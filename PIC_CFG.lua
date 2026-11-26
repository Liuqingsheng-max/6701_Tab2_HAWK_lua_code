imShow = {
	"DPHY_HS01_W255.bmp",
	"DPHY_HS02_W0.bmp",
	"DPHY_HS03_CK64.bmp",
	"DPHY_HS04_QUADRANT.bmp",
	--"W.bmp",
	--"checkerboard.bmp",
	--"W255.bmp",
	--"W0.bmp",
	--"dot.bmp",
	--"1by12-1.bmp",
	--"1by12-2.bmp",
	--"1by12-3.bmp",
	--"1by12-4.bmp",
	--"1by12-5.bmp",
	--"1by12-6.bmp",
	--"1by12-7.bmp",
	--"1by12-8.bmp",
	--"1by12-9.bmp",
	--"1by12-10.bmp",
	--"1by12-11.bmp",
	--"1by12-12.bmp",
	--"gamma.bmp",
	--"Chessboard_Neg.bmp",
	--"Chessboard_Pos.bmp",
	--"CrossHair_Image.bmp",
	--"Chessboard.bmp",

}


Folder = "./textures_dphy_hs/" 

imIndex = 1
LOG.INFO(imIndex)
bist_mode = 1	--1:bistmode, 0:PG

function Next()
	if imIndex >= #imShow then
		imIndex = 1
	else
		imIndex = imIndex + 1
	end
	if bist_mode == 1 then
		
		bitset_mode_swich(imIndex)
	else
		PIC.SW(Folder..'/'..imShow[imIndex])
		--DMIPI.CMDA()
		--PIC.SW(Folder..'/'..imShow[imIndex])
		LOG.DEBUG("PIC.SW("..Folder..imShow[imIndex]..")")
	end
	return imIndex
end


function Prev()
	if imIndex <= 1 then
		imIndex = #imShow
	else
		imIndex = imIndex - 1
	end
	if bist_mode == 1 then
		bitset_mode_swich(imIndex)
	else
		PIC.SW(Folder..'/'..imShow[imIndex])
		--DMIPI.CMDA()
		--PIC.SW(Folder..'/'..imShow[imIndex])
		LOG.DEBUG("PIC.SW("..Folder..imShow[imIndex]..")")
	end
	return imIndex
end


function Sw_by_index(index)
	if bist_mode == 0 then--1:bistmode, 0:PG
	
		PIC.SW(Folder..'/'..imShow[index])
	else
		bitset_mode_swich(index)
	end
	--LOG.DEBUG("PIC.SW("..Folder..imShow[index]..")")
end


function  FirstPicture()
	if bist_mode == 0 then--1:bistmode, 0:PG
		--IIC_W_Tab2(0xBD, {0x00}) -- Set to 45hz
		PIC.SW(Folder..'/'..imShow[1])
		--PIC.SW(Folder..'/'..imShow[1])
		LOG.DEBUG("PIC.SW("..Folder..imShow[1]..")")
	else
		--PWM_timing_from_Sapien_092326()
		--IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
		--IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
		--IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key
		
		--IIC_W_Tab2(0xBD, {0x10}) -- Set to 90hz
		--IIC_W_Tab2(0xf6, {0x00,0x1,00}) --GBLBC to default value  tk-10/16

		--IIC_W_Tab2(0xE5,{0x00,0x2A,0x80,0x01,0x54,0x00,0x40, 0x00,0x80  ,0x01,0x00,0x00,0x00})  --PWM Timing Gen
		--IIC_W_Tab2(0xE4,{0x00,0x07,0x07,0x0b,0x14,0x00})  --PWM Timing to 400ns
		--IIC_W_Tab2(0xf4,{0x1})


		--IIC_W_Tab2(0xFA, {0x91,0x00})  -- Select Red  tk-10/18
		--IIC_W_Tab2(0xFA, {0x92,0x00})  -- Select Green tk-10/18
		--IIC_W_Tab2(0xFA, {0x93,0x00})  -- Select Blue tk-10/18
		-- PWM_timing_debug_9square()
		
		IIC_W_Tab2(0xF0, {0x5a,0x5a}) -- level2 key
		IIC_W_Tab2(0xF1, {0x5a,0x5a}) --OTP key
		IIC_W_Tab2(0xFC, {0x5a,0x5a}) --3rd key
		IIC_W_Tab2(0xBD, {0x10}) -- Set to 90hz
		IIC_W_Tab2(0xf6,{0x0,0x0,0x5f}) -- Pixel current
		--IIC_W_Tab2(0xf6, {0x00,0x1,00})
		IIC_W_Tab2(0xE5,{0x00,0x2A,0x80,0x01,0x54,0x00,0x40, 0x00,0x80 ,0x01,0x00,0x00,0x00})
		--PWM Timing Gen, PWM_TYP_MULTI_VAL
		IIC_W_Tab2(0xE4,{0x00,0x07,0x07,0x0b,0x14,0x00}) --PWM Timing to 400ns
		IIC_W_Tab2(0xe3,{0x1})
		IIC_W_Tab2(0xfb,{0x07,0x27,0xe5,0x01,0x03, 0x00,0x10 ,0x00,0x00}) -- Duty cycle
		TIME.DELAY(100)
		IIC_W_Tab2(0xf4,{0x1})
		
		 -- PWM_timing_debug_case(0)
		VPG_Off()
		
		--VPG_SetFlatField(255)  --display on first picture  flat field

	end
end

function FirstPicture_Post_Initial()
	if bist_mode == 0 then--1:bistmode, 0:PG
		PIC.SW(Folder..'/'..imShow[2])
		--PIC.SW(Folder..'/'..imShow[1])
		LOG.DEBUG("PIC.SW("..Folder..imShow[2]..")")
	else
		bitset_mode_swich(2)
	end
end

function Sw_by_name(name)
	local result_table = {}
	local ret=""
	imIndex=getImageIndex(name)
	if imIndex==nil then
		ret="NG"
	else
		PIC.SW(Folder..'/'..imShow[imIndex])
		--DMIPI.CMDA()
		--PIC.SW(Folder..'/'..imShow[imIndex])
		LOG.DEBUG("PIC.SW("..Folder..imShow[imIndex]..")")
		ret="OK"
	end
	table.insert(result_table,ret)
	json_data = cjson.encode(result_table)
	return 0,json_data
end


function bitset_mode_swich(mode)
	if mode == 1 then
		println("Horizontal Bars")
		VPG_IIC_WRITE(1)
	elseif mode == 2 then
		println("Vertical Bars")
		VPG_IIC_WRITE(2)
	elseif mode == 3 then
		println("Checkerboard")
		VPG_IIC_WRITE(3)
	elseif mode == 4 then
		println("Cross hairs")
		VPG_IIC_WRITE(4)
	elseif mode == 5 then
		println("9 cross Pattern")
		VPG_IIC_WRITE(5)
	elseif mode == 6 then
		println("repeated Tile")
		VPG_IIC_WRITE(6)
	elseif mode == 7 then
		println("single Horizontal Stripe")
		VPG_IIC_WRITE(7)
	elseif mode == 8 then
		println("single Vertical Stripe")
		VPG_IIC_WRITE(8)
	elseif mode == 9 then
		println("Flat Field")
		VPG_IIC_WRITE(9)
	elseif mode == 10 then
		println("Gradient")
		VPG_IIC_WRITE(10)
	elseif mode == 11 then
		println("9 Square Pattern")
		VPG_IIC_WRITE(11)
	end

end

function getImageIndex(name)
    for i, v in ipairs(imShow) do
        if v == name then
            return i
        end
    end
    LOG.ERROR("图片不存在")
    return nil  -- 未找到返回nil
end

