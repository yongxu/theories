#!/usr/bin/env python3
"""IV3f: the canonical chapter's bullet on what self-concern reaches through dependence (EN, ZH) gains need up a
hierarchy.
usage (from the checkout root): python3 -B canonical_f.py"""
from pathlib import Path

ROOT = Path.cwd()
CH = ROOT / 'theories/becoming/chapters'
EDITS = [
    (CH / 'THE-THEORY-OF-BECOMING.md',
     'copies count by capacity, and it reaches a copy exactly where the others could not together give what is drawn. ',
     'copies count by capacity, and it reaches a copy exactly where the others could not together give what is drawn. '
     'Need climbs a hierarchy: drawing past what the families it draws on, and those feeding them, hold, it reaches '
     'what feeds their top. '),
    (CH / 'THE-THEORY-OF-BECOMING.zh.md',
     '副本按容量而非数目计，它恰在其余者合起来给不出所汲取者之处达到该副本。',
     '副本按容量而非数目计，它恰在其余者合起来给不出所汲取者之处达到该副本。“所需”沿层级上溯：汲取超出它所取用的诸族及供给这些族的诸族'
     '所持有者时，它达到供给其顶层者。'),
]
for path, old, new in EDITS:
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')
    print('wrote', path.relative_to(ROOT))
