#!/usr/bin/env python3
"""U2 (WRP2's board_wrp2.py): `land RECEIPT N QUEUE STATE` moves U2's row, its state set to STATE, to the history file
after the last landed row, drops U2's head-of-queue clause, puts QUEUE at the head of the queue note and names the
receipt as the latest. The latest-receipt sentence is matched with any date (the coordinator's note after UE21).
usage (from the checkout root): python3 -B board_u2.py land RECEIPT N QUEUE STATE"""
import datetime
import os
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = re.compile(r"U2's Lean at the head of the queue \([^()]*\); ")
TODAY = datetime.date.today()

board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith('| **U2: ')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)


def history_links(row):
    """The row's links, relative to the board, re-pointed for the history file."""
    def fix(m):
        target = m.group(1)
        if re.match(r'[a-z]+:|#', target):
            return m.group(0)
        path, _, frag = target.partition('#')
        full = os.path.normpath(os.path.join('_process', path))
        assert (ROOT / full).exists(), full
        return '](' + os.path.relpath(full, '_process/history/workboard') + ('#' + frag if frag else '') + ')'
    return re.sub(r'\]\(([^)]+)\)', fix, row)


if sys.argv[1] != 'land':
    raise SystemExit(__doc__)
receipt, section, queue_text, state_text = sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5]
assert f'§{section}' in queue_text and receipt in queue_text
cells[2] = state_text
row = history_links(' | '.join(cells))
del board[rows[0]]
queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
assert len(queue) == 1
assert len(HEAD.findall(board[queue[0]])) == 1, 'head-of-queue clause'
board[queue[0]] = HEAD.sub('', board[queue[0]], count=1)
board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + queue_text + '; ', 1)
latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
assert len(latest) == 1, latest
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(\d{1,2} \w+ \d{4}\)", board[latest[0]])
assert m, 'latest receipt sentence'
board[latest[0]] = board[latest[0]].replace(
    m.group(0), f"the latest core receipt is U2's `{receipt}` ({TODAY.day} {TODAY:%B} {TODAY.year})")
BOARD.write_text('\n'.join(board), encoding='utf-8')
history = HISTORY.read_text(encoding='utf-8').split('\n')
before = len(history)
lapsed = history.index('## Lapsed claims (18 October 2026)')
end = lapsed - 1
while not history[end].startswith('| '):
    end -= 1
history.insert(end + 1, row)
assert len(history) == before + 1
HISTORY.write_text('\n'.join(history), encoding='utf-8')
print('board: U2 landed; row moved to the history file; latest receipt', receipt)
