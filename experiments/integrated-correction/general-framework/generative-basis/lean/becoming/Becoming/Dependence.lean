import RelationalRenewal
import Becoming.Renewal
import Becoming.World
import Becoming.Witnesses

/-!
# Dependence that forms, holds, breaks and transforms

`Becoming.Renewal` reads a run through conditions whose dependences are fixed: which
conditions a formation needs, at what level, and which it draws on stay the same
throughout. Here they are observables of the configuration as well. A formation can
come to depend on a condition, need more or less of it, or cease to depend on it.
These changes belong to the same unfolding as the levels they concern.

A dependence holding at a step is read across that step. It is *kept* when the
condition meets it at the step and after it, and *broken* when it was met and the
condition falls below it. One step does not say whether a dependence that changes
during the step ended before the fall or because of it; the reading counts the fall
against the dependence as it stood when the step began.

Formations and conditions are fixed index types, so the identity of a formation across
steps is stipulated by `F`. Drawing records that a formation draws on a condition, not
how much: the levels move by the process alone.

Results:
* Constant dependence is the static reading of `RelationalRenewal`, recovered exactly:
  support, renewal, consumption and the classes of formations agree.
* Change is made at a step: a dependence that holds at one step and not at a later
  one dissolved across a step between, and one that comes to hold formed across one.
  This is stated without excluded middle: no stretch of the run avoids such a step.
* Renewal and consumption remain exclusive, and renewal keeps every renewing
  formation supported.
* Every met dependence is kept or broken across each step, and not both.
* Consumption, as inherited, does not require that the dependence it concerns was
  ever met. A requirement that is never met makes its condition consumed with no
  break; `Lost` adds that a met dependence was broken.
* Where formations are active only while the conditions they then depend on support
  them (`Dependent`, which leaves out buffers, reserves and lags), three outcomes are
  related. A formation active with a dependence at least as strong as an earlier one
  finds the condition meeting the earlier need. After a loss without return, a
  formation still active has weakened or dissolved its dependence; with constant
  dependence it is no longer active. Both are contrapositives of `Dependent`.
* The outcomes are neither exhaustive nor exclusive. Restoration concerns the
  condition, ending and transformation the formation, and whether one formation
  transforms or one ends as another forms depends on the identity stipulated by `F`.
  They are distinct possibilities: in one process, from one configuration, a break of
  the same dependence, read at the start of its step, is followed by an ending, by a
  transformation (one dependence dissolves as another forms) and by a restoration. The
  break does not determine the next configuration; in this witness the move that makes
  the break selects the outcome.
* Stepwise readings of a formation's event, each read through its relations to
  conditions. It is *within renewal* when its step keeps every dependence on every
  condition it participates in, the stepwise counterpart of renewal; whole-run renewal
  includes every active step. It is *breaking* when it draws on a condition at a step
  that breaks a dependence on it, and *undermining* when it draws on a condition at a
  step after which the condition is below both the present need of a dependence on it
  and a need of that dependence met while it held: the stepwise counterpart of
  consumption. A need was met while the dependence held when, at some step since which
  the dependence has held, the condition met the need of that step (`MetAbove`). A level
  from before the dependence held does not count (`NewNeed`); a dependence never met at
  its own need makes no drawer undermining, whatever earlier levels were
  (`FallingNeed`); falling short of a need grown beyond what was ever met is not
  undermining (`RisingNeed`); and a draw below a need that was met undermines after the
  need has grown (`Stunted`). Breaking is undermining, and an event within renewal is
  neither. A formation whose own dependence is broken is not within renewal at that
  step, though it need not be undermining.
* A dependence that lapses for one step and forms again starts a new tenure: one step
  of representation decides whether later drawing undermines (`Gap`). Whether dormancy,
  migration or seasonal absence continues a dependence is an application duty.
* After a loss, further drawing breaks nothing, yet it is undermining. Undermining reads
  co-participation in a shortfall that is not restored, not what a draw does: drawing
  that changes no level undermines too (`Pinned`), and in `Renewable`, where renewal
  continues below support, drawing after the loss also keeps the condition from
  returning.
* The stepwise and whole-run readings differ in both directions: a formation can draw
  within renewal at first and consume later, and an event can break a condition that
  is later restored, so that its formation does not consume in the run.
* Read through a formation's events, renewal is not the conjunction of its steps: a
  formation can keep its conditions at each of its own active steps while another
  formation breaks them.

No ethical predicate, ranking or axiom occurs. Which observables represent an actual
history, and whether a change of dependence preceded a fall, are application duties.

The structure `Dependence` (the observable of any configuration) and `Web`, which is `Dependence`
read along the step index, are stated in `Becoming.World`, the base of the core. The readings of
dependence along a run of a labelled process (`Dependence.along`, `Web.conditions_along`, the
`Crossing`, `Pinned` and `Renewable` runs) are in `Becoming.Labelled`.
-/

namespace Becoming

open RelationalRenewal

universe u v

/-! ## Change is made at a step -/

/-- What holds at `T` and fails at a later `t` ceased across some step between them. -/
theorem ceases_at_a_step {p : Nat → Prop} {T t : Nat} (le : T ≤ t) (holds : p T)
    (fails : ¬ p t) : ¬ ∀ s, T ≤ s → s < t → ¬ (p s ∧ ¬ p (s + 1)) := by
  induction le with
  | refl => exact fun _ => fails holds
  | @step m within earlier =>
    intro none
    exact earlier (fun yes => none m within (Nat.lt_succ_self m) ⟨yes, fails⟩)
      (fun s from_ below => none s from_ (Nat.lt_succ_of_lt below))

/-- What fails at `T` and holds at a later `t` arose across some step between them. -/
theorem arises_at_a_step {p : Nat → Prop} {T t : Nat} (le : T ≤ t) (absent : ¬ p T)
    (holds : p t) : ¬ ∀ s, T ≤ s → s < t → ¬ (¬ p s ∧ p (s + 1)) := by
  induction le with
  | refl => exact fun _ => absent holds
  | @step m within earlier =>
    intro none
    exact none m within (Nat.lt_succ_self m) ⟨fun yes =>
      earlier yes (fun s from_ below => none s from_ (Nat.lt_succ_of_lt below)), holds⟩

/-! ## Dependence as an observable of the configuration

The structure `Dependence` is in `Becoming.World`, where `Web F C` is `Dependence Nat F C`. -/

variable {S : Type u} {A : Type v} {F C : Type}

/-- Fixed dependences: the conditions of `Becoming.Renewal`. -/
def Conditions.dependence (K : Conditions S F C) : Dependence S F C :=
  ⟨K.level, K.active, fun _ => K.requires, fun _ => K.need, fun _ => K.draws⟩

namespace Web

variable (W : Web F C)

/-- The conditions a formation depends on at a step support it there. -/
def Supported (t : Nat) (f : F) : Prop :=
  ∀ c, W.requires t f c → W.need t f c ≤ W.level t c

/-- A formation is active only where the conditions it then depends on support it. -/
def Dependent : Prop :=
  ∀ t f, W.active t f → W.Supported t f

/-- The step from `t` keeps `g`'s dependence on `c`: met at `t` and after the step. -/
def Kept (t : Nat) (g : F) (c : C) : Prop :=
  W.need t g c ≤ W.level t c ∧ W.need t g c ≤ W.level (t + 1) c

/-- The step from `t` breaks `g`'s dependence on `c`: met at `t`, not after the step. -/
def Broken (t : Nat) (g : F) (c : C) : Prop :=
  W.requires t g c ∧ W.need t g c ≤ W.level t c ∧ W.level (t + 1) c < W.need t g c

/-- Every dependence on the condition is kept at every step. -/
def Renewed (c : C) : Prop :=
  ∀ t g, W.requires t g c → W.Kept t g c

/-- A dependence holding at some step is not met at any later step. It need not have
been met at that step; `Lost` requires that. -/
def Consumed (c : C) : Prop :=
  ∃ g T, W.requires T g c ∧ ∀ t, T < t → W.level t c < W.need T g c

/-- A met dependence is broken and never met again: a formed relationship is lost. -/
def Lost (c : C) : Prop :=
  ∃ g T, W.Broken T g c ∧ ∀ t, T < t → W.level t c < W.need T g c

/-- The relations a formation participates in at a step, through dependence or drawing. -/
def Participates (t : Nat) (f : F) (c : C) : Prop :=
  W.requires t f c ∨ W.draws t f c

def RenewingIn (f : F) : Prop :=
  ∀ t c, W.Participates t f c → W.Renewed c

def ConsumingIn (f : F) : Prop :=
  ∃ t c, W.draws t f c ∧ W.Consumed c

/-- A dependence forms across the step from `t`. -/
def Forms (t : Nat) (g : F) (c : C) : Prop :=
  ¬ W.requires t g c ∧ W.requires (t + 1) g c

/-- A dependence dissolves across the step from `t`. -/
def Dissolves (t : Nat) (g : F) (c : C) : Prop :=
  W.requires t g c ∧ ¬ W.requires (t + 1) g c

/-! ## Constant dependence is the static reading -/

/-- The static unfolding of `RelationalRenewal`, whose dependences never change. -/
def static (U : Unfolding F C) : Web F C :=
  ⟨U.level, U.active, fun _ => U.requires, fun _ => U.need, fun _ => U.draws⟩

variable {W}

theorem static_supported (U : Unfolding F C) (t : Nat) (f : F) :
    (static U).Supported t f ↔ RelationalRenewal.Supported U t f :=
  Iff.rfl

theorem static_dependent (U : Unfolding F C) :
    (static U).Dependent ↔ RelationalRenewal.Dependent U :=
  Iff.rfl

theorem static_renewed (U : Unfolding F C) (c : C) :
    (static U).Renewed c ↔ RelationalRenewal.Renewed U c :=
  ⟨fun renewed t g depends => (renewed t g depends).1,
   fun renewed t g depends => ⟨renewed t g depends, renewed (t + 1) g depends⟩⟩

theorem static_consumed (U : Unfolding F C) (c : C) :
    (static U).Consumed c ↔ RelationalRenewal.Consumed U c :=
  ⟨fun ⟨g, T, depends, below⟩ => ⟨g, T + 1, depends, below⟩,
   fun ⟨g, T, depends, below⟩ => ⟨g, T, depends, fun t later => below t (Nat.le_of_lt later)⟩⟩

theorem static_renewingIn (U : Unfolding F C) (f : F) :
    (static U).RenewingIn f ↔ RelationalRenewal.RenewingIn U f :=
  ⟨fun renewing c joins => (static_renewed U c).mp (renewing 0 c joins),
   fun renewing _ c joins => (static_renewed U c).mpr (renewing c joins)⟩

theorem static_consumingIn (U : Unfolding F C) (f : F) :
    (static U).ConsumingIn f ↔ RelationalRenewal.ConsumingIn U f :=
  ⟨fun ⟨_, c, drawn, consumed⟩ => ⟨c, drawn, (static_consumed U c).mp consumed⟩,
   fun ⟨c, drawn, consumed⟩ => ⟨0, c, drawn, (static_consumed U c).mpr consumed⟩⟩

/-! ## Renewal, consumption and loss -/

theorem renewed_not_consumed {c : C} (renewed : W.Renewed c) : ¬ W.Consumed c
  | ⟨g, T, depends, below⟩ =>
    Nat.not_le_of_gt (below (T + 1) (Nat.lt_succ_self T)) (renewed T g depends).2

theorem renewing_not_consuming {f : F} (renewing : W.RenewingIn f) : ¬ W.ConsumingIn f
  | ⟨t, c, drawn, consumed⟩ => renewed_not_consumed (renewing t c (Or.inr drawn)) consumed

/-- Renewal keeps a renewing formation supported at every step. -/
theorem renewing_keeps_support {f : F} (renewing : W.RenewingIn f) (t : Nat) :
    W.Supported t f :=
  fun c depends => (renewing t c (Or.inl depends) t f depends).1

theorem lost_consumed {c : C} : W.Lost c → W.Consumed c
  | ⟨g, T, ⟨depends, _, _⟩, below⟩ => ⟨g, T, depends, below⟩

/-- Every met dependence is kept or broken across each step. -/
theorem kept_or_broken {t : Nat} {g : F} {c : C} (depends : W.requires t g c)
    (met : W.need t g c ≤ W.level t c) : W.Kept t g c ∨ W.Broken t g c :=
  match Nat.lt_or_ge (W.level (t + 1) c) (W.need t g c) with
  | .inl fell => .inr ⟨depends, met, fell⟩
  | .inr held => .inl ⟨met, held⟩

theorem kept_not_broken {t : Nat} {g : F} {c : C} (kept : W.Kept t g c) : ¬ W.Broken t g c
  | ⟨_, _, fell⟩ => Nat.not_le_of_gt fell kept.2

/-! ## Outcomes of a loss where activity needs support -/

/-- A formation supported at `t`, with a dependence at least as strong as an earlier one,
finds the condition meeting the earlier need. Only its support at `t` is used. -/
theorem continuing_restores_at {T t : Nat} {g : F} {c : C} (supported : W.Supported t g)
    (depends : W.requires t g c) (unchanged : W.need T g c ≤ W.need t g c) :
    W.need T g c ≤ W.level t c :=
  Nat.le_trans unchanged (supported c depends)

/-- Under `Dependent`, a formation active with a dependence at least as strong as an
earlier one finds the condition meeting the earlier need. -/
theorem continuing_restores (dependent : W.Dependent) {T t : Nat} {g : F} {c : C}
    (active : W.active t g) (depends : W.requires t g c)
    (unchanged : W.need T g c ≤ W.need t g c) : W.need T g c ≤ W.level t c :=
  continuing_restores_at (dependent t g active) depends unchanged

/-- After a loss without return, a formation supported at a later step has weakened or
dissolved its dependence on the condition. Only its support at that step is used. -/
theorem consumed_continues_transformed_at {T : Nat} {g : F} {c : C}
    (below : ∀ t, T < t → W.level t c < W.need T g c) {t : Nat} (later : T < t)
    (supported : W.Supported t g) : ¬ (W.requires t g c ∧ W.need T g c ≤ W.need t g c)
  | ⟨depends, unchanged⟩ =>
    Nat.not_le_of_gt (below t later) (continuing_restores_at supported depends unchanged)

/-- Under `Dependent`, after a loss without return, a formation that is still active has
weakened or dissolved its dependence on the condition. -/
theorem consumed_continues_transformed (dependent : W.Dependent) {T : Nat} {g : F} {c : C}
    (below : ∀ t, T < t → W.level t c < W.need T g c) {t : Nat} (later : T < t)
    (active : W.active t g) : ¬ (W.requires t g c ∧ W.need T g c ≤ W.need t g c) :=
  consumed_continues_transformed_at below later (dependent t g active)

/-- At one step after a loss, with the dependence as it was and the condition below the
earlier need there, a formation active there only while supported is not active. -/
theorem consumed_ends_when_fixed_at {T t : Nat} {g : F} {c : C}
    (dependent : W.active t g → W.Supported t g)
    (fixed : W.requires t g c ∧ W.need T g c ≤ W.need t g c) (below : W.level t c < W.need T g c) :
    ¬ W.active t g :=
  fun active => Nat.not_le_of_gt below (Nat.le_trans fixed.2 (dependent active c fixed.1))

/-- Under `Dependent`, with dependence that does not change, a formation is not active
after a loss without return. -/
theorem consumed_ends_when_fixed (dependent : W.Dependent) {T : Nat} {g : F} {c : C}
    (fixed : ∀ t, T < t → W.requires t g c ∧ W.need T g c ≤ W.need t g c)
    (below : ∀ t, T < t → W.level t c < W.need T g c) :
    ∀ t, T < t → ¬ W.active t g :=
  fun t later => consumed_ends_when_fixed_at (dependent t g) (fixed t later) (below t later)

/-! ## Stepwise readings -/

/-- A formation's event at `t` is within renewal: it is active, and the step keeps
every dependence on every condition it participates in. -/
def RenewingAt (t : Nat) (f : F) : Prop :=
  W.active t f ∧ ∀ c, W.Participates t f c → ∀ g, W.requires t g c → W.Kept t g c

/-- A formation's relation to a condition at `t` is breaking: it draws on the condition
at a step that breaks a dependence on it. Other formations may take part in the
breaking. -/
def BreakingOn (t : Nat) (f : F) (c : C) : Prop :=
  W.draws t f c ∧ ∃ g, W.Broken t g c

/-- A formation's event at `t` is breaking when one of its relations is. -/
def BreakingAt (t : Nat) (f : F) : Prop :=
  ∃ c, W.BreakingOn t f c

/-- `g`'s dependence on `c` was met above `m` while it held: at some step since which the
dependence has held at every step up to `t`, met or not, the condition met the need of
that step, and that need exceeds `m`. -/
def MetAbove (t : Nat) (g : F) (c : C) (m : Nat) : Prop :=
  ∃ s, s ≤ t ∧ (∀ u, s ≤ u → u ≤ t → W.requires u g c) ∧ W.need s g c ≤ W.level s c ∧
    m < W.need s g c

/-- A formation's relation to a condition at `t` is undermining: it draws on the
condition at a step after which the condition is below a dependence's present need and
below a need of that dependence it met while the dependence held. Other formations may
take part. -/
def UnderminingOn (t : Nat) (f : F) (c : C) : Prop :=
  W.draws t f c ∧ ∃ g, W.requires t g c ∧ W.MetAbove t g c (W.level (t + 1) c) ∧
    W.level (t + 1) c < W.need t g c

/-- A formation's event at `t` is undermining when one of its relations is. -/
def UnderminingAt (t : Nat) (f : F) : Prop :=
  ∃ c, W.UnderminingOn t f c

/-- A dependence holding at `t` and met there, at a need above `m`, was met above `m`
while it held. -/
theorem MetAbove.now {t : Nat} {g : F} {c : C} {m : Nat} (depends : W.requires t g c)
    (met : W.need t g c ≤ W.level t c) (above : m < W.need t g c) : W.MetAbove t g c m :=
  ⟨t, Nat.le_refl t, fun _ after before => Nat.le_antisymm before after ▸ depends, met, above⟩

/-- A breaking relation is undermining. -/
theorem BreakingOn.undermining {t : Nat} {f : F} {c : C} :
    W.BreakingOn t f c → W.UnderminingOn t f c
  | ⟨drawn, g, depends, met, fell⟩ => ⟨drawn, g, depends, .now depends met fell, fell⟩

/-- An event within renewal is not undermining, so not breaking. -/
theorem RenewingAt.not_undermining {t : Nat} {f : F} (renewing : W.RenewingAt t f) :
    ¬ W.UnderminingAt t f
  | ⟨c, drawn, g, depends, _, fell⟩ =>
    Nat.not_le_of_gt fell (renewing.2 c (Or.inr drawn) g depends).2

theorem RenewingAt.not_breaking {t : Nat} {f : F} (renewing : W.RenewingAt t f) :
    ¬ W.BreakingAt t f
  | ⟨c, breaking⟩ => renewing.not_undermining ⟨c, breaking.undermining⟩

/-- Whole-run renewal includes every active step. -/
theorem renewing_at_active {f : F} (renewing : W.RenewingIn f) {t : Nat}
    (active : W.active t f) : W.RenewingAt t f :=
  ⟨active, fun c joins g depends => renewing t c joins t g depends⟩

/-- An event whose step breaks a dependence on a condition it participates in is not
within renewal. -/
theorem not_renewing_at_of_broken {t : Nat} {f g : F} {c : C} (joins : W.Participates t f c)
    (broken : W.Broken t g c) : ¬ W.RenewingAt t f
  | ⟨_, keeps⟩ => kept_not_broken (keeps c joins g broken.1) broken

end Web

/-! ## Consumption need not follow a loss -/

namespace Unmet

inductive Formation where
  | dormant
  | drawer

/-- A dormant formation requires a condition at a level it never has; another draws on
it throughout. Nothing changes. -/
def web : Web Formation Unit where
  level _ _ := 0
  active _
    | .dormant => False
    | .drawer => True
  requires _
    | .dormant => fun _ => True
    | .drawer => fun _ => False
  need _ _ _ := 1
  draws _
    | .dormant => fun _ => False
    | .drawer => fun _ => True

/-- A requirement never met makes its condition consumed, and the drawer consuming,
though no dependence is ever broken and nothing is lost. The drawer is not
undermining at any step. -/
theorem consumed_without_loss :
    web.Dependent ∧ (∀ t g, ¬ web.Broken t g ()) ∧ web.Consumed () ∧ ¬ web.Lost () ∧
    web.ConsumingIn .drawer ∧ ∀ t, ¬ web.UnderminingAt t .drawer := by
  have unbroken : ∀ t g, ¬ web.Broken t g ()
    | _, .dormant, ⟨_, met, _⟩ => Nat.not_succ_le_zero 0 met
    | _, .drawer, ⟨depends, _⟩ => depends
  have consumed : web.Consumed () := ⟨.dormant, 0, trivial, fun _ _ => Nat.zero_lt_one⟩
  refine ⟨?_, unbroken, consumed, fun ⟨g, T, broken, _⟩ => unbroken T g broken,
    ⟨0, (), trivial, consumed⟩, fun _ ⟨_, _, g, depends, ⟨_, _, _, met, _⟩, _⟩ => ?_⟩
  · intro _ f active _ depends
    cases f with
    | dormant => exact False.elim active
    | drawer => exact False.elim depends
  · cases g with
    | dormant => exact Nat.not_succ_le_zero 0 met
    | drawer => exact depends

end Unmet

/-! ## A dependence never met while it held makes no drawer undermining -/

namespace NewNeed

inductive Formation where
  | late
  | drawer

/-- The level is 2 at step 0 and 0 afterwards. `late` depends on the condition at level
one only from step 5, and is never active; `drawer` draws on it from step 5. -/
def web : Web Formation Unit where
  level t _ := match t with
    | 0 => 2
    | _ + 1 => 0
  active t f := match f with
    | .late => False
    | .drawer => 5 ≤ t
  requires t f _ := match f with
    | .late => 5 ≤ t
    | .drawer => False
  need _ _ _ := 1
  draws t f _ := match f with
    | .late => False
    | .drawer => 5 ≤ t

theorem level_late {t : Nat} (late : 5 ≤ t) : web.level t () = 0 :=
  match t, late with
  | _ + 1, _ => rfl

/-- `late`'s dependence is unmet at every step at which it holds. The condition met its
present need at step 0, before the dependence held, and that does not count: the drawer
is undermining at no step, though the whole-run reading counts it consuming through the
inherited `Consumed`. -/
theorem never_met_not_undermining :
    web.Dependent ∧ (∀ t, web.requires t .late () → web.level t () < web.need t .late ()) ∧
    (∀ t, 5 ≤ t → (∃ s, s ≤ t ∧ web.need t .late () ≤ web.level s ()) ∧
      ∀ m, ¬ web.MetAbove t .late () m) ∧
    (∀ t, ¬ web.UnderminingAt t .drawer) ∧ web.ConsumingIn .drawer := by
  have unmet : ∀ t, web.requires t .late () → web.level t () < web.need t .late () :=
    fun _ late => (level_late late).symm ▸ Nat.zero_lt_one
  have never : ∀ t m, ¬ web.MetAbove t .late () m := fun _ _ ⟨s, _, held, met, _⟩ =>
    Nat.not_le_of_gt (unmet s (held s (Nat.le_refl s) ‹_›)) met
  refine ⟨?_, unmet, fun t late => ⟨⟨0, Nat.zero_le t, Nat.le_succ 1⟩, never t⟩,
    fun t ⟨_, _, g, depends, met, _⟩ => ?_,
    ⟨5, (), Nat.le_refl 5, .late, 5, Nat.le_refl 5, fun t later =>
      (level_late (Nat.le_of_lt later)).symm ▸ Nat.zero_lt_one⟩⟩
  · intro _ f active _ depends
    cases f with
    | late => exact False.elim active
    | drawer => exact False.elim depends
  · cases g with
    | late => exact never t _ met
    | drawer => exact depends

end NewNeed

/-! ## A need that falls or grows is compared with the need then -/

namespace FallingNeed

inductive Formation where
  | late
  | drawer

/-- The level is 2 at step 0 and 0 afterwards. `late` depends on the condition at every
step, needing 3 before step 5 and 1 from step 5, and is never active; `drawer` draws on
it from step 5. -/
def web : Web Formation Unit where
  level t _ := match t with
    | 0 => 2
    | _ + 1 => 0
  active t f := match f with
    | .late => False
    | .drawer => 5 ≤ t
  requires _ f _ := match f with
    | .late => True
    | .drawer => False
  need t f _ := match f with
    | .late => if t < 5 then 3 else 1
    | .drawer => 0
  draws t f _ := match f with
    | .late => False
    | .drawer => 5 ≤ t

theorem need_late {t : Nat} (late : 5 ≤ t) : web.need t .late () = 1 :=
  if_neg (Nat.not_lt_of_le late)

theorem need_pos (t : Nat) : 1 ≤ web.need t .late () :=
  if early : t < 5 then
    Nat.le_trans (Nat.le_succ_of_le (Nat.le_succ 1))
      (Nat.le_of_eq (if_pos early : (if t < 5 then 3 else 1) = 3).symm)
  else Nat.le_of_eq (if_neg early : (if t < 5 then 3 else 1) = 1).symm

theorem unmet : ∀ t, web.level t () < web.need t .late ()
  | 0 => Nat.lt_succ_self 2
  | t + 1 => Nat.lt_of_lt_of_le Nat.zero_lt_one (need_pos (t + 1))

/-- `late`'s dependence is unmet at every step. From step 5 its present need is at most
the level at step 0, when it needed more; that earlier level does not count, and the
drawer is undermining at no step, though the whole-run reading counts it consuming. -/
theorem never_met_not_undermining :
    web.Dependent ∧ (∀ t, web.level t () < web.need t .late ()) ∧
    (∀ t, 5 ≤ t → web.need t .late () ≤ web.level 0 ()) ∧
    (∀ t, ¬ web.UnderminingAt t .drawer) ∧ web.ConsumingIn .drawer :=
  ⟨fun _ f active _ depends => match f, active, depends with
    | .late, active, _ => False.elim active,
   unmet, fun _ late => Nat.le_trans (Nat.le_of_eq (need_late late)) (Nat.le_succ 1),
   fun _ ⟨_, _, g, depends, ⟨s, _, _, met, _⟩, _⟩ => match g, depends with
    | .late, _ => Nat.not_le_of_gt (unmet s) met,
   ⟨5, (), Nat.le_refl 5, .late, 5, trivial, fun t later => match t, later with
    | _ + 1, _ => Nat.zero_lt_one⟩⟩

end FallingNeed

namespace RisingNeed

inductive Formation where
  | grower
  | drawer

/-- The level is 3 at step 0 and 1 afterwards. `grower` depends on the condition
throughout, needing 1 before step 5 and 2 from step 5, and is active before step 5;
`drawer` draws on it from step 5. -/
def web : Web Formation Unit where
  level t _ := match t with
    | 0 => 3
    | _ + 1 => 1
  active t f := match f with
    | .grower => t < 5
    | .drawer => 5 ≤ t
  requires _ f _ := match f with
    | .grower => True
    | .drawer => False
  need t f _ := match f with
    | .grower => if t < 5 then 1 else 2
    | .drawer => 0
  draws t f _ := match f with
    | .grower => False
    | .drawer => 5 ≤ t

theorem need_early {t : Nat} (early : t < 5) : web.need t .grower () = 1 := if_pos early

theorem need_grown {t : Nat} (late : 5 ≤ t) : web.need t .grower () = 2 :=
  if_neg (Nat.not_lt_of_le late)

theorem level_pos : ∀ t, 1 ≤ web.level t ()
  | 0 => Nat.le_succ_of_le (Nat.le_succ 1)
  | _ + 1 => Nat.le_refl 1

theorem level_late {t : Nat} (late : 5 ≤ t) : web.level t () = 1 :=
  match t, late with
  | _ + 1, _ => rfl

/-- The need 1 is met before step 5; the need 2 from step 5 never is, though the level at
step 0 would cover it. The grown need is not met while it held, and the drawer is
undermining at no step. -/
theorem grown_need_not_met :
    web.Dependent ∧ (∀ t, t < 5 → web.need t .grower () ≤ web.level t ()) ∧
    (∀ t, 5 ≤ t → web.level t () < web.need t .grower ()) ∧
    (∀ t, 5 ≤ t → web.need t .grower () ≤ web.level 0 ()) ∧
    ∀ t, ¬ web.UnderminingAt t .drawer :=
  have early : ∀ t, t < 5 → web.need t .grower () ≤ web.level t () := fun t before =>
    Nat.le_trans (Nat.le_of_eq (need_early before)) (level_pos t)
  ⟨fun t f active _ depends => match f, active, depends with
    | .grower, active, _ => early t active,
   early,
   fun _ late => Nat.lt_of_le_of_lt (Nat.le_of_eq (level_late late))
     (Nat.lt_of_lt_of_le (Nat.lt_succ_self 1) (Nat.le_of_eq (need_grown late).symm)),
   fun _ late => Nat.le_trans (Nat.le_of_eq (need_grown late)) (Nat.le_succ 2),
   fun t ⟨_, _, g, depends, ⟨s, _, _, met, above⟩, _⟩ => match g, depends with
    | .grower, _ =>
      if before : s < 5 then
        Nat.not_le_of_gt (Nat.lt_of_lt_of_le above (Nat.le_of_eq (need_early before)))
          (level_pos (t + 1))
      else
        Nat.not_succ_le_self 1
          (Nat.le_trans (Nat.le_of_eq (need_grown (Nat.ge_of_not_lt before)).symm)
            (Nat.le_trans met (Nat.le_of_eq (level_late (Nat.ge_of_not_lt before)))))⟩

end RisingNeed

/-! ## A draw below a need that was met undermines after the need has grown -/

namespace Stunted

inductive Formation where
  | grower
  | drawer

/-- The level is 1 at steps 0 and 1 and 0 from step 2. The grower depends on the
condition throughout, needing 1 at step 0, where the need is met and the grower is
active, and 2 from step 1, which is never met. The drawer draws from step 1; its step 1
takes the level from 1 to 0. -/
def web : Web Formation Unit where
  level t _ := match t with
    | 0 => 1
    | 1 => 1
    | _ + 2 => 0
  active t f := match f with
    | .grower => t = 0
    | .drawer => 1 ≤ t
  requires _ f _ := match f with
    | .grower => True
    | .drawer => False
  need t f _ := match f with
    | .grower => match t with
      | 0 => 1
      | _ + 1 => 2
    | .drawer => 0
  draws t f _ := match f with
    | .grower => False
    | .drawer => 1 ≤ t

theorem level_le_one : ∀ t, web.level t () ≤ 1
  | 0 => Nat.le_refl 1
  | 1 => Nat.le_refl 1
  | _ + 2 => Nat.zero_le 1

/-- The grower's need grows from one, met at step 0, to two, never met. No step breaks
its dependence, since the grown need is never met; yet from step 1 every draw leaves the
level below the present need and below the need that was met, and undermines. -/
theorem stunting_undermines :
    web.Dependent ∧ (∀ t, ¬ web.BreakingAt t .drawer) ∧
    ∀ t, 1 ≤ t → web.UnderminingAt t .drawer :=
  ⟨fun _ f active _ depends => match f, active, depends with
    | .grower, active, _ =>
      Eq.subst (motive := fun n => web.need n .grower () ≤ web.level n ()) active.symm
        (Nat.le_refl 1)
    | .drawer, _, h => (nomatch h),
   fun t ⟨_, _, g, depends, met, fell⟩ => match g, depends with
    | .grower, _ => match t, met, fell with
      | 0, _, fell => Nat.lt_irrefl 1 fell
      | m + 1, met, _ => Nat.not_succ_le_self 1 (Nat.le_trans met (level_le_one (m + 1)))
    | .drawer, h => (nomatch h),
   fun t late => match t, late with
    | m + 1, late => ⟨(), late, .grower, trivial,
      ⟨0, Nat.zero_le (m + 1), fun _ _ _ => trivial, Nat.le_refl 1, Nat.zero_lt_one⟩,
      Nat.zero_lt_two⟩
    | 0, h => absurd h (Nat.not_succ_le_zero 0)⟩

end Stunted

/-! ## A one-step lapse starts a new tenure -/

namespace Gap

inductive Formation where
  | migrant
  | drawer

/-- Two at steps 0 to 3 and nothing from step 4. -/
def levels (t : Nat) : Nat := if t < 4 then 2 else 0

/-- The migrant depends on the condition at need 1, met at steps 0 to 2, and is away at
step 3; it depends on the condition again from step 4. The drawer draws from step 3. -/
def away : Web Formation Unit where
  level t _ := levels t
  active t f := match f with
    | .migrant => t < 3
    | .drawer => 3 ≤ t
  requires t f _ := match f with
    | .migrant => t ≠ 3
    | .drawer => False
  need _ f _ := match f with
    | .migrant => 1
    | .drawer => 0
  draws t f _ := match f with
    | .migrant => False
    | .drawer => 3 ≤ t

/-- The same, with the migrant's dependence held through step 3. -/
def held : Web Formation Unit :=
  { away with requires := fun _ f _ => match f with
    | .migrant => True
    | .drawer => False }

theorem levels_high {t : Nat} (early : t < 4) : levels t = 2 := if_pos early

theorem levels_low {t : Nat} (late : 4 ≤ t) : levels t = 0 := if_neg (Nat.not_lt_of_le late)

/-- With the lapse at step 3 the drawer is undermining at no step, though the whole-run
reading counts it consuming; with the dependence held through step 3 it is undermining at
every step from 3. -/
theorem lapse_starts_afresh :
    (∀ t, ¬ away.UnderminingAt t .drawer) ∧ away.ConsumingIn .drawer ∧
    (∀ t, 3 ≤ t → held.UnderminingAt t .drawer) :=
  ⟨fun t ⟨_, drawn, g, depends, ⟨s, _, tenure, met, _⟩, _⟩ => match g, depends with
    | .migrant, _ =>
      if early : s < 4 then tenure 3 (Nat.le_of_lt_succ early) drawn rfl
      else Nat.not_succ_le_zero 0
        (Nat.le_trans met (Nat.le_of_eq (levels_low (Nat.ge_of_not_lt early)))),
   ⟨3, (), Nat.le_refl 3, .migrant, 4, (show (4 : Nat) ≠ 3 by decide), fun t later =>
     Nat.lt_of_le_of_lt (Nat.le_of_eq (levels_low (Nat.le_of_lt later))) Nat.zero_lt_one⟩,
   fun t late => ⟨(), late, .migrant, trivial,
     ⟨0, Nat.zero_le t, fun _ _ _ => trivial,
       Nat.le_trans (Nat.le_succ 1) (Nat.le_of_eq (levels_high (Nat.zero_lt_succ 3)).symm),
       Nat.lt_of_le_of_lt (Nat.le_of_eq (levels_low (Nat.succ_le_succ late))) Nat.zero_lt_one⟩,
     Nat.lt_of_le_of_lt (Nat.le_of_eq (levels_low (Nat.succ_le_succ late))) Nat.zero_lt_one⟩⟩

end Gap

/-! ## The outcomes are distinct possibilities -/

namespace Crossing

/-- How the formation stands: active on the first condition, dormant on it, active on
the second instead, or ended. -/
inductive Mode where
  | onFirst
  | dormant
  | onSecond
  | ended

inductive Source where
  | first
  | second

/-- The level of the first condition and the formation's mode; the second condition
stays at level one. -/
structure State where
  first : Nat
  mode : Mode

inductive Move where
  | rest
  /-- The first condition falls to zero while the formation takes the given mode. -/
  | fall (mode : Mode)
  /-- The first condition is renewed and a dormant formation resumes on it. -/
  | renew

/-- Whether the formation is active in a mode. -/
def Mode.active : Mode → Prop
  | .onFirst => True
  | .dormant => False
  | .onSecond => True
  | .ended => False

/-- Which condition the formation depends on in a mode. -/
def Mode.requires : Mode → Source → Prop
  | .onFirst, .first => True
  | .onFirst, .second => False
  | .dormant, .first => True
  | .dormant, .second => False
  | .onSecond, .first => False
  | .onSecond, .second => True
  | .ended, _ => False

def dependence : Dependence State Unit Source where
  level s
    | .first => s.first
    | .second => 1
  active s _ := s.mode.active
  requires s _ c := s.mode.requires c
  need _ _ _ := 1
  draws _ _ _ := False

def start : State := ⟨1, .onFirst⟩

def endingState : Nat → State
  | 0 => start
  | _ + 1 => ⟨0, .ended⟩

def transformingState : Nat → State
  | 0 => start
  | _ + 1 => ⟨0, .onSecond⟩

def restoringState : Nat → State
  | 0 => start
  | 1 => ⟨0, .dormant⟩
  | _ + 2 => start

end Crossing

/-! ## The stepwise and whole-run readings differ -/

namespace Renewable

def escalatingState : Nat → Nat := Witnesses.profile [1, 1] 0

def dippingState : Nat → Nat := Witnesses.profile [1, 0] 1

def pausingState : Nat → Nat
  | 0 => 1
  | 1 => 0
  | t + 2 => t + 1

end Renewable

/-! ## Undermining without effect -/

namespace Pinned

inductive Formation where
  | old
  | drawer

/-- The level of the condition and the amount the drawer takes at this step. -/
structure State where
  level : Nat
  taking : Nat

/-- `old` depends on the condition at level one and is active while supported; `drawer`
draws on it when it takes a positive amount. -/
def dependence : Dependence State Formation Unit where
  level s _ := s.level
  active s f := match f with
    | .old => 1 ≤ s.level
    | .drawer => True
  requires _ f _ := match f with
    | .old => True
    | .drawer => False
  need _ _ _ := 1
  draws s f _ := match f with
    | .old => False
    | .drawer => 0 < s.taking

def takingState : Nat → State
  | 0 => ⟨2, 0⟩
  | _ + 1 => ⟨0, 1⟩

def restingState : Nat → State
  | 0 => ⟨2, 0⟩
  | _ + 1 => ⟨0, 0⟩

end Pinned

namespace Dip

inductive Formation where
  | dependent
  | drawer

/-- A shared condition dips for one step and is renewed. -/
def levels : Nat → Nat := Witnesses.profile [1, 1, 0] 1

/-- The dependent is active wherever the condition meets its need at both ends of its step. -/
def dependentActive : Nat → Prop := Witnesses.profile [True, False, False] True

/-- The drawer draws on the condition once. -/
def drawerActive : Nat → Prop := Witnesses.profile [False, True] False

/-- The dependent depends on the condition throughout; the drawer only draws on it. -/
def web : Web Formation Unit where
  level t _ := levels t
  active t
    | .dependent => dependentActive t
    | .drawer => drawerActive t
  requires _ f _ := match f with
    | .dependent => True
    | .drawer => False
  need _ _ _ := 1
  draws t
    | .dependent => fun _ => False
    | .drawer => fun _ => drawerActive t

/-- The dependent is within renewal at each of its own steps, yet does not renew in the
run: the drawer breaks the shared condition while the dependent is inactive. Whole-run
renewal reads the shared condition, so it is not the conjunction of a formation's
steps. The dependent draws on nothing, so this separates readings of renewal, not readings
of whether its activity undermines others. -/
theorem renewing_at_each_step_not_in_run :
    web.Dependent ∧ (∀ t, web.active t .dependent → web.RenewingAt t .dependent) ∧
    ¬ web.RenewingIn .dependent := by
  refine ⟨?_, ?_, fun renewing => ?_⟩
  · intro t f active c depends
    cases f with
    | drawer => exact False.elim depends
    | dependent =>
      match t, active with
      | 0, _ => exact Nat.le_refl 1
      | _ + 3, _ => exact Nat.le_refl 1
  · intro t active
    refine ⟨active, fun _ _ g depends => ?_⟩
    cases g with
    | drawer => exact False.elim depends
    | dependent =>
      match t, active with
      | 0, _ => exact ⟨Nat.le_refl 1, Nat.le_refl 1⟩
      | _ + 3, _ => exact ⟨Nat.le_refl 1, Nat.le_refl 1⟩
  · exact Nat.not_succ_le_zero 0 (renewing 0 () (Or.inl trivial) 1 .dependent trivial).2

end Dip

end Becoming
