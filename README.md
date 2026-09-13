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

## Current status

Source inventory and header verification are complete for all 7 unique builds. **Bank 00** is the first active reconstruction target.
