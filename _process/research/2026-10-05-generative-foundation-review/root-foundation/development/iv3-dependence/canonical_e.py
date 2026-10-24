#!/usr/bin/env python3
"""IV3e: the canonical chapter's bullet on what self-concern reaches through dependence (EN, ZH): its capacity clause
is now exact.
usage (from the checkout root): python3 -B canonical_e.py"""
from pathlib import Path

ROOT = Path.cwd()
CH = ROOT / 'theories/becoming/chapters'
EDITS = [
    (CH / 'THE-THEORY-OF-BECOMING.md',
     'copies count by capacity, and it reaches a copy wherever the others could not together give what is drawn.',
     'copies count by capacity, and it reaches a copy exactly where the others could not together give what is drawn.'),
    (CH / 'THE-THEORY-OF-BECOMING.zh.md',
     '副本按容量而非数目计，凡其余者合起来给不出所汲取者之处，它都达到该副本。',
     '副本按容量而非数目计，它恰在其余者合起来给不出所汲取者之处达到该副本。'),
]
for path, old, new in EDITS:
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')
    print('wrote', path.relative_to(ROOT))
