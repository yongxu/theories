"""One register, short stubs that keep their anchors, a compact dependency page and scope states."""
from pathlib import Path
import re
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from tools.research import mirror, navigation, registry, research
from tools.research.reading_catalogue import anchors_from_text


def result(ident, status='recorded-checked', kind='theorem', deps=(), statement=True):
    r = {'id': ident, 'status': status, 'kind': kind, 'family': 'F01', 'title': {'en': ident + ' title'},
         'canonical_source': 'theories/' + ident + '.md', '_record_path': 'theories/results/records/' + ident + '.json',
         'dependencies': [{'id': d, 'relation': rel, 'detail': {'en': 'uses ' + d}} for d, rel in deps],
         'next_delta': {'en': ident + ' next'}}
    if statement:
        r['statement'] = {'en': ident + ' does this.'}
    return r


def goal(ident, state):
    return {'id': ident, 'scope_type': 'project-direction', 'state': state, 'sources': ['README.md'], 'result_ids': [],
            **{f: {'zh': ident + ' ' + f, 'en': ident + ' ' + f} for f in ('title', 'scope', 'objective', 'completion', 'premises')}}


def render(records, config=None, goal_records=()):
    config = config or {}
    def read(path):
        return config if path == navigation.CONFIG else {'documents': {}}
    with patch.object(navigation, 'read', side_effect=read), patch.object(navigation, 'goals', return_value=list(goal_records)):
        return navigation.render_views(records)


class RegisterAndStubTests(unittest.TestCase):
    def test_results_is_the_single_register(self):
        records = [result('a'), result('b', 'open', 'target')]
        views = render(records)
        register = views['RESULTS.md']
        self.assertIn('| `a` | [a title](theories/results/records/a.md) | theorem | recorded-checked |', register)
        self.assertIn('## Where to look first', register)
        for stub in ('RESEARCH.md', 'theories/becoming/README.md', 'theories/becoming/chapters/CLAIMS.md'):
            with self.subTest(stub=stub):
                self.assertNotIn('a title', views[stub])
                self.assertIn('RESULTS.md', views[stub])
                found = anchors_from_text(views[stub])
                self.assertIn('registered-results', found)
                self.assertIn('已登记成果--registered-results', found)
                self.assertIn('discovery-and-evidence--检索与证据', found)

    def test_register_index_is_a_stub_keeping_its_anchors(self):
        page = registry.render_index([result('a')])
        self.assertNotIn('a title', page)
        self.assertIn('../../../RESULTS.md', page)
        found = anchors_from_text(page)
        for anchor in ('canonical-result-register', '成果登记表-canonical-result-register', 'where-to-look-first',
                       '先查哪一项-where-to-look-first', 'check-and-search', '检查与检索-check-and-search'):
            self.assertIn(anchor, found)

    def test_roadmap_points_to_goals_and_keeps_goal_anchors(self):
        views = render([result('a')], goal_records=[goal('ethics', 'unmarked')])
        roadmap = views['theories/becoming/results/ROADMAP.md']
        self.assertIn('../../../GOALS.md#ethics', roadmap)
        self.assertTrue({'ethics', 'ethics-title', 'ethics-title--ethics-title'} <= anchors_from_text(roadmap))
        self.assertNotIn('ethics objective', roadmap)


class DependencyTests(unittest.TestCase):
    def test_adjacency_has_an_anchor_per_edge_and_reference_links(self):
        records = [result('a'), result('b', deps=[('a', 'formal-reuse')]), result('c', deps=[('a', 'interpretive'), ('b', 'formal-reuse')])]
        page = render(records)['DEPENDENCIES.md']
        found = anchors_from_text(page)
        self.assertTrue({'b--a', 'c--a', 'c--b'} <= found)
        self.assertIn('- [c][] ← <a id="c--a"></a>[a][] *(interpretive)* · <a id="c--b"></a>[b][]', page)
        self.assertIn('[a]: theories/results/records/a.md', page)
        self.assertNotIn('uses a', page)  # the detail stays on the record page

    def test_record_page_lists_reverse_edges(self):
        records, _ = registry.load_records()
        producer = next(r for r in records if r['_used_by'])
        page = registry.render_record(producer)
        self.assertIn('**Used by:**', page)
        consumer, _ = producer['_used_by'][0]
        self.assertIn(consumer, page.split('**Used by:**')[1].split('\n')[0])

    def test_changed_record_rerenders_its_producers(self):
        records = [result('a'), result('b', deps=[('a', 'formal-reuse')])]
        for r in records:
            r['references'] = []
        with patch.object(registry, 'standard_boundaries_path', return_value=None):
            selected = registry.affected_ids(records, {'theories/results/records/b.json'})
        self.assertEqual(selected, {'a', 'b'})


class GoalAndOpenQuestionTests(unittest.TestCase):
    def test_goals_are_ordered_by_state(self):
        goal_records = [goal('done', 'completed'), goal('later', 'unmarked'), goal('now', 'active')]
        page = render([result('a')], goal_records=goal_records)['GOALS.md']
        self.assertLess(page.index('## Active scopes'), page.index('### now title'))
        self.assertLess(page.index('### now title'), page.index('## Scopes not yet marked by Ren'))
        self.assertLess(page.index('### later title'), page.index('## Completed scopes'))
        self.assertLess(page.index('## Completed scopes'), page.index('### done title'))
        self.assertIn('**State:** `unmarked`', page)

    def test_goal_state_is_validated(self):
        for state in (None, 'open'):
            g = goal('x', state)
            with patch.object(navigation, 'goals', return_value=[g]), patch.object(navigation, 'read', return_value={}):
                errors = navigation.validate_goals([])
            self.assertTrue(any('x: state required' in e for e in errors))

    def test_open_questions_group_targets_programme_and_pending_decisions(self):
        config = {'open_questions': {'programme': [{'path': 'README.md', 'label': 'Further proofs'}],
                                     'pending_ren': [{'path': 'GOALS.md', 'label': 'Ren decides'}]}}
        page = render([result('a'), result('t', 'open', 'target')], config, [goal('later', 'unmarked')])['OPEN-QUESTIONS.md']
        self.assertLess(page.index('## Open targets'), page.index('### t title'))
        self.assertNotIn('### a title', page)
        self.assertIn('**Next:** t next', page)
        self.assertLess(page.index('## Open programme'), page.index('[Further proofs](README.md)'))
        self.assertLess(page.index('## Beyond the readings'), page.index('[Ren decides](GOALS.md)'))
        self.assertIn('decisions-pending-ren', anchors_from_text(page))
        self.assertIn('[later title](GOALS.md#later)', page)
        self.assertIn('registered-results', anchors_from_text(page))

    def test_open_question_links_must_name_files(self):
        with self.assertRaisesRegex(ValueError, 'missing file'):
            navigation.open_question_links({'open_questions': {'programme': [{'path': 'no/such.md', 'label': 'x'}]}})


class NavigationLineTests(unittest.TestCase):
    def test_the_line_is_grouped_as_the_site_and_links_the_proofs(self):
        page = render([result('a')])['RESULTS.md']
        self.assertIn(navigation.nav_line('RESULTS.md'), page)
        line = navigation.nav_line('RESULTS.md')
        for group in ('**Read**', '**Check**', '**See**'):
            self.assertIn(' · ' + group + ' · [', line)
        self.assertLess(line.index('**Read**'), line.index('**Check**'))
        self.assertLess(line.index('**Check**'), line.index('**See**'))
        self.assertIn('[Proofs](MAP.md#check-the-proofs-yourself)', line)
        self.assertTrue(line.startswith('[Home](README.md)'))  # what the site's strip of the line goes by

    def test_links_are_relative_to_the_page_and_a_front_keeps_its_edition(self):
        self.assertIn('[Home](../README.md)', navigation.nav_line('theories/README.md'))
        self.assertIn('[中文](GLOSSARY.zh.md)', navigation.nav_line('GLOSSARY.md', 'GLOSSARY.zh.md'))

    def test_a_front_without_the_line_is_an_error(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            (root / 'MAP.md').write_text('# Where\n\n' + navigation.nav_line('MAP.md') + '\n')
            (root / 'GLOSSARY.md').write_text('# Glossary\n\n[中文](GLOSSARY.zh.md)\n')
            errors = navigation.nav_front_errors(root)
        self.assertEqual(len(errors), 1)
        self.assertIn('GLOSSARY.md: its navigation line is missing', errors[0])

    def test_the_repository_fronts_carry_the_line(self):
        self.assertEqual(navigation.nav_front_errors(), [])


def chapters():
    return ({'b': ('theories/becoming/chapters/01-ROOT.md', 5), 'a': ('theories/becoming/chapters/01-ROOT.md', 9), 'c': ('theories/becoming/chapters/02-MAP.md', 1)},
            {'theories/becoming/chapters/01-ROOT.md': 'The root', 'theories/becoming/chapters/02-MAP.md': 'The map'})


class RegisterHeadTests(unittest.TestCase):
    def page(self, records):
        with patch.object(navigation, 'chapter_homes', chapters):
            return render(records)['RESULTS.md']

    def test_the_register_is_grouped_by_chapter_in_the_chapters_order(self):
        page = self.page([result('a'), result('b'), result('c'), result('z', 'superseded')])
        self.assertIn('[Chapter 1](#chapter-01) (2) · [Chapter 2](#chapter-02) (1) · [Stated in no chapter](#not-in-a-chapter) (1)', page)
        self.assertLess(page.index('### Chapter 1. The root'), page.index('`b`'))
        self.assertLess(page.index('| `b` |'), page.index('| `a` |'))  # the chapter's order, not the alphabet
        self.assertLess(page.index('| `a` |'), page.index('### Chapter 2. The map'))
        self.assertLess(page.index('### Chapter 2. The map'), page.index('### Stated in no chapter'))
        self.assertLess(page.index('### Stated in no chapter'), page.index('| `z` |'))

    def test_start_here_opens_and_the_maintenance_sentences_follow_the_table(self):
        ident = navigation.START_HERE[0]
        page = self.page([result(ident), result('a')])
        self.assertLess(page.index('## Start here'), page.index('## Registered results'))
        self.assertRegex(page, re.escape(ident + ' does this.') + r' (\*Its standing:\* [^`]+ )?`recorded-checked`, an existing Lean receipt is recorded\.')
        self.assertIn('not a ranking', page)
        self.assertLess(page.index('Results [the one page](theories/becoming/ONE-PAGE.md) leans on'), page.index('- **'))  # the first screen links one of the six
        self.assertNotIn('the first screen', page.split('## Registered results')[0])
        for premise in ('the continuation condition fixes scope', 'C gives order'):
            self.assertIn(premise, page.split('## Registered results')[0])
        for sentence in ('one editable JSON record', 'Hash drift requires'):
            self.assertGreater(page.index(sentence), page.index('## How this register is kept'))
        self.assertLess(page.index('neither certifies a stronger claim'), page.index('## Start here'))
        self.assertLess(page.index('not yet migrated keep their existing sources and are not counted here'), page.index('## Start here'))  # a qualifier on the count
        self.assertNotIn('Unmigrated results', page)

    def test_each_start_result_opens_with_the_one_pages_plain_line(self):
        records = [result(i) for i in navigation.START_HERE]
        page = self.page(records).split('## Registered results')[0]
        for ident in navigation.START_HERE:
            with self.subTest(ident=ident):
                plain = navigation.START_PLAIN[ident][1].rstrip('.')
                self.assertLess(page.index(plain), page.index(ident + ' does this.'))

    def test_closed_capture_is_said_to_be_without_noise(self):
        ident = 'closed-capture'
        page = self.page([result(ident)]).split('## Registered results')[0]
        item = next(line for line in page.split('\n') if line.startswith('- **'))
        self.assertIn('*Its standing:* Proved for any type, in the model only, without noise; drawn one member at a time, the critical mass\'s '
                      'locks are left by drift alone, with no new reader and no change in what is read, at a weight whose bound shrinks across '
                      'the distance from the mass ([drawn one at a time](theories/becoming/chapters/02-MAP.md#r-drawn-shaping-drawn-one-at-a-time)); '
                      'for capture through the rule this is a reading', item)
        self.assertIn('[which locks noise leaves](theories/becoming/chapters/02-MAP.md#which-locks-noise-leaves)', item)
        self.assertLess(item.index(ident + ' does this.'), item.index('without noise'))
        self.assertLess(item.index('without noise'), item.index('`recorded-checked`'))

    def test_each_start_result_carries_its_standing_in_the_one_pages_words(self):
        page = self.page([result(i) for i in navigation.START_HERE]).split('## Registered results')[0]
        items = {i: next(line for line in page.split('\n') if line.startswith('- **') and i + ' does this.' in line) for i in navigation.START_HERE}
        self.assertIn('*Its standing:* Proved, near-definitional; its force is the premise that a selector selects through just those.', items['selection-through-couplings'])
        self.assertIn('*Its standing:* Proved; a known theorem restated.', items['what-an-optimum-does-beyond-what-couples-in'])
        self.assertIn('*Its standing:* Proved on models; restates the commons.', items['own-count-misses-joint-excess'])
        self.assertIn('That this explains how things go on: argued. That every becoming fits it: open.', items['continuation-relative-to-a-class'])
        self.assertNotIn('*Its standing:*', items['one-root-to-its-edge'])  # its record carries its standing
        self.assertIn("its record's statement and its standing in its homes' words", page)

    def test_the_one_unglossed_term_is_glossed_as_the_glossary_does(self):
        r = result(navigation.START_HERE[0])
        r['statement'] = {'en': 'Continuation is 缘 met with a class, and 缘 again.'}
        page = self.page([r])
        self.assertIn('Continuation is 缘 ([condition](GLOSSARY.md#the-root), *yuán*) met with a class, and 缘 again.', page)

    def test_a_chapter_title_on_the_register_is_in_english(self):
        homes, titles = navigation.chapter_homes()
        self.assertEqual([t for t in titles.values() if re.search('[一-鿿]', t)], [])
        self.assertIn('The classical texts', titles['theories/becoming/chapters/06-CLASSICAL-TEXTS.md'])
        with tempfile.TemporaryDirectory() as folder:  # the name goes by the file, whatever the chapter's own heading says
            chapter = Path(folder) / navigation.CHAPTERS / '06-CLASSICAL-TEXTS.md'
            chapter.parent.mkdir(parents=True)
            chapter.write_text('# 古文\n\n<a id="r-x"></a>\n')
            self.assertIn('The classical texts', navigation.chapter_homes(Path(folder))[1]['theories/becoming/chapters/06-CLASSICAL-TEXTS.md'])

    def test_the_start_list_must_name_completed_results(self):
        records = [result(i) for i in navigation.START_HERE]
        self.assertEqual(navigation.start_here_errors(records), [])
        records[0]['status'] = 'open'
        records.pop()
        errors = navigation.start_here_errors(records)
        self.assertEqual(len(errors), 2)
        self.assertRegex(' '.join(errors), 'not a completed scoped result')
        self.assertRegex(' '.join(errors), 'not a registered result')

    def test_a_plain_line_or_standing_its_source_dropped_is_an_error(self):
        records = [result(i) for i in navigation.START_HERE]
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            (root / navigation.MAP_CHAPTER).parent.mkdir(parents=True)
            sources = {}
            for path, sentence in list(navigation.START_PLAIN.values()) + [pair for pairs, _, _ in navigation.START_STANDING.values() for pair in pairs]:
                sources.setdefault(path, []).append(sentence)
            for path, sentences in sources.items():
                (root / path).write_text('\n\n'.join(sentences))
            self.assertEqual(navigation.start_here_errors(records, root), [])
            dropped = navigation.START_STANDING['closed-capture'][0][1][1]
            (root / navigation.MAP_CHAPTER).write_text('\n\n'.join(s for s in sources[navigation.MAP_CHAPTER] if s != dropped))
            errors = navigation.start_here_errors(records, root)
        self.assertEqual(len(errors), 1)
        self.assertIn('no longer says, word for word: ' + dropped, errors[0])

    def test_the_repository_start_list_holds(self):
        self.assertEqual(navigation.start_here_errors(registry.load_records()[0]), [])


class OpenQuestionsHeadTests(unittest.TestCase):
    def setUp(self):
        self.folder = tempfile.TemporaryDirectory()
        self.addCleanup(self.folder.cleanup)

    def views(self):
        relative = '_process/architecture/history/x/'
        reading = navigation.ROOT / relative
        doc = {'documents': {'OPEN-QUESTIONS.md': {'reading': relative + 'OQ.reading.md', 'raw': relative + 'OQ.md'}}}
        def read(path):
            return {} if path == navigation.CONFIG else doc
        anchors = {'2-nothing-here-is-falsifiable': relative + 'OQ.reading.md', '3-rens-own-open-questions': relative + 'OQ.reading.md'}
        with patch.object(navigation, 'read', side_effect=read), patch.object(navigation, 'goals', return_value=[]), \
                patch.object(navigation, 'preserved_targets', return_value=anchors):
            return navigation.render_views([result('a'), result('t', 'open', 'target')])

    def test_the_page_opens_with_the_crux_and_the_warrant_in_their_homes_words(self):
        page = self.views()['OPEN-QUESTIONS.md']
        self.assertLess(page.index('## The crux and the warrant of C'), page.index('## Open targets'))
        for key in navigation.OPEN_LEAD:
            self.assertIn(navigation.OPEN_LEAD[key][1][1:].rstrip('.'), page)
        self.assertIn('the continuation condition for scope and C for order', page)
        self.assertIn('Neither is asserted.', page)

    def test_the_repository_homes_still_say_the_lead(self):
        self.assertEqual(navigation.open_lead_errors(), [])

    def test_a_lead_sentence_its_home_dropped_is_an_error(self):
        root = Path(self.folder.name)
        self.assertEqual(len(navigation.open_lead_errors(root)), len(navigation.OPEN_LEAD))  # no homes at all
        (root / navigation.CHAPTERS).mkdir(parents=True)
        sentences = list(navigation.OPEN_LEAD.values())
        (path, dropped), kept = sentences[-1], sentences[:-1]
        for home in {p for p, _ in sentences}:
            (root / home).write_text('\n\n'.join(s for p, s in kept if p == home))
        errors = navigation.open_lead_errors(root)
        self.assertEqual(len(errors), 1)
        self.assertIn(f'{path} no longer says, word for word: {dropped}', errors[0])

    def test_each_quotation_of_the_warrant_links_where_it_stands(self):
        page = self.views()['OPEN-QUESTIONS.md']
        for key, anchor in (('c-question', 'open-items-ranked'), ('c-definition', 'philosophical-warrant'), ('c-open', 'open-items-ranked')):
            with self.subTest(key=key):
                after = page.split(navigation.OPEN_LEAD[key][1], 1)[1]
                self.assertRegex(after[:120], r'^"\.? ?\(\[[^\]]+\]\([^)]*#' + anchor + r'\)')

    def test_decision_numbers_and_maintenance_leave_the_readers_page(self):
        page = self.views()['OPEN-QUESTIONS.md']
        self.assertNotIn('D45', page)
        self.assertNotIn('## Discovery and evidence', page)
        self.assertNotIn('## Preserved history', page)
        self.assertNotIn('<details>', page)
        self.assertNotIn('make research-check', page)

    def test_old_anchors_stay_with_nothing_to_read_and_the_owner_is_not_named(self):
        views = self.views()
        page = views['OPEN-QUESTIONS.md']
        self.assertIn('<a id="2-nothing-here-is-falsifiable"></a>', page)
        self.assertIn('discovery-and-evidence--检索与证据', anchors_from_text(page))
        self.assertNotIn('Historical section', page)
        self.assertNotIn('rens-own', page)
        self.assertNotRegex(re.sub(r'\]\([^)]*\)|<a id="[^"]*"></a>', '', page), r'\bRen\b')
        self.assertIn(navigation.OPEN_KEPT.split('/')[-1], page)

    def test_the_kept_page_holds_what_left(self):
        kept = self.views()[navigation.OPEN_KEPT]
        self.assertIn('## Discovery and evidence', kept)
        self.assertIn('## Preserved history', kept)
        self.assertIn('Historical section: 2-nothing-here-is-falsifiable', kept)
        self.assertIn('architecture/history/x/OQ.reading.md#2-nothing-here-is-falsifiable', kept)
        self.assertIn('<!-- Generated by', kept)

    def test_other_pages_keep_their_lower_sections(self):
        self.assertIn('## Discovery and evidence', self.views()['RESULTS.md'])


class OversizedLinkTests(unittest.TestCase):
    def repo(self, folder):
        root = Path(folder)
        (root / 'docs').mkdir()
        (root / 'BIG.md').write_text('# big\n\n' + 'x' * 2000)
        (root / 'small.md').write_text('# small\n')
        (root / 'docs/old.md').write_text('[kept](../BIG.md#a)\n')
        (root / 'docs/fine.md').write_text('[fine](../small.md)\n')
        for args in (['init', '-q'], ['add', '-A'], ['-c', 'user.name=x', '-c', 'user.email=x@x', 'commit', '-qm', 'base']):
            subprocess.run(['git', *args], cwd=root, check=True)
        return root

    def test_only_a_new_link_is_reported(self):
        with tempfile.TemporaryDirectory() as folder:
            root = self.repo(folder)
            self.assertEqual(research.oversized_links(root, since='HEAD', limit=1000)['new'], [])
            (root / 'docs/new.md').write_text('# n\n\n[new](../BIG.md#b)\n')
            (root / 'docs/old.md').write_text('[kept](../BIG.md#a)\n[added](../BIG.md#c)\n')
            found = research.oversized_links(root, since='HEAD', limit=1000)
        self.assertEqual(sorted((f['file'], f['line'], f['target']) for f in found['new']),
                         [('docs/new.md', 3, '../BIG.md#b'), ('docs/old.md', 2, '../BIG.md#c')])
        self.assertEqual(found['held_since'], 1)
        self.assertEqual(found['oversized'], ['BIG.md'])

    def test_a_link_in_code_is_not_a_link(self):
        with tempfile.TemporaryDirectory() as folder:
            root = self.repo(folder)
            (root / 'docs/code.md').write_text('`[new](../BIG.md#b)`\n')
            self.assertEqual(research.oversized_links(root, since='HEAD', limit=1000)['new'], [])

    def test_the_repository_has_no_new_oversized_link(self):
        self.assertEqual(research.oversized_links()['new'], [])


class RepointMirroredTests(unittest.TestCase):
    def test_a_dry_run_lists_and_apply_writes(self):
        study = '_process/s/STUDY.md'
        folders = {'mirrors': {'folders': {study: '_process/s/mirror/STUDY'}}}
        text = '# Study\n\n## 1. One\n\nbody\n'
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            (root / '_process/s').mkdir(parents=True)
            (root / 'chapters').mkdir()
            (root / study).write_text(text)
            (root / 'chapters/c.md').write_text('[a](../_process/s/STUDY.md#1-one) [w](../_process/s/STUDY.md) [o](d.md)\n')
            (root / 'chapters/d.md').write_text('x\n')
            for args in (['init', '-q'], ['add', '-A']):
                subprocess.run(['git', *args], cwd=root, check=True)
            with patch.object(navigation, 'read', return_value=folders), patch.object(mirror, 'ROOT', root):
                mirrors = mirror.Mirror(folders, root)
                with patch.object(mirror, 'Mirror', return_value=mirrors):
                    dry = research.repoint_mirrored(['chapters/c.md'], root=root)
                    self.assertIn('STUDY.md#1-one', (root / 'chapters/c.md').read_text())
                    done = research.repoint_mirrored(['chapters/c.md'], apply=True, root=root)
            body = (root / 'chapters/c.md').read_text()
        self.assertEqual((dry['links'], dry['applied'], done['applied']), (2, False, True))
        self.assertEqual(body, '[a](../_process/s/mirror/STUDY/001.md#1-one) [w](../_process/s/mirror/STUDY/README.md) [o](d.md)\n')


class FeaturedTests(unittest.TestCase):
    def test_laws_without_overview_show_statement_and_status(self):
        config = {'readme_featured_results': ['law'], 'readme_conditional_results': ['cond', 'more'],
                  'readme_featured_note': 'Proposal pending Ren.'}
        root = render([result('law'), result('cond'), result('more')], config)['README.md']
        self.assertIn('*Proposal pending Ren.*', root)
        self.assertLess(root.index('### Laws of the theory without axiom (sections 1–6)'), root.index('#### law title'))
        self.assertIn('law does this.', root)
        self.assertIn('**Status:** `recorded-checked`', root)
        self.assertLess(root.index('### Under the continuation condition'), root.index('#### cond title'))
        self.assertIn('[more title](theories/results/records/more.md) (`recorded-checked`)', root)
        self.assertIn('leading-results', anchors_from_text(root))
        self.assertNotIn('Part I', root)

    def test_selection_needs_an_overview_or_a_statement(self):
        with self.assertRaisesRegex(ValueError, 'overview or a statement'):
            navigation.featured_results([result('law', statement=False)], {'readme_featured_results': ['law']})


if __name__ == '__main__':
    unittest.main()
