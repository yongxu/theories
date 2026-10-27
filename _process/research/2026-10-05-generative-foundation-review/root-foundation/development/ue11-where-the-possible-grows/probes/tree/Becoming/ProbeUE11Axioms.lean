import Becoming.HeldPossible

/-! Which core lemmas the probes may use with an empty axiom report. -/

namespace Becoming.ProbeUE11.Axioms

theorem a1 : Nat.succ 0 ≠ 0 := Nat.succ_ne_zero 0
theorem a2 : Nat.succ 0 ≠ 0 := fun h => Nat.noConfusion h
theorem a3 : (1 : Nat) ≠ 0 := fun h => nomatch h
theorem a4 (n : Nat) : n + 1 ≠ n := Nat.succ_ne_self n
theorem a5 (n m : Nat) (h : ¬ n ≤ m) : m < n := Nat.gt_of_not_le h
theorem a6 (n m : Nat) (h : ¬ n < m) : m ≤ n := Nat.ge_of_not_lt h
theorem a7 (n m : Nat) (h : n ≤ m) : ¬ m < n := Nat.not_lt_of_le h
theorem a8 : ∀ b : Bool, ¬ cond (!b) (1 : Nat) 0 = cond b 1 0
  | true => fun same => Nat.noConfusion same
  | false => fun same => Nat.noConfusion same

end Becoming.ProbeUE11.Axioms
