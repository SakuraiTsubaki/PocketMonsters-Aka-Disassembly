; Japanese Red V1.0/V1.1 BG-map/VBlank copy and tile animation code.
; Reconstructed from ROM0 $0774-$09D9.
; $0774-$09CE is byte-identical in both revisions. SoftReset has revision-
; dependent GBPalWhiteOut and DelayFrames targets.

SECTION "JP VCopy", ROM0[$0774]

GetRowColAddressBgMap::
	xor a
	srl h
	rr a
	srl h
	rr a
	srl h
	rr a
	or l
	ld l, a
	ld a, b
	or h
	ld h, a
	ret

ClearBgMap::
	ld a, $7f
	jr FillBgMapCommon

FillBgMap::
	ld a, l

FillBgMapCommon::
	ld de, $0400
	ld l, e
.loop
	ld [hli], a
	dec e
	jr nz, .loop
	dec d
	jr nz, .loop
	ret

RedrawRowOrColumn::
	ldh a, [hRedrawRowOrColumnMode]
	and a
	ret z
	ld b, a
	xor a
	ldh [hRedrawRowOrColumnMode], a
	dec b
	jr nz, .redrawRow
.redrawColumn
	ld hl, wRedrawRowOrColumnSrcTiles
	ldh a, [hRedrawRowOrColumnDest]
	ld e, a
	ldh a, [hRedrawRowOrColumnDest + 1]
	ld d, a
	ld c, 18
.loop1
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, 31
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	ld a, d
	and $03
	or $98
	ld d, a
	dec c
	jr nz, .loop1
	xor a
	ldh [hRedrawRowOrColumnMode], a
	ret
.redrawRow
	ld hl, wRedrawRowOrColumnSrcTiles
	ldh a, [hRedrawRowOrColumnDest]
	ld e, a
	ldh a, [hRedrawRowOrColumnDest + 1]
	ld d, a
	push de
	call .DrawHalf
	pop de
	ld a, 32
	add e
	ld e, a
.DrawHalf
	ld c, 10
.loop2
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, e
	inc a
	and $1f
	ld b, a
	ld a, e
	and $e0
	or b
	ld e, a
	dec c
	jr nz, .loop2
	ret

AutoBgMapTransfer::
	ldh a, [hAutoBGTransferEnabled]
	and a
	ret z
	ld hl, sp + 0
	ld a, h
	ldh [hSPTemp], a
	ld a, l
	ldh [hSPTemp + 1], a
	ldh a, [hAutoBGTransferPortion]
	and a
	jr z, .transferTopThird
	dec a
	jr z, .transferMiddleThird
.transferBottomThird
	ld hl, wTileMap + 12 * 20
	ld sp, hl
	ld a, [hAutoBGTransferDest + 1]
	ld h, a
	ld a, [hAutoBGTransferDest]
	ld l, a
	ld de, 12 * 32
	add hl, de
	xor a
	jr .doTransfer
.transferTopThird
	ld hl, wTileMap
	ld sp, hl
	ld a, [hAutoBGTransferDest + 1]
	ld h, a
	ld a, [hAutoBGTransferDest]
	ld l, a
	ld a, 1
	jr .doTransfer
.transferMiddleThird
	ld hl, wTileMap + 6 * 20
	ld sp, hl
	ld a, [hAutoBGTransferDest + 1]
	ld h, a
	ld a, [hAutoBGTransferDest]
	ld l, a
	ld de, 6 * 32
	add hl, de
	ld a, 2
.doTransfer
	ldh [hAutoBGTransferPortion], a
	ld b, 6

TransferBgRows::
REPT 9
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc l
ENDR
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	ld a, 13
	add l
	ld l, a
	jr nc, .ok
	inc h
.ok
	dec b
	jr nz, TransferBgRows
	ldh a, [hSPTemp]
	ld h, a
	ldh a, [hSPTemp + 1]
	ld l, a
	ld sp, hl
	ret

VBlankCopyBgMap::
	ldh a, [hVBlankCopyBGSource]
	and a
	ret z
	ld hl, sp + 0
	ld a, h
	ldh [hSPTemp], a
	ld a, l
	ldh [hSPTemp + 1], a
	ldh a, [hVBlankCopyBGSource]
	ld l, a
	ldh a, [hVBlankCopyBGSource + 1]
	ld h, a
	ld sp, hl
	ldh a, [hVBlankCopyBGDest]
	ld l, a
	ldh a, [hVBlankCopyBGDest + 1]
	ld h, a
	ldh a, [hVBlankCopyBGNumRows]
	ld b, a
	xor a
	ldh [hVBlankCopyBGSource], a
	jr TransferBgRows

VBlankCopyDouble::
	ldh a, [hVBlankCopyDoubleSize]
	and a
	ret z
	ld hl, sp + 0
	ld a, h
	ldh [hSPTemp], a
	ld a, l
	ldh [hSPTemp + 1], a
	ldh a, [hVBlankCopyDoubleSource]
	ld l, a
	ldh a, [hVBlankCopyDoubleSource + 1]
	ld h, a
	ld sp, hl
	ldh a, [hVBlankCopyDoubleDest]
	ld l, a
	ldh a, [hVBlankCopyDoubleDest + 1]
	ld h, a
	ldh a, [hVBlankCopyDoubleSize]
	ld b, a
	xor a
	ldh [hVBlankCopyDoubleSize], a
.loop
REPT 3
	pop de
	ld [hl], e
	inc l
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	ld [hl], d
	inc l
ENDR
	pop de
	ld [hl], e
	inc l
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	ld [hl], d
	inc hl
	dec b
	jr nz, .loop
	ld a, l
	ldh [hVBlankCopyDoubleDest], a
	ld a, h
	ldh [hVBlankCopyDoubleDest + 1], a
	ld hl, sp + 0
	ld a, l
	ldh [hVBlankCopyDoubleSource], a
	ld a, h
	ldh [hVBlankCopyDoubleSource + 1], a
	ldh a, [hSPTemp]
	ld h, a
	ldh a, [hSPTemp + 1]
	ld l, a
	ld sp, hl
	ret

VBlankCopy::
	ldh a, [hVBlankCopySize]
	and a
	ret z
	ld hl, sp + 0
	ld a, h
	ldh [hSPTemp], a
	ld a, l
	ldh [hSPTemp + 1], a
	ldh a, [hVBlankCopySource]
	ld l, a
	ldh a, [hVBlankCopySource + 1]
	ld h, a
	ld sp, hl
	ldh a, [hVBlankCopyDest]
	ld l, a
	ldh a, [hVBlankCopyDest + 1]
	ld h, a
	ldh a, [hVBlankCopySize]
	ld b, a
	xor a
	ldh [hVBlankCopySize], a
.loop
REPT 7
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc l
ENDR
	pop de
	ld [hl], e
	inc l
	ld [hl], d
	inc hl
	dec b
	jr nz, .loop
	ld a, l
	ldh [hVBlankCopyDest], a
	ld a, h
	ldh [hVBlankCopyDest + 1], a
	ld hl, sp + 0
	ld a, l
	ldh [hVBlankCopySource], a
	ld a, h
	ldh [hVBlankCopySource + 1], a
	ldh a, [hSPTemp]
	ld h, a
	ldh a, [hSPTemp + 1]
	ld l, a
	ld sp, hl
	ret

UpdateMovingBgTiles::
	ldh a, [hTileAnimations]
	and a
	ret z
	ldh a, [hMovingBGTilesCounter1]
	inc a
	ldh [hMovingBGTilesCounter1], a
	cp 20
	ret c
	cp 21
	jr z, .flower
	ld hl, $9140
	ld c, 16
	ld a, [wMovingBGTilesCounter2]
	inc a
	and 7
	ld [wMovingBGTilesCounter2], a
	and 4
	jr nz, .left
.right
	ld a, [hl]
	rrca
	ld [hli], a
	dec c
	jr nz, .right
	jr .done
.left
	ld a, [hl]
	rlca
	ld [hli], a
	dec c
	jr nz, .left
.done
	ldh a, [hTileAnimations]
	rrca
	ret nc
	xor a
	ldh [hMovingBGTilesCounter1], a
	ret
.flower
	xor a
	ldh [hMovingBGTilesCounter1], a
	ld a, [wMovingBGTilesCounter2]
	and 1
	ld hl, FlowerTile1
	jr z, .copy
	ld hl, FlowerTile2
.copy
	ld de, $9030
	ld c, 16
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

FlowerTile1::
	db $ba, $18, $65, $64, $9a, $82, $9b, $82
	db $e6, $64, $9b, $fe, $f6, $7c, $5d, $18

FlowerTile2::
	db $ae, $0c, $73, $32, $cd, $41, $4d, $41
	db $b2, $f2, $4d, $7f, $aa, $3e, $5d, $1c

SoftReset::
	call StopAllSoundsAddr
	call GBPalWhiteOutAddr
	ld c, 32
	call DelayFramesAddr
