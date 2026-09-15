# Project Status

## Current stage

**Bank-by-bank disassembly in progress**

The byte-exact 32-bank RGBDS baseline is established for both Japanese Red
revisions. Bank `$00` source reconstruction has started from verified ROM bytes.

## Coverage

| Area | Status |
| --- | --- |
| Version/revision inventory | Established for Japanese Rev 0 and Rev A |
| ROM / bank / section mapping | 32 banks mapped; revision byte-diff inventory established |
| Code reconstruction | **In progress — Bank `$00`** |
| Data reconstruction | Pending structural identification |
| Scripts / events | Not started |
| Graphics / assets | Not started |
| Audio / resources | Not started |
| Maps / world data | Not started |
| Build / matching verification | Byte-exact INCBIN baseline established; reconstructed ranges require RGBDS rebuild verification |

## Bank `$00` progress

The shared Rev 0 / Rev A range `$0150-$01C3` has been replaced with labeled
RGBDS source in `src/banks/bank00.asm`.

- `$0150`: cartridge entry jump
- `$0153-$0166`: temporary ROM-bank switch / call / restore sequence
- `$0167-$0180`: LCD-disable sequence
- `$0181-$0187`: LCD-enable sequence
- `$0188-$0192`: `$C300` buffer clear loop
- `$0193-$01A2`: stride-4 initialization loop over `$C300-$C39F`
- `$01A3-$01C3`: banked byte-copy routine

The 116 reconstructed bytes are identical in both supplied Japanese revisions.
All not-yet-reconstructed Bank `$00` bytes remain covered by `INCBIN`, preserving
the original image on each target.

## Validation levels

Use the repository-wide verification levels: **Hypothesis**, **Observed**,
**Reproduced**, and **Matched**.

Current Bank `$00` source status is **Observed** from both supplied ROMs. It
becomes **Matched** after a local RGBDS rebuild reproduces both target hashes.

## Next milestone

Continue Bank `$00` from `$01C4` forward, separating code from tables/data and
recording Rev 0 / Rev A divergence points without forcing false commonality.
