"""One register, short stubs that keep their anchors, a compact dependency page and scope states."""
from pathlib import Path
import re
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from tools.research import mirror, navigation, registry, research
from tools.research.reading_catalogue import anchors_from_text


def agents_aim():
    """The aim as AGENTS.md states it, read from the file (DW, 13 November 2026). The pages are held to its words by
    reference: when the sentence is said again, the pages change with it and no test puts an earlier wording back."""
    text = (Path(__file__).resolve().parents[3] / 'AGENTS.md').read_text(encoding='utf-8')
    return re.search(r'we want to design (an alignment in which [^.]*)\.', text).group(1)


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

    def test_research_stub_gives_the_aim_once_in_agents_words(self):
        # pass 9b (10 November 2026): AGENTS.md's clause word for word, "a joint selection" said once; since AG-F's fix round
        # the same day, who selects together in AGENTS.md's words too, as the fronts now say it
        stub = render([result('a')])['RESEARCH.md']
        # DW (13 November 2026): the aim by reference to AGENTS.md, not as a literal
        self.assertIn('from it we want to design ' + agents_aim() + ';', stub)
        self.assertNotIn('people, institutions and trained systems', stub)
        self.assertEqual(stub.count(agents_aim()), 1)

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
            for page, zh in navigation.NAV_FRONTS.items():  # every other front carries its line
                if page not in ('MAP.md', 'GLOSSARY.md'):
                    (root / page).parent.mkdir(parents=True, exist_ok=True)
                    (root / page).write_text('# A front\n\n' + navigation.nav_line(page, zh) + '\n')
            errors = navigation.nav_front_errors(root)
        self.assertEqual(len(errors), 1)
        self.assertIn('GLOSSARY.md: its navigation line is missing', errors[0])

    def test_the_fronts_readers_meet_first_and_the_chapters_carry_the_line(self):
        fronts = set(navigation.NAV_FRONTS)
        for page in ('ONE-PAGE.md', 'THE-THEORY-OF-BECOMING.md', 'USES.md', 'USES-EXAMPLES.md', 'review/README.md',
                     *(f'chapters/{c}.md' for c in ('01-ROOT', '02-MAP', '03-KNOWING', '04-LIFE', '05-COLLECTIVES', '07-SIGNIFICANCE', '08-METHOD'))):
            self.assertIn('theories/becoming/' + page, fronts)

    def test_the_chapters_index_carries_the_line_under_its_title(self):
        from tools.research import indexes
        lines = indexes.chapters_index().split('\n')
        self.assertEqual(lines[4], navigation.nav_line('theories/becoming/chapters/README.md'))

    def test_a_line_below_the_top_is_not_the_fronts_line(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            for page, zh in navigation.NAV_FRONTS.items():
                (root / page).parent.mkdir(parents=True, exist_ok=True)
                (root / page).write_text('# A front\n\n' + navigation.nav_line(page, zh) + '\n')
            (root / 'MAP.md').write_text('# Where\n' + '\nA paragraph.\n' * 20 + navigation.nav_line('MAP.md') + '\n')
            errors = navigation.nav_front_errors(root)
        self.assertEqual([e.split(':')[0] for e in errors], ['MAP.md'])  # the site's strip would not find it there

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
        self.assertRegex(page, re.escape(ident + ' does this.') + r' (\*How far it has been seen:\* [^`]+ )?`recorded-checked`, an existing Lean receipt is recorded\.')
        self.assertIn('not a ranking', page)
        self.assertLess(page.index('Results [the one page](theories/becoming/ONE-PAGE.md) leans on'), page.index('- **'))  # the first screen links one of the six
        self.assertNotIn('the first screen', page.split('## Registered results')[0])
        # fifth pass: 07's Bases, the hypotheses a ranking result's theorem takes, not "two readings"; sixth pass: no "C for order";
        # seventh pass: 07 §4's own sentence, "takes" said once
        for premise in ('the ethics emerges from continuation', 'each ranking result names the hypotheses its theorem takes: [the continuation condition, self-concern or `Comparison` (C)]',
                        'and any further premise it uses.'):
            self.assertIn(premise, page.split('## Registered results')[0])
        self.assertNotIn('for order', page.split('## Registered results')[0])
        self.assertNotIn('two readings', page.split('## Registered results')[0])
        self.assertNotIn('as its theorem takes them', page.split('## Registered results')[0])
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
        self.assertIn('*How far it has been seen:* Proved for any type, in the model only, without noise; drawn one member at a time, the critical mass\'s '
                      'locks are left by drift alone, with no new reader and no change in what is read, at a weight whose bound shrinks across '
                      'the distance from the mass ([drawn one at a time](theories/becoming/chapters/02-MAP.md#r-drawn-shaping-drawn-one-at-a-time)); '
                      'for capture through the rule this is a reading', item)
        self.assertIn('[which locks noise leaves](theories/becoming/chapters/02-MAP.md#which-locks-noise-leaves)', item)
        self.assertLess(item.index(ident + ' does this.'), item.index('without noise'))
        self.assertLess(item.index('without noise'), item.index('`recorded-checked`'))

    def test_each_start_result_carries_how_far_it_has_been_seen_in_the_one_pages_words(self):
        page = self.page([result(i) for i in navigation.START_HERE]).split('## Registered results')[0]
        items = {i: next(line for line in page.split('\n') if line.startswith('- **') and i + ' does this.' in line) for i in navigation.START_HERE}
        # AG, 9 November 2026: the one page's column is "How far it has been seen", and its cells say only that
        self.assertIn('*How far it has been seen:* Proved on its model; its force is the premise that a selector selects through just those.', items['selection-through-couplings'])
        self.assertIn('*How far it has been seen:* Proved for any set of outcomes.', items['what-an-optimum-does-beyond-what-couples-in'])
        self.assertIn('*How far it has been seen:* Proved on its model.', items['own-count-misses-joint-excess'])
        self.assertIn('*How far it has been seen:* Proved for every relation and class. That this explains how things go on: argued. That every becoming fits it: open.', items['continuation-relative-to-a-class'])
        self.assertNotIn('*How far it has been seen:*', items['one-root-to-its-edge'])  # its record says it
        self.assertNotIn('*Its standing:*', page)
        self.assertIn("its record's statement and how far it has been seen, in its homes' words", page)

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
        # WB, 9 November 2026: the heading names how scope and order form; AG, 9 November: the lead quotes 07 and 08 as they now say it
        self.assertLess(page.index('## The crux, and how scope and order form'), page.index('## Open targets'))
        for key in navigation.OPEN_LEAD:
            self.assertIn(navigation.OPEN_LEAD[key][1][1:].rstrip('.'), page)
        # sixth pass (Ren, messages 10 and 11): no "C for order"; a result names the hypotheses its theorem takes
        self.assertIn('Each ranking result names the hypotheses its theorem takes: the continuation condition, self-concern or `Comparison` (C)', page)
        # fifth pass: the ethics emerges from continuation, so the lead opens with a life going on through what sustains it;
        # sixth pass: holding its own continuation as an order over courses is self-concern, and the ranking is stated at its
        # reach, on a finite listing and between level paths whose admissions end (07 §4); seventh pass (the sixth pass's cold
        # readings): that a life forms such an order is not shown, persisting a filter and not an order formed (07 §4.9), and
        # the condition and self-concern each a scope or a property of an order within the account
        self.assertLess(page.index('A life goes on through what sustains it'), page.index('Each ranking result names'))
        self.assertIn('That a life forms such an order is not shown: in the proofs it is a hypothesis', page)
        self.assertIn('what the models show of persisting is a filter on what was chosen, not an order formed', page)
        # eighth pass (the seventh pass's cold readings, H14, H15): "one way" names only relations running one way, not the
        # direction of the path result; the path result takes decided admission and admitted pairs in a finite list; self-concern
        # ranks so with its own continuation read as what lies within its reach
        self.assertIn("and a life's own continuation is read as what lies within its center's reach", page)
        self.assertIn('on a finite listing and, with admission decided, between two level paths whose admitted pairs fit in a finite list, '
                      'so that their admissions end', page)
        self.assertNotIn('and, one way, between', page)
        self.assertIn('Neither the condition nor self-concern stands above becoming: each represents a scope or a property of an order within the account', page)
        for old in ('C for order', 'between listed courses', 'what does not hold it ceases', 'a matter of reach', 'argued, not shown',
                    'courses that end', 'order or scope some formations hold'):
            self.assertNotIn(old, page)
        # the ninth pass's last text round (10 November 2026): the breadth of a life's reach along being affected (Fable's ninth
        # cold reading, 2.1); the target by the dynamics, as 08 §12 item 12 now says it (Ren on 10 November: the dynamics
        # connected and mapped, not "widening is better")
        self.assertIn("A life's reach, along being affected, holds everything that can affect its continuation at some remove", page)
        self.assertIn('How scope and order form within the dynamics, as dynamics connected to the rest of the map', page)
        for old in ('how orders ranking widening above form', 'Which formations hold an order ranking every widening above'):
            self.assertNotIn(old, page)
        self.assertNotIn("Neither is the account's own", page)
        self.assertNotIn('Neither is asserted', page)
        self.assertNotIn('no warrant from outside is sought', page)

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
        # AG-F's fix round (10 November 2026, its data verifier): the section says the ranking as the fronts say the hinge,
        # once, with its standing and the open target, and leaves the chain's scope to 07 §4
        section = root[root.index('### Under the continuation condition'):root.index('#### cond title')]
        self.assertIn('The hinge of the ethics is proved on models, on a finite listing, and is near-definitional ([chapter 7, '
                      'section 4](theories/becoming/chapters/07-SIGNIFICANCE.md#scope-and-order) states its scope)', section)
        self.assertIn('such an order already ranks one course above another whenever the one keeps all the other keeps and lets '
                      'more form. That a life forms such an order is not shown', section)
        for phrase in ('level paths', 'admitted pairs', 'additive', 'adds no premise', 'never fits', 'this route is silent'):
            self.assertNotIn(phrase, section)
        self.assertIn('[more title](theories/results/records/more.md) (`recorded-checked`)', root)
        self.assertIn('leading-results', anchors_from_text(root))
        self.assertNotIn('Part I', root)

    def test_selection_needs_an_overview_or_a_statement(self):
        with self.assertRaisesRegex(ValueError, 'overview or a statement'):
            navigation.featured_results([result('law', statement=False)], {'readme_featured_results': ['law']})


class OnePageMakingAndMetaAttractor(unittest.TestCase):
    """AG review, fourth pass (9 November 2026): the one page says what it is first and how it was made once, at its end;
    the meta-attractor is the folder's loop with its closed form what 02 §9 proves (in the fifth pass, that it can lock and
    under what conditions); the aim is GOALS' current goal."""

    def page(self, rel):
        return (registry.ROOT / 'theories/becoming' / rel).read_text(encoding='utf-8')

    def paragraph(self, text, lead):
        return next(p for p in text.split('\n\n') if p.startswith(lead))

    def test_the_making_is_said_once_at_the_end(self):
        en, zh = self.page('ONE-PAGE.md'), self.page('ONE-PAGE.zh.md')
        self.assertEqual(en.count('no independent human review is recorded yet'), 1)
        self.assertTrue(en.rstrip().split('\n\n')[-1].startswith('*Made with AI, proofs included.'))
        self.assertNotIn('Made with AI', self.paragraph(en, '**What it is.**'))
        self.assertEqual(zh.count('审查记录') + zh.count('审查的记录'), 1)
        self.assertTrue(zh.rstrip().split('\n\n')[-1].startswith('*它借助 AI 做成，证明也在内。'))
        self.assertNotIn('借助 AI', self.paragraph(zh, '**它是什么。**'))

    def test_the_meta_attractor_and_the_aim(self):
        what = self.paragraph(self.page('ONE-PAGE.md'), '**What it is.**')
        # DW (13 November 2026): the loop said without a contest (no "winning", "buy power")
        self.assertIn('Where what a selection raises comes to set the selection, the loop is what the work calls the '
                      '[meta-attractor](../meta-attractor/README.md)', what)
        self.assertNotIn('buy power', what)
        # AG review, fifth pass: the closed form can lock, under the conditions 02 §9 states (astra, fourth cold reading, 2)
        self.assertIn('can lock ([02 §9](chapters/02-MAP.md#r-closed-capture)) under three conditions: selection does not lower the '
                      'favoured share; a share not lower sets again a rule not lower; and a rule not lower than a favouring one '
                      'still favours. Then a course once locked stays locked', what)
        self.assertNotIn('is proved to lock', what)
        # AG-F's fix round (10 November 2026, astra's cold reading): the loss passing every bound is a premise of
        # `ClosedCapture.lock_outlives_loss` (`Accrues`, at least one unit a step), not something the lock gives
        self.assertIn('stays locked whatever the loss, and if the loss grows by at least one unit each step, it '
                      'passes every bound and the lock holds', what)
        self.assertNotIn('while a loss nothing in it reads passes every bound', what)
        self.assertNotIn('is not in the laws but in a reading', what)
        aim = self.paragraph(self.page('ONE-PAGE.md'), '**Alignment.**')
        # AG-F (10 November 2026): the aligned state as AGENTS.md's sentence and the goal's first two conditions, the
        # meta-attractor the two failing together; no condition comparing courses by widening (round 6's first high finding)
        self.assertIn('something other than their share still makes a difference to the rule, so that a loss that makes no '
                      'difference to their share can turn it', aim)
        self.assertIn('Read on the map, it asks two things.', aim)
        self.assertIn('a lock, once formed, gives way early enough', aim)
        self.assertNotIn('compared by widening', aim)
        self.assertIn('(../../GOALS.md#generative-alignment)', aim)
        # the ninth pass's last text round (10 November 2026): the aim as AGENTS.md states it, its whole sentence, in What it
        # is and in Alignment, as the first screen, USES and MAP say it; until then this asserted the clause absent, the
        # fourth pass's choice after AJ5 (29 October), which predates AGENTS.md (9 November); AJ's condition 1 stays, as
        # the goal's first condition, where the Alignment paragraph lists the goal's conditions
        aim_clause = agents_aim()  # DW (13 November 2026): by reference
        for text in (what, aim):
            self.assertIn(aim_clause, text)
            self.assertNotIn('into neither instrumental convergence', text)
            self.assertNotIn("AJ's plan", text)
        self.assertEqual(self.page('THE-THEORY-OF-BECOMING.md').count(aim_clause), 2)  # its lead and §7
        for rel in ('ONE-PAGE.zh.md', 'THE-THEORY-OF-BECOMING.zh.md'):  # README-ZH's clause
            self.assertEqual(self.page(rel).count('这样的联合选择读取自身份额之外的东西，也不会转而去选择对自身之选择的控制'), 2, rel)


class OnePageEthicsFromContinuation(unittest.TestCase):
    """AG review, fifth pass (9 November 2026), on Ren's message 9 that day ("there is no warrant, ethics emerges from
    continuation condition, not another way around, there is no any dualistic good or evil"): the one page and the overview
    say the ethics from continuation, with no warrant left open; that there is none to find is said once, where a reader
    would ask, outside the ten-minute part."""

    OLD_FRAME = ('unasserted', 'not asserted', 'stated and not asserted', 'neither asserted', 'warrant open', 'its warrant is open',
                 'no warrant from outside is sought', 'binds no one', 'widening what can form is better', 'stay readings',
                 'Two readings, two roles', 'No warrant binding every possible mind is claimed', 'a clarified ethics, not a grounded one')

    def page(self, rel):
        return (registry.ROOT / 'theories/becoming' / rel).read_text(encoding='utf-8')

    def paragraph(self, text, lead):
        return next(p for p in text.split('\n\n') if p.startswith(lead))

    def test_the_old_frame_is_gone(self):
        for rel in ('ONE-PAGE.md', 'THE-THEORY-OF-BECOMING.md'):
            text = self.page(rel)
            for phrase in self.OLD_FRAME:
                self.assertNotIn(phrase, text, (rel, phrase))
        for rel in ('ONE-PAGE.zh.md', 'THE-THEORY-OF-BECOMING.zh.md'):
            text = self.page(rel)
            for phrase in ('扩大可形成者更好', '仍是读法', '两种读法，两种作用', '澄清了、却未奠定根据的伦理', '不主张对一切可能的心智都有约束力的根据'):
                self.assertNotIn(phrase, text, (rel, phrase))

    def test_the_ethics_emerges_from_continuation(self):
        # Sixth pass (9 November 2026, Ren's messages 10 and 11 and the fifth pass's two cold readings): going on is not yet an
        # order (F1); the condition is the closure only on a reading of significance (F2); mutual dependence gives it (F3); the
        # ranking is on a finite listing and, between two courses, one way (F4); seeing is needed and not enough (F6). Seventh
        # pass (the sixth pass's two cold readings, H1-H10): relations close read across all steps; reach, not "continues
        # with"; widening what every additive weighting counting each thing above zero ranks higher, adding no premise beside
        # the life's own concern; one way, concern need not count dependents; admissions end, not courses; the two results
        # compose directly; that a life forms such an order is not shown (07 §4.9), so "emerges" is said with what is shown,
        # offered and open. Eighth pass (the seventh pass's two cold readings, H13-H16): the condition in time (07 §4.11), and
        # the ranking on the condition read across all steps, which is what its theorems take; self-concern defined; "one
        # way" only for relations running one way, the path result with decided admission and its bound from 07 §4.9;
        # seeing needed for a choice to answer to a loss.
        # AG-F (10 November 2026), on round 6's two high findings (the ethics turning on ranking by widening; the chain
        # repeated on every front) and Ren's words that day ("widening is better" is not the way to go): the one page says
        # the canonical text, dynamics first, the hinge once with its standing, the chain's scope left to 07 §4; until then
        # this pinned the chain here (the condition in time, the listing, the level paths, the persisting course, the
        # composite and the additive weightings)
        ethics = self.paragraph(self.page('ONE-PAGE.md'), '**The ethics.**')
        for phrase in ('There is no should beyond becoming ([the opening](OPENING.md)), and no good and evil set over it: right '
                       'and wrong form within it, in people and AI', 'The ethics emerges from continuation: a life goes on through '
                       'what sustains it.',
                       # AG-F's fix round (10 November 2026): closing read across all steps, and whether and when costs come
                       # back in time part of the dynamics (astra's cold reading, its high finding; 07 §4.11, `LatePair`);
                       # self-concern defined before the clause on closing (Fable, L3); the hinge near-definitional (M1)
                       'Where relations of being affected close, read across all steps, whatever bears the costs of its course '
                       'lies within what can, at some remove, affect its own going on', '#r-mutual-dependence-and-its-pace',
                       'and whether and when those costs come back to it in time is part of the dynamics ([07 §4.11]('
                       'chapters/07-SIGNIFICANCE.md#condition-in-time))',
                       "Call a life's order over courses *self-concerned* when it ranks one course above another whenever the "
                       "one keeps all the other keeps and adds to the life's own continuation",
                       'such an order already ranks one course above another whenever the one keeps all the other keeps and lets '
                       'more form: proved on models, on a finite listing, and near-definitional; that a life forms such an order '
                       'is not shown ([07 §4](chapters/07-SIGNIFICANCE.md#scope-and-order))',
                       'Where relations run one way, the losses of those who depend on a life never come back to it',
                       '#r-derived-extent-limits', 'counting them is the one step we offer, for life, 生生, AI within it',
                       'what each course draws on and from what renewal, what it opens and closes, what ends and what goes on, '
                       'and who bears it ([T8](chapters/07-SIGNIFICANCE.md#t8))',
                       "How such orders form, spread and lock, as dynamics connected to the rest of the map, is the work's open "
                       'target', '#open-items-ranked'):
            self.assertIn(phrase, ethics)
        self.assertLess(ethics.index('The ethics emerges from continuation'), ethics.index('proved on models'))
        self.assertEqual(ethics.count('proved on models'), 1)  # how far, once
        for phrase in ('admitted pairs fit in a finite list', 'level paths', 'never fits', 'every additive weighting',
                       'every way of adding up worth', 'ranking by widening', 'compose directly', 'Read in time', 'from some step on',
                       '*widens*', 'can, at some remove, bear on its own going on'):
            self.assertNotIn(phrase, ethics)
        for phrase in ('warrant', 'named order', 'A life that goes on holds', 'what does not hold it ceases', 'listed courses',
                       'not yet joined', 'C, ordering', 'Beyond that', 'argued, not shown', 'continues with', 'read without time',
                       'dated occurrences', 'worth something', 'second premise', 'does not reach', 'courses that end',
                       'not stated as one theorem', 'so ranking by widening',
                       # the eighth pass
                       'if a life holds its own continuation', 'one way, between', 'forming without end',
                       'seeing them is needed, and not enough', 'There, a course', 'and only from the steps where',
                       # the ninth pass
                       "each one's acts", 'come to bear on every other', 'holds only from some step on',
                       # its last text round
                       'the flow is mutually dependent', 'the course of a line that persists'):
            self.assertNotIn(phrase, ethics)
        self.assertNotIn('perspectivist', ethics)  # Fable, fourth cold reading, 1.3: said where a reader would ask

    def test_no_authority_outside_becoming_is_said_once_at_its_reach(self):
        # Sixth pass, F5 and F6: no authority outside becoming is sought, argued; non-entailment proved; whether a reason
        # formed within becoming could hold for every mind is neither claimed nor settled; seeing is needed and not enough
        for rel in ('ONE-PAGE.md', 'THE-THEORY-OF-BECOMING.md'):
            text = self.page(rel)
            self.assertEqual(text.count('seeks no authority outside becoming'), 1, rel)
            self.assertNotIn('no warrant binding every mind', text, rel)
            hold = self.paragraph(text, '**Must anyone hold the condition?**')
            for phrase in ('a perspectivist denies it without contradiction', 'the work does not claim or settle',
                           'Seeing more is needed for a selection to answer to a loss, and not enough', 'not only a failure of reach'):
                self.assertIn(phrase, hold, rel)
            self.assertNotIn('a matter of reach', hold, rel)
            self.assertNotIn('Seeing more is needed, and not enough', hold, rel)
        one = self.page('ONE-PAGE.md')
        self.assertGreater(one.index('**Must anyone hold the condition?**'), one.index('| | What the account says'))
        for rel in ('ONE-PAGE.zh.md', 'THE-THEORY-OF-BECOMING.zh.md'):
            text = self.page(rel)
            self.assertIn('**有谁必须持守延续条件吗？**', text, rel)  # Fable, fifth cold reading, Chinese 1
            self.assertNotIn('必须有人持守', text, rel)

    def test_retired_ways_of_saying_c_and_the_hinge(self):
        # Sixth pass, F9: C names the order a theorem takes (`Comparison`) or C's history, never a premise giving order;
        # F1: going on is not yet an order; F3: mutual dependence gives the condition so read (near-definitional)
        retired = ('C gives order', 'C for order', 'for scope', 'is a named order', "C's premise relocated", 'two premises',
                   'what does not hold it ceases', 'A life that goes on holds', 'not yet stated as one theorem; on',
                   'the joining of mutual dependence to the condition', 'a matter of reach', 'on listed courses',
                   'between listed courses', 'a narrower premise than C', 'reach further, as seeing')
        retired_zh = ('一种指名的次序', 'C 的前提换了位置', '以该条件定范围', 'C 定次序', '不持守它的', '持守自身的延续：', '到达那里的，是看见',
                      '列出的进程', '相互依存给出该条件，这一点尚未', '把相互依存与延续条件合成一条定理', '比 C 更窄的前提',
                      '其中无人读取的损失', '而不是从这条路径；', '而不是从这条路径（', '渐渐读到')
        # seventh pass (the sixth pass's two cold readings, H1-H9): the wordings the frame corrects, in both languages
        retired += ('argued, not shown', 'what each center continues with', 'what a center continues with', 'read without time',
                    'as among dated occurrences', 'every way of counting each thing', 'as worth something', 'no second premise',
                    'does not reach those who depend on one', 'does not reach it', 'courses that end', 'not stated as one theorem',
                    'C names the order', 'the order ranking a course above every course it widens', 'the ethics laid open',
                    'C the monotonicity of opportunity sets', 'each is a scope or order some formations hold')
        retired_zh += ('已论证，未表明', '有所值的计法', '不计时间', '有日期的诸发生', '与之一同延续', '到达不了', '与之同提',
                       '终会停止容纳', '别无他物', '尚未陈述为一条定理', '不规定意义', '净加权', '来持守', '把伦理摊开来',
                       'C 是机会集的单调性', '那种次序之名')
        for rel in ('ONE-PAGE.md', 'THE-THEORY-OF-BECOMING.md'):
            for phrase in retired:
                self.assertNotIn(phrase, self.page(rel), (rel, phrase))
        for rel in ('ONE-PAGE.zh.md', 'THE-THEORY-OF-BECOMING.zh.md'):
            for phrase in retired_zh:
                self.assertNotIn(phrase, self.page(rel), (rel, phrase))
        # Fable, sixth cold reading, Chinese 4: the one page has no other 相续, so not "line" as a term there
        self.assertNotIn('相续', self.page('ONE-PAGE.zh.md'))

    def test_the_lake_c_and_the_evidence_at_their_reach(self):
        # Seventh pass: on the lake, one-way relations mean the fishers' own continuation does not require the bed (H4), and
        # widening is what every additive weighting counting each listed thing above zero ranks higher (H1); C is a
        # requirement on an order (H5); the evidence names what the review found new without its old frame (F7)
        for rel in ('ONE-PAGE.md', 'THE-THEORY-OF-BECOMING.md'):
            text = self.page(rel)
            self.assertIn("preserving the fishers' own continuation does not require preserving the bed", text, rel)
            # AG-F: widening said on the lake as a relation between the two courses; the additive weightings are 07 §4.4's
            self.assertIn('a relation between the two courses, which does not weigh the lost catch', text, rel)
            self.assertNotIn('the bed among them, above zero ranks it higher', text, rel)
            self.assertIn('the requirement that an order rank each course above every course it widens', text, rel)
            self.assertIn('It found three things new', text, rel)
            self.assertIn('the scope and order the ranking results assume, clarified', text, rel)  # 08 §8's word; the first screen links 'the ranking results'
        for rel in ('ONE-PAGE.zh.md', 'THE-THEORY-OF-BECOMING.zh.md'):
            text = self.page(rel)
            self.assertIn('所以保住渔民自身的延续，并不要求保住贻贝床', text, rel)
            self.assertIn('即要求一种次序把一个进程排在它所扩大的每一个进程之上', text, rel)
            self.assertIn('它认为新的有三样', text, rel)
            self.assertIn('生命是否会形成', text, rel)
            # the ninth pass (K10): persisting's filter in the one plain sentence every Chinese front says; since AG-F the one
            # page leaves it to 07 §4.9, below
            if rel == 'THE-THEORY-OF-BECOMING.zh.md':
                self.assertIn('模型所显示的持续存在，只限定了哪些选择可能已经发生，并不表明作选择者持有或形成了某种次序', text, rel)
            self.assertIn('把“哪些延续有意义”', text, rel)  # astra, sixth cold reading, Chinese 8
        # astra and the sixth pass's verifier: the Chinese T8 refuter's example is marked as one
        self.assertIn('（例：渔民所捕多于鱼群所能补回，而渔民靠鱼群为生）', self.page('ONE-PAGE.zh.md'))
        # the overview's C bullet: a requirement, no longer a second foundation, its history kept; the ranking theorem's
        # hypotheses, with the condition used only at the life's own standpoint (H2); "emerges" said with what is shown (H10)
        overview = self.page('THE-THEORY-OF-BECOMING.md')
        for phrase in ('*C* names the requirement that an order rank each course above every course it widens (`Comparison`)',
                       'C is no longer introduced as a second foundation of the ethics; the name stays for the requirement '
                       'particular theorems take.', "whose proof uses the condition only at the life's own standpoint",
                       "With each standpoint's own continuation marking exactly its center's closure along a relation",
                       '"Emerges" names neither a derivation nor a shown development',
                       'not for orders neither additive nor transitive',
                       "not the offer's scope toward dependents whose loss never returns to them (§9) |"):
            self.assertIn(phrase, overview)
        zh = self.page('THE-THEORY-OF-BECOMING.zh.md')
        for phrase in ('*C* 是对一种次序的一项要求之名', '本论不再把 C 当作伦理的第二个根基', '其证明只在生命自身的立场上用到延续条件',
                       '“生出”既不指一个推导，也不指一个已表明的发展', '对净赋权已证明归约'):
            self.assertIn(phrase, zh)

    def test_the_case_says_the_fishers_once_and_the_control(self):
        one = self.page('ONE-PAGE.md')
        case = self.paragraph(one, '**One case.**')
        self.assertIn('three AI fishers, existing language models told what to do and not trained in the test, share a lake', case)
        self.assertNotIn('none was trained or fine-tuned', one)
        # the control arm (COMM_SEEN_TALK) had the community's goal and not the instruction; the treatment had both, so not
        # "in place of" (fifth pass, verifier)
        self.assertIn('against 3 of 10 when, told of the bed and able to talk, it had the community\'s goal alone, without that instruction', case)
        self.assertNotIn('in place of', case)
        # AG-F's fix round (astra's cold reading): the predictions as the first screen gives them, not "mostly failed",
        # which is the joint verdict across the two models
        self.assertIn("With talk, the second round's four frozen predictions all passed for that model, and three of the four "
                      'failed for the other; in the first round, without talk, five of its seven failed', case)
        self.assertNotIn('mostly failed', case)
        self.assertNotIn('none was trained or fine-tuned', self.page('THE-THEORY-OF-BECOMING.md'))

    def test_the_case_carries_the_reader_to_the_ethics_first(self):
        # astra, fourth cold reading, 6: the root, the picture and the table follow the lake's ethics
        one = self.page('ONE-PAGE.md')
        order = [one.index(lead) for lead in ('**One case.**', '**The ethics.**', 'In the case, relations run one way',
                                              '| | What the account says', '**The root.**', '](results/spine.svg)')]
        self.assertEqual(order, sorted(order))

    def test_the_overview_says_what_is_open_and_each_limit_at_its_claim(self):
        text = self.page('THE-THEORY-OF-BECOMING.md')
        self.assertIn('<a id="10-what-is-not-shown-and-what-is-open"></a>\n## 10. What is open\n', text)
        self.assertIn('<a id="10-尚未表明者与未决者"></a>\n## 10. 未决者\n', self.page('THE-THEORY-OF-BECOMING.zh.md'))
        # sixth pass, F3 and F4: the condition from mutual dependence is proved (near-definitional), and the ranking is not
        # shown for courses without end; seventh pass, H9: the two compose directly, said where the ranking is, not as a gap
        self.assertIn('Mutual dependence and this ranking compose directly, though no single theorem states the composite', text)
        # eighth pass (H15): what 07 §4.9 proves of the bound, not "not shown for courses that go on forming without end"
        # the ninth pass's last text round: the course actually taken (Fable, ninth cold reading, 2.2); the target named by
        # the dynamics, connected to the rest of the map (Ren, 10 November 2026, sources/15-codex-theory-conversations/
        # 2026-11-10-dynamics-connected-mapped-unified.md: "widening is better" is not the way to go), not as how orders
        # ranking widening above form
        # AG-F: the chain, the persisting course with it, is said once, in §7 (round 6's second high finding)
        self.assertEqual(text.count('never fits'), 1)
        self.assertEqual(text.count('admitted pairs fit in a finite list'), 1)
        self.assertLess(text.index('## 7. Significance'), text.index('never fits'))
        self.assertNotIn('never fits', self.page('ONE-PAGE.md'))
        self.assertIn('**How scope and order form within the dynamics**, as dynamics connected to the rest of the map', text)
        self.assertIn('Not yet connected or mapped, beside the lifting above:', text)
        for rel in ('ONE-PAGE.md', 'THE-THEORY-OF-BECOMING.md'):
            self.assertNotIn('how orders ranking widening above form', self.page(rel), rel)
        for rel in ('ONE-PAGE.zh.md', 'THE-THEORY-OF-BECOMING.zh.md'):
            self.assertNotIn('把扩大排在上面的次序又如何形成', self.page(rel), rel)
            self.assertIn('即作为与地图其余部分相连的动力学', self.page(rel), rel)
        self.assertNotIn('forming without end', text)
        opened = text.split('## 10. What is open', 1)[1]
        self.assertNotIn('one theorem', opened)
        self.assertNotIn('compose', opened)
        self.assertEqual(text.count('no independent human review is recorded yet') + text.count('No independent human review is recorded yet'), 1)

    def test_the_eighth_pass_at_its_theorems(self):
        # AG review, eighth pass (10 November 2026), on the seventh pass's two cold readings. H11: the direction's theorems
        # take J1/J2 (`Priority`), not C, and on the moves' frame an extension is a widening (`Direction.extension_iff_widens`).
        # H12: C has a `living` parameter, said where C is first named. H13: seeing is needed for a choice to answer to a
        # loss, and the lake's untold bed said as the test's result (07 T4: no condition kept an untold dependent). H16: the
        # condition in time and the one-center bound (07 §4.11). H18: self-concern ranks only widenings adding an own-marked
        # item; it gives no reason of its own (astra, seventh cold reading, 2). The picture draws three boxes into 07.
        pages = {rel: self.page(rel) for rel in ('ONE-PAGE.md', 'THE-THEORY-OF-BECOMING.md', 'ONE-PAGE.zh.md',
                                                 'THE-THEORY-OF-BECOMING.zh.md')}
        for rel, text in pages.items():
            for phrase in ('C read as widening', '按扩大来读的 C', 'the continuation condition and C coming into chapter 7',
                           '延续条件与 C 进入第七章', 'forming without end', '没有尽头的进程', 'a reason of its own, formed in it',
                           '在它之中形成的理由', '看见它们是必要的，却不足够', '看见更多是必要的，却不足够', 'seeing it was needed',
                           'on an acyclic relation, where it holds', '在无环的关系上，若它成立'):
                self.assertNotIn(phrase, text, (rel, phrase))
        for rel in ('ONE-PAGE.md', 'THE-THEORY-OF-BECOMING.md'):
            text = pages[rel]
            self.assertIn('the continuation condition, self-concern and C coming into chapter 7', text, rel)
            self.assertIn('C (`Comparison`: with every claim counted as living, the requirement that an order rank each course '
                          'above every course it widens)', text, rel)
            # the ninth pass (K4): offered under the condition, J1–J4 and a correspondence; the theorems take J1/J2
            self.assertIn('J1–J4 and a correspondence to actual systems', text, rel)
            self.assertIn('its theorems take J1/J2 and compare moves by what their outcomes admit, and do not use the condition',
                          text, rel)
        self.assertIn('In the test, no instruction tried preserved the untold bed', pages['ONE-PAGE.md'])
        overview = pages['THE-THEORY-OF-BECOMING.md']
        for phrase in ('`Flow.not_unrestricted_inTime`', '`Flow.unrestrictedEventually_iff_mutuallyDependentInTime`',
                       '`Flow.unrestrictedAfter_iff_coupledEachStep`', '`Drawing.lapses`', '`«续无外当且仅当后与独»`',
                       '`TwoSources.apart`', 'Where the condition holds, on an acyclic relation every standpoint has the same center',
                       'in general `Comparison` takes a reading `living`',
                       # the ninth pass (K5): the quantifier where `increasingInOwn_iff_increasing_iff_marks` puts it
                       'On a fixed listing, self-concern and being increasing in admission coincide for every order exactly when '
                       'every listed item is marked',
                       'it gives no verdict where keeping one thing closes another, and it shows no reason formed',
                       'Seeing them is needed there for a choice to answer to their loss, and not enough',
                       'seeing them is needed for a choice to answer to their loss, and not enough, and counting their loss is '
                       'the step of invariance'):
            self.assertIn(phrase, overview)
        for rel in ('ONE-PAGE.zh.md', 'THE-THEORY-OF-BECOMING.zh.md'):
            text = pages[rel]
            self.assertIn('延续条件、自我关切与 C 进入第七章', text, rel)
            self.assertIn('每一个主张都算作活时，即要求一种次序把一个进程排在它所扩大的每一个进程之上', text, rel)  # the glossary's 算作活
            if rel == 'THE-THEORY-OF-BECOMING.zh.md':  # as GLOSSARY.zh says it; the one page's Must anyone says it of a loss
                self.assertIn('要让选择因它们的损失而改变，就得看见它们，但看见还不够', text, rel)
            self.assertIn('其定理取 J1/J2，按各动作的结果所容纳者来比较诸动作，不使用延续条件', text, rel)  # the ninth pass (K4)
            # astra, seventh cold reading, Chinese 5; plainer in the ninth pass's last text round (astra, ninth cold reading,
            # 5), with the instruction's own "conditions that your fishing changes" (experiments/direction-installation)
            self.assertIn('他们的捕捞会改变一些条件，凡是延续依赖于这些条件的，都要算在内', text, rel)
            self.assertNotIn('凡是延续依存于他们的捕捞所改变之物的', text, rel)
        zh = pages['ONE-PAGE.zh.md']
        # AG-F: the one page's Chinese ethics is the canonical text, one paragraph, dynamics first, the hinge once
        for phrase in ('生命的延续也包含摄食与终结', '便及于自己行为下游的一切', '试过的指令没有一条保住了它',
                       '伦理从延续中生出：生命依靠维持它的东西而延续。',
                       '（*自我关切*；这里把自身的延续读作一切能隔着若干环节影响它的东西）',
                       # AG-F's fix round: as the Chinese screen (astra's high finding; Fable, M1 and L1)
                       '（这里把各个时刻的依赖与交换合在同一个关系里读），为它的进程付出代价的东西，都在能隔着若干环节影响它自身延续的东西'
                       '之内（[05](chapters/05-COLLECTIVES.md#r-mutual-dependence-and-its-pace)），但这并不保证影响按时间顺序传回来',
                       '又多出一些属于生命自身延续的东西', '依存于它的那些东西所承受的损失',
                       '这在模型上、在一个有限列表上已证明，并且近乎依定义，而生命是否会形成这种次序，尚未表明',
                       '看每一个进程取用什么、靠什么更新来补充，打开什么、关上什么，什么终结、什么继续，由谁承担'):
            self.assertIn(phrase, zh)
        for phrase in ('可列入一个有限列表', '能用一个有限列表列全', '从不能列入', '可以直接组合', '再把权重相加的计法',
                       '都可能隔着若干环节影响到它自身的延续', '多数没有通过'):
            self.assertNotIn(phrase, zh)
        self.assertIn('`Flow.unrestrictedEventually_iff_mutuallyDependentInTime`', pages['THE-THEORY-OF-BECOMING.zh.md'])
        # the eighth pass's verifier: in the overview's table the one-center bound follows "the root's condition", not the
        # in-time reading (the condition from some step on holds with every occurrence a standpoint, `RingOfThree.apart`);
        # the route said as the glossary's 论证路线, not 路径 beside 水平路径; admission 已判定 and （步，形成）对 as the glossary
        # the ninth pass: the bound with what it comes from on a net going forward in time (critic 5.2 item 11), and the
        # in-time clause as K3 says it
        # the ninth pass's last text round: the in-time reading takes every occurrence as a standpoint
        # (`Flow.not_unrestricted_inTime`), so that the two clauses cannot read as contradicting; the bound with what it comes
        # from in the words of the overview's §7, 07's thesis, USES and the glossary («续无外当且仅当后与独», «独则同一中心»:
        # on such a net the bound comes from the second part; its verifier, in place of "this bound counts what lies at or
        # before a center's step")
        for rel, bound, in_time in (('THE-THEORY-OF-BECOMING.md', "where it holds on an acyclic relation, every standpoint has "
                                     "the same center: on a net going forward in time this comes from the condition's asking "
                                     "that nothing other than the center lie at or before the center's step, and over what "
                                     'comes after, two centers can meet it',
                                     'read in time, with every occurrence a standpoint, it cannot hold over every step wherever '
                                     'there is a formation'),
                                    ('THE-THEORY-OF-BECOMING.zh.md', '在它成立之处，在无环的关系上每一个立场都有同一个中心：在随时间前进'
                                     '的网上，这来自该条件的一项要求，即除中心之外，没有什么位于中心那一步或其前',
                                     '按时间来读、以每一个发生为立场，凡有一个形成之处，它都不能在每一步都成立')):
            row = next(line for line in pages[rel].splitlines() if bound in line)
            self.assertLess(row.index(bound), row.index(in_time), rel)
        self.assertIn('所以这一论证路线对它什么也没有说', pages['THE-THEORY-OF-BECOMING.zh.md'])  # since AG-F, said once, there
        for rel in ('ONE-PAGE.zh.md', 'THE-THEORY-OF-BECOMING.zh.md'):
            for old in ('这条路径对它', '容纳可判定', '（步，形成）项'):
                self.assertNotIn(old, pages[rel], (rel, old))
        self.assertNotIn('over what comes after two centers', pages['THE-THEORY-OF-BECOMING.md'])
        self.assertNotIn('this bound counts what lies', pages['THE-THEORY-OF-BECOMING.md'])
        self.assertNotIn('这一界限所计的', pages['THE-THEORY-OF-BECOMING.zh.md'])

    def test_the_ninth_pass_at_its_theorems(self):
        # AG review, ninth pass (10 November 2026), on the eighth pass's two cold readings and its critic. K3: read in time
        # the condition cannot hold over every step (`Flow.not_unrestricted_inTime`); its form from some step on, another
        # predicate, is reach through exchanges and each one's going on (`StepInTime`), not acts alone. K4: the direction is
        # offered under the condition, J1–J4 and a correspondence, and its theorems take J1/J2, not the condition. K5: the
        # quantifier where `increasingInOwn_iff_increasing_iff_marks` puts it. K6: self-concern defined in the anchor's words.
        # K7: the persisting course never fits a finite list under 07 §4.9's hypotheses. K10: the Chinese terms made one.
        pages = {rel: self.page(rel) for rel in ('ONE-PAGE.md', 'THE-THEORY-OF-BECOMING.md', 'ONE-PAGE.zh.md',
                                                 'THE-THEORY-OF-BECOMING.zh.md')}
        for rel in ('ONE-PAGE.md', 'THE-THEORY-OF-BECOMING.md'):
            text = pages[rel]
            for phrase in ("each one's acts", 'come to bear on every other', 'holds only from some step on',
                           'For every order on a fixed listing', 'Where a life holds its own continuation as an order',
                           'takes the continuation condition, J1–J4', 'its theorems taking the continuation condition',
                           'J1–J4 and a correspondence as'):
                self.assertNotIn(phrase, text, (rel, phrase))
            for phrase in ('J1–J4 and a correspondence to actual systems',
                           'and do not use the condition; read under it, every admission compared counts from every standpoint'):
                self.assertIn(phrase, text, (rel, phrase))
            if rel == 'THE-THEORY-OF-BECOMING.md':  # since AG-F the one page leaves the chain and its reading in time to 07
                for phrase in ('from some step on', 'from any formation at any step, every formation is reached at some later '
                               "step, through exchanges and each one's going on"):
                    self.assertIn(phrase, text, (rel, phrase))
            found = [m.start() for m in re.finditer('never fits', text)]
            self.assertEqual(bool(found), rel == 'THE-THEORY-OF-BECOMING.md', rel)
            for at in found:  # each "never fits" said with 07 §4.9's hypotheses
                self.assertIn('activity, support and descent', text[at - 160:at + 160], (rel, text[at - 80:at + 40]))
        overview = pages['THE-THEORY-OF-BECOMING.md']
        for phrase in ("Call a life's order over courses *self-concerned* when it ranks above what it widens every widening "
                       'that adds to its own continuation, read as what lies within its reach (*self-concern*, '
                       '`Weighting.IncreasingInOwn`)',
                       'its form from some step on, another predicate, holds exactly where the flow is mutually dependent in '
                       "time: from any formation at any step, every formation is reached at some later step, through exchanges "
                       "and each one's going on, the steps reached differing",
                       'it fails over every step wherever there is a formation, since nothing reaches an earlier step'):
            self.assertIn(phrase, overview)
        for rel in ('ONE-PAGE.zh.md', 'THE-THEORY-OF-BECOMING.zh.md'):
            text = pages[rel]
            # the ninth pass's last text round (Fable, ninth cold reading, Chinese 1): 以……为前提 beside 不使用延续条件 read
            # as a contradiction, so the direction is said as offered under them; the course actually taken (Fable 2.2)
            for phrase in ('每一个的行为', '只从某一步起', '容纳已判定', '只证明了这一个方向', '范围之内者', '一道筛选',
                           '以延续条件、J1–J4 与一个对应为假设', '按扩大来比较诸行动', '谱系', '这条路径对它',
                           '以延续条件、J1–J4 以及与实际系统的对应为前提', '流在时间中相互依存之处', '列不进', '从不落入'):
                self.assertNotIn(phrase, text, (rel, phrase))
            for phrase in ('是在延续条件、J1–J4 以及与实际系统的对应之下提出的',
                           '在该条件之下来读，所比较的每一项容纳从每一个立场看都算数'):
                self.assertIn(phrase, text, (rel, phrase))
            if rel == 'THE-THEORY-OF-BECOMING.zh.md':  # since AG-F the one page leaves these to 07 §4 and §4.11
                for phrase in ('从任一步的任一形成出发，经由交换与各自的延续，每一个形成都会在此后某一步被到达',
                               '在能判定容纳与否', '这里把自身的延续读作自身所能到达的一切', '每一个延续都能隔着若干环节',
                               '沿“受影响”这一关系，生命所能到达的，包括一切能隔着若干环节影响其延续的东西：维持它的，与它取用同一些'
                               '条件的，都在其中。'):
                    self.assertIn(phrase, text, (rel, phrase))
            # 列入, as the cell's own 可列入一个有限列表 and the glossary say it (pass 9c's verifier); said once, in the overview
            found = [m.start() for m in re.finditer('从不能列入', text)]
            self.assertEqual(len(found), 1 if rel == 'THE-THEORY-OF-BECOMING.zh.md' else 0, rel)
            for at in found:
                self.assertIn('活动、支撑与世系', text[at - 80:at + 10], (rel, text[at - 60:at + 10]))
        # the overview's row with every occurrence a standpoint (above); the one page's K3 short form went with the chain in
        # AG-F, its reading in time left to 07 §4.11
        self.assertIn('按时间来读、以每一个发生为立场，凡有一个形成之处，它都不能在每一步都成立，因为没有什么能到达过去',
                      pages['THE-THEORY-OF-BECOMING.zh.md'])
        self.assertNotIn('按时间来读', pages['ONE-PAGE.zh.md'])
        # the overview keeps 重合 for two properties coinciding: §6 names a passage's agreement 相合
        self.assertIn('在一个固定列表上，自我关切与随容纳而递增对每一种次序都重合，恰在每个所列之物都被标记为自身之物之时',
                      pages['THE-THEORY-OF-BECOMING.zh.md'])


if __name__ == '__main__':
    unittest.main()
