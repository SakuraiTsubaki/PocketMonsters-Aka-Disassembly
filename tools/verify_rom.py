#!/usr/bin/env python3
"""Verify an input or rebuilt ROM without modifying it."""

from __future__ import annotations

import argparse
import hashlib
from pathlib import Path


TARGETS = {
    "aka": {
        "size": 524288,
        "sha1": "0623ad12f48c259447980d68bd85ddbf8204b2cd",
        "sha256": "392ce450d708c8d127aaed7afc20001a48625bd83a5fa5325be82f5c0972ccfa",
    },
    "aka-rev-a": {
        "size": 524288,
        "sha1": "ef74c79cded14204ac79e77f4964d9cb25003120",
        "sha256": "751abb1fb2b2d6b91dc631fa10ed36bd07f682cb5c3febe6c8f0e3dabc1fae1c",
    },
}


def digest(data: bytes, name: str) -> str:
    return hashlib.new(name, data).hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("target", choices=TARGETS)
    parser.add_argument("rom", type=Path)
    args = parser.parse_args()

    data = args.rom.read_bytes()
    expected = TARGETS[args.target]
    actual = {
        "size": len(data),
        "sha1": digest(data, "sha1"),
        "sha256": digest(data, "sha256"),
    }
    failures = [key for key in expected if actual[key] != expected[key]]
    for key in ("size", "sha1", "sha256"):
        print(f"{key}: {actual[key]}")
    if failures:
        print("verification: FAILED (" + ", ".join(failures) + ")")
        return 1
    print("verification: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

