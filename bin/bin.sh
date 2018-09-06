wine pcx2msx.exe -hl charset.pcx
#rem     --> charset.pcx.chr
#rem     --> charset.pcx.clr
wine zx7 charset.pcx.chr
#rem     --> charset.pcx.chr.zx7
wine zx7 charset.pcx.clr
#rem     --> charset.pcx.clr.zx7

wine pcx2spr.exe -8 sprites.pcx
#rem     --> sprites.pcx.spr
wine zx7 sprites.pcx.spr
#rem     --> sprites.pcx.spr.zx7

wine tmx2bin.exe screen.tmx
#rem     --> screen.tmx.bin
wine zx7 screen.tmx.bin
#rem     --> screen.tmx.bin.zx7

wine tniasm.exe bin.asm bin.bin

cp bin.bin ../dsk/bin.bin
cp bin.bin ../rom/bin.bin
