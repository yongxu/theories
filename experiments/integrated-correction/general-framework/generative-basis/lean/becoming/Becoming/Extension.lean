import Becoming.Regions
import Becoming.Witnesses

/-!
# Extension: C on frames, with no axiom

C, the comparison of `Becoming.Metaethics`, read on frames and on the level paths of a web, with
no valuation and no condition.

* **Living significance as a predicate.** Living content realized at a configuration falls under a
  relevance (`LivingSignificance`); stated here, with no valuation and no condition, since R34
  (20 October 2026), so that modules that compare readings without the condition need not import
  the valuations.
* **On frames.** A configuration extends another when it keeps every claim the other realizes
  and realizes a living claim the other does not (`Extension`); C on a frame is the requirement
  that an order rank every extension above what it extends (`Comparison`), and a description
  supporting an irreflexive order meeting it tells every extension from its base
  (`Comparison.separates`). Extension is irreflexive and transitive (`Extension.irrefl`,
  `Extension.trans`); a natural-number score satisfying C climbs along a chain of extensions and
  outgrows every configuration (`Comparison.climbs`, `Comparison.outgrows`). `LiftBetter` lifts
  an order from outcomes to moves (`LiftBetter.trans`, `LiftBetter.irrefl`, `LiftBetter.some`).
* **On the paths of a web.** The frame of a web's level paths (`Web.paths`): an extension in
  which every claim counts as living is exactly a widening (`Web.paths_extension_iff_widens`), so
  the widening order meets C for every reading of `living`
  (`Web.paths_comparison_widens`).

This holds by definition: `Comparison` unfolds to `Extension`, so that the widening order meets C
is an unfolding, and that courses are ranked by widening is taken, not shown here. Every
declaration moved here unchanged, with its name, from `Becoming.ValuationFrames` (R31, 20 October
2026), which reads valuations and the continuation condition on the same frames; the modules that
use C, and neither the valuations nor the condition, import this module and not those. No
valuation, condition or axiom occurs.
-/

namespace Becoming

open Generative

section Frames

variable {S A C : Type}

/-- A generative extension: the second configuration keeps every claim of the first
and realizes some living claim the first does not. -/
def Extension (F : Frame S A C) (living : C → Prop) (s t : S) : Prop :=
  (∀ c, F.realized s c → F.realized t c) ∧
    ∃ c, living c ∧ F.realized t c ∧ ¬ F.realized s c

/-- Living significance on the frame: living content realized at a configuration falls under the
relevance `relevance` there. The parameter carries no valence: read from significance
(`Frame.relevance`), it is significance from every standpoint. A predicate on a frame, with no
valuation and no condition; under the continuation condition it holds
(`livingSignificance_of_unrestricted`, `Web.unrestricted_iff_paths_livingSignificance`, in
`Becoming.Relevance`), and nothing here assumes it. -/
def LivingSignificance (F : Frame S A C) (living : C → Prop) (relevance : S → C → Prop) : Prop :=
  ∀ s c, living c → F.realized s c → relevance s c

/-- C on the frame: the requirement that the order `Better` rank every extension above what
it extends. `Better s t` says that the order ranks `t` strictly above `s`. -/
def Comparison (F : Frame S A C) (living : C → Prop) (Better : S → S → Prop) : Prop :=
  ∀ s t, Extension F living s t → Better s t

/-- **What C needs to see.** Where a comparison is read off a description of configurations,
compares no description with itself and meets C, the description tells every extension apart from
its base: a description identifying a configuration with an extension of it supports no comparison
satisfying C. -/
theorem Comparison.separates {F : Frame S A C} {living : C → Prop} {D : Type} {π : S → D}
    {compare : D → D → Prop} (irreflexive : ∀ d, ¬ compare d d)
    (comparison : Comparison F living fun s t => compare (π s) (π t)) {s t : S}
    (extension : Extension F living s t) : π s ≠ π t :=
  fun same => irreflexive (π t) (Eq.subst (motive := fun d => compare d (π t)) same
    (comparison s t extension))

/-- No configuration extends itself. -/
theorem Extension.irrefl {F : Frame S A C} {living : C → Prop} {s : S} :
    ¬ Extension F living s s :=
  fun ⟨_, _, _, now, before⟩ => before now

/-- Extensions compose. -/
theorem Extension.trans {F : Frame S A C} {living : C → Prop} {s t u : S}
    (first : Extension F living s t) (second : Extension F living t u) : Extension F living s u :=
  ⟨fun c held => second.1 c (first.1 c held),
    let ⟨c, live, now, before⟩ := second.2
    ⟨c, live, now, fun earlier => before (first.1 c earlier)⟩⟩

/-- **A natural-number score satisfying C climbs.** Along an endless chain of extensions, a
natural-number score whose strict order satisfies C rises by at least one at every link. -/
theorem Comparison.climbs {F : Frame S A C} {living : C → Prop} {score : S → Nat}
    (comparison : Comparison F living fun s t => score s < score t) {next : Nat → S}
    (chain : ∀ i, Extension F living (next i) (next (i + 1))) :
    ∀ m, score (next 0) + m ≤ score (next m)
  | 0 => Nat.le_refl _
  | m + 1 => Nat.le_trans (Nat.succ_le_succ (Comparison.climbs comparison chain m))
      (comparison _ _ (chain m))

/-- **No configuration stays above an endless chain of extensions.** A natural-number score whose
strict order satisfies C ranks some link of the chain above any configuration whatever: the link
`score s + 1` steps along. The force is the unit step of the natural numbers: a bounded score
(with values `k / (k + 1)`, say) can satisfy C without this. -/
theorem Comparison.outgrows {F : Frame S A C} {living : C → Prop} {score : S → Nat}
    (comparison : Comparison F living fun s t => score s < score t) {next : Nat → S}
    (chain : ∀ i, Extension F living (next i) (next (i + 1))) (s : S) :
    score s < score (next (score s + 1)) :=
  Nat.le_trans (Nat.le_add_left (score s + 1) (score (next 0)))
    (Comparison.climbs comparison chain (score s + 1))

/-- L, conservative default: the order `better` ranks every outcome of `a` above every outcome
of `b`. -/
def LiftBetter (F : Frame S A C) (better : S → S → Prop) (s : S) (a b : A) : Prop :=
  ∀ t, F.P.step s a t → ∀ t', F.P.step s b t' → better t t'

theorem LiftBetter.trans {F : Frame S A C} {better : S → S → Prop} {s : S} {a b c : A}
    (transitive : ∀ {x y z}, better x y → better y z → better x z)
    (ab : LiftBetter F better s a b) (bc : LiftBetter F better s b c)
    (live : Enabled F.P s b) : LiftBetter F better s a c :=
  fun t ht t' ht' => match live with
    | ⟨m, hm⟩ => transitive (ab t ht m hm) (bc m hm t' ht')

theorem LiftBetter.irrefl {F : Frame S A C} {better : S → S → Prop} {s : S} {a : A}
    (irreflexive : ∀ x, ¬ better x x) (live : Enabled F.P s a) : ¬ LiftBetter F better s a a :=
  fun lifted => match live with
    | ⟨t, ht⟩ => irreflexive t (lifted t ht t ht)

/-- The default implies the weaker "some outcome beats some outcome" when both act. -/
theorem LiftBetter.some {F : Frame S A C} {better : S → S → Prop} {s : S} {a b : A}
    (lifted : LiftBetter F better s a b) (liveA : Enabled F.P s a) (liveB : Enabled F.P s b) :
    ∃ t t', F.P.step s a t ∧ F.P.step s b t' ∧ better t t' :=
  match liveA, liveB with
  | ⟨t, ht⟩, ⟨t', ht'⟩ => ⟨t, t', ht, ht', lifted t ht t' ht'⟩

end Frames

/-! ## The paths of a web -/

section Paths

variable {F C : Type}

/-- The frame of a web's level paths: a claim is a formation at a step, realized along a level
path when the levels admit it there. Nothing steps. -/
def Web.paths (W : Web F C) : Frame (Nat → C → Nat) Unit (F × Nat) :=
  ⟨Witnesses.halted _ _, fun l e => W.Admits (l e.2) e.2 e.1⟩

/-- C with no axiom. On level paths, an extension in which every claim counts as living is exactly
a widening. -/
theorem Web.paths_extension_iff_widens (W : Web F C) {l l' : Nat → C → Nat} :
    Extension W.paths (fun _ => True) l' l ↔ W.Widens l l' :=
  ⟨fun ⟨keeps, e, _, realized, fresh⟩ => ⟨fun t f admits => keeps (f, t) admits, e.2, e.1, realized, fresh⟩,
   fun ⟨includes, t, f, admits, not⟩ =>
    ⟨fun e admits => includes e.2 e.1 admits, (f, t), trivial, admits, not⟩⟩

/-- C with no axiom, by definition. On level paths, the order ranking by widening what can form
meets C for every reading of `living`. The proof unfolds `Comparison` to `Extension`: that
courses are ranked by widening is taken, not shown here. -/
theorem Web.paths_comparison_widens (W : Web F C) (living : F × Nat → Prop) :
    Comparison W.paths living fun l' l => W.Widens l l' :=
  fun _ _ ⟨keeps, e, _, realized, fresh⟩ =>
    ⟨fun t f admits => keeps (f, t) admits, e.2, e.1, realized, fresh⟩

end Paths

end Becoming
