"""The landing gate (gate.py) against what it promises, on throwaway repositories. A landing runs the checks its
changed paths reach, and a path outside every area reaches all of them; a rule naming what the tree lacks stops the
gate. A pass is kept for a clean tree after exit 0, under its check, environment and checker code, and reused on the
same tree or across an ancestor whose diff reaches nothing the check reads, never across a commit that does not
descend from it. Heavy runs queue for the machine's slots and a twin is refused. The gate's own checks guard the
board's Queue line and the freezes, and `restated` lists the live lines linking a home section or record the change
rewrote. A test marked expectedFailure names a place where gate.py breaks that promise; it is left for its owner."""
import functools
import hashlib
import io
import json
import os
from pathlib import Path
import select
import subprocess
import sys
import tempfile
import threading
import time
import unittest
from unittest import mock

from tools.research import gate, paths

REPOSITORY = Path(gate.__file__).resolve().parents[2]
PEOPLE = {'GIT_AUTHOR_NAME': 'Test', 'GIT_AUTHOR_EMAIL': 'test@example.invalid',
          'GIT_COMMITTER_NAME': 'Test', 'GIT_COMMITTER_EMAIL': 'test@example.invalid'}
CONFIG = {'record_directories': ['theories/becoming/results/records']}
CACHED = ('files_at', 'manifests', 'pins', 'frozen_paths', 'quoted_paths', 'timed_paths', 'registry_sources',
          'draft_paths', 'review_reads')
PROBE = 'experiments/probe.py'


def clear_caches():
    """gate caches what it reads of a tree; a test moves HEAD and changes repository, so it clears them each time."""
    for name in CACHED:
        cached = getattr(gate, name, None)
        if hasattr(cached, 'cache_clear'):
            cached.cache_clear()


def sha(text):
    return hashlib.sha256(text.encode()).hexdigest()


def three(command=lambda name: (sys.executable, '-c', 'pass')):
    """Two checks reading one area each, and one reading every Markdown page that any addition or deletion reaches."""
    return (gate.Check('drafts', command('drafts'), ('drafts/**',)),
            gate.Check('tools', command('tools'), ('tools/**',)),
            gate.Check('pages', command('pages'), ('**/*.md',), added=True))


def strict(command=(sys.executable, '-c', 'pass')):
    """A check shaped like the strict one: every path, except modifications of the tests and of a board whose
    headings stay; the render follows it."""
    return gate.Check('strict', command, ('**',), added=True, unread=('tools/research/tests/**',),
                      unread_when=((gate.BOARD, 'same_headings'),))


TEST_FILE = 'tools/research/tests/test_x.py'
SMALL_BOARD = '# Board\n\n## Now\n\nA row.\n'


class Repo:
    """A throwaway repository whose first commit, on main, holds `files` ({path: text}; None deletes a path)."""

    def __init__(self, root: Path, files: dict):
        self.root = root
        root.mkdir()
        self.git('init', '-q', '-b', 'main')
        self.commit(files, 'base')

    def git(self, *args):
        try:
            return subprocess.run(['git', *args], cwd=self.root, check=True, stdout=subprocess.PIPE,
                                  stderr=subprocess.PIPE, text=True).stdout
        finally:
            clear_caches()

    def write(self, files):
        for name, body in files.items():
            p = self.root / name
            if body is None:
                p.unlink()
            else:
                p.parent.mkdir(parents=True, exist_ok=True)
                p.write_text(body)
        clear_caches()

    def commit(self, files, message='step'):
        self.write(files)
        self.git('add', '-A')
        self.git('commit', '-q', '-m', message)
        return self.head()

    def head(self):
        return self.git('rev-parse', 'HEAD').strip()

    def tree(self, rev='HEAD'):
        return self.git('rev-parse', rev + '^{tree}').strip()

    def short(self, rev):
        return self.git('rev-parse', '--short', rev).strip()

    def branch(self, name, start='main'):
        self.git('checkout', '-q', '-b', name, start)

    def descends(self, rev):
        return subprocess.run(['git', 'merge-base', '--is-ancestor', rev, 'HEAD'], cwd=self.root).returncode == 0


class GateCase(unittest.TestCase):
    """Each test has its own repository on branch `work` off main, its own gate directory and git configuration, and
    the module pointed at them; nothing is written under the real repository or its git directory."""
    FILES = {'drafts/a.md': '# A\n', 'drafts/b.md': '# B\n', 'drafts/名 b.md': '# 名\n', 'tools/x.py': 'x = 1\n',
             'README.txt': 'top\n', 'experiments/data.csv': '1\n', 'newarea/f.txt': 'f\n', TEST_FILE: 'pass\n',
             PROBE: "import os\nopen(os.environ['PROBE_NOTE'], 'a').write('x')\n"}

    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.tmp = Path(temporary.name).resolve()
        (self.tmp / 'gitconfig').write_text('')
        env = {k: v for k, v in os.environ.items() if not k.startswith(('GIT_', 'GATE_'))}
        env.update(PEOPLE, GIT_CONFIG_GLOBAL=str(self.tmp / 'gitconfig'), GIT_CONFIG_NOSYSTEM='1',
                   GATE_DIR=str(self.tmp / 'gate'), GATE_SLOTS='2', GATE_IN_SHARED_CHECKOUT='1',
                   PROBE_NOTE=str(self.tmp / 'ran-probe'))
        self.patch(mock.patch.dict(os.environ, env, clear=True))
        clear_caches()
        self.addCleanup(clear_caches)
        self.repo = Repo(self.tmp / 'repo', self.FILES)
        self.repo.branch('work')
        root = self.repo.root
        self.patch(mock.patch.object(gate, 'ROOT', root))
        self.patch(mock.patch.object(paths, 'role', lambda p: paths.Classifier(settings=CONFIG, root=root).role(p)))

    def patch(self, patcher):
        patcher.start()
        self.addCleanup(patcher.stop)

    def on_main(self, files):
        """Move main (as a commit made there outside this landing would), and start `work` again from it."""
        self.repo.git('checkout', '-q', 'main')
        self.repo.commit(files, 'on main')
        self.fresh()

    def fresh(self):
        self.repo.git('checkout', '-q', '-B', 'work', 'main')

    def counting(self, name, code=0):
        """A command that notes each run in a file outside the repository, then exits with `code`."""
        note = self.tmp / f'ran-{name}'
        return (sys.executable, '-c', f'import sys; open({str(note)!r}, "a").write("x"); sys.exit({code})')

    def runs(self, name):
        note = self.tmp / f'ran-{name}'
        return len(note.read_text()) if note.exists() else 0

    def gate_run(self, **kw):
        kw.setdefault('checks', three(self.counting))
        return gate.run('main', **kw)

    @staticmethod
    def status(out):
        return {n: r['status'] for n, r in out['results'].items()}

    def kept(self, name):
        return [json.loads(p.read_text()) for p in (self.tmp / 'gate' / 'passes').glob(f'{name}-*/*.json')]


class SelectionTests(GateCase):
    def selected(self, checks=None):
        return set(gate.plan('main', checks=checks or three())['selected'])

    def test_a_check_is_selected_only_by_a_path_it_reads(self):
        self.repo.commit({'tools/x.py': 'x = 2\n'})
        plan = gate.plan('main', checks=three())
        self.assertEqual(set(plan['selected']), {'tools'})
        self.assertEqual(plan['selected']['tools']['paths'], ['tools/x.py'])
        self.assertEqual(sorted(plan['skipped']), ['drafts', 'pages'])

    def test_a_changed_page_selects_each_check_reading_it(self):
        self.repo.commit({'drafts/名 b.md': '# 名, changed\n'})
        plan = gate.plan('main', checks=three())
        self.assertEqual(set(plan['selected']), {'drafts', 'pages'})
        self.assertEqual(plan['selected']['pages']['paths'], ['drafts/名 b.md'])

    def test_a_literal_read_is_reached_by_that_path_alone(self):
        one = (gate.Check('one', (sys.executable, '-c', 'pass'), ('drafts/a.md',)),)
        self.repo.commit({'drafts/b.md': '# B, changed\n'})
        self.assertEqual(self.selected(one), set())
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        self.assertEqual(self.selected(one), {'one'})

    def test_an_added_or_deleted_path_reaches_the_checks_marked_added(self):
        self.repo.commit({'experiments/new.csv': '2\n'}, 'add a file no check reads')
        self.assertEqual(self.selected(), {'pages'})
        self.repo.branch('deleting')
        self.repo.commit({'tools/x.py': None}, 'delete')
        self.assertEqual(self.selected(), {'tools', 'pages'})
        self.repo.branch('modifying')
        self.repo.commit({'experiments/data.csv': '2\n'}, 'modify a file no check reads')
        self.assertEqual(self.selected(), set())

    def test_a_path_outside_every_area_selects_every_check(self):
        self.repo.commit({'newarea/f.txt': 'g\n'})  # modified, not added: only its being unplaced can select
        plan = gate.plan('main', checks=three())
        self.assertEqual(set(plan['selected']), {'drafts', 'tools', 'pages'})
        self.assertEqual(plan['unplaced'], ['newarea/f.txt'])
        self.assertEqual([s['step'] for s in plan['before_the_gate']], ['core run', 'shared laws'])  # no strict check to render for
        plan = gate.plan('main', checks=three() + (strict(),))
        self.assertEqual(set(plan['selected']), {'drafts', 'tools', 'pages', 'strict'})
        self.assertEqual([s['step'] for s in plan['before_the_gate']], ['core run', 'shared laws', 'render'])

    def test_a_top_level_file_is_placed(self):
        self.repo.commit({'README.txt': 'changed\n'})
        plan = gate.plan('main', checks=three())
        self.assertEqual((plan['unplaced'], plan['selected']), ([], {}))

    def test_the_steps_before_the_gate_are_listed_when_reached_and_run_in_a_slot(self):
        def steps():
            return [s['step'] for s in gate.plan('main', checks=three() + (strict(),))['before_the_gate']]
        self.assertEqual(steps(), [])
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        self.assertEqual(steps(), ['render'])  # the render follows the strict check
        self.repo.commit({gate.BECOMING + '/Becoming/New.lean': 'theorem t : True := trivial\n'})
        self.assertEqual(steps(), ['core run', 'shared laws', 'render'])  # the shared laws follow a change to the Lean
        self.fresh()
        self.repo.commit({TEST_FILE: 'pass  # changed\n'})  # a modification the strict check never reads
        self.assertEqual(steps(), [])
        self.assertTrue(all('gate.py hold -- ' in s.command for s in gate.STEPS))

    def test_a_modification_the_check_never_reads_does_not_select_it(self):
        self.repo.commit({TEST_FILE: 'pass  # changed\n'})
        self.assertEqual(self.selected((strict(),)), set())
        self.fresh()
        self.repo.commit({'tools/research/tests/test_new.py': 'pass\n'})  # an addition it reads
        self.assertEqual(self.selected((strict(),)), {'strict'})

    def test_a_board_change_that_keeps_its_headings_is_not_read_by_the_strict_check(self):
        self.on_main({gate.BOARD: SMALL_BOARD})
        self.repo.commit({gate.BOARD: SMALL_BOARD.replace('A row.', 'A row, changed.')})
        self.assertEqual(self.selected((strict(),)), set())
        self.fresh()
        self.repo.commit({gate.BOARD: SMALL_BOARD.replace('## Now', '## Later')})
        self.assertEqual(self.selected((strict(),)), {'strict'})

    def test_an_optional_read_watches_for_a_path_that_may_appear(self):
        optional = (gate.Check('optional', (sys.executable, '-c', 'pass'), ('?drafts/maybe.md',)),)
        self.assertEqual(gate.plan('main', checks=optional)['stale_rules'], [])
        self.repo.commit({'drafts/maybe.md': 'here\n'})
        self.assertEqual(self.selected(optional), {'optional'})

    def test_the_landing_is_its_own_changes_from_the_merge_base(self):
        self.repo.git('checkout', '-q', 'main')
        self.repo.commit({'tools/x.py': 'x = 3\n'}, 'main moves')
        self.repo.git('checkout', '-q', 'work')
        self.repo.commit({'drafts/a.md': '# A, changed\n'}, 'the landing')
        self.assertEqual(self.selected(), {'drafts', 'pages'})

    def test_a_board_only_change_is_marked(self):
        self.repo.commit({gate.BOARD: 'a board\n'})
        self.assertTrue(gate.plan('main', checks=three())['board_only'])
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        self.assertFalse(gate.plan('main', checks=three())['board_only'])

    def test_a_dossiers_quotations_are_read(self):
        self.on_main({gate.REVIEW + '/D.md': 'Quote [experiments/data.csv]: "1"\n引〔drafts/b.md〕：「too」\nSource [MJ-S-001]: "a unit, not a file"\n'})
        quoting = (gate.Check('quotes', (sys.executable, '-c', 'pass'), (), derived='quoted_paths'),)
        for path, reached in (('experiments/data.csv', True), ('drafts/b.md', True), ('drafts/a.md', False)):
            with self.subTest(path):
                self.fresh()
                self.repo.commit({path: 'changed\n'})
                self.assertEqual(self.selected(quoting), {'quotes'} if reached else set())

    def test_a_rule_naming_what_the_tree_lacks_stops_the_gate(self):
        stale = (gate.Check('literal', (sys.executable, '-c', 'pass'), ('drafts/missing.md',)),
                 gate.Check('glob', (sys.executable, '-c', 'pass'), ('nowhere/**',)),
                 gate.Check('script', (sys.executable, '-B', 'experiments/gone.py'), ('drafts/**',)))
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        found = gate.plan('main', checks=stale)['stale_rules']
        self.assertEqual([s.split(':')[0] for s in found], ['literal', 'glob', 'script'], found)
        code, out = gate.run('main', checks=stale)
        self.assertEqual(code, 1)
        self.assertNotIn('results', out)
        self.assertEqual(out['errors'][1:], found)

    def test_a_pattern_argument_is_not_a_script(self):
        suite = gate.Check('suite', (sys.executable, '-B', '-m', 'unittest', 'discover', '-s', 'drafts', '-p', 'test_*.py'),
                           ('drafts/**',))
        self.assertIsNone(gate.script_of(suite))
        self.assertEqual(gate.script_of(gate.Check('probe', (sys.executable, '-B', PROBE), ('drafts/**',))), PROBE)
        self.assertEqual(gate.plan('main', checks=(suite,))['stale_rules'], [])

    def test_a_change_to_a_checks_own_script_selects_it(self):
        # Bug: selection (gate.py reached(), lines 346-351) reads only `reads`, while code_hash (line 404) admits the
        # check's script and tools/research as inputs of its result. A landing that changes only a checker is
        # therefore never checked by it: in the real table, a change to tools/research/gate.py selects neither
        # `board` nor `frozen`, whose commands are gate.py. The pass key keeps a stale pass from being reused; it does
        # not make the changed checker run.
        self.repo.commit({PROBE: 'raise SystemExit(1)\n'})
        probe = (gate.Check('probe', (sys.executable, '-B', PROBE), ('drafts/**',)),)
        self.assertEqual(self.selected(probe), {'probe'})

    def test_a_train_names_the_landings_whose_change_reaches_each_check(self):
        # Bug: plan(train=...) (gate.py line 393) diffs each branch from base_commit(b), the merge base of b and HEAD.
        # On the train's merged commit every landing is an ancestor of HEAD, so that merge base is b itself, the diff
        # is empty and every `landings` list is empty. It should diff from the merge base of `base` and b.
        self.repo.branch('t1')
        self.repo.commit({'drafts/a.md': '# A, by t1\n'}, 't1')
        self.repo.branch('t2')
        self.repo.commit({'tools/x.py': 'x = 9\n'}, 't2')
        self.repo.branch('train')
        self.repo.git('merge', '-q', '--no-ff', '-m', 'the train', 't1', 't2')
        selected = gate.plan('main', checks=three(), train=['t1', 't2'])['selected']
        self.assertEqual({n: s['landings'] for n, s in selected.items()},
                         {'drafts': ['t1'], 'tools': ['t2'], 'pages': ['t1']})


class PassTests(GateCase):
    def test_a_pass_is_kept_and_reused_on_the_same_tree(self):
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        code, out = self.gate_run()
        self.assertEqual(code, 0, out)
        self.assertEqual(self.status(out), {'drafts': 'passed', 'pages': 'passed'})
        [entry] = self.kept('drafts')
        self.assertEqual((entry['tree'], entry['commit']), (self.repo.tree(), self.repo.head()))
        code, out = self.gate_run()
        self.assertEqual(code, 0, out)
        self.assertEqual(self.status(out), {'drafts': 'reused', 'pages': 'reused'})
        self.assertEqual(out['results']['drafts']['from'], self.repo.tree()[:12])
        self.assertEqual((self.runs('drafts'), self.runs('pages'), self.runs('tools')), (1, 1, 0))

    def test_a_pass_is_reused_on_the_same_tree_under_a_descendant(self):
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        self.gate_run()
        self.repo.git('commit', '-q', '--allow-empty', '-m', 'the same tree, one commit on')
        code, out = self.gate_run()
        self.assertEqual(self.status(out), {'drafts': 'reused', 'pages': 'reused'})
        self.assertEqual(out['results']['drafts']['from'], self.repo.tree()[:12])

    def test_a_pass_is_not_reused_on_the_same_tree_under_a_commit_that_does_not_descend_from_it(self):
        # The drift check reads history, so the same tree under another history is not the same input.
        first = self.repo.commit({'drafts/a.md': '# A, changed\n'}, 'on work')
        self.gate_run()
        self.repo.branch('other')
        self.repo.commit({'drafts/a.md': '# A, changed\n'}, 'the same change, another commit')
        self.assertEqual(self.repo.tree(), self.repo.tree(first))
        self.assertFalse(self.repo.descends(first))
        code, out = self.gate_run()
        self.assertEqual(self.status(out), {'drafts': 'passed', 'pages': 'passed'})
        self.assertEqual(self.runs('drafts'), 2)

    def test_a_pass_is_reused_across_a_modification_the_check_never_reads(self):
        self.on_main({gate.BOARD: SMALL_BOARD})
        checks = (strict(self.counting('strict')),)
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        self.assertEqual(self.status(self.gate_run(checks=checks)[1]), {'strict': 'passed'})
        self.repo.commit({gate.BOARD: SMALL_BOARD.replace('A row.', 'A row, changed.')})
        self.assertEqual(self.status(self.gate_run(checks=checks)[1]), {'strict': 'reused'})
        self.repo.commit({gate.BOARD: SMALL_BOARD.replace('## Now', '## Later')})
        self.assertEqual(self.status(self.gate_run(checks=checks)[1]), {'strict': 'passed'})
        self.assertEqual(self.runs('strict'), 2)

    def test_an_ignored_lean_file_makes_the_tree_dirty(self):
        self.repo.commit({'.gitignore': 'ignored/\n.lake/\n', 'drafts/a.md': '# A, changed\n'})
        self.repo.write({'experiments/ignored/A.lean': 'x\n', 'experiments/.lake/B.lean': 'x\n'})
        code, out = self.gate_run()
        self.assertEqual(code, 1, out)
        self.assertIn('!! experiments/ignored/A.lean', out['errors'])
        self.assertFalse(any('.lake' in e for e in out['errors']), out)
        self.assertEqual(self.runs('drafts'), 0)

    def test_a_pass_is_reused_across_an_ancestor_whose_diff_reaches_nothing_the_check_reads(self):
        passed = self.repo.commit({'drafts/a.md': '# A, changed\n'}, 'drafts')
        self.gate_run()
        self.repo.commit({'tools/x.py': 'x = 2\n'}, 'tools')
        code, out = self.gate_run()
        self.assertEqual(code, 0, out)
        self.assertEqual(self.status(out), {'drafts': 'reused', 'pages': 'reused', 'tools': 'passed'})
        self.assertEqual(out['results']['drafts']['from'], self.repo.short(passed))
        self.assertEqual((self.runs('drafts'), self.runs('pages'), self.runs('tools')), (1, 1, 1))

    def test_a_pass_is_not_reused_when_the_diff_from_it_reaches_the_check(self):
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        self.gate_run()
        self.repo.commit({'drafts/b.md': '# B, changed\n'})
        code, out = self.gate_run()
        self.assertEqual(self.status(out), {'drafts': 'passed', 'pages': 'passed'})
        self.assertEqual((self.runs('drafts'), self.runs('pages')), (2, 2))

    def test_an_added_or_deleted_path_reaches_an_added_check_across_an_ancestor(self):
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        self.gate_run()
        self.repo.commit({'experiments/new.csv': '2\n'})
        self.assertEqual(self.status(self.gate_run()[1]), {'drafts': 'reused', 'pages': 'passed'})
        self.repo.commit({'experiments/data.csv': None})
        self.assertEqual(self.status(self.gate_run()[1]), {'drafts': 'reused', 'pages': 'passed'})
        self.repo.commit({'experiments/new.csv': '3\n'})  # a modification of a path pages does not read
        self.assertEqual(self.status(self.gate_run()[1]), {'drafts': 'reused', 'pages': 'reused'})
        self.assertEqual((self.runs('drafts'), self.runs('pages')), (1, 3))

    def test_a_path_outside_every_area_reaches_every_kept_pass(self):
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        self.gate_run()
        self.repo.commit({'newarea/f.txt': 'g\n'})
        self.assertEqual(self.status(self.gate_run()[1]), {'drafts': 'passed', 'pages': 'passed', 'tools': 'passed'})

    def test_a_pass_is_not_reused_for_a_commit_that_does_not_descend_from_it(self):
        passed = self.repo.commit({'drafts/a.md': '# A, changed\n'}, 'drafts on work')
        self.gate_run()
        self.repo.branch('other')
        self.repo.commit({'drafts/a.md': '# A, changed\n', 'tools/x.py': 'x = 2\n'}, 'the same drafts, and tools')
        # As in the ancestor case, the diff from the passed commit reaches only tools; only the ancestry differs.
        self.assertEqual(self.repo.git('diff', '--name-only', passed, 'HEAD').split(), ['tools/x.py'])
        self.assertFalse(self.repo.descends(passed))
        code, out = self.gate_run()
        self.assertEqual(self.status(out), {'drafts': 'passed', 'pages': 'passed', 'tools': 'passed'})
        self.assertEqual((self.runs('drafts'), self.runs('pages')), (2, 2))

    def test_a_pass_does_not_outlive_a_change_to_the_research_tools(self):
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        self.gate_run()
        self.repo.commit({'tools/research/helper.py': 'y = 1\n'})  # nothing drafts reads
        self.assertEqual(self.status(self.gate_run()[1])['drafts'], 'passed')
        self.assertEqual(self.runs('drafts'), 2)

    def test_a_pass_does_not_outlive_a_change_to_its_script(self):
        probe = (gate.Check('probe', (sys.executable, '-B', PROBE), ('drafts/**',)),)
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        self.assertEqual(self.status(self.gate_run(checks=probe)[1]), {'probe': 'passed'})
        self.repo.commit({'experiments/data.csv': '2\n'})  # neither what it reads nor its script
        self.assertEqual(self.status(self.gate_run(checks=probe)[1]), {'probe': 'reused'})
        self.repo.commit({PROBE: self.FILES[PROBE] + '# changed\n'})
        self.assertEqual(self.status(self.gate_run(checks=probe)[1]), {'probe': 'passed'})
        self.assertEqual(self.runs('probe'), 2)

    def test_a_failing_command_keeps_no_pass(self):
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        failing = (gate.Check('drafts', self.counting('drafts', code=3), ('drafts/**',)),)
        code, out = self.gate_run(checks=failing)
        self.assertEqual((code, out['failed']), (1, ['drafts']))
        self.assertEqual((out['results']['drafts']['status'], out['results']['drafts']['exit']), ('failed', 3))
        self.assertEqual(self.kept('drafts'), [])
        code, out = self.gate_run(checks=failing)
        self.assertEqual(self.status(out), {'drafts': 'failed'})
        self.assertEqual(self.runs('drafts'), 2)

    def test_a_dirty_tree_refuses_to_run_and_keeps_nothing(self):
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        for name, body in (('drafts/untracked.md', 'new\n'), ('drafts/b.md', '# B, uncommitted\n')):
            with self.subTest(name):
                self.repo.write({name: body})
                code, out = self.gate_run()
                self.assertEqual(code, 1)
                self.assertIn('uncommitted or untracked', out['errors'][0])
                self.assertTrue(any(name in e for e in out['errors'][1:]), out)
                self.assertNotIn('results', out)
                if name.endswith('untracked.md'):
                    self.repo.write({name: None})
                self.repo.git('checkout', '-q', '--', '.')
        self.assertEqual((self.runs('drafts'), self.runs('pages')), (0, 0))
        self.assertEqual(self.kept('drafts') + self.kept('pages'), [])

    def test_without_keeping_a_dirty_tree_runs_and_keeps_nothing(self):
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        self.repo.write({'drafts/untracked.md': 'new\n'})
        code, out = self.gate_run(keep_passes=False)
        self.assertEqual(code, 0, out)
        self.assertEqual(self.status(out), {'drafts': 'passed', 'pages': 'passed'})
        self.assertEqual(self.kept('drafts') + self.kept('pages'), [])

    def test_a_check_that_leaves_the_tree_dirty_keeps_no_pass(self):
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        script = "import pathlib; pathlib.Path('drafts/left-behind.md').write_text('x')"
        code, out = self.gate_run(checks=(gate.Check('drafts', (sys.executable, '-c', script), ('drafts/**',)),))
        self.assertEqual(self.status(out), {'drafts': 'passed'})
        self.assertEqual(self.kept('drafts'), [])

    def test_a_pass_belongs_to_its_environment(self):
        version = self.tmp / 'version'
        probe = (sys.executable, '-c', f'print(open({str(version)!r}).read())')
        checks = (gate.Check('drafts', self.counting('drafts'), ('drafts/**',), env=(probe,)),)
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        seen = []
        for v in ('1', '1', '2', '1'):
            version.write_text(v)
            seen.append(self.status(self.gate_run(checks=checks)[1])['drafts'])
        self.assertEqual(seen, ['passed', 'reused', 'passed', 'reused'])

    def test_full_runs_every_check_reusing_only_a_pass_on_the_same_tree_and_fresh_reuses_none(self):
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        self.gate_run()
        self.assertEqual(self.status(self.gate_run(full=True)[1]), {'drafts': 'reused', 'tools': 'passed', 'pages': 'reused'})
        self.repo.commit({'tools/x.py': 'x = 2\n'})  # drafts' pass now holds only across an ancestor
        self.assertEqual(self.status(self.gate_run(full=True)[1]), {'drafts': 'passed', 'tools': 'passed', 'pages': 'passed'})
        self.assertEqual(self.status(self.gate_run(full=True, fresh=True)[1]),
                         {'drafts': 'passed', 'tools': 'passed', 'pages': 'passed'})
        self.assertEqual((self.runs('drafts'), self.runs('tools'), self.runs('pages')), (3, 3, 3))

    def test_only_limits_the_run_to_the_named_checks(self):
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        self.assertEqual(self.status(self.gate_run(only=['drafts'])[1]), {'drafts': 'passed'})
        self.assertEqual(self.runs('pages'), 0)

    def test_a_pass_is_kept_for_the_tree_the_check_ran_on(self):
        # Bug: run() (gate.py lines 695-696) calls keep(), which reads tree() and HEAD only after the command has
        # ended (line 461), and dirty() then compares the working tree with that new HEAD. A commit made in the
        # worktree while a check runs therefore takes the pass for a tree the check never read, and the next run
        # reuses it on the same tree. Here the command commits, standing for any commit during a long run; the
        # tree it leaves would fail it. Read the tree and HEAD before the command, and keep the pass only if HEAD
        # is unchanged and the tree clean when it ends.
        self.repo.commit({'drafts/a.md': 'good\n'})
        started = self.repo.tree()
        script = ("import pathlib, subprocess, sys\n"
                  "if pathlib.Path('drafts/a.md').read_text() != 'good\\n': sys.exit(1)\n"
                  "pathlib.Path('drafts/a.md').write_text('bad\\n')\n"
                  "subprocess.run(['git', 'commit', '-q', '-am', 'during the run'], check=True)\n")
        code, out = self.gate_run(checks=(gate.Check('drafts', (sys.executable, '-c', script), ('drafts/**',)),))
        if self.status(out) != {'drafts': 'passed'} or self.repo.tree() == started:
            self.skipTest('the command did not pass and commit, as the case needs')
        self.assertEqual({e['tree'] for e in self.kept('drafts')} - {started}, set())


class CheckoutTests(GateCase):
    """The gate runs in a worktree of the merged commit, never the shared checkout other sessions move."""

    def setUp(self):
        super().setUp()
        del os.environ['GATE_IN_SHARED_CHECKOUT']
        self.repo.commit({'drafts/a.md': '# A, changed\n'})

    def chdir(self, where):
        before = os.getcwd()
        os.chdir(where)
        self.addCleanup(os.chdir, before)

    def test_the_gate_refuses_the_shared_checkout(self):
        self.chdir(self.repo.root)
        code, out = self.gate_run()
        self.assertEqual(code, 1, out)
        self.assertIn('never the shared checkout', out['errors'][0])
        self.assertEqual(self.runs('drafts'), 0)

    def test_the_gate_refuses_the_shared_checkout_from_any_working_directory(self):
        # Bug: shared_checkout() (gate.py line 271) resolves the output of `git rev-parse --git-dir`, which in the main
        # checkout is the relative '.git', against the process's working directory instead of ROOT (common_dir() joins
        # it to ROOT, line 267). Run from anywhere but the checkout's root (a subdirectory, or a tool that does not cd),
        # the guard finds no shared checkout and the gate runs there.
        self.chdir(self.tmp)
        code, out = self.gate_run()
        self.assertEqual(code, 1, out)

    def test_a_linked_worktree_runs(self):
        linked = self.tmp / 'linked'
        self.repo.git('worktree', 'add', '-q', '-b', 'linked', str(linked), 'work')
        self.patch(mock.patch.object(gate, 'ROOT', linked))
        self.chdir(linked)
        code, out = self.gate_run()
        self.assertEqual((code, self.status(out)), (0, {'drafts': 'passed', 'pages': 'passed'}), out)

    def test_the_shared_checkout_can_be_allowed(self):
        self.chdir(self.repo.root)
        os.environ['GATE_IN_SHARED_CHECKOUT'] = '1'
        code, out = self.gate_run()
        self.assertEqual((code, self.status(out)), (0, {'drafts': 'passed', 'pages': 'passed'}), out)


HOLDER = ('import sys\n'
          'from pathlib import Path\n'
          'sys.path.insert(0, sys.argv[1])\n'
          'from tools.research import gate\n'
          'gate.ROOT = Path(sys.argv[2])\n'
          'with gate.slot(sys.argv[3], wait=0.02) as i:\n'
          '    print(i, flush=True)\n'
          '    sys.stdin.read()\n')


class Waiter(threading.Thread):
    """Takes a slot in this process, through gate.slot, and holds it until released."""

    def __init__(self, label):
        super().__init__(daemon=True)
        self.label, self.index = label, None
        self.got, self.release = threading.Event(), threading.Event()

    def run(self):
        with gate.slot(self.label, wait=0.02) as i:
            self.index = i
            self.got.set()
            self.release.wait(30)


class SlotTests(GateCase):
    """Every wait is bounded: a holder is another process, killed at the end, and each waiting thread is a daemon."""

    def setUp(self):
        super().setUp()
        self.said = io.StringIO()
        self.patch(mock.patch.object(sys, 'stderr', self.said))

    def hold(self, label='holder'):
        """Another process holding a slot through gate.slot, on this repository's tree, until it is killed."""
        holder = subprocess.Popen([sys.executable, '-B', '-c', HOLDER, str(REPOSITORY), str(self.repo.root), label],
                                  stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        self.addCleanup(self.end, holder)
        ready, _, _ = select.select([holder.stdout], [], [], 30)
        line = holder.stdout.readline() if ready else ''
        if not line.strip():
            self.fail('the holder took no slot: ' + (holder.stderr.read() if holder.poll() is not None else 'waiting'))
        return holder, int(line)

    @staticmethod
    def end(holder):
        if holder.poll() is None:
            holder.kill()
        holder.wait(10)
        for stream in (holder.stdin, holder.stdout, holder.stderr):
            stream.close()

    def waiter(self, label):
        w = Waiter(label)
        self.addCleanup(lambda: (w.release.set(), w.join(10)))
        w.start()
        return w

    def lock_probe(self, index=0):
        """A script that exits 0 only while another holds slot `index`."""
        lock = self.tmp / 'gate' / 'slots' / f'slot-{index}.lock'
        lock.parent.mkdir(parents=True, exist_ok=True)
        lock.touch()
        return ('import fcntl, sys\n'
                f'stream = open({str(lock)!r}, "a+")\n'
                'try:\n'
                '    fcntl.flock(stream, fcntl.LOCK_EX | fcntl.LOCK_NB)\n'
                'except BlockingIOError:\n'
                '    sys.exit(0)\n'
                'sys.exit(1)\n')

    @staticmethod
    def until(condition, timeout=20.0):
        end = time.monotonic() + timeout
        while time.monotonic() < end:
            if condition():
                return True
            time.sleep(0.02)
        return condition()

    def test_with_one_slot_a_second_taker_waits_until_the_holder_ends(self):
        os.environ['GATE_SLOTS'] = '1'
        holder, index = self.hold()
        self.assertEqual(index, 0)
        self.assertEqual([h['run'] for h in gate.status()['held']], ['holder'])
        second = self.waiter('second')
        self.assertFalse(second.got.wait(0.5), 'took a slot while the only one was held')
        self.assertIn('waiting for a slot for second', self.said.getvalue())
        holder.kill()  # a slot is released when its process ends, however it ends
        self.assertTrue(second.got.wait(20), 'still waiting after the holder ended')
        self.assertEqual(second.index, 0)

    def test_with_two_slots_a_second_taker_takes_the_other_and_a_third_waits(self):
        os.environ['GATE_SLOTS'] = '2'
        holder, index = self.hold()
        second = self.waiter('second')
        self.assertTrue(second.got.wait(20), 'waited although a slot was free')
        self.assertEqual({index, second.index}, {0, 1})
        third = self.waiter('third')
        self.assertFalse(third.got.wait(0.5), 'took a slot while both were held')
        second.release.set()
        self.assertTrue(third.got.wait(20), 'still waiting after a slot was released')
        self.assertEqual(third.index, second.index)

    def test_a_twin_of_a_held_run_is_refused(self):
        os.environ['GATE_SLOTS'] = '2'
        self.hold('strict')
        with self.assertRaises(ValueError):  # refused at once, although a slot is free
            with gate.slot('strict', wait=0.02):
                pass
        other = self.waiter('links')  # another run on the same tree is no twin
        self.assertTrue(other.got.wait(20))
        other.release.set()
        other.join(10)
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        later = self.waiter('strict')  # nor is the same run on another tree
        self.assertTrue(later.got.wait(20))

    def test_hold_runs_a_command_in_a_slot_returns_its_exit_and_refuses_a_twin(self):
        os.environ['GATE_SLOTS'] = '1'
        probe = [sys.executable, '-c', self.lock_probe()]
        self.assertEqual(gate.hold(probe), 0)
        self.assertEqual(gate.hold([sys.executable, '-c', 'raise SystemExit(4)']), 4)
        self.assertEqual(gate.status()['held'], [])
        os.environ['GATE_SLOTS'] = '2'
        self.hold(' '.join(probe))
        with self.assertRaises(ValueError):
            gate.hold(probe)

    def test_a_heavy_check_runs_holding_a_slot_and_a_light_one_does_not(self):
        os.environ['GATE_SLOTS'] = '1'
        probe = self.lock_probe()
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        checks = (gate.Check('heavy', (sys.executable, '-c', probe), ('drafts/**',), heavy=True),
                  gate.Check('light', (sys.executable, '-c', probe), ('drafts/**',)))
        code, out = gate.run('main', checks=checks)
        self.assertEqual(self.status(out), {'heavy': 'passed', 'light': 'failed'})
        self.assertEqual(gate.status()['held'], [])

    def test_a_heavy_check_waits_for_a_slot_and_a_light_one_does_not(self):
        os.environ['GATE_SLOTS'] = '1'
        self.repo.commit({'drafts/a.md': '# A, changed\n', 'tools/x.py': 'x = 2\n'})
        checks = (gate.Check('tools', self.counting('tools'), ('tools/**',)),
                  gate.Check('drafts', self.counting('drafts'), ('drafts/**',), heavy=True))
        holder, _ = self.hold()
        self.patch(mock.patch.object(gate, 'slot', functools.partial(gate.slot, wait=0.02)))
        result = {}
        worker = threading.Thread(target=lambda: result.setdefault('out', gate.run('main', checks=checks)), daemon=True)
        self.addCleanup(lambda: (self.end(holder), worker.join(60)))  # before the patches are undone
        worker.start()
        self.assertTrue(self.until(lambda: self.runs('tools') == 1), 'the light check did not run')
        time.sleep(0.3)
        self.assertEqual(self.runs('drafts'), 0, 'the heavy check ran while every slot was held')
        self.assertTrue(worker.is_alive())
        holder.kill()
        worker.join(30)
        self.assertFalse(worker.is_alive(), 'the heavy check still waits after the holder ended')
        code, out = result['out']
        self.assertEqual((code, self.status(out)), (0, {'tools': 'passed', 'drafts': 'passed'}))
        self.assertIn('waiting for a slot for drafts', self.said.getvalue())


SECTIONS = ('## Rules', '## Now', '## Open claims', '## Landing queue', '## Decisions pending Ren')
HEAD = '(landing now: L1, its gate running).'
QUEUE = [HEAD, 'L2 waits on its readers.', 'L3 waits on L2 (after the freeze; see GATE.md).',
         "Then, in the coordinator's order: L2;", 'L3.']


def board(queue=QUEUE, sections=SECTIONS, queue_lines=1, body='A row of the board.\n' * 40):
    out = ['# Board', '']
    for h in sections:
        out += [h, '', body]
        if h == '## Landing queue':
            out += ['- **Queue:** ' + ' '.join(queue)] * queue_lines + ['']
    return '\n'.join(out) + '\n'


class BoardTests(GateCase):
    FILES = {**GateCase.FILES, gate.BOARD: board()}

    def check(self, text, board_only=False, **env):
        """The board check on a landing off main that commits `text` as the board (and a page, unless board_only)."""
        self.fresh()
        self.repo.commit({gate.BOARD: text, **({} if board_only else {'drafts/a.md': '# A, changed\n'})})
        with mock.patch.dict(os.environ, env):
            return gate.board_check('main')

    def assertFails(self, result, fragment):
        self.assertTrue(any(fragment in e for e in result['errors']), result)

    def test_clauses_are_cut_outside_brackets_before_a_space_or_the_end(self):
        self.assertEqual(gate.clauses('A (b. c; d) e. F; g.h i.'), ['A (b. c; d) e.', 'F;', 'g.h i.'])
        self.assertEqual(gate.clauses('[x](y.md) z. w'), ['[x](y.md) z.', 'w'])
        self.assertEqual(gate.clauses('0.8 of it.'), ['0.8 of it.'])
        self.assertEqual(gate.clauses(' '.join(QUEUE)), QUEUE)

    def test_a_landing_may_drop_its_head_clauses_and_the_closing_order(self):
        self.assertEqual(self.check(board(QUEUE[1:]))['errors'], [])
        self.assertEqual(self.check(board(QUEUE[1:3] + ["Then, in the coordinator's order: L3, then L2."]))['errors'], [])
        self.on_main({gate.BOARD: board([HEAD, 'L4 (landing now, in the same train).'] + QUEUE[1:])})
        self.assertEqual(self.check(board(QUEUE[1:]))['errors'], [])  # a train's head clauses

    def test_a_clause_that_only_mentions_the_head_is_kept(self):
        # A clause that only mentions the head ("waits until L1 no longer holds the head of the queue") is not a head
        # clause being replaced, and a short clause recurring inside another is still a clause of its own.
        queue = [HEAD, 'L2 waits until L1 no longer holds the head of the queue.', 'Ties are read as sets.',
                 'L3 holds that ties are read as sets.', "Then, in the coordinator's order: L2;", 'L3.']
        self.on_main({gate.BOARD: board(queue)})
        self.assertFails(self.check(board(queue[2:])), 'lost 1 clause(s)')
        self.assertFails(self.check(board([queue[0], queue[1]] + queue[3:])), 'lost 1 clause(s)')
        self.assertEqual(self.check(board(queue[1:]))['errors'], [])

    def test_losing_another_clause_fails(self):
        result = self.check(board([HEAD] + QUEUE[2:]))
        self.assertFails(result, 'lost 1 clause(s)')
        self.assertFails(result, 'L2 waits on its readers.')

    def test_the_board_keeps_its_sections_and_one_queue_line(self):
        self.assertFails(self.check(board(sections=SECTIONS[:2] + SECTIONS[3:])), 'lost its section "## Open claims"')
        self.assertFails(self.check(board(queue_lines=2)), 'exactly one Queue line')
        self.assertFails(self.check(board(queue_lines=0)), 'exactly one Queue line')

    def test_a_sharp_shrink_fails_unless_a_rewrite_is_named(self):
        self.assertFails(self.check(board(body='A row.\n')), 'shrank')
        self.assertEqual(self.check(board(body='A row of the board.\n' * 33))['errors'], [])  # above 0.8
        result = self.check(board(body='A row.\n'), GATE_BOARD_REWRITE='rows moved to history')
        self.assertEqual((result['errors'], result['accepted_rewrite']), ([], 'rows moved to history'))
        self.assertTrue(any('shrank' in e for e in result['would_fail']), result)

    def test_a_board_only_change_waits_while_a_clause_holds_the_head(self):
        later = board(QUEUE + ['L5 waits on its design.'])
        self.assertFails(self.check(later, board_only=True), 'board-only commit waits')
        self.assertEqual(self.check(later)['errors'], [])
        self.on_main({gate.BOARD: board(QUEUE[1:])})
        self.assertEqual(self.check(board(QUEUE[1:] + ['L5 waits on its design.']), board_only=True)['errors'], [])

    def test_the_first_clause_is_kept_unless_it_is_a_head_clause(self):
        # Bug: board_check() (gate.py line 581) checks the clauses a[1:end], so the base's first clause may vanish
        # whatever it says. When no landing holds the head, the first clause is an ordinary one (here "L2 waits on
        # its readers."), and losing it passes. Exempt a[0] only when HEAD_CLAUSE matches it.
        self.on_main({gate.BOARD: board(QUEUE[1:])})
        self.assertFails(self.check(board(QUEUE[2:])), 'lost 1 clause(s)')


PIN = 'experiments/exp/results/FROZEN-AT'


class FrozenTests(GateCase):
    FILES = {**GateCase.FILES, 'experiments/exp/design.py': 'design\n', 'experiments/exp/results/data.csv': '1\n',
             'experiments/f1/a.txt': 'a\n',
             'experiments/f1/FROZEN.sha256': sha('a\n') + '  experiments/f1/a.txt\n',
             'experiments/f2/b.txt': 'b\n',
             'experiments/f2/FREEZE.json': json.dumps({'files': [{'path': 'experiments/f2/b.txt', 'sha256': sha('b\n')}]})}

    def setUp(self):
        super().setUp()
        self.pinned = self.repo.head()
        self.on_main({PIN: f'exp {self.pinned[:9]} (the freeze)\n'})

    def frozen(self, everything=False, **env):
        with mock.patch.dict(os.environ, env):
            return gate.frozen_check('main', everything)

    def assertFails(self, result, fragment):
        self.assertTrue(any(fragment in e for e in result['errors']), result)

    def freeze_check(self):
        return gate.Check('freeze', self.counting('freeze'), (), derived='frozen_paths')

    def test_a_landing_that_touches_no_freeze_is_clean(self):
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        result = self.frozen()
        self.assertEqual((result['errors'], result['standing'], result['unverified']), ([], [], []))

    def test_a_frozen_file_the_landing_changes_fails(self):
        self.repo.commit({'experiments/f1/a.txt': 'a, changed\n', 'experiments/f2/b.txt': None})
        result = self.frozen()
        self.assertFails(result, 'this landing changes experiments/f1/a.txt, which it froze')
        self.assertFails(result, 'this landing changes experiments/f2/b.txt, which it froze')  # a deletion too
        self.assertEqual(self.frozen(GATE_FROZEN_ACK='experiments/f1/a.txt: rewritten; experiments/f2/b.txt: retired')['errors'], [])

    def test_a_freeze_the_landing_does_not_touch_is_standing_unless_everything_is_asked(self):
        self.on_main({'experiments/f2/b.txt': 'b, changed on main\n'})
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        result = self.frozen()
        self.assertEqual(result['errors'], [])
        self.assertEqual(result['standing'], ['experiments/f2/FREEZE.json: 1'])  # counted per record, for its owner
        everything = self.frozen(everything=True)  # the full set lists it whole and still does not fail on what stands
        self.assertEqual(everything['errors'], [])
        self.assertTrue(any('experiments/f2/b.txt is not the bytes frozen' in s for s in everything['standing']), everything)

    def test_a_pin_is_never_changed(self):
        self.repo.commit({PIN: f'exp {self.pinned[:9]} (the freeze, reworded)\n'})
        self.assertFails(self.frozen(), 'a pin is committed once and never changed')

    def test_a_pin_names_a_commit_that_is_an_ancestor(self):
        self.repo.branch('elsewhere')
        other = self.repo.commit({'drafts/b.md': '# B, elsewhere\n'}, 'elsewhere')
        self.fresh()
        self.repo.commit({'experiments/new/results/FROZEN-AT': f'new {other[:9]}\n', 'experiments/new/x.txt': 'x\n'})
        self.assertFails(self.frozen(), "names no commit in HEAD's history")  # a pin this landing adds
        self.fresh()
        self.repo.commit({'experiments/none/results/FROZEN-AT': 'not yet frozen\n'})
        self.assertFails(self.frozen(), 'names no commit')

    def test_a_file_the_pin_held_changes_only_when_acknowledged(self):
        self.repo.commit({'experiments/exp/design.py': 'design, changed\n'})
        self.assertFails(self.frozen(), 'changes experiments/exp/design.py')
        self.assertEqual(self.frozen(GATE_FROZEN_ACK='experiments/exp/design.py: the design was wrong')['errors'], [])
        self.fresh()
        self.repo.commit({'experiments/exp/results/round2.csv': '2\n'})  # not held at the pin
        self.assertEqual(self.frozen()['errors'], [])

    def test_the_freezes_select_the_frozen_check(self):
        for path, reached in (('experiments/f1/a.txt', True), ('experiments/exp/design.py', True),
                              ('experiments/f2/FREEZE.json', True), ('drafts/a.md', False)):
            with self.subTest(path):
                self.fresh()
                self.repo.commit({path: 'changed\n'})
                self.assertEqual(set(gate.plan('main', checks=(self.freeze_check(),))['selected']),
                                 {'freeze'} if reached else set())

    def test_an_acknowledgement_names_the_file_exactly(self):
        # Bug: frozen_check() (gate.py line 648) tests `p not in ack`, a substring test on the GATE_FROZEN_ACK string,
        # so an acknowledgement naming another file whose path contains this one (design.py.old) lets design.py change.
        self.repo.commit({'experiments/exp/design.py': 'design, changed\n'})
        self.assertFails(self.frozen(GATE_FROZEN_ACK='experiments/exp/design.py.old: retired'),
                         'changes experiments/exp/design.py')

    def test_a_freeze_json_listing_files_by_path_is_verified(self):
        # Bug: manifests() (gate.py lines 600-605) reads FREEZE*.json `files` only as a list of {path, sha256}; a
        # `files` mapping path to sha256 yields no entries, is listed as unverified, and nothing in it is checked or
        # selects the check. The repository has one: experiments/integrated-correction/selective-handoff/FREEZE.json,
        # 36 files.
        self.on_main({'experiments/f3/c.txt': 'c\n',
                      'experiments/f3/FREEZE.json': json.dumps({'files': {'experiments/f3/c.txt': sha('c\n')}})})
        self.repo.commit({'experiments/f3/c.txt': 'c, changed\n'})
        self.assertFails(self.frozen(), 'experiments/f3/c.txt')

    def test_a_deleted_pin_fails(self):
        # Bug: pins() and manifests() (gate.py lines 594-612) read only the tree at HEAD, so a landing that deletes a
        # FROZEN-AT pin (or a FROZEN.sha256 manifest) removes it from what frozen_check() verifies: the deletion that
        # most changes a pin passes.
        self.repo.commit({PIN: None})
        self.assertNotEqual(self.frozen()['errors'], [])

    def test_a_deleted_pin_selects_the_frozen_check(self):
        # Bug: the frozen check's reads are derived from HEAD's manifests and pins (frozen_paths, line 82) and it is not
        # `added`, so deleting a pin (or a manifest) reaches it by no rule and the gate does not run it.
        self.repo.commit({PIN: None})
        self.assertIn('freeze', gate.plan('main', checks=(self.freeze_check(),))['selected'])

    def test_a_missing_file_in_a_freeze_the_landing_does_not_touch_does_not_stop_the_gate(self):
        # A derived read is its check's own business: a file missing from a freeze no landing touches is standing, for
        # its owner, not a stale rule that would refuse every landing.
        self.on_main({'experiments/f1/FROZEN.sha256': self.FILES['experiments/f1/FROZEN.sha256'] +
                      sha('gone\n') + '  experiments/f1/gone.txt\n'})
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        self.assertTrue(any('gone.txt is missing' in s for s in self.frozen(everything=True)['standing']))
        code, out = gate.run('main', checks=(self.freeze_check(),))
        self.assertEqual((code, out.get('errors')), (0, None), out)


CHAPTER_PATH = 'theories/becoming/chapters/01-ONE.md'
FRONT_PATH = 'theories/becoming/FRONT.md'
RECORDS = 'theories/becoming/results/records/'
ALPHA_ANCHOR = '<a id="r-alpha"></a>'
CHAPTER = [
    '# One',
    '',
    'Intro, in no home.',
    '',
    ALPHA_ANCHOR,
    '**Theorem.** Alpha holds ([record](../results/records/alpha.md)).',
    '',
    'More about alpha.',
    '',
    '## Two',
    '',
    'After the heading, in no home.',
    '',
    '<a id="r-beta"></a>',
    '**Theorem.** Beta holds.',
    '',
    '<a id="r-gamma"></a>',
    '<a id="r-delta"></a>',
    '**Theorem.** Gamma and delta hold together.',
    '',
    '## Three',
    '',
    '| Result | Says |',
    '|---|---|',
    '| <a id="r-eps"></a><a id="r-zeta"></a>Eps and zeta | they hold |',
    '',
    '<a id="r-alpha-two"></a>',
    '**Theorem.** Alpha two holds.',
]
FRONT = [
    '# Front',
    'Alpha, as [01](chapters/01-ONE.md#r-alpha) says.',
    'The [record of alpha](results/records/alpha.md).',
    'Beta, as [01](chapters/01-ONE.md#r-beta) says.',
    'Gamma, as [01](chapters/01-ONE.md#r-gamma) says.',
    'Delta, as [01](chapters/01-ONE.md#r-delta) says.',
    'Eps, as [01](chapters/01-ONE.md#r-eps) says.',
    'Zeta, as [01](chapters/01-ONE.md#r-zeta) says.',
    'Alpha two, as [01](chapters/01-ONE.md#r-alpha-two) says.',
]
LINK = '[alpha](../../../theories/becoming/chapters/01-ONE.md#r-alpha)\n'


def record(rid, statement, digest='0' * 64):
    return json.dumps({'id': rid, 'title': rid.title(), 'statement': statement, 'status': 'proved', 'kind': 'theorem',
                       'references': [{'path': CHAPTER_PATH, 'role': 'home', 'sha256': digest}]}, indent=2) + '\n'


def front(text):
    return f'{FRONT_PATH}:{FRONT.index(text) + 1}'


class RestatedTests(GateCase):
    FILES = {CHAPTER_PATH: '\n'.join(CHAPTER) + '\n', FRONT_PATH: '\n'.join(FRONT) + '\n',
             '_process/research/study/NOTE.md': LINK,          # a study: past work, not kept in step
             '_process/history/OLD.md': LINK,                   # history
             'sources/talk.md': 'We spoke of r-alpha.\n',       # a source
             RECORDS + 'alpha.md': '# Alpha\n\nHome: [01](../../chapters/01-ONE.md#r-alpha)\n',  # generated
             RECORDS + 'alpha.json': record('alpha', 'Alpha holds.'),
             RECORDS + 'beta.json': record('beta', 'Beta holds.'),
             RECORDS + 'alpha-two.json': record('alpha-two', 'Alpha two holds.')}

    def edit(self, changes):
        lines = list(CHAPTER)
        for old, new in changes.items():
            i = lines.index(old)
            if new is None:
                del lines[i]
            else:
                lines[i] = new
        self.repo.commit({CHAPTER_PATH: '\n'.join(lines) + '\n'})

    def test_a_changed_home_lists_the_live_lines_that_link_it(self):
        self.edit({'More about alpha.': 'More about alpha, revised.'})
        out = gate.restated('main')
        self.assertEqual(out['sections'], ['r-alpha'])
        self.assertEqual(list(out['restated_at']), ['r-alpha'])
        listed = out['restated_at']['r-alpha']
        self.assertIn(front('Alpha, as [01](chapters/01-ONE.md#r-alpha) says.'), listed)
        self.assertIn(front('The [record of alpha](results/records/alpha.md).'), listed)
        self.assertNotIn(f'{CHAPTER_PATH}:{CHAPTER.index(ALPHA_ANCHOR) + 1}', listed)  # the anchor line
        # No study, history, source or generated page is listed.
        self.assertEqual([x for x in listed if not x.startswith((FRONT_PATH + ':', CHAPTER_PATH + ':'))], [])

    def test_a_change_in_no_home_lists_nothing(self):
        self.edit({'Intro, in no home.': 'Intro, revised.',
                   'After the heading, in no home.': 'After the heading, revised.'})
        out = gate.restated('main')
        self.assertEqual((out['sections'], out['restated_at']), ([], {}))

    def test_a_deleted_line_touches_the_home_it_stood_in(self):
        self.edit({'More about alpha.': None})
        self.assertEqual(gate.restated('main')['sections'], ['r-alpha'])

    def test_a_record_whose_said_fields_changed_lists_its_restatements(self):
        self.repo.commit({RECORDS + 'alpha.json': record('alpha', 'Alpha holds, restated.')})
        out = gate.restated('main')
        self.assertEqual(out['sections'], ['r-alpha'])
        self.assertIn(front('Alpha, as [01](chapters/01-ONE.md#r-alpha) says.'), out['restated_at']['r-alpha'])
        self.assertIn(front('The [record of alpha](results/records/alpha.md).'), out['restated_at']['r-alpha'])

    def test_a_repoint_that_changes_only_hashes_lists_nothing(self):
        self.repo.commit({RECORDS + 'beta.json': record('beta', 'Beta holds.', digest='1' * 64)})
        out = gate.restated('main')
        self.assertEqual((out['sections'], out['restated_at']), ([], {}))

    def test_a_new_record_is_listed(self):
        self.repo.commit({RECORDS + 'gamma.json': record('gamma', 'Gamma holds.')})
        out = gate.restated('main')
        self.assertEqual(out['sections'], ['r-gamma'])
        self.assertEqual(out['restated_at']['r-gamma'], [front('Gamma, as [01](chapters/01-ONE.md#r-gamma) says.')])

    def test_anchors_stacked_over_one_home_are_all_touched(self):
        # Bug: restated() keeps one current anchor (gate.py lines 738-747), so of two anchors stacked over one home a
        # changed line touches only the last, and pages restating the first are not listed. The live chapters stack
        # them: 01-ROOT.md:158-159, 03-KNOWING.md:357-358, 07-SIGNIFICANCE.md:208-209, 331-332 and 543-544.
        self.edit({'**Theorem.** Gamma and delta hold together.': '**Theorem.** Gamma and delta hold, revised.'})
        self.assertEqual(gate.restated('main')['sections'], ['r-delta', 'r-gamma'])

    def test_two_anchors_on_one_line_are_both_touched(self):
        # Bug: ANCHOR.search (gate.py line 740) takes only the first anchor on a line; 04-LIFE.md:105 has two in
        # one table row (r-formed-contacts-change-copying-fidelity, r-formed-copying-registration).
        self.edit({'| <a id="r-eps"></a><a id="r-zeta"></a>Eps and zeta | they hold |':
                   '| <a id="r-eps"></a><a id="r-zeta"></a>Eps and zeta | they hold, revised |'})
        self.assertEqual(gate.restated('main')['sections'], ['r-eps', 'r-zeta'])

    def test_a_line_linking_a_longer_id_does_not_restate_a_shorter_one(self):
        # Bug: restated() matches an anchor as a substring (gate.py lines 750-760), so a change to alpha lists a line
        # that links only #r-alpha-two. Six pairs of record ids in the repository are such prefixes (census-balance
        # and census-balance-under-continuation, wisdom-root and wisdom-root-without-axiom, ...).
        self.edit({'More about alpha.': 'More about alpha, revised.'})
        self.assertNotIn(front('Alpha two, as [01](chapters/01-ONE.md#r-alpha-two) says.'),
                         gate.restated('main')['restated_at']['r-alpha'])


    def test_another_records_home_that_links_a_changed_one_is_listed(self):
        # A chapter row that is the home of one record and links another restates the one it links.
        other = 'theories/becoming/chapters/02-TWO.md'
        self.on_main({other: '# Two\n\n| Result | Says |\n|---|---|\n| <a id="r-other"></a>Other, by [alpha](01-ONE.md#r-alpha) | x |\n'})
        self.edit({'More about alpha.': 'More about alpha, revised.'})
        self.assertIn(f'{other}:5', gate.restated('main')['restated_at']['r-alpha'])

class RuleTests(unittest.TestCase):
    """The real rule table, read without running any check or reading the tree."""

    def test_a_research_test_is_reached_by_the_live_files_it_asserts_on(self):
        # test_completion.py reads the live coverage file, the records and the core run's receipt (its lines 94 and
        # 110-112); its own check reads them, and a test file with no entry reads every path.
        completion = gate.BY_NAME['test:test_completion']
        for path in ('theories/becoming/results/completion/COVERAGE.json', 'theories/becoming/results/records/x.json',
                     gate.BECOMING + '/becoming-verification.json', 'tools/research/tests/test_completion.py'):
            with self.subTest(path):
                self.assertTrue(gate.reached(completion, [('M', path)]))
        self.assertFalse(gate.reached(completion, [('M', 'theories/becoming/ONE-PAGE.md')]))

    def test_a_change_to_the_gate_reaches_the_checks_it_runs(self):
        # Bug (as in SelectionTests.test_a_change_to_a_checks_own_script_selects_it): `board` and `frozen` run gate.py,
        # but a landing that changes only tools/research/gate.py selects neither (gate.py lines 226-229: their reads
        # are the board, and the freezes).
        self.assertTrue(gate.reached(gate.BY_NAME['board'], [('M', 'tools/research/gate.py')]))


LEAN_DIR = gate.LEAN


class ReceiptTests(GateCase):
    """The receipt check: the core receipt binds the current bytes of every module it lists, and every module under
    Becoming/ is in some receipt; another checker's receipt fails only on its own sources this landing changes."""
    CORE = gate.BECOMING + '/becoming-verification.json'
    OTHER = gate.BECOMING + '/other-verification.json'
    A = gate.BECOMING + '/Becoming/A.lean'
    B = gate.BECOMING + '/Becoming/B.lean'
    OWN = gate.BECOMING + '/Becoming/Own.lean'

    def receipt(self, sources, status='passed'):
        return json.dumps({'status': status, 'utc': 'T', 'source_paths': {n: p[len(LEAN_DIR) + 1:] for n, (p, _) in sources.items()},
                           'source_sha256': {n: sha(text) for n, (_, text) in sources.items()}})

    def setUp(self):
        super().setUp()
        self.on_main({self.A: 'a\n', self.B: 'b\n', self.OWN: 'own\n',
                      self.CORE: self.receipt({'A': (self.A, 'a\n'), 'B': (self.B, 'b\n')}),
                      self.OTHER: self.receipt({'A': (self.A, 'a\n'), 'Own': (self.OWN, 'own\n')})})

    def test_a_current_receipt_passes(self):
        self.repo.commit({'drafts/a.md': '# A, changed\n'})
        result = gate.receipt_check('main')
        self.assertEqual((result['errors'], result['area_checks_to_rerun']), ([], []))

    def test_lean_the_core_run_did_not_cover_fails(self):
        self.repo.commit({self.A: 'a, changed\n'})
        result = gate.receipt_check('main')
        self.assertTrue(any('becoming-verification.json' in e and 'A.lean' in e for e in result['errors']), result)
        self.assertEqual(result['area_checks_to_rerun'], [self.OTHER])  # its import moved on: an area check to rerun

    def test_another_checkers_own_source_fails_when_this_landing_changes_it(self):
        self.repo.commit({self.OWN: 'own, changed\n'})
        result = gate.receipt_check('main')
        self.assertTrue(any('other-verification.json' in e and 'Own.lean' in e for e in result['errors']), result)

    def test_a_module_no_receipt_lists_fails(self):
        self.repo.commit({gate.BECOMING + '/Becoming/New.lean': 'new\n'})
        self.assertTrue(any('New.lean' in e and 'no receipt lists' in e for e in gate.receipt_check('main')['errors']))

    def test_a_failed_core_receipt_fails(self):
        self.repo.commit({self.CORE: self.receipt({'A': (self.A, 'a\n'), 'B': (self.B, 'b\n')}, status='failed')})
        self.assertTrue(any('status' in e for e in gate.receipt_check('main')['errors']))


class StepTests(GateCase):
    """The shared-laws step follows a change to a record's laws, not to its other fields."""
    RECORD = 'theories/becoming/results/records/r.json'

    def test_the_shared_laws_follow_laws_not_other_fields(self):
        self.on_main({self.RECORD: json.dumps({'id': 'r', 'laws': ['L'], 'next_delta': 'x'})})
        steps = lambda: [s['step'] for s in gate.plan('main', checks=())['before_the_gate']]
        self.repo.commit({self.RECORD: json.dumps({'id': 'r', 'laws': ['L'], 'next_delta': 'y'})})
        self.assertNotIn('shared laws', steps())
        self.fresh()
        self.repo.commit({self.RECORD: json.dumps({'id': 'r', 'laws': ['L, narrowed'], 'next_delta': 'x'})})
        self.assertIn('shared laws', steps())


if __name__ == '__main__':
    unittest.main()
