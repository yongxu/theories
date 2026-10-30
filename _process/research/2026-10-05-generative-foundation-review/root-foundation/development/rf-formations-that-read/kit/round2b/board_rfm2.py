#!/usr/bin/env python3
"""RF round 2, second part, RF-M.2: the board, edited in a copy (board_rf2.py's pattern). `head BOARD TEXT` puts RF's
head-of-queue clause, "RF at the head of the queue (TEXT); ", at the front of the queue note; `land BOARD RECEIPT N
QUEUE STATE` sets the RF row's state cell to STATE, brings the statements cell to RF-M.2's landing (its sentence, the
designed cases, the review sentence), drops RF's head-of-queue clause, puts QUEUE at the head of the queue note and
names the receipt as the latest. BOARD is the path of the board file to edit (in the landing worktree, or a copy of
main's for a commit made without a working tree).
usage: python3 -B board_rfm2.py head BOARD TEXT | land BOARD RECEIPT N QUEUE STATE"""
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
if mode == 'head':
    assert not HEAD.findall(board[queue[0]]), 'a head-of-queue clause is already there'
    clause = f'RF at the head of the queue ({text}); '
    assert HEAD.fullmatch(clause), clause
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
elif mode == 'land':
    receipt, section, queue_text, state_text = text, int(sys.argv[4]), sys.argv[5], sys.argv[6]
    assert f'§{section}' in queue_text and receipt in queue_text
    assert 'RF-M.2 landed' not in cells[0], 'already landed'
    cells[2] = state_text
    old = "Designed: RF-M's helper, preference and institution cases. "
    new = ("RF-M.2 landed: what holding an act for a reading is worth (`Becoming.HeldForReading`, in natural-number "
           "counts: a reading telling the candidate gains over every open act exactly where none is valued best at "
           "every candidate of positive weight; holding for a reading that stops or releases stands above both moves "
           "exactly where the model gives positive weight to both strict signs, and holding for any rule of stopping, "
           "forgoing an amount, stands at least as high as going on exactly where its shortfall and the amount are at "
           "most the excess of switching off; on the reading loop, a formation choosing so on a listing only of gain, "
           "going on from the start, never senses the stop). Designed: RF-M's preference case, the valuation as "
           "state, its carrier first; an institution's rule of reading with members' acts stays a reading. ")
    assert cells[0].count(old) == 1, 'designed sentence'
    cells[0] = cells[0].replace(old, new)
    review = ("The plan and the Lean of each round had an independent cross-model review, with a re-check in round 2, "
              "RF7's Lean also a review through four lenses with each point verified, and the texts a cold read, every "
              "confirmed finding taken (plan §13).")
    assert cells[0].count(review) == 1, 'review sentence'
    cells[0] = cells[0].replace(review, (
        "The plan and the Lean of each round had an independent cross-model review, with a re-check in round 2, RF7's "
        "Lean also a review through four lenses with each point verified, RF-M.2's design a cross-model review before "
        "its Lean and its Lean one through three lenses, and the texts a cold read; what each finding became is in "
        "plan §13."))
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
