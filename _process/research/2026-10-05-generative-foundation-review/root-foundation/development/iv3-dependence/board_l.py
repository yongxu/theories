#!/usr/bin/env python3
"""IV3l: the board row. `land SECTION STATE QUEUE` moves the row, its state set to STATE, to the history file after the last
landed row, and adds QUEUE to the front of the queue note. No core receipt changes where the fixes are text only.
usage (from the checkout root): python3 -B board_l.py land SECTION STATE QUEUE"""
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board)
        if line.startswith('| **IV3l: the independent review of IV3i, IV3j, IV3k and 07 §4.6, and its fixes**')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)

if sys.argv[1] == 'land':
    section, state, queue_note = int(sys.argv[2]), sys.argv[3], sys.argv[4]
    cells[2] = state
    row = ' | '.join(cells)
    del board[rows[0]]
    queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
    assert len(queue) == 1
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + queue_note + '; ', 1)
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
print('board', sys.argv[1], 'study', section)
