import Becoming.DrawnShaping

/-!
# The loss read in time by the others, joined to the critical mass (board item MA4b)

`Becoming.DrawnShaping` (MA4) leaves the way out of the lock open: with the readers drawn from the
selected and `lo ≤ hi`, every course read from the share alone is locked one way or the other
(`DrawnShaping.drawn_locked_either`), so leaving needs a reading beyond the share.
`ClosedCapture.Thinned` (MA2) gives one: the others among the readers read the loss once it reaches
a bound. This module joins the two.

* **The rule read once the others read the loss.** The shapers among the readers read the rule
  after shaping with `hi` coming back to the shapers, whatever the loss; the others read it with
  `lo` while the loss is below `N` and with `lo'` from then on, all with the same `a`, `p` and `c`
  (`lossRead`, MA2's `Thinned.lossPool` over three of MA3's rules after shaping). Once the others
  read the loss, the rule read at a share is MA4's rule read with `lo'`
  (`DrawnShaping.drawn_favours_iff` at `lo'`).
* **Kept, exactly.** At a reading step at which the loss has reached its bound and the rule in force
  favours the shapers, `lo' ≤ hi`, the course is locked for good from the next step exactly where
  `x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo'` at the share there (`kept_iff`).
  No mirror premise enters, as one does in `Thinned.kept_iff`.
* **Turned, exactly, one step late.** At a reading step at which the loss has reached its bound and
  the late reading favours the others at the share there (ties included), the next step reading
  too, the course is locked the other way for good from two steps after the reading exactly where
  the late reading favours the others at the share one step after it (`turned_iff`). That share was
  selected under the rule in force at the reading step: where that rule still favoured the shapers,
  the reading must come one step before the share alone would say.
* **Before the bound, MA4's course.** With the loss starting at zero and growing by one a step, the
  joined course up to step `N` is MA4's (`early`), the loss at step `t` being `t`, and so is the
  share at step `N + 1` (`next_share`).
* **The window, in MA4's course.** From a start the rule read there favours, `lo ≤ hi` and
  `lo' ≤ hi`, the others reading the loss from step `N`, a reading step: the course is locked in the
  shapers' favour for good from step `N + 1` exactly where the late reading favours them at the
  share of step `N` of MA4's course (`kept_early_iff`); with step `N + 1` reading too, it is locked
  the other way for good from step `N + 2` exactly where the late reading favours the others (ties
  included) at the share of step `N + 1` (`turned_early_iff`). Along MA4's course the late reading
  never falls (`late_rises`), so the steps from which a reading turns the course come first and
  those from which it keeps the lock come last, and at most one step lies between: the step at
  which the late reading favours the others strictly at its share and the shapers strictly at the
  next (`one_between`). A reading from there comes one step too late.
* **Once favoured, every later reading keeps the lock.** From a start the rule read there favours,
  `lo ≤ hi` and `lo' ≤ hi`: where the late reading would favour the shapers at a step `s` of MA4's
  course, the others reading the loss from any step `s + d` leave the course locked in the shapers'
  favour for good (`closed_kept`). So their reading can turn the course only if it comes before the
  first step at which their late reading would favour the shapers.
* **The least reading of this form.** Where the late reading with nothing read as coming back
  favours the shapers, every late reading of this form does (`least`); with `c ≤ hi` that is exactly
  where `x.other * c ≤ x.carrier * (hi - c)` (`least_iff`). From a step of MA4's course at which it
  holds, no reading of this form by the others alone turns the course (`closed_for_every`).
* **The window closes by a deadline.** From a start with at least one shaper whose rule read there
  favours the shapers strictly, `lo ≤ hi`, `lo' ≤ hi` and `c < hi`: a reading of this form from any
  reading step from `g.other * c * x.other` on, `g` the rule read at the start, keeps the lock for
  good, under every schedule of reading steps (`deadline`). MA4's course is never below the course
  under the start's rule held fixed (`held_le`), whose counts grow by that rule's powers
  (`held_counts`) and whose share passes the least late reading's threshold by the deadline
  (`held_past`, by Bernoulli's inequality, `bernoulli_powers`).
* **Witness** (`Window`). Take `a = 1`, nothing shared, a cost of three, five read as coming back
  where a shaper reads, two where another does and nothing once the others read the loss, one
  shaper to one other, the rule read at every step.
  - Read from step 2, the course is locked the other way for good from step 4 (`Window.in_time`).
  - Read from step 3, the rule in force at step 4 favours the others, yet the course is not turned
    for good, and from step 6 it is locked in the shapers' favour for good (`Window.too_late`).
    The late reading still favours the others at the share of step 3; it comes one step too late.
  - Read from step 4 or any later step, by any reading of this form, the course stays locked in
    the shapers' favour for good (`Window.late_kept`).
  - The deadline is 24, the rule read at the start being 9 to 8 (`Window.by_deadline`).

Standing: elementary, a weighted majority read one step late. In this model it is the dilemma of
Collingridge (1980): control is easy while the need for it is not yet read, and hard once it is.
Lock-in and its timing (David 1985, Arthur 1989) and the tipping models (Schelling 1978,
Granovetter 1978) are credited. What it adds is the join on the spine: the exact window, its lag of
one step, and a deadline.

What is not derived: that actual rules are read by readers drawn from those they select, each kind
counted as the population counts it; that the others read the loss at all; that their late reading
has this form, the same `a`, `p` and `c` with what comes back read as a natural number (a late
reading of another form, such as one reading a larger cost, is not stated, and its window differs).
The deadline is a bound linear in the start's counts, not the step from which the window is closed
(24 in the witness, closed from step 4), and none is stated where the start's rule favours the
shapers only weakly or no shaper is present. Courses with noise, readers who learn, and a ranking
of courses (that needs C) are not stated. The representation commits to discrete steps, a fixed
schedule of reading steps and natural-number amounts. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace ReadInTime

open Pace RuleCapture ClosedCapture

/-! ## The rule read once the others read the loss -/

/-- **The rule read once the others read the loss**: the shapers among the readers read the rule
after shaping with `hi` coming back to the shapers, whatever the loss; the others with `lo` while the
loss is below `N` and with `lo'` from then on, all with the same `a`, `p` and `c`
(`ClosedCapture.Thinned.lossPool`). -/
abbrev lossRead (a p c hi lo lo' N : Nat) (pos : 0 < a) :
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

/-- **Kept, exactly.** At a reading step `r` at which the loss has reached its bound and the rule in
force favours the shapers, `lo' ≤ hi`: the course is locked under the late reading at every step from
`r + 1` exactly where, at the share at `r`, what the readers read as coming back to the shapers covers
the cost, `x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo'`. -/
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

/-- Every step adds at least one to the loss. -/
theorem loss_next (accrues : Accrues fB) (s : (CarrierCounts × Nat) × CarrierCounts) (r : Nat) :
    (course fB a p c hi lo lo' N pos reads s r).1.2 + 1 ≤
      (course fB a p c hi lo lo' N pos reads s (r + 1)).1.2 :=
  Eq.subst (motive := fun q : CarrierCounts × Nat => (course fB a p c hi lo lo' N pos reads s r).1.2 + 1 ≤ q.2)
    (paced_fast_succ (f := join CarrierCounts.select fB) (h := lossRead a p c hi lo lo' N pos)
      (reads := reads) s r).symm
    (accrues _ _)

/-- **Turned, exactly, one step late.** At a reading step `r` at which the loss has reached its bound
and the late reading favours the others at the share there (ties included), `lo' ≤ hi`, the step
`r + 1` reading too: the course is locked the other way under the late reading at every step from
`r + 2` exactly where the late reading favours the others at the share at `r + 1`, which was selected
under the rule in force at `r`. -/
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
theorem lossRead_before {ℓ : Nat} (lt : ℓ < N) (x g : CarrierCounts) :
    lossRead a p c hi lo lo' N pos (x, ℓ) g = DrawnShaping.drawn a p c hi lo pos x :=
  show (match Nat.ble (ℓ + 1) N with
      | true => Drawn.pool (RuleShaping.shaped a hi p c pos) (RuleShaping.shaped a lo p c pos) x
      | false => Drawn.pool (RuleShaping.shaped a hi p c pos) (RuleShaping.shaped a lo' p c pos) x) = _ by
    rw [Nat.ble_eq_true_of_le (show ℓ + 1 ≤ N from lt)]
    exact rfl

/-- One turn below the bound is MA4's turn on the share and the rule, and adds one to the loss. -/
theorem turn_before :
    ∀ (b : Bool) (q : (CarrierCounts × Nat) × CarrierCounts), q.1.2 < N →
      ((turn (join CarrierCounts.select Beyond.lossStep) (lossRead a p c hi lo lo' N pos) b q).1.1,
          (turn (join CarrierCounts.select Beyond.lossStep) (lossRead a p c hi lo lo' N pos) b q).2) =
        turn CarrierCounts.select (DrawnShaping.drawnRead a p c hi lo pos) b (q.1.1, q.2) ∧
      (turn (join CarrierCounts.select Beyond.lossStep) (lossRead a p c hi lo lo' N pos) b q).1.2 =
        q.1.2 + 1
  | true, ((x, _), g), lt =>
    ⟨congrArg (Prod.mk (CarrierCounts.select x g)) (lossRead_before (lo' := lo') lt x g), rfl⟩
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
      (h := lossRead a p c hi lo lo' N pos) (reads := reads)
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
      (h := lossRead a p c hi lo lo' N pos) (reads := reads)
      ((x, 0), DrawnShaping.drawn a p c hi lo pos x) N)).trans
    ((congrArg (fun q : CarrierCounts × CarrierCounts => CarrierCounts.select q.1 q.2) E.1).trans
      (paced_fast_succ (f := CarrierCounts.select) (h := DrawnShaping.drawnRead a p c hi lo pos)
        (reads := reads) (x, DrawnShaping.drawn a p c hi lo pos x) N).symm)

/-! ## The window, in MA4's course -/

/-- **Along MA4's course the late reading never falls.** From a start the rule read there favours,
`lo ≤ hi` and `lo' ≤ hi`: the late reading at the share of step `t + d` of MA4's course is not below
that at step `t`, since it reads a share that never falls. -/
theorem late_rises (step : lo ≤ hi) (readers : lo' ≤ hi) {x : CarrierCounts}
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
  have read := late_rises (reads := reads) (lo' := lo') step readers fav N 1
  ⟨fun turned => Eq.mp moved
      (Eq.subst (motive := CarrierCounts.disfavours)
        (Thinned.rule_read Thinned.lossStep_accrues at_next past') (turned 0).1),
   fun later =>
    (turned_iff Thinned.lossStep_accrues readers at_N at_next past
      (Eq.subst (motive := fun q : CarrierCounts × CarrierCounts =>
          CarrierCounts.disfavours (DrawnShaping.drawn a p c hi lo' pos q.1)) E.1.symm
        (CarrierCounts.lower read later))).mpr (Eq.mpr moved later)⟩

/-- **In time, late, or the one step between.** From a start the rule read there favours, `lo ≤ hi`
and `lo' ≤ hi`: at most one step of MA4's course has the late reading favouring the others strictly
at its share and the shapers strictly at the share of the next step. So at every step `N` but at
most one, a reading from `N` keeps the lock for good (`kept_early_iff`) or turns the course for good
(`turned_early_iff`). -/
theorem one_between (step : lo ≤ hi) (readers : lo' ≤ hi) {x : CarrierCounts}
    (fav : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo pos x)) {N M : Nat}
    (atN : ¬ CarrierCounts.favours
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x N).1) ∧
      ¬ CarrierCounts.disfavours
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x (N + 1)).1))
    (atM : ¬ CarrierCounts.favours
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x M).1) ∧
      ¬ CarrierCounts.disfavours
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x (M + 1)).1)) :
    N = M :=
  have after : ∀ {n m : Nat}, ¬ CarrierCounts.disfavours
      (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x (n + 1)).1) →
      n + 1 ≤ m →
      CarrierCounts.favours
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x m).1) :=
    fun {n m} strict le =>
      CarrierCounts.upper
        (Eq.subst (motive := fun j => CarrierCounts.order.le
            (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x (n + 1)).1)
            (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x j).1))
          (add_sub_of_le le) (late_rises step readers fav (n + 1) (m - (n + 1))))
        (Nat.le_of_lt (Nat.gt_of_not_le strict))
  Nat.le_antisymm (Nat.le_of_not_lt fun lt => atN.1 (after atM.2 lt))
    (Nat.le_of_not_lt fun lt => atM.1 (after atN.2 lt))

/-! ## The window closes -/

/-- **Once the late reading would favour the shapers, every later reading keeps the lock.** From a
start the rule read there favours, `lo ≤ hi` and `lo' ≤ hi`: where the late reading favours the
shapers at the share of step `s` of MA4's course, the others reading the loss from step `s + d`, a
reading step, leave the course locked in the shapers' favour at every step from `s + d + 1`. -/
theorem closed_kept (step : lo ≤ hi) (readers : lo' ≤ hi) {x : CarrierCounts}
    (fav : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo pos x)) {s : Nat}
    (closed : CarrierCounts.favours
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
    CarrierCounts.upper (late_rises step readers fav s d) closed
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
the shapers favours them, every late reading of this form does. -/
theorem least {x : CarrierCounts} (none : CarrierCounts.favours (DrawnShaping.drawn a p c hi 0 pos x))
    (lo' : Nat) : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo' pos x) :=
  DrawnShaping.drawn_favours_iff.mpr (Nat.le_trans (DrawnShaping.drawn_favours_iff.mp none)
    (Nat.add_le_add_left (Nat.mul_le_mul_left x.other (Nat.zero_le lo')) _))

/-- With what comes back to the shapers at least the cost where a shaper reads, the least late
reading favours the shapers exactly where `x.other * c ≤ x.carrier * (hi - c)`. -/
theorem least_iff (covers : c ≤ hi) {x : CarrierCounts} :
    CarrierCounts.favours (DrawnShaping.drawn a p c hi 0 pos x) ↔ x.other * c ≤ x.carrier * (hi - c) :=
  DrawnShaping.critical_iff (Nat.zero_le c) covers

/-- **Past the least reading's threshold, no reading of this form turns the course.** From a start
the rule read there favours, `lo ≤ hi` and `lo' ≤ hi`: where the least late reading favours the
shapers at step `s` of MA4's course, the others reading the loss with `lo'` from step `s + d`, a
reading step, leave the course locked in the shapers' favour at every step from `s + d + 1`. -/
theorem closed_for_every (step : lo ≤ hi) (readers : lo' ≤ hi) {x : CarrierCounts}
    (fav : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo pos x)) {s : Nat}
    (closed : CarrierCounts.favours
      (DrawnShaping.drawn a p c hi 0 pos (DrawnShaping.drawnCourse a p c hi lo pos reads x s).1))
    (d : Nat) (at_N : reads (s + d) = true) (k : Nat) :
    Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead a p c hi lo' pos)
      ((lossCourse a p c hi lo lo' (s + d) pos reads x (s + d + (1 + k))).1.1,
        (lossCourse a p c hi lo lo' (s + d) pos reads x (s + d + (1 + k))).2) :=
  closed_kept step readers fav (least closed lo') d at_N k

/-! ## The window closes by a deadline -/

/-- The share after `t` steps of selection by the rule `g` held fixed. -/
def held (x g : CarrierCounts) : Nat → CarrierCounts
  | 0 => x
  | t + 1 => CarrierCounts.select (held x g t) g

/-- Held fixed, the rule multiplies the carriers and the others by its powers. -/
theorem held_counts (x g : CarrierCounts) :
    ∀ t, (held x g t).carrier = x.carrier * powers g.carrier t ∧
      (held x g t).other = x.other * powers g.other t
  | 0 => ⟨(Nat.mul_one _).symm, (Nat.mul_one _).symm⟩
  | t + 1 =>
    have ih := held_counts x g t
    ⟨(congrArg (· * g.carrier) ih.1).trans ((mul_assoc_nat _ _ _).trans
        (congrArg (x.carrier * ·) (Nat.mul_comm _ _))),
     (congrArg (· * g.other) ih.2).trans ((mul_assoc_nat _ _ _).trans
        (congrArg (x.other * ·) (Nat.mul_comm _ _)))⟩

/-- Powers of a larger base are not smaller. -/
theorem powers_base_le {b b' : Nat} (le : b ≤ b') : ∀ t, powers b t ≤ powers b' t
  | 0 => Nat.le_refl 1
  | t + 1 => Nat.mul_le_mul le (powers_base_le le t)

/-- **MA4's course is never below the course with the start's rule held fixed**: from a start the
rule read there favours, `lo ≤ hi`, the rule in force is never below the start's. -/
theorem held_le (step : lo ≤ hi) {x : CarrierCounts}
    (fav : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo pos x)) :
    ∀ t, CarrierCounts.order.le (held x (DrawnShaping.drawn a p c hi lo pos x) t)
      (DrawnShaping.drawnCourse a p c hi lo pos reads x t).1
  | 0 => CarrierCounts.order.refl _
  | t + 1 =>
    Eq.subst (motive := fun y =>
        CarrierCounts.order.le (held x (DrawnShaping.drawn a p c hi lo pos x) (t + 1)) y)
      (paced_fast_succ (f := CarrierCounts.select) (h := DrawnShaping.drawnRead a p c hi lo pos)
        (reads := reads) (x, DrawnShaping.drawn a p c hi lo pos x) t).symm
      (CarrierCounts.select_mono (held_le step fav t) (DrawnShaping.drawn_locks (reads := reads) step fav t).2.2)

/-- **Held, a rule favouring strictly carries the share past the least late reading's threshold** by
step `g.other * c * x.other`, at least one carrier present and `c < hi` (Bernoulli's inequality,
`bernoulli_powers`). -/
theorem held_past (covers : c < hi) {x g : CarrierCounts} (some : 0 < x.carrier)
    (strict : g.other < g.carrier) {t : Nat} (late : g.other * c * x.other ≤ t) :
    (held x g t).other * c ≤ (held x g t).carrier * (hi - c) :=
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
  Eq.subst (motive := fun n => n * c ≤ (held x g t).carrier * (hi - c)) counts.2.symm
    (Eq.subst (motive := fun n => x.other * powers g.other t * c ≤ n * (hi - c)) counts.1.symm
      (Nat.le_trans cancel scaled))

/-- **The window closes by a deadline.** From a start with at least one shaper whose rule read there
favours the shapers strictly, `lo ≤ hi`, `lo' ≤ hi` and `c < hi`: the others reading the loss with any
`lo'` from a reading step `N` not before `g.other * c * x.other`, `g` the rule read at the start, leave
the course locked in the shapers' favour at every step from `N + 1`. The deadline holds under every
schedule of reading steps; it is a bound, linear in the start's counts, not the step at which the
window closes. -/
theorem deadline (step : lo ≤ hi) (readers : lo' ≤ hi) (covers : c < hi) {x : CarrierCounts}
    (some : 0 < x.carrier)
    (strict : (DrawnShaping.drawn a p c hi lo pos x).other < (DrawnShaping.drawn a p c hi lo pos x).carrier)
    {N : Nat} (late : (DrawnShaping.drawn a p c hi lo pos x).other * c * x.other ≤ N)
    (at_N : reads N = true) (k : Nat) :
    Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead a p c hi lo' pos)
      ((lossCourse a p c hi lo lo' N pos reads x (N + (1 + k))).1.1,
        (lossCourse a p c hi lo lo' N pos reads x (N + (1 + k))).2) :=
  have fav : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo pos x) := Nat.le_of_lt strict
  have past := (least_iff (a := a) (p := p) (pos := pos) (Nat.le_of_lt covers)).mpr
    (held_past covers some strict late)
  have closed : CarrierCounts.favours
      (DrawnShaping.drawn a p c hi 0 pos (DrawnShaping.drawnCourse a p c hi lo pos reads x N).1) :=
    CarrierCounts.upper
      (Drawn.pool_reads (DrawnShaping.shaped_le_iff.mpr (Nat.zero_le hi)) _ _
        (DrawnShaping.drawn a p c hi lo pos x) (DrawnShaping.drawn a p c hi lo pos x)
        (held_le (reads := reads) step fav N))
      past
  (kept_early_iff step readers fav at_N).mpr (least closed lo') k

/-! ### Witness: a reading in time, one step too late, and late

`a = 1`, nothing shared, a cost of three; five read as coming back where a shaper reads, two where
another does, and nothing once the others read the loss; one shaper to one other; the rule read at
every step. -/

namespace Window

theorem one_pos : 0 < 1 := Nat.zero_lt_one

/-- One shaper to one other. -/
def even : CarrierCounts := ⟨1, 1, Nat.zero_lt_one⟩

/-- The course in which the others read the loss from step `N`. -/
abbrev readFrom (N t : Nat) : (CarrierCounts × Nat) × CarrierCounts :=
  lossCourse 1 0 3 5 2 0 N one_pos (fun _ => true) even t

/-- **Read in time.** Read from step 2, the course is locked the other way at every step from step
4: the late reading favours the others at the shares of steps 2 and 3, 550 to 580 and 42260 to
42680. -/
theorem in_time (k : Nat) :
    Locked (reverse CarrierCounts.order) CarrierCounts.disfavours (DrawnShaping.drawnRead 1 0 3 5 0 one_pos)
      ((readFrom 2 (2 + 1 + (1 + k))).1.1, (readFrom 2 (2 + 1 + (1 + k))).2) :=
  (turned_iff (fB := Beyond.lossStep) (a := 1) (p := 0) (c := 3) (hi := 5) (lo := 2) (lo' := 0) (N := 2)
      (pos := one_pos) (reads := fun _ => true) (s := ((even, 0), DrawnShaping.drawn 1 0 3 5 2 one_pos even))
      (r := 2) Thinned.lossStep_accrues (Nat.zero_le 5) rfl rfl
      (show 2 ≤ 2 from Nat.le_refl 2) (show 550 ≤ 580 by decide)).mpr
    (show 42260 ≤ 42680 by decide) k

/-- **One step too late.** Read from step 3, though the late reading still favours the others at the
share of step 3 (42260 to 42680) and the rule in force at step 4 favours them, the course is not
locked the other way from step 5 on, the late reading favouring the shapers at the share of step 4;
and from step 6 it is locked in the shapers' favour for good. -/
theorem too_late :
    CarrierCounts.disfavours (DrawnShaping.drawn 1 0 3 5 0 one_pos (readFrom 3 3).1.1) ∧
      CarrierCounts.disfavours (readFrom 3 4).2 ∧
      (¬ ∀ k, Locked (reverse CarrierCounts.order) CarrierCounts.disfavours
          (DrawnShaping.drawnRead 1 0 3 5 0 one_pos)
          ((readFrom 3 (3 + 1 + (1 + k))).1.1, (readFrom 3 (3 + 1 + (1 + k))).2)) ∧
      ∀ k, Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead 1 0 3 5 0 one_pos)
        ((readFrom 3 (5 + (1 + k))).1.1, (readFrom 3 (5 + (1 + k))).2) :=
  ⟨show 42260 ≤ 42680 by decide, show 42260 ≤ 42680 by decide,
   fun turned => absurd
     ((turned_iff (fB := Beyond.lossStep) (a := 1) (p := 0) (c := 3) (hi := 5) (lo := 2) (lo' := 0) (N := 3)
        (pos := one_pos) (reads := fun _ => true) (s := ((even, 0), DrawnShaping.drawn 1 0 3 5 2 one_pos even))
        (r := 3) Thinned.lossStep_accrues (Nat.zero_le 5) rfl rfl
        (show 3 ≤ 3 from Nat.le_refl 3) (show 42260 ≤ 42680 by decide)).mp turned)
     (show ¬ 28225784 ≤ 27231056 by decide),
   fun k => ((kept_iff (fB := Beyond.lossStep) (a := 1) (p := 0) (c := 3) (hi := 5) (lo := 2) (lo' := 0)
      (N := 3) (pos := one_pos) (reads := fun _ => true)
      (s := ((even, 0), DrawnShaping.drawn 1 0 3 5 2 one_pos even)) (r := 5) Thinned.lossStep_accrues
      (Nat.zero_le 5) rfl (show 3 ≤ 5 by decide) (show 27231056 ≤ 28225784 by decide)).mpr
      (show 543075315120 + 323193446400 ≤ 905125525200 + 0 by decide)) k⟩

/-- **Read late.** From step 4 on the least late reading favours the shapers (27231056 to 28225784),
so the others reading the loss from step `4 + d` with any `lo' ≤ 5` leave the course locked in the
shapers' favour at every step from `4 + d + 1`. -/
theorem late_kept (lo' : Nat) (readers : lo' ≤ 5) (d k : Nat) :
    Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead 1 0 3 5 lo' one_pos)
      ((lossCourse 1 0 3 5 2 lo' (4 + d) one_pos (fun _ => true) even (4 + d + (1 + k))).1.1,
        (lossCourse 1 0 3 5 2 lo' (4 + d) one_pos (fun _ => true) even (4 + d + (1 + k))).2) :=
  closed_for_every (a := 1) (p := 0) (c := 3) (hi := 5) (lo := 2) (lo' := lo') (pos := one_pos)
    (reads := fun _ => true) (x := even) (s := 4) (show 2 ≤ 5 by decide) readers (show 8 ≤ 9 by decide)
    (show 27231056 ≤ 28225784 by decide) d rfl k

/-- **The deadline, in the witness.** The rule read at the start is 9 to 8, so the deadline is
`8 * 3 * 1 = 24`, well after step 4, from which the window is closed. -/
theorem by_deadline (lo' : Nat) (readers : lo' ≤ 5) (d k : Nat) :
    Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead 1 0 3 5 lo' one_pos)
      ((lossCourse 1 0 3 5 2 lo' (24 + d) one_pos (fun _ => true) even (24 + d + (1 + k))).1.1,
        (lossCourse 1 0 3 5 2 lo' (24 + d) one_pos (fun _ => true) even (24 + d + (1 + k))).2) :=
  deadline (a := 1) (p := 0) (c := 3) (hi := 5) (lo := 2) (lo' := lo') (pos := one_pos)
    (reads := fun _ => true) (x := even) (show 2 ≤ 5 by decide) readers (show 3 < 5 by decide)
    (show 0 < 1 by decide) (show 8 < 9 by decide) (show 24 ≤ 24 + d from Nat.le_add_right 24 d) rfl k

end Window

end ReadInTime

end Becoming
