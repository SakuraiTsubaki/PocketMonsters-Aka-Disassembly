; List-menu/quantity-selector state recovered while reconstructing Bank 00.
; Some addresses intentionally alias other temporary work variables.

DEF hItemPrice          EQU $FF8B
DEF hHalveItemPrices    EQU $FF8E
DEF hDivideBCDDivisor   EQU $FFA2
DEF hDivideBCDQuotient  EQU $FFA2

IF DEF(BUILD_JP)
	DEF wMonDataLocation   EQU $CC49
	DEF wPrintItemPrices   EQU $CF7A
	DEF wItemQuantity      EQU $CF7D
	DEF wLoadedMonBoxLevel EQU $CF82
	DEF wLoadedMonLevel    EQU $CFA0
	DEF wNamedObjectIndex  EQU $D0E3
	DEF wTempByteValue     EQU $D0E3
	DEF wIsKeyItem         EQU $D0E9
ENDC
