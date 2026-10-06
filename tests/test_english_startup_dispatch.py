import hashlib,json,unittest
from pathlib import Path
ROOT=Path(__file__).parents[1]
class Tests(unittest.TestCase):
 def test_cfg(self):
  c=json.loads((ROOT/'analysis/aka-en-startup-dispatch.json').read_text());self.assertEqual(c['source_sha256'],'5ca7ba01642a3b27b0cc0b5349b52792795b62d3ed977e98a09390659af96b7b');self.assertEqual([b['start_address'] for b in c['blocks']],[0x150,0x154,0x157]);self.assertTrue(all('block_bytes' not in b for b in c['blocks']))
 def test_manifest(self):
  m=json.loads((ROOT/'manifests/english-startup-dispatch.json').read_text());self.assertFalse(m['raw_rom_bytes_included']);[self.assertEqual(hashlib.sha256((ROOT/o['path']).read_bytes()).hexdigest(),o['sha256']) for o in m['outputs']]
if __name__=='__main__':unittest.main()
