#!/usr/bin/env python3
"""DF1b landing texts after a passing periphery checker: python3 -B <kit>/land_df1b.py (from the checkout root).

Appends the study section (the study's last + 1) with the entropy-production receipt, sets that section number in
every DF1b history note and in DEFECTS-FOUND's DF1b marks, and adds DF1b to the RA row's DF cell. The board's queue
line is the coordinator's."""
import json
import re
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PHYS = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/physics'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
RECORDS = ROOT / 'theories/becoming/results/records'
DEFECTS = ROOT / '_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md'

R = json.loads((PHYS / 'entropy-production-verification.json').read_text())
assert R['status'] == 'passed'
rid = R['utc']

st = STUDY.read_text(encoding='utf-8')
N = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M)) + 1
sec = (HERE / 'study_df1b.txt').read_text(encoding='utf-8')
sec = sec.replace('## NNN.', f'## {N}.').replace('PRECEIPT', f'`{rid}`')
assert 'NNN' not in sec and 'PRECEIPT' not in sec and 'RECHECK' not in sec
STUDY.write_text(st.rstrip('\n') + '\n\n' + sec.strip('\n') + '\n', encoding='utf-8')

noted = []
for p in sorted(RECORDS.glob('*.json')):
    t = p.read_text(encoding='utf-8')
    if 'DF_N' in t:
        assert t.count('DF_N') == 2 and 'board item DF1b' in t, p.name
        p.write_text(t.replace('DF_N', str(N)), encoding='utf-8')
        noted.append(p.stem)
assert len(noted) == 21, noted

t = DEFECTS.read_text(encoding='utf-8')
k = t.count('*DF: fixed in DF1b')
assert k == 10, k
DEFECTS.write_text(t.replace('*DF: fixed in DF1b', f'*DF: fixed in DF1b (study §{N})'), encoding='utf-8')

b = BOARD.read_text(encoding='utf-8')
rows = [l for l in b.split('\n') if l.startswith('| **RA: repository architecture**')]
assert len(rows) == 1
row = rows[0]
old = '([kit](research/2026-10-05-repository-reconciliation/architecture/df/README.md)); **DF2 next**'
assert row.count(old) == 1
new = ('([kit](research/2026-10-05-repository-reconciliation/architecture/df/README.md)); DF1b landed 27 October 2026 '
       f'(periphery receipt `{rid}`, study §{N}): the ten weak points UE8\'s dossier found and their instances elsewhere '
       '(MQ6 counted as it ran in T1 and T2, witnesses not read as laws, finite bounds not limits, Landauer\'s bound on '
       'heat exported, the two senses of "first law", four citations, two tests\' links; 21 records); **DF2 next**')
BOARD.write_text(b.replace(row, row.replace(old, new)), encoding='utf-8')
print('STUDY_SECTION', N, 'PRECEIPT', rid)
