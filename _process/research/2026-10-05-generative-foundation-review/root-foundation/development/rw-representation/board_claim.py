#!/usr/bin/env python3
"""RW's claim on main's board: its row in RV's place, RV's landed row moved to the history file marked done after ED5's,
and the way now's order line brought to RW. Each replacement asserted once; the Queue line compared byte for byte."""
B = '/Users/ren/theories/_process/BECOMING-WORKBOARD.md'
H = '/Users/ren/theories/_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
s = open(B).read()
n0 = len(s)
def queue(t):
    q = [l for l in t.split('\n') if l.startswith('- **Queue:**')]
    assert len(q) == 1
    return q[0]
q0 = queue(s)
def rep(a, b):
    global s
    assert s.count(a) == 1, (s.count(a), a[:90])
    s = s.replace(a, b)
rep("and RV having landed (RV's row), the map's open items",
    "RV having landed (`805cff889`), RW, the review's later steps until each of its seven scores is at least 8 of 10 (RW's row); then the map's open items")
lines = s.split('\n')
k = [i for i, l in enumerate(lines) if l.startswith('| **RV: what the pages around the account tell a reader**')]
assert len(k) == 1
rv = lines[k[0]]
DEV = 'research/2026-10-05-generative-foundation-review/root-foundation/development/rw-representation/'
row = ("| **RW: the review's later steps, until each of its seven scores is at least 8 of 10** (Ren, 8 November 2026: \"just finish all "
       "steps one by one\", then \"continue, actually, just keep going until everything is at least 8/10\"; his words go to `sources/` with the "
       "first landing). Purpose: shared understanding with human readers (RP) and alignment researchers coupling into the work (AJ4). RV's "
       "review scored how the repository presents itself 2 to 4 of 10 on seven questions (a site; the unification shown; how it grew; its value; "
       "its uses; what is valuable easy to see) and planned four steps, of which (a), what a reader is told, landed. This row does the rest: "
       "(b) a static site built from an allow-list that refuses the push screen's private paths, with a dispatch-only Pages job, its publishing "
       "Ren's (enabling Pages); the two pages GitHub cannot render (the crosswalk, 3.7 MB, and the core's declarations, 4.7 MB; a check on 8 November "
       "found the atlas, the chain and the Lean index do render, against the review) split by their generators; (c) a generated picture of the "
       "spine, the edge kinds kept apart, and a generated lineage of how the account grew; (d) a page on what the account is for and how far, "
       "\"nothing claimed\" where nothing is; and the way in (the first screen's value sentence and picture, the navigation line, a scoreboard of "
       "the frozen tests, failures first). Then fresh AI reviewers re-score the seven questions, and what keeps a score below 8 is fixed. Landed "
       "in pieces, each with independent readers' rounds and the gate. No new result, no Lean, no model call beyond AI readers, nothing paid, "
       "no test designed. The README keeps the opening at its top, as Ren asked on 10 October; the site's own landing links it | the "
       "coordinator | claimed 8 November 2026 | branch `rw-representation`, `~/tmp/rw/wt` | atlas.py and the crosswalk's pages, lean_catalogue.py "
       "and the core's declarations, new generators for the spine picture, the tests scoreboard and the lineage, navigation.py's navigation line "
       "and first screen, a new uses page, `tools/publishing/build_site.py`, `.github/workflows/pages.yml`, `_process/research-config.json` "
       "(`site_paths`) |")
lines[k[0]] = row
s = '\n'.join(lines)
assert queue(s) == q0
h = open(H).read()
done = rv.replace('| **RV: what the pages around the account tell a reader**', '| **RV: what the pages around the account tell a reader, done**', 1)
assert done != rv
hl = h.split('\n')
ed5 = [n for n, l in enumerate(hl) if l.startswith('| **ED5: edition 5 of the reader edition, done**')]
assert len(ed5) == 1 and not hl[ed5[0] + 1].startswith('|'), ed5
hl.insert(ed5[0] + 1, done)
open(H, 'w').write('\n'.join(hl))
open(B, 'w').write(s)
print('ok', n0, len(s))
