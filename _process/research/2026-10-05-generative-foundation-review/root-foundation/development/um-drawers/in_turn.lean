/-! ## Drawers in turn

Above, others drawing first were supplied as a rule reading the level. Here every drawer ranks
courses. At each step `k` drawers draw in turn: drawer `0` is given the level, drawer `d` leaves of
what it is given `a` at least its floor `low d t a`, what a capacity leaves it, and at most `a`, and
what the last leaves stands at the next step as `G t` of it. Each ranks what it draws over the steps
that remain. A profile revises another where each of its rules, at every step from every level,
leaves what draws its drawer the most against the other profile; a profile is perfect where it
revises itself. One law carries every result: what a best response keeps above its floor returns
to it at least one for one (`kept_returns`). So a drawer leaves its floor wherever what it draws later
does not depend on what it leaves (`at_floor`). With no floor and at least two drawers, backward
from the horizon every drawer after the first draws nothing later, and what the first leaves goes to
the second: revising from any profile comes to drawing everything within twice the horizon, and
every perfect profile draws everything. -/

namespace Optimum

namespace InTurn

/-- What drawers `d, …, d + c - 1` leave in turn of `b` at step `t`, drawer `d` leaving `rules d t b`
of the `b` it is given. -/
def pass (rules : Nat → Nat → Nat → Nat) (t : Nat) : Nat → Nat → Nat → Nat
  | _, 0, b => b
  | d, c + 1, b => pass rules t (d + 1) c (rules d t b)

/-- What stands at the step after `t`, `k` drawers in turn from the level `z`. -/
def next (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k t z : Nat) : Nat :=
  G t (pass rules t 0 k z)

/-- What drawer `d` of `k` draws over `j` steps from step `t` at level `z`. -/
def drawn (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k d : Nat) : Nat → Nat → Nat → Nat
  | 0, _, _ => 0
  | j + 1, t, z => (pass rules t 0 d z - rules d t (pass rules t 0 d z)) +
      drawn G rules k d j (t + 1) (next G rules k t z)

/-- What drawer `d` draws over the `j` steps after step `t`, having left `b` there: the drawers after
it at `t` and every drawer later following `rules`. -/
def later (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k d j t b : Nat) : Nat :=
  drawn G rules k d j (t + 1) (G t (pass rules t (d + 1) (k - (d + 1)) b))

/-- The levels along a profile of `k` drawers from `s`. -/
def levels (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k s : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => next G rules k t (levels G rules k s t)

/-- **A revision.** Each rule of `rules'` leaves between its floor and all of what it is given, and
over a horizon of `N` steps, at every step from every level, it leaves what draws its drawer the most
against the profile `rules`: of what drawer `d` is given at `t`, its draw there and what it draws
later. -/
def Revises (G : Nat → Nat → Nat) (low rules rules' : Nat → Nat → Nat → Nat) (k N : Nat) : Prop :=
  (∀ d t a, low d t a ≤ rules' d t a ∧ rules' d t a ≤ a) ∧
  ∀ t j, t + j + 1 = N → ∀ d, d < k → ∀ a b, low d t a ≤ b → b ≤ a →
    a - b + later G rules k d j t b ≤ a - rules' d t a + later G rules k d j t (rules' d t a)

/-- **Perfect over a horizon**: the profile revises itself, every drawer at a best response at every
step from every level, over the steps that remain. -/
def Perfect (G : Nat → Nat → Nat) (low rules : Nat → Nat → Nat → Nat) (k N : Nat) : Prop :=
  Revises G low rules rules k N

/-- **What a best response keeps above its floor returns to it at least one for one.** Of `a`, leaving
`r` draws `a - r` now and `C r` later; where that draws no less than leaving the floor `low ≤ r ≤ a`,
what `r` brings later exceeds what the floor brings by at least what it keeps above the floor. -/
theorem kept_returns {C : Nat → Nat} {a low r : Nat} (floor : low ≤ r) (le : r ≤ a)
    (best : a - low + C low ≤ a - r + C r) : C low + (r - low) ≤ C r := by
  match le_dest floor, le_dest le with
  | ⟨e, hr⟩, ⟨d, ha⟩ =>
    subst ha
    subst hr
    rw [Naturals.add_sub_cancel_left low e]
    rw [Nat.add_assoc low e d, Naturals.add_sub_cancel_left low (e + d),
      ← Nat.add_assoc low e d, Naturals.add_sub_cancel_left (low + e) d] at best
    rw [Nat.add_comm (C low) e]
    exact Naturals.le_of_add_le_add_right (Nat.le_trans
      (Nat.le_of_eq (Nat.add_right_comm e (C low) d))
      (Nat.le_trans best (Nat.le_of_eq (Nat.add_comm d (C (low + e))))))

/-- **A best response leaves its floor wherever nothing it keeps above the floor returns to it.** -/
theorem leaves_floor {C : Nat → Nat} {a low r : Nat} (floor : low ≤ r) (le : r ≤ a)
    (best : a - low + C low ≤ a - r + C r) (same : C r = C low) : r = low :=
  have none : r - low = 0 := Nat.eq_zero_of_le_zero (Naturals.le_of_add_le_add_left
    (Nat.le_trans (kept_returns floor le best) (Nat.le_of_eq (same.trans (Nat.add_zero (C low)).symm))))
  (Becoming.add_sub_of_le floor).symm.trans ((congrArg (low + ·) none).trans (Nat.add_zero low))

variable {G : Nat → Nat → Nat} {low rules rules' : Nat → Nat → Nat → Nat} {k N : Nat}

/-- **A drawer draws to capacity wherever what it draws later does not depend on what it leaves.** In
a revision, where what drawer `d` draws after step `t` is the same whether it leaves its rule's amount
or its floor, its rule leaves the floor. -/
theorem at_floor (rev : Revises G low rules rules' k N) {t j : Nat} (at_ : t + j + 1 = N) {d : Nat}
    (lt : d < k) (a : Nat)
    (same : later G rules k d j t (rules' d t a) = later G rules k d j t (low d t a)) :
    rules' d t a = low d t a :=
  leaves_floor (C := later G rules k d j t) (rev.1 d t a).1 (rev.1 d t a).2
    (rev.2 t j at_ d lt a (low d t a) (Nat.le_refl _) (Nat.le_trans (rev.1 d t a).1 (rev.1 d t a).2)) same

/-- **At the last step every drawer draws to capacity**, nothing being drawn after it. -/
theorem last_at_floor (rev : Revises G low rules rules' k N) {t : Nat} (at_ : t + 1 = N) :
    ∀ d, d < k → ∀ a, rules' d t a = low d t a := fun _ lt a =>
  at_floor rev (j := 0) at_ lt a rfl

/-- Of nothing, drawers who leave at most what they are given leave nothing. -/
theorem pass_zero (leaves : ∀ d t a, rules d t a ≤ a) (t : Nat) : ∀ d c, pass rules t d c 0 = 0
  | _, 0 => rfl
  | d, c + 1 => (congrArg (pass rules t (d + 1) c) (Nat.eq_zero_of_le_zero (leaves d t 0))).trans
      (pass_zero leaves t (d + 1) c)

/-- Where the first of them leaves nothing, drawers in turn leave nothing. -/
theorem pass_of_first (leaves : ∀ d t a, rules d t a ≤ a) {t d : Nat} (none : ∀ a, rules d t a = 0) :
    ∀ c b, pass rules t d (c + 1) b = 0 := fun c b =>
  (congrArg (pass rules t (d + 1) c) (none b)).trans (pass_zero leaves t (d + 1) c)

/-- **Where the first drawer leaves nothing, the others draw nothing.** Where drawer `0` leaves nothing
at every step from `t` to the horizon, every other drawer draws nothing over the steps that
remain. -/
theorem others_draw_nothing (leaves : ∀ d t a, rules d t a ≤ a) {t : Nat}
    (first : ∀ u, t ≤ u → u < N → ∀ a, rules 0 u a = 0) :
    ∀ j, t + j = N → ∀ d, 1 ≤ d → ∀ w, drawn G rules k d j t w = 0
  | 0, _, _, _, _ => rfl
  | j + 1, at_, d, one, w => match d, one with
    | 0, one => absurd one (Nat.not_succ_le_zero 0)
    | d + 1, one => by
      have now : ∀ a, rules 0 t a = 0 := first t (Nat.le_refl t)
        (Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right (Nat.succ_pos j)) (Nat.le_of_eq at_))
      show pass rules t 0 (d + 1) w - rules (d + 1) t (pass rules t 0 (d + 1) w) +
        drawn G rules k (d + 1) j (t + 1) (next G rules k t w) = 0
      rw [pass_of_first leaves now d w, others_draw_nothing leaves (t := t + 1)
        (fun u le lt => first u (Nat.le_of_succ_le le) lt) j ((Nat.add_right_comm t 1 j).trans at_) (d + 1) one,
        Nat.zero_sub]

/-- **Revising from the horizon back, every drawer comes to leave nothing.** With no floor and at
least two drawers, along every sequence of profiles each revising the one before over a horizon of
`N` steps, at every round from `2 c` on every drawer leaves nothing at every step of the last `c`,
from every level, whatever profile they started from: every drawer after the first draws nothing
later, so its revision leaves its floor, and then what the first leaves goes to the second. -/
theorem revisions_end {fs : Nat → Nat → Nat → Nat → Nat} (two : 2 ≤ k)
    (leaves : ∀ m d t a, fs m d t a ≤ a) (rev : ∀ m, Revises G (fun _ _ _ => 0) (fs m) (fs (m + 1)) k N) :
    ∀ c t, t + c = N → ∀ m, 2 * c ≤ m → ∀ u, t ≤ u → u < N → ∀ d, d < k → ∀ a, fs m d u a = 0
  | 0, t, at_, _, _, u, le, lt => absurd (Nat.lt_of_lt_of_le lt (Nat.le_of_eq at_.symm))
      (Nat.not_lt_of_ge le)
  | c + 1, t, at_, m, enough, u, le, lt =>
    have here : t + c + 1 = N := (Nat.add_assoc t c 1).trans at_
    have after : t + 1 + c = N := (Nat.add_right_comm t 1 c).trans here
    have later_ := revisions_end two leaves rev c (t + 1) after
    have firstPos : 0 < k := Nat.lt_of_lt_of_le (Nat.zero_lt_succ 1) two
    -- From round `2 c + 1` on, every drawer after the first leaves nothing at `t`.
    have others : ∀ m', 2 * c + 1 ≤ m' → ∀ d, 1 ≤ d → d < k → ∀ a, fs m' d t a = 0 :=
      fun m' big d one dk a => match m', big with
      | m'' + 1, big =>
        have none : ∀ w, drawn G (fs m'') k d c (t + 1) w = 0 :=
          others_draw_nothing (leaves m'') (t := t + 1)
            (fun u le' lt' => later_ m'' (Nat.le_of_succ_le_succ big) u le' lt' 0 firstPos) c after d one
        at_floor (rev m'') here dk a (by
          show drawn G (fs m'') k d c (t + 1) _ = drawn G (fs m'') k d c (t + 1) _
          rw [none, none])
    -- From round `2 c + 2` on, the first leaves nothing at `t`.
    have first : ∀ m', 2 * c + 2 ≤ m' → ∀ a, fs m' 0 t a = 0 := fun m' big a =>
      match m', big with
      | m'' + 1, big =>
        have second : ∀ b, fs m'' 1 t b = 0 := others m'' (Nat.le_of_succ_le_succ big) 1 (Nat.le_refl 1)
          (Nat.lt_of_lt_of_le (Nat.lt_succ_self 1) two)
        have rest : ∀ b, pass (fs m'') t (0 + 1) (k - (0 + 1)) b = 0 := fun b =>
          match le_dest two with
          | ⟨e, split⟩ =>
            have count : k - (0 + 1) = e + 1 :=
              (congrArg (· - 1) split).trans (congrArg (· - 1) (Nat.add_comm 2 e))
            Eq.subst (motive := fun n => pass (fs m'') t (0 + 1) n b = 0) count.symm
              (pass_of_first (leaves m'') second e b)
        at_floor (rev m'') here firstPos a (by
          show drawn G (fs m'') k 0 c (t + 1) (G t (pass (fs m'') t (0 + 1) (k - (0 + 1)) _)) =
            drawn G (fs m'') k 0 c (t + 1) (G t (pass (fs m'') t (0 + 1) (k - (0 + 1)) _))
          rw [rest, rest])
    match Nat.lt_or_ge t u with
    | .inl later' => later_ m (Nat.le_trans (Nat.mul_le_mul_left 2 (Nat.le_succ c)) enough) u later' lt
    | .inr before =>
      have same : u = t := Nat.le_antisymm before le
      have twice : 2 * (c + 1) = 2 * c + 2 := Nat.mul_succ 2 c
      fun d dk a => match d, dk with
        | 0, _ => same ▸ first m (Nat.le_trans (Nat.le_of_eq twice.symm) enough) a
        | d + 1, dk => same ▸ others m (Nat.le_trans (Nat.le_succ _) (Nat.le_trans (Nat.le_of_eq twice.symm) enough))
            (d + 1) (Nat.succ_le_succ (Nat.zero_le d)) dk a

/-- **Every perfect profile draws everything.** With no floor and at least two drawers in turn,
along every profile perfect over `N` steps every drawer leaves nothing at every step before the
horizon, from every level, whatever stands at nothing: a perfect profile is its own sequence of
revisions. -/
theorem perfect_ends (two : 2 ≤ k) (perfect : Perfect G (fun _ _ _ => 0) rules k N) {t : Nat}
    (before : t < N) : ∀ d, d < k → ∀ a, rules d t a = 0 :=
  revisions_end (fs := fun _ => rules) two (fun _ d t a => (perfect.1 d t a).2) (fun _ => perfect)
    N 0 (Nat.zero_add N) (2 * N) (Nat.le_refl _) t (Nat.zero_le t) before

/-- **Where the first drawer leaves nothing, the base stands at what stands at nothing**, from the
first step to the `N`-th. -/
theorem levels_of_first (one : 1 ≤ k) (leaves : ∀ d t a, rules d t a ≤ a)
    (first : ∀ t, t < N → ∀ a, rules 0 t a = 0) (s : Nat) {t : Nat} (before : t < N) :
    levels G rules k s (t + 1) = G t 0 :=
  match le_dest one with
  | ⟨c, split⟩ =>
    have count : k = c + 1 := split.trans (Nat.add_comm 1 c)
    congrArg (G t) (Eq.subst (motive := fun n => pass rules t 0 n (levels G rules k s t) = 0) count.symm
      (pass_of_first leaves (first t before) c _))

/-- **Drawing everything is perfect** for every number of drawers from two. -/
theorem perfect_of_zero (two : 2 ≤ k) (N : Nat) : Perfect G (fun _ _ _ => 0) (fun _ _ _ => 0) k N :=
  ⟨fun _ _ _ => ⟨Nat.le_refl 0, Nat.zero_le _⟩, fun t j at_ d _ a b _ _ =>
    match d with
    | 0 =>
      match le_dest two with
      | ⟨e, split⟩ =>
        have count : k - (0 + 1) = e + 1 :=
          (congrArg (· - 1) split).trans (congrArg (· - 1) (Nat.add_comm 2 e))
        have rest : ∀ b', pass (fun _ _ _ => 0) t (0 + 1) (k - (0 + 1)) b' = 0 := fun b' =>
          Eq.subst (motive := fun n => pass (fun _ _ _ => 0) t (0 + 1) n b' = 0) count.symm
            (pass_of_first (fun _ _ _ => Nat.zero_le _) (fun _ => rfl) e b')
        by
          show a - b + drawn G (fun _ _ _ => 0) k 0 j (t + 1)
              (G t (pass (fun _ _ _ => 0) t (0 + 1) (k - (0 + 1)) b)) ≤
            a - 0 + drawn G (fun _ _ _ => 0) k 0 j (t + 1)
              (G t (pass (fun _ _ _ => 0) t (0 + 1) (k - (0 + 1)) 0))
          rw [rest, rest, Nat.sub_zero]
          exact Nat.add_le_add_right (Nat.sub_le a b) _
    | d + 1 =>
      have nd : ∀ w, drawn G (fun _ _ _ => 0) k (d + 1) j (t + 1) w = 0 :=
        others_draw_nothing (fun _ _ _ => Nat.zero_le _) (t := t + 1) (N := N) (fun _ _ _ _ => rfl) j
          ((Nat.add_right_comm t 1 j).trans at_) (d + 1) (Nat.succ_le_succ (Nat.zero_le d))
      by
        show a - b + drawn G (fun _ _ _ => 0) k (d + 1) j (t + 1) _ ≤
          a - 0 + drawn G (fun _ _ _ => 0) k (d + 1) j (t + 1) _
        rw [nd, nd, Nat.add_zero, Nat.add_zero, Nat.sub_zero]
        exact Nat.sub_le a b⟩

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

/-- **The greatest from a floor.** No value of `f` between `low` and `a` exceeds its value at the
first amount from `low` up at which it is greatest. -/
theorem best_from (f : Nat → Nat) {low a b : Nat} (floor : low ≤ b) (le : b ≤ a) :
    f b ≤ f (low + bestUpTo (fun i => f (low + i)) (a - low)) :=
  Nat.le_trans (Nat.le_of_eq (congrArg f (Becoming.add_sub_of_le floor)).symm)
    (bestUpTo_max (fun i => f (low + i)) (a - low) (b - low) (Nat.sub_le_sub_right le low))

/-- **The revision of a profile**: of what drawer `d` is given at `t`, the first amount from its floor
up that draws it the most against the profile over the steps that remain. -/
def revise (G : Nat → Nat → Nat) (low rules : Nat → Nat → Nat → Nat) (k N d t a : Nat) : Nat :=
  low d t a + bestUpTo (fun i => a - (low d t a + i) + later G rules k d (N - t - 1) t (low d t a + i))
    (a - low d t a)

/-- **A revision always exists.** Where every floor is at most what is given, `revise` revises every
profile. -/
theorem revise_revises (floors : ∀ d t a, low d t a ≤ a) (rules : Nat → Nat → Nat → Nat) :
    Revises G low rules (revise G low rules k N) k N :=
  ⟨fun d t a => ⟨Nat.le_add_right _ _, Nat.le_trans (Nat.add_le_add_left (bestUpTo_le _ _) _)
      (Nat.le_of_eq (Becoming.add_sub_of_le (floors d t a)))⟩,
   fun t j at_ d _ a b floor le => by
    have steps : N - t - 1 = j := by rw [← at_, Nat.add_assoc, Naturals.add_sub_cancel_left]; rfl
    have h := best_from (fun b => a - b + later G rules k d (N - t - 1) t b) floor le
    rw [← steps]
    exact h⟩

/-- The profiles of successive revisions from `start`. -/
def revised (G : Nat → Nat → Nat) (low : Nat → Nat → Nat → Nat) (k N : Nat)
    (start : Nat → Nat → Nat → Nat) : Nat → Nat → Nat → Nat → Nat
  | 0 => start
  | m + 1 => revise G low (revised G low k N start m) k N

/-- Every profile revised from one leaving at most what it is given leaves at most what it is given. -/
theorem revised_leaves (floors : ∀ d t a, low d t a ≤ a) {start : Nat → Nat → Nat → Nat}
    (starts : ∀ d t a, start d t a ≤ a) : ∀ i d t a, revised G low k N start i d t a ≤ a
  | 0 => starts
  | i + 1 => fun d t a => ((revise_revises (G := G) (k := k) (N := N) floors (revised G low k N start i)).1 d t a).2

/-- **Revising toward best responses, drawers in turn come to drawing everything.** With no floor and
at least two drawers, from every profile leaving at most what it is given, at every round of
revision from `2 N` on every drawer leaves nothing at every step before the horizon, and the base
stands from the first step at what stands at nothing. -/
theorem revised_draw_all (two : 2 ≤ k) {start : Nat → Nat → Nat → Nat} (starts : ∀ d t a, start d t a ≤ a)
    {m : Nat} (enough : 2 * N ≤ m) :
    (∀ t, t < N → ∀ d, d < k → ∀ a, revised G (fun _ _ _ => 0) k N start m d t a = 0) ∧
    ∀ s t, t < N → levels G (revised G (fun _ _ _ => 0) k N start m) k s (t + 1) = G t 0 :=
  have leaves := revised_leaves (G := G) (k := k) (N := N) (fun _ _ _ => Nat.zero_le _) starts
  have zeros : ∀ t, t < N → ∀ d, d < k → ∀ a, revised G (fun _ _ _ => 0) k N start m d t a = 0 :=
    fun t lt => revisions_end (fs := revised G (fun _ _ _ => 0) k N start) two leaves
      (fun m => revise_revises (fun _ _ _ => Nat.zero_le _) (revised G (fun _ _ _ => 0) k N start m))
      N 0 (Nat.zero_add N) m enough t (Nat.zero_le t) lt
  ⟨zeros, fun s _ lt => levels_of_first (Nat.le_trans (Nat.le_succ 1) two) (leaves m)
    (fun t lt' => zeros t lt' 0 (Nat.lt_of_lt_of_le (Nat.zero_lt_succ 1) two)) s lt⟩

end InTurn
