#!/usr/bin/env python3
"""IV3j: the board row. `land RECEIPT SECTION THEOREMS DECLS` states the law as landed (the stores' rises included),
moves the row, its state set to landed, to the history file after the last landed row, and adds the landing to the
queue note.
usage (from the checkout root): python3 -B board_j.py land RECEIPT SECTION THEOREMS DECLS"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board)
        if line.startswith('| **IV3j: need across two tiers, the upper dividing its giving among the stores**')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)
LEAD = ('| **IV3j: need across two tiers, the upper dividing its giving among the stores** (continues IV3i, landed '
        '`b0e2f62f8`; [Ren, 23 October 2026](../sources/15-codex-theory-conversations/2026-10-23-one-system.md)). ')
assert cells[0].startswith(LEAD), cells[0][:120]

if sys.argv[1] == 'land':
    receipt, section, theorems, decls = sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5]
    cells[0] = LEAD + (
        'In `Becoming.Weightings`: the lower members give the family what they take from their own stores, which upper '
        'members with supplied capacities give, each dividing its giving among the stores; the consumer needs a '
        'formation\'s giving into the hierarchy exactly where, at some step, the other upper members cannot give what the '
        'stores rise, or the falls of the other active lower stores and, while another lower member is active to route '
        'it, what the other upper members can give beyond the rises fall short of the demand '
        '(`Flow.needs_iff_through_short`). Witness `Routing`: a lone upper member and a lone lower member holding nothing '
        'needed, neither of two lower members, neither of two upper members until a lower store rises, and a lone upper '
        'member needed to give a rising store though the lower stores could feed the user. Texts in the home section '
        '(07-SIGNIFICANCE §4.3).')
    cells[2] = (f'landed 2026-10-24, core receipt `{receipt}`; Becoming.Weightings {theorems} theorems in {decls} '
                f'declarations, empty axiom reports; record self-concern-through-dependence extended and the records '
                f'drifting by these edits re-pointed; study §{section}; D64 item 13')
    row = ' | '.join(cells)
    del board[rows[0]]
    queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
    assert len(queue) == 1
    board[queue[0]] = board[queue[0]].replace(
        '- **Queue:** ',
        '- **Queue:** IV3j landed (need across two tiers: a formation\'s giving into the hierarchy is needed exactly '
        'where the other upper members cannot give what the stores rise or the others cannot give the demand through '
        'the hierarchy, a lower member holding nothing needed where it is the only route; '
        f'`Becoming.Weightings`, core receipt `{receipt}`, study §{section}, record self-concern-through-dependence '
        'extended, row in the history file); ', 1)
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(m.group(0),
                                                f"the latest core receipt is IV3j's `{receipt}` (24 October 2026)")
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
