import Becoming.RuleShaping
import Becoming.ClosedCapture

/-!
# Drawn shaping: what comes back to the shapers, read by readers drawn from the selected

`Becoming.RuleShaping` states what selects the capacity to shape the rule when that capacity is
carried from parent to offspring: at a step the rule after shaping favours the shapers exactly where
what comes back to them alone covers the cost, and where what comes back is read from their share,
monotone in it and covering the cost, the loop locks (`RuleShaping.covering_locks`). That what comes
back is so read is the loop's premise, equivalent there to `ReadsShare`
(`RuleShaping.byBack_reads_iff`). `Becoming.ClosedCapture` states where `ReadsShare` comes from when
the rule is read by readers drawn from those it selects, each kind counted as the population counts
it: the rule read reads the share exactly where each carrier's reading favours the carriers at least
as much as each other's (`ClosedCapture.Drawn.pool_reads_iff`). This module joins the two. The rule
after shaping is read by readers drawn from the population: each shaper among the readers reads what
comes back to the shapers alone as `hi`, each other as `lo`, and the rule read gives each kind the sum
of the two readings, each counted as the population counts its readers (`drawn`, `drawnBack`). With no
premise beyond the hypotheses each statement names:

* **The loop's premise from who reads.** The rule read reads the share exactly where `lo ≤ hi`
  (`drawn_reads_iff`): the premise of `RuleShaping`'s loop holds exactly where the shapers among the
  readers give the shapers at least as much back as the others among them do.
* **A critical mass.** At a share the rule read favours the shapers exactly where
  `x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo` (`drawn_favours_iff`), whatever each
  leaves without shaping and whatever comes to every member alike (`drawn_favours_alike`). With
  `lo ≤ c ≤ hi` this is `x.other * (c - lo) ≤ x.carrier * (hi - c)` (`critical_iff`): the shapers stand
  to the others at least as `c - lo` to `hi - c`. With readers alike (`lo = hi = s`) it is `c ≤ s` at
  every share, `RuleShaping.favours_iff` again, and no share decides (`alike_favours_iff`). Outside
  that range no share decides either: the rule read favours the shapers at every share exactly where
  the others among the readers give back at least the cost (`favours_everywhere_iff`), and where the
  shapers among them give back less than it, it favours the others strictly at every share
  (`disfavours_everywhere`).
* **One loop.** From a start where the rule read favours the shapers, under the rule read there,
  every configuration of the course is locked and neither the shapers' share nor the rule in force is
  ever below where it started (`drawn_locks`); from a start where it favours the others, the rule in
  force keeps favouring the others and neither the share nor the rule is ever above where it started
  (`drawn_from_below`); `lo ≤ hi`, under every schedule of reading. Where the start favours the
  shapers strictly, their share rises strictly at every step, the shapers present (`drawn_rises`);
  where it favours the others strictly, it falls strictly at every step, the shapers present at the
  start (`drawn_falls`).
* **Witness** (`CriticalMass`). With `a = 1`, nothing shared, a cost of one, three coming back where a
  shaper reads and none where another does: from one shaper to each other the rule read favours the
  shapers strictly, five offspring to four (`CriticalMass.even_favours`), so the course is locked from
  the start and their share rises at every step (`CriticalMass.even_locks`, `CriticalMass.even_rises`);
  from one shaper to three others it favours the others strictly, seven to eight
  (`CriticalMass.few_disfavours`), and their share falls at every step (`CriticalMass.few_falls`); at
  one to two each kind leaves six (`CriticalMass.at_mass`). In both starts each shaper's own readers
  give back three times the cost, so that does not decide; how many of the readers are shapers does.

So where the rule is read by readers drawn from those it selects, the selection of the capacity to
shape it and the lock of the rule it shapes are one loop with a critical mass: from a share at which
what the readers drawn from the population give back covers the cost, the capacity is never again
lower and the rule stays locked in the shapers' favour; from a share at which it does not, the
capacity is never again higher and the rule stays locked in the others' favour. Either way the rule
locks; the critical mass decides which way. What every member receives does not move the critical
mass; what the others among the readers give back (`lo`), what the shapers among them give back
(`hi`) and the cost (`c`) do.

**Readings (the AI's, decided by their place in one account, DELEGATED-CHOICES D45).**
- The meta-attractor's two failures together, control over the selection selected and the rule it
  shapes locked: where the rule's readers are drawn from those it selects and each shaper among them
  gives the shapers at least as much back as each other among them, the two are one loop from above
  the critical mass (`drawn_locks`).
- Below the critical mass control over the selection is not selected, but the rule is still read
  from the share and locks the other way, in favour of those without the capacity
  (`drawn_from_below`). So the first of the joint selection's conditions (control not selected) does
  not give the second (a lock left in time): where readers are drawn from the selected, keeping
  control unselected leaves the rule locked by the share all the same.
- A capacity whose own readers repay it more than it costs is not thereby selected: below the
  critical mass it falls (`CriticalMass.few_falls`). Readers drawn from the others that give the
  shapers nothing back (`lo = 0`) put the critical mass at `c` shapers to `hi - c` others. Where even
  the shapers' own readers give back less than the cost, the capacity falls at every share
  (`disfavours_everywhere`, `drawn_falls`).

What is not derived: that actual rules are read by readers drawn from those they select, each kind
counted as the population counts it, or that the shapers among the readers give the shapers more back
than the others do (the loop's premise, moved to who reads by `drawn_reads_iff`, not shown of any
actual rule); transmission of the capacity (a premise as in `Becoming.Capture`); which actual rules
can be shaped, at what cost, and how much comes back. `hi`, `lo`, `p` and `c` are constants: readers
do not learn, the cost does not change with the share, and the readers are counted exactly as the
population counts them. A loss read by part of the readers (`ClosedCapture.Thinned`) is not joined
here. The representation commits to discrete steps, natural counts and others present. Nothing here
says that capture damages or supports 生生: ranking courses needs C. No ethical predicate, ranking or
axiom occurs.
-/

namespace Becoming

namespace DrawnShaping

open Pace RuleCapture

/-! ## The rule read by readers drawn from the selected -/

/-- **The rule after shaping, read by readers drawn from the selected**, at the population `x`: each
shaper among the readers reads the rule after shaping with `hi` coming back to the shapers alone, each
other with `lo`, and the rule read gives each kind the sum of the two readings, each counted as `x`
counts its readers (`ClosedCapture.Drawn.pool`). -/
def drawn (a p c hi lo : Nat) (pos : 0 < a) (x : CarrierCounts) : CarrierCounts :=
  ClosedCapture.Drawn.pool (RuleShaping.shaped a hi p c pos) (RuleShaping.shaped a lo p c pos) x

/-- The rule read at a reading step, from the population alone. -/
def drawnBack (a p c hi lo : Nat) (pos : 0 < a) (x _ : CarrierCounts) : CarrierCounts :=
  drawn a p c hi lo pos x

/-- The course from the population `x` under the rule read there. -/
def drawnCourse (a p c hi lo : Nat) (pos : 0 < a) (reads : Nat → Bool) (x : CarrierCounts) (t : Nat) :
    CarrierCounts × CarrierCounts :=
  paced CarrierCounts.select (drawnBack a p c hi lo pos) reads (x, drawn a p c hi lo pos x) t

/-! ## The loop's premise from who reads -/

/-- Two rules after shaping, alike but for what comes back to the shapers alone: one is not lower in
the share order than the other exactly where what comes back in it is not less. -/
theorem shaped_le_iff {a s s' p c : Nat} {pos : 0 < a} :
    CarrierCounts.order.le (RuleShaping.shaped a s p c pos) (RuleShaping.shaped a s' p c pos) ↔ s ≤ s' :=
  ⟨fun le => Naturals.le_of_add_le_add_left (Naturals.le_of_add_le_add_right
      (Nat.le_of_mul_le_mul_right (show (a + s + p) * (a + c + p) ≤ (a + s' + p) * (a + c + p) from le)
        (RuleShaping.shaped a s p c pos).other_pos)),
   fun le => Nat.mul_le_mul_right _ (Nat.add_le_add_right (Nat.add_le_add_left le a) p)⟩

/-- **The loop's premise from who reads.** The rule read by readers drawn from the selected reads the
share exactly where each shaper among the readers gives the shapers at least as much back as each
other among them. -/
theorem drawn_reads_iff {a p c hi lo : Nat} {pos : 0 < a} :
    ReadsShare CarrierCounts.order CarrierCounts.order (drawnBack a p c hi lo pos) ↔ lo ≤ hi :=
  (ClosedCapture.Drawn.pool_reads_iff (u := RuleShaping.shaped a hi p c pos)
    (v := RuleShaping.shaped a lo p c pos)).trans shaped_le_iff

/-! ## The critical mass -/

/-- `x * (a + s + p)` split into its part from `s` and its part from `a + p`. -/
theorem mul_split (x a s p : Nat) : x * (a + s + p) = x * s + x * (a + p) := by
  rw [Nat.add_comm a s, Nat.add_assoc s a p, Nat.mul_add]

/-- What the rule read gives a kind, split into the part from what comes back and the base. -/
theorem drawn_split (x y a p s t : Nat) :
    x * (a + s + p) + y * (a + t + p) = (x * s + y * t) + (x * (a + p) + y * (a + p)) := by
  rw [mul_split x a s p, mul_split y a t p]
  exact Nat.add_add_add_comm _ _ _ _

/-- **At a share, the rule read favours the shapers exactly where what the readers give back covers
the cost**: `x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo`. -/
theorem drawn_favours_iff {a p c hi lo : Nat} {pos : 0 < a} {x : CarrierCounts} :
    CarrierCounts.favours (drawn a p c hi lo pos x) ↔
      x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo := by
  show x.carrier * (a + c + p) + x.other * (a + c + p) ≤ x.carrier * (a + hi + p) + x.other * (a + lo + p) ↔
    x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo
  rw [drawn_split x.carrier x.other a p c c, drawn_split x.carrier x.other a p hi lo]
  exact ⟨Naturals.le_of_add_le_add_right, fun le => Nat.add_le_add_right le _⟩

/-- **What each leaves without shaping and what comes to every member alike do not move it.** -/
theorem drawn_favours_alike {a a' p p' c hi lo : Nat} {pos : 0 < a} {pos' : 0 < a'} {x : CarrierCounts} :
    CarrierCounts.favours (drawn a p c hi lo pos x) ↔ CarrierCounts.favours (drawn a' p' c hi lo pos' x) :=
  drawn_favours_iff.trans drawn_favours_iff.symm

/-- **The critical mass.** With what the others among the readers give back at most the cost and what
the shapers among them give back at least it, the rule read favours the shapers exactly where they
stand to the others at least as `c - lo` to `hi - c`. -/
theorem critical_iff {a p c hi lo : Nat} {pos : 0 < a} {x : CarrierCounts} (short : lo ≤ c)
    (covers : c ≤ hi) :
    CarrierCounts.favours (drawn a p c hi lo pos x) ↔ x.other * (c - lo) ≤ x.carrier * (hi - c) :=
  match le_dest short, le_dest covers with
  | ⟨d, hd⟩, ⟨e, he⟩ => by
    subst hd
    subst he
    refine drawn_favours_iff.trans ?_
    rw [Naturals.add_sub_cancel_left lo d, Naturals.add_sub_cancel_left (lo + d) e,
      Nat.mul_add x.other lo d, Nat.mul_add x.carrier (lo + d) e,
      ← Nat.add_assoc (x.carrier * (lo + d)) (x.other * lo) (x.other * d),
      Nat.add_right_comm (x.carrier * (lo + d)) (x.carrier * e) (x.other * lo)]
    exact ⟨Naturals.le_of_add_le_add_left, fun le => Nat.add_le_add_left le _⟩

/-- **Readers alike decide nothing by share.** Where the shapers and the others among the readers give
the shapers alike back, the rule read favours them exactly where the cost is at most what comes back,
at every share alike (`RuleShaping.favours_iff`). -/
theorem alike_favours_iff {a p c s : Nat} {pos : 0 < a} {x : CarrierCounts} :
    CarrierCounts.favours (drawn a p c s s pos x) ↔ c ≤ s := by
  refine drawn_favours_iff.trans ?_
  rw [← add_mul_split x.carrier x.other c, ← add_mul_split x.carrier x.other s]
  exact ⟨fun le => Nat.le_of_mul_le_mul_left le (Nat.lt_of_lt_of_le x.other_pos (Nat.le_add_left _ _)),
    fun le => Nat.mul_le_mul_left _ le⟩

/-- No shapers, one other. -/
def noShapers : CarrierCounts := ⟨0, 1, Nat.zero_lt_one⟩

/-- **Favoured at every share.** `lo ≤ hi`: the rule read favours the shapers at every share exactly
where the others among the readers give back at least the cost. -/
theorem favours_everywhere_iff {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) :
    (∀ x, CarrierCounts.favours (drawn a p c hi lo pos x)) ↔ c ≤ lo :=
  ⟨fun every =>
    have at_none : 0 * c + 1 * c ≤ 0 * hi + 1 * lo := drawn_favours_iff.mp (every noShapers)
    by
      rw [Nat.zero_mul, Nat.zero_mul, Nat.one_mul, Nat.one_mul, Nat.zero_add, Nat.zero_add] at at_none
      exact at_none,
   fun le _ => drawn_favours_iff.mpr
    (Nat.add_le_add (Nat.mul_le_mul_left _ (Nat.le_trans le step)) (Nat.mul_le_mul_left _ le))⟩

/-- **Disfavoured at every share.** `lo ≤ hi`: where the shapers among the readers give back less
than the cost, the rule read favours the others strictly at every share. -/
theorem disfavours_everywhere {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) (short : hi < c)
    (x : CarrierCounts) : (drawn a p c hi lo pos x).carrier < (drawn a p c hi lo pos x).other := by
  show x.carrier * (a + hi + p) + x.other * (a + lo + p) < x.carrier * (a + c + p) + x.other * (a + c + p)
  rw [drawn_split x.carrier x.other a p hi lo, drawn_split x.carrier x.other a p c c]
  exact Nat.add_lt_add_right
    (Nat.lt_of_le_of_lt (Nat.add_le_add_right (Nat.mul_le_mul_left x.carrier (Nat.le_of_lt short)) _)
      (Nat.add_lt_add_left (Nat.mul_lt_mul_of_pos_left (Nat.lt_of_le_of_lt step short) x.other_pos) _)) _

/-! ## One loop -/

/-- **One loop, from above.** From a start where the rule read favours the shapers, under the rule
read there, every configuration of the course is locked, and neither the shapers' share nor the rule
in force is ever below where it started, `lo ≤ hi`, under every schedule of reading. -/
theorem drawn_locks {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) {reads : Nat → Bool}
    {x : CarrierCounts} (fav : CarrierCounts.favours (drawn a p c hi lo pos x)) (k : Nat) :
    Locked CarrierCounts.order CarrierCounts.favours (drawnBack a p c hi lo pos)
        (drawnCourse a p c hi lo pos reads x k) ∧
      CarrierCounts.order.le x (drawnCourse a p c hi lo pos reads x k).1 ∧
      CarrierCounts.order.le (drawn a p c hi lo pos x) (drawnCourse a p c hi lo pos reads x k).2 :=
  have mono := (drawn_reads_iff (a := a) (p := p) (c := c) (pos := pos)).mpr step
  have start : Locked CarrierCounts.order CarrierCounts.favours (drawnBack a p c hi lo pos)
      (paced CarrierCounts.select (drawnBack a p c hi lo pos) reads (x, drawn a p c hi lo pos x) 0) :=
    ⟨fav, CarrierCounts.order.refl _⟩
  Eq.subst (motive := fun n =>
      Locked CarrierCounts.order CarrierCounts.favours (drawnBack a p c hi lo pos)
          (drawnCourse a p c hi lo pos reads x n) ∧
        CarrierCounts.order.le x (drawnCourse a p c hi lo pos reads x n).1 ∧
        CarrierCounts.order.le (drawn a p c hi lo pos x) (drawnCourse a p c hi lo pos reads x n).2)
    (Nat.zero_add k)
    ⟨locked_stays CarrierCounts.raises mono CarrierCounts.upper start k,
     locked_not_below CarrierCounts.raises mono CarrierCounts.upper start k⟩

/-- **One loop, from below.** From a start where the rule read favours the others, under the rule read
there, the rule in force keeps favouring the others at every step, not above what the reading of the
share gives, and neither the shapers' share nor the rule in force is ever above where it started,
`lo ≤ hi`, under every schedule of reading. -/
theorem drawn_from_below {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) {reads : Nat → Bool}
    {x : CarrierCounts} (dis : CarrierCounts.disfavours (drawn a p c hi lo pos x)) (k : Nat) :
    Locked (reverse CarrierCounts.order) CarrierCounts.disfavours (drawnBack a p c hi lo pos)
        (drawnCourse a p c hi lo pos reads x k) ∧
      CarrierCounts.order.le (drawnCourse a p c hi lo pos reads x k).1 x ∧
      CarrierCounts.order.le (drawnCourse a p c hi lo pos reads x k).2 (drawn a p c hi lo pos x) :=
  have mono := ((drawn_reads_iff (a := a) (p := p) (c := c) (pos := pos)).mpr step).reverse
  have start : Locked (reverse CarrierCounts.order) CarrierCounts.disfavours (drawnBack a p c hi lo pos)
      (paced CarrierCounts.select (drawnBack a p c hi lo pos) reads (x, drawn a p c hi lo pos x) 0) :=
    ⟨dis, CarrierCounts.order.refl _⟩
  Eq.subst (motive := fun n =>
      Locked (reverse CarrierCounts.order) CarrierCounts.disfavours (drawnBack a p c hi lo pos)
          (drawnCourse a p c hi lo pos reads x n) ∧
        CarrierCounts.order.le (drawnCourse a p c hi lo pos reads x n).1 x ∧
        CarrierCounts.order.le (drawnCourse a p c hi lo pos reads x n).2 (drawn a p c hi lo pos x))
    (Nat.zero_add k)
    ⟨locked_stays CarrierCounts.lowers mono CarrierCounts.lower start k,
     locked_not_below CarrierCounts.lowers mono CarrierCounts.lower start k⟩

/-- A rule not lower than one favouring the shapers strictly favours them strictly. -/
theorem upper_strictly {g g' : CarrierCounts} (le : CarrierCounts.order.le g g')
    (lt : g.other < g.carrier) : g'.other < g'.carrier :=
  match Nat.lt_or_ge g'.other g'.carrier with
  | .inl h => h
  | .inr h => absurd
      (calc g'.other * g.other
          < g'.other * g.carrier := Nat.mul_lt_mul_of_pos_left lt g'.other_pos
        _ = g.carrier * g'.other := Nat.mul_comm _ _
        _ ≤ g'.carrier * g.other := le
        _ ≤ g'.other * g.other := Nat.mul_le_mul_right _ h)
      (Nat.lt_irrefl _)

/-- A rule not above one favouring the others strictly favours them strictly. -/
theorem lower_strictly {g g' : CarrierCounts} (le : CarrierCounts.order.le g' g)
    (lt : g.carrier < g.other) : g'.carrier < g'.other :=
  match Nat.lt_or_ge g'.carrier g'.other with
  | .inl h => h
  | .inr h => absurd
      (calc g'.other * g.other
          ≤ g'.carrier * g.other := Nat.mul_le_mul_right _ h
        _ ≤ g.carrier * g'.other := le
        _ < g.other * g'.other := Nat.mul_lt_mul_of_pos_right lt g'.other_pos
        _ = g'.other * g.other := Nat.mul_comm _ _)
      (Nat.lt_irrefl _)

/-- **From above strictly, the shapers' share rises strictly at every step**, the shapers present at
the start, `lo ≤ hi`, under every schedule of reading. -/
theorem drawn_rises {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) {reads : Nat → Bool}
    {x : CarrierCounts} (strict : (drawn a p c hi lo pos x).other < (drawn a p c hi lo pos x).carrier)
    (some : 0 < x.carrier) (t : Nat) :
    (drawnCourse a p c hi lo pos reads x t).1.carrier * (drawnCourse a p c hi lo pos reads x (t + 1)).1.other <
      (drawnCourse a p c hi lo pos reads x (t + 1)).1.carrier * (drawnCourse a p c hi lo pos reads x t).1.other :=
  have now := drawn_locks (reads := reads) step (Nat.le_of_lt strict) t
  CarrierCounts.rises_strictly_along (x, drawn a p c hi lo pos x) t
    (RuleShaping.present_of_le now.2.1 some) (upper_strictly now.2.2 strict)

/-- Every rule read by readers drawn from the selected gives each shaper at least one offspring. -/
theorem drawn_carrier_pos {a p c hi lo : Nat} {pos : 0 < a} (x : CarrierCounts) :
    0 < (drawn a p c hi lo pos x).carrier :=
  show 0 < x.carrier * (a + hi + p) + x.other * (a + lo + p) from
    Nat.lt_of_lt_of_le
      (Nat.mul_pos x.other_pos
        (Nat.lt_of_lt_of_le pos (Nat.le_trans (Nat.le_add_right a lo) (Nat.le_add_right (a + lo) p))))
      (Nat.le_add_left _ _)

/-- From a start whose rule gives each shaper an offspring and with shapers present, every rule in
force does and shapers stay present, under the reading by readers drawn from the selected. -/
theorem present_drawn {a p c hi lo : Nat} {pos : 0 < a} {reads : Nat → Bool} {x g : CarrierCounts}
    (gives : 0 < g.carrier) (some : 0 < x.carrier) : ∀ t,
    0 < (paced CarrierCounts.select (drawnBack a p c hi lo pos) reads (x, g) t).2.carrier ∧
      0 < (paced CarrierCounts.select (drawnBack a p c hi lo pos) reads (x, g) t).1.carrier
  | 0 => ⟨gives, some⟩
  | t + 1 =>
    have now := present_drawn (reads := reads) gives some t
    have fast : 0 < (paced CarrierCounts.select (drawnBack a p c hi lo pos) reads (x, g) (t + 1)).1.carrier :=
      Eq.subst (motive := fun y : CarrierCounts => 0 < y.carrier) (paced_fast_succ _ t).symm
        (Nat.mul_pos now.2 now.1)
    match q : reads t with
    | true =>
      ⟨Eq.subst (motive := fun r : CarrierCounts => 0 < r.carrier)
        ((congrArg Prod.snd (paced_succ (x, g) t)).trans
          (congrArg (fun b => (turn CarrierCounts.select (drawnBack a p c hi lo pos) b
            (paced CarrierCounts.select (drawnBack a p c hi lo pos) reads (x, g) t)).2) q)).symm
        (drawn_carrier_pos _), fast⟩
    | false =>
      ⟨Eq.subst (motive := fun r : CarrierCounts => 0 < r.carrier)
        ((congrArg Prod.snd (paced_succ (x, g) t)).trans
          (congrArg (fun b => (turn CarrierCounts.select (drawnBack a p c hi lo pos) b
            (paced CarrierCounts.select (drawnBack a p c hi lo pos) reads (x, g) t)).2) q)).symm
        now.1, fast⟩

/-- **From below strictly, the shapers' share falls strictly at every step**, the shapers present at
the start, `lo ≤ hi`, under every schedule of reading. -/
theorem drawn_falls {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) {reads : Nat → Bool}
    {x : CarrierCounts} (strict : (drawn a p c hi lo pos x).carrier < (drawn a p c hi lo pos x).other)
    (some : 0 < x.carrier) (t : Nat) :
    (drawnCourse a p c hi lo pos reads x (t + 1)).1.carrier * (drawnCourse a p c hi lo pos reads x t).1.other <
      (drawnCourse a p c hi lo pos reads x t).1.carrier * (drawnCourse a p c hi lo pos reads x (t + 1)).1.other :=
  have now := drawn_from_below (reads := reads) step (Nat.le_of_lt strict) t
  Eq.subst (motive := fun y : CarrierCounts =>
      y.carrier * (drawnCourse a p c hi lo pos reads x t).1.other <
        (drawnCourse a p c hi lo pos reads x t).1.carrier * y.other)
    (paced_fast_succ (x, drawn a p c hi lo pos x) t).symm
    (RuleShaping.falls_strictly
      (present_drawn (a := a) (p := p) (c := c) (hi := hi) (lo := lo) (pos := pos) (reads := reads)
        (drawn_carrier_pos x) some t).2
      (lower_strictly now.2.2 strict))

/-! ## A witness: the critical mass -/

namespace CriticalMass

theorem one_pos : 0 < 1 := Nat.zero_lt_one

/-- One shaper to each other. -/
def even : CarrierCounts := ⟨1, 1, Nat.zero_lt_one⟩

/-- One shaper to two others. -/
def oneToTwo : CarrierCounts := ⟨1, 2, Nat.zero_lt_succ 1⟩

/-- One shaper to three others. -/
def oneToThree : CarrierCounts := ⟨1, 3, Nat.zero_lt_succ 2⟩

/-- **From one to one, the rule read favours the shapers strictly**: with `a = 1`, nothing shared, a
cost of one, three coming back where a shaper reads and none where another does, each shaper leaves
five and each other four. -/
theorem even_favours : (drawn 1 0 1 3 0 one_pos even).other < (drawn 1 0 1 3 0 one_pos even).carrier := by
  decide

/-- **From one to three, it favours the others strictly**: each shaper leaves seven and each other
eight. -/
theorem few_disfavours :
    (drawn 1 0 1 3 0 one_pos oneToThree).carrier < (drawn 1 0 1 3 0 one_pos oneToThree).other := by
  decide

/-- **At one to two, each kind leaves alike**, six each: the critical mass. -/
theorem at_mass : (drawn 1 0 1 3 0 one_pos oneToTwo).carrier = (drawn 1 0 1 3 0 one_pos oneToTwo).other :=
  rfl

/-- From one to one the course is locked from the start and the shapers' share is never below one to
one, under every schedule of reading. -/
theorem even_locks {reads : Nat → Bool} (k : Nat) :
    Locked CarrierCounts.order CarrierCounts.favours (drawnBack 1 0 1 3 0 one_pos)
        (drawnCourse 1 0 1 3 0 one_pos reads even k) ∧
      CarrierCounts.order.le even (drawnCourse 1 0 1 3 0 one_pos reads even k).1 :=
  have locks := drawn_locks (reads := reads) (Nat.zero_le 3) (Nat.le_of_lt even_favours) k
  ⟨locks.1, locks.2.1⟩

/-- From one to one the shapers' share rises strictly at every step. -/
theorem even_rises {reads : Nat → Bool} (t : Nat) :
    (drawnCourse 1 0 1 3 0 one_pos reads even t).1.carrier *
        (drawnCourse 1 0 1 3 0 one_pos reads even (t + 1)).1.other <
      (drawnCourse 1 0 1 3 0 one_pos reads even (t + 1)).1.carrier *
        (drawnCourse 1 0 1 3 0 one_pos reads even t).1.other :=
  drawn_rises (Nat.zero_le 3) even_favours Nat.zero_lt_one t

/-- From one to three the shapers' share falls strictly at every step. -/
theorem few_falls {reads : Nat → Bool} (t : Nat) :
    (drawnCourse 1 0 1 3 0 one_pos reads oneToThree (t + 1)).1.carrier *
        (drawnCourse 1 0 1 3 0 one_pos reads oneToThree t).1.other <
      (drawnCourse 1 0 1 3 0 one_pos reads oneToThree t).1.carrier *
        (drawnCourse 1 0 1 3 0 one_pos reads oneToThree (t + 1)).1.other :=
  drawn_falls (Nat.zero_le 3) few_disfavours Nat.zero_lt_one t

end CriticalMass

end DrawnShaping

end Becoming
