/-- **Where the first drawer leaves nothing, every dependence on the base above what stands at nothing
is broken at the first step.** Along a profile of drawers in turn, each leaving at most what it is
given, whose first drawer leaves nothing at every step before a horizon of at least one step, the
base stands from the first step at what stands at nothing: a formation depending on it, whose need,
met at the start, lies above what stands at nothing at the first step, is broken there. Every
perfect profile of two or more drawers (`Optimum.InTurn.perfect_ends`) and every profile revised from
round `2 N` on (`Optimum.InTurn.revised_draw_all`) is such a profile. -/
theorem drained_broken {G : Nat → Nat → Nat} {rules : Nat → Nat → Nat → Nat} {k N s : Nat} (one : 1 ≤ k)
    (leaves : ∀ d t a, rules d t a ≤ a) (first : ∀ t, t < N → ∀ a, rules 0 t a = 0)
    (follows : ∀ t, t ≤ N → W.level t c = Optimum.InTurn.levels G rules k s t)
    (long : 0 < N) (depends : W.requires 0 f c) (low : G 0 0 < W.need 0 f c)
    (start : W.need 0 f c ≤ W.level 0 c) :
    W.Broken 0 f c ∧ ∀ t, t < N → W.level (t + 1) c = G t 0 :=
  have stands : ∀ t, t < N → W.level (t + 1) c = G t 0 := fun t before =>
    (follows (t + 1) before).trans (Optimum.InTurn.levels_of_first one leaves first s before)
  ⟨⟨depends, start, Nat.lt_of_le_of_lt (Nat.le_of_eq (stands 0 long)) low⟩, stands⟩
