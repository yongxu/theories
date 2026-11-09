"""The map's index (atlas_index.py) against what it promises: each store is read into its table, each join is counted
by its route (exact, through a shared folder, by mention, or not at all), a crosswalk target resolves to a record by name
or by its home anchor and otherwise joins nothing, the records the dynamics do not cite are counted by family and
chapter, the pilots measure without adding data, and the repository's own stores build and render."""
from pathlib import Path
import sqlite3
import sys
import unittest

ROOT = Path(__file__).resolve().parents[3]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from tools.research import atlas_index  # noqa: E402

CH = 'theories/becoming/chapters/'


def record(rid, status='recorded-checked', family='F01', kind='theorem', **more):
    r = {'id': rid, 'title': {'en': rid}, 'kind': kind, 'status': status, 'family': family, 'statement': {'en': 'S'},
         'hypotheses': [], 'references': [], 'laws': [], 'history': []}
    r.update(more)
    return r


def exit_(to=None, strength='sufficient', records=()):
    return {'to': to, 'law': None, 'edge': {'en': 'e'}, 'strength': strength, 'records': list(records), 'source': CH + '01-ROOT.md#x'}


def dynamic(did, family, records=(), **more):
    d = {'id': did, 'name': {'en': did}, 'family': family, 'mechanism': {'en': 'm'}, 'records': list(records),
         'standing': [{'record': r, 'status': 'recorded-checked', 'kind': 'theorem'} for r in records], 'declarations': [],
         'base': 'any type', 'hypotheses': [], 'forbids': None, 'exits': [], 'transitions': [], 'tests': [], 'open': [],
         'valence': 'none asserted', 'beyond': None, 'sources': [], 'standing_without_record': None if records else 'reading'}
    d.update(more)
    return d


def stores():
    records = [
        record('r1', hypotheses=[{'en': 'A balanced world (Balances) on a finite list.', 'zh': '平'}],
               references=[{'path': 'experiments/solo/data.csv', 'role': 'integration'}],
               laws=[{'en': 'l', 'declarations': ['Becoming.A.x']}], history=[{'en': 'Tested by SOLO1, not by SOLO1b.'}]),
        record('r2', family='F07'),
        record('r3', status='superseded'),
        record('r4', family='F99'),
    ]
    graph = {'nodes': [{'id': f'record:{r}', 'type': 'result', 'record': r} for r in ('r1', 'r2', 'r3', 'r4')] + [
        {'id': f'section:{CH}01-ROOT.md#r-r1', 'type': 'section', 'chapter': CH + '01-ROOT.md', 'anchor': 'r-r1'},
        {'id': f'section:{CH}07-SIGNIFICANCE.md#r-r2', 'type': 'section', 'chapter': CH + '07-SIGNIFICANCE.md', 'anchor': 'r-r2'}],
        'edges': [{'from': f'section:{CH}01-ROOT.md#r-r1', 'to': 'record:r1', 'type': 'states'},
                  {'from': f'section:{CH}07-SIGNIFICANCE.md#r-r2', 'to': 'record:r2', 'type': 'states'}]}
    atlas = {'vocabulary': {'families': [{'id': 'A', 'en': 'Absorption'}, {'id': 'B', 'en': 'Drains'}]},
             'dynamics': [
                 dynamic('d1', 'A', ['r1'], declarations=['A.x', 'B.y'], hypotheses=[{'record': 'r1', 'index': 1}],
                         exits=[exit_('d2'), exit_(None, 'witness', ['r1'])],
                         transitions=[{'kind': 'juncture', 'condition': {'en': 'c'}, 'declarations': [], 'records': ['r1']}],
                         tests=[{'path': 'experiments/solo', 'thesis': 'T1', 'state': 'run'},
                                {'path': 'experiments/shared/sub', 'thesis': 'T2', 'state': 'run'},
                                {'path': 'experiments/elsewhere', 'thesis': 'T3', 'state': 'run'}]),
                 dynamic('d2', 'B')],
             'correspondences': [
                 {'id': 'c1', 'domain': 'x', 'group': 'g', 'relation': 'scope', 'carried': 'carried',
                  'targets': [{'record': 'r1', 'anchor': CH + '01-ROOT.md#r-r1', 'role': 'carries', 'says': {'en': 's'}}]},
                 {'id': 'c2', 'domain': 'x', 'group': 'g', 'relation': 'scope', 'carried': 'carried',
                  'targets': [{'anchor': CH + '07-SIGNIFICANCE.md#r-r2', 'role': 'carries', 'says': {'en': 's'}}]},
                 {'id': 'c3', 'domain': 'y', 'group': 'g', 'relation': 'scope', 'carried': 'carried',
                  'targets': [{'anchor': CH + '05-COLLECTIVES.md#markets', 'role': 'carries', 'says': {'en': 's'}}]},
                 {'id': 'c4', 'domain': 'y', 'group': 'g', 'relation': None, 'carried': 'not-carried', 'targets': []}]}
    tests = [{'id': 'SOLO1', 'name': 'n', 'thesis': 'T1', 'folder': 'experiments/solo/README.md', 'outcome': 'failed'},
             {'id': 'SH1 (round 1)', 'name': 'n', 'thesis': 'T2', 'folder': 'experiments/shared/README.md', 'outcome': 'mixed'},
             {'id': 'SH1 (round 2)', 'name': 'n', 'thesis': 'T2', 'folder': 'experiments/shared/README.md', 'outcome': 'mixed'},
             {'id': 'NONE1', 'name': 'n', 'thesis': 'T3', 'folder': 'experiments/none/README.md', 'outcome': 'not-run'},
             {'id': 'LA2', 'name': 'n', 'thesis': 'T7', 'folder': 'experiments/self-rewarding-lock/README.md', 'outcome': 'mixed'}]
    coverage = {'premises': {'items': [
        {'name': 'balance', 'pattern': r'\bBalances\b', 'witnesses': ['Becoming.W.a', 'Becoming.W.missing']},
        {'name': 'finite', 'pattern': r'World\.Finite\b', 'witnesses': []},
        {'name': 'decided', 'pattern': r'\bDecidable\b', 'witnesses': [], 'kind': 'logical', 'meets': ['Becoming.W.a'],
         'unrefuted': ['Becoming.W.b']}]}}
    return {'records': records, 'atlas': atlas, 'graph': graph, 'tests': tests, 'coverage': coverage,
            'families': {'F01': 'Core', 'F07': 'Judgment'}, 'core': {'Becoming.A.x', 'Becoming.W.a', 'Becoming.W.b'}}


class AtlasIndexTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.src = stores()
        cls.conn = sqlite3.connect(':memory:')
        atlas_index.build(cls.conn, cls.src)
        cls.m = atlas_index.measure(cls.conn)

    @classmethod
    def tearDownClass(cls):
        cls.conn.close()

    def test_ids_a_test_row_names(self):
        self.assertEqual(atlas_index.base_ids('CG3 (round 1)'), ['CG3'])
        self.assertEqual(atlas_index.base_ids('TR4, TR5'), ['TR4', 'TR5'])
        self.assertEqual(atlas_index.base_ids('LA4 (Stage A)'), ['LA4'])
        said = atlas_index.mentions('LA2')
        self.assertTrue(said.search('as LA2, frozen'))
        self.assertFalse(said.search('LA2b passed'))
        self.assertFalse(said.search('XLA2'))

    def test_exits_and_transitions(self):
        m = self.m
        self.assertEqual((m['exits'], m['exits_to_dynamic'], m['exits_nowhere'], m['exits_witness']), (2, 1, 1, 1))
        self.assertEqual(m['no_exit'], [('B', 'd2')])
        self.assertEqual(m['transitions'], 1)
        self.assertEqual(m['exits_dangling'], [])

    def test_tests_by_route(self):
        rows = {r['id']: r for r in self.m['test_rows']}
        self.assertEqual(rows['SOLO1']['records'], ['r1'])  # a reference in the folder, the folder its own
        self.assertFalse(rows['SOLO1']['shared'])
        self.assertEqual(rows['SOLO1']['mentioned'], ['r1'])  # SOLO1 named, SOLO1b not counted for it
        self.assertEqual(rows['SH1 (round 1)']['dynamics'], ['d1'])  # a link inside the folder joins it
        self.assertTrue(rows['SH1 (round 1)']['shared'])
        self.assertEqual((rows['NONE1']['records'], rows['NONE1']['dynamics'], rows['NONE1']['mentioned']), ([], [], []))
        m = self.m
        self.assertEqual((m['tests_record_exact'], m['tests_record_ambiguous'], m['tests_record_none']), (1, 0, 4))
        self.assertEqual((m['tests_dynamic_exact'], m['tests_dynamic_ambiguous'], m['tests_dynamic_none']), (1, 2, 2))
        self.assertEqual(m['tests_nothing'], 2)
        self.assertEqual(m['test_folders_shared'], [('experiments/shared', 'SH1 (round 1); SH1 (round 2)')])
        self.assertEqual(m['dynamic_test_links_unmatched'], [('d1', 'experiments/elsewhere')])
        self.assertEqual(m['dynamic_test_links_ambiguous'], 1)

    def test_crosswalk_resolution(self):
        m = self.m
        self.assertEqual((m['targets'], m['targets_record'], m['targets_home_only'], m['targets_section_only']), (3, 1, 1, 1))
        self.assertEqual((m['cw_no_target'], m['cw_no_record_target']), (1, 1))
        self.assertEqual((m['cw_reach'], m['cw_reach_dynamics']), (1, 1))  # r2 is reached, and no dynamic cites it
        self.assertEqual(m['dynamics_no_correspondence'], 1)

    def test_records_not_cited(self):
        m = self.m
        self.assertEqual((m['live_theorems'], m['cited'], m['uncited'], m['uncited_crosswalk']), (3, 1, 2, 1))
        self.assertEqual(m['uncited_by_family'], [('F01', 1, 0), ('F07', 1, 1), ('F99', 1, 1)])
        self.assertEqual(m['uncited_by_chapter'], [('', 1, 1), (CH + '01-ROOT.md', 1, 0), (CH + '07-SIGNIFICANCE.md', 1, 1)])
        self.assertEqual(m['uncited_records'], [('', 'r4', 0), (CH + '07-SIGNIFICANCE.md', 'r2', 1)])
        self.assertEqual(m['records_no_home'], 1)

    def test_atlas_and_graph_and_declarations(self):
        m = self.m
        self.assertEqual(m['graph_atlas_nodes'], 0)
        self.assertEqual(m['dynamics_in_graph'], 1)
        self.assertEqual([d for _, d, _ in m['dynamics_without_record']], ['d2'])
        self.assertEqual((m['dynamic_declarations'], m['dynamic_declarations_core']), (2, 1))  # A.x as the chapters write it
        self.assertEqual(m['dynamic_declarations_unrecorded'], 1)  # B.y: no record of d1 lists it

    def test_pilots_measure_without_adding(self):
        m = self.m
        self.assertEqual([r['id'] for r in m['pilot_tests']], ['LA2'])
        premises = {p['id']: p for p in m['premises']}
        self.assertEqual(premises['k3-balance']['by_name'], (0, 0))  # 'balanced' is not the word
        self.assertEqual(premises['k3-balance']['by_pattern'], (1, 1))
        self.assertEqual(premises['k3-balance']['dynamics'], 1)
        self.assertEqual((premises['k3-balance']['witnesses'], premises['k3-balance']['witnesses_core']), (2, 1))
        self.assertEqual(premises['k3-finite']['by_name'], (1, 1))
        self.assertEqual((premises['k3-decided']['witnesses'], premises['k3-decided']['witnesses_core']), (2, 2))
        self.assertEqual(m['premise_hypotheses_several'], 1)  # one hypothesis matches balance's pattern and finite's name

    def test_page(self):
        body = atlas_index.page(self.m, self.src['atlas'], self.src['families'])
        self.assertTrue(body.startswith('# What the map does not join\n\n' + atlas_index.GENERATED))
        self.assertIn('| Exits that name a destination (a dynamic, or a state in words) | 1 of 2 |', body)
        self.assertIn('| Live theorem records the atlas\'s dynamics do not cite | 2 of 3 |', body)
        self.assertIn('F99 (not in the session map)', body)
        self.assertIn('none of them is a dynamic', body)
        self.assertTrue(body.endswith('\n') and not body.endswith('\n\n'))

    def test_the_repository_builds_and_renders(self):
        pages, errors = atlas_index.render(None, None, None)
        self.assertEqual(errors, [])
        self.assertIn(atlas_index.REPORT, pages)
        self.assertIn('## Records the atlas does not cite', pages[atlas_index.REPORT])


if __name__ == '__main__':
    unittest.main()
