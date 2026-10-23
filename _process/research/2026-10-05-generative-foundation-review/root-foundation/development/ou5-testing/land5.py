#!/usr/bin/env python3
"""OU5 landing texts after land3.py: python3 -B <kit>/land5.py (section = the study's last + 1)."""
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
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.GrammarTesting')
st = (ROOT / STUDY).read_text(encoding='utf-8')
N = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M)) + 1
sec = (HERE / 'study_ou5.txt').read_text(encoding='utf-8').replace('## 374.', f'## {N}.').replace(
    'RECEIPT_ID', rid).replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations'])))
(ROOT / STUDY).write_text(st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n', encoding='utf-8')
b = (ROOT / BOARD).read_text(encoding='utf-8')
old = "next OU3b (the master laws, with EC's owner), the theorems that read activity only, and the old regimes as regions"
assert b.count(old) == 1
b = b.replace(old, f"**OU5 landed** (testing within the net: Becoming.GrammarTesting, record testing-within-the-net, study "
                   f"§{N}); next OU3b (the master laws, with EC's owner), the theorems that read activity only, and the old "
                   "regimes as regions")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', b)
b = b.replace(m.group(0), '- **Queue:** ' + f'OU5 landed with OU4 (testing within the net; study §{N})' + '; ' + m.group(1))
(ROOT / BOARD).write_text(b, encoding='utf-8')
subprocess.run([sys.executable, '-B', str(HERE / 'make_record5.py'), str(N), rid], check=True)
print('STUDY_SECTION', N)
