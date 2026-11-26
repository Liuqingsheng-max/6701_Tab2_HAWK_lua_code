function VREF_Trim_Pinot()
	local tim1 = TIME.TICK()
	local cfg  = VREF_TRIM_CFG
	local pbias = calibrated_pbias() or F8_PBIAS_DEFAULT

	IIC_W_Tab2(0xFD, {0x80, 0x00, 0x95})   -- ANALOGTEST: VDC_TMOD_EN, VREF on AMON (IGXL s25m11_otp_vref_0420)
	PPMU.CAL_EN(0)                          -- as Bandgap_Trim
	GPIO6_A_SET(1)                          -- AMON to SMU2 (as Bandgap_Trim / DAC_2point_calibration)
	GPIO3_A_SET(0)
	GPIO2_A_SET(1)
	Power.ValueSetting.SMU2 = 0
	SMU2(ON, 1, 0x82)                       -- as Bandgap_Trim
	TIME.DELAY(cfg.FIRST_SETTLE_MS)

	local best_code, best_volt = -1, 0
	local best_diff = math.huge
	local low, high = 0, cfg.CODES - 1

	-- Helper function to write, measure, and update the best result
	local function measure_and_update(code)
		IIC_W_Tab2(0xF8, f8_buffer(code, pbias))
		TIME.DELAY(cfg.STEP_MS)
		local volt = POWER.VOL_CUR(P_SMU2)
		LOG.INFO(string.format("  VDC_VREF_TRIM = %2d  AMON = %.4fV", code, volt))
		
		local diff = math.abs(volt - cfg.TARGET_V)
		if diff < best_diff then
			best_code, best_volt = code, volt
			best_diff = diff
		end
		return volt
	end

	-- 1. Binary Search
	while low <= high do
		local mid = math.floor((low + high) / 2)
		local volt = measure_and_update(mid)

		-- Early exit: If we are extremely close to the target (e.g., within 0.5mV), stop searching.
		if best_diff <= 0.0005 then
			break
		end

		if volt < cfg.TARGET_V then
			low = mid + 1  -- Target is higher, search upper half
		else
			high = mid - 1 -- Target is lower, search lower half
		end
	end

	-- 2. Neighbor Verification (Optional but recommended)
	-- Because of measurement noise or slight non-linearity, the exact best point might be right next to our binary search result.
	if best_code >= 0 then
		if best_code > 0 then measure_and_update(best_code - 1) end
		if best_code < cfg.CODES - 1 then measure_and_update(best_code + 1) end
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