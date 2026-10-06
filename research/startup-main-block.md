# Japanese startup main block

The cartridge entry chain reaches `0x09DA`. This verified 52-byte basic
block disables interrupts, clears hardware registers, calls `0x0167`, sets
the stack, and clears the 8 KiB WRAM range beginning at `0xC000`. The block
ends at the conditional loop edge to `0x0A06`. RGBDS source and structural
evidence are retained without publishing a standalone ROM fragment. This does
not promote the release candidate to verified.

