import Becoming.Presence

/-! Probes of the UE14 re-check: not for landing. -/

namespace Becoming

namespace Presence

namespace Recheck

open CausalGrowth (Causet)

/-- `past_every_iff` from left to right, asked of every causal set, is exactly excluded middle:
`past_every_needs_decision` with its converse. -/
theorem past_every_iff_em :
    (∀ c : Causet, c.Ordered → ∀ x y, x < c.size → y < c.size →
      (∀ π σ, NaturalLabelling c π σ → π y ≤ π x) → y = x ∨ c.prec y x) ↔ ∀ p : Prop, Decided p :=
  ⟨past_every_needs_decision,
   fun em c ordered x y hx hy every => match Nat.decEq y x with
   | .isTrue same => .inl same
   | .isFalse ne => .inr (every_iff_em.mpr em c ordered y x hy hx fun π σ natural =>
       match Nat.eq_or_lt_of_le (every π σ natural) with
       | .inl same =>
         absurd (((natural.at hy).2.symm.trans (congrArg σ same)).trans (natural.at hx).2) ne
       | .inr lt => lt)⟩

/-- On the vee, `1` and `2` have the same future (none) and the same past (`0`). -/
theorem vee_future_one_two (k : Nat) : Vee.vee.prec 1 k ↔ Vee.vee.prec 2 k :=
  ⟨fun pair => absurd pair.1 (by decide), fun pair => absurd pair.1 (by decide)⟩

theorem vee_past_one_two (k : Nat) : Vee.vee.prec k 1 ↔ Vee.vee.prec k 2 :=
  ⟨fun pair => ⟨pair.1, .inr rfl⟩, fun pair => ⟨pair.1, .inl rfl⟩⟩

/-- The past with the vee's pair `1`, `2`. -/
def VeePastOrPair (a b : Nat) : Prop :=
  a = b ∨ Vee.vee.prec b a ∨ (a = 1 ∧ b = 2) ∨ (a = 2 ∧ b = 1)

instance (a b : Nat) : Decidable (VeePastOrPair a b) :=
  inferInstanceAs (Decidable (a = b ∨ Vee.vee.prec b a ∨ (a = 1 ∧ b = 2) ∨ (a = 2 ∧ b = 1)))

/-- **Off the diamond the join can be the past with its pair**: on the vee the past joined with
being present together on every course is exactly the past with `1` and `2`, which share their past
and their future. -/
theorem vee_pastOrTogether_iff {a b : Nat} (ha : a < 3) (hb : b < 3) :
    PastOrTogether Vee.vee a b ↔ VeePastOrPair a b := by
  constructor
  · intro h
    rcases h with p | every
    · exact .inr (.inl p)
    · have same := (together_every_iff Vee.ordered ha hb).mp every
      have f0 := same 0
      have f1 := same 1
      have f2 := same 2
      revert f0 f1 f2
      rcases below_three ha with rfl | rfl | rfl <;>
      rcases below_three hb with rfl | rfl | rfl <;> decide
  · intro pair
    rcases pair with e | p | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
    · exact .inr ((together_every_iff Vee.ordered ha hb).mpr fun k =>
        Eq.subst (motive := fun z => Vee.vee.prec a k ↔ Vee.vee.prec z k) e Iff.rfl)
    · exact .inl p
    · exact .inr ((together_every_iff Vee.ordered ha hb).mpr vee_future_one_two)
    · exact .inr ((together_every_iff Vee.ordered ha hb).mpr fun k => (vee_future_one_two k).symm)

end Recheck

end Presence

end Becoming
