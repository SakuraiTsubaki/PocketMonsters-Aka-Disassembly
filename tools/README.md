# Tools

- `hash_input.py` records local ROM size, SHA-1, and SHA-256 without copying it.
- `validate_repository.py` checks the target repository contract.
- `verify_artifacts.py` rejects ROM images and verifies PNG companions for
  encoded graphics.

Add deterministic target-specific tools here and commit their lawful non-ROM
outputs, logs, fixtures, and validation material. Promote reusable tools to
`SakuraiTsubaki/Disassembly` after they gain a target-neutral contract.

- `inspect_gb_rom.py` — reports full-file hashes and validates the Nintendo logo, cartridge header checksum, and global checksum without retaining ROM bytes. Use `--require-valid` to make validation failures return a nonzero status.
