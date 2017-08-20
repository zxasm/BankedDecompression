;==================================================================
;
; Take a wild guess what this does, pfft :p
;
;==================================================================

; b=page number to page in... interrupts must be disabled !!!
setrampage:
	;di
	ld a, (pagevalue)
	and %11111000
	or b
	ld bc, pageport
	;ld (pagevalue), a
	out (c), a
	;ei
	ret
