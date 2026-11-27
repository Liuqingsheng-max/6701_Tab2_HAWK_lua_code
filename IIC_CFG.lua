IIC_SLV_Defaul = 0x60	--0x60 Tab2 addr
IIC_SLV_R = 0x60	--0x38： 未烧I2C ID efuse地址的屏（红绿蓝均可）	
IIC_SLV_G = 0x60	--Temporary write
IIC_SLV_B = 0x60    --Temporary write

SLAVE_ADDR = IIC_SLV_Defaul

IIC_CONFIG = {
    I2C_CHANNEL = 0, --{ CHANNEL_A = 0, CHANNEL_B = 1, CHANNEL_C = 2 },
    I2C_LEVEL = 1800, --{ HIGH = 3.300, MIDDLE = 1.800, OFF = 0 },
    SLAVE_ADDR = 0x60,--0x38, --38==70  3F = 7E  
    I2C_SPEED = 400,--{ HIGH = 1000, MIDDLE = 400, LOW = 100 },
    I2C_DUTY = 1,	--AUTO,0:NORMAL
    RX_DELAY = 1,
    I2C_STATE = 1,--{ EN = 1, CLOSE = 0 },
}

IIC_SLAVE_ADDR_TAB={IIC_SLV_Defaul,0x60}
--IIC_SLAVE_ADDR_TAB={}

function IIC_CONFIG.init_default()
	----FPGA.IIC_EN(IIC_CONFIG.IIC_CHANNEL,0)
	--MCU.SERIAL_LEVEL(IIC_CONFIG.IIC_LEVEL)
	LOG.INFO("IIC_INITchushihua")
    return IIC_CONFIG.init(
        IIC_CONFIG.I2C_CHANNEL,
        IIC_CONFIG.I2C_LEVEL,
        IIC_CONFIG.I2C_SPEED,
        IIC_CONFIG.I2C_DUTY,
        IIC_CONFIG.RX_DELAY,
        IIC_CONFIG.I2C_STATE
    )
end



function IIC_CONFIG.init(channel, level, speed, duty, rx_delay,state)
    if not IIC_CONFIG then
        LOG.ERROR("IIC.INIT API no777 t available")
    end
    LOG.INFO(string.format("IIC Channel:%d",channel))
    LOG.INFO(string.format("IIC speed:%d",speed))
    return IIC.INIT(channel, level, speed, duty, rx_delay, state)
end

IIC_CONFIG.init_default()
LOG.INFO("IIC_INITchushihua")


function IIC_W_Tab2(addr,data)
	IIC.WRITE(0x60, {0xF0}, {0x5a,0x5a}) 
	IIC.WRITE(0x60, {0xF1}, {0x5a,0x5a})
	IIC.WRITE(0x60, {0xFc}, {0x5a,0x5a})
	addr_S = addr
	data_S = data
	local addr_buf = { addr&0xFF}
	local payload

	if data == nil then
		-- 仅命令字节，无数据（DCS 命令，如 0x11 Sleep Out / 0x29 Display On）
		IIC.WRITE(IIC_CONFIG.SLAVE_ADDR, addr_buf)
		return 0
	
	elseif type(data) == "number" then
		-- 传入32位数字
		--payload = {data&0xFF,(data>>8)&0xFF,(data>>16)&0xFF,(data>>24)&0xFF}
		payload = {(data>>24)&0xFF,(data>>16)&0xFF,(data>>8)&0xFF,data&0xFF}
		--LOG.INFO("data is number")
	elseif type(data) == "table" then
		-- 字节数组，支持1~256字节任意长度
		payload = data
	else
		LOG.ERROR("Tab2 invalid data type ,actual type", type(data))
		return
	end

	--LOG.INFO(string.format("slave address:%02X, REG:0x%04X, data_len:%d",
		--IIC_CONFIG.SLAVE_ADDR, addr, #payload))
	IIC.WRITE(IIC_CONFIG.SLAVE_ADDR, addr_buf, payload)
end



function IIC_R_Tab2(addr,data_len)

	IIC.WRITE(0x60, {0xF0}, {0x5a,0x5a}) 
	IIC.WRITE(0x60, {0xF1}, {0x5a,0x5a})
	IIC.WRITE(0x60, {0xFc}, {0x5a,0x5a})
	local addre = {addr&0xFF}
	local ReadData = IIC.READ(IIC_CONFIG.SLAVE_ADDR, addre, data_len)
	local byte_str = ""
	for i =1,data_len do
		byte_str = byte_str .. " " .. string.format("0x% 02x ",ReadData[i])
	end
	
	local value = 0
	for i = 1,data_len do
		value = (value << 8) | ReadData[i]
	end
	
	LOG.INFO(string.format("REG:0x%04x len = %d bytes | Raw:[ %s] ",addr,data_len,byte_str))
	return value,ReadData
end


function IIC_Key_Set()

	IIC.WRITE(0x60, {0xF0}, {0x5a,0x5a}) 
	IIC.WRITE(0x60, {0xF1}, {0x5a,0x5a})
	IIC.WRITE(0x60, {0xFc}, {0x5a,0x5a})
end


function IIC_EN(ID,EN)
	if ID==0 then
		if EN==0 then
			PPMU.RELAY_EN(27)
			PPMU.RELAY_EN(28)
		elseif EN==1 then
			PPMU.RELAY_CLOSE(27)
			PPMU.RELAY_CLOSE(28)

		end
	elseif ID==1 then

		if EN==0 then
			PPMU.RELAY_EN(29)
			PPMU.RELAY_EN(30)
		elseif EN==1 then
			PPMU.RELAY_CLOSE(29)
			PPMU.RELAY_CLOSE(30)
		end
	
	end

end