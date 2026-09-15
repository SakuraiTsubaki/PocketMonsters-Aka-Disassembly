; Japanese Red sprite compression/decompression engine in Bank 00.
; The algorithm is byte-identical between V1.0 and V1.1 after accounting for
; the $12-byte ROM0 relocation caused by the shorter V1.1 serial block.
;
; This is sprite-processing code only. Compressed sprite artwork lives in
; later ROM banks and will be exported as source tile data + PNG when reached.

IF DEF(AKA_JP_REV0)
SECTION "JP Sprite Decompression", ROM0[$0FCE]
ENDC
IF DEF(AKA_JP_REVA)
SECTION "JP Sprite Decompression", ROM0[$0FBC]
ENDC

DEF BIT_USE_SPRITE_BUFFER_2 EQU 0
DEF BIT_LAST_SPRITE_CHUNK   EQU 1

UncompressSpriteData::
	ld b, a
	ldh a, [hLoadedROMBank]
	push af
	ld a, b
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ld a, RAMG_SRAM_ENABLE
	ld [rRAMG], a
	xor a
	ld [rRAMB], a
	call _UncompressSpriteData
	pop af
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	ret

_UncompressSpriteData::
	ld hl, sSpriteBuffer1
	ld c, $10 ; LOW(2 * SPRITEBUFFERSIZE)
	ld b, $03 ; HIGH(2 * SPRITEBUFFERSIZE)
	xor a
	call FillMemoryAddr
	ld a, $01
	ld [wSpriteInputBitCounter], a
	ld a, $03
	ld [wSpriteOutputBitOffset], a
	xor a
	ld [wSpriteCurPosX], a
	ld [wSpriteCurPosY], a
	ld [wSpriteLoadFlags], a
	call ReadNextInputByte
	ld b, a
	and $0f
	add a
	add a
	add a
	ld [wSpriteHeight], a
	ld a, b
	swap a
	and $0f
	add a
	add a
	add a
	ld [wSpriteWidth], a
	call ReadNextInputBit
	ld [wSpriteLoadFlags], a

UncompressSpriteDataLoop::
	ld hl, sSpriteBuffer1
	ld a, [wSpriteLoadFlags]
	bit BIT_USE_SPRITE_BUFFER_2, a
	jr z, .useSpriteBuffer1
	ld hl, sSpriteBuffer2
.useSpriteBuffer1
	call StoreSpriteOutputPointer
	ld a, [wSpriteLoadFlags]
	bit BIT_LAST_SPRITE_CHUNK, a
	jr z, .startDecompression
	call ReadNextInputBit
	and a
	jr z, .unpackingMode0
	call ReadNextInputBit
	inc a
.unpackingMode0
	ld [wSpriteUnpackMode], a
.startDecompression
	call ReadNextInputBit
	and a
	jr z, .readRLEncodedZeros
.readNextInput
	call ReadNextInputBit
	ld c, a
	call ReadNextInputBit
	sla c
	or c
	and a
	jr z, .readRLEncodedZeros
	call WriteSpriteBitsToBuffer
	call MoveToNextBufferPosition
	jr .readNextInput
.readRLEncodedZeros
	ld c, $00
.countConsecutiveOnesLoop
	call ReadNextInputBit
	and a
	jr z, .countConsecutiveOnesFinished
	inc c
	jr .countConsecutiveOnesLoop
.countConsecutiveOnesFinished
	ld a, c
	add a
	ld hl, LengthEncodingOffsetList
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld a, [hli]
	ld e, a
	ld d, [hl]
	push de
	inc c
	ld e, $00
	ld d, e
.readNumberOfZerosLoop
	call ReadNextInputBit
	or e
	ld e, a
	dec c
	jr z, .readNumberOfZerosDone
	sla e
	rl d
	jr .readNumberOfZerosLoop
.readNumberOfZerosDone
	pop hl
	add hl, de
	ld e, l
	ld d, h
.writeZerosLoop
	ld b, e
	xor a
	call WriteSpriteBitsToBuffer
	ld e, b
	call MoveToNextBufferPosition
	dec de
	ld a, d
	and a
	jr nz, .continueLoop
	ld a, e
	and a
.continueLoop
	jr nz, .writeZerosLoop
	jr .readNextInput

MoveToNextBufferPosition::
	ld a, [wSpriteHeight]
	ld b, a
	ld a, [wSpriteCurPosY]
	inc a
	cp b
	jr z, .curColumnDone
	ld [wSpriteCurPosY], a
	ld a, [wSpriteOutputPtr]
	inc a
	ld [wSpriteOutputPtr], a
	ret nz
	ld a, [wSpriteOutputPtr + 1]
	inc a
	ld [wSpriteOutputPtr + 1], a
	ret
.curColumnDone
	xor a
	ld [wSpriteCurPosY], a
	ld a, [wSpriteOutputBitOffset]
	and a
	jr z, .bitOffsetsDone
	dec a
	ld [wSpriteOutputBitOffset], a
	ld hl, wSpriteOutputPtrCached
	ld a, [hli]
	ld [wSpriteOutputPtr], a
	ld a, [hl]
	ld [wSpriteOutputPtr + 1], a
	ret
.bitOffsetsDone
	ld a, $03
	ld [wSpriteOutputBitOffset], a
	ld a, [wSpriteCurPosX]
	add $08
	ld [wSpriteCurPosX], a
	ld b, a
	ld a, [wSpriteWidth]
	cp b
	jr z, .allColumnsDone
	ld a, [wSpriteOutputPtr]
	ld l, a
	ld a, [wSpriteOutputPtr + 1]
	ld h, a
	inc hl
	jp StoreSpriteOutputPointer
.allColumnsDone
	pop hl
	xor a
	ld [wSpriteCurPosX], a
	ld a, [wSpriteLoadFlags]
	bit BIT_LAST_SPRITE_CHUNK, a
	jr nz, .done
	xor $01
	set BIT_LAST_SPRITE_CHUNK, a
	ld [wSpriteLoadFlags], a
	jp UncompressSpriteDataLoop
.done
	jp UnpackSprite

WriteSpriteBitsToBuffer::
	ld e, a
	ld a, [wSpriteOutputBitOffset]
	and a
	jr z, .offset0
	cp $02
	jr c, .offset1
	jr z, .offset2
	rrc e
	rrc e
	jr .offset0
.offset1
	sla e
	sla e
	jr .offset0
.offset2
	swap e
.offset0
	ld a, [wSpriteOutputPtr]
	ld l, a
	ld a, [wSpriteOutputPtr + 1]
	ld h, a
	ld a, [hl]
	or e
	ld [hl], a
	ret

ReadNextInputBit::
	ld a, [wSpriteInputBitCounter]
	dec a
	jr nz, .curByteHasMoreBitsToRead
	call ReadNextInputByte
	ld [wSpriteInputCurByte], a
	ld a, $08
.curByteHasMoreBitsToRead
	ld [wSpriteInputBitCounter], a
	ld a, [wSpriteInputCurByte]
	rlca
	ld [wSpriteInputCurByte], a
	and $01
	ret

ReadNextInputByte::
	ld a, [wSpriteInputPtr]
	ld l, a
	ld a, [wSpriteInputPtr + 1]
	ld h, a
	ld a, [hli]
	ld b, a
	ld a, l
	ld [wSpriteInputPtr], a
	ld a, h
	ld [wSpriteInputPtr + 1], a
	ld a, b
	ret

LengthEncodingOffsetList::
	dw $0001, $0003, $0007, $000f
	dw $001f, $003f, $007f, $00ff
	dw $01ff, $03ff, $07ff, $0fff
	dw $1fff, $3fff, $7fff, $ffff

UnpackSprite::
	ld a, [wSpriteUnpackMode]
	cp $02
	jp z, UnpackSpriteMode2
	and a
	jp nz, XorSpriteChunks
	ld hl, sSpriteBuffer1
	call SpriteDifferentialDecode
	ld hl, sSpriteBuffer2

SpriteDifferentialDecode::
	xor a
	ld [wSpriteCurPosX], a
	ld [wSpriteCurPosY], a
	call StoreSpriteOutputPointer
	ld a, [wSpriteFlipped]
	and a
	jr z, .notFlipped
	ld hl, DecodeNybble0TableFlipped
	ld de, DecodeNybble1TableFlipped
	jr .storeDecodeTablesPointers
.notFlipped
	ld hl, DecodeNybble0Table
	ld de, DecodeNybble1Table
.storeDecodeTablesPointers
	ld a, l
	ld [wSpriteDecodeTable0Ptr], a
	ld a, h
	ld [wSpriteDecodeTable0Ptr + 1], a
	ld a, e
	ld [wSpriteDecodeTable1Ptr], a
	ld a, d
	ld [wSpriteDecodeTable1Ptr + 1], a
	ld e, $00
.decodeNextByteLoop
	ld a, [wSpriteOutputPtr]
	ld l, a
	ld a, [wSpriteOutputPtr + 1]
	ld h, a
	ld a, [hl]
	ld b, a
	swap a
	and $0f
	call DifferentialDecodeNybble
	swap a
	ld d, a
	ld a, b
	and $0f
	call DifferentialDecodeNybble
	or d
	ld b, a
	ld a, [wSpriteOutputPtr]
	ld l, a
	ld a, [wSpriteOutputPtr + 1]
	ld h, a
	ld a, b
	ld [hl], a
	ld a, [wSpriteHeight]
	add l
	jr nc, .noCarry
	inc h
.noCarry
	ld [wSpriteOutputPtr], a
	ld a, h
	ld [wSpriteOutputPtr + 1], a
	ld a, [wSpriteCurPosX]
	add $08
	ld [wSpriteCurPosX], a
	ld b, a
	ld a, [wSpriteWidth]
	cp b
	jr nz, .decodeNextByteLoop
	xor a
	ld e, a
	ld [wSpriteCurPosX], a
	ld a, [wSpriteCurPosY]
	inc a
	ld [wSpriteCurPosY], a
	ld b, a
	ld a, [wSpriteHeight]
	cp b
	jr z, .done
	ld a, [wSpriteOutputPtrCached]
	ld l, a
	ld a, [wSpriteOutputPtrCached + 1]
	ld h, a
	inc hl
	call StoreSpriteOutputPointer
	jr .decodeNextByteLoop
.done
	xor a
	ld [wSpriteCurPosY], a
	ret

DifferentialDecodeNybble::
	srl a
	ld c, $00
	jr nc, .evenNumber
	ld c, $01
.evenNumber
	ld l, a
	ld a, [wSpriteFlipped]
	and a
	jr z, .notFlipped
	bit 3, e
	jr .selectLookupTable
.notFlipped
	bit 0, e
.selectLookupTable
	ld e, l
	jr nz, .initialValue1
	ld a, [wSpriteDecodeTable0Ptr]
	ld l, a
	ld a, [wSpriteDecodeTable0Ptr + 1]
	jr .tableLookup
.initialValue1
	ld a, [wSpriteDecodeTable1Ptr]
	ld l, a
	ld a, [wSpriteDecodeTable1Ptr + 1]
.tableLookup
	ld h, a
	ld a, e
	add l
	ld l, a
	jr nc, .noCarry
	inc h
.noCarry
	ld a, [hl]
	bit 0, c
	jr nz, .selectLowNybble
	swap a
.selectLowNybble
	and $0f
	ld e, a
	ret

DecodeNybble0Table::
	db $01, $32, $76, $45, $fe, $cd, $89, $ba
DecodeNybble1Table::
	db $fe, $cd, $89, $ba, $01, $32, $76, $45
DecodeNybble0TableFlipped::
	db $08, $c4, $e6, $2a, $f7, $3b, $19, $d5
DecodeNybble1TableFlipped::
	db $f7, $3b, $19, $d5, $08, $c4, $e6, $2a

XorSpriteChunks::
	xor a
	ld [wSpriteCurPosX], a
	ld [wSpriteCurPosY], a
	call ResetSpriteBufferPointers
	ld a, [wSpriteOutputPtr]
	ld l, a
	ld a, [wSpriteOutputPtr + 1]
	ld h, a
	call SpriteDifferentialDecode
	call ResetSpriteBufferPointers
	ld a, [wSpriteOutputPtr]
	ld l, a
	ld a, [wSpriteOutputPtr + 1]
	ld h, a
	ld a, [wSpriteOutputPtrCached]
	ld e, a
	ld a, [wSpriteOutputPtrCached + 1]
	ld d, a
.xorChunksLoop
	ld a, [wSpriteFlipped]
	and a
	jr z, .notFlipped
	push de
	ld a, [de]
	ld b, a
	swap a
	and $0f
	call ReverseNybble
	swap a
	ld c, a
	ld a, b
	and $0f
	call ReverseNybble
	or c
	pop de
	ld [de], a
.notFlipped
	ld a, [hli]
	ld b, a
	ld a, [de]
	xor b
	ld [de], a
	inc de
	ld a, [wSpriteCurPosY]
	inc a
	ld [wSpriteCurPosY], a
	ld b, a
	ld a, [wSpriteHeight]
	cp b
	jr nz, .xorChunksLoop
	xor a
	ld [wSpriteCurPosY], a
	ld a, [wSpriteCurPosX]
	add $08
	ld [wSpriteCurPosX], a
	ld b, a
	ld a, [wSpriteWidth]
	cp b
	jr nz, .xorChunksLoop
	xor a
	ld [wSpriteCurPosX], a
	ret

ReverseNybble::
	ld de, NybbleReverseTable
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	ld a, [de]
	ret

ResetSpriteBufferPointers::
	ld a, [wSpriteLoadFlags]
	bit BIT_USE_SPRITE_BUFFER_2, a
	jr nz, .buffer2Selected
	ld de, sSpriteBuffer1
	ld hl, sSpriteBuffer2
	jr .storeBufferPointers
.buffer2Selected
	ld de, sSpriteBuffer2
	ld hl, sSpriteBuffer1
.storeBufferPointers
	ld a, l
	ld [wSpriteOutputPtr], a
	ld a, h
	ld [wSpriteOutputPtr + 1], a
	ld a, e
	ld [wSpriteOutputPtrCached], a
	ld a, d
	ld [wSpriteOutputPtrCached + 1], a
	ret

NybbleReverseTable::
	db $00, $08, $04, $0c, $02, $0a, $06, $0e
	db $01, $09, $05, $0d, $03, $0b, $07, $0f

UnpackSpriteMode2::
	call ResetSpriteBufferPointers
	ld a, [wSpriteFlipped]
	push af
	xor a
	ld [wSpriteFlipped], a
	ld a, [wSpriteOutputPtrCached]
	ld l, a
	ld a, [wSpriteOutputPtrCached + 1]
	ld h, a
	call SpriteDifferentialDecode
	call ResetSpriteBufferPointers
	pop af
	ld [wSpriteFlipped], a
	jp XorSpriteChunks

StoreSpriteOutputPointer::
	ld a, l
	ld [wSpriteOutputPtr], a
	ld [wSpriteOutputPtrCached], a
	ld a, h
	ld [wSpriteOutputPtr + 1], a
	ld [wSpriteOutputPtrCached + 1], a
	ret
