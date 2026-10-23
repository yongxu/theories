#!/usr/bin/env python3
"""OU2 + OU3a landing texts, from the worktree root after the core checker run and the roots registration:
python3 -B <kit>/land2.py SECTION"""
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
rid = json.loads((ROOT / PKG / 'becoming-verification.json').read_text())['utc']
R = json.loads((ROOT / PKG / 'becoming-checks' / rid / 'verification.json').read_text())
assert R['status'] == 'passed'
st = (ROOT / STUDY).read_text(encoding='utf-8')
last = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M))
assert int(N) == last + 1, ('section number', N, last)
sec = (HERE / 'study_ou2.txt').read_text(encoding='utf-8').replace('## 372.', f'## {N}.').replace('RECEIPT_ID', rid)
(ROOT / STUDY).write_text(st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n', encoding='utf-8')
b = (ROOT / BOARD).read_text(encoding='utf-8')
old = ('OU0: corpus frozen (2,997 units), classification running; next OU2 and OU3')
assert b.count(old) == 1
new = (f'OU0: corpus frozen and classified (2,997 units, `one-unfolding-root/classify/REPORT.md`); **OU2 and OU3a landed** '
       f'(core receipt `{rid}`: the grammar extended, Becoming.GrammarReadings, the continuation family of Arising, '
       f'Change, Identity, ContinuedClasses, PatternPassing, Persistence and Space as its instances; records '
       f'continuation-relative-to-a-class and classical-definitions-in-the-grammar; study §{N}); next OU3b (the master '
       'laws, with EC\'s owner) and the theorems that read activity only')
b = b.replace(old, new)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", b)
assert m
b = b.replace(m.group(0), f"the latest core receipt is OU2 and OU3a's `{rid}` (23 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', b)
landed = (f'OU2 and OU3a landed (the grammar extended and read in the corpus; the old continuation family as its '
          f'instances; core receipt `{rid}`, study §{N})')
b = b.replace(m.group(0), '- **Queue:** ' + landed + '; ' + m.group(1))
(ROOT / BOARD).write_text(b, encoding='utf-8')
subprocess.run([sys.executable, '-B', str(HERE / 'make_records2.py'), N, rid], check=True)
print('STUDY_SECTION', N, 'RECEIPT', rid)
