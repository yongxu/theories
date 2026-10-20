# WE1 board edit, used by apply_text.py: the row moves to the history file; the queue and receipt sentences name the
# landing (adapted from SG1's board_part.py).
import re
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith("| **WE1: a whole that draws its members' arising")]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-21, core receipt `{receipt_id}`; Becoming.Wholes extended (no new module), now '
            f'{d_new} declarations, {n_new} of them theorems, empty axiom reports; record {RID} new; study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is WE1's `{receipt_id}` (21 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('WE1 ')]
landed = (f'WE1 landed (a whole that draws its parts\' arising beyond its renewal ends: listed parts each ending, none '
          f'arising from some step on, end together with their whole, the law below `Whole.needs_arising`; a whole whose '
          f'parts arise only where they depend on a family whose renewal is gated on it ends after the family\'s joint '
          f'excess outlasts its margin, `Web.Whole.family_excess_ends`, in `Becoming.Wholes`; OPENING note `collective` '
          f'restated and proposal 8\'s second clause a theorem under named premises; core receipt `{receipt_id}`, '
          f'study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id)
