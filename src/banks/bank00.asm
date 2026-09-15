; Bank 00 (ROM0)
; Disassembly is shared by Rev 0 and Rev A where bytes are identical.
; Unknown / not-yet-disassembled regions remain byte-exact INCBIN slices.

SECTION "Bank 00", ROM0[$0000]

; Reset vectors, interrupt vectors, cartridge header, and padding.
; These bytes are revision-sensitive, so keep them verbatim for now.
INCBIN BASEROM, $0000, $0150

; Cartridge entry point at $0150.
Start::
	jp $09da

; Temporarily switch to ROM bank $03, call $4000, then restore the bank.
Home_0153::
	ldh a, [$b8]
	push af
	ld a, $03
	ldh [$b8], a
	ld [$2000], a
	call $4000
	pop af
	ldh [$b8], a
	ld [$2000], a
	ret

; Disable the LCD during a safe scanline window while preserving IE.
Home_0167::
	xor a
	ldh [$0f], a
	ldh a, [$ff]
	ld b, a
	res 0, a
	ldh [$ff], a
.wait_for_vblank
	ldh a, [$44]
	cp $91
	jr nz, .wait_for_vblank
	ldh a, [$40]
	and $7f
	ldh [$40], a
	ld a, b
	ldh [$ff], a
	ret

; Re-enable the LCD.
Home_0181::
	ldh a, [$40]
	set 7, a
	ldh [$40], a
	ret

; Clear $A0 bytes beginning at $C300.
Home_0188::
	xor a
	ld hl, $c300
	ld b, $a0
.loop
	ld [hli], a
	dec b
	jr nz, .loop
	ret

; Write $A0 to every fourth byte in the $C300-$C39F range.
Home_0193::
	ld a, $a0
	ld hl, $c300
	ld de, $0004
	ld b, $28
.loop
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop
	ret

; Copy BC bytes from HL in the ROM bank supplied in A to DE,
; restoring the previous ROM bank afterward.
Home_01A3::
	ld [$cee4], a
	ldh a, [$b8]
	push af
	ld a, [$cee4]
	ldh [$b8], a
	ld [$2000], a
	call Home_01BB
	pop af
	ldh [$b8], a
	ld [$2000], a
	ret

Home_01BB::
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or b
	jr nz, Home_01BB
	ret

; Continue bank-by-bank replacement from here.
INCBIN BASEROM, $01c4, $4000 - $01c4
