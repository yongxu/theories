#!/usr/bin/env python3
"""OU3f: print the printed statements (the checker's signature audit, main's receipt) of the theorems of a module that
read only `active` by the recount (data/active-only.json), one per line, white space collapsed.
usage (from the checkout root): python3 -B <kit>/statements.py MODULE [--upper-only] [--width N]"""
import importlib.util
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('s3b', ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/kit/signatures_ou3b.py')
s3b = importlib.util.module_from_spec(spec)
spec.loader.exec_module(s3b)
module = sys.argv[1]
width = int(sys.argv[sys.argv.index('--width') + 1]) if '--width' in sys.argv else 400
A = json.loads((HERE.parent / 'data/active-only.json').read_text(encoding='utf-8'))
names = sorted(n for n, t in A.items() if t['module'] == f'Becoming.{module}'
               and ('--upper-only' not in sys.argv or t['upper'] == ['active']))
r = s3b.receipt_at_head()
sig = s3b.parse(s3b.log_of(r, f'Becoming{module}Signatures.log'))
for n in names:
    s = re.sub(r'\s+', ' ', sig.get(n, '(not in the signature log)'))
    s = s.split(' : ', 1)[1] if ' : ' in s else s
    s = s.replace('Becoming.', '').replace('Generative.', '')
    up = '' if A[n]['upper'] == ['active'] else ' [upper: ' + ','.join(A[n]['upper']) + ']'
    print(f"{n.replace('Becoming.', '')}{up} :: {s[:width]}")
