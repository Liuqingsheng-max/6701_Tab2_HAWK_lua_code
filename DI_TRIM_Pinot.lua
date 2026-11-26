

DI_TRIM_CFG = {
	GLBC_LSB_UA    = 0.021,         -- 21 nA per GLBC code (starting point only)
	GLBC_MIN       = 0,
	GLBC_MAX       = 0x1FF,         -- 9-bit field
	N_PIXEL        = 1856 * 1472,   -- active pixels; must match VPG_SetActiveArea (full array)
	REFRESH_HZ     = 90,            -- must match 0xBD setting (FirstPicture: 0x10 = 90 Hz)
	DUTY_PCT       = 4.59,
	TOL_PCT        = 1.0,           -- pass band = +/- TOL_PCT % of target (Copley / PG use 1 %)
	SETTLE_MS      = 600,           -- after each GLBC write, before Average_current()
	PATTERN_MS     = 300,           -- after VPG pattern change
	MAX_MEAS       = 20,            -- hard limit on GLBC measurement points
	STEP_RATIO     = 1.25,          -- max bracket step; limits current overshoot to ~25 % above target
	MAX_AVEE_UA    = 500000,        -- 0.5 A, DS V0.61 Table 5.2 Panel Peak Current
	-- Row-to-row (R2R) time: row starts spread over the whole frame, same method as Pequin
	-- (UFlex TMG_RSYNC_CFG 14.44 us x 768 rows; PG Set_Duty_Cycle RSYNC_INT = frame / 768)
	PWM_CLOCK_HZ     = 100e6,       -- DS V0.61 §8.1 / §8.3: MiP & PWM (display) clock = 100 MHz
	PWM_ROWS         = 1472,        -- DS §8.8.5: PWM rolling runs over all 1472 rows
	PWM_START_OFFSET = 0x002A80,    -- E5h 1st-3rd P, same value program_duty_cycle() writes
}

DI_trim_code  = DI_trim_code or 0
DI_trim_valid = false             -- true only after a PASS; apply_DI_trim_code() checks it


-- F6h VDC GLBC: 3 parameters, then F4h panel update (same as set_glbc in DAC 2-point)
local function write_glbc(glbc_code)
	IIC_W_Tab2(0xF6, {0x00, (glbc_code >> 8) & 0x01, glbc_code & 0xFF})
	IIC_W_Tab2(0xF4, {0x01})
end

-- Read back F6h, return GLBC[8:0], or -1 if the read fails. LOG only: F6h is a write (W) command
-- in DS V0.61 Table 7.2, so the readback is not used for pass/fail (existing code only logs it).
-- pcall: a failed read must not stop the test, because the value is only logged.
local function read_glbc()
	local ok, glbc = pcall(function()
		local _, read_bytes = IIC_R_Tab2(0xF6, 3)
		return ((read_bytes[2] & 0x01) << 8) | (read_bytes[3] & 0xFF)
	end)
	return ok and glbc or -1
end


VREF_TRIM_CFG = {
	TARGET_V        = 0.65,         -- Pinot TP V0.7 "VREF Trim" / IGXL VREF_TrimTarget
	LIMIT_LO_V      = 0.637,        -- TP pass / fail
	LIMIT_HI_V      = 0.663,
	CODES           = 64,           -- VDC_VREF_TRIM[5:0]
	FIRST_SETTLE_MS = 1000,         -- after SMU2 on (as Bandgap_Trim)
	STEP_MS         = 300,          -- after each F8h write (as Bandgap_Trim)
}

VREF_trim_code_Pinot = VREF_trim_code_Pinot or -1   -- best VDC_VREF_TRIM from VREF_Trim_Pinot(), -1 = not trimmed
VREF_trim_volt_Pinot = VREF_trim_volt_Pinot or 0

local F8_VREF_DEFAULT  = 0x20       -- F8h 5th P default (DS, FirstPicture, DAC_Full_Range_Calibration)
local F8_PBIAS_DEFAULT = 0x100      -- F8h 14th/15th P default 01 00 = 256

-- F8h, 34 bytes: same values DAC_Full_Range_Calibration() writes, with VDC_VREF_TRIM (5th P) and
-- PBIAS_IPXL_TRIM (14th/15th P) from the caller. F8h is a write (W) command, so it is never read.
local function f8_buffer(vref_code, pbias_code)
	return {
		0x72, 0x10, 0x10, 0x10, vref_code & 0x10, 0x10, 0x10, 0x25, 0x0A, 0x0A,   --  1-10th P
		0x03, 0x11, 0x20,                                                         -- 11-13th P
		(pbias_code >> 8) & 0x01, pbias_code & 0xFF,                              -- 14-15th P PBIAS_IPXL_TRIM
		0x08, 0x08, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,                     -- 16-24th P
		0x20, 0x20, 0x20, 0x20, 0x88, 0x02, 0x00, 0x02, 0x00, 0x00,               -- 25-34th P
	}
end

local function make_vref_payload(vref_trim)
		return {
			0x72,    --1stP   OSC_FTRIM[7:0]
			0x10,    --2ndP   VDC_VDDPHY_TRIM[4:0]
			0x10,    --3rdP   VDC_VDDLP_TRIM[4:0]
			0x10,    --4thP   VDC_VDDPLL_TRIM[4:0]
			vref_trim & 0x3F, --5thP   VDC_VREF_TRIM[5:0]
			-- 6thP ~ 34thP are defaults
		}
end

local function calibrated_vref()
	if (VREF_trim_code_Pinot or -1) >= 0 then return VREF_trim_code_Pinot end
	return nil
end

local function calibrated_pbias()
	if (DAC_calibration_code or 0) > 0 then return DAC_calibration_code end
	return nil
end


---
-- Write the calibrated trims to F8h: VDC_VREF_TRIM from VREF_Trim_Pinot() and PBIAS_IPXL_TRIM
-- (DAC_calibration_code) from DAC_Full_Range_Calibration(). A value that has not been calibrated
-- is written with its default (VREF 0x20, PBIAS 256). If neither has been calibrated, F8h is not changed.
-- The original apply_DAC_calibration_code() is not used (and not changed): its DAC_cal_buf is
-- built when TEST_API.lua loads, while DAC_calibration_code is still 0.
-- @return 0 = written, 1 = nothing calibrated (F8h not changed)
-- @usage apply_calibrated_trims_Pinot()
function apply_calibrated_trims_Pinot()
	local vref, pbias = calibrated_vref(), calibrated_pbias()
	if vref == nil and pbias == nil then
		LOG.INFO("apply_calibrated_trims_Pinot: no VREF trim / DAC calibration result, F8h not changed")
		return 1
	end
	IIC_W_Tab2(0xF8, f8_buffer(vref or F8_VREF_DEFAULT, pbias or F8_PBIAS_DEFAULT))
	IIC_W_Tab2(0xF4, {0x01})
	LOG.INFO(string.format("apply_calibrated_trims_Pinot: VDC_VREF_TRIM = %s, PBIAS_IPXL_TRIM = %s",
		vref and tostring(vref) or "default 32", pbias and tostring(pbias) or "default 256"))
	return 0
end


---
-- VREF trim (Pinot TP V0.7 "VREF Trim", same method as Pinot IGXL VBT_TRIM_VREF_Test):
-- route VREF to AMON, sweep VDC_VREF_TRIM (F8h 5th P) 0 ~ 63, keep the code closest to 0.65 V.
-- AMON is measured on SMU2 with the same relay path and SMU setup as Bandgap_Trim() (TEST_API.lua).
-- The best code is saved in VREF_trim_code_Pinot and written to F8h at the end.
-- @return 0 = best voltage within 0.637 ~ 0.663 V, 1 = outside; json [best_code, best_volt_V]
-- @usage VREF_Trim_Pinot()
function VREF_Trim_Pinot()
	local tim1 = TIME.TICK()
	local cfg  = VREF_TRIM_CFG
	local pbias = calibrated_pbias() or F8_PBIAS_DEFAULT
	IIC_W_Tab2(0xf6, {0x00,0x01, 0x00})
	IIC_W_Tab2(0xFD, {0x80,0x00, 0x95})   -- ANALOGTEST: VDC_TMOD_EN, VREF on AMON (IGXL s25m11_otp_vref_0420)
	PPMU.CAL_EN(0)                          -- as Bandgap_Trim
	GPIO6_A_SET(1)                          -- AMON to SMU2 (as Bandgap_Trim / DAC_2point_calibration)
	GPIO3_A_SET(0)
	GPIO2_A_SET(1)
	IIC_W_Tab2(0xF8, {0x72, 0x10, 0x10, 0x10, 0x20, 0x10, 0x10, 0x25, 0x0A})
	
	IIC_W_Tab2(0xFD, {0x80, 0x00, 0x95})
	--IIC_W_Tab2(0xFD, {0x00, 0x02, 0x94})
	Power.ValueSetting.SMU2 = 0
	SMU2(ON, 1, 0x82)                       -- as Bandgap_Trim
	TIME.DELAY(cfg.FIRST_SETTLE_MS)

	local best_code, best_volt = -1, 0
	for code = 0, 1 do
	--for code = 0, cfg.CODES - 1 do
		--IIC_W_Tab2(0xF8, f8_buffer(code, pbias))
		IIC_W_Tab2(0xF8, make_vref_payload(code))
		TIME.DELAY(cfg.STEP_MS)
		local volt,current = POWER.VOL_CUR(P_SMU2)
		LOG.INFO(string.format("  VDC_VREF_TRIM = %2d  AMON = %.4fV", code, volt))
		if best_code < 0 or math.abs(volt - cfg.TARGET_V) < math.abs(best_volt - cfg.TARGET_V) then
			best_code, best_volt = code, volt
		end
	end

	PPMU.CAL_EN(1)                          -- restore, as Bandgap_Trim
	GPIO6_A_SET(1)
	GPIO3_A_SET(0)
	GPIO2_A_SET(1)
	TIME.DELAY(20)
	SMU2(OFF, 0)
	IIC_W_Tab2(0xFD, {0x00, 0x00, 0x00})   -- clear ANALOGTEST (as DAC_2point_calibration)

	IIC_W_Tab2(0xF8, f8_buffer(best_code, pbias))
	IIC_W_Tab2(0xF4, {0x01})
	VREF_trim_code_Pinot = best_code
	VREF_trim_volt_Pinot = best_volt

	local pass = (best_volt >= cfg.LIMIT_LO_V and best_volt <= cfg.LIMIT_HI_V)
	local tim2 = TIME.TICK()
	LOG.INFO(string.format("VREF_Trim_Pinot: %s  best VDC_VREF_TRIM = %d  AMON = %.4fV  time=%.3fs",
		pass and "PASS" or "FAIL", best_code, best_volt, tim2 / 1000 - tim1 / 1000))
	local json_data = cjson.encode({best_code, best_volt})
	LOG.INFO(json_data)
	return pass and 0 or 1, json_data
end

function VREF_Trim_Pinot_Binary_Search()
	local tim1  = TIME.TICK()
	local cfg   = VREF_TRIM_CFG

	IIC_W_Tab2(0xf6, {0x00,0x01, 0x00}) -- Reset because apply_DI_trim_code change the value
	----------------------------------------------------------------
	-- 1. AMON path (setup unchanged: FBh EVAL Setting + FDh ANALOGTEST + SMU2)
	----------------------------------------------------------------
	PPMU.CAL_EN(0) -- as Bandgap_Trim
	GPIO6_A_SET(1) -- AMON to SMU2 (as Bandgap_Trim / DAC_2point_calibration)
	GPIO3_A_SET(0)
	GPIO2_A_SET(1)
	IIC_W_Tab2(0xFB, { 0x07, 0x2C, 0xA5, 0x01, 0x03, 0x00, 0x00, 0x00, 0x00 })
	IIC_W_Tab2(0xFD, { 0x00, 0x02, 0x94 })
	--IIC_W_Tab2(0xFD, {0x80, 0x00, 0x95})
	
	Power.ValueSetting.SMU2 = 0
	SMU2(ON, 1, 0x82) -- MODE 1: force 0 A, measure AMON voltage
	-- pre-warm: write a known code and wait the full settle before the first measurement
	IIC_W_Tab2(0xF8, make_vref_payload(0))
	TIME.DELAY(1000)

	local best_code, best_volt = -1, 0

	-- single read per code, as the original Bandgap_Trim flow
	local function measure_vref(code)
		IIC_W_Tab2(0xF8, make_vref_payload(code))
		TIME.DELAY(400)
		local v = POWER.VOL_CUR(P_SMU2)
		LOG.INFO(string.format("  VDC_VREF_TRIM = %2d  AMON = %.4fV", code, v))
		return v
	end

	local function in_window(v)
		return v >= cfg.LIMIT_LO_V and v <= cfg.LIMIT_HI_V
	end

	-- [NEW] pass window first, distance to target second:
	--   new in window / old not      -> new wins
	--   old in window / new not      -> old stays
	--   both in window               -> closer to target wins
	--   neither in window            -> closer to target wins
	local function track_best(code, v)
		if best_code < 0 then
			best_code, best_volt = code, v
			return
		end
		local new_in, old_in = in_window(v), in_window(best_volt)
		if new_in ~= old_in then
			if new_in then best_code, best_volt = code, v end
			return
		end
		-- equal distance -> lower code wins, so the result does not depend on the order
		-- in which the codes happened to be measured
		local d_new = math.abs(v - cfg.TARGET_V)
		local d_old = math.abs(best_volt - cfg.TARGET_V)
		if d_new < d_old or (d_new == d_old and code < best_code) then
			best_code, best_volt = code, v
		end
	end


	----------------------------------------------------------------
	-- 2. Endpoints: monotonic direction (guides the search only, never the result)
	----------------------------------------------------------------
	local v_first = measure_vref(0); track_best(0, v_first)
	local v_last = measure_vref(cfg.CODES - 1); track_best(cfg.CODES - 1, v_last)
	local ascending = (v_first <= v_last)
	LOG.INFO(string.format("VREF_Trim_Pinot: %s  V(0)=%.4fV  V(%d)=%.4fV)",
		ascending and "ascending" or "descending", v_first, cfg.CODES - 1, v_last))
	if math.abs(v_last - v_first) < 1e-6 then
		LOG.ERROR("VREF_Trim_Pinot: endpoints nearly equal (VREF not monotonic?) — fallback linear sweep")
		for code = 1, cfg.CODES - 2 do track_best(code, measure_vref(code)) end
	else
		----------------------------------------------------------------
		-- 3. lower_bound binary search down to the crossover code
		----------------------------------------------------------------
		local lo, hi = 0, cfg.CODES - 1
		while lo < hi do
			local mid = math.floor((lo + hi) / 2)
			local v_mid = measure_vref(mid)
			track_best(mid, v_mid)
			if ascending then
				if v_mid < cfg.TARGET_V then lo = mid + 1 else hi = mid end
			else
				if v_mid < cfg.TARGET_V then hi = mid else lo = mid + 1 end
			end
		end
		track_best(lo, measure_vref(lo)) -- crossover 點本身也要量測

	end



	-- ===== Teardown (unchanged) =====
	PPMU.CAL_EN(1) -- restore, as Bandgap_Trim
	GPIO6_A_SET(1)
	GPIO3_A_SET(0)
	GPIO2_A_SET(1)
	TIME.DELAY(20)
	SMU2(OFF, 0)
	--IIC_W_Tab2(0xFD, { 0x00, 0x00, 0x00 })                                        -- clear ANALOGTEST (as DAC_2point_calibration)
	--IIC_W_Tab2(0xFB, { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }) -- clear EVAL Setting

	IIC_W_Tab2(0xF8, make_vref_payload(best_code))
	IIC_W_Tab2(0xF4, { 0x01 })
	VREF_trim_code_Pinot = best_code
	VREF_trim_volt_Pinot = best_volt

	local pass = (best_volt >= cfg.LIMIT_LO_V and best_volt <= cfg.LIMIT_HI_V)
	local tim2 = TIME.TICK()
	LOG.DEBUG(string.format("VREF_Trim_Pinot: %s  best VDC_VREF_TRIM = %d  AMON = %.4fV  time=%.3fs",
		pass and "PASS" or "FAIL", best_code, best_volt, tim2 / 1000 - tim1 / 1000))
	local json_data = cjson.encode({ best_code, best_volt })
	LOG.INFO(json_data)
	return pass and 0 or 1, json_data
end

function DI_TRIM_Reg_SET()
	LOG.DEBUG(string.format("Setting register [0xf6 to 0x64],[0xe3 to 0],[0xf4 to 1]"))
	IIC_W_Tab2(0xf6,{0x0,0x0,0x64})
	IIC_W_Tab2(0xe3,{0x0})
	IIC_W_Tab2(0xf4,{0x1})
end

-- DI_TRIM_Pinot("Blue")
function DI_TRIM_Pinot(color)
	local time1 = TIME.TICK()

	local result_table = {}
	IIC_R_Tab2(0xe3,1)
	TIME.DELAY(20)
	IIC_W_Tab2(0xe3,{0x1})  -- Content Monitor Off
	TIME.DELAY(20)
	local colorParam = Set_Device_Condition_By_Color(color)
	TIME.DELAY(20)
	VPG_SetFlatField(0)  --display on first picture  flat field
	TIME.DELAY(1300)
	local alloff_current_raw_uA = Average_current() / 1000   -- signed, as Pequin alloff_CURRENT
	local Min_current_uA       = math.abs(alloff_current_raw_uA)
	LOG.INFO(string.format("Min current (all-off) = %.3fuA", Min_current_uA))
	
	IIC_R_Tab2(0xe3,1)
	TIME.DELAY(20)
	IIC_W_Tab2(0xe3,{0x1})  -- Content Monitor Off
	local initial_glbc = read_glbc()
	
	TIME.DELAY(20)
	VPG_SetFlatField(255)  --display on first picture  flat field
	TIME.DELAY(800)
	local Max_current_uA  = 0
	local target = colorParam[color]["pixel_uA"]
	--local iter = 1
	local max_loop = 10
	local delta = colorParam[color]["target_delta"]
	local Pix_I = 0
	local glbc_percent = 0
	local relative_table = {}
	local converge_flag = 0
	local retry_cnt = 0
	local retry_max = 1
	 
	while retry_cnt <= retry_max do
	
		local iter = 1
		relative_table = {}
		while iter <= max_loop do
			--TIME.DELAY(800)
			--TIME.DELAY(400)
			local allon_current_raw_uA = Average_current()  /1000    -- signed, as Pequin alloff_CURRENT
			Max_current_uA       = math.abs(allon_current_raw_uA)
			LOG.INFO(string.format("Max current (all-on) = %.3fuA", Max_current_uA))
			
			local max_min = Max_current_uA - Min_current_uA
			LOG.INFO(string.format("max-min=== %.3fuA", max_min))
			
			Pix_I = (max_min ) / (2732032 * (4.59/100))
			local relative = math.abs((Pix_I - target)) / target
			
			table.insert(relative_table, relative)
			LOG.INFO(string.format("---no relative continue %.4f,iter=%d",relative,iter))
			if relative < delta then
				LOG.DEBUG(string.format("relative %.4f",relative))
				converge_flag = 1
				break
			end
			--LOG.INFO(string.format("---no relative continue %.4f,iter=%d",relative,iter))	
			--(Max_value - Min_value)/(2917632 or 2732032 * 4.59/100) = Pxl I
			LOG.INFO(string.format("Pix_I = %.3f", Pix_I))
			local glbc_readback = read_glbc()
			local glbc =( target * 1000 /21) - (Pix_I * 1000 / 21)  -- change 95 to value of 0xf6
			LOG.INFO(string.format("glbc = %.3f", glbc))
			glbc_percent = (glbc / glbc_readback) * 100
			
			local final_glbc = math.floor((glbc_readback + glbc))
			
			IIC_W_Tab2(0xf6,{0x0,(final_glbc >> 8) & 0xff,final_glbc & 0xff})
			
			iter = iter + 1
		end
		
		if converge_flag == 1 then
		LOG.DEBUG(string.format("retry_cnt %.4f",retry_cnt))
			break
		end
		retry_cnt = retry_cnt + 1
		LOG.DEBUG(string.format("first 10 loop not converge, start retry loop %d", retry_cnt))
	end
	
	local final_glbc = read_glbc()
	
	--IIC_W_Tab2(0xf6,{0x0,(final_glbc >> 8) & 0xff,final_glbc & 0xff})
	local time2 = TIME.TICK()
	local total_time = time2 / 1000 - time1 /1000
	LOG.INFO("Di_Trim time: " .. string.format("%.3f", total_time ) .. "seconds")
	if converge_flag == 0 then
	  	LOG.INFO("max times err ")
	  	table.insert(result_table, -9999)
		table.insert(result_table, -9999)
		if #relative_table > 0 then
			table.sort(relative_table)
			min_relative = relative_table[1]
		end
		
		LOG.DEBUG(string.format("Return min_ralative = %.4f", min_relative))
		table.insert(result_table, min_relative)
		local json_data = cjson.encode(result_table)
		LOG.INFO(json_data)
		return 1,json_data
	 end
	 

	
	local max_min = Max_current_uA - Min_current_uA
	LOG.INFO(string.format("max-min=== %.3fuA", max_min))

	local glbc_percent = (final_glbc - initial_glbc ) / initial_glbc * 100

	--LOG.INFO(string.format("glbc_percent = %.3f", glbc_percent))
	table.insert(result_table, Pix_I)
	table.insert(result_table, glbc_percent)
	local json_data = cjson.encode(result_table)
	LOG.INFO(json_data)
	return 0,json_data

end


-- Re-apply stored DI trim code to F6h (overrides TEST_API.lua version, which wrote 0xDC).
-- @usage apply_DI_trim_code()
function apply_DI_trim_code()
	println("apply_DI_trim_code")
	if not DI_trim_valid then
		LOG.ERROR(string.format("apply_DI_trim_code: no valid DI trim, GLBC not changed (DI_trim_code=0x%X)", DI_trim_code))
		return 1
	end
	write_glbc(DI_trim_code)
	LOG.DEBUG(string.format("Apply DI_trim_code:0x%03X (F6h readback %d, log only)", DI_trim_code, read_glbc()))
	return 0
end
