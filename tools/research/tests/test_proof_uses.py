"""The print of the uses between proofs: tools/research/proof_uses.py without Lean. A small made-up receipt and rows
in a temporary directory: the stub and the printer text from a receipt, the printer's output read into rows, the
files written and read back, and status() against the receipt. The run is reached too, on a temporary root, with git,
the checker, the plan, the count of lacking steps, the scratch build and Lean's process each replaced by a stand-in:
what is held there is the order of its steps, the first words of its refusals and that a refusal writes nothing, not
that the Lean text of the printer compiles. AI-written (Claude Fable, for board row DJ), 22 November 2026."""
import contextlib
import hashlib
import io
import json
import os
import re
import tempfile
import unittest
from collections import namedtuple
from pathlib import Path
from types import SimpleNamespace
from unittest import mock

from tools.research import proof_uses, shared_laws

PRIVATE = '_private.Becoming.Alpha.0.Becoming.Alpha.helper'
TEXTS = {'Becoming.Alpha': 'alpha', 'Becoming.Beta': 'beta', 'RelationalRenewal': 'renewal'}
UTC = '20261122T000000.000000Z'


def sha(text):
    return hashlib.sha256(text.encode()).hexdigest()


def receipt(sources=None, theorems=None):
    """A receipt of three modules, one of them outside `Becoming.*`, with the keys the tool reads. `theorems` gives
    the number of theorems the checker counted in a module's source (0 where it is not given)."""
    sources = sources or TEXTS
    return {'status': 'passed', 'utc': UTC, 'toolchain': 'leanprover/lean4:v4.29.1',
            'source_paths': {m: ('becoming/' + m.replace('.', '/') if m.startswith('Becoming') else 'deeper/' + m) + '.lean'
                             for m in sources},
            'source_sha256': {m: sha(text) for m, text in sources.items()},
            'modules': [{'module': m, 'theorems': (theorems or {}).get(m, 0), 'declarations': []} for m in sources]}


def rows():
    """Rows by module as the printer's output is read: a private theorem, a theorem outside `Becoming.*`, a name
    Lean made (`Becoming.Alpha.size.eq_1`) among the uses with no row of its own, and a module with no theorem."""
    return {
        'Becoming.Alpha': [{'name': 'Becoming.Alpha.«始»', 'uses': []},
                           {'name': 'Becoming.Alpha.first', 'uses': ['Becoming.Alpha.size.eq_1', PRIVATE]},
                           {'name': PRIVATE, 'uses': ['RelationalRenewal.Law.kept']}],
        'Becoming.Beta': [],
        'RelationalRenewal': [{'name': 'RelationalRenewal.Law.kept', 'uses': []}],
    }


def printed(by_module, count=None, uses=None, before=()):
    """What the printer would print for these rows: one ROW line a theorem and the count line last."""
    lines = list(before)
    lines += ['ROW ' + json.dumps({'module': m, 'name': r['name'], 'uses': r['uses']}, ensure_ascii=False)
              for m in by_module for r in by_module[m]]
    total = sum(len(r['uses']) for found in by_module.values() for r in found)
    n = sum(len(found) for found in by_module.values())
    return '\n'.join(lines + [f'COUNT rows={n if count is None else count} uses={total if uses is None else uses}']) + '\n'


class Root(unittest.TestCase):
    """A temporary repository root holding a receipt and, once written, a print."""

    def setUp(self):
        scratch = tempfile.TemporaryDirectory()
        self.addCleanup(scratch.cleanup)
        self.root = Path(scratch.name)
        self.directory = self.root / proof_uses.DIRECTORY
        self.receipt_path = self.root / proof_uses.RECEIPT
        self.receipt_path.parent.mkdir(parents=True)
        self.put_receipt(receipt())

    def put_receipt(self, r):
        self.receipt = r
        self.receipt_path.write_text(json.dumps(r))

    def write(self, by_module=None, r=None, **more):
        by_module = rows() if by_module is None else by_module
        index = proof_uses.index_object(r or self.receipt, by_module, commit='c0ffee', **more)
        return index, proof_uses.write_print(self.directory, index, by_module)

    def stamps(self):
        return {p.name: (p.stat().st_ino, p.stat().st_mtime_ns, p.read_bytes()) for p in self.directory.iterdir()}

    def rewrite_index(self, change):
        """The index on disk, changed by `change` and put back: an index as another version of the tool, or a hand,
        would have left it."""
        index = json.loads((self.directory / 'INDEX.json').read_text(encoding='utf-8'))
        change(index)
        (self.directory / 'INDEX.json').write_text(json.dumps(index, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')


class FromAReceipt(unittest.TestCase):
    def test_the_stub_imports_every_module_of_the_receipt_and_states_nothing(self):
        text = proof_uses.stub_text(receipt())
        imports = [line[len('import '):] for line in text.splitlines() if line.startswith('import ')]
        self.assertEqual(imports, ['Becoming.Alpha', 'Becoming.Beta', 'RelationalRenewal'])
        rest = text[text.index('\n/-!'):].strip()
        self.assertTrue(rest.startswith('/-!') and rest.endswith('-/') and rest.count('-/') == 1)  # one comment, no more
        self.assertIn('AI-written', rest)
        self.assertEqual(text, proof_uses.stub_text(receipt()))  # the same receipt gives the same stub, so the same cache key

    def test_the_printer_text_holds_the_receipts_modules_and_its_hash_is_of_the_embedded_text(self):
        text = proof_uses.printer_text(receipt())
        self.assertIn('def receiptModules : List String := [\n  "Becoming.Alpha",\n  "Becoming.Beta",\n  "RelationalRenewal"\n]', text)
        self.assertNotIn(proof_uses.MODULES_PLACEHOLDER, text)
        self.assertTrue(text.startswith('import Lean\nimport ' + proof_uses.STUB + '\n'))
        self.assertEqual(proof_uses.printer_sha256(), hashlib.sha256(proof_uses.PRINTER.encode()).hexdigest())
        self.assertNotEqual(proof_uses.printer_sha256(), proof_uses.printer_sha256(proof_uses.PRINTER + '\n'))
        with self.assertRaises(ValueError):
            proof_uses.printer_text(receipt(), 'import Lean\n')  # a printer with no place for the modules

    def test_the_printer_text_keeps_a_private_theorem_and_takes_its_modules_from_the_list(self):
        # The Lean text is not compiled here. These two lines are what make a private theorem and a module outside
        # `Becoming.*` have rows; the test fails if an edit drops the one or brings the old test by prefix back.
        self.assertIn('if skipLast c || (privateToUserName c).isInternal then continue', proof_uses.PRINTER)
        self.assertIn('receiptModules.contains (toString m)', proof_uses.PRINTER)
        self.assertNotIn('`Becoming).isPrefixOf', proof_uses.PRINTER)

    def test_a_receipt_whose_module_names_could_not_be_file_names_is_refused(self):
        for name in ('../Outside', 'Becoming/Alpha', '.hidden', 'Becoming.Al pha', proof_uses.STUB):
            with self.subTest(name=name), self.assertRaises(ValueError):
                proof_uses.receipt_modules(receipt({'Becoming.Alpha': 'a', name: 'x'}))
        r = receipt()
        del r['source_paths']['Becoming.Beta']
        with self.assertRaises(ValueError):
            proof_uses.receipt_modules(r)

    def test_the_hash_of_the_sources_is_the_one_shared_laws_computes(self):
        r = receipt()
        self.assertEqual(proof_uses.sources_digest(r), shared_laws.sources_digest(r))
        self.assertEqual(proof_uses.sources_digest(r),
                         hashlib.sha256(json.dumps(r['source_sha256'], sort_keys=True).encode()).hexdigest())


class PrinterOutput(unittest.TestCase):
    MODULES = sorted(rows())

    def test_output_is_read_into_rows_by_module_sorted_with_a_warning_kept_aside(self):
        shuffled = {'RelationalRenewal': rows()['RelationalRenewal'],
                    'Becoming.Alpha': [dict(r, uses=r['uses'][::-1]) for r in rows()['Becoming.Alpha'][::-1]]}
        warning = 'ProofUses.lean:40:2: warning: `String.x` has been deprecated'
        by_module, notes = proof_uses.parse_output(printed(shuffled, before=[warning]), self.MODULES)
        self.assertEqual(notes, [warning])
        self.assertEqual(list(by_module), self.MODULES)
        self.assertEqual(by_module['Becoming.Beta'], [])  # a module with no theorem is there, with no rows
        self.assertEqual([r['name'] for r in by_module['Becoming.Alpha']],
                         ['Becoming.Alpha.first', 'Becoming.Alpha.«始»', PRIVATE])
        self.assertEqual(by_module['Becoming.Alpha'][0]['uses'], ['Becoming.Alpha.size.eq_1', PRIVATE])

    def test_rows_of_a_private_theorem_and_of_a_module_outside_becoming_are_read_through(self):
        # Only the reading: that the printer prints such rows is Lean's doing and is not held here.
        by_module, _ = proof_uses.parse_output(printed(rows()), self.MODULES)
        self.assertIn(PRIVATE, [r['name'] for r in by_module['Becoming.Alpha']])
        self.assertEqual(by_module['RelationalRenewal'], [{'name': 'RelationalRenewal.Law.kept', 'uses': []}])

    def test_output_that_is_not_a_whole_print_is_refused(self):
        good = printed(rows())
        refused = {
            'nothing printed': '',
            'cut before the count line': good[:good.rindex('COUNT')],
            'fewer rows than counted': printed(rows(), count=9),
            'other uses than counted': printed(rows(), uses=1),
            'an error from Lean': printed(rows(), before=['ProofUses.lean:3:0: error: unknown constant']),
            'a panic, after which Lean goes on and exits 0': printed(rows(), before=[
                'PANIC at Array.get!Internal Init.GetElem:171:2: index out of bounds']),
            'a row that is not JSON': 'ROW {"module": \nCOUNT rows=1 uses=0\n',
            'a row with another field': 'ROW {"module": "Becoming.Alpha", "name": "A", "uses": [], "head": null}\nCOUNT rows=1 uses=0\n',
            'a use that is no name': 'ROW {"module": "Becoming.Alpha", "name": "A", "uses": [1]}\nCOUNT rows=1 uses=1\n',
            'a module the receipt lacks': printed({'Becoming.Gamma': [{'name': 'Becoming.Gamma.a', 'uses': []}]}),
            'a name printed twice': printed({'Becoming.Alpha': [{'name': 'A', 'uses': []}], 'Becoming.Beta': [{'name': 'A', 'uses': []}]}),
            'two count lines': 'COUNT rows=0 uses=0\nCOUNT rows=0 uses=0\n',
        }
        for what, text in refused.items():
            with self.subTest(what=what):
                with self.assertRaises(proof_uses.Refused) as raised:
                    proof_uses.parse_output(text, self.MODULES)
                self.assertTrue(str(raised.exception).startswith(proof_uses.LEAN_SHORT), str(raised.exception))

    def test_a_module_with_fewer_rows_than_the_receipt_counts_theorems_is_named(self):
        # The count line agrees with the rows printed even when a whole module's rows were dropped inside Lean.
        counted = receipt(theorems={'Becoming.Alpha': 3, 'RelationalRenewal': 1})
        self.assertEqual(proof_uses.short_of_the_receipt(counted, rows()), [])
        dropped = dict(rows(), RelationalRenewal=[])
        by_module, _ = proof_uses.parse_output(printed(dropped), self.MODULES)  # the output itself reads as whole
        self.assertEqual(proof_uses.short_of_the_receipt(counted, by_module), ['RelationalRenewal'])
        fewer = dict(rows())
        fewer['Becoming.Alpha'] = fewer['Becoming.Alpha'][:2]
        self.assertEqual(proof_uses.short_of_the_receipt(counted, fewer), ['Becoming.Alpha'])
        # more rows than the receipt counts is no sign: Lean holds as theorems some things no person wrote as one
        self.assertEqual(proof_uses.short_of_the_receipt(receipt(theorems={'Becoming.Alpha': 1}), rows()), [])


class Files(Root):
    def test_the_files_round_trip_byte_for_byte_and_are_sorted(self):
        index, written = self.write()
        self.assertEqual(written['changed'], ['Becoming.Alpha', 'Becoming.Beta', 'RelationalRenewal'])
        self.assertEqual((written['removed'], written['index_changed'], written['not_of_the_print']), ([], True, []))
        self.assertEqual(sorted(p.name for p in self.directory.iterdir()),
                         ['Becoming.Alpha.jsonl', 'Becoming.Beta.jsonl', 'INDEX.json', 'RelationalRenewal.jsonl'])
        self.assertEqual((self.directory / 'Becoming.Alpha.jsonl').read_text(encoding='utf-8'),
                         '{"name": "Becoming.Alpha.first", "uses": ["Becoming.Alpha.size.eq_1", "' + PRIVATE + '"]}\n'
                         '{"name": "Becoming.Alpha.«始»", "uses": []}\n'
                         '{"name": "' + PRIVATE + '", "uses": ["RelationalRenewal.Law.kept"]}\n')
        self.assertEqual((self.directory / 'Becoming.Beta.jsonl').read_bytes(), b'')
        self.assertEqual((self.directory / 'INDEX.json').read_text(encoding='utf-8'),
                         json.dumps(index, ensure_ascii=False, indent=1) + '\n')
        read_index, read_rows = proof_uses.read_print(self.directory)
        self.assertEqual(read_index, index)
        for m, found in read_rows.items():
            self.assertEqual([r['name'] for r in found], sorted(r['name'] for r in rows()[m]))
            self.assertTrue(all(r['uses'] == sorted(r['uses']) for r in found))
        # written again from what was read: the same bytes
        before = self.stamps()
        proof_uses.write_print(self.directory, read_index, read_rows)
        self.assertEqual(self.stamps(), before)

    def test_the_index_has_the_fixed_keys_and_binds_the_receipt(self):
        index, _ = self.write()
        self.assertEqual(list(index), ['about', 'format', 'printer_sha256', 'toolchain', 'printed_from',
                                       'core_sources_sha256', 'modules', 'counts'])
        self.assertIs(type(index['format']), int)
        self.assertEqual((index['format'], proof_uses.FORMAT), (1, 1))
        self.assertEqual(index['printed_from'], {'commit': 'c0ffee', 'core_run': UTC})
        self.assertEqual(index['toolchain'], 'leanprover/lean4:v4.29.1')
        self.assertEqual(index['core_sources_sha256'], shared_laws.sources_digest(self.receipt))
        self.assertEqual(index['modules'], {'Becoming.Alpha': {'source_sha256': sha('alpha'), 'theorems': 3},
                                            'Becoming.Beta': {'source_sha256': sha('beta'), 'theorems': 0},
                                            'RelationalRenewal': {'source_sha256': sha('renewal'), 'theorems': 1}})
        self.assertEqual(index['counts'], {'modules': 3, 'theorems': 4, 'uses_without_row': 1})

    def test_no_index_is_made_or_written_without_a_commit_and_a_core_run(self):
        for commit in (None, '', 0, b'c0ffee'):
            with self.subTest(commit=commit), self.assertRaises(ValueError):
                proof_uses.index_object(self.receipt, rows(), commit=commit)
        with self.assertRaises(ValueError):
            proof_uses.index_object(self.receipt, rows())  # no commit given at all
        for utc in (None, ''):
            timeless = dict(self.receipt, utc=utc)
            with self.subTest(utc=utc), self.assertRaises(ValueError):
                proof_uses.index_object(timeless, rows(), commit='c0ffee')
        without = dict(self.receipt)
        del without['utc']
        with self.assertRaises(ValueError):
            proof_uses.index_object(without, rows(), commit='c0ffee')
        # and where the files are written: an index that lost either is refused before the first write
        good = proof_uses.index_object(self.receipt, rows(), commit='c0ffee')
        for made in (None, {}, {'commit': 'c0ffee'}, {'core_run': UTC}, {'commit': None, 'core_run': UTC},
                     {'commit': 'c0ffee', 'core_run': ''}):
            with self.subTest(printed_from=made), self.assertRaises(ValueError):
                proof_uses.write_print(self.directory, dict(good, printed_from=made), rows())
        lacking_it = {k: v for k, v in good.items() if k != 'printed_from'}
        with self.assertRaises(ValueError):
            proof_uses.write_print(self.directory, lacking_it, rows())
        self.assertFalse(self.directory.exists())

    def test_the_index_says_on_its_face_what_a_line_is_and_no_more(self):
        about = proof_uses.ABOUT
        for said in ('a use between proofs as written', 'One call', 'on that theorem\'s line, where it has one',
                     'No other definition is followed', 'private theorem', 'any name with a part beginning `_`'):
            self.assertIn(said, about)
        self.assertNotIn('Definitions are not followed', about)  # the matchers under a theorem's name are definitions
        for unsaid in ('a case', 'join', 'the same law', 'passage', 'road', 'proved from', 'most depended', 'most basic',
                       'central', 'pieces', 'linked to no other'):
            self.assertNotIn(unsaid, about)
            self.assertNotIn(unsaid, proof_uses.__doc__)

    def test_a_second_write_of_the_same_rows_changes_no_file(self):
        self.write()
        before = self.stamps()
        _, written = self.write()
        self.assertEqual((written['changed'], written['removed'], written['index_changed']), ([], [], False))
        self.assertEqual(self.stamps(), before)  # the same files (inode), untouched (time), the same bytes
        self.assertEqual([p.name for p in self.directory.iterdir() if p.name.startswith('.')], [])  # no temporary file left

    def test_the_same_rows_written_in_two_places_give_the_same_bytes_and_a_module_file_tells_no_place_or_time(self):
        elsewhere = tempfile.TemporaryDirectory(prefix='another-place-')
        self.addCleanup(elsewhere.cleanup)
        there = Path(elsewhere.name) / 'deeper' / proof_uses.DIRECTORY
        self.write()
        proof_uses.write_print(there, proof_uses.index_object(self.receipt, rows(), commit='c0ffee'), rows())
        names = sorted(p.name for p in self.directory.iterdir())
        self.assertEqual(names, sorted(p.name for p in there.iterdir()))
        self.assertEqual(len([n for n in names if n.endswith('.jsonl')]), 3)
        for name in names:  # the module files, and the index too: neither holds where it was written
            self.assertEqual((self.directory / name).read_bytes(), (there / name).read_bytes(), name)
        for name in names:
            if not name.endswith('.jsonl'):
                continue
            data = (self.directory / name).read_text(encoding='utf-8')
            for told in ('c0ffee', UTC, UTC[:8], str(self.root), self.root.name, elsewhere.name, os.sep, 'tmp',
                         self.receipt['toolchain'], 'sha256'):
                self.assertNotIn(told, data, name)
            self.assertIsNone(re.search(r'\d{2}:\d{2}|\d{8}T\d{6}|\d{4}-\d{2}-\d{2}', data), name)  # no clock time, no date
            for line in data.splitlines():
                self.assertEqual(sorted(json.loads(line)), ['name', 'uses'])
        # the commit and the core run are in the index, and only there
        index = json.loads((self.directory / 'INDEX.json').read_text(encoding='utf-8'))
        self.assertEqual(index['printed_from'], {'commit': 'c0ffee', 'core_run': UTC})

    def test_only_the_module_whose_rows_changed_is_written(self):
        self.write()
        before = self.stamps()
        changed = rows()
        changed['RelationalRenewal'].append({'name': 'RelationalRenewal.Law.more', 'uses': ['RelationalRenewal.Law.kept']})
        _, written = self.write(changed)
        self.assertEqual((written['changed'], written['index_changed']), (['RelationalRenewal'], True))
        after = self.stamps()
        self.assertEqual(after['Becoming.Alpha.jsonl'], before['Becoming.Alpha.jsonl'])
        self.assertNotEqual(after['RelationalRenewal.jsonl'][2], before['RelationalRenewal.jsonl'][2])

    def test_a_module_dropped_from_the_receipt_has_its_file_removed_and_no_other_file_is(self):
        self.write()
        (self.directory / 'README.md').write_text('a file the tool did not write\n')
        (self.directory / 'Becoming.Stray.jsonl').write_text('')  # a module file no index ever named
        smaller = receipt({'Becoming.Alpha': 'alpha', 'RelationalRenewal': 'renewal'})
        kept = {m: found for m, found in rows().items() if m != 'Becoming.Beta'}
        index, written = self.write(kept, smaller)
        self.assertEqual(written['removed'], ['Becoming.Beta'])
        self.assertEqual(written['not_of_the_print'], ['Becoming.Stray.jsonl', 'README.md'])
        self.assertEqual(sorted(p.name for p in self.directory.iterdir()),
                         ['Becoming.Alpha.jsonl', 'Becoming.Stray.jsonl', 'INDEX.json', 'README.md', 'RelationalRenewal.jsonl'])
        self.assertNotIn('Becoming.Beta', index['modules'])

    def test_rows_that_do_not_fit_the_index_write_nothing(self):
        index = proof_uses.index_object(self.receipt, rows(), commit='c0ffee')
        short = rows()
        short['Becoming.Alpha'].pop()
        fewer = {m: found for m, found in rows().items() if m != 'Becoming.Beta'}
        for by_module in (short, fewer):
            with self.assertRaises(ValueError):
                proof_uses.write_print(self.directory, index, by_module)
        self.assertFalse(self.directory.exists())
        with self.assertRaises(ValueError):
            proof_uses.index_object(self.receipt, fewer, commit='c0ffee')  # rows of other modules than the receipt's

    def test_uses_without_row_counts_a_name_with_no_row(self):
        self.assertEqual(proof_uses.names_without_row(rows()), ['Becoming.Alpha.size.eq_1'])
        more = rows()
        more['Becoming.Beta'] = [{'name': 'Becoming.Beta.b', 'uses': ['Becoming.Alpha.size.eq_1', 'Becoming.Gone.x']}]
        self.assertEqual(proof_uses.names_without_row(more), ['Becoming.Alpha.size.eq_1', 'Becoming.Gone.x'])  # each name once
        self.assertEqual(proof_uses.index_object(self.receipt, more, commit='c0ffee')['counts']['uses_without_row'], 2)
        none = {m: [dict(r, uses=[]) for r in found] for m, found in rows().items()}
        self.assertEqual(proof_uses.index_object(self.receipt, none, commit='c0ffee')['counts']['uses_without_row'], 0)


class Status(Root):
    def test_no_index_is_not_bound_and_says_so(self):
        found = proof_uses.status(self.root)
        self.assertEqual((found['present'], found['bound'], found['kind'], found['modules_behind'], found['damage']),
                         (False, False, 'no index', [], []))
        self.assertIn('there is no index', found['problems'][0])

    def test_bound_then_not_after_a_source_hash_changes_then_not_after_the_printer_changes(self):
        self.write()
        found = proof_uses.status(self.root)
        self.assertEqual((found['present'], found['bound'], found['kind'], found['problems'], found['modules_behind'],
                          found['damage']), (True, True, 'bound', [], [], []))
        self.assertEqual((found['sources_bound'], found['printer_bound'], found['toolchain_agrees'], found['format_agrees']),
                         (True, True, True, True))
        self.assertEqual(found['printed_from'], {'commit': 'c0ffee', 'core_run': UTC})

        # the receipt of a later core run, after one module's source changed
        self.put_receipt(receipt({'Becoming.Alpha': 'alpha', 'Becoming.Beta': 'beta, changed', 'RelationalRenewal': 'renewal'}))
        found = proof_uses.status(self.root)
        self.assertEqual((found['bound'], found['kind'], found['sources_bound'], found['printer_bound']),
                         (False, 'not bound', False, True))
        self.assertEqual(found['modules_behind'], ['Becoming.Beta'])
        self.assertEqual(found['behind'], {'changed': ['Becoming.Beta'], 'not_in_print': [], 'not_in_receipt': []})
        self.assertEqual(len(found['problems']), 1)
        self.assertIn('core_sources_sha256', found['problems'][0])

        # printed again from that receipt: bound; then the tool's printer text changes
        self.write()
        self.assertTrue(proof_uses.status(self.root)['bound'])
        found = proof_uses.status(self.root, printer=proof_uses.PRINTER + '-- a changed printer\n')
        self.assertEqual((found['bound'], found['kind'], found['sources_bound'], found['printer_bound'], found['modules_behind']),
                         (False, 'not bound', True, False, []))
        self.assertIn('printer_sha256', found['problems'][0])

    def test_a_later_receipt_of_the_same_sources_and_toolchain_leaves_the_print_bound(self):
        # A core run made again with nothing changed gives another time and the same map of source hashes: the
        # print is still of what that receipt checked, and nothing asks for it to be printed again.
        self.write()
        before = self.stamps()
        later = dict(self.receipt, utc='20261123T010203.000000Z', retained_run='another')
        self.assertEqual((later['source_sha256'], later['toolchain']), (self.receipt['source_sha256'], self.receipt['toolchain']))
        self.put_receipt(later)
        found = proof_uses.status(self.root)
        self.assertEqual((found['bound'], found['kind'], found['problems'], found['modules_behind'], found['damage']),
                         (True, 'bound', [], [], []))
        self.assertEqual((found['core_run'], found['printed_from']['core_run']), ('20261123T010203.000000Z', UTC))
        with mock.patch.object(proof_uses, 'ROOT', self.root), contextlib.redirect_stdout(io.StringIO()):
            self.assertEqual(proof_uses.main(['--check']), 0)
        self.assertEqual(self.stamps(), before)  # and neither wrote a byte

    def test_a_module_missing_on_either_side_is_named(self):
        self.write()
        self.put_receipt(receipt({'Becoming.Alpha': 'alpha', 'Becoming.Beta': 'beta', 'Becoming.New': 'new'}))
        found = proof_uses.status(self.root)
        self.assertFalse(found['bound'])
        self.assertEqual(found['behind'], {'changed': [], 'not_in_print': ['Becoming.New'], 'not_in_receipt': ['RelationalRenewal']})
        self.assertEqual(found['modules_behind'], ['Becoming.New', 'RelationalRenewal'])

    def test_an_index_or_a_receipt_that_cannot_be_read_is_a_problem_and_raises_nothing(self):
        self.write()
        self.receipt_path.write_text('{"status": "passed"}')
        found = proof_uses.status(self.root)
        self.assertEqual((found['bound'], found['kind'], len(found['problems']), found['damage']), (False, 'not bound', 1, []))
        self.assertIn('core receipt', found['problems'][0])
        (self.directory / 'INDEX.json').write_text('<<<<<<< a merge left by hand\n')
        found = proof_uses.status(self.root)
        self.assertEqual((found['present'], found['bound'], found['kind']), (True, False, 'damaged'))
        self.assertIn('cannot be read', found['problems'][0])
        self.assertEqual(len(found['damage']), 1)
        self.assertIn('INDEX.json cannot be read', found['damage'][0])

    def test_files_that_are_not_what_the_index_describes_are_damage_told_beside_bound(self):
        self.write()
        (self.directory / 'RelationalRenewal.jsonl').write_text('')
        (self.directory / 'Becoming.Beta.jsonl').unlink()
        (self.directory / 'Becoming.Stray.jsonl').write_text('')
        found = proof_uses.status(self.root)
        self.assertTrue(found['bound'])  # bound is of the index against the receipt and this tool only
        self.assertEqual(found['kind'], 'damaged')
        self.assertEqual(found['damage'], ['Becoming.Beta.jsonl is missing',
                                           'RelationalRenewal.jsonl has 0 lines; the index gives 1 theorems',
                                           'Becoming.Stray.jsonl is a file of no module the index names'])
        with mock.patch.object(proof_uses, 'ROOT', self.root), contextlib.redirect_stdout(io.StringIO()):
            self.assertEqual(proof_uses.main(['--check']), 1)
        # files cut and an index that does not bind, both: the one word is of the files
        self.put_receipt(receipt({'Becoming.Alpha': 'alpha, changed', 'Becoming.Beta': 'beta', 'RelationalRenewal': 'renewal'}))
        found = proof_uses.status(self.root)
        self.assertEqual((found['bound'], found['kind'], len(found['problems']), len(found['damage'])), (False, 'damaged', 1, 3))

    def test_another_toolchain_than_the_receipts_is_not_bound(self):
        # A toolchain raised with no source changed gives a receipt of the same source hashes; the proof terms
        # printed are still those the earlier Lean made.
        self.write()
        self.put_receipt(dict(self.receipt, toolchain='leanprover/lean4:v4.30.0'))
        found = proof_uses.status(self.root)
        self.assertEqual((found['bound'], found['kind'], found['sources_bound'], found['printer_bound'], found['toolchain_agrees']),
                         (False, 'not bound', True, True, False))
        self.assertEqual(found['problems'], ['the print was made with toolchain leanprover/lean4:v4.29.1; the core receipt '
                                             'is of leanprover/lean4:v4.30.0'])
        self.assertEqual(found['modules_behind'], [])
        self.write()  # printed again from that receipt
        self.assertEqual(proof_uses.status(self.root)['kind'], 'bound')

    def test_an_index_of_another_format_or_of_none_is_not_bound(self):
        # printer_sha256 binds the Lean text; `format` binds the Python that turns its output into files.
        self.write()
        for change, shown in ((lambda i: i.pop('format'), 'None'), (lambda i: i.update(format=2), '2'),
                              (lambda i: i.update(format='1'), "'1'"), (lambda i: i.update(format=True), 'True')):
            with self.subTest(format=shown):
                self.write()
                self.rewrite_index(change)
                found = proof_uses.status(self.root)
                self.assertEqual((found['bound'], found['kind'], found['format_agrees'], found['sources_bound'],
                                  found['printer_bound'], found['toolchain_agrees'], found['damage']),
                                 (False, 'not bound', False, True, True, True, []))
                self.assertEqual(found['problems'], [f'the print\'s files are in format {shown}; tools/research/proof_uses.py '
                                                     f'writes format {proof_uses.FORMAT}'])
        with mock.patch.object(proof_uses, 'FORMAT', 2):  # the tool moves on to another format: an old print is behind
            self.write()
            self.assertEqual(proof_uses.status(self.root)['kind'], 'bound')
        self.assertEqual(proof_uses.status(self.root)['kind'], 'not bound')

    def test_check_exits_1_where_there_is_no_index(self):
        with mock.patch.object(proof_uses, 'ROOT', self.root), contextlib.redirect_stdout(io.StringIO()) as out:
            self.assertEqual(proof_uses.main(['--check']), 1)
        self.assertEqual(json.loads(out.getvalue())['kind'], 'no index')


class BeforeTheRun(Root):
    """The refusals of the run that need no Lean: sources that are not the receipt's, Lean that is not a commit's,
    and the count of steps the cache lacks."""

    def test_sources_that_are_not_the_bytes_the_receipt_hashed_are_named(self):
        lean = self.root / proof_uses.LEAN_ROOT
        for m, text in TEXTS.items():
            path = lean / self.receipt['source_paths'][m]
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text)
        self.assertEqual(proof_uses.unbound_sources(self.receipt, lean), [])
        (lean / self.receipt['source_paths']['Becoming.Beta']).write_text('beta, edited')
        (lean / self.receipt['source_paths']['RelationalRenewal']).unlink()
        self.assertEqual(proof_uses.unbound_sources(self.receipt, lean), ['Becoming.Beta', 'RelationalRenewal'])

    def test_lean_that_differs_from_head_is_read_off_git_status(self):
        package = proof_uses.PACKAGE
        source = proof_uses.LEAN_ROOT + '/deeper/RelationalRenewal.lean'
        porcelain = '\0'.join([
            ' M ' + package + '/Becoming/Alpha.lean',                       # a tracked module, edited
            ' M ' + package + '/becoming-verification.json',                # the receipt after a core run: not Lean
            '?? ' + package + '/becoming-checks/20261122T0/Becoming.Alpha.lean',  # a core run's untracked copy
            '?? ' + source,                                                 # a source of the receipt, not tracked
            'R  ' + package + '/Becoming/New.lean', package + '/Becoming/Old.lean',  # a rename, staged
            'D  ' + package + '/Becoming/Gone.lean',
            ''])
        self.assertEqual(proof_uses.dirty_lean(porcelain, {source}),
                         sorted([package + '/Becoming/Alpha.lean', source, package + '/Becoming/New.lean',
                                 package + '/Becoming/Old.lean', package + '/Becoming/Gone.lean']))
        self.assertEqual(proof_uses.dirty_lean('', {source}), [])
        self.assertEqual(proof_uses.dirty_lean(' M ' + package + '/becoming-verification.json\0', {source}), [])

    def test_the_steps_the_cache_lacks_are_counted_and_nothing_is_restored(self):
        Step = namedtuple('Step', 'task key outputs')
        cache = self.root / 'cache'
        cache.mkdir()
        olean = hashlib.sha256(b'olean').hexdigest()

        def keep(key, runner='r', outputs=(olean,), file=None, data=b'olean'):
            (cache / (key + '.json')).write_text(json.dumps({'runner': runner, 'log': '', 'outputs': list(outputs)}))
            if file:
                (cache / key).mkdir()
                (cache / key / file).write_bytes(data)

        plan = [Step('compile Becoming.Alpha', 'k1', ['Becoming/Alpha.olean']), Step('compile ' + proof_uses.STUB, 'k2', ['Stub.olean']),
                Step('audit ' + proof_uses.STUB, 'k3', []), Step('compile Becoming.Beta', 'k4', ['Becoming/Beta.olean']),
                Step('compile RelationalRenewal', 'k5', ['RelationalRenewal.olean']), Step('audit Becoming.Alpha', 'k6', []),
                Step('compile Becoming.Spoiled', 'k7', ['Becoming/Spoiled.olean'])]
        keep('k1', file='Alpha.olean')                                  # held: its file has the hash the entry gives
        keep('k4', runner='another runner', file='Beta.olean')          # another runner wrote it
        keep('k5')                                                      # its output file is gone
        keep('k6', outputs=())                                          # held: a step with no output file
        keep('k7', file='Spoiled.olean', data=b'olean, spoiled')        # its file is there with other bytes
        listing = sorted(str(p.relative_to(cache)) for p in cache.rglob('*'))
        self.assertEqual(proof_uses.lacking(plan, cache, 'r'),
                         ['compile ' + proof_uses.STUB, 'audit ' + proof_uses.STUB, 'compile Becoming.Beta',
                          'compile RelationalRenewal', 'compile Becoming.Spoiled'])
        self.assertEqual(len(proof_uses.lacking(plan, cache, 'r', fresh=True)), 7)
        self.assertEqual(sorted(str(p.relative_to(cache)) for p in cache.rglob('*')), listing)
        self.assertEqual(os.listdir(self.root / 'cache' / 'k1'), ['Alpha.olean'])


class TheRun(Root):
    """run() on a temporary root. git_state, checker, plan, lacking and build are stand-ins, and so is the process
    run_printer starts, which gives the output and the exit code the test sets; run_printer itself, parse_output and
    the writing are the tool's own. No git, no checker and no Lean is started."""

    def setUp(self):
        super().setUp()
        self.put_receipt(receipt(theorems={'Becoming.Alpha': 2, 'RelationalRenewal': 1}))
        self.lean = self.root / proof_uses.LEAN_ROOT
        for m, text in TEXTS.items():
            path = self.lean / self.receipt['source_paths'][m]
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text)
        self.heads = ['c0ffee']        # what git gives for HEAD, call after call; the last is given from then on
        self.dirty = []                # the Lean files git gives as differing from HEAD
        self.lack = ['compile ' + proof_uses.STUB, 'audit ' + proof_uses.STUB]
        self.output, self.exit = printed(rows()), 0
        self.while_lean_runs = lambda: None
        self.calls = []

        def git_state(root, r):
            self.calls.append('git')
            return (self.heads.pop(0) if len(self.heads) > 1 else self.heads[0]), list(self.dirty)

        def build(root, tree):
            self.calls.append('build')
            return {'ran': list(self.lack)}

        def process(command, **more):
            self.calls.append('lean')
            self.while_lean_runs()
            return SimpleNamespace(returncode=self.exit, stdout=self.output.encode())

        cb = SimpleNamespace(audit_support=SimpleNamespace(TOOLCHAIN=self.receipt['toolchain']), CACHE=self.root / 'cache',
                             RUNNER='r', FRESH=False, lean_slot=contextlib.nullcontext)
        for name, stand_in in (('git_state', git_state), ('checker', lambda root: cb), ('build', build),
                               ('plan', lambda cb, r, stub: (['a step'] * 5, ['lean'])),
                               ('lacking', lambda steps, cache, runner, fresh=False: list(self.lack))):
            patch = mock.patch.object(proof_uses, name, stand_in)
            patch.start()
            self.addCleanup(patch.stop)
        patch = mock.patch.object(proof_uses.subprocess, 'run', process)
        patch.start()
        self.addCleanup(patch.stop)

    def run_it(self, **more):
        with contextlib.redirect_stderr(io.StringIO()):
            return proof_uses.run(self.root, **more)

    def refusal(self, **more):
        with self.assertRaises(proof_uses.Refused) as raised:
            self.run_it(**more)
        return str(raised.exception)

    def source(self, module):
        return self.lean / self.receipt['source_paths'][module]

    def test_a_run_writes_the_print_of_the_commit_and_the_core_run_and_a_second_changes_nothing(self):
        summary = self.run_it()
        self.assertEqual(self.calls, ['git', 'build', 'lean', 'git'])
        self.assertEqual((summary['modules'], summary['theorems'], summary['uses_without_row'], summary['module_files_changed'],
                          summary['index_changed'], summary['steps_the_cache_lacked']), (3, 4, 1, 3, True, 2))
        index, read = proof_uses.read_print(self.directory)
        self.assertEqual(index['printed_from'], {'commit': 'c0ffee', 'core_run': UTC})
        self.assertEqual(index['format'], proof_uses.FORMAT)
        self.assertEqual({m: [r['name'] for r in found] for m, found in read.items()},
                         {m: sorted(r['name'] for r in found) for m, found in rows().items()})
        found = proof_uses.status(self.root)
        self.assertEqual((found['bound'], found['kind'], found['problems'], found['damage']), (True, 'bound', [], []))
        # what Lean was given and what it printed are kept in the tool's own tree, apart from the print
        tree = self.root / proof_uses.TREE
        self.assertIn('"RelationalRenewal"', (tree / '.printer' / 'ProofUses.lean').read_text(encoding='utf-8'))
        self.assertEqual((tree / '.printer' / 'output.txt').read_text(encoding='utf-8'), self.output)
        self.assertTrue((tree / (proof_uses.STUB + '.lean')).read_text().startswith('import Becoming.Alpha\n'))
        before = self.stamps()
        again = self.run_it()
        self.assertEqual((again['module_files_changed'], again['module_files_removed'], again['index_changed']), (0, [], False))
        self.assertEqual(self.stamps(), before)

    def test_lean_that_failed_or_printed_short_is_refused_in_those_words_and_nothing_is_written(self):
        good = printed(rows())
        cases = {
            'cut before the count line': (good[:good.rindex('COUNT')], 0, None),
            'cut in the middle of a row': (good[:40], 0, None),
            'an exit other than 0': (good, 1, None),
            'a panic with exit 0': (printed(rows(), before=['PANIC at Array.get!Internal Init.GetElem:171:2: index out of bounds']), 0, None),
            'an error line with exit 0': (printed(rows(), before=['ProofUses.lean:60:2: error: unknown identifier']), 0, None),
            'no row at all': (printed({}), 0, None),
            'a module whose rows were dropped inside Lean': (printed(dict(rows(), RelationalRenewal=[])), 0, 'RelationalRenewal'),
            'fewer rows of a module than the receipt counts theorems': (
                printed(dict(rows(), **{'Becoming.Alpha': rows()['Becoming.Alpha'][:1]}), uses=None), 0, 'Becoming.Alpha'),
        }
        for what, (output, code, named) in cases.items():
            with self.subTest(what=what):
                self.output, self.exit, self.calls = output, code, []
                said = self.refusal()
                self.assertTrue(said.startswith(proof_uses.LEAN_SHORT), said)
                if named:
                    self.assertIn('fewer rows than the receipt counts theorems', said)
                    self.assertIn(named, said)
                self.assertEqual(self.calls[:3], ['git', 'build', 'lean'])
                self.assertFalse(self.directory.exists())

    def test_a_refused_run_leaves_an_earlier_print_as_it_was(self):
        self.run_it()
        before = self.stamps()
        self.output = printed(dict(rows(), RelationalRenewal=[]))
        self.assertTrue(self.refusal().startswith(proof_uses.LEAN_SHORT))
        self.heads = ['c0ffee', 'decaf']
        self.output = printed(rows())
        self.assertTrue(self.refusal().startswith(proof_uses.MOVED))
        self.assertEqual(self.stamps(), before)

    def test_a_tree_that_moved_while_lean_ran_is_refused_in_those_words_and_nothing_is_written(self):
        def edit():
            self.source('Becoming.Beta').write_text('beta, edited while Lean ran')

        def unedit():
            self.source('Becoming.Beta').write_text('beta')

        moves = {
            'HEAD is another commit': (lambda: self.heads.__setitem__(slice(None), ['decaf']), lambda: None, 'decaf'),
            'a source was edited': (edit, unedit, 'Becoming.Beta'),
            'a Lean file came to differ from HEAD': (lambda: self.dirty.append('Becoming/Alpha.lean'), self.dirty.clear,
                                                     'Becoming/Alpha.lean'),
        }
        for what, (move, undo, named) in moves.items():
            with self.subTest(what=what):
                self.heads, self.calls, self.while_lean_runs = ['c0ffee'], [], move
                said = self.refusal()
                undo()
                self.assertTrue(said.startswith(proof_uses.MOVED), said)
                self.assertIn(named, said)
                self.assertIn('Nothing was written', said)
                self.assertEqual(self.calls[:3], ['git', 'build', 'lean'])
                self.assertFalse(self.directory.exists())

    def test_a_refusal_before_lean_begins_with_the_words_that_tell_which_it_is(self):
        self.dirty = [proof_uses.PACKAGE + '/Becoming/Alpha.lean']
        said = self.refusal()
        self.assertTrue(said.startswith(proof_uses.NOT_A_COMMIT), said)
        self.assertIn('Becoming/Alpha.lean', said)
        self.dirty = []

        self.source('Becoming.Beta').write_text('beta, edited after the core run')
        said = self.refusal()
        self.assertTrue(said.startswith(proof_uses.NOT_THE_BYTES), said)
        self.assertIn('Becoming.Beta', said)
        self.assertIn('check_becoming.py', said)
        self.source('Becoming.Beta').write_text('beta')

        self.lack = [f'compile Becoming.M{n}' for n in range(9)]
        said = self.refusal()
        self.assertTrue(said.startswith('the cache lacks 9 steps: '), said)
        for hint in ('no fault', 'right after a passing core run of the same tree', 'before the render', '--build'):
            self.assertIn(hint, said)
        self.assertTrue(self.refusal(max_steps=8).startswith('the cache lacks 9 steps: '))
        self.lack = ['compile ' + proof_uses.STUB]
        self.assertTrue(self.refusal(max_steps=0).startswith('the cache lacks 1 step: '))

        self.assertNotIn('build', self.calls)  # none of these reached the scratch build
        self.assertNotIn('lean', self.calls)
        self.assertFalse(self.directory.exists())

    def test_build_lets_a_run_go_on_however_many_steps_the_cache_lacks(self):
        self.lack = [f'compile Becoming.M{n}' for n in range(9)]
        summary = self.run_it(build_all=True)
        self.assertEqual((summary['steps_the_cache_lacked'], len(summary['steps_run'])), (9, 9))
        self.assertEqual(proof_uses.status(self.root)['kind'], 'bound')
        self.lack = self.lack[:3]
        self.calls = []
        self.run_it()  # as many as --max-steps allows go on unasked
        self.assertEqual(self.calls, ['git', 'build', 'lean', 'git'])

    def test_the_five_first_words_are_told_apart_and_other_refusals_use_none_of_them(self):
        five = [proof_uses.NOT_A_COMMIT, proof_uses.NOT_THE_BYTES, 'the cache lacks ', proof_uses.LEAN_SHORT, proof_uses.MOVED]
        for a in five:
            for b in five:
                self.assertTrue(a == b or not a.startswith(b[:12]), (a, b))
        self.assertTrue(proof_uses.cache_refusal(7, 3).startswith('the cache lacks 7 steps: '))
        others = {
            'a receipt that did not pass': dict(self.receipt, status='failed'),
            'a receipt without the time of its run': {k: v for k, v in self.receipt.items() if k != 'utc'},
            'a receipt of another toolchain than the checker': dict(self.receipt, toolchain='leanprover/lean4:v4.30.0'),
        }
        kept = self.receipt
        for what, r in others.items():
            with self.subTest(what=what):
                self.put_receipt(r)
                said = self.refusal()
                self.assertFalse(any(said.startswith(first) for first in five), said)
        self.put_receipt(kept)
        self.assertNotIn('lean', self.calls)
        self.assertFalse(self.directory.exists())


class Help(unittest.TestCase):
    def test_the_help_says_when_to_run_the_tool(self):
        text = ' '.join(proof_uses.argument_parser().format_help().split())
        for said in ('When to run it.', 'Right after a passing core run of the same tree',
                     'when the checker\'s cache holds every step', 'and before the render',
                     'Run before the core run, it refuses: for lack of cached steps', 'That refusal is not a fault',
                     '--build compiles what the cache lacks'):
            self.assertIn(said, text)
        for first in (proof_uses.NOT_A_COMMIT, proof_uses.NOT_THE_BYTES, proof_uses.LEAN_SHORT, proof_uses.MOVED):
            self.assertIn(first.rstrip(': '), text)  # the help names the refusals by the words they begin with
        self.assertIn('the cache lacks N steps', text)


if __name__ == '__main__':
    unittest.main()
