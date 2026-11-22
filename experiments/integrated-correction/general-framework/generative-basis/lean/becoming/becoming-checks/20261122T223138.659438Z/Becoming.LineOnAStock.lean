import Becoming.TurningInTime
import Becoming.SelectionTerm
import Becoming.ReadingsPersist

/-!
# A line on a stock: units that leave offspring on a renewed level

AI-written, 16 November 2026.

## The model

A type `U` of units, each with a need and a use (`need use : U → Nat`) and the units it leaves
(`kids : U → List U`). A way is a list of units; a level is a number. After a step at level `x`
each unit of the way in turn leaves its kids where `x` meets its need and nothing where it does not
(`after`); the level becomes `RegimeMargin.step giving (taken use w) x`, where `taken` is the total of
the uses of every unit present (`left`). The net has a next while some unit's need is met (`Goes`,
`net`, `Law.stepWhile` of `TurningInTime.pair`); `course` is the pair's orbit, and `generation` the
kids of the kids … of a way with no level in it. `WayOfUnits` is the case `kids u = [u]` on
`U = Nat × Nat`; the bridge is in `WayOfUnits`, which imports this module.

## One relation with two ends, under any giving and use

The way and the level are one step, read from each end. The way reads the level only through which
needs it meets (`after_alike`); the level reads the way only through what it takes (`left_of_taken`);
the way after a step of two ways side by side is the two ways after it, side by side
(`after_append`; that they then reach each other only through the level, by what they take together,
is a reading). Along two courses from one way, under one `need` and `kids`, two givings, two uses and
two start levels, whose levels
meet the same needs of the way step by step, the ways are the same (`ways_alike`): no new difference,
new kinds included, arrives from a difference not yet made; read as generations of descent
(`SelectionTerm.Generations`, `generations`, `family_eq`), the same number is born
(`born_alike`).

What makes a difference to a way is its own response: two levels are `Alike` to `w` where the way
after a step at each is the same. Meeting the same needs makes levels alike (`alike_of_met`); where
every unit of `w` leaves a kid, alike levels meet the same needs (`alike_iff`), and without that they
need not (`AlikeFiner`). Every need in the next way is the need of a kid of a unit met at the level
(`need_in_after`); with kids needing what their parent needs and every unit leaving a kid, the needs
in the next way are those of `w` met at the level (`needs_after_iff`), and where every need of `w` is
met they are those of `w` (`needs_kept`).

## Laws of the way that ask nothing of the giving

* **Rise** (`rise`, one step, any decidable `S`, any level): where every unit of `S` is met and each
  unit's kids of `S` together take more than it, what `S` takes rises by at least its number of
  units.
* **What is lost of a line does not come back** (`never_in`, `gone_from`): with no unit outside a line
  `S` leaving a unit of it (`closed`), a line with no unit at a step has none after;
  `SelectionTerm.Generations.kept_of_descent` at the course as generations.
* **Units that take nothing** (`takes_nothing`): units of a decidable `Z` that take nothing and leave
  only units of `Z` leave the levels as they are, and the way as it is once they are taken out
  (`TakesNothing`); whether the net ends can change (`NothingTakenEnds`).
* **The account** (`account`): while what the way takes is within the level, the level at step `N`
  with everything taken before it is the start level with everything given before it
  (`balance_over_stretch_on` of `Prelude`).

## Laws that need the stock

Each docstring names all its premises.

* **A way each of whose units has kids that together take more than it comes to an unmet need within
  `hi + 1` steps, the way until then not depending on the stock** (`need_unmet`): with nothing given
  from nothing and the step under no draw keeping every level up to `hi` within `hi`
  (`RegimeMargin.Keeps giving 0 hi`), a way that is not empty, starting at most `hi`, every unit's
  kids together taking more than it (asked of every unit) and every descendant of the way needing
  something, every need met at the start, comes to an unmet need at a step from 1 to `hi + 1`; up to
  it the way is the generation, in which no giving, use or level appears (`way_while_met`). Through
  the course as it was under `allKids` (`after_of_met`, `course_asItWas`), by
  `TurningInTime.rising_takes_all`. With kids needing no more than their parent (`down`), the level
  by then is below a need the start met (`falls_to_unmet`); without `down` it need not have fallen
  (`KidHigherNeed`). In a world of one need, the net ends within `hi + 1` steps (`one_need_ends`); a
  lock whose share is a number of drawers ends through the same `TurningInTime.rising_takes_all`,
  not through `need_unmet` (`TurningInTime.locked_ends_rising`, `count_rises`).
* **A line that grows ends** (`line_ends`): with the stock so bounded and a closed line each of whose
  units has kids of the line that together take more than it, needs something, and has kids that need
  no more than it, the line is gone from some step on; for the line of every unit, the net ends
  (`way_ends`). No bound on the step.
* **Fall** (`fall`): a closed line of one need `m`, each of whose units has kids of the line that
  together take no less than it, taking at the start more than every giving (given), with
  `giving 0 < m`, is gone from some step on.
* **What a way that goes on takes** (`taken_below`): with nothing given from nothing and every
  descendant of the start needing something, below the level at every step after which some need is
  still met; on a net that never ends, the account holds for every `N` (`account_unending`).
* **The middle case, exact** (`unending_iff_holds`): where each unit's kids together take what it
  takes (`even`), every unit has kids (`some`), kids need no more than their parent (`down`), every
  descendant of the way needs something (`needs`), nothing is given from nothing (`nothing`), the start
  is at most `hi` (`high`), and `Regime` holds at every way the course reaches with some need met there
  and at every step before (`along`): the net never ends exactly where, some need met at every step
  before, the course comes to a configuration that holds (`Holds`). `WayOfUnits.unending_iff_holds` is
  its case `kids u = [u]`. In `TwoForOne` only `P`'s offspring are not itself (`Q` leaves itself), the
  course is fixed from step 1, and the instance uses the "if" side at `k = 0`.

## A unit's kids together taking more than it, the same, or less

Each law asks its case of every unit (`grows`: `way_ends`, `need_unmet`, `falls_to_unmet`,
`one_need_ends`; `even`: `unending_iff_holds`), or of every unit of a closed line (`line_ends`; its
kids of the line together taking no less than it: `fall`). A way that mixes them, as
`HigherStartEnds` (`A`'s kids together take less than it, `B`'s more than `B`, `C`'s more than `C`),
falls under none.

## What is given and not derived

The kinds, needs, uses and offspring are given with the carrier; nothing here makes a new kind or
changes `kids`. The giving and its bounds (`FromNothing`, `Keeps`, `Short`, `Meets`, `Regime`) are
premises. Kept countermodels and worked courses, each closed: kids that need more than their parent,
every other premise of `way_ends` holding, the net never ending (`KidsNeedMore`); a kid's greater need
unmet at the first step, the level not fallen, every premise of `need_unmet` holding (`KidHigherNeed`);
equal in place of more, every other premise holding, the net never ending, also as a case of
`unending_iff_holds` (`EqualInPlaceOfMore`); a case of `unending_iff_holds` with offspring that are not the unit
(`TwoForOne`); a share that rises while the number of drawers falls (`ShareRises`); a line that
doubles and ends, as a case of `way_ends` and of `need_unmet` (`Doubling`); a higher start that ends
while the lower one never does, the ways equal at steps 0 to 2 by `ways_alike` (`HigherStartEnds`); a
met unit with no kids, whose net ends with every need met (`NoKids`); a case of `fall` (`Overdrawn`);
a case of `line_ends` with a line that is a proper part of the way (`ProperLine`); levels alike that
meet different needs (`AlikeFiner`); a unit that takes nothing, lost (`TakesNothing`); a unit that
takes nothing and keeps the net going (`NothingTakenEnds`). Two built examples have this model's sizes
and levels, in `LineOnAStockCases`.

## What is not here

No exact condition for a way each of whose units has kids that together take more than it, or less,
never ending; `HigherStartEnds` shows that, with one way, whether the net ends is not monotone in
the start level. Losses of units that take something, the regime read as a `Web` with a `Flow` (a
reading only; `account` is the plain balance kept here), and a lock on these units are not here.
Nothing here is about a trained system.

Every declaration has an empty axiom report.
-/

namespace Becoming
namespace LineOnAStock

variable {U : Type}

/-! ## 1. The model -/

/-- The way after a step at level `x`: each unit in turn leaves its kids where `x` meets its need,
and nothing where it does not. -/
def after (need : U → Nat) (kids : U → List U) : List U → Nat → List U
  | [], _ => []
  | u :: w, x => cond (decide (need u ≤ x)) (kids u) [] ++ after need kids w x

/-- What a way takes: the total of its units' uses (`Becoming.total`, the total of `Prelude`). -/
def taken (use : U → Nat) (w : List U) : Nat := total w use

/-- The level after a step: `RegimeMargin.step` under what every unit present at the step takes. -/
def left (giving : Nat → Nat) (use : U → Nat) (w : List U) (x : Nat) : Nat :=
  RegimeMargin.step giving (taken use w) x

/-- Some unit of the way has its need met at the level. -/
def Goes (need : U → Nat) (s : List U × Nat) : Prop := ∃ u, u ∈ s.1 ∧ need u ≤ s.2

/-- The pair's step: the way after a step and the level after it (`TurningInTime.pair`). -/
abbrev step (need : U → Nat) (kids : U → List U) (giving : Nat → Nat) (use : U → Nat) :
    List U × Nat → List U × Nat :=
  TurningInTime.pair (after need kids) (left giving use)

/-- The net: the pair's step while some unit's need is met, and nothing where none is. -/
def net (need : U → Nat) (kids : U → List U) (giving : Nat → Nat) (use : U → Nat) :
    «际» (List U × Nat) :=
  Law.stepWhile (Goes need) (step need kids giving use)

/-- The course: the pair's orbit from `s`. -/
abbrev course (need : U → Nat) (kids : U → List U) (giving : Nat → Nat) (use : U → Nat)
    (s : List U × Nat) : Nat → List U × Nat :=
  Law.orbit (step need kids giving use) s

/-- The kids of every unit of a way, in order: the way after a step at which every need is met. -/
def allKids (kids : U → List U) : List U → List U
  | [] => []
  | u :: w => kids u ++ allKids kids w

/-- The `n`-th generation of a way with no level in it: the kids of the kids … of its units. -/
def generation (kids : U → List U) : Nat → List U → List U
  | 0, w => w
  | n + 1, w => allKids kids (generation kids n w)

/-- What `S` takes of a way: the total of `use` over the units of the way with `S`. -/
def lineTake (S : U → Prop) [DecidablePred S] (use : U → Nat) (w : List U) : Nat :=
  total w fun u => if S u then use u else 0

/-- The number of units of a way with `S`. -/
def lineCount (S : U → Prop) [DecidablePred S] (w : List U) : Nat :=
  total w fun u => if S u then 1 else 0

/-- A configuration from which what its way takes holds: the way is not empty, every unit's need is
met at the level, and the level is at or above what the way takes and `y` of it. `WayOfUnits.Holds`
for any units. -/
def Holds (need use : U → Nat) (y : Nat → Nat) (s : List U × Nat) : Prop :=
  s.1 ≠ [] ∧ (∀ u, u ∈ s.1 → need u ≤ s.2) ∧ taken use s.1 + y (taken use s.1) ≤ s.2

/-- The regime at a way `w`: giving short of what `w` takes below `y` of it, meeting it from there up
to `hi`, and the step under it keeping the level within `hi`. `WayOfUnits.Regime` for any units. -/
def Regime (giving : Nat → Nat) (use : U → Nat) (y : Nat → Nat) (hi : Nat) (w : List U) : Prop :=
  RegimeMargin.Short giving (taken use w) (y (taken use w)) ∧
    RegimeMargin.Meets giving (taken use w) (y (taken use w)) hi ∧
    RegimeMargin.Keeps giving (taken use w) hi

/-- Every unit of every generation of `w` needs something. -/
def Needing (need : U → Nat) (kids : U → List U) (w : List U) : Prop :=
  ∀ n u, u ∈ generation kids n w → 0 < need u

/-! ## 2. On lists -/

theorem mem_cond {a : U} {l : List U} : ∀ {b : Bool}, a ∈ cond b l [] → b = true ∧ a ∈ l
  | true, m => ⟨rfl, m⟩
  | false, m => nomatch m

theorem mem_cond_of {a : U} {l : List U} : ∀ {b : Bool}, b = true → a ∈ l → a ∈ cond b l []
  | true, _, m => m

/-- Where `x` and `x'` meet the need `n` alike, the two tests of it are the same. -/
theorem decide_le_congr {n x x' : Nat} (same : n ≤ x ↔ n ≤ x') :
    decide (n ≤ x) = decide (n ≤ x') :=
  (Nat.lt_or_ge x n).elim
    (fun lt => (decide_eq_false (Nat.not_le_of_gt lt)).trans
      (decide_eq_false fun le => Nat.not_le_of_gt lt (same.mpr le)).symm)
    (fun le => (decide_eq_true le).trans (decide_eq_true (same.mp le)).symm)

theorem ite_le {S : U → Prop} [DecidablePred S] (u : U) (a : Nat) :
    (if S u then a else 0) ≤ a :=
  (Decidable.em (S u)).elim
    (fun h => Nat.le_of_eq (if_pos h))
    (fun h => Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le a))

/-- What `S` takes is at most what the way takes. -/
theorem lineTake_le_taken {S : U → Prop} [DecidablePred S] {use : U → Nat} (w : List U) :
    lineTake S use w ≤ taken use w :=
  total_le w fun u _ => ite_le u (use u)

theorem lineTake_append {S : U → Prop} [DecidablePred S] {use : U → Nat} (a b : List U) :
    lineTake S use (a ++ b) = lineTake S use a + lineTake S use b :=
  total_append _ b a

/-- A unit with `S` in the way makes the count of `S` positive. -/
theorem lineCount_pos {S : U → Prop} [DecidablePred S] {u : U} (su : S u) {w : List U}
    (mu : u ∈ w) : 0 < lineCount S w :=
  have one : (if S u then 1 else 0) = 1 := if_pos su
  Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_of_eq one.symm))
    (le_total_of_mem (q := fun v => if S v then 1 else 0) mu)

/-- Every unit of a way has `S` or not; decided along the way. -/
theorem line_or_none {S : U → Prop} [DecidablePred S] :
    ∀ w : List U, (∀ u, u ∈ w → ¬ S u) ∨ ∃ u, u ∈ w ∧ S u :=
  fun w => gather_listed (D := fun u => ¬ S u) w
    (fun u mem k => (Decidable.em (S u)).elim (fun su => .inr ⟨u, mem, su⟩) k) Or.inl

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

/-- Whether some unit's need is met is decided, by `anyMet`. `WayOfUnits.goesDecidable` is its
case. -/
instance goesDecidable (need : U → Nat) (s : List U × Nat) : Decidable (Goes need s) :=
  decidable_of_iff (anyMet need s.2 s.1 = true) (anyMet_iff need s.2 s.1)

/-- A list that is not empty has a member. -/
theorem mem_of_ne_nil : ∀ {l : List U}, l ≠ [] → ∃ v, v ∈ l
  | [], ne => absurd rfl ne
  | v :: l, _ => ⟨v, .head l⟩

/-- Strong induction on a number: `Identification.below_upto`. -/
theorem strong_below {P : Nat → Prop} (step : ∀ m, (∀ m', m' < m → P m') → P m) :
    ∀ M m, m < M → P m :=
  Identification.below_upto step

/-! ## 3. The one relation with two ends -/

section Step

variable {need : U → Nat} {kids : U → List U}

/-- The way after a step is `List.flatMap` of what each unit leaves. -/
theorem after_flatMap (x : Nat) :
    ∀ w : List U, after need kids w x = w.flatMap fun u => cond (decide (need u ≤ x)) (kids u) []
  | [] => rfl
  | u :: w => congrArg (cond (decide (need u ≤ x)) (kids u) [] ++ ·) (after_flatMap x w)

/-- **Who is in the next way.** A unit is in the way after a step at `x` exactly where it is a kid of
a unit of the way whose need `x` meets. For any `need`, `kids`, way and level; by `after_flatMap` and
`ListTests.mem_flatMap_iff`. -/
theorem mem_after_iff {x : Nat} {v : U} {w : List U} :
    v ∈ after need kids w x ↔ ∃ u, u ∈ w ∧ need u ≤ x ∧ v ∈ kids u :=
  (Eq.subst (motive := fun l => v ∈ l ↔ ∃ u, u ∈ w ∧ v ∈ cond (decide (need u ≤ x)) (kids u) [])
      (after_flatMap x w).symm ListTests.mem_flatMap_iff).trans
    ⟨fun ⟨u, mu, mc⟩ => match mem_cond mc with
      | ⟨e, mk⟩ => ⟨u, mu, of_decide_eq_true e, mk⟩,
     fun ⟨u, mu, le, mk⟩ => ⟨u, mu, mem_cond_of (decide_eq_true le) mk⟩⟩

/-- **The way reads the level only through which needs it meets.** Where `x` and `x'` meet the same
needs in `w`, the way after a step at `x` is the way after a step at `x'`. For any `need` and
`kids`. -/
theorem after_alike {x x' : Nat} :
    ∀ {w : List U}, (∀ u, u ∈ w → (need u ≤ x ↔ need u ≤ x')) →
      after need kids w x = after need kids w x'
  | [], _ => rfl
  | u :: w, same => by
    show cond (decide (need u ≤ x)) (kids u) [] ++ after need kids w x =
      cond (decide (need u ≤ x')) (kids u) [] ++ after need kids w x'
    rw [decide_le_congr (same u (.head w)), after_alike fun v m => same v (.tail u m)]

/-- **Two ways side by side step side by side at one level.** The way after a step of `w₁ ++ w₂` at
`x` is the way after the step of `w₁` at `x`, then that of `w₂` at `x`. For any `need` and `kids`.
Used by no proof here. -/
theorem after_append (x : Nat) :
    ∀ w₁ w₂ : List U, after need kids (w₁ ++ w₂) x = after need kids w₁ x ++ after need kids w₂ x
  | [], _ => rfl
  | u :: w₁, w₂ =>
    (congrArg (cond (decide (need u ≤ x)) (kids u) [] ++ ·) (after_append x w₁ w₂)).trans
      (ListTests.append_assoc _ _ _).symm

/-- **The level reads the way only through what it takes.** The level after a step at two ways that
take the same is the same. For any giving and use. -/
theorem left_of_taken {giving : Nat → Nat} {use : U → Nat} {w₁ w₂ : List U} {x : Nat}
    (same : taken use w₁ = taken use w₂) : left giving use w₁ x = left giving use w₂ x :=
  congrArg (fun t => RegimeMargin.step giving t x) same

/-- Where every unit's need is met at `x`, the way after a step is all the kids. -/
theorem after_of_met {x : Nat} :
    ∀ {w : List U}, (∀ u, u ∈ w → need u ≤ x) → after need kids w x = allKids kids w
  | [], _ => rfl
  | u :: w, met =>
    (congrArg (fun b => cond b (kids u) [] ++ after need kids w x)
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

/-- The `n`-th generation is `allKids` taken `n` times. -/
theorem generation_orbit (w : List U) : ∀ n, generation kids n w = Law.orbit (allKids kids) w n
  | 0 => rfl
  | n + 1 => congrArg (allKids kids) (generation_orbit w n)

/-- Where every unit has kids, every generation of a way with a member has a member. -/
theorem generation_mem (some : ∀ u, kids u ≠ []) {v : U} {w : List U} (mv : v ∈ w) :
    ∀ n, ∃ u, u ∈ generation kids n w
  | 0 => ⟨v, mv⟩
  | n + 1 => match generation_mem some mv n with
    | ⟨u, mu⟩ => match mem_of_ne_nil (some u) with
      | ⟨c, mc⟩ => ⟨c, mem_allKids_iff.mpr ⟨u, mu, mc⟩⟩

/-- With kids needing no more than their parent (`down`), every unit of every generation of a way
whose needs are at most `z` needs at most `z`. -/
theorem generation_below (down : ∀ u v, v ∈ kids u → need v ≤ need u) {z : Nat} {w : List U}
    (met : ∀ u, u ∈ w → need u ≤ z) : ∀ n u, u ∈ generation kids n w → need u ≤ z
  | 0 => met
  | n + 1 => fun u mu => match mem_allKids_iff.mp mu with
    | ⟨p, mp, mk⟩ => Nat.le_trans (down p u mk) (generation_below down met n p mp)

/-- With kids needing no more than their parent (`down`), every unit of every generation of a way
needs at most what some unit of the way needs. -/
theorem generation_ancestor (down : ∀ u v, v ∈ kids u → need v ≤ need u) {w : List U} :
    ∀ n u, u ∈ generation kids n w → ∃ p, p ∈ w ∧ need u ≤ need p
  | 0 => fun u mu => ⟨u, mu, Nat.le_refl _⟩
  | n + 1 => fun u mu => match mem_allKids_iff.mp mu with
    | ⟨q, mq, mk⟩ => match generation_ancestor down n q mq with
      | ⟨p, mp, le⟩ => ⟨p, mp, Nat.le_trans (down q u mk) le⟩

/-- A unit of the way at step `k` of any course is a unit of the `k`-th generation of the start's
way. -/
theorem mem_generation {giving : Nat → Nat} {use : U → Nat} (s : List U × Nat) :
    ∀ k u, u ∈ (course need kids giving use s k).1 → u ∈ generation kids k s.1
  | 0, _, m => m
  | k + 1, _, m =>
    match (mem_after_iff (need := need) (kids := kids) (w := (course need kids giving use s k).1)
        (x := (course need kids giving use s k).2)).mp m with
    | ⟨p, mp, _, mk⟩ => mem_allKids_iff.mpr ⟨p, mem_generation s k p mp, mk⟩

end Step

/-! ## 3b. What makes a difference to a way -/

/-- Two levels are alike to a way where the way's own response to them is the same: the way after a
step at `x` is the way after a step at `x'`. -/
def Alike (need : U → Nat) (kids : U → List U) (w : List U) (x x' : Nat) : Prop :=
  after need kids w x = after need kids w x'

section Response

variable {need : U → Nat} {kids : U → List U}

/-- Levels that meet the same needs in `w` are alike to `w`: `after_alike`. -/
theorem alike_of_met {w : List U} {x x' : Nat} (same : ∀ u, u ∈ w → (need u ≤ x ↔ need u ≤ x')) :
    Alike need kids w x x' :=
  after_alike same

/-- What one unit leaves at a level is no shorter at a higher level. -/
theorem block_le {u : U} {x x' : Nat} (le : x ≤ x') :
    (cond (decide (need u ≤ x)) (kids u) []).length ≤
      (cond (decide (need u ≤ x')) (kids u) []).length :=
  (Nat.lt_or_ge x (need u)).elim
    (fun lt => Nat.le_trans (Nat.le_of_eq (congrArg (fun b => (cond b (kids u) []).length)
      (decide_eq_false (Nat.not_le_of_gt lt)))) (Nat.zero_le _))
    (fun ge => Nat.le_of_eq (congrArg (fun b => (cond b (kids u) []).length)
      ((decide_eq_true ge).trans (decide_eq_true (Nat.le_trans ge le)).symm)))

/-- A unit with kids whose need is above `x` and at most `x'` leaves nothing at `x` and something
at `x'`. -/
theorem block_lt {u : U} {x x' : Nat} (lt : x < need u) (le : need u ≤ x') (leaves : kids u ≠ []) :
    (cond (decide (need u ≤ x)) (kids u) []).length <
      (cond (decide (need u ≤ x')) (kids u) []).length :=
  match mem_of_ne_nil leaves with
  | ⟨_, mc⟩ => Nat.lt_of_lt_of_le
      (Nat.lt_of_le_of_lt (Nat.le_of_eq (congrArg (fun b => (cond b (kids u) []).length)
        (decide_eq_false (Nat.not_le_of_gt lt)))) (length_pos_of_mem mc))
      (Nat.le_of_eq (congrArg (fun b => (cond b (kids u) []).length) (decide_eq_true le).symm))

/-- The way after a step at a higher level is no shorter. By `block_le` and
`ListTests.length_append`. -/
theorem after_length_le {x x' : Nat} (le : x ≤ x') :
    ∀ w : List U, (after need kids w x).length ≤ (after need kids w x').length
  | [] => Nat.le_refl 0
  | u :: w => by
    show (cond (decide (need u ≤ x)) (kids u) [] ++ after need kids w x).length ≤
      (cond (decide (need u ≤ x')) (kids u) [] ++ after need kids w x').length
    rw [ListTests.length_append, ListTests.length_append]
    exact Nat.add_le_add (block_le le) (after_length_le le w)

/-- The way after a step at `x'` is longer than at `x ≤ x'` where some unit of `w` with kids has its
need above `x` and at most `x'`. -/
theorem after_length_lt {x x' : Nat} (le : x ≤ x') {u : U} (lt : x < need u) (le' : need u ≤ x')
    (leaves : kids u ≠ []) :
    ∀ {w : List U}, u ∈ w → (after need kids w x).length < (after need kids w x').length
  | _ :: w, .head _ => by
    show (cond (decide (need u ≤ x)) (kids u) [] ++ after need kids w x).length <
      (cond (decide (need u ≤ x')) (kids u) [] ++ after need kids w x').length
    rw [ListTests.length_append, ListTests.length_append]
    exact Nat.add_lt_add_of_lt_of_le (block_lt lt le' leaves) (after_length_le le w)
  | v :: w, .tail _ m => by
    show (cond (decide (need v ≤ x)) (kids v) [] ++ after need kids w x).length <
      (cond (decide (need v ≤ x')) (kids v) [] ++ after need kids w x').length
    rw [ListTests.length_append, ListTests.length_append]
    exact Nat.add_lt_add_of_le_of_lt (block_le le) (after_length_lt le lt le' leaves m)

/-- One direction of `alike_iff`: with `x ≤ x'` alike to `w`, a unit of `w` with kids met at `x'` is
met at `x`. -/
theorem met_of_alike_le {w : List U} {x x' : Nat} (le : x ≤ x') (alike : Alike need kids w x x')
    {u : U} (mu : u ∈ w) (leaves : kids u ≠ []) (met : need u ≤ x') : need u ≤ x :=
  (Nat.lt_or_ge x (need u)).elim
    (fun lt => absurd (congrArg List.length alike)
      (Nat.ne_of_lt (after_length_lt le lt met leaves mu)))
    id

/-- **What makes a difference to a way, exactly.** Where every unit of `w` leaves a kid (`leaves`),
two levels are alike to `w` (the way after a step at each is the same) exactly where they meet the
same needs in `w`. Left to right: for `x ≤ x'` the way at `x'` is at least as long as at `x`, and
longer where some unit of `w` has `x < need u ≤ x'` (`after_length_le`, `after_length_lt`); equal
ways have equal lengths; `Nat.le_total` for the two orders. Right to left: `after_alike`. Without
`leaves` only right to left holds (`AlikeFiner`). -/
theorem alike_iff {w : List U} {x x' : Nat} (leaves : ∀ u, u ∈ w → kids u ≠ []) :
    Alike need kids w x x' ↔ ∀ u, u ∈ w → (need u ≤ x ↔ need u ≤ x') :=
  ⟨fun alike u mu => (Nat.le_total x x').elim
      (fun le => ⟨fun h => Nat.le_trans h le, met_of_alike_le le alike mu (leaves u mu)⟩)
      (fun le => ⟨met_of_alike_le le alike.symm mu (leaves u mu), fun h => Nat.le_trans h le⟩),
   alike_of_met⟩

/-- **Every need in the next way is the need of a kid of a unit met at the level.** For any `need`,
`kids`, way and level, with no premise; by `mem_after_iff`. -/
theorem need_in_after {x n : Nat} {w : List U} (some : ∃ v, v ∈ after need kids w x ∧ need v = n) :
    ∃ u v, u ∈ w ∧ need u ≤ x ∧ v ∈ kids u ∧ need v = n :=
  match some with
  | ⟨v, mv, e⟩ => match (mem_after_iff (need := need) (kids := kids)).mp mv with
    | ⟨u, mu, le, mk⟩ => ⟨u, v, mu, le, mk, e⟩

/-- **What the next way responds to.** With kids needing what their parent needs (`inherit`) and
every unit leaving a kid (`some`): a need `n` is the need of a unit of the way after a step at `x`
exactly where it is the need of a unit of `w` and `n ≤ x`. So a need unmet at `x` is the need of no
unit of the next way, and where every need of `w` is met the needs are kept (`needs_kept`). By
`mem_after_iff`. -/
theorem needs_after_iff (inherit : ∀ u v, v ∈ kids u → need v = need u) (some : ∀ u, kids u ≠ [])
    {x n : Nat} {w : List U} :
    (∃ v, v ∈ after need kids w x ∧ need v = n) ↔ ∃ u, u ∈ w ∧ need u = n ∧ n ≤ x :=
  ⟨fun ⟨v, mv, e⟩ => match (mem_after_iff (need := need) (kids := kids)).mp mv with
     | ⟨u, mu, le, mk⟩ => ⟨u, mu, (inherit u v mk).symm.trans e,
         Nat.le_trans (Nat.le_of_eq (e.symm.trans (inherit u v mk))) le⟩,
   fun ⟨u, mu, e, le⟩ => match mem_of_ne_nil (some u) with
     | ⟨c, mc⟩ => ⟨c, (mem_after_iff (need := need) (kids := kids)).mpr
         ⟨u, mu, Nat.le_trans (Nat.le_of_eq e) le, mc⟩, (inherit u c mc).trans e⟩⟩

/-- With `inherit` and `some`, where every need of `w` is met at `x`, the needs in the way after the
step are those in `w`. By `needs_after_iff`. -/
theorem needs_kept (inherit : ∀ u v, v ∈ kids u → need v = need u) (some : ∀ u, kids u ≠ [])
    {x n : Nat} {w : List U} (met : ∀ u, u ∈ w → need u ≤ x) :
    (∃ v, v ∈ after need kids w x ∧ need v = n) ↔ ∃ u, u ∈ w ∧ need u = n :=
  (needs_after_iff inherit some).trans
    ⟨fun ⟨u, mu, e, _⟩ => ⟨u, mu, e⟩,
     fun ⟨u, mu, e⟩ => ⟨u, mu, e, Nat.le_trans (Nat.le_of_eq e.symm) (met u mu)⟩⟩

end Response

/-! ## 4. Alike: two courses whose levels meet the same needs -/

section Count

variable {need : U → Nat} {kids : U → List U}

/-- **Ways alike: no new difference from one not yet made.** For two givings `g`, `g'`, two uses
`use`, `use'`, two start levels `x`, `x'` and one way `w`, under one `need` and `kids`: if for every
`j < n` the two levels at step `j` meet the same needs among the units of the first course's way there
(`alike`), the two ways are the same at every step `j ≤ n`. So a difference in the ways, new kinds
included, arrives only after a step at which the levels met different needs of the way. Nothing is
asked of the givings, the uses or the stock. By `after_alike`, step by step (meeting the same needs is
finer than being `Alike`: `AlikeFiner`). -/
theorem ways_alike {g g' : Nat → Nat} {use use' : U → Nat} {w : List U} {x x' n : Nat}
    (alike : ∀ j, j < n → ∀ u, u ∈ (course need kids g use (w, x) j).1 →
      (need u ≤ (course need kids g use (w, x) j).2 ↔ need u ≤ (course need kids g' use' (w, x') j).2)) :
    ∀ j, j ≤ n → (course need kids g use (w, x) j).1 = (course need kids g' use' (w, x') j).1
  | 0, _ => rfl
  | j + 1, le =>
    (after_alike (alike j le)).trans
      (congrArg (fun l => after need kids l (course need kids g' use' (w, x') j).2)
        (ways_alike alike j (Nat.le_of_succ_le le)))

/-- The course as generations of descent (`SelectionTerm.Generations`): the first family is the start's
way, the kids of `u` at step `t` are `kids u` where the level at step `t` meets `need u` and nothing
otherwise, and the amount is the use. The kids are read off the course's own levels. -/
def generations (need : U → Nat) (kids : U → List U) (giving : Nat → Nat) (use : U → Nat)
    (s : List U × Nat) : SelectionTerm.Generations U where
  first := s.1
  kids t u := cond (decide (need u ≤ (course need kids giving use s t).2)) (kids u) []
  amount _ := use

/-- At every step the family of `generations` is the course's way. Under any giving and use, from any
start; by `after_flatMap`. -/
theorem family_eq {giving : Nat → Nat} {use : U → Nat} (s : List U × Nat) :
    ∀ t, (generations need kids giving use s).family t = (course need kids giving use s t).1
  | 0 => rfl
  | t + 1 =>
    (congrArg (fun l => l.flatMap ((generations need kids giving use s).kids t)) (family_eq s t)).trans
      (after_flatMap (course need kids giving use s t).2 (course need kids giving use s t).1).symm

/-- The number born at step `t` (`SelectionTerm.born`) is the length of the course's next way:
`SelectionTerm.Generations.born_eq` with `family_eq`. -/
theorem born_eq_length {giving : Nat → Nat} {use : U → Nat} (s : List U × Nat) (t : Nat) :
    SelectionTerm.born ((generations need kids giving use s).family t)
        ((generations need kids giving use s).kids t) =
      (course need kids giving use s (t + 1)).1.length :=
  ((generations need kids giving use s).born_eq t).trans (congrArg List.length (family_eq s (t + 1)))

/-- **The count alike, in `SelectionTerm`'s terms.** Under the premise of `ways_alike`, at every step
`j < n` the number born (`SelectionTerm.born`) in the two `generations` is the same: what `ways_alike`
gives at `j + 1`, read as a count of offspring by `SelectionTerm.Generations.born_eq`
(`born_eq_length`). -/
theorem born_alike {g g' : Nat → Nat} {use use' : U → Nat} {w : List U} {x x' n : Nat}
    (alike : ∀ j, j < n → ∀ u, u ∈ (course need kids g use (w, x) j).1 →
      (need u ≤ (course need kids g use (w, x) j).2 ↔ need u ≤ (course need kids g' use' (w, x') j).2))
    {j : Nat} (lt : j < n) :
    SelectionTerm.born ((generations need kids g use (w, x)).family j)
        ((generations need kids g use (w, x)).kids j) =
      SelectionTerm.born ((generations need kids g' use' (w, x')).family j)
        ((generations need kids g' use' (w, x')).kids j) :=
  (born_eq_length (w, x) j).trans ((congrArg List.length (ways_alike alike (j + 1) lt)).trans
    (born_eq_length (w, x') j).symm)

end Count

/-! ## 5. Rise, and what descends along a line -/

section Line

variable {need : U → Nat} {kids : U → List U} {use : U → Nat} {S : U → Prop}

/-- Where each unit `u` with `S` has `use u + bonus u` at most what `S` takes of its kids, and every
unit of `w` with `S` has its need met at `x`: what `S` takes of `w`, with the bonus of its units, is
at most what `S` takes of the way after the step. -/
theorem draw_rises [DecidablePred S] {bonus : U → Nat}
    (more : ∀ u, S u → use u + bonus u ≤ lineTake S use (kids u)) {x : Nat} :
    ∀ {w : List U}, (∀ u, u ∈ w → S u → need u ≤ x) →
      lineTake S use w + total w (fun u => if S u then bonus u else 0) ≤
        lineTake S use (after need kids w x)
  | [], _ => Nat.le_refl 0
  | u :: w, met => by
    have head : (if S u then use u else 0) + (if S u then bonus u else 0) ≤
        lineTake S use (cond (decide (need u ≤ x)) (kids u) []) :=
      (Decidable.em (S u)).elim
        (fun h => by
          rw [if_pos h, if_pos h, decide_eq_true (met u (.head w) h)]
          exact more u h)
        (fun h => by
          rw [if_neg h, if_neg h]
          exact Nat.zero_le _)
    show (if S u then use u else 0) + lineTake S use w +
        ((if S u then bonus u else 0) + total w fun v => if S v then bonus v else 0) ≤
      lineTake S use (cond (decide (need u ≤ x)) (kids u) [] ++ after need kids w x)
    rw [Nat.add_add_add_comm, lineTake_append]
    exact Nat.add_le_add head (draw_rises more fun v m => met v (.tail u m))

/-- **Rise.** For any decidable `S` (no closure is asked) each of whose units has kids with `S` that
together take more than it (`grows : ∀ u, S u → use u < lineTake S use (kids u)`): if every unit of
`w` with `S` has its need met at `x`, what `S` takes of the way after the step is at least what it
takes of `w` plus the number of units of `w` with `S`. One step, any level; by `draw_rises` with a
bonus of one. -/
theorem rise [DecidablePred S] (grows : ∀ u, S u → use u < lineTake S use (kids u)) {x : Nat} {w : List U}
    (met : ∀ u, u ∈ w → S u → need u ≤ x) :
    lineTake S use w + lineCount S w ≤ lineTake S use (after need kids w x) :=
  draw_rises (bonus := fun _ => 1) (fun u h => Nat.succ_le_of_lt (grows u h)) met

/-- With the kids with `S` together taking at least what the unit takes (`keeps`), and every unit of
`w` with `S` met at `x`, what `S` takes does not fall at the step. By `draw_rises` with a bonus of
nothing. -/
theorem draw_holds [DecidablePred S] (keeps : ∀ u, S u → use u ≤ lineTake S use (kids u)) {x : Nat} {w : List U}
    (met : ∀ u, u ∈ w → S u → need u ≤ x) :
    lineTake S use w ≤ lineTake S use (after need kids w x) :=
  Nat.le_trans (Nat.le_add_right _ _)
    (draw_rises (bonus := fun _ => 0) (fun u h => keeps u h) met)

/-- A unit with `S` in the way after a step is a kid of a unit with `S` whose need was met. Premise:
`S` is a line, that is, no unit outside it leaves a unit of it (`closed`). -/
theorem line_from_line (closed : ∀ u v, v ∈ kids u → S v → S u) {w : List U} {x : Nat} {v : U}
    (mv : v ∈ after need kids w x) (sv : S v) : ∃ u, u ∈ w ∧ need u ≤ x ∧ S u ∧ v ∈ kids u :=
  match (mem_after_iff (need := need) (kids := kids)).mp mv with
  | ⟨u, mu, le, mk⟩ => ⟨u, mu, le, closed u v mk sv, mk⟩

/-- Where no unit of the line has its need met at `x`, no unit of the line is in the way after the
step. Premise: `closed`. -/
theorem none_after (closed : ∀ u v, v ∈ kids u → S v → S u) {w : List U} {x : Nat}
    (nm : ∀ u, u ∈ w → S u → x < need u) : ∀ v, v ∈ after need kids w x → ¬ S v :=
  fun _ mv sv => match line_from_line closed mv sv with
  | ⟨u, mu, le, su, _⟩ => Nat.not_le_of_gt (nm u mu su) le

/-- **A line with no unit in the start way never has one.** With `closed`, under any giving and use:
`SelectionTerm.Generations.kept_of_descent` for the units not of the line, through `family_eq`. -/
theorem never_in (closed : ∀ u v, v ∈ kids u → S v → S u) {giving : Nat → Nat}
    {s : List U × Nat} (none : ∀ u, u ∈ s.1 → ¬ S u) :
    ∀ j u, u ∈ (course need kids giving use s j).1 → ¬ S u :=
  fun j u m => SelectionTerm.Generations.kept_of_descent (G := generations need kids giving use s)
    (Q := fun u => ¬ S u) (fun _ p k _ mk np sk => np (closed p k (mem_cond mk).2 sk)) none j u
    (Eq.subst (motive := fun l => u ∈ l) (family_eq s j).symm m)

/-- **What is gone from the line does not come back.** With `closed`, under any giving and use: if no
unit of the line is in the way at step `k`, none is at any later step. `never_in` from the course at
step `k` (`Law.orbit_add`). -/
theorem gone_from (closed : ∀ u v, v ∈ kids u → S v → S u) {giving : Nat → Nat}
    {s : List U × Nat} {k : Nat}
    (gone : ∀ u, u ∈ (course need kids giving use s k).1 → ¬ S u) :
    ∀ j, k ≤ j → ∀ u, u ∈ (course need kids giving use s j).1 → ¬ S u :=
  fun _ le => match le_dest le with
  | ⟨i, e⟩ => Eq.subst (motive := fun j => ∀ u, u ∈ (course need kids giving use s j).1 → ¬ S u)
      e.symm fun u m => never_in closed gone i u
        (Eq.subst (motive := fun c : List U × Nat => u ∈ c.1) (Law.orbit_add _ s k i) m)

/-- Where no unit of the line has its need met at step `k`, no unit of the line is in the way at any
step after `k`. With `closed`. -/
theorem gone_after (closed : ∀ u v, v ∈ kids u → S v → S u) {giving : Nat → Nat}
    {s : List U × Nat} {k : Nat}
    (nm : ∀ u, u ∈ (course need kids giving use s k).1 → S u →
      (course need kids giving use s k).2 < need u) :
    ∀ j, k + 1 ≤ j → ∀ u, u ∈ (course need kids giving use s j).1 → ¬ S u :=
  gone_from closed (k := k + 1) (none_after closed nm)

end Line

/-! ## 6. The level under a draw -/

/-- A step under a draw at least the level leaves nothing, with nothing given from nothing. -/
theorem step_zero {giving : Nat → Nat} {H x : Nat} (nothing : RegimeMargin.FromNothing giving)
    (le : x ≤ H) : RegimeMargin.step giving H x = 0 := by
  show x - H + giving (x - H) = 0
  rw [sub_eq_zero_of_le le]
  exact (Nat.zero_add _).trans nothing

/-- A step under a draw `H` of which every giving falls short (`short : ∀ z, giving z < T`,
`T ≤ H`) leaves less than the level, or what is given at nothing. No `FromNothing` is asked. -/
theorem step_overdrawn {giving : Nat → Nat} {T H x : Nat} (short : ∀ z, giving z < T) (le : T ≤ H) :
    RegimeMargin.step giving H x < x ∨ RegimeMargin.step giving H x = giving 0 :=
  (Nat.lt_or_ge x H).elim
    (fun lt => .inr (by
      show x - H + giving (x - H) = giving 0
      rw [sub_eq_zero_of_le (Nat.le_of_lt lt)]
      exact Nat.zero_add _))
    (fun ge => .inl (Nat.lt_of_lt_of_le
      (Nat.add_lt_add_left (Nat.lt_of_lt_of_le (short (x - H)) le) (x - H))
      (Nat.le_of_eq (Naturals.sub_add_cancel ge))))

/-- **Below `H + y`, a step lowers the level or leaves nothing.** With giving short of `H` below `y`
(`short`), nothing given from nothing (`nothing`), a draw `D` at least `H` (`more`) and a level `z`
below `H + y` (`below`): the step under `D` leaves nothing, or less than `z`. `TurningInTime.held_above`
contraposed; `WayOfUnits.step_falls` is this. -/
theorem step_lowers {giving : Nat → Nat} {H y D z : Nat} (short : RegimeMargin.Short giving H y)
    (nothing : RegimeMargin.FromNothing giving) (more : H ≤ D) (below : z < H + y) :
    RegimeMargin.step giving D z = 0 ∨ RegimeMargin.step giving D z < z :=
  (Nat.lt_or_ge (RegimeMargin.step giving D z) z).elim .inr fun ge => match z, below, ge with
    | 0, _, _ => .inl (step_zero nothing (Nat.zero_le D))
    | _ + 1, below, ge => absurd (TurningInTime.held_above nothing short more (Nat.succ_pos _) ge)
        (Nat.not_le_of_gt below)

/-! ## 7. Fall -/

section Fall

variable {need : U → Nat} {kids : U → List U} {use : U → Nat} {giving : Nat → Nat}
  {S : U → Prop}

/-- Where the level at step `k` is below the one need `m` of the line, no unit of the line is in the
way after step `k`. With `closed` and `one`. -/
theorem fall_low (closed : ∀ u v, v ∈ kids u → S v → S u) {m : Nat} (one : ∀ u, S u → need u = m)
    {s : List U × Nat} {k : Nat} (lt : (course need kids giving use s k).2 < m) :
    ∃ n, ∀ j, n ≤ j → ∀ u, u ∈ (course need kids giving use s j).1 → ¬ S u :=
  ⟨k + 1, gone_after closed fun u _ su => Nat.lt_of_lt_of_le lt (Nat.le_of_eq (one u su).symm)⟩

theorem fall_from [DecidablePred S] (closed : ∀ u v, v ∈ kids u → S v → S u) {m : Nat}
    (one : ∀ u, S u → need u = m)
    (keeps : ∀ u, S u → use u ≤ lineTake S use (kids u)) (low : giving 0 < m)
    (s : List U × Nat) :
    ∀ f k, (course need kids giving use s k).2 ≤ f →
      (∀ z, giving z < lineTake S use (course need kids giving use s k).1) →
      ∃ n, ∀ j, n ≤ j → ∀ u, u ∈ (course need kids giving use s j).1 → ¬ S u
  | f, k, bound, over =>
    (Nat.lt_or_ge (course need kids giving use s k).2 m).elim (fall_low closed one) fun ge =>
      have met : ∀ u, u ∈ (course need kids giving use s k).1 → S u →
          need u ≤ (course need kids giving use s k).2 :=
        fun u _ su => Nat.le_trans (Nat.le_of_eq (one u su)) ge
      have hold := draw_holds (need := need) keeps met
      have over' : ∀ z, giving z < lineTake S use (course need kids giving use s (k + 1)).1 :=
        fun z => Nat.lt_of_lt_of_le (over z) hold
      (step_overdrawn over (lineTake_le_taken _)).elim
        (fun fell => (Nat.lt_or_ge (course need kids giving use s (k + 1)).2 m).elim
          (fall_low closed one)
          (fun _ => match f, bound with
            | 0, bound => absurd (Nat.lt_of_lt_of_le fell bound) (Nat.not_lt_zero _)
            | f + 1, bound => fall_from closed one keeps low s f (k + 1)
                (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le fell bound)) over'))
        (fun given => fall_low closed one (k := k + 1)
          (Nat.lt_of_le_of_lt (Nat.le_of_eq given) low))

/-- **Fall.** For a line `S` (`closed`) of one need `m` (`one : ∀ u, S u → need u = m`), whose
units' kids of the line together take at least what the unit took (`keeps`), with `giving 0 < m`
(`low`): from a configuration `(w, x)` at which what `S` takes of `w` is more than `giving z` at
every `z` (`over`, given, not derived), there is a step from which no unit of the line is in the
way. While the level meets `m` the line is met, what it takes does not fall (`draw_holds`) and the
level falls or goes to `giving 0` (`step_overdrawn`); below `m` the line leaves nothing
(`gone_after`). -/
theorem fall [DecidablePred S] (closed : ∀ u v, v ∈ kids u → S v → S u) {m : Nat}
    (one : ∀ u, S u → need u = m)
    (keeps : ∀ u, S u → use u ≤ lineTake S use (kids u)) (low : giving 0 < m)
    {w : List U} {x : Nat} (over : ∀ z, giving z < lineTake S use w) :
    ∃ n, ∀ k, n ≤ k → ∀ u, u ∈ (course need kids giving use (w, x) k).1 → ¬ S u :=
  fall_from closed one keeps low (w, x) x 0 (Nat.le_refl x) over

end Fall

/-! ## 8. A line that grows ends -/

section Grows

variable {need : U → Nat} {kids : U → List U} {use : U → Nat} {giving : Nat → Nat}
  {S : U → Prop} {hi : Nat}

/-- Every unit with `S` in `w` needs at most `m`. -/
def Below (need : U → Nat) (S : U → Prop) (m : Nat) (w : List U) : Prop :=
  ∀ u, u ∈ w → S u → need u ≤ m

/-- No unit with `S` has its need met at the configuration. -/
def NoneMet (need : U → Nat) (S : U → Prop) (s : List U × Nat) : Prop :=
  ∀ u, u ∈ s.1 → S u → s.2 < need u

/-- With `closed` and `down`, every unit of the line in the way after a step at `x` needs at most
`x`. -/
theorem below_after (closed : ∀ u v, v ∈ kids u → S v → S u)
    (down : ∀ u v, S u → v ∈ kids u → need v ≤ need u) (w : List U) (x : Nat) :
    Below need S x (after need kids w x) :=
  fun _ mv sv => match line_from_line closed mv sv with
  | ⟨u, _, le, su, mk⟩ => Nat.le_trans (down u _ su mk) le

/-- With `closed` and `down`, a way whose line needs at most `m` leaves one that does. -/
theorem below_keeps (closed : ∀ u v, v ∈ kids u → S v → S u)
    (down : ∀ u v, S u → v ∈ kids u → need v ≤ need u) {m : Nat} {w : List U}
    (below : Below need S m w) (x : Nat) : Below need S m (after need kids w x) :=
  fun _ mv sv => match line_from_line closed mv sv with
  | ⟨u, mu, _, su, mk⟩ => Nat.le_trans (down u _ su mk) (below u mu su)

/-- The claim at `m`: from every configuration at most `hi` whose line needs at most `m`, some step
has no unit of the line met. -/
def Ends (need : U → Nat) (kids : U → List U) (giving : Nat → Nat) (use : U → Nat) (S : U → Prop)
    (hi m : Nat) : Prop :=
  ∀ s : List U × Nat, s.2 ≤ hi → Below need S m s.1 →
    ∃ k, NoneMet need S (course need kids giving use s k)

/-- One step and the rest: a step `j` of the course from the next configuration is step `1 + j` of
the course from `s`. -/
theorem none_shift {s : List U × Nat} {j : Nat}
    (nm : NoneMet need S (course need kids giving use (step need kids giving use s) j)) :
    ∃ k, NoneMet need S (course need kids giving use s k) :=
  ⟨1 + j, Eq.subst (motive := NoneMet need S) (Law.orbit_add _ s 1 j).symm nm⟩

theorem ends_low (keeps : RegimeMargin.Keeps giving 0 hi) (closed : ∀ u v, v ∈ kids u → S v → S u)
    (down : ∀ u v, S u → v ∈ kids u → need v ≤ need u) {m : Nat}
    (ih : ∀ m', m' < m → Ends need kids giving use S hi m')
    (s : List U × Nat) (high : s.2 ≤ hi) (lt : s.2 < m) :
    ∃ k, NoneMet need S (course need kids giving use s k) :=
  match ih s.2 lt (step need kids giving use s) (TurningInTime.kept_within keeps _ high)
      (below_after closed down s.1 s.2) with
  | ⟨_, nm⟩ => none_shift nm

/-- The step of `ends_all`'s induction at a level at or above `m`. With `nothing`, `keeps`, a line
`S` (`closed`) each of whose units has kids of the line that together take more than it (`grows`),
whose units need something (`needs`) and whose kids need no more than their parent (`down`), and the
claim `Ends` at every `m' < m` (`ih`): from every configuration `s` at most `hi` whose line needs at
most `m`, at a level at least `m`, with `hi + 1` at most what the line takes of `s.1` plus `k`, some
step has no unit of the line met. While the level stays at or above `m` the line is met and what it
takes rises by at least one at each step (`rise`), and it is at most the level, so at most `hi`,
else the step leaves nothing, below a positive need; so within `k` steps no unit of the line is left
or the level falls below `m`, where `ih` applies (`ends_low`). This is the arithmetic of
`TurningInTime.rising_takes_all` (a take that rises against a capped level) for a line among other
units, argued again here, not derived from it; of the laws here only `need_unmet` and those derived
from it (`falls_to_unmet`, `one_need_ends`) rest on `TurningInTime.rising_takes_all`. -/
theorem ends_high [DecidablePred S] (nothing : RegimeMargin.FromNothing giving)
    (keeps : RegimeMargin.Keeps giving 0 hi) (closed : ∀ u v, v ∈ kids u → S v → S u)
    (grows : ∀ u, S u → use u < lineTake S use (kids u)) (needs : ∀ u, S u → 0 < need u)
    (down : ∀ u v, S u → v ∈ kids u → need v ≤ need u) {m : Nat}
    (ih : ∀ m', m' < m → Ends need kids giving use S hi m') :
    ∀ k (s : List U × Nat), s.2 ≤ hi → Below need S m s.1 → m ≤ s.2 →
      hi + 1 ≤ lineTake S use s.1 + k → ∃ j, NoneMet need S (course need kids giving use s j)
  | k, s, high, below, ge, fuel =>
    (line_or_none (S := S) s.1).elim
      (fun nm => ⟨0, fun u mu su => absurd su (nm u mu)⟩)
      (fun ⟨u₀, mu₀, su₀⟩ =>
        have met : ∀ u, u ∈ s.1 → S u → need u ≤ s.2 := fun u mu su =>
          Nat.le_trans (below u mu su) ge
        have up : lineTake S use s.1 + 1 ≤ lineTake S use (after need kids s.1 s.2) :=
          Nat.le_trans (Nat.add_le_add_left (lineCount_pos su₀ mu₀) _) (rise grows met)
        have high' : (step need kids giving use s).2 ≤ hi := TurningInTime.kept_within keeps _ high
        have below' : Below need S m (step need kids giving use s).1 :=
          below_keeps closed down below s.2
        (Nat.lt_or_ge (step need kids giving use s).2 m).elim
          (fun lt => match ends_low keeps closed down ih _ high' lt with
            | ⟨_, nm⟩ => none_shift nm)
          (fun ge' =>
            have within : taken use s.1 ≤ s.2 := (Nat.lt_or_ge s.2 (taken use s.1)).elim
              (fun lt =>
                have zero : (step need kids giving use s).2 = 0 := step_zero nothing (Nat.le_of_lt lt)
                absurd (Nat.le_trans (below u₀ mu₀ su₀) (Nat.le_trans ge' (Nat.le_of_eq zero)))
                  (Nat.not_le_of_gt (needs u₀ su₀)))
              id
            have small : lineTake S use s.1 ≤ hi :=
              Nat.le_trans (lineTake_le_taken _) (Nat.le_trans within high)
            match k, fuel with
            | 0, fuel => absurd (Nat.le_trans fuel small) (Nat.not_succ_le_self hi)
            | k + 1, fuel =>
              match ends_high nothing keeps closed grows needs down ih k _ high' below' ge'
                  (Nat.le_trans fuel (Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm _ k 1))
                    (Nat.add_le_add_right up k))) with
              | ⟨_, nm⟩ => none_shift nm))

/-- The claim at every `m`, by strong induction. -/
theorem ends_all [DecidablePred S] (nothing : RegimeMargin.FromNothing giving)
    (keeps : RegimeMargin.Keeps giving 0 hi) (closed : ∀ u v, v ∈ kids u → S v → S u)
    (grows : ∀ u, S u → use u < lineTake S use (kids u)) (needs : ∀ u, S u → 0 < need u)
    (down : ∀ u v, S u → v ∈ kids u → need v ≤ need u) (m : Nat) :
    Ends need kids giving use S hi m :=
  strong_below (P := Ends need kids giving use S hi)
    (fun m ih s high below => (Nat.lt_or_ge s.2 m).elim
      (ends_low keeps closed down ih s high)
      (fun ge => ends_high nothing keeps closed grows needs down ih (hi + 1) s high below ge
        (Nat.le_add_left _ _)))
    (m + 1) m (Nat.lt_succ_self m)

/-- **A line that grows ends.** With nothing given from nothing (`nothing`), the step under no draw
keeping every level up to `hi` within `hi` (`keeps`), the start at most `hi` (`high`), and a line `S`
(`closed`: no unit outside it leaves a unit of it) each of whose units has kids of the line that
together take more than it (`grows`), whose units need something (`needs`), and whose kids need no
more than their parent (`down`): there is a step from which no unit of the line is in the way. No
bound on that step is stated. By `ends_all` at the total of the needs of `w`, and `gone_after`. -/
theorem line_ends [DecidablePred S] (nothing : RegimeMargin.FromNothing giving)
    (keeps : RegimeMargin.Keeps giving 0 hi) (closed : ∀ u v, v ∈ kids u → S v → S u)
    (grows : ∀ u, S u → use u < lineTake S use (kids u)) (needs : ∀ u, S u → 0 < need u)
    (down : ∀ u v, S u → v ∈ kids u → need v ≤ need u) {w : List U} {x : Nat} (high : x ≤ hi) :
    ∃ n, ∀ k, n ≤ k → ∀ u, u ∈ (course need kids giving use (w, x) k).1 → ¬ S u :=
  match ends_all nothing keeps closed grows needs down (total w need) (w, x) high
      (fun _ mu _ => le_total_of_mem mu) with
  | ⟨k, nm⟩ => ⟨k + 1, gone_after closed nm⟩

end Grows

section All

variable {need : U → Nat} {kids : U → List U} {use : U → Nat} {giving : Nat → Nat}

/-- What the line of every unit takes is what the way takes. -/
theorem lineTake_true (w : List U) : lineTake (fun _ => True) use w = taken use w :=
  total_congr (fun _ => rfl) w

/-- **A way whose units grow ends.** With nothing given from nothing, the step under no draw keeping
every level up to `hi` within `hi`, the start at most `hi`, every unit's kids together taking more
than it (`grows`), every need positive (`needs`) and kids needing no more than their parent
(`down`): at some step no unit's need is met, and the net from `(w, x)` ends. `line_ends`' route at
the line of every unit. -/
theorem way_ends {hi : Nat} (nothing : RegimeMargin.FromNothing giving)
    (keeps : RegimeMargin.Keeps giving 0 hi)
    (grows : ∀ u, use u < taken use (kids u)) (needs : ∀ u, 0 < need u)
    (down : ∀ u v, v ∈ kids u → need v ≤ need u) {w : List U} {x : Nat} (high : x ≤ hi) :
    (∃ n, ¬ Goes need (course need kids giving use (w, x) n)) ∧
      ¬ «不穷» (net need kids giving use) «一» (w, x) :=
  match ends_all (S := fun _ => True) nothing keeps (fun _ _ _ _ => trivial)
      (fun u _ => Nat.lt_of_lt_of_le (grows u) (Nat.le_of_eq (lineTake_true _).symm))
      (fun u _ => needs u) (fun u v _ mk => down u v mk) (total w need) (w, x) high
      (fun _ mu _ => le_total_of_mem mu) with
  | ⟨k, nm⟩ =>
    have stop : ¬ Goes need (course need kids giving use (w, x) k) := fun ⟨u, mu, le⟩ =>
      Nat.not_le_of_gt (nm u mu trivial) le
    ⟨⟨k, stop⟩, fun never => stop (Law.stepWhile_unending_iff.mp never k)⟩

/-- Where every unit's kids together take more than it (`grows`), every unit has kids. -/
theorem kids_of_grows (grows : ∀ u, use u < taken use (kids u)) : ∀ u, kids u ≠ [] :=
  fun u e => Nat.not_lt_zero _ (Eq.subst (motive := fun l => use u < taken use l) e (grows u))

/-- **While every need is met, the course is the course as it was under `allKids`.** Under any `need`,
`kids`, giving and use, from any start: where at every step before `n` every unit's need is met, the
course at step `n` is the orbit of `TurningInTime.asItWas (allKids kids)` under the same level step.
By `after_of_met`, step by step. -/
theorem course_asItWas {s : List U × Nat} :
    ∀ n, (∀ j, j < n → ∀ u, u ∈ (course need kids giving use s j).1 →
        need u ≤ (course need kids giving use s j).2) →
      course need kids giving use s n = Law.orbit (TurningInTime.asItWas (allKids kids)
        (fun w x => RegimeMargin.step giving (taken use w) x)) s n
  | 0, _ => rfl
  | n + 1, met =>
    (congrArg (fun z => (z, left giving use (course need kids giving use s n).1
        (course need kids giving use s n).2)) (after_of_met (met n (Nat.lt_succ_self n)))).trans
      (congrArg (TurningInTime.asItWas (allKids kids) (fun w x => RegimeMargin.step giving (taken use w) x))
        (course_asItWas n fun j lt => met j (Nat.lt_succ_of_lt lt)))

/-- While every need is met, the way at step `n` is the `n`-th generation: `course_asItWas` with
`TurningInTime.asItWas_way`. -/
theorem way_while_met {w : List U} {x n : Nat}
    (met : ∀ j, j < n → ∀ u, u ∈ (course need kids giving use (w, x) j).1 →
      need u ≤ (course need kids giving use (w, x) j).2) :
    (course need kids giving use (w, x) n).1 = generation kids n w :=
  (congrArg Prod.fst (course_asItWas n met)).trans
    ((TurningInTime.asItWas_way _ _ (w, x) n).trans (generation_orbit w n).symm)

/-- Where every unit's kids together take more than it (`grows`), all the kids of a way take at
least what the way takes and its length: `rise` at the line of every unit, with every need met (at
need nothing), where the way after the step is all the kids (`after_of_met`). -/
theorem allKids_rises (grows : ∀ u, use u < taken use (kids u)) (w : List U) :
    taken use w + w.length ≤ taken use (allKids kids w) :=
  Eq.subst (motive := fun l => taken use w + w.length ≤ taken use l)
    (after_of_met (need := fun _ => 0) (x := 0) fun _ _ => Nat.le_refl 0)
    (Eq.subst (motive := fun c => taken use w + c ≤ taken use (after (fun _ => 0) kids w 0))
      (total_ones w) (rise (need := fun _ => 0) (kids := kids) (use := use) (S := fun _ => True) (x := 0)
        (w := w) (fun u _ => grows u) fun _ _ _ => Nat.le_refl 0))

/-- With `grows`, along the generations of a way that is not empty what the way takes rises at every
step: `allKids_rises`, each generation having a member (`generation_mem`). -/
theorem generations_rise (grows : ∀ u, use u < taken use (kids u)) {w : List U} (ne : w ≠ []) :
    ∀ j, taken use (Law.orbit (allKids kids) w j) < taken use (Law.orbit (allKids kids) w (j + 1)) :=
  fun j => match mem_of_ne_nil ne with
  | ⟨_, mv⟩ => match generation_mem (kids_of_grows grows) mv j with
    | ⟨u, mu⟩ => Nat.lt_of_lt_of_le (Nat.lt_succ_self _)
        (Nat.le_trans (Nat.add_le_add_left (length_pos_of_mem
            (Eq.subst (motive := fun l => u ∈ l) (generation_orbit w j) mu)) _)
          (allKids_rises grows _))

/-- **A need comes to be unmet, the way unchanged by the stock until then.** With nothing given from
nothing (`nothing`), the step under no draw keeping every level up to `hi` within `hi` (`keeps`), every
unit's kids together taking more than it (`grows`, asked of every unit of the type), every unit of
every generation of `w` needing something (`needs`, asked only of the descendants of `w`), the start
at most `hi` (`high`), a way that is not empty (`ne`) and every need met at the start (`met`): there
is a step `n` with `0 < n ≤ hi + 1` at which some unit of the way has its need unmet, every need met
at every step before it, and up to it the way at step `j` is the `j`-th generation of `w`
(`way_while_met`).
Were every need met up to `hi + 1`, the course would be the course as it was under `allKids`
(`course_asItWas`), what it takes rising at each step (`generations_rise`), and its level at `hi + 1`
nothing (`TurningInTime.rising_takes_all`), while a unit there needs something. Kids needing no more
than their parent (`down`) is not asked, and without it the unmet need may be a kid's greater need at
a level that has not fallen: on `KidHigherNeed` every premise holds at `hi = 12`, and the configuration
after the first step is `([B, B], 12)`, its level the start's, below `B`'s need thirteen. With `down` the level
has fallen below a need the start met (`falls_to_unmet`). `ends_high` rests on the same arithmetic, a
take that rises against a capped level, for a line among other units, argued again there; of the laws
here only `need_unmet` and those derived from it (`falls_to_unmet`, `one_need_ends`) rest on
`TurningInTime.rising_takes_all`. -/
theorem need_unmet {hi : Nat} (nothing : RegimeMargin.FromNothing giving)
    (keeps : RegimeMargin.Keeps giving 0 hi) (grows : ∀ u, use u < taken use (kids u))
    {w : List U} {x : Nat} (needs : Needing need kids w) (high : x ≤ hi) (ne : w ≠ [])
    (met : ∀ u, u ∈ w → need u ≤ x) :
    ∃ n, 0 < n ∧ n ≤ hi + 1 ∧
      (∀ j, j < n → ∀ u, u ∈ (course need kids giving use (w, x) j).1 →
        need u ≤ (course need kids giving use (w, x) j).2) ∧
      (∀ j, j ≤ n → (course need kids giving use (w, x) j).1 = generation kids j w) ∧
      ∃ u, u ∈ (course need kids giving use (w, x) n).1 ∧ (course need kids giving use (w, x) n).2 < need u :=
  match first_of_decided
      (P := fun j => ∀ u, u ∈ (course need kids giving use (w, x) j).1 →
        need u ≤ (course need kids giving use (w, x) j).2)
      (Q := fun j => ∃ u, u ∈ (course need kids giving use (w, x) j).1 ∧
        (course need kids giving use (w, x) j).2 < need u)
      (fun _ => met_or_unmet need _ _) (hi + 1) with
  | .inl all =>
    have before : ∀ j, j < hi + 1 → ∀ u, u ∈ (course need kids giving use (w, x) j).1 →
        need u ≤ (course need kids giving use (w, x) j).2 := fun j lt => all j (Nat.le_of_lt lt)
    have zero : (course need kids giving use (w, x) (hi + 1)).2 = 0 :=
      (congrArg Prod.snd (course_asItWas (hi + 1) before)).trans
        (TurningInTime.rising_takes_all nothing keeps high fun j _ => generations_rise grows ne j)
    match mem_of_ne_nil ne with
    | ⟨_, mv⟩ => match generation_mem (kids_of_grows grows) mv (hi + 1) with
      | ⟨u, mu⟩ => absurd (Nat.le_trans (all (hi + 1) (Nat.le_refl _) u
            (Eq.subst (motive := fun l => u ∈ l) (way_while_met before).symm mu)) (Nat.le_of_eq zero))
          (Nat.not_le_of_gt (needs (hi + 1) u mu))
  | .inr ⟨n, le, unmet, before⟩ => match n, le, unmet, before with
    | 0, _, ⟨u, mu, lt⟩, _ => absurd (met u mu) (Nat.not_le_of_gt lt)
    | n + 1, le, unmet, before => ⟨n + 1, Nat.succ_pos n, le, before,
        fun _ lj => way_while_met fun i li => before i (Nat.lt_of_lt_of_le li lj), unmet⟩

/-- **A way each of whose units has kids that together take more than it, kids needing no more than
their parent, comes within `hi + 1` steps to a level below a need the start met.** The premises are
`need_unmet`'s (`nothing`, `keeps`, `grows` asked of every unit of the type, `needs` asked only of
the descendants of `w`, `high`, `ne`, `met`), with kids needing no more than their parent (`down`).
There is a step `n` with
`0 < n ≤ hi + 1` such that every need is met at every step before `n`; up to `n` the way at step `j`
is `generation kids j w`, in which no giving, use or level appears: it is the way of every course from
`w` on which every need is met until then (`way_while_met`), and what it takes rises at each of those
steps (by `generations_rise` read through that conjunct; not itself a conjunct); some unit of the way
at `n` has its need unmet; some unit of `w`, whose need the start met, needs more than the level at
`n`; and the level at `n` is below the start level `x`. By `need_unmet`, and `generation_ancestor`
for the unit of `w` whose need is at least the unmet one. This is the model's form of a going-on that
draws down what it rests on while nothing in it yet differs (a reading). Given, not derived: the
needs, uses and offspring, with every descendant of `w` needing something (`needs`); a giving that
gives nothing from nothing (`nothing`); that each unit's kids together take more than it (`grows`);
the cap (`keeps`, `high`); a start that is not empty with every need met (`ne`, `met`); `down`. -/
theorem falls_to_unmet {hi : Nat} (nothing : RegimeMargin.FromNothing giving)
    (keeps : RegimeMargin.Keeps giving 0 hi) (grows : ∀ u, use u < taken use (kids u))
    (down : ∀ u v, v ∈ kids u → need v ≤ need u)
    {w : List U} {x : Nat} (needs : Needing need kids w) (high : x ≤ hi) (ne : w ≠ [])
    (met : ∀ u, u ∈ w → need u ≤ x) :
    ∃ n, 0 < n ∧ n ≤ hi + 1 ∧
      (∀ j, j < n → ∀ u, u ∈ (course need kids giving use (w, x) j).1 →
        need u ≤ (course need kids giving use (w, x) j).2) ∧
      (∀ j, j ≤ n → (course need kids giving use (w, x) j).1 = generation kids j w) ∧
      (∃ u, u ∈ (course need kids giving use (w, x) n).1 ∧
        (course need kids giving use (w, x) n).2 < need u) ∧
      (∃ p, p ∈ w ∧ need p ≤ x ∧ (course need kids giving use (w, x) n).2 < need p) ∧
      (course need kids giving use (w, x) n).2 < x :=
  match need_unmet nothing keeps grows needs high ne met with
  | ⟨n, pos, le, before, ways, u, mu, lt⟩ =>
    match generation_ancestor down n u
        (Eq.subst (motive := fun l => u ∈ l) (ways n (Nat.le_refl n)) mu) with
    | ⟨p, mp, lp⟩ =>
      have below := Nat.lt_of_lt_of_le lt lp
      ⟨n, pos, le, before, ways, ⟨u, mu, lt⟩, ⟨p, mp, met p mp, below⟩,
        Nat.lt_of_lt_of_le below (met p mp)⟩

/-! ## 9. In a world of one need -/

/-- **A way that grows, in a world of one need, ends within `hi + 1` steps.** With every unit needing
`n` (`one`), `0 < n` (`pos`), every unit's kids together taking more than it (`grows`), nothing
given from nothing (`nothing`), the step under no draw keeping every level up to `hi` within `hi`
(`keeps`) and the start at most `hi` (`high`): within `hi + 1` steps the net from `(w, x)` reaches a
configuration that conditions nothing, its way the generation of `w` at that step. Where no need is
met at the start (the way empty, or `x` below `n`) that is step 0; otherwise every need is met
there, and by `need_unmet` the first step with an unmet need, at which with one need none is met. So
it rests on `TurningInTime.rising_takes_all`, the one law on which a lock whose share is a number of
drawers also ends (`TurningInTime.locked_ends_rising` through `ends_with_net_rising`, with
`TurningInTime.count_rises`). With needs that differ, `way_ends` (no bound on the step) holds
instead where every need is positive (`needs`) and kids need no more than their parent (`down`); it
asks both. Without `down` the net can go on with every other premise of `way_ends` holding
(`KidsNeedMore.all_but_down`). -/
theorem one_need_ends {hi n : Nat} (one : ∀ u, need u = n) (pos : 0 < n)
    (grows : ∀ u, use u < taken use (kids u)) (nothing : RegimeMargin.FromNothing giving)
    (keeps : RegimeMargin.Keeps giving 0 hi) {w : List U} {x : Nat} (high : x ≤ hi) :
    ∃ m t, m ≤ hi + 1 ∧ «迭» (net need kids giving use) m (w, x) t ∧
      (∀ v, ¬ net need kids giving use t v) ∧ t.1 = generation kids m w :=
  if go : Goes need (w, x) then (match go with
    | ⟨v, mv, le⟩ =>
      match need_unmet nothing keeps grows (fun _ u _ => Nat.lt_of_lt_of_le pos (Nat.le_of_eq (one u).symm))
          high (fun e => nomatch (Eq.subst (motive := fun l => v ∈ l) e mv))
          (fun u _ => Nat.le_trans (Nat.le_of_eq ((one u).trans (one v).symm)) le) with
      | ⟨m, _, le, before, ways, u, _, lt⟩ =>
        ⟨m, course need kids giving use (w, x) m, le, (Law.stepWhile_steps_iff m).mpr
          ⟨fun j lj => match generation_mem (kids_of_grows grows) mv j with
            | ⟨c, mc⟩ =>
              have mc' := Eq.subst (motive := fun l => c ∈ l) (ways j (Nat.le_of_lt lj)).symm mc
              ⟨c, mc', before j lj c mc'⟩, rfl⟩,
         Law.stepWhile_none_iff.mpr fun ⟨c, _, lc⟩ =>
          Nat.not_le_of_gt lt (Nat.le_trans (Nat.le_of_eq ((one u).trans (one c).symm)) lc),
         ways m (Nat.le_refl m)⟩)
  else ⟨0, (w, x), Nat.zero_le _, (Law.stepWhile_steps_iff 0).mpr
      ⟨fun _ lt => absurd lt (Nat.not_lt_zero _), rfl⟩, Law.stepWhile_none_iff.mpr go, rfl⟩

end All

/-! ## 10. The middle case: each unit's kids together take what it takes -/

section Even

variable {need : U → Nat} {kids : U → List U} {use : U → Nat} {giving : Nat → Nat}

/-- Where each unit's kids together take what it takes (`even`), all the kids of a way take what the
way takes: `SelectionTerm.Generations.total_flatMap` with `allKids_flatMap`. -/
theorem taken_allKids (even : ∀ u, taken use (kids u) = use u) (w : List U) :
    taken use (allKids kids w) = taken use w :=
  (congrArg (taken use) (allKids_flatMap w)).trans
    ((SelectionTerm.Generations.total_flatMap kids use w).trans (total_congr even w))

/-- With `even`, every generation of a way takes what the way takes. -/
theorem taken_generation (even : ∀ u, taken use (kids u) = use u) (w : List U) :
    ∀ n, taken use (generation kids n w) = taken use w
  | 0 => rfl
  | n + 1 => (taken_allKids even _).trans (taken_generation even w n)

/-- With `even`, while every unit of the `j`-th generation of `S` has its need met along the level's
course under what `S` takes, the course from `(S, z)` is the generation with that level. Under any
giving. `WayOfUnits.fixed_while` is its case `kids u = [u]`. -/
theorem course_generation (even : ∀ u, taken use (kids u) = use u) {S : List U} {z : Nat} :
    ∀ i, (∀ j, j < i → ∀ u, u ∈ generation kids j S →
        need u ≤ Law.orbit (RegimeMargin.step giving (taken use S)) z j) →
      course need kids giving use (S, z) i =
        (generation kids i S, Law.orbit (RegimeMargin.step giving (taken use S)) z i)
  | 0, _ => rfl
  | i + 1, met =>
    (congrArg (step need kids giving use)
        (course_generation even i fun j lt => met j (Nat.lt_succ_of_lt lt))).trans
      (congr (congrArg Prod.mk (after_of_met (need := need) (kids := kids) (met i (Nat.lt_succ_self i))))
        (congrArg (fun t => RegimeMargin.step giving t (Law.orbit (RegimeMargin.step giving (taken use S)) z i))
          (taken_generation even S i)))

/-- From a start at most `hi`, where `Regime` holds at every way the course reaches with some need met
there and at every step before (only its `Keeps` is used): every level the course reaches with some
need met at every step before is at most `hi`. -/
theorem within_along {y : Nat → Nat} {hi : Nat} {s : List U × Nat}
    (along : ∀ k, (∀ j, j ≤ k → Goes need (course need kids giving use s j)) →
      Regime giving use y hi (course need kids giving use s k).1)
    (high : s.2 ≤ hi) :
    ∀ k, (∀ j, j < k → Goes need (course need kids giving use s j)) →
      (course need kids giving use s k).2 ≤ hi
  | 0, _ => high
  | k + 1, before =>
    (along k fun j le => before j (Nat.lt_succ_of_le le)).2.2 (course need kids giving use s k).2
      (within_along along high k fun j lt => before j (Nat.lt_succ_of_lt lt))

/-- The step of `reaches_holds` at a bound `m` on the needs of the way, given the claim below `m`
(`ih`), by induction on a bound `f` on the level. Below `m`, one step leaves a way whose needs are at
most the level (`below_after`): `ih`. At or above `m` every need is met: the configuration holds, or the
level is below what the way takes and `y` of it, and the step under that draw lowers the level or
leaves nothing (`step_lowers`); nothing meets no need of a descendant (`needs`), and a lower level is
the induction on `f`, the next way's needs still at most `m` (`below_keeps`). -/
theorem reaches_from {y : Nat → Nat} {hi : Nat} {w : List U} {x : Nat}
    (down : ∀ u v, v ∈ kids u → need v ≤ need u) (needs : Needing need kids w)
    (nothing : RegimeMargin.FromNothing giving)
    (along : ∀ k, (∀ j, j ≤ k → Goes need (course need kids giving use (w, x) j)) →
      Regime giving use y hi (course need kids giving use (w, x) k).1)
    (all : ∀ k, Goes need (course need kids giving use (w, x) k)) {m : Nat}
    (ih : ∀ m', m' < m → ∀ f k, (course need kids giving use (w, x) k).2 ≤ f →
      Below need (fun _ => True) m' (course need kids giving use (w, x) k).1 →
      ∃ k', Holds need use y (course need kids giving use (w, x) k')) :
    ∀ f k, (course need kids giving use (w, x) k).2 ≤ f →
      Below need (fun _ => True) m (course need kids giving use (w, x) k).1 →
      ∃ k', Holds need use y (course need kids giving use (w, x) k')
  | f, k, bound, below =>
    (Nat.lt_or_ge (course need kids giving use (w, x) k).2 m).elim
      (fun lt => ih _ lt _ (k + 1) (Nat.le_refl _)
        (below_after (S := fun _ => True) (fun _ _ _ _ => trivial) (fun u v _ mk => down u v mk) _ _))
      (fun ge =>
        (Nat.lt_or_ge (course need kids giving use (w, x) k).2
            (taken use (course need kids giving use (w, x) k).1 +
              y (taken use (course need kids giving use (w, x) k).1))).elim
          (fun under => (step_lowers (along k fun j _ => all j).1 nothing (Nat.le_refl _) under).elim
            (fun zero => match all (k + 1) with
              | ⟨u, mu, le⟩ => absurd (Nat.le_trans le (Nat.le_of_eq zero))
                  (Nat.not_le_of_gt (needs (k + 1) u (mem_generation (w, x) (k + 1) u mu))))
            (fun lower => match f, bound with
              | 0, bound => absurd (Nat.lt_of_lt_of_le lower bound) (Nat.not_lt_zero _)
              | f + 1, bound => reaches_from down needs nothing along all ih f (k + 1)
                  (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lower bound))
                  (below_keeps (S := fun _ => True) (fun _ _ _ _ => trivial)
                    (fun u v _ mk => down u v mk) below _)))
          (fun enough => match all k with
            | ⟨v, mv, _⟩ => ⟨k, And.intro (fun e => nomatch (Eq.subst (motive := fun l => v ∈ l) e mv))
                (And.intro (fun u mu => Nat.le_trans (below u mu trivial) ge) enough)⟩))

/-- **A course on which some need is met at every step comes to a configuration that holds.** With
kids needing no more than their parent (`down`), every unit of every generation of `w` needing
something (`needs`), nothing given from nothing (`nothing`), `Regime` at every way the course reaches
with some need met there and at every step before (`along`; only its `Short` is used), and some need
met at every step (`all`). No premise on what the kids take. By strong induction on a bound on the
way's needs (`strong_below`, `reaches_from`), from the total of the needs of `w`. -/
theorem reaches_holds {y : Nat → Nat} {hi : Nat} {w : List U} {x : Nat}
    (down : ∀ u v, v ∈ kids u → need v ≤ need u) (needs : Needing need kids w)
    (nothing : RegimeMargin.FromNothing giving)
    (along : ∀ k, (∀ j, j ≤ k → Goes need (course need kids giving use (w, x) j)) →
      Regime giving use y hi (course need kids giving use (w, x) k).1)
    (all : ∀ k, Goes need (course need kids giving use (w, x) k)) :
    ∃ k, Holds need use y (course need kids giving use (w, x) k) :=
  strong_below (P := fun m => ∀ f k, (course need kids giving use (w, x) k).2 ≤ f →
      Below need (fun _ => True) m (course need kids giving use (w, x) k).1 →
      ∃ k', Holds need use y (course need kids giving use (w, x) k'))
    (fun _ ih => reaches_from down needs nothing along all ih)
    (total w need + 1) (total w need) (Nat.lt_succ_self _) x 0 (Nat.le_refl x)
    (fun _ mu _ => le_total_of_mem mu)

/-- **The middle case: when the net never ends (exact).** With each unit's kids together taking what
it takes (`even`), every unit having kids (`some`), kids needing no more than their parent (`down`),
every unit of every generation of `w` needing something (`needs`), nothing given from nothing
(`nothing`), the start at most `hi` (`high`), and `Regime` at every way the course reaches with some
need met there and at every step before, the start's included (`along`): the net from `(w, x)` never
ends exactly where, some need met at every step before, the course comes to a configuration that
holds (`Holds`).
Left to right by `reaches_holds` (with `step_lowers`, from `TurningInTime.held_above`; `even`, `some`
and `high` are not used there); right to left, from a holding configuration the way is the
generations, taking the same (`course_generation`), their needs at most the level (`generation_below`),
not empty (`generation_mem`), and the level under that one draw never falls below where it was
(`RegimeMargin.holds`, within `hi` by `within_along`). `WayOfUnits.unending_iff_holds` is the case
`kids u = [u]`. -/
theorem unending_iff_holds {y : Nat → Nat} {hi : Nat} {w : List U} {x : Nat}
    (even : ∀ u, taken use (kids u) = use u) (some : ∀ u, kids u ≠ [])
    (down : ∀ u v, v ∈ kids u → need v ≤ need u) (needs : Needing need kids w)
    (nothing : RegimeMargin.FromNothing giving) (high : x ≤ hi)
    (along : ∀ k, (∀ j, j ≤ k → Goes need (course need kids giving use (w, x) j)) →
      Regime giving use y hi (course need kids giving use (w, x) k).1) :
    «不穷» (net need kids giving use) «一» (w, x) ↔
      ∃ k, (∀ j, j < k → Goes need (course need kids giving use (w, x) j)) ∧
        Holds need use y (course need kids giving use (w, x) k) :=
  Law.stepWhile_unending_iff.trans
    ⟨fun all => match reaches_holds down needs nothing along all with
       | ⟨k, holds⟩ => ⟨k, fun j _ => all j, holds⟩,
     fun ⟨k, before, holds⟩ n => match holds with
      | ⟨ne, met, low⟩ => (Nat.lt_or_ge n k).elim (before n) fun ge =>
        match le_dest ge, mem_of_ne_nil ne with
        | ⟨i, e⟩, ⟨v, mv⟩ =>
          have upto : ∀ j, j ≤ k → Goes need (course need kids giving use (w, x) j) := fun j le =>
            (Nat.lt_or_eq_of_le le).elim (before j) fun e' =>
              Eq.subst (motive := fun i => Goes need (course need kids giving use (w, x) i)) e'.symm
                ⟨v, mv, met v mv⟩
          have held := RegimeMargin.holds (along k upto).2.1 (along k upto).2.2 low
            (within_along along high k before)
          have at_i : course need kids giving use (w, x) (k + i) =
              (generation kids i (course need kids giving use (w, x) k).1,
                Law.orbit (RegimeMargin.step giving (taken use (course need kids giving use (w, x) k).1))
                  (course need kids giving use (w, x) k).2 i) :=
            (Law.orbit_add _ (w, x) k i).trans
              (course_generation (S := (course need kids giving use (w, x) k).1)
                (z := (course need kids giving use (w, x) k).2) even i
                fun j _ u mu => Nat.le_trans (generation_below down met j u mu) (held j).1)
          match generation_mem some mv i with
          | ⟨u, mu⟩ => Eq.subst (motive := fun j => Goes need (course need kids giving use (w, x) j))
              e.symm (Eq.subst (motive := Goes need) at_i.symm
                ⟨u, mu, Nat.le_trans (generation_below down met i u mu) (held i).1⟩)⟩

/-! ## 11. On a course that goes on, what the way takes is less than the level -/

/-- **On a course that goes on, what the way takes is less than the level.** With nothing given from
nothing (`nothing`) and every unit of every generation of the start's way needing something
(`needs`), under any `kids`: where some unit's need is met at step `n + 1`, what the way takes at step
`n` is less than the level there. A draw at or above the level leaves nothing (`step_zero`), which
meets no need. -/
theorem taken_below (nothing : RegimeMargin.FromNothing giving) {s : List U × Nat}
    (needs : Needing need kids s.1) {n : Nat}
    (goes : Goes need (course need kids giving use s (n + 1))) :
    taken use (course need kids giving use s n).1 < (course need kids giving use s n).2 :=
  (Nat.lt_or_ge (taken use (course need kids giving use s n).1)
      (course need kids giving use s n).2).elim id fun ge =>
    match goes with
    | ⟨u, mu, le⟩ => absurd (Nat.le_trans le (Nat.le_of_eq (step_zero nothing ge)))
        (Nat.not_le_of_gt (needs (n + 1) u (mem_generation s (n + 1) u mu)))

/-- Where the net never ends, what the way takes is less than the level at every step. With
`nothing` and `needs`, as `taken_below`. -/
theorem unending_taken_below (nothing : RegimeMargin.FromNothing giving) {s : List U × Nat}
    (needs : Needing need kids s.1) (never : «不穷» (net need kids giving use) «一» s) (n : Nat) :
    taken use (course need kids giving use s n).1 < (course need kids giving use s n).2 :=
  taken_below nothing needs (Law.stepWhile_unending_iff.mp never (n + 1))

/-! ## 11b. The account -/

/-- **The account.** Under any `need`, `kids`, giving and use, from any start: if at every step
`t < N` what the way takes is at most the level, then the level at step `N` with everything the way
took at steps `0` to `N - 1` is the start level with everything given at those steps (`giving` of
what was left). `balance_over_stretch_on` (Prelude) at the stretch from `0`, each step balanced by
`Naturals.sub_add_cancel`. -/
theorem account {s : List U × Nat} (N : Nat)
    (within : ∀ t, t < N →
      taken use (course need kids giving use s t).1 ≤ (course need kids giving use s t).2) :
    (course need kids giving use s N).2 +
        total (steps 0 N) (fun t => taken use (course need kids giving use s t).1) =
      s.2 + total (steps 0 N) (fun t => giving ((course need kids giving use s t).2 -
        taken use (course need kids giving use s t).1)) :=
  Eq.subst (motive := fun m => (course need kids giving use s m).2 +
        total (steps 0 N) (fun t => taken use (course need kids giving use s t).1) =
      s.2 + total (steps 0 N) (fun t => giving ((course need kids giving use s t).2 -
        taken use (course need kids giving use s t).1)))
    (Nat.zero_add N)
    (balance_over_stretch_on (q := fun t => (course need kids giving use s t).2)
      (x := fun t => taken use (course need kids giving use s t).1)
      (y := fun t => giving ((course need kids giving use s t).2 -
        taken use (course need kids giving use s t).1)) 0 N
      fun t _ below =>
        (Nat.add_right_comm ((course need kids giving use s t).2 -
            taken use (course need kids giving use s t).1)
          (giving ((course need kids giving use s t).2 - taken use (course need kids giving use s t).1))
          (taken use (course need kids giving use s t).1)).trans
          (congrArg (· + giving ((course need kids giving use s t).2 -
              taken use (course need kids giving use s t).1))
            (Naturals.sub_add_cancel
              (within t (Nat.lt_of_lt_of_le below (Nat.le_of_eq (Nat.zero_add N)))))))

/-- **The account on a net that never ends.** With nothing given from nothing and every unit of
every generation of the start's way needing something, where the net never ends the account holds for
every `N`: `account` with `unending_taken_below`. -/
theorem account_unending (nothing : RegimeMargin.FromNothing giving) {s : List U × Nat}
    (needs : Needing need kids s.1) (never : «不穷» (net need kids giving use) «一» s) (N : Nat) :
    (course need kids giving use s N).2 +
        total (steps 0 N) (fun t => taken use (course need kids giving use s t).1) =
      s.2 + total (steps 0 N) (fun t => giving ((course need kids giving use s t).2 -
        taken use (course need kids giving use s t).1)) :=
  account N fun t _ => Nat.le_of_lt (unending_taken_below nothing needs never t)

/-! ## 12. Fixed configurations -/

/-- A configuration the step leaves as it is stays so. `WayOfUnits.course_fixed` is its case. -/
theorem course_fixed {s : List U × Nat} (fixed : step need kids giving use s = s) :
    ∀ k, course need kids giving use s k = s :=
  Learnable.orbit_of_still fixed

/-- **A course that comes to a configuration its step leaves as it is, some need met there and at
every step before, never ends.** By `course_fixed` and `Law.orbit_add`. -/
theorem unending_of_fixed {s : List U × Nat} {t : Nat}
    (before : ∀ j, j < t → Goes need (course need kids giving use s j))
    (fixed : step need kids giving use (course need kids giving use s t) =
      course need kids giving use s t)
    (goes : Goes need (course need kids giving use s t)) :
    «不穷» (net need kids giving use) «一» s :=
  Law.stepWhile_unending_iff.mpr fun k => (Nat.lt_or_ge k t).elim (before k) fun ge =>
    match le_dest ge with
    | ⟨i, e⟩ => Eq.subst (motive := fun j => Goes need (course need kids giving use s j)) e.symm
        (Eq.subst (motive := Goes need) ((Law.orbit_add _ s t i).trans (course_fixed fixed i)).symm
          goes)

end Even

/-! ## 12b. Units that take nothing: the levels and the rest of the way -/

/-- The way without its units with `Z`. -/
def strip (Z : U → Prop) [DecidablePred Z] : List U → List U
  | [] => []
  | u :: w => if Z u then strip Z w else u :: strip Z w

section Nothing

variable {need : U → Nat} {kids : U → List U} {use : U → Nat} {giving : Nat → Nat}
  {Z : U → Prop} [DecidablePred Z]

theorem strip_pos {u : U} {w : List U} (h : Z u) : strip Z (u :: w) = strip Z w := if_pos h

theorem strip_neg {u : U} {w : List U} (h : ¬ Z u) : strip Z (u :: w) = u :: strip Z w := if_neg h

theorem strip_append : ∀ a b : List U, strip Z (a ++ b) = strip Z a ++ strip Z b
  | [], _ => rfl
  | u :: a, b => (Decidable.em (Z u)).elim
      (fun h => (strip_pos (w := a ++ b) h).trans
        ((strip_append a b).trans (congrArg (· ++ strip Z b) (strip_pos h).symm)))
      (fun h => (strip_neg (w := a ++ b) h).trans
        ((congrArg (u :: ·) (strip_append a b)).trans
          (congrArg (· ++ strip Z b) (strip_neg h).symm)))

/-- A way of units all with `Z` strips to nothing. -/
theorem strip_all : ∀ {l : List U}, (∀ v, v ∈ l → Z v) → strip Z l = []
  | [], _ => rfl
  | v :: l, all => (strip_pos (all v (.head l))).trans (strip_all fun u m => all u (.tail v m))

theorem strip_strip : ∀ w : List U, strip Z (strip Z w) = strip Z w
  | [] => rfl
  | u :: w => (Decidable.em (Z u)).elim
      (fun h => (congrArg (strip Z) (strip_pos h)).trans ((strip_strip w).trans (strip_pos h).symm))
      (fun h => (congrArg (strip Z) (strip_neg h)).trans ((strip_neg h).trans
        ((congrArg (u :: ·) (strip_strip w)).trans (strip_neg h).symm)))

/-- With units of `Z` taking nothing (`zero`), a way and the way stripped of them take the same. -/
theorem taken_strip (zero : ∀ u, Z u → use u = 0) : ∀ w : List U, taken use (strip Z w) = taken use w
  | [] => rfl
  | u :: w => (Decidable.em (Z u)).elim
      (fun h => (congrArg (taken use) (strip_pos h)).trans ((taken_strip zero w).trans
        ((Nat.zero_add _).symm.trans (congrArg (· + taken use w) (zero u h).symm))))
      (fun h => (congrArg (taken use) (strip_neg h)).trans
        (congrArg (use u + ·) (taken_strip zero w)))

/-- With the kids of units of `Z` all of `Z` (`inZ`), what a way leaves stripped of `Z` is what the
way stripped of `Z` leaves, stripped. -/
theorem strip_after (inZ : ∀ u v, Z u → v ∈ kids u → Z v) (x : Nat) :
    ∀ w : List U, strip Z (after need kids (strip Z w) x) = strip Z (after need kids w x)
  | [] => rfl
  | u :: w => (Decidable.em (Z u)).elim
      (fun h => (congrArg (fun l => strip Z (after need kids l x)) (strip_pos h)).trans
        ((strip_after inZ x w).trans (Eq.symm
          ((strip_append (cond (decide (need u ≤ x)) (kids u) []) (after need kids w x)).trans
            (congrArg (· ++ strip Z (after need kids w x))
              (strip_all fun v mv => inZ u v h (mem_cond mv).2))))))
      (fun h => (congrArg (fun l => strip Z (after need kids l x)) (strip_neg h)).trans
        ((strip_append (cond (decide (need u ≤ x)) (kids u) []) (after need kids (strip Z w) x)).trans
          ((congrArg (strip Z (cond (decide (need u ≤ x)) (kids u) []) ++ ·) (strip_after inZ x w)).trans
            (strip_append (cond (decide (need u ≤ x)) (kids u) []) (after need kids w x)).symm)))

/-- Two courses from configurations at one level whose ways are the same stripped of `Z`: at every
step the levels are the same and the ways are the same stripped of `Z`. With `zero` and `inZ`; by
`taken_strip`, `strip_after` and `left_of_taken`. -/
theorem strip_course (zero : ∀ u, Z u → use u = 0) (inZ : ∀ u v, Z u → v ∈ kids u → Z v)
    {s s' : List U × Nat} (ways : strip Z s.1 = strip Z s'.1) (level : s.2 = s'.2) :
    ∀ n, (course need kids giving use s n).2 = (course need kids giving use s' n).2 ∧
      strip Z (course need kids giving use s n).1 = strip Z (course need kids giving use s' n).1
  | 0 => ⟨level, ways⟩
  | n + 1 => match strip_course zero inZ ways level n with
    | ⟨l, e⟩ =>
      ⟨(left_of_taken (giving := giving) (x := (course need kids giving use s n).2)
          ((taken_strip zero _).symm.trans ((congrArg (taken use) e).trans (taken_strip zero _)))).trans
        (congrArg (left giving use (course need kids giving use s' n).1) l),
       (strip_after inZ _ _).symm.trans
        ((congrArg (fun l' => strip Z (after need kids l' (course need kids giving use s n).2)) e).trans
          ((strip_after inZ _ _).trans
            (congrArg (fun z => strip Z (after need kids (course need kids giving use s' n).1 z)) l)))⟩

/-- **Units that take nothing leave the levels as they are, and the way as it is once they are taken
out.** For a decidable `Z` whose units take nothing (`zero`) and leave only units of `Z` (`inZ`), under
any `need`, `kids` and giving: at every step `n`, the level of the course from `(strip Z w, x)` is the
level of the course from `(w, x)`, and the two ways stripped of `Z` are the same. `strip_course` with
`strip_strip`. Not concluded, and false: that whether the net ends is the same; a unit of `Z` met at
the level keeps the net going (`NothingTakenEnds`). For two units where the first needs no less than
the second, `WayOfUnits.takes_nothing_iff_alone` is the exact form, the ending included. -/
theorem takes_nothing (zero : ∀ u, Z u → use u = 0) (inZ : ∀ u v, Z u → v ∈ kids u → Z v)
    (w : List U) (x : Nat) (n : Nat) :
    (course need kids giving use (strip Z w, x) n).2 = (course need kids giving use (w, x) n).2 ∧
      strip Z (course need kids giving use (strip Z w, x) n).1 =
        strip Z (course need kids giving use (w, x) n).1 :=
  strip_course (need := need) (kids := kids) (giving := giving) (s := (strip Z w, x)) (s' := (w, x))
    zero inZ (strip_strip w) rfl n

end Nothing

/-! ## 13. Kept countermodels and worked courses -/

/-- Giving `min z (10 - z)`. -/
def hump10 (z : Nat) : Nat := min z (10 - z)

/-- Nothing given, at every level. -/
def nothingGiven (_ : Nat) : Nat := 0

namespace KidsNeedMore

/-- Two kinds. -/
inductive Kind
  | A
  | B

open Kind

/-- `A` needs four, `B` nine. -/
def need : Kind → Nat
  | A => 4
  | B => 9

/-- `A` takes two, `B` one. -/
def use : Kind → Nat
  | A => 2
  | B => 1

/-- `A` leaves `B, A, B`; `B` leaves `B, B`. -/
def kids : Kind → List Kind
  | A => [B, A, B]
  | B => [B, B]

/-- From `([B, A, B], 8)` on `hump10` the step leaves the configuration as it is. -/
theorem fixed : step need kids hump10 use ([B, A, B], 8) = ([B, A, B], 8) := rfl

/-- **Kids that need more than their parent: every other premise of `way_ends` holds, and the net
never ends.** On `hump10` with `hi = 10`: nothing is given from nothing, the step under no draw keeps
every level up to ten within ten, every unit's kids together take more than it, every need is
positive and the start `8` is at most ten; `down` fails (`B`, a kid of `A`, needs nine, `A` four).
From `([B, A, B], 8)`: `A` is met and leaves `B, A, B`, both `B` are not met and leave nothing, and
what is taken, four, is given back; the step leaves the configuration as it is (`fixed`) and the net
never ends. So `way_ends` does not hold without `down`. -/
theorem all_but_down :
    RegimeMargin.FromNothing hump10 ∧ RegimeMargin.Keeps hump10 0 10 ∧
      (∀ u, use u < taken use (kids u)) ∧ (∀ u, 0 < need u) ∧ 8 ≤ 10 ∧
      ¬ (∀ u v, v ∈ kids u → need v ≤ need u) ∧
      «不穷» (net need kids hump10 use) «一» ([B, A, B], 8) :=
  ⟨rfl, RegimeMargin.keeps_of_below rfl, fun u => match u with
      | A => by decide
      | B => by decide,
   fun u => match u with
      | A => by decide
      | B => by decide,
   by decide, fun h => absurd (h A B (.head _)) (by decide),
   unending_of_fixed (t := 0) (fun _ lt => absurd lt (Nat.not_lt_zero _)) fixed
    ⟨A, .tail _ (.head _), by decide⟩⟩

end KidsNeedMore

namespace KidHigherNeed

/-- Two kinds. -/
inductive Kind
  | A
  | B

open Kind

/-- `A` needs one, `B` thirteen. -/
def need : Kind → Nat
  | A => 1
  | B => 13

/-- Each takes one. -/
def use (_ : Kind) : Nat := 1

/-- Each leaves `B, B`. -/
def kids (_ : Kind) : List Kind := [B, B]

/-- **Kept countermodel: without `down`, the unmet need of `need_unmet` can be a kid's greater need at
a level that has not fallen.** On `min z (12 - z)` (`TurningInTime.Three.giving`) with `hi = 12`, from
`([A], 12)`, every premise of `need_unmet` holds: nothing is given from nothing, the step under no draw
keeps every level up to twelve within twelve, every unit's kids together take two, more than its
one, every descendant needs something, the start is at most twelve, the way is not empty and `A`'s
need is met.
`down` fails (`B`, a kid of `A`, needs thirteen, `A` one). The course at step 1 is `([B, B], 12)`: the
level is the start level, and `B`'s need thirteen is above it, so the first unmet step is 1 and the
level there has not fallen below any need the start met (argued from these conjuncts: at the start
the one need, `A`'s one, is met). -/
theorem all_but_down :
    RegimeMargin.FromNothing TurningInTime.Three.giving ∧
      RegimeMargin.Keeps TurningInTime.Three.giving 0 12 ∧
      (∀ u, use u < taken use (kids u)) ∧ Needing need kids [A] ∧ 12 ≤ 12 ∧ [A] ≠ [] ∧
      (∀ u, u ∈ [A] → need u ≤ 12) ∧ ¬ (∀ u v, v ∈ kids u → need v ≤ need u) ∧
      course need kids TurningInTime.Three.giving use ([A], 12) 1 = ([B, B], 12) ∧ 12 < need B :=
  ⟨rfl, RegimeMargin.keeps_of_below rfl, fun _ => (by decide : 1 < 2),
   fun _ u _ => match u with
      | A => by decide
      | B => by decide,
   Nat.le_refl 12, List.cons_ne_nil _ _,
   fun u (mu : u ∈ [A]) => match u, mu with
      | _, .head _ => (by decide : 1 ≤ 12)
      | _, .tail _ m => (nomatch m),
   fun h => absurd (h A B (.head _)) (by decide), rfl, by decide⟩

end KidHigherNeed

namespace EqualInPlaceOfMore

/-- One unit needing one. -/
def need (_ : Unit) : Nat := 1

/-- It takes one. -/
def use (_ : Unit) : Nat := 1

/-- It leaves itself. -/
def kids (_ : Unit) : List Unit := [()]

/-- **Equal in place of more: every other premise of `way_ends` holds, and the net never ends.** On
`min z (12 - z)` with `hi = 12`: nothing is given from nothing, the step under no draw keeps every
level up to twelve within twelve, the need is positive, the kid needs what its parent needs, and the
start `12` is at most twelve; `grows` fails (its kid takes one, what it takes). From `([()], 12)` the
step leaves the configuration as it is and the net never ends. -/
theorem all_but_grows :
    RegimeMargin.FromNothing TurningInTime.Three.giving ∧
      RegimeMargin.Keeps TurningInTime.Three.giving 0 12 ∧ (∀ u, 0 < need u) ∧
      (∀ u v, v ∈ kids u → need v ≤ need u) ∧ 12 ≤ 12 ∧
      ¬ (∀ u, use u < taken use (kids u)) ∧
      «不穷» (net need kids TurningInTime.Three.giving use) «一» ([()], 12) :=
  ⟨rfl, RegimeMargin.keeps_of_below rfl, fun _ => (by decide : 0 < 1),
   fun _ _ _ => Nat.le_refl 1, Nat.le_refl 12, fun h => absurd (h ()) (by decide),
   unending_of_fixed (t := 0) (fun _ lt => absurd lt (Nat.not_lt_zero _)) rfl
    ⟨(), .head _, by decide⟩⟩

/-- **The same, as a case of `unending_iff_holds`.** With `y := id` and `hi := 12`: the kid takes what
its parent takes, has a kid, needs what it needs, needs something; nothing is given from nothing;
`Regime` holds at `[()]`, the way at every step (`course_fixed`); and `([()], 12)` holds, since twelve
meets the need and is at or above one and one. -/
theorem holds_by_law : «不穷» (net need kids TurningInTime.Three.giving use) «一» ([()], 12) :=
  (unending_iff_holds (need := need) (kids := kids) (use := use)
      (giving := TurningInTime.Three.giving) (y := id) (hi := 12) (fun _ => rfl) (fun _ => List.cons_ne_nil _ _)
      (fun _ _ _ => Nat.le_refl 1) (fun _ _ _ => (by decide : 0 < 1)) rfl (Nat.le_refl 12)
      (fun k _ => Eq.subst
        (motive := fun s : List Unit × Nat => Regime TurningInTime.Three.giving use id 12 s.1)
        (course_fixed rfl k).symm
        ⟨RegimeMargin.short_of_below rfl, RegimeMargin.meets_of_below rfl,
          RegimeMargin.keeps_of_below rfl⟩)).mpr
    ⟨0, fun _ lt => absurd lt (Nat.not_lt_zero _),
      And.intro (List.cons_ne_nil _ _)
        (And.intro (fun _ _ => (by decide : 1 ≤ 12)) (by decide : 1 + 1 ≤ 12))⟩

end EqualInPlaceOfMore

namespace TwoForOne

/-- Two kinds. -/
inductive Kind
  | P
  | Q

open Kind

/-- Both need one. -/
def need (_ : Kind) : Nat := 1

/-- `P` takes two, `Q` one. -/
def use : Kind → Nat
  | P => 2
  | Q => 1

/-- `P` leaves `Q, Q`; `Q` leaves itself. -/
def kids : Kind → List Kind
  | P => [Q, Q]
  | Q => [Q]

/-- **The middle case with offspring that are not the unit itself, by the law.** On `min z (12 - z)`
(`TurningInTime.Three.giving`), with `y := id` and `hi := 12`: `P`'s two kids `Q` together take two,
what it takes, and `Q`'s one kid takes one; every unit has kids, needs one and leaves kids needing
one; nothing is given from nothing; the start four is at most twelve. From `([P], 4)` the course is
`([Q, Q], 4)` at every step from 1 on, both ways taking two, at which `Regime` holds (giving short
of two below two, meeting two from two up to twelve, the step under two keeping the level within
twelve); and `([P], 4)` holds (its need met, four at or above two and two). So by
`unending_iff_holds` the net from `([P], 4)` never ends. -/
theorem holds_by_law :
    course need kids TurningInTime.Three.giving use ([P], 4) 1 = ([Q, Q], 4) ∧
    (∀ k, course need kids TurningInTime.Three.giving use ([P], 4) (1 + k) = ([Q, Q], 4)) ∧
    «不穷» (net need kids TurningInTime.Three.giving use) «一» ([P], 4) :=
  have later : ∀ k, course need kids TurningInTime.Three.giving use ([P], 4) (1 + k) = ([Q, Q], 4) :=
    fun k => (Law.orbit_add _ _ 1 k).trans (course_fixed rfl k)
  have regimeP : Regime TurningInTime.Three.giving use id 12 [P] :=
    ⟨RegimeMargin.short_of_below rfl, RegimeMargin.meets_of_below rfl, RegimeMargin.keeps_of_below rfl⟩
  have regimeQQ : Regime TurningInTime.Three.giving use id 12 [Q, Q] :=
    ⟨RegimeMargin.short_of_below rfl, RegimeMargin.meets_of_below rfl, RegimeMargin.keeps_of_below rfl⟩
  ⟨rfl, later, (unending_iff_holds (need := need) (kids := kids) (use := use)
      (giving := TurningInTime.Three.giving) (y := id) (hi := 12)
      (fun u => match u with
        | P => rfl
        | Q => rfl)
      (fun u => match u with
        | P => List.cons_ne_nil _ _
        | Q => List.cons_ne_nil _ _)
      (fun _ _ _ => Nat.le_refl 1) (fun _ _ _ => (by decide : 0 < 1)) rfl (by decide : 4 ≤ 12)
      (fun k _ => match k with
        | 0 => regimeP
        | k + 1 => Eq.subst (motive := fun i =>
              Regime TurningInTime.Three.giving use id 12
                (course need kids TurningInTime.Three.giving use ([P], 4) i).1)
            (Nat.add_comm 1 k)
            (Eq.subst (motive := fun s : List Kind × Nat => Regime TurningInTime.Three.giving use id 12 s.1)
              (later k).symm regimeQQ))).mpr
    ⟨0, fun _ lt => absurd lt (Nat.not_lt_zero _),
      ⟨List.cons_ne_nil _ _, fun _ _ => (by decide : 1 ≤ 4), (by decide : 2 + 2 ≤ 4)⟩⟩⟩

end TwoForOne

namespace ShareRises

/-- Two kinds. -/
inductive Kind
  | C
  | O

open Kind

/-- Both need one. -/
def need (_ : Kind) : Nat := 1

/-- Both take two. -/
def use (_ : Kind) : Nat := 2

/-- `C` leaves itself; `O` leaves nothing. -/
def kids : Kind → List Kind
  | C => [C]
  | O => []

/-- The units of kind `C`. -/
def isC : Kind → Bool
  | C => true
  | O => false

/-- **A share that rises while the number of drawers falls.** On `min z (12 - z)`, from
`([C, O], 12)`: the way is `[C]` from step 1 and the level is twelve at steps 0 and 1 and every step
after; `C` takes two of four at step 0 and two of two at step 1. -/
theorem course_values :
    (course need kids TurningInTime.Three.giving use ([C, O], 12) 1) = ([C], 12) ∧
      (∀ k, course need kids TurningInTime.Three.giving use ([C, O], 12) (1 + k) = ([C], 12)) ∧
      lineTake (fun u => isC u = true) use [C, O] = 2 ∧ taken use [C, O] = 4 ∧
      lineTake (fun u => isC u = true) use [C] = 2 ∧ taken use [C] = 2 :=
  ⟨rfl, fun k => (Law.orbit_add _ _ 1 k).trans (course_fixed rfl k), rfl, rfl, rfl, rfl⟩

/-- The net from `([C, O], 12)` never ends. -/
theorem goes_on : «不穷» (net need kids TurningInTime.Three.giving use) «一» ([C, O], 12) :=
  unending_of_fixed (t := 1)
    (fun j lt => match j, lt with
      | 0, _ => by decide
      | j + 1, lt => absurd lt (Nat.not_lt_of_ge (Nat.le_add_left 1 j)))
    rfl (by decide)

end ShareRises

namespace Doubling

/-- One unit needing one. -/
def need (_ : Unit) : Nat := 1

/-- It takes one. -/
def use (_ : Unit) : Nat := 1

/-- It leaves two copies of itself. -/
def kids (_ : Unit) : List Unit := [(), ()]

/-- **A way that doubles.** On `min z (12 - z)`, from one unit at twelve: the levels at steps 0 to 5
are 12, 12, 12, 12, 8, 0 and the ways have 1, 2, 4, 8, 16, 32 units; at step 5 no need is met and the
net ends. -/
theorem course_values :
    (course need kids TurningInTime.Three.giving use ([()], 12) 1).2 = 12 ∧
    (course need kids TurningInTime.Three.giving use ([()], 12) 2).2 = 12 ∧
    (course need kids TurningInTime.Three.giving use ([()], 12) 3).2 = 12 ∧
    (course need kids TurningInTime.Three.giving use ([()], 12) 4).2 = 8 ∧
    (course need kids TurningInTime.Three.giving use ([()], 12) 5).2 = 0 ∧
    (course need kids TurningInTime.Three.giving use ([()], 12) 1).1.length = 2 ∧
    (course need kids TurningInTime.Three.giving use ([()], 12) 2).1.length = 4 ∧
    (course need kids TurningInTime.Three.giving use ([()], 12) 3).1.length = 8 ∧
    (course need kids TurningInTime.Three.giving use ([()], 12) 4).1.length = 16 ∧
    (course need kids TurningInTime.Three.giving use ([()], 12) 5).1.length = 32 ∧
    ¬ Goes need (course need kids TurningInTime.Three.giving use ([()], 12) 5) ∧
    ¬ «不穷» (net need kids TurningInTime.Three.giving use) «一» ([()], 12) :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, by decide,
   fun never => absurd (Law.stepWhile_unending_iff.mp never 5) (by decide)⟩

/-- **The doubling way as a case of `way_ends`.** `FromNothing` and `Keeps` at no draw up to twelve
hold of `min z (12 - z)`; the unit's kids together take two, more than its one; its need is one; its
kids need what it needs. -/
theorem ends_by_law :
    (∃ n, ¬ Goes need (course need kids TurningInTime.Three.giving use ([()], 12) n)) ∧
      ¬ «不穷» (net need kids TurningInTime.Three.giving use) «一» ([()], 12) :=
  way_ends (need := need) (kids := kids) (use := use) (giving := TurningInTime.Three.giving)
    (hi := 12) rfl (RegimeMargin.keeps_of_below rfl) (fun _ => (by decide : 1 < 2))
    (fun _ => (by decide : 0 < 1)) (fun _ _ _ => Nat.le_refl 1) (by decide)

/-- **The doubling way as a case of `need_unmet`**, with `hi = 12`: some need is unmet at a step `n`
from 1 to 13, every need met before it and the way the `j`-th generation up to it (by
`course_values`, `n` is 5). -/
theorem unmet_by_law :
    ∃ n, 0 < n ∧ n ≤ 13 ∧
      (∀ j, j < n → ∀ u, u ∈ (course need kids TurningInTime.Three.giving use ([()], 12) j).1 →
        need u ≤ (course need kids TurningInTime.Three.giving use ([()], 12) j).2) ∧
      (∀ j, j ≤ n → (course need kids TurningInTime.Three.giving use ([()], 12) j).1 =
        generation kids j [()]) ∧
      ∃ u, u ∈ (course need kids TurningInTime.Three.giving use ([()], 12) n).1 ∧
        (course need kids TurningInTime.Three.giving use ([()], 12) n).2 < need u :=
  need_unmet (need := need) (kids := kids) (use := use) (giving := TurningInTime.Three.giving)
    (hi := 12) rfl (RegimeMargin.keeps_of_below rfl) (fun _ => (by decide : 1 < 2))
    (fun _ _ _ => (by decide : 0 < 1)) (Nat.le_refl 12) (List.cons_ne_nil _ _)
    (fun _ _ => (by decide : 1 ≤ 12))

end Doubling

namespace HigherStartEnds

/-- Three kinds. -/
inductive Kind
  | A
  | B
  | C

open Kind

/-- `A` needs one, `B` three, `C` twelve. -/
def need : Kind → Nat
  | A => 1
  | B => 3
  | C => 12

/-- `A` takes three, `B` and `C` one. -/
def use : Kind → Nat
  | A => 3
  | B => 1
  | C => 1

/-- `A` leaves `B, B`; `B` leaves `C, B`; `C` leaves `A`. -/
def kids : Kind → List Kind
  | A => [B, B]
  | B => [C, B]
  | C => [A]

/-- **From six.** On `min z (12 - z)`, from `([A], 6)`: `A` at six, `B B` at six, `C B C B` at eight,
which the step leaves as it is; the net never ends. -/
theorem from_six :
    course need kids TurningInTime.Three.giving use ([A], 6) 1 = ([B, B], 6) ∧
    course need kids TurningInTime.Three.giving use ([A], 6) 2 = ([C, B, C, B], 8) ∧
    course need kids TurningInTime.Three.giving use ([A], 6) 3 = ([C, B, C, B], 8) ∧
    «不穷» (net need kids TurningInTime.Three.giving use) «一» ([A], 6) :=
  ⟨rfl, rfl, rfl, unending_of_fixed (t := 2)
    (fun j lt => match j, lt with
      | 0, _ => by decide
      | 1, _ => by decide
      | j + 2, lt => absurd lt (Nat.not_lt_of_ge (Nat.le_add_left 2 j)))
    rfl (by decide)⟩

/-- **From seven.** On `min z (12 - z)`, from `([A], 7)`: `A` at seven, `B B` at eight, `C B C B` at
twelve, six units at twelve, ten at four, sixteen at nothing; no need is met there and the net
ends. -/
theorem from_seven :
    course need kids TurningInTime.Three.giving use ([A], 7) 1 = ([B, B], 8) ∧
    course need kids TurningInTime.Three.giving use ([A], 7) 2 = ([C, B, C, B], 12) ∧
    course need kids TurningInTime.Three.giving use ([A], 7) 3 = ([A, C, B, A, C, B], 12) ∧
    course need kids TurningInTime.Three.giving use ([A], 7) 4 =
      ([B, B, A, C, B, B, B, A, C, B], 4) ∧
    (course need kids TurningInTime.Three.giving use ([A], 7) 5).1.length = 16 ∧
    (course need kids TurningInTime.Three.giving use ([A], 7) 5).2 = 0 ∧
    ¬ «不穷» (net need kids TurningInTime.Three.giving use) «一» ([A], 7) :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl,
   fun never => absurd (Law.stepWhile_unending_iff.mp never 5) (by decide)⟩

/-- **The higher start ends** (the fate is not monotone in the start level): the two ways are the same
at steps 0, 1 and 2, by `ways_alike` at `n = 2` (at step 0 the levels six and seven, at step 1 six and
eight, meet the same needs of every kind); from six the net never ends, from seven it ends. -/
theorem higher_ends :
    (∀ j, j ≤ 2 → (course need kids TurningInTime.Three.giving use ([A], 6) j).1 =
      (course need kids TurningInTime.Three.giving use ([A], 7) j).1) ∧
    «不穷» (net need kids TurningInTime.Three.giving use) «一» ([A], 6) ∧
    ¬ «不穷» (net need kids TurningInTime.Three.giving use) «一» ([A], 7) :=
  ⟨ways_alike fun j lt u _ => match j, lt, u with
      | 0, _, A => by decide
      | 0, _, B => by decide
      | 0, _, C => by decide
      | 1, _, A => by decide
      | 1, _, B => by decide
      | 1, _, C => by decide
      | j + 2, lt, _ => absurd lt (Nat.not_lt_of_ge (Nat.le_add_left 2 j)),
   from_six.2.2.2, from_seven.2.2.2.2.2.2⟩

end HigherStartEnds

namespace NoKids

/-- One unit needing one. -/
def need (_ : Unit) : Nat := 1

/-- It takes one. -/
def use (_ : Unit) : Nat := 1

/-- It leaves nothing. -/
def kids (_ : Unit) : List Unit := []

/-- **A met unit with no kids.** On `min z (12 - z)`, from one unit at twelve: its need is met at
the start, one step later the way is empty at twelve, and the net ends. -/
theorem ends_met :
    (∀ u, u ∈ [()] → need u ≤ 12) ∧
    course need kids TurningInTime.Three.giving use ([()], 12) 1 = ([], 12) ∧
    ¬ «不穷» (net need kids TurningInTime.Three.giving use) «一» ([()], 12) :=
  ⟨fun _ _ => (by decide : 1 ≤ 12), rfl,
   fun never => absurd (Law.stepWhile_unending_iff.mp never 1) (by decide)⟩

end NoKids

namespace Overdrawn

/-- One unit needing one. -/
def need (_ : Unit) : Nat := 1

/-- It takes seven. -/
def use (_ : Unit) : Nat := 7

/-- It leaves itself. -/
def kids (_ : Unit) : List Unit := [()]

/-- Giving `min z (12 - z)` falls short of seven at every level. -/
theorem short : ∀ z, TurningInTime.Three.giving z < 7 := fun z =>
  (Nat.lt_or_ge z 7).elim
    (fun lt => Nat.lt_of_le_of_lt (RegimeMargin.Peaked.min_le_left' _ _) lt)
    (fun ge => match le_dest ge with
      | ⟨k, e⟩ => Nat.lt_of_le_of_lt (RegimeMargin.Peaked.min_le_right' _ _) (by
          rw [e, ← Naturals.sub_sub 12 7 k]
          exact Nat.lt_of_le_of_lt (Nat.sub_le 5 k) (by decide)))

/-- **A case of `fall`.** On `min z (12 - z)`, one unit needing one, taking seven and leaving itself:
the line of every unit (closed), of one need, whose kid takes what it takes, with `giving 0 = 0 < 1`,
and taking seven, more than every giving (`short`): from `([()], 12)` there is a step from which the
way is empty. By computation: the levels are 12, 10, 6, 0, and the way is `[()]` up to step 3 and
empty from step 4. -/
theorem gone :
    (∃ n, ∀ k, n ≤ k → ∀ u, u ∈ (course need kids TurningInTime.Three.giving use ([()], 12) k).1 →
      ¬ True) ∧
    course need kids TurningInTime.Three.giving use ([()], 12) 1 = ([()], 10) ∧
    course need kids TurningInTime.Three.giving use ([()], 12) 2 = ([()], 6) ∧
    course need kids TurningInTime.Three.giving use ([()], 12) 3 = ([()], 0) ∧
    (∀ k, course need kids TurningInTime.Three.giving use ([()], 12) (4 + k) = ([], 0)) :=
  ⟨fall (need := need) (kids := kids) (use := use) (giving := TurningInTime.Three.giving)
      (S := fun _ => True) (m := 1) (fun _ _ _ _ => trivial) (fun _ _ => rfl)
      (fun _ _ => Nat.le_refl 7) (by decide) short,
   rfl, rfl, rfl, fun k => (Law.orbit_add _ _ 4 k).trans (course_fixed rfl k)⟩

end Overdrawn

namespace ProperLine

/-- Two kinds. -/
inductive Kind
  | D
  | O

open Kind

/-- Both need one. -/
def need (_ : Kind) : Nat := 1

/-- Both take one. -/
def use (_ : Kind) : Nat := 1

/-- `D` leaves `D, D`; `O` leaves `O`. -/
def kids : Kind → List Kind
  | D => [D, D]
  | O => [O]

/-- The units of kind `D`. -/
def isD : Kind → Bool
  | D => true
  | O => false

/-- **A case of `line_ends` with a line that is a proper part of the way.** On `min z (12 - z)` with
`hi = 12`, the line of `D` (no `O` leaves a `D`), whose kids together take two, more than its one,
needing one, its kids needing what it needs: from `([D, O], 12)` there is a step from which no `D`
is in the way, by the law. By computation: the ways are `D O`, `D D O`, `D D D D O` at twelve, then
9 units at twelve, 17 at six and 33 at nothing; the way is empty at nothing from step 6 on. -/
theorem gone :
    (∃ n, ∀ k, n ≤ k → ∀ u, u ∈ (course need kids TurningInTime.Three.giving use ([D, O], 12) k).1 →
      ¬ isD u = true) ∧
    course need kids TurningInTime.Three.giving use ([D, O], 12) 1 = ([D, D, O], 12) ∧
    course need kids TurningInTime.Three.giving use ([D, O], 12) 2 = ([D, D, D, D, O], 12) ∧
    (course need kids TurningInTime.Three.giving use ([D, O], 12) 3).1.length = 9 ∧
    (course need kids TurningInTime.Three.giving use ([D, O], 12) 3).2 = 12 ∧
    (course need kids TurningInTime.Three.giving use ([D, O], 12) 4).1.length = 17 ∧
    (course need kids TurningInTime.Three.giving use ([D, O], 12) 4).2 = 6 ∧
    (course need kids TurningInTime.Three.giving use ([D, O], 12) 5).1.length = 33 ∧
    (course need kids TurningInTime.Three.giving use ([D, O], 12) 5).2 = 0 ∧
    (∀ k, course need kids TurningInTime.Three.giving use ([D, O], 12) (6 + k) = ([], 0)) :=
  ⟨line_ends (need := need) (kids := kids) (use := use) (giving := TurningInTime.Three.giving)
      (S := fun u => isD u = true) (hi := 12) rfl (RegimeMargin.keeps_of_below rfl)
      (fun u v mv sv => match u, v, mv, sv with
        | D, _, _, _ => rfl
        | O, _, .head _, sv => sv
        | O, _, .tail _ m, _ => nomatch m)
      (fun u su => match u, su with
        | D, _ => by decide
        | O, su => absurd su Bool.false_ne_true)
      (fun _ _ => (by decide : 0 < 1)) (fun _ _ _ _ => Nat.le_refl 1) (Nat.le_refl 12),
   rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl,
   fun k => (Law.orbit_add _ _ 6 k).trans (course_fixed rfl k)⟩

end ProperLine

namespace AlikeFiner

/-- Two kinds. -/
inductive Kind
  | d
  | b

open Kind

/-- `d` needs five, `b` one. -/
def need : Kind → Nat
  | d => 5
  | b => 1

/-- `d` leaves nothing; `b` leaves itself. -/
def kids : Kind → List Kind
  | d => []
  | b => [b]

/-- **Meeting the same needs is finer than being alike.** Levels four and six are alike to `[d, b]`
(the way after a step at each is `[b]`), and they do not meet the same needs in it (six meets `d`'s
five, four does not): `alike_iff` needs every unit to leave a kid, and `d` leaves none. -/
theorem alike_not_met :
    Alike need kids [d, b] 4 6 ∧ ¬ (∀ u, u ∈ [d, b] → (need u ≤ 4 ↔ need u ≤ 6)) :=
  ⟨rfl, fun h => absurd ((h d (.head _)).mpr (by decide : need d ≤ 6)) (by decide : ¬ need d ≤ 4)⟩

end AlikeFiner

namespace TakesNothing

/-- Three kinds. -/
inductive Kind
  | A
  | B
  | C

open Kind

/-- `A` needs one, `B` nine, `C` seven. -/
def need : Kind → Nat
  | A => 1
  | B => 9
  | C => 7

/-- `A` takes three, `B` two, `C` nothing. -/
def use : Kind → Nat
  | A => 3
  | B => 2
  | C => 0

/-- Each kind leaves itself. -/
def kids (u : Kind) : List Kind := [u]

/-- The units of kind `C`. -/
def isC : Kind → Bool
  | A => false
  | B => false
  | C => true

/-- **A unit that takes nothing, lost, leaves the levels as they are.** On `min z (12 - z)`, from
`([A, B, C], 9)` and from `([A, B], 9)`, the way without its `C`: at every step the levels are the
same and the ways without `C` are the same, by `takes_nothing` (`C` takes nothing and leaves only
`C`). By computation: from `([A, B, C], 9)` the course is `([A, B, C], 8)`, `([A, C], 6)`, then
`([A], 6)` at every step from 3 on, so `C` is in the way at steps 0 to 2 and at no step after; from
`([A, B], 9)` it is `([A, B], 8)`, then `([A], 6)` at every step from 2 on: the levels 9, 8, 6, 6, …
of both; the net from `([A, B, C], 9)` never ends. -/
theorem lost :
    (∀ n, (course need kids TurningInTime.Three.giving use ([A, B], 9) n).2 =
        (course need kids TurningInTime.Three.giving use ([A, B, C], 9) n).2 ∧
      strip (fun u => isC u = true) (course need kids TurningInTime.Three.giving use ([A, B], 9) n).1 =
        strip (fun u => isC u = true)
          (course need kids TurningInTime.Three.giving use ([A, B, C], 9) n).1) ∧
    course need kids TurningInTime.Three.giving use ([A, B, C], 9) 1 = ([A, B, C], 8) ∧
    course need kids TurningInTime.Three.giving use ([A, B, C], 9) 2 = ([A, C], 6) ∧
    (∀ k, course need kids TurningInTime.Three.giving use ([A, B, C], 9) (3 + k) = ([A], 6)) ∧
    course need kids TurningInTime.Three.giving use ([A, B], 9) 1 = ([A, B], 8) ∧
    (∀ k, course need kids TurningInTime.Three.giving use ([A, B], 9) (2 + k) = ([A], 6)) ∧
    «不穷» (net need kids TurningInTime.Three.giving use) «一» ([A, B, C], 9) :=
  ⟨takes_nothing (need := need) (kids := kids) (use := use) (giving := TurningInTime.Three.giving)
      (Z := fun u => isC u = true)
      (fun u h => match u, h with
        | C, _ => rfl
        | A, h => absurd h Bool.false_ne_true
        | B, h => absurd h Bool.false_ne_true)
      (fun _ _ h mv => match mv with
        | .head _ => h
        | .tail _ m => nomatch m)
      [A, B, C] 9,
   rfl, rfl, fun k => (Law.orbit_add _ _ 3 k).trans (course_fixed rfl k), rfl,
   fun k => (Law.orbit_add _ _ 2 k).trans (course_fixed rfl k),
   unending_of_fixed (t := 3)
    (fun j lt => match j, lt with
      | 0, _ => by decide
      | 1, _ => by decide
      | 2, _ => by decide
      | j + 3, lt => absurd lt (Nat.not_lt_of_ge (Nat.le_add_left 3 j)))
    rfl (by decide)⟩

end TakesNothing

namespace NothingTakenEnds

/-- Two kinds. -/
inductive Kind
  | A
  | C

open Kind

/-- `A` needs five, `C` one. -/
def need : Kind → Nat
  | A => 5
  | C => 1

/-- `A` takes one, `C` nothing. -/
def use : Kind → Nat
  | A => 1
  | C => 0

/-- Each kind leaves itself. -/
def kids (u : Kind) : List Kind := [u]

/-- The units of kind `C`. -/
def isC : Kind → Bool
  | A => false
  | C => true

/-- **Kept countermodel: a unit that takes nothing changes whether the net ends.** With nothing given
(`nothingGiven`), from five: `C` takes nothing and leaves only `C`, so `takes_nothing` holds, and the
levels and the ways without `C` from `([A, C], 5)` and from `([A], 5)` are the same at every step. Yet
from `([A, C], 5)` the net never ends (the course is `([A, C], 4)` at step 1, then `([C], 3)` at every
step from 2 on, where `C` is met: the second and third conjuncts), while from `([A], 5)` it ends at
step 1, at `([A], 4)`, where `A` is not met. So `takes_nothing` does not carry whether the net ends: a unit that takes nothing can keep the net
going after every unit that takes something has stopped being met. -/
theorem ending_differs :
    (∀ n, (course need kids nothingGiven use ([A], 5) n).2 =
        (course need kids nothingGiven use ([A, C], 5) n).2 ∧
      strip (fun u => isC u = true) (course need kids nothingGiven use ([A], 5) n).1 =
        strip (fun u => isC u = true) (course need kids nothingGiven use ([A, C], 5) n).1) ∧
    course need kids nothingGiven use ([A, C], 5) 1 = ([A, C], 4) ∧
    (∀ k, course need kids nothingGiven use ([A, C], 5) (2 + k) = ([C], 3)) ∧
    «不穷» (net need kids nothingGiven use) «一» ([A, C], 5) ∧
    «迭» (net need kids nothingGiven use) 1 ([A], 5) ([A], 4) ∧
    (∀ v, ¬ net need kids nothingGiven use ([A], 4) v) :=
  ⟨takes_nothing (need := need) (kids := kids) (use := use) (giving := nothingGiven)
      (Z := fun u => isC u = true)
      (fun u h => match u, h with
        | C, _ => rfl
        | A, h => absurd h Bool.false_ne_true)
      (fun _ _ h mv => match mv with
        | .head _ => h
        | .tail _ m => nomatch m)
      [A, C] 5,
   rfl, fun k => (Law.orbit_add _ _ 2 k).trans (course_fixed rfl k),
   unending_of_fixed (t := 2)
    (fun j lt => match j, lt with
      | 0, _ => by decide
      | 1, _ => by decide
      | j + 2, lt => absurd lt (Nat.not_lt_of_ge (Nat.le_add_left 2 j)))
    rfl (by decide),
   (Law.stepWhile_steps_iff 1).mpr ⟨fun j lt => match j, lt with
      | 0, _ => by decide
      | j + 1, lt => absurd lt (Nat.not_lt_of_ge (Nat.le_add_left 1 j)), rfl⟩,
   Law.stepWhile_none_iff.mpr (by decide)⟩

end NothingTakenEnds

end LineOnAStock
end Becoming
