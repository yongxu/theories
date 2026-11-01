theorem base {R : Nat → Nat → Prop} (h : ∀ a, R a a) : R 0 0 := h 0
-- a caller in another module whose own signature takes the instance
theorem caller2 {R : Nat → Nat → Prop} [∀ a b, Decidable (R a b)] (h : ∀ a, R a a) : R 0 0 := base h
