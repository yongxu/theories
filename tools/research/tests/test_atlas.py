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
from tools.research import atlas, navigation, paths, reading_catalogue, registry  # noqa: E402

CONFIG = {'record_directories': ['theories/becoming/results/records']}
CHAPTER = 'theories/becoming/chapters/02-MAP.md'
LEAF = 'experiments/periphery/Leaf.lean'
FILES = {
    CHAPTER: '# The map\n\n## 9. Capture\n\nA rule read from the share it selects.\n\n<a id="r-closed-capture"></a>\n'
             '**Theorem** (any type). The lock outlives a loss it does not read.\n',
    atlas.RECEIPT: json.dumps({'status': 'passed', 'modules': [{'module': 'Becoming.ClosedCapture', 'layer': 'core', 'declarations': [
        {'kind': 'theorem', 'name': 'Becoming.ClosedCapture.turned_by_loss'}, {'kind': 'def', 'name': 'Becoming.ClosedCapture.Locked'}]}]}),
    LEAF: ('namespace Leaf\n\ntheorem slows_down : True := trivial\n\n'
           '/-- A structure whose fields are declarations; an abbreviation of it declares none. -/\n'
           'structure Dependence where\n  requires : Nat\n  need level : Nat\n\nabbrev Web := Dependence\n\n'
           'mutual\ntheorem a_one : True := trivial\ntheorem a_two : True := trivial\nend\n\n'
           'theorem «所及» : True := trivial\n\ntheorem _root_.Rooted.law : True := trivial\n\n'
           '-- theorem commented_out : True := trivial\n\nend Leaf\n'),
    'experiments/history/Old.lean': 'theorem only_in_history : True := trivial\n',
    'experiments/periphery/Draft.lean': 'theorem never_added : True := trivial\n',
    'experiments/tests/t7/FROZEN.sha256': '0 design.md\n',
    'theories/early/README.md': '# An earlier folder\n',
    'theories/becoming/results/README.md': '# The results\n',
    'theories/becoming/chapters/07-SIGNIFICANCE.md': '# Significance\n',  # the atlas's lead links chapter 7's question
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
                          'declarations': ['Leaf.slows_down'], 'records': ['loss-read-in-time']}],
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

    def write_nav_targets(self):
        """The pages the shared navigation line and the atlas's views link, so a test of every link finds them."""
        for target in re.findall(r'\]\(([^)#\s]+)', navigation.nav_line(atlas.PAGE)):
            path = (self.root / atlas.ATLAS / target).resolve()
            path.parent.mkdir(parents=True, exist_ok=True)
            if not path.exists():
                path.write_text('# A page\n\n## Check the proofs yourself\n')
        (self.root / atlas.JOINS).write_text('# What the map does not join\n')

    def write_atlas(self, *entries):
        self.write_nav_targets()
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
        for name in ('Becoming.ClosedCapture.turned_by_loss', 'ClosedCapture.Locked', 'Leaf.slows_down'):
            with self.subTest(name=name):
                self.assertEqual(self.errors(capture(declarations=[name])), [])
        for name in ('only_in_history', 'never_added', 'ClosedCapture.no_such_law'):
            with self.subTest(name=name):
                self.assertOne(self.errors(capture(declarations=[name])), f'declarations: {name} is declared neither')
        self.assertOne(self.errors(capture(exits=[exit_(law='no_such_law')])), 'exits[0].law: no_such_law')

    def test_a_name_resolves_exactly_never_by_its_last_component(self):
        """A leaf's declarations are read with their namespaces, mutual blocks, fields and root names; a name is
        resolved as written (or under Becoming. in the core), never by its last component, and prose is none."""
        for name in ('Leaf.Dependence.requires', 'Leaf.Dependence.level', 'Leaf.Dependence.mk', 'Leaf.a_two', 'Leaf.«所及»',
                     'Rooted.law', 'Leaf.Web'):
            with self.subTest(declared=name):
                self.assertEqual(self.errors(capture(declarations=[name])), [])
        for name in ('slows_down',                      # its last component alone
                     'Becoming.Leaf.slows_down',        # a prefix the source does not declare
                     'Leaf.Web.requires',               # a field read through an abbreviation, not a declaration
                     'Becoming.Web.requires',
                     'Leaf',                            # a namespace
                     'Leaf.slows_down applied to Leaf.a_one',  # prose
                     'Leaf.commented_out', 'Leaf.Rooted.law'):
            with self.subTest(refused=name):
                self.assertOne(self.errors(capture(declarations=[name])), f'declarations: {name} is declared neither')

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

    def test_an_exit_no_law_shows_says_how_far_it_is_seen(self):
        reading = exit_(to='closed-capture', law=None, strength=None, records=[], standing_without_law='reading')
        self.assertEqual(self.errors(capture(), carriers(exits=[reading])), [])
        self.assertOne(self.errors(capture(), carriers(exits=[dict(reading, standing_without_law='likely')])),
                       'exits[0].standing_without_law', 'standings_without_record')
        self.assertOne(self.errors(capture(), carriers(exits=[dict(reading, law='Becoming.ClosedCapture.turned_by_loss')])),
                       'exits[0].standing_without_law: an exit a law shows takes its strength from it')
        self.assertOne(self.errors(capture(), carriers(exits=[dict(reading, strength='sufficient')])),
                       'exits[0].strength: an exit no law shows has no strength')
        self.assertOne(self.errors(capture(), carriers(exits=[dict(reading, records=['closed-capture'])])),
                       'exits[0].records: an exit no law shows rests on no record')
        self.assertOne(self.errors(capture(), carriers(exits=[dict(reading, to_law='Becoming.ClosedCapture.turned_by_loss')])),
                       'exits[0].to_law: an exit no law shows names no law')
        self.assertOne(self.errors(capture(exits=[exit_(strength=None)])), 'exits[0].strength', 'exit_strengths')
        routes = atlas._routes({'dynamics': [capture(exits=[exit_(to='self-reproducing-selection')]), carriers(exits=[reading])]})
        self.assertEqual(routes['self-reproducing-selection'], {'closed-capture': 'reading'})
        self.assertEqual(routes['closed-capture'], {'self-reproducing-selection': 'sufficient'})

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
        self.assertNotIn('**Valence.**', family + other)  # the data keep the field; the lead says once what it means
        self.assertIn("chapter 7's question", index)
        # AG review, 9 November 2026: how far a record has been seen is no longer called its standing (08 §2); the data
        # keep the key `standing`, and widening and narrowing are more and less future, not good and evil (07)
        self.assertIn('- **How far seen.** [closed-capture](../../records/closed-capture.md) recorded-checked (theorem)', family)
        self.assertIn('| Dynamic | Records | Base | How far seen | Exits | Open |', index)
        self.assertIn('It adds nothing to how far anything has been seen', index)
        self.assertIn('more and less future, not good and evil', index)
        for body in (index, family, other):
            self.assertNotIn('**Standing.**', body)
            self.assertNotIn('no standing of its own', body)
            self.assertNotIn('| Standing |', body)
            self.assertNotIn('is better is', body)
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

    def test_the_indexes_open_and_close_with_the_shared_line_and_the_atlas_views(self):
        self.write_atlas(capture())
        pages, _ = atlas.render(RECORDS)
        for path in (atlas.PAGE, atlas.CROSSWALK, atlas.FAMILY_PAGES + '/c.md'):
            lines = pages[path].rstrip('\n').split('\n')
            with self.subTest(page=path):
                self.assertIn(navigation.nav_line(path), lines[:6])
                views = [line for line in lines[:8] if line.startswith("The atlas's views: ")]
                self.assertEqual(len(views), 1)
                self.assertIn('[what does not join](', views[0] + ('' if path != atlas.PAGE else ''))
        index = pages[atlas.PAGE].rstrip('\n').split('\n')
        self.assertEqual(index[-1], [line for line in index[:8] if line.startswith("The atlas's views: ")][0])
        self.assertNotIn('map.html', pages[atlas.PAGE].split('\n')[4])

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

    def test_the_index_carries_the_navigation_line_under_its_title(self):
        built = atlas.build({'dynamics': [], 'correspondences': [], 'correspondence_groups': [group()]}, VOCABULARY, RECORDS)
        lines = atlas.folders_page(built).split('\n')
        self.assertEqual(lines[lines.index('# The earlier theory folders') + 2], navigation.nav_line(atlas.FOLDERS))

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



class ChineseCrosswalkTests(unittest.TestCase):
    def test_the_chinese_table_names_and_counts_every_group(self):
        """CROSSWALK.zh's table: each of the live atlas's groups by its Chinese name, linking its page, with the counts
        CROSSWALK.md's table gives it (what became of its entries, then their relations)."""
        live = json.loads((ROOT / 'theories/becoming/results/data/atlas.json').read_text(encoding='utf-8'))
        page = atlas.crosswalk_zh_page(live)
        carried = [c['en'] for c in live['vocabulary']['carried']]
        relations = [r['en'] for r in live['vocabulary']['relations']]
        for g in live['correspondence_groups']:
            with self.subTest(group=g['id']):
                self.assertIn(g['id'], atlas.GROUP_ZH)  # no group falls back to its English name
                row = next(l for l in page.split('\n') if l.startswith(f'| [{atlas.GROUP_ZH[g["id"]]}]('))
                cells = [c.strip() for c in row.strip('|').split('|')][2:]
                self.assertEqual(cells, [str(g['entries'])] + [str(g['by_carried'][c]) for c in carried]
                                 + [str(g['by_relation'][r]) for r in relations])



PREMISE_VOCABULARY = {**VOCABULARY,
                      'premise_kinds': [{'en': 'hypothesis of a law'}, {'en': 'World premise'}],
                      'premise_seeds': [{'en': 'K3'}, {'en': '08 card'}, {'en': 'Lean'}]}


def premise(**changes):
    """A well-formed premise: a hypothesis of one law, shown failing where the law leaves the lock."""
    p = {'id': 'closedcapture-unread', 'name': {'en': 'Unread'},
         'statement': {'en': 'Neither the next share nor the rule read reads what lies beyond the share.'},
         'kind': 'hypothesis of a law', 'lean': ['Becoming.ClosedCapture.Locked'], 'holds_in': ['closed-capture'],
         'fails_in': ['Becoming.ClosedCapture.turned_by_loss'], 'home': CHAPTER + '#r-closed-capture', 'seeded_from': ['Lean']}
    p.update(copy.deepcopy(changes))
    return p


class PremiseTests(AtlasCase):
    """PLAN §13, step 2: premises as entries, each law's premises, the premise an exit drops, what a transition lies
    between, and the ledger and terrain pages."""

    def read(self, **changes):
        base = {'premises': [{'law': 'Becoming.ClosedCapture.turned_by_loss', 'takes': ['closedcapture-unread']}],
                'exits': [exit_(drops=['closedcapture-unread'])]}
        return capture(**{**base, **changes})

    def check(self, dynamics, premises):
        return atlas.validate({'dynamics': [copy.deepcopy(d) for d in dynamics], 'premises': [copy.deepcopy(p) for p in premises],
                               'correspondences': [], 'correspondence_groups': []}, copy.deepcopy(PREMISE_VOCABULARY), RECORDS)

    def test_a_read_dynamic_and_its_premise_are_well_formed(self):
        self.assertEqual(self.check([self.read()], [premise()]), [])

    def test_premises_stay_optional(self):
        self.assertEqual(self.errors(capture()), [])  # no premises file, no premise lists in the vocabulary: none read yet

    def test_an_exit_drops_only_a_premise_of_the_atlas(self):
        self.assertOne(self.check([self.read(exits=[exit_(drops=['nowhere'])])], [premise()]), 'exits[0].drops', 'nowhere is not a premise')

    def test_a_law_takes_only_premises_of_the_atlas(self):
        bad = self.read(premises=[{'law': 'Becoming.ClosedCapture.turned_by_loss', 'takes': ['nowhere']}])
        self.assertOne(self.check([bad], [premise()]), 'premises[0].takes', 'nowhere is not a premise')

    def test_an_exit_resolves_only_to_a_dynamic(self):
        self.assertOne(self.check([self.read(exits=[exit_(to='closedcapture-unread')])], [premise()]), 'exits[0].to', 'not another entry')

    def test_a_premise_kind_is_closed(self):
        self.assertOne(self.check([self.read()], [premise(kind='a guess')]), 'kind', 'premise_kinds')

    def test_a_premise_shown_failing_names_a_record_or_declaration(self):
        self.assertOne(self.check([self.read()], [premise(fails_in=['Nowhere.lemma'])]), 'fails_in', 'Nowhere.lemma')

    def test_a_withheld_statement_is_null(self):
        self.assertEqual(self.check([self.read()], [premise(statement=None)]), [])

    def test_a_transition_lies_between_dynamics_or_states(self):
        t = copy.deepcopy(capture()['transitions'][0])
        good = self.read(transitions=[{**t, 'between': {'from': {'en': 'read in time'}, 'to': 'closed-capture'}}])
        self.assertEqual(self.check([good], [premise()]), [])
        bad = self.read(transitions=[{**t, 'between': {'from': 'nowhere', 'to': None}}])
        self.assertOne(self.check([bad], [premise()]), 'between.from', 'nowhere is not an entry')

    def test_the_ledger_and_terrain_pages(self):
        self.write_atlas(self.read(), carriers(family='G', exits=[exit_(to='closed-capture')]))
        (self.root / atlas.VOCABULARY).write_text(json.dumps(PREMISE_VOCABULARY, ensure_ascii=False, indent=1) + '\n')
        (self.root / atlas.ENTRIES / 'premises.json').write_text(json.dumps([premise()], ensure_ascii=False, indent=1) + '\n')
        pages, errors = atlas.render(RECORDS)
        self.assertEqual(errors, [])
        ledger, terrain, family = pages[atlas.PREMISES_PAGE], pages[atlas.TERRAIN], pages[atlas.FAMILY_PAGES + '/c.md']
        own = pages[atlas.premise_path('C')]  # taken only by family C's laws: on C's page of the ledger
        self.assertIn('| C. Capture of the selection | [c.md](premises/c.md) | 1 |', ledger)
        self.assertIn('<a id="closedcapture-unread"></a>**Unread** `closedcapture-unread`', own)
        self.assertNotIn('<a id="closedcapture-unread"></a>', ledger)
        self.assertIn('[Closed capture (元吸引子)](../families/c.md#closed-capture) (exit 1)', own)  # dropped by
        self.assertIn('```mermaid', terrain)
        self.assertIn('## C. Capture of the selection', terrain)
        self.assertNotIn('## G.', terrain)  # family G is not read for its premises
        self.assertIn('Drops [Unread](../premises/c.md#closedcapture-unread).', family)
        self.assertIn('`Becoming.ClosedCapture.turned_by_loss`: [Unread](../premises/c.md#closedcapture-unread)', family)
        self.assertIn('[the premise ledger](PREMISES.md)', pages[atlas.PAGE])

    def test_an_exit_no_law_shows_drops_no_premise(self):
        reading = exit_(to='closed-capture', law=None, strength=None, records=[], standing_without_law='reading')
        self.assertEqual(self.check([self.read(), carriers(family='G', exits=[reading])], [premise()]), [])
        dropping = carriers(family='G', exits=[dict(reading, drops=['closedcapture-unread'])])
        self.assertOne(self.check([self.read(), dropping], [premise()]), 'exits[0].drops', 'drops no premise')

    def test_the_terrain_says_no_law_places_a_dashed_edge_only_where_one_is_drawn(self):
        note = 'A dashed edge from an exit no law shows'
        reading = exit_(to='self-reproducing-selection', law=None, strength=None, records=[], standing_without_law='reading')
        for exits, drawn in (([exit_(drops=['closedcapture-unread'])], False),
                             ([exit_(drops=['closedcapture-unread']), reading], True)):
            self.write_atlas(self.read(exits=exits), carriers(family='G'))
            (self.root / atlas.VOCABULARY).write_text(json.dumps(PREMISE_VOCABULARY, ensure_ascii=False, indent=1) + '\n')
            (self.root / atlas.ENTRIES / 'premises.json').write_text(json.dumps([premise()], ensure_ascii=False, indent=1) + '\n')
            pages, errors = atlas.render(RECORDS)
            self.assertEqual(errors, [])
            terrain = pages[atlas.TERRAIN]
            self.assertEqual(note in terrain, drawn)
            if drawn:
                self.assertIn('-.->|reading|', terrain)

    def test_only_an_exit_to_a_dynamic_names_the_law_placing_it(self):
        placed = carriers(family='G', exits=[exit_(to='closed-capture', to_law='Becoming.ClosedCapture.turned_by_loss')])
        self.assertEqual(self.check([self.read(), placed], [premise()]), [])
        loose = self.read(exits=[exit_(drops=['closedcapture-unread'], to_law='Becoming.ClosedCapture.turned_by_loss')])
        self.assertOne(self.check([loose], [premise()]), 'exits[0].to_law', 'only an exit to a dynamic')

    def test_routes_keep_their_strongest_weakest_step(self):
        a = {'dynamics': [{'id': 'a', 'exits': [{'to': 'b', 'strength': 'exact'}, {'to': 'c', 'strength': 'witness'}]},
                          {'id': 'b', 'exits': [{'to': 'c', 'strength': 'sufficient'}]},
                          {'id': 'c', 'exits': [{'to': None, 'strength': 'necessary'}]}]}
        self.assertEqual(atlas._routes(a), {'a': {'b': 'exact', 'c': 'sufficient'}, 'b': {'c': 'sufficient'}, 'c': {}})


class CaseAndJoinTests(AtlasCase):
    """PLAN §13, the six-family pass: which general law a law is a case of, where the Lean derives it, and how two
    dynamics join, where one's state is another's rule, reading or pool."""

    read, check = PremiseTests.read, PremiseTests.check

    def cased(self, **case):
        c = {'law': 'Leaf.slows_down', 'how': {'en': 'its rate fixed to the share read'}, **case}
        return self.read(premises=[{'law': 'Becoming.ClosedCapture.turned_by_loss', 'takes': ['closedcapture-unread'], 'case_of': [c]}])

    def joined(self, **change):
        c = {'from': {'dynamic': 'closed-capture', 'law': None, 'role': 'share of the favoured kind'},
             'to': {'dynamic': 'self-reproducing-selection', 'law': None, 'role': 'pool'},
             'map': {'en': 'the share read as the pool the next selection draws from'}, 'order_kept': 'not checked',
             'premises': ['closedcapture-unread'], 'joint_law': 'Becoming.ClosedCapture.turned_by_loss', 'exits_kept': None,
             'standing': 'proved', 'source': CHAPTER + '#r-closed-capture'}
        for k, v in change.items():
            c[k] = v
        return self.read(compose=[c])

    def test_a_law_is_a_case_of_a_law_elsewhere(self):
        self.assertEqual(self.check([self.cased()], [premise()]), [])
        self.assertOne(self.check([self.cased(law='Becoming.ClosedCapture.turned_by_loss')], [premise()]),
                       'case_of[0].law', 'a law of this dynamic')
        self.assertOne(self.check([self.cased(law='Nowhere.lemma')], [premise()]), 'case_of[0].law', 'Nowhere.lemma')
        inner = self.cased(law='ClosedCapture.turned_by_loss')  # another declaration of the same dynamic, as its entry names it
        self.assertOne(self.check([inner], [premise()]), 'case_of[0].law', 'a law of this dynamic')
        self.assertOne(self.check([self.cased(how='fixed')], [premise()]), 'case_of[0].how', 'not a text')
        empty = self.read(premises=[{'law': 'Becoming.ClosedCapture.turned_by_loss', 'takes': [], 'case_of': []}])
        self.assertOne(self.check([empty], [premise()]), 'premises[0].case_of', 'nonempty')

    def test_a_joining_is_proved_by_a_joint_law_or_stated_in_a_source(self):
        other = carriers(family='G')
        self.assertEqual(self.check([self.joined(), other], [premise()]), [])
        self.assertEqual(self.check([self.joined(standing='stated', joint_law=None), other], [premise()]), [])
        self.assertEqual(self.check([self.joined(standing='reading', joint_law=None), other], [premise()]), [])
        self.assertOne(self.check([self.joined(standing='reading'), other], [premise()]), 'compose[0].joint_law', 'a reading joining has no joint law')
        self_join = self.joined(to={'dynamic': 'closed-capture', 'law': None, 'role': 'pool'})
        self.assertOne(self.check([self_join, other], [premise()]), 'compose[0]', 'between two dynamics')
        nowhere = self.joined(to={'dynamic': 'nowhere', 'law': None, 'role': 'pool'})
        self.assertOne(self.check([nowhere, other], [premise()]), 'compose[0].to.dynamic', 'not an entry')
        self.assertOne(self.check([self.joined(joint_law=None), other], [premise()]), 'compose[0].joint_law', 'names the Lean law')
        self.assertOne(self.check([self.joined(standing='stated'), other], [premise()]), 'compose[0].joint_law', 'no joint law')
        self.assertOne(self.check([self.joined(standing='read by an AI'), other], [premise()]), 'compose[0].standing', 'proved')
        self.assertOne(self.check([self.joined(to={'dynamic': 'self-reproducing-selection', 'law': None, 'role': 'share'}), other],
                                  [premise()]), 'compose[0].to.role', 'a rule, a reading or a pool')
        self.assertOne(self.check([self.joined(order_kept='mostly'), other], [premise()]), 'compose[0].order_kept', 'none of')
        third = carriers(id='a-third-dynamic', family='G')
        far = self.joined(**{'from': {'dynamic': 'a-third-dynamic', 'law': None, 'role': 'share'}})
        self.assertOne(self.check([far, other, third], [premise()]), 'compose[0]', 'written on one of the two')
        self.assertOne(self.check([self.joined(premises=['nowhere']), other], [premise()]), 'compose[0].premises', 'nowhere')

    def test_cases_and_joinings_are_shown_on_both_ends_and_on_the_terrain(self):
        d = self.joined()
        d['premises'] = self.cased()['premises']
        self.write_atlas(d, carriers(family='G', exits=[exit_(to='closed-capture')]))
        (self.root / atlas.VOCABULARY).write_text(json.dumps(PREMISE_VOCABULARY, ensure_ascii=False, indent=1) + '\n')
        (self.root / atlas.ENTRIES / 'premises.json').write_text(json.dumps([premise()], ensure_ascii=False, indent=1) + '\n')
        pages, errors = atlas.render(RECORDS)
        self.assertEqual(errors, [])
        c, g, terrain = pages[atlas.FAMILY_PAGES + '/c.md'], pages[atlas.FAMILY_PAGES + '/g.md'], pages[atlas.TERRAIN]
        self.assertIn('; a case of `Leaf.slows_down` (a law the atlas does not list): its rate fixed to the share read', c)
        for page in (c, g):
            self.assertIn('- **Joins.**', page)
            self.assertIn('→ the pool of [Self-reproducing selection across carriers]', page)
            self.assertIn('What passes: share of the favoured kind. How: the share read as the pool', page)
            self.assertIn('Proved by `Becoming.ClosedCapture.turned_by_loss`, whose statement relates both', page)
        self.assertIn('## Laws given as cases of one law', terrain)
        self.assertIn('| `Leaf.slows_down` | — | `Becoming.ClosedCapture.turned_by_loss` ([Closed capture (元吸引子)](families/c.md#closed-capture)) | C |', terrain)
        self.assertIn('## How dynamics join', terrain)


class TerrainPictureTests(AtlasCase):
    """Round 6: the terrain at the scale of the families, drawn from the entries alone."""

    def atlas_with_an_exit_between_families(self):
        read = capture(premises=[{'law': 'Becoming.ClosedCapture.turned_by_loss', 'takes': ['closedcapture-unread']}])
        other = carriers(family='G', exits=[exit_(to='closed-capture'), exit_(to='closed-capture', law=None, strength=None, records=[],
                                                                           standing_without_law='reading')])
        return atlas.build({'dynamics': [read, other], 'premises': [premise()], 'correspondences': [], 'correspondence_groups': []},
                           PREMISE_VOCABULARY, RECORDS)

    def test_it_counts_only_recorded_exits(self):
        c = atlas.terrain_counts(self.atlas_with_an_exit_between_families())
        self.assertEqual(c['between'], {('G', 'C'): {'law': 1, 'reading': 1}})
        self.assertTrue(c['families']['C']['read'])
        self.assertFalse(c['families']['G']['read'])
        self.assertEqual(c['families']['C']['to_state'], 1)

    def test_the_picture_says_what_it_draws(self):
        svg = atlas.terrain_svg(self.atlas_with_an_exit_between_families())
        self.assertIn('<title id="ts-title">', svg)
        self.assertIn('not a route', svg)
        self.assertIn('marker-end="url(#ts-law)"', svg)
        self.assertIn('marker-end="url(#ts-reading)"', svg)
        self.assertIn('not yet read', svg)
        self.assertNotIn('is better', svg)


SLICE_VOCABULARY = {**PREMISE_VOCABULARY,
                    'situation_kinds': [{'en': 'model'}, {'en': 'run'}, {'en': 'field'}],
                    'premise_assessments': [{'en': 'met'}, {'en': 'failed'}, {'en': 'not checked'}],
                    'failure_marks': [{'en': 'nothing failed'}, {'en': 'the law'}, {'en': 'the binding'}, {'en': 'the measurement'}],
                    'exit_openness': [{'en': 'open'}, {'en': 'closed'}, {'en': 'not read'}]}
README = 'experiments/tests/t7/README.md'
TESTS_TABLE = {'tests': [{'id': 'LA2', 'name': 'A lock in a self-rewarding loop', 'outcome': 'mixed', 'folder': README,
                          'gloss': 'Every frozen verdict passed; the bridge failed.'},
                         {'id': 'LA4 (Stage B)', 'name': 'Not frozen', 'outcome': 'held', 'folder': README, 'gloss': 'Held.'}]}


def binding(**changes):
    """A well-formed binding: a run whose frozen verdicts all passed while a premise of its identification failed."""
    b = {'id': 'test-la2', 'test': 'LA2',
         'bears_on': [{'dynamic': 'closed-capture', 'records': ['closed-capture'], 'laws': ['Becoming.ClosedCapture.turned_by_loss'],
                       'how': {'en': 'whether the lock outlives a loss the loop does not read'}}],
         'binding': {'kind': 'run', 'target': {'records': ['closed-capture'], 'laws': [], 'conclusion': {'en': 'the lock outlives the loss'}},
                     'roles': [{'role': {'en': 'the pool of readers'}, 'as': {'en': 'the judge trained on the loop'}}],
                     'premises': [{'premise': 'closedcapture-unread', 'assessed': 'failed', 'how': {'en': 'the judge read past the share'}}],
                     'observed': {'en': 'scores over five seeds'}, 'result': {'en': 'every frozen verdict passed'},
                     'marks': 'the binding', 'marks_why': {'en': 'a premise of the identification failed'},
                     'alternative': {'en': 'the judge was not a pool counting by kind'}, 'source': README + '#results'}}
    b.update(copy.deepcopy(changes))
    return b


def situation(**changes):
    """A well-formed situation: a policy, its raters and a reward model, and a harm to users no rater reads."""
    s = {'id': 'a-reward-model-pipeline', 'name': {'en': 'A reward-model pipeline'}, 'kind': 'model', 'standing': 'reading',
         'summary': {'en': 'A policy selected by a reward model trained on raters.'},
         'formations': [{'id': 'policy', 'en': 'the policy'}, {'id': 'raters', 'en': 'the raters'}, {'id': 'reward-model', 'en': 'the reward model'}],
         'conditions': [{'id': 'users-harm', 'en': 'a harm to users'}],
         'couplings': [{'from': 'policy', 'to': 'raters', 'en': 'outputs shown'}, {'from': 'raters', 'to': 'reward-model', 'en': 'ratings'},
                       {'from': 'reward-model', 'to': 'policy', 'en': 'the reward'}, {'from': 'policy', 'to': 'users-harm', 'en': 'deployed outputs'}],
         'readers': [{'id': 'reward-model', 'reads': ['raters', 'policy'], 'drawn_from': {'en': 'the raters'}, 'selects': ['policy']}],
         'rule': {'en': 'the reward, read from ratings'}, 'time': {'en': 'rounds of rating and training'},
         'dynamics': [{'dynamic': 'closed-capture', 'as': {'en': 'the reward read from what the policy is rated'},
                       'roles': [{'role': {'en': 'the share'}, 'as': {'en': 'what the policy does'}}]}],
         'premises': [{'premise': 'closedcapture-unread', 'assessed': 'met', 'why': {'en': 'no rater reads the harm'}}],
         'exits': [{'dynamic': 'closed-capture', 'exit': 1, 'open': 'open', 'why': {'en': 'a reading of the harm could turn it'}}],
         'bears': [{'who': {'en': 'users'}, 'what': {'en': 'the harm no rater reads, through closed capture'}}],
         'sources': [CHAPTER + '#r-closed-capture']}
    s.update(copy.deepcopy(changes))
    return s


class SliceTests(AtlasCase):
    """PLAN §13, steps 3 and 4, a first slice: bindings of tests to the dynamics they bear on, and situations."""

    def setUp(self):
        super().setUp()
        (self.root / atlas.TESTS).parent.mkdir(parents=True, exist_ok=True)
        (self.root / atlas.TESTS).write_text(json.dumps(TESTS_TABLE) + '\n')
        (self.root / README).write_text('# T7\n\n## Results\n\nEvery frozen verdict passed.\n')

    def read(self):
        return capture(premises=[{'law': 'Becoming.ClosedCapture.turned_by_loss', 'takes': ['closedcapture-unread']}],
                       exits=[exit_(drops=['closedcapture-unread'])])

    def check(self, bindings=(), situations=(), dynamics=None):
        return atlas.validate({'dynamics': [copy.deepcopy(d) for d in (dynamics or [self.read()])], 'premises': [premise()],
                               'bindings': [copy.deepcopy(b) for b in bindings], 'situations': [copy.deepcopy(s) for s in situations],
                               'correspondences': [], 'correspondence_groups': []}, copy.deepcopy(SLICE_VOCABULARY), RECORDS)

    def test_a_binding_and_a_situation_are_well_formed(self):
        self.assertEqual(self.check([binding()], [situation()]), [])

    def test_a_binding_names_a_row_and_takes_its_id_from_it(self):
        self.assertOne(self.check([binding(test='LA9', id='test-la9')]), 'test', 'not a row of the tests table')
        self.assertOne(self.check([binding(id='la2')]), 'id', 'test-la2')

    def test_a_row_with_a_result_has_a_bridge_and_one_without_has_none(self):
        self.assertOne(self.check([binding(binding=None)]), 'binding', 'has a result (mixed)')
        held = binding(id='test-la4-stage-b', test='LA4 (Stage B)')
        self.assertOne(self.check([held]), 'binding', 'no result (held)')
        self.assertEqual(self.check([binding(id='test-la4-stage-b', test='LA4 (Stage B)', binding=None)]), [])

    def test_a_row_reported_without_a_verdict_has_a_result(self):
        table = {'tests': TESTS_TABLE['tests'] + [{'id': 'TR2A', 'name': 'Stage A', 'outcome': 'no-verdict', 'folder': README}]}
        (self.root / atlas.TESTS).write_text(json.dumps(table) + '\n')
        self.assertOne(self.check([binding(id='test-tr2a', test='TR2A', binding=None)]), 'binding', 'has a result (no-verdict)')

    def test_a_binding_bears_only_on_a_read_dynamic_and_its_premises(self):
        unread = binding()
        unread['binding']['premises'] = []
        self.assertOne(self.check([unread], dynamics=[capture()]), 'bears_on 1.dynamic', 'not read for its premises')
        b = binding()
        b['binding']['premises'][0]['premise'] = 'elsewhere'
        errors = atlas.validate({'dynamics': [self.read()], 'premises': [premise(), premise(id='elsewhere')], 'bindings': [b],
                                 'situations': [], 'correspondences': [], 'correspondence_groups': []},
                                copy.deepcopy(SLICE_VOCABULARY), RECORDS)
        self.assertOne(errors, 'binding.premises 1', 'taken by no law of a dynamic the row bears on')

    def test_a_binding_whose_bears_on_is_no_list_is_reported_not_raised(self):
        errors = self.check([binding(bears_on=None)])
        self.assertTrue(any('bears_on' in e and 'nonempty list' in e for e in errors), errors)

    def test_a_situation_reads_every_exit_of_its_dynamics(self):
        self.assertOne(self.check(situations=[situation(exits=[])]), 'exits', 'closed-capture exit 1 is not read')

    def test_a_binding_bears_through_the_dynamics_own_records(self):
        b = binding()
        b['bears_on'][0]['records'] = ['an-earlier-capture']
        self.assertOne(self.check([b]), 'bears_on 1.records', 'not a record of closed-capture')

    def test_where_an_outcome_marks_is_closed(self):
        b = binding()
        b['binding']['marks'] = 'the theory'
        self.assertOne(self.check([b]), 'binding.marks', 'failure_marks')

    def test_a_situations_graph_names_its_own_nodes(self):
        self.assertOne(self.check(situations=[situation(readers=[{'id': 'users-harm', 'reads': ['raters'], 'drawn_from': {'en': 'x'}}])]),
                       'readers 1.id', 'not a formation')
        bad = situation()
        bad['couplings'].append({'from': 'policy', 'to': 'nowhere', 'en': 'x'})
        self.assertOne(self.check(situations=[bad]), 'couplings 5', 'nowhere')

    def test_a_situation_reads_through_dynamics_read_for_their_premises(self):
        self.assertOne(self.check(situations=[situation(premises=[], exits=[])], dynamics=[capture()]), 'dynamics 1', 'not read for its premises')
        other = premise(id='elsewhere')
        errors = atlas.validate({'dynamics': [self.read()], 'premises': [premise(), other], 'bindings': [],
                                 'situations': [situation(premises=[{'premise': 'elsewhere', 'assessed': 'met', 'why': {'en': 'x'}}])],
                                 'correspondences': [], 'correspondence_groups': []}, copy.deepcopy(SLICE_VOCABULARY), RECORDS)
        self.assertOne(errors, 'premises 1', 'taken by no law')
        two = situation()
        two['exits'].append({'dynamic': 'closed-capture', 'exit': 2, 'open': 'open', 'why': {'en': 'x'}})
        self.assertOne(self.check(situations=[two]), 'exits 2.exit', 'no exit 2')

    def test_the_checker_computes_what_lies_beyond_each_reader(self):
        rows = atlas.situation_sets(situation())
        self.assertEqual(rows, [{'reader': 'reward-model', 'closure': ['policy', 'raters', 'reward-model'],
                                 'reaches': ['policy', 'raters', 'users-harm'], 'beyond': ['users-harm'],
                                 'reads_among_selected': ['policy']}])

    def test_the_pages(self):
        self.write_atlas(self.read())
        (self.root / atlas.VOCABULARY).write_text(json.dumps(SLICE_VOCABULARY, ensure_ascii=False, indent=1) + '\n')
        for kind, rows in (('premises', [premise()]), ('bindings', [binding()]), ('situations', [situation()])):
            (self.root / atlas.ENTRIES / f'{kind}.json').write_text(json.dumps(rows, ensure_ascii=False, indent=1) + '\n')
        pages, errors = atlas.render(RECORDS)
        self.assertEqual(errors, [])
        bindings, situations = pages[atlas.BINDINGS_PAGE], pages[atlas.SITUATIONS_PAGE]
        self.assertIn('## LA2: A lock in a self-rewarding loop', bindings)
        self.assertIn('[LA2](#test-la2) (mixed; the binding)', bindings)
        self.assertIn('- **Where it marks.** the binding: a premise of the identification failed', bindings)
        self.assertIn('| the reward model (`reward-model`) | the policy (`policy`), the raters (`raters`), the reward model (`reward-model`) | '
                      'the policy (`policy`), the raters (`raters`), a harm to users (`users-harm`) | a harm to users (`users-harm`) |', situations)
        self.assertIn('- **Tests bound to it.** [LA2](../BINDINGS.md#test-la2) (the binding)', pages[atlas.FAMILY_PAGES + '/c.md'])
        self.assertIn('([the bindings](BINDINGS.md))', pages[atlas.PAGE])
        self.assertIn('([the situations](SITUATIONS.md))', pages[atlas.PAGE])



class Step2bTests(unittest.TestCase):
    """Every law's list holds every premise its hypothesis binders state: C and D's by step 2b's mapping, the other six
    families' by the six-family pass's (a law of C or D listed elsewhere too is held by step 2b's)."""

    def test_every_listing_holds_its_binders(self):
        root = Path(__file__).resolve().parents[3]
        mapping = json.loads((root / atlas.STEP2B).read_text(encoding='utf-8'))
        six = json.loads((root / atlas.SIX).read_text(encoding='utf-8'))
        self.assertFalse(set(mapping) & set(six), 'a law in both mappings')
        mapping.update(six)
        dynamics = json.loads((root / atlas.ENTRIES / 'dynamics.json').read_text(encoding='utf-8'))
        seen = set()
        for d in dynamics:
            for h in d.get('premises') or []:
                self.assertIn(h['law'], mapping, f'{d["id"]}: {h["law"]} is not in the mapping')
                seen.add(h['law'])
                m = mapping[h['law']]
                bound = {p for row in m['binders'] for p in row['premises']}
                self.assertFalse(bound - set(h['takes']), f'{d["id"]}: {h["law"]} lacks {sorted(bound - set(h["takes"]))}')
                other = set(h['takes']) - bound - set(m['takes_unbound'])
                self.assertFalse(other, f'{d["id"]}: {h["law"]} lists {sorted(other)}, neither bound nor taken another way')
                lost = set(m['takes_unbound']) - set(h['takes'])
                self.assertFalse(lost, f'{d["id"]}: {h["law"]} lacks {sorted(lost)}, taken another way')
        self.assertEqual(seen, set(mapping))


if __name__ == '__main__':
    unittest.main()
