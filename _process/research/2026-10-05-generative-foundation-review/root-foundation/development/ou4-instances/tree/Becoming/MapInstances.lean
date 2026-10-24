import Becoming.GrammarMap
import Becoming.ContinuedClasses
import Becoming.PatternPassing
import Becoming.Continuation

/-!
# The map's instances: the old base's regimes as regions (地图之例)

`Becoming.GrammarMap` reads generation (`«生成»`), keeping (`«守»`) and degeneration (`«退化»`) at
a fine class `E` and a coarse class `L`. This module reads the old base in it, with one reading
throughout, already used by `Becoming.Identity`, `Becoming.ContinuedClasses` and
`Becoming.PatternPassing`:

* the carrier is the occurrences `(t, f)` of formations, and 缘 is one step of a continuation `R`
  (`Web.continuationStep R`);
* the coarse class, the pattern, is activity (`Web.activityClass W`): a coarse line from an active
  occurrence is a lineage under `R` (`Web.lineage_iff_line`);
* the fine class, the parts, is activity together with one formation (`Web.carrierClass W`): an
  occurrence begins under it where its formation was not active before the step and carrying on as
  itself.

Results.

* **What a carrying renewal is.** From an active occurrence, a carrying renewal (`«传»`) is a step
  of `R` into an active occurrence whose formation did not carry on as itself across the step
  (`Web.carries_iff`). Under the passing continuation of `Becoming.PatternPassing` it is exactly
  a passing to a carrier that arises (`Web.passing_carries_iff`): 火传 at the map's grain.
* **Generation needs arising without end.** A generating line has carrying renewals beyond every
  step (`Web.generation_renews_late`); under the passing continuation, carriers arise at
  arbitrarily late steps (`Web.generation_arises_late`, the base's `Web.Unceasing`).
* **Keeping.** An endless line along which, from some step on, every active formation carried on as
  itself keeps (`Web.keeping_of_carried_on`). Read by names alone (`Web.itself`, the continuation
  along which `Becoming.ContinuedClasses` reads the name classes `RenewingIn` and `ConsumingIn`),
  nothing carries a renewal (`Web.itself_carries_nothing`), so nothing generates
  (`Web.itself_not_generation`), every endless line keeps (`Web.itself_keeps`), and a formation
  active at every step keeps (`Web.always_keeps`). The name classes therefore never read as
  generation: generation needs a continuation other than names.
* **Degeneration.** A line from an active occurrence along which nothing reached at some step is
  active does not go on (`Web.not_endless_of_gone`), so it lies outside generation and keeping
  (`Map.outside_of_not_endless`); where going on is decided at the points of the line, it
  degenerates (`Web.degenerates_of_gone`). This is where the map's boundary
  (`«生败之定当且仅当排中»`) enters the instances: the regimes below refute going on
  constructively, and reaching an end is the further step that decided going on supplies. Three
  regimes of the base fall there:
  - consumption of a condition whose dependence the line still holds at a later step at no lower
    need, where activity needs support (`Web.consumed_held_not_endless`);
  - a whole drawing beyond renewal: a family of conditions whose gated renewal ran into excess, as
    in `Flow.family_excess_ends`, ending every line that depends on the family at the step the
    excess reaches (`Web.family_excess_not_endless`);
  - passing that stops, with brief carriers, as in `Web.ByPassing.ends_within`
    (`Web.stopped_not_endless`).
* **Witnesses on the base.** The carriers in shifts of `PatternRelay.shifted` generate at every
  occurrence (`Map.shifted_generates`). The relay of `PatternRelay.web`, in which a carrier passes
  the pattern at its first step and carries on one more, renews and still ends at every carrier's
  first occurrence (`Map.relay_renews_and_ends`): the line branches, and the carrier's last
  occurrence ends it. Both have no conditions, so every carrier renews along the passing
  continuation vacuously; renewal of relations does not decide the region
  (`Map.renewal_undecided`).

Not connected: renewal along a continuation (`Web.RenewingAlong`) reads conditions, not whether a
line goes on, and does not imply any region (`Map.renewal_undecided`); consumption along a
continuation (`Web.ConsumingAlong`) ends a line only where the line holds the dependence consumed
(`Web.consumed_held_not_endless`), since a drawer need not depend on what it draws. The coarse
line's going on (`«不穷»`) asks every branch to go on, so a branch's end is the line's
degeneration.

Modelling choices: discrete steps, formations a fixed index type, activity Prop-valued, natural
number levels and needs. Every declaration has an empty axiom report.
-/

namespace Becoming

universe u

namespace Map

variable {α : Type u}

/-- A line that does not go on lies outside generation and keeping. -/
theorem outside_of_not_endless {R L E : «际» α} {x : α} (h : ¬ «不穷» R L x) :
    ¬ «生成» R L E x ∧ ¬ «守» R L E x :=
  ⟨fun g => h g.1, fun k => h k.1⟩

end Map

variable {F C : Type}

namespace Web

variable {W : Web F C} {R : Nat → F → F → Prop}

/-! ## Walking a line of occurrences -/

/-- What a line reaches lies at the same step or later. -/
theorem reached_later {E : «际» (Nat × F)} {x y : Nat × F}
    (reached : «所及» (continuationStep R) E x y) : x.1 ≤ y.1 :=
  match reached with
  | .inl same => Nat.le_of_eq (congrArg Prod.fst same)
  | .inr line => Nat.le_of_lt (line_advances line)

/-- What the pattern's line reaches from an active occurrence is active. -/
theorem active_along {x y : Nat × F} (start : W.active x.1 x.2)
    (reached : «所及» (continuationStep R) W.activityClass x y) : W.active y.1 y.2 :=
  match reached with
  | .inl same => Eq.subst (motive := fun z : Nat × F => W.active z.1 z.2) same start
  | .inr line => («线内同类» (activityClass_class W) line).mp start

/-- A line that never ends reaches an occurrence at every later step. -/
theorem reaches_onward {E : «际» (Nat × F)} {x : Nat × F}
    (endless : «不穷» (continuationStep R) E x) :
    ∀ k, ∃ y, «所及» (continuationStep R) E x y ∧ y.1 = x.1 + k
  | 0 => ⟨x, .inl rfl, rfl⟩
  | k + 1 => match reaches_onward endless k with
    | ⟨y, hy, at_⟩ => match endless y hy with
      | ⟨z, c⟩ => ⟨z, «所及之传递» hy (.inr (.one c)), c.1.1.trans (congrArg (· + 1) at_)⟩

/-- Where going on is decided at the points of a line, the line reaches an end or an occurrence at
every later step. -/
theorem ends_or_reaches {E : «际» (Nat × F)} {x : Nat × F}
    (decided : ∀ y, «所及» (continuationStep R) E x y →
      «有后» (continuationStep R) E y ∨ ¬ «有后» (continuationStep R) E y) :
    ∀ k, «退化» (continuationStep R) E x ∨
      ∃ y, «所及» (continuationStep R) E x y ∧ y.1 = x.1 + k
  | 0 => .inr ⟨x, .inl rfl, rfl⟩
  | k + 1 => match ends_or_reaches decided k with
    | .inl d => .inl d
    | .inr ⟨y, hy, at_⟩ => match decided y hy with
      | .inl ⟨z, c⟩ =>
        .inr ⟨z, «所及之传递» hy (.inr (.one c)), c.1.1.trans (congrArg (· + 1) at_)⟩
      | .inr ends => .inl ⟨y, hy, ends⟩

/-! ## Carrying renewal on the base -/

/-- **A carrying renewal on the base.** From an active occurrence, a carrying renewal under the
pattern (activity) and the parts (activity and one formation) is a step of the continuation into
an active occurrence whose formation did not carry on as itself across the step. -/
theorem carries_iff {x y : Nat × F} (start : W.active x.1 x.2) :
    «传» (continuationStep R) W.activityClass W.carrierClass x y ↔
      continuationStep R x y ∧ W.active y.1 y.2 ∧ ¬ (W.active x.1 y.2 ∧ R x.1 y.2 y.2) :=
  ⟨fun ⟨⟨step, alike⟩, begins⟩ => ⟨step, alike.mp start, fun ⟨before, self⟩ =>
     begins ⟨(x.1, y.2), ⟨step.1, self⟩, ⟨⟨fun _ => alike.mp start, fun _ => before⟩, rfl⟩⟩⟩,
   fun ⟨step, after, fresh⟩ => ⟨⟨step, ⟨fun _ => after, fun _ => start⟩⟩,
     fun ⟨(s, _), ⟨next, self⟩, ⟨alike, same⟩⟩ =>
       have at_ : s = x.1 := Nat.succ.inj (next.symm.trans step.1)
       fresh ⟨Eq.subst (motive := fun s' => W.active s' y.2) at_
               (Eq.subst (motive := fun f => W.active s f) same (alike.mpr after)),
              Eq.subst (motive := fun s' => R s' y.2 y.2) at_
               (Eq.subst (motive := fun f => R s f y.2) same self)⟩⟩⟩

/-- **火传 at the map's grain.** Under the passing continuation, a carrying renewal from a carrier
is exactly a passing to a carrier that arises across the step. -/
theorem passing_carries_iff {V : Web F C} {passes : Nat → F → F → Prop} {t : Nat} {b a : F}
    (carrier : V.active t b) :
    «传» (continuationStep (passingContinuation passes)) V.activityClass V.carrierClass
        (t, b) (t + 1, a) ↔ passes t b a ∧ V.Arises t a :=
  ⟨fun c => match (carries_iff (x := (t, b)) (y := (t + 1, a)) carrier).mp c with
    | ⟨⟨_, kind⟩, after, fresh⟩ =>
      have before : ¬ V.active t a := fun before => fresh ⟨before, .inl rfl⟩
      match kind with
      | .inl same => absurd (Eq.subst (motive := fun f => V.active t f) same carrier) before
      | .inr given => ⟨given, before, after⟩,
   fun ⟨given, before, after⟩ =>
     (carries_iff (x := (t, b)) (y := (t + 1, a)) carrier).mpr
       ⟨⟨rfl, .inr given⟩, after, fun ⟨now, _⟩ => before now⟩⟩

/-! ## Generation needs renewal without end -/

/-- **A generating line renews beyond every step**: for every step `N` its line reaches, at `N` or
later, an occurrence from which a carrying renewal goes. -/
theorem generation_renews_late {x : Nat × F}
    (h : «生成» (continuationStep R) W.activityClass W.carrierClass x) (N : Nat) :
    ∃ z w, «所及» (continuationStep R) W.activityClass x z ∧ N ≤ z.1 ∧
      «传» (continuationStep R) W.activityClass W.carrierClass z w :=
  match reaches_onward h.1 N with
  | ⟨y, hy, at_⟩ => match h.2 y hy with
    | ⟨z, w, hz, c⟩ => ⟨z, w, «所及之传递» hy hz,
        Nat.le_trans (Eq.subst (motive := fun s => N ≤ s) at_.symm (Nat.le_add_left N x.1))
          (reached_later hz), c⟩

/-- **Generation of a pattern is unceasing arising.** Under the passing continuation, a generating
line from a carrier has carriers arising at arbitrarily late steps. -/
theorem generation_arises_late {V : Web F C} {passes : Nat → F → F → Prop} {x : Nat × F}
    (start : V.active x.1 x.2)
    (h : «生成» (continuationStep (passingContinuation passes)) V.activityClass V.carrierClass x) :
    V.Unceasing :=
  fun N => match generation_renews_late h N with
  | ⟨(s, b), (_, a), hz, later, c⟩ =>
    match (carries_iff (active_along (x := x) (y := (s, b)) start hz)).mp c with
    | ⟨⟨next, _⟩, after, fresh⟩ =>
      ⟨s, a, later, fun before => fresh ⟨before, .inl rfl⟩,
       Eq.subst (motive := fun s' => V.active s' a) next after⟩

/-! ## Keeping -/

/-- **Keeping on the base.** An endless line from an active occurrence along which, from step `S`
on, every active formation was active before the step and carried on as itself keeps: no carrying
renewal lies ahead of its occurrence at step `x.1 + S`. -/
theorem keeping_of_carried_on {x : Nat × F} {S : Nat} (start : W.active x.1 x.2)
    (endless : «不穷» (continuationStep R) W.activityClass x)
    (on : ∀ s f, S ≤ s → W.active (s + 1) f → W.active s f ∧ R s f f) :
    «守» (continuationStep R) W.activityClass W.carrierClass x :=
  match reaches_onward endless S with
  | ⟨y, hy, at_⟩ => ⟨endless, y, hy, fun z w hz c =>
      match (carries_iff (active_along start («所及之传递» hy hz))).mp c with
      | ⟨⟨next, _⟩, after, fresh⟩ =>
        fresh (on z.1 w.2
          (Nat.le_trans (Eq.subst (motive := fun s => S ≤ s) at_.symm (Nat.le_add_left S x.1))
            (reached_later hz))
          (Eq.subst (motive := fun s => W.active s w.2) next after))⟩

/-- **By names alone nothing carries a renewal.** Along the continuation in which each formation
continues only itself, no step begins a part. -/
theorem itself_carries_nothing (z w : Nat × F) :
    ¬ «传» (continuationStep itself) W.activityClass W.carrierClass z w :=
  fun ⟨⟨step, alike⟩, begins⟩ => begins ⟨z, step, ⟨alike, step.2⟩⟩

/-- **By names alone nothing generates.** -/
theorem itself_not_generation (x : Nat × F) :
    ¬ «生成» (continuationStep itself) W.activityClass W.carrierClass x :=
  fun ⟨_, ahead⟩ => match ahead x (.inl rfl) with
    | ⟨z, w, _, c⟩ => itself_carries_nothing z w c

/-- **By names alone an endless line keeps.** -/
theorem itself_keeps {x : Nat × F}
    (endless : «不穷» (continuationStep itself) W.activityClass x) :
    «守» (continuationStep itself) W.activityClass W.carrierClass x :=
  ⟨endless, x, .inl rfl, fun z w _ c => itself_carries_nothing z w c⟩

/-- **A formation active at every step from `t` keeps**, read by its name. -/
theorem always_keeps {t : Nat} {f : F} (always : ∀ s, t ≤ s → W.active s f) :
    «守» (continuationStep itself) W.activityClass W.carrierClass (t, f) :=
  itself_keeps fun ⟨s, g⟩ hy =>
    have same : g = f := Continuing.itself_same (continuing_iff_line.mpr (match hy with
      | .inl e => .inl e
      | .inr line => .inr ⟨always t (Nat.le_refl t), line⟩))
    have later : t ≤ s := reached_later hy
    ⟨(s + 1, g), ⟨rfl, rfl⟩,
     ⟨fun _ => Eq.subst (motive := fun h => W.active (s + 1) h) same.symm
        (always (s + 1) (Nat.le_succ_of_le later)),
      fun _ => Eq.subst (motive := fun h => W.active s h) same.symm (always s later)⟩⟩

/-! ## Degeneration -/

/-- **A line along which nothing reached at a step is active does not go on.** -/
theorem not_endless_of_gone {x : Nat × F} {N : Nat} (start : W.active x.1 x.2) (le : x.1 ≤ N)
    (gone : ∀ y, «所及» (continuationStep R) W.activityClass x y → y.1 = N →
      ¬ W.active y.1 y.2) :
    ¬ «不穷» (continuationStep R) W.activityClass x :=
  fun endless => match le_dest le with
  | ⟨k, at_⟩ => match reaches_onward endless k with
    | ⟨y, hy, at'⟩ => gone y hy (at'.trans at_.symm) (active_along start hy)

/-- **Where going on is decided, such a line degenerates**: it reaches an end. -/
theorem degenerates_of_gone {x : Nat × F} {N : Nat} (start : W.active x.1 x.2) (le : x.1 ≤ N)
    (gone : ∀ y, «所及» (continuationStep R) W.activityClass x y → y.1 = N →
      ¬ W.active y.1 y.2)
    (decided : ∀ y, «所及» (continuationStep R) W.activityClass x y →
      «有后» (continuationStep R) W.activityClass y ∨
        ¬ «有后» (continuationStep R) W.activityClass y) :
    «退化» (continuationStep R) W.activityClass x :=
  match le_dest le with
  | ⟨k, at_⟩ => match ends_or_reaches decided k with
    | .inl d => d
    | .inr ⟨y, hy, at'⟩ => absurd (active_along start hy) (gone y hy (at'.trans at_.symm))

/-- **Consumption of what the line depends on ends it.** Where activity needs support, the level
of `c` stays below the need of `g`'s dependence on it at `T` from `T` on (with that dependence held
at `T`, this is `W.Consumed c`), and at a later step `N` every occurrence the line reaches holds a
dependence on `c` at no lower need, the line does not go on. -/
theorem consumed_held_not_endless (dependent : W.Dependent) {c : C} {g : F} {T N : Nat}
    (below : ∀ s, T < s → W.level s c < W.need T g c) (after : T < N)
    {x : Nat × F} (start : W.active x.1 x.2) (le : x.1 ≤ N)
    (held : ∀ y, «所及» (continuationStep R) W.activityClass x y → y.1 = N →
      W.requires N y.2 c ∧ W.need T g c ≤ W.need N y.2 c) :
    ¬ «不穷» (continuationStep R) W.activityClass x :=
  not_endless_of_gone start le fun y hy at_ active =>
    match held y hy at_ with
    | ⟨depends, high⟩ =>
      have now : W.active N y.2 := Eq.subst (motive := fun s => W.active s y.2) at_ active
      Nat.not_le_of_gt (below N after) (Nat.le_trans high (dependent N y.2 now c depends))

/-- **A whole drawing beyond renewal ends the lines that depend on it.** Under the premises of
`Flow.family_excess_ends` (balance, only active formations giving, activity needing support, the
family's renewal gated on it, `n` steps of excess from a stock below `n + m`), a line from an
active occurrence every occurrence of which at step `T + n` depends on a member of the family at a
need of at least `m` does not go on. -/
theorem family_excess_not_endless {L : Flow F C} (balances : L.Balances W)
    (acting : L.Acting W) (dependent : W.Dependent) {ds : List C} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (stock : W.stock ds T < n + m) {x : Nat × F} (start : W.active x.1 x.2) (le : x.1 ≤ T + n)
    (held : ∀ y, «所及» (continuationStep R) W.activityClass x y → y.1 = T + n →
      ∃ e, e ∈ ds ∧ W.requires (T + n) y.2 e ∧ m ≤ W.need (T + n) y.2 e) :
    ¬ «不穷» (continuationStep R) W.activityClass x :=
  not_endless_of_gone start le fun y hy at_ => match held y hy at_ with
    | ⟨e, inside, depends, high⟩ =>
      Eq.subst (motive := fun s => ¬ W.active s y.2) at_.symm
        (Becoming.Flow.family_excess_ends balances acting dependent gated excess stock 0 y.2 e
          inside depends high)

/-- **Passing that stops ends the pattern's line.** Under the passing premise, with carriers brief
for `d` and no passing from step `T` on, a line from a carrier at a step up to `T + d` does not go
on. -/
theorem stopped_not_endless {V : Web F C} {passes : Nat → F → F → Prop}
    (byPassing : V.ByPassing passes) {d T : Nat} (brief : ∀ a, V.Brief d a)
    (stopped : ∀ t, T ≤ t → ¬ V.PassesAt passes t) {x : Nat × F} (start : V.active x.1 x.2)
    (le : x.1 ≤ T + d) :
    ¬ «不穷» (continuationStep (passingContinuation passes)) V.activityClass x :=
  not_endless_of_gone start le fun y _ at_ active =>
    byPassing.ends_within brief stopped (Nat.le_of_eq at_.symm) ⟨y.2, active⟩

end Web

/-! ## Witnesses on the base -/

namespace Map

open PatternRelay

/-- In the shifts, an even step carries the carrier on. -/
theorem shifted_carry (s n : Nat) (active : Pulse.half s = n) (even : odd s = false) :
    «续» (Web.continuationStep (Web.passingContinuation passesOdd)) shifted.activityClass
      (s, n) (s + 1, n) :=
  ⟨⟨rfl, .inl rfl⟩, ⟨fun _ => (Shifts.half_even s even).trans active, fun _ => active⟩⟩

/-- In the shifts, an odd step is a carrying renewal: the carrier passes the pattern to the next,
which arises. -/
theorem shifted_pass (s n : Nat) (active : Pulse.half s = n) (odd' : odd s = true) :
    «传» (Web.continuationStep (Web.passingContinuation passesOdd)) shifted.activityClass
      shifted.carrierClass (s, n) (s + 1, n + 1) :=
  (Web.passing_carries_iff (V := shifted) active).mpr
    ⟨⟨odd', active.symm, rfl⟩, fun e => Nat.succ_ne_self n (e.symm.trans active),
     (half_odd s odd').trans (congrArg (· + 1) active)⟩

/-- **Generation on the base.** The carriers in shifts generate at every occurrence: the pattern's
line never ends, and a carrier arises by passing within every two steps of it. -/
theorem shifted_generates (t : Nat) :
    «生成» (Web.continuationStep (Web.passingContinuation passesOdd)) shifted.activityClass
      shifted.carrierClass (t, Pulse.half t) :=
  have onward : ∀ y, «所及» (Web.continuationStep (Web.passingContinuation passesOdd))
      shifted.activityClass (t, Pulse.half t) y → Pulse.half y.1 = y.2 :=
    fun _ hy => Web.active_along (W := shifted) (x := (t, Pulse.half t)) rfl hy
  ⟨fun ⟨s, n⟩ hy => match parity : odd s with
     | true => ⟨_, (shifted_pass s n (onward _ hy) parity).1⟩
     | false => ⟨_, shifted_carry s n (onward _ hy) parity⟩,
   fun ⟨s, n⟩ hy => match parity : odd s with
     | true => ⟨(s, n), (s + 1, n + 1), .inl rfl, shifted_pass s n (onward _ hy) parity⟩
     | false =>
       have c := shifted_carry s n (onward _ hy) parity
       ⟨(s + 1, n), (s + 2, n + 1), .inr (.one c),
        shifted_pass (s + 1) n (c.2.mp (onward _ hy)) (congrArg (!·) parity)⟩⟩

/-- A carrier of the relay is not active at the step after its two. -/
theorem relay_after_two (t : Nat) : ¬ (t = t + 1 ∨ t = t + 1 + 1) :=
  fun now => match now with
  | .inl e => Nat.succ_ne_self t e.symm
  | .inr e => Nat.lt_irrefl t
      (Eq.subst (motive := fun s => t < s) e.symm (Nat.lt_succ_of_lt (Nat.lt_succ_self t)))

/-- **Renewing and still ending on the base.** In the relay, from each carrier's first occurrence
the pattern is passed to a carrier that arises, and the line reaches the carrier's last occurrence,
which nothing continues. -/
theorem relay_renews_and_ends (t : Nat) :
    «新而终» (Web.continuationStep (Web.passingContinuation passes)) web.activityClass
      web.carrierClass (t, t) :=
  have carry : «续» (Web.continuationStep (Web.passingContinuation passes)) web.activityClass
      (t, t) (t + 1, t) := ⟨⟨rfl, .inl rfl⟩, ⟨fun _ => .inr rfl, fun _ => .inl rfl⟩⟩
  have ends : «亡» (Web.continuationStep (Web.passingContinuation passes)) web.activityClass
      (t + 1, t) := fun ⟨⟨_, n⟩, ⟨next, kind⟩, alike⟩ =>
    have after : t + 1 + 1 = n ∨ t + 1 + 1 = n + 1 :=
      Eq.subst (motive := fun s' => s' = n ∨ s' = n + 1) next (alike.mp (.inr rfl))
    match kind with
    | .inl same => relay_after_two t (match after with
      | .inl e => .inr (e.trans same.symm).symm
      | .inr e => .inl ((Nat.succ.inj e).trans same.symm).symm)
    | .inr ⟨wrong, _⟩ => Nat.succ_ne_self t wrong.symm
  ⟨⟨(t + 1, t), .inr (.one carry), ends⟩, (t, t), (t + 1, t + 1), .inl rfl,
   (Web.passing_carries_iff (V := web) (t := t) (b := t) (a := t + 1) (.inl rfl)).mpr
     ⟨⟨rfl, rfl⟩, relay_after_two t, .inl rfl⟩⟩

/-- **Renewal of relations does not decide the region.** In the relay and in the shifts every
carrier renews along the passing continuation (neither has conditions); the relay renews and still
ends, the shifts generate. -/
theorem renewal_undecided (t : Nat) :
    web.RenewingAlong (Web.passingContinuation passes) t t ∧
      «新而终» (Web.continuationStep (Web.passingContinuation passes)) web.activityClass
        web.carrierClass (t, t) ∧
    shifted.RenewingAlong (Web.passingContinuation passesOdd) t (Pulse.half t) ∧
      «生成» (Web.continuationStep (Web.passingContinuation passesOdd)) shifted.activityClass
        shifted.carrierClass (t, Pulse.half t) :=
  ⟨fun _ _ _ _ joins => match joins with
     | .inl r => False.elim r
     | .inr d => False.elim d,
   relay_renews_and_ends t,
   fun _ _ _ _ joins => match joins with
     | .inl r => False.elim r
     | .inr d => False.elim d,
   shifted_generates t⟩

end Map

end Becoming
