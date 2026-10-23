#!/usr/bin/env python3
"""IV3g: the canonical chapter's bullet on what self-concern reaches through dependence (EN, ZH) gains need in
degree.
usage (from the checkout root): python3 -B canonical_g.py"""
from pathlib import Path

ROOT = Path.cwd()
CH = ROOT / 'theories/becoming/chapters'
EDITS = [
    (CH / 'THE-THEORY-OF-BECOMING.md',
     'Need climbs a hierarchy: drawing past what the families it draws on, and those feeding them, hold, it reaches '
     'what feeds their top. ',
     'Need climbs a hierarchy: drawing past what the families it draws on, and those feeding them, hold, it reaches '
     'what feeds their top. It reaches a feeder in degree: the least the feeder gives while the center draws past the '
     'stock is the sum of what each step demands beyond what the others can give. '),
    (CH / 'THE-THEORY-OF-BECOMING.zh.md',
     '它达到供给其顶层者。',
     '它达到供给其顶层者。它按程度达到供给者：中心汲取超出存量时供给者至少要给的，是每步需求超出其余者合起来能给者之和。'),
]
for path, old, new in EDITS:
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')
    print('wrote', path.relative_to(ROOT))
