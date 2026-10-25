#!/usr/bin/env python3
"""OU6 landing texts after a passing core checker: python3 -B <kit>/land6.py (from the checkout root).

Appends the study section (the study's last + 1) with the receipt and the three modules' counts, sets that section
number in the three records' new history entries and in DEFECTS-FOUND, moves the OU6 row from the live board to the
history file with its landing note, and restores the queue line."""
import json
import re
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
RECORDS = ['continuation-relative-to-a-class', 'classical-definitions-in-the-grammar',
           'generation-and-degeneration-at-two-grains']
DEFECTS = ROOT / '_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md'

rid = json.loads((PKG / 'becoming-verification.json').read_text())['utc']
R = json.loads((PKG / 'becoming-checks' / rid / 'verification.json').read_text())
assert R['status'] == 'passed'
mods = {m['module']: m for m in R['modules']}


def counts(name):
    m = mods[name]
    return str(m['theorems']), str(len(m['declarations']))


st = STUDY.read_text(encoding='utf-8')
N = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M)) + 1
sec = (HERE / 'study_ou6.txt').read_text(encoding='utf-8').replace('## NNN.', f'## {N}.').replace('RECEIPT', rid)
for key, name in [('G', 'Becoming.Grammar'), ('R', 'Becoming.GrammarReadings'), ('M', 'Becoming.GrammarMap')]:
    t, d = counts(name)
    sec = re.sub(rf'\b{key}T\b', t, sec)
    sec = re.sub(rf'\b{key}D\b', d, sec)
assert 'NNN' not in sec and 'RECEIPT' not in sec
STUDY.write_text(st.rstrip('\n') + '\n\n' + sec.strip('\n') + '\n', encoding='utf-8')

for name in RECORDS:
    p = ROOT / 'theories/becoming/results/records' / f'{name}.json'
    t = p.read_text(encoding='utf-8')
    assert t.count('NNN') == 2, name
    p.write_text(t.replace('NNN', str(N)), encoding='utf-8')
t = DEFECTS.read_text(encoding='utf-8')
assert t.count('§NNN') == 2
DEFECTS.write_text(t.replace('§NNN', f'§{N}'), encoding='utf-8')

b = BOARD.read_text(encoding='utf-8')
rows = [l for l in b.split('\n') if l.startswith('| **OU6:')]
assert len(rows) == 1
row = rows[0]
b = b.replace(row + '\n', '')
old = ('OU6, the corrections to the grammar from the review of its sources, is at the head of the queue (24 October 2026, '
       'core checker running in its landing worktree).')
assert b.count(old) == 1
b = b.replace('its row moved likewise): ' + old,
              f'its row moved likewise; OU6, the corrections to the grammar from the review of its sources, landed, core '
              f'receipt `{rid}`, its row moved likewise): nothing is queued.')
old = "OU6's corrections and the lifting (OU, EC) go on under their owners."
assert b.count(old) == 1
b = b.replace(old, f"OU6's corrections landed (study §{N}); the lifting (OU, EC) goes on under its owners.")
BOARD.write_text(b, encoding='utf-8')
cells = row.split(' | ')
cells[-3] = (f'landed 24 October 2026, core receipt `{rid}`, study §{N}: the five corrections, the GrammarMap docstrings '
             'of the strong forms and the record of the two grains (DEFECTS-FOUND, chapter 02); chapters 01, 02 and 06, the '
             'three dossiers and the plan state them; the order 穷 → 变 → 通 stays open')
h = HISTORY.read_text(encoding='utf-8')
HISTORY.write_text(h.rstrip('\n') + '\n' + ' | '.join(cells) + '\n', encoding='utf-8')
print('STUDY_SECTION', N, 'RECEIPT', rid)
