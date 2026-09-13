# PocketMonsters-Aka-Disassembly

Complete disassembly and reconstruction project for **Pocket Monsters Aka (Japan)** and the verified international **Pokémon Red** releases.

The goal is to reconstruct each supported ROM into editable source form — code, data, text, graphics, audio, maps, scripts, tables, and build metadata — so a clean clone can eventually reproduce every supported build **without requiring a local `baserom.gb`**.

ROM binaries are read-only source references and are never committed.

## Verified source baselines

| Build ID | Release | Size | Banks | Header version | SHA-1 |
|---|---|---:|---:|---:|---|
| `aka-jp-rev0` | Pocket Monsters Aka (Japan) | 512 KiB | 32 | 0 | `0623ad12f48c259447980d68bd85ddbf8204b2cd` |
| `aka-jp-reva` | Pocket Monsters Aka (Japan) Rev A | 512 KiB | 32 | 1 | `ef74c79cded14204ac79e77f4964d9cb25003120` |
| `red-en-ue` | Pokémon Red Version (USA, Europe) | 1 MiB | 64 | 0 | `ea9bcae617fdf159b045185467ae58b2e4a48b9a` |
| `red-de` | Pokémon Rote Edition (Germany) | 1 MiB | 64 | 0 | `87d523fe1a0c548db7c5477b451ddec1eb083c06` |
| `red-it` | Pokémon Versione Rossa (Italy) | 1 MiB | 64 | 0 | `65b97cf8f2f1cff711a6d08c6c894c8ce65ce522` |
| `red-es` | Pokémon Edicion Roja (Spain) | 1 MiB | 64 | 0 | `fc17c5b904d551b1b908054ccd1c493f755f832a` |
| `red-fr` | Pokémon Version Rouge (France) | 1 MiB | 64 | 0 | `47a7622fa30e6402a3891fe65b3a930bf9bd7aec` |

Eight ROM files were supplied for analysis. The additional English copy is byte-identical to `red-en-ue` (same SHA-1 and MD5), so the source set contains **7 unique builds**.

## Reconstruction policy

- Keep all source ROMs read-only and outside Git.
- Never commit original or rebuilt `.gb`/`.gbc` ROM images.
- Recover ROM contents into meaningful, editable disassembly source wherever possible.
- Prefer structured RGBDS assembly, readable text source, PNG graphics, map/block data, audio sequence source, and explicit data tables over opaque byte dumps.
- Raw extraction is only an intermediate reconstruction stage and should be replaced by structured source as analysis progresses.
- Preserve build-specific differences instead of flattening revisions/localizations into one assumed layout.
- Verify completed outputs against the recorded SHA-1 values.
- When sprite/tile/font/UI graphics are recovered, commit the reconstructed image assets too (PNG plus the relevant 1bpp/2bpp conversion source, manifests, palettes/tilemaps where applicable). Graphics work is not considered complete with ASM metadata alone.
- Deduplicate graphics that are byte-identical across revisions/localizations; preserve genuinely different artwork as build-specific assets.

## Current status

Source inventory and header verification are complete for all 7 unique builds. **Bank 00 reconstruction is active.**

Recovered so far:

- common reset/interrupt vectors and cartridge entry point
- build-specific VBlank/Timer/Serial targets
- Japanese RST `$38` behavior and revision-specific `$0068-$00FF` residual data
- western `$0061-$00FF` High Home routines (`DisableLCD`, `EnableLCD`, sprite clearing/hiding, copy helpers)
- build-specific `_Start` code at `$0150`
- Japanese V1.0/V1.1 `$0153-$01C3` early Home routines
- Japanese V1.0/V1.1 `$01C4-$028B` collision-tile tables, reproduced exactly from structured source
- Japanese V1.0/V1.1 `$028C-$0358` banked copy and VBlank video-copy helpers
- Japanese `$0359-$03D1` interruption, tile-area, BG transfer, and screen-clear helpers with revision-dependent call targets preserved
- Japanese `$03D2-$04C8` text-box renderer, string-control dispatcher, and dakuten/handakuten kana conversion core
- Japanese `$04C9-$0773` name/control-token expansion, paragraph/scroll logic, `TextCommandProcessor`, sound/cry text commands, and complete text-command jump table
- Japanese `$0774-$09D9` BG-map addressing, row/column redraw, VBlank copy engines, overworld water/flower tile animation, embedded flower tiles, and `SoftReset`
- Japanese `$09DA-$0B3B` `Init`, VRAM/audio reset, full VBlank interrupt body, audio dispatch, play-time bank call, and `DelayFrame`
- Japanese `$0B3C-$0BA6` DMG palette load/fade routines and `FadePal1` through `FadePal8`
- Japanese Serial/link engine from `$0BA7` through the byte immediately before `Timer`: V1.0 `$0D99`, V1.1 `$0D87`, including the revision-specific layout of `Serial_ExchangeBytes`, link-menu synchronization, byte/nybble exchange, counters, and connection establishment
- Japanese Timer/audio dispatcher through the end of `PlaySound`: V1.0 `$0D9A-$0EBC`, V1.1 `$0D88-$0EAA`, including default map/bike/surf music selection, bank comparison, six-update pre-fade refresh, `PlayMusic`, and the three audio-engine `PlaySound` dispatch paths

The Japanese reconstruction is now structured continuously from `$0150` through the end of `PlaySound`: **V1.0 through `$0EBC` and V1.1 through `$0EAA`** (with the cartridge header region handled separately), plus the verified reset/vector and residual ranges before it.

See `analysis/bank00/` for verified offsets, revision differences, and range hashes. The active source is linked from `home.asm`.
