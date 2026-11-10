import Becoming.Frame
import Becoming.Extension

/-!
# The lifting rule L on a frame's responses

A response may have several outcomes on a frame, so comparing responses needs a rule lifting the
comparison of configurations to responses. `LiftBetter` (`Becoming.Metaethics`) is the
conservative rule: every outcome of one is better than every outcome of the other. This module
states what C, P and N give under it.

* **C lifts**: for a comparison meeting C, where every outcome of `b` extends every outcome of
  `a`, `b` is liftedly better by it (`comparison_lifts`).
* **P with L**: a lifted comparison between live responses supplies a reason to move
  (`lifted_comparison_supplies_reason`).
* **N with L**: a selection that no live response liftedly dominates selects a live response no
  live response liftedly extends (`lift_coherent_selection_survives`); where every live response
  is liftedly extended by a live one, none survives (`lift_continual_improvement_has_no_survivor`).
* **The choice of the rule is substantive** (`LiftModel`): a response with one better and one
  worse outcome is comparable by neither direction of the conservative rule, though some outcome
  beats (`some_outcome_does_not_lift`); and transitivity needs a live middle response, since
  through a response with no outcome both lifted comparisons hold vacuously while the composite
  fails (`lift_needs_live_middle`).

The functional articulation of `GenerativeComparison` is the deterministic case of P with L
(`articulation_iff_lifted`, `Becoming.Bridge`). Every declaration has an empty axiom report.
-/

namespace Becoming

open Generative

section Lifting

variable {S A C : Type}

/-- Every outcome of `b` generatively extends every outcome of `a`. -/
def LiftExtension (F : Frame S A C) (living : C → Prop) (s : S) (a b : A) : Prop :=
  ∀ t, F.P.step s a t → ∀ t', F.P.step s b t' → Extension F living t t'

/-- C lifts: for a comparison meeting C, a lifted extension is a conservative lifted comparison.
`Better first second` follows `GenerativeComparison`: the second is better. -/
theorem comparison_lifts {F : Frame S A C} {living : C → Prop} {Better : S → S → Prop}
    (comparison : Comparison F living Better) {s : S} {a b : A}
    (extension : LiftExtension F living s a b) : LiftBetter F (fun x y => Better y x) s b a :=
  fun t' ht' t ht => comparison t t' (extension t ht t' ht')

/-- P with L: a lifted comparison between live responses supplies a reason to move. -/
def LiftedArticulation (F : Frame S A C) (Better : S → S → Prop) (s : S)
    (Reason : A → A → Prop) : Prop :=
  ∀ a b, Enabled F.P s a → Enabled F.P s b → LiftBetter F (fun x y => Better y x) s b a →
    Reason a b

theorem lifted_comparison_supplies_reason {F : Frame S A C} {living : C → Prop}
    {Better : S → S → Prop} {s : S} {Reason : A → A → Prop}
    (comparison : Comparison F living Better) (practical : LiftedArticulation F Better s Reason)
    {a b : A} (liveA : Enabled F.P s a) (liveB : Enabled F.P s b)
    (extension : LiftExtension F living s a b) : Reason a b :=
  practical a b liveA liveB (comparison_lifts comparison extension)

/-- A live response no live response liftedly extends. -/
def LiftSurvives (F : Frame S A C) (living : C → Prop) (s : S) (a : A) : Prop :=
  Enabled F.P s a ∧ ∀ b, Enabled F.P s b → ¬ LiftExtension F living s a b

/-- N with L: a selected response is live and liftedly dominated by no live one. -/
def LiftCoherence (F : Frame S A C) (Better : S → S → Prop) (s : S)
    (Selected : A → Prop) : Prop :=
  ∀ a, Selected a → Enabled F.P s a ∧
    ∀ b, Enabled F.P s b → ¬ LiftBetter F (fun x y => Better y x) s b a

theorem lift_coherent_selection_survives {F : Frame S A C} {living : C → Prop}
    {Better : S → S → Prop} {s : S} {Selected : A → Prop}
    (comparison : Comparison F living Better) (coherence : LiftCoherence F Better s Selected)
    {a : A} (selected : Selected a) : LiftSurvives F living s a :=
  match coherence a selected with
  | ⟨live, undominated⟩ =>
    ⟨live, fun b liveB extension => undominated b liveB (comparison_lifts comparison extension)⟩

theorem lift_continual_improvement_has_no_survivor {F : Frame S A C} {living : C → Prop}
    {s : S} (improvement : ∀ a, Enabled F.P s a → ∃ b, Enabled F.P s b ∧ LiftExtension F living s a b)
    (a : A) : ¬ LiftSurvives F living s a
  | ⟨live, survives⟩ => match improvement a live with
    | ⟨b, liveB, extension⟩ => survives b liveB extension

namespace LiftModel

inductive Act where
  | low | high | mixed | dead

/-- From configuration 0: `low` reaches 1, `high` 3, `mixed` 0 or 4, `dead` nothing.
A larger configuration is better. -/
def options : Nat → Act → Nat → Prop
  | s, .low, t => s = 0 ∧ t = 1
  | s, .high, t => s = 0 ∧ t = 3
  | s, .mixed, t => s = 0 ∧ (t = 0 ∨ t = 4)
  | _, .dead, _ => False

def frame : Frame Nat Act Unit := ⟨⟨options⟩, fun _ _ => True⟩

def larger (x y : Nat) : Prop := y < x

/-- The lifting rule is substantive: a response with one better and one worse
outcome is not comparable by the conservative rule, yet some outcome beats. -/
theorem some_outcome_does_not_lift :
    (∃ t t', frame.P.step 0 .mixed t ∧ frame.P.step 0 .high t' ∧ larger t t') ∧
    ¬ LiftBetter frame larger 0 .mixed .high ∧ ¬ LiftBetter frame larger 0 .high .mixed :=
  ⟨⟨4, 3, ⟨rfl, Or.inr rfl⟩, ⟨rfl, rfl⟩, Nat.lt_succ_self 3⟩,
    fun lifted => Nat.not_lt_zero 3 (lifted 0 ⟨rfl, Or.inl rfl⟩ 3 ⟨rfl, rfl⟩),
    fun lifted => Nat.lt_asymm (Nat.lt_succ_self 3) (lifted 3 ⟨rfl, rfl⟩ 4 ⟨rfl, Or.inr rfl⟩)⟩

/-- Transitivity needs a live middle response: through a response with no outcome
both lifted comparisons hold vacuously, while the composite fails. -/
theorem lift_needs_live_middle :
    LiftBetter frame larger 0 .low .dead ∧ LiftBetter frame larger 0 .dead .high ∧
    ¬ LiftBetter frame larger 0 .low .high :=
  ⟨fun _ _ _ never => (nomatch never), fun _ never => (nomatch never),
    fun lifted => Nat.lt_asymm (lifted 1 ⟨rfl, rfl⟩ 3 ⟨rfl, rfl⟩)
      (Nat.lt_trans (Nat.lt_succ_self 1) (Nat.lt_succ_self 2))⟩

end LiftModel

end Lifting

end Becoming
