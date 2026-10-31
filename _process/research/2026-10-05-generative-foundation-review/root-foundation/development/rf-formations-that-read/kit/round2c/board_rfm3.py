#!/usr/bin/env python3
"""RF round 2, third part, RF-M.3: the board, edited in a copy (board_rfm2.py's pattern). `head BOARD TEXT` puts RF's
head-of-queue clause, "RF at the head of the queue (TEXT); ", at the front of the queue note; `land BOARD RECEIPT N
QUEUE` brings the RF row's statements cell to RF-M.3's landing (its sentence and the next step, the rule-9 decision
as made in RR's landing, the review sentence) and its state cell (RF-M.3 landed with its study section and receipt,
and the next step), drops RF's head-of-queue clause, puts QUEUE at the head of the queue note (followed by a space
where it ends in a full stop, a semicolon otherwise), drops RF-M.3 from the coordinator's order where it is listed
and names the receipt as the latest. BOARD is the path of the board file to edit (in the landing worktree, or a copy
of main's for a commit made without a working tree).
usage: python3 -B board_rfm3.py head BOARD TEXT | land BOARD RECEIPT N QUEUE"""
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
NEXT = "an institution's rule of reading with members' acts stays a reading"
if mode == 'head':
    assert not HEAD.findall(board[queue[0]]), 'a head-of-queue clause is already there'
    clause = f'RF at the head of the queue ({text}); '
    assert HEAD.fullmatch(clause), clause
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
elif mode == 'land':
    receipt, section, queue_text = text, int(sys.argv[4]), sys.argv[5]
    assert f'§{section}' in queue_text and receipt in queue_text
    assert 'RF-M.3 landed' not in cells[0] and 'RF-M.3 landed' not in cells[2], 'already landed'
    old = ("Next: RF-M's preference case, the valuation as state, its carrier to be designed first; " + NEXT + ". ")
    new = ("RF-M.3 landed: a reading informed and revalued (`Becoming.ListingValuation`, in natural-number counts: by a "
           "reference, holding for a reading formation's answer through a map falls short by the least shortfall "
           "through the map and a residual, nothing exactly where no listed cell is decided against its strict weighted "
           "preference; a finer map never raises the first and a revaluation moves only the second, so with a shared "
           "model and agreement in net informing never lowers the worth, and, on a shared model, by the reading formation's own current valuation no revaluation gains and one deciding a listed cell against its strict weighted preference loses; "
           "on one blanketed law carrying the listing and valuation as state, from different starts a route shown and a route presented can answer alike and end in one state). Next: the tests' designs (plan §10); a noisy answer and "
           "continuous beliefs stay periphery debts; " + NEXT + ". ")
    assert cells[0].count(old) == 1, 'next step in the statements cell'
    cells[0] = cells[0].replace(old, new)
    stages = Path('experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/'
                  'ReadStages.lean')
    if 'import Becoming.RevisionRoutes' in stages.read_text(encoding='utf-8'):
        rule9 = "with a revision at three routes, to be made in RR's landing. "
        if cells[0].count(rule9) == 1:
            cells[0] = cells[0].replace(rule9, "with a revision at three routes, made in RR's landing. ")
    review = ("RF-M.2's design a cross-model review before its Lean and its Lean one through three lenses, and the texts "
              "a cold read; what each finding became is in plan §13.")
    assert cells[0].count(review) == 1, 'review sentence'
    cells[0] = cells[0].replace(review, (
        "RF-M.2's and RF-M.3's designs a cross-model review before their Lean and their Lean one through three lenses, "
        "RF-M.3's with a re-check and a check of the delta, and the texts a cold read; what each finding became is in "
        "plan §13."))
    old_state = ("; next RF-M.3, a principal's valuation as state, its carrier designed first; " + NEXT + ";")
    assert cells[2].count(old_state) == 1, 'next step in the state cell'
    cells[2] = cells[2].replace(old_state, (
        f"; RF-M.3 landed (study §{section}, core receipt `{receipt}`): a reading informed and revalued; next the tests' "
        f"designs (plan §10); {NEXT};"))
    board[rows[0]] = ' | '.join(cells)
    assert len(HEAD.findall(board[queue[0]])) == 1, 'head-of-queue clause'
    board[queue[0]] = HEAD.sub('', board[queue[0]], count=1)
    # a clause ending in its own sentence ("… ask the coordinator for a slot.") is followed by a space, as the
    # landings since UE25's are; one ending without a full stop, by a semicolon
    sep = ' ' if queue_text.endswith('.') else '; '
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + queue_text + sep, 1)
    order = re.search(r"Then, in the coordinator's order: ([^;]*);", board[queue[0]])
    if order:  # split at the commas outside parentheses: an item may read "RF-M.3 (whole, ready)"
        listed, items, depth, start = order.group(1), [], 0, 0
        for i, ch in enumerate(listed):
            depth += (ch == '(') - (ch == ')')
            if depth == 0 and listed.startswith(', ', i):
                items.append(listed[start:i])
                start = i + 2
        items.append(listed[start:])
        kept = [item for item in items if not item.startswith(('RF-M.3', 'RF '))]
        assert len(items) - len(kept) <= 1, items
        board[queue[0]] = board[queue[0]].replace(order.group(0), (
            "Then, in the coordinator's order: " + ', '.join(kept) + ';') if kept else '', 1)
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(\d{1,2} \w+ 20\d\d\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(
        m.group(0), f"the latest core receipt is RF's `{receipt}` ({TODAY.day} {TODAY:%B} {TODAY.year})")
else:
    raise SystemExit(__doc__)
board_path.write_text('\n'.join(board), encoding='utf-8')
print('board:', mode, 'written to', board_path)
