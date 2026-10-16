# Red Divide wrapper reconstruction

All seven Red releases place `Divide` immediately after `Multiply`. Japanese rev0/rev1 use a 27-byte early homecall expansion with an absolute read of `hLoadedROMBank`; the five localized releases use the 26-byte `ldh` inline expansion. Both forms save the active bank, select bank `$0d`, call the release-specific `_Divide`, restore the bank, restore AF/BC/DE/HL, and return.

Japanese is the origin reference; English, German, Spanish, French, and Italian are independently verified. Naming follows `pret/pokered@af519899719f0754965776faac0e836a3b906e6d`, `home/math.asm` and `macros/farcall.asm`. No ROM bytes are published.
