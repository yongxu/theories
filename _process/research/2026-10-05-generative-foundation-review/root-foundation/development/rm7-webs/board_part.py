# RM7 board edit, used by apply_text.py: the row moves to the history file, its status naming what landed; the queue
# and receipt sentences name the landing.
import re
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith("| **RM7: coupled webs, support across a web and the cascade of ends**")]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-21, core receipt `{receipt_id}`; as claimed, with rest and thresholds left to the pair (a web\'s '
            f'state is a function, and stillness would need extensionality) and dependence total; new laws of '
            f'Becoming.RegimeMargin, {d_new} declarations added, {n_new} of them theorems, none removed, RM6\'s pair laws of '
            f'order, ending and dependence re-derived from the web\'s, empty axiom reports; record {RID} new; study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is RM7's `{receipt_id}` (21 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('RM7 ')]
landed = (f'RM7 landed (coupled webs, support across a web and the cascade of ends: any number of conditions each giving '
          f'from what is left of all; under mutual support the step keeps the order of states and ending is down-closed; '
          f'along every chain of dependence, with positive draws, the end of one ends everything downstream, a dependence '
          f'cycle ending together; the pair is the web indexed by Bool and its laws are read off the web\'s; witnesses '
          f'for a cascade past direct dependence and a zero draw stopping it; new laws of `Becoming.RegimeMargin`; core '
          f'receipt `{receipt_id}`, study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id)
