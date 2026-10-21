# RM6 board edit, used by apply_text.py: the row moves to the history file, its status naming what landed; the queue
# and receipt sentences name the landing.
import re
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith("| **RM6: coupled regimes, where a condition's margin is not its own**")]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-21, core receipt `{receipt_id}`; as claimed, with rest and the threshold stated within a band '
            f'in whole numbers (where mutual support gives within each draw), ending read as nothing from some step on, '
            f'and a further witness that a band without mutual support gives no rest; new laws of Becoming.RegimeMargin, '
            f'{d_new} declarations added, {n_new} of them theorems, none removed, empty axiom reports; record {RID} new; '
            f'study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is RM6's `{receipt_id}` (21 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('RM6 ')]
landed = (f'RM6 landed (coupled regimes, where a condition\'s margin is not its own: two conditions under draws, each '
          f'giving from what is left of both; under mutual support the coupled step keeps the order of states and a '
          f'condition ending from a state ends from every state below it; within a band in whole numbers a run comes to '
          f'rest and each condition\'s point of no return is a least level that does not rise as its partner rises; a '
          f'dependent drains by its draw once its partner has nothing left, and under dependence both ways the two end '
          f'together; witnesses for rescue, inhibition, a band without support and a cycle under support beyond a band; '
          f'new laws of `Becoming.RegimeMargin`; core receipt `{receipt_id}`, study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id)
