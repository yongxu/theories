"""Keep leading results ordered, scoped and derived from reviewable metadata."""
import copy
import json
import re
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from tools.research import navigation, registry

FIRST_SCREEN, LEAD = '_process/navigation/README-FIRST-SCREEN.md', '_process/navigation/README-LEAD.md'
REPOSITORY = '_process/navigation/REPOSITORY.md'


def result(ident, status='reviewed-scoped'):
    return {
        'id': ident, 'status': status, 'kind': 'argument',
        'title': {'zh': ident + ' 主张', 'en': ident + ' claim'},
        'canonical_source': 'theories/' + ident + '.md',
        '_record_path': 'theories/results/records/' + ident + '.json',
        'dependencies': [],
        'overview': {
            'title': {'zh': ident + ' 标题', 'en': ident + ' result'},
            'summary': {'zh': ident + ' 摘要', 'en': ident + ' scoped summary'},
            'evidence': {'zh': ident + ' 证据', 'en': ident + ' recorded evidence'},
        },
    }


def goal(ident, result_ids=()):
    return {
        'id': ident, 'scope_type': 'project-direction', 'state': 'unmarked',
        **{field: {'zh': ident + ' ' + field, 'en': ident + ' ' + field}
           for field in ('title', 'scope', 'objective', 'completion', 'premises')},
        'sources': ['README.md'], 'result_ids': list(result_ids),
        'overview': {
            'title': {'zh': ident + ' 方向', 'en': ident + ' direction'},
            'summary': {'zh': ident + ' 研究', 'en': ident + ' research summary'},
            'next_step': {'zh': ident + ' 下一步', 'en': ident + ' next investigation'},
        },
    }


class FeaturedResultsTests(unittest.TestCase):
    def test_selection_is_optional_and_preserves_configured_order(self):
        records = [result('first'), result('second')]
        self.assertEqual(navigation.featured_results(records, {}), [])
        selected = navigation.featured_results(records, {'readme_featured_results': ['second', 'first']})
        self.assertEqual([r['id'] for r in selected], ['second', 'first'])

    def test_rejects_malformed_duplicate_and_missing_selections(self):
        records = [result('first')]
        for configured, message in [
            ('first', 'list of result IDs'),
            ([3], 'list of result IDs'),
            (['first', 'first'], 'duplicate result IDs'),
            (['missing'], 'missing result'),
        ]:
            with self.subTest(configured=configured):
                with self.assertRaisesRegex(ValueError, message):
                    navigation.featured_results(records, {'readme_featured_results': configured})

    def test_rejects_open_superseded_and_withdrawn_results(self):
        for status in ('open', 'superseded', 'withdrawn'):
            with self.subTest(status=status):
                with self.assertRaisesRegex(ValueError, 'completed scoped result'):
                    navigation.featured_results([result('first', status)], {'readme_featured_results': ['first']})

    def test_rejects_target_even_if_incorrectly_marked_completed(self):
        record = result('first')
        record['kind'] = 'target'
        with self.assertRaisesRegex(ValueError, 'completed scoped result'):
            navigation.featured_results([record], {'readme_featured_results': ['first']})

    def test_requires_every_overview_field_in_one_language(self):
        for field in ('title', 'summary', 'evidence'):
            for language in ('en', 'zh'):
                record = result('first')
                record['overview'][field][language] = ' '
                with self.subTest(field=field, language=language):
                    self.assertEqual(len(navigation.featured_results([record], {'readme_featured_results': ['first']})), 1)
            record = result('first')
            record['overview'][field] = {'en': ' ', 'zh': ''}
            with self.subTest(field=field, language=None):
                with self.assertRaisesRegex(ValueError, 'overview title, summary and evidence'):
                    navigation.featured_results([record], {'readme_featured_results': ['first']})

    def test_navigation_validation_reports_invalid_featured_selection(self):
        with patch.object(navigation, 'goals', return_value=[]), patch.object(navigation, 'read', return_value={'readme_featured_results': ['missing']}):
            errors = navigation.validate_goals([])
        self.assertTrue(any('missing result: missing' in error for error in errors))

    def test_root_leads_with_ordered_english_summaries_and_source_links(self):
        records = [result('first'), result('second')]
        config = {'readme_featured_results': ['second', 'first'], 'readme_repository': REPOSITORY}
        def read(path):
            return config if path == navigation.CONFIG else {'documents': {}}
        with patch.object(navigation, 'read', side_effect=read), patch.object(navigation, 'goals', return_value=[]):
            views = navigation.render_views(records)
        root = views['README.md']
        self.assertTrue(root.startswith('# The Theory of Becoming\n'))
        self.assertLess(root.index('#### second claim'), root.index('#### first claim'))
        self.assertLess(root.index('first scoped summary'), root.index('## Research and repository'))
        self.assertIn('second scoped summary', root)
        self.assertIn('**Status:** `reviewed-scoped`', root)
        self.assertIn('[canonical source](theories/second.md)', root)
        self.assertIn('[conditions and evidence](theories/results/records/second.md)', root)
        self.assertNotIn('second 摘要', root)
        # AG, 9 November 2026: the brief opens with what the work is for, in AGENTS.md's terms
        self.assertIn('We are drawing a map of how relations form', views['_process/BRIEF.md'])
        for aim in ('so that humans and AI can check it and see the way together', 'first a map for alignment', 'also a map of wisdom'):
            self.assertIn(aim, views['_process/BRIEF.md'])
        self.assertNotIn('universal warrant', views['_process/BRIEF.md'])
        self.assertIn('Canonical entry:', views['_process/BRIEF.md'])
        self.assertNotIn('## What is established', views['_process/BRIEF.md'])
        for path, body in views.items():
            with self.subTest(path=path):
                prose = re.sub(r'<a id="[^"]*"></a>', '', body)  # kept anchors may spell the earlier Chinese heading
                # the navigation line's link to the Chinese edition is named in its own language, as the English fronts name it
                prose = re.sub(r'\[(?:中文|一页（中文）)\]\([^)]*\.zh\.md\)', '', prose)
                self.assertNotRegex(prose, '[\u4e00-\u9fff]', 'generated views render English only')

    def test_optional_overview_is_validated_and_visible_on_record_page(self):
        records, _ = registry.load_records()
        record = copy.deepcopy(records[0])
        record['overview'] = result('editorial')['overview']
        rendered = registry.render_record(record)
        for field in ('title', 'summary', 'evidence'):
            self.assertIn(record['overview'][field]['en'], rendered)
            self.assertNotIn(record['overview'][field]['zh'], rendered)
        for bad in (None, {}, {'title': {'zh': '标题', 'en': 'Title'}}):
            record['overview'] = bad
            errors, _ = registry.validate([record])
            self.assertTrue(any('overview requires title, summary and evidence' in error for error in errors))


class ResearchGoalsTests(unittest.TestCase):
    def test_selection_is_optional_and_ordered(self):
        goals = [goal('ethics'), goal('evolution')]
        self.assertEqual(navigation.research_goals(goals, {}), [])
        selected = navigation.research_goals(goals, {'readme_research_goals': ['evolution', 'ethics']})
        self.assertEqual([g['id'] for g in selected], ['evolution', 'ethics'])

    def test_rejects_malformed_duplicate_and_missing_goal_ids(self):
        for configured, message in [
            ('ethics', 'list of goal IDs'),
            ([3], 'list of goal IDs'),
            (['ethics', 'ethics'], 'duplicate goal IDs'),
            (['unknown'], 'missing goal'),
        ]:
            with self.subTest(configured=configured):
                with self.assertRaisesRegex(ValueError, message):
                    navigation.research_goals([goal('ethics')], {'readme_research_goals': configured})

    def test_accepts_one_language_and_rejects_empty_overview_fields(self):
        for field in ('title', 'summary', 'next_step'):
            for language in ('en', 'zh'):
                metadata = goal('ethics')
                metadata['overview'][field][language] = ' '
                with self.subTest(field=field, language=language):
                    self.assertEqual(len(navigation.research_goals([metadata], {'readme_research_goals': ['ethics']})), 1)
            metadata = goal('ethics')
            metadata['overview'][field] = {'zh': ' '}
            with self.subTest(field=field, language=None):
                with self.assertRaisesRegex(ValueError, 'overview title, summary and next_step'):
                    navigation.research_goals([metadata], {'readme_research_goals': ['ethics']})
                with patch.object(navigation, 'goals', return_value=[metadata]), patch.object(navigation, 'read', return_value={}):
                    errors = navigation.validate_goals([])
                self.assertTrue(any('overview requires title, summary and next_step' in error for error in errors))

    def test_navigation_validation_reports_missing_goal_id(self):
        with patch.object(navigation, 'goals', return_value=[]), patch.object(navigation, 'read', return_value={'readme_research_goals': ['unknown']}):
            errors = navigation.validate_goals([])
        self.assertTrue(any('missing goal: unknown' in error for error in errors))

    def test_root_renders_ordered_research_and_only_established_result_links(self):
        records = [result('checked', 'recorded-checked'), result('reviewed'), result('open-result', 'open'), result('retired', 'superseded'), result('withdrawn-result', 'withdrawn')]
        records[2]['kind'] = 'target'
        goals = [goal('ethics', ['open-result', 'checked', 'retired', 'reviewed', 'withdrawn-result']), goal('evolution')]
        config = {'readme_featured_results': ['checked'], 'readme_research_goals': ['evolution', 'ethics']}
        def read(path):
            return config if path == navigation.CONFIG else {'documents': {}}
        with patch.object(navigation, 'read', side_effect=read), patch.object(navigation, 'goals', return_value=goals):
            views = navigation.render_views(records)
        root = views['README.md']
        # the landing names the directions, in order, and links them on RESEARCH.md, which carries their details (RW)
        self.assertLess(root.index('## What is established'), root.index('## Ongoing research'))
        self.assertLess(root.index('[evolution direction](RESEARCH.md#evolution)'), root.index('[ethics direction](RESEARCH.md#ethics)'))
        self.assertLess(root.index('## Ongoing research'), root.index('## Research and repository'))
        self.assertNotIn('**Next:**', root)
        research = views['RESEARCH.md']
        self.assertLess(research.index('<a id="evolution"></a>'), research.index('<a id="ethics"></a>'))
        self.assertLess(research.index('### evolution direction'), research.index('### ethics direction'))
        self.assertIn('**Next:** ethics next investigation', research)
        self.assertIn('[Scope and authorization](GOALS.md#ethics)', research)
        self.assertIn('[Primary source](README.md)', research)
        root = research
        established = next(line for line in root.splitlines() if line.startswith('**Established results:**'))
        self.assertIn('[checked claim](theories/results/records/checked.md)', established)
        self.assertIn('[reviewed claim](theories/results/records/reviewed.md)', established)
        self.assertNotIn('open-result', established)
        self.assertNotIn('retired', established)
        self.assertNotIn('withdrawn-result', established)
        self.assertNotIn('ethics 研究', root)
        self.assertIn('ethics research summary', views['GOALS.md'])
        self.assertIn('ethics next investigation', views['GOALS.md'])
        self.assertNotIn('ethics 研究', views['GOALS.md'])
        # The earlier bilingual heading's anchor stays, so inbound links resolve.
        self.assertIn('<a id="ethics-title--ethics-title"></a>\n### ethics title', views['GOALS.md'])


class OpeningTests(unittest.TestCase):
    def test_opening_is_optional(self):
        self.assertEqual(navigation.readme_opening({}), '')

    def test_rejects_malformed_missing_and_empty_openings(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'empty.md').write_text('<!-- A note for editors. -->\n\n')
            for configured, message in [
                (3, 'path of a Markdown file'),
                ('opening.txt', 'path of a Markdown file'),
                ('missing.md', 'missing file'),
                ('empty.md', 'is empty'),
            ]:
                with self.subTest(configured=configured):
                    with self.assertRaisesRegex(ValueError, message):
                        navigation.readme_opening({'readme_opening': configured}, root)

    def test_opening_drops_the_editor_comment_and_adapts_links(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'theories').mkdir()
            (root / 'theories/OPENING.md').write_text('<!-- Edit here. -->\n## Truth exists\n\nSee [the source](../sources/original.md).\n')
            opening = navigation.readme_opening({'readme_opening': 'theories/OPENING.md'}, root)
        self.assertEqual(opening, '## Truth exists\n\nSee [the source](sources/original.md).')

    def test_opening_footnotes_become_numbered_notes_with_adapted_links(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'theories').mkdir()
            (root / 'theories/OPENING.md').write_text(
                'Truth exists.[^law]\n\n[ref]: ../sources/original.md\n\n'
                '[^law]: **Proved.** See [the record](records/law.md).\n')
            opening = navigation.readme_opening({'readme_opening': 'theories/OPENING.md'}, root)
        self.assertEqual(opening, 'Truth exists.<sup><a id="ref-law"></a>[1](#note-law)</sup>\n\n[ref]: sources/original.md'
                                  '\n\n### Notes\n\n1. <a id="note-law"></a>**Proved.** See [the record](theories/records/law.md). [↩](#ref-law)')

    def test_navigation_validation_reports_missing_opening(self):
        with patch.object(navigation, 'goals', return_value=[]), patch.object(navigation, 'read', return_value={'readme_opening': 'missing-opening.md'}):
            errors = navigation.validate_goals([])
        self.assertEqual(sum('missing file: missing-opening.md' in error for error in errors), 1)  # once, not again for the screen

    def test_root_places_the_first_screen_before_the_opening(self):
        site = {'ways_in': [{'path': 'a.md', 'label': 'The way in', 'group': 'Read'}]}
        config = {'readme_featured_results': ['first'], 'readme_first_screen': FIRST_SCREEN, 'readme_lead': LEAD,
                  'readme_status': 'Ongoing work.', 'site': site}
        def read(path):
            return config if path == navigation.CONFIG else {'documents': {}}
        with patch.object(navigation, 'read', side_effect=read), patch.object(navigation, 'goals', return_value=[]), \
                patch.object(navigation, 'readme_opening', return_value='## Truth exists\n\nOpening body.\n\n### Notes\n\n1. A note.'):
            views = navigation.render_views([result('first')])
        root = views['README.md']
        self.assertTrue(root.startswith('# The Theory of Becoming\n'))
        self.assertLess(root.index('[Home]'), root.index('> Ongoing work.'))
        screen, lead = 'A map of how anything forms', "The map's laws are checked in Lean"
        self.assertLess(root.index('> Ongoing work.'), root.index(screen))
        self.assertLess(root.index(screen), root.index('## Truth exists'))
        # the ways in stand between the screen and the rule above the opening
        ways = root.index('## Ways in')
        self.assertLess(root.index(screen), ways)
        self.assertLess(ways, root.index('| [The way in](a.md) |'))
        self.assertLess(root.index('| [The way in](a.md) |'), root.index('\n---\n', ways))
        self.assertLess(root.index('\n---\n', ways), root.index('## Truth exists'))
        self.assertLess(root.index('Opening body.'), root.index(lead))  # the lead follows the opening
        self.assertLess(root.index(lead), root.index('## What is established'))
        self.assertEqual(root.count(screen), 1)
        self.assertNotIn('{{', root)
        self.assertNotIn('Opening body.', views['_process/BRIEF.md'])

    def test_the_stated_time_counts_the_ways_in_table(self):
        site = {'ways_in': [{'path': 'a.md', 'label': 'word ' * 40, 'group': 'Read'} for _ in range(10)]}
        config = {'readme_first_screen': FIRST_SCREEN, 'site': site}
        def read(path):
            return config if path == navigation.CONFIG else {'documents': {}}
        with patch.object(navigation, 'read', side_effect=read), patch.object(navigation, 'goals', return_value=[]), \
                patch.object(navigation, 'readme_opening', return_value='## Truth exists\n\nOpening body.'):
            root = navigation.render_views([result('first')])['README.md']
        whole = root.split('\n---\n', 1)[0]  # README from its title to the rule above the opening
        without = whole.split('## Ways in', 1)[0]
        stated = re.search(r'^\*(.+?) to read\.\*$', root, flags=re.M).group(1)
        self.assertEqual(stated, navigation.reading_time(whole))
        self.assertNotEqual(stated, navigation.reading_time(without))

    def test_the_lean_package_is_linked_from_the_lead(self):
        self.assertIn('[the Lean package](MAP.md#check-the-proofs-yourself)', navigation.markdown_file('readme_lead', 'README.md'))


class FirstScreenTests(unittest.TestCase):
    """README's first screen: the readme_first_screen file with its fields filled at render (navigation.first_screen)."""
    OPENING = '## Truth exists\n\n' + 'word ' * 260 + '\n\n### Notes\n\n1. ' + 'note ' * 1300

    def screen(self, text, records=(), opening=None, above='', below=''):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'theories').mkdir()
            (root / 'theories/PAGE.md').write_text('page ' * 2154)
            (root / 'theories/GEN.md').write_text('<!-- Generated by tools/research/research.py render. -->\npage')
            (root / 'LEAD.md').write_text('<!-- For editors. -->\n' + text)
            return navigation.first_screen(list(records), self.OPENING if opening is None else opening,
                                           {'readme_first_screen': 'LEAD.md'}, root, above, below)

    def test_fields_are_filled_from_the_data(self):
        records = [result('a', 'recorded-checked'), result('b', 'recorded-checked'), result('c', 'open')]
        self.assertEqual(self.screen('{{count:registered}} results, {{count:recorded-checked}} with a receipt, {{count:open}} open.', records),
                         '3 results, 2 with a receipt, 1 open.')
        self.assertEqual(self.screen('[The page](theories/PAGE.md) ({{time:theories/PAGE.md}}).'),
                         '[The page](theories/PAGE.md) (17–22 minutes).')
        self.assertEqual(self.screen('The opening ({{time:opening}}), its notes ({{time:notes}}).'),
                         'The opening (2–3 minutes), its notes (10–13 minutes).')
        self.assertEqual(self.screen('This screen: {{time:screen}}.'), 'This screen: a minute.')
        self.assertEqual(self.screen('{{time:screen}}. ' + 'word ' * 300), '2–3 minutes. ' + ('word ' * 300).strip())
        # the whole screen is timed: the title, navigation and status above the file count
        self.assertEqual(self.screen('{{time:screen}}. ' + 'word ' * 100, above='# Title\n\n' + 'nav ' * 100), '2 minutes. ' + ('word ' * 100).strip())
        # and so do the ways in below the file, which stand before the opening's heading
        self.assertEqual(self.screen('{{time:screen}}. ' + 'word ' * 100, below='## Ways in\n\n| ' + 'cell ' * 100 + '|'), '2 minutes. ' + ('word ' * 100).strip())
        # as it renders, its own time filled in: 193 words and '2 minutes' time as 2 minutes (the field's own two words
        # would give 1–2); at 192 no time is right ('1–2 minutes' makes 195 words, 2 minutes; '2 minutes' 194, 1–2), so
        # the longer
        self.assertEqual(self.screen('{{time:screen}}. ' + 'word ' * 193), '2 minutes. ' + ('word ' * 193).strip())
        self.assertEqual(navigation.reading_time('word ' * 195), '2 minutes')
        self.assertEqual(self.screen('{{time:screen}}. ' + 'word ' * 192), '2 minutes. ' + ('word ' * 192).strip())

    def test_unknown_fields_and_missing_files_are_refused(self):
        for text, message in [('{{size:x}}', 'unknown field'), ('{{count:accepted}}', 'unknown status'),
                              ('{{time:theories/MISSING.md}}', 'missing file'), ('{{time:../outside.md}}', 'missing file'),
                              ('{{time:theories/GEN.md}}', 'page the render writes'), ('{{Time:screen}}', 'malformed field'),
                              ('{{ time:screen }}', 'malformed field')]:
            with self.subTest(text=text):
                with self.assertRaisesRegex(ValueError, message):
                    self.screen(text)
        with self.assertRaisesRegex(ValueError, 'does not have'):
            self.screen('{{time:notes}}', opening='## Truth exists\n\nNo notes.')

    def test_reading_time_counts_visible_prose_as_the_budgets_do(self):
        self.assertEqual(navigation.prose_counts('Two words <!-- hidden --> [a link](far/away.md) 中文'), (4, 2))
        self.assertEqual(navigation.prose_counts('```\ncode is not read\n```\nread'), (1, 0))
        self.assertEqual(navigation.reading_time('word ' * 1100), '8–11 minutes')  # ten minutes' budget
        self.assertEqual(navigation.reading_time('字' * 520), '2–3 minutes')  # a character counts half a word
        self.assertEqual(navigation.reading_time('word ' * 250), '2–3 minutes')  # 2.5 at the slow rate: halves round up

    def test_a_link_into_the_page_it_is_placed_in_stays_on_it(self):
        here, adapt = '_process/navigation/README-FIRST-SCREEN.md', navigation.adapt_links
        self.assertEqual(adapt('[o](../../README.md#truth-exists) [n](<../../README.md#a b>)', here, 'README.md'),
                         '[o](#truth-exists) [n](<#a b>)')
        # a link with a query or without a fragment, or the same link placed in another page, stays a path
        self.assertEqual(adapt('[q](../../README.md?x=1#a) [r](../../README.md)', here, 'README.md'), '[q](README.md?x=1#a) [r](README.md)')
        self.assertEqual(adapt('[o](../../README.md#truth-exists)', here, '_process/BRIEF.md'), '[o](../README.md#truth-exists)')

    def assert_making_said_once(self, text):
        """A front page names no person and says once, briefly, that the work was made with AI, never that no person has
        read it (Ren, 8 November 2026: sources/15-codex-theory-conversations/2026-11-08-ai-briefly-and-read.md). People and
        AI are the map's subject (AGENTS.md, 9 November 2026), so the screen may name AI as what the map is for, as many
        times as it says so; what it says once is the making, and no other label says who wrote, read or reviewed a part."""
        self.assertNotRegex(text, r'\b(Ren|Claude|Fable|astra|Codex|GPT)\b')
        self.assertEqual(len(re.findall(r'(?i)\bmade with AI\b', text)), 1)
        self.assertNotRegex(text, r'(?i)\bAI[- ](written|authored|generated|drafted|readings?|readers?|reviews?|reviewers?|translat\w*)\b'
                                  r'|\b(written|authored|drafted|generated|translated|read|reviewed|checked|made) (with|by) (an )?AI\b(?<!made with AI)')
        self.assertNotRegex(text, r'(?i)no human review|no person has (yet )?(read|reviewed)|no human has|nobody|no one has|not (been )?(reviewed|checked) by (a|any) person')

    def test_the_repository_first_screen_fills(self):
        # the real first screen: every field filled, no heading (the opening's ends the screen), and nothing of it
        # said again in the lead after the opening
        records = registry.load_records()[0]
        screen = navigation.first_screen(records, navigation.readme_opening())
        self.assertNotIn('{{', screen)
        self.assertNotIn('\n#', '\n' + screen)
        # the ethics as the fifth pass says it (Ren, 9 November 2026: "there is no warrant, ethics emerges from continuation
        # condition, not another way around, there is no any dualistic good or evil"): it emerges from continuation; where
        # relations close, holding one's own continuation orders courses as widening does (07 §4), proved on listed courses in
        # steps not yet joined; mixed courses weighed for no one; no warrant, no premises called unasserted, C not "better"
        self.assertIn('The ethics emerges from continuation.', screen)
        self.assertIn('no good and evil set over it', screen)
        self.assertIn('07-SIGNIFICANCE.md#r-self-concern-and-c-under-the-condition', screen)
        self.assertIn('in steps not yet joined into one theorem', screen)
        self.assertIn('the laws show it mixed and weigh it for no one', screen)
        for old in ('unasserted', 'not asserted', 'warrant', 'two readings', 'widening what can form is better', 'not a grounded one'):
            self.assertNotIn(old, screen)
        # the meta-attractor's closed form with the closed-capture record's hypotheses, not "proved to lock" alone
        self.assertNotIn('proved to lock', screen)
        self.assertIn('a locked start stays locked however large an unread loss grows', screen)
        # the aim as GOALS#generative-alignment and AJ's plan §1 state it, not the wording AJ5 replaced on 29 October
        # (it forbids accountable revision whose capacity is rewarded); the meta-attractor's closed form at 02 §9; and
        # whether a loss counts said as forming within becoming, not as a reading attached to neutral laws (07 §1)
        self.assertNotIn('control over its own selection', screen)
        self.assertIn("the rule still reads what lies beyond the shapers' share", screen)
        self.assertIn('02-MAP.md#r-closed-capture', screen)
        self.assertNotIn('not in the laws but in a reading', screen)
        self.assert_making_said_once(screen)
        self.assertIn('The work was made with AI', screen)
        self.assertIn('the person who directs it has read its important parts', screen)
        self.assertIn('no independent human review is recorded', screen)
        # and so does everything above the opening as README renders it: the title, the navigation and status lines
        above = re.sub(r'<!--.*?-->', '', (registry.ROOT / 'README.md').read_text().split('\n## Truth exists\n', 1)[0], flags=re.S)
        self.assert_making_said_once(above)
        lead = navigation.markdown_file('readme_lead', 'README.md')
        self.assertNotIn('is an account of', lead)
        self.assertNotIn('two premises', lead)
        self.assertNotIn('fixes scope', lead)

    def test_the_tests_fields_fill_from_the_rows_naming_a_thesis(self):
        rows = [{'thesis': 'T1', 'outcome': 'mixed'}, {'thesis': 'T2, T3', 'outcome': 'failed'}, {'thesis': 'T3', 'outcome': 'held'}, {'thesis': '', 'outcome': 'passed'},
                {'thesis': 'T4', 'outcome': 'dropped'}, {'thesis': 'T5', 'outcome': 'not-run'}, {'thesis': 'T6', 'outcome': 'refused'}, {'thesis': 'T7', 'outcome': 'not-rejected'}]
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            (root / 'theories/becoming/results/data').mkdir(parents=True)
            (root / 'theories/becoming/results/data/tests.json').write_text(json.dumps({'tests': rows}))
            (root / 'LEAD.md').write_text('{{tests:total}} {{tests:mixed}} {{tests:failed}} {{tests:passed}} {{tests:other}} {{tests:unrun}}')
            filled = navigation.first_screen([], 'x', {'readme_first_screen': 'LEAD.md'}, root)
            (root / 'LEAD.md').write_text('{{tests:nearly}}')
            with self.assertRaisesRegex(ValueError, 'readme_first_screen names an unknown count of tests'):
                navigation.first_screen([], 'x', {'readme_first_screen': 'LEAD.md'}, root)
            (root / 'LEAD.md').write_text('{{tests:total}}')
            (root / 'theories/becoming/results/data/tests.json').write_text('not json')
            with self.assertRaisesRegex(ValueError, r'^theories/becoming/results/data/tests\.json cannot be read'):  # the data named, not the screen
                navigation.first_screen([], 'x', {'readme_first_screen': 'LEAD.md'}, root)
        # seven name a thesis: held, dropped and not-run never ran, so 'other' is only the refused and the not rejected
        self.assertEqual(filled, '7 1 1 0 2 3')

    def test_the_repository_tests_fields_add_up_to_the_total(self):
        from tools.research import tests_page
        counts = tests_page.thesis_counts()
        with patch.object(navigation, 'markdown_file', return_value='{{tests:ran}} {{tests:unrun}} {{tests:other}}'):
            ran, unrun, other = [int(x) for x in navigation.first_screen([], 'x').split()]
        self.assertEqual(unrun, sum(counts.get(k, 0) for k in tests_page.NEVER_RAN))
        named = set(tests_page.CLASS_KEYS) - set(tests_page.NEVER_RAN) - {'passed', 'failed', 'mixed'}
        self.assertEqual(other, sum(counts.get(k, 0) for k in named))  # 'other' is the named classes that ran, nothing else
        self.assertGreaterEqual(other, 0)
        self.assertEqual(ran + unrun, counts['total'])

    def test_the_ways_in_table_follows_the_screen_from_the_sites_list(self):
        site = {'ways_in': [{'path': 'a.md', 'label': 'A', 'group': 'Read'}, {'path': 'b.md', 'label': 'B', 'group': 'Read'},
                            {'path': 'connections.html', 'label': 'Links', 'group': 'See'}]}
        table = navigation.ways_in_table({'site': site}, 'README.md')
        self.assertEqual(table[:4], ['## Ways in', '', '| Read | See |', '|---|---|'])
        self.assertEqual(table[4:6], ['| [A](a.md) | [Links](theories/becoming/results/atlas/CROSSWALK.md) |', '| [B](b.md) |  |'])
        self.assertEqual(navigation.ways_in_table({}, 'README.md'), [])

    def test_the_sites_home_stops_before_the_table(self):
        from tools.publishing import build_site
        readme = '# T\n\n> Status.\n\nThe screen.\n\n## Ways in\n\n| Read |\n|---|\n| [A](a.md) |\n\n---\n\n## Truth exists\n'
        self.assertEqual(build_site.first_screen(readme), '> Status.\n\nThe screen.')

    def test_the_repository_notes_are_told_from_the_body(self):
        # the opening's notes say once, just before them and naming no one, that they are written apart from its
        # first-person text: what an AI label on a reading would otherwise tell
        opening = navigation.readme_opening()
        body = opening.partition('\n### Notes\n')[0]
        last = body.rstrip().rsplit('\n\n', 1)[-1]
        self.assertIn('written apart from the first-person text', last)
        self.assertEqual(opening.count('written apart from'), 1)
        self.assertNotRegex(last, r'\b(AI|Ren|Claude)\b')


if __name__ == '__main__':
    unittest.main()
