#!/usr/bin/env python3
"""UE24 (UE23's board_ue23.py): `head ID TEXT` puts UE24's head-of-queue clause, "UE24 at the head of the queue
(TEXT); ", at the front of the queue note; `land ID RECEIPT SECTION QUEUE_TEXT STATE_TEXT` moves the row, its state set
to STATE_TEXT and its first cell brought to what the Lean shows after the review and its recheck, to the history file
after the last landed row, drops UE24's head-of-queue clause, puts QUEUE_TEXT at the head of the queue note and adds
UE24 to the UE row's landed items. The receipt is the periphery checker's, so the latest core receipt is not changed.
usage (from the checkout root): python3 -B board_ue24.py head UE24 TEXT |
       python3 -B board_ue24.py land UE24 RECEIPT N QUEUE STATE"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = re.compile(r'UE24 at the head of the queue \([^()]*\); ')
UE_OLD = "and UE20, UE21, UE22 and UE23 (30 October)"
UE_NEW = "and UE20, UE21, UE22, UE23 and UE24 (30 October)"
# the first cell as claimed (3bc5ecf60)
CLAIMED = (
    '| **UE24: identical cells under noise, which cell takes which place drawn** (the identical-cells rec'
    "ord's scope on noise and its next step, exchanges of any two cells; the principle's page §5, noise)."
    " Purpose: the theory's first statement on the principle's stochastic ground. For finitely many cells"
    ' with finitely many states, weights on configurations moved by a kernel in discrete steps: a kernel '
    'commuting with every rearrangement of the cells keeps an exchangeable law exchangeable, so from iden'
    'tical cells (all in one state, or each drawn independently by one law) every cell has the law of eve'
    'ry other at every step and each assignment of distinct states has weight at most one over the number'
    ' of orderings of the cells; a unique stationary law, and the steady-state form of a free energy symm'
    'etric in the cells, are exchangeable; the deterministic law is the case with no noise. Joined to the'
    " core: exchanges of neighbouring cells generate every rearrangement, so the core's descent with an e"
    'xchangeable field, read cell by cell, commutes with every rearrangement, its run without noise is th'
    "e core's run, and with noise of one law at every cell the law stays exchangeable. Witnesses on two c"
    'ells: a kernel parting them with certainty, which cell is which a fair draw, its only stationary law'
    " giving the alike configurations no weight; a cue reading a cell's number fixes the places. A new pe"
    'riphery module CellsUnderNoise importing Becoming.FreeEnergyGuarantees, with its own checker; a new '
    'record beside the identical-cells record; no core file changes. Reviewed before landing'
)
# the first cell brought to what the Lean shows (REVIEW-UE24 F8 and the recheck)
LANDED = (
    "| **UE24: identical cells under noise, an exchangeable law stays exchangeable** (the identical-cells record's "
    "scope on noise and its next step, exchanges of any two cells; the principle's page §5, noise). Purpose: the law "
    "on identical cells stated for finite Markov chains with noise. For finitely many cells with finitely many "
    "states, weights on configurations moved in discrete steps by kernels, one for each step: kernels commuting with "
    "every rearrangement of the cells keep exchangeable weights exchangeable, so from identical cells (all in one "
    "state, or independent and of one law) every cell has the weights of every other at every step and, where the "
    "kernels and the start are laws, each assignment of distinct states has weight at most one over the number of "
    "orderings of the cells; under a kernel commuting with every rearrangement a unique stationary law is "
    "exchangeable, and so are the Gibbs weights of a free energy no rearrangement changes, no kernel being shown to "
    "keep them; the law of one configuration is exchangeable only with all its cells alike. Joined to the core: "
    "exchanges of neighbouring cells generate every rearrangement; the core's descent, read cell by cell, has the "
    "core's run as its run; with an exchangeable field it commutes with every rearrangement, and with noise of one "
    "law at every cell, reading the cell's own state and the field it senses, exchangeable weights stay "
    "exchangeable; from all cells in one state some configuration of all cells alike keeps positive weight at every "
    "step, so independent noise never parts identical cells with certainty, though it can part them. Witnesses on "
    "two cells: a kernel commuting with the exchange that parts alike cells with certainty is the fair mixture of two "
    "rules assigning the places by the cells' numbers, and no noise of one law at every cell; a field reading the "
    "first cell, not exchangeable, assigns the places from an exchangeable start. The law forbids no statement of the "
    "2015 paper, whose scheme is exchangeable. A new periphery module CellsUnderNoise importing "
    "Becoming.FreeEnergyGuarantees, with its own checker; a new record beside the identical-cells record; no core "
    "file changes. Reviewed and rechecked before landing"
)
item = sys.argv[2]
assert item == 'UE24', item
board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith(f'| **{item}: ')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)
queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
assert len(queue) == 1

if sys.argv[1] == 'head':
    assert not HEAD.findall(board[queue[0]]), 'a head-of-queue clause is already there'
    clause = f'{item} at the head of the queue ({sys.argv[3]}); '
    assert HEAD.fullmatch(clause), clause
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
elif sys.argv[1] == 'land':
    receipt, section, queue_text, state_text = sys.argv[3], int(sys.argv[4]), sys.argv[5], sys.argv[6]
    assert f'§{section}' in queue_text and receipt in queue_text
    assert cells[0] == CLAIMED, 'the claimed first cell changed'
    assert LANDED.count(' | ') == 0
    cells[0] = LANDED
    cells[2] = state_text
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
