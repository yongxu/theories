#!/usr/bin/env python3
"""UE19 (UE18's board script): a board row. `state ID TEXT` sets the row's state; `head ID TEXT` puts UE19's
head-of-queue clause, "UE19 at the head of the queue (TEXT); ", at the front of the queue note; `land ID RECEIPT
SECTION QUEUE_TEXT STATE_TEXT` moves the row, its state set to STATE_TEXT and its statements brought to what the Lean
shows, to the history file after the last landed row, drops UE19's head-of-queue clause, puts QUEUE_TEXT at the head
of the queue note, names the core receipt as the latest and adds UE19 to the UE row's landed items (after UE17, or
after UE18 where it has landed).
usage (from the checkout root): python3 -B board_ue19.py state UE19 TEXT | python3 -B board_ue19.py head UE19 TEXT |
       python3 -B board_ue19.py land UE19 RECEIPT N QUEUE STATE"""
import datetime
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = re.compile(r'UE19 at the head of the queue \([^()]*\); ')
TODAY = datetime.date.today()
UE_LANDED = re.compile(r"and (UE16(?:, UE17)?) and (UE1[78]) \(29 October\)")
# the row's statements, brought to what the Lean shows after the review and the re-check, in the row moved to history
STATEMENTS = [
    ("In counting form in the core: hypotheses a model's likelihoods do not tell apart keep their ratio under every "
     "record, so no outcome sought separates them (from `ConditionalWeights.posterior_le_iff`, generalization through "
     "lumping); in the periphery, on Mathlib's reals beside UE17: expected free energy as risk plus ambiguity and as "
     "less epistemic and pragmatic value, the epistemic value of a policy nothing on a distinction the likelihoods "
     "lump.",
     "In counting form in the core (`Becoming.LumpedSeeking`, record what-seeking-cannot-separate): a pair every "
     "experiment ties keeps its prior order under every course of seeking, each experiment chosen from the course so "
     "far, whatever the policy of choice, and seeking turns the order once an experiment separating it is chosen; in "
     "the periphery, on Mathlib's reals beside UE17 (`ExpectedFreeEnergyReals`, record "
     "expected-free-energy-and-its-terms): expected free energy as risk plus ambiguity and as the negative of epistemic "
     "less pragmatic value, the epistemic value an expected information gain, read only through the lumping the "
     "likelihood makes."),
]
item = sys.argv[2]
assert item == 'UE19', item
board = BOARD.read_text(encoding='utf-8').split('\n')
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
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is ([^;]*?)`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    # landed together with UE18 on one receipt, the sentence names both
    owner = "UE18's and UE19's" if m.group(2) == receipt and m.group(1).strip() == "UE18's" else f"{item}'s"
    board[latest[0]] = board[latest[0]].replace(m.group(0),
                                                f"the latest core receipt is {owner} `{receipt}` ({TODAY.day} {TODAY:%B} {TODAY.year})")
    ue = [i for i, line in enumerate(board) if line.startswith('| **UE: a unified explanation of reality**')]
    assert len(ue) == 1, ue
    ue_cells = board[ue[0]].split(' | ')
    found = UE_LANDED.findall(ue_cells[2])
    assert len(ue_cells) == 5 and len(found) == 1, 'the UE row'
    ue_cells[2] = UE_LANDED.sub(lambda x: f"and {x.group(1)}, {x.group(2)} and UE19 (29 October)", ue_cells[2])
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
