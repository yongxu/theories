#!/usr/bin/env python3
"""Build SG7's tree: the package's Becoming.Optimum (SG6's) with SG6's `keeps_or_drops` read off a law recording
every step met before the fall (`keeps_or_falls`, generalized below), the root docstring's bullet and reading for a
coupling added step by step, and the section of sg7_section.lean appended before the module's end.
usage: python3 -B build_tree.py   (SG7_ROOT names the checkout to read, one whose Optimum is SG6's; default this
repository)"""
import os
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG7_ROOT']).resolve() if os.environ.get('SG7_ROOT') else HERE.parents[5]
REL = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Optimum.lean'
s = (ROOT / REL).read_text(encoding='utf-8')
assert 'metRun' not in s and 'holdingTo' in s, 'not SG6\'s Optimum'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def block(text, doc, head):
    """The docstring starting with `doc` through the end of the declaration starting with `head`."""
    assert text.count(doc) == 1 and text.count(head) == 1, (doc[:60], head)
    i = text.index(doc)
    j = text.index('\n\n', text.index(head, i))
    return text[i:j]


DROPS_OLD = block(s, '/-- A course from a start meeting `m` either keeps its level at `m` or above through the `n + 1`',
                  'theorem keeps_or_drops')
DROPS_NEW = """/-- **A course keeps a need or falls after meeting it.** A course from a start meeting `m` either
keeps its level at `m` or above through the `n + 1` steps of a horizon or falls below `m`, at some
step to the `n`-th, after standing at `m` or above at every step to it. -/
theorem keeps_or_falls {x : Nat → Nat} (start : m ≤ x 0) :
    ∀ n, Keeps m n x ∨ ∃ t, t ≤ n ∧ (∀ u, u ≤ t → m ≤ x u) ∧ x (t + 1) < m
  | 0 => match Nat.lt_or_ge (x 1) m with
    | .inl lt => .inr ⟨0, Nat.le_refl 0, fun u le => Eq.subst (motive := fun z => m ≤ x z)
        (Nat.le_antisymm le (Nat.zero_le u)).symm start, lt⟩
    | .inr ge => .inl fun t le => match le_or_eq_succ le with
      | .inl first => Eq.subst (motive := fun z => m ≤ x z)
          (Nat.le_antisymm first (Nat.zero_le t)).symm start
      | .inr second => Eq.subst (motive := fun z => m ≤ x z) second.symm ge
  | n + 1 => match keeps_or_falls start n with
    | .inr ⟨t, le, met, lt⟩ => .inr ⟨t, Nat.le_succ_of_le le, met, lt⟩
    | .inl keeps => match Nat.lt_or_ge (x (n + 1 + 1)) m with
      | .inl lt => .inr ⟨n + 1, Nat.le_refl _, keeps, lt⟩
      | .inr ge => .inl fun t le => match le_or_eq_succ le with
        | .inl earlier => keeps t earlier
        | .inr last => Eq.subst (motive := fun z => m ≤ x z) last.symm ge

/-- A course from a start meeting `m` either keeps its level at `m` or above through the `n + 1`
steps of a horizon or falls below `m`, at some step to the `n`-th, from a level meeting it: the
case of `keeps_or_falls`. -/
theorem keeps_or_drops {x : Nat → Nat} (start : m ≤ x 0) (n : Nat) :
    Keeps m n x ∨ ∃ t, t ≤ n ∧ m ≤ x t ∧ x (t + 1) < m :=
  (keeps_or_falls start n).imp id fun ⟨t, le, met, lt⟩ => ⟨t, le, met t (Nat.le_refl t), lt⟩"""
s = once(s, DROPS_OLD, DROPS_NEW)

BULLET_OLD = '  has optima, all breaking it below that and all keeping it above.\n'
BULLET_NEW = BULLET_OLD + """* **A coupling added for each step a dependence is kept.** A course standing at a need `m` or
  above at every step to the `j`-th draws across the horizon, with `r` for each of those steps, at
  most the start with what is given there, `r` a step and `q` for each of those steps
  (`Optimum.met_drawn_le`, from `Optimum.shortfall_ge`; `Flow.Balances.met_taken_le`): each met step
  forgoes at least `r - q`. So under an order adding `c` for each step the need stays met from the
  start, every optimum keeps it through the horizon where `c` covers the renewal forgone a step and
  exceeds the end the keeping course can reach, `r ≤ q + c` and `e < c`, whatever the horizon
  (`Optimum.frontier_keeps_stepwise`, `Web.frontier_keeps_stepwise`); where `c` with the end
  reached is below the need, every optimum falls below it within the horizon
  (`Optimum.frontier_breaks_at_end`, `Web.frontier_breaks_at_end`), and where `c` also exceeds the
  renewal forgone a step, `r < q + c`, every optimum meets the need at every step but the last and
  breaks it there alone, drawing the need itself: the end does not reach back
  (`Optimum.frontier_met_before_end`, `Web.frontier_met_before_end`, `Web.frontier_breaks_last`);
  and where `q + c < r` the coupling is at most `c` a step and a long horizon outweighs it
  (`Optimum.outweighed_stepwise`, `Web.frontier_breaks_stepwise_long`). Optima exist in every
  case (`Optimum.continued_stepwise_frontier`, `Optimum.continued_ending_stepwise_frontier`,
  `Optimum.continued_holding_stepwise_frontier`). The instance `Holding.logistic_stepwise`: under
  the logistic law a coupling of three a step keeps the dweller at every horizon, where a coupling
  of the whole keeping must exceed `n + 3`; one of two a step keeps it to the horizon's last step;
  one of at most one a step breaks it.
"""
s = once(s, BULLET_OLD, BULLET_NEW)

READING_OLD = "far-sighted optimizer's gain from breaking the dependence grows with how far it sees.\n"
READING_NEW = ("far-sighted optimizer's gain from breaking the dependence grows with how far it sees. A coupling\n"
               "added for each step the dependence is kept does not erode so: at the renewal forgone a step and\n"
               "above the need it keeps the dependence at every horizon, and below the need the horizon's end\n"
               "breaks it, at the last step alone where the coupling exceeds the renewal forgone a step.\n")
s = once(s, READING_OLD, READING_NEW)

END = '\nend Becoming\n'
assert s.endswith(END)
section = (HERE / 'sg7_section.lean').read_text(encoding='utf-8')
s = s[:-len(END)] + '\n' + section.rstrip('\n') + '\n' + END
out = HERE / 'tree' / 'Becoming' / 'Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(s, encoding='utf-8')
print('wrote', out, len(s.splitlines()), 'lines')
