
/-- **Drawing at once, every perfect profile breaks at the first step every dependence above what
stands at nothing.** Where each portion returns less than one for one, along every perfect profile
over a horizon of at least one step, with no floor, the base stands at what stands at nothing after
the first step: a formation depending on it, whose need, met at the start, lies above that, is broken
there (`Optimum.AtOnce.drains`). -/
theorem at_once_broken {G : Nat → Nat → Nat} {portion rules : Nat → Nat → Nat → Nat} {k N s : Nat}
    (returns : Optimum.AtOnce.ReturnsLess G portion k N)
    (perfect : Optimum.AtOnce.Perfect G portion (fun _ _ _ => 0) rules k N)
    (follows : ∀ t, t ≤ N → W.level t c = Optimum.AtOnce.levels G portion rules k s t)
    (long : 0 < N) (depends : W.requires 0 f c) (low : G 0 0 < W.need 0 f c)
    (start : W.need 0 f c ≤ W.level 0 c) : W.Broken 0 f c :=
  ⟨depends, start, Nat.lt_of_le_of_lt (Nat.le_of_eq ((follows 1 long).trans
    (Optimum.AtOnce.levels_drained ((Optimum.AtOnce.drains returns).2 rules perfect) s long))) low⟩
