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
	INCLUDE "home/jp_init_vblank.asm"
	INCLUDE "home/jp_fade.asm"
	INCLUDE "home/jp_serial.asm"
	INCLUDE "home/jp_timer_audio.asm"
	INCLUDE "home/jp_update_sprites.asm"
	INCLUDE "data/items/jp_marts.asm"
	INCLUDE "home/jp_overworld_text.asm"
	INCLUDE "home/jp_uncompress.asm"
	INCLUDE "home/jp_reset_player_sprite.asm"
	INCLUDE "home/jp_fade_audio.asm"
	INCLUDE "home/jp_text_script.asm"
	INCLUDE "home/jp_start_menu.asm"
	INCLUDE "home/jp_count_set_bits.asm"
	INCLUDE "home/jp_inventory.asm"
	INCLUDE "home/jp_list_menu_core.asm"
	INCLUDE "home/jp_list_quantity.asm"
ENDC
