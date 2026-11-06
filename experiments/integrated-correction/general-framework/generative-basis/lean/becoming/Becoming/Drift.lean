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
* **Selection in the draw: fixation leaves the starting share.** Among `M + 1` members, replace
  one at a time, reading only the steps that change the count: from a mixed population the count
  of the first kind goes up with weight `a` and down with weight `b` (in the one-birth-one-death
  chain both carry the factor `i · (M + 1 - i)` of the pairs that can change it, which drops from
  the ratio), and a population of one kind stays (`Replacement.value`, its histories counted
  step by step; composed, `Replacement.value_comp`). The potential with steps `b ^ j · a ^ (M - j)`
  (`Replacement.potential`, `Replacement.rise`) is harmonic for the steps, `a` times a step being
  `b` times the one below (`Replacement.rise_step`, `Replacement.potential_harmonic`), so it keeps
  its weighted value over any number of steps (`Replacement.value_potential`). Hence the histories
  fixing the first kind weigh, times the potential at the top, at most `(a + b) ^ k` times the
  potential at the start, and with the histories still varied at least that
  (`Replacement.fixation_bounds`); from a mixed population the histories climbing straight up weigh
  at least `a ^ (M + 1)` within `M + 1` steps (`Replacement.climbs`), so the varied ones weigh at
  most `r ^ m` after `m` rounds, with `r + a ^ (M + 1) = (a + b) ^ (M + 1)`
  (`Replacement.varied_vanishes`): the fixation share tends to the potential at the start over the
  potential at the top (`Replacement.fixation`), Moran's fixation probability with selection. With
  `a = b` the potential counts its steps and the share is the starting share
  (`Replacement.neutral_share`), as for sampled generations; with `b ≤ a` it is at least the
  starting share (`Replacement.favoured_share`), and with `b < a` strictly above it from every
  mixed start (`Replacement.favoured_share_above`). The favoured kind is never sure: from `i` the
  histories losing it weigh at least `b ^ i` times every later history
  (`Replacement.lost_ge`). Witness: two members, up two and down one, fixing the first kind with
  share two of three (`Favoured.two_members`).
* **With weights read from the count.** Each of these is the case at constant weights of replacement
  whose weights are read from the count (`Replacement.valueBy`): from a mixed count `i` up with `u i`,
  down with `d i`, and a step leaving the count with `e i`, every step weighing `T` together
  (`Replacement.Steps`), a population of one kind staying with `T`; at constant weights `u = a`,
  `d = b`, `e = 0` and `T = a + b` (`Replacement.value`, `Replacement.steps_const`). The potential's
  step at `j` is the downward weights at `1 … j` times the upward at `j + 1 … M`
  (`Replacement.riseBy`, `Replacement.downs`, `Replacement.ups`); `u (j + 1)` times the step at
  `j + 1` is `d (j + 1)` times the step at `j` (`Replacement.riseBy_step`), so the potential is
  harmonic and keeps its weighted value (`Replacement.valueBy_potential`), and the fixation bounds,
  the geometric vanishing of the varied and the lower bounds on fixing and losing hold as before
  (`Replacement.fixationBy`, `Replacement.climbsBy`, `Replacement.lost_geBy`). **On each side of where
  the weights balance**: across a stretch the upward weights times the step at its end are the
  downward weights times the step at its start (`Replacement.riseBy_shift`); where every count above
  `s` favours the first kind, the histories over any number of steps losing it from `s + n`, with `t`
  to the top, weigh, times the upward weights at `s + 1 … s + n`, at most `t` times the downward
  weights there times the whole weight (`Replacement.lostBy_favoured`); where every count up to
  `j + n` favours the second kind, the histories fixing the first from `j + 1` weigh, times the
  downward weights at `j + 1 … j + n`, at most `j + 1` times the upward weights there times the whole
  (`Replacement.fixedBy_disfavoured`). The potential's first step is the upward weights at `1 … M`
  multiplied and its last the downward weights there (`Replacement.riseBy_ends`): one member of each
  kind arising fixes with weights in that ratio.

Nothing here says which sampling happens: counting weighs the samplings, and as
`Becoming.Typicality` states, no record shows that the course that happens is among the many.
Drift is read as a count of the ways a sample can differ from its list, not as a chance supposed
of the unfolding. Modelling choices: two kinds; draws with replacement from the listed offspring,
each counted once (the Wright–Fisher sampling); over many generations a constant population size
and no selection or mutation in the draw; for selection in the draw, replacement one at a time
with constant natural-number weights `a` and `b` for the kinds (only the steps that change the
count read) and no mutation, the weights read from the count where stated, a step that leaves the
count weighed so that every step weighs alike; natural-number counts; discrete generations. No
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
  le_of_add_le_add_right _ (Nat.le_trans (Nat.le_of_eq (Nat.add_right_comm _ _ _))
    (Nat.le_trans (Nat.add_le_add_right taken _) (Nat.le_of_eq whole.symm)))

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
      rw [same, Nat.left_distrib (N * N), ← Reproduction.square_mul N e, ← Reproduction.square_mul n g]
      exact Nat.add_le_add_left (Nat.mul_le_mul ge ge) _
  | .inr le =>
    have zero : n * g = 0 := Nat.eq_zero_of_le_zero (Naturals.le_of_add_le_add_left
      (Nat.le_trans back (Nat.le_trans (Nat.mul_le_mul_left N le)
        (Nat.le_of_eq (Nat.add_zero _).symm))))
    by
      rw [← Reproduction.square_mul n g, zero, Nat.zero_mul, Nat.add_zero]
      exact Nat.mul_le_mul_left _ (Naturals.twice_le x y)

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
    exact Nat.mul_le_mul_left _ (Nat.mul_le_mul_left _ (Naturals.twice_le _ _))

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
  le_of_add_le_add_right _ (by
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
      exact le_of_add_le_add_right (2 * r ^ k) (Nat.le_trans (Nat.add_le_add_left twice _)
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

/-! ## Selection in the draw -/

namespace Replacement

/-- Both kinds present among `M + 1` members. -/
def Mixed (M i : Nat) : Prop := 0 < i ∧ i < M + 1

instance (M i : Nat) : Decidable (Mixed M i) := inferInstanceAs (Decidable (0 < i ∧ i < M + 1))

/-! ### Weights read from the count -/

/-- **Replacement one at a time, with weights read from the count.** Among `M + 1` members, `i` of
the first kind: from a mixed population a step moves the count up with weight `u i`, down with
`d i`, and leaves it with `e i` (a member replaced by one of its own kind); a population of one
kind stays, with weight `T`. `valueBy M T u d e f k i` totals a reading `f` of the count after `k`
steps from `i`, each history weighed by its steps. -/
def valueBy (M T : Nat) (u d e : Nat → Nat) (f : Nat → Nat) : Nat → Nat → Nat
  | 0, i => f i
  | k + 1, i => if Mixed M i then
      u i * valueBy M T u d e f k (i + 1) + d i * valueBy M T u d e f k (i - 1) +
        e i * valueBy M T u d e f k i
    else T * valueBy M T u d e f k i

/-- Every mixed count's three weights total `T`, so that every step weighs `T` together. -/
def Steps (M T : Nat) (u d e : Nat → Nat) : Prop := ∀ i, Mixed M i → u i + d i + e i = T

section Weights

variable {M T : Nat} {u d e : Nat → Nat}

theorem valueBy_mixed (f : Nat → Nat) (k : Nat) {i : Nat} (mixed : Mixed M i) :
    valueBy M T u d e f (k + 1) i =
      u i * valueBy M T u d e f k (i + 1) + d i * valueBy M T u d e f k (i - 1) +
        e i * valueBy M T u d e f k i :=
  if_pos mixed

theorem valueBy_one_kind (f : Nat → Nat) (k : Nat) {i : Nat} (one : ¬ Mixed M i) :
    valueBy M T u d e f (k + 1) i = T * valueBy M T u d e f k i :=
  if_neg one

/-- A population of one kind stays: its total is `T ^ k` times the reading. -/
theorem valueBy_stays (f : Nat → Nat) {i : Nat} (one : ¬ Mixed M i) :
    ∀ k, valueBy M T u d e f k i = T ^ k * f i
  | 0 => (Nat.one_mul _).symm
  | k + 1 => (valueBy_one_kind f k one).trans ((congrArg (T * ·) (valueBy_stays f one k)).trans
      ((mul_assoc_nat _ _ _).symm.trans (congrArg (· * f i) (Nat.mul_comm _ _))))

theorem add_three_pairs (x y z x' y' z' : Nat) :
    x + x' + (y + y') + (z + z') = x + y + z + (x' + y' + z') :=
  (congrArg (· + (z + z')) (Nat.add_add_add_comm x x' y y')).trans
    (Nat.add_add_add_comm (x + y) (x' + y') z z')

theorem valueBy_add (f g : Nat → Nat) :
    ∀ k i, valueBy M T u d e (fun j => f j + g j) k i =
      valueBy M T u d e f k i + valueBy M T u d e g k i
  | 0, _ => rfl
  | k + 1, i =>
    if mixed : Mixed M i then by
      rw [valueBy_mixed _ k mixed, valueBy_mixed _ k mixed, valueBy_mixed _ k mixed,
        valueBy_add f g k (i + 1), valueBy_add f g k (i - 1), valueBy_add f g k i,
        Nat.left_distrib, Nat.left_distrib, Nat.left_distrib]
      exact add_three_pairs _ _ _ _ _ _
    else by
      rw [valueBy_one_kind _ k mixed, valueBy_one_kind _ k mixed, valueBy_one_kind _ k mixed,
        valueBy_add f g k i, Nat.left_distrib]

theorem valueBy_mul (c : Nat) (f : Nat → Nat) :
    ∀ k i, valueBy M T u d e (fun j => c * f j) k i = c * valueBy M T u d e f k i
  | 0, _ => rfl
  | k + 1, i =>
    if mixed : Mixed M i then by
      rw [valueBy_mixed _ k mixed, valueBy_mixed _ k mixed, valueBy_mul c f k (i + 1),
        valueBy_mul c f k (i - 1), valueBy_mul c f k i, mul_turn (u i) c, mul_turn (d i) c,
        mul_turn (e i) c, ← Nat.left_distrib, ← Nat.left_distrib]
    else by
      rw [valueBy_one_kind _ k mixed, valueBy_one_kind _ k mixed, valueBy_mul c f k i, mul_turn]

theorem valueBy_le {f g : Nat → Nat} (le : ∀ j, f j ≤ g j) :
    ∀ k i, valueBy M T u d e f k i ≤ valueBy M T u d e g k i
  | 0, i => le i
  | k + 1, i =>
    if mixed : Mixed M i then by
      rw [valueBy_mixed _ k mixed, valueBy_mixed _ k mixed]
      exact Nat.add_le_add (Nat.add_le_add (Nat.mul_le_mul_left _ (valueBy_le le k (i + 1)))
        (Nat.mul_le_mul_left _ (valueBy_le le k (i - 1)))) (Nat.mul_le_mul_left _ (valueBy_le le k i))
    else by
      rw [valueBy_one_kind _ k mixed, valueBy_one_kind _ k mixed]
      exact Nat.mul_le_mul_left _ (valueBy_le le k i)

theorem valueBy_congr {f g : Nat → Nat} (same : ∀ j, f j = g j) (k i : Nat) :
    valueBy M T u d e f k i = valueBy M T u d e g k i :=
  Nat.le_antisymm (valueBy_le (fun j => Nat.le_of_eq (same j)) k i)
    (valueBy_le (fun j => Nat.le_of_eq (same j).symm) k i)

/-- Where every step weighs `T` together, a constant reading totals `T ^ k` times itself. -/
theorem valueBy_const (steps : Steps M T u d e) (c : Nat) :
    ∀ k i, valueBy M T u d e (fun _ => c) k i = T ^ k * c
  | 0, _ => (Nat.one_mul c).symm
  | k + 1, i =>
    if mixed : Mixed M i then by
      rw [valueBy_mixed _ k mixed, valueBy_const steps c k (i + 1), valueBy_const steps c k (i - 1),
        valueBy_const steps c k i, ← add_mul_split, ← add_mul_split, steps i mixed,
        ← mul_assoc_nat, Nat.mul_comm T, Nat.pow_succ]
    else by
      rw [valueBy_one_kind _ k mixed, valueBy_const steps c k i, ← mul_assoc_nat, Nat.mul_comm T,
        Nat.pow_succ]

/-- Histories compose: `n` more steps after `k` read the total of the last `n` as the reading. -/
theorem valueBy_comp (f : Nat → Nat) (n : Nat) :
    ∀ k i, valueBy M T u d e f (n + k) i = valueBy M T u d e (valueBy M T u d e f n) k i
  | 0, _ => rfl
  | k + 1, i =>
    if mixed : Mixed M i then by
      show valueBy M T u d e f (n + k + 1) i = _
      rw [valueBy_mixed _ _ mixed, valueBy_mixed _ _ mixed, valueBy_comp f n k (i + 1),
        valueBy_comp f n k (i - 1), valueBy_comp f n k i]
    else by
      show valueBy M T u d e f (n + k + 1) i = _
      rw [valueBy_one_kind _ _ mixed, valueBy_one_kind _ _ mixed, valueBy_comp f n k i]

/-! #### The potential with weights read from the count -/

/-- The downward weights from one up to `j`, multiplied. -/
def downs (d : Nat → Nat) : Nat → Nat
  | 0 => 1
  | j + 1 => downs d j * d (j + 1)

/-- The upward weights at `j + 1` to `j + n`, multiplied. -/
def ups (u : Nat → Nat) (j : Nat) : Nat → Nat
  | 0 => 1
  | n + 1 => u (j + 1) * ups u (j + 1) n

/-- The steps of the potential: the downward weights at `1 … j` and the upward weights at
`j + 1 … M` multiplied, up to the top; nothing beyond. -/
def riseBy (M : Nat) (u d : Nat → Nat) (j : Nat) : Nat :=
  if j ≤ M then downs d j * ups u j (M - j) else 0

/-- The potential: the steps below a count, totalled. -/
def potentialBy (M : Nat) (u d : Nat → Nat) : Nat → Nat
  | 0 => 0
  | j + 1 => potentialBy M u d j + riseBy M u d j

/-- **Each step up weighs against each step down at its count**: `u (j + 1)` times the step at
`j + 1` is `d (j + 1)` times the step at `j`. -/
theorem riseBy_step {j : Nat} (below : j < M) :
    u (j + 1) * riseBy M u d (j + 1) = d (j + 1) * riseBy M u d j := by
  have le1 : j + 1 ≤ M := below
  have le0 : j ≤ M := Nat.le_of_lt below
  obtain ⟨t, top⟩ := le_dest le1
  have e1 : M - (j + 1) = t := by rw [top]; exact Naturals.add_sub_cancel_left (j + 1) t
  have e0 : M - j = t + 1 := by
    rw [top, Nat.add_assoc, Nat.add_comm 1 t]; exact Naturals.add_sub_cancel_left j (t + 1)
  show u (j + 1) * (if j + 1 ≤ M then downs d (j + 1) * ups u (j + 1) (M - (j + 1)) else 0) =
    d (j + 1) * (if j ≤ M then downs d j * ups u j (M - j) else 0)
  rw [if_pos le1, if_pos le0, e1, e0]
  show u (j + 1) * (downs d j * d (j + 1) * ups u (j + 1) t) =
    d (j + 1) * (downs d j * (u (j + 1) * ups u (j + 1) t))
  rw [mul_assoc_nat (downs d j), mul_turn (downs d j) (d (j + 1)), mul_turn (downs d j) (u (j + 1)),
    mul_turn (d (j + 1)) (u (j + 1))]

theorem harmonic_step {x y z P r r' : Nat} (step : x * r' = y * r) :
    x * (P + r + r') + y * P + z * (P + r) = (x + y + z) * (P + r) := by
  rw [Nat.left_distrib x (P + r) r', step, add_mul_split, add_mul_split, Nat.left_distrib y P r,
    Nat.add_assoc (x * (P + r)) (y * r) (y * P), Nat.add_comm (y * r) (y * P)]

/-- The potential is harmonic for the steps: from a mixed count, `u i` times the potential above,
`d i` times the one below and `e i` times its own total the three weights times its own. -/
theorem potentialBy_harmonic {i : Nat} (mixed : Mixed M i) :
    u i * potentialBy M u d (i + 1) + d i * potentialBy M u d (i - 1) + e i * potentialBy M u d i =
      (u i + d i + e i) * potentialBy M u d i :=
  match i, mixed with
  | _ + 1, ⟨_, lt⟩ => harmonic_step (riseBy_step (Nat.lt_of_succ_lt_succ lt))

/-- So, where every step weighs `T` together, the potential keeps its weighted value over any
number of steps. -/
theorem valueBy_potential (steps : Steps M T u d e) :
    ∀ k i, valueBy M T u d e (potentialBy M u d) k i = T ^ k * potentialBy M u d i
  | 0, _ => (Nat.one_mul _).symm
  | k + 1, i =>
    if mixed : Mixed M i then by
      rw [valueBy_mixed _ k mixed, valueBy_potential steps k (i + 1),
        valueBy_potential steps k (i - 1), valueBy_potential steps k i, mul_turn (u i),
        mul_turn (d i), mul_turn (e i), ← Nat.left_distrib, ← Nat.left_distrib,
        potentialBy_harmonic mixed, steps i mixed, Nat.pow_succ, mul_assoc_nat]
    else by
      rw [valueBy_one_kind _ k mixed, valueBy_potential steps k i, Nat.pow_succ, mul_assoc_nat,
        mul_turn]

theorem potentialBy_le_succ (j : Nat) : potentialBy M u d j ≤ potentialBy M u d (j + 1) :=
  Nat.le_add_right _ _

theorem potentialBy_mono {i : Nat} : ∀ {j}, i ≤ j → potentialBy M u d i ≤ potentialBy M u d j
  | _, .refl => Nat.le_refl _
  | _ + 1, .step le => Nat.le_trans (potentialBy_mono le) (potentialBy_le_succ _)

/-- Beyond the top the potential stays. -/
theorem potentialBy_beyond : ∀ t, potentialBy M u d (M + 1 + t) = potentialBy M u d (M + 1)
  | 0 => rfl
  | t + 1 => by
    show potentialBy M u d (M + 1 + t) + riseBy M u d (M + 1 + t) = _
    have beyond : ¬ M + 1 + t ≤ M := fun le =>
      Nat.lt_irrefl M (Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le (Nat.lt_succ_self M) (Nat.le_add_right _ t)) le)
    show _ + (if M + 1 + t ≤ M then _ else 0) = _
    rw [if_neg beyond, Nat.add_zero, potentialBy_beyond t]

theorem potentialBy_le_top (j : Nat) : potentialBy M u d j ≤ potentialBy M u d (M + 1) :=
  match Nat.le_total j (M + 1) with
  | .inl le => potentialBy_mono le
  | .inr ge => match le_dest ge with
    | ⟨t, same⟩ => Nat.le_of_eq (same ▸ potentialBy_beyond t)

end Weights

/-- **Replacement one at a time.** Among `M + 1` members, `i` of the first kind: from a mixed
population a step moves the count up with weight `a` (a member of the first kind replaces one of
the second) and down with weight `b`; a population of one kind stays, with weight `a + b`.
`value M a b f k i` totals a reading `f` of the count after `k` steps from `i`, each history
weighed by its steps: the chain with weights read from the count (`valueBy`) at constant weights,
no step leaving the count. -/
def value (M a b : Nat) (f : Nat → Nat) : Nat → Nat → Nat :=
  valueBy M (a + b) (fun _ => a) (fun _ => b) (fun _ => 0) f

variable {M a b : Nat}

/-- At constant weights every step weighs `a + b` together. -/
theorem steps_const : Steps M (a + b) (fun _ => a) (fun _ => b) (fun _ => 0) :=
  fun _ _ => Nat.add_zero (a + b)

theorem value_mixed (f : Nat → Nat) (k : Nat) {i : Nat} (mixed : Mixed M i) :
    value M a b f (k + 1) i = a * value M a b f k (i + 1) + b * value M a b f k (i - 1) :=
  (valueBy_mixed (T := a + b) (u := fun _ => a) (d := fun _ => b) (e := fun _ => 0) f k mixed).trans
    (by rw [Nat.zero_mul, Nat.add_zero]; rfl)

theorem value_one_kind (f : Nat → Nat) (k : Nat) {i : Nat} (one : ¬ Mixed M i) :
    value M a b f (k + 1) i = (a + b) * value M a b f k i :=
  valueBy_one_kind f k one

/-- A population of one kind stays: its total is `(a + b) ^ k` times the reading. -/
theorem value_stays (f : Nat → Nat) {i : Nat} (one : ¬ Mixed M i) :
    ∀ k, value M a b f k i = (a + b) ^ k * f i :=
  valueBy_stays f one

theorem value_add (f g : Nat → Nat) :
    ∀ k i, value M a b (fun j => f j + g j) k i = value M a b f k i + value M a b g k i :=
  valueBy_add f g

theorem value_mul (c : Nat) (f : Nat → Nat) :
    ∀ k i, value M a b (fun j => c * f j) k i = c * value M a b f k i :=
  valueBy_mul c f

theorem value_le {f g : Nat → Nat} (le : ∀ j, f j ≤ g j) :
    ∀ k i, value M a b f k i ≤ value M a b g k i :=
  valueBy_le le

/-- Every history weighs its steps: a constant reading totals `(a + b) ^ k` times itself. -/
theorem value_const (c : Nat) : ∀ k i, value M a b (fun _ => c) k i = (a + b) ^ k * c :=
  valueBy_const steps_const c

/-- Histories compose: `n` more steps after `k` read the total of the last `n` as the reading. -/
theorem value_comp (f : Nat → Nat) (n : Nat) :
    ∀ k i, value M a b f (n + k) i = value M a b (value M a b f n) k i :=
  valueBy_comp f n

/-! ### The potential -/

theorem downs_const (b : Nat) : ∀ j, downs (fun _ => b) j = b ^ j
  | 0 => rfl
  | j + 1 => by
    show downs (fun _ => b) j * b = b ^ (j + 1)
    rw [downs_const b j, Nat.pow_succ]

theorem ups_const (a j : Nat) : ∀ n, ups (fun _ => a) j n = a ^ n
  | 0 => rfl
  | n + 1 => by
    show a * ups (fun _ => a) (j + 1) n = a ^ (n + 1)
    rw [ups_const a (j + 1) n, Nat.pow_succ, Nat.mul_comm]

/-- The steps of the potential at constant weights. -/
def rise (M a b j : Nat) : Nat := riseBy M (fun _ => a) (fun _ => b) j

/-- They are `b ^ j · a ^ (M - j)` up to the top, nothing beyond. -/
theorem rise_closed (j : Nat) : rise M a b j = if j ≤ M then b ^ j * a ^ (M - j) else 0 := by
  show (if j ≤ M then downs (fun _ => b) j * ups (fun _ => a) j (M - j) else 0) = _
  rw [downs_const, ups_const]

/-- The potential: the steps below a count, totalled. -/
def potential (M a b : Nat) : Nat → Nat := potentialBy M (fun _ => a) (fun _ => b)

/-- Each step up weighs `a` against each step down `b`: `a` times a step is `b` times the one
below it. -/
theorem rise_step {j : Nat} (below : j < M) : a * rise M a b (j + 1) = b * rise M a b j :=
  riseBy_step (u := fun _ => a) (d := fun _ => b) below

/-- The potential is harmonic for the steps: from a mixed count, `a` times the potential above
with `b` times the one below is `a + b` times its own. -/
theorem potential_harmonic {i : Nat} (mixed : Mixed M i) :
    a * potential M a b (i + 1) + b * potential M a b (i - 1) = (a + b) * potential M a b i :=
  have h := potentialBy_harmonic (e := fun _ => 0) (u := fun _ => a) (d := fun _ => b) mixed
  by rw [Nat.zero_mul, Nat.add_zero, Nat.add_zero] at h; exact h

/-- So the potential keeps its weighted value over any number of steps. -/
theorem value_potential : ∀ k i, value M a b (potential M a b) k i = (a + b) ^ k * potential M a b i :=
  valueBy_potential steps_const

theorem potential_le_succ (j : Nat) : potential M a b j ≤ potential M a b (j + 1) :=
  potentialBy_le_succ j

theorem potential_mono {i j : Nat} (le : i ≤ j) : potential M a b i ≤ potential M a b j :=
  potentialBy_mono le

/-- Beyond the top the potential stays. -/
theorem potential_beyond (t : Nat) : potential M a b (M + 1 + t) = potential M a b (M + 1) :=
  potentialBy_beyond t

theorem potential_le_top (j : Nat) : potential M a b j ≤ potential M a b (M + 1) :=
  potentialBy_le_top j

/-! ### Fixation with selection -/

/-- Fixed: every member of the first kind. -/
def fixed (M i : Nat) : Nat := if M + 1 ≤ i then 1 else 0

/-- Lost: none of the first kind. -/
def lost (i : Nat) : Nat := if i = 0 then 1 else 0

/-- Still varied. -/
def varied (M i : Nat) : Nat := if Mixed M i then 1 else 0

theorem partition (M i : Nat) : fixed M i + lost i + varied M i = 1 :=
  if z : i = 0 then by
    show (if M + 1 ≤ i then 1 else 0) + (if i = 0 then 1 else 0) + (if Mixed M i then 1 else 0) = 1
    rw [if_pos z, z, if_neg (fun le => Nat.not_succ_le_zero M le),
      if_neg (fun m : Mixed M 0 => Nat.lt_irrefl 0 m.1)]
  else if top : M + 1 ≤ i then by
    show (if M + 1 ≤ i then 1 else 0) + (if i = 0 then 1 else 0) + (if Mixed M i then 1 else 0) = 1
    rw [if_pos top, if_neg z, if_neg (fun m : Mixed M i => Nat.lt_irrefl i (Nat.lt_of_lt_of_le m.2 top))]
  else by
    show (if M + 1 ≤ i then 1 else 0) + (if i = 0 then 1 else 0) + (if Mixed M i then 1 else 0) = 1
    rw [if_neg top, if_neg z, if_pos ⟨Nat.pos_of_ne_zero z, Nat.lt_of_not_le top⟩]

section Weights

variable {M T : Nat} {u d e : Nat → Nat}

/-- Where every step weighs `T` together, every history ends fixed, lost or varied: their totals
add up to the whole weight. -/
theorem valueBy_partition (steps : Steps M T u d e) (k i : Nat) :
    valueBy M T u d e (fixed M) k i + valueBy M T u d e lost k i +
        valueBy M T u d e (varied M) k i = T ^ k :=
  (congrArg (· + valueBy M T u d e (varied M) k i) (valueBy_add (fixed M) lost k i).symm).trans
    ((valueBy_add (fun j => fixed M j + lost j) (varied M) k i).symm.trans
      ((valueBy_congr (fun j => partition M j) k i).trans
        ((valueBy_const steps 1 k i).trans (Nat.mul_one _))))

theorem fixedBy_below (j : Nat) : potentialBy M u d (M + 1) * fixed M j ≤ potentialBy M u d j :=
  if top : M + 1 ≤ j then by
    show _ * (if M + 1 ≤ j then 1 else 0) ≤ _
    rw [if_pos top, Nat.mul_one]; exact potentialBy_mono top
  else by
    show _ * (if M + 1 ≤ j then 1 else 0) ≤ _
    rw [if_neg top, Nat.mul_zero]; exact Nat.zero_le _

theorem potentialBy_within (j : Nat) :
    potentialBy M u d j ≤
      potentialBy M u d (M + 1) * fixed M j + potentialBy M u d (M + 1) * varied M j :=
  if z : j = 0 then by rw [z]; exact Nat.zero_le _
  else if top : M + 1 ≤ j then by
    show _ ≤ _ * (if M + 1 ≤ j then 1 else 0) + _
    rw [if_pos top, Nat.mul_one]; exact Nat.le_trans (potentialBy_le_top j) (Nat.le_add_right _ _)
  else by
    show _ ≤ _ + _ * (if Mixed M j then 1 else 0)
    rw [if_pos ⟨Nat.pos_of_ne_zero z, Nat.lt_of_not_le top⟩, Nat.mul_one]
    exact Nat.le_trans (potentialBy_le_top j) (Nat.le_add_left _ _)

/-- **Where fixation stands, with weights read from the count.** Where every step weighs `T`
together, over `k` steps from `i` the histories fixing the first kind weigh, times the potential at
the top, at most `T ^ k` times the potential at `i`, and with the histories still varied, at least
that. -/
theorem fixationBy_bounds (steps : Steps M T u d e) (k i : Nat) :
    potentialBy M u d (M + 1) * valueBy M T u d e (fixed M) k i ≤ T ^ k * potentialBy M u d i ∧
      T ^ k * potentialBy M u d i ≤
        potentialBy M u d (M + 1) * valueBy M T u d e (fixed M) k i +
          potentialBy M u d (M + 1) * valueBy M T u d e (varied M) k i :=
  ⟨Nat.le_trans (Nat.le_of_eq (valueBy_mul _ _ k i).symm)
      (Nat.le_trans (valueBy_le fixedBy_below k i) (Nat.le_of_eq (valueBy_potential steps k i))),
    Nat.le_trans (Nat.le_of_eq (valueBy_potential steps k i).symm)
      (Nat.le_trans (valueBy_le potentialBy_within k i)
        (Nat.le_of_eq ((valueBy_add _ _ k i).trans (by rw [valueBy_mul, valueBy_mul]))))⟩

/-- Climbing: where every upward weight at a mixed count is at least `c` and a population of one
kind stays with at least `c`, from a member of the first kind within reach of the top in `k`
steps the histories fixing it weigh at least `c ^ k`. -/
theorem climbsBy {c : Nat} (low : ∀ j, Mixed M j → c ≤ u j) (stay : c ≤ T) :
    ∀ k i, 0 < i → M + 1 ≤ i + k → c ^ k ≤ valueBy M T u d e (fixed M) k i
  | 0, i, _, reach => by
    show 1 ≤ (if M + 1 ≤ i then 1 else 0)
    rw [if_pos (show M + 1 ≤ i from reach)]; exact Nat.le_refl 1
  | k + 1, i, pos, reach =>
    if mixed : Mixed M i then by
      rw [valueBy_mixed _ k mixed, Nat.pow_succ, Nat.mul_comm (c ^ k)]
      exact Nat.le_trans (Nat.mul_le_mul (low i mixed) (climbsBy low stay k (i + 1) (Nat.succ_pos i)
        (Nat.le_trans reach (Nat.le_of_eq (Nat.succ_add i k).symm))))
        (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_add_right _ _))
    else by
      have top : M + 1 ≤ i := Nat.le_of_not_lt fun lt => mixed ⟨pos, lt⟩
      rw [valueBy_one_kind _ k mixed, Nat.pow_succ, Nat.mul_comm (c ^ k)]
      exact Nat.mul_le_mul stay (climbsBy low stay k i pos (Nat.le_trans top (Nat.le_add_right i k)))

/-- From a varied population, in `M + 1` steps, the histories still varied weigh at most
`T ^ (M + 1)` less `c ^ (M + 1)`; from one of one kind, none. -/
theorem varied_stepBy {c : Nat} (steps : Steps M T u d e) (low : ∀ j, Mixed M j → c ≤ u j)
    (stay : c ≤ T) (j : Nat) :
    valueBy M T u d e (varied M) (M + 1) j + c ^ (M + 1) * varied M j ≤ T ^ (M + 1) * varied M j :=
  if mixed : Mixed M j then by
    have one : varied M j = 1 := if_pos mixed
    have up := climbsBy (e := e) (d := d) low stay (M + 1) j mixed.1 (Nat.le_add_left _ _)
    rw [one, Nat.mul_one, Nat.mul_one, ← valueBy_partition steps (M + 1) j,
      Nat.add_comm (valueBy M T u d e (varied M) (M + 1) j)]
    exact Nat.add_le_add_right (Nat.le_trans up (Nat.le_add_right _ _)) _
  else by
    have zero : varied M j = 0 := if_neg mixed
    rw [valueBy_stays _ mixed, zero, Nat.mul_zero, Nat.mul_zero]
    exact Nat.le_refl 0

/-- **Selection in the draw ends variation**, with weights read from the count: with
`r + c ^ (M + 1) = T ^ (M + 1)`, the histories still varied after `m` rounds of `M + 1` steps weigh
at most `r ^ m`, out of `T ^ ((M + 1) · m)`. -/
theorem varied_vanishesBy {c r : Nat} (steps : Steps M T u d e) (low : ∀ j, Mixed M j → c ≤ u j)
    (stay : c ≤ T) (split : r + c ^ (M + 1) = T ^ (M + 1)) :
    ∀ m i, valueBy M T u d e (varied M) ((M + 1) * m) i ≤ r ^ m
  | 0, i => by
    show (if Mixed M i then 1 else 0) ≤ 1
    exact if mixed : Mixed M i then by rw [if_pos mixed]; exact Nat.le_refl 1
      else by rw [if_neg mixed]; exact Nat.zero_le 1
  | m + 1, i => by
    have each : ∀ j, valueBy M T u d e (varied M) (M + 1) j ≤ r * varied M j := fun j =>
      le_of_add_le_add_right (c ^ (M + 1) * varied M j)
        (Nat.le_trans (varied_stepBy steps low stay j)
          (Nat.le_of_eq ((congrArg (· * varied M j) split.symm).trans (add_mul_split _ _ _))))
    rw [Nat.mul_succ, Nat.add_comm, valueBy_comp]
    exact Nat.le_trans (valueBy_le each _ i)
      (Nat.le_trans (Nat.le_of_eq (valueBy_mul r (varied M) _ i))
        (Nat.le_trans (Nat.mul_le_mul_left r (varied_vanishesBy steps low stay split m i))
          (Nat.le_of_eq (Nat.mul_comm r (r ^ m)))))

/-- **Fixation with selection in the draw, with weights read from the count.** Over `m` rounds of
`M + 1` steps from `i`, the histories fixing the first kind weigh, times the potential at the top,
at most `T ^ ((M + 1) · m)` times the potential at `i`, and with the potential at the top times
`r ^ m`, at least that: their share tends to the potential at `i` over the potential at the top. -/
theorem fixationBy {c r : Nat} (steps : Steps M T u d e) (low : ∀ j, Mixed M j → c ≤ u j)
    (stay : c ≤ T) (split : r + c ^ (M + 1) = T ^ (M + 1)) (m i : Nat) :
    potentialBy M u d (M + 1) * valueBy M T u d e (fixed M) ((M + 1) * m) i ≤
        T ^ ((M + 1) * m) * potentialBy M u d i ∧
      T ^ ((M + 1) * m) * potentialBy M u d i ≤
        potentialBy M u d (M + 1) * valueBy M T u d e (fixed M) ((M + 1) * m) i +
          potentialBy M u d (M + 1) * r ^ m :=
  ⟨(fixationBy_bounds steps _ i).1, Nat.le_trans (fixationBy_bounds steps _ i).2
    (Nat.add_le_add_left (Nat.mul_le_mul_left _ (varied_vanishesBy steps low stay split m i)) _)⟩

/-- **Never ruled out**, with weights read from the count: where every downward weight at a mixed
count is at least `c`, from `i` mixed or none the histories losing the first kind weigh at least
`c ^ i` times every later history. -/
theorem lost_geBy {c : Nat} (low : ∀ j, Mixed M j → c ≤ d j) (k : Nat) :
    ∀ i, i ≤ M → c ^ i * T ^ k ≤ valueBy M T u d e lost (k + i) i
  | 0, _ => Nat.le_of_eq (by
      rw [Nat.pow_zero, Nat.one_mul, Nat.add_zero,
        valueBy_stays lost (fun m : Mixed M 0 => Nat.lt_irrefl 0 m.1)]
      show _ = _ * (if 0 = 0 then 1 else 0)
      rw [if_pos rfl, Nat.mul_one])
  | i + 1, le => by
    have mixed : Mixed M (i + 1) := ⟨Nat.succ_pos i, Nat.succ_lt_succ le⟩
    show _ ≤ valueBy M T u d e lost (k + i + 1) (i + 1)
    rw [valueBy_mixed _ _ mixed, Nat.pow_succ, Nat.mul_comm (c ^ i) c, mul_assoc_nat]
    exact Nat.le_trans (Nat.mul_le_mul (low (i + 1) mixed) (lost_geBy low k i (Nat.le_of_succ_le le)))
      (Nat.le_trans (Nat.le_add_left _ _) (Nat.le_add_right _ _))

/-! #### On each side of where the weights balance -/

theorem le_of_le_eq {a b c : Nat} (le : a ≤ b) (same : b = c) : a ≤ c := same ▸ le

theorem le_of_eq_le {a b c : Nat} (same : a = b) (le : b ≤ c) : a ≤ c := same ▸ le

theorem turn_out (a b c P : Nat) : c * (a * (b * P)) = P * (a * b * c) := by
  rw [← mul_assoc_nat a b P, ← mul_assoc_nat c, Nat.mul_comm _ P, Nat.mul_comm c]

/-- Weights at least others across a stretch give a product at least theirs. -/
theorem ups_le {f g : Nat → Nat} : ∀ {n j : Nat}, (∀ k, j < k → k ≤ j + n → f k ≤ g k) →
    ups f j n ≤ ups g j n
  | 0, _, _ => Nat.le_refl 1
  | n + 1, j, le => Nat.mul_le_mul (le (j + 1) (Nat.lt_succ_self j)
      (Nat.succ_le_succ (Nat.le_add_right j n)))
    (ups_le fun k lt kle => le k (Nat.lt_of_succ_lt lt) (le_of_le_eq kle (shift_succ j n).symm))

/-- Positive weights across a stretch give a positive product. -/
theorem ups_pos {f : Nat → Nat} : ∀ {n j : Nat}, (∀ k, j < k → k ≤ j + n → 0 < f k) → 0 < ups f j n
  | 0, _, _ => Nat.zero_lt_one
  | n + 1, j, pos => Nat.mul_pos (pos (j + 1) (Nat.lt_succ_self j)
      (Nat.succ_le_succ (Nat.le_add_right j n)))
    (ups_pos fun k lt kle => pos k (Nat.lt_of_succ_lt lt) (le_of_le_eq kle (shift_succ j n).symm))

/-- **The potential's steps across a stretch.** From `j`, `n` counts on and within the top, the
upward weights at `j + 1 … j + n` times the step at `j + n` are the downward weights there times
the step at `j`. -/
theorem riseBy_shift : ∀ (n j : Nat), j + n ≤ M →
    ups u j n * riseBy M u d (j + n) = ups d j n * riseBy M u d j
  | 0, _, _ => rfl
  | n + 1, j, le => by
    have e := shift_succ j n
    have below : j < M := Nat.lt_of_lt_of_le (Nat.lt_succ_of_le (Nat.le_add_right j n)) le
    have ih := riseBy_shift n (j + 1) (le_of_eq_le e.symm le)
    show u (j + 1) * ups u (j + 1) n * riseBy M u d (j + (n + 1)) =
      d (j + 1) * ups d (j + 1) n * riseBy M u d j
    rw [e, mul_assoc_nat (u (j + 1)), ih, mul_turn (u (j + 1)), riseBy_step below,
      mul_turn (ups d (j + 1) n), ← mul_assoc_nat]

/-- **Where the counts across a stretch favour the first kind** (each downward weight at most the
upward), the steps of the potential do not grow across it. -/
theorem riseBy_le_of_favoured {j n : Nat} (le : j + n ≤ M)
    (favoured : ∀ k, j < k → k ≤ j + n → d k ≤ u k) (pos : ∀ k, j < k → k ≤ j + n → 0 < u k) :
    riseBy M u d (j + n) ≤ riseBy M u d j :=
  SelectionTerm.le_of_mul_le_mul (ups_pos pos) (Nat.le_trans
    (Nat.le_of_eq (riseBy_shift n j le)) (Nat.mul_le_mul_right _ (ups_le favoured)))

/-- **Where they favour the second kind** (each upward weight at most the downward), the steps do not
fall across it. -/
theorem riseBy_le_of_disfavoured {j n : Nat} (le : j + n ≤ M)
    (disfavoured : ∀ k, j < k → k ≤ j + n → u k ≤ d k) (pos : ∀ k, j < k → k ≤ j + n → 0 < u k) :
    riseBy M u d j ≤ riseBy M u d (j + n) :=
  SelectionTerm.le_of_mul_le_mul (ups_pos pos) (Nat.le_trans
    (Nat.mul_le_mul_right _ (ups_le disfavoured)) (Nat.le_of_eq (riseBy_shift n j le).symm))

/-- With steps that do not grow from `i`, the potential rises from `i` over `t` more counts by at
most `t` of the step at `i`. -/
theorem potentialBy_tail {i : Nat} (fall : ∀ j, i ≤ j → riseBy M u d j ≤ riseBy M u d i) :
    ∀ t, potentialBy M u d (i + t) ≤ potentialBy M u d i + t * riseBy M u d i
  | 0 => Nat.le_of_eq (by rw [Nat.zero_mul]; rfl)
  | t + 1 => by
    show potentialBy M u d (i + t) + riseBy M u d (i + t) ≤ _
    rw [Nat.succ_mul, ← Nat.add_assoc]
    exact Nat.add_le_add (potentialBy_tail fall t) (fall (i + t) (Nat.le_add_right i t))

/-- With steps that do not fall up to `j`, the potential at `j + 1` is at most `j + 1` of the step
at `j`. -/
theorem potentialBy_head {j : Nat} (rise : ∀ l, l ≤ j → riseBy M u d l ≤ riseBy M u d j) :
    ∀ l, l ≤ j → potentialBy M u d (l + 1) ≤ (l + 1) * riseBy M u d j
  | 0, _ => by
    show 0 + riseBy M u d 0 ≤ (0 + 1) * riseBy M u d j
    rw [Nat.zero_add, Nat.zero_add, Nat.one_mul]; exact rise 0 (Nat.zero_le j)
  | l + 1, le => by
    show potentialBy M u d (l + 1) + riseBy M u d (l + 1) ≤ (l + 1 + 1) * riseBy M u d j
    rw [Nat.succ_mul]
    exact Nat.add_le_add (potentialBy_head rise l (Nat.le_of_succ_le le)) (rise (l + 1) le)

/-- Where every upward weight at a mixed count is positive, so is the potential at the top. -/
theorem potentialBy_top_pos (pos : ∀ k, Mixed M k → 0 < u k) : 0 < potentialBy M u d (M + 1) :=
  Nat.lt_of_lt_of_le (by
      show 0 < 0 + riseBy M u d 0
      rw [Nat.zero_add]
      show 0 < (if 0 ≤ M then downs d 0 * ups u 0 (M - 0) else 0)
      rw [if_pos (Nat.zero_le M), Nat.sub_zero]
      exact Nat.mul_pos Nat.zero_lt_one
        (ups_pos fun k lt le => pos k ⟨lt, Nat.lt_succ_of_le (le_of_le_eq le (Nat.zero_add M))⟩))
    (potentialBy_le_top 1)

/-- **Where losing stands.** Where every step weighs `T` together, over `k` steps from `i` the
histories losing the first kind weigh, times the potential at the top, with `T ^ k` times the
potential at `i`, at most `T ^ k` times the potential at the top; and with the histories still
varied, at least that. -/
theorem lostBy_bounds (steps : Steps M T u d e) (k i : Nat) :
    potentialBy M u d (M + 1) * valueBy M T u d e lost k i + T ^ k * potentialBy M u d i ≤
        T ^ k * potentialBy M u d (M + 1) ∧
      T ^ k * potentialBy M u d (M + 1) ≤
        potentialBy M u d (M + 1) * valueBy M T u d e lost k i + T ^ k * potentialBy M u d i +
          potentialBy M u d (M + 1) * valueBy M T u d e (varied M) k i := by
  have whole : potentialBy M u d (M + 1) * valueBy M T u d e (fixed M) k i +
      potentialBy M u d (M + 1) * valueBy M T u d e lost k i +
        potentialBy M u d (M + 1) * valueBy M T u d e (varied M) k i =
          T ^ k * potentialBy M u d (M + 1) := by
    rw [← Nat.left_distrib, ← Nat.left_distrib, valueBy_partition steps k i, Nat.mul_comm]
  have b := fixationBy_bounds steps k i
  exact ⟨Nat.le_trans (Nat.add_le_add_left b.2 _) (Nat.le_of_eq
      (((Nat.add_left_comm _ _ _).trans (Nat.add_assoc _ _ _).symm).trans whole)),
    Nat.le_trans (Nat.le_of_eq whole.symm) (le_of_eq_le
      (congrArg (· + potentialBy M u d (M + 1) * valueBy M T u d e (varied M) k i)
        (Nat.add_comm _ _))
      (Nat.add_le_add_right (Nat.add_le_add_left b.1 _) _))⟩

/-- **Above the balance, losing the first kind is bounded across the stretch.** Where every step
weighs `T` together, every upward weight at a mixed count is positive, and every count above `s`
favours the first kind (each downward weight at most the upward): from `s + n`, with `t` to the top,
the histories over `k` steps losing the first kind weigh, times the upward weights at
`s + 1 … s + n`, at most `t` times the downward weights there times the whole weight. Read as a
share, losing it is at most `t` times the product of each count's downward over upward weight
across the stretch. -/
theorem lostBy_favoured (steps : Steps M T u d e) (pos : ∀ k, Mixed M k → 0 < u k) {s n t : Nat}
    (top : s + n + t = M + 1) (favoured : ∀ k, s < k → k ≤ M → d k ≤ u k) (k : Nat) :
    ups u s n * valueBy M T u d e lost k (s + n) ≤ t * ups d s n * T ^ k := by
  cases t with
  | zero =>
    have one : ¬ Mixed M (s + n) := fun m => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le m.2 (Nat.le_of_eq top.symm))
    rw [valueBy_stays lost one]
    show _ * (_ * (if s + n = 0 then 1 else 0)) ≤ _
    rw [if_neg (show ¬ (s + n = 0) from fun z => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le
      (Nat.succ_pos M) (Nat.le_of_eq (top.symm.trans z))))]
    rw [Nat.mul_zero, Nat.mul_zero]; exact Nat.zero_le _
  | succ t =>
    have within : s + n ≤ M := Nat.le_of_succ_le_succ (le_of_le_eq
      (Nat.succ_le_succ (Nat.le_add_right (s + n) t)) top)
    have upPos : ∀ a b, a < b → b ≤ M → 0 < u b := fun _ b lt le =>
      pos b ⟨Nat.lt_of_le_of_lt (Nat.zero_le _) lt, Nat.lt_succ_of_le le⟩
    have fall : ∀ j, s + n ≤ j → riseBy M u d j ≤ riseBy M u d (s + n) := fun j le =>
      if beyond : j ≤ M then match le_dest le with
        | ⟨m, same⟩ => by
          rw [same] at beyond ⊢
          exact riseBy_le_of_favoured beyond
            (fun k lt kle => favoured k (Nat.lt_of_le_of_lt (Nat.le_add_right s n) lt)
              (Nat.le_trans kle beyond))
            (fun k lt kle => upPos _ k lt (Nat.le_trans kle beyond))
      else by
        show (if j ≤ M then _ else 0) ≤ _
        rw [if_neg beyond]; exact Nat.zero_le _
    have tail := potentialBy_tail fall (t + 1)
    rw [top] at tail
    have shift := riseBy_shift (u := u) (d := d) n s within
    have atS : riseBy M u d s ≤ potentialBy M u d (M + 1) :=
      Nat.le_trans (Nat.le_add_left _ _) (potentialBy_le_top (s + 1))
    have P := potentialBy_top_pos (d := d) pos
    have losing := (lostBy_bounds steps k (s + n)).1
    -- the top times the losing weight is at most `T ^ k` times `t + 1` steps at `s + n`
    have bound : potentialBy M u d (M + 1) * valueBy M T u d e lost k (s + n) ≤
        T ^ k * ((t + 1) * riseBy M u d (s + n)) :=
      le_of_add_le_add_right (T ^ k * potentialBy M u d (s + n))
        (Nat.le_trans losing (Nat.le_trans (Nat.mul_le_mul_left _ tail)
          (Nat.le_of_eq (by rw [Nat.left_distrib, Nat.add_comm]))))
    apply SelectionTerm.le_of_mul_le_mul P
    calc potentialBy M u d (M + 1) * (ups u s n * valueBy M T u d e lost k (s + n))
        = ups u s n * (potentialBy M u d (M + 1) * valueBy M T u d e lost k (s + n)) :=
          mul_turn _ _ _
      _ ≤ ups u s n * (T ^ k * ((t + 1) * riseBy M u d (s + n))) := Nat.mul_le_mul_left _ bound
      _ = T ^ k * ((t + 1) * (ups u s n * riseBy M u d (s + n))) := by
          rw [mul_turn (ups u s n), mul_turn (ups u s n)]
      _ = T ^ k * ((t + 1) * (ups d s n * riseBy M u d s)) := by rw [shift]
      _ ≤ T ^ k * ((t + 1) * (ups d s n * potentialBy M u d (M + 1))) :=
          Nat.mul_le_mul_left _ (Nat.mul_le_mul_left _ (Nat.mul_le_mul_left _ atS))
      _ = potentialBy M u d (M + 1) * ((t + 1) * ups d s n * T ^ k) := turn_out _ _ _ _

/-- **Below the balance, fixing the first kind is bounded across the stretch.** Where every step
weighs `T` together, every upward weight at a mixed count is positive, and every count from one to
`j + n` favours the second kind (each upward weight at most the downward): from `j + 1`, the
histories over `k` steps fixing the first kind weigh, times the downward weights at
`j + 1 … j + n`, at most `j + 1` times the upward weights there times the whole weight. Read as a
share, fixing it is at most `j + 1` times the product of each count's upward over downward weight
across the stretch. -/
theorem fixedBy_disfavoured (steps : Steps M T u d e) (pos : ∀ k, Mixed M k → 0 < u k) {j n : Nat}
    (within : j + n ≤ M) (disfavoured : ∀ k, 0 < k → k ≤ j + n → u k ≤ d k) (k : Nat) :
    ups d j n * valueBy M T u d e (fixed M) k (j + 1) ≤ (j + 1) * ups u j n * T ^ k := by
  have upPos : ∀ a b, a < b → b ≤ M → 0 < u b := fun _ b lt le =>
    pos b ⟨Nat.lt_of_le_of_lt (Nat.zero_le _) lt, Nat.lt_succ_of_le le⟩
  have jM : j ≤ M := Nat.le_trans (Nat.le_add_right j n) within
  have rise : ∀ l, l ≤ j → riseBy M u d l ≤ riseBy M u d j := fun l le =>
    match le_dest le with
    | ⟨m, same⟩ => by
      rw [same]
      exact riseBy_le_of_disfavoured (le_of_eq_le same.symm jM)
        (fun k lt kle => disfavoured k (Nat.lt_of_le_of_lt (Nat.zero_le l) lt)
          (Nat.le_trans (le_of_le_eq kle same.symm) (Nat.le_add_right j n)))
        (fun k lt kle => upPos _ k lt (Nat.le_trans (le_of_le_eq kle same.symm) jM))
  have head := potentialBy_head rise j (Nat.le_refl j)
  have shift := riseBy_shift (u := u) (d := d) n j within
  have atTop : riseBy M u d (j + n) ≤ potentialBy M u d (M + 1) :=
    Nat.le_trans (Nat.le_add_left _ _) (potentialBy_le_top (j + n + 1))
  have P := potentialBy_top_pos (d := d) pos
  have fix := (fixationBy_bounds steps k (j + 1)).1
  apply SelectionTerm.le_of_mul_le_mul P
  calc potentialBy M u d (M + 1) * (ups d j n * valueBy M T u d e (fixed M) k (j + 1))
      = ups d j n * (potentialBy M u d (M + 1) * valueBy M T u d e (fixed M) k (j + 1)) :=
        mul_turn _ _ _
    _ ≤ ups d j n * (T ^ k * potentialBy M u d (j + 1)) := Nat.mul_le_mul_left _ fix
    _ ≤ ups d j n * (T ^ k * ((j + 1) * riseBy M u d j)) :=
        Nat.mul_le_mul_left _ (Nat.mul_le_mul_left _ head)
    _ = T ^ k * ((j + 1) * (ups d j n * riseBy M u d j)) := by
        rw [mul_turn (ups d j n), mul_turn (ups d j n)]
    _ = T ^ k * ((j + 1) * (ups u j n * riseBy M u d (j + n))) := by rw [shift]
    _ ≤ T ^ k * ((j + 1) * (ups u j n * potentialBy M u d (M + 1))) :=
        Nat.mul_le_mul_left _ (Nat.mul_le_mul_left _ (Nat.mul_le_mul_left _ atTop))
    _ = potentialBy M u d (M + 1) * ((j + 1) * ups u j n * T ^ k) := turn_out _ _ _ _

/-- **One of each kind arising, the steps at the ends.** The potential's first step is the upward
weights at `1 … M` multiplied, and its last the downward weights there: from one member of the first
kind among the others, fixing it stands to the whole as the first step to the potential at the top;
from one member of the second kind among the first, losing the first kind stands to it as the last
step. -/
theorem riseBy_ends : riseBy M u d 0 = ups u 0 M ∧ riseBy M u d M = downs d M :=
  ⟨by
    show (if 0 ≤ M then downs d 0 * ups u 0 (M - 0) else 0) = _
    rw [if_pos (Nat.zero_le M), Nat.sub_zero]
    exact Nat.one_mul _,
   by
    show (if M ≤ M then downs d M * ups u M (M - M) else 0) = _
    rw [if_pos (Nat.le_refl M), Drift.sub_self_zero M]
    exact Nat.mul_one _⟩

end Weights

theorem value_congr {f g : Nat → Nat} (same : ∀ j, f j = g j) (k i : Nat) :
    value M a b f k i = value M a b g k i :=
  valueBy_congr same k i

/-- Every history ends fixed, lost or varied: their totals add up to the whole weight. -/
theorem value_partition (k i : Nat) :
    value M a b (fixed M) k i + value M a b lost k i + value M a b (varied M) k i = (a + b) ^ k :=
  valueBy_partition steps_const k i

theorem fixed_below (j : Nat) : potential M a b (M + 1) * fixed M j ≤ potential M a b j :=
  fixedBy_below j

theorem potential_within (j : Nat) :
    potential M a b j ≤ potential M a b (M + 1) * fixed M j + potential M a b (M + 1) * varied M j :=
  potentialBy_within j

/-- **Where fixation stands.** Over `k` steps from `i`, the histories fixing the first kind weigh,
times the potential at the top, at most `(a + b) ^ k` times the potential at `i`, and with the
histories still varied, at least that. -/
theorem fixation_bounds (k i : Nat) :
    potential M a b (M + 1) * value M a b (fixed M) k i ≤ (a + b) ^ k * potential M a b i ∧
      (a + b) ^ k * potential M a b i ≤
        potential M a b (M + 1) * value M a b (fixed M) k i +
          potential M a b (M + 1) * value M a b (varied M) k i :=
  fixationBy_bounds steps_const k i

/-- Climbing: from a member of the first kind, within reach of the top in `k` steps, the
histories fixing it weigh at least `a ^ k`. -/
theorem climbs : ∀ k i, 0 < i → M + 1 ≤ i + k → a ^ k ≤ value M a b (fixed M) k i :=
  climbsBy (fun _ _ => Nat.le_refl a) (Nat.le_add_right a b)

/-- From a varied population, in `M + 1` steps, the histories still varied weigh at most
`(a + b) ^ (M + 1)` less `a ^ (M + 1)`; from one of one kind, none. -/
theorem varied_step (j : Nat) :
    value M a b (varied M) (M + 1) j + a ^ (M + 1) * varied M j ≤ (a + b) ^ (M + 1) * varied M j :=
  varied_stepBy steps_const (fun _ _ => Nat.le_refl a) (Nat.le_add_right a b) j

/-- **Selection in the draw ends variation.** With `r + a ^ (M + 1) = (a + b) ^ (M + 1)`, the
histories still varied after `m` rounds of `M + 1` steps weigh at most `r ^ m`: out of
`(a + b) ^ ((M + 1) · m)`, a share falling geometrically where `a` is positive. -/
theorem varied_vanishes {r : Nat} (split : r + a ^ (M + 1) = (a + b) ^ (M + 1)) :
    ∀ m i, value M a b (varied M) ((M + 1) * m) i ≤ r ^ m :=
  varied_vanishesBy steps_const (fun _ _ => Nat.le_refl a) (Nat.le_add_right a b) split

/-- **Fixation with selection in the draw.** Over `m` rounds of `M + 1` steps from `i`, the histories
fixing the first kind weigh, times the potential at the top, at most `(a + b) ^ ((M + 1) · m)`
times the potential at `i`, and with the potential at the top times `r ^ m`, at least that: their
share tends to the potential at `i` over the potential at the top. -/
theorem fixation {r : Nat} (split : r + a ^ (M + 1) = (a + b) ^ (M + 1)) (m i : Nat) :
    potential M a b (M + 1) * value M a b (fixed M) ((M + 1) * m) i ≤
        (a + b) ^ ((M + 1) * m) * potential M a b i ∧
      (a + b) ^ ((M + 1) * m) * potential M a b i ≤
        potential M a b (M + 1) * value M a b (fixed M) ((M + 1) * m) i +
          potential M a b (M + 1) * r ^ m :=
  fixationBy steps_const (fun _ _ => Nat.le_refl a) (Nat.le_add_right a b) split m i

/-! ### Where fixation stands against the starting share -/

/-- Without selection in the draw (`a = b`) each step of the potential is the same. -/
theorem rise_neutral {j : Nat} (le : j ≤ M) : rise M a a j = a ^ M := by
  obtain ⟨t, top⟩ := le_dest le
  rw [rise_closed]
  rw [if_pos le, top, Naturals.add_sub_cancel_left, ← Naturals.pow_add]

/-- So the potential below the top counts its steps: `i` times `a ^ M`. -/
theorem potential_neutral : ∀ i, i ≤ M + 1 → potential M a a i = i * a ^ M
  | 0, _ => (Nat.zero_mul _).symm
  | i + 1, le => by
    show potential M a a i + rise M a a i = (i + 1) * a ^ M
    rw [potential_neutral i (Nat.le_of_succ_le le), rise_neutral (Nat.le_of_succ_le_succ le), Nat.succ_mul]

/-- Where the first kind is favoured or alike (`b ≤ a`, `a` positive), the steps do not grow. -/
theorem rise_antitone (pos : 0 < a) (favoured : b ≤ a) (j : Nat) :
    rise M a b (j + 1) ≤ rise M a b j :=
  if below : j < M then
    SelectionTerm.le_of_mul_le_mul pos (Nat.le_trans (Nat.le_of_eq (rise_step below))
      (Nat.mul_le_mul_right _ favoured))
  else by
    rw [rise_closed (j + 1)]
    rw [if_neg (show ¬ (j + 1 ≤ M) from below)]; exact Nat.zero_le _

theorem rise_antitone_le (pos : 0 < a) (favoured : b ≤ a) {i : Nat} :
    ∀ {j}, i ≤ j → rise M a b j ≤ rise M a b i
  | _, .refl => Nat.le_refl _
  | _ + 1, .step le => Nat.le_trans (rise_antitone pos favoured _) (rise_antitone_le pos favoured le)

/-- With steps that do not grow, the potential rises from `i` over `t` more counts by at most `t`
of the step at `i` (`potentialBy_tail`). -/
theorem potential_above (pos : 0 < a) (favoured : b ≤ a) (i : Nat) :
    ∀ t, potential M a b (i + t) ≤ potential M a b i + t * rise M a b i :=
  potentialBy_tail fun _ le => rise_antitone_le pos favoured le

/-- And from `s`, over `j` more counts, by at least `j` of the step at `s + j`. -/
theorem potential_from (pos : 0 < a) (favoured : b ≤ a) (s : Nat) :
    ∀ j, potential M a b s + j * rise M a b (s + j) ≤ potential M a b (s + j)
  | 0 => Nat.le_of_eq (by rw [Nat.zero_mul]; rfl)
  | j + 1 => by
    show _ ≤ potential M a b (s + j) + rise M a b (s + j)
    rw [Nat.succ_mul, ← Nat.add_assoc]
    exact Nat.add_le_add (Nat.le_trans (Nat.add_le_add_left (Nat.mul_le_mul_left j
      (rise_antitone pos favoured (s + j))) _) (potential_from pos favoured s j))
      (rise_antitone pos favoured (s + j))

/-- **The favoured kind fixes with at least its starting share.** Where `b ≤ a` and `a` is
positive, `i` times the potential at the top is at most `M + 1` times the potential at `i`: the
fixation share is at least `i / (M + 1)`, with equality where `a = b`. -/
theorem favoured_share (pos : 0 < a) (favoured : b ≤ a) {i t : Nat} (top : i + t = M + 1) :
    i * potential M a b (M + 1) ≤ (M + 1) * potential M a b i := by
  have below := potential_from (M := M) pos favoured 0 i
  rw [Nat.zero_add] at below
  have lower : i * rise M a b i ≤ potential M a b i :=
    Nat.le_trans (Nat.le_add_left _ _) below
  rw [← top]
  exact Nat.le_trans (Nat.mul_le_mul_left i (potential_above pos favoured i t))
    (Nat.le_trans (Nat.le_of_eq (by rw [Nat.left_distrib, mul_turn i t]))
      (Nat.le_trans (Nat.add_le_add_left (Nat.mul_le_mul_left t lower) _)
        (Nat.le_of_eq (add_mul_split i t _).symm)))

/-- Without selection in the draw the fixation share is the starting share. -/
theorem neutral_share {i : Nat} (le : i ≤ M + 1) :
    i * potential M a a (M + 1) = (M + 1) * potential M a a i := by
  rw [potential_neutral (M + 1) (Nat.le_refl _), potential_neutral i le, mul_turn i (M + 1)]

/-- **And strictly above it where it is favoured.** Where `b < a`, from a mixed start `i` of
`M + 1`, `i` times the potential at the top is below `M + 1` times the potential at `i`. -/
theorem favoured_share_above (favoured : b < a) {i t : Nat} (start : 0 < i) (rest : 0 < t)
    (top : i + t = M + 1) :
    i * potential M a b (M + 1) < (M + 1) * potential M a b i := by
  have pos : 0 < a := Nat.lt_of_le_of_lt (Nat.zero_le b) favoured
  have le := Nat.le_of_lt favoured
  obtain ⟨j, rfl⟩ : ∃ j, i = j + 1 := ⟨i - 1, (Nat.succ_pred_eq_of_pos start).symm⟩
  have one_le : 1 ≤ M := Nat.le_of_succ_le_succ (Nat.le_trans (Nat.add_le_add (Nat.le_add_left 1 j) rest)
    (Nat.le_of_eq top))
  have r0 : rise M a b 0 = a ^ M := by
    rw [rise_closed]
    rw [if_pos (Nat.zero_le M), Nat.pow_zero, Nat.one_mul, Nat.sub_zero]
  have r0pos : 0 < rise M a b 0 := r0 ▸ one_le_pow pos M
  have r1 : rise M a b 1 < rise M a b 0 :=
    Naturals.lt_of_mul_lt_mul_left (Nat.lt_of_le_of_lt (Nat.le_of_eq (rise_step (Nat.lt_of_lt_of_le Nat.zero_lt_one one_le)))
      (Nat.mul_lt_mul_of_pos_right favoured r0pos))
  have strict : (j + 1) * rise M a b (j + 1) < potential M a b (j + 1) := by
    have from1 := potential_from (M := M) pos le 1 j
    rw [Nat.add_comm 1 j] at from1
    have p1 : potential M a b 1 = rise M a b 0 := Nat.zero_add _
    rw [p1] at from1
    rw [Nat.succ_mul]
    have h1 : rise M a b (j + 1) ≤ rise M a b 1 := rise_antitone_le pos le (Nat.le_add_left 1 j)
    exact Nat.lt_of_lt_of_le (Nat.add_lt_add_left (Nat.lt_of_le_of_lt h1 r1) _)
      (Nat.le_trans (Nat.le_of_eq (Nat.add_comm _ _)) from1)
  rw [← top]
  exact Nat.lt_of_le_of_lt (Nat.mul_le_mul_left (j + 1) (potential_above pos le (j + 1) t))
    (Nat.lt_of_lt_of_le (by
      rw [Nat.left_distrib, mul_turn (j + 1) t]
      exact Nat.add_lt_add_left (Nat.mul_lt_mul_of_pos_left strict rest) _)
      (Nat.le_of_eq (add_mul_split (j + 1) t _).symm))

/-- **Never ruled out.** From `i` mixed or none, the histories losing the favoured kind weigh at
least `b ^ i` times every later history: a lineage of `i` steps down. -/
theorem lost_ge (k : Nat) : ∀ i, i ≤ M → b ^ i * (a + b) ^ k ≤ value M a b lost (k + i) i :=
  lost_geBy (fun _ _ => Nat.le_refl b) k

end Replacement

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

namespace Favoured

/-- Two members, one of each kind, each step up weighing two and each down one: the potential is two
at one and three at the top, so the first kind fixes with share two of three, above its starting
share of a half; over one round of two steps the histories fixing it weigh six of nine and none
stays varied. -/
theorem two_members :
    Replacement.potential 1 2 1 1 = 2 ∧ Replacement.potential 1 2 1 2 = 3 ∧
      Replacement.value 1 2 1 (Replacement.fixed 1) 2 1 = 6 ∧
      Replacement.value 1 2 1 (Replacement.varied 1) 2 1 = 0 ∧ 1 * 3 < 2 * 2 :=
  ⟨rfl, rfl, rfl, rfl, by decide⟩

end Favoured

end Drift

end Becoming
