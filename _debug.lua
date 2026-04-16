Set_TEST_MODE("MT")
Set_TEST_MODE("CP2")
Set_Color("R")

LOG.INFO(Color)
LOG.DEBUG(fields[1].state)

Power_Shorts_Test(Volt, delay, pinlist)--ok--MT &CP2
IO_Continuity_Test()--ok--MT &CP2
Idle_Power_Test()--ok--MT &CP2--上电
MIPI_Communication_Test()--ok--MT &CP2
EFuse_PreRead()--ok--MT &CP2
I2C_Communication_Test()--ok--MT &CP2
Display_init(0)--1:bistmode, 0:PG--点屏的
Set_DutState(ON)--MT &CP2
EFuse_PostTest()
test_bandgap_trim()--p0测试NG--1.1V调节到1V		CP2
test_temperature_sensor_adc()--ok  ADC 1/4,3/4   CP2
test_temperature_sensor_thermometer()--ok TSENSOR_CODEA，TSENSOR_CODEAB		CP2
Temperature_Sensor_Thermometer()----MT
dac_full_range_calibration()--p0测试NG  20 or 8		CP2
dac_2point_calibration()--测试NG 43 341		CP2
Mipi_Term90_270_Test(90, 0)--MT
Mipi_Term90_270_Test(270, 0)--MT

DI_TRIM(3.2,0.0459)--CP2
AVEE_SWEEP(0.0459)--CP2
AVEE_Trim_Test()--MT
EFuse_PostTest()--MT &CP2
Set_Drive_Condition(3.2, 0.04)--MT &CP2

Mipi_Term90_270_Test(90,0)
Mipi_Term90_270_Test(270,0)
PIC.SW(Folder..'/'..imShow[1])
Soft_Multi_frame(1, 11, 1, "1by12-12.bmp", 1000, 5, 3)--MT &CP2
Display_Frames_WithPulse(1, 11, 1, "W255.bmp", 4000, 5, 3)--MT &CP2

Warmup_All_On(0,3,0.0459)--CP2
test_demura_write_LUTfile("20251223_B_2DIDforDebug1234_UNAC22001251119032549_demura.txt")--MT &CP2

local field_names = {"code","rev","x","y","L0","L1","L2","L3","L4","L5","L6","L7","L8","wafer","fab","foundry","jtagID","sub","min0","maj","b1","timestamp","S1"}
Set_Brightness(0.09)
Set_Drive_Condition(3.2, 0.04)
CRC_CRC_Calculation_NEW_8BIT(BuildFields(field_names),CRC1_MINLEN)

	"DAC_MODE","DAC_CAL","DAC_POINTA","DAC_POINTB"	
	
	
	
	"BANDGAP","TSENSOR_TEMP","TSENSOR_ADC1Q","TSENSOR_ADC3Q","TSENSOR_CODEA"
	
	Soft_Multi_frame(1,11,1,"1by12-12.bmp",1,5,3)
	
	Soft_Multi_frame(1,11,1,"CrossHair_Image.bmp",1,5,3)
	Soft_Multi_frame(1,11,1,"W255.bmp",1,5,3)
	18:31:10 0x31000001
	DAC_WordpointA_B_Measurement_pixel()