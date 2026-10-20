# AP1 board edit, used by apply_text.py: the row moves to the history file; the queue and receipt sentences name the
# landing.
import re
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith('| **AP1: alignment approaches as instances')]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-21, core receipt `{receipt_id}`; {n_new} theorems in Becoming.SelectionPool and {w_new} in '
            f'Becoming.Weightings (no new module, rule 9), empty axiom reports; records {RID} and {AID} new, '
            f'widening-as-what-every-weighting-ranks extended; study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is AP1's `{receipt_id}` (21 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('AP1 ')]
landed = (f'AP1 landed (alignment approaches as instances of the selection laws, each with what it couples into, its '
          f'premise, its gap and what it adds, no ranking; the gap premise-free, the incompleteness of preference-coupled '
          f'approaches the continuation condition\'s; reading another\'s couplings is pooling with it, in '
          f'`Becoming.SelectionPool`; widening is what every order increasing in admission shares, additive or not, in '
          f'`Becoming.Weightings`; core receipt `{receipt_id}`, study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id)
