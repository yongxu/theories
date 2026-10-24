#!/usr/bin/env python3
"""OU6, the text pass on main's pages (25 October 2026), after the core checker passed on the tree merged with main.

Main had taken study sections 398 (RP2) and 399 (IV3l), so the study, the board and its history file are main's,
and this pass applies OU6's changes to them: the study section (the study's last + 1, from study_ou6.txt with the
receipt and the modules' counts), that section number in the records' OU6 history entries, in DEFECTS-FOUND and in
the chapter draft's note, the OU6 row moved from the live board into the history file's table of landed rows, the
queue handed to MA2, and the commit message filled in. Run from the checkout root: python3 -B <kit>/land6c.py"""
import json
import re
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RF = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = RF / 'BECOMING-RENEWAL-READING.md'
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
RECORDS = ['continuation-relative-to-a-class', 'classical-definitions-in-the-grammar',
           'generation-and-degeneration-at-two-grains']
DEFECTS = ROOT / '_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md'
DRAFT = RF / 'development/one-unfolding-root/CHAPTER-DRAFT.md'
WAS = 399

rid = json.loads((PKG / 'becoming-verification.json').read_text())['utc']
R = json.loads((PKG / 'becoming-checks' / rid / 'verification.json').read_text())
assert R['status'] == 'passed'
mods = {m['module']: m for m in R['modules']}


def fill(text):
    text = text.replace('RECEIPT', rid)
    for key, name in [('G', 'Becoming.Grammar'), ('R', 'Becoming.GrammarReadings'), ('M', 'Becoming.GrammarMap')]:
        text = re.sub(rf'\b{key}T\b', str(mods[name]['theorems']), text)
        text = re.sub(rf'\b{key}D\b', str(len(mods[name]['declarations'])), text)
    return text


st = STUDY.read_text(encoding='utf-8')
assert '(OU6)' not in st
N = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M)) + 1
sec = fill((HERE / 'study_ou6.txt').read_text(encoding='utf-8').replace('## NNN.', f'## {N}.'))
assert 'NNN' not in sec and 'RECEIPT' not in sec
STUDY.write_text(st.rstrip('\n') + '\n\n' + sec.strip('\n') + '\n', encoding='utf-8')

for name in RECORDS:
    p = ROOT / 'theories/becoming/results/records' / f'{name}.json'
    r = json.loads(p.read_text(encoding='utf-8'))
    h = r['history'][-1]
    assert 'OU6' in h['en'] and f'study section {WAS})' in h['en'] and f'研究第 {WAS} 节' in h['zh'], name
    h['en'] = h['en'].replace(f'study section {WAS})', f'study section {N})')
    h['zh'] = h['zh'].replace(f'研究第 {WAS} 节', f'研究第 {N} 节')
    p.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
for p, old, new, count in [(DEFECTS, f'(OU6, study §{WAS})', f'(OU6, study §{N})', 2),
                           (DRAFT, f'OU6（研究第 {WAS} 节）', f'OU6（研究第 {N} 节）', 1)]:
    t = p.read_text(encoding='utf-8')
    assert t.count(old) == count, p.name
    p.write_text(t.replace(old, new), encoding='utf-8')

b = BOARD.read_text(encoding='utf-8')
rows = [l for l in b.split('\n') if l.startswith('| **OU6:')]
assert len(rows) == 1
row = rows[0]
b = b.replace(row + '\n', '')
old = ('its row moved likewise): OU6, the corrections to the grammar from the review of its sources, is at the head of '
       'the queue (24 October 2026, core checker running in its landing worktree). MA2, readers drawn from the selected '
       "(landing taken over on Ren's yes), is next: merged with main in `.claude/worktrees/ma2` (branch `ma2`, "
       "`d53a423c0`), its core checker to run on the merged tree once OU6 is on main.")
assert b.count(old) == 1
b = b.replace(old, f'its row moved likewise; OU6, the corrections to the grammar from the review of its sources, landed '
                   f'25 October 2026, core receipt `{rid}`, its row moved likewise): MA2, readers drawn from the selected '
                   "(landing taken over on Ren's yes), is at the head of the queue: merged with main before OU6 in "
                   "`.claude/worktrees/ma2` (branch `ma2`, `d53a423c0`); it merges main again, now with OU6, and its core "
                   'checker runs on that tree.')
old = "OU6's corrections and the lifting (OU, EC) go on under their owners."
assert b.count(old) == 1
b = b.replace(old, f"OU6's corrections landed (study §{N}); the lifting (OU, EC) goes on under its owners.")
BOARD.write_text(b, encoding='utf-8')

cells = row.split(' | ')
cells[-3] = (f'landed 25 October 2026, core receipt `{rid}`, study §{N}: the five corrections, abiding read off the two-way '
             'core and ceasing for what does not itself renew, the GrammarMap and MapInstances docstrings of the strong '
             'forms, and the record of the two grains (DEFECTS-FOUND, chapter 02); chapters 01, 02 and 06, the three '
             'dossiers and the plan state them; the order 穷 → 变 → 通 stays open')
lines = HISTORY.read_text(encoding='utf-8').rstrip('\n').split('\n')
k = next(i for i, l in enumerate(lines) if l.startswith('## Lapsed claims'))
j = k - 1
while j > 0 and not lines[j].startswith('|'):
    j -= 1
lines.insert(j + 1, ' | '.join(cells))
HISTORY.write_text('\n'.join(lines) + '\n', encoding='utf-8')

msg = fill((HERE / 'commit-msg.txt').read_text(encoding='utf-8')).replace('Study §399', f'Study §{N}')
assert 'RECEIPT' not in msg
(HERE / 'commit-msg.final.txt').write_text(msg, encoding='utf-8')
print('STUDY_SECTION', N, 'RECEIPT', rid)
