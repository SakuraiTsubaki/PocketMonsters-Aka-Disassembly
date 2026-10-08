# English main font

The official English Red retail ROM stores the main text font as 128 uncompressed 8×8 1bpp tiles. `FontGraphics` spans bank 4 addresses `0x5A80` through `0x5E80`, corresponding to file offsets `0x11A80` through `0x11E80`.

The boundary and loading format are corroborated by `pret/pokered` source commit `af519899719f0754965776faac0e836a3b906e6d` (`gfx/font.asm`, `home/load_font.asm`, and `gfx/font/font.png`) and symbols commit `9a0c03834a435e38564445053ae9f9ece9999909` (`pokered.sym`). Converting that source PNG tilewise to 1bpp produces one unique match in the verified English ROM at the documented offset.

The range SHA-256 is `7da47648890723845fd71777e0ef6616c38f145a02a2aa58ca71d3460381d898`. `graphics/font/main-font-en.png` is a deterministic 4× nearest-neighbour rendering. No ROM image or raw ROM range is published.
