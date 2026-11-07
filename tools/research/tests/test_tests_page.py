"""The tests page (tests_page.py) against what it promises: every row quotes its folder word for word or the render
stops; an unknown class, a bad date or a thesis outside T1 to T8 is an error; the failures come first; and the
repository's own data passes."""
import json
from pathlib import Path
import shutil
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[3]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from tools.research import tests_page  # noqa: E402

ROW = {'id': 'X1', 'name': 'a test', 'thesis': 'T1', 'folder': 'experiments/x/README.md', 'frozen': '2026-10-20',
       'run': '2026-10-21', 'outcome': 'failed', 'quote': 'every frozen rule failed', 'quote_path': 'experiments/x/README.md',
       'gloss': 'Its rules failed.'}


class TestsPageTests(unittest.TestCase):
    def setUp(self):
        self.root = Path(tempfile.mkdtemp())
        self.addCleanup(shutil.rmtree, self.root)
        (self.root / 'experiments/x').mkdir(parents=True)
        (self.root / 'experiments/x/README.md').write_text('# X\n\nIn VD1 every frozen\nrule failed.\n')

    def check(self, **change):
        return tests_page.validate({'tests': [dict(ROW, **change)]}, self.root)

    def test_a_quote_its_folder_holds_passes_across_line_breaks(self):
        self.assertEqual(self.check(), [])

    def test_a_quote_its_folder_no_longer_holds_is_an_error(self):
        self.assertRegex(' '.join(self.check(quote='every frozen rule passed')), 'no longer says, word for word')

    def test_malformed_rows_are_errors(self):
        self.assertRegex(' '.join(self.check(outcome='nearly passed')), 'unknown outcome')
        self.assertRegex(' '.join(self.check(frozen='20 Oct')), 'frozen is not a date')
        self.assertRegex(' '.join(self.check(thesis='T9')), 'thesis is not T1 to T8')
        self.assertRegex(' '.join(self.check(folder='experiments/y/README.md')), "folder's page is missing")
        self.assertRegex(' '.join(tests_page.validate({'tests': [ROW, ROW]}, self.root)), 'a second row')

    def test_the_failures_come_first(self):
        rows = [dict(ROW, id='P', outcome='passed'), dict(ROW, id='F', outcome='failed'), dict(ROW, id='M', outcome='mixed')]
        page = tests_page.render_page({'as_of': '2026-11-08', 'tests': rows})
        self.assertLess(page.index('## Failed'), page.index('## Mixed'))
        self.assertLess(page.index('## Mixed'), page.index('## Passed'))
        self.assertIn('3 in all (1 failed; 1 mixed; 1 passed)', page)
        self.assertIn('[AI reading]', page)


class RepositoryDataTests(unittest.TestCase):
    def test_the_repository_tests_quote_their_folders(self):
        p = ROOT / tests_page.DATA
        if not p.is_file():
            self.skipTest('no tests data yet')
        self.assertEqual(tests_page.validate(json.loads(p.read_text())), [])


if __name__ == '__main__':
    unittest.main()
