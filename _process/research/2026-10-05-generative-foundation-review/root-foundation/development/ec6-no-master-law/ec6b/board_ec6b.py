#!/usr/bin/env python3
"""EC6b's landing on the board (after board_ma4b.py): the row's state set, the row moved to the history file after
the last landed row, the queue note's head mark replaced by the landing, and the receipt named as the latest.
usage (from the checkout root): python3 -B board_ec6b.py RECEIPT N"""
import re
import sys
from pathlib import Path

RECEIPT, N = sys.argv[1], int(sys.argv[2])
BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
STATE = (f"landed 2026-10-28 (core receipt `{RECEIPT}`, study §{N}): Pace, RuleCapture, Lasting, RegimeMargin, Closing "
         "and Decidedness re-proved through the closure law and the stretch balance, every statement unchanged; the "
         "seven closure rows reach the grammar and the census rests on balance; the measure's gaps from 13 to 5 "
         "(OU3d 3, EC6c 2); 47 records re-pointed, 44 proof bindings rebound")
QUEUE = (f"EC6b landed (EC6's cases of closure and balance derived, board rule 9: `Pace.stays` and `stays_turned`, regions "
         "the paced step keeps, by Invariant.reach with Run.reach, re-prove RuleCapture's locks and `rule_until_reading`; "
         "`Lasting.orbit_mono` by the product law; `downstream_within` and `ends_downstream`; `Upstream.within`, "
         "`Coupled.of_reach` and `onLoop_of_closing`; `Counts.over_stretch_decided` from balance_over_stretch_on by "
         f"finite choice on a stretch; every statement unchanged; core receipt `{RECEIPT}`, study §{N}; of the 118 "
         "distinct central declarations 40 reach the grammar, 30 rest on balance, 6 on an anchor with reasons and 42 on "
         "no master law, each with its reason; the measure's gaps 5, OU3d's 3 and EC6c's 2; row in the history file)")

board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith('| **EC6b: ')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = STATE
row = ' | '.join(cells)
del board[rows[0]]
queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
assert len(queue) == 1
head = re.match(r'- \*\*Queue:\*\* EC6b at the head of the queue \([^()]*\); ', board[queue[0]])
assert head, 'head mark'
board[queue[0]] = '- **Queue:** ' + QUEUE + '; ' + board[queue[0]][head.end():]
latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
assert len(latest) == 1, latest
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board[latest[0]])
assert m, 'latest receipt sentence'
board[latest[0]] = board[latest[0]].replace(m.group(0), f"the latest core receipt is EC6b's `{RECEIPT}` (28 October 2026)")
BOARD.write_text('\n'.join(board), encoding='utf-8')
history = HISTORY.read_text(encoding='utf-8').split('\n')
lapsed = history.index('## Lapsed claims (18 October 2026)')
end = lapsed - 1
while not history[end].startswith('| '):
    end -= 1
history.insert(end + 1, row)
HISTORY.write_text('\n'.join(history), encoding='utf-8')
print('board landed EC6b')
