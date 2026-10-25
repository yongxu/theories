#!/usr/bin/env python3
"""MA4: a board row (board_ma3.py). `state ID TEXT` sets the row's state. `land ID RECEIPT SECTION QUEUE_TEXT STATE_TEXT`
moves the row to the history file after the last landed row, with its state set to STATE_TEXT and its claim's expected
standing replaced by the standing the review gave. It also puts QUEUE_TEXT at the head of the queue note and names the
receipt as the latest.
usage (from the checkout root): python3 -B board_ma4.py state MA4 TEXT | python3 -B board_ma4.py land MA4 RECEIPT N QUEUE STATE"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
EXPECTED = ("a witness where the same gain from their own readers (three at a cost of one) selects the capacity from one "
            "shaper to each other and not from one to three. Expected standing: elementary, the bistability of positive "
            "frequency-dependent selection, with the threshold models of Schelling and Granovetter and Arthur's lock-in "
            "to credit; what it adds is the join on the spine.")
STANDING = ("a witness where the same reading of what comes back (three at a cost of one) selects the capacity from one "
            "shaper to each other and not from one to three. Standing after the review: elementary, the stag hunt whose "
            "mixed equilibrium is the critical mass, with Schelling's and Granovetter's thresholds, Arthur's lock-in and "
            "the noise bound of Kandori, Mailath and Rob and of Young credited; new on the spine is the critical-mass "
            "computation, the lock half near-definitional.")
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
    assert cells[0].count(EXPECTED) == 1
    cells[0] = cells[0].replace(EXPECTED, STANDING)
    cells[2] = state_text
    row = ' | '.join(cells)
    del board[rows[0]]
    queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
    assert len(queue) == 1
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + queue_text + '; ', 1)
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
