# Asset Workflow

Assets should remain traceable from source evidence to reviewable and reproducible project output.

## Principles

1. Record the target version, revision, region, language, and source location.
2. Preserve original identifiers, indices, ordering, dimensions, palettes, and container relationships when known.
3. Keep editable or source-faithful representations alongside generated forms when useful.
4. Do not deduplicate by appearance alone. Confirm byte identity or an equally strong reproducible equivalence first.
5. Keep genuinely different regional, revision, language, frame, form, or palette variants distinct.
6. PNG previews are encouraged for human review when their provenance is recorded.
7. Generated or converted assets should identify the tool, method, inputs, and hashes needed to reproduce them.

## Suggested flow

Source evidence → extraction/reconstruction → metadata/manifest → human-reviewable representation → conversion if required → verification.

Retail ROM images are never project artifacts and must not be committed.
