import Becoming.RuleCapture
import Becoming.Recurrence
import Becoming.SelectionTerm
import Becoming.SelectionLevels

/-!
# Rule shaping: the capacity to shape the rule, selected by what comes back to it

`Becoming.RuleCapture` states a selection whose rule is read from the share it selects and what that
loop does; that the rule reads the share is its premise `ReadsShare`, where "the winner shapes the
rule" of `Becoming.Capture` enters. This module asks what selects the capacity to shape the rule
when that capacity is itself carried from parent to offspring. On `RuleCapture`'s counts the carriers
are the shapers. Their shaping gives something, part of which comes back to the shapers alone (`s`)
and part of which comes to every member alike (`p`), and it costs each shaper `c`, read as what each
other leaves more than each shaper. The rule after shaping (`shaped`) gives each shaper `a + s + p`
offspring and each other `a + c + p`, `a` positive. `favours` and `disfavours` are weak: both hold
where the two kinds leave alike. With no premise beyond the hypotheses each statement names:

* **At a step, what comes back decides the direction.** The rule favours the shapers exactly where
  the cost is at most what comes back to them alone (`favours_iff`), and disfavours them exactly
  where what comes back is at most the cost (`disfavours_iff`), whatever comes to every member alike
  (`favours_alike`). The shared part pulls the rule toward even: a larger one gives a rule not
  higher in the share order where `c ≤ s` (`shared_lowers`, strictly where `c < s` and it is strictly
  larger, `shared_lowers_strictly`), and not lower where `s ≤ c` (`shared_raises`). A smaller cost
  gives a rule not lower (`lower_c_raises`), and a strictly smaller one a strictly higher rule
  (`lower_c_raises_strictly`). With nothing coming back and a cost, the shapers' share
  falls strictly at every step of the run, the shapers present at the start (`nothing_back_falls`,
  through `falls_strictly`, the mirror of `CarrierCounts.rises_strictly`). With no cost to the shapers
  alone the rule favours them whatever comes back (`c_zero_favours`); with nothing coming back as
  well, selection leaves the share where it is (`neutral_steady`). Witnesses: with `s + p = 5` to
  each shaper and a cost of one, the rule favours the shapers where two of the five come back to
  them alone and disfavours them where none does (`Split.favours`, `Split.shared_disfavours`), so
  that from one shaper to each other their share rises in the first case and falls in the second
  (`Split.rises`, `Split.falls`).
* **Across a stretch, how long each part lasts.** Selection by two rules in turn is selection by the
  two in one, their counts multiplied (`select_thenBy`), and the run under a rule is selection by the
  rule held, its counts raised to the number of steps (`orbit_held`). Carriers present, selection does
  not lower the share exactly where the rule favours, and raises it strictly exactly where the rule
  favours strictly (`le_select_iff`, `lt_select_iff`). So across `m` steps before anything comes back
  (the rule after shaping with `s = 0`) and then `n` steps with it, the shapers present, their share
  does not fall exactly where `(a + c + p) ^ m * (a + c + p) ^ n ≤ (a + p) ^ m * (a + s + p) ^ n`
  (`stretch_iff`), and rises strictly exactly where the inequality is strict (`stretch_lt_iff`). The
  shared part enters as part of what each leaves (`shaped_shift`), and across a stretch it can turn
  the verdict: with `a = 1`, `c = 1`, `s = 2`, two steps before and three with what comes back lower
  the shapers' share with nothing shared and raise it with one to every member (`SharedFlips`). Since
  the counts multiply, only how many steps of each kind matters, not their order. One more step before
  anything comes back never helps the shapers (`wait_not_more`); one more step with it never hurts
  them where it covers the cost (`back_longer_not_less`). Witnesses with `a = 2`, `c = 1`, `s = 2`: a
  step before and two with it raise the shapers' share (`Timing.soon_rises`), while two before and
  two with it, or one and one, lower it (`Timing.late_falls`, `Timing.shorter_falls`); after five steps
  before, seven with it lower the share and eight raise it (`Timing.seven_falls`, `Timing.eight_rises`):
  where what comes back exceeds the cost, enough steps with it outweigh any number before it, so the
  timing binds only where the steps with it are bounded.
* **The loop.** Where what comes back is read at each reading step from the shapers' share (`byBack`),
  the rule read is a monotone function of the share exactly where what comes back is
  (`byBack_reads_iff`): on this reading `ReadsShare` is equivalent to a statement about what comes
  back, that it is not lower where the shapers' share is not lower. Where it is so and covers the
  cost at every share, from a start whose rule covers it, the share falls at no step and the course is
  locked from the step after its first reading step (`covering_locks`, by
  `RuleCapture.favouring_locks`). At a threshold (`thresholdBack`: `hi` where the shapers are at least
  as many as the others, `lo` where they are fewer, `lo ≤ hi`), from a start where they are at least as
  many, under the rule read there, with `c ≤ hi`, the shapers' share is never again below its start
  and the rule in force stays the one read there (`threshold_from_above`, `threshold_rule_above`);
  from a start where they are fewer, with `lo ≤ c`, it is never again above its start
  (`threshold_from_below`, `threshold_rule_below`), under every schedule of reading. With
  `lo < c < hi` it is a tipping point: from above the share rises strictly at every step, and from
  below it falls strictly at every step, the shapers present (`threshold_rises`, `threshold_falls`).
* **Among groups: the shared part weighted by assortment.** Listed as groups of `m`, let a group's
  shared part be what its shapers give, `q` to every member for each shaper in it, each shaper
  leaving the shapers' count of the rule after shaping with that shared part and each other the
  others' (`Grouped`). That is a case of returns kept and shared within the group
  (`grouped_returns`, `SelectionLevels.rises_iff_kept`), so the whole selects for shaping exactly
  where `c` times the spread of shaping falls short of `s` times it with `m q` times the spread among
  groups (`grouped_rises_iff`): read over the rationals, where `c < s + m q ρ` with `ρ` the
  assortment, Hamilton's rule with what comes back alone added. With groups alike in how many shape
  (assortment none, the shared part coming to every member alike) it is `c < s` where shaping varies,
  this step's verdict whatever is shared (`grouped_alike_iff`); where `c < s` the whole selects for
  shaping however the groups are formed (`grouped_kept_rises`), so lower assortment cannot unselect
  what comes back alone covers; with the shapers together (groups uniform) it is `c < s + m q`
  (`grouped_uniform_iff`). Witness (`Assorting.either_verdict`): a cost of two above one coming back,
  so that within every group the rule disfavours the shapers, and the whole selects for shaping with
  the shapers together and against it with them apart.

So at a step the capacity to shape the rule is selected by the part of what it gives that comes back
to it alone, net of its cost: the part every member receives does not decide the direction, though it
pulls the rule toward even and, across a stretch, can turn the verdict. Across a stretch what decides
is how many steps carry the cost before anything comes back and how many carry it with what comes
back. Where what comes back is monotone in the shapers' share and covers the cost, the lock of
`RuleCapture` holds of the capacity.

**Readings (the AI's, decided by their place in one account, DELEGATED-CHOICES D45).**
- The corpus's second order, "recursive selection creates second-order selection pressure for
  mechanisms that increase control over future selection" (the meta-attractor's review of 2 October
  2026), with its conditions: variation and retention (two kinds, offspring carrying the parent's
  kind, a premise), real influence (the rule after shaping), what comes back to the shapers (`s`)
  and how long each part lasts (`m`, `n`). Its lever is stated exactly at a step: where rule-making
  gives nothing back to the rule-makers alone and costs them, the capacity falls
  (`nothing_back_falls`); where it costs them nothing either, it is selected neither way
  (`neutral_steady`); help that lowers the cost gives a rule not lower, and strictly higher where it
  lowers it strictly (`lower_c_raises`, `lower_c_raises_strictly`).
- Duration: where what comes back covers the cost, ending it sooner never helps the shapers
  (`back_longer_not_less`). The rule's value a shaping sets is read again from the share at the next
  reading step (`RuleCapture.perturbation_absorbed`, from a locked start and for a change keeping the
  direction), but the share the shaping moved stays; carried across a threshold it holds the course
  there (`RuleCapture.Reversed.not_absorbed`, and `threshold_from_above` here). So a shaping of the
  value alone can be decisive where it moves the share across a threshold.
- A capacity spent on reading what lies beyond the share, such as an independent review, is a shaping
  whose gain comes to every member alike: with a cost it falls (`nothing_back_falls`), the more slowly
  the larger its shared part (`shared_raises`), and with no cost to it alone its share stays
  (`neutral_steady`).

What is not derived: that offspring carry their parent's capacity (transmission, a premise as in
`Becoming.Capture`); that what comes back is read monotonically from the share (on `byBack`, the
premise equivalent to `ReadsShare`); which actual rules can be shaped, at what cost, or how much of
what shaping gives comes back, or how assorted shapers are. `s` and `p` are constants of the rule at
a step: the shared part reaches every member even with no shapers present and does not grow with
their number. A gain made by the shapers and divided among the members of their group is stated
among groups of equal size (`grouped_rises_iff`), at a step and with no transmission across steps;
divided among all, it is the case of groups alike. The cost is borne at every step, with what comes
back or not. The timing law's inequality depends on `a`, and with it on whether the cost is read as what
the others leave more or what the shapers leave less: read the second way, the same `c`, `s` and
steps can give the other verdict (with what each leaves before shaping `3`, `c = 1`, `s = 2`, three
steps before and four with what comes back fall, the case of `a = 2` here). The capacity has two
levels, carried or not; graded capacities, a gain growing with the number of domains captured, gains
passing between domains, readers drawn from the selected (board item MA2), noise and real-valued
shares are not stated. The representation commits to discrete steps, natural counts and others
present. Nothing here says that capture damages or supports 生生, or that open rule-making is better:
ranking courses needs C. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace RuleShaping

open Pace RuleCapture

/-! ## The rule after shaping -/

/-- **The rule after shaping.** Each shaper leaves `a + s + p` offspring and each other `a + c + p`:
`a` what each leaves without shaping, positive; `s` the part of what shaping gives that comes back to
the shapers alone; `p` the part that comes to every member alike; `c` the cost of shaping, read as
what each other leaves more than each shaper. -/
def shaped (a s p c : Nat) (pos : 0 < a) : CarrierCounts :=
  ⟨a + s + p, a + c + p,
    Nat.lt_of_lt_of_le pos (Nat.le_trans (Nat.le_add_right a c) (Nat.le_add_right (a + c) p))⟩

/-- Counts alike in both are one. -/
theorem eq_of_counts : ∀ {x y : CarrierCounts}, x.carrier = y.carrier → x.other = y.other → x = y
  | ⟨_, _, _⟩, ⟨_, _, _⟩, rfl, rfl => rfl

/-- **The rule after shaping favours the shapers (weakly) exactly where the cost is at most what
comes back to them alone.** -/
theorem favours_iff {a s p c : Nat} {pos : 0 < a} :
    CarrierCounts.favours (shaped a s p c pos) ↔ c ≤ s :=
  ⟨fun fav => Naturals.le_of_add_le_add_left
      (Naturals.le_of_add_le_add_right (show a + c + p ≤ a + s + p from fav)),
   fun le => Nat.add_le_add_right (Nat.add_le_add_left le a) p⟩

/-- **It disfavours them (weakly) exactly where what comes back is at most the cost.** -/
theorem disfavours_iff {a s p c : Nat} {pos : 0 < a} :
    CarrierCounts.disfavours (shaped a s p c pos) ↔ s ≤ c :=
  ⟨fun dis => Naturals.le_of_add_le_add_left
      (Naturals.le_of_add_le_add_right (show a + s + p ≤ a + c + p from dis)),
   fun le => Nat.add_le_add_right (Nat.add_le_add_left le a) p⟩

/-- **What comes to every member alike does not decide the direction**: with any two shared parts,
the rule after shaping favours the shapers under one exactly where it does under the other. -/
theorem favours_alike {a s p p' c : Nat} {pos : 0 < a} :
    CarrierCounts.favours (shaped a s p c pos) ↔ CarrierCounts.favours (shaped a s p' c pos) :=
  favours_iff.trans favours_iff.symm

/-- **A larger shared part gives a favouring rule not higher.** Where the cost is at most what comes
back, the rule with the larger shared part is not above the rule with the smaller in the share
order; both favour (`favours_alike`). -/
theorem shared_lowers {a s p p' c : Nat} {pos : 0 < a} (le : c ≤ s) (more : p ≤ p') :
    CarrierCounts.order.le (shaped a s p' c pos) (shaped a s p c pos) :=
  match le_dest more with
  | ⟨d, same⟩ =>
    have below : a + c + p ≤ a + s + p := Nat.add_le_add_right (Nat.add_le_add_left le a) p
    Eq.subst (motive := fun q => (a + s + q) * (a + c + p) ≤ (a + s + p) * (a + c + q)) same.symm
      (calc (a + s + (p + d)) * (a + c + p)
          = (a + s + p + d) * (a + c + p) :=
            congrArg (· * (a + c + p)) (Nat.add_assoc (a + s) p d).symm
        _ = (a + s + p) * (a + c + p) + d * (a + c + p) := add_mul_split _ _ _
        _ ≤ (a + s + p) * (a + c + p) + d * (a + s + p) :=
            Nat.add_le_add_left (Nat.mul_le_mul_left d below) _
        _ = (a + s + p) * (a + c + p) + (a + s + p) * d := congrArg (_ + ·) (Nat.mul_comm d _)
        _ = (a + s + p) * (a + c + p + d) := (Nat.left_distrib _ _ _).symm
        _ = (a + s + p) * (a + c + (p + d)) := congrArg (_ * ·) (Nat.add_assoc (a + c) p d))

/-- **Strictly where what comes back exceeds the cost**: a strictly larger shared part gives a rule
strictly lower in the share order. -/
theorem shared_lowers_strictly {a s p p' c : Nat} {pos : 0 < a} (lt : c < s) (more : p < p') :
    (shaped a s p' c pos).carrier * (shaped a s p c pos).other <
      (shaped a s p c pos).carrier * (shaped a s p' c pos).other :=
  match le_dest (Nat.succ_le_of_lt more) with
  | ⟨d, same⟩ =>
    have below : a + c + p < a + s + p := Nat.add_lt_add_right (Nat.add_lt_add_left lt a) p
    Eq.subst (motive := fun q => (a + s + q) * (a + c + p) < (a + s + p) * (a + c + q))
      (same.trans (Nat.succ_add p d)).symm
      (calc (a + s + (p + (d + 1))) * (a + c + p)
          = (a + s + p + (d + 1)) * (a + c + p) :=
            congrArg (· * (a + c + p)) (Nat.add_assoc (a + s) p (d + 1)).symm
        _ = (a + s + p) * (a + c + p) + (d + 1) * (a + c + p) := add_mul_split _ _ _
        _ < (a + s + p) * (a + c + p) + (d + 1) * (a + s + p) :=
            Nat.add_lt_add_left (Nat.mul_lt_mul_of_pos_left below (Nat.zero_lt_succ d)) _
        _ = (a + s + p) * (a + c + p) + (a + s + p) * (d + 1) :=
            congrArg (_ + ·) (Nat.mul_comm (d + 1) _)
        _ = (a + s + p) * (a + c + p + (d + 1)) := (Nat.left_distrib _ _ _).symm
        _ = (a + s + p) * (a + c + (p + (d + 1))) :=
            congrArg (_ * ·) (Nat.add_assoc (a + c) p (d + 1)))

/-- **A larger shared part gives a disfavouring rule not lower**: where what comes back is at most
the cost, the rule with the larger shared part is not below the rule with the smaller. -/
theorem shared_raises {a s p p' c : Nat} {pos : 0 < a} (le : s ≤ c) (more : p ≤ p') :
    CarrierCounts.order.le (shaped a s p c pos) (shaped a s p' c pos) :=
  match le_dest more with
  | ⟨d, same⟩ =>
    have below : a + s + p ≤ a + c + p := Nat.add_le_add_right (Nat.add_le_add_left le a) p
    Eq.subst (motive := fun q => (a + s + p) * (a + c + q) ≤ (a + s + q) * (a + c + p)) same.symm
      (calc (a + s + p) * (a + c + (p + d))
          = (a + s + p) * (a + c + p + d) := congrArg (_ * ·) (Nat.add_assoc (a + c) p d).symm
        _ = (a + s + p) * (a + c + p) + (a + s + p) * d := Nat.left_distrib _ _ _
        _ = (a + s + p) * (a + c + p) + d * (a + s + p) := congrArg (_ + ·) (Nat.mul_comm _ d)
        _ ≤ (a + s + p) * (a + c + p) + d * (a + c + p) :=
            Nat.add_le_add_left (Nat.mul_le_mul_left d below) _
        _ = (a + s + p + d) * (a + c + p) := (add_mul_split _ _ _).symm
        _ = (a + s + (p + d)) * (a + c + p) :=
            congrArg (· * (a + c + p)) (Nat.add_assoc (a + s) p d))

/-- **A smaller cost gives a rule not lower**: with the cost lowered and nothing else changed, the
rule after shaping is not lower in the share order. -/
theorem lower_c_raises {a s p c c' : Nat} {pos : 0 < a} (lower : c' ≤ c) :
    CarrierCounts.order.le (shaped a s p c pos) (shaped a s p c' pos) :=
  Nat.mul_le_mul_left _ (Nat.add_le_add_right (Nat.add_le_add_left lower a) p)

/-- **A strictly smaller cost gives a strictly higher rule**: with the cost strictly lowered and
nothing else changed, the rule after shaping is strictly higher in the share order. -/
theorem lower_c_raises_strictly {a s p c c' : Nat} {pos : 0 < a} (lower : c' < c) :
    (shaped a s p c pos).carrier * (shaped a s p c' pos).other <
      (shaped a s p c' pos).carrier * (shaped a s p c pos).other :=
  Nat.mul_lt_mul_of_pos_left (Nat.add_lt_add_right (Nat.add_lt_add_left lower a) p)
    (Nat.lt_of_lt_of_le pos (Nat.le_trans (Nat.le_add_right a s) (Nat.le_add_right (a + s) p)))

/-- **The shared part is part of what each leaves**: the rule after shaping with a shared part `p` is
the rule over the base `a + p` with nothing shared. -/
theorem shaped_shift {a s p c : Nat} {pos : 0 < a} :
    shaped a s p c pos = shaped (a + p) s 0 c (Nat.lt_of_lt_of_le pos (Nat.le_add_right a p)) :=
  eq_of_counts (Nat.add_right_comm a s p) (Nat.add_right_comm a c p)

/-! ## Nothing coming back -/

/-- **Selection by a rule disfavouring strictly lowers the share strictly**, the carriers present: the
mirror of `CarrierCounts.rises_strictly`. -/
theorem falls_strictly {x g : CarrierCounts} (some : 0 < x.carrier) (lt : g.carrier < g.other) :
    (CarrierCounts.select x g).carrier * x.other < x.carrier * (CarrierCounts.select x g).other :=
  calc x.carrier * g.carrier * x.other
      = x.carrier * x.other * g.carrier := Naturals.mul_right_comm _ _ _
    _ < x.carrier * x.other * g.other := Nat.mul_lt_mul_of_pos_left lt (Nat.mul_pos some x.other_pos)
    _ = x.carrier * (x.other * g.other) := mul_assoc_nat _ _ _

/-- Under a rule giving each carrier at least one offspring, carriers present stay present along the
run. -/
theorem present_along {g : CarrierCounts} (gives : 0 < g.carrier) {x : CarrierCounts}
    (some : 0 < x.carrier) : ∀ n, 0 < (Law.orbit (fun y => CarrierCounts.select y g) x n).carrier
  | 0 => some
  | n + 1 => Nat.mul_pos (present_along gives some n) gives

/-- A share not lower than one with carriers present has carriers present. -/
theorem present_of_le {x y : CarrierCounts} (le : CarrierCounts.order.le x y) (some : 0 < x.carrier) :
    0 < y.carrier :=
  match y, le with
  | ⟨0, _, op⟩, le =>
    absurd (Nat.lt_of_lt_of_le (Nat.mul_pos some op) (Nat.le_trans le (Nat.le_of_eq (Nat.zero_mul _))))
      (Nat.lt_irrefl 0)
  | ⟨k + 1, _, _⟩, _ => Nat.zero_lt_succ k

/-- **With nothing coming back to the shapers and a cost, the shapers' share falls strictly at every
step** of the run, the shapers present at the start. -/
theorem nothing_back_falls {a p c : Nat} {pos : 0 < a} (cost : 0 < c) {x : CarrierCounts}
    (some : 0 < x.carrier) (n : Nat) :
    (Law.orbit (fun y => CarrierCounts.select y (shaped a 0 p c pos)) x (n + 1)).carrier *
        (Law.orbit (fun y => CarrierCounts.select y (shaped a 0 p c pos)) x n).other <
      (Law.orbit (fun y => CarrierCounts.select y (shaped a 0 p c pos)) x n).carrier *
        (Law.orbit (fun y => CarrierCounts.select y (shaped a 0 p c pos)) x (n + 1)).other :=
  falls_strictly
    (present_along (Nat.lt_of_lt_of_le pos (Nat.le_add_right a p)) some n)
    (Nat.add_lt_add_right (Nat.add_lt_add_left cost a) p)

/-- **With no cost to the shapers alone, the rule favours them whatever comes back to them.** -/
theorem c_zero_favours {a s p : Nat} {pos : 0 < a} : CarrierCounts.favours (shaped a s p 0 pos) :=
  favours_iff.mpr (Nat.zero_le s)

/-- **With nothing coming back and no cost to the shapers alone, selection leaves their share where
it is**, neither raising nor lowering it. -/
theorem neutral_steady {a p : Nat} {pos : 0 < a} (x : CarrierCounts) :
    CarrierCounts.order.le x (CarrierCounts.select x (shaped a 0 p 0 pos)) ∧
      CarrierCounts.order.le (CarrierCounts.select x (shaped a 0 p 0 pos)) x :=
  ⟨CarrierCounts.raises x _ (favours_iff.mpr (Nat.le_refl 0)),
   CarrierCounts.lowers x _ (disfavours_iff.mpr (Nat.le_refl 0))⟩

/-! ## Across a stretch -/

/-- **Two rules in turn**: each carrier leaves the product of what the two give it, and each other
likewise. -/
def thenBy (g g' : CarrierCounts) : CarrierCounts :=
  ⟨g.carrier * g'.carrier, g.other * g'.other, Nat.mul_pos g.other_pos g'.other_pos⟩

/-- **Selection by two rules in turn is selection by the two in one.** -/
theorem select_thenBy (x g g' : CarrierCounts) :
    CarrierCounts.select (CarrierCounts.select x g) g' = CarrierCounts.select x (thenBy g g') :=
  eq_of_counts (mul_assoc_nat _ _ _) (mul_assoc_nat _ _ _)

/-- Every power of a positive count is positive. -/
theorem pow_pos_of_pos {b : Nat} (pos : 0 < b) : ∀ n, 0 < b ^ n
  | 0 => Nat.zero_lt_one
  | n + 1 => Nat.mul_pos (pow_pos_of_pos pos n) pos

/-- **A rule held for `n` steps**: each carrier leaves `g.carrier ^ n`, each other `g.other ^ n`. -/
def held (g : CarrierCounts) (n : Nat) : CarrierCounts :=
  ⟨g.carrier ^ n, g.other ^ n, pow_pos_of_pos g.other_pos n⟩

/-- **The run under a rule is selection by the rule held.** -/
theorem orbit_held (g x : CarrierCounts) : ∀ n,
    Law.orbit (fun y => CarrierCounts.select y g) x n = CarrierCounts.select x (held g n)
  | 0 => eq_of_counts (Nat.mul_one _).symm (Nat.mul_one _).symm
  | n + 1 => (congrArg (fun y => CarrierCounts.select y g) (orbit_held g x n)).trans
      (select_thenBy x (held g n) g)

/-- **Carriers present, selection does not lower the share exactly where the rule favours.** -/
theorem le_select_iff {x g : CarrierCounts} (some : 0 < x.carrier) :
    CarrierCounts.order.le x (CarrierCounts.select x g) ↔ CarrierCounts.favours g :=
  ⟨fun le => Nat.le_of_mul_le_mul_left
      (calc x.carrier * x.other * g.other
          = x.carrier * (x.other * g.other) := mul_assoc_nat _ _ _
        _ ≤ x.carrier * g.carrier * x.other := le
        _ = x.carrier * x.other * g.carrier := Naturals.mul_right_comm _ _ _)
      (Nat.mul_pos some x.other_pos),
   fun fav => CarrierCounts.raises x g fav⟩

/-- **Carriers present, selection raises the share strictly exactly where the rule favours
strictly.** -/
theorem lt_select_iff {x g : CarrierCounts} (some : 0 < x.carrier) :
    x.carrier * (CarrierCounts.select x g).other < (CarrierCounts.select x g).carrier * x.other ↔
      g.other < g.carrier :=
  ⟨fun lt => SelectionTerm.lt_of_mul_lt_mul
      (calc x.carrier * x.other * g.other
          = x.carrier * (x.other * g.other) := mul_assoc_nat _ _ _
        _ < x.carrier * g.carrier * x.other := lt
        _ = x.carrier * x.other * g.carrier := Naturals.mul_right_comm _ _ _),
   fun lt => CarrierCounts.rises_strictly some lt⟩

/-- The stretch of `m` steps before anything comes back and `n` steps with it is selection by the
two held rules in one. -/
theorem stretch_eq {a s p c : Nat} {pos : 0 < a} (x : CarrierCounts) (m n : Nat) :
    Law.orbit (fun y => CarrierCounts.select y (shaped a s p c pos))
        (Law.orbit (fun y => CarrierCounts.select y (shaped a 0 p c pos)) x m) n =
      CarrierCounts.select x (thenBy (held (shaped a 0 p c pos) m) (held (shaped a s p c pos) n)) :=
  (orbit_held _ _ n).trans
    ((congrArg (fun y => CarrierCounts.select y (held (shaped a s p c pos) n))
        (orbit_held _ _ m)).trans (select_thenBy _ _ _))

/-- **Across a stretch, the share does not fall exactly where the counts multiplied favour.** Across
`m` steps before anything comes back and `n` steps with it, the shapers present, their share does
not fall exactly where `(a + c + p) ^ m * (a + c + p) ^ n ≤ (a + p) ^ m * (a + s + p) ^ n`. -/
theorem stretch_iff {a s p c : Nat} {pos : 0 < a} {x : CarrierCounts} (some : 0 < x.carrier)
    (m n : Nat) :
    CarrierCounts.order.le x (Law.orbit (fun y => CarrierCounts.select y (shaped a s p c pos))
        (Law.orbit (fun y => CarrierCounts.select y (shaped a 0 p c pos)) x m) n) ↔
      (a + c + p) ^ m * (a + c + p) ^ n ≤ (a + p) ^ m * (a + s + p) ^ n :=
  Eq.subst (motive := fun y => CarrierCounts.order.le x y ↔
      (a + c + p) ^ m * (a + c + p) ^ n ≤ (a + p) ^ m * (a + s + p) ^ n) (stretch_eq x m n).symm
    (le_select_iff some)

/-- **And it rises strictly exactly where the inequality is strict.** -/
theorem stretch_lt_iff {a s p c : Nat} {pos : 0 < a} {x : CarrierCounts} (some : 0 < x.carrier)
    (m n : Nat) :
    x.carrier * (Law.orbit (fun y => CarrierCounts.select y (shaped a s p c pos))
        (Law.orbit (fun y => CarrierCounts.select y (shaped a 0 p c pos)) x m) n).other <
      (Law.orbit (fun y => CarrierCounts.select y (shaped a s p c pos))
        (Law.orbit (fun y => CarrierCounts.select y (shaped a 0 p c pos)) x m) n).carrier * x.other ↔
      (a + c + p) ^ m * (a + c + p) ^ n < (a + p) ^ m * (a + s + p) ^ n :=
  Eq.subst (motive := fun y : CarrierCounts => x.carrier * y.other < y.carrier * x.other ↔
      (a + c + p) ^ m * (a + c + p) ^ n < (a + p) ^ m * (a + s + p) ^ n) (stretch_eq x m n).symm
    (lt_select_iff some)

/-- **One more step before anything comes back never helps the shapers**: where the share does not
fall with `m + 1` steps before what comes back, it does not fall with `m`. -/
theorem wait_not_more {a s p c m n : Nat} (pos : 0 < a)
    (more : (a + c + p) ^ (m + 1) * (a + c + p) ^ n ≤ (a + p) ^ (m + 1) * (a + s + p) ^ n) :
    (a + c + p) ^ m * (a + c + p) ^ n ≤ (a + p) ^ m * (a + s + p) ^ n :=
  Nat.le_of_mul_le_mul_left
    (calc (a + c + p) * ((a + c + p) ^ m * (a + c + p) ^ n)
        = (a + c + p) ^ m * (a + c + p) ^ n * (a + c + p) := Nat.mul_comm _ _
      _ = (a + c + p) ^ m * (a + c + p) * (a + c + p) ^ n := Naturals.mul_right_comm _ _ _
      _ ≤ (a + p) ^ m * (a + p) * (a + s + p) ^ n := more
      _ = (a + p) ^ m * (a + s + p) ^ n * (a + p) := Naturals.mul_right_comm _ _ _
      _ ≤ (a + p) ^ m * (a + s + p) ^ n * (a + c + p) :=
          Nat.mul_le_mul_left _ (Nat.add_le_add_right (Nat.le_add_right a c) p)
      _ = (a + c + p) * ((a + p) ^ m * (a + s + p) ^ n) := Nat.mul_comm _ _)
    (Nat.lt_of_lt_of_le pos (Nat.le_trans (Nat.le_add_right a c) (Nat.le_add_right (a + c) p)))

/-- **One more step with what comes back never hurts the shapers where it covers the cost.** -/
theorem back_longer_not_less {a s p c m n : Nat} (le : c ≤ s)
    (now : (a + c + p) ^ m * (a + c + p) ^ n ≤ (a + p) ^ m * (a + s + p) ^ n) :
    (a + c + p) ^ m * (a + c + p) ^ (n + 1) ≤ (a + p) ^ m * (a + s + p) ^ (n + 1) :=
  calc (a + c + p) ^ m * (a + c + p) ^ (n + 1)
      = (a + c + p) ^ m * (a + c + p) ^ n * (a + c + p) := (mul_assoc_nat _ _ _).symm
    _ ≤ (a + p) ^ m * (a + s + p) ^ n * (a + c + p) := Nat.mul_le_mul_right _ now
    _ ≤ (a + p) ^ m * (a + s + p) ^ n * (a + s + p) :=
        Nat.mul_le_mul_left _ (Nat.add_le_add_right (Nat.add_le_add_left le a) p)
    _ = (a + p) ^ m * (a + s + p) ^ (n + 1) := mul_assoc_nat _ _ _

/-! ## The loop: what comes back read from the shapers' share -/

/-- **What comes back read from the share**: at a reading step the rule read gives each shaper
`a + σ x + p` and each other `a + c + p`, `σ x` what comes back to the shapers alone at the share
`x`. -/
def byBack (a p c : Nat) (pos : 0 < a) (σ : CarrierCounts → Nat) (x _ : CarrierCounts) :
    CarrierCounts :=
  shaped a (σ x) p c pos

/-- **The rule read reads the share exactly where what comes back is read monotonically from it.** -/
theorem byBack_reads_iff {a p c : Nat} {pos : 0 < a} {σ : CarrierCounts → Nat} :
    ReadsShare CarrierCounts.order CarrierCounts.order (byBack a p c pos σ) ↔
      ∀ x y, CarrierCounts.order.le x y → σ x ≤ σ y :=
  ⟨fun reads x y le => Naturals.le_of_add_le_add_left (Naturals.le_of_add_le_add_right
      (Nat.le_of_mul_le_mul_right (show (a + σ x + p) * (a + c + p) ≤ (a + σ y + p) * (a + c + p)
        from reads x y x y le) (shaped a (σ x) p c pos).other_pos)),
   fun mono x y _ _ le =>
    Nat.mul_le_mul_right _ (Nat.add_le_add_right (Nat.add_le_add_left (mono x y le) a) p)⟩

/-- **What comes back, monotone in the share and covering the cost at every share, locks the loop.**
From a start whose rule covers the cost, the share falls at no step, and the course is locked from the
step after its first reading step (`RuleCapture.favouring_locks`). -/
theorem covering_locks {a p c : Nat} {pos : 0 < a} {σ : CarrierCounts → Nat}
    (mono : ∀ x y, CarrierCounts.order.le x y → σ x ≤ σ y) (covers : ∀ x, c ≤ σ x)
    {reads : Nat → Bool} {x : CarrierCounts} {s : Nat} (start : c ≤ s) :
    (∀ t, CarrierCounts.order.le
        (paced CarrierCounts.select (byBack a p c pos σ) reads (x, shaped a s p c pos) t).1
        (paced CarrierCounts.select (byBack a p c pos σ) reads (x, shaped a s p c pos) (t + 1)).1) ∧
      ∀ r, reads r = true → Locked CarrierCounts.order CarrierCounts.favours (byBack a p c pos σ)
        (paced CarrierCounts.select (byBack a p c pos σ) reads (x, shaped a s p c pos) (r + 1)) :=
  favouring_locks CarrierCounts.raises (byBack_reads_iff.mpr mono)
    (fun y _ => favours_iff.mpr (covers y)) ((favours_iff (a := a) (p := p) (pos := pos)).mpr start)

/-! ## At a threshold -/

/-- **What comes back at a threshold**: `hi` where the shapers are at least as many as the others,
`lo` where they are fewer. -/
def thresholdBack (hi lo : Nat) (x : CarrierCounts) : Nat := if x.other ≤ x.carrier then hi else lo

theorem thresholdBack_above {hi lo : Nat} {x : CarrierCounts} (fav : CarrierCounts.favours x) :
    thresholdBack hi lo x = hi :=
  if_pos fav

theorem thresholdBack_below {hi lo : Nat} {x : CarrierCounts} (dis : ¬ CarrierCounts.favours x) :
    thresholdBack hi lo x = lo :=
  if_neg dis

/-- What comes back at a threshold, `lo` not above `hi`, is read monotonically from the share. -/
theorem thresholdBack_mono {hi lo : Nat} (step : lo ≤ hi) :
    ∀ x y, CarrierCounts.order.le x y → thresholdBack hi lo x ≤ thresholdBack hi lo y := fun x y le =>
  if hx : x.other ≤ x.carrier then
    Nat.le_of_eq ((thresholdBack_above hx).trans (thresholdBack_above (CarrierCounts.upper le hx)).symm)
  else if hy : y.other ≤ y.carrier then
    Nat.le_trans (Nat.le_of_eq (thresholdBack_below hx))
      (Nat.le_trans step (Nat.le_of_eq (thresholdBack_above hy).symm))
  else
    Nat.le_of_eq ((thresholdBack_below hx).trans (thresholdBack_below hy).symm)

/-- **From above the threshold, the shapers' share is never again below its start.** Where what
comes back covers the cost when the shapers are at least as many as the others, `lo` not above `hi`:
from a start where they are, under the rule read there, under every schedule of reading. -/
theorem threshold_from_above {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) (covers : c ≤ hi)
    {reads : Nat → Bool} {x : CarrierCounts} (above : CarrierCounts.favours x) (k : Nat) :
    CarrierCounts.order.le x
      (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
        (x, shaped a hi p c pos) k).1 :=
  Eq.subst (motive := fun n => CarrierCounts.order.le x
      (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
        (x, shaped a hi p c pos) n).1)
    (Nat.zero_add k)
  (locked_not_below (c := (x, shaped a hi p c pos)) (t := 0) CarrierCounts.raises
    (byBack_reads_iff.mpr (thresholdBack_mono step)) CarrierCounts.upper
    ⟨(favours_iff (a := a) (p := p) (pos := pos)).mpr covers,
     Eq.mpr (congrArg (CarrierCounts.order.le (shaped a hi p c pos))
        (congrArg (fun v => shaped a v p c pos) (thresholdBack_above above)))
      (CarrierCounts.order.refl _)⟩ k).1

/-- **From below the threshold, the shapers' share is never again above its start.** Where what
comes back is at most the cost when the shapers are fewer than the others, `lo` not above `hi`: from
a start where they are fewer, under the rule read there, under every schedule of reading. -/
theorem threshold_from_below {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) (short : lo ≤ c)
    {reads : Nat → Bool} {x : CarrierCounts} (below : ¬ CarrierCounts.favours x) (k : Nat) :
    CarrierCounts.order.le
      (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
        (x, shaped a lo p c pos) k).1
      x :=
  Eq.subst (motive := fun n => CarrierCounts.order.le
      (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
        (x, shaped a lo p c pos) n).1 x)
    (Nat.zero_add k)
  (locked_not_below (P := reverse CarrierCounts.order) (M := reverse CarrierCounts.order)
    (c := (x, shaped a lo p c pos)) (t := 0) CarrierCounts.lowers
    (byBack_reads_iff.mpr (thresholdBack_mono step)).reverse CarrierCounts.lower
    ⟨(disfavours_iff (a := a) (p := p) (pos := pos)).mpr short,
     Eq.mpr (congrArg (fun r => CarrierCounts.order.le r (shaped a lo p c pos))
        (congrArg (fun v => shaped a v p c pos) (thresholdBack_below below)))
      (CarrierCounts.order.refl _)⟩ k).1

/-- **From above, the rule in force stays the one read above the threshold**, at every step. -/
theorem threshold_rule_above {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) (covers : c ≤ hi)
    {reads : Nat → Bool} {x : CarrierCounts} (above : CarrierCounts.favours x) : ∀ t,
    (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
      (x, shaped a hi p c pos) t).2 = shaped a hi p c pos
  | 0 => rfl
  | t + 1 =>
    have now := threshold_rule_above (reads := reads) step covers above t
    have up : CarrierCounts.favours (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo))
        reads (x, shaped a hi p c pos) t).1 :=
      CarrierCounts.upper (threshold_from_above step covers above t) above
    match q : reads t with
    | true =>
      ((congrArg Prod.snd (paced_succ (x, shaped a hi p c pos) t)).trans
        (congrArg (fun b => (turn CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) b
          (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
            (x, shaped a hi p c pos) t)).2) q)).trans
        (congrArg (fun v => shaped a v p c pos) (thresholdBack_above up))
    | false =>
      ((congrArg Prod.snd (paced_succ (x, shaped a hi p c pos) t)).trans
        (congrArg (fun b => (turn CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) b
          (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
            (x, shaped a hi p c pos) t)).2) q)).trans now

/-- **From below, the rule in force stays the one read below the threshold**, at every step. -/
theorem threshold_rule_below {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) (short : lo ≤ c)
    {reads : Nat → Bool} {x : CarrierCounts} (below : ¬ CarrierCounts.favours x) : ∀ t,
    (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
      (x, shaped a lo p c pos) t).2 = shaped a lo p c pos
  | 0 => rfl
  | t + 1 =>
    have now := threshold_rule_below (reads := reads) step short below t
    have down : ¬ CarrierCounts.favours (paced CarrierCounts.select
        (byBack a p c pos (thresholdBack hi lo)) reads (x, shaped a lo p c pos) t).1 :=
      fun fav => below (CarrierCounts.upper (threshold_from_below step short below t) fav)
    match q : reads t with
    | true =>
      ((congrArg Prod.snd (paced_succ (x, shaped a lo p c pos) t)).trans
        (congrArg (fun b => (turn CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) b
          (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
            (x, shaped a lo p c pos) t)).2) q)).trans
        (congrArg (fun v => shaped a v p c pos) (thresholdBack_below down))
    | false =>
      ((congrArg Prod.snd (paced_succ (x, shaped a lo p c pos) t)).trans
        (congrArg (fun b => (turn CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) b
          (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
            (x, shaped a lo p c pos) t)).2) q)).trans now

/-- **A tipping point, from above.** With what comes back above the threshold exceeding the cost,
from a start where the shapers are at least as many as the others, their share rises strictly at
every step, under every schedule of reading. -/
theorem threshold_rises {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) (strict : c < hi)
    {reads : Nat → Bool} {x : CarrierCounts} (above : CarrierCounts.favours x) (some : 0 < x.carrier)
    (t : Nat) :
    (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
        (x, shaped a hi p c pos) t).1.carrier *
        (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
          (x, shaped a hi p c pos) (t + 1)).1.other <
      (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
        (x, shaped a hi p c pos) (t + 1)).1.carrier *
        (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
          (x, shaped a hi p c pos) t).1.other :=
  CarrierCounts.rises_strictly_along (x, shaped a hi p c pos) t
    (present_of_le (threshold_from_above step (Nat.le_of_lt strict) above t) some)
    (Eq.subst (motive := fun g : CarrierCounts => g.other < g.carrier)
      (threshold_rule_above step (Nat.le_of_lt strict) above t).symm
      (Nat.add_lt_add_right (Nat.add_lt_add_left strict a) p))

/-- From below, carriers present at the start stay present. -/
theorem threshold_present_below {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) (short : lo ≤ c)
    {reads : Nat → Bool} {x : CarrierCounts} (below : ¬ CarrierCounts.favours x) (some : 0 < x.carrier) :
    ∀ t, 0 < (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
      (x, shaped a lo p c pos) t).1.carrier
  | 0 => some
  | t + 1 =>
    Eq.subst (motive := fun y : CarrierCounts => 0 < y.carrier) (paced_fast_succ _ t).symm
      (Nat.mul_pos (threshold_present_below step short below some t)
        (Eq.subst (motive := fun g : CarrierCounts => 0 < g.carrier)
          (threshold_rule_below step short below t).symm
          (Nat.lt_of_lt_of_le pos (Nat.le_trans (Nat.le_add_right a lo) (Nat.le_add_right (a + lo) p)))))

/-- **A tipping point, from below.** With what comes back below the threshold short of the cost, from
a start where the shapers are fewer than the others, their share falls strictly at every step, the
shapers present at the start, under every schedule of reading. -/
theorem threshold_falls {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) (strict : lo < c)
    {reads : Nat → Bool} {x : CarrierCounts} (below : ¬ CarrierCounts.favours x) (some : 0 < x.carrier)
    (t : Nat) :
    (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
        (x, shaped a lo p c pos) (t + 1)).1.carrier *
        (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
          (x, shaped a lo p c pos) t).1.other <
      (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
        (x, shaped a lo p c pos) t).1.carrier *
        (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
          (x, shaped a lo p c pos) (t + 1)).1.other :=
  Eq.subst (motive := fun y : CarrierCounts =>
      y.carrier * (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
        (x, shaped a lo p c pos) t).1.other <
      (paced CarrierCounts.select (byBack a p c pos (thresholdBack hi lo)) reads
        (x, shaped a lo p c pos) t).1.carrier * y.other) (paced_fast_succ _ t).symm
    (falls_strictly (threshold_present_below step (Nat.le_of_lt strict) below some t)
      (Eq.subst (motive := fun g : CarrierCounts => g.carrier < g.other)
        (threshold_rule_below step (Nat.le_of_lt strict) below t).symm
        (Nat.add_lt_add_right (Nat.add_lt_add_left strict a) p)))

/-! ## Shaping among groups: the shared part weighted by assortment -/

section Groups

variable {α : Type}

open SelectionTerm SelectionLevels

/-- **The rule after shaping, in groups.** Listed as groups, each member shaping or not (`shapes`,
one or none): the shared part of a group is what its shapers give, `q` to every member of the group
for each shaper in it. In each group each shaper leaves the shapers' count of the rule after
shaping with that shared part, and each other the others' count. -/
def Grouped (gs : List (List α)) (w shapes : α → Nat) (a s q c : Nat) (pos : 0 < a) : Prop :=
  ∀ g, g ∈ gs → ∀ x, x ∈ g →
    (shapes x = 1 ∧ w x = (shaped a s (q * total g shapes) c pos).carrier) ∨
      (shapes x = 0 ∧ w x = (shaped a s (q * total g shapes) c pos).other)

/-- In groups the rule after shaping is a case of returns kept and shared within the group: each
member's offspring with `c` per unit of its shaping is `a + c` with `s` per unit of its own shaping
and `q` per unit its group holds. -/
theorem grouped_returns {gs : List (List α)} {w shapes : α → Nat} {a s q c : Nat} {pos : 0 < a}
    (grouped : Grouped gs w shapes a s q c pos) :
    ∀ g, g ∈ gs → ∀ x, x ∈ g →
      w x + c * shapes x = (a + c) + s * shapes x + q * total g shapes := fun g mg x mx =>
  match grouped g mg x mx with
  | .inl ⟨one, kept⟩ => by
    rw [one, kept, Nat.mul_one, Nat.mul_one]
    exact (Nat.add_right_comm (a + s) _ c).trans
      (congrArg (· + q * total g shapes) (Nat.add_right_comm a s c))
  | .inr ⟨zero, kept⟩ => by
    rw [zero, kept, Nat.mul_zero, Nat.mul_zero, Nat.add_zero, Nat.add_zero]
    rfl

/-- **The capacity to shape the rule, selected among groups.** Listed as groups of `m` members
each, the rule after shaping in each group with the group's shapers giving its shared part, the
whole selects for shaping exactly where `c` times the spread of shaping falls short of `s` times
it with `m` times `q` times the spread among groups (`SelectionLevels.rises_iff_kept`). Read over
the rationals, with the assortment `ρ` the share of the spread among groups, exactly where
`c < s + m q ρ`: Hamilton's rule with what comes back to the shapers alone added. -/
theorem grouped_rises_iff {gs : List (List α)} {w shapes : α → Nat} {a s q c m : Nat} {pos : 0 < a}
    (equal : ∀ g, g ∈ gs → g.length = m) (grouped : Grouped gs w shapes a s q c pos) :
    discord (whole gs) w shapes < concord (whole gs) w shapes ↔
      c * concord (whole gs) shapes shapes <
        s * concord (whole gs) shapes shapes + m * q * concordAmong gs shapes shapes :=
  rises_iff_kept gs w shapes equal (grouped_returns grouped)

/-- **With the shared part alike across groups** (groups alike in how many shape: assortment none,
the shared part coming to every member alike), where shaping varies, the whole selects for it
exactly where `c < s`: the direction of `favours_iff`, whatever is shared. -/
theorem grouped_alike_iff {gs : List (List α)} {w shapes : α → Nat} {a s q c m d : Nat}
    {pos : 0 < a} (equal : ∀ g, g ∈ gs → g.length = m) (grouped : Grouped gs w shapes a s q c pos)
    (alike : ∀ g, g ∈ gs → total g shapes = d) (varies : 0 < concord (whole gs) shapes shapes) :
    discord (whole gs) w shapes < concord (whole gs) w shapes ↔ c < s :=
  (grouped_rises_iff equal grouped).trans (by
    rw [(among_none_of_alike (w := shapes) alike).1, Nat.mul_zero, Nat.add_zero, Nat.mul_comm c,
      Nat.mul_comm s]
    exact ⟨SelectionTerm.lt_of_mul_lt_mul, fun lt => Nat.mul_lt_mul_of_pos_left lt varies⟩)

/-- **What comes back alone is not undone by assortment.** Where it exceeds the cost (`c < s`) and
shaping varies, the whole selects for shaping however the groups are formed and whatever is
shared. -/
theorem grouped_kept_rises {gs : List (List α)} {w shapes : α → Nat} {a s q c m : Nat}
    {pos : 0 < a} (equal : ∀ g, g ∈ gs → g.length = m) (grouped : Grouped gs w shapes a s q c pos)
    (covers : c < s) (varies : 0 < concord (whole gs) shapes shapes) :
    discord (whole gs) w shapes < concord (whole gs) w shapes :=
  (grouped_rises_iff equal grouped).mpr
    (Nat.lt_of_lt_of_le (Nat.mul_lt_mul_of_pos_right covers varies) (Nat.le_add_right _ _))

/-- **With the shapers together** (groups uniform in shaping, assortment one), where the groups
differ, the whole selects for shaping exactly where `c < s + m q`: a shared part of the group
selects shaping where the cost exceeds what comes back alone. -/
theorem grouped_uniform_iff {gs : List (List α)} {w shapes : α → Nat} {a s q c m : Nat}
    {pos : 0 < a} (equal : ∀ g, g ∈ gs → g.length = m) (grouped : Grouped gs w shapes a s q c pos)
    (uniform : ∀ g, g ∈ gs → ∃ v, ∀ x, x ∈ g → shapes x = v)
    (differ : 0 < concordAmong gs shapes shapes) :
    discord (whole gs) w shapes < concord (whole gs) w shapes ↔ c < s + m * q :=
  (grouped_rises_iff equal grouped).trans (by
    rw [spread_levels gs shapes equal, (within_none_of_uniform (w := shapes) uniform).1,
      Nat.mul_zero, Nat.zero_add, ← add_mul_split, Nat.mul_comm c, Nat.mul_comm (s + m * q)]
    exact ⟨SelectionTerm.lt_of_mul_lt_mul, fun lt => Nat.mul_lt_mul_of_pos_left lt differ⟩)

end Groups

/-! ## Witnesses -/

namespace Split

theorem one_pos : 0 < 1 := Nat.zero_lt_one

/-- One to one: one shaper to each other. -/
def even : CarrierCounts := ⟨1, 1, Nat.zero_lt_one⟩

/-- **Two of five come back**: with `s + p = 5` to each shaper, two of them to the shapers alone and
three to every member, at a cost of one, each shaper leaves six and each other five. -/
theorem favours : CarrierCounts.favours (shaped 1 2 3 1 one_pos) := favours_iff.mpr (Nat.le_succ 1)

/-- **None of five comes back**: with all five to every member, at the same cost, each shaper leaves
six and each other seven. -/
theorem shared_disfavours : ¬ CarrierCounts.favours (shaped 1 0 5 1 one_pos) :=
  fun fav => absurd (favours_iff.mp fav) (by decide)

/-- From one to one, the shapers' share rises where two of the five come back to them. -/
theorem rises : even.carrier * (CarrierCounts.select even (shaped 1 2 3 1 one_pos)).other <
    (CarrierCounts.select even (shaped 1 2 3 1 one_pos)).carrier * even.other := by decide

/-- From one to one, it falls where none of the five does. -/
theorem falls : (CarrierCounts.select even (shaped 1 0 5 1 one_pos)).carrier * even.other <
    even.carrier * (CarrierCounts.select even (shaped 1 0 5 1 one_pos)).other := by decide

end Split

namespace SharedFlips

theorem one_pos : 0 < 1 := Nat.zero_lt_one

/-- **With nothing shared, two steps before and three with what comes back lower the shapers' share**
(`a = 1`, `c = 1`, `s = 2`). -/
theorem without_falls {x : CarrierCounts} (some : 0 < x.carrier) :
    ¬ CarrierCounts.order.le x (Law.orbit (fun y => CarrierCounts.select y (shaped 1 2 0 1 one_pos))
        (Law.orbit (fun y => CarrierCounts.select y (shaped 1 0 0 1 one_pos)) x 2) 3) :=
  fun le => absurd ((stretch_iff some 2 3).mp le) (by decide)

/-- **With one to every member, the same steps raise it.** -/
theorem with_rises {x : CarrierCounts} (some : 0 < x.carrier) :
    x.carrier * (Law.orbit (fun y => CarrierCounts.select y (shaped 1 2 1 1 one_pos))
        (Law.orbit (fun y => CarrierCounts.select y (shaped 1 0 1 1 one_pos)) x 2) 3).other <
      (Law.orbit (fun y => CarrierCounts.select y (shaped 1 2 1 1 one_pos))
        (Law.orbit (fun y => CarrierCounts.select y (shaped 1 0 1 1 one_pos)) x 2) 3).carrier * x.other :=
  (stretch_lt_iff some 2 3).mpr (by decide)

end SharedFlips

namespace Timing

theorem two_pos : 0 < 2 := Nat.zero_lt_succ 1

/-- **Soon enough**: one step before what comes back and two with it (`a = 2`, `c = 1`, `s = 2`,
nothing shared), the shapers present, raise their share. -/
theorem soon_rises {x : CarrierCounts} (some : 0 < x.carrier) :
    x.carrier * (Law.orbit (fun y => CarrierCounts.select y (shaped 2 2 0 1 two_pos))
        (Law.orbit (fun y => CarrierCounts.select y (shaped 2 0 0 1 two_pos)) x 1) 2).other <
      (Law.orbit (fun y => CarrierCounts.select y (shaped 2 2 0 1 two_pos))
        (Law.orbit (fun y => CarrierCounts.select y (shaped 2 0 0 1 two_pos)) x 1) 2).carrier * x.other :=
  (stretch_lt_iff some 1 2).mpr (by decide)

/-- **Two steps before and two with it lower the share.** -/
theorem late_falls {x : CarrierCounts} (some : 0 < x.carrier) :
    ¬ CarrierCounts.order.le x (Law.orbit (fun y => CarrierCounts.select y (shaped 2 2 0 1 two_pos))
        (Law.orbit (fun y => CarrierCounts.select y (shaped 2 0 0 1 two_pos)) x 2) 2) :=
  fun le => absurd ((stretch_iff some 2 2).mp le) (by decide)

/-- **One step before and one with it lower the share too.** -/
theorem shorter_falls {x : CarrierCounts} (some : 0 < x.carrier) :
    ¬ CarrierCounts.order.le x (Law.orbit (fun y => CarrierCounts.select y (shaped 2 2 0 1 two_pos))
        (Law.orbit (fun y => CarrierCounts.select y (shaped 2 0 0 1 two_pos)) x 1) 1) :=
  fun le => absurd ((stretch_iff some 1 1).mp le) (by decide)

/-- **After five steps before, seven with what comes back lower the share** ... -/
theorem seven_falls {x : CarrierCounts} (some : 0 < x.carrier) :
    ¬ CarrierCounts.order.le x (Law.orbit (fun y => CarrierCounts.select y (shaped 2 2 0 1 two_pos))
        (Law.orbit (fun y => CarrierCounts.select y (shaped 2 0 0 1 two_pos)) x 5) 7) :=
  fun le => absurd ((stretch_iff some 5 7).mp le) (by decide)

/-- ... **and eight raise it**: enough steps with what comes back outweigh the steps before it. -/
theorem eight_rises {x : CarrierCounts} (some : 0 < x.carrier) :
    x.carrier * (Law.orbit (fun y => CarrierCounts.select y (shaped 2 2 0 1 two_pos))
        (Law.orbit (fun y => CarrierCounts.select y (shaped 2 0 0 1 two_pos)) x 5) 8).other <
      (Law.orbit (fun y => CarrierCounts.select y (shaped 2 2 0 1 two_pos))
        (Law.orbit (fun y => CarrierCounts.select y (shaped 2 0 0 1 two_pos)) x 5) 8).carrier * x.other :=
  (stretch_lt_iff some 5 8).mpr (by decide)

end Timing

namespace Assorting

open SelectionTerm SelectionLevels SelectionLevels.Member SelectionLevels.Founding

theorem one_pos : 0 < 1 := Nat.zero_lt_one

/-- Two shapers and two others, one coming back to each shaper alone, two the cost, one to every
member of its group for each shaper in it. With the shapers together each leaves four and each
other three. -/
def assortedOffspring : SelectionLevels.Member → Nat
  | .held => 4
  | .mate => 4
  | .first => 3
  | .second => 3

/-- With the shapers apart each leaves three and each other four. -/
def mixedOffspring : SelectionLevels.Member → Nat
  | .held => 3
  | .mate => 3
  | .first => 4
  | .second => 4

theorem assorted_grouped : Grouped assorted assortedOffspring keeps 1 1 1 2 one_pos
  | _, .head _, _, .head _ => .inl ⟨rfl, rfl⟩
  | _, .head _, _, .tail _ (.head _) => .inl ⟨rfl, rfl⟩
  | _, .head _, _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.head _), _, .head _ => .inr ⟨rfl, rfl⟩
  | _, .tail _ (.head _), _, .tail _ (.head _) => .inr ⟨rfl, rfl⟩
  | _, .tail _ (.head _), _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.tail _ mem), _, _ => nomatch mem

theorem mixed_grouped : Grouped mixed mixedOffspring keeps 1 1 1 2 one_pos
  | _, .head _, _, .head _ => .inl ⟨rfl, rfl⟩
  | _, .head _, _, .tail _ (.head _) => .inr ⟨rfl, rfl⟩
  | _, .head _, _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.head _), _, .head _ => .inl ⟨rfl, rfl⟩
  | _, .tail _ (.head _), _, .tail _ (.head _) => .inr ⟨rfl, rfl⟩
  | _, .tail _ (.head _), _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.tail _ mem), _, _ => nomatch mem

/-- **The cost above what comes back alone, and shaping selected among groups.** With a cost of
two and one coming back to each shaper alone, so that within every group the rule after shaping
disfavours the shapers (`favours_iff` fails), the whole selects for shaping where the shapers are
grouped together, eight falling short of four with eight, and against it where they are apart,
nothing then lying among the groups. -/
theorem either_verdict :
    ¬ CarrierCounts.favours (shaped 1 1 2 2 one_pos) ∧
      discord (whole assorted) assortedOffspring keeps <
        concord (whole assorted) assortedOffspring keeps ∧
      2 * concord (whole assorted) keeps keeps = 8 ∧
      1 * concord (whole assorted) keeps keeps + 2 * 1 * concordAmong assorted keeps keeps = 12 ∧
      concord (whole mixed) mixedOffspring keeps < discord (whole mixed) mixedOffspring keeps ∧
      concordAmong mixed keeps keeps = 0 :=
  ⟨fun fav => absurd (favours_iff.mp fav) (by decide),
    (grouped_rises_iff assorted_equal assorted_grouped).mpr (by decide), rfl, rfl, by decide, rfl⟩

end Assorting

end RuleShaping

end Becoming
