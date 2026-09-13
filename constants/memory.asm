; RAM/HRAM addresses verified from reconstructed Bank 00 machine code.

DEF hDMARoutine                EQU $FF80
DEF hSoftReset                 EQU $FF8A
DEF hROMBankTemp               EQU $FF8B
DEF hTextID                    EQU $FF8C
DEF hSerialConnectionStatus    EQU $FFAA
DEF hSCX                       EQU $FFAE
DEF hSCY                       EQU $FFAF
DEF hWY                        EQU $FFB0
DEF hJoyHeld                   EQU $FFB4
DEF hJoy5                      EQU $FFB5
DEF hLoadedROMBank             EQU $FFB8
DEF hAutoBGTransferEnabled     EQU $FFBA
DEF hAutoBGTransferPortion     EQU $FFBB
DEF hAutoBGTransferDest        EQU $FFBC
DEF hSPTemp                    EQU $FFBF
DEF hVBlankCopyBGSource        EQU $FFC1
DEF hVBlankCopyBGDest          EQU $FFC3
DEF hVBlankCopyBGNumRows       EQU $FFC5
DEF hVBlankCopySize            EQU $FFC6
DEF hVBlankCopySource          EQU $FFC7
DEF hVBlankCopyDest            EQU $FFC9
DEF hVBlankCopyDoubleSize      EQU $FFCB
DEF hVBlankCopyDoubleSource    EQU $FFCC
DEF hVBlankCopyDoubleDest      EQU $FFCE
DEF hRedrawRowOrColumnMode     EQU $FFD0
DEF hRedrawRowOrColumnDest     EQU $FFD1
DEF hFrameCounter              EQU $FFD5
DEF hVBlankOccurred            EQU $FFD6
DEF hTileAnimations            EQU $FFD7
DEF hMovingBGTilesCounter1     EQU $FFD8
DEF hWhoseTurn                 EQU $FFF3

DEF wShadowOAM                 EQU $C300
DEF wShadowOAMEnd              EQU $C3A0

IF DEF(BUILD_JP)
	DEF wAudioROMBank               EQU $C0EF
	DEF wAudioSavedROMBank          EQU $C0F0
	DEF wNewSoundID                 EQU $C0EE
	DEF wTileMap                    EQU $C3A0
	DEF wRedrawRowOrColumnSrcTiles  EQU $CBFC
	DEF wTextDest                   EQU $CC3A
	DEF wBuffer                     EQU $CEE4
	DEF wEnemyMonNick               EQU $CFC1
	DEF wAudioFadeOutControl        EQU $CFAE
	DEF wLastMusicSoundID           EQU $CFB1
	DEF wUpdateSpritesEnabled       EQU $CFB2
	DEF wBattleMonNick              EQU $CFF0
	DEF wMovingBGTilesCounter2      EQU $D062
	DEF wDisableVBlankWYUpdate      EQU $D07D
	DEF wVBlankSavedROMBank         EQU $D0E7
	DEF wLinkState                  EQU $D0F0
	DEF wPlayerName                 EQU $D11D
	DEF wRivalName                  EQU $D2CE
	DEF wLetterPrintingDelayFlags   EQU $D2D7
	DEF wMapPalOffset               EQU $D2DC
ENDC

IF DEF(BUILD_WEST)
	DEF wBuffer EQU $CEE9
ENDC
