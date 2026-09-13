; Japanese Red Bank 00 quantity/price selector used by list menus.

IF DEF(AKA_JP_REV0)
SECTION "JP List Quantity Menu", ROM0[$186A]
	DEF JP_QTY_JOYPAD_LOW_SENSITIVITY_ADDR EQU $3879
	DEF JP_QTY_PRINT_BCD_ADDR               EQU $2FC4
	DEF JP_QTY_PRINT_NUMBER_ADDR            EQU $3C8F
ENDC
IF DEF(AKA_JP_REVA)
SECTION "JP List Quantity Menu", ROM0[$1858]
	DEF JP_QTY_JOYPAD_LOW_SENSITIVITY_ADDR EQU $3867
	DEF JP_QTY_PRINT_BCD_ADDR               EQU $2FB2
	DEF JP_QTY_PRINT_NUMBER_ADDR            EQU $3C7D
ENDC

DEF JP_PRICEDITEMLISTMENU EQU $02

DisplayChooseQuantityMenu::
	ld hl, $C463 ; hlcoord 15, 9
	ld b, $01
	ld c, $03
	ld a, [wListMenuID]
	cp JP_PRICEDITEMLISTMENU
	jr nz, .drawTextBox
	ld hl, $C45B ; hlcoord 7, 9
	ld b, $01
	ld c, $0B
.drawTextBox
	call TextBoxBorder
	ld hl, $C478 ; hlcoord 16, 10
	ld a, [wListMenuID]
	cp JP_PRICEDITEMLISTMENU
	jr nz, .printInitialQuantity
	ld a, $F0 ; '円'
	ld [$C47A], a ; hlcoord 18, 10
	ld hl, $C470 ; hlcoord 8, 10
.printInitialQuantity
	ld de, InitialQuantityText
	call PlaceString
	xor a
	ld [wItemQuantity], a
	jp .incrementQuantity
.waitForKeyPressLoop
	call JP_QTY_JOYPAD_LOW_SENSITIVITY_ADDR
	ldh a, [hJoyPressed]
	bit 0, a ; A
	jp nz, .buttonAPressed
	bit 1, a ; B
	jp nz, .buttonBPressed
	bit 6, a ; UP
	jr nz, .incrementQuantity
	bit 7, a ; DOWN
	jr nz, .decrementQuantity
	jr .waitForKeyPressLoop
.incrementQuantity
	ld a, [wMaxItemQuantity]
	inc a
	ld b, a
	ld hl, wItemQuantity
	inc [hl]
	ld a, [hl]
	cp b
	jr nz, .handleNewQuantity
	ld a, $01
	ld [hl], a
	jr .handleNewQuantity
.decrementQuantity
	ld hl, wItemQuantity
	dec [hl]
	jr nz, .handleNewQuantity
	ld a, [wMaxItemQuantity]
	ld [hl], a
.handleNewQuantity
	ld hl, $C479 ; hlcoord 17, 10
	ld a, [wListMenuID]
	cp JP_PRICEDITEMLISTMENU
	jr nz, .printQuantity
.printPrice
	ld c, $03
	ld a, [wItemQuantity]
	ld b, a
	ld hl, hMoney
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
.addLoop
	ld de, hMoney + 2
	ld hl, hItemPrice + 2
	push bc
	ld a, $0B ; PREDEF AddBCDPredef
	call PredefAddr
	pop bc
	dec b
	jr nz, .addLoop
	ldh a, [hHalveItemPrices]
	and a
	jr z, .skipHalvingPrice
	xor a
	ldh [hDivideBCDDivisor], a
	ldh [hDivideBCDDivisor + 1], a
	ld a, $02
	ldh [hDivideBCDDivisor + 2], a
	ld a, $0D ; PREDEF DivideBCDPredef3
	call PredefAddr
	ldh a, [hDivideBCDQuotient]
	ldh [hMoney], a
	ldh a, [hDivideBCDQuotient + 1]
	ldh [hMoney + 1], a
	ldh a, [hDivideBCDQuotient + 2]
	ldh [hMoney + 2], a
.skipHalvingPrice
	ld hl, $C474 ; hlcoord 12, 10
	ld de, SpacesBetweenQuantityAndPriceText
	call PlaceString
	ld de, hMoney
	ld c, $83 ; 3 BCD bytes, leading zeroes
	call JP_QTY_PRINT_BCD_ADDR
	ld hl, $C471 ; hlcoord 9, 10
.printQuantity
	ld de, wItemQuantity
	ld bc, $8102 ; one byte, two digits, leading zeroes
	call JP_QTY_PRINT_NUMBER_ADDR
	jp .waitForKeyPressLoop
.buttonAPressed
	xor a
	ret
.buttonBPressed
	ld a, $FF
	ret

InitialQuantityText::
	db $F1, $F6, $F7, $50 ; "×０１@"

SpacesBetweenQuantityAndPriceText::
	db $7F, $7F, $7F, $7F, $7F, $7F, $7F, $50
