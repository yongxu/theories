#!/usr/bin/env python3
"""VT1: the board row. `state TEXT` sets the row's state; `land RECEIPT SECTION` moves the row, its state set to
landed, to the history file after the rows landed on 22 October, and updates the queue note.
usage (from the checkout root): python3 -B board.py state TEXT | python3 -B board.py land RECEIPT SECTION"""
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
board = BOARD.read_text().split('\n')
rows = [i for i, line in enumerate(board) if line.startswith('| **VT1: the valuer tests as theorems**')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)

if sys.argv[1] == 'state':
    cells[2] = sys.argv[2]
    board[rows[0]] = ' | '.join(cells)
    BOARD.write_text('\n'.join(board))
elif sys.argv[1] == 'land':
    receipt, section = sys.argv[2], int(sys.argv[3])
    cells[2] = (f'landed 2026-10-22, core receipt `{receipt}`; Becoming.Weightings 146 theorems in 199 declarations, empty '
                f'axiom reports; records a-narrowing-above-its-widening and weights-within-a-ratio-agree-past-it; study '
                f'§{section}')
    row = ' | '.join(cells)
    del board[rows[0]]
    queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
    assert len(queue) == 1
    board[queue[0]] = board[queue[0]].replace(
        '- **Queue:** ',
        '- **Queue:** VT1 landed (the valuer tests as theorems: a ranking of presentations puts a narrowing above its '
        'widening by one item only where it does not read the pair as the sets or the item weighs at zero or below, and '
        'read right exactly where it weighs below zero; a sign measured apart predicts the ranking under its link to the '
        'joint increment; weights within a ratio n/d agree exactly where n q < d p; `Becoming.Weightings`, core receipt '
        f'`{receipt}`, study §{section}, records a-narrowing-above-its-widening and weights-within-a-ratio-agree-past-it, '
        'row in the history file); ', 1)
    BOARD.write_text('\n'.join(board))
    history = HISTORY.read_text().split('\n')
    lapsed = history.index('## Lapsed claims (18 October 2026)')
    end = lapsed - 1
    while not history[end].startswith('| '):
        end -= 1
    history.insert(end + 1, row)
    HISTORY.write_text('\n'.join(history))
else:
    raise SystemExit(__doc__)
print('board', sys.argv[1])
