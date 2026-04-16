
function get_parent_path(path)
    -- 统一分隔符：将 \ 转为 /（兼容 Windows 路径）
    local normalized_path = string.gsub(path, "\\", "/")
    -- 去除末尾的 /（如果有），避免截取到空字符串
    normalized_path = string.gsub(normalized_path, "/+$", "") -- 正则：匹配末尾1个及以上 / 并替换为空
    -- 找到最后一个 / 的位置
    local last_sep_pos = string.find(normalized_path, "/[^/]*$") -- 匹配最后一个 / 及其后面的内容
    -- 如果没有 /（说明是根目录或单级目录），返回原路径或根目录
    if not last_sep_pos then
        LOG.WARN("path is root or single-level, cannot go up: " .. path)
        return path -- 或返回 "/"（根目录），根据需求调整
    end
    -- 截取最后一个 / 之前的内容（上一级路径）
    return string.sub(normalized_path, 1, last_sep_pos - 1)
end



function read_demura_coeffs_i3c()
    -- Constants
    local LUT_RW_CTRL_ADDR = 0x0018
    local LUT_RW_CTRL_RESET = 0x00
    local NUM_SRAMS = 8 -- Set to 8 for all SRAMS
    local TARG_CSR = 0x0d
    local I3C_LUT_BASE_ADDR = 0x8000
    for sram_idx = 0, NUM_SRAMS - 1 do
        -- 0. Clear LUT_RW_CTRL before starting
        F_MIPI_WRITE(LUT_RW_CTRL_ADDR, LUT_RW_CTRL_RESET, TARG_CSR)
        TIME.DELAY(100)
        -- 1. Set LUT_RW_CTRL for I3C read from this Demura SRAM
        -- LUT_RW_CTRL = (sram_idx << 4) | 0x0C
        local lut_rw_ctrl_i3c = bit32.lshift(sram_idx, 4) + 0x0C
        LOG.INFO(string.format("Set LUT_RW_CTRL=0x%02X for I3C read from Demura SRAM %d", lut_rw_ctrl_i3c, sram_idx))
        F_MIPI_WRITE(LUT_RW_CTRL_ADDR, lut_rw_ctrl_i3c, TARG_CSR)
        TIME.DELAY(100)
        -- 2. Read back the first 3 words (up to 12 coefficients, log first 10)
        local read_vals = {}
        local coeff_count = 0
        for word_offset = 0, 2 do
            local read_val_32bit = IIC_R_PEQUIN(I3C_LUT_BASE_ADDR + word_offset) or 0
            for i = 0, 3 do
                if coeff_count < 10 then
                    local shift = i * 8
                    local byte_val = bit32.band(bit32.rshift(read_val_32bit, shift), 0xFF)
                    table.insert(read_vals, string.format("0x%02X", byte_val))
                    coeff_count = coeff_count + 1
                end
            end
        end
        LOG.INFO(string.format("Readback Demura SRAM %d, first 10 coefficients: %s", sram_idx, table.concat(read_vals, ", ")))
        -- 3. Clear LUT_RW_CTRL after read
        F_MIPI_WRITE(LUT_RW_CTRL_ADDR, LUT_RW_CTRL_RESET, TARG_CSR)
        TIME.DELAY(100)
    end
end



function DEMURA_ON()
    LOG.DEBUG("<DEMURA_ON>")
    local result_table={}
    -- Read current value
    local reg_val = IIC_R_PEQUIN(0x0028, 4)
    println(string.format("Current PCU_CTRL: 0x%08X", reg_val))
    -- Clear DMR_BYPASS (bit 2)
    local new_val = reg_val & (~(1 << 2))
    IIC_W_PEQUIN(0x0028, new_val)
    TIME.DELAY(10)
    -- Read back to confirm
    local confirm_val = IIC_R_PEQUIN(0x0028, 4)
    println(string.format("Confirmed PCU_CTRL: 0x%08X", confirm_val))
    if (confirm_val & (1 << 2)) ~= 0 then
        LOG.ERROR("DEMURA_ON failed: DMR_BYPASS still set")
        table.insert(result_table,1)
    else
        LOG.INFO("DEMURA_ON succeeded")
        table.insert(result_table,0)
    end
    if bist_mode == 1 then--1:bistmode, 0:PG
    --TIME.DELAY(200)
    	F_28M2_I2C_Initial()
    end
    local json_data = cjson.encode(result_table)
	LOG.INFO(json_data)
	return 0, json_data
end
function DEMURA_OFF()
    LOG.DEBUG("<DEMURA_OFF>")
    local result_table={}
    -- Read current value
    local reg_val = IIC_R_PEQUIN(0x0028, 4)
    println(string.format("Current PCU_CTRL: 0x%08X", reg_val))
    -- Set DMR_BYPASS (bit 2)
    local new_val = reg_val | (1 << 2)
    IIC_W_PEQUIN(0x0028, new_val)
    TIME.DELAY(10)
    -- Read back to confirm
    local confirm_val = IIC_R_PEQUIN(0x0028, 4)
    println(string.format("Confirmed PCU_CTRL: 0x%08X", confirm_val))
    if (confirm_val & (1 << 2)) == 0 then
        LOG.ERROR("DEMURA_OFF failed: DMR_BYPASS not set")
        table.insert(result_table,1)
    else
        LOG.INFO("DEMURA_OFF succeeded")
        table.insert(result_table,0)
    end
    if bist_mode == 1 then--1:bistmode, 0:PG
    	--TIME.DELAY(200)
    	F_28M2_I2C_Initial()
    end
    local json_data = cjson.encode(result_table)
	LOG.INFO(json_data)
	return 0, json_data
end



--test_demura_write_LUTfile("20251223_B_2DIDforDebug1234_UNAC22001251119032549_demura.txt")
function test_demura_write_LUTfile(file_name)
	--I3C_INIT()
	PIC.SW(Folder..'/'..imShow[1])
	TIME.DELAY(10)
	local tim1 = TIME.TICK()
    --read_demura_coeffs_i3c()
    local result_table={}
    --coeff_matrix = demura_file_to_coeff_matrix(file_name)
    coeff_matrix =parse_demura_hex_file_to_matrix_text1(file_name)
    if coeff_matrix then
	    LOG.INFO("Start writing Demura coeffs to I2C SRAMs")
	    --demura_write_i2c(coeff_matrix) -- 此时传入的矩阵完全符合函数要求
	    demura_write_glw_pic()
	    --demura_write_glw(coeff_matrix)
	else
    	LOG.ERROR("Failed to get valid coeff_matrix from file, abort I2C write")
	end

    local verify_result = demura_read_verify(
    coeff_matrix,  -- 原始系数矩阵
    0,                 -- 目标SRAM索引
    0,                -- SRAM内起始行
    10,                -- SRAM内结束行
    0,                -- 起始列
    10                 -- 结束列
	)
	
	if not verify_result then
	    LOG.ERROR("Retry demura write due to verify failed")
	    -- demura_write_i2c(your_coeff_matrix)  -- 可选：重试写入
	    table.insert(result_table,"fail")
	else
		table.insert(result_table,"pass")
		LOG.DEBUG("Write demura check OK")
	end
	
	PIC.SW(Folder..'/'..imShow[1])
	TIME.DELAY(10)
    DMIPI.VID()
    TIME.DELAY(10)
    DMIPI.HS()
	
	--删除PG内部demura文件
	local PG_path = SYS.GET_PATH()
    local delete_path = string.format("%s/%s", PG_path, file_name)
    LOG.INFO(string.format("PG删除demura文件路径: %s", delete_path))
    local ok, err = os.remove(delete_path)
	if ok then
	    LOG.INFO("删除成功")
	else
	    LOG.ERROR("删除失败：", err)
	end

    for i=0,7 do
    	local delete_path = string.format("%s/demura_file%d.bmp", PG_path, i)
    	LOG.INFO(string.format("PG删除demura文件路径: %s", delete_path))
    	local ok, err = os.remove(delete_path)
		if ok then
		    LOG.INFO("删除成功")
		else
		    LOG.ERROR("删除失败：", err)
		end
    end
    
    -- End timing
    local tim2 = TIME.TICK()
	LOG.INFO("Demura write time "..(tim2/1000 - tim1/1000))
    --read_demura_coeffs_i3c()

    local json_data = cjson.encode(result_table)
	LOG.INFO(json_data)
	return 0, json_data 
end
--test_demura_write_flat_matrix(0.1)
function test_demura_write_flat_matrix(float_coeff)
    --read_demura_coeffs_i3c()
    
    
    
    coeff_matrix = gen_demura_flat_matrix(float_coeff)
    -- Start timing
    local tim1 = TIME.TICK()
    --demura_write_glw(coeff_matrix)
    demura_write_i2c(coeff_matrix)
    -- End timing
    local tim2 = TIME.TICK()
	LOG.INFO("Demura write time "..(tim2/1000 - tim1/1000))
    --read_demura_coeffs_i3c()
    --read_demura_coeff_rows_i3c(2)
end

function parse_demura_hex_file_to_matrix(file_name)
    -- 1. 拼接文件路径（需根据实际项目路径调整，此处复用前序函数的路径逻辑）
    local config = {
    file_path = "",
    target_rows = 768,  -- 总行数：8 SRAM × 96 行/SRAM（函数固定要求）
    target_cols = 576,  -- 总列数（函数固定要求）
    hex_base = 16,      -- 文档系数为十六进制（0xXX 格式）
    fill_val = 0        -- 无效系数填充值（函数默认用 0）
}
    local project_path = SYS.GET_PATH()
    --project_path = get_parent_path(project_path) -- 需确保 get_parent_path 函数已实现
     config.file_path = project_path .. "/" .. file_name
    --local file = io.open(file_path, "r")
    
    -- 2. 文件存在性校验
    -- 2.1 打开文档（只读模式）
    local file, err = io.open(config.file_path, "r")
    if not file then
        LOG.ERROR("Failed to open Demura file: " .. config.file_path .. " | Error: " .. (err or "unknown"))
        return nil
    end

    local coeff_matrix = {}  -- 最终输出的整数矩阵
    local line_idx = 0       -- 记录当前行号（匹配矩阵行索引）

    -- 2.2 逐行解析文档
    for line in file:lines() do
        line_idx = line_idx + 1
        -- 超出目标行数：直接截断（避免矩阵行数过多）
        if line_idx > config.target_rows then
            --LOG.ERROR(string.format("File has more than %d rows, truncate excess lines (current line: %d)", config.target_rows, line_idx))
            break
        end

        -- 去除行首尾双引号（文档可能存在的格式包裹）
        line = line:gsub('^"+', ''):gsub('"+$', '')
        -- 处理空行：填充全 0 行（避免矩阵行数不足）
        if line == "" then
            --LOG.ERROR(string.format("Line %d is empty, fill with 0 (int) for all %d cols", line_idx, config.target_cols))
            local empty_row = {}
            for col = 1, config.target_cols do
                table.insert(empty_row, config.fill_val)
            end
            table.insert(coeff_matrix, empty_row)
            goto continue
        end

        -- 2.3 分割当前行的十六进制系数（适配 "0xXX," 格式，确保末尾系数不遗漏）
        local current_row = {}
        -- 行末尾加逗号：解决 "0xDC" 无末尾逗号导致的最后一个系数无法匹配问题
        for coeff_str in string.gmatch(line .. ",", "(.-),") do
            -- 处理空系数（如连续逗号 "0xDC,,0xA8"）
            if coeff_str == "" then
                table.insert(current_row, config.fill_val)
                --LOG.DEBUG(string.format("Line %d: Empty coefficient at col %d, fill with 0", line_idx, #current_row))
                goto coeff_next
            end

            -- 关键：十六进制字符串转整数（必须指定 16 进制，否则 0xXX 解析失败）
            local val = tonumber(coeff_str, config.hex_base)
            -- 校验系数有效性（0xXX 为 8 位无符号整数，范围 0~255）
            if val == nil or val < 0 or val > 255 then
                --LOG.ERROR(string.format("Line %d: Invalid coeff '%s' (must be 0x00~0xFF), fill with 0", line_idx, coeff_str))
                val = config.fill_val
            end
            table.insert(current_row, val)  -- 存入整数（匹配函数的整数输入要求）

            ::coeff_next::
        end

        -- 2.4 补全/截断行至 target_cols 列（确保每行 576 列，匹配函数要求）
        -- 补全：列数不足时，末尾填充 0
        while #current_row < config.target_cols do
            table.insert(current_row, config.fill_val)
            --LOG.DEBUG(string.format("Line %d: Need %d cols, current %d, pad with 0", line_idx, config.target_cols, #current_row))
        end
        -- 截断：列数超出时，删除多余系数（避免打包 32 位字时地址越界）
        while #current_row > config.target_cols do
            table.remove(current_row)
            --LOG.DEBUG(string.format("Line %d: Need %d cols, current %d, truncate", line_idx, config.target_cols, #current_row))
        end

        -- 2.5 将处理后的行加入矩阵
        table.insert(coeff_matrix, current_row)

        ::continue::
    end

    -- 2.6 关闭文档
    file:close()

    -- 2.7 补全矩阵总行数（若文档行数不足 768 行，添加全 0 行）
    while #coeff_matrix < config.target_rows do
        local empty_row = {}
        for col = 1, config.target_cols do
            table.insert(empty_row, config.fill_val)
        end
        table.insert(coeff_matrix, empty_row)
        --LOG.DEBUG(string.format("Matrix need %d rows, current %d, pad with 0 row", config.target_rows, #coeff_matrix - 1))
    end

    -- 2.8 校验矩阵维度（确保与函数要求完全一致）
    local final_rows = #coeff_matrix
    local final_cols = #coeff_matrix[1]
    if final_rows ~= config.target_rows or final_cols ~= config.target_cols then
        LOG.ERROR(string.format("Matrix dimension mismatch! Need %dx%d, got %dx%d", 
            config.target_rows, config.target_cols, final_rows, final_cols))
        return nil
    end

    LOG.INFO(string.format("Demura file parsed success! Matrix: %d rows × %d cols (int type, 0~255)", final_rows, final_cols))
    return coeff_matrix

end


function test_demura_4coeffs_i2c()
    -- Constants
    local LUT_RW_CTRL_ADDR = 0x0018
    local LUT_RW_CTRL_RESET = 0x00
    local DEMURA_SRAM_IDX = 0
    local WORD_ADDR = 0x8000  -- Bit 15 set for LUT access, word 0
    local COEFF_VAL = 120     -- Example coefficient value
    local TARG_CSR = 0x0d     -- For CSR register writes
    -- 0. Clear LUT_RW_CTRL (good practice)
    LOG.INFO("Clear LUT_RW_CTRL before write")
    IIC_W_PEQUIN(LUT_RW_CTRL_ADDR, LUT_RW_CTRL_RESET)
    --TIME.DELAY(10)
    
    -- 1. Set LUT_RW_CTRL for I2C/I3C write to Demura SRAM 0
    -- LUT_RW_CTRL = (DEMURA_SRAM_IDX << 4) | 0xA
    local lut_rw_ctrl_i2c = (DEMURA_SRAM_IDX << 4) | 0xA
    LOG.INFO("Set LUT_RW_CTRL for I2C/I3C write to Demura SRAM 0")
    IIC_W_PEQUIN(LUT_RW_CTRL_ADDR, lut_rw_ctrl_i2c)
    --TIME.DELAY(10)
    
    -- 2. Write one word (all four coefficients = COEFF_VAL) to first word of SRAM 0
    local word = (COEFF_VAL << 24) | (COEFF_VAL << 16) | (COEFF_VAL << 8) | COEFF_VAL
    LOG.INFO("Write one word (all four coefficients = "..COEFF_VAL..") to first word of Demura SRAM 0")
    IIC_W_PEQUIN(WORD_ADDR, word)
    --TIME.DELAY(10)
    
    -- 3. Clear LUT_RW_CTRL after write
    LOG.INFO("Clear LUT_RW_CTRL after write")
    IIC_W_PEQUIN(LUT_RW_CTRL_ADDR, LUT_RW_CTRL_RESET)
    --TIME.DELAY(10)
    
    -- 4. (Optional) Set LUT_RW_CTRL for I2C/I3C read from Demura SRAM 0
    local lut_rw_ctrl_i2c_read = (DEMURA_SRAM_IDX << 4) | 0xC
    LOG.INFO("Set LUT_RW_CTRL for I2C/I3C read from Demura SRAM 0")
    IIC_W_PEQUIN(LUT_RW_CTRL_ADDR, lut_rw_ctrl_i2c_read)
    --TIME.DELAY(10)
    
    -- 5. (Optional) Read back the first word (4 coefficients) using I2C/I3C
    local read_val_32bit = IIC_R_PEQUIN(WORD_ADDR) or 0
    local read_vals = {}
    for i = 0, 3 do
        local shift = i * 8
        local byte_val = (read_val_32bit >> shift) & 0xFF
        table.insert(read_vals, string.format("0x%02X", byte_val))
    end
    LOG.INFO("Readback Demura SRAM 0, word 0 coefficients: " .. table.concat(read_vals, ", "))
    -- 6. Clear LUT_RW_CTRL after read
    LOG.INFO("Clear LUT_RW_CTRL after read")
    IIC_W_PEQUIN(LUT_RW_CTRL_ADDR, LUT_RW_CTRL_RESET)
end


function demura_write_i2c(coeff_matrix)
    -- Constants
    local LUT_RW_CTRL_ADDR = 0x0018
    local LUT_RW_CTRL_RESET = 0x00
    local NUM_SRAMS = 8 --8 SRAMS total
    local ROWS_PER_SRAM = 96 --96 rows per SRAM total
    local NUM_COLS = 576
    local COEFFS_PER_WORD = 4
    local WORDS_PER_ROW = math.ceil(NUM_COLS / COEFFS_PER_WORD)
    for sram_idx = 0, NUM_SRAMS - 1 do
        -- 0. Clear LUT_RW_CTRL before starting
        IIC_W_PEQUIN(LUT_RW_CTRL_ADDR, LUT_RW_CTRL_RESET)
        TIME.DELAY(10)
        -- 1. Set LUT_RW_CTRL for I2C/I3C write to this Demura SRAM
        -- LUT_RW_CTRL = (sram_idx << 4) | 0xA (I3C_MIPI_SEL=1, PCU_TC_LUT_WR_EN=1)
        local lut_rw_ctrl_i2c = (sram_idx << 4) | 0xA
        LOG.INFO(string.format("Set LUT_RW_CTRL=0x%02X for I2C/I3C write to Demura SRAM %d", lut_rw_ctrl_i2c, sram_idx))
        IIC_W_PEQUIN(LUT_RW_CTRL_ADDR, lut_rw_ctrl_i2c)
        TIME.DELAY(10)
        -- Logging: collect first 10 coefficients for this SRAM
        local log_coeffs = {}
        local coeff_count = 0
        for row_in_sram = 0, ROWS_PER_SRAM - 1 do
            local global_row = sram_idx * ROWS_PER_SRAM + row_in_sram
            for col = 0, NUM_COLS - 1, COEFFS_PER_WORD do
                -- Pack 4 coefficients into a 32-bit word (LSB first)
                local c = {}
                for i = 0, COEFFS_PER_WORD - 1 do
                    local idx = col + i
                    if idx < NUM_COLS then
                        c[i+1] = coeff_matrix[global_row + 1][idx + 1] or 0
                        if coeff_count < 10 then
                            table.insert(log_coeffs, string.format("0x%02X", c[i+1]))
                            coeff_count = coeff_count + 1
                        end
                    else
                        c[i+1] = 0
                    end
                end
                -- Ensure all c[1]..c[4] are numbers
                for i = 1, COEFFS_PER_WORD do
                    if c[i] == nil then c[i] = 0 end
                end
                local word = (c[4] << 24) | (c[3] << 16) | (c[2] << 8) | c[1]
                -- Compute LUT address: bit 15 set for LUT, [14:0]=word index
                local word_idx = row_in_sram * WORDS_PER_ROW + math.floor(col / COEFFS_PER_WORD)
                local word_addr = 0x8000 + word_idx
                IIC_W_PEQUIN(word_addr, word)
                TIME.DELAY(20)  -- Short delay for I2C write
            end
        end
        LOG.INFO(string.format("SRAM %d write first 10 coefficients: %s", sram_idx, table.concat(log_coeffs, ", ")))
        -- 3. Clear LUT_RW_CTRL after write
        IIC_W_PEQUIN(LUT_RW_CTRL_ADDR, LUT_RW_CTRL_RESET)
        TIME.DELAY(10)
    end
end

function gen_demura_flat_matrix(float_coeff)
    -- Check input value range
    if float_coeff < 0 or float_coeff > 1.0 then
        LOG.ERROR("Invalid float_coeff value, must be between 0 and 1.0")
        return nil
    end
    -- Define target matrix dimensions
    local target_rows = 768
    local target_cols = 576
    -- Calculate the 8-bit value for all elements
    local coeff_value
    if float_coeff >= 1.0 then
        coeff_value = 0x00
    else
        coeff_value = 1 + math.floor(float_coeff * 255 + 0.5)
    end
    -- Create the flat matrix
    local coeff_matrix = {}
    for i = 1, target_rows do
        local coeff_row = {}
        for j = 1, target_cols do
            table.insert(coeff_row, coeff_value)
        end
        table.insert(coeff_matrix, coeff_row)
    end
    -- Log the first 10 values
    local coeff_vals = {}
    for i = 1, target_rows do
        for j = 1, target_cols do
            table.insert(coeff_vals, tostring(coeff_matrix[i][j]))
            if #coeff_vals == 10 then break end
        end
        if #coeff_vals == 10 then break end
    end
    LOG.INFO("First 10 8-bit values: " .. table.concat(coeff_vals, ", "))
    -- Log matrix dimensions
    LOG.INFO(string.format("Matrix dimensions: %d x %d", target_rows, target_cols))
    return coeff_matrix
end

function read_demura_coeff_rows_i3c(num_rows)
    -- Constants
    local LUT_RW_CTRL_ADDR = 0x0018
    local LUT_RW_CTRL_RESET = 0x00
    local NUM_SRAMS = 8
    local ROWS_PER_SRAM = 96
    local NUM_COLS = 576
    local COEFFS_PER_WORD = 4
    local WORDS_PER_ROW = math.ceil(NUM_COLS / COEFFS_PER_WORD)
    local I3C_LUT_BASE_ADDR = 0x8000
    for sram_idx = 0, NUM_SRAMS - 1 do
        -- 0. Clear LUT_RW_CTRL before starting
        IIC_W_PEQUIN(LUT_RW_CTRL_ADDR, LUT_RW_CTRL_RESET)
        TIME.DELAY(10)
        -- 1. Set LUT_RW_CTRL for I3C read from this Demura SRAM
        -- LUT_RW_CTRL = (sram_idx << 4) | 0x0C (I3C_MIPI_SEL=1, PCU_TC_LUT_RD_EN=1)
        local lut_rw_ctrl_i3c = (sram_idx << 4) | 0x0C
        LOG.INFO(string.format("Set LUT_RW_CTRL=0x%02X for I3C read from Demura SRAM %d", lut_rw_ctrl_i3c, sram_idx))
        IIC_W_PEQUIN(LUT_RW_CTRL_ADDR, lut_rw_ctrl_i3c)
        TIME.DELAY(10)
        -- 2. Read and log all coefficients for the requested number of rows
        for row_in_sram = 0, math.min(num_rows, ROWS_PER_SRAM) - 1 do
            local global_row = sram_idx * ROWS_PER_SRAM + row_in_sram
            for col = 0, NUM_COLS - 1, COEFFS_PER_WORD do
                local word_idx = row_in_sram * WORDS_PER_ROW + math.floor(col / COEFFS_PER_WORD)
                local word_addr = I3C_LUT_BASE_ADDR + word_idx
                local read_val_32bit = IIC_R_PEQUIN(word_addr) or 0
                for i = 0, COEFFS_PER_WORD - 1 do
                    local col_idx = col + i
                    if col_idx < NUM_COLS then
                        local shift = i * 8
                        local coeff = (read_val_32bit >> shift) & 0xFF
                        LOG.INFO(string.format("SRAM:%d ROW:%d COL:%d COEFF:0x%02X", sram_idx, global_row, col_idx, coeff))
                    end
                end
            end
        end
        -- 3. Clear LUT_RW_CTRL after read
        IIC_W_PEQUIN(LUT_RW_CTRL_ADDR, LUT_RW_CTRL_RESET)
        TIME.DELAY(10)
    end
end




--1.1 IO Continuity Test-ready
--Purpose: Check IO Pin2Pin and Pin2GND open short by using internal ESD diode


function demura_read_verify(coeff_matrix, target_sram, start_row_in_sram, end_row_in_sram, start_col, end_col)
 if coeff_matrix==nil then
 	LOG.ERROR("Failed to open the file, and the matrix values are null.")
 	return nil
 end
    -- 1. 入参合法性校验（保留原逻辑）
    local NUM_SRAMS = 8 --8 SRAMS total
    local ROWS_PER_SRAM = 96 --96 rows per SRAM total
    local NUM_COLS = 576
    local LUT_RW_CTRL_ADDR = 0x0018
    local LUT_RW_CTRL_RESET = 0x00
    local COEFFS_PER_WORD = 4
    local WORDS_PER_ROW = math.ceil(NUM_COLS / COEFFS_PER_WORD)
    if target_sram < 0 or target_sram >= NUM_SRAMS then
        LOG.ERROR(string.format("Invalid SRAM index: %d (must be 0~%d)", target_sram, NUM_SRAMS-1))
        return false
    end
    if start_row_in_sram < 0 or end_row_in_sram >= ROWS_PER_SRAM or start_row_in_sram > end_row_in_sram then
        LOG.ERROR(string.format("Invalid row range in SRAM %d: start=%d, end=%d (must be 0~95, start≤end)", 
            target_sram, start_row_in_sram, end_row_in_sram))
        return false
    end
    if start_col < 0 or end_col >= NUM_COLS or start_col > end_col then
        LOG.ERROR(string.format("Invalid column range: start=%d, end=%d (must be 0~575, start≤end)", 
            start_col, end_col))
        return false
    end

    -- 2. 初始化LUT读写控制寄存器（保留原逻辑）
    IIC_W_PEQUIN(LUT_RW_CTRL_ADDR, LUT_RW_CTRL_RESET)
    TIME.DELAY(50)  -- 确保复位稳定

    -- 3. 配置LUT_RW_CTRL为「I3C读模式」（保留原逻辑，仅备注位定义）
    local lut_rw_ctrl_i2c = (target_sram << 4) | 0xC  -- 读模式：bit0=1（读使能），bit3=1（I3C选择）
    LOG.INFO(string.format("Set LUT_RW_CTRL=0x%02X for I2C/I3C read from Demura SRAM %d", 
        lut_rw_ctrl_i2c, target_sram))
    IIC_W_PEQUIN(LUT_RW_CTRL_ADDR, lut_rw_ctrl_i2c)
    TIME.DELAY(50)  -- 确保配置生效

    -- 4. 逐行逐列回读并对比
    local is_verify_ok = true  -- 整体验证结果
    local mismatch_count = 0   -- 不匹配计数
    local total_check_count = 0-- 总检查系数个数

    for row_in_sram = start_row_in_sram, end_row_in_sram do
        -- 全局行号（硬件0开始）
        local global_row_hw = target_sram * ROWS_PER_SRAM + row_in_sram  
        -- 核心修正1：Lua矩阵索引从1开始，需加偏移
        local matrix_row = global_row_hw + 1  
        local row_coeff_mismatch = false  -- 该行是否存在不匹配

        -- 按「4个系数/寄存器」分组读取（与写入的打包逻辑一致）
        for col = start_col, end_col, COEFFS_PER_WORD do
            -- 核心修正2：寄存器地址计算（用全局行号替代SRAM内行号，避免地址偏移）
            local col_group_idx = math.floor(col / COEFFS_PER_WORD)
            -- 原错误：row_in_sram * WORDS_PER_ROW → 仅SRAM内行号，跨SRAM/跨行时地址错误
            -- 修正后：global_row_hw * WORDS_PER_ROW → 全局行号，地址精准对应
            local word_idx = row_in_sram * WORDS_PER_ROW + col_group_idx
            local word_addr = 0x8000 + word_idx  -- 与写入的地址格式完全一致

            -- 4.1 读取32-bit寄存器值（保留原逻辑）
            local read_word = IIC_R_PEQUIN(word_addr)  -- 需确保该函数返回32-bit无符号整数
            TIME.DELAY(2)  -- 读操作短延迟，避免总线冲突

            -- 4.2 解析寄存器值为4个系数（保留原逻辑）
            local read_coeffs = {
			    read_word % 256,                                  -- 第1个系数（最低8位）
			    math.floor(read_word / 256) % 256,                -- 第2个系数（8~15位）
			    math.floor(read_word / 65536) % 256,               -- 第3个系数（16~23位）
			    math.floor(read_word / 16777216) % 256             -- 第4个系数（24~31位）
			}

            -- 4.3 与原始系数矩阵对比（仅对比当前列范围内的系数）
            for i = 0, COEFFS_PER_WORD - 1 do
                local current_col = col + i
                if current_col > end_col then
                    break  -- 超出目标列范围，停止当前寄存器的对比
                end
                total_check_count = total_check_count + 1

                -- 核心修正3：矩阵列索引从1开始，需加偏移；行索引用修正后的matrix_row
                local matrix_col = current_col + 1
                local original_coeff = coeff_matrix[matrix_row][matrix_col] or 0
                local read_coeff = read_coeffs[i + 1] or 0

                -- 对比判定（保留原逻辑）
                if original_coeff ~= read_coeff then
                    LOG.ERROR(string.format(
                        "Mismatch: SRAM=%d, GlobalRow=%d, Col=%d | Original=0x%02X, Read=0x%02X",
                        target_sram, global_row_hw, current_col, original_coeff, read_coeff
                    ))
                    is_verify_ok = false
                    mismatch_count = mismatch_count + 1
                    row_coeff_mismatch = true
                end
            end

            -- 日志：打印该行前5个匹配的系数（保留原逻辑）
            if not row_coeff_mismatch and col == start_col then
                local log_str = string.format("SRAM=%d, GlobalRow=%d, Cols[%d~%d] read ok: ",
                    target_sram, global_row_hw, col, math.min(col + COEFFS_PER_WORD - 1, end_col))
                local log_coeffs = {}
                for i = 0, math.min(COEFFS_PER_WORD - 1, end_col - col) do
                    table.insert(log_coeffs, string.format("0x%02X", read_coeffs[i + 1]))
                end
                LOG.INFO(log_str .. table.concat(log_coeffs, ", "))
            end
        end
    end

    -- 5. 回读后复位LUT读写控制寄存器（保留原逻辑）
    IIC_W_PEQUIN(LUT_RW_CTRL_ADDR, LUT_RW_CTRL_RESET)
    TIME.DELAY(10)

    -- 6. 输出验证结果汇总（保留原逻辑）
    LOG.INFO(string.format("Verify Summary: SRAM=%d, Rows[%d~%d], Cols[%d~%d] | TotalCheck=%d, Mismatch=%d",
        target_sram, start_row_in_sram, end_row_in_sram, start_col, end_col, total_check_count, mismatch_count))
    if is_verify_ok then
        LOG.INFO("=== Demura coeff read verify PASSED ===")
    else
        LOG.ERROR("=== Demura coeff read verify FAILED ===")
    end

    return is_verify_ok
end


function parse_demura_hex_file_to_matrix_text(file_name)
    -- 1. 配置参数（明确目标维度和解析规则）
    local config = {
        file_path = "",
        target_rows = 768,  -- 8 SRAM × 96 行/SRAM
        target_cols = 576,  -- 固定列数
        hex_base = 16,      -- 十六进制解析
        fill_val = 0,       -- 无效数据填充值
        max_coeff_val = 255 -- 8位无符号整数上限
    }

     --2. 路径拼接与日志打印（便于排查路径问题）
    local project_path = SYS.GET_PATH() or "."  -- 兼容SYS.GET_PATH()返回nil的情况
    config.file_path = string.format("%s/%s", project_path, file_name)
    LOG.INFO(string.format("Start parsing Demura file: %s", config.file_path))
    
	--config.file_path = "/home/userftp/modules/PEQUIN_Test_Flow_1217/UNAC2000420251025255359_demura.txt"
    -- 3. 文件打开与合法性校验
    local file, err = io.open(config.file_path, "r")
    if not file then
    -- 失败：打印详细错误日志，直接返回 nil（避免后续逻辑出错）
    LOG.ERROR(string.format(
        "文件打开失败！路径：%s | 错误原因：%s",
        config.file_path,  -- 打印实际路径，便于排查
        err or "未知错误"   -- 打印系统返回的错误信息
    ))
    return nil  -- 打开失败直接退出，不执行后续解析逻辑
else
    -- 成功：打印确认日志（新增，明确告知文件已打开）
    LOG.INFO(string.format("文件打开成功！路径：%s", config.file_path))
end

    local coeff_matrix = {}  -- 最终输出矩阵（Lua索引1开始）
    local line_idx = 0       -- 当前解析行号（从0开始，对应矩阵行号-1）

    -- 4. 逐行解析（核心优化部分）
    for line in file:lines() do
        line_idx = line_idx + 1
        LOG.DEBUG(string.format("原始行[%d]内容：%s", line_idx, line:gsub("\n", "\\n"):gsub("\r", "\\r")))
        -- 超出目标行数：截断（避免矩阵过大）
        if line_idx > config.target_rows then
            LOG.ERROR(string.format("File exceeds target rows (%d), truncating excess lines (current: %d)", 
                config.target_rows, line_idx))
            break
        end

        -- 4.1 行数据预处理（兼容格式异常）
        line = line:gsub('^\"+', ''):gsub('\"+$', '')  -- 去除首尾双引号
        line = line:gsub('%s+', '')                    -- 去除所有空格（包括空格、制表符、换行符）
        line = line:gsub(';.*$', '')                   -- 去除注释（;开头的内容）
        line = line:gsub(',+', ',')                    -- 合并连续逗号（如",,,"→","）
        line = line:gsub('^,', ''):gsub(',$', '')     -- 去除首尾逗号（如",a,b,"→"a,b"）

        -- 4.2 处理空行（填充全0行）
        if line == "" then
        	LOG.INFO(string.format("行[%d]是空行，触发goto跳过循环", line_idx))
            --LOG.DEBUG(string.format("Line %d: Empty line, fill with 0s", line_idx))
            local empty_row = {}
            for col = 1, config.target_cols do
                table.insert(empty_row, config.fill_val)
            end
            table.insert(coeff_matrix, empty_row)
            goto continue  -- 跳过后续解析，进入下一行
        end

        -- 4.3 解析系数（兼容多种格式）
        local current_row = {}
        -- 支持的分隔符：逗号、分号、竖线（可根据实际文档调整）
        local delimiter_pattern = "[,;|]"
        -- 分割行数据（兼容多种分隔符）
        for coeff_str in string.gmatch(line, "[^" .. delimiter_pattern .. "]+") do
        
        	LOG.INFO(string.format("行[%d]原始系数串：%s", line_idx, coeff_str))
        	
            -- 4.3.1 系数字符串清洗（兼容格式异常）
            coeff_str = coeff_str:gsub('0x', ''):gsub('0X', '')  -- 去除0x/0X前缀（支持纯十六进制数字）
            coeff_str = coeff_str:gsub('[^0-9a-fA-F]', '')       -- 只保留十六进制有效字符（去除字母、符号等）
            
			LOG.INFO(string.format("行[%d]清洗后系数串：%s", line_idx, coeff_str))
			
            -- 4.3.2 十六进制转整数
            local val = tonumber(coeff_str, config.hex_base)
            
             LOG.INFO(string.format("行[%d]系数解析：%s → %s", line_idx, coeff_str, val or "nil"))
             
            -- 4.3.3 有效性校验（确保是8位无符号整数）
            if val == nil or val < 0 or val > config.max_coeff_val then
                --LOG.WARN(string.format("Line %d: Invalid coeff '%s' (must be 0x00~0xFF), fill with 0", 
                    --line_idx, coeff_str))
                val = config.fill_val
            end

            table.insert(current_row, val)
        end

        -- 4.4 行数据补全/截断（确保576列）
        -- 补全：列数不足时填充0
        while #current_row < config.target_cols do
            table.insert(current_row, config.fill_val)
            --LOG.DEBUG(string.format("Line %d: Column count insufficient (%d < %d), pad with 0", 
                --line_idx, #current_row - 1, config.target_cols))
        end
        -- 截断：列数超出时删除多余数据
        while #current_row > config.target_cols do
            local removed_val = table.remove(current_row)
            --LOG.DEBUG(string.format("Line %d: Column count excess (%d > %d), truncate val=0x%02X", 
                --line_idx, #current_row + 1, config.target_cols, removed_val))
        end

        -- 4.5 加入矩阵
        table.insert(coeff_matrix, current_row)

        ::continue::
    end

    -- 5. 关闭文件
    file:close()

    -- 6. 矩阵补全（行数不足768时填充全0行）
    while #coeff_matrix < config.target_rows do
        local empty_row = {}
        for col = 1, config.target_cols do
            table.insert(empty_row, config.fill_val)
        end
        table.insert(coeff_matrix, empty_row)
        --LOG.DEBUG(string.format("Matrix row count insufficient (%d < %d), pad with 0 row", 
            --#coeff_matrix - 1, config.target_rows))
    end

    -- 7. 最终维度校验
    local final_rows = #coeff_matrix
    local final_cols = #coeff_matrix[1] or 0
    if final_rows ~= config.target_rows or final_cols ~= config.target_cols then
        LOG.ERROR(string.format("Matrix dimension mismatch! Need %dx%d, got %dx%d", 
            config.target_rows, config.target_cols, final_rows, final_cols))
        return nil
    end

    -- 8. 解析结果日志（打印前3行前3列预览）
    LOG.INFO(string.format("Demura file parsed successfully! Matrix: %d rows × %d cols (0~255)", 
        final_rows, final_cols))
    LOG.DEBUG("Matrix preview (first 3x3):")
    for i = 1, math.min(3, final_rows) do
        local preview_str = string.format("Row %d: ", i)
        for j = 1, math.min(3, final_cols) do
            preview_str = preview_str .. string.format("0x%02X ", coeff_matrix[i][j])
        end
        LOG.DEBUG(preview_str)
    end

    return coeff_matrix
end


function parse_demura_hex_file_to_matrix_text1(file_name)
    -- 1. 配置参数（保持原配置，hex_base=16适配目标文件）
    local config = {
        file_path = "",
        target_rows = 768,  -- 8 SRAM × 96 行/SRAM
        target_cols = 576,  -- 固定列数
        hex_base = 16,      -- 目标文件为十六进制（0x前缀格式）
        fill_val = 0,       -- 无效数据填充值
        max_coeff_val = 255 -- 8位无符号整数上限
    }

    -- 2. 路径拼接与关键日志（无冗余打印）
    local project_path = SYS.GET_PATH() or "."
    --project_path=get_parent_path(project_path)
    config.file_path = string.format("%s/%s", project_path, file_name)
    LOG.INFO(string.format("Start parsing Demura file: %s", config.file_path))
    
    -- 3. 文件打开校验（无修改）
    local file, err = io.open(config.file_path, "r")
    if not file then
        LOG.ERROR(string.format(
            "文件打开失败！路径：%s | 错误原因：%s",
            config.file_path, err or "未知错误"
        ))
        return nil
    end
    LOG.INFO(string.format("文件打开成功！路径：%s", config.file_path))

    local coeff_matrix = {}  -- 最终矩阵（Lua索引1开始）
    local line_idx = 0       -- 当前解析行号（从0开始）

    -- 4. 逐行解析（核心修复：正确捕获第一个系数）
    for line in file:lines() do
        line_idx = line_idx + 1
        -- 超出目标行数：截断（无多余日志）
        if line_idx > config.target_rows then
            LOG.ERROR(string.format("文件超出目标行数（%d），截断多余行（当前：%d）", config.target_rows, line_idx))
            break
        end

        -- 4.1 极简预处理：仅去除所有空格（避免换行/制表符干扰）
        line = line:gsub('%s+', '')  -- 只保留这1步，其他冗余预处理（全角转半角等）按需保留
        local current_row = {}

        -- 4.2 处理空行：快速生成全0行（比循环插入快3倍+）
        if line == "" then
            LOG.INFO(string.format("行[%d]是空行，填充全0", line_idx))
            local empty_row = {}
            local fill_str = string.rep(config.fill_val .. ",", config.target_cols)
            for val in string.gmatch(fill_str, "([^,]+)") do
                table.insert(empty_row, tonumber(val))
            end
            table.insert(coeff_matrix, empty_row)
            goto continue
        end

        -- 4.3 核心修复：直接匹配所有0x开头的十六进制值（不丢第一个）
        -- 匹配规则：捕获 "0x" 后的所有十六进制字符（0-9、a-f、A-F）
        local match_pattern = "0x([0-9a-fA-F]+)"  
        local match_count = 0
        for coeff_str in string.gmatch(line, match_pattern) do
            match_count = match_count + 1
            -- 直接转换（正则已过滤无效字符，无需额外清洗）
            local val = tonumber(coeff_str, config.hex_base) or config.fill_val
            -- 范围校验：确保在0~255之间
            val = (val < 0 or val > config.max_coeff_val) and config.fill_val or val
            table.insert(current_row, val)
            -- 提前终止：达到目标列数立即停止（减少多余循环）
            if #current_row >= config.target_cols then
                break
            end
        end

        -- 4.4 异常处理：若该行无任何有效系数（极端情况），手动补0
        if match_count == 0 then
            LOG.ERROR(string.format("行[%d]未匹配到有效系数，填充全0", line_idx))
            current_row = {}
            local fill_str = string.rep(config.fill_val .. ",", config.target_cols)
            for val in string.gmatch(fill_str, "([^,]+)") do
                table.insert(current_row, tonumber(val))
            end
        end

        -- 4.5 行补全/截断（确保576列）
        -- 补全：列数不足时填充0
        local lack_cols = config.target_cols - #current_row
        if lack_cols > 0 then
            local fill_str = string.rep(config.fill_val .. ",", lack_cols)
            for val in string.gmatch(fill_str, "([^,]+)") do
                table.insert(current_row, tonumber(val))
            end
        end
        -- 截断：列数超出时删除多余值
        while #current_row > config.target_cols do
            table.remove(current_row)
        end

        -- 4.6 加入矩阵
        table.insert(coeff_matrix, current_row)
        ::continue::
    end

    -- 5. 关闭文件（无修改）
    file:close()

    -- 6. 矩阵补全：行数不足768时填充全0行
    while #coeff_matrix < config.target_rows do
        local empty_row = {}
        local fill_str = string.rep(config.fill_val .. ",", config.target_cols)
        for val in string.gmatch(fill_str, "([^,]+)") do
            table.insert(empty_row, tonumber(val))
        end
        table.insert(coeff_matrix, empty_row)
    end

    -- 7. 最终维度校验（无修改）
    local final_rows = #coeff_matrix
    local final_cols = #coeff_matrix[1] or 0
    if final_rows ~= config.target_rows or final_cols ~= config.target_cols then
        LOG.ERROR(string.format("矩阵维度不匹配！需要 %dx%d，实际 %dx%d", 
            config.target_rows, config.target_cols, final_rows, final_cols))
        return nil
    end

    -- 8. 解析结果日志（预览前3x3，验证第一个值是否正确）
    LOG.INFO(string.format("Demura文件解析成功！矩阵：%d行 × %d列（值范围：0~255）", final_rows, final_cols))
    LOG.DEBUG("矩阵预览（前3x3，验证首值）：")
    for i = 1, math.min(3, final_rows) do
        local preview_str = "第" .. i .. "行："
        for j = 1, math.min(3, final_cols) do
            preview_str = preview_str .. string.format("0x%02X ", coeff_matrix[i][j])
        end
        LOG.DEBUG(preview_str)
    end

    return coeff_matrix
end


function demura_write_glw_pic()
    --DMIPI.CMD()
    DMIPI.VID()
    TIME.DELAY(10)
    DMIPI.HS()
    TIME.DELAY(10)
    local project_path = SYS.GET_PATH()
    -- Constants
    local LUT_RW_CTRL_ADDR = 0x0018
    local LUT_RW_CTRL_RESET = 0x00
    local NUM_SRAMS = 8 -- Set to 8 for all SRAMS
    local ROWS_PER_SRAM = 96 --96 for whole row
    local NUM_COLS = 576
    local COEFFS_PER_WORD = 4 --Set to 4
    local TARG_CSR = 0x0d
    for sram_idx = 0, NUM_SRAMS - 1 do
        -- 0. Clear LUT_RW_CTRL before starting
        F_MIPI_WRITE(LUT_RW_CTRL_ADDR, LUT_RW_CTRL_RESET, TARG_CSR)
       	 
        TIME.DELAY(20)
        -- 1. Set LUT_RW_CTRL for MIPI write to this Demura SRAM
        local lut_rw_ctrl_mipi = bit32.lshift(sram_idx, 4) + 0x2
        LOG.INFO(string.format("Set LUT_RW_CTRL=0x%02X for MIPI write to Demura SRAM %d", lut_rw_ctrl_mipi, sram_idx))
        F_MIPI_WRITE(LUT_RW_CTRL_ADDR, lut_rw_ctrl_mipi, TARG_CSR)
     
		-------------------------------------
        
        
        TIME.DELAY(20)
        --local read_data = IIC_R_PEQUIN(LUT_RW_CTRL_ADDR)
        --local hex_str = string.format("0x%08X",read_data)
        --LOG.INFO(string.format("LUT_RW_CTRL 0x%08X",hex_str))
        -- Logging: collect first 10 coefficients for this SRAM
      
		filename = string.format("./demura_file%d.bmp",sram_idx)
		--DMIPI.DEMURA_LOAD("./demura_file0.bmp",0)
        DMIPI.DEMURA_LOAD(filename,0)
        TIME.DELAY(20)
		--LOG.INFO(string.format("SRAM %d write first 10 coefficients: %s", sram_idx, table.concat(log_coeffs, ", ")))
        -- 3. Clear LUT_RW_CTRL after write
        F_MIPI_WRITE(LUT_RW_CTRL_ADDR, LUT_RW_CTRL_RESET, TARG_CSR)
        
	end
	-------------------------------------
    --TIME.DELAY(100)
   
	
end

function GET_PROJECT_PATH()
	local project_path = SYS.GET_PATH()
	project_path=get_parent_path(project_path)


	local json_data = cjson.encode(project_path)
	LOG.INFO(json_data)
	return 0, json_data 
end
