"""Keep the review packet's quotations and Lean names true to their sources.

The packet in theories/becoming/review/ goes to human reviewers. Its dossiers quote chapters, records and studies
that keep changing, and cite Lean declarations that get renamed. The packet's own checker, check_dossiers.py in
its kit (development/review-packet/), checks every quotation against the file it names and every Lean name against
the sources; this test runs it over the whole packet, so a change that breaks a quotation is found at landing, not
by a reviewer. A quote-only change to a chapter now has to keep the dossiers in step: for a packet about to go to
people, that is the right cost.

On failure, update the dossier's quotation or Lean name, or tell its owner on the work board: RP for README,
CLASSICAL-TEXTS, BUDDHIST-THOUGHT and LOGIC; RP2 for PHILOSOPHY; AJ4 for ALIGNMENT.
"""
import contextlib
import importlib.util
import io
from pathlib import Path
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
        paths = sorted(str(p) for p in PACKET.glob('*.md'))
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


if __name__ == '__main__':
    unittest.main()
