local ret=CRC4bit_Calculation(0x09, 0x00, 4, 1)
LOG.DEBUG(string.format("0X%X",ret))
bitset_mode_swich(1)
PIC.SW(Folder..'/'..imShow[2])
Temperature_Test(100,2)

MIPI_TO_VPG()
VPG_TO_MIPI()

Set_TEST_MODE("MT")
Set_TEST_MODE("CP2")
line=",alb,gfgh"
line = string.gsub(line, "^,", "")  -- 只删除开头的逗号
LOG.INFO(line)
	Set_Brightness(0.0459)

PPMU.CAL_EN(1) --开启5V 电压
PPMU.CAL_EN(0) --开启5V 电压

ShowChangelog()   -- 直接调用你写的函数

FPGA.PCIE_WRITE(0x2528, 0x1 |0X01<<5 | (1<<8) | 1<<16)

local tim1 = TIME.TICK()
test_temperature_sensor_thermometer()
local tim2 = TIME.TICK()
println("测试时间：%f S",(tim2- tim1)/1000)

Post_Initial_ON()
for i = 1,10,1 do
Mipi_Term90_270_Test(90, 0)
end
for i=1,20,1 do
Mipi_Term90_270_Test(270, 0)
end


Set_TEST_MODE("MT")
Set_Color("B")

--舜宇===========================
Demura_Stability_test(1)--Demura烧录稳定性测试

Demura_test(1)
--================================
Set_TEST_MODE("CP2")



Set_TEST_MODE("MT")
Set_Color("G")
count = 10
for i =1,count, 1 do
LOG.INFO(string.format("\n[第 %d/%d 次]", i, count))
--MIPI_RESET()
 --MIPI_FREQ_SET_SEL01(1200) -- 1.1Gbps
Display.init_lvds()
Idle_Power_Test()
MIPI_Communication_Test()
POWER_OFF()
end
PPMU.RELAY_CLOSE(0x7FFCFFFF)


 PPMU_IO_ALL_MODE(PPMU_MODE_TABLE.NORMAL_MODE)
POWER.SINGLE_SET(4, 1,0x83, Power.CONSTANT_VOLTAGE ,200, Power.OVPSetting.DVDD, Power.UVPSetting.DVDD, Power.OCPSetting.DVDD, Power.UCPSetting.DVDD, Power.UCPSetting.DVDD)
POWER.SINGLE_SET(Power.ChannelSetting.VDDIO, 1, Power.MEDIUM_RANGE, 0 , 200, Power.OVPSetting.VDDIO, Power.UVPSetting.VDDIO, Power.OCPSetting.VDDIO, Power.UCPSetting.VDDIO, Power.UCPSetting.VDDIO)
POWER.SINGLE_SET(5,1, Power.MEDIUM_RANGE, 0 ,200, Power.OVPSetting.AVDD, Power.UVPSetting.AVDD, Power.OCPSetting.AVDD, Power.UCPSetting.AVDD, Power.UCPSetting.AVDD)
POWER.SINGLE_SET(Power.ChannelSetting.AVDD, 1, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE ,800, Power.OVPSetting.AVDD, Power.UVPSetting.AVDD, Power.OCPSetting.AVDD, Power.UCPSetting.AVDD, Power.UCPSetting.AVDD)

Set_TEST_MODE("CP2")
IIC_W_Tab2(0x00EF,0x55555555)
IIC_R_Tab2(0x00EF, 4)
POWER_ON()
VDDIO(1)
 AVDD(1)
 DVDD(1)
RESET(HIGH)
 AVEE1(ON)
PPMU.CAL_EN(1)    --5V off 

PPMU_POWER_CHANNEL_TEST(cur)
PPMU_POWER_CHANNEL_TEST(200)

PPMU_IO_ALL_MODE(PPMU_MODE_TABLE.GND)
PPMU.RELAY_CLOSE(CHANNEL_TAB.DVDD_OUT)
PPMU_POWER_CHANNEL_TEST(200)

IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key

IIC_W_Tab2(0xE3, {0x01})
IIC_W_Tab2(0xE5,{0x00,0x2A,0x80,0x01,0x54,0x00,0x40, 0x00,0x80  ,0x01,0x00,0x00,0x00})  --PWM Timing Gen
IIC_W_Tab2(0xE4,{0x00,0x05,0x05,0x08,0x0f,0x00})  --PWM Timing Gen
    --E5為shadow register，需寫F4=01觸發Update才會生效（同IC.lua:133 / debug_mipi.lua:33）
IIC_W_Tab2(0xF4, {0x01})
IIC_R_Tab2(0xE3,1)
IIC_R_Tab2(0xE5,9)

VPG_SetSparseGrid(20, 20, 11, 11)
VPG_SetFlatField(255)

VPG_CrossHair(255,928, 736) -- Center
VPG_SetActiveArea(1472, 1856, 0, 0) -- full display

IIC_W_Tab2(0xb4,{0x0,0x0,0x0,0x0}) 
IIC_R_Tab2(0xb4,4)
IIC_R_Tab2(0xfb,10)
IIC_R_Tab2(0xe5,13)
IIC_R_Tab2(0xf6,3)


FirstPicture()

Set_Pixel_Current(1)


VPG_SetFlatField(127)
VPG_SetFlatField(255)
bist_mode_swich_EN(8, 1)
Power_Measurement("AVEE1")


VPG_9SQUARE_FRC(928, 736, 300, 300)
VPG_9POINT_FRC(928, 736, 300, 300)

VPG_SetFlatField(0)
VPG_SetActiveArea(1472, 1100, 0, 378) --set active area in center
VPG_SPARSEDGRID_X_Y(3, 4, 0,0)


-- for dutycycle workaround
IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key
TIME.DELAY(20)
IIC_W_Tab2(0xe3,{0x1}) 
TIME.DELAY(20)
IIC_W_Tab2(0xE5,{0x00,0x2A,0x80,0x01,0x54,0x00,0x40,0x00,0x10,0x01,0x00,0x00,0x00})  --PWM Timing Gen
TIME.DELAY(20)
IIC_W_Tab2(0xfb,{0x07,0x27,0xe5,0x01,0x03,0x00,0x30,0x00,0x00}) 
TIME.DELAY(100)
IIC_W_Tab2(0xf4,{0x1}) 

IIC_R_Tab2(0xfb,10)
-- for dutycycle workaround debug 10/16 EJ
--IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
--IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
--IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key
--TIME.DELAY(20)
--IIC_W_Tab2(0xe3,{0x1}) 
--TIME.DELAY(20)
IIC_W_Tab2(0xE5,{0x00,0x2A,0x80,0x01,0x54,0x00,0x40,0x00,0x10,0x01,0x00,0x00,0x00})  --PWM Timing Gen
TIME.DELAY(20)
IIC_W_Tab2(0xfb,{0x07,0x27,0xe5,0x01,0x03,0x00,0x30,0x00,0x00}) 
IIC_R_Tab2(0xfb,10)
TIME.DELAY(100)
IIC_W_Tab2(0xf4,{0x1}) 

IIC_W_Tab2(0xb0,{0x0,0x0,0x98})
IIC_W_Tab2(0xfb,{0x07,0x27,0xe5,0x01,0x03,   0x00,0x64    ,0x00,0x00}) 
TIME.DELAY(100)
IIC_W_Tab2(0xf4,{0x1})

IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key
		
IIC_R_Tab2(0xfd,3)
IIC_R_Tab2(0xf4,1)
IIC_R_Tab2(0xf8,34)
		
IIC_W_Tab2(0xF8, {0x72,0x10,0x10,0x10,0x20,0x10,0x10,0x25,0x0a,0x0a,0x03,0x11,0x20, 0x01,0x00 ,0x08,0x08,0x10,0x00,0x00,0x00,0x00,0x00,0x00,0x20,0x20,0x20,0x20,0x88,0x02,0x00,0x02,0x00,0x00 })

		
--- DItrim - manual  - Start - Red
IIC_R_Tab2(0xe3,1)
TIME.DELAY(20)
IIC_W_Tab2(0xe3,{0x1})  -- Content Monitor Off
TIME.DELAY(20)
Set_Duty_Cycle(90, 4.59)
TIME.DELAY(20)
IIC_W_Tab2(0xf6,{0x0,0x0,0x5f})   -- Pixel Current = 2uA
TIME.DELAY(20)
VPG_SetFlatField(0)  --display on first picture  flat field
local alloff_current_raw_uA = Average_current() / 1000     -- signed, as Pequin alloff_CURRENT
local Min_current_uA       = math.abs(alloff_current_raw_uA)
LOG.INFO(string.format("dark current (all-off) = %.3fuA", Min_current_uA))


IIC_R_Tab2(0xe3,1)
TIME.DELAY(20)
IIC_W_Tab2(0xe3,{0x1})  -- Content Monitor Off
TIME.DELAY(20)
Set_Duty_Cycle(90, 4.59)
TIME.DELAY(20)
IIC_W_Tab2(0xf6,{0x0,0x0,0x5f})   -- Pixel Current = 2uA
TIME.DELAY(20)
VPG_SetFlatField(255)  --display on first picture  flat field
TIME.DELAY(100)
local allon_current_raw_uA = Average_current() / 1000     -- signed, as Pequin alloff_CURRENT
local Max_current_uA       = math.abs(allon_current_raw_uA)
LOG.INFO(string.format("All on current (all-off) = %.3fmA", Max_current_uA/1000))

--(Max_value - Min_value)/(2917632 * 4.59/100) = Pxl I
-- 0.287/(2917632 * 4.59/100)  = ~ Pix_I
-- Return 0x5f - (Pix_I/21na) = ox5f - ((Pix_I/21na) ~ return  2
--- DItrim - manual  - Stop


--- DItrim - manual  - Start - REd/
	Set_Device_Condition_By_Color("Red")
IIC_R_Tab2(0xe3,1)
TIME.DELAY(20)
IIC_W_Tab2(0xe3,{0x1})  -- Content Monitor Off
TIME.DELAY(20)
Set_Duty_Cycle(90, 4.59)
TIME.DELAY(20)
IIC_W_Tab2(0xf6,{0x0,0x0,0x5f})   -- Pixel Current = 2uA
TIME.DELAY(20)
VPG_SetFlatField(0)  --display on first picture  flat field

IIC_R_Tab2(0xe3,1)
TIME.DELAY(20)
IIC_W_Tab2(0xe3,{0x1})  -- Content Monitor Off
TIME.DELAY(20)
Set_Duty_Cycle(90, 4.59)
TIME.DELAY(20)
IIC_W_Tab2(0xf6,{0x0,0x0,0x5f})   -- Pixel Current = 2uA
TIME.DELAY(20)
VPG_SetFlatField(255)  --display on first picture  flat field

--(Max_value - Min_value)/(2917632 * 4.59/100)
-- 0.287/(2917632 * 4.59/100)  = ~ 2uA
--- DItrim - manual  - Stop

--- DItrim - manual  - Start - Blue/



IIC_R_Tab2(0xe3,1)
	TIME.DELAY(20)
	IIC_W_Tab2(0xe3,{0x1})  -- Content Monitor Off
	TIME.DELAY(20)
	Set_Duty_Cycle(90, 4.59)
	TIME.DELAY(20)
	Set_Device_Condition_By_Color("Red")
	--IIC_W_Tab2(0xf6,{0x0,0x0,0x5F})   -- Pixel Current = 2uA
	TIME.DELAY(20)
	VPG_SetFlatField(255)  --display on first picture  flat field



for _ = 0,9 do
	
	VREF_Trim_Pinot_Binary_Search()
	Pixel_Current_DAC_Cal_binary() -- Read back 0xF8 and update only the required fields -- for the IPXL trim
	DisplayOff()
	TIME.DELAY(500)
	DisplayOn()
	TIME.DELAY(500)
	DI_TRIM_Pinot("Red")
	
	
	--apply_DI_trim_code()
	
	Temp_Sensor_Cal("TSR")
 	Temp_Sensor_Cal("TSL")
end

--IIC_W_Tab2(0xf6,{0x0,0x0,0x64})
	IIC_W_Tab2(0xe3,{0x0})
	IIC_W_Tab2(0xf4,{0x1})
	DAC_calibration_code = 390
DAC_calibration_code = 390
local version = SYS.VERSION()
LOG.INFO(string.format("%s",version ))

VREF_Trim_Pinot() -- Original time around 20s
VPG_SetFlatField(0)  --display on first picture  flat field
VPG_SetFlatField(255)  --display on first picture  flat field
IIC_W_Tab2(0x28,{0x1}) 
IIC_W_Tab2(0xf6,{0x0,0x0,0x00})

IIC_R_Tab2(0x28,1)
Temp_Sensor_Cal("TSR")

