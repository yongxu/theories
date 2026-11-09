import datetime as dt
import json
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))
from tools.research import lineage, zh_fronts  # noqa: E402

STATIC = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rw-spine/lineage_static.json'


def point(id_, date, label='public', path='notes/a.md', quote='the first words', thread=False, private=False, origin='person'):
    return {'id': id_, 'date': date, 'title': {'en': f'Point {id_}', 'zh': f'点 {id_}'},
            'what': {'en': 'It changed.', 'zh': '它变了。'}, 'label': label, 'thread': thread, 'origin': origin,
            'evidence': [{'path': path, 'locator': 'line 1', 'quote': '' if private else quote, 'private': private}]}


class Tree(unittest.TestCase):
    """A temporary repository: two records with dated history, a crosswalk, and the files the points cite."""

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        root = Path(self.tmp.name)
        (root / lineage.RECORDS).mkdir(parents=True)
        (root / lineage.RECORDS / 'a.json').write_text(json.dumps({'history': [
            {'en': '28 October 2026: added.'}, {'en': '2026-10-27: renamed.'}, {'en': 'no date here'}]}))
        (root / lineage.RECORDS / 'b.json').write_text(json.dumps({'history': [{'en': '3 November 2026: corrected.'}]}))
        (root / Path(lineage.CORRESPONDENCES).parent).mkdir(parents=True)
        (root / lineage.CORRESPONDENCES).write_text(json.dumps([
            {'group': 'g1', 'carried': 'carried'}, {'group': 'g1', 'carried': 'changed'}, {'group': 'g2', 'carried': 'changed'}]))
        (root / 'theories/becoming/results/atlas/CROSSWALK.md').write_text(
            'Weighted, that estimates 82.6% holding, 14.2% with a label or role wrong and 3.2% with a wrong reading over all 1183.\n')
        (root / 'notes').mkdir()
        (root / 'notes/a.md').write_text('Here are *the first* words of a note.\n')
        self.root = root
        self.patch = mock.patch.object(lineage, 'ROOT', root)
        self.patch.start()
        static = json.loads(STATIC.read_text())
        self.spec = {**static, 'points': [point('a', '2024-07'), point('b', '2026-10-28', thread=True, origin='drafted'),
                                          point('c', '2026-11-03', 'private', 'sources/12-x/chat.md', private=True, origin='ai')],
                     'thread': {'title': {'en': 'One thread', 'zh': '一条线索'}, 'intro': {'en': 'It ran.', 'zh': '它延续。'},
                                'points': ['a', 'b']},
                     'phases': [{'id': 'old', 'from': '2024-01', 'to': '2024-12', 'name': {'en': 'Old', 'zh': '旧'},
                                 'what': {'en': 'It began.', 'zh': '它开始。'}, 'points': ['a']},
                                {'id': 'new', 'from': '2026-10-01', 'to': '2026-11-08', 'name': {'en': 'New', 'zh': '新'},
                                 'what': {'en': 'It grew.', 'zh': '它长大。'}, 'points': ['b', 'c']}],
                     'renames': [{'date': '2026-10-27', 'from': 'old', 'to': 'new', 'where': {'en': 'here', 'zh': '这里'},
                                  'evidence_path': 'notes/a.md', 'quote': 'first words', 'label': 'public'}],
                     'papers': [{'id': 'p', 'title': 'A paper', 'date': '2026-10-02', 'paths': ['notes/a.md'],
                                 'claimed': {'en': 'It claimed.', 'zh': '它主张。'}, 'stands': {'en': 'Part stands.', 'zh': '部分成立。'},
                                 'stands_basis': ['notes/a.md'], 'label': 'public'}]}

    def tearDown(self):
        self.patch.stop()
        self.tmp.cleanup()

    def test_a_good_spec_checks_clean(self):
        self.assertEqual(lineage.check(self.spec), [])

    def test_errors_name_what_broke(self):
        s = json.loads(json.dumps(self.spec))
        s['points'][1]['date'] = '2023-01'
        s['points'][0]['label'] = 'rumour'
        s['points'][2]['evidence'][0]['private'] = False
        s['renames'][0]['quote'] = 'words that are not there'
        s['thread']['points'].append('zz')
        s['points'][0]['origin'] = 'hearsay'
        errors = '\n'.join(lineage.check(s))
        self.assertIn("unknown origin 'hearsay'", errors)
        self.assertIn('point b: out of date order', errors)
        self.assertIn("unknown label 'rumour'", errors)
        self.assertIn('no such path sources/12-x/chat.md', errors)
        self.assertIn('no longer holds', errors)
        self.assertIn('names no point zz', errors)

    def test_the_live_arc_in_brief_is_at_most_240_words(self):
        words = json.loads((ROOT / lineage.DATA).read_text(encoding='utf-8'))['words']['en']['arc_short']
        self.assertLessEqual(len(words.replace('**The arc in brief.** ', '').split()), 240)  # the brief glosses its terms in place

    def test_history_by_week_reads_both_date_forms(self):
        weeks, undated = lineage.history_by_week()
        self.assertEqual(weeks, {dt.date(2026, 10, 26): 2, dt.date(2026, 11, 2): 1})
        self.assertEqual(undated, 1)

    def test_pages_are_generated_in_both_languages(self):
        with mock.patch.object(lineage, 'spec', return_value=self.spec):
            pages, errors = lineage.render()
        self.assertEqual(errors, [])
        self.assertEqual(set(pages), set(lineage.PAGE.values()) | set(lineage.SVG.values()))
        en, zh = pages[lineage.PAGE['en']], pages[lineage.PAGE['zh']]
        self.assertTrue(en.startswith('<!-- Generated by'))
        self.assertIn('At `7040940cd` (8 November 2026) the repository held 6,087 commits, a count taken at that commit', en)
        self.assertIn('| 3 | 2026-11-03 |', en)
        self.assertIn('`sources/12-x/chat.md` (not in this repository)', en)
        self.assertIn('[`notes/a.md`](../notes/a.md)', en)
        self.assertIn('| 1 | 0 | 2 | 0 | 0 | 0 |', en)
        self.assertIn('## 一条线索', zh)
        svg = pages[lineage.SVG['en']]
        self.assertNotIn('<script', svg)
        # two public points, two legend circles and four for who wrote it; the private one a diamond
        self.assertEqual(svg.count('<circle'), 2 + 1 + 1 + 3)  # points; the key's public and thread; the three who-wrote marks that occur
        self.assertIn('fill="#a8a29e"', svg)  # point b, AI-drafted
        self.assertIn("| 2 | 2026-10-28 |", en)
        self.assertIn("AI-drafted from a person's words |", en)
        self.assertIn("1 by a person", en)
        self.assertIn("- **not stated** (none so far)", en)
        self.assertNotIn('not stated (none', svg)  # the picture's key lists only what occurs
        self.assertIn('- **1.** **2024-07, Point a.**', en)  # a thread's numbers are the table's, in the text
        self.assertIn('[来源 1 处](#src-2)', zh)
        self.assertIn('<a id="src-2"></a>**2.**', zh)
        self.assertIn('- **Old** (2024-01 – 2024-12). It began. (points 1–1; all public; 1 by a person)', en)
        self.assertIn('Of the 3:', en)
        self.assertIn('private and unpublished** (1)', en)
        self.assertIn('AI reconstruction** (none so far)', en)
        self.assertIn('[`notes/a.md`](../notes/a.md?plain=1#L1) (line 1)', en)
        self.assertIn('来源 1 处', zh)
        self.assertIn(zh_fronts.nav_line(lineage.PAGE['zh']) + '\n\n*', zh)

    def test_the_short_arc_the_weeks_and_one_shape_so_far(self):
        s = json.loads(json.dumps(self.spec))
        s['points'][2] = point('c', '2026-11-03', origin='ai')
        s['words']['en'].update(arc_short='**The arc in brief.** It grew.', labels_all='{label}, all {n} so far; none yet {others}',
                                marks_note='Height only keeps marks apart.')
        s['words']['zh'].update(arc_short='**弧线简述。** 它长大了。', labels_all='{label}：迄今全部 {n} 个；尚无「{others}」', marks_note='高度只为让标记不相重叠。')
        with mock.patch.object(lineage, 'spec', return_value=s):
            pages, errors = lineage.render()
        self.assertEqual(errors, [])
        en, svg, zh = pages[lineage.PAGE['en']], pages[lineage.SVG['en']], pages[lineage.SVG['zh']]
        self.assertLess(en.index('**The arc in brief.** It grew.'), en.index('## '))  # the ten-minute part opens the page
        self.assertIn('>public, all 3 so far; none yet private and unpublished, or AI reconstruction</text>', svg)
        self.assertIn('>26 Oct</text>', svg)
        self.assertIn('>2 Nov</text>', svg)
        self.assertIn('>11月2日</text>', zh)
        self.assertIn('>Height only keeps marks apart.</text>', svg)
        self.assertEqual(lineage.week_label(dt.date(2026, 10, 12), 'en'), '12 Oct')

    def test_the_earlier_folders_dated_and_read_against(self):
        (self.root / 'theories/f1').mkdir(parents=True)
        (self.root / 'theories/f1/README.md').write_text('# One\n\nWritten in March 2024.\nDone by August 2025.\n')
        s = json.loads(json.dumps(self.spec))
        s['folders'] = [{'folder': 'f1', 'from': '2024-03', 'to': '2025-08', 'basis': 'folder',
                         'evidence': [{'path': 'theories/f1/README.md', 'quote': 'Written in March 2024'},
                                      {'path': 'theories/f1/README.md', 'quote': 'Done by August 2025'}]}]
        for lang, intro, page_word in (('en', 'Each folder:', 'what became of it'), ('zh', '每个文件夹：', '其后如何（英文）')):
            s['words'][lang].update(folders_table=intro, folders_columns=['a', 'b', 'c', 'd', 'e', 'f'], folder_page=page_word)
        self.assertEqual(lineage.check(s), [])
        atlas = json.dumps({'correspondence_groups': [{'id': 'cxg-f1', 'title': {'en': 'Folder one'}, 'kind': 'theory', 'entries': 5}]})
        against = {'cxg-f1': [('ch-05', '05 Joint', 'theories/becoming/chapters/05-COLLECTIVES.md', 3),
                              ('one-page', 'The one page', 'theories/becoming/ONE-PAGE.md', 2)]}
        with mock.patch.object(lineage, 'spec', return_value=s):
            pages, errors = lineage.render(atlas, against)
        self.assertEqual(errors, [])
        self.assertIn('| [Folder one](f1/README.md) | [2024-03](f1/README.md?plain=1#L3) – [2025-08](f1/README.md?plain=1#L4) | '
                      'theory | 5 | [05](becoming/chapters/05-COLLECTIVES.md) (3), [The one page](becoming/ONE-PAGE.md) (2) | '
                      '[what became of it](becoming/results/atlas/crosswalk/f1.md) |', pages[lineage.PAGE['en']])
        self.assertIn('| 理论 | 5 | [05](becoming/chapters/05-COLLECTIVES.md)（3）、[一页](becoming/ONE-PAGE.md)（2） |', pages[lineage.PAGE['zh']])
        s['folders'][0]['evidence'][1]['quote'] = 'Done by May 2025'
        (self.root / 'theories/f2').mkdir()
        errors = '\n'.join(lineage.check(s))
        self.assertIn("no longer holds 'Done by May 2025'", errors)
        self.assertIn("the dated folders ['f2'] differ from theories/", errors)

    def test_evidence_at_a_commit_is_read_there_and_named(self):
        s = json.loads(json.dumps(self.spec))
        s['points'][1]['evidence'] = [{'path': '_process/BOARD.md', 'locator': 'Queue line', 'quote': 'X landed', 'private': False,
                                       'commit': 'abc123456'}]
        with mock.patch.object(lineage, '_read_at', return_value='- **Queue:** X landed (content tip `1`).\n'):
            self.assertEqual(lineage.check(s), [])
            with mock.patch.object(lineage, 'spec', return_value=s):
                pages, _ = lineage.render()
        self.assertIn('`_process/BOARD.md` at commit `abc123456` (Queue line)', pages[lineage.PAGE['en']])
        self.assertIn('提交 `abc123456` 中的 `_process/BOARD.md`', pages[lineage.PAGE['zh']])
        with mock.patch.object(lineage, '_read_at', return_value='- **Queue:** nothing.\n'):
            self.assertTrue(any('no longer holds' in e for e in lineage.check(s)))

    def test_the_english_edition_opens_with_the_navigation_line(self):
        with mock.patch.object(lineage, 'spec', return_value=self.spec):
            pages, _ = lineage.render()
        en = pages[lineage.PAGE['en']]
        nav = ' · '.join(lineage.navigation.link(p, lineage.PAGE['en'], label) for p, label in lineage.navigation.NAV)
        self.assertIn('# How the account grew\n\n' + nav + '\n\n[中文](LINEAGE.zh.md) · ', en)

    def test_a_mark_not_stated_keeps_its_dot_on_the_thread(self):
        for on_thread in (False, True):
            mark = lineage.marker(10, 10, 'public', on_thread, 'unstated')
            self.assertIn('r="2.2"', mark)
            self.assertNotIn('r="2.2"', lineage.marker(10, 10, 'public', on_thread, 'ai'))
        self.assertEqual(lineage.marker(10, 10, 'reconstruction', False, 'unstated').count('stroke-dasharray'), 1)

    def test_titles_that_would_cross_stop_the_render(self):
        def crossing(placed, lang, thread):
            return [(0, 100, 400, '1 · A long title over its neighbour', 'start', {}), (1, 120, 400, '2 · Above', 'start', {})]
        with mock.patch.object(lineage, 'spec', return_value=self.spec), mock.patch.object(lineage, 'title_rows', crossing):
            pages, errors = lineage.render()
        self.assertEqual(pages, {})
        self.assertTrue(any('titles cross or overlap' in e for e in errors), errors)

    def test_no_leader_crosses_a_title_in_the_live_picture(self):
        self.patch.stop()
        try:
            s = lineage.spec()
            placed, _ = lineage.lanes_of(s, lineage.axis(s), 470)
            thread = {pid for th in lineage.threads_of(s) for pid in th['points']}
            for lang in ('en', 'zh'):
                rows = lineage.title_rows(placed, lang, thread)
                self.assertEqual(lineage.title_crossings(rows, thread), [], lang)
                self.assertEqual(lineage.leaders_through_marks(placed, rows), [], lang)
        finally:
            self.patch.start()

    def test_the_live_chinese_edition_carries_the_fronts_line(self):
        self.patch.stop()
        try:
            self.assertEqual(zh_fronts.problems(pages=(lineage.PAGE['zh'],)), [])
        finally:
            self.patch.start()

    def test_a_titled_point_stands_above_others_at_its_date(self):
        s = json.loads(json.dumps(self.spec))
        s['points'][1]['short'] = {'en': 'B', 'zh': 'B'}
        s['points'].insert(2, point('b2', '2026-10-28'))
        s['points'].insert(3, point('b3', '2026-10-30'))  # a few days on: a few px to the right, within a mark's reach
        at = {'2024-07': 100.0, '2026-10-28': 300.0, '2026-10-30': 305.0, '2026-11-03': 500.0}
        with mock.patch.object(lineage, 'x_of', lambda d, segments: at[d.isoformat()[:7] if d.day == 1 and d.month == 7 else d.isoformat()]):
            placed, lanes = lineage.lanes_of(s, None, 400)
        y = {p['id']: py for _, p, _, py in placed}
        self.assertLess(y['b'], min(y['b2'], y['b3']))  # higher on the page: the titled one's leader rises past nothing
        self.assertEqual([n for n, *_ in placed], [1, 2, 3, 4, 5])  # numbers stay the table's
        self.assertEqual(lanes, 3)

    def test_the_strands_count_points_on_threads_and_folders_cited(self):
        (self.root / 'theories/fork').mkdir(parents=True)
        (self.root / 'theories/fork/README.md').write_text('x')
        (self.root / 'theories/other').mkdir()
        (self.root / 'theories/other/README.md').write_text('x')
        s = json.loads(json.dumps(self.spec))
        s['points'][0]['evidence'][0]['path'] = 'theories/fork/README.md'
        self.assertEqual(lineage.strand_counts(s), {'total': 3, 'on_threads': 2, 'on_none': 1, 'cited': 1, 'folders_n': 2})

    def test_the_axis_gives_each_phase_room_by_its_points(self):
        segments = lineage.axis(self.spec)
        widths = [s[3] - s[2] for s in segments if s[4]]
        self.assertAlmostEqual(widths[1] / widths[0], (2 + 3) / (1 + 3))  # two points against one, three added to each
        self.assertEqual([round(s[3] - s[2]) for s in segments if s[4] is None], [lineage.GAP])
        self.assertLess(lineage.x_of(dt.date(2024, 6, 1), segments), lineage.x_of(dt.date(2026, 10, 15), segments))


if __name__ == '__main__':
    unittest.main()
