@echo off

pcx2msx -hl charset.pcx
rem     --> charset.pcx.chr
rem     --> charset.pcx.clr

pcx2spr -8 sprites.pcx
rem     --> sprites.pcx.spr

tmx2bin screen.tmx
rem     --> screen.tmx.bin

tniasm gfx.asm gfx.bin

copy gfx.bin ..\dsk\gfx.bin
