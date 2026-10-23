#!/usr/bin/env python3
"""OU4 landing texts: python3 -B <kit>/land3.py SECTION (from the worktree root after the checker and registration)."""
import json
import re
import subprocess
import sys
from pathlib import Path
ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
N = sys.argv[1]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
BOARD = '_process/BECOMING-WORKBOARD.md'
rid = json.loads((ROOT / PKG / 'becoming-verification.json').read_text())['utc']
R = json.loads((ROOT / PKG / 'becoming-checks' / rid / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.GrammarMap')
st = (ROOT / STUDY).read_text(encoding='utf-8')
last = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M))
assert int(N) == last + 1, (N, last)
sec = (HERE / 'study_ou4.txt').read_text(encoding='utf-8').replace('## 373.', f'## {N}.').replace(
    'RECEIPT_ID', rid).replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations'])))
(ROOT / STUDY).write_text(st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n', encoding='utf-8')
b = (ROOT / BOARD).read_text(encoding='utf-8')
old = "next OU3b (the master laws, with EC's owner) and the theorems that read activity only"
assert b.count(old) == 1
b = b.replace(old, f"**OU4 landed** (the map at two grains: generation, keeping, degeneration; Becoming.GrammarMap, "
                   f"core receipt `{rid}`, record generation-and-degeneration-at-two-grains, study §{N}); next OU3b (the "
                   "master laws, with EC's owner), the theorems that read activity only, and the old regimes as regions")
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", b)
b = b.replace(m.group(0), f"the latest core receipt is OU4's `{rid}` (23 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', b)
b = b.replace(m.group(0), '- **Queue:** ' + f'OU4 landed (the map at two grains; core receipt `{rid}`, study §{N})' + '; ' + m.group(1))
(ROOT / BOARD).write_text(b, encoding='utf-8')
subprocess.run([sys.executable, '-B', str(HERE / 'make_record3.py'), N, rid], check=True)
print('STUDY_SECTION', N, 'RECEIPT', rid)
