# UM board edit, used by apply_text.py: the row moves to the history file, its status naming what landed; the queue
# and receipt sentences name the landing.
import re
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines_ = board.split('\n')
rows = [i for i, line in enumerate(lines_) if line.startswith("| **UM: one unified model of drawers in turn")]
assert len(rows) == 1, rows
row = lines_.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-22, core receipt `{receipt_id}`; as claimed; Becoming.Optimum '
            f'{lines["Becoming.Optimum"]}, Becoming.RegimeMargin {lines["Becoming.RegimeMargin"]}, empty axiom reports; '
            f'record {RID} new, four drawer records superseded by it; study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines_)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is UM's `{receipt_id}` (22 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('UM ')]
landed = (f'UM landed (one model of drawers in turn, every drawer with a floor, on one law of best response, what a '
          f'drawer keeps above its floor returning to it at least one for one, the drain, revision, capacity and '
          f'witnesses from it, four drawer records superseded by `{RID}`; one law of exact thresholds for the margins; '
          f'core receipt `{receipt_id}`, study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id)
