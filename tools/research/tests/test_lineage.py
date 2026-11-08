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
        self.assertIn('6,087 commits at `7040940cd`', en)
        self.assertIn('| 3 | 2026-11-03 |', en)
        self.assertIn('`sources/12-x/chat.md` (not in this repository)', en)
        self.assertIn('[`notes/a.md`](../notes/a.md)', en)
        self.assertIn('| 1 | 0 | 2 | 0 | 0 | 0 |', en)
        self.assertIn('## 一条线索', zh)
        svg = pages[lineage.SVG['en']]
        self.assertNotIn('<script', svg)
        # two public points, two legend circles and four for who wrote it; the private one a diamond
        self.assertEqual(svg.count('<circle'), 2 + 2 + 4)
        self.assertIn('fill="#a8a29e"', svg)  # point b, AI-drafted
        self.assertIn("| 2 | 2026-10-28 |", en)
        self.assertIn("AI-drafted from a person's words |", en)
        self.assertIn("1 by a person", en)
        self.assertIn("- **not stated** (none so far)", en)
        self.assertIn('- **Old** (2024-01 – 2024-12). It began. (points 1–1; all public; 1 by a person)', en)
        self.assertIn('Of the 3:', en)
        self.assertIn('private and unpublished** (1)', en)
        self.assertIn('AI reconstruction** (none so far)', en)
        self.assertIn('[`notes/a.md`](../notes/a.md?plain=1#L1) (line 1)', en)
        self.assertIn('来源 1 处', zh)
        self.assertIn(zh_fronts.nav_line(lineage.PAGE['zh']) + '\n\n*', zh)

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

    def test_no_leader_crosses_a_title_in_the_live_picture(self):
        self.patch.stop()
        try:
            s = lineage.spec()
            segments = lineage.axis(s)
            lanes, placed = [], []
            for n, p in enumerate(s['points'], 1):
                x = lineage.x_of(lineage.parse_date(p['date'])[0], segments)
                lane = next((i for i, last in enumerate(lanes) if x - last >= 17), len(lanes))
                if lane == len(lanes):
                    lanes.append(x)
                lanes[lane] = x
                placed.append((n, p, x, 454 - 17 * lane))
            for lang in ('en', 'zh'):
                self.assertEqual(lineage.title_crossings(lineage.title_rows(placed, lang)), [], lang)
        finally:
            self.patch.start()

    def test_the_live_chinese_edition_carries_the_fronts_line(self):
        self.patch.stop()
        try:
            self.assertEqual(zh_fronts.problems(pages=(lineage.PAGE['zh'],)), [])
        finally:
            self.patch.start()

    def test_the_axis_gives_each_phase_room_by_its_points(self):
        segments = lineage.axis(self.spec)
        widths = [s[3] - s[2] for s in segments if s[4]]
        self.assertAlmostEqual(widths[1] / widths[0], (2 + 3) / (1 + 3))  # two points against one, three added to each
        self.assertEqual([round(s[3] - s[2]) for s in segments if s[4] is None], [lineage.GAP])
        self.assertLess(lineage.x_of(dt.date(2024, 6, 1), segments), lineage.x_of(dt.date(2026, 10, 15), segments))


if __name__ == '__main__':
    unittest.main()
