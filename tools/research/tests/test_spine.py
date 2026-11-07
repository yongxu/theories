import json
import math
import re
import sys
import unittest
from pathlib import Path
from unittest import mock

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))
from tools.research import spine  # noqa: E402

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


class Geometry(unittest.TestCase):
    def centres(self):
        out = {}
        for i, k in enumerate(ORDER):
            a = -math.pi / 2 + i * 2 * math.pi / len(ORDER)
            out[k] = (spine.CX + spine.RING * math.cos(a), spine.CY + spine.RING * math.sin(a))
        return out

    def test_curves_stay_inside_the_ring_and_clear_of_the_grammar(self):
        c = self.centres()
        for a in ORDER:
            for b in ORDER:
                if a == b:
                    continue
                for lane in (0.0, 1.0):
                    _, point = spine.curve(c[a], 40, c[b], 40, lane)
                    x, y = point(0.5)
                    d = math.hypot(x - spine.CX, y - spine.CY)
                    self.assertLess(d, spine.RING - 40, (a, b, lane))
                    self.assertGreater(d, 56, (a, b, lane))

    def test_two_directions_of_a_pair_take_different_lanes(self):
        c = self.centres()
        _, outer = spine.curve(c['root'], 40, c['map'], 40, 0.0)
        _, inner = spine.curve(c['map'], 40, c['root'], 40, 1.0)
        self.assertGreater(math.dist(outer(0.5), inner(0.5)), 20)


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
        out = spine.svg(graph(), s, 'en')
        # root to map (12) is drawn, darker since the root comes first; map to root (3) is under the threshold
        self.assertIn('>12</text>', out)
        self.assertNotIn('>3</text>', out.split('</defs>', 1)[1].split('How to read it')[0])

    def test_section_tables_every_pair_and_counts_what_is_not_drawn(self):
        g = graph()
        lines = spine.section(g, 'theories/becoming/results/THEORY-GRAPH.md')
        body = '\n'.join(lines)
        self.assertIn('](spine.svg)', body)
        self.assertIn('| The root | The map | 12 | 0 | 0 | 0 |', body)
        self.assertIn('| The map | The root | 3 | 0 | 0 | 0 |', body)
        self.assertIn('| Life and evolution | The root | 0 | 0 | 0 | 1 |', body)
        self.assertIn('1 pair with fewer than 10 formal-reuse uses (3 uses)', body)
        rows = [l for l in lines if l.startswith('| ') and not l.startswith('| Edges from results of')]
        total = sum(int(c) for l in rows for c in l.strip('|').split('|')[2:])
        kinds = sum(1 for e in g['edges'] if e['type'] in spine.KINDS)
        self.assertEqual(total, kinds)


if __name__ == '__main__':
    unittest.main()
