; List-menu/quantity-selector state recovered while reconstructing Bank 00.
; Some HRAM addresses intentionally alias other temporary work variables.

DEF hItemPrice          EQU $FF8B
DEF hHalveItemPrices    EQU $FF8E
DEF hDivideBCDDivisor   EQU $FFA2
DEF hDivideBCDQuotient  EQU $FFA2

IF DEF(BUILD_JP)
	DEF wItemQuantity EQU $CF7D
ENDC
