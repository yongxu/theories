#!/usr/bin/env python3
"""MA4b: a board row (board_ma4.py). `state ID TEXT` sets the row's state. `land ID RECEIPT SECTION QUEUE_TEXT STATE_TEXT`
moves the row to the history file after the last landed row, with its state set to STATE_TEXT and its claim's expected
standing replaced by the standing the review gave. It also puts QUEUE_TEXT at the head of the queue note and names the
receipt as the latest.
`head ID TEXT` puts the item at the head of the queue note (TEXT without parentheses); `land` removes that mark.
usage (from the checkout root): python3 -B board_ma4b.py head MA4b TEXT | state MA4b TEXT | land MA4b RECEIPT N QUEUE STATE"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
EXPECTED = ("Expected standing: elementary, a weighted majority read one step late; Collingridge's dilemma (1980), "
            "lock-in (David 1985, Arthur 1989) and the tipping models credited; what it adds is the join on the spine "
            "and the exact window.")
STANDING = ("Standing (independent review): elementary, MA2's Thinned laws composed with MA4's monotone course, the "
            "lag of one step being the representation's; the window is exact at every step but at most one, given "
            "readings at N and N + 1, and the course from that step is left open (a new round, which can go either "
            "way); the deadline is a loose bound, quadratic in the start's counts; in this model Collingridge's second "
            "horn is a theorem and the first a premise (the bound N); the nearest prior result is Biggs, Carpenter and "
            "Brock 2009.")
item = sys.argv[2]
board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith(f'| **{item}: ')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)

if sys.argv[1] == 'head':
    queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
    assert len(queue) == 1 and '(' not in sys.argv[3] and ')' not in sys.argv[3]
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', f'- **Queue:** {item} at the head of the queue ({sys.argv[3]}); ', 1)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
elif sys.argv[1] == 'state':
    cells[2] = sys.argv[3]
    board[rows[0]] = ' | '.join(cells)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
elif sys.argv[1] == 'land':
    receipt, section, queue_text, state_text = sys.argv[3], int(sys.argv[4]), sys.argv[5], sys.argv[6]
    assert f'§{section}' in queue_text and receipt in queue_text
    assert STANDING and cells[0].count(EXPECTED) == 1
    cells[0] = cells[0].replace(EXPECTED, STANDING)
    cells[2] = state_text
    row = ' | '.join(cells)
    del board[rows[0]]
    queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
    assert len(queue) == 1
    head = re.match(r'- \*\*Queue:\*\* ' + re.escape(item) + r' at the head of the queue \([^()]*\); ', board[queue[0]])
    if head:
        board[queue[0]] = '- **Queue:** ' + board[queue[0]][head.end():]
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
