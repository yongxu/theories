#!/usr/bin/env python3
"""IV3d: the canonical chapter's bullet on what self-concern reaches through dependence (EN, ZH). With capacities the
copies clause holds only where each copy could carry the need alone; the bullet says so and adds the capacity clause.
usage (from the checkout root): python3 -B canonical_d.py"""
from pathlib import Path

ROOT = Path.cwd()
CH = ROOT / 'theories/becoming/chapters'
EDITS = [
    (CH / 'THE-THEORY-OF-BECOMING.md',
     'Drawn along need, it reaches a copy only where the copy is the only one. An order',
     'Drawn along need, it reaches a copy only where the copy is the only one, when each copy could carry the need '
     'alone; copies count by capacity, and it reaches a copy wherever the others could not together give what is '
     'drawn. An order'),
    (CH / 'THE-THEORY-OF-BECOMING.zh.md',
     '沿“所需”来画，它只在某个副本是唯一者时达到该副本。只把',
     '沿“所需”来画，在每个副本都能单独承担所需时，它只在某个副本是唯一者时达到该副本；副本按容量而非数目计，凡其余者合起来给不出所汲取者之处，'
     '它都达到该副本。只把'),
]
for path, old, new in EDITS:
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')
    print('wrote', path.relative_to(ROOT))
