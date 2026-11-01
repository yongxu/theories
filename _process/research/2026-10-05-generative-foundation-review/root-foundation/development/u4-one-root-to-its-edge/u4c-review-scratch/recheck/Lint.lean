section S
variable (R : Nat → Nat → Prop)
variable {R} [∀ a b, Decidable (R a b)]
-- re-proved: instance omitted
omit [∀ a b, Decidable (R a b)] in
theorem base (h : ∀ a, R a a) : R 0 0 := h 0
-- a caller in the same section, statement unchanged
theorem caller (h : ∀ a, R a a) : R 0 0 := base h
end S
