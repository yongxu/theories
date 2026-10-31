-- Init only. An order increasing in admission and asymmetric need not be transitive,
-- so transitivity is not part of what C (Increasing) asks.
namespace Skeptic
def IncludesOn (items : List Nat) (a b : Nat → Bool) : Prop := ∀ x, x ∈ items → b x = true → a x = true
def ExceedsOn (items : List Nat) (a b : Nat → Bool) : Prop := ∃ x, x ∈ items ∧ a x = true ∧ b x = false
def WidensOn (items : List Nat) (a b : Nat → Bool) : Prop := IncludesOn items a b ∧ ExceedsOn items a b
def Increasing (items : List Nat) (R : (Nat → Bool) → (Nat → Bool) → Prop) : Prop :=
  ∀ a b, WidensOn items a b → R b a
def items : List Nat := [0, 1, 2]
def one (k : Nat) : Nat → Bool := fun y => y == k
-- R b a: a ranked above b. Widening, plus a 3-cycle 0 < 1 < 2 < 0 on singletons.
def R (b a : Nat → Bool) : Prop :=
  WidensOn items a b ∨ (b = one 0 ∧ a = one 1) ∨ (b = one 1 ∧ a = one 2) ∨ (b = one 2 ∧ a = one 0)
theorem increasing : Increasing items R := fun _ _ w => .inl w
theorem not_widens (j k : Nat) (hk : k ∈ items) (hjk : j ≠ k) : ¬ WidensOn items (one j) (one k) :=
  fun ⟨inc, _⟩ => by
    have := inc k hk (by simp [one])
    simp [one] at this; exact hjk this.symm
theorem not_transitive : R (one 0) (one 1) ∧ R (one 1) (one 2) ∧ ¬ R (one 0) (one 2) := by
  refine ⟨.inr (.inl ⟨rfl, rfl⟩), .inr (.inr (.inl ⟨rfl, rfl⟩)), ?_⟩
  intro h
  rcases h with w | ⟨_, e⟩ | ⟨e, _⟩ | ⟨e, _⟩
  · exact not_widens 2 0 (by simp [items]) (by decide) w
  · have := congrFun e 2; simp [one] at this
  · have := congrFun e 0; simp [one] at this
  · have := congrFun e 0; simp [one] at this
end Skeptic
#print axioms Skeptic.not_transitive
