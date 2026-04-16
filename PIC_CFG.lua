imShow = {
	--"W.bmp",
	"W255.bmp",
	"W0.bmp",
	"dot.bmp",
	"1by12-1.bmp",
	"1by12-2.bmp",
	"1by12-3.bmp",
	"1by12-4.bmp",
	"1by12-5.bmp",
	"1by12-6.bmp",
	"1by12-7.bmp",
	"1by12-8.bmp",
	"1by12-9.bmp",
	"1by12-10.bmp",
	"1by12-11.bmp",
	"1by12-12.bmp",
	"gamma.bmp",
	"Chessboard_Neg.bmp",
	"Chessboard_Pos.bmp",
	"CrossHair_Image.bmp",

}


Folder = "./textures/" 

imIndex = 1
LOG.INFO(imIndex)
bist_mode = 0--0	--1:bistmode, 0:PG

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
		PIC.SW(Folder..'/'..imShow[1])
		--PIC.SW(Folder..'/'..imShow[1])
		LOG.DEBUG("PIC.SW("..Folder..imShow[1]..")")
	else
		bitset_mode_swich(1)
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

function bitset_mode_swich(mode,EN)
	IIC_W_PEQUIN(0x74, 0) --TMG_CTRL
	IIC_W_PEQUIN(0x70, 0) --TMG_CTRL
	IIC_W_PEQUIN(0x74, 0x12087A23) --TMG_CTRL
	TIME.DELAY(10)
	if mode == 1 then
		println("All-On (Flat field)") 
		IIC_W_PEQUIN(0xB0, 0xFFFF) --VPG_DATA
		IIC_W_PEQUIN(0x9C, 0x00000003) --VPG_CTRL
	elseif mode == 2 then
		println("All-Off")
		IIC_W_PEQUIN(0xB0, 0x0000) --VPG_DATA
		IIC_W_PEQUIN(0x9C, 0x00000003) --VPG_CTRL
	elseif mode == 3 then
		println("CHKBRD_16X16")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xB4, 0x100010) --VPG_BAR_CHK_CFG  0x40000
		IIC_W_PEQUIN(0x9C, 0x00000303) --VPG_CTRL
	elseif mode == 4 then
		println("INVCHKBRD_16X16")
		IIC_W_PEQUIN(0xB0, 0xFF00) --VPG_DATA
		IIC_W_PEQUIN(0xB4, 0x100010) --VPG_BAR_CHK_CFG  0x40000
		IIC_W_PEQUIN(0x9C, 0x00000303) --VPG_CTRL
	elseif mode == 5 then
		println("CHKBRD_32X32")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xB4, 0x200020) --VPG_BAR_CHK_CFG  0x40000
		IIC_W_PEQUIN(0x9C, 0x00000303) --VPG_CTRL
	elseif mode == 6 then
		println("INVCHKBRD_32X32")
		IIC_W_PEQUIN(0xB0, 0xFF00) --VPG_DATA
		IIC_W_PEQUIN(0xB4, 0x200020) --VPG_BAR_CHK_CFG  0x40000
		IIC_W_PEQUIN(0x9C, 0x00000303) --VPG_CTRL
	elseif mode == 7 then
		println("CHKBRD_64X64")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xB4, 0x400040) --VPG_BAR_CHK_CFG
		IIC_W_PEQUIN(0x9C, 0x00000303) --VPG_CTRL
	elseif mode == 8 then
		println("CHKBRD_64X64")
		IIC_W_PEQUIN(0xB0, 0xFF00) --VPG_DATA
		IIC_W_PEQUIN(0xB4, 0x400040) --VPG_BAR_CHK_CFG
		IIC_W_PEQUIN(0x9C, 0x00000303) --VPG_CTRL
	elseif mode == 9 then
		println("9-Crosses")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xC0, 0x351440C8) --VPG_9_CROSS_CFG
		IIC_W_PEQUIN(0x9C, 0x00000703) --VPG_CTRL
	elseif mode == 10 then
		println("Repeated Slice Tile  (Sparse Grid)")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xC4, 0x22228888) -- VPG_SLICE_AB
		IIC_W_PEQUIN(0xC8, 0x03) --VPG_9_CROSS_CFG
		IIC_W_PEQUIN(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 11 then
		println("VPG_SPARSEDGRID_X0Y0")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xC4, 0x11111111) -- VPG_SLICE_AB
		IIC_W_PEQUIN(0xC8, 0x02) --VPG_9_CROSS_CFG
		IIC_W_PEQUIN(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 12 then
		println("VPG_SPARSEDGRID_X1Y0")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xC4, 0x22222222) -- VPG_SLICE_AB
		IIC_W_PEQUIN(0xC8, 0x02) --VPG_9_CROSS_CFG
		IIC_W_PEQUIN(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 13 then
		println("VPG_SPARSEDGRID_X2Y0")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xC4, 0x44444444) -- VPG_SLICE_AB
		IIC_W_PEQUIN(0xC8, 0x02) --VPG_9_CROSS_CFG
		IIC_W_PEQUIN(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 14 then
		println("VPG_SPARSEDGRID_X3Y0")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xC4, 0x88888888) -- VPG_SLICE_AB
		IIC_W_PEQUIN(0xC8, 0x02) --VPG_9_CROSS_CFG
		IIC_W_PEQUIN(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 15 then
		println("VPG_SPARSEDGRID_X0Y1")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xC4, 0x11111111) -- VPG_SLICE_AB
		IIC_W_PEQUIN(0xC8, 0x102) --VPG_9_CROSS_CFG
		IIC_W_PEQUIN(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 16 then
		println("VPG_SPARSEDGRID_X1Y1")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xC4, 0x22222222) -- VPG_SLICE_AB
		IIC_W_PEQUIN(0xC8, 0x102) --VPG_9_CROSS_CFG
		IIC_W_PEQUIN(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 17 then
		println("VPG_SPARSEDGRID_X2Y1")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xC4, 0x44444444) -- VPG_SLICE_AB
		IIC_W_PEQUIN(0xC8, 0x102) --VPG_9_CROSS_CFG
		IIC_W_PEQUIN(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 18 then
		println("VPG_SPARSEDGRID_X3Y1")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xC4, 0x88888888) -- VPG_SLICE_AB
		IIC_W_PEQUIN(0xC8, 0x102) --VPG_9_CROSS_CFG
		IIC_W_PEQUIN(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 19 then
		println("VPG_SPARSEDGRID_X0Y2")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xC4, 0x11111111) -- VPG_SLICE_AB
		IIC_W_PEQUIN(0xC8, 0x202) --VPG_9_CROSS_CFG
		IIC_W_PEQUIN(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 20 then
		println("VPG_SPARSEDGRID_X1Y2")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xC4, 0x22222222) -- VPG_SLICE_AB
		IIC_W_PEQUIN(0xC8, 0x202) --VPG_9_CROSS_CFG
		IIC_W_PEQUIN(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 21 then
		println("VPG_SPARSEDGRID_X2Y2")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xC4, 0x44444444) -- VPG_SLICE_AB
		IIC_W_PEQUIN(0xC8, 0x202) --VPG_9_CROSS_CFG
		IIC_W_PEQUIN(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 22 then
		println("VPG_SPARSEDGRID_X3Y2")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xC4, 0x88888888) -- VPG_SLICE_AB
		IIC_W_PEQUIN(0xC8, 0x202) --VPG_9_CROSS_CFG
		IIC_W_PEQUIN(0x9C, 0x00000803) --VPG_CTRL
	elseif mode == 23 then
		println("CHKBRD_54X54")
		IIC_W_PEQUIN(0xB0, 0xFF00) --VPG_DATA
		IIC_W_PEQUIN(0xB4, 0x360036) --VPG_BAR_CHK_CFG
		IIC_W_PEQUIN(0x9C, 0x00000303) --VPG_CTRL
	elseif mode == 24 then
		println("INVCHKBRD_54X54")
		IIC_W_PEQUIN(0xB0, 0x00FF) --VPG_DATA
		IIC_W_PEQUIN(0xB4, 0x360036) --VPG_STRIPE_H
		IIC_W_PEQUIN(0x9C, 0x00000303) --VPG_CTRL
	end
	TIME.DELAY(10)
	IIC_W_PEQUIN(0x9C, 0) --VPG_CTRL
	if EN == 1 then
	   IIC_W_PEQUIN(0x74, 0x2087A23) --TMG_CTRL
	   TIME.DELAY(10)
	   IIC_W_PEQUIN(0x70, 0x40000003) --TMG_CTRL
	   TIME.DELAY(10)
	   IIC_W_PEQUIN(0x70, 0x80000001) --TMG_CTRL
	   TIME.DELAY(50)
	end
	return 0
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

function Soft_Multi_frame(black1_number,w1_number,black2_number,pic_name, delay_time,trigger_keep_time,delay)
	
	keep_cycle = math.floor(trigger_keep_time/1.85)
	FPGA.PCIE_WRITE(0x25C4, 0x2 | (keep_cycle<<8) | delay<<16)
	
	TIME.DELAY(delay_time)
	PIC.MULTI_SW(1,"./textures/W0.bmp",black1_number,"./textures/"..pic_name,w1_number,"./textures/W0.bmp",black2_number)
	--PIC.MULTI_SW(1,"./textures/"..pic_name,black1_number,"./textures/"..pic_name,w1_number,"./textures/"..pic_name,black2_number)
	
end
