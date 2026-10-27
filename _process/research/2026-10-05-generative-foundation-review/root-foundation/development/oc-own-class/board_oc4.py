#!/usr/bin/env python3
"""OC4: the board row. `land SECTION PFLETTERS` moves the row, its state set to landed, into the history file after the
last landed row (inserting it, the rest of the file byte for byte), adds the landing to the queue note and, where the
PF line's owner said yes to its questions ((g), (h)), brings the way now's paraphrase of them to the new wording.
PFLETTERS are the PF line's applied letters from a–l, or - for none.
usage (from the checkout root): python3 -B board_oc4.py land SECTION PFLETTERS"""
import sys
from datetime import date
from pathlib import Path

ROOT = Path.cwd()
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
if sys.argv[1:2] != ['land'] or len(sys.argv) != 4:
    raise SystemExit(__doc__)
section, pf = int(sys.argv[2]), ('' if sys.argv[3] == '-' else sys.argv[3])
assert set(pf) <= set('abcdefghijkl'), pf
left = [k for k in 'abcdefghijkl' if k not in pf]
board = BOARD.read_text(encoding='utf-8').split('\n')
rows = [i for i, line in enumerate(board) if line.startswith("| **OC4: a second check of the crux's texts**")]
assert len(rows) == 1, rows
cells = board[rows[0]].split(' | ')
assert len(cells) == 5, len(cells)
if not left:
    pf_part = "the PF line's places (a)–(l) on its owner's answer"
elif pf:
    pf_part = (f"the PF line's places {', '.join(f'({k})' for k in pf)} on its owner's answer, "
               f"{', '.join(f'({k})' for k in left)} left with it")
else:
    pf_part = "the PF line's places (a)–(l) proposed to its owner and left with it"
cells[2] = (f'landed {date.today().isoformat()}; the review: 2 errors, 8 imprecisions and 2 clarity points against the '
            'Lean, 6 places a philosopher could not follow, no proof wrong (`development/oc-own-class/REVIEW-OC4.md`); '
            'every finding verified, two suggested wordings narrowed; fixed in the IV3 and OC lines\' texts (07 §4.3 and '
            '§4.6, P-15, P-18, P-20, the records constancy-read-at-a-members-class and need-and-feeding-read-with-time, '
            f'D64), {pf_part}; texts only, no checker run; GrammarPath\'s module doc (lines 7 and 32), the root bullet on '
            'what leaves the class and a class lemma for `FinerWake`\'s finer division wait for the next landing that '
            f'rebuilds `Becoming.GrammarPath`; study §{section}')
row = ' | '.join(cells)
del board[rows[0]]
queue = [i for i, line in enumerate(board) if line.startswith('- **Queue:** ')]
assert len(queue) == 1
board[queue[0]] = board[queue[0]].replace(
    '- **Queue:** ',
    "- **Queue:** OC4 landed (the crux's texts checked a second time and made exact, texts only, no checker run; study "
    f'§{section}, row in the history file); ', 1)
if 'g' in pf or 'h' in pf:
    crux = [i for i, line in enumerate(board) if line.startswith('  2. **The crux.** ')]
    assert len(crux) == 1, crux
    line = board[crux[0]]
    if 'g' in pf:
        old = "a line that ends or the regularity one's acts keep going,"
        assert line.count(old) == 1
        line = line.replace(old, "a line that ends while it still conditions something or a regularity of one's own,")
    if 'h' in pf:
        old = "and whether one's effects are one's own for scope"
        assert line.count(old) == 1
        line = line.replace(old, "and whether all of one's effects are one's own for scope")
    board[crux[0]] = line
text = HISTORY.read_text(encoding='utf-8')
history = text.split('\n')
assert len(history) > 600, 'the history file looks cut; restore it first'
lapsed = history.index('## Lapsed claims (18 October 2026)')
end = lapsed - 1
while not history[end].startswith('| '):
    end -= 1
history.insert(end + 1, row)
HISTORY.write_text('\n'.join(history), encoding='utf-8')
assert HISTORY.read_text(encoding='utf-8').count('\n') == text.count('\n') + 1
BOARD.write_text('\n'.join(board), encoding='utf-8')
print('board land')
