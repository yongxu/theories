#!/usr/bin/env python3
"""UE20 (UE19's board script, with no receipt: UE20 adds no Lean): a board row. `state ID TEXT` sets the row's state;
`head ID TEXT` puts UE20's head-of-queue clause, "UE20 at the head of the queue (TEXT); ", at the front of the queue
note; `land ID SECTION QUEUE_TEXT STATE_TEXT` moves the row, its state set to STATE_TEXT and its statements brought to
what landed, to the history file after the last landed row, drops UE20's head-of-queue clause, puts QUEUE_TEXT at the
head of the queue note and adds UE20 to the UE row's landed items. The latest core receipt is left as it stands.
usage (from the checkout root): python3 -B board_ue20.py state UE20 TEXT | python3 -B board_ue20.py head UE20 TEXT |
       python3 -B board_ue20.py land UE20 N QUEUE STATE"""
import datetime
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = re.compile(r'UE20 at the head of the queue \([^()]*\); ')
TODAY = datetime.date.today()
UE_OLD = "and UE16, UE17, UE18 and UE19 (29 October)"
UE_NEW = f"and UE16, UE17, UE18 and UE19 (29 October), and UE20 ({TODAY.day} {TODAY:%B})"
# the row's statements, brought to what landed, in the row moved to history
STATEMENTS = [
    ("UE1's record, 08 §8 and the UE plan brought to it. No Lean",
     "03 §6, 08 §8's bullet on UE1's record, FEP-INTEGRATION and the UE plan linked to it; UE1's record already a "
     "containment with its third parts (UE16, UE19), unchanged. No Lean"),
]
item = sys.argv[2]
assert item == 'UE20', item
board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith(f'| **{item}: ')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)
queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
assert len(queue) == 1

if sys.argv[1] == 'state':
    cells[2] = sys.argv[3]
    board[rows[0]] = ' | '.join(cells)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
elif sys.argv[1] == 'head':
    assert not HEAD.findall(board[queue[0]]), 'a head-of-queue clause is already there'
    clause = f'{item} at the head of the queue ({sys.argv[3]}); '
    assert HEAD.fullmatch(clause), clause
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
elif sys.argv[1] == 'land':
    section, queue_text, state_text = int(sys.argv[3]), sys.argv[4], sys.argv[5]
    assert f'§{section}' in queue_text
    cells[2] = state_text
    for old, new in STATEMENTS:
        assert cells[0].count(old) == 1, old[:60]
        cells[0] = cells[0].replace(old, new)
    row = ' | '.join(cells)
    del board[rows[0]]
    queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
    assert len(queue) == 1
    assert len(HEAD.findall(board[queue[0]])) == 1, 'head-of-queue clause'
    board[queue[0]] = HEAD.sub('', board[queue[0]], count=1)
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + queue_text + '; ', 1)
    ue = [i for i, line in enumerate(board) if line.startswith('| **UE: a unified explanation of reality**')]
    assert len(ue) == 1, ue
    ue_cells = board[ue[0]].split(' | ')
    assert len(ue_cells) == 5 and ue_cells[2].count(UE_OLD) == 1, 'the UE row'
    ue_cells[2] = ue_cells[2].replace(UE_OLD, UE_NEW)
    board[ue[0]] = ' | '.join(ue_cells)
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
print('board', sys.argv[1], item)
