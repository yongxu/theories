# RM2 board edit, used by apply_text.py: the row moves to the history file (its F3 attribution corrected to MQ3's
# check, study section 272); the queue and receipt sentences name the landing.
import re
board = (ROOT / BOARD).read_text(encoding='utf-8')
history = (ROOT / HISTORY).read_text(encoding='utf-8')
lines = board.split('\n')
rows = [i for i, line in enumerate(lines) if line.startswith("| **RM2: the regime's point over every adjustment of giving**")]
assert len(rows) == 1, rows
row = lines.pop(rows[0])
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
OLD_F3 = ("MQ5's frozen check F3 found that the regime's point does not separate fates under a held catch, "
          "[study §280](research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md"
          "#280-a-lag-and-the-draws-response-in-the-field-mq5)")
NEW_F3 = ("MQ3's frozen check F3 found that the regime's point does not separate fates under a held catch, "
          "[study §272](research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md"
          "#272-the-margin-of-a-regime-in-the-field-mq3); MQ5 read the lag, [study §280]"
          "(research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md"
          "#280-a-lag-and-the-draws-response-in-the-field-mq5)")
assert cells[0].count(OLD_F3) == 1
cells[0] = cells[0].replace(OLD_F3, NEW_F3)
cells[2] = (f'landed 2026-10-21, core receipt `{receipt_id}`; new laws of Becoming.RegimeMargin, {d_new} declarations '
            f'added, {n_new} of them theorems, {removed} removed, {removed_thms} of them theorems, empty axiom reports; '
            f'record {RID} new; study §{N}')
row = ' | '.join(cells).replace('](../', '](../../../').replace('](research/', '](../../research/')
hist = history.split('\n')
stop = next((i for i, line in enumerate(hist) if line.startswith('## Lapsed claims')), len(hist))
lastrow = max(i for i, line in enumerate(hist[:stop]) if line.startswith('| **'))
hist.insert(lastrow + 1, row)
board = '\n'.join(lines)
m = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", board)
assert m, 'receipt sentence'
board = board.replace(m.group(0), f"the latest core receipt is RM2's `{receipt_id}` (21 October 2026)")
m = re.search(r'- \*\*Queue:\*\* ([^\n]*)', board)
assert m, 'queue sentence'
parts = [p for p in m.group(1).split('; ') if not p.startswith('RM2 ')]
landed = (f'RM2 landed (the regime\'s point over every adjustment of giving: RegimeMargin\'s laws on ending and holding '
          f'hold over any law of what is left and of the recent giving, the regime\'s step the case, the regime forms '
          f'no law reads any more removed; every rest of the state at or above the draw is the regime\'s where the '
          f'adjustment rests at the draw where the regime gives it, on the run; the fates hold with the recent giving '
          f'on the level\'s side, and on the other side the point is crossed both ways; witnesses for both premises, '
          f'in new laws of `Becoming.RegimeMargin`; core receipt `{receipt_id}`, study §{N}, row in the history file)')
board = board.replace(m.group(0), '- **Queue:** ' + '; '.join([landed] + parts))
(ROOT / BOARD).write_text(board, encoding='utf-8')
(ROOT / HISTORY).write_text('\n'.join(hist), encoding='utf-8')
print('board row moved; receipt', receipt_id)
