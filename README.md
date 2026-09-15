# Pocket Monsters Aka — Disassembly

![Status](https://img.shields.io/badge/status-INCBIN_baseline-blue)
![Project](https://img.shields.io/badge/project-disassembly-blue)
![ROMs](https://img.shields.io/badge/ROM_binaries-not_included-success)

Independent, verification-first disassembly and source-reconstruction project
for the two Japanese releases of **Pocket Monsters Aka / Pokémon Red**.

## Current baseline

- Pocket Monsters Aka (Japan), header revision 0
- Pocket Monsters Aka (Japan) (Rev A), header revision 1
- 32 fixed 16 KiB banks per revision
- Complete RGBDS `INCBIN` coverage from bank `$00` through bank `$1F`
- Known-input and rebuilt-output hashes checked separately
- ROM files never committed

This first milestone intentionally preserves every byte. Banks will be replaced
incrementally with labeled RGBDS source while every commit continues to rebuild
the exact target ROM.

## Local ROM setup

Create `baseroms/` and place the read-only originals at:

```text
baseroms/pocket_monsters_aka_japan.gb
baseroms/pocket_monsters_aka_japan_rev_a.gb
```

Expected SHA-1 values:

```text
0623ad12f48c259447980d68bd85ddbf8204b2cd  pocket_monsters_aka_japan.gb
ef74c79cded14204ac79e77f4964d9cb25003120  pocket_monsters_aka_japan_rev_a.gb
```

## Build and verify

Required tools are RGBDS (`rgbasm`, `rgblink`), Python 3, and GNU Make.

```sh
make verify-inputs
make
make verify
```

`make` does not run `rgbfix`: the cartridge header is part of the source image
and must remain byte-identical.

## Repository structure

```text
src/                 RGBDS entry points and common 32-bank layout
tools/               ROM inventory and digest verification tools
docs/                Project policy, inventory, and revision analysis
```

## Documentation

| Document | Purpose |
| --- | --- |
| [ROM inventory](docs/ROM_INVENTORY.md) | Exact identities of all supplied Red releases |
| [Revision comparison](docs/REVISION_COMPARISON.md) | Bank-level Japanese Rev 0 / Rev A differences |
| [Project status](docs/PROJECT_STATUS.md) | Current stage, coverage, validation level, and next milestones |
| [Roadmap](docs/ROADMAP.md) | Disassembly phases and long-term progression |
| [Version coverage](docs/VERSIONS.md) | Regions, languages, revisions, releases, builds, and hashes |
| [Research guide](docs/RESEARCH_GUIDE.md) | Evidence, confidence, and research-recording workflow |
| [Verification guide](docs/VERIFICATION.md) | Standards for Observed, Reproduced, and Matched results |
| [Repository structure](docs/REPOSITORY_STRUCTURE.md) | Intended long-term source, data, asset, tooling, and manifest layout |
| [Documentation hub](docs/README.md) | Entry point for format, code, script, asset, version, and verification notes |

## Repository policy

The checked-in tree contains handwritten project files only. Original ROMs,
raw bank dumps, and other copyrighted binary payloads stay outside version
control. Future extracted assets must be reviewed before distribution.

Research findings identify the relevant target revision and clearly separate
hypotheses from observed, reproduced, or matched results. See
[CONTRIBUTING.md](CONTRIBUTING.md) for contribution rules.

