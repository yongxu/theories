#!/usr/bin/env python3
"""IF1 and RP1: chapter (EN, ZH), OPENING [^race] and the study section.
usage (from the checkout root): python3 -B apply_text.py STUDY_SECTION RECEIPT"""
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
N, RECEIPT = int(sys.argv[1]), sys.argv[2]
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
EN = ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
ZH = ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
OPENING = ROOT / 'theories/becoming/OPENING.md'
REC = '../results/records/'
A, P = 'a-rise-past-the-inflow-is-drawn-from-beyond', 'a-race-for-position-draws-everything'
ANCHOR = f'#{N}-a-rise-past-the-inflow-and-a-race-for-position-if1-rp1'
SLINK = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md{ANCHOR}'


PENDING = {}


def edit(path, pairs):
    s = PENDING.get(path, path.read_text())
    for old, new in pairs:
        assert s.count(old) == 1, (path.name, old[:80], s.count(old))
        s = s.replace(old, new)
    PENDING[path] = s


edit(EN, [
    ("so every selection holding only where it rises holds only on flows taking from a condition no member couples into; "
     "`Diversion` is an instance, and its supplying flow shows the premise binds (`Diversion.supplying_raises_untaken`). "
     "Used in §4.3 and §7.2 (law 3).",
     "so every selection holding only where it rises holds only on flows taking from a condition no member couples into; "
     "`Diversion` is an instance, and its supplying flow shows the premise binds (`Diversion.supplying_raises_untaken`). "
     "Without that premise the laws hold graded by the containing family's inflow (`Flow.inflow`, what each formation taking "
     "part gives it beyond what it takes from it, zero exactly where it gains nothing): a rise past the inflow has a formation "
     "drawing from beyond, the rise past it is drawn from beyond in full, and every selection rewarding such a rise favours "
     "the draw (`Flow.Balances.rise_draws_beyond_inflow`, `Flow.Balances.rise_le_inflow_beyond`, "
     "`Flow.favours_reaching_beyond_inflow`); the gainless laws are the case of no inflow, and the supplying flow, rising by "
     f"exactly its inflow, shows the bound exact (`Diversion.supplying_rises_by_inflow`; IF1, [study §{N}]({SLINK})). "
     "Used in §4.3 and §7.2 (law 3)."),
    ("closed, the family rises by at most what the beyond loses (`Flow.Balances.rise_bounded_by_beyond`).",
     "closed, the family rises by at most what the beyond loses (`Flow.Balances.rise_bounded_by_beyond`). Graded by the "
     "whole's inflow these hold for an open whole past what flows in, the gainless laws their case (`Flow.Balances.rise_lowers_beyond_inflow`, "
     "`Flow.Balances.breaks_beyond_inflow`, `Flow.favours_breaking_beyond_inflow`, `Flow.reaches_inflow`, "
     "`Flow.Balances.rise_bounded_by_beyond_inflow`)."),
    (" Where the eligible outcomes are supplied otherwise, without room an optimum need not lower anything",
     " Drawers in turn who rank their position instead, `k` times their draw against what all draw, keep nothing for "
     "position where it comes back to them in no later draw, so at the last step every best response draws everything, and "
     "where what stands from nothing is at most what stands from anything left and there are at least two, every profile "
     "perfect for position draws everything at every step and drawing everything is perfect; where something left stops "
     "what stands next, drawing everything is not perfect, a drawer keeping what it is given to deny the regrowth "
     "(`Optimum.InTurn.position_keeps_nothing`, `Optimum.InTurn.position_perfect_ends`, `Optimum.InTurn.zero_position_perfect`, "
     f"`Optimum.InTurn.Stopping.perfect_keeps`; RP1, [study §{N}]({SLINK}), [{P}]({REC}{P}.md))."
     " Where the eligible outcomes are supplied otherwise, without room an optimum need not lower anything"),
    ("| [Raising what couples in draws from beyond](../results/records/raising-what-couples-in-draws-from-beyond.md) | theorem without premise | — | §3.4 |",
     "| [Raising what couples in draws from beyond](../results/records/raising-what-couples-in-draws-from-beyond.md) | theorem without premise | — | §3.4 |\n"
     f"| [A rise past the inflow is drawn from beyond]({REC}{A}.md) | theorem without premise | — | §3.4 |"),
    ("plain sums over the steps that remain; for the drain and the revision two drawers with no floor; drawing at once, each "
     "portion returning less than one for one | §3.4, §7.1, §8.1 |",
     "plain sums over the steps that remain; for the drain and the revision two drawers with no floor; drawing at once, each "
     "portion returning less than one for one | §3.4, §7.1, §8.1 |\n"
     f"| [A race for position draws everything]({REC}{P}.md) | theorem under stated premises | `k` drawers in turn with no "
     "floor, ranking position over the steps that remain; any law `G` of what stands; for the drain `G t 0 ≤ G t x` and at "
     "least two drawers | §3.4 |"),
])

edit(ZH, [
    ("`Flow.favours_reaching_beyond`、`Flow.Balances.breaks_beyond`（",
     "`Flow.favours_reaching_beyond`（不加无所增益的前提时按包含族的流入分级：超过流入的上升有从其外汲取的构成，"
     "超过的部分全数取自其外，奖励它的选择偏向这一汲取，`Flow.favours_reaching_beyond_inflow`；无流入是其情形）、`Flow.Balances.breaks_beyond`（"),
    ("| [抬高所耦合者取自其外](../results/records/raising-what-couples-in-draws-from-beyond.md) | 不加前提的定理 | — | §3.4 |",
     "| [抬高所耦合者取自其外](../results/records/raising-what-couples-in-draws-from-beyond.md) | 不加前提的定理 | — | §3.4 |\n"
     f"| [超过流入的上升取自其外]({REC}{A}.md) | 不加前提的定理 | — | §3.4 |"),
    ("抽干与修订两个抽取者无下限；同时抽取时每份所回少于一对一 | §3.4、§7.1、§8.1 |",
     "抽干与修订两个抽取者无下限；同时抽取时每份所回少于一对一 | §3.4、§7.1、§8.1 |\n"
     f"| [争位次的轮流抽取者全部抽取]({REC}{P}.md) | 在所述前提下的定理 | `k` 个无下限的轮流抽取者，按其余各步上的位次排序；任一所立之律 "
     "`G`；抽干需 `G t 0 ≤ G t x` 且至少两个抽取者 | §3.4 |"),
])

old_race = OPENING.read_text().split('\n')
idx = [i for i, line in enumerate(old_race) if line.startswith('[^race]:')]
assert len(idx) == 1
KEEP = "In a balanced flow, let a family list every condition"
line = old_race[idx[0]]
assert line.count(KEEP) == 1
old_race[idx[0]] = line[:line.index(KEEP)] + (
    "In a balanced flow, let a family "
    "list every condition a member of a group couples into, inside a family containing it. Then every selection that holds only "
    "where the first family's stock rises across a step by more than the containing family's inflow (what the formations taking "
    "part give it beyond what they take from it), and does hold, holds only where some formation taking part gives that family "
    "more than it takes from it and takes from a condition no member of the group couples into "
    f"(`Flow.favours_reaching_beyond_inflow`, [record](results/records/{A}.md)). Where the containing family gains nothing, its "
    "inflow is zero and every rise counts (`Flow.favours_reaching_beyond`). The theorem finds some such formation, not "
    "necessarily the one rewarded: a selection that reads only the rise cannot tell who drew it. Whether a race raises what it "
    "rewards faster than what flows in renews what it draws on is the empirical question. That a race of position cannot raise "
    "everyone needs no premise: for any amounts and any change of them, some part's position does not rise "
    "(`RelativePosition.not_all_rise`, [record](results/records/relative-position-is-zero-sum.md)). That a race for position "
    "draws down is proved for drawers taking in turn: where what stands from nothing is at most what stands from anything left, "
    "every profile in which each drawer, at every step, leaves what places it highest draws everything at every step "
    f"(`Optimum.InTurn.position_perfect_ends`, [record](results/records/{P}.md)); where something left would stop what stands "
    "next, a drawer may keep it to stop it.")
PENDING[OPENING] = '\n'.join(old_race)

text = (HERE / 'study_if1_rp1.txt').read_text().replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
s = STUDY.read_text()
assert f'\n## {N}. ' not in s and f'\n## {N - 1}. ' in s, N
PENDING[STUDY] = s.rstrip('\n') + '\n\n' + text.rstrip('\n') + '\n'
for path, content in PENDING.items():
    path.write_text(content)
print('applied', N)
