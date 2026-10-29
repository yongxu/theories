#!/usr/bin/env python3
"""WRT2 (UE15's board_ue15.py): a board row. `head ID TEXT` puts WRT2's head-of-queue clause, "WRT2 at the head of the
queue (TEXT); ", at the front of the queue note; `land ID RECEIPT SECTION QUEUE_TEXT STATE_TEXT` moves the row, its
state set to STATE_TEXT and its statements brought to what the Lean shows, to the history file after the last landed
row, drops WRT2's head-of-queue clause, puts QUEUE_TEXT at the head of the queue note and names the receipt as the
latest. The OU row is its owner's: OU's criterion 7 is reported to it, not edited here.
usage (from the checkout root): python3 -B board_wrt2.py head WRT2 TEXT |
       python3 -B board_wrt2.py land WRT2 RECEIPT N QUEUE STATE"""
import datetime
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = re.compile(r'WRT2 at the head of the queue \([^()]*\); ')
TODAY = datetime.date.today()
# the row's statements, brought to what the Lean shows after the review, in the row moved to history
STATEMENTS = [
    ("the converse (the relational part realized; conservation exactly the debit–credit form; what amounts induce "
     "decided)",
     "the converse (the relational part ranging over everything, at the model too; conservation exactly its form, "
     "\"the standing after the step with `b` is `a`\", half by definition; what amounts induce decided, and every world "
     "deciding its activity exactly excluded middle)"),
    ("(the standing forgotten at the model's selection; balance carried by conservation alone; conservation never "
     "identity on the predicates of `Nat`; a line of falls ends, from `Amounts.falls_end`)",
     "(the model does not determine standings; balance not determined by the web and the signs of exchange, carried at "
     "the model only by conservation's step; conservation never identity on the predicates of `Nat`; a line of falls "
     "ends, from `Amounts.falls_end`, a condition of the World's image)"),
    ("Every statement was checked in a scratch build (28 theorems, every axiom report empty, nothing landed).",
     "After an independent review of the Lean and its re-read, every finding taken: GrammarTransport 41 theorems in "
     "44 declarations and WorldRepresentation 34 in 48, every axiom report empty, with the design's names mapped to "
     "the implemented ones (DESIGN.md §7); record the-world-represented-both-ways (01 §8.6)."),
]
item = sys.argv[2]
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
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(\d{1,2} October 2026\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(m.group(0),
                                                f"the latest core receipt is {item}'s `{receipt}` ({TODAY.day} {TODAY:%B} {TODAY.year})")
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
