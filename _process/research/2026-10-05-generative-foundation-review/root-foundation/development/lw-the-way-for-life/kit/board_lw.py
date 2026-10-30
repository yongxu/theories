#!/usr/bin/env python3
"""LW's board row at landing (from the checkout root): the row, taken, becomes done and moves to the history file
before "## Lapsed claims", its links rewritten for the history file's place, as other done rows are."""
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
TITLE = '| **LW: the ethics for life, with no absolute good, taken**'

lines = BOARD.read_text(encoding='utf-8').split('\n')
hits = [i for i, l in enumerate(lines) if l.startswith(TITLE)]
assert len(hits) == 1, hits
c = lines[hits[0]].split(' | ')
assert len(c) == 5, len(c)
c[0] = c[0].replace(TITLE, '| **LW: the ethics for life, with no absolute good, done**', 1)
c[2] = ("done 30 October 2026 (texts only: no Lean, no record, nothing proved changes; the condition (scope) and C "
        "(order) stay named premises). T8 in the stance form, \"For life, the way is 生生\": \"for life\" says whose way it "
        "is, not whose losses count, which stay every continuation's; it is the way of those whose own line runs through "
        "life, of whatever substrate; the stance starts from P1, which the condition contains, not from a wish, and "
        "neither gives that the wider course is better, which is C's. No verdict binding every possible mind is claimed, "
        "and neither logic alone nor the represented dynamics alone entails the condition. Open: P2 and P4 of 07 §4.6 with P3, the "
        "step for what that path does not reach, a reason for C. The thesis paragraph, does-not-show, 07's open item, the "
        "one page and the overview (both editions), 08, the review packet's P-26, COLLECTIVE-DIRECTION, OPENING's "
        "footnote [^ethics] and AGENTS.md's ethics paragraph follow (TEXTS §3, by kit/lw_texts.py). The record "
        "universal-practical-warrant stays the target zero-axiom-session pursues, which the ethics does not wait on; "
        "whether that goal is restated is Ren's. Reviewed twice: GPT astra, and five lenses with each finding verified "
        "(62 findings, 51 standing, every one taken or its split decided in TEXTS §2); the final texts re-read by GPT astra, "
        "two of its three findings taken and the third, a phrase in the goal's objective, fixed by the goal's owner "
        "with Ren's approval")
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
print('LW done; row moved to', HISTORY)
