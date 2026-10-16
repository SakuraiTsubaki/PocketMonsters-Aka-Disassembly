import hashlib,json,unittest
from pathlib import Path
R=Path(__file__).parents[1];H='fd06ac5c2f683a65c1825e318fe63bd21f92fefd4b19bf9608ddb7a613a511e9'
class T(unittest.TestCase):
 def test_releases(self):
  rows={x['id']:x for x in json.loads((R/'analysis/aka-release-header-report.json').read_text())['releases']}
  for k,row in rows.items():
   m=json.loads((R/f'analysis/{k}-multiply-core.json').read_text());f=m['function'];w=json.loads((R/f'analysis/{k}-multiply-wrapper.json').read_text())['function'];d=json.loads((R/f'analysis/{k}-divide-wrapper.json').read_text())['function'];self.assertEqual(m['target']['sha256'],row['sha256']);self.assertEqual((f['bank'],f['address'],f['rom_offset'],f['range_end_exclusive'],f['length']),(0x0D,w['far_call']['target']['address'],w['far_call']['target']['rom_offset'],d['home_call']['target']['rom_offset'],100));self.assertEqual(f['code_sha256'],H);self.assertEqual(f['hram_layout']['product'],[0xFF95,0xFF96,0xFF97,0xFF98]);self.assertFalse(m['raw_rom_bytes_included'])
 def test_manifest(self):
  m=json.loads((R/'manifests/multiply-core-reconstruction.json').read_text());[self.assertEqual(hashlib.sha256((R/o['path']).read_bytes()).hexdigest(),o['sha256'])for o in m['outputs']]
if __name__=='__main__':unittest.main()
