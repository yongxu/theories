#!/usr/bin/env python3
"""UE14 (UE13's board_ue13.py): a board row. `state ID TEXT` sets the row's state; `head ID TEXT` puts UE14's
head-of-queue clause, "UE14 at the head of the queue (TEXT); ", at the front of the queue note; `land ID RECEIPT
SECTION QUEUE_TEXT STATE_TEXT` moves the row, its state set to STATE_TEXT and its statements brought to what the Lean
shows, to the history file after the last landed row, drops UE14's head-of-queue clause, puts QUEUE_TEXT at the head
of the queue note, names the receipt as the latest and adds UE14 to the UE row's landed items.
usage (from the checkout root): python3 -B board_ue14.py state UE14 TEXT | python3 -B board_ue14.py head UE14 TEXT |
       python3 -B board_ue14.py land UE14 RECEIPT N QUEUE STATE"""
import datetime
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = re.compile(r'UE14 at the head of the queue \([^()]*\); ')
TODAY = datetime.date.today()
UE_OLD = "and UE12 and UE13 (28 October)"
UE_NEW = "and UE12, UE13 and UE14 (28 October)"
# the row's statements, brought to what the Lean shows after the review, in the row moved to history
STATEMENTS = [
    ("(the core's Mazurkiewicz theorem, `OrderNormal.rearranges_iff`, as an instance)",
     "(the core's Mazurkiewicz theorem, `rearranges_iff` in `Becoming.OrderNormal`, as an instance)"),
    ("Laws, with precedence decided: what a course has born after t births is exactly a down-set of t elements, each one "
     "born so on some course;",
     "Laws, each with the decision it needs: what a course has born by a stage is a stem, and with membership decided "
     "every stem is what some course has born first;"),
    ("i precedes j exactly where i is born before j on every course (Szpilrajn's theorem read on growth, the "
     "counterpart of Stein's);",
     "with precedence decided, i precedes j exactly where i is born before j on every course (Szpilrajn's theorem in "
     "Dushnik and Miller's form, read on growth), so what is born no later than an element on every course is its past "
     "with itself, "
     "the largest relation every course respects (a maximum, not Stein's uniqueness), and with precedence weakly "
     "decided i is born before j on some course exactly where they differ and j does not precede i; the present at a "
     "stage, the maximal elements of what is born, is an antichain, and with precedence weakly decided every antichain "
     "given by a test is one; two elements are present together on some course exactly where unrelated (precedence "
     "weakly decided), and on every course exactly where they have the same future (precedence decided);"),
    ("a condition is on the frontier when what it conditions is born on some course exactly where it conditions it "
     "directly, a link,",
     "a condition is present when what it conditions is born on some course exactly where it conditions it directly, "
     "a link (precedence weakly decided),"),
    ("and on every course exactly where all it conditions is that element or above it;",
     "and on every course, with no decision, exactly where that is the one element it is linked to; asked of every "
     "causal set, each calibrated decision is exactly excluded middle or its weak form;"),
    ("witnesses: on three elements presence on the frontier differs between two courses,",
     "witnesses: on three elements presence at a birth, and the present after two births, differ between two courses,"),
    ("and on Wüthrich and Callender's four, invariance under automorphisms does not single out precedence.",
     "and on Wüthrich and Callender's four their relation, kept by every automorphism, is not what every course has "
     "born by a birth, and on those elements is the past with the pair present together on every course, a join that "
     "need not be transitive elsewhere."),
    ("So presence in time beyond precedence and these two bounds is a choice of course on a covariant growth.",
     "So presence in time between these bounds, each defined from precedence, is a choice of course on a covariant "
     "growth."),
    ("A leaf at L1 importing Becoming.CausalGrowth and Becoming.OrderNormal (namespace `Presence`); pure core",
     "A leaf at L1 importing Becoming.CausalGrowth and Becoming.OrderNormal (namespace `Presence`), each main law also "
     "stated on the growth's courses, with one record, the-present-on-causal-set-growth (01 §1); pure core"),
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
