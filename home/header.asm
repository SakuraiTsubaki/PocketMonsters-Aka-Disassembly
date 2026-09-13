; Reset vectors, interrupt vectors, and cartridge entry point.
; Vector targets are build-specific and come from constants/builds.asm.

SECTION "rst0", ROM0[$0000]
	rst $38
	ds $08 - @, 0

SECTION "rst8", ROM0[$0008]
	rst $38
	ds $10 - @, 0

SECTION "rst10", ROM0[$0010]
	rst $38
	ds $18 - @, 0

SECTION "rst18", ROM0[$0018]
	rst $38
	ds $20 - @, 0

SECTION "rst20", ROM0[$0020]
	rst $38
	ds $28 - @, 0

SECTION "rst28", ROM0[$0028]
	rst $38
	ds $30 - @, 0

SECTION "rst30", ROM0[$0030]
	rst $38
	ds $38 - @, 0

SECTION "rst38", ROM0[$0038]
IF DEF(BUILD_JP)
	; Japanese Red V1.0/V1.1 contain this invalid jump in the unused RST $38 slot.
	jp $F080
ELSE
	rst $38
ENDC
	ds $40 - @, 0

SECTION "vblank", ROM0[$0040]
	jp VBLANK_VECTOR_TARGET
	ds $48 - @, 0

SECTION "lcd", ROM0[$0048]
	rst $38
	ds $50 - @, 0

SECTION "timer", ROM0[$0050]
	jp TIMER_VECTOR_TARGET
	ds $58 - @, 0

SECTION "serial", ROM0[$0058]
	jp SERIAL_VECTOR_TARGET
	ds $60 - @, 0

SECTION "joypad", ROM0[$0060]
	reti
IF DEF(BUILD_JP)
	; Japanese builds leave $0061-$0067 zero-filled before residual header data.
	ds $68 - @, 0
ENDC

SECTION "Header", ROM0[$0100]
Start::
	nop
	jp _Start

	; $0104-$014F is the standard cartridge header area. The final build will
	; reproduce it with rgbfix using the verified build metadata.
	ds $0150 - @
