import Becoming.Typicality
import Becoming.GroupEnding

/-!
# Drift: offspring sampled rather than listed

`Becoming.SelectionTerm` reads a generation's change of mean off its listed offspring: each parent
with its listed number of offspring. Where the next generation is not the listed offspring but a
sample of them, the sample can differ from the list. This module states, by counting the samples,
what sampling adds: nothing on average, a spread that is exact, and a weight of samples undoing
selection that falls as the sample grows.

A next generation of two kinds is sampled `n` times from the listed offspring, each draw one of
them: `p` listed offspring of the first kind (holding an amount, say) and `q` of the second. A
sampling is a course of `Becoming.Typicality` (`true` for the first kind), weighing `p` for each
draw of the first kind and `q` for each of the second, so each sampling counts the ways of drawing
it; the `(p + q) ^ n` ways of drawing `n` times are all counted (`Typicality.total_weight`).

* **Sampling is unbiased.** Over the samplings, each by its weight, the draws of the first kind add
  up to `n · p / (p + q)` times the whole weight: `(p + q)` times their weighted count is `n · p`
  times `(p + q) ^ n` (`expected_ones`), and likewise for the second kind (`expected_zeros`). On
  average the sampled share is the listed share; sampling moves the mean of a generation by
  nothing on average (`Generations.expected_sampled`: sampled from a listed generation, the first
  kind's count averages the listed share).
* **The spread is exact.** The squared deviations of the sampled count from its listed share add
  up to `n · p · q · (p + q) ^ n` (`Typicality.spread`): the variance of the sampled share is
  `p · q / ((p + q)² · n)`, falling as `1/n`.
* **Drift can undo selection, with a weight falling as `1/n`.** Where a listed step raises the
  share of the first kind from `h / N` (`h` of `N` parents) to `p / (p + q)`, the gap
  `g = N · p − (p + q) · h` is positive. The samplings of `n` whose share of the first kind is at
  most `h / N` (`fallsBack`: they undo the step's selection) weigh, times `n² · g²`, at most
  `N² · n · p · q · (p + q) ^ n` (`falls_back`): out of the whole weight, at most
  `N² · p · q / (n · g²)`, which with `p / (p + q) − h / N = g / (N · (p + q))` is
  `p · q / ((p + q)² · (p/(p+q) − h/N)² · n)`. Over listed generations, a step that raises the
  mean of an amount held or not (`Generations.Raises`) has the same bound for samplings of the
  next generation falling back to the step's start (`Generations.raised_falls_back`). The weight is
  positive where any sampling falls back: with one draw from three of one kind and two of the
  other, raised from a half, the draw of the second kind weighs two of five (`OneDraw.falls_back`).
* **Never ruled out.** The samplings with no draw of the first kind (`lost`: the favoured kind
  lost in one generation) weigh exactly `q ^ n` (`lost_weight`), and each falls back, so the
  samplings undoing the step weigh at least `q ^ n` at every sample size (`falls_back_ge`): drift
  makes undoing selection rare as the sample grows, never impossible.
* **On the base.** Where ending among groups raises the mean of an amount held or not (the groups
  with less of it not active, `GroupEnding.Flow.raises_of_inactive`), a sampled next generation
  undoes the rise with both bounds (`Flow.ended_falls_back`).

Nothing here says which sampling happens: counting weighs the samplings, and as
`Becoming.Typicality` states, no record shows that the course that happens is among the many.
Drift is read as a count of the ways a sample can differ from its list, not as a chance supposed
of the unfolding. Modelling choices: two kinds; draws with replacement from the listed offspring,
each counted once (the Wright–Fisher sampling); natural-number counts; discrete generations. No
ethical predicate, ranking or axiom occurs; every declaration has an empty axiom report.
-/

namespace Becoming

namespace Drift

open Typicality

/-! ## Sampling is unbiased -/

theorem step_ones (p q W o : Nat) :
    p * W * (o + 1) + q * W * o = (p + q) * (W * o) + p * W :=
  (congrArg (· + q * W * o) (Nat.mul_succ (p * W) o)).trans
    ((Nat.add_right_comm _ _ _).trans (congrArg (· + p * W)
      ((Naturals.add_congr (mul_assoc_nat p W o) (mul_assoc_nat q W o)).trans
        (add_mul_split p q (W * o)).symm)))

theorem step_zeros (p q W o : Nat) :
    p * W * o + q * W * (o + 1) = (p + q) * (W * o) + q * W :=
  (congrArg (p * W * o + ·) (Nat.mul_succ (q * W) o)).trans
    ((Nat.add_assoc _ _ _).symm.trans (congrArg (· + q * W)
      ((Naturals.add_congr (mul_assoc_nat p W o) (mul_assoc_nat q W o)).trans
        (add_mul_split p q (W * o)).symm)))

/-- One more draw: the weighted count of the first kind is `p + q` times the last with `p` times
the last whole weight. -/
theorem weighted_ones_step (p q n : Nat) :
    total (Typicality.courses (n + 1)) (fun w => weight p q w * ones w) =
      (p + q) * total (Typicality.courses n) (fun w => weight p q w * ones w) + p * (p + q) ^ n := by
  show total (extend (Typicality.courses n)) (fun w => weight p q w * ones w) = _
  rw [total_extend]
  show total (Typicality.courses n) (fun w => p * weight p q w * (ones w + 1) + q * weight p q w * ones w) = _
  rw [total_congr (fun w => step_ones p q (weight p q w) (ones w)), total_add, total_mul, total_mul,
    total_weight]

theorem weighted_zeros_step (p q n : Nat) :
    total (Typicality.courses (n + 1)) (fun w => weight p q w * zeros w) =
      (p + q) * total (Typicality.courses n) (fun w => weight p q w * zeros w) + q * (p + q) ^ n := by
  show total (extend (Typicality.courses n)) (fun w => weight p q w * zeros w) = _
  rw [total_extend]
  show total (Typicality.courses n) (fun w => p * weight p q w * zeros w + q * weight p q w * (zeros w + 1)) = _
  rw [total_congr (fun w => step_zeros p q (weight p q w) (zeros w)), total_add, total_mul, total_mul,
    total_weight]

theorem step_expected (a b X n : Nat) :
    a * (n * b * X) + a * (b * X) = (n + 1) * b * (X * a) :=
  (Nat.left_distrib a _ _).symm.trans ((congrArg (a * ·) ((add_mul_split (n * b) b X).symm.trans
    (congrArg (· * X) (Nat.succ_mul n b).symm))).trans ((Nat.mul_comm a _).trans
      (mul_assoc_nat _ X a)))

/-- **Sampling is unbiased.** `p + q` times the weighted count of draws of the first kind is `n · p`
times the whole weight: on average the sampled share is `p / (p + q)`. -/
theorem expected_ones (p q : Nat) : ∀ n,
    (p + q) * total (Typicality.courses n) (fun w => weight p q w * ones w) = n * p * (p + q) ^ n
  | 0 => by
    show (p + q) * 0 = 0 * p * (p + q) ^ 0
    rw [Nat.mul_zero, Nat.zero_mul, Nat.zero_mul]
  | n + 1 => by
    rw [weighted_ones_step, Nat.left_distrib, expected_ones p q n]
    exact step_expected (p + q) p ((p + q) ^ n) n

/-- And for the second kind: `n · q` times the whole weight. -/
theorem expected_zeros (p q : Nat) : ∀ n,
    (p + q) * total (Typicality.courses n) (fun w => weight p q w * zeros w) = n * q * (p + q) ^ n
  | 0 => by
    show (p + q) * 0 = 0 * q * (p + q) ^ 0
    rw [Nat.mul_zero, Nat.zero_mul, Nat.zero_mul]
  | n + 1 => by
    rw [weighted_zeros_step, Nat.left_distrib, expected_zeros p q n]
    exact step_expected (p + q) q ((p + q) ^ n) n

/-! ## Drift can undo selection -/

/-- The weight of a sampling whose share of the first kind is at most `h / N`, and nothing
otherwise. -/
def fallsBack (p q n h N : Nat) (w : List Bool) : Nat :=
  if ones w * N ≤ h * n then weight p q w else 0

/-- A sampling falling back to `h / N` is behind its listed share by the gap: with `a` draws of the
first kind and `b` of the second, `N · q · a` with `n · g` is at most `N · p · b`. -/
theorem gap_le {N p q h g n a b : Nat} (len : a + b = n) (gap : (p + q) * h + g = N * p)
    (back : a * N ≤ h * n) : N * (q * a) + n * g ≤ N * (p * b) :=
  have whole : N * (p * b) + N * (p * a) = n * ((p + q) * h) + n * g :=
    (Nat.left_distrib N _ _).symm.trans ((congrArg (N * ·) ((Nat.left_distrib p b a).symm.trans
      (congrArg (p * ·) ((Nat.add_comm b a).trans len)))).trans ((mul_assoc_nat N p n).symm.trans
        ((Nat.mul_comm _ n).trans ((congrArg (n * ·) gap.symm).trans (Nat.left_distrib n _ _)))))
  have taken : N * (q * a) + N * (p * a) ≤ n * ((p + q) * h) :=
    Nat.le_trans (Nat.le_of_eq ((Nat.left_distrib N _ _).symm.trans
      ((congrArg (N * ·) ((Nat.add_comm _ _).trans (add_mul_split p q a).symm)).trans
        ((mul_turn N (p + q) a).trans ((congrArg ((p + q) * ·) (Nat.mul_comm N a)))))))
      (Nat.le_trans (Nat.mul_le_mul_left (p + q) back) (Nat.le_of_eq
        ((congrArg ((p + q) * ·) (Nat.mul_comm h n)).trans (mul_turn (p + q) n h))))
  Naturals.le_of_add_le_add_right (Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm _ _ _))
    (Nat.le_trans (Nat.add_le_add_right taken _) (Nat.le_of_eq whole.symm)))

theorem square_mul (N e : Nat) : N * e * (N * e) = N * N * (e * e) :=
  (mul_assoc_nat N e (N * e)).trans ((congrArg (N * ·) (mul_turn e N e)).trans
    (mul_assoc_nat N N (e * e)).symm)

/-- Behind by the gap, the squared deviation exceeds the cross term by the gap squared:
`N² · 2xy` with `n² · g²` is at most `N² · (x² + y²)`. -/
theorem far_back {N x y n g : Nat} (back : N * x + n * g ≤ N * y) :
    N * N * (2 * (x * y)) + n * n * (g * g) ≤ N * N * (x * x + y * y) :=
  match Nat.le_total x y with
  | .inl le => match le_dest le with
    | ⟨e, at_y⟩ => by
      rw [at_y] at back ⊢
      have same : x * x + (x + e) * (x + e) = 2 * (x * (x + e)) + e * e := by
        rw [add_mul_split x e (x + e), Nat.mul_add e x e, Nat.mul_comm e x, Nat.add_left_comm,
          ← Nat.add_assoc (x * x) (x * e) (e * e), ← Nat.mul_add x x e, ← Nat.add_assoc, Nat.two_mul]
      have ge : n * g ≤ N * e :=
        Naturals.le_of_add_le_add_left (Nat.le_trans back (Nat.le_of_eq (Nat.left_distrib N x e)))
      rw [same, Nat.left_distrib (N * N), ← square_mul N e, ← square_mul n g]
      exact Nat.add_le_add_left (Nat.mul_le_mul ge ge) _
  | .inr le =>
    have zero : n * g = 0 := Nat.eq_zero_of_le_zero (Naturals.le_of_add_le_add_left
      (Nat.le_trans back (Nat.le_trans (Nat.mul_le_mul_left N le)
        (Nat.le_of_eq (Nat.add_zero _).symm))))
    by
      rw [← square_mul n g, zero, Nat.zero_mul, Nat.add_zero]
      exact Nat.mul_le_mul_left _ (two_mul_le x y)

/-- Each sampling: its weight if it falls back, times `n² · g²`, with its weight times `N²` times
the cross term, is at most its weight times `N²` times its squared deviation. -/
theorem falls_back_le {p q n h N g : Nat} (gap : (p + q) * h + g = N * p) {w : List Bool}
    (len : w.length = n) :
    fallsBack p q n h N w * (n * n * (g * g)) + weight p q w * (N * N * cross p q w) ≤
      weight p q w * (N * N * square p q w) :=
  if back : ones w * N ≤ h * n then by
    show (if ones w * N ≤ h * n then weight p q w else 0) * _ + _ ≤ _
    rw [if_pos back, Nat.mul_comm (weight p q w) (n * n * (g * g)), ← Nat.mul_comm (weight p q w),
      ← Nat.left_distrib, Nat.add_comm (n * n * (g * g))]
    exact Nat.mul_le_mul_left _ (far_back (gap_le ((ones_add_zeros w).trans len) gap back))
  else by
    show (if ones w * N ≤ h * n then weight p q w else 0) * _ + _ ≤ _
    rw [if_neg back, Nat.zero_mul, Nat.zero_add]
    exact Nat.mul_le_mul_left _ (Nat.mul_le_mul_left _ (two_mul_le _ _))

/-- **Drift can undo selection, with a weight falling as `1/n`.** Where `(p + q) · h + g = N · p`
(a listed step raising the share of the first kind from `h / N` to `p / (p + q)` by the gap `g`),
the samplings of `n` whose share of the first kind is at most `h / N` weigh, times `n² · g²`, at
most `N² · n · p · q · (p + q) ^ n`, out of `(p + q) ^ n` for all of them. -/
theorem falls_back (p q n h N g : Nat) (gap : (p + q) * h + g = N * p) :
    total (Typicality.courses n) (fallsBack p q n h N) * (n * n * (g * g)) ≤
      N * N * (n * (p * q * (p + q) ^ n)) :=
  have bound := total_le_mem (Typicality.courses n) fun w mw =>
    falls_back_le (p := p) (q := q) (n := n) (h := h) (N := N) (g := g) gap (mem_courses_iff.mp mw)
  have spreadN : total (Typicality.courses n) (fun w => weight p q w * (N * N * square p q w)) =
      total (Typicality.courses n) (fun w => weight p q w * (N * N * cross p q w)) +
        N * N * (n * (p * q * (p + q) ^ n)) := by
    rw [total_congr (fun w => mul_turn (weight p q w) (N * N) (square p q w)),
      total_congr (fun w => mul_turn (weight p q w) (N * N) (cross p q w)), total_mul,
      total_mul, spread, Nat.left_distrib]
  Naturals.le_of_add_le_add_right (by
    rw [total_add, total_mul_right, spreadN] at bound
    rw [Nat.add_comm (N * N * _)]
    exact bound)

/-- The weight of a sampling with no draw of the first kind, and nothing otherwise: the samplings
that lose the first kind. -/
def lost (p q : Nat) (w : List Bool) : Nat :=
  if ones w = 0 then weight p q w else 0

theorem lost_true (p q : Nat) (w : List Bool) : lost p q (true :: w) = 0 :=
  if_neg (fun same => Nat.noConfusion same)

theorem lost_false (p q : Nat) (w : List Bool) : lost p q (false :: w) = q * lost p q w :=
  if zero : ones w = 0 then by
    show (if ones w = 0 then q * weight p q w else 0) = q * (if ones w = 0 then weight p q w else 0)
    rw [if_pos zero, if_pos zero]
  else by
    show (if ones w = 0 then q * weight p q w else 0) = q * (if ones w = 0 then weight p q w else 0)
    rw [if_neg zero, if_neg zero, Nat.mul_zero]

/-- **Drift can lose the favoured kind at every size.** The samplings of `n` with no draw of the
first kind weigh exactly `q ^ n`, out of `(p + q) ^ n`. -/
theorem lost_weight (p q : Nat) : ∀ n, total (Typicality.courses n) (lost p q) = q ^ n
  | 0 => rfl
  | n + 1 => by
    show total (extend (Typicality.courses n)) (lost p q) = q ^ n * q
    rw [total_extend, total_congr (fun w => (congrArg (· + lost p q (false :: w)) (lost_true p q w)).trans
      ((Nat.zero_add _).trans (lost_false p q w))), total_mul, lost_weight p q n, Nat.mul_comm]

theorem lost_le (p q n h N : Nat) (w : List Bool) : lost p q w ≤ fallsBack p q n h N w :=
  if zero : ones w = 0 then by
    show (if ones w = 0 then weight p q w else 0) ≤
      (if ones w * N ≤ h * n then weight p q w else 0)
    rw [if_pos zero, zero, Nat.zero_mul, if_pos (Nat.zero_le _)]
    exact Nat.le_refl _
  else by
    show (if ones w = 0 then weight p q w else 0) ≤ _
    rw [if_neg zero]
    exact Nat.zero_le _

/-- So the samplings falling back weigh at least `q ^ n`: at no sample size is undoing the step
ruled out, while the bound of `falls_back` makes it rare as `n` grows. -/
theorem falls_back_ge (p q n h N : Nat) : q ^ n ≤ total (Typicality.courses n) (fallsBack p q n h N) :=
  (lost_weight p q n).symm ▸ Typicality.total_le (lost_le p q n h N) _

/-! ## Over listed generations -/

namespace Generations

variable {α : Type}

/-- Sampled from a listed generation of `p` holding an amount and `q` not: `p + q` (the listed
size) times the weighted count of samplings' holders is `n · p` times the whole weight. -/
theorem expected_sampled (G : SelectionTerm.Generations α) {t q : Nat}
    (split : G.size (t + 1) = G.sum (t + 1) + q) (n : Nat) :
    G.size (t + 1) * total (Typicality.courses n) (fun w => weight (G.sum (t + 1)) q w * ones w) =
      n * G.sum (t + 1) * G.size (t + 1) ^ n := by
  rw [split]
  exact expected_ones _ q n

/-- **Over listed generations.** Where a step raises the mean of an amount held or not (`p` of the
next generation's listed members holding it, `q` not), samplings of `n` from the next generation
falling back to the step's start (`h` of `N` holding it) weigh, times `n² · g²`, at most
`N² · n · p · q · (p + q) ^ n`, for the positive gap `g`. -/
theorem raised_falls_back (G : SelectionTerm.Generations α) {t q : Nat}
    (split : G.size (t + 1) = G.sum (t + 1) + q) (raises : G.Raises t) (n : Nat) :
    ∃ g, 0 < g ∧
      total (Typicality.courses n) (fallsBack (G.sum (t + 1)) q n (G.sum t) (G.size t)) * (n * n * (g * g)) ≤
        G.size t * G.size t * (n * (G.sum (t + 1) * q * (G.sum (t + 1) + q) ^ n)) :=
  match le_dest ((G.rises_step_iff t).mpr raises) with
  | ⟨d, at_gap⟩ =>
    ⟨d + 1, Nat.succ_pos d, falls_back _ q n _ _ (d + 1) (by
      rw [← split, Nat.add_succ, ← Nat.succ_add]
      exact at_gap.symm)⟩

end Generations

/-! ## On the base -/

namespace Flow

open SelectionTerm SelectionLevels

variable {X : Type} {L : Becoming.Flow X X} {W : Web X X}

/-- **Drift against ending among groups.** Over generations of descent with exact transmission
and groups of equal size uniform in an amount held or not, where the groups with less of it are
not active and a group with more of it leaves offspring, ending raises the mean
(`GroupEnding.Flow.raises_of_inactive`); yet the samplings of `n` from the next generation that
fall back to the step's start weigh, times `n² · g²` for a positive gap `g`, at most
`N² · n · p · q · (p + q) ^ n`, and at least `q ^ n`: what ending among groups raised, a sampled
generation undoes rarely as the sample grows, and at no size never. -/
theorem ended_falls_back (acting : L.Acting W) {G : SelectionTerm.Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {t m q : Nat} (gs : List (List X))
    (listed : whole gs = G.family t) (equal : ∀ g, g ∈ gs → g.length = m)
    (uniform : ∀ g, g ∈ gs → ∃ c, ∀ p, p ∈ g → G.amount t p = c)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (inactive : ∀ g h, g ∈ gs → h ∈ gs → total h (G.amount t) < total g (G.amount t) →
      ∀ p, p ∈ h → ¬ W.active t p)
    {g h : List X} (mg : g ∈ gs) (mh : h ∈ gs) (less : total h (G.amount t) < total g (G.amount t))
    (leaves : 0 < total g (G.offspringNumber t))
    (split : G.size (t + 1) = G.sum (t + 1) + q) (n : Nat) :
    (∃ gap, 0 < gap ∧
      total (Typicality.courses n) (fallsBack (G.sum (t + 1)) q n (G.sum t) (G.size t)) *
          (n * n * (gap * gap)) ≤
        G.size t * G.size t * (n * (G.sum (t + 1) * q * (G.sum (t + 1) + q) ^ n))) ∧
      q ^ n ≤ total (Typicality.courses n) (fallsBack (G.sum (t + 1)) q n (G.sum t) (G.size t)) :=
  ⟨Generations.raised_falls_back G split
      (GroupEnding.Flow.raises_of_inactive acting descended gs listed equal uniform exact inactive
        mg mh less leaves) n,
    falls_back_ge _ q n _ _⟩

end Flow

/-! ## Witness -/

namespace OneDraw

/-- One draw from three listed offspring of the first kind and two of the second, after a step
raising the first kind's share from one of two: the draw of the second kind falls back, weighing
two of the five ways, and the gap is one (`5 · 1 + 1 = 2 · 3`). -/
theorem falls_back :
    total (Typicality.courses 1) (fallsBack 3 2 1 1 2) = 2 ∧ total (Typicality.courses 1) (weight 3 2) = 5 ∧
      (3 + 2) * 1 + 1 = 2 * 3 :=
  ⟨rfl, rfl, rfl⟩

end OneDraw

end Drift

end Becoming
