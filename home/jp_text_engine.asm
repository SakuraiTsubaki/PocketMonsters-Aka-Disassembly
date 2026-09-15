; Japanese Red V1.0/V1.1 text engine continuation.
; Reconstructed from ROM0 $04C9-$0773.
; The two revisions share identical logic/data in this range; only external
; call targets move between revisions and are selected in constants/builds.asm.

SECTION "JP Text Engine", ROM0[$04C9]

NullChar::
	ld b, h
	ld c, l
	pop hl
	ld de, TextIDErrorText
	dec de
	ret

TextIDErrorText::
; text_decimal hTextID, 1, 2 / "エラー" / done
	db $09, $8c, $ff, $12, $00, $83, $a5, $e3, $57

PrintPlayerName::
	push de
	ld de, wPlayerName
	jr PlaceCommandCharacter

PrintRivalName::
	push de
	ld de, wRivalName
	jr PlaceCommandCharacter

TrainerChar::
	push de
	ld de, TrainerCharText
	jr PlaceCommandCharacter

TMChar::
	push de
	ld de, TMCharText
	jr PlaceCommandCharacter

PCChar::
	push de
	ld de, PCCharText
	jr PlaceCommandCharacter

RocketChar::
	push de
	ld de, RocketCharText
	jr PlaceCommandCharacter

PlacePOKe::
	push de
	ld de, PlacePOKeText
	jr PlaceCommandCharacter

SixDotsChar::
	push de
	ld de, SixDotsCharText
	jr PlaceCommandCharacter

PlaceMoveTargetsName::
	ldh a, [hWhoseTurn]
	xor 1
	jr PlaceMoveUsersName.place

PlaceMoveUsersName::
	ldh a, [hWhoseTurn]

.place
	push de
	and a
	jr nz, .enemy
	ld de, wBattleMonNick
	jr PlaceCommandCharacter

.enemy
	ld de, EnemyText
	call PlaceString
	ld h, b
	ld l, c
	ld de, wEnemyMonNick

PlaceCommandCharacter::
	call PlaceString
	ld h, b
	ld l, c
	pop de
	inc de
	jp PlaceNextChar

; Encoded with the original Japanese Red character set.
TMCharText::      db $dc, $2b, $9d, $8b, $ab, $50 ; "わざマシン@"
TrainerCharText:: db $93, $a7, $e3, $94, $e3, $50 ; "トレーナー@"
PCCharText::      db $40, $8e, $89, $ab, $50      ; "パソコン@"
RocketCharText::  db $a8, $88, $ac, $93, $30, $de, $50 ; "ロケットだん@"
PlacePOKeText::   db $43, $88, $a1, $ab, $50      ; "ポケモン@"
SixDotsCharText:: db $75, $75, $50                ; "⋯⋯@"
EnemyText::       db $c3, $b7, $c9, $7f, $50      ; "てきの　@"

ContText::
	push de
	ld b, h
	ld c, l
	ld hl, ContCharText
	call TextCommandProcessor
	ld h, b
	ld l, c
	pop de
	inc de
	jp PlaceNextChar

ContCharText::
	db $00, $4b, $50, $50 ; TX_START, "<_CONT>@", TX_END

PromptText::
	ld a, [wLinkState]
	cp $04
	jp z, .ok
	ld a, $ee
	ld [wTileMap + 16 * 20 + 18], a
.ok
	call ProtectedDelay3
	call ManualTextScrollAddr
	ld a, $7f
	ld [wTileMap + 16 * 20 + 18], a

DoneText::
	pop hl
	ld de, .stop
	dec de
	ret
.stop
	db $50 ; TX_END

Paragraph::
	push de
	ld a, $ee
	ld [wTileMap + 16 * 20 + 18], a
	call ProtectedDelay3
	call ManualTextScrollAddr
	ld hl, wTileMap + 13 * 20 + 1
	ld bc, $0412
	call ClearScreenArea
	ld c, 20
	call DelayFramesAddr
	pop de
	ld hl, wTileMap + 14 * 20 + 1
	jp NextChar

_ContText::
	ld a, $ee
	ld [wTileMap + 16 * 20 + 18], a
	call ProtectedDelay3
	push de
	call ManualTextScrollAddr
	pop de
	ld a, $7f
	ld [wTileMap + 16 * 20 + 18], a

_ContTextNoPause::
	push de
	call ScrollTextUpOneLine
	call ScrollTextUpOneLine
	ld hl, wTileMap + 16 * 20 + 1
	pop de
	jp NextChar

ScrollTextUpOneLine::
	ld hl, wTileMap + 14 * 20
	ld de, wTileMap + 13 * 20
	ld b, 60
.copyText
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copyText
	ld hl, wTileMap + 16 * 20 + 1
	ld a, $7f
	ld b, 18
.clearText
	ld [hli], a
	dec b
	jr nz, .clearText
	ld b, 5
.WaitFrame
	call DelayFrameAddr
	dec b
	jr nz, .WaitFrame
	ret

ProtectedDelay3::
	push bc
	call Delay3Addr
	pop bc
	ret

TextCommandProcessor::
	ld a, [wLetterPrintingDelayFlags]
	push af
	set 1, a
	ld [wLetterPrintingDelayFlags], a
	ld a, c
	ld [wTextDest], a
	ld a, b
	ld [wTextDest + 1], a

NextTextCommand::
	ld a, [hli]
	cp $50 ; TX_END
	jr nz, .TextCommand
	pop af
	ld [wLetterPrintingDelayFlags], a
	ret

.TextCommand
	push hl
	ld hl, TextCommandJumpTable
	push bc
	add a
	ld b, 0
	ld c, a
	add hl, bc
	pop bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

TextCommand_BOX::
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	push hl
	ld h, d
	ld l, e
	call TextBoxBorder
	pop hl
	jr NextTextCommand

TextCommand_START::
	pop hl
	ld d, h
	ld e, l
	ld h, b
	ld l, c
	call PlaceString
	ld h, d
	ld l, e
	inc hl
	jr NextTextCommand

TextCommand_RAM::
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	ld h, b
	ld l, c
	call PlaceString
	pop hl
	jr NextTextCommand

TextCommand_BCD::
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld c, a
	call PrintBCDNumberAddr
	ld b, h
	ld c, l
	pop hl
	jr NextTextCommand

TextCommand_MOVE::
	pop hl
	ld a, [hli]
	ld [wTextDest], a
	ld c, a
	ld a, [hli]
	ld [wTextDest + 1], a
	ld b, a
	jp NextTextCommand

TextCommand_LOW::
	pop hl
	ld bc, wTileMap + 16 * 20 + 1
	jp NextTextCommand

TextCommand_PROMPT_BUTTON::
	ld a, [wLinkState]
	cp $04
	jp z, TextCommand_WAIT_BUTTON
	ld a, $ee
	ld [wTileMap + 16 * 20 + 18], a
	push bc
	call ManualTextScrollAddr
	pop bc
	ld a, $7f
	ld [wTileMap + 16 * 20 + 18], a
	pop hl
	jp NextTextCommand

TextCommand_SCROLL::
	ld a, $7f
	ld [wTileMap + 16 * 20 + 18], a
	call ScrollTextUpOneLine
	call ScrollTextUpOneLine
	pop hl
	ld bc, wTileMap + 16 * 20 + 1
	jp NextTextCommand

TextCommand_START_ASM::
	pop hl
	ld de, NextTextCommand
	push de
	jp hl

TextCommand_NUM::
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld b, a
	and $0f
	ld c, a
	ld a, b
	and $f0
	swap a
	set 6, a
	ld b, a
	call PrintNumberAddr
	ld b, h
	ld c, l
	pop hl
	jp NextTextCommand

TextCommand_PAUSE::
	push bc
	call Joypad
	ldh a, [hJoyHeld]
	and $03
	jr nz, .done
	ld c, 30
	call DelayFramesAddr
.done
	pop bc
	pop hl
	jp NextTextCommand

TextCommand_SOUND::
	pop hl
	push bc
	dec hl
	ld a, [hli]
	ld b, a
	push hl
	ld hl, TextCommandSounds
.loop
	ld a, [hli]
	cp b
	jr z, .play
	inc hl
	jr .loop

.play
	cp $14
	jr z, .pokemonCry
	cp $15
	jr z, .pokemonCry
	cp $16
	jr z, .pokemonCry
	ld a, [hl]
	call PlaySoundAddr
	call WaitForSoundToFinishAddr
	pop hl
	pop bc
	jp NextTextCommand

.pokemonCry
	push de
	ld a, [hl]
	call PlayCryAddr
	pop de
	pop hl
	pop bc
	jp NextTextCommand

TextCommandSounds::
	db $0b, $86
	db $12, $9a
	db $0e, $91
	db $0f, $86
	db $10, $89
	db $11, $94
	db $13, $98
	db $14, $a8
	db $15, $97
	db $16, $78

TextCommand_DOTS::
	pop hl
	ld a, [hli]
	ld d, a
	push hl
	ld h, b
	ld l, c

.loop
	ld a, $75
	ld [hli], a
	push de
	call Joypad
	pop de
	ldh a, [hJoyHeld]
	and $03
	jr nz, .next
	ld c, 10
	call DelayFramesAddr
.next
	dec d
	jr nz, .loop
	ld b, h
	ld c, l
	pop hl
	jp NextTextCommand

TextCommand_WAIT_BUTTON::
	push bc
	call ManualTextScrollAddr
	pop bc
	pop hl
	jp NextTextCommand

TextCommandJumpTable::
	dw TextCommand_START
	dw TextCommand_RAM
	dw TextCommand_BCD
	dw TextCommand_MOVE
	dw TextCommand_BOX
	dw TextCommand_LOW
	dw TextCommand_PROMPT_BUTTON
	dw TextCommand_SCROLL
	dw TextCommand_START_ASM
	dw TextCommand_NUM
	dw TextCommand_PAUSE
	dw TextCommand_SOUND
	dw TextCommand_DOTS
	dw TextCommand_WAIT_BUTTON
	dw TextCommand_SOUND
	dw TextCommand_SOUND
	dw TextCommand_SOUND
	dw TextCommand_SOUND
	dw TextCommand_SOUND
	dw TextCommand_SOUND
	dw TextCommand_SOUND
	dw TextCommand_SOUND
	dw TextCommand_SOUND
