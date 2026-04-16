--Public Sub VPG_9POINT_FRC(Optional l_DacWord As Long = 0x7F, Optional l_LutValue As Long = 0x3F, Optional b_RegWriteOnly As Boolean = True)

   --  Broadcast I3C Static Address
     --I3C_Broadcast_PEQA(nWirePA_FRC)
 --Clocks
 


--[[
函数名称：VPG_9POINT_FRC
功能描述：Pequin 芯片 9点运动校准配置，通过配置时钟、DAC、LUT、时序发生器（TMG）、PCU 等模块，
          生成9个校准方块并点亮像素阵列（PA）
参数说明：
  - l_DacWord（可选）：DAC 控制字，默认值 0x7F（十进制 127）
  - l_LutValue（可选）：LUT[0] 配置值，默认值 0x3F（十进制 63）
  - b_RegWriteOnly（可选）：寄存器仅写标志，默认值 true（暂未在逻辑中使用，保留参数兼容性）
全局依赖：
  - gb_isDacCalPerformed：全局布尔变量，标记是否已执行 DAC 校准
  - gsl_DACcalLoopExit(addr)：全局函数，读取 DAC 校准退出码（addr 为地址参数，此处固定传 0）
  - IIC_W_PEQUIN(regAddr, regVal)：寄存器写入函数（需确保底层已实现 I3C 写入逻辑）
  - TIME.DELAY(delaySec)：硬件延迟函数（delaySec 为延迟时间，单位：秒）
]]
function VPG_9POINT_FRC(l_DacWord, l_LutValue, b_RegWriteOnly)
	--POWER_ON_IDLE_POWER()
    -- 初始化可选参数（Lua 无默认参数语法，需手动判断赋值）
    l_DacWord = l_DacWord or 0x7F  -- DAC_WORD 默认值：0x7F
    l_LutValue = l_LutValue or 0x3F-- LUT[0] 默认值：0x3F
    b_RegWriteOnly = b_RegWriteOnly ~= nil and b_RegWriteOnly or true  -- 仅写标志默认 true

    -- 1. I3C 静态地址广播（初始化从设备通信）
    --I3C_Broadcast_PEQA(nWirePA_FRC)  -- nWirePA_FRC 为 FRC 通道的 I3C 线数参数（需提前定义）

    -- 2. 时钟模块配置（CLK_CTRL）
    IIC_W_PEQUIN(0x00, 0x109000)  -- 寄存器地址 0x00，配置值 0x109000

    -- 3. 阴极/带隙模块配置（ANLG_CTRL）
    IIC_W_PEQUIN(0xCC, 0x01)      -- 寄存器地址 0xCC，使能阴极/带隙电路

    -- 4. VPG（视频模式生成器）- 数据配置
    IIC_W_PEQUIN(0x24, 0x04)      -- DISP_CTRL：显示控制配置
    IIC_W_PEQUIN(0x98, 0x10)      -- VID_SRC_SEL：视频源选择（选择 VPG 输出）
    IIC_W_PEQUIN(0xA0, 0x240300)  -- VPG_SIZE：VPG 输出尺寸配置
    IIC_W_PEQUIN(0xA4, 0x2FF000)  -- VPG_ROW_CFG：VPG 行参数配置
    IIC_W_PEQUIN(0xA8, 0x23F000)  -- VPG_COL_CFG：VPG 列参数配置
    IIC_W_PEQUIN(0xAC, 0x140000)  -- VPG_PORCHES：VPG 前后沿配置

    -- 5. VPG - 图案配置
    IIC_W_PEQUIN(0xB0, 0xFFFF)    -- VPG_DATA：VPG 输出数据（全1图案）
    IIC_W_PEQUIN(0xB4, 0x10001)   -- VPG_BAR_CHK_CFG：VPG 条带检查配置

    -- 6. DAC（数模转换器）配置
    IIC_W_PEQUIN(0xDC, l_DacWord) -- DAC_WORD：写入传入/默认的 DAC 控制字
    -- 根据是否执行过 DAC 校准，选择 DAC_CTRL 配置值
    if gb_isDacCalPerformed then
        local l_DacCtrl = 0x13 + gsl_DACcalLoopExit(0) * (2 ^ 16)  -- 校准值计算：低16位 0x13 + 高16位校准偏移
        IIC_W_PEQUIN(0xD8, l_DacCtrl)  -- DAC_CTRL：写入校准后的值（替代原硬编码 0x70003）
        -- 备注：需通过 Meta 工具验证 VBB20 电压设置是否需根据校准值调整
    else
        -- 未校准场景：使用硬编码默认值（Rocket 批次芯片 eFuse 为初始状态，无预存校准值）
        IIC_W_PEQUIN(0xD8, 0x50013)  -- DAC_CTRL：硬编码默认值 0x50013
    end

    -- 7. LUT（查找表）配置
    IIC_W_PEQUIN(0x18, 0xC9)      -- LUT_WR_CTRL：LUT 写控制（使能写操作）
    IIC_W_PEQUIN(0x68, 0x01)      -- PAI_SETUP：像素阵列接口（PAI）初始化配置
    IIC_W_PEQUIN(0x60, 0x80)      -- PAI_LUT_XB_CTRL：PAI LUT 交叉bar控制
    IIC_W_PEQUIN(0x8000, l_LutValue) -- LUT[0]：写入传入/默认的 LUT 值
    IIC_W_PEQUIN(0x18, 0xC0)      -- LUT_WR_CTRL：禁用 LUT 写操作（锁定配置）

    -- 8. 时序发生器（TMG）配置
    IIC_W_PEQUIN(0x74, 0x1087A23)-- TMG_ISYNC_CFG：内部同步配置（原注释备选值 0x11087A23）
    IIC_W_PEQUIN(0x78, 0x01)      -- TMG_VSYNC_2_ISYNC_CFG：场同步（VSYNC）转内部同步配置
    IIC_W_PEQUIN(0x7C, 0x30000A5)-- TMG_RSYNC_CFG：行同步（RSYNC）配置
    IIC_W_PEQUIN(0x80, 0x3000000)-- TMG_PA_ROW_CTRL：像素阵列（PA）行控制
    IIC_W_PEQUIN(0x70, 0x03)      -- TMG_CTRL：时序发生器主控制（使能基础时序）

    -- 9. PCU（像素控制单元）配置
    IIC_W_PEQUIN(0x38, 0xFFFFFFFF)-- PCU_N_M_VERT_MASK：垂直方向 N/M 掩码（全使能）
    IIC_W_PEQUIN(0x48, 0xFFFFFFFF)-- PCU_N_M_HORZ_MASK：水平方向 N/M 掩码（全使能）
    IIC_W_PEQUIN(0x34, 0xF0F)     -- PCU_N_M_VERT：垂直方向 N/M 系数配置
    IIC_W_PEQUIN(0x44, 0xF0F)     -- PCU_N_M_HORZ：水平方向 N/M 系数配置

    --=========================================================================
    -- 10. 9个校准方块（SQR 1~SQR 9）配置：每个方块独立配置行/列控制 + 写入暂存缓冲区（SB）
    -- 通用说明：
    --  - LED_ROW_CTRL（0x2C）：LED 行控制（定义方块行范围）
    --  - PCU_N_M_VERT_START（0x3C）：垂直方向起始位置
    --  - LED_COLUMN_CTRL（0x30）：LED 列控制（定义方块列范围）
    --  - PCU_N_M_HORZ_START（0x4C）：水平方向起始位置
    --  - VPG_CTRL（0x9C）：VPG 控制（0x3 表示写暂存缓冲区）
    --  - 延迟 100 秒：确保 VPG 配置完全写入暂存缓冲区
    --=========================================================================

    -- SQR 1：第1个方块配置
    IIC_W_PEQUIN(0x2C, 0x1F00B0)  -- LED_ROW_CTRL：行参数
    IIC_W_PEQUIN(0x3C, 0xB00F)    -- PCU_N_M_VERT_START：垂直起始位置
    IIC_W_PEQUIN(0x30, 0x1F0080)  -- LED_COLUMN_CTRL：列参数（原注释备选值 0x2400000）
    IIC_W_PEQUIN(0x4C, 0x800F)    -- PCU_N_M_HORZ_START：水平起始位置
    IIC_W_PEQUIN(0x9C, 0x03)      -- VPG_CTRL：写暂存缓冲区
    TIME.DELAY(100)               -- 等待写入完成

    -- SQR 2：第2个方块配置
    IIC_W_PEQUIN(0x2C, 0x1F00B0)
    IIC_W_PEQUIN(0x3C, 0xB00F)
    IIC_W_PEQUIN(0x30, 0x1F0110)
    IIC_W_PEQUIN(0x4C, 0x1100F)
    IIC_W_PEQUIN(0x9C, 0x03)
    TIME.DELAY(100)

    -- SQR 3：第3个方块配置
    IIC_W_PEQUIN(0x2C, 0x1F00B0)
    IIC_W_PEQUIN(0x3C, 0xB00F)
    IIC_W_PEQUIN(0x30, 0x1F01A0)
    IIC_W_PEQUIN(0x4C, 0x1A00F)
    IIC_W_PEQUIN(0x9C, 0x03)
    TIME.DELAY(100)

    -- SQR 4：第4个方块配置
    IIC_W_PEQUIN(0x2C, 0x1F0170)
    IIC_W_PEQUIN(0x3C, 0x1700F)
    IIC_W_PEQUIN(0x30, 0x1F0080)
    IIC_W_PEQUIN(0x4C, 0x800F)
    IIC_W_PEQUIN(0x9C, 0x03)
    TIME.DELAY(100)

    -- SQR 5：第5个方块配置（中心方块）
    IIC_W_PEQUIN(0x2C, 0x1F0170)
    IIC_W_PEQUIN(0x3C, 0x1700F)
    IIC_W_PEQUIN(0x30, 0x1F0110)
    IIC_W_PEQUIN(0x4C, 0x1100F)
    IIC_W_PEQUIN(0x9C, 0x03)
    TIME.DELAY(100)

    -- SQR 6：第6个方块配置
    IIC_W_PEQUIN(0x2C, 0x1F0170)
    IIC_W_PEQUIN(0x3C, 0x1700F)
    IIC_W_PEQUIN(0x30, 0x1F01A0)
    IIC_W_PEQUIN(0x4C, 0x1A00F)
    IIC_W_PEQUIN(0x9C, 0x03)
    TIME.DELAY(100)

    -- SQR 7：第7个方块配置
    IIC_W_PEQUIN(0x2C, 0x1F0230)
    IIC_W_PEQUIN(0x3C, 0x2300F)
    IIC_W_PEQUIN(0x30, 0x1F0080)
    IIC_W_PEQUIN(0x4C, 0x800F)
    IIC_W_PEQUIN(0x9C, 0x03)
    TIME.DELAY(100)

    -- SQR 8：第8个方块配置
    IIC_W_PEQUIN(0x2C, 0x1F0230)
    IIC_W_PEQUIN(0x3C, 0x2300F)
    IIC_W_PEQUIN(0x30, 0x1F0110)
    IIC_W_PEQUIN(0x4C, 0x1100F)
    IIC_W_PEQUIN(0x9C, 0x03)
    TIME.DELAY(100)

    -- SQR 9：第9个方块配置
    IIC_W_PEQUIN(0x2C, 0x1F0230)
    IIC_W_PEQUIN(0x3C, 0x2300F)
    IIC_W_PEQUIN(0x30, 0x1F01A0)
    IIC_W_PEQUIN(0x4C, 0x1A00F)
    IIC_W_PEQUIN(0x9C, 0x03)
    TIME.DELAY(100)

    --=========================================================================
    -- 11. 像素阵列（PA）激活：将暂存缓冲区（SB）数据写入 PA 并点亮
    --=========================================================================
    IIC_W_PEQUIN(0x70, 0x40000003)  -- TMG_CTRL：使能暂存缓冲区写 PA
    TIME.DELAY(100)               -- 等待 SB 到 PA 的数据传输完成（短延迟）
    IIC_W_PEQUIN(0x70, 0x80000001)  -- TMG_CTRL：激活像素阵列（点亮）
    TIME.DELAY(100)                -- 等待阵列稳定点亮（确保校准图案正常显示）
end

-- （可选）函数调用示例：使用默认参数执行 9点校准
-- VPG_9POINT_FRC()

-- （可选）函数调用示例：自定义 DAC 控制字和 LUT 值
-- VPG_9POINT_FRC(0x80, 0x40, true)