import hashlib,json,unittest
from pathlib import Path
R=Path(__file__).parents[1];E={'aka-jp-rev0':(0x718D,0xD0F0,0xD10D),'aka-jp-rev1':(0x7192,0xD0F0,0xD10D),'red-en-rev0':(0x6E9B,0xD12B,0xD148),'red-de-rev0':(0x6EA9,0xD130,0xD14D),'red-es-rev0':(0x6EAA,0xD130,0xD14D),'red-fr-rev0':(0x6EB0,0xD130,0xD14D),'red-it-rev0':(0x6E9E,0xD130,0xD14D)}
class T(unittest.TestCase):
 def test_releases(self):
  rows={x['id']:x for x in json.loads((R/'analysis/aka-release-header-report.json').read_text())['releases']};self.assertEqual(set(rows),set(E))
  for k,(a,l,s) in E.items():
   m=json.loads((R/f'analysis/{k}-battle-random.json').read_text());f=m['function'];w=json.loads((R/f'analysis/{k}-random-wrapper.json').read_text())['function'];self.assertEqual(m['target']['sha256'],rows[k]['sha256']);self.assertEqual((f['bank'],f['address'],f['length']),(15,a,56));self.assertEqual(f['control_flow']['non_link_jump']['address'],w['address']);self.assertEqual((f['state']['wLinkState'],f['state']['link_state_battling'],f['state']['wLinkBattleRandomNumberListIndex'],f['state']['wLinkBattleRandomNumberList']),(l,4,0xCCDE,s));self.assertEqual((f['state']['stream_length'],f['state']['refreshed_seed_count']),(10,9));self.assertFalse(m['raw_rom_bytes_included'])
 def test_manifest(self):
  m=json.loads((R/'manifests/battle-random-reconstruction.json').read_text());[self.assertEqual(hashlib.sha256((R/o['path']).read_bytes()).hexdigest(),o['sha256'])for o in m['outputs']]
if __name__=='__main__':unittest.main()
