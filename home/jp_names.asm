; Japanese Red Bank 00 name helpers.
; GetMonName, item/TM/HM naming, HM tests, and GetMoveName.

IF DEF(AKA_JP_REV0)
SECTION "JP Name Helpers", ROM0[$1AAB]
	DEF JP_NAMES_GET_NAME_ADDR    EQU $37B3
	DEF JP_NAMES_IS_IN_ARRAY_ADDR EQU $3DDB
ENDC
IF DEF(AKA_JP_REVA)
SECTION "JP Name Helpers", ROM0[$1A99]
	DEF JP_NAMES_GET_NAME_ADDR    EQU $37A1
	DEF JP_NAMES_IS_IN_ARRAY_ADDR EQU $3DC9
ENDC

GetMonName::
	push hl
	ldh a, [hLoadedROMBank]
	push af
	ld a, $0E ; BANK(MonsterNames)
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ld a, [wNamedObjectIndex]
	dec a
	ld hl, $5068 ; MonsterNames
	ld e, a
	ld d, $00
	add hl, de
	add hl, de
	add hl, de
	add hl, de
	add hl, de ; five bytes per stored species name
	ld de, wNameBuffer
	push de
	ld bc, $0005
	call CopyData
	ld hl, wNameBuffer + 5
	ld [hl], $50 ; '@'
	pop de
	pop af
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	pop hl
	ret

GetItemName::
	push hl
	push bc
	ld a, [wNamedObjectIndex]
	cp JP_HM01
	jr nc, .Machine
	ld [wNameListIndex], a
	ld a, JP_ITEM_NAME
	ld [wNameListType], a
	ld a, $01 ; BANK(ItemNames)
	ld [wPredefBank], a
	call JP_NAMES_GET_NAME_ADDR
	jr .Finish
.Machine
	call GetMachineName
.Finish
	ld de, wNameBuffer
	pop bc
	pop hl
	ret

GetMachineName::
	push hl
	push de
	push bc
	ld a, [wNamedObjectIndex]
	push af
	cp JP_TM01
	jr nc, .WriteTM
	add JP_NUM_HMS
	ld [wNamedObjectIndex], a
	ld hl, HiddenPrefix
	ld bc, $0006
	jr .WriteMachinePrefix
.WriteTM
	ld hl, TechnicalPrefix
	ld bc, $0005
.WriteMachinePrefix
	ld de, wNameBuffer
	call CopyData
	ld a, [wNamedObjectIndex]
	sub JP_TM01 - 1
	ld b, $F6 ; Japanese full-width '０'
.FirstDigit
	sub 10
	jr c, .SecondDigit
	inc b
	jr .FirstDigit
.SecondDigit
	add 10
	push af
	ld a, b
	ld [de], a
	inc de
	pop af
	ld b, $F6
	add b
	ld [de], a
	inc de
	ld a, $50
	ld [de], a
	pop af
	ld [wNamedObjectIndex], a
	pop bc
	pop de
	pop hl
	ret

TechnicalPrefix:: ; わざマシン
	db $DC, $2B, $9D, $8B, $AB
HiddenPrefix:: ; ひでんマシン
	db $CB, $33, $DE, $9D, $8B, $AB

IsItemHM::
	cp JP_HM01
	jr c, .notHM
	cp JP_TM01
	ret
.notHM
	and a
	ret

IsMoveHM::
	ld hl, HMMoves
	ld de, $0001
	jp JP_NAMES_IS_IN_ARRAY_ADDR

HMMoves::
	db $0F, $13, $39, $46, $94, $FF

GetMoveName::
	push hl
	ld a, JP_MOVE_NAME
	ld [wNameListType], a
	ld a, [wNamedObjectIndex]
	ld [wNameListIndex], a
	ld a, $04 ; BANK(MoveNames)
	ld [wPredefBank], a
	call JP_NAMES_GET_NAME_ADDR
	ld de, wNameBuffer
	pop hl
	ret
