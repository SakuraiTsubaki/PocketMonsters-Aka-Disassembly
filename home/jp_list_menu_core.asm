; Japanese Red Bank 00 list-menu driver.
; This range ends immediately before DisplayChooseQuantityMenu.

IF DEF(AKA_JP_REV0)
SECTION "JP List Menu Core", ROM0[$16F7]
	DEF JP_LIST_BANKSWITCH_HOME_ADDR          EQU $3606
	DEF JP_LIST_HANDLE_MENU_INPUT_ADDR        EQU $3B08
	DEF JP_LIST_PLACE_MENU_CURSOR_ADDR        EQU $3BC6
	DEF JP_LIST_PLACE_UNFILLED_CURSOR_ADDR    EQU $3C1C
	DEF JP_LIST_GET_ITEM_PRICE_ADDR           EQU $3827
	DEF JP_LIST_GET_NAME_ADDR                 EQU $37B3
	DEF JP_LIST_GET_PARTY_MON_NAME_ADDR       EQU $2FB1
	DEF JP_LIST_COPY_TO_STRING_BUFFER_ADDR    EQU $386E
	DEF JP_LIST_BANKSWITCH_BACK_ADDR          EQU $3617
	DEF JP_LIST_SWAP_ITEMS_ADDR               EQU $6ADF
	DEF JP_LIST_PRINT_ENTRIES_ADDR            EQU $1968
	DEF JP_LIST_EXIT_ADDR                     EQU $194C
ENDC
IF DEF(AKA_JP_REVA)
SECTION "JP List Menu Core", ROM0[$16E5]
	DEF JP_LIST_BANKSWITCH_HOME_ADDR          EQU $35F4
	DEF JP_LIST_HANDLE_MENU_INPUT_ADDR        EQU $3AF6
	DEF JP_LIST_PLACE_MENU_CURSOR_ADDR        EQU $3BB4
	DEF JP_LIST_PLACE_UNFILLED_CURSOR_ADDR    EQU $3C0A
	DEF JP_LIST_GET_ITEM_PRICE_ADDR           EQU $3815
	DEF JP_LIST_GET_NAME_ADDR                 EQU $37A1
	DEF JP_LIST_GET_PARTY_MON_NAME_ADDR       EQU $2F9F
	DEF JP_LIST_COPY_TO_STRING_BUFFER_ADDR    EQU $385C
	DEF JP_LIST_BANKSWITCH_BACK_ADDR          EQU $3605
	DEF JP_LIST_SWAP_ITEMS_ADDR               EQU $6A84
	DEF JP_LIST_PRINT_ENTRIES_ADDR            EQU $1956
	DEF JP_LIST_EXIT_ADDR                     EQU $193A
ENDC

DEF JP_LIST_MENU_BOX     EQU $0D
DEF JP_ITEMLISTMENU      EQU $03
DEF JP_CHOSE_MENU_ITEM   EQU $01
DEF JP_BIT_NO_TEXT_DELAY EQU 6

DisplayListMenuID::
	xor a
	ldh [hAutoBGTransferEnabled], a
	ld a, $01
	ld [hJoy7], a
	ld a, [wBattleType]
	and a
	jr nz, .specialBattleType
	ld a, $01
	jr .bankswitch
.specialBattleType
	ld a, $0F ; BANK(DisplayBattleMenu)
.bankswitch
	call JP_LIST_BANKSWITCH_HOME_ADDR
	ld hl, wStatusFlags5
	set JP_BIT_NO_TEXT_DELAY, [hl]
	xor a
	ld [wMenuItemToSwap], a
	ld [wListCount], a
	ld a, [wListPointer]
	ld l, a
	ld a, [wListPointer + 1]
	ld h, a
	ld a, [hl]
	ld [wListCount], a
	ld a, JP_LIST_MENU_BOX
	ld [wTextBoxID], a
	call JP_DISPLAY_TEXT_BOX_ID_ADDR
	call UpdateSprites
	ld hl, $C3CC ; hlcoord 4, 2
	ld de, $090E ; d=9, e=14
	ld a, [wListMenuID]
	and a
	jr nz, .skipMovingSprites
	call UpdateSprites
.skipMovingSprites
	ld a, $01
	ld [wMenuWatchMovingOutOfBounds], a
	ld a, [wListCount]
	cp $02
	jr c, .setMenuVariables
	ld a, $02
.setMenuVariables
	ld [wMaxMenuItem], a
	ld a, $04
	ld [wTopMenuItemY], a
	ld a, $05
	ld [wTopMenuItemX], a
	ld a, $07 ; PAD_A | PAD_B | PAD_SELECT
	ld [wMenuWatchedKeys], a
	ld c, $0A
	call DelayFramesAddr

DisplayListMenuIDLoop::
	xor a
	ldh [hAutoBGTransferEnabled], a
	call JP_LIST_PRINT_ENTRIES_ADDR
	ld a, $01
	ldh [hAutoBGTransferEnabled], a
	call Delay3Addr
	ld a, [wBattleType]
	and a
	jr z, .notOldManBattle
	ld a, $ED ; filled right arrow cursor
	ld [$C3F5], a ; tilecoord 5,4
	ld c, $50
	call DelayFramesAddr
	xor a
	ld [wCurrentMenuItem], a
	ld hl, $C3F5
	ld a, l
	ld [wMenuCursorLocation], a
	ld a, h
	ld [wMenuCursorLocation + 1], a
	jr .buttonAPressed
.notOldManBattle
	call LoadGBPal
	call JP_LIST_HANDLE_MENU_INPUT_ADDR
	push af
	call JP_LIST_PLACE_MENU_CURSOR_ADDR
	pop af
	bit 0, a ; A
	jp z, .checkOtherKeys
.buttonAPressed
	ld a, [wCurrentMenuItem]
	call JP_LIST_PLACE_UNFILLED_CURSOR_ADDR
	ld a, $01
	ld [wMenuExitMethod], a
	ld [wChosenMenuItem], a
	xor a
	ld [wMenuWatchMovingOutOfBounds], a
	ld a, [wCurrentMenuItem]
	ld c, a
	ld a, [wListScrollOffset]
	add c
	ld c, a
	ld a, [wListCount]
	and a
	jp z, JP_LIST_EXIT_ADDR
	dec a
	cp c
	jp c, JP_LIST_EXIT_ADDR
	ld a, c
	ld [wWhichPokemon], a
	ld a, [wListMenuID]
	cp JP_ITEMLISTMENU
	jr nz, .skipMultiplying
	sla c
.skipMultiplying
	ld a, [wListPointer]
	ld l, a
	ld a, [wListPointer + 1]
	ld h, a
	inc hl
	ld b, $00
	add hl, bc
	ld a, [hl]
	ld [wCurListMenuItem], a
	ld a, [wListMenuID]
	and a
	jr z, .pokemonList
	push hl
	call JP_LIST_GET_ITEM_PRICE_ADDR
	pop hl
	ld a, [wListMenuID]
	cp JP_ITEMLISTMENU
	jr nz, .skipGettingQuantity
	inc hl
	ld a, [hl]
	ld [wMaxItemQuantity], a
.skipGettingQuantity
	ld a, [wCurItem]
	ld [wNameListIndex], a
	ld a, $01 ; BANK(ItemNames)
	ld [wPredefBank], a
	call JP_LIST_GET_NAME_ADDR
	jr .storeChosenEntry
.pokemonList
	ld hl, wPartyCount
	ld a, [wListPointer]
	cp l
	ld hl, wPartyMonNicks
	jr z, .getPokemonName
	ld hl, wBoxMonNicks
.getPokemonName
	ld a, [wWhichPokemon]
	call JP_LIST_GET_PARTY_MON_NAME_ADDR
.storeChosenEntry
	ld de, wNameBuffer
	call JP_LIST_COPY_TO_STRING_BUFFER_ADDR
	ld a, JP_CHOSE_MENU_ITEM
	ld [wMenuExitMethod], a
	ld a, [wCurrentMenuItem]
	ld [wChosenMenuItem], a
	xor a
	ld [hJoy7], a
	ld hl, wStatusFlags5
	res JP_BIT_NO_TEXT_DELAY, [hl]
	jp JP_LIST_BANKSWITCH_BACK_ADDR
.checkOtherKeys
	bit 1, a ; B
	jp nz, JP_LIST_EXIT_ADDR
	bit 2, a ; SELECT
	jp nz, JP_LIST_SWAP_ITEMS_ADDR
	ld b, a
	bit 7, b ; DOWN
	ld hl, wListScrollOffset
	jr z, .upPressed
	ld a, [hl]
	add $03
	ld b, a
	ld a, [wListCount]
	cp b
	jp c, DisplayListMenuIDLoop
	inc [hl]
	jp DisplayListMenuIDLoop
.upPressed
	ld a, [hl]
	and a
	jp z, DisplayListMenuIDLoop
	dec [hl]
	jp DisplayListMenuIDLoop
