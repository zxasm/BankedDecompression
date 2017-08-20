;==================================================================
;
;	NOTES:  ONLY VARIABLES !!!
;
;==================================================================


pagevalue:
	defb %00010000 ; default 128 bank setup I think

; keep in this order so we can LD BC!
zx7DestinationBank:
	defb 6	
zx7SourceBank:
	defb 0
zx7SaveHL:
	defw 0




