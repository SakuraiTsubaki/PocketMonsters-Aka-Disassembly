# Title version graphics

The Japanese origin ROM and the English fallback ROM contain the same ten-tile, 80×8 1bpp `Red Version` graphic. The bytes are at `0x68000` in Japanese revision 0 and at `0x6802f` in the English release. Both ranges have SHA-256 `9bf9798802187f4072c0f734d94068745cdb5467be2c518ef9db282de2f1b229`.

The four European localizations place their localized version graphic at `0x6802f`: German `Rote Edition`, French `Version Rouge`, Spanish `Edición Roja`, and Italian `Versione Rossa`. German, French, and Italian use ten tiles; Spanish uses eight. Each PNG is generated directly from the verified local release and therefore preserves the localized lettering rather than substituting the English asset.

The identification is independently anchored to `Version_GFX` / `gfx/title/red_version.1bpp` in the public `pret/pokered` reconstruction and the German, French, and Spanish matching disassemblies maintained by `einstein95`. The Italian range is verified by its matching bank-relative position and the decoded `VERSIONE ROSSA` image. This commit preserves the ROM-derived visual result, not ROM bytes. The shared extractor records the exact ROM identity, range, source hash, tile layout, and deterministic PNG hash.

The matching range also occurs in the Japanese Green ROM, but it is not published here as a Green title asset: occurrence alone does not prove that the Green program displays it. That false-positive was excluded pending control-flow verification.

## Reproduction

Run `SakuraiTsubaki/Disassembly/tools/extract_gb_1bpp.py` with the offsets and verified ROM SHA-256 values recorded in `manifests/title-version-graphics.json`. No ROM image or raw range is stored in this repository.
