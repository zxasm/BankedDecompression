;==================================================================
;
; Test Banked Decompression 
;
;==================================================================

	org 32768
NewStack: defb 0, 0		; Stack can go here, away from the banked memory

START:
	nop
	di
	; move the stack before we page otherwise I will break it and the stack will blow!
	ld (NewStack), sp
	ld sp, START
	;ei
main:
	xor a
	inc a
	out (254), a

	; the magic usually happens here...
	; until I break it ;)
	
	; NOTE: YOU NEED TO RESTORE THE BANKS AS NEEDED, :)	
	
	; page in bank 0
	ld a, (zx7SourceBank)
	ld b, a
	call setrampage
	
	; move the compressed data to that page
	ld hl, testscreen
	ld de, 49152
	ld bc, testscreenLEN
	ldir
	;
	
	; page in bank 7 so that we definitely do not have the source or dest banked in :)
	;ld b, 7
	;call setrampage
	
	; do the dirty deed !
	ld hl, 49152 ; location of compressed data in sourceBank
	ld de, 55000 ; destination for uncompressed data in destinationBank 
	ld b, 0
	ld c, 6
	call ZX7_DecompressBanked
	
	; now page the destinationBank back in
	;ld a, (zx7DestinationBank)
	;ld b, a
	;call setrampage
	
	; then try to ldir the decompressed data to the screen :D
	ld hl, 55000 ; remember I used this to be awkward, heh
	ld de, 16384
	ld bc, 6144
	ldir

	jp $

	ret
size_main: 	EQU $-main

	include "paging.asm"
	include "dzx7_standard_banked.asm"

	include "constants.asm"
	include "variables.asm"
	
testscreen:
	incbin "test.scr.zx7"
testscreenLEN: EQU $-testscreen

size_all:	EQU $-START
lastlocation: EQU $


END START