#!/usr/bin/env python3
"""IV3j: move IV3j's study section from FROM to the next free number after a concurrent landing took FROM: main's study
is taken and IV3j's section appended at the new number (from study_iv3j.txt, receipt unchanged); D64 item 13, the record
self-concern-through-dependence and the board's landed row and queue note follow.
usage (from the checkout root, mid-merge, main's study checked out): python3 -B renumber_j.py FROM RECEIPT"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
FROM, RECEIPT = int(sys.argv[1]), sys.argv[2]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = ROOT / (RF + 'BECOMING-RENEWAL-READING.md')
R = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Weightings')

st = STUDY.read_text(encoding='utf-8')
assert '(IV3j)' not in st
N = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M)) + 1
assert N > FROM
sec = (HERE / 'study_iv3j.txt').read_text(encoding='utf-8')
sec = (sec.replace('## {N}.', f'## {N}.').replace('RECEIPT_ID', RECEIPT)
       .replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations']))))
STUDY.write_text(st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n', encoding='utf-8')


def move(path, pairs):
    p = ROOT / path
    s = p.read_text(encoding='utf-8')
    for a, b in pairs:
        assert s.count(a) == 1, (path, a)
        s = s.replace(a, b)
    p.write_text(s, encoding='utf-8')


move(RF + 'DELEGATED-CHOICES.md', [(f'(study section {FROM}, IV3j)', f'(study section {N}, IV3j)')])
move('theories/becoming/results/records/self-concern-through-dependence.json',
     [(f'388 and {FROM};', f'388 and {N};'), (f'388 与 {FROM} 节', f'388 与 {N} 节'),
      (f'the Routing witness; study section {FROM}.', f'the Routing witness; study section {N}.'),
      (f'Routing 见证；研究第 {FROM} 节', f'Routing 见证；研究第 {N} 节')])
move('_process/BECOMING-WORKBOARD.md', [(f'study §{FROM}, record self-concern-through-dependence extended, row in the history file); ',
                                         f'study §{N}, record self-concern-through-dependence extended, row in the history file); ')])
move('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md',
     [(f're-pointed; study §{FROM}; D64 item 13', f're-pointed; study §{N}; D64 item 13')])
print('IV3j study section', FROM, '->', N)
