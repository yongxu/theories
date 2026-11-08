"""The Lean catalogue's document scan asks the tree again each time: a page a render writes after the first scan is
linked in the same render (lean_catalogue.documents, local_link's cache cleared)."""
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[3]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from tools.research import lean_catalogue  # noqa: E402


class DocumentScanTests(unittest.TestCase):
    def test_a_file_written_after_the_first_scan_is_linked(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp).resolve()
            (root / 'theories').mkdir()
            (root / 'theories/DOC.md').write_text('# D\n\n[new](NEW.lean)\n')
            with patch.object(lean_catalogue, 'ROOT', root), patch.object(lean_catalogue, '_mirror_folders', lambda: {}), \
                    patch.object(lean_catalogue, 'discover', lambda glob: ['theories/DOC.md']):
                _, before = lean_catalogue.documents()
                (root / 'theories/NEW.lean').write_text('')
                _, after = lean_catalogue.documents()
        self.assertNotIn('theories/NEW.lean', before)
        self.assertEqual(after.get('theories/NEW.lean'), ['theories/DOC.md'])


if __name__ == '__main__':
    unittest.main()
