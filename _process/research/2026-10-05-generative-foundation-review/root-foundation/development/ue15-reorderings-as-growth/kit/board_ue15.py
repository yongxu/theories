#!/usr/bin/env python3
"""UE15 (UE14's board_ue14.py): a board row. `state ID TEXT` sets the row's state; `head ID TEXT` puts UE15's
head-of-queue clause, "UE15 at the head of the queue (TEXT); ", at the front of the queue note; `land ID RECEIPT
SECTION QUEUE_TEXT STATE_TEXT` moves the row, its state set to STATE_TEXT and its statements brought to what the Lean
shows, to the history file after the last landed row, drops UE15's head-of-queue clause, puts QUEUE_TEXT at the head
of the queue note, names the receipt as the latest and adds UE15 to the UE row's landed items.
usage (from the checkout root): python3 -B board_ue15.py state UE15 TEXT | python3 -B board_ue15.py head UE15 TEXT |
       python3 -B board_ue15.py land UE15 RECEIPT N QUEUE STATE"""
import datetime
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = re.compile(r'UE15 at the head of the queue \([^()]*\); ')
TODAY = datetime.date.today()
UE_OLD = "and UE12, UE13 and UE14 (28 October)"
UE_NEW = "and UE12, UE13, UE14 and UE15 (28 October)"
# the row's statements, brought to what the Lean shows after the review, in the row moved to history
STATEMENTS = [
    ("UE14's laws on the World by instance (born before on every reordering is precedence, presents are antichains, an "
     "exchange is present at another's step on some reordering exactly where it is a link below it and on every "
     "reordering exactly where it is the one link), with joining decided on the stretch where a law needs it "
     "(precedence then decided by bounded search, a lemma to prove);",
     "UE14's laws on the World by instance, each with its decision (taken before on every reordering is precedence not "
     "refuted with no decision, precedence with the pair decided; with precedence weakly decided, on some reordering "
     "differing and not being preceded; presents are antichains, and with precedence weakly decided every antichain "
     "given by a test is one; an exchange is present when another is taken on some reordering exactly where it is a "
     "link below it, precedence weakly decided, and on every reordering exactly where the other is the one exchange of "
     "the stretch it is linked to, with no decision), joining decided or weakly decided on the stretch deciding "
     "precedence so, by search over the steps between;"),
    ("so presence at a step gives persistence, and a witness joined through a dependence shows the converse fails; "
     "witnesses: the vee as a world.",
     "so presence at a step gives persistence, on the world and on every reordering on which it holds, presence on the "
     "world as it is being precedence with no exchange between joined to the earlier one, and two worlds show the "
     "converse fails, through a dependence and by moving a relatum and moving it back with no dependence; witnesses: "
     "the vee as a world, its order of exchanges UE14's vee."),
    ("A leaf at L1 importing `Becoming.Presence` (Reordering in its closure), namespace to settle; pure core",
     "A leaf at L1 importing `Becoming.Presence` (Reordering in its closure), namespace `ReorderingGrowth`, with one "
     "record, reorderings-as-courses-of-growth (01 §9.6); pure core"),
]
item = sys.argv[2]
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
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(m.group(0),
                                                f"the latest core receipt is {item}'s `{receipt}` ({TODAY.day} {TODAY:%B} {TODAY.year})")
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
