
/-! ## A course of steps

Above, one step. Here a part chooses again at every step of a course: at each, the levels after
are an optimum of its order among the outcomes open to it from the levels before, the formations
outside it exchanging as they do in that step. At a condition beyond, each step's level is read off
the one before by the law of one step: the level with what the rest gives, less what the rest takes
and the part's capacity, or nothing. Where what the rest gives there is at most `r` a step,
however low the level, a draw above `r` brings it below any positive need `m` once the steps
exceed its starting excess over `m`, and for good, and a dependence at that need is lost; where it
renews by exactly `r` while it stands at the need, a draw of `k` keeps it there exactly where
`k ≤ r`. Over `n` steps no course draws more than the starting level with `r` for each step. What
the renewal does below the need decides only what is drawn: where it stops below the need (a
gate), a draw above the renewal draws at most the starting level with `r` for each of its units,
however long the course; where at least one is given at every step, however low the level, the
draw has no bound, everything given drawn and the dependence lost all the same. A draw of
`k ≤ r` draws `k` at every step. -/

namespace Optimum

/-! ### Levels renewed and drawn

A level `x` along a course, `g t` given to it and `d t` taken from it at the step from `t`, each
step taking at most what stands with what is given: `x (t + 1) = x t + g t - d t`. -/

section Levels

variable {x g d : Nat → Nat} {r m : Nat}

/-- Less the same amount keeps the order (as `Nat.sub_le_sub_right`, with an empty axiom
report). -/
theorem sub_le_sub_right_of_le {n k : Nat} (le : n ≤ k) : ∀ a, n - a ≤ k - a
  | 0 => le
  | a + 1 => Nat.pred_le_pred (sub_le_sub_right_of_le le a)

/-- Less more is at most less less (as `Nat.sub_le_sub_left`, with an empty axiom report). -/
theorem sub_le_sub_left_of_le {a b : Nat} (le : a ≤ b) (n : Nat) : n - b ≤ n - a :=
  match le_dest le with
  | ⟨j, same⟩ => Eq.subst (motive := fun y => n - y ≤ n - a) same.symm
      (Nat.le_trans (Nat.le_of_eq (Naturals.sub_sub n a j).symm) (Nat.sub_le (n - a) j))

/-- **Above the renewal, the level never rises.** Where at most `r` is given and more than `r`
taken at a step, the level after is at most the level before. -/
theorem never_rises (step : ∀ t, x (t + 1) = x t + g t - d t) {t : Nat} (renews : g t ≤ r)
    (over : r < d t) : x (t + 1) ≤ x t := by
  rw [step t]
  exact Nat.le_trans (sub_le_sub_left_of_le (Nat.le_trans renews (Nat.le_of_lt over)) _)
    (Nat.le_of_eq (Naturals.add_sub_cancel _ _))

/-- **Above the renewal, below the need the level stays below.** Where at most `r` is given and
more than `r` taken at every step, a level below the need at one step is below it at every later
step, whatever is given below the need. -/
theorem level_stays_below (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (over : ∀ t, r < d t) {s : Nat} (below : x s < m) : ∀ j, x (s + j) < m
  | 0 => below
  | j + 1 => Nat.lt_of_le_of_lt (never_rises step (renews (s + j)) (over (s + j)))
      (level_stays_below step renews over below j)

/-- Above the renewal, the level stays within its start. -/
theorem level_le_start (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (over : ∀ t, r < d t) : ∀ t, x t ≤ x 0
  | 0 => Nat.le_refl _
  | t + 1 => Nat.le_trans (never_rises step (renews t) (over t)) (level_le_start step renews over t)

/-- **Above the renewal, a positive level falls.** Where at most `r` is given and more than `r`
taken at a step, a positive level falls by at least one across it. -/
theorem falls_over (step : ∀ t, x (t + 1) = x t + g t - d t) {t : Nat} (renews : g t ≤ r)
    (over : r < d t) (positive : 0 < x t) : x (t + 1) + 1 ≤ x t :=
  calc x (t + 1) + 1 = x t + g t - d t + 1 := by rw [step t]
    _ ≤ x t + r - (r + 1) + 1 :=
        Nat.add_le_add_right (Nat.le_trans (sub_le_sub_right_of_le (Nat.add_le_add_left renews _) _)
          (sub_le_sub_left_of_le over _)) 1
    _ = x t := by
        rw [← Naturals.sub_sub, Naturals.add_sub_cancel,
          Naturals.sub_add_cancel (c := 1) positive]

/-- **Above the renewal, the level falls below any need, within its starting excess over it.**
Where at every step at most `r` is given, however low the level, and more than `r` is taken, the
level stands below a positive need `m` at every step `t` with `x 0 < m + t`, so at every step from
`x 0` on. -/
theorem ends_within (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (over : ∀ t, r < d t) (needs : 0 < m) :
    ∀ t, x 0 < m + t → x t < m :=
  have falling : ∀ t, x t = 0 ∨ x t + t ≤ x 0 := fun t => by
    induction t with
    | zero => exact .inr (Nat.le_refl _)
    | succ t ih =>
      match Nat.eq_zero_or_pos (x t) with
      | .inl gone => exact .inl (Nat.eq_zero_of_le_zero
          (Nat.le_trans (never_rises step (renews t) (over t)) (Nat.le_of_eq gone)))
      | .inr positive =>
        match ih with
        | .inl gone => exact (absurd (Eq.subst (motive := fun y => 0 < y) gone positive)
            (Nat.lt_irrefl 0))
        | .inr fell =>
          exact .inr (calc x (t + 1) + (t + 1) = x (t + 1) + 1 + t :=
                (Nat.add_assoc _ _ _).symm.trans (Nat.add_right_comm _ _ _)
            _ ≤ x t + t := Nat.add_le_add_right (falls_over step (renews t) (over t) positive) t
            _ ≤ x 0 := fell)
  fun t within => match falling t with
    | .inl gone => Nat.lt_of_le_of_lt (Nat.le_of_eq gone) needs
    | .inr fell => Nat.lt_of_add_lt_add_right (Nat.lt_of_le_of_lt fell within)

/-- **Within the renewal, the level stays at the need and never falls.** Where exactly `r` is
given while the level stands at the need or above and at most `r` is taken at every step, a level
starting at the need stands at it or above at every step and does not fall across any. -/
theorem kept_at_need (step : ∀ t, x (t + 1) = x t + g t - d t)
    (renewing : ∀ t, m ≤ x t → g t = r) (within : ∀ t, d t ≤ r) (start : m ≤ x 0) :
    ∀ t, m ≤ x t ∧ x t ≤ x (t + 1) :=
  have rises : ∀ t, m ≤ x t → x t ≤ x (t + 1) := fun t atNeed => by
    rw [step t, renewing t atNeed]
    exact Nat.le_trans (Nat.le_of_eq (Naturals.add_sub_cancel _ _).symm)
      (sub_le_sub_left_of_le (within t) _)
  have stands : ∀ t, m ≤ x t := fun t => by
    induction t with
    | zero => exact start
    | succ t ih => exact Nat.le_trans ih (rises t ih)
  fun t => ⟨stands t, rises t (stands t)⟩

/-- What is given at a step is at most `r` where it is `r` at the need or above and nothing
below. -/
theorem renews_of (renewing : ∀ t, m ≤ x t → g t = r)
    (unsupported : ∀ t, x t < m → g t = 0) (t : Nat) : g t ≤ r :=
  match Nat.lt_or_ge (x t) m with
  | .inl below => Nat.le_trans (Nat.le_of_eq (unsupported t below)) (Nat.zero_le r)
  | .inr atNeed => Nat.le_of_eq (renewing t atNeed)

/-- **Kept exactly within the renewal.** Where exactly `r` is given while the level stands at a
positive need `m` or above, at most `r` below it, and `k` is taken at every step, a level starting
at the need stands at it at every step exactly where `k ≤ r`. -/
theorem kept_iff_within (step : ∀ t, x (t + 1) = x t + g t - d t) {k : Nat}
    (renewing : ∀ t, m ≤ x t → g t = r) (renews : ∀ t, g t ≤ r)
    (draws : ∀ t, d t = k) (needs : 0 < m) (start : m ≤ x 0) :
    (∀ t, m ≤ x t) ↔ k ≤ r :=
  ⟨fun kept => match Nat.lt_or_ge r k with
    | .inl over => absurd (kept (x 0)) (Nat.not_le_of_gt (ends_within step renews
        (fun t => Nat.lt_of_lt_of_le over (Nat.le_of_eq (draws t).symm)) needs (x 0)
        (Nat.lt_add_of_pos_left needs)))
    | .inr within => within,
   fun within t => (kept_at_need step renewing (fun t => Nat.le_trans (Nat.le_of_eq (draws t))
      within) start t).1⟩

/-- What the step from `t` takes from a level `x` given `g`: the level with what is given, less
what stands after. -/
def drawnAt (x g : Nat → Nat) (t : Nat) : Nat := x t + g t - x (t + 1)

/-- **What stands and what was drawn.** Across `n` steps, what stands after with everything drawn
is the starting level with everything given (sums of `Amounts.whole`). -/
theorem level_add_drawn (step : ∀ t, x (t + 1) = x t + g t - d t) :
    ∀ n, x n + Amounts.whole.sum (drawnAt x g) 0 n = x 0 + Amounts.whole.sum g 0 n
  | 0 => rfl
  | n + 1 => by
    show x (n + 1) + (Amounts.whole.sum (drawnAt x g) 0 n + drawnAt x g (0 + n)) =
      x 0 + (Amounts.whole.sum g 0 n + g (0 + n))
    rw [Nat.zero_add]
    have back : x (n + 1) + drawnAt x g n = x n + g n :=
      Naturals.add_sub_of_le (show x (n + 1) ≤ x n + g n by rw [step n]; exact Nat.sub_le _ _)
    rw [Nat.add_left_comm, back, ← Nat.add_assoc, Nat.add_comm (Amounts.whole.sum _ 0 n) (x n),
      level_add_drawn step n, Nat.add_assoc]

/-- A sum of at most `r` at each step is at most `r` for each step. -/
theorem sum_le_mul (renews : ∀ t, g t ≤ r) :
    ∀ n, Amounts.whole.sum g 0 n ≤ r * n
  | 0 => Nat.zero_le _
  | n + 1 => Nat.le_trans
      (Nat.le_of_eq (congrArg (Amounts.whole.sum g 0 n + g ·) (Nat.zero_add n)))
      (Nat.le_trans (Nat.add_le_add (sum_le_mul renews n) (renews n))
        (Nat.le_of_eq (Nat.mul_succ r n).symm))

/-- Where at most `r` is given at each step and nothing from `N` on, the sum over any number of
steps is at most `r` for each step before `N`. -/
theorem sum_le_mul_until {N : Nat} (renews : ∀ t, g t ≤ r)
    (after : ∀ t, N ≤ t → g t = 0) :
    ∀ n, Amounts.whole.sum g 0 n ≤ r * N
  | 0 => Nat.zero_le _
  | n + 1 => match Nat.lt_or_ge n N with
    | .inl before => Nat.le_trans (sum_le_mul renews (n + 1)) (Nat.mul_le_mul_left r before)
    | .inr later => Nat.le_trans (Nat.le_of_eq ((congrArg (Amounts.whole.sum g 0 n + g ·)
        (Nat.zero_add n)).trans ((congrArg (_ + ·) (after n later)).trans (Nat.add_zero _))))
        (sum_le_mul_until renews after n)

/-- **No course draws more than its start and the renewal.** Where at most `r` is given at each
step, everything drawn across `n` steps is at most the starting level with `r` for each step. -/
theorem drawn_within (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (n : Nat) : Amounts.whole.sum (drawnAt x g) 0 n ≤ x 0 + r * n :=
  Nat.le_trans (Nat.le_add_left _ (x n)) (Nat.le_trans (Nat.le_of_eq (level_add_drawn step n))
    (Nat.add_le_add_left (sum_le_mul renews n) _))

/-- **Gated, above the renewal a course draws a bounded amount, however long.** Where at most `r`
is given at each step, nothing while the level stands below a positive need (the gate), and more
than `r` is taken at each step, everything drawn across any number of steps is at most the
starting level with `r` for each of its units. -/
theorem ended_drawn_le (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (unsupported : ∀ t, x t < m → g t = 0) (over : ∀ t, r < d t) (needs : 0 < m) (n : Nat) :
    Amounts.whole.sum (drawnAt x g) 0 n ≤ x 0 + r * x 0 :=
  Nat.le_trans (Nat.le_add_left _ (x n)) (Nat.le_trans (Nat.le_of_eq (level_add_drawn step n))
    (Nat.add_le_add_left (sum_le_mul_until (N := x 0) renews (fun t later => unsupported t
      (ends_within step renews over needs t
        (Nat.lt_of_le_of_lt later (Nat.lt_add_of_pos_left needs)))) n) _))

/-- A sum of at least `a` at each step is at least `a` for each step. -/
theorem mul_le_sum {a : Nat} (gives : ∀ t, a ≤ g t) : ∀ n, a * n ≤ Amounts.whole.sum g 0 n
  | 0 => Nat.le_trans (Nat.le_of_eq (Nat.mul_zero a)) (Nat.zero_le _)
  | n + 1 => Nat.le_trans (Nat.le_of_eq (Nat.mul_succ a n))
      (Nat.le_trans (Nat.add_le_add (mul_le_sum gives n) (gives n))
        (Nat.le_of_eq (congrArg (Amounts.whole.sum g 0 n + g ·) (Nat.zero_add n)).symm))

/-- **Where the level ends no higher than it started, everything given was drawn.** -/
theorem given_le_drawn (step : ∀ t, x (t + 1) = x t + g t - d t) {n : Nat} (within : x n ≤ x 0) :
    Amounts.whole.sum g 0 n ≤ Amounts.whole.sum (drawnAt x g) 0 n :=
  Naturals.le_of_add_le_add_left (k := x 0)
    (Nat.le_trans (Nat.le_of_eq (level_add_drawn step n).symm) (Nat.add_le_add_right within _))

/-- **Above the renewal, everything given is drawn.** Where at least `a` and at most `r` is given at
every step, however low the level, and more than `r` is taken, everything drawn across `n` steps is
at least `a` for each step: with `a = r`, as much as a level kept at its need by a draw of `r`
yields (`kept_drawn`). -/
theorem drawn_at_least (step : ∀ t, x (t + 1) = x t + g t - d t) {a : Nat} (renews : ∀ t, g t ≤ r)
    (gives : ∀ t, a ≤ g t) (over : ∀ t, r < d t) (n : Nat) :
    a * n ≤ Amounts.whole.sum (drawnAt x g) 0 n :=
  Nat.le_trans (mul_le_sum gives n) (given_le_drawn step (level_le_start step renews over n))

/-- **Ungated, above the renewal the draw has no bound.** Where at least one and at most `r` is
given at every step, however low the level, and more than `r` is taken, everything drawn has no
bound, at least one a step, while the level falls below any positive need all the same
(`ends_within`). -/
theorem drawn_unbounded (step : ∀ t, x (t + 1) = x t + g t - d t) (renews : ∀ t, g t ≤ r)
    (gives : ∀ t, 0 < g t) (over : ∀ t, r < d t) :
    ¬ ∃ B, ∀ n, Amounts.whole.sum (drawnAt x g) 0 n ≤ B :=
  fun ⟨B, bounded⟩ => Nat.not_succ_le_self B
    (Nat.le_trans (Nat.le_of_eq (Nat.one_mul _).symm)
      (Nat.le_trans (drawn_at_least step renews gives over (B + 1)) (bounded _)))

/-- A level less what is left of it after `k` is taken is `k`, where `k` is within it. -/
theorem sub_sub_of_le {a k : Nat} (within : k ≤ a) : a - (a - k) = k :=
  (congrArg (· - (a - k)) (Naturals.add_sub_of_le within).symm).trans
    (Naturals.add_sub_cancel k (a - k))

/-- **Within the renewal, a course draws its whole take at every step.** Where exactly `r` is
given while the level stands at the need or above and `k ≤ r` is taken at every step, a level
starting at the need has `k` drawn at every step: `k` for each step of the course. -/
theorem kept_drawn (step : ∀ t, x (t + 1) = x t + g t - d t) {k : Nat}
    (renewing : ∀ t, m ≤ x t → g t = r) (draws : ∀ t, d t = k) (within : k ≤ r)
    (start : m ≤ x 0) : ∀ n, Amounts.whole.sum (drawnAt x g) 0 n = k * n
  | 0 => rfl
  | n + 1 =>
    have atNeed := (kept_at_need step renewing (fun t => Nat.le_trans (Nat.le_of_eq (draws t))
      within) start n).1
    have each : drawnAt x g n = k := by
      show x n + g n - x (n + 1) = k
      rw [step n, renewing n atNeed, draws n]
      exact sub_sub_of_le (Nat.le_trans within (Nat.le_add_left r (x n)))
    (congrArg (Amounts.whole.sum (drawnAt x g) 0 n + drawnAt x g ·) (Nat.zero_add n)).trans
      ((congrArg (· + drawnAt x g n) (kept_drawn step renewing draws within start n)).trans
        ((congrArg (k * n + ·) each).trans (Nat.mul_succ k n).symm))

/-- **Gated, over a long enough course keeping draws more.** Of two levels from the same kind of
renewal, `r` a step at a positive need and nothing below, one drawn above `r` at every step and one
drawn `r` at every step from a start at the need: over `n` steps with `x 0 + r * x 0 < r * n`, the
second has had more drawn from it. -/
theorem keeping_draws_more {x' g' d' : Nat → Nat} (step : ∀ t, x (t + 1) = x t + g t - d t)
    (renews : ∀ t, g t ≤ r) (unsupported : ∀ t, x t < m → g t = 0) (over : ∀ t, r < d t)
    (needs : 0 < m) (step' : ∀ t, x' (t + 1) = x' t + g' t - d' t)
    (renewing' : ∀ t, m ≤ x' t → g' t = r) (draws' : ∀ t, d' t = r) (start' : m ≤ x' 0)
    {n : Nat} (long : x 0 + r * x 0 < r * n) :
    Amounts.whole.sum (drawnAt x g) 0 n < Amounts.whole.sum (drawnAt x' g') 0 n :=
  Nat.lt_of_le_of_lt (ended_drawn_le step renews unsupported over needs n)
    (Nat.lt_of_lt_of_le long (Nat.le_of_eq
      (kept_drawn step' renewing' draws' (Nat.le_refl r) start' n).symm))

/-- **Gated, the draw is bounded exactly above the renewal.** Where exactly `r` is given while the
level stands at a positive need or above, nothing below it, and `k > 0` is taken at every step, a
level starting at the need has a bound on everything ever drawn from it exactly where `r < k`. -/
theorem drawn_bounded_iff (step : ∀ t, x (t + 1) = x t + g t - d t) {k : Nat}
    (renewing : ∀ t, m ≤ x t → g t = r) (unsupported : ∀ t, x t < m → g t = 0)
    (draws : ∀ t, d t = k) (positive : 0 < k) (needs : 0 < m) (start : m ≤ x 0) :
    (∃ B, ∀ n, Amounts.whole.sum (drawnAt x g) 0 n ≤ B) ↔ r < k :=
  ⟨fun ⟨B, bounded⟩ => match Nat.lt_or_ge r k with
    | .inl over => over
    | .inr within => absurd (bounded (B + 1)) (Nat.not_le_of_gt (Nat.lt_of_lt_of_le
        (Nat.lt_succ_self B) (Nat.le_trans (Nat.le_of_eq (Nat.one_mul (B + 1)).symm)
          (Nat.le_trans (Nat.mul_le_mul_right (B + 1) positive)
            (Nat.le_of_eq (kept_drawn step renewing draws within start (B + 1)).symm))))),
   fun over => ⟨x 0 + r * x 0, ended_drawn_le step (renews_of renewing unsupported) unsupported
    (fun t => Nat.lt_of_lt_of_le over (Nat.le_of_eq (draws t).symm)) needs⟩⟩

/-- Where a decided property holds at `0` and fails at `n`, it holds at some step before `n` and
fails at the next. -/
theorem last_before {P : Nat → Prop} [DecidablePred P] (first : P 0) :
    ∀ {n : Nat}, ¬ P n → ∃ T, T < n ∧ P T ∧ ¬ P (T + 1)
  | 0, fails => absurd first fails
  | n + 1, fails =>
    if holds : P n then ⟨n, Nat.lt_succ_self n, holds, fails⟩
    else match last_before first holds with
      | ⟨T, lt, at_, next⟩ => ⟨T, Nat.lt_succ_of_lt lt, at_, next⟩

end Levels

open Flow

/-- **A course of re-optimizing steps.** At every step, the levels after are an optimum of the
part's order among the outcomes open to it from the levels before, the formations outside it
exchanging as they do in that step. -/
def Reoptimizes (L : Flow F C) (W : Web F C) (part : F → Bool) (cap : F → C → Nat)
    (ds rest : List C) (better : (C → Nat) → (C → Nat) → Prop) : Prop :=
  ∀ t, Frontier (L.Outcome part (W.level t) cap (ds ++ rest) t) better (W.level (t + 1))

variable {L : Flow F C} {W : Web F C} {part : F → Bool} {cap : F → C → Nat} {ds rest : List C}
  {better : (C → Nat) → (C → Nat) → Prop}

/-- **Each step of the course read off the one before.** Over a course of re-optimizing steps, at
a condition beyond, the level after each step is the level before with what the rest gives, less
what the rest takes and the part's capacity, or nothing. -/
theorem course_beyond [DecidableEq F] [DecidableEq C] (distinct : ∀ t, Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C}
    (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better)
    {c : C} (mem : c ∈ rest) (t : Nat) :
    W.level (t + 1) c = W.level t c + L.restGiven part t c -
      (L.restTaken part t c + L.capacity part cap t c) :=
  (optimum_beyond (distinct t) cdistinct apart inside rising (course t) mem).trans
    (Naturals.sub_sub _ _ _)

/-- **Several optimizers along a course.** Where every step of a balanced course is a mutual best
response, at a condition beyond every optimizer's family the level after each step is the level
before with what the formations outside every optimizer give, less what they take and the
optimizers' joint capacity, or nothing. -/
theorem mutual_course_beyond [DecidableEq F] [DecidableEq C] {optimizer : F → Bool}
    {dsOf restOf : F → List C} {betterOf : F → (C → Nat) → (C → Nat) → Prop}
    (distinct : ∀ t, Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (dsOf h ++ restOf h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ restOf h → ¬ c ∈ dsOf h)
    (inside : ∀ h, optimizer h = true → ∃ e, e ∈ dsOf h)
    (rising : ∀ h, optimizer h = true → Rising (dsOf h) (betterOf h))
    (best : ∀ t, MutualBest L optimizer (W.level t) cap dsOf restOf betterOf t (W.level (t + 1)))
    (balances : L.Balances W) {c : C}
    (beyond : ∀ t h, h ∈ L.present t → optimizer h = true → c ∈ restOf h) (t : Nat) :
    W.level (t + 1) c = W.level t c + L.restGiven optimizer t c -
      (L.restTaken optimizer t c + L.capacity optimizer cap t c) :=
  (mutual_beyond (distinct t) cdistinct apart inside rising (best t) (balances t)
    (beyond t)).trans (Naturals.sub_sub _ _ _)

end Optimum

namespace Flow

/-- **A renewal needs support.** Where whatever gives to `c` across the step from `t` is
supported there (`Flow.GiversSupported`, as where only active formations give and activity needs
support) and every formation outside a part giving to `c` depends on `c` at a need of at least
`m`, nothing outside the part gives to `c` across a step from a level below `m`: the gate on which
`Flow.stays_below` turns, for the formations outside a part. -/
theorem restGiven_unsupported {L : Flow F C} {W : Web F C} {part : F → Bool} {t : Nat} {c : C}
    {m : Nat} (givers : L.GiversSupported W t c)
    (gated : ∀ h, h ∈ L.present t → part h = false → 0 < L.give t h c →
      W.requires t h c ∧ m ≤ W.need t h c)
    (below : W.level t c < m) : L.restGiven part t c = 0 :=
  (total_congr_on fun h present => by
    show (bif part h then 0 else L.give t h c) = 0
    cases out : part h
    · show L.give t h c = 0
      match zero : L.give t h c with
      | 0 => rfl
      | n + 1 =>
        have positive : 0 < L.give t h c :=
          Eq.subst (motive := fun y => 0 < y) zero.symm (Nat.succ_pos n)
        exact absurd (Nat.le_trans (gated h present out positive).2
            (givers h present positive c (gated h present out positive).1))
          (Nat.not_le_of_gt below)
    · rfl).trans (total_zero _)

end Flow

namespace Web

open Flow Optimum

variable {W : Web F C} {c : C} {f : F} {r m : Nat}

/-- **Above the renewal, a dependence on the condition is lost.** Where a condition's level is
given at most `r` at each step, however low it stands, more than `r` is taken at each step, and a
formation depends on it at a positive need `m` throughout, starting met, the dependence is broken
at some step and never met again. -/
theorem lost_over {g d : Nat → Nat} (step : ∀ t, W.level (t + 1) c = W.level t c + g t - d t)
    (renews : ∀ t, g t ≤ r) (over : ∀ t, r < d t) (needs : 0 < m)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m)
    (start : m ≤ W.level 0 c) : W.Lost c :=
  have ended := ends_within (x := fun t => W.level t c) step renews over needs
  match last_before (P := fun t => m ≤ W.level t c) start (n := W.level 0 c)
      (Nat.not_le_of_gt (ended _ (Nat.lt_add_of_pos_left needs))) with
  | ⟨T, _, met, fails⟩ =>
    have next : W.level (T + 1) c < m := Nat.gt_of_not_le fails
    ⟨f, T, ⟨depends T, Nat.le_trans (Nat.le_of_eq (need T)) met,
        Nat.lt_of_lt_of_le next (Nat.le_of_eq (need T).symm)⟩,
     fun _ later => match le_dest later with
      | ⟨j, same⟩ => Eq.subst (motive := fun y => W.level y c < W.need T f c) same.symm
          (Nat.lt_of_lt_of_le
            (level_stays_below (x := fun t => W.level t c) step renews over next j)
            (Nat.le_of_eq (need T).symm))⟩

/-- **Lost exactly above the renewal.** Where a condition's level is given exactly `r` while it
stands at a positive need `m` or above, at most `r` below it, `k` is taken at every step, and a
formation depends on it at that need throughout, starting met, the dependence is lost exactly where
`r < k`; where `k ≤ r` the level does not fall across any step. -/
theorem lost_iff {g d : Nat → Nat} {k : Nat}
    (step : ∀ t, W.level (t + 1) c = W.level t c + g t - d t)
    (renewing : ∀ t, m ≤ W.level t c → g t = r) (renews : ∀ t, g t ≤ r)
    (draws : ∀ t, d t = k) (needs : 0 < m) (depends : ∀ t, W.requires t f c)
    (need : ∀ t, W.need t f c = m) (start : m ≤ W.level 0 c) : W.Lost c ↔ r < k :=
  ⟨fun ⟨_, T, broken, _⟩ => match Nat.lt_or_ge r k with
    | .inl over => over
    | .inr within => absurd (Nat.lt_of_lt_of_le broken.2.2 broken.2.1)
        (Nat.not_lt_of_ge (kept_at_need (x := fun t => W.level t c) step renewing
          (fun t => Nat.le_trans (Nat.le_of_eq (draws t)) within) start T).2),
   fun over => lost_over step renews
    (fun t => Nat.lt_of_lt_of_le over (Nat.le_of_eq (draws t).symm)) needs depends need start⟩

variable {L : Flow F C} {part : F → Bool} {cap : F → C → Nat} {ds rest : List C}
  {better : (C → Nat) → (C → Nat) → Prop}

/-- **A re-optimizing course loses a dependence beyond exactly where its draw exceeds the
renewal.** Over a course of re-optimizing steps, at a condition beyond that the rest renews by
exactly `r` while it stands at a positive need `m`, by at most `r` below, with what the rest takes
and the part's capacity there `k` at every step, and a formation depending on it at `m` throughout,
starting met, the dependence is lost exactly where `r < k`. -/
theorem course_lost_iff [DecidableEq F] [DecidableEq C] (distinct : ∀ t, Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C}
    (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better)
    (mem : c ∈ rest) {k : Nat} (renewing : ∀ t, m ≤ W.level t c → L.restGiven part t c = r)
    (renews : ∀ t, L.restGiven part t c ≤ r)
    (draws : ∀ t, L.restTaken part t c + L.capacity part cap t c = k) (needs : 0 < m)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m)
    (start : m ≤ W.level 0 c) :
    W.Lost c ↔ r < k :=
  lost_iff (course_beyond distinct cdistinct apart inside rising course mem) renewing renews
    draws needs depends need start

/-- **A re-optimizing course keeps a condition beyond at its need exactly within the renewal.**
Over a course of re-optimizing steps, at a condition beyond that the rest renews by exactly `r`
while it stands at a positive need `m`, by at most `r` below, with what the rest takes and the
part's capacity there `k` at every step, from a start at the need, the condition stands at the need
at every step exactly where `k ≤ r`. -/
theorem course_kept_iff [DecidableEq F] [DecidableEq C] (distinct : ∀ t, Distinct (L.present t))
    (cdistinct : Distinct (ds ++ rest)) (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C}
    (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better)
    (mem : c ∈ rest) {k : Nat} (renewing : ∀ t, m ≤ W.level t c → L.restGiven part t c = r)
    (renews : ∀ t, L.restGiven part t c ≤ r)
    (draws : ∀ t, L.restTaken part t c + L.capacity part cap t c = k) (needs : 0 < m)
    (start : m ≤ W.level 0 c) : (∀ t, m ≤ W.level t c) ↔ k ≤ r :=
  kept_iff_within (x := fun t => W.level t c)
    (course_beyond distinct cdistinct apart inside rising course mem) renewing renews draws
    needs start

/-- **No re-optimizing course draws more than its start and the renewal.** Over a course of
re-optimizing steps, at a condition beyond that the rest gives at most `r` a step, everything
drawn there across `n` steps (the level with what the rest gives, less what stands after) is at
most the starting level with `r` for each step. -/
theorem course_drawn_within [DecidableEq F] [DecidableEq C]
    (distinct : ∀ t, Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C} (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better) (mem : c ∈ rest)
    (renews : ∀ t, L.restGiven part t c ≤ r) (n : Nat) :
    Amounts.whole.sum (drawnAt (fun t => W.level t c) fun t => L.restGiven part t c) 0 n ≤
      W.level 0 c + r * n :=
  drawn_within (x := fun t => W.level t c)
    (course_beyond distinct cdistinct apart inside rising course mem) renews n

/-- **Gated, a re-optimizing course above the renewal draws a bounded amount.** Over a course of
re-optimizing steps, at a condition beyond that the rest gives at most `r` a step and nothing while
it stands below a positive need `m`, with what the rest takes and the part's capacity there above
`r` at every step, everything ever drawn there is at most the starting level with `r` for each of
its units. -/
theorem course_ended_drawn [DecidableEq F] [DecidableEq C]
    (distinct : ∀ t, Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C} (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better) (mem : c ∈ rest)
    (renews : ∀ t, L.restGiven part t c ≤ r)
    (unsupported : ∀ t, W.level t c < m → L.restGiven part t c = 0)
    (over : ∀ t, r < L.restTaken part t c + L.capacity part cap t c) (needs : 0 < m) (n : Nat) :
    Amounts.whole.sum (drawnAt (fun t => W.level t c) fun t => L.restGiven part t c) 0 n ≤
      W.level 0 c + r * W.level 0 c :=
  ended_drawn_le (x := fun t => W.level t c)
    (course_beyond distinct cdistinct apart inside rising course mem) renews unsupported over
    needs n

/-- **Ungated, a re-optimizing course above the renewal loses the dependence and draws without
bound.** Over a course of re-optimizing steps, at a condition beyond that the rest gives at least
`a` and at most `r` at every step, however low it stands, with what the rest takes and the part's
capacity there above `r` at every step, a dependence on it at a positive need `m` throughout,
starting met, is lost, while everything drawn there across `n` steps is at least `a` for each step
and, for a positive `a`, has no bound: where the dependence is lost, the gate is what bounds the
draw. -/
theorem course_drawn_unbounded [DecidableEq F] [DecidableEq C]
    (distinct : ∀ t, Distinct (L.present t)) (cdistinct : Distinct (ds ++ rest))
    (apart : ∀ c, c ∈ rest → ¬ c ∈ ds) {e : C} (inside : e ∈ ds) (rising : Rising ds better)
    (course : Reoptimizes L W part cap ds rest better) (mem : c ∈ rest)
    {a : Nat} (renews : ∀ t, L.restGiven part t c ≤ r) (gives : ∀ t, a ≤ L.restGiven part t c)
    (over : ∀ t, r < L.restTaken part t c + L.capacity part cap t c) (needs : 0 < m)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m)
    (start : m ≤ W.level 0 c) :
    W.Lost c ∧ (∀ n, a * n ≤
      Amounts.whole.sum (drawnAt (fun t => W.level t c) fun t => L.restGiven part t c) 0 n) ∧
      (0 < a → ¬ ∃ B, ∀ n,
        Amounts.whole.sum (drawnAt (fun t => W.level t c) fun t => L.restGiven part t c) 0 n ≤ B) :=
  have step := course_beyond distinct cdistinct apart inside rising course mem
  ⟨lost_over step renews over needs depends need start,
   drawn_at_least (x := fun t => W.level t c) step renews gives over,
   fun positive => drawn_unbounded (x := fun t => W.level t c) step renews
     (fun t => Nat.lt_of_lt_of_le positive (gives t)) over⟩

/-- **Several optimizers each within the renewal can lose it together.** Where every step of a
balanced course is a mutual best response, a condition beyond every optimizer's family is given by
the formations outside them at most `r` a step, however low it stands, what those formations take
with the optimizers' joint capacity there exceeds `r` at every step, and a formation depends on it
at a positive need `m` throughout, starting met, the dependence is lost, however small each
optimizer's own capacity. -/
theorem mutual_course_lost [DecidableEq F] [DecidableEq C] {optimizer : F → Bool}
    {dsOf restOf : F → List C} {betterOf : F → (C → Nat) → (C → Nat) → Prop}
    (distinct : ∀ t, Distinct (L.present t))
    (cdistinct : ∀ h, optimizer h = true → Distinct (dsOf h ++ restOf h))
    (apart : ∀ h, optimizer h = true → ∀ c, c ∈ restOf h → ¬ c ∈ dsOf h)
    (inside : ∀ h, optimizer h = true → ∃ e, e ∈ dsOf h)
    (rising : ∀ h, optimizer h = true → Rising (dsOf h) (betterOf h))
    (best : ∀ t, MutualBest L optimizer (W.level t) cap dsOf restOf betterOf t (W.level (t + 1)))
    (balances : L.Balances W)
    (beyond : ∀ t h, h ∈ L.present t → optimizer h = true → c ∈ restOf h)
    (renews : ∀ t, L.restGiven optimizer t c ≤ r)
    (over : ∀ t, r < L.restTaken optimizer t c + L.capacity optimizer cap t c) (needs : 0 < m)
    (depends : ∀ t, W.requires t f c) (need : ∀ t, W.need t f c = m)
    (start : m ≤ W.level 0 c) :
    W.Lost c :=
  lost_over (mutual_course_beyond distinct cdistinct apart inside rising best balances beyond)
    renews over needs depends need start

end Web

namespace Optimum

namespace Renewing

open Diversion DrawnBeyond Drain

/-- What the dweller gives the source across a step from level `s`: `r` where the source meets its
need of two, nothing below. -/
def renewal (r s : Nat) : Nat := if 2 ≤ s then r else 0

/-- The source along the course from `s₀`: each step adds the renewal and the taker takes `k`, or
all there is. -/
def source (k r s₀ : Nat) : Nat → Nat
  | 0 => s₀
  | t + 1 => source k r s₀ t + renewal r (source k r s₀ t) - k

/-- What the dweller gives the source at each step of the course. -/
def renewed (k r s₀ : Nat) (t : Nat) : Nat := renewal r (source k r s₀ t)

/-- What the taker takes from the source at the step from `t`. -/
def draw (k r s₀ : Nat) : Nat → Nat := drawnAt (source k r s₀) (renewed k r s₀)

/-- The store along the course: everything the taker has drawn. -/
def store (k r s₀ : Nat) : Nat → Nat
  | 0 => 0
  | t + 1 => store k r s₀ t + draw k r s₀ t

/-- The levels along the course. -/
def level (k r s₀ : Nat) (t : Nat) : Place → Nat
  | .source => source k r s₀ t
  | .store => store k r s₀ t

/-- At each step the taker takes what it draws from the source and gives it to the store; the
dweller gives the source the renewal. -/
def course (k r s₀ : Nat) : Flow Formation Place where
  present _ := [.taker, .dweller]
  take t f c := match f, c with
    | .taker, .source => draw k r s₀ t
    | .taker, .store => 0
    | .dweller, _ => 0
  give t f c := match f, c with
    | .taker, .store => draw k r s₀ t
    | .taker, .source => 0
    | .dweller, .source => renewed k r s₀ t
    | .dweller, .store => 0

variable {k r s₀ : Nat}

/-- What the step leaves is within the level with the renewal. -/
theorem source_within (t : Nat) :
    source k r s₀ (t + 1) ≤ source k r s₀ t + renewed k r s₀ t :=
  Nat.sub_le _ _

/-- The renewal is `r` where the source stands at its need. -/
theorem renewed_at {t : Nat} (atNeed : 2 ≤ source k r s₀ t) : renewed k r s₀ t = r :=
  if_pos atNeed

/-- Nothing is renewed where the source stands below its need. -/
theorem renewed_below {t : Nat} (below : source k r s₀ t < 2) : renewed k r s₀ t = 0 :=
  if_neg (Nat.not_le_of_gt below)

/-- The renewal is at most `r`. -/
theorem renewal_le (r s : Nat) : renewal r s ≤ r :=
  match Nat.lt_or_ge s 2 with
  | .inl below => Nat.le_trans (Nat.le_of_eq (if_neg (Nat.not_le_of_gt below))) (Nat.zero_le r)
  | .inr atNeed => Nat.le_of_eq (if_pos atNeed)

/-- What the taker draws at a step is at most `k`. -/
theorem draw_le (t : Nat) : draw k r s₀ t ≤ k :=
  match Nat.lt_or_ge (source k r s₀ t + renewed k r s₀ t) k with
  | .inl below => Nat.le_trans (Nat.sub_le _ _) (Nat.le_of_lt below)
  | .inr within => Nat.le_of_eq (sub_sub_of_le within)

/-- At most `k`, and at most the level with the renewal, is at most what the taker draws. -/
theorem le_draw {a : Nat} (t : Nat) (atMostK : a ≤ k)
    (atMostLevel : a ≤ source k r s₀ t + renewed k r s₀ t) : a ≤ draw k r s₀ t :=
  match Nat.lt_or_ge (source k r s₀ t + renewed k r s₀ t) k with
  | .inl below => Nat.le_trans atMostLevel (Nat.le_of_eq (show source k r s₀ t +
      renewed k r s₀ t = source k r s₀ t + renewed k r s₀ t -
        (source k r s₀ t + renewed k r s₀ t - k) by
      rw [sub_eq_zero_of_le (Nat.le_of_lt below), Nat.sub_zero]))
  | .inr within => Nat.le_trans atMostK (Nat.le_of_eq (sub_sub_of_le within).symm)

/-- The course balances: the source loses what the taker draws and gains the renewal; the store
gains what the taker draws. -/
theorem course_balances : (course k r s₀).Balances (web (level k r s₀)) := fun t c =>
  match c with
  | .source => show source k r s₀ (t + 1) + (draw k r s₀ t + 0) =
      source k r s₀ t + (0 + (renewed k r s₀ t + 0)) by
    rw [Nat.add_zero, Nat.add_zero, Nat.zero_add]
    exact Naturals.add_sub_of_le (source_within t)
  | .store => show store k r s₀ (t + 1) + (0 + 0) = store k r s₀ t + (draw k r s₀ t + 0) from
    rfl

/-- The taker acts within its capacity `k` at every step. -/
theorem course_within (t : Nat) :
    (course k r s₀).ActsWithin takerPart (takerCap k) ([Place.store] ++ [Place.source]) t
      (course k r s₀) :=
  ⟨rfl, fun _ _ _ => ⟨rfl, rfl⟩,
   fun h c member => match h, c, member with
    | .taker, .source, _ => draw_le t
    | .taker, .store, _ => Nat.le_refl 0,
   fun h c member outside => match h, c, member with
    | .taker, .store, _ => absurd (.head _) outside
    | .taker, .source, _ => rfl,
   fun h member => match h, member with
    | .taker, _ => show draw k r s₀ t + (0 + 0) ≤ 0 + (draw k r s₀ t + 0) from
        Nat.le_of_eq (Nat.zero_add _).symm⟩

/-- **At every step, the taker's draw is an optimum of the store's order.** Every outcome open to
the taker leaves the store at most where its draw does: it gives the store no more than it takes,
takes at most `k`, from the source alone, and at most what stands there with the renewal. -/
theorem course_optimum (t : Nat) :
    Frontier ((course k r s₀).Outcome takerPart (level k r s₀ t) (takerCap k)
      ([Place.store] ++ [Place.source]) t) storeOrder (level k r s₀ (t + 1)) :=
  ⟨⟨course k r s₀, course_within t, course_balances t⟩,
   fun o ⟨L', acts, balances⟩ above => by
    have atStore : o .store + L'.taken t .store = store k r s₀ t + L'.given t .store :=
      balances .store
    have src : o .source + L'.taken t .source = source k r s₀ t + L'.given t .source :=
      balances .source
    have gives : L'.given t .store = L'.give t .taker .store + (L'.give t .dweller .store + 0) :=
      congrArg (fun ps => total ps fun f => L'.give t f .store) acts.1
    have takes : L'.taken t .source = L'.take t .taker .source + (L'.take t .dweller .source + 0) :=
      congrArg (fun ps => total ps fun f => L'.take t f .source) acts.1
    have renews : L'.given t .source =
        L'.give t .taker .source + (L'.give t .dweller .source + 0) :=
      congrArg (fun ps => total ps fun f => L'.give t f .source) acts.1
    have dwellerStore : L'.give t .dweller .store = 0 := (acts.2.1 .dweller .store rfl).2
    have dwellerTake : L'.take t .dweller .source = 0 := (acts.2.1 .dweller .source rfl).1
    have dwellerGive : L'.give t .dweller .source = renewed k r s₀ t :=
      (acts.2.1 .dweller .source rfl).2
    have conserved : L'.give t .taker .store + (L'.give t .taker .source + 0) ≤
        L'.take t .taker .store + (L'.take t .taker .source + 0) := acts.2.2.2.2 .taker rfl
    have fromStore : L'.take t .taker .store ≤ 0 := acts.2.2.1 .taker .store rfl
    have fromSource : L'.take t .taker .source ≤ k := acts.2.2.1 .taker .source rfl
    rw [dwellerStore] at gives
    rw [dwellerTake] at takes
    rw [dwellerGive] at renews
    have gives : L'.given t .store = L'.give t .taker .store := gives
    have takes : L'.taken t .source = L'.take t .taker .source := takes
    have renews : L'.given t .source = L'.give t .taker .source + renewed k r s₀ t := renews
    have conserved : L'.give t .taker .store + L'.give t .taker .source ≤
        L'.take t .taker .store + L'.take t .taker .source := conserved
    rw [Nat.le_antisymm fromStore (Nat.zero_le _), Nat.zero_add] at conserved
    rw [takes, renews] at src
    have toSource : L'.take t .taker .source ≤
        source k r s₀ t + renewed k r s₀ t + L'.give t .taker .source :=
      calc L'.take t .taker .source ≤ o .source + L'.take t .taker .source := Nat.le_add_left _ _
        _ = source k r s₀ t + (L'.give t .taker .source + renewed k r s₀ t) := src
        _ = source k r s₀ t + renewed k r s₀ t + L'.give t .taker .source := by
            rw [Nat.add_comm (L'.give t .taker .source), Nat.add_assoc]
    have atMostLevel : L'.give t .taker .store ≤ source k r s₀ t + renewed k r s₀ t :=
      Naturals.le_of_add_le_add_right (Nat.le_trans conserved toSource)
    have atMostK : L'.give t .taker .store ≤ k :=
      Nat.le_trans (Nat.le_add_right _ _) (Nat.le_trans conserved fromSource)
    have atMost : o .store ≤ store k r s₀ (t + 1) :=
      calc o .store ≤ o .store + L'.taken t .store := Nat.le_add_right _ _
        _ = store k r s₀ t + L'.give t .taker .store := by rw [atStore, gives]
        _ ≤ store k r s₀ t + draw k r s₀ t :=
            Nat.add_le_add_left (le_draw t atMostK atMostLevel) _
    exact Nat.not_le_of_gt above atMost⟩

/-- **The taker re-optimizes at every step of the course.** -/
theorem course_reoptimizes :
    Reoptimizes (course k r s₀) (web (level k r s₀)) takerPart (takerCap k) [Place.store]
      [Place.source] storeOrder :=
  course_optimum

/-- **Each step of the source read off the one before, by the law of the course.** Derived from
`Optimum.course_beyond`. -/
theorem source_beyond (t : Nat) :
    (web (level k r s₀)).level (t + 1) .source = (web (level k r s₀)).level t .source +
      (course k r s₀).restGiven takerPart t .source -
        ((course k r s₀).restTaken takerPart t .source +
          (course k r s₀).capacity takerPart (takerCap k) t .source) :=
  course_beyond (fun _ => formations_distinct) store_source_distinct source_apart (.head [])
    storeOrder_rising course_reoptimizes (.head []) t

/-- What the dweller gives the source is the renewal. -/
theorem restGiven_source (t : Nat) :
    (course k r s₀).restGiven takerPart t .source = renewed k r s₀ t :=
  show 0 + (renewed k r s₀ t + 0) = renewed k r s₀ t from Nat.zero_add _

/-- Nothing outside the taker takes from the source, and the taker's capacity there is `k`. -/
theorem draws_source (t : Nat) :
    (course k r s₀).restTaken takerPart t .source +
      (course k r s₀).capacity takerPart (takerCap k) t .source = k :=
  show 0 + (0 + 0) + (k + (0 + 0)) = k from Nat.zero_add k

/-- The renewal is `r` where the source stands at its need of two. -/
theorem renewing_source (t : Nat) (atNeed : 2 ≤ (web (level k r s₀)).level t .source) :
    (course k r s₀).restGiven takerPart t .source = r :=
  (restGiven_source t).trans (renewed_at atNeed)

/-- Nothing is renewed where the source stands below its need. -/
theorem unsupported_source (t : Nat) (below : (web (level k r s₀)).level t .source < 2) :
    (course k r s₀).restGiven takerPart t .source = 0 :=
  (restGiven_source t).trans (renewed_below below)

/-- **The dweller's dependence is lost exactly where the taker's capacity exceeds the renewal.**
From a source at its need of two or above, at every step of the course the store's optimum, the
dweller's dependence on the source is lost exactly where `r < k`; derived from
`Web.course_lost_iff`. -/
theorem lost_iff (start : 2 ≤ s₀) : (web (level k r s₀)).Lost .source ↔ r < k :=
  Web.course_lost_iff (f := Formation.dweller) (fun _ => formations_distinct) store_source_distinct
    source_apart (.head []) storeOrder_rising course_reoptimizes (.head []) renewing_source
    (fun t => Nat.le_trans (Nat.le_of_eq (restGiven_source t)) (renewal_le r _)) draws_source
    (Nat.succ_pos 1) (fun _ => trivial) (fun _ => rfl) start

/-- The store holds everything drawn. -/
theorem store_eq_sum : ∀ n, store k r s₀ n = Amounts.whole.sum (draw k r s₀) 0 n
  | 0 => rfl
  | n + 1 => (congrArg (· + draw k r s₀ n) (store_eq_sum n)).trans
      (congrArg (Amounts.whole.sum (draw k r s₀) 0 n + draw k r s₀ ·) (Nat.zero_add n).symm)

/-- **Above the renewal, the store stays bounded however long the course.** -/
theorem store_bounded (over : r < k) (n : Nat) :
    (web (level k r s₀)).level n .store ≤ s₀ + r * s₀ :=
  Nat.le_trans (Nat.le_of_eq (store_eq_sum n)) (ended_drawn_le (x := source k r s₀) (m := 2)
    (g := renewed k r s₀) (d := fun _ => k) (fun _ => rfl) (renews_of (x := source k r s₀)
      (g := renewed k r s₀) (fun _ atNeed => renewed_at atNeed)
      (fun _ below => renewed_below below))
    (fun _ below => renewed_below below) (fun _ => over) (Nat.succ_pos 1) n)

/-- **Within the renewal, the store gains `k` at every step.** -/
theorem store_kept (start : 2 ≤ s₀) (within : k ≤ r) (n : Nat) :
    (web (level k r s₀)).level n .store = k * n :=
  (store_eq_sum n).trans (kept_drawn (x := source k r s₀) (m := 2) (g := renewed k r s₀)
    (d := fun _ => k) (fun _ => rfl) (fun _ atNeed => renewed_at atNeed) (fun _ => rfl) within
    start n)

/-- **Re-optimizing the store with more capacity than the renewal leaves less in the store.** From
a source at its need, the taker of capacity `r < k`, choosing the store's optimum at every step,
holds less in the store after `n` steps with `s₀ + r * s₀ < r * n` than a taker of capacity `r`
does, choosing the same way. -/
theorem keeping_holds_more (start : 2 ≤ s₀) (over : r < k) {n : Nat}
    (long : s₀ + r * s₀ < r * n) :
    (web (level k r s₀)).level n .store < (web (level r r s₀)).level n .store :=
  Nat.lt_of_le_of_lt (Nat.le_of_eq (store_eq_sum n))
    (Nat.lt_of_lt_of_le (keeping_draws_more (x := source k r s₀) (m := 2) (g := renewed k r s₀)
      (d := fun _ => k) (x' := source r r s₀) (g' := renewed r r s₀) (d' := fun _ => r)
      (fun _ => rfl) (renews_of (x := source k r s₀) (g := renewed k r s₀)
        (fun _ atNeed => renewed_at atNeed) (fun _ below => renewed_below below))
      (fun _ below => renewed_below below) (fun _ => over) (Nat.succ_pos 1) (fun _ => rfl)
      (fun _ atNeed => renewed_at atNeed) (fun _ => rfl) start long)
      (Nat.le_of_eq (store_eq_sum n).symm))

/-- **The store is bounded exactly where the capacity exceeds the renewal.** From a source at its
need, with `0 < k`, the store has a bound over every course length exactly where `r < k`. -/
theorem store_bounded_iff (start : 2 ≤ s₀) (positive : 0 < k) :
    (∃ B, ∀ n, (web (level k r s₀)).level n .store ≤ B) ↔ r < k :=
  have sums : (∃ B, ∀ n, (web (level k r s₀)).level n .store ≤ B) ↔
      ∃ B, ∀ n, Amounts.whole.sum (drawnAt (source k r s₀) (renewed k r s₀)) 0 n ≤ B :=
    ⟨fun ⟨B, bounded⟩ => ⟨B, fun n => Nat.le_trans (Nat.le_of_eq (store_eq_sum n).symm)
        (bounded n)⟩,
     fun ⟨B, bounded⟩ => ⟨B, fun n => Nat.le_trans (Nat.le_of_eq (store_eq_sum n))
        (bounded n)⟩⟩
  sums.trans (drawn_bounded_iff (x := source k r s₀) (m := 2) (g := renewed k r s₀)
    (d := fun _ => k) (fun _ => rfl) (fun _ atNeed => renewed_at atNeed)
    (fun _ below => renewed_below below) (fun _ => rfl) positive (Nat.succ_pos 1) start)

/-! ### Two takers along a course

Two takers, each of capacity one at the source, each ordering by the store, and the dweller
renewing the source by `r` while it stands at its need of two. At every step both drawing what
there is is a mutual best response. With `r < 2` the joint capacity exceeds the renewal and the
dweller's dependence is lost, though with `r = 1` either taker alone would keep it; the store stays
bounded, while the course in which one taker restrains, none of whose steps is a mutual best
response, gains a unit at every step. -/

section Pair

open TwoTakers

/-- One unit where something stands: the amount less what is left after one. -/
def takeOne (a : Nat) : Nat := a - (a - 1)

/-- At most one unit. -/
theorem takeOne_le_one : ∀ a, takeOne a ≤ 1
  | 0 => Nat.zero_le 1
  | n + 1 => Nat.le_of_eq (succ_sub_self n)

/-- What is left after one unit: the amount less one. -/
theorem sub_takeOne : ∀ a, a - takeOne a = a - 1
  | 0 => rfl
  | n + 1 => congrArg (n + 1 - ·) (succ_sub_self n)

/-- One unit and what is left make the amount. -/
theorem takeOne_split (a : Nat) : takeOne a + (a - 1) = a :=
  (congrArg (takeOne a + ·) (sub_takeOne a).symm).trans
    (Naturals.add_sub_of_le (Nat.sub_le a (a - 1)))

/-- At most one, and at most the amount, is at most one unit of it. -/
theorem le_takeOne {x : Nat} : ∀ {a : Nat}, x ≤ 1 → x ≤ a → x ≤ takeOne a
  | 0, _, within => within
  | n + 1, one, _ => Nat.le_trans one (Nat.le_of_eq (succ_sub_self n).symm)

/-- The source along the two takers' course from `s₀`: each step adds the renewal and the two take
one unit each, or what there is. -/
def jointSource (r s₀ : Nat) : Nat → Nat
  | 0 => s₀
  | t + 1 => jointSource r s₀ t + renewal r (jointSource r s₀ t) - 2

/-- What stands at the source with the renewal across the step from `t`. -/
def avail (r s₀ t : Nat) : Nat := jointSource r s₀ t + renewal r (jointSource r s₀ t)

/-- The first taker takes one unit where one stands with the renewal. -/
def first (r s₀ t : Nat) : Nat := takeOne (avail r s₀ t)

/-- The second takes one unit where one is left. -/
def second (r s₀ t : Nat) : Nat := takeOne (avail r s₀ t - 1)

/-- The store along the course: everything the two have drawn. -/
def jointStore (r s₀ : Nat) : Nat → Nat
  | 0 => 0
  | t + 1 => jointStore r s₀ t + (first r s₀ t + second r s₀ t)

/-- The levels along the two takers' course. -/
def jointLevel (r s₀ : Nat) (t : Nat) : Place → Nat
  | .source => jointSource r s₀ t
  | .store => jointStore r s₀ t

/-- Each taker takes its unit from the source and gives it to the store; the dweller gives the
source the renewal. -/
def jointCourse (r s₀ : Nat) : Flow Member Place where
  present _ := [.taker true, .taker false, .dweller]
  take t f c := match f, c with
    | .taker true, .source => first r s₀ t
    | .taker false, .source => second r s₀ t
    | .taker _, .store => 0
    | .dweller, _ => 0
  give t f c := match f, c with
    | .taker true, .store => first r s₀ t
    | .taker false, .store => second r s₀ t
    | .taker _, .source => 0
    | .dweller, .source => renewal r (jointSource r s₀ t)
    | .dweller, .store => 0

/-- The dweller requires the source at need two and is active exactly while it stands so; the
takers require nothing, are active throughout and draw on the source. -/
def jointWeb (level : Nat → Place → Nat) : Web Member Place where
  level := level
  active t f := match f with
    | .taker _ => True
    | .dweller => 2 ≤ level t .source
  requires _ f c := match f, c with
    | .dweller, .source => True
    | .dweller, .store => False
    | .taker _, _ => False
  need _ _ _ := 2
  draws _ f c := match f, c with
    | .taker _, .source => True
    | .taker _, .store => False
    | .dweller, _ => False

variable {r s₀ : Nat}

/-- What the two draw and what stands after make what stood with the renewal. -/
theorem joint_split (t : Nat) :
    jointSource r s₀ (t + 1) + (first r s₀ t + second r s₀ t) = avail r s₀ t :=
  have rest : second r s₀ t + jointSource r s₀ (t + 1) = avail r s₀ t - 1 :=
    (congrArg (takeOne (avail r s₀ t - 1) + ·)
      (Naturals.sub_sub (avail r s₀ t) 1 1)).symm.trans
      (takeOne_split (avail r s₀ t - 1))
  (Nat.add_comm _ _).trans ((Nat.add_assoc _ _ _).trans
    ((congrArg (first r s₀ t + ·) rest).trans (takeOne_split (avail r s₀ t))))

/-- The two takers' course balances. -/
theorem joint_course_balances : (jointCourse r s₀).Balances (jointWeb (jointLevel r s₀)) :=
  fun t c => match c with
  | .source => show jointSource r s₀ (t + 1) + (first r s₀ t + (second r s₀ t + 0)) =
      jointSource r s₀ t + (0 + (0 + (renewal r (jointSource r s₀ t) + 0))) by
    rw [Nat.add_zero (second r s₀ t), Nat.add_zero (renewal r (jointSource r s₀ t)),
      Nat.zero_add (0 + renewal r (jointSource r s₀ t)),
      Nat.zero_add (renewal r (jointSource r s₀ t))]
    exact joint_split t
  | .store => show jointStore r s₀ (t + 1) + (0 + (0 + 0)) =
      jointStore r s₀ t + (first r s₀ t + (second r s₀ t + 0)) from rfl

/-- Each taker acts within its capacity of one in the two takers' course. -/
theorem joint_course_within (w : Bool) (t : Nat) :
    (jointCourse r s₀).ActsWithin (alone (Member.taker w)) capOf
      ([Place.store] ++ [Place.source]) t (jointCourse r s₀) :=
  ⟨rfl, fun _ _ _ => ⟨rfl, rfl⟩,
   fun h c member => match h, c, member with
    | .taker true, .source, _ => takeOne_le_one _
    | .taker false, .source, _ => takeOne_le_one _
    | .taker true, .store, _ => Nat.le_refl 0
    | .taker false, .store, _ => Nat.le_refl 0
    | .dweller, _, member => absurd (of_decide_eq_true member) fun same => (nomatch same),
   fun _ c _ outside => match c with
    | .store => absurd (.head _) outside
    | .source => absurd (.tail _ (.head _)) outside,
   fun h member => match h, member with
    | .taker true, _ => show first r s₀ t + (0 + 0) ≤ 0 + (first r s₀ t + 0) from
        Nat.le_of_eq (Nat.zero_add _).symm
    | .taker false, _ => show second r s₀ t + (0 + 0) ≤ 0 + (second r s₀ t + 0) from
        Nat.le_of_eq (Nat.zero_add _).symm
    | .dweller, member => absurd (of_decide_eq_true member) fun same => nomatch same⟩

/-- **The first taker's draw is an optimum of the store's order, given the second's.** Every
outcome open to the first taker alone leaves the store at most where the course does: it gives the
store at most one unit, and with the second's draw at most what stands with the renewal. -/
theorem first_optimum (t : Nat) :
    Frontier ((jointCourse r s₀).Outcome (alone (Member.taker true)) (jointLevel r s₀ t) capOf
      ([Place.store] ++ [Place.source]) t) storeOrder (jointLevel r s₀ (t + 1)) :=
  ⟨⟨jointCourse r s₀, joint_course_within true t, joint_course_balances t⟩,
   fun o ⟨L', acts, balances⟩ above => by
    have atStore : o .store + L'.taken t .store = jointStore r s₀ t + L'.given t .store :=
      balances .store
    have src : o .source + L'.taken t .source = jointSource r s₀ t + L'.given t .source :=
      balances .source
    have gives : L'.given t .store = L'.give t (.taker true) .store +
        (L'.give t (.taker false) .store + (L'.give t .dweller .store + 0)) :=
      congrArg (fun ps => total ps fun f => L'.give t f .store) acts.1
    have takes : L'.taken t .source = L'.take t (.taker true) .source +
        (L'.take t (.taker false) .source + (L'.take t .dweller .source + 0)) :=
      congrArg (fun ps => total ps fun f => L'.take t f .source) acts.1
    have renews : L'.given t .source = L'.give t (.taker true) .source +
        (L'.give t (.taker false) .source + (L'.give t .dweller .source + 0)) :=
      congrArg (fun ps => total ps fun f => L'.give t f .source) acts.1
    rw [(acts.2.1 (.taker false) .store rfl).2, (acts.2.1 .dweller .store rfl).2] at gives
    rw [(acts.2.1 (.taker false) .source rfl).1, (acts.2.1 .dweller .source rfl).1] at takes
    rw [(acts.2.1 (.taker false) .source rfl).2, (acts.2.1 .dweller .source rfl).2] at renews
    have gives : L'.given t .store = L'.give t (.taker true) .store + second r s₀ t := gives
    have takes : L'.taken t .source = L'.take t (.taker true) .source + second r s₀ t := takes
    have renews : L'.given t .source =
        L'.give t (.taker true) .source + renewal r (jointSource r s₀ t) :=
      renews.trans (congrArg (L'.give t (.taker true) .source + ·)
        (Nat.zero_add (renewal r (jointSource r s₀ t) + 0)))
    have conserved : L'.give t (.taker true) .store + L'.give t (.taker true) .source ≤
        L'.take t (.taker true) .store + L'.take t (.taker true) .source :=
      acts.2.2.2.2 (.taker true) (alone_self _)
    have fromStore : L'.take t (.taker true) .store ≤ 0 :=
      acts.2.2.1 (.taker true) .store (alone_self _)
    have fromSource : L'.take t (.taker true) .source ≤ 1 :=
      acts.2.2.1 (.taker true) .source (alone_self _)
    rw [Nat.le_antisymm fromStore (Nat.zero_le _), Nat.zero_add] at conserved
    rw [takes, renews] at src
    have toSource : L'.take t (.taker true) .source + second r s₀ t ≤
        avail r s₀ t + L'.give t (.taker true) .source :=
      calc L'.take t (.taker true) .source + second r s₀ t
          ≤ o .source + (L'.take t (.taker true) .source + second r s₀ t) := Nat.le_add_left _ _
        _ = jointSource r s₀ t + (L'.give t (.taker true) .source +
            renewal r (jointSource r s₀ t)) := src
        _ = avail r s₀ t + L'.give t (.taker true) .source := by
            rw [Nat.add_comm (L'.give t (.taker true) .source), ← Nat.add_assoc]; rfl
    have withSecond : L'.give t (.taker true) .store + second r s₀ t ≤ avail r s₀ t :=
      Naturals.le_of_add_le_add_right (k := L'.give t (.taker true) .source)
        (Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm _ _ _))
          (Nat.le_trans (Nat.add_le_add_right conserved _) toSource))
    have atMostFirst : L'.give t (.taker true) .store ≤ first r s₀ t :=
      le_takeOne (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_trans conserved fromSource))
        (Nat.le_trans (Nat.le_add_right _ _) withSecond)
    have atMost : o .store ≤ jointStore r s₀ (t + 1) :=
      calc o .store ≤ o .store + L'.taken t .store := Nat.le_add_right _ _
        _ = jointStore r s₀ t + (L'.give t (.taker true) .store + second r s₀ t) := by
            rw [atStore, gives]
        _ ≤ jointStore r s₀ t + (first r s₀ t + second r s₀ t) :=
            Nat.add_le_add_left (Nat.add_le_add_right atMostFirst _) _
    exact Nat.not_le_of_gt above atMost⟩

/-- **The second taker's draw is an optimum of the store's order, given the first's.** -/
theorem second_optimum (t : Nat) :
    Frontier ((jointCourse r s₀).Outcome (alone (Member.taker false)) (jointLevel r s₀ t) capOf
      ([Place.store] ++ [Place.source]) t) storeOrder (jointLevel r s₀ (t + 1)) :=
  ⟨⟨jointCourse r s₀, joint_course_within false t, joint_course_balances t⟩,
   fun o ⟨L', acts, balances⟩ above => by
    have atStore : o .store + L'.taken t .store = jointStore r s₀ t + L'.given t .store :=
      balances .store
    have src : o .source + L'.taken t .source = jointSource r s₀ t + L'.given t .source :=
      balances .source
    have gives : L'.given t .store = L'.give t (.taker true) .store +
        (L'.give t (.taker false) .store + (L'.give t .dweller .store + 0)) :=
      congrArg (fun ps => total ps fun f => L'.give t f .store) acts.1
    have takes : L'.taken t .source = L'.take t (.taker true) .source +
        (L'.take t (.taker false) .source + (L'.take t .dweller .source + 0)) :=
      congrArg (fun ps => total ps fun f => L'.take t f .source) acts.1
    have renews : L'.given t .source = L'.give t (.taker true) .source +
        (L'.give t (.taker false) .source + (L'.give t .dweller .source + 0)) :=
      congrArg (fun ps => total ps fun f => L'.give t f .source) acts.1
    rw [(acts.2.1 (.taker true) .store rfl).2, (acts.2.1 .dweller .store rfl).2] at gives
    rw [(acts.2.1 (.taker true) .source rfl).1, (acts.2.1 .dweller .source rfl).1] at takes
    rw [(acts.2.1 (.taker true) .source rfl).2, (acts.2.1 .dweller .source rfl).2] at renews
    have gives : L'.given t .store = first r s₀ t + L'.give t (.taker false) .store := gives
    have takes : L'.taken t .source = first r s₀ t + L'.take t (.taker false) .source := takes
    have renews : L'.given t .source =
        L'.give t (.taker false) .source + renewal r (jointSource r s₀ t) :=
      renews.trans (Nat.zero_add (L'.give t (.taker false) .source +
        (renewal r (jointSource r s₀ t) + 0)))
    have conserved : L'.give t (.taker false) .store + L'.give t (.taker false) .source ≤
        L'.take t (.taker false) .store + L'.take t (.taker false) .source :=
      acts.2.2.2.2 (.taker false) (alone_self _)
    have fromStore : L'.take t (.taker false) .store ≤ 0 :=
      acts.2.2.1 (.taker false) .store (alone_self _)
    have fromSource : L'.take t (.taker false) .source ≤ 1 :=
      acts.2.2.1 (.taker false) .source (alone_self _)
    rw [Nat.le_antisymm fromStore (Nat.zero_le _), Nat.zero_add] at conserved
    rw [takes, renews] at src
    have toSource : first r s₀ t + L'.take t (.taker false) .source ≤
        avail r s₀ t + L'.give t (.taker false) .source :=
      calc first r s₀ t + L'.take t (.taker false) .source
          ≤ o .source + (first r s₀ t + L'.take t (.taker false) .source) := Nat.le_add_left _ _
        _ = jointSource r s₀ t + (L'.give t (.taker false) .source +
            renewal r (jointSource r s₀ t)) := src
        _ = avail r s₀ t + L'.give t (.taker false) .source := by
            rw [Nat.add_comm (L'.give t (.taker false) .source), ← Nat.add_assoc]; rfl
    have withFirst : first r s₀ t + L'.give t (.taker false) .store ≤ avail r s₀ t :=
      Naturals.le_of_add_le_add_right (k := L'.give t (.taker false) .source)
        (Nat.le_trans (Nat.le_of_eq (Nat.add_assoc _ _ _))
          (Nat.le_trans (Nat.add_le_add_left conserved _) toSource))
    have atMostSecond : L'.give t (.taker false) .store ≤ second r s₀ t :=
      le_takeOne (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_trans conserved fromSource))
        (Nat.le_trans (Naturals.le_sub_of_add_le withFirst)
          (Nat.le_of_eq (sub_takeOne (avail r s₀ t))))
    have atMost : o .store ≤ jointStore r s₀ (t + 1) :=
      calc o .store ≤ o .store + L'.taken t .store := Nat.le_add_right _ _
        _ = jointStore r s₀ t + (first r s₀ t + L'.give t (.taker false) .store) := by
            rw [atStore, gives]
        _ ≤ jointStore r s₀ t + (first r s₀ t + second r s₀ t) :=
            Nat.add_le_add_left (Nat.add_le_add_left atMostSecond _) _
    exact Nat.not_le_of_gt above atMost⟩

/-- **At every step both drawing is a mutual best response.** -/
theorem joint_course_best (t : Nat) :
    MutualBest (jointCourse r s₀) takers (jointLevel r s₀ t) capOf (fun _ => [Place.store])
      (fun _ => [Place.source]) (fun _ => storeOrder) t (jointLevel r s₀ (t + 1)) :=
  fun h _ opt => match h, opt with
    | .taker true, _ => ⟨joint_course_within true t, first_optimum t⟩
    | .taker false, _ => ⟨joint_course_within false t, second_optimum t⟩

/-- What the dweller gives the source in the two takers' course is the renewal. -/
theorem joint_restGiven (t : Nat) :
    (jointCourse r s₀).restGiven takers t .source = renewal r (jointSource r s₀ t) :=
  show 0 + (0 + (renewal r (jointSource r s₀ t) + 0)) = renewal r (jointSource r s₀ t) from
    (Nat.zero_add _).trans (Nat.zero_add _)

/-- **Each within the renewal, jointly above it: the dependence is lost.** From a source at its
need, with a renewal `r < 2`, the two takers' joint capacity of two exceeds it, and at mutual best
responses at every step the dweller's dependence on the source is lost; derived from
`Web.mutual_course_lost`. -/
theorem joint_course_lost (start : 2 ≤ s₀) (below : r < 2) :
    (jointWeb (jointLevel r s₀)).Lost .source :=
  Web.mutual_course_lost (f := Member.dweller) (fun _ => members_distinct) lists.1 lists.2.1
    lists.2.2.1 lists.2.2.2 joint_course_best joint_course_balances (fun _ _ _ _ => .head [])
    (fun t => Nat.le_trans (Nat.le_of_eq (joint_restGiven t)) (renewal_le r _))
    (fun _ => below) (Nat.succ_pos 1) (fun _ => trivial) (fun _ => rfl) start

/-- **Alone, a taker of capacity one keeps a source renewed by one.** -/
theorem alone_kept (start : 2 ≤ s₀) : ¬ (web (level 1 1 s₀)).Lost .source :=
  fun lost => Nat.lt_irrefl 1 ((lost_iff start).mp lost)

/-- The two takers' store holds everything drawn from the source. -/
theorem joint_store_eq_sum : ∀ n, jointStore r s₀ n =
    Amounts.whole.sum (drawnAt (jointSource r s₀) fun t => renewal r (jointSource r s₀ t)) 0 n
  | 0 => rfl
  | n + 1 => (congrArg (· + (first r s₀ n + second r s₀ n)) (joint_store_eq_sum n)).trans
      ((congrArg (Amounts.whole.sum (drawnAt (jointSource r s₀)
          fun t => renewal r (jointSource r s₀ t)) 0 n + ·)
        ((Naturals.add_sub_cancel_left (jointSource r s₀ (n + 1)) _).symm.trans
          (congrArg (· - jointSource r s₀ (n + 1)) (joint_split n)))).trans
        (congrArg (Amounts.whole.sum (drawnAt (jointSource r s₀)
          fun t => renewal r (jointSource r s₀ t)) 0 n + drawnAt (jointSource r s₀)
            (fun t => renewal r (jointSource r s₀ t)) ·) (Nat.zero_add n).symm))

/-- **Above the renewal jointly, the two takers' store stays bounded however long the course.** -/
theorem joint_store_bounded (below : r < 2) (n : Nat) : jointStore r s₀ n ≤ s₀ + r * s₀ :=
  Nat.le_trans (Nat.le_of_eq (joint_store_eq_sum n)) (ended_drawn_le (x := jointSource r s₀)
    (m := 2) (g := fun t => renewal r (jointSource r s₀ t)) (d := fun _ => 2) (fun _ => rfl)
    (fun _ => renewal_le r _) (fun _ low => if_neg (Nat.not_le_of_gt low)) (fun _ => below)
    (Nat.succ_pos 1) n)

/-- One taker draws a unit at every step and the other nothing; the dweller renews by one. -/
def restrainedCourse (s₀ : Nat) : Flow Member Place where
  present _ := [.taker true, .taker false, .dweller]
  take _ f c := match f, c with
    | .taker true, .source => 1
    | .taker true, .store => 0
    | .taker false, _ => 0
    | .dweller, _ => 0
  give _ f c := match f, c with
    | .taker true, .store => 1
    | .taker true, .source => 0
    | .taker false, _ => 0
    | .dweller, .source => renewal 1 s₀
    | .dweller, .store => 0

/-- The levels of the restrained course: the source where it started, the store at the step
count. -/
def restrainedLevel (s₀ : Nat) (t : Nat) : Place → Nat
  | .source => s₀
  | .store => t

/-- The restrained course balances from a source at its need. -/
theorem restrained_course_balances (start : 2 ≤ s₀) :
    (restrainedCourse s₀).Balances (jointWeb (restrainedLevel s₀)) := fun t c =>
  match c with
  | .source => show s₀ + (1 + (0 + (0 + 0))) = s₀ + (0 + (0 + (renewal 1 s₀ + 0))) from
      (congrArg (fun y => s₀ + (0 + (0 + (y + 0)))) (if_pos start : renewal 1 s₀ = 1)).symm
  | .store => show t + 1 + (0 + (0 + (0 + 0))) = t + (1 + (0 + (0 + 0))) from rfl

/-- **No step of the restrained course is a mutual best response.** Something stands at the
source after each step, and the restraining taker does not take its whole capacity there. -/
theorem restrained_course_not_best (start : 2 ≤ s₀) (t : Nat) :
    ¬ MutualBest (restrainedCourse s₀) takers (restrainedLevel s₀ t) capOf
      (fun _ => [Place.store]) (fun _ => [Place.source]) (fun _ => storeOrder) t
      (restrainedLevel s₀ (t + 1)) := fun best =>
  absurd (MutualBest.full (L := restrainedCourse s₀) (ds := fun _ => [Place.store])
    (rest := fun _ => [Place.source]) members_distinct lists.1 lists.2.1 lists.2.2.1 lists.2.2.2
    best (restrained_course_balances start t) (h := .taker false) (.tail _ (.head _)) rfl
    (.head []) (Nat.lt_of_lt_of_le (Nat.succ_pos 1) start)).1 fun same => nomatch same

/-- **Restraint, which no mutual best response allows, holds more.** From a source at its need
renewed by one, after `n` steps with `s₀ + s₀ < n` the two takers' store at mutual best
responses at every step holds less than the restrained course's. -/
theorem restraint_holds_more {n : Nat} (long : s₀ + s₀ < n) :
    (jointWeb (jointLevel 1 s₀)).level n .store < (jointWeb (restrainedLevel s₀)).level n .store :=
  Nat.lt_of_le_of_lt (Nat.le_trans (joint_store_bounded (Nat.lt_succ_self 1) n)
    (Nat.le_of_eq (congrArg (s₀ + ·) (Nat.one_mul s₀)))) long

end Pair

end Renewing

end Optimum
