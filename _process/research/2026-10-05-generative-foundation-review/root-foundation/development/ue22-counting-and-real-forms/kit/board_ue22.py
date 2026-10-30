#!/usr/bin/env python3
"""UE22 (UE17's board_ue17.py, with a claim): a board row. `claim ID` adds UE22's row to the open claims after
UE8's; `state ID TEXT` sets the row's state; `head ID TEXT` puts UE22's head-of-queue clause, "UE22 at the head of
the queue (TEXT); ", at the front of the queue note; `land ID RECEIPT SECTION QUEUE_TEXT STATE_TEXT` moves the row,
its state set to STATE_TEXT and its statements brought to what the Lean shows, to the history file after the last
landed row, drops UE22's head-of-queue clause, puts QUEUE_TEXT at the head of the queue note and adds UE22 to the UE
row's landed items. The receipts are the periphery checkers', so the latest core receipt is not changed.
usage (from the checkout root): python3 -B board_ue22.py claim UE22 | python3 -B board_ue22.py state UE22 TEXT |
       python3 -B board_ue22.py head UE22 TEXT | python3 -B board_ue22.py land UE22 RECEIPT N QUEUE STATE"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = re.compile(r'UE22 at the head of the queue \([^()]*\); ')
UE_OLD = "and UE20 and UE21 (30 October)"
UE_NEW = "and UE20, UE21 and UE22 (30 October)"
PLAN = 'research/2026-10-05-generative-foundation-review/root-foundation/development/ue-unified-explanation/FEP-INTEGRATION.md'
ROW = (
    "| **UE22: the counting form and the real form of the free-energy bound, joined** "
    f"([plan]({PLAN}) item 7; the open item free-energy-bound-in-counts names, and UE21's review F7: at "
    "FreeEnergyReals' next change). Purpose: the principle's central bound stated as one law in its two forms, so "
    "that the core's counting form and the periphery's real form are not two results beside each other. For a "
    "belief with natural counts n over hypotheses listed once, with a positive total N, against natural joint "
    "weights a, with no count where the weight is nothing: N times the gap between the belief's free energy and "
    "the surprisal of the total (FreeEnergyReals, over the reals) is the logarithm of the ratio of the counting "
    "bound's two sides (Becoming.FreeEnergyCounting). So the real bound at count beliefs follows from the core's, "
    "the two cases of equality (proportion; the posterior) are one, and away from proportion both are strict; the "
    "gap is the divergence from the posterior, the counting ratio its exponential (the method of types); in the "
    "core's generative model the same holds against the joint shares and the record's share, the whole weight "
    "dropping out; off the support the identity fails (a witness). A section of FreeEnergyReals importing "
    "Becoming.FreeEnergyCounting, its docstring brought up to date; the periphery checkers rerun for "
    "FreeEnergyReals and ExpectedFreeEnergyReals; laws added to free-energy-bounds-surprisal; no core file "
    "changes. Reviewed and re-checked before landing | Claude Code desktop session (farther than FEP), 30 October "
    "2026 | claimed 30 October 2026; drafting | `development/ue22-counting-and-real-forms/` | UE17, UE21 → "
    "03 §6, the principle's page, UE |"
)
# the row's statements, brought to what the Lean shows after the review, in the row moved to history
STATEMENTS = [
    ("and UE21's review F7: at FreeEnergyReals' next change)", "and UE21's review F6, with F7(a): at FreeEnergyReals' next change)"),
    ("So the real bound at count beliefs follows from the core's, ",
     "So the two bounds hold at such a belief exactly together, the real bound there follows from the core's, "),
    ("in the core's generative model the same holds against the joint shares and the record's share, the whole weight "
     "dropping out; off the support the identity fails (a witness).",
     "in the core's generative model the same holds against the joint shares and the record's share, the whole weight "
     "dropping out; off the support or with a hypothesis listed twice the identity can fail (witnesses)."),
    ("the counting ratio its exponential (the method of types)",
     "the counting bound's two sides differing by the exponential of N times it (the method of types)"),
]
PENDING = ("; pending at Becoming.FreeEnergyCounting's next change (RECHECK-UE22 N2): its docstring and "
           "Witness.off_support's say the real form fails at that witness, where it holds at equality "
           "(FreeEnergy.Witness.one_count_off_support)")
item = sys.argv[2]
assert item == 'UE22', item
board = BOARD.read_text(encoding='utf-8').split('\n')

if sys.argv[1] == 'claim':
    assert not [line for line in board if line.startswith(f'| **{item}: ')], 'already claimed'
    ue8 = [i for i, line in enumerate(board) if line.startswith('| **UE8: ')]
    assert len(ue8) == 1, ue8
    assert ROW.count(' | ') == 4, ROW.count(' | ')
    board.insert(ue8[0] + 1, ROW)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
    print('board claim', item)
    raise SystemExit(0)

rows = [i for i, line in enumerate(board) if line.startswith(f'| **{item}: ')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)
queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
assert len(queue) == 1

if sys.argv[1] == 'state':
    cells[2] = sys.argv[3]
    board[rows[0]] = ' | '.join(cells)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
elif sys.argv[1] == 'head':
    assert not HEAD.findall(board[queue[0]]), 'a head-of-queue clause is already there'
    clause = f'{item} at the head of the queue ({sys.argv[3]}); '
    assert HEAD.fullmatch(clause), clause
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
elif sys.argv[1] == 'land':
    receipt, section, queue_text, state_text = sys.argv[3], int(sys.argv[4]), sys.argv[5], sys.argv[6]
    assert f'§{section}' in queue_text and receipt in queue_text
    cells[2] = state_text
    for old, new in STATEMENTS:
        assert cells[0].count(old) == 1, old[:60]
        cells[0] = cells[0].replace(old, new)
    row = ' | '.join(cells)
    del board[rows[0]]
    queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
    assert len(queue) == 1
    assert len(HEAD.findall(board[queue[0]])) == 1, 'head-of-queue clause'
    board[queue[0]] = HEAD.sub('', board[queue[0]], count=1)
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + queue_text + '; ', 1)
    ue = [i for i, line in enumerate(board) if line.startswith('| **UE: a unified explanation of reality**')]
    assert len(ue) == 1, ue
    ue_cells = board[ue[0]].split(' | ')
    assert len(ue_cells) == 5 and ue_cells[2].count(UE_OLD) == 1, 'the UE row'
    ue_cells[2] = ue_cells[2].replace(UE_OLD, UE_NEW)
    assert PENDING not in ue_cells[2]
    ue_cells[2] = ue_cells[2].rstrip() + PENDING
    board[ue[0]] = ' | '.join(ue_cells)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
    history = HISTORY.read_text(encoding='utf-8').split('\n')
    lapsed = history.index('## Lapsed claims (18 October 2026)')
    end = lapsed - 1
    while not history[end].startswith('| '):
        end -= 1
    history.insert(end + 1, row)
    HISTORY.write_text('\n'.join(history), encoding='utf-8')
else:
    raise SystemExit(__doc__)
print('board', sys.argv[1], item)
