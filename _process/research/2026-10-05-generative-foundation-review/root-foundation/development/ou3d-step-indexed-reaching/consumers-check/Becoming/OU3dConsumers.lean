import Becoming.Withholding
import Becoming.Tolerance
import Becoming.Labelled

/-!
Not for landing: the second step's evidence. The real consumers' statements, re-proved from OU3d's laws in the
landed `GrammarLaws` (this tree's copy): `Withholding.answers_closed` and `waitsAll_closed` on the real
`Law.run` with rounds by `Iff.rfl`, `withholding_spreads`, `Tolerance.answers_restores_iff`, `Chain` and
`Within` against `«迭»` and `«迭内»`, `Trace` against `«迭»` of a process's steps, and
`WithinMoves.after_course`. Adapted from the independent review's check (REVIEW-OU3d.md).
-/

namespace Becoming
namespace OU3dConsumers

open Generative

universe u v w

section Withholding'

variable {α : Type u}

open Withholding

theorem chain_iff {up : α → α → Prop} : ∀ (k : Nat) {b a : α}, Chain up k b a ↔ «迭» up k b a
  | 0, _, _ => ⟨Chain.zero_eq, fun e => Eq.subst (motive := fun v => Chain up 0 _ v) e (.here _)⟩
  | k + 1, _, _ => ⟨fun ch => match Chain.last ch with
      | ⟨_, ch', link⟩ => («迭之末步» k).mpr ⟨_, (chain_iff k).mp ch', link⟩,
    fun steps => match («迭之末步» k).mp steps with
      | ⟨_, first, link⟩ => .step ((chain_iff k).mpr first) link⟩

theorem within_iff {up : α → α → Prop} {k : Nat} {b a : α} : Within up k b a ↔ «迭内» up k b a :=
  ⟨fun ⟨j, le, ch⟩ => ⟨j, le, (chain_iff j).mp ch⟩,
   fun ⟨j, le, steps⟩ => ⟨j, le, (chain_iff j).mpr steps⟩⟩

/-- The real `Withholding.answers_closed`, on the real `Law.run`, rounds by `Iff.rfl`, `R` inferred. -/
theorem answers_closed (up : α → α → Prop) (s : α → Prop) (n : Nat) (a : α) :
    (Law.run (answers up) s).state n a ↔ ∀ b, Chain up n b a → s b :=
  («承之迭» (S := (Law.run (answers up) s).state) (fun _ _ => Iff.rfl) n a).trans
    ⟨fun all b ch => all b ((chain_iff n).mp ch), fun all b steps => all b ((chain_iff n).mpr steps)⟩

/-- The real `Withholding.waitsAll_closed`, rounds by `Iff.rfl`, `R` inferred. -/
theorem waitsAll_closed (up : α → α → Prop) (s : α → Prop) (n : Nat) (a : α) :
    (Law.run (waitsAll up) s).state n a ↔ ∀ b, Within up n b a → s b :=
  («存承之迭» (S := (Law.run (waitsAll up) s).state) (fun _ _ => Iff.rfl) n a).trans
    ⟨fun all b w => all b (within_iff.mp w), fun all b w => all b (within_iff.mpr w)⟩

theorem withholding_spreads {up : α → α → Prop} {s : α → Prop} {b a : α} {k n : Nat}
    (out : ¬ s b) (ch : Chain up k b a) (le : k ≤ n) : ¬ (Law.run (waitsAll up) s).state n a :=
  fun gives => out ((waitsAll_closed up s n a).mp gives b ⟨k, le, ch⟩)

theorem answers_restores_iff {up : α → α → Prop} (n : Nat) (a : α) :
    (∀ s, (Law.run (answers up) s).state n a) ↔ ∀ b, ¬ Chain up n b a :=
  ⟨fun all b ch => (answers_closed up Tolerance.allWithheld n a).mp
      ((Tolerance.worst_start (Tolerance.answers_keeps up) n a).mp all) b ch,
   fun empty s => (answers_closed up s n a).mpr fun b ch => (empty b ch).elim⟩

/-- The statements agree with the real ones. -/
example : ∀ (up : α → α → Prop) (s : α → Prop) (n : Nat) (a : α),
    (Law.run (answers up) s).state n a ↔ ∀ b, Chain up n b a → s b := Withholding.answers_closed
example : ∀ (up : α → α → Prop) (s : α → Prop) (n : Nat) (a : α),
    (Law.run (waitsAll up) s).state n a ↔ ∀ b, Within up n b a → s b := Withholding.waitsAll_closed

end Withholding'

section Traces

variable {S : Type u} {A : Type v} {C : Type w} {P : Process S A}

theorem trace_steps : ∀ {s t : S} {xs : List A}, Trace P s xs t → «迭» (Steps P) xs.length s t
  | _, _, _, .nil _ => rfl
  | _, _, _, .cons step path => ⟨_, ⟨_, step⟩, trace_steps path⟩

theorem steps_trace : ∀ (k : Nat) {s t : S}, «迭» (Steps P) k s t →
    ∃ xs : List A, xs.length = k ∧ Trace P s xs t
  | 0, s, _, e => ⟨[], rfl, Eq.subst (motive := fun v => Trace P s [] v) e (.nil s)⟩
  | k + 1, _, _, ⟨_, ⟨a, step⟩, rest⟩ => match steps_trace k rest with
    | ⟨xs, len, path⟩ => ⟨a :: xs, congrArg (· + 1) len, .cons step path⟩

theorem withinMoves_iff {realized : S → C → Prop} {bundle : C → Prop} {s : S} {n : Nat} :
    WithinMoves P realized s n bundle ↔ ∃ t, «迭内» (Steps P) n s t ∧ ∀ c, bundle c → realized t c :=
  ⟨fun ⟨word, t, path, short, holds⟩ => ⟨t, ⟨word.length, short, trace_steps path⟩, holds⟩,
   fun ⟨t, ⟨k, le, steps⟩, holds⟩ => match steps_trace k steps with
    | ⟨xs, len, path⟩ => ⟨xs, t, path, Eq.subst (motive := fun i => i ≤ n) len.symm le, holds⟩⟩

/-- `WithinMoves.after_course` from `«迭内之接»`, the bound in the consumers' order. -/
theorem after_course {realized : S → C → Prop} {bundle : C → Prop} {n : Nat} {s t : S}
    {xs : List A} (path : Trace P s xs t) (within : WithinMoves P realized t n bundle) :
    WithinMoves P realized s (xs.length + n) bundle :=
  match withinMoves_iff.mp within with
  | ⟨u, rest, holds⟩ =>
    withinMoves_iff.mpr ⟨u, «迭内之接» ⟨xs.length, Nat.le_refl _, trace_steps path⟩ rest, holds⟩

end Traces

end OU3dConsumers
end Becoming
