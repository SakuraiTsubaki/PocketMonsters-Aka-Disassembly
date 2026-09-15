# Project Standards

These standards define the common baseline for the repository.

## Naming and layout

- Use stable, descriptive, machine-friendly paths.
- Prefer ASCII-safe generic directory and tooling names unless verified source conventions require otherwise.
- Avoid spaces in machine-oriented paths.
- Preserve meaningful original IDs, indices, symbols, and archive/member identifiers.
- Represent material region, language, revision, release, or version differences in paths or metadata.
- Do not force another generation or platform's internal layout onto this target.

## Source and generated material

- Prefer editable source plus reproducible conversion over opaque output.
- Generated files should identify their source and generation method.
- Keep scripts and tools required to regenerate important outputs.
- Human-reviewable previews such as PNG files are welcome when provenance remains clear.

## Deduplication

Store byte-identical material once when practical and reference it from manifests or indexes. Visual similarity alone is not sufficient evidence for deduplication.

## Evidence

Separate confirmed observations from hypotheses. Use `unknown` or `TBD` rather than inventing metadata. Record hashes, addresses, offsets, symbols, commands, or other evidence when they materially support a claim.

## Repository safety

Do not commit retail ROM images, rebuilt playable ROM images, console keys, or equivalent complete game-image containers. Reconstructed source, analysis, tooling, manifests, documentation, patches, and reviewable derived assets are allowed when appropriate.
