; Japanese Red V1.0/V1.1 text-box and string decoding core.
; Reconstructed from ROM0 $03D2-$04C8. All bytes are shared except the
; PrintLetterDelay call target selected in constants/builds.asm.

SECTION "JP Text Core", ROM0[$03D2]

TextBoxBorder::
; Draw a c-by-b box at hl using the Japanese border tile IDs.
	push hl
	ld a, $79
	ld [hli], a
	inc a
	call .PlaceChars
	inc a
	ld [hl], a
	pop hl

	ld de, 20
	add hl, de

.next
	push hl
	ld a, $7c
	ld [hli], a
	ld a, $7f
	call .PlaceChars
	ld [hl], $7c
	pop hl

	ld de, 20
	add hl, de
	dec b
	jr nz, .next

	ld a, $7d
	ld [hli], a
	ld a, $7a
	call .PlaceChars
	ld [hl], $7e
	ret

.PlaceChars
	ld d, c
.loop
	ld [hli], a
	dec d
	jr nz, .loop
	ret

PlaceString::
	push hl

PlaceNextChar::
	ld a, [de]
	cp $50 ; terminator
	jr nz, .NotTerminator
	ld b, h
	ld c, l
	pop hl
	ret

.NotTerminator
	cp $4e ; <NEXT>
	jr nz, .NotNext
	pop hl
	ld bc, 40
	add hl, bc
	push hl
	jp NextChar

.NotNext
	cp $4f ; <LINE>
	jr nz, .NotLine
	pop hl
	ld hl, $c4e1
	push hl
	jp NextChar

.NotLine
; Dictionary/control characters. Targets not yet reconstructed in this tree are
; kept as verified absolute ROM0 addresses until their labels are recovered.
	and a
	jp z, $04c9       ; <NULL>
	cp $4c
	jp z, $05bb       ; <SCROLL>
	cp $4b
	jp z, $05a9       ; <_CONT>
	cp $51
	jp z, $0588       ; <PARA>
	cp $52
	jp z, $04da       ; <PLAYER>
	cp $53
	jp z, $04e0       ; <RIVAL>
	cp $54
	jp z, $04fe       ; Pokémon token
	cp $5b
	jp z, $04f2       ; PC
	cp $5e
	jp z, $04f8       ; Rocket
	cp $5c
	jp z, $04ec       ; TM
	cp $5d
	jp z, $04e6       ; Trainer
	cp $55
	jp z, $0555       ; <CONT>
	cp $56
	jp z, $0504       ; two ellipses
	cp $57
	jp z, $0581       ; <DONE>
	cp $58
	jp z, $0569       ; <PROMPT>
	cp $59
	jp z, $050a       ; <TARGET>
	cp $5a
	jp z, $0510       ; <USER>

; Handle standalone dakuten/handakuten and encoded voiced kana.
	cp $e4
	jr z, .PlaceDiacriticSymbol
	cp $e5
	jr nz, .KanaCharacter

.PlaceDiacriticSymbol
	push hl
	ld bc, -20
	add hl, bc
	ld [hl], a
	pop hl
	jr NextChar

.KanaCharacter
	cp $60
	jr nc, .RegularKana
	cp $40
	jr nc, .Handakuten
	cp $20
	jr nc, .HiraganaDakuten

; Katakana dakuten -> base kana.
	add $80
	jr .PlaceDakuten

.HiraganaDakuten
	add $90

.PlaceDakuten
	push af
	ld a, $e5
	push hl
	ld bc, -20
	add hl, bc
	ld [hl], a
	pop hl
	pop af
	jr .RegularKana

.Handakuten
	cp $44
	jr nc, .HiraganaHandakuten

; Katakana handakuten -> base kana.
	add $59
	jr .PlaceHandakuten

.HiraganaHandakuten
	add $86

.PlaceHandakuten
	push af
	ld a, $e4
	push hl
	ld bc, -20
	add hl, bc
	ld [hl], a
	pop hl
	pop af

.RegularKana
	ld [hli], a
	call PrintLetterDelayAddr

NextChar::
	inc de
	jp PlaceNextChar
