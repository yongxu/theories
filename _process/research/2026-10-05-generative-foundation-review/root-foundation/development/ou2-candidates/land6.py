#!/usr/bin/env python3
"""OU2c landing texts after land5.py: python3 -B <kit>/land6.py"""
import csv
import collections
import json
import re
import subprocess
import sys
from pathlib import Path
ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
rid = json.loads((ROOT / PKG / 'becoming-verification.json').read_text())['utc']
R = json.loads((ROOT / PKG / 'becoming-checks' / rid / 'verification.json').read_text())
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.GrammarCandidates')
with open(HERE / 'outcomes.tsv', encoding='utf-8') as f:
    cnt = collections.Counter(r['outcome'] for r in csv.DictReader(f, delimiter='\t'))
oc = ', '.join(f'{v} {k}' for k, v in sorted(cnt.items(), key=lambda x: -x[1]))
st = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M)) + 1
sec = (HERE / 'study_ou6.txt').read_text(encoding='utf-8').replace('## 375.', f'## {N}.').replace(
    'RECEIPT_ID', rid).replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations']))).replace('OUTCOMES', oc)
(ROOT / STUDY).write_text(st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n', encoding='utf-8')
b = (ROOT / BOARD).read_text(encoding='utf-8')
old = '**OU5 landed** (testing within the net'
assert b.count(old) == 1
b = b.replace(old, f'**OU2c landed** (the corpus\'s candidate theorems tested: {oc}; Becoming.GrammarCandidates, record '
                   f'candidate-theorems-of-the-corpus, study §{N}); **OU5 landed** (testing within the net')
(ROOT / BOARD).write_text(b, encoding='utf-8')
subprocess.run([sys.executable, '-B', str(HERE / 'make_record6.py'), str(N), rid], check=True)
print('STUDY_SECTION', N)
