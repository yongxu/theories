/-- Of nothing, drawers who leave at most what they are given leave nothing. -/
theorem pass_zero (leaves : ∀ d t a, rules d t a ≤ a) (t : Nat) : ∀ d c, pass rules t d c 0 = 0
  | _, 0 => rfl
  | d, c + 1 => (congrArg (pass rules t (d + 1) c) (Nat.eq_zero_of_le_zero (leaves d t 0))).trans
      (pass_zero leaves t (d + 1) c)

/-- **Through a drawer that leaves nothing, nothing passes.** Where drawer `u` leaves nothing at `t`,
drawers `d, …, d + c - 1`, `u` among them, leave nothing of whatever they are given. -/
theorem pass_through (leaves : ∀ d t a, rules d t a ≤ a) {t u : Nat} (none : ∀ a, rules u t a = 0) :
    ∀ c d b, d ≤ u → u < d + c → pass rules t d c b = 0
  | 0, d, _, le, lt => absurd (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.add_zero d))) (Nat.not_lt_of_ge le)
  | c + 1, d, b, le, lt => (Nat.lt_or_ge d u).elim
      (fun dlt => pass_through leaves none c (d + 1) (rules d t b) dlt
        (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.add_right_comm d 1 c).symm)))
      (fun dge => (congrArg (pass rules t (d + 1) c)
        ((congrArg (fun x => rules x t b) (Nat.le_antisymm le dge)).trans (none b))).trans (pass_zero leaves t (d + 1) c))

/-- **After a drawer that leaves nothing, the others draw nothing.** Where drawer `u` leaves nothing at
every step from `t` to the horizon, every drawer after it draws nothing over the steps that remain. -/
theorem after_draw_nothing (leaves : ∀ d t a, rules d t a ≤ a) {t u : Nat}
    (zero : ∀ s, t ≤ s → s < N → ∀ a, rules u s a = 0) :
    ∀ j, t + j = N → ∀ d, u < d → ∀ w, drawn G rules k d j t w = 0
  | 0, _, _, _, _ => rfl
  | j + 1, at_, d, lt, w => by
    have now : ∀ a, rules u t a = 0 := zero t (Nat.le_refl t)
      (Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right (Nat.succ_pos j)) (Nat.le_of_eq at_))
    show pass rules t 0 d w - rules d t (pass rules t 0 d w) +
      drawn G rules k d j (t + 1) (next G rules k t w) = 0
    rw [pass_through leaves now d 0 w (Nat.zero_le u) (Nat.lt_of_lt_of_le lt (Nat.le_of_eq (Nat.zero_add d).symm)),
      after_draw_nothing leaves (t := t + 1) (fun s le lt' => zero s (Nat.le_of_succ_le le) lt') j
        ((Nat.add_right_comm t 1 j).trans at_) d lt, Nat.zero_sub]

/-- **A drawer after one that leaves nothing later draws to capacity.** In a revision, where drawer `u`
of the profile revised leaves nothing at every step after `t`, every drawer after `u` leaves its
floor at `t`: nothing it keeps comes back to it. -/
theorem floor_after (rev : Revises G low rules rules' k N) (leaves : ∀ d t a, rules d t a ≤ a) {t j u : Nat}
    (at_ : t + j + 1 = N) (zero : ∀ s, t + 1 ≤ s → s < N → ∀ a, rules u s a = 0) {d : Nat} (lt : u < d)
    (dk : d < k) (a : Nat) : rules' d t a = low d t a :=
  have none := after_draw_nothing (G := G) (k := k) leaves (t := t + 1) zero j ((Nat.add_right_comm t 1 j).trans at_) d lt
  at_floor rev at_ dk a ((none _).trans (none _).symm)

/-- **A drawer before one that leaves nothing draws to capacity.** In a revision, where drawer `w` of
the profile revised leaves nothing at `t`, every drawer before `w` leaves its floor at `t`: what it
keeps passes through `w`. -/
theorem floor_through (rev : Revises G low rules rules' k N) (leaves : ∀ d t a, rules d t a ≤ a) {t j w : Nat}
    (at_ : t + j + 1 = N) (zero : ∀ a, rules w t a = 0) (wk : w < k) {d : Nat} (dw : d < w) (a : Nat) :
    rules' d t a = low d t a :=
  have dk : d < k := Nat.lt_trans dw wk
  have through : ∀ b, pass rules t (d + 1) (k - (d + 1)) b = 0 := fun b =>
    pass_through leaves zero (k - (d + 1)) (d + 1) b dw
      (Nat.lt_of_lt_of_le wk (Nat.le_of_eq (Becoming.add_sub_of_le dk).symm))
  at_floor rev at_ dk a (by
    show drawn G rules k d j (t + 1) (G t (pass rules t (d + 1) (k - (d + 1)) _)) =
      drawn G rules k d j (t + 1) (G t (pass rules t (d + 1) (k - (d + 1)) _))
    rw [through, through])

/-- **Revising from the horizon back, every drawer comes to its floor.** Where two drawers `u < v`
have no floor, along every sequence of profiles each revising the one before over `N` steps, at
every round from `p c` on every drawer leaves its floor at every step of the last `c`, from every
level, whatever profile they started from, where `p` is at least three, or two where `u` is the first
drawer: after `u` nothing returns once `u` leaves nothing later, `u`'s keeping passes through `v`,
and before `u` everything passes through `u`. -/
theorem revisions_reach_floors {fs : Nat → Nat → Nat → Nat → Nat} {u v p : Nat} (uv : u < v) (vk : v < k)
    (freeU : ∀ t a, low u t a = 0) (freeV : ∀ t a, low v t a = 0) (two : 2 ≤ p) (rounds : u = 0 ∨ 3 ≤ p)
    (leaves : ∀ m d t a, fs m d t a ≤ a) (rev : ∀ m, Revises G low (fs m) (fs (m + 1)) k N) :
    ∀ c t, t + c = N → ∀ m, p * c ≤ m → ∀ s, t ≤ s → s < N → ∀ d, d < k → ∀ a, fs m d s a = low d s a
  | 0, _, at_, _, _, _, le, lt => absurd (Nat.lt_of_lt_of_le lt (Nat.le_of_eq at_.symm))
      (Nat.not_lt_of_ge le)
  | c + 1, t, at_, m, enough, s, le, lt =>
    have here : t + c + 1 = N := (Nat.add_assoc t c 1).trans at_
    have after : t + 1 + c = N := (Nat.add_right_comm t 1 c).trans here
    have later_ := revisions_reach_floors uv vk freeU freeV two rounds leaves rev c (t + 1) after
    have uk : u < k := Nat.lt_trans uv vk
    have uLater : ∀ m', p * c ≤ m' → ∀ s', t + 1 ≤ s' → s' < N → ∀ a, fs m' u s' a = 0 :=
      fun m' big s' le' lt' a => (later_ m' big s' le' lt' u uk a).trans (freeU s' a)
    -- From round `p c + 1` on, every drawer after `u` leaves its floor at `t`.
    have stageA : ∀ m', p * c + 1 ≤ m' → ∀ d, u < d → d < k → ∀ a, fs m' d t a = low d t a :=
      fun m' big _ ud dk a => match m', big with
      | m'' + 1, big => floor_after (rev m'') (leaves m'') here (uLater m'' (Nat.le_of_succ_le_succ big)) ud dk a
    -- From round `p c + 2` on, `u` leaves nothing at `t`.
    have stageB : ∀ m', p * c + 2 ≤ m' → ∀ a, fs m' u t a = 0 := fun m' big a => match m', big with
      | m'' + 1, big =>
        (floor_through (rev m'') (leaves m'') here
          (fun b => (stageA m'' (Nat.le_of_succ_le_succ big) v uv vk b).trans (freeV t b)) vk uv a).trans (freeU t a)
    -- From round `p c + 3` on, every drawer before `u` leaves its floor at `t`.
    have stageC : ∀ m', p * c + 3 ≤ m' → ∀ d, d < u → ∀ a, fs m' d t a = low d t a :=
      fun m' big _ du a => match m', big with
      | m'' + 1, big => floor_through (rev m'') (leaves m'') here (stageB m'' (Nat.le_of_succ_le_succ big)) uk du a
    have full : p * (c + 1) = p * c + p := Nat.mul_succ p c
    match Nat.lt_or_ge t s with
    | .inl later' => later_ m (Nat.le_trans (Nat.mul_le_mul_left p (Nat.le_succ c)) enough) s later' lt
    | .inr before =>
      have same : s = t := Nat.le_antisymm before le
      fun d dk a => same ▸ match Nat.lt_trichotomy d u with
        | .inr (.inr ud) => stageA m (Nat.le_trans (Nat.add_le_add_left (Nat.le_trans (Nat.le_succ 1) two) _)
            (Nat.le_trans (Nat.le_of_eq full.symm) enough)) d ud dk a
        | .inr (.inl du) => (congrArg (fun x => fs m x t a) du).trans ((stageB m (Nat.le_trans
            (Nat.add_le_add_left two _) (Nat.le_trans (Nat.le_of_eq full.symm) enough)) a).trans
            ((freeU t a).symm.trans (congrArg (fun x => low x t a) du.symm)))
        | .inl du => match rounds with
          | .inl zero => absurd (zero ▸ du) (Nat.not_lt_zero d)
          | .inr three => stageC m (Nat.le_trans (Nat.add_le_add_left three _)
              (Nat.le_trans (Nat.le_of_eq full.symm) enough)) d du a

/-- **Where two drawers have no floor, every perfect profile is the floor profile.** Along every profile
perfect over `N` steps in which two drawers have no floor, whatever floors the others have, every
drawer leaves exactly its floor at every step before the horizon, from every level: a perfect profile
is its own sequence of revisions. With no floor anywhere every drawer leaves nothing. -/
theorem perfect_at_floors {u v : Nat} (uv : u < v) (vk : v < k) (freeU : ∀ t a, low u t a = 0)
    (freeV : ∀ t a, low v t a = 0) (perfect : Perfect G low rules k N) {t : Nat} (before : t < N) :
    ∀ d, d < k → ∀ a, rules d t a = low d t a :=
  revisions_reach_floors (fs := fun _ => rules) (p := 3) uv vk freeU freeV (Nat.le_succ 2) (.inr (Nat.le_refl 3))
    (fun _ d t a => (perfect.1 d t a).2) (fun _ => perfect) N 0 (Nat.zero_add N) (3 * N) (Nat.le_refl _) t
    (Nat.zero_le t) before

/-- **Where a drawer leaves nothing, the base stands at what stands at nothing**, from the first step
to the `N`-th. -/
theorem levels_through (leaves : ∀ d t a, rules d t a ≤ a) {u : Nat} (uk : u < k)
    (zero : ∀ t, t < N → ∀ a, rules u t a = 0) (s : Nat) {t : Nat} (before : t < N) :
    levels G rules k s (t + 1) = G t 0 :=
  congrArg (G t) (pass_through leaves (zero t before) k 0 _ (Nat.zero_le u)
    (Nat.lt_of_lt_of_le uk (Nat.le_of_eq (Nat.zero_add k).symm)))

/-- **Where two drawers have no floor, leaving the floor is perfect.** -/
theorem floors_perfect {u v : Nat} (uv : u < v) (vk : v < k) (floors : ∀ d t a, low d t a ≤ a)
    (freeU : ∀ t a, low u t a = 0) (freeV : ∀ t a, low v t a = 0) (N : Nat) : Perfect G low low k N :=
  ⟨fun d t a => ⟨Nat.le_refl _, floors d t a⟩, fun t j at_ d dk a b floor _ =>
    have uk : u < k := Nat.lt_trans uv vk
    have same : later G low k d j t b = later G low k d j t (low d t a) :=
      match Nat.lt_trichotomy d u with
      | .inr (.inr ud) =>
        have none := after_draw_nothing (G := G) (k := k) floors (t := t + 1) (N := N)
          (fun s _ _ a' => freeU s a') j ((Nat.add_right_comm t 1 j).trans at_) d ud
        (none _).trans (none _).symm
      | .inr (.inl du) =>
        have through : ∀ b', pass low t (d + 1) (k - (d + 1)) b' = 0 := fun b' =>
          pass_through floors (freeV t) (k - (d + 1)) (d + 1) b' (Eq.subst (motive := fun x => x < v) du.symm uv)
            (Nat.lt_of_lt_of_le vk (Nat.le_of_eq (Becoming.add_sub_of_le dk).symm))
        by
          show drawn G low k d j (t + 1) (G t (pass low t (d + 1) (k - (d + 1)) b)) =
            drawn G low k d j (t + 1) (G t (pass low t (d + 1) (k - (d + 1)) (low d t a)))
          rw [through, through]
      | .inl du =>
        have through : ∀ b', pass low t (d + 1) (k - (d + 1)) b' = 0 := fun b' =>
          pass_through floors (freeU t) (k - (d + 1)) (d + 1) b' du
            (Nat.lt_of_lt_of_le uk (Nat.le_of_eq (Becoming.add_sub_of_le dk).symm))
        by
          show drawn G low k d j (t + 1) (G t (pass low t (d + 1) (k - (d + 1)) b)) =
            drawn G low k d j (t + 1) (G t (pass low t (d + 1) (k - (d + 1)) (low d t a)))
          rw [through, through]
    Nat.le_trans (Nat.add_le_add_right (sub_le_sub_left_of_le floor a) _)
      (Nat.le_of_eq (congrArg (a - low d t a + ·) same))⟩

