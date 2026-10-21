# RM3 board edit, used by apply_text.py: the row moves to the history file, its status naming that the law landed is
# stronger than the claim (every run within a band, not only those whose first step rises or falls); the queue and
# receipt sentences name the landing.
import re
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith('| **RM3: where a run of a regime comes to rest**')]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[2] = (f'landed 2026-10-21, core receipt `{receipt_id}` (a first version\'s receipt `{first_id}` kept); stronger than '
            f'claimed: every run of a rising adjustment within a band comes to rest, whatever its first step; new laws of '
            f'Becoming.LastChange and Becoming.RegimeMargin, {d_new} declarations added, {n_new} of them theorems, none '
            f'removed, empty axiom reports; record {RID} new; study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is RM3's `{receipt_id}` (21 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('RM3 ')]
landed = (f'RM3 landed (where a run of a regime comes to rest: a law\'s run with a bounded mark comes to rest within the '
          f'bound, decided, with no omniscience; with giving rising with what is left, every run of the regime\'s step '
          f'within a band rests within its top; with the adjustment rising with what is left and with the recent giving, '
          f'every run within a band up to hi rests within 3 hi + 3 steps, at the regime\'s point or below the draw; '
          f'witnesses that rising giving and the band are needed, in new laws of `Becoming.LastChange` and '
          f'`Becoming.RegimeMargin`; core receipt `{receipt_id}`, study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id)
