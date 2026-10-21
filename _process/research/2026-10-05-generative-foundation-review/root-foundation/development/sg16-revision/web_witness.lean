
/-- **Revising toward best responses breaks at the first step every dependence above what stands at
nothing.** From every profile of two drawers in turn, along the profile reached by `2 N` or more
rounds of revision over a horizon of at least one step, a formation depending on the base, whose need,
met at the start, lies above what stands at nothing at the first step, is broken there. -/
theorem revised_broken {G first second : Nat → Nat → Nat} {N s m : Nat} (enough : 2 * N ≤ m)
    (follows : ∀ t, t ≤ N → W.level t c = Optimum.InTurn.levels G
      (Optimum.InTurn.revised G N first second m).1 (Optimum.InTurn.revised G N first second m).2 s t)
    (long : 0 < N) (depends : W.requires 0 f c) (low : G 0 0 < W.need 0 f c)
    (start : W.need 0 f c ≤ W.level 0 c) : W.Broken 0 f c :=
  ⟨depends, start, Nat.lt_of_le_of_lt (Nat.le_of_eq ((follows 1 long).trans
    ((Optimum.InTurn.revised_draw_all G N first second enough).2 s 0 long))) low⟩
