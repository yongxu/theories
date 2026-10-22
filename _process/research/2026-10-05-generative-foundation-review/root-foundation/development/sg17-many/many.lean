/-! ### Any number of drawers in turn

At each step `k` drawers draw in turn: drawer `0` is given the level, each leaves what its rule says of
what it is given, and what the last leaves stands as `G` says. With at least two drawers, backward from
the horizon, every drawer after the first draws nothing later, so of whatever it is given it leaves
nothing; then whatever the first leaves the second takes, so the first leaves nothing too. Two drawers
are the case `k = 2` (`Many.perfect_pair`). -/

namespace Many

/-- What drawers `m, …, m + c - 1` leave in turn of `b` at step `t`, drawer `m` leaving `rules m t b` of
the `b` it is given. -/
def pass (rules : Nat → Nat → Nat → Nat) (t : Nat) : Nat → Nat → Nat → Nat
  | _, 0, b => b
  | m, c + 1, b => pass rules t (m + 1) c (rules m t b)

/-- What stands at the step after `t`, `k` drawers in turn from the level `z`. -/
def next (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k t z : Nat) : Nat :=
  G t (pass rules t 0 k z)

/-- What drawer `m` of `k` draws over `j` steps from step `t` at level `z`. -/
def drawn (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k m : Nat) : Nat → Nat → Nat → Nat
  | 0, _, _ => 0
  | j + 1, t, z => (pass rules t 0 m z - rules m t (pass rules t 0 m z)) +
      drawn G rules k m j (t + 1) (next G rules k t z)

/-- **A mutual best response of `k` drawers at a step**, `j` steps after it: of whatever it is given,
each drawer leaves what draws it the most over the rest, the drawers after it at the step and every
drawer at later steps responding by their rules. -/
def BestAt (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k j t : Nat) : Prop :=
  ∀ m, m < k → ∀ a b, b ≤ a →
    a - b + drawn G rules k m j (t + 1) (G t (pass rules t (m + 1) (k - (m + 1)) b)) ≤
      a - rules m t a + drawn G rules k m j (t + 1) (G t (pass rules t (m + 1) (k - (m + 1)) (rules m t a)))

/-- **Perfect over a horizon.** Each leaves at most what it is given, and over `N` steps the `k` drawers
are at a mutual best response at every step, from every level. -/
def Perfect (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k N : Nat) : Prop :=
  (∀ m t a, rules m t a ≤ a) ∧ ∀ t j, t + j + 1 = N → BestAt G rules k j t

/-- The levels along a profile of `k` drawers from `s`. -/
def levels (G : Nat → Nat → Nat) (rules : Nat → Nat → Nat → Nat) (k s : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => next G rules k t (levels G rules k s t)

variable {G : Nat → Nat → Nat} {rules : Nat → Nat → Nat → Nat} {k : Nat}

/-- Of nothing, drawers who leave at most what they are given leave nothing. -/
theorem pass_zero (leaves : ∀ m t a, rules m t a ≤ a) (t : Nat) : ∀ m c, pass rules t m c 0 = 0
  | _, 0 => rfl
  | m, c + 1 => (congrArg (pass rules t (m + 1) c) (Nat.eq_zero_of_le_zero (leaves m t 0))).trans
      (pass_zero leaves t (m + 1) c)

/-- Where the first of them leaves nothing, drawers in turn leave nothing. -/
theorem pass_of_first (leaves : ∀ m t a, rules m t a ≤ a) {t m : Nat} (none : ∀ a, rules m t a = 0) :
    ∀ c b, pass rules t m (c + 1) b = 0 := fun c b =>
  (congrArg (pass rules t (m + 1) c) (none b)).trans (pass_zero leaves t (m + 1) c)

/-- **One step back from the horizon.** With at least two drawers, each leaving at most what it is
given, where every drawer after the first draws nothing over the `j` steps after step `t` from any
level, a mutual best response at `t` has every drawer leave nothing there, and every drawer after the
first draws nothing over the `j + 1` steps from `t`. -/
theorem step_ends (leaves : ∀ m t a, rules m t a ≤ a) (two : 2 ≤ k) {j t : Nat}
    (none : ∀ m, 1 ≤ m → m < k → ∀ w, drawn G rules k m j (t + 1) w = 0)
    (best : BestAt G rules k j t) :
    (∀ m, m < k → ∀ a, rules m t a = 0) ∧ ∀ m, 1 ≤ m → m < k → ∀ z, drawn G rules k m (j + 1) t z = 0 :=
  have later : ∀ m, 1 ≤ m → m < k → ∀ a, rules m t a = 0 := fun m one lt a =>
    have pick := best m lt a 0 (Nat.zero_le a)
    zero_of_le_sub (leaves m t a) (by
      rw [none m one lt, none m one lt, Nat.add_zero, Nat.add_zero, Nat.sub_zero] at pick
      exact pick)
  have second : ∀ a, rules 1 t a = 0 := later 1 (Nat.le_refl 1) (Nat.lt_of_lt_of_le (Nat.lt_succ_self 1) two)
  have rest : ∀ b, pass rules t (0 + 1) (k - (0 + 1)) b = 0 := fun b =>
    match le_dest two with
    | ⟨c, split⟩ =>
      have count : k - (0 + 1) = c + 1 := (congrArg (· - 1) split).trans (congrArg (· - 1) (Nat.add_comm 2 c))
      Eq.subst (motive := fun n => pass rules t (0 + 1) n b = 0) count.symm (pass_of_first leaves second c b)
  have first : ∀ a, rules 0 t a = 0 := fun a =>
    have pick := best 0 (Nat.lt_of_lt_of_le (Nat.zero_lt_succ 1) two) a 0 (Nat.zero_le a)
    zero_of_le_sub (leaves 0 t a) (Naturals.le_of_add_le_add_right (by
      rw [rest, rest, Nat.sub_zero] at pick
      exact pick))
  ⟨fun m lt a => match m, lt with
    | 0, _ => first a
    | m + 1, lt => later (m + 1) (Nat.succ_le_succ (Nat.zero_le m)) lt a,
   fun m one lt z => match m, one, lt with
    | 0, one, _ => absurd one (Nat.not_succ_le_zero 0)
    | m + 1, one, lt => by
      show pass rules t 0 (m + 1) z - rules (m + 1) t (pass rules t 0 (m + 1) z) +
        drawn G rules k (m + 1) j (t + 1) (next G rules k t z) = 0
      rw [pass_of_first leaves first m z, none (m + 1) one lt, Nat.zero_sub]⟩

/-- **Backward from the horizon, every drawer leaves nothing.** With at least two drawers, along a
profile perfect over `N` steps, at every step with `j` steps after it every drawer leaves nothing from
every level, and every drawer after the first draws nothing over the `j + 1` steps. -/
theorem ends_at (two : 2 ≤ k) {N : Nat} (perfect : Perfect G rules k N) :
    ∀ j t, t + j + 1 = N → (∀ m, m < k → ∀ a, rules m t a = 0) ∧
      ∀ m, 1 ≤ m → m < k → ∀ z, drawn G rules k m (j + 1) t z = 0
  | 0, t, at_ => step_ends perfect.1 two (fun _ _ _ _ => rfl) (perfect.2 t 0 at_)
  | j + 1, t, at_ =>
    have later := ends_at two perfect j (t + 1)
      ((congrArg (· + 1) ((Nat.add_assoc t 1 j).trans (congrArg (t + ·) (Nat.add_comm 1 j)))).trans at_)
    step_ends perfect.1 two later.2 (perfect.2 t (j + 1) at_)

/-- **Every perfect profile of two or more drawers draws everything.** Along every profile of `k ≥ 2`
drawers in turn perfect over `N` steps, every drawer leaves nothing at every step before the horizon,
from every level, whatever stands at nothing. -/
theorem perfect_ends (two : 2 ≤ k) {N : Nat} (perfect : Perfect G rules k N) {t : Nat} (before : t < N) :
    ∀ m, m < k → ∀ a, rules m t a = 0 :=
  match le_dest before with
  | ⟨j, split⟩ => (ends_at two perfect j t ((Nat.add_right_comm t j 1).trans split.symm)).1

/-- **The base stands at what stands at nothing.** Along every profile of `k ≥ 2` drawers perfect over
`N` steps, at every step from the first to the `N`-th the base stands at what stands at nothing. -/
theorem perfect_levels (two : 2 ≤ k) {N : Nat} (perfect : Perfect G rules k N) (s : Nat) {t : Nat}
    (before : t < N) : levels G rules k s (t + 1) = G t 0 :=
  match le_dest two with
  | ⟨c, split⟩ =>
    have count : k = c + 1 + 1 := split.trans ((Nat.add_comm 2 c).trans (Nat.add_assoc c 1 1).symm)
    congrArg (G t) (Eq.subst (motive := fun n => pass rules t 0 n (levels G rules k s t) = 0) count.symm
      (pass_of_first perfect.1 (perfect_ends two perfect before 0 (Nat.lt_of_lt_of_le (Nat.zero_lt_succ 1) two))
        (c + 1) _))

/-- Where each draws everything, every drawer after the first draws nothing. -/
theorem zero_drawn {m : Nat} (one : 1 ≤ m) : ∀ j t z, drawn G (fun _ _ _ => 0) k m j t z = 0
  | 0, _, _ => rfl
  | j + 1, t, z => match m, one with
    | m + 1, _ => by
      show pass (fun _ _ _ => 0) t 0 (m + 1) z - 0 +
        drawn G (fun _ _ _ => 0) k (m + 1) j (t + 1) (next G (fun _ _ _ => 0) k t z) = 0
      rw [pass_of_first (fun _ _ _ => Nat.zero_le _) (fun _ => rfl) m z,
        zero_drawn (Nat.succ_le_succ (Nat.zero_le m)) j]

/-- **Drawing everything is perfect** for every number of drawers from two. -/
theorem perfect_of_zero (two : 2 ≤ k) (N : Nat) : Perfect G (fun _ _ _ => 0) k N :=
  ⟨fun _ _ _ => Nat.zero_le _, fun t j _ m lt a b _ => match m, lt with
    | 0, _ =>
      match le_dest two with
      | ⟨c, split⟩ =>
        have count : k - (0 + 1) = c + 1 :=
          (congrArg (· - 1) split).trans (congrArg (· - 1) (Nat.add_comm 2 c))
        have rest : ∀ b', pass (fun _ _ _ => 0) t (0 + 1) (k - (0 + 1)) b' = 0 := fun b' =>
          Eq.subst (motive := fun n => pass (fun _ _ _ => 0) t (0 + 1) n b' = 0) count.symm
            (pass_of_first (fun _ _ _ => Nat.zero_le _) (fun _ => rfl) c b')
        by
          rw [rest, rest, Nat.sub_zero]
          exact Nat.add_le_add_right (Nat.sub_le a b) _
    | m + 1, _ => by
      rw [zero_drawn (Nat.succ_le_succ (Nat.zero_le m)), zero_drawn (Nat.succ_le_succ (Nat.zero_le m)),
        Nat.add_zero, Nat.add_zero, Nat.sub_zero]
      exact Nat.sub_le a b⟩

/-- Two drawers as drawers `0` and `1`. -/
def pair (first second : Nat → Nat → Nat) : Nat → Nat → Nat → Nat
  | 0 => first
  | _ + 1 => second

theorem drawn_first {first second : Nat → Nat → Nat} :
    ∀ j t z, drawn G (pair first second) 2 0 j t z = firstDrawn G first second j t z
  | 0, _, _ => rfl
  | j + 1, t, z => congrArg (z - first t z + ·) (drawn_first j (t + 1) _)

theorem drawn_second {first second : Nat → Nat → Nat} :
    ∀ j t z, drawn G (pair first second) 2 1 j t z = secondDrawn G first second j t z
  | 0, _, _ => rfl
  | j + 1, t, z => congrArg (first t z - second t (first t z) + ·) (drawn_second j (t + 1) _)

theorem levels_pair {first second : Nat → Nat → Nat} (s : Nat) :
    ∀ t, levels G (pair first second) 2 s t = InTurn.levels G first second s t
  | 0 => rfl
  | t + 1 => congrArg (fun z => G t (second t (first t z))) (levels_pair s t)

/-- **Two drawers in turn are the case `k = 2`.** A profile of two drawers perfect over `N` steps is
perfect as drawers `0` and `1`. -/
theorem perfect_pair {first second : Nat → Nat → Nat} {N : Nat} (perfect : InTurn.Perfect G first second N) :
    Perfect G (pair first second) 2 N :=
  ⟨fun m t a => match m with
    | 0 => perfect.1 t a
    | _ + 1 => perfect.2.1 t a,
   fun t j at_ m lt a b le => match m, lt with
    | 0, _ => Nat.le_trans (Nat.le_of_eq (congrArg (a - b + ·) (drawn_first _ _ _)))
        (Nat.le_trans ((perfect.2.2 t j at_).2 a b le)
          (Nat.le_of_eq (congrArg (a - first t a + ·) (drawn_first _ _ _)).symm))
    | 1, _ => Nat.le_trans (Nat.le_of_eq (congrArg (a - b + ·) (drawn_second _ _ _)))
        (Nat.le_trans ((perfect.2.2 t j at_).1 a b le)
          (Nat.le_of_eq (congrArg (a - second t a + ·) (drawn_second _ _ _)).symm))
    | m + 2, lt => absurd lt (Nat.not_lt_of_ge (Nat.le_add_left 2 m))⟩

end Many

