; Japanese Red Bank 00 list-menu exit and entry renderer.
; Ends immediately before GetMonName.

IF DEF(AKA_JP_REV0)
SECTION "JP List Menu Entries", ROM0[$194C]
	DEF JP_ENTRIES_GET_ITEM_NAME_ADDR  EQU $1ADD
	DEF JP_ENTRIES_GET_MOVE_NAME_ADDR  EQU $1B6D
	DEF JP_ENTRIES_LOAD_MON_DATA_ADDR  EQU $2D68
	DEF JP_ENTRIES_PRINT_LEVEL_ADDR    EQU $2F02
	DEF JP_ENTRIES_IS_KEY_ITEM_ADDR    EQU $3121
ENDC
IF DEF(AKA_JP_REVA)
SECTION "JP List Menu Entries", ROM0[$193A]
	DEF JP_ENTRIES_GET_ITEM_NAME_ADDR  EQU $1ACB
	DEF JP_ENTRIES_GET_MOVE_NAME_ADDR  EQU $1B5B
	DEF JP_ENTRIES_LOAD_MON_DATA_ADDR  EQU $2D56
	DEF JP_ENTRIES_PRINT_LEVEL_ADDR    EQU $2EF0
	DEF JP_ENTRIES_IS_KEY_ITEM_ADDR    EQU $310F
ENDC

DEF JP_CANCELLED_MENU EQU $02
DEF JP_MOVESLISTMENU  EQU $01
DEF JP_PLAYER_PARTY_DATA EQU $00
DEF JP_BOX_DATA          EQU $02

ExitListMenu::
	ld a, [wCurrentMenuItem]
	ld [wChosenMenuItem], a
	ld a, JP_CANCELLED_MENU
	ld [wMenuExitMethod], a
	ld [wMenuWatchMovingOutOfBounds], a
	xor a
	ld [hJoy7], a
	ld hl, wStatusFlags5
	res JP_BIT_NO_TEXT_DELAY, [hl]
	call JP_LIST_BANKSWITCH_BACK_ADDR
	scf
	ret

PrintListMenuEntries::
	ld hl, $C3E1 ; hlcoord 5, 3
	ld b, $09
	ld c, $0E
	call ClearScreenArea
	ld a, [wListPointer]
	ld e, a
	ld a, [wListPointer + 1]
	ld d, a
	inc de
	ld a, [wListScrollOffset]
	ld c, a
	ld a, [wListMenuID]
	cp JP_ITEMLISTMENU
	ld a, c
	jr nz, .skipMultiplying
	sla a
	sla c
.skipMultiplying
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	ld hl, $C3F6 ; hlcoord 6, 4
	ld b, $04
.loop
	ld a, b
	ld [wWhichPokemon], a
	ld a, [de]
	ld [wNamedObjectIndex], a
	cp $FF
	jp z, .printCancelMenuItem
	push bc
	push de
	push hl
	push hl
	push de
	ld a, [wListMenuID]
	and a
	jr z, .pokemonPCMenu
	cp JP_MOVESLISTMENU
	jr z, .movesMenu
	call JP_ENTRIES_GET_ITEM_NAME_ADDR
	jr .placeNameString
.pokemonPCMenu
	push hl
	ld hl, wPartyCount
	ld a, [wListPointer]
	cp l
	ld hl, wPartyMonNicks
	jr z, .getPokemonName
	ld hl, wBoxMonNicks
.getPokemonName
	ld a, [wWhichPokemon]
	ld b, a
	ld a, $04
	sub b
	ld b, a
	ld a, [wListScrollOffset]
	add b
	call JP_LIST_GET_PARTY_MON_NAME_ADDR
	pop hl
	jr .placeNameString
.movesMenu
	call JP_ENTRIES_GET_MOVE_NAME_ADDR
.placeNameString
	call PlaceString
	pop de
	pop hl
	ld a, [wPrintItemPrices]
	and a
	jr z, .skipPrintingItemPrice
	push hl
	ld a, [de]
	ld de, $421C ; ItemPrices
	ld [wCurItem], a
	call JP_LIST_GET_ITEM_PRICE_ADDR
	pop hl
	ld bc, $0006
	add hl, bc
	ld c, $83
	call JP_QTY_PRINT_BCD_ADDR
	ld [hl], $F0 ; '円'
.skipPrintingItemPrice
	ld a, [wListMenuID]
	and a
	jr nz, .skipPrintingPokemonLevel
	ld a, [wNamedObjectIndex]
	push af
	push hl
	ld hl, wPartyCount
	ld a, [wListPointer]
	cp l
	ld a, JP_PLAYER_PARTY_DATA
	jr z, .next
	ld a, JP_BOX_DATA
.next
	ld [wMonDataLocation], a
	ld hl, wWhichPokemon
	ld a, [hl]
	ld b, a
	ld a, $04
	sub b
	ld b, a
	ld a, [wListScrollOffset]
	add b
	ld [hl], a
	call JP_ENTRIES_LOAD_MON_DATA_ADDR
	ld a, [wMonDataLocation]
	and a
	jr z, .skipCopyingLevel
	ld a, [wLoadedMonBoxLevel]
	ld [wLoadedMonLevel], a
.skipCopyingLevel
	pop hl
	ld bc, $0006
	add hl, bc
	call JP_ENTRIES_PRINT_LEVEL_ADDR
	pop af
	ld [wNamedObjectIndex], a
.skipPrintingPokemonLevel
	pop hl
	pop de
	inc de
	ld a, [wListMenuID]
	cp JP_ITEMLISTMENU
	jr nz, .nextListEntry
	ld a, [wNamedObjectIndex]
	ld [wCurItem], a
	call JP_ENTRIES_IS_KEY_ITEM_ADDR
	ld a, [wIsKeyItem]
	and a
	jr nz, .skipPrintingItemQuantity
	push hl
	ld bc, $0009
	add hl, bc
	ld a, $F1 ; '×'
	ld [hli], a
	ld a, [wNamedObjectIndex]
	push af
	ld a, [de]
	ld [wMaxItemQuantity], a
	push de
	ld de, wTempByteValue
	ld [de], a
	ld bc, $0102
	call PrintNumberAddr
	pop de
	pop af
	ld [wNamedObjectIndex], a
	pop hl
.skipPrintingItemQuantity
	inc de
	pop bc
	inc c
	push bc
	inc c
	ld a, [wMenuItemToSwap]
	and a
	jr z, .nextListEntry
	sla a
	cp c
	jr nz, .nextListEntry
	dec hl
	ld a, $EC ; unfilled/right swap arrow
	ld [hli], a
.nextListEntry
	ld bc, $0028 ; two tilemap rows
	add hl, bc
	pop bc
	inc c
	dec b
	jp nz, .loop
	ld bc, $FFF8
	add hl, bc
	ld a, $EE ; down arrow
	ld [hl], a
	ret
.printCancelMenuItem
	ld de, ListMenuCancelText
	jp PlaceString

ListMenuCancelText::
	db $D4, $D2, $D9, $50 ; "やめる@"
