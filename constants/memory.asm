; RAM/HRAM addresses verified from reconstructed Bank 00 machine code.

DEF hROMBankTemp              EQU $FF8B
DEF hJoyHeld                  EQU $FFB4
DEF hJoy5                     EQU $FFB5
DEF hLoadedROMBank            EQU $FFB8
DEF hAutoBGTransferEnabled    EQU $FFBA
DEF hVBlankCopyBGSource       EQU $FFC1
DEF hVBlankCopyBGDest         EQU $FFC3
DEF hVBlankCopyBGNumRows      EQU $FFC5
DEF hVBlankCopySize           EQU $FFC6
DEF hVBlankCopySource         EQU $FFC7
DEF hVBlankCopyDest           EQU $FFC9
DEF hVBlankCopyDoubleSize     EQU $FFCB
DEF hVBlankCopyDoubleSource   EQU $FFCC
DEF hVBlankCopyDoubleDest     EQU $FFCE

DEF wShadowOAM     EQU $C300
DEF wShadowOAMEnd  EQU $C3A0

IF DEF(BUILD_JP)
	DEF wTileMap EQU $C3A0
	DEF wBuffer  EQU $CEE4
ENDC

IF DEF(BUILD_WEST)
	DEF wBuffer EQU $CEE9
ENDC
