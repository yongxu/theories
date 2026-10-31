#!/usr/bin/env python3
"""HE2: the board. `head TEXT` puts TEXT, the claim at the head of the queue, before the queue note's entries, and
refuses where another item holds the head, in either phrasing ("at the head of the queue (" or "landing now";
board rule 5). `land RECEIPT N QUEUE_TEXT STATE_TEXT` drops that claim and puts QUEUE_TEXT at the head instead, names
the receipt as the latest, dated today, and moves HE2's row, with STATE_TEXT as its state, to the end of the history
file's landed rows, its links rebased to the history file (board rule 4).
Run it on a copy of main's board for the head (the commit-tree method), and in the landing worktree for the land.
usage (from the checkout root): python3 -B he2_board.py head TEXT | python3 -B he2_board.py land RECEIPT N QUEUE STATE"""
from datetime import datetime, timezone
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
ITEM = 'HE2'
HEAD = 'HE2 at the head of the queue ('
PREFIX = '- **Queue:** '
NOW = datetime.now(timezone.utc)
DAY = f'{NOW.day} {NOW:%B %Y}'
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
    line = board[queue[0]]
    print('the queue opens:', line[len(PREFIX):len(PREFIX) + 160])
    assert HEAD not in line, 'already claimed'
    assert 'at the head of the queue (' not in line and 'landing now' not in line, \
        'another item holds the head: claim behind it'
    board[queue[0]] = line.replace(PREFIX, PREFIX + text + '; ', 1)
elif sys.argv[1] == 'land':
    receipt, section, queue_text, state_text = sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5]
    assert f'§{section}' in queue_text and receipt in queue_text
    rest = without_head(board[queue[0]])
    assert 'at the head of the queue (' not in rest and 'landing now' not in rest, 'another claim at the head'
    board[queue[0]] = rest.replace(PREFIX, PREFIX + queue_text + '; ', 1)
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(\d{1,2} \w+ 20\d\d\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(m.group(0), f"the latest core receipt is HE2's `{receipt}` ({DAY})")
    # HE2's row to the end of the history file's landed rows (board rule 4), links relative to the history file.
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
    lapsed = [i for i, line in enumerate(htext) if line.startswith('## Lapsed claims')]
    assert len(lapsed) == 1, lapsed
    end = lapsed[0] - 1
    while not htext[end].startswith('| **'):
        assert not htext[end].strip(), ('unexpected text before the lapsed claims', htext[end][:60])
        end -= 1
    htext.insert(end + 1, row)
    HISTORY.write_text('\n'.join(htext), encoding='utf-8')
else:
    raise SystemExit(__doc__)
BOARD.write_text('\n'.join(board), encoding='utf-8')
print('board', sys.argv[1], ITEM)
