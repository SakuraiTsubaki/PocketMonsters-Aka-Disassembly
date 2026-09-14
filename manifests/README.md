# Manifest Guide

This directory contains target inventories and metadata that support reproducible disassembly work. Existing manifests are project data and should be preserved when extending this guide.

Useful manifest fields may include target/release ID, region, language, revision, source location, bank/section/address or offset, asset identifier, repository path, size, hashes, extraction/conversion method, verification state, and shared byte-identical usage.

## Rules

- Do not invent unknown metadata; use `TBD`, `unknown`, or empty/null values explicitly.
- Prefer stable identifiers and cryptographic hashes when identity matters.
- Preserve provenance even when a byte-identical asset is stored only once.
- Do not deduplicate assets solely because they look or sound identical.
- Keep retail/rebuilt ROM images and console keys out of Git.

See `../docs/ASSET_WORKFLOW.md`, `../docs/VERIFICATION.md`, and `../docs/DISASSEMBLY_STANDARDS.md`.
