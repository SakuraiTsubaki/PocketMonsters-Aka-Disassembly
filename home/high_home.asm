; Western Red keeps four small home-bank helper groups in $0061-$00BD.
; The five western localizations are byte-identical in this whole range.

SECTION "High Home", ROM0[$0061]

DisableLCD::
	xor a
	ldh [rIF], a
	ldh a, [rIE]
	ld b, a
	res 0, a
	ldh [rIE], a
.wait
	ldh a, [rLY]
	cp 145
	jr nz, .wait
	ldh a, [rLCDC]
	and $7F
	ldh [rLCDC], a
	ld a, b
	ldh [rIE], a
	ret

EnableLCD::
	ldh a, [rLCDC]
	set 7, a
	ldh [rLCDC], a
	ret

ClearSprites::
	xor a
	ld hl, wShadowOAM
	ld b, wShadowOAMEnd - wShadowOAM
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret

HideSprites::
	ld a, 160
	ld hl, wShadowOAM
	ld de, 4
	ld b, 40
.loop
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop
	ret

FarCopyData::
; Copy bc bytes from bank a:hl to de.
	ld [wBuffer], a
	ldh a, [hLoadedROMBank]
	push af
	ld a, [wBuffer]
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	call CopyData
	pop af
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ret

CopyData::
; Copy bc bytes from hl to de.
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, CopyData
	ret

	ds $0100 - @, 0
