import Becoming.DrawnShaping

/-!
# The loss read in time by the others, joined to the critical mass (board item MA4b)

`Becoming.DrawnShaping` (MA4) leaves the way out of the lock open: with the readers drawn from the
selected and `lo ≤ hi`, every course from a start under the rule read there, read from the share
alone, is locked one way or the other (`DrawnShaping.drawn_locked_either`), so leaving needs a
reading beyond the share. `ClosedCapture.Thinned` (MA2) gives one: the others among the readers read
the loss once it reaches a bound. This module joins the two.

* **The rule read once the others read the loss.** The shapers among the readers read the rule
  after shaping with `hi` coming back to the shapers, whatever the loss; the others read it with
  `lo` while the loss is below `N` and with `lo'` from then on, all with the same `a`, `p` and `c`
  (`shapedLossPool`, MA2's `Thinned.lossPool` over three of MA3's rules after shaping). Once the
  loss has reached the bound, the rule read at a share is MA4's rule read with `lo'`, the late
  reading (`Thinned.lossPool_past`, `Thinned.rule_read`), whose verdict
  `DrawnShaping.drawn_favours_iff` gives. As in MA3 and MA4, `favours` and `disfavours` are weak.
* **Kept, exactly.** Where every step adds at least one to the loss (`Accrues`): at a reading step
  at which the loss has reached its bound and the rule in force favours the shapers, `lo' ≤ hi`, the
  course is locked for good from the next step exactly where
  `x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo'` at the share there (`kept_iff`).
  No mirror premise enters, as one does in `Thinned.kept_iff`.
* **Turned, exactly, one step late.** Where every step adds at least one to the loss: at a reading
  step at which the loss has reached its bound, `lo' ≤ hi`, where the late reading favours the
  others at the share there (ties included) and the next step reads too, the course is locked the
  other way for good from two steps after the reading exactly where the late reading favours the
  others at the share one step after it (`turned_iff`). That share was selected under the rule in
  force at the reading step: where that rule still favoured the shapers, the reading must come one
  step before the share alone would say. The lag is the representation's: a rule read at a step is
  in force from the next.
* **Before the bound, MA4's course.** With the loss starting at zero and growing by one a step, the
  joined course up to step `N` is MA4's (`early`), the loss at step `t` being `t`, and so is the
  share at step `N + 1` (`next_share`).
* **The window, in MA4's course.** From a start the rule read there favours, `lo ≤ hi` and
  `lo' ≤ hi`, the others reading the loss from step `N`, a reading step: the course is locked in the
  shapers' favour for good from step `N + 1` exactly where the late reading favours them at the
  share of step `N` of MA4's course (`kept_early_iff`); with step `N + 1` reading too, it is locked
  the other way for good from step `N + 2` exactly where the late reading favours the others (ties
  included) at the share of step `N + 1` (`turned_early_iff`). Along MA4's course the late reading
  never falls (`late_never_falls`), so, with the rule read at steps `N` and `N + 1`, the steps from
  which a reading turns the course come first (`in_time_earlier`) and those from which it keeps the
  lock come last (`kept_once_favoured`), ties aside, where both hold; and at most one step lies
  between: the step at which the late reading favours the others strictly at its share and the
  shapers strictly at the next (`at_most_one_between`, which needs only `lo ≤ hi`). From that step
  neither law decides: the rule in force favours the others for one step, and the course starts a
  new round, to which `kept_iff` and `turned_iff` apply again from step `N + 2`
  (`kept_next_round_iff`). The round can go either way: in the witness the course read from the step
  between is locked in the shapers' favour again from step 6 (`Window.too_late`), and from one shaper
  to three others it is turned for good (`Between.turned`).
* **Once favoured, every later reading keeps the lock.** From a start the rule read there favours,
  `lo ≤ hi` and `lo' ≤ hi`: where the late reading would favour the shapers at a step `s` of MA4's
  course, the others reading the loss from any reading step `s + d` leave the course locked in the
  shapers' favour at every step from `s + d + 1` (`kept_once_favoured`). So, ties aside, their
  reading can turn the course only if it comes before the first step at which their late reading
  would favour the shapers.
* **The least reading of this form.** Where the late reading with nothing read as coming back
  favours the shapers, every late reading of this form does, whatever `lo'` (`least`); with
  `c ≤ hi` that is exactly where `x.other * c ≤ x.carrier * (hi - c)` (`least_iff`). From a step of
  MA4's course at which it holds, `lo ≤ hi`, every reading of this form with `lo' ≤ hi` from a
  reading step leaves the course locked in the shapers' favour from the step after
  (`kept_past_least`); the start need not be supposed favoured, since the least reading favouring
  forces it.
* **The window closes by a deadline.** From a start with at least one shaper whose rule read there,
  `g`, favours the shapers strictly, `lo ≤ hi` and `lo' ≤ hi` (so that `c < hi`,
  `covers_of_strict`): a reading of this form from any reading step from `g.other * c * x.other` on
  leaves the course locked in the shapers' favour from the next step, under every schedule of
  reading steps (`deadline`). MA4's share is never below the share under the start's rule held fixed
  (`held_le`), whose counts grow by that rule's powers (`held_counts`, from
  `RuleShaping.orbit_held`) and pass the least late reading's threshold by the deadline
  (`held_past`, by Bernoulli's inequality, `bernoulli_powers`).
* **Witnesses.**
  - `Window`: `a = 1`, nothing shared, a cost of three, five read as coming back where a shaper
    reads, two where another does and nothing once the others read the loss, one shaper to one
    other, the rule read at every step. Read from step 2, the course is locked the other way for
    good from step 4 (`Window.in_time`). Step 3 is the one step between (`Window.between`): read
    from there, the rule in force at step 4 favours the others, yet the course is not turned for
    good, and from step 6 it is locked in the shapers' favour for good (`Window.too_late`); in this
    witness that reading comes one step too late, the late reading still favouring the others at the
    share of step 3. Read from step 4 or any later step, by any reading of this form with
    `lo' ≤ 5`, the course stays locked in the shapers' favour (`Window.late_kept`). The deadline is
    24, the rule read at the start being 9 to 8 (`Window.by_deadline`); from two to two the window
    is the same and the deadline 96 (`Window.scaled`).
  - `Between.turned`: a cost of one, three read as coming back where a shaper reads, two where
    another does and nothing once the others read the loss, one shaper to three others: step 0 is
    the step between, and read from there the course is turned for good from step 4.
  - `Tie.both`: at MA4's critical mass, one shaper to two others, every rule read ties, and the
    course read from step 0 is locked both in the shapers' favour from step 1 and the other way from
    step 2.

Standing: elementary, MA2's `Thinned` laws composed with MA4's monotone course; the lag of one step
is the representation's (a rule read at a step is in force from the next). In this model the second
horn of Collingridge's dilemma (1980) is a theorem: from the first step at which the late reading
would favour the shapers, a reading keeps the lock (`kept_once_favoured`), and past the least
reading's threshold every reading of this form with `lo' ≤ hi` does (`kept_past_least`); the first
horn, that the need is read too late, is the premise that the loss is read only from `N`. Biggs,
Carpenter and Brock (2009) give the continuous analogue of the window. Lock-in and its timing (David
1985, Arthur 1989, Cowan 1991), the tipping models (Schelling 1978, Granovetter 1978) and replicator
selection with a delay (Alboszta and Miękisz 2004) are credited. What it adds on the spine is the
join: a window exact at every step but at most one, given readings at steps `N` and `N + 1`; its lag
of one step; and a deadline.

What is not derived: that actual rules are read by readers drawn from those they select, each kind
counted as the population counts it; that the others read the loss at all, and that the loss, once
it reaches the bound, stays there (here it grows by at least one a step; in MA4's course by one from
zero); that their late reading has this form, the same `a`, `p` and `c` with what comes back read as
a natural number. A late reading of another form, such as one reading a larger cost, is not stated,
and its window differs; with a late reading whose weight against the shapers is chosen after the
share is seen (a rule far enough below the one the shapers read), the others could turn the course
from any share, which is not stated here either. The deadline is a bound,
`(x.carrier + x.other) * (a + c + p) * c * x.other`, quadratic in the start's counts, while scaling
the counts leaves the window as it is (`Window.scaled`); it is not the step from which the window is
closed (24 in the witness, closed from step 4), and none is stated where the start's rule favours
the shapers only weakly or no shaper is present. Courses with noise, readers who learn, a general
law for the round that starts at the step between, and a ranking of courses (that needs C) are not
stated. The representation commits to discrete steps, a fixed schedule of reading steps and
natural-number amounts. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace ReadInTime

open Pace RuleCapture ClosedCapture

/-! ## The rule read once the others read the loss -/

/-- **The rule read once the others read the loss**: the shapers among the readers read the rule
after shaping with `hi` coming back to the shapers, whatever the loss; the others with `lo` while the
loss is below `N` and with `lo'` from then on, all with the same `a`, `p` and `c`. It is MA2's
`ClosedCapture.Thinned.lossPool` over three of MA3's rules after shaping. -/
abbrev shapedLossPool (a p c hi lo lo' N : Nat) (pos : 0 < a) :
    CarrierCounts × Nat → CarrierCounts → CarrierCounts :=
  Thinned.lossPool (RuleShaping.shaped a hi p c pos) (RuleShaping.shaped a lo p c pos)
    (RuleShaping.shaped a lo' p c pos) N

/-- The course of the share, what lies beyond it and the rule from `s`, what lies beyond stepping
by `fB`, under the schedule `reads`. -/
abbrev course (fB : CarrierCounts × Nat → CarrierCounts → Nat) (a p c hi lo lo' N : Nat)
    (pos : 0 < a) (reads : Nat → Bool) (s : (CarrierCounts × Nat) × CarrierCounts) (t : Nat) :
    (CarrierCounts × Nat) × CarrierCounts :=
  Thinned.course fB (RuleShaping.shaped a hi p c pos) (RuleShaping.shaped a lo p c pos)
    (RuleShaping.shaped a lo' p c pos) N reads s t

variable {fB : CarrierCounts × Nat → CarrierCounts → Nat} {a p c hi lo lo' N : Nat} {pos : 0 < a}
  {reads : Nat → Bool}

/-! ## Kept and turned, exactly -/

/-- **Kept, exactly.** Where every step adds at least one to the loss (`Accrues fB`), at a reading
step `r` at which the loss has reached its bound and the rule in force favours the shapers,
`lo' ≤ hi`: the course is locked under the late reading at every step from `r + 1` exactly where, at
the share at `r`, what the readers read as coming back to the shapers covers the cost,
`x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo'`. -/
theorem kept_iff (accrues : Accrues fB) (readers : lo' ≤ hi) {s : (CarrierCounts × Nat) × CarrierCounts}
    {r : Nat} (at_r : reads r = true) (past : N ≤ (course fB a p c hi lo lo' N pos reads s r).1.2)
    (fav : CarrierCounts.favours (course fB a p c hi lo lo' N pos reads s r).2) :
    (∀ k, Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead a p c hi lo' pos)
        ((course fB a p c hi lo lo' N pos reads s (r + (1 + k))).1.1,
          (course fB a p c hi lo lo' N pos reads s (r + (1 + k))).2)) ↔
      (course fB a p c hi lo lo' N pos reads s r).1.1.carrier * c +
          (course fB a p c hi lo lo' N pos reads s r).1.1.other * c ≤
        (course fB a p c hi lo lo' N pos reads s r).1.1.carrier * hi +
          (course fB a p c hi lo lo' N pos reads s r).1.1.other * lo' :=
  ⟨fun locked => (DrawnShaping.drawn_favours_iff (a := a) (p := p) (pos := pos)).mp
      (Eq.subst (motive := CarrierCounts.favours) (Thinned.rule_read accrues at_r past) (locked 0).1),
   fun le k => (Thinned.read_late_kept accrues (DrawnShaping.shaped_le_iff.mpr readers) at_r past fav
      ((DrawnShaping.drawn_favours_iff (a := a) (p := p) (pos := pos)).mpr le) k).2.1⟩

/-- Where `fB` accrues, every step adds at least one to the loss. -/
theorem loss_next (accrues : Accrues fB) (s : (CarrierCounts × Nat) × CarrierCounts) (r : Nat) :
    (course fB a p c hi lo lo' N pos reads s r).1.2 + 1 ≤
      (course fB a p c hi lo lo' N pos reads s (r + 1)).1.2 :=
  Eq.subst (motive := fun q : CarrierCounts × Nat => (course fB a p c hi lo lo' N pos reads s r).1.2 + 1 ≤ q.2)
    (paced_fast_succ (f := join CarrierCounts.select fB) (h := shapedLossPool a p c hi lo lo' N pos)
      (reads := reads) s r).symm
    (accrues _ _)

/-- **Turned, exactly, one step late.** Where every step adds at least one to the loss
(`Accrues fB`), at a reading step `r` at which the loss has reached its bound and the late reading
favours the others at the share there (ties included), `lo' ≤ hi`, the step `r + 1` reading too: the
course is locked the other way under the late reading at every step from `r + 2` exactly where the
late reading favours the others at the share at `r + 1`, which was selected under the rule in force
at `r`. -/
theorem turned_iff (accrues : Accrues fB) (readers : lo' ≤ hi) {s : (CarrierCounts × Nat) × CarrierCounts}
    {r : Nat} (at_r : reads r = true) (at_next : reads (r + 1) = true)
    (past : N ≤ (course fB a p c hi lo lo' N pos reads s r).1.2)
    (dis : CarrierCounts.disfavours
      (DrawnShaping.drawn a p c hi lo' pos (course fB a p c hi lo lo' N pos reads s r).1.1)) :
    (∀ k, Locked (reverse CarrierCounts.order) CarrierCounts.disfavours
        (DrawnShaping.drawnRead a p c hi lo' pos)
        ((course fB a p c hi lo lo' N pos reads s (r + 1 + (1 + k))).1.1,
          (course fB a p c hi lo lo' N pos reads s (r + 1 + (1 + k))).2)) ↔
      CarrierCounts.disfavours
        (DrawnShaping.drawn a p c hi lo' pos (course fB a p c hi lo lo' N pos reads s (r + 1)).1.1) :=
  have past' : N ≤ (course fB a p c hi lo lo' N pos reads s (r + 1)).1.2 :=
    Nat.le_trans past (Nat.le_trans (Nat.le_succ _) (loss_next accrues s r))
  have now : CarrierCounts.disfavours (course fB a p c hi lo lo' N pos reads s (r + 1)).2 :=
    Eq.subst (motive := CarrierCounts.disfavours) (Thinned.rule_read accrues at_r past).symm dis
  ⟨fun turned =>
      Eq.subst (motive := CarrierCounts.disfavours) (Thinned.rule_read accrues at_next past') (turned 0).1,
   fun later k =>
      (Thinned.read_in_time_turns accrues (DrawnShaping.shaped_le_iff.mpr readers) at_next past' now later k).1⟩

/-! ## Before the bound, MA4's course -/

/-- The course from the population `x` under the rule read there, the loss starting at zero and
growing by one a step, so that the others read it from step `N`. -/
abbrev lossCourse (a p c hi lo lo' N : Nat) (pos : 0 < a) (reads : Nat → Bool) (x : CarrierCounts)
    (t : Nat) : (CarrierCounts × Nat) × CarrierCounts :=
  course Beyond.lossStep a p c hi lo lo' N pos reads ((x, 0), DrawnShaping.drawn a p c hi lo pos x) t

/-- Below the bound, the rule read is MA4's. -/
theorem shapedLossPool_before {ℓ : Nat} (lt : ℓ < N) (x g : CarrierCounts) :
    shapedLossPool a p c hi lo lo' N pos (x, ℓ) g = DrawnShaping.drawn a p c hi lo pos x :=
  show (match Nat.ble (ℓ + 1) N with
      | true => Drawn.pool (RuleShaping.shaped a hi p c pos) (RuleShaping.shaped a lo p c pos) x
      | false => Drawn.pool (RuleShaping.shaped a hi p c pos) (RuleShaping.shaped a lo' p c pos) x) = _ by
    rw [Nat.ble_eq_true_of_le (show ℓ + 1 ≤ N from lt)]
    exact rfl

/-- One turn below the bound is MA4's turn on the share and the rule, and adds one to the loss. -/
theorem turn_before :
    ∀ (b : Bool) (q : (CarrierCounts × Nat) × CarrierCounts), q.1.2 < N →
      ((turn (join CarrierCounts.select Beyond.lossStep) (shapedLossPool a p c hi lo lo' N pos) b q).1.1,
          (turn (join CarrierCounts.select Beyond.lossStep) (shapedLossPool a p c hi lo lo' N pos) b q).2) =
        turn CarrierCounts.select (DrawnShaping.drawnRead a p c hi lo pos) b (q.1.1, q.2) ∧
      (turn (join CarrierCounts.select Beyond.lossStep) (shapedLossPool a p c hi lo lo' N pos) b q).1.2 =
        q.1.2 + 1
  | true, ((x, _), g), lt =>
    ⟨congrArg (Prod.mk (CarrierCounts.select x g)) (shapedLossPool_before (lo' := lo') lt x g), rfl⟩
  | false, ((_, _), _), _ => ⟨rfl, rfl⟩

/-- **Before the bound, MA4's course.** Up to step `N` the share and the rule are those of MA4's
course from `x` under the rule read there, and the loss at step `t` is `t`. -/
theorem early {x : CarrierCounts} :
    ∀ t, t ≤ N →
      ((lossCourse a p c hi lo lo' N pos reads x t).1.1, (lossCourse a p c hi lo lo' N pos reads x t).2) =
          DrawnShaping.drawnCourse a p c hi lo pos reads x t ∧
        (lossCourse a p c hi lo lo' N pos reads x t).1.2 = t
  | 0, _ => ⟨rfl, rfl⟩
  | t + 1, le =>
    have ih := early t (Nat.le_of_succ_le le)
    have lt : (lossCourse a p c hi lo lo' N pos reads x t).1.2 < N :=
      Eq.subst (motive := fun n => n < N) ih.2.symm le
    have one := turn_before (reads t) (lossCourse a p c hi lo lo' N pos reads x t) lt
    have succ := paced_succ (f := join CarrierCounts.select Beyond.lossStep)
      (h := shapedLossPool a p c hi lo lo' N pos) (reads := reads)
      ((x, 0), DrawnShaping.drawn a p c hi lo pos x) t
    ⟨(congrArg (fun q : (CarrierCounts × Nat) × CarrierCounts => (q.1.1, q.2)) succ).trans
        (one.1.trans
          ((congrArg (turn CarrierCounts.select (DrawnShaping.drawnRead a p c hi lo pos) (reads t)) ih.1).trans
            (paced_succ (f := CarrierCounts.select) (h := DrawnShaping.drawnRead a p c hi lo pos)
              (reads := reads) (x, DrawnShaping.drawn a p c hi lo pos x) t).symm)),
     (congrArg (fun q : (CarrierCounts × Nat) × CarrierCounts => q.1.2) succ).trans
        (one.2.trans (congrArg Nat.succ ih.2))⟩

/-- The share one step after the bound is MA4's: it was selected under the rule in force at step `N`,
which is MA4's. -/
theorem next_share {x : CarrierCounts} :
    (lossCourse a p c hi lo lo' N pos reads x (N + 1)).1.1 =
      (DrawnShaping.drawnCourse a p c hi lo pos reads x (N + 1)).1 :=
  have E := early (a := a) (p := p) (c := c) (hi := hi) (lo := lo) (lo' := lo') (N := N) (pos := pos)
    (reads := reads) (x := x) N (Nat.le_refl _)
  (congrArg Prod.fst (paced_fast_succ (f := join CarrierCounts.select Beyond.lossStep)
      (h := shapedLossPool a p c hi lo lo' N pos) (reads := reads)
      ((x, 0), DrawnShaping.drawn a p c hi lo pos x) N)).trans
    ((congrArg (fun q : CarrierCounts × CarrierCounts => CarrierCounts.select q.1 q.2) E.1).trans
      (paced_fast_succ (f := CarrierCounts.select) (h := DrawnShaping.drawnRead a p c hi lo pos)
        (reads := reads) (x, DrawnShaping.drawn a p c hi lo pos x) N).symm)

/-! ## The window, in MA4's course -/

/-- **Along MA4's course the late reading never falls.** From a start the rule read there favours,
`lo ≤ hi` and `lo' ≤ hi`: the late reading at the share of step `t + d` of MA4's course is not below
that at step `t`, since it reads a share that never falls. -/
theorem late_never_falls (step : lo ≤ hi) (readers : lo' ≤ hi) {x : CarrierCounts}
    (fav : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo pos x)) (t d : Nat) :
    CarrierCounts.order.le
      (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x t).1)
      (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x (t + d)).1) :=
  Drawn.pool_reads (DrawnShaping.shaped_le_iff.mpr readers) _ _ (DrawnShaping.drawn a p c hi lo pos x)
    (DrawnShaping.drawn a p c hi lo pos x)
    (locked_not_below CarrierCounts.raises
      ((DrawnShaping.drawn_reads_iff (a := a) (p := p) (c := c) (pos := pos)).mpr step) CarrierCounts.upper
      (DrawnShaping.drawn_locks (reads := reads) step fav t).1 d).1

/-- **Kept, in MA4's course.** From a start the rule read there favours, `lo ≤ hi` and `lo' ≤ hi`,
the others reading the loss from step `N`, a reading step: the course is locked in the shapers' favour
at every step from `N + 1` exactly where the late reading favours them at the share of step `N` of
MA4's course. -/
theorem kept_early_iff (step : lo ≤ hi) (readers : lo' ≤ hi) {x : CarrierCounts}
    (fav : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo pos x)) (at_N : reads N = true) :
    (∀ k, Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead a p c hi lo' pos)
        ((lossCourse a p c hi lo lo' N pos reads x (N + (1 + k))).1.1,
          (lossCourse a p c hi lo lo' N pos reads x (N + (1 + k))).2)) ↔
      CarrierCounts.favours
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x N).1) :=
  have E := early (a := a) (p := p) (c := c) (hi := hi) (lo := lo) (lo' := lo') (N := N) (pos := pos)
    (reads := reads) (x := x) N (Nat.le_refl _)
  have past : N ≤ (lossCourse a p c hi lo lo' N pos reads x N).1.2 :=
    Eq.subst (motive := fun n => N ≤ n) E.2.symm (Nat.le_refl _)
  have fav' : CarrierCounts.favours (lossCourse a p c hi lo lo' N pos reads x N).2 :=
    Eq.subst (motive := fun q : CarrierCounts × CarrierCounts => CarrierCounts.favours q.2) E.1.symm
      (DrawnShaping.drawn_locks (reads := reads) step fav N).1.1
  have same : CarrierCounts.favours
        (DrawnShaping.drawn a p c hi lo' pos (lossCourse a p c hi lo lo' N pos reads x N).1.1) =
      CarrierCounts.favours
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x N).1) :=
    congrArg (fun q : CarrierCounts × CarrierCounts =>
      CarrierCounts.favours (DrawnShaping.drawn a p c hi lo' pos q.1)) E.1
  (kept_iff Thinned.lossStep_accrues readers at_N past fav').trans
    ((DrawnShaping.drawn_favours_iff (a := a) (p := p) (pos := pos)).symm.trans ⟨Eq.mp same, Eq.mpr same⟩)

/-- **Turned, in MA4's course.** From a start the rule read there favours, `lo ≤ hi` and `lo' ≤ hi`,
the others reading the loss from step `N`, steps `N` and `N + 1` reading: the course is locked the
other way at every step from `N + 2` exactly where the late reading favours the others (ties
included) at the share of step `N + 1` of MA4's course. -/
theorem turned_early_iff (step : lo ≤ hi) (readers : lo' ≤ hi) {x : CarrierCounts}
    (fav : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo pos x)) (at_N : reads N = true)
    (at_next : reads (N + 1) = true) :
    (∀ k, Locked (reverse CarrierCounts.order) CarrierCounts.disfavours
        (DrawnShaping.drawnRead a p c hi lo' pos)
        ((lossCourse a p c hi lo lo' N pos reads x (N + 1 + (1 + k))).1.1,
          (lossCourse a p c hi lo lo' N pos reads x (N + 1 + (1 + k))).2)) ↔
      CarrierCounts.disfavours
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x (N + 1)).1) :=
  have E := early (a := a) (p := p) (c := c) (hi := hi) (lo := lo) (lo' := lo') (N := N) (pos := pos)
    (reads := reads) (x := x) N (Nat.le_refl _)
  have past : N ≤ (lossCourse a p c hi lo lo' N pos reads x N).1.2 :=
    Eq.subst (motive := fun n => N ≤ n) E.2.symm (Nat.le_refl _)
  have past' : N ≤ (lossCourse a p c hi lo lo' N pos reads x (N + 1)).1.2 :=
    Nat.le_trans past (Nat.le_trans (Nat.le_succ _) (loss_next Thinned.lossStep_accrues _ N))
  have next := next_share (a := a) (p := p) (c := c) (hi := hi) (lo := lo) (lo' := lo') (N := N) (pos := pos)
    (reads := reads) (x := x)
  have moved : CarrierCounts.disfavours
        (DrawnShaping.drawn a p c hi lo' pos (lossCourse a p c hi lo lo' N pos reads x (N + 1)).1.1) =
      CarrierCounts.disfavours
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x (N + 1)).1) :=
    congrArg (fun y : CarrierCounts => CarrierCounts.disfavours (DrawnShaping.drawn a p c hi lo' pos y)) next
  have read := late_never_falls (reads := reads) (lo' := lo') step readers fav N 1
  ⟨fun turned => Eq.mp moved
      (Eq.subst (motive := CarrierCounts.disfavours)
        (Thinned.rule_read Thinned.lossStep_accrues at_next past') (turned 0).1),
   fun later =>
    (turned_iff Thinned.lossStep_accrues readers at_N at_next past
      (Eq.subst (motive := fun q : CarrierCounts × CarrierCounts =>
          CarrierCounts.disfavours (DrawnShaping.drawn a p c hi lo' pos q.1)) E.1.symm
        (CarrierCounts.lower read later))).mpr (Eq.mpr moved later)⟩

/-- **In-time steps come first.** From a start the rule read there favours, `lo ≤ hi` and
`lo' ≤ hi`: where the late reading favours the others at the share of step `t` of MA4's course, it
does at the share of every earlier step `s`. -/
theorem in_time_earlier (step : lo ≤ hi) (readers : lo' ≤ hi) {x : CarrierCounts}
    (fav : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo pos x)) {s t : Nat} (le : s ≤ t)
    (later : CarrierCounts.disfavours
      (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x t).1)) :
    CarrierCounts.disfavours
      (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x s).1) :=
  CarrierCounts.lower
    (Eq.subst (motive := fun j => CarrierCounts.order.le
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x s).1)
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x j).1))
      (add_sub_of_le le) (late_never_falls step readers fav s (t - s)))
    later

/-- A run of rules that never falls has at most one step at which it favours the others strictly
and the shapers strictly at the next. -/
theorem at_most_one_between_up {g : Nat → CarrierCounts}
    (up : ∀ t d, CarrierCounts.order.le (g t) (g (t + d))) {N M : Nat}
    (atN : ¬ CarrierCounts.favours (g N) ∧ ¬ CarrierCounts.disfavours (g (N + 1)))
    (atM : ¬ CarrierCounts.favours (g M) ∧ ¬ CarrierCounts.disfavours (g (M + 1))) : N = M :=
  have after : ∀ {n m : Nat}, ¬ CarrierCounts.disfavours (g (n + 1)) → n + 1 ≤ m →
      CarrierCounts.favours (g m) :=
    fun {n m} strict le =>
      CarrierCounts.upper
        (Eq.subst (motive := fun j => CarrierCounts.order.le (g (n + 1)) (g j)) (add_sub_of_le le)
          (up (n + 1) (m - (n + 1))))
        (Nat.le_of_lt (Nat.gt_of_not_le strict))
  Nat.le_antisymm (Nat.le_of_not_lt fun lt => atN.1 (after atM.2 lt))
    (Nat.le_of_not_lt fun lt => atM.1 (after atN.2 lt))

/-- A run of rules that never rises has no such step. -/
theorem none_between_down {g : Nat → CarrierCounts}
    (down : ∀ t, CarrierCounts.order.le (g (t + 1)) (g t)) {N : Nat}
    (atN : ¬ CarrierCounts.favours (g N) ∧ ¬ CarrierCounts.disfavours (g (N + 1))) : False :=
  atN.1 (CarrierCounts.upper (down N) (Nat.le_of_lt (Nat.gt_of_not_le atN.2)))

/-- **In time, late, or the one step between.** With `lo ≤ hi`: at most one step of MA4's course has
the late reading favouring the others strictly at its share and the shapers strictly at the share of
the next step. MA4's course is monotone one way or the other (`DrawnShaping.drawn_locks`,
`DrawnShaping.drawn_from_below`) and the late reading reads the share one way or the other
(`Drawn.pool_reads`, `Drawn.pool_against`), so along the course the late reading never falls or never
rises. So, from a start the rule read there favours, with `lo' ≤ hi` and steps `N` and `N + 1`
reading, at every step `N` but at most one a reading from `N` keeps the lock for good
(`kept_early_iff`) or turns the course for good (`turned_early_iff`). -/
theorem at_most_one_between (step : lo ≤ hi) {x : CarrierCounts} {N M : Nat}
    (atN : ¬ CarrierCounts.favours
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x N).1) ∧
      ¬ CarrierCounts.disfavours
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x (N + 1)).1))
    (atM : ¬ CarrierCounts.favours
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x M).1) ∧
      ¬ CarrierCounts.disfavours
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x (M + 1)).1)) :
    N = M :=
  have mono := (DrawnShaping.drawn_reads_iff (a := a) (p := p) (c := c) (pos := pos)).mpr step
  match Nat.le_total (DrawnShaping.drawn a p c hi lo pos x).other (DrawnShaping.drawn a p c hi lo pos x).carrier,
    Nat.le_total lo' hi with
  | .inl fav, .inl readers =>
    at_most_one_between_up (g := fun t => DrawnShaping.drawn a p c hi lo' pos
        (DrawnShaping.drawnCourse a p c hi lo pos reads x t).1)
      (late_never_falls step readers fav) atN atM
  | .inl fav, .inr against =>
    have up : ∀ t d, CarrierCounts.order.le (DrawnShaping.drawnCourse a p c hi lo pos reads x t).1
        (DrawnShaping.drawnCourse a p c hi lo pos reads x (t + d)).1 := fun t d =>
      (locked_not_below CarrierCounts.raises mono CarrierCounts.upper
        (DrawnShaping.drawn_locks (reads := reads) step fav t).1 d).1
    (none_between_down (g := fun t => DrawnShaping.drawn a p c hi lo' pos
        (DrawnShaping.drawnCourse a p c hi lo pos reads x t).1)
      (fun t => Drawn.pool_against (DrawnShaping.shaped_le_iff.mpr against) _ _
        (DrawnShaping.drawn a p c hi lo pos x) (DrawnShaping.drawn a p c hi lo pos x) (up t 1)) atN).elim
  | .inr dis, .inl readers =>
    have down : ∀ t d, CarrierCounts.order.le (DrawnShaping.drawnCourse a p c hi lo pos reads x (t + d)).1
        (DrawnShaping.drawnCourse a p c hi lo pos reads x t).1 := fun t d =>
      (locked_not_below CarrierCounts.lowers mono.reverse CarrierCounts.lower
        (DrawnShaping.drawn_from_below (reads := reads) step dis t).1 d).1
    (none_between_down (g := fun t => DrawnShaping.drawn a p c hi lo' pos
        (DrawnShaping.drawnCourse a p c hi lo pos reads x t).1)
      (fun t => Drawn.pool_reads (DrawnShaping.shaped_le_iff.mpr readers) _ _
        (DrawnShaping.drawn a p c hi lo pos x) (DrawnShaping.drawn a p c hi lo pos x) (down t 1)) atN).elim
  | .inr dis, .inr against =>
    have down : ∀ t d, CarrierCounts.order.le (DrawnShaping.drawnCourse a p c hi lo pos reads x (t + d)).1
        (DrawnShaping.drawnCourse a p c hi lo pos reads x t).1 := fun t d =>
      (locked_not_below CarrierCounts.lowers mono.reverse CarrierCounts.lower
        (DrawnShaping.drawn_from_below (reads := reads) step dis t).1 d).1
    at_most_one_between_up (g := fun t => DrawnShaping.drawn a p c hi lo' pos
        (DrawnShaping.drawnCourse a p c hi lo pos reads x t).1)
      (fun t d => Drawn.pool_against (DrawnShaping.shaped_le_iff.mpr against) _ _
        (DrawnShaping.drawn a p c hi lo pos x) (DrawnShaping.drawn a p c hi lo pos x) (down t d)) atN atM

/-- **Kept, in the next round.** Where the late reading favours the shapers at the share of step
`N + 1` of MA4's course, as at the one step between, `lo' ≤ hi`, steps `N + 1` and `N + 2` reading:
the course read from `N` is locked in the shapers' favour at every step from `N + 3` exactly where the
late reading favours them at its share of step `N + 2`. Neither the start favoured nor `lo ≤ hi` is
needed. -/
theorem kept_next_round_iff (readers : lo' ≤ hi) {x : CarrierCounts}
    (late1 : CarrierCounts.favours
      (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x (N + 1)).1))
    (at_next : reads (N + 1) = true) (at_two : reads (N + 2) = true) :
    (∀ k, Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead a p c hi lo' pos)
        ((lossCourse a p c hi lo lo' N pos reads x (N + 2 + (1 + k))).1.1,
          (lossCourse a p c hi lo lo' N pos reads x (N + 2 + (1 + k))).2)) ↔
      CarrierCounts.favours
        (DrawnShaping.drawn a p c hi lo' pos (lossCourse a p c hi lo lo' N pos reads x (N + 2)).1.1) :=
  have grows := fun t => ClosedCapture.loss_grows (fA := CarrierCounts.select) (fB := Beyond.lossStep)
    (h := shapedLossPool a p c hi lo lo' N pos) (reads := reads) Thinned.lossStep_accrues
    ((x, 0), DrawnShaping.drawn a p c hi lo pos x) t
  have past1 : N ≤ (lossCourse a p c hi lo lo' N pos reads x (N + 1)).1.2 :=
    Nat.le_trans (Nat.le_trans (Nat.le_succ N) (Nat.le_of_eq (Nat.zero_add (N + 1)).symm)) (grows (N + 1))
  have past2 : N ≤ (lossCourse a p c hi lo lo' N pos reads x (N + 2)).1.2 :=
    Nat.le_trans (Nat.le_trans (Nat.le_add_right N 2) (Nat.le_of_eq (Nat.zero_add (N + 2)).symm))
      (grows (N + 2))
  have rule2 : (lossCourse a p c hi lo lo' N pos reads x (N + 1 + 1)).2 =
      Drawn.pool (RuleShaping.shaped a hi p c pos) (RuleShaping.shaped a lo' p c pos)
        (lossCourse a p c hi lo lo' N pos reads x (N + 1)).1.1 :=
    Thinned.rule_read Thinned.lossStep_accrues at_next past1
  have share1 := next_share (a := a) (p := p) (c := c) (hi := hi) (lo := lo) (lo' := lo') (N := N)
    (pos := pos) (reads := reads) (x := x)
  have fav2 : CarrierCounts.favours (lossCourse a p c hi lo lo' N pos reads x (N + 2)).2 :=
    Eq.subst (motive := CarrierCounts.favours) rule2.symm
      (Eq.subst (motive := fun y => CarrierCounts.favours (DrawnShaping.drawn a p c hi lo' pos y))
        share1.symm late1)
  (kept_iff Thinned.lossStep_accrues readers at_two past2 fav2).trans
    (DrawnShaping.drawn_favours_iff (a := a) (p := p) (pos := pos)).symm

/-! ## The window closes -/

/-- **Once the late reading would favour the shapers, every later reading keeps the lock.** From a
start the rule read there favours, `lo ≤ hi` and `lo' ≤ hi`: where the late reading favours the
shapers at the share of step `s` of MA4's course, the others reading the loss from step `s + d`, a
reading step, leave the course locked in the shapers' favour at every step from `s + d + 1`. -/
theorem kept_once_favoured (step : lo ≤ hi) (readers : lo' ≤ hi) {x : CarrierCounts}
    (fav : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo pos x)) {s : Nat}
    (favoured : CarrierCounts.favours
      (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x s).1))
    (d : Nat) (at_N : reads (s + d) = true) (k : Nat) :
    Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead a p c hi lo' pos)
      ((lossCourse a p c hi lo lo' (s + d) pos reads x (s + d + (1 + k))).1.1,
        (lossCourse a p c hi lo lo' (s + d) pos reads x (s + d + (1 + k))).2) :=
  have E := early (a := a) (p := p) (c := c) (hi := hi) (lo := lo) (lo' := lo') (N := s + d) (pos := pos)
    (reads := reads) (x := x) (s + d) (Nat.le_refl _)
  have favN := (DrawnShaping.drawn_locks (reads := reads) step fav (s + d)).1.1
  have lateN : CarrierCounts.favours
      (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x (s + d)).1) :=
    CarrierCounts.upper (late_never_falls step readers fav s d) favoured
  have past : s + d ≤ (lossCourse a p c hi lo lo' (s + d) pos reads x (s + d)).1.2 :=
    Eq.subst (motive := fun n => s + d ≤ n) E.2.symm (Nat.le_refl _)
  have fav' : CarrierCounts.favours (lossCourse a p c hi lo lo' (s + d) pos reads x (s + d)).2 :=
    Eq.subst (motive := fun q : CarrierCounts × CarrierCounts => CarrierCounts.favours q.2) E.1.symm favN
  have late' : CarrierCounts.favours
      (DrawnShaping.drawn a p c hi lo' pos (lossCourse a p c hi lo lo' (s + d) pos reads x (s + d)).1.1) :=
    Eq.subst (motive := fun q : CarrierCounts × CarrierCounts =>
        CarrierCounts.favours (DrawnShaping.drawn a p c hi lo' pos q.1)) E.1.symm lateN
  (Thinned.read_late_kept Thinned.lossStep_accrues (DrawnShaping.shaped_le_iff.mpr readers) at_N past fav'
    late' k).2.1

/-- **The least reading of this form.** Where the late reading with nothing read as coming back to
the shapers favours them, every late reading of this form does, whatever `lo'`. -/
theorem least {x : CarrierCounts} (none : CarrierCounts.favours (DrawnShaping.drawn a p c hi 0 pos x))
    (lo' : Nat) : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo' pos x) :=
  DrawnShaping.drawn_favours_iff.mpr (Nat.le_trans (DrawnShaping.drawn_favours_iff.mp none)
    (Nat.add_le_add_left (Nat.mul_le_mul_left x.other (Nat.zero_le lo')) _))

/-- With what comes back to the shapers at least the cost where a shaper reads, the least late
reading favours the shapers exactly where `x.other * c ≤ x.carrier * (hi - c)`. -/
theorem least_iff (covers : c ≤ hi) {x : CarrierCounts} :
    CarrierCounts.favours (DrawnShaping.drawn a p c hi 0 pos x) ↔ x.other * c ≤ x.carrier * (hi - c) :=
  DrawnShaping.critical_iff (Nat.zero_le c) covers

/-- **Past the least reading's threshold, every reading of this form keeps the lock.** With
`lo ≤ hi` and `lo' ≤ hi`: where the least late reading favours the shapers at step `s` of MA4's
course, the others reading the loss with `lo'` from step `s + d`, a reading step, leave the course
locked in the shapers' favour at every step from `s + d + 1`. The start need not be supposed
favoured: with `lo ≤ hi`, the least late reading favouring at a step of MA4's course forces the
start's rule read to favour the shapers. -/
theorem kept_past_least (step : lo ≤ hi) (readers : lo' ≤ hi) {x : CarrierCounts} {s : Nat}
    (least_favours : CarrierCounts.favours
      (DrawnShaping.drawn a p c hi 0 pos (DrawnShaping.drawnCourse a p c hi lo pos reads x s).1))
    (d : Nat) (at_N : reads (s + d) = true) (k : Nat) :
    Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead a p c hi lo' pos)
      ((lossCourse a p c hi lo lo' (s + d) pos reads x (s + d + (1 + k))).1.1,
        (lossCourse a p c hi lo lo' (s + d) pos reads x (s + d + (1 + k))).2) :=
  have fav : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo pos x) :=
    match Nat.le_total (DrawnShaping.drawn a p c hi lo pos x).other
        (DrawnShaping.drawn a p c hi lo pos x).carrier with
    | .inl f => f
    | .inr dis => CarrierCounts.upper
        (Drawn.pool_reads (DrawnShaping.shaped_le_iff.mpr step) _ _
          (DrawnShaping.drawn a p c hi lo pos x) (DrawnShaping.drawn a p c hi lo pos x)
          (DrawnShaping.drawn_from_below (reads := reads) step dis s).2.1)
        (least least_favours lo)
  kept_once_favoured step readers fav (least least_favours lo') d at_N k

/-! ## The window closes by a deadline -/

/-- **A start favouring the shapers strictly, with `lo ≤ hi`, has `c < hi`.** -/
theorem covers_of_strict (step : lo ≤ hi) {x : CarrierCounts}
    (strict : (DrawnShaping.drawn a p c hi lo pos x).other < (DrawnShaping.drawn a p c hi lo pos x).carrier) :
    c < hi :=
  match Nat.lt_or_ge c hi with
  | .inl h => h
  | .inr h =>
    absurd strict (Nat.not_lt_of_le
      (show x.carrier * (a + hi + p) + x.other * (a + lo + p) ≤
          x.carrier * (a + c + p) + x.other * (a + c + p) from
        Nat.add_le_add
          (Nat.mul_le_mul_left _ (Nat.add_le_add_right (Nat.add_le_add_left h a) p))
          (Nat.mul_le_mul_left _ (Nat.add_le_add_right (Nat.add_le_add_left (Nat.le_trans step h) a) p))))

/-- `powers` is the power. -/
theorem powers_eq_pow (b : Nat) : ∀ t, powers b t = b ^ t
  | 0 => rfl
  | t + 1 => (congrArg (b * ·) (powers_eq_pow b t)).trans (Nat.mul_comm b (b ^ t))

/-- Held fixed, the rule multiplies the carriers and the others by its powers
(`RuleShaping.orbit_held`). -/
theorem held_counts (x g : CarrierCounts) (t : Nat) :
    (Law.orbit (fun y => CarrierCounts.select y g) x t).carrier = x.carrier * powers g.carrier t ∧
      (Law.orbit (fun y => CarrierCounts.select y g) x t).other = x.other * powers g.other t :=
  ⟨(congrArg CarrierCounts.carrier (RuleShaping.orbit_held g x t)).trans
      (congrArg (x.carrier * ·) (powers_eq_pow g.carrier t).symm),
   (congrArg CarrierCounts.other (RuleShaping.orbit_held g x t)).trans
      (congrArg (x.other * ·) (powers_eq_pow g.other t).symm)⟩

/-- Powers of a larger base are not smaller. -/
theorem powers_base_le {b b' : Nat} (le : b ≤ b') : ∀ t, powers b t ≤ powers b' t
  | 0 => Nat.le_refl 1
  | t + 1 => Nat.mul_le_mul le (powers_base_le le t)

/-- **MA4's course is never below the course with the start's rule held fixed**: from a start the
rule read there favours, `lo ≤ hi`, MA4's share at every step is not below the share under the
start's rule held fixed, since the rule in force is never below the start's. -/
theorem held_le (step : lo ≤ hi) {x : CarrierCounts}
    (fav : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo pos x)) :
    ∀ t, CarrierCounts.order.le
      (Law.orbit (fun y => CarrierCounts.select y (DrawnShaping.drawn a p c hi lo pos x)) x t)
      (DrawnShaping.drawnCourse a p c hi lo pos reads x t).1
  | 0 => CarrierCounts.order.refl _
  | t + 1 =>
    Eq.subst (motive := fun y => CarrierCounts.order.le
        (Law.orbit (fun z => CarrierCounts.select z (DrawnShaping.drawn a p c hi lo pos x)) x (t + 1)) y)
      (paced_fast_succ (f := CarrierCounts.select) (h := DrawnShaping.drawnRead a p c hi lo pos)
        (reads := reads) (x, DrawnShaping.drawn a p c hi lo pos x) t).symm
      (CarrierCounts.select_mono (held_le step fav t) (DrawnShaping.drawn_locks (reads := reads) step fav t).2.2)

/-- **Held, a rule favouring strictly carries the share past the least late reading's threshold** by
step `g.other * c * x.other`, at least one carrier present and `c < hi` (Bernoulli's inequality,
`bernoulli_powers`). -/
theorem held_past (covers : c < hi) {x g : CarrierCounts} (some : 0 < x.carrier)
    (strict : g.other < g.carrier) {t : Nat} (late : g.other * c * x.other ≤ t) :
    (Law.orbit (fun y => CarrierCounts.select y g) x t).other * c ≤
      (Law.orbit (fun y => CarrierCounts.select y g) x t).carrier * (hi - c) :=
  have counts := held_counts x g t
  have grow : g.other * (x.other * powers g.other t * c) ≤ g.other * powers g.carrier t :=
    calc g.other * (x.other * powers g.other t * c)
        = g.other * c * x.other * powers g.other t :=
          (mul_assoc_nat g.other (x.other * powers g.other t) c).symm.trans
            ((Naturals.mul_right_comm g.other (x.other * powers g.other t) c).trans
              (mul_assoc_nat (g.other * c) x.other (powers g.other t)).symm)
      _ ≤ t * powers g.other t := Nat.mul_le_mul_right _ late
      _ ≤ (g.other + t) * powers g.other t := Nat.mul_le_mul_right _ (Nat.le_add_left t g.other)
      _ ≤ g.other * powers (g.other + 1) t := bernoulli_powers g.other t
      _ ≤ g.other * powers g.carrier t := Nat.mul_le_mul_left _ (powers_base_le strict t)
  have cancel : x.other * powers g.other t * c ≤ powers g.carrier t :=
    Nat.le_of_mul_le_mul_left grow g.other_pos
  have scaled : powers g.carrier t ≤ x.carrier * powers g.carrier t * (hi - c) :=
    Nat.le_trans (Nat.le_of_eq ((Nat.mul_one _).trans (Nat.one_mul _)).symm)
      (Nat.mul_le_mul (Nat.mul_le_mul_right _ some) (SupportGated.sub_pos_of_lt covers))
  Eq.subst (motive := fun n => n * c ≤ (Law.orbit (fun y => CarrierCounts.select y g) x t).carrier * (hi - c))
    counts.2.symm
    (Eq.subst (motive := fun n => x.other * powers g.other t * c ≤ n * (hi - c)) counts.1.symm
      (Nat.le_trans cancel scaled))

/-- **The window closes by a deadline.** From a start with at least one shaper whose rule read there
favours the shapers strictly, `lo ≤ hi` and `lo' ≤ hi`: the others reading the loss with `lo'` from a
reading step `N` not before `g.other * c * x.other`, `g` the rule read at the start, leave the course
locked in the shapers' favour at every step from `N + 1`. The deadline holds under every schedule of
reading steps. It is a bound, `(x.carrier + x.other) * (a + c + p) * c * x.other`, quadratic in the
start's counts, not the step at which the window closes. -/
theorem deadline (step : lo ≤ hi) (readers : lo' ≤ hi) {x : CarrierCounts} (some : 0 < x.carrier)
    (strict : (DrawnShaping.drawn a p c hi lo pos x).other < (DrawnShaping.drawn a p c hi lo pos x).carrier)
    {N : Nat} (late : (DrawnShaping.drawn a p c hi lo pos x).other * c * x.other ≤ N)
    (at_N : reads N = true) (k : Nat) :
    Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead a p c hi lo' pos)
      ((lossCourse a p c hi lo lo' N pos reads x (N + (1 + k))).1.1,
        (lossCourse a p c hi lo lo' N pos reads x (N + (1 + k))).2) :=
  have covers := covers_of_strict step strict
  have fav : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo pos x) := Nat.le_of_lt strict
  have past := (least_iff (a := a) (p := p) (pos := pos) (Nat.le_of_lt covers)).mpr
    (held_past covers some strict late)
  have favoured : CarrierCounts.favours
      (DrawnShaping.drawn a p c hi 0 pos (DrawnShaping.drawnCourse a p c hi lo pos reads x N).1) :=
    CarrierCounts.upper
      (Drawn.pool_reads (DrawnShaping.shaped_le_iff.mpr (Nat.zero_le hi)) _ _
        (DrawnShaping.drawn a p c hi lo pos x) (DrawnShaping.drawn a p c hi lo pos x)
        (held_le (reads := reads) step fav N))
      past
  (kept_early_iff step readers fav at_N).mpr (least favoured lo') k

/-! ### Witnesses

`Window`: `a = 1`, nothing shared, a cost of three; five read as coming back where a shaper reads,
two where another does, and nothing once the others read the loss; one shaper to one other; the
rule read at every step. `Between`: a cost of one, three, two and nothing, one shaper to three
others. `Tie`: MA4's critical mass. -/

namespace Window

open DrawnShaping.CriticalMass (even)

/-- The course in which the others read the loss from step `N`. -/
abbrev readFrom (N t : Nat) : (CarrierCounts × Nat) × CarrierCounts :=
  lossCourse 1 0 3 5 2 0 N Nat.one_pos (fun _ => true) even t

/-- **Read in time.** Read from step 2, the course is locked the other way at every step from step
4: the late reading favours the others at the shares of steps 2 and 3, 550 to 580 and 42260 to
42680. -/
theorem in_time (k : Nat) :
    Locked (reverse CarrierCounts.order) CarrierCounts.disfavours (DrawnShaping.drawnRead 1 0 3 5 0 Nat.one_pos)
      ((readFrom 2 (2 + 1 + (1 + k))).1.1, (readFrom 2 (2 + 1 + (1 + k))).2) :=
  (turned_iff (fB := Beyond.lossStep) (a := 1) (p := 0) (c := 3) (hi := 5) (lo := 2) (lo' := 0) (N := 2)
      (pos := Nat.one_pos) (reads := fun _ => true) (s := ((even, 0), DrawnShaping.drawn 1 0 3 5 2 Nat.one_pos even))
      (r := 2) Thinned.lossStep_accrues (Nat.zero_le 5) rfl rfl
      (show 2 ≤ 2 from Nat.le_refl 2) (show 550 ≤ 580 by decide)).mpr
    (show 42260 ≤ 42680 by decide) k

/-- **Step 3 is the one step between.** The late reading favours the others strictly at the share of
step 3 of MA4's course (42260 to 42680) and the shapers strictly at that of step 4 (28225784 to
27231056), and no other step does both. -/
theorem between :
    (¬ CarrierCounts.favours (DrawnShaping.drawn 1 0 3 5 0 Nat.one_pos
        (DrawnShaping.drawnCourse 1 0 3 5 2 Nat.one_pos (fun _ => true) even 3).1) ∧
      ¬ CarrierCounts.disfavours (DrawnShaping.drawn 1 0 3 5 0 Nat.one_pos
        (DrawnShaping.drawnCourse 1 0 3 5 2 Nat.one_pos (fun _ => true) even (3 + 1)).1)) ∧
    ∀ M, (¬ CarrierCounts.favours (DrawnShaping.drawn 1 0 3 5 0 Nat.one_pos
        (DrawnShaping.drawnCourse 1 0 3 5 2 Nat.one_pos (fun _ => true) even M).1) ∧
      ¬ CarrierCounts.disfavours (DrawnShaping.drawn 1 0 3 5 0 Nat.one_pos
        (DrawnShaping.drawnCourse 1 0 3 5 2 Nat.one_pos (fun _ => true) even (M + 1)).1)) → M = 3 :=
  ⟨⟨show ¬ 42680 ≤ 42260 by decide, show ¬ 28225784 ≤ 27231056 by decide⟩,
   fun _ atM => at_most_one_between (show 2 ≤ 5 by decide) atM
     ⟨show ¬ 42680 ≤ 42260 by decide, show ¬ 28225784 ≤ 27231056 by decide⟩⟩

/-- **Read from the step between, here one step too late.** Read from step 3, though the late
reading still favours the others at the share of step 3 (42260 to 42680) and the rule in force at
step 4 favours them, the course is not locked the other way from step 5 on, the late reading
favouring the shapers at the share of step 4; and from step 6 it is locked in the shapers' favour for
good. -/
theorem too_late :
    CarrierCounts.disfavours (DrawnShaping.drawn 1 0 3 5 0 Nat.one_pos (readFrom 3 3).1.1) ∧
      CarrierCounts.disfavours (readFrom 3 4).2 ∧
      (¬ ∀ k, Locked (reverse CarrierCounts.order) CarrierCounts.disfavours
          (DrawnShaping.drawnRead 1 0 3 5 0 Nat.one_pos)
          ((readFrom 3 (3 + 1 + (1 + k))).1.1, (readFrom 3 (3 + 1 + (1 + k))).2)) ∧
      ∀ k, Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead 1 0 3 5 0 Nat.one_pos)
        ((readFrom 3 (5 + (1 + k))).1.1, (readFrom 3 (5 + (1 + k))).2) :=
  ⟨show 42260 ≤ 42680 by decide, show 42260 ≤ 42680 by decide,
   fun turned => absurd
     ((turned_iff (fB := Beyond.lossStep) (a := 1) (p := 0) (c := 3) (hi := 5) (lo := 2) (lo' := 0) (N := 3)
        (pos := Nat.one_pos) (reads := fun _ => true) (s := ((even, 0), DrawnShaping.drawn 1 0 3 5 2 Nat.one_pos even))
        (r := 3) Thinned.lossStep_accrues (Nat.zero_le 5) rfl rfl
        (show 3 ≤ 3 from Nat.le_refl 3) (show 42260 ≤ 42680 by decide)).mp turned)
     (show ¬ 28225784 ≤ 27231056 by decide),
   fun k => ((kept_iff (fB := Beyond.lossStep) (a := 1) (p := 0) (c := 3) (hi := 5) (lo := 2) (lo' := 0)
      (N := 3) (pos := Nat.one_pos) (reads := fun _ => true)
      (s := ((even, 0), DrawnShaping.drawn 1 0 3 5 2 Nat.one_pos even)) (r := 5) Thinned.lossStep_accrues
      (Nat.zero_le 5) rfl (show 3 ≤ 5 by decide) (show 27231056 ≤ 28225784 by decide)).mpr
      (show 543075315120 + 323193446400 ≤ 905125525200 + 0 by decide)) k⟩

/-- **Read late.** From step 4 on the least late reading favours the shapers (28225784 to 27231056),
so the others reading the loss from step `4 + d` with any `lo' ≤ 5` leave the course locked in the
shapers' favour at every step from `4 + d + 1`. -/
theorem late_kept (lo' : Nat) (readers : lo' ≤ 5) (d k : Nat) :
    Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead 1 0 3 5 lo' Nat.one_pos)
      ((lossCourse 1 0 3 5 2 lo' (4 + d) Nat.one_pos (fun _ => true) even (4 + d + (1 + k))).1.1,
        (lossCourse 1 0 3 5 2 lo' (4 + d) Nat.one_pos (fun _ => true) even (4 + d + (1 + k))).2) :=
  kept_past_least (a := 1) (p := 0) (c := 3) (hi := 5) (lo := 2) (lo' := lo') (pos := Nat.one_pos)
    (reads := fun _ => true) (x := even) (s := 4) (show 2 ≤ 5 by decide) readers
    (show 27231056 ≤ 28225784 by decide) d rfl k

/-- **The deadline, in the witness.** The rule read at the start is 9 to 8, so the deadline is
`8 * 3 * 1 = 24`, well after step 4, from which the window is closed. -/
theorem by_deadline (lo' : Nat) (readers : lo' ≤ 5) (d k : Nat) :
    Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead 1 0 3 5 lo' Nat.one_pos)
      ((lossCourse 1 0 3 5 2 lo' (24 + d) Nat.one_pos (fun _ => true) even (24 + d + (1 + k))).1.1,
        (lossCourse 1 0 3 5 2 lo' (24 + d) Nat.one_pos (fun _ => true) even (24 + d + (1 + k))).2) :=
  deadline (a := 1) (p := 0) (c := 3) (hi := 5) (lo := 2) (lo' := lo') (pos := Nat.one_pos)
    (reads := fun _ => true) (x := even) (show 2 ≤ 5 by decide) readers
    (show 0 < 1 by decide) (show 8 < 9 by decide) (show 24 ≤ 24 + d from Nat.le_add_right 24 d) rfl k

/-- Two shapers to two others. -/
def twoToTwo : CarrierCounts := ⟨2, 2, Nat.zero_lt_succ 1⟩

/-- **The deadline is not a law of the share.** From two to two, as from one to one, the least late
reading favours the others at the share of step 3 (1352320 to 1365760), and every reading of this
form with `lo' ≤ 5` from step 4 on keeps the lock; yet the deadline is 96, four times 24. -/
theorem scaled :
    (DrawnShaping.drawn 1 0 3 5 2 Nat.one_pos twoToTwo).other * 3 * twoToTwo.other = 96 ∧
      ¬ CarrierCounts.favours (DrawnShaping.drawn 1 0 3 5 0 Nat.one_pos
        (DrawnShaping.drawnCourse 1 0 3 5 2 Nat.one_pos (fun _ => true) twoToTwo 3).1) ∧
      ∀ (lo' : Nat), lo' ≤ 5 → ∀ d k, Locked CarrierCounts.order CarrierCounts.favours
        (DrawnShaping.drawnRead 1 0 3 5 lo' Nat.one_pos)
        ((lossCourse 1 0 3 5 2 lo' (4 + d) Nat.one_pos (fun _ => true) twoToTwo (4 + d + (1 + k))).1.1,
          (lossCourse 1 0 3 5 2 lo' (4 + d) Nat.one_pos (fun _ => true) twoToTwo (4 + d + (1 + k))).2) :=
  ⟨rfl, show ¬ 1365760 ≤ 1352320 by decide,
   fun lo' readers d k => kept_past_least (a := 1) (p := 0) (c := 3) (hi := 5) (lo := 2) (lo' := lo')
      (pos := Nat.one_pos) (reads := fun _ => true) (x := twoToTwo) (s := 4) (show 2 ≤ 5 by decide) readers
      (show 6971150336 ≤ 7225800704 by decide) d rfl k⟩

end Window

namespace Between

open DrawnShaping.CriticalMass (oneToThree)

/-- **Read from the step between, the course can be turned.** `a = 1`, nothing shared, a cost of
one, three read as coming back where a shaper reads, two where another does and nothing once the
others read the loss, one shaper to three others, the rule read at every step. The start's rule
favours the shapers (13 to 8); step 0 is the step between, the late reading favouring the others
strictly at the start (7 to 8) and the shapers strictly at MA4's share of step 1 (76 to 74); yet read
from step 0 the course is locked the other way at every step from step 4, the late reading favouring
the others at its shares of steps 2 and 3 (556 to 566, 41872 to 42248). -/
theorem turned :
    CarrierCounts.favours (DrawnShaping.drawn 1 0 1 3 2 Nat.one_pos oneToThree) ∧
      ¬ CarrierCounts.favours (DrawnShaping.drawn 1 0 1 3 0 Nat.one_pos
        (DrawnShaping.drawnCourse 1 0 1 3 2 Nat.one_pos (fun _ => true) oneToThree 0).1) ∧
      ¬ CarrierCounts.disfavours (DrawnShaping.drawn 1 0 1 3 0 Nat.one_pos
        (DrawnShaping.drawnCourse 1 0 1 3 2 Nat.one_pos (fun _ => true) oneToThree 1).1) ∧
      ∀ k, Locked (reverse CarrierCounts.order) CarrierCounts.disfavours
        (DrawnShaping.drawnRead 1 0 1 3 0 Nat.one_pos)
        ((lossCourse 1 0 1 3 2 0 0 Nat.one_pos (fun _ => true) oneToThree (2 + 1 + (1 + k))).1.1,
          (lossCourse 1 0 1 3 2 0 0 Nat.one_pos (fun _ => true) oneToThree (2 + 1 + (1 + k))).2) :=
  ⟨show 8 ≤ 13 by decide, show ¬ 8 ≤ 7 by decide, show ¬ 76 ≤ 74 by decide,
   (turned_iff (fB := Beyond.lossStep) (a := 1) (p := 0) (c := 1) (hi := 3) (lo := 2) (lo' := 0) (N := 0)
      (pos := Nat.one_pos) (reads := fun _ => true)
      (s := ((oneToThree, 0), DrawnShaping.drawn 1 0 1 3 2 Nat.one_pos oneToThree))
      (r := 2) Thinned.lossStep_accrues (Nat.zero_le 3) rfl rfl
      (Nat.zero_le _) (show 556 ≤ 566 by decide)).mpr (show 41872 ≤ 42248 by decide)⟩

end Between

namespace Tie

open DrawnShaping.CriticalMass (oneToTwo)

/-- **At a tie a reading both keeps and turns.** At MA4's critical mass (`a = 1`, nothing shared, a
cost of one, three read as coming back where a shaper reads and nothing where another does, before
the bound and after it, one shaper to two others, the rule read at every step), every rule read ties:
the late reading is 6 to 6 at the start and 36 to 36 at the share of step 1, and the course read from
step 0 is locked in the shapers' favour at every step from step 1 and the other way at every step
from step 2. -/
theorem both :
    CarrierCounts.favours (DrawnShaping.drawn 1 0 1 3 0 Nat.one_pos
        (DrawnShaping.drawnCourse 1 0 1 3 0 Nat.one_pos (fun _ => true) oneToTwo 0).1) ∧
      (∀ k, Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead 1 0 1 3 0 Nat.one_pos)
        ((lossCourse 1 0 1 3 0 0 0 Nat.one_pos (fun _ => true) oneToTwo (0 + (1 + k))).1.1,
          (lossCourse 1 0 1 3 0 0 0 Nat.one_pos (fun _ => true) oneToTwo (0 + (1 + k))).2)) ∧
      (∀ k, Locked (reverse CarrierCounts.order) CarrierCounts.disfavours
        (DrawnShaping.drawnRead 1 0 1 3 0 Nat.one_pos)
        ((lossCourse 1 0 1 3 0 0 0 Nat.one_pos (fun _ => true) oneToTwo (0 + 1 + (1 + k))).1.1,
          (lossCourse 1 0 1 3 0 0 0 Nat.one_pos (fun _ => true) oneToTwo (0 + 1 + (1 + k))).2)) :=
  ⟨show 6 ≤ 6 by decide,
   (kept_early_iff (a := 1) (p := 0) (c := 1) (hi := 3) (lo := 0) (lo' := 0) (N := 0) (pos := Nat.one_pos)
      (reads := fun _ => true) (x := oneToTwo) (Nat.zero_le 3) (Nat.zero_le 3) (show 6 ≤ 6 by decide) rfl).mpr
     (show 6 ≤ 6 by decide),
   (turned_early_iff (a := 1) (p := 0) (c := 1) (hi := 3) (lo := 0) (lo' := 0) (N := 0) (pos := Nat.one_pos)
      (reads := fun _ => true) (x := oneToTwo) (Nat.zero_le 3) (Nat.zero_le 3) (show 6 ≤ 6 by decide) rfl
      rfl).mpr
     (show 36 ≤ 36 by decide)⟩

end Tie

end ReadInTime

end Becoming
