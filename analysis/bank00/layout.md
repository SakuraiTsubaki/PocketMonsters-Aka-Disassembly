# Bank 00 layout — first recovered ranges

This document records ranges independently verified against the seven unique uploaded Red-family ROMs.

## Common vectors and entry header

All seven builds use `nop; jp $0150` at `$0100`. The reset slots at `$0000-$0037`, VBlank/LCD/Timer/Serial/Joypad vectors, and their build-specific handler targets are represented in `home/header.asm`.

The Japanese builds differ from the western builds at RST `$38`:

- Japanese V1.0/V1.1: `jp $F080` at `$0038`.
- Western builds: `rst $38` at `$0038`.

## Japanese `$0068-$00FF`

Japanese Red does not place the western `High Home` helpers after the Joypad vector. `$0061-$0067` is zero-filled and `$0068-$00FF` contains revision-specific residual bytes. They are preserved in `home/garbage_header.asm`.

- V1.0 SHA-1 for `$0068-$00FF`: `e825cf552841abf607fea09748fcae672cbe2b79`
- V1.1 SHA-1 for `$0068-$00FF`: `ab8bed6a4b09d119f383ca1f8b5c6050c0a83ee9`

## Western `$0061-$00BD`

English, German, Italian, Spanish, and French Red are byte-identical from `$0061-$00FF`. `$0061-$00BD` contains `DisableLCD`, `EnableLCD`, `ClearSprites`, `HideSprites`, `FarCopyData`, and `CopyData`; `$00BE-$00FF` is zero-filled. The reconstructed source is in `home/high_home.asm`.

SHA-1 for `$0061-$00FF` across all five western builds: `62518b31ffe74d9a3d075cb813d0a2f62f6e07df`.

## `_Start` at `$0150`

- Japanese V1.0/V1.1: `jp Init` with `Init = $09DA`.
- Western builds: CGB boot-register check, store to build-specific `wOnCGB`, then jump to build-specific `Init`.

The initial instructions are reconstructed in `home/start.asm`.

## External cross-checks

Semantic labels were cross-checked against the public `pret/pokered` disassembly and the public `Narishma-gb/pokegreen` Japanese Red/Green disassembly. Byte values, offsets, ROM hashes, and localization differences in this repository are independently verified from the supplied ROM files.
