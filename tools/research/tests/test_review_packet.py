"""Keep the review packet's quotations and Lean names true to their sources.

The packet in theories/becoming/review/ goes to human reviewers. Its dossiers quote chapters, records and studies
that keep changing, and cite Lean declarations that get renamed. The packet's own checker, check_dossiers.py in
its kit (development/review-packet/), checks every quotation against the file it names, every Lean name against
the sources and every copied Lean statement against its source; this test runs it over the whole packet, so a
change that breaks a quotation is found at landing, not by a reviewer. A quote-only change to a chapter now has to
keep the dossiers in step: for a packet about to go to people, that is the right cost.

On failure, update the dossier's quotation or Lean name, or tell its owner on the work board: RP for README,
CLASSICAL-TEXTS, BUDDHIST-THOUGHT and LOGIC; RP2 for PHILOSOPHY; AJ4 for ALIGNMENT.
"""
import contextlib
import importlib.util
import io
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[3]
CHECKER = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/review-packet/check_dossiers.py'
RESYNC = CHECKER.with_name('resync_report.py')
PACKET = ROOT / 'theories/becoming/review'
OWNERS = {'PHILOSOPHY.md': 'RP2', 'ALIGNMENT.md': 'AJ4'}  # every other part of the packet: RP


def load_checker():
    spec = importlib.util.spec_from_file_location('check_dossiers', CHECKER)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class ReviewPacketTest(unittest.TestCase):
    def test_quotations_and_lean_names_hold(self):
        paths = sorted(str(p) for p in PACKET.glob('*.md')) + [str(PACKET / 'recoding/CODEBOOK.md')]
        self.assertTrue(paths, 'no dossiers found in ' + str(PACKET))
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            status = load_checker().main(paths)
        problems = []
        for line in out.getvalue().splitlines():
            if line.endswith('problem(s)'):
                continue
            name = Path(line.split(':', 1)[0]).name
            problems.append(f'{line}  [tell {OWNERS.get(name, "RP")}]')
        self.assertEqual(status, 0 if not problems else 1)
        self.assertEqual(problems, [], 'review packet out of step with its sources:\n' + '\n'.join(problems))

    def check_block(self, lean):
        with tempfile.TemporaryDirectory() as scratch:
            dossier = Path(scratch) / 'X.md'
            dossier.write_text(f'```lean\n{lean}\n```\n', encoding='utf-8')
            out = io.StringIO()
            with contextlib.redirect_stdout(out):
                status = load_checker().main([str(dossier)])
        return status, out.getvalue()

    def test_lean_blocks_are_compared_with_their_sources(self):
        stated = ('theorem ReadsOnlyDynamics.not_entails {D : Type} {law : D → (Pos → Nat → F → Prop) → Prop}\n'
                  '    (reads : ReadsOnlyDynamics law) (entails : ∀ d sig, law d sig → Unrestricted sig)\n'
                  '    (p : Pos) (f : F) {d : D} {sig : Pos → Nat → F → Prop} : ¬ law d sig')
        definition = ('def ReadsOnlyDynamics {D : Type} (law : D → (Pos → Nat → F → Prop) → Prop) : Prop :=\n'
                      "  ∀ d sig sig', law d sig → law d sig'")
        self.assertEqual(self.check_block(stated)[0], 0)
        self.assertEqual(self.check_block(definition)[0], 0)
        for changed in (stated.replace('¬ law d sig', 'law d sig'),  # another conclusion
                        stated.split('\n    (reads')[0],  # cut before its proof
                        definition.replace("law d sig'", 'False'),  # another body
                        definition.rsplit(' → ', 1)[0],  # a body cut short
                        'theorem seed_is_needed :\n    let V',  # cut inside its own `:=`
                        'theorem seed_is_needed :\n    let V := valuation linked (fun _ _ => False)',
                        'partial ' + definition.replace("law d sig'", 'False'),
                        'example : False'):
            status, said = self.check_block(changed)
            self.assertEqual(status, 1, changed)
            self.assertIn('Lean block differs from the sources', said)


class ResyncReportTest(unittest.TestCase):
    """A re-sync reads the report, so what the report counts must have a line. Rows with no text once shared one key."""

    def report(self, before, after, dossier):
        with tempfile.TemporaryDirectory() as scratch:
            root = Path(scratch)
            env = {k: v for k, v in os.environ.items() if not k.startswith('GIT_')}

            def commit(files):
                for name, text in files.items():
                    (root / name).parent.mkdir(parents=True, exist_ok=True)
                    (root / name).write_text(text, encoding='utf-8')
                for args in (['add', '-A'], ['-c', 'user.name=t', '-c', 'user.email=t@t', 'commit', '-qm', 'x']):
                    subprocess.run(['git', *args], cwd=root, env=env, check=True, capture_output=True)

            subprocess.run(['git', 'init', '-q'], cwd=root, env=env, check=True)
            commit({**before, 'review/X.md': dossier})
            pin = subprocess.run(['git', 'rev-parse', 'HEAD'], cwd=root, env=env, check=True, capture_output=True, text=True).stdout.strip()
            commit(after)
            run = subprocess.run([sys.executable, '-B', str(RESYNC), pin, 'review/X.md', '--out', 'out.md'], cwd=root, env=env,
                                 capture_output=True, text=True)
            self.assertEqual(run.returncode, 0, run.stderr)
            return run.stdout, (root / 'out.md').read_text(encoding='utf-8')

    def test_every_change_it_counts_gets_a_line(self):
        section = ('# S\n\n<a id="named"></a>\n## Named\n\nNamed {0}.\n\n## A `plain` heading\n\nPlain {0}.\n\n'
                   'Paragraph with alpha and beta, {0}.\n')
        before = {'docs/one.md': 'one\n', 'docs/two.md': 'two\n', 'docs/same.md': 'same\n', 'data/t.tsv': 'a\t1\n',
                  'docs/s.md': section.format('old')}
        after = {'docs/one.md': 'one now\n', 'docs/two.md': 'two now\n', 'data/t.tsv': 'a\t2\n', 'docs/s.md': section.format('new'),
                 'docs/new.md': 'new\n'}
        dossier = ('# X\n\n## A-1 First\n\n[one](../docs/one.md), [two](../docs/two.md), [same](../docs/same.md), '
                   '[table](../data/t.tsv), [folder](../data), [a URL](https://example.org/url.md).\n'
                   '[named](../docs/s.md#named), [plain](../docs/s.md#a-plain-heading).\n'
                   '引〔docs/s.md〕：「alpha」 and Quote [docs/s.md]: "beta"\n\n'
                   '## A-2 Second\n\n[one again](../docs/one.md), [new](../docs/new.md), [lost](../docs/s.md#nowhere).\n\n'
                   '```lean\nexample : arr[i](j) = 0\n```\n')
        summary, text = self.report(before, after, dossier)
        first, _, second = text.partition('\n## A-2')
        for name in ('one.md', 'two.md', 't.tsv', 'data'):
            self.assertRegex(first, r'whole file changed[^\n]*, ' + name + r' \(.*\):\n', name)
        self.assertRegex(first, r'section changed\*\*, s\.md \(named\)')
        self.assertRegex(first, r'section changed\*\*, s\.md \(a-plain-heading\)')
        self.assertRegex(first, r'paragraph changed\*\*, s\.md \(beta\): as above')
        self.assertRegex(second, r'one\.md \(.*\): as under A-1 First')
        self.assertRegex(second, r'new since the pin[^\n]*, new\.md')
        self.assertRegex(second, r'anchor not found[^\n]*, s\.md \(nowhere\)')
        for absent in ('same.md', 'url.md', '(j'):
            self.assertNotIn(absent, text)
        self.assertIn('linked files 6: 4 changed, 1 new since the pin, 0 gone', summary)
        self.assertIn('1 anchors not found', summary)
        self.assertIn('items to re-read 2 of 2', summary)


if __name__ == '__main__':
    unittest.main()
