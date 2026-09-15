# Version Coverage

The two Japanese Pocket Monsters Aka revisions are independent immutable reference targets for source reconstruction.

| Target ID | Region | Language | Revision | Size | SHA-1 | SHA-256 | Status |
| --- | --- | --- | --- | ---: | --- | --- | --- |
| `aka-jpn-rev0` | Japan | Japanese | Rev 0 / header `$00` | 524,288 bytes | `0623ad12f48c259447980d68bd85ddbf8204b2cd` | `392ce450d708c8d127aaed7afc20001a48625bd83a5fa5325be82f5c0972ccfa` | Verified input identity; source reconstruction active |
| `aka-jpn-rev1` | Japan | Japanese | Rev 1 / Rev A / header `$01` | 524,288 bytes | `ef74c79cded14204ac79e77f4964d9cb25003120` | `751abb1fb2b2d6b91dc631fa10ed36bd07f682cb5c3febe6c8f0e3dabc1fae1c` | Verified input identity; source reconstruction active |

## Policy

- Rev 0 and Rev 1 are never flattened into one assumed Red ROM.
- Shared source is used only where byte identity has been verified across both targets.
- Revision-specific bytes, code, data, text, pointers and assets remain target-qualified.
- ROM binaries remain local/read-only and are never committed.
- Unknown ranges remain byte-exact `INCBIN` until replaced by verified reconstruction.
