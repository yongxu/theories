#!/usr/bin/env python3
"""UE9 (UE7's board_ue7.py; the head-of-queue clause is found by its form, since the worktree's commit is named when
the head is claimed): a board row. `state ID TEXT` sets the row's state; `land ID RECEIPT SECTION QUEUE_TEXT
STATE_TEXT` moves the row, its state set to STATE_TEXT and its three statements brought to what the Lean shows (the
re-check's R1), to the history file after the last landed row, drops UE9's head-of-queue clause, puts QUEUE_TEXT at the
head of the queue note, names the receipt as the latest and brings the way now's UE item to the landing.
usage (from the checkout root): python3 -B board_ue9.py state UE9 TEXT | python3 -B board_ue9.py land UE9 RECEIPT N QUEUE STATE"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = re.compile(r'UE9 at the head of the queue \([^()]*\); ')
NOW_OLD = "and none compares two courses, which UE9 takes up."
NOW_NEW = ('and none compares two courses. UE9 (comparing two courses on what they admit, study §{section}) landed: '
           'on a web of formations on two sides, ranking every course that keeps widening by name above one admitting '
           'alike and wider at first closes a cycle, which needs a static course admitting infinitely many formations '
           'and is not given by one; widening with a lag decides UE4\'s lag, as does a tail order containing eventual '
           'widening, and on the own-condition web the two rank a pair oppositely, so choosing between counting early '
           'steps and reading only tails is a premise. 07\'s other two candidates, what a course keeps reachable '
           '(UE10) and what carries its openings, remain.')
# the row's three statements, as the re-check's R1 asks, in the row moved to history
STATEMENTS = [
    ('(1) no strict partial order extending widening and invariant under renaming formations ranks a course that keeps '
     'widening above every static course merely wider now and mixed with it afterwards (four courses on the naturals, '
     'odd and even, close a cycle);',
     '(1) on a web of formations on two sides, no strict partial order containing widening ranks every course keeping '
     'widening by name above every static course wider at first and mixed with it (a growing course and a fixed one, '
     'with their mirrors under exchanging the sides, close a cycle; the fixed course admits infinitely many formations, '
     'which the cycle needs and which does not suffice);'),
    ('(2) widening joined with the strict part of inclusion with a fixed delay is a strict partial order, invariant '
     'under renaming, deciding the lag;',
     '(2) widening joined with the strict part of inclusion with some lag is a strict partial order, unchanged by every '
     'renaming constant across steps and reading names across steps, deciding the lag;'),
    ('(3) that strict part and eventual widening together close a cycle,',
     '(3) on the own-condition web, that strict part and eventual widening together close a cycle,')]
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
    now = [i for i, line in enumerate(board) if NOW_OLD in line]
    assert len(now) == 1 and board[now[0]].count(NOW_OLD) == 1, 'the way now, UE item'
    board[now[0]] = board[now[0]].replace(NOW_OLD, NOW_NEW.format(section=section), 1)
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(m.group(0),
                                                f"the latest core receipt is {item}'s `{receipt}` (26 October 2026)")
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
