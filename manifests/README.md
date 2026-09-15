# Manifests

Manifests provide machine-readable identity, provenance, generation, and verification metadata for project artifacts.

Useful fields may include:

- stable artifact ID
- target game/version/revision/region/language
- source bank, section, address, archive/member, symbol, index, or other locator
- source and output hashes
- extraction/reconstruction/conversion tool and command
- dimensions, format, palette/index information, or other asset-specific metadata
- deduplication relationships
- verification level and evidence

Do not invent unknown values. Use explicit `null`, `unknown`, or equivalent schema-supported states.

See `example.asset-manifest.json` for a minimal example.
