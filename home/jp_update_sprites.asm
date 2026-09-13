; Japanese Red Bank 00 sprite update trampoline.
; V1.0/V1.1 are byte-identical here.

IF DEF(AKA_JP_REV0)
SECTION "JP Update Sprites", ROM0[$0EBD]
ENDC
IF DEF(AKA_JP_REVA)
SECTION "JP Update Sprites", ROM0[$0EAB]
ENDC

UpdateSprites::
	ld a, [wUpdateSpritesEnabled]
	dec a
	ret nz

; homecall _UpdateSprites (bank 1:$4A1C), expanded explicitly while the shared
; homecall macro layer is still being reconstructed.
	ldh a, [hLoadedROMBank]
	push af
	ld a, $01
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	call $4A1C
	pop af
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ret
