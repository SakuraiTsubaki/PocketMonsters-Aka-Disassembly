; Japanese Red Bank 00 inventory helper wrappers.
; V1.1 keeps the same logic but several external targets moved.

IF DEF(AKA_JP_REV0)
SECTION "JP Inventory Helpers", ROM0[$16A7]
	DEF JP_SUBTRACT_AMOUNT_PAID_TARGET EQU $6ABC
	DEF JP_DISPLAY_TEXT_BOX_ID_ADDR    EQU $3130
	DEF JP_PLAY_SOUND_WAIT_ADDR        EQU $3788
ENDC
IF DEF(AKA_JP_REVA)
SECTION "JP Inventory Helpers", ROM0[$1695]
	DEF JP_SUBTRACT_AMOUNT_PAID_TARGET EQU $6A61
	DEF JP_DISPLAY_TEXT_BOX_ID_ADDR    EQU $311E
	DEF JP_PLAY_SOUND_WAIT_ADDR        EQU $3776
ENDC

; Subtracts the pending purchase price from the player's money.
; The implementation lives in bank 1.
SubtractAmountPaidFromMoney::
	ld b, $01
	ld hl, JP_SUBTRACT_AMOUNT_PAID_TARGET
	jp BankswitchAddr

; Adds the sale total in hMoney to the player's money, redraws the money box,
; and plays the purchase/sale confirmation sound.
AddAmountSoldToMoney::
	ld de, wPlayerMoney + 2
	ld hl, hMoney + 2
	ld c, $03
	ld a, $0B ; PREDEF AddBCDPredef
	call PredefAddr
	ld a, $13 ; MONEY_BOX
	ld [wTextBoxID], a
	call JP_DISPLAY_TEXT_BOX_ID_ADDR
	ld a, $B2 ; SFX_PURCHASE
	call JP_PLAY_SOUND_WAIT_ADDR
	jp WaitForSoundToFinishAddr

; Remove an item/quantity from an inventory. The worker is bank 3:$4652.
RemoveItemFromInventory::
	ldh a, [hLoadedROMBank]
	push af
	ld a, $03
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	call $4652
	pop af
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ret

; Add an item/quantity to an inventory. Preserve the worker's flags while
; restoring the previous ROM bank, matching the original homecall_sf sequence.
AddItemToInventory::
	push bc
	ldh a, [hLoadedROMBank]
	push af
	ld a, $03
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	call $45E2
	pop bc
	ld a, b
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	pop bc
	ret
