#!/usr/bin/env python3
"""OC1: the board row. `head` marks the row at the head of the landing queue. `land RECEIPT SECTION THEOREMS DECLS` moves
the row, its state set to landed, into the history file after the last landed row (inserting it, the rest of the file
byte for byte), and adds the landing to the queue note and the latest receipt.
usage (from the checkout root): python3 -B board_oc1.py head | land RECEIPT SECTION THEOREMS DECLS"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board)
        if line.startswith("| **OC1: constancy read at a member's own class, and the division of what it leaves out**")]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)

if sys.argv[1] == 'head':
    cells[2] = ("claimed 2026-10-25; Lean verified in scratch (`development/oc-own-class/tree`: GrammarPath 77 theorems in "
                "118 declarations, empty axiom reports), built on PF2's landed module by `build_tree.py`; **at the head of "
                "the queue (checker running)**. The change to PF's module is a generalization below it (rule 9): every "
                "statement stays, only proofs change. Also restored on 25 October: the board history file, which PF2's "
                "landing (`2e591bcce`) had cut to its own row (`4f5312c69`)")
    board[rows[0]] = ' | '.join(cells)
    BOARD.write_text('\n'.join(board), encoding='utf-8')
elif sys.argv[1] == 'land':
    receipt, section, theorems, decls = sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5]
    cells[2] = (f'landed 2026-10-25, core receipt `{receipt}`; Becoming.GrammarPath {theorems} theorems in {decls} '
                f'declarations, empty axiom reports, PF\'s and PF2\'s statements unchanged; new record '
                f'constancy-read-at-a-members-class; the next step of what-leaves-a-class-follows-its-line answered; the '
                f'records drifting by these edits re-pointed; study §{section}')
    row = ' | '.join(cells)
    del board[rows[0]]
    queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
    assert len(queue) == 1
    board[queue[0]] = board[queue[0]].replace(
        '- **Queue:** ',
        "- **Queue:** OC1 landed (which class P2 reads: constancy up to the net's end read at a member's class carries "
        "the path's laws, PF's and PF2's forms its corollaries; where the class holds the member's effects how what lies "
        "outside is divided is idle, and otherwise the split of the member's class from the rest asks least, exactly "
        "that what stays and what leaves follow every alike step that goes on; "
        f'`Becoming.GrammarPath`, core receipt `{receipt}`, study §{section}, new record '
        'constancy-read-at-a-members-class, row in the history file); ', 1)
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;.]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    board[latest[0]] = board[latest[0]].replace(m.group(0),
                                                f"the latest core receipt is OC1's `{receipt}` (25 October 2026)")
    BOARD.write_text('\n'.join(board), encoding='utf-8')
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
print('board', sys.argv[1])
