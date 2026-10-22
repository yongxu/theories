# EV13 and EV14 board edit, used by apply_text.py: both rows move to the history file, their status naming what landed;
# the queue and receipt sentences name the landing.
import re
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines_ = board.split('\n')
moved = []
for start, mod, rid in (('| **EV13: selection in the draw', 'Becoming.Drift', RID13),
                        ('| **EV14: mutation, transmission that is not exact', 'Becoming.Reproduction', RID14),
                        ('| **EV15: the breeding value', 'Becoming.Reproduction', RID15),
                        ('| **EV16: dependences formed by descent', 'Becoming.Transmission', RID16)):
    rows = [i for i, line in enumerate(lines_) if line.startswith(start)]
    assert len(rows) == 1, (start, rows)
    row = lines_.pop(rows[0])
    cells = row.split(' | ')
    assert len(cells) == 5, len(cells)
    cells[2] = (f'landed 2026-10-22 with EV13-EV16 together, core receipt `{receipt_id}`; {mod} gained {n_thm[mod]} '
                f'theorems in this landing (no new module, rule 9), empty axiom reports; record {rid}; study §{N}')
    moved.append(' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/'))
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
for k, row in enumerate(moved):
    hist.insert(lastrow + 1 + k, row)
board = '\n'.join(lines_)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is EV13-EV16's `{receipt_id}` (22 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith(('EV13 ', 'EV14 ', 'EV15 ', 'EV16 ', 'EV13-EV16 '))]
landed = (f'EV13-EV16 landed (selection in the draw: the fixation share a potential\'s ratio, in `Becoming.Drift`; mutation '
          f'and its balance, and the breeding value with Fisher\'s fundamental theorem, in `Becoming.Reproduction`; a '
          f'dependence formed from drawing where depending and drawing part at the giver, in `Becoming.Transmission`; '
          f'records `{RID13}`, `{RID14}`, `{RID15}`, `{RID16}`; core receipt `{receipt_id}`, study §{N}, rows in the '
          f'history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board rows moved; receipt', receipt_id)
