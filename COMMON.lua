
PressCurAlarmRet = "PRESS CURRENT NG"
PressLvAlarmRet = "PRESS LV NG"

Gamma1AdjustFaileRet = "GAMMA1 ADJUST NG"
Gamma2AdjustFaileRet = "GAMMA2 ADJUST NG"
Gamma3AdjustFaileRet = "GAMMA3 ADJUST NG"
Gamma4AdjustFaileRet = "GAMMA4 ADJUST NG"
Gamma5AdjustFaileRet = "GAMMA5 ADJUST NG"
Gamma6AdjustFaileRet = "GAMMA6 ADJUST NG"
Gamma7AdjustFaileRet = "GAMMA7 ADJUST NG"
Gamma8AdjustFaileRet = "GAMMA8 ADJUST NG"

-----------------------------------
BurstMode = {
	Burst      = (1 << 1) 
}

DisplayType={
	MIPI_TYPE = 0,
	HDMI_TYPE = 1,
	EDP_TYPE  = 2
}
MipiType ={
		VIDEO      = 0x03, --VIDEO MODE
		COMMAND    = 0x02  --CMD MODE
}
function println(...)
	LOG.INFO(string.format(...))
end


function F_THIRD_CMD_PROCESS(cmdChar, ...)
    -- 参数类型校验
    local paramTable = {...}
    if type(cmdChar) ~= "string" then
        LOG.ERROR(string.format("参数类型错误: cmdChar应为字符串，实际为 %s", type(cmdChar)))
        return nil, "参数类型错误"
    end

    if type(paramTable) ~= "table" then
        LOG.ERROR(string.format("参数类型错误: paramTable应为表，实际为 %s", type(paramTable)))
        return nil, "参数类型错误"
    end
    --LOG.DEBUG(string.format("收到命令: %s, 参数数量: %d", cmdChar, #paramTable))
    
    -- 检查命令是否存在
    local func = ThirdPartyMap[cmdChar]
    if not func then
        LOG.ERROR(string.format("未知命令: %s", cmdChar))
        return nil, "未知命令"
    end

    local success,status,redata  = pcall(function()
        return func(table.unpack(paramTable))
    end)
    
    if status==nil then
    	status=1
    end
    --LOG.DEBUG(redata[1])
    local len, data=processListOptimized(redata)--计算长度,数据处理
	--LOG.DEBUG(status.."---"..data)
	return status, data--状态，"长度，数据"
end

--拼接字符串“长度，数据”
function processListOptimized(list)

    -- 处理空列表的特殊情况
    if list == nil then
        return 0, "0"
    end

    local count = #list
    local strList = {}
    
    -- 将所有元素转为字符串并存入新表
	-- 从第二个元素开始遍历
	for i = 1, #list+1 do
		if i==1 then
			strList[i] = tostring(count)
			goto continue  
		end
	    strList[i] = tostring(list[i-1])
	    --LOG.DEBUG(list[i-1])
	    ::continue::
	end
	
    -- 使用 table.concat 高效拼接字符串
    local result = table.concat(strList, ",")
    
    return count, result
end

-- 解析字符串数据
-- @param data 待解析的字符串，格式如 "15,62,33"
-- @return table 解析后的数值数组
-- @return number 数据个数
function parseCommaSeparatedData(data)
    -- 处理空值或无效输入
    if not data or type(data) ~= "string" or data == "" then
        return {0}, 0
    end
    
    local table = {}
    local count = 0
    
    -- 使用 string.gmatch 分割字符串
    for value in string.gmatch(data, "[^,]+") do
        count = count + 1
        -- 尝试将每个值转换为数值（如果是数值格式）
        local num = tonumber(value)
        table[count] = num ~= nil and num or value  -- 转换失败则保留原始字符串
    end
    return table, count
end

function toSINT(_i, _len)
	_len = _len or 9
	if ((_i >> (_len - 1)) & 0x1 == 1) then -- negative
		_o = -1 * ((0x1 << _len) - _i)
		if _o == -(2 ^ (_len - 1)) then
			_o = 0
		end
	else
		_o = _i
	end
	return _o
end

--自定义函数：将十进制数转为8位二进制字符串
--function toBinary(num)
	--local bin=""
	--for i=7,0,-1 do
		--bin=bin..(math.floor(num/2^i)%2)
	--end
	--return bin
--end
--转二进制格式
function toBinary(n)
	if n == 0 then return "0" end
	local bin = ""
	while n > 0 do
		bin = (n % 2) .. bin
		n = math.floor(n / 2)
	end
	return bin
end

--print(toBinary(42))  -- 输出: 101010

--提取指定长度的二进制
function extract_bits(num, start_bit, length)
    -- 创建掩码，提取指定长度的位
    local mask = (1 << length) - 1
    -- 右移到位，然后应用掩码
    return (num >> start_bit) & mask
end

-- 2进制字符串转10进制数值（含异常处理）
-- 参数：bin_str（2进制字符串）、default（转换失败时的默认值，可选）
-- 返回：10进制数值 或 默认值
function bin_to_decimal(bin_str, default)
    -- 先判断输入是否为字符串（避免非字符串类型报错）
    if type(bin_str) ~= "string" then
        return default or nil
    end
    
    -- 调用 tonumber 转换，base=2（仅解析 0/1 字符）
    local decimal = tonumber(bin_str, 2)
    -- 转换失败返回默认值，成功返回结果
    return decimal ~= nil and decimal or (default or nil)
end

--将时间戳转换成时间格式
function timestampToDateTime(MODE,timestamp, isUTC)
	if isUTC then
		if MODE == 0 then
			return os.date("!%Y", timestamp) --加！获取UTC时区时间
		elseif MODE == 1 then
			return os.date("!%m", timestamp) --加！获取UTC时区时间
		elseif MODE == 2 then
			return os.date("!%d", timestamp) --加！获取UTC时区时间
		end
		
	else
	   return os.date("%Y-%m-%d %H:%M:%S", timestamp)  --不加加！获取本地的时区
	end
   
end
-- 测试
--local ts = 1660261783
--println("UTC时间:", timestampToDateTime(ts, true))
--println("本地时间:", timestampToDateTime(ts, false))

-- 输出结果：
-- timestamp Code: 1660261783
-- 2022-08-11 23:49:43

function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

function toint(n)
    local s = tostring(n)
    local i,j = s:find('%.')
    if i then
        return tonumber(s:sub(1,i-1))
    else
        return n
    end
end

function keepDecimalTest(num, n)
    if type(num) ~= "number" then
        return num    
    end
    n = n or 2
    if num < 0 then
        return -(math.abs(num) - math.abs(num) % 0.1 ^ n)
    else
        return num - num % 0.1 ^ n
    end
end

function dfs_creat(file_id, file_type, file_name)
	LOG.CREAT_FILE(file_id..","..file_type..","..file_name)
end

function dfs_write(file_id, file_string)
	log.write_file(file_id .. "," .. file_string)
end

function F_SET_DISPLAY_SLEEP_OUT()
	dis.dcs_w(0xFE,0x00)
	dis.dcs_w(0, 0X05, 0x11)	--Sleep Out
end

function F_SET_DISPLAY_SLEEP_IN()
	dis.dcs_w(0xFE,0x00)
	dis.dcs_w(0x10)	-- Sleep In
end

function F_SET_DISPLAY_ON()
	dis.dcs_w(0xFE,0x00)
	dis.dcs_w(0x29)	-- Display On
end

function F_SET_DISPLAY_OFF()
	dis.dcs_w(0xFE,0x00)
	dis.dcs_w(0x28)	-- Display Off
end

function DFS_TEST(id)
	dfs_creat(id,"DFS", "DFS_test_file_name")
	
	TIME.DELAY(100)
	dfs_write(id, "Today is nice...")
end

function F_DFS_FUN_START(panel_id)
	log.creat_file("2"..",".."DFS"..","..panel_id)
	TIME.DELAY(100)
	log.write_file("2" .. "," .. "<PANEL_INFO>\n")
	log.write_file("2" .. "," .. "	<RAW>\n")
	log.write_file("2" .. "," .. "		<![CDATA[\n")
	log.write_file("2" .. "," .. "		RUNCARD_ID^OTP_ID^TP_RECIPE_ID^TP_VERSION:\n")
	log.write_file("2" .. "," .. "		]]>\n")
	log.write_file("2" .. "," .. "	</RAW>\n")
end

function F_DFS_GET_GAMMA_DATA_START()
	log.write_file("2" .. "," .. "	<OTP_DATA>\n")
	log.write_file("2" .. "," .. "		<![CDATA[\n")
	--OTP_DATA
	log.write_file("2" .. "," .. "		Mode^BOND^LV^COLOR^PATTERN^FREQUENCY^VALUE:\n")
end

function F_DFS_GET_GAMMA_DATA_END()
	log.write_file("2" .. "," .. "		]]>\n")
	log.write_file("2" .. "," .. "	</OTP_DATA>\n")
end

function F_DFS_GET_OPTICS_DATA(White_L,Black_L)
	log.write_file("2" .. "," .. "	<OPTICS_DATA>\n")
	log.write_file("2" .. "," .. "		<![CDATA[\n")
	
	log.write_file("2" .. "," .. "		ITEM^COLOR^VALUE_UPPER^VALUE_DEEPER^VALUE^VALUE_RESULT:\n")
	log.write_file("2" .. "," .. "		BRIGHTNESS^L255^^^"..White_L.."^OK\n")
	log.write_file("2" .. "," .. "		BRIGHTNESS^L0^^^%f^OK;\n",Black_L)
	log.write_file("2" .. "," .. "		CONTRAST_RATIO^CR^^"..White_L/Black_L.."^"..White_L/Black_L.."^\n")
	log.write_file("2" .. "," .. "		]]>\n")
	log.write_file("2" .. "," .. "	</OPTICS_DATA>\n")
end
--function F_DFS_SET_FRAME_RATE(No)

--end
function F_DFS_GET_GAMMA_DATA(Mode)
	--local Pos
	--local ModeName = GammaConfig[Mode].Name
	--local ModeRequency = GammaConfig[Mode].Requency
	--local idx
	
	--for idx=15,1,-1 do
		--local bind = GammaConfig[Mode].Binds[idx];
		--log.write_file("2"..",".."		".. ModeName.."^"..GammaBinds[idx].."^"..bind.L_Current.."^WHITE^CIE_X^"..ModeRequency.."^"..bind.x_Current.."\n")
		--log.write_file("2"..",".."		".. ModeName.."^"..GammaBinds[idx].."^"..bind.L_Current.."^WHITE^CIE_Y^"..ModeRequency.."^"..bind.y_Current.."\n")
		--log.write_file("2"..",".."		".. ModeName.."^"..GammaBinds[idx].."^"..bind.L_Current.."^WHITE^GAMMA^"..ModeRequency.."^2.2\n")
		--log.write_file("2"..",".."		".. ModeName.."^"..GammaBinds[idx].."^"..bind.L_Current.."^WHITE^EL_I^"..ModeRequency.."^500&600".."\n")
		--log.write_file("2"..",".."		".. ModeName.."^"..GammaBinds[idx].."^"..bind.L_Current.."^WHITE^REGISTER^"..ModeRequency.."^"..bind.Red.."&"..bind.Green.."&"..bind.Blue.."\n")
		--TIME.DELAY(10)
	--end
end

function F_DFS_ELECTRONIC_DATA(Type)--{
	---------------------3------------------------
	log.write_file("2" .. "," .. "	<ELECTRONIC_DATA>\n")
	log.write_file("2" .. "," .. "		<![CDATA[\n")
	log.write_file("2" .. "," .. "		NO^ITEM^PATTERN^FREQUENCY^VALUE_UPPER^VALUE_DEEPER^VALUE^VALUE_RESULT:\n")
	F_DFS_SET_FRAME_RATE(Type)--Type: 0-60HZ;1-90HZ;2-120HZ;3-144HZ;
	for i = 0,1 do
		F_DFS_SET_PATTERN_AND_GET_POWER(i)--i=0 =>WHITE;i=1 =>BLACK;i=2 =>SLEEP_IN;i=3 =>DEEP_SLEEP_IN;
		F_DFS_ELECTRONIC_WRITE()
	end
	log.write_file("2" .. "," .. "		]]>\n")
	log.write_file("2" .. "," .. "	</ELECTRONIC>\n")
end
function GammaDFSFile(panel_id)
	local i
	
	F_DFS_FUN_START(panel_id)
	F_DFS_GET_GAMMA_DATA_START()
	for i=1,8,1 do
		F_DFS_GET_GAMMA_DATA(i)
	end
	F_DFS_GET_GAMMA_DATA_END()
	F_DFS_GET_OPTICS_DATA(300,100)
end

--******************************************************************************
--* Function Name  : Array2Hexstr
--* Description    : integer table change to Hex string
--* Input          : tb(table) (integer table)
--* Input          : sep(string) Connection character, can be default, default "," connection
--* Return         : string
--*******************************************************************************
local function Array2Hexstr(tb, sep)

	local str = ""
	local trantb = {}
	
	for i = 1, #tb do
		trantb[i] =  string.format("0x%02X", tb[i])
	end
	if sep == nil then
		sep = ','
	end
	
	str = table.concat(trantb, sep)
	return str

end

--******************************************************************************
--* Function Name  : Array2Decstr
--* Description    : integer table change to Dec string
--* Input          : tb(table) 
--* Input          : sep(string) 
--* Return         : string
--*******************************************************************************
local function Array2Decstr(tb, sep)

	local str = ""
	local trantb = {}
	
	for i = 1, #tb do
		trantb[i] =  string.format("%d", tb[i])
	end
	if sep == nil then
		sep = ','
	end
	
	str = table.concat(trantb, sep)
	return str

end

--******************************************************************************
--* Function Name  : Array2Floatstr
--* Description    : table change to Float string,Default to four decimal places
--* Input          : tb(table) 
--* Input          : sep(string) 
--* Return         : string
--*******************************************************************************
local function Array2Floatstr(tb, sep)

	local str = ""
	local trantb = {}
	
	for i = 1, #tb do
		trantb[i] =  string.format("%.4f", tb[i])
	end
	if sep == nil then
		sep = ','
	end
	
	str = table.concat(trantb, sep)
	return str


end

--******************************************************************************
--* Function Name  : AsciiChar2Hex
--* Description    : string  change to table for ASCII
--* Input          : str(string)
--* Return         : table
--*******************************************************************************
local function AsciiChar2Hex(str)

	local tb = {}
	for i = 1, #str do 
		tb[i] = string.byte(str, i)
	end
	
	return tb
end

--******************************************************************************
--* Function Name  : AsciiHex2Char
--* Description    : table  change to string table for ASCII
--* Input          : str(string)
--* Return         : table
--*******************************************************************************
local function AsciiHex2Char(tb)

	local str =""
	local chartb = {}
	
	for i = 1,#tb do
		chartb[i] = string.char(tb[i])
	end
	
	return table.concat(chartb)


end

--******************************************************************************
--* Function Name  : CompareTb
--* Description    : table Compare
--* Input          : tb1(table)Compare table 1
--* Input          : tb2(table)Compare table 2
--* Input          : length(number)Compare length
--* Return         : ret(number)(0:OK,1:NG)
--*******************************************************************************
local function CompareTb(tb1, tb2, length)

    if #tb1 < length or #tb2 < length then
        return 1
    end
    for i = 1, length do
        if(tb1[i] ~= tb2[i]) then
            return 1
        end
    end

    return 0

end

--******************************************************************************
--* Function Name  : ConvertDataToUint32
--* Description    : table change to Uint32
--* Input          : tb(table)table
--* Input          : littleendian(boolean)(true:Low in front, high in back, false:Low in back, high in front)
--* Return         : num(number)
--*******************************************************************************
local function ConvertDataToUint32(tb, littleendian)

    if littleendian then
        return tb[1] | tb[2] << 8 | tb[3] << 16 | tb[4] <<24
    else
        return tb[4] | tb[3] << 8 | tb[2] << 16 | tb[1] <<24
    end

end

--******************************************************************************
--* Function Name  : ConvertDataToUint16
--* Description    : table change to  Uint16
--* Input          : tb(table)
--* Input          : littleendian(boolean)(true:Low in front, high in back, false:Low in back, high in front)
--* Return         : tb(table)
--*******************************************************************************
local function ConvertDataToUint16(tb, littleendian)
    if littleendian then
        return tb[1] | tb[2] << 8
    else
        return tb[2] | tb[1] << 8
    end

end

--******************************************************************************
--* Function Name  : ConvertUint32ToData
--* Description    : Uint32 change to table
--* Input          : data(number)
--* Input          : littleendian(boolean)(true:Low in front, high in back, false:Low in back, high in front)
--* Return         : tb(table)
--*******************************************************************************
local function ConvertUint32ToData(data, littleendian)

    local tb ={nil}
    if littleendian then
        tb[1] = data & 0xFF;
        tb[2] = (data >> 8) & 0xFF;
        tb[3] = (data >> 16) & 0xFF;
        tb[4] = (data >> 24) & 0xFF;
    else
        tb[4] = data & 0xFF;
        tb[3] = (data >> 8) & 0xFF;
        tb[2] = (data >> 16) & 0xFF;
        tb[1] = (data >> 24) & 0xFF;
    end

    return tb

end

--******************************************************************************
--* Function Name  : ConvertUint16ToData
--* Description    : Uint16 change to table
--* Input          : data(number)
--* Input          : littleendian(boolean)(true:Low in front, high in back, false:Low in back, high in front)
--* Return         : tb(table)
--*******************************************************************************
local function ConvertUint16ToData(data, littleendian)

    local tb ={nil}
    if littleendian then
        tb[1] = data & 0xFF;
        tb[2] = (data >> 8) & 0xFF;
    else

        tb[2] = data & 0xFF;
        tb[1] = (data >> 8) & 0xFF;
    end

    return tb

end

--******************************************************************************
--* Function Name  : CarveTb
--* Description    : Carve table
--* Input          : tb(table)source  table
--* Input          : startpos(number) index
--* Input          : length(number)length
--* Return         : tb2(table)new table
--*******************************************************************************
local function CarveTb(tb, startpos, length)

    local tb2 = {nil}
    if #tb >= (startpos + length -1) then
        for i = 1, length do
            tb2[i] = tb[i + startpos - 1]
        end
    end

    return tb2

end

--******************************************************************************
--* Function Name  : ConcatTb
--* Description    : Concat table
--* Input          : master Table
--* Input          : slave Table
--* Return         : nil
--*******************************************************************************
local function ConcatTb(mTb, sTb)

  local size = #mTb

  for i = 1, #sTb do
    mTb[size + i] = sTb[i]
  end

  --return mTb

end

--******************************************************************************
--* Function Name  : split
--* Description    : split
--* Input          : str(string),
--* Input          : reps(string),
--* Return         : resultStrList(table)
--*******************************************************************************
local function Split(str, reps)

    local resultStrList = {}

    string.gsub(str,'[^'..reps..']+',function ( w )
            table.insert(resultStrList, w)
        end)

    return resultStrList

end

--******************************************************************************
--* Function Name  : ParseLineOrderStr
--* Description    : Line order string parse(exp:"4321" --> {4,3,2,1})
--* Input          : str(string),Line order string
--* Return         : table (table) Line order table
--*******************************************************************************
local function ParseLineOrderStr(str)

    local tb = {}
    for i = 1, #str do 
        tb[i] = tonumber(string.sub(str, i, i))
    end

    return tb
end

local function file_exists(path)
	
	local file = io.open(path, "rb")
	if file then 
		file:close() 
	end
	
	return file ~= nil
end

--******************************************************************************
--* Function Name  : WriteFile
--* Description    : Write string to File
--* Input          : path(string)
--* Input          : content(string)
--* Return         : ret(number)(0:OK,1:NG)
--*******************************************************************************
local function WriteFile(path, content)

	local file = io.open(path, "a+");
	
	if file then
		if file:write(content) == nil then
			return 1 ;
		end
		io.close(file);
		return 0;
	else
		return 1;
	end

end



function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

function toint(n)
    local s = tostring(n)
    local i,j = s:find('%.')
    if i then
        return tonumber(s:sub(1,i-1))
    else
        return n
    end
end

function dfs_creat(file_id, file_type, file_name)
	LOG.CREAT_FILE(file_id..","..file_type..","..file_name)
end

ADDP = 
	{
		Split				= Split,
		CarveTb				= CarveTb,
		ConcatTb			= ConcatTb,
		CompareTb			= CompareTb,
		WriteFile			= WriteFile,
		Array2Hexstr		= Array2Hexstr,
		Array2Decstr		= Array2Decstr,
		AsciiChar2Hex		= AsciiChar2Hex,
		AsciiHex2Char		= AsciiHex2Char,
		Array2Floatstr		= Array2Floatstr,
		ParseLineOrderStr	= ParseLineOrderStr,
		ConvertDataToUint32	= ConvertDataToUint32,
		ConvertDataToUint16	= ConvertDataToUint16,
		ConvertUint32ToData	= ConvertUint32ToData,
		ConvertUint16ToData	= ConvertUint16ToData,
	}
	
	


function isInRange(a, b, range)
    -- 处理基准值为0的特殊情况
    if a == 0 then
        return b == 0
    end
    
    -- 计算允许的浮动范围
    local minVal = a * (1 - range)
    local maxVal = a * (1 + range)
    
    -- 关键修复：确保 minVal <= maxVal（无论a是正数还是负数）
    if minVal > maxVal then
        minVal, maxVal = maxVal, minVal  -- 交换两个值
    end
    --LOG.INFO(string.format("minVal:%f,maxVal:%f,b:%f",minVal,maxVal,b))
    -- 检查b是否在调整后的范围内
    return b >= minVal and b <= maxVal
end


function F_CLK_OUT(CLK)
	MCU.CHANNEL_LEVEL(2,1,1.80)--gpio 1.8V
	PPMU.PIXEL_EN(1) --CLK_OUT EN
	Pre_Clk=CLK
	DEDP.SI5351_SET(CLK*1000*1000,5)--50M
--DEDP.SI5351_SET(64*1000*1000,5)--64M
end
function F_CLK_CLOSE()

	PPMU.PIXEL_EN(0) --CLK_OUT EN
	DEDP.SI5351_SET(0,0)--50M
--DEDP.SI5351_SET(64*1000*1000,5)--64M
end
function F_CLK_IN_TEST()
	PPMU.PIXEL_IN(1)--CLK_OUT EN
	local Real_Clk1 = DEDP.GET_FRQ(1)/1000000
	local Real_Clk2 = DEDP.GET_FRQ(2)/1000000
	if (isInRange(Pre_Clk, Real_Clk1*2, 0.1)) then
		LOG.DEBUG(string.format("CLK_IN1_TEST-->PASS,CLK_OUT-->%.3fMHZ CLK_IN-->%.3fMHZ",Pre_Clk,Real_Clk1*2))
	else
		LOG.ERROR(string.format("CLK_IN1_TEST-->NG,CLK_OUT-->%.3fMHZ CLK_IN-->%.3fMHZ",Pre_Clk,Real_Clk1*2))
	end
	
	if (isInRange(Pre_Clk, Real_Clk2*8, 0.1)) then
		LOG.DEBUG(string.format("CLK_IN2_TEST-->PASS,CLK_OUT-->%.3fMHZ CLK_IN-->%.3fMHZ",Pre_Clk,Real_Clk2*8))
	else
		LOG.ERROR(string.format("CLK_IN2_TEST-->NG,CLK_OUT-->%.3fMHZ CLK_IN-->%.3fMHZ",Pre_Clk,Real_Clk2*8))
	end
--DEDP.SI5351_SET(64*1000*1000,5)--64M

end

function F_MIPI_WRITE(reg,data)
    local ret = 0;

    local regTab = {(reg >> 8) & 0xff,reg  & 0xff}
    local dataValue = data
    local dataTab = {data  & 0xff,(data >> 8) & 0xff,(data >> 16) & 0xff,(data >> 24) & 0xff}

    DMIPI.REG_W(0x29,regTab[2],regTab[1],0x0d,0x00,table.unpack(dataTab))
    println("DMIPI.REG_W(0x29,0x%02X,0x%02X,0x0d,0x00,0x%02X,0x%02X,0x%02X,0x%02X)",regTab[2],regTab[1],table.unpack(dataTab))

    return ret;
end
function F_READ_FOR_MIPI(addr, length)
	DMIPI.LP()
    -- 参数校验
    if length <= 0 or length > 255 then
        error("Invalid length (1-255 bytes supported)")
    end

    -- 发送读取命令（addr: 32bit, length: 1-4 bytes）
    DMIPI.REG_W(0x29, 0xFF, 
        (addr >> 24) & 0xFF,  -- addr[31:24]
        (addr >> 16) & 0xFF,  -- addr[23:16]
        addr & 0xFF,          -- addr[7:0] (注：原代码缺少 addr[15:8]!)
        length                -- 读取长度
    )

    -- 可选延迟（根据硬件需求调整）
    -- TIME.DELAY(200)

    -- 读取数据（返回字节数组）
    local read_data = DMIPI.REG_R((addr >> 8) & 0xFF, length)

    -- 动态拼接返回值（根据length决定数据宽度）
    local result = 0
    for i = 1, length do
        result = result | ((read_data[i] & 0xFF) << (8 * (i - 1)))
    end

    -- 调试日志（可选）
    -- LOG.INFO(string.format("Read 0x%X: 0x%X (length=%d)", addr, result, length))

    return result  -- 返回数值（非G_value）
end

function Set_Color_IIC_SlaveAddr(color)
	if color == "Red" then
		SLAVE_ADDR = IIC_SLV_R
	elseif color == "Green" then
		SLAVE_ADDR = IIC_SLV_G
	elseif color =="Blue" then
		SLAVE_ADDR = IIC_SLV_B
	end 
	IIC_CONFIG.init_default()
end
--Set_Color("G")
--function Set_Color(color)
	--Color = color == nil  and Color or color
	----Set_Color_Power(PowerCfg_B)
	--local results_table={}
	
	--if Color =="R" then
		--Color = "Red"
		--Power.ValueSetting.AVEE1 = -1800
		----Set_Color_Test_Item(Color)
		--IIC_CONFIG.SLAVE_ADDR =IIC_SLV_R
		
		--table.insert(results_table,Power.ValueSetting.AVEE1)
		--table.insert(results_table,IIC_CONFIG.SLAVE_ADDR)
		----Set_Color_IIC_SlaveAddr(Color)
	--elseif Color =="G" then
		--Color = "Green"
		--Power.ValueSetting.AVEE1 = -2500
		--IIC_CONFIG.SLAVE_ADDR =IIC_SLV_G
		
		--table.insert(results_table,Power.ValueSetting.AVEE1)
		--table.insert(results_table,IIC_CONFIG.SLAVE_ADDR)
		----Set_Color_Power(PowerCfg_G)
		----Set_Color_Test_Item(Color)
		----Set_Color_IIC_SlaveAddr(Color)
	--elseif Color == "B" then
		--Color = "Blue"
		--Power.ValueSetting.AVEE1 = -2500
		--IIC_CONFIG.SLAVE_ADDR =IIC_SLV_B
		
		--table.insert(results_table,Power.ValueSetting.AVEE1)
		--table.insert(results_table,IIC_CONFIG.SLAVE_ADDR)
		----Set_Color_Test_Item(Color)
		----Set_Color_IIC_SlaveAddr(Color)
	----else
		----Color = "Blue"
		----Power.ValueSetting.AVEE1 = -2500
		------Set_Color_Test_Item(Color)
		----Set_Color_IIC_SlaveAddr(Color)
	--end
	--IIC_CONFIG.init_default()
	--local json_data = cjson.encode(results_table)
	--LOG.INFO(json_data)
    --return 0,json_data
--end
--20260122 add
--Set_Color("R")
function Set_Color(color)
	Color = color == nil  and Color or color
	--Set_Color_Power(PowerCfg_B)
	local results_table={}
	
	if Color =="R" then
		Color = "Red"
		Power.ValueSetting.AVEE1 = -1800
		--Set_Color_Test_Item(Color)
		IIC_CONFIG.SLAVE_ADDR =IIC_SLV_R
		I3C_CONFIG.SLAVE_ADDR =IIC_SLV_R
		DAC_CTRL_value=0x50111
		table.insert(results_table,Power.ValueSetting.AVEE1)
		table.insert(results_table,IIC_CONFIG.SLAVE_ADDR)
		--Set_Color_IIC_SlaveAddr(Color)
	elseif Color =="G" then
		Color = "Green"
		Power.ValueSetting.AVEE1 = -3000
		IIC_CONFIG.SLAVE_ADDR =IIC_SLV_G
		I3C_CONFIG.SLAVE_ADDR =IIC_SLV_G
		DAC_CTRL_value=0x50011
		table.insert(results_table,Power.ValueSetting.AVEE1)
		table.insert(results_table,IIC_CONFIG.SLAVE_ADDR)
	elseif Color == "B" then
		Color = "Blue"
		Power.ValueSetting.AVEE1 = -3000
		IIC_CONFIG.SLAVE_ADDR =IIC_SLV_B
		I3C_CONFIG.SLAVE_ADDR =IIC_SLV_B
		DAC_CTRL_value=0x50011
		table.insert(results_table,Power.ValueSetting.AVEE1)
		table.insert(results_table,IIC_CONFIG.SLAVE_ADDR)
	end
	
	LOG.INFO(TEST_MODE) 
	if TEST_MODE == "CP2" then
		IIC_CONFIG.SLAVE_ADDR =IIC_SLV_Defaul
		I3C_CONFIG.SLAVE_ADDR =IIC_SLV_Defaul  
	end
	
	IIC_SLAVE_ADDR_TAB[2]=IIC_CONFIG.SLAVE_ADDR 
	IIC_CONFIG.init_default()
	local json_data = cjson.encode(results_table)
	LOG.INFO(json_data)
    return 0,json_data
end


function get_module_path()
	--Return the current path of the lua module 
	module_path = SYS.GET_PATH()
	return 0,module_path
end

function CombineEfuseToHexStr(byteArray)
    if type(byteArray) ~= "table" then
        LOG.ERROR("CombineEfuseToHexStr错误：输入不是表类型")
        return nil
    end
    if #byteArray == 0 then
        LOG.ERROR("CombineEfuseToHexStr错误：输入字节数组为空")
        return nil
    end

    local hexStr = ""  -- 存储最终拼接的十六进制字符串
    local isValid = true

    for i = 1, #byteArray do
        -- 提取当前字节值并校验（必须是0-255的有效字节）
        local byteVal = tonumber(byteArray[i])
        if not byteVal or byteVal < 0 or byteVal > 255 then
            LOG.ERROR(string.format("CombineEfuseToHexStr错误：第%d个元素无效（值=%s，需0-255）", 
                i, tostring(byteArray[i])))
            isValid = false
            break
        end
        hexStr = string.format("%02X", byteVal)..hexStr 
    end

    if not isValid then
        return nil
    else
        return "0X" .. hexStr
    end
end

function ExtractBitsFromHex(hexStr, startBit, endBit)
    -- 参数类型检查
    if type(hexStr) ~= "string" then
        LOG.ERROR("ExtractBitsFromHex错误：hexStr不是字符串")
        return nil
    end
    if type(startBit) ~= "number" or type(endBit) ~= "number" then
        LOG.ERROR("ExtractBitsFromHex错误：startBit或endBit不是数字")
        return nil
    end

    -- 去除可能的0x/0X前缀
    local hex = hexStr:gsub("^[0xX][xX]?", "")
    if hex == "" then
        LOG.ERROR("ExtractBitsFromHex错误：hexStr为空")
        return nil
    end

    -- 补全为偶数位（每两个字符一个字节）
    if #hex % 2 == 1 then
        hex = "0" .. hex
    end

    -- 将十六进制字符串转换为字节数组（高位在前）
    local bytes = {}
    for i = 1, #hex, 2 do
        local byteStr = hex:sub(i, i+1)
        local byteVal = tonumber(byteStr, 16)
        if not byteVal then
            LOG.ERROR(string.format("ExtractBitsFromHex错误：无效十六进制字符 %s", byteStr))
            return nil
        end
        table.insert(bytes, byteVal)
    end

    local totalBits = #bytes * 8
    -- 校验位范围
    if startBit < 0 or endBit < 0 or startBit > endBit or endBit >= totalBits then
        LOG.ERROR(string.format("ExtractBitsFromHex错误：位范围无效 startBit=%d endBit=%d totalBits=%d", startBit, endBit, totalBits))
        return nil
    end

    -- 构建提取位的二进制字符串（从高位到低位，即 endBit → startBit）
    local bitStr = ""
    for bitPos = endBit, startBit, -1 do
        -- 计算字节索引：字节数组高位在前，bitPos=0 对应最后一个字节
        local byteIdx = #bytes - math.floor(bitPos / 8)
        local bitOff = bitPos % 8
        local bitVal = (bytes[byteIdx] >> bitOff) & 1
        bitStr = bitStr .. tostring(bitVal)
    end

    -- 检查提取的位数是否超过Lua数字的精确表示范围（最大53位）
    local bitLen = #bitStr
    --if bitLen > 53 then
        --LOG.ERROR(string.format("ExtractBitsFromHex错误：提取的位数 %d 超过53位，可能精度丢失", bitLen))
        --return nil
    --end

    -- 将二进制字符串转换为数字
    local num = tonumber(bitStr, 2)
    if not num then
        LOG.ERROR("ExtractBitsFromHex错误：二进制转换失败")
        return nil
    end

    return num
end
