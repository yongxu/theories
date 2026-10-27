#!/usr/bin/env python3
"""UE13 (UE12's board_ue12.py): a board row. `state ID TEXT` sets the row's state; `head ID TEXT` puts UE13's
head-of-queue clause, "UE13 at the head of the queue (TEXT); ", at the front of the queue note; `land ID RECEIPT
SECTION QUEUE_TEXT STATE_TEXT` moves the row, its state set to STATE_TEXT and its statements brought to what the Lean
shows, to the history file after the last landed row, drops UE13's head-of-queue clause, puts QUEUE_TEXT at the head
of the queue note, names the receipt as the latest and adds UE13 to the UE row's landed items.
usage (from the checkout root): python3 -B board_ue13.py state UE13 TEXT | python3 -B board_ue13.py head UE13 TEXT |
       python3 -B board_ue13.py land UE13 RECEIPT N QUEUE STATE"""
import datetime
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = re.compile(r'UE13 at the head of the queue \([^()]*\); ')
TODAY = datetime.date.today()
UE_OLD = "UE10, UE0's evolution rows in 08 §8 and UE11 (27 October), and UE12 (28 October)"
UE_NEW = "UE10, UE0's evolution rows in 08 §8 and UE11 (27 October), and UE12 and UE13 (28 October)"
# the row's statements, brought to what the Lean shows after the review and the re-check, in the row moved to history
STATEMENTS = [
    ("precedence is the reach of the links, the root's `«及»`, on finite labelled causal sets, and need not be where the "
     "order is not locally finite (a witness on ω + 1)",
     "precedence is the reach of its links, the root's `«及»`, on naturally labelled orders with decided precedence, "
     "the finite labelled causal sets among them, the decision not droppable (excluded middle), and the links can fail "
     "where an interval is infinite (a witness on ω + 1)"),
    ("and on every course what can be born next, its stems, keeps widening (UE10)",
     "and on every course from a causal set what can be born next, its stems, keeps widening (UE10)"),
    ("so of two courses one widens what can be born next exactly where it loses precedence",
     "so of two courses from the empty set one includes the other's stems exactly where its precedence is included in "
     "the other's, and widens them where, besides, the other has a pair it lacks"),
    ("widening never adds continuation within the one class, while read on links a finer class can gain continuation "
     "(a witness)",
     "widening adds no continuation of any class read on precedence, while read on links a finer class can gain or lose "
     "it (witnesses)"),
    ("the course of births with empty pasts is widest and nothing continues in it, the single chain is narrowest.",
     "the course of births with empty pasts includes the stems of every course from the empty set and nothing "
     "continues in it, and every such course includes the single chain's; read on what continues the order reverses, "
     "no strict order contains both, and no configuration renews without end; finding the pair a widening loses is "
     "excluded middle, and most comparisons need the empty start (witnesses); up to relabelling the pasts still "
     "reverse precedence and the kinds of birth do not (witnesses)."),
    ("So a reading of 生生 as widening the adjacent possible alone ranks highest the course in which nothing continues, "
     "and one as continuation alone the single chain.",
     "So what widening ranks depends on what it is read on, the course in which nothing continues on what can be born "
     "next and the single chain on what continues; with every continuation's losses counted the reading is on both "
     "together, where C ranks no two courses and ordering them needs a measure."),
    ("A leaf at L1 importing Becoming.ReachableRanges and Becoming.HeldPossible",
     "A leaf at L1 importing Becoming.HeldPossible, with two records, precedence-and-its-links (01 §1) and "
     "what-can-be-born-next (07 §2)"),
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
