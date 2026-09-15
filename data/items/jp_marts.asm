; Japanese Red mart inventories embedded in Bank 00.
; V1.0/V1.1 are byte-identical. Each list is $FE, count, item IDs..., $FF.

IF DEF(AKA_JP_REV0)
SECTION "JP Mart Inventories", ROM0[$0ED6]
ENDC
IF DEF(AKA_JP_REVA)
SECTION "JP Mart Inventories", ROM0[$0EC4]
ENDC

MACRO jp_mart
	db $FE, _NARG
	db \#
	db $FF
ENDM

ViridianMartClerkText:: ; Poke Ball, Antidote, Parlyz Heal, Burn Heal
	jp_mart $04, $0B, $0F, $0C

PewterMartClerkText:: ; Poke Ball, Potion, Escape Rope, Antidote, Burn Heal, Awakening, Parlyz Heal
	jp_mart $04, $14, $1D, $0B, $0C, $0E, $0F

CeruleanMartClerkText:: ; Poke Ball, Potion, Repel, Antidote, Burn Heal, Awakening, Parlyz Heal
	jp_mart $04, $14, $1E, $0B, $0C, $0E, $0F

UnusedBikeShopClerkText:: ; Bicycle (unreferenced)
	jp_mart $06

VermilionMartClerkText:: ; Poke Ball, Super Potion, Ice Heal, Awakening, Parlyz Heal, Repel
	jp_mart $04, $13, $0D, $0E, $0F, $1E

LavenderMartClerkText:: ; Great Ball, Super Potion, Revive, Escape Rope, Super Repel, status heals
	jp_mart $03, $13, $35, $1D, $38, $0B, $0C, $0D, $0F

CeladonMart2FClerk1Text::
	jp_mart $03, $13, $35, $38, $0B, $0C, $0D, $0E, $0F

CeladonMart2FClerk2Text:: ; TM shop
	jp_mart $E8, $E9, $CA, $CF, $ED, $C9, $CD, $D1, $D9

CeladonMart4FClerkText:: ; Poke Doll + evolution stones
	jp_mart $33, $20, $21, $22, $2F

CeladonMart5FClerk1Text:: ; battle stat items
	jp_mart $2E, $37, $3A, $41, $42, $43, $44

CeladonMart5FClerk2Text:: ; vitamins
	jp_mart $24, $25, $26, $27

FuchsiaMartClerkText::
	jp_mart $02, $03, $13, $35, $34, $38

UnusedMartClerkText:: ; unreferenced
	jp_mart $03, $12, $13, $34, $35

CinnabarMartClerkText::
	jp_mart $02, $03, $12, $39, $1D, $34, $35

SaffronMartClerkText::
	jp_mart $03, $12, $39, $1D, $34, $35

IndigoPlateauLobbyClerkText::
	jp_mart $02, $03, $10, $11, $34, $35, $39

PURGE jp_mart
