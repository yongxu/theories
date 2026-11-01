#!/usr/bin/env python3
"""Rehearsal only: where another session's "(landing now" clause holds the head of the Queue line at the merged main,
drop that one clause from the working copy so the board steps can be rehearsed as on a free head. The clause is
written to the file given, and nothing is committed; the real landing waits for a free head (head_sj.sh).
usage (from the checkout root): python3 -B free_head_rehearsal.py OUT"""
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
lines = BOARD.read_text(encoding='utf-8').split('\n')
i = [k for k, l in enumerate(lines) if l.startswith('- **Queue:** ')]
assert len(i) == 1, i
i = i[0]
prefix, line = '- **Queue:** ', lines[i][len('- **Queue:** '):]
start = line.find('(landing now')
if start < 0:
    Path(sys.argv[1]).write_text('', encoding='utf-8')
    print('free-head: the head is free')
    sys.exit(0)
depth, k = 0, start
while True:
    c = line[k]
    depth += c == '('
    depth -= c == ')'
    k += 1
    if depth == 0:
        break
end = k + (2 if line[k:k + 2] == '; ' else 1 if line[k:k + 1] == ' ' else 0)
held = line[:end]
assert '(landing now' in held and held.count('(') == held.count(')'), held[:200]
lines[i] = prefix + line[end:]
BOARD.write_text('\n'.join(lines), encoding='utf-8')
Path(sys.argv[1]).write_text(held, encoding='utf-8')
print('free-head: dropped in the working copy only:', held[:160], '…')
