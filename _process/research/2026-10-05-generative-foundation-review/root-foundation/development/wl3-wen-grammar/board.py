#!/usr/bin/env python3
"""WL3: the board row. `state TEXT` sets the row's state; `land RECEIPT SECTION THEOREMS DECLS` moves the row, its state
set to landed, to the history file after the last landed row, and adds the landing to the queue note. Adapted from
IV3's board.py.
usage (from the checkout root): python3 -B board.py state TEXT | python3 -B board.py land RECEIPT SECTION THEOREMS DECLS"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith('| **WL3: the 文 line joined to the one-unfolding root.**')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)

if sys.argv[1] == 'state':
    cells[2] = sys.argv[2]
    board[rows[0]] = ' | '.join(cells)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
elif sys.argv[1] == 'land':
    receipt, section, theorems, decls = sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5]
    cells[2] = (f'landed 2026-10-23, core receipt `{receipt}`; Becoming.GrammarCourse {theorems} theorems in {decls} '
                f'declarations, empty axiom reports; record wen-in-the-grammar; study §{section}; mapping '
                f'`development/wl3-wen-grammar/MAPPING.md`. For OU\'s owner (no Grammar definition changed): '
                f'`core_within_core_iff` and `contains_core_iff` hold for every carrier and could move into '
                f'`Becoming.Grammar`; `Law.alike_iff_core` proves, for a determined law read through a map, the '
                f'bisimulation correspondence that the docstring of `«闭合当且仅当有常»` leaves unproved')
    row = ' | '.join(cells)
    del board[rows[0]]
    queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
    assert len(queue) == 1
    board[queue[0]] = board[queue[0]].replace(
        '- **Queue:** ',
        '- **Queue:** WL3 landed (the 文 line joined to the one-unfolding root: 文同 is the core of the class of a '
        'map\'s values under a law\'s step and likeness by bisimulation is that core, the coarsest value-keeping class '
        'is the core, the states of a 文 are its core along the steps, the bounded laws, two 文 as one net and '
        f'learnability through the core; `Becoming.GrammarCourse`, core receipt `{receipt}`, study §{section}, record '
        'wen-in-the-grammar, row in the history file); ', 1)
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(m.group(0),
                                                f"the latest core receipt is WL3's `{receipt}` (23 October 2026)")
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
print('board', sys.argv[1])
