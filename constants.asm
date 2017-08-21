;==================================================================
;
;	NOTES:  ONLY CONSTANTS, NOT VARIABLES !!!
;
;==================================================================

LD_BYTES: 			EQU $0556
SA_BYTES:			EQU $04C2


RAMPAGE0: 			EQU %00000000
RAMPAGE1: 			EQU %00000001
RAMPAGE2: 			EQU %00000010
RAMPAGE3: 			EQU %00000011
RAMPAGE4: 			EQU %00000100
RAMPAGE5: 			EQU %00000101
RAMPAGE6: 			EQU %00000110
RAMPAGE7: 			EQU %00000111
ROM128K:			EQU %00000000
ROM48K:			EQU %00010000
NORMALSCREENPAGE:	EQU %00000101
SHADOWSCREENPAGE:	EQU %00000111

pageport: 			EQU 0x7ffd

BORDCR:			EQU 23624
ATTR_P:			EQU 23693
ROM_CLS:			EQU 3435
CHAN_OPEN:			EQU 5633
CC_INK:			EQU 16
CC_PAPER:			EQU 17
CC_AT:				EQU 22
CC_OVER:			EQU 21


