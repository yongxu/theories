/-- Drawers who leave everything they are given pass it on whole. -/
theorem pass_keep (t : Nat) : ∀ d c b, InTurn.pass (fun _ _ a => a) t d c b = b
  | _, 0, _ => rfl
  | d, c + 1, b => pass_keep t (d + 1) c b

/-- Under the gate, drawers in turn who all leave everything keep the source at two or above. -/
theorem restraint_keeps (k : Nat) : ∀ t, 2 ≤ InTurn.levels (fun _ z => z + gate z) (fun _ _ a => a) k 2 t
  | 0 => Nat.le_refl 2
  | t + 1 => Nat.le_trans (restraint_keeps k t) (Nat.le_trans (Nat.le_of_eq (pass_keep t 0 k _).symm)
      (Nat.le_add_right _ _))

/-- **The gate witness.** From a source at two, the level the dweller needs, under a gate renewing
one unit at every level from one: alone, the course holding the source at two is an optimum of the
order by what the taker draws across `n + 2` steps with capacity three, keeping the dweller met
through the horizon (`gated_alike`). Any number of drawers in turn from two who all leave
everything keep the source at two or above; drawing everything is perfect for them; every perfect
profile breaks the dweller at the first step; and revising from restraint, from round `2 (n + 2)` on
every profile breaks it there. -/
theorem gated_in_turn (n : Nat) {k : Nat} (two : 2 ≤ k) {m : Nat} (enough : 2 * (n + 2) ≤ m) :
    Frontier (OpenCourse gate 3 2) (byDrawn gate (n + 1)) (holding 2 2 (n + 1)) ∧
      (∀ t, t ≤ n + 1 → 2 ≤ (web (level gate 2 2 (n + 1))).level t .source) ∧
      (∀ t, 2 ≤ InTurn.levels (fun _ z => z + gate z) (fun _ _ a => a) k 2 t) ∧
      InTurn.Perfect (fun _ z => z + gate z) (fun _ _ _ => 0) (fun _ _ _ => 0) k (n + 2) ∧
      (∀ rules, InTurn.Perfect (fun _ z => z + gate z) (fun _ _ _ => 0) rules k (n + 2) →
        (web (onSource (InTurn.levels (fun _ z => z + gate z) rules k 2))).Broken 0 .dweller .source) ∧
      (web (onSource (InTurn.levels (fun _ z => z + gate z)
        (InTurn.revised (fun _ z => z + gate z) (fun _ _ _ => 0) k (n + 2) (fun _ _ a => a) m) k 2))).Broken 0
          .dweller .source :=
  have alone := gated_alike n
  have one : 1 ≤ k := Nat.le_trans (Nat.le_succ 1) two
  have firstPos : 0 < k := Nat.lt_of_lt_of_le (Nat.zero_lt_succ 1) two
  have revised := InTurn.revised_draw_all (G := fun _ z => z + gate z) (N := n + 2) two
    (start := fun _ _ a => a) (fun _ _ a => Nat.le_refl a) enough
  ⟨alone.1, alone.2.2.2.1, restraint_keeps k, InTurn.perfect_of_zero two (n + 2), fun rules perfect =>
    (Web.drained_broken (W := web (onSource (InTurn.levels (fun _ z => z + gate z) rules k 2)))
      (c := Place.source) (f := Formation.dweller) one (fun d t a => (perfect.1 d t a).2)
      (fun _ lt => InTurn.perfect_ends two perfect lt 0 firstPos) (fun _ _ => rfl) (Nat.succ_pos (n + 1))
      trivial (Nat.succ_pos 1) (Nat.le_refl 2)).1,
   (Web.drained_broken (W := web (onSource (InTurn.levels (fun _ z => z + gate z)
      (InTurn.revised (fun _ z => z + gate z) (fun _ _ _ => 0) k (n + 2) (fun _ _ a => a) m) k 2)))
      (c := Place.source) (f := Formation.dweller)
      (rules := InTurn.revised (fun _ z => z + gate z) (fun _ _ _ => 0) k (n + 2) (fun _ _ a => a) m) one
      (InTurn.revised_leaves (fun _ _ _ => Nat.zero_le _) (fun _ _ a => Nat.le_refl a) m)
      (fun t lt => revised.1 t lt 0 firstPos) (fun _ _ => rfl) (Nat.succ_pos (n + 1))
      trivial (Nat.succ_pos 1) (Nat.le_refl 2)).1⟩

/-- A capacity of one unit a step for every drawer after the first, none for the first. -/
def oneUnit : Nat → Nat → Nat → Nat
  | 0, _, _ => 0
  | _ + 1, _, a => a - 1

/-- The first leaves everything at the first step from two up and draws everything otherwise. -/
def keepsFirst : Nat → Nat → Nat
  | 0, z => if 2 ≤ z then z else 0
  | _ + 1, _ => 0

/-- The first keeps as `keepsFirst` says, the others take their unit. -/
def keeping : Nat → Nat → Nat → Nat
  | 0, t, z => keepsFirst t z
  | _ + 1, _, a => a - 1

theorem keepsFirst_le : ∀ t z, keepsFirst t z ≤ z
  | 0, z => if h : 2 ≤ z then Nat.le_of_eq (if_pos h) else Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le z)
  | _ + 1, z => Nat.zero_le z

/-- `b + d` twice is `d` with `b` twice, and `d` again. -/
theorem twice_sum (b d : Nat) : (b + d) + (b + d) = (d + (b + b)) + d :=
  (Nat.add_assoc b d (b + d)).trans ((Nat.add_left_comm b d (b + d)).trans
    ((congrArg (d + ·) (Nat.add_assoc b b d).symm).trans (Nat.add_assoc d (b + b) d).symm))

/-- Under doubling, leaving `a` of `z` and drawing what doubles of the rest after the second takes one,
draws at most what `keepsFirst` draws. -/
theorem keepsFirst_best (z a : Nat) (le : a ≤ z) :
    z - a + ((a - 1) + (a - 1)) ≤
      z - keepsFirst 0 z + ((keepsFirst 0 z - 1) + (keepsFirst 0 z - 1)) :=
  if two : 2 ≤ z then by
    show z - a + ((a - 1) + (a - 1)) ≤
      z - (if 2 ≤ z then z else 0) + (((if 2 ≤ z then z else 0) - 1) + ((if 2 ≤ z then z else 0) - 1))
    rw [if_pos two, Nat.sub_self, Nat.zero_add]
    exact match a, le with
    | 0, _ => match z, two with
      | e + 2, _ => Nat.succ_le_succ (Nat.le_add_right (e + 1) e)
    | b + 1, le => match le_dest le with
      | ⟨d, split⟩ => by
        rw [split, Naturals.add_sub_cancel_left (b + 1) d, Nat.add_right_comm b 1 d]
        show d + (b + b) ≤ (b + d) + (b + d)
        exact Nat.le_trans (Nat.le_add_right _ d) (Nat.le_of_eq (twice_sum b d).symm)
  else by
    show z - a + ((a - 1) + (a - 1)) ≤
      z - (if 2 ≤ z then z else 0) + (((if 2 ≤ z then z else 0) - 1) + ((if 2 ≤ z then z else 0) - 1))
    rw [if_neg two]
    have small : a - 1 = 0 := Becoming.sub_eq_zero_of_le
      (Nat.le_of_lt_succ (Nat.lt_of_le_of_lt le (Nat.gt_of_not_le two)))
    rw [small]
    exact Nat.sub_le z a

/-- Only leaving all three, where the second takes one and what doubles of the rest is drawn after,
draws four. -/
theorem only_three : ∀ f, f ≤ 3 → 4 ≤ 3 - f + ((f - 1) + (f - 1)) → f = 3
  | 0, _, h => absurd h (by decide)
  | 1, _, h => absurd h (by decide)
  | 2, _, h => absurd h (by decide)
  | 3, _, _ => rfl
  | f + 4, le, _ => absurd le (Nat.not_le_of_gt (Nat.lt_of_lt_of_le (Nat.lt_succ_self 3) (Nat.le_add_left 4 f)))

/-- **The capacity witness: a limit on the other's draw makes restraint the best response.** What
stands after a step is twice what is left; over two steps, the first of two drawers can take any
amount and the second one unit a step. The profile in which the first leaves everything at the first
step from two up, and draws everything otherwise, and the second takes its unit, is perfect within
these floors. In every such perfect profile, from three, the second takes its unit, so what the first
leaves returns to it twice, less one: the first leaves everything at the first step, the source stands
at four after it and a dweller needing two, met at three, is kept across the first step. With no
floor every perfect profile breaks it there. -/
theorem doubling_capacity :
    InTurn.Perfect (fun _ z => z + z) oneUnit keeping 2 2 ∧
    (∀ rules, InTurn.Perfect (fun _ z => z + z) oneUnit rules 2 2 →
      rules 0 0 3 = 3 ∧ (web (onSource (InTurn.levels (fun _ z => z + z) rules 2 3))).Kept 0 .dweller .source) ∧
    ∀ rules, InTurn.Perfect (fun _ z => z + z) (fun _ _ _ => 0) rules 2 2 →
      (web (onSource (InTurn.levels (fun _ z => z + z) rules 2 3))).Broken 0 .dweller .source :=
  ⟨⟨fun d t a => match d with
      | 0 => ⟨Nat.zero_le _, keepsFirst_le t a⟩
      | _ + 1 => ⟨Nat.le_refl _, Nat.sub_le a 1⟩,
    fun t j at_ d lt a b floor _ => match t, j, at_, d, lt with
      | 0, 0, h, _, _ => absurd h (by decide)
      | 0, j + 2, h, _, _ => absurd h (Nat.ne_of_gt (Nat.succ_le_succ
          (Nat.succ_le_succ (Nat.succ_le_succ (Nat.zero_le (0 + j))))))
      | 1, j + 1, h, _, _ => absurd h (Nat.ne_of_gt (Nat.succ_le_succ (Nat.succ_le_succ (Nat.le_add_right 1 j))))
      | t + 2, j, h, _, _ => absurd h (Nat.ne_of_gt (Nat.succ_le_succ
          (Nat.le_trans (Nat.le_add_left 2 t) (Nat.le_add_right (t + 2) j))))
      | _, _, _, d + 2, lt => absurd lt (Nat.not_lt_of_ge (Nat.le_add_left 2 d))
      | 0, 1, _, 0, _ => keepsFirst_best a b ‹b ≤ a›
      | 0, 1, _, 1, _ => sub_le_sub_left_of_le floor a
      | 1, 0, _, 0, _ => Nat.sub_le a b
      | 1, 0, _, 1, _ => sub_le_sub_left_of_le floor a⟩,
   fun rules perfect =>
    have last := InTurn.last_at_floor perfect (t := 1) rfl
    have none : ∀ w, InTurn.drawn (fun _ z => z + z) rules 2 1 1 1 w = 0 := fun w => by
      show rules 0 1 w - rules 1 1 (rules 0 1 w) + 0 = 0
      rw [last 0 (Nat.zero_lt_succ 1) w, last 1 (Nat.lt_succ_self 1) (oneUnit 0 1 w)]
      try rfl
    have sec : ∀ a, rules 1 0 a = a - 1 := fun a =>
      InTurn.at_floor perfect (t := 0) (j := 1) rfl (Nat.lt_succ_self 1) a (by
        show InTurn.drawn (fun _ z => z + z) rules 2 1 1 1 _ = InTurn.drawn (fun _ z => z + z) rules 2 1 1 1 _
        rw [none, none])
    have drawnOne : ∀ w, InTurn.drawn (fun _ z => z + z) rules 2 0 1 1 w = w := fun w =>
      congrArg (fun x => w - x + 0) (last 0 (Nat.zero_lt_succ 1) w)
    have laterOne : ∀ b, InTurn.later (fun _ z => z + z) rules 2 0 1 0 b = (b - 1) + (b - 1) := fun b =>
      (drawnOne _).trans (by
        show rules 1 0 b + rules 1 0 b = _
        rw [sec])
    have pick := perfect.2 0 1 rfl 0 (Nat.zero_lt_succ 1) 3 3 (Nat.zero_le 3) (Nat.le_refl 3)
    have three : rules 0 0 3 = 3 := only_three (rules 0 0 3) (perfect.1 0 0 3).2 (by
      rw [laterOne, laterOne] at pick
      exact pick)
    have four : InTurn.levels (fun _ z => z + z) rules 2 3 1 = 4 := by
      show rules 1 0 (rules 0 0 3) + rules 1 0 (rules 0 0 3) = 4
      rw [three, sec]
    ⟨three, Nat.le_succ 2,
     Nat.le_trans (Nat.le_trans (Nat.le_succ 2) (Nat.le_succ 3)) (Nat.le_of_eq four.symm)⟩,
   fun rules perfect =>
    (Web.drained_broken (W := web (onSource (InTurn.levels (fun _ z => z + z) rules 2 3)))
      (c := Place.source) (f := Formation.dweller) (Nat.le_succ 1) (fun d t a => (perfect.1 d t a).2)
      (fun _ lt => InTurn.perfect_ends (Nat.le_refl 2) perfect lt 0 (Nat.zero_lt_succ 1)) (fun _ _ => rfl)
      (Nat.succ_pos 1) trivial (Nat.succ_pos 1) (Nat.le_succ 2)).1⟩
