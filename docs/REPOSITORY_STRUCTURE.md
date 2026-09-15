# Repository Structure

The repository starts intentionally small. Directories are added when real project material exists.

## Expected long-term areas

- `asm/` — reconstructed assembly/source when appropriate for the target
- `data/` — structured game data and editable tables
- `assets/` — reconstructed or extracted reviewable assets
- `tools/` — extraction, conversion, build, and verification tooling
- `tests/` — reproducibility and regression checks
- `manifests/` — structured provenance, identity, and asset metadata
- `docs/` — research, format, workflow, and verification documentation

These names describe responsibilities, not a mandate to imitate another generation's project tree. The verified architecture of the target determines the detailed layout.

## Stability

Avoid repository-wide structural version churn. Improve policy and documentation in place. Git history is the historical record; the live tree should represent the current structure only.
