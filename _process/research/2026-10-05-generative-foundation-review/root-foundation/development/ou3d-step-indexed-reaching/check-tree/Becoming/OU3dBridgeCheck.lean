import Becoming.GrammarLaws

/-!
Not for landing: a check that the consumers of OU3d's laws can bridge to them. The definitions of
`Withholding` (its two laws, `Chain`, `Within`) and `Law.orbit` are restated here, since the real
modules sit above `GrammarLaws`; `answers_closed` and `waitsAll_closed` are then read off the
grammar's laws with rounds that hold by `Iff.rfl`, and `Chain` and `Within` meet `«迭»` and
`«迭内»` by `«迭之末步»`.
-/

namespace Becoming
namespace OU3dBridgeCheck

universe u

variable {α : Type u}

def orbit (f : (α → Prop) → α → Prop) (s : α → Prop) : Nat → α → Prop
  | 0 => s
  | n + 1 => f (orbit f s n)

def waitsAll (up : α → α → Prop) (s : α → Prop) (a : α) : Prop := s a ∧ ∀ b, up b a → s b

def answers (up : α → α → Prop) (s : α → Prop) (a : α) : Prop := ∀ b, up b a → s b

inductive Chain (up : α → α → Prop) : Nat → α → α → Prop
  | here (a : α) : Chain up 0 a a
  | step {k : Nat} {b c a : α} : Chain up k b c → up c a → Chain up (k + 1) b a

def Within (up : α → α → Prop) (k : Nat) (b a : α) : Prop := ∃ j, j ≤ k ∧ Chain up j b a

variable {up : α → α → Prop}

/-- As in `Withholding`: a chain of no waits leads from a formation to itself. -/
theorem Chain.zero_eq {b a : α} : Chain up 0 b a → b = a
  | .here _ => rfl

/-- As in `Withholding`: a chain of `n = k + 1` waits ends with one link after a chain of `k`. -/
theorem Chain.last_of_eq {n : Nat} {b a : α} :
    Chain up n b a → ∀ k, n = k + 1 → ∃ c, Chain up k b c ∧ up c a
  | .here _, _, same => Nat.noConfusion same
  | .step ch link, _, same => (Nat.succ.inj same) ▸ ⟨_, ch, link⟩

/-- A chain of `k` waits is `k` steps of the grammar, last step last by `«迭之末步»`. -/
theorem chain_iff : ∀ (k : Nat) {b a : α}, Chain up k b a ↔ «迭» up k b a
  | 0, _, _ => ⟨Chain.zero_eq, fun e => Eq.subst (motive := fun v => Chain up 0 _ v) e (.here _)⟩
  | k + 1, _, _ => ⟨fun ch => match ch.last_of_eq k rfl with
      | ⟨_, ch', link⟩ => («迭之末步» k).mpr ⟨_, (chain_iff k).mp ch', link⟩,
    fun steps => match («迭之末步» k).mp steps with
      | ⟨_, first, link⟩ => .step ((chain_iff k).mpr first) link⟩

theorem within_iff {k : Nat} {b a : α} : Within up k b a ↔ «迭内» up k b a :=
  ⟨fun ⟨j, le, ch⟩ => ⟨j, le, (chain_iff j).mp ch⟩, fun ⟨j, le, steps⟩ => ⟨j, le, (chain_iff j).mpr steps⟩⟩

variable (up) (s : α → Prop)

/-- `Withholding.answers_closed`, read off `«承之迭»`. -/
theorem answers_closed (n : Nat) (a : α) : orbit (answers up) s n a ↔ ∀ b, Chain up n b a → s b :=
  («承之迭» (S := orbit (answers up) s) (fun _ _ => Iff.rfl) n a).trans
    ⟨fun all b ch => all b ((chain_iff n).mp ch), fun all b steps => all b ((chain_iff n).mpr steps)⟩

/-- `Withholding.waitsAll_closed`, read off `«存承之迭»`. -/
theorem waitsAll_closed (n : Nat) (a : α) : orbit (waitsAll up) s n a ↔ ∀ b, Within up n b a → s b :=
  («存承之迭» (S := orbit (waitsAll up) s) (fun _ _ => Iff.rfl) n a).trans
    ⟨fun all b w => all b (within_iff.mp w), fun all b w => all b (within_iff.mpr w)⟩

/-- `WithinMoves.after_course`'s shape: `k` steps, then within `n`, is within `k + n`. -/
theorem steps_then_within {k n : Nat} {x y z : α} (first : «迭» up k x y) (rest : «迭内» up n y z) :
    «迭内» up (k + n) x z :=
  «迭内之接» ⟨k, Nat.le_refl k, first⟩ rest

end OU3dBridgeCheck
end Becoming
