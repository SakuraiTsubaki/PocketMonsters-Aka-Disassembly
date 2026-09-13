; Japanese Red Bank 00 map/NPC text-script dispatcher and common dialogue.
; This range begins immediately after FadeOutAudio and ends immediately before
; DisplayStartMenu. Japanese encoded text remains explicit bytes until the
; complete Japanese charmap/text macro layer is reconstructed.

IF DEF(AKA_JP_REV0)
SECTION "JP Text Script", ROM0[$13F1]
	DEF JP_DISPLAY_TEXT_ID_INIT_ADDR EQU $724B
	DEF JP_SWITCH_TO_MAP_ROM_BANK_ADDR EQU $2CCD
	DEF JP_DISPLAY_START_MENU_ADDR EQU $15DE
	DEF JP_ITEM_STORAGE_PC_ADDR EQU $34AA
	DEF JP_BILLS_PC_ADDR EQU $34B4
	DEF JP_POKEMON_CENTER_PC_ADDR EQU $34C9
	DEF JP_GAME_CORNER_PRIZE_ADDR EQU $34BE
	DEF JP_CABLE_CLUB_NPC_ADDR EQU $736B
	DEF JP_PRINT_TEXT_NO_BOX_ADDR EQU $3C89
	DEF JP_WAIT_TEXT_SCROLL_ADDR EQU $38AE
	DEF JP_LOAD_PLAYER_SPRITE_GFX_ADDR EQU $23AE
	DEF JP_LOAD_CURRENT_MAP_VIEW_ADDR EQU $26BB
	DEF JP_PRINT_TEXT_ADDR EQU $3C79
	DEF JP_POKEMART_DIALOGUE_ADDR EQU $6BBB
	DEF JP_POKECENTER_DIALOGUE_ADDR EQU $7121
ENDC
IF DEF(AKA_JP_REVA)
SECTION "JP Text Script", ROM0[$13DF]
	DEF JP_DISPLAY_TEXT_ID_INIT_ADDR EQU $71F0
	DEF JP_SWITCH_TO_MAP_ROM_BANK_ADDR EQU $2CBB
	DEF JP_DISPLAY_START_MENU_ADDR EQU $15CC
	DEF JP_ITEM_STORAGE_PC_ADDR EQU $3498
	DEF JP_BILLS_PC_ADDR EQU $34A2
	DEF JP_POKEMON_CENTER_PC_ADDR EQU $34B7
	DEF JP_GAME_CORNER_PRIZE_ADDR EQU $34AC
	DEF JP_CABLE_CLUB_NPC_ADDR EQU $7310
	DEF JP_PRINT_TEXT_NO_BOX_ADDR EQU $3C77
	DEF JP_WAIT_TEXT_SCROLL_ADDR EQU $389C
	DEF JP_LOAD_PLAYER_SPRITE_GFX_ADDR EQU $239C
	DEF JP_LOAD_CURRENT_MAP_VIEW_ADDR EQU $26A9
	DEF JP_PRINT_TEXT_ADDR EQU $3C67
	DEF JP_POKEMART_DIALOGUE_ADDR EQU $6B60
	DEF JP_POKECENTER_DIALOGUE_ADDR EQU $70C6
ENDC

DEF JP_UPDATE_SPRITE_FACING_ADDR EQU $5AD7
DEF JP_VENDING_MACHINE_MENU_ADDR EQU $4E36
DEF JP_INIT_MAP_SPRITES_ADDR EQU $7840
DEF JP_PRINT_SAFARI_GAME_OVER_ADDR EQU $7A99
DEF JP_LOAD_GB_PAL_ADDR EQU $0B3C

DisplayTextID::
	ldh a, [hLoadedROMBank]
	push af
	ld b, $01
	ld hl, JP_DISPLAY_TEXT_ID_INIT_ADDR
	call BankswitchAddr
	ld hl, wTextPredefFlag
	bit 0, [hl]
	res 0, [hl]
	jr nz, .skipSwitchToMapBank
	ld a, [wCurMap]
	call JP_SWITCH_TO_MAP_ROM_BANK_ADDR
.skipSwitchToMapBank
	ld a, $1e
	ld [hFrameCounter], a
	ld hl, wCurMapTextPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld d, $00
	ldh a, [hTextID]
	ld [wSpriteIndex], a

	and a
	jp z, JP_DISPLAY_START_MENU_ADDR
	cp $d3
	jp z, DisplaySafariGameOverText
	cp $d0
	jp z, DisplayPokemonFaintedText
	cp $d1
	jp z, DisplayPlayerBlackedOutText
	cp $d2
	jp z, DisplayRepelWoreOffText

	ld a, [wNumSprites]
	ld e, a
	ldh a, [hTextID]
	cp e
	jr z, .spriteHandling
	jr nc, .skipSpriteHandling
.spriteHandling
	push hl
	push de
	push bc
	ld b, $04
	ld hl, JP_UPDATE_SPRITE_FACING_ADDR
	call BankswitchAddr
	pop bc
	pop de
	ld hl, wMapSpriteData
	ldh a, [hTextID]
	dec a
	add a
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	inc hl
	ld a, [hl]
	pop hl
.skipSpriteHandling
	dec a
	ld e, a
	sla e
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hl]

	cp $fe
	jp z, DisplayPokemartDialogue
	cp $ff
	jp z, DisplayPokemonCenterDialogue
	cp $fc
	jp z, JP_ITEM_STORAGE_PC_ADDR
	cp $fd
	jp z, JP_BILLS_PC_ADDR
	cp $f9
	jp z, JP_POKEMON_CENTER_PC_ADDR
	cp $f5
	jr nz, .notVendingMachine
	ld b, $1d
	ld hl, JP_VENDING_MACHINE_MENU_ADDR
	call BankswitchAddr
	jr AfterDisplayingTextID
.notVendingMachine
	cp $f7
	jp z, JP_GAME_CORNER_PRIZE_ADDR
	cp $f6
	jr nz, .ordinaryText
	ld hl, JP_CABLE_CLUB_NPC_ADDR
	ld b, $01
	call BankswitchAddr
	jr AfterDisplayingTextID
.ordinaryText
	call JP_PRINT_TEXT_NO_BOX_ADDR
	ld a, [wDoNotWaitForButtonPressAfterDisplayingText]
	and a
	jr nz, HoldTextDisplayOpen

AfterDisplayingTextID::
	ld a, [wEnteringCableClub]
	and a
	jr nz, HoldTextDisplayOpen
	call JP_WAIT_TEXT_SCROLL_ADDR

HoldTextDisplayOpen::
	call Joypad
	ldh a, [hJoyHeld]
	bit 0, a
	jr nz, HoldTextDisplayOpen

CloseTextDisplay::
	ld a, [wCurMap]
	call JP_SWITCH_TO_MAP_ROM_BANK_ADDR
	ld a, $90
	ldh [hWY], a
	call DelayFrameAddr
	call JP_LOAD_GB_PAL_ADDR
	xor a
	ldh [hAutoBGTransferEnabled], a
	ld hl, wSprite01StateData2OrigFacingDirection
	ld c, $0f
	ld de, SPRITESTATEDATA1_LENGTH
.restoreSpriteFacingDirectionLoop
	ld a, [hl]
	dec h
	ld [hl], a
	inc h
	add hl, de
	dec c
	jr nz, .restoreSpriteFacingDirectionLoop
	ld a, $05
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	call JP_INIT_MAP_SPRITES_ADDR
	ld hl, wFontLoaded
	res 0, [hl]
	ld a, [wStatusFlags6]
	bit 3, a
	call z, JP_LOAD_PLAYER_SPRITE_GFX_ADDR
	call JP_LOAD_CURRENT_MAP_VIEW_ADDR
	pop af
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	jp UpdateSprites

DisplayPokemartDialogue::
	push hl
	ld hl, PokemartGreetingText
	call JP_PRINT_TEXT_ADDR
	pop hl
	inc hl
	call LoadItemList
	ld a, $02
	ld [wListMenuID], a
	ldh a, [hLoadedROMBank]
	push af
	ld a, $01
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	call JP_POKEMART_DIALOGUE_ADDR
	pop af
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	jp AfterDisplayingTextID

PokemartGreetingText::
	db $00, $D6, $B3, $BA, $BF, $E7, $4E, $B5, $BB
	db $26, $BC, $D3, $C9, $33, $BD, $B6, $E6, $57

LoadItemList::
	ld a, $01
	ld [wUpdateSpritesEnabled], a
	ld a, h
	ld [wItemListPointer], a
	ld a, l
	ld [wItemListPointer + 1], a
	ld de, wItemList
.loop
	ld a, [hli]
	ld [de], a
	inc de
	cp $ff
	jr nz, .loop
	ret

DisplayPokemonCenterDialogue::
	xor a
	ldh [$8b], a
	ldh [$8c], a
	ldh [$8d], a
	inc hl
	ldh a, [hLoadedROMBank]
	push af
	ld a, $01
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	call JP_POKECENTER_DIALOGUE_ADDR
	pop af
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	jp AfterDisplayingTextID

DisplaySafariGameOverText::
	ld hl, JP_PRINT_SAFARI_GAME_OVER_ADDR
	ld b, $07
	call BankswitchAddr
	jp AfterDisplayingTextID

DisplayPokemonFaintedText::
	ld hl, PokemonFaintedText
	call JP_PRINT_TEXT_ADDR
	jp AfterDisplayingTextID

PokemonFaintedText::
	db $01, $68, $CD, $00, $CA, $7F, $C1, $B6, $D7, $C2, $B7, $C0, $57

DisplayPlayerBlackedOutText::
	ld hl, PlayerBlackedOutText
	call JP_PRINT_TEXT_ADDR
	jp HoldTextDisplayOpen

PlayerBlackedOutText::
	db $00, $52, $C9, $7F, $C3, $D3, $C4, $C6, $CA, $4F, $C0, $C0
	db $B6, $B4, $D9, $54, $26, $7F, $D3, $B3, $B2, $C5, $B2, $E7, $51
	db $52, $CA, $4F, $D2, $C9, $CF, $B4, $26, $7F, $CF, $DF, $B8, $D7
	db $C6, $7F, $C5, $DF, $C0, $E7, $58

DisplayRepelWoreOffText::
	ld hl, RepelWoreOffText
	call JP_PRINT_TEXT_ADDR
	jp AfterDisplayingTextID

RepelWoreOffText::
	db $00, $8C, $42, $A7, $E3, $C9, $7F, $BA, $B3, $B6, $26, $B7, $D9, $D3, $57
