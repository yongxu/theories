import Becoming.TurningInTime

/-!
# A way of units: a turn with no mark given

AI-written, 13 November 2026.

## What the package already has

`Becoming.TurningInTime` steps a way and a level as a pair (`TurningInTime.pair`), cuts the pair's
step where the level is below a need (`TurningInTime.net`), and states the exact condition
`TurningInTime.turns_in_time_iff`: under its regime premises, the line never ends exactly where, at
the first marked level of the course as it was, the need met there and at every step before, the level
one step later is at or above `H₂ + y₂`. There the marks are given: `AloneOutside`, `turns`, `kept`,
`uses` and `uses₁` are premises. Something ending below its need is already in the package, on models
of its own: a formation that depends, at a need of at least `m`, on a member of a family whose stock is
below `m`, where it is active only while supported, is not active (`Flow.family_ends_below_at`,
`Becoming.Continuation`); and `ReadingsSpread`'s overdrawn focal line, which takes from the source
while the source lasts, is removed once the source stands below its need, while the wide line persists
(`ReadingsSpread.Commons.overdrawn_spreads_then_ends`). At a standing use `H`, with giving short of
`H` below `y` and nothing given from nothing, the level's own course comes to nothing from below
`H + y` (`RegimeMargin.ends_below`); with giving meeting `H` from `y` up to `hi` and the step keeping
the level within `hi`, it never falls below a start from `H + y` up to `hi` (`RegimeMargin.holds`).

## What this module adds

Each bullet names the main premises; each theorem's docstring names all of them. Unit, need, use, way
and level are this model's labels, not terms of the root.

* **A way of units.** A unit is a pair of numbers: the level it needs to go on (`need`) and what it
  takes from the level at each step (`use`). A way is the list of units present. A unit goes on at a
  level that meets its need (`goes`); after a step the way is the units that go on (`after`, the
  root's `GrammarLaws.keep`), and the level is `RegimeMargin.step` under what the units present take
  together (`taken`, `left`): every unit present at the step takes. The net has a next while some unit
  goes on (`Goes`, `net`; `course` is the pair's orbit). Where the level is below the need of one unit
  of the way and meets the need of another, the line under the way's class ends there while the net
  goes on (`ends_while_net_goes`).
* **When the line never ends, for any number of units** (`unending_iff_holds`). With every unit of the
  start needing something, nothing given from nothing, the start at most `hi`, and, at every way the
  course reaches with some unit going on there and at every step before it, the start's included,
  giving short of what the way takes below `y` of it, meeting it from there up to `hi`, and the step
  keeping the level within `hi` (`Regime`): the line never ends exactly where, the net going on until
  then, it comes to a way that is not empty, all of whose units' needs are met at a level from which
  what they take together holds (`Holds`). `With.goes_on_holds` meets these premises from a start of
  two units.
* **Two units, and the tie to TurningInTime** (`two_units_iff`). For a first unit needing `m` and
  taking `h` and a second needing `n ≤ m` and taking `H₂`, under `turns_in_time_iff`'s regime premises
  with `H₁ := h + H₂` and a start below `h + H₂ + y₁` and at most `hi`: the line never ends exactly
  where, at the first level below `m` of the course as it was, `n` is met and the level one step later
  is at or above `H₂ + y₂`. By `turns_in_time_iff` on a carrier of two values (the first unit there or
  ended) with `marked := (· < m)`, `alone := id` and the kept kind `false`, for which `AloneOutside`,
  `turns`, `kept`, `uses` and `uses₁` are proved, not assumed (`first_outside`, `first_turns`,
  `first_kept`, `first_uses`, `first_uses₁`), and a transfer: from this start the units' line never
  ends exactly where the carrier's line never ends (`unending_iff_carrier`).
* **A line of two units that never ends stays at or above `H₂ + y₂`, below which the level under the
  second unit's use falls** (`unending_above`). With `n ≤ m`, nothing given from nothing, giving
  short of `H₂` below `y₂` and `0 < n`, under any use of the first unit and from any start: if the
  line from a first unit needing
  `m` and a second needing `n` and taking `H₂` never ends, every level of its course is at or above
  `H₂ + y₂`. Below it each step, under a use of at least `H₂`, leaves nothing or a lower level
  (`step_falls`), so the level comes to nothing, below `n` (`carrier_falls`, `carrier_above`).
* **Comparisons of two units**, not through `two_units_iff`, from any start at most `hi`. With
  `n ≤ m`, nothing given from nothing, and `Short`, `Meets` and `Keeps` at the second unit's use `H₂`
  from `y₂` up to `hi`: a greater need `m' ≥ m` of the first unit never ends a line that did not end
  (`greater_need`). With `n ≤ m`, nothing given from nothing, `Short`, `Meets` and `Keeps` at the
  second unit's use `H₂'` in the line compared, the same sum taken `h + H₂ = h' + H₂'` and `h ≤ h'`:
  more of the use on the first unit never ends a line that did not end (`more_use_on_first`). Each
  rests on `carrier_above`, the step of `unending_above`: the two lines have the same course until
  they leave each other, the level there is at or above the second unit's use and `y` of it, and from
  there the second unit alone holds (`alone_holds`, by `RegimeMargin.holds`); at `n = 0` both lines
  never end.
* **A unit that takes nothing** (`takes_nothing_iff_alone`). With `n ≤ m`, under any giving and from
  any start, the line from a first unit needing `m` and taking nothing and a second needing `n` and
  taking `H₂` never ends exactly where the line of the second unit alone never ends: whether the first
  unit is there or has ended, the level's course is the same. So from a start below `H₂ + y₁`, with
  giving short of `H₂` below `y₁`, nothing given from nothing and every need positive, the line ends
  (`takes_nothing_ends`, `RegimeMargin.ends_below` for the second unit).
* **Two ways from one start** (`With`, `Against`). Giving `min z (12 - z)`
  (`TurningInTime.Three.giving`), from the level nine, needs nine and one, the two units taking five
  together: with the first taking four and the second one, the levels run 9, 8, 6, 10, 12, 12 and the
  line never ends (`With.goes_on`, by `two_units_iff`; `With.goes_on_holds`, by `unending_iff_holds`;
  `With.levels`); with the first taking one and the second four, they run 9, 8, 6, 4, 0 and the line
  ends (`Against.turns_and_ends`). The needs, the sum taken and the levels up to the first unit's
  ending are the same; which unit takes the larger use differs.
* **Where something is given from nothing, the comparisons fail** (`GivenFromNothing`). Giving two at
  nothing and at two and nothing elsewhere, with `Short`, `Meets` and `Keeps` at the second unit's use
  three from four up to six (`GivenFromNothing.regime`), from six: a first unit needing two and taking
  one with a second needing two and taking three never ends, and with the first needing seven the
  line ends (`GivenFromNothing.greater_need_fails`); a first unit needing seven and taking nothing
  with a second taking four never ends, and with them taking one and three the line ends
  (`GivenFromNothing.more_use_fails`). So neither comparison holds without nothing given from
  nothing. A line that comes to a configuration its step leaves as it is, some unit going on there and
  at every step before, never ends (`unending_of_fixed`).

## What is given and what is not shown

Units only end. Nothing here builds a unit, and nothing derives that a unit which needs more is there.
The needs, the uses and `y`, `y₁`, `y₂` are parameters; `RegimeMargin.Short`, `Meets`, `Keeps` and
`FromNothing` are premises on the giving, as in TurningInTime; `unending_iff_holds` asks them along the
course, at every way it reaches with some unit going on there and at every step before, not at every
way. They ask `Meets` and `Keeps` up to one `hi`, so under a giving with no such `hi` at what the ways
take, `unending_iff_holds` does not apply. The marks of a way that conditions on a reading are not
derived: TurningInTime's `marked` is a property of levels, while here the level at which the way
changes depends on the way, so `unending_iff_holds` does not go through `turns_in_time_iff`, and
`two_units_iff` does only for two units and from a start below `h + H₂ + y₁` and at most `hi`. A start
at or above `h + H₂ + y₁`, a start that already holds with both units among them, is outside
`two_units_iff`; `unending_iff_holds` covers it under its own premises, which ask `Meets` and `Keeps`
at `h + H₂` with `y (h + H₂)` too, where `two_units_iff` asks only `Short` there. `greater_need` and
`more_use_on_first` do not go through `two_units_iff`: they are proved for two units from any start
at most `hi`, with `n ≤ m`, nothing given from nothing, and `Short`, `Meets` and `Keeps` at the second
unit's use (in the line compared, for `more_use_on_first`), without `0 < n`, `n ≤ H₂ + y₂`, `Short`
at `h + H₂` or a bound on the start below `h + H₂ + y₁`, and `more_use_on_first` without the regime
at `H₂`. The comparison for any number of units is not stated. Nothing given from nothing cannot be
dropped from either comparison (`GivenFromNothing`, proved). For each other premise, computed cases,
not Lean, show it needed too: a simulation of this module (in the reports on its study) gives, with
that premise dropped and the others kept, a giving and a start at which the statement fails, for
`greater_need` without `n ≤ m`, `m ≤ m'`, `Short`, `Meets`, `Keeps` or the start at most `hi`, for
`more_use_on_first` without `n ≤ m`, `Short`, `Meets`, `Keeps`, the same sum, `h ≤ h'` or the start
at most `hi`, and for `unending_above` without `n ≤ m` or nothing given from nothing. `unending_above`
asks `0 < n`: at `n = 0` the line never ends from any start (`unending_needs_nothing`), a start below
`H + y` among them.
Readings, not theorems: that `ReadingsSpread`'s overdrawn focal line is such a unit; that the gauges
`near` and `mid` of `Becoming.ReadOffInTime`'s witness of one loss, which need more and take
nothing, are the case of `takes_nothing_iff_alone`, at whose ending the level's course is as it was,
so that they can only be read; anything about keeping a unit from ending by lowering its need.
Nothing here is about a trained system.

Every declaration has an empty axiom report.
-/

namespace Becoming
namespace WayOfUnits

/-! ## 1. Units, the way and its net -/

/-- The level a unit `u = (need, use)` needs to go on. -/
def need (u : Nat × Nat) : Nat := u.1

/-- What a unit takes from the level at each step. -/
def use (u : Nat × Nat) : Nat := u.2

/-- A unit goes on at the level `x` where `x` meets its need. -/
def goes (x : Nat) (u : Nat × Nat) : Bool := decide (need u ≤ x)

/-- The way after a step at the level `x`: the units that go on, in order (the root's
`GrammarLaws.keep`). -/
def after (w : List (Nat × Nat)) (x : Nat) : List (Nat × Nat) := GrammarLaws.keep (goes x) w

/-- What a way takes: the sum of its units' uses. -/
def taken : List (Nat × Nat) → Nat
  | [] => 0
  | u :: w => use u + taken w

/-- The level after a step: `RegimeMargin.step` under what every unit present at the step takes. -/
def left (giving : Nat → Nat) (w : List (Nat × Nat)) (x : Nat) : Nat :=
  RegimeMargin.step giving (taken w) x

/-- Some unit of the way goes on at the level. -/
def Goes (s : List (Nat × Nat) × Nat) : Prop := ∃ u, u ∈ s.1 ∧ need u ≤ s.2

/-- The net: the pair's step (`TurningInTime.pair`) while some unit goes on, and nothing where none
does. -/
def net (giving : Nat → Nat) : «际» (List (Nat × Nat) × Nat) :=
  Law.stepWhile Goes (TurningInTime.pair after (left giving))

/-- The course: the pair's orbit from `s`. -/
abbrev course (giving : Nat → Nat) (s : List (Nat × Nat) × Nat) : Nat → List (Nat × Nat) × Nat :=
  Law.orbit (TurningInTime.pair after (left giving)) s

/-- A configuration from which what its units take holds: the way is not empty, every unit's need is
met at the level, and the level is at or above what the way takes and `y` of it. -/
def Holds (y : Nat → Nat) (s : List (Nat × Nat) × Nat) : Prop :=
  s.1 ≠ [] ∧ (∀ u, u ∈ s.1 → need u ≤ s.2) ∧ taken s.1 + y (taken s.1) ≤ s.2

/-- The regime at a way `S`: giving short of what `S` takes below `y` of it, meeting it from there up
to `hi`, and the step under it keeping the level within `hi`. -/
def Regime (giving y : Nat → Nat) (hi : Nat) (S : List (Nat × Nat)) : Prop :=
  RegimeMargin.Short giving (taken S) (y (taken S)) ∧
    RegimeMargin.Meets giving (taken S) (y (taken S)) hi ∧ RegimeMargin.Keeps giving (taken S) hi

/-! ## 2. On lists and on steps -/

/-- A unit goes on where the level meets its need. -/
theorem goes_of_le {x : Nat} {u : Nat × Nat} (le : need u ≤ x) : goes x u = true :=
  decide_eq_true le

/-- A unit does not go on where the level is below its need. -/
theorem goes_false_of_lt {x : Nat} {u : Nat × Nat} (lt : x < need u) : goes x u = false :=
  decide_eq_false (Nat.not_le_of_gt lt)

/-- Where a unit goes on, the level meets its need. -/
theorem le_of_goes {x : Nat} {u : Nat × Nat} (g : goes x u = true) : need u ≤ x :=
  of_decide_eq_true g

/-- A list that is not empty has a member. -/
theorem mem_of_ne_nil : ∀ {l : List (Nat × Nat)}, l ≠ [] → ∃ v, v ∈ l
  | [], ne => absurd rfl ne
  | v :: l, _ => ⟨v, .head l⟩

/-- A configuration that holds has some unit going on: its way is not empty and every unit's need is
met. Under any `y`. -/
theorem goes_of_holds {y : Nat → Nat} {s : List (Nat × Nat) × Nat} (holds : Holds y s) : Goes s :=
  match mem_of_ne_nil holds.1 with
  | ⟨v, mv⟩ => ⟨v, mv, holds.2.1 v mv⟩

/-- Where two properties of steps agree at each step at which the second held at every step before,
the one holds at every step exactly where the other does. For any `P` and `Q` on steps, by induction
on the step. -/
theorem all_iff_while {P Q : Nat → Prop} (agree : ∀ k, (∀ j, j < k → Q j) → (P k ↔ Q k)) :
    (∀ k, P k) ↔ ∀ k, Q k :=
  ⟨fun all =>
    have pre : ∀ k j, j < k → Q j := by
      intro k
      induction k with
      | zero => intro j lt; exact absurd lt (Nat.not_lt_zero j)
      | succ k ih =>
        intro j lt
        exact (Nat.lt_or_eq_of_le (Nat.le_of_lt_succ lt)).elim (ih j) fun e =>
          Eq.subst (motive := Q) e.symm ((agree k ih).mp (all k))
    fun k => pre (k + 1) k (Nat.lt_succ_self k),
   fun all k => (agree k fun j _ => all j).mpr (all k)⟩

/-- What `keep` keeps is no longer than the list. -/
theorem length_keep_le {α : Type} (p : α → Bool) :
    ∀ l : List α, (GrammarLaws.keep p l).length ≤ l.length
  | [] => Nat.le_refl 0
  | x :: l => by
    show (cond (p x) (x :: GrammarLaws.keep p l) (GrammarLaws.keep p l)).length ≤ l.length + 1
    cases p x with
    | true => exact Nat.succ_le_succ (length_keep_le p l)
    | false => exact Nat.le_succ_of_le (length_keep_le p l)

/-- Where a member of the list fails the test, what `keep` keeps is shorter than the list. -/
theorem length_keep_lt {α : Type} {p : α → Bool} :
    ∀ {l : List α} {a : α}, a ∈ l → p a = false → (GrammarLaws.keep p l).length < l.length
  | [], _, m, _ => nomatch m
  | x :: l, _, m, pa => by
    show (cond (p x) (x :: GrammarLaws.keep p l) (GrammarLaws.keep p l)).length < l.length + 1
    cases m with
    | head =>
      rw [pa]
      exact Nat.lt_succ_of_le (length_keep_le p l)
    | tail _ m' =>
      cases p x with
      | true => exact Nat.succ_lt_succ (length_keep_lt m' pa)
      | false => exact Nat.lt_succ_of_lt (length_keep_lt m' pa)

/-- At a level, either every unit of a way has its need met, or some unit's need is above the level;
decided by induction on the way. -/
theorem met_or_unmet (z : Nat) :
    ∀ S : List (Nat × Nat), (∀ u, u ∈ S → need u ≤ z) ∨ ∃ u, u ∈ S ∧ z < need u
  | [] => .inl fun _ m => nomatch m
  | v :: S => (Nat.lt_or_ge z (need v)).elim (fun lt => .inr ⟨v, .head S, lt⟩) fun le =>
      (met_or_unmet z S).elim
        (fun all => .inl fun u m => match u, m with
          | _, .head _ => le
          | u, .tail _ m' => all u m')
        (fun ⟨u, m, lt⟩ => .inr ⟨u, .tail v m, lt⟩)

/-- A unit is in the way after a step at `x` exactly where it was in the way and `x` meets its need. -/
theorem mem_after_iff {w : List (Nat × Nat)} {x : Nat} {u : Nat × Nat} :
    u ∈ after w x ↔ u ∈ w ∧ need u ≤ x :=
  (GrammarLaws.mem_keep (p := goes x) (l := w)).trans
    ⟨fun h => ⟨h.1, le_of_goes h.2⟩, fun h => ⟨h.1, goes_of_le h.2⟩⟩

/-- **The way after a step is the way exactly where every unit's need is met.** At any way `w` and
level `x`; one direction is `GrammarLaws.keep_all`, the other by the length of what is kept. -/
theorem after_eq_iff {w : List (Nat × Nat)} {x : Nat} : after w x = w ↔ ∀ u, u ∈ w → need u ≤ x :=
  ⟨fun same => match met_or_unmet x w with
    | .inl met => met
    | .inr ⟨_, m, lt⟩ => absurd
        (Nat.lt_of_lt_of_le (length_keep_lt m (goes_false_of_lt lt))
          (Nat.le_of_eq (congrArg List.length same.symm)))
        (Nat.lt_irrefl _),
   fun met => GrammarLaws.keep_all w fun u m => goes_of_le (met u m)⟩

/-- **A unit is present after `n` steps exactly where it was present at the start and its need was
met at every step before `n`.** Along the course from any `s`, under any giving. -/
theorem mem_course_iff (giving : Nat → Nat) (s : List (Nat × Nat) × Nat) (u : Nat × Nat) :
    ∀ n, u ∈ (course giving s n).1 ↔ u ∈ s.1 ∧ ∀ j, j < n → need u ≤ (course giving s j).2
  | 0 => ⟨fun m => ⟨m, fun _ lt => absurd lt (Nat.not_lt_zero _)⟩, fun h => h.1⟩
  | n + 1 =>
    (mem_after_iff (w := (course giving s n).1) (x := (course giving s n).2)).trans
      ⟨fun ⟨m, le⟩ => match (mem_course_iff giving s u n).mp m with
        | ⟨m0, before⟩ => ⟨m0, fun j lt => (Nat.lt_or_eq_of_le (Nat.le_of_lt_succ lt)).elim
            (before j)
            (fun e => Eq.subst (motive := fun i => need u ≤ (course giving s i).2) e.symm le)⟩,
       fun ⟨m0, before⟩ =>
        ⟨(mem_course_iff giving s u n).mpr ⟨m0, fun j lt => before j (Nat.lt_succ_of_lt lt)⟩,
          before n (Nat.lt_succ_self n)⟩⟩

/-- Whether some unit of a way goes on at `x`, computed along the way. -/
def anyGoes (x : Nat) : List (Nat × Nat) → Bool
  | [] => false
  | u :: w => goes x u || anyGoes x w

/-- `anyGoes` is true exactly where some unit of the way goes on at `x`. -/
theorem anyGoes_iff (x : Nat) :
    ∀ w : List (Nat × Nat), anyGoes x w = true ↔ ∃ u, u ∈ w ∧ need u ≤ x
  | [] => ⟨fun h => absurd h Bool.false_ne_true, fun ⟨_, m, _⟩ => nomatch m⟩
  | v :: w => by
    show (goes x v || anyGoes x w) = true ↔ _
    cases hv : goes x v with
    | true => exact ⟨fun _ => ⟨v, .head w, le_of_goes hv⟩, fun _ => rfl⟩
    | false =>
      exact (anyGoes_iff x w).trans
        ⟨fun ⟨u, m, le⟩ => ⟨u, .tail v m, le⟩,
         fun ⟨u, m, le⟩ => match u, m, le with
          | _, .head _, le => absurd (hv.symm.trans (goes_of_le le)) Bool.false_ne_true
          | u, .tail _ m', le => ⟨u, m', le⟩⟩

/-- Whether some unit of a way goes on at a level is decided, by `anyGoes`. -/
instance goesDecidable (s : List (Nat × Nat) × Nat) : Decidable (Goes s) :=
  decidable_of_iff (anyGoes s.2 s.1 = true) (anyGoes_iff s.2 s.1)

/-! ## 3. An ending while the net goes on -/

/-- **Where the level is below the need of one unit of the way and meets the need of another, the
line under the way's class ends there while the net goes on.** For units `p` and `q` of `w` with
`x < need p` and `need q ≤ x`, under any giving: `(w, x)` conditions something in the net, and nothing
of its way, since `p` is not in the way after the step. The counterpart of
`TurningInTime.kind_ends_while_net_goes` for the units' net. -/
theorem ends_while_net_goes {giving : Nat → Nat} {w : List (Nat × Nat)} {x : Nat} {p q : Nat × Nat}
    (mp : p ∈ w) (lt : x < need p) (mq : q ∈ w) (ge : need q ≤ x) :
    «亡» (net giving) (sameValue (Prod.fst : List (Nat × Nat) × Nat → List (Nat × Nat))) (w, x) ∧
      ∃ v, net giving (w, x) v :=
  ⟨fun ⟨_, ⟨_, e⟩, same⟩ =>
    Nat.not_le_of_gt lt ((mem_after_iff (w := w) (x := x)).mp
      (Eq.subst (motive := fun l => p ∈ l) ((same : w = _).trans (congrArg Prod.fst e)) mp)).2,
   ⟨TurningInTime.pair after (left giving) (w, x), ⟨q, mq, ge⟩, rfl⟩⟩

/-! ## 4. When the line never ends, for any number of units -/

/-- While every unit of `S` has its need met along the course of the level under what `S` takes, the
course from `(S, z)` is `S` with that level. Under any giving. -/
theorem fixed_while {giving : Nat → Nat} {S : List (Nat × Nat)} {z : Nat} :
    ∀ i, (∀ j, j < i → ∀ u, u ∈ S →
        need u ≤ Law.orbit (RegimeMargin.step giving (taken S)) z j) →
      course giving (S, z) i = (S, Law.orbit (RegimeMargin.step giving (taken S)) z i)
  | 0, _ => rfl
  | i + 1, met => by
    have same : after S (Law.orbit (RegimeMargin.step giving (taken S)) z i) = S :=
      GrammarLaws.keep_all S fun u m => goes_of_le (met i (Nat.lt_succ_self i) u m)
    show TurningInTime.pair after (left giving) (course giving (S, z) i) =
      (S, RegimeMargin.step giving (taken S) (Law.orbit (RegimeMargin.step giving (taken S)) z i))
    rw [fixed_while i fun j lt => met j (Nat.lt_succ_of_lt lt)]
    show (after S (Law.orbit (RegimeMargin.step giving (taken S)) z i),
        RegimeMargin.step giving (taken S) (Law.orbit (RegimeMargin.step giving (taken S)) z i)) =
      (S, RegimeMargin.step giving (taken S) (Law.orbit (RegimeMargin.step giving (taken S)) z i))
    rw [same]

/-- **Holding.** From `(S, z)` with every unit's need met at `z`, `z` at or above what `S` takes and
`yS`, and `z` at most `hi`, where giving meets what `S` takes from `yS` up to `hi` and the step under it
keeps the level within `hi`: at every step the course is `S` with the level of `S`'s own course, and
that level is at or above `z`. By `RegimeMargin.holds` and `fixed_while`. -/
theorem stays {giving : Nat → Nat} {S : List (Nat × Nat)} {yS hi z : Nat}
    (meets : RegimeMargin.Meets giving (taken S) yS hi) (keeps : RegimeMargin.Keeps giving (taken S) hi)
    (met : ∀ u, u ∈ S → need u ≤ z) (low : taken S + yS ≤ z) (high : z ≤ hi) (i : Nat) :
    course giving (S, z) i = (S, Law.orbit (RegimeMargin.step giving (taken S)) z i) ∧
      z ≤ Law.orbit (RegimeMargin.step giving (taken S)) z i :=
  ⟨fixed_while i fun j _ u m => Nat.le_trans (met u m) (RegimeMargin.holds meets keeps low high j).1,
   (RegimeMargin.holds meets keeps low high i).1⟩

/-- **Falling.** From `(S, z)` with `v` in `S`, every unit of `S` needing something, nothing given
from nothing, giving short of what `S` takes below `yS`, and `z` below what `S` takes and `yS`: at some
step the course from `(S, z)` still has the way `S`, and the level is below some unit's need. By
`RegimeMargin.ends_below`, `first_of_decided` and `fixed_while`. -/
theorem falls {giving : Nat → Nat} {S : List (Nat × Nat)} {yS z : Nat}
    (short : RegimeMargin.Short giving (taken S) yS) (nothing : RegimeMargin.FromNothing giving)
    (pos : ∀ u, u ∈ S → 0 < need u) {v : Nat × Nat} (mv : v ∈ S) (below : z < taken S + yS) :
    ∃ t, (course giving (S, z) t).1 = S ∧ ∃ u, u ∈ S ∧ (course giving (S, z) t).2 < need u :=
  have ended : Law.orbit (RegimeMargin.step giving (taken S)) z z = 0 :=
    RegimeMargin.ends_below short nothing below
  match first_of_decided
      (P := fun j => ∀ u, u ∈ S → need u ≤ Law.orbit (RegimeMargin.step giving (taken S)) z j)
      (Q := fun j => ∃ u, u ∈ S ∧ Law.orbit (RegimeMargin.step giving (taken S)) z j < need u)
      (fun _ => met_or_unmet _ S) z with
  | .inl all => absurd (Nat.le_trans (all z (Nat.le_refl z) v mv) (Nat.le_of_eq ended))
      (Nat.not_le_of_gt (pos v mv))
  | .inr ⟨t, _, unmet, before⟩ =>
    have at_t := fixed_while t before
    ⟨t, congrArg Prod.fst at_t,
      Eq.subst (motive := fun s : List (Nat × Nat) × Nat => ∃ u, u ∈ S ∧ s.2 < need u) at_t.symm
        unmet⟩

/-- **The level stays within `hi`.** From a start at most `hi`, where `Regime` holds at every way the
course reaches with some unit going on there and at every step before it, the start's included (only
its third clause, `Keeps`, is used): at every step the course reaches with some unit going on at every
step before it, the level is at most `hi`. -/
theorem course_within {giving y : Nat → Nat} {hi : Nat} {s : List (Nat × Nat) × Nat}
    (along : ∀ k, (∀ j, j ≤ k → Goes (course giving s j)) → Regime giving y hi (course giving s k).1)
    (high : s.2 ≤ hi) :
    ∀ k, (∀ j, j < k → Goes (course giving s j)) → (course giving s k).2 ≤ hi
  | 0, _ => high
  | k + 1, before =>
    (along k fun j le => before j (Nat.lt_succ_of_le le)).2.2 (course giving s k).2
      (course_within along high k fun j lt => before j (Nat.lt_succ_of_lt lt))

/-- Where some unit goes on at every step of the course from `(w, x)`, it reaches a configuration that
holds, by induction on a bound `ℓ` on the way's length at a step `k`: a step where some unit's need is
not met shortens the way; where every need is met below what the way takes and `y` of it, `falls`
shortens it later; otherwise the configuration holds. Premises: every unit of `w` needing something,
nothing given from nothing, and `Regime` at every way the course reaches with some unit going on there
and at every step before it, the start's included (only its first clause, `Short`, is used here). -/
theorem reaches_holds {giving y : Nat → Nat} {hi : Nat} {w : List (Nat × Nat)} {x : Nat}
    (needs : ∀ u, u ∈ w → 0 < need u) (nothing : RegimeMargin.FromNothing giving)
    (along : ∀ k, (∀ j, j ≤ k → Goes (course giving (w, x) j)) →
      Regime giving y hi (course giving (w, x) k).1)
    (all : ∀ k, Goes (course giving (w, x) k)) :
    ∀ ℓ k, (course giving (w, x) k).1.length ≤ ℓ → ∃ k', Holds y (course giving (w, x) k')
  | 0, k, short => match all k with
    | ⟨_, m, _⟩ => absurd short (Nat.not_le_of_gt (length_pos_of_mem m))
  | ℓ + 1, k, short =>
    match met_or_unmet (course giving (w, x) k).2 (course giving (w, x) k).1 with
    | .inr ⟨_, m, lt⟩ =>
      reaches_holds needs nothing along all ℓ (k + 1)
        (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le (length_keep_lt m (goes_false_of_lt lt)) short))
    | .inl met => match all k with
      | ⟨v, mv, _⟩ =>
        (Nat.lt_or_ge (course giving (w, x) k).2
            (taken (course giving (w, x) k).1 + y (taken (course giving (w, x) k).1))).elim
          (fun below =>
            match falls (along k fun j _ => all j).1 nothing
                (fun u m => needs u ((mem_course_iff giving (w, x) u k).mp m).1) mv below with
            | ⟨t, way, u, mu, unmet⟩ =>
              have at_t : course giving (w, x) (k + t) =
                  course giving ((course giving (w, x) k).1, (course giving (w, x) k).2) t :=
                Law.orbit_add _ _ k t
              reaches_holds needs nothing along all ℓ (k + t + 1) (by
                show (after (course giving (w, x) (k + t)).1
                  (course giving (w, x) (k + t)).2).length ≤ ℓ
                rw [at_t, way]
                exact Nat.le_of_lt_succ
                  (Nat.lt_of_lt_of_le (length_keep_lt mu (goes_false_of_lt unmet)) short)))
          (fun enough =>
            have none : ¬ v ∈ ([] : List (Nat × Nat)) := fun m => nomatch m
            ⟨k, fun e => none (Eq.subst (motive := fun l => v ∈ l) e mv), met, enough⟩)

/-- **When the line never ends, for any number of units (exact).** With every unit of `w` needing
something (`needs`), nothing given from nothing (`nothing`), the start at most `hi` (`high`), and, at
every way the course reaches with some unit going on there and at every step before it, the start's
included, giving short of what the way takes below `y` of it, meeting it from there up to `hi`, and the
step under it keeping the level within `hi` (`along`, `Regime`; stated along the course, not over every
sub-way of `w`, and not at the way where the net stops): the line from `(w, x)`
never ends exactly where, the net going on at every step before, the course comes to a configuration
that holds: a way that is not empty, every unit's need met at the level, and the level at or above what
the way takes and `y` of it (`Holds`). By `Law.stepWhile_unending_iff`, `reaches_holds` (with
`falls`, from `RegimeMargin.ends_below`) one way and `stays` (from `RegimeMargin.holds`) and
`course_within` the other. -/
theorem unending_iff_holds {giving y : Nat → Nat} {hi : Nat} {w : List (Nat × Nat)} {x : Nat}
    (needs : ∀ u, u ∈ w → 0 < need u) (nothing : RegimeMargin.FromNothing giving) (high : x ≤ hi)
    (along : ∀ k, (∀ j, j ≤ k → Goes (course giving (w, x) j)) →
      Regime giving y hi (course giving (w, x) k).1) :
    «不穷» (net giving) «一» (w, x) ↔
      ∃ k, (∀ j, j < k → Goes (course giving (w, x) j)) ∧ Holds y (course giving (w, x) k) :=
  Law.stepWhile_unending_iff.trans
    ⟨fun all => match reaches_holds needs nothing along all _ 0 (Nat.le_refl _) with
       | ⟨k, holds⟩ => ⟨k, fun j _ => all j, holds⟩,
     fun ⟨k, before, holds⟩ n =>
      have upto : ∀ j, j ≤ k → Goes (course giving (w, x) j) := fun j le =>
        (Nat.lt_or_eq_of_le le).elim (before j) fun e =>
          Eq.subst (motive := fun i => Goes (course giving (w, x) i)) e.symm (goes_of_holds holds)
      (Nat.lt_or_ge n k).elim (before n) fun ge =>
        match le_dest ge, holds with
        | ⟨i, e⟩, ⟨ne, met, low⟩ =>
          have s := stays (along k upto).2.1 (along k upto).2.2 met low
            (course_within along high k before) i
          have at_i : course giving (w, x) (k + i) =
              ((course giving (w, x) k).1,
                Law.orbit (RegimeMargin.step giving (taken (course giving (w, x) k).1))
                  (course giving (w, x) k).2 i) :=
            (Law.orbit_add _ _ k i).trans s.1
          match mem_of_ne_nil ne with
          | ⟨v, mv⟩ => Eq.subst (motive := fun j => Goes (course giving (w, x) j)) e.symm
              (Eq.subst (motive := Goes) at_i.symm ⟨v, mv, Nat.le_trans (met v mv) s.2⟩)⟩

/-! ## 5. Two units, and the tie to TurningInTime -/

/-- The carrier's way after a step: the first unit is still there (`true`) where it was there and the
level meets its need `m`. -/
def firstAfter (m : Nat) (b : Bool) (x : Nat) : Bool := b && decide (m ≤ x)

/-- What the way of two units takes: `h + H₂` with the first unit there, `H₂` once it has ended. -/
def firstUse (h H₂ : Nat) (b : Bool) : Nat := cond b (h + H₂) H₂

/-- The way of two units: both where the first is there, the second alone where the first has
ended. -/
def twoWay (m h n H₂ : Nat) (b : Bool) : List (Nat × Nat) := cond b [(m, h), (n, H₂)] [(n, H₂)]

/-- The carrier's course from the first unit there at the level `x`. -/
abbrev carrierCourse (giving : Nat → Nat) (m h H₂ x : Nat) : Nat → Bool × Nat :=
  Law.orbit (TurningInTime.pair (firstAfter m)
    (fun b z => RegimeMargin.step giving (firstUse h H₂ b) z)) (true, x)

/-- What the way of two units takes is the carrier's use. -/
theorem taken_twoWay (m h n H₂ : Nat) : ∀ b, taken (twoWay m h n H₂ b) = firstUse h H₂ b
  | true => rfl
  | false => rfl

/-- At a level that meets the second unit's need `n`, the way of two units after a step is the way
of the carrier after the step. -/
theorem after_twoWay {m h n H₂ z : Nat} (ge : n ≤ z) :
    ∀ b, after (twoWay m h n H₂ b) z = twoWay m h n H₂ (firstAfter m b z)
  | true => by
    show cond (goes z (m, h)) ((m, h) :: cond (goes z (n, H₂)) [(n, H₂)] [])
        (cond (goes z (n, H₂)) [(n, H₂)] []) =
      cond (decide (m ≤ z)) [(m, h), (n, H₂)] [(n, H₂)]
    exact congrArg (fun c => cond (goes z (m, h)) ((m, h) :: c) c)
      (congrArg (fun g => cond g [(n, H₂)] []) (goes_of_le (x := z) (u := (n, H₂)) ge))
  | false => by
    show cond (goes z (n, H₂)) [(n, H₂)] [] = [(n, H₂)]
    exact congrArg (fun g => cond g [(n, H₂)] []) (goes_of_le (x := z) (u := (n, H₂)) ge)

/-- With `n ≤ m`, some unit of the way of two units goes on at `z` exactly where `z` meets `n`. -/
theorem goes_twoWay {m h n H₂ z : Nat} (order : n ≤ m) :
    ∀ b, Goes (twoWay m h n H₂ b, z) ↔ n ≤ z
  | true => ⟨fun ⟨u, mu, le⟩ =>
      (match u, (mu : u ∈ [(m, h), (n, H₂)]), le with
      | _, .head _, le => Nat.le_trans order le
      | _, .tail _ (.head _), le => le
      | _, .tail _ (.tail _ m'), _ => nomatch m'),
    fun le => ⟨(n, H₂), .tail _ (.head _), le⟩⟩
  | false => ⟨fun ⟨u, mu, le⟩ =>
      (match u, (mu : u ∈ [(n, H₂)]), le with
      | _, .head _, le => le
      | _, .tail _ m', _ => nomatch m'),
    fun le => ⟨(n, H₂), .head _, le⟩⟩

/-- While the level of the carrier's course meets `n`, the units' course from both units is the way of
the carrier with the carrier's level. Under any giving. -/
theorem course_twoWay {giving : Nat → Nat} {m h n H₂ x : Nat} :
    ∀ k, (∀ j, j < k → n ≤ (carrierCourse giving m h H₂ x j).2) →
      course giving ([(m, h), (n, H₂)], x) k =
        (twoWay m h n H₂ (carrierCourse giving m h H₂ x k).1, (carrierCourse giving m h H₂ x k).2)
  | 0, _ => rfl
  | k + 1, before => by
    show TurningInTime.pair after (left giving) (course giving ([(m, h), (n, H₂)], x) k) =
      (twoWay m h n H₂ (firstAfter m (carrierCourse giving m h H₂ x k).1
          (carrierCourse giving m h H₂ x k).2),
        RegimeMargin.step giving (firstUse h H₂ (carrierCourse giving m h H₂ x k).1)
          (carrierCourse giving m h H₂ x k).2)
    rw [course_twoWay k fun j lt => before j (Nat.lt_succ_of_lt lt)]
    show (after (twoWay m h n H₂ (carrierCourse giving m h H₂ x k).1)
          (carrierCourse giving m h H₂ x k).2,
        RegimeMargin.step giving (taken (twoWay m h n H₂ (carrierCourse giving m h H₂ x k).1))
          (carrierCourse giving m h H₂ x k).2) = _
    rw [after_twoWay (before k (Nat.lt_succ_self k)), taken_twoWay]

/-- With `n ≤ m`, some unit goes on at every step of the units' course from both units at `x` exactly
where the level of the carrier's course from `true` at `x` meets `n` at every step. Under any giving;
by `course_twoWay`, `goes_twoWay` and `all_iff_while`. -/
theorem goes_iff_carrier {giving : Nat → Nat} {m h n H₂ x : Nat} (order : n ≤ m) :
    (∀ k, Goes (course giving ([(m, h), (n, H₂)], x) k)) ↔
      ∀ k, n ≤ (carrierCourse giving m h H₂ x k).2 :=
  all_iff_while fun k before =>
    Eq.subst (motive := fun s => Goes s ↔ n ≤ (carrierCourse giving m h H₂ x k).2)
      (course_twoWay k before).symm (goes_twoWay order _)

/-- **The transfer.** With `n ≤ m`, the units' line from both units at `x` never ends exactly where
the carrier's line from `true` at `x`, under TurningInTime's net at the need `n`, never ends. Under any
giving. -/
theorem unending_iff_carrier {giving : Nat → Nat} {m h n H₂ x : Nat} (order : n ≤ m) :
    «不穷» (net giving) «一» ([(m, h), (n, H₂)], x) ↔
      «不穷» (TurningInTime.net n (firstAfter m)
        (fun b z => RegimeMargin.step giving (firstUse h H₂ b) z)) «一» (true, x) :=
  Law.stepWhile_unending_iff.trans ((goes_iff_carrier order).trans
    (Law.stepWhile_unending_iff (can := fun s : Bool × Nat => n ≤ s.2)
      (next := TurningInTime.pair (firstAfter m)
        (fun b z => RegimeMargin.step giving (firstUse h H₂ b) z)) (s := (true, x))).symm)

/-- Outside the levels below `m`, the carrier's way after a step is the way: `AloneOutside` with
`alone := id`, proved. -/
theorem first_outside (m : Nat) : TurningInTime.AloneOutside (fun z => z < m) id (firstAfter m) :=
  fun b z nm => by
    have ge : m ≤ z := Nat.ge_of_not_lt nm
    show (b && decide (m ≤ z)) = b
    rw [decide_eq_true ge]
    cases b <;> rfl

/-- At a level below `m`, the carrier's way after a step is `false`, the first unit ended: `turns`,
proved. -/
theorem first_turns (m : Nat) : ∀ b z, z < m → firstAfter m b z = false :=
  fun b z lt => by
    show (b && decide (m ≤ z)) = false
    rw [decide_eq_false (Nat.not_le_of_gt lt)]
    cases b <;> rfl

/-- Once ended, the first unit stays ended: `kept`, proved. -/
theorem first_kept (m : Nat) : ∀ b z, b = false → firstAfter m b z = false :=
  fun b _ k => by subst k; rfl

/-- With the first unit ended, the way takes `H₂`: `uses`, proved. -/
theorem first_uses (h H₂ : Nat) : ∀ b, b = false → firstUse h H₂ b = H₂ :=
  fun b k => by subst k; rfl

/-- The first unit there, left where it is, stays there. The same as `TurningInTime.Three.orbit_id`,
which is private there. -/
theorem orbit_id_true : ∀ j, Law.orbit (id : Bool → Bool) true j = true
  | 0 => rfl
  | j + 1 => orbit_id_true j

/-- Along the course as it was the way takes `h + H₂`: `uses₁`, proved. -/
theorem first_uses₁ (h H₂ : Nat) : ∀ j, h + H₂ ≤ firstUse h H₂ (Law.orbit id true j) :=
  fun j => Nat.le_of_eq (congrArg (firstUse h H₂) (orbit_id_true j)).symm

/-- The carrier's course as it was is the first unit there with the level's course under `h + H₂`. -/
theorem asItWas_first {giving : Nat → Nat} {h H₂ x : Nat} : ∀ j,
    Law.orbit (TurningInTime.asItWas id (fun b z => RegimeMargin.step giving (firstUse h H₂ b) z))
      (true, x) j = (true, Law.orbit (RegimeMargin.step giving (h + H₂)) x j)
  | 0 => rfl
  | j + 1 => congrArg
      (TurningInTime.asItWas id (fun b z => RegimeMargin.step giving (firstUse h H₂ b) z))
      (asItWas_first j)

/-- **Two units: the tie to `turns_in_time_iff` (exact).** For a first unit needing `m` and taking `h`
and a second needing `n` and taking `H₂`, with `n ≤ m` (`order`), nothing given from nothing, giving
short of `H₂` below `y₂`, meeting it from `y₂` up to `hi` and the step under `H₂` keeping the level
within `hi`, a positive `n` at most `H₂ + y₂`, giving short of `h + H₂` below `y₁`, and the start `x`
below `h + H₂ + y₁` and at most `hi`: the line from both units at `x` never ends exactly where there is
a step `T` of the course as it was (the level's course under `h + H₂`) with the level at or above `m`
before it, `n` met and the level below `m` at it, and the level one step later at or above `H₂ + y₂`.
By `turns_in_time_iff` on the carrier `Bool` with `marked := (· < m)`, `alone := id`,
`Kept b := b = false`, `H₁ := h + H₂`, whose `AloneOutside`, `turns`, `kept`, `uses`, `uses₁` are
proved here, and `unending_iff_carrier`. -/
theorem two_units_iff {giving : Nat → Nat} {m h n H₂ y₁ y₂ hi x : Nat}
    (order : n ≤ m) (nothing : RegimeMargin.FromNothing giving)
    (short : RegimeMargin.Short giving H₂ y₂) (meets : RegimeMargin.Meets giving H₂ y₂ hi)
    (keeps : RegimeMargin.Keeps giving H₂ hi) (needs : 0 < n) (within : n ≤ H₂ + y₂)
    (short₁ : RegimeMargin.Short giving (h + H₂) y₁) (below : x < h + H₂ + y₁) (high : x ≤ hi) :
    «不穷» (net giving) «一» ([(m, h), (n, H₂)], x) ↔
      ∃ T, (∀ j, j < T → m ≤ Law.orbit (RegimeMargin.step giving (h + H₂)) x j) ∧
        n ≤ Law.orbit (RegimeMargin.step giving (h + H₂)) x T ∧
        Law.orbit (RegimeMargin.step giving (h + H₂)) x T < m ∧
        H₂ + y₂ ≤ Law.orbit (RegimeMargin.step giving (h + H₂)) x (T + 1) :=
  have same : ∀ j, (Law.orbit (TurningInTime.asItWas id
      (fun b z => RegimeMargin.step giving (firstUse h H₂ b) z)) (true, x) j).2 =
        Law.orbit (RegimeMargin.step giving (h + H₂)) x j :=
    fun j => congrArg Prod.snd (asItWas_first j)
  (unending_iff_carrier (giving := giving) (h := h) (H₂ := H₂) (x := x) order).trans
    ((TurningInTime.turns_in_time_iff (marked := fun z => z < m) (alone := id)
        (after := firstAfter m) (Kept := fun b => b = false) (giving := giving)
        (use := firstUse h H₂) (H₁ := h + H₂) (y₁ := y₁) (H₂ := H₂) (y₂ := y₂) (hi := hi)
        (need := n) (w := true) (x := x)
        (first_outside m) (first_turns m) (first_kept m) (first_uses h H₂) nothing short meets
        keeps needs within short₁ (first_uses₁ h H₂) below high).trans
      ⟨fun ⟨T, before, atT, markedT, enough⟩ =>
        ⟨T, fun j lt => Nat.le_trans (Nat.ge_of_not_lt (before j lt).2) (Nat.le_of_eq (same j)),
          Nat.le_trans atT (Nat.le_of_eq (same T)),
          Nat.lt_of_le_of_lt (Nat.le_of_eq (same T).symm) markedT,
          Nat.le_trans enough (Nat.le_of_eq (same (T + 1)))⟩,
       fun ⟨T, before, atT, belowT, enough⟩ =>
        ⟨T, fun j lt =>
            ⟨Nat.le_trans order (Nat.le_trans (before j lt) (Nat.le_of_eq (same j).symm)),
             fun l => Nat.not_le_of_gt l (Nat.le_trans (before j lt) (Nat.le_of_eq (same j).symm))⟩,
          Nat.le_trans atT (Nat.le_of_eq (same T).symm),
          Nat.lt_of_le_of_lt (Nat.le_of_eq (same T)) belowT,
          Nat.le_trans enough (Nat.le_of_eq (same (T + 1)).symm)⟩⟩)

/-! ## 6. A line of two units that never ends stays at or above `H₂ + y₂`, below which the level under the second unit's use falls -/

/-- The carrier's step: the way after a step (`firstAfter`) and the level under what the way takes
(`firstUse`). The step of `carrierCourse`. -/
abbrev carrierStep (giving : Nat → Nat) (m h H₂ : Nat) : Bool × Nat → Bool × Nat :=
  TurningInTime.pair (firstAfter m) (fun b z => RegimeMargin.step giving (firstUse h H₂ b) z)

/-- **Below `H + y`, a step lowers the level or leaves nothing.** With giving short of
`H` below `y` (`short`), nothing given from nothing (`nothing`), a use `U` at least `H` (`more`) and a
level `z` below `H + y` (`below`): the step under `U` leaves nothing, or less than `z`. Where `z` is
below `U` the step takes all of it and nothing is given from nothing; otherwise what is left is below
`y`, and giving there is short of `H`, so of `U`. -/
theorem step_falls {giving : Nat → Nat} {H y U z : Nat} (short : RegimeMargin.Short giving H y)
    (nothing : RegimeMargin.FromNothing giving) (more : H ≤ U) (below : z < H + y) :
    RegimeMargin.step giving U z = 0 ∨ RegimeMargin.step giving U z < z :=
  (Nat.lt_or_ge z U).elim
    (fun lt =>
      have gone : z - U = 0 := sub_eq_zero_of_le (Nat.le_of_lt lt)
      .inl (by
        show z - U + giving (z - U) = 0
        rw [gone]
        exact (Nat.zero_add (giving 0)).trans nothing))
    (fun ge =>
      have leftBelow : z - U < y := (Nat.lt_or_ge (z - U) y).elim id fun atLeast =>
        absurd (Nat.le_trans (Nat.add_le_add more atLeast) (Nat.le_of_eq (add_sub_of_le ge)))
          (Nat.not_le_of_gt below)
      have less : giving (z - U) < U := Nat.lt_of_lt_of_le (short (z - U) leftBelow) more
      .inr (Nat.lt_of_lt_of_le (Nat.add_lt_add_left less (z - U))
        (Nat.le_of_eq (Naturals.sub_add_cancel ge))))

/-- What the way of two units takes is at least `U` wherever the second unit's use `H₂` is
(`low : U ≤ H₂`), whether the first unit is there or has ended. -/
theorem use_at_least {h H₂ U : Nat} (low : U ≤ H₂) : ∀ b, U ≤ firstUse h H₂ b
  | true => Nat.le_trans low (Nat.le_add_left H₂ h)
  | false => low

/-- **From a level below `U + y`, the carrier's level falls at every step until it is nothing.** With `U ≤ H₂` (`low`), giving short of `U` below `y` (`short`), nothing given from
nothing (`nothing`) and the level at step `k` below `U + y` (`below`): `j` steps later the level is
nothing, or at least `j` below the level at `k`. By `step_falls` and `use_at_least`, by induction on
`j`. -/
theorem carrier_falls {giving : Nat → Nat} {m h H₂ U y x k : Nat} (low : U ≤ H₂)
    (short : RegimeMargin.Short giving U y) (nothing : RegimeMargin.FromNothing giving)
    (below : (carrierCourse giving m h H₂ x k).2 < U + y) :
    ∀ j, (carrierCourse giving m h H₂ x (k + j)).2 = 0 ∨
      (carrierCourse giving m h H₂ x (k + j)).2 + j ≤ (carrierCourse giving m h H₂ x k).2
  | 0 => .inr (Nat.le_refl _)
  | j + 1 =>
    have prev := carrier_falls (m := m) (h := h) (x := x) low short nothing below j
    have curBelow : (carrierCourse giving m h H₂ x (k + j)).2 < U + y := prev.elim
      (fun zero => Nat.lt_of_le_of_lt (Nat.le_of_eq zero)
        (Nat.lt_of_le_of_lt (Nat.zero_le _) below))
      (fun le => Nat.lt_of_le_of_lt (Nat.le_trans (Nat.le_add_right _ j) le) below)
    have falls := step_falls (U := firstUse h H₂ (carrierCourse giving m h H₂ x (k + j)).1)
      short nothing (use_at_least low _) curBelow
    falls.elim .inl fun lt =>
      .inr (prev.elim
        (fun zero => absurd (Nat.lt_of_lt_of_le lt (Nat.le_of_eq zero)) (Nat.not_lt_zero _))
        (fun le =>
          have moved : RegimeMargin.step giving
                (firstUse h H₂ (carrierCourse giving m h H₂ x (k + j)).1)
                (carrierCourse giving m h H₂ x (k + j)).2 + j + 1 ≤
              (carrierCourse giving m h H₂ x k).2 :=
            Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm _ 1 j).symm)
              (Nat.le_trans (Nat.add_le_add_right (Nat.succ_le_of_lt lt) j) le)
          moved))

/-- **While the second unit's need is met at every step, the carrier's level stays at or above
`U + y`.** With `U ≤ H₂` (`low`), giving short of `U` below `y` (`short`), nothing given from nothing
(`nothing`), `0 < n` (`needs`) and `n` met at every step of the carrier's course from `true` at `x`
(`all`): every level of that course is at or above `U + y`. From a level below it the level is
nothing within as many steps as it stood (`carrier_falls`), below `n`. -/
theorem carrier_above {giving : Nat → Nat} {m h n H₂ U y x : Nat} (low : U ≤ H₂)
    (short : RegimeMargin.Short giving U y) (nothing : RegimeMargin.FromNothing giving)
    (needs : 0 < n) (all : ∀ k, n ≤ (carrierCourse giving m h H₂ x k).2) (k : Nat) :
    U + y ≤ (carrierCourse giving m h H₂ x k).2 :=
  (Nat.lt_or_ge (carrierCourse giving m h H₂ x k).2 (U + y)).elim
    (fun below =>
      have gone : (carrierCourse giving m h H₂ x (k + (carrierCourse giving m h H₂ x k).2)).2 ≤ 0 :=
        (carrier_falls low short nothing below (carrierCourse giving m h H₂ x k).2).elim
          Nat.le_of_eq
          (fun le => le_of_add_le_add_right _ (Nat.le_trans le (Nat.le_of_eq (Nat.zero_add _).symm)))
      absurd (Nat.lt_of_lt_of_le needs (Nat.le_trans (all _) gone)) (Nat.lt_irrefl 0))
    id

/-- **A line of two units that never ends stays at or above `H + y`, below which the level under the
second unit's use falls.** With `n ≤ m` (`order`), nothing given from nothing (`nothing`), giving short of `H`
below `y` (`short`) and `0 < n` (`needs`), under any `h` and from any start `x`: if the line from a
first unit needing `m` and taking `h` and a second needing `n` and taking `H` never ends, every level
of its course is at or above `H + y`. By `goes_iff_carrier`, `carrier_above` at `U := H` and
`course_twoWay`. At `n = 0` the line never ends from any start (`unending_needs_nothing`), below
`H + y` too; `needs` is asked for that reason. -/
theorem unending_above {giving : Nat → Nat} {m h n H y x : Nat} (order : n ≤ m)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (needs : 0 < n) (never : «不穷» (net giving) «一» ([(m, h), (n, H)], x)) :
    ∀ k, H + y ≤ (course giving ([(m, h), (n, H)], x) k).2 :=
  have all : ∀ k, n ≤ (carrierCourse giving m h H x k).2 :=
    (goes_iff_carrier order).mp (Law.stepWhile_unending_iff.mp never)
  fun k => Nat.le_trans (carrier_above (Nat.le_refl H) short nothing needs all k)
    (Nat.le_of_eq (congrArg Prod.snd (course_twoWay (n := n) k fun j _ => all j)).symm)

/-- **With a second unit that needs nothing, the line never ends.** Under any giving, for any `m`,
`h`, `H` and from any start `x`: the line from a first unit needing `m` and taking `h` and a second
needing nothing and taking `H` never ends, since the second unit goes on at every level
(`goes_iff_carrier`). -/
theorem unending_needs_nothing {giving : Nat → Nat} {m h H x : Nat} :
    «不穷» (net giving) «一» ([(m, h), (0, H)], x) :=
  Law.stepWhile_unending_iff.mpr ((goes_iff_carrier (Nat.zero_le m)).mpr fun _ => Nat.zero_le _)

/-- The step under `Keeps` at the second unit's use `H₂` keeps the level within `hi` whatever the way
of two units takes: at `h + H₂` it is the step under `H₂` from what is left after `h`, which is at
most the level. Premise: `Keeps` at `H₂` up to `hi` (`keeps`). -/
theorem keeps_use {giving : Nat → Nat} {h H₂ hi : Nat} (keeps : RegimeMargin.Keeps giving H₂ hi) :
    ∀ b, RegimeMargin.Keeps giving (firstUse h H₂ b) hi
  | true => fun z le => by
    show z - (h + H₂) + giving (z - (h + H₂)) ≤ hi
    rw [← Naturals.sub_sub z h H₂]
    exact keeps (z - h) (Nat.le_trans (Nat.sub_le z h) le)
  | false => keeps

/-- **The carrier's level stays within `hi`.** With the step under `H₂` keeping the level within `hi`
(`keeps`) and the start at most `hi` (`high`): every level of the carrier's course from `true` at `x`
is at most `hi`. By `keeps_use`, by induction on the step. -/
theorem carrier_within {giving : Nat → Nat} {m h H₂ hi x : Nat}
    (keeps : RegimeMargin.Keeps giving H₂ hi) (high : x ≤ hi) :
    ∀ k, (carrierCourse giving m h H₂ x k).2 ≤ hi
  | 0 => high
  | k + 1 => keeps_use (h := h) keeps (carrierCourse giving m h H₂ x k).1
      (carrierCourse giving m h H₂ x k).2 (carrier_within keeps high k)

/-- **The second unit alone holds from at or above `H₂ + y`.** With giving meeting `H₂` from `y` up to
`hi` (`meets`) and the step under `H₂` keeping the level within `hi` (`keeps`): from a carrier
configuration with the first unit ended, `n` met, the level at or above `H₂ + y` and at most `hi`,
the next has the first unit ended, `n` met and the level at or above `H₂ + y`. By
`RegimeMargin.holds`, one step. -/
theorem alone_holds {giving : Nat → Nat} {m h n H₂ y hi : Nat}
    (meets : RegimeMargin.Meets giving H₂ y hi) (keeps : RegimeMargin.Keeps giving H₂ hi) :
    ∀ s : Bool × Nat, s.1 = false → n ≤ s.2 → H₂ + y ≤ s.2 → s.2 ≤ hi →
      (carrierStep giving m h H₂ s).1 = false ∧ n ≤ (carrierStep giving m h H₂ s).2 ∧
        H₂ + y ≤ (carrierStep giving m h H₂ s).2
  | (false, z), _, met, low, high =>
    have up : z ≤ RegimeMargin.step giving H₂ z := (RegimeMargin.holds meets keeps low high 1).1
    ⟨rfl, Nat.le_trans met up, Nat.le_trans low up⟩
  | (true, _), ended, _, _, _ => absurd ended.symm Bool.false_ne_true

/-! ## 7. Comparisons of two units -/

/-- At a level that meets `m'`, with `m ≤ m'` (`more`), the carrier's step with the first unit needing
`m'` is its step with it needing `m`: the first unit, there or ended, stays so in both. -/
theorem step_above_need {giving : Nat → Nat} {m m' h H₂ : Nat} (more : m ≤ m') :
    ∀ s : Bool × Nat, m' ≤ s.2 → carrierStep giving m' h H₂ s = carrierStep giving m h H₂ s
  | (b, z), ge => by
    show (b && decide (m' ≤ z), RegimeMargin.step giving (firstUse h H₂ b) z) =
      (b && decide (m ≤ z), RegimeMargin.step giving (firstUse h H₂ b) z)
    rw [decide_eq_true ge, decide_eq_true (Nat.le_trans more ge)]

/-- Along the carrier's courses from `true` at `x`, with the first unit needing `m'` and needing `m`:
at every step they are the same, or the first has the first unit ended, `n` met and the level at or
above `H₂ + y₂`. Premises: `m ≤ m'` (`more`), nothing given from nothing (`nothing`), `Short`, `Meets`,
`Keeps` at `H₂` from `y₂` up to `hi` (`short`, `meets`, `keeps`), the start at most `hi` (`high`),
`0 < n` (`needs`), and `n` met at every step of the course with `m` (`all`). The two leave each other
at the first level below `m'`, the first unit there or already ended in both; from there
`carrier_above` and `alone_holds`. -/
theorem greater_need_along {giving : Nat → Nat} {m m' h n H₂ y₂ hi x : Nat} (more : m ≤ m')
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H₂ y₂)
    (meets : RegimeMargin.Meets giving H₂ y₂ hi) (keeps : RegimeMargin.Keeps giving H₂ hi)
    (high : x ≤ hi) (needs : 0 < n) (all : ∀ k, n ≤ (carrierCourse giving m h H₂ x k).2) :
    ∀ k, carrierCourse giving m' h H₂ x k = carrierCourse giving m h H₂ x k ∨
      ((carrierCourse giving m' h H₂ x k).1 = false ∧ n ≤ (carrierCourse giving m' h H₂ x k).2 ∧
        H₂ + y₂ ≤ (carrierCourse giving m' h H₂ x k).2)
  | 0 => .inl rfl
  | k + 1 => match greater_need_along more nothing short meets keeps high needs all k with
    | .inr ⟨ended, met, low⟩ => .inr (alone_holds (m := m') (h := h) meets keeps _ ended met low
        (carrier_within (m := m') (h := h) keeps high k))
    | .inl same =>
      have next : carrierCourse giving m' h H₂ x (k + 1) =
          carrierStep giving m' h H₂ (carrierCourse giving m h H₂ x k) :=
        congrArg (carrierStep giving m' h H₂) same
      (Nat.lt_or_ge (carrierCourse giving m h H₂ x k).2 m').elim
        (fun lt => .inr (Eq.subst
          (motive := fun s : Bool × Nat => s.1 = false ∧ n ≤ s.2 ∧ H₂ + y₂ ≤ s.2) next.symm
          ⟨first_turns m' (carrierCourse giving m h H₂ x k).1 (carrierCourse giving m h H₂ x k).2 lt,
           all (k + 1), carrier_above (Nat.le_refl H₂) short nothing needs all (k + 1)⟩))
        (fun ge => .inl (next.trans (step_above_need more _ ge)))

/-- **A greater need of the first unit never ends a line that did not end.** With `n ≤ m` (`order`),
`m ≤ m'` (`more`), nothing given from nothing (`nothing`), giving short of `H₂` below `y₂` (`short`),
meeting it from `y₂` up to `hi` (`meets`), the step under `H₂` keeping the level within `hi`
(`keeps`), and the start at most `hi` (`high`); under any `h` and any `n`: if the line with the first
unit needing `m` never ends, neither does the line with it needing `m'`. At `n = 0` both lines never
end. Otherwise the line with `m'` has the course of the line with `m` until a level below `m'` with
the first unit there; one step later its level is the other line's, so `n` is met and it is at or
above `H₂ + y₂` (`carrier_above`, as in `unending_above`), and from there the second unit alone holds
(`alone_holds`, `RegimeMargin.holds`, within `hi` by `carrier_within`): `greater_need_along`. -/
theorem greater_need {giving : Nat → Nat} {m m' h n H₂ y₂ hi x : Nat}
    (order : n ≤ m) (more : m ≤ m') (nothing : RegimeMargin.FromNothing giving)
    (short : RegimeMargin.Short giving H₂ y₂) (meets : RegimeMargin.Meets giving H₂ y₂ hi)
    (keeps : RegimeMargin.Keeps giving H₂ hi) (high : x ≤ hi) :
    «不穷» (net giving) «一» ([(m, h), (n, H₂)], x) →
      «不穷» (net giving) «一» ([(m', h), (n, H₂)], x) :=
  fun never =>
    have all : ∀ k, n ≤ (carrierCourse giving m h H₂ x k).2 :=
      (goes_iff_carrier order).mp (Law.stepWhile_unending_iff.mp never)
    Law.stepWhile_unending_iff.mpr ((goes_iff_carrier (Nat.le_trans order more)).mpr
      ((Nat.lt_or_ge 0 n).elim
        (fun needs k => (greater_need_along more nothing short meets keeps high needs all k).elim
          (fun same => Nat.le_trans (all k) (Nat.le_of_eq (congrArg Prod.snd same).symm))
          (fun alone => alone.2.1))
        (fun zero _ => Nat.le_trans zero (Nat.zero_le _))))

/-- With the same sum taken (`sum : h + H₂ = h' + H₂'`), the carrier's step with the first unit there
is the same under the uses `h, H₂` and `h', H₂'`. -/
theorem step_same_sum {giving : Nat → Nat} {m h H₂ h' H₂' : Nat} (sum : h + H₂ = h' + H₂') :
    ∀ s : Bool × Nat, s.1 = true → carrierStep giving m h' H₂' s = carrierStep giving m h H₂ s
  | (true, z), _ => by
    show (firstAfter m true z, RegimeMargin.step giving (h' + H₂') z) =
      (firstAfter m true z, RegimeMargin.step giving (h + H₂) z)
    rw [sum]
  | (false, _), there => absurd there Bool.false_ne_true

/-- The first unit is there or has ended. -/
theorem there_or_ended : ∀ b : Bool, b = true ∨ b = false
  | true => .inl rfl
  | false => .inr rfl

/-- Along the carrier's courses from `true` at `x`, with the uses `h', H₂'` and `h, H₂`: at every step
they are the same, or the first has the first unit ended, `n` met and the level at or above
`H₂' + y₂'`. Premises: nothing given from nothing (`nothing`), `Short`, `Meets`, `Keeps` at `H₂'` from
`y₂'` up to `hi` (`short'`, `meets'`, `keeps'`), the same sum taken (`sum`), `H₂' ≤ H₂` (`lessUse`),
the start at most `hi` (`high`), `0 < n` (`needs`), and `n` met at every step of the course with
`h, H₂` (`all`). The two leave each other where the first unit has ended; every level of the course
with `h, H₂` is at or above `H₂' + y₂'` (`carrier_above` at `U := H₂'`), and from there
`alone_holds`. -/
theorem more_use_along {giving : Nat → Nat} {m n h H₂ h' H₂' y₂' hi x : Nat}
    (nothing : RegimeMargin.FromNothing giving) (short' : RegimeMargin.Short giving H₂' y₂')
    (meets' : RegimeMargin.Meets giving H₂' y₂' hi) (keeps' : RegimeMargin.Keeps giving H₂' hi)
    (sum : h + H₂ = h' + H₂') (lessUse : H₂' ≤ H₂) (high : x ≤ hi) (needs : 0 < n)
    (all : ∀ k, n ≤ (carrierCourse giving m h H₂ x k).2) :
    ∀ k, carrierCourse giving m h' H₂' x k = carrierCourse giving m h H₂ x k ∨
      ((carrierCourse giving m h' H₂' x k).1 = false ∧ n ≤ (carrierCourse giving m h' H₂' x k).2 ∧
        H₂' + y₂' ≤ (carrierCourse giving m h' H₂' x k).2)
  | 0 => .inl rfl
  | k + 1 => match more_use_along nothing short' meets' keeps' sum lessUse high needs all k with
    | .inr ⟨ended, met, low⟩ => .inr (alone_holds (m := m) (h := h') meets' keeps' _ ended met low
        (carrier_within (m := m) (h := h') keeps' high k))
    | .inl same =>
      have next : carrierCourse giving m h' H₂' x (k + 1) =
          carrierStep giving m h' H₂' (carrierCourse giving m h H₂ x k) :=
        congrArg (carrierStep giving m h' H₂') same
      (there_or_ended (carrierCourse giving m h H₂ x k).1).elim
        (fun there => .inl (next.trans (step_same_sum sum _ there)))
        (fun ended => .inr (Eq.subst
          (motive := fun s : Bool × Nat => s.1 = false ∧ n ≤ s.2 ∧ H₂' + y₂' ≤ s.2) next.symm
          (alone_holds (m := m) (h := h') meets' keeps' _ ended (all k)
            (carrier_above lessUse short' nothing needs all k)
            (Nat.le_trans (Nat.le_of_eq (congrArg Prod.snd same).symm)
              (carrier_within (m := m) (h := h') keeps' high k)))))

/-- **More of the use on the first unit never ends a line that did not end.** With `n ≤ m` (`order`),
nothing given from nothing (`nothing`), giving short of `H₂'` below `y₂'` (`short'`), meeting it from
`y₂'` up to `hi` (`meets'`), the step under `H₂'` keeping the level within `hi` (`keeps'`), the same
sum taken `h + H₂ = h' + H₂'` (`sum`), `h ≤ h'` (`more`), and the start at most `hi` (`high`); no
regime at `H₂`: if the line with the first unit taking `h` and the second `H₂` never ends, neither does
the line with them taking `h'` and `H₂'`. At `n = 0` both lines never end. Otherwise, while the first
unit is there both lines take the same sum and have the same course; every level of the first line is
at or above `H₂' + y₂'`, since `H₂' ≤ H₂` and below it the level would come to nothing
(`carrier_above`); so where the first unit has ended, the second unit alone taking `H₂'` holds
(`alone_holds`, `RegimeMargin.holds`, within `hi` by `carrier_within`): `more_use_along`. -/
theorem more_use_on_first {giving : Nat → Nat} {m n h H₂ h' H₂' y₂' hi x : Nat}
    (order : n ≤ m) (nothing : RegimeMargin.FromNothing giving)
    (short' : RegimeMargin.Short giving H₂' y₂') (meets' : RegimeMargin.Meets giving H₂' y₂' hi)
    (keeps' : RegimeMargin.Keeps giving H₂' hi) (sum : h + H₂ = h' + H₂') (more : h ≤ h')
    (high : x ≤ hi) :
    «不穷» (net giving) «一» ([(m, h), (n, H₂)], x) →
      «不穷» (net giving) «一» ([(m, h'), (n, H₂')], x) :=
  fun never =>
    have all : ∀ k, n ≤ (carrierCourse giving m h H₂ x k).2 :=
      (goes_iff_carrier order).mp (Law.stepWhile_unending_iff.mp never)
    have lessUse : H₂' ≤ H₂ := Naturals.le_of_add_le_add_left (k := h)
      (Nat.le_trans (Nat.add_le_add_right more H₂') (Nat.le_of_eq sum.symm))
    Law.stepWhile_unending_iff.mpr ((goes_iff_carrier order).mpr
      ((Nat.lt_or_ge 0 n).elim
        (fun needs k =>
          (more_use_along nothing short' meets' keeps' sum lessUse high needs all k).elim
            (fun same => Nat.le_trans (all k) (Nat.le_of_eq (congrArg Prod.snd same).symm))
            (fun alone => alone.2.1))
        (fun zero _ => Nat.le_trans zero (Nat.zero_le _))))

/-! ## 8. A unit that takes nothing -/

/-- With the first unit taking nothing, the carrier's use is `H₂` whether the first unit is there or
has ended. -/
theorem firstUse_zero (H₂ : Nat) : ∀ b, firstUse 0 H₂ b = H₂
  | true => Nat.zero_add H₂
  | false => rfl

/-- With the first unit taking nothing, the level of the carrier's course is the level's course under
`H₂`. Under any giving, from any start. -/
theorem carrier_level_zero {giving : Nat → Nat} {m H₂ x : Nat} :
    ∀ k, (carrierCourse giving m 0 H₂ x k).2 = Law.orbit (RegimeMargin.step giving H₂) x k
  | 0 => rfl
  | k + 1 =>
    (congrArg (fun H => RegimeMargin.step giving H (carrierCourse giving m 0 H₂ x k).2)
      (firstUse_zero H₂ (carrierCourse giving m 0 H₂ x k).1)).trans
      (congrArg (RegimeMargin.step giving H₂) (carrier_level_zero k))

/-- Some unit goes on at every step of the course from the second unit alone at `x` exactly where the
level's course under `H₂` meets `n` at every step. Under any giving; by `fixed_while`, `goes_twoWay`
and `all_iff_while`. -/
theorem goes_iff_alone {giving : Nat → Nat} {n H₂ x : Nat} :
    (∀ k, Goes (course giving ([(n, H₂)], x) k)) ↔
      ∀ k, n ≤ Law.orbit (RegimeMargin.step giving H₂) x k :=
  all_iff_while fun k before =>
    Eq.subst (motive := fun s => Goes s ↔ n ≤ Law.orbit (RegimeMargin.step giving H₂) x k)
      (fixed_while (giving := giving) (S := [(n, H₂)]) (z := x) k fun j lt u mu =>
        match u, mu with
        | _, .head _ => before j lt
        | _, .tail _ m' => nomatch m').symm
      (goes_twoWay (m := n) (h := 0) (Nat.le_refl n) false)

/-- **With a unit that takes nothing, there or ended, the line is the other unit's alone (exact).**
With `n ≤ m` (`order`), under any giving and from any start `x`: the line from a first unit needing
`m` and taking nothing and a second needing `n` and taking `H₂` never ends exactly where the line from
the second unit alone never ends. Some unit goes on exactly where `n` is met (`goes_iff_carrier`,
`goes_iff_alone`), and the level's course is the course under `H₂` on both ways
(`carrier_level_zero`). -/
theorem takes_nothing_iff_alone {giving : Nat → Nat} {m n H₂ x : Nat} (order : n ≤ m) :
    «不穷» (net giving) «一» ([(m, 0), (n, H₂)], x) ↔ «不穷» (net giving) «一» ([(n, H₂)], x) :=
  Law.stepWhile_unending_iff.trans ((goes_iff_carrier order).trans
    ((⟨fun all k => Nat.le_trans (all k) (Nat.le_of_eq (carrier_level_zero k)),
       fun all k => Nat.le_trans (all k) (Nat.le_of_eq (carrier_level_zero k).symm)⟩ :
        (∀ k, n ≤ (carrierCourse giving m 0 H₂ x k).2) ↔
          ∀ k, n ≤ Law.orbit (RegimeMargin.step giving H₂) x k).trans
      (goes_iff_alone.symm.trans Law.stepWhile_unending_iff.symm)))

/-- **Where the first unit takes nothing, from below `H₂ + y₁` the line ends.**
With `n ≤ m` (`order`), nothing given from nothing (`nothing`), `0 < n` (`needs`), giving short of
`H₂` below `y₁` (`short₁`) and the start `x` below `H₂ + y₁` (`below`): the line from
`[(m, 0), (n, H₂)]` at `x` ends. By `takes_nothing_iff_alone`, the level's course under `H₂` coming to
nothing (`RegimeMargin.ends_below`) and `n` positive; whether and when the first unit ends changes nothing in it. -/
theorem takes_nothing_ends {giving : Nat → Nat} {m n H₂ y₁ x : Nat}
    (order : n ≤ m) (nothing : RegimeMargin.FromNothing giving) (needs : 0 < n)
    (short₁ : RegimeMargin.Short giving H₂ y₁) (below : x < H₂ + y₁) :
    ¬ «不穷» (net giving) «一» ([(m, 0), (n, H₂)], x) :=
  fun never =>
    have met : n ≤ Law.orbit (RegimeMargin.step giving H₂) x x :=
      goes_iff_alone.mp (Law.stepWhile_unending_iff.mp ((takes_nothing_iff_alone order).mp never)) x
    have ended : Law.orbit (RegimeMargin.step giving H₂) x x = 0 :=
      RegimeMargin.ends_below short₁ nothing below
    Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le needs (Nat.le_trans met (Nat.le_of_eq ended)))

/-! ## 9. Two ways from one start -/


namespace With

/-- The way: a first unit that needs nine and takes four, and a second that needs one and takes
one. -/
def way : List (Nat × Nat) := [(9, 4), (1, 1)]

/-- **With the first unit taking four, the line never ends.** Giving `min z (12 - z)`
(`TurningInTime.Three.giving`), from nine: by `two_units_iff` at `m = 9`, `h = 4`, `n = 1`, `H₂ = 1`,
`y₁ = 5`, `y₂ = 1`, `hi = 12`; the course as it was runs nine, eight, six, the first level below nine
is at step 1, and six is at or above `H₂ + y₂ = 2`. -/
theorem goes_on : «不穷» (net TurningInTime.Three.giving) «一» (way, 9) :=
  (two_units_iff (giving := TurningInTime.Three.giving) (m := 9) (h := 4) (n := 1) (H₂ := 1)
      (y₁ := 5) (y₂ := 1) (hi := 12) (x := 9) (by decide) rfl
      (RegimeMargin.short_of_below rfl) (RegimeMargin.meets_of_below rfl)
      (RegimeMargin.keeps_of_below rfl) (by decide) (by decide) (RegimeMargin.short_of_below rfl)
      (by decide) (by decide)).mpr
    ⟨1, by decide, by decide, by decide, by decide⟩

/-- **Its levels**: nine, eight, six, ten, twelve, twelve; the first unit ends at eight and the
second goes on alone. -/
theorem levels :
    course TurningInTime.Three.giving (way, 9) 1 = (way, 8) ∧
    course TurningInTime.Three.giving (way, 9) 2 = ([(1, 1)], 6) ∧
    course TurningInTime.Three.giving (way, 9) 3 = ([(1, 1)], 10) ∧
    course TurningInTime.Three.giving (way, 9) 4 = ([(1, 1)], 12) ∧
    course TurningInTime.Three.giving (way, 9) 5 = ([(1, 1)], 12) :=
  ⟨rfl, rfl, rfl, rfl, rfl⟩

/-- **With's line never ending, through `unending_iff_holds`.** With `y := id` and `hi := 12`: both
units need something, nothing is given from nothing and nine is at most twelve; `Regime` holds at the
way of both units (taking five, `y 5 = 5`) at steps 0 and 1, and at `[(1, 1)]` (taking one,
`y 1 = 1`) from step 2 on, where the course stays by `stays`; at step 2, `([(1, 1)], 6)` holds. So
`unending_iff_holds`'s premises are met from a start of two units. -/
theorem goes_on_holds : «不穷» (net TurningInTime.Three.giving) «一» (way, 9) :=
  have meets₁ : RegimeMargin.Meets TurningInTime.Three.giving (taken [(1, 1)]) 1 12 :=
    RegimeMargin.meets_of_below rfl
  have keeps₁ : RegimeMargin.Keeps TurningInTime.Three.giving (taken [(1, 1)]) 12 :=
    RegimeMargin.keeps_of_below rfl
  have regimeWay : Regime TurningInTime.Three.giving id 12 way :=
    ⟨RegimeMargin.short_of_below rfl, RegimeMargin.meets_of_below rfl, RegimeMargin.keeps_of_below rfl⟩
  have regimeOne : Regime TurningInTime.Three.giving id 12 [(1, 1)] :=
    ⟨RegimeMargin.short_of_below rfl, meets₁, keeps₁⟩
  have later : ∀ k, (course TurningInTime.Three.giving (way, 9) (k + 2)).1 = [(1, 1)] := fun k =>
    (congrArg (fun i => (course TurningInTime.Three.giving (way, 9) i).1) (Nat.add_comm k 2)).trans
      ((congrArg Prod.fst (Law.orbit_add _ (way, 9) 2 k)).trans
        ((congrArg (fun s => (course TurningInTime.Three.giving s k).1) levels.2.1).trans
          (congrArg Prod.fst (stays (S := [(1, 1)]) (yS := 1) (hi := 12) (z := 6) meets₁ keeps₁
            (fun u mu => match u, mu with
              | _, .head _ => by decide
              | _, .tail _ m' => nomatch m')
            (by decide) (by decide) k).1)))
  (unending_iff_holds (giving := TurningInTime.Three.giving) (y := id) (hi := 12) (w := way) (x := 9)
      (fun u mu => match u, mu with
        | _, .head _ => by decide
        | _, .tail _ (.head _) => by decide
        | _, .tail _ (.tail _ m') => nomatch m')
      rfl (by decide)
      (fun k _ => match k with
        | 0 => regimeWay
        | 1 => Eq.subst (motive := fun s : List (Nat × Nat) × Nat =>
            Regime TurningInTime.Three.giving id 12 s.1) levels.1.symm regimeWay
        | k + 2 => Eq.subst (motive := Regime TurningInTime.Three.giving id 12) (later k).symm
            regimeOne)).mpr
    ⟨2, fun j lt => match j, lt with
      | 0, _ => by decide
      | 1, _ => by decide
      | j + 2, lt => absurd lt (Nat.not_lt_of_ge (Nat.le_add_left 2 j)),
     Eq.subst (motive := Holds id) levels.2.1.symm
      ⟨List.cons_ne_nil _ _, (fun u mu => match u, mu with
        | _, .head _ => by decide
        | _, .tail _ m' => nomatch m'), by decide⟩⟩

end With

namespace Against

/-- The way: a first unit that needs nine and takes one, and a second that needs one and takes
four. -/
def way : List (Nat × Nat) := [(9, 1), (1, 4)]

/-- **With the first unit taking one, the line ends.** Giving `min z (12 - z)`
(`TurningInTime.Three.giving`), from nine: the levels run nine, eight, six (the first unit ends at
eight, as in `With`), four, nothing; four steps lead to `([(1, 4)], 0)`, which conditions nothing, and
the line from `(way, 9)` ends. -/
theorem turns_and_ends :
    course TurningInTime.Three.giving (way, 9) 1 = (way, 8) ∧
    course TurningInTime.Three.giving (way, 9) 2 = ([(1, 4)], 6) ∧
    course TurningInTime.Three.giving (way, 9) 3 = ([(1, 4)], 4) ∧
    «迭» (net TurningInTime.Three.giving) 4 (way, 9) ([(1, 4)], 0) ∧
    (∀ v, ¬ net TurningInTime.Three.giving ([(1, 4)], 0) v) ∧
    ¬ «不穷» (net TurningInTime.Three.giving) «一» (way, 9) :=
  ⟨rfl, rfl, rfl, (Law.stepWhile_steps_iff 4).mpr ⟨by decide, rfl⟩,
   Law.stepWhile_none_iff.mpr (by decide),
   fun never => absurd (Law.stepWhile_unending_iff.mp never 4) (by decide)⟩

end Against

/-! ## 10. Where something is given from nothing, the comparisons fail -/

/-- **A configuration the pair's step leaves as it is stays so.** Under any giving, from any `s` with
`TurningInTime.pair after (left giving) s = s` (`fixed`): the course from `s` is `s` at every step. -/
theorem course_fixed {giving : Nat → Nat} {s : List (Nat × Nat) × Nat}
    (fixed : TurningInTime.pair after (left giving) s = s) : ∀ k, course giving s k = s
  | 0 => rfl
  | k + 1 => (congrArg (TurningInTime.pair after (left giving)) (course_fixed fixed k)).trans fixed

/-- **A line that comes to a configuration its step leaves as it is, some unit going on there and at
every step before, never ends.** Under any giving, from any `s`, at a step `t` with some unit going
on at every step before `t` (`before`), the course at `t` left as it is by the pair's step
(`fixed`) and some unit going on there (`goes`). By `course_fixed` and `Law.orbit_add`. -/
theorem unending_of_fixed {giving : Nat → Nat} {s : List (Nat × Nat) × Nat} {t : Nat}
    (before : ∀ j, j < t → Goes (course giving s j))
    (fixed : TurningInTime.pair after (left giving) (course giving s t) = course giving s t)
    (goes : Goes (course giving s t)) : «不穷» (net giving) «一» s :=
  Law.stepWhile_unending_iff.mpr fun k => (Nat.lt_or_ge k t).elim (before k) fun ge =>
    match le_dest ge with
    | ⟨i, e⟩ => Eq.subst (motive := fun j => Goes (course giving s j)) e.symm
        (Eq.subst (motive := Goes) ((Law.orbit_add _ s t i).trans (course_fixed fixed i)).symm goes)

namespace GivenFromNothing

/-- A giving that gives two at nothing and at two, and nothing elsewhere. -/
def giving : Nat → Nat
  | 0 => 2
  | 2 => 2
  | _ => 0

/-- **The regime at the use three, with something given from nothing.** Giving is short of three
below four, meets three from four up to six (no level qualifies), and the step under three keeps the
level within six; it gives two at nothing, so `FromNothing` fails. Checked level by level. -/
theorem regime :
    RegimeMargin.Short giving 3 4 ∧ RegimeMargin.Meets giving 3 4 6 ∧ RegimeMargin.Keeps giving 3 6 ∧
      ¬ RegimeMargin.FromNothing giving :=
  ⟨RegimeMargin.short_of_below rfl, RegimeMargin.meets_of_below rfl, RegimeMargin.keeps_of_below rfl,
   fun e => absurd (e : giving 0 = 0) (by decide : ¬ giving 0 = 0)⟩

/-- **Without nothing given from nothing, a greater need ends a line that did not end.** Under
`giving`, from six, with a second unit needing two and taking three (`regime` at three with `y₂ = 4`
and `hi = 6`; `n ≤ m`, `m ≤ m'` and the start at most `hi` hold): with the first unit needing two and
taking one, the levels run 6, 4, 2, 2, … with both units there, and the line never ends; with it
needing seven, the first unit ends at six, the second alone takes three at four and leaves one, below
two, and the line ends. So `greater_need` fails without `nothing`. -/
theorem greater_need_fails :
    «不穷» (net giving) «一» ([(2, 1), (2, 3)], 6) ∧ ¬ «不穷» (net giving) «一» ([(7, 1), (2, 3)], 6) :=
  ⟨unending_of_fixed (t := 2) (fun j lt => match j, lt with
      | 0, _ => by decide
      | 1, _ => by decide
      | j + 2, lt => absurd lt (Nat.not_lt_of_ge (Nat.le_add_left 2 j)))
    rfl (by decide),
   fun never => absurd (Law.stepWhile_unending_iff.mp never 2) (by decide)⟩

/-- **Without nothing given from nothing, more of the use on the first unit ends a line that did not
end.** Under `giving`, from six, with a first unit needing seven (`regime` at the second unit's use
three with `y₂' = 4` and `hi = 6`; `n ≤ m`, the same sum four, `h ≤ h'` and the start at most `hi`
hold): with the first unit taking nothing and the second four, the first unit ends at six and the
levels run 6, 4, 2, 2, …, and the line never ends; with them taking one and three, the second unit
alone takes three at four and leaves one, below two, and the line ends. So `more_use_on_first` fails
without `nothing`. -/
theorem more_use_fails :
    «不穷» (net giving) «一» ([(7, 0), (2, 4)], 6) ∧ ¬ «不穷» (net giving) «一» ([(7, 1), (2, 3)], 6) :=
  ⟨unending_of_fixed (t := 2) (fun j lt => match j, lt with
      | 0, _ => by decide
      | 1, _ => by decide
      | j + 2, lt => absurd lt (Nat.not_lt_of_ge (Nat.le_add_left 2 j)))
    rfl (by decide),
   greater_need_fails.2⟩

end GivenFromNothing

end WayOfUnits
end Becoming
