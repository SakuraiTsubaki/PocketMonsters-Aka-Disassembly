# Red Multiply wrapper reconstruction

All seven catalogued Red releases contain one verified 13-byte home-bank `Multiply` wrapper. It preserves HL and BC, invokes the release-specific `_Multiply` target through `Bankswitch`, restores the registers, and returns. Japanese rev0/rev1 target bank `$0d:$7e73`; English, German, and Spanish target `$0d:$7d41`; French and Italian target `$0d:$7d4d`.

Japanese is the origin reference, with all five Western languages independently verified against their local ROM hashes. Naming and macro expansion follow `pret/pokered@af519899719f0754965776faac0e836a3b906e6d`, `home/math.asm` and `macros/farcall.asm`. No ROM bytes are published.
