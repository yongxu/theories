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


def current_template(root):
    """A first screen and an editions record in which the landing page's template follows it, so the page carries no banner."""
    import json
    (root / zh_fronts.TEMPLATE_SOURCE).parent.mkdir(parents=True, exist_ok=True)
    (root / zh_fronts.TEMPLATE_SOURCE).write_text('The first screen.\n', encoding='utf-8')
    (root / zh_fronts.EDITIONS).write_text(json.dumps({'editions': {zh_fronts.TEMPLATE: {
        'revised': '2026-11-08', 'english': zh_fronts.edition_digest('The first screen.\n'), 'chinese': '0' * 64,
        'english_commit': 'abc1234'}}}), encoding='utf-8')


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

    def test_by_thesis_counts_the_english_tables_cells(self):
        """TESTS.zh's 按论题 table: on the live data, each row's cells are TESTS.md's, under the Chinese class names, each
        thesis named as the overview's theses table names it, and the number naming a thesis the first screen's total."""
        import json
        from tools.research import tests_page as english_tests
        rows = json.loads((ROOT / zh_fronts.TESTS_DATA).read_text(encoding='utf-8'))['tests']
        page = zh_fronts.tests_page()[0][zh_fronts.TESTS_PAGE]
        section = page[page.index('<a id="by-thesis"></a>'):page.index('\n## ', page.index('## 按论题') + 1)]
        mine = [l for l in section.split('\n') if l.startswith('| ') and not l.startswith('| 论题')]
        theirs = [l for l in english_tests.by_thesis(rows) if l.startswith('| ') and not l.startswith('| Thesis')]
        self.assertEqual([l.split(' | ')[1:] for l in mine], [l.split(' | ')[1:] for l in theirs])
        names = zh_fronts.thesis_names_zh()
        self.assertEqual(names['T3'], '在有余地之处，优化耗竭其耦合之外者')
        for t, name in names.items():
            if any(t in r['thesis'] for r in rows):
                self.assertIn(f'[{t}]({zh_fronts.METHOD_THESES}) {name} |', section)
        self.assertIn(f'指明论题的检验共 {english_tests.screen_count("total")} 项', section)

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
            current_template(root)
            pages, errors = zh_fronts.render([], {'TESTS.md': 'x'}, root)
            refused, refused_errors = zh_fronts.render([], {}, root)  # TESTS.md's own render refused the data: it says why
            inputs = {str(p.relative_to(root)) for p in zh_fronts.inputs(root)}
        self.assertEqual(errors, [])
        self.assertIn(zh_fronts.TESTS_PAGE, pages)
        self.assertNotIn('{{time:', pages['README.zh.md'])
        self.assertEqual((refused, refused_errors), ({}, []))
        self.assertIn(zh_fronts.TESTS_DATA, inputs)
        self.assertIn(zh_fronts.TESTS_LINES, inputs)
        self.assertIn(zh_fronts.EDITIONS, inputs)
        self.assertIn(zh_fronts.TEMPLATE_SOURCE, inputs)

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
        current_template(self.root)

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

    def test_the_tests_counts_are_the_english_screens(self):
        import json
        from tools.research import tests_page as english_tests
        rows = [{'thesis': 'T1', 'outcome': 'mixed'}, {'thesis': 'T2, T3', 'outcome': 'failed'}, {'thesis': 'T3', 'outcome': 'held'},
                {'thesis': '', 'outcome': 'passed'}, {'thesis': 'T5', 'outcome': 'not-run'}, {'thesis': 'T6', 'outcome': 'refused'},
                {'thesis': 'T7', 'outcome': 'passed'}]
        rows = [{'id': f'X{i}', 'name': 'n', 'folder': 'experiments/x/README.md', 'frozen': '', 'run': '', 'gloss': 'g', **r} for i, r in enumerate(rows)]
        data = self.root / zh_fronts.TESTS_DATA
        data.parent.mkdir(parents=True, exist_ok=True)
        data.write_text(json.dumps({'tests': rows}), encoding='utf-8')
        fields = ('ran', 'mixed', 'passed', 'failed', 'other', 'unrun', 'total')
        pages, errors = self.render('# 首\n\n' + ' '.join('{{tests:%s}}' % f for f in fields) + '\n', {english_tests.PAGE: 'word'})
        self.assertEqual(errors, [])
        # six name a thesis; held and not-run never ran; of the four that ran, the refused one is 'other'
        self.assertIn('4 1 1 1 1 2 6', pages[zh_fronts.PAGE])
        # Data TESTS.md's own render refused (so it is not among the outputs): the landing page waits, that render says why.
        for bad in ('not json', '{"tests": [3]}', '{"tests": [{"thesis": null}]}', '{"rows": []}'):
            with self.subTest(data=bad):
                data.write_text(bad, encoding='utf-8')
                self.assertEqual(self.render('# 首\n\n{{tests:ran}}\n'), ({}, []))
        # No data at all: the field names the file it could not read, not the template's field.
        data.unlink()
        pages, errors = self.render('# 首\n\n{{tests:ran}}\n')
        self.assertEqual(pages, {})
        self.assertTrue(any(zh_fronts.TESTS_DATA + ' cannot be read' in e and 'FileNotFoundError' in e for e in errors), errors)
        # Rows of the wrong shape reach screen_count as the data's fault, whatever the error.
        for bad, why in (('not json', 'JSONDecodeError'), ('{"tests": [3]}', 'TypeError'), ('{"tests": [{"thesis": null}]}', 'AttributeError'),
                         ('{"rows": []}', 'KeyError')):
            with self.subTest(data=bad):
                data.write_text(bad, encoding='utf-8')
                with self.assertRaisesRegex(english_tests.Unreadable, why):
                    english_tests.screen_count('ran', self.root)

    def test_links_are_written_from_the_template_and_a_generated_page_on_disk_is_refused(self):
        pages, errors = self.render('# 首\n\n{{nav}}\n\n[一页](../../theories/becoming/ONE-PAGE.zh.md) 与 [术语](../../GLOSSARY.zh.md#锁定)。\n')
        self.assertEqual(errors, [])
        self.assertIn('[一页](theories/becoming/ONE-PAGE.zh.md) 与 [术语](GLOSSARY.zh.md#锁定)', pages[zh_fronts.PAGE])
        (self.root / 'RESULTS.md').write_text('<!-- Generated by elsewhere -->\n\n# r\n', encoding='utf-8')
        pages, errors = self.render('# 首\n\n约 {{time:RESULTS.md}}\n')
        self.assertEqual(pages, {})
        self.assertTrue(any('render writes after this one' in e for e in errors), errors)

    def test_the_chinese_opening_is_timed_without_its_notes(self):
        """{{time:opening-zh}}: the Chinese opening's body, its footnotes split off as navigation.endnotes splits the English's."""
        from tools.research import navigation
        text = re.sub(r'<!--.*?-->', '', (ROOT / zh_fronts.OPENING_ZH).read_text(encoding='utf-8'), flags=re.S)
        body, _, notes = navigation.endnotes(text).partition('\n### Notes\n')
        self.assertTrue(notes.strip())
        self.assertNotIn('[^', body)
        landing = (ROOT / zh_fronts.PAGE).read_text(encoding='utf-8')
        self.assertIn(f'由 AI 译自英文版（正文约 {zh_fronts.zh_time(body)}）', landing)
        self.assertIn(f'| 正文约 {zh_fronts.zh_time(body)}，注释另计 |', landing)

    def test_the_template_says_the_aim_and_its_governing_clauses_as_the_english_screen(self):
        """The Chinese screen's template, as the reader sees it (its note dropped): the aim as AGENTS.md states it (the
        ninth pass, 10 November 2026; from the fourth pass to the eighth, as GOALS#generative-alignment and AJ's plan §1 state
        condition 1, one of the goal's conditions; which wording is right is Ren's); the meta-attractor's closed form at
        02 §9; and each governing clause once on the page (AG review, fourth pass, 9 November 2026)."""
        text = re.sub(r'<!--.*?-->', '', (ROOT / zh_fronts.TEMPLATE).read_text(encoding='utf-8'), flags=re.S)
        self.assertIn('人与 AI 赖以延续的，始终及时地对他们怎样一同选择造成差别；塑造他们怎样选择，也不成为他们为之而选的', text)  # the fronts' one term (K10)
        # AG-F's fix round (10 November 2026, its screens verifier): who selects together in AGENTS.md's words, as the
        # canonical aligned state's Chinese says it, not 人、制度与训练出的系统
        # DW (13 November 2026): the aim said again; the two names follow it as what happens when it does not hold
        self.assertIn('这样一种对齐：', text)
        self.assertIn('工具性趋同与元吸引子，是这一点不成立时所发生之事的名字', text)
        self.assertNotIn('人、制度与训练出的系统', text)
        self.assertNotIn('规则仍读取塑造者份额之外的东西', text)
        self.assertIn('02-MAP.md#r-closed-capture', text)
        self.assertNotIn('不在诸律之中', text)
        self.assertEqual(text.count('义以英文版为准'), 1)
        self.assertEqual(text.count('以所链接之处为准'), 1)
        self.assertEqual(text.count('尚无独立的人工审查记录'), 1)

    def test_the_template_says_the_ethics_as_the_english_screen(self):
        """The Chinese screen's ethics mirrors the English, dynamics first, as AG-F placed it (10 November 2026, on round 6's
        two high findings: the fronts' ethics turned on ranking by widening, 扩大 ten times on README.zh, and the chain was
        said twice on the screen; Ren that day: "i think 'widening is better' is not the way to go - we need to make dynamics
        connected, mapped, and 'unified'"): no should beyond becoming and no good and evil set over it (Ren, 9 November 2026,
        message 9); the ethics emerging from continuation; where relations close and where they run one way; counting the
        losses that never come back and T8's way of seeing offered for life. How far that has been seen is said once, in
        看到了多远: the hinge on models on a finite listing, that a life forms such an order not shown, the open target named by
        the dynamics. The fifth to ninth passes' fuller wording, the chain with its scope, stands only at 07 §4 and its records."""
        text = re.sub(r'<!--.*?-->', '', (ROOT / zh_fronts.TEMPLATE).read_text(encoding='utf-8'), flags=re.S)
        self.assertIn('伦理从延续中生出', text)
        self.assertIn('也没有凌驾其上的善与恶', text)
        # AG-F's fix round (10 November 2026, astra's cold reading, its high finding): the closing relation read with every
        # step's dependence and exchange in one relation, which does not make effects come back in time order (07 §4.11,
        # `LatePair`); 那些东西, not a bare 那些 (Fable, L1)
        self.assertIn('生命依靠维持它的东西而延续：[“受影响”的关系闭合之处](../../theories/becoming/chapters/05-COLLECTIVES.md#r-mutual-'
                      'dependence-and-its-pace)（这里把各个时刻的依赖与交换合在同一个关系里读），为它的进程付出代价的东西，都在能隔着若干'
                      '环节影响它自身延续的东西之内，但这并不保证影响按时间顺序传回来，代价是否、何时回到它身上，是动力学的一部分（[07 §4.11]'
                      '(../../theories/becoming/chapters/07-SIGNIFICANCE.md#condition-in-time)）', text)
        self.assertNotIn('都可能隔着若干环节影响到它自身的延续', text)
        self.assertIn('依存于它的那些东西所承受的损失，永远不会回到它身上', text)
        self.assertIn('我们提出把这些损失也算进来，并提出[一种看法](../../theories/becoming/chapters/07-SIGNIFICANCE.md#t8)：看每一个'
                      '进程取用什么、靠什么更新来补充，打开什么、关上什么，什么终结、什么继续，由谁承担。', text)
        # AG-F's fix round: near-definitional, as 07 §4 says (Fable, M1); 又多出一些 (Fable, L1); 在模型上, its 其 having no
        # antecedent (the screens verifier)
        self.assertIn('伦理的枢纽在模型上、在一个有限列表上已证明，并且近乎依定义（[07 §4](../../theories/becoming/chapters/07-SIGNIFICANCE.md#'
                      'scope-and-order)）：设生命对诸进程有一种次序，凡一个进程保有另一个所保有的一切、又多出一些属于生命自身延续的东西，'
                      '就把前者排在后者之上（*自我关切*；这里把自身的延续读作一切能隔着若干环节影响它的东西）；那么在“受影响”这一关系闭合'
                      '之处（各个时刻合在一起读），凡一个进程保有另一个所保有的一切、又让更多东西形成，这一次序都已经把前者排在后者之上。生命是否会形成这种'
                      '次序，尚未表明；这种次序怎样在动力学之中形成、扩散与锁定，并与地图上其余的动力学相连，是本论的[开放目标]('
                      '../../theories/becoming/chapters/08-METHOD.md#open-items-ranked)。', text)
        self.assertLess(text.index('**伦理。**'), text.index('**看到了多远。**'))
        self.assertLess(text.index('**看到了多远。**'), text.index('伦理的枢纽'))
        self.assertEqual(text.count('在一个有限列表上'), 1)
        # widening stays at 07 §4.4 as a relation between two courses; the screen does not say it, and the review's find
        # names the ranking results only by the link
        self.assertEqual(text.count('扩大'), 0)
        self.assertIn('把[排序结果](../../theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order)所预设的范围与次序说清楚', text)
        self.assertIn('在这次检验中，渔民都没有被告知贻贝床时，所试过的指令没有一条保住了它', text)
        # round 6, Q5.2: the predictions as the experiment's home and the tests page give them
        self.assertIn('能够交谈的第二轮，冻结的四项预测对那个模型全部通过，对另一个模型有三项未通过；不能交谈的第一轮，七项预测中有五项未通过', text)
        self.assertNotIn('多数没有通过', text)
        # round 6, Q1.3: the making said right after 这是什么, where a reader sees it first
        paragraphs = text.split('\n\n')
        at = next(k for k, p in enumerate(paragraphs) if p.startswith('**这是什么。**'))
        self.assertTrue(paragraphs[at + 1].startswith('这项工作借助 AI 做成'))
        for old in ('两种读法', '扩大可形成者', '未奠定根据', '就会锁定', '所读之外的什么',
                    '列出的进程', '尚未合为一条定理', '与之一同延续者', '渐渐', '一个继续下去的生命',
                    '不计时间', '第二个前提', '有所值', '已论证', '达不到', '与之同提', '终会停止容纳', '尚未陈述为一条定理',
                    '来持守', '在那里', '正的赋权', '别无他物', '这里把一种排序性质称为', '即更多的未来', '较广的进程',
                    '看见它们是必要的', '依一种读法', '这一点尚未表明', '对所择者的过滤', '每一延续', '只在只有一个中心时成立',
                    '谱系', '并没有形成一种次序', '在这种读法下说的正是这个', '什么会终结',
                    '范围之内者', '容纳已判定', '只证明了这一个方向', '只从某一步起才成立', '都作用到其他每一个', '一道筛选',
                    '每一个延续都可以', '续无外于后', '流在时间中', '它实际所走的进程从来',
                    # AG-F: the chain and its scope, which 07 §4 and its records hold
                    '水平路径', '（步，形成）对', '跨越所有步来读', '按时间来读', '在时间中相互依存', '直接组合', '没有尽头地延续',
                    '论证路线', '延续条件', '大于零的权重', '另加前提', '未必把依存于它的那些也算进来'):
            self.assertNotIn(old, text)

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
                           ('{{count:invented}}', 'unknown status'), ('{{stated:theories/becoming/ONE-PAGE.zh.md}}', 'states no reading time'),
                           ('{{tests:nearly}}', 'unknown count of tests'), ('{{tests:ran}}', 'tests.json cannot be read')):
            with self.subTest(body=body):
                pages, errors = self.render('# 首\n\n' + body + '\n')
                self.assertEqual(pages, {})
                self.assertTrue(any(word in e for e in errors), errors)


class EditionsTests(unittest.TestCase):
    """How far each translated edition follows its English: a dated banner where the English has moved on, written by
    the render and required by the check; --revised records a revision against a committed English."""

    def setUp(self):
        import json
        import tempfile
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        for page, english in zh_fronts.tracked().items():
            if page != zh_fronts.TEMPLATE:
                self.write(page, f'# 页\n\n{zh_fronts.nav_line(page)}\n\n*约 1 分钟读完。*\n\n正文。\n')
            self.write(english, f'# Page\n\n[中文](x.zh.md) · [One page](o.md)\n\nText of {english}.\n')
        self.write(zh_fronts.TEMPLATE, '<!-- note -->\n\n# 首\n\n{{nav}}\n\n正文。\n')
        held = {p: {'revised': '2026-11-08', 'english': zh_fronts.edition_digest((self.root / e).read_text(encoding='utf-8')),
                    'chinese': zh_fronts.edition_digest((self.root / p).read_text(encoding='utf-8')), 'english_commit': 'abc1234'}
                for p, e in zh_fronts.tracked().items()}
        self.write(zh_fronts.EDITIONS, json.dumps({'editions': held}))
        self.page = 'theories/becoming/USES.zh.md'

    def write(self, rel, body):
        (self.root / rel).parent.mkdir(parents=True, exist_ok=True)
        (self.root / rel).write_text(body, encoding='utf-8')

    def text(self, rel):
        return (self.root / rel).read_text(encoding='utf-8')

    def test_a_note_the_navigation_line_or_a_link_target_changes_no_digest(self):
        d = zh_fronts.edition_digest
        base = '# Page\n\n[中文](a.zh.md)\n\nBody, [a test](x/README.md#r).\n'
        self.assertEqual(d(base), d('<!-- a\nnote -->\n# Page\n\n[Home](README.md) · [中文](a.zh.md) · **Read**\n\nBody, [a test](y/README.md).\n'))
        self.assertNotEqual(d(base), d(base.replace('Body', 'Body changed')))
        self.assertNotEqual(d(base), d(base.replace('a test', 'another test')))
        # only the navigation line goes: a line of the body linking a Chinese page still counts
        self.assertNotEqual(d(base + '\nSee [中文](b.zh.md) for more.\n'), d(base + '\nSee [中文](b.zh.md) for less.\n'))
        zh = '# 页\n\n[English](a.md) · [首页](README.zh.md)\n\n正文。\n'
        self.assertEqual(d(zh), d(zh.replace('[English](a.md) · [首页](README.zh.md)\n', '[English](a.md) · [首页](README.zh.md)\n\n' + zh_fronts.BANNER + '它依……*\n')))

    def test_a_banner_right_under_the_line_with_no_blank_is_taken_out_too(self):
        nav = zh_fronts.nav_line(self.page)
        page = self.text(self.page).replace(nav + '\n\n', nav + '\n' + zh_fronts.BANNER + '旧的。*\n\n')
        self.assertEqual(zh_fronts.with_banner(page, None, nav), self.text(self.page))

    def test_a_banner_like_line_elsewhere_is_left_alone(self):
        page = self.text(self.page) + '\n' + zh_fronts.BANNER + '这一行在正文里。*\n'
        self.write(self.page, page)
        self.assertEqual(zh_fronts.with_banner(page, None, zh_fronts.nav_line(self.page)), page)

    def test_current_editions_carry_no_banner(self):
        self.assertEqual(zh_fronts.banner_problems(self.root), [])
        self.assertEqual(zh_fronts.write_banners(self.root), ([], []))

    def test_a_changed_english_needs_a_dated_banner_which_the_render_writes_and_a_revision_removes(self):
        english = zh_fronts.FRONTS[self.page]
        self.write(english, self.text(english).replace('Text of', 'New text of'))
        problems = zh_fronts.banner_problems(self.root)
        self.assertEqual(len(problems), 1)
        self.assertIn(self.page, problems[0])
        self.assertIn('--revised ' + self.page, problems[0])
        before = self.text(self.page)
        self.assertEqual(zh_fronts.write_banners(self.root), ([self.page], []))
        after = self.text(self.page)
        want = ('*本版落后于英文版：它依 2026 年 11 月 8 日的[英文版](USES.md)译出，英文版此后有改动，本版尚未随之修订；'
                '有出入处，以英文版为准。*')
        self.assertIn(zh_fronts.nav_line(self.page) + '\n\n' + want + '\n\n*约 1 分钟读完。*', after)
        self.assertEqual(after.replace(want + '\n\n', ''), before)  # nothing else on the page touched
        self.assertEqual(zh_fronts.banner_problems(self.root), [])
        self.assertEqual(zh_fronts.write_banners(self.root), ([], []))  # a fixed point
        self.write(english, self.text(english).replace('New text of', 'Text of'))  # the English back where the edition is
        self.assertEqual(zh_fronts.write_banners(self.root), ([self.page], []))
        self.assertEqual(self.text(self.page), before)

    def test_the_landing_page_says_so_where_the_first_screen_has_moved_on(self):
        pages, errors = zh_fronts.render([], {}, self.root)
        self.assertEqual(errors, [])
        self.assertNotIn(zh_fronts.BANNER, pages[zh_fronts.PAGE])
        self.write(zh_fronts.TEMPLATE_SOURCE, 'A new first screen.\n')
        pages, errors = zh_fronts.render([], {}, self.root)
        self.assertEqual(errors, [])
        self.assertIn(zh_fronts.nav_line(zh_fronts.PAGE) + '\n\n*本版落后于英文版：它依 2026 年 11 月 8 日的[英文版](README.md)译出', pages[zh_fronts.PAGE])

    def test_a_malformed_or_incomplete_record_is_an_error(self):
        import json
        good = json.loads(self.text(zh_fronts.EDITIONS))
        for edit, word in ((lambda d: d['editions'].pop(self.page), 'has no entry'),
                           (lambda d: d['editions'].update({'X.zh.md': d['editions'][self.page]}), 'no translated front'),
                           (lambda d: d['editions'][self.page].update(revised='8 Nov'), 'needs "revised"'),
                           (lambda d: d.pop('editions'), 'is not a JSON object')):
            with self.subTest(word=word):
                data = json.loads(json.dumps(good))
                edit(data)
                self.write(zh_fronts.EDITIONS, json.dumps(data))
                self.assertTrue(any(word in e for e in zh_fronts.banner_problems(self.root)), zh_fronts.banner_problems(self.root))
                self.assertEqual(zh_fronts.write_banners(self.root)[0], [])

    def test_revised_records_today_against_a_committed_english_only(self):
        import json
        import subprocess
        git = lambda *a: subprocess.run(['git', '-C', str(self.root), *a], capture_output=True, text=True, check=True)
        git('init', '-q'); git('add', '-A'); git('-c', 'user.name=t', '-c', 'user.email=t@t', 'commit', '-qm', 'x')
        english = zh_fronts.FRONTS[self.page]
        self.write(english, self.text(english).replace('Text of', 'New text of'))
        found = zh_fronts.record_revised([self.page], self.root, today='2026-11-09')
        self.assertTrue(found and 'uncommitted' in found[0], found)
        git('-c', 'user.name=t', '-c', 'user.email=t@t', 'commit', '-qam', 'y')
        found = zh_fronts.record_revised([self.page], self.root, today='2026-11-09')  # the Chinese was not touched
        self.assertTrue(found and 'unchanged since it was last recorded' in found[0], found)
        self.write(self.page, self.text(self.page).replace('正文。', '新的正文。'))
        self.assertEqual(zh_fronts.record_revised([self.page], self.root, today='2026-11-09'), [])
        entry = json.loads(self.text(zh_fronts.EDITIONS))['editions'][self.page]
        commit = git('log', '-1', '--format=%h', '--', english).stdout.strip()
        self.assertEqual(entry, {'revised': '2026-11-09', 'english': zh_fronts.edition_digest(self.text(english)),
                                 'chinese': zh_fronts.edition_digest(self.text(self.page)), 'english_commit': commit})
        self.assertEqual(zh_fronts.banner_problems(self.root), [])
        self.assertEqual(zh_fronts.record_revised(['README.md'], self.root), ['not a translated front: README.md'])
        # a new English that needs no change in the Chinese: recorded only with the reason, which the entry keeps
        self.write(english, self.text(english) + 'A typo fixed.\n')
        git('-c', 'user.name=t', '-c', 'user.email=t@t', 'commit', '-qam', 'z')
        self.assertTrue(zh_fronts.record_revised([self.page], self.root, today='2026-11-10'))
        self.assertEqual(zh_fronts.record_revised([self.page], self.root, today='2026-11-10', unchanged='an English typo'), [])
        self.assertEqual(json.loads(self.text(zh_fronts.EDITIONS))['editions'][self.page]['unchanged'], 'an English typo')
        other = 'theories/becoming/ONE-PAGE.zh.md'  # given with the reason, but its Chinese did change: no reason kept for it
        self.write(other, self.text(other).replace('正文。', '改过的正文。'))
        self.write(self.page, self.text(self.page))
        self.assertEqual(zh_fronts.record_revised([self.page, other], self.root, today='2026-11-10', unchanged='an English typo'), [])
        self.assertNotIn('unchanged', json.loads(self.text(zh_fronts.EDITIONS))['editions'][other])
        # an entry for a file no longer a front is dropped by the next record, not left to block the check
        data = json.loads(self.text(zh_fronts.EDITIONS))
        data['editions']['OLD.zh.md'] = data['editions'][self.page]
        self.write(zh_fronts.EDITIONS, json.dumps(data))
        self.write(self.page, self.text(self.page).replace('新的正文。', '又新的正文。'))
        self.assertEqual(zh_fronts.record_revised([self.page], self.root, today='2026-11-11'), [])
        self.assertNotIn('OLD.zh.md', json.loads(self.text(zh_fronts.EDITIONS))['editions'])


if __name__ == '__main__':
    unittest.main()
