/-! ## Courses ranked over a horizon

Above, the part chooses again at each step. Here it ranks whole courses: an order on the courses
open to it at a condition beyond, rising with what a course draws there across a horizon of steps.
Where at most `r` is given at each step, what a course draws, what it leaves after the horizon and
everything the renewal falls short of `r` add to the starting level with `r` for each step; so an
order rising with what is drawn ranks courses exactly by the renewal they forgo and what they leave,
and a level registers in it only through what is given there. Where what is given is a law `R` of
the level, at most `r`, a course from a start draws across `n + 1` steps at most the start with what
is given there and `r` for each step after, exactly where it stands at a level of greatest renewal
at every step from the first to the `n`-th and leaves nothing after the last; where such a level is
within reach and the capacity, every optimum of every order rising with what is drawn is such a
course. So every optimum breaks at the first step a dependence whose need lies above every level of
greatest renewal and leaves it unmet through the horizon; a dependence every such level meets stands
through the horizon and is broken at its end; and where the renewal is the same at every level at or
above a need, two courses standing there and ending alike draw the same, whatever dependence above
the need one keeps and the other breaks. -/

namespace Optimum

section Horizon

variable {x g : Nat → Nat} {r : Nat}

/-- Sums over `n` steps of what agrees at each of them are the same. -/
theorem sum_eq_of_eq {f f' : Nat → Nat} :
    ∀ {n : Nat}, (∀ t, t < n → f t = f' t) →
      Amounts.whole.sum f 0 n = Amounts.whole.sum f' 0 n
  | 0, _ => rfl
  | n + 1, same => by
    show Amounts.whole.sum f 0 n + f (0 + n) = Amounts.whole.sum f' 0 n + f' (0 + n)
    rw [Nat.zero_add, sum_eq_of_eq (n := n) (fun t lt => same t (Nat.lt_succ_of_lt lt)),
      same n (Nat.lt_succ_self n)]

/-- A sum across `n + 1` steps is the first step with the sum across the `n` after it. -/
theorem sum_succ_first (f : Nat → Nat) :
    ∀ n, Amounts.whole.sum f 0 (n + 1) = f 0 + Amounts.whole.sum (fun t => f (t + 1)) 0 n
  | 0 => show 0 + f (0 + 0) = f 0 + 0 from (Nat.zero_add _).trans (Nat.add_zero _).symm
  | n + 1 => by
    show Amounts.whole.sum f 0 (n + 1) + f (0 + (n + 1)) =
      f 0 + (Amounts.whole.sum (fun t => f (t + 1)) 0 n + f (0 + n + 1))
    rw [sum_succ_first f n, Nat.add_assoc, Nat.zero_add, Nat.zero_add]

/-- Two amounts added and two more: the middle two exchanged. -/
theorem add_four (a b c d : Nat) : a + b + (c + d) = a + c + (b + d) := by
  rw [Nat.add_assoc, Nat.add_left_comm b c d, ← Nat.add_assoc]

/-- Nothing from two amounts added is nothing from each. -/
theorem eq_zero_of_add {a : Nat} : ∀ {b : Nat}, a + b = 0 → a = 0 ∧ b = 0
  | 0, zero => ⟨zero, rfl⟩
  | _ + 1, zero => absurd zero (Naturals.succ_ne_zero _)

/-- Adding the same amount first keeps two amounts apart. -/
theorem add_left_cancel_of {k a b : Nat} (same : k + a = k + b) : a = b :=
  Nat.le_antisymm (Naturals.le_of_add_le_add_left (k := k) (Nat.le_of_eq same))
    (Naturals.le_of_add_le_add_left (k := k) (Nat.le_of_eq same.symm))

/-- Of two equal sums of two amounts, the first amount of one is at most the first of the other
exactly where the second of the other is at most the second of the one. -/
theorem le_iff_of_add_eq {a b a' b' : Nat} (same : a + b = a' + b') : a ≤ a' ↔ b' ≤ b :=
  ⟨fun le => Naturals.le_of_add_le_add_left (k := a')
      (Nat.le_trans (Nat.le_of_eq same.symm) (Nat.add_le_add_right le b)),
   fun le => Naturals.le_of_add_le_add_right (k := b)
      (Nat.le_trans (Nat.le_of_eq same) (Nat.add_le_add_left le a'))⟩

/-- Nothing left of `n` less `m` is `n` at most `m`. -/
theorem le_of_sub_zero {n m : Nat} (zero : n - m = 0) : n ≤ m :=
  match Nat.lt_or_ge m n with
  | .inl lt => absurd (Nat.lt_of_lt_of_le lt (Nat.le_of_eq
      ((Naturals.sub_add_cancel (Nat.le_of_lt lt)).symm.trans
        ((congrArg (· + m) zero).trans (Nat.zero_add m))))) (Nat.lt_irrefl m)
  | .inr ge => ge

/-- A sum over `n` steps is nothing exactly where each step is nothing. -/
theorem sum_eq_zero_iff {f : Nat → Nat} :
    ∀ {n : Nat}, Amounts.whole.sum f 0 n = 0 ↔ ∀ t, t < n → f t = 0
  | 0 => ⟨fun _ _ lt => absurd lt (Nat.not_lt_zero _), fun _ => rfl⟩
  | n + 1 => ⟨fun zero =>
      have both := eq_zero_of_add (a := Amounts.whole.sum f 0 n) (b := f (0 + n)) zero
      fun t lt => match Nat.lt_or_ge t n with
        | .inl before => sum_eq_zero_iff.mp both.1 t before
        | .inr later => (congrArg f ((Nat.le_antisymm (Nat.le_of_lt_succ lt) later).trans
            (Nat.zero_add n).symm)).trans both.2,
     fun all => show Amounts.whole.sum f 0 n + f (0 + n) = 0 from
       (congrArg (· + f (0 + n))
         (sum_eq_zero_iff.mpr fun t lt => all t (Nat.lt_succ_of_lt lt))).trans
         ((Nat.zero_add _).trans
           ((congrArg f (Nat.zero_add n)).trans (all n (Nat.lt_succ_self n))))⟩

/-- **What is given and what it falls short of.** Where at most `r` is given at each step,
everything given across `n` steps, with everything it falls short of `r`, is `r` for each step. -/
theorem sum_add_shortfall (renews : ∀ t, g t ≤ r) :
    ∀ n, Amounts.whole.sum g 0 n + Amounts.whole.sum (fun t => r - g t) 0 n = r * n
  | 0 => rfl
  | n + 1 => by
    show Amounts.whole.sum g 0 n + g (0 + n) +
        (Amounts.whole.sum (fun t => r - g t) 0 n + (r - g (0 + n))) = r * (n + 1)
    rw [Nat.zero_add, add_four, sum_add_shortfall renews n, Naturals.add_sub_of_le (renews n),
      Nat.mul_succ]

/-- **What a course draws, leaves and forgoes.** Where each step leaves at most the level with what
is given and at most `r` is given at each step, what is drawn across `n` steps, with what stands
after them and everything the renewal falls short of `r`, is the starting level with `r` for each
step. -/
theorem drawn_add_shortfall (within : ∀ t, x (t + 1) ≤ x t + g t) (renews : ∀ t, g t ≤ r)
    (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 n + x n + Amounts.whole.sum (fun t => r - g t) 0 n =
      x 0 + r * n := by
  rw [Nat.add_comm (Amounts.whole.sum (drawnAt x g) 0 n), level_add_drawn_of_within within n,
    Nat.add_assoc, sum_add_shortfall renews n]

/-- **What a course draws after its first step, leaves and forgoes.** Where each step leaves at most
the level with what is given and at most `r` is given at each step, what is drawn across `n + 1`
steps, with what stands after them and everything the renewal falls short of `r` at the `n` steps
after the first, is the starting level with what is given at the first step and `r` for each step
after. -/
theorem drawn_add_shortfall_after (within : ∀ t, x (t + 1) ≤ x t + g t)
    (renews : ∀ t, g t ≤ r) (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 (n + 1) + x (n + 1) +
        Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = x 0 + g 0 + r * n := by
  have later : Amounts.whole.sum (fun t => drawnAt x g (t + 1)) 0 n + x (n + 1) +
      Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = x 1 + r * n :=
    drawn_add_shortfall (x := fun t => x (t + 1)) (g := fun t => g (t + 1))
      (fun t => within (t + 1)) (fun t => renews (t + 1)) n
  have first : x 1 + drawnAt x g 0 = x 0 + g 0 := Naturals.add_sub_of_le (within 0)
  rw [sum_succ_first, Nat.add_assoc (drawnAt x g 0), Nat.add_assoc (drawnAt x g 0), later,
    ← Nat.add_assoc, Nat.add_comm (drawnAt x g 0), first]

/-- **The most a course draws.** Where each step leaves at most the level with what is given and at
most `r` is given at each step, no course draws across `n + 1` steps more than the starting level
with what is given at the first step and `r` for each step after. -/
theorem drawn_le_most (within : ∀ t, x (t + 1) ≤ x t + g t) (renews : ∀ t, g t ≤ r)
    (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 (n + 1) ≤ x 0 + g 0 + r * n :=
  Nat.le_trans (Nat.le_add_right _ (x (n + 1))) (Nat.le_trans (Nat.le_add_right _ _)
    (Nat.le_of_eq (drawn_add_shortfall_after within renews n)))

/-- **Exactly which courses draw the most.** Where each step leaves at most the level with what is
given and at most `r` is given at each step, a course draws across `n + 1` steps the starting level
with what is given at the first step and `r` for each step after exactly where `r` is given at every
step after the first and nothing stands after the last. -/
theorem most_iff (within : ∀ t, x (t + 1) ≤ x t + g t) (renews : ∀ t, g t ≤ r) (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 (n + 1) = x 0 + g 0 + r * n ↔
      x (n + 1) = 0 ∧ ∀ t, t < n → g (t + 1) = r :=
  have whole := drawn_add_shortfall_after within renews n
  ⟨fun most =>
    have rest : x (n + 1) + Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = 0 :=
      add_left_cancel_of ((Nat.add_assoc _ _ _).symm.trans
        (whole.trans (most.symm.trans (Nat.add_zero _).symm)))
    have both := eq_zero_of_add rest
    ⟨both.1, fun t lt => Nat.le_antisymm (renews (t + 1))
        (le_of_sub_zero (sum_eq_zero_iff.mp both.2 t lt))⟩,
   fun ⟨left, renewed⟩ => by
    have none : Amounts.whole.sum (fun t => r - g (t + 1)) 0 n = 0 :=
      sum_eq_zero_iff.mpr fun t lt => (congrArg (r - ·) (renewed t lt)).trans (Nat.sub_self r)
    rw [left, none] at whole
    exact whole⟩

end Horizon

/-- What a course of levels `x` draws across `n` steps where `R` gives at each level. -/
def drawnOver (R : Nat → Nat) (x : Nat → Nat) (n : Nat) : Nat :=
  Amounts.whole.sum (drawnAt x fun t => R (x t)) 0 n

/-- **The courses open from a start.** From level `s`, where `R` gives at each level and at most
`k` may be drawn a step: each step leaves at most the level with what is given, and draws at most
`k`. -/
def OpenCourse (R : Nat → Nat) (k s : Nat) (x : Nat → Nat) : Prop :=
  x 0 = s ∧ ∀ t, x (t + 1) ≤ x t + R (x t) ∧ drawnAt x (fun t => R (x t)) t ≤ k

/-- The order of courses by what they draw across `n + 1` steps: more is better. -/
def byDrawn (R : Nat → Nat) (n : Nat) (b a : Nat → Nat) : Prop :=
  drawnOver R a (n + 1) < drawnOver R b (n + 1)

/-- From `s`, the course standing at `y` from the first step to the `n`-th and at nothing after. -/
def holding (s y n : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => if t < n then y else 0

variable {R : Nat → Nat} {k r s y n : Nat}

/-- The holding course stands at `y` from the first step to the `n`-th. -/
theorem holding_before {t : Nat} (before : t < n) : holding s y n (t + 1) = y :=
  if_pos before

/-- The holding course stands at nothing after the `n`-th step. -/
theorem holding_after {t : Nat} (after : n ≤ t) : holding s y n (t + 1) = 0 :=
  if_neg (Nat.not_lt_of_ge after)

/-- Each step of the holding course leaves at most the level with what is given, where `y` is
within the start with what is given there. -/
theorem holding_within (reach : y ≤ s + R s) (n : Nat) :
    ∀ t, holding s y n (t + 1) ≤ holding s y n t + R (holding s y n t)
  | 0 => match Nat.lt_or_ge 0 n with
    | .inl lt => Nat.le_trans (Nat.le_of_eq (holding_before lt)) reach
    | .inr ge => Nat.le_trans (Nat.le_of_eq (holding_after ge)) (Nat.zero_le _)
  | t + 1 => match Nat.lt_or_ge (t + 1) n with
    | .inl lt => Nat.le_trans (Nat.le_of_eq ((holding_before lt).trans
        (holding_before (Nat.lt_of_succ_lt lt)).symm)) (Nat.le_add_right _ _)
    | .inr ge => Nat.le_trans (Nat.le_of_eq (holding_after ge)) (Nat.zero_le _)

/-- **A course holding a level of greatest renewal draws the most.** Where `R` gives at most `r` at
every level and `r` at `y`, within the start with what is given there, the course holding `y` draws
across `n + 1` steps the start with what is given there and `r` for each step after. -/
theorem holding_most (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (n : Nat) : drawnOver R (holding s y n) (n + 1) = s + R s + r * n :=
  (most_iff (x := holding s y n) (g := fun t => R (holding s y n t)) (holding_within reach n)
    (fun _ => renews _) n).mpr
    ⟨holding_after (Nat.le_refl n), fun _ lt => (congrArg R (holding_before lt)).trans greatest⟩

/-- **The holding course is open**, over a horizon of at least two steps, with a capacity covering
what the first step draws down to `y` and `y` with `r`. -/
theorem holding_open (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ k) (long : 0 < n) :
    OpenCourse R k s (holding s y n) :=
  have stands : ∀ t, holding s y n (t + 1) + R (holding s y n (t + 1)) ≤ k := fun t =>
    match Nat.lt_or_ge t n with
    | .inl lt => by rw [holding_before lt, greatest]; exact holds
    | .inr ge => by
      rw [holding_after ge]
      exact Nat.le_trans (Nat.le_of_eq (Nat.zero_add _))
        (Nat.le_trans (renews 0) (Nat.le_trans (Nat.le_add_left r y) holds))
  ⟨rfl, fun t => ⟨holding_within reach n t, match t with
    | 0 => Nat.le_trans (Nat.le_of_eq (congrArg (s + R s - ·) (holding_before long)))
        (Nat.le_trans (sub_le_sub_right_of_le drawsDown y)
          (Nat.le_of_eq (Naturals.add_sub_cancel_left y k)))
    | t + 1 => Nat.le_trans (Nat.sub_le _ _) (stands t)⟩⟩

/-- No open course draws across `n + 1` steps more than the start with what is given there and `r`
for each step after, where `R` gives at most `r`. -/
theorem open_le_most (renews : ∀ z, R z ≤ r) {x : Nat → Nat} (opens : OpenCourse R k s x)
    (n : Nat) : drawnOver R x (n + 1) ≤ s + R s + r * n :=
  Eq.subst (motive := fun z => drawnOver R x (n + 1) ≤ z + R z + r * n) opens.1
    (drawn_le_most (fun t => (opens.2 t).1) (fun t => renews (x t)) n)

/-- **The holding course is an optimum** of the order by what is drawn. -/
theorem holding_frontier (renews : ∀ z, R z ≤ r) (greatest : R y = r) (reach : y ≤ s + R s)
    (drawsDown : s + R s ≤ y + k) (holds : y + r ≤ k) (long : 0 < n) :
    Frontier (OpenCourse R k s) (byDrawn R n) (holding s y n) :=
  ⟨holding_open renews greatest reach drawsDown holds long, fun _ opens more =>
    Nat.not_le_of_gt more (Nat.le_trans (open_le_most renews opens n)
      (Nat.le_of_eq (holding_most renews greatest reach n).symm))⟩

/-- **Every optimum holds a level of greatest renewal and leaves nothing.** Where `R` gives at most
`r` at every level and `r` at some `y` within the start with what is given there, over a horizon of
at least two steps, with a capacity covering what the first step draws down to `y` and `y` with
`r`, every optimum of every order on the courses open from the start that rises with what is drawn
across `n + 1` steps draws the most: it
stands at a level of greatest renewal at every step from the first to the `n`-th and at nothing
after the last. -/
theorem frontier_holds {better : (Nat → Nat) → (Nat → Nat) → Prop}
    (renews : ∀ z, R z ≤ r)
    (rising : ∀ a b, drawnOver R a (n + 1) < drawnOver R b (n + 1) → better b a)
    (greatest : R y = r) (reach : y ≤ s + R s) (drawsDown : s + R s ≤ y + k)
    (holds : y + r ≤ k) (long : 0 < n) {x : Nat → Nat}
    (front : Frontier (OpenCourse R k s) better x) :
    x (n + 1) = 0 ∧ ∀ t, t < n → R (x (t + 1)) = r :=
  have most : drawnOver R x (n + 1) = s + R s + r * n :=
    Nat.le_antisymm (open_le_most renews front.1 n)
      (match Nat.lt_or_ge (drawnOver R x (n + 1)) (s + R s + r * n) with
      | .inl less => absurd (rising x (holding s y n) (Nat.lt_of_lt_of_le less
          (Nat.le_of_eq (holding_most renews greatest reach n).symm)))
          (front.2 _ (holding_open renews greatest reach drawsDown holds long))
      | .inr ge => ge)
  (most_iff (fun t => (front.1.2 t).1) (fun t => renews (x t)) n).mp
    (Eq.subst (motive := fun z => drawnOver R x (n + 1) = z + R z + r * n) front.1.1.symm most)

end Optimum

namespace Flow

open Optimum

variable {L L' : Flow F C} {W W' : Web F C} {c : C} {r : Nat}

/-- **Under balance, what is drawn is what is taken.** -/
theorem Balances.drawnAt_eq (balances : L.Balances W) (c : C) (t : Nat) :
    drawnAt (fun t => W.level t c) (fun t => L.given t c) t = L.taken t c :=
  (congrArg (· - W.level (t + 1) c) (balances t c).symm).trans
    ((congrArg (· - W.level (t + 1) c) (Nat.add_comm _ _)).trans (Naturals.add_sub_cancel _ _))

/-- Under balance, each step leaves at most the level with what is given. -/
theorem Balances.within (balances : L.Balances W) (c : C) (t : Nat) :
    W.level (t + 1) c ≤ W.level t c + L.given t c :=
  Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (balances t c))

/-- Under balance, everything taken from a condition across `n` steps is what is drawn there. -/
theorem Balances.sum_taken (balances : L.Balances W) (c : C) (n : Nat) :
    Amounts.whole.sum (fun t => L.taken t c) 0 n =
      Amounts.whole.sum (drawnAt (fun t => W.level t c) fun t => L.given t c) 0 n :=
  sum_eq_of_eq fun t _ => (balances.drawnAt_eq c t).symm

/-- **What a balanced course takes, leaves and forgoes.** Where the formations taking part give a
condition at most `r` a step, what they take from it across `n` steps, with its level after them and
everything given there falls short of `r`, is its starting level with `r` for each step. -/
theorem Balances.taken_add_shortfall (balances : L.Balances W) (renews : ∀ t, L.given t c ≤ r)
    (n : Nat) :
    Amounts.whole.sum (fun t => L.taken t c) 0 n + W.level n c +
        Amounts.whole.sum (fun t => r - L.given t c) 0 n = W.level 0 c + r * n := by
  rw [balances.sum_taken c n]
  exact drawn_add_shortfall (balances.within c) renews n

/-- **Balanced courses ranked by what they forgo and leave.** Of two balanced courses from one
level at a condition, each given at most `r` there a step, the first takes from it across `n` steps
at most what the second takes exactly where what the second leaves with everything given to it
falls short of `r` is at most the first's: an order rising with what is taken registers the levels
a course passes through only through what is given at them. -/
theorem Balances.taken_le_iff (balances : L.Balances W) (balances' : L'.Balances W')
    (renews : ∀ t, L.given t c ≤ r) (renews' : ∀ t, L'.given t c ≤ r)
    (same : W'.level 0 c = W.level 0 c) (n : Nat) :
    Amounts.whole.sum (fun t => L.taken t c) 0 n ≤
        Amounts.whole.sum (fun t => L'.taken t c) 0 n ↔
      W'.level n c + Amounts.whole.sum (fun t => r - L'.given t c) 0 n ≤
        W.level n c + Amounts.whole.sum (fun t => r - L.given t c) 0 n :=
  le_iff_of_add_eq (by
    rw [← Nat.add_assoc, ← Nat.add_assoc, balances.taken_add_shortfall renews n,
      balances'.taken_add_shortfall renews' n, same])

/-- **Alike in what is given and left, alike in what is taken.** Two balanced courses from one
level at a condition, given the same there at each of `n` steps and leaving the same after them,
take the same from it across them, whatever levels they pass through. -/
theorem Balances.taken_eq_of_alike (balances : L.Balances W) (balances' : L'.Balances W')
    (same : W'.level 0 c = W.level 0 c) {n : Nat}
    (given : ∀ t, t < n → L'.given t c = L.given t c)
    (left : W'.level n c = W.level n c) :
    Amounts.whole.sum (fun t => L'.taken t c) 0 n = Amounts.whole.sum (fun t => L.taken t c) 0 n :=
  add_left_cancel_of (k := W.level n c)
    (calc W.level n c + Amounts.whole.sum (fun t => L'.taken t c) 0 n
        = W'.level n c + Amounts.whole.sum (drawnAt (fun t => W'.level t c)
            fun t => L'.given t c) 0 n := by rw [left, balances'.sum_taken c n]
      _ = W'.level 0 c + Amounts.whole.sum (fun t => L'.given t c) 0 n :=
          level_add_drawn_of_within (x := fun t => W'.level t c) (g := fun t => L'.given t c)
            (balances'.within c) n
      _ = W.level 0 c + Amounts.whole.sum (fun t => L.given t c) 0 n := by
          rw [same, sum_eq_of_eq given]
      _ = W.level n c + Amounts.whole.sum (drawnAt (fun t => W.level t c)
            fun t => L.given t c) 0 n :=
          (level_add_drawn_of_within (x := fun t => W.level t c) (g := fun t => L.given t c)
            (balances.within c) n).symm
      _ = W.level n c + Amounts.whole.sum (fun t => L.taken t c) 0 n := by
          rw [balances.sum_taken c n])

/-- **A balanced course is open.** Where what is given to a condition is a law `R` of its level and
what is taken there is at most `k` a step, the course of its levels is open from its start. -/
theorem Balances.open_course {R : Nat → Nat} {k : Nat} (balances : L.Balances W)
    (renewal : ∀ t, L.given t c = R (W.level t c)) (within : ∀ t, L.taken t c ≤ k) :
    OpenCourse R k (W.level 0 c) fun t => W.level t c :=
  ⟨rfl, fun t => ⟨Nat.le_trans (balances.within c t) (Nat.le_of_eq
      (congrArg (W.level t c + ·) (renewal t))),
    Nat.le_trans (Nat.le_of_eq ((congrArg (fun z => W.level t c + z - W.level (t + 1) c)
      (renewal t)).symm.trans (balances.drawnAt_eq c t))) (within t)⟩⟩

end Flow

namespace Web

open Optimum

variable {W : Web F C} {c : C} {f : F} {R : Nat → Nat} {k r y m n : Nat}
  {better : (Nat → Nat) → (Nat → Nat) → Prop}

/-- **Far-sight breaks at the first step a dependence above every level of greatest renewal.** Where
what is given to a condition is a law `R` of its level, at most `r` at every level and `r` at some
`y` within the start with what is given there, over a horizon of at least two steps, with a capacity
covering what the first step draws down to `y` and `y` with `r`, and every level where `R` gives `r`
lies below a formation's need on the condition, met at the start: every optimum, among the courses
open from the start, of every order rising with what is drawn across `n + 1` steps breaks the
dependence at the first step and leaves it unmet through the horizon. -/
theorem frontier_broken (renews : ∀ z, R z ≤ r)
    (rising : ∀ a b, drawnOver R a (n + 1) < drawnOver R b (n + 1) → better b a)
    (greatest : R y = r) (reach : y ≤ W.level 0 c + R (W.level 0 c))
    (drawsDown : W.level 0 c + R (W.level 0 c) ≤ y + k) (holds : y + r ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k (W.level 0 c)) better fun t => W.level t c)
    (above : ∀ z, R z = r → z < m) (depends : W.requires 0 f c) (need : W.need 0 f c = m)
    (start : m ≤ W.level 0 c) :
    W.Broken 0 f c ∧ ∀ t, t < n + 1 → W.level (t + 1) c < m :=
  have held := frontier_holds renews rising greatest reach drawsDown holds long front
  have unmet : ∀ t, t < n + 1 → W.level (t + 1) c < m := fun t lt =>
    match Nat.lt_or_ge t n with
    | .inl before => above _ (held.2 t before)
    | .inr after => Eq.subst (motive := fun z => W.level (z + 1) c < m)
        (Nat.le_antisymm after (Nat.le_of_lt_succ lt))
        (Nat.lt_of_le_of_lt (Nat.le_of_eq held.1)
          (Nat.lt_of_le_of_lt (Nat.zero_le y) (above y greatest)))
  ⟨⟨depends, Nat.le_trans (Nat.le_of_eq need) start,
    Nat.lt_of_lt_of_le (unmet 0 (Nat.succ_pos n)) (Nat.le_of_eq need.symm)⟩, unmet⟩

/-- **Far-sight keeps a dependence every level of greatest renewal meets through the horizon, and
breaks it at its end.** Where what is given to a condition is a law `R` of its level, at most `r` at
every level and `r` at some `y` within the start with what is given there, over a horizon of at
least two steps, with a capacity covering what the first step draws down to `y` and `y` with `r`,
and every level where `R` gives `r` meets a formation's positive need on the condition, met at the
start: under every optimum, among the
courses open from the start, of every order rising with what is drawn across `n + 1` steps, the
dependence stands at every step to the `n`-th and is broken at the last. -/
theorem frontier_kept (renews : ∀ z, R z ≤ r)
    (rising : ∀ a b, drawnOver R a (n + 1) < drawnOver R b (n + 1) → better b a)
    (greatest : R y = r) (reach : y ≤ W.level 0 c + R (W.level 0 c))
    (drawsDown : W.level 0 c + R (W.level 0 c) ≤ y + k) (holds : y + r ≤ k) (long : 0 < n)
    (front : Frontier (OpenCourse R k (W.level 0 c)) better fun t => W.level t c)
    (meets : ∀ z, R z = r → m ≤ z) (needs : 0 < m) (depends : W.requires n f c)
    (need : W.need n f c = m) (start : m ≤ W.level 0 c) :
    (∀ t, t ≤ n → m ≤ W.level t c) ∧ W.Broken n f c :=
  have held := frontier_holds renews rising greatest reach drawsDown holds long front
  have stands : ∀ t, t ≤ n → m ≤ W.level t c := fun t le => match t, le with
    | 0, _ => start
    | t + 1, le => meets _ (held.2 t (Nat.lt_of_succ_le le))
  ⟨stands, depends, Nat.le_trans (Nat.le_of_eq need) (stands n (Nat.le_refl n)),
    Nat.lt_of_le_of_lt (Nat.le_of_eq held.1) (Nat.lt_of_lt_of_le needs (Nat.le_of_eq need.symm))⟩

end Web

namespace Optimum

namespace Holding

open Diversion DrawnBeyond Drain

/-- What the taker draws from the source at each step of the holding course. -/
def draw (R : Nat → Nat) (s y n : Nat) : Nat → Nat :=
  drawnAt (holding s y n) fun t => R (holding s y n t)

/-- The store along the holding course: everything the taker has drawn. -/
def store (R : Nat → Nat) (s y n : Nat) : Nat → Nat
  | 0 => 0
  | t + 1 => store R s y n t + draw R s y n t

/-- The levels along the holding course. -/
def level (R : Nat → Nat) (s y n : Nat) (t : Nat) : Place → Nat
  | .source => holding s y n t
  | .store => store R s y n t

/-- At each step the taker takes what the holding course draws from the source and gives it to the
store; the dweller gives the source what `R` gives at its level. -/
def course (R : Nat → Nat) (s y n : Nat) : Flow Formation Place where
  present _ := [.taker, .dweller]
  take t f c := match f, c with
    | .taker, .source => draw R s y n t
    | .taker, .store => 0
    | .dweller, _ => 0
  give t f c := match f, c with
    | .taker, .store => draw R s y n t
    | .taker, .source => 0
    | .dweller, .source => R (holding s y n t)
    | .dweller, .store => 0

variable {R : Nat → Nat} {s y n : Nat}

/-- The holding course balances: the source loses what the taker draws and gains what `R` gives;
the store gains what the taker draws. -/
theorem course_balances (reach : y ≤ s + R s) : (course R s y n).Balances (web (level R s y n)) :=
  fun t c => match c with
  | .source => show holding s y n (t + 1) + (draw R s y n t + 0) =
      holding s y n t + (0 + (R (holding s y n t) + 0)) by
    rw [Nat.add_zero, Nat.add_zero, Nat.zero_add]
    exact Naturals.add_sub_of_le (holding_within reach n t)
  | .store => show store R s y n (t + 1) + (0 + 0) = store R s y n t + (draw R s y n t + 0) from
    rfl

/-- The logistic law with room for two, `s (2 - s)`: one unit renewed at level one, nothing at
none or at two or more. -/
def logistic (s : Nat) : Nat := s * (2 - s)

/-- The logistic law gives one unit at one and nothing from two on. -/
theorem logistic_beyond (s : Nat) : logistic (s + 2) = 0 :=
  (congrArg ((s + 2) * ·) (sub_eq_zero_of_le (Nat.le_add_left 2 s))).trans (Nat.mul_zero _)

/-- The logistic law gives at most one. -/
theorem logistic_le : ∀ s, logistic s ≤ 1
  | 0 => Nat.zero_le 1
  | 1 => Nat.le_refl 1
  | s + 2 => Nat.le_trans (Nat.le_of_eq (logistic_beyond s)) (Nat.zero_le 1)

/-- The logistic law gives one only at one, below the dweller's need. -/
theorem logistic_greatest : ∀ z, logistic z = 1 → z < 2
  | 0, zero => absurd zero (Naturals.succ_ne_zero 0).symm
  | 1, _ => Nat.lt_succ_self 1
  | s + 2, one => absurd ((logistic_beyond s).symm.trans one) (Naturals.succ_ne_zero 0).symm

/-- **The logistic witness: far-sight breaks the dweller.** From a source at two, the level the
dweller needs and where the logistic law renews nothing, the course holding the source at one, where
the law renews most, balances and is an optimum of the order by what the taker draws across
`n + 2` steps among the courses open to it with capacity two; it breaks the dweller's dependence at
the first step and leaves it unmet through the horizon, as every such optimum does
(`Web.frontier_broken`). -/
theorem logistic_broken (n : Nat) :
    (course logistic 2 1 (n + 1)).Balances (web (level logistic 2 1 (n + 1))) ∧
      Frontier (OpenCourse logistic 2 2) (byDrawn logistic (n + 1)) (holding 2 1 (n + 1)) ∧
      (web (level logistic 2 1 (n + 1))).Broken 0 .dweller .source ∧
      ∀ t, t < n + 2 → (web (level logistic 2 1 (n + 1))).level (t + 1) .source < 2 :=
  have front :
      Frontier (OpenCourse logistic 2 2) (byDrawn logistic (n + 1)) (holding 2 1 (n + 1)) :=
    holding_frontier logistic_le rfl (Nat.le_succ 1) (Nat.le_succ 2) (Nat.le_refl 2)
      (Nat.succ_pos n)
  ⟨course_balances (Nat.le_succ 1), front,
   Web.frontier_broken (W := web (level logistic 2 1 (n + 1))) (c := Place.source)
     (f := Formation.dweller) (y := 1) logistic_le (fun _ _ more => more) rfl (Nat.le_succ 1)
     (Nat.le_succ 2) (Nat.le_refl 2) (Nat.succ_pos n) front logistic_greatest trivial rfl
     (Nat.le_refl 2)⟩

/-- A gate: one unit renewed at every level from one, nothing at none. -/
def gate : Nat → Nat
  | 0 => 0
  | _ + 1 => 1

/-- The gate gives at most one. -/
theorem gate_le : ∀ s, gate s ≤ 1
  | 0 => Nat.zero_le 1
  | _ + 1 => Nat.le_refl 1

/-- **The gated witness: the order registers nothing of a dependence above the gate.** From a source
at two, under a gate renewing one unit at every level from one, the course holding the source at two
and the course holding it at one are both optima of the order by what the taker draws across `n + 2`
steps among the courses open to it with capacity three, and the taker takes the same from the
source along both (`Flow.Balances.taken_eq_of_alike`); the first keeps the dweller's dependence at
every step to the `(n + 1)`-th, the second breaks it at the first step. -/
theorem gated_alike (n : Nat) :
    Frontier (OpenCourse gate 3 2) (byDrawn gate (n + 1)) (holding 2 2 (n + 1)) ∧
      Frontier (OpenCourse gate 3 2) (byDrawn gate (n + 1)) (holding 2 1 (n + 1)) ∧
      Amounts.whole.sum (fun t => (course gate 2 1 (n + 1)).taken t .source) 0 (n + 2) =
        Amounts.whole.sum (fun t => (course gate 2 2 (n + 1)).taken t .source) 0 (n + 2) ∧
      (∀ t, t ≤ n + 1 → 2 ≤ (web (level gate 2 2 (n + 1))).level t .source) ∧
      (web (level gate 2 1 (n + 1))).Broken 0 .dweller .source :=
  have alike : ∀ t, t < n + 2 →
      (course gate 2 1 (n + 1)).given t .source = (course gate 2 2 (n + 1)).given t .source :=
    fun t lt => congrArg (fun z => 0 + (z + 0)) (match t, lt with
      | 0, _ => rfl
      | _ + 1, lt =>
        have before := Nat.lt_of_succ_lt_succ lt
        (congrArg gate (holding_before (s := 2) (y := 1) before)).trans
          (congrArg gate (holding_before (s := 2) (y := 2) before)).symm)
  ⟨holding_frontier gate_le rfl (Nat.le_succ 2) (Nat.le_add_left 3 2) (Nat.le_refl 3)
     (Nat.succ_pos n),
   holding_frontier gate_le rfl (Nat.le_trans (Nat.le_succ 1) (Nat.le_succ 2)) (Nat.le_succ 3)
     (Nat.le_succ 2) (Nat.succ_pos n),
   Flow.Balances.taken_eq_of_alike (L := course gate 2 2 (n + 1))
     (W := web (level gate 2 2 (n + 1)))
     (L' := course gate 2 1 (n + 1)) (W' := web (level gate 2 1 (n + 1))) (c := Place.source)
     (n := n + 2) (course_balances (Nat.le_succ 2))
     (course_balances (Nat.le_trans (Nat.le_succ 1) (Nat.le_succ 2))) rfl alike
     ((holding_after (s := 2) (y := 1) (Nat.le_refl (n + 1))).trans
       (holding_after (s := 2) (y := 2) (Nat.le_refl (n + 1))).symm),
   fun t le => match t, le with
     | 0, _ => Nat.le_refl 2
     | _ + 1, le => Nat.le_of_eq (holding_before (s := 2) (y := 2) (Nat.lt_of_succ_le le)).symm,
   trivial, Nat.le_refl 2,
   Nat.lt_of_le_of_lt (Nat.le_of_eq (holding_before (s := 2) (y := 1) (Nat.succ_pos n)))
     (Nat.lt_succ_self 1)⟩

end Holding

end Optimum
