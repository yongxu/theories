import Becoming.ConditionalWeights
import Becoming.Flow

/-!
# The free-energy bound in counting form

Variational free energy bounds a record's surprisal, with equality exactly at the posterior
(Gibbs' inequality; the periphery's `FreeEnergyReals`, board item UE17). For a belief whose shares
are natural counts `n` over listed hypotheses, with total `N`, and natural joint weights `a`, with
total `A`, the bound exponentiated reads

  `N ^ N * ∏ a ^ n ≤ A ^ N * ∏ n ^ n`,

with no logarithm. This module proves it in the pure core, with its case of equality
(board item UE21).

* **The arithmetic–geometric mean inequality in counts.** From a Bernoulli-type inequality,
  `(k + 1) * x * y ^ k ≤ x ^ (k + 1) + k * y ^ (k + 1)` (`bernoulli`, by rearrangement,
  `rearrange`), one more term joins a mean (`mean_step`), so `n` copies of `x` and `m` copies of
  `y` have `(n + m) ^ (n + m) * (x ^ n * y ^ m) ≤ (n * x + m * y) ^ (n + m)` (`mean_two`), and two
  parts with counts `n`, `m` and weights `a`, `b` have
  `(n + m) ^ (n + m) * (a ^ n * b ^ m) ≤ (a + b) ^ (n + m) * (n ^ n * m ^ m)` (`two_parts`). Each
  is strict away from equality (`bernoulli_strict`, `mean_step_strict`, `mean_two_strict`,
  `two_parts_strict`), and two parts reach the bound only where `n * b = a * m`
  (`proportional_of_two_parts_eq`).
* **The bound** (`bound`): over any listed hypotheses, with `total` the core's sum over a listing
  and `powerProduct a n` the product of each `a ^ n`. It holds with no support condition: a count
  where the joint weight is nothing makes the left side nothing, as the free energy is infinite
  there as usually defined, and the bound is strict (`Witness.off_support`). Under Mathlib's
  `log 0 = 0` the real form of the periphery module `FreeEnergyReals` is at equality at that
  witness, and fails at counts one and one against the same weights, so off the support the two
  modules' laws are not one law.
* **Equality exactly in proportion** (`bound_eq_iff`): the bound holds with equality exactly where
  the counts are proportional to the weights, `n h * A = a h * N` at every listed hypothesis
  (`bound_eq_of_proportional`, `proportional_of_bound_eq`), and away from proportion it is strict
  (`bound_lt_of_not_proportional`; `Witness.strict_off_proportion`; scaled counts reach it,
  `Witness.scaled_reach`). Where every weight is nothing, or every count, both sides agree for a
  degenerate reason (`zero_weights_reach`, `no_counts_reach`); at one total the bound may be
  reached by no count belief (`Witness.total_two_unreached`).
* **Joined to the core's generative model** (`bound_given_record`): with the joint weight of a
  hypothesis its prior weight times the record's weight under it, the total is the record's weight
  (`record_total`, from `ConditionalWeights.evidence`), and the count beliefs at the bound are
  exactly those in proportion to the joint weights (`given_record_eq_iff`, `posterior_counts_reach`);
  with the hypotheses listed once, exactly those whose every count over the total is the same
  ratio as the hypothesis's share given the record (`given_record_eq_iff_share`, through
  `ConditionalWeights.posterior_single`; `Witness.duplicate_share` without). Where the record weighs
  nothing every count belief is at the bound, the share given it being `⟨0, 0⟩`, the same ratio as
  any (`nothing_record_reach_all`, `Witness.nothing_record_reach`,
  `ConditionalWeights.Share.zero_whole`).

**Modelling choices.** Natural counts and weights, listed hypotheses, `0 ^ 0 = 1`; a belief with
natural counts stands for the shares `n h / N`. The inequality is the free-energy bound for such a
belief, with a positive total, after taking logarithms, which this module does not take, and agrees
with UE17's real form on the support; the record's weight here is the total `E`, where the periphery reads the joint
weights as shares of the whole weight, both bounds then shifting by its logarithm. **Standing:** in
counts the bound is Cauchy's arithmetic–geometric mean inequality (1821), a count being a
repetition, with its case of equality; read with `a / A` as a model and `n` as observed counts it
says that the observed frequencies maximize the multinomial likelihood (the method of types). Both
readings are classical; the counting form and its join are near-definitional; new is that the
principle's central bound, with its equality, holds in the pure core. Every declaration has an
empty axiom report. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace FreeEnergyCounting

open ConditionalWeights

/-! ## Arithmetic in counts

The prelude's `Nat.mul_pow` and `Nat.pow_lt_pow_left` use `propext`, and
`Nat.lt_of_mul_lt_mul_left` also `Classical.choice` and `Quot.sound`, in this version of Lean, so
those laws are proved here; the rest of the arithmetic uses axiom-free laws of the prelude
(`Nat.eq_of_mul_eq_mul_left`, `Nat.eq_of_mul_eq_mul_right`, `Nat.mul_lt_mul_of_pos_left`,
`Nat.mul_lt_mul_of_pos_right`, `Nat.lt_of_add_lt_add_left`, `Nat.mul_eq_zero`) and of the core
(`Naturals.pow_add`, `Naturals.mul_right_comm`, the cancellations, `total_zero`). -/

/-- A count to its own power is positive (`0 ^ 0 = 1`). -/
theorem self_pow_pos : ∀ n : Nat, 0 < n ^ n
  | 0 => Nat.zero_lt_one
  | n + 1 => Nat.pow_pos (Nat.succ_pos n)

theorem lt_cancel_mul_left {a b c : Nat} (lt : c * a < c * b) : a < b :=
  match Nat.lt_or_ge a b with
  | .inl ab => ab
  | .inr ba => absurd lt (Nat.not_lt_of_le (Nat.mul_le_mul_left c ba))

theorem base_zero_of_pow_zero {p c : Nat} (zero : p ^ c = 0) : p = 0 :=
  match p, zero with
  | 0, _ => rfl
  | p + 1, zero => absurd (zero ▸ Nat.pow_pos (n := c) (Nat.succ_pos p)) (Nat.lt_irrefl 0)

theorem pow_succ_lt_pow_succ {x y : Nat} (xy : x < y) : ∀ j : Nat, x ^ (j + 1) < y ^ (j + 1)
  | 0 => Nat.mul_lt_mul_of_pos_left xy Nat.zero_lt_one
  | j + 1 => Nat.lt_of_le_of_lt (Nat.mul_le_mul_left _ (Nat.le_of_lt xy))
      (Nat.mul_lt_mul_of_pos_right (pow_succ_lt_pow_succ xy j) (Nat.lt_of_le_of_lt (Nat.zero_le x) xy))

/-! ## Rearrangement and a Bernoulli-type inequality -/

/-- **Rearrangement in counts**: pairing the larger with the larger gives at least as much. -/
theorem rearrange {a b c d : Nat} (ab : a ≤ b) (cd : c ≤ d) : a * d + b * c ≤ a * c + b * d :=
  match exists_add_of_le ab with
  | ⟨e, be⟩ => by
    subst be
    rw [add_mul_split, add_mul_split]
    exact Nat.le_trans
      (Nat.add_le_add_left (Nat.add_le_add_right (Nat.mul_le_mul_left e cd) _) _)
      (Nat.le_of_eq ((congrArg (a * d + ·) (Nat.add_comm _ _)).trans
        ((Nat.add_left_comm _ _ _).trans (congrArg (a * c + ·) (Nat.add_comm _ _)))))

/-- Rearrangement is strict where both pairs are apart. -/
theorem rearrange_strict {a b c d : Nat} (ab : a < b) (cd : c < d) : a * d + b * c < a * c + b * d :=
  match exists_add_of_le ab with
  | ⟨k, bk⟩ => by
    subst bk
    rw [show k + (a + 1) = (k + 1) + a from (Nat.succ_add k a).symm, add_mul_split (k + 1) a c,
      add_mul_split (k + 1) a d]
    exact Nat.lt_of_lt_of_le
      (Nat.add_lt_add_left (Nat.add_lt_add_right (Nat.mul_lt_mul_of_pos_left cd (Nat.succ_pos k)) _) _)
      (Nat.le_of_eq ((congrArg (a * d + ·) (Nat.add_comm _ _)).trans
        ((Nat.add_left_comm _ _ _).trans (congrArg (a * c + ·) (Nat.add_comm _ _)))))

/-- Two powers rearranged: `x ^ j * y + x * y ^ j ≤ x ^ (j + 1) + y ^ (j + 1)`. -/
theorem powers_rearrange (x y j : Nat) : x ^ j * y + x * y ^ j ≤ x ^ (j + 1) + y ^ (j + 1) :=
  match Nat.le_total x y with
  | .inl xy =>
    Nat.le_trans (Nat.le_of_eq ((Nat.add_comm _ _).trans (congrArg (x * y ^ j + ·) (Nat.mul_comm _ _))))
      (Nat.le_trans (rearrange xy (Nat.pow_le_pow_left xy j))
        (Nat.le_of_eq (congr (congrArg (· + ·) (Nat.mul_comm x (x ^ j))) (Nat.mul_comm y (y ^ j)))))
  | .inr yx =>
    Nat.le_trans (Nat.le_of_eq (congrArg (· + x * y ^ j) (Nat.mul_comm _ _)))
      (Nat.le_trans (rearrange yx (Nat.pow_le_pow_left yx j))
        (Nat.le_of_eq ((Nat.add_comm _ _).trans
          (congr (congrArg (· + ·) (Nat.mul_comm x (x ^ j))) (Nat.mul_comm y (y ^ j))))))

/-- Two distinct counts' powers rearranged strictly, for a positive power. -/
theorem powers_rearrange_strict (x y j : Nat) (ne : x ≠ y) :
    x ^ (j + 1) * y + x * y ^ (j + 1) < x ^ (j + 1 + 1) + y ^ (j + 1 + 1) :=
  match Nat.lt_or_ge x y with
  | .inl xy =>
    Nat.lt_of_le_of_lt
      (Nat.le_of_eq ((Nat.add_comm _ _).trans (congrArg (x * y ^ (j + 1) + ·) (Nat.mul_comm _ _))))
      (Nat.lt_of_lt_of_le (rearrange_strict xy (pow_succ_lt_pow_succ xy j))
        (Nat.le_of_eq (congr (congrArg (· + ·) (Nat.mul_comm x (x ^ (j + 1))))
          (Nat.mul_comm y (y ^ (j + 1))))))
  | .inr yx =>
    have xy : y < x := Nat.lt_of_le_of_ne yx (fun eq => ne eq.symm)
    Nat.lt_of_le_of_lt (Nat.le_of_eq (congrArg (· + x * y ^ (j + 1)) (Nat.mul_comm _ _)))
      (Nat.lt_of_lt_of_le (rearrange_strict xy (pow_succ_lt_pow_succ xy j))
        (Nat.le_of_eq ((Nat.add_comm _ _).trans
          (congr (congrArg (· + ·) (Nat.mul_comm x (x ^ (j + 1)))) (Nat.mul_comm y (y ^ (j + 1)))))))

theorem bernoulli_split (x y k : Nat) :
    (k + 1 + 1) * x * y ^ (k + 1) = (k + 1) * x * y ^ k * y + x * y ^ (k + 1) := by
  rw [add_mul_split (k + 1) 1 x, add_mul_split ((k + 1) * x) (1 * x), Nat.one_mul]
  exact congrArg (· + x * y ^ (k + 1)) (mul_assoc_nat _ _ _).symm

theorem bernoulli_regroup (x y k : Nat) :
    (x ^ (k + 1) + k * y ^ (k + 1)) * y + x * y ^ (k + 1) =
      x ^ (k + 1) * y + x * y ^ (k + 1) + k * y ^ (k + 1 + 1) :=
  (congrArg (· + x * y ^ (k + 1)) ((add_mul_split _ _ y).trans
    (congrArg (x ^ (k + 1) * y + ·) (mul_assoc_nat k _ y)))).trans (Nat.add_right_comm _ _ _)

theorem bernoulli_close (x y k : Nat) :
    x ^ (k + 1 + 1) + y ^ (k + 1 + 1) + k * y ^ (k + 1 + 1) = x ^ (k + 1 + 1) + (k + 1) * y ^ (k + 1 + 1) :=
  (Nat.add_assoc _ _ _).trans (congrArg (x ^ (k + 1 + 1) + ·) ((Nat.add_comm _ _).trans
    ((congrArg (k * y ^ (k + 1 + 1) + ·) (Nat.one_mul _).symm).trans (add_mul_split k 1 _).symm)))

/-- **A Bernoulli-type inequality in counts**: `(k + 1) * x * y ^ k ≤ x ^ (k + 1) + k * y ^ (k + 1)`,
the arithmetic–geometric mean inequality for `k` copies of `y ^ (k + 1)` and one of
`x ^ (k + 1)`. -/
theorem bernoulli (x y : Nat) : ∀ k : Nat, (k + 1) * x * y ^ k ≤ x ^ (k + 1) + k * y ^ (k + 1)
  | 0 => Nat.le_of_eq ((Nat.mul_one _).trans ((Nat.add_zero _).symm.trans
      (congrArg (1 * x + ·) (Nat.zero_mul _).symm)))
  | k + 1 =>
    Nat.le_trans (Nat.le_of_eq (bernoulli_split x y k))
      (Nat.le_trans (Nat.add_le_add_right (Nat.mul_le_mul_right y (bernoulli x y k)) _)
        (Nat.le_trans (Nat.le_of_eq (bernoulli_regroup x y k))
          (Nat.le_trans (Nat.add_le_add_right (powers_rearrange x y (k + 1)) _)
            (Nat.le_of_eq (bernoulli_close x y k)))))

/-- The Bernoulli-type inequality is strict for two distinct counts and a positive `k`. -/
theorem bernoulli_strict (x y : Nat) (ne : x ≠ y) :
    ∀ k : Nat, 0 < k → (k + 1) * x * y ^ k < x ^ (k + 1) + k * y ^ (k + 1)
  | 0, pos => absurd pos (Nat.lt_irrefl 0)
  | k + 1, _ =>
    Nat.lt_of_le_of_lt (Nat.le_of_eq (bernoulli_split x y k))
      (Nat.lt_of_le_of_lt (Nat.add_le_add_right (Nat.mul_le_mul_right y (bernoulli x y k)) _)
        (Nat.lt_of_le_of_lt (Nat.le_of_eq (bernoulli_regroup x y k))
          (Nat.lt_of_lt_of_le (Nat.add_lt_add_right (powers_rearrange_strict x y k ne) _)
            (Nat.le_of_eq (bernoulli_close x y k)))))

/-! ## The arithmetic–geometric mean inequality in counts -/

/-- The product identity behind `mean_step`. -/
theorem mean_step_identity (k S y : Nat) :
    (k + 1) * (k * (S + y)) * ((k + 1) * S) ^ k = k * ((k + 1) ^ (k + 1) * S ^ k) * (S + y) := by
  rw [Naturals.mul_pow_eq (k + 1) S k]
  calc (k + 1) * (k * (S + y)) * ((k + 1) ^ k * S ^ k)
      = k * ((k + 1) * (S + y)) * ((k + 1) ^ k * S ^ k) :=
        congrArg (· * ((k + 1) ^ k * S ^ k)) (mul_turn _ _ _)
    _ = k * ((k + 1) * (S + y) * ((k + 1) ^ k * S ^ k)) := mul_assoc_nat _ _ _
    _ = k * ((k + 1) ^ k * (k + 1) * (S ^ k * (S + y))) :=
        congrArg (k * ·) ((Naturals.mul_mul_mul_comm _ _ _ _).trans
          ((congrArg (· * ((S + y) * S ^ k)) (Nat.mul_comm (k + 1) ((k + 1) ^ k))).trans
            (congrArg ((k + 1) ^ k * (k + 1) * ·) (Nat.mul_comm (S + y) (S ^ k)))))
    _ = k * ((k + 1) ^ (k + 1) * S ^ k * (S + y)) := congrArg (k * ·) (mul_assoc_nat _ _ _).symm
    _ = k * ((k + 1) ^ (k + 1) * S ^ k) * (S + y) := (mul_assoc_nat _ _ _).symm

theorem mean_step_lhs (S y k : Nat) :
    (k + 1 + 1) * ((k + 1) * (S + y)) * ((k + 1 + 1) * S) ^ (k + 1) =
      (k + 1) * ((k + 1 + 1) ^ (k + 1 + 1) * S ^ (k + 1)) * S +
        (k + 1) * ((k + 1 + 1) ^ (k + 1 + 1) * S ^ (k + 1) * y) :=
  (mean_step_identity (k + 1) S y).trans ((Nat.left_distrib _ S y).trans
    (congrArg ((k + 1) * ((k + 1 + 1) ^ (k + 1 + 1) * S ^ (k + 1)) * S + ·) (mul_assoc_nat _ _ _)))

theorem mean_step_rhs (S y k : Nat) :
    ((k + 1) * (S + y)) ^ (k + 1 + 1) + (k + 1) * ((k + 1 + 1) * S) ^ (k + 1 + 1) =
      (k + 1) * ((k + 1 + 1) ^ (k + 1 + 1) * S ^ (k + 1)) * S +
        (k + 1) * ((k + 1) ^ (k + 1) * (S + y) ^ (k + 1 + 1)) :=
  (Nat.add_comm _ _).trans (congr (congrArg (· + ·)
    ((congrArg ((k + 1) * ·) ((Naturals.mul_pow_eq (k + 1 + 1) S (k + 1 + 1)).trans
      (mul_assoc_nat ((k + 1 + 1) ^ (k + 1 + 1)) (S ^ (k + 1)) S).symm)).trans
      (mul_assoc_nat (k + 1) ((k + 1 + 1) ^ (k + 1 + 1) * S ^ (k + 1)) S).symm))
    ((Naturals.mul_pow_eq (k + 1) (S + y) (k + 1 + 1)).trans
      ((Naturals.mul_right_comm ((k + 1) ^ (k + 1)) (k + 1) ((S + y) ^ (k + 1 + 1))).trans
        (Nat.mul_comm _ _))))

/-- **One more term joins a mean**: `(k + 1) ^ (k + 1) * S ^ k * y ≤ k ^ k * (S + y) ^ (k + 1)`, the
arithmetic–geometric mean inequality's step from `k` terms totalling `S` to one more term `y`
(`bernoulli` at `k * (S + y)` and `(k + 1) * S`). -/
theorem mean_step (S y : Nat) : ∀ k : Nat, (k + 1) ^ (k + 1) * S ^ k * y ≤ k ^ k * (S + y) ^ (k + 1)
  | 0 => Nat.le_trans (Nat.le_of_eq (Nat.one_mul y))
      (Nat.le_trans (Nat.le_add_left y S)
        (Nat.le_of_eq ((Nat.one_mul (S + y)).symm.trans (Nat.one_mul _).symm)))
  | k + 1 =>
    Nat.le_of_mul_le_mul_left (Naturals.le_of_add_le_add_left (Nat.le_trans
      (Nat.le_of_eq (mean_step_lhs S y k).symm)
      (Nat.le_trans (bernoulli ((k + 1) * (S + y)) ((k + 1 + 1) * S) (k + 1))
        (Nat.le_of_eq (mean_step_rhs S y k))))) (Nat.succ_pos k)

/-- The step is strict where the new term is not the mean of the others: `k * y ≠ S`. -/
theorem mean_step_strict (S y : Nat) :
    ∀ k : Nat, 0 < k → k * y ≠ S → (k + 1) ^ (k + 1) * S ^ k * y < k ^ k * (S + y) ^ (k + 1)
  | 0, pos, _ => absurd pos (Nat.lt_irrefl 0)
  | k + 1, _, ne =>
    have apart : (k + 1) * (S + y) ≠ (k + 1 + 1) * S := fun eq => ne (Naturals.add_left_cancel
      ((Nat.left_distrib (k + 1) S y).symm.trans (eq.trans ((add_mul_split (k + 1) 1 S).trans
        (congrArg ((k + 1) * S + ·) (Nat.one_mul S))))))
    lt_cancel_mul_left (Nat.lt_of_add_lt_add_left (Nat.lt_of_le_of_lt
      (Nat.le_of_eq (mean_step_lhs S y k).symm)
      (Nat.lt_of_lt_of_le (bernoulli_strict _ _ apart (k + 1) (Nat.succ_pos k))
        (Nat.le_of_eq (mean_step_rhs S y k)))))

theorem mean_two_sum (n m x y : Nat) : n * x + m * y + y = n * x + (m + 1) * y :=
  (Nat.add_assoc _ _ _).trans (congrArg (n * x + ·)
    ((congrArg (m * y + ·) (Nat.one_mul y).symm).trans (add_mul_split m 1 y).symm))

theorem mean_two_ident (K A X Y y : Nat) : K * (A * (X * (Y * y))) = A * (K * (X * Y)) * y :=
  (mul_turn _ _ _).trans ((congrArg (A * ·)
    ((congrArg (K * ·) (mul_assoc_nat X Y y).symm).trans (mul_assoc_nat K (X * Y) y).symm)).trans
    (mul_assoc_nat _ _ y).symm)

/-- **The arithmetic–geometric mean inequality for two values in counts**: `n` copies of `x` and
`m` copies of `y` have `(n + m) ^ (n + m) * (x ^ n * y ^ m) ≤ (n * x + m * y) ^ (n + m)`. -/
theorem mean_two (n x y : Nat) :
    ∀ m : Nat, (n + m) ^ (n + m) * (x ^ n * y ^ m) ≤ (n * x + m * y) ^ (n + m)
  | 0 => Nat.le_of_eq (((congrArg (n ^ n * ·) (Nat.mul_one (x ^ n))).trans (Naturals.mul_pow_eq n x n).symm).trans
      ((congrArg (· ^ n) (Nat.add_zero (n * x)).symm).trans
        (congrArg (fun z => (n * x + z) ^ n) (Nat.zero_mul y).symm)))
  | m + 1 =>
    Nat.le_of_mul_le_mul_left (c := (n + m) ^ (n + m))
      (Nat.le_trans (Nat.le_of_eq (mean_two_ident _ _ (x ^ n) (y ^ m) y))
        (Nat.le_trans (Nat.mul_le_mul_right y (Nat.mul_le_mul_left _ (mean_two n x y m)))
          (Nat.le_trans (mean_step (n * x + m * y) y (n + m))
            (Nat.le_of_eq (congrArg (fun z => (n + m) ^ (n + m) * z ^ (n + m + 1))
              (mean_two_sum n m x y))))))
      (self_pow_pos (n + m))

/-- Two values in counts, strictly: with `n` positive and `x ≠ y`, one or more copies of `y`
keep the mean inequality strict. -/
theorem mean_two_strict (n x y : Nat) (npos : 0 < n) (ne : x ≠ y) (m : Nat) :
    (n + (m + 1)) ^ (n + (m + 1)) * (x ^ n * y ^ (m + 1)) < (n * x + (m + 1) * y) ^ (n + (m + 1)) :=
  have apart : (n + m) * y ≠ n * x + m * y := fun eq => ne (Nat.eq_of_mul_eq_mul_left npos
    (add_right_cancel _ ((add_mul_split n m y).symm.trans eq))).symm
  lt_cancel_mul_left (c := (n + m) ^ (n + m))
    (Nat.lt_of_le_of_lt (Nat.le_of_eq (mean_two_ident _ _ (x ^ n) (y ^ m) y))
      (Nat.lt_of_le_of_lt (Nat.mul_le_mul_right y (Nat.mul_le_mul_left _ (mean_two n x y m)))
        (Nat.lt_of_lt_of_le (mean_step_strict (n * x + m * y) y (n + m)
            (Nat.lt_of_lt_of_le npos (Nat.le_add_right n m)) apart)
          (Nat.le_of_eq (congrArg (fun z => (n + m) ^ (n + m) * z ^ (n + m + 1))
            (mean_two_sum n m x y))))))

/-! ## Two parts -/

theorem two_parts_lhs (a b n m : Nat) :
    (n + m) ^ (n + m) * ((a * m) ^ n * (b * n) ^ m) =
      (n + m) ^ (n + m) * (a ^ n * b ^ m) * (m ^ n * n ^ m) :=
  (congrArg ((n + m) ^ (n + m) * ·)
    ((congr (congrArg (· * ·) (Naturals.mul_pow_eq a m n)) (Naturals.mul_pow_eq b n m)).trans
      (Naturals.mul_mul_mul_comm (a ^ n) (m ^ n) (b ^ m) (n ^ m)))).trans
    (mul_assoc_nat _ _ _).symm

theorem two_parts_rhs (a b n m : Nat) :
    (n * (a * m) + m * (b * n)) ^ (n + m) = (a + b) ^ (n + m) * (n ^ n * m ^ m) * (m ^ n * n ^ m) :=
  have sum : n * (a * m) + m * (b * n) = n * m * (a + b) :=
    (congr (congrArg (· + ·)
      ((congrArg (n * ·) (Nat.mul_comm a m)).trans (mul_assoc_nat n m a).symm))
      ((congrArg (m * ·) (Nat.mul_comm b n)).trans
        ((mul_assoc_nat m n b).symm.trans (congrArg (· * b) (Nat.mul_comm m n))))).trans
      (Nat.left_distrib (n * m) a b).symm
  have four : n ^ n * n ^ m * (m ^ n * m ^ m) = n ^ n * m ^ m * (m ^ n * n ^ m) :=
    (congrArg (n ^ n * n ^ m * ·) (Nat.mul_comm (m ^ n) (m ^ m))).trans
      ((Naturals.mul_mul_mul_comm _ _ _ _).trans
        (congrArg (n ^ n * m ^ m * ·) (Nat.mul_comm (n ^ m) (m ^ n))))
  (congrArg (· ^ (n + m)) sum).trans
    ((Naturals.mul_pow_eq (n * m) (a + b) (n + m)).trans
      ((congrArg (· * (a + b) ^ (n + m))
        ((Naturals.mul_pow_eq n m (n + m)).trans
          ((congr (congrArg (· * ·) (Naturals.pow_add n n m)) (Naturals.pow_add m n m)).trans four))).trans
        ((Nat.mul_comm _ _).trans (mul_assoc_nat _ _ _).symm)))

/-- **Two parts**: with counts `n`, `m` and weights `a`, `b`,
`(n + m) ^ (n + m) * (a ^ n * b ^ m) ≤ (a + b) ^ (n + m) * (n ^ n * m ^ m)`; from `mean_two` at
`a * m` and `b * n`. -/
theorem two_parts (a b : Nat) :
    ∀ n m : Nat, (n + m) ^ (n + m) * (a ^ n * b ^ m) ≤ (a + b) ^ (n + m) * (n ^ n * m ^ m)
  | 0, m => by
    rw [Nat.zero_add]
    exact Nat.le_trans (Nat.le_of_eq (congrArg (m ^ m * ·) (Nat.one_mul (b ^ m))))
      (Nat.le_trans (Nat.mul_le_mul_left _ (Nat.pow_le_pow_left (Nat.le_add_left b a) m))
        (Nat.le_of_eq ((Nat.mul_comm _ _).trans (congrArg ((a + b) ^ m * ·) (Nat.one_mul _).symm))))
  | n + 1, 0 =>
    Nat.le_trans (Nat.le_of_eq (congrArg ((n + 1) ^ (n + 1) * ·) (Nat.mul_one (a ^ (n + 1)))))
      (Nat.le_trans (Nat.mul_le_mul_left _ (Nat.pow_le_pow_left (Nat.le_add_right a b) (n + 1)))
        (Nat.le_of_eq ((Nat.mul_comm _ _).trans
          (congrArg ((a + b) ^ (n + 1) * ·) (Nat.mul_one _).symm))))
  | n + 1, m + 1 =>
    Nat.le_of_mul_le_mul_right (Nat.le_trans (Nat.le_of_eq (two_parts_lhs a b (n + 1) (m + 1)).symm)
      (Nat.le_trans (mean_two (n + 1) (a * (m + 1)) (b * (n + 1)) (m + 1))
        (Nat.le_of_eq (two_parts_rhs a b (n + 1) (m + 1)))))
      (Nat.mul_pos (Nat.pow_pos (Nat.succ_pos m)) (Nat.pow_pos (Nat.succ_pos n)))

/-- Two parts with positive counts are strictly below the bound unless `a * m = b * n`. -/
theorem two_parts_strict (a b : Nat) (n m : Nat) (ne : a * (m + 1) ≠ b * (n + 1)) :
    (n + 1 + (m + 1)) ^ (n + 1 + (m + 1)) * (a ^ (n + 1) * b ^ (m + 1)) <
      (a + b) ^ (n + 1 + (m + 1)) * ((n + 1) ^ (n + 1) * (m + 1) ^ (m + 1)) :=
  Naturals.lt_of_mul_lt_mul_right (v := (m + 1) ^ (n + 1) * (n + 1) ^ (m + 1))
    (Nat.lt_of_le_of_lt (Nat.le_of_eq (two_parts_lhs a b (n + 1) (m + 1)).symm)
      (Nat.lt_of_lt_of_le (mean_two_strict (n + 1) (a * (m + 1)) (b * (n + 1)) (Nat.succ_pos n) ne m)
        (Nat.le_of_eq (two_parts_rhs a b (n + 1) (m + 1)))))

/-- **Two parts reach the bound only in proportion**: equality forces `n * b = a * m`. -/
theorem proportional_of_two_parts_eq (a b : Nat) :
    ∀ n m : Nat, (n + m) ^ (n + m) * (a ^ n * b ^ m) = (a + b) ^ (n + m) * (n ^ n * m ^ m) →
      n * b = a * m
  | 0, 0, _ => (Nat.zero_mul b).trans (Nat.mul_zero a).symm
  | 0, m + 1, eq =>
    match a, eq with
    | 0, _ => (Nat.zero_mul b).trans (Nat.zero_mul _).symm
    | a + 1, eq => absurd (by
        rw [Nat.zero_add] at eq
        exact eq) (Nat.ne_of_lt (Nat.lt_of_le_of_lt
          (Nat.le_of_eq (congrArg ((m + 1) ^ (m + 1) * ·) (Nat.one_mul (b ^ (m + 1)))))
          (Nat.lt_of_lt_of_le (Nat.mul_lt_mul_of_pos_left
              (pow_succ_lt_pow_succ (Nat.lt_add_of_pos_left (k := a + 1) (Nat.succ_pos a)) m)
              (self_pow_pos (m + 1)))
            (Nat.le_of_eq ((Nat.mul_comm _ _).trans
              (congrArg ((a + 1 + b) ^ (m + 1) * ·) (Nat.one_mul _).symm))))))
  | n + 1, 0, eq =>
    match b, eq with
    | 0, _ => (Nat.mul_zero _).trans (Nat.mul_zero _).symm
    | b + 1, eq => absurd eq (Nat.ne_of_lt (Nat.lt_of_le_of_lt
        (Nat.le_of_eq (congrArg ((n + 1) ^ (n + 1) * ·) (Nat.mul_one (a ^ (n + 1)))))
        (Nat.lt_of_lt_of_le (Nat.mul_lt_mul_of_pos_left
            (pow_succ_lt_pow_succ (Nat.lt_add_of_pos_right (k := b + 1) (Nat.succ_pos b)) n)
            (self_pow_pos (n + 1)))
          (Nat.le_of_eq ((Nat.mul_comm _ _).trans
            (congrArg ((a + (b + 1)) ^ (n + 1) * ·) (Nat.mul_one _).symm))))))
  | n + 1, m + 1, eq =>
    if h : a * (m + 1) = b * (n + 1) then (Nat.mul_comm _ _).trans h.symm
    else absurd eq (Nat.ne_of_lt (two_parts_strict a b n m h))

/-! ## The bound over listed hypotheses -/


/-- **The product of powers** `∏ a h ^ n h` over a listing. -/
def powerProduct {α : Type} (a n : α → Nat) : List α → Nat
  | [] => 1
  | h :: hs => a h ^ n h * powerProduct a n hs

theorem powerProduct_self_pos {α : Type} (n : α → Nat) : ∀ hs : List α, 0 < powerProduct n n hs
  | [] => Nat.zero_lt_one
  | h :: hs => Nat.mul_pos (self_pow_pos (n h)) (powerProduct_self_pos n hs)

theorem zero_of_total_zero {α : Type} (f : α → Nat) :
    ∀ hs : List α, total hs f = 0 → ∀ h, h ∈ hs → f h = 0
  | [], _ => fun _ mem => nomatch mem
  | _ :: hs, zero => fun h mem => match mem with
    | .head _ => Nat.eq_zero_of_le_zero (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq zero))
    | .tail _ mem' => zero_of_total_zero f hs (Nat.eq_zero_of_le_zero
        (Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq zero))) h mem'

theorem cons_left (K X Y P : Nat) : K * (X * (Y * P)) = X * Y * (K * P) :=
  (mul_turn _ _ _).trans ((congrArg (X * ·) (mul_turn _ _ _)).trans (mul_assoc_nat _ _ _).symm)

theorem cons_mid (X Y Z Q : Nat) : X * Y * (Z * Q) = X * (Y * Z) * Q :=
  (mul_assoc_nat _ _ _).symm.trans (congrArg (· * Q) (mul_assoc_nat _ _ _))

theorem cons_right (R C K Q : Nat) : R * (C * K) * Q = K * (R * (C * Q)) :=
  (mul_assoc_nat _ _ _).trans ((congrArg (R * ·) ((mul_assoc_nat _ _ _).trans (mul_turn _ _ _))).trans
    (mul_turn _ _ _))

/-- **The free-energy bound in counting form.** For counts `n` and weights `a` over any listed
hypotheses, `N ^ N * ∏ a ^ n ≤ A ^ N * ∏ n ^ n`, with `N` the total count and `A` the total
weight. -/
theorem bound {α : Type} (n a : α → Nat) :
    ∀ hs : List α, total hs n ^ total hs n * powerProduct a n hs ≤ total hs a ^ total hs n * powerProduct n n hs
  | [] => Nat.le_refl _
  | h :: hs =>
    Nat.le_of_mul_le_mul_left (c := total hs n ^ total hs n)
      (Nat.le_trans (Nat.le_of_eq (cons_left _ _ _ _))
        (Nat.le_trans (Nat.mul_le_mul_left _ (bound n a hs))
          (Nat.le_trans (Nat.le_of_eq (cons_mid _ _ _ _))
            (Nat.le_trans (Nat.mul_le_mul_right _ (two_parts (a h) (total hs a) (n h) (total hs n)))
              (Nat.le_of_eq (cons_right _ _ _ _))))))
      (self_pow_pos (total hs n))

/-- Counts proportional to the weights at fixed totals: where `n h * A = a h * N` at every listed
hypothesis, `N ^ (Σ n) * ∏ a ^ n = A ^ (Σ n) * ∏ n ^ n`. -/
theorem powerProduct_scaled {α : Type} (n a : α → Nat) (A N : Nat) :
    ∀ hs : List α, (∀ h, h ∈ hs → n h * A = a h * N) →
      N ^ total hs n * powerProduct a n hs = A ^ total hs n * powerProduct n n hs
  | [], _ => rfl
  | h :: hs, prop =>
    have here : a h ^ n h * N ^ n h = n h ^ n h * A ^ n h :=
      (Naturals.mul_pow_eq (a h) N (n h)).symm.trans ((congrArg (· ^ n h) (prop h (.head _)).symm).trans
        (Naturals.mul_pow_eq (n h) A (n h)))
    ((congrArg (· * (a h ^ n h * powerProduct a n hs)) (Naturals.pow_add N (n h) (total hs n))).trans
      ((Naturals.mul_mul_mul_comm _ _ _ _).trans
        (congrArg (· * (N ^ total hs n * powerProduct a n hs)) (Nat.mul_comm _ _)))).trans
    ((congr (congrArg (· * ·) here) (powerProduct_scaled n a A N hs (fun g mem => prop g (.tail _ mem)))).trans
      ((congrArg (· * (A ^ total hs n * powerProduct n n hs)) (Nat.mul_comm _ _)).trans
        ((Naturals.mul_mul_mul_comm _ _ _ _).trans
          (congrArg (· * (n h ^ n h * powerProduct n n hs)) (Naturals.pow_add A (n h) (total hs n)).symm))))

/-- **Equality where the counts are proportional to the weights**: `n h * A = a h * N` at every
listed hypothesis gives `N ^ N * ∏ a ^ n = A ^ N * ∏ n ^ n`. -/
theorem bound_eq_of_proportional {α : Type} (n a : α → Nat) (hs : List α)
    (prop : ∀ h, h ∈ hs → n h * total hs a = a h * total hs n) :
    total hs n ^ total hs n * powerProduct a n hs = total hs a ^ total hs n * powerProduct n n hs :=
  powerProduct_scaled n a (total hs a) (total hs n) hs prop

/-- A head in proportion with the rest, and the rest in proportion within itself, make the
whole listing proportional. -/
theorem proportional_cons {α : Type} (n a : α → Nat) (g : α) (hs : List α)
    (rest : ∀ h, h ∈ hs → n h * total hs a = a h * total hs n)
    (head : n g * total hs a = a g * total hs n) :
    ∀ h, h ∈ g :: hs → n h * total (g :: hs) a = a h * total (g :: hs) n := by
  intro h mem
  show n h * (a g + total hs a) = a h * (n g + total hs n)
  cases mem with
  | head _ =>
    rw [Nat.left_distrib, Nat.left_distrib, head, Nat.mul_comm (n g) (a g)]
  | tail _ mem =>
    have cross : n h * a g = a h * n g :=
      match Nat.eq_zero_or_pos (total hs a) with
      | .inr bpos => Nat.eq_of_mul_eq_mul_right bpos
          ((mul_assoc_nat _ _ _).trans ((mul_turn _ _ _).trans
            ((congrArg (a g * ·) (rest h mem)).trans ((mul_turn _ _ _).trans
              ((congrArg (a h * ·) head.symm).trans (mul_assoc_nat _ _ _).symm)))))
      | .inl bzero =>
        have ah : a h = 0 := zero_of_total_zero a hs bzero h mem
        have rhs0 : a h * n g = 0 := by rw [ah, Nat.zero_mul]
        match Nat.mul_eq_zero.mp (head.symm.trans (by rw [bzero, Nat.mul_zero])) with
        | .inl ag => by rw [ag, Nat.mul_zero, rhs0]
        | .inr mzero => by rw [zero_of_total_zero n hs mzero h mem, Nat.zero_mul, rhs0]
    rw [Nat.left_distrib, Nat.left_distrib, cross, rest h mem]

/-- **Equality forces proportion**: where the bound holds with equality, the counts are
proportional to the weights at every listed hypothesis. -/
theorem proportional_of_bound_eq {α : Type} (n a : α → Nat) :
    ∀ hs : List α, total hs n ^ total hs n * powerProduct a n hs = total hs a ^ total hs n * powerProduct n n hs →
      ∀ h, h ∈ hs → n h * total hs a = a h * total hs n
  | [], _ => fun _ mem => nomatch mem
  | g :: hs, eq => by
    have le1 := Nat.mul_le_mul_left ((n g + total hs n) ^ (n g + total hs n) * a g ^ n g) (bound n a hs)
    have le2 := Nat.mul_le_mul_right (powerProduct n n hs) (two_parts (a g) (total hs a) (n g) (total hs n))
    have uz := (cons_left (total hs n ^ total hs n) _ _ _).symm.trans
      ((congrArg (total hs n ^ total hs n * ·) eq).trans (cons_right _ _ _ _).symm)
    have vw := cons_mid ((n g + total hs n) ^ (n g + total hs n)) (a g ^ n g)
      (total hs a ^ total hs n) (powerProduct n n hs)
    have uv := Nat.le_antisymm le1 (Nat.le_trans (Nat.le_of_eq vw) (Nat.le_trans le2 (Nat.le_of_eq uz.symm)))
    have wz := Nat.le_antisymm le2 (Nat.le_trans (Nat.le_of_eq uz.symm) (Nat.le_trans le1 (Nat.le_of_eq vw)))
    have head : n g * total hs a = a g * total hs n :=
      proportional_of_two_parts_eq (a g) (total hs a) (n g) (total hs n) (Nat.eq_of_mul_eq_mul_right (powerProduct_self_pos n hs) wz)
    match Nat.eq_zero_or_pos (a g ^ n g) with
    | .inr ypos =>
      exact proportional_cons n a g hs (proportional_of_bound_eq n a hs
        (Nat.eq_of_mul_eq_mul_left (Nat.mul_pos (self_pow_pos _) ypos) uv)) head
    | .inl yzero =>
      have lhs0 : total (g :: hs) n ^ total (g :: hs) n * powerProduct a n (g :: hs) = 0 := by
        show (n g + total hs n) ^ (n g + total hs n) * (a g ^ n g * powerProduct a n hs) = 0
        rw [yzero, Nat.zero_mul, Nat.mul_zero]
      have azero : total (g :: hs) a = 0 :=
        match Nat.mul_eq_zero.mp (eq.symm.trans lhs0) with
        | .inl pz => base_zero_of_pow_zero pz
        | .inr qz => absurd qz (Nat.ne_of_gt (powerProduct_self_pos n (g :: hs)))
      intro h mem
      rw [azero, zero_of_total_zero a (g :: hs) azero h mem, Nat.mul_zero, Nat.zero_mul]

/-- **The bound is reached exactly in proportion**: `N ^ N * ∏ a ^ n = A ^ N * ∏ n ^ n` exactly
where `n h * A = a h * N` at every listed hypothesis. -/
theorem bound_eq_iff {α : Type} (n a : α → Nat) (hs : List α) :
    total hs n ^ total hs n * powerProduct a n hs = total hs a ^ total hs n * powerProduct n n hs ↔
      ∀ h, h ∈ hs → n h * total hs a = a h * total hs n :=
  ⟨proportional_of_bound_eq n a hs, bound_eq_of_proportional n a hs⟩

/-- **Away from proportion the bound is strict**, for every listing. -/
theorem bound_lt_of_not_proportional {α : Type} (n a : α → Nat) (hs : List α)
    (apart : ¬ ∀ h, h ∈ hs → n h * total hs a = a h * total hs n) :
    total hs n ^ total hs n * powerProduct a n hs < total hs a ^ total hs n * powerProduct n n hs :=
  Nat.lt_of_le_of_ne (bound n a hs) (fun eq => apart ((bound_eq_iff n a hs).1 eq))

/-- **Every weight nothing**: every count belief is at the bound, the proportion holding with
nothing on both sides; there is nothing to be in proportion to. -/
theorem zero_weights_reach {α : Type} (n : α → Nat) (hs : List α) :
    total hs n ^ total hs n * powerProduct (fun _ => 0) n hs =
      total hs (fun _ => 0) ^ total hs n * powerProduct n n hs :=
  (bound_eq_iff n (fun _ => 0) hs).2 fun h _ =>
    (congrArg (n h * ·) (total_zero hs)).trans ((Nat.mul_zero _).trans (Nat.zero_mul _).symm)

/-- **No counts**: with every count nothing both sides are one; no belief is stated. -/
theorem no_counts_reach {α : Type} (a : α → Nat) (hs : List α) :
    total hs (fun _ => 0) ^ total hs (fun _ => 0) * powerProduct a (fun _ => 0) hs =
      total hs a ^ total hs (fun _ => 0) * powerProduct (fun _ => 0) (fun _ => 0) hs :=
  (bound_eq_iff (fun _ => 0) a hs).2 fun h _ =>
    (Nat.zero_mul _).trans ((Nat.mul_zero _).symm.trans (congrArg (a h * ·) (total_zero hs).symm))

/-! ## Joined to the core's generative model -/

/-- **The joint weight of a hypothesis given a record**: its prior weight times the record's
weight under it, the part of its share given the record (`ConditionalWeights.posterior_single`). -/
abbrev joint {α β : Type} (prior : α → Nat) (lik : α → β → Nat) (os : List β) (rec : β → Bool)
    (h : α) : Nat :=
  prior h * mass os (lik h) rec

/-- The record's weight is the total of the joint weights (`ConditionalWeights.evidence`, read
through `ConditionalWeights.mass_eq_total`). -/
theorem record_total {α β : Type} (prior : α → Nat) (lik : α → β → Nat) (hs : List α) (os : List β)
    (rec : β → Bool) :
    mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) = total hs (joint prior lik os rec) :=
  (evidence prior lik hs os rec).trans (mass_eq_total _ _ hs)

/-- **The bound in a generative model of the core**: for counts `n` over the listed hypotheses,
`N ^ N * ∏ joint ^ n ≤ E ^ N * ∏ n ^ n`, `E` the record's weight. -/
theorem bound_given_record {α β : Type} (prior : α → Nat) (lik : α → β → Nat) (hs : List α)
    (os : List β) (rec : β → Bool) (n : α → Nat) :
    total hs n ^ total hs n * powerProduct (joint prior lik os rec) n hs ≤
      mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) ^ total hs n * powerProduct n n hs :=
  Nat.le_trans (bound n (joint prior lik os rec) hs)
    (Nat.le_of_eq (congrArg (· ^ total hs n * powerProduct n n hs) (record_total prior lik hs os rec).symm))

/-- **The count beliefs at the bound are exactly those in proportion to the joint weights**:
equality exactly where `n h * E = joint h * N` at every listed hypothesis. Where the record weighs
nothing, every count belief is at the bound (`nothing_record_reach_all`). -/
theorem given_record_eq_iff {α β : Type} (prior : α → Nat) (lik : α → β → Nat) (hs : List α)
    (os : List β) (rec : β → Bool) (n : α → Nat) :
    total hs n ^ total hs n * powerProduct (joint prior lik os rec) n hs =
        mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) ^ total hs n *
          powerProduct n n hs ↔
      ∀ h, h ∈ hs → n h * mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) =
        joint prior lik os rec h * total hs n := by
  rw [record_total prior lik hs os rec]
  exact bound_eq_iff n (joint prior lik os rec) hs

/-- **Where the record weighs nothing, every count belief is at the bound**: both sides are equal,
with no share given the record to be in proportion to. With a positive total both are nothing; with
the total nothing both are `1`, since `0 ^ 0 = 1`. -/
theorem nothing_record_reach_all {α β : Type} (prior : α → Nat) (lik : α → β → Nat) (hs : List α)
    (os : List β) (rec : β → Bool) (n : α → Nat)
    (nothing : mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) = 0) :
    total hs n ^ total hs n * powerProduct (joint prior lik os rec) n hs =
      mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) ^ total hs n *
        powerProduct n n hs :=
  (given_record_eq_iff prior lik hs os rec n).2 fun h mem => by
    rw [nothing, Nat.mul_zero,
      zero_of_total_zero (joint prior lik os rec) hs
        ((record_total prior lik hs os rec).symm.trans nothing) h mem, Nat.zero_mul]

/-- **With the hypotheses listed once, the count beliefs at the bound are exactly those whose
every count, over the total, is the same ratio as the hypothesis's share given the record**
(`ConditionalWeights.posterior_single`). Where the record weighs nothing that share is `⟨0, 0⟩`,
the same ratio as any (`ConditionalWeights.Share.zero_whole`); a hypothesis listed twice breaks the
join (`Witness.duplicate_share`). -/
theorem given_record_eq_iff_share {α β : Type} [DecidableEq α] (prior : α → Nat)
    (lik : α → β → Nat) {hs : List α} (os : List β) (rec : β → Bool) (n : α → Nat)
    (distinct : Distinct hs) :
    total hs n ^ total hs n * powerProduct (joint prior lik os rec) n hs =
        mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) ^ total hs n *
          powerProduct n n hs ↔
      ∀ h, h ∈ hs → ConditionalWeights.Share.Same ⟨n h, total hs n⟩
        (ConditionalWeights.share (openSteps hs os)
          (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
          (fun c => decide (c.1 = h))) :=
  (given_record_eq_iff prior lik hs os rec n).trans
    ⟨fun prop h mem => by
      rw [posterior_single prior lik os rec distinct mem]
      show n h * _ = _ * total hs n
      rw [← evidence prior lik hs os rec]
      exact prop h mem,
     fun same h mem => by
      have s := same h mem
      rw [posterior_single prior lik os rec distinct mem] at s
      rw [evidence prior lik hs os rec]
      exact s⟩

/-- **The counts of the share given the record reach the bound**: with `n` the joint weights
themselves, both sides are equal. -/
theorem posterior_counts_reach {α β : Type} (prior : α → Nat) (lik : α → β → Nat) (hs : List α)
    (os : List β) (rec : β → Bool) :
    total hs (joint prior lik os rec) ^ total hs (joint prior lik os rec) *
        powerProduct (joint prior lik os rec) (joint prior lik os rec) hs =
      mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) ^
          total hs (joint prior lik os rec) *
        powerProduct (joint prior lik os rec) (joint prior lik os rec) hs :=
  congrArg (· ^ total hs (joint prior lik os rec) *
      powerProduct (joint prior lik os rec) (joint prior lik os rec) hs)
    (record_total prior lik hs os rec).symm

/-! ## Witnesses -/

namespace Witness

/-- Two hypotheses of weight one each. -/
def even : Bool → Nat := fun _ => 1

/-- A belief all on the first hypothesis. -/
def first : Bool → Nat := fun b => if b then 1 else 0

/-- **Away from proportion the bound is strict**: the belief all on one of two hypotheses of weight
one each has `1 < 2`. -/
theorem strict_off_proportion :
    total [true, false] first ^ total [true, false] first * powerProduct even first [true, false] <
      total [true, false] even ^ total [true, false] first * powerProduct first first [true, false] := by
  decide

/-- Two counts on each of two hypotheses. -/
def twoEach : Bool → Nat := fun _ => 2

/-- **Scaled counts reach the bound**: two counts on each of two hypotheses of weight one each,
`4 ^ 4 * 1 = 2 ^ 4 * (2 ^ 2 * 2 ^ 2)`. -/
theorem scaled_reach :
    total [true, false] twoEach ^ total [true, false] twoEach * powerProduct even twoEach [true, false] =
      total [true, false] even ^ total [true, false] twoEach * powerProduct twoEach twoEach [true, false] := by
  decide

/-- Weights nothing on the first hypothesis and one on the second. -/
def secondOnly : Bool → Nat := fun b => if b then 0 else 1

/-- **Off the support the bound still holds**: a belief all on a hypothesis of joint weight nothing
makes the left side nothing, as the free energy is infinite there as usually defined, and the bound
is strict. Under Mathlib's `log 0 = 0` the real form of `FreeEnergyReals` is at equality here
instead, the free energy being the surprisal; it fails at counts one and one (`even`) against the
same weights. -/
theorem off_support :
    total [true, false] first ^ total [true, false] first * powerProduct secondOnly first [true, false] = 0 ∧
      0 < total [true, false] secondOnly ^ total [true, false] first * powerProduct first first [true, false] := by
  decide

/-- Weights one and two. -/
def oneTwo : Bool → Nat := fun b => if b then 1 else 2

/-- `k` counts on the first hypothesis and the rest of two on the second. -/
def split2 (k : Nat) : Bool → Nat := fun b => if b then k else 2 - k

/-- **At one total the bound may be unreached**: against weights one and two, every count belief of
total two is strictly below it (`8 < 9` at counts one and one), the shares in proportion to the
weights, one third and two thirds, having no counts of total two. -/
theorem total_two_unreached : ∀ k, k ≤ 2 →
    total [true, false] (split2 k) ^ total [true, false] (split2 k) *
        powerProduct oneTwo (split2 k) [true, false] <
      total [true, false] oneTwo ^ total [true, false] (split2 k) *
        powerProduct (split2 k) (split2 k) [true, false]
  | 0, _ => by decide
  | 1, _ => by decide
  | 2, _ => by decide
  | k + 3, le => absurd (Nat.le_of_succ_le_succ (Nat.le_of_succ_le_succ le)) (Nat.not_succ_le_zero k)

/-- A prior of weight one everywhere. -/
def unitPrior : Bool → Nat := fun _ => 1

/-- A likelihood of weight one everywhere. -/
def unitLik : Bool → Bool → Nat := fun _ _ => 1

/-- **A record weighing nothing**: the belief all on the first hypothesis is at the bound, both
sides nothing, with no share given the record to be in proportion to. -/
theorem nothing_record_reach :
    total [true, false] first ^ total [true, false] first *
        powerProduct (joint unitPrior unitLik [true] (fun _ => false)) first [true, false] = 0 ∧
      mass (openSteps [true, false] [true]) (pairWeight unitPrior unitLik) (fun _ => false) ^
          total [true, false] first * powerProduct first first [true, false] = 0 := by
  decide

/-- **A hypothesis listed twice breaks the join to the share**: with the first hypothesis listed
twice and every weight one, the counts one everywhere are at the bound, yet the first hypothesis's
count over the total is `1` over `3` while its share given the record is `2` over `3`. -/
theorem duplicate_share :
    (total [true, true, false] (fun _ : Bool => 1) ^ total [true, true, false] (fun _ : Bool => 1) *
        powerProduct (joint unitPrior unitLik [true] (fun _ => true)) (fun _ => 1) [true, true, false] =
      mass (openSteps [true, true, false] [true]) (pairWeight unitPrior unitLik) (fun _ => true) ^
          total [true, true, false] (fun _ : Bool => 1) *
        powerProduct (fun _ : Bool => 1) (fun _ => 1) [true, true, false]) ∧
    total [true, true, false] (fun _ : Bool => 1) = 3 ∧
    (ConditionalWeights.share (openSteps [true, true, false] [true])
        (ConditionalWeights.restrict (fun _ => true) (pairWeight unitPrior unitLik))
        (fun c => decide (c.1 = true))).part = 2 ∧
    (ConditionalWeights.share (openSteps [true, true, false] [true])
        (ConditionalWeights.restrict (fun _ => true) (pairWeight unitPrior unitLik))
        (fun c => decide (c.1 = true))).whole = 3 := by
  decide

end Witness

end FreeEnergyCounting

end Becoming
