; Link-menu synchronization block.
; Rev 0 places this block before Serial_ExchangeByte; Rev A moves the same
; logical block after SetUnknownCounterToFFFF. jp_serial.asm includes this file
; at the correct revision-dependent position.

Serial_ExchangeLinkMenuSelection::
; Send the link-menu selection three times and retain two received bytes.
	ld hl, wLinkMenuSelectionSendBuffer
	ld de, wLinkMenuSelectionReceiveBuffer
	ld c, 2
	ld a, 1
	ldh [hSerialIgnoringInitialData], a
.loop
	call DelayFrame
	ld a, [hl]
	ldh [hSerialSendData], a
	call Serial_ExchangeByte
	ld b, a
	inc hl
	ldh a, [hSerialIgnoringInitialData]
	and a
	xor a
	ldh [hSerialIgnoringInitialData], a
	jr nz, .loop
	ld a, b
	ld [de], a
	inc de
	dec c
	jr nz, .loop
	ret

Serial_PrintWaitingTextAndSyncAndExchangeNybble::
	call SaveScreenTilesToBuffer1Addr
; callfar PrintWaitingText, expanded explicitly until the shared farcall macro
; layer is reconstructed in this repository.
	ld hl, PrintWaitingTextAddr
	ld b, PrintWaitingTextBank
	call BankswitchAddr
	call Serial_SyncAndExchangeNybble
	jp LoadScreenTilesFromBuffer1Addr

Serial_SyncAndExchangeNybble::
	ld a, $FF
	ld [wSerialExchangeNybbleReceiveData], a
.loop1
	call Serial_ExchangeNybble
	call DelayFrame
	call IsUnknownCounterZero
	jr z, .next1
	push hl
	ld hl, wUnknownSerialCounter + 1
	dec [hl]
	jr nz, .next2
	dec hl
	dec [hl]
	jr nz, .next2
	pop hl
	xor a
	jp SetUnknownCounterToFFFF
.next2
	pop hl
.next1
	ld a, [wSerialExchangeNybbleReceiveData]
	inc a
	jr z, .loop1
	ld b, 10
.loop2
	call DelayFrame
	call Serial_ExchangeNybble
	dec b
	jr nz, .loop2
	ld b, 10
.loop3
	call DelayFrame
	call Serial_SendZeroByte
	dec b
	jr nz, .loop3
	ld a, [wSerialExchangeNybbleReceiveData]
	ld [wSerialSyncAndExchangeNybbleReceiveData], a
	ret
