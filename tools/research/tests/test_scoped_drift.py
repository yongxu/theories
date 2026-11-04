"""A reviewed Markdown source that changed only outside what a record cites keeps the review;
one changed where the record is cited, or not found in history, drifts. Runs in a scratch
git repository; nothing in this checkout is changed."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from tools.research import registry

STUDY = '''# Study

Intro.

## 1. First

Line about [one](results/records/one.md).

Other line.

## 2. Second

Line about [two](results/records/two.md).
'''


class ScopedDriftTests(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.TemporaryDirectory()
        self.root = Path(self.dir.name)
        self.cache = self.root / 'cache.json'
        git = lambda *a: subprocess.run(['git', *a], cwd=self.root, check=True, capture_output=True)
        self.git = git
        git('init', '-q')
        git('config', 'user.email', 't@t')
        git('config', 'user.name', 't')
        self.path = 'study.md'
        self.write(STUDY)
        git('add', '.')
        git('commit', '-qm', 'reviewed')
        self.reviewed = registry.digest(self.root / self.path)
        self.comparisons = self.root / 'comparisons'
        self.patches = [patch.object(registry, 'ROOT', self.root), patch.object(registry, 'VERSION_CACHE', self.cache),
                        patch.object(registry, 'DRIFT_CACHE', self.comparisons)]
        for p in self.patches:
            p.start()
        registry._versions.clear()
        registry._comparisons.clear()

    def tearDown(self):
        for p in self.patches:
            p.stop()
        registry._versions.clear()
        registry._comparisons.clear()
        self.dir.cleanup()

    def write(self, text):
        (self.root / self.path).write_text(text)

    def drift(self, ident, text, record=None):
        self.write(text)
        return registry.scoped_drift(record or {'id': ident}, self.path, self.reviewed, self.root / self.path)

    def test_unchanged_review_survives_added_sections(self):
        self.assertIsNone(self.drift('one', STUDY + '\n## 3. Third\n\nNew [one](results/records/one.md).\n'))

    def test_rewrite_elsewhere_keeps_the_review(self):
        changed = STUDY.replace('Line about [two]', 'Rewritten line about [two]')
        self.assertIsNone(self.drift('one', changed))
        self.assertEqual(self.drift('two', changed), ['## 2. Second'])

    def test_rewrite_of_a_cited_anchor_section_drifts(self):
        changed = STUDY.replace('Other line.', 'Other line, changed.')
        record = {'id': 'three', 'progress': [{'source': 'study.md#1-first'}]}
        self.assertEqual(self.drift('three', changed, record), ['## 1. First'])
        self.assertIsNone(self.drift('one', changed))

    def test_unlocated_record_drifts_on_any_rewrite(self):
        changed = STUDY.replace('Other line.', 'Other line, changed.')
        self.assertEqual(self.drift('elsewhere', changed), ['## 1. First'])

    def test_renamed_record_is_located_by_its_former_id(self):
        changed = STUDY.replace('Other line.', 'Other line, changed.')
        renamed = {'id': 'one-renamed', 'former_ids': ['one']}
        self.assertIsNone(self.drift('one-renamed', changed, renamed))
        registry._comparisons.clear()
        relinked = STUDY.replace('records/one.md', 'records/one-renamed.md')
        self.assertEqual(self.drift('one-renamed', relinked, renamed), ['## 1. First'])

    def test_rewrite_before_first_heading_bears_on_every_record(self):
        self.assertEqual(self.drift('one', STUDY.replace('Intro.', 'Intro, changed.')), ['(before the first heading)'])

    def test_reviewed_version_must_be_in_history(self):
        self.reviewed = '0' * 64
        self.assertEqual(self.drift('one', STUDY + 'x\n'), ['(reviewed version not in history)'])

    def test_non_markdown_needs_exact_bytes(self):
        self.assertEqual(registry.scoped_drift({'id': 'one'}, 'Proof.lean', self.reviewed, self.root / self.path),
                         ['(not Markdown: exact bytes required)'])

    def test_cached_comparison_gives_the_same_result(self):
        changed = STUDY.replace('Line about [two]', 'Rewritten line about [two]').replace('Intro.', 'Intro, changed.')
        cold = registry.changed_lines(self.path, self.reviewed, changed)
        self.assertEqual(len(list(self.comparisons.rglob('*.json'))), 1)
        registry._comparisons.clear()
        with patch('difflib.SequenceMatcher.get_opcodes', side_effect=AssertionError('compared again')):
            self.assertEqual(registry.changed_lines(self.path, self.reviewed, changed), cold)
            self.assertEqual(self.drift('two', changed), ['## 2. Second', '(before the first heading)'])

    def test_unreadable_or_unfitting_cache_entry_is_compared_again(self):
        changed = STUDY.replace('Other line.', 'Other line, changed.')
        expected = self.drift('elsewhere', changed)
        entry, = self.comparisons.rglob('*.json')
        for broken in ('[["delete", 2, 3', '{}', '[["delete", 0, 99, 0, 0]]', '[["delete", 1.0, 2, 1, 1]]', '[["insert", 1, 2, 1, 1]]'):
            with self.subTest(broken=broken):
                entry.write_text(broken)
                registry._comparisons.clear()
                self.assertEqual(self.drift('elsewhere', changed), expected)
                self.assertNotEqual(entry.read_text(), broken)

    def test_unwritable_cache_is_ignored(self):
        changed = STUDY.replace('Line about [two]', 'Rewritten line about [two]')
        expected = self.drift('two', changed)
        registry._comparisons.clear()
        with patch.object(registry, 'DRIFT_CACHE', self.root / self.path / 'under-a-file'):
            self.assertEqual(self.drift('two', changed), expected)


class SourcesTests(unittest.TestCase):
    def test_scan_agrees_with_declaration_in_source(self):
        cases = [
            ('namespace Becoming.Expansion\ninstance kind_decided : DecidableEq Kind := by decide\n', 'Becoming.Expansion.kind_decided'),
            ('@[reducible] private instance (priority := 100) kind_decided : DecidableEq Kind := by decide\n', 'X.kind_decided'),
            ('instance (priority := low)\n  kind_decided [Inhabited Kind] : DecidableEq Kind := by decide\n', 'X.kind_decided'),
            ('instance (kind_decided : Type) : Inhabited kind_decided := by infer_instance\n', 'X.kind_decided'),
            ('instance kind_decided_other : DecidableEq Kind := by decide\n', 'X.kind_decided'),
            ('protected theorem Run.reach (h : True) : True := h', 'Becoming.Run.reach'),
            ("def Example.value' : Nat := 0", "Example.value'"),
            ("def Example.value' : Nat := 0", 'Example.value'),
        ]
        with tempfile.TemporaryDirectory() as d:
            for i, (text, name) in enumerate(cases):
                p = Path(d) / f'{i}.lean'
                p.write_text(text)
                with self.subTest(text=text, name=name):
                    self.assertEqual(registry.Sources().declares(p, name), registry.declaration_in_source(text, name))


class ScrubTests(unittest.TestCase):
    """Expected outputs fixed from the character-by-character scrubber this one replaced."""
    def test_blanks_comments_and_strings_keeping_offsets(self):
        from tools.research.lean_catalogue import scrub
        for source, expected in [('"a\\"b" x', '       x'), ('/- /- -/ -/ y', '            y'), ('-- c\nz', '    \nz'), ('"\\\n"', '  \n '), ('/- unclosed', '           '), ('"unclosed', '         '), ('a"\\', 'a  '), ('x--', 'x  '), ('/-', '  '), ('"\\', '  '), ('theorem t : "s" = "s" := rfl -- done\n/-! doc /- nested -/ -/\ndef x := 1', 'theorem t :     =     := rfl        \n                       \ndef x := 1')]:
            with self.subTest(source=source):
                self.assertEqual(scrub(source), expected)

    def test_completion_strips_comments_as_before(self):
        """Expected outputs fixed from the character-by-character scan `_strip_comments` replaced."""
        from tools.research.completion import _strip_comments
        for source, expected in [('theorem t : "--" = x -- done\nz', 'theorem t : "--" = x        \nz'), ('"a\\"b -- c" d', '"a\\"b -- c" d'),
                                 ('a\'"b -- c\nd', 'a\'"b     \nd'), ('/- /- -/ -/ y', '            y'), ('/--/x', '    x'),
                                 ('/- "-/" -/ z', '      " -/ z'), ('/-! doc\n  more -/\ndef x', '       \n         \ndef x'),
                                 ('/- unclosed\nz', '           \n '), ('"unclosed -- x', '"unclosed -- x'), ('x-', 'x-'), ('', '')]:
            with self.subTest(source=source):
                self.assertEqual(_strip_comments(source), expected)


if __name__ == '__main__':
    unittest.main()
