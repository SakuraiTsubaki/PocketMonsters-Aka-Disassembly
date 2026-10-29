# Aka ClearScreen disassembly

`aka-jp-rev0` is the Japanese origin reference. All 7 cataloged releases (Japanese, German, English, Spanish, French, Italian) contain exactly one ROM0 routine with the 19-byte ClearScreen control structure. It fills the 20x18 tilemap with the release's blank tile and tail-jumps to Delay3. Maps preserve RAM addresses, tile values, targets and hashes without ROM bytes. Existing candidate status is retained and never promoted by a structural match.
