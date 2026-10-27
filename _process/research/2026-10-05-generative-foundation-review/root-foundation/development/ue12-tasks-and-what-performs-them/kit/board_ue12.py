#!/usr/bin/env python3
"""UE12 (UE11's board_ue11.py, with a `head` mode): a board row. `state ID TEXT` sets the row's state; `head ID TEXT`
puts UE12's head-of-queue clause, "UE12 at the head of the queue (TEXT); ", at the front of the queue note; `land ID
RECEIPT SECTION QUEUE_TEXT STATE_TEXT` moves the row, its state set to STATE_TEXT and its statements brought to what
the Lean shows, to the history file after the last landed row, drops UE12's head-of-queue clause, puts QUEUE_TEXT at
the head of the queue note, names the receipt as the latest and adds UE12 to the UE row's landed items.
usage (from the checkout root): python3 -B board_ue12.py state UE12 TEXT | python3 -B board_ue12.py head UE12 TEXT |
       python3 -B board_ue12.py land UE12 RECEIPT N QUEUE STATE"""
import datetime
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = re.compile(r'UE12 at the head of the queue \([^()]*\); ')
TODAY = datetime.date.today()
UE_OLD = "and UE10, UE0's evolution rows in 08 §8 and UE11 (27 October)"
UE_NEW = "and UE10, UE0's evolution rows in 08 §8, UE11 and UE12 (27 October)"
# the row's statements, brought to what the Lean shows (the review's F1, F5, F6, F8, F9 and the re-check's R1), in the
# row moved to history
STATEMENTS = [
    ('Read in the account: a task is a relation on a substrate; what performs it is a class of a performing part, '
     'presented with every input and in the class again after delivering; its possible is the possible relative to a '
     'held part (UE10, UE11), and the division into performer and substrate is stated with each claim.',
     "Read in the account: a task is a relation on a substrate; what performs it is a region of a performing part's "
     'states, had with every input and restored at the end of each delivery, not held: holding it throughout, the '
     'possible relative to a held part (UE11), is sufficient and not needed; the division into performer and '
     'substrate is stated with each claim.'),
    ('Laws: held throughout implies restored at the end, not conversely (a catalytic cycle); one performer reused in '
     'series; two composed in series or in parallel where each delivers by moves holding what the other uses, which '
     'locality gives; a coupled witness where two possible tasks compose into one that no class of any part performs, '
     'so the composition principle is a premise about the process;',
     'Laws: held throughout implies restored at the end, not conversely (a catalytic cycle, whose task has an '
     'impossible transpose); one region delivering a regular pair in series, and two tasks in turn; two regions '
     'composed in series or in parallel where each delivers by moves holding what the other uses, sufficient and not '
     'needed, which locality gives on interleavings, possibility read in each process; composition failing within one '
     'interleaving on one substrate, and on a resetting process whose deliveries change what their tasks do not list, '
     "which constructor theory's tasks list, so the composition principle is not contradicted;"),
    ('a possible whole of impossible parts under a conserved amount, and the same task possible once the conserved '
     'total is read as the performer;',
     'a possible whole of impossible parts under a conserved amount, with the additive pattern of a conservation law, '
     'and the same task performed once an invariant of the process is read as the performer;'),
    ('the requirement that every chain of construction begin with performers it does not construct, as a theorem of a '
     'tower of performers, failing where every level changes at once;',
     'on a tower of performers with no top, every delivery, and every making of a performer from a natural '
     'configuration, had with the performers from some level up held, and no delivery so where every level changes at '
     'once;'),
    ('what can be done with the performing part at hand grows only as it changes.',
     'what can be done with the performing part held grows only as it changes; and a delivery adds nothing to the '
     'whole possible, while widening follows deliveries in neither direction, so what possible tasks carry is the '
     'inclusion of the whole possible, not widening.'),
    ('A leaf at L1 importing Becoming.HeldPossible (namespace `Tasks`, since the prelude has `Task`); pure core',
     'A leaf at L1 importing Becoming.HeldPossible, a reading of constructor theory no other module uses yet '
     '(namespace `Tasks`, since the prelude has `Task`); pure core')]
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
