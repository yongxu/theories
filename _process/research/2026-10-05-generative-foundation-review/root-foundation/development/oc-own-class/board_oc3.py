#!/usr/bin/env python3
"""OC3: the board row. `land SECTION PF RECEIPT` moves the row, its state set to landed, into the history file after
the last landed row (inserting it, the rest of the file byte for byte) and adds the landing to the queue note. PF is
`yes` where the PF line's places (e)–(f) changed in the same landing, else `no`; RECEIPT is the core receipt where
(g), GrammarPath's module doc, changed, else `-`, and then the latest receipt is updated too.
usage (from the checkout root): python3 -B board_oc3.py land SECTION PF RECEIPT"""
import re
import sys
from datetime import date
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith('| **OC3: "goes on past" an end read as "continues past"**')]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)
if sys.argv[1:2] != ['land']:
    raise SystemExit(__doc__)
section, pf, receipt = int(sys.argv[2]), sys.argv[3], sys.argv[4]
assert pf in ('yes', 'no')
places = ['(a)–(d) in the IV3 line']
if pf == 'yes':
    places.append('(e)–(f) on the PF line owner\'s answer')
if receipt != '-':
    places.append(f'(g) with core receipt `{receipt}`')
cells[2] = (f'landed {date.today().isoformat()}; "continues past" in ' + ', '.join(places)
            + '; no statement changed; the record need-and-feeding-read-with-time\'s history notes it; study '
            f'§{section}' + ('; (e)–(f) left with the PF line\'s owner' if pf == 'no' else '')
            + ('; **(g) deferred to the next landing that rebuilds `Becoming.GrammarPath`**, which applies it (the PF '
               'line owner\'s choice: a comment alone is not worth a checker run)' if receipt == '-' else ''))
row = ' | '.join(cells)
del board[rows[0]]
queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
assert len(queue) == 1
board[queue[0]] = board[queue[0]].replace(
    '- **Queue:** ',
    '- **Queue:** OC3 landed ("goes on past" an end read as "continues past", the sense of «过亡而续», wording only; '
    + (f'core receipt `{receipt}`, ' if receipt != '-' else 'no checker run, ')
    + f'study §{section}, row in the history file); ', 1)
if receipt != '-':
    latest = [i for i, line in enumerate(board) if 'the latest core receipt is' in line]
    assert len(latest) == 1, latest
    m = re.search(r"the latest core receipt is [^;.]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board[latest[0]])
    assert m, 'latest receipt sentence'
    day = int(receipt[6:8])
    board[latest[0]] = board[latest[0]].replace(m.group(0),
                                                f"the latest core receipt is OC3's `{receipt}` ({day} October 2026)")
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
BOARD.write_text('\n'.join(board), encoding='utf-8')
print('board land')
