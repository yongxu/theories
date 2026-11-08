"""The Chinese fronts' one navigation line (zh_fronts.py): every hand-written front carries it, each link in it
resolves from the page it is on, the page itself is bold and not linked, and the generated lineage can ask for its own."""
from pathlib import Path
import posixpath
import re
import sys
import unittest

ROOT = Path(__file__).resolve().parents[3]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from tools.research import zh_fronts  # noqa: E402

LINK = re.compile(r'\[([^\]]+)\]\(([^)]+)\)')


class ChineseFrontsTests(unittest.TestCase):
    def test_every_hand_written_front_carries_the_line(self):
        self.assertEqual(zh_fronts.problems(), [])

    def test_each_link_resolves_from_its_page_and_the_page_itself_is_not_linked(self):
        for page in zh_fronts.FRONTS:
            line = zh_fronts.nav_line(page)
            with self.subTest(page=page):
                links = LINK.findall(line)
                self.assertEqual(links[0], ('English', posixpath.relpath(zh_fronts.FRONTS[page], posixpath.dirname(page) or '.')))
                for label, target in links:
                    self.assertTrue((ROOT / posixpath.dirname(page) / target).resolve().is_file(), target)
                    self.assertNotEqual(posixpath.normpath(posixpath.join(posixpath.dirname(page), target)), page)
                own = dict((p, label) for label, p in zh_fronts.WAYS).get(page)
                if own:
                    self.assertIn(f'**{own}**', line)
                self.assertEqual(len(links) + (1 if own else 0), len(zh_fronts.WAYS) + 1)

    def test_a_page_that_is_no_front_has_no_line(self):
        with self.assertRaises(KeyError):
            zh_fronts.nav_line('theories/becoming/chapters/06-CLASSICAL-TEXTS.md')


if __name__ == '__main__':
    unittest.main()
