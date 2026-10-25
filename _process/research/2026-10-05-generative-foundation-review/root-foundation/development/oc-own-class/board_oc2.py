#!/usr/bin/env python3
"""OC2: the board row. `progress` records the review's state; `head` marks the row at the head of the landing
queue; `land RECEIPT SECTION THEOREMS DECLS PF` moves the row, its state set to landed, into the history file after
the last landed row (inserting it, the rest of the file byte for byte), and adds the landing to the queue note and
the latest receipt. PF is `yes` where PF's and PF2's wording was fixed in the same landing, else `no`.
usage (from the checkout root): python3 -B board_oc2.py progress | head | land RECEIPT SECTION THEOREMS DECLS PF"""
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith('| **OC2: the independent review of OC1 and its fixes**')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)
FOUND = ('the reviewer\'s report in (4 errors, 9 imprecisions, 4 clarity points; no proof wrong), each finding '
         'verified against the Lean and holding')

if sys.argv[1] == 'progress':
    cells[2] = (f'claimed 2026-10-25; {FOUND}; fixes drafted: `Becoming.GrammarPath` rebuilt in scratch '
                '(`build_tree_oc2.py`: 86 theorems in 132 declarations, empty axiom reports), the texts next. The PF '
                'line\'s owner is asked whether OC2 may also fix PF\'s and PF2\'s "goes on" for "conditions something" '
                '(the glossary reads it as 延)')
elif sys.argv[1] == 'head':
    cells[2] = (f'claimed 2026-10-25; {FOUND}; fixes verified in scratch (`Becoming.GrammarPath` 86 theorems in 132 '
                'declarations, empty axiom reports); **at the head of the queue (checker running)**. Statements of '
                'earlier declarations unchanged; «闭则外分无关», `Inconstant.not_all_follow` and '
                '`CleanStep.not_constant_to_end` now go through the new laws (rule 9)')
elif sys.argv[1] == 'land':
    receipt, section, theorems, decls, pf = sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5], sys.argv[6]
    assert pf in ('yes', 'no')
    cells[2] = (f'landed {datetime.now(timezone.utc).date().isoformat()}, core receipt `{receipt}`; {FOUND}, all fixed: Becoming.GrammarPath {theorems} '
                f'theorems in {decls} declarations, empty axiom reports, earlier statements unchanged; the record '
                'constancy-read-at-a-members-class and what-leaves-a-class-follows-its-line\'s next step corrected; '
                f'07 §4.6, P-20, the root bullet, the checker scope and the README rows; study §{section} '
                '(§408 kept, its corrections there)' +
                ('; PF\'s and PF2\'s "goes on" fixed on the PF line owner\'s yes. Known uses kept: PF\'s two philosophy '
                 'studies (cited by sha256 by PF\'s and PF2\'s records, frozen), PF2\'s record statement and third law '
                 '(not on the list answered), and "goes on past" an end in the module doc, §4.6 step 2, D64\'s reading, '
                 'need-and-feeding-read-with-time, P-15 and P-20 (the sense of «过亡而续»; for a pass of its own, '
                 f'study §{section})' if pf == 'yes' else
                 '; PF\'s and PF2\'s "goes on" for "conditions something" left with the PF line\'s owner (the list is '
                 f'in study §{section})'))
    row = ' | '.join(cells)
    del board[rows[0]]
    queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
    assert len(queue) == 1
    board[queue[0]] = board[queue[0]].replace(
        '- **Queue:** ',
        '- **Queue:** OC2 landed (the independent review of OC1, every finding fixed: how what lies outside is '
        'divided bears only through what is alike to an effect that leaves the class, a sufficient condition under '
        'the split, the condition at the member\'s class asking more than that a line end only where the net does, '
        f'`Inconstant` and `CleanStep` failing it at the member\'s class; `Becoming.GrammarPath`, core receipt '
        f'`{receipt}`, study §{section}, row in the history file); ', 1)
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;.]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(m.group(0),
                                                f"the latest core receipt is OC2's `{receipt}` (25 October 2026)")
    text = HISTORY.read_text(encoding='utf-8')
    history = text.split('\n')
    assert len(history) > 600, 'the history file looks cut; restore it first'
    lapsed = history.index('## Lapsed claims (18 October 2026)')
    end = lapsed - 1
    while not history[end].startswith('| '):
        end -= 1
    history.insert(end + 1, row)
    HISTORY.write_text('\n'.join(history), encoding='utf-8')
    assert HISTORY.read_text(encoding='utf-8').count('\n') == text.count('\n') + 1
else:
    raise SystemExit(__doc__)
if sys.argv[1] != 'land':
    board[rows[0]] = ' | '.join(cells)
BOARD.write_text('\n'.join(board), encoding='utf-8')
print('board', sys.argv[1])
