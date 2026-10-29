#!/usr/bin/env python3
"""HE: the board. `head TEXT` puts TEXT, the claim at the head of the queue, before the queue note's entries, and
refuses where another item already holds the head (board rule 5). `land RECEIPT SECTION QUEUE_TEXT STATE_TEXT` drops
that claim and puts QUEUE_TEXT at the head instead, names the receipt as the latest, dated today, moves HE's row with
STATE_TEXT as its state to the history file's landed rows, after UE20's, its links rebased (board rule 4), and brings
OU3f's row to what HE did (kept_onward now in GrammarLaws; GrammarLaws' module doc corrected).
usage (from the checkout root): python3 -B he_board.py head TEXT | python3 -B he_board.py land RECEIPT N QUEUE STATE"""
from datetime import date
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
ITEM = 'HE'
HEAD = "HE at the head of the queue ("
PREFIX = '- **Queue:** '
TODAY = date.today()
DAY = f'{TODAY.day} {TODAY.strftime("%B")} {TODAY.year}'
board = BOARD.read_text(encoding='utf-8').split('\n')
queue = [i for i, line in enumerate(board) if line.startswith(PREFIX)]
assert len(queue) == 1, queue


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
    assert 'at the head of the queue (' not in board[queue[0]], 'another item holds the head: claim behind it'
    board[queue[0]] = board[queue[0]].replace(PREFIX, PREFIX + text + '; ', 1)
elif sys.argv[1] == 'land':
    receipt, section, queue_text, state_text = sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5]
    assert f'§{section}' in queue_text and receipt in queue_text
    board[queue[0]] = without_head(board[queue[0]]).replace(PREFIX, PREFIX + queue_text + '; ', 1)
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(\d{1,2} \w+ 20\d\d\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(m.group(0), f"the latest core receipt is HE's `{receipt}` ({DAY})")
    # OU3f's row: kept_onward is GrammarLaws' now, and GrammarLaws' module doc no longer lags.
    ou = [i for i, line in enumerate(board) if line.startswith('| **OU3f: ')]
    assert len(ou) == 1, ou
    for old, new in (("`Becoming.KeptOnward` holds `kept_onward`, the grammar's closure at the successor, its home "
                      "beside «线则所闭» in `GrammarLaws`",
                      "`kept_onward`, the grammar's closure at the successor, now stands beside «线则所闭» in "
                      "`GrammarLaws` (HE)"),
                     ("GrammarLaws' module doc lags until HE (its item 2); ", "GrammarLaws' module doc corrected by HE; ")):
        assert board[ou[0]].count(old) == 1, ('OU3f\'s row has changed; re-read it', old[:60])
        board[ou[0]] = board[ou[0]].replace(old, new)
    # HE's row to the history file's landed rows (board rule 4), after UE20's, links relative to the history file.
    rows = [i for i, line in enumerate(board) if line.startswith(f'| **{ITEM}: ')]
    assert len(rows) == 1, rows
    cells = board[rows[0]].split(' | ')
    assert len(cells) == 5, len(cells)
    cells[2] = state_text
    row = ' | '.join(cells)
    row = re.sub(r'\]\((research/)', r'](../../\1', row)
    row = re.sub(r'\]\(\.\./(theories|sources)/', r'](../../../\1/', row)
    del board[rows[0]]
    htext = HISTORY.read_text(encoding='utf-8').split('\n')
    after = [i for i, line in enumerate(htext) if line.startswith('| **UE20: ')]
    assert len(after) == 1, after
    htext.insert(after[0] + 1, row)
    HISTORY.write_text('\n'.join(htext), encoding='utf-8')
else:
    raise SystemExit(__doc__)
BOARD.write_text('\n'.join(board), encoding='utf-8')
print('board', sys.argv[1], ITEM)
