import Becoming.RuleShaping
import Becoming.ClosedCapture
import Becoming.ChoiceCountCapture

/-!
# Drawn shaping: what comes back to the shapers, read by readers drawn from the selected

`Becoming.RuleShaping` states what selects the capacity to shape the rule when that capacity is
carried from parent to offspring: at a step the rule after shaping favours the shapers exactly where
what comes back to them alone covers the cost, and where what comes back is read from their share,
monotone in it and covering the cost, the loop locks (`RuleShaping.covering_locks`). That what comes
back is so read is the loop's premise, equivalent there to `ReadsShare`
(`RuleShaping.byBack_reads_iff`). `Becoming.ClosedCapture` states where `ReadsShare` comes from when
the rule is read by readers drawn from those it selects, each kind counted as the population counts
it: the rule read reads the share monotonically exactly where each carrier's reading favours the
carriers at least as much as each other's (`ClosedCapture.Drawn.pool_reads_iff`). This module joins
the two. The rule after shaping is read by readers drawn from the population: each shaper among the
readers reads what comes back to the shapers alone as `hi`, each other as `lo`, and the rule read
gives each kind the sum of the two readings, each counted as the population counts its readers
(`drawn`, `drawnRead`). Both kinds of reader read the same `a`, `p` and `c`. `favours` and
`disfavours` are weak: both hold where the two kinds leave alike. With no premise beyond the
hypotheses each statement names:

* **The loop's premise, moved to who reads.** The rule read reads the share monotonically exactly
  where `lo ≤ hi` (`drawn_reads_iff`): the premise of `RuleShaping`'s loop holds exactly where the
  shapers among the readers read at least as much coming back to the shapers as the others among
  them do. Where `hi ≤ lo` the rule read reads against the share (`drawn_against`).
* **A critical mass.** At a share the rule read favours the shapers exactly where
  `x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo` (`drawn_favours_iff`): the cost,
  counted over the readers, is at most what they read as coming back to the shapers, whatever each
  leaves without shaping and whatever comes to every member alike (`drawn_favours_alike`). With
  `lo ≤ c ≤ hi` this is `x.other * (c - lo) ≤ x.carrier * (hi - c)` (`critical_iff`): the shapers
  stand to the others at least as `c - lo` to `hi - c`. With readers alike (`lo = hi = s`) it is
  `c ≤ s` at every share, `RuleShaping.favours_iff` again (`alike_favours_iff`). With no hypothesis
  on the readers, the rule read favours the shapers at every share exactly where `c ≤ lo` and
  `c ≤ hi` (`favours_everywhere_iff`), and the others strictly at every share exactly where `lo < c`
  and `hi ≤ c` (`disfavours_strictly_everywhere_iff`). With `lo ≤ hi` a share decides, the rule read
  favouring the shapers at some share and the others strictly at another, exactly where
  `lo < c < hi` (`critical_mass_iff`).
* **One loop, either way.** With `lo ≤ hi`, under every schedule of reading, from a start under the
  rule read there: where that rule favours the shapers, every configuration of the course is locked
  and neither the shapers' share nor the rule in force is ever below where it started
  (`drawn_locks`); where it favours the others, every configuration is locked the other way, the rule
  in force favouring the others and staying a monotone reading of the share, and neither the share
  nor the rule in force is ever above where it started (`drawn_from_below`). So every such course is
  locked one way or the other at every step (`drawn_locked_either`). Where the start favours the
  shapers strictly, their share rises strictly at every step, the shapers present (`drawn_rises`);
  where it favours the others strictly, it falls strictly at every step, the shapers present at the
  start (`drawn_falls`). Without `lo ≤ hi` a start favouring the shapers strictly need not be locked
  (`Against.not_locked`).
* **Witness** (`CriticalMass`). With `a = 1`, nothing shared, a cost of one, three read as coming back
  where a shaper reads and none where another does: from one shaper to each other the rule read
  favours the shapers strictly, five offspring to four (`CriticalMass.even_favours`), so the course is
  locked from the start and their share rises at every step (`CriticalMass.even_locks`,
  `CriticalMass.even_rises`); from one shaper to three others it favours the others strictly, seven
  to eight (`CriticalMass.few_disfavours`), so the course is locked the other way and their share
  falls at every step (`CriticalMass.few_locks`, `CriticalMass.few_falls`); at one to two each kind
  leaves six (`CriticalMass.at_mass`) and the share stays where it is (`CriticalMass.at_mass_stays`).
  In every start the shapers among the readers read three times the cost as coming back, so that does
  not decide; how many of the readers are shapers does.

So where the rule is read by readers drawn from those it selects and the shapers among the readers
read at least as much coming back to the shapers as the others among them do (`lo ≤ hi`), the
selection of the capacity to shape the rule and the lock of the rule it shapes are one loop, with a
critical mass where `lo < c < hi`: from a share at which what the readers read as coming back covers
the cost, the capacity is never again lower and the rule stays locked in the shapers' favour; from a
share at which it does not, the capacity is never again higher and the rule stays locked in the
others' favour; at the mass both hold and the share stays. What every member receives does not move
the critical mass; what the others among the readers read as coming back (`lo`), what the shapers
among them read (`hi`) and the cost (`c`) do.

**Readings (the AI's, decided by their place in one account, DELEGATED-CHOICES D45).**
- The meta-attractor's two failures together, control over the selection selected and the rule it
  shapes locked: where the rule's readers are drawn from those it selects and the shapers among them
  read at least as much coming back to the shapers as the others among them do, above the critical
  mass one start condition gives both. The capacity's share rises at every step, the shapers present
  (`drawn_rises`), and every configuration is locked (`drawn_locks`). At the mass the share stays
  (`CriticalMass.at_mass_stays`). Whether a reading of a loss beyond the share comes too late to
  leave this lock is not joined here.
- Below the critical mass the capacity is not selected (its share never rises, `drawn_from_below`; it
  falls strictly where the start is strict, the shapers present, `drawn_falls`), and the course is
  still locked, the other way: the rule in force favours those without the capacity and stays a
  monotone reading of the share. This is no capture by the shapers. It is the same closed reading as
  `ClosedCapture`'s: here every course from the rule read at its start is locked one way or the other
  (`drawn_locked_either`). So control not selected does not by itself give a lock left in time;
  leaving needs a reading of what lies beyond the share, which this model does not contain
  (`ClosedCapture.Thinned`, not joined).
- A capacity for which the shapers among the readers read more coming back than it costs (`c < hi`)
  is not thereby selected: below the critical mass it falls (`CriticalMass.few_falls`). With `lo = 0`
  and `c ≤ hi` the critical mass is `c` shapers to `hi - c` others (`critical_iff`). With `lo ≤ hi`,
  where `hi ≤ c` and `lo < c`, the share falls at every step from every start with shapers present
  (`disfavours_strictly_everywhere_iff`, `drawn_falls`).

**Correspondence (an AI reading).** Where `lo < c < hi` this is the stag hunt in which the second
strategy's payoff does not depend on the partner: a shaper meeting a shaper leaves `a + p + hi`, a
shaper meeting an other `a + p + lo`, an other meeting anyone `a + p + c`. The critical mass is its
mixed equilibrium, at the shapers' share `(c - lo) / (hi - lo)`, and the shapers' state is risk
dominant exactly where `2 * c < hi + lo` (Harsanyi and Selten 1988; Skyrms 2004). Because both
readings give each other `a + c + p`, the rule read is the frequency-weighted mean of the two
readings up to a common factor, and reading at every step is discrete-time replicator selection up
to a lag of one step, the rule in force read from the population before (Hofbauer and Sigmund 1998).
The threshold is the critical mass of binary choices with externalities (Schelling 1973, 1978;
Granovetter 1978, whose thresholds are distributed where here there is one; Oliver, Marwell and
Teixeira 1985), and the lock is the lock-in of increasing returns (Arthur 1989), here decided by the
start rather than by random arrivals. The laws prove the direction at every step on each side of the
mass and the lock under every schedule of reading, not convergence to either boundary state. What
the join adds for this model is MA3's loop premise as an equivalent condition on who reads
(`drawn_reads_iff`) and the critical mass's exact location and regimes; the lock half is
`RuleCapture`'s `locked_stays` and `locked_not_below` at a start read there. The reading is stated
with its sources in `development/ma4-drawn-shaping/NOTE.md`.

What is not derived: that actual rules are read by readers drawn from those they select, each kind
counted as the population counts it, or that the shapers among the readers read at least as much
coming back to the shapers as the others do (the loop's premise, moved to who reads by
`drawn_reads_iff`, not removed, and not shown of any actual rule); transmission of the capacity (a
premise as in `Becoming.Capture`); which actual rules can be shaped, at what cost, and how much
comes back. Both kinds of reader read the same `a`, `p` and `c` and differ only in what comes back
to the shapers alone. `hi`, `lo`, `p` and `c` are constants: readers do not learn, the cost does not
change with the share, and the readers are counted exactly as the population counts them. Starts are
under the rule read there; a rule in force against the reading can carry the share across the mass
(`RuleCapture.Reversed.not_absorbed`). There is no noise here, so the critical mass and the locks
bound courses without noise only. Drawn one member at a time (`Becoming.DrawnReplacement`), either
lock is left by drift alone, with weight positive at every count and a bound on it shrinking across
the distance from the mass, and which state one member arising fixes with more weight is decided by
the product of the weights across the mixed counts, in which `a` and `p` enter. That is not the
risk-dominant state in general (Kandori, Mailath and Rob 1993; Young 1993; here the shapers' where
`2 * c < hi + lo`): the Moran criterion approaches it under weak selection (Nowak and others 2004),
and under strong selection in a small population the two can part (`DrawnReplacement`). A loss read by part of the readers
(`ClosedCapture.Thinned`) is not joined here. The representation commits to discrete steps, natural
counts and others present. Nothing here says that capture damages or supports 生生: ranking courses
needs C. No ethical predicate, ranking or axiom occurs.
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
def drawnRead (a p c hi lo : Nat) (pos : 0 < a) (x _ : CarrierCounts) : CarrierCounts :=
  drawn a p c hi lo pos x

/-- The course from the population `x` under the rule read there, under the schedule `reads`. -/
def drawnCourse (a p c hi lo : Nat) (pos : 0 < a) (reads : Nat → Bool) (x : CarrierCounts) (t : Nat) :
    CarrierCounts × CarrierCounts :=
  paced CarrierCounts.select (drawnRead a p c hi lo pos) reads (x, drawn a p c hi lo pos x) t

/-! ## The loop's premise, moved to who reads -/

/-- Two rules after shaping, alike but for what comes back to the shapers alone: one is not lower in
the share order than the other exactly where what comes back in it is not less. -/
theorem shaped_le_iff {a s s' p c : Nat} {pos : 0 < a} :
    CarrierCounts.order.le (RuleShaping.shaped a s p c pos) (RuleShaping.shaped a s' p c pos) ↔ s ≤ s' :=
  ⟨fun le => Naturals.le_of_add_le_add_left (Naturals.le_of_add_le_add_right
      (Nat.le_of_mul_le_mul_right (show (a + s + p) * (a + c + p) ≤ (a + s' + p) * (a + c + p) from le)
        (RuleShaping.shaped a s p c pos).other_pos)),
   fun le => Nat.mul_le_mul_right _ (Nat.add_le_add_right (Nat.add_le_add_left le a) p)⟩

/-- **The loop's premise, moved to who reads.** The rule read by readers drawn from the selected reads
the share monotonically exactly where the shapers among the readers read at least as much coming back
to the shapers as the others among them do. -/
theorem drawn_reads_iff {a p c hi lo : Nat} {pos : 0 < a} :
    ReadsShare CarrierCounts.order CarrierCounts.order (drawnRead a p c hi lo pos) ↔ lo ≤ hi :=
  (ClosedCapture.Drawn.pool_reads_iff (u := RuleShaping.shaped a hi p c pos)
    (v := RuleShaping.shaped a lo p c pos)).trans shaped_le_iff

/-- **The other way, against the share.** Where the shapers among the readers read at most as much
coming back to the shapers as the others among them do, the rule read reads against the share
(`ClosedCapture.Drawn.pool_against`). -/
theorem drawn_against {a p c hi lo : Nat} {pos : 0 < a} (readers : hi ≤ lo) :
    ReadsShare CarrierCounts.order (reverse CarrierCounts.order) (drawnRead a p c hi lo pos) :=
  ClosedCapture.Drawn.pool_against (u := RuleShaping.shaped a hi p c pos)
    (v := RuleShaping.shaped a lo p c pos) (shaped_le_iff.mpr readers)

/-! ## The critical mass -/

/-- `x * (a + s + p)` split into its part from `s` and its part from `a + p`. -/
theorem mul_split (x a s p : Nat) : x * (a + s + p) = x * s + x * (a + p) := by
  rw [Nat.add_comm a s, Nat.add_assoc s a p, Nat.mul_add]

/-- What the rule read gives a kind, split into the part from `s` and `t` and the part from `a + p`. -/
theorem drawn_split (x y a p s t : Nat) :
    x * (a + s + p) + y * (a + t + p) = (x * s + y * t) + (x * (a + p) + y * (a + p)) := by
  rw [mul_split x a s p, mul_split y a t p]
  exact Nat.add_add_add_comm _ _ _ _

/-- **At a share, the rule read favours the shapers exactly where what the readers read as coming back
to the shapers covers the cost**, each reader counted as the population counts it:
`x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo`. -/
theorem drawn_favours_iff {a p c hi lo : Nat} {pos : 0 < a} {x : CarrierCounts} :
    CarrierCounts.favours (drawn a p c hi lo pos x) ↔
      x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo := by
  show x.carrier * (a + c + p) + x.other * (a + c + p) ≤ x.carrier * (a + hi + p) + x.other * (a + lo + p) ↔
    x.carrier * c + x.other * c ≤ x.carrier * hi + x.other * lo
  rw [drawn_split x.carrier x.other a p c c, drawn_split x.carrier x.other a p hi lo]
  exact ⟨Naturals.le_of_add_le_add_right, fun le => Nat.add_le_add_right le _⟩

/-- **At a share, the rule read favours the others strictly exactly where what the readers read as
coming back to the shapers is short of the cost**: `x.carrier * hi + x.other * lo < x.carrier * c +
x.other * c`. -/
theorem drawn_lt_iff {a p c hi lo : Nat} {pos : 0 < a} {x : CarrierCounts} :
    (drawn a p c hi lo pos x).carrier < (drawn a p c hi lo pos x).other ↔
      x.carrier * hi + x.other * lo < x.carrier * c + x.other * c := by
  show x.carrier * (a + hi + p) + x.other * (a + lo + p) <
      x.carrier * (a + c + p) + x.other * (a + c + p) ↔ _
  rw [drawn_split x.carrier x.other a p hi lo, drawn_split x.carrier x.other a p c c]
  exact ⟨Nat.lt_of_add_lt_add_right, fun lt => Nat.add_lt_add_right lt _⟩

/-- **What each leaves without shaping and what comes to every member alike do not move it.** -/
theorem drawn_favours_alike {a a' p p' c hi lo : Nat} {pos : 0 < a} {pos' : 0 < a'} {x : CarrierCounts} :
    CarrierCounts.favours (drawn a p c hi lo pos x) ↔ CarrierCounts.favours (drawn a' p' c hi lo pos' x) :=
  drawn_favours_iff.trans drawn_favours_iff.symm

/-- **The critical mass.** With what the others among the readers read as coming back at most the
cost and what the shapers among them read at least it, the rule read favours the shapers exactly
where they stand to the others at least as `c - lo` to `hi - c`. -/
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

/-- **Readers alike decide nothing by share.** Where the shapers and the others among the readers read
alike what comes back to the shapers, the rule read favours them exactly where the cost is at most
what comes back, at every share alike (`RuleShaping.favours_iff`). -/
theorem alike_favours_iff {a p c s : Nat} {pos : 0 < a} {x : CarrierCounts} :
    CarrierCounts.favours (drawn a p c s s pos x) ↔ c ≤ s := by
  refine drawn_favours_iff.trans ?_
  rw [← add_mul_split x.carrier x.other c, ← add_mul_split x.carrier x.other s]
  exact ⟨fun le => Nat.le_of_mul_le_mul_left le (Nat.lt_of_lt_of_le x.other_pos (Nat.le_add_left _ _)),
    fun le => Nat.mul_le_mul_left _ le⟩

/-- No shapers, one other. -/
def noShapers : CarrierCounts := ⟨0, 1, Nat.zero_lt_one⟩

/-- **Favoured at every share, exactly.** With no hypothesis on the readers, the rule read favours the
shapers at every share exactly where the cost is at most what the others among the readers read as
coming back and at most what the shapers among them read. -/
theorem favours_everywhere_iff {a p c hi lo : Nat} {pos : 0 < a} :
    (∀ x, CarrierCounts.favours (drawn a p c hi lo pos x)) ↔ c ≤ lo ∧ c ≤ hi :=
  ⟨fun every =>
    have at_none : 0 * c + 1 * c ≤ 0 * hi + 1 * lo := drawn_favours_iff.mp (every noShapers)
    have low : c ≤ lo := by
      rw [Nat.zero_mul, Nat.zero_mul, Nat.one_mul, Nat.one_mul, Nat.zero_add, Nat.zero_add] at at_none
      exact at_none
    have many : (lo + 1) * c + 1 * c ≤ (lo + 1) * hi + 1 * lo :=
      drawn_favours_iff.mp (every ⟨lo + 1, 1, Nat.zero_lt_one⟩)
    ⟨low, match Nat.lt_or_ge hi c with
      | .inl lt =>
        absurd
          (calc (lo + 1) * hi + (lo + 1)
              = (lo + 1) * (hi + 1) := (Nat.mul_succ (lo + 1) hi).symm
            _ ≤ (lo + 1) * c := Nat.mul_le_mul_left _ lt
            _ ≤ (lo + 1) * c + 1 * c := Nat.le_add_right _ _
            _ ≤ (lo + 1) * hi + 1 * lo := many
            _ = (lo + 1) * hi + lo := congrArg _ (Nat.one_mul lo))
          (Nat.not_le_of_gt (Nat.add_lt_add_left (Nat.lt_succ_self lo) _))
      | .inr ge => ge⟩,
   fun both _ => drawn_favours_iff.mpr
    (Nat.add_le_add (Nat.mul_le_mul_left _ both.2) (Nat.mul_le_mul_left _ both.1))⟩

/-- **Favoured at no share, exactly.** With no hypothesis on the readers, the rule read favours the
others strictly at every share exactly where what the others among the readers read as coming back is
short of the cost and what the shapers among them read is at most it. At `hi = c`, `lo < c`, the
shapers are favoured at no share, however many. -/
theorem disfavours_strictly_everywhere_iff {a p c hi lo : Nat} {pos : 0 < a} :
    (∀ x, (drawn a p c hi lo pos x).carrier < (drawn a p c hi lo pos x).other) ↔ lo < c ∧ hi ≤ c :=
  ⟨fun every =>
    have at_none : 0 * hi + 1 * lo < 0 * c + 1 * c := drawn_lt_iff.mp (every noShapers)
    have low : lo < c := by
      rw [Nat.zero_mul, Nat.zero_mul, Nat.one_mul, Nat.one_mul, Nat.zero_add, Nat.zero_add] at at_none
      exact at_none
    have many : c * hi + 1 * lo < c * c + 1 * c := drawn_lt_iff.mp (every ⟨c, 1, Nat.zero_lt_one⟩)
    ⟨low, match Nat.lt_or_ge c hi with
      | .inl lt =>
        absurd
          (calc c * c + 1 * c
              = c * c + c := congrArg _ (Nat.one_mul c)
            _ = c * (c + 1) := (Nat.mul_succ c c).symm
            _ ≤ c * hi := Nat.mul_le_mul_left _ lt
            _ ≤ c * hi + 1 * lo := Nat.le_add_right _ _)
          (Nat.not_le_of_gt many)
      | .inr ge => ge⟩,
   fun both x => drawn_lt_iff.mpr
    (Nat.add_lt_add_of_le_of_lt (Nat.mul_le_mul_left _ both.2)
      (Nat.mul_lt_mul_of_pos_left both.1 x.other_pos))⟩

/-- **A share decides exactly where `lo < c < hi`.** With the shapers among the readers reading at
least as much coming back to the shapers as the others among them do, the rule read favours the
shapers at some share and the others strictly at another exactly where what the others among the
readers read as coming back is short of the cost and what the shapers among them read exceeds it. -/
theorem critical_mass_iff {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) :
    ((∃ x, CarrierCounts.favours (drawn a p c hi lo pos x)) ∧
        ∃ x, (drawn a p c hi lo pos x).carrier < (drawn a p c hi lo pos x).other) ↔
      lo < c ∧ c < hi :=
  ⟨fun ⟨⟨x, fav⟩, ⟨y, lt⟩⟩ =>
    have low : lo < c := match Nat.lt_or_ge lo c with
      | .inl h => h
      | .inr h => absurd (favours_everywhere_iff.mpr ⟨h, Nat.le_trans h step⟩ y) (Nat.not_le_of_gt lt)
    ⟨low, match Nat.lt_or_ge c hi with
      | .inl h => h
      | .inr h => absurd fav (Nat.not_le_of_gt (disfavours_strictly_everywhere_iff.mpr ⟨low, h⟩ x))⟩,
   fun ⟨low, high⟩ =>
    ⟨⟨⟨c - lo, hi - c, Naturals.le_sub_of_add_le high⟩,
      (critical_iff (Nat.le_of_lt low) (Nat.le_of_lt high)).mpr (Nat.le_of_eq (Nat.mul_comm _ _))⟩,
     ⟨noShapers, drawn_lt_iff.mpr (show 0 * hi + 1 * lo < 0 * c + 1 * c by
        rw [Nat.zero_mul, Nat.zero_mul, Nat.one_mul, Nat.one_mul, Nat.zero_add, Nat.zero_add]
        exact low)⟩⟩⟩

/-! ## One loop, either way -/

/-- **One loop, from above.** From a start where the rule read favours the shapers, under the rule
read there, every configuration of the course is locked, and neither the shapers' share nor the rule
in force is ever below where it started, `lo ≤ hi`, under every schedule of reading. -/
theorem drawn_locks {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) {reads : Nat → Bool}
    {x : CarrierCounts} (fav : CarrierCounts.favours (drawn a p c hi lo pos x)) (k : Nat) :
    Locked CarrierCounts.order CarrierCounts.favours (drawnRead a p c hi lo pos)
        (drawnCourse a p c hi lo pos reads x k) ∧
      CarrierCounts.order.le x (drawnCourse a p c hi lo pos reads x k).1 ∧
      CarrierCounts.order.le (drawn a p c hi lo pos x) (drawnCourse a p c hi lo pos reads x k).2 :=
  have mono := (drawn_reads_iff (a := a) (p := p) (c := c) (pos := pos)).mpr step
  have start : Locked CarrierCounts.order CarrierCounts.favours (drawnRead a p c hi lo pos)
      (paced CarrierCounts.select (drawnRead a p c hi lo pos) reads (x, drawn a p c hi lo pos x) 0) :=
    ⟨fav, CarrierCounts.order.refl _⟩
  Eq.subst (motive := fun n =>
      Locked CarrierCounts.order CarrierCounts.favours (drawnRead a p c hi lo pos)
          (drawnCourse a p c hi lo pos reads x n) ∧
        CarrierCounts.order.le x (drawnCourse a p c hi lo pos reads x n).1 ∧
        CarrierCounts.order.le (drawn a p c hi lo pos x) (drawnCourse a p c hi lo pos reads x n).2)
    (Nat.zero_add k)
    ⟨locked_stays CarrierCounts.raises mono CarrierCounts.upper start k,
     locked_not_below CarrierCounts.raises mono CarrierCounts.upper start k⟩

/-- **One loop, from below.** From a start where the rule read favours the others, under the rule read
there, the rule in force keeps favouring the others at every step, what the reading of the share gives
is not above it, and neither the shapers' share nor the rule in force is ever above where it started,
`lo ≤ hi`, under every schedule of reading. -/
theorem drawn_from_below {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) {reads : Nat → Bool}
    {x : CarrierCounts} (dis : CarrierCounts.disfavours (drawn a p c hi lo pos x)) (k : Nat) :
    Locked (reverse CarrierCounts.order) CarrierCounts.disfavours (drawnRead a p c hi lo pos)
        (drawnCourse a p c hi lo pos reads x k) ∧
      CarrierCounts.order.le (drawnCourse a p c hi lo pos reads x k).1 x ∧
      CarrierCounts.order.le (drawnCourse a p c hi lo pos reads x k).2 (drawn a p c hi lo pos x) :=
  have mono := ((drawn_reads_iff (a := a) (p := p) (c := c) (pos := pos)).mpr step).reverse
  have start : Locked (reverse CarrierCounts.order) CarrierCounts.disfavours (drawnRead a p c hi lo pos)
      (paced CarrierCounts.select (drawnRead a p c hi lo pos) reads (x, drawn a p c hi lo pos x) 0) :=
    ⟨dis, CarrierCounts.order.refl _⟩
  Eq.subst (motive := fun n =>
      Locked (reverse CarrierCounts.order) CarrierCounts.disfavours (drawnRead a p c hi lo pos)
          (drawnCourse a p c hi lo pos reads x n) ∧
        CarrierCounts.order.le (drawnCourse a p c hi lo pos reads x n).1 x ∧
        CarrierCounts.order.le (drawnCourse a p c hi lo pos reads x n).2 (drawn a p c hi lo pos x))
    (Nat.zero_add k)
    ⟨locked_stays CarrierCounts.lowers mono CarrierCounts.lower start k,
     locked_not_below CarrierCounts.lowers mono CarrierCounts.lower start k⟩

/-- **Either way, locked.** With `lo ≤ hi`, under every schedule of reading, every course from the rule
read at its start is locked in the shapers' favour at every step or locked the other way at every
step. -/
theorem drawn_locked_either {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) (reads : Nat → Bool)
    (x : CarrierCounts) :
    (∀ k, Locked CarrierCounts.order CarrierCounts.favours (drawnRead a p c hi lo pos)
        (drawnCourse a p c hi lo pos reads x k)) ∨
      ∀ k, Locked (reverse CarrierCounts.order) CarrierCounts.disfavours (drawnRead a p c hi lo pos)
        (drawnCourse a p c hi lo pos reads x k) :=
  match Nat.le_total (drawn a p c hi lo pos x).other (drawn a p c hi lo pos x).carrier with
  | .inl fav => .inl fun k => (drawn_locks (reads := reads) step fav k).1
  | .inr dis => .inr fun k => (drawn_from_below (reads := reads) step dis k).1

/-- A rule not lower than one favouring the shapers strictly favours them strictly: the mirror of
`ChoiceCountCapture.lower_strict`. -/
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

/-- **Carriers present stay present along every course whose reading gives each carrier an
offspring**, from a start whose rule does, under every schedule of reading. -/
theorem present_along_course {h : CarrierCounts → CarrierCounts → CarrierCounts}
    (each : ∀ y r, 0 < (h y r).carrier) {reads : Nat → Bool} {x g : CarrierCounts}
    (gives : 0 < g.carrier) (some : 0 < x.carrier) : ∀ t,
    0 < (paced CarrierCounts.select h reads (x, g) t).2.carrier ∧
      0 < (paced CarrierCounts.select h reads (x, g) t).1.carrier
  | 0 => ⟨gives, some⟩
  | t + 1 =>
    have now := present_along_course each (reads := reads) gives some t
    have fast : 0 < (paced CarrierCounts.select h reads (x, g) (t + 1)).1.carrier :=
      Eq.subst (motive := fun y : CarrierCounts => 0 < y.carrier) (paced_fast_succ _ t).symm
        (Nat.mul_pos now.2 now.1)
    match q : reads t with
    | true =>
      ⟨Eq.subst (motive := fun r : CarrierCounts => 0 < r.carrier)
        ((congrArg Prod.snd (paced_succ (x, g) t)).trans
          (congrArg (fun b => (turn CarrierCounts.select h b
            (paced CarrierCounts.select h reads (x, g) t)).2) q)).symm
        (each _ _), fast⟩
    | false =>
      ⟨Eq.subst (motive := fun r : CarrierCounts => 0 < r.carrier)
        ((congrArg Prod.snd (paced_succ (x, g) t)).trans
          (congrArg (fun b => (turn CarrierCounts.select h b
            (paced CarrierCounts.select h reads (x, g) t)).2) q)).symm
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
      (present_along_course (h := drawnRead a p c hi lo pos) (fun y _ => drawn_carrier_pos y)
        (reads := reads) (drawn_carrier_pos x) some t).2
      (ChoiceCountCapture.lower_strict now.2.2 strict))

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
cost of one, three read as coming back where a shaper reads and none where another does, each shaper
leaves five and each other four. -/
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
    Locked CarrierCounts.order CarrierCounts.favours (drawnRead 1 0 1 3 0 one_pos)
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

/-- From one to three the course is locked the other way at every step and the shapers' share is
never above one to three, under every schedule of reading. -/
theorem few_locks {reads : Nat → Bool} (k : Nat) :
    Locked (reverse CarrierCounts.order) CarrierCounts.disfavours (drawnRead 1 0 1 3 0 one_pos)
        (drawnCourse 1 0 1 3 0 one_pos reads oneToThree k) ∧
      CarrierCounts.order.le (drawnCourse 1 0 1 3 0 one_pos reads oneToThree k).1 oneToThree :=
  have locks := drawn_from_below (reads := reads) (Nat.zero_le 3) (Nat.le_of_lt few_disfavours) k
  ⟨locks.1, locks.2.1⟩

/-- From one to three the shapers' share falls strictly at every step. -/
theorem few_falls {reads : Nat → Bool} (t : Nat) :
    (drawnCourse 1 0 1 3 0 one_pos reads oneToThree (t + 1)).1.carrier *
        (drawnCourse 1 0 1 3 0 one_pos reads oneToThree t).1.other <
      (drawnCourse 1 0 1 3 0 one_pos reads oneToThree t).1.carrier *
        (drawnCourse 1 0 1 3 0 one_pos reads oneToThree (t + 1)).1.other :=
  drawn_falls (Nat.zero_le 3) few_disfavours Nat.zero_lt_one t

/-- **At the critical mass the share stays where it is**: from one to two the shapers' share is
neither below nor above one to two at any step, under every schedule of reading. -/
theorem at_mass_stays {reads : Nat → Bool} (k : Nat) :
    CarrierCounts.order.le oneToTwo (drawnCourse 1 0 1 3 0 one_pos reads oneToTwo k).1 ∧
      CarrierCounts.order.le (drawnCourse 1 0 1 3 0 one_pos reads oneToTwo k).1 oneToTwo :=
  ⟨(drawn_locks (reads := reads) (Nat.zero_le 3) (Nat.le_of_eq at_mass.symm) k).2.1,
   (drawn_from_below (reads := reads) (Nat.zero_le 3) (Nat.le_of_eq at_mass) k).2.1⟩

end CriticalMass

/-! ## A witness: read against the share -/

namespace Against

/-- **Read against the share, a start favouring the shapers is not locked.** With the shapers among
the readers reading nothing coming back to the shapers and the others among them three (`hi = 0`,
`lo = 3`; `a = 1`, nothing shared, a cost of one), from one shaper to each other the rule read favours
the shapers strictly, five offspring to four; read at every step, the course is not locked at step 1,
and the rule in force at step 2, twenty-one to eighteen, is below the start's. `drawn_locks` needs
`lo ≤ hi`. -/
theorem not_locked :
    (drawn 1 0 1 0 3 CriticalMass.one_pos CriticalMass.even).other <
        (drawn 1 0 1 0 3 CriticalMass.one_pos CriticalMass.even).carrier ∧
      ¬ Locked CarrierCounts.order CarrierCounts.favours (drawnRead 1 0 1 0 3 CriticalMass.one_pos)
          (drawnCourse 1 0 1 0 3 CriticalMass.one_pos (fun _ => true) CriticalMass.even 1) ∧
      ¬ CarrierCounts.order.le (drawn 1 0 1 0 3 CriticalMass.one_pos CriticalMass.even)
          (drawnCourse 1 0 1 0 3 CriticalMass.one_pos (fun _ => true) CriticalMass.even 2).2 :=
  ⟨by decide,
   fun lock =>
    (show ¬ ((drawnCourse 1 0 1 0 3 CriticalMass.one_pos (fun _ => true) CriticalMass.even 1).2.carrier *
          (drawn 1 0 1 0 3 CriticalMass.one_pos
            (drawnCourse 1 0 1 0 3 CriticalMass.one_pos (fun _ => true) CriticalMass.even 1).1).other ≤
        (drawn 1 0 1 0 3 CriticalMass.one_pos
            (drawnCourse 1 0 1 0 3 CriticalMass.one_pos (fun _ => true) CriticalMass.even 1).1).carrier *
          (drawnCourse 1 0 1 0 3 CriticalMass.one_pos (fun _ => true) CriticalMass.even 1).2.other)
      by decide) lock.2,
   fun le =>
    (show ¬ ((drawn 1 0 1 0 3 CriticalMass.one_pos CriticalMass.even).carrier *
          (drawnCourse 1 0 1 0 3 CriticalMass.one_pos (fun _ => true) CriticalMass.even 2).2.other ≤
        (drawnCourse 1 0 1 0 3 CriticalMass.one_pos (fun _ => true) CriticalMass.even 2).2.carrier *
          (drawn 1 0 1 0 3 CriticalMass.one_pos CriticalMass.even).other)
      by decide) le⟩

end Against

end DrawnShaping

end Becoming
