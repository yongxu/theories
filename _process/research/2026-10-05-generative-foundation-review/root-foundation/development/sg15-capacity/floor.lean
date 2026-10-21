/-- What leaves no less, taken from the whole, than a floor at most what was taken is the floor. -/
theorem eq_of_sub_le_sub {z f low : Nat} (floor : low ≤ f) (le : f ≤ z) (ge : z - low ≤ z - f) : f = low :=
  have same : z - f = z - low := Nat.le_antisymm (sub_le_sub_left_of_le floor z) ge
  Naturals.add_left_cancel ((Naturals.sub_add_cancel le).trans
    ((Naturals.sub_add_cancel (Nat.le_trans floor le)).symm.trans (congrArg (· + low) same.symm)))

