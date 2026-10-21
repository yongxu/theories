# RM5 board edit, used by apply_text.py: the row moves to the history file, its status naming what landed (the core
# laws in any amounts and the periphery's convergence over the reals, two receipts); the queue and receipt sentences
# name the landing.
import re
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith('| **RM5: the regime in any amounts, and its runs over the reals**')]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-21, core receipt `{receipt_id}`, periphery receipt `{peri_id}` (RegimeReals, '
            f'{pm["theorems"]} theorems, standard axioms only); as claimed, with a witness that over the reals a run '
            f'need not come to rest; new laws of Becoming.RegimeMargin, {d_new} declarations added, {n_new} of them '
            f'theorems, none removed, empty axiom reports; record {RID} new; study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is RM5's `{receipt_id}` (21 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('RM5 ')]
landed = (f'RM5 landed (the regime in any amounts, and its runs over the reals: in any linearly ordered amounts with a '
          f'draw the step of a rising adjustment keeps the order of states, from the first step a step neither raising '
          f'nor lowering both climbs or sinks toward the draw and the next such step is of its kind, ordered steps stay '
          f'ordered, a run within a band stays there, and the rests are the regime\'s point or below the draw, whole '
          f'numbers an instance, in new laws of `Becoming.RegimeMargin`; over the non-negative reals, in the periphery '
          f'module `RegimeReals`, every run within a band converges, to a rest where the adjustment is continuous, the '
          f'fates below the draw down-closed and fewer as the recent giving rises, and a run need not rest; core receipt '
          f'`{receipt_id}`, periphery receipt `{peri_id}`, study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipts', receipt_id, peri_id)
