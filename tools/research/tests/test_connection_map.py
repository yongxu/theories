import json
import re
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))
from tools.research import connection_map as cm  # noqa: E402

VOCABULARY = {'relations': [{'en': 'agreement', 'zh': '相合'}, {'en': 'divergence', 'zh': '相分'}],
              'carried': [{'en': c} for c in ('carried', 'not-carried', 'history-only', 'fresh-reading')]}
GRAPH = {'nodes': [{'id': 'result:r1', 'type': 'result', 'record': 'r1', 'status': 'recorded-checked', 'kind': 'theorem', 'title': 'Law one'},
                   {'id': 'section:' + cm.BECOMING + 'chapters/02-MAP.md#r-r1', 'type': 'section'},
                   {'id': 'text:A', 'type': 'text'}, {'id': 'text:B', 'type': 'text'}, {'id': 'text:C', 'type': 'text'}, {'id': 'text:D', 'type': 'text'}],
         'edges': [{'type': 'states', 'from': 'section:' + cm.BECOMING + 'chapters/02-MAP.md#r-r1', 'to': 'result:r1'},
                   {'type': 'read-as', 'from': 'text:A', 'to': 'result:r1', 'outcome': 'proved'},
                   {'type': 'read-as', 'from': 'text:B', 'to': 'result:r1', 'outcome': 'not expressible'},
                   {'type': 'names', 'from': 'text:C', 'to': 'concept:x'}],
         'classified_total': 9}
SHARED = {'boundary': {'counts': {'derived': 2, 'counting': 1, 'connected': 3, 'unplaced': 0}, 'groups': {'on the edge': 2, 'below the grammar': 1, 'distances': 3, 'unplaced': 0}},
          'central_reach': {'counts': {'reaching the grammar': 4, 'the rest': 2}}}


def entry(id_, group, carried='carried', relation='agreement', record='r1', basis='read-in-repo'):
    targets = [{'record': record, 'says': {'en': 'It says.'}}] if record else []
    return {'id': id_, 'name': {'en': id_}, 'group': group, 'carried': carried, 'relation': relation, 'sense': {'en': 'Sense.'}, 'quote': None,
            'reading': {'en': 'Read.'}, 'source': {'work': 'a.md', 'locator': 'head', 'basis': basis}, 'account_adds': None, 'source_adds': None,
            'absence': {'searched': ['x'], 'read': []} if carried in cm.ABSENT else None, 'targets': targets}


def group(id_, domain):
    return {'id': id_, 'title': {'en': id_}, 'domain': domain, 'kind': 'theory', 'summary': {'en': 'S.'}, 'read': ['a'], 'skimmed': [], 'searched': [],
            'not_mapped': [], 'coverage': None, 'by_carried': {}, 'by_relation': {}}


def atlas(*entries):
    return {'vocabulary': VOCABULARY, 'dynamics': [], 'correspondences': list(entries),
            'correspondence_groups': [group('cxg-early', 'earlier-folders'), group('cxg-greek', 'greek-roman')]}


class PayloadTests(unittest.TestCase):
    def data(self, *entries):
        return cm.payload(atlas(*entries), GRAPH, SHARED)

    def test_a_record_target_is_threaded_to_the_chapter_that_states_it(self):
        d = self.data(entry('cx-a', 'cxg-early'))
        self.assertEqual(d['entries'][0]['warps'], ['ch-02'])
        self.assertEqual([(w['id'], w['n']) for w in d['warp']], [('ch-02', 1)])
        self.assertEqual(d['entries'][0]['targets'][0]['status'], 'recorded-checked')

    def test_what_stayed_behind_is_counted_and_reaches_nothing(self):
        d = self.data(entry('cx-a', 'cxg-early'), entry('cx-b', 'cxg-early', 'not-carried', None, None), entry('cx-c', 'cxg-early', 'history-only', 'agreement'))
        self.assertEqual(d['totals']['loose'], 2)
        self.assertEqual(d['groups'][0]['loose'], 2)
        self.assertEqual([(w['id'], w['n']) for w in d['warp']], [('ch-02', 1)])
        self.assertNotIn('agreement-of-loose', d['totals']['relation'])
        self.assertEqual(d['totals']['relation'], {'agreement': 1})

    def test_meeting_needs_two_groups_and_marks_a_difference(self):
        d = self.data(entry('cx-a', 'cxg-early'), entry('cx-b', 'cxg-early'))
        self.assertEqual((d['points'], d['single']), ([], 1))
        d = self.data(entry('cx-a', 'cxg-early'), entry('cx-b', 'cxg-greek', 'fresh-reading', 'divergence', basis='ai-knowledge'))
        self.assertEqual([(p['key'], p['groups'], p['differ']) for p in d['points']], [('r1', 2, True)])
        self.assertEqual(d['totals']['from_knowledge'], 1)

    def test_the_standings_are_read_from_the_data_and_a_zero_is_left_out(self):
        d = self.data()
        self.assertEqual(d['declarations'], 6)
        self.assertEqual([(g['title'], g['n']) for g in d['standings']],
                         [('On the edge', 2), ('Below the grammar', 1), ('At a named distance, each with its reason', 3)])
        self.assertEqual([r['key'] for r in d['reach']], ['reaching the grammar', 'the rest'])

    def test_the_corpus_counts_come_from_the_edges(self):
        self.assertEqual(self.data()['corpus'], {'classified': 9, 'stating': 4, 'law': 1, 'no_law': 1, 'cited': 1, 'only': 1})


class LiveDataTests(unittest.TestCase):
    def test_every_standing_and_reach_in_the_data_is_worded(self):
        shared = json.loads((ROOT / cm.registry.SHARED_LAWS).read_text(encoding='utf-8'))
        worded = {k for _, _, rows in cm.STANDINGS for k, _, _ in rows}
        self.assertEqual(set(shared['boundary']['counts']) - worded, set())
        self.assertEqual(set(shared['boundary']['groups']) - {key for _, key, _ in cm.STANDINGS}, set())
        self.assertEqual(set(shared['central_reach']['counts']) - {k for k, _, _ in cm.REACH}, set())


class PageTests(unittest.TestCase):
    def setUp(self):
        hostile = entry('cx-a', 'cxg-early')
        hostile['reading'] = {'en': 'Ends </script><b> and a [link](nowhere.md).'}
        self.page = cm.page(cm.payload(atlas(hostile), GRAPH, SHARED))
        self.fragment = cm.fragment(cm.payload(atlas(hostile), GRAPH, SHARED, base=None))

    def test_text_cannot_close_the_script_or_trip_the_link_check(self):
        self.assertEqual(self.page.count('</script><b>'), 0)
        self.assertEqual(re.findall(r'\]\((<[^>]+>|[^\s)]+)\)', self.page), [])

    def test_the_data_comes_back_whole(self):
        blob = re.search(r'<script type="application/json" id="cx-data">(.*?)</script>', self.page, re.S).group(1)
        self.assertEqual(json.loads(blob)['entries'][0]['reading'], 'Ends </script><b> and a [link](nowhere.md).')

    def test_the_page_stands_alone(self):
        self.assertTrue(self.page.startswith('<!doctype html>'))
        self.assertIn(cm.GENERATED, self.page)
        self.assertEqual(re.findall(r'(?:src|href)="https?:', self.page), [])
        self.assertEqual(re.findall(r'@import|url\(http', self.page), [])

    def test_the_fragment_has_no_skeleton_and_no_repository_links(self):
        self.assertFalse(self.fragment.lstrip().lower().startswith('<!doctype'))
        self.assertNotIn('<html', self.fragment)
        self.assertIn('"base":null', self.fragment)

    def test_it_names_both_premises_where_it_speaks_of_the_ethics(self):
        self.assertIn('the continuation condition for scope and C for order', self.page)
        self.assertIn('their warrant is open', self.page)
        self.assertNotIn('derives from the condition', self.page)


if __name__ == '__main__':
    unittest.main()
