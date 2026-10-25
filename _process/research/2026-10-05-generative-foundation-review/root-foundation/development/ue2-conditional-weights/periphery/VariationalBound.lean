import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Algebra.BigOperators.Field

/-!
# The variational bound: free energy is at least surprisal (periphery draft, UE2)

`Becoming.ConditionalWeights` states, in the pure core and with no logarithm, what a record does
to a weighting of courses (`given`), the share of an event (`share`) and Bayes's rule in counting
form (`bayes`, `posterior_single`). The free-energy principle's central inequality needs
logarithms: for any distribution `q` over hidden causes, the variational free energy
`F q = Σ q i · (log q i − log p i)`, with `p i` the joint probability of cause `i` and a record, is
at least the surprisal of the record, `−log Σ p i`, with equality at the posterior
`q i = p i / Σ p`. This draft states it over Mathlib's reals for a finite set of causes.

* **Each term.** Where `q i ≥ 0`, `p i > 0` and `P > 0`,
  `q i · (log p i − log q i − log P) ≤ p i / P − q i` (`term_le`), from `log x ≤ x − 1`; a cause
  with `q i = 0` contributes nothing, as `log 0 = 0` in Mathlib.
* **Free energy is at least surprisal.** For `q` nonnegative with total one and `p` positive on a
  nonempty finite set, `−log (Σ p) ≤ Σ q i · (log q i − log p i)` (`free_energy_ge_surprisal`):
  Gibbs' inequality.
* **The bound is met at the posterior.** At `q i = p i / Σ p` the free energy is the surprisal
  (`free_energy_posterior`).
* **In counting form.** With natural weights `w i` of the courses with cause `i` agreeing with a
  record, out of a positive total weight `Z`, the free energy against the joint shares `w i / Z` is
  at least `−log ((Σ w) / Z)`, the logarithm of the reciprocal of the record's share
  (`free_energy_ge_surprisal_counts`): the share is the core's `share` of the courses agreeing with
  the record, read as a real ratio, and `Σ w` is the core's `evidence` when `w i` is a hypothesis's
  weight times the record's weight under it.

**Correspondence (an AI reading).** This is the variational bound of the free-energy principle
(Friston and others; the surprisal of sensory data bounded above by free energy), proved as Gibbs'
inequality for finite sums. Read with the core: the posterior at which the bound is met is the
share given the record of `Becoming.ConditionalWeights.posterior_single`, and the surprisal is the
logarithm of `Share.reciprocal` of the record's share.

What is not derived: densities, continuous causes or time; the bound where some `p i` is zero while
`q i` is not (the free energy is then not finite); the expected free energy of policies. The
counting corollary takes every joint weight positive. No instance theorem joins this draft to the
core's `share` in Lean: the core is built with Lean 4.29.1 and this draft with the periphery's Lean
4.30.0-rc2 and Mathlib, so that join waits for a periphery checker that compiles the core's closure
with the periphery toolchain (as `representation/check_representation.py` does).
-/

open Finset Real

namespace VariationalBound

variable {ι : Type*}

/-- **Each term of the free energy against the surprisal.** -/
theorem term_le {qi pi P : ℝ} (hq : 0 ≤ qi) (hp : 0 < pi) (hP : 0 < P) :
    qi * (Real.log pi - Real.log qi - Real.log P) ≤ pi / P - qi := by
  rcases hq.eq_or_lt with h | h
  · rw [← h, zero_mul, sub_zero]
    exact (div_pos hp hP).le
  · have hlog : Real.log pi - Real.log qi - Real.log P = Real.log (pi / (qi * P)) := by
      rw [Real.log_div hp.ne' (mul_pos h hP).ne', Real.log_mul h.ne' hP.ne']
      ring
    rw [hlog]
    calc qi * Real.log (pi / (qi * P)) ≤ qi * (pi / (qi * P) - 1) :=
          mul_le_mul_of_nonneg_left (Real.log_le_sub_one_of_pos (div_pos hp (mul_pos h hP))) h.le
      _ = pi / P - qi := by
          field_simp

/-- **Free energy is at least surprisal** (Gibbs' inequality): for `q` nonnegative with total one
and `p` positive on a nonempty finite set, `−log (Σ p) ≤ Σ q i · (log q i − log p i)`. -/
theorem free_energy_ge_surprisal (s : Finset ι) (q p : ι → ℝ) (hq : ∀ i ∈ s, 0 ≤ q i)
    (hq1 : ∑ i ∈ s, q i = 1) (hp : ∀ i ∈ s, 0 < p i) (hs : s.Nonempty) :
    -Real.log (∑ i ∈ s, p i) ≤ ∑ i ∈ s, q i * (Real.log (q i) - Real.log (p i)) := by
  set P := ∑ i ∈ s, p i with hPdef
  have hP : 0 < P := Finset.sum_pos hp hs
  have key : ∑ i ∈ s, q i * (Real.log (p i) - Real.log (q i) - Real.log P) ≤
      ∑ i ∈ s, (p i / P - q i) :=
    Finset.sum_le_sum fun i hi => term_le (hq i hi) (hp i hi) hP
  have rhs : ∑ i ∈ s, (p i / P - q i) = 0 := by
    rw [Finset.sum_sub_distrib, ← Finset.sum_div, ← hPdef, div_self hP.ne', hq1, sub_self]
  have lhs : ∑ i ∈ s, q i * (Real.log (p i) - Real.log (q i) - Real.log P) =
      -(∑ i ∈ s, q i * (Real.log (q i) - Real.log (p i))) - Real.log P := by
    have split : ∀ i, q i * (Real.log (p i) - Real.log (q i) - Real.log P) =
        -(q i * (Real.log (q i) - Real.log (p i))) - q i * Real.log P := fun i => by ring
    rw [Finset.sum_congr rfl fun i _ => split i, Finset.sum_sub_distrib, Finset.sum_neg_distrib,
      ← Finset.sum_mul, hq1, one_mul]
  linarith

/-- **The bound is met at the posterior** `q i = p i / Σ p`. -/
theorem free_energy_posterior (s : Finset ι) (p : ι → ℝ) (hp : ∀ i ∈ s, 0 < p i)
    (hs : s.Nonempty) :
    ∑ i ∈ s, (p i / ∑ j ∈ s, p j) * (Real.log (p i / ∑ j ∈ s, p j) - Real.log (p i)) =
      -Real.log (∑ j ∈ s, p j) := by
  set P := ∑ j ∈ s, p j with hPdef
  have hP : 0 < P := Finset.sum_pos hp hs
  have each : ∀ i ∈ s, (p i / P) * (Real.log (p i / P) - Real.log (p i)) =
      (p i / P) * (-Real.log P) := fun i hi => by
    rw [Real.log_div (hp i hi).ne' hP.ne']
    ring
  rw [Finset.sum_congr rfl each, ← Finset.sum_mul, ← Finset.sum_div, ← hPdef, div_self hP.ne',
    one_mul]

/-- **In counting form.** With natural weights `w i` of the courses with cause `i` agreeing with a
record, out of a positive total weight `Z`, and `q` a distribution over the causes, the free energy
against the joint shares `w i / Z` is at least the surprisal of the record, `−log ((Σ w) / Z)`. -/
theorem free_energy_ge_surprisal_counts (s : Finset ι) (q : ι → ℝ) (w : ι → ℕ) (Z : ℕ)
    (hq : ∀ i ∈ s, 0 ≤ q i) (hq1 : ∑ i ∈ s, q i = 1) (hw : ∀ i ∈ s, 0 < w i) (hZ : 0 < Z)
    (hs : s.Nonempty) :
    -Real.log ((∑ i ∈ s, (w i : ℝ)) / Z) ≤
      ∑ i ∈ s, q i * (Real.log (q i) - Real.log ((w i : ℝ) / Z)) := by
  have bound := free_energy_ge_surprisal s q (fun i => (w i : ℝ) / Z) hq hq1
    (fun i hi => div_pos (Nat.cast_pos.mpr (hw i hi)) (Nat.cast_pos.mpr hZ)) hs
  rwa [← Finset.sum_div] at bound

end VariationalBound

#print axioms VariationalBound.term_le
#print axioms VariationalBound.free_energy_ge_surprisal
#print axioms VariationalBound.free_energy_posterior
#print axioms VariationalBound.free_energy_ge_surprisal_counts
