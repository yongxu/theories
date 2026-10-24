import Becoming.Grammar
import Becoming.Wholes

/-!
# PatternPassing: a pattern that outlasts each of its carriers lasts only through passing

`Becoming.Wholes` proves that parts covering the steps from `T` on, none active at two steps `d`
apart, have a part arising within every `d` consecutive steps (`Web.Covered.arises_within`), and
that the bound `d` is attained (`Shifts.shifts`). This module reads a web's activity as carrying a
pattern and asks what a pattern lasting longer than each of its carriers needs, with no premise
beyond the hypotheses each statement names.

A pattern carried in a web `W` by `carries : Nat → F → Prop` is read through the web whose
activity is carrying while active (`Web.carrying`); where every carrier is active, its activity is
exactly carrying (`Web.carrying_iff`). Every law below is stated for any web `V`, its activity read
as carrying, so it holds of `W.carrying carries` for every pattern carried in every web. The
pattern is *present* at a step where some formation carries it (`Web.Present`). `passes t b a`
reads "across the step from `t`, `b` gives the pattern to `a`"; some carrier *passes it across the
step* where a formation carrying it at `t` gives it to a formation carrying it at `t + 1`
(`Web.PassesAt`). The *passing premise* (`Web.ByPassing`): a formation carrying the pattern at
`t + 1` carried it at `t` or was given it across the step from `t` by a formation carrying it at
`t`. Like transmission in `Becoming.Evolution` (`Flow.TransmitsWithin`), which
`Becoming.Transmission` shows independent of the core's other premises wherever it binds, the
passing premise is a reading of how carrying forms, supplied and not derived.

* **A lasting pattern of brief carriers needs carriers that begin.** Present at every step from
  `T` on, its carriers brief for `d` (none carries at two steps `d` apart, `Web.Brief`), some
  carrier begins within every `d` consecutive steps (`Web.begins_within`, an instance of
  `Web.Covered.arises_within` on the formations of the web as its parts; `PatternRelay.shifts`
  attains the bound). As there, "within" is the irrefutable form: no stretch of `d` steps is
  without a beginning.
* **Under the passing premise every beginning is a passing** (`Web.ByPassing.begins_passed`), and
  tracing a carrier back over `k` steps, it carried at the start or some carrier passed the pattern
  across one of those steps (`Web.ByPassing.trace`).
* **Under the passing premise the pattern lasts only through passing.** Present at every step from
  `T` on, its carriers brief for `d`, some carrier passes it across one of every `d` consecutive
  steps from `T` on (`Web.ByPassing.passes_within`). This one is positive: the step and both
  carriers are given. A carrier passes it within every two steps but not within every one in
  `PatternRelay.shifted` (`PatternRelay.shifts`), so the bound `d` is attained.
* **One empty step ends it.** Under the passing premise presence at a step gives presence at every
  earlier step (`Web.ByPassing.present_back`, `Web.ByPassing.present_of_le`), so a step at which
  no formation carries the pattern is followed by none at which any does
  (`Web.ByPassing.empty_stays`).
* **If passing stops, it ends within one span.** Under the passing premise, its carriers brief for
  `d`, and no carrier passing it across any step from `T` on, no formation carries it at any step
  from `T + d` on (`Web.ByPassing.ends_within`).
* **Witnesses.** In `PatternRelay` each carrier carries for two steps and gives the pattern to
  the next carrier across every step: every premise holds, the pattern is present at every step,
  and every carrier's carrying ends (`PatternRelay.relay`). With passing stopped from step `T` on,
  the pattern is present at every step up to `T + 1` and at none from `T + 2` on
  (`PatternRelay.stopped_relay`), so the bound `T + d` of `Web.ByPassing.ends_within` is attained
  at `d = 2`.

Passing carries whatever pattern it carries: nothing here says which patterns are worth passing,
or what carrying one does to the carriers or to anything else. What is not derived: whether
carrying forms by passing (`Web.ByPassing` is a hypothesis), which formations pass, when, or to
which formations, and whether a pattern changes as it is passed.
-/

namespace Becoming

variable {F C : Type}

namespace Web

/-! ## A pattern carried in a web -/

/-- The web read through a pattern: a formation is active where it carries the pattern and is
active in `W`. -/
def carrying (W : Web F C) (carries : Nat → F → Prop) : Web F C where
  level := W.level
  active t a := carries t a ∧ W.active t a
  requires := W.requires
  need := W.need
  draws := W.draws

/-- **Carrying is activity.** A formation active in the web read through a pattern is active in
the web. -/
theorem carrying_active (W : Web F C) (carries : Nat → F → Prop) {t : Nat} {a : F}
    (active : (W.carrying carries).active t a) : W.active t a :=
  active.2

/-- **Where every carrier is active, the web read through a pattern is active exactly where the
pattern is carried.** -/
theorem carrying_iff (W : Web F C) {carries : Nat → F → Prop}
    (carried : ∀ t a, carries t a → W.active t a) (t : Nat) (a : F) :
    (W.carrying carries).active t a ↔ carries t a :=
  ⟨And.left, fun carrying => ⟨carrying, carried t a carrying⟩⟩

variable (V : Web F C)

/-- The pattern is present at step `t`: some formation carries it. -/
def Present (t : Nat) : Prop :=
  ∃ a, V.active t a

/-- Some carrier passes the pattern across the step from `t`: a formation carrying it at `t`
gives it to a formation carrying it at `t + 1`. -/
def PassesAt (passes : Nat → F → F → Prop) (t : Nat) : Prop :=
  ∃ b a, V.active t b ∧ passes t b a ∧ V.active (t + 1) a

/-- The passing premise: a formation carrying the pattern at `t + 1` carried it at `t`, or was
given it across the step from `t` by a formation carrying it at `t`. -/
def ByPassing (passes : Nat → F → F → Prop) : Prop :=
  ∀ t a, V.active (t + 1) a → V.active t a ∨ ∃ b, V.active t b ∧ passes t b a

variable {V} {passes : Nat → F → F → Prop}

/-! ## A lasting pattern of brief carriers -/

/-- **A lasting pattern of brief carriers needs carriers that begin.** A pattern present at every
step from `T` on, no carrier carrying it at two steps `d` apart, has no `d` consecutive steps from
`T` on across which no carrier begins. An instance of `Web.Covered.arises_within`, every formation
of the web a part. -/
theorem begins_within {d T : Nat} (present : ∀ t, T ≤ t → V.Present t)
    (brief : ∀ a, V.Brief d a) {S : Nat} (after : T ≤ S) :
    ¬ ∀ j, j < d → ∀ a, ¬ V.Arises (S + j) a :=
  fun quiet => Covered.arises_within (parts := fun _ => True)
    (fun t later => match present t later with
      | ⟨a, active⟩ => ⟨a, trivial, active⟩)
    (fun a _ => brief a) after fun j below a _ => quiet j below a

/-! ## Under the passing premise -/

/-- **Under the passing premise every beginning is a passing.** A formation that begins to carry
the pattern across a step was given it there by a formation carrying it. -/
theorem ByPassing.begins_passed (by_passing : V.ByPassing passes) {t : Nat} {a : F}
    (begins : V.Arises t a) : ∃ b, V.active t b ∧ passes t b a :=
  match by_passing t a begins.2 with
  | .inl before => absurd before begins.1
  | .inr given => given

/-- **Tracing a carrier back.** Under the passing premise, a formation carrying the pattern `k`
steps after `S` carried it at `S`, or some carrier passed it across one of the `k` steps from
`S`. -/
theorem ByPassing.trace (by_passing : V.ByPassing passes) {S : Nat} :
    ∀ {k : Nat} {a : F}, V.active (S + k) a →
      V.active S a ∨ ∃ j, j < k ∧ V.PassesAt passes (S + j)
  | 0, _, active => .inl active
  | k + 1, a, active => match by_passing (S + k) a active with
    | .inl before => match trace by_passing before with
      | .inl start => .inl start
      | .inr ⟨j, below, passing⟩ => .inr ⟨j, Nat.lt_succ_of_lt below, passing⟩
    | .inr ⟨b, carrier, given⟩ => .inr ⟨k, Nat.lt_succ_self k, b, a, carrier, given, active⟩

/-- **Under the passing premise, the pattern lasts only through passing.** A pattern present at
every step from `T` on, no carrier carrying it at two steps `d` apart, is passed by some carrier
across one of every `d` consecutive steps from `T` on. -/
theorem ByPassing.passes_within (by_passing : V.ByPassing passes) {d T : Nat}
    (present : ∀ t, T ≤ t → V.Present t) (brief : ∀ a, V.Brief d a) {S : Nat}
    (after : T ≤ S) : ∃ j, j < d ∧ V.PassesAt passes (S + j) :=
  match present (S + d) (Nat.le_trans after (Nat.le_add_right S d)) with
  | ⟨a, active⟩ => match by_passing.trace active with
    | .inl start => absurd active (brief a S start)
    | .inr found => found

/-- **Presence goes back one step.** Under the passing premise, a pattern present at `t + 1` was
present at `t`. -/
theorem ByPassing.present_back (by_passing : V.ByPassing passes) {t : Nat}
    (present : V.Present (t + 1)) : V.Present t :=
  match present with
  | ⟨a, active⟩ => match by_passing t a active with
    | .inl before => ⟨a, before⟩
    | .inr ⟨b, carrier, _⟩ => ⟨b, carrier⟩

/-- Presence goes back any number of steps. -/
theorem ByPassing.present_earlier (by_passing : V.ByPassing passes) {t : Nat} :
    ∀ {k : Nat}, V.Present (t + k) → V.Present t
  | 0, present => present
  | _ + 1, present => present_earlier by_passing (by_passing.present_back present)

/-- **Under the passing premise, presence at a step gives presence at every earlier step.** -/
theorem ByPassing.present_of_le (by_passing : V.ByPassing passes) {t t' : Nat} (le : t ≤ t')
    (present : V.Present t') : V.Present t :=
  match le_dest le with
  | ⟨_, same⟩ =>
    by_passing.present_earlier (Eq.subst (motive := fun s => V.Present s) same present)

/-- **One empty step ends the pattern.** Under the passing premise, a step at which no formation
carries the pattern is followed by no step at which any does. -/
theorem ByPassing.empty_stays (by_passing : V.ByPassing passes) {t : Nat}
    (empty : ¬ V.Present t) {t' : Nat} (later : t ≤ t') : ¬ V.Present t' :=
  fun present => empty (by_passing.present_of_le later present)

/-- **If passing stops, the pattern ends within one span.** Under the passing premise, no carrier
carrying it at two steps `d` apart, and no carrier passing it across any step from `T` on, no
formation carries it at any step from `T + d` on. -/
theorem ByPassing.ends_within (by_passing : V.ByPassing passes) {d T : Nat}
    (brief : ∀ a, V.Brief d a) (stopped : ∀ t, T ≤ t → ¬ V.PassesAt passes t) {t : Nat}
    (later : T + d ≤ t) : ¬ V.Present t :=
  fun ⟨a, active⟩ => match le_dest later with
  | ⟨m, same⟩ =>
    have carried : V.active (T + m + d) a :=
      Eq.subst (motive := fun s => V.active s a) (same.trans (Nat.add_right_comm T d m)) active
    match by_passing.trace carried with
    | .inl start => brief a (T + m) start carried
    | .inr ⟨j, _, passing⟩ =>
      stopped (T + m + j) (Nat.le_trans (Nat.le_add_right T m) (Nat.le_add_right (T + m) j))
        passing

end Web

/-! ## Witnesses -/

namespace PatternRelay

/-- The `n`th carrier carries the pattern at steps `n` and `n + 1`. -/
def web : Web Nat Unit where
  level _ _ := 0
  active t n := t = n ∨ t = n + 1
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- Across the step from `t`, the carrier `t` gives the pattern to the carrier `t + 1`. -/
def passes (t b a : Nat) : Prop :=
  b = t ∧ a = t + 1

/-- Every carrier carries for two steps, as a member of `Generations` is active. -/
theorem brief (n : Nat) : web.Brief 2 n :=
  Generations.brief (.member n) trivial

/-- **A relay of carriers each carrying for two steps, each giving the pattern to the next.** The
passing premise holds, no carrier carries at two steps two apart, every carrier's carrying ends,
the pattern is present at every step, and some carrier passes it across every step. -/
theorem relay : web.ByPassing passes ∧ (∀ n, web.Brief 2 n) ∧ (∀ n, web.Ends n) ∧
    (∀ t, web.Present t) ∧ ∀ t, web.PassesAt passes t :=
  ⟨fun t _ active => match active with
    | .inl begins => .inr ⟨t, .inl rfl, rfl, begins.symm⟩
    | .inr goes_on => .inl (.inl (Nat.succ.inj goes_on)),
   brief,
   fun n => Generations.ends (.member n) trivial,
   fun t => ⟨t, .inl rfl⟩,
   fun t => ⟨t, t + 1, .inl rfl, ⟨rfl, rfl⟩, .inl rfl⟩⟩

/-- The relay stopped at step `T`: the carriers up to `T`, each carrying at steps `n` and
`n + 1`. -/
def stopped (T : Nat) : Web Nat Unit where
  level _ _ := 0
  active t n := n ≤ T ∧ (t = n ∨ t = n + 1)
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- Across each step before `T`, the carrier `t` gives the pattern to the carrier `t + 1`;
nothing is given from step `T` on. -/
def passesUntil (T t b a : Nat) : Prop :=
  t < T ∧ b = t ∧ a = t + 1

/-- The stopped relay meets the passing premise. -/
theorem stopped_by_passing (T : Nat) : (stopped T).ByPassing (passesUntil T) :=
  fun t _ ⟨within, active⟩ => match active with
  | .inl begins =>
    have before : t < T := Eq.subst (motive := (· ≤ T)) begins.symm within
    .inr ⟨t, ⟨Nat.le_of_lt before, .inl rfl⟩, before, rfl, begins.symm⟩
  | .inr goes_on => .inl ⟨within, .inl (Nat.succ.inj goes_on)⟩

/-- Every carrier of the stopped relay carries for two steps. -/
theorem stopped_brief (T n : Nat) : (stopped T).Brief 2 n :=
  fun t now later => brief n t now.2 later.2

/-- No carrier of the stopped relay passes the pattern across any step from `T` on. -/
theorem stopped_quiet (T : Nat) : ∀ t, T ≤ t → ¬ (stopped T).PassesAt (passesUntil T) t :=
  fun _ after ⟨_, _, _, ⟨before, _⟩, _⟩ => Nat.lt_irrefl T (Nat.lt_of_le_of_lt after before)

/-- **With passing stopped from step `T` on, the pattern ends exactly one span later.** The relay
stopped at `T` meets every premise of `Web.ByPassing.ends_within` with `d = 2`; the pattern is
present at every step up to `T + 1` and at none from `T + 2` on. So the bound `T + d` is
attained. -/
theorem stopped_relay (T : Nat) : (stopped T).ByPassing (passesUntil T) ∧
    (∀ n, (stopped T).Brief 2 n) ∧
    (∀ t, T ≤ t → ¬ (stopped T).PassesAt (passesUntil T) t) ∧
    (∀ t, t ≤ T + 1 → (stopped T).Present t) ∧
    ∀ t, T + 2 ≤ t → ¬ (stopped T).Present t :=
  ⟨stopped_by_passing T, stopped_brief T, stopped_quiet T,
   fun _ within => (stopped_by_passing T).present_of_le within ⟨T, Nat.le_refl T, .inr rfl⟩,
   fun _ later => (stopped_by_passing T).ends_within (stopped_brief T) (stopped_quiet T) later⟩

/-- Half of the step after an odd one is one more than half of it. -/
theorem half_odd : ∀ t, odd t = true → Pulse.half (t + 1) = Pulse.half t + 1
  | 0, odd' => (nomatch odd')
  | 1, _ => rfl
  | t + 2, odd' => congrArg (· + 1) (half_odd t ((Shifts.odd_two t).symm.trans odd'))

/-- Carriers in shifts: the `n`th carries the pattern at steps `2n` and `2n + 1`. -/
def shifted : Web Nat Unit where
  level _ _ := 0
  active t n := Pulse.half t = n
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- Across each odd step, the carrier of that shift gives the pattern to the next. -/
def passesOdd (t b a : Nat) : Prop :=
  odd t = true ∧ b = Pulse.half t ∧ a = b + 1

/-- **The bounds of `Web.begins_within` and `Web.ByPassing.passes_within` are attained.**
Carriers in shifts of two steps, each giving the pattern to the next across an odd step: the
passing premise holds, no carrier carries at two steps two apart, the pattern is present at every
step, no carrier passes it across an even step, and no carrier begins across an even step. So a
carrier begins, and the pattern is passed, across one of every two consecutive steps, not of every
one. -/
theorem shifts : shifted.ByPassing passesOdd ∧ (∀ n, shifted.Brief 2 n) ∧
    (∀ t, shifted.Present t) ∧ (∀ t, odd t = false → ¬ shifted.PassesAt passesOdd t) ∧
    ∀ t, odd t = false → ∀ n, ¬ shifted.Arises t n :=
  ⟨fun t _ active => match parity : odd t with
    | true => .inr ⟨Pulse.half t, rfl, parity, rfl, active.symm.trans (half_odd t parity)⟩
    | false => .inl ((Shifts.half_even t parity).symm.trans active),
   fun _ t now later => Nat.succ_ne_self (Pulse.half t) (later.trans now.symm),
   fun t => ⟨Pulse.half t, rfl⟩,
   ⟨fun _ even ⟨_, _, _, ⟨odd', _⟩, _⟩ => (nomatch even.symm.trans odd'),
   fun t even _ arises => arises.1 ((Shifts.half_even t even).symm.trans arises.2)⟩⟩

end PatternRelay


/-! ## The grammar's reading: lasting through passing as continuation relative to a class (火传)

`Becoming.Grammar` states continuation (续) for every carrier and every relation. Here the carrier
is the occurrences of carrying, pairs `(t, a)` of a step and a formation, and 缘 is one step of
the continuation this module's passing premise reads (`Web.passingContinuation`): across the step
from `t`, `a` continues `b` where `a` is `b` carrying on or `b` gives the pattern to `a`. Its
occurrence relation is `Web.continuationStep` of `Becoming.Identity`. Two classes are used, both
read off the web: the pattern's class is activity (`Web.activityClass V`: alike in carrying the
pattern or not), and the carrier class is finer (`Web.carrierClass V`: alike in carrying and one
formation). Nothing else is supplied.

* **The passing premise is that nothing begins under the pattern's class after the first step**:
  every carrying occurrence after it has a predecessor (有前) under the pattern's class
  (`Web.byPassing_iff_hasPred`), which is Identity's `Continues` under the passing continuation
  (`Web.byPassing_iff_continues`).
* **A carrier begins (生) and ends (亡) under the carrier class** exactly where it arises and
  ceases (`Web.arises_iff_sheng_carrier`, `Web.ceases_iff_wang_carrier`). An alteration (异) of a
  carrying occurrence, continuation under the pattern's class told apart by the carrier class, is
  a passing (`Web.passesAt_of_alters`); a passing to another formation is an alteration
  (`Web.alters_of_passes`).
* **火传.** 《庄子·养生主》「指窮於爲薪，火傳也」: a carrier that ceases while it passes the pattern
  on ends under the carrier class and does not end under the pattern's class: it alters
  (`Web.passing_fire`). This is the shape of the grammar's `«亡于细者不必亡于粗»`, and
  `PatternRelay.shifted` realizes it at every odd step (`PatternRelay.shifted_fire`,
  `PatternRelay.fire_shape`). In `PatternRelay.web` each carrier passes the pattern at its first
  step, so its last occurrence ends under both classes: there the passing is not a handing over at
  the end.
* **The pattern's line.** Under the passing premise every carrying occurrence lies on a line
  (相续) under the pattern's class from a carrying occurrence at every earlier step
  (`Web.ByPassing.line_back`).
* **Derived from grammar laws.** `Web.ByPassing.passes_within` (the pattern lasts only through
  passing) follows from a relational law stated here for every carrier and relation
  (`marked_step_of_apart`: a line whose ends a class tells apart, every step of which keeps the
  class or carries a mark, has a marked step on it) applied to the carrier class
  (`Web.ByPassing.passes_within_by_line`). `Web.ByPassing.begins_passed` follows from
  `alters_of_begins` (a beginning under a finer class, continued under a coarser one, is an
  alteration) (`Web.ByPassing.begins_passed_by_grammar`). An occurrence with no continuation under
  the pattern's class ends under the carrier class, by `«亡于粗则亡于细»`: its carrier ceases
  (`Web.ceases_of_pattern_ends`).

Not connected: `Web.begins_within` is an instance of `Web.Covered.arises_within` and reads no
continuation; `Web.ByPassing.ends_within`, `present_back` and `empty_stays` are read about
presence at a step, which is not a grammar term (a step is not an occurrence). `PassesAt` counts a
formation passing the pattern to itself, which is no alteration; so an alteration gives a passing,
not conversely.
-/

/-- **A line whose ends a class tells apart has a marked step.** Where every step of continuation
under `E` either keeps the class `K` or carries the mark `P`, a line (相续) under `E` from `x` to
`y` with `K` telling `x` and `y` apart has a step carrying the mark, given with its place on the
line: reached from `x`, and reaching `y`. Stated for every carrier and every relation; only
transitivity of `K` is used. -/
theorem marked_step_of_apart {α : Type _} {R E K P : «际» α} (hK : «类» K)
    (split : ∀ x y, «续» R E x y → K x y ∨ P x y) {x y : α} (line : «相续» R E x y) :
    ¬ K x y → ∃ u v, «续» R E u v ∧ P u v ∧ (x = u ∨ «相续» R E x u) ∧ (v = y ∨ «相续» R E v y) := by
  induction line with
  | one c =>
    intro apart
    match split _ _ c with
    | .inl k => exact absurd k apart
    | .inr p => exact ⟨_, _, c, p, .inl rfl, .inl rfl⟩
  | more c rest ih =>
    intro apart
    match split _ _ c with
    | .inl k =>
      match ih (fun k' => apart (hK.trans k k')) with
      | ⟨u, v, cuv, p, .inl same, after⟩ =>
        exact ⟨u, v, cuv, p, .inr (Eq.subst (motive := fun w => «相续» R E _ w) same (.one c)), after⟩
      | ⟨u, v, cuv, p, .inr reached, after⟩ =>
        exact ⟨u, v, cuv, p, .inr (.more c reached), after⟩
    | .inr p => exact ⟨_, _, c, p, .inl rfl, .inr rest⟩

/-- A line (相续) under a class stays within the class: its ends are alike. -/
theorem line_within_class {α : Type _} {R E : «际» α} (hE : «类» E) {x y : α}
    (line : «相续» R E x y) : E x y := by
  induction line with
  | one c => exact c.2
  | more c _ ih => exact hE.trans c.2 ih

/-- **A beginning under a finer class, continued under a coarser one, is an alteration (异).** -/
theorem alters_of_begins {α : Type _} {R E F : «际» α} {x y : α} (begins : «生» R F y)
    (continues : «续» R E x y) : «异» R E F x y :=
  ⟨continues, fun same => begins ⟨x, continues.1, same⟩⟩

namespace Web

/-- The continuation the passing premise reads: across the step from `t`, `a` continues `b` where
`a` is `b` carrying on, or `b` gives the pattern to `a`. -/
def passingContinuation (passes : Nat → F → F → Prop) (t : Nat) (b a : F) : Prop :=
  b = a ∨ passes t b a

/-- Two occurrences of one formation. -/
def sameFormation : «际» (Nat × F) := fun x y => x.2 = y.2

/-- The carrier class: alike in carrying the pattern, and of one formation. Finer than the
pattern's class `activityClass`. -/
def carrierClass (V : Web F C) : «际» (Nat × F) := «合» V.activityClass sameFormation

theorem carrierClass_class (V : Web F C) : «类» V.carrierClass :=
  ⟨fun _ => ⟨Iff.rfl, rfl⟩, fun same => ⟨same.1.symm, same.2.symm⟩,
   fun same same' => ⟨same.1.trans same'.1, same.2.trans same'.2⟩⟩

/-- The carrier class is finer than the pattern's class. -/
theorem carrierClass_finer (V : Web F C) : «则» V.carrierClass V.activityClass :=
  fun _ _ same => same.1

variable {V : Web F C} {passes : Nat → F → F → Prop}

/-- **The passing premise is a continuation.** It says exactly that every formation carrying the
pattern after a step continues, under the passing continuation, a formation carrying it before
the step. -/
theorem byPassing_iff_continues :
    V.ByPassing passes ↔ ∀ t a, V.active (t + 1) a → V.Continues (passingContinuation passes) t a :=
  ⟨fun byPassing t a after => match byPassing t a after with
    | .inl before => ⟨a, before, .inl rfl⟩
    | .inr ⟨b, carrier, given⟩ => ⟨b, carrier, .inr given⟩,
   fun continues t a after => match continues t a after with
    | ⟨_, carrier, .inl same⟩ => .inl (Eq.subst (motive := fun f => V.active t f) same carrier)
    | ⟨b, carrier, .inr given⟩ => .inr ⟨b, carrier, given⟩⟩

/-- **The passing premise: nothing begins under the pattern's class after the first step.** Every
occurrence carrying the pattern after a step has a predecessor (有前) under the pattern's class. -/
theorem byPassing_iff_hasPred :
    V.ByPassing passes ↔ ∀ t a, V.active (t + 1) a →
      «有前» (continuationStep (passingContinuation passes)) V.activityClass (t + 1, a) :=
  byPassing_iff_continues.trans
    ⟨fun continues t a after => (hasPred_iff_continues after).mpr (continues t a after),
     fun pred t a after => (hasPred_iff_continues after).mp (pred t a after)⟩

/-- **A carrier begins (生) under the carrier class exactly where it arises.** -/
theorem arises_iff_sheng_carrier {t : Nat} {a : F} :
    V.Arises t a ↔ V.active (t + 1) a ∧
      «生» (continuationStep (passingContinuation passes)) V.carrierClass (t + 1, a) :=
  ⟨fun ⟨before, after⟩ => ⟨after, fun ⟨x, ⟨next, _⟩, ⟨alike, same⟩⟩ =>
     before (Eq.subst (motive := fun s => V.active s a) (Nat.succ.inj next).symm
       (Eq.subst (motive := fun f => V.active x.1 f) same (alike.mpr after)))⟩,
   fun ⟨after, begins⟩ => ⟨fun before =>
     begins ⟨(t, a), ⟨rfl, .inl rfl⟩, ⟨⟨fun _ => after, fun _ => before⟩, rfl⟩⟩, after⟩⟩

/-- **A carrier ends (亡) under the carrier class exactly where it ceases.** -/
theorem ceases_iff_wang_carrier {t : Nat} {b : F} :
    V.Ceases t b ↔ V.active t b ∧
      «亡» (continuationStep (passingContinuation passes)) V.carrierClass (t, b) :=
  ⟨fun ⟨before, gone⟩ => ⟨before, fun ⟨y, ⟨next, _⟩, ⟨alike, same⟩⟩ =>
     gone (Eq.subst (motive := fun s => V.active s b) next
       (Eq.subst (motive := fun f => V.active y.1 f) same.symm (alike.mp before)))⟩,
   fun ⟨before, ends⟩ => ⟨before, fun after =>
     ends ⟨(t + 1, b), ⟨rfl, .inl rfl⟩, ⟨⟨fun _ => after, fun _ => before⟩, rfl⟩⟩⟩⟩

/-- **An alteration (异) of a carrying occurrence is a passing.** Continuation under the pattern's
class that the carrier class tells apart, from a formation carrying the pattern, is some carrier
passing it across the step. One way only: `PassesAt` also counts a formation passing the pattern
to itself, which alters nothing. -/
theorem passesAt_of_alters {x y : Nat × F} (carrying : V.active x.1 x.2)
    (alters : «异» (continuationStep (passingContinuation passes)) V.activityClass V.carrierClass
      x y) : V.PassesAt passes x.1 :=
  match alters with
  | ⟨⟨⟨next, kind⟩, alike⟩, apart⟩ => match kind with
    | .inl same => absurd ⟨alike, same⟩ apart
    | .inr given => ⟨x.2, y.2, carrying, given,
        Eq.subst (motive := fun s => V.active s y.2) next (alike.mp carrying)⟩

/-- **A passing to another formation is an alteration (异).** -/
theorem alters_of_passes {t : Nat} {b a : F} (carrier : V.active t b) (given : passes t b a)
    (carried : V.active (t + 1) a) (other : ¬ b = a) :
    «异» (continuationStep (passingContinuation passes)) V.activityClass V.carrierClass
      (t, b) (t + 1, a) :=
  ⟨⟨⟨rfl, .inr given⟩, ⟨fun _ => carried, fun _ => carrier⟩⟩, fun same => other same.2⟩

/-- **火传 (《庄子·养生主》「指窮於爲薪，火傳也」).** A carrier that ceases across a step while it
passes the pattern to a formation carrying it after the step ends (亡) under the carrier class and
does not end under the pattern's class: the step is an alteration (异). The firewood is used up;
the fire is passed on. -/
theorem passing_fire {t : Nat} {b a : F} (ceases : V.Ceases t b) (given : passes t b a)
    (carried : V.active (t + 1) a) :
    «亡» (continuationStep (passingContinuation passes)) V.carrierClass (t, b) ∧
    ¬ «亡» (continuationStep (passingContinuation passes)) V.activityClass (t, b) ∧
    «异» (continuationStep (passingContinuation passes)) V.activityClass V.carrierClass
      (t, b) (t + 1, a) :=
  have alters := alters_of_passes ceases.1 given carried fun same =>
    ceases.2 (Eq.subst (motive := fun f => V.active (t + 1) f) same.symm carried)
  ⟨(ceases_iff_wang_carrier.mp ceases).2, fun ends => ends ⟨_, alters.1⟩, alters⟩

/-- **Derived from `«亡于粗则亡于细»`.** An occurrence carrying the pattern that nothing continues
under the pattern's class (it neither carries on nor passes the pattern to any carrier) ends under
the carrier class: its carrier ceases. -/
theorem ceases_of_pattern_ends {t : Nat} {b : F} (carrying : V.active t b)
    (ends : «亡» (continuationStep (passingContinuation passes)) V.activityClass (t, b)) :
    V.Ceases t b :=
  ceases_iff_wang_carrier.mpr ⟨carrying, «亡于粗则亡于细» _ (carrierClass_finer V) ends⟩

/-- **The pattern's line (相续).** Under the passing premise, an occurrence carrying the pattern
`k + 1` steps after `S` lies on a line under the pattern's class from an occurrence carrying it at
`S`. -/
theorem ByPassing.line_back (byPassing : V.ByPassing passes) {S : Nat} :
    ∀ {k : Nat} {a : F}, V.active (S + (k + 1)) a →
      ∃ b, V.active S b ∧
        «相续» (continuationStep (passingContinuation passes)) V.activityClass (S, b)
          (S + (k + 1), a)
  | 0, a, after => match byPassing S a after with
    | .inl before => ⟨a, before, .one ⟨⟨rfl, .inl rfl⟩, ⟨fun _ => after, fun _ => before⟩⟩⟩
    | .inr ⟨b, carrier, given⟩ =>
      ⟨b, carrier, .one ⟨⟨rfl, .inr given⟩, ⟨fun _ => after, fun _ => carrier⟩⟩⟩
  | k + 1, a, after => match byPassing (S + (k + 1)) a after with
    | .inl before => match line_back byPassing before with
      | ⟨b, start, line⟩ => ⟨b, start, «及之传递» line
          (.one ⟨⟨rfl, .inl rfl⟩, ⟨fun _ => after, fun _ => before⟩⟩)⟩
    | .inr ⟨_, carrier, given⟩ => match line_back byPassing carrier with
      | ⟨b, start, line⟩ => ⟨b, start, «及之传递» line
          (.one ⟨⟨rfl, .inr given⟩, ⟨fun _ => after, fun _ => carrier⟩⟩)⟩

/-- **The pattern lasts only through passing, derived from the grammar.** The statement of
`Web.ByPassing.passes_within`, proved through `ByPassing.line_back` and `marked_step_of_apart`:
the pattern's line from step `S` to step `S + d` has ends the carrier class tells apart (no
carrier carries at two steps `d` apart), and every step of continuation keeps the carrier class or
is a passing, so a passing lies on it, between `S` and `S + d`. -/
theorem ByPassing.passes_within_by_line (byPassing : V.ByPassing passes) {d T : Nat}
    (present : ∀ t, T ≤ t → V.Present t) (brief : ∀ a, V.Brief d a) {S : Nat}
    (after : T ≤ S) : ∃ j, j < d ∧ V.PassesAt passes (S + j) :=
  match d, present, brief with
  | 0, present, brief => match present S after with
    | ⟨a, carrying⟩ => absurd carrying (brief a S carrying)
  | k + 1, present, brief =>
    match present (S + (k + 1)) (Nat.le_trans after (Nat.le_add_right S (k + 1))) with
    | ⟨a, carried⟩ => match byPassing.line_back carried with
      | ⟨b, start, line⟩ =>
        have apart : ¬ V.carrierClass (S, b) (S + (k + 1), a) := fun ⟨_, same⟩ =>
          brief a S (Eq.subst (motive := fun f => V.active S f) same start) carried
        have split : ∀ x y, «续» (continuationStep (passingContinuation passes)) V.activityClass
            x y → V.carrierClass x y ∨ passes x.1 x.2 y.2 := fun _ _ ⟨⟨_, kind⟩, alike⟩ =>
          match kind with
          | .inl same => .inl ⟨alike, same⟩
          | .inr given => .inr given
        match marked_step_of_apart (carrierClass_class V) split line apart with
        | ⟨u, v, ⟨⟨next, _⟩, alike⟩, given, from_, to⟩ =>
          have reached : V.activityClass (S, b) u := match from_ with
            | .inl same => Eq.subst (motive := fun w => V.activityClass (S, b) w) same Iff.rfl
            | .inr line' => line_within_class (activityClass_class V) line'
          have carrying : V.active u.1 u.2 := reached.mp start
          have later : S ≤ u.1 := match from_ with
            | .inl same => Nat.le_of_eq (congrArg Prod.fst same)
            | .inr line' => Nat.le_of_lt (line_advances line')
          have before : v.1 ≤ S + (k + 1) := match to with
            | .inl same => Nat.le_of_eq (congrArg Prod.fst same)
            | .inr line' => Nat.le_of_lt (line_advances line')
          match le_dest later with
          | ⟨j, at_⟩ =>
            ⟨j, Naturals.le_of_add_le_add_left (k := S)
                (Eq.subst (motive := fun s => s + 1 ≤ S + (k + 1)) at_
                  (Eq.subst (motive := fun s => s ≤ S + (k + 1)) next before)),
             Eq.subst (motive := fun s => V.PassesAt passes s) at_
               ⟨u.2, v.2, carrying, given,
                Eq.subst (motive := fun s => V.active s v.2) next (alike.mp carrying)⟩⟩

/-- **Every beginning is a passing, derived from the grammar.** The statement of
`Web.ByPassing.begins_passed`, proved through `alters_of_begins`: a carrier's beginning is a
beginning (生) under the carrier class, the passing premise gives it a predecessor under the
pattern's class, so the step is an alteration (异), which is a passing. -/
theorem ByPassing.begins_passed_by_grammar (byPassing : V.ByPassing passes) {t : Nat} {a : F}
    (begins : V.Arises t a) : ∃ b, V.active t b ∧ passes t b a :=
  match byPassing_iff_hasPred.mp byPassing t a begins.2 with
  | ⟨x, continues⟩ =>
    match alters_of_begins (arises_iff_sheng_carrier (passes := passes).mp begins).2 continues with
    | ⟨⟨⟨next, kind⟩, alike⟩, apart⟩ =>
      have same : x.1 = t := (Nat.succ.inj next).symm
      have carrier : V.active t x.2 :=
        Eq.subst (motive := fun s => V.active s x.2) same (alike.mpr begins.2)
      match kind with
      | .inl same' => absurd ⟨alike, same'⟩ apart
      | .inr given => ⟨x.2, carrier, Eq.subst (motive := fun s => passes s x.2 a) same given⟩

end Web

namespace PatternRelay

/-- **火传 in the shifts.** Across every odd step the carrier of the shift ceases and passes the
pattern to the next: its occurrence ends (亡) under the carrier class and alters (异) under the
pattern's class. -/
theorem shifted_fire (t : Nat) (parity : odd t = true) :
    «亡» (Web.continuationStep (Web.passingContinuation passesOdd)) shifted.carrierClass
      (t, Pulse.half t) ∧
    ¬ «亡» (Web.continuationStep (Web.passingContinuation passesOdd)) shifted.activityClass
      (t, Pulse.half t) ∧
    «异» (Web.continuationStep (Web.passingContinuation passesOdd)) shifted.activityClass
      shifted.carrierClass (t, Pulse.half t) (t + 1, Pulse.half t + 1) :=
  Web.passing_fire
    ⟨rfl, fun after => Nat.succ_ne_self (Pulse.half t) ((half_odd t parity).symm.trans after)⟩
    ⟨parity, rfl, rfl⟩ (half_odd t parity)

/-- **The grammar's `«亡于细者不必亡于粗»`, in the module's own witness.** The carrier class is
finer than the pattern's class, and the occurrence of the first carrier at its last step ends
under the carrier class and not under the pattern's. -/
theorem fire_shape :
    «则» shifted.carrierClass shifted.activityClass ∧
    «亡» (Web.continuationStep (Web.passingContinuation passesOdd)) shifted.carrierClass (1, 0) ∧
    ¬ «亡» (Web.continuationStep (Web.passingContinuation passesOdd)) shifted.activityClass
      (1, 0) :=
  ⟨Web.carrierClass_finer shifted, (shifted_fire 1 rfl).1, (shifted_fire 1 rfl).2.1⟩

end PatternRelay

end Becoming
