#!/usr/bin/env python3
"""OU3f: print the source of declarations by their short name (as the statements helper prints them) from a module.
usage (from the checkout root): python3 -B <kit>/source.py MODULE NAME [NAME ...] [--max N]"""
import re
import sys
from pathlib import Path

PKG = Path('experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming')
args = [a for a in sys.argv[1:] if not a.startswith('--')]
mx = int(sys.argv[sys.argv.index('--max') + 1]) if '--max' in sys.argv else 40
module, names = args[0], args[1:]
lines = (PKG / f'{module}.lean').read_text(encoding='utf-8').split('\n')
for name in names:
    short = name.split('.')[-1]
    pat = re.compile(r'^(?:private |protected )?(theorem|def|lemma) ' + r'(?:[\w.«»]*\.)?' + re.escape(short) + r'\b')
    hits = [i for i, l in enumerate(lines) if pat.match(l) and (name.split('.')[-2] in l if '.' in name else True)]
    if not hits:
        hits = [i for i, l in enumerate(lines) if pat.match(l)]
    for i in hits[:1]:
        j = i + 1
        while j < len(lines) and j - i < mx and not re.match(r'^(theorem|def|lemma|instance|/--|/-!|end |section|namespace|variable|private |protected )', lines[j]):
            j += 1
        print(f'--- {name} ({module}:{i + 1})')
        print('\n'.join(lines[i:j]).rstrip())
