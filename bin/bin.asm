
; -----------------------------------------------------------------------------
; MSX BIOS entry points and constants

; MSX BIOS
	DISSCR:	equ $0041 ; Disable screen
	ENASCR:	equ $0044 ; Enable screen
	LDIRVM:	equ $005c ; Copy block to VRAM, from memory
	CLRSPR:	equ $0069 ; Clear all sprites
	INIGRP:	equ $0072 ; Initialize VDP to Graphics Mode

; MSX system variables
	LINLEN: equ $f3b0 ; Width for the current text mode
	CLIKSW:	equ $f3db ; Keyboard click sound
	FORCLR:	equ $f3e9 ; Foreground colour
	BAKCLR:	equ $f3ea ; Background colour
	BDRCLR:	equ $f3eb ; Border colour
	SCRMOD: equ $fcaf ; Screen mode.

; MSX system hooks
	HKEYI:	equ $fd9a ; Interrupt handler
	HTIMI:	equ $fd9f ; Interrupt handler
	HOOK_SIZE:	equ HTIMI - HKEYI

; VRAM addresses
	CHRTBL:	equ $0000 ; Pattern table
	NAMTBL:	equ $1800 ; Name table
	CLRTBL:	equ $2000 ; Color table
	SPRATR:	equ $1B00 ; Sprite attributes table
	SPRTBL:	equ $3800 ; Sprite pattern table

; VDP symbolic constants
	SCR_WIDTH:	equ 32
	NAMTBL_SIZE:	equ 32 * 24
	CHRTBL_SIZE:	equ 256 * 8
	SPRTBL_SIZE:	equ 32 * 64
	SPAT_END:	equ $d0 ; Sprite attribute table end marker
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; BLOAD header
	db	$fe ; ID byte
	dw	start_address
	dw	end_address -1
	dw	execution_address
; -----------------------------------------------------------------------------

	org	$af00
start_address:
	; Important note:
	; If "Jump to initialization routine" is checked in MSX-BASIC ROM Creator,
	; the ROM will jump to the binary file start
	; (instead of execution address like BLOAD,R does)
	; so the execution address must match start_address to make a .BIN
	; compatible with MSX-BASIC ROM Creator
	
; -----------------------------------------------------------------------------
execution_address:
; VDP: color 15,1,1
	ld	a, 15
	ld	[FORCLR], a
	ld	a, 1
	ld	[BAKCLR], a
	ld	[BDRCLR], a
; VDP: screen 2
	call	INIGRP
	call	DISSCR
; ; screen ,2
	; ld	hl, RG1SAV
	; set	1, [hl]
; screen ,,0
	xor	a
	ld	[CLIKSW], a

; Unpacks CHRTBL to the three banks
	ld	hl, CHRTBL_PACKED
	call	UNPACK
	ld	de, CHRTBL
	call	LDIRVM_CHRTBL_BANK
	ld	de, CHRTBL + CHRTBL_SIZE
	call	LDIRVM_CHRTBL_BANK
	ld	de, CHRTBL + CHRTBL_SIZE + CHRTBL_SIZE
	call	LDIRVM_CHRTBL_BANK

; Unpacks CLRTBL to the three banks
	ld	hl, CLRTBL_PACKED
	call	UNPACK
	ld	de, CLRTBL
	call	LDIRVM_CLRTBL_BANK
	ld	de, CLRTBL + CHRTBL_SIZE
	call	LDIRVM_CLRTBL_BANK
	ld	de, CLRTBL + CHRTBL_SIZE + CHRTBL_SIZE
	call	LDIRVM_CLRTBL_BANK
	
; Unpacks NAMTBL
	ld	hl, NAMTBL_PACKED
	call	UNPACK
	ld	de, NAMTBL
	ld	bc, NAMTBL_SIZE
	call	LDIRVM_UNPACKED
	
; Unpacks SPRTBL
	ld	hl, SPRTBL_PACKED
	call	UNPACK
	ld	de, SPRTBL
	ld	bc, SPRTBL_SIZE
	call	LDIRVM_UNPACKED
	
; Initializes the replayer
	call	PLAYER_OFF
; Initializes WYZPlayer sound buffers
	ld	hl, wyzplayer_buffer.a
	ld	[CANAL_A], hl
	ld	hl, wyzplayer_buffer.b
	ld	[CANAL_B], hl
	ld	hl, wyzplayer_buffer.c
	ld	[CANAL_C], hl
	ld	hl, wyzplayer_buffer.p
	ld	[CANAL_P], hl

; Preserves the existing hook
	ld	hl, HTIMI
	ld	de, htimi_hook_backup
	ld	bc, HOOK_SIZE
	ldir
; Install the replayer hook in the interruption
	di
	ld	hl, WYZPLAYER_HOOK
	ld	de, HTIMI
	ld	bc, HOOK_SIZE
	ldir
	ei

; Loads song #0
	halt
	ld	a, 0
	call	CARGA_CANCION
	halt

; Enables screen
	call	ENASCR

; Tricks MSX-BASIC to believe it's SCREEN 1
	ld	a, 1
	ld	[SCRMOD], a
	ld	a, SCR_WIDTH
	ld	[LINLEN], a
	ret
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; LDIRVM the decompresison buffer to one CHRTBL or CLRTBL bank
; param de: VRAM destination address
LDIRVM_CHRTBL_BANK:
LDIRVM_CLRTBL_BANK:
	ld	bc, CHRTBL_SIZE
	; jr	LDIRVM_CLRTBL_BANK
; ------VVVV----falls through--------------------------------------------------

; -----------------------------------------------------------------------------
; LDIRVM the decompresison buffer
; param de: VRAM destination address
; param bc: uncompressed data size
LDIRVM_UNPACKED:
	ld	hl, unpack_buffer
	jp	LDIRVM
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; H.TIMI hook that invokes both the replayer and the previously existing hook
WYZPLAYER_HOOK:
	push	af ; Preserves VDP status register S#0 (a)
	call	INICIO
	pop	af ; Restores VDP status register S#0 (a)
	jp	htimi_hook_backup
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; WYZPlayer v0.47c
	include	"wyzplayer/WYZPROPLAY47cMSX.ASM"
; ZX7 decoder by Einar Saukas, Antonio Villena & Metalbrain
; "Standard" version (69 bytes only)
UNPACK:
	ld	de, unpack_buffer
	include "zx7/dzx7_standard.tniasm.asm"
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Charset binary data (CHRTBL and CLRTBL)
CHRTBL_PACKED:
	incbin	"charset.pcx.chr.zx7"
CLRTBL_PACKED:
	incbin	"charset.pcx.clr.zx7"
	
; Screen binary data (NAMTBL)
NAMTBL_PACKED:
	incbin	"screen.tmx.bin.zx7"
	
; Sprites binary data (SPRTBL)
SPRTBL_PACKED:
	incbin	"sprites.pcx.spr.zx7"

; WYZPlayer example song
	include	"DonusTrak.mus.asm"
TABLA_SONG:
	dw	$ + 2
	incbin	"DonusTrak.mus"
; -----------------------------------------------------------------------------
	
end_address:

; -----------------------------------------------------------------------------
	org	$e000
	
; Unpacker routine buffer
unpack_buffer:
	; (no reserved bytes!; will be overwritten by replayer variables)

; Backup of the H.TIMI hook previous to the installation of the replayer hook
htimi_hook_backup:
	rb	HOOK_SIZE

; WYZPlayer v0.47c variables
	include	"wyzplayer/WYZPROPLAY47c_RAM.tniasm.ASM"

; WYZPlayer sound buffers. Recommended at least $10 bytes per channel
wyzplayer_buffer:
.a:	rb	$20
.b:	rb	$20
.c:	rb	$20
.p:	rb	$20

; -----------------------------------------------------------------------------
