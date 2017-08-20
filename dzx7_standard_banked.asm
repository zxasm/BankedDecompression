; -----------------------------------------------------------------------------
; ZX7 decoder by Einar Saukas, Antonio Villena & Metalbrain
; "Standard" version (69 bytes only)
;
; NOTE: This has been edited by John Young as a test
;             for decompressing between 128 banks...
;             20170820@1340
;
; -----------------------------------------------------------------------------
; Parameters:
;   HL: source address (compressed data)
;   DE: destination address (decompressing)
;   BC: B = source 128k bank, C = destination 128k bank
; -----------------------------------------------------------------------------

ZX7_DecompressBanked:
	;
	; save the source and destination bank details for later...
	ld (zx7DestinationBank), bc
	; now change to the source bank otherwise it will decompress 
	; data from the wrong place :p
	ld a, (zx7SourceBank)
	ld b, a
	call setrampage
	;
dzx7_standard:
        ld      a, $80
dzx7s_copy_byte_loop:
	
	; save flags and set carry to indicate LDI
	push af
	call CopyCopyByteLoop
       ;ldi                             ; copy literal byte
	pop af 
	;ld bc, 0
dzx7s_main_loop:
        call    dzx7s_next_bit
        jr      nc, dzx7s_copy_byte_loop ; next bit indicates either literal or sequence

; determine number of bits used for length (Elias gamma coding)
        push    de
        ld      bc, 0
        ld      d, b
dzx7s_len_size_loop:
        inc     d
        call    dzx7s_next_bit
        jr      nc, dzx7s_len_size_loop

; determine length
dzx7s_len_value_loop:
        call    nc, dzx7s_next_bit
        rl      c
        rl      b
        jr      c, dzx7s_exit           ; check end marker
        dec     d
        jr      nz, dzx7s_len_value_loop
        inc     bc                      ; adjust length

; determine offset
        ld      e, (hl)                 ; load offset flag (1 bit) + offset value (7 bits)
        inc     hl
        defb    $cb, $33                ; opcode for undocumented instruction "SLL E" aka "SLS E"
        jr      nc, dzx7s_offset_end    ; if offset flag is set, load 4 extra bits
        ld      d, $10                  ; bit marker to load 4 bits
dzx7s_rld_next_bit:
        call    dzx7s_next_bit
        rl      d                       ; insert next bit into D
        jr      nc, dzx7s_rld_next_bit  ; repeat 4 times, until bit marker is out
        inc     d                       ; add 128 to DE
        srl	d			; retrieve fourth bit from D
dzx7s_offset_end:
        rr      e                       ; insert fourth bit into E

; copy previous sequence
        ex      (sp), hl                ; store source, restore destination
        push    hl                      ; store destination
        sbc     hl, de                  ; HL = destination - offset - 1
        pop     de                      ; DE = destination
        
        push af			; SAVE THE FLAGS !
	
	; dooooo itttttt !
       ;call CopyBankToBank
       ldir 
        pop af				; NOW GIMME THE FECKERS BACK !
        
dzx7s_exit:
        pop     hl                      ; restore source address (compressed data)
        jr      nc, dzx7s_main_loop
dzx7s_next_bit:
        add     a, a                    ; check next bit
        ret     nz                      ; no more bits left?
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        rla
        ret

; -----------------------------------------------------------------------------
CopyBankToBank:
	; we need to copy the data to the buffer first
	; I am assuming it is never more than 128 bytes
	; I could probably reduce the buffer size :)
	; but for testing, meh

	; save the registers I shall be ruining...
	push hl
	add hl, bc
	ld (zx7SaveHL), hl
	pop hl
	
	push hl
	push de
	push bc
	
	; we should already be in the source bank...
	; send decompressed block to the buffer

	ld de, zxBufferSpace
	ldir
	
	; change to destination bank!
	;ld a, (zx7DestinationBank)
	;ld b, a
	;call setrampage
	
	; restore the registers
	pop bc
	pop de
	pop hl
	
	; LDIR the buffer to the destination :)
	ld hl, zxBufferSpace
	; note that destination address and length should hold 
	; the original values, I just changed where the source is :)
	ldir

	ld hl, (zx7SaveHL)
	; switch back to the sourceBank otherwise ZX7 will get confused heh
	;ld a, (zx7SourceBank)
	;ld b, a
	;call setrampage
	ret
; -----------------------------------------------------------------------------

CopyCopyByteLoop:
	; we should already be in the source bank...
	push de
	ld de, zxBufferSpace
	ldi
	pop de
	
	;push bc
	; change to destination bank!
	;ld a, (zx7DestinationBank)
	;ld b, a
	;call setrampage
	; restore the registers
	;pop bc

	; annnnd back again...
	push hl
	ld hl, zxBufferSpace
	; note that destination address and length should hold 
	; the original values, I just changed where the source is :)
	ldi
	pop hl
	

	;push bc
	; switch back to the sourceBank otherwise ZX7 will get confused heh
	;ld a, (zx7SourceBank)
	;ld b, a
	;call setrampage
	;pop bc
	
	ret



; -----------------------------------------------------------------------------
zxBufferSpace: defs 128, 77
; -----------------------------------------------------------------------------
