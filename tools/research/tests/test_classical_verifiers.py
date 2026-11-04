"""The classical-text verifiers (board item RAE): the RO map's verify_ro.py and the ZH map's verify_zh.py, each run
on the repository as it stands, so research-test fails where 06-CLASSICAL-TEXTS, the two passage maps, the records and
the newest core receipt no longer agree. Each checks its fragments against the preserved texts, its declarations
against the newest core receipt, its records against theories/becoming/results/records, and the numbers 06 states of
its map against the map."""
from pathlib import Path
import subprocess
import sys
import unittest

ROOT = Path(__file__).resolve().parents[3]
DEV = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development'


def run(script, *flags):
    return subprocess.run([sys.executable, *flags, str(script)], cwd=script.parent, capture_output=True, text=True)


class ClassicalVerifierTests(unittest.TestCase):
    def test_ro_map_verifies(self):
        out = run(DEV / 'ro-relational-sources/verify_ro.py', '-B')
        self.assertEqual(out.returncode, 0, out.stdout[-3000:] + out.stderr[-2000:])
        self.assertIn('rows of its table of counts agree', out.stdout)

    def test_zh_map_verifies(self):
        out = run(DEV / 'zhonghua/verify_zh.py', '-I')
        self.assertEqual(out.returncode, 0, out.stdout[-3000:] + out.stderr[-2000:])
        self.assertIn('stated numbers', out.stdout)


if __name__ == '__main__':
    unittest.main()
