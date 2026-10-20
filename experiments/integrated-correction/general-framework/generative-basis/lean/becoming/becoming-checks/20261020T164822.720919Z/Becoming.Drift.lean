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
* **Over many sampled generations: drift ends variation and fixes each kind with its starting
  share.** A population of `N`, `h` of the first kind, sampled generation after generation, each
  next generation `N` draws from the last weighted by its counts (`sampled`: the histories of `k`
  generations, each weighed by its ways of drawing, `(N ^ N) ^ k` together, `sampled_one`). Summed
  over the histories the final count is `h · (N ^ N) ^ k` (`sampled_count`): no direction without
  selection. The ends are absorbing (`sampled_none`, `sampled_all`). From a varied population the
  samplings fixing and losing the first kind weigh at least one each, so the histories still
  varied after `k` generations weigh at most `r ^ k` with `r + 2 = N ^ N` (`varied_vanishes`).
  Hence the histories fixing the first kind weigh, times `N`, at most `h · (N ^ N) ^ k` and with
  `N · r ^ k` at least that (`fixation`): their share tends to `h / N`, the neutral fixation
  probability. Witness: two members, one of each kind, one generation (`TwoMembers.one_generation`).

Nothing here says which sampling happens: counting weighs the samplings, and as
`Becoming.Typicality` states, no record shows that the course that happens is among the many.
Drift is read as a count of the ways a sample can differ from its list, not as a chance supposed
of the unfolding. Modelling choices: two kinds; draws with replacement from the listed offspring,
each counted once (the Wright–Fisher sampling); over many generations a constant population size
and no selection or mutation in the draw; natural-number counts; discrete generations. No
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

/-! ## Over many sampled generations -/

/-- The weight of a sampling with every draw of the first kind, and nothing otherwise. -/
def whole (p q : Nat) (w : List Bool) : Nat :=
  if zeros w = 0 then weight p q w else 0

theorem whole_true (p q : Nat) (w : List Bool) : whole p q (true :: w) = p * whole p q w :=
  if zero : zeros w = 0 then by
    show (if zeros w = 0 then p * weight p q w else 0) = p * (if zeros w = 0 then weight p q w else 0)
    rw [if_pos zero, if_pos zero]
  else by
    show (if zeros w = 0 then p * weight p q w else 0) = p * (if zeros w = 0 then weight p q w else 0)
    rw [if_neg zero, if_neg zero, Nat.mul_zero]

theorem whole_false (p q : Nat) (w : List Bool) : whole p q (false :: w) = 0 :=
  if_neg (fun same => Nat.noConfusion same)

/-- The samplings of `n` with every draw of the first kind weigh exactly `p ^ n`. -/
theorem whole_weight (p q : Nat) : ∀ n, total (Typicality.courses n) (whole p q) = p ^ n
  | 0 => rfl
  | n + 1 => by
    show total (extend (Typicality.courses n)) (whole p q) = p ^ n * p
    rw [total_extend, total_congr (fun w => (congrArg (whole p q (true :: w) + ·) (whole_false p q w)).trans
      ((Nat.add_zero _).trans (whole_true p q w))), total_mul, whole_weight p q n, Nat.mul_comm]

theorem ones_le (w : List Bool) : ones w ≤ w.length :=
  (ones_add_zeros w) ▸ Nat.le_add_right _ _

/-- From no member of the first kind, every sampling with weight has none: summed over the
samplings, a reading of the count is `q ^ n` times its value at nothing. -/
theorem from_none (q : Nat) (g : Nat → Nat) : ∀ n,
    total (Typicality.courses n) (fun w => weight 0 q w * g (ones w)) = q ^ n * g 0
  | 0 => rfl
  | n + 1 => by
    show total (extend (Typicality.courses n)) (fun w => weight 0 q w * g (ones w)) = _
    rw [total_extend]
    show total (Typicality.courses n) (fun w => 0 * weight 0 q w * g (ones w + 1) + q * weight 0 q w * g (ones w)) = _
    rw [total_congr (fun w => (congrArg (· + q * weight 0 q w * g (ones w)) (by rw [Nat.zero_mul, Nat.zero_mul])).trans
      ((Nat.zero_add _).trans (mul_assoc_nat q _ _))), total_mul, from_none q g n, Nat.pow_succ, Nat.mul_comm (q ^ n) q,
      mul_assoc_nat]

/-- From every member of the first kind, likewise: `p ^ n` times the reading's value at `n`. -/
theorem from_all (p : Nat) : ∀ n (g : Nat → Nat),
    total (Typicality.courses n) (fun w => weight p 0 w * g (ones w)) = p ^ n * g n
  | 0, _ => rfl
  | n + 1, g => by
    show total (extend (Typicality.courses n)) (fun w => weight p 0 w * g (ones w)) = _
    rw [total_extend]
    show total (Typicality.courses n) (fun w => p * weight p 0 w * g (ones w + 1) + 0 * weight p 0 w * g (ones w)) = _
    rw [total_congr (fun w => (congrArg (p * weight p 0 w * g (ones w + 1) + ·) (by rw [Nat.zero_mul, Nat.zero_mul])).trans
      ((Nat.add_zero _).trans (mul_assoc_nat p _ _))), total_mul, from_all p n (fun c => g (c + 1)), Nat.pow_succ,
      Nat.mul_comm (p ^ n) p, mul_assoc_nat]

/-- **Sampled generations.** A population of `N`, `h` of them of the first kind, sampled generation
after generation: each next generation is `N` draws from the last, weighted by its counts (`h` of
the first kind, `N - h` of the second). Summed over the histories of `k` generations, each weighed
by its ways of drawing, `sampled N f k h` is the total of a reading `f` of the final count. -/
def sampled (N : Nat) (f : Nat → Nat) : Nat → Nat → Nat
  | 0, h => f h
  | k + 1, h => total (Typicality.courses N) (fun w => weight h (N - h) w * sampled N f k (ones w))

theorem sampled_succ (N : Nat) (f : Nat → Nat) (k h : Nat) :
    sampled N f (k + 1) h =
      total (Typicality.courses N) (fun w => weight h (N - h) w * sampled N f k (ones w)) := rfl

/-- Readings that agree on the counts a population can have give the same total; one at most
another gives at most its total. -/
theorem sampled_le {N : Nat} {f g : Nat → Nat} (le : ∀ c, c ≤ N → f c ≤ g c) :
    ∀ k h, h ≤ N → sampled N f k h ≤ sampled N g k h
  | 0, h, within => le h within
  | k + 1, _, _ => total_le_mem _ fun w mw =>
    Nat.mul_le_mul_left _ (sampled_le le k _
      (Nat.le_trans (ones_le w) (Nat.le_of_eq (mem_courses_iff.mp mw))))

theorem sampled_add (N : Nat) (f g : Nat → Nat) :
    ∀ k h, sampled N (fun c => f c + g c) k h = sampled N f k h + sampled N g k h
  | 0, _ => rfl
  | k + 1, h => by
    rw [sampled_succ, sampled_succ, sampled_succ,
      total_congr (fun w => (congrArg (weight h (N - h) w * ·) (sampled_add N f g k (ones w))).trans
        (Nat.left_distrib _ _ _)), total_add]

theorem sampled_mul (N c : Nat) (f : Nat → Nat) :
    ∀ k h, sampled N (fun x => c * f x) k h = c * sampled N f k h
  | 0, _ => rfl
  | k + 1, h => by
    rw [sampled_succ, sampled_succ,
      total_congr (fun w => (congrArg (weight h (N - h) w * ·) (sampled_mul N c f k (ones w))).trans
        (mul_turn _ c _)), total_mul]

/-- **The histories weigh `(N ^ N) ^ k` together.** -/
theorem sampled_one (N : Nat) : ∀ k h, h ≤ N → sampled N (fun _ => 1) k h = (N ^ N) ^ k
  | 0, _, _ => rfl
  | k + 1, h, within => by
    rw [sampled_succ, total_congr_mem _ fun w mw =>
      (congrArg (weight h (N - h) w * ·) (sampled_one N k (ones w)
        (Nat.le_trans (ones_le w) (Nat.le_of_eq (mem_courses_iff.mp mw))))),
      total_mul_right, total_weight, add_sub_of_le within, Nat.pow_succ]
    exact Nat.mul_comm _ _

/-- **The ends are absorbing.** From no member of the first kind, every history keeps none. -/
theorem sampled_none (N : Nat) (f : Nat → Nat) : ∀ k, sampled N f k 0 = (N ^ N) ^ k * f 0
  | 0 => (Nat.one_mul _).symm
  | k + 1 => by
    rw [sampled_succ]
    show total (Typicality.courses N) (fun w => weight 0 N w * sampled N f k (ones w)) = _
    rw [from_none N (fun c => sampled N f k c) N, sampled_none N f k, Nat.pow_succ, Nat.mul_comm (_ ^ k) (N ^ N),
      mul_assoc_nat]

theorem sub_self_zero : ∀ N : Nat, N - N = 0
  | 0 => rfl
  | N + 1 => (Nat.succ_sub_succ N N).trans (sub_self_zero N)

/-- And from every member of the first kind, every history keeps all. -/
theorem sampled_all (N : Nat) (f : Nat → Nat) : ∀ k, sampled N f k N = (N ^ N) ^ k * f N
  | 0 => (Nat.one_mul _).symm
  | k + 1 => by
    rw [sampled_succ, sub_self_zero, from_all N N (fun c => sampled N f k c), sampled_all N f k, Nat.pow_succ,
      Nat.mul_comm (_ ^ k) (N ^ N), mul_assoc_nat]

theorem weighted_ones (h N : Nat) (within : h ≤ N) :
    total (Typicality.courses N) (fun w => weight h (N - h) w * ones w) = h * N ^ N :=
  match N, within with
  | 0, within => by
    rw [Nat.eq_zero_of_le_zero within]
    rfl
  | M + 1, within =>
    Nat.eq_of_mul_eq_mul_left (Nat.succ_pos M) (by
      have e := expected_ones h (M + 1 - h) (M + 1)
      rw [add_sub_of_le within] at e
      rw [e, mul_assoc_nat])

/-- **No direction without selection.** Summed over the histories of `k` sampled generations, the
final count of the first kind is its start `h` times the whole weight `(N ^ N) ^ k`: on average
drift keeps the count. -/
theorem sampled_count (N : Nat) : ∀ k h, h ≤ N → sampled N (fun c => c) k h = h * (N ^ N) ^ k
  | 0, h, _ => (Nat.mul_one h).symm
  | k + 1, h, within => by
    rw [sampled_succ, total_congr_mem _ fun w mw =>
      (congrArg (weight h (N - h) w * ·) (sampled_count N k (ones w)
        (Nat.le_trans (ones_le w) (Nat.le_of_eq (mem_courses_iff.mp mw))))).trans
        (mul_assoc_nat _ _ _).symm, total_mul_right, weighted_ones h N within, Nat.pow_succ,
      mul_assoc_nat, Nat.mul_comm (N ^ N)]

/-- A count of the first kind short of the whole and of nothing: the population still varied. -/
def varied (N c : Nat) : Nat :=
  if 0 < c then (if c < N then 1 else 0) else 0

/-- A count of the whole population: the first kind fixed. -/
def fixed (N c : Nat) : Nat :=
  if c = N then 1 else 0

theorem varied_zero (N : Nat) : varied N 0 = 0 := if_neg (Nat.lt_irrefl 0)

theorem varied_self (N : Nat) : varied N N = 0 :=
  if pos : 0 < N then by
    show (if 0 < N then (if N < N then 1 else 0) else 0) = 0
    rw [if_pos pos, if_neg (Nat.lt_irrefl N)]
  else if_neg pos

/-- Each sampling from a varied population: its weight times what follows from it, with its
weight times the bound where it fixes or loses the first kind, is at most its weight times the
bound. -/
theorem varied_step {N h M : Nat} (S : Nat → Nat) (zero : S 0 = 0) (full : S N = 0)
    (bound : ∀ c, c ≤ N → S c ≤ M) (pos : 0 < N) {w : List Bool} (len : w.length = N) :
    weight h (N - h) w * S (ones w) + (lost h (N - h) w * M + whole h (N - h) w * M) ≤
      weight h (N - h) w * M :=
  have le := Nat.le_trans (ones_le w) (Nat.le_of_eq len)
  if none : ones w = 0 then by
    have some : ¬ zeros w = 0 := fun z => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos (Nat.le_of_eq
      (len.symm.trans ((ones_add_zeros w).symm.trans (by rw [none, z])))))
    show weight h (N - h) w * S (ones w) + ((if ones w = 0 then weight h (N - h) w else 0) * M +
      (if zeros w = 0 then weight h (N - h) w else 0) * M) ≤ _
    rw [if_pos none, if_neg some, none, zero, Nat.mul_zero, Nat.zero_mul, Nat.add_zero, Nat.zero_add]
    exact Nat.le_refl _
  else if all : zeros w = 0 then by
    have at_full : ones w = N := (Nat.add_zero _).symm.trans ((congrArg (ones w + ·) all.symm).trans
      ((ones_add_zeros w).trans len))
    show weight h (N - h) w * S (ones w) + ((if ones w = 0 then weight h (N - h) w else 0) * M +
      (if zeros w = 0 then weight h (N - h) w else 0) * M) ≤ _
    rw [if_neg none, if_pos all, at_full, full, Nat.mul_zero, Nat.zero_mul, Nat.zero_add, Nat.zero_add]
    exact Nat.le_refl _
  else by
    show weight h (N - h) w * S (ones w) + ((if ones w = 0 then weight h (N - h) w else 0) * M +
      (if zeros w = 0 then weight h (N - h) w else 0) * M) ≤ _
    rw [if_neg none, if_neg all, Nat.zero_mul, Nat.add_zero]
    exact Nat.mul_le_mul_left _ (bound _ le)

theorem one_le_pow {p : Nat} (pos : 0 < p) : ∀ n, 1 ≤ p ^ n
  | 0 => Nat.le_refl 1
  | n + 1 => Nat.le_trans (one_le_pow pos n) (Nat.le_trans (Nat.le_of_eq (Nat.mul_one _).symm)
      (Nat.mul_le_mul_left _ pos))

/-- **Drift ends variation.** The histories of `k` sampled generations still varied weigh at most
`r ^ k`, where `r + 2 = N ^ N`: out of `(N ^ N) ^ k`, a share falling geometrically, since from a
varied population the samplings fixing and losing the first kind weigh at least one each. -/
theorem varied_vanishes {N r : Nat} (two : r + 2 = N ^ N) :
    ∀ k h, h ≤ N → sampled N (varied N) k h ≤ r ^ k
  | 0, h, _ => by
    show (if 0 < h then (if h < N then 1 else 0) else 0) ≤ 1
    exact if a : 0 < h then (if b : h < N then by rw [if_pos a, if_pos b]; exact Nat.le_refl 1
      else by rw [if_pos a, if_neg b]; exact Nat.zero_le 1) else by rw [if_neg a]; exact Nat.zero_le 1
  | k + 1, h, within =>
    if a : h = 0 then by
      rw [a, sampled_none, varied_zero, Nat.mul_zero]
      exact Nat.zero_le _
    else if b : h = N then by
      rw [b, sampled_all, varied_self, Nat.mul_zero]
      exact Nat.zero_le _
    else by
      have hpos : 0 < h := Nat.pos_of_ne_zero a
      have hlt : h < N := Nat.lt_of_le_of_ne within b
      have qpos : 0 < N - h := Nat.pos_of_ne_zero fun z =>
        Nat.lt_irrefl h (Nat.lt_of_lt_of_le hlt (Nat.le_of_eq
          ((add_sub_of_le within).symm.trans ((congrArg (h + ·) z).trans (Nat.add_zero h)))))
      have Npos : 0 < N := Nat.lt_of_le_of_lt (Nat.zero_le h) hlt
      have step := total_le_mem (Typicality.courses N) fun w mw =>
        varied_step (h := h) (M := r ^ k) (fun c => sampled N (varied N) k c)
          ((sampled_none N _ k).trans (by rw [varied_zero, Nat.mul_zero]))
          ((sampled_all N _ k).trans (by rw [varied_self, Nat.mul_zero]))
          (fun c le => varied_vanishes two k c le) Npos (mem_courses_iff.mp mw)
      rw [total_add, total_add, total_mul_right, total_mul_right, total_mul_right, lost_weight, whole_weight,
        total_weight, add_sub_of_le within, ← two] at step
      have twice : 2 * r ^ k ≤ (N - h) ^ N * r ^ k + h ^ N * r ^ k :=
        Nat.le_trans (Nat.le_of_eq (Nat.two_mul _)) (Nat.add_le_add
          (Nat.le_trans (Nat.le_of_eq (Nat.one_mul _).symm) (Nat.mul_le_mul_right _ (one_le_pow qpos N)))
          (Nat.le_trans (Nat.le_of_eq (Nat.one_mul _).symm) (Nat.mul_le_mul_right _ (one_le_pow hpos N))))
      rw [sampled_succ, Nat.pow_succ, Nat.mul_comm (r ^ k) r]
      exact Naturals.le_of_add_le_add_right (k := 2 * r ^ k) (Nat.le_trans (Nat.add_le_add_left twice _)
        (Nat.le_trans step (Nat.le_of_eq (add_mul_split r 2 (r ^ k)))))

theorem count_le (N c : Nat) (le : c ≤ N) : c ≤ N * fixed N c + N * varied N c :=
  if z : c = 0 then z ▸ Nat.zero_le _
  else if f : c = N then by
    show c ≤ N * (if c = N then 1 else 0) + N * (if 0 < c then (if c < N then 1 else 0) else 0)
    rw [if_pos f, if_pos (Nat.pos_of_ne_zero z), if_neg (show ¬ c < N from fun lt => Nat.lt_irrefl N (f ▸ lt)),
      Nat.mul_one]
    exact Nat.le_trans (Nat.le_of_eq f) (Nat.le_add_right _ _)
  else by
    show c ≤ N * (if c = N then 1 else 0) + N * (if 0 < c then (if c < N then 1 else 0) else 0)
    rw [if_neg f, if_pos (Nat.pos_of_ne_zero z), if_pos (Nat.lt_of_le_of_ne le f), Nat.mul_zero, Nat.zero_add,
      Nat.mul_one]
    exact le

theorem fixed_le (N c : Nat) : N * fixed N c ≤ c :=
  if f : c = N then by
    show N * (if c = N then 1 else 0) ≤ c
    rw [if_pos f, Nat.mul_one]
    exact Nat.le_of_eq f.symm
  else by
    show N * (if c = N then 1 else 0) ≤ c
    rw [if_neg f, Nat.mul_zero]
    exact Nat.zero_le c

/-- **Drift fixes each kind with its starting share.** Over `k` sampled generations from `h` of
`N`, the histories fixing the first kind weigh, times `N`, at most `h · (N ^ N) ^ k`, and with
`N · r ^ k` at least that: their share of the whole weight is within `r ^ k / (N ^ N) ^ k` of
`h / N`, so it tends to `h / N`, the neutral fixation probability. -/
theorem fixation {N r : Nat} (two : r + 2 = N ^ N) (k h : Nat) (within : h ≤ N) :
    N * sampled N (fixed N) k h ≤ h * (N ^ N) ^ k ∧
      h * (N ^ N) ^ k ≤ N * sampled N (fixed N) k h + N * r ^ k :=
  ⟨Nat.le_trans (Nat.le_of_eq (sampled_mul N N (fixed N) k h).symm)
      (Nat.le_trans (sampled_le (f := fun c => N * fixed N c) (g := fun c => c) (fun c _ => fixed_le N c) k h within)
        (Nat.le_of_eq (sampled_count N k h within))),
    Nat.le_trans (Nat.le_of_eq (sampled_count N k h within).symm) (Nat.le_trans
      (sampled_le (g := fun c => N * fixed N c + N * varied N c) (fun c le => count_le N c le) k h within)
      (Nat.le_trans (Nat.le_of_eq ((sampled_add N _ _ k h).trans (by rw [sampled_mul, sampled_mul])))
        (Nat.add_le_add_left (Nat.mul_le_mul_left N (varied_vanishes two k h within)) _)))⟩

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

namespace TwoMembers

/-- Two members, one of each kind, one sampled generation: of the four histories one fixes the
first kind, one loses it and two stay varied; `2 · 1 ≤ 1 · 4 ≤ 2 · 1 + 2 · 2`. -/
theorem one_generation :
    sampled 2 (fixed 2) 1 1 = 1 ∧ sampled 2 (varied 2) 1 1 = 2 ∧ sampled 2 (fun c => c) 1 1 = 4 ∧
      sampled 2 (fun _ => 1) 1 1 = 4 :=
  ⟨rfl, rfl, rfl, rfl⟩

end TwoMembers

end Drift

end Becoming
