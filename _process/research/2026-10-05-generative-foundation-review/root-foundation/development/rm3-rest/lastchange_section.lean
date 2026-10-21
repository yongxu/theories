/-! ### A law's run with a bounded mark

`settles_of_lpo` needs the limited principle of omniscience because a run of a process may change
again after any step. A run of a law is fixed by its law: where the law leaves a configuration as it
is, the run stays there, and whether it does is decided at each step. So where a quantity marks the
changes of the run and is bounded along it, the run comes to rest within the bound, with no
omniscience. -/

section LawRuns

variable {S : Type u} {next : S → S}

/-- Where the law leaves a configuration as it is, the run from it stays there. -/
theorem still_of_fixed {s : S} (fixed : next s = s) : StillFrom (Law.run next s) 0 :=
  have stays : ∀ n, Law.orbit next s n = s := fun n =>
    (congrArg (Law.orbit next s) (Nat.one_mul n)).symm.trans
      (Law.orbit_mul (next := next) (s := s) (p := 1) fixed n)
  fun k => (stays (0 + k + 1)).trans (stays (0 + k)).symm

/-- The run from the next configuration still from a step leaves the run still one step later. -/
theorem still_succ {s : S} {N : Nat} (still : StillFrom (Law.run next (next s)) N) :
    StillFrom (Law.run next s) (N + 1) := fun k => by
  show Law.orbit next s (N + 1 + k + 1) = Law.orbit next s (N + 1 + k)
  rw [Nat.add_right_comm N 1 k, Law.orbit_shift next s (N + k + 1), Law.orbit_shift next s (N + k)]
  exact still k

/-- **A law's run with a bounded mark comes to rest within the bound.** Where a quantity `q` marks
the changes of a law's run (it never falls along the run and rises wherever the configuration
changes) and stays at most `B` along it, and `B` is at most `d` above the mark at the start, the run
is still from some step at most `d`. Whether the law leaves a configuration as it is is decided at
each step, so no omniscience is needed: each change raises the mark by at least one, and the mark
has at most `d` to rise. -/
theorem still_within [DecidableEq S] {q : S → Nat} {B : Nat} :
    ∀ (d : Nat) (s : S), B ≤ d + q s → Marks q (Law.orbit next s) →
      (∀ n, q (Law.orbit next s n) ≤ B) → ∃ N, N ≤ d ∧ StillFrom (Law.run next s) N := by
  intro d
  induction d with
  | zero =>
    intro s fuel marks bounded
    refine ⟨0, Nat.le_refl 0, still_of_fixed ?_⟩
    exact Decidable.byContradiction fun moves =>
      have rises : q s < q (next s) := (marks 0).2 moves
      have top : B ≤ q s := Nat.le_trans fuel (Nat.le_of_eq (Nat.zero_add (q s)))
      Nat.lt_irrefl _ (Nat.lt_of_lt_of_le rises (Nat.le_trans (bounded 1) top))
  | succ d ih =>
    intro s fuel marks bounded
    exact if fixed : next s = s then ⟨0, Nat.zero_le _, still_of_fixed fixed⟩ else
      have rises : q s + 1 ≤ q (next s) := (marks 0).2 fixed
      have fuel' : B ≤ d + q (next s) :=
        Nat.le_trans fuel (Nat.le_trans
          (Nat.le_of_eq ((Nat.add_right_comm d 1 (q s)).trans (Nat.add_assoc d (q s) 1)))
          (Nat.add_le_add_left rises d))
      have shifted : ∀ n, Law.orbit next (next s) n = Law.orbit next s (n + 1) :=
        fun n => (Law.orbit_shift next s n).symm
      have marks' : Marks q (Law.orbit next (next s)) := fun n => by
        rw [shifted n, shifted (n + 1)]
        exact marks (n + 1)
      have ⟨N, le, still⟩ :=
        ih (next s) fuel' marks' (fun n => by rw [shifted n]; exact bounded (n + 1))
      ⟨N + 1, Nat.succ_le_succ le, still_succ still⟩

end LawRuns
