/-- **Drawers in turn, any number from two, break at the first step every dependence on the base above
what stands at nothing.** Along every profile of `k ≥ 2` drawers in turn perfect over a horizon of at
least one step the base stands at what stands at nothing from the first step on: a formation depending
on it, whose need, met at the start, lies above what stands at nothing at the first step, is broken
there. -/
theorem turns_broken {G : Nat → Nat → Nat} {rules : Nat → Nat → Nat → Nat} {k N s : Nat} (two : 2 ≤ k)
    (perfect : Optimum.InTurn.Many.Perfect G rules k N)
    (follows : ∀ t, t ≤ N → W.level t c = Optimum.InTurn.Many.levels G rules k s t)
    (long : 0 < N) (depends : W.requires 0 f c) (low : G 0 0 < W.need 0 f c)
    (start : W.need 0 f c ≤ W.level 0 c) :
    W.Broken 0 f c ∧ ∀ t, t < N → W.level (t + 1) c = G t 0 :=
  have stands : ∀ t, t < N → W.level (t + 1) c = G t 0 := fun t before =>
    (follows (t + 1) before).trans (Optimum.InTurn.Many.perfect_levels two perfect s before)
  ⟨⟨depends, start, Nat.lt_of_le_of_lt (Nat.le_of_eq (stands 0 long)) low⟩, stands⟩

