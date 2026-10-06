import hashlib,json,unittest
from pathlib import Path
ROOT=Path(__file__).parents[1]
EXPECTED={'de':'9cd186b288dbcd52413d561ae449f1f700c32b45af56dbf849095d4a0c8637a6','fr':'23766290f3b2347f815f1e8977c3b84047ed880cadda8c4f1a3595a633daa303','it':'e805d00b0002156d38b96efd57c823b0db3a3ef4cd32f98bd9bb4779bda3dd5b','es':'a756cf7ad888aa46de4b9699a177a0edf1775e59eb6330014c6f5c139be9c45d'}
class Tests(unittest.TestCase):
 def test_languages(self):
  for l,h in EXPECTED.items():
   c=json.loads((ROOT/f'analysis/aka-{l}-startup-dispatch.json').read_text());self.assertEqual(c['source_sha256'],h);self.assertEqual([b['start_address'] for b in c['blocks']],[0x150,0x154,0x157]);self.assertTrue(all('block_bytes' not in b for b in c['blocks']))
 def test_manifests(self):
  for l in EXPECTED:
   m=json.loads((ROOT/f'manifests/{l}-startup-dispatch.json').read_text());[self.assertEqual(hashlib.sha256((ROOT/o['path']).read_bytes()).hexdigest(),o['sha256']) for o in m['outputs']]
if __name__=='__main__':unittest.main()
