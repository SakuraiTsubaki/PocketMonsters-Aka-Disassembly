; Japanese Red V1.0/V1.1 Init, audio reset, VBlank, and DelayFrame.
; ROM0 $09DA-$0B3B. The two revisions share the same local layout; moved
; external routines are selected through constants/builds.asm.

SECTION "JP Init and VBlank", ROM0[$09DA]

Init::
	di
	xor a
	ldh [rIF], a
	ldh [rIE], a
	ldh [rSCX], a
	ldh [rSCY], a
	ldh [rSB], a
	ldh [rSC], a
	ldh [rWX], a
	ldh [rWY], a
	ldh [rTMA], a
	ldh [rTAC], a
	ldh [rBGP], a
	ldh [rOBP0], a
	ldh [rOBP1], a

	ld a, $80
	ldh [rLCDC], a
	call DisableLCD

	ld sp, $DFFF
	ld hl, $C000
	ld bc, $2000
.loop
	ld [hl], 0
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .loop

	call ClearVram

	ld hl, $FF80
	ld bc, $007F
	call FillMemoryAddr
	call ClearSprites

	ld a, $01 ; bank containing WriteDMACodeToHRAM
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	call WriteDMACodeToHRAMAddr

	xor a
	ldh [hTileAnimations], a
	ldh [rSTAT], a
	ldh [hSCX], a
	ldh [hSCY], a
	ldh [rIF], a
	ld a, $0D ; VBlank | Timer | Serial
	ldh [rIE], a

	ld a, 144
	ldh [hWY], a
	ldh [rWY], a
	ld a, 7
	ldh [rWX], a

	ld a, $FF ; connection not established
	ldh [hSerialConnectionStatus], a

	ld h, $98
	call ClearBgMap
	ld h, $9C
	call ClearBgMap

	ld a, $E3
	ldh [rLCDC], a
	ld a, 16
	ldh [hSoftReset], a
	call StopAllSounds

	ei

	ld a, $40 ; PREDEF LoadSGB
	call PredefAddr

	ld a, $1F ; bank containing SFX_Shooting_Star
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, $9C
	ld [hAutoBGTransferDest + 1], a
	xor a
	ld [hAutoBGTransferDest], a
	dec a
	ld [wUpdateSpritesEnabled], a

	ld a, $32 ; PREDEF PlayIntro
	call PredefAddr

	call DisableLCD
	call ClearVram
	call GBPalNormalAddr
	call ClearSprites
	ld a, $E3
	ldh [rLCDC], a
	jp PrepareTitleScreenAddr

ClearVram::
	ld hl, $8000
	ld bc, $2000
	xor a
	jp FillMemoryAddr

StopAllSounds::
	ld a, $02 ; Audio Engine 1 bank
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	xor a
	ld [wAudioFadeOutControl], a
	ld [wNewSoundID], a
	ld [wLastMusicSoundID], a
	dec a
	jp PlaySoundAddr

VBlank::
	push af
	push bc
	push de
	push hl

	ldh a, [hLoadedROMBank]
	ld [wVBlankSavedROMBank], a

	ldh a, [hSCX]
	ldh [rSCX], a
	ldh a, [hSCY]
	ldh [rSCY], a

	ld a, [wDisableVBlankWYUpdate]
	and a
	jr nz, .ok
	ldh a, [hWY]
	ldh [rWY], a
.ok

	call AutoBgMapTransfer
	call VBlankCopyBgMap
	call RedrawRowOrColumn
	call VBlankCopy
	call VBlankCopyDouble
	call UpdateMovingBgTiles
	call hDMARoutine

	ld a, $01 ; bank containing PrepareOAMData
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	call PrepareOAMDataAddr

	call RandomAddr

	ldh a, [hVBlankOccurred]
	and a
	jr z, .skipZeroing
	xor a
	ldh [hVBlankOccurred], a
.skipZeroing

	ldh a, [hFrameCounter]
	and a
	jr z, .skipDec
	dec a
	ldh [hFrameCounter], a
.skipDec

	call FadeOutAudioAddr

	ld a, [wAudioROMBank]
	ldh [hLoadedROMBank], a
	ld [rROMB], a

	cp $02
	jr nz, .checkForAudio2
.audio1
	call $4000 ; Audio1_UpdateMusic
	jr .afterMusic
.checkForAudio2
	cp $08
	jr nz, .audio3
.audio2
	call $6C38 ; Music_DoLowHealthAlarm
	call $455F ; Audio2_UpdateMusic
	jr .afterMusic
.audio3
	call $4417 ; Audio3_UpdateMusic
.afterMusic

	ld b, $06 ; BANK(TrackPlayTime)
	ld hl, $4DEE ; TrackPlayTime
	call BankswitchAddr

	ld a, [wVBlankSavedROMBank]
	ldh [hLoadedROMBank], a
	ld [rROMB], a

	pop hl
	pop de
	pop bc
	pop af
	reti

DelayFrame::
; Wait for the next VBlank interrupt.
	ld a, 1
	ldh [hVBlankOccurred], a
.halt
	halt
	ldh a, [hVBlankOccurred]
	and a
	jr nz, .halt
	ret
