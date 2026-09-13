; RAM addresses verified from the western Red Bank 00 machine code.
; Japanese RAM symbols will be added as their Bank 00 routines are recovered.

IF DEF(BUILD_WEST)
	DEF hLoadedROMBank EQU $FFB8
	DEF wShadowOAM     EQU $C300
	DEF wShadowOAMEnd  EQU $C3A0
	DEF wBuffer        EQU $CEE9
ENDC
