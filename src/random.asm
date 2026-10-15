; Generation I hardware-divider RNG across all catalogued Red releases.
; JP rev0/rev1 bank $04:$7fea; EN $04:$7a8f; DE $04:$7a9d;
; ES $04:$7abe; FR $04:$7aa0; IT $04:$7ac3.

Random_::
    ldh a, [rDIV]
    ld b, a
    ldh a, [hRandomAdd]
    adc b
    ldh [hRandomAdd], a
    ldh a, [rDIV]
    ld b, a
    ldh a, [hRandomSub]
    sbc b
    ldh [hRandomSub], a
    ret
