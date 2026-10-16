import hashlib,json,unittest
from pathlib import Path
R=Path(__file__).parents[1];V={'aka-jp-rev0':('inline-absolute-hram',27),'aka-jp-rev1':('inline-absolute-hram',27),'red-en-rev0':('inline-ldh',26),'red-de-rev0':('inline-ldh',26),'red-es-rev0':('inline-ldh',26),'red-fr-rev0':('inline-ldh',26),'red-it-rev0':('inline-ldh',26)}
class T(unittest.TestCase):
 def test_releases(self):
  rows={x['id']:x for x in json.loads((R/'analysis/aka-release-header-report.json').read_text())['releases']};self.assertEqual(set(rows),set(V))
  for k,(v,n) in V.items():
   m=json.loads((R/f'analysis/{k}-divide-wrapper.json').read_text());f=m['function'];x=json.loads((R/f'analysis/{k}-multiply-wrapper.json').read_text())['function'];self.assertEqual(m['target']['sha256'],rows[k]['sha256']);self.assertEqual((f['bank'],f['address'],f['length'],f['variant']),(0,x['range_end_exclusive'],n,v));self.assertEqual(f['home_call']['target']['bank'],x['far_call']['target']['bank']);self.assertEqual(f['home_call']['target']['address'],x['far_call']['target']['address']+0x64);self.assertEqual(f['preserved_registers'],['AF','BC','DE','HL']);self.assertFalse(m['raw_rom_bytes_included'])
 def test_manifest(self):
  m=json.loads((R/'manifests/divide-wrapper-reconstruction.json').read_text());[self.assertEqual(hashlib.sha256((R/o['path']).read_bytes()).hexdigest(),o['sha256'])for o in m['outputs']]
if __name__=='__main__':unittest.main()
