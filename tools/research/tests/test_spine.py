import json
import math
import re
import sys
import unittest
from pathlib import Path
from unittest import mock

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))
from tools.research import spine, zh_fronts  # noqa: E402

ORDER = ['root', 'map', 'knowing', 'life', 'collective', 'classical', 'significance', 'method']


def node(id_, type_, region, **kw):
    return {'id': id_, 'type': type_, 'region': region, **kw}


def graph():
    """Two results per region, a module each, uses in both directions between root and map, and one of each other kind."""
    nodes = [node('concept:a', 'concept', 'root')]
    for k in ORDER:
        nodes += [node(f'record:{k}1', 'result', k), node(f'record:{k}2', 'result', k),
                  node(f'module:{k}', 'module', k, on_grammar=k == 'root')]
    edges = [{'from': 'record:root1', 'to': 'record:map1', 'type': 'formal-reuse'}] * 12 + \
            [{'from': 'record:map1', 'to': 'record:root1', 'type': 'formal-reuse'}] * 3 + \
            [{'from': 'record:map2', 'to': 'record:map1', 'type': 'formal-reuse'},
             {'from': 'record:knowing1', 'to': 'record:significance1', 'type': 'interpretive'},
             {'from': 'record:significance1', 'to': 'record:collective1', 'type': 'application'},
             {'from': 'record:life1', 'to': 'record:root2', 'type': 'related'},
             {'from': 'module:map', 'to': 'module:root', 'type': 'imports'}]
    return {'nodes': nodes, 'edges': edges}


class Counting(unittest.TestCase):
    def test_counts_by_region_and_kind(self):
        results, pairs, modules, concepts = spine.counts(graph(), ORDER)
        self.assertEqual(results['root'], 2)
        self.assertEqual(pairs[('root', 'map')]['formal-reuse'], 12)
        self.assertEqual(pairs[('map', 'root')]['formal-reuse'], 3)
        self.assertEqual(pairs[('map', 'map')]['formal-reuse'], 1)
        self.assertEqual(pairs[('life', 'root')]['related'], 1)
        self.assertEqual(set(pairs[('root', 'map')]), set(spine.KINDS))
        self.assertEqual(modules['root'], [1, 1])
        self.assertEqual(modules['map'], [1, 0])
        self.assertEqual(concepts, 1)

    def test_wrap_keeps_every_word_and_width(self):
        text = 'a verified inference using the cited result, the count of uses'
        lines = spine.wrap(text, 20, 'en')
        self.assertEqual(' '.join(lines), text)
        self.assertTrue(all(len(l) <= 20 for l in lines))
        zh = spine.wrap('一个从它所选择者读出的度量', 8, 'zh')
        self.assertEqual(''.join(zh), '一个从它所选择者读出的度量')
        self.assertTrue(all(len(l) <= 4 for l in zh))

    def test_items_wrap_between_items_only(self):
        body = '11 项推导而得 · 1 项在一个所述的假设之下 · 6 项为计数，位于文法以下 · 99 项处于一个指明的距离'
        lines = spine.wrap_items(body, 92, 'zh')
        self.assertEqual(' · '.join(lines), body)
        self.assertEqual(lines[-1], '99 项处于一个指明的距离')
        self.assertEqual(spine.wrap_items('ab · cd', 20, 'en'), ['ab · cd'])


class Geometry(unittest.TestCase):
    def layout(self):
        """The fixture with a pair across the ring (knowing and significance) and a pair at 90 degrees, both ways."""
        g = graph()
        more = [('knowing1', 'significance1', 12), ('significance1', 'knowing1', 11), ('root1', 'knowing1', 10),
                ('knowing1', 'root1', 13), ('map1', 'root1', 9)]
        for a, b, n in more:
            g['edges'] += [{'from': f'record:{a}', 'to': f'record:{b}', 'type': 'formal-reuse'}] * n
        results, pairs, modules, concepts = spine.counts(g, ORDER)
        return spine.layout(spine.spec(), results, pairs, 'en', 120)

    def test_no_curve_comes_near_the_grammar(self):
        L = self.layout()
        for c in L['curves']:
            for i in range(21):
                x, y = c['point'](i / 20)
                self.assertGreater(math.hypot(x - L['cx'], y - L['cy']), spine.GR + 6, (c['from'], c['to'], i))

    def test_a_pair_across_the_ring_goes_round_one_side(self):
        L = self.layout()
        mids = {(c['from'], c['to']): c['point'](0.5) for c in L['curves'] if c['kind'] == 'formal-reuse'}
        (x1, y1), (x2, y2) = mids[('knowing', 'significance')], mids[('significance', 'knowing')]
        self.assertGreater((y1 - L['cy']) * (y2 - L['cy']), 0, 'both directions on the same side of the centre')
        self.assertGreater(math.dist((x1, y1), (x2, y2)), 8, 'in different lanes')

    def test_two_directions_of_a_pair_take_different_lanes(self):
        L = self.layout()
        mids = {(c['from'], c['to']): c['point'](0.5) for c in L['curves'] if c['kind'] == 'formal-reuse'}
        self.assertGreater(math.dist(mids[('root', 'knowing')], mids[('knowing', 'root')]), 8)


class Checking(unittest.TestCase):
    def test_live_spec_holds_at_its_homes(self):
        self.assertEqual(spine.check(spine.spec()), [])

    def test_a_phrase_gone_from_its_home_is_an_error(self):
        s = spine.spec()
        real = spine._read

        def without(path):
            text = real(path)
            if path == s['theses_homes']['en']:
                text = text.replace('three frozen seabird tests did not reject it at their thresholds', 'three frozen seabird tests')
            return text

        with mock.patch.object(spine, '_read', side_effect=without):
            errors = spine.check(s)
        self.assertTrue(any('did not reject it' in e for e in errors), errors)

    def test_an_unknown_outcome_is_an_error(self):
        s = spine.spec()
        s['theses'][0] = {**s['theses'][0], 'outcome': 'passed'}
        self.assertTrue(any('unknown outcome' in e for e in spine.check(s)))


class Drawing(unittest.TestCase):
    def test_picture_is_self_contained_and_says_what_it_counts(self):
        s = spine.spec()
        for lang in ('en', 'zh'):
            out = spine.svg(graph(), s, lang)
            self.assertTrue(out.startswith('<svg xmlns="http://www.w3.org/2000/svg"'))
            self.assertNotIn('<script', out)
            self.assertNotIn('<foreignObject', out)
            self.assertIsNone(re.search(r'(?:href|src)="(?!#)', out), 'no external resource')
            self.assertIn('<title id="spine-title">', out)
            for t in s['theses']:
                self.assertIn(f'>{t["id"]}</text>', out)
        g = graph()
        g['edges'] += [{'from': 'record:root1', 'to': 'record:map1', 'type': 'formal-reuse'}] * 4 + \
            [{'from': 'record:knowing1', 'to': 'record:root1', 'type': 'formal-reuse'}] * 11
        out = spine.svg(g, s, 'en')
        drawing = out.split('</defs>', 1)[1].split('How to read it')[0]
        # root to map (16) is drawn and its count written; knowing to root (11) is drawn and not written; map to root
        # (3) is under the threshold and not drawn
        self.assertIn('>16</text>', drawing)
        self.assertNotIn('>11</text>', drawing)
        self.assertNotIn('>3</text>', drawing)
        self.assertIn('1 of 1 modules', drawing)

    def test_each_count_in_the_live_picture_sits_by_its_own_curve(self):
        g = json.loads((ROOT / 'theories/becoming/results/data/theory-graph.json').read_text(encoding='utf-8'))
        s = spine.spec()
        for lang in ('en', 'zh'):
            info = {}
            spine.svg(g, s, lang, info)
            self.assertTrue(info['counts'])
            for c, box in info['counts']:
                x, y = (box[0] + box[2]) / 2, (box[1] + box[3]) / 2

                def gap(curve):
                    return min(math.hypot(px - x, py - y) for px, py in (curve['point'](i / 200) for i in range(201)))
                nearest = min(info['curves'], key=gap)
                self.assertIs(nearest, c, (lang, c['from'], c['to'], c['n'], nearest['from'], nearest['to'], nearest['kind']))
                other = min(gap(o) for o in info['curves'] if o is not c)
                self.assertGreater(other, gap(c) + spine.LEAD - 0.5, (lang, c['n']))
                for circle in info['circles']:
                    self.assertTrue(spine.clear_of_circle(box, circle), (lang, c['n'], circle))
                for block in info['boxes']:
                    self.assertFalse(spine.overlaps(box, block), (lang, c['n'], block))
            placed = [box for _, box in info['counts']]
            for i, a in enumerate(placed):
                self.assertFalse(any(spine.overlaps(a, b) for b in placed[i + 1:]), (lang, a))

    def test_a_count_with_no_place_stops_the_render(self):
        g = (ROOT / 'theories/becoming/results/data/theory-graph.json').read_text(encoding='utf-8')
        with mock.patch.object(spine, 'LEAD', 500):
            pages, errors = spine.render(g)
        self.assertEqual(pages, {})
        self.assertTrue(any('no place for the count' in e for e in errors), errors)

    def test_a_count_on_a_circle_stops_the_render_though_nearest_its_curve(self):
        g = (ROOT / 'theories/becoming/results/data/theory-graph.json').read_text(encoding='utf-8')
        real = spine.place_box

        def grown(*a, **k):  # the same centre, so the lead still holds, and a box too large to clear anything
            box = real(*a, **k)
            return (box[0] - 200, box[1] - 200, box[2] + 200, box[3] + 200) if k.get('accept') else box
        with mock.patch.object(spine, 'place_box', grown):
            pages, errors = spine.render(g)
        self.assertEqual(pages, {})
        self.assertTrue(any('no place for the count' in e for e in errors), errors)

    def test_a_curve_behind_a_chapter_stops_the_render(self):
        g = (ROOT / 'theories/becoming/results/data/theory-graph.json').read_text(encoding='utf-8')
        with mock.patch.object(spine, 'LANE_STEP', 60):
            pages, errors = spine.render(g)
        self.assertEqual(pages, {})
        self.assertTrue(any('passes behind chapter' in e for e in errors), errors)

    def test_drawn_otherwise_names_the_kind(self):
        v = lambda f, i, a: {'formal-reuse': f, 'interpretive': i, 'application': a, 'related': 0}
        self.assertEqual(spine.drawn_otherwise({('a', 'b'): v(3, 0, 3), ('c', 'd'): v(1, 0, 1), ('e', 'f'): v(20, 9, 9)})[:2], (2, 'a dotted application curve'))
        self.assertEqual(spine.drawn_otherwise({('a', 'b'): v(3, 5, 0)})[:2], (1, 'a dashed interpretive curve'))
        self.assertEqual(spine.drawn_otherwise({('a', 'b'): v(3, 5, 0), ('c', 'd'): v(3, 0, 1)})[:2], (2, 'a dashed or dotted curve of another kind'))
        self.assertEqual(spine.drawn_otherwise({('a', 'b'): v(12, 0, 0)})[0], 0)

    def test_fronts_carry_the_two_sentences_above_the_picture(self):
        s = spine.spec()
        for path, lang in (('theories/becoming/ONE-PAGE.md', 'en'), ('theories/becoming/THE-THEORY-OF-BECOMING.md', 'en'),
                           ('theories/becoming/ONE-PAGE.zh.md', 'zh'), ('theories/becoming/THE-THEORY-OF-BECOMING.zh.md', 'zh')):
            text = (ROOT / path).read_text(encoding='utf-8')
            sentences = spine.how_to_read(s, lang)
            self.assertIn(sentences, text, path)
            self.assertLess(text.index(sentences), text.index('results/spine'), path)
        self.assertIn('About a tenth of the 117', spine.how_to_read(s, 'en'))
        self.assertIn('counting laws, below the grammar (6)', spine.how_to_read(s, 'en'))

    def test_the_chinese_page(self):
        page = spine.zh_page(graph())
        self.assertIn(zh_fronts.nav_line(spine.PAGE_ZH), page)
        self.assertIn('<a id="the-spine-what-it-shows-and-does-not-show"></a>', page)
        self.assertIn('| 根 | 生成、守与退化 | 12 | 0 | 0 | 0 |', page)
        self.assertIn('](spine.zh.svg)', page)
        self.assertRegex(page, r'\*约 [0-9–]+ 分钟读完。\*')

    def test_section_tables_every_pair_and_counts_what_is_not_drawn(self):
        g = graph()
        lines = spine.section(g, 'theories/becoming/results/THEORY-GRAPH.md')
        body = '\n'.join(lines)
        lead = '\n'.join(spine.lead(g, 'theories/becoming/results/THEORY-GRAPH.md'))
        self.assertIn('](spine.svg)', lead)
        self.assertIn('| derived | 11 |', lead)
        self.assertIn('| T6. ', lead)
        self.assertIn('| The root | The map | 12 | 0 | 0 | 0 |', body)
        self.assertIn('| The map | The root | 3 | 0 | 0 | 0 |', body)
        self.assertIn('| Life and evolution | The root | 0 | 0 | 0 | 1 |', body)
        self.assertIn('1 pair with fewer than 10 formal-reuse uses (3 uses)', body)
        rows = [l for l in lines if l.startswith('| ') and not l.startswith('| Edges from results of')]
        total = sum(int(c) for l in rows for c in l.strip('|').split('|')[2:])
        kinds = sum(1 for e in g['edges'] if e['type'] in spine.KINDS)
        self.assertEqual(total, kinds)


class Tables(unittest.TestCase):
    """The tables THEORY-GRAPH.md reads from 08 §7 and the edge record, against small inputs."""

    METHOD = ('<a id="shared-laws-and-connectivity"></a>\n## 7. Shared laws\n\n'
              '| Law | Statement | Anchor | On the grammar | Rows |\n|---|---|---|---|---:|\n'
              '| Closure | c | `W` | `«a»` | 4 |\n| Balance | b | `B` | represented both ways, not derived | 6 |\n\nNext.\n'
              'Of the 126 rows, 5 now reach the grammar: all 4 on closure and 2 of 6 on balance, and 1 on no anchor.\n\n## 8. Known\n'
              'Elsewhere, all 6 on balance.')

    def test_the_laws_table_and_how_many_reach_the_grammar(self):
        with mock.patch.object(spine, '_read', lambda path: self.METHOD if path == spine.METHOD else None):
            self.assertEqual(spine.shared_laws_rows(), [('Closure', 'c', False, 4), ('Balance', 'b', True, 6)])
            self.assertEqual(spine.reaching_the_grammar('Closure', 4), 4)
            self.assertEqual(spine.reaching_the_grammar('Balance', 6), 2)
            self.assertIsNone(spine.reaching_the_grammar('Balance', 7))  # the sentence no longer counts those rows
            self.assertEqual(spine.rows_reaching(), (5, 1))
            self.assertEqual(spine.shared_laws_cells(), [('Closure', '`«a»`'), ('Balance', 'represented both ways, not derived')])

    def test_a_cycle_among_recorded_uses_is_found(self):
        g = {'edges': [{'from': 'a', 'to': 'b', 'type': 'formal-reuse'}, {'from': 'b', 'to': 'c', 'type': 'formal-reuse'},
                       {'from': 'c', 'to': 'a', 'type': 'formal-reuse'}, {'from': 'c', 'to': 'd', 'type': 'formal-reuse'},
                       {'from': 'd', 'to': 'a', 'type': 'related'}]}
        self.assertEqual(spine.formal_cycles(g), (4, 4, [['a', 'b', 'c']]))
        g['edges'] = g['edges'][1:]
        self.assertEqual(spine.formal_cycles(g), (3, 4, []))
        self.assertIn('no result reaches itself', spine.circular_paragraph(g, 'en')[0])
        self.assertIn('condition of entry, not a finding', spine.circular_paragraph(g, 'en')[0])

    def test_a_basis_is_cut_after_its_first_sentence_and_keeps_its_standing(self):
        record = {'boundary': {'standings': [
            {'declaration': 'Becoming.X.y', 'standing': 'derived', 'law': ['Becoming.L'],
             'basis': {'en': 'A case of «L» at x, through Steps.along. Its other step is support. Its statement still reads as counting.'}},
            {'declaration': 'Becoming.X.z', 'standing': 'derived', 'law': [], 'basis': {'en': 'A case, e.g. the run, of «L». Then more.'}},
            {'declaration': 'Becoming.X.w', 'standing': 'named distance', 'basis': {'en': 'Far.'}},
            {'declaration': 'Becoming.X.v', 'standing': 'counting'}]}}
        with mock.patch.object(spine, '_read', lambda path: json.dumps(record) if path.endswith('.json') else None), \
                mock.patch.object(spine, 'ROOT', Path('/nonexistent')):
            rows = spine.derived_rows()
            self.assertEqual(spine.edge_bases(), (3, 1))
        self.assertEqual(rows[0][2], 'A case of «L» at x, through Steps.along. … Its statement still reads as counting.')
        self.assertEqual(rows[1][2], 'A case, e.g. the run, of «L».')  # an abbreviation's point is not a sentence's end


if __name__ == '__main__':
    unittest.main()
