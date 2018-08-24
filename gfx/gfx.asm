
; BLOAD header
	db	$fe ; ID byte
	dw	$0000 ; start_address
	dw	end_address -1
	dw	$0000 ; (no execution_address)

; Pattern table (CHRTBL)
	org	$0000
	incbin	"charset.pcx.chr" ; bank 0
	incbin	"charset.pcx.chr" ; bank 1
	incbin	"charset.pcx.chr" ; bank 2
	
; Name table (NAMTBL)
	org	$1800
	incbin	"screen.tmx.bin"
	
; Sprite attributes table (SPRATR)
	org	$1b00
	ds	$2000 - $, $d0 ; padding ($d0 = Sprite attribute table end marker)
	
; Color table (CLRTBL)
	org	$2000
	incbin	"charset.pcx.clr" ; bank 0
	incbin	"charset.pcx.clr" ; bank 1
	incbin	"charset.pcx.clr" ; bank 2
	
; Sprite pattern table (SPRTBL)
	org	$3800
	incbin	"sprites.pcx.spr"
	
end_address:
