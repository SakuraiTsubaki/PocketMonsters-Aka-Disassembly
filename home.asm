; Reconstructed Bank 00 source.
; Only confirmed ranges are included here; the remaining ROM0 body is still
; under active disassembly.

INCLUDE "home/header.asm"

IF DEF(BUILD_JP)
	INCLUDE "home/garbage_header.asm"
ENDC

IF DEF(BUILD_WEST)
	INCLUDE "home/high_home.asm"
ENDC

INCLUDE "home/start.asm"

IF DEF(BUILD_JP)
	INCLUDE "home/jp_early_home.asm"
	INCLUDE "data/tilesets/jp_collision_tile_ids.asm"
	INCLUDE "home/jp_copy2.asm"
	INCLUDE "home/jp_text_core.asm"
	INCLUDE "home/jp_text_engine.asm"
	INCLUDE "home/jp_vcopy.asm"
ENDC
