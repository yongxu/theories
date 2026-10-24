#!/usr/bin/env python3
"""IV3b: the board row. `state TEXT` sets the row's state; `land RECEIPT SECTION THEOREMS DECLS` moves the row, its state
set to landed, to the history file after the last landed row, and adds the landing to the queue note.
usage (from the checkout root): python3 -B board.py state TEXT | python3 -B board.py land RECEIPT SECTION THEOREMS DECLS"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith('| **IV3b: need on the base')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)

if sys.argv[1] == 'state':
    cells[2] = sys.argv[2]
    board[rows[0]] = ' | '.join(cells)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
elif sys.argv[1] == 'land':
    receipt, section, theorems, decls = sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5]
    cells[2] = (f'landed 2026-10-23, core receipt `{receipt}`; Becoming.Weightings {theorems} theorems in {decls} '
                f'declarations, empty axiom reports; records self-concern-through-dependence and '
                f'what-self-concern-alone-ranks extended; study §{section}; D64 item 6')
    row = ' | '.join(cells)
    del board[rows[0]]
    queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
    assert len(queue) == 1
    board[queue[0]] = board[queue[0]].replace(
        '- **Queue:** ',
        '- **Queue:** IV3b landed (need on the base: a formation drawing past its family\'s stock needs some feeder\'s '
        'giving, and a feeder\'s exactly where it is the only one, need over any courses with two readings; the coupled '
        'ending ranked below by self-concern in one theorem; `Becoming.Weightings`, core receipt '
        f'`{receipt}`, study §{section}, records self-concern-through-dependence and what-self-concern-alone-ranks '
        'extended, row in the history file); ', 1)
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(m.group(0),
                                                f"the latest core receipt is IV3b's `{receipt}` (23 October 2026)")
    BOARD.write_text('\n'.join(board), encoding='utf-8')
    history = HISTORY.read_text(encoding='utf-8').split('\n')
    lapsed = history.index('## Lapsed claims (18 October 2026)')
    end = lapsed - 1
    while not history[end].startswith('| '):
        end -= 1
    history.insert(end + 1, row)
    HISTORY.write_text('\n'.join(history), encoding='utf-8')
else:
    raise SystemExit(__doc__)
print('board', sys.argv[1])
