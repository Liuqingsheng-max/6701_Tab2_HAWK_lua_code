I3C_CONFIG = {
    I3C_CHANNEL = 0, --{ CHANNEL_A = 0, CHANNEL_B = 1, CHANNEL_C = 2 },
    I3C_LEVEL = 1800, --{ HIGH = 3.300, MIDDLE = 1.800, OFF = 0 },
    SLAVE_ADDR = 0x38, --38==70  3F = 7E  
    I3C_SPEED = 4,--{ HIGH = 1000, MIDDLE = 400, LOW = 100 },
    I3C_DUTY = 1,	--AUTO,0:NORMAL
    I3C_DA = 0x29,
    I3C_STATE = 1,--{ EN = 1, CLOSE = 0 },
}



function I3C_INIT()
	I3C.INIT(I3C_CONFIG.I3C_CHANNEL, I3C_CONFIG.I3C_LEVEL, I3C_CONFIG.I3C_SPEED, I3C_CONFIG.I3C_DUTY, I3C_CONFIG.I3C_STATE)
	I3C.BOARD_CAST(1)
	I3C.SET_DASA(I3C_CONFIG.I3C_DA,I3C_CONFIG.SLAVE_ADDR)
	
	LOG.INFO(string.format("I3C_CHANNEL:%d",I3C_CONFIG.I3C_CHANNEL))
	LOG.INFO(string.format("I3C_SPEED:%d",I3C_CONFIG.I3C_SPEED))
	
end


function I3C_W_PEQUIN(addr,data)
	addr_S = addr
	data_S = data
	--local addr = {addr>>24&0xFF,addr>>16&0xFF,addr>>8&0xFF,addr&0xFF}
	local addr = {addr>>8&0xFF,addr&0xFF}
	local data = {data>>24&0xFF,data>>16&0xFF,data>>8&0xFF,data&0xFF}
	I3C.WRITE({addr[2],addr[1]},{data[4],data[3],data[2],data[1]})
	--TIME.DELAY(10)
	--LOG.INFO(string.format("IIC.WRITE(0x%02X,0x%02X,0x%02X,0x%02X,0x%02X,0x%02X)",addr[2],addr[1],data[4],data[3],data[2],data[1]))
	--IIC_R_PEQUIN_6701(addr_S,data_S)
	--TIME.DELAY(10)
end


function I3C_R_PEQUIN(addr,num)
	local addre = {addr>>8&0xFF,addr&0xFF}
	local ReadData = I3C.READ({addre[2],addre[1]},4)
	local value = (ReadData[4]<<24) + (ReadData[3]<<16) + (ReadData[2]<<8) + ReadData[1]
	--LOG.INFO(string.format("addr : 0x%04x value is : 0x%08x",addr,value))
	return value
end