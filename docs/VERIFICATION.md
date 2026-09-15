# Verification

Verification claims should be reproducible and scoped to a specific target.

## Levels

### Observed

A fact was directly confirmed from target evidence.

### Reproduced

A documented process independently recreates the expected structure, asset, data, code behavior, or intermediate result.

### Matched

The reproduced result satisfies an explicit matching criterion such as exact bytes, hash equality, exact decoded structure, or a documented deterministic comparison.

## Evidence

Record the target identity, method, commands/tools, expected result, actual result, and hashes or reports when applicable.

## Build matching

When a build is possible, document toolchain assumptions and distinguish partial/section matches from whole-image matches. Retail or rebuilt playable ROM images must not be committed merely to demonstrate a match.
