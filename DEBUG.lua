

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









