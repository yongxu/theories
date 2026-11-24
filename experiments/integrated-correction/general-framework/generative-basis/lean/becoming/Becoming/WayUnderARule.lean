import Becoming.TurningInTime
import Becoming.SelectionTerm
import Becoming.ReadingsPersist
import Becoming.RuleCapture

/-!
# A way of units under a rule set again, on a stock

AI-written, 23 November 2026; Stage 2 join below `Becoming.LineOnAStock`, 24 November 2026. Unit,
way, rule, share, level, need and test are working names.

## The model

A type `U` of units, each with a need and a use (`need use : U → Nat`), and a type `R` of rules.
Under a rule `g` a unit `u` leaves the units `kids g u`. At one step without a rule, each unit of a
way leaves its kids where `x` meets its need and nothing where it does not (`stepAfter`), what a way
takes is the total of its units' uses (`taken`), and the level becomes
`RegimeMargin.step giving (taken use w) x` (`stepLeft`), with some need met (`stepGoes`), every unit's
kids in order (`allKids`), `n`-th generations (`generation`, `stepNeeding`), a bound on needs along a
subset (`Below`), a configuration that holds (`Holds`), and the regime at a way (`Regime`). Under a
rule, a configuration is `((w, g), x)`: a way (a list of units), the rule in force, a level. After a
step at level `x` the way is `stepAfter need (kids g) w x` and the rule is `next w g`, set from the
way present before the step (`after`); the level is `stepLeft giving use w x` (`left`). The step is
`TurningInTime.pair` of the two (`step`), `course` its orbit, and the net has a next while some
unit's need is met (`Goes`, `net`, `Law.stepWhile`). A rule can favour (`favours : R → Prop`); the
"or" (`tested_or_ends`) asks nothing of `next`.

The test at a configuration (`Tested`): its way and level hold (`Holds`: the way is not empty, every
need is met, and the level is at or above what the way takes and `y` of it), the rule in force does
not favour, and the rule set next does not favour.

## What is stated

* **The level stays within the cap** (`within_along`): with the start at most `hi` and the step
  under what the way takes keeping levels within `hi` along the course, every level the course
  reaches with some need met at every step before it is at most `hi`.
* **One of two outcomes** (`tested_or_ends`): with `favours` decided; under a rule that favours each
  unit's kids together take more than it; under a rule that does not they together take what it
  takes; kids need no more than their parent under every rule; every unit the course reaches needs
  something; nothing given from nothing, the start at most `hi`; and along the course (at steps with
  some need met there and at every step before) the step under what the way takes keeping levels
  within `hi` and, under a rule that does not favour, with `T` what the way takes, giving short of
  `T` at every level below `y T` and at least `T` at every level left `z` with `y T ≤ z` and
  `z + T ≤ hi`. Then the course comes to a step with the test, some need met at every step before
  it, or to a step with no need met, some need met at every step before it. That under a rule that
  does not favour every unit has kids (`some`) is not asked. The "or" is inclusive:
  `BothOutcomes.both` is a course that meets every premise, has the test at its start and no need
  met at its step 4. Laws of one step instantiate the single-step helpers at `kids := kids g`, and
  `level_held` is `RegimeMargin.holds`.
* **The least step with the test** (`first_tested`, `first_tested_or_ends`): with `favours`
  decided, a course with a step with the test has one before which no step has it
  (`first_of_decided`); so the first outcome can be read as a first step with the test.
* **The first outcome lasts** (`tested_lasts`): with `even`, `some`, `down`, `high`, `keepsAlong`
  and `regimeAlong` (of `regimeAlong` only its `Meets` half, at the step with the test), the rule
  set next read from a share of the way (`next := fun w g => h (share w) g`), and `lowers` (under a
  rule that does not favour, the share of all the kids of a way is not above the way's), `monotone`
  (`RuleCapture.ReadsShare`) and `upper` (a rule above a favouring rule favours): if the course
  comes to a step with the test, some need met at every step before it, the net never ends. Not
  asked: `grows`, `needs`, `nothing`, that `favours` is decided. `some` (under a rule that does not
  favour every unit has kids) is asked here and not by the "or": it keeps the way after a holding
  step from being empty. That no later rule favours is carried by `RuleCapture.turn_locked` at the
  orders reversed (`lasts_from`).
* **The two outcomes shut each other out** (`unending_iff_tested`, `ends_iff_unmet`): under the
  premises of `tested_or_ends` and of `tested_lasts` together, the net never ends exactly where the
  course comes to a step with the test, and ends exactly where it comes to a step with no need met
  (in both, some need met at every step before it; right to left of the second asks no premise).
  Corollaries of `tested_or_ends` and `tested_lasts`.
* **From a locked start** (`locked_while_met`, `favours_while_met`, `unmet_before_unfavoured`,
  `unmet_before_tested`): with `raises`, `monotone`, `upper` and the start `RuleCapture.Locked`,
  and no premise on the stock, the rule favours at every step up to one after the first step with
  a need unmet, so the test comes at least two steps after a need went unmet. The lock is carried
  by `RuleCapture.turn_locked`, a step at which every need is met being a turn (`step_turn`).
* **Two courses that differ in one unit of one need** (`TwoKinds`, `NeedTwentySeven`,
  `NeedTwentySix`): two kinds `F` and `O`, the rule `true` favouring, the share the number of `F`,
  giving `min z (32 - z)`, from one `F` under `true` at twenty-eight. Every premise of
  `tested_or_ends`, of `tested_lasts` and of the locked start holds where `F` needs something
  (`TwoKinds.premises`). Where `F` needs twenty-seven the test holds at step 4 and the net never
  ends (`NeedTwentySeven.goes_on`, by `tested_lasts`). Where it
  needs twenty-six no need is met at step 4, so the net ends (the half of `ends_iff_unmet` that asks
  no premise), and no step with some need met at every step before it has the test
  (`NeedTwentySix.ends_untested`, by `unending_iff_tested`, right to left, which is `tested_lasts`;
  the qualifier is redundant by an argument not in the module). In the first, what goes on is twelve
  `O` (`course_values`) and the one `F` the rule counted is gone: on Ren's 24 November 2026
  decision (`2B`), `NeedTwentySeven` counts strictly as ecological exhaustion (`Tested`) after the
  counted unit dies off, reserving *turning in time* for pre-exhaustion course change. Not proved in
  this module (found by program on 20 November 2026): with the rule held favouring the same start
  comes to a step with no need met, and with the rule that does not favour held from the first move
  something goes on too. In both courses `lowers` and `raises` hold as equalities (all the kids of a
  way have its share under either rule), so the share changes only at a step where a need is unmet.
* **A course with both outcomes** (`BothOutcomes`): one unit needing one and taking one; rules `a`,
  `b`, `c`, of which only `c` favours; under `a` and `b` the unit leaves itself, under `c` two;
  after `a` comes `b`, after `b` and after `c` comes `c`; the same giving, `y T = T`, `hi = 32`,
  from one unit under `a` at two. Every premise of `tested_or_ends` holds, the test holds at step 0,
  some need is met at steps 0 to 3 and none at step 4 (`BothOutcomes.both`): under those premises
  alone the "or" is inclusive. What shuts the outcomes out of each other is `tested_lasts`, whose
  premises this course does not meet: no reading of this `next` from a share of the way has
  `lowers`, `monotone` and `upper` (`BothOutcomes.not_read_from_a_share`, by `tested_lasts`; which
  of the three fails is not stated).
* **At one rule** (`course_one_rule`, `way_one_rule`, `goes_one_rule`, `tested_one_rule`): with
  `R := PUnit` the course is `Law.orbit (TurningInTime.pair (stepAfter need kids) (stepLeft giving use))`
  with the rule carried, and the test at a rule that does not favour is `Holds`. `Becoming.LineOnAStock`
  imports this module and proves `unending_iff_holds` and `way_ends` directly from
  `unending_iff_tested` and `tested_or_ends`.

What is not stated: a bound on either step; that a need goes unmet from a locked start; that any
actual selection meets these premises. The going on found is a configuration that holds: no unit
here adds to what it rests on.

Every declaration has an empty axiom report.
-/

namespace Becoming
namespace WayUnderARule

variable {U R : Type}

/-! ## 0. Shared single-step primitives on ways and levels -/

/-- The way after a single-rule step at level `x`: each unit in turn leaves its kids where `x`
meets its need, and nothing where it does not. -/
def stepAfter (need : U → Nat) (kids : U → List U) : List U → Nat → List U
  | [], _ => []
  | u :: w, x => cond (decide (need u ≤ x)) (kids u) [] ++ stepAfter need kids w x

attribute [simp] stepAfter

/-- What a way takes: the total of its units' uses (`Becoming.total`, the total of `Prelude`). -/
abbrev taken (use : U → Nat) (w : List U) : Nat := total w use

/-- The level after a single-rule step: `RegimeMargin.step` under what every unit present takes. -/
def stepLeft (giving : Nat → Nat) (use : U → Nat) (w : List U) (x : Nat) : Nat :=
  RegimeMargin.step giving (taken use w) x

/-- Some unit of a way has its need met at the level. -/
abbrev stepGoes (need : U → Nat) (s : List U × Nat) : Prop := ∃ u, u ∈ s.1 ∧ need u ≤ s.2

/-- The kids of every unit of a way, in order: the way after a step at which every need is met. -/
def allKids (kids : U → List U) : List U → List U
  | [] => []
  | u :: w => kids u ++ allKids kids w

attribute [simp] allKids

/-- The `n`-th generation of a way with no level in it: the kids of the kids … of its units. -/
def generation (kids : U → List U) : Nat → List U → List U
  | 0, w => w
  | n + 1, w => allKids kids (generation kids n w)

/-- Every unit of every single-rule generation of `w` needs something. -/
abbrev stepNeeding (need : U → Nat) (kids : U → List U) (w : List U) : Prop :=
  ∀ n u, u ∈ generation kids n w → 0 < need u

/-- A configuration of a way and level from which what its way takes holds: the way is not empty,
every unit's need is met at the level, and the level is at or above what the way takes and `y` of
it. -/
abbrev Holds (need use : U → Nat) (y : Nat → Nat) (s : List U × Nat) : Prop :=
  s.1 ≠ [] ∧ (∀ u, u ∈ s.1 → need u ≤ s.2) ∧ taken use s.1 + y (taken use s.1) ≤ s.2

/-- The regime at a way `w`: giving short of what `w` takes below `y` of it, meeting it from there
up to `hi`, and the step under it keeping the level within `hi`. -/
abbrev Regime (giving : Nat → Nat) (use : U → Nat) (y : Nat → Nat) (hi : Nat) (w : List U) : Prop :=
  RegimeMargin.Short giving (taken use w) (y (taken use w)) ∧
    RegimeMargin.Meets giving (taken use w) (y (taken use w)) hi ∧
    RegimeMargin.Keeps giving (taken use w) hi

/-- Every unit with `S` in `w` needs at most `m`. -/
abbrev Below (need : U → Nat) (S : U → Prop) (m : Nat) (w : List U) : Prop :=
  ∀ u, u ∈ w → S u → need u ≤ m

theorem mem_cond {a : U} {l : List U} : ∀ {b : Bool}, a ∈ cond b l [] → b = true ∧ a ∈ l
  | true, m => ⟨rfl, m⟩
  | false, m => nomatch m

theorem mem_cond_of {a : U} {l : List U} : ∀ {b : Bool}, b = true → a ∈ l → a ∈ cond b l []
  | true, _, m => m

/-- At a level, either every unit of a way has its need met, or some unit's need is above it. -/
theorem met_or_unmet (need : U → Nat) (z : Nat) :
    ∀ w : List U, (∀ u, u ∈ w → need u ≤ z) ∨ ∃ u, u ∈ w ∧ z < need u :=
  fun w => gather_listed (D := fun u => need u ≤ z) w
    (fun u mem k => (Nat.lt_or_ge z (need u)).elim (fun lt => .inr ⟨u, mem, lt⟩) k) Or.inl

/-- Whether some unit of a way has its need met at `x`, computed along the way. -/
def anyMet (need : U → Nat) (x : Nat) : List U → Bool
  | [] => false
  | u :: w => decide (need u ≤ x) || anyMet need x w

theorem anyMet_iff (need : U → Nat) (x : Nat) :
    ∀ w : List U, anyMet need x w = true ↔ ∃ u, u ∈ w ∧ need u ≤ x
  | [] => ⟨fun h => absurd h Bool.false_ne_true, fun ⟨_, m, _⟩ => nomatch m⟩
  | v :: w => by
    show (decide (need v ≤ x) || anyMet need x w) = true ↔ _
    cases hv : decide (need v ≤ x) with
    | true => exact ⟨fun _ => ⟨v, .head w, of_decide_eq_true hv⟩, fun _ => rfl⟩
    | false =>
      exact (anyMet_iff need x w).trans
        ⟨fun ⟨u, m, le⟩ => ⟨u, .tail v m, le⟩,
         fun ⟨u, m, le⟩ => by
          cases m with
          | head => exact absurd (hv.symm.trans (decide_eq_true le)) Bool.false_ne_true
          | tail _ m' => exact ⟨u, m', le⟩⟩

/-- Whether some unit's need is met at `(w, x)` is decided, by `anyMet`. -/
instance stepGoesDecidable (need : U → Nat) (s : List U × Nat) : Decidable (stepGoes need s) :=
  decidable_of_iff (anyMet need s.2 s.1 = true) (anyMet_iff need s.2 s.1)

/-- A list that is not empty has a member. -/
theorem mem_of_ne_nil : ∀ {l : List U}, l ≠ [] → ∃ v, v ∈ l
  | [], ne => absurd rfl ne
  | v :: l, _ => ⟨v, .head l⟩

/-- Strong induction on a number: `Identification.below_upto`. -/
theorem strong_below {P : Nat → Prop} (step : ∀ m, (∀ m', m' < m → P m') → P m) :
    ∀ M m, m < M → P m :=
  Identification.below_upto step

/-- A step under a draw at least the level leaves nothing, with nothing given from nothing. -/
theorem step_zero {giving : Nat → Nat} {H x : Nat} (nothing : RegimeMargin.FromNothing giving)
    (le : x ≤ H) : RegimeMargin.step giving H x = 0 := by
  show x - H + giving (x - H) = 0
  rw [sub_eq_zero_of_le le]
  exact (Nat.zero_add _).trans nothing

/-- Below `H + y`, a step lowers the level or leaves nothing: `TurningInTime.held_above`
contraposed. -/
theorem step_lowers {giving : Nat → Nat} {H y D z : Nat} (short : RegimeMargin.Short giving H y)
    (nothing : RegimeMargin.FromNothing giving) (more : H ≤ D) (below : z < H + y) :
    RegimeMargin.step giving D z = 0 ∨ RegimeMargin.step giving D z < z :=
  (Nat.lt_or_ge (RegimeMargin.step giving D z) z).elim .inr fun ge => match z, below, ge with
    | 0, _, _ => .inl (step_zero nothing (Nat.zero_le D))
    | _ + 1, below, ge => absurd (TurningInTime.held_above nothing short more (Nat.succ_pos _) ge)
        (Nat.not_le_of_gt below)

section BaseStep

variable {need : U → Nat} {kids : U → List U}

/-- The way after a step is `List.flatMap` of what each unit leaves. -/
theorem after_flatMap (x : Nat) :
    ∀ w : List U, stepAfter need kids w x = w.flatMap fun u => cond (decide (need u ≤ x)) (kids u) []
  | [] => rfl
  | u :: w => congrArg (cond (decide (need u ≤ x)) (kids u) [] ++ ·) (after_flatMap x w)

/-- A unit is in the way after a step at `x` exactly where it is a kid of a unit of the way whose
need `x` meets. -/
theorem mem_after_iff {x : Nat} {v : U} {w : List U} :
    v ∈ stepAfter need kids w x ↔ ∃ u, u ∈ w ∧ need u ≤ x ∧ v ∈ kids u :=
  (Eq.subst (motive := fun l => v ∈ l ↔ ∃ u, u ∈ w ∧ v ∈ cond (decide (need u ≤ x)) (kids u) [])
      (after_flatMap x w).symm ListTests.mem_flatMap_iff).trans
    ⟨fun ⟨u, mu, mc⟩ => match mem_cond mc with
      | ⟨e, mk⟩ => ⟨u, mu, of_decide_eq_true e, mk⟩,
     fun ⟨u, mu, le, mk⟩ => ⟨u, mu, mem_cond_of (decide_eq_true le) mk⟩⟩

/-- Where every unit's need is met at `x`, the way after a step is all the kids. -/
theorem after_of_met {x : Nat} :
    ∀ {w : List U}, (∀ u, u ∈ w → need u ≤ x) → stepAfter need kids w x = allKids kids w
  | [], _ => rfl
  | u :: w, met =>
    (congrArg (fun b => cond b (kids u) [] ++ stepAfter need kids w x)
        (decide_eq_true (met u (.head w)))).trans
      (congrArg (kids u ++ ·) (after_of_met fun v m => met v (.tail u m)))

/-- All the kids of a way are `List.flatMap kids` of it. -/
theorem allKids_flatMap : ∀ w : List U, allKids kids w = w.flatMap kids
  | [] => rfl
  | u :: w => congrArg (kids u ++ ·) (allKids_flatMap w)

/-- A unit is among all the kids of a way exactly where it is a kid of a unit of the way. -/
theorem mem_allKids_iff {v : U} {w : List U} : v ∈ allKids kids w ↔ ∃ u, u ∈ w ∧ v ∈ kids u :=
  Eq.subst (motive := fun l => v ∈ l ↔ ∃ u, u ∈ w ∧ v ∈ kids u) (allKids_flatMap w).symm
    ListTests.mem_flatMap_iff

/-- A unit of the way at step `k` of a single-rule course is a unit of the `k`-th generation of the
start's way. -/
theorem mem_generation {giving : Nat → Nat} {use : U → Nat} (s : List U × Nat) :
    ∀ k u,
      u ∈ (Law.orbit (TurningInTime.pair (stepAfter need kids) (stepLeft giving use)) s k).1 →
        u ∈ generation kids k s.1
  | 0, _, m => m
  | k + 1, _, m =>
    match (mem_after_iff (need := need) (kids := kids)
        (w := (Law.orbit (TurningInTime.pair (stepAfter need kids) (stepLeft giving use)) s k).1)
        (x := (Law.orbit (TurningInTime.pair (stepAfter need kids) (stepLeft giving use)) s k).2)).mp m with
    | ⟨p, mp, _, mk⟩ => mem_allKids_iff.mpr ⟨p, mem_generation s k p mp, mk⟩

end BaseStep

section BaseLine

variable {need : U → Nat} {kids : U → List U} {use : U → Nat} {S : U → Prop}

/-- A unit with `S` in the way after a step is a kid of a unit with `S` whose need was met, where
`S` is closed backward under `kids`. -/
theorem line_from_line (closed : ∀ u v, v ∈ kids u → S v → S u) {w : List U} {x : Nat} {v : U}
    (mv : v ∈ stepAfter need kids w x) (sv : S v) : ∃ u, u ∈ w ∧ need u ≤ x ∧ S u ∧ v ∈ kids u :=
  match (mem_after_iff (need := need) (kids := kids)).mp mv with
  | ⟨u, mu, le, mk⟩ => ⟨u, mu, le, closed u v mk sv, mk⟩

/-- With `closed` and `down`, every unit of `S` in the way after a step at `x` needs at most `x`. -/
theorem below_after (closed : ∀ u v, v ∈ kids u → S v → S u)
    (down : ∀ u v, S u → v ∈ kids u → need v ≤ need u) (w : List U) (x : Nat) :
    Below need S x (stepAfter need kids w x) :=
  fun _ mv sv => match line_from_line closed mv sv with
  | ⟨u, _, le, su, mk⟩ => Nat.le_trans (down u _ su mk) le

/-- With `closed` and `down`, a way whose units in `S` need at most `m` leaves one that does. -/
theorem below_keeps (closed : ∀ u v, v ∈ kids u → S v → S u)
    (down : ∀ u v, S u → v ∈ kids u → need v ≤ need u) {m : Nat} {w : List U}
    (below : Below need S m w) (x : Nat) : Below need S m (stepAfter need kids w x) :=
  fun _ mv sv => match line_from_line closed mv sv with
  | ⟨u, mu, _, su, mk⟩ => Nat.le_trans (down u _ su mk) (below u mu su)

/-- Where every unit's kids together take more than it (`grows`), all the kids of a way take at
least what the way takes and its length. -/
theorem allKids_rises (grows : ∀ u, use u < taken use (kids u)) :
    ∀ w : List U, taken use w + w.length ≤ taken use (allKids kids w)
  | [] => Nat.le_refl 0
  | u :: w =>
    Nat.le_trans
      (Nat.le_of_eq
        (((congrArg (use u + taken use w + ·) (Nat.add_comm w.length 1)).trans
          (Nat.add_add_add_comm (use u) 1 (taken use w) w.length).symm)))
      (Nat.le_trans
        (Nat.add_le_add (Nat.succ_le_of_lt (grows u)) (allKids_rises grows w))
        (Nat.le_of_eq (total_append use (allKids kids w) (kids u)).symm))

/-- Where each unit's kids together take what it takes (`even`), all the kids of a way take what
the way takes. -/
theorem taken_allKids (even : ∀ u, taken use (kids u) = use u) (w : List U) :
    taken use (allKids kids w) = taken use w :=
  (congrArg (taken use) (allKids_flatMap w)).trans
    ((SelectionTerm.Generations.total_flatMap kids use w).trans (total_congr even w))

end BaseLine

/-! ## 1. The model -/

/-- The way and the rule after a step at level `x`: the way is `stepAfter` under the kids of the
rule in force, and the rule is `next` of the way present before the step and the rule in force. -/
def after (need : U → Nat) (kids : R → U → List U) (next : List U → R → R) (p : List U × R)
    (x : Nat) : List U × R :=
  (stepAfter need (kids p.2) p.1 x, next p.1 p.2)

/-- The level after a step: `stepLeft` at the way; the rule is not read. -/
def left (giving : Nat → Nat) (use : U → Nat) (p : List U × R) (x : Nat) : Nat :=
  stepLeft giving use p.1 x

/-- The pair's step: the way and rule after a step and the level after it
(`TurningInTime.pair`). -/
abbrev step (need : U → Nat) (kids : R → U → List U) (next : List U → R → R)
    (giving : Nat → Nat) (use : U → Nat) : (List U × R) × Nat → (List U × R) × Nat :=
  TurningInTime.pair (after need kids next) (left giving use)

/-- The course: the pair's orbit from `s`. -/
abbrev course (need : U → Nat) (kids : R → U → List U) (next : List U → R → R)
    (giving : Nat → Nat) (use : U → Nat) (s : (List U × R) × Nat) : Nat → (List U × R) × Nat :=
  Law.orbit (step need kids next giving use) s

/-- Some unit of the way has its need met at the level: `stepGoes` at the way and the level. -/
def Goes (need : U → Nat) (s : (List U × R) × Nat) : Prop :=
  stepGoes need (s.1.1, s.2)

/-- Whether some unit's need is met is decided: `stepGoesDecidable`. -/
instance goesDecidable (need : U → Nat) (s : (List U × R) × Nat) : Decidable (Goes need s) :=
  stepGoesDecidable need (s.1.1, s.2)

/-- The net: the pair's step while some unit's need is met, and nothing where none is. -/
def net (need : U → Nat) (kids : R → U → List U) (next : List U → R → R) (giving : Nat → Nat)
    (use : U → Nat) : «际» ((List U × R) × Nat) :=
  Law.stepWhile (Goes need) (step need kids next giving use)

/-- The test at a configuration: its way and level hold (`Holds`: the way is not empty, every
unit's need is met, and the level is at or above what the way takes and `y` of it), the rule in
force does not favour, and the rule set next does not favour. -/
def Tested (need use : U → Nat) (y : Nat → Nat) (favours : R → Prop) (next : List U → R → R)
    (s : (List U × R) × Nat) : Prop :=
  Holds need use y (s.1.1, s.2) ∧ ¬ favours s.1.2 ∧ ¬ favours (next s.1.1 s.1.2)

/-! ## 2. One step at the rule in force -/

section Step

variable {need use : U → Nat} {kids : R → U → List U} {next : List U → R → R}
  {giving : Nat → Nat} {favours : R → Prop}

/-- Where under a rule that favours each unit's kids together take more than it (`grows`), the rule
in force favours, the way has a unit and every need is met: the way after the step takes at least
one more. `allKids_rises` at the kids of the rule in force, the next way being all the kids
(`after_of_met`). -/
theorem taken_rises (grows : ∀ g, favours g → ∀ u, use u < taken use (kids g u))
    {t : (List U × R) × Nat} (fav : favours t.1.2) {v : U} (mv : v ∈ t.1.1)
    (met : ∀ u, u ∈ t.1.1 → need u ≤ t.2) :
    taken use t.1.1 + 1 ≤ taken use (step need kids next giving use t).1.1 :=
  Eq.subst (motive := fun l => taken use t.1.1 + 1 ≤ taken use l)
    (after_of_met (kids := kids t.1.2) met).symm
    (Nat.le_trans (Nat.add_le_add_left (length_pos_of_mem mv) _)
      (allKids_rises (grows t.1.2 fav) t.1.1))

/-- Where under a rule that does not favour each unit's kids together take what it takes (`even`),
the rule in force does not favour and every need is met: the way after the step takes what the way
takes. `taken_allKids` at the kids of the rule in force, with `after_of_met`. -/
theorem taken_kept (even : ∀ g, ¬ favours g → ∀ u, taken use (kids g u) = use u)
    {t : (List U × R) × Nat} (notfav : ¬ favours t.1.2) (met : ∀ u, u ∈ t.1.1 → need u ≤ t.2) :
    taken use (step need kids next giving use t).1.1 = taken use t.1.1 :=
  (congrArg (taken use) (after_of_met (kids := kids t.1.2) met)).trans
    (taken_allKids (even t.1.2 notfav) t.1.1)

/-- With kids needing no more than their parent under every rule (`down`), a way whose units need at
most `m` leaves one whose units need at most `m`. `below_keeps` at the kids of the rule in force. -/
theorem below_kept (down : ∀ g u v, v ∈ kids g u → need v ≤ need u) {m : Nat}
    {t : (List U × R) × Nat} (below : Below need (fun _ => True) m t.1.1) :
    Below need (fun _ => True) m (step need kids next giving use t).1.1 :=
  below_keeps (S := fun _ => True) (kids := kids t.1.2) (fun _ _ _ _ => trivial)
    (fun u v _ mk => down t.1.2 u v mk) below t.2

/-- With `down`, every unit of the way after a step needs at most the level the step was taken at.
`below_after` at the kids of the rule in force. -/
theorem below_level (down : ∀ g u v, v ∈ kids g u → need v ≤ need u) (t : (List U × R) × Nat) :
    Below need (fun _ => True) t.2 (step need kids next giving use t).1.1 :=
  below_after (S := fun _ => True) (kids := kids t.1.2) (fun _ _ _ _ => trivial)
    (fun u v _ mk => down t.1.2 u v mk) t.1.1 t.2

/-- Where under a rule that does not favour every unit has kids (`some`), the rule in force does not
favour and some unit's need is met: the way after the step has a unit. By `mem_after_iff`. -/
theorem mem_after (some : ∀ g, ¬ favours g → ∀ u, kids g u ≠ []) {t : (List U × R) × Nat}
    (notfav : ¬ favours t.1.2) (goes : Goes need t) :
    ∃ v, v ∈ (step need kids next giving use t).1.1 :=
  match goes with
  | ⟨u, mu, le⟩ => match mem_of_ne_nil (some t.1.2 notfav u) with
    | ⟨c, mc⟩ =>
      ⟨c, (mem_after_iff (need := need) (kids := kids t.1.2)).mpr ⟨u, mu, le, mc⟩⟩

/-- At a level above nothing and below what the way takes and `y` of it, with giving short of what
the way takes below `y` of it (`short`) and nothing given from nothing (`nothing`), the step leaves
less than the level. `step_lowers` under what the way takes; where it leaves nothing, that is less
than a level above nothing. -/
theorem level_lowers (nothing : RegimeMargin.FromNothing giving) {y : Nat → Nat}
    {t : (List U × R) × Nat}
    (short : RegimeMargin.Short giving (taken use t.1.1) (y (taken use t.1.1)))
    (pos : 0 < t.2)
    (under : t.2 < taken use t.1.1 + y (taken use t.1.1)) :
    (step need kids next giving use t).2 < t.2 :=
  (step_lowers short nothing (Nat.le_refl _) under).elim
    (fun zero => Nat.lt_of_le_of_lt (Nat.le_of_eq zero) pos) id

/-- At a level at most `hi` and at or above what the way takes and `y` of it, with giving at least
what the way takes, `T`, at every level `z` left with `y T ≤ z` and `z + T ≤ hi` (`meets`) and the
step under what the way takes keeping levels within `hi` (`keeps`), the step leaves no less than
the level. `RegimeMargin.holds` at its first step. -/
theorem level_held {y : Nat → Nat} {hi : Nat} {t : (List U × R) × Nat}
    (meets : RegimeMargin.Meets giving (taken use t.1.1) (y (taken use t.1.1)) hi)
    (keeps : RegimeMargin.Keeps giving (taken use t.1.1) hi)
    (enough : taken use t.1.1 + y (taken use t.1.1) ≤ t.2)
    (high : t.2 ≤ hi) : t.2 ≤ (step need kids next giving use t).2 :=
  (RegimeMargin.holds meets keeps enough high 1).1

end Step

/-! ## 3. The level stays within the cap -/

section Or

variable {need use : U → Nat} {kids : R → U → List U} {next : List U → R → R}
  {giving y : Nat → Nat} {hi : Nat} {favours : R → Prop} {s : (List U × R) × Nat}

/-- **The level stays within the cap.** From a start at most `hi` (`high`), where the step under
what the way takes keeps every level up to `hi` within `hi` at every way the course reaches with
some need met there and at every step before (`keepsAlong`): every level the course reaches with
some need met at every step before it is at most `hi`. The rule is carried alongside the level. -/
theorem within_along
    (keepsAlong : ∀ k, (∀ j, j ≤ k → Goes need (course need kids next giving use s j)) →
      RegimeMargin.Keeps giving
        (taken use (course need kids next giving use s k).1.1) hi)
    (high : s.2 ≤ hi) :
    ∀ k, (∀ j, j < k → Goes need (course need kids next giving use s j)) →
      (course need kids next giving use s k).2 ≤ hi
  | 0, _ => high
  | k + 1, before =>
    keepsAlong k (fun j le => before j (Nat.lt_succ_of_le le))
      (course need kids next giving use s k).2
      (within_along keepsAlong high k fun j lt => before j (Nat.lt_succ_of_lt lt))

/-! ## 4. One of two outcomes -/

/-- The two outcomes along a course `c`: a step with the test (`Tested`), some need met at every
step before it; or a step with no need met, some need met at every step before it. -/
def Outcomes (need use : U → Nat) (y : Nat → Nat) (favours : R → Prop) (next : List U → R → R)
    (c : Nat → (List U × R) × Nat) : Prop :=
  (∃ k, (∀ j, j < k → Goes need (c j)) ∧ Tested need use y favours next (c k)) ∨
    ∃ n, (∀ j, j < n → Goes need (c j)) ∧ ¬ Goes need (c n)

/-- The claim at a bound `m` on the needs of the way, a room `room` and a bound `f` on the level:
from every step `k` of the course `c` with some need met at every step before it, at which every
unit of the way needs at most `m`, `hi + 1` is at most what the way takes and `room`, and the level
is at most `f`, one of the two outcomes holds along `c`. -/
def OrFrom (need use : U → Nat) (y : Nat → Nat) (favours : R → Prop) (next : List U → R → R)
    (hi : Nat) (c : Nat → (List U × R) × Nat) (m room f : Nat) : Prop :=
  ∀ k, (∀ j, j < k → Goes need (c j)) → Below need (fun _ => True) m (c k).1.1 →
    hi + 1 ≤ taken use (c k).1.1 + room → (c k).2 ≤ f →
    Outcomes need use y favours next c

/-- Some need met at every step before `k` and at `k` is some need met at every step before
`k + 1`. -/
theorem goes_upto {k : Nat}
    (before : ∀ j, j < k → Goes need (course need kids next giving use s j))
    (goes : Goes need (course need kids next giving use s k)) :
    ∀ j, j ≤ k → Goes need (course need kids next giving use s j) :=
  fun j le => (Nat.lt_or_eq_of_le le).elim (before j) fun e =>
    Eq.subst (motive := fun i => Goes need (course need kids next giving use s i)) e.symm goes

/-- **The head of a step.** With kids needing no more than their parent under every rule (`down`),
every unit the course reaches needing something (`needs`), nothing given from nothing (`nothing`),
and the claim `OrFrom` at every bound below `m` (`ihM`): at a step `k` with some need met at every
step before it, at which every unit of the way needs at most `m`, one of the two outcomes holds
along the course, or some need is met at `k`, every need is met there, and what the way takes is at
most the level. Where no need is met, that is the second outcome at `k`. Where the level is below
`m`, every unit of the next way needs at most the level (`below_level`): `ihM`. Else every need is
met; where the way takes more than the level the step leaves nothing (`step_zero`),
which meets no need: the second outcome at `k + 1`. -/
theorem outcome_or_met (down : ∀ g u v, v ∈ kids g u → need v ≤ need u)
    (needs : ∀ k u, u ∈ (course need kids next giving use s k).1.1 → 0 < need u)
    (nothing : RegimeMargin.FromNothing giving) {m : Nat}
    (ihM : ∀ m', m' < m → ∀ room f,
      OrFrom need use y favours next hi (course need kids next giving use s) m' room f)
    {k : Nat} (before : ∀ j, j < k → Goes need (course need kids next giving use s j))
    (below : Below need (fun _ => True) m
      (course need kids next giving use s k).1.1) :
    Outcomes need use y favours next (course need kids next giving use s) ∨
      (Goes need (course need kids next giving use s k) ∧
        (∀ u, u ∈ (course need kids next giving use s k).1.1 →
          need u ≤ (course need kids next giving use s k).2) ∧
        taken use (course need kids next giving use s k).1.1 ≤
          (course need kids next giving use s k).2) :=
  (Decidable.em (Goes need (course need kids next giving use s k))).elim
    (fun goes =>
      have before' : ∀ j, j < k + 1 → Goes need (course need kids next giving use s j) :=
        fun j lt => goes_upto before goes j (Nat.le_of_lt_succ lt)
      (Nat.lt_or_ge (course need kids next giving use s k).2 m).elim
        (fun lt => Or.inl (ihM _ lt (hi + 1) (course need kids next giving use s (k + 1)).2
          (k + 1) before' (below_level down (course need kids next giving use s k))
          (Nat.le_add_left _ _) (Nat.le_refl _)))
        (fun ge =>
          (Nat.lt_or_ge (course need kids next giving use s k).2
              (taken use (course need kids next giving use s k).1.1)).elim
            (fun lt => Or.inl (Or.inr ⟨k + 1, before', fun ⟨u, mu, le⟩ =>
              Nat.not_le_of_gt (needs (k + 1) u mu) (Nat.le_trans le
                (Nat.le_of_eq (step_zero nothing (Nat.le_of_lt lt))))⟩))
            (fun within => Or.inr
              ⟨goes, fun u mu => Nat.le_trans (below u mu trivial) ge, within⟩)))
    (fun stop => Or.inl (Or.inr ⟨k, before, stop⟩))

/-- **The step of the claim at a room `room + 1`, by recursion on the bound `f` on the level.**
Premises: those of `tested_or_ends`, the claim `OrFrom` at every bound on the needs below `m`
(`ihM`), and the claim at `m` and `room` for every `f` (`ihC`). At a step `k`, after the head
(`outcome_or_met`), some need is met and every need is met. Where the rule in force favours, the
next way takes at least one more (`taken_rises`): `ihC` at `k + 1`. Where it does not favour and the
level is below what the way takes and `y` of it, the step leaves less (`level_lowers`, the level
being above nothing since a need is met), the next way takes the same (`taken_kept`): the recursion
at `f` less one and `k + 1`. Where it does not favour and the configuration holds: the test at `k`
if the rule set next does not favour. If it favours and no need is met at `k + 1`, that is the
second outcome at `k + 1`. If it favours and some need is met at `k + 1`: the way there has a unit
and takes the same, the level has not fallen (`level_held`, the level at `k` being at most `hi` by
`within_along`) and meets every need there (`below_level`), so the way at `k + 2` takes at least one
more: `ihC` at `k + 2`. The bound `m` is kept by `below_kept`. -/
theorem or_from_level [DecidablePred favours]
    (grows : ∀ g, favours g → ∀ u, use u < taken use (kids g u))
    (even : ∀ g, ¬ favours g → ∀ u, taken use (kids g u) = use u)
    (down : ∀ g u v, v ∈ kids g u → need v ≤ need u)
    (needs : ∀ k u, u ∈ (course need kids next giving use s k).1.1 → 0 < need u)
    (nothing : RegimeMargin.FromNothing giving) (high : s.2 ≤ hi)
    (keepsAlong : ∀ k, (∀ j, j ≤ k → Goes need (course need kids next giving use s j)) →
      RegimeMargin.Keeps giving
        (taken use (course need kids next giving use s k).1.1) hi)
    (regimeAlong : ∀ k, (∀ j, j ≤ k → Goes need (course need kids next giving use s j)) →
      ¬ favours (course need kids next giving use s k).1.2 →
      RegimeMargin.Short giving
          (taken use (course need kids next giving use s k).1.1)
          (y (taken use (course need kids next giving use s k).1.1)) ∧
        RegimeMargin.Meets giving
          (taken use (course need kids next giving use s k).1.1)
          (y (taken use (course need kids next giving use s k).1.1)) hi)
    {m room : Nat}
    (ihM : ∀ m', m' < m → ∀ room f,
      OrFrom need use y favours next hi (course need kids next giving use s) m' room f)
    (ihC : ∀ f, OrFrom need use y favours next hi (course need kids next giving use s) m room f) :
    ∀ f, OrFrom need use y favours next hi (course need kids next giving use s) m (room + 1) f
  | f, k, before, below, fuel, bound =>
    (outcome_or_met down needs nothing ihM before below).elim id fun ⟨goes, met, _⟩ =>
      match goes with
      | ⟨u₀, mu₀, le₀⟩ =>
        have upto : ∀ j, j ≤ k → Goes need (course need kids next giving use s j) :=
          goes_upto before goes
        have before' : ∀ j, j < k + 1 → Goes need (course need kids next giving use s j) :=
          fun j lt => upto j (Nat.le_of_lt_succ lt)
        have below' : Below need (fun _ => True) m
            (course need kids next giving use s (k + 1)).1.1 := below_kept down below
        (Decidable.em (favours (course need kids next giving use s k).1.2)).elim
          (fun fav => ihC (course need kids next giving use s (k + 1)).2 (k + 1) before' below'
            (Nat.le_trans fuel (Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm _ room 1))
              (Nat.add_le_add_right (taken_rises grows fav mu₀ met) room)))
            (Nat.le_refl _))
          (fun notfav =>
            have kept : taken use (course need kids next giving use s (k + 1)).1.1 =
                taken use (course need kids next giving use s k).1.1 :=
              taken_kept even notfav met
            (Nat.lt_or_ge (course need kids next giving use s k).2
                (taken use (course need kids next giving use s k).1.1 +
                  y (taken use (course need kids next giving use s k).1.1))).elim
              (fun under =>
                have lower : (course need kids next giving use s (k + 1)).2 <
                    (course need kids next giving use s k).2 :=
                  level_lowers nothing (regimeAlong k upto notfav).1
                    (Nat.lt_of_lt_of_le (needs k u₀ mu₀) le₀) under
                match f, bound with
                | 0, bound => absurd (Nat.lt_of_lt_of_le lower bound) (Nat.not_lt_zero _)
                | f + 1, bound =>
                  or_from_level grows even down needs nothing high keepsAlong regimeAlong
                    ihM ihC f (k + 1) before' below'
                    (Eq.subst (motive := fun T => hi + 1 ≤ T + (room + 1)) kept.symm fuel)
                    (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lower bound)))
              (fun enough =>
                (Decidable.em (favours (next (course need kids next giving use s k).1.1
                    (course need kids next giving use s k).1.2))).elim
                  (fun fav' =>
                    have held : (course need kids next giving use s k).2 ≤
                        (course need kids next giving use s (k + 1)).2 :=
                      level_held (regimeAlong k upto notfav).2 (keepsAlong k upto) enough
                        (within_along keepsAlong high k before)
                    have met' : ∀ u, u ∈ (course need kids next giving use s (k + 1)).1.1 →
                        need u ≤ (course need kids next giving use s (k + 1)).2 :=
                      fun u mu => Nat.le_trans
                        (below_level down (course need kids next giving use s k) u mu trivial)
                        held
                    (Decidable.em (Goes need (course need kids next giving use s (k + 1)))).elim
                      (fun goes' => match goes' with
                        | ⟨_, mv, _⟩ =>
                          have before'' : ∀ j, j < k + 1 + 1 →
                              Goes need (course need kids next giving use s j) :=
                            fun j lt => goes_upto before' goes' j (Nat.le_of_lt_succ lt)
                          ihC (course need kids next giving use s (k + 1 + 1)).2 (k + 1 + 1)
                            before'' (below_kept down below')
                            (Nat.le_trans fuel
                              (Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm _ room 1))
                                (Nat.add_le_add_right
                                  (Nat.le_trans (Nat.le_of_eq (congrArg (· + 1) kept.symm))
                                    (taken_rises grows fav' mv met')) room)))
                            (Nat.le_refl _))
                      (fun stop => Or.inr ⟨k + 1, before', stop⟩))
                  (fun notfav' => Or.inl ⟨k, before,
                    And.intro
                      (And.intro (fun e => nomatch (Eq.subst (motive := fun l => u₀ ∈ l) e mu₀))
                        (And.intro met enough))
                      (And.intro notfav notfav')⟩)))

/-- **The claim at a bound `m` on the needs, by recursion on the room.** Premises: those of
`tested_or_ends` and the claim `OrFrom` at every bound below `m` (`ihM`). With no room, `hi + 1` is
at most what the way takes; after the head (`outcome_or_met`) what the way takes is at most the
level, which is at most `hi` (`within_along`): one of the outcomes holds. With room `room + 1`:
`or_from_level`. -/
theorem or_from_room [DecidablePred favours]
    (grows : ∀ g, favours g → ∀ u, use u < taken use (kids g u))
    (even : ∀ g, ¬ favours g → ∀ u, taken use (kids g u) = use u)
    (down : ∀ g u v, v ∈ kids g u → need v ≤ need u)
    (needs : ∀ k u, u ∈ (course need kids next giving use s k).1.1 → 0 < need u)
    (nothing : RegimeMargin.FromNothing giving) (high : s.2 ≤ hi)
    (keepsAlong : ∀ k, (∀ j, j ≤ k → Goes need (course need kids next giving use s j)) →
      RegimeMargin.Keeps giving
        (taken use (course need kids next giving use s k).1.1) hi)
    (regimeAlong : ∀ k, (∀ j, j ≤ k → Goes need (course need kids next giving use s j)) →
      ¬ favours (course need kids next giving use s k).1.2 →
      RegimeMargin.Short giving
          (taken use (course need kids next giving use s k).1.1)
          (y (taken use (course need kids next giving use s k).1.1)) ∧
        RegimeMargin.Meets giving
          (taken use (course need kids next giving use s k).1.1)
          (y (taken use (course need kids next giving use s k).1.1)) hi)
    {m : Nat}
    (ihM : ∀ m', m' < m → ∀ room f,
      OrFrom need use y favours next hi (course need kids next giving use s) m' room f) :
    ∀ room f, OrFrom need use y favours next hi (course need kids next giving use s) m room f
  | 0 => fun _ k before below fuel _ =>
    (outcome_or_met down needs nothing ihM before below).elim id fun ⟨_, _, within⟩ =>
      absurd (Nat.le_trans fuel (Nat.le_trans within (within_along keepsAlong high k before)))
        (Nat.not_succ_le_self hi)
  | room + 1 =>
    or_from_level grows even down needs nothing high keepsAlong regimeAlong ihM
      (or_from_room grows even down needs nothing high keepsAlong regimeAlong ihM room)

/-- **The claim at every bound on the needs, by strong induction** (`strong_below`,
`or_from_room`). Premises: those of `tested_or_ends`. -/
theorem or_all [DecidablePred favours]
    (grows : ∀ g, favours g → ∀ u, use u < taken use (kids g u))
    (even : ∀ g, ¬ favours g → ∀ u, taken use (kids g u) = use u)
    (down : ∀ g u v, v ∈ kids g u → need v ≤ need u)
    (needs : ∀ k u, u ∈ (course need kids next giving use s k).1.1 → 0 < need u)
    (nothing : RegimeMargin.FromNothing giving) (high : s.2 ≤ hi)
    (keepsAlong : ∀ k, (∀ j, j ≤ k → Goes need (course need kids next giving use s j)) →
      RegimeMargin.Keeps giving
        (taken use (course need kids next giving use s k).1.1) hi)
    (regimeAlong : ∀ k, (∀ j, j ≤ k → Goes need (course need kids next giving use s j)) →
      ¬ favours (course need kids next giving use s k).1.2 →
      RegimeMargin.Short giving
          (taken use (course need kids next giving use s k).1.1)
          (y (taken use (course need kids next giving use s k).1.1)) ∧
        RegimeMargin.Meets giving
          (taken use (course need kids next giving use s k).1.1)
          (y (taken use (course need kids next giving use s k).1.1)) hi)
    (m : Nat) :
    ∀ room f, OrFrom need use y favours next hi (course need kids next giving use s) m room f :=
  strong_below
    (P := fun m => ∀ room f,
      OrFrom need use y favours next hi (course need kids next giving use s) m room f)
    (fun _ ih =>
      or_from_room grows even down needs nothing high keepsAlong regimeAlong ih)
    (m + 1) m (Nat.lt_succ_self m)

/-- **A step with the test, or a step with no need met.** For units `U` and rules `R`, any `next`,
and `favours` decided at every rule. Premises:

* `grows`: under a rule that favours, each unit's kids together take more than it;
* `even`: under a rule that does not favour, each unit's kids together take what it takes;
* `down`: under every rule, kids need no more than their parent;
* `needs`: every unit of every way the course reaches needs something (it follows from
  `∀ u, 0 < need u`);
* `nothing`: nothing is given from nothing; `high`: the start level is at most `hi`;
* `keepsAlong`: at every step `k` with some need met there and at every step before, the step under
  what the way at `k` takes keeps every level up to `hi` within `hi`;
* `regimeAlong`: at every such step at which the rule in force does not favour, with `T` what the
  way there takes, giving is short of `T` at every level below `y T`, and is at least `T` at every
  level `z` left with `y T ≤ z` and `z + T ≤ hi`.

Then the course from `s` comes to a step at which the test holds (`Tested`: the way and level hold,
the rule in force does not favour and the rule set next does not), some need met at every step
before it; or to a step at which no need is met, some need met at every step before it. The second
is the first step with no need met; the first is a step with the test, not stated to be the first.
Under these premises the "or" is inclusive: `BothOutcomes.both` is a course that meets them, has the
test at its start and comes to a step with no need met. That under a rule that does not favour every
unit has kids (`some`) is not asked: a way left empty after a holding step has no need met, which is
the second outcome. Where the rule set next is read from a share of the way and `some`, `lowers`,
`monotone` and `upper` hold as well, `tested_lasts` makes the two outcomes shut each other out
(`unending_iff_tested`, `ends_iff_unmet`); and `first_tested_or_ends` takes the least step with the
test. No bound on either step is stated. By `or_all` at the total of the needs of the start's way,
the room `hi + 1` and the start level. -/
theorem tested_or_ends [DecidablePred favours]
    (grows : ∀ g, favours g → ∀ u, use u < taken use (kids g u))
    (even : ∀ g, ¬ favours g → ∀ u, taken use (kids g u) = use u)
    (down : ∀ g u v, v ∈ kids g u → need v ≤ need u)
    (needs : ∀ k u, u ∈ (course need kids next giving use s k).1.1 → 0 < need u)
    (nothing : RegimeMargin.FromNothing giving) (high : s.2 ≤ hi)
    (keepsAlong : ∀ k, (∀ j, j ≤ k → Goes need (course need kids next giving use s j)) →
      RegimeMargin.Keeps giving
        (taken use (course need kids next giving use s k).1.1) hi)
    (regimeAlong : ∀ k, (∀ j, j ≤ k → Goes need (course need kids next giving use s j)) →
      ¬ favours (course need kids next giving use s k).1.2 →
      RegimeMargin.Short giving
          (taken use (course need kids next giving use s k).1.1)
          (y (taken use (course need kids next giving use s k).1.1)) ∧
        RegimeMargin.Meets giving
          (taken use (course need kids next giving use s k).1.1)
          (y (taken use (course need kids next giving use s k).1.1)) hi) :
    (∃ k, (∀ j, j < k → Goes need (course need kids next giving use s j)) ∧
        Tested need use y favours next (course need kids next giving use s k)) ∨
      (∃ n, (∀ j, j < n → Goes need (course need kids next giving use s j)) ∧
        ¬ Goes need (course need kids next giving use s n)) :=
  or_all grows even down needs nothing high keepsAlong regimeAlong (total s.1.1 need)
    (hi + 1) s.2 0 (fun _ lt => absurd lt (Nat.not_lt_zero _))
    (fun _ mu _ => le_total_of_mem mu) (Nat.le_add_left _ _) (Nat.le_refl _)

/-! ## 5. The least step with the test -/

/-- At a way and a level, the configuration holds (`Holds`) or it does not: the way is
empty or not, every need is met or some is not (`met_or_unmet`), and the level is at
or above what the way takes and `y` of it, or below. -/
theorem holds_or_not (need use : U → Nat) (y : Nat → Nat) : ∀ (w : List U) (x : Nat),
    Holds need use y (w, x) ∨ ¬ Holds need use y (w, x)
  | [], _ => .inr fun holds => holds.1 rfl
  | u :: w, x => (met_or_unmet need x (u :: w)).elim
      (fun met =>
        (Nat.lt_or_ge x
            (taken use (u :: w) + y (taken use (u :: w)))).elim
          (fun lt => .inr fun holds => Nat.not_le_of_gt lt holds.2.2)
          (fun ge => .inl ⟨List.cons_ne_nil u w, met, ge⟩))
      (fun ⟨v, mv, lt⟩ => .inr fun holds => Nat.not_le_of_gt lt (holds.2.1 v mv))

/-- **The test or not the test.** With `favours` decided at every rule, at a configuration the test
(`Tested`) holds or it does not: `holds_or_not`, then the rule in force and the rule set next. -/
theorem tested_or_not [DecidablePred favours] (t : (List U × R) × Nat) :
    Tested need use y favours next t ∨ ¬ Tested need use y favours next t :=
  (holds_or_not need use y t.1.1 t.2).elim
    (fun holds => (Decidable.em (favours t.1.2)).elim
      (fun fav => .inr fun tested => tested.2.1 fav)
      fun notfav => (Decidable.em (favours (next t.1.1 t.1.2))).elim
        (fun fav' => .inr fun tested => tested.2.2 fav')
        fun notfav' => .inl ⟨holds, notfav, notfav'⟩)
    (fun not => .inr fun tested => not tested.1)

/-- **The least step with the test.** With `favours` decided at every rule and no other premise:
if the course from `s` has a step with the test (`Tested`), some need met at every step before it,
then it has such a step before which no step has the test. By a bounded search
(`first_of_decided`, with `tested_or_not`). -/
theorem first_tested [DecidablePred favours] :
    (∃ k, (∀ j, j < k → Goes need (course need kids next giving use s j)) ∧
        Tested need use y favours next (course need kids next giving use s k)) →
      ∃ k, (∀ j, j < k → Goes need (course need kids next giving use s j)) ∧
        Tested need use y favours next (course need kids next giving use s k) ∧
        ∀ j, j < k → ¬ Tested need use y favours next (course need kids next giving use s j) :=
  fun ⟨k, before, tested⟩ =>
    match first_of_decided
        (P := fun t => ¬ Tested need use y favours next (course need kids next giving use s t))
        (Q := fun t => Tested need use y favours next (course need kids next giving use s t))
        (fun t => (tested_or_not (course need kids next giving use s t)).elim
          (fun yes => .inr yes) (fun no => .inl no)) k with
    | .inl never => absurd tested (never k (Nat.le_refl k))
    | .inr ⟨m, le, tested, earlier⟩ =>
      ⟨m, fun j lt => before j (Nat.lt_of_lt_of_le lt le), tested, earlier⟩

/-- **A first step with the test, or a first step with no need met.** Under the premises of
`tested_or_ends` (`grows`, `even`, `down`, `needs`, `nothing`, `high`, `keepsAlong`, `regimeAlong`,
with `favours` decided at every rule and any `next`): the course from `s` comes to a step with the
test, some need met at every step before it and the test at no step before it; or to a step with no
need met, some need met at every step before it. `tested_or_ends`, with `first_tested` on its first
outcome. The "or" is inclusive, as there. -/
theorem first_tested_or_ends [DecidablePred favours]
    (grows : ∀ g, favours g → ∀ u, use u < taken use (kids g u))
    (even : ∀ g, ¬ favours g → ∀ u, taken use (kids g u) = use u)
    (down : ∀ g u v, v ∈ kids g u → need v ≤ need u)
    (needs : ∀ k u, u ∈ (course need kids next giving use s k).1.1 → 0 < need u)
    (nothing : RegimeMargin.FromNothing giving) (high : s.2 ≤ hi)
    (keepsAlong : ∀ k, (∀ j, j ≤ k → Goes need (course need kids next giving use s j)) →
      RegimeMargin.Keeps giving
        (taken use (course need kids next giving use s k).1.1) hi)
    (regimeAlong : ∀ k, (∀ j, j ≤ k → Goes need (course need kids next giving use s j)) →
      ¬ favours (course need kids next giving use s k).1.2 →
      RegimeMargin.Short giving
          (taken use (course need kids next giving use s k).1.1)
          (y (taken use (course need kids next giving use s k).1.1)) ∧
        RegimeMargin.Meets giving
          (taken use (course need kids next giving use s k).1.1)
          (y (taken use (course need kids next giving use s k).1.1)) hi) :
    (∃ k, (∀ j, j < k → Goes need (course need kids next giving use s j)) ∧
        Tested need use y favours next (course need kids next giving use s k) ∧
        ∀ j, j < k →
          ¬ Tested need use y favours next (course need kids next giving use s j)) ∨
      (∃ n, (∀ j, j < n → Goes need (course need kids next giving use s j)) ∧
        ¬ Goes need (course need kids next giving use s n)) :=
  (tested_or_ends grows even down needs nothing high keepsAlong regimeAlong).elim
    (fun tested => .inl (first_tested tested)) .inr

end Or

/-! ## 6. The rule read from a share of the way: the first outcome lasts -/

section Share

variable {A : Type} {need use : U → Nat} {kids : R → U → List U} {giving y : Nat → Nat}
  {hi : Nat} {favours : R → Prop} {P : Ideals.Preorder A} {M : Ideals.Preorder R}
  {share : List U → A} {h : A → R → R} {s : (List U × R) × Nat}

/-- The order of ways by their shares: a way is below another where `P` puts its share below the
other's. -/
def byShare (share : List U → A) (P : Ideals.Preorder A) : Ideals.Preorder (List U) where
  le w w' := P.le (share w) (share w')
  refl w := P.refl (share w)
  trans ab bc := P.trans ab bc

/-- **A step at which every need is met is a turn.** With the rule set next read from the share of
the way (`next := fun w g => h (share w) g`): where every unit's need is met, the way and rule
after the step are `Pace.turn` at a reading step, of the selection "all the kids under the rule in
force" and that reading. By `after_of_met`. -/
theorem step_turn {t : (List U × R) × Nat} (met : ∀ u, u ∈ t.1.1 → need u ≤ t.2) :
    (step need kids (fun w g => h (share w) g) giving use t).1 =
      Pace.turn (fun w g => allKids (kids g) w) (fun w g => h (share w) g) true t.1 :=
  congrArg (fun l => (l, h (share t.1.1) t.1.2))
    (after_of_met (kids := kids t.1.2) met)

/-- A configuration held from a level `x₀` and a take `T₀` within `hi`: its way has a unit, every
unit of it needs at most `x₀`, it takes `T₀`, and its level is at least `x₀` and at most `hi`. -/
def HeldAt (need use : U → Nat) (hi x₀ T₀ : Nat) (t : (List U × R) × Nat) : Prop :=
  (∃ v, v ∈ t.1.1) ∧ Below need (fun _ => True) x₀ t.1.1 ∧
    taken use t.1.1 = T₀ ∧ x₀ ≤ t.2 ∧ t.2 ≤ hi

/-- **One step keeps a held configuration, under a rule that does not favour.** With `even`, `some`
and `down`, giving at least `T₀` at every level `z` left with `y T₀ ≤ z` and `z + T₀ ≤ hi`
(`meets`), the step under `T₀` keeping levels within `hi` (`keeps`), and `T₀ + y T₀ ≤ x₀`
(`enough`): where the rule in force does not favour and the configuration is `HeldAt` `x₀` and
`T₀`, so is the configuration after the step. Any `next`. By `mem_after`, `below_kept`,
`taken_kept` and `level_held`. -/
theorem held_step {next : List U → R → R} {x₀ T₀ : Nat}
    (even : ∀ g, ¬ favours g → ∀ u, taken use (kids g u) = use u)
    (some : ∀ g, ¬ favours g → ∀ u, kids g u ≠ [])
    (down : ∀ g u v, v ∈ kids g u → need v ≤ need u)
    (meets : RegimeMargin.Meets giving T₀ (y T₀) hi) (keeps : RegimeMargin.Keeps giving T₀ hi)
    (enough : T₀ + y T₀ ≤ x₀) {t : (List U × R) × Nat} (notfav : ¬ favours t.1.2)
    (held : HeldAt need use hi x₀ T₀ t) :
    HeldAt need use hi x₀ T₀ (step need kids next giving use t) :=
  match held with
  | ⟨⟨v, mv⟩, below, take, low, high⟩ =>
    have met : ∀ u, u ∈ t.1.1 → need u ≤ t.2 := fun u mu =>
      Nat.le_trans (below u mu trivial) low
    have keeps' : RegimeMargin.Keeps giving (taken use t.1.1) hi :=
      Eq.subst (motive := fun T => RegimeMargin.Keeps giving T hi) take.symm keeps
    ⟨mem_after (next := next) (giving := giving) some notfav ⟨v, mv, met v mv⟩,
      below_kept down below, (taken_kept even notfav met).trans take,
      Nat.le_trans low
        (level_held
          (Eq.subst (motive := fun T => RegimeMargin.Meets giving T (y T) hi) take.symm meets)
          keeps'
          (Nat.le_trans (Eq.subst (motive := fun T => T + y T ≤ x₀) take.symm enough) low)
          high),
      keeps' t.2 high⟩

/-- **From a configuration with the test, every later configuration is held and its rule does not
favour.** With `even`, `down`, what `tested_lasts` adds (`some`: under a rule that does not favour
every unit has kids; `lowers`: under a rule that does not favour, the share of all the kids of a way
is not above the way's; `monotone`: the rule read is a monotone function of the share alone;
`upper`: a rule above a favouring rule favours), and at the configuration `t` itself: giving at
least what its way takes, `T`, at every level `z` left with `y T ≤ z` and `z + T ≤ hi` (`meets`),
the step under `T` keeping levels within `hi` (`keeps`), the level at most `hi` (`high`) and the
test (`tested`). Then at every step `i + 1` after `t` the configuration is `HeldAt` the level and
the take of `t`, and it is locked at the reversed order: its rule does not favour and the rule read
there is not above it.

The stock's part is `held_step`. The rule's part: one step after the test the reversed lock holds
(the rule set at `t` does not favour, and by `lowers` and `monotone` the rule read after the step
is not above it), and each later step keeps it by **`RuleCapture.turn_locked`** at the orders
reversed (`RuleCapture.reverse`), the step being a turn (`step_turn`); its three premises are
`lowers`, `monotone` reversed (`RuleCapture.ReadsShare.reverse`) along `share`, and `upper` read
backward. -/
theorem lasts_from
    (even : ∀ g, ¬ favours g → ∀ u, taken use (kids g u) = use u)
    (some : ∀ g, ¬ favours g → ∀ u, kids g u ≠ [])
    (down : ∀ g u v, v ∈ kids g u → need v ≤ need u)
    (lowers : ∀ w g, ¬ favours g → P.le (share (allKids (kids g) w)) (share w))
    (monotone : RuleCapture.ReadsShare P M h)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {t : (List U × R) × Nat}
    (meets : RegimeMargin.Meets giving (taken use t.1.1)
      (y (taken use t.1.1)) hi)
    (keeps : RegimeMargin.Keeps giving (taken use t.1.1) hi) (high : t.2 ≤ hi)
    (tested : Tested need use y favours (fun w g => h (share w) g) t) :
    ∀ i, HeldAt need use hi t.2 (taken use t.1.1)
          (Law.orbit (step need kids (fun w g => h (share w) g) giving use) t (i + 1)) ∧
        RuleCapture.Locked (RuleCapture.reverse M) (fun g => ¬ favours g)
          (fun w g => h (share w) g)
          (Law.orbit (step need kids (fun w g => h (share w) g) giving use) t (i + 1)).1
  | 0 =>
    ⟨held_step even some down meets keeps tested.1.2.2 tested.2.1
        ⟨mem_of_ne_nil tested.1.1, fun u mu _ => tested.1.2.1 u mu, rfl,
          Nat.le_refl _, high⟩,
      tested.2.2,
      monotone _ _ _ _ (Eq.subst (motive := fun l => P.le (share l) (share t.1.1))
        (after_of_met (kids := kids t.1.2) tested.1.2.1).symm
        (lowers t.1.1 t.1.2 tested.2.1))⟩
  | i + 1 =>
    match lasts_from even some down lowers monotone upper meets keeps high tested i with
    | ⟨held, locked⟩ =>
      ⟨held_step even some down meets keeps tested.1.2.2 locked.1 held,
        Eq.subst
          (motive := RuleCapture.Locked (RuleCapture.reverse M) (fun g => ¬ favours g)
            (fun w g => h (share w) g))
          (step_turn fun u mu => Nat.le_trans (held.2.1 u mu trivial) held.2.2.2.1).symm
          (RuleCapture.turn_locked (P := RuleCapture.reverse (byShare share P))
            (f := fun w g => allKids (kids g) w) lowers
            (fun w w' g g' le =>
              RuleCapture.ReadsShare.reverse monotone (share w) (share w') g g' le)
            (fun le notfav fav => notfav (upper le fav)) true _ locked).1⟩

/-- **The first outcome lasts.** With the rule set next read from a share of the way
(`next := fun w g => h (share w) g`, for a share `share : List U → A`, orders `P` on shares and `M`
on rules, and a reading `h`). Premises:

* `even`: under a rule that does not favour, each unit's kids together take what it takes;
* `some`: under a rule that does not favour, every unit has kids;
* `down`: under every rule, kids need no more than their parent;
* `high`: the start level is at most `hi`;
* `keepsAlong`: at every step `k` with some need met there and at every step before, the step under
  what the way at `k` takes keeps every level up to `hi` within `hi`;
* `regimeAlong`: at every such step at which the rule in force does not favour, with `T` what the
  way there takes, giving is short of `T` at every level below `y T`, and is at least `T` at every
  level `z` left with `y T ≤ z` and `z + T ≤ hi` (only the second is used here, and only at the
  step with the test);
* `lowers`: under a rule that does not favour, the share of all the kids of a way is not above the
  way's share;
* `monotone`: the rule read is a monotone function of the share alone (`RuleCapture.ReadsShare`);
* `upper`: a rule above a favouring rule favours.

Then: if the course from `s` comes to a step with the test (`Tested`), some need met at every step
before it, the net from `s` never ends. Not asked: `grows`, `needs`, `nothing`, or that `favours` is
decided. `some` is asked here and not by `tested_or_ends`: through `held_step` it gives a way that
is not empty after a holding step (that it cannot be dropped is argued, not proved here: without it
a way whose units take nothing could leave no unit under a rule that does not favour). By
`lasts_from` at the step with the test (the level there at most `hi` by `within_along`): every later
way has a unit whose need the level meets. -/
theorem tested_lasts
    (even : ∀ g, ¬ favours g → ∀ u, taken use (kids g u) = use u)
    (some : ∀ g, ¬ favours g → ∀ u, kids g u ≠ [])
    (down : ∀ g u v, v ∈ kids g u → need v ≤ need u) (high : s.2 ≤ hi)
    (keepsAlong : ∀ k,
      (∀ j, j ≤ k → Goes need (course need kids (fun w g => h (share w) g) giving use s j)) →
      RegimeMargin.Keeps giving
        (taken use
          (course need kids (fun w g => h (share w) g) giving use s k).1.1) hi)
    (regimeAlong : ∀ k,
      (∀ j, j ≤ k → Goes need (course need kids (fun w g => h (share w) g) giving use s j)) →
      ¬ favours (course need kids (fun w g => h (share w) g) giving use s k).1.2 →
      RegimeMargin.Short giving
          (taken use
            (course need kids (fun w g => h (share w) g) giving use s k).1.1)
          (y (taken use
            (course need kids (fun w g => h (share w) g) giving use s k).1.1)) ∧
        RegimeMargin.Meets giving
          (taken use
            (course need kids (fun w g => h (share w) g) giving use s k).1.1)
          (y (taken use
            (course need kids (fun w g => h (share w) g) giving use s k).1.1)) hi)
    (lowers : ∀ w g, ¬ favours g → P.le (share (allKids (kids g) w)) (share w))
    (monotone : RuleCapture.ReadsShare P M h)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') :
    (∃ k,
        (∀ j, j < k →
          Goes need (course need kids (fun w g => h (share w) g) giving use s j)) ∧
        Tested need use y favours (fun w g => h (share w) g)
          (course need kids (fun w g => h (share w) g) giving use s k)) →
      «不穷» (net need kids (fun w g => h (share w) g) giving use) «一» s :=
  fun ⟨k, before, tested⟩ => Law.stepWhile_unending_iff.mpr fun n =>
    have goes : Goes need (course need kids (fun w g => h (share w) g) giving use s k) :=
      match mem_of_ne_nil tested.1.1 with
      | ⟨v, mv⟩ => ⟨v, mv, tested.1.2.1 v mv⟩
    have upto := goes_upto before goes
    (Nat.lt_or_ge n k).elim (before n) fun ge =>
      match le_dest ge with
      | ⟨0, e⟩ =>
        Eq.subst
          (motive := fun i =>
            Goes need (course need kids (fun w g => h (share w) g) giving use s i))
          e.symm goes
      | ⟨i + 1, e⟩ =>
        match (lasts_from even some down lowers monotone upper
            (regimeAlong k upto tested.2.1).2 (keepsAlong k upto)
            (within_along keepsAlong high k before) tested i).1 with
        | ⟨⟨v, mv⟩, below, _, low, _⟩ =>
          Eq.subst
            (motive := fun i =>
              Goes need (course need kids (fun w g => h (share w) g) giving use s i))
            e.symm
            (Eq.subst (motive := Goes need) (Law.orbit_add _ s k (i + 1)).symm
              ⟨v, mv, Nat.le_trans (below v mv trivial) low⟩)

/-! ## 7. The two outcomes shut each other out -/

/-- **The net never ends exactly where the course comes to a step with the test.** With `favours`
decided at every rule, the rule set next read from a share of the way, the premises of
`tested_or_ends` (`grows`, `even`, `down`, `needs`, `nothing`, `high`, `keepsAlong`, `regimeAlong`)
and those `tested_lasts` adds (`some`, `lowers`, `monotone`, `upper`): the net from `s` never ends
exactly where the course from `s` has a step with the test (`Tested`), some need met at every step
before it. Left to right by `tested_or_ends` (a net that never ends has no step with no need met);
right to left is `tested_lasts`. -/
theorem unending_iff_tested [DecidablePred favours]
    (grows : ∀ g, favours g → ∀ u, use u < taken use (kids g u))
    (even : ∀ g, ¬ favours g → ∀ u, taken use (kids g u) = use u)
    (some : ∀ g, ¬ favours g → ∀ u, kids g u ≠ [])
    (down : ∀ g u v, v ∈ kids g u → need v ≤ need u)
    (needs : ∀ k u,
      u ∈ (course need kids (fun w g => h (share w) g) giving use s k).1.1 → 0 < need u)
    (nothing : RegimeMargin.FromNothing giving) (high : s.2 ≤ hi)
    (keepsAlong : ∀ k,
      (∀ j, j ≤ k → Goes need (course need kids (fun w g => h (share w) g) giving use s j)) →
      RegimeMargin.Keeps giving
        (taken use
          (course need kids (fun w g => h (share w) g) giving use s k).1.1) hi)
    (regimeAlong : ∀ k,
      (∀ j, j ≤ k → Goes need (course need kids (fun w g => h (share w) g) giving use s j)) →
      ¬ favours (course need kids (fun w g => h (share w) g) giving use s k).1.2 →
      RegimeMargin.Short giving
          (taken use
            (course need kids (fun w g => h (share w) g) giving use s k).1.1)
          (y (taken use
            (course need kids (fun w g => h (share w) g) giving use s k).1.1)) ∧
        RegimeMargin.Meets giving
          (taken use
            (course need kids (fun w g => h (share w) g) giving use s k).1.1)
          (y (taken use
            (course need kids (fun w g => h (share w) g) giving use s k).1.1)) hi)
    (lowers : ∀ w g, ¬ favours g → P.le (share (allKids (kids g) w)) (share w))
    (monotone : RuleCapture.ReadsShare P M h)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') :
    «不穷» (net need kids (fun w g => h (share w) g) giving use) «一» s ↔
      ∃ k,
        (∀ j, j < k →
          Goes need (course need kids (fun w g => h (share w) g) giving use s j)) ∧
        Tested need use y favours (fun w g => h (share w) g)
          (course need kids (fun w g => h (share w) g) giving use s k) :=
  ⟨fun never =>
      (tested_or_ends grows even down needs nothing high keepsAlong regimeAlong).elim id
        fun ⟨n, _, stop⟩ => absurd (Law.stepWhile_unending_iff.mp never n) stop,
    tested_lasts even some down high keepsAlong regimeAlong lowers monotone upper⟩

/-- **The net ends exactly where the course comes to a step with no need met.** Under the premises
of `unending_iff_tested`: the net from `s` does not go on without end exactly where the course from
`s` has a step with no need met, some need met at every step before it. Left to right by
`tested_or_ends`, its first outcome shut out by `tested_lasts`. Right to left asks no premise: a net
that never ends has some need met at every step. With `unending_iff_tested`: under these premises
exactly one of the two outcomes of `tested_or_ends` comes. -/
theorem ends_iff_unmet [DecidablePred favours]
    (grows : ∀ g, favours g → ∀ u, use u < taken use (kids g u))
    (even : ∀ g, ¬ favours g → ∀ u, taken use (kids g u) = use u)
    (some : ∀ g, ¬ favours g → ∀ u, kids g u ≠ [])
    (down : ∀ g u v, v ∈ kids g u → need v ≤ need u)
    (needs : ∀ k u,
      u ∈ (course need kids (fun w g => h (share w) g) giving use s k).1.1 → 0 < need u)
    (nothing : RegimeMargin.FromNothing giving) (high : s.2 ≤ hi)
    (keepsAlong : ∀ k,
      (∀ j, j ≤ k → Goes need (course need kids (fun w g => h (share w) g) giving use s j)) →
      RegimeMargin.Keeps giving
        (taken use
          (course need kids (fun w g => h (share w) g) giving use s k).1.1) hi)
    (regimeAlong : ∀ k,
      (∀ j, j ≤ k → Goes need (course need kids (fun w g => h (share w) g) giving use s j)) →
      ¬ favours (course need kids (fun w g => h (share w) g) giving use s k).1.2 →
      RegimeMargin.Short giving
          (taken use
            (course need kids (fun w g => h (share w) g) giving use s k).1.1)
          (y (taken use
            (course need kids (fun w g => h (share w) g) giving use s k).1.1)) ∧
        RegimeMargin.Meets giving
          (taken use
            (course need kids (fun w g => h (share w) g) giving use s k).1.1)
          (y (taken use
            (course need kids (fun w g => h (share w) g) giving use s k).1.1)) hi)
    (lowers : ∀ w g, ¬ favours g → P.le (share (allKids (kids g) w)) (share w))
    (monotone : RuleCapture.ReadsShare P M h)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') :
    ¬ «不穷» (net need kids (fun w g => h (share w) g) giving use) «一» s ↔
      ∃ n,
        (∀ j, j < n →
          Goes need (course need kids (fun w g => h (share w) g) giving use s j)) ∧
        ¬ Goes need (course need kids (fun w g => h (share w) g) giving use s n) :=
  ⟨fun ends =>
      (tested_or_ends grows even down needs nothing high keepsAlong regimeAlong).elim
        (fun tested => absurd
          (tested_lasts even some down high keepsAlong regimeAlong lowers monotone upper tested)
          ends)
        id,
    fun ⟨n, _, stop⟩ never => stop (Law.stepWhile_unending_iff.mp never n)⟩

/-! ## 8. From a locked start -/

/-- **While every need is met, a locked start stays locked.** With the rule set next read from a
share of the way, `raises` (under a rule that favours, the share of all the kids of a way is not
below the way's share), `monotone` (the rule read is a monotone function of the share alone),
`upper` (a rule above a favouring rule favours) and the start locked (`locked`,
`RuleCapture.Locked`: its rule favours and is not above the rule read there): at every step `n`
with every unit's need met at every step before it, the way and rule are locked. No premise on the
stock. Each step is a turn (`step_turn`) and keeps the lock by **`RuleCapture.turn_locked`**, at
the selection "all the kids under the rule in force" and the order of ways by their shares
(`byShare`). -/
theorem locked_while_met
    (raises : ∀ w g, favours g → P.le (share w) (share (allKids (kids g) w)))
    (monotone : RuleCapture.ReadsShare P M h)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g')
    (locked : RuleCapture.Locked M favours (fun w g => h (share w) g) s.1) :
    ∀ n,
      (∀ j, j < n →
        ∀ u, u ∈ (course need kids (fun w g => h (share w) g) giving use s j).1.1 →
          need u ≤ (course need kids (fun w g => h (share w) g) giving use s j).2) →
      RuleCapture.Locked M favours (fun w g => h (share w) g)
        (course need kids (fun w g => h (share w) g) giving use s n).1
  | 0, _ => locked
  | n + 1, met =>
    Eq.subst (motive := RuleCapture.Locked M favours (fun w g => h (share w) g))
      (step_turn (met n (Nat.lt_succ_self n))).symm
      (RuleCapture.turn_locked (P := byShare share P)
        (f := fun w g => allKids (kids g) w) raises
        (fun w w' g g' le => monotone (share w) (share w') g g' le) upper true _
        (locked_while_met raises monotone upper locked n fun j lt =>
          met j (Nat.lt_succ_of_lt lt))).1

/-- **From a locked start the rule favours until a need has gone unmet, and one step more.** With
`raises`, `monotone`, `upper` and the start locked (`locked`), as in `locked_while_met`, and no
premise on the stock: where every unit's need is met at every step before `n`, the rule in force
favours at every step up to `n + 1`. Up to `n` by `locked_while_met`; at `n + 1` the rule is the
one read at `n`, which is not below the favouring rule in force there (`upper`). -/
theorem favours_while_met
    (raises : ∀ w g, favours g → P.le (share w) (share (allKids (kids g) w)))
    (monotone : RuleCapture.ReadsShare P M h)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g')
    (locked : RuleCapture.Locked M favours (fun w g => h (share w) g) s.1) :
    ∀ n,
      (∀ j, j < n →
        ∀ u, u ∈ (course need kids (fun w g => h (share w) g) giving use s j).1.1 →
          need u ≤ (course need kids (fun w g => h (share w) g) giving use s j).2) →
      ∀ j, j ≤ n + 1 →
        favours (course need kids (fun w g => h (share w) g) giving use s j).1.2 :=
  fun n met j le => (Nat.lt_or_eq_of_le le).elim
    (fun lt => (locked_while_met raises monotone upper locked j fun i li =>
      met i (Nat.lt_of_lt_of_le li (Nat.le_of_lt_succ lt))).1)
    (fun e =>
      Eq.subst
        (motive := fun i =>
          favours (course need kids (fun w g => h (share w) g) giving use s i).1.2)
        e.symm
        (match locked_while_met raises monotone upper locked n met with
          | ⟨fav, above⟩ => upper above fav))

/-- **From a locked start, a rule that does not favour comes at least two steps after a need went
unmet.** With `raises`, `monotone`, `upper` and the start locked, and no premise on the stock:
where the rule in force at step `k` does not favour, some step `j` with `j + 2 ≤ k` has a unit
whose need is above the level there. The step found is the first with a need unmet, by a bounded
search (`first_of_decided`, with `met_or_unmet`), though the statement does not say
that it is the first; `favours_while_met` puts it at least two steps before `k`. -/
theorem unmet_before_unfavoured
    (raises : ∀ w g, favours g → P.le (share w) (share (allKids (kids g) w)))
    (monotone : RuleCapture.ReadsShare P M h)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g')
    (locked : RuleCapture.Locked M favours (fun w g => h (share w) g) s.1) {k : Nat}
    (notfav : ¬ favours (course need kids (fun w g => h (share w) g) giving use s k).1.2) :
    ∃ j, j + 2 ≤ k ∧
      ∃ u, u ∈ (course need kids (fun w g => h (share w) g) giving use s j).1.1 ∧
        (course need kids (fun w g => h (share w) g) giving use s j).2 < need u :=
  match first_of_decided
      (P := fun t =>
        ∀ u, u ∈ (course need kids (fun w g => h (share w) g) giving use s t).1.1 →
          need u ≤ (course need kids (fun w g => h (share w) g) giving use s t).2)
      (Q := fun t =>
        ∃ u, u ∈ (course need kids (fun w g => h (share w) g) giving use s t).1.1 ∧
          (course need kids (fun w g => h (share w) g) giving use s t).2 < need u)
      (fun t => met_or_unmet need
        (course need kids (fun w g => h (share w) g) giving use s t).2
        (course need kids (fun w g => h (share w) g) giving use s t).1.1) k with
  | .inl all =>
    absurd (favours_while_met raises monotone upper locked k
      (fun j lt => all j (Nat.le_of_lt lt)) k (Nat.le_succ k)) notfav
  | .inr ⟨m, _, unmet, before⟩ =>
    (Nat.lt_or_ge k (m + 2)).elim
      (fun lt => absurd
        (favours_while_met raises monotone upper locked m before k (Nat.le_of_lt_succ lt))
        notfav)
      (fun ge => ⟨m, ge, unmet⟩)

/-- **From a locked start, the test comes at least two steps after a need went unmet.** With
`raises`, `monotone`, `upper` and the start locked, and no premise on the stock: where the test
(`Tested`) holds at step `k`, some step `j` with `j + 2 ≤ k` has a unit whose need is above the
level there. `unmet_before_unfavoured`, the test saying that the rule in force does not favour. -/
theorem unmet_before_tested
    (raises : ∀ w g, favours g → P.le (share w) (share (allKids (kids g) w)))
    (monotone : RuleCapture.ReadsShare P M h)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g')
    (locked : RuleCapture.Locked M favours (fun w g => h (share w) g) s.1) {k : Nat}
    (tested : Tested need use y favours (fun w g => h (share w) g)
      (course need kids (fun w g => h (share w) g) giving use s k)) :
    ∃ j, j + 2 ≤ k ∧
      ∃ u, u ∈ (course need kids (fun w g => h (share w) g) giving use s j).1.1 ∧
        (course need kids (fun w g => h (share w) g) giving use s j).2 < need u :=
  unmet_before_unfavoured raises monotone upper locked tested.2.1

end Share

/-! ## 9. Two courses that differ in one unit of one need -/

namespace TwoKinds

/-- Two kinds of unit. -/
inductive Kind
  | F
  | O

open Kind

/-- `F` needs `n`, `O` one. -/
def need (n : Nat) : Kind → Nat
  | F => n
  | O => 1

/-- `F` takes fourteen, `O` one. -/
def use : Kind → Nat
  | F => 14
  | O => 1

/-- Under the rule `true`, `F` leaves `F, O` and `O` leaves `O, O`; under the rule `false` each
leaves itself. -/
def kids : Bool → Kind → List Kind
  | true, F => [F, O]
  | true, O => [O, O]
  | false, u => [u]

/-- Giving `min z (32 - z)`. -/
def giving (z : Nat) : Nat := min z (32 - z)

/-- The share of a way: the number of `F` in it. -/
def share : List Kind → Nat
  | [] => 0
  | F :: w => share w + 1
  | O :: w => share w

/-- The rule read off a share: `true` exactly where the share is at least one, whatever rule is in
force. -/
def read (a : Nat) (_ : Bool) : Bool := decide (1 ≤ a)

/-- The rule `true` favours. -/
abbrev favours (g : Bool) : Prop := g = true

/-- The start: one `F`, the rule `true`, the level twenty-eight. -/
def start : (List Kind × Bool) × Nat := (([F], true), 28)

/-- The course from the start where `F` needs `n`: the rule set next is `read` of the share of the
way. -/
abbrev run (n : Nat) : Nat → (List Kind × Bool) × Nat :=
  course (need n) kids (fun w g => read (share w) g) giving use start

/-- A number at most two others is at most their `min`. -/
theorem le_min {a b c : Nat} (ab : a ≤ b) (ac : a ≤ c) : a ≤ min b c := by
  show a ≤ (if b ≤ c then b else c)
  cases Nat.decLe b c with
  | isTrue _ => exact ab
  | isFalse _ => exact ac

/-- Under every take, the step keeps every level up to thirty-two within thirty-two:
`TurningInTime.kept_within` from the step under no take, checked level by level. -/
theorem keeps (T : Nat) : RegimeMargin.Keeps giving T 32 := fun _ le =>
  TurningInTime.kept_within (giving := giving) (hi := 32) (RegimeMargin.keeps_of_below rfl) T le

/-- At every take `T`, giving is short of `T` at every level below `T`: it is at most the level. -/
theorem short (T : Nat) : RegimeMargin.Short giving T T := fun z lt =>
  Nat.lt_of_le_of_lt (RegimeMargin.Peaked.min_le_left' z (32 - z)) lt

/-- At every take `T`, giving is at least `T` at every level `z` left with `T ≤ z` and
`z + T ≤ 32`. -/
theorem meets (T : Nat) : RegimeMargin.Meets giving T T 32 := fun _ le top =>
  le_min le (Naturals.le_sub_of_add_le top)

/-- Under the rule `false`, all the kids of a way are the way. -/
theorem allKids_false : ∀ w : List Kind, allKids (kids false) w = w
  | [] => rfl
  | u :: w => congrArg (u :: ·) (allKids_false w)

/-- Under the rule `true`, all the kids of a way have the way's share. -/
theorem share_allKids_true :
    ∀ w : List Kind, share (allKids (kids true) w) = share w
  | [] => rfl
  | F :: w => congrArg (· + 1) (share_allKids_true w)
  | O :: w => share_allKids_true w

/-- A way of share nothing has only `O`. -/
theorem only_O : ∀ {w : List Kind}, share w = 0 → ∀ u, u ∈ w → u = O
  | [], _, _, m => nomatch m
  | F :: _, e, _, _ => absurd e (Naturals.succ_ne_zero _)
  | O :: w, e, _, m => (mem_cons_cases m).elim id (only_O (w := w) e _)

/-- Where `F` needs something, kids need no more than their parent under both rules. -/
theorem down {n : Nat} (pos : 0 < n) : ∀ g u v, v ∈ kids g u → need n v ≤ need n u
  | true, F, _, .head _ => Nat.le_refl _
  | true, F, _, .tail _ (.head _) => pos
  | true, O, _, .head _ => Nat.le_refl _
  | true, O, _, .tail _ (.head _) => Nat.le_refl _
  | false, _, _, .head _ => Nat.le_refl _

/-- **Every premise of the three lists, at the two courses' parameters with `F` needing `n`.** In
the order of the lists but for `some`, with `y T = T`, `hi = 32`, shares ordered by `≤`
(`TurningInTime.Three.shareOrder`) and rules with `false` below `true`
(`TurningInTime.Three.ruleOrder`):

* list 1, the premises of `tested_or_ends`: `grows`, `even`, `down`, `needs` (along the course),
  `nothing`, `high`, `keepsAlong`, `regimeAlong`;
* list 2, what `tested_lasts` adds: `some` (it stands third in the conjunction, after `even`),
  `lowers`, `monotone`, `upper`;
* list 3: `raises`, and the start locked. -/
def Premises (n : Nat) : Prop :=
  (∀ g, favours g → ∀ u, use u < taken use (kids g u)) ∧
  (∀ g, ¬ favours g → ∀ u, taken use (kids g u) = use u) ∧
  (∀ g, ¬ favours g → ∀ u, kids g u ≠ []) ∧
  (∀ g u v, v ∈ kids g u → need n v ≤ need n u) ∧
  (∀ k u, u ∈ (run n k).1.1 → 0 < need n u) ∧
  RegimeMargin.FromNothing giving ∧
  start.2 ≤ 32 ∧
  (∀ k, (∀ j, j ≤ k → Goes (need n) (run n j)) →
    RegimeMargin.Keeps giving (taken use (run n k).1.1) 32) ∧
  (∀ k, (∀ j, j ≤ k → Goes (need n) (run n j)) → ¬ favours (run n k).1.2 →
    RegimeMargin.Short giving (taken use (run n k).1.1)
        (id (taken use (run n k).1.1)) ∧
      RegimeMargin.Meets giving (taken use (run n k).1.1)
        (id (taken use (run n k).1.1)) 32) ∧
  (∀ w g, ¬ favours g →
    TurningInTime.Three.shareOrder.le (share (allKids (kids g) w)) (share w)) ∧
  RuleCapture.ReadsShare TurningInTime.Three.shareOrder TurningInTime.Three.ruleOrder read ∧
  (∀ {g g'}, TurningInTime.Three.ruleOrder.le g g' → favours g → favours g') ∧
  (∀ w g, favours g →
    TurningInTime.Three.shareOrder.le (share w) (share (allKids (kids g) w))) ∧
  RuleCapture.Locked TurningInTime.Three.ruleOrder favours (fun w g => read (share w) g) start.1

/-- **Where `F` needs something, every premise of the three lists holds** (`Premises`). Under
`true` the kids of `F` together take fifteen, more than fourteen, and the kids of `O` two, more
than one; under `false` each unit leaves itself; kids need no more than their parent (`down`);
both kinds need something, so every unit the course reaches does; nothing is given from nothing
and the start twenty-eight is at most thirty-two; the stock's premises hold at every take
(`keeps`, `short`, `meets`), so along the course; no step changes the share of a way whose needs
are all met (`allKids_false`, `share_allKids_true`), so `lowers` and `raises` hold; the rule read
is `true` from a share of one up, monotone in the share; only `true` favours and nothing is above
it; and at the start the rule `true` favours and is the rule read from its one `F`. -/
theorem premises {n : Nat} (pos : 0 < n) : Premises n :=
  ⟨fun g fav u => match g, fav, u with
      | true, _, F => by decide
      | true, _, O => by decide
      | false, fav, _ => absurd fav Bool.false_ne_true,
    fun g notfav u => match g, notfav, u with
      | false, _, F => rfl
      | false, _, O => rfl
      | true, notfav, _ => absurd rfl notfav,
    fun g notfav u => match g, notfav with
      | false, _ => List.cons_ne_nil u []
      | true, notfav => absurd rfl notfav,
    down pos,
    fun _ u _ => match u with
      | F => pos
      | O => Nat.succ_pos 0,
    rfl, by decide, fun _ _ => keeps _, fun _ _ _ => ⟨short _, meets _⟩,
    fun w g notfav => match g, notfav with
      | false, _ => Nat.le_of_eq (congrArg share (allKids_false w))
      | true, notfav => absurd rfl notfav,
    fun _ _ _ _ le e => decide_eq_true (Nat.le_trans (of_decide_eq_true e) le),
    fun le fav => le fav,
    fun w g fav => match g, fav with
      | true, _ => Nat.le_of_eq (share_allKids_true w).symm
      | false, fav => absurd fav Bool.false_ne_true,
    rfl, fun _ => rfl⟩

end TwoKinds

namespace NeedTwentySeven

open TwoKinds TwoKinds.Kind

/-- **The course where `F` needs twenty-seven**, by computation. Step 1: `F, O` under `true` at
twenty-eight. Step 2: one `F` and three `O` under `true` at twenty-six. Step 3: six `O` under
`true` at eighteen (twenty-six did not meet the need of `F`, which left nothing; the rule read
from the one `F` then present is still `true`). Step 4: twelve `O` under `false` at twenty-four
(no `F` was present at step 3). Step 5 is step 4: twelve `O` leave themselves, take twelve, and
twelve are given back. -/
theorem course_values :
    run 27 1 = (([F, O], true), 28) ∧ run 27 2 = (([F, O, O, O], true), 26) ∧
      run 27 3 = (([O, O, O, O, O, O], true), 18) ∧
      run 27 4 = (([O, O, O, O, O, O, O, O, O, O, O, O], false), 24) ∧
      run 27 5 = run 27 4 :=
  ⟨rfl, rfl, rfl, rfl, rfl⟩

/-- **The premises hold** where `F` needs twenty-seven: `TwoKinds.premises`. -/
theorem premises : Premises 27 := TwoKinds.premises (by decide)

/-- **The test at step 4, some need met at every step before it.** At steps 0 to 3 some unit's need
is met; at step 4 the twelve `O` have their need of one met at twenty-four, which is what they take
and that again, the rule in force is `false`, and the rule read from a way with no `F` is `false`.
By computation. -/
theorem tested :
    (∀ j, j < 4 → Goes (need 27) (run 27 j)) ∧
      Tested (need 27) use id favours (fun w g => read (share w) g) (run 27 4) :=
  ⟨fun j lt => match j, lt with
      | 0, _ => by decide
      | 1, _ => by decide
      | 2, _ => by decide
      | 3, _ => by decide
      | _ + 4, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 4 _)),
    ⟨List.cons_ne_nil _ _,
      fun u mu => Eq.subst (motive := fun v => need 27 v ≤ (run 27 4).2)
        (only_O (w := (run 27 4).1.1) rfl u mu).symm (by decide),
      by decide⟩,
    by decide, by decide⟩

/-- **The net never ends, by the law.** `tested_lasts` at the premises (`premises`) and the test at
step 4 (`tested`). What goes on is twelve `O` (`course_values`) and the one `F` the rule counted is
gone. Not proved in this module (found by program on 20 November 2026): with the rule held favouring
the same start comes to a step with no need met, and with the rule that does not favour held from
the first move something goes on too. -/
theorem goes_on :
    «不穷» (net (need 27) kids (fun w g => read (share w) g) giving use) «一» start :=
  match premises with
  | ⟨_, even, leaves, down, _, _, high, keepsAlong, regimeAlong, lowers, monotone, upper, _, _⟩ =>
    tested_lasts (P := TurningInTime.Three.shareOrder) (M := TurningInTime.Three.ruleOrder)
      (share := share) (h := read) (y := id) (hi := 32) even leaves down high keepsAlong
      regimeAlong lowers monotone @upper ⟨4, tested⟩

/-- **The first need unmet is at step 2.** At steps 0 and 1 the level twenty-eight meets every
need; at step 2 the level twenty-six is below the need of `F`. By computation. -/
theorem first_unmet :
    (∀ j, j < 2 → ∀ u, u ∈ (run 27 j).1.1 → need 27 u ≤ (run 27 j).2) ∧
      ∃ u, u ∈ (run 27 2).1.1 ∧ (run 27 2).2 < need 27 u :=
  ⟨fun j lt u _ => match j, lt, u with
      | 0, _, F => by decide
      | 0, _, O => by decide
      | 1, _, F => by decide
      | 1, _, O => by decide
      | _ + 2, lt, _ => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 2 _)),
    ⟨F, .head _, by decide⟩⟩

/-- **The rule favours through step 3, by the law.** `favours_while_met` at the premises: the start
is locked and every need is met before step 2 (`first_unmet`). The test comes at step 4, two steps
after the first need unmet, the least `unmet_before_tested` allows. -/
theorem favours_through_three : ∀ j, j ≤ 3 → favours (run 27 j).1.2 :=
  match premises with
  | ⟨_, _, _, _, _, _, _, _, _, _, monotone, upper, raises, locked⟩ =>
    favours_while_met (P := TurningInTime.Three.shareOrder)
      (M := TurningInTime.Three.ruleOrder) (share := share) (h := read) raises monotone @upper
      locked 2 first_unmet.1

end NeedTwentySeven

namespace NeedTwentySix

open TwoKinds TwoKinds.Kind

/-- **The course where `F` needs twenty-six**, by computation. Steps 1 and 2 as where it needs
twenty-seven: `F, O` under `true` at twenty-eight, then one `F` and three `O` under `true` at
twenty-six. Step 3: twenty-six met the need of `F`, so one `F` and seven `O` under `true` at
eighteen. Step 4: eighteen did not meet the need of `F`; fourteen `O` under `true` at nothing, the
twenty-one taken at step 3 being more than eighteen. -/
theorem course_values :
    run 26 1 = (([F, O], true), 28) ∧ run 26 2 = (([F, O, O, O], true), 26) ∧
      run 26 3 = (([F, O, O, O, O, O, O, O], true), 18) ∧
      run 26 4 = (([O, O, O, O, O, O, O, O, O, O, O, O, O, O], true), 0) :=
  ⟨rfl, rfl, rfl, rfl⟩

/-- **The premises hold** where `F` needs twenty-six: `TwoKinds.premises`. -/
theorem premises : Premises 26 := TwoKinds.premises (by decide)

/-- **No need met at step 4, some need met at every step before it.** By computation. -/
theorem ends :
    (∀ j, j < 4 → Goes (need 26) (run 26 j)) ∧ ¬ Goes (need 26) (run 26 4) :=
  ⟨fun j lt => match j, lt with
      | 0, _ => by decide
      | 1, _ => by decide
      | 2, _ => by decide
      | 3, _ => by decide
      | _ + 4, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 4 _)),
    by decide⟩

/-- **The net ends, and no step with some need met at every step before it has the test.** The net
ends because step 4 has no need met (`ends`; the half of `ends_iff_unmet` that asks no premise). No
step with some need met at every step before it has the test, by the law at the premises
(`premises`): such a step would make the net never end (`unending_iff_tested`, right to left, which
is `tested_lasts`). -/
theorem ends_untested :
    ¬ «不穷» (net (need 26) kids (fun w g => read (share w) g) giving use) «一» start ∧
      ¬ ∃ k, (∀ j, j < k → Goes (need 26) (run 26 j)) ∧
        Tested (need 26) use id favours (fun w g => read (share w) g) (run 26 k) :=
  match premises with
  | ⟨grows, even, leaves, down, needs, nothing, high, keepsAlong, regimeAlong, lowers, monotone,
      upper, _, _⟩ =>
    have stops :
        ¬ «不穷» (net (need 26) kids (fun w g => read (share w) g) giving use) «一» start :=
      (ends_iff_unmet (P := TurningInTime.Three.shareOrder)
        (M := TurningInTime.Three.ruleOrder) (share := share) (h := read) (y := id) (hi := 32)
        grows even leaves down needs nothing high keepsAlong regimeAlong lowers monotone
        @upper).mpr ⟨4, ends⟩
    ⟨stops, fun tested => stops
      ((unending_iff_tested (P := TurningInTime.Three.shareOrder)
        (M := TurningInTime.Three.ruleOrder) (share := share) (h := read) (y := id) (hi := 32)
        grows even leaves down needs nothing high keepsAlong regimeAlong lowers monotone
        @upper).mpr tested)⟩

/-- **The rule favours through step 4, by the law.** `favours_while_met` at the premises: the start
is locked, and every need is met at steps 0, 1 and 2 (by computation); that a need is unmet at step
3 is not stated. -/
theorem favours_through_four : ∀ j, j ≤ 4 → favours (run 26 j).1.2 :=
  match premises with
  | ⟨_, _, _, _, _, _, _, _, _, _, monotone, upper, raises, locked⟩ =>
    favours_while_met (P := TurningInTime.Three.shareOrder)
      (M := TurningInTime.Three.ruleOrder) (share := share) (h := read) raises monotone @upper
      locked 3 fun j lt u _ => match j, lt, u with
        | 0, _, F => by decide
        | 0, _, O => by decide
        | 1, _, F => by decide
        | 1, _, O => by decide
        | 2, _, F => by decide
        | 2, _, O => by decide
        | _ + 3, lt, _ => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 3 _))

end NeedTwentySix

/-! ## 10. At one rule: the single-rule course as a case -/

section OneRule

variable {need use : U → Nat} {kids : U → List U} {giving : Nat → Nat}

/-- **At one rule the course is the single-rule orbit, the rule carried.** With `R := PUnit` and
the same kids under it, for any `next`: at every step the way and the level are those of
`Law.orbit (TurningInTime.pair (stepAfter need kids) (stepLeft giving use))` from the same way and
level. -/
theorem course_one_rule (next : List U → PUnit → PUnit) (w : List U) (x : Nat) :
    ∀ k, course need (fun _ => kids) next giving use ((w, PUnit.unit), x) k =
      (((Law.orbit (TurningInTime.pair (stepAfter need kids) (stepLeft giving use)) (w, x) k).1,
          PUnit.unit),
        (Law.orbit (TurningInTime.pair (stepAfter need kids) (stepLeft giving use)) (w, x) k).2)
  | 0 => rfl
  | k + 1 => congrArg (step need (fun _ => kids) next giving use) (course_one_rule next w x k)

/-- At one rule the way at every step is the way of the single-rule orbit (`course_one_rule`). -/
theorem way_one_rule (next : List U → PUnit → PUnit) (w : List U) (x k : Nat) :
    (course need (fun _ => kids) next giving use ((w, PUnit.unit), x) k).1.1 =
      (Law.orbit (TurningInTime.pair (stepAfter need kids) (stepLeft giving use)) (w, x) k).1 :=
  congrArg (fun t => t.1.1) (course_one_rule next w x k)

/-- At one rule some need is met at a step exactly where it is at that step of the single-rule
orbit (`course_one_rule`). -/
theorem goes_one_rule (next : List U → PUnit → PUnit) (w : List U) (x k : Nat) :
    Goes need (course need (fun _ => kids) next giving use ((w, PUnit.unit), x) k) ↔
      stepGoes need
        (Law.orbit (TurningInTime.pair (stepAfter need kids) (stepLeft giving use)) (w, x) k) :=
  Eq.subst
    (motive := fun t =>
      Goes need t ↔
        stepGoes need
          (Law.orbit (TurningInTime.pair (stepAfter need kids) (stepLeft giving use)) (w, x) k))
    (course_one_rule next w x k).symm Iff.rfl

/-- At one rule that does not favour, the test at a step is that the configuration at that step of
the single-rule orbit holds (`course_one_rule`). -/
theorem tested_one_rule {y : Nat → Nat} (next : List U → PUnit → PUnit) (w : List U)
    (x k : Nat) :
    Tested need use y (fun _ => False) next
        (course need (fun _ => kids) next giving use ((w, PUnit.unit), x) k) ↔
      Holds need use y
        (Law.orbit (TurningInTime.pair (stepAfter need kids) (stepLeft giving use)) (w, x) k) :=
  Eq.subst
    (motive := fun t =>
      Tested need use y (fun _ => False) next t ↔
        Holds need use y
          (Law.orbit (TurningInTime.pair (stepAfter need kids) (stepLeft giving use)) (w, x) k))
    (course_one_rule next w x k).symm
    ⟨fun tested => tested.1, fun holds => ⟨holds, id, id⟩⟩

end OneRule

/-- The order on the one-element type. -/
def oneOrder : Ideals.Preorder PUnit where
  le _ _ := True
  refl _ := trivial
  trans _ _ := trivial

/-! ## 11. A course with both outcomes -/

namespace BothOutcomes

/-- Three rules. -/
inductive Rule
  | a
  | b
  | c

open Rule

/-- The one unit needs one. -/
def need (_ : Unit) : Nat := 1

/-- The one unit takes one. -/
def use (_ : Unit) : Nat := 1

/-- Under the rules `a` and `b` the unit leaves itself; under `c` it leaves two. -/
def kids : Rule → Unit → List Unit
  | a, u => [u]
  | b, u => [u]
  | c, u => [u, u]

/-- The rule set next, whatever the way: after `a` comes `b`, after `b` and after `c` comes `c`. -/
def next (_ : List Unit) : Rule → Rule
  | a => b
  | b => c
  | c => c

/-- Only the rule `c` favours. -/
abbrev favours (g : Rule) : Prop := g = c

/-- Whether a rule favours is decided. -/
instance favoursDecidable : DecidablePred favours := fun g =>
  match g with
  | a => isFalse fun e => nomatch e
  | b => isFalse fun e => nomatch e
  | c => isTrue rfl

/-- The start: one unit, the rule `a`, the level two. -/
def start : (List Unit × Rule) × Nat := (([()], a), 2)

/-- The course from the start, with the giving of `TwoKinds`, `min z (32 - z)`. -/
abbrev run : Nat → (List Unit × Rule) × Nat :=
  course need kids next TwoKinds.giving use start

/-- **Every premise of `tested_or_ends`, at this course's parameters**, in its order, with
`y T = T` and `hi = 32`: `grows`, `even`, `down`, `needs` (along the course), `nothing`, `high`,
`keepsAlong`, `regimeAlong`. That `favours` is decided is the instance `favoursDecidable`. -/
def Premises : Prop :=
  (∀ g, favours g → ∀ u, use u < taken use (kids g u)) ∧
  (∀ g, ¬ favours g → ∀ u, taken use (kids g u) = use u) ∧
  (∀ g u v, v ∈ kids g u → need v ≤ need u) ∧
  (∀ k u, u ∈ (run k).1.1 → 0 < need u) ∧
  RegimeMargin.FromNothing TwoKinds.giving ∧
  start.2 ≤ 32 ∧
  (∀ k, (∀ j, j ≤ k → Goes need (run j)) →
    RegimeMargin.Keeps TwoKinds.giving (taken use (run k).1.1) 32) ∧
  (∀ k, (∀ j, j ≤ k → Goes need (run j)) → ¬ favours (run k).1.2 →
    RegimeMargin.Short TwoKinds.giving (taken use (run k).1.1)
        (id (taken use (run k).1.1)) ∧
      RegimeMargin.Meets TwoKinds.giving (taken use (run k).1.1)
        (id (taken use (run k).1.1)) 32)

/-- **The premises hold** (`Premises`). Under `c` the unit's two kids together take two, more than
one; under `a` and `b` it leaves itself; every unit needs one; nothing is given from nothing and
the start two is at most thirty-two; the stock's premises hold at every take (`TwoKinds.keeps`,
`TwoKinds.short`, `TwoKinds.meets`), so along the course. -/
theorem premises : Premises :=
  ⟨fun g fav _ => match g, fav with
      | c, _ => (by decide : (1 : Nat) < 2)
      | a, fav => nomatch fav
      | b, fav => (nomatch fav),
    fun g notfav _ => match g, notfav with
      | a, _ => rfl
      | b, _ => rfl
      | c, notfav => absurd rfl notfav,
    fun _ _ _ _ => Nat.le_refl 1,
    fun _ _ _ => Nat.succ_pos 0,
    rfl, by decide, fun _ _ => TwoKinds.keeps _,
    fun _ _ _ => ⟨TwoKinds.short _, TwoKinds.meets _⟩⟩

/-- **The course**, by computation. Step 1: the unit under `b` at two. Step 2: the unit under `c`
at two. Step 3: two units under `c` at two. Step 4: four units under `c` at nothing, the two units
of step 3 having taken the two there were. -/
theorem course_values :
    run 1 = (([()], b), 2) ∧ run 2 = (([()], c), 2) ∧ run 3 = (([(), ()], c), 2) ∧
      run 4 = (([(), (), (), ()], c), 0) :=
  ⟨rfl, rfl, rfl, rfl⟩

/-- **The test at step 0.** The way has its one unit, whose need of one the level two meets; two is
what the way takes and that again; the rule in force `a` does not favour, and the rule set next,
`b`, does not. -/
theorem tested_at_start : Tested need use id favours next (run 0) :=
  ⟨⟨List.cons_ne_nil _ _, fun _ _ => (by decide : (1 : Nat) ≤ 2), (by decide : (1 : Nat) + 1 ≤ 2)⟩,
    fun e => (nomatch e), fun e => (nomatch e)⟩

/-- **Some need met at steps 0 to 3, and no need met at step 4.** By computation. -/
theorem ends : (∀ j, j < 4 → Goes need (run j)) ∧ ¬ Goes need (run 4) :=
  ⟨fun j lt => match j, lt with
      | 0, _ => by decide
      | 1, _ => by decide
      | 2, _ => by decide
      | 3, _ => by decide
      | _ + 4, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 4 _)),
    by decide⟩

/-- **Both outcomes of `tested_or_ends` hold of one course.** Every premise of `tested_or_ends`
holds of the course from `start` (`premises`); it has a step with the test, some need met at every
step before it (step 0, `tested_at_start`); and it has a step with no need met, some need met at
every step before it (step 4, `ends`). So under the premises of `tested_or_ends` alone its "or"
is inclusive. What shuts the two outcomes out of each other is what `tested_lasts` adds, which
this course does not meet (`not_read_from_a_share`). -/
theorem both :
    Premises ∧
      (∃ k, (∀ j, j < k → Goes need (run j)) ∧ Tested need use id favours next (run k)) ∧
      ∃ n, (∀ j, j < n → Goes need (run j)) ∧ ¬ Goes need (run n) :=
  ⟨premises, ⟨0, fun _ lt => absurd lt (Nat.not_lt_zero _), tested_at_start⟩, 4, ends⟩

/-- **The law at this course.** `tested_or_ends` at `premises`, with `y := id` and `hi := 32`: the
conjunction `Premises` is its list of premises, clause for clause. The law gives one outcome or the
other; `both` gives each. -/
theorem by_law : Outcomes need use id favours next run :=
  match premises with
  | ⟨grows, even, down, needs, nothing, high, keepsAlong, regimeAlong⟩ =>
    tested_or_ends (y := id) (hi := 32) grows even down needs nothing high keepsAlong regimeAlong

/-- **No reading of this `next` from a share of the way meets what `tested_lasts` adds.** For any
share of the way, orders `P` on shares and `M` on rules, and reading `h` with
`fun w g => h (share w) g` the `next` of this case (`reads`): `lowers`, `monotone` and `upper` do
not all hold. The other premises of `tested_lasts` hold here (`premises`; every unit has kids under
every rule), so with the three it would make the net never end from the test at step 0
(`tested_at_start`), and a net that never ends has some need met at step 4, which `ends` denies.
Which of the three fails is not stated. -/
theorem not_read_from_a_share {A : Type} {P : Ideals.Preorder A} {M : Ideals.Preorder Rule}
    {share : List Unit → A} {h : A → Rule → Rule} (reads : (fun w g => h (share w) g) = next)
    (lowers : ∀ w g, ¬ favours g → P.le (share (allKids (kids g) w)) (share w))
    (monotone : RuleCapture.ReadsShare P M h)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') : False :=
  match premises with
  | ⟨_, even, down, _, _, high, _, _⟩ =>
    have never :
        «不穷» (net need kids (fun w g => h (share w) g) TwoKinds.giving use) «一» start :=
      tested_lasts (y := id) (hi := 32) even
        (fun g _ u => match g with
          | a => List.cons_ne_nil u []
          | b => List.cons_ne_nil u []
          | c => List.cons_ne_nil u [u])
        down high (fun _ _ => TwoKinds.keeps _)
        (fun _ _ _ => ⟨TwoKinds.short _, TwoKinds.meets _⟩) lowers monotone upper
        ⟨0, fun _ lt => absurd lt (Nat.not_lt_zero _),
          Eq.subst (motive := fun nx => Tested need use id favours nx start) reads.symm
            tested_at_start⟩
    ends.2 (Eq.subst
      (motive := fun nx => Goes need (course need kids nx TwoKinds.giving use start 4)) reads
      (Law.stepWhile_unending_iff.mp never 4))

end BothOutcomes

end WayUnderARule
end Becoming
