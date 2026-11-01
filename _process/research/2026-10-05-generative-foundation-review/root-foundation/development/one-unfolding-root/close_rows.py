#!/usr/bin/env python3
"""Close the board rows OU's owner holds whose work has landed (EC, U1b, RN), and state on OU's row what is left (2 November 2026, the coordinator passing on the
request that everything merged be finished and every session say what it has left): each row titled done, its status
cell the closing, its links rebased, and moved to the history file after the last landed row (board_og.py's pattern).
Also the overview's budget row, whose "224 over" the measure reads as 208 (6,208 words against 6,000).
usage (from the checkout root): python3 -B close_rows.py"""
import re
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
BUDGETS = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
               'aj4-alignment-readers/READING-BUDGETS.md')
CLOSE = {
    '| **EC: an elegant completion**': (
        None, '; closed 2 November 2026: EC6 then took the gaps from 13 to 4 (`994c9d10f`), and OU3c to OU3e closed the '
        'measure (§433, §437, §439): every central declaration follows from a shared law or has its reason (08 §7), '
        'so no declaration remains for EC'),
    '| **U1b: amounts\' interface in the package**': (
        None, '; closed 2 November 2026: the release gate\'s item 3 met'),
    '| **RN: the opening\'s notes, about three minutes each**': (
        None, ' (`e825d6e1e`); closed 2 November 2026: the release gate\'s item 6 met'),
}

lines = BOARD.read_text(encoding='utf-8').split('\n')
moved = []
for title, (_, closing) in CLOSE.items():
    rows = [k for k, l in enumerate(lines) if l.startswith(title)]
    assert len(rows) == 1, (title, rows)
    row = lines.pop(rows[0])
    head, rest = row.split('**', 2)[1], row.split('**', 2)[2]
    row = '| **' + head + ', done**' + rest
    cells = row.split(' | ')
    assert len(cells) == 5, (title, len(cells))
    cells[2] = cells[2].rstrip() + closing
    row = ' | '.join(cells)
    row = re.sub(r'\]\(\.\./theories/', '](../../../theories/', row)
    row = re.sub(r'\]\(research/', '](../../research/', row)
    row = re.sub(r'\]\(\.\./sources/', '](../../../sources/', row)
    moved.append(row)
# OU stays open: plan §十三 items 6, 8, 9's institution and 11 are left (WHAT-REMAINS, after the gate).
ou = [k for k, l in enumerate(lines) if l.startswith('| **OU: one-unfolding root, continuity (续) at the centre**')]
assert len(ou) == 1, ou
cells = lines[ou[0]].split(' | ')
assert len(cells) == 5 and 'left after the gate' not in cells[2]
cells[2] = cells[2].rstrip() + ('; 2 November 2026: the release gate\'s items 1 to 6 are met, item 4 the last (OU7, '
    '§492), and item 7, the freeze, is Ren\'s; left after the gate (WHAT-REMAINS): plan §十三 item 6 (the map on each '
    'model class), item 8 (pairing and power with their uses, and the fragments mutual translation reaches, in Lean), '
    'item 9\'s institution (OG having given the organism its model, §497) and item 11 (the three minimalities\' '
    'report, MDL and Pareto), each to be claimed as an item of its own')
lines[ou[0]] = ' | '.join(cells)
BOARD.write_text('\n'.join(lines), encoding='utf-8')

hist = HISTORY.read_text(encoding='utf-8').split('\n')
k = hist.index('## Lapsed claims (18 October 2026)') - 1
while k > 0 and not hist[k].startswith('| **'):
    k -= 1
hist[k + 1:k + 1] = moved
HISTORY.write_text('\n'.join(hist), encoding='utf-8')

t = BUDGETS.read_text(encoding='utf-8')
a = '| An hour | Done: 224 over, which OU\'s owner judged'
assert t.count(a) == 1
BUDGETS.write_text(t.replace(a, '| An hour | Done: 208 over, which OU\'s owner judged'), encoding='utf-8')
print('closed', len(moved), 'rows after history line', k + 1)
