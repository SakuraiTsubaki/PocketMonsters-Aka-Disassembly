; Home-bank Random wrapper reconstructed across all catalogued Red releases.
Random::
    push hl
    push de
    push bc
    farcall Random_
    ldh a, [hRandomAdd]
    pop bc
    pop de
    pop hl
    ret
