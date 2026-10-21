#!/usr/bin/env python3
"""Build SG5's tree: the package's Becoming.Optimum with the law of what stands and what was drawn
generalized below SG4's (`level_add_drawn_of_within`, from each step leaving at most the level with
what is given; `level_add_drawn` its case), the root docstring's bullet for courses ranked over a
horizon, and the section of sg5_section.lean appended before the module's end.
usage: python3 -B build_tree.py   (SG5_ROOT names the checkout to read; default this repository)"""
import os
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG5_ROOT']).resolve() if os.environ.get('SG5_ROOT') else HERE.parents[5]
REL = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Optimum.lean'
s = (ROOT / REL).read_text(encoding='utf-8')
assert 'OpenCourse' not in s, 'already integrated'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


LEVEL_OLD = """/-- **What stands and what was drawn.** Across `n` steps, what stands after with everything drawn
is the starting level with everything given (sums of `Amounts.whole`). -/
theorem level_add_drawn (step : ∀ t, x (t + 1) = x t + g t - d t) :
    ∀ n, x n + Amounts.whole.sum (drawnAt x g) 0 n = x 0 + Amounts.whole.sum g 0 n
  | 0 => rfl
  | n + 1 => by
    show x (n + 1) + (Amounts.whole.sum (drawnAt x g) 0 n + drawnAt x g (0 + n)) =
      x 0 + (Amounts.whole.sum g 0 n + g (0 + n))
    rw [Nat.zero_add]
    have back : x (n + 1) + drawnAt x g n = x n + g n :=
      Naturals.add_sub_of_le (show x (n + 1) ≤ x n + g n by rw [step n]; exact Nat.sub_le _ _)
    rw [Nat.add_left_comm, back, ← Nat.add_assoc, Nat.add_comm (Amounts.whole.sum _ 0 n) (x n),
      level_add_drawn step n, Nat.add_assoc]
"""
LEVEL_NEW = """/-- **What stands and what was drawn.** Where each step leaves at most the level with what is
given, across `n` steps what stands after with everything drawn is the starting level with
everything given (sums of `Amounts.whole`). -/
theorem level_add_drawn_of_within (within : ∀ t, x (t + 1) ≤ x t + g t) :
    ∀ n, x n + Amounts.whole.sum (drawnAt x g) 0 n = x 0 + Amounts.whole.sum g 0 n
  | 0 => rfl
  | n + 1 => by
    show x (n + 1) + (Amounts.whole.sum (drawnAt x g) 0 n + drawnAt x g (0 + n)) =
      x 0 + (Amounts.whole.sum g 0 n + g (0 + n))
    rw [Nat.zero_add]
    have back : x (n + 1) + drawnAt x g n = x n + g n := Naturals.add_sub_of_le (within n)
    rw [Nat.add_left_comm, back, ← Nat.add_assoc, Nat.add_comm (Amounts.whole.sum _ 0 n) (x n),
      level_add_drawn_of_within within n, Nat.add_assoc]

/-- **What stands and what was drawn** along a course whose steps take `d`: the case of
`level_add_drawn_of_within`. -/
theorem level_add_drawn (step : ∀ t, x (t + 1) = x t + g t - d t) :
    ∀ n, x n + Amounts.whole.sum (drawnAt x g) 0 n = x 0 + Amounts.whole.sum g 0 n :=
  level_add_drawn_of_within fun t => by rw [step t]; exact Nat.sub_le _ _
"""
s = once(s, LEVEL_OLD, LEVEL_NEW)

BULLET_OLD = """  (`Renewing.restrained_course_not_best`, `Renewing.restraint_holds_more`).
"""
BULLET_NEW = BULLET_OLD + """* **Courses ranked over a horizon.** Where each step leaves at most the level with what is given
  and at most `r` is given at each step, what a course draws, what it leaves and everything the
  renewal falls short of `r` add to the starting level with `r` for each step
  (`Optimum.drawn_add_shortfall`, `Flow.Balances.taken_add_shortfall`); so of two balanced courses
  from one level, one takes at most what the other takes exactly where the other forgoes and leaves
  at most what the one does (`Flow.Balances.taken_le_iff`), and two given alike and ending alike
  take the same, whatever levels they pass through (`Flow.Balances.taken_eq_of_alike`). Where what
  is given is a law `R` of the level, a course draws across `n + 1` steps at most the start with
  what is given there and `r` for each step after (`Optimum.drawn_le_most`), exactly where it stands
  at a level where `R` gives `r` at every step to the `n`-th and leaves nothing after the last
  (`Optimum.most_iff`). Where such a level is within reach and the capacity, over at least two
  steps, every optimum of every order rising with what is drawn is such a course
  (`Optimum.frontier_holds`): it breaks at the first step a dependence whose need lies above every
  level of greatest renewal and leaves it unmet through the horizon (`Web.frontier_broken`), and
  keeps one that every such level meets through the horizon, breaking it at its end
  (`Web.frontier_kept`). `Holding` is the instance: from the level a dweller needs, under the
  logistic law `s (2 - s)`, the course holding the source at one, where the law renews most, is an
  optimum and breaks the dweller at the first step (`Holding.logistic_broken`); under a gate
  renewing one unit at every level from one, the courses holding the source at the dweller's need
  and below it are both optima and take the same (`Holding.gated_alike`).
"""
s = once(s, BULLET_OLD, BULLET_NEW)

READING_OLD = """at the renewal draws; where it does not, the draw goes on without bound after the dependence is
lost.
"""
READING_NEW = """at the renewal draws; where it does not, the draw goes on without bound after the dependence is
lost. Ranking whole courses changes when, not whether: what a course draws, leaves and forgoes is
conservation over the horizon, so what a course draws registers its levels only through what is
renewed there, and every optimum of a far-sighted order rising with it holds a level of greatest
renewal, the maximum sustainable yield's level (half of room in the logistic law; Schaefer 1954), as
a sole owner does (Scott 1955), and draws everything at its horizon, the end of a finite-horizon
harvest (Clark 1976); a dependence beyond needing more than
those levels is lost at the first step however far the horizon, as single-species management leaves
predators of a forage stock uncounted (Pikitch and others 2012).
"""
s = once(s, READING_OLD, READING_NEW)

NOT_OLD = """covered); over a course, a renewal varying with the level at or above the need (one growing with
the level, as in logistic growth, is not stated), an optimizer ranking courses rather than steps,
and how optimizers come to a mutual best response; for several optimizers,"""
NOT_NEW = """covered); over a course, against a renewal varying with the level, the optimum where a level of
greatest renewal is out of reach or the capacity cannot draw down to it in one step or draw
everything at the horizon's last step, an order valuing what is left or earlier draws more (a
terminal value or a discount), several optimizers ranking courses, and how optimizers come to a
mutual best response; for several optimizers,"""
s = once(s, NOT_OLD, NOT_NEW)

sec = (HERE / 'sg5_section.lean').read_text(encoding='utf-8')
tail = '\nend Becoming\n'
assert s.endswith(tail)
s = s[:-len(tail)] + '\n' + sec.rstrip('\n') + '\n' + tail
out = HERE / 'tree/Becoming/Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(s, encoding='utf-8')
print('wrote', out, len(s.splitlines()), 'lines')
