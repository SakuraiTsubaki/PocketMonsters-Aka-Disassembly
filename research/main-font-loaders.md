# Main font loader provenance

Both Japanese Red revisions and all five official global Red releases were
scanned independently for the Gen I 1bpp font-loading routine. Every verified
ROM contains exactly one matching loader, and every loader resolves to the
source offset and source hash already recorded by its font extraction report.

The Japanese revisions load the shared origin font from `0x10B19`; the global
releases load their language-specific font from `0x11A80`. The loader offsets
also provide a code-level comparison point: Japanese Red matches the
corresponding Green revisions, while each global Red localization matches the
corresponding global Blue loader layout. Those relationships are observations
from independently hashed ROMs, not an assumption that the games are one
project.

The reports contain ROM identity, loader location, banked address, source
range, and hashes. They contain neither instruction bytes nor font bytes.

