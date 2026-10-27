#!/usr/bin/env python3
"""OC4, the PF line's places on its owner's answer: the board. `land SECTION` amends OC4's row in the history file (its
PF places, proposed and left with the line's owner, now landed on its yes), adds the follow-up to the queue note, and
brings the way now's paraphrase of the two questions to their new wording ((g), (h)).
usage (from the checkout root): python3 -B board_oc4b.py land SECTION"""
import sys
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
if sys.argv[1:2] != ['land'] or len(sys.argv) != 3:
    raise SystemExit(__doc__)
section = int(sys.argv[2])

text = HISTORY.read_text(encoding='utf-8')
history = text.split('\n')
assert len(history) > 600, 'the history file looks cut; restore it first'
rows = [i for i, line in enumerate(history) if line.startswith("| **OC4: a second check of the crux's texts**")]
assert len(rows) == 1, rows
old = "the PF line's places (a)–(l) proposed to its owner and left with it"
assert history[rows[0]].count(old) == 1
history[rows[0]] = history[rows[0]].replace(
    old, "the PF line's places (a)–(l) proposed to its owner and landed on its yes in a follow-up (study "
         f"§{section}; the root bullet waits with OC3's (g), as it chose)")
HISTORY.write_text('\n'.join(history), encoding='utf-8')
assert HISTORY.read_text(encoding='utf-8').count('\n') == text.count('\n')

board = BOARD.read_text(encoding='utf-8').split('\n')
queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
assert len(queue) == 1
board[queue[0]] = board[queue[0]].replace(
    '- **Queue:** ',
    "- **Queue:** OC4's PF places landed ((a)–(l) on the PF line owner's yes, texts only, no checker run; study "
    f'§{section}, OC4\'s row in the history file amended); ', 1)
crux = [i for i, line in enumerate(board) if line.startswith('  2. **The crux.** ')]
assert len(crux) == 1, crux
line = board[crux[0]]
for old, new in (("a line that ends or the regularity one's acts keep going,",
                  "a line that ends while it still conditions something or a regularity of one's own,"),
                 ("and whether one's effects are one's own for scope",
                  "and whether all of one's effects are one's own for scope")):
    assert line.count(old) == 1, old
    line = line.replace(old, new)
board[crux[0]] = line
BOARD.write_text('\n'.join(board), encoding='utf-8')
print('board land')
