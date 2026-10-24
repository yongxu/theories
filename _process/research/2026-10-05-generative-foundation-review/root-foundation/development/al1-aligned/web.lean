
/-- **Drawing at once, where no portion returns more than one for one, drawing everything is perfect
and breaks at the first step every dependence above what stands at nothing.** Where, at every step
before the last, no drawer's portion of what stands next returns more than one for one on what it
alone leaves while the others draw everything, the profile drawing everything is perfect
(`Optimum.AtOnce.drain_perfect_iff`); along it, over a horizon of at least one step, a formation
depending on the base, whose need, met at the start, lies above what stands at nothing at the first
step, is broken there. -/
theorem drain_perfect_broken {G : Nat → Nat → Nat} {portion : Nat → Nat → Nat → Nat} {k N s : Nat}
    (returns : ∀ d, d < k → ∀ t, t + 1 < N → ∀ z b, b ≤ portion d t z →
      portion d (t + 1) (G t b) ≤ portion d (t + 1) (G t 0) + b)
    (follows : ∀ t, t ≤ N → W.level t c = Optimum.AtOnce.levels G portion (fun _ _ _ => 0) k s t)
    (long : 0 < N) (depends : W.requires 0 f c) (low : G 0 0 < W.need 0 f c)
    (start : W.need 0 f c ≤ W.level 0 c) :
    Optimum.AtOnce.Perfect G portion (fun _ _ _ => 0) (fun _ _ _ => 0) k N ∧ W.Broken 0 f c :=
  ⟨Optimum.AtOnce.drain_perfect_iff.2 returns,
   ⟨depends, start, Nat.lt_of_le_of_lt (Nat.le_of_eq ((follows 1 long).trans
     (Optimum.AtOnce.levels_drained (N := N) (fun _ _ _ _ _ => rfl) s long))) low⟩⟩

/-- **Where each portion returns less than one for one, what the drain breaks pays no drawer.** Along
every perfect profile over a horizon of at least one step, a dependence on the base above what stands
at nothing, met at the start, is broken at the first step (`at_once_broken`), and along no profile
whatever does any drawer draw more over the horizon than where every drawer draws everything
(`Optimum.AtOnce.drain_most`): keeping the dependence would pay none of them. -/
theorem at_once_beyond {G : Nat → Nat → Nat} {portion rules : Nat → Nat → Nat → Nat} {k N s : Nat}
    (returns : Optimum.AtOnce.ReturnsLess G portion k N)
    (perfect : Optimum.AtOnce.Perfect G portion (fun _ _ _ => 0) rules k N)
    (follows : ∀ t, t ≤ N → W.level t c = Optimum.AtOnce.levels G portion rules k s t)
    (long : 0 < N) (depends : W.requires 0 f c) (low : G 0 0 < W.need 0 f c)
    (start : W.need 0 f c ≤ W.level 0 c) :
    W.Broken 0 f c ∧ ∀ rules' : Nat → Nat → Nat → Nat, ∀ d, d < k → ∀ z,
      Optimum.AtOnce.drawn G portion rules' k d N 0 z ≤
        Optimum.AtOnce.drawn G portion (fun _ _ _ => 0) k d N 0 z :=
  ⟨at_once_broken returns perfect follows long depends low start,
   fun _ _ dk => Optimum.AtOnce.drain_most returns dk N 0 (Nat.zero_add N)⟩

/-- **One drawer given the whole drains where the whole never returns more than one for one, and the
drain still breaks what depends on the base.** For a single drawer whose portion is all that stands,
where at every step before the last what stands from any amount left is at most what stands from
nothing and that amount, drawing everything is perfect (`Optimum.AtOnce.whole_perfect_iff`); along
it a formation depending on the base, whose need, met at the start, lies above what stands at nothing
at the first step, is broken there. Counting the whole of what is drawn does not count what depends
on what is left. -/
theorem whole_drain_broken {G : Nat → Nat → Nat} {N s : Nat}
    (whole : ∀ t, t + 1 < N → ∀ b, G t b ≤ G t 0 + b)
    (follows : ∀ t, t ≤ N → W.level t c = Optimum.AtOnce.levels G (fun _ _ z => z) (fun _ _ _ => 0) 1 s t)
    (long : 0 < N) (depends : W.requires 0 f c) (low : G 0 0 < W.need 0 f c)
    (start : W.need 0 f c ≤ W.level 0 c) :
    Optimum.AtOnce.Perfect G (fun _ _ z => z) (fun _ _ _ => 0) (fun _ _ _ => 0) 1 N ∧ W.Broken 0 f c :=
  ⟨Optimum.AtOnce.whole_perfect_iff.2 whole,
   (drain_perfect_broken (Optimum.AtOnce.drain_perfect_iff.1 (Optimum.AtOnce.whole_perfect_iff.2 whole))
     follows long depends low start).2⟩
