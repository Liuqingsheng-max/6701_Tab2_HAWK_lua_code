POWER.ADJUST_OUTPUT(2,2500)


vol,col = POWER.VOL_CUR(2)
LOG.INFO(string.format("vol:%.2f,col:%.2f",vol,col))

POWER.SET_ALARM(2,0,2500,0,300*1000*1000)


LOG.INFO(DEDP.VERSION())





SYS.REBOOT(1)


data_table=DMIPI.VERSION()

version = (data_table[1]<<24)|(data_table[2]<<16)|(data_table[3]<<8)|data_table[4]


LOG.INFO("CORE FPGA VERSION:"..version)




adc = IIC_R_PEQUIN(0x03000180,0)
LOG.INFO(adc)
--LOG.INFO(string.format("vol:0x%x%x%x%x",adc[1],adc[2],adc[3],adc[4]))
LOG.INFO(string.format("vol:%02X %02X %02X %02X",adc[1],adc[2],adc[3],adc[4]))


	F_BURST_IIC_WRITE_4REGS_FOR_HI(0x0200600C,0x00000001)
	F_BURST_IIC_WRITE_4REGS_FOR_HI(0x020060A8,0x00002263)
	F_BURST_IIC_WRITE_4REGS_FOR_HI(0x02006014,0x00000200)
IIC.TRIGGER()



for i=0 ,100, 1 do
	ret = SYS.IS_RUN_ERR()
	if ret ~= 0 then
		SYS.CLR_RUN_ERR()
		LOG.ERROR("已点击中止按键，退出")
		return -1
	end
DisplayOn()
TIME.DELAY(200)
DisplayOff()
SYS.CLR_RUN_ERR()
TIME.DELAY(100)
end


SYS.CLR_RUN_ERR()






function ZC_S(DATA)
 SMU.TMUX_EN(DATA)
 LOG.INFO(SMU.GET_VOL())
 LOG.INFO(SMU.GET_CUR())
 --4.把所有开关调到S1
 SMU.SEL_SWITCH(0x00)
 SMU.TMUX_CLOSE(DATA)
end
tim1 = TIME.TICK()
SMU.SECOND_SWITCH(1)
for i=0,31,1 do
 SMU.RELAY_EN(i)
end
SMU.SEL_SWITCH(0x00)
SMU.SET_VOL(4)
ZC_S(0)
ZC_S(1)
ZC_S(2)
ZC_S(3)
ZC_S(4)
ZC_S(5)
ZC_S(6)
ZC_S(7)
ZC_S(8)
ZC_S(9)
ZC_S(10)
ZC_S(11)
ZC_S(12)
ZC_S(13)
ZC_S(14)
ZC_S(15)
ZC_S(16)
ZC_S(17)
ZC_S(18)
ZC_S(19)
ZC_S(20)
ZC_S(21)
ZC_S(22)
ZC_S(23)
ZC_S(24)
ZC_S(25)
ZC_S(26)
ZC_S(27)
ZC_S(28)
ZC_S(29)
ZC_S(30)
for i=0,31,1 do
 --LOG.INFO(i)
 SMU.RELAY_CLOSE(i)
 --TIME.DELAY(800)
end
tim2 = TIME.TICK()
LOG.INFO("上电时间"..(tim2/1000 - tim1/1000))
SYS.REBOOT(1)
