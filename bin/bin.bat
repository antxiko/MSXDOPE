@echo off

pcx2msx -hl charset.pcx
rem     --> charset.pcx.chr
rem     --> charset.pcx.clr
zx7 charset.pcx.chr
rem     --> charset.pcx.chr.zx7
zx7 charset.pcx.clr
rem     --> charset.pcx.clr.zx7

pcx2spr -8 sprites.pcx
rem     --> sprites.pcx.spr
zx7 sprites.pcx.spr
rem     --> sprites.pcx.spr.zx7

tmx2bin screen.tmx
rem     --> screen.tmx.bin
zx7 screen.tmx.bin
rem     --> screen.tmx.bin.zx7

tniasm bin.asm bin.bin
dir bin.bin

copy bin.bin ..\dsk\bin.bin

copy bin.bin ..\rom\bin.bin
