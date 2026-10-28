#!/usr/bin/env python3
"""EC6c and EC6d's landing on the board (after board_ec6b.py): both rows' states set and the rows moved to the history
file after the last landed row, the landing put at the head of the queue note, and the receipt named as the latest.
usage (from the checkout root): python3 -B board_ec6c.py RECEIPT N"""
import re
import sys
from pathlib import Path

RECEIPT, N = sys.argv[1], int(sys.argv[2])
BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
STATES = {
    'EC6c': (f"landed 2026-10-28 (core receipt `{RECEIPT}`, study §{N}): `Flow.BalancesBetween` beside `Flow.Balances` with "
             "`Flow.balances_iff_between` by `Iff.rfl` (`Flow.Balances` not redefined), `Optimum.Outcome` spelled with it "
             "(Optimum's proofs passing unchanged), the clause in `LAWS['balance']`; `Optimum.optimum_beyond` and "
             "`mutual_beyond` rest on balance"),
    'EC6d': (f"landed 2026-10-28 (study §{N}): COVERAGE's actor row cites `PartForms.goAlike`, the measure reporting it a "
             "case of the grammar's lumping law not yet derived; the life row keeps its two `*_reaches`, `Valuation.reaches` "
             "being generic; census-balance gains the counted census read of activity on a web, so `CensusWebs.keep_pace` "
             "has a record; no record's statement changed"),
}
QUEUE = (f"EC6c and EC6d landed (Optimum's balance clause named once as `Flow.BalancesBetween`, `Flow.Balances` unchanged; "
         f"COVERAGE's actor row on `PartForms.goAlike`; census-balance homing `CensusWebs.keep_pace`; core receipt `{RECEIPT}`, "
         f"study §{N}; of the 118 distinct central declarations 40 reach the grammar, 32 rest on balance, 7 on another "
         "anchor (6 with reasons, 1 pending), 39 on no master law, each with its reason; the measure's gaps 4, OU3d's 3 and "
         "PartForms.goAlike's lumping derivation; rows in the history file)")

board = BOARD.read_text(encoding='utf-8').split('\n')
history = HISTORY.read_text(encoding='utf-8').split('\n')
moved = []
for item, state in STATES.items():
    rows = [i for i, line in enumerate(board) if line.startswith(f'| **{item}: ')]
    assert len(rows) == 1, (item, rows)
    cells = board[rows[0]].split(' | ')
    assert len(cells) == 5, len(cells)
    cells[2] = state
    moved.append(' | '.join(cells))
    del board[rows[0]]
queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
assert len(queue) == 1
board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + QUEUE + '; ', 1)
latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
assert len(latest) == 1, latest
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board[latest[0]])
assert m, 'latest receipt sentence'
board[latest[0]] = board[latest[0]].replace(m.group(0), f"the latest core receipt is EC6c's `{RECEIPT}` (28 October 2026)")
BOARD.write_text('\n'.join(board), encoding='utf-8')
lapsed = history.index('## Lapsed claims (18 October 2026)')
end = lapsed - 1
while not history[end].startswith('| '):
    end -= 1
for k, row in enumerate(moved):
    history.insert(end + 1 + k, row)
HISTORY.write_text('\n'.join(history), encoding='utf-8')
print('board landed EC6c and EC6d')
