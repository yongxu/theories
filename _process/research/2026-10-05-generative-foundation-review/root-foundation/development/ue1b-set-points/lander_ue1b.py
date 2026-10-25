#!/usr/bin/env python3
"""UE1b, the lander's two edits that texts_ue1b.py leaves out (LANDING §3 and §4):
- 05, thesis T3: the scope of the forbidden side-effect term, which concerns rewards rising with what they read; counted
  after an order with a plateau, a set point or an aspiration level, such a term decides within the plateau;
- UE1's NOTE-CORRECTIONS §2, restated in the landed names (no record cites that file; UE1's record cites NOTE.md).
Run after texts_ue1b.py, which writes the anchor r-what-a-set-point-optimum-does-beyond. Every edit asserts it applies
exactly once.
usage (from the checkout root of the landing worktree): python3 -B <kit>/lander_ue1b.py"""
from pathlib import Path

ROOT = Path.cwd()
CH5 = ROOT / 'theories/becoming/chapters/05-COLLECTIVES.md'
CORR = ROOT / ('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
               'ue1-fep-bridge/NOTE-CORRECTIONS.md')


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


assert CH5.read_text(encoding='utf-8').count('<a id="r-what-a-set-point-optimum-does-beyond"></a>') == 1, \
    'run texts_ue1b.py first'

# 05, T3: the scope of the side-effect clause, after Forbids
edit(CH5, """an instruction that does not bring a dependent into what the learners couple into, yet keeps it more often than the same learners without the instruction.
- *Refuted by.*""", """an instruction that does not bring a dependent into what the learners couple into, yet keeps it more often than the same learners without the instruction.
- *Scope of the side-effect clause.* It concerns rewards rising with what they read. Counted after an order with a plateau, a set point or an aspiration level, such a term decides within the plateau, and there it keeps what it counts ([the set-point law](#r-what-a-set-point-optimum-does-beyond)); that is no counterexample, since the reward does not rise there.
- *Refuted by.*""")

# UE1's NOTE-CORRECTIONS §2, in the landed names
text = CORR.read_text(encoding='utf-8')
start = text.index('## 2. The chooser with set points (NOTE §5, reading 3)')
end = text.index('## 3. The third part (NOTE §7(b))')
old = text[start:end]
assert text.count(old) == 1
new = """## 2. The chooser with set points (NOTE §5, reading 3)

**As written:** where the step can lose what it takes, "nothing protects what lies beyond", and a term counted after the set point "keeps the most beyond"; joint excess "holds for choosers held at set points".

**Corrected** (UE1b's [review](../ue1b-set-points/REVIEW-UE1b.md) and the landed kit, `Becoming.SetPointOptimum`, record [what-a-set-point-optimum-does-beyond](../../../../../../theories/becoming/results/records/what-a-set-point-optimum-does-beyond.md)):

- Where the family holds a condition, no asymmetric order nearing a set point is rising (`Optimum.Nearing.not_rising`), so the optimum law does not reach it as stated. Below its set point it rises, and its optima drain as a maximizer's do (`Optimum.least_below`, `Optimum.nearing_beyond`).
- Where the set point can be reached, every optimum stands at it, and nearing alone asks nothing more of what lies beyond (`Optimum.optima_iff`). In a balanced step in which the whole gains nothing, what lies beyond falls by the family's shortfall from its set point with the loss (`Flow.Balances.atSetPoint_draws`).
- Where the step can lose what it takes, the set point alone does not protect what lies beyond: the order by distance has the draining step among its optima, beside the keeping one (`Topped.nearing_either`). A term on what lies beyond, counted after the set point, does protect it there (`Topped.counted_after_keeps`).
- That term leaves what lies beyond, in total, at the most any eligible way of reaching the set point leaves (`Optimum.counted_after_most`). With several conditions beyond, it can empty one of them (`Spread.counted_after_empties`). Counting less, it drains (`Topped.counted_less_drains`). After an aspiration level it keeps too (`Drain.satisficingThen_keeps`). What protects is how the choice among equal optima is made, not the set point.
- A formation holding its family's stock, by any means, takes at least its loss from what feeds it (`Flow.held_draws`), and joint excess applies to any such holders (`Flow.held_excess_ends`). That the holders are set-point choosers re-optimizing at every step is a reading.

"""
CORR.write_text(text.replace(old, new), encoding='utf-8')
print('lander: 05 T3 scope of the side-effect clause; NOTE-CORRECTIONS §2 in the landed names')
