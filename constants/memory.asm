; RAM/HRAM addresses verified from reconstructed Bank 00 machine code.

DEF hROMBankTemp              EQU $FF8B
DEF hTextID                   EQU $FF8C
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
DEF hWhoseTurn                EQU $FFF3

DEF wShadowOAM                EQU $C300
DEF wShadowOAMEnd             EQU $C3A0

IF DEF(BUILD_JP)
	DEF wTileMap                  EQU $C3A0
	DEF wBattleMonNick            EQU $CFF0
	DEF wEnemyMonNick             EQU $CFC1
	DEF wTextDest                 EQU $CC3A
	DEF wLinkState                EQU $D0F0
	DEF wPlayerName               EQU $D11D
	DEF wLetterPrintingDelayFlags EQU $D2D7
	DEF wRivalName                EQU $D2CE
	DEF wBuffer                   EQU $CEE4
ENDC

IF DEF(BUILD_WEST)
	DEF wBuffer EQU $CEE9
ENDC
