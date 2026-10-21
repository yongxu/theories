/-- **A course gaining the most against every open course.** At each step to the `n`-th the level
`h` leaves gains, weighted, at least what the level any course open from `s` leaves there does. -/
def GainsMost (w R : Nat → Nat) (k s n : Nat) (h : Nat → Nat) : Prop :=
  ∀ x, OpenCourse R k s x → ∀ t, t < n →
    w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * h (t + 1) ≤
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * x (t + 1)

/-- A course whose level gains at each step to the `n`-th at least what any level does gains the
most against every open course. -/
theorem gainsMost_of_greatest {h : Nat → Nat}
    (greatest : ∀ t, t < n → ∀ z, w (t + 1) * (z + R z) + w t * h (t + 1) ≤
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * z) : GainsMost w R k s n h :=
  fun x _ t lt => greatest t lt (x (t + 1))

/-- **A course gaining the most against every open course is an optimum.** Where an open course from
`s` leaves nothing at the last step and gains the most against every open course, it is an optimum,
among the open courses, of the order by the weighted draw across `n + 1` steps. -/
theorem frontier_of_gainsMost {h : Nat → Nat} (opens : OpenCourse R k s h) (ends : h (n + 1) = 0)
    (most : GainsMost w R k s n h) :
    Frontier (OpenCourse R k s)
      (fun b a => weightedOver w R a (n + 1) < weightedOver w R b (n + 1)) h :=
  ⟨opens, fun b openB more => Nat.not_le_of_gt more
    (weighted_le_of_gains (fun t => (openB.2 t).1) (fun t => (opens.2 t).1)
      (openB.1.trans opens.1.symm) ends (most b openB))⟩

/-- **Every optimum gains what a course gaining the most gains, and leaves nothing weighted.** Under
the premises of `frontier_of_gainsMost`, every optimum of every order on the courses open from the
start that rises with the weighted draw across `n + 1` steps leaves, weighted at the last step,
nothing, and at each step to the `n`-th leaves a level gaining what that course's level gains. -/
theorem frontier_gains_of_most {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (rising : ∀ a b, weightedOver w R a (n + 1) < weightedOver w R b (n + 1) → better b a)
    {h : Nat → Nat} (opens : OpenCourse R k s h) (ends : h (n + 1) = 0)
    (most : GainsMost w R k s n h) {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) :
    w n * x (n + 1) = 0 ∧ ∀ t, t < n →
      w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * h (t + 1) =
        w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * x (t + 1) :=
  have gains := most x front.1
  have outdrawn : ¬ ((∃ j, j < n ∧ w (j + 1) * (x (j + 1) + R (x (j + 1))) + w j * h (j + 1) <
      w (j + 1) * (h (j + 1) + R (h (j + 1))) + w j * x (j + 1)) ∨ 0 < w n * x (n + 1)) :=
    fun short => front.2 _ opens (rising x _ (weighted_lt_of_gains (fun t => (front.1.2 t).1)
      (fun t => (opens.2 t).1) (front.1.1.trans opens.1.symm) ends gains short))
  ⟨match Nat.eq_zero_or_pos (w n * x (n + 1)) with
    | .inl zero => zero
    | .inr pos => absurd (Or.inr pos) outdrawn,
   fun t lt => match Nat.lt_or_ge (w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * h (t + 1))
      (w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * x (t + 1)) with
    | .inl less => absurd (Or.inl ⟨t, lt, less⟩) outdrawn
    | .inr ge => Nat.le_antisymm (gains t lt) ge⟩

