import hashlib
import json
import struct
import unittest
from pathlib import Path


ROOT = Path(__file__).parents[1]


class TitleVersionGraphicsTests(unittest.TestCase):
    def test_reports_and_pngs_match_manifest(self):
        manifest = json.loads((ROOT / "manifests" / "title-version-graphics.json").read_text())
        for output in manifest["outputs"]:
            path = ROOT / output["path"]
            self.assertTrue(path.is_file())
            self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), output["sha256"])
        for language in ("jp", "en"):
            report = json.loads((ROOT / "analysis" / f"aka-{language}-title-version.json").read_text())
            png = (ROOT / "graphics" / "title" / f"version-{language}.png").read_bytes()
            self.assertEqual((report["source_length"], report["tile_count"]), (80, 10))
            self.assertEqual(struct.unpack(">II", png[16:24]), (320, 32))
            self.assertNotIn("source_bytes", report)
            self.assertEqual(hashlib.sha256(png).hexdigest(), report["png_sha256"])

    def test_japanese_origin_and_english_fallback_are_byte_identical(self):
        reports = [json.loads((ROOT / "analysis" / f"aka-{language}-title-version.json").read_text()) for language in ("jp", "en")]
        self.assertEqual(reports[0]["source_sha256"], reports[1]["source_sha256"])
        self.assertNotEqual(reports[0]["rom_sha256"], reports[1]["rom_sha256"])


if __name__ == "__main__":
    unittest.main()
