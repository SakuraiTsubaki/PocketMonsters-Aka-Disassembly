; Japanese Red Bank 00 audio-volume fade handler.
; V1.1 is relocated $12 bytes earlier; logic is otherwise identical.

IF DEF(AKA_JP_REV0)
SECTION "JP Fade Audio", ROM0[$139C]
ENDC
IF DEF(AKA_JP_REVA)
SECTION "JP Fade Audio", ROM0[$138A]
ENDC

FadeOutAudio::
	ld a, [wAudioFadeOutControl]
	and a
	jr nz, .fadingOut
	ld a, [wStatusFlags2]
	bit 1, a ; no audio fade-out flag
	ret nz
	ld a, $77
	ldh [rAUDVOL], a
	ret
.fadingOut
	ld a, [wAudioFadeOutCounter]
	and a
	jr z, .counterReachedZero
	dec a
	ld [wAudioFadeOutCounter], a
	ret
.counterReachedZero
	ld a, [wAudioFadeOutCounterReloadValue]
	ld [wAudioFadeOutCounter], a
	ldh a, [rAUDVOL]
	and a
	jr z, .fadeOutComplete
	ld b, a
	and $0f
	dec a
	ld c, a
	ld a, b
	and $f0
	swap a
	dec a
	swap a
	or c
	ldh [rAUDVOL], a
	ret
.fadeOutComplete
	ld a, [wAudioFadeOutControl]
	ld b, a
	xor a
	ld [wAudioFadeOutControl], a
	ld a, $ff ; stop all music
	ld [wNewSoundID], a
	call PlaySound
	ld a, [wAudioSavedROMBank]
	ld [wAudioROMBank], a
	ld a, b
	ld [wNewSoundID], a
	jp PlaySound
