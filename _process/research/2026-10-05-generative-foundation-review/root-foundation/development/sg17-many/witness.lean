
/-- **The gate witness, any number of drawers.** From a source at two, under a gate renewing one unit
at every level from one, drawing everything is perfect for every number of drawers in turn from two,
and every perfect profile of them breaks the dweller at the first step. -/
theorem gated_turns (n : Nat) {k : Nat} (two : 2 ≤ k) :
    InTurn.Many.Perfect (fun _ z => z + gate z) (fun _ _ _ => 0) k (n + 2) ∧
      ∀ rules, InTurn.Many.Perfect (fun _ z => z + gate z) rules k (n + 2) →
        (web (onSource (InTurn.Many.levels (fun _ z => z + gate z) rules k 2))).Broken 0 .dweller .source :=
  ⟨InTurn.Many.perfect_of_zero two (n + 2), fun rules perfect =>
    (Web.turns_broken (W := web (onSource (InTurn.Many.levels (fun _ z => z + gate z) rules k 2)))
      (c := Place.source) (f := Formation.dweller) two perfect (fun _ _ => rfl) (Nat.succ_pos (n + 1))
      trivial (Nat.succ_pos 1) (Nat.le_refl 2)).1⟩
