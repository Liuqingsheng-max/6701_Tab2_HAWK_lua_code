DAC_calibration_code = 0
per_step_uA = 21
bit8 = (DAC_calibration_code >> 8) & 0x01
byte_low = DAC_calibration_code & 0xFF



DAC_cal_buf = {
	0x72,  --1stP
	0x10,  --2ndP
	0x10,  --3rdP
	0x10,  --4thP
	0x20,  --5thP
	0x10,  --6thP
	0x10,  --7thP
	0x25,  --8thP
	0x0A,  --9thP
	0x0A,  --10thP
	0x03,  --11thP
	0x11,  --12thP
	0x20,  --13thP
	bit8,  --14thP  PBIAS_IPXL_TRIM[8]
	byte_low, --15thP  PBIAS_IPXL_TRIM[7:0]
	0x08,  --16thP
	0x08,  --17thP
	0x10,  --18thP
	0x00,  --19thP
	0x00,  --20thP
	0x00,  --21thP
	0x00,  --22thP
	0x00,  --23thP
	0x00,  --24thP
	0x20,  --25thP
	0x20,  --26thP
	0x20,  --27thP
	0x20,  --28thP
	0x88,  --29thP
	0x02,  --30thP
	0x00,  --31thP
	0x02,  --32thP
	0x00,  --33thp
	0x00   --34thp
}

Temperature_TRIM_buf = {
	0x72,       --1stP
	0x10,       --2ndP
	0x10,       --3rdP
	0x10,       --4thP
	0x20,       --5thP
	0x10,       --6thP
	0x10,       --7thP
	0x25,       --8thP
	0x0A,       --9thP
	0x0A,       --10thP
	0x03,       --11thP
	0x11,       --12thP
	0x20,       --13thP
	0x01,       --14thP  PBIAS_IPXL_TRIM[8]
	0x00,       --15thP  PBIAS_IPXL_TRIM[7:0]
	0x08,       --16thP
	0x08,       --17thP
	0x10,       --18thP
	0x00,       --19thP
	0x00,       --20thP
	0x00,       --21thP
	0x00,       --22thP
	0x00,       --23thP
	0x00,       --24thP
	0x20,       --25thP
	0x20,       --26thP
	0x20,       --27thP
	0x20,       --28thP
	0x88,       --29thP
	TSL_TRIM_High, --30thP TSL_TRIM_TARGET[9:8]
	TSL_TRIM_Low, --31thP	TSL_TRIM_TARGET[7:0]
	TSR_TRIM_High, --32thP TSR_TRIM_TARGET[9:8]
	TSR_TRIM_Low, --33thp  TSR_TRIM_TARGET[7:0]
	0x00        --34thp
}


function Set_TEST_MODE(Test_Mode)
	if Test_Mode == "MT" or Test_Mode == "CP2" then
		TEST_MODE = Test_Mode
		LOG.DEBUG("Test Mode:" .. Test_Mode)
	else
		TEST_MODE = "MT"
		LOG.DEBUG("Test Mode:" .. Test_Mode)
	end

	RestInit()
	Set_IO_TEST_MODE()
end

--VQPS(ON)
--[[
Function: Power_Shorts_Test
Desc: Pinot power pin short test using PPMU. Apply low voltage and clamp current to detect short circuit.
Input:
    Volt    : Test voltage(mV). Nil for default parallel mode.
    delay   : Stabilize delay(ms). Nil for default parallel mode.
    pinlist : Channel list table. Nil for default parallel mode.
Return:
    0       : Function execute status, 0 = success
    Power_name : Json string of power rail names
    voltage    : Json string of measured voltage array
    current    : Json string of measured current array(mA)
--]]
function Power_Shorts_Test(Volt, delay, pinlist)
	-- 1. Set all IO to 0V.
	-- 2. Set all positive power supply pins to 0.1V, AVEE to –0.1V and all clamp to 10mA
	local result_table = {}
	local Power_name = {}
	local voltage = {}
	local current = {}

	if Volt == nil or delay == nil or pinlist == nil then
		local VOLTAGE_VALUE = 100        --mV
		local VOLTAGE_CLAMP = 200        --mV
		local CURRENT_CLAMP = 20 * 1000 * 1000 --nA
		local UNDER_VOLTAGE_PROTECTIVE = 0 --mV
		local UNDER_CURRENT_PROTECTIVE = 0 --mV
		--local result_table ={}
		local VQPS_DATA_VOLTAGE = 0.0
		local VDD10_DATA_VOLTAGE = 0.0
		local VDD18_DATA_VOLTAGE = 0.0
		local AVEE_DATA_VOLTAGE = 0.0
		local AVDD18_DATA_VOLTAGE = 0.0 --20251222 add

		local VQPS_DATA_CURRENT = 0.0
		local VDD10_DATA_CURRENT = 0.0
		local VDD18_DATA_CURRENT = 0.0
		local AVEE_DATA_CURRENT = 0.0
		local AVDD18_DATA_CURRENT = 0.0 --20251222 add

		PPMU_IO_ALL_MODE(PPMU_MODE_TABLE.NC)
		--PPMU.RELAY_CLOSE(CHANNEL_TAB.GPIO6_A)
		--PPMU.RELAY_CLOSE(CHANNEL_TAB.GPIO7_A)

		PPMU.RELAY_CLOSE(CHANNEL_TAB.VQPS_OUT)
		PPMU.RELAY_CLOSE(CHANNEL_TAB.VDDIO_OUT)
		PPMU.RELAY_CLOSE(CHANNEL_TAB.DVDD_OUT)
		PPMU.RELAY_CLOSE(CHANNEL_TAB.AVEE1_OUT)

		PPMU.RELAY_CLOSE(CHANNEL_TAB.AVDD_OUT)
		POWER.MULTI_SET(
			{ channel = P_VQPS, en = 1, range = 0x85, mode = 0, vol = 200, ovp = 300, uvp = 0, ocp = 200 * 1000 * 100, ucp = 0 },
			{ channel = P_VDD18, en = 1, range = 0x85, mode = 0, vol = 150, ovp = 250, uvp = 0, ocp = 200 * 1000 * 80, ucp = 0 },
			{ channel = P_VDD10, en = 1, range = 0x85, mode = 0, vol = 100, ovp = 650, uvp = 0, ocp = 200 * 1000 * 80, ucp = 0 },
			{ channel = P_AVDD18, en = 1, range = 0x85, mode = 0, vol = 100, ovp = 250, uvp = 0, ocp = 200 * 1000 * 80, ucp = 0 },
			{ channel = P_AVEE, en = 1, range = 0x85, mode = 0, vol = -100, ovp = 200, uvp = 0, ocp = 200 * 1000 * 80, ucp = 0 }
		)


		TIME.DELAY(300)
		--3. Measure & Report current at VDD10,VDD18,AVEE,VQPS
		VQPS_DATA_VOLTAGE, VQPS_DATA_CURRENT     = POWER.VOL_CUR(P_VQPS)
		VDD18_DATA_VOLTAGE, VDD18_DATA_CURRENT   = POWER.VOL_CUR(P_VDD18)
		VDD10_DATA_VOLTAGE, VDD10_DATA_CURRENT   = POWER.VOL_CUR(P_VDD10)
		AVDD18_DATA_VOLTAGE, AVDD18_DATA_CURRENT = POWER.VOL_CUR(P_AVDD18) --20251222add
		AVEE_DATA_VOLTAGE, AVEE_DATA_CURRENT     = POWER.VOL_CUR(P_AVEE)

		VQPS_DATA_CURRENT                        = VQPS_DATA_CURRENT / 1e6
		VDD10_DATA_CURRENT                       = VDD10_DATA_CURRENT / 1e6
		VDD18_DATA_CURRENT                       = VDD18_DATA_CURRENT / 1e6
		AVEE_DATA_CURRENT                        = AVEE_DATA_CURRENT / 1e6
		AVDD18_DATA_CURRENT                      = AVDD18_DATA_CURRENT / 1e6 --20251222add

		POWER_OFF()

		LOG.INFO(string.format("VQPS_DATA :%.4fV, %.4fmA", VQPS_DATA_VOLTAGE, VQPS_DATA_CURRENT))
		LOG.INFO(string.format("VDD18_DATA:%.4fV, %.4fmA", VDD18_DATA_VOLTAGE, VDD18_DATA_CURRENT))
		LOG.INFO(string.format("VDD10_DATA:%.4fV, %.4fmA", VDD10_DATA_VOLTAGE, VDD10_DATA_CURRENT))
		LOG.INFO(string.format("AVEE_DATA :%.4fV, %.4fmA", AVEE_DATA_VOLTAGE, AVEE_DATA_CURRENT))
		LOG.INFO(string.format("AVDD18_DATA :%.4fV, %.4fmA", AVDD18_DATA_VOLTAGE, AVDD18_DATA_CURRENT)) --20251222add

		table.insert(result_table, VQPS_DATA_CURRENT)
		table.insert(result_table, VDD10_DATA_CURRENT)
		table.insert(result_table, VDD18_DATA_CURRENT)
		table.insert(result_table, AVEE_DATA_CURRENT)
		table.insert(result_table, AVDD18_DATA_CURRENT) --20251222add

		Power_name = cjson.encode({ "VPQS", "VDD18", "VDD10", "AVEE", "AVDD18" })
		LOG.INFO(Power_name)
		voltage = cjson.encode({ VQPS_DATA_VOLTAGE, VDD18_DATA_VOLTAGE, VDD10_DATA_VOLTAGE, AVEE_DATA_VOLTAGE,
			AVDD18_DATA_VOLTAGE })
		LOG.INFO(voltage)
		current = cjson.encode({ VQPS_DATA_CURRENT, VDD18_DATA_CURRENT, VDD10_DATA_CURRENT, AVEE_DATA_CURRENT,
			AVDD18_DATA_CURRENT })
		LOG.INFO(current)
	else
		local VOLTAGE_VALUE = Volt
		local delaytime = delay
		--local power_pchannel = pinlist
		local VOLTAGE_CLAMP = 200        --mV
		local CURRENT_CLAMP = 20 * 1000 * 1000 --nA
		local DATA_VOLTAGE = 0.0
		local DATA_CURRENT = 0.0
		for k, v in pairs(pinlist) do
			POWER_CHANNEL_VALUE(v, ON, VOLTAGE_VALUE, VOLTAGE_CLAMP, CURRENT_CLAMP)
			TIME.DELAY(delaytime)

			DATA_VOLTAGE, DATA_CURRENT = POWER.VOL_CUR(v)
			DATA_CURRENT               = DATA_CURRENT / 1e6
			LOG.INFO(string.format("CHANNLE:%d,VQPS_DATA :%.4fV, %.4fmA", v, DATA_VOLTAGE, DATA_CURRENT))
			table.insert(result_table, DATA_CURRENT)

			POWER_CHANNEL_VALUE(v, OFF, VOLTAGE_VALUE, VOLTAGE_CLAMP, CURRENT_CLAMP)
		end
	end

	--local json_data = cjson.encode(result_table)
	--LOG.INFO(json_data)
	return 0, Power_name, voltage, current
end

--[[
Function: IO_Continuity_Test
Desc: Pinot IO continuity test by PPMU. Force +/- current and measure voltage to check open/short.
Input:
    current : Test current(uA). Nil for default full pin test.
    delay   : Stabilize delay(ms). Nil for default full pin test.
    pinlist : Target pin channel. Nil for default full pin test.
Return:
    0       : Success
    pin_table: Json of pin name list
    current_table: Json of forced current list
    voltage_table: Json of measured voltage list
    Return 1 if NG found(OPEN/CLOSE/NG keyword in voltage result)
--]]
function IO_Continuity_Test(current, delay, pinlist)
	--Test Sequence
	--1. Set all power rail to 0V
	--2. Set all IO pin to GND.
	--3. For IO Pin (GPIO,TPAD,I2C, Reset, refclk):
	--a. Connect one pin to PMU, Force 200uA, clamp 1.5V report voltage. Exp pass range(0.2~1.1V)
	--b. Force –200uA, CLAMP -1.5v, report voltage. Exp pass range(-0.2~-1.1V)
	--c. Connect this pin back to GND
	local result_table = {}
	local result_table1 = {}
	local pin_table = {}
	local voltage_table = {}
	local current_table = {}
	
	POWER_OFF()

	TIME.DELAY(100)
	if current == nil or delay == nil or pinlist == nil then
		local curent = { -200, 200 }

		pin_table, current_table, voltage_table = PPMU_IO_CHANNEL_TEST(curent, delay)
	else
		--local curent = -100
		local ioname = ""
		for k, v in pairs(IO_PPMU_CHANEL_negative) do
			if pinlist == v.PinNo then
				ioname = v.PinName
			end
			--LOG.INFO(string.format("no:%d",k))	
		end

		result_table1 = PPMU_IO_CHANNEL_TEST_Customize(b, pinlist, ioname, delay)
		table.insert(result_table, result_table1)
	end

	pin_table = cjson.encode(pin_table)
	LOG.INFO(pin_table)
	current_table = cjson.encode(current_table)
	LOG.INFO(current_table)
	voltage_table = cjson.encode(voltage_table)
	LOG.INFO(voltage_table)

	if voltage_table:find("OPEN") or voltage_table:find("CLOSE") or voltage_table:find("NG") then
		LOG.ERROR("PPMU_IO_TEST NG")
		return 1, voltage_table
	end
	return 0, pin_table, current_table, voltage_table
end

function DMIPI_R_A(reg, len)
	local DATA = DMIPI.REG_R(reg, len)
	for i = 1, len, 1 do
		LOG.INFO(string.format("data[%d]0x%02x", i, DATA[i]))
	end
	return DATA
end

--GPIO3_A_SET(0)
function MIPI_DPHY_LP_Test()
	LOG.DEBUG("<MIPI_DPHY_LP_Test>")
	local data_table = {}
	local ret = 0
	local test_data = {
		0xAAAAAAAA,
		0x55555555,
		0x5A5A5A5A,
		0xA5A5A5A5,
		0x00000000
	}

	--PPMU.CAL_EN(1)
	--PPMU.CAL_EN(0)    --5V on
	--DMIPI.VID()
	--DMIPI.CMD()
	DMIPI.LP()
	--DMIPI.HS()
	--TIME.DELAY(1000)
	for k, v in ipairs(test_data) do
		F_MIPI_WRITE(0xEF, v)
		TIME.DELAY(50)
		
		local read_data = IIC_R_Tab2(0xEF, 4)
		--local read_data = DMIPI_R_A(0xEF, 4)
		--TIME.DELAY(50)
		--local read_data = F_READ_FOR_MIPI(0xEF, 4)
		local hex_str = string.format("0x%08X", read_data)
		println(hex_str)
		table.insert(data_table, hex_str)
		if v ~= read_data then
			LOG.ERROR("IIC read NG")
			ret = -1
		end
	end

	--data_table = 0xAAAAAAAA
	--hex_str = string.format("0x%08X",data_table)
	local json_data = cjson.encode(data_table)
	--LOG.INFO(json_data)
	--local json_data = cjson.encode(data_table)

	LOG.INFO(json_data)
	return ret, json_data
end

function toBinary_crc(n, min_len)
	min_len = min_len or 1
	if n == 0 then
		return string.rep("0", min_len)
	end
	local bin = ""
	while n > 0 do
		bin = (n % 2) .. bin
		n = math.floor(n / 2)
	end
	-- 强制补齐前导0，保证位数不丢
	if #bin < min_len then
		bin = string.rep("0", min_len - #bin) .. bin
	end
	return bin
end

--[[
Function: I2C_Communication_Test
Desc: I2C communication read/write test. Write pattern data to register 0x00EF then readback to verify.
Input: None
Return:
    ret        : 0 = test complete
    json_data  : Json string of readback data
--]]
function I2C_Communication_Test()
	LOG.DEBUG("<I2CCommunication_Test>")
	local data_table = {}
	local ret = 0
	local test_data = {
		0xAAAAAAAA,
		0x55555555,
		0x5A5A5A5A,
		0xA5A5A5A5,
		0x00000000
	}
	local original_slave_addr = IIC_CONFIG.SLAVE_ADDR

	for i = 1, #IIC_SLAVE_ADDR_TAB do
		IIC_CONFIG.SLAVE_ADDR = IIC_SLAVE_ADDR_TAB[i]
		I3C_CONFIG.SLAVE_ADDR = IIC_SLAVE_ADDR_TAB[i]
		IIC_CONFIG.init_default()
		data_table = {}
		LOG.DEBUG(string.format("0x%X", IIC_CONFIG.SLAVE_ADDR))
		local pass = true
		for k, v in ipairs(test_data) do
			IIC_W_Tab2(0x00EF, v)
			local read_data = IIC_R_Tab2(0xEF, 4)
			local hex_str = string.format("0x%08X", read_data)
			println(hex_str)
			table.insert(data_table, hex_str)

			if v ~= read_data then
				LOG.ERROR("IIC read NG")
				pass = false
				break
			end
		end

		if pass then
			break
		else
			data_table = { 0X0, 0X0, 0X0, 0X0 }
		end
	end

	IIC_CONFIG.SLAVE_ADDR = original_slave_addr
	LOG.INFO(string.format("0x%08X", IIC_CONFIG.SLAVE_ADDR))
	local json_data = cjson.encode(data_table)
	LOG.INFO(json_data)
	return ret, json_data
end


--I3C_Communication_Test()
function I3C_Communication_Test()
	LOG.DEBUG("<I3CCommunication_Test>")

	local ret = 0
	local data_table = {}
	local test_data = {
		0xAAAAAAAA,
		0x55555555,
		0x5A5A5A5A,
		0xA5A5A5A5,
		0x00000000
	}

	I3C_INIT()

	TIME.DELAY(200)
	for k, v in ipairs(test_data) do
		I3C_W_Tab2(0xEF, v)
		--TIME.DELAY(10)
		local read_data = I3C_R_Tab2(0xEf, 4)
		local hex_str = string.format("0x%08X", read_data)
		println(hex_str)
		table.insert(data_table, hex_str)
		if v ~= read_data then
			LOG.ERROR("I3C read NG")
			ret = -1
		end
	end

	--IIC_CONFIG.init_default()

	local json_data = cjson.encode(data_table)
	LOG.INFO(json_data)
	return ret, json_data
end

file_id=ChannelID+100
function F_Save_CSV(channel_id, target_res)
     local Y = os.date("%Y")
    local MON = os.date("%m", os.time())
    local D = os.date("%d", os.time())
    local timestamp = os.date("%H%M%S")
    local file_type = "csv"
    local file_name = string.format("C:\\AVEE_CURRENT\\%s\\%s\\%s\\CH%s\\ohm_%s_%s_smuCV.csv", Y, MON, D, channel_id, target_res,timestamp)
    local head_Str = "target_ohm,SMU_V(V),SMU_C(uA)\n"
    LOG.CREAT_FILE(file_id..","..file_type..","..file_name..","..head_Str)
    LOG.INFO("CSV文件已创建："..file_name)
end

function Update_CSV(data)
    LOG.WRITE_FILE(string.format("%s,%s", file_id, data))
end


--AVEE_current(12000,3)
function AVEE_current(sum,channel)
	local data_table = {}
	local csv_data_table = {}
	local data = 0
	for i = 1, sum, 1 do
		TIME.DELAY(5)
		local VOLTAGE, CURRENT = POWER.VOL_CUR(channel)
		local current_uA = CURRENT / 1000.0
		--LOG.INFO(string.format("CURRENT %.3fnA", CURRENT))
		--pixel_current=((math.abs(CURRENT)/1000)-(math.abs(darkcurrent)/1000))/(768*576*DutyCycle)
		table.insert(csv_data_table, {i,current_uA})
	end
	
	F_Save_CSV(channel, 1120)
	
	for i =1, #csv_data_table do
		local row = csv_data_table[i]
		Update_CSV(row[1]..",")
		Update_CSV(row[2].."\n")
	end
	--table.sort(data_table)
	--table.remove(data_table, 1)
	--table.remove(data_table, #data_table)
	----LOG.INFO(#data_table)
	--for i = 1, #data_table, 1 do
		--data = data + data_table[i]
	--end
	----LOG.INFO(#data_table)
	--data = data / #data_table
	--LOG.INFO(string.format("CURRENT %.3fmA", data/1000000))
	return 1
end

function Average_current()
	local data_table = {}
	local data = 0
	for i = 1, 400, 1 do
		TIME.DELAY(5)
		local VOLTAGE, CURRENT = POWER.VOL_CUR(6)
		--LOG.INFO(string.format("CURRENT %.3fnA", CURRENT))
		--pixel_current=((math.abs(CURRENT)/1000)-(math.abs(darkcurrent)/1000))/(768*576*DutyCycle)
		table.insert(data_table, CURRENT)
	end
	table.sort(data_table)
	table.remove(data_table, 1)
	table.remove(data_table, #data_table)
	--LOG.INFO(#data_table)
	for i = 1, #data_table, 1 do
		data = data + data_table[i]
	end
	--LOG.INFO(#data_table)
	data = data / #data_table
	LOG.INFO(string.format("CURRENT %.3fmA", data/1000000))
	return data
end

--function Average_current()
    --local data_table = {}
    --local n = 120
    --for i = 1, n, 1 do
        --TIME.DELAY(5)
        --local VOLTAGE, CURRENT = POWER.VOL_CUR(6)
        ----LOG.INFO(string.format("CURRENT %.3fnA", CURRENT))
        --table.insert(data_table, CURRENT)
    --end
    --table.sort(data_table)
    ---- median: middle value, or mean of the two middle values when n is even
    --local data
    --if n % 2 == 0 then
        --data = (data_table[n // 2] + data_table[n // 2 + 1]) / 2
    --else
        --data = data_table[(n + 1) // 2]
    --end
        --LOG.INFO(string.format("CURRENT %.3fmA", data / 1000000))
        --return data
--end

--function Average_current()
	--local data_table = {}
	--local data = 0
	--for i = 1, 400, 1 do
		--TIME.DELAY(4)
		--local VOLTAGE, CURRENT = POWER.VOL_CUR(6)
		----pixel_current=((math.abs(CURRENT)/1000)-(math.abs(darkcurrent)/1000))/(768*576*DutyCycle)
		----table.insert(data_table, CURRENT)
		--data_table[i] = CURRENT
	--end
	--table.sort(data_table)
	
	--local trim_count = math.floor(400 * 0.05)
	--local valid_count = 400 - 2*trim_count
	--local sum = 0
	
	--for i = trim_count + 1, 400 - trim_count, 1 do
		--sum = sum + data_table[i]
	--end

	--local average = sum / valid_count
	--return average
--end

--[[
Function: Power_Measurement
Desc: Single power rail voltage & current sampling. Remove max/min then calculate average.
Input:
    channel_name : Power rail name, support SMU1/SMU2/VQPS/VDDIO/DVDD/AVDD/AVEE1
Return:
    0           : Success; -1: invalid channel
    result_table: Json string of [avg_voltage, avg_current(mA)]
--]]
--Power_Measurement("AVEE1",300)
--Power_Measurement("AVEE1")
function Power_Measurement(channel_name, samples)
	local result_table = {}
	local average_current_table = {}
	local average_voltage_table = {}
	local average_current = 0
	local average_voltage = 0
	local POWER_DATA_VOLTAGE = 0.0
	local POWER_DATA_CURRENT = 0.0
	--local samples = 4000
	if samples == nil then
		samples = 40
	end
	local channel_map = {
		["SMU1"]  = 0,
		["SMU2"]  = 1,
		["VQPS"]  = 2,
		["VDDIO"] = 3,
		["DVDD"]  = 4,
		["AVDD"]  = 5,
		["AVEE1"] = 6
	}

	local ch_num = channel_map[channel_name]
	if ch_num == nil then
		LOG.ERROR(string.format("ERROR: invalid channel name [%s]", tostring(channel_name)))
		table.insert(result_table, -9999)
		table.insert(result_table, -9999)
		local json_data_err = cjson.encode(result_table)
		LOG.INFO(json_data_err)
		return 0, json_data_err
	end
	--TIME.DELAY(1000)
	for i = 1, samples do
		TIME.DELAY(5)
		VOLTAGE, CURRENT = POWER.VOL_CUR(ch_num)
		table.insert(average_current_table, CURRENT)
		table.insert(average_voltage_table, VOLTAGE)
		LOG.INFO(string.format("[%d]：%.15fA, %15fV", i, CURRENT, VOLTAGE))
	end
	table.sort(average_current_table)
	table.sort(average_voltage_table)
	table.remove(average_current_table, 1)
	table.remove(average_voltage_table, 1)
	table.remove(average_current_table, #average_current_table)
	table.remove(average_voltage_table, #average_voltage_table)
	for _, val in ipairs(average_current_table) do
		average_current = average_current + val
	end
	for _, val in ipairs(average_voltage_table) do
		average_voltage = average_voltage + val
	end
	average_current = average_current / #average_current_table
	average_voltage = average_voltage / #average_voltage_table
	LOG.INFO(string.format("%.3fA, %.3fV", average_current, average_voltage))

	POWER_DATA_VOLTAGE = average_voltage
	POWER_DATA_CURRENT = average_current / 1e6

	LOG.INFO(string.format("AVEE_DATA :%.4fV, %.4fmA", POWER_DATA_VOLTAGE, POWER_DATA_CURRENT))
	table.insert(result_table, POWER_DATA_VOLTAGE)
	table.insert(result_table, POWER_DATA_CURRENT)

	result_table = cjson.encode(result_table)
	LOG.INFO(result_table)

	return 0, result_table
end

--[[
	Function: bist_mode_swich_EN
	Desc:Set VPG Pattern
	Input:number en
--]]

--bist_mode_swich_EN(7,1)
function bist_mode_swich_EN(num, en)
	local run = 1
	if num == 1 then
		VPG_SetFlatField(255)
	elseif num == 2 then
		VPG_SetFlatField(0)
	elseif num == 3 then
		VPG_SetCheckerboard(255, 16, 16)
	elseif num == 5 then
		VPG_SetCheckerboard(255, 32, 32)
	elseif num == 7 then
		VPG_SetCheckerboard(255, 64, 64)
	elseif num == 8 then
		VPG_SetCheckerboard(0, 64, 64) -- Invert checkerboard
	else
		run = 0
		LOG.INFO(string.format("run = 0"))
	end

	if run == 0 then
		if num >= 1 and num <= 24 then
			LOG.INFO(string.format("bist_mode_swich_EN: num = %d backup function", num))
		else
			LOG.ERROR(string.format("bist_mode_swich_EN: num = %d out of range[1~24]", num))
		end
		return -1
	end

	return 0
end

--[[
Function: VPG_9SQUARE_FRC
Desc: VPG pattern generator, generate 9 square cross pattern.
Input:
    cx : Cross center X coordinate
    cy : Cross center Y coordinate
    ox : Cross offset X
    oy : Cross offset Y
Return: None
--]]
--  VPG_9SQUARE_FRC(928, 736, 300, 300)
--  VPG_SetCheckerboard(255,128,128)
function VPG_9SQUARE_FRC(cx, cy, ox, oy)
	VPG_SetFlatField(255)
	TIME.DELAY(20)
	local data_buf = {
		-- 1st P: PG_SEL=5, PG_MODE_EN=1
		0xB1,
		-- 2nd ~ 20th
		0xff, -- 2 PG_SHADE
		0x00, -- 3 PG_BAR_WIDTH[10:8]
		0x10, -- 4 PG_BAR_WIDTH[7:0]
		0x00, -- 5 PG_BLK_VSIZE[10:8]
		0x10, -- 6 PG_BLK_VSIZE[7:0]
		0x00, -- 7 PG_BLK_HSIZE[10:8]
		0x10, -- 8 PG_BLK_HSIZE[7:0]
		0x02, -- 9 PG_VLINE[10:8]
		0xE0, --10 PG_VLINE[7:0]
		0x03, --11 PG_HLINE[10:8]
		0xA0, --12 PG_HLINE[7:0]
		0x00, --13 PG_PAT_VSIZE[10:8]
		0x10, --14 PG_PAT_VSIZE[7:0]
		0x00, --15 PG_PAT_HSIZE[10:8]
		0x10, --16 PG_PAT_HSIZE[7:0]
		0x00, --17 PG_PAT_X[10:8]
		0x01, --18 PG_PAT_X[7:0]
		0x00, --19 PG_PAT_Y[10:8]
		0x01, --20 PG_PAT_Y[7:0]
		0x01, --21 PG_PAT_Y[7:0]
		0x01, --22 PG_PAT_Y[7:0]
		0x01, --23 PG_PAT_Y[7:0]
		0x01, --24 PG_PAT_Y[7:0]
		0x01, --25 PG_PAT_Y[7:0]
		0x01, --26 PG_PAT_Y[7:0]
		0x01, --27 PG_PAT_Y[7:0]
		0x01, --28 PG_PAT_Y[7:0]

		-- 29~32 中心十字坐标（传入参数）
		(cx >> 8) & 0x07, --29 PG_CROSS_CENTER_X[10:8]
		cx & 0xFF,  --30 PG_CROSS_CENTER_X[7:0]
		(cy >> 8) & 0x07, --31 PG_CROSS_CENTER_Y[10:8]
		cy & 0xFF,  --32 PG_CROSS_CENTER_Y[7:0]

		-- 33~36 十字偏移量
		(ox >> 8) & 0x07, --33 PG_CROSS_OFFSET_X[10:8]
		ox & 0xFF,  --34 PG_CROSS_OFFSET_X[7:0]
		(oy >> 8) & 0x07, --35 PG_CROSS_OFFSET_Y[10:8]
		oy & 0xFF   --36 PG_CROSS_OFFSET_Y[7:0]
	}

	IIC_W_Tab2(0xF6, { 0x00, 0x00, 0x3f })
	IIC_W_Tab2(0xFA, data_buf)

	LOG.INFO(string.format(
		"9Cross: CX=%d,CY=%d,OX=%d,OY=%d",
		cx, cy, ox, oy
	))
end

--[[
Function: VPG_9POINT_FRC
Desc: VPG pattern generator, generate 9 point pattern.
Input:
    cx : Center X coordinate
    cy : Center Y coordinate
    ox : Offset X
    oy : Offset Y
Return: None
--]]

--VPG_9POINT_FRC(928, 736, 300, 300)
function VPG_9POINT_FRC(cx, cy, ox, oy)
	VPG_SetFlatField(255)
	TIME.DELAY(20)
	local data_buf = {
		-- 1st P: PG_SEL=5, PG_MODE_EN=1
		0x51,
		-- 2nd ~ 20th
		0xff, -- 2 PG_SHADE
		0x00, -- 3 PG_BAR_WIDTH[10:8]
		0x10, -- 4 PG_BAR_WIDTH[7:0]
		0x00, -- 5 PG_BLK_VSIZE[10:8]
		0x10, -- 6 PG_BLK_VSIZE[7:0]
		0x00, -- 7 PG_BLK_HSIZE[10:8]
		0x10, -- 8 PG_BLK_HSIZE[7:0]
		0x02, -- 9 PG_VLINE[10:8]
		0xE0, --10 PG_VLINE[7:0]
		0x03, --11 PG_HLINE[10:8]
		0xA0, --12 PG_HLINE[7:0]
		0x00, --13 PG_PAT_VSIZE[10:8]
		0x10, --14 PG_PAT_VSIZE[7:0]
		0x00, --15 PG_PAT_HSIZE[10:8]
		0x10, --16 PG_PAT_HSIZE[7:0]
		0x00, --17 PG_PAT_X[10:8]
		0x01, --18 PG_PAT_X[7:0]
		0x00, --19 PG_PAT_Y[10:8]
		0x01, --20 PG_PAT_Y[7:0]



		-- 21~24 中心十字坐标（传入参数）
		(cx >> 8) & 0x07, --21 PG_CROSS_CENTER_X[10:8]
		cx & 0xFF,  --22 PG_CROSS_CENTER_X[7:0]
		(cy >> 8) & 0x07, --23 PG_CROSS_CENTER_Y[10:8]
		cy & 0xFF,  --24 PG_CROSS_CENTER_Y[7:0]

		-- 25~28 十字偏移量
		(ox >> 8) & 0x07, --25 PG_CROSS_OFFSET_X[10:8]
		ox & 0xFF,  --26 PG_CROSS_OFFSET_X[7:0]
		(oy >> 8) & 0x07, --27 PG_CROSS_OFFSET_Y[10:8]
		oy & 0xFF   --28 PG_CROSS_OFFSET_Y[7:0]
	}

	IIC_W_Tab2(0xF6, { 0x00, 0x00, 0x7f })
	IIC_W_Tab2(0xFA, data_buf)

	LOG.INFO(string.format(
		"9Cross: CX=%d,CY=%d,OX=%d,OY=%d",
		cx, cy, ox, oy
	))
end

--[[
Function: EFuse_DieID_Read
Desc: Read EFuse area including DieID. Unlock efuse register, read 256 bytes data then lock.
Input: None
Return:
    1          : Return status
    json_data  : Json string of efuse raw byte array
--]]
--EFuse_DieID_Read()
function EFuse_DieID_Read()
	local efuse_data = {}
	local val_table = {}
	VQPS(ON)
	TIME.DELAY(1000)

	IIC_W_Tab2(0xF0, 0x5A5A)      --Level2 Key
	IIC_W_Tab2(0xF1, 0x5A5A)      --OTP(efuse) key
	IIC_W_Tab2(0xC0, { 0x01, 0x01 }) --OTP(efuse) Control
	TIME.DELAY(5)

	IIC_W_Tab2(0xC0, 0x0000)

	val_table, efuse_data = IIC_R_Tab2(0xC1, 256)

	local json_data = cjson.encode(efuse_data)
	LOG.INFO(json_data)

	--for i = 1, #efuse_data do
	--println("efuse_data[%d]=%02X", i, efuse_data[i])
	--end

	IIC_W_Tab2(0xF0, 0xA5A5) --Level2 Key
	IIC_W_Tab2(0xF1, 0xA5A5) --OTP(efuse) key

	VQPS(OFF)

	return 1, json_data
end

--[[
Function: EFuse_write256bit
Desc: Write single byte to EFuse. Unlock EFuse, write data buffer and trigger program, then lock.
Input:
    offset : EFuse buffer index(start from 1)
    val    : Byte value to program
Return:
    1 : Function complete status
--]]
--IIC_R_Tab2(0xF1,2)
--EFuse_write256bit(16,0x56)
function EFuse_write256bit(offset, val)
	local efuse_buf = {}
	for i = 1, 255 do
		efuse_buf[i] = 0x00
	end
	efuse_buf[offset] = val
	VQPS(ON)
	TIME.DELAY(1000)

	IIC_W_Tab2(0xF0, 0x5A5A)
	IIC_W_Tab2(0xF1, 0x5A5A)
	IIC_W_Tab2(0xC1, efuse_buf) --OTP User
	IIC_W_Tab2(0xC0, { 0x02, 0x00, 0x00 })


	TIME.DELAY(30)

	IIC_W_Tab2(0xC0, 0x0000) --OTP(efuse) Control
	IIC_W_Tab2(0xF0, 0xA5A5) --Level2 Key
	IIC_W_Tab2(0xF1, 0xA5A5) --OTP(efuse) key

	VQPS(OFF)

	LOG.INFO(string.format("EFuse  ,offset %d set val=0x%02x", offset, val))
	return 1
end

function DAC_Full_Range_Calibration()
	local results = {}
	local current_table = {}
	local best_trim = nil
	local best_diff = math.huge
	local target_uA = 5.2
	local best_current = nil
	local dac_current = 0
	local notFound = 0

	local tim1 = TIME.TICK()
	PPMU.CAL_EN(0) --5V on
	GPIO6_A_SET(1)
	GPIO3_A_SET(0)
	GPIO2_A_SET(1)

	IIC_W_Tab2(0xFD, { 0x00, 0x00, 0x00 })
	IIC_R_Tab2(0xFD, 3)
	--PPMU.CAL_EN(1)    --5V off

	TIME.DELAY(10)

	Power.ValueSetting.SMU2 = 0
	SMU2(ON, 0, 0x82)
	TIME.DELAY(1000)
	local Vol, leakageCurrent = POWER.VOL_CUR(P_SMU2)
	LOG.INFO(string.format("Pre?set Current:%f", leakageCurrent))

	IIC_W_Tab2(0xF0, { 0x5a, 0x5a })
	IIC_W_Tab2(0xF1, { 0x5a, 0x5a })
	IIC_W_Tab2(0xFc, { 0x5a, 0x5a })
	IIC_W_Tab2(0xFD, { 0x00, 0x02, 0x94 }) --ANALOGTEST

	TIME.DELAY(100)
	--IIC_W_Tab2(0xF7, {0x03, 0x00, 0x00,0x00, 0x00,0x00, 0x00})



	for trim_val = 0, 511, 5 do
		LOG.INFO(string.format("===== Test PBIAS_IPXL_TRIM = %d =====", trim_val))

		local bit8 = (trim_val >> 8) & 0x01
		local byte_low = trim_val & 0xFF

		local trim_buf = {
			0x72, --1stP
			0x10, --2ndP
			0x10, --3rdP
			0x10, --4thP
			0x20, --5thP
			0x10, --6thP
			0x10, --7thP
			0x25, --8thP
			0x0A, --9thP
			0x0A, --10thP
			0x03, --11thP
			0x11, --12thP
			0x20, --13thP
			bit8, --14thP  PBIAS_IPXL_TRIM[8]
			byte_low, --15thP  PBIAS_IPXL_TRIM[7:0]
			0x08, --16thP
			0x08, --17thP
			0x10, --18thP
			0x00, --19thP
			0x00, --20thP
			0x00, --21thP
			0x00, --22thP
			0x00, --23thP
			0x00, --24thP
			0x20, --25thP
			0x20, --26thP
			0x20, --27thP
			0x20, --28thP
			0x88, --29thP
			0x02, --30thP
			0x00, --31thP
			0x02, --32thP
			0x00, --33thp
			0x00 --34thp
		}

		IIC_W_Tab2(0xF8, trim_buf) --Trim
		--TIME.DELAY(100)
		TIME.DELAY(50)

		IIC_R_Tab2(0xF8, 34)


		local refVolt, measCurrent = POWER.VOL_CUR(P_SMU2)
		measCurrent = (measCurrent) / 1000
		LOG.INFO(string.format("trim=%d  Meas Current = %f uA", trim_val, measCurrent))
		table.insert(current_table, { trim = trim_val, current = measCurrent })


		local diff = math.abs(math.abs(measCurrent) - target_uA)
		if diff < best_diff then
			best_diff = diff
			best_trim = trim_val
			best_current = measCurrent
			DAC_calibration_code = trim_val
			println("[%02d] DAC best current out:%.4fuA", best_trim, best_current)
		end
	end

	SMU2(OFF, 0, 0x82)
	PPMU.CAL_EN(1)

	--F_Save_DAC_CSV()
	--for i,data in ipairs(current_table) do
	--local line = string.format("%d,%d,%.4f,\n",i,data.trim,data.current)
	--Update_DAC_CSV(line)
	--end


	local tim2 = TIME.TICK()
	LOG.INFO("DAC_Full_range time: " .. string.format("%.3f", (tim2 / 1000 - tim1 / 1000)) .. "seconds")
	--IIC_W_Tab2(0xFD, {0x00, 0x00, 0x00})
	LOG.INFO(string.format("[%02d] DAC best current out:%.4fuA", best_trim, best_current))
	--LOG.INFO(string.format("Best trim code = %d, min diff = %f uA", best_trim, best_diff))

	table.insert(results, best_trim)
	table.insert(results, best_current)
	--table.insert(results,notFound)
	--table.insert(results,leakageCurrent)

	local json_data = cjson.encode(results)
	LOG.INFO(json_data)
	return 0, json_data
end

--[[
Function: Pixel_Current_DAC_Cal_binary
Desc: DAC full range calibration. Sweep PBIAS_IPXL_TRIM to find trim code for target 5.2uA pixel current.
Input: None
Return:
    0          : Success status
    json_data  : Json array [best_trim, best_measured_current(uA)]
--]]
--- Calibrates the pixel-current DAC (PBIAS_IPXL_TRIM[8:0], F8h TRIM bytes 14-15)
-- so the AMON-monitored pixel current hits the 5.2 uA target.
-- Routes analog mux Y5 to AMON (GPIO6=1, GPIO3=0, GPIO2=1), enables the analog
-- test path (FDh ANALOGTEST = {0x00, 0x02, 0x94}), then forces constant current
-- with SMU2 and measures the voltage across R_AMUX (100 kOhm):
-- I(uA) = Vmeas / 100k * 1e6.
-- Binary search over the 9-bit trim code (0~511) with per-code result caching,
-- so no code is measured twice (~11 measurements instead of a full sweep).
-- If 5.2 uA lies outside the DAC range, the closest end code is kept and a
-- warning is logged (notFound=1 in the log).
-- The winning code is left written to F8h and stored in global DAC_calibration_code.
-- @usage Pixel_Current_DAC_Cal_binary()   -- stores result in DAC_calibration_code
-- @return number status  Always 0 (out-of-range target is reported in the log only).
-- @return string json    cjson array [best_trim, best_current_uA].
-- @see DAC_Full_Range_Calibration, apply_DAC_calibration_code
function Pixel_Current_DAC_Cal_binary()
	local R_AMUX_OHM = 100000
	local TRIM_MIN   = 0
	local TRIM_MAX   = 511 -- 9-bit trim code
	local SETTLE_MS  = 450 -- settling time after each trim write

	local function make_trim_payload(trim_val)
	
		local _,read_data = IIC_R_Tab2(0xF8,34)
		read_data[14] = (trim_val >> 8) & 0x01
		read_data[15] = trim_val & 0xFF
		return read_data
	end
	local results = {}
	local current_table = {}
	local best_trim = nil
	local best_diff = math.huge
	local target_uA = 5.2
	local best_current = nil
	local notFound = 0
	local meas_count = 0

	local tim1 = TIME.TICK()
	PPMU.CAL_EN(0) --5V on
	Power.ValueSetting.SMU2 = 0
	SMU2(ON, 1, 0x85) --Constant Current (measure Voltage)
	TIME.DELAY(1000)

	-- Y5
	GPIO6_A_SET(1)
	GPIO3_A_SET(0)
	GPIO2_A_SET(1)

	-- FDh ANALOGTEST : soft-reset analog-test MUX before reconfiguring
	IIC_W_Tab2(0xFD, { 0x00, 0x00, 0x00 })
	IIC_R_Tab2(0xFD, 3) -- read-back to latch reset state

	TIME.DELAY(10)

	local preVolt = POWER.VOL_CUR(P_SMU2)
	LOG.INFO(string.format("Preset AMUX Voltage:%f", preVolt))

	-- I2C keys : F0h Level2 key, F1h OTP/eFuse key, FCh 3rd key
	IIC_W_Tab2(0xF0, { 0x5a, 0x5a }) -- unlock Level2 register bank
	IIC_W_Tab2(0xF1, { 0x5a, 0x5a }) -- unlock OTP key
	IIC_W_Tab2(0xFc, { 0x5a, 0x5a }) -- unlock 3rd key
	-- FDh ANALOGTEST : enable analog-test item path to AMON
	-- 3rd P = 0x94 → VDC_TPXL_EN (analog pixel test enabled) + ANA_TMUX/ANA_TEST_SET
	IIC_W_Tab2(0xFD, { 0x00, 0x02, 0x94 })

	TIME.DELAY(100)

	----------------------------------------------------------------
	-- Measure |current| (uA) at one trim code. Results are cached,
	-- so no code is ever measured twice. Also tracks the best code.
	----------------------------------------------------------------
	local cache = {}
	local function measure(trim_val)
		if cache[trim_val] ~= nil then
			return cache[trim_val]
		end
		-- F8h TRIM : PBIAS_IPXL_TRIM[8:0] at bytes 14-15 (set pixel-current DAC code)
		IIC_W_Tab2(0xF8, make_trim_payload(trim_val))
		TIME.DELAY(SETTLE_MS)
		--IIC_R_Tab2(0xF8, 34)
		local measVolt, forceCur = POWER.VOL_CUR(P_SMU2) -- V nA
		local measCurrent = measVolt / R_AMUX_OHM * 1e6
		meas_count = meas_count + 1
		LOG.INFO(string.format("[#%02d] trim=%d AMUX=%.4fV Current=%.4f uA, forceCur=%.4f",
			meas_count, trim_val, measVolt, measCurrent, forceCur))
		table.insert(current_table, { trim = trim_val, current = measCurrent })

		local diff = math.abs(math.abs(measCurrent) - target_uA)
		if diff < best_diff then
			best_diff = diff
			best_trim = trim_val
			best_current = measCurrent
			LOG.DEBUG(string.format("[%02d] DAC best current out: %.4fuA", best_trim, best_current))
		end

		cache[trim_val] = math.abs(measCurrent)
		return cache[trim_val]
	end

	----------------------------------------------------------------
	-- Binary search, step size 1.
	-- 1) Measure both ends to learn slope direction and check that
	--    the target is inside the DAC range.
	-- 2) Bisect until lo/hi are adjacent codes bracketing the target.
	-- 3) best_trim = whichever measured code is closest (tracked in
	--    measure()).
	-- Total: 2 + ceil(log2(511)) = ~11 measurements (was 52).
	----------------------------------------------------------------
	local lo, hi = TRIM_MIN, TRIM_MAX
	local i_lo = measure(lo)
	local i_hi = measure(hi)
	local increasing = (i_hi >= i_lo)

	local i_min = math.min(i_lo, i_hi)
	local i_max = math.max(i_lo, i_hi)
	if target_uA < i_min or target_uA > i_max then
		-- Target outside DAC range: best_trim is already the closest end code
		notFound = 1
		LOG.ERROR(string.format("WARNING: target %.3fuA outside DAC range [%.4f, %.4f]uA",
			target_uA, i_min, i_max))
	else
		while (hi - lo) > 1 do
			local mid = (lo + hi) // 2
			local above = (measure(mid) >= target_uA)
			-- increasing slope: above target -> answer is at/below mid
			-- decreasing slope: above target -> answer is above mid
			if above == increasing then
				hi = mid
			else
				lo = mid
			end
		end
	end

	DAC_calibration_code = best_trim
	-- F8h TRIM : write final winning PBIAS_IPXL_TRIM code
	IIC_W_Tab2(0xF8, make_trim_payload(best_trim))
	TIME.DELAY(50)
	IIC_R_Tab2(0xF8, 34) -- read-back to confirm trim latched

	SMU2(OFF, 0, 0x82)
	PPMU.CAL_EN(1)

	local tim2 = TIME.TICK()
	LOG.INFO("DAC_BinarySearch time: " ..
		string.format("%.3f", (tim2 / 1000 - tim1 / 1000)) .. "seconds, measurements=" .. meas_count)
	LOG.INFO(string.format("[%02d] DAC best current out:%.4fuA (diff=%.4fuA, notFound=%d)", best_trim, best_current,
		best_diff, notFound))

	table.insert(results, best_trim)
	table.insert(results, best_current)
	--table.insert(results,notFound)

	local json_data = cjson.encode(results)
	LOG.INFO(json_data)
	return 0, json_data
end

--[[
Function: DAC_2point_calibration
Desc: DAC two-point calibration. Fix PBIAS_IPXL_TRIM, measure pixel current at GLBC=43 and GLBC=341, calculate linear coefficient I=k*GLBC+b, judge +/-5% spec.
Input: None
Return:
    0          : Function complete status
    json_data  : Json array [current@GLBC43(uA), current@GLBC341(uA)]
--]]
function DAC_2point_calibration()
	----------------------------------------------------------------
	-- 1. Constants
	----------------------------------------------------------------
	local CODE_A       = 43 -- GLBC code, V0.4 Pass/Fail 10
	local CODE_B       = 341 -- GLBC code, V0.4 Pass/Fail 11
	local CODE_MAX     = 511

	local IPXL_TOL_PCT = 5 -- V0.4 criteria 10 / 11: +/-5% each

	-- *** PENDING META CONFIRMATION ***
	-- V0.4 only says "+/-5% of expected value" and never states the expected
	-- value anywhere. The two numbers below are derived from the p.23 data
	-- points GLBC=146 -> 3.0uA and GLBC=156 -> 3.2uA, which give the nominal
	-- line I(uA) = 0.02 * GLBC + 0.08. They are NOT quoted in the test plan.
	-- Replace directly once the official values are available.
	local EXPECT_A_uA  = 0.94 -- Code 43
	local EXPECT_B_uA  = 6.90 -- Code 341

	local SETTLE_MS    = 300
	local SMU_RANGE    = 0x02 -- auto range, matches the working Full Range
	local CUR_SIGN     = -1 -- SMU2 reads negative (sink); flip to compare

	-- PBIAS_IPXL_TRIM is held for the whole test and must not change
	local PBIAS        = pbias_trim or PBIAS_IPXL_code or 256

	local results      = {}
	PPMU.CAL_EN(0)

	LOG.INFO(string.format("===== DAC 2-Point : GLBC %d / %d, PBIAS_IPXL_TRIM fixed %d =====",
		CODE_A, CODE_B, PBIAS))

	----------------------------------------------------------------
	-- 2. Local helpers
	----------------------------------------------------------------
	-- F8h 34-byte payload; only bytes 14/15 carry PBIAS_IPXL_TRIM
	local function make_trim_payload(trim_val)
		local bit8     = (trim_val >> 8) & 0x01
		local byte_low = trim_val & 0xFF
		return {
			0x72, --1stP   OSC_FTRIM
			0x10, --2ndP   VDC_VDDPHY_TRIM
			0x10, --3rdP   VDC_VDDLP_TRIM
			0x10, --4thP   VDC_VDDPLL_TRIM
			0x20, --5thP   VDC_VREF_TRIM
			0x10, --6thP   VDC_VDDA_TRIM
			0x10, --7thP   VDC_VDDPXL_TRIM
			0x25, --8thP   VDC_VEEA1P6_TRIM
			0x0A, --9thP   VDC_VEEA1P2_TRIM
			0x0A, --10thP  VDC_VEEA1_TRIM
			0x03, --11thP  VDC_BGR_IBIAS / VDC_MAIN_IBIAS
			0x11, --12thP  VDC_VT_IBIAS / VDC_LDO_IBIAS
			0x20, --13thP  VDC_IREF_TRIM
			bit8, --14thP  PBIAS_IPXL_TRIM[8]
			byte_low, --15thP  PBIAS_IPXL_TRIM[7:0]
			0x08, --16thP  PHY_TERM50_TRIM   must match Full Range exactly
			0x08, --17thP  PHY_TERM80_TRIM
			0x10, --18thP  PHY_BIAS_TRIM
			0x00, --19thP  PHY_OCALAP
			0x00, --20thP  PHY_OCALAN
			0x00, --21thP  PHY_OCALBP
			0x00, --22thP  PHY_OCALBN
			0x00, --23thP  PHY_OCALCP
			0x00, --24thP  PHY_OCALCN
			0x20, --25thP  TSL_TOP_TRIM
			0x20, --26thP  TSR_TOP_TRIM
			0x20, --27thP  TSL_BOT_TRIM
			0x20, --28thP  TSR_BOT_TRIM
			0x88, --29thP  TSR_BGR_TRIM / TSL_BGR_TRIM
			0x02, --30thP  TSL_TRIM_TARGET[9:8]
			0x00, --31thP  TSL_TRIM_TARGET[7:0]
			0x02, --32thP  TSR_TRIM_TARGET[9:8]
			0x00, --33thP  TSR_TRIM_TARGET[7:0]
			0x00 --34thP  TRIM_DUM1
		}
	end

	-- F6h VDC GLBC: 3 parameters
	local function set_glbc(code)
		IIC_W_Tab2(0xF6, { 0x00, (code >> 8) & 0x01, code & 0xFF })
		IIC_W_Tab2(0xF4, { 0x01 }) -- Update, per IC.lua:212 / _debug2.lua:35
	end

	----------------------------------------------------------------
	-- 3. Power up and measurement path
	--    (sequence matches the Full Range function that is known to work)
	----------------------------------------------------------------
	GPIO6_A_SET(1)                      -- PG_GPIO5 -> X_CBIT3 = 1
	GPIO3_A_SET(0)                      -- PG_GPIO2 -> X_CBIT2 = 0
	GPIO2_A_SET(1)                      -- PG_GPIO1 -> X_CBIT1 = 1   -> U3 Y5 = AMON

	IIC_W_Tab2(0xFD, { 0x00, 0x00, 0x00 }) -- clear FDh first
	IIC_R_Tab2(0xFD, 3)

	-- Do NOT switch 5V off: the CBIT relay coils (K11/K12) run on 5V_A
	--PPMU.CAL_EN(1)    --5V off
	TIME.DELAY(10)

	Power.ValueSetting.SMU2 = 0
	SMU2(ON, 0, SMU_RANGE)
	TIME.DELAY(1000)

	local Vol, leakageCurrent = POWER.VOL_CUR(P_SMU2)
	LOG.INFO(string.format("Pre-set (leakage) Current: %f nA", leakageCurrent))

	IIC_W_Tab2(0xF0, { 0x5a, 0x5a }) -- Level2 Key
	IIC_W_Tab2(0xF1, { 0x5a, 0x5a }) -- OTP Key
	IIC_W_Tab2(0xFc, { 0x5a, 0x5a }) -- third key

	-- FDh per the test plan's s25m11_otp_ipxl_0420().
	-- Measured: 0x02 and 0x12 behave identically here.
	IIC_W_Tab2(0xFD, { 0x00, 0x02, 0x94 })
	TIME.DELAY(100)

	-- Write PBIAS_IPXL_TRIM once and hold it. Equivalent to the Pequin step
	-- "Apply calibrated trim value to bandgap".
	IIC_W_Tab2(0xF8, make_trim_payload(PBIAS))
	TIME.DELAY(SETTLE_MS)

	----------------------------------------------------------------
	-- 4. Measure: only GLBC changes
	----------------------------------------------------------------
	local function measure_at_glbc(code, tag)
		set_glbc(code)
		TIME.DELAY(SETTLE_MS)
		local refVolt, measCurrent = POWER.VOL_CUR(P_SMU2)
		local cur_uA = CUR_SIGN * (measCurrent - leakageCurrent) / 1000
		LOG.INFO(string.format("%s GLBC=%3d  I = %.4f uA", tag, code, cur_uA))
		return cur_uA
	end

	local curA_uA = measure_at_glbc(CODE_A, "[point A]")
	local curB_uA = measure_at_glbc(CODE_B, "[point B]")

	-- Read F6h back to confirm the GLBC write landed (3 bytes)
	IIC_R_Tab2(0xF6, 3)

	----------------------------------------------------------------
	-- 5. Tear down
	----------------------------------------------------------------
	SMU2(OFF, 0, SMU_RANGE)
	GPIO2_A_SET(0)
	GPIO3_A_SET(0)
	GPIO6_A_SET(0)

	----------------------------------------------------------------
	-- 6. Solve I = k * GLBC + b
	----------------------------------------------------------------
	local k_uA = (curB_uA - curA_uA) / (CODE_B - CODE_A)
	local b_uA = curA_uA - k_uA * CODE_A
	local fs_uA = k_uA * CODE_MAX + b_uA

	LOG.INFO(string.format("k = %.2f nA/code, b = %.1f nA, full scale @%d = %.3f uA",
		k_uA * 1000, b_uA * 1000, CODE_MAX, fs_uA))

	-- Sanity check on the ratio of the two points. Expected 6.90/0.94 = 7.34.
	-- A ratio near 1 means the GLBC write had no effect, or GLBC is not on
	-- this monitor path; k / b / Pass-Fail below would all be meaningless.
	local ratio = (curA_uA ~= 0) and (curB_uA / curA_uA) or 0
	LOG.INFO(string.format("Sanity: I(341)/I(43) = %.2f  (expect ~7.34)", ratio))
	if math.abs(ratio - 1) < 0.2 then
		LOG.ERROR("2Point sanity FAIL: two points nearly identical -> GLBC write not effective")
	end

	----------------------------------------------------------------
	-- 7. Pass / Fail (V0.4 criteria 10 / 11)
	----------------------------------------------------------------
	local tolA_uA = EXPECT_A_uA * IPXL_TOL_PCT / 100
	local tolB_uA = EXPECT_B_uA * IPXL_TOL_PCT / 100

	local passA = (math.abs(curA_uA - EXPECT_A_uA) <= tolA_uA) and 1 or 0
	local passB = (math.abs(curB_uA - EXPECT_B_uA) <= tolB_uA) and 1 or 0

	LOG.INFO(string.format("Point A: %.4f uA  expect %.3f +/- %.3f  -> %s",
		curA_uA, EXPECT_A_uA, tolA_uA, (passA == 1) and "PASS" or "FAIL"))
	LOG.INFO(string.format("Point B: %.4f uA  expect %.3f +/- %.3f  -> %s",
		curB_uA, EXPECT_B_uA, tolB_uA, (passB == 1) and "PASS" or "FAIL"))

	if passA == 0 then LOG.ERROR("2Point criteria 10: current at Code 43 out of +/-5%") end
	if passB == 0 then LOG.ERROR("2Point criteria 11: current at Code 341 out of +/-5%") end

	-- Criterion 12 "Linearity error exceeds specification": not judged.
	--   (a) V0.4 gives no number; the "specification" is blank
	--   (b) Two points cannot yield an INL figure - any two points define a
	--       perfect straight line, so the residual is always zero
	--   k / b are still computed and datalogged; add a verdict once the
	--   design team supplies a limit.
	LOG.INFO("Criteria 12 (linearity): no spec value given, not judged. k/b datalogged only.")

	----------------------------------------------------------------
	-- 8. Cache globals for eFuse and downstream back-calculation
	----------------------------------------------------------------
	IPXL_2P_POINTA_nA = curA_uA * 1000
	IPXL_2P_POINTB_nA = curB_uA * 1000
	IPXL_2P_K_nA      = k_uA * 1000
	IPXL_2P_B_nA      = b_uA * 1000
	IPXL_2P_PBIAS     = PBIAS

	----------------------------------------------------------------
	-- 9. Datalog
	--    RESULT ORDER:
	--      [1] PBIAS_IPXL_TRIM used
	--      [2] I @ GLBC 43   (uA)   <-- to be eFused
	--      [3] I @ GLBC 341  (uA)   <-- to be eFused
	--      [4] k             (nA/code)
	--      [5] b             (nA)
	--      [6] Pass Point A  (1/0)
	--      [7] Pass Point B  (1/0)
	----------------------------------------------------------------
	--table.insert(results, PBIAS)
	table.insert(results, curA_uA)
	table.insert(results, curB_uA)
	--table.insert(results, k_uA * 1000)
	--table.insert(results, b_uA * 1000)
	--table.insert(results, passA)
	--table.insert(results, passB)

	local json_data = cjson.encode(results)
	LOG.INFO(json_data)

	-- Existing convention returns 0 unconditionally. If the harness treats
	-- non-zero as fail, use:
	--   return (passA==1 and passB==1) and 0 or 1, json_data
	return 0, json_data
end

--[[
Function: Temperature_Sensor_Thermometer
Desc: Chip internal temperature sensor read function. Unlock register, configure left(TSL)/right(TSR) temperature sensor, read raw ADC code and convert to temperature.
Input: None
Return:
    0          : Function complete status
    json_data  : Json array [LeftTemp(℃), RightTemp(℃), TSL_RAW_CODE, TSR_RAW_CODE]
--]]
function Temperature_Sensor_Thermometer()
	local results = {}
	IIC_W_Tab2(0xF0, { 0x5a, 0x5a }) -- Level2 Key
	IIC_W_Tab2(0xF1, { 0x5a, 0x5a }) -- OTP Key
	IIC_W_Tab2(0xFc, { 0x5a, 0x5a }) -- third key

	--IIC_W_Tab2(0xFE, {0x02, 0x03})

	-- 温度控制寄存器配置
	IIC_W_Tab2(0xE0,
		{ 0x30, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF, 0x30, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F }) --Temperature Control
	IIC_W_Tab2(0xE0,
		{ 0x78, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF, 0x78, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F }) --Temperature Control
	IIC_W_Tab2(0xE0,
		{ 0x70, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF, 0x70, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F }) --Temperature Control
	--IIC_W_Tab2(0xE0,0x70)

	--Temperature_TRIM_buf[30]  = 0x1
	--Temperature_TRIM_buf[31]  = 0x55
	--Temperature_TRIM_buf[32]  = 0x1
	--Temperature_TRIM_buf[33]  = 0x55
	--IIC_W_Tab2(0xF8,Temperature_TRIM_buf)
	--IIC_R_Tab2(0xF8, 34)

	TIME.DELAY(50)
	local _, readData = IIC_R_Tab2(0xE1, 4)
	-- rData[1] → 1st P: TSL_DATA_OUT[9:8]
	-- rData[2] → 2nd P: TSL_DATA_OUT[7:0]
	-- rData[3] → 3rd P: TSR_DATA_OUT[9:8]
	-- rData[4] → 4th P: TSR_DATA_OUT[7:0]
	local tsl_high    = readData[1] & 0x03 -- 低2bit
	local tsl_low     = readData[2] & 0xFF
	local TSL_CODE    = (tsl_high << 8) | tsl_low

	local tsr_high    = readData[3] & 0x03 -- 低2bit
	local tsr_low     = readData[4] & 0xFF
	local TSR_CODE    = (tsr_high << 8) | tsr_low


	local function Code2Temp(code)
		-- 292(-25℃) ~ 732(85℃)
		if code < 292 or code > 732 then
			return nil
		end
		return -25 + (code - 292) * 0.25
	end

	local tempLeft = Code2Temp(TSL_CODE)
	local tempRight = Code2Temp(TSR_CODE)

	LOG.INFO(string.format("TSL_CODE = %d, Left Temp = %s ℃", TSL_CODE, tostring(tempLeft or "OutRange")))
	LOG.INFO(string.format("TSR_CODE = %d, Right Tmp = %s ℃", TSR_CODE, tostring(tempRight or "OutRange")))


	table.insert(results, tempLeft)
	table.insert(results, tempRight)
	table.insert(results, TSL_CODE)
	table.insert(results, TSR_CODE)


	local json_data = cjson.encode(results)
	LOG.INFO(json_data)
	return 0, json_data
end

--Set_Brightness(100)
function Set_Brightness(glbc_value)
	local results = {}
	IIC_W_Tab2(0xF0, { 0x5a, 0x5a }) -- Level2 Key
	IIC_W_Tab2(0xF1, { 0x5a, 0x5a }) -- OTP Key
	IIC_W_Tab2(0xFc, { 0x5a, 0x5a }) -- third key


	--IIC_W_Tab2(0xF6, {0x00, 0x01 ,0xFF}) -- Pixel current to max
	--IIC_R_Tab2(0xF6,3)

	--IIC_W_Tab2(0xFA, {0x91, 0x00, 0x00, 0x10,0x00,0x80,0x00,0x80,0x00})
	--IIC_W_Tab2(0xFA, {0x91, 0xFF, 0x00, 0x10,0x00,0x80,0x00,0x80,0x00})

	local bit8   = (glbc_value >> 8) & 0x01
	local bit7_0 = glbc_value & 0xFF

	LOG.INFO(string.format("bit8 val:0x%X, bbit7_0 val:0x%X", bit8, bit7_0))
	IIC_W_Tab2(0xF6, { 0x00, bit8, bit7_0 })

	IIC_R_Tab2(0xF6, 3)
	return 0
end

function F_CLK_IN_TEST()
	--MCU.CHANNEL_LEVEL(2,1,1.80)--gpio 1.8V
	PPMU.PIXEL_IN(1) --CLK_OUT EN
	--PPMU.RELAY_EN(0x200)
	--PPMU.CAL_EN(0)
	--Pre_Clk=Real_Clk1
	local Real_Clk1 = DEDP.GET_FRQ(1) / 1000000
	local Real_Clk2 = DEDP.GET_FRQ(2) / 1000000


	local real1 = Real_Clk1 * 2
	local real2 = Real_Clk2 * 8

	LOG.DEBUG(string.format("CLK_MEASURE: ch1_real=%.3fMHZ, ch2_real=%3fMHZ", real1, real2))

	return real1

	--if (isInRange(Pre_Clk, Real_Clk1*2, 0.1)) then
	--LOG.DEBUG(string.format("CLK_IN1_TEST-->PASS,CLK_OUT-->%.3fMHZ CLK_IN-->%.3fMHZ",Pre_Clk,Real_Clk1*2))
	--else
	--LOG.ERROR(string.format("CLK_IN1_TEST-->NG,CLK_OUT-->%.3fMHZ CLK_IN-->%.3fMHZ",Pre_Clk,Real_Clk1*2))
	--end

	--if (isInRange(Pre_Clk, Real_Clk2*8, 0.1)) then
	--LOG.DEBUG(string.format("CLK_IN2_TEST-->PASS,CLK_OUT-->%.3fMHZ CLK_IN-->%.3fMHZ",Pre_Clk,Real_Clk2*8))
	--else
	--LOG.ERROR(string.format("CLK_IN2_TEST-->NG,CLK_OUT-->%.3fMHZ CLK_IN-->%.3fMHZ",Pre_Clk,Real_Clk2*8))
	--end
	--DEDP.SI5351_SET(64*1000*1000,5)--64M
	--return meas_freq_mhz
end

--[[
Function: Internal_Osc_trim
Desc: Internal oscillator trim calibration. Sweep OSC_FTRIM code, measure clock frequency, find the trim value closest to target 12.5MHz, then verify and judge PASS/FAIL.
Input: None
Return:
    0          : Function complete status
    json_data  : Json array [target_freq(MHz), best_osc_ftrim, best_meas_freq(MHz), final_verify_freq(MHz)]
--]]
function Internal_Osc_trim()
	local json_data = {}
	local results = {}
	local pass_fail_str

	local target_frequency = 12.5 -- Unit: MHz
	local freq_low_limit = 12.375
	local freq_high_limit = 12.625
	--local target_frequency = 386  -- Unit: MHz
	--local freq_low_limit = 381
	--local freq_high_limit = 391
	local best_frequency = 0
	local best_osc_ftrim = 0
	local min_diff = math.huge
	local pre_default_freq = 0

	--PPMU.CAL_EN(1)    --5V on
	--IIC_W_Tab2(0xFE, {0x1A, 0x00})
	IIC_W_Tab2(0xFE, { 0x1A, 0x00 }) --LOGICPTEST
	--IIC_W_Tab2(0xFE, {0x08, 0x00})
	--IIC_W_Tab2(0xFF, {0x03, 0x00})
	IIC_W_Tab2(0xFF, { 0x03, 0x02 }) --EDSTEST
	--IIC_R_Tab2(0xFF, 2)
	--IIC_R_Tab2(0xFE, 2)
	IIC_W_Tab2(0xF8, { 0x80, 0x10, 0x10, 0x10, 0x20, 0x10, 0x10, 0x25 })


	TIME.DELAY(200)
	pre_default_freq = F_CLK_IN_TEST()
	LOG.DEBUG(string.format("pre_default_fpreq = %.5f", pre_default_freq))

	for osc_ftrim = 0, 0x32 do
		--reg_0xF8[1] = osc_ftrim
		IIC_W_Tab2(0xF8, { osc_ftrim, 0x10, 0x10, 0x10, 0x20, 0x10, 0x10, 0x25 })

		TIME.DELAY(200)
		IIC_R_Tab2(0xF8, 8)

		local measured_freq = F_CLK_IN_TEST()
		LOG.DEBUG(string.format("===OSC_TRIM = %d,measured_freq = %.5f", osc_ftrim, measured_freq))
		local diff = math.abs(measured_freq - target_frequency)
		if diff < min_diff then
			min_diff = diff
			best_frequency = measured_freq
			best_osc_ftrim = osc_ftrim
		end
	end
	LOG.DEBUG(string.format("***best_trim: %d, bset_fre: %.5f", best_osc_ftrim, best_frequency))

	-- Step9: Identify the trim code that produces the closest match to 12.5 MHz
	-- Step10: Write optimal trim code to register
	--IIC_W_Tab2(0xF8, best_osc_ftrim)
	TIME.DELAY(50)

	local final_verify_freq = F_CLK_IN_TEST()

	if final_verify_freq >= freq_low_limit and final_verify_freq <= freq_high_limit and best_osc_ftrim >= 0 and best_osc_ftrim <= 0xFF then
		pass_fail_str = "PASS"
	else
		pass_fail_str = "FAIL"
	end

	--table.insert(results, pass_fail_str)
	table.insert(results, target_frequency)
	--table.insert(results, pre_default_freq)
	table.insert(results, best_osc_ftrim)
	table.insert(results, best_frequency)
	table.insert(results, final_verify_freq)

	local json_data = cjson.encode(results)
	LOG.INFO(json_data)

	return 0, json_data
end

function ConvertTo10BitBinary(num)
	-- 范围0 ~7.9921875
	if num < 0 then num = 0 end
	if num >= 8 then num = 7.9921875 end

	local raw_int = math.floor(num * 128)
	local bin_str = ""

	-- 从bit9循环到bit0
	for i = 9, 0, -1 do
		local bit = math.floor(raw_int / (2 ^ i)) % 2
		bin_str = bin_str .. tostring(bit)
		--3bit整数结束，i==7，插入小数点
		if i == 7 then
			bin_str = bin_str .. "."
		end
	end
	return bin_str, raw_int
end

function Bandgap_Trim()
	local tim1 = TIME.TICK()
	local target_voltage = 1.227
	local best_trim = 0
	local best_voltage = 0
	local results = {}
	local result_table = {}

	IIC_W_Tab2(0xE0, { 0x20, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF, 0x20 })
	DisplayOff()
	TIME.DELAY(100)
	DisplayOn()
	--IIC_W_Tab2(0xFD, {0x80, 0x10, 0x11})
	IIC_W_Tab2(0xFD, { 0x80, 0x00, 0x91 })

	--IIC_W_Tab2(0xFD, {0x00, 0x02, 0x94})

	PPMU.CAL_EN(0) --5V on

	GPIO6_A_SET(1)
	GPIO3_A_SET(0)
	GPIO2_A_SET(1)

	--IIC_W_Tab2(0xE0, {0x20,0x82,0x00,0x40,0x14,0x00,0x02,0xA0,0x02,0xA0,0x01,0xB0,0xCF,0x20})
	IIC_R_Tab2(0xE0, 14)
	IIC_R_Tab2(0xF2, 2)
	IIC_W_Tab2(0xF2, { 0x12, 0x00 })
	Power.ValueSetting.SMU2 = 0
	SMU2(ON, 1, 0x82)
	TIME.DELAY(1000)
	local Vol, leakageCurrent = POWER.VOL_CUR(P_SMU2)
	LOG.INFO(string.format("Preset Vol:%f", Vol))

	--IIC_W_Tab2(0xF8, {0x72,0x10,0x10,0x10,0x20,0x10,0x10,0x25,0x0A,0x0A,0x3F,0x33,0x3F,0x01,0xFF})

	--IIC_W_Tab2(0xF8, {0x72,0x10,0x10,0x10,0x3F,0x10,0x10,0x25,0x0A,0x0A,0x03})
	for bgr_ibias = 0, 3 do
		for main_ibias = 0, 15 do
			--trim_byte = (trim_code << 4) | 0x08
			--trim_byte = 0x80 | trim_code
			--trim_byte = (trim_code << 4) | trim_code
			--trim_byte = (trim_code << 4) | 0x03
			--trim_byte = trim_code & 0x3F
			trim_byte = (bgr_ibias << 4) | main_ibias
			IIC_W_Tab2(0xF8, { 0x72, 0x10, 0x10, 0x10, 0x20, 0x10, 0x10, 0x25, 0x0A, 0x0A, trim_byte })
			--0x11,0x20,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
			--0x20,0x20,0x20,0x20,trim_byte})
			LOG.INFO(string.format("trim_byte = 0x%x", trim_byte))
			TIME.DELAY(200)
			local measure_voltage, measure_current = POWER.VOL_CUR(P_SMU2)

			--local average_voltage = 0
			--for i =0, 10 do
			--TIME.DELAY(10)
			--local measure_voltage, measure_current = POWER.VOL_CUR(P_SMU2)
			--average_voltage = average_voltage + measure_voltage
			--end
			--average_voltage = average_voltage / 11

			LOG.INFO(string.format("BGR_IBIAS = %d,VOL= %.6f", trim_byte, measure_voltage))
			table.insert(result_table, measure_voltage)
			if math.abs(measure_voltage - target_voltage) < math.abs(best_voltage - target_voltage) then
				best_voltage = measure_voltage
				best_trim = trim_byte
				LOG.INFO(string.format("best_voltage:%.6f", best_voltage))
			end
		end
	end
	LOG.INFO(string.format("best_trim= %d, best_voltage:%.6f", best_trim, best_voltage))

	table.insert(result_table, best_voltage)
	table.insert(result_table, best_trim)
	local json_data = cjson.encode(result_table)
	LOG.INFO(json_data)

	Power.ValueSetting.DVDD = 800
	DVDD(ON)
	PPMU.CAL_EN(1)
	GPIO6_A_SET(1)
	GPIO3_A_SET(0)
	GPIO2_A_SET(1)
	TIME.DELAY(20)
	SMU2(OFF, 0)

	return 0, json_data
end

-----done
function apply_DAC_calibration_code()
	println("apply_DAC_calibration_code")
	println("DAC_calibration_code:0x%X", DAC_calibration_code)
	IIC_W_Tab2(0xF8, DAC_cal_buf)
	println("Apply DAC_calibration_code:0x%08X", DAC_calibration_code)
end

--apply_DAC_CAL_code(10)
function apply_DAC_CAL_code(DAC_CAL_code)
	println("apply_DAC_CAL_code")
	DAC_calibration_code = DAC_CAL_code
	println("DAC_calibration_code:0x%X", DAC_calibration_code)
	IIC_W_Tab2(0xF8, DAC_cal_buf)
	println("Apply DAC_calibration_code:0x%08X", DAC_calibration_code)
end

------done



--apply_DAC_WORD_code(300)
function apply_DAC_WORD_code(DAC_WORD_code)
	println("apply_DAC_WORD_code")
	println("DAC_WORD_code:0x%X", DAC_WORD_code)
	IIC_W_Tab2(0xDC, DAC_WORD_code)
	println("Apply DAC_WORD_code:0x%08X", DAC_WORD_code)
end

--[[
Function: Temperature_Sensor_ADC
Desc: Read temperature sensor raw ADC code. Unlock register, configure TSL/TSR temperature sensor, only fetch raw 10bit code without converting to Celsius temperature.
Input: None
Return:
    0          : Function complete status
    json_data  : Json array [TSL_RAW_CODE, TSR_RAW_CODE]
--]]
function Temperature_Sensor_ADC()
	local results = {}
	IIC_W_Tab2(0xF0, { 0x5a, 0x5a }) -- Level2 Key
	IIC_W_Tab2(0xF1, { 0x5a, 0x5a }) -- OTP Key
	IIC_W_Tab2(0xFc, { 0x5a, 0x5a }) -- third key

	IIC_W_Tab2(0xFE, { 0x02, 0x03 })

	-- 温度控制寄存器配置
	IIC_W_Tab2(0xE0,
		{ 0x30, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF, 0x30, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F }) --Temperature Control
	IIC_W_Tab2(0xE0,
		{ 0x78, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF, 0x78, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F }) --Temperature Control
	IIC_W_Tab2(0xE0,
		{ 0x70, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF, 0x70, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F }) --Temperature Control
	--IIC_W_Tab2(0xE0,0x70)

	local _, readData = IIC_R_Tab2(0xE1, 4)
	-- rData[1] → 1st P: TSL_DATA_OUT[9:8]
	-- rData[2] → 2nd P: TSL_DATA_OUT[7:0]
	-- rData[3] → 3rd P: TSR_DATA_OUT[9:8]
	-- rData[4] → 4th P: TSR_DATA_OUT[7:0]
	local tsl_high    = readData[1] & 0x03 -- 低2bit
	local tsl_low     = readData[2] & 0xFF
	local TSL_CODE    = (tsl_high << 8) | tsl_low

	local tsr_high    = readData[3] & 0x03 -- 低2bit
	local tsr_low     = readData[4] & 0xFF
	local TSR_CODE    = (tsr_high << 8) | tsr_low


	--local function Code2Temp(code)
	---- 292(-25℃) ~ 732(85℃)
	--if code < 292 or code >732 then
	--return nil
	--end
	--return -25 + (code - 292) * 0.25
	--end

	--local tempLeft = Code2Temp(TSL_CODE)
	--local tempRight = Code2Temp(TSR_CODE)

	--LOG.INFO(string.format("TSL_CODE = %d, Left Temp = %s ℃", TSL_CODE, tostring(tempLeft or "OutRange")))
	--LOG.INFO(string.format("TSR_CODE = %d, Right Tmp = %s ℃", TSR_CODE, tostring(tempRight or "OutRange")))


	--table.insert(results,tempLeft)
	--table.insert(results,tempRight)
	table.insert(results, TSL_CODE)
	table.insert(results, TSR_CODE)


	local json_data = cjson.encode(results)
	LOG.INFO(json_data)
	return 0, json_data
end


PWM_CASES = {
	-- Test (1): T_nov1 sweep (T_PWMSET - T_CMPSET)
	[0]  = { fa = { 0x91, 0x00 }, e4 = { 0x00, 0x08, 0x08, 0x09, 0x12, 0x00 }, pw = 360, set = 10, param = "T_nov1", pat = 0 },
	[1]  = { fa = { 0x91, 0x00 }, e4 = { 0x00, 0x08, 0x08, 0x0A, 0x13, 0x00 }, pw = 380, set = 20, param = "T_nov1", pat = 0 },
	[2]  = { fa = { 0x91, 0x00 }, e4 = { 0x00, 0x08, 0x08, 0x0B, 0x14, 0x00 }, pw = 400, set = 30, param = "T_nov1", pat = 0 },
	[3]  = { fa = { 0x91, 0x00 }, e4 = { 0x00, 0x08, 0x08, 0x0C, 0x15, 0x00 }, pw = 420, set = 40, param = "T_nov1", pat = 0 },
	[4]  = { fa = { 0x91, 0x00 }, e4 = { 0x00, 0x08, 0x08, 0x0D, 0x16, 0x00 }, pw = 440, set = 50, param = "T_nov1", pat = 0 },

	-- Test (2): T_PCHGB sweep
	[5]  = { fa = { 0x91, 0x80 }, e4 = { 0x00, 0x03, 0x03, 0x07, 0x10, 0x00 }, pw = 320, set = 30, param = "T_PCHGB", pat = 128 },
	[6]  = { fa = { 0x91, 0x80 }, e4 = { 0x00, 0x04, 0x04, 0x08, 0x11, 0x00 }, pw = 340, set = 40, param = "T_PCHGB", pat = 128 },
	[7]  = { fa = { 0x91, 0x80 }, e4 = { 0x00, 0x05, 0x05, 0x09, 0x12, 0x00 }, pw = 360, set = 50, param = "T_PCHGB", pat = 128 },
	[8]  = { fa = { 0x91, 0x80 }, e4 = { 0x00, 0x06, 0x06, 0x0A, 0x13, 0x00 }, pw = 380, set = 60, param = "T_PCHGB", pat = 128 },
	[9]  = { fa = { 0x91, 0x80 }, e4 = { 0x00, 0x07, 0x07, 0x0B, 0x14, 0x00 }, pw = 400, set = 70, param = "T_PCHGB", pat = 128 },
	[10] = { fa = { 0x91, 0x80 }, e4 = { 0x00, 0x08, 0x08, 0x0C, 0x15, 0x00 }, pw = 420, set = 80, param = "T_PCHGB", pat = 128 },
	[11] = { fa = { 0x91, 0x80 }, e4 = { 0x00, 0x09, 0x09, 0x0D, 0x16, 0x00 }, pw = 440, set = 90, param = "T_PCHGB", pat = 128 },

	-- Test (3): T_nov2 sweep (T_CMPSET - T_PCHGB)
	[12] = { fa = { 0x91, 0x00 }, e4 = { 0x00, 0x08, 0x08, 0x0C, 0x15, 0x00 }, pw = 340, set = 0, param = "PWMSET", pat = 0 },
	[13] = { fa = { 0x91, 0x00 }, e4 = { 0x00, 0x08, 0x09, 0x0D, 0x16, 0x00 }, pw = 360, set = 10, param = "PWMSET", pat = 0 },
	[14] = { fa = { 0x91, 0x00 }, e4 = { 0x00, 0x08, 0x0A, 0x0E, 0x17, 0x00 }, pw = 380, set = 20, param = "PWMSET", pat = 0 },

	-- Test (4): T_PWMTPW sweep (black/white pairs)
	[15] = { fa = { 0x91, 0x00 }, e4 = { 0x00, 0x08, 0x08, 0x0C, 0x10, 0x00 }, pw = 320, set = 40, param = "PWMSET", pat = 0 },
	[16] = { fa = { 0x91, 0xFF }, e4 = { 0x00, 0x08, 0x08, 0x0C, 0x10, 0x00 }, pw = 320, set = 40, param = "PWMSET", pat = 255 },
	[17] = { fa = { 0x91, 0x00 }, e4 = { 0x00, 0x08, 0x08, 0x0C, 0x11, 0x00 }, pw = 340, set = 50, param = "PWMSET", pat = 0 },
	[18] = { fa = { 0x91, 0xFF }, e4 = { 0x00, 0x08, 0x08, 0x0C, 0x11, 0x00 }, pw = 340, set = 50, param = "PWMSET", pat = 255 },
	[19] = { fa = { 0x91, 0x00 }, e4 = { 0x00, 0x08, 0x08, 0x0C, 0x12, 0x00 }, pw = 360, set = 60, param = "PWMSET", pat = 0 },
	[20] = { fa = { 0x91, 0xFF }, e4 = { 0x00, 0x08, 0x08, 0x0C, 0x12, 0x00 }, pw = 360, set = 60, param = "PWMSET", pat = 255 },
	[21] = { fa = { 0x91, 0x00 }, e4 = { 0x00, 0x08, 0x08, 0x0C, 0x13, 0x00 }, pw = 380, set = 70, param = "PWMSET", pat = 0 },
	[22] = { fa = { 0x91, 0xFF }, e4 = { 0x00, 0x08, 0x08, 0x0C, 0x13, 0x00 }, pw = 380, set = 70, param = "PWMSET", pat = 255 },
	[23] = { fa = { 0x91, 0x00 }, e4 = { 0x00, 0x08, 0x08, 0x0C, 0x14, 0x00 }, pw = 400, set = 80, param = "PWMSET", pat = 0 },
	[24] = { fa = { 0x91, 0xFF }, e4 = { 0x00, 0x08, 0x08, 0x0C, 0x14, 0x00 }, pw = 400, set = 80, param = "PWMSET", pat = 255 },
	[25] = { fa = { 0x91, 0x00 }, e4 = { 0x00, 0x08, 0x08, 0x0C, 0x15, 0x00 }, pw = 420, set = 90, param = "PWMSET", pat = 0 },
	[26] = { fa = { 0x91, 0xFF }, e4 = { 0x00, 0x08, 0x08, 0x0C, 0x15, 0x00 }, pw = 420, set = 90, param = "PWMSET", pat = 255 },

	-- Test (5a): pulse-width sweep @ Flat Field GL128
	[27] = { fa = { 0x91, 0x80 }, e4 = { 0x00, 0x05, 0x05, 0x08, 0x0E, 0x00 }, pw = 280, set = nil, param = "PWMSET", pat = 128 },
	[28] = { fa = { 0x91, 0x80 }, e4 = { 0x00, 0x05, 0x05, 0x08, 0x0F, 0x00 }, pw = 300, set = nil, param = "PWMSET", pat = 128 },
	[29] = { fa = { 0x91, 0x80 }, e4 = { 0x00, 0x05, 0x05, 0x09, 0x0F, 0x00 }, pw = 300, set = nil, param = "PWMSET", pat = 128 },
	[30] = { fa = { 0x91, 0x80 }, e4 = { 0x00, 0x05, 0x05, 0x09, 0x10, 0x00 }, pw = 320, set = nil, param = "PWMSET", pat = 128 },
	[31] = { fa = { 0x91, 0x80 }, e4 = { 0x00, 0x05, 0x05, 0x09, 0x0E, 0x00 }, pw = 280, set = nil, param = "PWMSET", pat = 128 },
	[32] = { fa = { 0x91, 0x80 }, e4 = { 0x00, 0x05, 0x05, 0x08, 0x0D, 0x00 }, pw = 260, set = nil, param = "PWMSET", pat = 128 },
	[33] = { fa = { 0x91, 0x80 }, e4 = { 0x00, 0x04, 0x04, 0x08, 0x0D, 0x00 }, pw = 260, set = nil, param = "PWMSET", pat = 128 },
	[34] = { fa = { 0x91, 0x80 }, e4 = { 0x00, 0x04, 0x04, 0x07, 0x0C, 0x00 }, pw = 240, set = nil, param = "PWMSET", pat = 128 },

	-- Test (5b): same sweep @ Flat Field GL1
	[35] = { fa = { 0x91, 0x01 }, e4 = { 0x00, 0x05, 0x05, 0x08, 0x0E, 0x00 }, pw = 280, set = nil, param = "PWMSET", pat = 1 },
	[36] = { fa = { 0x91, 0x00 }, e4 = { 0x00, 0x05, 0x05, 0x08, 0x0F, 0x00 }, pw = 300, set = nil, param = "PWMSET", pat = 1 },
	[37] = { fa = { 0x91, 0x01 }, e4 = { 0x00, 0x05, 0x05, 0x09, 0x0F, 0x00 }, pw = 300, set = nil, param = "PWMSET", pat = 1 },
	[38] = { fa = { 0x91, 0x01 }, e4 = { 0x00, 0x05, 0x05, 0x09, 0x10, 0x00 }, pw = 320, set = nil, param = "PWMSET", pat = 1 },
	[39] = { fa = { 0x91, 0x01 }, e4 = { 0x00, 0x05, 0x05, 0x09, 0x0E, 0x00 }, pw = 280, set = nil, param = "PWMSET", pat = 1 },
	[40] = { fa = { 0x91, 0x01 }, e4 = { 0x00, 0x05, 0x05, 0x08, 0x0D, 0x00 }, pw = 260, set = nil, param = "PWMSET", pat = 1 },
	[41] = { fa = { 0x91, 0x01 }, e4 = { 0x00, 0x04, 0x04, 0x08, 0x0D, 0x00 }, pw = 260, set = nil, param = "PWMSET", pat = 1 },
	[42] = { fa = { 0x91, 0x01 }, e4 = { 0x00, 0x04, 0x04, 0x07, 0x0C, 0x00 }, pw = 240, set = nil, param = "PWMSET", pat = 1 },

	-- Test (5c): same sweep @ Flat Field GL254
	[43] = { fa = { 0x91, 0xFE }, e4 = { 0x00, 0x05, 0x05, 0x08, 0x0E, 0x00 }, pw = 280, set = nil, param = "PWMSET", pat = 254 },
	[44] = { fa = { 0x91, 0xFE }, e4 = { 0x00, 0x05, 0x05, 0x08, 0x0F, 0x00 }, pw = 300, set = nil, param = "PWMSET", pat = 254 },
	[45] = { fa = { 0x91, 0xFE }, e4 = { 0x00, 0x05, 0x05, 0x09, 0x0F, 0x00 }, pw = 300, set = nil, param = "PWMSET", pat = 254 },
	[46] = { fa = { 0x91, 0xFE }, e4 = { 0x00, 0x05, 0x05, 0x09, 0x10, 0x00 }, pw = 320, set = nil, param = "PWMSET", pat = 254 },
	[47] = { fa = { 0x91, 0xFE }, e4 = { 0x00, 0x05, 0x05, 0x09, 0x0E, 0x00 }, pw = 280, set = nil, param = "PWMSET", pat = 254 },
	[48] = { fa = { 0x91, 0xFE }, e4 = { 0x00, 0x05, 0x05, 0x08, 0x0D, 0x00 }, pw = 260, set = nil, param = "PWMSET", pat = 254 },
	[49] = { fa = { 0x91, 0xFE }, e4 = { 0x00, 0x04, 0x04, 0x08, 0x0D, 0x00 }, pw = 260, set = nil, param = "PWMSET", pat = 254 },
	[50] = { fa = { 0x91, 0xFE }, e4 = { 0x00, 0x04, 0x04, 0x07, 0x0C, 0x00 }, pw = 240, set = nil, param = "PWMSET", pat = 254 },

}

PWM_CASE_MIN = 0
PWM_CASE_MAX = 50

-- helper: format a byte table as hex for logging
local function hexstr(t)
	local parts = {}
	for i = 1, #t do parts[i] = string.format("0x%02X", t[i]) end
	return "{" .. table.concat(parts, ",") .. "}"
end

-- log line: swap print() for your harness's logger if needed
function PWM_log(msg)
	print(msg)
	-- TheExec.Datalog.WriteComment(msg)   -- IG-XL datalog
end


---new duty cycle-----
-- Program duty cycle via EOTF_Bypass_Value[11:0]
-- ON_TIME    = EOTF_Bypass_Value * 10 * 256 * 2   (in TIME_UNIT_S units)
-- duty_cycle = ON_TIME / (1 / refresh_rate) * 100

local TIME_UNIT_S = 1e-9         -- time base of ON_TIME formula (assumed 1 ns)
local STEP        = 10 * 256 * 2 -- 5120 units per count
local MAX_VALUE   = 0xFFF        -- 12-bit register field

-- Input : refresh_hz (e.g. 90), duty_pct (0..100)
-- Output: EOTF_Bypass_Value[7:0], EOTF_Bypass_Value[11:8], full value, actual duty %
function calc_EOTF_Bypass_Value(refresh_hz, duty_pct)
	assert(refresh_hz > 0, "refresh rate must be > 0")
	assert(duty_pct >= 0 and duty_pct <= 100, "duty must be 0..100 %")

	local frame_s = 1 / refresh_hz        -- 90 Hz -> 11.111 ms
	local on_s    = frame_s * duty_pct / 100 -- required ON_TIME
	local value   = math.floor(on_s / (STEP * TIME_UNIT_S) + 0.5)

	if value > MAX_VALUE then
		LOG.INFO(string.format("WARNING: value %d > 0xFFF, clamping", value))
		value = MAX_VALUE
	end

	local val_7_0     = value % 256               -- EOTF_Bypass_Value[7:0]
	local val_11_8    = math.floor(value / 256) % 16 -- EOTF_Bypass_Value[11:8]

	local actual_duty = (value * STEP * TIME_UNIT_S) / frame_s * 100
	return val_7_0, val_11_8, value, actual_duty
end

-- Replace with your actual register write
local function write_reg(name, val)
	LOG.INFO(string.format("  %-24s = 0x%02X", name, val))
end

--Set_Duty_Cycle(90, 1)
function Set_Duty_Cycle(refresh_hz, duty_pct)
	local v7_0, v11_8, value, actual = calc_EOTF_Bypass_Value(refresh_hz, duty_pct)
	LOG.INFO(string.format("%g Hz, %.2f%% -> EOTF_Bypass_Value = 0x%03X (%d), actual %.4f%%",
		refresh_hz, duty_pct, value, value, actual))
	write_reg("EOTF_Bypass_Value[7:0]", v7_0)
	write_reg("EOTF_Bypass_Value[11:8]", v11_8)


	--IIC_W_Tab2(0xE5,{0x00,0x2A,0x80,0x01,0x54,0x00,0x40,0x00,0x10,0x01,0x00,0x00,0x00})  --PWM Timing Gen
	--TIME.DELAY(20)
	IIC_W_Tab2(0xfb, { 0x07, 0x27, 0xe5, 0x01, 0x03, v11_8, v7_0, 0x00, 0x00 })
	IIC_R_Tab2(0xfb, 10)
	TIME.DELAY(100)
	IIC_W_Tab2(0xf4, { 0x1 })

	return v7_0, v11_8
end

---duty cycle-----

--------------------------------------------------------current-----------------------------------
-- Program uLED current via BIASTOP_GLBC[8:0]
-- I_LED = BIASTOP_GLBC * 21 nA

local LSB_NA    = 21    -- 21 nA per code
local MAX_VALUE = 0x1FF -- 9-bit field (511)

-- Input : current_ua (uA)
-- Output: BIASTOP_GLBC[7:0], BIASTOP_GLBC[8:8], full code, actual current (uA)
function calc_BIASTOP_GLBC(current_ua)
	assert(current_ua and current_ua >= 0, "current must be >= 0 uA")

	local value = math.floor(current_ua * 1000 / LSB_NA + 0.5) -- round to nearest code

	if value > MAX_VALUE then
		LOG.INFO(string.format("WARNING: %.3f uA exceeds max %.3f uA, clamping",
			current_ua, MAX_VALUE * LSB_NA / 1000))
		value = MAX_VALUE
	end

	local val_7_0   = value % 256              -- BIASTOP_GLBC[7:0]
	local val_8     = math.floor(value / 256) % 2 -- BIASTOP_GLBC[8:8]

	local actual_ua = value * LSB_NA / 1000
	return val_7_0, val_8, value, actual_ua
end

-- Replace with your actual register write
local function write_reg_cur(name, val)
	LOG.INFO(string.format("  %-18s = 0x%02X", name, val))
end


--Set_Pixel_Current(5.2)
function Set_Pixel_Current(current_ua)
	local v7_0, v8, value, actual = calc_BIASTOP_GLBC(current_ua)
	LOG.INFO(string.format("%.3f uA -> BIASTOP_GLBC = 0x%03X (%d), actual %.3f uA",
		current_ua, value, value, actual))
	write_reg_cur("BIASTOP_GLBC[7:0]", v7_0)
	write_reg_cur("BIASTOP_GLBC[8:8]", v8)

	IIC_W_Tab2(0xf6, { 00, v8, v7_0 })

	return v7_0, v8
end

---------------------------------------------currnet------------------------------


--Input : color = "Red" / "Green" / "Blue"
--Set_Device_Condition_By_Color("Red")
function Set_Device_Condition_By_Color(color)
	local colorParam = {
		Red = { avee = -2300, pixel_uA = 2.0, dutyPct = 4.59, target_delta = 0.01},
		Green = { avee = -3000, pixel_uA = 0.8, dutyPct = 4.59, target_delta = 0.025},
		Blue = { avee = -3000, pixel_uA = 0.4, dutyPct = 4.59, target_delta = 0.05},
	}

	local cfg        = colorParam[color]
	if cfg == nil then
		LOG.ERROR(string.format("Set_Device_Condition_byColor invalid [%s]", color))
		return 0
	end
	--Set AVEE Voltage
	POWER.SINGLE_SET(Power.ChannelSetting.AVEE1, 1, 0x85, Power.CONSTANT_VOLTAGE, cfg.avee, Power.OVPSetting.AVEE1,
		Power.UVPSetting.AVEE1, Power.OCPSetting.AVEE1, Power.UCPSetting.AVEE1, Power.UCPSetting.AVEE1)

	--Set Pixel Current
	Set_Pixel_Current(cfg.pixel_uA)

	--Set duty Duty_cycle (refresh set to 90Hz)
	Set_Duty_Cycle(90, cfg.dutyPct)

	LOG.INFO(string.format("[Setup OK] Color :%s, AVEE:%dmV, PixelCurrent:%.2fuA,DutyCycle:%.2f",
		color, cfg.avee, cfg.pixel_uA, cfg.dutyPct))
	return colorParam
end

--Warm_Up_Condition("Green")
function Warm_Up_Condition(color)
	local colorParam = {
		Red = { avee = -5000, pixel_uA = 3.2, dutyPct = 4.59 },
		Green = { avee = -5000, pixel_uA = 3.2, dutyPct = 9 },
		Blue = { avee = -5000, pixel_uA = 3.2, dutyPct = 9 },
	}

	local cfg        = colorParam[color]
	if cfg == nil then
		LOG.ERROR(string.format("Set_Device_Condition_byColor invalid [%s]", color))
		return 0
	end
	
	--Set AVEE Voltage
	POWER.SINGLE_SET(Power.ChannelSetting.AVEE1, 1, 0x85, Power.CONSTANT_VOLTAGE, cfg.avee, Power.OVPSetting.AVEE1,
		Power.UVPSetting.AVEE1, Power.OCPSetting.AVEE1, Power.UCPSetting.AVEE1, Power.UCPSetting.AVEE1)

	--Set Pixel Current
	Set_Pixel_Current(cfg.pixel_uA)

	--Set duty Duty_cycle (refresh set to 90Hz)
	Set_Duty_Cycle(90, cfg.dutyPct)

	LOG.INFO(string.format("[Setup OK] Color :%s, AVEE:%dmV, PixelCurrent:%.2fuA,DutyCycle:%.2f",
		color, cfg.avee, cfg.pixel_uA, cfg.dutyPct))

	return 1
end

---------------------------------------------------------------------------------

--- Calibrates one on-chip temperature sensor (TSR or TSL) so its DATA_OUT reads 50'C.
-- Trims <side>_TOP_TRIM[5:0] and <side>_BOT_TRIM[5:0] together with a binary
-- search over 0~63 until <side>_DATA_OUT equals the 50'C code.
-- Temperature relation (E1h datasheet): Code = 392 + 4 * T('C), so 50'C = 592.
-- F8h data : [25] TSL_TOP, [26] TSR_TOP, [27] TSL_BOT, [28] TSR_BOT.
-- E1h data : bytes 1-2 = TSL_DATA_OUT[9:0], bytes 3-4 = TSR_DATA_OUT[9:0].
-- Setup per test plan: F0h/F1h/FCh keys, FEh LOGICIPTEST = {0x02, 0x03}, then the
-- 3x E0h Temperature Control sequence (re-issued before every read; the first E1h
-- read of each measurement is a dummy).
-- If the other sensor was already calibrated, its trim code (TSL_calibration_code /
-- TSR_calibration_code) is preserved in the F8h payload while this side is searched.
-- The winning code is left written to F8h and stored in global TSR_calibration_code
-- or TSL_calibration_code.
-- @param side string  "TSR" (right sensor) or "TSL" (left sensor).
-- @usage Temp_Sensor_Cal("TSR", 1)   -- calibrate right sensor, sets TSR_calibration_code
-- @usage Temp_Sensor_Cal("TSL", 1)   -- calibrate left sensor,  sets TSL_calibration_code
-- @return number status  0 on completion, 1 if side is not "TSR"/"TSL".
-- @return string json cjson array [best_trim, best_temp_C].
-- @see VPG_SetFlatField
function Temp_Sensor_Cal(side, otp_Enable)
	local function make_ts_trim_payload(tsl_trim, tsr_trim)
		return {
			0x72, 0x10, 0x10, 0x10, 0x20, 0x10, 0x10, 0x25,
			0x0A, 0x0A, 0x03, 0x11, 0x20,
			0x01, 0x00,
			0x08, 0x08, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			tsl_trim & 0x3F, -- data 25 : TSL_TOP[5:0]
			tsr_trim & 0x3F, -- data 26 : TSR_TOP[5:0]
			tsl_trim & 0x3F, -- data 27 : TSL_BOT[5:0]
			tsr_trim & 0x3F, -- data 28 : TSR_BOT[5:0]
			0x88, 0x02, 0x00, 0x02, 0x00, 0x00
		}
	end

	local results = {}
	local temp_table = {}
	local best_trim = nil
	local best_diff = math.huge
	local target_C = 50.0
	local target_code = 392 + 4 * target_C -- 592
	local best_code = nil
	local best_temp = nil
	local notFound = 0
	local meas_count = 0

	if side ~= "TSR" and side ~= "TSL" then -- only reject when it matches neither
		LOG.INFO("Temp_Sensor_Cal: side must be \"TSR\" or \"TSL\"")
		return 1, cjson.encode(results)
	end

	--VPG_SetFlatField(0)
	TIME.DELAY(500)

	-- keep the other sensor's trim if it was already calibrated
	local other_trim = 0
	if side == "TSR" and TSL_calibration_code ~= nil then other_trim = TSL_calibration_code end
	if side == "TSL" and TSR_calibration_code ~= nil then other_trim = TSR_calibration_code end

	local tim1 = TIME.TICK()

	-- I2C keys : unlock protected register banks
	IIC_W_Tab2(0xF0, { 0x5a, 0x5a }) -- F0h Level2 key
	IIC_W_Tab2(0xF1, { 0x5a, 0x5a }) -- F1h OTP (eFuse) key
	IIC_W_Tab2(0xFC, { 0x5a, 0x5a }) -- FCh 3rd key
	-- FEh LOGICIPTEST : {0x02, 0x03} → enable OTP_OSC_DIV and MIPI_OSC_DIV for temp sensor path
	IIC_W_Tab2(0xFE, { 0x02, 0x03 })

	-- E0h Temperature Control : enable temp-sensor readout (3 configs, each writes 26 bytes)
	-- Each entry configures a sensor channel with bias/current/settling parameters
	IIC_W_Tab2(0xE0, { 0x30, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF,
		0x30, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F })
	IIC_W_Tab2(0xE0, { 0x78, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF,
		0x78, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F })
	IIC_W_Tab2(0xE0, { 0x70, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF,
		0x70, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F })
	TIME.DELAY(10)

	-- write trim, read temperature code, track best
	local function measure(trim_val)
		-- F8h TRIM : set TSR/TSL TOP and BOT trim codes (bytes 25-28)
		-- only the requested side's trim changes; the other side keeps its existing code
		if side == "TSR" then
			IIC_W_Tab2(0xF8, make_ts_trim_payload(other_trim, trim_val)) -- TSL=other_trim, TSR=trim_val
		else
			IIC_W_Tab2(0xF8, make_ts_trim_payload(trim_val, other_trim)) -- TSL=trim_val, TSR=other_trim
		end
		-- Re-issue E0h Temperature Control after each trim write so the ADC
		-- sees freshly-configured bias/current parameters before reading back
		IIC_W_Tab2(0xE0, { 0x30, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF,
			0x30, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F })
		IIC_W_Tab2(0xE0, { 0x78, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF,
			0x78, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F })
		IIC_W_Tab2(0xE0, { 0x70, 0x82, 0x00, 0x40, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0xCF,
			0x70, 0x82, 0x00, 0x41, 0x14, 0x00, 0x02, 0xA0, 0x02, 0xA0, 0x01, 0xB0, 0x1F })

		TIME.DELAY(50)
		IIC_R_Tab2(0xF8, 34) -- read F8h back to latch trim values

		-- E1h Temperature State : first read throws away stale conversion;
		-- second read returns fresh TSL/TSR codes (bytes 1-2 = TSL, 3-4 = TSR)
		IIC_R_Tab2(0xE1, 4)         -- 1st read (dummy, flush stale)
		local _, rd = IIC_R_Tab2(0xE1, 4) -- 2nd read : assumes byte table returned, MSB first
		local tsl_code = ((rd[1] & 0x03) << 8) | rd[2]
		local tsr_code = ((rd[3] & 0x03) << 8) | rd[4]
		local code = tsr_code
		if side == "TSL" then code = tsl_code end
		local temp = (code - 392) / 4

		meas_count = meas_count + 1
		LOG.INFO(string.format("%s trim=%d TSL_OUT=%d TSR_OUT=%d Temp=%.2fC", side, trim_val, tsl_code, tsr_code, temp))
		table.insert(temp_table, { trim = trim_val, code = code, temp = temp })

		local diff = math.abs(code - target_code)
		if diff < best_diff then
			best_diff = diff
			best_trim = trim_val
			best_code = code
			best_temp = temp
			LOG.INFO(string.format("[%02d] %s best temp out: %.2fC", best_trim, side, best_temp))
		end
		return code
	end

	----------------------------------------------------------------
	-- Binary search over 6-bit trim code (0 ~ 63) for target 50'C.
	-- 1) Measure both ends to learn slope direction and confirm the
	--    target code (592) is inside the sensor's range.
	-- 2) Bisect until lo/hi are adjacent codes bracketing the target.
	-- 3) best_trim = whichever measured code is closest (tracked in measure()).
	-- Total: 2 + ceil(log2(63)) = ~8 measurements (vs. a full 64-code sweep).
	----------------------------------------------------------------
	local lo = 0
	local hi = 63
	local code_lo = measure(lo)
	local code_hi = measure(hi)
	local increasing = (code_hi >= code_lo)


	IIC_R_Tab2(0xF8, 34) -- no-op (read-back only)
	IIC_R_Tab2(0xE1, 4) -- no-op (dummy read, result unused)


	if target_code < math.min(code_lo, code_hi) or target_code > math.max(code_lo, code_hi) then
		notFound = 1
		LOG.INFO(string.format("%s: 50C not reachable in trim range 0~63", side))
	else
		while (hi - lo) > 1 do
			local mid = (lo + hi) // 2
			local code = measure(mid)
			if (code >= target_code) == increasing then
				hi = mid
			else
				lo = mid
			end
		end
	end

	-- Write final winning trim code back to F8h and latch it
	-- F8h TRIM bytes 25-28 : <side>_TOP_TRIM[5:0] + <side>_BOT_TRIM[5:0]
	-- The other sensor's trim (already calibrated) is preserved via other_trim
	if side == "TSR" then
		TSR_calibration_code = best_trim
		if otp_Enable == 1 then
			OTP_Write(other_trim, best_trim)
		else
			IIC_W_Tab2(0xF8, make_ts_trim_payload(other_trim, best_trim)) -- TSL=other_trim, TSR=best_trim
		end
	else
		TSL_calibration_code = best_trim
		if otp_Enable == 1 then
			OTP_Write(best_trim, other_trim)
		else
			IIC_W_Tab2(0xF8, make_ts_trim_payload(best_trim, other_trim)) -- TSL=best_trim, TSR=other_trim
		end
	end
	
	TIME.DELAY(50)
	IIC_R_Tab2(0xF8, 34) -- read-back to confirm trim latched
	
	local tim2 = TIME.TICK()
	LOG.INFO(side .. "_Cal time: " .. string.format("%.3f", (tim2 / 1000 - tim1 / 1000)) .. "seconds")
	LOG.INFO(string.format("[%02d] %s best temp out:%.2fC (code=%d, notFound=%d)", best_trim, side, best_temp, best_code,
		notFound))

	table.insert(results, best_trim)
	table.insert(results, best_temp)
	--table.insert(results, notFound)

	local json_data = cjson.encode(results)
	LOG.INFO(json_data)
	return 0, json_data
end

local function make_ts_trim_payload_otp(tsl_trim, tsr_trim)

    assert(
        type(tsl_trim) == "number"
            and tsl_trim == math.floor(tsl_trim)
            and tsl_trim >= 0
            and tsl_trim <= 0x3F,
        "tsl_trim must be an integer in 0..63"
    )

    assert(
        type(tsr_trim) == "number"
            and tsr_trim == math.floor(tsr_trim)
            and tsr_trim >= 0
            and tsr_trim <= 0x3F,
        "tsr_trim must be an integer in 0..63"
    )

    return {
        -- data 1～8
        0x72, 0x10, 0x10, 0x10, 0x20, 0x10, 0x10, 0x25,

        -- data 9～13
        0x0A, 0x0A, 0x03, 0x11, 0x20,

        -- data 14～15：像素电流Trim
        0x01, 0x00,

        -- data 16～24
        0x08, 0x08, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,

        -- data 25～28：温度Trim
        tsl_trim & 0x3F, -- data 25：TSL_TOP
        tsr_trim & 0x3F, -- data 26：TSR_TOP
        tsl_trim & 0x3F, -- data 27：TSL_BOT
        tsr_trim & 0x3F, -- data 28：TSR_BOT

        -- data 29～34
        0x88, 0x02, 0x00, 0x02, 0x00, 0x00
    }
end


--[[
Function: OTP_Write
Input:
    tsl_trim：TSL校准值，整数0～63
    tsr_trim：TSR校准值，整数0～63
Return:
    1：写入流程执行结束，未进行回读校验
--]]
--OTP_Write(0x27, 0x2d)
function OTP_Write(tsl_trim, tsr_trim)

    -- 根据传入值组装F8数据
    local trim_buf = make_ts_trim_payload_otp(tsl_trim, tsr_trim)

    -- 开启烧录电源
    --VQPS(ON)
    --TIME.DELAY(1000)

    -- Level2解锁
    IIC_W_Tab2(0xF0, {0x5A, 0x5A})
    IIC_W_Tab2(0xF1, {0x5A, 0x5A})
	IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key

    -- 写入完整Trim数据
    IIC_R_Tab2(0xF8, 34)
    IIC_W_Tab2(0xF8, trim_buf)

    VQPS(ON)
    TIME.DELAY(1000)

    -- 触发OTP烧录
 
	IIC_W_Tab2(0xC0, {0x00,0x06})

    -- 等待大于22ms
    TIME.DELAY(100)

    -- 清除OTP控制
    IIC_W_Tab2(0xC0, {0x00, 0x00})

    -- 上锁
    IIC_W_Tab2(0xF0, {0xA5, 0xA5})
    IIC_W_Tab2(0xF1, {0xA5, 0xA5})

	 TIME.DELAY(50)
    -- 关闭烧录电源
    VQPS(OFF)
    
    IIC_R_Tab2(0xF8, 34)

    LOG.INFO(string.format(
        "OTP_Write sequence completed: TSL=0x%02X, TSR=0x%02X",
        tsl_trim, tsr_trim
    ))

    return 1
end

function Get_PG_Version()
	local results  = {}
	local version = SYS.VERSION()
	LOG.INFO(string.format("%s",version ))
	
	table.insert(results, version)
	local json_data= cjson.encode(results)
	LOG.INFO(json_data)
	return 0, json_data
end


-- Pixel_Current_DAC_Cal_tmp()
function Pixel_Current_DAC_Cal_tmp()
	local R_AMUX_OHM = 100000
	local TRIM_MIN   = 0
	local TRIM_MAX   = 511 -- 9-bit trim code
	local SETTLE_MS  = 450 -- settling time after each trim write

	local results = {}
	local current_table = {}
	local best_trim = nil
	local best_diff = math.huge
	local target_uA = 5.2
	local best_current = nil
	local notFound = 0
	local meas_count = 0

	local tim1 = TIME.TICK()

-- Y5
    --AVEE1(OFF)         --AVEE

	SMU2(OFF, 1, 0x85) --Constant Current (measure Voltage)
	PPMU.CAL_EN(1) --5V off
	TIME.DELAY(100)
	Power.ValueSetting.SMU2 = 0
	TIME.DELAY(100)
	--SMU2(ON, 0, 0x85)  --0: Constant Voltage (measure Current)
	SMU2(ON, 1, 0x85)    --1: Constant Current (measure Voltage)
	TIME.DELAY(100)

	GPIO6_A_SET(0)  -- S0
	GPIO3_A_SET(0)  -- S1
	GPIO2_A_SET(0)  -- S2

	GPIO4_A_SET(0)  -- PGM_EN

	IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
	IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
	IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key
	

	IIC_W_Tab2(0xFD, { 0x80, 0x00, 0x91 })   -- VBG
	IIC_W_Tab2(0xFD, { 0x80, 0x00, 0x95 })   -- VREF
	IIC_W_Tab2(0xFD, { 0x00, 0x02, 0x94 })	-- IPXL
	IIC_R_Tab2(0xFD, 3) 
	TIME.DELAY(50)
IIC_W_Tab2(0xF8, {0x72,0x10,0x10,0x10, 0x20 ,0x10,0x10,0x25,0x0a,0x0a,0x03,0x11,0x20,  0x01,0x00    ,0x08,0x08,0x10,0x00,0x00,0x00,0x00,0x00,0x00,0x20,0x20,0x20,0x20,0x88,0x02,0x00,0x02,0x00,0x00 })
	IIC_R_Tab2(0xF8, 24) 

	GPIO4_A_SET(1)  -- PGM_EN
	TIME.DELAY(50)

	local v = POWER.VOL_CUR(P_SMU2)
	LOG.INFO(string.format(" AMON = %.4fV",v))
	
	TIME.DELAY(10)

	local json_data = cjson.encode(results)
	LOG.INFO(json_data)
	return 0, json_data
	

end


--Ramon
DPHY_HS_CFG = {
    D5_HS      = 0x03,      -- clock lane HS + 2 lanes
    D5_LP      = 0x00,      -- clock lane LP (I2C works)
    I2C_WAIT   = 20,        -- ms after D5_LP before the first I2C access (HS_SHOW value)
    CFG_WAIT   = 100,       -- ms after the Pinot video-mode setup (HS_SHOW value)
    SET_RATE   = false,     -- true: re-apply 1600 Mbps here (SIGNAL_CFG already sets it at TP load)
    RATE_WAIT  = 200,       -- ms after DMIPI.TIMING / FREQ when SET_RATE = true
    MDIV       = 16,        -- 1600 Mbps (SEL_00: 100 Mbps per step)
    TIMING     = {0x08, 0x03, 0x04, 0x02, 0x02},   -- vendor SEL_00 values
    FOLDER     = "./textures_dphy_hs",
    FIRST_PIC  = "DPHY_HS03_CK64.bmp",
    PIC_MS     = 500,       -- wait after PIC.SW, and between CRC reads (HS_SHOW used 300)
    CRC_PICS   = {"DPHY_HS03_CK64.bmp"},
    CRC_TRY    = 5,         -- CRC reads per image; two consecutive equal reads are needed
}

DPHY_HS_ON = false

-- Test images (10, folder textures_dphy_hs): {file, role, purpose}. Delete "data" lines to shorten the test.
-- The full 41-image library: gen_dphy_hs_patterns.py --all (engineering only).
DPHY_HS_PICS = {
    -- "cam": visible on the camera (the panel shows only on / off while EOTF bypass is on) + CRC
    {"DPHY_HS01_W255.bmp", "cam", "full white: all pixels lit"},
    --{"DPHY_HS02_W0.bmp", "cam", "full black: no pixel lit"},
    --{"DPHY_HS03_CK64.bmp", "cam", "64 px checker (Video_Test, focus)"},
    --{"DPHY_HS04_QUADRANT.bmp", "cam", "1-bit orientation: TL white + top notch, TR checker, BL stripes, BR black"},
    --{"DPHY_HS05_CHANNEL.bmp", "cam", "colour channel: R die shows HS03, G die HS04, B die HS01"},
    -- "data": grey-level data patterns judged by the VIDEO MUX CRC; the grey levels are not visible while
    -- EOTF bypass is on, so each carries its number (06..10) drawn in black: the camera sees "lit + number"
    --{"DPHY_HS06_HRAMP.bmp", "data", "horizontal ramp: all 256 grey codes per line (camera: 06)"},
    --{"DPHY_HS07_BITBARS.bmp", "data", "8 bands 1,2,4..128: each data bit = 1 alone (camera: 07)"},
    --{"DPHY_HS08_BITBARS_INV.bmp", "data", "8 bands 254..127: each data bit = 0 alone (camera: 08)"},
    --{"DPHY_HS09_CK1_55AA.bmp", "data", "1x1 checker 55/AA: every bit toggles every pixel (camera: 09)"},
    --{"DPHY_HS10_NOISE.bmp", "data", "pseudo-random pixels, PRBS-like (camera: 10)"},
}

-- DPHY_HS05_CHANNEL: R channel = HS03, G channel = HS04, B channel = HS01. Pinot shows only its own colour
-- byte, so its CRC must equal the CRC of the reference image of the die colour.
DPHY_HS_CHANNEL_PIC = "DPHY_HS05_CHANNEL.bmp"
DPHY_HS_CHANNEL_REF = {R = "DPHY_HS03_CK64.bmp", G = "DPHY_HS04_QUADRANT.bmp", B = "DPHY_HS01_W255.bmp"}

local CF_RESET = {0x13, 0x07, 0xC0, 0xFF, 0xFF, 0x4F, 0x00, 0xBF, 0x1F, 0xC4, 0x01, 0x00, 0x34}
local NOCRC = {["FF FF FF FF FF FF FF FF"] = true, ["00 00 00 00 00 00 00 00"] = true}

local function d5(v)
    CORE.SPI_WRITE(0xD5, 0x00, 0x00, 0x00, v)
end

local function hex(t)
    if type(t) ~= "table" then return "--" end
    local s = {}
    for i = 1, #t do s[i] = string.format("%02X", t[i]) end
    return table.concat(s, " ")
end

-- I2C helpers on the current slave address (call only with the clock lane LP)
local function keys()
    for _, k in ipairs({0xF0, 0xF1, 0xFC}) do IIC.WRITE(IIC_CONFIG.SLAVE_ADDR, {k}, {0x5A, 0x5A}) end
end

local function wr(reg, data)
    keys()
    IIC.WRITE(IIC_CONFIG.SLAVE_ADDR, {reg}, data)
end

local function rd(reg, n)
    local a = IIC_CONFIG.SLAVE_ADDR
    local ok, d = pcall(IIC.READ, a, {reg}, n)
    if not ok or type(d) ~= "table" or #d < n then return nil end
    if n >= 5 and d[2] == (a << 1) and d[3] == reg and d[5] == ((a << 1) | 1) then return nil end
    return d
end

local function pic_sw(name)
    local r = PIC.SW(DPHY_HS_CFG.FOLDER .. "/" .. name)
    if type(r) == "number" and r ~= 0 then
        LOG.ERROR(string.format("PIC.SW %s/%s returned %d (file missing? folder copied?)", DPHY_HS_CFG.FOLDER, name, r))
        return false
    end
    return true
end

function DPHY_HS_I2C(fn)
    if DPHY_HS_ON then
        d5(DPHY_HS_CFG.D5_LP)
        TIME.DELAY(DPHY_HS_CFG.I2C_WAIT)
    end
    local ok, res = pcall(fn)
    if DPHY_HS_ON then d5(DPHY_HS_CFG.D5_HS) end
    if not ok then
        LOG.ERROR("DPHY_HS_I2C: " .. tostring(res))
        return nil
    end
    return res
end

-- Pinot Video mode (same registers and order as HS_SHOW pinot_to_video), clock lane LP
local function pinot_video_mode()
    local t = Display.Timing
    wr(0xFE, {0x12, 0x23})                               -- reset value + CRC_ON
    wr(0xCF, CF_RESET)                                   -- MIPI RX settings back to reset
    wr(0xBF, {(t.vdisplay >> 8) & 0x07, t.vdisplay & 0xFF,
              (t.hdisplay >> 8) & 0x07, t.hdisplay & 0xFF,
              0x00, t.vbp, 0x00, t.vfp, 0x00, t.hbp, 0x00, t.hfp})
    wr(0xB4, {0x00, 0x00, 0x00, 0x00})                   -- start position 0,0
    wr(0xB1, {0x00, 0x88})                               -- TARPMODE = 0 (Video mode)
    wr(0xBD, {0x00})                                     -- 45 Hz (1600 Mbps x 2 lanes)
    wr(0xFA, {0x90, 0xFF, 0x00, 0x10, 0x00, 0x80, 0x00, 0x80, 0x00})   -- VPG off
    wr(0xCA, {0x02})                                     -- CRC on VIDEO MUX
    wr(0xF4, {0x01})
    TIME.DELAY(30)
    IIC.WRITE(IIC_CONFIG.SLAVE_ADDR, {0x29})             -- display on
    rd(0x05, 1)                                          -- clear DSI error count
end

function DPHY_HS_VIDEO_ON(pic)
    pic = pic or DPHY_HS_CFG.FIRST_PIC
    DPHY_HS_ON = false
    d5(DPHY_HS_CFG.D5_LP)
    DMIPI.LP()
    TIME.DELAY(DPHY_HS_CFG.I2C_WAIT)
    if not rd(0x0A, 1) then
        LOG.ERROR("DPHY_HS_VIDEO_ON: no I2C answer at 0x" .. string.format("%02X", IIC_CONFIG.SLAVE_ADDR) .. ", run DisplayOn() first")
        return 1
    end
    if DPHY_HS_CFG.SET_RATE then
        local tm = DPHY_HS_CFG.TIMING
        DMIPI.TIMING(tm[1], tm[2], tm[3], tm[4], tm[5])
        DMIPI.FREQ(1, 1, DPHY_HS_CFG.MDIV, 1)
        TIME.DELAY(DPHY_HS_CFG.RATE_WAIT)
    end
    pinot_video_mode()
    TIME.DELAY(DPHY_HS_CFG.CFG_WAIT)

    DMIPI.VID()
    DMIPI.HS()
    DMIPI.OPEN()
    if not pic_sw(pic) then return 1 end
    d5(DPHY_HS_CFG.D5_HS)                                -- clock lane HS last
    DPHY_HS_ON = true
    bist_mode = 0
    TIME.DELAY(DPHY_HS_CFG.PIC_MS)
    LOG.INFO("DPHY_HS_VIDEO_ON: " .. pic .. " (800 Mbps x 2 lanes, 20 Hz)")
    return 0
end

function DPHY_HS_IMG(n)
    local name = n
    if type(n) == "number" then name = DPHY_HS_PICS[n] and DPHY_HS_PICS[n][1] end
    name = name or DPHY_HS_CFG.FIRST_PIC
    LOG.INFO("DPHY_HS_IMG: " .. tostring(name))
    return pic_sw(name) and 0 or 1
end

function DPHY_HS_VIDEO_OFF()
    DPHY_HS_ON = false
    d5(DPHY_HS_CFG.D5_LP)
    DMIPI.LP()
    TIME.DELAY(DPHY_HS_CFG.I2C_WAIT)
    wr(0xB1, {0x01, 0x88})                               -- TARP mode (reset)
    wr(0xBD, {0x10})                                     -- 90 Hz (FirstPicture value)
    wr(0xFA, {0x91, 0xFF, 0x00, 0x10, 0x00, 0x80, 0x00, 0x80, 0x00})   -- VPG flat field 255
    wr(0xF4, {0x01})
    bist_mode = 1
    LOG.INFO("DPHY_HS_VIDEO_OFF: back to TARP mode + VPG flat white")
    return 0
end

function DPHY_HS_STATUS()
    local s = DPHY_HS_I2C(function()
        return {pm = rd(0x0A, 1), sm = rd(0x0E, 1), err = rd(0x05, 1)}
    end) or {}
    LOG.INFO(string.format("DPHY_HS_STATUS | 0Ah %s | 0Eh %s | 05h %s", hex(s.pm), hex(s.sm), hex(s.err)))
    return s
end

-- VIDEO MUX CRC of the image on screen: up to CRC_TRY reads, two consecutive equal reads are needed.
-- Keys are written before each read (CBh is an MCS register); all-FF / all-00 reads are rejected.
local function crc_of(pic)
    if not pic_sw(pic) then return nil, "load" end
    TIME.DELAY(DPHY_HS_CFG.PIC_MS)
    local last, seen = nil, {}
    for _ = 1, DPHY_HS_CFG.CRC_TRY do
        local c = DPHY_HS_I2C(function() keys() return rd(0xCB, 8) end)
        local s = c and hex(c) or "no answer"
        seen[#seen + 1] = s
        if NOCRC[s] or s == "no answer" then
            s = nil
        elseif s == last then
            return s
        end
        last = s
        TIME.DELAY(DPHY_HS_CFG.PIC_MS)
    end
    return nil, table.concat(seen, " / ")
end

-- VIDEO MUX CRC of the image on screen, no repeat check: the first non-empty read is returned.
-- Empty = no I2C answer, or all-FF / all-00. Up to CRC_TRY reads (CRC_TRY = 1: a single read).
local function crc_any(pic)
    if not pic_sw(pic) then return nil, "load" end
    TIME.DELAY(DPHY_HS_CFG.PIC_MS)
    local raw = {}
    for _ = 1, DPHY_HS_CFG.CRC_TRY do
        local c = DPHY_HS_I2C(function() keys() return rd(0xCB, 8) end)
        local h = c and hex(c) or "no answer"
        if c and not NOCRC[h] then return h end
        raw[#raw + 1] = h
        TIME.DELAY(DPHY_HS_CFG.PIC_MS)
    end
    return nil, table.concat(raw, " / ")
end

-- Production item. PASS when:
--   DPHY_HS_VIDEO_ON ok, Pinot power mode 0Ah = 1C (sleep out, normal, display on),
--   CRC of CRC_PICS[1] is not empty (I2C answers and the read is not all-FF / all-00).
function MIPI_DPHY_HS_Init_Test()
    local result = {}
    if DPHY_HS_VIDEO_ON(DPHY_HS_CFG.FIRST_PIC) ~= 0 then
   	 	DPHY_HS_ON = false
        CORE.SPI_WRITE(0xD5, 0x00, 0x00, 0x00, 0x00)   -- clock lane LP, I2C works again
        DMIPI.LP()
        DMIPI.CMD()                                     -- stop the video stream (DMIPI.VID)
        bist_mode = 1                                   -- back to VPG mode (PIC_CFG default)
        TIME.DELAY(20)
        LOG.INFO(string.format("DPHY_HS_MODE = %s",DPHY_HS_ON))
        return 1, cjson.encode({"Fail", "DPHY_HS_VIDEO_ON"})
    end
    LOG.INFO(string.format("DPHY_HS_MODE = %s",DPHY_HS_ON))
    TIME.DELAY(50)
    local crc = {}
    for i, p in ipairs(DPHY_HS_CFG.CRC_PICS) do
        local c, why = crc_any(p)
        crc[i] = c or "none"
        LOG.INFO(string.format("  %s: CRC %s", p, c or ("empty (" .. tostring(why) .. ")")))
        TIME.DELAY(50)
    end
    local st = DPHY_HS_STATUS()
    local pm = st.pm and st.pm[1] or 0xFF

    local ok = crc[1] ~= "none" and pm == 0x1C
    table.insert(result, ok and "Pass" or "Fail")
    table.insert(result, crc[1])
    --table.insert(result, string.format("0x%02X", pm))
    local json_data = cjson.encode(result)
    LOG.INFO(json_data)
    LOG.INFO(string.format("F_DPHY_HS_Video_Test %s | CRC CK64 %s | 0Ah %02X",
        ok and "PASS" or "FAIL", crc[1], pm))
    pic_sw(DPHY_HS_CFG.FIRST_PIC)
    DPHY_HS_ON = false
    CORE.SPI_WRITE(0xD5, 0x00, 0x00, 0x00, 0x00)   -- clock lane LP, I2C works again
    DMIPI.LP()
    DMIPI.CMD()                                     -- stop the video stream (DMIPI.VID)
    bist_mode = 1                                   -- back to VPG mode (PIC_CFG default)
    TIME.DELAY(20)
    LOG.INFO(string.format("DPHY_HS_MODE = %s",DPHY_HS_ON))
    return ok and 0 or 1, json_data
end

-- Every DPHY_HS_PICS image, CRC of each. PASS when:
--   every image gives a stable CRC,
--   CRC(DPHY_HS05_CHANNEL) = CRC(reference image of the die colour) (Pinot takes only its own colour byte),
--   all other images have different CRCs (a stuck data bit / lane makes two patterns look the same).
-- Die colour = the colour Pinot is set to: from its I2C address 0x60 + Device ID (0 = R, 1 = G, 2 = B).
-- An unburned die reads Device ID 0 (= R) whatever the wafer colour; the log shows both that and the TP's Color.
function MIPI_DPHY_HS_Video_Test()
    if not DPHY_HS_ON and DPHY_HS_VIDEO_ON(DPHY_HS_CFG.FIRST_PIC) ~= 0 then
    	DPHY_HS_ON = false
        CORE.SPI_WRITE(0xD5, 0x00, 0x00, 0x00, 0x00)   -- clock lane LP, I2C works again
        DMIPI.LP()
        DMIPI.CMD()                                     -- stop the video stream (DMIPI.VID)
        bist_mode = 1                                   -- back to VPG mode (PIC_CFG default)
        TIME.DELAY(20)
        LOG.INFO(string.format("DPHY_HS_MODE = %s",DPHY_HS_ON))
        return 1, cjson.encode({"Fail", "DPHY_HS_VIDEO_ON"})
    end
    
    LOG.INFO(string.format("DPHY_HS_MODE = %s",DPHY_HS_ON))
    local result = {}
    local color = (IIC_CONFIG.SLAVE_ADDR - 0x60) & 0x03
    local mycol = ({[0] = "R", "G", "B"})[color]
    local crc, list, bad = {}, {}, {}
    local crc_temp = {}
    for _, e in ipairs(DPHY_HS_PICS) do
        local c, why = crc_of(e[1])
        crc[e[1]] = c or "none"
        list[#list + 1] = e[1]
        LOG.INFO(string.format("  %-26s CRC %s", e[1], c or ("none (" .. tostring(why) .. ")")))
        if not c then bad[#bad + 1] = e[1] .. ":" .. (why == "load" and "load" or "unstable") end
        TIME.DELAY(100)
        --LOG.INFO(string.format("------c = %s",c))
        --table.insert(result,c)
        --crc_temp[#crc_temp + 1] = c or "none"
    end
    -- colour channel: CHANNEL image = reference image of the die colour
    local alias = {}
    local cp, ref = DPHY_HS_CHANNEL_PIC, DPHY_HS_CHANNEL_REF[mycol or "R"]
    if crc[cp] then
        alias[cp] = ref
        if crc[cp] ~= "none" and crc[ref] and crc[ref] ~= "none" and crc[cp] ~= crc[ref] then
            bad[#bad + 1] = cp .. "~=" .. ref .. "(colour " .. tostring(mycol) .. ")"
        end
        TIME.DELAY(100)
    end
    -- all other CRCs must be unique
    local seen = {}
    for _, f in ipairs(list) do
        if not alias[f] and crc[f] ~= "none" then
            if seen[crc[f]] then bad[#bad + 1] = f .. "==" .. seen[crc[f]] else seen[crc[f]] = f end
        end
    end
    local ok = #bad == 0 and #list > 0
    local first = table.concat(bad, " ", 1, math.min(#bad, 5))
    LOG.INFO(string.format("F_DPHY_HS_Pattern_Test %s | %d images | Pinot colour %s (I2C 0x%02X), TP Color %s | %s",
        ok and "PASS" or "FAIL", #list, tostring(mycol), IIC_CONFIG.SLAVE_ADDR, tostring(Color),
        ok and "all CRC checks ok" or (#bad .. " problems: " .. first)))
    pic_sw(DPHY_HS_CFG.FIRST_PIC)
     table.insert(result, ok and "Pass" or "Fail")
     
    for _, file_name in ipairs(list) do
     	table.insert(result, crc[file_name])
    end
    --table.insert(result, #list)
    --table.insert(result, #bad)
    --table.insert(result, first)
    local json_data  = cjson.encode(result)
    LOG.INFO(json_data)
    DPHY_HS_ON = false
    LOG.INFO(string.format("DPHY_HS_MODE = %s",DPHY_HS_ON))
    CORE.SPI_WRITE(0xD5, 0x00, 0x00, 0x00, 0x00)   -- clock lane LP, I2C works again
    DMIPI.LP()
    DMIPI.CMD()                                     -- stop the video stream (DMIPI.VID)
    bist_mode = 1                                   -- back to VPG mode (PIC_CFG default)
    TIME.DELAY(20)
    return ok and 0 or 1, json_data
end

--F_DPHY_HS_Show()
-- Production: show image n for the camera (no I2C, so the stream stays clean)
function F_DPHY_HS_Show(n)
    n = n or 1
    if not DPHY_HS_ON and DPHY_HS_VIDEO_ON(DPHY_HS_CFG.FIRST_PIC) ~= 0 then
        return 1, cjson.encode({"Fail", "DPHY_HS_VIDEO_ON"})
    end
    local r = DPHY_HS_IMG(n)
    TIME.DELAY(DPHY_HS_CFG.PIC_MS)
    local e = DPHY_HS_PICS[n]
    LOG.INFO(string.format("------e[1] = %s",e[1]))
    return r, cjson.encode({r == 0 and "OK" or "Fail", e and e[1] or tostring(n)})
end

-- No-argument stepping through DPHY_HS_PICS (PIC.SW only), like Next() / Prev() in PIC_CFG
DPHY_HS_IDX = DPHY_HS_IDX or 1
local function step(d)
    if not DPHY_HS_ON then
        LOG.INFO("DPHY_HS: run DPHY_HS_VIDEO_ON() first")
        return 1
    end
    DPHY_HS_IDX = (DPHY_HS_IDX - 1 + d) % #DPHY_HS_PICS + 1
    LOG.INFO(string.format("DPHY_HS image %d / %d: %s", DPHY_HS_IDX, #DPHY_HS_PICS, DPHY_HS_PICS[DPHY_HS_IDX][3]))
    return DPHY_HS_IMG(DPHY_HS_IDX)
end
function DPHY_HS_NEXT() return step(1) end
function DPHY_HS_PREV() return step(-1) end

AVEE_CAP_CFG = AVEE_CAP_CFG or {
	CHANNEL          = 6,      -- P_AVEE
	N_SAMPLES        = 10000,  -- used when no duration is passed
	INTERVAL_MS      = 1,
	CHANGES_ONLY     = true,   -- store only reads whose value changed (the meter holds ~44 ms)
	MAX_STORE        = 200000, -- safety limit on stored points (memory); reads continue, storing stops
	PG_AVG           = nil,    -- nil = keep TAB2 meter averaging; 1 = raw (restored afterwards)
	SETTLE_MS        = 800,    -- after the pattern is set, before the capture (as DI_TRIM)
	CMON_OFF         = true,   -- write E3h = 1 (content monitor off) as DI_TRIM does
	STEP_SHADE       = nil,    -- optional flat-field shade to switch to during the capture
	STEP_AT_MS       = nil,    -- ... at this time (ms after the first read)
	SAMPLES_PER_LINE = 50,     -- points per LOG line
	CSV_PATH         = nil,    -- optional: also write a CSV on the PG file system
}

local function cap_log_data(tag, ts, cur, n)
	local per = AVEE_CAP_CFG.SAMPLES_PER_LINE
	local i = 1
	while i <= n do
		local parts = {}
		local last = math.min(i + per - 1, n)
		for k = i, last do
			parts[#parts + 1] = string.format("%d:%.0f", ts[k], cur[k])
		end
		LOG.INFO(string.format("AVEECAP,%s,%d,%s", tag, i, table.concat(parts, ";")))
		i = last + 1
	end
end

local function cap_write_csv(path, tag, ts, cur, n)
	local f = io.open(path, "w")
	if not f then
		LOG.ERROR("AVEE_CAPTURE: cannot open " .. tostring(path))
		return
	end
	f:write("tag,index,t_ms,I_nA\n")
	for k = 1, n do
		f:write(string.format("%s,%d,%d,%.0f\n", tag, k, ts[k], cur[k]))
	end
	f:close()
	LOG.INFO("AVEE_CAPTURE: CSV written to " .. path)
end

--AVEE_CAPTURE("Green", 255, "100", 60000)
function AVEE_CAPTURE(color, shade, tag, duration_ms)
	local cfg = AVEE_CAP_CFG
	local ch  = cfg.CHANNEL
	local dt  = cfg.INTERVAL_MS
	local n   = cfg.N_SAMPLES
	if duration_ms ~= nil then
		n = math.floor(duration_ms / dt) + 1
	end
	local changes_only = cfg.CHANGES_ONLY and true or false
	local max_store = cfg.MAX_STORE or 200000
	tag = tag or string.format("%s_%s", tostring(color or "asis"), tostring(shade or "asis"))

	-- 1. setup (optional)
	if cfg.CMON_OFF then
		IIC_W_Tab2(0xe3, {0x1})  -- Content Monitor Off
		TIME.DELAY(20)
	end
	if color ~= nil then
		Set_Device_Condition_By_Color(color)
		TIME.DELAY(20)
	end
	if shade ~= nil then
		VPG_SetFlatField(shade)
	end
	if cfg.PG_AVG ~= nil then
		for i = 0, 8, 1 do
			POWER.AVG_CYCLE(0, i, cfg.PG_AVG)
			POWER.AVG_CYCLE(1, i, cfg.PG_AVG)
		end
		POWER.COLLECT_SET(cfg.PG_AVG)
	end
	if cfg.SETTLE_MS and cfg.SETTLE_MS > 0 then
		TIME.DELAY(cfg.SETTLE_MS)
	end

	-- 2. capture: store only, log afterwards (logging inside the loop would wreck the timing)
	local ts, cur = {}, {}
	local m = 0                                   -- stored points
	local reads, mean, m2, mn, mx = 0, 0, 0, math.huge, -math.huge   -- running stats (uA, |I|)
	local max_gap, t_prev, t_last, c_last = 0, nil, 0, nil
	local gap_hist = {}                           -- read-interval histogram (ms -> count) for the median
	local full_warned = false
	local stepped = (cfg.STEP_SHADE == nil or cfg.STEP_AT_MS == nil)
	local t_step = -1

	local ok, err = pcall(function()
		local t0 = TIME.TICK()
		local prev_c = nil
		for i = 1, n do
			local due = t0 + (i - 1) * dt
			while TIME.TICK() < due do end
			if not stepped and (due - t0) >= cfg.STEP_AT_MS then
				t_step = TIME.TICK() - t0
				VPG_SetFlatField(cfg.STEP_SHADE)
				stepped = true
			end
			local t = TIME.TICK() - t0
			local _, c = POWER.VOL_CUR(ch)

			-- running statistics over every read (Welford)
			reads = reads + 1
			local a = math.abs(c) / 1000
			local d = a - mean
			mean = mean + d / reads
			m2 = m2 + d * (a - mean)
			if a < mn then mn = a end
			if a > mx then mx = a end
			if t_prev ~= nil then
				local g = t - t_prev
				if g > max_gap then max_gap = g end
				gap_hist[g] = (gap_hist[g] or 0) + 1
			end
			t_prev = t
			t_last, c_last = t, c

			-- storage
			if (not changes_only) or prev_c == nil or c ~= prev_c then
				if m < max_store then
					m = m + 1
					ts[m] = t
					cur[m] = c
				elseif not full_warned then
					full_warned = true
				end
			end
			prev_c = c
		end
	end)

	if cfg.PG_AVG ~= nil then
		power_collect_set()      -- back to the TAB2 meter averaging
	end

	-- with CHANGES_ONLY, also store the last read so the final hold has an end time
	if changes_only and reads > 0 and m > 0 and ts[m] ~= t_last and m < max_store then
		m = m + 1
		ts[m] = t_last
		cur[m] = c_last
	end

	if not ok then
		LOG.ERROR("AVEE_CAPTURE failed: " .. tostring(err) .. string.format(" after %d reads", reads))
		if m > 0 then
			cap_log_data(tag, ts, cur, m)   -- keep what was captured
		end
		return 1, cjson.encode({-9999})
	end

	-- 3. summary
	local std = (reads > 1) and math.sqrt(m2 / (reads - 1)) or 0
	local med_gap, acc = 0, 0
	local keys = {}
	for g, _ in pairs(gap_hist) do keys[#keys + 1] = g end
	table.sort(keys)
	for _, g in ipairs(keys) do
		acc = acc + gap_hist[g]
		if acc >= (reads - 1) / 2 then med_gap = g; break end
	end
	local med_change = 0
	if changes_only and m > 2 then
		local ch_gaps = {}
		for k = 2, m - 1 do ch_gaps[#ch_gaps + 1] = ts[k] - ts[k - 1] end
		table.sort(ch_gaps)
		med_change = ch_gaps[math.floor((#ch_gaps + 1) / 2)]
	end

	LOG.INFO(string.format(
		"AVEECAP_HDR,%s,color=%s,shade=%s,ch=%d,n=%d,interval_ms=%d,pg_avg=%s,settle_ms=%d,step_shade=%s,step_at_ms=%d,changes_only=%d",
		tag, tostring(color), tostring(shade), ch, n, dt, tostring(cfg.PG_AVG or "TAB2"),
		cfg.SETTLE_MS or 0, tostring(cfg.STEP_SHADE), t_step, changes_only and 1 or 0))
	cap_log_data(tag, ts, cur, m)
	LOG.INFO(string.format(
		"AVEECAP_END,%s,duration_ms=%d,reads=%d,stored=%d,mean_uA=%.3f,min_uA=%.3f,max_uA=%.3f,std_uA=%.3f,median_dt_ms=%d,max_dt_ms=%d,median_change_ms=%d,store_full=%d",
		tag, t_last, reads, m, mean, mn, mx, std, med_gap, max_gap, med_change, full_warned and 1 or 0))
	if med_gap > dt then
		LOG.INFO(string.format("AVEE_CAPTURE: requested %d ms but achieved %d ms per read (meter is slower)", dt, med_gap))
	end
	if full_warned then
		LOG.INFO(string.format("AVEE_CAPTURE: MAX_STORE %d reached, later points not stored (stats still cover all reads)", max_store))
	end
	if cfg.CSV_PATH then
		cap_write_csv(cfg.CSV_PATH, tag, ts, cur, m)
	end

	return 0, cjson.encode({reads, t_last, mean, mn, mx, std, med_gap, max_gap, m})
end
--Ramon


--add 2026/11/19 lqs
g_sweep_csv_seq  = 0
-- create CSV file for pixel/duty current sweep (same method as F_Save_CSV)
function F_Save_Current_Sweep_CSV()
	local Y = os.date("%Y")
	local MON = os.date("%m")
	local D = os.date("%d")
	local timestamp = os.date("%H%M%S")
	local file_type = "csv"
	g_sweep_csv_seq = g_sweep_csv_seq + 1
	local file_name = string.format("C:\\AVEE_CURRENT\\%s\\%s\\%s\\pixel_duty_current_%s_%04d.csv",
		Y, MON, D, timestamp, g_sweep_csv_seq)
	local head_Str = "pixel_uA,duty_pct,AVDD_uA,AVEE1_uA\n"
	LOG.CREAT_FILE(file_id .. "," .. file_type .. "," .. file_name .. "," .. head_Str)
	LOG.INFO("CSV文件已创建：" .. file_name)
end

--[[
Function: Pixel_Duty_Current_Sweep
Desc: Sweep pixel current (0.1 ~ 4.0 uA, step 0.1) x duty cycle (5 ~ 100 %, step 5).
      For each condition, sample AVDD (ch 5) and AVEE1 (ch 6) current N times,
      average them, and save to CSV (same table method as AVEE_current).
Input:
    samples : Samples per condition. Default 100.
Return:
    1 on success
--]]
--Pixel_Duty_Current_Sweep(120)
function Pixel_Duty_Current_Sweep(samples)
	if samples == nil then
		samples = 100
	end

	local AVDD_CH  = 5   -- AVDD channel (Power.ChannelSetting.AVDD)
	local AVEE1_CH = 6   -- AVEE1 channel (Power.ChannelSetting.AVEE1)

	local pixel_count = 2  -- 0.2 .. 4.0 uA, step 0.2
	local duty_count  = 20   -- 1 .. 20 %, step 1
	
	POWER.SINGLE_SET(Power.ChannelSetting.AVEE1, 1, 0x85, Power.CONSTANT_VOLTAGE, -5000, Power.OVPSetting.AVEE1,
		Power.UVPSetting.AVEE1, Power.OCPSetting.AVEE1, Power.UCPSetting.AVEE1, Power.UCPSetting.AVEE1)
		
	TIME.DELAY(100)
	VPG_SetFlatField(255)

	F_Save_Current_Sweep_CSV()

	for pi = 0, pixel_count - 1 do
		local pixel_uA = math.floor((1.8 + pi * 1.8) * 100 + 0.5) / 100
		Set_Pixel_Current(pixel_uA)

		for di = 0, duty_count - 1 do
			local duty_pct = 1+ di * 1
			Set_Duty_Cycle(90, duty_pct)
			TIME.DELAY(100)

			local avdd_v, avdd_c = 0, 0
			local avee_v, avee_c = 0, 0
			for i = 1, samples do
				TIME.DELAY(5)
				local v1, c1 = POWER.VOL_CUR(AVDD_CH)
				local v2, c2 = POWER.VOL_CUR(AVEE1_CH)
				avdd_v = avdd_v + v1
				avdd_c = avdd_c + c1
				avee_v = avee_v + v2
				avee_c = avee_c + c2
			end

			local avdd_uA  = avdd_c / samples / 1000.0  -- nA -> uA
			local avee1_uA = avee_c / samples / 1000.0  -- nA -> uA
					
			g_avdd_uA = avdd_uA
			g_avee1_uA = avee1_uA

			LOG.INFO(string.format("pixel=%.2fuA duty=%d%% AVDD=%.3fuA AVEE1=%.3fuA",
				pixel_uA, duty_pct, avdd_uA, avee1_uA))

			Update_CSV(string.format("%.2f,%d,%.3f,%.3f\n",
				pixel_uA, duty_pct, avdd_uA, avee1_uA))
		end
		
		if g_avdd_uA < 0.001 and  g_avee1_uA < 0.001  then
				TIME.DELAY(500)
				DisplayOn()
				TIME.DELAY(500)
				POWER.SINGLE_SET(Power.ChannelSetting.AVEE1, 1, 0x85, Power.CONSTANT_VOLTAGE, -5000, Power.OVPSetting.AVEE1,
							Power.UVPSetting.AVEE1, Power.OCPSetting.AVEE1, Power.UCPSetting.AVEE1, Power.UCPSetting.AVEE1)
				TIME.DELAY(100)
				VPG_SetFlatField(255)
				LOG.DEBUG("-----rePower On")
		end
	end

	return 1
end


