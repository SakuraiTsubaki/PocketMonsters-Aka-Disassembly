; Japanese Red timer stub and Bank 00 audio dispatcher.
; V1.1 relocates this whole block $12 bytes earlier because of the shorter
; serial engine, but the logical layout is otherwise identical.

IF DEF(AKA_JP_REV0)
SECTION "JP Timer and Audio", ROM0[$0D9A]
ENDC
IF DEF(AKA_JP_REVA)
SECTION "JP Timer and Audio", ROM0[$0D88]
ENDC

Timer::
; The timer interrupt is effectively unused in normal play.
	reti

PlayDefaultMusic::
	call WaitForSoundToFinishAddr
	xor a
	ld c, a
	ld d, a
	ld [wLastMusicSoundID], a
	jr PlayDefaultMusicCommon

PlayDefaultMusicFadeOutCurrent::
	ld c, 10
	ld d, 0
	ld a, [wStatusFlags4]
	bit BIT_BATTLE_OVER_OR_BLACKOUT, a
	jr z, PlayDefaultMusicCommon
	xor a
	ld [wLastMusicSoundID], a
	ld c, 8
	ld d, c

PlayDefaultMusicCommon::
	ld a, [wWalkBikeSurfState]
	and a
	jr z, .walking
	cp $02
	jr z, .surfing
	ld a, MUSIC_BIKE_RIDING
	jr .next
.surfing
	ld a, MUSIC_SURFING
.next
	ld b, a
	ld a, d
	and a
	ld a, AUDIO3_BANK ; Bike/Surf music lives in audio bank $1F.
	jr nz, .next2
	ld [wAudioROMBank], a
.next2
	ld [wAudioSavedROMBank], a
	jr .next3
.walking
	ld a, [wMapMusicSoundID]
	ld b, a
	call CompareMapMusicBankWithCurrentBank
	jr c, .next4
.next3
	ld a, [wLastMusicSoundID]
	cp b
	ret z
.next4
	ld a, c
	ld [wAudioFadeOutControl], a
	ld a, b
	ld [wLastMusicSoundID], a
	ld [wNewSoundID], a
	jp PlaySound

UpdateMusic6Times::
	ld a, [wAudioROMBank]
	ld b, a
	cp AUDIO1_BANK
	jr nz, .checkForAudio2
	ld hl, Audio1_UpdateMusicAddr
	jr .next
.checkForAudio2
	cp AUDIO2_BANK
	jr nz, .audio3
	ld hl, Audio2_UpdateMusicAddr
	jr .next
.audio3
	ld hl, Audio3_UpdateMusicAddr
.next
	ld c, 6
.loop
	push bc
	push hl
	call BankswitchAddr
	pop hl
	pop bc
	dec c
	jr nz, .loop
	ret

CompareMapMusicBankWithCurrentBank::
	ld a, [wMapMusicROMBank]
	ld e, a
	ld a, [wAudioROMBank]
	cp e
	jr nz, .differentBanks
	ld [wAudioSavedROMBank], a
	and a
	ret
.differentBanks
	ld a, c
	and a
	ld a, e
	jr nz, .next
	ld [wAudioROMBank], a
.next
	ld [wAudioSavedROMBank], a
	scf
	ret

PlayMusic::
	ld b, a
	ld [wNewSoundID], a
	xor a
	ld [wAudioFadeOutControl], a
	ld a, c
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, b

PlaySound::
; Play/stop the requested music or SFX through whichever audio engine owns the
; currently selected audio ROM bank.
	push hl
	push de
	push bc
	ld b, a
	ld a, [wNewSoundID]
	and a
	jr z, .next
	xor a
	ld [wChannelSoundIDs + CHAN5], a
	ld [wChannelSoundIDs + CHAN6], a
	ld [wChannelSoundIDs + CHAN7], a
	ld [wChannelSoundIDs + CHAN8], a
.next
	ld a, [wAudioFadeOutControl]
	and a
	jr z, .noFadeOut
	ld a, [wNewSoundID]
	and a
	jr z, .done
	xor a
	ld [wNewSoundID], a
	ld a, [wLastMusicSoundID]
	cp $FF
	jr nz, .fadeOut
	xor a
	ld [wAudioFadeOutControl], a
.noFadeOut
	xor a
	ld [wNewSoundID], a
	ldh a, [hLoadedROMBank]
	ldh [hSavedROMBank], a
	ld a, [wAudioROMBank]
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	cp AUDIO1_BANK
	jr nz, .checkForAudio2
	ld a, b
	call Audio1_PlaySoundAddr
	jr .next2
.checkForAudio2
	cp AUDIO2_BANK
	jr nz, .audio3
	ld a, b
	call Audio2_PlaySoundAddr
	jr .next2
.audio3
	ld a, b
	call Audio3_PlaySoundAddr
.next2
	ldh a, [hSavedROMBank]
	ldh [hLoadedROMBank], a
	ld [rROMB], a
	jr .done
.fadeOut
	ld a, b
	ld [wLastMusicSoundID], a
	ld a, [wAudioFadeOutControl]
	ld [wAudioFadeOutCounterReloadValue], a
	ld [wAudioFadeOutCounter], a
	ld a, b
	ld [wAudioFadeOutControl], a
.done
	pop bc
	pop de
	pop hl
	ret
