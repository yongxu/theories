"""One register, short stubs that keep their anchors, a compact dependency page and scope states."""
import unittest
from unittest.mock import patch

from tools.research import navigation, registry
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
