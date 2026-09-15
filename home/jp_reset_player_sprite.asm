; Japanese Red player sprite-state reset immediately after the sprite
; decompression engine. V1.1 is relocated $12 bytes earlier.

IF DEF(AKA_JP_REV0)
SECTION "JP Reset Player Sprite", ROM0[$136B]
ENDC
IF DEF(AKA_JP_REVA)
SECTION "JP Reset Player Sprite", ROM0[$1359]
ENDC

ResetPlayerSpriteData::
	ld hl, wSpriteStateData1
	call ResetPlayerSpriteData_ClearSpriteData
	ld hl, wSpriteStateData2
	call ResetPlayerSpriteData_ClearSpriteData
	ld a, $01
	ld [wSpritePlayerStateData1PictureID], a
	ld [wSpritePlayerStateData2ImageBaseOffset], a
	ld hl, wSpritePlayerStateData1YPixels
	ld [hl], $3c
	inc hl
	inc hl
	ld [hl], $40
	ret

ResetPlayerSpriteData_ClearSpriteData::
	ld bc, SPRITESTATEDATA1_LENGTH
	xor a
	jp FillMemoryAddr
