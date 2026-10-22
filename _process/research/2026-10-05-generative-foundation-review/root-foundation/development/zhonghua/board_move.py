#!/usr/bin/env python3
"""Move a landed row from the live board to the history file (board rule 4) and name the landing first in the queue
note: python3 -I board_move.py STATE NOTE [ROW_PREFIX]   (from the repository root)
  STATE       the new state cell, links relative to the live board (re-rooted for the history file)
  NOTE        the sentence put first in the queue note ("ZH landed (…)")
  ROW_PREFIX  the row's opening, ZH's by default (WL: '| **WL: 文理生生 joined')"""
import sys
from pathlib import Path

BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
PREFIX = sys.argv[3] if len(sys.argv) > 3 else '| **ZH: the 中华 edition of the theory'
state, note = sys.argv[1], sys.argv[2]
board = Path(BOARD).read_text(encoding='utf-8')
history = Path(HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith(PREFIX)]
assert len(rows) == 1, (PREFIX, len(rows))
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = state
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
last = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(last + 1, row)
q = [i for i, line in enumerate(lines) if line.startswith('- **Queue:** ')]
assert len(q) == 1, len(q)
lines[q[0]] = '- **Queue:** ' + note + '; ' + lines[q[0]][len('- **Queue:** '):]
Path(BOARD).write_text('\n'.join(lines), encoding='utf-8')
Path(HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('moved the row', PREFIX, 'to', HISTORY)
