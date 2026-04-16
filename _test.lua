local ret=CRC4bit_Calculation(0x09, 0x00, 4, 1)
LOG.DEBUG(string.format("0X%X",ret))
bitset_mode_swich(1)
PIC.SW(Folder..'/'..imShow[2])
Temperature_Test(100,2)

MIPI_TO_VPG()
VPG_TO_MIPI()

Set_TEST_MODE("MT")
Set_TEST_MODE("CP2")


bitset_mode_swich(1,1)
bitset_mode_swich(1,0)
I2C_FRAME_CONTROL(11)

if ret ~= 0 then
	for i=1,#IIC_SLAVE_ADDR_TAB do 
		I3C_CONFIG.SLAVE_ADDR = IIC_SLAVE_ADDR_TAB[i]
		IIC_CONFIG.SLAVE_ADDR = IIC_SLAVE_ADDR_TAB[i]
		IIC_CONFIG.init_default()
		ret,tb = I2C_Communication_Test()
		if ret == 0 then
			break
		end
	end
end
	PPMU_IO_ALL_MODE(PPMU_MODE_TABLE.NORMAL_MODE)
GPIO.INIT(ARM_IO7_1V8, OUT, LOW, LOW)
GPIO.INIT(ARM_IO8_1V8, OUT, LOW, LOW)

GPIO.OUT(ARM_IO8_1V8, 0)
GPIO.OUT(ARM_IO7_1V8, 0)

GPIO.OUT(ARM_IO8_1V8, 1)
GPIO.OUT(ARM_IO7_1V8, 1)

LOG.INFO(raw_values["jtagID"])







