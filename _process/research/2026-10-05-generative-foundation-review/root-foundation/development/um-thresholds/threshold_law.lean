/-- Leading runs of `true` agree for checks that agree. -/
theorem leading_congr {b b' : Nat → Bool} (same : ∀ x, b x = b' x) : ∀ k, leading b k = leading b' k
  | 0 => rfl
  | k + 1 => by
    show (if leading b k = k ∧ b k = true then k + 1 else leading b k) =
      (if leading b' k = k ∧ b' k = true then k + 1 else leading b' k)
    rw [leading_congr same k, same k]

/-- **The law of exact thresholds.** Where a reading `P` of levels is closed downward up to `hi` and a
check `d` is exact for it there, the levels up to `hi` the reading holds of are exactly those below
the leading run of `true` among `d`'s first `hi + 1` values. Every point of no return in this module
is this law for its own reading and check. -/
theorem leading_exact {P : Nat → Prop} {d : Nat → Bool} {hi : Nat}
    (down : ∀ a b, b ≤ hi → P b → a ≤ b → P a) (exact : ∀ a, a ≤ hi → (P a ↔ d a = true)) :
    ∀ a, a ≤ hi → (P a ↔ a < leading d (hi + 1)) :=
  fun a high =>
    ⟨fun holds => (Nat.lt_or_ge a (leading d (hi + 1))).elim id fun ge =>
        have short : leading d (hi + 1) < hi + 1 := Nat.lt_of_le_of_lt ge (Nat.lt_succ_of_le high)
        False.elim (Bool.noConfusion ((leading_false d (hi + 1) short).symm.trans
          ((exact _ (Nat.le_of_lt_succ short)).1 (down _ a high holds ge)))),
     fun lt => (exact a high).2 (leading_true d (hi + 1) a lt)⟩

/-- **A threshold falls with its reading.** Where checks `d` and `e` are exact up to `hi` for readings
`P` and `Q`, and `Q` implies `P` there, `e`'s threshold is no higher than `d`'s. -/
theorem leading_falls {P Q : Nat → Prop} {d e : Nat → Bool} {hi : Nat}
    (exactP : ∀ a, a ≤ hi → (P a ↔ d a = true)) (exactQ : ∀ a, a ≤ hi → (Q a ↔ e a = true))
    (implies : ∀ a, a ≤ hi → Q a → P a) : leading e (hi + 1) ≤ leading d (hi + 1) :=
  (Nat.lt_or_ge (leading d (hi + 1)) (leading e (hi + 1))).elim
    (fun lt =>
      have high : leading d (hi + 1) ≤ hi :=
        Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lt (leading_le e (hi + 1)))
      False.elim (Bool.noConfusion ((leading_false d (hi + 1) (Nat.lt_succ_of_le high)).symm.trans
        ((exactP _ high).1 (implies _ high ((exactQ _ high).2 (leading_true e (hi + 1) _ lt)))))))
    id

/-- **A check exact for the levels below `t` has threshold `t`**, where `t` is at most `hi + 1`: the
law of exact thresholds for the reading "below `t`". -/
theorem leading_eq {d : Nat → Bool} {hi t : Nat} (exact : ∀ a, a ≤ hi → (a < t ↔ d a = true))
    (reach : t ≤ hi + 1) : leading d (hi + 1) = t :=
  have same := leading_exact (P := fun a => a < t) (fun _ _ _ lt le => Nat.lt_of_le_of_lt le lt) exact
  Nat.le_antisymm
    ((Nat.lt_or_ge t (leading d (hi + 1))).elim
      (fun lt => absurd ((same t (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lt (leading_le d (hi + 1))))).2
        lt) (Nat.lt_irrefl t))
      id)
    ((Nat.lt_or_ge (leading d (hi + 1)) t).elim
      (fun lt => absurd ((same _ (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le lt reach))).1 lt) (Nat.lt_irrefl _))
      id)

