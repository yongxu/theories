import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Algebra.BigOperators.Field

/-!
# Conditional weights over the reals: the logarithm of a reciprocal share (periphery draft, UE2)

`Becoming.ConditionalWeights` states, in the pure core and with no logarithm, conditioning as
restriction (`restrict`, `mass_restrict`), the share of an event (`share`), Bayes's rule in counting
form (`restrict_two_ways`) and the posterior share of a generative model (`posterior_single`).
Averages of logarithms have no counting form there. This module states, over Mathlib's reals and for
a finite set of causes, how the logarithm of the reciprocal of a sum compares with a `q`-average of
logarithms, and where the two are equal.

* **Each term.** Where `q i ≥ 0`, `p i ≥ 0`, `q i` is zero wherever `p i` is, and `P > 0`,
  `q i · (log p i − log q i − log P) ≤ p i / P − q i` (`term_le`), from `log x ≤ x − 1`; a cause
  with `q i = 0` contributes nothing, as `log 0 = 0` in Mathlib. With `p i > 0` the two sides are
  equal exactly where `q i = p i / P` (`term_eq_iff`).
* **The inequality.** For `q` nonnegative with total one, and `p` nonnegative with `q` zero wherever
  `p` is, `−log (Σ p) ≤ Σ q i · (log q i − log p i)` (`neg_log_sum_le`); with `p` positive it is
  `neg_log_sum_le_of_pos`. A finite set carrying a total of one is not empty (`nonempty_of_total`).
* **Equality exactly at the posterior.** With `p` positive, the two sides are equal exactly where
  `q i = p i / Σ p` for every `i` (`neg_log_sum_eq_iff`), and so at that `q` (`neg_log_sum_at_posterior`).
* **In counting form.** With natural weights `w i` out of a positive total `Z`, and `q` zero wherever
  `w` is, `−log ((Σ w) / Z) ≤ Σ q i · (log q i − log (w i / Z))` (`log_reciprocal_share_le`): the
  left side is the logarithm of the reciprocal of the share `⟨Σ w, Z⟩`.

**Correspondence (an AI reading).** Read `p i` as the joint probability of cause `i` and a record,
`Σ p` as the record's probability and `q` as a recognition density. Then the right side is the
variational free energy of `q`, the left side the surprisal of the record, and `neg_log_sum_le` is
the free-energy principle's bound, Gibbs' inequality; `neg_log_sum_eq_iff` says the bound is met
exactly at the posterior, so that minimizing free energy over `q` recovers the posterior. In counting
form the joint probabilities are the shares of a generative model's courses (`pairWeight`), `Σ w` is
the record's weight (`evidence`), and the posterior is the share given the record
(`posterior_single`). A cause the record rules out has joint weight zero, which the support
hypothesis admits.

What is not derived: densities, continuous causes or time; the expected free energy of policies; the
bound where `q` puts weight on a cause of joint weight zero, where the free energy is not finite and,
with Mathlib's `log 0 = 0`, the inequality fails. No instance theorem joins this draft to the core's
`share` in Lean: the core is built with Lean 4.29.1 and this draft with the periphery's Lean
4.30.0-rc2 and Mathlib, so that join waits for a periphery checker that compiles the core's closure
with the periphery toolchain, as `regime/check_regime_reals.py` does.
-/

open Finset Real

namespace Becoming.ConditionalWeights

variable {ι : Type*}

/-- **Each term of the comparison**, where `q` is zero wherever `p` is. -/
theorem term_le {qi pi P : ℝ} (hq : 0 ≤ qi) (hp : 0 ≤ pi) (support : pi = 0 → qi = 0)
    (hP : 0 < P) :
    qi * (Real.log pi - Real.log qi - Real.log P) ≤ pi / P - qi := by
  rcases hq.eq_or_lt with h | h
  · rw [← h, zero_mul, sub_zero]
    exact div_nonneg hp hP.le
  · have hpi : 0 < pi := lt_of_le_of_ne hp (fun e => absurd (support e.symm) h.ne')
    have hlog : Real.log pi - Real.log qi - Real.log P = Real.log (pi / (qi * P)) := by
      rw [Real.log_div hpi.ne' (mul_pos h hP).ne', Real.log_mul h.ne' hP.ne']
      ring
    rw [hlog]
    calc qi * Real.log (pi / (qi * P)) ≤ qi * (pi / (qi * P) - 1) :=
          mul_le_mul_of_nonneg_left (Real.log_le_sub_one_of_pos (div_pos hpi (mul_pos h hP))) h.le
      _ = pi / P - qi := by
          field_simp

/-- **A term meets its bound exactly at the normalized weight.** -/
theorem term_eq_iff {qi pi P : ℝ} (hq : 0 ≤ qi) (hp : 0 < pi) (hP : 0 < P) :
    qi * (Real.log pi - Real.log qi - Real.log P) = pi / P - qi ↔ qi = pi / P := by
  have hP0 : P ≠ 0 := hP.ne'
  constructor
  · intro h
    rcases hq.eq_or_lt with h0 | h0
    · rw [← h0, zero_mul, sub_zero] at h
      exact absurd h.symm (div_pos hp hP).ne'
    · by_contra hne
      have hx : pi / (qi * P) ≠ 1 := by
        intro h1
        apply hne
        rw [div_eq_one_iff_eq (mul_pos h0 hP).ne'] at h1
        rw [h1]
        field_simp
      have hlt := Real.log_lt_sub_one_of_pos (div_pos hp (mul_pos h0 hP)) hx
      have hlog : Real.log pi - Real.log qi - Real.log P = Real.log (pi / (qi * P)) := by
        rw [Real.log_div hp.ne' (mul_pos h0 hP).ne', Real.log_mul h0.ne' hP.ne']
        ring
      rw [hlog] at h
      have hm : qi * Real.log (pi / (qi * P)) < qi * (pi / (qi * P) - 1) :=
        mul_lt_mul_of_pos_left hlt h0
      have e : qi * (pi / (qi * P) - 1) = pi / P - qi := by
        field_simp
      linarith
  · intro h
    rw [h, Real.log_div hp.ne' hP0]
    ring

/-- A finite set carrying a total of one is not empty. -/
theorem nonempty_of_total (s : Finset ι) (q : ι → ℝ) (hq1 : ∑ i ∈ s, q i = 1) : s.Nonempty :=
  Finset.nonempty_of_sum_ne_zero (by rw [hq1]; exact one_ne_zero)

/-- **The logarithm of the reciprocal of a sum is at most a `q`-average of logarithms** (Gibbs'
inequality): for `q` nonnegative with total one and `p` nonnegative, `q` zero wherever `p` is,
`−log (Σ p) ≤ Σ q i · (log q i − log p i)`. -/
theorem neg_log_sum_le (s : Finset ι) (q p : ι → ℝ) (hq : ∀ i ∈ s, 0 ≤ q i)
    (hq1 : ∑ i ∈ s, q i = 1) (hp : ∀ i ∈ s, 0 ≤ p i) (support : ∀ i ∈ s, p i = 0 → q i = 0) :
    -Real.log (∑ i ∈ s, p i) ≤ ∑ i ∈ s, q i * (Real.log (q i) - Real.log (p i)) := by
  set P := ∑ i ∈ s, p i with hPdef
  have hP : 0 < P := by
    obtain ⟨j, hj, hqj⟩ := Finset.exists_ne_zero_of_sum_ne_zero
      (show ∑ i ∈ s, q i ≠ 0 by rw [hq1]; exact one_ne_zero)
    have hpj : 0 < p j := lt_of_le_of_ne (hp j hj) (fun e => hqj (support j hj e.symm))
    exact lt_of_lt_of_le hpj (Finset.single_le_sum hp hj)
  have key : ∑ i ∈ s, q i * (Real.log (p i) - Real.log (q i) - Real.log P) ≤
      ∑ i ∈ s, (p i / P - q i) :=
    Finset.sum_le_sum fun i hi => term_le (hq i hi) (hp i hi) (support i hi) hP
  have rhs : ∑ i ∈ s, (p i / P - q i) = 0 := by
    rw [Finset.sum_sub_distrib, ← Finset.sum_div, ← hPdef, div_self hP.ne', hq1, sub_self]
  have lhs : ∑ i ∈ s, q i * (Real.log (p i) - Real.log (q i) - Real.log P) =
      -(∑ i ∈ s, q i * (Real.log (q i) - Real.log (p i))) - Real.log P := by
    have split : ∀ i, q i * (Real.log (p i) - Real.log (q i) - Real.log P) =
        -(q i * (Real.log (q i) - Real.log (p i))) - q i * Real.log P := fun i => by ring
    rw [Finset.sum_congr rfl fun i _ => split i, Finset.sum_sub_distrib, Finset.sum_neg_distrib,
      ← Finset.sum_mul, hq1, one_mul]
  linarith

/-- **The same with `p` positive.** -/
theorem neg_log_sum_le_of_pos (s : Finset ι) (q p : ι → ℝ) (hq : ∀ i ∈ s, 0 ≤ q i)
    (hq1 : ∑ i ∈ s, q i = 1) (hp : ∀ i ∈ s, 0 < p i) :
    -Real.log (∑ i ∈ s, p i) ≤ ∑ i ∈ s, q i * (Real.log (q i) - Real.log (p i)) :=
  neg_log_sum_le s q p hq hq1 (fun i hi => (hp i hi).le) (fun i hi e => absurd e (hp i hi).ne')

/-- **Equality exactly at the posterior**: with `p` positive, the two sides are equal exactly where
`q i = p i / Σ p` for every `i`. -/
theorem neg_log_sum_eq_iff (s : Finset ι) (q p : ι → ℝ) (hq : ∀ i ∈ s, 0 ≤ q i)
    (hq1 : ∑ i ∈ s, q i = 1) (hp : ∀ i ∈ s, 0 < p i) :
    ∑ i ∈ s, q i * (Real.log (q i) - Real.log (p i)) = -Real.log (∑ i ∈ s, p i) ↔
      ∀ i ∈ s, q i = p i / ∑ j ∈ s, p j := by
  set P := ∑ i ∈ s, p i with hPdef
  have hP : 0 < P := Finset.sum_pos hp (nonempty_of_total s q hq1)
  have le : ∀ i ∈ s, q i * (Real.log (p i) - Real.log (q i) - Real.log P) ≤ p i / P - q i :=
    fun i hi => term_le (hq i hi) (hp i hi).le (fun e => absurd e (hp i hi).ne') hP
  have rhs : ∑ i ∈ s, (p i / P - q i) = 0 := by
    rw [Finset.sum_sub_distrib, ← Finset.sum_div, ← hPdef, div_self hP.ne', hq1, sub_self]
  have lhs : ∑ i ∈ s, q i * (Real.log (p i) - Real.log (q i) - Real.log P) =
      -(∑ i ∈ s, q i * (Real.log (q i) - Real.log (p i))) - Real.log P := by
    have split : ∀ i, q i * (Real.log (p i) - Real.log (q i) - Real.log P) =
        -(q i * (Real.log (q i) - Real.log (p i))) - q i * Real.log P := fun i => by ring
    rw [Finset.sum_congr rfl fun i _ => split i, Finset.sum_sub_distrib, Finset.sum_neg_distrib,
      ← Finset.sum_mul, hq1, one_mul]
  constructor
  · intro hF i hi
    have hsum : ∑ i ∈ s, q i * (Real.log (p i) - Real.log (q i) - Real.log P) =
        ∑ i ∈ s, (p i / P - q i) := by
      rw [lhs, rhs]
      linarith
    exact (term_eq_iff (hq i hi) (hp i hi) hP).mp ((Finset.sum_eq_sum_iff_of_le le).mp hsum i hi)
  · intro hall
    have hsum : ∑ i ∈ s, q i * (Real.log (p i) - Real.log (q i) - Real.log P) =
        ∑ i ∈ s, (p i / P - q i) :=
      (Finset.sum_eq_sum_iff_of_le le).mpr fun i hi =>
        (term_eq_iff (hq i hi) (hp i hi) hP).mpr (hall i hi)
    rw [lhs, rhs] at hsum
    linarith

/-- **At the posterior `q i = p i / Σ p` the two sides are equal.** -/
theorem neg_log_sum_at_posterior (s : Finset ι) (p : ι → ℝ) (hp : ∀ i ∈ s, 0 < p i) :
    ∑ i ∈ s, (p i / ∑ j ∈ s, p j) * (Real.log (p i / ∑ j ∈ s, p j) - Real.log (p i)) =
      -Real.log (∑ j ∈ s, p j) := by
  rcases s.eq_empty_or_nonempty with h | hs
  · simp [h]
  · have hP : 0 < ∑ j ∈ s, p j := Finset.sum_pos hp hs
    exact (neg_log_sum_eq_iff s (fun i => p i / ∑ j ∈ s, p j) p
      (fun i hi => (div_pos (hp i hi) hP).le)
      (by rw [← Finset.sum_div, div_self hP.ne']) hp).mpr fun _ _ => rfl

/-- **In counting form.** With natural weights `w i` out of a positive total `Z`, and `q` a
distribution zero wherever `w` is, the logarithm of the reciprocal of the share `⟨Σ w, Z⟩` is at
most `Σ q i · (log q i − log (w i / Z))`. -/
theorem log_reciprocal_share_le (s : Finset ι) (q : ι → ℝ) (w : ι → ℕ) (Z : ℕ)
    (hq : ∀ i ∈ s, 0 ≤ q i) (hq1 : ∑ i ∈ s, q i = 1) (support : ∀ i ∈ s, w i = 0 → q i = 0)
    (hZ : 0 < Z) :
    -Real.log ((∑ i ∈ s, (w i : ℝ)) / Z) ≤
      ∑ i ∈ s, q i * (Real.log (q i) - Real.log ((w i : ℝ) / Z)) := by
  have hZ' : (Z : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hZ.ne'
  have bound := neg_log_sum_le s q (fun i => (w i : ℝ) / Z) hq hq1
    (fun i _ => div_nonneg (Nat.cast_nonneg _) (Nat.cast_nonneg _))
    (fun i hi e => support i hi (by
      rcases div_eq_zero_iff.mp e with h | h
      · exact_mod_cast h
      · exact absurd h hZ'))
  rwa [← Finset.sum_div] at bound

end Becoming.ConditionalWeights

#print axioms Becoming.ConditionalWeights.term_le
#print axioms Becoming.ConditionalWeights.term_eq_iff
#print axioms Becoming.ConditionalWeights.nonempty_of_total
#print axioms Becoming.ConditionalWeights.neg_log_sum_le
#print axioms Becoming.ConditionalWeights.neg_log_sum_le_of_pos
#print axioms Becoming.ConditionalWeights.neg_log_sum_eq_iff
#print axioms Becoming.ConditionalWeights.neg_log_sum_at_posterior
#print axioms Becoming.ConditionalWeights.log_reciprocal_share_le
