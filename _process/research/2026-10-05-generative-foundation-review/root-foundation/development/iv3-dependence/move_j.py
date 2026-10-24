#!/usr/bin/env python3
"""IV3j: after further landings took the study numbers and added Lean, move IV3j's study section from FROM to the next free
number and the record from OLD to NEW receipt (the run on the newly merged tree; same Weightings source). Main's study is
taken first; the section is appended from study_iv3j.txt; D64 item 13 and the record follow. The board row is re-landed
with board_j.py and 08-METHOD's counts with receipts_j.py.
usage (from the checkout root, mid-merge, after the checker): python3 -B move_j.py FROM OLD_RECEIPT NEW_RECEIPT"""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
FROM, OLD, NEW = int(sys.argv[1]), sys.argv[2], sys.argv[3]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = ROOT / (RF + 'BECOMING-RENEWAL-READING.md')
SOURCE = f'{PKG}/Becoming/Weightings.lean'
R = json.loads((ROOT / PKG / 'becoming-checks' / NEW / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.Weightings')
assert not any(mod['axiom_dependencies'].values())
assert R['source_sha256']['Becoming.Weightings'] == hashlib.sha256((ROOT / SOURCE).read_bytes()).hexdigest()

st = STUDY.read_text(encoding='utf-8')
assert '(IV3j)' not in st
N = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M)) + 1
sec = (HERE / 'study_iv3j.txt').read_text(encoding='utf-8')
sec = (sec.replace('## {N}.', f'## {N}.').replace('RECEIPT_ID', NEW)
       .replace('THEOREMS', str(mod['theorems'])).replace('DECLS', str(len(mod['declarations']))))
STUDY.write_text(st.rstrip('\n') + '\n\n' + sec.rstrip('\n') + '\n', encoding='utf-8')


def move(path, pairs, every=()):
    p = ROOT / path
    s = p.read_text(encoding='utf-8')
    for a, b in pairs:
        assert s.count(a) == 1, (path, a)
        s = s.replace(a, b)
    for a, b in every:
        assert a in s, (path, a)
        s = s.replace(a, b)
    p.write_text(s, encoding='utf-8')


move(RF + 'DELEGATED-CHOICES.md', [(f'(study section {FROM}, IV3j)', f'(study section {N}, IV3j)')])
record = 'theories/becoming/results/records/self-concern-through-dependence.json'
move(record, [(f'388 and {FROM};', f'388 and {N};'), (f'388 与 {FROM} 节', f'388 与 {N} 节'),
              (f'the Routing witness; study section {FROM}.', f'the Routing witness; study section {N}.'),
              (f'Routing 见证；研究第 {FROM} 节', f'Routing 见证；研究第 {N} 节')], every=[(OLD, NEW)])
d = json.loads((ROOT / record).read_text(encoding='utf-8'))
receipt = f'{PKG}/becoming-checks/{NEW}/verification.json'
for ref in d['references']:
    if ref['role'] == 'receipt':
        assert ref['path'] == receipt
        ref['sha256'] = hashlib.sha256((ROOT / receipt).read_bytes()).hexdigest()
d['reviewed_at_utc'] = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
(ROOT / record).write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('IV3j study section', FROM, '->', N, '; receipt', OLD, '->', NEW)
