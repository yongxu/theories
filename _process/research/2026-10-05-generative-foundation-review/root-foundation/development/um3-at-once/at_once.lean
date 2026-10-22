
/-! ### Drawing at once

The same law at a second arrangement. At each step the level `z` is divided into portions, drawer
`d` given `portion d t z`, and all draw at once; what all leave, added, stands at the next step as
`G t` of it, and what lies in no portion does not stand. What a drawer leaves comes back to it only
through its portion of what stands next. Where that return is less than one for one, by the strict
law (`InTurn.floor_of_less`) every perfect profile draws everything, drawing everything is perfect,
and revising from any profile reaches it within one round a step back. -/

namespace AtOnce

/-- The values of `f` below `n`, added. -/
def sumTo (f : Nat → Nat) : Nat → Nat
  | 0 => 0
  | n + 1 => sumTo f n + f n

/-- What all `k` drawers leave at step `t` of the level `z`. -/
def pool (portion rules : Nat → Nat → Nat → Nat) (k t z : Nat) : Nat :=
  sumTo (fun d => rules d t (portion d t z)) k

/-- What stands at the step after `t`. -/
def next (G : Nat → Nat → Nat) (portion rules : Nat → Nat → Nat → Nat) (k t z : Nat) : Nat :=
  G t (pool portion rules k t z)

/-- What drawer `d` draws over `j` steps from step `t` at level `z`. -/
def drawn (G : Nat → Nat → Nat) (portion rules : Nat → Nat → Nat → Nat) (k d : Nat) : Nat → Nat → Nat → Nat
  | 0, _, _ => 0
  | j + 1, t, z => (portion d t z - rules d t (portion d t z)) +
      drawn G portion rules k d j (t + 1) (next G portion rules k t z)

/-- What drawer `d` draws over the `j` steps after `t`, having left `b` of its portion of `z`, the
others leaving as `rules` says. -/
def later (G : Nat → Nat → Nat) (portion rules : Nat → Nat → Nat → Nat) (k d j t z b : Nat) : Nat :=
  drawn G portion rules k d j (t + 1)
    (G t (sumTo (fun e => if e = d then b else rules e t (portion e t z)) k))

/-- The levels along a profile from `s`. -/
def levels (G : Nat → Nat → Nat) (portion rules : Nat → Nat → Nat → Nat) (k s : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => next G portion rules k t (levels G portion rules k s t)

/-- **A revision**, drawing at once: each rule of `rules'` leaves between its floor and all of its
portion, and at every step from every level it leaves what draws its drawer the most, the others
leaving as `rules` says. -/
def Revises (G : Nat → Nat → Nat) (portion low rules rules' : Nat → Nat → Nat → Nat) (k N : Nat) : Prop :=
  (∀ d t a, low d t a ≤ rules' d t a ∧ rules' d t a ≤ a) ∧
  ∀ t j, t + j + 1 = N → ∀ d, d < k → ∀ z b, low d t (portion d t z) ≤ b → b ≤ portion d t z →
    portion d t z - b + later G portion rules k d j t z b ≤
      portion d t z - rules' d t (portion d t z) + later G portion rules k d j t z (rules' d t (portion d t z))

/-- **Perfect**, drawing at once: the profile revises itself. -/
def Perfect (G : Nat → Nat → Nat) (portion low rules : Nat → Nat → Nat → Nat) (k N : Nat) : Prop :=
  Revises G portion low rules rules k N

/-- **Each portion returns less than one for one**: of what stands at the step after `t`, raised by a
positive amount left, drawer `d`'s portion rises by less than that amount. -/
def ReturnsLess (G : Nat → Nat → Nat) (portion : Nat → Nat → Nat → Nat) (k N : Nat) : Prop :=
  ∀ d, d < k → ∀ t, t + 1 < N → ∀ x b, 0 < b → portion d (t + 1) (G t (x + b)) < portion d (t + 1) (G t x) + b

variable {G : Nat → Nat → Nat} {portion : Nat → Nat → Nat → Nat} {k N : Nat}

theorem sumTo_congr {f g : Nat → Nat} : ∀ {n}, (∀ e, e < n → f e = g e) → sumTo f n = sumTo g n
  | 0, _ => rfl
  | n + 1, same => (congrArg (· + f n) (sumTo_congr fun e lt => same e (Nat.lt_succ_of_lt lt))).trans
      (congrArg (sumTo g n + ·) (same n (Nat.lt_succ_self n)))

theorem sumTo_zeros : ∀ n, sumTo (fun _ => 0) n = 0
  | 0 => rfl
  | n + 1 => sumTo_zeros n

theorem sumTo_zero {f : Nat → Nat} {n : Nat} (zero : ∀ e, e < n → f e = 0) : sumTo f n = 0 :=
  (sumTo_congr (g := fun _ => 0) zero).trans (sumTo_zeros n)

/-- **One summand set apart.** With `d` below `n`, the sum with `b` at `d` is the sum with nothing
there, and `b`. -/
theorem sumTo_set {f : Nat → Nat} {d b : Nat} : ∀ {n}, d < n →
    sumTo (fun e => if e = d then b else f e) n = sumTo (fun e => if e = d then 0 else f e) n + b
  | 0, lt => absurd lt (Nat.not_lt_zero d)
  | n + 1, lt => (Nat.lt_or_ge d n).elim
      (fun dn => by
        show sumTo (fun e => if e = d then b else f e) n + (if n = d then b else f n) =
          sumTo (fun e => if e = d then 0 else f e) n + (if n = d then 0 else f n) + b
        rw [sumTo_set dn, if_neg (Nat.ne_of_gt dn), if_neg (Nat.ne_of_gt dn), Nat.add_right_comm])
      (fun nd => have same : n = d := Nat.le_antisymm nd (Nat.le_of_lt_succ lt)
        have below : ∀ e, e < n → (if e = d then b else f e) = (if e = d then 0 else f e) := fun e en => by
          rw [if_neg (Nat.ne_of_lt (Nat.lt_of_lt_of_le en (Nat.le_of_eq same))),
            if_neg (Nat.ne_of_lt (Nat.lt_of_lt_of_le en (Nat.le_of_eq same)))]
        by
          show sumTo (fun e => if e = d then b else f e) n + (if n = d then b else f n) =
            sumTo (fun e => if e = d then 0 else f e) n + (if n = d then 0 else f n) + b
          rw [sumTo_congr below, if_pos same, if_pos same, Nat.add_zero])

/-- Where every drawer draws everything at a step, drawer `d` draws its portion there and nothing is
left to stand but what stands at nothing. -/
theorem drawn_step {rules : Nat → Nat → Nat → Nat} {d t : Nat} (dk : d < k)
    (zero : ∀ e, e < k → ∀ z, rules e t (portion e t z) = 0) (j w : Nat) :
    drawn G portion rules k d (j + 1) t w = portion d t w + drawn G portion rules k d j (t + 1) (G t 0) := by
  show portion d t w - rules d t (portion d t w) +
    drawn G portion rules k d j (t + 1) (G t (sumTo (fun e => rules e t (portion e t w)) k)) = _
  rw [zero d dk w, Nat.sub_zero, sumTo_zero (fun e ek => zero e ek w)]

/-- **Where the others draw everything later, what a drawer keeps returns less than one for one.** -/
theorem later_less {rules : Nat → Nat → Nat → Nat} (returns : ReturnsLess G portion k N) {d t c z r : Nat}
    (dk : d < k) (here : t + c + 1 = N)
    (after : ∀ s, t + 1 ≤ s → s < N → ∀ e, e < k → ∀ z, rules e s (portion e s z) = 0) (pos : 0 < r) :
    later G portion rules k d c t z r < later G portion rules k d c t z 0 + (r - 0) :=
  match c, here with
  | 0, _ => by
    show 0 < 0 + (r - 0)
    rw [Nat.zero_add, Nat.sub_zero]
    exact pos
  | c' + 1, here =>
    have next_ : t + 1 < N := Nat.lt_of_lt_of_le
      (Nat.lt_succ_of_le (Nat.add_le_add_left (Nat.succ_pos c') t)) (Nat.le_of_eq here)
    have v : ∀ b, later G portion rules k d (c' + 1) t z b =
        portion d (t + 1) (G t (sumTo (fun e => if e = d then 0 else rules e t (portion e t z)) k + b)) +
          drawn G portion rules k d c' (t + 1 + 1) (G (t + 1) 0) := fun b =>
      (drawn_step (G := G) dk (fun e ek z' => after (t + 1) (Nat.le_refl _) next_ e ek z') c' _).trans
        (congrArg (fun x => portion d (t + 1) (G t x) + drawn G portion rules k d c' (t + 1 + 1) (G (t + 1) 0))
          (sumTo_set dk))
    by
      rw [v r, v 0, Nat.sub_zero, Nat.add_right_comm _ (drawn G portion rules k d c' (t + 1 + 1) (G (t + 1) 0)) r]
      exact Nat.add_lt_add_right (returns d dk t next_ _ r pos) _

/-- **Revising from the horizon back, every drawer comes to draw everything.** Where each portion
returns less than one for one, along every sequence of profiles each revising the one before over
`N` steps, with no floor, at every round from `c` on every drawer draws all of its portion at every
step of the last `c`, whatever profile they started from. -/
theorem revisions_drain {fs : Nat → Nat → Nat → Nat → Nat} (returns : ReturnsLess G portion k N)
    (rev : ∀ m, Revises G portion (fun _ _ _ => 0) (fs m) (fs (m + 1)) k N) :
    ∀ c t, t + c = N → ∀ m, c ≤ m → ∀ s, t ≤ s → s < N → ∀ d, d < k → ∀ z, fs m d s (portion d s z) = 0
  | 0, _, at_, _, _, _, le, lt => absurd (Nat.lt_of_lt_of_le lt (Nat.le_of_eq at_.symm)) (Nat.not_lt_of_ge le)
  | c + 1, t, at_, m, enough, s, le, lt =>
    have here : t + c + 1 = N := (Nat.add_assoc t c 1).trans at_
    have later_ := revisions_drain returns rev c (t + 1) ((Nat.add_right_comm t 1 c).trans here)
    have now : ∀ m', c + 1 ≤ m' → ∀ d, d < k → ∀ z, fs m' d t (portion d t z) = 0 := fun m' big d dk z =>
      match m', big with
      | m'' + 1, big =>
        InTurn.floor_of_less (C := later G portion (fs m'') k d c t z) (Nat.zero_le _)
          ((rev m'').1 d t (portion d t z)).2 ((rev m'').2 t c here d dk z 0 (Nat.zero_le _) (Nat.zero_le _))
          (later_less returns dk here (later_ m'' (Nat.le_of_succ_le_succ big)))
    match Nat.lt_or_ge t s with
    | .inl after => later_ m (Nat.le_trans (Nat.le_succ c) enough) s after lt
    | .inr before => (Nat.le_antisymm before le) ▸ now m enough

/-- **Drawing at once, every perfect profile draws everything, and drawing everything is perfect.**
Where each portion returns less than one for one, with no floor, the profile drawing everything is
perfect over every horizon, and every perfect profile has every drawer draw all of its portion at
every step before the horizon: a perfect profile is its own sequence of revisions. -/
theorem drains (returns : ReturnsLess G portion k N) :
    Perfect G portion (fun _ _ _ => 0) (fun _ _ _ => 0) k N ∧
      ∀ rules, Perfect G portion (fun _ _ _ => 0) rules k N →
        ∀ t, t < N → ∀ d, d < k → ∀ z, rules d t (portion d t z) = 0 :=
  ⟨⟨fun _ _ _ => ⟨Nat.le_refl 0, Nat.zero_le _⟩, fun t j at_ d dk z b _ le =>
      have ret : later G portion (fun _ _ _ => 0) k d j t z b ≤
          later G portion (fun _ _ _ => 0) k d j t z 0 + (b - 0) :=
        match b with
        | 0 => Nat.le_add_right _ _
        | b + 1 => Nat.le_of_lt (later_less returns dk at_ (fun _ _ _ _ _ _ => rfl) (Nat.succ_pos b))
      Nat.le_trans (Nat.add_le_add_left ret _) (Nat.le_of_eq
        ((congrArg (portion d t z - b + ·) (Nat.add_comm (later G portion (fun _ _ _ => 0) k d j t z 0) b)).trans
          ((Nat.add_assoc _ b _).symm.trans (congrArg (· + later G portion (fun _ _ _ => 0) k d j t z 0)
            (Naturals.sub_add_cancel le)))))⟩,
   fun rules perfect t lt => revisions_drain (fs := fun _ => rules) returns (fun _ => perfect)
     N 0 (Nat.zero_add N) N (Nat.le_refl N) t (Nat.zero_le t) lt⟩

/-- **Where every drawer draws everything, the base stands at what stands at nothing**, from the first
step to the `N`-th. -/
theorem levels_drained {rules : Nat → Nat → Nat → Nat}
    (zero : ∀ t, t < N → ∀ d, d < k → ∀ z, rules d t (portion d t z) = 0) (s : Nat) {t : Nat} (before : t < N) :
    levels G portion rules k s (t + 1) = G t 0 :=
  congrArg (G t) (sumTo_zero fun e ek => zero t before e ek _)

end AtOnce
