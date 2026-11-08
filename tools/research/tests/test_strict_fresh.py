"""`check --strict-fresh`: a stale directory index fails the check only in strict mode."""
import unittest
from unittest.mock import patch

from tools.research import navigation, registry, research

# A generated index that does not exist, so it differs from what render would write.
STALE = 'tmp/__strict-fresh-test__/INDEX.md'


class StrictFreshTests(unittest.TestCase):
    def setUp(self):
        fronts = patch.object(navigation, 'validate_fronts', lambda records: [])  # these tests register no records
        fronts.start()
        self.addCleanup(fronts.stop)

    def run_check(self, strict_fresh):
        register = (registry.OUT / 'RESULT-REGISTER.md').relative_to(research.ROOT)
        calls = []

        def index_outputs(render=False):
            calls.append(render)
            return {STALE: 'what render would write\n'}, [], []

        with patch.object(research, 'input_snapshot', lambda: None), \
                patch.object(research, 'unchanged_inputs', lambda before: True), \
                patch.object(research, 'index_outputs', index_outputs), \
                patch.object(research, 'check_links', lambda outputs, planned=(): []), \
                patch.object(registry, 'load_records', lambda: ([], [])), \
                patch.object(registry, 'validate', lambda records: ([], [])), \
                patch.object(registry, 'orphan_pages', lambda records: []), \
                patch.object(registry, 'render_index', lambda records: (research.ROOT / register).read_text()), \
                patch.object(navigation, 'validate_goals', lambda records: []), \
                patch.object(navigation, 'validate_history', lambda: []), \
                patch.object(navigation, 'render_views', lambda records: {}), \
                patch.object(research.theory_graph, 'render', lambda records: {}), \
                patch.object(research.atlas, 'render', lambda records: ({}, [])), \
                patch.multiple(research.zh_fronts, render=lambda records, outputs: ({}, []), write_banners=lambda: ([], []),
                               banner_problems=lambda: []), \
                patch.object(research.mirror, 'render', lambda: ({}, [])):
            code, result = research.check_or_render(False, strict_fresh=strict_fresh)
        return code, result, calls

    def test_default_reports_a_stale_index_without_failing(self):
        code, result, calls = self.run_check(False)
        self.assertEqual(code, 0)
        self.assertEqual(result['errors'], [])
        self.assertEqual(result['stale_indexes'], [STALE])
        self.assertEqual(calls, [False])  # the Lean catalogue is left to its own check

    def test_strict_fails_on_a_stale_index_and_compares_the_lean_catalogue(self):
        code, result, calls = self.run_check(True)
        self.assertEqual(code, 1)
        self.assertEqual(result['stale_indexes'], [STALE])
        self.assertEqual(len(result['errors']), 1)
        self.assertIn('--strict-fresh', result['errors'][0])
        self.assertTrue(result['errors'][0].endswith(STALE))
        self.assertEqual(calls, [True])

    def test_one_render_settles_the_lean_catalogue(self):
        # The catalogue reads links in pages the same render writes (README), so render
        # compares it once more after writing and writes what changed.
        register = (registry.OUT / 'RESULT-REGISTER.md').relative_to(research.ROOT)
        catalogue = {'tmp/__strict-fresh-test__/source-index.json': '{"after": "the first write"}\n'}
        writes = []

        def write_views(outputs, initial=None):
            writes.append(dict(outputs))
            return []

        index = {'tmp/__strict-fresh-test__/INDEX.md': 'counts a page the first write added\n'}
        for later, counted, expected, found in [(catalogue, {}, 2, []), ({}, {}, 1, []), (catalogue, {}, 1, ['x.md: a page the catalogue no longer writes']),
                                                ({}, index, 2, [])]:
            writes.clear()
            with patch.object(research, 'input_snapshot', lambda: None), \
                    patch.object(research, 'unchanged_inputs', lambda before: True), \
                    patch.object(research, 'index_outputs', lambda render=False: ({}, [], [])), \
                    patch.object(research, 'check_links', lambda outputs, planned=(): []), \
                    patch.object(research.indexes, 'adopted', lambda: {}), \
                    patch.object(research.indexes, 'render', lambda: counted), \
                    patch.object(research.lean_catalogue, 'render', lambda: later), \
                    patch.object(research.lean_catalogue, 'problems', lambda files: found), \
                    patch.object(registry, 'load_records', lambda: ([], [])), \
                    patch.object(registry, 'validate', lambda records: ([], [])), \
                    patch.object(registry, 'orphan_pages', lambda records: []), \
                    patch.object(registry, 'render_index', lambda records: (research.ROOT / register).read_text()), \
                    patch.object(navigation, 'validate_goals', lambda records: []), \
                    patch.object(navigation, 'validate_history', lambda: []), \
                    patch.object(navigation, 'render_views', lambda records: {}), \
                    patch.object(research.atlas, 'render', lambda records: ({}, [])), \
                    patch.multiple(research.zh_fronts, render=lambda records, outputs: ({}, []), write_banners=lambda: ([], []),
                                   banner_problems=lambda: []), \
                    patch.object(research.mirror, 'render', lambda: ({}, [])), \
                    patch.object(navigation, 'write_views', write_views):
                code, result = research.check_or_render(True)
            self.assertEqual(result['errors'], ['lean catalogue: ' + e for e in found])  # a problem on the second pass writes nothing more
            self.assertEqual(len(writes), expected)
            if expected == 2:
                self.assertEqual(writes[1], {**later, **counted})

    def test_the_flag_belongs_to_check_only(self):
        with patch('sys.argv', ['research.py', 'render', '--strict-fresh']), \
                patch('sys.stderr'), self.assertRaises(SystemExit):
            research.main()


if __name__ == '__main__':
    unittest.main()
