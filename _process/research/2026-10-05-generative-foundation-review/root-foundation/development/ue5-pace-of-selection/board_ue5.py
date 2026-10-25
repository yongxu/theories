#!/usr/bin/env python3
"""UE5: the board row (UE1's board_ue1.py, with the title fix the review asks for).
`state UE5 TEXT` sets the row's state.
`title UE5` takes the label the review withdrew ("the theory's form of Haldane's cost of selection") out of the row's
title cell, asserting it is there once.
`land UE5 RECEIPT SECTION QUEUE_TEXT STATE_TEXT` makes the same title fix where it is still needed, moves the row, its
state set to STATE_TEXT, to the history file after the last landed row, puts QUEUE_TEXT at the head of the queue note
and names the receipt as the latest, dated from the receipt.
usage (from the checkout root): python3 -B <kit>/board_ue5.py state UE5 TEXT | title UE5 | land UE5 RECEIPT N QUEUE STATE"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
MONTHS = ('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October',
          'November', 'December')
WITHDRAWN = " (UE0's first ranked candidate; the theory's form of Haldane's cost of selection)."
KEPT = " (UE0's first ranked candidate)."
PHRASES = ("Haldane's cost in counting form", "the theory's form of Haldane's cost")

if len(sys.argv) < 3:
    raise SystemExit(__doc__)
item = sys.argv[2]
assert item == 'UE5', item
board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith(f'| **{item}: ')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)


def fix_title(required):
    if WITHDRAWN in cells[0]:
        assert cells[0].count(WITHDRAWN) == 1
        cells[0] = cells[0].replace(WITHDRAWN, KEPT)
    else:
        assert not required, 'the title no longer carries the withdrawn label'
    assert not any(p in cells[0] for p in PHRASES), cells[0][:120]


if sys.argv[1] == 'state':
    cells[2] = sys.argv[3]
    assert not any(p in cells[2] for p in PHRASES)
    board[rows[0]] = ' | '.join(cells)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
elif sys.argv[1] == 'title':
    fix_title(required=True)
    board[rows[0]] = ' | '.join(cells)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
elif sys.argv[1] == 'land':
    receipt, section, queue_text, state_text = sys.argv[3], int(sys.argv[4]), sys.argv[5], sys.argv[6]
    assert f'§{section}' in queue_text and receipt in queue_text
    assert not any(p in queue_text or p in state_text for p in PHRASES)
    fix_title(required=False)
    cells[2] = state_text
    row = ' | '.join(cells)
    del board[rows[0]]
    queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
    assert len(queue) == 1
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + queue_text + '; ', 1)
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(\d{1,2} [A-Z][a-z]+ 20\d\d\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    date = f'{int(receipt[6:8])} {MONTHS[int(receipt[4:6]) - 1]} {receipt[:4]}'
    board[latest[0]] = board[latest[0]].replace(m.group(0), f"the latest core receipt is {item}'s `{receipt}` ({date})")
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
