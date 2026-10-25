#!/usr/bin/env python3
"""OU6, the rebase pass (25 October 2026): main had taken study section 398 (RP2) and queued MA2 behind OU6, so the
study, the board and its history file are taken from main and OU6's changes applied to them again. Run from the
checkout root after resolving those three files to main's version: python3 -B <kit>/land6b.py

Appends the study section (the study's last + 1), moves the section number and the date in the records' OU6 history
entries and in DEFECTS-FOUND to it, moves the OU6 row from the live board to the history file, and hands the head of
the queue to MA2."""
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
WAS = 398

rid = json.loads((PKG / 'becoming-verification.json').read_text())['utc']
R = json.loads((PKG / 'becoming-checks' / rid / 'verification.json').read_text())
assert R['status'] == 'passed'
mods = {m['module']: m for m in R['modules']}

st = STUDY.read_text(encoding='utf-8')
assert '(OU6)' not in st
N = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M)) + 1
sec = (HERE / 'study_ou6.txt').read_text(encoding='utf-8').replace('## NNN.', f'## {N}.').replace('RECEIPT', rid)
for key, name in [('G', 'Becoming.Grammar'), ('R', 'Becoming.GrammarReadings'), ('M', 'Becoming.GrammarMap')]:
    sec = re.sub(rf'\b{key}T\b', str(mods[name]['theorems']), sec)
    sec = re.sub(rf'\b{key}D\b', str(len(mods[name]['declarations'])), sec)
assert 'NNN' not in sec and 'RECEIPT' not in sec
STUDY.write_text(st.rstrip('\n') + '\n\n' + sec.strip('\n') + '\n', encoding='utf-8')

for name in RECORDS:
    p = ROOT / 'theories/becoming/results/records' / f'{name}.json'
    r = json.loads(p.read_text(encoding='utf-8'))
    h = r['history'][-1]
    assert 'OU6' in h['en'] and f'study section {WAS})' in h['en'] and f'研究第 {WAS} 节' in h['zh'], name
    h['en'] = h['en'].replace(f'study section {WAS})', f'study section {N})').replace('24 October 2026', '25 October 2026', 1)
    h['zh'] = h['zh'].replace(f'研究第 {WAS} 节', f'研究第 {N} 节').replace('2026年10月24日', '2026年10月25日', 1)
    p.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
t = DEFECTS.read_text(encoding='utf-8')
assert t.count(f'(OU6, study §{WAS})') == 2
DEFECTS.write_text(t.replace(f'(OU6, study §{WAS})', f'(OU6, study §{N})'), encoding='utf-8')

b = BOARD.read_text(encoding='utf-8')
rows = [l for l in b.split('\n') if l.startswith('| **OU6:')]
assert len(rows) == 1
row = rows[0]
b = b.replace(row + '\n', '')
old = ('its row moved likewise): OU6, the corrections to the grammar from the review of its sources, is at the head of '
       'the queue (24 October 2026, core checker running in its landing worktree). MA2, readers drawn from the selected '
       "(landing taken over on Ren's yes), is next:")
assert b.count(old) == 1
b = b.replace(old, f'its row moved likewise; OU6, the corrections to the grammar from the review of its sources, landed '
                   f'25 October 2026, core receipt `{rid}`, its row moved likewise): MA2, readers drawn from the selected '
                   "(landing taken over on Ren's yes), is at the head of the queue:")
old = "OU6's corrections and the lifting (OU, EC) go on under their owners."
assert b.count(old) == 1
b = b.replace(old, f"OU6's corrections landed (study §{N}); the lifting (OU, EC) goes on under its owners.")
BOARD.write_text(b, encoding='utf-8')
cells = row.split(' | ')
cells[-3] = (f'landed 25 October 2026, core receipt `{rid}`, study §{N}: the five corrections, the GrammarMap docstrings '
             'of the strong forms and the record of the two grains (DEFECTS-FOUND, chapter 02); chapters 01, 02 and 06, the '
             'three dossiers and the plan state them; the order 穷 → 变 → 通 stays open')
h = HISTORY.read_text(encoding='utf-8')
HISTORY.write_text(h.rstrip('\n') + '\n' + ' | '.join(cells) + '\n', encoding='utf-8')
print('STUDY_SECTION', N, 'RECEIPT', rid)
