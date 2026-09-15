# Contributing

Contributions should improve the accuracy, readability, reproducibility, or documentation of the disassembly without obscuring target-specific differences.

## Good contributions

- structured assembly/source reconstruction
- confirmed symbol naming and comments
- data-format, script, text, graphics, audio, or map research
- build and matching improvements
- extraction/conversion/verification tools
- manifests, checksums, tests, and documentation

## Requirements

- Identify the relevant game version, region, language, revision, or release when the change is target-specific.
- Separate verified findings from hypotheses.
- Preserve real revision/localization differences.
- Prefer small, reviewable commits.
- Document commands, offsets, symbols, hashes, or other evidence when practical.
- Keep generated data reproducible where practical.
- Do not commit retail or rebuilt ROM images, console keys, or other redistributable game binaries.

For graphics and sprite work, include human-viewable PNGs alongside reconstructed graphics source when practical, and verify byte/hash identity before deduplicating shared assets.

See `docs/README.md`, `docs/DISASSEMBLY_STANDARDS.md`, `docs/BUILD_AND_MATCHING.md`, and `docs/VERIFICATION.md` for project-wide guidance.
