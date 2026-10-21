#!/usr/bin/env python3
"""Build SG6's tree: the package's Becoming.Optimum with SG5's identity generalized below (the bound on
what is given needed only at the steps counted: `sum_add_shortfall_up_to`, read off SG5's
`sum_add_shortfall` for what is given at those steps and nothing after; `drawn_add_shortfall_up_to`,
`drawn_add_shortfall_after_up_to`, SG5's two laws their cases) and its holding course generalized
below (`holdingTo`, ending at any level at most the one held; `holding` the course ending at nothing,
its laws cases), SG5's two docstrings saying what is drawn rather than every order rising with it, the
root docstring's bullet and reading for what keeping forgoes, and the section of sg6_section.lean
appended before the module's end.
usage: python3 -B build_tree.py   (SG6_ROOT names the checkout to read, one whose Optimum is SG5's; default this
repository)"""
import os
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG6_ROOT']).resolve() if os.environ.get('SG6_ROOT') else HERE.parents[5]
REL = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Optimum.lean'
s = (ROOT / REL).read_text(encoding='utf-8')
assert 'holdingTo' not in s, 'already integrated'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def block(text, doc, head):
    """The docstring starting with `doc` through the end of the declaration starting with `head`."""
    assert text.count(doc) == 1 and text.count(head) == 1, (doc[:60], head)
    i = text.index(doc)
    j = text.index('\n\n', text.index(head, i))
    return text[i:j]


SUM_OLD = block(s, '/-- **What is given and what it falls short of.**', 'theorem sum_add_shortfall ')
SUM_NEW = SUM_OLD + """

/-- **What is given and what it falls short of, at the steps counted.** Where at most `r` is given at
each of `n` steps, everything given across them, with everything it falls short of `r`, is `r` for
each step: `sum_add_shortfall` for what is given at those steps and nothing after. -/
theorem sum_add_shortfall_up_to {n : Nat} (renews : ∀ t, t < n → g t ≤ r) :
    Amounts.whole.sum g 0 n + Amounts.whole.sum (fun t => r - g t) 0 n = r * n := by
  have given : Amounts.whole.sum g 0 n =
      Amounts.whole.sum (fun t => if t < n then g t else 0) 0 n :=
    sum_eq_of_eq fun _ lt => (if_pos lt).symm
  have short : Amounts.whole.sum (fun t => r - g t) 0 n =
      Amounts.whole.sum (fun t => r - if t < n then g t else 0) 0 n :=
    sum_eq_of_eq fun _ lt => congrArg (r - ·) (if_pos lt).symm
  rw [given, short]
  exact sum_add_shortfall (g := fun t => if t < n then g t else 0) (fun t => by
    show (if t < n then g t else 0) ≤ r
    match Nat.lt_or_ge t n with
    | .inl lt => rw [if_pos lt]; exact renews t lt
    | .inr ge => rw [if_neg (Nat.not_lt_of_ge ge)]; exact Nat.zero_le r) n"""
s = once(s, SUM_OLD, SUM_NEW)

DRAWN_NEW = """/-- **What a course draws, leaves and forgoes.** Where each step leaves at most the level with what
is given and at most `r` is given at each of `n` steps, what is drawn across them, with what stands
after them and everything the renewal falls short of `r`, is the starting level with `r` for each
step. -/
theorem drawn_add_shortfall_up_to (within : ∀ t, x (t + 1) ≤ x t + g t) {n : Nat}
    (renews : ∀ t, t < n → g t ≤ r) :
    Amounts.whole.sum (drawnAt x g) 0 n + x n + Amounts.whole.sum (fun t => r - g t) 0 n =
      x 0 + r * n := by
  rw [Nat.add_comm (Amounts.whole.sum (drawnAt x g) 0 n), level_add_drawn_of_within within n,
    Nat.add_assoc, sum_add_shortfall_up_to renews]

/-- **What a course draws, leaves and forgoes**, where at most `r` is given at every step: the case
of `drawn_add_shortfall_up_to`. -/
theorem drawn_add_shortfall (within : ∀ t, x (t + 1) ≤ x t + g t) (renews : ∀ t, g t ≤ r)
    (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 n + x n + Amounts.whole.sum (fun t => r - g t) 0 n =
      x 0 + r * n :=
  drawn_add_shortfall_up_to within fun t _ => renews t"""
s = s.replace(block(s, '/-- **What a course draws, leaves and forgoes.**', 'theorem drawn_add_shortfall '),
              DRAWN_NEW)

AFTER_NEW = """/-- **What a course draws after its first step, leaves and forgoes.** Where each step leaves at most
the level with what is given and at most `r` is given at each of the `n` steps after the first,
what is drawn across `n + 1` steps, with what stands after them and everything the renewal falls
short of `r` at those steps, is the starting level with what is given at the first step and `r` for
each step after. -/
theorem drawn_add_shortfall_after_up_to (within : ∀ t, x (t + 1) ≤ x t + g t) {n : Nat}
    (renews : ∀ t, t < n → g (t + 1) ≤ r) :
    Amounts.whole.sum (drawnAt x g) 0 (n + 1) + x (n + 1) +
        Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = x 0 + g 0 + r * n := by
  have later : Amounts.whole.sum (fun t => drawnAt x g (t + 1)) 0 n + x (n + 1) +
      Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = x 1 + r * n :=
    drawn_add_shortfall_up_to (x := fun t => x (t + 1)) (g := fun t => g (t + 1))
      (fun t => within (t + 1)) renews
  have first : x 1 + drawnAt x g 0 = x 0 + g 0 := Naturals.add_sub_of_le (within 0)
  rw [sum_succ_first, Nat.add_assoc (drawnAt x g 0), Nat.add_assoc (drawnAt x g 0), later,
    ← Nat.add_assoc, Nat.add_comm (drawnAt x g 0), first]

/-- **What a course draws after its first step, leaves and forgoes**, where at most `r` is given at
every step: the case of `drawn_add_shortfall_after_up_to`. -/
theorem drawn_add_shortfall_after (within : ∀ t, x (t + 1) ≤ x t + g t)
    (renews : ∀ t, g t ≤ r) (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 (n + 1) + x (n + 1) +
        Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = x 0 + g 0 + r * n :=
  drawn_add_shortfall_after_up_to within fun t _ => renews (t + 1)"""
s = s.replace(block(s, '/-- **What a course draws after its first step, leaves and forgoes.**',
                    'theorem drawn_add_shortfall_after '), AFTER_NEW)

HOLD_OLD_START = '/-- From `s`, the course standing at `y` from the first step to the `n`-th and at nothing after. -/'
HOLD_OLD = s[s.index(HOLD_OLD_START):s.index('\n\n', s.index('theorem holding_within'))]
assert s.count(HOLD_OLD_START) == 1 and 'variable {R : Nat → Nat} {k r s y n : Nat}' in HOLD_OLD
HOLD_NEW = """/-- From `s`, the course standing at `y` from the first step to the `n`-th and at `e` after. -/
def holdingTo (s y e n : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => if t < n then y else e

/-- From `s`, the course standing at `y` from the first step to the `n`-th and at nothing after: the
course holding `y` and ending at nothing. -/
def holding (s y n : Nat) : Nat → Nat := holdingTo s y 0 n

variable {R : Nat → Nat} {k r s y e n : Nat}

/-- The course holding `y` stands there from the first step to the `n`-th. -/
theorem holdingTo_before {t : Nat} (before : t < n) : holdingTo s y e n (t + 1) = y :=
  if_pos before

/-- The course holding `y` and ending at `e` stands at `e` after the `n`-th step. -/
theorem holdingTo_after {t : Nat} (after : n ≤ t) : holdingTo s y e n (t + 1) = e :=
  if_neg (Nat.not_lt_of_ge after)

/-- After its start, the course holding `y` and ending at `e` at most `y` stands at `e` or above. -/
theorem holdingTo_ge (settles : e ≤ y) (t : Nat) : e ≤ holdingTo s y e n (t + 1) :=
  match Nat.lt_or_ge t n with
  | .inl before => Nat.le_trans settles (Nat.le_of_eq (holdingTo_before before).symm)
  | .inr after => Nat.le_of_eq (holdingTo_after after).symm

/-- Each step of the course holding `y` and ending at `e` at most `y` leaves at most the level with
what is given, where `y` is within the start with what is given there. -/
theorem holdingTo_within (reach : y ≤ s + R s) (settles : e ≤ y) :
    ∀ t, holdingTo s y e n (t + 1) ≤ holdingTo s y e n t + R (holdingTo s y e n t)
  | 0 => match Nat.lt_or_ge 0 n with
    | .inl lt => Nat.le_trans (Nat.le_of_eq (holdingTo_before lt)) reach
    | .inr ge => Nat.le_trans (Nat.le_of_eq (holdingTo_after ge)) (Nat.le_trans settles reach)
  | t + 1 => match Nat.lt_or_ge (t + 1) n with
    | .inl lt => Nat.le_trans (Nat.le_of_eq ((holdingTo_before lt).trans
        (holdingTo_before (Nat.lt_of_succ_lt lt)).symm)) (Nat.le_add_right _ _)
    | .inr ge => Nat.le_trans (Nat.le_of_eq (holdingTo_after ge))
        (Nat.le_trans (holdingTo_ge settles t) (Nat.le_add_right _ _))

/-- The holding course stands at `y` from the first step to the `n`-th. -/
theorem holding_before {t : Nat} (before : t < n) : holding s y n (t + 1) = y :=
  holdingTo_before before

/-- The holding course stands at nothing after the `n`-th step. -/
theorem holding_after {t : Nat} (after : n ≤ t) : holding s y n (t + 1) = 0 :=
  holdingTo_after after

/-- Each step of the holding course leaves at most the level with what is given, where `y` is
within the start with what is given there. -/
theorem holding_within (reach : y ≤ s + R s) (n : Nat) :
    ∀ t, holding s y n (t + 1) ≤ holding s y n t + R (holding s y n t) :=
  holdingTo_within reach (Nat.zero_le y)"""
s = once(s, HOLD_OLD, HOLD_NEW)

OPEN_OLD = block(s, '/-- **The holding course is open**', 'theorem holding_open')
OPEN_NEW = """/-- What a step draws is at most `k` where the level with what is given is at most the level after
with `k`. -/
theorem drawnAt_le_of {a b c k : Nat} (le : a + b ≤ c + k) : a + b - c ≤ k :=
  Nat.le_trans (sub_le_sub_right_of_le le c) (Nat.le_of_eq (Naturals.add_sub_cancel_left c k))

/-- **The steps of the course holding `y` and ending at `e` within the horizon.** Over a horizon of
at least two steps, with a capacity covering what the first step draws down to `y` and `y` with `r`
down to `e`, each step to the `n`-th leaves at most the level with what is given and draws at most
`k`. -/
theorem holdingTo_steps (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ e + k) (long : 0 < n) :
    ∀ t, t ≤ n → holdingTo s y e n (t + 1) ≤ holdingTo s y e n t + R (holdingTo s y e n t) ∧
      drawnAt (holdingTo s y e n) (fun t => R (holdingTo s y e n t)) t ≤ k
  | 0, _ => ⟨holdingTo_within reach settles 0, drawnAt_le_of (Nat.le_trans drawsDown
      (Nat.le_of_eq (congrArg (· + k) (holdingTo_before long).symm)))⟩
  | t + 1, le => ⟨holdingTo_within reach settles (t + 1), drawnAt_le_of (by
      show holdingTo s y e n (t + 1) + R (holdingTo s y e n (t + 1)) ≤
        holdingTo s y e n (t + 1 + 1) + k
      rw [holdingTo_before (Nat.lt_of_succ_le le), greatest]
      match Nat.lt_or_ge (t + 1) n with
      | .inl lt =>
        rw [holdingTo_before lt]
        exact Nat.le_trans holds (Nat.add_le_add_right settles k)
      | .inr ge =>
        rw [holdingTo_after ge]
        exact holds)⟩

/-- **The course holding `y` and ending at `e` is open**, over a horizon of at least two steps, with
a capacity covering what the first step draws down to `y`, `y` with `r` down to `e`, and what is
given at `e`. -/
theorem holdingTo_open (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ e + k) (rests : R e ≤ k) (long : 0 < n) :
    OpenCourse R k s (holdingTo s y e n) :=
  ⟨rfl, fun t => match Nat.lt_or_ge t (n + 1) with
    | .inl lt =>
      holdingTo_steps greatest reach settles drawsDown holds long t (Nat.le_of_lt_succ lt)
    | .inr ge => ⟨holdingTo_within reach settles t, match t, ge with
      | 0, ge => absurd ge (Nat.not_succ_le_zero n)
      | j + 1, ge => drawnAt_le_of (by
          show holdingTo s y e n (j + 1) + R (holdingTo s y e n (j + 1)) ≤
            holdingTo s y e n (j + 1 + 1) + k
          rw [holdingTo_after (Nat.le_of_succ_le_succ ge),
            holdingTo_after (Nat.le_succ_of_le (Nat.le_of_succ_le_succ ge))]
          exact Nat.add_le_add_left rests e)⟩⟩

/-- **The holding course is open**, over a horizon of at least two steps, with a capacity covering
what the first step draws down to `y` and `y` with `r`: the case of `holdingTo_open` ending at
nothing. -/
theorem holding_open (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ k) (long : 0 < n) :
    OpenCourse R k s (holding s y n) :=
  holdingTo_open greatest reach (Nat.zero_le y) drawsDown
    (Nat.le_trans holds (Nat.le_of_eq (Nat.zero_add k).symm))
    (Nat.le_trans (renews 0) (Nat.le_trans (Nat.le_add_left r y) holds)) long"""
s = once(s, OPEN_OLD, OPEN_NEW)

# SG5's section comment and taken_le_iff docstring: what is drawn, not every order rising with it.
s = once(s, """everything the renewal falls short of `r` add to the starting level with `r` for each step; so an
order rising with what is drawn ranks courses exactly by the renewal they forgo and what they leave,
and a level registers in it only through what is given there.""",
         """everything the renewal falls short of `r` add to the starting level with `r` for each step; so
what is drawn ranks courses exactly as the renewal they forgo with what they leave does, reversed,
and registers a level only through what is given there.""")
s = once(s, """falls short of `r` is at most the first's: an order rising with what is taken registers the levels
a course passes through only through what is given at them. -/""",
         """falls short of `r` is at most the first's: what is taken registers the levels a course passes
through only through what is given at them. -/""")

BULLET_OLD = """  and below it are both optima and take the same (`Holding.gated_alike`).
"""
BULLET_NEW = BULLET_OLD + """* **What keeping a dependence forgoes.** Where what is given at every level at or above a need `m`
  is at most `q`, what a course keeping the condition at `m` or above through the horizon draws,
  with what it leaves, is at most the start with what is given there and `q` for each step after
  (`Optimum.keeping_le_most`, `Flow.Balances.keeping_taken_le`); among the courses keeping it,
  every optimum of every order rising with what is drawn holds a level where `q` is given and
  leaves exactly `m` (`Optimum.frontier_keeps`, `Web.frontier_keeps`), and the course holding such
  a level is one (`Optimum.continued_keeping_frontier`). So keeping forgoes, against the course
  holding a level of greatest renewal `r` and leaving nothing, `(r - q) n + m`: under an order
  adding to what a keeping course draws a coupling below that, every optimum falls below the need
  within the horizon, breaking the dependence (`Optimum.frontier_breaks_below`,
  `Web.frontier_breaks_below`); under one adding more to a keeping course and nothing to a course
  falling below the need, every optimum keeps it (`Optimum.frontier_keeps_above`,
  `Web.frontier_keeps_above`); and for a coupling of exactly `w` both have optima
  (`Optimum.continued_breaking_frontier`, `Optimum.continued_kept_frontier`). Where the capacity
  cannot draw down to nothing or to the need, the end it reaches enters the thresholds. Where the
  need lies above every level of greatest renewal, `q < r`, what keeping forgoes grows with the
  horizon, and every coupling below the horizon with the need is outweighed
  (`Optimum.forgone_grows`, `Web.frontier_breaks_long`). The courses attaining these bounds draw
  nothing after the horizon (`Optimum.continued`), so nothing is supposed beyond it; the identity
  and the holding course of the section above are generalized below it
  (`drawn_add_shortfall_after_up_to`, `holdingTo`). `Holding.logistic_coupled` is the instance:
  from the level the dweller needs, under the logistic law, keeping the dweller through `n + 2`
  steps forgoes `n + 3`, and the order by what the taker draws with a coupling `w` of the dweller
  has optima, all breaking it below that and all keeping it above.
"""
s = once(s, BULLET_OLD, BULLET_NEW)

READING_OLD = """predators of a forage stock uncounted (Pikitch and others 2012).
"""
READING_NEW = """predators of a forage stock uncounted (Pikitch and others 2012). What keeping such a dependence
forgoes is exact: the renewal given up at the need for each step and the need left at the end, so a
coupling of the dependence decides the optimum at that amount, and where the need lies above every
level of greatest renewal the amount grows with the horizon: the yield forgone by holding a stock
for what depends on it, the ecosystem constraint on a single-species yield, is no fixed sum, and a
far-sighted optimizer's gain from breaking the dependence grows with how far it sees.
"""
s = once(s, READING_OLD, READING_NEW)

sec = (HERE / 'sg6_section.lean').read_text(encoding='utf-8')
tail = '\nend Becoming\n'
assert s.endswith(tail)
s = s[:-len(tail)] + '\n' + sec.rstrip('\n') + '\n' + tail
out = HERE / 'tree/Becoming/Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(s, encoding='utf-8')
print('wrote', out, len(s.splitlines()), 'lines')
