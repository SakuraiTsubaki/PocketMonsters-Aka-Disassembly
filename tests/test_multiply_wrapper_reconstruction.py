import hashlib,json,unittest
from pathlib import Path
R=Path(__file__).parents[1];E={'aka-jp-rev0':(0x38F5,0x7E73,0x3620),'aka-jp-rev1':(0x38E3,0x7E73,0x360E),'red-en-rev0':(0x38AC,0x7D41,0x35D6),'red-de-rev0':(0x38C6,0x7D41,0x35F0),'red-es-rev0':(0x38CB,0x7D41,0x35F5),'red-fr-rev0':(0x38C9,0x7D4D,0x35F3),'red-it-rev0':(0x38C4,0x7D4D,0x35EE)}
class T(unittest.TestCase):
 def test_releases(self):
  rows={x['id']:x for x in json.loads((R/'analysis/aka-release-header-report.json').read_text())['releases']};self.assertEqual(set(rows),set(E))
  for k,(a,t,s) in E.items():
   m=json.loads((R/f'analysis/{k}-multiply-wrapper.json').read_text());f=m['function'];self.assertEqual(m['target']['sha256'],rows[k]['sha256']);self.assertEqual((f['bank'],f['address'],f['length']),(0,a,13));self.assertEqual(f['far_call']['target']['bank'],0x0D);self.assertEqual(f['far_call']['target']['address'],t);self.assertEqual(f['far_call']['bankswitch']['address'],s);self.assertEqual(f['preserved_registers'],['BC','HL']);self.assertFalse(m['raw_rom_bytes_included'])
 def test_manifest(self):
  m=json.loads((R/'manifests/multiply-wrapper-reconstruction.json').read_text());[self.assertEqual(hashlib.sha256((R/o['path']).read_bytes()).hexdigest(),o['sha256'])for o in m['outputs']]
if __name__=='__main__':unittest.main()
