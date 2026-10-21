/-! ## What keeping a dependence forgoes over a horizon

Above, every optimum of an order rising with what is drawn holds a level of greatest renewal. Here
a condition is kept at a need `m` or above through the `n + 1` steps of a horizon. Where what is
given at or above `m` is at most `q`, what a course keeping it draws, with what it leaves, is at
most the start with what is given there and `q` for each step after; among the courses keeping it,
the optima of every order rising with what is drawn hold a level where `q` is given and leave
exactly `m`. Against the course holding a level where `r` is given and leaving nothing, keeping
forgoes `(r - q) n + m`. So an order adding to what a keeping course draws a coupling below that
has only optima falling below the need within the horizon, and one adding more to a keeping course
and nothing to a course falling below the need has only optima keeping it; where the worth adds
exactly the coupling, both have optima, so neither holds vacuously. Where `q < r`, what
keeping forgoes grows with the horizon, and every coupling below the horizon with the need is
outweighed. The courses that attain these bounds draw nothing after the horizon, so nothing is
supposed about what lies beyond it; where the capacity cannot draw down to nothing or to the need,
the end `e` it can reach enters the thresholds. -/

namespace Optimum

/-- A course keeps its level at `m` or above through the `n + 1` steps of a horizon. -/
def Keeps (m n : Nat) (x : Nat → Nat) : Prop := ∀ t, t ≤ n + 1 → m ≤ x t

/-- A step at most one past `n` is at most `n` or one past it. -/
theorem le_or_eq_succ {t n : Nat} (le : t ≤ n + 1) : t ≤ n ∨ t = n + 1 :=
  match Nat.lt_or_ge t (n + 1) with
  | .inl lt => .inl (Nat.le_of_lt_succ lt)
  | .inr ge => .inr (Nat.le_antisymm le ge)

variable {R : Nat → Nat} {k q r s y m n : Nat}

/-- **What a course keeping a need draws and leaves.** Where each step leaves at most the level with
what `R` gives there, `R` gives at most `q` at every level at or above `m`, and a course keeps its
level at `m` or above through `n + 1` steps, what it draws across them with what it leaves is at
most its start with what is given there and `q` for each step after. -/
theorem keeping_le_most (above : ∀ z, m ≤ z → R z ≤ q) {x : Nat → Nat}
    (within : ∀ t, x (t + 1) ≤ x t + R (x t)) (keeps : Keeps m n x) :
    drawnOver R x (n + 1) + x (n + 1) ≤ x 0 + R (x 0) + q * n :=
  Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq
    (drawn_add_shortfall_after_up_to (x := x) (g := fun t => R (x t)) (r := q) (n := n) within
      fun t lt => above _ (keeps (t + 1) (Nat.succ_le_succ (Nat.le_of_lt lt)))))

/-- What a course keeping a need draws, with the need, is at most its start with what is given there
and `q` for each step after. -/
theorem keeping_drawn_le (above : ∀ z, m ≤ z → R z ≤ q) {x : Nat → Nat}
    (within : ∀ t, x (t + 1) ≤ x t + R (x t)) (keeps : Keeps m n x) :
    drawnOver R x (n + 1) + m ≤ x 0 + R (x 0) + q * n :=
  Nat.le_trans (Nat.add_le_add_left (keeps (n + 1) (Nat.le_refl _)) _)
    (keeping_le_most above within keeps)

/-- **What the course holding a level draws.** Where `R` gives `r` at `y`, within the start with
what is given there, the course holding `y` to the `n`-th step and ending at `e` at most `y` draws
across `n + 1` steps, with `e`, the start with what is given there and `r` for each step after. -/
theorem holdingTo_most {e : Nat} (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y)
    (n : Nat) : drawnOver R (holdingTo s y e n) (n + 1) + e = s + R s + r * n := by
  have whole := drawn_add_shortfall_after_up_to (x := holdingTo s y e n)
    (g := fun t => R (holdingTo s y e n t)) (r := r) (n := n) (holdingTo_within reach settles)
    fun t lt => Nat.le_of_eq ((congrArg R (holdingTo_before lt)).trans greatest)
  have none : Amounts.whole.sum (fun t => r - R (holdingTo s y e n (t + 1))) 0 n = 0 :=
    sum_eq_zero_iff.mpr fun t lt =>
      (congrArg (fun z => r - R z) (holdingTo_before lt)).trans
        ((congrArg (r - ·) greatest).trans (Nat.sub_self r))
  rw [holdingTo_after (Nat.le_refl n), none, Nat.add_zero] at whole
  exact whole

/-- The course holding `y` at or above `m`, from a start at or above `m` and ending at `e` at or
above `m`, keeps its level at `m` or above. -/
theorem holdingTo_keeps {e : Nat} (meets : m ≤ s) (needs : m ≤ y) (ends : m ≤ e) :
    Keeps m n (holdingTo s y e n) :=
  fun t _ => match t with
  | 0 => meets
  | t + 1 => match Nat.lt_or_ge t n with
    | .inl before => Nat.le_trans needs (Nat.le_of_eq (holdingTo_before before).symm)
    | .inr after => Nat.le_trans ends (Nat.le_of_eq (holdingTo_after after).symm)

/-- The course `x` through the `n + 1` steps of a horizon, drawing nothing after them. -/
def continued (R : Nat → Nat) (x : Nat → Nat) (n : Nat) : Nat → Nat
  | 0 => x 0
  | t + 1 => if t ≤ n then x (t + 1) else continued R x n t + R (continued R x n t)

/-- The continued course stands where the course does through the horizon. -/
theorem continued_le {x : Nat → Nat} : ∀ {t : Nat}, t ≤ n + 1 → continued R x n t = x t
  | 0, _ => rfl
  | _ + 1, le => if_pos (Nat.le_of_succ_le_succ le)

/-- After the horizon the continued course draws nothing. -/
theorem continued_after {x : Nat → Nat} {t : Nat} (after : n < t) :
    continued R x n (t + 1) = continued R x n t + R (continued R x n t) :=
  if_neg (Nat.not_le_of_gt after)

/-- **A course open through the horizon continues openly.** A course from `s` whose steps to the
`n`-th leave at most the level with what is given and draw at most `k`, continued by drawing
nothing after them, is open. -/
theorem continued_open {x : Nat → Nat} (start : x 0 = s)
    (steps : ∀ t, t ≤ n → x (t + 1) ≤ x t + R (x t) ∧ drawnAt x (fun t => R (x t)) t ≤ k) :
    OpenCourse R k s (continued R x n) :=
  ⟨start, fun t => match Nat.lt_or_ge n t with
    | .inr le => by
      show continued R x n (t + 1) ≤ continued R x n t + R (continued R x n t) ∧
        continued R x n t + R (continued R x n t) - continued R x n (t + 1) ≤ k
      rw [continued_le (Nat.le_succ_of_le le), continued_le (Nat.succ_le_succ le)]
      exact steps t le
    | .inl after => by
      show continued R x n (t + 1) ≤ continued R x n t + R (continued R x n t) ∧
        continued R x n t + R (continued R x n t) - continued R x n (t + 1) ≤ k
      rw [continued_after after, Nat.sub_self]
      exact ⟨Nat.le_refl _, Nat.zero_le k⟩⟩

/-- The continued course draws across the horizon what the course draws. -/
theorem continued_drawn {x : Nat → Nat} :
    drawnOver R (continued R x n) (n + 1) = drawnOver R x (n + 1) :=
  sum_eq_of_eq fun t lt => by
    show continued R x n t + R (continued R x n t) - continued R x n (t + 1) =
      x t + R (x t) - x (t + 1)
    rw [continued_le (Nat.le_succ_of_le (Nat.le_of_lt_succ lt)),
      continued_le (Nat.succ_le_succ (Nat.le_of_lt_succ lt))]

/-- The continued course keeps its level at `m` or above through the horizon where the course
does. -/
theorem continued_keeps {x : Nat → Nat} (keeps : Keeps m n x) : Keeps m n (continued R x n) :=
  fun t le => Nat.le_trans (keeps t le) (Nat.le_of_eq (continued_le le).symm)

/-- Comparing worths below what keeping forgoes. -/
theorem lt_of_forgone_below {A D Wa Da S w q' r' e : Nat} (coupled : A ≤ D + w)
    (kept : D + m ≤ S + q') (most : Da + e = S + r') (draws : Da ≤ Wa)
    (below : w + q' + e < r' + m) : A < Wa := by
  have less : A + (m + e) < Wa + (m + e) :=
    calc A + (m + e) ≤ D + w + (m + e) := Nat.add_le_add_right coupled _
      _ = D + m + (w + e) := by
        rw [Nat.add_assoc D w, Nat.add_assoc D m, Nat.add_left_comm w m e]
      _ ≤ S + q' + (w + e) := Nat.add_le_add_right kept _
      _ = S + (w + q' + e) := by
        rw [Nat.add_assoc S q' (w + e), Nat.add_left_comm q' w e, Nat.add_assoc w q' e]
      _ < S + (r' + m) := Nat.add_lt_add_left below _
      _ = Da + e + m := by rw [← Nat.add_assoc, ← most]
      _ ≤ Wa + e + m := Nat.add_le_add_right (Nat.add_le_add_right draws e) m
      _ = Wa + (m + e) := by rw [Nat.add_assoc, Nat.add_comm e m]
  exact Nat.lt_of_add_lt_add_right less

/-- Comparing worths beyond what keeping forgoes. -/
theorem lt_of_forgone_beyond {A D Wa Da S w q' r' e : Nat} (uncoupled : A ≤ D)
    (bound : D ≤ S + r') (most : Da + e = S + q') (coupled : Da + w ≤ Wa)
    (beyond : r' + e < w + q') : A < Wa := by
  have less : A + e < Wa + e :=
    calc A + e ≤ S + r' + e := Nat.add_le_add_right (Nat.le_trans uncoupled bound) e
      _ = S + (r' + e) := Nat.add_assoc _ _ _
      _ < S + (w + q') := Nat.add_lt_add_left beyond _
      _ = Da + e + w := by rw [Nat.add_comm w q', ← Nat.add_assoc, ← most]
      _ = Da + w + e := Nat.add_right_comm _ _ _
      _ ≤ Wa + e := Nat.add_le_add_right coupled e
  exact Nat.lt_of_add_lt_add_right less

/-- **Among the courses keeping a need, the optima hold its greatest renewal and leave the need.**
Where `R` gives at most `q` at every level at or above `m` and `q` at some `y` at or above `m`
within the start with what is given there, from a start meeting `m`, over a horizon of at least two
steps, with a capacity covering what the first step draws down to `y` and `y` with `q` down to
`m`: every optimum, among the open courses keeping their level at `m` or above through the horizon,
of every order rising with what is drawn across `n + 1` steps stands where `R` gives `q` at every
step to the `n`-th and at `m` after the last. -/
theorem frontier_keeps {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (above : ∀ z, m ≤ z → R z ≤ q)
    (rising : ∀ a b, drawnOver R a (n + 1) < drawnOver R b (n + 1) → better b a)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ m + k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (fun a => OpenCourse R k s a ∧ Keeps m n a) better x) :
    x (n + 1) = m ∧ ∀ t, t < n → R (x (t + 1)) = q := by
  have opens : OpenCourse R k s (continued R (holdingTo s y m n) n) :=
    continued_open (x := holdingTo s y m n) rfl
      (holdingTo_steps greatest reach needs drawsDown holds long)
  have most := holdingTo_most (n := n) greatest reach needs
  have atLeast : drawnOver R (holdingTo s y m n) (n + 1) ≤ drawnOver R x (n + 1) :=
    Nat.ge_of_not_lt fun less =>
      front.2 _ ⟨opens, continued_keeps (holdingTo_keeps meets needs (Nat.le_refl m))⟩
        (rising x _ (Nat.lt_of_lt_of_le less (Nat.le_of_eq continued_drawn.symm)))
  have whole : drawnOver R x (n + 1) + x (n + 1) +
      Amounts.whole.sum (fun t => q - R (x (t + 1))) 0 n = x 0 + R (x 0) + q * n :=
    drawn_add_shortfall_after_up_to (x := x) (g := fun t => R (x t)) (r := q) (n := n)
      (fun t => (front.1.1.2 t).1)
      fun t lt => above _ (front.1.2 (t + 1) (Nat.succ_le_succ (Nat.le_of_lt lt)))
  rw [front.1.1.1, ← most, Nat.add_assoc] at whole
  have rest : x (n + 1) + Amounts.whole.sum (fun t => q - R (x (t + 1))) 0 n ≤ m :=
    Naturals.le_of_add_le_add_left (k := drawnOver R x (n + 1))
      (Nat.le_trans (Nat.le_of_eq whole) (Nat.add_le_add_right atLeast m))
  have stands : m ≤ x (n + 1) := front.1.2 (n + 1) (Nat.le_refl _)
  have none : Amounts.whole.sum (fun t => q - R (x (t + 1))) 0 n = 0 :=
    Nat.le_antisymm (Naturals.le_of_add_le_add_left (k := x (n + 1))
      (Nat.le_trans rest (Nat.le_trans stands (Nat.le_of_eq (Nat.add_zero _).symm))))
      (Nat.zero_le _)
  exact ⟨Nat.le_antisymm (Nat.le_trans (Nat.le_add_right _ _) rest) stands, fun t lt =>
    Nat.le_antisymm (above _ (front.1.2 (t + 1) (Nat.succ_le_succ (Nat.le_of_lt lt))))
      (le_of_sub_zero (sum_eq_zero_iff.mp none t lt))⟩

/-- A course from a start meeting `m` either keeps its level at `m` or above through the `n + 1`
steps of a horizon or falls below `m`, at some step to the `n`-th, from a level meeting it. -/
theorem keeps_or_drops {x : Nat → Nat} (start : m ≤ x 0) :
    ∀ n, Keeps m n x ∨ ∃ t, t ≤ n ∧ m ≤ x t ∧ x (t + 1) < m
  | 0 => match Nat.lt_or_ge (x 1) m with
    | .inl lt => .inr ⟨0, Nat.le_refl 0, start, lt⟩
    | .inr ge => .inl fun t le => match le_or_eq_succ le with
      | .inl first => Eq.subst (motive := fun z => m ≤ x z)
          (Nat.le_antisymm first (Nat.zero_le t)).symm start
      | .inr second => Eq.subst (motive := fun z => m ≤ x z) second.symm ge
  | n + 1 => match keeps_or_drops start n with
    | .inr ⟨t, le, met, lt⟩ => .inr ⟨t, Nat.le_succ_of_le le, met, lt⟩
    | .inl keeps => match Nat.lt_or_ge (x (n + 1 + 1)) m with
      | .inl lt => .inr ⟨n + 1, Nat.le_refl _, keeps (n + 1) (Nat.le_refl _), lt⟩
      | .inr ge => .inl fun t le => match le_or_eq_succ le with
        | .inl earlier => keeps t earlier
        | .inr last => Eq.subst (motive := fun z => m ≤ x z) last.symm ge

/-- A course from a start meeting `m` that does not keep its level at `m` or above through the
horizon falls below `m`, at some step to the `n`-th, from a level meeting it. -/
theorem drops_of_not_keeps {x : Nat → Nat} (start : m ≤ x 0) (fails : ¬ Keeps m n x) :
    ∃ t, t ≤ n ∧ m ≤ x t ∧ x (t + 1) < m :=
  match keeps_or_drops start n with
  | .inl keeps => absurd keeps fails
  | .inr drops => drops

/-- A course either keeps its level at `m` or above through the `n + 1` steps of a horizon or stands
below `m` at some step through them. -/
theorem keeps_or_below {x : Nat → Nat} : Keeps m n x ∨ ∃ t, t ≤ n + 1 ∧ x t < m :=
  match Nat.lt_or_ge (x 0) m with
  | .inl lt => .inr ⟨0, Nat.zero_le _, lt⟩
  | .inr start => match keeps_or_drops start n with
    | .inl keeps => .inl keeps
    | .inr ⟨t, le, _, lt⟩ => .inr ⟨t + 1, Nat.succ_le_succ le, lt⟩

/-- **The optimum among the courses keeping a need.** Under the premises of `frontier_keeps`, the
course holding `y` to the `n`-th step, standing at `m` after the last and drawing nothing after it,
is an optimum, among the open courses keeping their level at `m` or above through the horizon, of
the order by what is drawn. -/
theorem continued_keeping_frontier (above : ∀ z, m ≤ z → R z ≤ q)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ m + k) (long : 0 < n) :
    Frontier (fun a => OpenCourse R k s a ∧ Keeps m n a) (byDrawn R n)
      (continued R (holdingTo s y m n) n) :=
  have most : drawnOver R (continued R (holdingTo s y m n) n) (n + 1) + m = s + R s + q * n := by
    rw [continued_drawn]
    exact holdingTo_most greatest reach needs n
  ⟨⟨continued_open (x := holdingTo s y m n) rfl
      (holdingTo_steps greatest reach needs drawsDown holds long),
    continued_keeps (holdingTo_keeps meets needs (Nat.le_refl m))⟩,
   fun b ⟨opens, keeps⟩ more => by
    have kept := keeping_drawn_le above (fun t => (opens.2 t).1) keeps
    rw [opens.1] at kept
    exact Nat.not_le_of_gt more
      (Naturals.le_of_add_le_add_right (Nat.le_trans kept (Nat.le_of_eq most.symm)))⟩

/-- **What keeping forgoes grows with the horizon.** Where `q < r`, every coupling `w` that with an
end `e` is below the horizon with the need is below what keeping forgoes against the course leaving
`e`, `(r - q) n + m - e`, stated as `w + q n + e < r n + m`. -/
theorem forgone_grows {w e : Nat} (less : q < r) (short : w + e < n + m) :
    w + q * n + e < r * n + m :=
  have grows : q * n + n ≤ r * n :=
    Nat.le_trans (Nat.le_of_eq (Nat.succ_mul q n).symm)
      (Nat.mul_le_mul_right n (Nat.succ_le_of_lt less))
  calc w + q * n + e = q * n + (w + e) := by rw [Nat.add_right_comm, Nat.add_comm (w + e)]
    _ < q * n + (n + m) := Nat.add_lt_add_left short _
    _ = q * n + n + m := (Nat.add_assoc _ _ _).symm
    _ ≤ r * n + m := Nat.add_le_add_right grows m

/-- **A coupling below what keeping forgoes leaves no optimum keeping the need.** Where `R` gives
`r` at `y`, within the start with what is given there, over a horizon of at least two steps, with a
capacity covering what the first step draws down to `y` and `y` with `r` down to some `e` at most
`y`, and `R` gives at most `q` at every level at or above `m`: every optimum, among the open
courses, of every order rising with a worth at least what a course draws and at most `w` more for a
course keeping its level at `m` or above falls below `m` within the horizon, where
`w + q n + e < r n + m`. -/
theorem frontier_breaks_below {better : (Nat → Nat) → (Nat → Nat) → Prop}
    {worth : (Nat → Nat) → Nat} {w e : Nat}
    (rising : ∀ a b, worth a < worth b → better b a)
    (draws : ∀ a, drawnOver R a (n + 1) ≤ worth a)
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + w)
    (above : ∀ z, m ≤ z → R z ≤ q) (below : w + q * n + e < r * n + m)
    (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ e + k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : ¬ Keeps m n x := by
  intro keeps
  have opens : OpenCourse R k s (continued R (holdingTo s y e n) n) :=
    continued_open (x := holdingTo s y e n) rfl
      (holdingTo_steps greatest reach settles drawsDown holds long)
  have most : drawnOver R (continued R (holdingTo s y e n) n) (n + 1) + e = s + R s + r * n := by
    rw [continued_drawn]
    exact holdingTo_most greatest reach settles n
  have kept := keeping_drawn_le above (fun t => (front.1.2 t).1) keeps
  rw [front.1.1] at kept
  exact front.2 _ opens
    (rising x _ (lt_of_forgone_below (coupled x front.1 keeps) kept most (draws _) below))

/-- **An optimum falling below the need.** Where `R` gives at most `r` at every level, under the
premises of `frontier_breaks_below` with the course ending at nothing, and for a worth adding
nothing to what a course standing below `m` within the horizon draws: the course holding `y` to the
`n`-th step, at nothing after the last and drawing nothing after it, is an optimum, among the open
courses, of the order by the worth. -/
theorem continued_breaking_frontier {worth : (Nat → Nat) → Nat} {w : Nat}
    (draws : ∀ a, drawnOver R a (n + 1) ≤ worth a)
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + w)
    (uncoupled : ∀ a t, OpenCourse R k s a → t ≤ n + 1 → a t < m →
      worth a ≤ drawnOver R a (n + 1))
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (below : w + q * n < r * n + m)
    (greatest : R y = r) (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (fun b a => worth a < worth b) (continued R (holding s y n) n) :=
  have most : drawnOver R (continued R (holding s y n) n) (n + 1) = s + R s + r * n :=
    continued_drawn.trans (holding_most renews greatest reach n)
  ⟨continued_open (x := holding s y n) rfl (holdingTo_steps greatest reach (Nat.zero_le y)
      drawsDown (Nat.le_trans holds (Nat.le_of_eq (Nat.zero_add k).symm)) long),
   fun b opens more => Nat.not_le_of_gt more (match keeps_or_below (x := b) with
    | .inl keeps => by
      have kept := keeping_drawn_le above (fun t => (opens.2 t).1) keeps
      rw [opens.1] at kept
      exact Nat.le_of_lt (lt_of_forgone_below (e := 0) (coupled b opens keeps) kept
        ((Nat.add_zero _).trans most) (draws _) below)
    | .inr ⟨t, le, lt⟩ => Nat.le_trans (uncoupled b t opens le lt)
        (Nat.le_trans (open_le_most renews opens n)
          (Nat.le_trans (Nat.le_of_eq most.symm) (draws _))))⟩

/-- **A coupling beyond what keeping forgoes leaves no optimum falling below the need.** Where `R`
gives at most `r` at every level and `q` at some `y` within the start with what is given there, from
a start meeting `m`, over a horizon of at least two steps, with a capacity covering what the first
step draws down to `y` and `y` with `q` down to some `e` between `m` and `y`: every optimum, among
the open courses, of every order rising with a worth adding at least `w` to what a course keeping
its level at `m` or above draws and nothing to what a course falling below `m` within the horizon
draws keeps its level at `m` or above through the horizon, where `r n + e < w + q n`. -/
theorem frontier_keeps_above {better : (Nat → Nat) → (Nat → Nat) → Prop}
    {worth : (Nat → Nat) → Nat} {w e : Nat}
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → drawnOver R a (n + 1) + w ≤ worth a)
    (uncoupled : ∀ a t, OpenCourse R k s a → t ≤ n + 1 → a t < m →
      worth a ≤ drawnOver R a (n + 1))
    (renews : ∀ z, R z ≤ r) (beyond : r * n + e < w + q * n)
    (greatest : R y = q) (meets : m ≤ s) (ends : m ≤ e) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : Keeps m n x :=
  fun t le => match Nat.lt_or_ge (x t) m with
  | .inr ge => ge
  | .inl lt => by
    have opens : OpenCourse R k s (continued R (holdingTo s y e n) n) :=
      continued_open (x := holdingTo s y e n) rfl
        (holdingTo_steps greatest reach settles drawsDown holds long)
    have most : drawnOver R (continued R (holdingTo s y e n) n) (n + 1) + e =
        s + R s + q * n := by
      rw [continued_drawn]
      exact holdingTo_most greatest reach settles n
    exact absurd (rising x _ (lt_of_forgone_beyond (uncoupled x t front.1 le lt)
      (open_le_most renews front.1 n) most
      (coupled _ opens (continued_keeps (holdingTo_keeps meets (Nat.le_trans ends settles) ends)))
      beyond)) (front.2 _ opens)

/-- **An optimum keeping the need.** Where `R` gives at most `r` at every level, at most `q` at
every level at or above `m`, and `q` at some `y` at or above `m` within the start with what is given
there, from a start meeting `m`, over a horizon of at least two steps, with a capacity covering what
the first step draws down to `y` and `y` with `q` down to `m`, and for a worth adding exactly `w` to
what a course keeping its level at `m` or above draws and nothing to what a course standing below
`m` within the horizon draws, where `r n + m < w + q n`: the course holding `y` to the `n`-th step,
at `m` after the last and drawing nothing after it, is an optimum, among the open courses, of the
order by the worth. -/
theorem continued_kept_frontier {worth : (Nat → Nat) → Nat} {w : Nat}
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → drawnOver R a (n + 1) + w ≤ worth a)
    (bounded : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + w)
    (uncoupled : ∀ a t, OpenCourse R k s a → t ≤ n + 1 → a t < m →
      worth a ≤ drawnOver R a (n + 1))
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (beyond : r * n + m < w + q * n)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ m + k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (fun b a => worth a < worth b)
      (continued R (holdingTo s y m n) n) :=
  have optimum := continued_keeping_frontier above greatest needs meets reach drawsDown holds long
  have most : drawnOver R (continued R (holdingTo s y m n) n) (n + 1) + m = s + R s + q * n := by
    rw [continued_drawn]
    exact holdingTo_most greatest reach needs n
  have least := coupled _ optimum.1.1 optimum.1.2
  ⟨optimum.1.1, fun b opens more => Nat.not_le_of_gt more (match keeps_or_below (x := b) with
    | .inl keeps => Nat.le_trans (bounded b opens keeps) (Nat.le_trans (Nat.add_le_add_right
        (Nat.ge_of_not_lt (optimum.2 b ⟨opens, keeps⟩)) w) least)
    | .inr ⟨t, le, lt⟩ => Nat.le_of_lt (lt_of_forgone_beyond (uncoupled b t opens le lt)
        (open_le_most renews opens n) most least beyond))⟩

end Optimum

namespace Flow

open Optimum

variable {L : Flow F C} {W : Web F C} {c : C}

/-- **What a balanced course keeping a need takes.** Where what is given to a condition is a law
`R` of its level, at most `q` at every level at or above `m`, and the course of its levels keeps
them at `m` or above through `n + 1` steps, what is taken there across them, with `m`, is at most
the starting level with what is given there and `q` for each step after. -/
theorem Balances.keeping_taken_le {R : Nat → Nat} {q m n : Nat} (balances : L.Balances W)
    (renewal : ∀ t, L.given t c = R (W.level t c)) (above : ∀ z, m ≤ z → R z ≤ q)
    (keeps : Optimum.Keeps m n fun t => W.level t c) :
    Amounts.whole.sum (fun t => L.taken t c) 0 (n + 1) + m ≤
      W.level 0 c + R (W.level 0 c) + q * n :=
  Nat.le_trans (Nat.le_of_eq (congrArg (· + m) (sum_eq_of_eq fun t _ =>
      ((congrArg (fun z => W.level t c + z - W.level (t + 1) c) (renewal t)).symm.trans
        (balances.drawnAt_eq c t)).symm)))
    (keeping_drawn_le above (fun t => Nat.le_trans (balances.within c t)
      (Nat.le_of_eq (congrArg (W.level t c + ·) (renewal t)))) keeps)

end Flow

namespace Web

open Optimum

variable {W : Web F C} {c : C} {f : F} {R : Nat → Nat} {k q r s y m n w e : Nat}
  {better : (Nat → Nat) → (Nat → Nat) → Prop} {worth : (Nat → Nat) → Nat}

/-- **Among the courses keeping a dependence, the optima leave exactly its need.** Under the
premises of `Optimum.frontier_keeps`, with a formation's need on the condition `m` at the horizon's
last step: every optimum, among the open courses keeping the condition at `m` or above through the
horizon, of every order rising with what is drawn stands at exactly the need after the last step,
and where `R` gives `q` at every step to the `n`-th. -/
theorem frontier_keeps (above : ∀ z, m ≤ z → R z ≤ q)
    (rising : ∀ a b, drawnOver R a (n + 1) < drawnOver R b (n + 1) → better b a)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ m + k) (long : 0 < n)
    (front : Frontier (fun a => OpenCourse R k s a ∧ Optimum.Keeps m n a) better
      fun t => W.level t c)
    (need : W.need (n + 1) f c = m) :
    W.level (n + 1) c = W.need (n + 1) f c ∧ ∀ t, t < n → R (W.level (t + 1) c) = q :=
  have held := Optimum.frontier_keeps above rising greatest needs meets reach drawsDown holds long
    front
  ⟨held.1.trans need.symm, held.2⟩

/-- **A coupling below what keeping forgoes breaks the dependence within the horizon.** Under the
premises of `Optimum.frontier_breaks_below`, with a formation depending on the condition at the need
`m` at every step, met at the start: every optimum, among the open courses, of every order rising
with a worth at least what a course draws and at most `w` more for a course keeping the condition at
`m` or above breaks the dependence at some step to the `n`-th, where `w + q n + e < r n + m`. -/
theorem frontier_breaks_below
    (rising : ∀ a b, worth a < worth b → better b a)
    (draws : ∀ a, drawnOver R a (n + 1) ≤ worth a)
    (coupled : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      worth a ≤ drawnOver R a (n + 1) + w)
    (above : ∀ z, m ≤ z → R z ≤ q) (below : w + q * n + e < r * n + m)
    (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ e + k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m) (start : m ≤ s) :
    ∃ t, t ≤ n ∧ W.Broken t f c :=
  match drops_of_not_keeps (Eq.subst (motive := fun z => m ≤ z) front.1.1.symm start)
      (Optimum.frontier_breaks_below rising draws coupled above below greatest reach settles
        drawsDown holds long front) with
  | ⟨t, le, met, lt⟩ => ⟨t, le, depends t, Nat.le_trans (Nat.le_of_eq (need t)) met,
      Nat.lt_of_lt_of_le lt (Nat.le_of_eq (need t).symm)⟩

/-- **Far-sight breaks a dependence above every level of greatest renewal against every coupling
short of the horizon.** Under the premises of `Web.frontier_breaks_below`, where the renewal at or
above the need is below the greatest, `q < r`, and the coupling with the end `e` is below the
horizon with the need: every optimum breaks the dependence within the horizon. -/
theorem frontier_breaks_long
    (rising : ∀ a b, worth a < worth b → better b a)
    (draws : ∀ a, drawnOver R a (n + 1) ≤ worth a)
    (coupled : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      worth a ≤ drawnOver R a (n + 1) + w)
    (above : ∀ z, m ≤ z → R z ≤ q) (less : q < r) (short : w + e < n + m)
    (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ e + k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m) (start : m ≤ s) :
    ∃ t, t ≤ n ∧ W.Broken t f c :=
  Web.frontier_breaks_below rising draws coupled above (forgone_grows less short) greatest reach
    settles drawsDown holds long front depends need start

/-- **A coupling beyond what keeping forgoes keeps the dependence through the horizon.** Under the
premises of `Optimum.frontier_keeps_above`, with a formation's need on the condition `m` at every
step: every optimum, among the open courses, of every order rising with a worth adding at least `w`
to what a course keeping the condition at `m` or above draws and nothing to what a course falling
below `m` within the horizon draws meets the need at every step through the horizon, where
`r n + e < w + q n`. -/
theorem frontier_keeps_above
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupled : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      drawnOver R a (n + 1) + w ≤ worth a)
    (uncoupled : ∀ a t, OpenCourse R k s a → t ≤ n + 1 → a t < m →
      worth a ≤ drawnOver R a (n + 1))
    (renews : ∀ z, R z ≤ r) (beyond : r * n + e < w + q * n)
    (greatest : R y = q) (meets : m ≤ s) (ends : m ≤ e) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (need : ∀ t, W.need t f c = m) :
    ∀ t, t ≤ n + 1 → W.need t f c ≤ W.level t c :=
  fun t le => Nat.le_trans (Nat.le_of_eq (need t))
    (Optimum.frontier_keeps_above rising coupled uncoupled renews beyond greatest meets ends reach
      settles drawsDown holds long front t le)

end Web

namespace Optimum

namespace Holding

open Diversion

/-- One where a course stands at `m` or above at every step to the `T`-th, nothing otherwise. -/
def metThrough (m : Nat) (x : Nat → Nat) : Nat → Nat
  | 0 => if m ≤ x 0 then 1 else 0
  | t + 1 => if m ≤ x (t + 1) then metThrough m x t else 0

/-- A course standing at `m` or above at every step to the `T`-th is met through it. -/
theorem metThrough_of_keeps {m : Nat} {x : Nat → Nat} :
    ∀ {T : Nat}, (∀ t, t ≤ T → m ≤ x t) → metThrough m x T = 1
  | 0, keeps => show (if m ≤ x 0 then 1 else 0) = 1 from if_pos (keeps 0 (Nat.le_refl 0))
  | T + 1, keeps => show (if m ≤ x (T + 1) then metThrough m x T else 0) = 1 from
      (if_pos (keeps (T + 1) (Nat.le_refl _))).trans
        (metThrough_of_keeps fun t le => keeps t (Nat.le_succ_of_le le))

/-- A course below `m` at some step to the `T`-th is not met through it. -/
theorem metThrough_of_below {m : Nat} {x : Nat → Nat} :
    ∀ {T t : Nat}, t ≤ T → x t < m → metThrough m x T = 0
  | 0, t, le, lt => show (if m ≤ x 0 then 1 else 0) = 0 from
      if_neg (Nat.not_le_of_gt (Eq.subst (motive := fun z => x z < m)
        (Nat.le_antisymm le (Nat.zero_le t)) lt))
  | T + 1, _, le, lt => show (if m ≤ x (T + 1) then metThrough m x T else 0) = 0 from
    match le_or_eq_succ le with
    | .inl earlier => match Nat.lt_or_ge (x (T + 1)) m with
      | .inl below => if_neg (Nat.not_le_of_gt below)
      | .inr meets => (if_pos meets).trans (metThrough_of_below earlier lt)
    | .inr last => if_neg (Nat.not_le_of_gt (Eq.subst (motive := fun z => x z < m) last lt))

/-- What a course draws across `n + 1` steps under `R`, with `w` where it stands at `m` or above at
every step through them. -/
def coupledDraw (R : Nat → Nat) (m w n : Nat) (x : Nat → Nat) : Nat :=
  drawnOver R x (n + 1) + w * metThrough m x (n + 1)

/-- A course keeping its level at `m` or above through the horizon adds `w` to what it draws. -/
theorem coupledDraw_of_keeps {R : Nat → Nat} {m w n : Nat} {x : Nat → Nat} (keeps : Keeps m n x) :
    coupledDraw R m w n x = drawnOver R x (n + 1) + w :=
  congrArg (drawnOver R x (n + 1) + ·)
    ((congrArg (w * ·) (metThrough_of_keeps keeps)).trans (Nat.mul_one w))

/-- A course standing below `m` at some step through the horizon adds nothing to what it draws. -/
theorem coupledDraw_of_below {R : Nat → Nat} {m w n t : Nat} {x : Nat → Nat} (le : t ≤ n + 1)
    (below : x t < m) : coupledDraw R m w n x = drawnOver R x (n + 1) :=
  (congrArg (drawnOver R x (n + 1) + ·)
    ((congrArg (w * ·) (metThrough_of_below le below)).trans (Nat.mul_zero w))).trans
      (Nat.add_zero _)

/-- The levels with the source along a course and the store empty. -/
def onSource (x : Nat → Nat) (t : Nat) : Place → Nat
  | .source => x t
  | .store => 0

/-- Under the logistic law nothing is renewed at two or above. -/
theorem logistic_above : ∀ z, 2 ≤ z → logistic z ≤ 0 := fun _ le =>
  match le_dest le with
  | ⟨j, same⟩ => Nat.le_of_eq ((congrArg logistic (same.trans (Nat.add_comm 2 j))).trans
      (logistic_beyond j))

/-- **The logistic witness: what keeping the dweller forgoes.** From a source at two, the level the
dweller needs, under the logistic law with capacity two, keeping the dweller through `n + 2` steps
forgoes `n + 3`. Under the order by what the taker draws with `w` added where the source stays at
two or above through the horizon: where `w < n + 3`, the course drawing the source to one and then
holding it there has the greatest worth (`continued_breaking_frontier`) and every optimum breaks
the dweller's dependence within the horizon (`Web.frontier_breaks_below`); where `n + 3 < w`, the
course staying at two has the greatest worth (`continued_kept_frontier`) and every optimum keeps the
dependence met through the horizon (`Web.frontier_keeps_above`). -/
theorem logistic_coupled (n w : Nat) :
    (w < n + 3 →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => coupledDraw logistic 2 w (n + 1) a < coupledDraw logistic 2 w (n + 1) b)
        (continued logistic (holding 2 1 (n + 1)) (n + 1)) ∧
      ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => coupledDraw logistic 2 w (n + 1) a < coupledDraw logistic 2 w (n + 1) b) x →
      ∃ t, t ≤ n + 1 ∧ (web (onSource x)).Broken t .dweller .source) ∧
    (n + 3 < w →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => coupledDraw logistic 2 w (n + 1) a < coupledDraw logistic 2 w (n + 1) b)
        (continued logistic (holdingTo 2 2 2 (n + 1)) (n + 1)) ∧
      ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => coupledDraw logistic 2 w (n + 1) a < coupledDraw logistic 2 w (n + 1) b) x →
      ∀ t, t ≤ n + 2 → (web (onSource x)).need t .dweller .source ≤
        (web (onSource x)).level t .source) :=
  have draws : ∀ a, drawnOver logistic a (n + 1 + 1) ≤ coupledDraw logistic 2 w (n + 1) a :=
    fun _ => Nat.le_add_right _ _
  have bounded : ∀ a, OpenCourse logistic 2 2 a → Keeps 2 (n + 1) a →
      coupledDraw logistic 2 w (n + 1) a ≤ drawnOver logistic a (n + 1 + 1) + w :=
    fun _ _ keeps => Nat.le_of_eq (coupledDraw_of_keeps keeps)
  have coupled : ∀ a, OpenCourse logistic 2 2 a → Keeps 2 (n + 1) a →
      drawnOver logistic a (n + 1 + 1) + w ≤ coupledDraw logistic 2 w (n + 1) a :=
    fun _ _ keeps => Nat.le_of_eq (coupledDraw_of_keeps keeps).symm
  have uncoupled : ∀ a t, OpenCourse logistic 2 2 a → t ≤ n + 1 + 1 → a t < 2 →
      coupledDraw logistic 2 w (n + 1) a ≤ drawnOver logistic a (n + 1 + 1) :=
    fun _ _ _ le below => Nat.le_of_eq (coupledDraw_of_below le below)
  ⟨fun short =>
    have below : w + 0 * (n + 1) < 1 * (n + 1) + 2 := by
      rw [Nat.zero_mul, Nat.one_mul, Nat.add_zero]; exact short
    ⟨continued_breaking_frontier (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1)
      (y := 1) (q := 0) (r := 1) draws bounded uncoupled logistic_le logistic_above below rfl
      (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_refl 2) (Nat.succ_pos n),
    fun x front =>
      Web.frontier_breaks_below (W := web (onSource x)) (c := Place.source)
        (f := Formation.dweller) (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1) (w := w)
        (worth := coupledDraw logistic 2 w (n + 1)) (y := 1) (q := 0) (r := 1) (e := 0)
        (fun _ _ less => less) draws bounded logistic_above below rfl (Nat.le_succ 1)
        (Nat.zero_le 1) (Nat.le_succ 2) (Nat.le_refl 2) (Nat.succ_pos n) front
        (fun _ => trivial) (fun _ => rfl) (Nat.le_refl 2)⟩,
   fun beyond' =>
    have beyond : 1 * (n + 1) + 2 < w + 0 * (n + 1) := by
      rw [Nat.zero_mul, Nat.one_mul, Nat.add_zero]; exact beyond'
    ⟨continued_kept_frontier (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1)
      (y := 2) (q := 0) (r := 1) coupled bounded uncoupled logistic_le logistic_above beyond rfl
      (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 2)
      (Nat.le_add_right 2 2) (Nat.succ_pos n),
    fun x front =>
      Web.frontier_keeps_above (W := web (onSource x)) (c := Place.source)
        (f := Formation.dweller) (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1) (w := w)
        (worth := coupledDraw logistic 2 w (n + 1)) (y := 2) (q := 0) (r := 1) (e := 2)
        (fun _ _ less => less) coupled uncoupled logistic_le
        (Nat.le_trans (Nat.le_of_eq (Nat.add_zero _)) beyond) rfl (Nat.le_refl 2)
        (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 2)
        (Nat.le_add_right 2 2) (Nat.succ_pos n) front (fun _ => rfl)⟩⟩

end Holding

end Optimum
