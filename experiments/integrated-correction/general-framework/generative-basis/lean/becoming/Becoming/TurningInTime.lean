import Becoming.GuardedStep
import Becoming.GrammarRegularity
import Becoming.OwnClass
import Becoming.PoolFromCourse
import Becoming.ReadOffInTime

/-!
# Turning in time: a line that ends where the net ends, or while the net goes on

AI-written, 12 November 2026.

## What the root already has

A line under a class ends in one of two ways: where its last occurrence conditions nothing at all (the
net ends there), or where the occurrence still conditions something but nothing alike to it. The root
names the gap between the two. Constancy up to the net's end (`«至终有常»`, `Becoming.GrammarPath`)
asks that whatever an alike occurrence conditions, this one conditions something alike to it, unless
this one conditions nothing at all; at a member's class it is `«本类至终有常»`. A line that ends while its
last occurrence still conditions something breaks it (`«亡而网续则不至终有常»`,
`«亡而网续则本类不至终有常»`). With the successor fixed, it is going alike (`«同行»`) with whether the next
conditions anything decided (`«局定后则至终有常当且仅当同行可决»`), and constancy is constancy up to the
net's end with a next where the class leads (`«有常当且仅当至终有常可续»`). A determined law's step
(`Law.step`) never lets the net end; cut where it cannot go on (`Law.stepWhile`,
`Becoming.GuardedStep`), a line on it can.

## What the level's laws already have

A level `x` along a course, `g t` given to it and `d t` taken from it at each step, with
`x (t + 1) = x t + g t - d t`: where at most `r` is given and more than `r` taken at every step, the
level never rises (`Optimum.never_rises`), stays within its start (`Optimum.level_le_start`), and is
below any positive need `m` at every step `t` with `x 0 < m + t` (`Optimum.ends_within`). At a standing use
`H`, with giving short of `H` below `y` and nothing given from nothing, a level below `H + y` comes to
nothing (`RegimeMargin.ends_below`), and from a level at or above `H + y` up to `hi`, where giving
meets `H` from `y` and the step keeps the level within `hi`, it never falls below where it started
(`RegimeMargin.holds`); under all of these premises and `0 < H + y`, from a level up to `hi` it comes
to nothing exactly where it starts below `H + y` (`RegimeMargin.ends_iff_below`).

## What this module adds

Each bullet names the main premises; each law's own docstring names all of them. Way, level, need,
marked, alone, as it was, kept kind, giving and use are this model's labels for parts of its
configurations and step, not terms of the root.

* **The pair cut by a need.** One step takes a pair of a way `w` and a level `x` to
  `(after w x, left w x)` (`pair`): `Mechanism.adaptive`'s step with the level in the second place
  (`pair_adaptive`). The net (`net need after left`) is the pair's step where the level is at least
  `need`, and nothing where it is below; at a need of nothing it is the pair's whole step
  (`net_zero`). `AloneOutside marked alone after` says that at every level not marked, the way after
  a step is `alone` of the way; `asItWas alone left` is the step as it was, the way after a step
  `alone` of the way at every level.
* **Which differences of level make a difference.** The way's class is constant up to the net's end
  exactly where no two levels that meet the need give one way two different ways after a step
  (`toEnd_iff`, through `Law.stepWhile_toEnd_iff`); it is constant exactly where, from a level that
  meets the need, every level meets it and gives one way the same way after a step (`constant_iff`),
  so, where some way is given, exactly where nothing is needed and no level makes a difference
  (`constant_iff_needs_nothing`), which at a need of nothing is `adaptive_constant_iff`
  (`constant_adaptive`). With `AloneOutside` and no marked level that meets the need, the class of a
  kind `κ : W → K` is constant up to the net's end where `alone` takes ways of one kind to ways of one
  kind (`kind_toEnd_of_unmarked`), and the way's class is (`toEnd_of_unmarked`, the case `κ := id`);
  for marks between `low` and `high`, no level that meets the need is marked exactly where
  `high < low` or `high < need` (`unmarked_interval_iff`). The core of the way's class does not
  relate a configuration whose level meets the need to one of the same way whose level is below it
  (`core_apart_below_need`, by `«有常则可续»` at the core).
* **The course as it was.** With `AloneOutside`, up to the first marked level of the course as it was,
  the course is that course (`agrees_until_marked`), and its way is `alone` taken `n` times
  (`asItWas_way`). With no marked level that meets the need, lines of `n` steps from one way at two
  levels reach one way (`alike_along`, `«同行之迭»` through `«至终有常局定后则同行»`).
* **Ending where the net ends.** With `AloneOutside`, no marked level that meets a positive need and
  the level of the course as it was in `Optimum`'s form, at most `r` given and more than `r` taken at
  every step, the line from `s` reaches, within `s.2` steps, a configuration that conditions nothing,
  with the way `alone` taken that many times (`ends_with_net`, by `Optimum.ends_within`). With the
  step's level `RegimeMargin.step giving (use w) x` (`regime_step_eq`), nothing given from nothing,
  giving short of `H` below `y`, uses of at least `H` along `alone`'s orbit and a start below
  `H + y`, the premises hold (`ends_with_net_regime`).
* **The split at the first marked level.** With `AloneOutside` and decided marks, where the course as
  it was comes to a level below the need, the line never ends exactly where there is a step `T` of
  the course as it was, the need met and no level marked before it, the need met and the level marked
  at it, from whose next configuration the line never ends (`unending_iff_first_marked`). From a way
  of a kind every step keeps, that uses `H₂`, with giving short of `H₂` below `y₂`, meeting it from
  `y₂` up to `hi` and the step keeping the level within `hi`, a positive need at most `H₂ + y₂` and
  the level at most `hi`, the line never ends exactly where the level is at or above `H₂ + y₂`
  (`unending_iff_above`). Composed, with a way after a marked step of the kept kind, uses of at least
  `H₁` along `alone`'s orbit, giving short of `H₁` below `y₁` and the course as it was starting below
  `H₁ + y₁`: the line never ends exactly where at the first marked level, the need met there and at
  every step before it, the level of the course as it was one step later is at or above `H₂ + y₂`
  (`turns_in_time_iff`). Where at a level that meets the need the way after the step is of another
  kind than the way, the line under the kind's class ends there while the net goes on
  (`kind_ends_while_net_goes`); with a kind `alone` keeps and some unmarked level that meets the need,
  the kind's class is then not constant up to the net's end at that member's class
  (`kind_not_toEnd_of_turn`, by `«出类不随则本类不至终有常»`).
* **The lock's courses as courses of the pair** (section 6; the lock's own names
  are cited there). `ClosedCapture`'s joined two-level step, regrouped with the share, the rule and
  the step count as the way and the loss as the level (`windowRegroup`), is the pair's step, and a
  total step is the net at a need of nothing (`net_zero`). The course that reads off the share is the
  window course as it was (`join_is_asItWas`); `PoolFromCourse`'s window course is the orbit of
  `pair (windowAfter …) (windowLeft fB)` (`window_is_pair`; on `paced`, `window_paced`), at every level
  outside `[N, K)` its way after a step is `windowAlone`, the rule read off the share by `hA` on the
  same schedule (`window_alone_outside`), and it agrees with the course that reads off the share until
  that course's loss first lies in `[N, K)` (`window_agrees_until_marked`). Under `RuleCapture`'s
  premises of `turn_locked` (`Raises`, `ReadsShare`, favouring kept upward), along the course that
  reads off the share the configurations whose share and rule are `Locked` form a region closed under
  the step, with no `Accrues` (`locked_closed`); so at a locked member the class
  `ClosedCapture.lockedAlike` meets `«本类至终有常»` and `«所缘同于»` (`locked_at_class`, by
  `«类闭则本类常闭»`). Along the way's step as it was (`windowAlone`), a `Locked` way stays `Locked`
  (`locked_alone`, under the same premises), and under those premises with `ends_with_net`'s (a
  positive need, no marked level that meets it, the level of the course as it was given at most `r`
  and losing more than `r` at every step) a `Locked` start reaches a configuration that conditions
  nothing, its share and rule still `Locked` (`locked_ends_with_net`).
* **The point of no return, a level and a step** (section 7). `RegimeMargin` calls the level `H + y`
  the point of no return under a standing use `H`; `Becoming.ReadOffInTime` calls the first step at
  which a course is not recoverable its point of no return (`NoReturnAt`). For any level course `X`
  that never rises and starts at most `hi`, with the feasible courses `X` turned to `H` at some step,
  the start included (`turned`, `Turned`), and what is asked of a course the need met at every step
  (`MeetsNeed`): under nothing given from nothing, giving short of `H` below `y`, meeting it from `y`
  up to `hi`, the step under `H` keeping the level within `hi`, and a positive need at most `H + y`,
  the course turned at `T` meets the need exactly where `H + y ≤ X T` (`turned_meets_iff`), `X` is
  recoverable at `N` exactly where `H + y ≤ X N` (`recoverable_iff_above`), and its point of no return
  is the first step at which its level is below `H + y` (`noReturnAt_iff_first_below`); where it comes
  below `H + y` it has one (`noReturnAt_of_below`). On the pair, with `AloneOutside`, `turns`, `kept`
  and `uses` and no premise on the need, the level course is the course as it was turned at `T + 1`,
  for `T` its first marked step (`course_turned`). Under `turns_in_time_iff`'s premises on the regime
  and on the course as it was (none on the marks or the kept kind) the course as it was has a point of
  no return `N ≤ x` (`noReturn_exists`); the premises on `H₂` decide recoverability at each step
  through `recoverable_iff_above`, and that the course is not recoverable at step `x` needs only that
  its level there is below the need. Under all of `turns_in_time_iff`'s premises the line never ends
  exactly where the first marked step `T`, the need met there and before, has `T + 1 < N`
  (`turns_in_time_iff_before`, through `course_turned`, `turned_meets_iff` and
  `recoverable_iff_above`).
* **Three courses from one start** (`Three`). Giving `min z (12 - z)`, a use of five as it was and of
  three for the kept kind, a need of one, from the level nine: first marked at step 0 or 1 the line
  never ends (`Three.goes_on`); first marked at step 2 it turns and ends (`Three.turned_and_ends`), and
  there the line under the way's class, continued from the step before, ends while the net goes on, so
  by the root's `«亡而网续则不至终有常»` the way's class is not constant up to the net's end
  (`Three.line_ends_while_net_goes`); with no marked level it ends as it was
  (`Three.ends_as_it_was`). With the kept kind's use three and `y = 3`, the course as it was from
  nine (nine, eight, six, two, nothing) has its point of no return at step 3 (`Three.noReturn`).

## What is given and what is not shown

`AloneOutside` and the marks are given, not derived: which levels make a difference to the way is a
premise of every law that uses them. `Kept` is kept by premise (`kept`), that a way after a marked
step is of the kept kind is a premise (`turns`), and every way of the kept kind has one standing use
(`uses : ∀ w, Kept w → use w = H₂`); with `kept` and `turns` this makes the course after the turn a
single threshold, and the exactness of `turns_in_time_iff` past `T` rests on it. In
`ends_with_net_regime`, `unending_iff_above` and `turns_in_time_iff` the level's step is
`RegimeMargin.step giving (use w)`, with one `giving` for every way and nothing given from nothing
(`RegimeMargin.FromNothing giving`): the way enters the level's step only through `use`. That the marked levels are levels of the same quantity the going on needs is a choice
of the model, and so are these. `unending_iff_above` and `turns_in_time_iff` need giving to meet `H₂`
from `y₂` up to `hi` (`RegimeMargin.Meets`), the step under `H₂` to keep the level within `hi`
(`RegimeMargin.Keeps`), the need at most `H₂ + y₂` (`within`) and the level at most `hi` (`high`).
`unending_iff_first_marked` needs the course as it was to come below the need (`asItWasEnds`): without
it, a course never marked whose level never falls below the need is a line that never ends with no such
step `T` (argued here, not a Lean statement). `turns_in_time_iff` needs the decidability of the marks (`[DecidablePred marked]`) and the
course as it was below `H₁ + y₁` with uses of at least `H₁` along `alone`'s orbit.
`constant_iff_needs_nothing` needs a given way `w₀`. The closed form of the step `T` by
`Optimum.reread_deadline_iff` is not stated. Nothing here is about a trained system.
From `Becoming.ReadOffInTime` this module uses `first_of_decided`, and its point of no return of a
course (`Recoverable`, `NoReturnAt`, with `NoReturnAt.recoverable_iff` and `noReturnAt_of_past`),
which section 7 joins to `RegimeMargin`'s point of no return, a level. Its selection side
(`FirstApart`, `TellsApartAt`, `ReadableInTime`, `ReadsInTime`) is not instantiated: the pair has no
web. `FourReaders.recoverable_iff_regime` is not derived from `recoverable_iff_above`: its courses are
over three places, and its course as it was is not of `RegimeMargin.step`'s form; that the two say
the same of their models is a reading. In section 7 the feasible courses are the turns of `X` to one
standing use `H` at any step, the start included; other continuations are not considered, and the
marks stay given. The pair's own courses are only the turns at `T + 1` for a first marked step `T`
(`course_turned`); `turned_meets_iff`, `recoverable_iff_above` and `noReturnAt_iff_first_below` hold
for any level course that never rises and starts at most `hi`, however it arises, and need nothing of
the pair.
This module lies in the package's second layer only through what it imports, `Becoming.OwnClass` (for
`«类闭则本类常闭»`) and `Becoming.ReadOffInTime` (for `first_of_decided` and the point of no return of a
course); it states no continuation condition and no valuation, and uses none.
Nothing here derives that a lock needs nothing of what it uses: that a lock's own models need nothing
is how they are built. They have a total step, so in them no line ends where the net ends, and
`ends_with_net` and the split at the first marked level, which ask for a positive need or a course as
it was that comes below the need, do not apply to them; the laws on a kind's class hold at every need.
Where the way's step as it was is the lock's, under `turn_locked`'s premises and `ends_with_net`'s (a
positive need among them), a `Locked` start ends `Locked` where the net ends (`locked_ends_with_net`).
Under the regime the level of the course as it was is
`DrawHistory.underDraws` along `alone`'s orbit; that identification is not stated. `locked_at_class` is
stated where the beyond is a loss (`B = Nat`), as `ClosedCapture.lockedAlike` is. `locked_stays`,
`lock_line`, `window_never_read`, `window_past_course` and `course_past` are not re-proved.

Every declaration has an empty axiom report.
-/

namespace Becoming
namespace TurningInTime

universe u v

variable {W : Type u}

/-! ## 1. The pair and its net -/

/-- One step: the way becomes `after w x` and the level `left w x`. -/
def pair (after : W → Nat → W) (left : W → Nat → Nat) (s : W × Nat) : W × Nat :=
  (after s.1 s.2, left s.1 s.2)

/-- The step as it was: the way after a step is `alone` of the way at every level. -/
def asItWas (alone : W → W) (left : W → Nat → Nat) : W × Nat → W × Nat :=
  pair (fun w _ => alone w) left

/-- The pair's step is `Mechanism.adaptive`'s, with the level in the place `adaptive` gives to what it
calls the rule. -/
theorem pair_adaptive (after : W → Nat → W) (left : W → Nat → Nat) :
    «谓» (Law.step (pair after left))
      (moveRel (adaptive (fun (x : Nat) (w : W) (_ : Unit) => after w x) (fun x w => left w x)) ()) :=
  fun _ _ => Iff.rfl

/-- The net: a next only where the level meets the need. -/
def net (need : Nat) (after : W → Nat → W) (left : W → Nat → Nat) : «际» (W × Nat) :=
  Law.stepWhile (fun s => need ≤ s.2) (pair after left)

/-- At a need of nothing the net is the pair's whole step. -/
theorem net_zero (after : W → Nat → W) (left : W → Nat → Nat) :
    «谓» (net 0 after left) (Law.step (pair after left)) :=
  fun _ _ => ⟨fun h => h.2, fun h => ⟨Nat.zero_le _, h⟩⟩

/-- Outside the marked levels the way after a step is `alone` of the way: the level makes no
difference to it there. -/
def AloneOutside (marked : Nat → Prop) (alone : W → W) (after : W → Nat → W) : Prop :=
  ∀ w x, ¬ marked x → after w x = alone w

/-- Whether a configuration's level meets the need is decided. Needed to call
`Law.stepWhile_toEnd_iff` at the net. -/
private theorem need_decided {need : Nat} (s : W × Nat) : need ≤ s.2 ∨ ¬ need ≤ s.2 :=
  (Nat.lt_or_ge s.2 need).elim (fun lt => .inr (Nat.not_le_of_gt lt)) .inl

/-! ## 2. Which differences of level make a difference -/

/-- **The way's class is constant up to the net's end exactly where no two levels that meet the need
give one way two different ways after a step.** -/
theorem toEnd_iff (need : Nat) (after : W → Nat → W) (left : W → Nat → Nat) :
    «至终有常» (net need after left) (sameValue (Prod.fst : W × Nat → W)) ↔
      ∀ w x x', need ≤ x → need ≤ x' → after w x = after w x' :=
  (Law.stepWhile_toEnd_iff (can := fun s : W × Nat => need ≤ s.2) (next := pair after left)
    need_decided).trans
    (Law.stepWhile_goesAlike_iff.trans
      ⟨fun h w x x' ge ge' => h (w, x) (w, x') rfl ge ge',
       fun h s s' e ge ge' => (congrArg (fun v => after v s.2) e).trans (h s'.1 s.2 s'.2 ge ge')⟩)

/-- **The way's class is constant exactly where, from a level that meets the need, every level meets
it and gives one way the same way after a step.** -/
theorem constant_iff (need : Nat) (after : W → Nat → W) (left : W → Nat → Nat) :
    «有常» (net need after left) (sameValue (Prod.fst : W × Nat → W)) ↔
      ∀ w x x', need ≤ x → need ≤ x' ∧ after w x = after w x' :=
  Law.stepWhile_constant_iff.trans
    ⟨fun h w x x' ge => h (w, x) (w, x') rfl ge,
     fun h s s' e ge => match h s'.1 s.2 s'.2 ge with
       | ⟨c, same⟩ => ⟨c, (congrArg (fun v => after v s.2) e).trans same⟩⟩

/-- **Where some way `w₀` is given, the way's class is constant exactly where nothing is needed of
the level and no level makes a difference to the way after a step**; at `need = 0` the second clause
is `adaptive_constant_iff`'s (`constant_adaptive`). -/
theorem constant_iff_needs_nothing (w₀ : W) (need : Nat) (after : W → Nat → W)
    (left : W → Nat → Nat) :
    «有常» (net need after left) (sameValue (Prod.fst : W × Nat → W)) ↔
      need = 0 ∧ ∀ w x x', after w x = after w x' :=
  (constant_iff need after left).trans
    ⟨fun h =>
      have zero : need = 0 := Nat.eq_zero_of_le_zero (h w₀ need 0 (Nat.le_refl need)).1
      ⟨zero, fun w x x' => (h w x x' (Nat.le_trans (Nat.le_of_eq zero) (Nat.zero_le x))).2⟩,
     fun ⟨zero, h⟩ w x x' _ => ⟨Nat.le_trans (Nat.le_of_eq zero) (Nat.zero_le x'), h w x x'⟩⟩

/-- **At a need of nothing, the way's class is constant under the net exactly where it is constant
under `Mechanism.adaptive`'s step** (`adaptive_constant_iff`, the level in the second place
of the pair). -/
theorem constant_adaptive (after : W → Nat → W) (left : W → Nat → Nat) :
    «有常» (net 0 after left) (sameValue (Prod.fst : W × Nat → W)) ↔
      ∀ u, «有常» (moveRel (adaptive (fun (x : Nat) (w : W) (_ : Unit) => after w x)
        (fun x w => left w x)) u) (sameValue (Prod.fst : W × Nat → W)) :=
  have same : (∀ w x x', 0 ≤ x → 0 ≤ x' ∧ after w x = after w x') ↔
      ∀ (g g' : Nat) (w : W) (_ : Unit), after w g = after w g' :=
    ⟨fun h g g' w _ => (h w g g' (Nat.zero_le g)).2,
     fun h w x x' _ => ⟨Nat.zero_le x', h x x' w ()⟩⟩
  (constant_iff 0 after left).trans (same.trans adaptive_constant_iff.symm)

/-- **With no marked level that meets the need, the class of a kind is constant up to the net's end
where `alone` takes ways of one kind to ways of one kind.** With `AloneOutside`, for a kind
`κ : W → K` of any type, where `κ w = κ w'` gives `κ (alone w) = κ (alone w')` (as it does where `alone`
keeps the kind, `κ (alone w) = κ w`). -/
theorem kind_toEnd_of_unmarked {K : Type v} {marked : Nat → Prop} {alone : W → W}
    {after : W → Nat → W} (outside : AloneOutside marked alone after) {need : Nat}
    (un : ∀ x, need ≤ x → ¬ marked x) {κ : W → K}
    (respects : ∀ w w', κ w = κ w' → κ (alone w) = κ (alone w')) (left : W → Nat → Nat) :
    «至终有常» (net need after left) (sameValue (fun s : W × Nat => κ s.1)) :=
  (Law.stepWhile_toEnd_iff (can := fun s : W × Nat => need ≤ s.2) (next := pair after left)
    need_decided).mpr
    (Law.stepWhile_goesAlike_iff.mpr fun s s' e ge ge' =>
      ((congrArg κ (outside s.1 s.2 (un _ ge))).trans (respects s.1 s'.1 e)).trans
        (congrArg κ (outside s'.1 s'.2 (un _ ge'))).symm)

/-- **With no marked level that meets the need, the way's class is constant up to the net's end.**
With `AloneOutside`; `kind_toEnd_of_unmarked` at `κ := id`. -/
theorem toEnd_of_unmarked {marked : Nat → Prop} {alone : W → W} {after : W → Nat → W}
    (outside : AloneOutside marked alone after) {need : Nat} (un : ∀ x, need ≤ x → ¬ marked x)
    (left : W → Nat → Nat) : «至终有常» (net need after left) (sameValue (Prod.fst : W × Nat → W)) :=
  kind_toEnd_of_unmarked (κ := id) outside un (fun _ _ e => congrArg alone e) left

/-- **No level that meets the need lies between `low` and `high` exactly where `high` is below `low`
or below the need.** -/
theorem unmarked_interval_iff {need low high : Nat} :
    (∀ x, need ≤ x → ¬ (low ≤ x ∧ x ≤ high)) ↔ high < low ∨ high < need :=
  ⟨fun un => (Nat.lt_or_ge high low).elim .inl fun low_le =>
    (Nat.lt_or_ge high need).elim .inr fun need_le =>
      (Nat.lt_or_ge need low).elim
        (fun lt => absurd ⟨Nat.le_refl low, low_le⟩ (un low (Nat.le_of_lt lt)))
        (fun ge => absurd ⟨ge, need_le⟩ (un need (Nat.le_refl need))),
   fun h _ ge between => h.elim
    (fun lt => Nat.not_le_of_gt lt (Nat.le_trans between.1 between.2))
    (fun lt => Nat.not_le_of_gt lt (Nat.le_trans ge between.2))⟩

/-- **The core of the way's class does not relate a configuration whose level meets the need to one of
the same way whose level is below it.** By `«有常则可续»` at the core, which is constant (`«根»`); no
new root law. -/
theorem core_apart_below_need {need : Nat} {after : W → Nat → W} {left : W → Nat → Nat} {w : W}
    {x x' : Nat} (ge : need ≤ x) (lt : x' < need) :
    ¬ «核» (net need after left) (sameValue (Prod.fst : W × Nat → W)) (w, x) (w, x') :=
  fun core =>
    match «有常则可续» («根» (net need after left) (sameValue (Prod.fst : W × Nat → W))).2.1
        (w, x) (w, x') (pair after left (w, x)) core ⟨ge, rfl⟩ with
    | ⟨_, c, _⟩ => Nat.not_le_of_gt lt c

/-! ## 3. The course as it was -/

/-- **Up to the first marked level of the course as it was, the course is the course as it was.**
With `AloneOutside`. -/
theorem agrees_until_marked {marked : Nat → Prop} {alone : W → W} {after : W → Nat → W}
    (outside : AloneOutside marked alone after) (left : W → Nat → Nat) (s : W × Nat) :
    ∀ n, (∀ j, j < n → ¬ marked (Law.orbit (asItWas alone left) s j).2) →
      Law.orbit (pair after left) s n = Law.orbit (asItWas alone left) s n
  | 0, _ => rfl
  | n + 1, before =>
    (congrArg (pair after left)
        (agrees_until_marked outside left s n fun j lt => before j (Nat.lt_succ_of_lt lt))).trans
      (congrArg (fun z => (z, left (Law.orbit (asItWas alone left) s n).1
          (Law.orbit (asItWas alone left) s n).2))
        (outside _ _ (before n (Nat.lt_succ_self n))))

/-- The way of the course as it was after `n` steps is `alone` taken `n` times. -/
theorem asItWas_way (alone : W → W) (left : W → Nat → Nat) (s : W × Nat) :
    ∀ n, (Law.orbit (asItWas alone left) s n).1 = Law.orbit alone s.1 n
  | 0 => rfl
  | n + 1 => congrArg alone (asItWas_way alone left s n)

/-- **With no marked level that meets the need, lines of `n` steps from one way at two levels reach
one way**: `«同行之迭»`, the way's class going alike by `«至终有常局定后则同行»` from
`toEnd_of_unmarked`. With `AloneOutside`. -/
theorem alike_along {marked : Nat → Prop} {alone : W → W} {after : W → Nat → W}
    (outside : AloneOutside marked alone after) {need : Nat} (un : ∀ x, need ≤ x → ¬ marked x)
    {left : W → Nat → Nat} (n : Nat) {w : W} {x x' : Nat} {t t' : W × Nat}
    (line : «迭» (net need after left) n (w, x) t) (line' : «迭» (net need after left) n (w, x') t') :
    t.1 = t'.1 :=
  «同行之迭»
    («至终有常局定后则同行» (toEnd_of_unmarked outside un left)
      (fun _ x' _ v v' r r' =>
        Law.stepWhile_fixed (fun s : W × Nat => need ≤ s.2) (pair after left) v v' ⟨x', r, r'⟩))
    n (show sameValue (Prod.fst : W × Nat → W) (w, x) (w, x') from rfl) line line'

/-! ## 4. Ending where the net ends -/

/-- **Ending where the net ends.** With `AloneOutside`, no marked level that meets the need, a
positive need, and the level of the course as it was in `Optimum`'s form (`step`), at most `r` given
(`renews`) and more than `r` taken (`over`) at every step: within `s.2` steps the line from `s`
reaches a configuration that conditions nothing, its way `alone` taken that many times. By
`Optimum.ends_within` and `first_of_decided`. -/
theorem ends_with_net {marked : Nat → Prop} {alone : W → W} {after : W → Nat → W}
    {left : W → Nat → Nat} (outside : AloneOutside marked alone after)
    {need : Nat} (needs : 0 < need) (un : ∀ x, need ≤ x → ¬ marked x)
    {s : W × Nat} {g d : Nat → Nat} {r : Nat}
    (step : ∀ t, (Law.orbit (asItWas alone left) s (t + 1)).2 =
      (Law.orbit (asItWas alone left) s t).2 + g t - d t)
    (renews : ∀ t, g t ≤ r) (over : ∀ t, r < d t) :
    ∃ n t, n ≤ s.2 ∧ «迭» (net need after left) n s t ∧ (∀ v, ¬ net need after left t v) ∧
      t.1 = Law.orbit alone s.1 n :=
  have ended := Optimum.ends_within (x := fun t => (Law.orbit (asItWas alone left) s t).2)
    step renews over needs s.2 (Nat.lt_add_of_pos_left needs)
  match first_of_decided (P := fun t => need ≤ (Law.orbit (asItWas alone left) s t).2)
      (Q := fun t => (Law.orbit (asItWas alone left) s t).2 < need)
      (fun t => (Nat.lt_or_ge (Law.orbit (asItWas alone left) s t).2 need).elim
        .inr .inl) s.2 with
  | .inl all => absurd (all s.2 (Nat.le_refl _)) (Nat.not_le_of_gt ended)
  | .inr ⟨m, within, below, before⟩ =>
    have agree : ∀ j, j ≤ m →
        Law.orbit (pair after left) s j = Law.orbit (asItWas alone left) s j :=
      fun j le => agrees_until_marked outside left s j
        (fun i lt => un _ (before i (Nat.lt_of_lt_of_le lt le)))
    ⟨m, Law.orbit (pair after left) s m, within,
      (Law.stepWhile_steps_iff m).mpr
        ⟨fun j lt => Eq.subst (motive := fun z : W × Nat => need ≤ z.2)
          (agree j (Nat.le_of_lt lt)).symm (before j lt), rfl⟩,
      Law.stepWhile_none_iff.mpr (Eq.subst (motive := fun z : W × Nat => ¬ need ≤ z.2)
        (agree m (Nat.le_refl m)).symm (Nat.not_le_of_gt below)),
      (congrArg Prod.fst (agree m (Nat.le_refl m))).trans (asItWas_way alone left s m)⟩

/-- `RegimeMargin.step` in `Optimum`'s form, where nothing gives from nothing. -/
theorem regime_step_eq {giving : Nat → Nat} (nothing : RegimeMargin.FromNothing giving) (d x : Nat) :
    RegimeMargin.step giving d x = x + giving (x - d) - d :=
  (Nat.lt_or_ge x d).elim
    (fun lt => by
      have gone : x - d = 0 := sub_eq_zero_of_le (Nat.le_of_lt lt)
      show x - d + giving (x - d) = x + giving (x - d) - d
      rw [gone, show giving 0 = 0 from nothing, Nat.add_zero, Nat.add_zero, gone])
    (fun ge =>
      (Naturals.add_sub_cancel (x - d + giving (x - d)) d).symm.trans
        (congrArg (· - d) ((Nat.add_right_comm (x - d) (giving (x - d)) d).trans
          (congrArg (· + giving (x - d)) (Naturals.sub_add_cancel ge)))))

/-- A level that steps by `RegimeMargin.step giving (D t)`, with every `D t` at least `H`, giving short
of `H` below `y`, and a start below `H + y`, is in `Optimum`'s form with at most `H - 1` given and more
than `H - 1` taken at every step. Needed by `ends_with_net_regime` and `turns_in_time_iff`, which
read it off the course as it was; what the draw leaves is below `y` by
`RegimeMargin.Adjusted.left_below`, and the level is kept within its start by a joint induction with
`Optimum.never_rises`. -/
private theorem regime_levels {giving : Nat → Nat} {H y : Nat} {X D : Nat → Nat}
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (uses : ∀ t, H ≤ D t) (below : X 0 < H + y)
    (step : ∀ t, X (t + 1) = RegimeMargin.step giving (D t) (X t)) :
    (∀ t, X (t + 1) = X t + giving (X t - D t) - D t) ∧ (∀ t, giving (X t - D t) ≤ H - 1) ∧
      ∀ t, H - 1 < D t :=
  have pos : 0 < H := RegimeMargin.Adjusted.draw_pos short below
  have back : H - 1 + 1 = H := Naturals.sub_add_cancel pos
  have step' : ∀ t, X (t + 1) = X t + giving (X t - D t) - D t := fun t =>
    (step t).trans (regime_step_eq nothing (D t) (X t))
  have over : ∀ t, H - 1 < D t := fun t => Nat.lt_of_lt_of_le (Nat.le_of_eq back) (uses t)
  have short_at : ∀ z d, z < H + y → H ≤ d → giving (z - d) ≤ H - 1 := fun z d lt hd =>
    have small : giving (z - d) < H := (Nat.lt_or_ge z d).elim
      (fun zl => Nat.lt_of_le_of_lt
        (Nat.le_of_eq ((congrArg giving (sub_eq_zero_of_le (Nat.le_of_lt zl))).trans nothing)) pos)
      (fun zg =>
        have ypos : 0 < y := Naturals.lt_of_add_lt_add_left (k := H)
          (show H + 0 < H + y from Nat.lt_of_le_of_lt (Nat.le_trans hd zg) lt)
        short _ (Nat.lt_of_le_of_lt (Optimum.sub_le_sub_left_of_le hd z)
          (RegimeMargin.Adjusted.left_below ypos lt)))
    le_of_add_le_add_right 1 (Nat.le_trans small (Nat.le_of_eq back.symm))
  have bound : ∀ t, X t ≤ X 0 := fun t => by
    induction t with
    | zero => exact Nat.le_refl _
    | succ t ih =>
      exact Nat.le_trans
        (Optimum.never_rises (x := X) (g := fun t => giving (X t - D t)) (d := D) step'
          (short_at _ _ (Nat.lt_of_le_of_lt ih below) (uses t)) (over t)) ih
  ⟨step', fun t => short_at _ _ (Nat.lt_of_le_of_lt (bound t) below) (uses t), over⟩

/-- **The regime as one way to meet `ends_with_net`'s premises.** With `AloneOutside`, no marked
level that meets a positive need, nothing given from nothing, giving short of `H` below `y`, every way
on `alone`'s orbit from `w` using at least `H`, and the level `x` below `H + y`: within `x` steps the
line from `(w, x)` reaches a configuration that conditions nothing, its way `alone` taken that many
times. -/
theorem ends_with_net_regime {marked : Nat → Prop} {alone : W → W} {after : W → Nat → W}
    (outside : AloneOutside marked alone after) {need : Nat} (needs : 0 < need)
    (un : ∀ x, need ≤ x → ¬ marked x) {giving : Nat → Nat} {use : W → Nat} {H y : Nat}
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    {w : W} {x : Nat} (uses : ∀ j, H ≤ use (Law.orbit alone w j)) (below : x < H + y) :
    ∃ n t, n ≤ x ∧
      «迭» (net need after (fun w x => RegimeMargin.step giving (use w) x)) n (w, x) t ∧
      (∀ v, ¬ net need after (fun w x => RegimeMargin.step giving (use w) x) t v) ∧
      t.1 = Law.orbit alone w n :=
  have levels := regime_levels
    (X := fun t => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2)
    (D := fun t => use (Law.orbit alone w t)) nothing short uses below
    (fun t => congrArg (fun v => RegimeMargin.step giving (use v) (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) (asItWas_way alone _ (w, x) t))
  ends_with_net outside needs un (s := (w, x)) levels.1 levels.2.1 levels.2.2

/-! ## 5. Turning in time, exactly -/

/-- **Split at the first marked level.** With `AloneOutside`, where the course as it was comes to a
level below the need (`asItWasEnds`), the line never ends exactly where there is a step `T` of the
course as it was, the need met and no level marked before it, the need met and the level marked at it,
from whose next configuration the line never ends. Whether a level is marked is decided
(`[DecidablePred marked]`). -/
theorem unending_iff_first_marked {marked : Nat → Prop} [DecidablePred marked] {alone : W → W}
    {after : W → Nat → W} {left : W → Nat → Nat} (outside : AloneOutside marked alone after)
    {need : Nat} {s : W × Nat}
    (asItWasEnds : ∃ n, (Law.orbit (asItWas alone left) s n).2 < need) :
    «不穷» (net need after left) «一» s ↔
      ∃ T, (∀ j, j < T → need ≤ (Law.orbit (asItWas alone left) s j).2 ∧
              ¬ marked (Law.orbit (asItWas alone left) s j).2) ∧
        need ≤ (Law.orbit (asItWas alone left) s T).2 ∧
        marked (Law.orbit (asItWas alone left) s T).2 ∧
        «不穷» (net need after left) «一»
          (pair after left (Law.orbit (asItWas alone left) s T)) :=
  Law.stepWhile_unending_iff.trans
    ⟨fun all => match asItWasEnds with
      | ⟨n, ended⟩ =>
        match first_of_decided
            (P := fun t => need ≤ (Law.orbit (asItWas alone left) s t).2 ∧
              ¬ marked (Law.orbit (asItWas alone left) s t).2)
            (Q := fun t => ¬ (need ≤ (Law.orbit (asItWas alone left) s t).2 ∧
              ¬ marked (Law.orbit (asItWas alone left) s t).2))
            (fun t => if h : need ≤ (Law.orbit (asItWas alone left) s t).2 ∧
                ¬ marked (Law.orbit (asItWas alone left) s t).2 then .inl h else .inr h)
            n with
        | .inl allP => absurd (allP n (Nat.le_refl n)).1 (Nat.not_le_of_gt ended)
        | .inr ⟨T, _, notP, before⟩ =>
          have agree : ∀ j, j ≤ T →
              Law.orbit (pair after left) s j = Law.orbit (asItWas alone left) s j :=
            fun j le => agrees_until_marked outside left s j
              (fun i lt => (before i (Nat.lt_of_lt_of_le lt le)).2)
          have atT : need ≤ (Law.orbit (asItWas alone left) s T).2 :=
            Eq.subst (motive := fun z : W × Nat => need ≤ z.2) (agree T (Nat.le_refl T)) (all T)
          have markedT : marked (Law.orbit (asItWas alone left) s T).2 :=
            if h : marked (Law.orbit (asItWas alone left) s T).2 then h
            else absurd ⟨atT, h⟩ notP
          ⟨T, before, atT, markedT, Law.stepWhile_unending_iff.mpr fun k =>
            Eq.subst (motive := fun z : W × Nat => need ≤ z.2)
              ((Law.orbit_add (pair after left) s T (k + 1)).trans
                ((Law.orbit_shift (pair after left) _ k).trans
                  (congrArg (fun z => Law.orbit (pair after left) (pair after left z) k)
                    (agree T (Nat.le_refl T)))))
              (all (T + (k + 1)))⟩,
     fun ⟨T, before, atT, _, onward⟩ =>
      have agree : ∀ j, j ≤ T →
          Law.orbit (pair after left) s j = Law.orbit (asItWas alone left) s j :=
        fun j le => agrees_until_marked outside left s j
          (fun i lt => (before i (Nat.lt_of_lt_of_le lt le)).2)
      have later := Law.stepWhile_unending_iff.mp onward
      fun n => match Nat.lt_or_ge n (T + 1) with
        | .inl lt =>
          have le : n ≤ T := Nat.le_of_lt_succ lt
          have val : need ≤ (Law.orbit (asItWas alone left) s n).2 :=
            match Nat.lt_or_eq_of_le le with
            | .inl lt' => (before n lt').1
            | .inr e => Eq.subst
                (motive := fun i => need ≤ (Law.orbit (asItWas alone left) s i).2)
                e.symm atT
          Eq.subst (motive := fun z : W × Nat => need ≤ z.2) (agree n le).symm val
        | .inr ge => match le_dest ge with
          | ⟨k, e⟩ =>
            Eq.subst (motive := fun z : W × Nat => need ≤ z.2)
              ((congrArg (Law.orbit (pair after left) s) e).trans
                ((Law.orbit_add (pair after left) s (T + 1) k).trans
                  (congrArg (fun z => Law.orbit (pair after left) (pair after left z) k)
                    (agree T (Nat.le_refl T))))).symm
              (later k)⟩

/-- **From a way of the kept kind the pair's level is the level's course under `H₂`.** From a way `w`
of a kind every step keeps (`kept`) whose ways use `H₂` (`uses`), at every step the pair's way is of
that kind and its level is `Law.orbit (RegimeMargin.step giving H₂) x` at that step. Needed by
`unending_iff_above` and `course_turned`. -/
private theorem kept_run {Kept : W → Prop} {after : W → Nat → W} {giving : Nat → Nat}
    {use : W → Nat} {H₂ : Nat}
    (kept : ∀ w x, Kept w → Kept (after w x)) (uses : ∀ w, Kept w → use w = H₂)
    {w : W} {x : Nat} (kind : Kept w) : ∀ n,
      Kept (Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) n).1 ∧
      (Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) n).2 =
        Law.orbit (RegimeMargin.step giving H₂) x n
  | 0 => ⟨kind, rfl⟩
  | n + 1 =>
    have ih := kept_run kept uses kind n
    ⟨kept _ _ ih.1,
      (congrArg (fun H => RegimeMargin.step giving H
        (Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) n).2)
        (uses _ ih.1)).trans (congrArg (RegimeMargin.step giving H₂) ih.2)⟩

/-- **From a way of a kind every step keeps, that uses `H₂`, the line never ends exactly where the
level is at or above `H₂ + y₂`**: with nothing given from nothing, giving short of `H₂` below `y₂`,
meeting it from `y₂` up to `hi` and the step keeping the level within `hi`, a positive need at most
`H₂ + y₂`, and the level at most `hi`. By `RegimeMargin.ends_iff_below` and `RegimeMargin.holds`. -/
theorem unending_iff_above {Kept : W → Prop} {after : W → Nat → W} {giving : Nat → Nat}
    {use : W → Nat} {H₂ y₂ hi need : Nat}
    (kept : ∀ w x, Kept w → Kept (after w x)) (uses : ∀ w, Kept w → use w = H₂)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H₂ y₂)
    (meets : RegimeMargin.Meets giving H₂ y₂ hi) (keeps : RegimeMargin.Keeps giving H₂ hi)
    (needs : 0 < need) (within : need ≤ H₂ + y₂) {w : W} {x : Nat} (kind : Kept w) (high : x ≤ hi) :
    «不穷» (net need after (fun w x => RegimeMargin.step giving (use w) x)) «一» (w, x) ↔
      H₂ + y₂ ≤ x :=
  have run := kept_run (giving := giving) kept uses kind
  Law.stepWhile_unending_iff.trans
    ⟨fun all => (Nat.lt_or_ge x (H₂ + y₂)).elim
      (fun lt => match (RegimeMargin.ends_iff_below (Nat.lt_of_lt_of_le needs within) short nothing
          meets keeps high).mpr lt with
        | ⟨n, zero⟩ => absurd (Nat.le_trans (all n) (Nat.le_of_eq ((run n).2.trans zero)))
            (Nat.not_le_of_gt needs))
      id,
     fun low n => Nat.le_trans within (Nat.le_trans low
      (Nat.le_trans (RegimeMargin.holds meets keeps low high n).1 (Nat.le_of_eq (run n).2.symm)))⟩

/-- **Turning in time, exactly.** With `AloneOutside` and decided marks; a way after a marked step of
the kept kind (`turns`), a kind every step keeps (`kept`) that uses `H₂` (`uses`); nothing given from
nothing; giving short of `H₂` below `y₂`, meeting it from `y₂` up to `hi`, the step under `H₂` keeping
the level within `hi`; a positive need at most `H₂ + y₂`; giving short of `H₁` below `y₁`, every way on
`alone`'s orbit from `w` using at least `H₁`, and the start `x` below `H₁ + y₁` and at most `hi`: the
line from `(w, x)` never ends exactly where there is a step `T` of the course as it was, the need met
and no level marked before it, the need met and the level marked at it, and the level of the course as
it was at `T + 1` at or above `H₂ + y₂`. The level at `T + 1` of the course as it was is the level
after the turning step: both are `left` of the way and level at `T`. -/
theorem turns_in_time_iff {marked : Nat → Prop} [DecidablePred marked] {alone : W → W}
    {after : W → Nat → W} {Kept : W → Prop} {giving : Nat → Nat} {use : W → Nat}
    {H₁ y₁ H₂ y₂ hi need : Nat}
    (outside : AloneOutside marked alone after) (turns : ∀ w x, marked x → Kept (after w x))
    (kept : ∀ w x, Kept w → Kept (after w x)) (uses : ∀ w, Kept w → use w = H₂)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H₂ y₂)
    (meets : RegimeMargin.Meets giving H₂ y₂ hi) (keeps : RegimeMargin.Keeps giving H₂ hi)
    (needs : 0 < need) (within : need ≤ H₂ + y₂)
    (short₁ : RegimeMargin.Short giving H₁ y₁) {w : W} {x : Nat}
    (uses₁ : ∀ j, H₁ ≤ use (Law.orbit alone w j)) (below : x < H₁ + y₁) (high : x ≤ hi) :
    «不穷» (net need after (fun w x => RegimeMargin.step giving (use w) x)) «一» (w, x) ↔
      ∃ T, (∀ j, j < T →
          need ≤ (Law.orbit (asItWas alone
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2 ∧
          ¬ marked (Law.orbit (asItWas alone
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2) ∧
        need ≤ (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 ∧
        marked (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 ∧
        H₂ + y₂ ≤ (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) (T + 1)).2 :=
  have levels := regime_levels
    (X := fun t => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2)
    (D := fun t => use (Law.orbit alone w t)) nothing short₁ uses₁ below
    (fun t => congrArg (fun v => RegimeMargin.step giving (use v) (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) (asItWas_way alone _ (w, x) t))
  have bound := Optimum.level_le_start (x := fun t => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) levels.1 levels.2.1 levels.2.2
  have ends : ∃ n, (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) n).2 < need :=
    ⟨x, Optimum.ends_within (x := fun t => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) levels.1 levels.2.1 levels.2.2
      needs x (Nat.lt_add_of_pos_left needs)⟩
  have above : ∀ T, marked (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 →
      («不穷» (net need after (fun w x => RegimeMargin.step giving (use w) x)) «一»
        (pair after (fun w x => RegimeMargin.step giving (use w) x)
          (Law.orbit (asItWas alone
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T)) ↔
        H₂ + y₂ ≤ (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) (T + 1)).2) :=
    fun T markedT => unending_iff_above
      (w := after (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).1
        (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2)
      (x := (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) (T + 1)).2)
      kept uses nothing short meets keeps needs within (turns _ _ markedT)
      (Nat.le_trans (bound (T + 1)) high)
  (unending_iff_first_marked outside ends).trans
    ⟨fun ⟨T, before, atT, markedT, onward⟩ =>
      ⟨T, before, atT, markedT, (above T markedT).mp onward⟩,
     fun ⟨T, before, atT, markedT, enough⟩ =>
      ⟨T, before, atT, markedT, (above T markedT).mpr enough⟩⟩

/-- **The line under the kind ends while the net goes on.** At a level that meets the need, where the
way after the step is of another kind, the configuration ends under the kind's class and still
conditions something. -/
theorem kind_ends_while_net_goes {K : Type v} {κ : W → K} {need : Nat} {after : W → Nat → W}
    {left : W → Nat → Nat} {w : W} {x : Nat} (ge : need ≤ x) (other : ¬ κ (after w x) = κ w) :
    «亡» (net need after left) (sameValue (fun s : W × Nat => κ s.1)) (w, x) ∧
      ∃ v, net need after left (w, x) v :=
  ⟨fun ⟨_, ⟨_, e⟩, same⟩ =>
    other ((congrArg (fun z : W × Nat => κ z.1) e).symm.trans same.symm),
   ⟨pair after left (w, x), ge, rfl⟩⟩

/-- **Where at a level `x` that meets the need the way after the step is of another kind, and some
level `x₀` that meets the need is not marked, the class of a kind that `alone` keeps is not constant
up to the net's end at `(w, x)`'s class.** With `AloneOutside`, for a kind `κ : W → K` of any type.
That `x` is marked is not a premise: were it not marked, `outside` and `keeps` would give the way after
the step the kind of the way. The pair's case of `«出类不随则本类不至终有常»`: `(w, x)` conditions a
configuration of another kind, while `(w, x₀)`, of its kind, conditions something and nothing of that
other kind. -/
theorem kind_not_toEnd_of_turn {K : Type v} {marked : Nat → Prop} {alone : W → W}
    {after : W → Nat → W} (outside : AloneOutside marked alone after) {need : Nat} {κ : W → K}
    (keeps : ∀ w, κ (alone w) = κ w) {left : W → Nat → Nat} {w : W} {x x₀ : Nat}
    (ge : need ≤ x) (other : ¬ κ (after w x) = κ w) (ge₀ : need ≤ x₀) (un₀ : ¬ marked x₀) :
    ¬ «本类至终有常» (net need after left) (sameValue (fun s : W × Nat => κ s.1)) (w, x) :=
  «出类不随则本类不至终有常» (sameValue_class (fun s : W × Nat => κ s.1))
    (m := (w, x)) (c := (w, x₀)) (u := pair after left (w, x)) rfl ⟨ge, rfl⟩
    (fun e => other e.symm) ⟨pair after left (w, x₀), ge₀, rfl⟩
    (fun _ ⟨_, ey⟩ e => other (e.trans ((congrArg (fun z : W × Nat => κ z.1) ey).trans
      ((congrArg κ (outside w x₀ un₀)).trans (keeps w)))))

/-! ## 6. The lock's courses as courses of the pair

`RuleCapture`'s lock and `PoolFromCourse`'s window course, read in this module's terms; the lock's own
names are cited here. `ClosedCapture`'s joined two-level step, regrouped with the share, the rule and
the step count as the way and the loss as the level (`windowRegroup`), is the pair's step, and a total
step is the net at a need of nothing (`net_zero`). The course that reads off the share
(`ClosedCapture.joinRead`) is the window course as it was (`join_is_asItWas`): at every step, regrouped,
it is the orbit of `asItWas (windowAlone fA hA reads) (windowLeft fB)`. The window course is the orbit
of `pair (windowAfter …) (windowLeft fB)` (`window_is_pair`; on `PoolFromCourse`'s own course function
`paced`, `window_paced`); at every level outside `[N, K)` its way after a step is `windowAlone`, the
rule read off the share by `hA` on the same schedule (`window_alone_outside`); and it agrees with the
course that reads off the share until that course's loss first lies in `[N, K)`
(`window_agrees_until_marked`, which is `agrees_until_marked` read on the window). Along the course
that reads off the share the locked region is closed (`locked_closed`), which at a locked member is the
root's condition at its class (`locked_at_class`). Along the way's step as it was (`windowAlone`) a
`Locked` way stays `Locked` (`locked_alone`). Nothing here derives that a lock needs nothing of what it
uses: that a lock's own models need nothing is how they are built. They have a total step, so in them
no line ends where the net ends, and `ends_with_net` and the split at the first marked level do not
apply to them; the laws on a kind's class hold at every need. At a positive need the lock's way is
no longer a case that needs nothing: where the way's step as it was is the lock's, under
`turn_locked`'s premises and `ends_with_net`'s, a `Locked` start ends `Locked` where the net ends
(`locked_ends_with_net`). Nothing here re-proves `locked_stays`, `lock_line`, `window_never_read`,
`window_past_course` or `course_past`; `locked_alone` is `locked_stays`'s counterpart on `windowAlone`
from any step count, by the same law, `turn_locked`. -/

section Lock

open Pace RuleCapture ClosedCapture PoolFromCourse

universe w

variable {A : Type u} {B : Type v} {R : Type w}

/-- **The locked region is closed under the joined two-level step.** Where the selection raises the
share under every favouring rule (`Raises`), the rule read is monotone in the share (`ReadsShare`)
and favouring is kept by a rule not lower (`upper`), whatever
`Law.step (Pace.step (join fA fB) (joinRead hA) reads)` relates to a configuration whose share and rule
are `Locked` has its share and rule `Locked`, at reading steps and elsewhere. No `Accrues` is used: the
step on what lies beyond the share is any `fB`. -/
theorem locked_closed {P : Ideals.Preorder A} {M : Ideals.Preorder R} {favours : R → Prop}
    {fA : A → R → A} {fB : A × B → R → B} {hA : A → R → R} {reads : Nat → Bool}
    (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') :
    «闭» (Law.step (Pace.step (join fA fB) (joinRead hA) reads))
      (fun q : (A × B) × R × Nat => Locked M favours hA (q.1.1, q.2.1)) :=
  fun q _ lock step =>
    have joined := turn_join fA fB hA (reads q.2.2) (q.1, q.2.1) (q.1.1, q.2.1) rfl rfl
    have kept := (turn_locked raises monotone upper (reads q.2.2) (q.1.1, q.2.1) lock).1
    Eq.subst (motive := fun q' : (A × B) × R × Nat => Locked M favours hA (q'.1.1, q'.2.1)) step.symm
      (Eq.subst (motive := fun p : A × R => Locked M favours hA p)
        (congr (congrArg Prod.mk joined.1) joined.2).symm kept)

/-- **At a locked member the class of being locked or not meets the root's condition at the member's
class (`«本类至终有常»`), and what the member conditions is alike to it (`«所缘同于»`).** Under the premises of `locked_closed`, at a configuration `m`
of the joined two-level step whose share and rule are `Locked`, `«本类至终有常»` and `«所缘同于»` hold
for `ClosedCapture.lockedAlike`: the locked region closed under the step (`locked_closed`) is the
member's block, and `«类闭则本类常闭»` gives both, its decidedness met because the step is total. -/
theorem locked_at_class {P : Ideals.Preorder A} {M : Ideals.Preorder R} {favours : R → Prop}
    {fA : A → R → A} {fB : A × Nat → R → Nat} {hA : A → R → R} {reads : Nat → Bool}
    (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {m : (A × Nat) × R × Nat}
    (locked : Locked M favours hA (m.1.1, m.2.1)) :
    «本类至终有常» (Law.step (Pace.step (join fA fB) (joinRead hA) reads)) (lockedAlike M favours hA) m ∧
      «所缘同于» (Law.step (Pace.step (join fA fB) (joinRead hA) reads)) (lockedAlike M favours hA) m :=
  «类闭则本类常闭» (lockedAlike_class M favours hA)
    (fun u v alike step =>
      ⟨fun _ => locked_closed raises monotone upper u v (alike.mp locked) step, fun _ => locked⟩)
    (fun _ _ => .inl ⟨_, rfl⟩)

/-- The regrouping of a configuration of the joined two-level step: what the loop reads
(`ClosedCapture.loopPart`: the share, the rule and the step count) as the way, the loss
(`ClosedCapture.loss`) as the level. -/
def windowRegroup (q : (A × Nat) × R × Nat) : (A × R × Nat) × Nat :=
  (ClosedCapture.loopPart q, ClosedCapture.loss q)

/-- The way after a step of the window course, read off `Pace.step`, `ClosedCapture.join` and
`PoolFromCourse.windowRead`: the share steps by `fA`, the rule is read through the window where the
schedule reads and kept elsewhere, and the step count goes up by one. -/
def windowAfter (fA : A → R → A) (hA : A → R → R) (hL : A × Nat → R → R) (N K : Nat)
    (reads : Nat → Bool) (w : A × R × Nat) (x : Nat) : A × R × Nat :=
  (fA w.1 w.2.1, bif reads w.2.2 then windowRead hA hL N K (w.1, x) w.2.1 else w.2.1, w.2.2 + 1)

/-- The level after a step of the window course: the loss steps by `fB`. -/
def windowLeft (fB : A × Nat → R → Nat) (w : A × R × Nat) (x : Nat) : Nat := fB (w.1, x) w.2.1

/-- The way after a step where the rule is read off the share alone, by `hA`, on the same schedule. -/
def windowAlone (fA : A → R → A) (hA : A → R → R) (reads : Nat → Bool) (w : A × R × Nat) :
    A × R × Nat :=
  (fA w.1 w.2.1, bif reads w.2.2 then hA w.1 w.2.1 else w.2.1, w.2.2 + 1)

/-- `windowAlone`'s share and rule are one `Pace.turn` of the share and rule, reading where the
schedule reads at the step count. Needed by `locked_alone`. -/
private theorem windowAlone_turn (fA : A → R → A) (hA : A → R → R) (reads : Nat → Bool)
    (v : A × R × Nat) :
    ((windowAlone fA hA reads v).1, (windowAlone fA hA reads v).2.1) =
      Pace.turn fA hA (reads v.2.2) (v.1, v.2.1) :=
  (fun b => match b with
    | true => (rfl : ((fA v.1 v.2.1, hA v.1 v.2.1) : A × R) = Pace.turn fA hA true (v.1, v.2.1))
    | false => (rfl : ((fA v.1 v.2.1, v.2.1) : A × R) = Pace.turn fA hA false (v.1, v.2.1)) :
    ∀ b : Bool, ((fA v.1 v.2.1, bif b then hA v.1 v.2.1 else v.2.1) : A × R) =
      Pace.turn fA hA b (v.1, v.2.1)) (reads v.2.2)

/-- **Along the way's step as it was, a way whose share and rule are `Locked` stays so.** Where the
selection raises the share under every favouring rule (`Raises`), the rule read is monotone in the
share (`ReadsShare`) and favouring is kept by a rule not lower (`upper`), from a way `w` whose share and
rule are `Locked`, the way `windowAlone fA hA reads` taken `n` times has its share and rule `Locked`,
for every `n`. By `RuleCapture.turn_locked`: `windowAlone`'s share and rule are
`Pace.turn fA hA (reads w.2.2) (w.1, w.2.1)`. -/
theorem locked_alone {P : Ideals.Preorder A} {M : Ideals.Preorder R} {favours : R → Prop}
    {fA : A → R → A} {hA : A → R → R} {reads : Nat → Bool}
    (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {w : A × R × Nat}
    (locked : Locked M favours hA (w.1, w.2.1)) :
    ∀ n, Locked M favours hA ((Law.orbit (windowAlone fA hA reads) w n).1,
      (Law.orbit (windowAlone fA hA reads) w n).2.1)
  | 0 => locked
  | n + 1 =>
    Eq.subst (motive := fun p : A × R => Locked M favours hA p)
      (windowAlone_turn fA hA reads (Law.orbit (windowAlone fA hA reads) w n)).symm
      (turn_locked raises monotone upper _ _ (locked_alone raises monotone upper locked n)).1

/-- **A `Locked` way that needs a level ends `Locked`, where the net ends.** The way's step as it was
is the lock's (`windowAlone`: the share steps by `fA`, the rule is read off the share by `hA` where the
schedule `reads` reads at the step count and kept elsewhere, the step count goes up by one); the
level's step `left` is any. Where the selection raises the share under every favouring rule
(`Raises`), the rule read is monotone in the share (`ReadsShare`) and favouring is kept by a rule not
lower (`upper`); at every level not marked the way after a step is `windowAlone` of the way
(`AloneOutside`); the need is positive (`needs`) and no marked level meets it (`un`); and the level of
the course as it was steps in `Optimum`'s form (`step`), at most `r` given (`renews`) and more than
`r` taken (`over`) at every step: then from a start `s` whose share and rule are `Locked`, within
`s.2` steps the line reaches a configuration that conditions nothing, its share and rule still
`Locked`. It is `ends_with_net` with `locked_alone`; no `Accrues` is used. It is read as the
counterpart of `ClosedCapture.lock_outlives_loss` where what is used up is a level the going on needs:
there the lock stays and the loss grows without end, here the lock stays and the line ends. That is a
reading of the two statements, not a derivation of one from the other. -/
theorem locked_ends_with_net {P : Ideals.Preorder A} {M : Ideals.Preorder R} {favours : R → Prop}
    {fA : A → R → A} {hA : A → R → R} {reads : Nat → Bool}
    (raises : Raises P favours fA) (monotone : ReadsShare P M hA)
    (upper : ∀ {g g'}, M.le g g' → favours g → favours g') {marked : Nat → Prop}
    {after : A × R × Nat → Nat → A × R × Nat} {left : A × R × Nat → Nat → Nat}
    (outside : AloneOutside marked (windowAlone fA hA reads) after) {need : Nat} (needs : 0 < need)
    (un : ∀ x, need ≤ x → ¬ marked x) {s : (A × R × Nat) × Nat}
    (locked : Locked M favours hA (s.1.1, s.1.2.1)) {g d : Nat → Nat} {r : Nat}
    (step : ∀ t, (Law.orbit (asItWas (windowAlone fA hA reads) left) s (t + 1)).2 =
      (Law.orbit (asItWas (windowAlone fA hA reads) left) s t).2 + g t - d t)
    (renews : ∀ t, g t ≤ r) (over : ∀ t, r < d t) :
    ∃ n t, n ≤ s.2 ∧ «迭» (net need after left) n s t ∧ (∀ v, ¬ net need after left t v) ∧
      Locked M favours hA (t.1.1, t.1.2.1) :=
  match ends_with_net outside needs un step renews over with
  | ⟨n, t, within, line, ends, way⟩ =>
    ⟨n, t, within, line, ends,
      Eq.subst (motive := fun z : A × R × Nat => Locked M favours hA (z.1, z.2.1)) way.symm
        (locked_alone raises monotone upper locked n)⟩

/-- One step of the joined two-level step with any reading `h`, regrouped, is one step of the pair.
Needed by `regroup_orbit`. -/
private theorem regroup_step (fA : A → R → A) (fB : A × Nat → R → Nat) (h : A × Nat → R → R)
    (reads : Nat → Bool) (q : (A × Nat) × R × Nat) :
    windowRegroup (Pace.step (join fA fB) h reads q) =
      pair (fun w x => (fA w.1 w.2.1, bif reads w.2.2 then h (w.1, x) w.2.1 else w.2.1, w.2.2 + 1))
        (windowLeft fB) (windowRegroup q) :=
  match q with
  | ((a, x), g, n) =>
    have each : ∀ b : Bool,
        (((Pace.turn (join fA fB) h b ((a, x), g)).1.1,
            (Pace.turn (join fA fB) h b ((a, x), g)).2, n + 1),
          (Pace.turn (join fA fB) h b ((a, x), g)).1.2) =
        ((fA a g, bif b then h (a, x) g else g, n + 1), fB (a, x) g)
      | true => rfl
      | false => rfl
    each (reads n)

/-- The joined two-level course with any reading `h`, regrouped, is at every step the orbit of the
pair. One induction, used by `window_is_pair` and `join_is_asItWas`. -/
private theorem regroup_orbit (fA : A → R → A) (fB : A × Nat → R → Nat) (h : A × Nat → R → R)
    (reads : Nat → Bool) (c : (A × Nat) × R × Nat) :
    ∀ t, windowRegroup (Law.orbit (Pace.step (join fA fB) h reads) c t) =
      Law.orbit (pair (fun w x => (fA w.1 w.2.1, bif reads w.2.2 then h (w.1, x) w.2.1 else w.2.1,
        w.2.2 + 1)) (windowLeft fB)) (windowRegroup c) t
  | 0 => rfl
  | t + 1 =>
    (regroup_step fA fB h reads _).trans
      (congrArg (pair (fun w x => (fA w.1 w.2.1, bif reads w.2.2 then h (w.1, x) w.2.1 else w.2.1,
        w.2.2 + 1)) (windowLeft fB)) (regroup_orbit fA fB h reads c t))

/-- Two configurations of the joined two-level step with one regrouping are one. Needed by
`window_agrees_until_marked`. -/
private theorem windowRegroup_inj {q q' : (A × Nat) × R × Nat}
    (e : windowRegroup q = windowRegroup q') : q = q' :=
  congrArg (fun p : (A × R × Nat) × Nat => ((p.1.1, p.2), p.1.2.1, p.1.2.2)) e

/-- **The window course is a course of the pair, by regrouping.** For every start `c` and step `t`,
the configuration `t` steps along `Pace.step (join fA fB) (windowRead hA hL N K) reads` from `c`,
regrouped by `windowRegroup`, is the configuration `t` steps along `pair (windowAfter …) (windowLeft fB)`
from `c` regrouped. On `PoolFromCourse`'s own course function, `window_paced`. -/
theorem window_is_pair (fA : A → R → A) (fB : A × Nat → R → Nat) (hA : A → R → R)
    (hL : A × Nat → R → R) (N K : Nat) (reads : Nat → Bool) (c : (A × Nat) × R × Nat) :
    ∀ t, windowRegroup (Law.orbit (Pace.step (join fA fB) (windowRead hA hL N K) reads) c t) =
      Law.orbit (pair (windowAfter fA hA hL N K reads) (windowLeft fB)) (windowRegroup c) t :=
  regroup_orbit fA fB (windowRead hA hL N K) reads c

/-- **The joined step that reads off the share, regrouped, is the window pair's step as it was.** For
every start `c` and step `t`, the configuration `t` steps along
`Pace.step (join fA fB) (joinRead hA) reads` from `c`, regrouped, is the configuration `t` steps along
`asItWas (windowAlone fA hA reads) (windowLeft fB)` from `c` regrouped. -/
theorem join_is_asItWas (fA : A → R → A) (fB : A × Nat → R → Nat) (hA : A → R → R)
    (reads : Nat → Bool) (c : (A × Nat) × R × Nat) :
    ∀ t, windowRegroup (Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) c t) =
      Law.orbit (asItWas (windowAlone fA hA reads) (windowLeft fB)) (windowRegroup c) t :=
  regroup_orbit fA fB (joinRead hA) reads c

/-- **Outside the window the way after a step is the share's reading.** At every level not in
`[N, K)`, `windowAfter` is `windowAlone`: the window reads the rule off the share by `hA` there, on the
same schedule. -/
theorem window_alone_outside (fA : A → R → A) (hA : A → R → R) (hL : A × Nat → R → R) (N K : Nat)
    (reads : Nat → Bool) :
    AloneOutside (fun x => N ≤ x ∧ x < K) (windowAlone fA hA reads) (windowAfter fA hA hL N K reads) :=
  fun w _ outside =>
    congrArg (fun g => (fA w.1 w.2.1, bif reads w.2.2 then g else w.2.1, w.2.2 + 1))
      (if_neg outside)

/-- **The window course is the course that reads off the share up to the first step at which that
course's loss lies in `[N, K)`.** For every start `c` and step `n`: where at no step before `n` the
loss of the course along `Pace.step (join fA fB) (joinRead hA) reads` from `c` lies in `[N, K)`, the
window course from `c` is that course at `n`. `agrees_until_marked` read on the window, through
`window_is_pair`, `join_is_asItWas` and `window_alone_outside`. Its neighbours: `window_through` and
`window_past` (past `K` the window reads off the share, pointwise), `window_unread` (at `K ≤ N` it
reads off the share at every configuration: the case with no marked level),
`window_past_course` (past `K`, the window course is the share's own loop from where it is) and
`course_past` (two readings that agree past a bound give one course from a start past it); none of
them says that the window course is the course read off the share before its loss is first marked. -/
theorem window_agrees_until_marked (fA : A → R → A) (fB : A × Nat → R → Nat) (hA : A → R → R)
    (hL : A × Nat → R → R) (N K : Nat) (reads : Nat → Bool) (c : (A × Nat) × R × Nat) :
    ∀ n,
    (∀ j, j < n → ¬ (N ≤ (Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) c j).1.2 ∧
        (Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) c j).1.2 < K)) →
      Law.orbit (Pace.step (join fA fB) (windowRead hA hL N K) reads) c n =
        Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) c n :=
  fun n before =>
    windowRegroup_inj ((window_is_pair fA fB hA hL N K reads c n).trans
      ((agrees_until_marked (window_alone_outside fA hA hL N K reads) (windowLeft fB)
          (windowRegroup c) n
          (fun j lt => Eq.subst (motive := fun z : (A × R × Nat) × Nat => ¬ (N ≤ z.2 ∧ z.2 < K))
            (join_is_asItWas fA fB hA reads c j) (before j lt))).trans
        (join_is_asItWas fA fB hA reads c n).symm))

/-- **The identification on PoolFromCourse's own course function.** For every start `c` and step `t`,
the window course `paced (join fA fB) (windowRead hA hL N K) reads c t` with the step count `t`,
regrouped, is the configuration `t` steps along `pair (windowAfter …) (windowLeft fB)` from `c` at step
count `0` regrouped: `window_is_pair` composed with `ClosedCapture.orbit_paced`. -/
theorem window_paced (fA : A → R → A) (fB : A × Nat → R → Nat) (hA : A → R → R)
    (hL : A × Nat → R → R) (N K : Nat) (reads : Nat → Bool) (c : (A × Nat) × R) (t : Nat) :
    (((paced (join fA fB) (windowRead hA hL N K) reads c t).1.1,
        (paced (join fA fB) (windowRead hA hL N K) reads c t).2, t),
      (paced (join fA fB) (windowRead hA hL N K) reads c t).1.2) =
      Law.orbit (pair (windowAfter fA hA hL N K reads) (windowLeft fB)) ((c.1.1, c.2, 0), c.1.2) t :=
  (congrArg windowRegroup
      (ClosedCapture.orbit_paced (join fA fB) (windowRead hA hL N K) reads c t)).symm.trans
    (window_is_pair fA fB hA hL N K reads (c.1, c.2, 0) t)

end Lock

/-! ## 7. The point of no return, a level and a step

`RegimeMargin` calls the level `H + y` the point of no return under a standing use `H`
(`RegimeMargin.ends_iff_below`); `ReadOffInTime` calls the first step at which a course is not
recoverable its point of no return (`NoReturnAt`), with the feasible courses and what is asked of a
course given. Here the two are joined for any level course `X` that never rises and starts at most
`hi`. The feasible courses are `X` turned to the standing use `H` at some step, the start included
(`turned`, `Turned`); what is asked of a course is that the need be met at every step (`MeetsNeed`);
courses are over one condition (`Unit`). Under nothing given from nothing and `RegimeMargin`'s
`Short`, `Meets` and `Keeps` at `H` with `y` and `hi`, and a positive need at most `H + y`: the course
turned at `T` meets the need at every step exactly where `H + y ≤ X T` (`turned_meets_iff`); `X` is
recoverable at `N` exactly where `H + y ≤ X N` (`recoverable_iff_above`); and its point of no return,
a step, is the first step at which its level is below `H + y` (`noReturnAt_iff_first_below`). On the
pair, the level course from `(w, x)` is the course as it was turned at `T + 1`, for `T` its first
marked step (`course_turned`, with no premise on the need); under `turns_in_time_iff`'s premises on
the regime and on the course as it was (none on the marks or the kept kind), the course as it was has
a point of no return within `x` steps (`noReturn_exists`); and under all of `turns_in_time_iff`'s
premises the line never ends exactly where, at the first marked step `T`, the need met there and
before, `T + 1` is before the point of no return of the course as it was (`turns_in_time_iff_before`,
through `course_turned`, `turned_meets_iff` and `recoverable_iff_above`). The feasible courses are
turns to one standing use; other continuations are not considered, and the marks stay given. -/

section PointOfNoReturn

/-- **The course `X` turned at step `T` to the standing use `H`**: `X t` at every step `t` up to `T`,
and from there the level's course under `RegimeMargin.step giving H` from `X T`. -/
def turned (X : Nat → Nat) (giving : Nat → Nat) (H T t : Nat) : Nat :=
  if t ≤ T then X t else Law.orbit (RegimeMargin.step giving H) (X T) (t - T)

/-- **The feasible courses**: the courses over one condition that are `X` turned to `H` at some step
`T`, the start included. -/
def Turned (X : Nat → Nat) (giving : Nat → Nat) (H : Nat) (l : Nat → Unit → Nat) : Prop :=
  ∃ T, ∀ t c, l t c = turned X giving H T t

/-- **What is asked of a course**: the need met at every step. -/
def MeetsNeed (need : Nat) (l : Nat → Unit → Nat) : Prop := ∀ t c, need ≤ l t c

/-- Up to step `T` the course turned at `T` is `X`. No premise. -/
private theorem turned_before {X : Nat → Nat} {giving : Nat → Nat} {H T t : Nat} (le : t ≤ T) :
    turned X giving H T t = X t :=
  if_pos le

/-- `k` steps after `T` the course turned at `T` is the level's course under `H` from `X T`, `k` steps
on. No premise. -/
private theorem turned_after (X : Nat → Nat) (giving : Nat → Nat) (H T : Nat) :
    ∀ k, turned X giving H T (T + k) = Law.orbit (RegimeMargin.step giving H) (X T) k
  | 0 => if_pos (Nat.le_refl T)
  | k + 1 =>
    (if_neg (Nat.not_le_of_gt (Nat.lt_succ_of_le (Nat.le_add_right T k)))).trans
      (congrArg (Law.orbit (RegimeMargin.step giving H) (X T))
        (Naturals.add_sub_cancel_left T (k + 1)))

/-- A course that never rises at any step (`fall`) is, `k` steps after `j`, at most where it was at
`j`. -/
private theorem fall_by {X : Nat → Nat} (fall : ∀ t, X (t + 1) ≤ X t) (j : Nat) :
    ∀ k, X (j + k) ≤ X j
  | 0 => Nat.le_refl _
  | k + 1 => Nat.le_trans (fall (j + k)) (fall_by fall j k)

/-- A course that never rises at any step (`fall`) is not higher at a later step: `X T ≤ X j` for
`j ≤ T`. -/
private theorem later_le {X : Nat → Nat} (fall : ∀ t, X (t + 1) ≤ X t) {j T : Nat} (le : j ≤ T) :
    X T ≤ X j :=
  match le_dest le with
  | ⟨k, e⟩ => Eq.subst (motive := fun i => X i ≤ X j) e.symm (fall_by fall j k)

/-- **A level whose course under `H` meets a positive need at every step is at or above `H + y`.**
With nothing given from nothing and giving short of `H` below `y`; by `RegimeMargin.ends_below`. -/
private theorem above_of_run_meets {giving : Nat → Nat} {H y need z : Nat}
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (needs : 0 < need) (meet : ∀ k, need ≤ Law.orbit (RegimeMargin.step giving H) z k) :
    H + y ≤ z :=
  (Nat.lt_or_ge z (H + y)).elim
    (fun lt => absurd (Nat.le_trans (meet z) (Nat.le_of_eq (RegimeMargin.ends_below short nothing lt)))
      (Nat.not_le_of_gt needs))
    id

/-- **Where the course turned at `T` meets a positive need at every step, it is at or above `H + y` at
every step from `T`.** With nothing given from nothing and giving short of `H` below `y`. -/
private theorem above_after {X : Nat → Nat} {giving : Nat → Nat} {H y need T : Nat}
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (needs : 0 < need) (meet : ∀ t, need ≤ turned X giving H T t) {M : Nat} (le : T ≤ M) :
    H + y ≤ turned X giving H T M :=
  match le_dest le with
  | ⟨k, e⟩ =>
    Eq.subst (motive := fun i => H + y ≤ turned X giving H T i) e.symm
      (Eq.subst (motive := fun z => H + y ≤ z) (turned_after X giving H T k).symm
        (above_of_run_meets nothing short needs fun j =>
          Eq.subst (motive := fun z => need ≤ z)
            ((turned_after X giving H T (k + j)).trans
              (Law.orbit_add (RegimeMargin.step giving H) (X T) k j))
            (meet (T + (k + j)))))

/-- **The course turned at `T` meets the need at every step where `H + y ≤ X T`** (R1, if). With `X`
never rising (`fall`) and starting at most `hi` (`top`), giving meeting `H` from `y` up to `hi`
(`meets`), the step under `H` keeping the level within `hi` (`keeps`), and the need at most `H + y`
(`within`); by `RegimeMargin.holds`. -/
theorem turned_meets_of_above {X : Nat → Nat} {giving : Nat → Nat} {H y hi need T : Nat}
    (fall : ∀ t, X (t + 1) ≤ X t) (top : X 0 ≤ hi)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (within : need ≤ H + y) (low : H + y ≤ X T) : ∀ t, need ≤ turned X giving H T t :=
  fun t => (Nat.lt_or_ge T t).elim
    (fun lt => match le_dest (Nat.le_of_lt lt) with
      | ⟨k, e⟩ => Eq.subst (motive := fun i => need ≤ turned X giving H T i) e.symm
          (Eq.subst (motive := fun z => need ≤ z) (turned_after X giving H T k).symm
            (Nat.le_trans within (Nat.le_trans low
              (RegimeMargin.holds meets keeps low
                (Nat.le_trans (later_le fall (Nat.zero_le T)) top) k).1))))
    (fun ge => Eq.subst (motive := fun z => need ≤ z) (turned_before ge).symm
      (Nat.le_trans within (Nat.le_trans low (later_le fall ge))))

/-- **Where the course turned at `T` meets the need at every step, `H + y ≤ X T`** (R1, only if).
With nothing given from nothing, giving short of `H` below `y`, and a positive need; by
`RegimeMargin.ends_below`. Nothing about `X` is used. -/
theorem above_of_turned_meets {X : Nat → Nat} {giving : Nat → Nat} {H y need T : Nat}
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (needs : 0 < need) (meet : ∀ t, need ≤ turned X giving H T t) : H + y ≤ X T :=
  Eq.subst (motive := fun z => H + y ≤ z) (turned_before (Nat.le_refl T))
    (above_after nothing short needs meet (Nat.le_refl T))

/-- **R1. The course turned at `T` meets the need at every step exactly where `H + y ≤ X T`.** With
`X` never rising (`fall`) and starting at most `hi` (`top`), nothing given from nothing, giving short
of `H` below `y`, meeting it from `y` up to `hi`, the step under `H` keeping the level within `hi`,
and a positive need at most `H + y`. The if direction uses `fall`, `top`, `meets`, `keeps` and
`within` (`turned_meets_of_above`); the only-if direction `nothing`, `short` and `needs`
(`above_of_turned_meets`). -/
theorem turned_meets_iff {X : Nat → Nat} {giving : Nat → Nat} {H y hi need T : Nat}
    (fall : ∀ t, X (t + 1) ≤ X t) (top : X 0 ≤ hi)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (needs : 0 < need) (within : need ≤ H + y) :
    (∀ t, need ≤ turned X giving H T t) ↔ H + y ≤ X T :=
  ⟨above_of_turned_meets nothing short needs, turned_meets_of_above fall top meets keeps within⟩

/-- **Where `H + y ≤ X N`, `X` is recoverable at `N`** (R2, if): the course turned at `N` agrees with
`X` up to `N` and meets the need at every step. With `X` never rising (`fall`) and starting at most
`hi` (`top`), giving meeting `H` from `y` up to `hi` (`meets`), the step under `H` keeping the level
within `hi` (`keeps`), and the need at most `H + y` (`within`). -/
theorem recoverable_of_above {X : Nat → Nat} {giving : Nat → Nat} {H y hi need N : Nat}
    (fall : ∀ t, X (t + 1) ≤ X t) (top : X 0 ≤ hi)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (within : need ≤ H + y) (low : H + y ≤ X N) :
    Recoverable (Turned X giving H) (MeetsNeed need) (fun t _ => X t) N :=
  ⟨fun t _ => turned X giving H N t, ⟨N, fun _ _ => rfl⟩, fun _ le _ => turned_before le,
   fun t _ => turned_meets_of_above fall top meets keeps within low t⟩

/-- **Where `X` is recoverable at `N`, `H + y ≤ X N`** (R2, only if). With `X` never rising (`fall`),
nothing given from nothing, giving short of `H` below `y`, and a positive need; by
`RegimeMargin.ends_below`. A turn at `T` before `N` that meets the need is at or above `H + y` from
`T` on, `X N` among them; a turn at `T` after `N` has `H + y ≤ X T ≤ X N`. -/
theorem above_of_recoverable {X : Nat → Nat} {giving : Nat → Nat} {H y need N : Nat}
    (fall : ∀ t, X (t + 1) ≤ X t)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (needs : 0 < need) (rec : Recoverable (Turned X giving H) (MeetsNeed need) (fun t _ => X t) N) :
    H + y ≤ X N :=
  match rec with
  | ⟨_, ⟨T, eq⟩, agree, meet⟩ =>
    have meetT : ∀ t, need ≤ turned X giving H T t := fun t =>
      Eq.subst (motive := fun z => need ≤ z) (eq t ()) (meet t ())
    (Nat.lt_or_ge N T).elim
      (fun lt => Nat.le_trans (above_of_turned_meets nothing short needs meetT)
        (later_le fall (Nat.le_of_lt lt)))
      (fun ge => Eq.subst (motive := fun z => H + y ≤ z)
        ((eq N ()).symm.trans (agree N (Nat.le_refl N) ()))
        (above_after nothing short needs meetT ge))

/-- **R2. `X` is recoverable at `N` exactly where `H + y ≤ X N`**: `RegimeMargin`'s point of no
return, a level, read on `ReadOffInTime`'s `Recoverable` with the turns of `X` to `H` as the feasible
courses and the need met at every step as what is asked. With `X` never rising (`fall`) and starting at
most `hi` (`top`), nothing given from nothing, giving short of `H` below `y`, meeting it from `y` up to
`hi`, the step under `H` keeping the level within `hi`, and a positive need at most `H + y`. The if
direction uses `fall`, `top`, `meets`, `keeps` and `within` (`recoverable_of_above`); the only-if
direction `fall`, `nothing`, `short` and `needs` (`above_of_recoverable`). -/
theorem recoverable_iff_above {X : Nat → Nat} {giving : Nat → Nat} {H y hi need N : Nat}
    (fall : ∀ t, X (t + 1) ≤ X t) (top : X 0 ≤ hi)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (needs : 0 < need) (within : need ≤ H + y) :
    Recoverable (Turned X giving H) (MeetsNeed need) (fun t _ => X t) N ↔ H + y ≤ X N :=
  ⟨above_of_recoverable fall nothing short needs, recoverable_of_above fall top meets keeps within⟩

/-- **R3. The point of no return of `X`, a step, is the first step at which its level is below
`H + y`, the point of no return of the regime it can turn to.** Under `recoverable_iff_above`'s
premises: `X` never rising and starting at most `hi`, nothing given from nothing, giving short of `H`
below `y`, meeting it from `y` up to `hi`, the step under `H` keeping the level within `hi`, and a
positive need at most `H + y`. -/
theorem noReturnAt_iff_first_below {X : Nat → Nat} {giving : Nat → Nat} {H y hi need N : Nat}
    (fall : ∀ t, X (t + 1) ≤ X t) (top : X 0 ≤ hi)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (needs : 0 < need) (within : need ≤ H + y) :
    NoReturnAt (Turned X giving H) (MeetsNeed need) (fun t _ => X t) N ↔
      X N < H + y ∧ ∀ n, n < N → H + y ≤ X n :=
  have iff := fun n => recoverable_iff_above (X := X) (N := n) fall top nothing short meets keeps
    needs within
  ⟨fun ⟨fails, before⟩ =>
    ⟨(Nat.lt_or_ge (X N) (H + y)).elim id (fun ge => absurd ((iff N).mpr ge) fails),
     fun n lt => (iff n).mp (before n lt)⟩,
   fun ⟨below, before⟩ =>
    ⟨fun rec => Nat.not_le_of_gt below ((iff N).mp rec), fun n lt => (iff n).mpr (before n lt)⟩⟩

/-- Recoverability of `X` is decided at every step, through `recoverable_iff_above`'s two directions.
Under its premises: `X` never rising (`fall`) and starting at most `hi` (`top`), nothing given from
nothing, giving short of `H` below `y`, meeting it from `y` up to `hi`, the step under `H` keeping the
level within `hi`, and a positive need at most `H + y`. -/
private theorem recoverable_decided {X : Nat → Nat} {giving : Nat → Nat} {H y hi need : Nat}
    (fall : ∀ t, X (t + 1) ≤ X t) (top : X 0 ≤ hi)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (needs : 0 < need) (within : need ≤ H + y) :
    ∀ m, Recoverable (Turned X giving H) (MeetsNeed need) (fun t _ => X t) m ∨
      ¬ Recoverable (Turned X giving H) (MeetsNeed need) (fun t _ => X t) m :=
  fun m => (Nat.lt_or_ge (X m) (H + y)).elim
    (fun lt => .inr fun rec =>
      Nat.not_le_of_gt lt (above_of_recoverable fall nothing short needs rec))
    (fun ge => .inl (recoverable_of_above fall top meets keeps within ge))

/-- Where `X` is recoverable at `N`, with the need met at every step as what is asked, `X` meets the
need at every step up to `N`, whatever the feasible courses: the course that recovers agrees with `X`
there and meets the need. No premise. -/
private theorem met_of_recoverable {feasible : (Nat → Unit → Nat) → Prop} {X : Nat → Nat}
    {need N : Nat} (rec : Recoverable feasible (MeetsNeed need) (fun t _ => X t) N) :
    ∀ j, j ≤ N → need ≤ X j :=
  match rec with
  | ⟨_, _, agree, meet⟩ => fun j le =>
    Eq.subst (motive := fun z => need ≤ z) (agree j le ()) (meet j ())

/-- **Where `X` comes below `H + y`, it has a point of no return no later.** Under
`recoverable_iff_above`'s premises (`X` never rising and starting at most `hi`, nothing given from
nothing, giving short of `H` below `y`, meeting it from `y` up to `hi`, the step under `H` keeping the
level within `hi`, a positive need at most `H + y`), where `X n < H + y` there is a point of no return
`N ≤ n`; by `noReturnAt_of_past`, recoverability decided through `recoverable_iff_above`. `top`,
`meets`, `keeps` and `within` serve only to decide recoverability at each step; that `X` is not
recoverable at `n` uses `fall`, `nothing`, `short` and `needs`. -/
theorem noReturnAt_of_below {X : Nat → Nat} {giving : Nat → Nat} {H y hi need : Nat}
    (fall : ∀ t, X (t + 1) ≤ X t) (top : X 0 ≤ hi)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    (meets : RegimeMargin.Meets giving H y hi) (keeps : RegimeMargin.Keeps giving H hi)
    (needs : 0 < need) (within : need ≤ H + y) {n : Nat} (below : X n < H + y) :
    ∃ N, N ≤ n ∧ NoReturnAt (Turned X giving H) (MeetsNeed need) (fun t _ => X t) N :=
  noReturnAt_of_past (recoverable_decided fall top nothing short meets keeps needs within)
    (fun rec => Nat.not_le_of_gt below (above_of_recoverable fall nothing short needs rec))

/-- Under the regime the level of the course as it was never rises, and at step `x` it is below every
positive need, so it is nothing there. With nothing given from nothing, giving short of `H₁` below `y₁`, every way on
`alone`'s orbit from `w` using at least `H₁`, and the start `x` below `H₁ + y₁`; by `regime_levels`,
`Optimum.never_rises` and `Optimum.ends_within`. Needed by `noReturn_exists`,
`turns_in_time_iff_before` and `Three.noReturn`. -/
private theorem asItWas_falls {alone : W → W} {giving : Nat → Nat} {use : W → Nat} {H₁ y₁ : Nat}
    (nothing : RegimeMargin.FromNothing giving) (short₁ : RegimeMargin.Short giving H₁ y₁)
    {w : W} {x : Nat} (uses₁ : ∀ j, H₁ ≤ use (Law.orbit alone w j)) (below : x < H₁ + y₁) :
    (∀ t, (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x)
        (t + 1)).2 ≤
      (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) ∧
    ∀ m, 0 < m →
      (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) x).2 < m :=
  have levels := regime_levels
    (X := fun t => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2)
    (D := fun t => use (Law.orbit alone w t)) nothing short₁ uses₁ below
    (fun t => congrArg (fun v => RegimeMargin.step giving (use v) (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) (asItWas_way alone _ (w, x) t))
  ⟨fun t => Optimum.never_rises (x := fun t => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) levels.1 (levels.2.1 t)
      (levels.2.2 t),
   fun _ pos => Optimum.ends_within (x := fun t => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) levels.1 levels.2.1 levels.2.2
      pos x (Nat.lt_add_of_pos_left pos)⟩

/-- **R4. On the pair, the level course is the course as it was turned one step after its first
marked step.** With `AloneOutside`, a way after a marked step of the kept kind (`turns`), a kind every
step keeps (`kept`) that uses `H₂` (`uses`), and the level's step `RegimeMargin.step giving (use w)`:
where `T` is the first step at which the level of the course as it was from `(w, x)` is marked, the
pair's level course from `(w, x)` is, at every step, that course turned at `T + 1` to `H₂`. No premise
on the need, and none on `giving`. At the marked step `T` the way is still the way as it was, so the
level at `T + 1` is that of the course as it was; the way from `T + 1` on is of the kept kind. -/
theorem course_turned {marked : Nat → Prop} {alone : W → W} {after : W → Nat → W}
    {Kept : W → Prop} {giving : Nat → Nat} {use : W → Nat} {H₂ : Nat}
    (outside : AloneOutside marked alone after) (turns : ∀ w x, marked x → Kept (after w x))
    (kept : ∀ w x, Kept w → Kept (after w x)) (uses : ∀ w, Kept w → use w = H₂)
    {w : W} {x T : Nat}
    (before : ∀ j, j < T → ¬ marked (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2)
    (markedT : marked (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2) :
    ∀ t, (Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2 =
      turned (fun j => (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2) giving H₂ (T + 1) t :=
  have agree : ∀ j, j ≤ T →
      Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j =
        Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j :=
    fun j le => agrees_until_marked outside _ (w, x) j
      (fun i lt => before i (Nat.lt_of_lt_of_le lt le))
  have next : Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x)
      (T + 1) =
      (after (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).1
        (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2,
       (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x)
        (T + 1)).2) :=
    congrArg (pair after (fun w x => RegimeMargin.step giving (use w) x)) (agree T (Nat.le_refl T))
  have run := kept_run (giving := giving) kept uses
    (w := after (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x)
      T).1 (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2)
    (x := (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x)
      (T + 1)).2)
    (turns _ _ markedT)
  fun t => (Nat.lt_or_ge t (T + 1)).elim
    (fun lt => (congrArg Prod.snd (agree t (Nat.le_of_lt_succ lt))).trans
      (turned_before (X := fun j => (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2) (Nat.le_of_lt lt)).symm)
    (fun ge => match le_dest ge with
      | ⟨k, e⟩ =>
        Eq.subst (motive := fun i =>
            (Law.orbit (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x) i).2 =
              turned (fun j => (Law.orbit (asItWas alone
                (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2) giving H₂ (T + 1) i)
          e.symm
          ((congrArg Prod.snd
              ((Law.orbit_add (pair after (fun w x => RegimeMargin.step giving (use w) x)) (w, x)
                  (T + 1) k).trans
                (congrArg (fun s => Law.orbit
                  (pair after (fun w x => RegimeMargin.step giving (use w) x)) s k) next))).trans
            ((run k).2.trans (turned_after (fun j => (Law.orbit (asItWas alone
              (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2) giving H₂ (T + 1)
              k).symm)))

/-- **R5. The course as it was has a point of no return, within `x` steps.** Under
`turns_in_time_iff`'s premises on the regime and on the course as it was (none on the marks or the
kept kind): nothing given from nothing; giving short of `H₂` below `y₂`, meeting it from `y₂` up to
`hi`, the step under `H₂` keeping the level within `hi`; a positive need at most `H₂ + y₂`; giving
short of `H₁` below `y₁`, every way on `alone`'s orbit from `w` using at least `H₁`, and the start `x`
below `H₁ + y₁` and at most `hi`. Then the level course as it was from `(w, x)`, with the turns to
`H₂` as the feasible courses and the need met at every step as what is asked, has a point of no
return `N ≤ x`. By `noReturnAt_of_past`. The premises on `H₂` (with `high`) decide recoverability at
each step through `recoverable_iff_above`; that the course is not recoverable at step `x` needs only
that its level there is below the need (a course that agrees with it at `x` does not meet the need
there), which the premises on the course as it was give with a positive need
(`Optimum.ends_within`). -/
theorem noReturn_exists {alone : W → W} {giving : Nat → Nat} {use : W → Nat}
    {H₁ y₁ H₂ y₂ hi need : Nat}
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H₂ y₂)
    (meets : RegimeMargin.Meets giving H₂ y₂ hi) (keeps : RegimeMargin.Keeps giving H₂ hi)
    (needs : 0 < need) (within : need ≤ H₂ + y₂)
    (short₁ : RegimeMargin.Short giving H₁ y₁) {w : W} {x : Nat}
    (uses₁ : ∀ j, H₁ ≤ use (Law.orbit alone w j)) (below : x < H₁ + y₁) (high : x ≤ hi) :
    ∃ N, N ≤ x ∧ NoReturnAt
      (Turned (fun j => (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2) giving H₂)
      (MeetsNeed need)
      (fun t _ => (Law.orbit (asItWas alone
        (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) N :=
  have regime := asItWas_falls nothing short₁ uses₁ below
  noReturnAt_of_past
    (recoverable_decided (X := fun j => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2)
      regime.1 high nothing short meets keeps needs within)
    (fun rec => Nat.not_le_of_gt (regime.2 need needs) (met_of_recoverable rec x (Nat.le_refl x)))

/-- **R6. Turning in time is turning before the point of no return.** Under `turns_in_time_iff`'s
premises (`AloneOutside` and decided marks; a way after a marked step of the kept kind, a kind every
step keeps that uses `H₂`; nothing given from nothing; giving short of `H₂` below `y₂`, meeting it from
`y₂` up to `hi`, the step under `H₂` keeping the level within `hi`; a positive need at most
`H₂ + y₂`; giving short of `H₁` below `y₁`, every way on `alone`'s orbit from `w` using at least `H₁`,
and the start `x` below `H₁ + y₁` and at most `hi`): the line from `(w, x)` never ends exactly where
there is a step `T` of the course as it was, the need met and no level marked before it, the need met
and the level marked at it, and a point of no return `N` of the course as it was (the turns to `H₂`
feasible, the need met at every step asked) with `T + 1 < N`. The need met at and before `T` follows
from that point `N` with `T + 1 < N`, with no premise (the course that recovers at `T + 1` agrees with the course as it was
up to there and meets the need); it is kept to match `turns_in_time_iff`. Proved through
`course_turned`, `turned_meets_iff` and `recoverable_iff_above`: the pair's own level course is the
course as it was turned at `T + 1`, and that turn meets the need exactly where the course as it was is
recoverable at `T + 1`. `recoverable_iff_above` at `T + 1` is used in both directions: its only-if
direction, where `short` enters, in this theorem's if direction, and its if direction, with
`noReturn_exists` and `NoReturnAt.recoverable_iff`, in this theorem's only-if direction.
`unending_iff_first_marked` is used only to find `T`. -/
theorem turns_in_time_iff_before {marked : Nat → Prop} [DecidablePred marked] {alone : W → W}
    {after : W → Nat → W} {Kept : W → Prop} {giving : Nat → Nat} {use : W → Nat}
    {H₁ y₁ H₂ y₂ hi need : Nat}
    (outside : AloneOutside marked alone after) (turns : ∀ w x, marked x → Kept (after w x))
    (kept : ∀ w x, Kept w → Kept (after w x)) (uses : ∀ w, Kept w → use w = H₂)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H₂ y₂)
    (meets : RegimeMargin.Meets giving H₂ y₂ hi) (keeps : RegimeMargin.Keeps giving H₂ hi)
    (needs : 0 < need) (within : need ≤ H₂ + y₂)
    (short₁ : RegimeMargin.Short giving H₁ y₁) {w : W} {x : Nat}
    (uses₁ : ∀ j, H₁ ≤ use (Law.orbit alone w j)) (below : x < H₁ + y₁) (high : x ≤ hi) :
    «不穷» (net need after (fun w x => RegimeMargin.step giving (use w) x)) «一» (w, x) ↔
      ∃ T, (∀ j, j < T →
          need ≤ (Law.orbit (asItWas alone
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2 ∧
          ¬ marked (Law.orbit (asItWas alone
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2) ∧
        need ≤ (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 ∧
        marked (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) T).2 ∧
        ∃ N, NoReturnAt
            (Turned (fun j => (Law.orbit (asItWas alone
              (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2) giving H₂)
            (MeetsNeed need)
            (fun t _ => (Law.orbit (asItWas alone
              (fun w x => RegimeMargin.step giving (use w) x)) (w, x) t).2) N ∧
          T + 1 < N :=
  have regime := asItWas_falls nothing short₁ uses₁ below
  have recAt := fun n => recoverable_iff_above (N := n)
    (X := fun j => (Law.orbit (asItWas alone
      (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2)
    regime.1 high nothing short meets keeps needs within
  ⟨fun never =>
    match (unending_iff_first_marked outside ⟨x, regime.2 need needs⟩).mp never with
    | ⟨T, before, atT, markedT, _⟩ =>
      have line := course_turned (giving := giving) outside turns kept uses
        (fun j lt => (before j lt).2) markedT
      have low := above_of_turned_meets (X := fun j => (Law.orbit (asItWas alone
            (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2)
          nothing short needs fun t =>
        Eq.subst (motive := fun z => need ≤ z) (line t) (Law.stepWhile_unending_iff.mp never t)
      match noReturn_exists nothing short meets keeps needs within short₁ uses₁ below high with
      | ⟨N, _, point⟩ =>
        ⟨T, before, atT, markedT, N, point, point.recoverable_iff.mp ((recAt (T + 1)).mpr low)⟩,
   fun ⟨T, before, _, markedT, _, point, lt⟩ =>
    have line := course_turned (giving := giving) outside turns kept uses
      (fun j lt => (before j lt).2) markedT
    have low := (recAt (T + 1)).mp (point.2 (T + 1) lt)
    Law.stepWhile_unending_iff.mpr fun t =>
      Eq.subst (motive := fun z => need ≤ z) (line t).symm
        (turned_meets_of_above (X := fun j => (Law.orbit (asItWas alone
          (fun w x => RegimeMargin.step giving (use w) x)) (w, x) j).2)
          regime.1 high meets keeps within low t)⟩

end PointOfNoReturn

/-! ## 8. Three courses from one start -/

namespace Three

/-- Giving that rises with the level to six at six and falls to nothing at twelve. -/
def giving (z : Nat) : Nat := min z (12 - z)

/-- Two kinds of way: as it was (`true`), which uses five, and the kept kind (`false`), which uses
three. -/
def use (w : Bool) : Nat := bif w then 5 else 3

/-- The level after a step: `RegimeMargin.step` under the way's use. -/
def left (w : Bool) (x : Nat) : Nat := RegimeMargin.step giving (use w) x

/-- At a level from `low` to `high` the way after a step is of the kept kind; elsewhere it is the
way. -/
def after (low high : Nat) (w : Bool) (x : Nat) : Bool := if low ≤ x ∧ x ≤ high then false else w

private theorem outside (low high : Nat) :
    AloneOutside (fun x => low ≤ x ∧ x ≤ high) id (after low high) :=
  fun _ _ h => if_neg h

private theorem turns (low high : Nat) :
    ∀ w x, (low ≤ x ∧ x ≤ high) → after low high w x = false :=
  fun _ _ h => if_pos h

private theorem kept (low high : Nat) :
    ∀ w x, w = false → after low high w x = false :=
  fun _ x k => if h : low ≤ x ∧ x ≤ high then if_pos h else (if_neg h).trans k

private theorem uses_kept : ∀ w, w = false → use w = 3 :=
  fun _ k => Eq.subst (motive := fun v => use v = 3) k.symm rfl

private theorem orbit_id : ∀ j, Law.orbit (id : Bool → Bool) true j = true
  | 0 => rfl
  | j + 1 => orbit_id j

private theorem uses_true : ∀ j, 5 ≤ use (Law.orbit id true j) :=
  fun j => Eq.subst (motive := fun v => 5 ≤ use v) (orbit_id j).symm (Nat.le_refl 5)

/-- **First marked at step 0 or at step 1, the line never ends.** From the level nine, with the mark
at nine the way turns at once and eight is left; with the mark at eight it turns one step later and
six is left, the kept kind's `H₂ + y₂`. -/
theorem goes_on : «不穷» (net 1 (after 9 9) left) «一» (true, 9) ∧
    «不穷» (net 1 (after 8 8) left) «一» (true, 9) :=
  have iff_at := fun low high =>
    turns_in_time_iff (marked := fun x => low ≤ x ∧ x ≤ high) (alone := id) (after := after low high)
      (Kept := fun w => w = false) (giving := giving) (use := use)
      (H₁ := 5) (y₁ := 5) (H₂ := 3) (y₂ := 3) (hi := 12) (need := 1) (w := true) (x := 9)
      (outside low high) (turns low high) (kept low high) uses_kept rfl
      (RegimeMargin.short_of_below rfl) (RegimeMargin.meets_of_below rfl)
      (RegimeMargin.keeps_of_below rfl) (by decide) (by decide) (RegimeMargin.short_of_below rfl)
      uses_true (by decide) (by decide)
  ⟨(iff_at 9 9).mpr ⟨0, by decide, by decide, by decide, by decide⟩,
   (iff_at 8 8).mpr ⟨1, by decide, by decide, by decide, by decide⟩⟩

/-- **First marked at step 2, it turns and ends.** With the mark at six, the course runs nine, eight,
six; there the way turns, two is left, below six, and after one more step nothing is left. At step 2,
the configuration `(true, 6)`, the line under the way's class ends while the net goes on
(`kind_ends_while_net_goes` at `κ := id`). -/
theorem turned_and_ends :
    Law.orbit (pair (after 6 6) left) (true, 9) 3 = (false, 2) ∧
    «迭» (net 1 (after 6 6) left) 4 (true, 9) (false, 0) ∧
    (∀ v, ¬ net 1 (after 6 6) left (false, 0) v) ∧
    ¬ «不穷» (net 1 (after 6 6) left) «一» (true, 9) ∧
    Law.orbit (pair (after 6 6) left) (true, 9) 2 = (true, 6) ∧
    «亡» (net 1 (after 6 6) left) (sameValue (fun s : Bool × Nat => s.1)) (true, 6) ∧
      ∃ v, net 1 (after 6 6) left (true, 6) v :=
  ⟨rfl, (Law.stepWhile_steps_iff 4).mpr ⟨by decide, rfl⟩,
   Law.stepWhile_none_iff.mpr (by decide),
   fun never => absurd (Law.stepWhile_unending_iff.mp never 4) (by decide),
   rfl,
   kind_ends_while_net_goes (κ := id) (need := 1) (after := after 6 6) (left := left) (w := true)
     (x := 6) (by decide) (by decide)⟩

/-- **With the mark at six, the line under the way's class ends while the net goes on, so the way's
class is not constant up to the net's end.** The step from `(true, 8)` to `(true, 6)` continues under
the way's class; `(true, 6)` ends under it and still conditions something
(`kind_ends_while_net_goes`); so by the root's `«亡而网续则不至终有常»` the class is not constant up to
the net's end, and by `kind_not_toEnd_of_turn`, with the unmarked level nine, not at `(true, 6)`'s
class. -/
theorem line_ends_while_net_goes :
    «续» (net 1 (after 6 6) left) (sameValue (fun s : Bool × Nat => s.1)) (true, 8) (true, 6) ∧
    ¬ «至终有常» (net 1 (after 6 6) left) (sameValue (fun s : Bool × Nat => s.1)) ∧
    ¬ «本类至终有常» (net 1 (after 6 6) left) (sameValue (fun s : Bool × Nat => s.1)) (true, 6) :=
  have continues : «续» (net 1 (after 6 6) left) (sameValue (fun s : Bool × Nat => s.1))
      (true, 8) (true, 6) := ⟨⟨by decide, rfl⟩, rfl⟩
  have ends := kind_ends_while_net_goes (κ := id) (need := 1) (after := after 6 6) (left := left)
    (w := true) (x := 6) (by decide) (by decide)
  ⟨continues, «亡而网续则不至终有常» continues ends.1 ends.2,
   kind_not_toEnd_of_turn (outside 6 6) (κ := id) (fun _ => rfl) (left := left) (w := true)
     (x := 6) (x₀ := 9) (by decide) (by decide) (by decide) (by decide)⟩

/-- **With no marked level, it ends as it was.** No level that meets the need is marked (marks from
ten down to nothing hold no level); the course runs nine, eight, six, two, nothing, and the line ends
there, its way as it was. -/
theorem ends_as_it_was :
    (∀ x, 1 ≤ x → ¬ (10 ≤ x ∧ x ≤ 0)) ∧
    «迭» (net 1 (after 10 0) left) 4 (true, 9) (true, 0) ∧
    (∀ v, ¬ net 1 (after 10 0) left (true, 0) v) ∧
    ¬ «不穷» (net 1 (after 10 0) left) «一» (true, 9) :=
  ⟨unmarked_interval_iff.mpr (.inl (by decide)), (Law.stepWhile_steps_iff 4).mpr ⟨by decide, rfl⟩,
   Law.stepWhile_none_iff.mpr (by decide),
   fun never => absurd (Law.stepWhile_unending_iff.mp never 4) (by decide)⟩

/-- **From nine as it was, the point of no return is step 3.** The course as it was runs nine, eight,
six, two, nothing; with the turns to the kept kind's use three as the feasible courses (`y = 3`, so
`H₂ + y₂ = 6`) and a need of one met at every step as what is asked, step 3 is the first at which it
is not recoverable (`noReturnAt_iff_first_below`). First marked at step 0 or 1, the pair's course is
the course as it was turned at step 1 or 2 (`course_turned`), before the point, and the line never
ends (`goes_on`); first marked at step 2 it is turned at step 3, the point itself, and the line ends
(`turned_and_ends`). -/
theorem noReturn :
    NoReturnAt (Turned (fun t => (Law.orbit (asItWas id left) (true, 9) t).2) giving 3)
      (MeetsNeed 1) (fun t _ => (Law.orbit (asItWas id left) (true, 9) t).2) 3 :=
  (noReturnAt_iff_first_below (X := fun t => (Law.orbit (asItWas id left) (true, 9) t).2)
    (giving := giving) (H := 3) (y := 3) (hi := 12) (need := 1) (N := 3)
    (asItWas_falls (giving := giving) (use := use) (H₁ := 5) (y₁ := 5) (w := true) (x := 9)
      rfl (RegimeMargin.short_of_below rfl) uses_true (by decide)).1
    (by decide) rfl (RegimeMargin.short_of_below rfl) (RegimeMargin.meets_of_below rfl)
    (RegimeMargin.keeps_of_below rfl) (by decide) (by decide)).mpr ⟨by decide, by decide⟩

end Three

end TurningInTime
end Becoming
