# Game Boy header logo extraction

The selected Japanese Aka candidate contributes the fixed 48-byte header logo at ROM range `0x0104`–`0x0133`. The extractor decodes the data as twenty-four 4×4 one-bit tiles arranged 12×2, then writes a deterministic nearest-neighbor PNG. The manifest binds the full local ROM hash, source-slice hash, analysis report, and PNG hash without storing the ROM or raw ROM slice.

The PNG is 384×64 for inspection; its logical decoded raster is 48×8. Visual inspection confirmed the corrected tile ordering after rejecting an initial row-major interpretation.
