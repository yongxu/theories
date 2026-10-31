#!/usr/bin/env python3
"""LA4's board row at the formal part's landing (from the checkout root): the row stays (the learner runs are still to
come); its status cell gains the formal part, landed, and its next step. Nothing else on the board changes.
usage: python3 -B board_la4.py RECEIPT N"""
import sys
from pathlib import Path

RECEIPT, N = sys.argv[1], int(sys.argv[2])
BOARD = Path('_process/BECOMING-WORKBOARD.md')
TITLE = '| **LA4: the drain beyond the reward, under training by gradient**'
OLD_TAIL = "; Stage A's code, calibration and power check next |"
NEW_TAIL = (
    f"; the formal part landed (core run {RECEIPT}, every axiom report empty; study §{N}): the core leaves "
    "`Becoming.OptimumSeason` (the season as `season.py` runs it, the optimum laws it meets, the design's enumeration "
    "checks as theorems) and `Becoming.WeightedCommuting` (a weighted law commuting with a map keeps expectations "
    "symmetric; a sampling learner commutes under three conditions; Reinforcing and Pooling), two records "
    "(the-test-season-meets-the-optimum-laws, a-commuting-learner-drives-no-unread-choice), the separable family's "
    "exact flow (`exact_flow.py`), DESIGN §12 and the texts of 05 §7, 08, the overview and the experiments README; "
    "reviewed before the queue (REVIEW-LA4-FORMAL). Stage A's code, mirror test, calibration and power check next, "
    "on a machine suited to them |")

lines = BOARD.read_text(encoding='utf-8').split('\n')
hits = [i for i, l in enumerate(lines) if l.startswith(TITLE)]
assert len(hits) == 1, hits
row = lines[hits[0]]
assert row.count(OLD_TAIL) == 1, 'the status cell has changed: read the row'
# the tail is the end of the status cell, followed by the path and connections cells
i = row.index(OLD_TAIL)
rest = row[i + len(OLD_TAIL):]
assert rest.startswith(' `experiments/drain-beyond-the-reward/`'), rest[:60]
row = row[:i] + NEW_TAIL + rest
# the row's opening named the clause as untested; CG1 and IN1 tested a drain beyond the couplings, and what no test
# yet varies is nearness to the optimum
OLD_OPEN = ("T3's clause on trained systems, which no test yet reaches (the LA1 series tested the bridge to a stated "
            "reward, in context).")
NEW_OPEN = ("T3's clause on trained systems, whose dependence on how near a trained system comes to its reward's "
            "optimum no test yet varies (CG1 and IN1 tested a drain beyond the reward's couplings, the LA1 series the "
            "bridge to a stated reward, in context).")
assert row.count(OLD_OPEN) == 1, 'the row\'s opening has changed: read the row'
lines[hits[0]] = row.replace(OLD_OPEN, NEW_OPEN)
BOARD.write_text('\n'.join(lines), encoding='utf-8')
print('LA4 row: formal part landed')
