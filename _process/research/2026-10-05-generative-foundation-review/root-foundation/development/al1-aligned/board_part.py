# AL1 board edit (from UM3), used by apply_text.py: the row moves to the history file, its status naming what landed; the queue
# and receipt sentences name the landing.
import re
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines_ = board.split('\n')
rows = [i for i, line in enumerate(lines_) if line.startswith("| **AL1: when drawing at once drains, and whom restraint pays**")]
assert len(rows) == 1, rows
row = lines_.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-22, core receipt `{receipt_id}`; as claimed, with record {RID} updated in place of a new record and Web.whole_drain_broken added; Becoming.Optimum {lines["Becoming.Optimum"]}, '
            f'empty axiom reports; study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines_)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is AL1's `{receipt_id}` (22 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('AL1 ')]
landed = (f'AL1 landed (when drawing at once drains, and whom restraint pays: drawing everything is perfect exactly where '
          f'no portion returns more than one for one on what its drawer alone leaves; where each returns less, no profile '
          f'draws any drawer more; holding can draw every drawer more where the drain is perfect; for a drawer given the '
          f'whole drawing everything is not perfect where the whole returns more than one for one; OPENING [^aligned] and '
          f'[^race] rewritten; record `{RID}`; core receipt `{receipt_id}`, study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id)
