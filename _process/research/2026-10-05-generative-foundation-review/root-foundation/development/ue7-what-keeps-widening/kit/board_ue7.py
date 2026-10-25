#!/usr/bin/env python3
"""UE7 (copied from UE4's board_ue4.py; the receipt's date is 26 October 2026, and landing also drops UE7's
head-of-queue clause and brings the way now's UE item to the landing): a board row (GS1–GS3's board_gs.py).
`state ID TEXT` sets the row's state; `land ID RECEIPT SECTION QUEUE_TEXT STATE_TEXT` moves the row, its state set to
STATE_TEXT, to the history file after the last landed row, puts QUEUE_TEXT at the head of the queue note and names
the receipt as the latest. Adapted from WL3's board.py.
usage (from the checkout root): python3 -B board_ue7.py state UE7 TEXT | python3 -B board_ue7.py land UE7 RECEIPT N QUEUE STATE"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = ('UE7 at the head of the queue (core checker running in its landing worktree from `64c11b8ed`; it patches '
        'Population, Novelty, Gain and Admission, so the modules above them rebuild); ')
NOW_OLD = ('UE7 (what keeps widening) is reviewed: its four laws are restatements or near-definitional, the map law '
           "answers part of 02's open item, and it lands after OU3b.")
NOW_NEW = ('UE7 (what keeping widening needs, study §{section}) landed: a course keeping widening by name with fixed '
           'finite requirements needs unbounded stock, fed from beyond, and under upkeep ever more renewers; support '
           'passing on fixes opened by the opened as a recency bound, and under the World premises nothing keeps '
           'opening along passing of support. The laws are restatements or near-definitional, the map law answers '
           "part of 02's open item, and none compares two courses, which UE9 takes up.")
item = sys.argv[2]
board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith(f'| **{item}: ')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)

if sys.argv[1] == 'state':
    cells[2] = sys.argv[3]
    board[rows[0]] = ' | '.join(cells)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
elif sys.argv[1] == 'land':
    receipt, section, queue_text, state_text = sys.argv[3], int(sys.argv[4]), sys.argv[5], sys.argv[6]
    assert f'§{section}' in queue_text and receipt in queue_text
    cells[2] = state_text
    row = ' | '.join(cells)
    del board[rows[0]]
    queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
    assert len(queue) == 1
    assert board[queue[0]].count(HEAD) == 1, 'head-of-queue clause'
    board[queue[0]] = board[queue[0]].replace(HEAD, '', 1)
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + queue_text + '; ', 1)
    now = [i for i, line in enumerate(board) if NOW_OLD in line]
    assert len(now) == 1 and board[now[0]].count(NOW_OLD) == 1, 'the way now, UE item'
    board[now[0]] = board[now[0]].replace(NOW_OLD, NOW_NEW.format(section=section), 1)
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(m.group(0),
                                                f"the latest core receipt is {item}'s `{receipt}` (26 October 2026)")
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
