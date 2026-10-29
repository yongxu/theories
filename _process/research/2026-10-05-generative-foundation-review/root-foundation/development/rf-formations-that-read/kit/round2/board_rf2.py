#!/usr/bin/env python3
"""RF round 2: the board, edited in a copy (round 1's board_rf.py, for round 2). `state BOARD TEXT` sets the RF row's
state cell to TEXT; `head BOARD TEXT` puts RF's head-of-queue clause, "RF at the head of the queue (TEXT); ", at the
front of the queue note. BOARD is the path of the board file to edit (a copy of main's, for a commit made without a
working tree).
usage: python3 -B board_rf2.py state BOARD TEXT | python3 -B board_rf2.py head BOARD TEXT"""
import re
import sys
from pathlib import Path

HEAD = re.compile(r'RF at the head of the queue \([^()]*\); ')
mode, board_path, text = sys.argv[1], Path(sys.argv[2]), sys.argv[3]
board = board_path.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith('| **RF: ')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)
queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
assert len(queue) == 1
if mode == 'state':
    assert cells[2].startswith(' round 1 landed') or cells[2].startswith('round 1 landed'), cells[2][:60]
    cells[2] = text
    board[rows[0]] = ' | '.join(cells)
elif mode == 'head':
    assert not HEAD.findall(board[queue[0]]), 'a head-of-queue clause is already there'
    clause = f'RF at the head of the queue ({text}); '
    assert HEAD.fullmatch(clause), clause
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
else:
    raise SystemExit(__doc__)
board_path.write_text('\n'.join(board), encoding='utf-8')
