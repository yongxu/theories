#!/usr/bin/env python3
"""UE24: UE8's draft dossier (development/ue8-sciences-dossier/SCIENCES.md, not yet in the packet) brought to the
chapters as they stand. Four quotations earlier landings left behind (08's shape of the third parts and its verdict on
the habit's lock, 03's averages of logarithms, 07's open candidate) are re-quoted from the current text, and S-15's
paragraph on the identical-cells candidate gains UE24's law under noise. Every edit is asserted to apply once, and the
packet's checker (check_dossiers.py) must report no problem afterwards.
usage (from the checkout root, after texts_ue24.py): python3 -B <kit>/dossier_ue24.py"""
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development'
DOSSIER = ROOT / DEV / 'ue8-sciences-dossier/SCIENCES.md'
CH08 = 'Quote [theories/becoming/chapters/08-METHOD.md]: '
EDITS = [
    (CH08 + '"Each joins a framework that lacks conservation, renewal over time or a threshold to a premise or law of '
     'the theory, and forbids what the conjunction forbids. Each forbidden statement is known in a neighbouring field',
     CH08 + '"Each joins a framework that lacks conservation, renewal over time or a threshold to a premise or law of '
     'the theory, and forbids what the conjunction forbids. ... Each forbidden statement is known in a neighbouring '
     'field'),
    (CH08 + '"What the law adds is exactness for a simplified model and its edges, so as a containment of the '
     'free-energy principle it is a restatement with its third part open."',
     CH08 + '"What the law adds is exactness for a simplified model and its edges, so as a containment of the '
     'free-energy principle it is a restatement"; the containment\'s third parts lie in 05 §9, 05 §1 and 03 §6.'),
    ('"The paper\'s own simulation broke the symmetry with small random initial expectations."',
     '"The paper\'s own simulation broke the symmetry with small random initial expectations." Under noise of one law '
     'at every cell the law gives way to an exchangeable law, which decides nothing of which cell takes which place '
     'and forbids nothing of the paper, whose scheme has that form ([record](../../../../../../theories/becoming/'
     'results/records/identical-cells-under-noise.md)).'),
    ('Quote [theories/becoming/chapters/03-KNOWING.md]: "Averages of logarithms, entropy and free energy among them, '
     'have no counting form here."',
     'Quote [theories/becoming/chapters/03-KNOWING.md]: "Averages of logarithms, entropy and free energy among them, '
     'are not the logarithm of one reciprocal share"; the free-energy bound has a counting form, with its equality, '
     'in the pure core.'),
    ('Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "The candidates left are what a course keeps reachable '
     'and what carries its openings."',
     'Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "The candidate left is what carries a course\'s '
     'openings."'),
]
text = DOSSIER.read_text(encoding='utf-8')
for old, new in EDITS:
    assert text.count(old) == 1, (old[:80], text.count(old))
    text = text.replace(old, new)
DOSSIER.write_text(text, encoding='utf-8')
check = subprocess.run([sys.executable, '-B', f'{DEV}/review-packet/check_dossiers.py', str(DOSSIER.relative_to(ROOT))],
                       cwd=ROOT, capture_output=True, text=True)
print(check.stdout[-2000:], check.stderr[-1000:])
assert check.returncode == 0 and check.stdout.strip().endswith('0 problem(s)'), 'the dossier check fails'
print('dossier: UE8\'s SCIENCES.md, four quotations re-quoted and the law under noise added; check_dossiers passes')
