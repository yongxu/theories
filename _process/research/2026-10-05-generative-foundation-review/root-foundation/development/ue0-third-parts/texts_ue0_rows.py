#!/usr/bin/env python3
"""UE0 follow-up, texts only (no checker run): the evolution line's two rows in 08 §8's table, with the audit's verdicts.
The audit found that the table had no row for Price, Fisher, Hamilton and selection among groups, nor for drift,
fixation and mutation, though 04 §7 sends their verdicts there (AUDIT.md §5, §7 item 6). This adds the two rows; says in
the verdict paragraph that they are the audit's, not the prior-art review's; names them in the third-parts paragraph;
points 04 §7 at the table; brings the UE plan's line on the missing row up to date; and appends the study section N.
No verdict, record, Lean or generated page changes beyond the render. Every edit asserts it applies exactly once.
usage (from the checkout root, on main or a landing worktree, after DF2 is on main): python3 -B <kit>/texts_ue0_rows.py N"""
import sys
from pathlib import Path

ROOT = Path.cwd()
N = int(sys.argv[1])
CH = ROOT / 'theories/becoming/chapters'
RF = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = RF / 'BECOMING-RENEWAL-READING.md'
PLAN = RF / 'development/ue-unified-explanation/PLAN.md'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# 08 §8: the two rows, after the last row of the table
edit(CH / '08-METHOD.md', """| [Fed from beyond](02-MAP.md#r-continuing-self-fed-from-beyond), [entropy](02-MAP.md#r-least-loss-from-entropy-production), [nets](01-ROOT.md#r-place-transition-nets-on-the-spine) | Schrödinger (1944); Prigogine (1977); ranking functions; P-invariants of Petri nets (Lautenbach 1975) | restated; the nets agree with net theory and are not independent evidence |
""", """| [Fed from beyond](02-MAP.md#r-continuing-self-fed-from-beyond), [entropy](02-MAP.md#r-least-loss-from-entropy-production), [nets](01-ROOT.md#r-place-transition-nets-on-the-spine) | Schrödinger (1944); Prigogine (1977); ranking functions; P-invariants of Petri nets (Lautenbach 1975) | restated; the nets agree with net theory and are not independent evidence |
| [Evolution on descent](04-LIFE.md#r-evolution-on-descent), [what bounds offspring numbers](04-LIFE.md#r-what-bounds-offspring-numbers), [Hamilton's rule](04-LIFE.md#r-selection-with-returns-to-groupmates), [groups on coupled conditions](04-LIFE.md#r-groups-whose-conditions-are-coupled) | Price (1970, 1972); Fisher (1930); Hamilton (1964, 1975); multilevel selection; Malthus (1798) | restated in counts; joined to the flow, a third part known as the Malthusian bound ([below](#third-parts)) |
| [Drift](04-LIFE.md#r-drift-offspring-sampled), [fixation](04-LIFE.md#r-fixation-by-drift), [mutation](04-LIFE.md#r-mutation-and-the-balance-it-sets) | Wright–Fisher; Moran (1958); Kimura; mutation–selection balance (Haldane); the error threshold (Eigen 1971) | restated as finite weighted bounds |
""")

# 08 §8: where the two rows come from
edit(CH / '08-METHOD.md',
     "and the search was not exhaustive.\n\n| Central result | Closest prior result | Verdict |",
     "and the search was not exhaustive. The last two rows, the evolution line of [04](04-LIFE.md), which that "
     "review did not rank, carry the verdicts of the audit of the third parts ([below](#third-parts)).\n\n"
     "| Central result | Closest prior result | Verdict |")

# 08 §8: the third-parts paragraph names the evolution rows
edit(CH / '08-METHOD.md',
     "Price's equation and Fisher's theorem joined to the flow have one as well "
     "([04](04-LIFE.md#r-what-bounds-offspring-numbers)).",
     "In the evolution line's rows, which the audit added to the table, Price's equation and Fisher's theorem "
     "joined to the flow have one as well ([04](04-LIFE.md#r-what-bounds-offspring-numbers)); drift, fixation and "
     "mutation have none.")

# 04 §7: the pointer names the table
edit(CH / '04-LIFE.md',
     "their verdicts against prior work are in [08](08-METHOD.md).",
     "their verdicts against prior work are in [08 §8](08-METHOD.md#known-results).")

# the UE plan: the table now carries the rows
edit(PLAN,
     "Beyond those rows, so does Price, Fisher and Hamilton joined to the flow, which 08 §8's table lacks.",
     "Beyond those rows, so does Price, Fisher and Hamilton joined to the flow, now one of the two evolution rows "
     "the audit added to 08 §8's table.")

# the study section
section = f"""## {N}. The evolution line in 08 §8's table (UE0's follow-up)

UE0's audit of the third parts found that 08 §8's table had no row for the evolution line, though 04 §7 sends its verdicts there ([audit](development/ue0-third-parts/AUDIT.md), §5 and §7, item 6). The two rows are added with the audit's verdicts: Price, Fisher, Hamilton and selection among groups, restated in counts and, joined to the flow, with a third part known as the Malthusian bound; drift, fixation and mutation, restated as finite weighted bounds, with none. The verdict paragraph says the two rows are the audit's, not the prior-art review's, the third-parts paragraph names them, 04 §7 points to the table, and the UE plan no longer says the table lacks them.

```text
Result(s): none new; texts only.
Delta: 08 §8's table gains the evolution line's two rows with UE0's verdicts; its verdict paragraph says where they
       come from; the third-parts paragraph names them; 04 §7's pointer names the table; the UE plan's line on the
       missing row is brought up to date. No verdict changes.
Supplied premises / correspondence: none.
Evidence: UE0's audit, §5.1 and §5.2, unchanged.
Boundary: no record, Lean or generated page changes beyond the render.
Output → input: 08 §8; 04 §7; the UE plan.
```
"""
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')
print('texts: 08 §8 evolution rows, verdict paragraph, third parts; 04 §7 pointer; UE plan; study section', N)
