; RAM addresses verified from the reconstructed Bank 00 machine code.

DEF hLoadedROMBank EQU $FFB8
DEF wShadowOAM     EQU $C300
DEF wShadowOAMEnd  EQU $C3A0

IF DEF(BUILD_JP)
	DEF wBuffer EQU $CEE4
ENDC

IF DEF(BUILD_WEST)
	DEF wBuffer EQU $CEE9
ENDC
