#!/usr/bin/env python3
"""UE10 (UE9's board_ue9.py; the head-of-queue clause is found by its form, since the worktree's commit is named when
the head is claimed): a board row. `state ID TEXT` sets the row's state; `land ID RECEIPT SECTION QUEUE_TEXT
STATE_TEXT` moves the row, its state set to STATE_TEXT and its four statements brought to what the Lean shows, to the
history file after the last landed row, drops UE10's head-of-queue clause, puts QUEUE_TEXT at the head of the queue
note, names the receipt as the latest, brings the way now's UE item to the landing and adds UE10 to the UE row's
landed items.
usage (from the checkout root): python3 -B board_ue10.py state UE10 TEXT | python3 -B board_ue10.py land UE10 RECEIPT N QUEUE STATE"""
import datetime
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
HEAD = re.compile(r'UE10 at the head of the queue \([^()]*\); ')
NOW_OLD = "07's other two candidates, what a course keeps reachable (UE10) and what carries its openings, remain."
NOW_NEW = ('UE10 (what a course keeps reachable, study §{section}) landed: covering, the comparison of what courses keep '
           'reachable at the same offsets, implies inclusion of what each configuration admits now, so widening what can '
           'be reached never ranks a configuration above one that starts a course and admits now what it does not, and on '
           'a determined process it is the strict part of range inclusion of the two courses; read with a lag, built as UE9\'s lagged order is on '
           'families of courses, it decides one witness\'s pair, not every such pair, and C leaves that pair unranked, so '
           'the lag\'s verdict is a premise beyond C; on a branching witness realized and reachable widening rank a pair '
           'oppositely, so no strict partial order there contains both. 07\'s last candidate, what carries a course\'s '
           'openings, remains.')
UE_OLD = 'UE7 (`d299d86af`) and UE9 (`8548c5896`, 26 October)'
TODAY = datetime.date.today()
UE_NEW = f'UE7 (`d299d86af`) and UE9 (`8548c5896`, 26 October), and UE10 ({TODAY.day} {TODAY:%B})'
# the row's four statements, brought to what the Lean shows, in the row moved to history
STATEMENTS = [
    ('(1) covering, every course from one configuration included step for step by a course from the other, is a '
     'preorder, and widening what can be reached a strict partial order coinciding with widening of the courses on '
     'determined processes;',
     '(1) covering, every course from one configuration included offset for offset by a course from the other, is a '
     'preorder implying inclusion now where the covered configuration starts a course, and widening what can be '
     'reached is irreflexive and transitive, so it never ranks a configuration above one that starts a course and '
     'admits now what it does not, and on a determined process it is the strict part of range inclusion of the two '
     'courses; read with a lag it decides one witness\'s pair, not every such pair, a verdict C leaves open;'),
    ('(2) the possible only narrows: within one process every range reachable from a later configuration of a course '
     'is a tail of one reachable from an earlier one, so no course keeps widening what can be reached, and the possible '
     'within a horizon grows only through what becomes actual (the adjacent possible restated; growth of the whole '
     'possible needs a law that changes, the grammar\'s deepest gap);',
     '(2) nothing is added to the whole possible along a course, and where reachable configurations start courses a '
     'step whose later configuration covers the earlier leaves it unchanged; same-offset widening of what can be '
     'reached can rise along a course while the whole possible stays the same, a rise on a determined process being '
     'the course one step on strictly including the course; the possible within a horizon keeps widening only '
     'where no list holds the whole possible (the adjacent possible restated for a prestated space; growth of the '
     'whole possible needs a process that changes);'),
    ('(3) a configuration with an unrealized wider course covers one whose realized course widens its own, so C read '
     'on reachable courses and C on realized courses rank one pair oppositely, and holding both is a lexical premise;',
     '(3) on a branching witness a configuration with an unrealized wider course widens what can be reached over one '
     'whose realized course widens its own, so there no strict partial order contains both, nor satisfies C both on '
     'realized courses and on reachable ranges, and holding both needs a rule of precedence [AI reading] (the lexical '
     'order is one);'),
    ('(4) marginals do not certify joint ranges.',
     '(4) the bundles realizable within every bound do not certify what can be reached together.')]
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
                                                f"the latest core receipt is {item}'s `{receipt}` ({TODAY.day} {TODAY:%B} {TODAY.year})")
    ue = [i for i, line in enumerate(board) if line.startswith('| **UE: a unified explanation of reality**')]
    assert len(ue) == 1, ue
    ue_cells = board[ue[0]].split(' | ')
    assert len(ue_cells) == 5 and ue_cells[2].count(UE_OLD) == 1, 'the UE row'
    ue_cells[2] = re.sub(r'; UE10 [^;]*$', '', ue_cells[2].replace(UE_OLD, UE_NEW))
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
