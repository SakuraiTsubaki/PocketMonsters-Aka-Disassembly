; RAM/HRAM addresses verified from reconstructed Bank 00 machine code.

DEF hDMARoutine                EQU $FF80
DEF hSoftReset                 EQU $FF8A
DEF hROMBankTemp               EQU $FF8B
DEF hTextID                    EQU $FF8C
DEF hSerialReceivedNewData     EQU $FFA9
DEF hSerialConnectionStatus    EQU $FFAA
DEF hSerialIgnoringInitialData EQU $FFAB
DEF hSerialSendData            EQU $FFAC
DEF hSerialReceiveData         EQU $FFAD
DEF hSCX                       EQU $FFAE
DEF hSCY                       EQU $FFAF
DEF hWY                        EQU $FFB0
DEF hJoyHeld                   EQU $FFB4
DEF hJoy5                      EQU $FFB5
DEF hLoadedROMBank             EQU $FFB8
DEF hSavedROMBank              EQU $FFB9
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
	; SRAM sprite decompression work buffers.
	DEF sSpriteBuffer1                      EQU $A188
	DEF sSpriteBuffer2                      EQU $A310
	DEF SPRITEBUFFERSIZE                    EQU $0188

	; Player/object sprite-state structures used by Bank 00 reset code.
	DEF wSpriteStateData1                   EQU $C100
	DEF wSpriteStateData2                   EQU $C200
	DEF SPRITESTATEDATA1_LENGTH             EQU $0010
	DEF wSpritePlayerStateData1PictureID    EQU $C100
	DEF wSpritePlayerStateData1YPixels      EQU $C104
	DEF wSpritePlayerStateData2ImageBaseOffset EQU $C20E

	DEF wChannelSoundIDs                     EQU $C026
	DEF wNewSoundID                          EQU $C0EE
	DEF wAudioROMBank                        EQU $C0EF
	DEF wAudioSavedROMBank                   EQU $C0F0
	DEF wTileMap                             EQU $C3A0
	DEF wRedrawRowOrColumnSrcTiles           EQU $CBFC
	DEF wTextDest                            EQU $CC3A
	DEF wLinkMenuSelectionReceiveBuffer      EQU $CC3D
	DEF wSerialExchangeNybbleTempReceiveData EQU $CC3D
	DEF wSerialSyncAndExchangeNybbleReceiveData EQU $CC3D
	DEF wSerialExchangeNybbleReceiveData     EQU $CC3E
	DEF wLinkMenuSelectionSendBuffer         EQU $CC42
	DEF wSerialExchangeNybbleSendData        EQU $CC42
	DEF wUnknownSerialCounter                EQU $CC47
	DEF wNameBuffer                          EQU $CD68
	DEF wBuffer                              EQU $CEE4
	DEF wEnemyMonNick                        EQU $CFC1
	DEF wAudioFadeOutControl                 EQU $CFAE
	DEF wAudioFadeOutCounterReloadValue      EQU $CFAF
	DEF wAudioFadeOutCounter                 EQU $CFB0
	DEF wLastMusicSoundID                    EQU $CFB1
	DEF wUpdateSpritesEnabled                EQU $CFB2
	DEF wBattleMonNick                       EQU $CFF0
	DEF wUnknownSerialCounter2               EQU $D051
	DEF wMovingBGTilesCounter2               EQU $D062
	DEF wDisableVBlankWYUpdate               EQU $D07D
	DEF wSpriteCurPosX                       EQU $D07E
	DEF wSpriteCurPosY                       EQU $D07F
	DEF wSpriteWidth                         EQU $D080
	DEF wSpriteHeight                        EQU $D081
	DEF wSpriteInputCurByte                  EQU $D082
	DEF wSpriteInputBitCounter               EQU $D083
	DEF wSpriteOutputBitOffset               EQU $D084
	DEF wSpriteLoadFlags                     EQU $D085
	DEF wSpriteUnpackMode                    EQU $D086
	DEF wSpriteFlipped                       EQU $D087
	DEF wSpriteInputPtr                      EQU $D088
	DEF wSpriteOutputPtr                     EQU $D08A
	DEF wSpriteOutputPtrCached               EQU $D08C
	DEF wSpriteDecodeTable0Ptr               EQU $D08E
	DEF wSpriteDecodeTable1Ptr               EQU $D090
	DEF wVBlankSavedROMBank                  EQU $D0E7
	DEF wLinkState                           EQU $D0F0
	DEF wPlayerName                          EQU $D11D
	DEF wRivalName                           EQU $D2CE
	DEF wLetterPrintingDelayFlags            EQU $D2D7
	DEF wMapMusicSoundID                     EQU $D2DA
	DEF wMapMusicROMBank                     EQU $D2DB
	DEF wMapPalOffset                        EQU $D2DC
	DEF wWalkBikeSurfState                   EQU $D67F
	DEF wStatusFlags2                        EQU $D6AB
	DEF wStatusFlags4                        EQU $D6AD
ENDC

IF DEF(BUILD_WEST)
	DEF wBuffer EQU $CEE9
ENDC
