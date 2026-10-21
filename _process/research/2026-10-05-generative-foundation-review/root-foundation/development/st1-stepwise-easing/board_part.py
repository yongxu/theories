# ST1 board edit, used by apply_text.py: the row moves to the history file, its status naming what landed; the queue
# and receipt sentences name the landing.
import re
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith("| **ST1: the stepwise law of easing")]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-21, core receipt `{receipt_id}`; as claimed, the law exact (the easing course undermining no '
            f'event the other includes) and the restraint premise sufficient, not necessary (the restrained flow taking '
            f'within what it gives); new laws of Becoming.Ranking and Becoming.JointDraw, {d_new} declarations added, '
            f'{n_new} of them theorems, none removed, empty axiom reports; record {RID} new; study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is ST1's `{receipt_id}` (21 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('ST1 ')]
landed = (f'ST1 landed (the stepwise law of easing: under easing an event the stepwise reading includes stays included '
          f'exactly where the easing course does not undermine there, so it extends the other exactly when it undermines '
          f'no event the other includes and includes one the other withholds; a course whose levels never fall undermines '
          f'nothing, giving restraint over any number of drawers under the stepwise reading where the restrained flow takes '
          f'within what it gives; new laws of `Becoming.Ranking` and `Becoming.JointDraw`; core receipt `{receipt_id}`, '
          f'study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id)
