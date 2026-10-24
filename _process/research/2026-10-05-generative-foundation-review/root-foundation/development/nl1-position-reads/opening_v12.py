#!/usr/bin/env python3
"""NL1: the opening's version 12 bookkeeping, after apply_text.py: the header comment's version, the frozen copy
(written at drafts/2026-10-10-opening/OPENING-V12.md for research.py move), the drafts README, the review's note.
usage (from the checkout root): python3 -B opening_v12.py"""
from pathlib import Path
O = Path("theories/becoming/OPENING.md")
s = O.read_text(encoding="utf-8")
old = "(version 11 of the drafts, 22 October 2026)"
assert s.count(old) == 1
s = s.replace(old, "(version 12 of the drafts, 22 October 2026)")
O.write_text(s, encoding="utf-8")
Path("drafts/2026-10-10-opening/OPENING-V12.md").write_text(s, encoding="utf-8")
R = Path("drafts/2026-10-10-opening/README.md")
r = R.read_text(encoding="utf-8")
for a, b in [("versions 2 to 11,", "versions 2 to 12,"),
             ("`opening-v10.json` and `opening-v11.json`)", "`opening-v10.json`, `opening-v11.json` and `opening-v12.json`)")]:
    assert r.count(a) == 1, a
    r = r.replace(a, b)
anchor = "The frozen copy is [OPENING-V11.md](history/OPENING-V11.md)."
assert r.count(anchor) == 1
r = r.replace(anchor, anchor + "\n\nVersion 12 was applied on 22 October 2026 ([source](../../sources/15-codex-theory-conversations/2026-10-22-aim-frontier-not-past-understanding.md)). The sentence on the three theories says that none of them is a law, each failing in a world the laws admit, and states what position reads: read against the others, it bounds what all draw only from below, so no winning certifies that anything lasts (board item NL1, record what-position-reads). Nothing else in the body changed. The frozen copy is [OPENING-V12.md](history/OPENING-V12.md).")
R.write_text(r, encoding="utf-8")
V = Path("_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md")
v = V.read_text(encoding="utf-8")
a = "*Version 11 (22 October 2026, OP11).*"
i = v.index(a)
j = v.index("\n\n", i)
note = "\n\n*Version 12 (22 October 2026, NL1).* The sentence on the three theories had said that none of their features is \"among the laws\" and that winning \"need not\" measure what lasts. A list shows what is listed, not what follows from it, and the second rested on one example. On Ren's \"we should aim frontier, not my past understanding\" ([source](../../../../sources/15-codex-theory-conversations/2026-10-22-aim-frontier-not-past-understanding.md)), it now reads that none of them is a law, each failing in a world the laws admit, and that position, read against the others, bounds what all draw only from below, so no winning certifies that anything lasts ([what-position-reads](../../../../theories/becoming/results/records/what-position-reads.md)). The readings of each feature as a law are the note's, labelled as such."
v = v[:j] + note + v[j:]
V.write_text(v, encoding="utf-8")
print("opening v12: header, frozen copy, drafts README, review note")
