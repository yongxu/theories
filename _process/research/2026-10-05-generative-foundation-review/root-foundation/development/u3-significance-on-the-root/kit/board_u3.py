#!/usr/bin/env python3
"""U3's board row at landing (from the checkout root): the row, its Lean items 1 and 2 landed, becomes done and moves to
the history file before "## Lapsed claims", its links rewritten for the history file's place, as other done rows are.
Item 3 («广之对应») was never U3's to land: it stays with GrammarTransport's owner, as the row says."""
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
TITLE = '| **U3: the significance rows on the root, designed; Lean items 1 and 2 claimed**'

lines = BOARD.read_text(encoding='utf-8').split('\n')
hits = [i for i, l in enumerate(lines) if l.startswith(TITLE)]
assert len(hits) == 1, hits
c = lines[hits[0]].split(' | ')
assert len(c) == 5, len(c)
c[0] = c[0].replace(TITLE, '| **U3: the significance rows on the root, done**', 1)
c[2] = ("done 30 October 2026 (core run 20261030T131028.245732Z, every axiom report empty; study §465). The core leaf "
        "`Becoming.SignificanceStatements` and row 10's interface law in `Becoming.Weightings`: rows 5 and 7 restated "
        "on a web's level paths and row 10 on a finite listing, each on its own carrier with an F5 item (model own); "
        "rows 1, 8 and 9 specialized at the own-closure reading of significance, `selfAscribed (ownClosure rel) "
        "center`, with none, since F5 takes no specialization. A restatement, not a derivation: nothing ethical follows "
        "from the root, the condition (scope) and C (order) stay premises and `sig` the general form. F5 44/16/7/51 "
        "(from 44/16/4/54); 全四 met as F4 defines it, always with F5's figure beside it (OU's owner's ruling). Four "
        "records (`kit/make_records_u3.py`), chapter 7's home bullets, 08 §7's count, the one page and the overview in "
        "both editions, PHILOSOPHY, BUDDHIST-THOUGHT and the FU proposal (`kit/texts_u3.py`); the apart root "
        "registered (`kit/register_u3.py`). Reviewed: the design (GPT astra), the Lean and records kit "
        "(REVIEW-U3-LEAN) and the texts (REVIEW-U3-TEXTS, three lenses, 39 findings, all taken). Item 3 "
        "(`«广之对应»`) stays with GrammarTransport's owner")
row = ' | '.join(c).replace('](research/', '](../../research/').replace('](../sources/', '](../../../sources/')
del lines[hits[0]]
BOARD.write_text('\n'.join(lines), encoding='utf-8')
hl = HISTORY.read_text(encoding='utf-8').split('\n')
k = [i for i, l in enumerate(hl) if l.startswith('## Lapsed claims')]
assert len(k) == 1
j = k[0] - 1
while hl[j].strip() == '':
    j -= 1
assert hl[j].startswith('| '), hl[j][:80]
hl.insert(j + 1, row)
HISTORY.write_text('\n'.join(hl), encoding='utf-8')
print('U3 done; row moved to', HISTORY)
