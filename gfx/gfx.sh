wine pcx2msx.exe -hl charset.pcx
#rem     --> charset.pcx.chr
#rem     --> charset.pcx.clr

wine pcx2spr.exe -8 sprites.pcx
#rem     --> sprites.pcx.spr

wine tmx2bin.exe screen.tmx
#rem     --> screen.tmx.bin

wine tniasm.exe gfx.asm gfx.bin

cp gfx.bin ../dsk/gfx.bin
