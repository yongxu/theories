import Becoming.MapInstances

/-! Reviewer's check, not for landing: OU3f part two's `steps_advance` and `reaches_onward` re-proof,
against main's MapInstances, with `«迭则所及»` and `«不穷则迭»` copied verbatim from the tree. -/

namespace Becoming
namespace OU3fMapCheck

universe u

section Copy

variable {α : Type u}

/-- `n` steps of a line's continuation lie within the line's reach (迭则所及). -/
theorem «迭则所及» {R E : «际» α} : ∀ (n : Nat) {x y : α}, «迭» («续» R E) n x y → «所及» R E x y
  | 0, _, _, e => .inl e
  | n + 1, _, _, steps => .inr («迭则及» n steps)

/-- **An unending line has steps of every length (不穷则迭).** -/
theorem «不穷则迭» {R E : «际» α} {x : α} (endless : «不穷» R E x) :
    ∀ n, ∃ y, «迭» («续» R E) n x y
  | 0 => ⟨x, rfl⟩
  | n + 1 => match «不穷则迭» endless n with
    | ⟨y, steps⟩ => match endless y («迭则所及» n steps) with
      | ⟨z, c⟩ => ⟨z, («迭之末步» n).mpr ⟨y, steps, c⟩⟩

end Copy

variable {F C : Type} {R : Nat → F → F → Prop}

open Web in
/-- `k` steps of a continuation under `continuationStep R` advance the step index by `k`. -/
theorem steps_advance {E : «际» (Nat × F)} : ∀ (k : Nat) {x y : Nat × F},
    «迭» («续» (continuationStep R) E) k x y → y.1 = x.1 + k
  | 0, _, _, e => (congrArg Prod.fst e).symm
  | k + 1, x, _, ⟨_, c, rest⟩ =>
    (steps_advance k rest).trans ((congrArg (· + k) c.1.1).trans (Nat.succ_add x.1 k))

open Web in
/-- `Web.reaches_onward`, re-proved as in the tree. -/
theorem reaches_onward {E : «际» (Nat × F)} {x : Nat × F}
    (endless : «不穷» (continuationStep R) E x) :
    ∀ k, ∃ y, «所及» (continuationStep R) E x y ∧ y.1 = x.1 + k :=
  fun k => match «不穷则迭» endless k with
  | ⟨y, steps⟩ => ⟨y, «迭则所及» k steps, steps_advance k steps⟩

/-- The statement is the real one. -/
example {E : «际» (Nat × F)} {x : Nat × F} (endless : «不穷» (Web.continuationStep R) E x) :
    ∀ k, ∃ y, «所及» (Web.continuationStep R) E x y ∧ y.1 = x.1 + k :=
  Web.reaches_onward endless

/-- A probe so the audit reports `Nat.succ_add`'s axioms. -/
theorem succ_add_probe : ∀ n m : Nat, Nat.succ n + m = Nat.succ (n + m) := Nat.succ_add

end OU3fMapCheck
end Becoming
