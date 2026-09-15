; Count set bits in b bytes at hl. This routine is byte-identical in both
; Japanese Red revisions; only its ROM0 placement is shifted by $12.

IF DEF(AKA_JP_REV0)
SECTION "JP Count Set Bits", ROM0[$1690]
ENDC
IF DEF(AKA_JP_REVA)
SECTION "JP Count Set Bits", ROM0[$167E]
ENDC

CountSetBits::
	ld c, $00
.loop
	ld a, [hli]
	ld e, a
	ld d, $08
.innerLoop
	srl e
	ld a, $00
	adc c
	ld c, a
	dec d
	jr nz, .innerLoop
	dec b
	jr nz, .loop
	ld a, c
	ld [wNumSetBits], a
	ret
