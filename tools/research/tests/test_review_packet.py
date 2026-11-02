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
from pathlib import Path
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[3]
CHECKER = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/review-packet/check_dossiers.py'
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


if __name__ == '__main__':
    unittest.main()
