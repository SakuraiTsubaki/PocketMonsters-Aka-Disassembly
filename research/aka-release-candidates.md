# Study: establish Pokémon Red release candidates

- Status: draft
- Release ID: aka-jp-rev0, aka-jp-rev1, red-en-rev0, red-de-rev0, red-es-rev0, red-fr-rev0, red-it-rev0
- Input SHA-256: recorded per release in `research/releases.csv`
- Last updated: 2026-09-18

## Question

Which locally available Japanese and localized Pokémon Red ROM images can be recorded as hash-identified release candidates without distributing ROM content?

## Environment and tool versions

- Host: Windows
- Hash implementation: PowerShell `Get-FileHash` using SHA-1 and SHA-256
- Header parser: PowerShell byte-array reads
- Repository baseline: `9fa0603c710009037df554e592d257e546c25043`

## Address convention

Game Boy cartridge header offsets are file offsets. The title was read from `0x0134..0x0143`, the mask ROM revision from `0x014C`, the header checksum from `0x014D`, and the global checksum from `0x014E..0x014F` in big-endian order.

## Exact procedure

For each legally obtained local `.gb` input:

1. Record byte length.
2. Compute SHA-1 and SHA-256 over the complete file.
3. Read the title, revision, header checksum, and global checksum fields.
4. Record only metadata and hashes in `research/releases.csv` and `project.json`.
5. Do not copy or commit ROM bytes.

Repository hashing can be reproduced for an individual file with:

```sh
python tools/hash_input.py path/to/legally-obtained-input
```

## Observations

| Release ID | Size | Revision | Header checksum | Global checksum |
| --- | ---: | ---: | --- | --- |
| aka-jp-rev0 | 524288 | 0 | 0x32 | 0xa2c1 |
| aka-jp-rev1 | 524288 | 1 | 0x31 | 0xb866 |
| red-en-rev0 | 1048576 | 0 | 0x20 | 0x91e6 |
| red-de-rev0 | 1048576 | 0 | 0x18 | 0x5cdc |
| red-es-rev0 | 1048576 | 0 | 0x18 | 0x384a |
| red-fr-rev0 | 1048576 | 0 | 0x18 | 0x7afc |
| red-it-rev0 | 1048576 | 0 | 0x18 | 0x89d2 |

All seven inputs expose the ASCII title `POKEMON RED`.

## Derived results

Seven distinct release candidates were identified: two Japanese revisions and one revision-zero image for each of English, German, Spanish, French, and Italian.

## Interpretation and confidence

The size, full-file hashes, and cartridge header fields were directly observed. Region and language labels are based on the local release labeling and remain candidate metadata pending independent confirmation. No candidate is marked verified.

## Reproduction

Recompute SHA-1 and SHA-256 independently and compare them with both `research/releases.csv` and `project.json`. Re-read the cartridge header offsets listed above.

## Limitations and next questions

- Independent hash confirmation is still required before changing status to `verified`.
- Nintendo logo and full header checksum validation should be automated.
- Catalog references should be cited without importing copyrighted ROM content.
- Bank mapping begins only after a release baseline is independently verified.
