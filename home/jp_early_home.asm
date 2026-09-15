; Japanese Red V1.0/V1.1 early Home routines.
; The two revisions are byte-identical from $0153 through $01C3.

SECTION "JP Early Home", ROM0[$0153]

Joypad::
; Call ReadJoypad in bank 3 at $4000, preserving the currently loaded bank.
	ldh a, [hLoadedROMBank]
	push af
	ld a, $03
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	call $4000
	pop af
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ret

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
