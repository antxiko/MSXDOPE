
; -----------------------------------------------------------------------------
; MSX system variables

; MSX system hooks
	HKEYI:	equ $fd9a ; Interrupt handler
	HTIMI:	equ $fd9f ; Interrupt handler
	HOOK_SIZE:	equ HTIMI - HKEYI
; -----------------------------------------------------------------------------

	
; -----------------------------------------------------------------------------
; BLOAD header
	db	$fe ; ID byte
	dw	$c000 ; start_address
	dw	end_address -1
	dw	$c000 ; execution_address
; -----------------------------------------------------------------------------

	org	$c000
start_address:
execution_address:

; -----------------------------------------------------------------------------
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
	ret

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

; WYZPlayer example song
	include	"DonusTrak.mus.asm"
TABLA_SONG:
	dw	$ + 2
	incbin	"DonusTrak.mus"
; -----------------------------------------------------------------------------
	
end_address:

; -----------------------------------------------------------------------------
	; org	$e000

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
