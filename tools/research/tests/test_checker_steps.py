"""The Becoming checker's concurrent steps: each waits for what it reads; the receipt keeps serial order.
A step not in the cache runs once under its key's lock, Lean processes take the machine's slots, and the
plan the checker and scratch_build share keys every step by its inputs."""
import os
from pathlib import Path
import re
import tempfile
import threading
import time
import unittest

from tools.research.tests.test_style import load_checker


class CheckerSteps(unittest.TestCase):
    def setUp(self):
        self.checker = load_checker()
        self.lock = threading.Lock()
        self.finished, self.running, self.peak = [], 0, 0

    def task(self, name, needs, fails=False):
        def action():
            with self.lock:
                self.assertTrue(set(needs) <= set(self.finished), (name, needs))
                self.running += 1
                self.peak = max(self.peak, self.running)
            time.sleep(0.01)
            with self.lock:
                self.running -= 1
                self.finished.append(name)
            if fails:
                raise RuntimeError(name)
            return name.upper()
        return needs, action

    def graph(self, failing=()):
        # A small import graph: a ← b ← d, a ← c ← d, d ← e, and f alone.
        needs = {'a': [], 'b': ['a'], 'c': ['a'], 'd': ['b', 'c'], 'e': ['d'], 'f': []}
        return {name: self.task(name, n, name in failing) for name, n in needs.items()}

    def test_each_step_waits_for_what_it_reads(self):
        for jobs in (1, 2, 4):
            self.finished, self.peak = [], 0
            results = self.checker.run_graph(self.graph(), jobs=jobs)
            self.assertEqual(results, {name: name.upper() for name in 'abcdef'})
            self.assertLessEqual(self.peak, jobs)

    def test_failure_stops_what_depends_on_it(self):
        with self.assertRaises(RuntimeError):
            self.checker.run_graph(self.graph(failing={'b'}), jobs=2)
        self.assertFalse({'d', 'e'} & set(self.finished))

    def test_receipt_lists_steps_in_serial_order(self):
        steps = {'ran': ['c.log', 'version.log', 'a.log'], 'reused': {'b.log': 1, 'x.log': 2},
                 'keys': {'c.log': 'k3', 'b.log': 'k2', 'a.log': 'k1'}}
        self.checker.in_serial_order(steps, ['version.log', 'a.log', 'b.log', 'c.log'])
        self.assertEqual(steps['ran'], ['version.log', 'a.log', 'c.log'])
        self.assertEqual(list(steps['reused']), ['b.log', 'x.log'])
        self.assertEqual(list(steps['keys']), ['a.log', 'b.log', 'c.log'])



class SharedSteps(unittest.TestCase):
    """The runner every checker and scratch build uses (`lean_step`), on a scratch cache and a stand-in for Lean."""

    def setUp(self):
        self.checker = load_checker()
        self.scratch = tempfile.TemporaryDirectory()
        self.root = Path(self.scratch.name)
        cache = self.root / 'cache'
        self.checker.CACHE, self.checker.LOCKS, self.checker.SLOTS = cache, cache / 'locks', cache / 'slots'
        self.checker.FRESH = False

    def tearDown(self):
        self.scratch.cleanup()

    def directory(self, name):
        path = self.root / name
        path.mkdir()
        return path

    # The stand-in: writes its output file, sleeps, prints its arguments; `fail` and `warn` as told.
    def lean(self, seconds=0.2):
        script = ('import sys, time; time.sleep(%s); open("out.olean", "w").write("o");'
                  'a = sys.argv[1:]; print(*a);'
                  'sys.exit(1 if "fail" in a else 0)') % seconds
        return ['python3', '-c', script]

    def test_a_step_wanted_twice_at_once_runs_once(self):
        outcomes = {}

        def go(name):
            outcomes[name] = self.checker.lean_step(self.lean(), ['x'], self.directory(name), 'k1', ['out.olean'],
                                                    {'run': name})
        threads = [threading.Thread(target=go, args=(n,)) for n in ('one', 'two')]
        for thread in threads:
            thread.start()
        for thread in threads:
            thread.join()
        ran = [n for n, o in outcomes.items() if o.reused_from is None]
        self.assertEqual(len(ran), 1, outcomes)
        other = 'two' if ran == ['one'] else 'one'
        self.assertEqual(outcomes[other].reused_from, {'run': ran[0]})
        self.assertEqual((self.root / other / 'out.olean').read_text(), 'o')
        self.assertEqual(outcomes[ran[0]].output, outcomes[other].output)
        self.assertFalse(list(self.checker.LOCKS.iterdir()), 'the lock file goes with the lock')

    def test_seconds_are_kept_and_a_failure_is_not_stored(self):
        first = self.checker.lean_step(self.lean(0), ['x'], self.directory('a'), 'k2', ['out.olean'], {'run': 'a'})
        self.assertTrue(first.passed and first.seconds is not None and first.reused_from is None)
        entry = (self.checker.CACHE / 'k2.json').read_text()
        self.assertIn('"seconds"', entry)
        again = self.checker.lean_step(self.lean(0), ['x'], self.directory('b'), 'k2', ['out.olean'], {'run': 'b'})
        self.assertEqual(again.reused_from, {'run': 'a'})
        failed = self.checker.lean_step(self.lean(0), ['fail'], self.directory('c'), 'k3', ['out.olean'], {'run': 'c'})
        self.assertEqual((failed.returncode, failed.passed), (1, False))
        warned = self.checker.lean_step(self.lean(0), ['warning:'], self.directory('d'), 'k4', ['out.olean'], {'run': 'd'})
        self.assertEqual((warned.returncode, warned.passed), (0, False))
        self.assertFalse((self.checker.CACHE / 'k3.json').exists() or (self.checker.CACHE / 'k4.json').exists())

    def test_fresh_runs_every_step(self):
        self.checker.lean_step(self.lean(0), ['x'], self.directory('a'), 'k5', ['out.olean'], {'run': 'a'})
        self.checker.FRESH = True
        again = self.checker.lean_step(self.lean(0), ['x'], self.directory('b'), 'k5', ['out.olean'], {'run': 'b'})
        self.assertIsNone(again.reused_from)

    def test_lean_processes_keep_to_the_slots(self):
        self.checker.LEAN_SLOTS = 2
        lock, inside, peak = threading.Lock(), [0], [0]

        def go():
            with self.checker.lean_slot():
                with lock:
                    inside[0] += 1
                    peak[0] = max(peak[0], inside[0])
                time.sleep(0.15)
                with lock:
                    inside[0] -= 1
        threads = [threading.Thread(target=go) for _ in range(5)]
        for thread in threads:
            thread.start()
        for thread in threads:
            thread.join()
        self.assertEqual(peak[0], 2)

    def test_a_waiter_on_a_removed_lock_file_takes_the_new_one(self):
        entered, order = threading.Event(), []

        def holder():
            with self.checker.step_lock('k6'):
                entered.set()
                time.sleep(0.2)
                order.append('holder')

        def waiter():
            entered.wait()
            with self.checker.step_lock('k6'):
                order.append('waiter')
                self.assertTrue((self.checker.LOCKS / 'k6.lock').exists())
        threads = [threading.Thread(target=holder), threading.Thread(target=waiter)]
        for thread in threads:
            thread.start()
        for thread in threads:
            thread.join()
        self.assertEqual(order, ['holder', 'waiter'])
        self.assertFalse((self.checker.LOCKS / 'k6.lock').exists())


class Plan(unittest.TestCase):
    """The plan on a small package of modules: keys by inputs, the order of a one-at-a-time run."""

    def setUp(self):
        self.checker = load_checker()
        self.sources = {'Base': b'-- base\n', 'Found': b'import Std\nimport Base\n', 'Top': b'import Found\nimport Base\n'}
        self.order = ['Base', 'Found', 'Top']
        self.context = ['toolchain', 'binary']
        self.keys = self.checker.module_keys(self.context, self.sources, self.order)
        self.registry = {name: [{'name': name + '.t', 'kind': 'theorem'}, {'name': name + '.d', 'kind': 'def'}]
                         for name in self.order}

    def test_steps_in_the_old_order_with_the_old_keys(self):
        plan, files = self.checker.lean_plan(self.context, self.sources, self.keys, self.registry, self.order,
                                             audited=self.order, signed=['Top'], prelude=self.order,
                                             extra=[('controls', 'Controls.lean', 'import Top\n')])
        self.assertEqual([s.log for s in plan], [
            'Base.log', 'BaseAxiomAudit.log', 'Found.log', 'FoundAxiomAudit.log', 'Top.log', 'TopAxiomAudit.log',
            'TopSignatures.log', 'Controls.log', 'Base.PreludeOnly.log', 'Found.PreludeOnly.log', 'Top.PreludeOnly.log'])
        steps = {s.task: s for s in plan}
        self.assertEqual(steps['compile Top'].needs, ['compile Found', 'compile Base'])
        self.assertEqual(steps['compile Top'].key, self.keys['Top'])
        audit = 'import Top\n#print axioms Top.t\n#print axioms Top.d\n'
        self.assertEqual(steps['audit Top'].text, audit)
        self.assertEqual(steps['audit Top'].key, self.checker.step_key(self.context, 'TopAxiomAudit.lean', audit.encode(), self.keys))
        self.assertEqual(steps['signatures Top'].text, 'import Top\n#check @Top.t\n')
        self.assertEqual(steps['controls'].needs, ['compile Top'])
        self.assertEqual(steps['prelude Top'].needs, ['prelude Found', 'prelude Base'])
        self.assertEqual(files['prelude-only']['Found.lean'], b'import Base\n')

    def test_a_compile_from_the_prelude_with_its_modules_inputs_is_its_modules_step(self):
        plan, _ = self.checker.lean_plan(self.context, self.sources, self.keys, self.registry, self.order,
                                         prelude=self.order)
        steps = {s.task: s for s in plan}
        # Base reads no Std: the same bytes, the same imports, the same step.
        self.assertEqual(steps['prelude Base'].key, steps['compile Base'].key)
        # Found loses its `import Std` line, and Top imports Found: other inputs, other steps.
        self.assertNotEqual(steps['prelude Found'].key, steps['compile Found'].key)
        self.assertNotEqual(steps['prelude Top'].key, steps['compile Top'].key)
        self.assertEqual({s.args[0] for s in plan if s.task.split()[0] in ('compile', 'prelude')}, {'-o'})

    def test_imports_are_parsed_once_and_returned_fresh(self):
        data = b'import A\n-- import B\nimport Std\nimport C\n'
        first = self.checker.imports_of(data)
        self.assertEqual(first, ['A', 'C'])
        first.append('Z')
        self.assertEqual(self.checker.imports_of(data), ['A', 'C'])
        self.assertEqual(self.checker._imports.cache_info().hits, 1)


class EnvironmentAudit(unittest.TestCase):
    def test_one_listing_of_the_constants(self):
        checker = load_checker()
        text = checker.ENVIRONMENT_AUDIT.format(imports='import M', modules='`M, `N')
        self.assertEqual(text.count('env.constants.map₁.toList'), 1)
        self.assertIn('let modules : Array Name := #[`M, `N]', text)
        loop = text.index('for (n, _) in env.constants.map₁.toList')
        self.assertLess(text.index('position := position.insert'), loop)
        self.assertLess(loop, text.index('Lean.collectAxioms n'))
        self.assertEqual(re.findall(r'logInfo m!"(\w+)', text), ['AXIOMS', 'CONSTANTS'])


if __name__ == '__main__':
    unittest.main()
