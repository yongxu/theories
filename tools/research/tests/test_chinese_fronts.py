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
                if zh_fronts.FRONTS[page]:
                    self.assertEqual(links[0], ('English', posixpath.relpath(zh_fronts.FRONTS[page], posixpath.dirname(page) or '.')))
                else:
                    self.assertNotIn('English', line)  # chapter 6 has no English edition
                for label, target in links:
                    self.assertTrue((ROOT / posixpath.dirname(page) / target).resolve().is_file(), target)
                    self.assertNotEqual(posixpath.normpath(posixpath.join(posixpath.dirname(page), target)), page)
                own = dict((p, label) for label, p in zh_fronts.WAYS).get(page)
                if own:
                    self.assertIn(f'**{own}**', line)
                self.assertEqual(len(links) + (1 if own else 0), len(zh_fronts.WAYS) + (1 if zh_fronts.FRONTS[page] else 0))

    def test_a_page_that_is_no_front_has_no_line(self):
        with self.assertRaises(KeyError):
            zh_fronts.nav_line('theories/becoming/chapters/01-ROOT.md')

    def test_a_way_in_to_an_english_page_says_so(self):
        for label, target in zh_fronts.WAYS:
            with self.subTest(target=target):
                english = target.endswith('.md') and not target.endswith('.zh.md') and '06-CLASSICAL-TEXTS' not in target
                self.assertEqual('（英文）' in label, english)


class TestsPageTests(unittest.TestCase):
    """TESTS.zh.md from the tests' data and their Chinese lines: failures first, an English line marked, nothing stale shown as current."""

    def write(self, root, rows, lines):
        import json
        for rel, body in ((zh_fronts.TESTS_DATA, {'tests': rows}), (zh_fronts.TESTS_LINES, {'lines': lines})):
            (root / rel).parent.mkdir(parents=True, exist_ok=True)
            (root / rel).write_text(json.dumps(body, ensure_ascii=False), encoding='utf-8')

    ROWS = [{'id': 'P1', 'name': 'A pass', 'thesis': 'T1', 'folder': 'experiments/p/README.md', 'frozen': '2026-10-02', 'run': '2026-10-03', 'outcome': 'passed', 'gloss': 'It passed.'},
            {'id': 'F1', 'name': 'A failure', 'thesis': 'T2', 'folder': 'experiments/f/README.md', 'frozen': '2026-10-01', 'run': '2026-10-02', 'outcome': 'failed', 'gloss': 'It failed.'},
            {'id': 'N1', 'name': 'Not run', 'thesis': 'T3', 'folder': 'experiments/n/README.md', 'frozen': '2026-10-05', 'run': '', 'outcome': 'not-run', 'gloss': 'Not run.'}]

    def test_failures_first_and_only_what_scored(self):
        import tempfile
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            self.write(root, self.ROWS, {'F1': {'en_name': 'A failure', 'en': 'It failed.', 'name': '一项失败', 'gloss': '它未通过。'},
                                         'P1': {'en_name': 'A pass', 'en': 'It passed.', 'name': '一项通过 | 以竖线', 'gloss': '它通过了。'}})
            pages, errors = zh_fronts.tests_page(root)
        page = pages[zh_fronts.TESTS_PAGE]
        self.assertEqual(errors, [])
        self.assertLess(page.index('## 未通过'), page.index('## 通过'))
        self.assertIn('| [**F1**](experiments/f/README.md) 一项失败 | T2 | 2026-10-01 | 2026-10-02 | 它未通过。 |', page)
        self.assertNotIn('N1', page)
        self.assertIn('全部 3 项中：「未通过」1，「通过」1；此外「已冻结、尚未运行」1', page)
        self.assertIn(zh_fronts.nav_line(zh_fronts.TESTS_PAGE), page)
        self.assertIn('一项通过 \\| 以竖线', page)

    def test_the_landing_page_render_writes_and_times_it(self):
        import tempfile
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            self.write(root, self.ROWS, {})
            (root / zh_fronts.TEMPLATE).parent.mkdir(parents=True, exist_ok=True)
            (root / zh_fronts.TEMPLATE).write_text('<!-- note -->\n# 首页\n\n{{nav}}\n\n检验约 {{time:TESTS.zh.md}}。\n', encoding='utf-8')
            for c in zh_fronts.CHAPTERS:
                (root / c).parent.mkdir(parents=True, exist_ok=True)
                (root / c).write_text('# c\n', encoding='utf-8')
            pages, errors = zh_fronts.render([], {'TESTS.md': 'x'}, root)
            refused, _ = zh_fronts.render([], {}, root)  # TESTS.md's own render refused the data: no Chinese page
            inputs = {str(p.relative_to(root)) for p in zh_fronts.inputs(root)}
        self.assertEqual(errors, [])
        self.assertIn(zh_fronts.TESTS_PAGE, pages)
        self.assertNotIn('{{time:', pages['README.zh.md'])
        self.assertNotIn(zh_fronts.TESTS_PAGE, refused)
        self.assertIn(zh_fronts.TESTS_DATA, inputs)
        self.assertIn(zh_fronts.TESTS_LINES, inputs)

    def test_a_row_whose_english_changed_shows_the_english_marked(self):
        import tempfile
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            self.write(root, self.ROWS, {'F1': {'en_name': 'A failure', 'en': 'An older line.', 'name': '一项失败', 'gloss': '旧的中文。'},
                                         'P1': {'en_name': 'An older name', 'en': 'It passed.', 'name': '旧名', 'gloss': '它通过了。'}})
            pages, _ = zh_fronts.tests_page(root)
        page = pages[zh_fronts.TESTS_PAGE]
        self.assertNotIn('旧的中文', page)
        self.assertNotIn('旧名', page)
        self.assertIn('A failure（英文）', page)
        self.assertIn('It failed.（英文）', page)
        self.assertIn('A pass（英文）', page)

    def test_a_line_for_no_test_is_an_error(self):
        import tempfile
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            self.write(root, self.ROWS, {'GONE': {'en_name': 'w', 'en': 'x', 'name': 'y', 'gloss': 'z'}})
            pages, errors = zh_fronts.tests_page(root)
            self.write(root, self.ROWS, {'F1': {'en_name': 'A failure', 'en': 'It failed.', 'name': '', 'gloss': '它未通过。'}})
            _, empty = zh_fronts.tests_page(root)
        self.assertEqual(errors, [f'zh fronts: {zh_fronts.TESTS_LINES} has a line for a test that does not exist: GONE'])
        self.assertEqual(pages, {})
        self.assertEqual(empty, [f'zh fronts: {zh_fronts.TESTS_LINES}: the line for F1 needs non-empty en, en_name, name and gloss'])

    def test_a_bad_line_is_what_the_landing_page_render_reports(self):
        import tempfile
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            self.write(root, self.ROWS, {'F1': {'en_name': 'A failure', 'en': 'It failed.', 'name': '', 'gloss': 'x'}})
            (root / zh_fronts.TEMPLATE).parent.mkdir(parents=True, exist_ok=True)
            (root / zh_fronts.TEMPLATE).write_text('# 首页\n\n检验约 {{time:TESTS.zh.md}}。\n', encoding='utf-8')
            pages, errors = zh_fronts.render([], {'TESTS.md': 'x'}, root)
        self.assertEqual(pages, {})
        self.assertEqual(errors, [f'zh fronts: {zh_fronts.TESTS_LINES}: the line for F1 needs non-empty en, en_name, name and gloss'])

    def test_cells_escape_only_bare_pipes(self):
        self.assertEqual(zh_fronts._cell('a | b'), 'a \\| b')
        self.assertEqual(zh_fronts._cell('a \\| b'), 'a \\| b')
        self.assertEqual(zh_fronts._cell('a \\\\| b'), 'a \\\\\\| b')


class LandingPageTests(unittest.TestCase):
    """README.zh.md from its template: every field filled by README.md's rule, a generated page timed as it will be written."""

    def setUp(self):
        import tempfile
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        for rel, body in {'theories/becoming/ONE-PAGE.zh.md': '# 一页\n\n' + '字' * 2600,
                          'theories/LINEAGE.zh.md': '# 长成\n\n[English](LINEAGE.md)\n\n*全文约 9–12 分钟。*\n',
                          **{c: '# x\n\n' + 'word ' * 13000 for c in zh_fronts.CHAPTERS}}.items():
            (self.root / rel).parent.mkdir(parents=True, exist_ok=True)
            (self.root / rel).write_text(body, encoding='utf-8')
        self.template = self.root / zh_fronts.TEMPLATE
        self.template.parent.mkdir(parents=True, exist_ok=True)
        self.records = [{'status': 'recorded-checked'}, {'status': 'recorded-checked'}, {'status': 'reviewed-scoped'}]

    def render(self, body, outputs=None):
        self.template.write_text('<!-- the template\'s note -->\n\n' + body, encoding='utf-8')
        return zh_fronts.render(self.records, outputs or {}, self.root)

    def test_fields_are_filled_and_the_note_dropped(self):
        pages, errors = self.render('# 首\n\n{{nav}}\n\n*这一屏约 {{time:screen}}（全页约 {{time:page}}）。*\n\n'
                                    '{{count:registered}} 条中 {{count:recorded-checked}} 条。一页约 {{time:theories/becoming/ONE-PAGE.zh.md}}；'
                                    '每章约 {{time:chapters}}；长成：{{stated:theories/LINEAGE.zh.md}}；检验约 {{time:TESTS.md}}。\n\n## 后\n',
                                    {'TESTS.md': 'word ' * 4000})
        self.assertEqual(errors, [])
        page = pages[zh_fronts.PAGE]
        self.assertTrue(page.startswith(zh_fronts.GENERATED + '\n\n# 首'))
        self.assertNotIn('the template', page)
        self.assertIn(zh_fronts.nav_line(zh_fronts.PAGE), page)
        self.assertIn('3 条中 2 条', page)
        self.assertIn('一页约 10–13 分钟', page)  # 2,600 characters, a character half a word
        self.assertIn('每章约 1.5–2 小时', page)
        self.assertIn('长成：全文约 9–12 分钟', page)
        self.assertIn('检验约 31–40 分钟', page)  # timed as the render is about to write it
        self.assertNotIn('{{', page)

    def test_links_are_written_from_the_template_and_a_generated_page_on_disk_is_refused(self):
        pages, errors = self.render('# 首\n\n{{nav}}\n\n[一页](../../theories/becoming/ONE-PAGE.zh.md) 与 [术语](../../GLOSSARY.zh.md#锁定)。\n')
        self.assertEqual(errors, [])
        self.assertIn('[一页](theories/becoming/ONE-PAGE.zh.md) 与 [术语](GLOSSARY.zh.md#锁定)', pages[zh_fronts.PAGE])
        (self.root / 'RESULTS.md').write_text('<!-- Generated by elsewhere -->\n\n# r\n', encoding='utf-8')
        pages, errors = self.render('# 首\n\n约 {{time:RESULTS.md}}\n')
        self.assertEqual(pages, {})
        self.assertTrue(any('render writes after this one' in e for e in errors), errors)

    def test_a_stated_time_is_kept_whole_in_a_table(self):
        (self.root / 'theories/LINEAGE.zh.md').write_text('# 长成\n\n*全文约 9–12 分钟 | 另 3 分钟。*\n', encoding='utf-8')
        pages, errors = self.render('# 首\n\n| a | {{stated:theories/LINEAGE.zh.md}} |\n')
        self.assertEqual(errors, [])
        self.assertIn('| a | 全文约 9–12 分钟 \\| 另 3 分钟 |', pages[zh_fronts.PAGE])

    def test_the_generated_fronts_carry_the_line_on_disk(self):
        for page in zh_fronts.GENERATED_FRONTS:
            with self.subTest(page=page):
                self.assertEqual(zh_fronts.current(page), zh_fronts.nav_line(page))

    def test_an_unknown_field_or_a_missing_page_renders_nothing(self):
        for body, word in (('{{when:now}}', 'unknown field'), ('{{time:theories/none.md}}', 'missing page'),
                           ('{{count:invented}}', 'unknown status'), ('{{stated:theories/becoming/ONE-PAGE.zh.md}}', 'states no reading time')):
            with self.subTest(body=body):
                pages, errors = self.render('# 首\n\n' + body + '\n')
                self.assertEqual(pages, {})
                self.assertTrue(any(word in e for e in errors), errors)


if __name__ == '__main__':
    unittest.main()
