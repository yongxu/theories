#!/usr/bin/env python3
"""EV7: the board part of apply_text.py alone, for a rebase that took main's board: the row moves to the history file
and the queue and receipt sentences name the landing.
usage (from the checkout root): python3 -B board.py RECEIPT STUDY_SECTION SL_THEOREMS GE_THEOREMS"""
import re
import sys
from pathlib import Path
ROOT = Path.cwd()
BOARD = '_process/BECOMING-WORKBOARD.md'
HISTORY = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
RID = 'selection-within-and-among-groups-of-any-sizes'
receipt_id, N, n_sl_thm, n_mod_thm = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4])
apart, spine_thms = '-', '-'
# Board: the row moves to the history file; the queue and receipt sentences name the landing.
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith('| **EV7: groups of unequal size')]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-20, core receipt `{receipt_id}`; {n_sl_thm} theorems in Becoming.SelectionLevels and '
            f'{n_mod_thm} in Becoming.GroupEnding (no new module, rule 9), empty axiom reports; record {RID}; study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(20 October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is EV7's `{receipt_id}` (20 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('EV7 ')]
landed = (f'EV7 landed (groups of any sizes and regrouping: the sized division in `Becoming.SelectionLevels`, ending for '
          f'any sizes in `Becoming.GroupEnding`; core receipt `{receipt_id}`, study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id, 'apart', apart, 'spine theorems', spine_thms)
