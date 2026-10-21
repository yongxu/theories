# SG11 board edit, used by apply_text.py: the row moves to the history file, its status naming what landed; the queue
# and receipt sentences name the landing.
import re
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith("| **SG11: valuing what is left at the horizon**")]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-22, core receipt `{receipt_id}`; as claimed, the capacity needing only to cover the renewal '
            f'after the first step and the horizon any; new laws of Becoming.Optimum, {d_new} declarations added, {n_new} '
            f'of them theorems, none removed, empty axiom reports; record {RID} new; study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is SG11's `{receipt_id}` (22 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('SG11 ')]
landed = (f'SG11 landed (valuing what is left at the horizon: with what is left valued one for one with what is drawn, '
          f'every optimum of every order rising with it holds a level of greatest renewal to the horizon, the optima of '
          f'that order exactly the open courses doing so, so the drain at the end is no longer forced; a dependence above '
          f'every such level is still broken at the first step; new laws of `Becoming.Optimum`; core receipt '
          f'`{receipt_id}`, study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id)
