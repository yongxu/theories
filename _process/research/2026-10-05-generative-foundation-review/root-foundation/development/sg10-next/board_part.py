# SG10 board edit, used by apply_text.py: the row moves to the history file; the queue and receipt sentences name the
# landing.
import re
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith('| **SG10: over every law of what stands next**')]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-21, core receipt `{receipt_id}`; new laws of Becoming.Optimum, {d_new} declarations '
            f'added, {n_new} of them theorems, {removed} removed, {removed_thms} of them theorems, empty axiom reports; record {RID} new; study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is SG10's `{receipt_id}` (21 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('SG10 ')]
landed = (f'SG10 landed (over every law of what stands: SG8\'s and SG9\'s laws hold over any law of what a level '
          f'gives at a step, the renewal law the case, the renewal forms no law reads any more removed; where others '
          f'first draw from what an optimizer leaves at least what the remainder renews, every optimum of an order '
          f'whose weighting falls at every step ends the base at once, and where they draw more, every optimum under '
          f'positive weights rising at no step, every dependence on the base with a positive need broken at the first '
          f'step; witness the doubling source, rebuilt alone and ended under the same weights with others drawing '
          f'first, in new laws of `Becoming.Optimum`; core receipt `{receipt_id}`, study §{N}, row in the history '
          f'file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id)
