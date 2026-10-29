#!/usr/bin/env python3
"""RF round 2: the board, edited in a copy (round 1's board_rf.py, for round 2). `state BOARD TEXT` sets the RF row's
state cell to TEXT; `head BOARD TEXT` puts RF's head-of-queue clause, "RF at the head of the queue (TEXT); ", at the
front of the queue note; `land BOARD RECEIPT N QUEUE STATE` sets the state cell to STATE, brings the statements cell's
round 2 sentence to the first landing, drops RF's head-of-queue clause, puts QUEUE at the head of the queue note and
names the receipt as the latest. BOARD is the path of the board file to edit (in the landing worktree, or a copy of
main's for a commit made without a working tree).
usage: python3 -B board_rf2.py state BOARD TEXT | head BOARD TEXT | land BOARD RECEIPT N QUEUE STATE"""
import datetime
import re
import sys
from pathlib import Path

HEAD = re.compile(r'RF at the head of the queue \([^()]*\); ')
mode, board_path, text = sys.argv[1], Path(sys.argv[2]), sys.argv[3]
TODAY = datetime.date.today()
board = board_path.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith('| **RF: ')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)
queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
assert len(queue) == 1
if mode == 'state':
    assert cells[2].startswith(' round 1 landed') or cells[2].startswith('round 1 landed'), cells[2][:60]
    cells[2] = text
    board[rows[0]] = ' | '.join(cells)
elif mode == 'head':
    assert not HEAD.findall(board[queue[0]]), 'a head-of-queue clause is already there'
    clause = f'RF at the head of the queue ({text}); '
    assert HEAD.fullmatch(clause), clause
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
elif mode == 'land':
    receipt, section, queue_text, state_text = text, int(sys.argv[4]), sys.argv[5], sys.argv[6]
    assert f'§{section}' in queue_text and receipt in queue_text
    cells[2] = state_text
    old = ("Round 2, designed: RF3 a formation's reading kept by its own update, joined to "
           "`GuardHorizon.uniform_policy_iff_fiber_feasible`; RF6.1 revision that opens an executable correction; RF6.3 "
           "reflexive prediction; RF-M one finite mechanism of prediction, selection, revision and intervention; RF7 "
           "disclosure or concealment in two stages. ")
    new = ("Round 2, first landing: RF3 a formation's reading kept by its own update and RF-M's mechanism with its first "
           "cases (`Becoming.ReadingLoop`: with a reading its update keeps, a policy keeps a task and goes on exactly "
           "where each state's act is good and enabled for it; the worlds possible after a history; two worlds and one "
           "formation; where only answers breaking a task tell worlds apart, keeping it is never telling them apart; a "
           "formation keeping candidate laws; acts alike from a model or an order); RF6.3 a prediction read by what it "
           "predicts (`Becoming.ReflexivePrediction`: right where the response leaves it, the least right one reached on "
           "a chain). Designed: RF6.1 revision that opens an executable correction (built in the kit, held for a "
           "revision as a reachable step); RF-M's helper, preference and institution cases; RF7 disclosure or "
           "concealment in two stages. ")
    assert cells[0].count(old) == 1, 'round 2 sentence'
    cells[0] = cells[0].replace(old, new)
    cells[0] = cells[0].replace("The plan and the Lean each had an independent cross-model review and the texts a cold "
                                "read by three readers, every finding taken (plan §13).",
                                "The plan and the Lean of each round had an independent cross-model review, with a "
                                "re-check in round 2, and the texts a cold read, every finding taken (plan §13).")
    board[rows[0]] = ' | '.join(cells)
    assert len(HEAD.findall(board[queue[0]])) == 1, 'head-of-queue clause'
    board[queue[0]] = HEAD.sub('', board[queue[0]], count=1)
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + queue_text + '; ', 1)
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(\d{1,2} October 2026\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(
        m.group(0), f"the latest core receipt is RF's `{receipt}` ({TODAY.day} {TODAY:%B} {TODAY.year})")
else:
    raise SystemExit(__doc__)
board_path.write_text('\n'.join(board), encoding='utf-8')
