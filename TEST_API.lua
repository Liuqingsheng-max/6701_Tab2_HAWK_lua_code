
Bandgap_code = 0
tempratue_0p25_code=0
tempratue_0p75_code=0
DAC_POINTA_CODE=0
DAC_POINTB_CODE=0
thermal_sensor0_code=0
thermal_sensor1_code=0
DAC_cal_trim_step = 0
DAC_calibration_code=0
DI_trim_code=0
LUT_code = 0
LundyuLED_code=0
caled_temp_point=50

mipi_term_90=0X1B1B1
mipi_term_270=0x1011
Efuse_90_clk=0x03
Efuse_90_data=0x03
Efuse_270_clk=0x01
Efuse_270_data=0x01

Pixel_Current_uA = 0
Duty_cycle = 0
raw_values = {}--efuse缓存值
CRC1_MINLEN = {
    4,--code
    4,--rev
    9,--x
    9,--y
    6,--L0
    6,--L1
    6,--L2
    6,--L3
    6,--L4
    6,--L5
    6,--L6
    6,--L7
    6,--L8
    6,--wafer
    5,--fab
    5,--foundry
    15,--jtagID
    2,--sub
    2,--min0
    2,--maj
    4,--b1
    32,--timestamp
    6--S1
}
CRC3_MINLEN={4,4}

dac_crc_MINLEN = {
    1,--DAC_MODE
    4,--DAC_CAL
    12,--DAC_POINTA
    12,--DAC_POINTB
    
}
CRC_TEMP_MINLEN = {
    4,--BGTRIM
    12,--Temperature
    10,--TEMP_1q
    10,--TEMP_3q
    10,--SensorA
    10--SensorB
    
}
CRC_MIPI_TERM = {
	3,--CLK-TERM90
	3,--DATA-TERM90
	3,--CLK-TERM270
	3,--DATA-TERM90
}

efuse_field = {
    {name = "Die_ID",       s=0x00, e=0xFF, fmt="Die_ID:0X%02X",	MATCHED=1},
    {name = "code",         s=0x00, e=0x03, fmt="code:0X%02X",	MATCHED=0},
    {name = "rev",          s=0x04, e=0x07, fmt="rev:0X%02X",		MATCHED=0},
    {name = "x",            s=0x08, e=0x10, fmt="x:%d",			MATCHED=0},
    {name = "y",            s=0x11, e=0x19, fmt="y:%d",			MATCHED=0},
    {name = "L0",           s=0x1A, e=0x1F, fmt="L0:0X%02X",	MATCHED=0},
    {name = "L1",           s=0x20, e=0x25, fmt="L1:0X%02X",	MATCHED=0},
    {name = "L2",           s=0x26, e=0x2B, fmt="L2:0X%02X",	MATCHED=0},
    {name = "L3",           s=0x2C, e=0x31, fmt="L3:0X%02X",	MATCHED=0},
    {name = "L4",           s=0x32, e=0x37, fmt="L4:0X%02X",	MATCHED=0},
    {name = "L5",           s=0x38, e=0x3D, fmt="L5:0X%02X",	MATCHED=0},
    {name = "L6",           s=0x3E, e=0x43, fmt="L6:0X%02X",	MATCHED=0},
    {name = "L7",           s=0x44, e=0x49, fmt="L7:0X%02X",	MATCHED=0},
    {name = "L8",           s=0x4A, e=0x4F, fmt="L8:0X%02X",	MATCHED=0},
    {name = "wafer",        s=0x50, e=0x55, fmt="wafer:%d",		MATCHED=0},
    {name = "fab",          s=0x56, e=0x5A, fmt="fab:0X%X",		MATCHED=0},
    {name = "foundry",      s=0x5B, e=0x5F, fmt="foundry:0X%X",	MATCHED=0},
    {name = "jtagID",       s=0x60, e=0x6E, fmt="jtagID:0X%X",	MATCHED=0},
    {name = "OVF",          s=0x6F, e=0x6F, fmt="OVF:0X%X",		MATCHED=0},
    {name = "sub",          s=0x70, e=0x71, fmt="sub:0X%X",		MATCHED=0},
    {name = "min0",         s=0x72, e=0x73, fmt="min0:0X%X",	MATCHED=0},
    {name = "maj",          s=0x74, e=0x75, fmt="maj:0X%X",		MATCHED=0},
    {name = "custom",       s=0x76, e=0x7B, fmt="custom:0X%X",	MATCHED=0},
    {name = "timestamp",    s=0x80, e=0x9F, fmt="timestamp Code:%d",MATCHED=0},
    {name = "b1",           s=0x7C, e=0x7F, fmt="b1:0x%02X",	MATCHED=0},
    {name = "S1",           s=0xA0, e=0xA5, fmt="S1:0x%02X",	MATCHED=0},
    {name = "CRC1",         s=0xA6, e=0xAD, fmt="CRC1:0x%02X",	MATCHED=0},
    {name = "B2",           s=0xAE, e=0xB1, fmt="B2:0x%02X",	MATCHED=0},
    {name = "S2",           s=0xB2, e=0xB7, fmt="S2:0x%02X",	MATCHED=0},
    {name = "CRC2",         s=0xB8, e=0xBB, fmt="CRC2:0x%02X",	MATCHED=0},
    {name = "B3",           s=0xBC, e=0xBF, fmt="B3:0x%02X",	MATCHED=0},
    {name = "S3",           s=0xC0, e=0xC3, fmt="S3:0x%02X",	MATCHED=0},
    {name = "CRC3",         s=0xC4, e=0xC7, fmt="CRC3:0x%02X",	MATCHED=0},
    {name = "B4",           s=0xC8, e=0xCB, fmt="B4:0x%02X",	MATCHED=0},
    {name = "S4",           s=0xCC, e=0xCF, fmt="S4:0x%02X",	MATCHED=0},
    {name = "CRC4",         s=0xD0, e=0xD3, fmt="CRC4:0x%02X",	MATCHED=0},
    {name = "B5",           s=0xD4, e=0xD7, fmt="B5:0x%02X",	MATCHED=0},
    {name = "S5",           s=0xD8, e=0xDB, fmt="S5:0x%02X",	MATCHED=0},
    {name = "CRC5",         s=0xDC, e=0xDF, fmt="CRC5:0x%02X",	MATCHED=0},
    {name = "B6",           s=0x1F4, e=0x1F7, fmt="B6:0x%02X",	MATCHED=0},
    {name = "S6",           s=0x1F8, e=0x1FB, fmt="S6:0x%02X",	MATCHED=0},
    {name = "CRC6",         s=0x1FC, e=0x1FF, fmt="CRC6:0x%02X",MATCHED=0},
    {name = "DAC_MODE",  s=0x100, e=0x100, fmt="DAC_MODE:%d",MATCHED=0},
    {name = "DAC_CAL",       s=0x102, e=0x105, fmt="DAC_CAL:%d",	MATCHED=0},
    {name = "AVEEPOINT",    s=0x106, e=0x10F, fmt="AVEEPOINT:%d",MATCHED=0},
    {name = "DAC_POINTA",       s=0x110, e=0x11B, fmt="DAC_POINTA:%d",	MATCHED=0},
    {name = "DAC_POINTB",       s=0x11C, e=0x127, fmt="DAC_POINTB:%d",	MATCHED=0},
    {name = "CRCforDACBlock",s=0x128, e=0x12F, fmt="CRCforDACBlock:%d",	MATCHED=0},
    {name = "BANDGAP",  s=0x130, e=0x133, fmt="BANDGAP:%d",	MATCHED=0},
    {name = "TSENSOR_TEMP",  s=0x134, e=0x13F, fmt="TSENSOR_TEMP:%d",	MATCHED=0},
    {name = "TSENSOR_ADC1Q", s=0x140, e=0x149, fmt="TSENSOR_ADC1Q:%d",MATCHED=0},
    {name = "TSENSOR_ADC3Q", s=0x14A, e=0x153, fmt="TSENSOR_ADC3Q:%d",MATCHED=0},
    {name = "TSENSOR_CODEA",  s=0x154, e=0x15F, fmt="TSENSOR_CODEA:%d",	MATCHED=0},
    {name = "TSENSOR_CODEB",  s=0x160, e=0x16B, fmt="TSENSOR_CODEB:%d",	MATCHED=0},
    {name = "CRCforTempSensorBlock", s=0x170, e=0x177, fmt="CRCforTempSensorBlock:%d",MATCHED=0},
    {name = "FSEL",         s=0x180, e=0x181, fmt="FSEL:%d",	MATCHED=0},
    {name = "FTUNE",        s=0x182, e=0x184, fmt="FTUNE:%d",	MATCHED=0},
    {name = "clk_term90",   s=0x190, e=0x192, fmt="clk_term90:%d",MATCHED=0},
    {name = "clk_term270",  s=0x193, e=0x195, fmt="clk_term270:%d",MATCHED=0},
    {name = "data_term90",  s=0x196, e=0x198, fmt="data_term90:%d",MATCHED=0},
    {name = "data_term270", s=0x199, e=0x19B, fmt="data_term270:%d",MATCHED=0},
    {name = "LundyuLED",    s=0x1EF, e=0x1EF, fmt="LundyuLED:%d",MATCHED=0},
    {name = "I2CID",        s=0x1F0, e=0x1F1, fmt="I2CID:%d",MATCHED=0}
    }



function datalog_results(tittle, tb)
	println("%s: \n{",tittle)
	for k,v in pairs(tb) do
		println("%s = %s",k,v)

	end
	println("}")
end

function Set_TEST_MODE(Test_Mode)
	if Test_Mode=="MT" or Test_Mode=="CP2" then
		TEST_MODE=Test_Mode
		LOG.DEBUG("Test Mode:"..Test_Mode)
	else
		TEST_MODE="MT"
		LOG.DEBUG("Test Mode:"..Test_Mode)
	end

	RestInit()
	Set_IO_TEST_MODE()
end

--1.0 Power Shorts Test-ready
--Purpose: Checks if there are any gross shorts on the Power pins of the device.
--Test Sequence
--1. Set all IO to 0V.
--2. Set all positive power supply pins to 0.1V, AVEE to –0.1V and all clamp to 10mA 
--3. Measure & Report current at VDD10,VDD18,AVEE,VQPS
--4. Power down power rail.
--Pass Fail Criteria
--Current measurement limits:
--a. Low Limit: 0 mA
--b. High Limit: 1 mA

function F_28M2_OSTest()
	local tim1 = TIME.TICK()
	TIME.DELAY(500)

	-- 1. Set all IO to 0V.
	-- 2. Set all positive power supply pins to 0.1V, AVEE to –0.1V and all clamp to 10mA 
	local ret = 1
	local os_short = "Pass"
	local os_table = {}
	local VOLTAGE_VALUE = 100 --mV
	local VOLTAGE_CLAMP = 200 --mV
	local CURRENT_CLAMP = 20*1000*1000 --nA
	local UNDER_VOLTAGE_PROTECTIVE = 0 --mV
	local UNDER_CURRENT_PROTECTIVE = 0  --mV
	local Current_table ={}
	
	
	for i = IIC_SLV_Defaul,IIC_SLV_B do 
		IIC_CONFIG.SLAVE_ADDR = i
		IIC_CONFIG.init_default()
		TIME.DELAY(100)
		if i == IIC_SLV_Defaul then
			POWER_ON()
		end
		ret,tb = I2C_Communication_Test()
		if ret == 0 then
			break
		end
		
	end

	POWER_OFF()
	TIME.DELAY(200)
	
	println("=================POWER_SHORTS=========================")
	local VQPS_DATA = {
		VOLTAGE = 0.0,    -- volts
		CURRENT = 0.0,    -- amps
	}
	local VDD10_DATA = {
		VOLTAGE = 0.0,    -- volts
		CURRENT = 0.0,    -- amps
	}
	local VDD18_DATA = {
		VOLTAGE = 0.0,    -- volts
		CURRENT = 0.0,    -- amps
	}
	local AVEE_DATA = {
		VOLTAGE = 0.0,    -- volts
		CURRENT = 0.0,    -- amps
	}
	--VQPS
	POWER_CHANNEL_VALUE(P_VQPS, ON, VOLTAGE_VALUE, VOLTAGE_CLAMP, CURRENT_CLAMP)
	--VDD18
	POWER_CHANNEL_VALUE(P_VDD18, ON, VOLTAGE_VALUE , VOLTAGE_CLAMP, CURRENT_CLAMP)
	--VDD10
	POWER_CHANNEL_VALUE(P_VDD10, ON, VOLTAGE_VALUE, VOLTAGE_CLAMP, CURRENT_CLAMP)
	--AVEE
	POWER_CHANNEL_VALUE(P_AVEE, ON, -VOLTAGE_VALUE, -VOLTAGE_CLAMP, CURRENT_CLAMP)

	TIME.DELAY(200)
	--3. Measure & Report current at VDD10,VDD18,AVEE,VQPS
	VQPS_DATA.VOLTAGE, VQPS_DATA.CURRENT=POWER.VOL_CUR(P_VQPS)
	VDD18_DATA.VOLTAGE, VDD18_DATA.CURRENT=POWER.VOL_CUR(P_VDD18)
	VDD10_DATA.VOLTAGE, VDD10_DATA.CURRENT=POWER.VOL_CUR(P_VDD10)
	AVEE_DATA.VOLTAGE, AVEE_DATA.CURRENT=POWER.VOL_CUR(P_AVEE)
	
	VQPS_DATA.CURRENT  = VQPS_DATA.CURRENT/1000
	VDD18_DATA.CURRENT = VDD18_DATA.CURRENT/1000
	VDD10_DATA.CURRENT = VDD10_DATA.CURRENT/1000
	AVEE_DATA.CURRENT  = AVEE_DATA.CURRENT/1000
	
	--POWER_OFF()
	
	LOG.INFO(string.format("VQPS_DATA :%.4fV, %.4fuA",VQPS_DATA.VOLTAGE, VQPS_DATA.CURRENT))
	LOG.INFO(string.format("VDD18_DATA:%.4fV, %.4fuA",VDD18_DATA.VOLTAGE, VDD18_DATA.CURRENT))
	LOG.INFO(string.format("VDD10_DATA:%.4fV, %.4fuA",VDD10_DATA.VOLTAGE, VDD10_DATA.CURRENT))
	LOG.INFO(string.format("AVEE_DATA :%.4fV, %.4fuA",AVEE_DATA.VOLTAGE, AVEE_DATA.CURRENT))
		
	Current_table = {VDD18_DATA.CURRENT, VDD10_DATA.CURRENT, AVEE_DATA.CURRENT, VQPS_DATA.CURRENT}
	--table.insert(Current_table,VDD18_DATA.CURRENT)
	--table.insert(Current_table,VDD10_DATA.CURRENT)
	--table.insert(Current_table,AVEE_DATA.CURRENT)
	--table.insert(Current_table,VQPS_DATA.CURRENT)
	
	for i=1, #Current_table, 1 do
	
		cur = Current_table[i] / 1000
		if cur > 10 then --10mA
			os_short = "Fail"
			ret = 0
		end
	end

	
	local current_data = cjson.encode(Current_table)
	LOG.INFO(current_data)
	
	println("=================IO_Continuity_Test=========================")
	
	local io_continuity = "Pass"
	local io_continuity_table = {}
	local io_continuity_curent = -100
	POWER_OFF()
	TIME.DELAY(200)
	
	io_continuity_table = PPMU_IO_CHANNEL_TEST(io_continuity_curent)
	
	local io_continuity_data = cjson.encode(io_continuity_table)
	if io_continuity_data:find("OPEN") or io_continuity_data:find("CLOSE") or io_continuity_data:find("NG") then
		LOG.ERROR("PPMU_IO_TEST NG")
		ret = 0
		io_continuity = "Fail"
	end
	LOG.INFO(io_continuity_data)
	
	os_table = {os_short, io_continuity}
	println("测试时间：%f S",(TIME.TICK() - tim1)/1000)
	return ret,os_table
	

end
--pinlist = {2,3,4,6}
--POWER_SHORTS(-100, 350, pinlist)

function Power_Shorts_Test(Volt, delay, pinlist)
	-- 1. Set all IO to 0V.
	-- 2. Set all positive power supply pins to 0.1V, AVEE to –0.1V and all clamp to 10mA 
	local result_table ={}
	local Power_name={}
	local voltage={}
	local current={}
	
	if Volt==nil or delay==nil or pinlist==nil then
		local VOLTAGE_VALUE = 100 --mV
		local VOLTAGE_CLAMP = 200 --mV
		local CURRENT_CLAMP = 200*1000*1000 --nA
		local UNDER_VOLTAGE_PROTECTIVE = 0 --mV
		local UNDER_CURRENT_PROTECTIVE = 0  --mV
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
		
		PPMU_IO_ALL_MODE(PPMU_MODE_TABLE.GND)
    
		PPMU.RELAY_CLOSE(CHANNEL_TAB.VQPS_OUT)
		PPMU.RELAY_CLOSE(CHANNEL_TAB.VDDIO_OUT)
		PPMU.RELAY_CLOSE(CHANNEL_TAB.DVDD_OUT)
		PPMU.RELAY_CLOSE(CHANNEL_TAB.AVEE1_OUT)
		if TEST_MODE=="MT" then
			POWER.MULTI_SET(
		    { channel = P_VQPS,			en=1, range = 0x85, mode = 0, vol = 200, ovp = 300, uvp = 0, ocp = 200*1000*100, ucp = 0 },
		    { channel = P_VDD18,		en=1, range = 0x85, mode = 0, vol = 150, ovp = 250, uvp = 0, ocp = 200*1000*80,  ucp = 0 },
		    { channel = P_VDD10,		en=1, range = 0x85, mode = 0, vol = 100, ovp = 200, uvp = 0, ocp = 200*1000*80,  ucp = 0 },
		    { channel = P_AVEE,			en=1, range = 0x85, mode = 0, vol = -100, ovp = 200, uvp = 0, ocp = 200*1000*80,  ucp = 0 }
			)
			
		elseif TEST_MODE=="CP2" then
			PPMU.RELAY_CLOSE(CHANNEL_TAB.AVDD_OUT)
			POWER.MULTI_SET(
		    { channel = P_VQPS,			en=1, range = 0x85, mode = 0, vol = 200, ovp = 300, uvp = 0, ocp = 200*1000*100, ucp = 0 },
		    { channel = P_VDD18,		en=1, range = 0x85, mode = 0, vol = 150, ovp = 250, uvp = 0, ocp = 200*1000*80,  ucp = 0 },
		    { channel = P_VDD10,		en=1, range = 0x85, mode = 0, vol = 100, ovp = 200, uvp = 0, ocp = 200*1000*80,  ucp = 0 },
		    { channel = P_AVDD18,		en=1, range = 0x85, mode = 0, vol = 150, ovp = 250, uvp = 0, ocp = 200*1000*80,  ucp = 0 },
		    { channel = P_AVEE,			en=1, range = 0x85, mode = 0, vol = -100, ovp = 200, uvp = 0, ocp = 200*1000*80,  ucp = 0 }
			)
		
		end

		TIME.DELAY(80)--
		--3. Measure & Report current at VDD10,VDD18,AVEE,VQPS
		VQPS_DATA_VOLTAGE, VQPS_DATA_CURRENT=POWER.VOL_CUR(P_VQPS)
		VDD18_DATA_VOLTAGE, VDD18_DATA_CURRENT=POWER.VOL_CUR(P_VDD18)
		VDD10_DATA_VOLTAGE, VDD10_DATA_CURRENT=POWER.VOL_CUR(P_VDD10)
		AVDD18_DATA_VOLTAGE,AVDD18_DATA_CURRENT=POWER.VOL_CUR(P_AVDD18)--20251222add
		AVEE_DATA_VOLTAGE, AVEE_DATA_CURRENT=POWER.VOL_CUR(P_AVEE)
		
		VQPS_DATA_CURRENT  = VQPS_DATA_CURRENT/1e6
		VDD10_DATA_CURRENT = VDD10_DATA_CURRENT/1e6
		VDD18_DATA_CURRENT = VDD18_DATA_CURRENT/1e6
		AVEE_DATA_CURRENT  = AVEE_DATA_CURRENT/1e6
		AVDD18_DATA_CURRENT = AVDD18_DATA_CURRENT/1e6--20251222add
		
		--POWER_OFF()
		POWER.MULTI_SET(
		    { channel = P_VQPS,			en=0, range = 0x85, mode = 0, vol = 0, ovp = 300, uvp = 0, ocp = 1000*1000*100, ucp = 0 },
		    { channel = P_VDD18,		en=0, range = 0x85, mode = 0, vol = 0, ovp = 250, uvp = 0, ocp = 1000*1000*80,  ucp = 0 },
		    { channel = P_VDD10,		en=0, range = 0x85, mode = 0, vol = 0, ovp = 200, uvp = 0, ocp = 1000*1000*80,  ucp = 0 },
		    { channel = P_AVDD18,		en=0, range = 0x85, mode = 0, vol = 0, ovp = 250, uvp = 0, ocp = 1000*1000*80,  ucp = 0 },
		    { channel = P_AVEE,			en=0, range = 0x85, mode = 0, vol = 0, ovp = 200, uvp = 0, ocp = 1000*1000*80,  ucp = 0 }
		)
		PPMU_IO_ALL_MODE(PPMU_MODE_TABLE.NC)
		
		if TEST_MODE=="MT" then
		
			LOG.INFO(string.format("VQPS_DATA :%.4fV, %.4fmA",VQPS_DATA_VOLTAGE, VQPS_DATA_CURRENT))
			LOG.INFO(string.format("VDD18_DATA:%.4fV, %.4fmA",VDD18_DATA_VOLTAGE, VDD18_DATA_CURRENT))
			LOG.INFO(string.format("VDD10_DATA:%.4fV, %.4fmA",VDD10_DATA_VOLTAGE, VDD10_DATA_CURRENT))
			LOG.INFO(string.format("AVEE_DATA :%.4fV, %.4fmA",AVEE_DATA_VOLTAGE, AVEE_DATA_CURRENT))
			
			table.insert(result_table,VQPS_DATA_CURRENT)
			table.insert(result_table,VDD10_DATA_CURRENT)
			table.insert(result_table,VDD18_DATA_CURRENT)
			table.insert(result_table,AVEE_DATA_CURRENT)
		
		else
			LOG.INFO(string.format("VQPS_DATA :%.4fV, %.4fmA",VQPS_DATA_VOLTAGE, VQPS_DATA_CURRENT))
			LOG.INFO(string.format("VDD18_DATA:%.4fV, %.4fmA",VDD18_DATA_VOLTAGE, VDD18_DATA_CURRENT))
			LOG.INFO(string.format("VDD10_DATA:%.4fV, %.4fmA",VDD10_DATA_VOLTAGE, VDD10_DATA_CURRENT))
			LOG.INFO(string.format("AVEE_DATA :%.4fV, %.4fmA",AVEE_DATA_VOLTAGE, AVEE_DATA_CURRENT))
			LOG.INFO(string.format("AVDD18_DATA :%.4fV, %.4fmA",AVDD18_DATA_VOLTAGE, AVDD18_DATA_CURRENT))--20251222add
			
			table.insert(result_table,VQPS_DATA_CURRENT)
			table.insert(result_table,VDD10_DATA_CURRENT)
			table.insert(result_table,VDD18_DATA_CURRENT)
			table.insert(result_table,AVEE_DATA_CURRENT)
			table.insert(result_table,AVDD18_DATA_CURRENT)--20251222add
		
		end
		

		
		--Power_name=cjson.encode({"VPQS","VDD18","VDD10","AVEE","AVDD18"})
		--LOG.INFO(Power_name)
		--voltage=cjson.encode({VQPS_DATA_VOLTAGE,VDD18_DATA_VOLTAGE,VDD10_DATA_VOLTAGE,AVEE_DATA_VOLTAGE,AVDD18_DATA_VOLTAGE})
		--LOG.INFO(voltage)
		--current=cjson.encode({VQPS_DATA_CURRENT,VDD18_DATA_CURRENT,VDD10_DATA_CURRENT,AVEE_DATA_CURRENT,AVDD18_DATA_CURRENT})
		--LOG.INFO(current)
		local json_data = cjson.encode(result_table)
		LOG.INFO(json_data)
		return 0, json_data
	else
		local VOLTAGE_VALUE = Volt
		local delaytime = delay
		--local power_pchannel = pinlist
		local VOLTAGE_CLAMP = 200 --mV
		local CURRENT_CLAMP = 20*1000*1000 --nA
		local DATA_VOLTAGE = 0.0
		local DATA_CURRENT = 0.0
		for k,v in pairs(pinlist) do
			POWER_CHANNEL_VALUE(v, ON,VOLTAGE_VALUE, VOLTAGE_CLAMP, CURRENT_CLAMP)
			TIME.DELAY(delaytime)
			
			DATA_VOLTAGE, DATA_CURRENT=POWER.VOL_CUR(v)
			DATA_CURRENT  = DATA_CURRENT/1e6
			LOG.INFO(string.format("CHANNLE:%d,VQPS_DATA :%.4fV, %.4fmA",v,DATA_VOLTAGE, DATA_CURRENT))
			table.insert(result_table,DATA_CURRENT)
			
			POWER_CHANNEL_VALUE(v, OFF,VOLTAGE_VALUE, VOLTAGE_CLAMP, CURRENT_CLAMP)
		end
		
		
	end
	
	--local json_data = cjson.encode(result_table)
	--LOG.INFO(json_data)
	return 0,Power_name,voltage,current
end
--IO_Continuity_Test({200}, 50, 10)
function IO_Continuity_Test(current, delay, pinlist)
	--Test Sequence
	--1. Set all power rail to 0V
	--2. Set all IO pin to GND.
	--3. For IO Pin (GPIO,TPAD,I2C, Reset, refclk):
	--a. Connect one pin to PMU, Force 200uA, clamp 1.5V report voltage. Exp pass range(0.2~1.1V)
	--b. Force –200uA, CLAMP -1.5v, report voltage. Exp pass range(-0.2~-1.1V)
	--c. Connect this pin back to GND
	
	local time1=TIME.TICK()
	local result_table = {}
	local result_table1 = {}
	local curent={}
	--POWER_OFF()
	--TIME.DELAY(200)
	if current==nil or delay==nil or pinlist==nil then
		local curent = {200,-200}
		
		result_table = PPMU_IO_CHANNEL_TEST(curent,delay)
	
	else
		--local curent = -100
		
			
			for c,b in pairs(current) do
				local ioname=""
				for k,v in pairs(IO_PPMU_CHANEL_negative) do
					if pinlist == v.PinNo then
						ioname = v.PinName
		
					end
					--LOG.INFO(string.format("no:%d",k))	
				end

				result_table1 = PPMU_IO_CHANNEL_TEST_Customize(b,pinlist,ioname,delay)
				table.insert(result_table,result_table1)
			end
		
	end
	
	
	
	local json_data = cjson.encode(result_table)
	if json_data:find("OPEN") or json_data:find("CLOSE") or json_data:find("NG") then
		LOG.ERROR("PPMU_IO_TEST NG")
		return 1,json_data
	end
	LOG.INFO(json_data)
	local time2=TIME.TICK()
	LOG.DEBUG("测试时间"..(time2/1000 - time1/1000))
	return 0,json_data
	
end
--GPIO3_A_SET(0) 
function MIPI_Communication_Test()
	LOG.DEBUG("<MIPI_Communication_Test>")
	local data_table = {}
	local ret = 0
	local test_data = {
		0xAAAAAAAA,
		0x55555555,
		0xFFFFFFFF,
		0x00000000,
	}
	
	--PPMU.CAL_EN(1)
   	--PPMU.CAL_EN(0)    --5V on
   	TIME.DELAY(10)
	DMIPI.VID()
	DMIPI.HS()
	for k, v in ipairs(test_data) do
		F_MIPI_WRITE(0x0FFC, v)
		TIME.DELAY(10)
		local read_data = IIC_R_PEQUIN(0x0FFC, 4)
		--TIME.DELAY(50)
		--local read_data = F_READ_FOR_MIPI(0x0FFC, 4)
		local hex_str = string.format("0x%08X",read_data)
		println(hex_str)
		table.insert(data_table,hex_str)
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
	return ret,json_data
	
end

function Idle_Power_Test()
	local tim1 = TIME.TICK()
	println("=================Idle_Power_Test=========================")
	local ret = 1
	local idle_table ={}	
	local Power_name={}
	local voltage={}
	local current={}
	
	local VDD10_DATA_VOLTAGE = 0.0
	local VDD18_DATA_VOLTAGE = 0.0
	local AVDD18_DATA_VOLTAGE = 0.0 --20251222 add
	local AVEE_DATA_VOLTAGE = 0.0
		
	
	local VDD10_DATA_CURRENT = 0.0
	local VDD18_DATA_CURRENT = 0.0
	local AVDD18_DATA_CURRENT = 0.0 --20251222 add
	local AVEE_DATA_CURRENT = 0.0
	--POWER_OFF()
	--TIME.DELAY(100)
	POWER_ON_IDLE_POWER()
	--TIME.DELAY(100)
	VDD18_DATA_VOLTAGE, VDD18_DATA_CURRENT=POWER.VOL_CUR(P_VDD18)
	VDD10_DATA_VOLTAGE, VDD10_DATA_CURRENT=POWER.VOL_CUR(P_VDD10)
	AVDD18_DATA_VOLTAGE, AVDD18_DATA_CURRENT=POWER.VOL_CUR(P_AVDD18) --20251222 add
	AVEE_DATA_VOLTAGE, AVEE_DATA_CURRENT=POWER.VOL_CUR(P_AVEE)

	VDD18_DATA_CURRENT = VDD18_DATA_CURRENT/1e6
	VDD10_DATA_CURRENT = VDD10_DATA_CURRENT/1e6
	AVDD18_DATA_CURRENT = AVDD18_DATA_CURRENT/1e6
	AVEE_DATA_CURRENT  = AVEE_DATA_CURRENT/1e6
	
	TOTALPOWER=(math.abs(VDD18_DATA_CURRENT*VDD18_DATA_VOLTAGE)+math.abs(VDD10_DATA_VOLTAGE*VDD10_DATA_CURRENT)+math.abs(AVDD18_DATA_CURRENT*AVDD18_DATA_VOLTAGE)+math.abs(AVEE_DATA_VOLTAGE*AVEE_DATA_CURRENT))
	TOTALPOWER=TOTALPOWER/1e3
	
	LOG.INFO(string.format("VDD18_DATA:%.4fV, %.4fmA",VDD18_DATA_VOLTAGE, VDD18_DATA_CURRENT))
	LOG.INFO(string.format("VDD10_DATA:%.4fV, %.4fmA",VDD10_DATA_VOLTAGE, VDD10_DATA_CURRENT))
	LOG.INFO(string.format("AVDD18_DATA:%.4fV, %.4fmA",AVDD18_DATA_VOLTAGE, AVDD18_DATA_CURRENT))
	LOG.INFO(string.format("AVEE_DATA :%.4fV, %.4fmA",AVEE_DATA_VOLTAGE, AVEE_DATA_CURRENT))
	LOG.INFO(string.format("TOTALPOWER :%.4fV",TOTALPOWER))
	--POWER_OFF()
	table.insert(idle_table,math.abs(VDD18_DATA_CURRENT))
	table.insert(idle_table,math.abs(VDD10_DATA_CURRENT))
	table.insert(idle_table,math.abs(AVDD18_DATA_CURRENT))
	table.insert(idle_table,AVEE_DATA_CURRENT)
	table.insert(idle_table,TOTALPOWER)

	
	local idle_table_data = cjson.encode(idle_table)
	LOG.INFO(idle_table_data)
	
	--println("测试时间：%f S",(TIME.TICK() - tim1)/1000)
	--return 0,Power_name,voltage,current
	return 0,idle_table_data


end

function Idle_Power_Vmin_Test()
	local tim1 = TIME.TICK()
	println("=================Idle_Power_Vnim_Test=========================")
	local ret = 1
	local idle_table ={}
	local Power_name={}
	local voltage={}
	local current={}

	
	local VDD10_DATA_VOLTAGE = 0.0
	local VDD18_DATA_VOLTAGE = 0.0
	local AVDD18_DATA_VOLTAGE = 0.0 --20251222 add
	local AVEE_DATA_VOLTAGE = 0.0
		
	
	local VDD10_DATA_CURRENT = 0.0
	local VDD18_DATA_CURRENT = 0.0
	local AVDD18_DATA_CURRENT = 0.0 --20251222 add
	local AVEE_DATA_CURRENT = 0.0
	--POWER_OFF()
	--TIME.DELAY(100)
	POWER_ON_IDLE_POWER_Min()
	--TIME.DELAY(100)
	VDD18_DATA_VOLTAGE, VDD18_DATA_CURRENT=POWER.VOL_CUR(P_VDD18)
	VDD10_DATA_VOLTAGE, VDD10_DATA_CURRENT=POWER.VOL_CUR(P_VDD10)
	AVDD18_DATA_VOLTAGE, AVDD18_DATA_CURRENT=POWER.VOL_CUR(P_AVDD18) --20251222 add
	AVEE_DATA_VOLTAGE, AVEE_DATA_CURRENT=POWER.VOL_CUR(P_AVEE)
	

	VDD18_DATA_CURRENT = VDD18_DATA_CURRENT/1e6
	VDD10_DATA_CURRENT = VDD10_DATA_CURRENT/1e6
	AVDD18_DATA_CURRENT = AVDD18_DATA_CURRENT/1e6
	AVEE_DATA_CURRENT  = AVEE_DATA_CURRENT/1e6
	
	LOG.INFO(string.format("VDD18_DATA:%.4fV, %.4fmA",VDD18_DATA_VOLTAGE, VDD18_DATA_CURRENT))
	LOG.INFO(string.format("VDD10_DATA:%.4fV, %.4fmA",VDD10_DATA_VOLTAGE, VDD10_DATA_CURRENT))
	LOG.INFO(string.format("AVDD18_DATA:%.4fV, %.4fmA",AVDD18_DATA_VOLTAGE, AVDD18_DATA_CURRENT))
	LOG.INFO(string.format("AVEE_DATA :%.4fV, %.4fmA",AVEE_DATA_VOLTAGE, AVEE_DATA_CURRENT))
	POWER_OFF()
	table.insert(idle_table,math.abs(VDD18_DATA_CURRENT))
	table.insert(idle_table,math.abs(VDD10_DATA_CURRENT))
	table.insert(idle_table,math.abs(AVDD18_DATA_CURRENT))
	table.insert(idle_table,math.abs(AVEE_DATA_CURRENT))
	
	Power_name=cjson.encode({"VDD18","VDD10","AVEE","AVDD18"})
	LOG.INFO(Power_name)
	voltage=cjson.encode({VDD18_DATA_VOLTAGE,VDD10_DATA_VOLTAGE,AVEE_DATA_VOLTAGE,AVDD18_DATA_VOLTAGE})
	LOG.INFO(voltage)
	current=cjson.encode({VDD18_DATA_CURRENT,VDD10_DATA_CURRENT,AVEE_DATA_CURRENT,AVDD18_DATA_CURRENT})
	LOG.INFO(current)
	
	--local idle_table_data = cjson.encode(idle_table)
	--LOG.INFO(idle_table_data)
	
	println("测试时间：%f S",(TIME.TICK() - tim1)/1000)
	return 0,Power_name,voltage,current


end

--舜禹
function EFuse_PreRead()
	local tim1 = TIME.TICK()
	println("=================EFuse_DieID_Read=========================")
	local ret = 0
	local dieid_table = {}
	local Efuse_data = {}
	local bitStream1 = "0x"
	local bitStream2 = "0x"
	local bitStream3 = "0x"
	local results_tables = {}
	
	Efuse_data = EFuse_full_bank_read()
	
	local Efuse_str= CombineEfuseToHexStr(Efuse_data)

	results_tables=dumpEfuse(Efuse_str)
	println("测试时间：%f S",(TIME.TICK() - tim1)/1000)
	local idle_table_data = cjson.encode(results_tables)
	LOG.INFO(idle_table_data)
	return ret, idle_table_data
end


function dumpEfuse(Efuse_str)

    -- 初始化存储
    local results_table = {}
    -- 核心循环（遍历 efuse_field 表）
    for _, field in ipairs(efuse_field) do
        -- 读取值
        local val = ExtractBitsFromHex(Efuse_str, field.s, field.e)
        raw_values[field.name] = val				--存储到全局
        if field.MATCHED == 1 then
        	table.insert(results_table, (val == 0x00) and 0 or 1)
        else
			table.insert(results_table, val)
        end
        println(string.format(field.fmt, val))
    end

    local LotID = string.char(
        raw_values.L8+0x20,raw_values.L7+0x20,raw_values.L6+0x20,raw_values.L5+0x20,
        raw_values.L4+0x20,raw_values.L3+0x20,raw_values.L2+0x20,raw_values.L1+0x20,raw_values.L0+0x20
    )
    println("LotID:" .. LotID)

    local ts = raw_values.timestamp
    local dateY = timestampToDateTime(0, ts, true)
    local dateM = timestampToDateTime(1, ts, true)
    local dateD = timestampToDateTime(2, ts, true)
    println("DateTime:%s", dateY)
    println("DateTime:%s", dateM)
    println("DateTime:%s", dateD)
    
    table.insert(results_table, dateY)
    table.insert(results_table, dateM)
    table.insert(results_table, dateD)
    table.insert(results_table, LotID)
    
    --判断机台所对应的pre
    local field_names = {"code","rev","x","y","L0","L1","L2","L3","L4","L5","L6","L7","L8","wafer","fab","foundry","jtagID","sub","min0","maj","b1","timestamp","S1"}
	local CRC1 = CRC_CRC_Calculation_NEW_8BIT(BuildFields(field_names),CRC1_MINLEN)
	table.insert(results_table,CRC1)
	table.insert(results_table,raw_values["CRC1"])
	if CRC1 == raw_values["CRC1"] then  --判断值是否一样，一样为1不一样为0
		table.insert(results_table,1)
	else
		table.insert(results_table,0)

	end
	
	if TEST_MODE =="MT" then
    	local field_names={ raw_values["B3"],raw_values["S3"]}
    	local CRC3 = CRC_CRC_Calculation_NEW_4BIT(field_names, CRC3_MINLEN)
 
		table.insert(results_table,CRC3)
		table.insert(results_table,raw_values["CRC3"])
		if CRC3 == raw_values["CRC3"] then  --判断值是否一样，一样为1不一样为0
			table.insert(results_table,1)
		else
			table.insert(results_table,0)
		end
		
		local field_names={ "DAC_MODE","DAC_CAL","DAC_POINTA","DAC_POINTB"}
		local CRCforDACBlock = CRC_CRC_Calculation_NEW_8BIT(BuildFields(field_names),dac_crc_MINLEN)
		table.insert(results_table,CRCforDACBlock)
		table.insert(results_table,raw_values["CRCforDACBlock"])
		if CRCforDACBlock == raw_values["CRCforDACBlock"] then  --判断值是否一样，一样为1不一样为0
			table.insert(results_table,1)
		else
			table.insert(results_table,0)
		end
			
		local field_names={ "BANDGAP","TSENSOR_TEMP","TSENSOR_ADC1Q","TSENSOR_ADC3Q","TSENSOR_CODEA","TSENSOR_CODEB"}
		local CRCforTempSensorBlock = CRC_CRC_Calculation_NEW_8BIT(BuildFields(field_names),CRC_TEMP_MINLEN)

		table.insert(results_table,CRCforTempSensorBlock)
		table.insert(results_table,raw_values["CRCforTempSensorBlock"])
		if CRCforTempSensorBlock == raw_values["CRCforTempSensorBlock"] then  --判断值是否一样，一样为1不一样为0
			table.insert(results_table,1)
		else
			table.insert(results_table,0)
		end
	end
    return results_table
end

function BuildFields(field_names)
	local result={}
	for i = 1,#field_names do
		local number = field_names[i]
		local value = raw_values[number]
		table.insert(result,value)
	end
	return result
end

function CRC_CRC_Calculation_NEW_4BIT(CRC_fields,CRC_MINLEN)

	local  CRC_BIN_file, CRC_BIN_file_len=concat_bits(CRC_fields,CRC_MINLEN)
	println("CRC_file:0b" .. string.format("%s", CRC_BIN_file)) 
	LOG.INFO(string.format("len:%s",CRC_BIN_file_len))
	
	
	
	local CRC_4BIT=CRC_Calculation_4bit(CRC_BIN_file,0)
	LOG.INFO(string.format("CRC_4BIT:%d",CRC_4BIT))
	return CRC_4BIT
end

function CRC_CRC_Calculation_NEW_8BIT(CRC_fields,CRC_MINLEN)

	local CRC_BIN_file, CRC_BIN_file_len=concat_bits(CRC_fields,CRC_MINLEN)
	println("CRC_file:0b" .. string.format("%s", CRC_BIN_file)) 
	LOG.INFO(string.format("len:%s",CRC_BIN_file_len))
	
	
	
	local CRC_8BIT=crc8_calc_bits(CRC_BIN_file)
	LOG.INFO(string.format("CRC_8BIT:%d",CRC_8BIT))
	return CRC_8BIT
end


function concat_bits(fields,min_len)
    local bin_str = ""
    -- 从后往前拼：timestamp(最高位) → code(最低位)
    for i = #fields, 1, -1 do
        local val = fields[i]
        --local bits = get_bit_length(val)
        bin_str = bin_str .. toBinary_crc(val, min_len[i])
    end
    return bin_str, #bin_str
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

function crc8_calc_bits(bits_str)
    return crc8_update_bits(0x00, bits_str)
end

function crc8_update_bits(crc, bits_str)
    if crc == nil then
        crc = 0x00
    end

    if type(bits_str) ~= "string" then
        error("bits_str must be a binary string")
    end

    local poly = 0x9B
    local mask = 0xFF

    -- remove spaces / underscores for readability
    local clean = bits_str:gsub("[%s_]+", "")

    -- validate input
    for i = 1, #clean do
        local c = clean:sub(i, i)
        if c ~= "0" and c ~= "1" then
            error("bits_str must contain only '0' or '1'")
        end
    end

    -- LSB first:
    -- if input string is written in normal order (MSB -> LSB),
    -- then processing from string end to start gives LSB-first behavior.
    for i = #clean, 1, -1 do
        local bit = tonumber(clean:sub(i, i))
        local fb = bit ~ ((crc >> 7) & 0x1)
        crc = (crc << 1) & mask
        if fb ~= 0 then
            crc = crc ~ poly
        end
    end

    return crc
end

function CRC_Calculation_4bit(bits_str,direction)
    -- 将B和S拼接成8bit数据V
    -- B为高4位，S为低4位
    --local V = (S & 0x0F) << 4 | (B & 0x0F)
    local bits_str_len=#bits_str
    local bits_str_value = tonumber(bits_str,2) or 0
    LOG.INFO(string.format("S_valid:%f",bits_str_value))
    -- 初始化CRC为0
    local CRC = {
        [0] = 0,  -- bit0 (LSB)
        [1] = 0,  -- bit1
        [2] = 0,  -- bit2
        [3] = 0   -- bit3 (MSB)
    }
    
    if direction == 1 then
        -- 从高位开始处理：bit7到bit0
        for bit = bits_str_len-1, 0, -1 do
            -- 获取V的第bit位
            local V_bit = (bits_str_value >> bit) & 0x01
            
            -- V[bit]与CRC[bit3]进行XOR运算
            local X0 = V_bit ~ CRC[3]
            
            -- 计算新的CRC值
            local newCRC = {}
            newCRC[3] = X0 ~ CRC[2]  -- X[bit0]与CRC[bit2]进行XOR运算，得X[bit3]
            newCRC[2] = CRC[1]       -- X[bit2] = CRC[bit1]
            newCRC[1] = CRC[0]       -- X[bit1] = CRC[bit0]
            newCRC[0] = X0           -- X[bit0] = 原来的X[bit0]
            
            -- 更新CRC
            CRC = newCRC
        end
    else
        -- 从低位开始处理：bit0到bit7
        for bit = 0, bits_str_len-1 do
            -- 获取V的第bit位
            local V_bit = (bits_str_value >> bit) & 0x01
            
            -- V[bit]与CRC[bit3]进行XOR运算
            local X0 = V_bit ~ CRC[3]
            
            -- 计算新的CRC值
            local newCRC = {}
            newCRC[3] = X0 ~ CRC[2]  -- X[bit0]与CRC[bit2]进行XOR运算，得X[bit3]
            newCRC[2] = CRC[1]       -- X[bit2] = CRC[bit1]
            newCRC[1] = CRC[0]       -- X[bit1] = CRC[bit0]
            newCRC[0] = X0           -- X[bit0] = 原来的X[bit0]
            
            -- 更新CRC
            CRC = newCRC
        end
    end
    
    -- 将4bit CRC数组转换为整数
    local result = (CRC[3] << 3) | (CRC[2] << 2) | (CRC[1] << 1) | CRC[0]
    return result
end


function I2C_Communication_Test()
	LOG.DEBUG("<I2CCommunication_Test>")
	local data_table = {}
	local ret = 0
	local test_data = {
		0xAAAAAAAA,
		0x55555555,
		0xFFFFFFFF,
		0x00000000
	}
	
	for k, v in ipairs(test_data) do
		IIC_W_PEQUIN(0x0FFC, v)
		--TIME.DELAY(10)
		local read_data = IIC_R_PEQUIN(0x0FFC, 4)
		local hex_str = string.format("0x%08X",read_data)
		println(hex_str)
		table.insert(data_table,hex_str)
		if v ~= read_data then
			LOG.ERROR("IIC read NG")
			ret = -1
		end
	end
	LOG.INFO(string.format("0x%08X",IIC_CONFIG.SLAVE_ADDR))
	--POWER_OFF() --20251223 add
	local json_data = cjson.encode(data_table)
	LOG.INFO(json_data)
	return ret,json_data
	
end

--20260122 add
--I2C_Single_RW(0x0FFC,0x55555522)
function I2C_Single_RW(addr,data)
	LOG.DEBUG("<I2C_Single_RW>")
	local data_table = {}
	local ret = 0
	--POWER_OFF()
	--TIME.DELAY(200)
	--POWER_ON()

	IIC_W_PEQUIN(addr, data)
	--TIME.DELAY(10)
	local read_data = IIC_R_PEQUIN(addr)
	local hex_str = string.format("0x%08X",read_data)
	println(hex_str)
	table.insert(data_table,hex_str)
	if data ~= read_data then
		LOG.ERROR("IIC read NG")
		ret = -1
	end
	--POWER_OFF() --20251223 add
	local json_data = cjson.encode(data_table)
	LOG.INFO(json_data)
	return ret,json_data
	
end
--20260122 add

function EFuse_full_bank_read()

	i3c_write(0x0140, 0x10000000) -- Select eFuse debug field
	i3c_write(0x0148, 0xffffffff) -- Enable all GPIO pins
	i3c_write(0x0138, 0x00001909) -- Mux eFuse bus onto GPIOs
	i3c_write(0x0000, 0x0010C000) -- Enable eFuse controller clock
	i3c_write(0x015c, 0x00000011) -- Set read setup, hold and pulse width
	i3c_write(0x0164, 0x00000519) -- Set VQPS setup & hold
	
	--TIME.DELAY(10)
	local efuse_data = {}
	local num_rows = 64 -- Adjust based on eFuse size
	-- Read entire eFuse block
	for row = 0, num_rows - 1 do
		local read_cmd = 0x00004000 | row -- Read command with row address
		i3c_write(0x0154, read_cmd)
		--wait(10e-6) -- Wait for read to complete
		TIME.DELAY(1)
		-- Read eFuse byte from CSR
		local efuse_byte = i3c_read(0x0158) & 0xFF
		efuse_data[row+1] = efuse_byte
		--println("efuse_data[%d]=%02X",row+1,efuse_data[row+1])
	end
	return efuse_data
	
end

function reverse8(x)
    local result = 0
    for i = 0, 7 do
        local bit = (x >> i) & 1
        result = result | (bit << (7 - i))
    end
    return result
end
	

function F_28M2_Interface_Check()
	local tim1 = TIME.TICK()
	LOG.DEBUG("<I2CCommunication_Test>")
	local interface_table = {}
	local i2c_table = {}
	local i3c_table = {}
	local i2c_data = "Pass"
	local i3c_data = "NO Value"
	local code_90 = "NO Value"
	local code_270 = "NO Value"
	local prbs = "NO Value"
	local mipi_result = "NO Value"
	local ret =1
	local test_data = {
		0xAAAAAAAA,
		0x55555555
	}
	for k, v in ipairs(test_data) do
		IIC_W_PEQUIN(0x0FFC, v)
		TIME.DELAY(10)
		local read_data = IIC_R_PEQUIN(0x0FFC, 4)
		local hex_str = string.format("0x%08X",read_data)
		println(hex_str)
		table.insert(i2c_table,hex_str)
		if v ~= read_data then
			LOG.ERROR("IIC read NG")
			i2c_data = "Fail"
			ret = 0
			
		end
	end
	local i2c_val = cjson.encode(i2c_table)
	LOG.INFO(i2c_val)

	table.insert(interface_table, i2c_data)
	table.insert(interface_table, i3c_data)
	table.insert(interface_table, code_90)
	table.insert(interface_table, code_270)
	table.insert(interface_table, prbs)
	table.insert(interface_table, mipi_result)
	println("测试时间：%f S",(TIME.TICK() - tim1)/1000)
	return ret, interface_table

end


function I2C_Address_efuse()
	local tim1 = TIME.TICK()
	local results_table={}
	local result=0
	local addr_table = {}
	local ret = 1
	local i2c_data = "NO Value"
	local i2c_val = 0x00
	local i2c_addressLSB = 0x1F0
	local i2c_bitwidth = 2
	local i2c_bitStart = 0
	local i2c_bitStream1 = "0x"
	local i2c_bitStream2 = "0x"
	local i2c_Efuse_data = 0
	println("=================I2C_Address_efuse =========================")
	if Color == "Red" then
		i2c_val = 0x01
		IIC_CONFIG.SLAVE_ADDR = IIC_SLV_R
	elseif Color == "Green" then
		i2c_val = 0x02
		IIC_CONFIG.SLAVE_ADDR = IIC_SLV_G
	elseif Color == "Blue" then
		i2c_val = 0x03
		IIC_CONFIG.SLAVE_ADDR = IIC_SLV_B
	end
	efuse_write(i2c_val, i2c_addressLSB, i2c_bitwidth, i2c_bitStart)
	IIC_CONFIG.init_default()
	POWER_OFF()
	TIME.DELAY(50)
	POWER_ON()
	TIME.DELAY(200)
	i2c_Efuse_data = EFuse_bits_read(i2c_addressLSB, i2c_bitwidth, i2c_bitStart)
	if i2c_Efuse_data == i2c_val then
		LOG.INFO(string.format("efuse_DATA:0x%X",i2c_Efuse_data))
	else
		LOG.ERROR(string.format("FUSE VALUE ERROR:0x%X",i2c_Efuse_data))
	end
	table.insert(results_table,i2c_Efuse_data)
	local json_data = cjson.encode(results_table)
	LOG.INFO(json_data)
	println("测试时间：%f S",(TIME.TICK() - tim1)/1000)
	return 0, json_data
	
end

function DAC_Divider_efuse()
	local results_table={}
	local addr_table = {}
	println("=================DAC_Divider_efuse =========================")

		
	local dac_data = "NO Value"
	local dac_val = 0x00
	local dac_addressLSB = 0x100
	local dac_bitwidth = 1
	local dac_bitStart = 0
	local dac_bitStream1 = "0x"
	local dac_bitStream2 = "0x"
	

	if Color == "Red" then
		dac_val = 0x00
	elseif Color == "Green" then
		dac_val = 0x01
	elseif Color == "Blue" then
		dac_val = 0x01
	end
	efuse_write(dac_val, dac_addressLSB, dac_bitwidth, dac_bitStart)
	
	local DAC_Divider_efuse_data = EFuse_bits_read(dac_addressLSB, dac_bitwidth, dac_bitStart)

	if DAC_Divider_efuse_data == dac_val then
	
		LOG.INFO(string.format("efuse_DATA:0x%X",DAC_Divider_efuse_data))
		table.insert(results_table,DAC_Divider_efuse_data)
	else
		LOG.ERROR(string.format("FUSE VALUE ERROR:0x%X",DAC_Divider_efuse_data))
		table.insert(results_table,DAC_Divider_efuse_data)
	end
	local json_data = cjson.encode(results_table)
	LOG.INFO(json_data)
	
	println("测试时间：%f S",(TIME.TICK() - tim1)/1000)
	--return ret, addr_table
	return 0, json_data


end
--efuse_write(1, 0xB0, 4, 0)
function  efuse_write(val, addressLSB, bitwidth, bitStart)
	local efuse_bit = 0
	local addr_shift = 0
	local Efuse_data = 0
	local result=0
	Efuse_data = EFuse_bits_read(addressLSB, bitwidth, bitStart)
	--Efuse_data = 0
	if Efuse_data == 0 then
	
		--set_voltage("VQPS", 1.8V)
		VQPS(ON)
		--wait(1e-3) -- Wait to settle
		TIME.DELAY(300)
		println("efuse_write(0x%X,0x%04X,%d,%d)",val, addressLSB, bitwidth, bitStart)
		addressLSB = math.floor((addressLSB/8))
		
		println("efuse_write(0x%X,0x%04X,%d,%d)",val, addressLSB, bitwidth, bitStart)
		-- Configure eFuse programming
		i3c_write(0x0000, 0x0010C000) -- Enable eFuse controller clock
		i3c_write(0x0160, 0x00001f4d) -- Program setup, hold and pulse width
		i3c_write(0x0164, 0x00000519) -- VQPS setup & hold
		TIME.DELAY(100)
		for i=0, bitwidth-1 do
			bit=(val>> i)&1
			efuse_bit = bitStart + addr_shift
			
			if efuse_bit > 7 then
				addressLSB = addressLSB + 1
				efuse_bit = 0
				bitStart = 0
				addr_shift = 0
			end
			addr_shift = addr_shift + 1
			
			println("efuse_bit = 0b%s",toBinary(efuse_bit))
			if bit == 1 then
			
				i3c_write(0x0154, 0x00008000|((efuse_bit << 6) |addressLSB))
				TIME.DELAY(10)
			end
		end
	
		i3c_write(0x0000, 0x0010D000) -- Disable eFuse controller clock
		TIME.DELAY(100)
		--set_voltage("VQPS", 0V)
		VQPS(OFF)
		
	else 
		println("NO NEED TO WRITE EFUSE")
		
	end
	--Efuse_data = EFuse_bits_read(addressLSB, bitwidth, bitStart)
	--return val
end

function  efuse_write_burning(val, addressLSB, bitwidth, bitStart)
	local efuse_bit = 0
	local addr_shift = 0
	local Efuse_data = 0
	Efuse_data = EFuse_bits_read(addressLSB, bitwidth, bitStart)
	--Efuse_data = 0
	--if Efuse_data == 0 then
	
		--set_voltage("VQPS", 1.8V)
		VQPS(ON)
		--wait(1e-3) -- Wait to settle
		TIME.DELAY(300)
		println("efuse_write(0x%X,0x%04X,%d,%d)",val, addressLSB, bitwidth, bitStart)
		addressLSB = math.floor(addressLSB/8)
		
		println("efuse_write(0x%X,0x%04X,%d,%d)",val, addressLSB, bitwidth, bitStart)
		-- Configure eFuse programming
		i3c_write(0x0000, 0x0010C000) -- Enable eFuse controller clock
		i3c_write(0x0160, 0x00001f4d) -- Program setup, hold and pulse width
		i3c_write(0x0164, 0x00000519) -- VQPS setup & hold
		TIME.DELAY(100)
		for i=0, bitwidth-1 do
			bit=(val>> i)&1
			efuse_bit = bitStart + addr_shift
			
			if efuse_bit > 7 then
				addressLSB = addressLSB + 1
				efuse_bit = 0
				bitStart = 0
				addr_shift = 0
			end
			addr_shift = addr_shift + 1
			
			println("efuse_bit = 0b%s",toBinary(efuse_bit))
			if bit == 1 then
			
				i3c_write(0x0154, 0x00008000|((efuse_bit << 6) |addressLSB))
				TIME.DELAY(10)
			end
		end
	
		i3c_write(0x0000, 0x0010D000) -- Disable eFuse controller clock
		TIME.DELAY(100)
		--set_voltage("VQPS", 0V)
		VQPS(OFF)
		
	--else 
		--println("NO NEED TO WRITE EFUSE")
	--end
	--Efuse_data = EFuse_bits_read(addressLSB, bitwidth, bitStart)

end
function  efuse_write_I2C_R_to_B(val, addressLSB, bitwidth, bitStart)
	local efuse_bit = 0
	local addr_shift = 0
	local Efuse_data = 0
	Efuse_data = EFuse_bits_read(addressLSB, bitwidth, bitStart)
	Efuse_data = 0
	if Efuse_data == 0 then
	
		--set_voltage("VQPS", 1.8V)
		VQPS(ON)
		--wait(1e-3) -- Wait to settle
		TIME.DELAY(300)
		println("efuse_write(0x%X,0x%04X,%d,%d)",val, addressLSB, bitwidth, bitStart)
		addressLSB = math.floor(addressLSB/8)
		
		println("efuse_write(0x%X,0x%04X,%d,%d)",val, addressLSB, bitwidth, bitStart)
		-- Configure eFuse programming
		i3c_write(0x0000, 0x0010C000) -- Enable eFuse controller clock
		i3c_write(0x0160, 0x00001f4d) -- Program setup, hold and pulse width
		i3c_write(0x0164, 0x00000519) -- VQPS setup & hold
		TIME.DELAY(100)
		for i=0, bitwidth-1 do
			bit=(val>> i)&1
			efuse_bit = bitStart + addr_shift
			
			if efuse_bit > 7 then
				addressLSB = addressLSB + 1
				efuse_bit = 0
				bitStart = 0
				addr_shift = 0
			end
			addr_shift = addr_shift + 1
			
			println("efuse_bit = 0b%s",toBinary(efuse_bit))
			if bit == 1 then
			
				i3c_write(0x0154, 0x00008000|((efuse_bit << 6) |addressLSB))
				TIME.DELAY(10)
			end
		end
	
		i3c_write(0x0000, 0x0010D000) -- Disable eFuse controller clock
		TIME.DELAY(100)
		--set_voltage("VQPS", 0V)
		VQPS(OFF)
		
	else 
		println("NO NEED TO WRITE EFUSE")
	end
	--Efuse_data = EFuse_bits_read(addressLSB, bitwidth, bitStart)

end
function EFuse_bits_read(addressLSB, bitwidth, bitStart)
	-- Configure eFuse reading
	i3c_write(0x0140, 0x10000000) -- Select eFuse debug field
	i3c_write(0x0148, 0xffffffff) -- Enable all GPIO pins
	i3c_write(0x0138, 0x00001909) -- Mux eFuse bus onto GPIOs
	i3c_write(0x0000, 0x0010C000) -- Enable eFuse controller clock
	i3c_write(0x015c, 0x00000011) -- Set read setup, hold and pulse width
	i3c_write(0x0164, 0x00000519) -- Set VQPS setup & hold
	
	TIME.DELAY(10)
	local results_table={}
	local efuse_data = {}
	local rows_start = math.floor((addressLSB/8)) -- rows_start
	local rows_end = math.ceil(((addressLSB+4)/8)) -- rows_end
	-- Read entire eFuse block
	local n = 0
	for row = rows_start, rows_end do
		local read_cmd = 0x00004000 | row -- Read command with row address
		i3c_write(0x0154, read_cmd)
		--wait(10e-6) -- Wait for read to complete
		TIME.DELAY(10)
		-- Read eFuse byte from CSR
		local efuse_byte = i3c_read(0x0158) & 0xFF
		efuse_data[n+1] = efuse_byte
		--println("read efuse_data[%d]=0x%02X",n+1,efuse_data[n+1])
		n = n+1
	end
	local efuse_data_hex = 0
	--local efuse_data = {0x15}
	local a = 0
	for i = 1,#efuse_data do 
		efuse_data_hex = efuse_data_hex | efuse_data[i] << a *8
		a = a+1
		--println("efuse_data_hex：0x%x",efuse_data_hex)
	end
	--println("readefuse_data_hex：0x%x",efuse_data_hex) 
	local mask = 1
	efuse_data_bin = extract_bits(efuse_data_hex, bitStart, bitwidth)
	--println("read efuse_data_bin：0x%x",efuse_data_bin) 
	--println("read efuse_data_bin：0b'%s",toBinary(efuse_data_bin)) 
	return efuse_data_bin
	
end
	

function F_28M2_TrimAndCal()
	local tim1 = TIME.TICK()
	local ret = 1
	local osc_code = "NO Value"
	local bandGap_code = nil
	local anode_code = "NO Value"
	local quarter_code = nil
	local three_quarter_code = nil
	local c50_code = "50"
	local adc_code0 = nil
	local adc_code1 = nil
	local best_cal_trim = nil
	local pointA = nil
	local pointB = nil
	local trimAndCal_table = {}
	--local table = {osc_code,bandGap_code, anode_code, quarter_code, three_quarter_code, c50_code, adc_code0, adc_code1, best_cal_trim, pointA, pointB}
	println("=================test_bandgap_trim =========================")
	trim_table = test_bandgap_trim()
	bandGap_code = trim_table["best_trim"]
	
	println("=================test_temperature_sensor_adc =========================")
    local resTsnsADC = test_temperature_sensor_adc()
    LOG.INFO(string.format("TEMP sns ADC 1/4 CODE:0X%x",resTsnsADC["1qFS"]))
    LOG.INFO(string.format("TEMP sns ADC 3/4 CODE:0X%x",resTsnsADC["3qFS"]))
    quarter_code = resTsnsADC["1qFS"]
    three_quarter_code = resTsnsADC["3qFS"]
    c50_code = resTsnsADC["50C"]
    println("=================test_temperature_sensor_thermometer =========================")
    local resTsensor = test_temperature_sensor_thermometer()
    LOG.INFO(string.format("TEMP SENSOR 0:0X%x",resTsensor["tsns0"]))
    LOG.INFO(string.format("TEMP SENSOR 1:0X%x",resTsensor["tsns1"]))
    adc_code0 = resTsensor["tsns0"]
    adc_code1 = resTsensor["tsns1"]
    AVEE1(ON)
    TIME.DELAY(100)
    println("=================dac_full_range_calibration =========================")
    resDAC_RangeCal = dac_full_range_calibration()
    println("DAC Full range cal result target_current: %.3f uA; best get: %.3f uA; code:0x%x",resDAC_RangeCal["target_current"],resDAC_RangeCal["measured_current"],resDAC_RangeCal["best_cal_trim"])
    println("-------------------------------")
    best_cal_trim = resDAC_RangeCal["best_cal_trim"]
    leak_current = resDAC_RangeCal["leakage_current"]
    
	println("=================test_pixel_current_dac_trim =========================")
    resDAC2point_nA= test_pixel_current_dac_trim(leak_current, best_cal_trim)
    println("DAC 2point Cal: pointA: %.3f nA; pointB: %.3f nA; ",resDAC2point_nA["currentPointA_nA"],resDAC2point_nA["currentPointB_nA"])
    pointA = resDAC2point_nA["currentPointA_nA"]
    pointB = resDAC2point_nA["currentPointB_nA"]
    
    table.insert(trimAndCal_table, osc_code)
    table.insert(trimAndCal_table, bandGap_code)
    table.insert(trimAndCal_table, anode_code)
    table.insert(trimAndCal_table, quarter_code)
    table.insert(trimAndCal_table, three_quarter_code)
    table.insert(trimAndCal_table, c50_code)
    table.insert(trimAndCal_table, adc_code0)
    table.insert(trimAndCal_table, adc_code1)
   	table.insert(trimAndCal_table, best_cal_trim)
    table.insert(trimAndCal_table, pointA)
    table.insert(trimAndCal_table, pointB)
    println("测试时间：%f S",(TIME.TICK() - tim1)/1000)
	return ret, trimAndCal_table
 

end

function apply_trim()
    local results_table = {}
	--println("apply_calibrated_bandgap_trim")
	local BGtrim= raw_values["BandgapTrim"] or EFuse_bits_read(0x130, 4, 0)
	LOG.INFO(string.format("BGTRIM:%d",BGtrim))
	local BGTRIM_VALUE =  0x00+(BGtrim << 4)+0x01 -- BG_TRIM bits[7:4]
	LOG.INFO(string.format("BGTRIM_VALUE:0x%X",BGTRIM_VALUE))
	i3c_write(0x00CC, BGTRIM_VALUE)
	TIME.DELAY(5)
	local READ=IIC_R_PEQUIN(0x00CC)
	--LOG.INFO(string.format("READ:0x%X",READ))
---------------------------------------------------
	local dac_ctrl_val=0
	local lo_c_mode=1
	if Color == "Red" then
		lo_c_mode=0
	end
	
	local dac_cal =  raw_values["DACCAL"] or EFuse_bits_read(0x102,4,2)
	LOG.INFO(string.format("dac_cal:0x%X",dac_cal))
	local VOLTAGE,CURRENT=POWER.VOL_CUR(P_AVEE)
	--TIME.DELAY(5)
	local RANGE_GLBL,RANGE_DAC=AVEE_RANG_Setting(VOLTAGE)
	dac_ctrl_val=dac_ctrl_val+(dac_cal << 16)
	dac_ctrl_val=dac_ctrl_val+(lo_c_mode << 8)
	dac_ctrl_val=dac_ctrl_val+(RANGE_GLBL<<4)+(RANGE_DAC << 6)
	dac_ctrl_val=dac_ctrl_val+(1 << 1)	
	dac_ctrl_val=dac_ctrl_val+(1 << 0)

	LOG.INFO(string.format("dac_ctrl_val:0x%X",dac_ctrl_val))
	IIC_W_PEQUIN(0xD8, dac_ctrl_val) --DAC_CTRL
	DAC_CTRL_value=dac_ctrl_val
	
	table.insert(results_table,BGtrim)
	table.insert(results_table,dac_cal)
	table.insert(results_table,lo_c_mode)
	
    local json_data = cjson.encode(results_table)
	LOG.INFO(json_data)
    --LOG.INFO("Power-up time: " .. string.format("%.3f", (tim2 / 1000 - tim1 / 1000)) .. " seconds")
	return 0, json_data
	
end


function apply_dac_ctrl_trim()
	local dac_ctrl=0
	local lo_c_mode=1
	if Color == "Red" then
		lo_c_mode=0
	end
	
	local DAC_EFUSE =  EFuse_bits_read(0x102,4,2)--MT复用EDID
	local VOLTAGE,CURRENT=POWER.VOL_CUR(P_AVEE)
	--TIME.DELAY(5)
	local RANGE_GLBL,RANGE_DAC=AVEE_RANG_Setting(VOLTAGE)
	dac_ctrl=dac_ctrl+(DAC_EFUSE << 16)--MT复用EDID
	dac_ctrl=dac_ctrl+(lo_c_mode << 8)--MT复用EDID
	dac_ctrl=dac_ctrl+(RANGE_GLBL<<4)+(RANGE_DAC << 6)
	dac_ctrl=dac_ctrl+(1 << 1)	
	dac_ctrl=dac_ctrl+(1 << 0)

	LOG.INFO(string.format("result:0x%X",dac_ctrl))
	IIC_W_PEQUIN(0xD8, dac_ctrl) --DAC_CTRL
	DAC_CTRL_value=dac_ctrl
end

--    Power.ValueSetting.SMU2 = 100 --nA or mV
 --   SMU2(ON,0,0x82)    --0:give volage ; 1:give current, range max up to 5
function test_bandgap_trim()
	local tim1 = TIME.TICK()
	local results = {}
	local results_table = {}
	local code_volages = {}
	PPMU.CAL_EN(1)    --5V off 

	--#1:Set VDD10 form 1.0V to 1.1V
	Power.ValueSetting.DVDD = 1100
	DVDD(ON)--VDD10
	Power.ValueSetting.SMU2 = 0
	SMU2(ON,1,0x82)
	--#2:Enable bandgap
	i3c_write(0x00CC, 0x00000000)  -- BG disable = 1	
	 --If not done already, select output on Temp Tpad: Write 0x00000060 to address 0x00F0 (TEMP_SAMP_CTRL)
	i3c_write(0x00F0, 0x00000160) -- Output TEMP_TPAD
	i3c_write(0x00EC, 0x00000002)
	local target_voltage = 1.0 -- 1V bandgap target
	local best_voltage = 0
	local best_trim = 0
	--#5:Trim loop
	for trim_code = 0, 15 do
	 -- Set bandgap trim in DAC_CTRL register (0x00D8)
	-- 调整Trim位：向地址0x00CC写入数据 0x000000X0    a. 位[7:4] = BG微调（每步约6mV）
		local dac_ctrl =  0x00000000 | (trim_code << 4) -- BG_TRIM bits[7:4]
		i3c_write(0x00CC, dac_ctrl)
		TIME.DELAY(50)
		-- Measure voltage on TEMP_TPAD
		 local measured_voltage, measured_current = POWER.VOL_CUR(P_SMU2) --SMU2: Temp_tpad  config mode?
		 println("trim_code: 0x%X,  measured_voltage:%.4f",trim_code,measured_voltage)
		 table.insert(results_table,measured_voltage)
		 if math.abs(measured_voltage - target_voltage) < math.abs(best_voltage - target_voltage) then
			best_voltage = measured_voltage
			best_trim = trim_code
			println("best_voltage:%.4f",best_voltage)
		 end
		 
	end
	
	Bandgap_code=best_trim--全局
	
	local analog_ctrl =  0x00000000 | (Bandgap_code << 4) -- BG_TRIM bits[7:4]
	i3c_write(0x00CC, analog_ctrl)

	Power.ValueSetting.DVDD = 1000
	DVDD(ON)--VDD10
	SMU2(OFF, 0)
   	PPMU.CAL_EN(0)    --5V on
	if IS_DEBUG=="TRUE" then
		best_trim = 10
	end
	table.insert(results_table,best_voltage)
	table.insert(results_table,best_trim)
	local json_data = cjson.encode(results_table)
	LOG.INFO(json_data)
	println("测试时间：%f S",(TIME.TICK() - tim1)/1000)
	return 0,json_data
end



function apply_calibrated_bandgap_trim()
	println("apply_calibrated_bandgap_trim")
	local dac_ctrl =  0x00000000 | (Bandgap_code << 4) | (0X01) -- BG_TRIM bits[7:4]--
	i3c_write(0x00CC, dac_ctrl)
	println("Apply bandgap code:0x%08X",dac_ctrl)
end

function test_temperature_sensor_adc()
    local results = {}
    --i3c_write(0x00CC, 0x00000000) -- ANLG_CTRL - BG disable = 0
    apply_calibrated_bandgap_trim_test_two(1)--初次写入
    --#3:Optional: Enable GPIO readout
    i3c_write(0x0138, 0x00000212) -- DBG_MUX_310 - temp ADC on GPIOs
    i3c_write(0x0148, 0xFFFFFFFF) -- GPIO_OE - enable all GPIOs
    --#4:Enable external input via TEMP_TPAD
    i3c_write(0x00F0, 0x00000170) -- TEMP_SAMP_CTRL - ADC source and TPAD_EN
    --#5:Reset and enable temperature sensor ADC
    i3c_write(0x00EC, 0x00000001) -- TEMP_SENS_CTRL - Reset
    i3c_write(0x00EC, 0x00000002) -- TEMP_SENS_CTRL - Enable
    
    i3c_write(0x00F0,0x00000140)--i3c_write(0x00F0,0x00000040)
    TIME.DELAY(10)
    i3c_write(0x00F0,0x00000142)--i3c_write(0x00F0,0x00000042)
    local quarter_code = i3c_read(0x0104) & 0x3FF
    LOG.INFO(string.format("IIC_read quarter_code:%x",quarter_code))
    
    --#5:Reset and enable temperature sensor ADC
    i3c_write(0x00EC, 0x00000001) -- TEMP_SENS_CTRL - Reset
    i3c_write(0x00EC, 0x00000002) -- TEMP_SENS_CTRL - Enable
    --TIME.DELAY(10)
    i3c_write(0x00F0,0x00000130)--i3c_write(0x00F0,0x00000030)
    TIME.DELAY(10)
    i3c_write(0x00F0,0x00000132)--i3c_write(0x00F0,0x00000032)
    local three_quarter_code = i3c_read(0x0104) & 0x3FF
    LOG.INFO(string.format("IIC_read three_quarter_code:%x",three_quarter_code))
    if IS_DEBUG=="TRUE" then
    	tempratue_0p25_code=233
    	tempratue_0p75_code=711
    end
 	results={tempratue_0p25_code,tempratue_0p75_code}
 	
	local json_data = cjson.encode(results)
	LOG.INFO(json_data)
    println("test_temperature_sensor_thermometer的测试时间：%f S",(TIME.TICK() - tim1)/1000)
    --datalog_results("TEMP_THERMOMETER", results)
    return 0,json_data

 end

 function Temperature_Sensor_Thermometer()
    local results_table = {}
    local Temperature_read=0.0
    local Temperature_table={}
    --i3c_write(0x00CC, 0x00000000) -- ANLG_CTRL - BG disable = 0
    --apply_calibrated_bandgap_trim()
    --#2:Enable thermometers, ADCs and manual mode
    i3c_write(0x00EC, 0x00000012) -- TEMP_SENS_CTRL - THERM_EN, ADC_EN, RESET_ADC
    --#3:Enable TEMP_TPAD output and disable auto sampling
    i3c_write(0x00F0, 0x00000010) -- TEMP_SAMP_CTRL
    
    local temp_sensors = {0,1} -- VTherm 0 and VTherm 1
    for _, sensor in ipairs(temp_sensors) do
        -- 1. do manual temp sensor sampling
        local adc_source = sensor + 1 -- VTherm 0 = 001, VTherm 1 = 010
        local samp_ctrl = 0x00000000 | (adc_source << 4)
        i3c_write(0x00F0, samp_ctrl)
        --TIME.DELAY(100)
        i3c_write(0x00F0, samp_ctrl | (1 << 1))
		LOG.INFO(string.format("samp_ctrl[%d]:0X%x",sensor,samp_ctrl))
        TIME.DELAY(10)
        -- 2. Read ADC code and measure voltage
        local adc_code = i3c_read(0x0104) & 0x3FF-- TEMP_ADC_RAW_VAL[9:0]
        --LOG.INFO(string.format("TEMP SENSOR CODE:0X%x",adc_code))
        Temperature_read=convert_adc_to_temperature(adc_code, sensor)
        --LOG.INFO(string.format("Temperature:%f",Temperature_read))
        table.insert(results_table,1000)
        table.insert(results_table,Temperature_read)
        table.insert(results_table,adc_code)

    end
    local json_data = cjson.encode(results_table)
	LOG.INFO(json_data)
	return 0, json_data
    
 end
 
 function convert_adc_to_temperature(adc_code, sensorIdx) -- sensorIdx is either 0 or 1

    local caled_temp_point = caled_temp_point--(EFuse_bits_read(0x134,12,4) & 0x0FFF)/10.0 --expect 50.0
    local codeEfuse=0
	if TEST_MODE=="MT" then
	    if sensorIdx == 0 then
	        codeEfuse = raw_values["TempSensorA"] or (EFuse_bits_read(0x154,10,4) & 0x03FF)
	    else
	        codeEfuse = raw_values["TempSensorB"] or (EFuse_bits_read(0x160,10,0) & 0x03FF)
	    end
	elseif TEST_MODE=="CP2" then 
	    if sensorIdx == 0 then
	        codeEfuse = thermal_sensor0_code
	    else
	        codeEfuse = thermal_sensor1_code
	    end
	end

    local sensor_temp = caled_temp_point + (adc_code - codeEfuse)/(-1.6)
    return sensor_temp

end
 
 function dac_full_range_calibration()
    local results = {}
   	--PPMU.CAL_EN(1)    --5V off

    --i3c_write(0x00D8, 0x0) --for init
    Power.ValueSetting.SMU1 = 0 --nA or mV
--    SMU2(0,0,0x83)
    SMU1(ON,0,0x82)    --0:give volage ; 1:give current, range max up to 5
    
    TIME.DELAY(50)--
    local refVolt, leakageCurrent = POWER.VOL_CUR(P_SMU1)
    --println("measured_voltage:%f",measured_voltage)
    println("leakageCurrent:%f",leakageCurrent)
    
    --apply_calibrated_bandgap_trim_test_two(1)--apply_calibrated_bandgap_trim_test_two已经执行
    local difference=10 --tolerance
    --#2:Setup DAC  
    local dac_ctrl = 0
    --local glbl, dac = get_avee_range_settings(voltage_AVEEE1)--GLBL=BIT[5:4]  DAC=BIT[7:6]
    local glbl=1
    local dac =0
    dac_ctrl = dac_ctrl | (5 << 16) -- DAC_CAL = 5 (recommended start)
    local LO_C_MODE = (Color == "Red") and 0 or 1
    println("LO_C_MODE:%d",LO_C_MODE)
    
    dac_ctrl = dac_ctrl | (LO_C_MODE << 8) -- LO_C_MODE = 0 for red, 1 for G/B
    dac_ctrl = dac_ctrl | (glbl << 6) | (dac << 4) -- AVEE range settings
    dac_ctrl = dac_ctrl | (1 << 1) -- UPDATE_IMM
    dac_ctrl = dac_ctrl | (1 << 0) -- EN
    dac_ctrl = dac_ctrl | (1 << 3) 
    --dac_ctrl = dac_ctrl | (1 << 2) 
    --dac_ctrl = dac_ctrl & ~ (1 << 3) 
    i3c_write(0x00D8, dac_ctrl) -- DAC_CTRL

    println("dac_ctrl:0x%08X",dac_ctrl)
    --#3:Set DAC Word to nominal drive current
    local nominal_dac_word = 0x1ff
    i3c_write(0x00DC, nominal_dac_word) -- DAC_WORD
    println("dac_word:0x%08X",nominal_dac_word)
    local target_current = (LO_C_MODE == 0) and 20 or 8     --uA
    
    local best_current = 0
    --#4:Calibration trim loop
    for cal_trim = 0, 15 do
        dac_ctrl = (dac_ctrl & ~(0xF << 16)) | (cal_trim << 16)
        i3c_write(0x00D8, dac_ctrl)
        TIME.DELAY(50) -- Wait to settle  500ms???????
        --#5:Measure current
        local measured_voltage, measured_current = POWER.VOL_CUR(P_SMU1)
        println("measured_current:%f",measured_current)
    --    println("[%d],measured_voltage: %fmV; measured_current:%.4fnA",cal_trim,measured_voltage,measured_current)
        dac_current=(-measured_current+leakageCurrent)/1000
        println("[0x%x] [%02d] DAC current out:%.4fuA",dac_ctrl,cal_trim,dac_current)
        println("dac_current - target_current:%f",math.abs(dac_current - target_current))
        if math.abs(dac_current - target_current) <= math.abs(target_current *(difference/100)) and math.abs(dac_current)>=20 then
            best_current = dac_current
            DAC_cal_trim_step = cal_trim
            DAC_calibration_code=dac_ctrl
			println("taregt: %.3f uA; best get: %.3f uA; code:0x%x",target_current,best_current,DAC_cal_trim_step)
        	break
        end
   
    end

    if IS_DEBUG=="TRUE" then
		DAC_cal_trim_step = 4
	end
	dac_ctrl = (dac_ctrl & ~(0xF << 16)) | (DAC_cal_trim_step << 16)
	i3c_write(0x00D8, dac_ctrl)			--设置目标值
    --SMU1(OFF, 0)
	table.insert(results,DAC_cal_trim_step)
	table.insert(results,best_current)
	
	local json_data = cjson.encode(results)
	LOG.INFO(json_data)
	return 0,json_data
	
end

function test_pixel_current_dac_trim(leakageCurrent,best_cal_trim)
    local results = {}
    --local calibrated_dac_cal = dac_full_range_calibration()
    -- -- 0 for Red, 1 for Blue & Green
    local lo_c_mode = (Color == "Red") and 0 or 1

    
    --Obtain voltage
--    local voltage_AVEEE1,current_AVEEE1=POWER.VOL_CUR(P_AVEE)
--    local RANGE_GLBL, RANGE_DAC=get_avee_range_settings(voltage_AVEEE1)

    local dac_ctrl = 0
    dac_ctrl = dac_ctrl + (best_cal_trim<<16)                -- Use calibrated DAC_CAL
    dac_ctrl = dac_ctrl + (lo_c_mode << 8)                        -- LO_C_MODE based on wafer color
    dac_ctrl = dac_ctrl + (0 << 4)+ (0 << 6)    -- AVEE range settings
    dac_ctrl = dac_ctrl + (1 << 1)                                -- UPDATE_IMM
    dac_ctrl = dac_ctrl + (1 << 0)                                --ENABLE DAC
    dac_ctrl = dac_ctrl + (1 << 3)
    i3c_write(0x00D8, dac_ctrl)
    println("dac_ctrl:0x%08X",dac_ctrl)

    println(leakageCurrent)
    println(best_cal_trim)
    
    local CodeA = 43
    i3c_write(0x00DC, CodeA)
    TIME.DELAY(300)
    local voltage_pointA,measA = POWER.VOL_CUR(P_SMU2)  -- Measure the ANOD_TPAD current
    local current_pointA = leakageCurrent-measA
    println("CodeA[%d] measA:%.4fnA   pointA:%.4fnA",CodeA,measA, current_pointA)
    results["currentPointA_nA"] = current_pointA
    
    local CodeB = 341
    i3c_write(0x00DC, CodeB)
    TIME.DELAY(300)
    local voltage_pointB,measB = POWER.VOL_CUR(P_SMU2)-- Measure the ANOD_TPAD current
    local current_pointB = leakageCurrent-measB
    println("CodeB[%d] measB:%.4fnA  pointB: %.4fnA",CodeB,measB,current_pointB)
	local pointA_Code = math.floor(current_pointA/5)
	local pointB_Code = math.floor(current_pointB/5)
	println("pointA_Code:%d ",pointA_Code)
	println("pointB_Code:%d ",pointB_Code)
	
	PiontA_efuse_write(pointA_Code)
	PiontB_efuse_write(pointB_Code)
	
    results["currentPointB_nA"] = current_pointB

    return results
end



function  F_28M2_MIPI_CReg_Write(target_current)--uA
    local results = {}
	local target_current_nA  = tonumber(target_current)*1000
    --local calibrated_dac_cal = dac_full_range_calibration()
    -- -- 0 for Red, 1 for Blue & Green
    local efuse_dac_cal_code =  EFuse_bits_read(0x102,4,2)
	--local efuse_dac_lo_power_mode_code =  EFuse_bits_read()
    best_cal_trim = efuse_dac_cal_code
    println("best_cal_trim:0x%08X",best_cal_trim)
    local lo_c_mode = (Color == "Red") and 0 or 1

	local glbl=0
	local dac =0
    local dac_ctrl = 0
    dac_ctrl = dac_ctrl + (best_cal_trim<<16)                -- Use calibrated DAC_CAL
    dac_ctrl = dac_ctrl + (lo_c_mode << 8)                        -- LO_C_MODE based on wafer color
    dac_ctrl = dac_ctrl + (0 << 4)+ (0 << 6)    -- AVEE range settings
    dac_ctrl = dac_ctrl + (1 << 1)                                -- UPDATE_IMM
    dac_ctrl = dac_ctrl + (1 << 0)                                --ENABLE DAC
    dac_ctrl = dac_ctrl + (1 << 3)
    i3c_write(0x00D8, dac_ctrl)
    println("dac_ctrl:0x%08X",dac_ctrl)
    
    --Power.ValueSetting.SMU2 = -001 --nA or mV
    --SMU2(ON,0,0x82)
    --TIME.DELAY(600)
    
	local dacword_pointA =  EFuse_bits_read(0x110,12,0)
	local dacword_pointB =  EFuse_bits_read(0x11C,12,4)
	println("dacword_pointA: 0x%X",dacword_pointA)
	println("dacword_pointB: 0x%X",dacword_pointB)
	
	local PointA_current = dacword_pointA * 5
	local PointB_current = dacword_pointB * 5
	println("PointA_current: %d",PointA_current)
	println("PointB_current: %d",PointB_current)
	local DAC_Word_B=341
	local DAC_Word_A=43
	local Gain =  math.ceil((PointB_current - PointA_current) / (DAC_Word_B - DAC_Word_A))
	println("Gain:%d",Gain)
	local Offset = PointA_current - Gain * DAC_Word_A
	println("Offset:%d",Offset)
	local DAC_Code = math.floor((target_current_nA - Offset) / Gain)
	println("DAC_Code:%d",DAC_Code)
	
	if DAC_Code > 511 then
		DAC_Code = 511
	end
	i3c_write(0x00DC, DAC_Code)
	TIME.DELAY(100)
	IIC_W_PEQUIN(0x0, 0x109000) --CLK_CTRL
	TIME.DELAY(100)
    results = {DAC_Code}

    return 1, results
end

function BandGap_trim_efuse_write(value)
	local val = value
	local addressLSB = 0x130
	local bitwidth = 4
	local bitStart = 0
	efuse_write(val, addressLSB, bitwidth, bitStart)
	return 0
end


function Temperature_sensor_adc_quarte_efuse_write(value)
	local val = value
	local addressLSB = 0x140
	local bitwidth = 10
	local bitStart = 0
	efuse_write(val, addressLSB, bitwidth, bitStart)
	return 0
end
function Temperature_sensor_adc_three_quarte_efuse_write(value)
	local val = value
	local addressLSB = 0x14A
	local bitwidth = 10
	local bitStart = 2
	efuse_write(val, addressLSB, bitwidth, bitStart)
	return 0
end
function Temperature_sensor_adc_50C_efuse_write(value)
	local val = value
	local addressLSB = 0x134
	local bitwidth = 12
	local bitStart = 4
	efuse_write(val, addressLSB, bitwidth, bitStart)
	return 0
end

function vtherm0_adc_efuse_write(value)
	local val = value
	local addressLSB = 0x154
	local bitwidth = 10
	local bitStart = 4
	efuse_write(val, addressLSB, bitwidth, bitStart)
	return 0
end
function vtherm1_adc_efuse_write(value)
	local val = value
	local addressLSB = 0x160
	local bitwidth = 10
	local bitStart = 0
	efuse_write(val, addressLSB, bitwidth, bitStart)
	return 0
end
function DAC_full_cal_efuse_write(value)
	local val = value
	local addressLSB = 0x102
	local bitwidth = 4
	local bitStart = 2
	efuse_write(val, addressLSB, bitwidth, bitStart)
	return 0
end
function PiontA_efuse_write(value)
	local val = value
	local addressLSB = 0x110
	local bitwidth = 12
	local bitStart = 0
	efuse_write(val, addressLSB, bitwidth, bitStart)
	return 0
end
function PiontB_efuse_write(value)
	local val = value
	local addressLSB = 0x11C
	local bitwidth = 12
	local bitStart = 4
	efuse_write(val, addressLSB, bitwidth, bitStart)
	return 0
end

function F_28M2_eFuse_PostTest()

	local ret = 1
	local post_value = "Pass"
	local post_table = {}
	
	local val = 0x8
	local addressLSB = 0xBC
	local bitwidth = 4
	local bitStart = 4
	efuse_write(val, addressLSB, bitwidth, bitStart)
	
	post_data = EFuse_bits_read(addressLSB, bitwidth, bitStart)
	if post_data ~= 0x8 then
		post_value = "Fail"
		ret = 0
	end
	post_table = {post_data}
		
	return ret, post_table

end





--Temperature_Read(1)
function Temperature_Read(sensor_id)

	i3c_write(0x00CC, 0x00000000)  -- ANLG_CTRL - BG disable = 0
	i3c_write(0x00EC, 0x00000012)  -- DBG_MUX_310 - temp ADC on GPIOs
    -- Enable external input via TEMP_TPAD
    i3c_write(0x00F0, 0x00000110)  -- - TEMP_SAMP_CTRL - ADC source and TPAD_EN

    -- Test all temperature sensors
    local adc_source = sensor_id + 1  -- 0→1（001），1→2（010）
    -- Set ADC source to output VTherm on TEMP_TPAD & ADCs
    local samp_ctrl = 0x00000110 | (adc_source << 4) 
    i3c_write(0x00F0, samp_ctrl)
    TIME.DELAY(1) 

    -- Start manual sample
    local temp_reg = i3c_read(0x00F0, 1)
    i3c_write(0x00F0, temp_reg | (1 << 1))
    TIME.DELAY(100)

    -- Read ADC code and measure voltage
    local adc_code = i3c_read(0x0104, 1) & 0x3FF  -- TEMP_ADC_RAW_VAL[9:0]
    --local voltage = POWER.VOL_CUR(1)  -- 

    local temperature = convert_adc_to_temperature(adc_code)
    return temperature
end


function LB_DIB_Impedance_calibration()
	local result_table={}
	local SMU1DATA_V = 0.0
	local SMU1DATA_C = 0.0
	
	local SMU2DATA_V = 0.0
	local SMU2DATA_C = 0.0
	GPIO3_A_SET(0)
	SMU1_OUT_V(-200)
	TIME.DELAY(350)
	SMU2_OUT_V(-200)
	TIME.DELAY(350)
	SMU1DATA_V,SMU1DATA_C=POWER.VOL_CUR(P_SMU1)
	SMU2DATA_V,SMU2DATA_C=POWER.VOL_CUR(P_SMU2)
	LOG.INFO(string.format("1V:%f",SMU1DATA_V))
	LOG.INFO(string.format("1C:%f",SMU1DATA_C))
	local SMU1_ohm = SMU1DATA_V/(SMU1DATA_C/1e9)
	local SMU2_ohm = SMU2DATA_V/(SMU2DATA_C/1e9)
	GPIO3_A_SET(0)
	SMU1_OUT_V(0)
	SMU2_OUT_V(0)
	table.insert(result_table,SMU1_ohm)
	table.insert(result_table,SMU2_ohm)
	return result_table
end
--Mipi_Term90_270_Test(90,0)
function Mipi_Term90_270_Test(ohm, channel)
	local tim1 = TIME.TICK()
	local result_table={}
	--Post_Initial_ON()
	PIC.SW(Folder..'/'..imShow[2])
	TIME.DELAY(10)
	local clk90 = raw_values["clk_term90"] or 0
	local clk270 = raw_values["clk_term270"] or 0
	local data90 = raw_values["data_term90"] or 0
	local data270 = raw_values["data_term270"] or 0
	

	if clk90 == 0 or clk270 == 0 or data90 == 0 or data270 == 0 then
	    Efuse_clk90_value = EFuse_bits_read(0x190,3,0)
	    Efuse_clk270_value = EFuse_bits_read(0x193,3,3)
	    Efuse_data90_value = EFuse_bits_read(0x196,3,6)
	    Efuse_data270_value = EFuse_bits_read(0x199,3,1)
	else
	    Efuse_clk90_value = clk90
	    Efuse_clk270_value = clk270
	    Efuse_data90_value = data90
	    Efuse_data270_value = data270
	end
	
	if Efuse_clk90_value==0 or Efuse_clk270_value==0 or Efuse_data90_value==0 or Efuse_data270_value==0  then
		--TIME.DELAY(200)
		--POWER_ON_IDLE_POWER()
		DMIPI.LP()
		TIME.DELAY(10)
		local ret=0
		local ret1=0
		
		local read_data = 0
		local LB_DB = LB_DIB_Impedance_calibration()
		local lb_db = 0.0
		local test_channel = 0
		local term_clk = 0	
		local term_data = 0
		local difference_value=10----Resistance deviation range unit: %
		
		--LOG.INFO(#LB_DB)
		local SMU1_lb_db = LB_DB[1]
		local SMU2_lb_db = LB_DB[2]
		LOG.INFO(string.format("1ohm:%f",SMU1_lb_db))
		LOG.INFO(string.format("2ohm:%f",SMU2_lb_db))
		--Force 5V at both SMU
		local read_data = i3c_read(0x000c)
		TIME.DELAY(1)
		i3c_write(0x000c,read_data|0x40400)---Write 1 to the 10th bit and 18th bit of the 0xc register
	
		GPIO3_A_SET(1)--暂时使用恒压
		SMU1_OUT_V(-200)
		SMU2_OUT_V(-200)
		
		--SMU1_OUT_C(200*1000)
		--SMU2_OUT_C(200*1000)
		TIME.DELAY(50)
		if ohm == 90 then
			read_data = i3c_read(0x000c)
			TIME.DELAY(10)
			i3c_write(0x000c,read_data|0x180)---clk 90ohm set
			TIME.DELAY(10)
			ret,term_clk = resistance_value_code_clk90(ohm,0,SMU1_lb_db,difference_value)
			
			read_data = i3c_read(0x000c)
			TIME.DELAY(10)
			i3c_write(0x000c,read_data|0x18000)---data 90ohm set
			ret1,term_data = resistance_value_code_data90(ohm,1,SMU2_lb_db,difference_value)
		elseif ohm == 270 then
			read_data = i3c_read(0x000c)
			read_data= read_data & ~(0x3 << 7)
			read_data= read_data & ~(0x3 << 15)
			i3c_write(0x000c,read_data)
			ret,term_clk = resistance_value_code_clk270(ohm,0,SMU1_lb_db,difference_value)---clk 270ohm set
			--LOG.INFO(string.format("term_clk:0x%X",term_clk))
			read_data = i3c_read(0x000c)
			read_data= read_data & ~(0x3 << 7)
			read_data= read_data & ~(0x3 << 15)
			i3c_write(0x000c,read_data)
			ret1,term_data = resistance_value_code_data270(ohm,1,SMU2_lb_db,difference_value)---data 270ohm set
		end
		LOG.INFO(#term_clk)
		LOG.INFO(#term_data)
		--Read the code that tests the measured impedance closest to 90 ohms
		--local term = resistance_value_code(ohm,test_channel,lb_db)
		if ret~=0 then
			LOG.ERROR("No suitable clk_trem_code found")
			
		else
			LOG.INFO(string.format("%fohm,clk_trem_code:0x%X",ohm,term_clk[1]))
		end
		
		if ret1~=0 then
			LOG.ERROR("No suitable data_trem_code found")
			
		else
			LOG.INFO(string.format("%fohm,data_trem_code:0x%X",ohm,term_data[1]))
		end
		SMU1_OUT_V(0)
		SMU2_OUT_V(0)
		GPIO3_A_SET(0)
		if ohm==90 and ret==0 and ret1==0 then --测试完后写入值，90
			 local original = IIC_R_PEQUIN(0x000c)
			 LOG.INFO(string.format("0x%X",original))
			 original= original & ~(0x1F << 12)
			 original= original & ~(0x1F << 4)
			 original= original & ~(0x01 << 10)
			 original= original & ~(0x01 << 18)
			 original= original | (0x3<< 7)
			 original= original | (0x3<< 15)
			 LOG.INFO(string.format("result:0x%X",original))
			 original= original | ((term_clk[1]&0x7)<< 4)
			 original= original | ((term_data[1]&0x7)<< 12)
			 mipi_term_90=original
			 MIPI_TERM=original
			 LOG.INFO(string.format("mipi_term_90:0x%X",original))
			 --VIDEO Using
			 IIC_W_PEQUIN(0x000c,mipi_term_90)
		 	 Efuse_90_clk=term_clk[1]&0x7
		 	 Efuse_90_data=term_data[1]&0x7
		elseif ohm==270 and ret==0 and ret1==0 then
			local original = IIC_R_PEQUIN(0x000c)
			LOG.INFO(string.format("0x%X",original))
			original= original & ~(0x1F << 12)
			original= original & ~(0x1F << 4)
			original= original & ~(0x01 << 10)
			original= original & ~(0x01 << 18)
			original= original & ~(0x3 <<7)
			original= original & ~(0x3 <<15)
			LOG.INFO(string.format("result:0x%X",original))
			original= original | ((term_clk[1]&0x7)<< 4)
			original= original | ((term_data[1]&0x7)<< 12)
			mipi_term_270=original
			MIPI_TERM=original
			--IIC_W_PEQUIN(0x000c,mipi_term_270)--默认写入90，暂时屏蔽
			LOG.INFO(string.format("mipi_term_270:0x%X",original))
			Efuse_270_clk=term_clk[1]&0x7
			Efuse_270_data=term_data[1]&0x7

		end
		
		DMIPI.VID()
		DMIPI.HS()
		if ret~=0 or ret1~=0 then
			IIC_W_PEQUIN(0x000c,0X1)
		end
	
		table.move(term_clk,1,#term_clk,#result_table+1,result_table)
		table.move(term_data,1,#term_data,#result_table+1,result_table)
		--table.insert(result_table,Clk_term270)
		LOG.INFO(#result_table)
	
	else--如果已经校准直接写入
		if ohm==90 then
			 local original = IIC_R_PEQUIN(0x000c)
			 LOG.INFO(string.format("0x%X",original))
			 original= original & ~(0x1F << 12)
			 original= original & ~(0x1F << 4)
			 original= original & ~(0x01 << 10)
			 original= original & ~(0x01 << 18)
			 original= original | (0x3<< 7)
			 original= original | (0x3<< 15)
			 LOG.INFO(string.format("result:0x%X",original))
			 original= original | ((Efuse_clk90_value&0x7)<< 4)
			 original= original | ((Efuse_data90_value&0x7)<< 12)
			 mipi_term_90=original
			 MIPI_TERM=original
			 IIC_W_PEQUIN(0x000c,mipi_term_90)
			 LOG.INFO(string.format("mipi_term_90:0x%X",original))
			 
			 table.insert(result_table,Efuse_clk90_value)
			 for i=1,24 do
			 	table.insert(result_table,0)
			 end
	    	table.insert(result_table,Efuse_data90_value)
	    	 for i=1,24 do
			 	table.insert(result_table,0)
			 end
		
		elseif ohm==270 then
			 local original = IIC_R_PEQUIN(0x000c)
			 LOG.INFO(string.format("0x%X",original))
			 original= original & ~(0x1F << 12)
			 original= original & ~(0x1F << 4)
			 original= original & ~(0x01 << 10)
			 original= original & ~(0x01 << 18)
			 original= original & ~(0x3 <<7)
			 original= original & ~(0x3 <<15)
			 LOG.INFO(string.format("result:0x%X",original))
			 original= original | ((Efuse_clk270_value&0x7)<< 4)
			 original= original | ((Efuse_data270_value&0x7)<< 12)
			 mipi_term_270=original
			 MIPI_TERM=original
			 --IIC_W_PEQUIN(0x000c,mipi_term_270)--默认写入90，暂时屏蔽
			 LOG.INFO(string.format("mipi_term_270:0x%X",original))
			 
			table.insert(result_table,Efuse_clk270_value)
			 for i=1,24 do
			 	table.insert(result_table,0)
			 end
	    	table.insert(result_table,Efuse_data270_value)
	    	 for i=1,24 do
			 	table.insert(result_table,0)
			 end
		end

	end
	local json_data = cjson.encode(result_table)
	local tim2 = TIME.TICK()
    LOG.INFO("Power-up time: " .. string.format("%.3f", (tim2 / 1000 - tim1 / 1000)) .. " seconds")
	LOG.INFO(#json_data)
	LOG.INFO(json_data)
	return 0, json_data
end


function resistance_value_code_clk90(Target_value,power_channel,lb_db,difference_value)
	local Clk_DATA={
		SMU_V=0.0;
		SMU_C=0.0;	
	}
	local ret = 0
	local DATA_TABLE = {}
	local results_table={}
	local bit_mask = 0x70        -- 目标位掩码（bit4~bit6=111，用于清空位域）
	local bit_shift = 4          -- 目标位起始偏移（bit4，左移 4 位对齐）
	local cycle_states = 8       -- 循环状态总数（3 位 bit 共 8 种）
	local read_data = 0 
	local term_code_table={}
	local test_ohm_table={}
	--efuse_write(val, 0x000c, bitwidth, bitStart)
	--for term_code=0,7,1 do
		--Start testing by gradually writing to the 0x000 register starting from 0x00
		local original = i3c_read(0x000c)
			  original= original & ~(0x1F << 12)
		for cycle_idx = 0, cycle_states - 1 do

    		local cleared = original & (~bit_mask)         
    		local term_code = cleared | (cycle_idx << bit_shift)  

    		LOG.INFO(string.format("loop %d ：0x%X",cycle_idx, term_code))
			--end
			--read_data = i3c_read(0x000c)
			i3c_write(0x000c,term_code)
			TIME.DELAY(10)
			local readdd_data = i3c_read(0x000c)
			LOG.INFO(string.format("read_data[%d]:0x%X",cycle_idx,readdd_data))
			TIME.DELAY(300)
			--Obtain the actual voltage and current of the SMU channel
			Clk_DATA.SMU_V,Clk_DATA.SMU_C=POWER.VOL_CUR(power_channel)--The units are V, nA
			
			--Calculate the resistance value
			local resistance_value = Clk_DATA.SMU_V/(Clk_DATA.SMU_C/1e9)
			 resistance_value = resistance_value-lb_db
			 table.insert(DATA_TABLE,Clk_DATA.SMU_V)
			 
			 table.insert(DATA_TABLE,Clk_DATA.SMU_C/1e9)
			 table.insert(DATA_TABLE,resistance_value)
			--Check if the calculated resistance value is within the range
			local Impedance_result = check_best_resistance_value(Target_value,resistance_value,difference_value)
			if Impedance_result then
				table.insert(term_code_table,cycle_idx)
				table.insert(test_ohm_table,resistance_value)
				LOG.INFO(string.format("The closest impedance:0x%02x",term_code))
			end
			if #term_code_table == 0 and cycle_idx == 7 then
				ret=1
				
			end
		end
		local Serial_number = closest(test_ohm_table,Target_value)
		LOG.INFO(Serial_number)
		if Serial_number == nil then
			local result11 = 999
			table.insert(results_table,result11)
		else
		table.insert(results_table,term_code_table[Serial_number])
		end
		
		table.move(DATA_TABLE,1,#DATA_TABLE,#results_table+1,results_table)
	return ret,results_table


end


function resistance_value_code_clk270(Target_value,power_channel,lb_db,difference_value)
	local Clk_DATA={
		SMU_V=0.0;
		SMU_C=0.0;	
	}
	local ret = 0
	local DATA_TABLE = {}
	local results_table={}
	local bit_mask = 0x70        -- 目标位掩码（bit4~bit6=111，用于清空位域）
	local bit_shift = 4          -- 目标位起始偏移（bit4，左移 4 位对齐）
	local cycle_states = 8       -- 循环状态总数（3 位 bit 共 8 种）
	local read_data = 0 
	local term_code_table={}
	local test_ohm_table={}
	--efuse_write(val, 0x000c, bitwidth, bitStart)
	--for term_code=0,7,1 do
		--Start testing by gradually writing to the 0x000 register starting from 0x00
		local original = i3c_read(0x000c)
			  original= original & ~(0x1F << 12)
		for cycle_idx = 0, cycle_states - 1 do

    		local cleared = original & (~bit_mask)         
    		local term_code = cleared | (cycle_idx << bit_shift)  

    		LOG.INFO(string.format("loop %d ：0x%X",cycle_idx, term_code))
			--end
			--read_data = i3c_read(0x000c)
			i3c_write(0x000c,term_code)
			TIME.DELAY(10)
			local readdd_data = i3c_read(0x000c)
			LOG.INFO(string.format("read_data[%d]:0x%X",cycle_idx,readdd_data))
			TIME.DELAY(300)
			--Obtain the actual voltage and current of the SMU channel
			Clk_DATA.SMU_V,Clk_DATA.SMU_C=POWER.VOL_CUR(power_channel)--The units are V, nA
			
			--Calculate the resistance value
			local resistance_value = Clk_DATA.SMU_V/(Clk_DATA.SMU_C/1e9)
			 resistance_value = resistance_value-lb_db
			 table.insert(DATA_TABLE,Clk_DATA.SMU_V)
			 
			 table.insert(DATA_TABLE,Clk_DATA.SMU_C/1e9)
			 table.insert(DATA_TABLE,resistance_value)
			--Check if the calculated resistance value is within the range
			local Impedance_result = check_best_resistance_value(Target_value,resistance_value,difference_value)
			if Impedance_result then
				table.insert(term_code_table,cycle_idx)
				table.insert(test_ohm_table,resistance_value)
				LOG.INFO(string.format("The closest impedance:0x%02x",term_code))
			end
			if #term_code_table == 0 and cycle_idx == 7 then
				ret=1
				
			end
		
		end
		LOG.INFO(#term_code_table)
		--local Serial_number = closest(test_ohm_table,Target_value)
		local Serial_number = closest(test_ohm_table,Target_value)
		LOG.INFO(Serial_number)
		if Serial_number == nil then
			local result11 = 999
			table.insert(results_table,result11)
		else
		table.insert(results_table,term_code_table[Serial_number])
		end
		
		table.move(DATA_TABLE,1,#DATA_TABLE,#results_table+1,results_table)
		LOG.INFO(ret)
	return ret,results_table


end

function resistance_value_code_data90(Target_value,power_channel,lb_db,difference_value)
	local Clk_DATA={
		SMU_V=0.0;
		SMU_C=0.0;	
	}
	local ret = 0
	local DATA_TABLE = {}
	local results_table={}
	local bit_mask = 0x7000        -- 目标位掩码（bit4~bit6=111，用于清空位域）
	local bit_shift = 12          -- 目标位起始偏移（bit4，左移 4 位对齐）
	local cycle_states = 8       -- 循环状态总数（3 位 bit 共 8 种）
	local read_data = 0 
	local term_code_table={}
	local test_ohm_table={}

	--efuse_write(val, 0x000c, bitwidth, bitStart)
	--for term_code=0,7,1 do
		--Start testing by gradually writing to the 0x000 register starting from 0x00
		--local original = i3c_read(0x000c)
		local original = i3c_read(0x000c)
			original= original & ~(0x1F << 4)
		for cycle_idx = 0, cycle_states - 1 do

    		local cleared = original & (~bit_mask)         
    		local term_code = cleared | (cycle_idx << bit_shift)  

    		LOG.INFO(string.format("loop %d ：0x%X",cycle_idx, term_code))
			--end
			--read_data = i3c_read(0x000c)
			i3c_write(0x000c,term_code)
			TIME.DELAY(10)
			local readdd_data = i3c_read(0x000c)
			LOG.INFO(string.format("read_data[%d]:0x%X",cycle_idx,readdd_data))
			TIME.DELAY(300)
			--Obtain the actual voltage and current of the SMU channel
			Clk_DATA.SMU_V,Clk_DATA.SMU_C=POWER.VOL_CUR(power_channel)--The units are V, nA
			
			--Calculate the resistance value
			local resistance_value = Clk_DATA.SMU_V/(Clk_DATA.SMU_C/1e9)
			 resistance_value = resistance_value-lb_db
			 
			 table.insert(DATA_TABLE,Clk_DATA.SMU_V)
			 
			 table.insert(DATA_TABLE,Clk_DATA.SMU_C/1e9)
			 table.insert(DATA_TABLE,resistance_value)
			 
			 
			--Check if the calculated resistance value is within the range
			local Impedance_result = check_best_resistance_value(Target_value,resistance_value,difference_value)
			if Impedance_result then
				table.insert(term_code_table,cycle_idx)
				table.insert(test_ohm_table,resistance_value)
				LOG.INFO(string.format("The closest impedance:0x%02x",term_code))
			end
			if #term_code_table == 0 and cycle_idx == 7 then
				ret=1
				
			end
		end
		--test_ohm_table = {92}
		--term_code_table = {4}
		local Serial_number = closest(test_ohm_table,Target_value)
		
		if Serial_number == nil then
			local result11 = 999
			table.insert(results_table,result11)
		else
		table.insert(results_table,term_code_table[Serial_number])
		end
		
		table.move(DATA_TABLE,1,#DATA_TABLE,#results_table+1,results_table)

	return ret,results_table


end

function resistance_value_code_data270(Target_value,power_channel,lb_db,difference_value)
	local Clk_DATA={
		SMU_V=0.0;
		SMU_C=0.0;	
	}
	local ret = 0
	local DATA_TABLE = {}
	local results_table={}
	local bit_mask = 0x7000        -- 目标位掩码（bit4~bit6=111，用于清空位域）
	local bit_shift = 12          -- 目标位起始偏移（bit4，左移 4 位对齐）
	local cycle_states = 8       -- 循环状态总数（3 位 bit 共 8 种）
	local read_data = 0 
	local term_code_table={}
	local test_ohm_table={}
	--efuse_write(val, 0x000c, bitwidth, bitStart)
	--for term_code=0,7,1 do
		--Start testing by gradually writing to the 0x000 register starting from 0x00
		local original = i3c_read(0x000c)
		original= original & ~(0x1F << 4)
		for cycle_idx = 0, cycle_states - 1 do

    		local cleared = original & (~bit_mask)         
    		local term_code = cleared | (cycle_idx << bit_shift)  

    		LOG.INFO(string.format("loop %d ：0x%X",cycle_idx , term_code))
			--end
			--read_data = i3c_read(0x000c)
			i3c_write(0x000c,term_code)
			TIME.DELAY(10)
			local readdd_data = i3c_read(0x000c)
			LOG.INFO(string.format("read_data[%d]:0x%X",cycle_idx,readdd_data))
			TIME.DELAY(300)
			--Obtain the actual voltage and current of the SMU channel
			Clk_DATA.SMU_V,Clk_DATA.SMU_C=POWER.VOL_CUR(power_channel)--The units are V, nA
			
			--Calculate the resistance value
			local resistance_value = Clk_DATA.SMU_V/(Clk_DATA.SMU_C/1e9)
			 resistance_value = resistance_value-lb_db
			 table.insert(DATA_TABLE,Clk_DATA.SMU_V)
			 
			 table.insert(DATA_TABLE,Clk_DATA.SMU_C/1e9)
			 table.insert(DATA_TABLE,resistance_value)
			--Check if the calculated resistance value is within the range
			local Impedance_result = check_best_resistance_value(Target_value,resistance_value,difference_value)
			if Impedance_result then
				table.insert(term_code_table,cycle_idx)
				table.insert(test_ohm_table,resistance_value)
				LOG.INFO(string.format("The closest impedance:0x%02x",term_code))
			end
			if #term_code_table == 0 and cycle_idx == 7 then
				ret=1
				
			end
		end
		--local Serial_number = closest(test_ohm_table,Target_value)
		local Serial_number = closest(test_ohm_table,Target_value)
		
		if Serial_number == nil then
			local result11 = 999
			table.insert(results_table,result11)
		else
		table.insert(results_table,term_code_table[Serial_number])
		end
		
		table.move(DATA_TABLE,1,#DATA_TABLE,#results_table+1,results_table)
		
	return ret,results_table


end

function closest(test_ohm_table,ohm)
    local args = test_ohm_table  -- 接收可变参数，转为列表
    if #args == 1 then
    	return 1
    else
	    if #args == 0 then 
	    return nil 
	    end  -- 空输入返回 nil
	
	    local closestVal = args[1]  -- 初始化：第一个值为候选
	    local Serial_number = 1
	    local minDiff = math.abs(closestVal - ohm)  -- 初始化最小差值
	
	    -- 遍历所有值，更新最小差值和对应的值
	    for i = 2, #args do
	        local currentVal = args[i]
	        local currentDiff = math.abs(currentVal - ohm)
	        if currentDiff < minDiff then  -- 找到更接近的，更新
	            minDiff = currentDiff
	            closestVal = currentVal
	            Serial_number = i
	        end
	    end
	    return Serial_number
	end
    
end
function check_best_resistance_value(Target_value,actual_value,percentage_difference)
	--Calculate the difference in the resistance range
	local difference_value = Target_value * (percentage_difference/100)
	--Minimum range value of resistance
	local minvalue = Target_value - difference_value
	--Maximum range value of resistance
	local maxvalue = Target_value + difference_value
	LOG.INFO(string.format("Target_value:%.2f,actual_value:%.2f,Range[%.2f-%.2f]",Target_value,actual_value,minvalue,maxvalue))
	--If the actual resistance value is within the range, return it; otherwise, return nil.
	return (actual_value>=minvalue) and (actual_value<=maxvalue)

end

function DAC_WordpointA_B_Measurement()
	POWER_ON_0x2D0()
	local result_table = {}
	local difference_value_34 = 0
	local difference_value_341 = 0
	local PointA =  EFuse_bits_read(0x110,12,0)
	local PointB =  EFuse_bits_read(0x11C,12,4)
	LOG.INFO(string.format("PointA:%d",PointA))
	LOG.INFO(string.format("Pointb:%d",PointB))
	PointA=PointA*5
	PointB=PointB*5
	LOG.INFO(string.format("PointA:0x%X",PointA))
	LOG.INFO(string.format("Pointb:0x%X",PointB))
	table.insert(result_table,PointA)
	table.insert(result_table,PointB)
	
	local json_data = cjson.encode(result_table)
	LOG.INFO(json_data)
	return 0,json_data
end

function AVEE_Trim_Test()
	local result_table = {}
	local cur_change = 0
	local cur_ratio = 0.0
	local default_avee_mv = Power.ValueSetting.AVEE1
	--LOG.INFO(string.format("V:%fmV",default_avee_mv))
	local start_mV = default_avee_mv-500
	local end_mV = default_avee_mv+500
	local step_mV = 100
	local last_cur = 0
	local saturation_vol_mv = 0
	local margin_vol_mv = 0
	local threshold = 30----Resistance deviation range unit: %
	local threshold1 = -threshold
	local test_DATA = {}
	--LOG.INFO(threshold)
	--LOG.INFO(threshold1)
	POWER_ON_0x2D0()
	
	for Set_voltage = start_mV,end_mV,step_mV do
		--AVEE provides the corresponding voltage
		AVEE1_OUT_V(Set_voltage)
		TIME.DELAY(50)
		--Read the voltage and current of AVEE
		local Measure_vol,Measure_cur = POWER.VOL_CUR(6)
		Measure_vol = Measure_vol * 1000--mV
		Measure_cur = Measure_cur / 1e6--uA
		--LOG.INFO(string.format("V:%fmV,C:%fuA",Measure_vol,Measure_cur))
		
		--Store the voltage and current values of AVEE under different voltages
		table.insert(test_DATA,Measure_vol)
		table.insert(test_DATA,Measure_cur)
		if last_cur ~= 0 then
		--Subtract the current measured current from the previous measured current, and then divide the resulting value by the previous measured current to calculate the current change rate.
			cur_change = Measure_cur - last_cur
			cur_ratio = (cur_change /last_cur)*100
			--LOG.INFO(string.format("current change ratio:%f%%",cur_ratio))
			LOG.INFO(string.format("cur_ratio:%f",cur_ratio))
			--tore the saturation voltage value when the current change rate is less than five percent and the saturation voltage value is obtained for the first time.
			if cur_ratio <= threshold and cur_ratio >= threshold1 and saturation_vol_mv == 0 then
				saturation_vol_mv = Set_voltage
				LOG.INFO(string.format("THE BEST F_AVEE_Trim: Saturation detected at %f mV (current change ratio: %.2f%%)", 
                    saturation_vol_mv, cur_ratio))
			end
		end
		
		LOG.INFO(string.format("set vol:%.2fmV,Measure voltage:%.2fV,Measure current:%fmA",Set_voltage,Measure_vol,Measure_cur))
		
		--LOG.INFO(string.format("last_cur：%f",last_cur))
		last_cur = Measure_cur
	end

	if saturation_vol_mv == 0 then
		saturation_vol_mv = end_mV
		local saturation_result = "Fail"
		table.insert(result_table,saturation_result)
		LOG.ERROR(string.format("F_AVEE_Trim: No saturation detected. Using end voltage %d mV as fallback.", 
            saturation_vol_mv))
    else
    	

		--Use the formula (AVEE - margin)/10 to calculate the value written to efuse
		local target_avee_mv = math.abs(saturation_vol_mv) -margin_vol_mv
		local efuse_value = math.floor(math.abs(target_avee_mv/10))
		LOG.INFO(string.format("WRITE_efuse_value:0x%02X",efuse_value))
		table.insert(result_table,efuse_value)
	end
	LOG.INFO(#test_DATA)
	table.move(test_DATA,1,#test_DATA,#result_table+1,result_table)
	i3c_write(0x7c,0x30000a5)

	local json_data = cjson.encode(result_table)
	--LOG.INFO(#json_data)
	LOG.INFO(json_data)
	LOG.INFO(#result_table)
	return 0, json_data
end


function AVEE_SWEEP(DutyCyele)
	Sw_by_name("W.bmp")
	Set_DutState(ON)
	local result_table = {}
	local cur_change = 0
	local cur_ratio = 0.0
	--根据RGB设置1000-3000mV Red 2000-4000mV G B
	local start_mV = -1000
	local end_mV = -3000
	local step_mV = -100
	local test_DATA = {}
	--local EFUSE_WRITE = 1----1=Enable efuse writing   0=Disable efuse writing
	local efuse_value=0
	
	if 	Color ~= "Red" then
		start_mV = -2000
		end_mV = -4000
	end

	IIC_W_PEQUIN(0x7C, 0x30002D0) --TMG_RSYNC_CFG
	for Set_voltage = start_mV,end_mV,step_mV do
		--AVEE provides the corresponding voltage

		AVEE1_OUT_V(Set_voltage)

		--Sw_by_name("W0.bmp")
		Set_Brightness(0)
		local falg=0
		if falg==0 then
			TIME.DELAY(100)
		else
			TIME.DELAY(50)
		end
		--Read the voltage and current of AVEE
		local Dark_Measure_vol,Dark_Measure_cur = POWER.VOL_CUR(6)--DARK
		Dark_Measure_vol = Dark_Measure_vol * 1000--mV
		Dark_Measure_cur = Dark_Measure_cur / 1e3--uA
		table.insert(test_DATA,Dark_Measure_vol)
		table.insert(test_DATA,Dark_Measure_cur / 1e3)--mA
		--LOG.DEBUG(string.format("VOL->%f,CUR->%f",Dark_Measure_vol,Dark_Measure_cur))
		Set_Brightness(DutyCyele)
		TIME.DELAY(50)
		local Active_Measure_vol,Active_Measure_cur = POWER.VOL_CUR(6)--active
		Active_Measure_vol = Active_Measure_vol * 1000--mV
		Active_Measure_cur = Active_Measure_cur / 1e3--uA
		--table.insert(test_DATA,Measure_vol)
		table.insert(test_DATA,Active_Measure_cur / 1e3)--mA
		local Pixel_current=(Active_Measure_cur-Dark_Measure_cur)/(576*768*DutyCyele)
		table.insert(test_DATA,Pixel_current)
		
		LOG.INFO(string.format("AVEE vol:%.2fmV,Dark_Measure_vol:%.2fV,Dark_Measure_Current:%fuA,Active_Measure_cur:%fuA,Pixel_current:%fuA",Set_voltage,Dark_Measure_vol,Dark_Measure_cur,Active_Measure_cur,Pixel_current))
		
		--local ret=SYS.IS_RUN_ERR()
		--if ret ~=0 then
			--SYS.CLR_RUN_ERR()
			--return 0
		--end
		
	end
	Set_DutState(OFF)
	AVEE1_OUT_V(Power.ValueSetting.AVEE1)
	
	local json_data = cjson.encode(test_DATA)

	LOG.INFO(json_data)

	return 0, json_data
end






function Active_Power_Test()
	local result_table ={}
	local VDD18_DATA = {
		VOLTAGE = 0.0,    -- volts
		CURRENT = 0.0,    -- amps
	}
	local VDD10_DATA = {
		VOLTAGE = 0.0,    -- volts
		CURRENT = 0.0,    -- amps
	}
	local AVEE_DATA = {
		VOLTAGE = 0.0,    -- volts
		CURRENT = 0.0,    -- amps
	} 
	DisplayOff()
	TIME.DELAY(400)
	POWER_ON_0x2D0()
	TIME.DELAY(200)
	--i3c_write(0x7c,0x30002d0)
	--bitset_mode_swich(1)
	TIME.DELAY(200)
	VDD18_DATA.VOLTAGE, VDD18_DATA.CURRENT=POWER.VOL_CUR(P_VDD18)
	VDD10_DATA.VOLTAGE, VDD10_DATA.CURRENT=POWER.VOL_CUR(P_VDD10_MIPI)
	AVEE_DATA.VOLTAGE, AVEE_DATA.CURRENT=POWER.VOL_CUR(P_AVEE)
	
	VDD18_DATA.CURRENT = VDD18_DATA.CURRENT/1e6
	VDD10_DATA.CURRENT = VDD10_DATA.CURRENT/1e6
	AVEE_DATA.CURRENT  = AVEE_DATA.CURRENT/1e6
	
	i3c_write(0x7c,0x30000a5)
	LOG.INFO(string.format("VDD18_DATA:%.4fV, %.4fmA",VDD18_DATA.VOLTAGE, VDD18_DATA.CURRENT))
	LOG.INFO(string.format("VDD10_DATA:%.4fV, %.4fmA",VDD10_DATA.VOLTAGE, VDD10_DATA.CURRENT))
	LOG.INFO(string.format("AVEE_DATA :%.4fV, %.4fmA",AVEE_DATA.VOLTAGE, AVEE_DATA.CURRENT))

	table.insert(result_table,VDD18_DATA.CURRENT)
	table.insert(result_table,VDD10_DATA.CURRENT)
	table.insert(result_table,AVEE_DATA.CURRENT)
	
	local json_data = cjson.encode(result_table)
	LOG.INFO(json_data)
	return 0, json_data
	
end

function Post_Initial_Current()
	local result_table ={}
	local VDD10_DATA_VOLTAGE = 0.0
	local VDD18_DATA_VOLTAGE = 0.0
	local AVEE_DATA_VOLTAGE = 0.0
		
	
	local VDD10_DATA_CURRENT = 0.0
	local VDD18_DATA_CURRENT = 0.0
	local AVEE_DATA_CURRENT = 0.0
	--Set_Color(color)
	Post_Initial_ON()

	TIME.DELAY(350)

	VDD18_DATA_VOLTAGE, VDD18_DATA_CURRENT=POWER.VOL_CUR(P_VDD18)
	VDD10_DATA_VOLTAGE, VDD10_DATA_CURRENT=POWER.VOL_CUR(P_VDD10_MIPI)
	AVEE_DATA_VOLTAGE, AVEE_DATA_CURRENT=POWER.VOL_CUR(P_AVEE)
	

	VDD18_DATA_CURRENT = VDD18_DATA_CURRENT/1e6
	VDD10_DATA_CURRENT = VDD10_DATA_CURRENT/1e6
	AVEE_DATA_CURRENT  = AVEE_DATA_CURRENT/1e6
	
	LOG.INFO(string.format("VDD18_DATA:%.4fV, %.4fmA",VDD18_DATA_VOLTAGE, VDD18_DATA_CURRENT))
	LOG.INFO(string.format("VDD10_DATA:%.4fV, %.4fmA",VDD10_DATA_VOLTAGE, VDD10_DATA_CURRENT))
	LOG.INFO(string.format("AVEE_DATA :%.4fV, %.4fmA",AVEE_DATA_VOLTAGE, AVEE_DATA_CURRENT))
	--POWER_OFF()
	table.insert(result_table,VDD18_DATA_CURRENT)
	table.insert(result_table,VDD10_DATA_CURRENT)
	table.insert(result_table,AVEE_DATA_CURRENT)
	
	local json_data = cjson.encode(result_table)
	LOG.INFO(json_data)
	return 0 ,json_data
end


function I3C_Communication_Test()
	LOG.DEBUG("<I3CCommunication_Test>")
	
	local ret = 0
	local data_table = {}
	local test_data = {
		0xAAAAAAAA,
		0x55555555,
		0xFFFFFFFF,
		0x00000000
	}	

	I3C_INIT()

	TIME.DELAY(200)
	for k, v in ipairs(test_data) do
		I3C_W_PEQUIN(0x0FFC, v)
		--TIME.DELAY(10)
		local read_data = I3C_R_PEQUIN(0x0FFC,4)
		local hex_str = string.format("0x%08X",read_data)
		println(hex_str)
		table.insert(data_table,hex_str)
		if v ~= read_data then
			LOG.ERROR("IIC read NG")
			ret = -1 
		end
	end
	
	IIC_CONFIG.init_default()
	
	local json_data = cjson.encode(data_table)
	LOG.INFO(json_data)
	return ret,json_data
	
end

--20260122 add
--I3C_Single_RW(0x0FFC,0x55555522)
function I3C_Single_RW(addr,data)
	LOG.DEBUG("<I3C_Single_RW>")
	local data_table = {}
	local ret = 0
	--POWER_OFF()
	--TIME.DELAY(200)
	I3C_INIT()
	
	I3C_W_PEQUIN(addr, data)
	--TIME.DELAY(10)
	local read_data = I3C_R_PEQUIN(addr)
	local hex_str = string.format("0x%08X",read_data)
	println(hex_str)
	table.insert(data_table,hex_str)
	if data ~= read_data then
		LOG.ERROR("IIC read NG")
		ret = -1
	end
	
	IIC_CONFIG.init_default()
	--POWER_OFF() --20251223 add
	local json_data = cjson.encode(data_table)
	LOG.INFO(json_data)
	return ret,json_data
	
end
--20260122 add

--20260113 ADD
function Efuse_post_write()
	--if EFUSE_WRITE==1 then
		LOG.INFO("==========Efuse Write B5 TO 0X8==========")
		local result_table={}
		local val_B5 = 0x8
		local addressLSB_B5 = 0xD4
		local bitwidth_B5 = 4
		local bitStart_B5 = 4
		local Efuse_write_flag_B5=efuse_write(val_B5, addressLSB_B5, bitwidth_B5, bitStart_B5)
		table.insert(result_table,Efuse_write_flag_B5)
		local post_data_B5 = EFuse_bits_read(addressLSB_B5, bitwidth_B5, bitStart_B5)
		if post_data_B5 ~= 0x8 then
			LOG.ERROR("Efuse_Write ERROR,Plese Check!!!!")
			LOG.ERROR(string.format("Efuse_Write:%d,Efuse_Read:%d",0x8,post_data_B5))
			
			table.insert(result_table,val_B5)
			table.insert(result_table,post_data_B5)
			table.insert(result_table,0)
		else
			local result_B5=post_data_B5CRCforTempSensorBlock
			table.insert(result_table,val_B5)
			table.insert(result_table,post_data_B5)
			table.insert(result_table,1)
			LOG.INFO(string.format("B5 Write sucess:%d",post_data_B5))
		end
	
	local json_data = cjson.encode(result_table)
	LOG.INFO(json_data)
	return 0,json_data

end
function DAC_WordpointA_B_Measurement_pixel()

	local result_table = {}
	local DATA_TABLE={}
	
	
	local PointA =  raw_values["POINTA"] or EFuse_bits_read(0x110,12,0)
	local PointB =  raw_values["POINTB"] or EFuse_bits_read(0x11C,12,4)
	PointA=PointA*5
	PointB=PointB*5
	LOG.INFO(string.format("PointA:%d",PointA))
	LOG.INFO(string.format("Pointb:%d",PointB))

	table.insert(DATA_TABLE,PointA/2)
	table.insert(DATA_TABLE,PointB/2)
	return DATA_TABLE
end
--bist_mode_swich_EN(1,0)
function bist_mode_swich_EN(mode,EN)
	if mode == 1 then
		println("All-On (Flat field)") 
		i3c_write(0xB0, 0xFFFF) --VPG_DATA
		i3c_write(0x9C, 0x00000003) --VPG_CTRL
	elseif mode == 2 then
		println("All-Off")
		i3c_write(0xB0, 0x0000) --VPG_DATA
		i3c_write(0x9C, 0x00000003) --VPG_CTRL
	elseif mode == 3 then
		println("CHKBRD_16X16")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xB4, 0x100010) --VPG_BAR_CHK_CFG  0x40000
		i3c_write(0x9C, 0x00000303) --VPG_CTRL
	elseif mode == 4 then
		println("INVCHKBRD_16X16")
		i3c_write(0xB0, 0xFF00) --VPG_DATA
		i3c_write(0xB4, 0x100010) --VPG_BAR_CHK_CFG  0x40000
		i3c_write(0x9C, 0x00000303) --VPG_CTRL
	elseif mode == 5 then
		println("CHKBRD_32X32")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xB4, 0x200020) --VPG_BAR_CHK_CFG  0x40000
		i3c_write(0x9C, 0x00000303) --VPG_CTRL
	elseif mode == 6 then
		println("INVCHKBRD_32X32")
		i3c_write(0xB0, 0xFF00) --VPG_DATA
		i3c_write(0xB4, 0x200020) --VPG_BAR_CHK_CFG  0x40000
		i3c_write(0x9C, 0x00000303) --VPG_CTRL
	elseif mode == 7 then
		println("CHKBRD_64X64")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xB4, 0x400040) --VPG_BAR_CHK_CFG
		i3c_write(0x9C, 0x00000303) --VPG_CTRL
	elseif mode == 8 then
		println("CHKBRD_64X64")
		i3c_write(0xB0, 0xFF00) --VPG_DATA
		i3c_write(0xB4, 0x400040) --VPG_BAR_CHK_CFG
		i3c_write(0x9C, 0x00000303) --VPG_CTRL
	elseif mode == 9 then
		println("9-Crosses")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xC0, 0x351440C8) --VPG_9_CROSS_CFG
		i3c_write(0x9C, 0x00000703) --VPG_CTRL
	elseif mode == 10 then
		println("Repeated Slice Tile  (Sparse Grid)")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xC4, 0x22228888) -- VPG_SLICE_AB
		i3c_write(0xC8, 0x03) --VPG_9_CROSS_CFG
		i3c_write(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 11 then
		println("VPG_SPARSEDGRID_X0Y0")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xC4, 0x11111111) -- VPG_SLICE_AB
		i3c_write(0xC8, 0x02) --VPG_9_CROSS_CFG
		i3c_write(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 12 then
		println("VPG_SPARSEDGRID_X1Y0")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xC4, 0x22222222) -- VPG_SLICE_AB
		i3c_write(0xC8, 0x02) --VPG_9_CROSS_CFG
		i3c_write(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 13 then
		println("VPG_SPARSEDGRID_X2Y0")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xC4, 0x44444444) -- VPG_SLICE_AB
		i3c_write(0xC8, 0x02) --VPG_9_CROSS_CFG
		i3c_write(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 14 then
		println("VPG_SPARSEDGRID_X3Y0")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xC4, 0x88888888) -- VPG_SLICE_AB
		i3c_write(0xC8, 0x02) --VPG_9_CROSS_CFG
		i3c_write(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 15 then
		println("VPG_SPARSEDGRID_X0Y1")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xC4, 0x11111111) -- VPG_SLICE_AB
		i3c_write(0xC8, 0x102) --VPG_9_CROSS_CFG
		i3c_write(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 16 then
		println("VPG_SPARSEDGRID_X1Y1")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xC4, 0x22222222) -- VPG_SLICE_AB
		i3c_write(0xC8, 0x102) --VPG_9_CROSS_CFG
		i3c_write(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 17 then
		println("VPG_SPARSEDGRID_X2Y1")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xC4, 0x44444444) -- VPG_SLICE_AB
		i3c_write(0xC8, 0x102) --VPG_9_CROSS_CFG
		i3c_write(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 18 then
		println("VPG_SPARSEDGRID_X3Y1")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xC4, 0x88888888) -- VPG_SLICE_AB
		i3c_write(0xC8, 0x102) --VPG_9_CROSS_CFG
		i3c_write(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 19 then
		println("VPG_SPARSEDGRID_X0Y2")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xC4, 0x11111111) -- VPG_SLICE_AB
		i3c_write(0xC8, 0x202) --VPG_9_CROSS_CFG
		i3c_write(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 20 then
		println("VPG_SPARSEDGRID_X1Y2")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xC4, 0x22222222) -- VPG_SLICE_AB
		i3c_write(0xC8, 0x202) --VPG_9_CROSS_CFG
		i3c_write(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 21 then
		println("VPG_SPARSEDGRID_X2Y2")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xC4, 0x44444444) -- VPG_SLICE_AB
		i3c_write(0xC8, 0x202) --VPG_9_CROSS_CFG
		i3c_write(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 22 then
		println("VPG_SPARSEDGRID_X3Y2")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xC4, 0x88888888) -- VPG_SLICE_AB
		i3c_write(0xC8, 0x202) --VPG_9_CROSS_CFG
		i3c_write(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 23 then
		println("CHKBRD_54X54")
		i3c_write(0xB0, 0xFF00) --VPG_DATA
		i3c_write(0xB4, 0x360036) --VPG_BAR_CHK_CFG
		i3c_write(0x9C, 0x00000303) --VPG_CTRL
	elseif mode == 24 then
		println("INVCHKBRD_54X54")
		i3c_write(0xB0, 0x00FF) --VPG_DATA
		i3c_write(0xB4, 0x360036) --VPG_STRIPE_H
		i3c_write(0x9C, 0x00000303) --VPG_CTRL
	end
	TIME.DELAY(10)
	if EN == 1 then
	   --IIC_W_PEQUIN(0x9C, 0x00000003) --VPG_CTRL
	   --TIME.DELAY(10)
	   IIC_W_PEQUIN(0x70, 0x40000003) --TMG_CTRL
	   TIME.DELAY(10)
	   IIC_W_PEQUIN(0x70, 0x80000001) --TMG_CTRL
	   TIME.DELAY(10)
	end

	return 0
end
--apply_calibrated_bandgap_trim_test_two(1)
function apply_calibrated_bandgap_trim_test_two(EN)---0:禁用阴极，1：使能阴极
	println("apply_calibrated_bandgap_trim_test_two")
	
	if EN ~= 0 and EN ~= 1 then EN = 1 end
	local dac_ctrl =  0x00000000 | (Bandgap_code << 4)|EN
	i3c_write(0x00CC, dac_ctrl)
	println("Apply Bandgap_code:0x%08X",dac_ctrl)
end

--20260116 ADD
 function test_temperature_sensor_thermometer()
 	local tim1 = TIME.TICK()
    local results = {}
	--PPMU.CAL_EN(1)    --5V off 
	Power.ValueSetting.SMU2 = 0
	SMU2(ON,1,0x82)
	TIME.DELAY(50)
    
    i3c_write(0x00CC, 0x00000000) -- ANLG_CTRL - BG disable = 0
    --apply_calibrated_bandgap_trim_test_two(1)--test_temperature_sensor_adc 已操作
    --#2:Enable thermometers, ADCs and manual mode
    i3c_write(0x00F0, 0x00000170)
    i3c_write(0x00EC, 0x00000012) -- TEMP_SENS_CTRL - THERM_EN, ADC_EN, RESET_ADC
    --#3:Enable TEMP_TPAD output and disable auto sampling

    local temp_sensors = {0,1} -- VTherm 0 and VTherm 1
    for _, sensor in ipairs(temp_sensors) do
    	--i3c_write(0x00F0, 0x00000110) -- TEMP_SAMP_CTRL
        -- 1. do manual temp sensor sampling
        local adc_source = sensor + 1 -- VTherm 0 = 001, VTherm 1 = 010
        local samp_ctrl = 0x00000100 | (adc_source << 4)
        i3c_write(0x00F0, samp_ctrl)
        TIME.DELAY(100)
        i3c_write(0x00F0, samp_ctrl | (1 << 1))
        TIME.DELAY(10)
        -- 2. Read ADC code and measure voltage
        local adc_code = i3c_read(0x0104) & 0x3FF-- TEMP_ADC_RAW_VAL[9:0]
        LOG.INFO(string.format("TEMP SENSOR CODE:0X%x",adc_code))
        if sensor == 0 then
            thermal_sensor0_code=adc_code
        else
            thermal_sensor1_code=adc_code
        end
		local measured_voltage, measured_current = POWER.VOL_CUR(P_SMU2) --SMU2: Temp_tpad  config mode?
		println("sensor%d_measured_voltage:%.4f",sensor,measured_voltage)
		table.insert(results,measured_voltage)--TPAD实际电压
    end
    SMU2(OFF, 0)
    table.insert(results,1000)--预期电压--暂不清楚，先返回任意打印
    table.insert(results,1000)--预期电压--暂不清楚，先返回任意打印
    
 	table.insert(results,thermal_sensor0_code)--50 ℃时ADC值
 	table.insert(results,thermal_sensor1_code)--50 ℃时ADC值
 	
	--table.insert(results,caled_temp_point)--实际温度50℃  
	--table.insert(results,caled_temp_point)--实际温度50℃  
 	
	local json_data = cjson.encode(results)
	LOG.INFO(json_data)
    println("test_temperature_sensor_thermometer的测试时间：%f S",(TIME.TICK() - tim1)/1000)
    --datalog_results("TEMP_THERMOMETER", results)
    return 0,json_data
    
 end
 
 function F_28M2_Temp_Read()

	local ret = 1
	local temp_table = {}
	local temp = 0
	local results = {}
	 --i3c_write(0x00CC, 0x00000000) -- ANLG_CTRL - BG disable = 0
    
    local temp_sensors = {0,1} -- VTherm 0 and VTherm 1
    for _, sensor in ipairs(temp_sensors) do
	    --i3c_write(0x00CC, 0x00000000)  -- ANLG_CTRL - BG disable = 0
	    apply_calibrated_bandgap_trim()
		i3c_write(0x00EC, 0x00000012)  -- DBG_MUX_310 - temp ADC on GPIOs
	    -- Enable external input via TEMP_TPAD
	    i3c_write(0x00F0, 0x00000110)  -- - TEMP_SAMP_CTRL - ADC source and TPAD_EN
	
	    -- Test all temperature sensors
	    local adc_source = sensor + 1  -- 0→1（001），1→2（010）
	    -- Set ADC source to output VTherm on TEMP_TPAD & ADCs
	    local samp_ctrl = 0x00000110 | (adc_source << 4) 
	    i3c_write(0x00F0, samp_ctrl)
	    TIME.DELAY(1) 
	
	    -- Start manual sample
	    local temp_reg = i3c_read(0x00F0, 1)
	    i3c_write(0x00F0, temp_reg | (1 << 1))
	    TIME.DELAY(100)
	
	    -- Read ADC code and measure voltage
	    local adc_code = i3c_read(0x0104, 1) & 0x3FF  -- TEMP_ADC_RAW_VAL[9:0]
	    --local voltage = POWER.VOL_CUR(1)  -- 
	
		local temperature = convert_adc_to_temperature(adc_code, sensor)
		--local temperature = convert_adc_to_temperature_old(adc_code)
		results[string.format("temp_sensors%d",sensor)] = temperature
    end
    TIME.DELAY(100)
    IIC_W_PEQUIN(0xCC, 0x1) --ANLG_CTRL
	println("temp_sensors0:%f",results["temp_sensors0"])
	println("temp_sensors1:%f",results["temp_sensors1"])
	--datalog_results(results)
	--LOG.INFO("TEMP = " ..table[1])
	IIC_W_PEQUIN(0x0, 0x109000) --CLK_CTRL
	TIME.DELAY(100)
	
	temp_table = {results["temp_sensors0"]}
	
	return ret, temp_table
end

--20260122 ADD
--Set_Pixel_Current(3.2,0.0459)

function DI_TRIM(current_uA,DutyCycle)
	Pixel_Current_uA = current_uA
	local tim1 = TIME.TICK()
	--Set pixel current in uA
	local result_table = {}
	local difference_value=current_uA*0.05--目标像素电流上下%5
	--计算目标值
		local dataCurrent=0x1FF
    if Color=="Red" then
    	dataCurrent=math.floor(current_uA/10*511)
    else
    	dataCurrent=math.floor(current_uA/4*511)
    end

	--Set_DutState(ON)
    --local dac_ctrl = 0
    ----local glbl, dac = get_avee_range_settings(voltage_AVEEE1)--GLBL=BIT[5:4]  DAC=BIT[7:6]
    --local glbl=1
    --local dac =0
    --dac_ctrl = dac_ctrl | (DAC_cal_trim_step << 16) -- DAC_CAL = 5 (recommended start)
    --local LO_C_MODE = (Color == "Red") and 0 or 1
    --println("LO_C_MODE:%d",LO_C_MODE)
    
    --dac_ctrl = dac_ctrl | (LO_C_MODE << 8) -- LO_C_MODE = 0 for red, 1 for G/B
    --dac_ctrl = dac_ctrl | (glbl << 6) | (dac << 4) -- AVEE range settings
    --dac_ctrl = dac_ctrl | (1 << 1) -- UPDATE_IMM
    --dac_ctrl = dac_ctrl | (1 << 0) -- EN
    --dac_ctrl = dac_ctrl | (1 << 3) 
 
    ----dac_ctrl = dac_ctrl | (1 << 2) 
    ----dac_ctrl = dac_ctrl & ~ (1 << 3) 
    --i3c_write(0x00D8, dac_ctrl) -- DAC_CTRL
    --LOG.INFO(string.format("dac_ctrl: 0x%X",dac_ctrl))
    
    --bist_mode_swich_EN(2,1)--ALL OFF
    Sw_by_name("W0.bmp")
    TIME.DELAY(100)
	local alloff_CURRENT=Average_current()
	alloff_CURRENT=alloff_CURRENT/1000
	dark_CURRENT=alloff_CURRENT  --dark current & cathode_on current
	
	i3c_write(0x00CC, 0x00000000) --Disable cathode mode
	TIME.DELAY(70)
	local cathode_off_CURRENT=Average_current()
	cathode_off_CURRENT=cathode_off_CURRENT/1000
	cathode_off_CURRENT=cathode_off_CURRENT
	
	local cathode_delta_CURRENT=dark_CURRENT-cathode_off_CURRENT
	
	apply_calibrated_bandgap_trim_test_two(1)--Disable cathode mode ,Enable is required
	--TIME.DELAY(10)
	--bist_mode_swich_EN(1,1)
	Sw_by_name("W255.bmp")
	Set_Brightness(DutyCycle)
	TIME.DELAY(100)
	local allon_CURRENT=Average_current()
	allon_CURRENT=allon_CURRENT/1000
	
	local pixel_current_init=allon_CURRENT/(576*768*DutyCycle)
	LOG.INFO(string.format("pixel_current_init:%.3f",math.abs(pixel_current_init)))
	
	local read_data_DC=IIC_R_PEQUIN(0xDC) --DAC_WORD
    local register_value,pixel_current,iter= calculate_Dichotomy(dark_CURRENT,current_uA,difference_value,dataCurrent,DutyCycle)
	LOG.INFO(string.format("iter:%.3f",math.abs(iter)))
	--local read_data1 = IIC_R_PEQUIN(0xDC)
    --LOG.INFO(string.format("DATA:0x%X",read_data1))

	local allon_trim_CURRENT=Average_current()
	allon_trim_CURRENT=allon_trim_CURRENT/1000

	--AVEE_V=POWER.VOL_CUR(P_AVEE)*1000
	DI_trim_code=register_value--全局缓存
    DAC_word_value=register_value
	LOG.INFO(string.format("Dregister_valueI_trim_code:0x%X",DI_trim_code))
    table.insert(result_table,dark_CURRENT)--IDLE-CATHODE-ON
    
	LOG.INFO(string.format("dark_CURRENT:%f",dark_CURRENT))
	table.insert(result_table,cathode_off_CURRENT)--IDLE-CATHODE-OFF Disable cathode mode
	
	LOG.INFO(string.format("cathode_off_CURRENT:%f",cathode_off_CURRENT))
	table.insert(result_table,cathode_delta_CURRENT)--IDLE-CATHODE-DELTA dark_CURRENT-cathode_off_CURRENT
	
	LOG.INFO(string.format("cathode_delta_CURRENT:%f",cathode_delta_CURRENT))
	table.insert(result_table,alloff_CURRENT)--ALLOFF bist_mode 2
	
	LOG.INFO(string.format("alloff_CURRENT:%f",alloff_CURRENT))
	table.insert(result_table,allon_CURRENT)--ALLON-INIT 校准前 bist_mode 1
	
	LOG.INFO(string.format("allon_CURRENT:%f",allon_CURRENT))
	table.insert(result_table,math.abs(pixel_current_init))--PIXELCURRENT-INIT 校准前 pixel_current
	
	LOG.INFO(string.format("pixel_current_init:%f",pixel_current_init))
	table.insert(result_table,read_data_DC)--DACWORD-INIT 校准前DAC_WORD
	
	LOG.INFO(string.format("read_data_DC:%f",read_data_DC))
	table.insert(result_table,allon_trim_CURRENT)--ALLON-TRIM 校准后 bist_mode 1
	
	LOG.INFO(string.format("allon_trim_CURRENT:%f",allon_trim_CURRENT))
	table.insert(result_table,pixel_current)--PIXELCURRENT-TRIM 校准后 pixel_current
	
	LOG.INFO(string.format("pixel_current:%f",pixel_current))
	table.insert(result_table,register_value)--DACWORD-TRIM 校准后DAC_WORD
	
	LOG.INFO(string.format("register_value:%f",register_value))
	table.insert(result_table,iter)--LOOPSTEPCNT 调节次数
	
	LOG.INFO(string.format("iter:%f",iter))
	--Set_DutState(OFF)
	local json_data = cjson.encode(result_table)
	LOG.INFO(json_data)
	return 0, json_data
    
end

--Set_Pixel_Current(1,0.0459)
function Set_Pixel_Current(current_uA)
	local result_table = {}
	--Set pixel current in uA

     --current_nA_at_DACWordpointA = EFuse_bits_read(0x110,12,0)*5/2 -- current at DAC word A (43)
     --current_nA_at_DACWordpointB = EFuse_bits_read(0x11C,12,4)*5/2 -- current at DAC word B (341)
    
    --variables for current at DACWordpoint A and B MUST be replaced with calibration data read from eFuse
	if TEST_MODE=="MT" then
		local dacpoint=DAC_WordpointA_B_Measurement_pixel()
	    current_nA_at_DACWordpointA = math.abs(dacpoint[1])
	    current_nA_at_DACWordpointB = math.abs(dacpoint[2])

	elseif TEST_MODE=="CP2" then
	    current_nA_at_DACWordpointA = DAC_POINTA_CODE/2 
	    current_nA_at_DACWordpointB = DAC_POINTB_CODE/2
	end
	if IS_DEBUG=="TRUE" then
	    current_nA_at_DACWordpointA = (156*5)/2 
	    current_nA_at_DACWordpointB = (1246*5)/2
	end
	LOG.DEBUG(string.format("pointA:%f,pointB:%f",current_nA_at_DACWordpointA,current_nA_at_DACWordpointB))
    DACWordpointA = 43
    DACWordpointB = 341
    
    current_gain = (current_nA_at_DACWordpointB - current_nA_at_DACWordpointA) / (DACWordpointB - DACWordpointA)
    LOG.INFO(string.format("k:%0.4f",current_gain))
    current_offset = (current_nA_at_DACWordpointA - (current_gain * DACWordpointA))
    LOG.INFO(current_offset)
     LOG.INFO(string.format("b:%0.4f",current_offset))
    target_current_nA = current_uA * 1000
    DAC_value_for_target_current = (target_current_nA - current_offset) / current_gain
    LOG.INFO(DAC_value_for_target_current)
    
    if DAC_value_for_target_current < 0 or DAC_value_for_target_current > 511 then
        LOG.ERROR("DAC_value_for_target_current is out of range: " .. tostring(DAC_value_for_target_current))
        return
    end
    dataCurrent = math.tointeger(math.floor(DAC_value_for_target_current)) & 0xFFFFFFFF 
    LOG.INFO(string.format("Set_Pixel_Current : %f Frame value is : 0x%x", target_current_nA, dataCurrent))
    LOG.INFO(string.format("DAC:%04x",dataCurrent))
    
    
    if Color == "Red" then
    	dataCurrent = math.tointeger(dataCurrent)
    end
    
    
    IIC_W_PEQUIN(0xDC, dataCurrent)  -- Write the DAC word
    DAC_word_value=dataCurrent
	--table.insert(result_table,Power.ValueSetting.AVEE1)--
	--table.insert(result_table,dataCurrent)--DACWORD-TRIM 校准后DAC_WORD

	--local json_data = cjson.encode(result_table)
	--LOG.INFO(json_data)
	return 0, dataCurrent
end

function Set_Duty_Cycle(duty_cycle_percent)
	local tim1 = TIME.TICK()
	--Set duty cycle for gray 255
	local result_table = {}
	frame_rate = 90  --Should be read from Pequin or defined elsewhere in Lua config
	ref_clock = 50000000  --Should be measured from Pequin or defined elsewhere in Lua config

	clock_cycles_per_frame = ref_clock/frame_rate-------------555,555.5555555556
	Rsync = clock_cycles_per_frame/768---------723.3796296296297
	LUT_val =math.floor( duty_cycle_percent*clock_cycles_per_frame/255)-------65,359.47712418301
	LOG.INFO(string.format('LUT_val: %f',LUT_val))
	data_LUT_val = math.tointeger(math.floor(LUT_val)) & 0xFFFFFFFF ------65359   0x0000FFCF
	LOG.INFO(string.format('LUT_val register value: 0x%x',data_LUT_val))
	
	--Set LUT value
	IIC_W_PEQUIN(0x18, 0xC9) --LUT_WR_CTRL
	IIC_W_PEQUIN(0x68, 0x1) --PAI_SETUP
	IIC_W_PEQUIN(0x60, 0x80) --PAI_LUT_XB_CTRL
	IIC_W_PEQUIN(0x8000,data_LUT_val) -- Set LUT value
	IIC_W_PEQUIN(0x18, 0xC0) --LUT_WR_CTRL
	LUT_val=data_LUT_val
	--Set the R_sync delay
	R_sync = clock_cycles_per_frame/768-----723.3796296296297
	R_sync_interval = math.tointeger(math.floor(Rsync))-------723
	local RSYNC_NUM_VALUE = 0x300 << 16  -- Setting RSYNC_NUM to 768 (0x300)-------0x3000000，49152000
	local RSYNC_INT_VALUE = R_sync_interval & 0xFFF -- Masking interval to 12 bits------723
	local data_RSYNC_CFG = RSYNC_NUM_VALUE | RSYNC_INT_VALUE
	LOG.INFO(string.format('RSYNC_INT value: %d (0x%x)', R_sync_interval, R_sync_interval))
	LOG.INFO(string.format('TMG_RSYNC_CFG register value: 0x%x', data_RSYNC_CFG))
	IIC_W_PEQUIN(0x7C, data_RSYNC_CFG) -- Set TMG_RSYNC_CFG (0x007C) [1, 2]
	RSYNC_CFG=data_RSYNC_CFG
	--local read_data = IIC_R_PEQUIN(0x7C)
    --LOG.INFO(string.format("DATA:0x%X",read_data))
    local tim2 = TIME.TICK()

	table.insert(result_table,LUT_val)
	--local json_data = cjson.encode(result_table)
	LOG.INFO(LUT_val)
	return 0, LUT_val
end

function Set_Drive_Condition(pixel_current, duty_cycle)
	Duty_cycle = duty_cycle
	local result_table = {}
	local _,lutData = Set_Duty_Cycle(duty_cycle)
	local ret,dacwordData=Set_Pixel_Current(pixel_current)
	table.insert(result_table,dacwordData)
	table.insert(result_table,lutData)
	local json_data = cjson.encode(result_table)
	LOG.INFO(json_data) 
	return ret,json_data 
end

function apply_DAC_calibration_code()
	println("apply_DAC_calibration_code")
	println("DAC_calibration_code:0x%X",DAC_calibration_code)
	i3c_write(0x00D8, DAC_calibration_code)
	println("Apply DAC_calibration_code:0x%08X",DAC_calibration_code)
end

--apply_DAC_CAL_code(10)
function apply_DAC_CAL_code(DAC_CAL_code)
	println("apply_DAC_CAL_code")
    local dac_ctrl = 0
    dac_ctrl = (DAC_CAL_code << 16) | 3
	println("DAC_calibration_code:0x%X",dac_ctrl)
	i3c_write(0x00D8, dac_ctrl)
	println("Apply DAC_calibration_code:0x%08X",dac_ctrl)
end

function apply_DI_trim_code()
	println("apply_DI_trim_code")
	println("DI_trim_code:0x%X",DI_trim_code)
	i3c_write(0xDC, DI_trim_code)
	println("Apply DI_trim_code:0x%08X",DI_trim_code)
end

--apply_DAC_WORD_code(300)
function apply_DAC_WORD_code(DAC_WORD_code)
	println("apply_DAC_WORD_code")
	println("DAC_WORD_code:0x%X",DAC_WORD_code)
	i3c_write(0xDC, DAC_WORD_code)
	println("Apply DAC_WORD_code:0x%08X",DAC_WORD_code)
end

function calculate_Dichotomy(darkcurrent,Target_current,difference_value,register_value,DutyCycle)


    -- 核心变量初始化
    local result = 0  -- 默认返回0，达标后更新为寄存器值
    local average_current = 0
    local average_current_table = {}
    local VOLTAGE = 0
    local CURRENT = 0
    local pixel_current = 0
    local low_value = 0x2B    -- 寄存器最小值（43）
    local high_value = 0x1FF  -- release to 1FF 20260206--寄存器最大值（341）
    local mid_value = 0x0
    local iter = 1
    local max_iter = 10       -- 最大迭代次数

    -- 初始寄存器值修正+写入硬件
    register_value = math.max(low_value, math.min(register_value, high_value))
    IIC_W_PEQUIN(0xDC, register_value)
    LOG.INFO(string.format("初始化：寄存器=0x%X，二分区间=[0x%X,0x%X]，目标电流=%.15fuA，允许误差=%.15fuA",
        register_value, low_value, high_value, Target_current, difference_value))

    -- 首次采样计算初始电流
    for i = 1, 5 do
        TIME.DELAY(50)
        VOLTAGE, CURRENT = POWER.VOL_CUR(6)
        pixel_current = ((math.abs(CURRENT)/1000) - (math.abs(darkcurrent)/1000)) / (768 * 576 * DutyCycle)
        table.insert(average_current_table, pixel_current)
        LOG.INFO(string.format("首次采样[%d]：%.15fuA", i, pixel_current))
    end
    table.sort(average_current_table)
    table.remove(average_current_table, 1)
    table.remove(average_current_table, #average_current_table)
    for _, val in ipairs(average_current_table) do
        average_current = average_current + val
    end
    average_current = average_current / #average_current_table
    LOG.INFO(string.format("初始平均电流：%.15fuA（与目标差值：%.15fuA）",
        average_current, math.abs(average_current - Target_current)))

    -- 初始电流已合格，直接返回寄存器值
    if math.abs(average_current - Target_current) <= difference_value then
        result = register_value
        LOG.INFO(" 初始电流已达标，返回寄存器值0x%X", result)
        return result, average_current
    end

    -- 二分法迭代调节
    while math.abs(average_current - Target_current) > difference_value and iter <= max_iter do
        LOG.INFO("\n=== 迭代["..iter.."/"..max_iter.."] ===")
        -- 重新采样电流（清空旧数据）
        average_current_table = {}
        average_current = 0
        for i = 1, 5 do
            TIME.DELAY(50)
            VOLTAGE, CURRENT = POWER.VOL_CUR(6)
            pixel_current = ((math.abs(CURRENT)/1000) - (math.abs(darkcurrent)/1000)) / (768 * 576 * DutyCycle)
            table.insert(average_current_table, pixel_current)
            LOG.INFO(string.format("采样[%d]：%.15fuA", i, pixel_current))
        end
        -- 滤波计算平均电流
        table.sort(average_current_table)
        table.remove(average_current_table, 1)
        table.remove(average_current_table, #average_current_table)
        for _, val in ipairs(average_current_table) do
            average_current = average_current + val
        end
        average_current = average_current / #average_current_table
        LOG.INFO(string.format("迭代[%d]平均电流：%.15fuA（差值：%.15fuA）",
            iter, average_current, math.abs(average_current - Target_current)))

        -- 二分法核心逻辑
        local current_diff = math.abs(average_current - Target_current)
        if current_diff > difference_value and average_current > Target_current then
            LOG.INFO(" 电流偏大，下调寄存器（当前区间：[0x"..string.format("%X",low_value)..",0x"..string.format("%X",high_value).."]）")
            high_value = register_value
            mid_value = math.floor((low_value + high_value) / 2)
            register_value = math.max(low_value, math.min(mid_value, high_value))
        elseif current_diff > difference_value and average_current < Target_current then
            LOG.INFO(" 电流偏小，上调寄存器（当前区间：[0x"..string.format("%X",low_value)..",0x"..string.format("%X",high_value).."]）")
            low_value = register_value
            mid_value = math.ceil((low_value + high_value) / 2)
            register_value = math.max(low_value, math.min(mid_value, high_value))
        end

        -- 写入新寄存器值+硬件稳定延时
        IIC_W_PEQUIN(0xDC, register_value)
        LOG.INFO(string.format("迭代[%d]寄存器更新为：0x%X（新区间：[0x%X,0x%X]）",
            iter, register_value, low_value, high_value))
        --TIME.DELAY(150)

        -- 检查是否收敛，收敛则更新result并返回
        if current_diff <= difference_value then
            result = register_value
            LOG.INFO(string.format(" 迭代[%d]调节成功！最终电流：%.15fuA，寄存器：0x%X",
                iter, average_current, result))
            return result, average_current,iter
        end

        iter = iter + 1
    end

    -- 【核心新增】迭代10次未收敛，返回0
    local final_diff = math.abs(average_current - Target_current)
    if iter > max_iter and final_diff > difference_value then
        result = 0  -- 强制返回0
        LOG.ERROR(string.format("❌ 达最大迭代次数（%d次），未调节到目标电流！最终电流：%.15fuA（差值：%.15fuA），返回0",
            max_iter, average_current, final_diff))
        return result, average_current,iter
    end

    -- 迭代次数未超但区间收敛（兜底返回）
    result = register_value
    LOG.INFO(string.format("调节结束，最终电流：%.15fuA，寄存器：0x%X", average_current, result))
    return result, average_current,iter
end

function Average_current()
	local data_table={}
	local data=0
	for i=1,5,1 do
			TIME.DELAY(10)
			local VOLTAGE,CURRENT=POWER.VOL_CUR(6)
			--pixel_current=((math.abs(CURRENT)/1000)-(math.abs(darkcurrent)/1000))/(768*576*DutyCycle)
			table.insert(data_table,CURRENT)
			
	end
		table.sort(data_table)
		table.remove(data_table, 1)
		table.remove(data_table, #data_table)
		--LOG.INFO(#data_table)
		for i=1,#data_table,1 do
			data=data+data_table[i]
		end
		--LOG.INFO(#data_table)
		data=data/#data_table
		return data
end
--Set_Brightness(0.0459)
function Set_Brightness(duty_cycle_percent,PWM_value,Rsync_value)--后续被Set_Duty_Cyclet替换

	if PWM_value==nil then PWM_value=255 end
	if Rsync_value==nil then Rsync_value=0x300 << 16 end
	local tim1 = TIME.TICK()
	--Set duty cycle for gray 255
	local result_table = {}
	frame_rate = 90  --Should be read from Pequin or defined elsewhere in Lua config
	ref_clock = 50000000  --Should be measured from Pequin or defined elsewhere in Lua config

	clock_cycles_per_frame = ref_clock/frame_rate
	Rsync = clock_cycles_per_frame/768-------
	LUT_val = math.floor(duty_cycle_percent*clock_cycles_per_frame/PWM_value)--255
	LOG.INFO(string.format('LUT_val: %f',LUT_val))
	data_LUT_val = math.tointeger(math.floor(LUT_val)) & 0xFFFFFFFF 
	LOG.INFO(string.format('LUT_val register value: 0x%x',data_LUT_val))
	
	--Set LUT value
	IIC_W_PEQUIN(0x18, 0xC9) --LUT_WR_CTRL
	IIC_W_PEQUIN(0x68, 0x1) --PAI_SETUP
	IIC_W_PEQUIN(0x60, 0x80) --PAI_LUT_XB_CTRL
	IIC_W_PEQUIN(0x8000,data_LUT_val) -- Set LUT value
	IIC_W_PEQUIN(0x18, 0xC0) --LUT_WR_CTRL
	LUT_code=data_LUT_val
	--Set the R_sync delay
	R_sync = clock_cycles_per_frame/768----
	R_sync_interval = math.tointeger(math.floor(Rsync))-------723
	local RSYNC_NUM_VALUE = Rsync_value--0x300 << 16  -- Setting RSYNC_NUM to 768 (0x300)--
	local RSYNC_INT_VALUE = R_sync_interval & 0xFFF -- Masking interval to 12 bits------723
	local data_RSYNC_CFG = RSYNC_NUM_VALUE | RSYNC_INT_VALUE
	LOG.INFO(string.format('RSYNC_INT value: %d (0x%x)', R_sync_interval, R_sync_interval))
	LOG.INFO(string.format('TMG_RSYNC_CFG register value: 0x%x', data_RSYNC_CFG))
	IIC_W_PEQUIN(0x7C, data_RSYNC_CFG) -- Set TMG_RSYNC_CFG (0x007C) [1, 2]
	RSYNC_CFG=data_RSYNC_CFG
	local read_data = IIC_R_PEQUIN(0x7C)
    LOG.INFO(string.format("DATA:0x%X",read_data))
    local tim2 = TIME.TICK()
    LOG.INFO("Power-up time: " .. string.format("%.3f", (tim2 / 1000 - tim1 / 1000)) .. " seconds")
	if read_data == data_RSYNC_CFG then
    	local json_data = cjson.encode(duty_cycle_percent)
		LOG.INFO(json_data)
		return 0, json_data
	else
		LOG.ERROR("Failed to set pixel current")
		local cur="Fail"
		table.insert(result_table,cur)
		local json_data = cjson.encode(result_table)
		LOG.INFO(json_data)
    	return 1,json_data
    end
end

function EFuse_bits_read_v2(addressLSB, bitwidth, bitStart)

	local result_table={}
	-- Configure eFuse reading
	i3c_write(0x0140, 0x10000000) -- Select eFuse debug field
	i3c_write(0x0148, 0xffffffff) -- Enable all GPIO pins
	i3c_write(0x0138, 0x00001909) -- Mux eFuse bus onto GPIOs
	i3c_write(0x0000, 0x0010C000) -- Enable eFuse controller clock
	i3c_write(0x015c, 0x00000011) -- Set read setup, hold and pulse width
	i3c_write(0x0164, 0x00000519) -- Set VQPS setup & hold
	
	TIME.DELAY(10)
	local results_table={}
	local efuse_data = {}
	local rows_start = math.floor(addressLSB/8) -- rows_start
	local rows_end = math.ceil((addressLSB+4)/8) -- rows_end
	-- Read entire eFuse block
	local n = 0
	for row = rows_start, rows_end do
		local read_cmd = 0x00004000 | row -- Read command with row address
		i3c_write(0x0154, read_cmd)
		--wait(10e-6) -- Wait for read to complete
		TIME.DELAY(10)
		-- Read eFuse byte from CSR
		local efuse_byte = i3c_read(0x0158) & 0xFF
		efuse_data[n+1] = efuse_byte
		println("read efuse_data[%d]=0x%02X",n+1,efuse_data[n+1])
		n = n+1
	end
	local efuse_data_hex = 0
	--local efuse_data = {0x15}
	local a = 0
	for i = 1,#efuse_data do 
		efuse_data_hex = efuse_data_hex | efuse_data[i] << a *8
		a = a+1
		--println("efuse_data_hex：0x%x",efuse_data_hex)
	end
	println("readefuse_data_hex：0x%x",efuse_data_hex) 
	local mask = 1
	efuse_data_bin = extract_bits(efuse_data_hex, bitStart, bitwidth)
	println("read efuse_data_bin：0x%x",efuse_data_bin) 
	println("read efuse_data_bin：0b'%s",toBinary(efuse_data_bin)) 
	table.insert(result_table,addressLSB)
	table.insert(result_table,efuse_data_bin)
	table.insert(result_table,bitStart)
	table.insert(result_table,bitwidth)
	local json_data = cjson.encode(result_table)
	LOG.INFO(json_data)
	return 0,json_data
	
end

--20260128 ADD
function AVEE_Current_Measurement()

	local result_table ={}
	local AVEE_DATA_VOLTAGE = 0.0
	local AVEE_DATA_CURRENT = 0.0
	
	AVEE_DATA_VOLTAGE, AVEE_DATA_CURRENT=POWER.VOL_CUR(P_AVEE)
	AVEE_DATA_CURRENT  = AVEE_DATA_CURRENT/1e6
	
	LOG.INFO(string.format("AVEE_DATA :%.4fV, %.4fmA",AVEE_DATA_VOLTAGE, AVEE_DATA_CURRENT))
	table.insert(result_table,AVEE_DATA_VOLTAGE)
	table.insert(result_table,AVEE_DATA_CURRENT)
	
	result_table=cjson.encode(result_table)
	LOG.INFO(result_table)
	
	return 0,result_table
end
--Power_Measurement(4)
function Power_Measurement(channel)

	local result_table ={}
	local POWER_DATA_VOLTAGE = 0.0
	local POWER_DATA_CURRENT = 0.0
	
	POWER_DATA_VOLTAGE, POWER_DATA_CURRENT=POWER.VOL_CUR(channel)
	POWER_DATA_CURRENT  = POWER_DATA_CURRENT/1e6
	
	LOG.INFO(string.format("AVEE_DATA :%.4fV, %.4fmA",POWER_DATA_VOLTAGE, POWER_DATA_CURRENT))
	table.insert(result_table,POWER_DATA_VOLTAGE)
	table.insert(result_table,POWER_DATA_CURRENT)
	
	result_table=cjson.encode(result_table)
	LOG.INFO(result_table)
	
	return 0,result_table
end
--20260204 ADD
 function dac_2point_calibration()
    local results = {}

   	--PPMU.CAL_EN(1)    --5V off
   	--TIME.DELAY(10)
    --i3c_write(0x00D8, 0x0) --for init
    --Power.ValueSetting.SMU1 = 0 --nA or mV
    --SMU1(ON,0,0x82)    --0:give volage ; 1:give current, range max up to 5
    
    --TIME.DELAY(70)--
    --local refVolt, leakageCurrent = POWER.VOL_CUR(P_SMU1)--dac_full_range_calibration已经SMU已经打开
    ----println("measured_voltage:%f",measured_voltage)
    --println("leakageCurrent:%f",leakageCurrent)
    --apply_calibrated_bandgap_trim_test_two(1)--test_bandgap_trim已经开启
    --local difference=10 --tolerance
    --#2:Setup DAC  
    --local dac_ctrl = 0
    ----local glbl, dac = get_avee_range_settings(voltage_AVEEE1)--GLBL=BIT[5:4]  DAC=BIT[7:6]
    --local glbl=1
    --local dac =0
    --dac_ctrl = dac_ctrl | (DAC_cal_trim_step << 16) -- DAC_CAL = 5 (recommended start)
    --local LO_C_MODE = (Color == "Red") and 0 or 1
    --println("LO_C_MODE:%d",LO_C_MODE)
    --dac_ctrl = dac_ctrl | (LO_C_MODE << 8) -- LO_C_MODE = 0 for red, 1 for G/B
    --dac_ctrl = dac_ctrl | (glbl << 6) | (dac << 4) -- AVEE range settings
    --dac_ctrl = dac_ctrl | (1 << 1) -- UPDATE_IMM
    --dac_ctrl = dac_ctrl | (1 << 0) -- EN
    --dac_ctrl = dac_ctrl | (1 << 3) 
    ----dac_ctrl = dac_ctrl | (1 << 2) 
    ----dac_ctrl = dac_ctrl & ~ (1 << 3) 
    --i3c_write(0x00D8, dac_ctrl) -- DAC_CTRL

    --println("dac_ctrl:0x%08X",dac_ctrl)
    --#3:Set DAC Word to nominal drive current
    local point1 = 43
    local point2 = 341
    i3c_write(0x00DC, point1) -- DAC_WORD
    println("dac_word:0x%08X",point1)
    TIME.DELAY(70)--1000ms??????????????????????
    local refVolt, leakageCurrent1 = POWER.VOL_CUR(P_SMU1)
    --println("measured_voltage:%f",measured_voltage)
    println("Code43_Current:%f",leakageCurrent1)
    
    i3c_write(0x00DC, point2) -- DAC_WORD
    println("dac_word:0x%08X",point2)
    TIME.DELAY(70)--1000ms??????????????????????
    local refVolt, leakageCurrent2 = POWER.VOL_CUR(P_SMU1)
    --println("measured_voltage:%f",measured_voltage)
    println("Code341_Current:%f",leakageCurrent2)
	
	SMU1(OFF, 0)
	if IS_DEBUG=="TRUE" then
		DAC_POINTA_CODE=337
		DAC_POINTB_CODE=2638
	end
	table.insert(results,math.abs(DAC_POINTA_CODE))
	table.insert(results,math.abs(DAC_POINTB_CODE))
	
	local json_data = cjson.encode(results)
	LOG.INFO(json_data)
	return 0,json_data
	
end
--I2C_FRAME_CONTROL(200)
function I2C_FRAME_CONTROL(num_frames)

	local TMG_ISYNC_CFG_ADDR=0x74
	local base_value=0x12087a23
	
	local cleared_value=base_value & 0x8FFFFFFF
	local new_value=cleared_value | ((num_frames & 0x7)<<28)
	
	for i=1,num_frames do	
		IIC_W_PEQUIN(0x70, 0x00000000)
		IIC_W_PEQUIN(TMG_ISYNC_CFG_ADDR, new_value)
		
		IIC_W_PEQUIN(0x70, 0x40000003)
		TIME.DELAY(11)
		IIC_W_PEQUIN(0x70, 0x80000001)
	end
	
	return 0
end

function calc_8bit_dec(bit8_str)
   
    if type(bit8_str) ~= "string" or #bit8_str ~= 8 then
        LOG.ERROR("calc_8bit_dec 输入必须是8位二进制字符串")
    end
    if not bit8_str:match("^[01]+$") then
        LOG.ERROR("calc_8bit_dec 输入只能包含0和1")
    end

    local dec = 0
    for i = 1, 8 do
        local bit_pos =  i  -- 字符串索引：1→8（从左到右）
        local bit_char = bit8_str:sub(bit_pos, bit_pos)
        local bit = tonumber(bit_char) or 0
        dec = dec + bit * (2 ^ (i - 1))
    end
    return dec
end

function  efuse_write_512(val, addressLSB, bitwidth, bitStart)
	local efuse_bit = 0
	local addr_shift = 0
	local Efuse_data = 0
	local result=0
	addressLSB = math.floor((addressLSB/8)/2)
	--println("efuse_write(0x%X,0x%04X,%d,%d)",val, ad dressLSB, bitwidth, bitStart)
	for i=0, bitwidth-1 do
		bit=(val>> i)&1
		efuse_bit = bitStart + addr_shift
		
		if efuse_bit > 7 then
			addressLSB = addressLSB + 1
			efuse_bit = 0
			bitStart = 0
			addr_shift = 0
		end
		
		addr_shift = addr_shift + 1

		if bit == 1 then
			i3c_write(0x0154, 0x00008000|((efuse_bit << 6) |addressLSB))
			TIME.DELAY(10)
		end
	end

end

function EFuse_bits_read_512(addressLSB, bitwidth, bitStart)

	local results_table={}
	local efuse_data = {}
	local rows_start = math.floor((addressLSB/8)/2) -- rows_start
	local rows_end = math.ceil(((addressLSB+4)/8)/2) -- rows_end
	-- Read entire eFuse block
	local n = 0
	for row = rows_start, rows_end do
		local read_cmd = 0x00004000 | row -- Read command with row address
		i3c_write(0x0154, read_cmd)
		--wait(10e-6) -- Wait for read to complete
		TIME.DELAY(10)
		-- Read eFuse byte from CSR
		local efuse_byte = i3c_read(0x0158) & 0xFF
		efuse_data[n+1] = efuse_byte
		--println("read efuse_data[%d]=0x%02X",n+1,efuse_data[n+1])
		n = n+1
	end
	local efuse_data_hex = 0
	--local efuse_data = {0x15}
	local a = 0
	for i = 1,#efuse_data do 
		efuse_data_hex = efuse_data_hex | efuse_data[i] << a *8
		a = a+1
		--println("efuse_data_hex：0x%x",efuse_data_hex)
	end
	--println("readefuse_data_hex：0x%x",efuse_data_hex) 
	local mask = 1
	efuse_data_bin = extract_bits(efuse_data_hex, bitStart, bitwidth)
	
	return efuse_data_bin
end

function Display_Frames_WithPulse(black1_number, w1_number, black2_number, pic_name, delay_time, trigger_keep_time, delay)
    -- 初始化温度传感器控制寄存器
    i3c_write(0x00EC, 0x00000012) -- TEMP_SENS_CTRL - THERM_EN, ADC_EN, RESET_ADC
    i3c_write(0x00F0, 0x00000010) -- TEMP_SAMP_CTRL

    -- 读取 eFuse 中存储的两个温度传感器校准 ADC 码
    local codeEfuse1 = EFuse_bits_read(0x154, 10, 4) & 0x03FF
    local codeEfuse2 = EFuse_bits_read(0x160, 10, 0) & 0x03FF
    local caled_temp_point = 50   -- 校准温度点，可根据实际情况从 eFuse 读取

    -- 启动帧显示
    Soft_Multi_frame(black1_number, w1_number, black2_number, pic_name, delay_time, trigger_keep_time, delay)

    -- 存储原始采集数据（电压 mV，电流 nA）
    local vdd10_vol_raw = {}
    local vdd10_cur_raw = {}
    local avee_vol_raw = {}
    local avee_cur_raw = {}
    local temp_raw = {}   -- 每个元素为 {temp0, adc0, temp1, adc1}

    -- === 数据采集循环（只采集，不处理） ===
    for i = 1, 8 do
        -- 读取电压电流
        local vdd10_vol, vdd10_cur = POWER.VOL_CUR(P_VDD10)
        local avee_vol, avee_cur = POWER.VOL_CUR(P_AVEE)
        table.insert(vdd10_vol_raw, vdd10_vol)
        table.insert(vdd10_cur_raw, vdd10_cur)
        table.insert(avee_vol_raw, avee_vol)
        table.insert(avee_cur_raw, avee_cur)

        -- 读取两个温度传感器
        local temp_vals = {}   -- {temp0, adc0, temp1, adc1}
        for adc_source = 1, 2 do   -- adc_source=1 对应传感器0, 2对应传感器1
            -- 启动手动采样
            local samp_ctrl = (adc_source << 4)   -- 设置 ADC source
            i3c_write(0x00F0, samp_ctrl)
            i3c_write(0x00F0, samp_ctrl | (1 << 1))   -- 触发采样
            TIME.DELAY(10)   -- 等待转换完成

            -- 读取 ADC 码
            local adc_code = i3c_read(0x0104) & 0x3FF

            -- 根据校准值计算温度
            local codeEfuse = (adc_source == 1) and codeEfuse1 or codeEfuse2
            local temp = caled_temp_point + (adc_code - codeEfuse) / (-1.6)   -- 温度计算公式，与您代码一致

            -- 存入临时表
            if adc_source == 1 then
                temp_vals[1] = temp
                temp_vals[2] = adc_code
            else
                temp_vals[3] = temp
                temp_vals[4] = adc_code
            end
        end
        -- 保存本次采样的温度数据（四个元素）
        table.insert(temp_raw, temp_vals)

        -- 调试输出
        LOG.DEBUG(string.format("VDD10_C:%.3f mA, AVEE_C:%.3f mA", vdd10_cur / 1e6, avee_cur / 1e6))
        LOG.DEBUG(string.format("Temp0:%.2f°C (ADC=0x%X), Temp1:%.2f°C (ADC=0x%X)", 
            temp_vals[1], temp_vals[2], temp_vals[3], temp_vals[4]))
    end

    -- === 循环外统一数据处理 ===
    local max_VDD10_cur_mA = -math.huge
    local max_VDD10_vol_mV = nil
    local max_AVEE_cur_abs = -math.huge
    local max_AVEE_cur_signed_mA = nil
    local max_AVEE_vol_mV = nil
    local max_temp_value = -math.huge
    local max_temp_data = nil   -- 保存温度最大值对应的完整四元素表

    for idx = 1, #vdd10_cur_raw do
        -- VDD10
        local vdd10_cur_mA = vdd10_cur_raw[idx] / 1e6
        if vdd10_cur_mA > max_VDD10_cur_mA then
            max_VDD10_cur_mA = vdd10_cur_mA
            max_VDD10_vol_mV = vdd10_vol_raw[idx]
        end

        -- AVEE
        local avee_cur_mA = avee_cur_raw[idx] / 1e6
        local abs_cur = math.abs(avee_cur_mA)
        if abs_cur > max_AVEE_cur_abs then
            max_AVEE_cur_abs = abs_cur
            max_AVEE_cur_signed_mA = avee_cur_mA
            max_AVEE_vol_mV = avee_vol_raw[idx]
        end

        -- 温度：取两个传感器中的最大值
        local t0 = temp_raw[idx][1]
        local t1 = temp_raw[idx][3]
        local cur_max = math.max(t0, t1)
        if cur_max > max_temp_value then
            max_temp_value = cur_max
            max_temp_data = {}
            for _, v in ipairs(temp_raw[idx]) do
                table.insert(max_temp_data, v)
            end
        end
    end

    -- 构建结果表
    local result_table = {
    	VDD10_vol_mV = max_VDD10_vol_mV,
   		VDD10_cur_mA = max_VDD10_cur_mA,
    	AVEE_vol_mV = max_AVEE_vol_mV,
    	AVEE_cur_signed_mA = max_AVEE_cur_signed_mA,
    }
    LOG.INFO(string.format("max_VDD10_vol_mV:%.3fmV",max_VDD10_vol_mV*1000))
    LOG.INFO(string.format("max_VDD10_cur_mA:%.3fmA",max_VDD10_cur_mA))
    LOG.INFO(string.format("max_AVEE_vol_mV:%.3fmV",max_AVEE_vol_mV*1000))
    LOG.INFO(string.format("max_AVEE_cur_signed_uA:%.3fuA",max_AVEE_cur_signed_mA*1000/576/768/Duty_cycle))
    if max_temp_data then
        for __, v in ipairs(max_temp_data) do
            table.insert(result_table, v)
        end
    end

    local json_data = cjson.encode(result_table)
    LOG.INFO(json_data)
    return 0, json_data
end

function Soft_Multi_frame_Disabled() --关闭帧触发
	FPGA.PCIE_WRITE(0x25C4, 0x2 | (0<<8) | 0<<16)--防止额外的帧触发
end

function Warmup_All_On(vol,current_uA,DutyCycle)
	Sw_by_name("W255.bmp")
	--POWER.MULTI_SET(
	    --{ channel = P_AVEE,		en=1, range = 0x85, mode = 0, vol = vol, ovp = vol+100, uvp = 0, ocp = 800*1000*1000,  ucp = 0 }
	--)
	POWER_CHANNEL_VALUE(P_AVEE, ON, vol, -vol+100, -800)
	TIME.DELAY(10)
	DI_TRIM(current_uA,DutyCycle)
	
    local json_data = Temperature_Sensor_Thermometer()
    LOG.INFO(json_data)
    return 0, json_data
end

function EFuse_PostTest()
	local result_table={}
    -- 初始化寄存器
    local fields = {}
    IIC_W_PEQUIN(0x0140, 0x10000000)
    IIC_W_PEQUIN(0x0148, 0xffffffff)
    IIC_W_PEQUIN(0x0138, 0x00001909)
    IIC_W_PEQUIN(0x0000, 0x0010C000)
    IIC_W_PEQUIN(0x015c, 0x00000011)
    IIC_W_PEQUIN(0x0164, 0x00000519)
    TIME.DELAY(10)
	if TEST_MODE=="MT" then
	    local val_B5       = 0x9
		local val_S5       = 0x0
	    local CRC5_VALUE    = CRC4bit_Calculation(val_B5, val_S5,4, 1)
	    local val_clk90     = Efuse_90_clk & 0x7
	    local val_clk270    = Efuse_270_clk & 0x7
	    local val_data90    = Efuse_90_data & 0x7
	    local val_data270   = Efuse_270_data & 0x7
		local CRC_MIPI_TERM = CRC_CRC_Calculation_NEW_4BIT({val_clk90,val_clk270,val_data90,val_data270},CRC_MIPI_TERM)
		LOG.INFO(string.format("0X%s",val_B5))
		LOG.INFO(string.format("0X%s",val_S5))
		LOG.INFO(string.format("0X%s",CRC5_VALUE))
		LOG.INFO(string.format("0X%s",val_clk90))
		LOG.INFO(string.format("0X%s",val_clk270))
		LOG.INFO(string.format("0X%s",val_data90))
		LOG.INFO(string.format("0X%s",val_data270))
		LOG.INFO(CRC_MIPI_TERM)
	    -- 定义所有字段的配置
	    fields = {
	        { name = "B5",          value = val_B5,      state=0,  addr = 0xD4,  bits = 4, start_bit = 4 },
	        { name = "S5",        	value = CRC5_VALUE,  state=0,  addr = 0xDC,  bits = 4, start_bit = 4 },
	        { name = "CRC5",        value = CRC5_VALUE,  state=0,  addr = 0xDC,  bits = 4, start_bit = 4 },
	        { name = "clk_term90",  value = val_clk90,   state=0,  addr = 0x190, bits = 3, start_bit = 0 },
	        { name = "clk_term270", value = val_clk270,  state=0,  addr = 0x193, bits = 3, start_bit = 3 },
	        { name = "data_term90", value = val_data90,  state=0,  addr = 0x196, bits = 3, start_bit = 6 },
	        { name = "data_term270",value = val_data270, state=0,  addr = 0x199, bits = 3, start_bit = 1 },
	        { name = "CRC_MIPI_TERM",value = CRC_MIPI_TERM, state=0,  addr = 0x19C, bits = 4, start_bit = 4 },
	    }
	
	elseif TEST_MODE=="CP2" then
    -- 准备要写入的值
	    local IIC_ID = (Color == "Red") and 0x01 or (Color == "Green") and 0x02 or (Color == "Blue") and 0x03 or 0x00
	    local DAC_MODE = (Color == "Red") and 0 or 1
	    local DAC_CAL = DAC_cal_trim_step
	    local Pixel_Current = math.floor(Pixel_Current_uA*1000 / 5)
	    local DAC_WORD = DAC_word_value
	    local BANDGAP = Bandgap_code
	    local TSENSOR_TEMP = 50
	    local TSENSOR_ADC1Q = tempratue_0p25_code
	    local TSENSOR_ADC3Q = tempratue_0p75_code
	    local TSENSOR_CODEA = thermal_sensor0_code
	    local TSENSOR_CODEB = thermal_sensor1_code
	    local CRCforDACBlock = CRC8bit_Calculation(Pixel_Current, Pixel_Current)   -- 注意：原代码中 B和S 均为 DAC_POINTA，可能为笔误，但保持原样
	    local TSENSOR_CRC = CRC8bit_Calculation(TSENSOR_CODEA, TSENSOR_CODEB)
	    local B3 = 0x09
	    local S3 = 0x00
	    local CRC3 = CRC4bit_Calculation(B3, S3, 4, 1)
	    local LundyuLED = LundyuLED_code   -- 
	    
	    local field_names = { "DAC_MODE","DAC_CAL","Pixel_Current","DAC_WORD" }
		local result = BuildFields(field_names)
		local CRCforDACBlock = CRC_CRC_Calculation_NEW_8BIT(result,dac_crc_MINLEN)
		
		
	    local field_names={ "BANDGAP","TSENSOR_TEMP","TSENSOR_ADC1Q","TSENSOR_ADC3Q","TSENSOR_CODEA","TSENSOR_CODEB"}
	    local result = BuildFields(field_names)
		local CRCforTempSensorBlock = CRC_CRC_Calculation_NEW_8BIT(result,CRC_TEMP_MINLEN)
	
	    -- 定义所有字段的配置
	    fields = {
	        { name = "IIC_ID",          value = IIC_ID,      state=0,    addr = 0x1F0, bits = 2, start_bit = 0 },
	        { name = "DAC_MODE",        value = DAC_MODE,    state=0,    addr = 0x100, bits = 1, start_bit = 0 },
	        { name = "DAC_MODE",        value = DAC_MODE,    state=0,    addr = 0x100, bits = 1, start_bit = 0 },
	        { name = "DAC_CAL",         value = DAC_CAL,     state=0,    addr = 0x102, bits = 4, start_bit = 2 },
	        { name = "Pixel_Current",   value = Pixel_Current,  state=0,    addr = 0x110, bits = 12, start_bit = 0 },
	        { name = "DAC_WORD",  		value = DAC_WORD,  state=0,    addr = 0x11C, bits = 12, start_bit = 4 },
	        { name = "BANDGAP",         value = BANDGAP,     state=0,   addr = 0x130, bits = 4, start_bit = 0 },
	        { name = "TSENSOR_TEMP",    value = TSENSOR_TEMP, state=0, addr = 0x13C, bits = 4, start_bit = 4 },
	        { name = "TSENSOR_ADC1Q",   value = TSENSOR_ADC1Q,state=0, addr = 0x140, bits = 10, start_bit = 0 },
	        { name = "TSENSOR_ADC3Q",   value = TSENSOR_ADC3Q,state=0, addr = 0x14A, bits = 10, start_bit = 2 },
	        { name = "TSENSOR_CODEA",   value = TSENSOR_CODEA,state=0, addr = 0x154, bits = 12, start_bit = 4 },
	        { name = "TSENSOR_CODEB",   value = TSENSOR_CODEB,state=0, addr = 0x160, bits = 12, start_bit = 0 },
	        { name = "TSENSOR_CRC",     value = TSENSOR_CRC,  state=0, addr = 0x170, bits = 8, start_bit = 0 },
	        { name = "B3",              value = B3,           state=0, addr = 0x0BC, bits = 4, start_bit = 4 },
	        { name = "S3",              value = S3,           state=0,  addr = 0x0C0, bits = 4, start_bit = 0 },
	        { name = "CRC3",            value = CRC3,         state=0,   addr = 0x0C4, bits = 4, start_bit = 4 },
	        { name = "CRCforDACBlock",  value = CRCforDACBlock, state=0,   addr = 0x128, bits = 8, start_bit = 0 },
	        { name = "CRCforTempSensorBlock",  value = CRCforTempSensorBlock,    state=0,   addr = 0x170, bits = 8, start_bit = 0 },
	    }
	end

    if EFUSE_WRITE == 1 then
        VQPS(ON)
        TIME.DELAY(10)
    end

    -- 统一处理每个字段
    for i, field in ipairs(fields) do
        local flag = EFuse_bits_read_TOTAL(field.addr, field.bits, field.start_bit)
        if flag == 0 then
            LOG.INFO(string.format("==========Efuse Write %s==========", field.name))
            fields[i].state=1
            if EFUSE_WRITE == 1 then
                efuse_write_TOTAL(field.value, field.addr, field.bits, field.start_bit)
            end
        else
        LOG.INFO(string.format("========== Efuse No Write %s==========",field.name))
        
        
        end
    end
    -- 写入完成后关闭 VQPS
    if EFUSE_WRITE == 1 then
        VQPS(OFF)
    end

    -- 重新配置寄存器以读取
    i3c_write(0x0140, 0x10000000)
    i3c_write(0x0148, 0xffffffff)
    i3c_write(0x0138, 0x00001909)
    i3c_write(0x0000, 0x0010C000)
    i3c_write(0x015c, 0x00000011)
    i3c_write(0x0164, 0x00000519)
    TIME.DELAY(10)

    -- 读取并校验每个字段
    for i, field in ipairs(fields) do
        local read_val = EFuse_bits_read_TOTAL(field.addr, field.bits, field.start_bit)
		if fields[i].state ==1 then
		   	table.insert(result_table, field.value)
		    table.insert(result_table, read_val)
	    	if read_val == field.value then
	        	table.insert(result_table, 1)
	        	LOG.INFO(string.format("%s Write success: %d", field.name, field.value))
	    	else
	        	table.insert(result_table, 0)
	        	LOG.ERROR(string.format("Efuse_Write ERROR: %s, write=%d, read=%d", field.name, field.value, read_val))
	    	end
	    else
	    	table.insert(result_table, '')
		    table.insert(result_table, read_val)
		    table.insert(result_table, '')
		end
    end  

    -- 编码并返回 JSON
    local json_data = cjson.encode(result_table)
    LOG.INFO(json_data)
    return 0, json_data
end	

function EFuse_bits_read_TOTAL(addressLSB, bitwidth, bitStart)
	-- Configure eFuse reading
	
	local results_table={}
	local efuse_data = {}
	local rows_start = math.floor(addressLSB/8) -- rows_start
	local rows_end = math.ceil((addressLSB+4)/8) -- rows_end
	-- Read entire eFuse block
	local n = 0
	for row = rows_start, rows_end do
		local read_cmd = 0x00004000 | row -- Read command with row address
		IIC_W_PEQUIN(0x0154, read_cmd)
		--wait(10e-6) -- Wait for read to complete
		TIME.DELAY(10)
		-- Read eFuse byte from CSR
		local efuse_byte = IIC_R_PEQUIN(0x0158) & 0xFF
		efuse_data[n+1] = efuse_byte
		--println("read efuse_data[%d]=0x%02X",n+1,efuse_data[n+1])
		n = n+1
	end
	local efuse_data_hex = 0
	--local efuse_data = {0x15}
	local a = 0
	for i = 1,#efuse_data do 
		efuse_data_hex = efuse_data_hex | efuse_data[i] << a *8
		a = a+1
		--println("efuse_data_hex：0x%x",efuse_data_hex)
	end
	--println("readefuse_data_hex：0x%x",efuse_data_hex) 
	local mask = 1
	efuse_data_bin = extract_bits(efuse_data_hex, bitStart, bitwidth)
	--println("read efuse_data_bin：0x%x",efuse_data_bin) 
	--println("read efuse_data_bin：0b'%s",toBinary(efuse_data_bin)) 
	return efuse_data_bin
end

function  efuse_write_TOTAL(val, addressLSB, bitwidth, bitStart)
	local efuse_bit = 0
	local addr_shift = 0
	local Efuse_data = 0
	local result=0
	addressLSB = math.floor(addressLSB/8)
	
	println("efuse_write(0x%X,0x%04X,%d,%d)",val, addressLSB, bitwidth, bitStart)
	for i=0, bitwidth-1 do
		bit=(val>> i)&1
		efuse_bit = bitStart + addr_shift
		
		if efuse_bit > 7 then
			addressLSB = addressLSB + 1
			efuse_bit = 0
			bitStart = 0
			addr_shift = 0
		end
		addr_shift = addr_shift + 1
		
		println("efuse_bit = 0b%s",toBinary(efuse_bit))
		if bit == 1 then
		
			IIC_W_PEQUIN(0x0154, 0x00008000|((efuse_bit << 6) |addressLSB))
			TIME.DELAY(10)
		end
	end
	return 0
end

function CRC8bit_Calculation(B, S, reverse)
    -- 输入：B、S 均为 12 位数据（取低 12 位有效）
    -- reverse: true 表示 MSB 优先（高位到低位），false 表示 LSB 优先（低位到高位，即 VBA 原方向）
    -- 1. 提取低12位
    local B12 = B & 0xFFF
    local S12 = S & 0xFFF
    -- 2. 拼接为 24 位数据：S 为高 12 位，B 为低 12 位
    local data = (S12 << 12) | B12
    -- 3. 初始化 CRC 寄存器（8 位，索引 0 为 LSB，7 为 MSB）
    local CRC = {[0]=0, [1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0}
    -- 4. 逐位处理（根据 reverse 决定方向）
    if reverse then
        -- MSB 优先：从高位到低位（bit23 到 bit0）
        for iBit = 23, 0, -1 do
            local bitVal = (data >> iBit) & 1
            local iInvert = bitVal ~ CRC[7]
            CRC[7] = CRC[6] ~ iInvert
            CRC[6] = CRC[5]
            CRC[5] = CRC[4]
            CRC[4] = CRC[3] ~ iInvert
            CRC[3] = CRC[2] ~ iInvert
            CRC[2] = CRC[1]
            CRC[1] = CRC[0] ~ iInvert
            CRC[0] = iInvert
        end
    else
        -- LSB 优先：从低位到高位（bit0 到 bit23），与 VBA 原逻辑一致
        for iBit = 0, 23 do
            local bitVal = (data >> iBit) & 1
            local iInvert = bitVal ~ CRC[7]
            CRC[7] = CRC[6] ~ iInvert
            CRC[6] = CRC[5]
            CRC[5] = CRC[4]
            CRC[4] = CRC[3] ~ iInvert
            CRC[3] = CRC[2] ~ iInvert
            CRC[2] = CRC[1]
            CRC[1] = CRC[0] ~ iInvert
            CRC[0] = iInvert
        end
    end
    
    -- 5. 将 CRC 寄存器转换为整数（LSB 对应 bit0）
    local result = 0
    for i = 0, 7 do
        result = result | (CRC[i] << i)
    end
    return result
end


function CRC4bit_Calculation(B, S, S_len, direction)
    -- 参数校验
    local B_4bit = B & 0x0F
    local s_bit_len = math.max(tonumber(S_len) or 1, 1)
    local S_valid = tonumber(S) or 0

    -- 拼接数据：B在高位，S在低位
    local total_bit_len = 4 + s_bit_len
    local full_data = (B_4bit << s_bit_len) | S_valid

    -- 更新CRC的核心逻辑（对应多项式0x9）
    local function update_crc(crc, bit_val)
        local X0 = bit_val ~ crc[3]          -- 输入与当前最高位异或
        return {
            [3] = X0 ~ crc[2],               -- 新最高位
            [2] = crc[1],
            [1] = crc[0],
            [0] = X0                          -- 新最低位
        }
    end

    -- 初始化CRC寄存器（全0）
    local CRC = {[0]=0, [1]=0, [2]=0, [3]=0}

    -- 按方向逐位处理
    if direction == 1 then
        for bit_idx = total_bit_len - 1, 0, -1 do
            local bit_val = (full_data >> bit_idx) & 1
            CRC = update_crc(CRC, bit_val)
        end
    else
        for bit_idx = 0, total_bit_len - 1 do
            local bit_val = (full_data >> bit_idx) & 1
            CRC = update_crc(CRC, bit_val)
        end
    end

    -- 将4位寄存器组合成整数
    return (CRC[3] << 3) | (CRC[2] << 2) | (CRC[1] << 1) | CRC[0]
end

function AVEE_RANG_Setting(Avee_value)
	local avee_value=math.abs(Avee_value)
	local AVEE_RANG_GLBL=0
	local AVEE_RANG_DAC=0 
	if avee_value > 0 and avee_value < 3 then
		AVEE_RANG_GLBL=0
	elseif avee_value > 3 and avee_value < 3.5 then
		AVEE_RANG_GLBL=1
	elseif avee_value > 3.5 and avee_value < 4 then
		AVEE_RANG_GLBL=2
	end
	if avee_value > 0 and avee_value < 4 then
		AVEE_RANG_DAC=0
	elseif avee_value > 4 and avee_value < 5 then
		AVEE_RANG_DAC=1
	end
	return AVEE_RANG_GLBL,AVEE_RANG_DAC
end







