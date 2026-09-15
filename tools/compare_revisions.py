#!/usr/bin/env python3
"""Compare two 512 KiB Game Boy ROM revisions bank by bank.

The tool reports byte-position differences only. It intentionally does not infer
semantic change counts from shifted code/data.
"""

from __future__ import annotations

import argparse
from pathlib import Path

BANK_SIZE = 0x4000
EXPECTED_BANKS = 0x20
EXPECTED_SIZE = BANK_SIZE * EXPECTED_BANKS


def fmt_offset(value: int | None) -> str:
    return "—" if value is None else f"${value:05X}"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("rev0", type=Path)
    parser.add_argument("rev_a", type=Path)
    args = parser.parse_args()

    left = args.rev0.read_bytes()
    right = args.rev_a.read_bytes()

    for path, data in ((args.rev0, left), (args.rev_a, right)):
        if len(data) != EXPECTED_SIZE:
            parser.error(
                f"{path}: expected {EXPECTED_SIZE} bytes, got {len(data)}"
            )

    total = 0
    print("| Bank | Differing bytes | First ROM offset | Last ROM offset |")
    print("|---:|---:|---:|---:|")

    for bank in range(EXPECTED_BANKS):
        start = bank * BANK_SIZE
        end = start + BANK_SIZE
        differences = [
            start + index
            for index, (a, b) in enumerate(zip(left[start:end], right[start:end]))
            if a != b
        ]
        total += len(differences)
        first = differences[0] if differences else None
        last = differences[-1] if differences else None
        print(
            f"| `${bank:02X}` | {len(differences)} | "
            f"{fmt_offset(first)} | {fmt_offset(last)} |"
        )

    print(f"\nTotal differing byte positions: {total}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
