#print axioms Nat.div_eq
#print axioms Nat.left_distrib
#print axioms Nat.right_distrib
#print axioms Nat.mul_succ
#print axioms Nat.succ_mul
#print axioms Nat.add_comm
#print axioms Nat.add_assoc
#print axioms Nat.sub_le
#print axioms Nat.le_sub_of_add_le
#print axioms Nat.add_le_add
#print axioms Nat.add_sub_add_right
#print axioms Nat.add_sub_of_le
#print axioms Nat.sub_add_comm
-- Prototype: the horizon on own sum and own ageing, no simp, no omega, no Nat.sub lemma: level kept additively
def sumL : List Nat → Nat | [] => 0 | a :: as => a + sumL as
def rep : Nat → Nat → List Nat | 0, _ => [] | n+1, q => q :: rep n q
theorem sumL_rep (n q : Nat) : sumL (rep n q) = n * q := by
  induction n with
  | zero => exact (Nat.zero_mul q).symm
  | succ n ih => show q + sumL (rep n q) = (n+1) * q
                 rw [ih, Nat.succ_mul, Nat.add_comm]
#print axioms sumL_rep
-- the additive form of one overdrawn step, which needs no Nat.sub lemma
theorem horizon_form (g d L : Nat) : ∀ k, k * d ≤ L → ∃ r, r + k * d = L := by
  intro k h
  exact ⟨L - k * d, Nat.sub_add_cancel h⟩
#print axioms horizon_form
theorem horizon_own (d L k : Nat) (h : k * d ≤ L) : ∃ r, r + k * d = L := by
  induction k * d generalizing L with
  | zero => exact ⟨L, rfl⟩
  | succ n ih =>
    cases L with
    | zero => exact absurd h (Nat.not_succ_le_zero n)
    | succ L =>
      have ⟨r, hr⟩ := ih L (Nat.le_of_succ_le_succ h)
      exact ⟨r, congrArg Nat.succ hr⟩
#print axioms horizon_own
