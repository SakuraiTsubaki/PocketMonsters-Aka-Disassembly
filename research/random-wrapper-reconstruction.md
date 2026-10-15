# Red Random wrapper reconstruction

All seven SHA-256-gated Red releases contain exactly one 17-byte home-bank wrapper that preserves BC, DE, and HL, far-calls the already verified `Random_`, returns `hRandomAdd=$ffd3` in A, and restores all saved registers. Japanese rev0/rev1 use `$3e8c`/`$3e7a`; English `$3e5c`; German `$3e76`; Spanish `$3e7b`; French `$3e79`; Italian `$3e74`. The reports retain each build's distinct `Bankswitch` address.

The source basis is `pret/pokered@af519899719f0754965776faac0e836a3b906e6d`, `home/random.asm`, with `macros/farcall.asm` explaining the expansion. Japanese is the origin reference; because Generation I has no official Korean release, English precedes the remaining official languages. No ROM bytes are published.
