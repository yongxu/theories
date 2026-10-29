#!/usr/bin/env python3
"""UE16 (UE15's board_ue15.py): a board row. `state ID TEXT` sets the row's state; `head ID TEXT` puts UE16's
head-of-queue clause, "UE16 at the head of the queue (TEXT); ", at the front of the queue note; `land ID RECEIPT
SECTION QUEUE_TEXT STATE_TEXT` moves the row, its state set to STATE_TEXT and its statements brought to what the Lean
shows, to the history file after the last landed row, drops UE16's head-of-queue clause, puts QUEUE_TEXT at the head
of the queue note, names the receipt as the latest and adds UE16 to the UE row's landed items.
usage (from the checkout root): python3 -B board_ue16.py state UE16 TEXT | python3 -B board_ue16.py head UE16 TEXT |
       python3 -B board_ue16.py land UE16 RECEIPT N QUEUE STATE"""
import datetime
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = re.compile(r'UE16 at the head of the queue \([^()]*\); ')
TODAY = datetime.date.today()
UE_OLD = "and UE12, UE13, UE14 and UE15 (28 October)"
UE_NEW = "and UE12, UE13, UE14 and UE15 (28 October), and UE16 (29 October)"
# the row's statements, brought to what the Lean shows after the review, in the row moved to history
STATEMENTS = [
    ("UE1's record becomes a containment with third parts. Pure core, a leaf at L1 or L2 by its imports",
     "UE1's record becomes a containment with third parts. Pure core, a leaf at L1 importing `Becoming.Commuting`, "
     "`Becoming.Exclusion` and `Becoming.SetPointOptimum`, namespace `FreeEnergyGuarantees`, with two records, "
     "identical-cells-under-a-descent-treating-them-alike (05 §9) and risk-minimization-on-a-shared-renewal (05 §1); after the "
     "review, never parting under any descent reading no cell's number, minima within one size, claim 3 on the landed "
     "held pair with each take a least-risk choice, three regulators of the shared level ending at once, and claim 2 "
     "graded weak"),
]
item = sys.argv[2]
assert item == 'UE16', item
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
    receipt, section, queue_text, state_text = sys.argv[3], int(sys.argv[4]), sys.argv[5], sys.argv[6]
    assert f'§{section}' in queue_text and receipt in queue_text
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
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(m.group(0),
                                                f"the latest core receipt is {item}'s `{receipt}` ({TODAY.day} {TODAY:%B} {TODAY.year})")
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
