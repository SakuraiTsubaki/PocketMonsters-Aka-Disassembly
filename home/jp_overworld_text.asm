; Japanese Red Bank 00 common overworld text immediately before the sprite
; decompression engine. Text bytes are kept explicit until the full Japanese
; charmap/text macro layer is reconstructed.

IF DEF(AKA_JP_REV0)
SECTION "JP Overworld Text", ROM0[$0F69]
ENDC
IF DEF(AKA_JP_REVA)
SECTION "JP Overworld Text", ROM0[$0F57]
ENDC

TextScriptEndingText::
	db $50 ; string terminator

TextScriptEnd::
	ld hl, TextScriptEndingText
	ret

ExclamationText:: ; "！"
	db $00, $E7, $57

GroundRoseText:: ; "どこかで　じめんがもりあがった！"
	db $00, $34, $BA, $B6, $33, $7F, $2C, $D2, $DE, $26, $D3, $D8, $B1, $26, $DF, $C0, $E7, $57

BoulderText:: ; "「かいりき」　で　うごかせるかも<⋯>"
	db $00, $70, $B6, $B2, $D8, $B7, $71, $7F, $33, $7F, $B3, $2A, $B6, $BE, $D9, $B6, $D3, $56, $57

MartSignText:: ; "#　グッズが　いっぱい！" / "フレンドリィショップ"
	db $00, $54, $7F, $07, $AC, $0C, $26, $7F, $B2, $DF, $44, $B2, $E7, $4F
	db $9B, $A7, $AB, $13, $D8, $B0, $8B, $AF, $AC, $42, $57

PokeCenterSignText:: ; "#の　たいりょく　かいふく！" / "#センター"
	db $00, $54, $C9, $7F, $C0, $B2, $D8, $E2, $B8, $7F, $B6, $B2, $CC, $B8, $E7, $4F
	db $54, $8D, $AB, $8F, $E3, $57

PickUpItemText::
	db $08 ; TX_START_ASM / text_asm
	ld a, $5C ; PREDEF_PICK_UP_ITEM
	call PredefAddr
	jp TextScriptEnd
