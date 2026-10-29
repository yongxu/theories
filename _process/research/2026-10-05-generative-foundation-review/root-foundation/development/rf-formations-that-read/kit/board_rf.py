#!/usr/bin/env python3
"""RF round 1 (WRT2's board_wrt2.py): the board. `head TEXT` puts RF's head-of-queue clause, "RF at the head of the
queue (TEXT); ", at the front of the queue note; `land RECEIPT SECTION QUEUE_TEXT STATE_TEXT` sets the RF row's state to
STATE_TEXT and its statements to what the Lean shows after the review (the row stays open: round 2 is designed, not
built), drops RF's head-of-queue clause, puts QUEUE_TEXT at the head of the queue note and names the receipt as the
latest.
usage (from the checkout root): python3 -B board_rf.py head TEXT | python3 -B board_rf.py land RECEIPT N QUEUE STATE"""
import datetime
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HEAD = re.compile(r'RF at the head of the queue \([^()]*\); ')
TODAY = datetime.date.today()
STATEMENTS = [
    ("(Ren, 29 October 2026, source record `sources/15-codex-theory-conversations/2026-10-29-formations-that-read.md` "
     "landing with the plan, named without a link until then; ",
     "([Ren, 29 October 2026](../sources/15-codex-theory-conversations/2026-10-29-formations-that-read.md); "),
    ("plan `development/rf-formations-that-read/PLAN.md`, untracked until it lands). ",
     "[plan](research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md)). "),
    ("New Lean, as leaves, each reviewed before the queue: RF1 what choices show of the order they come from (on the "
     "grammar: «及», «无环», «无环则及为序»; inner alignment, inverse reinforcement learning, revealed preference); "
     "RF2 acts that differ where unread (on `Learning`'s lumping laws; deception, evaluation awareness); RF3 a "
     "formation's reading kept by its own update (on the grammar: «闭»), joined to "
     "`GuardHorizon.uniform_policy_iff_fiber_feasible` (good regulator, requisite variety); RF4 readers reading readers "
     "(cascades, copying). ",
     "Round 1, landed: RF1 what choices show of the order they come from (`Becoming.ShownOrder`, on the grammar: with "
     "no cycle shown, the positive comparisons every according strict order shares are exactly the shown reach, none "
     "forced beyond it; one search with two orders); RF2 what readings fix of the unread (`Becoming.Unread`: under a "
     "selection through the readings, a selected twin where the formation can tell; acts, states and couplings); RF4 "
     "readers reading readers (`Becoming.Cascade`: from member k on, the acts carry no more than the couplings before "
     "it). Round 2, "
     "designed: RF3 a formation's reading kept by its own update, joined to "
     "`GuardHorizon.uniform_policy_iff_fiber_feasible`; RF6.1 revision that opens an executable correction; RF6.3 "
     "reflexive prediction; RF-M one finite mechanism of prediction, selection, revision and intervention; RF7 "
     "disclosure or concealment in two stages. "),
    ("Readings, no new Lean: one failure and one exit across scales, on the existing capture laws; concealment as "
     "shaping (`RuleShaping.favours_iff`). ",
     "Readings, no new Lean: a shared obstruction pattern across scales, each row's standing stated; concealment as "
     "shaping an analogy until RF7. "),
    ("First: the plan's independent review (cross-model).",
     "The plan and the Lean each had an independent cross-model review and the texts a cold read by three readers, "
     "every finding taken (plan §13)."),
]
board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith('| **RF: ')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)
queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
assert len(queue) == 1

if sys.argv[1] == 'head':
    assert not HEAD.findall(board[queue[0]]), 'a head-of-queue clause is already there'
    clause = f'RF at the head of the queue ({sys.argv[2]}); '
    assert HEAD.fullmatch(clause), clause
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
elif sys.argv[1] == 'land':
    receipt, section, queue_text, state_text = sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5]
    assert f'§{section}' in queue_text and receipt in queue_text
    cells[2] = state_text
    for old, new in STATEMENTS:
        assert cells[0].count(old) == 1, old[:60]
        cells[0] = cells[0].replace(old, new)
    board[rows[0]] = ' | '.join(cells)
    assert len(HEAD.findall(board[queue[0]])) == 1, 'head-of-queue clause'
    board[queue[0]] = HEAD.sub('', board[queue[0]], count=1)
    board[queue[0]] = board[queue[0]].replace('- **Queue:** ', '- **Queue:** ' + queue_text + '; ', 1)
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(\d{1,2} October 2026\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(m.group(0),
                                                f"the latest core receipt is RF's `{receipt}` ({TODAY.day} {TODAY:%B} {TODAY.year})")
    BOARD.write_text('\n'.join(board), encoding='utf-8')
else:
    raise SystemExit(__doc__)
print('board', sys.argv[1], 'RF')
