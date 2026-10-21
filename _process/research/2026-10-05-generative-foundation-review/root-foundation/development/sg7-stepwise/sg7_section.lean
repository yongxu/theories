/-! ## A coupling added for each step a dependence is kept

Above, a coupling of keeping a need through the whole horizon must exceed what keeping forgoes,
which grows with the horizon where the need lies above every level of greatest renewal. Here the
worth adds `c` for each step a course stays at the need from the start. A course met through `j`
steps of the horizon draws, with `r` for each of them, at most the start with what is given there,
`r` a step and `q` for each of them: each met step forgoes at least `r - q`. So every optimum keeps
the need through every horizon where `c` covers the renewal forgone a step, `r ≤ q + c`, and
exceeds the end the keeping course can reach, at least the need; where `c` with the end the
capacity reaches is below the need, every optimum falls below it within the horizon, and where `c`
also exceeds the renewal forgone a step it falls at the horizon's last step alone, drawing the need
itself there: the end does not reach back; and where `q + c < r` the coupling is at most `c` a step
and a long horizon outweighs it. Optima exist on both sides. -/

namespace Optimum

variable {R : Nat → Nat} {k q r s y m n c : Nat}

/-- What falls short of `r` from at most `q`, with `q`, is at least `r`. -/
theorem le_sub_add_of_le {g : Nat} (le : g ≤ q) : r ≤ r - g + q :=
  match Nat.le_total g r with
  | .inl within => Nat.le_trans (Nat.le_of_eq (Naturals.sub_add_cancel within).symm)
      (Nat.add_le_add_left le _)
  | .inr beyond => Nat.le_trans (Nat.le_trans beyond le) (Nat.le_add_left q _)

/-- **What met steps forgo.** Where what is given at each of the first `j` of `n` steps is at most
`q`, `r` for each of those steps is at most everything given falls short of `r` across the `n`
steps, with `q` for each of those steps. -/
theorem shortfall_ge {g : Nat → Nat} :
    ∀ {n j : Nat}, j ≤ n → (∀ t, t < j → g t ≤ q) →
      j * r ≤ Amounts.whole.sum (fun t => r - g t) 0 n + j * q
  | 0, j, le, _ => Nat.le_trans
      (Nat.le_of_eq ((congrArg (· * r) (Nat.le_antisymm le (Nat.zero_le j))).trans (Nat.zero_mul r)))
      (Nat.zero_le _)
  | n + 1, j, le, met => by
    show j * r ≤ Amounts.whole.sum (fun t => r - g t) 0 n + (r - g (0 + n)) + j * q
    rw [Nat.zero_add]
    match le_or_eq_succ le with
    | .inl earlier =>
      exact Nat.le_trans (shortfall_ge earlier met)
        (Nat.add_le_add_right (Nat.le_add_right _ _) _)
    | .inr last =>
      subst last
      rw [Nat.succ_mul, Nat.succ_mul, Nat.add_add_add_comm]
      exact Nat.add_le_add
        (shortfall_ge (Nat.le_refl n) fun t lt => met t (Nat.lt_succ_of_lt lt))
        (le_sub_add_of_le (met n (Nat.lt_succ_self n)))

/-- **What a course met through `j` steps draws.** Where each step leaves at most the level with
what is given, `R` gives at most `r` at every level and at most `q` at every level at or above `m`,
and a course stands at `m` or above at every step to the `j`-th, `j ≤ n`: what it draws across
`n + 1` steps, with `r` for each of those `j` steps, is at most its start with what is given there,
`r` for each step after the first and `q` for each of those `j` steps. -/
theorem met_drawn_le (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) {x : Nat → Nat}
    (within : ∀ t, x (t + 1) ≤ x t + R (x t)) {j : Nat} (met : ∀ t, t ≤ j → m ≤ x t)
    (le : j ≤ n) : drawnOver R x (n + 1) + j * r ≤ x 0 + R (x 0) + r * n + j * q := by
  have whole : drawnOver R x (n + 1) + x (n + 1) +
      Amounts.whole.sum (fun t => r - R (x (t + 1))) 0 n = x 0 + R (x 0) + r * n :=
    drawn_add_shortfall_after (x := x) (g := fun t => R (x t)) within (fun t => renews (x t)) n
  have short : j * r ≤ Amounts.whole.sum (fun t => r - R (x (t + 1))) 0 n + j * q :=
    shortfall_ge (g := fun t => R (x (t + 1))) le fun t lt => above _ (met (t + 1) lt)
  calc drawnOver R x (n + 1) + j * r
      ≤ drawnOver R x (n + 1) + (Amounts.whole.sum (fun t => r - R (x (t + 1))) 0 n + j * q) :=
        Nat.add_le_add_left short _
    _ = drawnOver R x (n + 1) + Amounts.whole.sum (fun t => r - R (x (t + 1))) 0 n + j * q :=
        (Nat.add_assoc _ _ _).symm
    _ ≤ drawnOver R x (n + 1) + x (n + 1) +
          Amounts.whole.sum (fun t => r - R (x (t + 1))) 0 n + j * q :=
        Nat.add_le_add_right (Nat.add_le_add_right (Nat.le_add_right _ _) _) _
    _ = x 0 + R (x 0) + r * n + j * q := by rw [whole]

/-- The course holding `y` at or above `m`, from a start at or above `m`, stands at `m` or above at
every step to the `n`-th, whatever its end. -/
theorem holdingTo_met {e : Nat} (meets : m ≤ s) (needs : m ≤ y) :
    ∀ t, t ≤ n → m ≤ holdingTo s y e n t
  | 0, _ => meets
  | _ + 1, le => Nat.le_trans needs (Nat.le_of_eq (holdingTo_before le).symm)

/-- What a step coupling adds over the renewal forgone, step by step. -/
theorem stepwise_arith {e j i : Nat} (rate : r ≤ q + c) (exceeds : e < c) :
    r * (j + i) + j * q + c * j + e < q * (j + i) + c * (j + i + 1) + j * r :=
  have key : r * i + e < q * i + c * i + c :=
    Nat.lt_of_le_of_lt
      (Nat.add_le_add_right (Nat.le_trans (Nat.le_of_eq (Nat.mul_comm r i))
        (Nat.le_trans (Nat.mul_le_mul_left i rate)
          (Nat.le_of_eq ((Nat.mul_add i q c).trans (by rw [Nat.mul_comm i q, Nat.mul_comm i c])))))
        e)
      (Nat.add_lt_add_left exceeds _)
  calc r * (j + i) + j * q + c * j + e
      = j * r + j * q + c * j + (r * i + e) := by
        rw [Nat.mul_add, Nat.mul_comm r j, Nat.add_right_comm (j * r) (r * i) (j * q),
          Nat.add_right_comm (j * r + j * q) (r * i) (c * j), Nat.add_assoc (j * r + j * q + c * j)]
    _ < j * r + j * q + c * j + (q * i + c * i + c) := Nat.add_lt_add_left key _
    _ = j * r + (q * j + (c * j + (q * i + (c * i + c)))) := by
        rw [Nat.mul_comm j q, Nat.add_assoc (j * r), Nat.add_assoc (j * r), Nat.add_assoc (q * i),
          Nat.add_assoc (q * j)]
    _ = j * r + (q * j + (q * i + (c * j + (c * i + c)))) := by
        rw [Nat.add_left_comm (c * j) (q * i)]
    _ = q * (j + i) + c * (j + i + 1) + j * r := by
        rw [Nat.mul_add q j i, Nat.mul_add c (j + i) 1, Nat.mul_add c j i, Nat.mul_one,
          Nat.add_comm _ (j * r), Nat.add_assoc (q * j), Nat.add_assoc (c * j)]

/-- Comparing a course met through `j` steps with a keeping course, under a step coupling. -/
theorem lt_of_stepwise {A D Da Wa S e j : Nat} (coupledAt : A ≤ D + c * j)
    (met : D + j * r ≤ S + r * n + j * q) (le : j ≤ n) (most : Da + e = S + q * n)
    (coupled : Da + c * (n + 1) ≤ Wa) (rate : r ≤ q + c) (exceeds : e < c) : A < Wa :=
  match le_dest le with
  | ⟨i, split⟩ => by
    subst split
    have less : A + j * r + e < Wa + j * r + e :=
      calc A + j * r + e ≤ D + c * j + j * r + e :=
            Nat.add_le_add_right (Nat.add_le_add_right coupledAt _) _
        _ = D + j * r + c * j + e := by rw [Nat.add_right_comm D (c * j) (j * r)]
        _ ≤ S + r * (j + i) + j * q + c * j + e :=
            Nat.add_le_add_right (Nat.add_le_add_right met _) _
        _ = S + (r * (j + i) + j * q + c * j + e) := by
            rw [Nat.add_assoc S, Nat.add_assoc S, Nat.add_assoc S]
        _ < S + (q * (j + i) + c * (j + i + 1) + j * r) :=
            Nat.add_lt_add_left (stepwise_arith rate exceeds) _
        _ = Da + e + c * (j + i + 1) + j * r := by
            rw [most, Nat.add_assoc S, Nat.add_assoc S]
        _ = Da + c * (j + i + 1) + j * r + e := by
            rw [Nat.add_right_comm Da e, Nat.add_right_comm (Da + c * (j + i + 1)) e]
        _ ≤ Wa + j * r + e := Nat.add_le_add_right (Nat.add_le_add_right coupled _) _
    exact Nat.lt_of_add_lt_add_right (Nat.lt_of_add_lt_add_right less)

/-- **A coupling a step covering the renewal forgone and exceeding the end keeps the need at every
horizon.** Where `R` gives at most `r` at every level, at most `q` at every level at or above `m`,
and `q` at some `y` within the start with what is given there, from a start meeting `m`, over a
horizon of at least two steps, with a capacity covering what the first step draws down to `y` and
`y` with `q` down to some `e` between `m` and `y`; for a worth adding at least `c` for each step to
what a keeping course draws, and at most `c` for each step met to what a course falling below `m`
within the horizon draws: where `r ≤ q + c` and `e < c`, every optimum, among the open courses, of
every order rising with the worth keeps its level at `m` or above through the horizon. -/
theorem frontier_keeps_stepwise {better : (Nat → Nat) → (Nat → Nat) → Prop}
    {worth : (Nat → Nat) → Nat} {e : Nat}
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → drawnOver R a (n + 1) + c * (n + 1) ≤ worth a)
    (coupledAt : ∀ a j, OpenCourse R k s a → (∀ t, t ≤ j → m ≤ a t) → a (j + 1) < m → j ≤ n →
      worth a ≤ drawnOver R a (n + 1) + c * j)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : r ≤ q + c) (exceeds : e < c)
    (greatest : R y = q) (meets : m ≤ s) (ends : m ≤ e) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : Keeps m n x :=
  match keeps_or_falls (Eq.subst (motive := fun z => m ≤ z) front.1.1.symm meets) n with
  | .inl keeps => keeps
  | .inr ⟨j, le, met, lt⟩ => by
    have opens : OpenCourse R k s (continued R (holdingTo s y e n) n) :=
      continued_open (x := holdingTo s y e n) rfl
        (holdingTo_steps greatest reach settles drawsDown holds long)
    have most : drawnOver R (continued R (holdingTo s y e n) n) (n + 1) + e = s + R s + q * n := by
      rw [continued_drawn]
      exact holdingTo_most greatest reach settles n
    have drawn := met_drawn_le renews above (fun t => (front.1.2 t).1) met le
    rw [front.1.1] at drawn
    exact absurd (rising x _ (lt_of_stepwise (coupledAt x j front.1 met lt le) drawn le most
      (coupled _ opens (continued_keeps (holdingTo_keeps meets (Nat.le_trans ends settles) ends)))
      rate exceeds)) (front.2 _ opens)

/-- **The optimum keeping the need under a step coupling.** Under the premises of
`frontier_keeps_stepwise` with the keeping course ending at `m`, for a worth adding exactly `c` for
each step to what a keeping course draws: the course holding `y` to the `n`-th step, at `m` after
the last and drawing nothing after it, is an optimum, among the open courses, of the order by the
worth. -/
theorem continued_stepwise_frontier {worth : (Nat → Nat) → Nat}
    (coupled : ∀ a, OpenCourse R k s a → Keeps m n a → drawnOver R a (n + 1) + c * (n + 1) ≤ worth a)
    (bounded : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + c * (n + 1))
    (coupledAt : ∀ a j, OpenCourse R k s a → (∀ t, t ≤ j → m ≤ a t) → a (j + 1) < m → j ≤ n →
      worth a ≤ drawnOver R a (n + 1) + c * j)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : r ≤ q + c) (exceeds : m < c)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ m + k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (fun b a => worth a < worth b)
      (continued R (holdingTo s y m n) n) :=
  have optimum := continued_keeping_frontier above greatest needs meets reach drawsDown holds long
  have most : drawnOver R (continued R (holdingTo s y m n) n) (n + 1) + m = s + R s + q * n := by
    rw [continued_drawn]
    exact holdingTo_most greatest reach needs n
  have least := coupled _ optimum.1.1 optimum.1.2
  ⟨optimum.1.1, fun b opens more => Nat.not_le_of_gt more
    (match keeps_or_falls (Eq.subst (motive := fun z => m ≤ z) opens.1.symm meets) n with
    | .inl keeps => Nat.le_trans (bounded b opens keeps) (Nat.le_trans (Nat.add_le_add_right
        (Nat.ge_of_not_lt (optimum.2 b ⟨opens, keeps⟩)) _) least)
    | .inr ⟨j, le, met, lt⟩ => by
      have drawn := met_drawn_le renews above (fun t => (opens.2 t).1) met le
      rw [opens.1] at drawn
      exact Nat.le_of_lt (lt_of_stepwise (coupledAt b j opens met lt le) drawn le most least rate
        exceeds))⟩

/-- **Below the need, the horizon's end breaks it.** Where `R` gives at most `q` at every level at
or above `m` and `q` at some `y` at or above `m` within the start with what is given there, from a
start meeting `m`, over a horizon of at least two steps, with a capacity covering what the first
step draws down to `y` and `y` with `q` down to some `e` at most `y`; for a worth adding at most `c`
for each step to what a keeping course draws, and at least `c` for each of the first `n` steps to
what a course meeting `m` at each of them draws: where `c + e < m`, no optimum, among the open
courses, of any order rising with the worth keeps its level at `m` or above through the horizon. -/
theorem frontier_breaks_at_end {better : (Nat → Nat) → (Nat → Nat) → Prop}
    {worth : (Nat → Nat) → Nat} {e : Nat}
    (rising : ∀ a b, worth a < worth b → better b a)
    (bounded : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + c * (n + 1))
    (coupledTo : ∀ a, OpenCourse R k s a → (∀ t, t ≤ n → m ≤ a t) →
      drawnOver R a (n + 1) + c * n ≤ worth a)
    (above : ∀ z, m ≤ z → R z ≤ q) (short : c + e < m)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : ¬ Keeps m n x := by
  intro keeps
  have opens : OpenCourse R k s (continued R (holdingTo s y e n) n) :=
    continued_open (x := holdingTo s y e n) rfl
      (holdingTo_steps greatest reach settles drawsDown holds long)
  have most : drawnOver R (continued R (holdingTo s y e n) n) (n + 1) + e = s + R s + q * n := by
    rw [continued_drawn]
    exact holdingTo_most greatest reach settles n
  have least := coupledTo _ opens fun t le => Nat.le_trans (holdingTo_met meets needs t le)
    (Nat.le_of_eq (continued_le (Nat.le_succ_of_le le)).symm)
  have kept := keeping_drawn_le above (fun t => (front.1.2 t).1) keeps
  rw [front.1.1] at kept
  have less : worth x + m < worth (continued R (holdingTo s y e n) n) + m :=
    calc worth x + m ≤ drawnOver R x (n + 1) + c * (n + 1) + m :=
          Nat.add_le_add_right (bounded x front.1 keeps) m
      _ = drawnOver R x (n + 1) + m + c * (n + 1) := Nat.add_right_comm _ _ _
      _ ≤ s + R s + q * n + c * (n + 1) := Nat.add_le_add_right kept _
      _ = drawnOver R (continued R (holdingTo s y e n) n) (n + 1) + c * n + (c + e) := by
          rw [← most, Nat.mul_succ c n,
            Nat.add_add_add_comm (drawnOver R (continued R (holdingTo s y e n) n) (n + 1)) e (c * n) c,
            Nat.add_comm e c]
      _ ≤ worth (continued R (holdingTo s y e n) n) + (c + e) := Nat.add_le_add_right least _
      _ < worth (continued R (holdingTo s y e n) n) + m := Nat.add_lt_add_left short _
  exact front.2 _ opens (rising x _ (Nat.lt_of_add_lt_add_right less))

/-- What a step coupling covering the renewal forgone adds, step by step. -/
theorem stepwise_arith_le {j i : Nat} (rate : r ≤ q + c) :
    r * (j + i) + j * q + c * j ≤ q * (j + i) + c * (j + i) + j * r :=
  have key : r * i ≤ q * i + c * i :=
    Nat.le_trans (Nat.le_of_eq (Nat.mul_comm r i))
      (Nat.le_trans (Nat.mul_le_mul_left i rate)
        (Nat.le_of_eq ((Nat.mul_add i q c).trans (by rw [Nat.mul_comm i q, Nat.mul_comm i c]))))
  calc r * (j + i) + j * q + c * j
      = j * r + j * q + c * j + r * i := by
        rw [Nat.mul_add, Nat.mul_comm r j, Nat.add_right_comm (j * r) (r * i) (j * q),
          Nat.add_right_comm (j * r + j * q) (r * i) (c * j)]
    _ ≤ j * r + j * q + c * j + (q * i + c * i) := Nat.add_le_add_left key _
    _ = j * r + (q * j + (c * j + (q * i + c * i))) := by
        rw [Nat.mul_comm j q, Nat.add_assoc (j * r), Nat.add_assoc (j * r), Nat.add_assoc (q * j)]
    _ = j * r + (q * j + (q * i + (c * j + c * i))) := by
        rw [Nat.add_left_comm (c * j) (q * i)]
    _ = q * (j + i) + c * (j + i) + j * r := by
        rw [Nat.mul_add q j i, Nat.mul_add c j i, Nat.add_comm _ (j * r), Nat.add_assoc (q * j)]

/-- Comparing a course met through `j` steps with one met through every step but the last and
ending at nothing, under a step coupling. -/
theorem le_of_stepwise_end {A D Da Wa S j : Nat} (coupledAt : A ≤ D + c * j)
    (met : D + j * r ≤ S + r * n + j * q) (le : j ≤ n) (most : Da = S + q * n)
    (coupledTo : Da + c * n ≤ Wa) (rate : r ≤ q + c) : A ≤ Wa :=
  match le_dest le with
  | ⟨i, split⟩ => by
    subst split
    have sum : A + j * r ≤ Wa + j * r :=
      calc A + j * r ≤ D + c * j + j * r := Nat.add_le_add_right coupledAt _
        _ = D + j * r + c * j := by rw [Nat.add_right_comm D (c * j) (j * r)]
        _ ≤ S + r * (j + i) + j * q + c * j := Nat.add_le_add_right met _
        _ = S + (r * (j + i) + j * q + c * j) := by rw [Nat.add_assoc S, Nat.add_assoc S]
        _ ≤ S + (q * (j + i) + c * (j + i) + j * r) := Nat.add_le_add_left (stepwise_arith_le rate) _
        _ = Da + c * (j + i) + j * r := by rw [most, Nat.add_assoc S, Nat.add_assoc S]
        _ ≤ Wa + j * r := Nat.add_le_add_right coupledTo _
    exact Naturals.le_of_add_le_add_right sum

/-- **Between the renewal forgone and the need, the optimum keeps the need to the horizon's last step
and draws everything there.** Where `R` gives at most `r` at every level, at most `q` at every level
at or above `m`, and `q` at some `y` at or above `m` within the start with what is given there, from
a start meeting `m`, over a horizon of at least two steps, with a capacity covering what the first
step draws down to `y` and `y` with `q`; for a worth adding exactly `c` for each step a keeping
course or a course falling below `m` within the horizon stays met, and at least `c` for each of the
first `n` steps to a course meeting `m` at each of them: where `r ≤ q + c` and `c ≤ m`, the course
holding `y` to the `n`-th step, at nothing after the last and drawing nothing after it, is an
optimum, among the open courses, of the order by the worth. -/
theorem continued_ending_stepwise_frontier {worth : (Nat → Nat) → Nat}
    (bounded : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + c * (n + 1))
    (coupledAt : ∀ a j, OpenCourse R k s a → (∀ t, t ≤ j → m ≤ a t) → a (j + 1) < m → j ≤ n →
      worth a ≤ drawnOver R a (n + 1) + c * j)
    (coupledTo : ∀ a, OpenCourse R k s a → (∀ t, t ≤ n → m ≤ a t) →
      drawnOver R a (n + 1) + c * n ≤ worth a)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : r ≤ q + c) (low : c ≤ m)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (fun b a => worth a < worth b)
      (continued R (holdingTo s y 0 n) n) :=
  have opens : OpenCourse R k s (continued R (holdingTo s y 0 n) n) :=
    continued_open (x := holdingTo s y 0 n) rfl (holdingTo_steps greatest reach (Nat.zero_le y)
      drawsDown (Nat.le_trans holds (Nat.le_of_eq (Nat.zero_add k).symm)) long)
  have most : drawnOver R (continued R (holdingTo s y 0 n) n) (n + 1) = s + R s + q * n := by
    rw [continued_drawn]
    exact holdingTo_most greatest reach (Nat.zero_le y) n
  have least := coupledTo _ opens fun t le => Nat.le_trans (holdingTo_met meets needs t le)
    (Nat.le_of_eq (continued_le (Nat.le_succ_of_le le)).symm)
  ⟨opens, fun b openB more => Nat.not_le_of_gt more
    (match keeps_or_falls (Eq.subst (motive := fun z => m ≤ z) openB.1.symm meets) n with
    | .inl keeps => by
      have kept := keeping_drawn_le above (fun t => (openB.2 t).1) keeps
      rw [openB.1] at kept
      have sum : worth b + m ≤ worth (continued R (holdingTo s y 0 n) n) + m :=
        calc worth b + m ≤ drawnOver R b (n + 1) + c * (n + 1) + m :=
              Nat.add_le_add_right (bounded b openB keeps) m
          _ = drawnOver R b (n + 1) + m + c * (n + 1) := Nat.add_right_comm _ _ _
          _ ≤ s + R s + q * n + c * (n + 1) := Nat.add_le_add_right kept _
          _ = drawnOver R (continued R (holdingTo s y 0 n) n) (n + 1) + c * n + c := by
              rw [most, Nat.mul_succ c n, Nat.add_assoc (s + R s + q * n) (c * n) c]
          _ ≤ worth (continued R (holdingTo s y 0 n) n) + m := Nat.add_le_add least low
      exact Naturals.le_of_add_le_add_right sum
    | .inr ⟨j, le, met, lt⟩ => by
      have drawn := met_drawn_le renews above (fun t => (openB.2 t).1) met le
      rw [openB.1] at drawn
      exact le_of_stepwise_end (coupledAt b j openB met lt le) drawn le most least rate)⟩

/-- What a step coupling above the renewal forgone adds over the steps before the last. -/
theorem stepwise_arith_lt {j i : Nat} (rate : r < q + c) :
    r * (j + 1 + i) + j * q + c * j < q * (j + 1 + i) + c * (j + 1 + i) + j * r :=
  calc r * (j + 1 + i) + j * q + c * j
      = r * (j + i) + j * q + c * j + r := by
        rw [Nat.add_right_comm j 1 i, Nat.mul_succ r (j + i),
          Nat.add_right_comm (r * (j + i)) r (j * q),
          Nat.add_right_comm (r * (j + i) + j * q) r (c * j)]
    _ < q * (j + i) + c * (j + i) + j * r + (q + c) :=
        Nat.lt_of_le_of_lt (Nat.add_le_add_right (stepwise_arith_le (Nat.le_of_lt rate)) r)
          (Nat.add_lt_add_left rate _)
    _ = q * (j + 1 + i) + c * (j + 1 + i) + j * r := by
        rw [Nat.add_right_comm j 1 i, Nat.mul_succ q (j + i), Nat.mul_succ c (j + i),
          Nat.add_right_comm (q * (j + i) + c * (j + i)) (j * r) (q + c),
          Nat.add_add_add_comm (q * (j + i)) (c * (j + i)) q c]

/-- Comparing a course falling below the need before the horizon's last step with one met through
every step but the last and ending at nothing, under a step coupling above the renewal forgone. -/
theorem lt_of_stepwise_end {A D Da Wa S j : Nat} (coupledAt : A ≤ D + c * j)
    (met : D + j * r ≤ S + r * n + j * q) (before : j < n) (most : Da = S + q * n)
    (coupledTo : Da + c * n ≤ Wa) (rate : r < q + c) : A < Wa :=
  have succ : j + 1 ≤ n := before
  match le_dest succ with
  | ⟨i, split⟩ => by
    subst split
    have less : A + j * r < Wa + j * r :=
      calc A + j * r ≤ D + c * j + j * r := Nat.add_le_add_right coupledAt _
        _ = D + j * r + c * j := by rw [Nat.add_right_comm D (c * j) (j * r)]
        _ ≤ S + r * (j + 1 + i) + j * q + c * j := Nat.add_le_add_right met _
        _ = S + (r * (j + 1 + i) + j * q + c * j) := by rw [Nat.add_assoc S, Nat.add_assoc S]
        _ < S + (q * (j + 1 + i) + c * (j + 1 + i) + j * r) :=
            Nat.add_lt_add_left (stepwise_arith_lt rate) _
        _ = Da + c * (j + 1 + i) + j * r := by rw [most, Nat.add_assoc S, Nat.add_assoc S]
        _ ≤ Wa + j * r := Nat.add_le_add_right coupledTo _
    exact Nat.lt_of_add_lt_add_right less

/-- **A coupling a step above the renewal forgone keeps the need to the horizon's last step.** Where
`R` gives at most `r` at every level, at most `q` at every level at or above `m`, and `q` at some `y`
at or above `m` within the start with what is given there, from a start meeting `m`, over a horizon
of at least two steps, with a capacity covering what the first step draws down to `y` and `y` with
`q`; for a worth adding at most `c` for each step met to what a course falling below `m` within the
horizon draws, and at least `c` for each of the first `n` steps to what a course meeting `m` at each
of them draws: where `r < q + c`, every optimum, among the open courses, of every order rising with
the worth stands at `m` or above at every step to the `n`-th. -/
theorem frontier_met_before_end {better : (Nat → Nat) → (Nat → Nat) → Prop}
    {worth : (Nat → Nat) → Nat}
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupledAt : ∀ a j, OpenCourse R k s a → (∀ t, t ≤ j → m ≤ a t) → a (j + 1) < m → j ≤ n →
      worth a ≤ drawnOver R a (n + 1) + c * j)
    (coupledTo : ∀ a, OpenCourse R k s a → (∀ t, t ≤ n → m ≤ a t) →
      drawnOver R a (n + 1) + c * n ≤ worth a)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : r < q + c)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ k) (long : 0 < n)
    {x : Nat → Nat} (front : Frontier (OpenCourse R k s) better x) : ∀ t, t ≤ n → m ≤ x t :=
  match keeps_or_falls (Eq.subst (motive := fun z => m ≤ z) front.1.1.symm meets) n with
  | .inl keeps => fun t le => keeps t (Nat.le_succ_of_le le)
  | .inr ⟨j, le, met, lt⟩ =>
    match Nat.lt_or_ge j n with
    | .inr ge => fun t within => met t (Nat.le_trans within ge)
    | .inl before => by
      have opens : OpenCourse R k s (continued R (holdingTo s y 0 n) n) :=
        continued_open (x := holdingTo s y 0 n) rfl (holdingTo_steps greatest reach (Nat.zero_le y)
          drawsDown (Nat.le_trans holds (Nat.le_of_eq (Nat.zero_add k).symm)) long)
      have most : drawnOver R (continued R (holdingTo s y 0 n) n) (n + 1) = s + R s + q * n := by
        rw [continued_drawn]
        exact holdingTo_most greatest reach (Nat.zero_le y) n
      have least := coupledTo _ opens fun t le => Nat.le_trans (holdingTo_met meets needs t le)
        (Nat.le_of_eq (continued_le (Nat.le_succ_of_le le)).symm)
      have drawn := met_drawn_le renews above (fun t => (front.1.2 t).1) met le
      rw [front.1.1] at drawn
      exact absurd (rising x _ (lt_of_stepwise_end (coupledAt x j front.1 met lt le) drawn before
        most least rate)) (front.2 _ opens)

/-- **An optimum falling below the need under a step coupling.** Where `R` gives at most `r` at every
level, at most `q` at every level at or above `m`, and `r` at some `y` within the start with what is
given there, from a start meeting `m`, over a horizon of at least two steps, with a capacity covering
what the first step draws down to `y` and `y` with `r`; for a worth at least what a course draws,
at most `c` more for each step a keeping course or a course falling below `m` within the horizon
stays met: where `q + c ≤ r` and `c ≤ m`, the course holding `y` to the `n`-th step, at nothing after
the last and drawing nothing after it, is an optimum, among the open courses, of the order by the
worth. -/
theorem continued_holding_stepwise_frontier {worth : (Nat → Nat) → Nat}
    (draws : ∀ a, drawnOver R a (n + 1) ≤ worth a)
    (bounded : ∀ a, OpenCourse R k s a → Keeps m n a → worth a ≤ drawnOver R a (n + 1) + c * (n + 1))
    (coupledAt : ∀ a j, OpenCourse R k s a → (∀ t, t ≤ j → m ≤ a t) → a (j + 1) < m → j ≤ n →
      worth a ≤ drawnOver R a (n + 1) + c * j)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : q + c ≤ r) (low : c ≤ m)
    (greatest : R y = r) (meets : m ≤ s) (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (fun b a => worth a < worth b) (continued R (holding s y n) n) :=
  have most : drawnOver R (continued R (holding s y n) n) (n + 1) = s + R s + r * n :=
    continued_drawn.trans (holding_most renews greatest reach n)
  have least : s + R s + r * n ≤ worth (continued R (holding s y n) n) :=
    Nat.le_trans (Nat.le_of_eq most.symm) (draws _)
  have per : q * n + c * n ≤ r * n :=
    Nat.le_trans (Nat.le_of_eq (by rw [Nat.mul_comm q, Nat.mul_comm c, ← Nat.mul_add,
      Nat.mul_comm])) (Nat.mul_le_mul_right n rate)
  ⟨continued_open (x := holding s y n) rfl (holdingTo_steps greatest reach (Nat.zero_le y)
      drawsDown (Nat.le_trans holds (Nat.le_of_eq (Nat.zero_add k).symm)) long),
   fun b opens more => Nat.not_le_of_gt more (Nat.le_trans (match keeps_or_falls
      (Eq.subst (motive := fun z => m ≤ z) opens.1.symm meets) n with
    | .inl keeps => by
      have kept := keeping_drawn_le above (fun t => (opens.2 t).1) keeps
      rw [opens.1] at kept
      have sum : worth b + m ≤ s + R s + r * n + m :=
        calc worth b + m ≤ drawnOver R b (n + 1) + c * (n + 1) + m :=
              Nat.add_le_add_right (bounded b opens keeps) m
          _ = drawnOver R b (n + 1) + m + c * (n + 1) := Nat.add_right_comm _ _ _
          _ ≤ s + R s + q * n + c * (n + 1) := Nat.add_le_add_right kept _
          _ = s + R s + (q * n + c * n) + c := by
              rw [Nat.mul_succ c n, ← Nat.add_assoc (s + R s + q * n) (c * n) c,
                Nat.add_assoc (s + R s) (q * n) (c * n)]
          _ ≤ s + R s + r * n + m := Nat.add_le_add (Nat.add_le_add_left per _) low
      exact Naturals.le_of_add_le_add_right sum
    | .inr ⟨j, le, met, lt⟩ => by
      have drawn := met_drawn_le renews above (fun t => (opens.2 t).1) met le
      rw [opens.1] at drawn
      have perStep : j * q + c * j ≤ j * r :=
        Nat.le_trans (Nat.le_of_eq (by rw [Nat.mul_comm c j, ← Nat.mul_add]))
          (Nat.mul_le_mul_left j rate)
      have sum : worth b + j * r ≤ s + R s + r * n + j * r :=
        calc worth b + j * r ≤ drawnOver R b (n + 1) + c * j + j * r :=
              Nat.add_le_add_right (coupledAt b j opens met lt le) _
          _ = drawnOver R b (n + 1) + j * r + c * j := Nat.add_right_comm _ _ _
          _ ≤ s + R s + r * n + j * q + c * j := Nat.add_le_add_right drawn _
          _ = s + R s + r * n + (j * q + c * j) := Nat.add_assoc _ _ _
          _ ≤ s + R s + r * n + j * r := Nat.add_le_add_left perStep _
      exact Naturals.le_of_add_le_add_right sum) least)⟩

/-- **A coupling a step below the renewal forgone is outweighed by a long horizon.** Where
`q + c < r`, every end `e` with `c + e < n + m` has `c (n + 1) + q n + e < r n + m`: a coupling of at
most `c` a step falls below what keeping forgoes. -/
theorem outweighed_stepwise {e : Nat} (less : q + c < r) (short : c + e < n + m) :
    c * (n + 1) + q * n + e < r * n + m :=
  have grows : q * n + c * n + n ≤ r * n :=
    Nat.le_trans (Nat.le_of_eq (by rw [Nat.mul_comm q, Nat.mul_comm c, ← Nat.mul_add,
      ← Nat.mul_succ, Nat.mul_comm]))
      (Nat.mul_le_mul_right n (Nat.succ_le_of_lt less))
  calc c * (n + 1) + q * n + e = q * n + c * n + (c + e) := by
        rw [Nat.mul_succ c n, Nat.add_comm (c * n + c) (q * n), Nat.add_assoc (q * n) (c * n + c) e,
          Nat.add_assoc (c * n) c e, ← Nat.add_assoc (q * n) (c * n) (c + e)]
    _ < q * n + c * n + (n + m) := Nat.add_lt_add_left short _
    _ = q * n + c * n + n + m := (Nat.add_assoc _ _ _).symm
    _ ≤ r * n + m := Nat.add_le_add_right grows m

end Optimum

namespace Flow

open Optimum

variable {L : Flow F C} {W : Web F C} {c : C}

/-- **What a balanced course met through `j` steps takes.** Where what is given to a condition is a
law `R` of its level, at most `r` at every level and at most `q` at every level at or above `m`, and
the course of its levels stands at `m` or above at every step to the `j`-th, `j ≤ n`: what is taken
there across `n + 1` steps, with `r` for each of those `j` steps, is at most the starting level with
what is given there, `r` for each step after the first and `q` for each of those `j` steps. -/
theorem Balances.met_taken_le {R : Nat → Nat} {q r m n j : Nat} (balances : L.Balances W)
    (renewal : ∀ t, L.given t c = R (W.level t c)) (renews : ∀ z, R z ≤ r)
    (above : ∀ z, m ≤ z → R z ≤ q) (met : ∀ t, t ≤ j → m ≤ W.level t c) (le : j ≤ n) :
    Amounts.whole.sum (fun t => L.taken t c) 0 (n + 1) + j * r ≤
      W.level 0 c + R (W.level 0 c) + r * n + j * q :=
  Nat.le_trans (Nat.le_of_eq (congrArg (· + j * r) (sum_eq_of_eq fun t _ =>
      ((congrArg (fun z => W.level t c + z - W.level (t + 1) c) (renewal t)).symm.trans
        (balances.drawnAt_eq c t)).symm)))
    (met_drawn_le (x := fun t => W.level t c) renews above (fun t => Nat.le_trans (balances.within c t)
      (Nat.le_of_eq (congrArg (W.level t c + ·) (renewal t)))) met le)

end Flow

namespace Web

open Optimum

variable {W : Web F C} {c : C} {f : F} {R : Nat → Nat} {k q r s y m n e w : Nat}
  {better : (Nat → Nat) → (Nat → Nat) → Prop} {worth : (Nat → Nat) → Nat}

/-- **A coupling a step covering the renewal forgone and exceeding the end keeps a dependence at
every horizon.** Under the premises of `Optimum.frontier_keeps_stepwise`, with a formation's need on
the condition `m` at every step: every optimum, among the open courses, of every order rising with a
worth adding at least `w` for each step to what a keeping course draws and at most `w` for each step
met to what a course falling below the need draws meets the need at every step through the horizon,
where `r ≤ q + w` and `e < w`. -/
theorem frontier_keeps_stepwise
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupled : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      drawnOver R a (n + 1) + w * (n + 1) ≤ worth a)
    (coupledAt : ∀ a j, OpenCourse R k s a → (∀ t, t ≤ j → m ≤ a t) → a (j + 1) < m → j ≤ n →
      worth a ≤ drawnOver R a (n + 1) + w * j)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : r ≤ q + w) (exceeds : e < w)
    (greatest : R y = q) (meets : m ≤ s) (ends : m ≤ e) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (need : ∀ t, W.need t f c = m) :
    ∀ t, t ≤ n + 1 → W.need t f c ≤ W.level t c :=
  fun t le => Nat.le_trans (Nat.le_of_eq (need t))
    (Optimum.frontier_keeps_stepwise rising coupled coupledAt renews above rate exceeds greatest
      meets ends reach settles drawsDown holds long front t le)

/-- **Below the need, the horizon's end breaks a dependence.** Under the premises of
`Optimum.frontier_breaks_at_end`, with a formation depending on the condition at the need `m` at
every step, met at the start: every optimum, among the open courses, of every order rising with a
worth adding at most `w` for each step to what a keeping course draws and at least `w` for each of
the first `n` steps to a course meeting the need at each of them breaks the dependence at some step
to the `n`-th, where `w + e < m`. -/
theorem frontier_breaks_at_end
    (rising : ∀ a b, worth a < worth b → better b a)
    (bounded : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      worth a ≤ drawnOver R a (n + 1) + w * (n + 1))
    (coupledTo : ∀ a, OpenCourse R k s a → (∀ t, t ≤ n → m ≤ a t) →
      drawnOver R a (n + 1) + w * n ≤ worth a)
    (above : ∀ z, m ≤ z → R z ≤ q) (short : w + e < m)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s) (settles : e ≤ y)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ e + k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m) :
    ∃ t, t ≤ n ∧ W.Broken t f c :=
  match drops_of_not_keeps (Eq.subst (motive := fun z => m ≤ z) front.1.1.symm meets)
      (Optimum.frontier_breaks_at_end rising bounded coupledTo above short greatest needs meets
        reach settles drawsDown holds long front) with
  | ⟨t, le, met, lt⟩ => ⟨t, le, depends t, Nat.le_trans (Nat.le_of_eq (need t)) met,
      Nat.lt_of_lt_of_le lt (Nat.le_of_eq (need t).symm)⟩

/-- **A coupling a step above the renewal forgone keeps a dependence to the horizon's last step.**
Under the premises of `Optimum.frontier_met_before_end`, with a formation's need on the condition
`m` at every step: every optimum, among the open courses, of every order rising with a worth adding
at most `w` for each step met to what a course falling below the need draws and at least `w` for
each of the first `n` steps to a course meeting the need at each of them meets the need at every
step to the `n`-th, where `r < q + w`. -/
theorem frontier_met_before_end
    (rising : ∀ a b, worth a < worth b → better b a)
    (coupledAt : ∀ a j, OpenCourse R k s a → (∀ t, t ≤ j → m ≤ a t) → a (j + 1) < m → j ≤ n →
      worth a ≤ drawnOver R a (n + 1) + w * j)
    (coupledTo : ∀ a, OpenCourse R k s a → (∀ t, t ≤ n → m ≤ a t) →
      drawnOver R a (n + 1) + w * n ≤ worth a)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : r < q + w)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (need : ∀ t, W.need t f c = m) :
    ∀ t, t ≤ n → W.need t f c ≤ W.level t c :=
  fun t le => Nat.le_trans (Nat.le_of_eq (need t))
    (Optimum.frontier_met_before_end rising coupledAt coupledTo renews above rate greatest needs
      meets reach drawsDown holds long front t le)

/-- **Between the renewal forgone and the need, the horizon's end breaks a dependence at its last
step alone.** Under the premises of `Web.frontier_met_before_end` and of `Web.frontier_breaks_at_end`
with the end at nothing, for a dependence at the need `m` at every step: every optimum, among the
open courses, of every order rising with a worth adding at most `w` for each step met to what a
course falling below the need or keeping it draws and at least `w` for each of the first `n` steps
to a course meeting the need at each of them, where `r < q + w` and `w < m`, meets the need at every
step to the `n`-th and breaks the dependence at the `n`-th. -/
theorem frontier_breaks_last
    (rising : ∀ a b, worth a < worth b → better b a)
    (bounded : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      worth a ≤ drawnOver R a (n + 1) + w * (n + 1))
    (coupledAt : ∀ a j, OpenCourse R k s a → (∀ t, t ≤ j → m ≤ a t) → a (j + 1) < m → j ≤ n →
      worth a ≤ drawnOver R a (n + 1) + w * j)
    (coupledTo : ∀ a, OpenCourse R k s a → (∀ t, t ≤ n → m ≤ a t) →
      drawnOver R a (n + 1) + w * n ≤ worth a)
    (renews : ∀ z, R z ≤ r) (above : ∀ z, m ≤ z → R z ≤ q) (rate : r < q + w) (short : w < m)
    (greatest : R y = q) (needs : m ≤ y) (meets : m ≤ s) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + q ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m) :
    (∀ t, t ≤ n → W.need t f c ≤ W.level t c) ∧ W.Broken n f c :=
  have met := Web.frontier_met_before_end rising coupledAt coupledTo renews above rate greatest
    needs meets reach drawsDown holds long front need
  match Web.frontier_breaks_at_end (e := 0) rising bounded coupledTo above short greatest needs
      meets reach (Nat.zero_le y) drawsDown (Nat.le_trans holds (Nat.le_of_eq (Nat.zero_add k).symm))
      long front depends need with
  | ⟨t, le, broken⟩ =>
    match Nat.lt_or_ge t n with
    | .inl before => (Nat.lt_irrefl (W.level (t + 1) c) (Nat.lt_of_lt_of_le broken.2.2
        (Nat.le_trans (Nat.le_of_eq ((need t).trans (need (t + 1)).symm)) (met (t + 1) before)))).elim
    | .inr ge => ⟨met, Nat.le_antisymm le ge ▸ broken⟩

/-- **A coupling a step below the renewal forgone breaks a dependence over a long horizon.** Under
the premises of `Web.frontier_breaks_below`, for a worth adding at most `w (n + 1)` to what a keeping
course draws, where `q + w < r` and `w + e < n + m`: every optimum breaks the dependence within the
horizon. -/
theorem frontier_breaks_stepwise_long
    (rising : ∀ a b, worth a < worth b → better b a)
    (draws : ∀ a, drawnOver R a (n + 1) ≤ worth a)
    (bounded : ∀ a, OpenCourse R k s a → Optimum.Keeps m n a →
      worth a ≤ drawnOver R a (n + 1) + w * (n + 1))
    (above : ∀ z, m ≤ z → R z ≤ q) (less : q + w < r) (short : w + e < n + m)
    (greatest : R y = r) (reach : y ≤ s + R s) (settles : e ≤ y) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ e + k) (long : 0 < n)
    (front : Frontier (OpenCourse R k s) better fun t => W.level t c)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m) (start : m ≤ s) :
    ∃ t, t ≤ n ∧ W.Broken t f c :=
  Web.frontier_breaks_below rising draws bounded above (outweighed_stepwise less short) greatest
    reach settles drawsDown holds long front depends need start

end Web

namespace Optimum

namespace Holding

open Diversion

/-- How many of the steps to the `T`-th a course stands at `m` or above from the start through. -/
def metRun (m : Nat) (x : Nat → Nat) : Nat → Nat
  | 0 => 0
  | t + 1 => metRun m x t + metThrough m x (t + 1)

/-- A course standing at `m` or above at every step to the `T`-th is met for all `T` of them. -/
theorem metRun_of_met {m : Nat} {x : Nat → Nat} :
    ∀ {T : Nat}, (∀ t, t ≤ T → m ≤ x t) → metRun m x T = T
  | 0, _ => rfl
  | T + 1, met => show metRun m x T + metThrough m x (T + 1) = T + 1 from
      (congrArg (· + metThrough m x (T + 1))
        (metRun_of_met fun t le => met t (Nat.le_succ_of_le le))).trans
        (congrArg (T + ·) (metThrough_of_keeps met))

/-- A course met through `j` steps and below `m` at the next is met for `j` steps, whatever later. -/
theorem metRun_of_falls {m j : Nat} {x : Nat → Nat} (met : ∀ t, t ≤ j → m ≤ x t)
    (below : x (j + 1) < m) : ∀ i, metRun m x (j + i) = j
  | 0 => metRun_of_met met
  | i + 1 => show metRun m x (j + i) + metThrough m x (j + i + 1) = j from
      (congrArg (· + metThrough m x (j + i + 1)) (metRun_of_falls met below i)).trans
        (congrArg (j + ·) (metThrough_of_below (Nat.succ_le_succ (Nat.le_add_right j i)) below))

/-- A course met through `j` steps is met for at least `j` of any `j + i` steps. -/
theorem metRun_ge {m j : Nat} {x : Nat → Nat} (met : ∀ t, t ≤ j → m ≤ x t) :
    ∀ i, j ≤ metRun m x (j + i)
  | 0 => Nat.le_of_eq (metRun_of_met met).symm
  | i + 1 => Nat.le_trans (metRun_ge met i) (Nat.le_add_right _ _)

/-- What a course draws across `n + 1` steps under `R`, with `c` for each of them it stays at `m` or
above from the start through. -/
def stepwiseDraw (R : Nat → Nat) (m c n : Nat) (x : Nat → Nat) : Nat :=
  drawnOver R x (n + 1) + c * metRun m x (n + 1)

/-- A course keeping `m` through the horizon adds `c` for each of its steps. -/
theorem stepwiseDraw_of_keeps {R : Nat → Nat} {m c n : Nat} {x : Nat → Nat} (keeps : Keeps m n x) :
    stepwiseDraw R m c n x = drawnOver R x (n + 1) + c * (n + 1) :=
  congrArg (fun z => drawnOver R x (n + 1) + c * z) (metRun_of_met keeps)

/-- A course met through `j` steps of the horizon and below `m` at the next adds `c` for each of the
`j`. -/
theorem stepwiseDraw_of_falls {R : Nat → Nat} {m c n j : Nat} {x : Nat → Nat}
    (met : ∀ t, t ≤ j → m ≤ x t) (below : x (j + 1) < m) (le : j ≤ n) :
    stepwiseDraw R m c n x = drawnOver R x (n + 1) + c * j :=
  match le_dest (Nat.le_succ_of_le le) with
  | ⟨i, split⟩ => congrArg (fun z => drawnOver R x (n + 1) + c * z)
      ((congrArg (metRun m x) split).trans (metRun_of_falls met below i))

/-- A course met through the first `n` steps adds at least `c` for each. -/
theorem stepwiseDraw_ge {R : Nat → Nat} {m c n : Nat} {x : Nat → Nat}
    (met : ∀ t, t ≤ n → m ≤ x t) : drawnOver R x (n + 1) + c * n ≤ stepwiseDraw R m c n x :=
  Nat.add_le_add_left (Nat.mul_le_mul_left c (metRun_ge met 1)) _

/-- **The logistic witness: a coupling a step.** From a source at two, the level the dweller needs,
under the logistic law with capacity two, under the order by what the taker draws with `c` added for
each step the source stays at two or above from the start through the horizon of `n + 2` steps:
where `3 ≤ c`, the course staying at two is an optimum and every optimum keeps the dweller met
through the horizon, whatever `n` (`continued_stepwise_frontier`, `Web.frontier_keeps_stepwise`);
where `2 ≤ c`, every optimum meets the dweller at every step but the horizon's last
(`Web.frontier_met_before_end`); where `1 ≤ c ≤ 2`, the course keeping the dweller met to the last
step and drawing the source to nothing there is an optimum
(`continued_ending_stepwise_frontier`); where `c ≤ 1`, the course drawing the source to one and holding it there is an optimum and every
optimum breaks the dweller within the horizon (`continued_holding_stepwise_frontier`,
`Web.frontier_breaks_at_end`). A coupling of the whole keeping must exceed `n + 3`
(`logistic_coupled`). -/
theorem logistic_stepwise (n c : Nat) :
    (3 ≤ c →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => stepwiseDraw logistic 2 c (n + 1) a < stepwiseDraw logistic 2 c (n + 1) b)
        (continued logistic (holdingTo 2 2 2 (n + 1)) (n + 1)) ∧
      ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => stepwiseDraw logistic 2 c (n + 1) a < stepwiseDraw logistic 2 c (n + 1) b) x →
      ∀ t, t ≤ n + 2 → (web (onSource x)).need t .dweller .source ≤
        (web (onSource x)).level t .source) ∧
    (2 ≤ c → ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => stepwiseDraw logistic 2 c (n + 1) a < stepwiseDraw logistic 2 c (n + 1) b) x →
      ∀ t, t ≤ n + 1 → (web (onSource x)).need t .dweller .source ≤
        (web (onSource x)).level t .source) ∧
    (1 ≤ c → c ≤ 2 →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => stepwiseDraw logistic 2 c (n + 1) a < stepwiseDraw logistic 2 c (n + 1) b)
        (continued logistic (holdingTo 2 2 0 (n + 1)) (n + 1))) ∧
    (c ≤ 1 →
      Frontier (OpenCourse logistic 2 2)
        (fun b a => stepwiseDraw logistic 2 c (n + 1) a < stepwiseDraw logistic 2 c (n + 1) b)
        (continued logistic (holding 2 1 (n + 1)) (n + 1)) ∧
      ∀ x, Frontier (OpenCourse logistic 2 2)
        (fun b a => stepwiseDraw logistic 2 c (n + 1) a < stepwiseDraw logistic 2 c (n + 1) b) x →
      ∃ t, t ≤ n + 1 ∧ (web (onSource x)).Broken t .dweller .source) :=
  have coupled : ∀ a, OpenCourse logistic 2 2 a → Keeps 2 (n + 1) a →
      drawnOver logistic a (n + 1 + 1) + c * (n + 1 + 1) ≤ stepwiseDraw logistic 2 c (n + 1) a :=
    fun _ _ keeps => Nat.le_of_eq (stepwiseDraw_of_keeps keeps).symm
  have bounded : ∀ a, OpenCourse logistic 2 2 a → Keeps 2 (n + 1) a →
      stepwiseDraw logistic 2 c (n + 1) a ≤ drawnOver logistic a (n + 1 + 1) + c * (n + 1 + 1) :=
    fun _ _ keeps => Nat.le_of_eq (stepwiseDraw_of_keeps keeps)
  have coupledAt : ∀ a j, OpenCourse logistic 2 2 a → (∀ t, t ≤ j → 2 ≤ a t) → a (j + 1) < 2 →
      j ≤ n + 1 → stepwiseDraw logistic 2 c (n + 1) a ≤ drawnOver logistic a (n + 1 + 1) + c * j :=
    fun _ _ _ met below le => Nat.le_of_eq (stepwiseDraw_of_falls met below le)
  ⟨fun three =>
    have rate : 1 ≤ 0 + c :=
      Nat.le_trans (Nat.le_trans (Nat.le_add_left 1 2) three) (Nat.le_of_eq (Nat.zero_add c).symm)
    ⟨continued_stepwise_frontier (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1)
      (y := 2) (q := 0) (r := 1) coupled bounded coupledAt logistic_le logistic_above rate three rfl
      (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 2) (Nat.le_add_right 2 2)
      (Nat.succ_pos n),
    fun x front =>
      Web.frontier_keeps_stepwise (W := web (onSource x)) (c := Place.source)
        (f := Formation.dweller) (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1) (w := c)
        (worth := stepwiseDraw logistic 2 c (n + 1)) (y := 2) (q := 0) (r := 1) (e := 2)
        (fun _ _ less => less) coupled coupledAt logistic_le logistic_above rate three rfl
        (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 2)
        (Nat.le_add_right 2 2) (Nat.succ_pos n) front (fun _ => rfl)⟩,
   fun two x front =>
    Web.frontier_met_before_end (W := web (onSource x)) (c := Place.source)
      (f := Formation.dweller) (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1) (w := c)
      (worth := stepwiseDraw logistic 2 c (n + 1)) (y := 2) (q := 0) (r := 1)
      (fun _ _ less => less) coupledAt (fun _ _ met => stepwiseDraw_ge met) logistic_le
      logistic_above (Nat.lt_of_lt_of_le (Nat.lt_succ_self 1)
        (Nat.le_trans two (Nat.le_of_eq (Nat.zero_add c).symm)))
      rfl (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 2) (Nat.le_refl 2)
      (Nat.succ_pos n) front (fun _ => rfl),
   fun one two =>
    continued_ending_stepwise_frontier (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1)
      (y := 2) (q := 0) (r := 1) bounded coupledAt (fun _ _ met => stepwiseDraw_ge met) logistic_le
      logistic_above (Nat.le_trans one (Nat.le_of_eq (Nat.zero_add c).symm)) two rfl
      (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_add_right 2 2) (Nat.le_refl 2)
      (Nat.succ_pos n),
   fun one =>
    have rate : 0 + c ≤ 1 := Nat.le_trans (Nat.le_of_eq (Nat.zero_add c)) one
    ⟨continued_holding_stepwise_frontier (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1)
      (y := 1) (q := 0) (r := 1) (fun _ => Nat.le_add_right _ _) bounded coupledAt logistic_le
      logistic_above rate (Nat.le_trans one (Nat.le_succ 1)) rfl (Nat.le_refl 2) (Nat.le_succ 1)
      (Nat.le_succ 2) (Nat.le_refl 2) (Nat.succ_pos n),
    fun x front =>
      Web.frontier_breaks_at_end (W := web (onSource x)) (c := Place.source)
        (f := Formation.dweller) (R := logistic) (k := 2) (s := 2) (m := 2) (n := n + 1) (w := c)
        (worth := stepwiseDraw logistic 2 c (n + 1)) (y := 2) (q := 0) (e := 0)
        (fun _ _ less => less) bounded (fun _ _ met => stepwiseDraw_ge met) logistic_above
        (Nat.lt_succ_of_le one) rfl (Nat.le_refl 2) (Nat.le_refl 2) (Nat.le_refl 2) (Nat.zero_le 2)
        (Nat.le_add_right 2 2) (Nat.le_refl 2) (Nat.succ_pos n) front (fun _ => trivial)
        (fun _ => rfl)⟩⟩

end Holding

end Optimum
