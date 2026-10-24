#!/usr/bin/env python3
"""IV3k: the board row. `land RECEIPT SECTION THEOREMS DECLS` moves the row, its state set to landed, to the history file
after the last landed row, and adds the landing to the queue note and the latest receipt.
usage (from the checkout root): python3 -B board_k.py land RECEIPT SECTION THEOREMS DECLS"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board)
        if line.startswith('| **IV3k: need and feeding read with time, and chapter 7 led by the structure**')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)

if sys.argv[1] == 'land':
    receipt, section, theorems, decls = sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5]
    cells[2] = (f'landed 2026-10-24, core receipt `{receipt}`; Becoming.Weightings {theorems} theorems in {decls} '
                f'declarations, empty axiom reports; new record need-and-feeding-read-with-time; the records drifting by '
                f'these edits re-pointed; study §{section}; D64 items 1, 5 and 14')
    row = ' | '.join(cells)
    del board[rows[0]]
    queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
    assert len(queue) == 1
    board[queue[0]] = board[queue[0]].replace(
        '- **Queue:** ',
        '- **Queue:** IV3k landed (need and feeding read with time: a formation active at no step of the stretch is needed '
        'only where nothing lets the consumer draw past the stock, and a feeding closure read with time holds only what '
        'gives by the step it is read up to, while read across every step it can run past the end of what it carries; '
        'chapter 7 led by the structure, after SW; '
        f'`Becoming.Weightings`, core receipt `{receipt}`, study §{section}, new record need-and-feeding-read-with-time, '
        'row in the history file); ', 1)
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(m.group(0),
                                                f"the latest core receipt is IV3k's `{receipt}` (24 October 2026)")
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
