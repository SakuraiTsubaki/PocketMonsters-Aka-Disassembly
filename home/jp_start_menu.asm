; Japanese Red Bank 00 Start Menu dispatcher.
; V1.1 is relocated $12 bytes earlier; helper addresses that moved with the
; revision are selected below.

IF DEF(AKA_JP_REV0)
SECTION "JP Start Menu", ROM0[$15DE]
	DEF JP_DRAW_START_MENU_ADDR EQU $72C0
	DEF JP_HANDLE_MENU_INPUT_ADDR EQU $3B08
	DEF JP_ERASE_MENU_CURSOR_ADDR EQU $3C29
	DEF JP_PLACE_MENU_CURSOR_ADDR EQU $3C1C
	DEF JP_SAVE_SCREEN_TILES_BUFFER2_ADDR EQU $373E
	DEF JP_LOAD_TEXT_BOX_TILE_PATTERNS_ADDR EQU $36EA
ENDC
IF DEF(AKA_JP_REVA)
SECTION "JP Start Menu", ROM0[$15CC]
	DEF JP_DRAW_START_MENU_ADDR EQU $7265
	DEF JP_HANDLE_MENU_INPUT_ADDR EQU $3AF6
	DEF JP_ERASE_MENU_CURSOR_ADDR EQU $3C17
	DEF JP_PLACE_MENU_CURSOR_ADDR EQU $3C0A
	DEF JP_SAVE_SCREEN_TILES_BUFFER2_ADDR EQU $372C
	DEF JP_LOAD_TEXT_BOX_TILE_PATTERNS_ADDR EQU $36D8
ENDC

DEF JP_PRINT_SAFARI_ZONE_STEPS_ADDR EQU $4B75
DEF JP_START_MENU_POKEDEX_ADDR EQU $5AF8
DEF JP_START_MENU_POKEMON_ADDR EQU $5B0C
DEF JP_START_MENU_ITEM_ADDR EQU $5DE6
DEF JP_START_MENU_TRAINER_INFO_ADDR EQU $5F60
DEF JP_START_MENU_SAVE_RESET_ADDR EQU $60E6
DEF JP_START_MENU_OPTION_ADDR EQU $60F9

DisplayStartMenu::
	ld a, $04
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ld a, [wWalkBikeSurfState]
	ld [wWalkBikeSurfStateCopy], a
	ld a, $8f
	call PlaySound

RedisplayStartMenu::
	ld b, $01
	ld hl, JP_DRAW_START_MENU_ADDR
	call BankswitchAddr
	ld b, $03
	ld hl, JP_PRINT_SAFARI_ZONE_STEPS_ADDR
	call BankswitchAddr
	call UpdateSprites
.loop
	call JP_HANDLE_MENU_INPUT_ADDR
	ld b, a
	bit 6, a
	jr z, .checkIfDownPressed
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .loop
	ld a, [wLastMenuItem]
	and a
	jr nz, .loop
	ld a, [wPokedexEventByte]
	bit 5, a
	ld a, $06
	jr nz, .wrapMenuItemId
	dec a
.wrapMenuItemId
	ld [wCurrentMenuItem], a
	call JP_ERASE_MENU_CURSOR_ADDR
	jr .loop
.checkIfDownPressed
	bit 7, a
	jr z, .buttonPressed
	ld a, [wPokedexEventByte]
	bit 5, a
	ld a, [wCurrentMenuItem]
	ld c, $07
	jr nz, .checkIfPastBottom
	dec c
.checkIfPastBottom
	cp c
	jr nz, .loop
	xor a
	ld [wCurrentMenuItem], a
	call JP_ERASE_MENU_CURSOR_ADDR
	jr .loop
.buttonPressed
	call JP_PLACE_MENU_CURSOR_ADDR
	ld a, [wCurrentMenuItem]
	ld [wBattleAndStartSavedMenuItem], a
	ld a, b
	and $0a
	jp nz, CloseStartMenu
	call JP_SAVE_SCREEN_TILES_BUFFER2_ADDR
	ld a, [wPokedexEventByte]
	bit 5, a
	ld a, [wCurrentMenuItem]
	jr nz, .displayMenuItem
	inc a
.displayMenuItem
	cp $00
	jp z, JP_START_MENU_POKEDEX_ADDR
	cp $01
	jp z, JP_START_MENU_POKEMON_ADDR
	cp $02
	jp z, JP_START_MENU_ITEM_ADDR
	cp $03
	jp z, JP_START_MENU_TRAINER_INFO_ADDR
	cp $04
	jp z, JP_START_MENU_SAVE_RESET_ADDR
	cp $05
	jp z, JP_START_MENU_OPTION_ADDR

CloseStartMenu::
	call Joypad
	ldh a, [hJoyPressed]
	bit 0, a
	jr nz, CloseStartMenu
	call JP_LOAD_TEXT_BOX_TILE_PATTERNS_ADDR
	jp CloseTextDisplay
