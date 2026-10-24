#!/usr/bin/env python3
"""Copy Lean statements for the philosophy dossier (RP2) from the source files: theorems and lemmas cut at `:=`,
definitions whole (to the first blank line). usage: python3 -B lean_statements.py NAME ..."""
import re, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[6]
CORE = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming'


def find(name):
    short = name.split('.')[-1]
    alts = '|'.join(re.escape(x) for x in dict.fromkeys([name, short]))
    pat = re.compile(r'^\s*(?:@\[[^\]]*\]\s*)?(?:private\s+|protected\s+|noncomputable\s+)*(theorem|lemma|def|abbrev|structure|inductive)\s+(' + alts + r')(?=[\s(:{\[])', re.M)
    hits = []
    for p in sorted(CORE.rglob('*.lean')):
        t = p.read_text(encoding='utf-8')
        for m in pat.finditer(t):
            kind = m.group(1)
            start = m.start()
            if kind in ('theorem', 'lemma'):
                end = t.find(':=', m.end())
                stmt = t[start:end].rstrip()
            else:
                end = t.find('\n\n', m.end())
                stmt = t[start:end if end > 0 else len(t)].rstrip()
            hits.append((p.relative_to(CORE.parent), stmt))
    return hits


for n in sys.argv[1:]:
    hs = find(n)
    if not hs:
        print(f'-- NOT FOUND: {n}\n')
    for p, s in hs:
        print(f'-- {n}  [{p}]\n{s}\n')
