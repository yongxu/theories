
/-- **Leaving nothing ends the base at once.** Where both leave nothing at every step before `N`, from
every level, the base stands at what stands at nothing at every step from the first to the `N`-th. -/
theorem levels_of_zero (zeros : ∀ t, t < N → (∀ z, first t z = 0) ∧ ∀ a, second t a = 0) (s : Nat)
    {t : Nat} (before : t < N) : levels G first second s (t + 1) = G t 0 :=
  congrArg (G t) ((congrArg (second t) ((zeros t before).1 _)).trans ((zeros t before).2 0))

/-- Where both leave nothing at every step from `t` to the horizon, the second draws nothing over the
steps that remain. -/
theorem secondDrawn_of_zero {N : Nat}
    (zeros : ∀ u, t ≤ u → u < N → (∀ z, first u z = 0) ∧ ∀ a, second u a = 0) :
    ∀ j, t + j = N → ∀ w, secondDrawn G first second j t w = 0
  | 0, _, _ => rfl
  | j + 1, at_, w =>
    have now := zeros t (Nat.le_refl t) (Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right (Nat.succ_pos j))
      (Nat.le_of_eq at_))
    have later := secondDrawn_of_zero (t := t + 1) (N := N)
      (fun u le lt => zeros u (Nat.le_of_succ_le le) lt) j
      ((Nat.add_right_comm t 1 j).trans at_) (next G first second t w)
    show first t w - second t (first t w) + secondDrawn G first second j (t + 1) (next G first second t w) = 0
    by rw [now.1 w, now.2 0, later]

/-- **A revision.** The profile `first' second'` revises `first second` over a horizon of `N` steps
where each new rule leaves at most what it is given and, at every step from every level, is a best
response to the old profile: the second's to what follows under the old rules, the first's to the
old second at the step and what follows. -/
def Revises (G : Nat → Nat → Nat) (first second first' second' : Nat → Nat → Nat) (N : Nat) : Prop :=
  (∀ t z, first' t z ≤ z) ∧ (∀ t a, second' t a ≤ a) ∧
  ∀ t j, t + j + 1 = N →
    (∀ a b, b ≤ a → a - b + secondDrawn G first second j (t + 1) (G t b) ≤
      a - second' t a + secondDrawn G first second j (t + 1) (G t (second' t a))) ∧
    ∀ z a, a ≤ z → z - a + firstDrawn G first second j (t + 1) (G t (second t a)) ≤
      z - first' t z + firstDrawn G first second j (t + 1) (G t (second t (first' t z)))

/-- **Revising from the horizon back, both come to leave nothing.** Along every sequence of profiles
each revising the one before over a horizon of `N` steps, at every round from `2 k` on both leave
nothing at every step of the last `k` before the horizon, from every level, whatever the profile they
started from. -/
theorem revisions_end {fs ss : Nat → Nat → Nat → Nat} {N : Nat}
    (rev : ∀ m, Revises G (fs m) (ss m) (fs (m + 1)) (ss (m + 1)) N) :
    ∀ k t, t + k = N → ∀ m, 2 * k ≤ m → ∀ u, t ≤ u → u < N →
      (∀ z, fs m u z = 0) ∧ ∀ a, ss m u a = 0
  | 0, t, at_, _, _, u, le, lt => absurd (Nat.lt_of_lt_of_le lt (Nat.le_of_eq at_.symm))
      (Nat.not_lt_of_ge le)
  | k + 1, t, at_, m, enough, u, le, lt =>
    have here : t + k + 1 = N := (Nat.add_assoc t k 1).trans at_
    have later := revisions_end rev k (t + 1) ((Nat.add_right_comm t 1 k).trans here)
    -- From round `2 k + 1` on, the second leaves nothing at `t`.
    have sec : ∀ m', 2 * k + 1 ≤ m' → ∀ a, ss m' t a = 0 := fun m' big a =>
      match m', big with
      | m'' + 1, big =>
        have none := secondDrawn_of_zero (t := t + 1) (N := N)
          (fun u le' lt' => later m'' (Nat.le_of_succ_le_succ big) u le' lt') k
          ((Nat.add_right_comm t 1 k).trans here)
        have best := ((rev m'').2.2 t k here).1 a 0 (Nat.zero_le a)
        zero_of_le_sub ((rev m'').2.1 t a) (Nat.le_trans (Nat.le_of_eq (by rw [none, Nat.sub_zero,
          Nat.add_zero])) (Nat.le_trans best (Nat.le_of_eq (by rw [none, Nat.add_zero]))))
    -- From round `2 k + 2` on, the first leaves nothing at `t`.
    have fst : ∀ m', 2 * k + 2 ≤ m' → ∀ z, fs m' t z = 0 := fun m' big z =>
      match m', big with
      | m'' + 1, big =>
        have old := sec m'' (Nat.le_of_succ_le_succ big)
        have best := ((rev m'').2.2 t k here).2 z 0 (Nat.zero_le z)
        zero_of_le_sub ((rev m'').1 t z) (Naturals.le_of_add_le_add_right
          (Nat.le_trans (Nat.le_of_eq (congrArg (· + _) (Nat.sub_zero z).symm))
            (Nat.le_trans best (Nat.le_of_eq (by rw [old, old])))))
    match Nat.lt_or_ge t u with
    | .inl after => later m (Nat.le_trans (Nat.mul_le_mul_left 2 (Nat.le_succ k)) enough) u after lt
    | .inr before =>
      have same : u = t := Nat.le_antisymm before le
      have two : 2 * (k + 1) = 2 * k + 2 := Nat.mul_succ 2 k
      ⟨fun z => same ▸ fst m (Nat.le_trans (Nat.le_of_eq two.symm) enough) z,
       fun a => same ▸ sec m (Nat.le_trans (Nat.le_succ _) (Nat.le_trans (Nat.le_of_eq two.symm) enough)) a⟩

/-- The first of `0, …, z` at which `f` is greatest among them. -/
def bestUpTo (f : Nat → Nat) : Nat → Nat
  | 0 => 0
  | z + 1 => if f (bestUpTo f z) < f (z + 1) then z + 1 else bestUpTo f z

theorem bestUpTo_le (f : Nat → Nat) : ∀ z, bestUpTo f z ≤ z
  | 0 => Nat.le_refl 0
  | z + 1 => by
    show (if f (bestUpTo f z) < f (z + 1) then z + 1 else bestUpTo f z) ≤ z + 1
    exact if h : f (bestUpTo f z) < f (z + 1) then by rw [if_pos h]; exact Nat.le_refl _
      else by rw [if_neg h]; exact Nat.le_succ_of_le (bestUpTo_le f z)

/-- **The greatest of finitely many.** No value of `f` at `0, …, z` exceeds its value at `bestUpTo f z`. -/
theorem bestUpTo_max (f : Nat → Nat) : ∀ z a, a ≤ z → f a ≤ f (bestUpTo f z)
  | 0, a, le => Nat.le_of_eq (congrArg f (Nat.le_antisymm le (Nat.zero_le a)))
  | z + 1, a, le => by
    show f a ≤ f (if f (bestUpTo f z) < f (z + 1) then z + 1 else bestUpTo f z)
    exact if h : f (bestUpTo f z) < f (z + 1) then by
        rw [if_pos h]
        exact match le_or_eq_succ le with
          | .inl earlier => Nat.le_of_lt (Nat.lt_of_le_of_lt (bestUpTo_max f z a earlier) h)
          | .inr last => Nat.le_of_eq (congrArg f last)
      else by
        rw [if_neg h]
        exact match le_or_eq_succ le with
          | .inl earlier => bestUpTo_max f z a earlier
          | .inr last => Nat.le_trans (Nat.le_of_eq (congrArg f last)) (Nat.ge_of_not_lt h)

/-- The second's revision: of what the first leaves, the first amount it may leave that draws it the
most over the rest, the old rules following. -/
def reviseSecond (G : Nat → Nat → Nat) (first second : Nat → Nat → Nat) (N t a : Nat) : Nat :=
  bestUpTo (fun b => a - b + secondDrawn G first second (N - t - 1) (t + 1) (G t b)) a

/-- The first's revision: of the level, the first amount it may leave that draws it the most over the
rest, the old second responding. -/
def reviseFirst (G : Nat → Nat → Nat) (first second : Nat → Nat → Nat) (N t z : Nat) : Nat :=
  bestUpTo (fun a => z - a + firstDrawn G first second (N - t - 1) (t + 1) (G t (second t a))) z

/-- **A revision always exists.** Taking at every step from every level the first amount that draws
the most, against the old profile, revises it. -/
theorem revise_revises (G : Nat → Nat → Nat) (first second : Nat → Nat → Nat) (N : Nat) :
    Revises G first second (reviseFirst G first second N) (reviseSecond G first second N) N :=
  ⟨fun t z => bestUpTo_le _ z, fun t a => bestUpTo_le _ a, fun t j at_ =>
    have steps : N - t - 1 = j := by rw [← at_, Nat.add_assoc, Naturals.add_sub_cancel_left]; rfl
    ⟨fun a b le => by
      show a - b + secondDrawn G first second j (t + 1) (G t b) ≤
        a - reviseSecond G first second N t a +
          secondDrawn G first second j (t + 1) (G t (reviseSecond G first second N t a))
      have h := bestUpTo_max (fun b => a - b + secondDrawn G first second (N - t - 1) (t + 1) (G t b)) a b le
      rw [← steps]
      exact h,
     fun z a le => by
      show z - a + firstDrawn G first second j (t + 1) (G t (second t a)) ≤
        z - reviseFirst G first second N t z +
          firstDrawn G first second j (t + 1) (G t (second t (reviseFirst G first second N t z)))
      have h := bestUpTo_max
        (fun a => z - a + firstDrawn G first second (N - t - 1) (t + 1) (G t (second t a))) z a le
      rw [← steps]
      exact h⟩⟩

/-- The profiles of successive revisions from `first second`. -/
def revised (G : Nat → Nat → Nat) (N : Nat) (first second : Nat → Nat → Nat) :
    Nat → (Nat → Nat → Nat) × (Nat → Nat → Nat)
  | 0 => (first, second)
  | m + 1 => (reviseFirst G (revised G N first second m).1 (revised G N first second m).2 N,
      reviseSecond G (revised G N first second m).1 (revised G N first second m).2 N)

/-- **Revising toward best responses, drawers in turn come to drawing everything.** From every profile,
at every round of revision from `2 N` on both leave nothing at every step before the horizon, from
every level: the perfect profile of drawing everything (`perfect_of_zero`) is reached within twice
the horizon, and the base stands from the first step at what stands at nothing. -/
theorem revised_draw_all (G : Nat → Nat → Nat) (N : Nat) (first second : Nat → Nat → Nat) {m : Nat}
    (enough : 2 * N ≤ m) :
    (∀ t, t < N → (∀ z, (revised G N first second m).1 t z = 0) ∧
      ∀ a, (revised G N first second m).2 t a = 0) ∧
    ∀ s t, t < N → levels G (revised G N first second m).1 (revised G N first second m).2 s (t + 1) =
      G t 0 :=
  have zeros : ∀ t, t < N → (∀ z, (revised G N first second m).1 t z = 0) ∧
      ∀ a, (revised G N first second m).2 t a = 0 := fun t lt =>
    revisions_end (fs := fun m => (revised G N first second m).1)
      (ss := fun m => (revised G N first second m).2)
      (fun m => revise_revises G (revised G N first second m).1 (revised G N first second m).2 N)
      N 0 (Nat.zero_add N) m enough t (Nat.zero_le t) lt
  ⟨zeros, fun s _ lt => levels_of_zero zeros s lt⟩
