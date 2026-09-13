; Japanese Red V1.0/V1.1 Bank 00 copy/video helpers.
; Bytes are identical at $028C-$0358. Revision-specific call targets in
; CheckForUserInterruption and ClearScreen are selected in constants/builds.asm.

SECTION "JP Copy and Video Helpers", ROM0[$028C]

FarCopyData2::
; Copy bc bytes from a:hl to de using hROMBankTemp.
	ldh [hROMBankTemp], a
	ldh a, [hLoadedROMBank]
	push af
	ldh a, [hROMBankTemp]
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	call CopyData
	pop af
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ret

FarCopyData3::
; Copy bc bytes from a:de to hl.
	ldh [hROMBankTemp], a
	ldh a, [hLoadedROMBank]
	push af
	ldh a, [hROMBankTemp]
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	push hl
	push de
	push de
	ld d, h
	ld e, l
	pop hl
	call CopyData
	pop de
	pop hl
	pop af
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ret

FarCopyDataDouble::
; Expand bc bytes of 1bpp data from a:hl into duplicated 2bpp bytes at de.
	ldh [hROMBankTemp], a
	ldh a, [hLoadedROMBank]
	push af
	ldh a, [hROMBankTemp]
	ldh [hLoadedROMBank], a
	ld [rROMB], a
.loop
	ld a, [hli]
	ld [de], a
	inc de
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, .loop
	pop af
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ret

CopyVideoData::
; Copy c 2bpp tiles from b:de to hl in VBlank-sized chunks.
	ldh a, [hAutoBGTransferEnabled]
	push af
	xor a
	ldh [hAutoBGTransferEnabled], a
	ldh a, [hLoadedROMBank]
	ldh [hROMBankTemp], a
	ld a, b
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ld a, e
	ldh [hVBlankCopySource], a
	ld a, d
	ldh [hVBlankCopySource + 1], a
	ld a, l
	ldh [hVBlankCopyDest], a
	ld a, h
	ldh [hVBlankCopyDest + 1], a
.loop
	ld a, c
	cp 8
	jr nc, .keepgoing
	ldh [hVBlankCopySize], a
	call DelayFrameAddr
	ldh a, [hROMBankTemp]
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	pop af
	ldh [hAutoBGTransferEnabled], a
	ret
.keepgoing
	ld a, 8
	ldh [hVBlankCopySize], a
	call DelayFrameAddr
	ld a, c
	sub 8
	ld c, a
	jr .loop

CopyVideoDataDouble::
; Copy c 1bpp tiles from b:de to hl, expanding them during VBlank.
	ldh a, [hAutoBGTransferEnabled]
	push af
	xor a
	ldh [hAutoBGTransferEnabled], a
	ldh a, [hLoadedROMBank]
	ldh [hROMBankTemp], a
	ld a, b
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ld a, e
	ldh [hVBlankCopyDoubleSource], a
	ld a, d
	ldh [hVBlankCopyDoubleSource + 1], a
	ld a, l
	ldh [hVBlankCopyDoubleDest], a
	ld a, h
	ldh [hVBlankCopyDoubleDest + 1], a
.loop
	ld a, c
	cp 8
	jr nc, .keepgoing
	ldh [hVBlankCopyDoubleSize], a
	call DelayFrameAddr
	ldh a, [hROMBankTemp]
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	pop af
	ldh [hAutoBGTransferEnabled], a
	ret
.keepgoing
	ld a, 8
	ldh [hVBlankCopyDoubleSize], a
	call DelayFrameAddr
	ld a, c
	sub 8
	ld c, a
	jr .loop

CheckForUserInterruption::
; Return carry when the title/intro interruption input is seen within c frames.
	call DelayFrameAddr
	push bc
	call JoypadLowSensitivityAddr
	pop bc
	ldh a, [hJoyHeld]
	cp $46 ; Up + Select + B
	jr z, .input
	ldh a, [hJoy5]
	and $09 ; Start | A
	jr nz, .input
	dec c
	jr nz, CheckForUserInterruption
	and a
	ret
.input
	scf
	ret

ClearScreenArea::
; Clear a c-by-b tile rectangle at hl with the Japanese blank tile ($7f).
	ld a, $7f
	ld de, 20
.loopRows
	push hl
	push bc
.loopTiles
	ld [hli], a
	dec c
	jr nz, .loopTiles
	pop bc
	pop hl
	add hl, de
	dec b
	jr nz, .loopRows
	ret

CopyScreenTileBufferToVRAM::
; Copy wTileMap to the BG map in three six-row portions.
	ld c, 6

	ld hl, $0000
	ld de, $C3A0
	call .setup
	call DelayFrameAddr

	ld hl, $0600
	ld de, $C418
	call .setup
	call DelayFrameAddr

	ld hl, $0C00
	ld de, $C490
	call .setup
	jp DelayFrameAddr

.setup
	ld a, d
	ldh [hVBlankCopyBGSource + 1], a
	call GetRowColAddressBgMapAddr
	ld a, l
	ldh [hVBlankCopyBGDest], a
	ld a, h
	ldh [hVBlankCopyBGDest + 1], a
	ld a, c
	ldh [hVBlankCopyBGNumRows], a
	ld a, e
	ldh [hVBlankCopyBGSource], a
	ret

ClearScreen::
; Clear the 20x18 tilemap and wait for the display update.
	ld bc, 360
	inc b
	ld hl, wTileMap
	ld a, $7f
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	jp Delay3Addr
