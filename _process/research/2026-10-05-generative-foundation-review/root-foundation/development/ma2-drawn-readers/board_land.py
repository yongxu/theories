#!/usr/bin/env python3
"""MA2's landing on the board: the row moves to the history file, the queue paragraph drops MA2's place in line, the
Now section's queue bullet opens with the landing, and the AJ row records it with AJ2 and AJ4's holder. Re-run
after taking main's board in a merge.

usage (from the checkout root): python3 -B board_land.py RECEIPT N THEOREMS DECLS"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT, N, THEOREMS, DECLS = sys.argv[1:5]
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
board = BOARD.read_text(encoding='utf-8')
history = HISTORY.read_text(encoding='utf-8')

# 1. The row moves to the history file.
lines = board.split('\n')
rows = [i for i, l in enumerate(lines) if l.startswith('| **MA2: readers drawn from the selected**')]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[1] = ('Claude Code desktop session (readers drawn from the selected), 22 October 2026; landed by the Claude Code '
            'desktop session coordinating AJ (Unification and coherence progress, fork 2), 25 October 2026, on Ren\'s yes')
cells[2] = (f'landed 2026-10-25, core receipt `{RECEIPT}` on the tree merged with main (first passed on branch `ma2` at '
            f'`20261022T110422.961776Z`); Becoming.ClosedCapture {THEOREMS} theorems in {DECLS} declarations, 42 of them '
            f'new, empty axiom reports; new record readers-drawn-from-the-selected, home 02 §9 '
            f'(`r-readers-drawn-from-the-selected`), T7 and the overview\'s capture paragraph; closed-capture\'s next step; '
            f'the records drifting by these edits re-pointed; study §{N}; D67 (D64 when proved)')
cells[3] = 'worktree `.claude/worktrees/ma2` (branch `ma2`); kit `development/ma2-drawn-readers/`'
moved = ' | '.join(cells)
if moved.split(' | ')[0] not in history:
    history = history.rstrip('\n') + '\n' + moved + '\n'
board = '\n'.join(lines)

# 2. The queue paragraph drops MA2's place in line.
head_now = re.compile(r"\): MA2, readers drawn from the selected \(landing taken over on Ren's yes\), is at the head of the "
                      r"queue: .*? Hold commits")
board, k = head_now.subn(f'; MA2, readers drawn from the selected, landed 25 October 2026, core receipt `{RECEIPT}`, its row '
                         'moved likewise): PF is at the head of the queue. Hold commits', board)
assert k == 1, k

# 3. The Now section's queue bullet opens with the landing.
landed = (f'MA2 landed (readers drawn from the selected: within a pool of readers drawn from those it selects, counted '
          f'as it counts them, the rule is read from the share exactly where each kind reads at least as favourably '
          f'for its own kind, and where only the disfavoured read the loss the counts when they read it decide for '
          f'good; proved 22 October, landed on Ren\'s yes; `Becoming.ClosedCapture`, core receipt `{RECEIPT}`, study '
          f'§{N}, new record readers-drawn-from-the-selected, row in the history file); ')
head = '- **Queue:** '
assert head in board
if 'MA2 landed (readers drawn from the selected' not in board:
    board = board.replace(head, head + landed, 1)

# 4. The AJ row records the landing and AJ2 and AJ4's holder.
old_path = re.compile(r'MA2 lands \(verified on `ma2`, `e8257c8ce`; owner idle since 22 October, lapsing about 25 '
                      r'October, 20:00 Asia/Bangkok, by rule 4\)')
board, k = old_path.subn(f'MA2 landed 25 October (core receipt `{RECEIPT}`)', board)
assert k <= 1, k
old_goal = ('capacity to control it is not selected, because what control returns does not come back to the controller '
            'within the time correction takes (MA3)')
new_goal = ('capacity to shape the rule is not selected, because what shaping brings back to the shapers alone does not '
            'cover its cost, at each step and across the steps the selection runs (MA3)')
board = board.replace(old_goal, new_goal, 1)
old_state = 'claimed 2026-10-24 on `45935124a`; plan written; AJ2 to AJ4 start after MA3 lands |'
new_state = ('claimed 2026-10-24 on `45935124a`; plan written; MA2 landed 25 October; AJ4 held by the Claude Code '
             'desktop session Unification and coherence progress (fork 3) since `c4dfe54cd` (Ren, 24 October: the '
             'alignment community\'s uptake a top objective, [source](../sources/15-codex-theory-conversations/'
             '2026-10-24-alignment-community-objective.md)), and AJ2 handed to it in `1c291dd29`; AJ2 to AJ4 start '
             'after MA3 lands |')
if old_state in board:
    board = board.replace(old_state, new_state, 1)
assert 'AJ4 held by' in board, 'the AJ row was not updated'

BOARD.write_text(board, encoding='utf-8')
HISTORY.write_text(history, encoding='utf-8')
print('board: MA2 landed, row moved, queue and AJ row updated')
