# Pocket Monsters Aka CallFunctionInTable

The Japanese release `aka-jp-rev0` is the origin reference. All 7 cataloged releases (Japanese, English, German, French, Italian, Spanish) contain exactly one ROM0 implementation. Each embedded return address equals function start + 16, proving the local return trampoline rather than matching only a wildcard byte pattern. Release identity, address, full routine hash and candidate status are retained without ROM bytes.
