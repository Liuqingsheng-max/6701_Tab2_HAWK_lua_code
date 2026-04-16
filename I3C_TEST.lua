I3C.INIT(channel,voltage,speed,duty,EN)
channel: 0 A,1 B,2 C
voltage:1200mV-4700mV
speed:1MHZ-200MHZ
duty：占空比
0，%70占空比
1，%50占空比
2，%30占空比
en：1 enable 0 disable
I3C.SET_DASA(i3c_addr,slave_addr)
i3c_addr:I3C 动态分配地址，slave_addr设备地址（I2C）

I3C.WRITE({addr[1]....},{data[1],data[2]...})
I3C写

I3C.READ({addr[1]....},Read_length)

I3C.FREQ(frequency) 独立设置速率接口
I3C.DUTY(duty) 独立设置占空比接口 参考初始化


I3C.FREQ(12) 独立设置速率接口

POWER_ON()

I3C.INIT(0,1900,12.5,1,1)
I3C.BOARD_CAST(1)
I3C.SET_DASA(0x29,0x38)
I3C.WRITE({0xFC,0x0f},{0x12,0x34,0x56,0x78})

ReadData = I3C.READ({0xFC,0x0f},4)
for i = 1,#ReadData do 
	println(ReadData[i])
end



i3c_read(0x0ffc,4)
--I3C.FREQ(12.5)
--I3C.SET_DASA(0x48,0x08)
--I3C.DUTY(0)
--set_i3c_ctl_param_duty(0)
--i3c_ctl_speed = 16
--i3c_READ_TESTok2(0)
--i3c_READ_TESTok2(1)
--i3c_READ_TESTok2(2)
--i3c_READ_TESTok2(3)


--I3C.WRITE({1},{0x28})

ReadData = I3C.READ({0},2)
LOG.INFO(type(ReadData))
TEMP_h = ReadData[1]  
TEMP_l = ReadData[2]
LOG.INFO(string.format("SUCCESS i3c reg TEMP_h read: %d.%d", TEMP_h,TEMP_l>>4))


I3C.WRITE({addr[1]....},{data[1],data[2]...})
i3c_write(0x0ffc,0x12345678)
i3c_read(0x0ffc,4)