
/-! #### When drawing everything is perfect, and whom restraint pays

`drains` assumed that each portion returns less than one for one. Its converse is exact: drawing
everything is perfect exactly where no drawer's portion of what stands next returns more than one for
one on what it alone leaves, the others drawing everything (`drain_perfect_iff`). In whole amounts
the premise of `drains` says more than it seems: a unit left returns less than a unit, so nothing,
and a portion never rises with what is left (`portion_falls`); then no profile draws any drawer more
than drawing everything (`drain_most`), and what the drain breaks lies beyond every drawer. Where the
drain is perfect and yet a profile holding the level draws each drawer more at every later step than
the drained base gives, it draws every drawer more over a long enough horizon (`holding_draws_more`),
and no profile leaving something at the last step is perfect (`last_draws`). A drawer whose portion
is all that stands finds the drain imperfect wherever the whole returns more than one for one
(`whole_not_drained`); one drawer given the whole drains exactly where the whole never does
(`whole_perfect_iff`). -/

/-- What drawer `d` draws over the steps after `t`, having left `b` there while the others draw
everything: its portion of what stands next from `b`, and its portions of what stands at nothing
after. -/
theorem later_drained {d t c z b : Nat} (dk : d < k) :
    later G portion (fun _ _ _ => 0) k d (c + 1) t z b =
      portion d (t + 1) (G t b) + drawn G portion (fun _ _ _ => 0) k d c (t + 1 + 1) (G (t + 1) 0) :=
  (drawn_step (G := G) dk (fun _ _ _ => rfl) c _).trans
    (congrArg (fun x => portion d (t + 1) (G t x) + drawn G portion (fun _ _ _ => 0) k d c (t + 1 + 1) (G (t + 1) 0))
      ((sumTo_set (f := fun _ => 0) dk).trans
        ((congrArg (· + b) (sumTo_zero fun _ _ => ite_self 0)).trans (Nat.zero_add b))))

/-- From `t + 1 < N`, the steps after `t` to the horizon, one more than some `m`. -/
theorem steps_after {t N : Nat} (lt : t + 1 < N) : ∃ m, t + (m + 1) + 1 = N :=
  match le_dest lt with
  | ⟨m, h⟩ => ⟨m, (Nat.add_assoc t (m + 1) 1).trans ((congrArg (t + ·) (Nat.add_comm m 2)).trans
      ((Nat.add_assoc t 2 m).symm.trans h.symm))⟩

/-- **Drawing everything is perfect exactly where no portion returns more than one for one.** With no
floor, the profile drawing everything is perfect over `N` steps exactly where, at every step before
the last, of what stands next from `b` that drawer `d` alone leaves of its portion, the others drawing
everything, `d`'s portion is at most its portion of what stands at nothing, and `b`. The converse of
`drains`: where some drawer's portion returns more than one for one on what it alone leaves, drawing
everything is not perfect. -/
theorem drain_perfect_iff :
    Perfect G portion (fun _ _ _ => 0) (fun _ _ _ => 0) k N ↔
      ∀ d, d < k → ∀ t, t + 1 < N → ∀ z b, b ≤ portion d t z →
        portion d (t + 1) (G t b) ≤ portion d (t + 1) (G t 0) + b :=
  ⟨fun perfect d dk t lt z b le =>
    match steps_after lt with
    | ⟨m, at_⟩ =>
      have best := perfect.2 t (m + 1) at_ d dk z b (Nat.zero_le b) le
      have best' : portion d t z - b + (portion d (t + 1) (G t b) + drawn G portion (fun _ _ _ => 0) k d m
          (t + 1 + 1) (G (t + 1) 0)) ≤ portion d t z + (portion d (t + 1) (G t 0) + drawn G portion
          (fun _ _ _ => 0) k d m (t + 1 + 1) (G (t + 1) 0)) := by
        rw [later_drained dk, later_drained dk] at best
        exact best
      have added := Nat.add_le_add_right best' b
      by
        rw [Nat.add_right_comm (portion d t z - b), Naturals.sub_add_cancel le, Nat.add_assoc (portion d t z),
          Nat.add_right_comm (portion d (t + 1) (G t 0))] at added
        exact Naturals.le_of_add_le_add_right (Naturals.le_of_add_le_add_left added),
   fun returns => ⟨fun _ _ _ => ⟨Nat.le_refl 0, Nat.zero_le _⟩, fun t j at_ d dk z b _ le =>
    match j, at_ with
    | 0, _ => Nat.add_le_add_right (Nat.sub_le _ b) 0
    | m + 1, at_ =>
      have lt : t + 1 < N := Nat.lt_of_lt_of_le
        (Nat.add_lt_add_left (Nat.succ_lt_succ (Nat.succ_pos m)) t) (Nat.le_of_eq at_)
      have ret := returns d dk t lt z b le
      by
        show portion d t z - b + later G portion (fun _ _ _ => 0) k d (m + 1) t z b ≤
          portion d t z + later G portion (fun _ _ _ => 0) k d (m + 1) t z 0
        rw [later_drained dk, later_drained dk]
        exact Nat.le_trans (Nat.add_le_add_left (Nat.add_le_add_right ret _) _) (Nat.le_of_eq (by
          rw [Nat.add_right_comm (portion d (t + 1) (G t 0)) b, ← Nat.add_assoc (portion d t z - b),
            Nat.add_right_comm (portion d t z - b), Naturals.sub_add_cancel le]))⟩⟩

/-- **Where each portion returns less than one for one, a portion never rises with what is left.** In
whole amounts a unit left returns less than a unit, so nothing: at every step before the last, a
drawer's portion of what stands next from `x + b` is at most its portion from `x`. -/
theorem portion_falls (returns : ReturnsLess G portion k N) {d t : Nat} (dk : d < k) (lt : t + 1 < N) :
    ∀ b x, portion d (t + 1) (G t (x + b)) ≤ portion d (t + 1) (G t x)
  | 0, _ => Nat.le_refl _
  | b + 1, x => Nat.le_trans (Nat.le_of_lt_succ (returns d dk t lt (x + b) 1 (Nat.succ_pos 0)))
      (portion_falls returns dk lt b x)

/-- **Where each portion returns less than one for one, drawing everything draws each drawer the
most.** Along every profile whatever, over the steps from `t` to the horizon, drawer `d` draws at most
what it draws where every drawer draws everything: what one leaves returns to no drawer, so restraint
pays none of them. -/
theorem drain_most (returns : ReturnsLess G portion k N) {rules : Nat → Nat → Nat → Nat} {d : Nat}
    (dk : d < k) :
    ∀ j t, t + j = N → ∀ z, drawn G portion rules k d j t z ≤ drawn G portion (fun _ _ _ => 0) k d j t z
  | 0, _, _, _ => Nat.le_refl 0
  | j + 1, t, at_, z =>
    have ih := drain_most returns dk j (t + 1) ((Nat.add_right_comm t 1 j).trans at_)
    have fall : ∀ x, drawn G portion (fun _ _ _ => 0) k d j (t + 1) (G t x) ≤
        drawn G portion (fun _ _ _ => 0) k d j (t + 1) (G t 0) := fun x =>
      match j, at_ with
      | 0, _ => Nat.le_refl 0
      | m + 1, at_ => by
        rw [drawn_step dk (fun _ _ _ => rfl) m, drawn_step dk (fun _ _ _ => rfl) m]
        exact Nat.add_le_add_right (Nat.le_trans
          (Nat.le_of_eq (congrArg (fun y => portion d (t + 1) (G t y)) (Nat.zero_add x).symm))
          (portion_falls returns dk (Nat.lt_of_lt_of_le
            (Nat.add_lt_add_left (Nat.succ_lt_succ (Nat.succ_pos m)) t) (Nat.le_of_eq at_)) x 0)) _
    Nat.le_trans (Nat.add_le_add (Nat.sub_le _ _) (Nat.le_trans (ih _) (fall _)))
      (Nat.le_of_eq (drawn_step dk (fun _ _ _ => rfl) j z).symm)

/-- **At the last step a perfect profile draws everything.** With no floor, in a perfect profile every
drawer draws all of its portion at the horizon's last step: a profile leaving something there is not
perfect. -/
theorem last_draws {rules : Nat → Nat → Nat → Nat} (perfect : Perfect G portion (fun _ _ _ => 0) rules k N)
    {t : Nat} (at_ : t + 1 = N) {d : Nat} (dk : d < k) (z : Nat) : rules d t (portion d t z) = 0 :=
  InTurn.leaves_floor (C := fun _ => 0) (Nat.zero_le _) (perfect.1 d t _).2
    (perfect.2 t 0 at_ d dk z 0 (Nat.le_refl 0) (Nat.zero_le _)) rfl

/-- What drawer `d` draws over `j` steps after `t` where every drawer draws everything, together with
`j`, is at most what it draws along a profile holding the level `y`, where at each of those steps it
draws more than its portion of what stands at nothing gives. -/
theorem drained_add_le {rules : Nat → Nat → Nat → Nat} {y d : Nat} (dk : d < k)
    (holds : ∀ t, next G portion rules k t y = y)
    (more : ∀ t, portion d (t + 1) (G t 0) < portion d (t + 1) y - rules d (t + 1) (portion d (t + 1) y)) :
    ∀ j t, drawn G portion (fun _ _ _ => 0) k d j (t + 1) (G t 0) + j ≤ drawn G portion rules k d j (t + 1) y
  | 0, _ => Nat.le_refl 0
  | j + 1, t => by
    rw [drawn_step dk (fun _ _ _ => rfl) j]
    show _ ≤ portion d (t + 1) y - rules d (t + 1) (portion d (t + 1) y) +
      drawn G portion rules k d j (t + 1 + 1) (next G portion rules k (t + 1) y)
    rw [holds (t + 1), Nat.add_comm j 1, Nat.add_add_add_comm]
    exact Nat.add_le_add (more t) (drained_add_le dk holds more j (t + 1))

/-- **Holding the level draws each drawer more than drawing everything.** Along a profile under which
what stands at every step is the level `y` it started at, where drawer `d` draws at each step after the
first more than its portion of what stands at nothing gives, over `n + 1` steps with its first portion
below `n`, it draws more than where every drawer draws everything. -/
theorem holding_draws_more {rules : Nat → Nat → Nat → Nat} {y d n : Nat} (dk : d < k)
    (holds : ∀ t, next G portion rules k t y = y)
    (more : ∀ t, portion d (t + 1) (G t 0) < portion d (t + 1) y - rules d (t + 1) (portion d (t + 1) y))
    (long : portion d 0 y < n) :
    drawn G portion (fun _ _ _ => 0) k d (n + 1) 0 y < drawn G portion rules k d (n + 1) 0 y := by
  rw [drawn_step dk (fun _ _ _ => rfl) n]
  show _ < portion d 0 y - rules d 0 (portion d 0 y) + drawn G portion rules k d n (0 + 1) (next G portion rules k 0 y)
  rw [holds 0]
  exact Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le (Nat.add_lt_add_right long _)
    (Nat.le_of_eq (Nat.add_comm n _))) (Nat.le_trans (drained_add_le dk holds more n 0) (Nat.le_add_left _ _))

/-- **For a drawer given all that stands, drawing everything is not perfect where the whole returns more than one
for one.**
Where drawer `d`'s portion at the step after `t` is all that stands then, and what stands from `b` it
can leave exceeds what stands from nothing by more than `b`, drawing everything is not perfect. -/
theorem whole_not_drained {d t z b : Nat} (dk : d < k) (lt : t + 1 < N)
    (whole : ∀ y, portion d (t + 1) y = y) (within : b ≤ portion d t z) (more : G t 0 + b < G t b) :
    ¬ Perfect G portion (fun _ _ _ => 0) (fun _ _ _ => 0) k N := fun perfect =>
  have le := drain_perfect_iff.1 perfect d dk t lt z b within
  by
    rw [whole, whole] at le
    exact Nat.not_le_of_gt more le

/-- **One drawer given the whole drains exactly where the whole never returns more than one for one.**
For a single drawer whose portion is all that stands, drawing everything is perfect over `N` steps
exactly where, at every step before the last, what stands from any `b` left is at most what stands
from nothing, and `b`. -/
theorem whole_perfect_iff :
    Perfect G (fun _ _ z => z) (fun _ _ _ => 0) (fun _ _ _ => 0) 1 N ↔
      ∀ t, t + 1 < N → ∀ b, G t b ≤ G t 0 + b :=
  ⟨fun perfect t lt b => drain_perfect_iff.1 perfect 0 Nat.zero_lt_one t lt b b (Nat.le_refl b),
   fun whole => drain_perfect_iff.2 fun _ _ t lt _ b _ => whole t lt b⟩
