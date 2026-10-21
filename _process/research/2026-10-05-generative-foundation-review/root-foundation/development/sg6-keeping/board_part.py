# SG6 board edit, used by apply_text.py: the row moves to the history file; the queue and receipt sentences name the
# landing.
import re
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith('| **SG6: what keeping a dependence forgoes over a horizon**')]
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
board = board.replace(m.group(0), f"the latest core receipt is SG6's `{receipt_id}` (21 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('SG6 ')]
landed = (f'SG6 landed (what keeping a dependence forgoes over a horizon: where what is given at or above the need '
          f'is at most q, keeping forgoes, against the course holding the greatest renewal r and leaving nothing, '
          f'(r - q) n and the need; a coupling of the dependence below that leaves only optima breaking it within the '
          f'horizon, one beyond it only optima keeping it, both attained; where the need lies above every level of '
          f'greatest renewal the amount grows with the horizon and outweighs every coupling fixed in total; witness the '
          f'logistic law, forgoing n + 3 over n + 2 steps, in new laws of `Becoming.Optimum`; core receipt '
          f'`{receipt_id}`, study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id)
