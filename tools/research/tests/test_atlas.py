"""The atlas (atlas.py) against what it promises, on a throwaway repository: a few records, a core receipt, a tracked
periphery leaf and a history copy, a chapter with anchors, a test folder and a vocabulary. Each check of PLAN §3.5 as
the atlas states it passes a well-formed entry and fails a broken one with an error naming the entry and field; an
entry's standing is its records' status and kind, listed as the records say; the page's links resolve; and a render
is a function of its inputs."""
import contextlib
import copy
import io
import json
import os
from pathlib import Path
import posixpath
import re
import subprocess
import sys
import tempfile
import unittest
from unittest import mock
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parents[3]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from tools.research import atlas, paths, reading_catalogue, registry  # noqa: E402

CONFIG = {'record_directories': ['theories/becoming/results/records']}
CHAPTER = 'theories/becoming/chapters/02-MAP.md'
LEAF = 'experiments/periphery/Leaf.lean'
FILES = {
    CHAPTER: '# The map\n\n## 9. Capture\n\nA rule read from the share it selects.\n\n<a id="r-closed-capture"></a>\n'
             '**Theorem** (any type). The lock outlives a loss it does not read.\n',
    atlas.RECEIPT: json.dumps({'status': 'passed', 'modules': [{'module': 'Becoming.ClosedCapture', 'layer': 'core', 'declarations': [
        {'kind': 'theorem', 'name': 'Becoming.ClosedCapture.turned_by_loss'}, {'kind': 'def', 'name': 'Becoming.ClosedCapture.Locked'}]}]}),
    LEAF: 'namespace Leaf\n\ntheorem slows_down : True := trivial\n\nend Leaf\n',
    'experiments/history/Old.lean': 'theorem only_in_history : True := trivial\n',
    'experiments/periphery/Draft.lean': 'theorem never_added : True := trivial\n',
    'experiments/tests/t7/FROZEN.sha256': '0 design.md\n',
    'theories/early/README.md': '# An earlier folder\n',
    'theories/becoming/results/README.md': '# The results\n',
    atlas.ATLAS + '/map.html': '<!doctype html>\n',
}
TRACKED = (LEAF, 'experiments/history/Old.lean')
RECORDS = [
    {'id': 'closed-capture', 'status': 'recorded-checked', 'kind': 'theorem',
     'hypotheses': [{'en': 'No axiom.', 'zh': '不加公理。'}, {'en': 'Modelling choices: two kinds, counted.'}]},
    {'id': 'loss-read-in-time', 'status': 'reviewed-scoped', 'kind': 'assessment', 'hypotheses': [{'en': 'Readers drawn from the selected.'}]},
    {'id': 'an-earlier-capture', 'status': 'superseded', 'superseded_by': 'closed-capture', 'kind': 'theorem', 'hypotheses': [{'en': 'x'}]},
]
VOCABULARY = {
    'families': [{'id': 'C', 'en': 'Capture of the selection'}, {'id': 'G', 'en': 'Closure and stagnation'}],
    'bases': [{'en': 'root', 'zh': '根'}, {'en': 'any type'}, {'en': 'World'}],
    'transition_kinds': [{'en': 'window or deadline'}, {'en': 'exact threshold'}],
    'exit_strengths': [{'en': 'sufficient'}, {'en': 'necessary'}, {'en': 'exact'}, {'en': 'witness'}],
    'standings_without_record': [{'en': 'argued'}, {'en': 'conjectured'}, {'en': 'reading', 'zh': '读法'}, {'en': 'open', 'zh': '未决'}],
    'test_states': [{'en': 'designed'}, {'en': 'frozen'}, {'en': 'run'}],
    'domains': [{'en': 'earlier-folders'}, {'en': 'greek-roman'}],
    'carried': [{'en': 'carried'}, {'en': 'carried-in-part'}, {'en': 'changed'}, {'en': 'history-only'}, {'en': 'not-carried'}, {'en': 'fresh-reading'}],
    'relations': [{'en': 'agreement', 'zh': '相合'}, {'en': 'scope', 'zh': '定域'}, {'en': 'divergence', 'zh': '相分'}, {'en': 'contrary-reading', 'zh': '反读'}],
    'agreement_of': [{'en': 'law'}, {'en': 'thesis-or-method'}, {'en': 'reading'}],
    'target_roles': [{'en': 'carries'}, {'en': 'neighbour'}, {'en': 'limit'}],
    'group_kinds': [{'en': 'theory'}, {'en': 'domain'}],
    'source_bases': [{'en': 'read-in-repo'}, {'en': 'ai-knowledge'}],
}


def capture(**changes):
    """A well-formed dynamic with two records, a core and a periphery declaration, an exit, a transition, a test and
    an open item; `changes` replace its fields."""
    e = {'id': 'closed-capture', 'name': {'en': 'Closed capture', 'zh': '元吸引子'}, 'family': 'C',
         'mechanism': {'en': 'A rule read from the share it selects, nothing in the loop reading beyond the share.'},
         'records': ['closed-capture', 'loss-read-in-time'], 'declarations': ['ClosedCapture.turned_by_loss'], 'base': 'any type',
         'hypotheses': [{'record': 'closed-capture', 'index': 2}],
         'forbids': {'en': 'Leaving the lock by a loss nothing in the loop reads.'},
         'exits': [{'to': {'en': 'the course turned for good'}, 'law': 'Becoming.ClosedCapture.turned_by_loss',
                    'edge': {'en': 'where the reading too is formed from the share'}, 'strength': 'sufficient',
                    'records': ['closed-capture'], 'source': CHAPTER + '#r-closed-capture'}],
         'transitions': [{'kind': 'window or deadline', 'condition': {'en': 'read before the late reading favours the shapers'},
                          'declarations': ['slows_down'], 'records': ['loss-read-in-time']}],
         'tests': [{'path': 'experiments/tests/t7', 'thesis': 'T7', 'state': 'frozen'}],
         'open': [{'en': 'Whether reading beyond the share is necessary.', 'source': CHAPTER + '#9-capture'}],
         'valence': 'none asserted', 'beyond': {'en': 'What lies beyond the share bears the loss.'},
         'sources': [CHAPTER + '#r-closed-capture'], 'standing_without_record': None}
    e.update(copy.deepcopy(changes))
    return e


def carriers(**changes):
    """A well-formed dynamic with no record: standing open, its source cited."""
    e = capture(id='self-reproducing-selection', name={'en': 'Self-reproducing selection across carriers'}, records=[],
                declarations=[], hypotheses=[], exits=[], transitions=[], tests=[], open=[], forbids=None, beyond=None,
                sources=[CHAPTER + '#9-capture'], standing_without_record='open')
    e.update(copy.deepcopy(changes))
    return e


def exit_(**changes):
    x = copy.deepcopy(capture()['exits'][0])
    x.update(changes)
    return x


class AtlasCase(unittest.TestCase):
    """Each test has its own repository, and the atlas, the path roles and git pointed at it; nothing is read from the
    real repository's content or written under it."""

    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = root = Path(temporary.name).resolve()
        for name, body in FILES.items():
            (root / name).parent.mkdir(parents=True, exist_ok=True)
            (root / name).write_text(body)
        for r in RECORDS:
            (root / atlas.RECORDS / f'{r["id"]}.md').parent.mkdir(parents=True, exist_ok=True)
            (root / atlas.RECORDS / f'{r["id"]}.md').write_text(f'# {r["id"]}\n')
        (root / 'gitconfig').write_text('')
        env = {k: v for k, v in os.environ.items() if not k.startswith('GIT_')}
        env.update(GIT_CONFIG_GLOBAL=str(root / 'gitconfig'), GIT_CONFIG_NOSYSTEM='1')
        self.patch(mock.patch.dict(os.environ, env, clear=True))
        subprocess.run(['git', 'init', '-q'], cwd=root, check=True)
        subprocess.run(['git', 'add', '--', *TRACKED], cwd=root, check=True)
        self.patch(mock.patch.object(atlas, 'ROOT', root))
        self.patch(mock.patch.object(paths, 'role', lambda p: paths.Classifier(settings=CONFIG, root=root).role(p)))

    def patch(self, patcher):
        patcher.start()
        self.addCleanup(patcher.stop)

    def errors(self, *entries, vocabulary=VOCABULARY, records=RECORDS):
        return atlas.validate({'dynamics': [copy.deepcopy(e) for e in entries], 'correspondences': [],
                               'correspondence_groups': []}, copy.deepcopy(vocabulary), records)

    def assertOne(self, errors, *words):
        """Exactly one error, containing each of `words`."""
        self.assertEqual(len(errors), 1, errors)
        for w in words:
            self.assertIn(w, errors[0])

    def write_atlas(self, *entries):
        (self.root / atlas.ENTRIES).mkdir(parents=True, exist_ok=True)
        (self.root / atlas.VOCABULARY).write_text(json.dumps(VOCABULARY, ensure_ascii=False, indent=1) + '\n')
        (self.root / atlas.ENTRIES / 'dynamics.json').write_text(json.dumps(list(entries), ensure_ascii=False, indent=1) + '\n')
        for kind in ('correspondences', 'correspondence_groups'):
            (self.root / atlas.ENTRIES / f'{kind}.json').write_text('[]\n')


class ValidationTests(AtlasCase):
    def test_well_formed_entries_pass(self):
        self.assertEqual(self.errors(capture(), carriers()), [])

    def test_ids_are_unique_and_well_formed(self):
        self.assertOne(self.errors(capture(id='Closed_Capture')), 'dynamics: Closed_Capture: id:', '[a-z][a-z0-9-]+')
        self.assertOne(self.errors(capture(), capture()), 'dynamics: closed-capture: id: listed 2 times')

    def test_closed_fields_take_only_the_vocabulary(self):
        cases = [(capture(family='Z'), 'family', "'Z' is not in the vocabulary's families"),
                 (capture(base='counts'), 'base', 'bases'),
                 (capture(transitions=[dict(capture()['transitions'][0], kind='hysteresis')]), 'transitions[0].kind', 'transition_kinds'),
                 (capture(exits=[exit_(strength='likely')]), 'exits[0].strength', 'exit_strengths'),
                 (capture(tests=[{'path': 'experiments/tests/t7', 'thesis': 'T7', 'state': 'planned'}]), 'tests[0].state', 'test_states'),
                 (carriers(standing_without_record='proved'), 'standing_without_record', 'standings_without_record'),
                 (capture(valence='good'), 'valence', 'none asserted')]
        for entry, field, words in cases:
            with self.subTest(field=field):
                self.assertOne(self.errors(entry), f': {field}: ', words)

    def test_a_field_missing_or_unknown_is_named(self):
        entry = capture(labels=['x'])
        del entry['beyond']
        errors = self.errors(entry)
        self.assertEqual(len(errors), 2, errors)
        self.assertTrue(any('beyond: missing' in e for e in errors))
        self.assertTrue(any('labels: not a field of a dynamic' in e for e in errors))

    def test_the_vocabulary_is_checked_first(self):
        vocabulary = dict(VOCABULARY, bases=[])
        self.assertOne(self.errors(capture(), vocabulary=vocabulary), 'vocabulary: bases: missing or empty')

    def test_every_record_resolves_and_none_is_superseded(self):
        self.assertOne(self.errors(capture(records=['closed-capture', 'no-such-record'])), 'records: no record no-such-record')
        self.assertOne(self.errors(capture(records=['closed-capture', 'an-earlier-capture'])),
                       'records: record an-earlier-capture is superseded by closed-capture')
        self.assertOne(self.errors(capture(exits=[exit_(records=['no-such-record'])])), 'exits[0].records: no record no-such-record')

    def test_every_declaration_resolves_in_the_core_or_a_live_tracked_leaf(self):
        for name in ('Becoming.ClosedCapture.turned_by_loss', 'ClosedCapture.Locked', 'slows_down', 'Leaf.slows_down'):
            with self.subTest(name=name):
                self.assertEqual(self.errors(capture(declarations=[name])), [])
        for name in ('only_in_history', 'never_added', 'ClosedCapture.no_such_law'):
            with self.subTest(name=name):
                self.assertOne(self.errors(capture(declarations=[name])), f'declarations: {name} is declared neither')
        self.assertOne(self.errors(capture(exits=[exit_(law='no_such_law')])), 'exits[0].law: no_such_law')

    def test_hypotheses_name_an_own_record_and_an_index_it_has(self):
        self.assertEqual(self.errors(capture(hypotheses=[{'record': 'closed-capture', 'index': 1},
                                                         {'record': 'loss-read-in-time', 'index': 1}])), [])
        self.assertOne(self.errors(capture(hypotheses=[{'record': 'closed-capture', 'index': 3}])),
                       'hypotheses[0].index: closed-capture lists hypotheses 1 to 2, not 3')
        self.assertOne(self.errors(capture(hypotheses=[{'record': 'closed-capture', 'index': 0}])), 'hypotheses[0].index')
        self.assertOne(self.errors(capture(records=['closed-capture'], transitions=[],
                                           hypotheses=[{'record': 'loss-read-in-time', 'index': 1}])),
                       "hypotheses[0].record: 'loss-read-in-time' is not among the entry's records")

    def test_every_source_resolves_to_a_file_and_its_anchor(self):
        self.assertEqual(self.errors(capture(sources=[CHAPTER + '#r-closed-capture', CHAPTER + '#9-capture'])), [])
        for ref, words in ((CHAPTER + '#no-such', 'has no anchor no-such'), ('theories/none.md#a', 'no file theories/none.md'),
                           (CHAPTER, 'is not path#anchor')):
            with self.subTest(ref=ref):
                self.assertOne(self.errors(capture(sources=[ref])), 'sources[0]: ', words)
        self.assertOne(self.errors(capture(exits=[exit_(source=CHAPTER + '#no-such')])), 'exits[0].source: ', 'no-such')
        self.assertOne(self.errors(capture(open=[{'en': 'x', 'source': CHAPTER + '#no-such'}])), 'open[0].source: ')

    def test_an_entry_without_a_record_says_its_standing_and_cites_a_source(self):
        self.assertOne(self.errors(carriers(standing_without_record=None)), 'standing_without_record: an entry with no record says which')
        self.assertOne(self.errors(carriers(sources=[])), 'sources: an entry with no record cites its source')
        self.assertOne(self.errors(capture(standing_without_record='argued')),
                       'standing_without_record: an entry with records takes its standing from them')

    def test_exits_name_an_edge_an_exact_one_its_law_and_tests_exist(self):
        self.assertEqual(self.errors(capture(exits=[exit_(strength='exact')])), [])
        self.assertOne(self.errors(capture(exits=[exit_(edge=None)])), 'exits[0].edge: every exit names its edge')
        self.assertOne(self.errors(capture(exits=[exit_(strength='exact', law=None)])), 'exits[0].law: an exact exit names its law')
        self.assertOne(self.errors(capture(exits=[exit_(strength='witness', law=None)])), 'exits[0].law: a witness exit names its law')
        self.assertOne(self.errors(capture(tests=[{'path': 'experiments/tests/t9', 'thesis': 'T9', 'state': 'designed'}])),
                       'tests[0].path: no experiments/tests/t9')

    def test_an_exit_may_lead_to_another_entry(self):
        self.assertEqual(self.errors(capture(), carriers(exits=[exit_(to='closed-capture')])), [])
        self.assertOne(self.errors(carriers(exits=[exit_(to='closed-capture')])), 'exits[0].to: closed-capture is not another entry')


class BuildTests(AtlasCase):
    def test_standing_is_each_records_status_and_kind_never_merged(self):
        built = atlas.build({'dynamics': [capture(), carriers()], 'correspondences': [], 'correspondence_groups': []}, VOCABULARY, RECORDS)
        d, e = built['dynamics']
        self.assertEqual(d['standing'], [{'record': 'closed-capture', 'status': 'recorded-checked', 'kind': 'theorem'},
                                         {'record': 'loss-read-in-time', 'status': 'reviewed-scoped', 'kind': 'assessment'}])
        self.assertEqual(d['exits'][0]['standing'], [{'record': 'closed-capture', 'status': 'recorded-checked', 'kind': 'theorem'}])
        self.assertEqual((e['standing'], e['standing_without_record']), ([], 'open'))
        self.assertEqual(built['counts'], {'C': 2, 'G': 0})

    def test_standing_follows_the_record(self):
        records = copy.deepcopy(RECORDS)
        records[0]['status'] = 'reviewed-scoped'
        self.write_atlas(capture())
        pages, errors = atlas.render(records)
        self.assertEqual(errors, [])
        self.assertIn('| reviewed-scoped (theorem); reviewed-scoped (assessment) |', pages[atlas.PAGE])

    def test_hypotheses_are_the_records_text_by_index(self):
        built = atlas.build({'dynamics': [capture(hypotheses=[{'record': 'closed-capture', 'index': 1}])], 'correspondences': [], 'correspondence_groups': []}, VOCABULARY, RECORDS)
        self.assertEqual(built['dynamics'][0]['hypotheses'],
                         [{'record': 'closed-capture', 'index': 1, 'text': {'en': 'No axiom.', 'zh': '不加公理。'}}])


class RenderTests(AtlasCase):
    def test_an_error_renders_no_page(self):
        self.write_atlas(capture(family='Z'))
        pages, errors = atlas.render(RECORDS)
        self.assertEqual(pages, {})
        self.assertOne(errors, 'atlas: dynamics: closed-capture: family:')

    def test_the_pages_link_entries_and_records_and_every_link_resolves(self):
        self.write_atlas(capture(), carriers(family='G', exits=[exit_(to='closed-capture')]))
        pages, errors = atlas.render(RECORDS)
        self.assertEqual(errors, [])
        index, family, other = pages[atlas.PAGE], pages[atlas.FAMILY_PAGES + '/c.md'], pages[atlas.FAMILY_PAGES + '/g.md']
        for body in (index, family, other):
            self.assertTrue(body.startswith(atlas.GENERATED + '\n'))
        self.assertIn('| <a id="closed-capture"></a><a id="closed-capture-元吸引子"></a>[Closed capture (元吸引子)](families/c.md#closed-capture) | '
                      '[closed-capture](../records/closed-capture.md), [loss-read-in-time](../records/loss-read-in-time.md) | any type | '
                      'recorded-checked (theorem); reviewed-scoped (assessment) | 1 | 1 |', index)
        self.assertIn('| [Closed capture (元吸引子)](#closed-capture) | [closed-capture](../../records/closed-capture.md), '
                      '[loss-read-in-time](../../records/loss-read-in-time.md) | any type |', family)
        self.assertIn('| [C. Capture of the selection](families/c.md) | 1 |', index)
        self.assertIn('| [G. Closure and stagnation](families/g.md) | 1 |', index)
        self.assertIn('hypothesis 2: Modelling choices: two kinds, counted.', family)
        self.assertIn('To [Closed capture (元吸引子)](c.md#closed-capture): sufficient', other)  # an exit to another family's page
        self.assertNotIn('- **Mechanism.**', index)  # the sections are on the families' pages
        self.assertIn('Families: **C**, [G](g.md).', family)
        checked = 0
        for name in (atlas.PAGE, atlas.FAMILY_PAGES + '/c.md', atlas.FAMILY_PAGES + '/g.md'):
            for target in re.findall(r'\]\((<[^>]+>|[^\s)]+)\)', pages[name]):
                path, _, anchor = target.strip('<>').partition('#')
                with self.subTest(page=name, target=target):
                    resolved = posixpath.normpath(posixpath.join(posixpath.dirname(name), unquote(path))) if path else name
                    if resolved in pages:
                        own = reading_catalogue.anchors_from_text(pages[resolved])
                    else:
                        self.assertTrue((self.root / resolved).exists())
                        own = reading_catalogue.anchors(self.root / resolved) if resolved.endswith('.md') else set()
                    if anchor:
                        self.assertIn(unquote(anchor), own)
                    checked += 1
        self.assertGreater(checked, 30)

    def test_the_index_keeps_every_anchor_the_single_page_had(self):
        self.write_atlas(capture(), carriers(family='G'), carriers(id='twin', name={'en': 'Closed capture (元吸引子)'}))
        pages, _ = atlas.render(RECORDS)
        own = reading_catalogue.anchors_from_text(pages[atlas.PAGE])
        slug = reading_catalogue.slug
        single = {'closed-capture', 'self-reproducing-selection', 'twin', 'family-c', 'family-g', 'the-atlas-of-dynamics',
                  slug('C. Capture of the selection'), slug('G. Closure and stagnation'), slug('Closed capture (元吸引子)'),
                  slug('Closed capture (元吸引子)') + '-1', slug('Self-reproducing selection across carriers')}
        self.assertEqual(single - own, set())  # the single page's ids and headings, a repeated heading numbered as GitHub does
        self.assertEqual(pages[atlas.PAGE].count('<a id="closed-capture-元吸引子"></a>'), 1)

    def test_a_page_the_atlas_no_longer_writes_is_an_error_until_it_is_removed(self):
        self.write_atlas(capture())
        left = self.root / atlas.FAMILY_PAGES / 'z.md'
        left.parent.mkdir(parents=True, exist_ok=True)
        left.write_text('# A family since removed\n')
        pages, errors = atlas.render(RECORDS)
        self.assertEqual((pages, errors), ({}, [f'atlas: {atlas.FAMILY_PAGES}/z.md: a page the atlas no longer writes; remove it by name']))
        left.unlink()
        self.assertEqual(atlas.render(RECORDS)[1], [])

    def test_the_indexes_open_and_close_with_the_results_views(self):
        self.write_atlas(capture())
        pages, _ = atlas.render(RECORDS)
        for path in (atlas.PAGE, atlas.CROSSWALK):
            lines = pages[path].rstrip('\n').split('\n')
            with self.subTest(page=path):
                self.assertIn('[the connection map](map.html)', lines[-1])
                self.assertIn(lines[-1], lines[:6])

    def test_a_page_larger_than_github_shows_is_an_error_and_no_page_is_written(self):
        self.write_atlas(capture())
        self.assertEqual(atlas.render(RECORDS)[1], [])
        with mock.patch.object(atlas, 'PAGE_LIMIT', 2_000):
            pages, errors = atlas.render(RECORDS)
        self.assertEqual(pages, {})
        self.assertTrue(errors)
        self.assertTrue(all('more than the 2,000 this render allows' in e for e in errors), errors)
        self.assertTrue(any(e.startswith(f'atlas: {atlas.FAMILY_PAGES}/c.md: ') for e in errors), errors)

    def test_the_data_holds_the_resolved_entries(self):
        self.write_atlas(capture())
        pages, _ = atlas.render(RECORDS)
        data = json.loads(pages[atlas.DATA])
        self.assertEqual([d['id'] for d in data['dynamics']], ['closed-capture'])
        self.assertEqual(data['dynamics'][0]['hypotheses'][0]['text'], {'en': 'Modelling choices: two kinds, counted.'})
        self.assertEqual(data['dynamics'][0]['standing'][1]['status'], 'reviewed-scoped')

    def test_render_is_a_function_of_its_inputs(self):
        self.write_atlas(capture(), carriers())
        first = atlas.render(RECORDS)
        self.assertEqual(atlas.render(list(reversed(copy.deepcopy(RECORDS)))), first)
        self.assertEqual(atlas.render(RECORDS), first)
        self.write_atlas(carriers(), capture())
        self.assertNotEqual(atlas.render(RECORDS)[0][atlas.DATA], first[0][atlas.DATA])  # the curated order is kept

    def test_inputs_are_the_curated_files(self):
        self.write_atlas()
        self.assertEqual(atlas.inputs(), [self.root / atlas.ENTRIES / f'{k}.json' for k in ('correspondence_groups', 'correspondences', 'dynamics')]
                         + [self.root / atlas.VOCABULARY])


RECORD_PAGE = atlas.RECORDS + '/closed-capture.md'


def group(**changes):
    g = {'id': 'cxg-early', 'domain': 'earlier-folders', 'title': {'en': 'An earlier folder'}, 'kind': 'theory',
         'summary': {'en': 'What it held.'}, 'read': ['a.md'], 'skimmed': [], 'searched': [], 'not_mapped': [], 'coverage': None,
         'reads': atlas.READS, 'source': RECORD_PAGE}
    g.update(changes)
    return g


def reading(**changes):
    e = {'id': 'cx-early-claim', 'name': {'en': 'A claim'}, 'domain': 'earlier-folders', 'group': 'cxg-early',
         'source': {'work': RECORD_PAGE, 'locator': 'its head', 'basis': 'read-in-repo'}, 'sense': {'en': 'In its own terms.'},
         'quote': None, 'carried': 'carried', 'relation': 'agreement', 'agreement_of': 'law', 'reading': {'en': 'Read so.'},
         'targets': [{'record': 'closed-capture', 'role': 'carries', 'says': {'en': 'It says this.'}}], 'account_adds': None, 'source_adds': None,
         'absence': None, 'same_as': None, 'labels': ['AI reading'], 'reads': atlas.READS}
    e.update(changes)
    return e


class CorrespondenceTests(AtlasCase):
    def problems(self, *entries, groups=None):
        return atlas.validate({'dynamics': [], 'correspondences': [copy.deepcopy(e) for e in entries],
                               'correspondence_groups': [group()] if groups is None else groups},
                              copy.deepcopy(VOCABULARY), RECORDS)

    def test_a_carried_reading_passes(self):
        self.assertEqual(self.problems(reading()), [])

    def test_an_id_is_unique_across_the_atlas_and_a_group_exists(self):
        self.assertOne(self.problems(reading(group='cxg-none')), 'group:', 'cxg-none')
        self.assertTrue(any('unique across the atlas' in e for e in self.problems(reading(), reading())))

    def test_the_outcome_decides_what_an_entry_must_show(self):
        self.assertOne(self.problems(reading(relation=None, agreement_of=None)), 'relation:', 'needs a relation')
        self.assertTrue(any('needs what it is read against' in e for e in self.problems(reading(targets=[]))))
        self.assertOne(self.problems(reading(carried='carried-in-part')), 'source_adds:')
        self.assertOne(self.problems(reading(carried='not-carried', relation=None, agreement_of=None, targets=[])), 'absence:', 'searched')
        self.assertEqual(self.problems(reading(carried='not-carried', relation=None, agreement_of=None, targets=[], absence={'searched': ['grep x'], 'read': []})), [])
        self.assertTrue(any('no relation and no targets' in e
                            for e in self.problems(reading(carried='not-carried', absence={'searched': ['grep x'], 'read': []}))))
        self.assertOne(self.problems(reading(absence={'searched': ['grep x']})), 'absence:', 'only for')

    def test_a_label_and_three_reads_are_required(self):
        self.assertOne(self.problems(reading(labels=[])), 'labels:', 'AI reading')
        self.assertOne(self.problems(reading(reads=['map'])), 'reads:')

    def test_a_target_cites_the_live_account(self):
        self.assertTrue(any('no record no-such' in e for e in self.problems(reading(targets=[{'record': 'no-such', 'role': 'carries', 'says': {'en': 'x'}}]))))
        self.assertTrue(any('not in the live account' in e for e in self.problems(
            reading(agreement_of='reading', targets=[{'anchor': 'experiments/history/Old.lean', 'role': 'carries', 'says': {'en': 'x'}}]))))

    def test_agreement_says_what_it_is_with_and_a_law_must_carry_it(self):
        self.assertOne(self.problems(reading(agreement_of=None)), 'agreement_of:', 'every agreement says')
        self.assertOne(self.problems(reading(relation='scope')), 'agreement_of:', 'only for agreement')
        self.assertEqual(self.problems(reading(relation='scope', agreement_of=None)), [])
        neighbour = [{'record': 'closed-capture', 'role': 'neighbour', 'says': {'en': 'x'}}]
        self.assertTrue(any('whose role is carries' in e for e in self.problems(reading(agreement_of='reading', targets=neighbour))))
        self.assertTrue(any('checked theorem' in e for e in self.problems(reading(targets=neighbour))))
        section = [{'anchor': RECORD_PAGE, 'role': 'carries', 'says': {'en': 'x'}}]
        self.assertTrue(any('checked theorem' in e for e in self.problems(reading(targets=section))))
        self.assertEqual(self.problems(reading(agreement_of='thesis-or-method', targets=section)), [])

    def test_a_target_has_a_role_and_nothing_is_carried_in_history(self):
        self.assertTrue(any('.role' in e for e in self.problems(reading(targets=[{'record': 'closed-capture', 'says': {'en': 'x'}}]))))
        gone = {'searched': ['grep x'], 'read': []}
        self.assertTrue(any('nothing is carried' in e for e in self.problems(reading(carried='history-only', relation='scope', agreement_of=None, absence=gone))))
        near = [{'record': 'closed-capture', 'role': 'neighbour', 'says': {'en': 'x'}}]
        self.assertEqual(self.problems(reading(carried='history-only', relation='scope', agreement_of=None, absence=gone, targets=near)), [])

    def test_same_as_names_other_entries(self):
        self.assertTrue(any('same_as' in e for e in self.problems(reading(same_as=['cx-none']))))
        self.assertEqual(self.problems(reading(same_as=['cx-other']), reading(id='cx-other', same_as=['cx-early-claim'])), [])

    def test_a_quote_is_verbatim_and_only_from_a_stored_text(self):
        self.assertOne(self.problems(reading(quote='words not there')), 'quote:', 'verbatim')
        self.assertOne(self.problems(reading(source={'work': 'A book', 'locator': 'ch. 1', 'basis': 'ai-knowledge'}, quote='words')),
                       'quote:', 'paraphrase')
        self.assertEqual(self.problems(reading(source={'work': 'A book', 'locator': 'ch. 1', 'basis': 'ai-knowledge'})), [])

    def test_a_domain_says_what_is_present_and_absent(self):
        bare = group(id='cxg-greek', domain='greek-roman', kind='domain')
        self.assertOne(self.problems(groups=[bare]), 'coverage:')
        self.assertEqual(self.problems(groups=[group(id='cxg-greek', domain='greek-roman', kind='domain',
                                                     coverage={'present': [], 'absent': [{'en': 'Nothing here.', 'searched': ['x']}]})]), [])

    def test_the_page_puts_the_source_first_and_counts_divergence_beside_agreement(self):
        (self.root / atlas.ENTRIES).mkdir(parents=True, exist_ok=True)
        (self.root / atlas.VOCABULARY).write_text(json.dumps(VOCABULARY, ensure_ascii=False) + '\n')
        (self.root / atlas.ENTRIES / 'dynamics.json').write_text('[]\n')
        (self.root / atlas.ENTRIES / 'correspondence_groups.json').write_text(json.dumps([group()]))
        (self.root / atlas.ENTRIES / 'correspondences.json').write_text(json.dumps(
            [reading(), reading(id='cx-early-other', relation='divergence', agreement_of=None),
             reading(id='cx-early-gone', carried='not-carried', relation=None, agreement_of=None, targets=[], absence={'searched': ['grep x'], 'read': []})]))
        pages, errors = atlas.render(RECORDS)
        self.assertEqual(errors, [])
        index, page = pages[atlas.CROSSWALK], pages[atlas.CROSSWALK_PAGES + '/early.md']
        for body in (index, page):
            self.assertTrue(body.startswith(atlas.GENERATED + '\n'))
            self.assertIn('A shared word is not a correspondence', body)  # a reader may come to a folder's page first
        self.assertLess(page.index('Its own sense'), page.index('Reading [AI reading]'))
        self.assertIn('| <a id="cxg-early"></a><a id="an-earlier-folder"></a><a id="cx-early-claim"></a><a id="cx-early-other"></a>'
                      '<a id="cx-early-gone"></a>[An earlier folder](crosswalk/early.md) | 3 | 2 | 0 | 0 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 0 |', index)
        self.assertNotIn('Its own sense', index)
        self.assertIn('Searched: grep x', page)
        self.assertIn('[The crosswalk](../CROSSWALK.md)', page)
        self.assertIn('[06](../../../chapters/06-CLASSICAL-TEXTS.md#three-relations)', page)
        self.assertEqual(reading_catalogue.anchors_from_text(page) >= {'cx-early-other', 'cx-early-gone'}, True)
        kept = reading_catalogue.anchors_from_text(index)
        self.assertEqual({'cxg-early', reading_catalogue.slug('An earlier folder'), 'cx-early-claim', 'cx-early-other', 'cx-early-gone'} - kept, set())
        self.assertIn('[its README](../../../../early/README.md)', page)  # an earlier folder's page names the folder
        self.assertIn('## Summary and what was read', page)
        data = json.loads(pages[atlas.DATA])
        self.assertEqual(data['correspondence_groups'][0]['by_carried']['not-carried'], 1)
        self.assertEqual(data['correspondences'][0]['targets'][0]['standing']['status'], 'recorded-checked')
        folders = pages[atlas.FOLDERS]
        self.assertIn('The one folders beside', folders)  # the count is the groups'
        self.assertTrue(folders.startswith(atlas.GENERATED + '\n'))
        self.assertIn('| [An earlier folder](early/README.md) | theory | 3 | 2 | 0 | 0 | 0 | 1 | 0 | '
                      '[what became of it](becoming/results/atlas/crosswalk/early.md) |', folders)

    def test_a_mention_of_another_entry_links_it_on_its_page(self):
        (self.root / atlas.ENTRIES).mkdir(parents=True, exist_ok=True)
        (self.root / atlas.VOCABULARY).write_text(json.dumps(VOCABULARY, ensure_ascii=False) + '\n')
        (self.root / atlas.ENTRIES / 'dynamics.json').write_text('[]\n')
        greek = group(id='cxg-greek', domain='greek-roman', title={'en': 'Greek thought'}, kind='domain',
                      coverage={'present': [], 'absent': [{'en': 'Nothing here.', 'searched': ['x']}]})
        (self.root / atlas.ENTRIES / 'correspondence_groups.json').write_text(json.dumps([group(not_mapped=[{'en': 'Read beside cx-greek-one.'}]), greek]))
        (self.root / atlas.ENTRIES / 'correspondences.json').write_text(json.dumps(
            [reading(reading={'en': 'Beside cx-greek-one and cx-early-other, not cx-nowhere.'}),
             reading(id='cx-early-other', relation='divergence', agreement_of=None),
             reading(id='cx-greek-one', group='cxg-greek', domain='greek-roman')]))
        pages, errors = atlas.render(RECORDS)
        self.assertEqual(errors, [])
        page = pages[atlas.CROSSWALK_PAGES + '/early.md']
        self.assertIn('Beside [cx-greek-one](greek.md#cx-greek-one) and [cx-early-other](#cx-early-other), not cx-nowhere.', page)
        self.assertIn('<a id="cx-early-claim"></a>', page)  # its own anchor is left as it is
        self.assertIn('- Read beside [cx-greek-one](greek.md#cx-greek-one).', page)  # in the group's own lists too
        self.assertIn('lands on its group\'s row here', pages[atlas.CROSSWALK])


    def test_the_index_lists_only_the_earlier_folders(self):
        domain = group(id='cxg-greek', domain='greek-roman', title={'en': 'Greek thought'}, kind='domain',
                       coverage={'present': [], 'absent': []})
        built = atlas.build({'dynamics': [], 'correspondences': [], 'correspondence_groups': [group(), domain]}, VOCABULARY, RECORDS)
        page = atlas.folders_page(built)
        self.assertIn('(early/README.md)', page)
        self.assertNotIn('Greek thought', page)

    def test_an_earlier_folder_group_names_its_folder(self):
        self.assertTrue(any('cxg-<its folder>' in e for e in self.problems(reading(group='cxg-gone'), groups=[group(id='cxg-gone')])))


class CheckTests(AtlasCase):
    CHECKS = {'first_critic': {'sampled': 59, 'held': 32, 'partly': 12, 'failed': 15, 'aimed': True},
              'second_critic': {'sampled': 10, 'per_stratum': 5, 'entries': 40, 'verdicts': {'holds': 8, 'label': 1, 'fails': 1},
                                'estimate_percent': {'holds': 80.0, 'label': 12.5, 'fails': 7.5}}}

    def test_the_page_says_how_far_to_trust_it_before_any_count(self):
        self.write_atlas(capture())
        (self.root / atlas.CHECKS).write_text(json.dumps(self.CHECKS))
        pages, errors = atlas.render(RECORDS)
        self.assertEqual(errors, [])
        page = pages[atlas.CROSSWALK]
        self.assertLess(page.index('How far to trust it'), page.index('entries in 0 groups'))
        self.assertIn('7.5% with a wrong reading over all 40', page)
        self.assertIn('gives no rate', page)
        self.assertEqual(json.loads(pages[atlas.DATA])['crosswalk_checks']['second_critic']['sampled'], 10)
        self.assertIn(self.root / atlas.CHECKS, atlas.inputs())

    def test_verdicts_that_do_not_count_the_sample_render_nothing(self):
        self.write_atlas(capture())
        bad = copy.deepcopy(self.CHECKS)
        bad['second_critic']['verdicts']['holds'] = 9
        (self.root / atlas.CHECKS).write_text(json.dumps(bad))
        pages, errors = atlas.render(RECORDS)
        self.assertEqual(pages, {})
        self.assertTrue(any('do not count the sample' in e for e in errors))


class MainTests(AtlasCase):
    def main(self, *argv):
        out = io.StringIO()
        with mock.patch.object(registry, 'load_records', lambda: (copy.deepcopy(RECORDS), [])), contextlib.redirect_stdout(out):
            code = atlas.main(list(argv))
        return code, json.loads(out.getvalue())

    def test_check_fails_on_a_page_that_differs_and_passes_on_a_fresh_one(self):
        self.write_atlas(capture())
        code, result = self.main('--check')
        self.assertEqual((code, result['errors'], result['differs']), (1, [], [atlas.PAGE, atlas.CROSSWALK, atlas.FOLDERS, atlas.DATA,
                                                                       atlas.FAMILY_PAGES + '/c.md', atlas.FAMILY_PAGES + '/g.md',
                                                                       atlas.CROSSWALK_ZH]))
        pages, _ = atlas.render(RECORDS)
        for path, body in pages.items():
            (self.root / path).parent.mkdir(parents=True, exist_ok=True)
            (self.root / path).write_text(body)
        code, result = self.main('--check', '--json')
        self.assertEqual((code, result['differs'], result['dynamics']), (0, [], 1))
        self.assertEqual(result['atlas']['dynamics'][0]['id'], 'closed-capture')
        (self.root / atlas.PAGE).write_text(pages[atlas.PAGE] + 'edited\n')
        self.assertEqual(self.main('--check')[1]['differs'], [atlas.PAGE])

    def test_an_error_fails(self):
        self.write_atlas(capture(records=['no-such-record']))
        code, result = self.main()
        self.assertEqual(code, 1)
        self.assertTrue(result['errors'])


class PageSizeTests(unittest.TestCase):
    """The atlas's Markdown pages as they stand in this checkout, each within what GitHub shows."""

    def test_every_page_the_atlas_writes_is_within_what_github_shows(self):
        files = json.loads((ROOT / '_process/architecture/generated-manifest.json').read_text())['files']
        written = [p for p in files if p.endswith('.md') and (p.startswith(atlas.ATLAS + '/') or p == atlas.FOLDERS) and (ROOT / p).is_file()]
        self.assertIn(atlas.CROSSWALK, written)
        for p in written:
            with self.subTest(page=p):
                self.assertLessEqual((ROOT / p).stat().st_size, atlas.PAGE_LIMIT)


if __name__ == '__main__':
    unittest.main()
