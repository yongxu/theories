#!/usr/bin/env python3
"""UE23 (UE22's board_ue22.py): a board row. `claim ID` adds UE23's row to the open claims after UE8's; `state ID
TEXT` sets the row's state; `head ID TEXT` puts UE23's head-of-queue clause, "UE23 at the head of the queue (TEXT); ",
at the front of the queue note; `land ID RECEIPT SECTION QUEUE_TEXT STATE_TEXT` moves the row, its state set to
STATE_TEXT and its statements brought to what the Lean shows, to the history file after the last landed row, drops
UE23's head-of-queue clause, puts QUEUE_TEXT at the head of the queue note and adds UE23 to the UE row's landed items.
The receipt is the periphery checker's, so the latest core receipt is not changed.
usage (from the checkout root): python3 -B board_ue23.py claim UE23 | python3 -B board_ue23.py state UE23 TEXT |
       python3 -B board_ue23.py head UE23 TEXT | python3 -B board_ue23.py land UE23 RECEIPT N QUEUE STATE"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = re.compile(r'UE23 at the head of the queue \([^()]*\); ')
UE_OLD = "and UE20, UE21 and UE22 (30 October)"
UE_NEW = "and UE20, UE21, UE22 and UE23 (30 October)"
PLAN = 'research/2026-10-05-generative-foundation-review/root-foundation/development/ue-unified-explanation/FEP-INTEGRATION.md'
ROW = (
    "| **UE23: seeking by expected free energy, joined to the core's seeking law** "
    f"([plan]({PLAN}) item 8; the join what-seeking-cannot-separate and expected-free-energy-and-its-terms each name "
    "as missing, and the principle's page §5). Purpose: the core's seeking law (Becoming.LumpedSeeking: a pair every "
    "experiment ties keeps its prior order under every course of seeking, whatever the policy of choice) and the "
    "periphery's expected free energy (ExpectedFreeEnergyReals: one step, read through the lumping) stated as one "
    "account of the agent active inference describes. The belief after a course, FreeEnergyReals' posterior of the "
    "prior times the course's likelihood, is the core's share given that course, the choice weights dropping out; "
    "choosing each experiment by any rule reading the experiments' expected free energies at that belief is a policy "
    "of choice in the core's sense, so seeking by expected free energy keeps every tied order; where every "
    "experiment's likelihood reads states through one lumping, the belief after every course is, on the classes, the "
    "classes' belief, so at every step every experiment's expected free energy and epistemic value are the classes', "
    "and two priors alike on the classes make the same choices under every rule (a softmax among them) and give every "
    "course the same weight: the whole course of seeking by expected free energy is blind to the split within a "
    "class; a witness where one separating experiment turns the order. A section of ExpectedFreeEnergyReals "
    "importing Becoming.LumpedSeeking, its periphery checker rerun; laws added to the records; no core file changes. "
    "Reviewed before landing | Claude Code desktop session (farther than FEP), 30 October 2026 | claimed 30 October "
    "2026; drafting | `development/ue23-seeking-by-expected-free-energy/` | UE19, UE17, UE22 → 03 §6, the "
    "principle's page, UE |"
)
# the row's statements, brought to what the Lean shows after the review, in the row moved to history
STATEMENTS = [
    ("The belief after a course, FreeEnergyReals' posterior of the prior times the course's likelihood, is the core's "
     "share given that course, the choice weights dropping out; choosing each experiment by any rule reading the "
     "experiments' expected free energies at that belief is a policy of choice in the core's sense, so seeking by "
     "expected free energy keeps every tied order;",
     "The posterior after a course, FreeEnergyReals' posterior of the prior times the course's likelihood, is, where "
     "the agent's model is the core's, the core's share given a chosen course, the choice weights dropping out, and "
     "the core's order given it is the posterior's; choosing each experiment by any rule with natural weights reading "
     "the experiments' expected free energies is among the core's policies, whatever the agent's model, so seeking by it keeps every tied order (an "
     "instance), and over the reals the softmax keeps it too;"),
    ("the belief after every course is, on the classes, the classes' belief",
     "the posterior after every course is, on the classes, the classes' posterior"),
    ("give every course the same weight", "give every course the same predictive weight"),
    ("a witness where one separating experiment turns the order",
     "witnesses where one separating experiment turns the order and where two priors whose posteriors differ seek "
     "alike"),
]
PENDING = ''
item = sys.argv[2]
assert item == 'UE23', item
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
    if PENDING:
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
