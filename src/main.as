; msx dope wars (asm version)
; coded by ibannieto and antxiko (working progress)


	output  "dope.rom"

    include "inc/const.as"

    defpage	 0,0x4000, 0x2000

	page 0

    org 4000h
    dw 4241h,START,0,0,0,0,0,0

START:
	di
	im 		1
	ld 		sp, #f380
    ld 		a, #c9
	ld  	(TIMI), a
    ld  	(HKEY), a
    ei

	[3] nop

    call INIT_GRAPHICS

    call    DISSCR

    ld	    hl, NAMTBL
	ld      bc, 768
	xor	    a
	call	FILVRM

    ld      hl, TILESFULL_CLR
    ld      de, CLRTBL
    call    depack_VRAM

    ld      hl, TILESFULL_CHR
    ld      de, CHRTBL
    call    depack_VRAM

    call ENASCR

	call	PORTADA
	;call	INTRO
	;call	GAME_LOOP
	;call	AGRADECIMIENTOS
	;call	GAMEOVER

END:
	jr.		END

PORTADA:
	call    DISSCR

    ld	    hl, NAMTBL
	ld      bc, 768
	xor	    a
	call	FILVRM

    ld      hl, PORTADA_NAMTBL
    ld      de, NAMTBL
    call    depack_VRAM

	call	ENASCR

    call    CHGET

	ret


; rutinas
INIT_GRAPHICS:
    ld      hl,FORCLR
	ld      [hl],15
	inc     hl
	ld      [hl],1
	inc		hl
	ld		[hl],1
	call    CHGCLR

    xor		a
   	ld		[CLIKSW],a

    ld      a,2
    call    CHGMOD

    ret

TILESFULL_CHR:
    incbin  "../gfx/nmsxtiles/portada.til"
TILESFULL_CLR:
    incbin  "../gfx/nmsxtiles/portada.col"
PORTADA_NAMTBL:
    incbin  "bin/portada.nam"

depack_VRAM:
	include "inc/depack.as"
    include "inc/unpack.as"

SCR_WIDTH	equ 32

buffer:
	ds		768    