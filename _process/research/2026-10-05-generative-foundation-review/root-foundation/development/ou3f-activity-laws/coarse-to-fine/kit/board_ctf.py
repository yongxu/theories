#!/usr/bin/env python3
"""OU3f's coarse-to-fine pair, the last of OU3f: the board. `head TEXT` prints the Queue line's opening for the lander
to read, puts TEXT, the claim at the head of the queue, before the queue note's entries, and refuses where another item
already holds the head (board rule 5). The guard knows only the phrasings "at the head of the queue (" and "landing now",
so read the printed line: a claim phrased otherwise (OU3d's "next after UE15 (") must not be jumped.
`land RECEIPT SECTION QUEUE_TEXT LANDED_CLAUSE` drops that claim and puts QUEUE_TEXT at the head instead, names the
receipt as the latest, dated today, and moves OU3f's row, the item done, to the history file (board rule 4). Its state
is built from the row's own cell: the closing "next: the coarse-to-fine pair" becomes LANDED_CLAUSE, so the account
of the earlier parts (§442, §443, §445, §451) stays as written. The row goes at the end of the landed rows, before the
next heading, its links rebased.
usage (from the checkout root): python3 -B <kit>/board_ctf.py head TEXT
                             | python3 -B <kit>/board_ctf.py land RECEIPT N QUEUE LANDED_CLAUSE"""
from datetime import date
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
ITEM = 'OU3f'
HEAD = "OU3f's coarse-to-fine pair at the head of the queue ("
NEXT = '; next: the coarse-to-fine pair'
LANDED = '## Landed after the board was rewritten'
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
    print('Queue line, read before claiming:', board[queue[0]][:600], sep='\n')
    assert text.startswith(HEAD) and text.endswith(')'), text[:60]
    assert HEAD not in board[queue[0]], 'already claimed'
    for held in ('at the head of the queue (', 'landing now'):
        assert held not in board[queue[0]], f'another item holds the head ("{held}"): claim behind it'
    board[queue[0]] = board[queue[0]].replace(PREFIX, PREFIX + text + '; ', 1)
elif sys.argv[1] == 'land':
    receipt, section, queue_text, landed_clause = sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5]
    assert f'§{section}' in queue_text and receipt in queue_text
    assert f'§{section}' in landed_clause and receipt in landed_clause, 'the landed clause names the section and receipt'
    board[queue[0]] = without_head(board[queue[0]]).replace(PREFIX, PREFIX + queue_text + '; ', 1)
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(\d{1,2} \w+ 20\d\d\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(m.group(0), f"the latest core receipt is OU3f's `{receipt}` ({DAY})")
    # OU3f's row to the history file's landed rows (board rule 4), its state built from its own cell, links relative
    # to the history file.
    rows = [i for i, line in enumerate(board) if line.startswith(f'| **{ITEM}: ')]
    assert len(rows) == 1, rows
    cells = board[rows[0]].split(' | ')
    assert len(cells) == 5, len(cells)
    assert cells[2].endswith(NEXT), 'the state cell no longer ends with the coarse-to-fine pair as next: ' + cells[2][-80:]
    for earlier in ('§442', '§443', '§445', '§451'):
        assert earlier in cells[2], f'the state cell lacks {earlier}'
    cells[2] = cells[2][:-len(NEXT)] + '; ' + landed_clause
    row = ' | '.join(cells)
    row = re.sub(r'\]\((research/)', r'](../../\1', row)
    row = re.sub(r'\]\(\.\./(theories|sources)/', r'](../../../\1/', row)
    del board[rows[0]]
    htext = HISTORY.read_text(encoding='utf-8').split('\n')
    start = [i for i, line in enumerate(htext) if line.startswith(LANDED)]
    assert len(start) == 1, start
    end = next(i for i in range(start[0] + 1, len(htext)) if htext[i].startswith('## '))
    last = max(i for i in range(start[0], end) if htext[i].startswith('| '))
    htext.insert(last + 1, row)
    HISTORY.write_text('\n'.join(htext), encoding='utf-8')
else:
    raise SystemExit(__doc__)
BOARD.write_text('\n'.join(board), encoding='utf-8')
print('board', sys.argv[1], ITEM)
