Set_TEST_MODE("MT")
Set_TEST_MODE("CP2")
Set_Color("B")

LOG.INFO(Color)
LOG.DEBUG(fields[1].state)
DVDD(1)
POWER_ON()
VQPS(1)

Warm_Up_Condition("Blue")
Set_Duty_Cycle(90, 100)
VPG_SetFlatField(255)
Pixel_Duty_Current_Sweep(120)  --SHMOO AVDD&AVEE1


Power_Shorts_Test(Volt, delay, pinlist)--ok--MT &CP2
IO_Continuity_Test()--ok--MT &CP2 
		
Idle_Power_Test()--ok--MT &CP2--上电
MIPI_Communication_Test()--ok--MT &CP2
EFuse_PreRead()--ok--MT &CP2
I2C_Communication_Test()--ok--MT &CP2
Display_init(0)--1:bistmode, 0:PG--点屏的
Set_DutState(ON)--MT &CP2
EFuse_PostTest()--MT &CP2
apply_trim()--MT 
test_bandgap_trim()--p0测试NG--1.1V调节到1V		CP2
test_temperature_sensor_adc()--ok  ADC 1/4,3/4   CP2
test_temperature_sensor_thermometer()--ok TSENSOR_CODEA，TSENSOR_CODEAB		CP2
Temperature_Sensor_Thermometer()----MT
dac_full_range_calibration()--p0测试NG  20 or 8		CP2
dac_2point_calibration()--测试NG 43 341		CP2

x=convert_adc_to_temperature(727, 1) 
log.info(x)
IIC_W_Tab2(0xF6, {0x00,0x0,0x80})
Mipi_Term90_270_Test(90, 0)--MT
for i = 1 ,10 do 
Mipi_Term90_270_Test(270, 0)--MT
end
DI_TRIM(0.7,0.0459)--CP2

AVEE_SWEEP(0.0459)--CP2
AVEE_Trim_Test()--MT
EFuse_PostTest()--MT &CP2
Set_Drive_Condition(3.2, 0.05)--MT &CP2
SMU1(OFF,1,0x82)
SMU2(OFF,1,0x82)
Mipi_Term90_270_Test(90,0)
for i = 1,10,1 do
Mipi_Term90_270_Test(270,0)
end
PIC.SW(Folder..'/'..imShow[1])
Soft_Multi_frame(1, 15, 1, "W255.bmp", 1000, 5, 1)--MT &CP2
Display_Frames_WithPulse(1, 11, 1, "W255.bmp", 4000, 5, 3)--MT &CP2
test_demura_write_LUTfile("20251223_B_2DIDforDebug1234_UNAC22001251119032549_demura.txt")
Warmup_All_On(0,3,0.0459)--CP2
test_demura_write_LUTfile("20251223_B_2DIDforDebug1234_UNAC22001251119032549_demura.txt")--MT &CP2
local field_names = {"code","rev","x","y","L0","L1","L2","L3","L4","L5","L6","L7","L8","wafer","fab","foundry","jtagID","sub","min0","maj","b1","timestamp","S1"}
Set_Brightness(0.3)
Set_Drive_Condition(3.2, 0.04)
CRC_CRC_Calculation_NEW_8BIT(BuildFields(field_names),CRC1_MINLEN)




PPMU_IO_ALL_MODE(PPMU_MODE_TABLE.NORMAL_MODE)
POWER.SINGLE_SET(4, 1,0x83, Power.CONSTANT_VOLTAGE ,1200, Power.OVPSetting.DVDD, Power.UVPSetting.DVDD, Power.OCPSetting.DVDD, Power.UCPSetting.DVDD, Power.UCPSetting.DVDD)
POWER.SINGLE_SET(Power.ChannelSetting.VDDIO, 1, Power.MEDIUM_RANGE, 0 , 200, Power.OVPSetting.VDDIO, Power.UVPSetting.VDDIO, Power.OCPSetting.VDDIO, Power.UCPSetting.VDDIO, Power.UCPSetting.VDDIO)
POWER.SINGLE_SET(5,1, Power.MEDIUM_RANGE, 0 ,200, Power.OVPSetting.AVDD, Power.UVPSetting.AVDD, Power.OCPSetting.AVDD, Power.UCPSetting.AVDD, Power.UCPSetting.AVDD)
POWER.SINGLE_SET(Power.ChannelSetting.AVDD, 1, Power.MEDIUM_RANGE, Power.CONSTANT_VOLTAGE ,800, Power.OVPSetting.AVDD, Power.UVPSetting.AVDD, Power.OCPSetting.AVDD, Power.UCPSetting.AVDD, Power.UCPSetting.AVDD)
