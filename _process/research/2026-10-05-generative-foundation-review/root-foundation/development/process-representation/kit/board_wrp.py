#!/usr/bin/env python3
"""WRP (board_wrt2.py's pattern, for a design landed as documents only): the board.
`head TEXT` puts WRP's head-of-queue clause, "WRP at the head of the queue (TEXT); ", at the front of the queue
note. `land STATE QUEUE ROWFILE` sets the WRP row's state to STATE and moves the row to the history file after the
last landed row, puts the row in ROWFILE (WRP2, proposed) where the WRP row stood, drops WRP's head-of-queue clause
and puts QUEUE at the head of the queue note. No receipt: nothing is compiled.
usage (from the checkout root): python3 -B board_wrp.py head TEXT |
       python3 -B board_wrp.py land STATE QUEUE ROWFILE"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = re.compile(r'WRP at the head of the queue \([^()]*\); ')

board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith('| **WRP: ')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)
queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
assert len(queue) == 1, queue

if sys.argv[1] == 'head':
    assert not HEAD.findall(board[queue[0]]), 'a head-of-queue clause is already there'
    clause = f'WRP at the head of the queue ({sys.argv[2]}); '
    assert HEAD.fullmatch(clause), clause
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
elif sys.argv[1] == 'land':
    state_text, queue_text, rowfile = sys.argv[2], sys.argv[3], Path(sys.argv[4])
    proposed = rowfile.read_text(encoding='utf-8').strip()
    assert proposed.startswith('| **WRP2: ') and len(proposed.split(' | ')) == 5 and '\n' not in proposed, 'row'
    assert not any(line.startswith('| **WRP2: ') for line in board), 'WRP2 row exists'
    cells[2] = state_text
    row = ' | '.join(cells)
    board[rows[0]] = proposed
    assert len(HEAD.findall(board[queue[0]])) == 1, 'head-of-queue clause'
    board[queue[0]] = HEAD.sub('', board[queue[0]], count=1)
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + queue_text + '; ', 1)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
    history = HISTORY.read_text(encoding='utf-8').split('\n')
    before = len(history)
    lapsed = history.index('## Lapsed claims (18 October 2026)')
    end = lapsed - 1
    while not history[end].startswith('| '):
        end -= 1
    history.insert(end + 1, row)
    assert len(history) == before + 1
    HISTORY.write_text('\n'.join(history), encoding='utf-8')
else:
    raise SystemExit(__doc__)
print('board', sys.argv[1], 'WRP')
