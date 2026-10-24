#!/usr/bin/env python3
"""OU1's landing texts, from the worktree root after the core checker run and register.py:
python3 -B <kit>/land_ou1.py SECTION
Appends the study section, updates the board (the OU row, the latest receipt, the queue) and writes the record."""
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
N = sys.argv[1]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = f'{RF}/BECOMING-RENEWAL-READING.md'
BOARD = '_process/BECOMING-WORKBOARD.md'

ptr = json.loads((ROOT / PKG / 'becoming-verification.json').read_text())
rid = ptr['utc']
R = json.loads((ROOT / PKG / 'becoming-checks' / rid / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Grammar')
thm, decl = mod['theorems'], len(mod['declarations'])

# --- the study section
st = (ROOT / STUDY).read_text(encoding='utf-8')
assert f'\n## {N}. ' not in st and '(OU1)' not in st
last = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M))
assert int(N) == last + 1, ('section number', N, last)
sec = (HERE / 'study_ou1.txt').read_text(encoding='utf-8')
sec = sec.replace('## 371.', f'## {N}.').replace('RECEIPT_ID', rid).replace('THEOREMS', str(thm)).replace('DECLS', str(decl))
(ROOT / STUDY).write_text(st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n', encoding='utf-8')

# --- the board
b = (ROOT / BOARD).read_text(encoding='utf-8')
old_state = ('claimed 2026-10-23 on `0cc1aafb4`; plan v9 under review (GPT astra done, two Opus reviews running); OU0 corpus '
             'freeze running; OU1 drafted in scratch, every declaration with an empty axiom report')
assert b.count(old_state) == 1
new_state = (f'claimed 2026-10-23 on `0cc1aafb4`; plan v10 (three reviews of v9 taken); **OU1 landed** (core receipt `{rid}`, '
             f'`Becoming.Grammar` {thm} theorems in {decl} declarations, empty axiom reports; record '
             f'continuation-relative-to-a-class; study §{N}); OU0: corpus frozen (2,997 units), classification running; '
             'next OU2 and OU3')
b = b.replace(old_state, new_state)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", b)
assert m, 'latest receipt sentence'
b = b.replace(m.group(0), f"the latest core receipt is OU1's `{rid}` (23 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', b)
assert m
landed = (f'OU1 landed (the grammar: continuation relative to a class, for every carrier and relation; '
          f'`Becoming.Grammar`, core receipt `{rid}`, study §{N}, record continuation-relative-to-a-class; a leaf until '
          'OU3)')
b = b.replace(m.group(0), '- **Queue:** ' + landed + '; ' + m.group(1))
(ROOT / BOARD).write_text(b, encoding='utf-8')

# --- the record
subprocess.run([sys.executable, '-B', str(HERE / 'make_record.py'), N, rid], check=True)
print('STUDY_SECTION', N)
print('RECEIPT', rid, thm, decl)
