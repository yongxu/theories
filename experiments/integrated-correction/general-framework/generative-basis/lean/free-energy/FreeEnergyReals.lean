import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Algebra.BigOperators.Field
import Becoming.ConditionalWeights
import Becoming.FreeEnergyCounting

/-!
# Variational free energy over the reals, joined to the core's conditioning and counting form

`Becoming.ConditionalWeights` states, in the pure core, with natural weights and no logarithm,
conditioning as restriction (`restrict`), the share of an event (`share`), Bayes's rule in counting
form (`restrict_two_ways`) and the share given a record in a generative model (`posterior_single`).
The core takes no logarithm and states no average of logarithms. This module states, over
Mathlib's reals and for a finite set of causes `s`, the variational free energy of a belief, its
bound by surprisal and the bound's equality exactly at the posterior, its decompositions, and reads
the posterior from the core: minimizing free energy over beliefs that put no weight where the joint
weight is zero (elsewhere it is infinite as usually defined) gives the core's share given the
record, and such a belief exists only where the record weighs something (`record_pos_of_belief`).
For beliefs in counts over hypotheses listed once, on the support, the bound itself is read from
the core: it is the core's counting form (`Becoming.FreeEnergyCounting`) through the logarithm.

* **The quantities.** For a belief `q` and joint weights `p` over `s`: the free energy
  `freeEnergy s q p = Σ q i · (log q i − log p i)`; the divergence of `q` from `r`,
  `divergence s q r`, the same average read against a distribution `r`; the surprisal of an amount,
  `surprisal P = −log P`; and the posterior, `posterior s p i = p i / Σ p`. Mathlib's conventions
  `log 0 = 0` and `x / 0 = 0` hold throughout. The free energy is the divergence from the joint
  weights, whose total need not be one (`freeEnergy_eq_divergence`), and reads a belief and the
  joint weights only at the causes (`freeEnergy_congr`, `freeEnergy_congr_weights`); it is the
  `q`-average of `−log p` less the entropy of `q`, the energy less the entropy that gives it its
  name (`freeEnergy_eq_energy_sub_entropy`).
* **The bound** (`surprisal_le_freeEnergy`, Gibbs' inequality). Where `q` is nonnegative with total
  one, `p` is nonnegative and `q` is zero wherever `p` is, `−log Σ p ≤ freeEnergy s q p`; the
  total of `p` is then positive (`total_pos`). Term by term it is `log x ≤ x − 1` (`term_le`).
* **Equality exactly at the posterior** (`freeEnergy_eq_surprisal_iff`). Under the same hypotheses
  the two sides are equal exactly where `q i = p i / Σ p` for every cause; with `p` positive the
  support hypothesis holds of every `q` (`freeEnergy_eq_surprisal_iff_of_pos`). At the posterior
  the free energy is the surprisal (`freeEnergy_posterior`), and among beliefs zero wherever `p`
  is, `q` has the least free energy exactly where it is the posterior (`minimizes_iff_posterior`).
  Off the support the bound can fail (`Witness.bound_fails_off_support`), so the minimization is over
  the beliefs where the free energy is finite as usually defined.
* **Divergence from the posterior plus surprisal** (`freeEnergy_eq_divergence_add_surprisal`). For
  `q` with total one, zero wherever `p` is, and `Σ p` not zero, with no sign hypothesis:
  `freeEnergy s q p = divergence s q (posterior s p) + surprisal (Σ p)`. The divergence is
  nonnegative and zero exactly at the posterior (`divergence_posterior_nonneg`,
  `divergence_posterior_eq_zero_iff`); between any two distributions likewise
  (`divergence_nonneg`, `divergence_eq_zero_iff`).
* **Complexity less accuracy** (`freeEnergy_eq_complexity_sub_accuracy`). Where
  `p i = prior i · lik i` and `q` is zero wherever `p` is, with no sign hypothesis:
  `freeEnergy s q p = divergence s q prior − Σ q i · log (lik i)`.
* **The join to the core.** A share is read as a real number, its part over its whole
  (`Share.toReal`). In a core generative model (`pairWeight prior lik` over `openSteps hs os`, the
  hypotheses `hs` listed without repetition, a record `rec`), take the causes to be the listed
  hypotheses and the joint weight of `h` to be the share of the courses whose hypothesis is `h` and
  whose record agrees: its part is `h`'s prior weight times the record's weight under it
  (`jointShare_part`, `jointShare_toReal`), and the joint weights sum to the record's share
  (`sum_jointShare`, through `evidence`). The posterior of these weights is, at each listed
  hypothesis, the core's share given the record (`givenShare_eq_posterior`, through
  `posterior_single`). So, for every belief over the listed hypotheses that is nonnegative, has
  total one and is zero wherever a hypothesis's prior weight times the record's weight under it is
  zero: the surprisal of the record's share is at most the belief's free energy
  (`record_surprisal_le_freeEnergy`); the two are equal exactly where the belief is the core's share
  given the record (`freeEnergy_eq_record_surprisal_iff`); such a belief exists only where the
  record weighs something (`record_pos_of_belief`); there the free energy of the core's share given
  the record is the surprisal of the record's share (`freeEnergy_givenShare`), and a belief has the
  least free energy among such beliefs exactly where it is that share (`minimizes_iff_givenShare`).
* **Surprisal adds over independent parts** (`surprisal_product`, from the core's `share_product`):
  where each of two events of independent parts weighs something, the surprisal of the share of
  both is the sum of their surprisals. The surprisal of a share is the logarithm of its reciprocal,
  the whole over the part (`surprisal_eq_log_reciprocal`), as the core's `Share.reciprocal` says.
* **The counting form, through the logarithm** (`gap_counts`). For natural counts `n` over
  hypotheses listed once, with a positive total `N`, and natural joint weights `a` with total `A`,
  no count falling where the weight is nothing, the belief in counts `n / N` (`countBelief`) has
  `N · (freeEnergy (n / N) a − surprisal A) = log (A ^ N · ∏ n ^ n) − log (N ^ N · ∏ a ^ n)`, the
  logarithms of the two sides of the core's counting bound (`FreeEnergyCounting.bound`). So at such
  a belief the two bounds are one, each holding exactly where the other does
  (`surprisal_le_freeEnergy_iff_bound`, which uses neither). From the core's laws the bound holds
  (`surprisal_le_freeEnergy_of_counts`, from `FreeEnergyCounting.bound`), is reached exactly where
  the counts are in proportion to the weights (`freeEnergy_eq_surprisal_iff_of_counts`, from
  `FreeEnergyCounting.bound_eq_iff`), which is where the belief is the posterior
  (`proportional_iff_posterior`), and is strict away from proportion
  (`surprisal_lt_freeEnergy_of_counts`). None of these four reaches `surprisal_le_freeEnergy`,
  `term_le` or Mathlib's `Real.log_le_sub_one_of_pos`. Every statement about `Real.log` reaches
  `x + 1 ≤ exp x` (`Real.add_one_le_exp`) through its definition as the inverse of `exp`; with that
  definition left unexpanded these reach neither it nor its strict form (a dependency audit in the
  UE22 study). The log ratio is `N` times
  the divergence from the posterior (`divergence_counts`), so the counting bound's left side is its
  right side times `exp (−N · D)` (`counts_eq_mul_exp`). The gap reads the joint weights up to a
  factor (`gap_div`), so in a core generative model, against the joint shares and the record's
  share, `N` times the gap is the logarithm of the ratio of the two sides of
  `FreeEnergyCounting.bound_given_record` (`gap_counts_given_record`). From the core's laws the
  bound holds there (`record_surprisal_le_freeEnergy_of_counts`), is reached exactly where every
  count over the total is the same ratio as the hypothesis's share given the record
  (`freeEnergy_eq_record_surprisal_iff_of_counts`, from
  `FreeEnergyCounting.given_record_eq_iff_share`), which as real numbers is where the belief is that
  share (`freeEnergy_eq_record_surprisal_iff_toReal_of_counts`, through
  `Share.same_iff_toReal_eq`), and is strict elsewhere (`record_surprisal_lt_freeEnergy_of_counts`).
  The identity needs the hypotheses listed once (`Witness.gap_counts_duplicate`) and can fail off
  the support (`Witness.gap_counts_off_support`: counts one and one against weights nothing and
  one, where the core's bound holds strictly and the real form, under `log 0 = 0`, fails); at one
  count, on a hypothesis of weight nothing, it holds, and where the weights total one, as in
  `Witness.one_count_off_support`, the real form is at equality while the core's bound is strict, so
  off the support the two cases of equality can part even where the identity holds.

**Correspondence (an AI reading).** Read a share as a probability (as in
`Becoming.ConditionalWeights`), `q` as a recognition density over hidden causes, and `p i` as the
joint probability of cause `i` and a record. Then `freeEnergy` is the variational free energy of the
free-energy principle, `surprisal (Σ p)` the surprisal of the record, `surprisal_le_freeEnergy` its
bound, and `minimizes_iff_posterior` the statement that exact minimization of variational free
energy, over the beliefs where it is finite, is exact Bayesian inference.
`freeEnergy_eq_divergence_add_surprisal` is the decomposition into the divergence from the posterior
plus surprisal, and `freeEnergy_eq_complexity_sub_accuracy` the one into complexity (the divergence
from the prior) less accuracy (the expected log-likelihood). Through the join, the posterior that
minimization reaches is the core's conditioning by restriction, read from natural weights: the core
states the posterior by counting, and this module characterizes it as the one minimizer of free
energy among the beliefs where it is finite. With `n` as observed counts and `a / A` as a model,
`counts_eq_mul_exp` is the identity of the method of types: the probability of a sequence with
these counts under the model is its probability under its own frequencies times `exp (−N · D)`.

What is not derived: densities, continuous causes or time; expected free energy (stated in
`ExpectedFreeEnergyReals`); any process by
which a system lowers its free energy (a descent, message passing), only what the least free energy
is and where it is reached; beliefs confined to a family (mean-field, the Laplace approximation's
Gaussian), whose least free energy exceeds the surprisal by the family's divergence from the
posterior, a reading of `freeEnergy_eq_divergence_add_surprisal`; free energy as a bound on the
long-run average of surprisal, the entropy of sensory states, which carries the principle's reading
of persisting; free energy over parameters and models, as in learning and model comparison; the
bound where `q` puts weight on a cause of joint weight zero, where the free energy as usually
defined is infinite and, with Mathlib's `log 0 = 0`, the bound can fail
(`Witness.bound_fails_off_support`). The complexity and accuracy are stated for real `prior` and
`lik`; reading them from the core's model (a prior share and a likelihood share) is not stated here.
The counting form reaches only beliefs in counts over hypotheses listed once, against natural joint
weights or, by `gap_div`, natural weights divided by one amount: beliefs with irrational shares, and
joint weights whose ratios are irrational, are not read from it, and a record weighing nothing is
excluded by its hypotheses (`total_pos_of_counts`). The declarations here may depend on Lean's
standard axioms, through Mathlib, and the receipt reports each one's; the core laws they read have
empty axiom reports. Discrete causes, natural weights and counts in the core, `0 ^ 0 = 1`
and Boolean records are the representation's commitments. No ethical premise occurs.
-/

namespace Becoming.FreeEnergy

/-! ## Free energy, divergence and surprisal over a finite set of causes -/

section Reals

variable {ι : Type*}

/-- **Variational free energy** of a belief `q` against joint weights `p` over the causes `s`: the
`q`-average of `log q − log p`. -/
noncomputable def freeEnergy (s : Finset ι) (q p : ι → ℝ) : ℝ :=
  ∑ i ∈ s, q i * (Real.log (q i) - Real.log (p i))

/-- **The divergence** (Kullback–Leibler) of `q` from `r` over the causes `s`: the `q`-average of
`log q − log r`. -/
noncomputable def divergence (s : Finset ι) (q r : ι → ℝ) : ℝ :=
  ∑ i ∈ s, q i * (Real.log (q i) - Real.log (r i))

/-- **Free energy is the divergence from the joint weights**, whose total need not be one: the two
are one average. -/
theorem freeEnergy_eq_divergence (s : Finset ι) (q p : ι → ℝ) :
    freeEnergy s q p = divergence s q p := rfl

/-- **Surprisal**: the negative logarithm of an amount, read for a positive amount; `surprisal 0 =
0` by Mathlib's `log 0 = 0`, where surprisal is usually infinite. -/
noncomputable def surprisal (P : ℝ) : ℝ := -Real.log P

/-- **The posterior**: each joint weight over their total. -/
noncomputable def posterior (s : Finset ι) (p : ι → ℝ) (i : ι) : ℝ := p i / ∑ j ∈ s, p j

/-- **Each term of the bound**, where `q` is zero wherever `p` is, from `log x ≤ x − 1`. A cause
with `q i = 0` contributes nothing. -/
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

/-- **A term with positive joint weight meets its bound exactly at the normalized weight.** -/
theorem term_eq_iff_of_pos {qi pi P : ℝ} (hq : 0 ≤ qi) (hp : 0 < pi) (hP : 0 < P) :
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

/-- **A term meets its bound exactly at the normalized weight**, where `q` is zero wherever `p` is:
a cause of joint weight zero meets it, with `q i = 0 = p i / P`. -/
theorem term_eq_iff {qi pi P : ℝ} (hq : 0 ≤ qi) (hp : 0 ≤ pi) (support : pi = 0 → qi = 0)
    (hP : 0 < P) :
    qi * (Real.log pi - Real.log qi - Real.log P) = pi / P - qi ↔ qi = pi / P := by
  rcases hp.eq_or_lt with h0 | hpos
  · rw [support h0.symm, ← h0]
    simp
  · exact term_eq_iff_of_pos hq hpos hP

/-- The free energy reads a belief only at the causes. -/
theorem freeEnergy_congr (s : Finset ι) {q q' : ι → ℝ} (p : ι → ℝ)
    (same : ∀ i ∈ s, q i = q' i) : freeEnergy s q p = freeEnergy s q' p :=
  Finset.sum_congr rfl fun i hi => by rw [same i hi]

/-- **The free energy reads the joint weights only at the causes.** -/
theorem freeEnergy_congr_weights (s : Finset ι) (q : ι → ℝ) {p p' : ι → ℝ}
    (same : ∀ i ∈ s, p i = p' i) : freeEnergy s q p = freeEnergy s q p' :=
  Finset.sum_congr rfl fun i hi => by rw [same i hi]

/-- Where `q` has total one, the terms of the bound sum to minus the free energy, less `log P`. -/
theorem sum_terms (s : Finset ι) (q p : ι → ℝ) (hq1 : ∑ i ∈ s, q i = 1) (P : ℝ) :
    ∑ i ∈ s, q i * (Real.log (p i) - Real.log (q i) - Real.log P) =
      -freeEnergy s q p - Real.log P := by
  have split : ∀ i, q i * (Real.log (p i) - Real.log (q i) - Real.log P) =
      -(q i * (Real.log (q i) - Real.log (p i))) - q i * Real.log P := fun i => by ring
  unfold freeEnergy
  rw [Finset.sum_congr rfl fun i _ => split i, Finset.sum_sub_distrib, Finset.sum_neg_distrib,
    ← Finset.sum_mul, hq1, one_mul]

/-- Where `q` has total one, the normalized joint weights less `q` sum to nothing. -/
theorem sum_normalized_sub (s : Finset ι) (q p : ι → ℝ) (hq1 : ∑ i ∈ s, q i = 1)
    (hP : ∑ i ∈ s, p i ≠ 0) :
    ∑ i ∈ s, (p i / ∑ j ∈ s, p j - q i) = 0 := by
  rw [Finset.sum_sub_distrib, ← Finset.sum_div, div_self hP, hq1, sub_self]

/-- **The joint weights have a positive total** where `q` has total one, `p` is nonnegative and `q`
is zero wherever `p` is. -/
theorem total_pos (s : Finset ι) (q p : ι → ℝ) (hq1 : ∑ i ∈ s, q i = 1)
    (hp : ∀ i ∈ s, 0 ≤ p i) (support : ∀ i ∈ s, p i = 0 → q i = 0) : 0 < ∑ i ∈ s, p i := by
  obtain ⟨j, hj, hqj⟩ := Finset.exists_ne_zero_of_sum_ne_zero
    (show ∑ i ∈ s, q i ≠ 0 by rw [hq1]; exact one_ne_zero)
  have hpj : 0 < p j := lt_of_le_of_ne (hp j hj) (fun e => hqj (support j hj e.symm))
  exact lt_of_lt_of_le hpj (Finset.single_le_sum hp hj)

/-- **The bound** (Gibbs' inequality): for `q` nonnegative with total one and `p` nonnegative, `q`
zero wherever `p` is, the surprisal of the total of `p` is at most the free energy. -/
theorem surprisal_le_freeEnergy (s : Finset ι) (q p : ι → ℝ) (hq : ∀ i ∈ s, 0 ≤ q i)
    (hq1 : ∑ i ∈ s, q i = 1) (hp : ∀ i ∈ s, 0 ≤ p i)
    (support : ∀ i ∈ s, p i = 0 → q i = 0) :
    surprisal (∑ i ∈ s, p i) ≤ freeEnergy s q p := by
  have hP := total_pos s q p hq1 hp support
  have key : ∑ i ∈ s, q i * (Real.log (p i) - Real.log (q i) - Real.log (∑ j ∈ s, p j)) ≤
      ∑ i ∈ s, (p i / ∑ j ∈ s, p j - q i) :=
    Finset.sum_le_sum fun i hi => term_le (hq i hi) (hp i hi) (support i hi) hP
  rw [sum_terms s q p hq1, sum_normalized_sub s q p hq1 hP.ne'] at key
  unfold surprisal
  linarith

/-- **Equality exactly at the posterior**: under the hypotheses of the bound, the free energy is the
surprisal of the total exactly where `q i = p i / Σ p` for every cause. -/
theorem freeEnergy_eq_surprisal_iff (s : Finset ι) (q p : ι → ℝ) (hq : ∀ i ∈ s, 0 ≤ q i)
    (hq1 : ∑ i ∈ s, q i = 1) (hp : ∀ i ∈ s, 0 ≤ p i)
    (support : ∀ i ∈ s, p i = 0 → q i = 0) :
    freeEnergy s q p = surprisal (∑ i ∈ s, p i) ↔ ∀ i ∈ s, q i = posterior s p i := by
  have hP := total_pos s q p hq1 hp support
  have le : ∀ i ∈ s, q i * (Real.log (p i) - Real.log (q i) - Real.log (∑ j ∈ s, p j)) ≤
      p i / ∑ j ∈ s, p j - q i :=
    fun i hi => term_le (hq i hi) (hp i hi) (support i hi) hP
  have sums : (∑ i ∈ s, q i * (Real.log (p i) - Real.log (q i) - Real.log (∑ j ∈ s, p j)) =
      ∑ i ∈ s, (p i / ∑ j ∈ s, p j - q i)) ↔ freeEnergy s q p = surprisal (∑ i ∈ s, p i) := by
    rw [sum_terms s q p hq1, sum_normalized_sub s q p hq1 hP.ne']
    unfold surprisal
    constructor <;> intro h <;> linarith
  rw [← sums, Finset.sum_eq_sum_iff_of_le le]
  exact forall₂_congr fun i hi => term_eq_iff (hq i hi) (hp i hi) (support i hi) hP

/-- **Equality exactly at the posterior, with `p` positive**: then every `q` is zero wherever `p`
is, and the free energy is the surprisal of the total exactly where `q i = p i / Σ p`. -/
theorem freeEnergy_eq_surprisal_iff_of_pos (s : Finset ι) (q p : ι → ℝ) (hq : ∀ i ∈ s, 0 ≤ q i)
    (hq1 : ∑ i ∈ s, q i = 1) (hp : ∀ i ∈ s, 0 < p i) :
    freeEnergy s q p = surprisal (∑ i ∈ s, p i) ↔ ∀ i ∈ s, q i = p i / ∑ j ∈ s, p j :=
  freeEnergy_eq_surprisal_iff s q p hq hq1 (fun i hi => (hp i hi).le)
    fun i hi zero => absurd zero (hp i hi).ne'

/-- The posterior of nonnegative weights is nonnegative. -/
theorem posterior_nonneg (s : Finset ι) (p : ι → ℝ) (hp : ∀ i ∈ s, 0 ≤ p i) {i : ι}
    (hi : i ∈ s) : 0 ≤ posterior s p i :=
  div_nonneg (hp i hi) (Finset.sum_nonneg hp)

/-- The posterior is zero wherever the joint weight is. -/
theorem posterior_eq_zero (s : Finset ι) (p : ι → ℝ) {i : ι} (zero : p i = 0) :
    posterior s p i = 0 := by
  rw [posterior, zero, zero_div]

/-- The posterior has total one where the joint weights' total is not zero. -/
theorem sum_posterior (s : Finset ι) (p : ι → ℝ) (hP : ∑ i ∈ s, p i ≠ 0) :
    ∑ i ∈ s, posterior s p i = 1 := by
  unfold posterior
  rw [← Finset.sum_div, div_self hP]

/-- **At the posterior the free energy is the surprisal of the total.** -/
theorem freeEnergy_posterior (s : Finset ι) (p : ι → ℝ) (hp : ∀ i ∈ s, 0 ≤ p i)
    (hP : 0 < ∑ i ∈ s, p i) :
    freeEnergy s (posterior s p) p = surprisal (∑ i ∈ s, p i) :=
  (freeEnergy_eq_surprisal_iff s (posterior s p) p (fun _ hi => posterior_nonneg s p hp hi)
    (sum_posterior s p hP.ne') hp (fun _ _ zero => posterior_eq_zero s p zero)).mpr
    fun _ _ => rfl

/-- **The posterior, and only it, has the least free energy**: among beliefs over `s` that are
nonnegative, have total one and are zero wherever `p` is, `q` has the least free energy exactly
where it is the posterior. -/
theorem minimizes_iff_posterior (s : Finset ι) (q p : ι → ℝ) (hq : ∀ i ∈ s, 0 ≤ q i)
    (hq1 : ∑ i ∈ s, q i = 1) (hp : ∀ i ∈ s, 0 ≤ p i)
    (support : ∀ i ∈ s, p i = 0 → q i = 0) :
    (∀ q' : ι → ℝ, (∀ i ∈ s, 0 ≤ q' i) → ∑ i ∈ s, q' i = 1 →
        (∀ i ∈ s, p i = 0 → q' i = 0) → freeEnergy s q p ≤ freeEnergy s q' p) ↔
      ∀ i ∈ s, q i = posterior s p i := by
  have hP := total_pos s q p hq1 hp support
  have atPosterior := freeEnergy_posterior s p hp hP
  have bound := surprisal_le_freeEnergy s q p hq hq1 hp support
  constructor
  · intro least
    have le := least (posterior s p) (fun _ hi => posterior_nonneg s p hp hi)
      (sum_posterior s p hP.ne') (fun _ _ zero => posterior_eq_zero s p zero)
    exact (freeEnergy_eq_surprisal_iff s q p hq hq1 hp support).mp (by linarith)
  · intro same q' hq' hq1' support'
    have eq := (freeEnergy_eq_surprisal_iff s q p hq hq1 hp support).mpr same
    have ge := surprisal_le_freeEnergy s q' p hq' hq1' hp support'
    linarith

/-- **Free energy is the divergence from the posterior plus the surprisal of the total**, for `q`
with total one and zero wherever `p` is, and `p` with a total that is not zero. -/
theorem freeEnergy_eq_divergence_add_surprisal (s : Finset ι) (q p : ι → ℝ)
    (hq1 : ∑ i ∈ s, q i = 1) (support : ∀ i ∈ s, p i = 0 → q i = 0)
    (hP : ∑ i ∈ s, p i ≠ 0) :
    freeEnergy s q p = divergence s q (posterior s p) + surprisal (∑ i ∈ s, p i) := by
  have key : ∀ i ∈ s, q i * (Real.log (q i) - Real.log (posterior s p i)) =
      q i * (Real.log (q i) - Real.log (p i)) + q i * Real.log (∑ j ∈ s, p j) := by
    intro i hi
    by_cases hpi : p i = 0
    · rw [support i hi hpi]
      ring
    · rw [posterior, Real.log_div hpi hP]
      ring
  unfold divergence surprisal freeEnergy
  rw [Finset.sum_congr rfl key, Finset.sum_add_distrib, ← Finset.sum_mul, hq1]
  ring

/-- **The divergence of a distribution from a distribution is nonnegative**, where the first is
zero wherever the second is. -/
theorem divergence_nonneg (s : Finset ι) (q r : ι → ℝ) (hq : ∀ i ∈ s, 0 ≤ q i)
    (hq1 : ∑ i ∈ s, q i = 1) (hr : ∀ i ∈ s, 0 ≤ r i) (hr1 : ∑ i ∈ s, r i = 1)
    (support : ∀ i ∈ s, r i = 0 → q i = 0) : 0 ≤ divergence s q r := by
  have bound := surprisal_le_freeEnergy s q r hq hq1 hr support
  rw [hr1, surprisal, Real.log_one, neg_zero] at bound
  exact bound

/-- **The divergence is zero exactly where the two distributions agree**, where the first is zero
wherever the second is. -/
theorem divergence_eq_zero_iff (s : Finset ι) (q r : ι → ℝ) (hq : ∀ i ∈ s, 0 ≤ q i)
    (hq1 : ∑ i ∈ s, q i = 1) (hr : ∀ i ∈ s, 0 ≤ r i) (hr1 : ∑ i ∈ s, r i = 1)
    (support : ∀ i ∈ s, r i = 0 → q i = 0) :
    divergence s q r = 0 ↔ ∀ i ∈ s, q i = r i := by
  have equal := freeEnergy_eq_surprisal_iff s q r hq hq1 hr support
  simp only [hr1, surprisal, Real.log_one, neg_zero, posterior, div_one] at equal
  exact equal

/-- **The divergence from the posterior is nonnegative**: under the hypotheses of the bound. -/
theorem divergence_posterior_nonneg (s : Finset ι) (q p : ι → ℝ) (hq : ∀ i ∈ s, 0 ≤ q i)
    (hq1 : ∑ i ∈ s, q i = 1) (hp : ∀ i ∈ s, 0 ≤ p i)
    (support : ∀ i ∈ s, p i = 0 → q i = 0) :
    0 ≤ divergence s q (posterior s p) := by
  have hP := total_pos s q p hq1 hp support
  have split := freeEnergy_eq_divergence_add_surprisal s q p hq1 support hP.ne'
  have bound := surprisal_le_freeEnergy s q p hq hq1 hp support
  linarith

/-- **The divergence from the posterior is zero exactly at the posterior**: under the hypotheses of
the bound. -/
theorem divergence_posterior_eq_zero_iff (s : Finset ι) (q p : ι → ℝ)
    (hq : ∀ i ∈ s, 0 ≤ q i) (hq1 : ∑ i ∈ s, q i = 1) (hp : ∀ i ∈ s, 0 ≤ p i)
    (support : ∀ i ∈ s, p i = 0 → q i = 0) :
    divergence s q (posterior s p) = 0 ↔ ∀ i ∈ s, q i = posterior s p i := by
  have hP := total_pos s q p hq1 hp support
  have split := freeEnergy_eq_divergence_add_surprisal s q p hq1 support hP.ne'
  rw [← freeEnergy_eq_surprisal_iff s q p hq hq1 hp support]
  constructor <;> intro h <;> linarith

/-- **Complexity less accuracy**: where each joint weight is a prior weight times a likelihood and
`q` is zero wherever the joint weight is, the free energy is the divergence of `q` from the prior
(the complexity, nonnegative where `q` and the prior are distributions: `divergence_nonneg`) less
the
`q`-average of the log-likelihood (the accuracy). -/
theorem freeEnergy_eq_complexity_sub_accuracy (s : Finset ι) (q prior lik : ι → ℝ)
    (support : ∀ i ∈ s, prior i * lik i = 0 → q i = 0) :
    freeEnergy s q (fun i => prior i * lik i) =
      divergence s q prior - ∑ i ∈ s, q i * Real.log (lik i) := by
  unfold freeEnergy divergence
  rw [← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun i hi => ?_
  by_cases zero : prior i * lik i = 0
  · rw [support i hi zero]
    ring
  · rw [Real.log_mul (left_ne_zero_of_mul zero) (right_ne_zero_of_mul zero)]
    ring

/-- **Energy less entropy**: the free energy is the `q`-average of `−log p` less the entropy of
`q`, with no hypothesis. -/
theorem freeEnergy_eq_energy_sub_entropy (s : Finset ι) (q p : ι → ℝ) :
    freeEnergy s q p = ∑ i ∈ s, q i * -Real.log (p i) - ∑ i ∈ s, q i * -Real.log (q i) := by
  unfold freeEnergy
  rw [← Finset.sum_sub_distrib]
  exact Finset.sum_congr rfl fun i _ => by ring

/-- **The gap reads the joint weights up to a factor**: for `q` with total one and zero wherever
`p` is, and `p` with a total that is not zero, dividing every joint weight by one amount `c ≠ 0`
leaves the free energy less the surprisal of the total unchanged, both shifting by `log c`. -/
theorem gap_div (s : Finset ι) (q p : ι → ℝ) (hq1 : ∑ i ∈ s, q i = 1)
    (support : ∀ i ∈ s, p i = 0 → q i = 0) (hP : ∑ i ∈ s, p i ≠ 0) {c : ℝ} (hc : c ≠ 0) :
    freeEnergy s q (fun i => p i / c) - surprisal (∑ i ∈ s, p i / c) =
      freeEnergy s q p - surprisal (∑ i ∈ s, p i) := by
  have term : ∀ i ∈ s, q i * (Real.log (q i) - Real.log (p i / c)) =
      q i * (Real.log (q i) - Real.log (p i)) + q i * Real.log c := by
    intro i hi
    by_cases zero : p i = 0
    · rw [support i hi zero]
      ring
    · rw [Real.log_div zero hc]
      ring
  unfold freeEnergy surprisal
  rw [Finset.sum_congr rfl term, Finset.sum_add_distrib, ← Finset.sum_mul, hq1, ← Finset.sum_div,
    Real.log_div hP hc]
  ring

end Reals

namespace Witness

/-- **Off the support the bound can fail**, with Mathlib's `log 0 = 0`: over two causes with joint
weights one and zero, the belief one half on each has a free energy below the surprisal of the
total, `−log 1 = 0`, since the cause of weight zero contributes `(1/2) · log (1/2)` where, as
usually defined, its contribution is infinite. -/
theorem bound_fails_off_support :
    freeEnergy Finset.univ (fun _ : Fin 2 => (1 / 2 : ℝ)) (fun i => if i = 0 then 1 else 0) <
      surprisal (∑ i : Fin 2, if i = 0 then (1 : ℝ) else 0) := by
  have two : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have half : Real.log (1 / 2) = -Real.log 2 := by rw [one_div, Real.log_inv]
  simp only [freeEnergy, surprisal, Fin.sum_univ_two]
  norm_num
  linarith

end Witness

/-! ## The join to the core's conditioning -/

section Core

open Becoming.ConditionalWeights

variable {α : Type*} {β : Type*}

/-- **A share as a real number**: its part over its whole (`0` where the whole is nothing, by
Mathlib's convention `x / 0 = 0`). -/
noncomputable def _root_.Becoming.ConditionalWeights.Share.toReal (a : Share) : ℝ :=
  (a.part : ℝ) / (a.whole : ℝ)

/-- A share as a real number is nonnegative. -/
theorem _root_.Becoming.ConditionalWeights.Share.toReal_nonneg (a : Share) : 0 ≤ a.toReal :=
  div_nonneg (Nat.cast_nonneg _) (Nat.cast_nonneg _)

/-- An event that weighs something has a positive share. -/
theorem share_toReal_pos {Ω : Type*} (l : List Ω) (w : Ω → ℕ) (e : Ω → Bool)
    (positive : 0 < mass l w e) : 0 < (share l w e).toReal :=
  div_pos (Nat.cast_pos.mpr positive)
    (Nat.cast_pos.mpr (lt_of_lt_of_le positive (share_within l w e)))

/-- Two shares taken together (`Share.mul`) are, as real numbers, their product. -/
theorem _root_.Becoming.ConditionalWeights.Share.toReal_mul (a b : Share) :
    (a.mul b).toReal = a.toReal * b.toReal := by
  show ((a.part * b.part : ℕ) : ℝ) / ((a.whole * b.whole : ℕ) : ℝ) =
    (a.part : ℝ) / a.whole * ((b.part : ℝ) / b.whole)
  rw [Nat.cast_mul, Nat.cast_mul, mul_div_mul_comm]

/-- **The surprisal of a share is the logarithm of its reciprocal**, the whole over the part. -/
theorem surprisal_eq_log_reciprocal (a : Share) :
    surprisal a.toReal = Real.log a.reciprocal.toReal := by
  show -Real.log ((a.part : ℝ) / a.whole) = Real.log ((a.whole : ℝ) / a.part)
  rw [← Real.log_inv, inv_div]

/-- The cast of a mass, under the event that always holds, over a list without repetition is the
sum over its members. -/
theorem cast_mass_eq_sum [DecidableEq α] (f : α → ℕ) :
    ∀ {hs : List α}, Distinct hs →
      ((mass hs f (fun _ => true) : ℕ) : ℝ) = ∑ h ∈ hs.toFinset, (f h : ℝ)
  | [], _ => by simp [mass]
  | a :: t, ⟨fresh, rest⟩ => by
    rw [List.toFinset_cons, Finset.sum_insert (fun inside => fresh (List.mem_toFinset.mp inside))]
    show (((if (fun _ : α => true) a = true then f a else 0) + mass t f (fun _ => true) : ℕ) :
      ℝ) = _
    rw [Nat.cast_add, cast_mass_eq_sum f rest]
    simp

/-- **The joint share's part.** In a generative model, the courses whose hypothesis is a listed
`h₀` and whose record agrees weigh `h₀`'s prior weight times the record's weight under it. -/
theorem jointShare_part [DecidableEq α] (prior : α → ℕ) (lik : α → β → ℕ) {hs : List α}
    (os : List β) (rec : β → Bool) (distinct : Distinct hs) {h₀ : α} (mem : h₀ ∈ hs) :
    (share (openSteps hs os) (pairWeight prior lik)
        (fun c => decide (c.1 = h₀) && rec c.2)).part =
      prior h₀ * mass os (lik h₀) rec :=
  (mass_pairWeight prior lik hs os (fun h => decide (h = h₀)) rec).trans
    (mass_single (fun h => prior h * mass os (lik h) rec) h₀ distinct mem)

/-- **The joint share as a real number**: `h₀`'s prior weight times the record's weight under it,
over the whole weight. -/
theorem jointShare_toReal [DecidableEq α] (prior : α → ℕ) (lik : α → β → ℕ) {hs : List α}
    (os : List β) (rec : β → Bool) (distinct : Distinct hs) {h₀ : α} (mem : h₀ ∈ hs) :
    (share (openSteps hs os) (pairWeight prior lik)
        (fun c => decide (c.1 = h₀) && rec c.2)).toReal =
      ((prior h₀ * mass os (lik h₀) rec : ℕ) : ℝ) /
        ((mass (openSteps hs os) (pairWeight prior lik) (fun _ => true) : ℕ) : ℝ) := by
  unfold Share.toReal
  rw [jointShare_part prior lik os rec distinct mem]
  rfl

/-- **The record's share as a real number**: the sum over the hypotheses of each one's prior weight
times the record's weight under it (`evidence`), over the whole weight. -/
theorem recordShare_toReal (prior : α → ℕ) (lik : α → β → ℕ) (hs : List α) (os : List β)
    (rec : β → Bool) :
    (share (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)).toReal =
      ((mass hs (fun h => prior h * mass os (lik h) rec) (fun _ => true) : ℕ) : ℝ) /
        ((mass (openSteps hs os) (pairWeight prior lik) (fun _ => true) : ℕ) : ℝ) := by
  unfold Share.toReal
  rw [← evidence prior lik hs os rec]
  rfl

/-- **The joint shares sum to the record's share**: over the listed hypotheses, the shares of the
courses whose hypothesis is each one and whose record agrees add up, as real numbers, to the share
of the courses whose record agrees. -/
theorem sum_jointShare [DecidableEq α] (prior : α → ℕ) (lik : α → β → ℕ) {hs : List α}
    (os : List β) (rec : β → Bool) (distinct : Distinct hs) :
    ∑ h ∈ hs.toFinset, (share (openSteps hs os) (pairWeight prior lik)
        (fun c => decide (c.1 = h) && rec c.2)).toReal =
      (share (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)).toReal := by
  have each : ∀ h ∈ hs.toFinset, (share (openSteps hs os) (pairWeight prior lik)
      (fun c => decide (c.1 = h) && rec c.2)).toReal =
        ((prior h * mass os (lik h) rec : ℕ) : ℝ) /
          ((mass (openSteps hs os) (pairWeight prior lik) (fun _ => true) : ℕ) : ℝ) :=
    fun h mem => jointShare_toReal prior lik os rec distinct (List.mem_toFinset.mp mem)
  rw [Finset.sum_congr rfl each, ← Finset.sum_div,
    ← cast_mass_eq_sum (fun h => prior h * mass os (lik h) rec) distinct, recordShare_toReal]

/-- **The share given the record as a real number** (`posterior_single`): a listed hypothesis's
prior weight times the record's weight under it, over that product summed over the hypotheses. -/
theorem givenShare_toReal [DecidableEq α] (prior : α → ℕ) (lik : α → β → ℕ) {hs : List α}
    (os : List β) (rec : β → Bool) (distinct : Distinct hs) {h₀ : α} (mem : h₀ ∈ hs) :
    (share (openSteps hs os)
        (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h₀))).toReal =
      ((prior h₀ * mass os (lik h₀) rec : ℕ) : ℝ) /
        ((mass hs (fun h => prior h * mass os (lik h) rec) (fun _ => true) : ℕ) : ℝ) := by
  rw [posterior_single prior lik os rec distinct mem]
  rfl

/-- **The posterior of the joint shares is the core's share given the record**: at each listed
hypothesis, the posterior over the reals of the joint shares is the share, under the weighting
restricted to the record, of the courses whose hypothesis is that one. -/
theorem givenShare_eq_posterior [DecidableEq α] (prior : α → ℕ) (lik : α → β → ℕ)
    {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs) {h₀ : α}
    (mem : h₀ ∈ hs) :
    (share (openSteps hs os)
        (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h₀))).toReal =
      posterior hs.toFinset (fun h => (share (openSteps hs os) (pairWeight prior lik)
        (fun c => decide (c.1 = h) && rec c.2)).toReal) h₀ := by
  simp only [posterior]
  rw [sum_jointShare prior lik os rec distinct, givenShare_toReal prior lik os rec distinct mem,
    jointShare_toReal prior lik os rec distinct mem, recordShare_toReal]
  by_cases hZ : ((mass (openSteps hs os) (pairWeight prior lik) (fun _ => true) : ℕ) : ℝ) = 0
  · have within : mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) ≤
        mass (openSteps hs os) (pairWeight prior lik) (fun _ => true) :=
      share_within (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)
    have whole : mass (openSteps hs os) (pairWeight prior lik) (fun _ => true) = 0 := by
      exact_mod_cast hZ
    have record : mass hs (fun h => prior h * mass os (lik h) rec) (fun _ => true) = 0 := by
      rw [← evidence prior lik hs os rec]
      omega
    simp [hZ, record]
  · exact (div_div_div_cancel_right₀ hZ _ _).symm

/-- A listed hypothesis's joint share is zero, as a real number, only where its prior weight times
the record's weight under it is zero. -/
theorem weight_zero_of_jointShare_zero [DecidableEq α] (prior : α → ℕ) (lik : α → β → ℕ)
    {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs) {h₀ : α}
    (mem : h₀ ∈ hs)
    (zero : (share (openSteps hs os) (pairWeight prior lik)
      (fun c => decide (c.1 = h₀) && rec c.2)).toReal = 0) :
    prior h₀ * mass os (lik h₀) rec = 0 := by
  have within := share_within (openSteps hs os) (pairWeight prior lik)
    (fun c => decide (c.1 = h₀) && rec c.2)
  rw [← jointShare_part prior lik os rec distinct mem]
  unfold Share.toReal at zero
  rcases div_eq_zero_iff.mp zero with part | whole
  · exact_mod_cast part
  · have : (share (openSteps hs os) (pairWeight prior lik)
        (fun c => decide (c.1 = h₀) && rec c.2)).whole = 0 := by exact_mod_cast whole
    omega

/-- **A belief zero on the hypotheses the prior or the record rules out exists only where the record
weighs something.** A belief over the listed hypotheses with total one, zero wherever a hypothesis's
prior weight times the record's weight under it is zero, puts weight on some hypothesis whose
product is not zero, and the record's weight is at least that product. -/
theorem record_pos_of_belief [DecidableEq α] (prior : α → ℕ) (lik : α → β → ℕ) {hs : List α}
    (os : List β) (rec : β → Bool) (distinct : Distinct hs) (q : α → ℝ)
    (hq1 : ∑ h ∈ hs.toFinset, q h = 1)
    (ruledOut : ∀ h ∈ hs, prior h * mass os (lik h) rec = 0 → q h = 0) :
    0 < mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) := by
  have total := total_pos hs.toFinset q (fun h => (share (openSteps hs os) (pairWeight prior lik)
      (fun c => decide (c.1 = h) && rec c.2)).toReal) hq1 (fun _ _ => Share.toReal_nonneg _)
      fun h mem zero => ruledOut h (List.mem_toFinset.mp mem)
        (weight_zero_of_jointShare_zero prior lik os rec distinct (List.mem_toFinset.mp mem) zero)
  rw [sum_jointShare prior lik os rec distinct] at total
  rcases Nat.eq_zero_or_pos (mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2))
    with zero | positive
  · exfalso
    have : (share (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)).toReal = 0 := by
      show ((mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) : ℕ) : ℝ) / _ = 0
      rw [zero, Nat.cast_zero, zero_div]
    linarith
  · exact positive

/-- **The bound, in the core's terms.** For every belief `q` over the listed hypotheses,
nonnegative, with total one and zero wherever a hypothesis's prior weight times the record's weight
under it is zero, the surprisal of the record's share is at most the free energy of `q` against the
joint shares. -/
theorem record_surprisal_le_freeEnergy [DecidableEq α] (prior : α → ℕ) (lik : α → β → ℕ)
    {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs) (q : α → ℝ)
    (hq : ∀ h ∈ hs, 0 ≤ q h) (hq1 : ∑ h ∈ hs.toFinset, q h = 1)
    (ruledOut : ∀ h ∈ hs, prior h * mass os (lik h) rec = 0 → q h = 0) :
    surprisal (share (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)).toReal ≤
      freeEnergy hs.toFinset q (fun h => (share (openSteps hs os) (pairWeight prior lik)
        (fun c => decide (c.1 = h) && rec c.2)).toReal) := by
  rw [← sum_jointShare prior lik os rec distinct]
  exact surprisal_le_freeEnergy hs.toFinset q _ (fun h mem => hq h (List.mem_toFinset.mp mem))
    hq1 (fun _ _ => Share.toReal_nonneg _) fun h mem zero =>
      ruledOut h (List.mem_toFinset.mp mem)
        (weight_zero_of_jointShare_zero prior lik os rec distinct (List.mem_toFinset.mp mem) zero)

/-- **Equality exactly at the core's share given the record.** Under the hypotheses of the bound,
the free energy of `q` against the joint shares is the surprisal of the record's share exactly
where `q` is, at every listed hypothesis, the share given the record of the courses whose
hypothesis is that one. -/
theorem freeEnergy_eq_record_surprisal_iff [DecidableEq α] (prior : α → ℕ) (lik : α → β → ℕ)
    {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs) (q : α → ℝ)
    (hq : ∀ h ∈ hs, 0 ≤ q h) (hq1 : ∑ h ∈ hs.toFinset, q h = 1)
    (ruledOut : ∀ h ∈ hs, prior h * mass os (lik h) rec = 0 → q h = 0) :
    freeEnergy hs.toFinset q (fun h => (share (openSteps hs os) (pairWeight prior lik)
        (fun c => decide (c.1 = h) && rec c.2)).toReal) =
        surprisal (share (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)).toReal ↔
      ∀ h ∈ hs, q h = (share (openSteps hs os)
        (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h))).toReal := by
  rw [← sum_jointShare prior lik os rec distinct,
    freeEnergy_eq_surprisal_iff hs.toFinset q _ (fun h mem => hq h (List.mem_toFinset.mp mem))
      hq1 (fun _ _ => Share.toReal_nonneg _) fun h mem zero =>
        ruledOut h (List.mem_toFinset.mp mem)
          (weight_zero_of_jointShare_zero prior lik os rec distinct (List.mem_toFinset.mp mem)
            zero)]
  constructor
  · intro all h mem
    rw [givenShare_eq_posterior prior lik os rec distinct mem]
    exact all h (List.mem_toFinset.mpr mem)
  · intro all h mem
    rw [← givenShare_eq_posterior prior lik os rec distinct (List.mem_toFinset.mp mem)]
    exact all h (List.mem_toFinset.mp mem)

/-- **The free energy at the core's share given the record is the surprisal of the record's
share**, where the record weighs something. Where it weighs nothing, both sides are 0 by Mathlib's
conventions; the hypothesis excludes that case. -/
theorem freeEnergy_givenShare [DecidableEq α] (prior : α → ℕ) (lik : α → β → ℕ) {hs : List α}
    (os : List β) (rec : β → Bool) (distinct : Distinct hs)
    (positive : 0 < mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)) :
    freeEnergy hs.toFinset
        (fun h => (share (openSteps hs os)
          (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
          (fun c => decide (c.1 = h))).toReal)
        (fun h => (share (openSteps hs os) (pairWeight prior lik)
          (fun c => decide (c.1 = h) && rec c.2)).toReal) =
      surprisal (share (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)).toReal := by
  have same : ∀ h ∈ hs.toFinset,
      (share (openSteps hs os)
          (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
          (fun c => decide (c.1 = h))).toReal =
        posterior hs.toFinset (fun h => (share (openSteps hs os) (pairWeight prior lik)
          (fun c => decide (c.1 = h) && rec c.2)).toReal) h :=
    fun h mem => givenShare_eq_posterior prior lik os rec distinct (List.mem_toFinset.mp mem)
  have total : 0 < ∑ h ∈ hs.toFinset, (share (openSteps hs os) (pairWeight prior lik)
      (fun c => decide (c.1 = h) && rec c.2)).toReal := by
    rw [sum_jointShare prior lik os rec distinct]
    exact share_toReal_pos _ _ _ positive
  rw [freeEnergy_congr hs.toFinset _ same, ← sum_jointShare prior lik os rec distinct]
  exact freeEnergy_posterior hs.toFinset _ (fun _ _ => Share.toReal_nonneg _) total

/-- **The core's share given the record is the one belief with the least free energy**: a belief
`q` over the listed hypotheses (nonnegative, with total one, zero wherever a hypothesis's prior
weight times the record's weight under it is zero; such a belief exists only where the record
weighs something, `record_pos_of_belief`) has the least free energy against the joint shares among
such beliefs exactly where it is, at every listed hypothesis, the share given the record. -/
theorem minimizes_iff_givenShare [DecidableEq α] (prior : α → ℕ) (lik : α → β → ℕ)
    {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs)
    (q : α → ℝ) (hq : ∀ h ∈ hs, 0 ≤ q h) (hq1 : ∑ h ∈ hs.toFinset, q h = 1)
    (ruledOut : ∀ h ∈ hs, prior h * mass os (lik h) rec = 0 → q h = 0) :
    (∀ q' : α → ℝ, (∀ h ∈ hs, 0 ≤ q' h) → ∑ h ∈ hs.toFinset, q' h = 1 →
        (∀ h ∈ hs, prior h * mass os (lik h) rec = 0 → q' h = 0) →
        freeEnergy hs.toFinset q (fun h => (share (openSteps hs os) (pairWeight prior lik)
            (fun c => decide (c.1 = h) && rec c.2)).toReal) ≤
          freeEnergy hs.toFinset q' (fun h => (share (openSteps hs os) (pairWeight prior lik)
            (fun c => decide (c.1 = h) && rec c.2)).toReal)) ↔
      ∀ h ∈ hs, q h = (share (openSteps hs os)
        (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h))).toReal := by
  have positive := record_pos_of_belief prior lik os rec distinct q hq1 ruledOut
  have bound := record_surprisal_le_freeEnergy prior lik os rec distinct q hq hq1 ruledOut
  have equal := freeEnergy_eq_record_surprisal_iff prior lik os rec distinct q hq hq1 ruledOut
  constructor
  · intro least
    have each : ∀ h ∈ hs.toFinset,
        (share (openSteps hs os)
            (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
            (fun c => decide (c.1 = h))).toReal =
          posterior hs.toFinset (fun h => (share (openSteps hs os) (pairWeight prior lik)
            (fun c => decide (c.1 = h) && rec c.2)).toReal) h :=
      fun h mem => givenShare_eq_posterior prior lik os rec distinct (List.mem_toFinset.mp mem)
    have total : ∑ h ∈ hs.toFinset, (share (openSteps hs os)
        (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h))).toReal = 1 := by
      rw [Finset.sum_congr rfl each]
      apply sum_posterior
      rw [sum_jointShare prior lik os rec distinct]
      exact (share_toReal_pos _ _ _ positive).ne'
    have le := least _ (fun _ _ => Share.toReal_nonneg _) total fun h mem zero => by
      rw [givenShare_toReal prior lik os rec distinct mem, zero, Nat.cast_zero, zero_div]
    rw [freeEnergy_givenShare prior lik os rec distinct positive] at le
    exact equal.mp (le_antisymm le bound)
  · intro same q' hq' hq1' ruledOut'
    rw [equal.mpr same]
    exact record_surprisal_le_freeEnergy prior lik os rec distinct q' hq' hq1' ruledOut'

/-- **Surprisal adds over independent parts** (`share_product`): over the pairs of two listed
domains weighted by products, where each of two events weighs something, the surprisal of the
share of both is the sum of their surprisals. -/
theorem surprisal_product (w₁ : α → ℕ) (w₂ : β → ℕ) (e₁ : α → Bool) (e₂ : β → Bool)
    (xs : List α) (ys : List β) (positive₁ : 0 < mass xs w₁ e₁)
    (positive₂ : 0 < mass ys w₂ e₂) :
    surprisal (share (openSteps xs ys) (fun c => w₁ c.1 * w₂ c.2)
        (fun c => e₁ c.1 && e₂ c.2)).toReal =
      surprisal (share xs w₁ e₁).toReal + surprisal (share ys w₂ e₂).toReal := by
  rw [share_product, Share.toReal_mul]
  unfold surprisal
  rw [Real.log_mul (share_toReal_pos xs w₁ e₁ positive₁).ne'
    (share_toReal_pos ys w₂ e₂ positive₂).ne']
  ring

end Core

/-! ## The counting form, through the logarithm -/

section Counts

open Becoming.ConditionalWeights

variable {α : Type}

/-- **A belief in counts**: each count over the total of the counts over the listing, as a real
number. -/
noncomputable def countBelief (hs : List α) (n : α → ℕ) (h : α) : ℝ :=
  (n h : ℝ) / (Becoming.total hs n : ℝ)

/-- The cast of a total over a list without repetition is the sum over its members. -/
theorem cast_total [DecidableEq α] (f : α → ℕ) :
    ∀ {hs : List α}, Distinct hs → ((Becoming.total hs f : ℕ) : ℝ) = ∑ h ∈ hs.toFinset, (f h : ℝ)
  | [], _ => by simp [Becoming.total]
  | g :: t, ⟨fresh, rest⟩ => by
    rw [List.toFinset_cons, Finset.sum_insert (fun inside => fresh (List.mem_toFinset.mp inside))]
    show ((f g + Becoming.total t f : ℕ) : ℝ) = _
    rw [Nat.cast_add, cast_total f rest]

/-- The cast of a product of powers over a list without repetition is the product over its
members. -/
theorem cast_powerProduct [DecidableEq α] (a n : α → ℕ) :
    ∀ {hs : List α}, Distinct hs →
      ((FreeEnergyCounting.powerProduct a n hs : ℕ) : ℝ) = ∏ h ∈ hs.toFinset, (a h : ℝ) ^ n h
  | [], _ => by simp [FreeEnergyCounting.powerProduct]
  | g :: t, ⟨fresh, rest⟩ => by
    rw [List.toFinset_cons, Finset.prod_insert (fun inside => fresh (List.mem_toFinset.mp inside))]
    show ((a g ^ n g * FreeEnergyCounting.powerProduct a n t : ℕ) : ℝ) = _
    rw [Nat.cast_mul, Nat.cast_pow, cast_powerProduct a n rest]

/-- **Counts with a positive total, none where the weight is nothing, have weights with a positive
total.** -/
theorem total_pos_of_counts (n a : α → ℕ) :
    ∀ {hs : List α}, 0 < Becoming.total hs n → (∀ h ∈ hs, a h = 0 → n h = 0) →
      0 < Becoming.total hs a
  | [], positive, _ => absurd positive (Nat.lt_irrefl 0)
  | g :: t, positive, support => by
    have whole : 0 < n g + Becoming.total t n := positive
    show 0 < a g + Becoming.total t a
    by_cases ng : n g = 0
    · have rest := total_pos_of_counts n a (hs := t) (by omega)
        (fun h mem => support h (.tail _ mem))
      omega
    · have : a g ≠ 0 := fun zero => ng (support g (.head _) zero)
      omega

/-- **The product of powers is positive where no count falls on a weight of nothing.** -/
theorem powerProduct_pos (a n : α → ℕ) :
    ∀ {hs : List α}, (∀ h ∈ hs, a h = 0 → n h = 0) → 0 < FreeEnergyCounting.powerProduct a n hs
  | [], _ => Nat.one_pos
  | g :: t, support => by
    show 0 < a g ^ n g * FreeEnergyCounting.powerProduct a n t
    refine Nat.mul_pos ?_ (powerProduct_pos a n fun h mem => support h (.tail _ mem))
    by_cases ng : n g = 0
    · rw [ng, pow_zero]
      exact Nat.one_pos
    · exact pow_pos (Nat.pos_of_ne_zero fun zero => ng (support g (.head _) zero)) _

/-- A belief in counts is nonnegative. -/
theorem countBelief_nonneg (hs : List α) (n : α → ℕ) (h : α) : 0 ≤ countBelief hs n h :=
  div_nonneg (Nat.cast_nonneg _) (Nat.cast_nonneg _)

/-- A belief in counts with a positive total has total one over the listed hypotheses. -/
theorem sum_countBelief [DecidableEq α] (n : α → ℕ) {hs : List α} (distinct : Distinct hs)
    (positive : 0 < Becoming.total hs n) : ∑ h ∈ hs.toFinset, countBelief hs n h = 1 := by
  unfold countBelief
  rw [← Finset.sum_div, ← cast_total n distinct]
  exact div_self (Nat.cast_ne_zero.mpr positive.ne')

/-- A belief in counts is zero wherever the weight is, where no count falls on a weight of
nothing. -/
theorem countBelief_support [DecidableEq α] (n a : α → ℕ) {hs : List α}
    (support : ∀ h ∈ hs, a h = 0 → n h = 0) :
    ∀ h ∈ hs.toFinset, (a h : ℝ) = 0 → countBelief hs n h = 0 := fun h mem zero => by
  rw [countBelief, support h (List.mem_toFinset.mp mem) (by exact_mod_cast zero), Nat.cast_zero,
    zero_div]

/-- A count to its own power is not zero, as a real number. -/
theorem self_pow_ne_zero (k : ℕ) : ((k : ℝ) ^ k) ≠ 0 := by
  rcases Nat.eq_zero_or_pos k with zero | pos
  · rw [zero, pow_zero]
    exact one_ne_zero
  · exact pow_ne_zero _ (Nat.cast_ne_zero.mpr pos.ne')

/-- **The free-energy gap at a belief in counts is the logarithm of the counting bound's ratio.**
For counts `n` over hypotheses listed once, with a positive total `N`, and natural joint weights
`a`, with no count where the weight is nothing: `N` times the free energy of the belief `n / N`
less the surprisal of the total weight is `log (A ^ N * ∏ n ^ n) − log (N ^ N * ∏ a ^ n)`, the
logarithms of the two sides of the counting bound (`FreeEnergyCounting.bound`). -/
theorem gap_counts [DecidableEq α] (n a : α → ℕ) {hs : List α} (distinct : Distinct hs)
    (positive : 0 < Becoming.total hs n) (support : ∀ h ∈ hs, a h = 0 → n h = 0) :
    (Becoming.total hs n : ℝ) *
        (freeEnergy hs.toFinset (countBelief hs n) (fun h => (a h : ℝ)) -
          surprisal (∑ h ∈ hs.toFinset, (a h : ℝ))) =
      Real.log ((Becoming.total hs a ^ Becoming.total hs n *
          FreeEnergyCounting.powerProduct n n hs : ℕ) : ℝ) -
        Real.log ((Becoming.total hs n ^ Becoming.total hs n *
          FreeEnergyCounting.powerProduct a n hs : ℕ) : ℝ) := by
  have hN := cast_total n distinct
  have hA := cast_total a distinct
  have Npos : (0 : ℝ) < Becoming.total hs n := Nat.cast_pos.mpr positive
  have Apos : (0 : ℝ) < Becoming.total hs a :=
    Nat.cast_pos.mpr (total_pos_of_counts n a positive support)
  have weightPow : ∀ h ∈ hs.toFinset, (a h : ℝ) ^ n h ≠ 0 := fun h mem => by
    by_cases nh : n h = 0
    · rw [nh, pow_zero]
      exact one_ne_zero
    · exact pow_ne_zero _ (Nat.cast_ne_zero.mpr fun zero =>
        nh (support h (List.mem_toFinset.mp mem) zero))
  have key : (Becoming.total hs n : ℝ) *
      freeEnergy hs.toFinset (countBelief hs n) (fun h => (a h : ℝ)) =
        ∑ h ∈ hs.toFinset, (n h : ℝ) * Real.log (n h) -
          ∑ h ∈ hs.toFinset, (n h : ℝ) * Real.log (a h) -
            (Becoming.total hs n : ℝ) * Real.log (Becoming.total hs n) := by
    unfold freeEnergy countBelief
    rw [Finset.mul_sum]
    have term : ∀ h ∈ hs.toFinset, (Becoming.total hs n : ℝ) *
        ((n h : ℝ) / (Becoming.total hs n : ℝ) *
          (Real.log ((n h : ℝ) / (Becoming.total hs n : ℝ)) - Real.log (a h))) =
        (n h : ℝ) * Real.log (n h) - (n h : ℝ) * Real.log (a h) -
          (n h : ℝ) * Real.log (Becoming.total hs n) := by
      intro h _
      by_cases zero : n h = 0
      · simp [zero]
      · rw [Real.log_div (Nat.cast_ne_zero.mpr zero) Npos.ne']
        field_simp
        ring
    rw [Finset.sum_congr rfl term, Finset.sum_sub_distrib, Finset.sum_sub_distrib,
      ← Finset.sum_mul, ← hN]
  rw [Nat.cast_mul, Nat.cast_mul, Nat.cast_pow, Nat.cast_pow, cast_powerProduct n n distinct,
    cast_powerProduct a n distinct,
    Real.log_mul (pow_ne_zero _ Apos.ne') (Finset.prod_ne_zero_iff.mpr fun h _ => self_pow_ne_zero _),
    Real.log_mul (pow_ne_zero _ Npos.ne') (Finset.prod_ne_zero_iff.mpr weightPow),
    Real.log_prod (fun h _ => self_pow_ne_zero _), Real.log_prod weightPow,
    Real.log_pow, Real.log_pow, mul_sub, key]
  simp only [Real.log_pow]
  unfold surprisal
  rw [← hA]
  ring

/-- The counting bound's left side is positive where no count falls on a weight of nothing. -/
theorem counting_lhs_pos (n a : α → ℕ) {hs : List α} (support : ∀ h ∈ hs, a h = 0 → n h = 0) :
    0 < Becoming.total hs n ^ Becoming.total hs n * FreeEnergyCounting.powerProduct a n hs :=
  Nat.mul_pos (FreeEnergyCounting.self_pow_pos _) (powerProduct_pos a n support)

/-- **The real bound at a belief in counts, from the core's counting bound**: under the
hypotheses of `gap_counts`, the surprisal of the total weight is at most the free energy, as
`surprisal_le_freeEnergy` states, here read from `FreeEnergyCounting.bound` through the logarithm.
-/
theorem surprisal_le_freeEnergy_of_counts [DecidableEq α] (n a : α → ℕ) {hs : List α}
    (distinct : Distinct hs) (positive : 0 < Becoming.total hs n)
    (support : ∀ h ∈ hs, a h = 0 → n h = 0) :
    surprisal (∑ h ∈ hs.toFinset, (a h : ℝ)) ≤
      freeEnergy hs.toFinset (countBelief hs n) (fun h => (a h : ℝ)) := by
  have gap := gap_counts n a distinct positive support
  have le := Real.log_le_log (Nat.cast_pos.mpr (counting_lhs_pos n a support))
    (Nat.cast_le.mpr (FreeEnergyCounting.bound n a hs))
  have Npos : (0 : ℝ) < Becoming.total hs n := Nat.cast_pos.mpr positive
  nlinarith

/-- **Equality exactly in proportion, from the core**: under the hypotheses of `gap_counts`, the
free energy of the belief in counts is the surprisal of the total weight exactly where the counts
are proportional to the weights, `n h * A = a h * N` at every listed hypothesis
(`FreeEnergyCounting.bound_eq_iff`). -/
theorem freeEnergy_eq_surprisal_iff_of_counts [DecidableEq α] (n a : α → ℕ) {hs : List α}
    (distinct : Distinct hs) (positive : 0 < Becoming.total hs n)
    (support : ∀ h ∈ hs, a h = 0 → n h = 0) :
    freeEnergy hs.toFinset (countBelief hs n) (fun h => (a h : ℝ)) =
        surprisal (∑ h ∈ hs.toFinset, (a h : ℝ)) ↔
      ∀ h, h ∈ hs → n h * Becoming.total hs a = a h * Becoming.total hs n := by
  rw [← FreeEnergyCounting.bound_eq_iff n a hs]
  have gap := gap_counts n a distinct positive support
  have Lpos := counting_lhs_pos n a support
  have Rpos := Nat.lt_of_lt_of_le Lpos (FreeEnergyCounting.bound n a hs)
  have Npos : (0 : ℝ) < Becoming.total hs n := Nat.cast_pos.mpr positive
  constructor
  · intro equal
    rw [equal, sub_self, mul_zero] at gap
    have logs : Real.log ((Becoming.total hs n ^ Becoming.total hs n *
        FreeEnergyCounting.powerProduct a n hs : ℕ) : ℝ) =
        Real.log ((Becoming.total hs a ^ Becoming.total hs n *
          FreeEnergyCounting.powerProduct n n hs : ℕ) : ℝ) := by linarith
    exact_mod_cast Real.log_injOn_pos (Set.mem_Ioi.mpr (Nat.cast_pos.mpr Lpos))
      (Set.mem_Ioi.mpr (Nat.cast_pos.mpr Rpos)) logs
  · intro equal
    rw [equal, sub_self] at gap
    rcases mul_eq_zero.mp gap with zero | zero
    · exact absurd zero Npos.ne'
    · linarith

/-- **Away from proportion the real bound is strict, from the core**: under the hypotheses of
`gap_counts` (`FreeEnergyCounting.bound_lt_of_not_proportional`). -/
theorem surprisal_lt_freeEnergy_of_counts [DecidableEq α] (n a : α → ℕ) {hs : List α}
    (distinct : Distinct hs) (positive : 0 < Becoming.total hs n)
    (support : ∀ h ∈ hs, a h = 0 → n h = 0)
    (apart : ¬ ∀ h, h ∈ hs → n h * Becoming.total hs a = a h * Becoming.total hs n) :
    surprisal (∑ h ∈ hs.toFinset, (a h : ℝ)) <
      freeEnergy hs.toFinset (countBelief hs n) (fun h => (a h : ℝ)) := by
  have gap := gap_counts n a distinct positive support
  have lt := Real.log_lt_log (Nat.cast_pos.mpr (counting_lhs_pos n a support))
    (Nat.cast_lt.mpr (FreeEnergyCounting.bound_lt_of_not_proportional n a hs apart))
  have Npos : (0 : ℝ) < Becoming.total hs n := Nat.cast_pos.mpr positive
  nlinarith

/-- **The two bounds are one at a belief in counts**: under the hypotheses of `gap_counts`, the
surprisal of the total weight is at most the free energy exactly where the counting bound holds.
Neither bound is used: the equivalence is `gap_counts` and the logarithm's order. -/
theorem surprisal_le_freeEnergy_iff_bound [DecidableEq α] (n a : α → ℕ) {hs : List α}
    (distinct : Distinct hs) (positive : 0 < Becoming.total hs n)
    (support : ∀ h ∈ hs, a h = 0 → n h = 0) :
    surprisal (∑ h ∈ hs.toFinset, (a h : ℝ)) ≤
        freeEnergy hs.toFinset (countBelief hs n) (fun h => (a h : ℝ)) ↔
      Becoming.total hs n ^ Becoming.total hs n * FreeEnergyCounting.powerProduct a n hs ≤
        Becoming.total hs a ^ Becoming.total hs n * FreeEnergyCounting.powerProduct n n hs := by
  have gap := gap_counts n a distinct positive support
  have Lpos := counting_lhs_pos n a support
  have Npos : (0 : ℝ) < Becoming.total hs n := Nat.cast_pos.mpr positive
  have Rpos : 0 < Becoming.total hs a ^ Becoming.total hs n *
      FreeEnergyCounting.powerProduct n n hs :=
    Nat.mul_pos (pow_pos (total_pos_of_counts n a positive support) _)
      (FreeEnergyCounting.powerProduct_self_pos n hs)
  constructor
  · intro le
    have logs : Real.log ((Becoming.total hs n ^ Becoming.total hs n *
        FreeEnergyCounting.powerProduct a n hs : ℕ) : ℝ) ≤
        Real.log ((Becoming.total hs a ^ Becoming.total hs n *
          FreeEnergyCounting.powerProduct n n hs : ℕ) : ℝ) := by nlinarith
    exact_mod_cast (Real.log_le_log_iff (Nat.cast_pos.mpr Lpos) (Nat.cast_pos.mpr Rpos)).mp logs
  · intro le
    have logs := Real.log_le_log (Nat.cast_pos.mpr Lpos) (Nat.cast_le.mpr le)
    nlinarith

/-- **The core's proportion is the posterior**: under the hypotheses of `gap_counts`, the counts
are proportional to the weights exactly where the belief in counts is, at every listed
hypothesis, the posterior of the weights, the case of equality of `freeEnergy_eq_surprisal_iff`.
-/
theorem proportional_iff_posterior [DecidableEq α] (n a : α → ℕ) {hs : List α}
    (distinct : Distinct hs) (positive : 0 < Becoming.total hs n)
    (support : ∀ h ∈ hs, a h = 0 → n h = 0) :
    (∀ h, h ∈ hs → n h * Becoming.total hs a = a h * Becoming.total hs n) ↔
      ∀ h ∈ hs.toFinset, countBelief hs n h = posterior hs.toFinset (fun h => (a h : ℝ)) h := by
  have Npos : (0 : ℝ) < Becoming.total hs n := Nat.cast_pos.mpr positive
  have Apos : (0 : ℝ) < Becoming.total hs a :=
    Nat.cast_pos.mpr (total_pos_of_counts n a positive support)
  simp only [countBelief, posterior]
  rw [← cast_total a distinct]
  constructor
  · intro prop h mem
    rw [div_eq_div_iff Npos.ne' Apos.ne']
    exact_mod_cast prop h (List.mem_toFinset.mp mem)
  · intro equal h mem
    have each := equal h (List.mem_toFinset.mpr mem)
    rw [div_eq_div_iff Npos.ne' Apos.ne'] at each
    exact_mod_cast each

/-- **The counting bound's log ratio is `N` times the divergence from the posterior**: under the
hypotheses of `gap_counts`, `N · D(n / N ‖ a / A) = log (A ^ N * ∏ n ^ n) − log (N ^ N * ∏ a ^ n)`.
-/
theorem divergence_counts [DecidableEq α] (n a : α → ℕ) {hs : List α} (distinct : Distinct hs)
    (positive : 0 < Becoming.total hs n) (support : ∀ h ∈ hs, a h = 0 → n h = 0) :
    (Becoming.total hs n : ℝ) *
        divergence hs.toFinset (countBelief hs n) (posterior hs.toFinset (fun h => (a h : ℝ))) =
      Real.log ((Becoming.total hs a ^ Becoming.total hs n *
          FreeEnergyCounting.powerProduct n n hs : ℕ) : ℝ) -
        Real.log ((Becoming.total hs n ^ Becoming.total hs n *
          FreeEnergyCounting.powerProduct a n hs : ℕ) : ℝ) := by
  have total : ∑ h ∈ hs.toFinset, (a h : ℝ) ≠ 0 := by
    rw [← cast_total a distinct]
    exact Nat.cast_ne_zero.mpr (total_pos_of_counts n a positive support).ne'
  rw [← gap_counts n a distinct positive support,
    freeEnergy_eq_divergence_add_surprisal hs.toFinset (countBelief hs n) (fun h => (a h : ℝ))
      (sum_countBelief n distinct positive) (countBelief_support n a support) total]
  ring

/-- **The counting bound's two sides differ by the exponential of `N` times the divergence**: under
the hypotheses of `gap_counts`,
`N ^ N * ∏ a ^ n = A ^ N * ∏ n ^ n * exp (−N · D(n / N ‖ a / A))`. -/
theorem counts_eq_mul_exp [DecidableEq α] (n a : α → ℕ) {hs : List α} (distinct : Distinct hs)
    (positive : 0 < Becoming.total hs n) (support : ∀ h ∈ hs, a h = 0 → n h = 0) :
    ((Becoming.total hs n ^ Becoming.total hs n * FreeEnergyCounting.powerProduct a n hs : ℕ) :
        ℝ) =
      ((Becoming.total hs a ^ Becoming.total hs n * FreeEnergyCounting.powerProduct n n hs : ℕ) :
          ℝ) *
        Real.exp (-((Becoming.total hs n : ℝ) *
          divergence hs.toFinset (countBelief hs n) (posterior hs.toFinset (fun h => (a h : ℝ))))) := by
  have Lpos := counting_lhs_pos n a support
  have Rpos := Nat.lt_of_lt_of_le Lpos (FreeEnergyCounting.bound n a hs)
  rw [divergence_counts n a distinct positive support, neg_sub, Real.exp_sub,
    Real.exp_log (Nat.cast_pos.mpr Lpos), Real.exp_log (Nat.cast_pos.mpr Rpos)]
  field_simp

/-! ### In the core's generative model -/

variable {β : Type}

/-- **The gap in the core's generative model is the logarithm of the counting bound's ratio
given the record.** With the hypotheses listed once, for a belief in counts with a positive total
and no count on a hypothesis whose prior weight times the record's weight under it is nothing: `N`
times the free energy against the joint shares less the surprisal of the record's share (the
terms of `record_surprisal_le_freeEnergy`) is `log (E ^ N * ∏ n ^ n) − log (N ^ N * ∏ joint ^ n)`,
`E` the record's weight, the two sides of `FreeEnergyCounting.bound_given_record`. The whole weight
by which the shares divide drops out (`gap_div`). -/
theorem gap_counts_given_record [DecidableEq α] (prior : α → ℕ) (lik : α → β → ℕ) {hs : List α}
    (os : List β) (rec : β → Bool) (distinct : Distinct hs) (n : α → ℕ)
    (positive : 0 < Becoming.total hs n)
    (ruledOut : ∀ h ∈ hs, prior h * mass os (lik h) rec = 0 → n h = 0) :
    (Becoming.total hs n : ℝ) *
        (freeEnergy hs.toFinset (countBelief hs n) (fun h => (share (openSteps hs os)
            (pairWeight prior lik) (fun c => decide (c.1 = h) && rec c.2)).toReal) -
          surprisal (share (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)).toReal) =
      Real.log ((mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) ^
          Becoming.total hs n * FreeEnergyCounting.powerProduct n n hs : ℕ) : ℝ) -
        Real.log ((Becoming.total hs n ^ Becoming.total hs n *
          FreeEnergyCounting.powerProduct (FreeEnergyCounting.joint prior lik os rec) n hs : ℕ) :
            ℝ) := by
  have support : ∀ h ∈ hs, FreeEnergyCounting.joint prior lik os rec h = 0 → n h = 0 := ruledOut
  have Epos := total_pos_of_counts n _ positive support
  have within : mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) ≤
      mass (openSteps hs os) (pairWeight prior lik) (fun _ => true) :=
    share_within (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)
  have Wne : ((mass (openSteps hs os) (pairWeight prior lik) (fun _ => true) : ℕ) : ℝ) ≠ 0 := by
    rw [FreeEnergyCounting.record_total prior lik hs os rec] at within
    exact Nat.cast_ne_zero.mpr (Nat.lt_of_lt_of_le Epos within).ne'
  have each : ∀ h ∈ hs.toFinset, (share (openSteps hs os) (pairWeight prior lik)
      (fun c => decide (c.1 = h) && rec c.2)).toReal =
        (FreeEnergyCounting.joint prior lik os rec h : ℝ) /
          ((mass (openSteps hs os) (pairWeight prior lik) (fun _ => true) : ℕ) : ℝ) :=
    fun h mem => jointShare_toReal prior lik os rec distinct (List.mem_toFinset.mp mem)
  have record : (share (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)).toReal =
      ∑ h ∈ hs.toFinset, (FreeEnergyCounting.joint prior lik os rec h : ℝ) /
        ((mass (openSteps hs os) (pairWeight prior lik) (fun _ => true) : ℕ) : ℝ) := by
    show ((mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) : ℕ) : ℝ) /
      ((mass (openSteps hs os) (pairWeight prior lik) (fun _ => true) : ℕ) : ℝ) = _
    rw [FreeEnergyCounting.record_total prior lik hs os rec, cast_total _ distinct, Finset.sum_div]
  have total : ∑ h ∈ hs.toFinset, (FreeEnergyCounting.joint prior lik os rec h : ℝ) ≠ 0 := by
    rw [← cast_total _ distinct]
    exact Nat.cast_ne_zero.mpr Epos.ne'
  rw [freeEnergy_congr_weights _ _ each, record,
    gap_div hs.toFinset (countBelief hs n) (fun h => (FreeEnergyCounting.joint prior lik os rec h : ℝ))
      (sum_countBelief n distinct positive) (countBelief_support n _ support) total Wne,
    FreeEnergyCounting.record_total prior lik hs os rec]
  exact gap_counts n _ distinct positive support

/-- **A share is the same ratio as another exactly where the two are equal as real numbers**,
where both wholes are positive. -/
theorem _root_.Becoming.ConditionalWeights.Share.same_iff_toReal_eq (a b : Share)
    (ha : 0 < a.whole) (hb : 0 < b.whole) : Share.Same a b ↔ a.toReal = b.toReal := by
  unfold Share.Same Share.toReal
  rw [div_eq_div_iff (Nat.cast_ne_zero.mpr ha.ne') (Nat.cast_ne_zero.mpr hb.ne')]
  constructor
  · intro same
    exact_mod_cast same
  · intro equal
    exact_mod_cast equal

/-- **Equality given the record, from the core**: under the hypotheses of
`gap_counts_given_record`, the free energy against the joint shares is the surprisal of the
record's share exactly where every count over the total is the same ratio as the hypothesis's
share given the record (`FreeEnergyCounting.given_record_eq_iff_share`); as real numbers, that is
where the belief in counts is the share given the record, as `freeEnergy_eq_record_surprisal_iff`
states (`freeEnergy_eq_record_surprisal_iff_toReal_of_counts`). -/
theorem freeEnergy_eq_record_surprisal_iff_of_counts [DecidableEq α] (prior : α → ℕ)
    (lik : α → β → ℕ) {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs)
    (n : α → ℕ) (positive : 0 < Becoming.total hs n)
    (ruledOut : ∀ h ∈ hs, prior h * mass os (lik h) rec = 0 → n h = 0) :
    freeEnergy hs.toFinset (countBelief hs n) (fun h => (share (openSteps hs os)
        (pairWeight prior lik) (fun c => decide (c.1 = h) && rec c.2)).toReal) =
        surprisal (share (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)).toReal ↔
      ∀ h, h ∈ hs → Share.Same ⟨n h, Becoming.total hs n⟩ (share (openSteps hs os)
        (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h))) := by
  rw [← FreeEnergyCounting.given_record_eq_iff_share prior lik os rec n distinct]
  have support : ∀ h ∈ hs, FreeEnergyCounting.joint prior lik os rec h = 0 → n h = 0 := ruledOut
  have gap := gap_counts_given_record prior lik os rec distinct n positive ruledOut
  have Lpos := counting_lhs_pos n _ support
  have Rpos := Nat.lt_of_lt_of_le Lpos
    (FreeEnergyCounting.bound_given_record prior lik hs os rec n)
  have Npos : (0 : ℝ) < Becoming.total hs n := Nat.cast_pos.mpr positive
  constructor
  · intro equal
    rw [equal, sub_self, mul_zero] at gap
    have logs : Real.log ((Becoming.total hs n ^ Becoming.total hs n *
        FreeEnergyCounting.powerProduct (FreeEnergyCounting.joint prior lik os rec) n hs : ℕ) :
          ℝ) =
        Real.log ((mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) ^
          Becoming.total hs n * FreeEnergyCounting.powerProduct n n hs : ℕ) : ℝ) := by linarith
    exact_mod_cast Real.log_injOn_pos (Set.mem_Ioi.mpr (Nat.cast_pos.mpr Lpos))
      (Set.mem_Ioi.mpr (Nat.cast_pos.mpr Rpos)) logs
  · intro equal
    rw [equal, sub_self] at gap
    rcases mul_eq_zero.mp gap with zero | zero
    · exact absurd zero Npos.ne'
    · linarith

/-- **Equality given the record as real numbers, from the core**: under the hypotheses of
`gap_counts_given_record`, the free energy against the joint shares is the surprisal of the
record's share exactly where the belief in counts is, at every listed hypothesis, the share given
the record, as `freeEnergy_eq_record_surprisal_iff` states; through
`freeEnergy_eq_record_surprisal_iff_of_counts` and `Share.same_iff_toReal_eq`, the share given the
record having the record's weight, positive here, as its whole (`whole_restrict`). -/
theorem freeEnergy_eq_record_surprisal_iff_toReal_of_counts [DecidableEq α] (prior : α → ℕ)
    (lik : α → β → ℕ) {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs)
    (n : α → ℕ) (positive : 0 < Becoming.total hs n)
    (ruledOut : ∀ h ∈ hs, prior h * mass os (lik h) rec = 0 → n h = 0) :
    freeEnergy hs.toFinset (countBelief hs n) (fun h => (share (openSteps hs os)
        (pairWeight prior lik) (fun c => decide (c.1 = h) && rec c.2)).toReal) =
        surprisal (share (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)).toReal ↔
      ∀ h ∈ hs, countBelief hs n h = (share (openSteps hs os)
        (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h))).toReal := by
  rw [freeEnergy_eq_record_surprisal_iff_of_counts prior lik os rec distinct n positive ruledOut]
  have Epos : 0 < mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) := by
    rw [FreeEnergyCounting.record_total prior lik hs os rec]
    exact total_pos_of_counts n _ positive ruledOut
  refine forall₂_congr fun h _ => ?_
  rw [Share.same_iff_toReal_eq _ _ positive
    (by rw [show (share (openSteps hs os)
          (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
          (fun c => decide (c.1 = h))).whole =
          mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2) from
        whole_restrict _ _ _]; exact Epos)]
  rfl

/-- **The bound given the record, from the core**: under the hypotheses of
`gap_counts_given_record`, the surprisal of the record's share is at most the free energy against
the joint shares, as `record_surprisal_le_freeEnergy` states, here read from
`FreeEnergyCounting.bound_given_record`. -/
theorem record_surprisal_le_freeEnergy_of_counts [DecidableEq α] (prior : α → ℕ)
    (lik : α → β → ℕ) {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs)
    (n : α → ℕ) (positive : 0 < Becoming.total hs n)
    (ruledOut : ∀ h ∈ hs, prior h * mass os (lik h) rec = 0 → n h = 0) :
    surprisal (share (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)).toReal ≤
      freeEnergy hs.toFinset (countBelief hs n) (fun h => (share (openSteps hs os)
        (pairWeight prior lik) (fun c => decide (c.1 = h) && rec c.2)).toReal) := by
  have gap := gap_counts_given_record prior lik os rec distinct n positive ruledOut
  have le := Real.log_le_log (Nat.cast_pos.mpr (counting_lhs_pos n _ ruledOut))
    (Nat.cast_le.mpr (FreeEnergyCounting.bound_given_record prior lik hs os rec n))
  have Npos : (0 : ℝ) < Becoming.total hs n := Nat.cast_pos.mpr positive
  nlinarith

/-- **Away from the share given the record the bound is strict, from the core**: under the
hypotheses of `gap_counts_given_record`, where some count over the total is not the same ratio as
its hypothesis's share given the record. -/
theorem record_surprisal_lt_freeEnergy_of_counts [DecidableEq α] (prior : α → ℕ)
    (lik : α → β → ℕ) {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs)
    (n : α → ℕ) (positive : 0 < Becoming.total hs n)
    (ruledOut : ∀ h ∈ hs, prior h * mass os (lik h) rec = 0 → n h = 0)
    (apart : ¬ ∀ h, h ∈ hs → Share.Same ⟨n h, Becoming.total hs n⟩ (share (openSteps hs os)
        (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h)))) :
    surprisal (share (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)).toReal <
      freeEnergy hs.toFinset (countBelief hs n) (fun h => (share (openSteps hs os)
        (pairWeight prior lik) (fun c => decide (c.1 = h) && rec c.2)).toReal) := by
  have gap := gap_counts_given_record prior lik os rec distinct n positive ruledOut
  have lt := Real.log_lt_log (Nat.cast_pos.mpr (counting_lhs_pos n _ ruledOut))
    (Nat.cast_lt.mpr (Nat.lt_of_le_of_ne
      (FreeEnergyCounting.bound_given_record prior lik hs os rec n)
      fun eq => apart ((FreeEnergyCounting.given_record_eq_iff_share prior lik os rec n
        distinct).mp eq)))
  have Npos : (0 : ℝ) < Becoming.total hs n := Nat.cast_pos.mpr positive
  nlinarith

end Counts

namespace Witness

/-- **Off the support the identity can fail**: counts one and one against weights nothing and one
(`FreeEnergyCounting.Witness.even`, `FreeEnergyCounting.Witness.secondOnly`). Under Mathlib's
`log 0 = 0`, `N` times the gap is `−2 log 2`, below nothing, so the real bound fails there; the
counting bound's left side is nothing and its right side one, so the core's bound holds strictly,
and the logarithm of its ratio is `log 1 − log 0 = 0`. -/
theorem gap_counts_off_support :
    (Becoming.total [true, false] FreeEnergyCounting.Witness.even : ℝ) *
        (freeEnergy [true, false].toFinset (countBelief [true, false] FreeEnergyCounting.Witness.even)
            (fun h => (FreeEnergyCounting.Witness.secondOnly h : ℝ)) -
          surprisal (∑ h ∈ [true, false].toFinset, (FreeEnergyCounting.Witness.secondOnly h : ℝ))) =
        -2 * Real.log 2 ∧
      Becoming.total [true, false] FreeEnergyCounting.Witness.even ^
          Becoming.total [true, false] FreeEnergyCounting.Witness.even *
          FreeEnergyCounting.powerProduct FreeEnergyCounting.Witness.secondOnly
            FreeEnergyCounting.Witness.even [true, false] = 0 ∧
      Becoming.total [true, false] FreeEnergyCounting.Witness.secondOnly ^
          Becoming.total [true, false] FreeEnergyCounting.Witness.even *
          FreeEnergyCounting.powerProduct FreeEnergyCounting.Witness.even
            FreeEnergyCounting.Witness.even [true, false] = 1 ∧
      Real.log ((Becoming.total [true, false] FreeEnergyCounting.Witness.secondOnly ^
          Becoming.total [true, false] FreeEnergyCounting.Witness.even *
          FreeEnergyCounting.powerProduct FreeEnergyCounting.Witness.even
            FreeEnergyCounting.Witness.even [true, false] : ℕ) : ℝ) -
        Real.log ((Becoming.total [true, false] FreeEnergyCounting.Witness.even ^
          Becoming.total [true, false] FreeEnergyCounting.Witness.even *
          FreeEnergyCounting.powerProduct FreeEnergyCounting.Witness.secondOnly
            FreeEnergyCounting.Witness.even [true, false] : ℕ) : ℝ) = 0 := by
  refine ⟨?_, by decide, by decide, ?_⟩
  · simp [freeEnergy, surprisal, countBelief, Becoming.total, FreeEnergyCounting.Witness.even,
      FreeEnergyCounting.Witness.secondOnly]
    ring
  · simp [Becoming.total, FreeEnergyCounting.powerProduct, FreeEnergyCounting.Witness.even,
      FreeEnergyCounting.Witness.secondOnly]

/-- **Off the support the identity can hold while the two equalities part**: at UE21's
off-support counts (`FreeEnergyCounting.Witness.first` against
`FreeEnergyCounting.Witness.secondOnly`), `N` times the gap equals the log ratio, the free energy is
the surprisal (so both are nothing), and the counts are not in proportion, so the core's bound is
strict (`FreeEnergyCounting.Witness.off_support`). -/
theorem one_count_off_support :
    (Becoming.total [true, false] FreeEnergyCounting.Witness.first : ℝ) *
        (freeEnergy [true, false].toFinset
            (countBelief [true, false] FreeEnergyCounting.Witness.first)
            (fun h => (FreeEnergyCounting.Witness.secondOnly h : ℝ)) -
          surprisal (∑ h ∈ [true, false].toFinset, (FreeEnergyCounting.Witness.secondOnly h : ℝ))) =
      Real.log ((Becoming.total [true, false] FreeEnergyCounting.Witness.secondOnly ^
          Becoming.total [true, false] FreeEnergyCounting.Witness.first *
          FreeEnergyCounting.powerProduct FreeEnergyCounting.Witness.first
            FreeEnergyCounting.Witness.first [true, false] : ℕ) : ℝ) -
        Real.log ((Becoming.total [true, false] FreeEnergyCounting.Witness.first ^
          Becoming.total [true, false] FreeEnergyCounting.Witness.first *
          FreeEnergyCounting.powerProduct FreeEnergyCounting.Witness.secondOnly
            FreeEnergyCounting.Witness.first [true, false] : ℕ) : ℝ) ∧
    freeEnergy [true, false].toFinset
        (countBelief [true, false] FreeEnergyCounting.Witness.first)
        (fun h => (FreeEnergyCounting.Witness.secondOnly h : ℝ)) =
      surprisal (∑ h ∈ [true, false].toFinset, (FreeEnergyCounting.Witness.secondOnly h : ℝ)) ∧
    ¬ (∀ h, h ∈ [true, false] →
        FreeEnergyCounting.Witness.first h *
            Becoming.total [true, false] FreeEnergyCounting.Witness.secondOnly =
          FreeEnergyCounting.Witness.secondOnly h *
            Becoming.total [true, false] FreeEnergyCounting.Witness.first) := by
  refine ⟨?_, ?_, by decide⟩
  · simp [freeEnergy, surprisal, countBelief, Becoming.total, FreeEnergyCounting.powerProduct,
      FreeEnergyCounting.Witness.first, FreeEnergyCounting.Witness.secondOnly]
  · simp [freeEnergy, surprisal, countBelief, Becoming.total, FreeEnergyCounting.Witness.first,
      FreeEnergyCounting.Witness.secondOnly]

/-- **A hypothesis listed twice breaks the identity**: with `true` listed twice and every count and
weight one, `N` times the gap is `−log 2`, the real side summing over the set of hypotheses, while
the log ratio, over the listing, is `0`. -/
theorem gap_counts_duplicate :
    (Becoming.total [true, true] (fun _ : Bool => 1) : ℝ) *
        (freeEnergy [true, true].toFinset (countBelief [true, true] (fun _ : Bool => 1))
            (fun h => ((fun _ : Bool => 1) h : ℝ)) -
          surprisal (∑ h ∈ [true, true].toFinset, ((fun _ : Bool => 1) h : ℝ))) = -Real.log 2 ∧
      Real.log ((Becoming.total [true, true] (fun _ : Bool => 1) ^
          Becoming.total [true, true] (fun _ : Bool => 1) *
          FreeEnergyCounting.powerProduct (fun _ : Bool => 1) (fun _ : Bool => 1) [true, true] : ℕ) :
            ℝ) -
        Real.log ((Becoming.total [true, true] (fun _ : Bool => 1) ^
          Becoming.total [true, true] (fun _ : Bool => 1) *
          FreeEnergyCounting.powerProduct (fun _ : Bool => 1) (fun _ : Bool => 1) [true, true] : ℕ) :
            ℝ) = 0 := by
  refine ⟨?_, sub_self _⟩
  simp [freeEnergy, surprisal, countBelief, Becoming.total]

end Witness

end Becoming.FreeEnergy
