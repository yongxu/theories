#!/usr/bin/env python3
"""UE11 (UE10's board_ue10.py; the head-of-queue clause is found by its form, since the worktree's commit is named when
the head is claimed): a board row. `state ID TEXT` sets the row's state; `land ID RECEIPT SECTION QUEUE_TEXT
STATE_TEXT` moves the row, its state set to STATE_TEXT and its statements brought to what the Lean shows, to the
history file after the last landed row, drops UE11's head-of-queue clause, puts QUEUE_TEXT at the head of the queue
note, names the receipt as the latest and adds UE11 to the UE row's landed items. The way now names no UE item, so it
is left as it is.
usage (from the checkout root): python3 -B board_ue11.py state UE11 TEXT | python3 -B board_ue11.py land UE11 RECEIPT N QUEUE STATE"""
import datetime
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = re.compile(r'UE11 at the head of the queue \([^()]*\); ')
TODAY = datetime.date.today()
UE_OLD = "and UE10 and UE0's evolution rows in 08 §8 (27 October)"
UE_NEW = "and UE10, UE0's evolution rows in 08 §8 and UE11 (27 October)"
# the row's statements, brought to what the Lean shows, in the row moved to history
STATEMENTS = [
    ('(1) across a move of a process nothing is added to the possible under that process, so where the possible under '
     'it grows the step is not one of its moves;',
     '(1) for any process, what is possible under it from a configuration it reaches is possible from the first, so a '
     'step from s to t, where something possible from t is not possible from s, is not one of its moves;'),
    ("(2) along a course the possible under a process keeps widening, in 07's form, only if from no step on are all "
     "steps its moves;",
     "(2) along a course the possible under a process keeps widening, in 07's form read from the first step, only if "
     "from every step some bounded stretch is not made of its moves, so only if from no step on are all steps its "
     "moves;"),
    ('(3) with a part held (the moves keeping it), the possible is included in the whole possible, grows only across a '
     'step changing the part, and keeps widening only where the part changes without end and no list holds the whole '
     'possible;',
     '(3) with a part held (the moves holding it), the possible is included in the whole possible, grows only across a '
     'step changing the part, gains nothing from the step at which the part stays for good, and keeps widening only '
     'where the part changes without end (located where holding is decided; on the root, no unending line under the '
     'part) and no list holds the whole possible, which does not suffice, and never along a course that only returns;'),
    ('(5) a tower of rules, each level changed by the next with no top level, is one process: nothing is added to its '
     'whole possible, and the possible with the levels from n up held keeps widening only where those levels change '
     'without end, so nowhere along a course whose levels from some N up stay;',
     '(5) on the root, reach over a sequence of relations growing coarser that each step meets lies on a line under '
     'one of them, so a tower of rules with no top, each rule changing only as the one above it allows, is one process '
     'each of whose possibilities is had with the rules from some height up held (not so where every rule changes at '
     'once); '
     'nothing is added to its whole possible, and the possible with the rules from height n up held keeps widening '
     'only where moves above n recur, so not along a course whose rules from some N ≤ n up stay from some step on;'),
    ('(6) witness: a climbing rule, along whose course the possible with the rule held keeps widening while every '
     'formation is possible at every step.',
     '(6) witnesses: a raised rule, and a tower copying down, along whose courses the possible held keeps widening '
     '(relative to every height, on the tower, each rule changing once) while every formation is possible at every '
     'step and every moment ceases under what is held; and the rule raised at every other step, along whose course '
     'renewal without end holds as well.')]
item = sys.argv[2]
board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith(f'| **{item}: ')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)

if sys.argv[1] == 'state':
    cells[2] = sys.argv[3]
    board[rows[0]] = ' | '.join(cells)
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
