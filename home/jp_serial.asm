; Japanese Red V1.0/V1.1 serial/link engine.
; The two revisions share the same Serial interrupt entry at $0BA7 but differ
; structurally in Serial_ExchangeBytes and in where jp_serial2.asm is placed.

SECTION "JP Serial", ROM0[$0BA7]

Serial::
	push af
	push bc
	push de
	push hl
	ldh a, [hSerialConnectionStatus]
	inc a
	jr z, .connectionNotYetEstablished
	ldh a, [rSB]
	ldh [hSerialReceiveData], a
	ldh a, [hSerialSendData]
	ldh [rSB], a
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr z, .done
	ld a, SC_START | SC_EXTERNAL
	ldh [rSC], a
	jr .done
.connectionNotYetEstablished
	ldh a, [rSB]
	ldh [hSerialReceiveData], a
	ldh [hSerialConnectionStatus], a
	cp USING_INTERNAL_CLOCK
	jr z, .usingInternalClock
	xor a
	ldh [rSB], a
	ld a, $03
	ldh [rDIV], a
.waitLoop
	ldh a, [rDIV]
	bit 7, a
	jr nz, .waitLoop
	ld a, SC_START | SC_EXTERNAL
	ldh [rSC], a
	jr .done
.usingInternalClock
	xor a
	ldh [rSB], a
.done
	ld a, $01
	ldh [hSerialReceivedNewData], a
	ld a, SERIAL_NO_DATA_BYTE
	ldh [hSerialSendData], a
	pop hl
	pop de
	pop bc
	pop af
	reti

Serial_ExchangeBytes::
; hl = send data, de = receive data, bc = length.
	ld a, 1
	ldh [hSerialIgnoringInitialData], a
.loop
	ld a, [hl]
	ldh [hSerialSendData], a
	call Serial_ExchangeByte
	push bc
	ld b, a
	inc hl
	ld a, 48
.waitLoop
	dec a
	jr nz, .waitLoop
	ldh a, [hSerialIgnoringInitialData]
	and a
	ld a, b
	pop bc
	jr z, .storeReceivedByte
	dec hl
	cp SERIAL_PREAMBLE_BYTE
	jr nz, .loop
	xor a
	ldh [hSerialIgnoringInitialData], a
	jr .loop
.storeReceivedByte

IF DEF(AKA_JP_REV0)
; Rev 0-only, effectively unused compatibility path. This exact 18-byte block
; is absent from Rev A and accounts for the later ROM0 address shift.
	push af
	ld a, [wLinkState]
	cp LINK_STATE_RESET
	jr nz, .next
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr nz, .next
	ld de, wNameBuffer
.next
	pop af
ENDC

	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

IF DEF(AKA_JP_REV0)
	INCLUDE "home/jp_serial2.asm"
ENDC

Serial_ExchangeByte::
	xor a
	ldh [hSerialReceivedNewData], a
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr nz, .loop
	ld a, SC_START | SC_INTERNAL
	ldh [rSC], a
.loop
	ldh a, [hSerialReceivedNewData]
	and a
	jr nz, .ok
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr nz, .doNotIncrementUnknownCounter
	call IsUnknownCounterZero
	jr z, .doNotIncrementUnknownCounter
	call WaitLoop_15Iterations
	push hl
	ld hl, wUnknownSerialCounter + 1
	inc [hl]
	jr nz, .noCarry
	dec hl
	inc [hl]
.noCarry
	pop hl
	call IsUnknownCounterZero
	jr nz, .loop
	jp SetUnknownCounterToFFFF
.doNotIncrementUnknownCounter
	ldh a, [rIE]
	and IE_SERIAL | IE_TIMER | IE_STAT | IE_VBLANK
	cp IE_SERIAL
	jr nz, .loop
	ld a, [wUnknownSerialCounter2]
	dec a
	ld [wUnknownSerialCounter2], a
	jr nz, .loop
	ld a, [wUnknownSerialCounter2 + 1]
	dec a
	ld [wUnknownSerialCounter2 + 1], a
	jr nz, .loop
	ldh a, [hSerialConnectionStatus]
	cp USING_EXTERNAL_CLOCK
	jr z, .ok
	ld a, $FF
.waitLoop
	dec a
	jr nz, .waitLoop
.ok
	xor a
	ldh [hSerialReceivedNewData], a
	ldh a, [rIE]
	and IE_SERIAL | IE_TIMER | IE_STAT | IE_VBLANK
	sub IE_SERIAL
	jr nz, .skipReloadingUnknownCounter2
	ld [wUnknownSerialCounter2], a
	ld a, $50
	ld [wUnknownSerialCounter2 + 1], a
.skipReloadingUnknownCounter2
	ldh a, [hSerialReceiveData]
	cp SERIAL_NO_DATA_BYTE
	ret nz
	call IsUnknownCounterZero
	jr z, .done
	push hl
	ld hl, wUnknownSerialCounter + 1
	ld a, [hl]
	dec a
	ld [hld], a
	inc a
	jr nz, .noBorrow
	dec [hl]
.noBorrow
	pop hl
	call IsUnknownCounterZero
	jr z, SetUnknownCounterToFFFF
.done
	ldh a, [rIE]
	and IE_SERIAL | IE_TIMER | IE_STAT | IE_VBLANK
	cp IE_SERIAL
	ld a, SERIAL_NO_DATA_BYTE
	ret z
	ld a, [hl]
	ldh [hSerialSendData], a
	call DelayFrame
	jp Serial_ExchangeByte

WaitLoop_15Iterations::
	ld a, 15
.waitLoop
	dec a
	jr nz, .waitLoop
	ret

IsUnknownCounterZero::
	push hl
	ld hl, wUnknownSerialCounter
	ld a, [hli]
	or [hl]
	pop hl
	ret

SetUnknownCounterToFFFF::
; A is always zero on entry.
	dec a
	ld [wUnknownSerialCounter], a
	ld [wUnknownSerialCounter + 1], a
	ret

IF DEF(AKA_JP_REVA)
	INCLUDE "home/jp_serial2.asm"
ENDC

Serial_ExchangeNybble::
	call .doExchange
	ld a, [wSerialExchangeNybbleSendData]
	add $60
	ldh [hSerialSendData], a
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	jr nz, .doExchange
	ld a, SC_START | SC_INTERNAL
	ldh [rSC], a
.doExchange
	ldh a, [hSerialReceiveData]
	ld [wSerialExchangeNybbleTempReceiveData], a
	and $F0
	cp $60
	ret nz
	xor a
	ldh [hSerialReceiveData], a
	ld a, [wSerialExchangeNybbleTempReceiveData]
	and $0F
	ld [wSerialExchangeNybbleReceiveData], a
	ret

Serial_SendZeroByte::
	xor a
	ldh [hSerialSendData], a
	ldh a, [hSerialConnectionStatus]
	cp USING_INTERNAL_CLOCK
	ret nz
	ld a, SC_START | SC_INTERNAL
	ldh [rSC], a
	ret

Serial_TryEstablishingExternallyClockedConnection::
	ld a, ESTABLISH_CONNECTION_WITH_EXTERNAL_CLOCK
	ldh [rSB], a
	xor a
	ldh [hSerialReceiveData], a
	ld a, SC_START | SC_EXTERNAL
	ldh [rSC], a
	ret
