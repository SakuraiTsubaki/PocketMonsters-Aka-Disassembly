import hashlib,json,unittest
from pathlib import Path
R=Path(__file__).parents[1]
class Tests(unittest.TestCase):
 def test_catalog(self):
  s=json.loads((R/'analysis/call-function-in-table-summary.json').read_text());self.assertEqual((s['function'],s['release_count']),('CallFunctionInTable',7));self.assertEqual([x['language'] for x in s['releases'][:3]],['Japanese','Japanese','English'])
  for x in s['releases']:
   e=json.loads((R/x['evidence']).read_text());f=e['function'];self.assertEqual((f['bank'],f['length'],f['return_address']),(0,20,f['address']+16));self.assertEqual(e['target']['status'],'candidate');self.assertFalse(e['raw_rom_bytes_included'])
 def test_manifest(self):
  m=json.loads((R/'manifests/call-function-in-table-reconstruction.json').read_text());
  for x in m['outputs']:self.assertEqual(hashlib.sha256((R/x['path']).read_bytes()).hexdigest(),x['sha256'])
if __name__=='__main__':unittest.main()
