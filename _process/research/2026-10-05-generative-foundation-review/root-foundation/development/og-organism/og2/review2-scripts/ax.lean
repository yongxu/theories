theorem t_omega (a b c : Nat) (h : a + b ≤ c) : a ≤ c := by omega
theorem t_decide : (List.replicate 3 2).sum = 6 := by decide
theorem t_simp (a : Nat) (l : List Nat) : (a :: l).sum = a + l.sum := by simp
theorem t_rfl (a : Nat) (l : List Nat) : (a :: l).sum = a + l.sum := rfl
#print axioms t_omega
#print axioms t_decide
#print axioms t_simp
#print axioms t_rfl
#print axioms List.sum_cons
#print axioms List.take_succ_cons
#print axioms List.length_take
#print axioms List.take_append
#print axioms List.sum_replicate
#print axioms List.sum_append
#print axioms List.take_replicate
#print axioms List.drop_eq_nil_of_le
#print axioms List.length_replicate
#print axioms Nat.div_add_mod
#print axioms Nat.div_lt_iff_lt_mul
#print axioms Nat.le_div_iff_mul_le
#print axioms Nat.mul_le_mul_left
#print axioms Nat.mul_le_mul_right
#print axioms Nat.add_mul
#print axioms Nat.mul_comm
#print axioms Nat.add_sub_cancel
#print axioms Nat.sub_add_cancel
#print axioms Nat.sub_sub
#print axioms Nat.lt_of_lt_of_le
#print axioms Nat.mod_lt
#print axioms Nat.div_mul_le_self
#print axioms Nat.lt_mul_div_succ
#print axioms List.getElem_replicate
#print axioms List.any_eq_true
