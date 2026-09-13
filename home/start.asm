; First instructions at $0150.

SECTION "Home Start", ROM0[$0150]

_Start::
IF DEF(BUILD_JP)
	; Japanese Red jumps directly to Init.
	jp INIT_TARGET
ELSE
	; Western Red records whether the boot ROM identified CGB hardware.
	cp $11
	jr z, .cgb
	xor a
	jr .ok
.cgb
	ld a, 0
.ok
	ld [W_ON_CGB], a
	jp INIT_TARGET
ENDC
