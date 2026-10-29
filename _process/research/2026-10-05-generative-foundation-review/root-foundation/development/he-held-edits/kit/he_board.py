#!/usr/bin/env python3
"""HE: the board (OU3f's board_lineage.py). HE's row closes when it lands; OU3f's row no longer says that
GrammarLaws' module doc lags. `head TEXT` puts TEXT, the claim at the head of the queue, before the queue note's
entries; `land RECEIPT SECTION QUEUE_TEXT STATE_TEXT` drops that claim, puts QUEUE_TEXT at the head instead, names the
receipt as the latest and sets the row's state to STATE_TEXT.
usage (from the checkout root): python3 -B he_board.py head TEXT | python3 -B he_board.py land RECEIPT N QUEUE STATE"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
ITEM = 'HE'
HEAD = "HE at the head of the queue ("
board = BOARD.read_text(encoding='utf-8').split('\n')
queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
assert len(queue) == 1, queue
PREFIX = '- **Queue:** '


def without_head(line):
    """The queue line with this item's claim at the head dropped: the claim runs to its closing parenthesis."""
    assert line.startswith(PREFIX + HEAD), 'the head claim is not at the head of the queue'
    depth, i = 0, len(PREFIX + HEAD) - 1
    while True:
        depth += {'(': 1, ')': -1}.get(line[i], 0)
        if depth == 0:
            break
        i += 1
    assert line[i + 1:i + 3] == '; ', line[i:i + 5]
    return PREFIX + line[i + 3:]


if sys.argv[1] == 'head':
    text = sys.argv[2]
    assert text.startswith(HEAD) and text.endswith(')'), text[:60]
    assert HEAD not in board[queue[0]], 'already claimed'
    board[queue[0]] = board[queue[0]].replace(PREFIX, PREFIX + text + '; ', 1)
elif sys.argv[1] == 'land':
    receipt, section, queue_text, state_text = sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5]
    assert f'§{section}' in queue_text and receipt in queue_text
    board[queue[0]] = without_head(board[queue[0]]).replace(PREFIX, PREFIX + queue_text + '; ', 1)
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(m.group(0),
                                                f"the latest core receipt is HE's `{receipt}` (29 October 2026)")
    rows = [i for i, line in enumerate(board) if line.startswith(f'| **{ITEM}: ')]
    assert len(rows) == 1, rows
    cells = board[rows[0]].split(' | ')
    assert len(cells) == 5, len(cells)
    cells[2] = state_text
    board[rows[0]] = ' | '.join(cells)
    # OU3f's row: GrammarLaws' module doc no longer lags.
    ou = [i for i, line in enumerate(board) if line.startswith('| **OU3f: ')]
    assert len(ou) == 1, ou
    lag = "GrammarLaws' module doc lags until HE (its item 2); "
    assert board[ou[0]].count(lag) == 1, 'OU3f\'s row has changed; re-read it'
    board[ou[0]] = board[ou[0]].replace(lag, "GrammarLaws' module doc corrected by HE; ")
else:
    raise SystemExit(__doc__)
BOARD.write_text('\n'.join(board), encoding='utf-8')
print('board', sys.argv[1], ITEM)
