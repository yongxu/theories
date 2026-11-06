import Becoming.GrammarMap
import Becoming.ContinuedClasses
import Becoming.PatternPassing
import Becoming.Continuation

/-!
# The map's instances: the old base's regimes as regions (地图之例)

`Becoming.GrammarMap` reads generation and keeping in the strong form (`«全生成»`, `«全守»`),
reaching an end (`«有终»`) and degeneration (`«退化»`, ending on every branch) at a fine class `E`
and a coarse class `L`. This module reads the old base in it, with one reading
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
  (`Web.itself_not_generation`), both cases of the laws for any continuation in which each
  formation continues only itself (`Web.not_carries_of_within_itself`,
  `Web.not_generation_of_within_itself`); every endless line keeps (`Web.itself_keeps`), and a formation
  active at every step keeps (`Web.always_keeps`). The name classes therefore never read as
  generation: generation needs a continuation other than names.
* **Degeneration, constructively.** Along any class, where everything the line from `x` reaches at
  a step `N` not before `x` ends on every branch, `x` ends on every branch (`Web.ends_of_ends_at`,
  by induction on the steps left: a continuation lies one step later). No excluded middle enters,
  and no premise that the line does not branch. So, at every class `E` within activity
  (`«则» E W.activityClass`), a line from an active occurrence, nothing it reaches being active at
  one step `N` not before the start, ends on every branch: the pattern read at `E` degenerates
  (`Web.every_branch_ends_of_gone`). What the line under `E` reaches lies on the line under
  activity (`Web.reached_coarser`), so it is active (`Web.active_along_finer`), and nothing is
  reached at `N`. What carries the law is the uniform horizon, which it states through activity.
  Its instance at activity itself is `Web.activity_every_branch_ends_of_gone`; the kind grain's is
  in `Becoming.KeepingWidening`.
* **Not going on, and reaching an end.** Read coarser, the same line does not go on
  (`Web.not_endless_of_gone`, by `«尽则非不穷»`), so it lies outside generation and keeping
  (`Map.outside_of_not_endless`); where going on is decided at the points of the line, it reaches
  an end (有终, `Web.end_of_gone`, by `«尽而续可定则有终»`). With no decision, that every line meeting
  the law's premise reaches an end is exactly excluded middle (`Map.end_of_gone_iff_excluded_middle`):
  in `Map.Undecided`, a web with one occurrence active at step `0`, one at step `1` and none from
  step `2`, continued exactly where a proposition `P` holds, the premise holds and the pattern
  degenerates (`Map.Undecided.degenerates`) while an end decides `P` (`Map.Undecided.end_decides`;
  the start is continued exactly where `P` holds, `Map.Undecided.first_has_next_iff`). Nothing
  infinite is undecided there, only whether one step is taken. This is where the map's boundary
  (`«不穷有终之定当且仅当排中»`) enters the instances: on the base, constructively, degeneration is
  the region a known horizon gives, and reaching an end is the further step that decided going on
  supplies. Three regimes of the base fall there, each making an occurrence at its step inactive,
  stated once, pointwise, and degenerating the line through that step:
  - consumption of a condition whose dependence the line still holds at a later step at no lower
    need, where activity needs support (`Web.consumed_held_gone`, `Web.consumed_held_degenerates`,
    so `Web.consumed_held_not_endless`);
  - a whole drawing beyond renewal: a family of conditions whose renewal, whatever gives it, ran
    into excess, ending every line that depends on the family at the step the excess reaches
    (`Web.family_excess_gone`, `Web.family_excess_degenerates`, so `Web.family_excess_not_endless`);
    a gate on the renewal, with only active formations giving, makes the formations' end last
    (`Flow.family_excess_ends`), which these do not use;
  - passing that stops, with brief carriers, as in `Web.ByPassing.ends_within`
    (`Web.stopped_gone`, `Web.stopped_degenerates`, so `Web.stopped_not_endless`).
* **Witnesses on the base.** The carriers in shifts of `PatternRelay.shifted` generate at every
  occurrence (`Map.shifted_generates`). The relay of `PatternRelay.web`, in which a carrier passes
  the pattern at its first step and carries on one more, renews and still ends at every carrier's
  first occurrence (`Map.relay_renews_and_ends`): the line branches, and the carrier's last
  occurrence ends it. Both have no conditions, so every carrier renews along the passing
  continuation vacuously; renewal of relations does not decide the region
  (`Map.renewal_undecided`). The hypotheses of each regime's degeneration law hold together from
  an active start, and the line takes a step before it degenerates: consumption, in a web of one
  formation depending at need one on a condition whose level falls to zero after step `1`
  (`Map.Depleted.degenerates`, `Map.Depleted.continues`); a whole drawing, in `Coupled` of
  `Becoming.Continuation`, the taker and the renewer of a patch read as one family
  (`Map.coupled_degenerates`, `Map.coupled_continues`); passing that stops, in the stopped relay of
  `Becoming.PatternPassing`, at every stopping step (`Map.stopped_relay_degenerates`,
  `Map.stopped_relay_continues`). In the first two the dependence premise is shown at every
  occurrence, reached or not; the stopped relay has none. In all three the web's activity is given,
  not derived from the regime: the premise sets can hold together on an active start, which does
  not show that a regime is what ends the line.

Not connected: renewal along a continuation (`Web.RenewingAlong`) reads conditions, not whether a
line goes on, and does not imply any region (`Map.renewal_undecided`); consumption along a
continuation (`Web.ConsumingAlong`) ends a line only where the line holds the dependence consumed
(`Web.consumed_held_not_endless`), since a drawer need not depend on what it draws. The coarse
line's going on (`«不穷»`) asks every branch to go on, so one branch's end is enough for the line
not to go on and, where decided, to reach an end (有终); degeneration (尽) asks every branch to
end.

Modelling choices: discrete steps (a continuation advances the step by one), formations a fixed
index type, activity Prop-valued, continuations Prop-valued relations, natural-number levels and
needs, natural-number amounts of a family's stock, uptake and replenishment (the second regime), and
in the degeneration laws a uniform horizon: one step `N` at which every branch is gone. Every
declaration has an empty axiom report.
-/

namespace Becoming

universe u

namespace Map

variable {α : Type u}

/-- A line that does not go on lies outside generation and keeping. -/
theorem outside_of_not_endless {R L E : «际» α} {x : α} (h : ¬ «不穷» R L x) :
    ¬ «全生成» R L E x ∧ ¬ «全守» R L E x :=
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
theorem active_along_line {x y : Nat × F} (start : W.active x.1 x.2)
    (reached : «所及» (continuationStep R) W.activityClass x y) : W.active y.1 y.2 :=
  match reached with
  | .inl same => Eq.subst (motive := fun z : Nat × F => W.active z.1 z.2) same start
  | .inr line => («线内同类» (activityClass_class W) line).mp start

/-- A line that never ends reaches an occurrence at every later step: the grammar's unending line has
steps of every length (`«不穷则迭»`), which lie within its reach (`«迭则同一或及»`, at the line's
continuation) and advance the index (`steps_advance`). -/
theorem reaches_onward {E : «际» (Nat × F)} {x : Nat × F}
    (endless : «不穷» (continuationStep R) E x) :
    ∀ k, ∃ y, «所及» (continuationStep R) E x y ∧ y.1 = x.1 + k :=
  fun k => match «不穷则迭» endless k with
  | ⟨y, steps⟩ => ⟨y, «迭则同一或及» k steps, steps_advance k steps⟩

/-- Where going on is decided at the points of a line, the line reaches an end or an occurrence at
every later step. -/
theorem ends_or_reaches {E : «际» (Nat × F)} {x : Nat × F}
    (decided : ∀ y, «所及» (continuationStep R) E x y →
      «有后» (continuationStep R) E y ∨ ¬ «有后» (continuationStep R) E y) :
    ∀ k, «有终» (continuationStep R) E x ∨
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
    (h : «全生成» (continuationStep R) W.activityClass W.carrierClass x) (N : Nat) :
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
    (h : «全生成» (continuationStep (passingContinuation passes)) V.activityClass V.carrierClass x) :
    V.Unceasing :=
  fun N => match generation_renews_late h N with
  | ⟨(s, b), (_, a), hz, later, c⟩ =>
    match (carries_iff (active_along_line (x := x) (y := (s, b)) start hz)).mp c with
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
    «全守» (continuationStep R) W.activityClass W.carrierClass x :=
  match reaches_onward endless S with
  | ⟨y, hy, at_⟩ => ⟨endless, y, hy, fun z w hz c =>
      match (carries_iff (active_along_line start («所及之传递» hy hz))).mp c with
      | ⟨⟨next, _⟩, after, fresh⟩ =>
        fresh (on z.1 w.2
          (Nat.le_trans (Eq.subst (motive := fun s => S ≤ s) at_.symm (Nat.le_add_left S x.1))
            (reached_later hz))
          (Eq.subst (motive := fun s => W.active s w.2) next after))⟩

/-- **Where each formation continues only itself, nothing carries a renewal**: along any
continuation contained in `itself`, no step begins a part. -/
theorem not_carries_of_within_itself (within : ∀ t g f, R t g f → itself t g f) (z w : Nat × F) :
    ¬ «传» (continuationStep R) W.activityClass W.carrierClass z w :=
  fun ⟨⟨step, alike⟩, begins⟩ => begins ⟨z, step, ⟨alike, within _ _ _ step.2⟩⟩

/-- **Where each formation continues only itself, nothing generates.** -/
theorem not_generation_of_within_itself (within : ∀ t g f, R t g f → itself t g f) (x : Nat × F) :
    ¬ «全生成» (continuationStep R) W.activityClass W.carrierClass x :=
  fun ⟨_, ahead⟩ => match ahead x (.inl rfl) with
    | ⟨z, w, _, c⟩ => not_carries_of_within_itself within z w c

/-- **By names alone nothing carries a renewal.** Along the continuation in which each formation
continues only itself, no step begins a part. -/
theorem itself_carries_nothing (z w : Nat × F) :
    ¬ «传» (continuationStep itself) W.activityClass W.carrierClass z w :=
  not_carries_of_within_itself (fun _ _ _ same => same) z w

/-- **By names alone nothing generates.** -/
theorem itself_not_generation (x : Nat × F) :
    ¬ «全生成» (continuationStep itself) W.activityClass W.carrierClass x :=
  not_generation_of_within_itself (fun _ _ _ same => same) x

/-- **By names alone an endless line keeps.** -/
theorem itself_keeps {x : Nat × F}
    (endless : «不穷» (continuationStep itself) W.activityClass x) :
    «全守» (continuationStep itself) W.activityClass W.carrierClass x :=
  ⟨endless, x, .inl rfl, fun z w _ c => itself_carries_nothing z w c⟩

/-- **A formation active at every step from `t` keeps**, read by its name. -/
theorem always_keeps {t : Nat} {f : F} (always : ∀ s, t ≤ s → W.active s f) :
    «全守» (continuationStep itself) W.activityClass W.carrierClass (t, f) :=
  itself_keeps fun ⟨s, g⟩ hy =>
    have same : g = f := Continuing.itself_same (continuing_iff_line.mpr (match hy with
      | .inl e => .inl e
      | .inr line => .inr ⟨always t (Nat.le_refl t), line⟩))
    have later : t ≤ s := reached_later hy
    ⟨(s + 1, g), ⟨rfl, rfl⟩,
     ⟨fun _ => Eq.subst (motive := fun h => W.active (s + 1) h) same.symm
        (always (s + 1) (Nat.le_succ_of_le later)),
      fun _ => Eq.subst (motive := fun h => W.active s h) same.symm (always s later)⟩⟩

/-! ## Ending on every branch, by the steps left -/

/-- Everything the line reaches `d` steps before `N` ends on every branch, where everything it
reaches at `N` does. -/
theorem ends_before {E : «际» (Nat × F)} {x : Nat × F} {N : Nat}
    (at_N : ∀ y, «所及» (continuationStep R) E x y → y.1 = N → «尽» (continuationStep R) E y) :
    ∀ d y, «所及» (continuationStep R) E x y → y.1 + d = N → «尽» (continuationStep R) E y
  | 0, y, hy, at_ => at_N y hy at_
  | d + 1, y, hy, at_ => .mk fun z c =>
    ends_before at_N d z («所及之传递» hy (.inr (.one c)))
      ((congrArg (· + d) c.1.1).trans ((Nat.succ_add y.1 d).trans at_))

/-- **Ending at a step ends the line before it.** Along any class, where everything the line from
`x` reaches at a step `N` not before `x` ends on every branch, `x` ends on every branch. -/
theorem ends_of_ends_at {E : «际» (Nat × F)} {x : Nat × F} {N : Nat} (le : x.1 ≤ N)
    (at_N : ∀ y, «所及» (continuationStep R) E x y → y.1 = N → «尽» (continuationStep R) E y) :
    «尽» (continuationStep R) E x :=
  match le_dest le with
  | ⟨k, at_⟩ => ends_before at_N k x (.inl rfl) at_.symm

/-! ## Degeneration: the constructive law -/

/-- What the line reaches under a finer class it reaches under a coarser one. -/
theorem reached_coarser {E E' : «际» (Nat × F)} (inside : «则» E E') {x y : Nat × F}
    (reached : «所及» (continuationStep R) E x y) : «所及» (continuationStep R) E' x y :=
  match reached with
  | .inl same => .inl same
  | .inr line => .inr («及之单调» («粗化» (continuationStep R) inside) x y line)

/-- What the line under a class finer than activity reaches from an active occurrence is active. -/
theorem active_along_finer {E : «际» (Nat × F)} (inside : «则» E W.activityClass) {x y : Nat × F}
    (start : W.active x.1 x.2) (reached : «所及» (continuationStep R) E x y) : W.active y.1 y.2 :=
  active_along_line start (reached_coarser inside reached)

/-- **A line from an active occurrence, nothing it reaches being active at one step `N` not before
the start, ends on every branch**, at every class finer than activity: no decision of going on and
no premise that the line does not branch. -/
theorem every_branch_ends_of_gone {E : «际» (Nat × F)} (inside : «则» E W.activityClass)
    {x : Nat × F} {N : Nat} (start : W.active x.1 x.2) (le : x.1 ≤ N)
    (gone : ∀ y, «所及» (continuationStep R) E x y → y.1 = N → ¬ W.active y.1 y.2) :
    «退化» (continuationStep R) E x :=
  ends_of_ends_at le fun y hy at_ => absurd (active_along_finer inside start hy) (gone y hy at_)

/-- **At the activity grain**, under exactly the premises of `Web.not_endless_of_gone`. -/
theorem activity_every_branch_ends_of_gone {x : Nat × F} {N : Nat} (start : W.active x.1 x.2)
    (le : x.1 ≤ N)
    (gone : ∀ y, «所及» (continuationStep R) W.activityClass x y → y.1 = N →
      ¬ W.active y.1 y.2) :
    «退化» (continuationStep R) W.activityClass x :=
  every_branch_ends_of_gone («则之自反» W.activityClass) start le gone

/-! ## Not going on, and reaching an end: degeneration read coarser -/

/-- **A line along which nothing reached at a step is active does not go on.** -/
theorem not_endless_of_gone {x : Nat × F} {N : Nat} (start : W.active x.1 x.2) (le : x.1 ≤ N)
    (gone : ∀ y, «所及» (continuationStep R) W.activityClass x y → y.1 = N →
      ¬ W.active y.1 y.2) :
    ¬ «不穷» (continuationStep R) W.activityClass x :=
  «尽则非不穷» (activity_every_branch_ends_of_gone start le gone)

/-- **Where going on is decided, such a line reaches an end** (有终): its degeneration
(`Web.activity_every_branch_ends_of_gone`) with the decision. -/
theorem end_of_gone {x : Nat × F} {N : Nat} (start : W.active x.1 x.2) (le : x.1 ≤ N)
    (gone : ∀ y, «所及» (continuationStep R) W.activityClass x y → y.1 = N →
      ¬ W.active y.1 y.2)
    (decided : ∀ y, «所及» (continuationStep R) W.activityClass x y →
      «有后» (continuationStep R) W.activityClass y ∨
        ¬ «有后» (continuationStep R) W.activityClass y) :
    «有终» (continuationStep R) W.activityClass x :=
  «尽而续可定则有终» (activity_every_branch_ends_of_gone start le gone) decided

/-! ## The three regimes degenerate, through one gone step each -/

/-- **Consumption makes an occurrence at the later step inactive** where it holds the dependence
at no lower need. -/
theorem consumed_held_gone (dependent : W.Dependent) {c : C} {g : F} {T N : Nat}
    (below : ∀ s, T < s → W.level s c < W.need T g c) (after : T < N) {y : Nat × F}
    (at_ : y.1 = N) (held : W.requires N y.2 c ∧ W.need T g c ≤ W.need N y.2 c) :
    ¬ W.active y.1 y.2 :=
  fun active =>
    have now : W.active N y.2 := Eq.subst (motive := fun s => W.active s y.2) at_ active
    Nat.not_le_of_gt (below N after) (Nat.le_trans held.2 (dependent N y.2 now c held.1))

/-- **Consumption of what the line depends on degenerates it**, under the hypotheses of
`Web.consumed_held_not_endless`. -/
theorem consumed_held_degenerates (dependent : W.Dependent) {c : C} {g : F} {T N : Nat}
    (below : ∀ s, T < s → W.level s c < W.need T g c) (after : T < N)
    {x : Nat × F} (start : W.active x.1 x.2) (le : x.1 ≤ N)
    (held : ∀ y, «所及» (continuationStep R) W.activityClass x y → y.1 = N →
      W.requires N y.2 c ∧ W.need T g c ≤ W.need N y.2 c) :
    «退化» (continuationStep R) W.activityClass x :=
  activity_every_branch_ends_of_gone start le fun y hy at_ =>
    consumed_held_gone dependent below after at_ (held y hy at_)

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
  «尽则非不穷» (consumed_held_degenerates dependent below after start le held)

/-- **A whole drawing beyond renewal makes an occurrence at the step the excess reaches inactive**
where it depends on a member of the family at a need of at least `m`: under balance and where
activity needs support, whatever renews the family. -/
theorem family_excess_gone {L : Flow F C} (balances : L.Balances W)
    (dependent : W.Dependent) {ds : List C} {m : Nat}
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (stock : W.stock ds T < n + m) {y : Nat × F} (at_ : y.1 = T + n)
    (held : ∃ e, e ∈ ds ∧ W.requires (T + n) y.2 e ∧ m ≤ W.need (T + n) y.2 e) :
    ¬ W.active y.1 y.2 :=
  match held with
  | ⟨_, inside, depends, high⟩ =>
    Eq.subst (motive := fun s => ¬ W.active s y.2) at_.symm
      (Becoming.Flow.family_ends_below_at (dependent (T + n) y.2)
        (Becoming.Flow.below_of_excess balances excess stock) inside depends high)

/-- **A whole drawing beyond renewal degenerates the lines that depend on it**, under the
hypotheses of `Web.family_excess_not_endless`. -/
theorem family_excess_degenerates {L : Flow F C} (balances : L.Balances W)
    (dependent : W.Dependent) {ds : List C} {m : Nat}
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (stock : W.stock ds T < n + m) {x : Nat × F} (start : W.active x.1 x.2) (le : x.1 ≤ T + n)
    (held : ∀ y, «所及» (continuationStep R) W.activityClass x y → y.1 = T + n →
      ∃ e, e ∈ ds ∧ W.requires (T + n) y.2 e ∧ m ≤ W.need (T + n) y.2 e) :
    «退化» (continuationStep R) W.activityClass x :=
  activity_every_branch_ends_of_gone start le fun y hy at_ =>
    family_excess_gone balances dependent excess stock at_ (held y hy at_)

/-- **A whole drawing beyond renewal ends the lines that depend on it.** Under balance, with activity
needing support and `n` steps of excess from a stock below `n + m`, a line from an active occurrence
every occurrence of which at step `T + n` depends on a member of the family at a need of at least
`m` does not go on. -/
theorem family_excess_not_endless {L : Flow F C} (balances : L.Balances W)
    (dependent : W.Dependent) {ds : List C} {m : Nat}
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (stock : W.stock ds T < n + m) {x : Nat × F} (start : W.active x.1 x.2) (le : x.1 ≤ T + n)
    (held : ∀ y, «所及» (continuationStep R) W.activityClass x y → y.1 = T + n →
      ∃ e, e ∈ ds ∧ W.requires (T + n) y.2 e ∧ m ≤ W.need (T + n) y.2 e) :
    ¬ «不穷» (continuationStep R) W.activityClass x :=
  «尽则非不穷» (family_excess_degenerates balances dependent excess stock start le held)

/-- **Passing that stops makes every occurrence at step `T + d` inactive**, `d` the span for which
carriers are brief and `T` the step from which nothing passes. -/
theorem stopped_gone {V : Web F C} {passes : Nat → F → F → Prop} (byPassing : V.ByPassing passes)
    {d T : Nat} (brief : ∀ a, V.Brief d a) (stopped : ∀ t, T ≤ t → ¬ V.PassesAt passes t)
    {y : Nat × F} (at_ : y.1 = T + d) : ¬ V.active y.1 y.2 :=
  fun active => byPassing.ends_within brief stopped (Nat.le_of_eq at_.symm) ⟨y.2, active⟩

/-- **Passing that stops degenerates the pattern's line**, under the hypotheses of
`Web.stopped_not_endless`. -/
theorem stopped_degenerates {V : Web F C} {passes : Nat → F → F → Prop}
    (byPassing : V.ByPassing passes) {d T : Nat} (brief : ∀ a, V.Brief d a)
    (stopped : ∀ t, T ≤ t → ¬ V.PassesAt passes t) {x : Nat × F} (start : V.active x.1 x.2)
    (le : x.1 ≤ T + d) :
    «退化» (continuationStep (passingContinuation passes)) V.activityClass x :=
  activity_every_branch_ends_of_gone start le fun _ _ at_ =>
    stopped_gone byPassing brief stopped at_

/-- **Passing that stops ends the pattern's line.** Under the passing premise, with carriers brief
for `d` and no passing from step `T` on, a line from a carrier at a step up to `T + d` does not go
on. -/
theorem stopped_not_endless {V : Web F C} {passes : Nat → F → F → Prop}
    (byPassing : V.ByPassing passes) {d T : Nat} (brief : ∀ a, V.Brief d a)
    (stopped : ∀ t, T ≤ t → ¬ V.PassesAt passes t) {x : Nat × F} (start : V.active x.1 x.2)
    (le : x.1 ≤ T + d) :
    ¬ «不穷» (continuationStep (passingContinuation passes)) V.activityClass x :=
  «尽则非不穷» (stopped_degenerates byPassing brief stopped start le)

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
    «全生成» (Web.continuationStep (Web.passingContinuation passesOdd)) shifted.activityClass
      shifted.carrierClass (t, Pulse.half t) :=
  have onward : ∀ y, «所及» (Web.continuationStep (Web.passingContinuation passesOdd))
      shifted.activityClass (t, Pulse.half t) y → Pulse.half y.1 = y.2 :=
    fun _ hy => Web.active_along_line (W := shifted) (x := (t, Pulse.half t)) rfl hy
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
    «新而有终» (Web.continuationStep (Web.passingContinuation passes)) web.activityClass
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
      «新而有终» (Web.continuationStep (Web.passingContinuation passes)) web.activityClass
        web.carrierClass (t, t) ∧
    shifted.RenewingAlong (Web.passingContinuation passesOdd) t (Pulse.half t) ∧
      «全生成» (Web.continuationStep (Web.passingContinuation passesOdd)) shifted.activityClass
        shifted.carrierClass (t, Pulse.half t) :=
  ⟨fun _ _ _ _ joins => match joins with
     | .inl r => False.elim r
     | .inr d => False.elim d,
   relay_renews_and_ends t,
   fun _ _ _ _ joins => match joins with
     | .inl r => False.elim r
     | .inr d => False.elim d,
   shifted_generates t⟩

/-! ## Witnesses of the regimes, and of the decision -/

namespace Depleted

/-- One formation, active at steps `0` and `1`, depending at need one on one condition, whose level
is one at steps `0` and `1` and zero after. -/
def web : Web Unit Unit where
  level t _ := match t with
    | 0 => 1
    | 1 => 1
    | _ + 2 => 0
  active t _ := t ≤ 1
  requires _ _ _ := True
  need _ _ _ := 1
  draws _ _ _ := True

/-- Activity needs support. -/
theorem dependent : web.Dependent :=
  fun t _ active _ _ => match t, active with
    | 0, _ => Nat.le_refl 1
    | 1, _ => Nat.le_refl 1
    | n + 2, late => absurd late (Nat.not_le_of_gt (Nat.le_add_left 2 n))

/-- After step `1` the level is below the need at step `1`. -/
theorem below : ∀ s, 1 < s → web.level s () < web.need 1 () ()
  | 0, early => absurd early (Nat.not_lt_zero 1)
  | 1, early => absurd early (Nat.lt_irrefl 1)
  | _ + 2, _ => Nat.zero_lt_one

/-- Every step is a continuation. -/
def every : Nat → Unit → Unit → Prop := fun _ _ _ => True

/-- **The line takes its step**: the occurrence at step `0` is continued by the one at step `1`. -/
theorem continues :
    «续» (Web.continuationStep every) web.activityClass (0, ()) (1, ()) :=
  ⟨⟨rfl, trivial⟩, ⟨fun _ => Nat.le_refl 1, fun _ => Nat.zero_le 1⟩⟩

/-- **The premises of `Web.consumed_held_degenerates` hold together, and the line degenerates.** -/
theorem degenerates : «退化» (Web.continuationStep every) web.activityClass (0, ()) :=
  Web.consumed_held_degenerates (c := ()) (g := ()) (T := 1) (N := 2) dependent below
    (Nat.lt_succ_self 1) (Nat.zero_le 1) (Nat.zero_le 2) fun _ _ _ => ⟨trivial, Nat.le_refl 1⟩

end Depleted

/-- **The premises of `Web.family_excess_degenerates` hold together** in `Coupled`: the taker's
line, along every continuation, degenerates. -/
theorem coupled_degenerates :
    «退化» (Web.continuationStep (fun _ _ _ => True)) Coupled.web.activityClass
      (0, Coupled.Formation.taker) :=
  Web.family_excess_degenerates (T := 0) (n := 3) Coupled.balances Coupled.dependent
    Coupled.excess (show 1 + (2 + 0) < 3 + 1 from Nat.lt_succ_self 3) trivial
    (Nat.zero_le 3) fun y _ _ => match y with
      | (_, .taker) => ⟨.patch, .head _, trivial, Nat.le_refl 1⟩
      | (_, .renewer) => ⟨.neighbour, .tail _ (.head _), trivial, Nat.le_refl 1⟩

/-- **The taker's line takes its step**: in `Coupled`, along every continuation, the taker at step
`0` is continued by the taker at step `1`. -/
theorem coupled_continues :
    «续» (Web.continuationStep (fun _ _ _ => True)) Coupled.web.activityClass
      (0, Coupled.Formation.taker) (1, Coupled.Formation.taker) :=
  ⟨⟨rfl, trivial⟩, ⟨fun _ => trivial, fun _ => trivial⟩⟩

/-- **The premises of `Web.stopped_degenerates` hold together** in the relay stopped at `T`: the
first carrier's line degenerates. -/
theorem stopped_relay_degenerates (T : Nat) :
    «退化» (Web.continuationStep (Web.passingContinuation (PatternRelay.passesUntil T)))
      (PatternRelay.stopped T).activityClass (0, 0) :=
  Web.stopped_degenerates (d := 2) (T := T) (PatternRelay.stopped_by_passing T)
    (PatternRelay.stopped_brief T) (PatternRelay.stopped_quiet T) ⟨Nat.zero_le T, .inl rfl⟩
    (Nat.zero_le (T + 2))

/-- **The first carrier's line takes its step**: in the relay stopped at `T`, the first carrier at
step `0` is continued by itself at step `1`. -/
theorem stopped_relay_continues (T : Nat) :
    «续» (Web.continuationStep (Web.passingContinuation (PatternRelay.passesUntil T)))
      (PatternRelay.stopped T).activityClass (0, 0) (1, 0) :=
  ⟨⟨rfl, .inl rfl⟩, ⟨fun _ => ⟨Nat.zero_le T, .inr rfl⟩, fun _ => ⟨Nat.zero_le T, .inl rfl⟩⟩⟩

/-! ## Reaching an end needs the decision -/

namespace Undecided

/-- One occurrence at step `0` (`false`), one at step `1` (`true`), nothing active from step `2`. -/
def web : Web Bool Unit where
  level _ _ := 0
  active t f := (t = 0 ∧ f = false) ∨ (t = 1 ∧ f = true)
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- Every step is continued exactly where `P` holds. -/
def continuation (P : Prop) : Nat → Bool → Bool → Prop := fun _ _ _ => P

/-- Nothing is active at step `2`. -/
theorem inactive_two (f : Bool) : ¬ web.active 2 f :=
  fun now => match now with
    | .inl ⟨e, _⟩ => Nat.noConfusion e
    | .inr ⟨e, _⟩ => Nat.noConfusion (Nat.succ.inj e)

/-- The occurrence at step `1` ends: nothing continues it. -/
theorem last_ends (P : Prop) :
    «亡» (Web.continuationStep (continuation P)) web.activityClass (1, true) :=
  fun ⟨(_, f), ⟨next, _⟩, alike⟩ =>
    inactive_two f
      (Eq.subst (motive := fun s' => web.active s' f) next (alike.mp (.inr ⟨rfl, rfl⟩)))

/-- Where `P` holds, the occurrence at step `0` is continued by the one at step `1`. -/
theorem first_continues {P : Prop} (p : P) :
    «续» (Web.continuationStep (continuation P)) web.activityClass (0, false) (1, true) :=
  ⟨⟨rfl, p⟩, ⟨fun _ => .inr ⟨rfl, rfl⟩, fun _ => .inl ⟨rfl, rfl⟩⟩⟩

/-- Witness lemma: the occurrence at step `0` has a continuation exactly where `P` holds. -/
theorem first_has_next_iff (P : Prop) :
    «有后» (Web.continuationStep (continuation P)) web.activityClass (0, false) ↔ P :=
  ⟨fun ⟨_, c⟩ => c.1.2, fun p => ⟨(1, true), first_continues p⟩⟩

/-- **The premise of the degeneration law holds at the activity grain, and the pattern
degenerates.** -/
theorem degenerates (P : Prop) :
    (∀ y, «所及» (Web.continuationStep (continuation P)) web.activityClass (0, false) y →
        y.1 = 2 → ¬ web.active y.1 y.2) ∧
      «退化» (Web.continuationStep (continuation P)) web.activityClass (0, false) :=
  have gone : ∀ y, «所及» (Web.continuationStep (continuation P)) web.activityClass (0, false) y →
      y.1 = 2 → ¬ web.active y.1 y.2 := fun y _ at_ =>
    Eq.subst (motive := fun s => ¬ web.active s y.2) at_.symm (inactive_two y.2)
  ⟨gone, Web.activity_every_branch_ends_of_gone (.inl ⟨rfl, rfl⟩) (Nat.zero_le 2) gone⟩

/-- **Reaching an end decides `P`.** -/
theorem end_decides {P : Prop}
    (h : «有终» (Web.continuationStep (continuation P)) web.activityClass (0, false)) : P ∨ ¬ P :=
  match h with
  | ⟨_, .inl same, ends⟩ =>
    .inr fun p => ends (Eq.subst
      (motive := fun z => «有后» (Web.continuationStep (continuation P)) web.activityClass z) same
      ((first_has_next_iff P).mpr p))
  | ⟨_, .inr (.one c), _⟩ => .inl c.1.2
  | ⟨_, .inr (.more c _), _⟩ => .inl c.1.2

end Undecided

/-- **That every line meeting the degeneration law's premise reaches an end is exactly excluded
middle**, at every web and continuation: the decision premise of `Web.end_of_gone` is as strong as
excluded middle. -/
theorem end_of_gone_iff_excluded_middle :
    (∀ (F' C' : Type) (V : Web F' C') (R : Nat → F' → F' → Prop) (x : Nat × F') (N : Nat),
        V.active x.1 x.2 → x.1 ≤ N →
        (∀ y, «所及» (Web.continuationStep R) V.activityClass x y → y.1 = N → ¬ V.active y.1 y.2) →
        «有终» (Web.continuationStep R) V.activityClass x) ↔
      ∀ P : Prop, P ∨ ¬ P :=
  ⟨fun h P => Undecided.end_decides
      (h _ _ Undecided.web (Undecided.continuation P) (0, false) 2 (.inl ⟨rfl, rfl⟩)
        (Nat.zero_le 2) (Undecided.degenerates P).1),
   fun em _ _ _ _ _ _ start le gone =>
    «尽而续可定则有终» (Web.activity_every_branch_ends_of_gone start le gone) fun _ _ => em _⟩

end Map

end Becoming
