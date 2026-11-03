# Aka FarCopyData reconstruction

aka-jp-rev0 is the Japanese origin reference. All 7 cataloged releases (Japanese, German, English, Spanish, French, Italian) verify the 24-byte FarCopyData wrapper immediately before CopyData. The wrapper saves the active ROM bank, selects the source bank from A, delegates the BC-byte transfer, and restores the previous bank. Addresses and hashes are preserved without publishing ROM bytes.
