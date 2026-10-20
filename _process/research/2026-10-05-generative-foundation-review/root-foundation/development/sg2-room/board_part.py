# SG2 board edit, used by apply_text.py: the row moves to the history file; the queue and receipt sentences name the
# landing.
import re
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith('| **SG2: room derived from the exchange')]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-21, core receipt `{receipt_id}`; new laws of Becoming.Optimum, {d_new} declarations '
            f'added, {n_new} of them theorems, empty axiom reports; record {RID} new; study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is SG2's `{receipt_id}` (21 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('SG2 ')]
landed = (f'SG2 landed (room read off the exchange: among the outcomes open to a part whose members take at most their '
          f'capacity and give no more than they take, the rest exchanging as it does, room holds with no further premise, '
          f'every optimum of every order rising with what couples in stands at each condition beyond at what the rest '
          f'leaves less the part\'s capacity, untouched where the part may take nothing, and a dependence beyond breaks '
          f'exactly where its need exceeds that, in new laws of `Becoming.Optimum`; core receipt `{receipt_id}`, study '
          f'§{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id)
