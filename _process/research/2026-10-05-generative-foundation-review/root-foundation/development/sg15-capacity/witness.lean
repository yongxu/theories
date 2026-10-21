

/-- The first leaves everything at the first step from two up and draws everything otherwise. -/
def keepsFirst : Nat → Nat → Nat
  | 0, z => if 2 ≤ z then z else 0
  | _ + 1, _ => 0

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
stands after a step is twice what is left; over two steps, the first can take any amount and the
second one unit a step. The profile in which the first leaves everything at the first step from two
up, and draws everything otherwise, and the second takes its unit, is perfect within these
capacities. In every profile perfect within them, from three the first leaves everything at the first
step, the second takes its unit, and the source stands at four after it: a dweller needing two,
met at three, is kept across the first step. Where neither draw is limited, every perfect profile
breaks it there (`Web.perfect_broken`). -/
theorem doubling_capacity :
    InTurn.PerfectWithin (fun _ z => z + z) (fun _ _ => 0) (fun _ a => a - 1) keepsFirst (fun _ a => a - 1) 2 ∧
    (∀ first second, InTurn.PerfectWithin (fun _ z => z + z) (fun _ _ => 0) (fun _ a => a - 1) first second 2 →
      first 0 3 = 3 ∧ (web (onSource (InTurn.levels (fun _ z => z + z) first second 3))).Kept 0
        .dweller .source) ∧
    ∀ first second, InTurn.PerfectWithin (fun _ z => z + z) (fun _ _ => 0) (fun _ _ => 0) first second 2 →
      (web (onSource (InTurn.levels (fun _ z => z + z) first second 3))).Broken 0 .dweller .source :=
  ⟨⟨fun t z => ⟨Nat.zero_le _, keepsFirst_le t z⟩, fun _ a => ⟨Nat.le_refl _, Nat.sub_le a 1⟩,
    fun t j at_ => match t, j, at_ with
      | 0, 0, h => absurd h (by decide)
      | 0, j + 2, h => absurd h (Nat.ne_of_gt (Nat.succ_le_succ
          (Nat.succ_le_succ (Nat.succ_le_succ (Nat.zero_le (0 + j))))))
      | 0, 1, _ => ⟨fun a _ low _ => sub_le_sub_left_of_le low a,
          fun z a _ le => keepsFirst_best z a le⟩
      | 1, 0, _ => ⟨fun a _ low _ => sub_le_sub_left_of_le low a,
          fun z a _ _ => Nat.sub_le z a⟩
      | 1, j + 1, h => absurd h (Nat.ne_of_gt (Nat.succ_le_succ (Nat.succ_le_succ (Nat.le_add_right 1 j))))
      | t + 2, j, h => absurd h (Nat.ne_of_gt (Nat.succ_le_succ
          (Nat.le_trans (Nat.le_add_left 2 t) (Nat.le_add_right (t + 2) j))))⟩,
   fun first second perfect =>
    have last := InTurn.last_at_floor perfect (t := 1) rfl
    have none : ∀ w, InTurn.secondDrawn (fun _ z => z + z) first second 1 1 w = 0 := fun w => by
      show first 1 w - second 1 (first 1 w) + 0 = 0
      rw [last.1 w, last.2 0]
    have sec : ∀ a, second 0 a = a - 1 := InTurn.second_at_floor perfect.2.1 none (perfect.2.2 0 1 rfl)
    have drawn : ∀ w, InTurn.firstDrawn (fun _ z => z + z) first second 1 1 w = w := fun w => by
      show w - first 1 w + 0 = w
      rw [last.1 w]
      try rfl
    have pick := (perfect.2.2 0 1 rfl).2 3 3 (Nat.zero_le 3) (Nat.le_refl 3)
    have three : first 0 3 = 3 := only_three (first 0 3) (perfect.1 0 3).2 (by
      have whole : InTurn.firstDrawn (fun _ z => z + z) first second 2 0 3 =
          3 - first 0 3 + ((first 0 3 - 1) + (first 0 3 - 1)) := by
        show 3 - first 0 3 + InTurn.firstDrawn (fun _ z => z + z) first second 1 1
          (second 0 (first 0 3) + second 0 (first 0 3)) = _
        rw [drawn, sec]
      rw [drawn, sec, whole] at pick
      exact pick)
    have four : InTurn.levels (fun _ z => z + z) first second 3 1 = 4 := by
      show second 0 (first 0 3) + second 0 (first 0 3) = 4
      rw [three, sec]
    ⟨three, Nat.le_succ 2,
     Nat.le_trans (Nat.le_trans (Nat.le_succ 2) (Nat.le_succ 3)) (Nat.le_of_eq four.symm)⟩,
   fun first second perfect =>
    (Web.perfect_broken (W := web (onSource (InTurn.levels (fun _ z => z + z) first second 3)))
      (c := Place.source) (f := Formation.dweller) (InTurn.within_zero_iff.1 perfect) (fun _ _ => rfl)
      (Nat.succ_pos 1) trivial (Nat.succ_pos 1) (Nat.le_succ 2)).1⟩
