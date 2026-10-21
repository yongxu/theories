# RM4 board edit, used by apply_text.py: the row moves to the history file, its status naming what landed against the
# claim (the fate stated is resting below the draw, which needs no premise of nothing from nothing; where nothing gives
# from nothing that rest is at nothing); the queue and receipt sentences name the landing.
import re
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith('| **RM4: the threshold in the plane of level and recent giving**')]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-21, core receipt `{receipt_id}`; the fate stated is resting below the draw, which needs no '
            f'premise of nothing from nothing (where the adjustment gives nothing from nothing that rest is at nothing, '
            f'by the last clause of `Adjusted.fates`); the threshold is decided at step 3 hi + 3 and is H + y under the '
            f'regime\'s step; new laws of Becoming.LastChange and Becoming.RegimeMargin, {d_new} declarations added, '
            f'{n_new} of them theorems, none removed, empty axiom reports; record {RID} new; study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is RM4's `{receipt_id}` (21 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('RM4 ')]
landed = (f'RM4 landed (the threshold in the plane of level and recent giving: a run has at most one rest; under an '
          f'adjustment rising with what is left and with the recent giving, within a band, a state below one whose run '
          f'rests below the draw rests below it too, decided at step 3 hi + 3; for each recent giving the runs resting '
          f'below the draw are exactly those from levels below a least level, which does not rise as the recent giving '
          f'rises; under the regime\'s step it is H + y; a witness that rising giving is needed, in new laws of '
          f'`Becoming.LastChange` and `Becoming.RegimeMargin`; core receipt `{receipt_id}`, study §{N}, row in the '
          f'history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id)
