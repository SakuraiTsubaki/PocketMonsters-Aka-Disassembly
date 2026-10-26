import hashlib
import json
import unittest
from pathlib import Path

ROOT = Path(__file__).parents[1]
ADDRESSES = {
    "aka-jp-rev0": (0, 0x01BB),
    "aka-jp-rev1": (0, 0x01BB),
    "red-de-rev0": (0, 0x00B5),
    "red-en-rev0": (0, 0x00B5),
    "red-es-rev0": (0, 0x00B5),
    "red-fr-rev0": (0, 0x00B5),
    "red-it-rev0": (0, 0x00B5),
}
CODE_SHA256 = "4c81b1d98cede80c642119edcb1c3f45c1f05e97c1d9aafcf250b065f33d495c"


class CopyDataReconstructionTests(unittest.TestCase):
    def test_all_releases(self):
        header = json.loads((ROOT / "analysis/aka-release-header-report.json").read_text(encoding="utf-8"))
        releases = {item["id"]: item for item in header["releases"]}
        self.assertEqual(set(releases), set(ADDRESSES))
        for release, location in ADDRESSES.items():
            report = json.loads((ROOT / f"analysis/{release}-copy-data.json").read_text(encoding="utf-8"))
            function = report["function"]
            self.assertEqual(report["target"]["sha256"], releases[release]["sha256"])
            self.assertEqual((function["bank"], function["address"]), location)
            self.assertEqual((function["length"], function["code_sha256"]), (9, CODE_SHA256))
            self.assertFalse(report["raw_rom_bytes_included"])

    def test_manifest(self):
        manifest = json.loads((ROOT / "manifests/copy-data-reconstruction.json").read_text(encoding="utf-8"))
        self.assertFalse(manifest["raw_rom_bytes_included"])
        for output in manifest["outputs"]:
            self.assertEqual(hashlib.sha256((ROOT / output["path"]).read_bytes()).hexdigest(), output["sha256"])


if __name__ == "__main__":
    unittest.main()
