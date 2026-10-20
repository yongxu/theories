"""The atlas refuses stale evidence instead of silently rebinding it."""
import hashlib
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest

SPEC = importlib.util.spec_from_file_location('atlas_build', Path(__file__).parents[1] / 'build.py')
builder = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(builder)
COMMIT = 'c' * 40


class EvidenceBindingTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.here = self.root / 'experiments/atlas'
        (self.here / 'model').mkdir(parents=True)
        (self.here / 'src').mkdir()
        self.source = self.here / 'model/Example.lean'
        self.source.write_text('-- literal </script> must not end the containing script\n')
        self.write_record()
        self.write_components([{'id': 'own', 'part': 1, 'path': 'experiments/atlas/model/Example.lean',
                                'line': 1, 'end': 1},
                               {'id': 'core', 'part': 0, 'path': 'Core.lean', 'commit': COMMIT,
                                'line': 1, 'end': 1, 'code': 'def core := 0'}])
        (self.here / 'src/page.fragment.html').write_text('<script type="application/json">__ATLAS_DATA__</script>')
        (self.here / 'src/learning.js').write_text('// fixture dynamics\n')
        (self.here / 'src/shell.html').write_text('<main><!--__ATLAS_FRAGMENT__--></main>')
        old = builder.ROOT, builder.HERE
        self.addCleanup(lambda: self.restore(old))
        builder.ROOT, builder.HERE = self.root, self.here

    def write_record(self, **changes):
        record = {'status': 'passed', 'axiom_dependencies': {}, 'checked_at_utc': 'fixture',
                  'lean_version': 'fixture', 'theorems': 1, 'declarations': 1,
                  'core': {'checked_against_commit': COMMIT},
                  'own_sha256': {'experiments/atlas/model/Example.lean':
                                 hashlib.sha256(self.source.read_bytes()).hexdigest()}}
        record.update(changes)
        (self.here / 'model/atlas-verification.json').write_text(json.dumps(record))

    def write_components(self, components):
        (self.here / 'components.json').write_text(json.dumps({'components': components}))

    @staticmethod
    def restore(old):
        builder.ROOT, builder.HERE = old

    def test_build_is_deterministic_and_raw_code_cannot_close_the_script(self):
        first = builder.build()
        self.assertEqual(first, builder.build())
        self.assertIn(r'<\/script>', first)
        self.assertNotIn('literal </script>', first)

    def test_changed_model_is_rejected(self):
        self.source.write_text('-- changed after the recorded check\n')
        with self.assertRaisesRegex(ValueError, 'Changed since verification'):
            builder.build()

    def test_reported_axioms_are_rejected(self):
        self.write_record(axiom_dependencies={'Example.claim': ['sorryAx']})
        with self.assertRaisesRegex(ValueError, 'not verified'):
            builder.build()

    def test_core_excerpt_from_another_commit_is_rejected(self):
        self.write_record(core={'checked_against_commit': 'd' * 40})
        with self.assertRaisesRegex(ValueError, 'another commit'):
            builder.build()

    def test_excerpt_from_unverified_file_is_rejected(self):
        (self.root / 'Other.lean').write_text('x\n')
        self.write_components([{'id': 'other', 'part': 1, 'path': 'Other.lean', 'line': 1, 'end': 1}])
        with self.assertRaisesRegex(ValueError, 'unverified file'):
            builder.build()


class RealCoreExcerptTests(unittest.TestCase):
    def test_core_excerpts_match_their_commit(self):
        import subprocess
        root = Path(__file__).resolve().parents[3]
        for c in json.loads((Path(__file__).parents[1] / 'components.json').read_text())['components']:
            if 'commit' not in c:
                continue
            shown = subprocess.run(['git', 'show', c['commit'] + ':' + c['path']], cwd=root,
                                   capture_output=True, text=True)
            if shown.returncode:
                self.skipTest('core commit not in this clone (shallow checkout)')
            self.assertEqual('\n'.join(shown.stdout.splitlines()[c['line'] - 1:c['end']]), c['code'], c['id'])


if __name__ == '__main__':
    unittest.main()
