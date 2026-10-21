#!/usr/bin/env python3
"""SG4: the draw is bounded exactly above the renewal only for a positive draw (`Optimum.drawn_bounded_iff` and
`Optimum.Renewing.store_bounded_iff` take `0 < k`; a draw of nothing is bounded and not above the renewal). Make the
landed text say so, and the kit's texts and scripts with it, so that a rerun of the kit reproduces the landing.
usage (from the checkout root, after apply_text.py and make_record.py): python3 -B precise_positive.py

Applied once, to the first landing text (the gated form, not committed); the kit's texts carry its change, and it
is not rerun."""
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path.cwd()
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
REC = 'theories/becoming/results/records/re-optimizing-above-a-renewal-ends-it.json'

EN34 = ('the draw is bounded exactly where `r < k`, and over a long course keeping draws more',
        'a positive draw is bounded exactly where `r < k`, and over a long course keeping draws more')
EN10 = ('above the renewal everything ever drawn is bounded, within it not, so',
        'above the renewal everything ever drawn is bounded, within it a positive draw is not, so')
ZH34 = ('；所汲取的总量恰在 `r < k` 时有界，', '；正的汲取的总量恰在 `r < k` 时有界，')
ZH10 = ('超出更新时所汲取的总量有界，在其内则无界', '超出更新时所汲取的总量有界，在其内正的汲取则无界')
BOARD = ('and kept within it; the draw is bounded exactly above the', 'and kept within it; a positive draw is bounded '
         'exactly above the')
ST1 = ('within it k is drawn at every step, so the draw is bounded\n       exactly where r < k',
       'within it k is drawn at every step, so a positive draw is\n       bounded exactly where r < k')
ST2 = ('So the draw is bounded exactly where `r < k` (`Optimum.drawn_bounded_iff`)',
       'So a positive draw is bounded exactly where `r < k` (`Optimum.drawn_bounded_iff`)')
ST3 = ('the store is bounded exactly there (`store_bounded_iff`)',
       'with a positive capacity the store is bounded exactly there (`store_bounded_iff`)')
ST4 = ("the draw's total is bounded exactly above the renewal", "a positive draw's total is bounded exactly above the "
       "renewal")
CK1 = ('everything ever drawn is bounded exactly above the renewal', "a positive draw's total is bounded exactly above "
       "the renewal")
CK2 = ('the draw is bounded exactly above the renewal;', 'a positive draw is bounded exactly above the renewal;')
L3 = ('So the draw is bounded exactly where r < k', 'So a positive draw is bounded exactly where r < k')
L3Z = ('故所汲取的总量恰在 r < k 时有界', '故正的汲取总量恰在 r < k 时有界')
L7 = ('the store is bounded exactly there', 'with a positive capacity the store is bounded exactly there')
L7Z = ('库恰在那时有界', '容量为正时库恰在那时有界')
H = ('the draw is bounded exactly above the renewal', 'a positive draw is bounded exactly above the renewal')
HZ = ('所汲取的总量恰在超出更新时有界', '正的汲取总量恰在超出更新时有界')


def edit(path, pairs, root=ROOT):
    p = root / path
    text = p.read_text(encoding='utf-8')
    for old, new in pairs:
        k = text.count(old)
        if k != 1:
            raise SystemExit(f'{path}: expected one match, found {k}: {old[:80]!r}')
        text = text.replace(old, new)
    p.write_text(text, encoding='utf-8')
    print('edited', path, len(pairs))


# The landed text.
edit('theories/becoming/chapters/THE-THEORY-OF-BECOMING.md', [EN34, EN10])
edit('theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md', [ZH34, ZH10])
edit('_process/BECOMING-WORKBOARD.md', [BOARD])
edit(RF + 'BECOMING-RENEWAL-READING.md', [ST1, ST2, ST3, ST4])
edit(RF + 'BECOMING-SIGNIFICANCE-REVIEW.md', [CK1, CK2])
d = json.loads((ROOT / REC).read_text(encoding='utf-8'))
laws = d['laws']
for i, (old, new), (oldz, newz) in [(2, L3, L3Z), (6, L7, L7Z)]:
    assert laws[i]['en'].count(old) == 1 and laws[i]['zh'].count(oldz) == 1, i
    laws[i]['en'] = laws[i]['en'].replace(old, new)
    laws[i]['zh'] = laws[i]['zh'].replace(oldz, newz)
    assert len(laws[i]['en']) <= 420 and len(laws[i]['zh']) <= 190, (i, len(laws[i]['en']), len(laws[i]['zh']))
h = d['history'][-1]
assert h['en'].count(H[0]) == 1 and h['zh'].count(HZ[0]) == 1
h['en'] = h['en'].replace(*H)
h['zh'] = h['zh'].replace(*HZ)
(ROOT / REC).write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('edited', REC)

# The kit, so that it reproduces the landing.
edit('study_sg4.txt', [ST1, ST2, ST3, ST4], HERE)
edit('check_sg4.txt', [CK1, CK2], HERE)
edit('apply_text.py', [
    ("'`r` a step (`Web.course_drawn_within`), the draw is bounded exactly where `r < k`, and over a long course '",
     "'`r` a step (`Web.course_drawn_within`), a positive draw is bounded exactly where `r < k`, and over a long '\n"
     "         'course '"),
    ("'it; above the renewal everything ever drawn is bounded, within it not, so over a long course keeping draws '",
     "'it; above the renewal everything ever drawn is bounded, within it a positive draw is not, so over a long '\n"
     "          'course keeping draws '"),
    ('所汲取的总量恰在 `r < k` 时有界，', '正的汲取的总量恰在 `r < k` 时有界，'),
    ('超出更新时所汲取的总量有界，在其内则无界', '超出更新时所汲取的总量有界，在其内正的汲取则无界')], HERE)
edit('board_part.py', [("f'lost exactly where the draw exceeds r, for good, and kept within it; the draw is bounded "
                        "exactly above the '",
                        "f'lost exactly where the draw exceeds r, for good, and kept within it; a positive draw is '\n"
                        "          f'bounded exactly above the '")], HERE)
edit('make_record.py', [
    ("'step. So the draw is bounded exactly where r < k,", "'step. So a positive draw is bounded exactly where r < k,"),
    ('故所汲取的总量恰在 r < k 时有界', '故正的汲取总量恰在 r < k 时有界'),
    ("the store is bounded exactly there, gains k a step '", "with a positive capacity the store is bounded exactly '\n"
     "     'there, gains k a step '"),
    ('库恰在那时有界', '容量为正时库恰在那时有界'),
    ("and kept within it; the draw is bounded '\n              f'exactly above the renewal;",
     "and kept within it; a positive draw is '\n              f'bounded exactly above the renewal;"),
    ('所汲取的总量恰在超出更新时有界', '正的汲取总量恰在超出更新时有界')], HERE)
