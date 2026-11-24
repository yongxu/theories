import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Topology.Order.IntermediateValue
import Mathlib.Probability.Distributions.Gaussian.Real
import Mathlib.Tactic
import ObservationalFidelity

/-!
# Quantitative Transfer for Four Guarded-Runtime Failure Regimes (`QuantitativeTransfer`)

AI-written (Frontier 3, 24 November 2026). Formalized with Lean 4.30.0-rc2 and Mathlib over `ℝ`,
importing `ObservationalFidelity` (and through it `AlignmentReals`, `BecomingReals`,
`Becoming.OplaxHistory`). Every declaration depends only on Lean's three standard axioms
(`propext`, `Classical.choice`, `Quot.sound`), with `0` `sorryAx`, `0` `private` declarations,
`0` `lemma`/`class`/unnamed `instance` declarations, and `0` forbidden market words.

The neural stress lab (`experiments/neural-alignment-stress-lab/RESULTS.md` §4.2, §5.0) records
four regimes where the guarded runtime still breaks. For each, this module proves a limit together
with the theorem that shows the limit sits exactly at its stated threshold (a sharpness witness or
a remedy):

1. **Correlated judge pool (`FAIL_correlated_pool_drift`).** Scores `s i x = γ c x + (1 - γ) u i x`
   (a rank-1 shared term plus residuals in `[0, 1]`): internal disagreement is at most `1 - γ` for
   every pool size, the shared bias `γ |c x - t x| - (1 - γ)` survives averaging over every pool
   size (attained), and an anchor channel outside the drift detects what the pool cannot
   (`correlated_pool_blindness_vs_anchor`).
2. **Aliased probe (`FAIL_severe_aliasing`).** For `pα u = (1 - α) p u + α m (f u)` read with noise
   `ε`, two same-fiber states are separable by some rule iff `2ε < (1 - α) |p u₁ - p u₂|`
   (`aliased_separable_iff`); the predictor floor is derived from
   `ObservationalFidelity.fiber_split_readout_floor`, and a finite mixture version gives the
   two-point test floor `≥ α` over `ObservationalFidelity.tvDist` (attained).
3. **Lag horizon (`FAIL_long_lag`).** A reserve drawn down at rate `≥ H₁` reaches `x_crit` (mean
   value + intermediate value theorems) before a correction delayed by `L` can act whenever
   `(x₀ - x_crit) / H₁ < L`; exact for the linear trajectory (`lag_wall_iff_linear`). The policy's
   switching lag `M(ρ, η)` from feature leakage is strictly increasing in `ρ`.
4. **Trust region (`FAIL_high_lr`).** Projected steps `‖Δz‖ ≤ Δ_max` after an `α`-Lipschitz guard map
   give an `AlignmentReals.MetricLaxSim` (`trustRegionMetricLaxSim`), hence the tube
   `α ^ n d₀ + Δ_max (1 - α ^ n) / (1 - α)` (attained on `ℝ`) and a `Viability.Kernel` via
   `metric_laxSim_contraction_tube`; unprojected steps leave every bounded guard band in one step.
5. **Detector advantage (`Youden J = TPR - FPR`, finite and lag).** `youdenJ P₀ P₁ g = 1 - errSum`
   satisfies `|youdenJ P₀ P₁ g| ≤ tvDist P₀ P₁` (attained), caps same-fiber aliased mixtures at
   `(1 - α) tvDist (K u₁) (K u₂) ≤ 1 - α` (attained), and vanishes before `t* < L` under lag
   blindness (`lag_wall_youdenJ_zero`).
6. **Measure-theoretic `Youden J` and Gaussian-additive aliasing floor.** Over `Measure ℝ` and
   `ProbabilityTheory.gaussianReal`, Bhattacharyya + Cauchy-Schwarz + Hellinger bounds give
   `1 - exp (-Δ^2 / (8 v)) ≤ TV ≤ √(1 - exp (-Δ^2 / (4 v)))` with `|measYoudenJ| ≤ TV` (attained
   at the midpoint), positive error floor and `J` ceiling for `gaussianAliasedLaw`, sharpness at
   the midpoint, zero separation at `α = 1`, and the `B5` Gaussian lab witness.
7. **Zero-variance Dirac limit (`v = 0`).** At `v = 0`, `gaussianAliasedLaw` collapses to
   `Measure.dirac (aliasedProbe α p m f u)`, yielding an exact dichotomy on same-fiber states:
   zero advantage (`measYoudenJ = 0`, `measErrorSum = 1`) when `α = 1 ∨ p u₁ = p u₂`, and exact
   singleton separation (`measYoudenJ = 1`, `measErrorSum = 0`) when `α ≠ 1 ∧ p u₁ ≠ p u₂`.
8. **Multi-step (`T`-sample) sequential Gaussian aliasing & sample-complexity vs. lag-horizon wall.**
   Via `T`-fold convolution `convPow`, `gaussianSeqLaw` equals
   `gaussianReal (T * aliasedProbe ...) (T * v)` (with sample-mean pushforward `v / T`), yielding
   the `√T` Youden ceiling, sample-complexity lower bound `4 v J_target^2 / Δ^2 ≤ T`, `T`-sample
   midpoint sharpness, the joint lag-horizon vs. sample-complexity wall
   `sequential_gaussian_lag_sample_wall`, and the `B5` sequential witness (`T = 4` vs `T = 100`).

Applying any of these to the stress lab is a recognition, not a proof (Rule 2); see
`frontier3-quantitative-transfer-2026-11-24/PAPER-ATTACK.md`.
-/

namespace QuantitativeTransfer

open scoped BigOperators
open Set

/-! ## Part 1: Correlated Judge Pool — Rank-1 Disagreement Ceiling, Shared Bias Floor, Anchor -/

/-- Judge `i`'s score of course `x` under shared drift `γ`: a shared channel `c` plus a residual. -/
noncomputable def judgeScore {X : Type*} {M : ℕ} (γ : ℝ) (c : X → ℝ) (u : Fin M → X → ℝ)
    (i : Fin M) (x : X) : ℝ :=
  γ * c x + (1 - γ) * u i x

/-- Mean of the `M` residuals at course `x`. -/
noncomputable def residualMean {X : Type*} {M : ℕ} (u : Fin M → X → ℝ) (x : X) : ℝ :=
  (∑ i, u i x) / M

/-- Pool mean score at course `x`. -/
noncomputable def poolMean {X : Type*} {M : ℕ} (γ : ℝ) (c : X → ℝ) (u : Fin M → X → ℝ) (x : X) : ℝ :=
  (∑ i, judgeScore γ c u i x) / M

theorem poolMean_eq {X : Type*} {M : ℕ} (hM : 0 < M) (γ : ℝ) (c : X → ℝ) (u : Fin M → X → ℝ)
    (x : X) : poolMean γ c u x = γ * c x + (1 - γ) * residualMean u x := by
  have hM' : (M : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hM.ne'
  unfold poolMean residualMean judgeScore
  rw [Finset.sum_add_distrib, Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul,
    ← Finset.mul_sum]
  field_simp

theorem residualMean_mem {X : Type*} {M : ℕ} (hM : 0 < M) (u : Fin M → X → ℝ)
    (hu : ∀ i x, 0 ≤ u i x ∧ u i x ≤ 1) (x : X) :
    0 ≤ residualMean u x ∧ residualMean u x ≤ 1 := by
  have hMpos : (0 : ℝ) < M := Nat.cast_pos.mpr hM
  have hsum0 : 0 ≤ ∑ i, u i x := Finset.sum_nonneg fun i _ => (hu i x).1
  have hsum1 : ∑ i, u i x ≤ M := by
    calc ∑ i, u i x ≤ ∑ _i : Fin M, (1 : ℝ) := Finset.sum_le_sum fun i _ => (hu i x).2
      _ = M := by simp
  exact ⟨div_nonneg hsum0 hMpos.le, (div_le_one hMpos).mpr hsum1⟩

theorem judgeScore_sub {X : Type*} {M : ℕ} (γ : ℝ) (c : X → ℝ) (u : Fin M → X → ℝ) (i k : Fin M)
    (x : X) : judgeScore γ c u i x - judgeScore γ c u k x = (1 - γ) * (u i x - u k x) := by
  unfold judgeScore; ring

/-- Two values in `[0, 1]` differ by at most `1`. -/
theorem abs_sub_le_one_of_unit {a b : ℝ} (ha : 0 ≤ a ∧ a ≤ 1) (hb : 0 ≤ b ∧ b ≤ 1) : |a - b| ≤ 1 :=
  abs_le.mpr ⟨by linarith [ha.1, hb.2], by linarith [ha.2, hb.1]⟩

/-- A shared-channel score `γ c + (1 - γ) v` with `v ∈ [0, 1]` misses a truth `t ∈ [0, 1]` by at
least `γ |c - t| - (1 - γ)`. -/
theorem shared_score_bias_floor {γ c v t : ℝ} (hγ0 : 0 ≤ γ) (hγ1 : γ ≤ 1) (hv : 0 ≤ v ∧ v ≤ 1)
    (ht : 0 ≤ t ∧ t ≤ 1) : γ * |c - t| - (1 - γ) ≤ |γ * c + (1 - γ) * v - t| := by
  have hvt : |v - t| ≤ 1 := abs_sub_le_one_of_unit hv ht
  have hsplit : γ * c + (1 - γ) * v - t = γ * (c - t) + (1 - γ) * (v - t) := by ring
  have h1 : |γ * (c - t)| ≤ |γ * c + (1 - γ) * v - t| + |(1 - γ) * (v - t)| := by
    rw [hsplit]
    calc |γ * (c - t)| = |(γ * (c - t) + (1 - γ) * (v - t)) + (-((1 - γ) * (v - t)))| := by ring_nf
      _ ≤ |γ * (c - t) + (1 - γ) * (v - t)| + |-((1 - γ) * (v - t))| := abs_add_le _ _
      _ = _ := by rw [abs_neg]
  rw [abs_mul, abs_of_nonneg hγ0, abs_mul, abs_of_nonneg (by linarith : (0 : ℝ) ≤ 1 - γ)] at h1
  have h2 : (1 - γ) * |v - t| ≤ 1 - γ := by nlinarith
  linarith

/-- **Rank-1 Disagreement Ceiling (`pool_disagreement_ceiling`):** for every pool size, pairwise
disagreement and deviation from the pool mean are at most `1 - γ`, and courses the shared channel
conflates (`c x = c y`) have pool means within `1 - γ`. -/
theorem pool_disagreement_ceiling {X : Type*} {M : ℕ} {γ : ℝ} (hγ1 : γ ≤ 1)
    (c : X → ℝ) (u : Fin M → X → ℝ) (hu : ∀ i x, 0 ≤ u i x ∧ u i x ≤ 1) :
    (∀ i k x, |judgeScore γ c u i x - judgeScore γ c u k x| ≤ 1 - γ) ∧
    (∀ i x, |judgeScore γ c u i x - poolMean γ c u x| ≤ 1 - γ) ∧
    (0 < M → ∀ x y, c x = c y → |poolMean γ c u x - poolMean γ c u y| ≤ 1 - γ) := by
  have h1γ : 0 ≤ 1 - γ := by linarith
  refine ⟨fun i k x => ?_, fun i x => ?_, fun hM x y hc => ?_⟩
  · rw [judgeScore_sub, abs_mul, abs_of_nonneg h1γ]
    exact mul_le_of_le_one_right h1γ (abs_sub_le_one_of_unit (hu i x) (hu k x))
  · have hM : 0 < M := i.pos
    rw [poolMean_eq hM, show judgeScore γ c u i x - (γ * c x + (1 - γ) * residualMean u x) =
        (1 - γ) * (u i x - residualMean u x) by unfold judgeScore; ring, abs_mul, abs_of_nonneg h1γ]
    exact mul_le_of_le_one_right h1γ (abs_sub_le_one_of_unit (hu i x) (residualMean_mem hM u hu x))
  · rw [poolMean_eq hM, poolMean_eq hM, hc, show γ * c y + (1 - γ) * residualMean u x -
        (γ * c y + (1 - γ) * residualMean u y) = (1 - γ) * (residualMean u x - residualMean u y) by
        ring, abs_mul, abs_of_nonneg h1γ]
    exact mul_le_of_le_one_right h1γ
      (abs_sub_le_one_of_unit (residualMean_mem hM u hu x) (residualMean_mem hM u hu y))

/-- **Shared Bias Floor (`pool_shared_bias_floor`):** for every pool size `M ≥ 1`, the pool mean
misses the truth by at least `γ |c x - t x| - (1 - γ)`, and by exactly `γ |c x - t x|` when every
residual is truthful: the rank-1 shared term is not averaged away by adding judges. -/
theorem pool_shared_bias_floor {X : Type*} {M : ℕ} (hM : 0 < M) {γ : ℝ} (hγ0 : 0 ≤ γ)
    (hγ1 : γ ≤ 1) (c t : X → ℝ) (u : Fin M → X → ℝ) (hu : ∀ i x, 0 ≤ u i x ∧ u i x ≤ 1)
    (ht : ∀ x, 0 ≤ t x ∧ t x ≤ 1) :
    (∀ x, γ * |c x - t x| - (1 - γ) ≤ |poolMean γ c u x - t x|) ∧
    (∀ x, |poolMean γ c (fun (_ : Fin M) => t) x - t x| = γ * |c x - t x|) := by
  refine ⟨fun x => ?_, fun x => ?_⟩
  · rw [poolMean_eq hM]
    exact shared_score_bias_floor hγ0 hγ1 (residualMean_mem hM u hu x) (ht x)
  · have hMr : (M : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hM.ne'
    have hmean : residualMean (fun (_ : Fin M) => t) x = t x := by
      unfold residualMean; rw [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
      field_simp
    rw [poolMean_eq hM, hmean, show γ * c x + (1 - γ) * t x - t x = γ * (c x - t x) by ring,
      abs_mul, abs_of_nonneg hγ0]

/-- **Ceiling Attained (`pool_ceiling_attained`):** for `M ≥ 2` some residuals in `[0, 1]` reach
pairwise disagreement exactly `1 - γ`. -/
theorem pool_ceiling_attained {X : Type*} {M : ℕ} (hM : 2 ≤ M) {γ : ℝ} (hγ1 : γ ≤ 1)
    (c : X → ℝ) (x : X) :
    ∃ u : Fin M → X → ℝ, (∀ i y, 0 ≤ u i y ∧ u i y ≤ 1) ∧
      |judgeScore γ c u ⟨0, by omega⟩ x - judgeScore γ c u ⟨1, by omega⟩ x| = 1 - γ := by
  refine ⟨fun i _ => if i.val = 0 then 1 else 0, fun i y => by dsimp only; split_ifs <;> norm_num, ?_⟩
  rw [judgeScore_sub]
  show |(1 - γ) * ((if (0 : ℕ) = 0 then (1 : ℝ) else 0) - (if (1 : ℕ) = 0 then (1 : ℝ) else 0))| = 1 - γ
  rw [if_pos rfl, if_neg one_ne_zero, sub_zero, mul_one, abs_of_nonneg (by linarith)]

/-- **Anchor Remedy (`anchor_detects_shared_drift`):** an anchor `a` outside the drift with
`|a x - t x| ≤ εₐ` departs from the pool mean and from every judge by at least
`γ |c x - t x| - (1 - γ) - εₐ`. -/
theorem anchor_detects_shared_drift {X : Type*} {M : ℕ} {γ εₐ : ℝ} (hγ0 : 0 ≤ γ) (hγ1 : γ ≤ 1)
    (c t a : X → ℝ) (u : Fin M → X → ℝ) (hu : ∀ i x, 0 ≤ u i x ∧ u i x ≤ 1)
    (ht : ∀ x, 0 ≤ t x ∧ t x ≤ 1) (ha : ∀ x, |a x - t x| ≤ εₐ) :
    (0 < M → ∀ x, γ * |c x - t x| - (1 - γ) - εₐ ≤ |a x - poolMean γ c u x|) ∧
    (∀ i x, γ * |c x - t x| - (1 - γ) - εₐ ≤ |a x - judgeScore γ c u i x|) := by
  have key : ∀ (s : ℝ) (x : X), γ * |c x - t x| - (1 - γ) ≤ |s - t x| →
      γ * |c x - t x| - (1 - γ) - εₐ ≤ |a x - s| := fun s x h => by
    have htri : |s - t x| ≤ |a x - s| + |a x - t x| := by
      calc |s - t x| = |(-(a x - s)) + (a x - t x)| := by ring_nf
        _ ≤ |-(a x - s)| + |a x - t x| := abs_add_le _ _
        _ = _ := by rw [abs_neg]
    linarith [ha x]
  refine ⟨fun hM x => key _ x ((pool_shared_bias_floor hM hγ0 hγ1 c t u hu ht).1 x),
    fun i x => key _ x (shared_score_bias_floor hγ0 hγ1 (hu i x) (ht x))⟩

/-- **Correlated Pool Blindness vs Anchor (`correlated_pool_blindness_vs_anchor`):** for any veto
threshold `τ ≥ 1 - γ`, the internal disagreement veto never fires — for every pool size and every
size of shared error — while the anchor veto fires on the pool mean and on every judge whenever
`τ + (1 - γ) + εₐ < γ |c x - t x|`. -/
theorem correlated_pool_blindness_vs_anchor {X : Type*} {M : ℕ} {γ εₐ τ : ℝ} (hγ0 : 0 ≤ γ)
    (hγ1 : γ ≤ 1) (hτ : 1 - γ ≤ τ) (c t a : X → ℝ) (u : Fin M → X → ℝ)
    (hu : ∀ i x, 0 ≤ u i x ∧ u i x ≤ 1) (ht : ∀ x, 0 ≤ t x ∧ t x ≤ 1)
    (ha : ∀ x, |a x - t x| ≤ εₐ) :
    (∀ i k x, ¬ τ < |judgeScore γ c u i x - judgeScore γ c u k x|) ∧
    (∀ x, τ + (1 - γ) + εₐ < γ * |c x - t x| →
      (0 < M → τ < |a x - poolMean γ c u x|) ∧ ∀ i, τ < |a x - judgeScore γ c u i x|) := by
  obtain ⟨hceil, -, -⟩ := pool_disagreement_ceiling hγ1 c u hu
  obtain ⟨hmean, hjudge⟩ := anchor_detects_shared_drift hγ0 hγ1 c t a u hu ht ha
  exact ⟨fun i k x h => absurd (hceil i k x) (by linarith),
    fun x hx => ⟨fun hM => by linarith [hmean hM x], fun i => by linarith [hjudge i x]⟩⟩

/-- **Lab Witness (`correlated_pool_lab_witness`):** at `γ = 24/25`, `τ = 7/50`, `M = 3`, exact
anchor: the internal veto is silent on every course, the anchor veto fires on every course with
`|c x - t x| > 3/16`; on the course `c = 1`, `t = 0`, `u = 0` the judges agree exactly while the
anchor sees the pool mean `24/25` away from the truth. -/
theorem correlated_pool_lab_witness :
    (∀ {X : Type} (c t : X → ℝ) (u : Fin 3 → X → ℝ), (∀ i x, 0 ≤ u i x ∧ u i x ≤ 1) →
      (∀ x, 0 ≤ t x ∧ t x ≤ 1) →
      (∀ i k x, ¬ (7 / 50 : ℝ) < |judgeScore (24 / 25) c u i x - judgeScore (24 / 25) c u k x|) ∧
      (∀ x, (3 / 16 : ℝ) < |c x - t x| →
        (7 / 50 : ℝ) < |t x - poolMean (24 / 25) c u x| ∧
        ∀ i, (7 / 50 : ℝ) < |t x - judgeScore (24 / 25) c u i x|)) ∧
    ((∀ i k : Fin 3, judgeScore (24 / 25) (fun _ : Unit => (1 : ℝ)) (fun _ _ => 0) i () -
        judgeScore (24 / 25) (fun _ : Unit => (1 : ℝ)) (fun _ _ => 0) k () = 0) ∧
      (7 / 50 : ℝ) < |(0 : ℝ) - poolMean (24 / 25) (fun _ : Unit => (1 : ℝ))
        (fun (_ : Fin 3) _ => (0 : ℝ)) ()|) := by
  refine ⟨fun c t u hu ht => ?_, fun i k => by rw [judgeScore_sub]; ring, ?_⟩
  swap
  · rw [poolMean_eq (by norm_num), show residualMean (fun (_ : Fin 3) (_ : Unit) => (0 : ℝ)) () = 0 by
      simp [residualMean]]
    norm_num [abs_of_neg]
  obtain ⟨hin, han⟩ := correlated_pool_blindness_vs_anchor (εₐ := 0) (τ := 7 / 50) (M := 3)
    (by norm_num : (0 : ℝ) ≤ 24 / 25) (by norm_num) (by norm_num) c t t u hu ht
    (fun x => by simp)
  refine ⟨hin, fun x hx => ?_⟩
  have h := han x (by nlinarith [abs_nonneg (c x - t x)])
  exact ⟨h.1 (by norm_num), h.2⟩


/-! ## Part 2: Aliased Probe — Readout Floor Inside `2ε`, Sharp Separation, Mixture Test Floor -/

/-- Aliased probe reading `(1 - α) p u + α m (f u)` (the stress lab's `interventional_probe` form). -/
noncomputable def aliasedProbe {U O : Type*} (α : ℝ) (p : U → ℝ) (m : O → ℝ) (f : U → O) (u : U) : ℝ :=
  (1 - α) * p u + α * m (f u)

/-- A rule `g` separates two readings under noise `ε`: `false` on every admissible observation of
the first, `true` on every admissible observation of the second. -/
def SeparatesUnderNoise (ε r₁ r₂ : ℝ) (g : ℝ → Bool) : Prop :=
  (∀ y, |y - r₁| ≤ ε → g y = false) ∧ (∀ y, |y - r₂| ≤ ε → g y = true)

/-- **Aliased Fiber Gap (`aliased_fiber_gap`):** within a fiber of `f`, aliasing scales the probe
gap by exactly `1 - α`. -/
theorem aliased_fiber_gap {U O : Type*} {α : ℝ} (hα1 : α ≤ 1) (p : U → ℝ) (m : O → ℝ) (f : U → O)
    {u₁ u₂ : U} (hf : f u₁ = f u₂) :
    |aliasedProbe α p m f u₁ - aliasedProbe α p m f u₂| = (1 - α) * |p u₁ - p u₂| := by
  unfold aliasedProbe
  rw [hf, show (1 - α) * p u₁ + α * m (f u₂) - ((1 - α) * p u₂ + α * m (f u₂)) =
    (1 - α) * (p u₁ - p u₂) by ring, abs_mul, abs_of_nonneg (by linarith)]

/-- The midpoint of two readings within `2ε` is an admissible observation of both. -/
theorem midpoint_admissible {ε r₁ r₂ : ℝ} (h : |r₁ - r₂| ≤ 2 * ε) :
    |(r₁ + r₂) / 2 - r₁| ≤ ε ∧ |(r₁ + r₂) / 2 - r₂| ≤ ε := by
  constructor
  · rw [show (r₁ + r₂) / 2 - r₁ = -(r₁ - r₂) / 2 by ring, abs_div, abs_neg, abs_two]; linarith
  · rw [show (r₁ + r₂) / 2 - r₂ = (r₁ - r₂) / 2 by ring, abs_div, abs_two]; linarith

/-- **Noisy Readout Floor (`noisy_readout_floor`):** if two readings are within `2ε`, no rule
separates them, and any real predictor `b` of a viability split `h₁ = 0`, `h₂ = 1` from admissible
observations errs by at least `1/2`. The predictor part is
`ObservationalFidelity.fiber_split_readout_floor` on the type of admissible (state, observation)
pairs read off by the observation. -/
theorem noisy_readout_floor {U : Type*} {ε : ℝ} (r : U → ℝ) {u₁ u₂ : U}
    (hsep : |r u₁ - r u₂| ≤ 2 * ε) :
    (∀ g : ℝ → Bool, ¬ SeparatesUnderNoise ε (r u₁) (r u₂) g) ∧
    (∀ (h : U → ℝ) (b : ℝ → ℝ) {γ : ℝ}, h u₁ = 0 → h u₂ = 1 →
      (∀ u y, |y - r u| ≤ ε → |h u - b y| ≤ γ) → (1 / 2 : ℝ) ≤ γ) := by
  obtain ⟨hm₁, hm₂⟩ := midpoint_admissible hsep
  refine ⟨fun g ⟨h₁, h₂⟩ => ?_, fun h b γ hh₁ hh₂ hγ => ?_⟩
  · have := (h₁ _ hm₁).symm.trans (h₂ _ hm₂); exact Bool.false_ne_true this
  · let V := {q : U × ℝ // |q.2 - r q.1| ≤ ε}
    exact ObservationalFidelity.fiber_split_readout_floor (fun q : V => q.1.2) (fun q : V => h q.1.1) b
      ⟨(u₁, (r u₁ + r u₂) / 2), hm₁⟩ ⟨(u₂, (r u₁ + r u₂) / 2), hm₂⟩ rfl hh₁ hh₂
      (fun q => hγ q.1.1 q.1.2 q.2)

/-- **Sharp Separation (`noisy_readout_separates`):** if two readings are more than `2ε` apart, the
midpoint threshold rule separates every admissible observation of one from the other. -/
theorem noisy_readout_separates {ε r₁ r₂ : ℝ} (hsep : 2 * ε < |r₁ - r₂|) :
    SeparatesUnderNoise ε r₁ r₂ (fun y => decide (0 < (r₂ - r₁) * (y - (r₁ + r₂) / 2))) := by
  have hd : |r₂ - r₁| = |r₁ - r₂| := abs_sub_comm _ _
  have hsq : (r₂ - r₁) * (r₂ - r₁) = |r₁ - r₂| * |r₁ - r₂| := by
    rw [← hd, ← abs_mul, abs_of_nonneg (mul_self_nonneg _)]
  constructor
  · intro y hy
    simp only [decide_eq_false_iff_not, not_lt]
    have hb : (r₂ - r₁) * (y - r₁) ≤ |r₁ - r₂| * ε := by
      calc (r₂ - r₁) * (y - r₁) ≤ |(r₂ - r₁) * (y - r₁)| := le_abs_self _
        _ = |r₂ - r₁| * |y - r₁| := abs_mul _ _
        _ ≤ |r₁ - r₂| * ε := by rw [hd]; exact mul_le_mul_of_nonneg_left hy (abs_nonneg _)
    nlinarith [abs_nonneg (r₁ - r₂)]
  · intro y hy
    have hε : 0 ≤ ε := (abs_nonneg _).trans hy
    have hpos : 0 < |r₁ - r₂| := by linarith
    simp only [decide_eq_true_eq]
    have hb : -(|r₁ - r₂| * ε) ≤ (r₂ - r₁) * (y - r₂) := by
      have : |(r₂ - r₁) * (y - r₂)| ≤ |r₁ - r₂| * ε := by
        rw [abs_mul, hd]; exact mul_le_mul_of_nonneg_left hy (abs_nonneg _)
      linarith [neg_abs_le ((r₂ - r₁) * (y - r₂))]
    nlinarith

/-- **Aliased Separability Iff (`aliased_separable_iff`):** two same-fiber states are separable by
some rule under noise `ε ≥ 0` iff `2ε < (1 - α) |p u₁ - p u₂|`; the aliasing wall sits exactly at
`(1 - α) |p u₁ - p u₂| = 2ε`. -/
theorem aliased_separable_iff {U O : Type*} {α ε : ℝ} (hα1 : α ≤ 1) (p : U → ℝ) (m : O → ℝ)
    (f : U → O) {u₁ u₂ : U} (hf : f u₁ = f u₂) :
    (∃ g, SeparatesUnderNoise ε (aliasedProbe α p m f u₁) (aliasedProbe α p m f u₂) g) ↔
      2 * ε < (1 - α) * |p u₁ - p u₂| := by
  rw [← aliased_fiber_gap hα1 p m f hf]
  constructor
  · rintro ⟨g, hg⟩
    by_contra hle
    exact (noisy_readout_floor (aliasedProbe α p m f) (not_lt.mp hle)).1 g hg
  · intro h
    exact ⟨_, noisy_readout_separates h⟩

/-- **Aliased Readout Floor (`aliased_readout_floor`):** when aliasing shrinks the within-fiber
probe gap to `(1 - α) |p u₁ - p u₂| ≤ 2ε`, no rule separates the intact from the strained state and
every real predictor of the split errs by at least `1/2`. -/
theorem aliased_readout_floor {U O : Type*} {α ε : ℝ} (hα1 : α ≤ 1) (p : U → ℝ) (m : O → ℝ)
    (f : U → O) {u₁ u₂ : U} (hf : f u₁ = f u₂) (hsep : (1 - α) * |p u₁ - p u₂| ≤ 2 * ε) :
    (∀ g : ℝ → Bool,
      ¬ SeparatesUnderNoise ε (aliasedProbe α p m f u₁) (aliasedProbe α p m f u₂) g) ∧
    (∀ (h : U → ℝ) (b : ℝ → ℝ) {γ : ℝ}, h u₁ = 0 → h u₂ = 1 →
      (∀ u y, |y - aliasedProbe α p m f u| ≤ ε → |h u - b y| ≤ γ) → (1 / 2 : ℝ) ≤ γ) :=
  noisy_readout_floor (aliasedProbe α p m f) (by rw [aliased_fiber_gap hα1 p m f hf]; exact hsep)

/-- **Aliasing Lab Witness (`aliased_lab_witness`):** with probe gap `6/5` (the lab's measured
`1.195`), aliasing `19/20` blinds every rule for every `ε ≥ 3/100`, while aliasing `1/20` leaves a
separating rule for every `ε < 57/100`. -/
theorem aliased_lab_witness {U O : Type*} (p : U → ℝ) (m : O → ℝ) (f : U → O) {u₁ u₂ : U}
    (hf : f u₁ = f u₂) (hgap : |p u₁ - p u₂| = 6 / 5) :
    (∀ ε : ℝ, 3 / 100 ≤ ε → ∀ g : ℝ → Bool, ¬ SeparatesUnderNoise ε
      (aliasedProbe (19 / 20) p m f u₁) (aliasedProbe (19 / 20) p m f u₂) g) ∧
    (∀ ε : ℝ, ε < 57 / 100 → ∃ g, SeparatesUnderNoise ε
      (aliasedProbe (1 / 20) p m f u₁) (aliasedProbe (1 / 20) p m f u₂) g) :=
  ⟨fun ε hε => (aliased_readout_floor (by norm_num) p m f hf (by rw [hgap]; linarith)).1,
   fun ε hε => (aliased_separable_iff (by norm_num) p m f hf).mpr (by rw [hgap]; linarith)⟩

/-- Mixture of a fine law `P` with a macro law `N` at aliasing `α`. -/
noncomputable def mixDist {Y : Type*} [Fintype Y] (α : ℝ) (hα0 : 0 ≤ α) (hα1 : α ≤ 1)
    (P N : ObservationalFidelity.FinDist Y) : ObservationalFidelity.FinDist Y where
  w y := (1 - α) * P.w y + α * N.w y
  nonneg y := add_nonneg (mul_nonneg (by linarith) (P.nonneg y)) (mul_nonneg hα0 (N.nonneg y))
  sum_eq_one := by
    rw [Finset.sum_add_distrib, ← Finset.mul_sum, ← Finset.mul_sum, P.sum_eq_one, N.sum_eq_one]; ring

/-- Mass a law puts where the rule `g` answers `true`. -/
noncomputable def testMass {Y : Type*} [Fintype Y] (P : ObservationalFidelity.FinDist Y)
    (g : Y → Bool) : ℝ :=
  ∑ y, if g y then P.w y else 0

theorem testMass_add_not {Y : Type*} [Fintype Y] (P : ObservationalFidelity.FinDist Y)
    (g : Y → Bool) : testMass P g + testMass P (fun y => !g y) = 1 := by
  unfold testMass
  rw [← Finset.sum_add_distrib, ← P.sum_eq_one]
  exact Finset.sum_congr rfl fun y _ => by cases h : g y <;> simp [h]

theorem tvDist_le_one {Y : Type*} [Fintype Y] (P Q : ObservationalFidelity.FinDist Y) :
    ObservationalFidelity.tvDist P Q ≤ 1 := by
  unfold ObservationalFidelity.tvDist FiniteProb.tvDist
  have h : ∑ y, |P.w y - Q.w y| ≤ ∑ y, (P.w y + Q.w y) := Finset.sum_le_sum fun y _ =>
    abs_le.mpr ⟨by linarith [P.nonneg y, Q.nonneg y], by linarith [P.nonneg y, Q.nonneg y]⟩
  rw [Finset.sum_add_distrib, P.sum_eq_one, Q.sum_eq_one] at h
  linarith

/-- **Two-Point Test Floor (`two_point_test_floor`):** every rule's error sum on two laws is at
least `1 - tvDist`. -/
theorem two_point_test_floor {Y : Type*} [Fintype Y] (P₁ P₂ : ObservationalFidelity.FinDist Y)
    (g : Y → Bool) :
    1 - ObservationalFidelity.tvDist P₁ P₂ ≤ testMass P₁ g + testMass P₂ (fun y => !g y) := by
  have hnot := testMass_add_not P₂ g
  have hzero : ∑ y, (P₂.w y - P₁.w y) = 0 := by
    rw [Finset.sum_sub_distrib, P₁.sum_eq_one, P₂.sum_eq_one, sub_self]
  have hterm : ∀ y, (if g y then P₂.w y else 0) - (if g y then P₁.w y else 0) ≤
      (1 / 2 : ℝ) * |P₁.w y - P₂.w y| + (1 / 2 : ℝ) * (P₂.w y - P₁.w y) := fun y => by
    cases g y
    · simp only [Bool.false_eq_true, if_false, sub_zero]
      linarith [le_abs_self (P₁.w y - P₂.w y)]
    · simp only [if_true]
      linarith [le_abs_self (P₁.w y - P₂.w y), abs_sub_comm (P₁.w y) (P₂.w y),
        le_abs_self (P₂.w y - P₁.w y)]
  have hsum : testMass P₂ g - testMass P₁ g ≤ ObservationalFidelity.tvDist P₁ P₂ := by
    unfold testMass ObservationalFidelity.tvDist FiniteProb.tvDist
    rw [← Finset.sum_sub_distrib]
    calc ∑ y, ((if g y then P₂.w y else 0) - (if g y then P₁.w y else 0))
        ≤ ∑ y, ((1 / 2 : ℝ) * |P₁.w y - P₂.w y| + (1 / 2 : ℝ) * (P₂.w y - P₁.w y)) :=
          Finset.sum_le_sum fun y _ => hterm y
      _ = (1 / 2 : ℝ) * ∑ y, |P₁.w y - P₂.w y| := by
          rw [Finset.sum_add_distrib, ← Finset.mul_sum, ← Finset.mul_sum, hzero, mul_zero, add_zero]
  linarith

theorem tvDist_mixDist_same {Y : Type*} [Fintype Y] {α : ℝ} (hα0 : 0 ≤ α) (hα1 : α ≤ 1)
    (P₁ P₂ N : ObservationalFidelity.FinDist Y) :
    ObservationalFidelity.tvDist (mixDist α hα0 hα1 P₁ N) (mixDist α hα0 hα1 P₂ N) =
      (1 - α) * ObservationalFidelity.tvDist P₁ P₂ := by
  unfold ObservationalFidelity.tvDist FiniteProb.tvDist mixDist
  simp only
  rw [Finset.mul_sum, Finset.mul_sum, Finset.mul_sum]
  refine Finset.sum_congr rfl fun y _ => ?_
  rw [show (1 - α) * P₁.w y + α * N.w y - ((1 - α) * P₂.w y + α * N.w y) =
    (1 - α) * (P₁.w y - P₂.w y) by ring, abs_mul, abs_of_nonneg (by linarith)]
  ring

/-- **Mixture Aliasing Test Floor (`mixture_aliasing_test_floor`):** if the observation law of a
state mixes its fine law `K u` with a macro law `N (f u)` at aliasing `α`, then for two same-fiber
states every rule's error sum is at least `1 - (1 - α) tvDist (K u₁) (K u₂) ≥ α`. -/
theorem mixture_aliasing_test_floor {U O Y : Type*} [Fintype Y] {α : ℝ} (hα0 : 0 ≤ α) (hα1 : α ≤ 1)
    (K : U → ObservationalFidelity.FinDist Y) (N : O → ObservationalFidelity.FinDist Y) (f : U → O)
    {u₁ u₂ : U} (hf : f u₁ = f u₂) (g : Y → Bool) :
    1 - (1 - α) * ObservationalFidelity.tvDist (K u₁) (K u₂) ≤
      testMass (mixDist α hα0 hα1 (K u₁) (N (f u₁))) g +
        testMass (mixDist α hα0 hα1 (K u₂) (N (f u₂))) (fun y => !g y) ∧
    α ≤ 1 - (1 - α) * ObservationalFidelity.tvDist (K u₁) (K u₂) := by
  have h := two_point_test_floor (mixDist α hα0 hα1 (K u₁) (N (f u₁)))
    (mixDist α hα0 hα1 (K u₂) (N (f u₂))) g
  rw [← hf, tvDist_mixDist_same hα0 hα1] at h
  rw [← hf]
  refine ⟨h, ?_⟩
  have := tvDist_le_one (K u₁) (K u₂)
  nlinarith

/-- **Mixture Floor Attained (`mixture_floor_attained`):** on `Bool`, fine laws at the two points
and the support rule give error sum exactly `α`, for every macro law `N`. -/
theorem mixture_floor_attained {α : ℝ} (hα0 : 0 ≤ α) (hα1 : α ≤ 1)
    (N : ObservationalFidelity.FinDist Bool) :
    testMass (mixDist α hα0 hα1 (ObservationalFidelity.diracDist false) N) id +
      testMass (mixDist α hα0 hα1 (ObservationalFidelity.diracDist true) N) (fun y => !id y) = α := by
  have hN := N.sum_eq_one
  rw [Fintype.sum_bool] at hN
  simp [testMass, mixDist, ObservationalFidelity.diracDist, FiniteProb.diracDist]
  linear_combination α * hN

/-! ## Part 3: Lag Horizon — Continuous Drawdown Wall and Leakage Switching Lag -/

/-- **Drawdown Bound (`le_of_deriv_le_on_Icc`):** a function continuous on `[0, T]`, differentiable
inside with derivative at most `-H₁`, stays below `x 0 - H₁ t` on `[0, T]`. -/
theorem le_of_deriv_le_on_Icc {x : ℝ → ℝ} {H₁ T : ℝ} (hcont : ContinuousOn x (Icc 0 T))
    (hdiff : DifferentiableOn ℝ x (Ioo 0 T)) (hder : ∀ t ∈ Ioo 0 T, deriv x t ≤ -H₁) :
    ∀ t ∈ Icc 0 T, x t ≤ x 0 - H₁ * t := by
  have hmono : AntitoneOn (fun t => x t + H₁ * t) (Icc 0 T) := by
    refine antitoneOn_of_deriv_nonpos (convex_Icc 0 T)
      (hcont.add (continuousOn_const.mul continuousOn_id)) ?_ ?_
    · rw [interior_Icc]
      exact hdiff.add (differentiableOn_const _ |>.mul differentiableOn_id)
    · intro t ht
      rw [interior_Icc] at ht
      have hxd : DifferentiableAt ℝ x t := hdiff.differentiableAt (Ioo_mem_nhds ht.1 ht.2)
      have hd : HasDerivAt (fun y => x y + H₁ * y) (deriv x t + H₁ * 1) t :=
        hxd.hasDerivAt.add ((hasDerivAt_id' t).const_mul H₁)
      rw [hd.deriv]
      linarith [hder t ht]
  intro t ht
  have h0 : (0 : ℝ) ∈ Icc 0 T := ⟨le_rfl, ht.1.trans ht.2⟩
  have := hmono h0 ht ht.1
  simp only [mul_zero, add_zero] at this
  linarith

/-- **Lag-Horizon Wall (`lag_horizon_wall`):** if the reserve starts at or above `x_crit`, falls at
rate at least `H₁ > 0` on `[0, L]`, and `(x 0 - x_crit) / H₁ < L`, then it reaches `x_crit` at some
`t* ≤ (x 0 - x_crit) / H₁ < L` — before a correction delayed by `L` can act — and `x L < x_crit`. -/
theorem lag_horizon_wall {x : ℝ → ℝ} {H₁ L x_crit : ℝ} (hH : 0 < H₁) (hx0 : x_crit ≤ x 0)
    (hL : (x 0 - x_crit) / H₁ < L) (hcont : ContinuousOn x (Icc 0 L))
    (hdiff : DifferentiableOn ℝ x (Ioo 0 L)) (hder : ∀ t ∈ Ioo 0 L, deriv x t ≤ -H₁) :
    (∃ t ∈ Icc 0 ((x 0 - x_crit) / H₁), t < L ∧ x t = x_crit) ∧ x L < x_crit := by
  set t₁ := (x 0 - x_crit) / H₁ with ht₁
  have ht₁0 : 0 ≤ t₁ := div_nonneg (by linarith) hH.le
  have hHt : H₁ * t₁ = x 0 - x_crit := by rw [ht₁]; field_simp
  have hbound := le_of_deriv_le_on_Icc hcont hdiff hder
  have hxt₁ : x t₁ ≤ x_crit := by
    have := hbound t₁ ⟨ht₁0, hL.le⟩; linarith
  refine ⟨?_, ?_⟩
  · obtain ⟨t, ht, hxt⟩ := intermediate_value_Icc' ht₁0
      (hcont.mono (Icc_subset_Icc le_rfl hL.le)) ⟨hxt₁, hx0⟩
    exact ⟨t, ht, lt_of_le_of_lt ht.2 hL, hxt⟩
  · have := hbound L ⟨ht₁0.trans hL.le, le_rfl⟩
    have : H₁ * t₁ < H₁ * L := mul_lt_mul_of_pos_left hL hH
    linarith

/-- **Wall Exact on the Linear Trajectory (`lag_wall_iff_linear`):** the trajectory
`x₀ - H₁ t` drops below `x_crit` within `[0, L]` iff `(x₀ - x_crit) / H₁ < L`. -/
theorem lag_wall_iff_linear {H₁ L x₀ x_crit : ℝ} (hH : 0 < H₁) (hL0 : 0 ≤ L) :
    (∃ t ∈ Icc 0 L, x₀ - H₁ * t < x_crit) ↔ (x₀ - x_crit) / H₁ < L := by
  rw [div_lt_iff₀ hH]
  constructor
  · rintro ⟨t, ht, hlt⟩
    nlinarith [ht.2]
  · intro h
    exact ⟨L, ⟨hL0, le_rfl⟩, by linarith⟩

/-- The linear trajectory meets every premise of `lag_horizon_wall` (so the wall is not vacuous). -/
theorem linear_trajectory_premises (H₁ x₀ L : ℝ) :
    ContinuousOn (fun t => x₀ - H₁ * t) (Icc 0 L) ∧
    DifferentiableOn ℝ (fun t => x₀ - H₁ * t) (Ioo 0 L) ∧
    ∀ t ∈ Ioo 0 L, deriv (fun t => x₀ - H₁ * t) t ≤ -H₁ := by
  refine ⟨by fun_prop, by fun_prop, fun t _ => ?_⟩
  rw [deriv_const_sub, deriv_const_mul _ differentiableAt_id, deriv_id'']
  simp

/-- Continuous-time switching lag: the warning score enters at `s₀ + η ρ S` (safe-phase leakage
`ρ`) and falls at rate at most `η p n2`; it stays above `v_rest` for this long. -/
noncomputable def switchLag (s₀ ρ S v_rest η p n2 : ℝ) : ℝ :=
  (s₀ + η * ρ * S - v_rest) / (η * p * n2)

/-- **Switching Score Persists (`switching_score_persists`):** a score entering at `s₀ + η ρ S` and
falling at rate at most `η p n2 > 0` stays above `v_rest` for every `t < switchLag`. -/
theorem switching_score_persists {s : ℝ → ℝ} {s₀ ρ S v_rest η p n2 T : ℝ} (hrate : 0 < η * p * n2)
    (hs0 : s 0 = s₀ + η * ρ * S) (hcont : ContinuousOn s (Icc 0 T))
    (hdiff : DifferentiableOn ℝ s (Ioo 0 T)) (hder : ∀ t ∈ Ioo 0 T, -(η * p * n2) ≤ deriv s t) :
    ∀ t ∈ Icc 0 T, t < switchLag s₀ ρ S v_rest η p n2 → v_rest < s t := by
  have hneg := le_of_deriv_le_on_Icc (x := fun t => -s t) (H₁ := -(η * p * n2)) hcont.neg hdiff.neg
    (fun t ht => by
      rw [deriv.fun_neg]
      linarith [hder t ht])
  intro t ht hlt
  have hb := hneg t ht
  simp only at hb
  rw [switchLag, lt_div_iff₀ hrate] at hlt
  nlinarith

/-- **Switching Lag Rises with Leakage (`switchLag_strictMono_rho`):** for `η, S, p, n2 > 0` the
switching lag is strictly increasing in the leakage `ρ`. -/
theorem switchLag_strictMono_rho {s₀ S v_rest η p n2 : ℝ} (hη : 0 < η) (hS : 0 < S) (hp : 0 < p)
    (hn : 0 < n2) : StrictMono fun ρ => switchLag s₀ ρ S v_rest η p n2 := by
  intro ρ₁ ρ₂ h
  have hd : 0 < η * p * n2 := by positivity
  simp only [switchLag]
  apply div_lt_div_of_pos_right _ hd
  nlinarith [mul_pos hη hS]

/-- **No Switching Lag Without Leakage (`switchLag_nonpos_tabular`):** at `ρ = 0` with entry score
`s₀ ≤ v_rest` the switching lag is `≤ 0` (the orthogonal case). -/
theorem switchLag_nonpos_tabular {s₀ S v_rest η p n2 : ℝ} (hrate : 0 < η * p * n2)
    (hs : s₀ ≤ v_rest) : switchLag s₀ 0 S v_rest η p n2 ≤ 0 := by
  unfold switchLag
  exact div_nonpos_of_nonpos_of_nonneg (by linarith [show η * 0 * S = 0 by ring]) hrate.le

/-- **Leakage Lag Wall (`leakage_lag_wall`):** if `x 0 < x_crit + H₁ (L + M)` with `M` the
switching lag, and the reserve falls at rate at least `H₁` until `L + M`, it reaches `x_crit`
strictly before `L + M`: before the policy has switched. The threshold
`x_crit + H₁ (L + M(ρ))` is strictly increasing in `ρ`. -/
theorem leakage_lag_wall {x : ℝ → ℝ} {H₁ L x_crit s₀ S v_rest η p n2 ρ : ℝ} (hH : 0 < H₁)
    (hx0 : x_crit ≤ x 0)
    (hthr : x 0 < x_crit + H₁ * (L + switchLag s₀ ρ S v_rest η p n2))
    (hcont : ContinuousOn x (Icc 0 (L + switchLag s₀ ρ S v_rest η p n2)))
    (hdiff : DifferentiableOn ℝ x (Ioo 0 (L + switchLag s₀ ρ S v_rest η p n2)))
    (hder : ∀ t ∈ Ioo 0 (L + switchLag s₀ ρ S v_rest η p n2), deriv x t ≤ -H₁) :
    (∃ t ∈ Icc 0 (L + switchLag s₀ ρ S v_rest η p n2),
      t < L + switchLag s₀ ρ S v_rest η p n2 ∧ x t = x_crit) ∧
    (0 < η → 0 < S → 0 < p → 0 < n2 →
      StrictMono fun ρ' => x_crit + H₁ * (L + switchLag s₀ ρ' S v_rest η p n2)) := by
  have hL : (x 0 - x_crit) / H₁ < L + switchLag s₀ ρ S v_rest η p n2 := by
    rw [div_lt_iff₀ hH]; linarith
  obtain ⟨⟨t, ht, hlt, hxt⟩, -⟩ := lag_horizon_wall hH hx0 hL hcont hdiff hder
  refine ⟨⟨t, ⟨ht.1, hlt.le⟩, hlt, hxt⟩, fun hη hS hp hn ρ₁ ρ₂ h => ?_⟩
  have := switchLag_strictMono_rho (s₀ := s₀) (v_rest := v_rest) hη hS hp hn h
  simp only at this ⊢
  nlinarith

/-- **`B1` Headroom Witness (`b1_headroom_witness`):** at `x_crit = 3`, `H₁ = 4`, `L = 5`, the linear
trajectory from `27` (`b_feas`) crosses before `L + M` iff `M > 1`, and from `39` (`+12`) iff
`M > 4`: `+12` buys three steps of switching lag. -/
theorem b1_headroom_witness (M : ℝ) (hM : 0 ≤ M) :
    ((∃ t ∈ Icc 0 (5 + M), (27 : ℝ) - 4 * t < 3) ↔ 1 < M) ∧
    ((∃ t ∈ Icc 0 (5 + M), (39 : ℝ) - 4 * t < 3) ↔ 4 < M) := by
  rw [lag_wall_iff_linear (by norm_num) (by linarith), lag_wall_iff_linear (by norm_num) (by linarith)]
  constructor <;> constructor <;> intro h <;> norm_num at h ⊢ <;> linarith

/-! ## Part 4: Trust Region — `MetricLaxSim` Tube, Viability, Overshoot, Attained Tube -/

/-- Coarse reference: the guard map alone. -/
noncomputable def guardRef {Q : Type*} (T : Q → Q) : Generative.Process Q Unit :=
  Becoming.Assurance.ofMap fun q _ => T q

theorem guardRef_trace {Q : Type*} (T : Q → Q) :
    ∀ {q : Q} {w : List Unit} {q' : Q}, Generative.Trace (guardRef T) q w q' → q' = T^[w.length] q
  | _, [], _, .nil _ => rfl
  | q, _ :: w, q', .cons step rest => by
    have hstep : _ = T q := step
    rw [guardRef_trace T rest, hstep, List.length_cons, Function.iterate_succ_apply]

theorem dist_add_le_of_norm {E : Type*} [NormedAddCommGroup E] (a b v : E) : dist (a + v) b ≤ dist a b + ‖v‖ := by
  rw [dist_eq_norm, dist_eq_norm, show a + v - b = (a - b) + v by abel]
  exact norm_add_le _ _

section TrustRegion

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Projection of a step `v` onto the ball of radius `Δ`. -/
noncomputable def trustProj (Δ : ℝ) (v : E) : E :=
  if ‖v‖ ≤ Δ then v else (Δ / ‖v‖) • v

theorem norm_trustProj_le {Δ : ℝ} (hΔ : 0 ≤ Δ) (v : E) : ‖trustProj Δ v‖ ≤ Δ := by
  unfold trustProj
  split_ifs with h
  · exact h
  · have hv : 0 < ‖v‖ := lt_of_le_of_lt hΔ (not_le.mp h)
    rw [norm_smul, Real.norm_eq_abs, abs_of_nonneg (div_nonneg hΔ hv.le), div_mul_cancel₀ _ hv.ne']

theorem trustProj_of_norm_le {Δ : ℝ} {v : E} (h : ‖v‖ ≤ Δ) : trustProj Δ v = v := if_pos h

/-- Fine process: guard map `T`, then the projected gradient step `trustProj Δ (lr • g)`. -/
noncomputable def trustStep (T : E → E) (lr Δ : ℝ) : Generative.Process E E :=
  Becoming.Assurance.ofMap fun z g => T z + trustProj Δ (lr • g)

/-- Unprojected process: guard map `T`, then the raw gradient step `lr • g`. -/
noncomputable def rawStep (T : E → E) (lr : ℝ) : Generative.Process E E :=
  Becoming.Assurance.ofMap fun z g => T z + lr • g

/-- **Trust-Region `MetricLaxSim` (`trustRegionMetricLaxSim`):** for an `α`-Lipschitz guard map and
`0 ≤ Δ`, the trust-region process simulates the guard map with `(α, β, ε, η) = (α, 1, Δ, 0)`, for
every learning rate. -/
noncomputable def trustRegionMetricLaxSim (T : E → E) (lr Δ : ℝ) {α : ℝ} (hα0 : 0 ≤ α)
    (hα1 : α < 1) (hΔ : 0 ≤ Δ) (hT : ∀ x y, dist (T x) (T y) ≤ α * dist x y) :
    Becoming.AlignmentReals.MetricLaxSim (trustStep T lr Δ) (guardRef T) id id where
  strict _ := Nat.lt_succ_self _
  Epoch _ _ := True
  EpochQ _ _ := True
  epoch_step _ _ _ _ _ _ := trivial
  epoch_proj _ _ _ := trivial
  α := α; β := 1; ε := Δ; η := 0
  α_nonneg := hα0; α_lt_one := hα1; β_ge_one := le_rfl; ε_nonneg := hΔ; η_nonneg := le_rfl
  sim_block _ s q r w s' _ _ _ hdist hlen htr := by
    have hw : w.length = 1 := by simpa using hlen
    rcases w with _ | ⟨g, _ | _⟩ <;> simp at hw
    have hs' : s' = T s + trustProj Δ (lr • g) := by
      rcases htr with _ | ⟨hs, hr⟩; cases hr; exact hs
    refine ⟨(), T q, rfl, trivial, ?_⟩
    change dist s' (T q) ≤ α * r + Δ
    rw [hs']
    have h1 := dist_add_le_of_norm (T s) (T q) (trustProj Δ (lr • g))
    have h2 := hT s q
    have h3 := norm_trustProj_le hΔ (lr • g)
    have h4 : α * dist s q ≤ α * r := mul_le_mul_of_nonneg_left hdist hα0
    linarith
  excursion _ s q r w₁ _ _ _ _ hdist hlen htr := by
    dsimp only [id] at hlen
    have hw : w₁ = [] := List.length_eq_zero_iff.mp (by omega)
    subst hw; cases htr
    change dist s q ≤ 1 * r + 0
    have hd : dist s q ≤ r := hdist
    linarith

/-- **Trust-Region Tube (`trust_region_tube`):** every `n`-step trust-region run, for every
gradient sequence and every learning rate, stays within
`α ^ n d₀ + Δ (1 - α ^ n) / (1 - α) ≤ α ^ n d₀ + Δ / (1 - α)` of the guard reference `T^[n] q₀`.
Derived via `MetricLaxSim.advance_blocks` and `metricSlack_eq`. -/
theorem trust_region_tube (T : E → E) (lr Δ : ℝ) {α : ℝ} (hα0 : 0 ≤ α) (hα1 : α < 1) (hΔ : 0 ≤ Δ)
    (hT : ∀ x y, dist (T x) (T y) ≤ α * dist x y) {z₀ z : E} (q₀ : E) {gs : List E}
    (htr : Generative.Trace (trustStep T lr Δ) z₀ gs z) :
    dist z (T^[gs.length] q₀) ≤
        α ^ gs.length * dist z₀ q₀ + Δ * (1 - α ^ gs.length) / (1 - α) ∧
      dist z (T^[gs.length] q₀) ≤ α ^ gs.length * dist z₀ q₀ + Δ / (1 - α) := by
  let sim := trustRegionMetricLaxSim T lr Δ hα0 hα1 hΔ hT
  obtain ⟨u, w_rem, wR, q_n, hrem, hwR, trR, tr_rem, _, _, hdist⟩ :=
    Becoming.AlignmentReals.MetricLaxSim.advance_blocks sim gs.length 0 (dist_nonneg) trivial trivial
      le_rfl (by simp) htr
  have hwrem0 : w_rem = [] := by simpa using hrem
  subst hwrem0
  have hu : u = z := by cases tr_rem; rfl
  have hq : q_n = T^[gs.length] q₀ := by rw [guardRef_trace T trR, hwR]
  rw [← hu, ← hq]
  exact ⟨by simpa [mul_div_assoc] using
      hdist.trans_eq (Becoming.AlignmentReals.metricSlack_eq hα1.ne Δ gs.length _),
    hdist.trans (Becoming.AlignmentReals.metricSlack_le hα0 hα1 hΔ gs.length _)⟩

/-- **Trust-Region Viability (`trust_region_viability`):** with guard centre `c` fixed by `T`, a run
starting within `d₀` of `c` keeps `dist z c ≤ B` forever — for every gradient sequence and every
learning rate — whenever `max d₀ (Δ / (1 - α)) ≤ B`. Derived via `metric_laxSim_contraction_tube`. -/
theorem trust_region_viability (T : E → E) (lr Δ : ℝ) {α : ℝ} (hα0 : 0 ≤ α) (hα1 : α < 1)
    (hΔ : 0 ≤ Δ) (hT : ∀ x y, dist (T x) (T y) ≤ α * dist x y) {c : E} (hc : T c = c)
    {z₀ : E} {d₀ B : ℝ} (hz₀ : dist z₀ c ≤ d₀) (hB : max d₀ (Δ / (1 - α)) ≤ B) :
    Becoming.Viability.Kernel (trustStep T lr Δ) (fun z => dist z c ≤ B) z₀ := by
  let sim := trustRegionMetricLaxSim T lr Δ hα0 hα1 hΔ hT
  have cert : Becoming.Viability.Certificate (guardRef T) (fun q => q = c) (fun q => q = c) :=
    ⟨fun _ h => h, fun s _ t hstep hs => by
      have : t = T s := hstep
      rw [this, hs, hc]⟩
  exact (Becoming.AlignmentReals.metric_laxSim_contraction_tube sim cert d₀
    (dist_nonneg.trans hz₀)
    (fun q u hq hd => by
      rw [hq] at hd
      change dist u c ≤ 1 * max d₀ (Δ / (1 - α)) + 0 at hd
      linarith)
    c trivial trivial hz₀ rfl).2

/-- **Unprojected Overshoot (`unprojected_step_overshoots`):** without projection, for every guard
band `B`, every learning rate `lr > 0`, and every guard map fixing `c`, some gradient proposal
leaves the band in one step from `c`. -/
theorem unprojected_step_overshoots [Nontrivial E] (T : E → E) {c : E} (hc : T c = c) {lr : ℝ}
    (hlr : 0 < lr) (B : ℝ) :
    (∃ g : E, B < dist (T c + lr • g) c) ∧
      ¬ Becoming.Viability.Kernel (rawStep T lr) (fun z => dist z c ≤ B) c := by
  obtain ⟨v, hv⟩ := exists_ne (0 : E)
  have hvn : 0 < ‖v‖ := norm_pos_iff.mpr hv
  have hout : B < dist (T c + lr • (((|B| + 1) / (lr * ‖v‖)) • v)) c := by
    rw [hc, dist_eq_norm, add_sub_cancel_left, smul_smul, norm_smul, Real.norm_eq_abs,
      show lr * ((|B| + 1) / (lr * ‖v‖)) = (|B| + 1) / ‖v‖ by field_simp,
      abs_of_pos (div_pos (by positivity) hvn), div_mul_cancel₀ _ hvn.ne']
    linarith [le_abs_self B]
  refine ⟨⟨_, hout⟩, fun hker => ?_⟩
  have hin : dist (T c + lr • (((|B| + 1) / (lr * ‖v‖)) • v)) c ≤ B :=
    hker _ ⟨[((|B| + 1) / (lr * ‖v‖)) • v], .cons rfl (.nil _)⟩
  linarith

end TrustRegion

/-- Iterate of the scalar trust-region recursion `z ↦ α z + Δ` from `0`. -/
noncomputable def trustRun (α Δ : ℝ) : ℕ → ℝ
  | 0 => 0
  | n + 1 => α * trustRun α Δ n + Δ

theorem trustRun_eq {α : ℝ} (hα1 : α ≠ 1) (Δ : ℝ) :
    ∀ n, trustRun α Δ n = Δ * (1 - α ^ n) / (1 - α)
  | 0 => by simp [trustRun]
  | n + 1 => by
    rw [trustRun, trustRun_eq hα1 Δ n]
    field_simp [sub_ne_zero.mpr hα1.symm]
    ring

theorem trustRun_trace {α lr Δ : ℝ} (hlr : 0 < lr) (hΔ : 0 ≤ Δ) :
    ∀ (n : ℕ) (z : ℝ), Generative.Trace (trustStep (fun y : ℝ => α * y) lr Δ) z
      (List.replicate n (Δ / lr)) ((fun y => α * y + Δ)^[n] z)
  | 0, z => .nil z
  | n + 1, z => by
    have hstep : (fun y => α * y + Δ) z = α * z + trustProj Δ (lr • (Δ / lr)) := by
      rw [smul_eq_mul, mul_div_cancel₀ _ hlr.ne', trustProj_of_norm_le (by
        rw [Real.norm_eq_abs, abs_of_nonneg hΔ])]
    rw [List.replicate_succ, Function.iterate_succ_apply]
    exact .cons hstep (trustRun_trace hlr hΔ n _)

theorem trustRun_iterate (α Δ : ℝ) : ∀ n, (fun y => α * y + Δ)^[n] 0 = trustRun α Δ n
  | 0 => rfl
  | n + 1 => by rw [Function.iterate_succ_apply', trustRun_iterate α Δ n, trustRun]

/-- **Trust-Region Tube Attained (`trust_region_tube_attained`):** on `ℝ` with `T z = α z`, the
constant proposal `Δ / lr` from `0` reaches distance exactly `Δ (1 - α ^ n) / (1 - α)` from the
reference after `n` steps, so the tube radius of `trust_region_tube` cannot be lowered. -/
theorem trust_region_tube_attained {α lr Δ : ℝ} (hα0 : 0 ≤ α) (hα1 : α < 1) (hlr : 0 < lr)
    (hΔ : 0 ≤ Δ) (n : ℕ) :
    ∃ z, Generative.Trace (trustStep (fun y : ℝ => α * y) lr Δ) 0 (List.replicate n (Δ / lr)) z ∧
      dist z ((fun y : ℝ => α * y)^[n] 0) = α ^ n * dist (0 : ℝ) 0 + Δ * (1 - α ^ n) / (1 - α) := by
  refine ⟨_, trustRun_trace hlr hΔ n 0, ?_⟩
  have hfix : (fun y : ℝ => α * y)^[n] 0 = 0 := Function.iterate_fixed (by simp) n
  have hpow : α ^ n ≤ 1 := pow_le_one₀ hα0 hα1.le
  rw [hfix, trustRun_iterate, trustRun_eq hα1.ne, dist_self, mul_zero, zero_add, Real.dist_eq,
    sub_zero, abs_of_nonneg (div_nonneg (mul_nonneg hΔ (by linarith)) (by linarith))]

/-- **Trust-Region Lab Witness (`trust_region_lab_witness`):** at `Δ_max = 1` (the `B5` setting), a
guard map contracting by `α = 1/2` towards `c` keeps the logit band `dist z c ≤ 2` (soft guard
bias `±2`) for every gradient sequence and learning rate from any start within `2`, while on a
nontrivial space the unprojected process with any `lr > 0` leaves that band in one step. -/
theorem trust_region_lab_witness {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [Nontrivial E]
    (T : E → E) (hT : ∀ x y, dist (T x) (T y) ≤ (1 / 2) * dist x y) {c : E} (hc : T c = c) :
    (∀ (lr : ℝ) (z₀ : E), dist z₀ c ≤ 2 →
      Becoming.Viability.Kernel (trustStep T lr 1) (fun z => dist z c ≤ 2) z₀) ∧
    (∀ lr : ℝ, 0 < lr → (∃ g : E, 2 < dist (T c + lr • g) c) ∧
      ¬ Becoming.Viability.Kernel (rawStep T lr) (fun z => dist z c ≤ 2) c) :=
  ⟨fun lr _ hz₀ => trust_region_viability T lr 1 (by norm_num) (by norm_num) (by norm_num) hT hc hz₀
      (by norm_num),
   fun _ hlr => unprojected_step_overshoots T hc hlr 2⟩

/-! ## Part 5: Detector Advantage (`Youden J = TPR - FPR`) Walls (Finite & Lag) -/

/-- Youden's `J = TPR - FPR` advantage of a binary rule `g` distinguishing `P₁` from `P₀`. -/
noncomputable def youdenJ {Y : Type*} [Fintype Y] (P₀ P₁ : ObservationalFidelity.FinDist Y)
    (g : Y → Bool) : ℝ :=
  testMass P₁ g - testMass P₀ g

/-- Youden's `J` equals `1` minus the two-point error sum `FPR + FNR`. -/
theorem youdenJ_eq_one_sub_errorSum {Y : Type*} [Fintype Y]
    (P₀ P₁ : ObservationalFidelity.FinDist Y) (g : Y → Bool) :
    youdenJ P₀ P₁ g = 1 - (testMass P₀ g + testMass P₁ (fun y => !g y)) := by
  unfold youdenJ
  linarith [testMass_add_not P₁ g]

/-- Constant rules have zero Youden advantage. -/
theorem youdenJ_const_zero {Y : Type*} [Fintype Y]
    (P₀ P₁ : ObservationalFidelity.FinDist Y) :
    youdenJ P₀ P₁ (fun _ => true) = 0 ∧ youdenJ P₀ P₁ (fun _ => false) = 0 := by
  have ht : ∀ P : ObservationalFidelity.FinDist Y, testMass P (fun _ => true) = 1 := fun P => by
    simp [testMass, P.sum_eq_one]
  have hf : ∀ P : ObservationalFidelity.FinDist Y, testMass P (fun _ => false) = 0 := fun P => by
    simp [testMass]
  exact ⟨by unfold youdenJ; rw [ht P₁, ht P₀, sub_self],
    by unfold youdenJ; rw [hf P₁, hf P₀, sub_self]⟩

/-- Youden's `J` is bounded above by total variation distance. -/
theorem youdenJ_le_tvDist {Y : Type*} [Fintype Y] (P₀ P₁ : ObservationalFidelity.FinDist Y)
    (g : Y → Bool) :
    youdenJ P₀ P₁ g ≤ ObservationalFidelity.tvDist P₀ P₁ := by
  linarith [two_point_test_floor P₀ P₁ g, youdenJ_eq_one_sub_errorSum P₀ P₁ g]

/-- Absolute Youden advantage `|J|` is bounded above by total variation distance. -/
theorem abs_youdenJ_le_tvDist {Y : Type*} [Fintype Y] (P₀ P₁ : ObservationalFidelity.FinDist Y)
    (g : Y → Bool) :
    |youdenJ P₀ P₁ g| ≤ ObservationalFidelity.tvDist P₀ P₁ := by
  refine abs_le.mpr ⟨?_, youdenJ_le_tvDist P₀ P₁ g⟩
  have hrev := youdenJ_le_tvDist P₁ P₀ g
  rw [ObservationalFidelity.tvDist_symm] at hrev
  unfold youdenJ at hrev ⊢
  linarith

/-- Some binary rule attains `youdenJ P₀ P₁ g = tvDist P₀ P₁` on finite carriers. -/
theorem youdenJ_tvDist_attained {Y : Type*} [Fintype Y] [DecidableEq Y]
    (P₀ P₁ : ObservationalFidelity.FinDist Y) :
    ∃ g : Y → Bool, youdenJ P₀ P₁ g = ObservationalFidelity.tvDist P₀ P₁ := by
  let g : Y → Bool := fun y => @decide (P₀.w y < P₁.w y) (Classical.propDecidable _)
  refine ⟨g, ?_⟩
  have hzero : ∑ y : Y, (P₁.w y - P₀.w y) = 0 := by
    rw [Finset.sum_sub_distrib, P₁.sum_eq_one, P₀.sum_eq_one, sub_self]
  have hterm : ∀ y : Y,
      (if g y then P₁.w y else 0) - (if g y then P₀.w y else 0) =
        (1 / 2 : ℝ) * |P₀.w y - P₁.w y| + (1 / 2 : ℝ) * (P₁.w y - P₀.w y) := fun y => by
    by_cases h : P₀.w y < P₁.w y
    · have hg : g y = true := @decide_eq_true (P₀.w y < P₁.w y) (Classical.propDecidable _) h
      rw [hg, if_pos rfl, if_pos rfl, abs_of_neg (sub_neg.mpr h)]
      ring
    · have hg : g y = false := @decide_eq_false (P₀.w y < P₁.w y) (Classical.propDecidable _) h
      rw [hg]
      simp only [Bool.false_eq_true, if_false, sub_self]
      rw [abs_of_nonneg (sub_nonneg.mpr (not_lt.mp h))]
      ring
  unfold youdenJ testMass ObservationalFidelity.tvDist FiniteProb.tvDist
  rw [← Finset.sum_sub_distrib]
  calc ∑ y : Y, ((if g y then P₁.w y else 0) - (if g y then P₀.w y else 0))
      = ∑ y : Y, ((1 / 2 : ℝ) * |P₀.w y - P₁.w y| + (1 / 2 : ℝ) * (P₁.w y - P₀.w y)) :=
        Finset.sum_congr rfl fun y _ => hterm y
    _ = (1 / 2 : ℝ) * ∑ y : Y, |P₀.w y - P₁.w y| := by
        rw [Finset.sum_add_distrib, ← Finset.mul_sum, ← Finset.mul_sum, hzero, mul_zero, add_zero]

/-- **Mixture Aliasing Advantage Ceiling (`youdenJ_mixture_aliasing_ceiling`):** for same-fiber
states `f u₁ = f u₂`, every detector on the aliased mixture `(1 - α) K u + α N (f u)` has
`|youdenJ| ≤ (1 - α) tvDist (K u₁) (K u₂) ≤ 1 - α`. -/
theorem youdenJ_mixture_aliasing_ceiling {U O Y : Type*} [Fintype Y] {α : ℝ} (hα0 : 0 ≤ α)
    (hα1 : α ≤ 1) (K : U → ObservationalFidelity.FinDist Y)
    (N : O → ObservationalFidelity.FinDist Y) (f : U → O) {u₁ u₂ : U} (hf : f u₁ = f u₂)
    (g : Y → Bool) :
    |youdenJ (mixDist α hα0 hα1 (K u₁) (N (f u₁)))
        (mixDist α hα0 hα1 (K u₂) (N (f u₂))) g| ≤
      (1 - α) * ObservationalFidelity.tvDist (K u₁) (K u₂) ∧
    (1 - α) * ObservationalFidelity.tvDist (K u₁) (K u₂) ≤ 1 - α := by
  refine ⟨?_, mul_le_of_le_one_right (by linarith) (tvDist_le_one (K u₁) (K u₂))⟩
  calc |youdenJ (mixDist α hα0 hα1 (K u₁) (N (f u₁)))
          (mixDist α hα0 hα1 (K u₂) (N (f u₂))) g|
      ≤ ObservationalFidelity.tvDist (mixDist α hα0 hα1 (K u₁) (N (f u₁)))
          (mixDist α hα0 hα1 (K u₂) (N (f u₂))) := abs_youdenJ_le_tvDist _ _ g
    _ = (1 - α) * ObservationalFidelity.tvDist (K u₁) (K u₂) := by
        rw [← hf, tvDist_mixDist_same hα0 hα1]

/-- **Mixture Advantage Attained (`youdenJ_mixture_attained`):** on `Bool`, `id` attains
`youdenJ = 1 - α` for every macro law `N`. -/
theorem youdenJ_mixture_attained {α : ℝ} (hα0 : 0 ≤ α) (hα1 : α ≤ 1)
    (N : ObservationalFidelity.FinDist Bool) :
    youdenJ (mixDist α hα0 hα1 (ObservationalFidelity.diracDist false) N)
      (mixDist α hα0 hα1 (ObservationalFidelity.diracDist true) N) id = 1 - α := by
  rw [youdenJ_eq_one_sub_errorSum, mixture_floor_attained hα0 hα1 N]

/-- **Lag-Wall Zero Advantage (`lag_wall_youdenJ_zero`):** when the reserve reaches `x_crit` before
the delayed channel separates (`∀ t < L, P₀ t = P₁ t`), every detector has `youdenJ = 0` at every
step `s ≤ t*` up to crossing. -/
theorem lag_wall_youdenJ_zero {Y : Type*} [Fintype Y] {x : ℝ → ℝ} {H₁ L x_crit : ℝ}
    (hH : 0 < H₁) (hx0 : x_crit ≤ x 0) (hL : (x 0 - x_crit) / H₁ < L)
    (hcont : ContinuousOn x (Icc 0 L)) (hdiff : DifferentiableOn ℝ x (Ioo 0 L))
    (hder : ∀ t ∈ Ioo 0 L, deriv x t ≤ -H₁)
    (P₀ P₁ : ℝ → ObservationalFidelity.FinDist Y) (hblind : ∀ t, t < L → P₀ t = P₁ t) :
    ∃ t ∈ Icc 0 ((x 0 - x_crit) / H₁), t < L ∧ x t = x_crit ∧
      ∀ s ≤ t, ∀ g, youdenJ (P₀ s) (P₁ s) g = 0 := by
  obtain ⟨⟨t, ht, htl, hxt⟩, -⟩ := lag_horizon_wall hH hx0 hL hcont hdiff hder
  refine ⟨t, ht, htl, hxt, fun s hs g => ?_⟩
  rw [hblind s (lt_of_le_of_lt hs htl)]
  unfold youdenJ
  exact sub_self _

/-! ## Part 6: Measure-Theoretic `Youden J` & Gaussian-Additive Aliasing Floor over `Measure ℝ` -/

/-- Measure-theoretic Youden advantage `μ₁(A) - μ₀(A)` on a real event `A`. -/
noncomputable def measYoudenJ (μ₀ μ₁ : MeasureTheory.Measure ℝ) (A : Set ℝ) : ℝ :=
  (μ₁ A).toReal - (μ₀ A).toReal

/-- Measure-theoretic two-point error sum `μ₀(A) + μ₁(Aᶜ)`. -/
noncomputable def measErrorSum (μ₀ μ₁ : MeasureTheory.Measure ℝ) (A : Set ℝ) : ℝ :=
  (μ₀ A).toReal + (μ₁ Aᶜ).toReal

/-- For probability measures and measurable `A`, `measYoudenJ = 1 - measErrorSum`. -/
theorem measYoudenJ_eq_one_sub_errorSum (μ₀ μ₁ : MeasureTheory.Measure ℝ)
    [MeasureTheory.IsProbabilityMeasure μ₀] [MeasureTheory.IsProbabilityMeasure μ₁]
    {A : Set ℝ} (hA : MeasurableSet A) :
    measYoudenJ μ₀ μ₁ A = 1 - measErrorSum μ₀ μ₁ A := by
  have hsum : μ₁ A + μ₁ Aᶜ = 1 := by
    rw [MeasureTheory.measure_add_measure_compl hA, MeasureTheory.measure_univ]
  have hreal : (μ₁ A).toReal + (μ₁ Aᶜ).toReal = 1 := by
    rw [← ENNReal.toReal_add (MeasureTheory.measure_ne_top μ₁ A)
      (MeasureTheory.measure_ne_top μ₁ Aᶜ), hsum, ENNReal.toReal_one]
  unfold measYoudenJ measErrorSum
  linarith

/-- For probability measures, `Set.univ` and `∅` have zero `measYoudenJ`. -/
theorem measYoudenJ_const_zero (μ₀ μ₁ : MeasureTheory.Measure ℝ)
    [MeasureTheory.IsProbabilityMeasure μ₀] [MeasureTheory.IsProbabilityMeasure μ₁] :
    measYoudenJ μ₀ μ₁ Set.univ = 0 ∧ measYoudenJ μ₀ μ₁ ∅ = 0 := by
  simp [measYoudenJ]

/-- **Continuous-Channel Lag-Wall Zero Advantage (`lag_wall_measYoudenJ_zero`):** when the reserve
reaches `x_crit` before the delayed continuous channel separates (`∀ t < L, μ₀ t = μ₁ t`), every
event `A` has `measYoudenJ = 0` at every `s ≤ t*`. -/
theorem lag_wall_measYoudenJ_zero {x : ℝ → ℝ} {H₁ L x_crit : ℝ}
    (hH : 0 < H₁) (hx0 : x_crit ≤ x 0) (hL : (x 0 - x_crit) / H₁ < L)
    (hcont : ContinuousOn x (Icc 0 L)) (hdiff : DifferentiableOn ℝ x (Ioo 0 L))
    (hder : ∀ t ∈ Ioo 0 L, deriv x t ≤ -H₁)
    (μ₀ μ₁ : ℝ → MeasureTheory.Measure ℝ) (hblind : ∀ t, t < L → μ₀ t = μ₁ t) :
    ∃ t ∈ Icc 0 ((x 0 - x_crit) / H₁), t < L ∧ x t = x_crit ∧
      ∀ s ≤ t, ∀ A : Set ℝ, measYoudenJ (μ₀ s) (μ₁ s) A = 0 := by
  obtain ⟨⟨t, ht, htl, hxt⟩, -⟩ := lag_horizon_wall hH hx0 hL hcont hdiff hder
  refine ⟨t, ht, htl, hxt, fun s hs A => ?_⟩
  rw [hblind s (lt_of_le_of_lt hs htl)]
  unfold measYoudenJ
  exact sub_self _

/-- Gaussian-additive observation law `N(aliasedProbe α p m f u, v)` on `ℝ`. -/
noncomputable def gaussianAliasedLaw {U O : Type*} (α : ℝ) (p : U → ℝ) (m : O → ℝ) (f : U → O)
    (v : NNReal) (u : U) : MeasureTheory.Measure ℝ :=
  ProbabilityTheory.gaussianReal (aliasedProbe α p m f u) v

/-- Elementary Cauchy-Schwarz inequality for Lebesgue integrals on `ℝ` without `Lp` overhead. -/
theorem integral_cauchy_schwarz {f g : ℝ → ℝ}
    (hf2 : MeasureTheory.Integrable (fun x => f x ^ 2))
    (hg2 : MeasureTheory.Integrable (fun x => g x ^ 2))
    (hfg : MeasureTheory.Integrable (fun x => f x * g x)) :
    (∫ x : ℝ, f x * g x) ^ 2 ≤ (∫ x : ℝ, f x ^ 2) * (∫ x : ℝ, g x ^ 2) := by
  set A : ℝ := ∫ x : ℝ, f x ^ 2
  set B : ℝ := ∫ x : ℝ, f x * g x
  set C : ℝ := ∫ x : ℝ, g x ^ 2
  have hA0 : 0 ≤ A := MeasureTheory.integral_nonneg fun x => sq_nonneg (f x)
  have hquad : ∀ t : ℝ, 0 ≤ t ^ 2 * A + 2 * t * B + C := fun t => by
    have hnonneg : 0 ≤ ∫ x : ℝ, (t * f x + g x) ^ 2 :=
      MeasureTheory.integral_nonneg fun x => sq_nonneg (t * f x + g x)
    have hrew : (fun x : ℝ => (t * f x + g x) ^ 2) =
        fun x : ℝ => t ^ 2 * (f x ^ 2) + ((2 * t) * (f x * g x) + g x ^ 2) := by
      ext x; ring
    have hint : MeasureTheory.Integrable (fun x : ℝ => (2 * t) * (f x * g x) + g x ^ 2) :=
      (hfg.const_mul (2 * t)).add hg2
    rw [hrew, MeasureTheory.integral_add (hf2.const_mul (t ^ 2)) hint,
      MeasureTheory.integral_add (hfg.const_mul (2 * t)) hg2,
      MeasureTheory.integral_const_mul, MeasureTheory.integral_const_mul] at hnonneg
    linarith
  rcases eq_or_lt_of_le hA0 with hAzero | hApos
  · have hB : B = 0 := by
      by_contra hBne
      have hbad := hquad (-(C + 1) / (2 * B))
      rw [← hAzero, mul_zero, zero_add] at hbad
      have h2B : 2 * B ≠ 0 := mul_ne_zero two_ne_zero hBne
      have hcancel : 2 * (-(C + 1) / (2 * B)) * B = -(C + 1) := by
        field_simp
      linarith
    rw [hB, ← hAzero]
    norm_num
  · have hmin := hquad (-B / A)
    have hcalc : (-B / A) ^ 2 * A + 2 * (-B / A) * B + C = C - B ^ 2 / A := by
      field_simp [hApos.ne']
      ring
    rw [hcalc] at hmin
    have hmul : 0 ≤ A * (C - B ^ 2 / A) := mul_nonneg hApos.le hmin
    have hdiv : A * (C - B ^ 2 / A) = A * C - B ^ 2 := by
      field_simp [hApos.ne']
    linarith

/-- Pointwise identity for the geometric mean of two equal-variance Gaussian PDFs. -/
theorem gaussianPDFReal_sqrt_mul_eq (μ₁ μ₂ : ℝ) {v : NNReal} (hv : v ≠ 0) (x : ℝ) :
    Real.sqrt (ProbabilityTheory.gaussianPDFReal μ₁ v x *
        ProbabilityTheory.gaussianPDFReal μ₂ v x) =
      Real.exp (-(μ₁ - μ₂) ^ 2 / (8 * (v : ℝ))) *
        ProbabilityTheory.gaussianPDFReal ((μ₁ + μ₂) / 2) v x := by
  have hvpos : (0 : ℝ) < v := NNReal.coe_pos.mpr (pos_iff_ne_zero.mpr hv)
  have hsq :
      (Real.exp (-(μ₁ - μ₂) ^ 2 / (8 * (v : ℝ))) *
          ProbabilityTheory.gaussianPDFReal ((μ₁ + μ₂) / 2) v x) ^ 2 =
        ProbabilityTheory.gaussianPDFReal μ₁ v x * ProbabilityTheory.gaussianPDFReal μ₂ v x := by
    unfold ProbabilityTheory.gaussianPDFReal
    have hexp :
        Real.exp (-(μ₁ - μ₂) ^ 2 / (8 * (v : ℝ))) ^ 2 *
            Real.exp (-(x - (μ₁ + μ₂) / 2) ^ 2 / (2 * (v : ℝ))) ^ 2 =
          Real.exp (-(x - μ₁) ^ 2 / (2 * (v : ℝ))) *
            Real.exp (-(x - μ₂) ^ 2 / (2 * (v : ℝ))) := by
      simp only [sq, ← Real.exp_add]
      congr 1
      field_simp [hvpos.ne']
      ring
    calc
      (Real.exp (-(μ₁ - μ₂) ^ 2 / (8 * (v : ℝ))) *
          ((√(2 * Real.pi * (v : ℝ)))⁻¹ *
            Real.exp (-(x - (μ₁ + μ₂) / 2) ^ 2 / (2 * (v : ℝ))))) ^ 2
        = ((√(2 * Real.pi * (v : ℝ)))⁻¹ * (√(2 * Real.pi * (v : ℝ)))⁻¹) *
            (Real.exp (-(μ₁ - μ₂) ^ 2 / (8 * (v : ℝ))) ^ 2 *
              Real.exp (-(x - (μ₁ + μ₂) / 2) ^ 2 / (2 * (v : ℝ))) ^ 2) := by ring
      _ = ((√(2 * Real.pi * (v : ℝ)))⁻¹ * (√(2 * Real.pi * (v : ℝ)))⁻¹) *
            (Real.exp (-(x - μ₁) ^ 2 / (2 * (v : ℝ))) *
              Real.exp (-(x - μ₂) ^ 2 / (2 * (v : ℝ)))) := by rw [hexp]
      _ = _ := by ring
  rw [← hsq]
  exact Real.sqrt_sq (mul_nonneg (Real.exp_pos _).le
    (ProbabilityTheory.gaussianPDFReal_nonneg _ _ _))

/-- **Gaussian Bhattacharyya Integral (`gaussian_bhattacharyya_integral`):** the Bhattacharyya
coefficient of two equal-variance Gaussians equals `exp (-(μ₁ - μ₂)^2 / (8 v))`. -/
theorem gaussian_bhattacharyya_integral (μ₁ μ₂ : ℝ) {v : NNReal} (hv : v ≠ 0) :
    ∫ x : ℝ, Real.sqrt (ProbabilityTheory.gaussianPDFReal μ₁ v x *
        ProbabilityTheory.gaussianPDFReal μ₂ v x) =
      Real.exp (-(μ₁ - μ₂) ^ 2 / (8 * (v : ℝ))) := by
  have hfn : (fun x : ℝ => Real.sqrt (ProbabilityTheory.gaussianPDFReal μ₁ v x *
      ProbabilityTheory.gaussianPDFReal μ₂ v x)) =
      fun x : ℝ => Real.exp (-(μ₁ - μ₂) ^ 2 / (8 * (v : ℝ))) *
        ProbabilityTheory.gaussianPDFReal ((μ₁ + μ₂) / 2) v x :=
    funext (gaussianPDFReal_sqrt_mul_eq μ₁ μ₂ hv)
  rw [hfn, MeasureTheory.integral_const_mul,
    ProbabilityTheory.integral_gaussianPDFReal_eq_one ((μ₁ + μ₂) / 2) hv, mul_one]

/-- **Gaussian TV Upper Bound (`gaussian_tv_le_hellinger`):** total variation distance between
equal-variance Gaussians is at most `√(1 - exp (-(μ₁ - μ₂)^2 / (4 v)))`. -/
theorem gaussian_tv_le_hellinger (μ₁ μ₂ : ℝ) {v : NNReal} (hv : v ≠ 0) :
    (1 / 2 : ℝ) * ∫ x : ℝ,
        |ProbabilityTheory.gaussianPDFReal μ₂ v x - ProbabilityTheory.gaussianPDFReal μ₁ v x| ≤
      Real.sqrt (1 - Real.exp (-(μ₁ - μ₂) ^ 2 / (4 * (v : ℝ)))) := by
  let p₁ : ℝ → ℝ := ProbabilityTheory.gaussianPDFReal μ₁ v
  let p₂ : ℝ → ℝ := ProbabilityTheory.gaussianPDFReal μ₂ v
  let f : ℝ → ℝ := fun x => |Real.sqrt (p₂ x) - Real.sqrt (p₁ x)|
  let g : ℝ → ℝ := fun x => Real.sqrt (p₂ x) + Real.sqrt (p₁ x)
  let b : ℝ → ℝ := fun x => Real.sqrt (p₁ x * p₂ x)
  have hp₁ : MeasureTheory.Integrable p₁ := ProbabilityTheory.integrable_gaussianPDFReal μ₁ v
  have hp₂ : MeasureTheory.Integrable p₂ := ProbabilityTheory.integrable_gaussianPDFReal μ₂ v
  have hb_eq : b = fun x => Real.exp (-(μ₁ - μ₂) ^ 2 / (8 * (v : ℝ))) *
      ProbabilityTheory.gaussianPDFReal ((μ₁ + μ₂) / 2) v x :=
    funext (gaussianPDFReal_sqrt_mul_eq μ₁ μ₂ hv)
  have hb_int : MeasureTheory.Integrable b := by
    rw [hb_eq]
    exact (ProbabilityTheory.integrable_gaussianPDFReal ((μ₁ + μ₂) / 2) v).const_mul _
  have hf2_eq : (fun x => f x ^ 2) = fun x => p₂ x + p₁ x - 2 * b x := by
    ext x
    have h1 := ProbabilityTheory.gaussianPDFReal_nonneg μ₁ v x
    have h2 := ProbabilityTheory.gaussianPDFReal_nonneg μ₂ v x
    dsimp only [f, b]
    rw [sq_abs, sub_sq, Real.sq_sqrt h2, Real.sq_sqrt h1, Real.sqrt_mul h1]
    ring
  have hg2_eq : (fun x => g x ^ 2) = fun x => p₂ x + p₁ x + 2 * b x := by
    ext x
    have h1 := ProbabilityTheory.gaussianPDFReal_nonneg μ₁ v x
    have h2 := ProbabilityTheory.gaussianPDFReal_nonneg μ₂ v x
    dsimp only [g, b]
    rw [add_sq, Real.sq_sqrt h2, Real.sq_sqrt h1, Real.sqrt_mul h1]
    ring
  have hfg_eq : (fun x => f x * g x) = fun x => |p₂ x - p₁ x| := by
    ext x
    have h1 := ProbabilityTheory.gaussianPDFReal_nonneg μ₁ v x
    have h2 := ProbabilityTheory.gaussianPDFReal_nonneg μ₂ v x
    have hg0 : 0 ≤ Real.sqrt (p₂ x) + Real.sqrt (p₁ x) :=
      add_nonneg (Real.sqrt_nonneg _) (Real.sqrt_nonneg _)
    dsimp only [f, g]
    calc |Real.sqrt (p₂ x) - Real.sqrt (p₁ x)| * (Real.sqrt (p₂ x) + Real.sqrt (p₁ x))
        = |Real.sqrt (p₂ x) - Real.sqrt (p₁ x)| * |Real.sqrt (p₂ x) + Real.sqrt (p₁ x)| := by
          rw [abs_of_nonneg hg0]
      _ = |(Real.sqrt (p₂ x) - Real.sqrt (p₁ x)) * (Real.sqrt (p₂ x) + Real.sqrt (p₁ x))| :=
          (abs_mul _ _).symm
      _ = |Real.sqrt (p₂ x) ^ 2 - Real.sqrt (p₁ x) ^ 2| := by ring_nf
      _ = |p₂ x - p₁ x| := by rw [Real.sq_sqrt h2, Real.sq_sqrt h1]
  have hp₂₁_int : MeasureTheory.Integrable (fun x => p₂ x + p₁ x) := hp₂.add hp₁
  have h2b_int : MeasureTheory.Integrable (fun x => 2 * b x) := hb_int.const_mul 2
  have hf2_int : MeasureTheory.Integrable (fun x => f x ^ 2) := by
    rw [hf2_eq]; exact hp₂₁_int.sub h2b_int
  have hg2_int : MeasureTheory.Integrable (fun x => g x ^ 2) := by
    rw [hg2_eq]; exact hp₂₁_int.add h2b_int
  have hfg_int : MeasureTheory.Integrable (fun x => f x * g x) := by
    rw [hfg_eq]; exact (hp₂.sub hp₁).abs
  have hcs := integral_cauchy_schwarz hf2_int hg2_int hfg_int
  have hB : ∫ x : ℝ, b x = Real.exp (-(μ₁ - μ₂) ^ 2 / (8 * (v : ℝ))) :=
    gaussian_bhattacharyya_integral μ₁ μ₂ hv
  have hf2_val : ∫ x : ℝ, f x ^ 2 = 2 - 2 * Real.exp (-(μ₁ - μ₂) ^ 2 / (8 * (v : ℝ))) := by
    rw [hf2_eq, MeasureTheory.integral_sub hp₂₁_int h2b_int,
      MeasureTheory.integral_add hp₂ hp₁, MeasureTheory.integral_const_mul,
      ProbabilityTheory.integral_gaussianPDFReal_eq_one μ₂ hv,
      ProbabilityTheory.integral_gaussianPDFReal_eq_one μ₁ hv, hB]
    ring
  have hg2_val : ∫ x : ℝ, g x ^ 2 = 2 + 2 * Real.exp (-(μ₁ - μ₂) ^ 2 / (8 * (v : ℝ))) := by
    rw [hg2_eq, MeasureTheory.integral_add hp₂₁_int h2b_int,
      MeasureTheory.integral_add hp₂ hp₁, MeasureTheory.integral_const_mul,
      ProbabilityTheory.integral_gaussianPDFReal_eq_one μ₂ hv,
      ProbabilityTheory.integral_gaussianPDFReal_eq_one μ₁ hv, hB]
    ring
  rw [hfg_eq, hf2_val, hg2_val] at hcs
  have hexp2 : Real.exp (-(μ₁ - μ₂) ^ 2 / (8 * (v : ℝ))) ^ 2 =
      Real.exp (-(μ₁ - μ₂) ^ 2 / (4 * (v : ℝ))) := by
    rw [sq, ← Real.exp_add]
    congr 1
    ring
  have hsq_bound :
      ((1 / 2 : ℝ) * ∫ x : ℝ, |p₂ x - p₁ x|) ^ 2 ≤
        1 - Real.exp (-(μ₁ - μ₂) ^ 2 / (4 * (v : ℝ))) := by
    rw [← hexp2]
    nlinarith
  have hnonneg : 0 ≤ (1 / 2 : ℝ) * ∫ x : ℝ, |p₂ x - p₁ x| :=
    mul_nonneg (by norm_num) (MeasureTheory.integral_nonneg fun x => abs_nonneg _)
  calc (1 / 2 : ℝ) * ∫ x : ℝ, |p₂ x - p₁ x|
      = Real.sqrt (((1 / 2 : ℝ) * ∫ x : ℝ, |p₂ x - p₁ x|) ^ 2) :=
        (Real.sqrt_sq hnonneg).symm
    _ ≤ Real.sqrt (1 - Real.exp (-(μ₁ - μ₂) ^ 2 / (4 * (v : ℝ)))) :=
        Real.sqrt_le_sqrt hsq_bound

/-- **Gaussian TV Lower Bound (`gaussian_tv_ge_hellinger`):** total variation distance between
equal-variance Gaussians is at least `1 - exp (-(μ₁ - μ₂)^2 / (8 v))`. -/
theorem gaussian_tv_ge_hellinger (μ₁ μ₂ : ℝ) {v : NNReal} (hv : v ≠ 0) :
    1 - Real.exp (-(μ₁ - μ₂) ^ 2 / (8 * (v : ℝ))) ≤
      (1 / 2 : ℝ) * ∫ x : ℝ,
        |ProbabilityTheory.gaussianPDFReal μ₂ v x - ProbabilityTheory.gaussianPDFReal μ₁ v x| := by
  let p₁ : ℝ → ℝ := ProbabilityTheory.gaussianPDFReal μ₁ v
  let p₂ : ℝ → ℝ := ProbabilityTheory.gaussianPDFReal μ₂ v
  let b : ℝ → ℝ := fun x => Real.sqrt (p₁ x * p₂ x)
  have hp₁ : MeasureTheory.Integrable p₁ := ProbabilityTheory.integrable_gaussianPDFReal μ₁ v
  have hp₂ : MeasureTheory.Integrable p₂ := ProbabilityTheory.integrable_gaussianPDFReal μ₂ v
  have hb_eq : b = fun x => Real.exp (-(μ₁ - μ₂) ^ 2 / (8 * (v : ℝ))) *
      ProbabilityTheory.gaussianPDFReal ((μ₁ + μ₂) / 2) v x :=
    funext (gaussianPDFReal_sqrt_mul_eq μ₁ μ₂ hv)
  have hb_int : MeasureTheory.Integrable b := by
    rw [hb_eq]
    exact (ProbabilityTheory.integrable_gaussianPDFReal ((μ₁ + μ₂) / 2) v).const_mul _
  have hpt : ∀ x : ℝ, p₁ x + p₂ x - |p₂ x - p₁ x| ≤ 2 * b x := fun x => by
    have h1 := ProbabilityTheory.gaussianPDFReal_nonneg μ₁ v x
    have h2 := ProbabilityTheory.gaussianPDFReal_nonneg μ₂ v x
    dsimp only [b]
    rcases le_total (p₁ x) (p₂ x) with hle | hle
    · rw [abs_of_nonneg (sub_nonneg.mpr hle)]
      have hsq : p₁ x = Real.sqrt (p₁ x * p₁ x) := (Real.sqrt_mul_self h1).symm
      have hle_sqrt : Real.sqrt (p₁ x * p₁ x) ≤ Real.sqrt (p₁ x * p₂ x) :=
        Real.sqrt_le_sqrt (mul_le_mul_of_nonneg_left hle h1)
      linarith
    · rw [abs_of_nonpos (sub_nonpos.mpr hle)]
      have hsq : p₂ x = Real.sqrt (p₂ x * p₂ x) := (Real.sqrt_mul_self h2).symm
      have hle_sqrt : Real.sqrt (p₂ x * p₂ x) ≤ Real.sqrt (p₁ x * p₂ x) :=
        Real.sqrt_le_sqrt (mul_le_mul_of_nonneg_right hle h2)
      linarith
  have hp₁₂_int : MeasureTheory.Integrable (fun x => p₁ x + p₂ x) := hp₁.add hp₂
  have habs_int : MeasureTheory.Integrable (fun x => |p₂ x - p₁ x|) := (hp₂.sub hp₁).abs
  have h2b_int : MeasureTheory.Integrable (fun x => 2 * b x) := hb_int.const_mul 2
  have hint :
      ∫ x : ℝ, (p₁ x + p₂ x - |p₂ x - p₁ x|) ≤ ∫ x : ℝ, 2 * b x :=
    MeasureTheory.integral_mono (hp₁₂_int.sub habs_int) h2b_int hpt
  rw [MeasureTheory.integral_sub hp₁₂_int habs_int,
    MeasureTheory.integral_add hp₁ hp₂, MeasureTheory.integral_const_mul,
    ProbabilityTheory.integral_gaussianPDFReal_eq_one μ₁ hv,
    ProbabilityTheory.integral_gaussianPDFReal_eq_one μ₂ hv,
    gaussian_bhattacharyya_integral μ₁ μ₂ hv] at hint
  linarith

/-- Helper bound: for any measurable set `A`, `measYoudenJ (gaussianReal μ₁ v) (gaussianReal μ₂ v) A`
is at most half the `L¹` density difference. -/
theorem gaussian_measYoudenJ_le_tv_one (μ₁ μ₂ : ℝ) {v : NNReal} (hv : v ≠ 0)
    {A : Set ℝ} (hA : MeasurableSet A) :
    measYoudenJ (ProbabilityTheory.gaussianReal μ₁ v) (ProbabilityTheory.gaussianReal μ₂ v) A ≤
      (1 / 2 : ℝ) * ∫ x : ℝ,
        |ProbabilityTheory.gaussianPDFReal μ₂ v x - ProbabilityTheory.gaussianPDFReal μ₁ v x| := by
  let p₁ : ℝ → ℝ := ProbabilityTheory.gaussianPDFReal μ₁ v
  let p₂ : ℝ → ℝ := ProbabilityTheory.gaussianPDFReal μ₂ v
  have hp₁ : MeasureTheory.Integrable p₁ := ProbabilityTheory.integrable_gaussianPDFReal μ₁ v
  have hp₂ : MeasureTheory.Integrable p₂ := ProbabilityTheory.integrable_gaussianPDFReal μ₂ v
  have hm₁ : (ProbabilityTheory.gaussianReal μ₁ v A).toReal = ∫ x : ℝ, A.indicator p₁ x := by
    rw [ProbabilityTheory.gaussianReal_apply_eq_integral μ₁ hv A,
      ENNReal.toReal_ofReal (MeasureTheory.integral_nonneg fun x =>
        ProbabilityTheory.gaussianPDFReal_nonneg μ₁ v x),
      MeasureTheory.integral_indicator hA]
  have hm₂ : (ProbabilityTheory.gaussianReal μ₂ v A).toReal = ∫ x : ℝ, A.indicator p₂ x := by
    rw [ProbabilityTheory.gaussianReal_apply_eq_integral μ₂ hv A,
      ENNReal.toReal_ofReal (MeasureTheory.integral_nonneg fun x =>
        ProbabilityTheory.gaussianPDFReal_nonneg μ₂ v x),
      MeasureTheory.integral_indicator hA]
  have hpt : ∀ x : ℝ,
      A.indicator p₂ x - A.indicator p₁ x ≤
        (1 / 2 : ℝ) * |p₂ x - p₁ x| + (1 / 2 : ℝ) * (p₂ x - p₁ x) := fun x => by
    by_cases hx : x ∈ A
    · simp only [Set.indicator_of_mem hx]
      linarith [le_abs_self (p₂ x - p₁ x)]
    · simp only [Set.indicator_of_notMem hx, sub_self]
      linarith [neg_abs_le (p₂ x - p₁ x)]
  have hhalf_abs_int : MeasureTheory.Integrable (fun x => (1 / 2 : ℝ) * |p₂ x - p₁ x|) :=
    (hp₂.sub hp₁).abs.const_mul (1 / 2)
  have hhalf_diff_int : MeasureTheory.Integrable (fun x => (1 / 2 : ℝ) * (p₂ x - p₁ x)) :=
    (hp₂.sub hp₁).const_mul (1 / 2)
  have hint :
      ∫ x : ℝ, (A.indicator p₂ x - A.indicator p₁ x) ≤
        ∫ x : ℝ, ((1 / 2 : ℝ) * |p₂ x - p₁ x| + (1 / 2 : ℝ) * (p₂ x - p₁ x)) :=
    MeasureTheory.integral_mono
      ((hp₂.indicator hA).sub (hp₁.indicator hA))
      (hhalf_abs_int.add hhalf_diff_int)
      hpt
  have hzero : ∫ x : ℝ, (p₂ x - p₁ x) = 0 := by
    rw [MeasureTheory.integral_sub hp₂ hp₁,
      ProbabilityTheory.integral_gaussianPDFReal_eq_one μ₂ hv,
      ProbabilityTheory.integral_gaussianPDFReal_eq_one μ₁ hv, sub_self]
  rw [MeasureTheory.integral_sub (hp₂.indicator hA) (hp₁.indicator hA),
    MeasureTheory.integral_add hhalf_abs_int hhalf_diff_int,
    MeasureTheory.integral_const_mul, MeasureTheory.integral_const_mul, hzero, mul_zero,
    add_zero] at hint
  unfold measYoudenJ
  rw [hm₁, hm₂]
  exact hint

/-- **Gaussian Youden Ceiling (`gaussian_measYoudenJ_le_tv`):** for every measurable event `A`,
`|measYoudenJ (gaussianReal μ₁ v) (gaussianReal μ₂ v) A|` is at most the Gaussian total variation
distance. -/
theorem gaussian_measYoudenJ_le_tv (μ₁ μ₂ : ℝ) {v : NNReal} (hv : v ≠ 0)
    {A : Set ℝ} (hA : MeasurableSet A) :
    |measYoudenJ (ProbabilityTheory.gaussianReal μ₁ v) (ProbabilityTheory.gaussianReal μ₂ v) A| ≤
      (1 / 2 : ℝ) * ∫ x : ℝ,
        |ProbabilityTheory.gaussianPDFReal μ₂ v x - ProbabilityTheory.gaussianPDFReal μ₁ v x| := by
  refine abs_le.mpr ⟨?_, gaussian_measYoudenJ_le_tv_one μ₁ μ₂ hv hA⟩
  have hrev := gaussian_measYoudenJ_le_tv_one μ₂ μ₁ hv hA
  have habs :
      (fun x : ℝ => |ProbabilityTheory.gaussianPDFReal μ₁ v x -
        ProbabilityTheory.gaussianPDFReal μ₂ v x|) =
      fun x : ℝ => |ProbabilityTheory.gaussianPDFReal μ₂ v x -
        ProbabilityTheory.gaussianPDFReal μ₁ v x| := by
    ext x; exact abs_sub_comm _ _
  rw [habs] at hrev
  unfold measYoudenJ at hrev ⊢
  linarith

/-- **Midpoint Threshold Attains Gaussian TV (`gaussian_midpoint_attains_tv`):** for `μ₁ < μ₂`
and `v ≠ 0`, `Set.Ioi ((μ₁ + μ₂) / 2)` attains exact total variation distance. -/
theorem gaussian_midpoint_attains_tv {μ₁ μ₂ : ℝ} (hμ : μ₁ < μ₂) {v : NNReal} (hv : v ≠ 0) :
    measYoudenJ (ProbabilityTheory.gaussianReal μ₁ v) (ProbabilityTheory.gaussianReal μ₂ v)
        (Set.Ioi ((μ₁ + μ₂) / 2)) =
      (1 / 2 : ℝ) * ∫ x : ℝ,
        |ProbabilityTheory.gaussianPDFReal μ₂ v x - ProbabilityTheory.gaussianPDFReal μ₁ v x| := by
  let A : Set ℝ := Set.Ioi ((μ₁ + μ₂) / 2)
  have hA : MeasurableSet A := measurableSet_Ioi
  have hvpos : (0 : ℝ) < v := NNReal.coe_pos.mpr (pos_iff_ne_zero.mpr hv)
  let p₁ : ℝ → ℝ := ProbabilityTheory.gaussianPDFReal μ₁ v
  let p₂ : ℝ → ℝ := ProbabilityTheory.gaussianPDFReal μ₂ v
  have hp₁ : MeasureTheory.Integrable p₁ := ProbabilityTheory.integrable_gaussianPDFReal μ₁ v
  have hp₂ : MeasureTheory.Integrable p₂ := ProbabilityTheory.integrable_gaussianPDFReal μ₂ v
  have hm₁ : (ProbabilityTheory.gaussianReal μ₁ v A).toReal = ∫ x : ℝ, A.indicator p₁ x := by
    rw [ProbabilityTheory.gaussianReal_apply_eq_integral μ₁ hv A,
      ENNReal.toReal_ofReal (MeasureTheory.integral_nonneg fun x =>
        ProbabilityTheory.gaussianPDFReal_nonneg μ₁ v x),
      MeasureTheory.integral_indicator hA]
  have hm₂ : (ProbabilityTheory.gaussianReal μ₂ v A).toReal = ∫ x : ℝ, A.indicator p₂ x := by
    rw [ProbabilityTheory.gaussianReal_apply_eq_integral μ₂ hv A,
      ENNReal.toReal_ofReal (MeasureTheory.integral_nonneg fun x =>
        ProbabilityTheory.gaussianPDFReal_nonneg μ₂ v x),
      MeasureTheory.integral_indicator hA]
  have hpt : ∀ x : ℝ,
      A.indicator p₂ x - A.indicator p₁ x =
        (1 / 2 : ℝ) * |p₂ x - p₁ x| + (1 / 2 : ℝ) * (p₂ x - p₁ x) := fun x => by
    have hcpos : 0 < (√(2 * Real.pi * (v : ℝ)))⁻¹ := by positivity
    by_cases hx : (μ₁ + μ₂) / 2 < x
    · have hmem : x ∈ A := hx
      have hexp_lt : -(x - μ₁) ^ 2 / (2 * (v : ℝ)) < -(x - μ₂) ^ 2 / (2 * (v : ℝ)) := by
        rw [div_lt_div_iff_of_pos_right (by positivity : 0 < 2 * (v : ℝ))]
        nlinarith
      have hp_lt : p₁ x < p₂ x := by
        dsimp only [p₁, p₂, ProbabilityTheory.gaussianPDFReal]
        exact mul_lt_mul_of_pos_left (Real.exp_lt_exp.mpr hexp_lt) hcpos
      simp only [Set.indicator_of_mem hmem]
      rw [abs_of_pos (sub_pos.mpr hp_lt)]
      ring
    · have hnot : x ∉ A := hx
      have hle_x : x ≤ (μ₁ + μ₂) / 2 := not_lt.mp hx
      have hexp_le : -(x - μ₂) ^ 2 / (2 * (v : ℝ)) ≤ -(x - μ₁) ^ 2 / (2 * (v : ℝ)) := by
        rw [div_le_div_iff_of_pos_right (by positivity : 0 < 2 * (v : ℝ))]
        nlinarith
      have hp_le : p₂ x ≤ p₁ x := by
        dsimp only [p₁, p₂, ProbabilityTheory.gaussianPDFReal]
        exact mul_le_mul_of_nonneg_left (Real.exp_le_exp.mpr hexp_le) hcpos.le
      simp only [Set.indicator_of_notMem hnot, sub_self]
      rw [abs_of_nonpos (sub_nonpos.mpr hp_le)]
      ring
  have hhalf_abs_int : MeasureTheory.Integrable (fun x => (1 / 2 : ℝ) * |p₂ x - p₁ x|) :=
    (hp₂.sub hp₁).abs.const_mul (1 / 2)
  have hhalf_diff_int : MeasureTheory.Integrable (fun x => (1 / 2 : ℝ) * (p₂ x - p₁ x)) :=
    (hp₂.sub hp₁).const_mul (1 / 2)
  have hzero : ∫ x : ℝ, (p₂ x - p₁ x) = 0 := by
    rw [MeasureTheory.integral_sub hp₂ hp₁,
      ProbabilityTheory.integral_gaussianPDFReal_eq_one μ₂ hv,
      ProbabilityTheory.integral_gaussianPDFReal_eq_one μ₁ hv, sub_self]
  unfold measYoudenJ
  rw [hm₁, hm₂, ← MeasureTheory.integral_sub (hp₂.indicator hA) (hp₁.indicator hA),
    show (fun x : ℝ => A.indicator p₂ x - A.indicator p₁ x) =
      fun x : ℝ => (1 / 2 : ℝ) * |p₂ x - p₁ x| + (1 / 2 : ℝ) * (p₂ x - p₁ x) from funext hpt,
    MeasureTheory.integral_add hhalf_abs_int hhalf_diff_int,
    MeasureTheory.integral_const_mul, MeasureTheory.integral_const_mul, hzero, mul_zero, add_zero]

/-- **Gaussian Aliased Youden Wall (`gaussian_aliased_youdenJ_wall`):** for same-fiber states
`f u₁ = f u₂`, `α ≤ 1`, `v ≠ 0`, and every measurable event `A`:
- `|measYoudenJ| ≤ √(1 - exp (-((1 - α) |p u₁ - p u₂|)^2 / (4 v)))`
- `√(1 - exp (-((1 - α) |p u₁ - p u₂|)^2 / (4 v))) ≤ (1 - α) |p u₁ - p u₂| / (2 √v)`
- `0 < 1 - √(1 - exp (-((1 - α) |p u₁ - p u₂|)^2 / (4 v))) ≤ measErrorSum`. -/
theorem gaussian_aliased_youdenJ_wall {U O : Type*} {α : ℝ} (hα1 : α ≤ 1)
    (p : U → ℝ) (m : O → ℝ) (f : U → O) {u₁ u₂ : U} (hf : f u₁ = f u₂)
    {v : NNReal} (hv : v ≠ 0) {A : Set ℝ} (hA : MeasurableSet A) :
    |measYoudenJ (gaussianAliasedLaw α p m f v u₁) (gaussianAliasedLaw α p m f v u₂) A| ≤
        Real.sqrt (1 - Real.exp (-((1 - α) * |p u₁ - p u₂|) ^ 2 / (4 * (v : ℝ)))) ∧
      Real.sqrt (1 - Real.exp (-((1 - α) * |p u₁ - p u₂|) ^ 2 / (4 * (v : ℝ)))) ≤
        (1 - α) * |p u₁ - p u₂| / (2 * Real.sqrt (v : ℝ)) ∧
      0 < 1 - Real.sqrt (1 - Real.exp (-((1 - α) * |p u₁ - p u₂|) ^ 2 / (4 * (v : ℝ)))) ∧
      1 - Real.sqrt (1 - Real.exp (-((1 - α) * |p u₁ - p u₂|) ^ 2 / (4 * (v : ℝ)))) ≤
        measErrorSum (gaussianAliasedLaw α p m f v u₁) (gaussianAliasedLaw α p m f v u₂) A := by
  have hvpos : (0 : ℝ) < v := NNReal.coe_pos.mpr (pos_iff_ne_zero.mpr hv)
  have hgap :
      (aliasedProbe α p m f u₁ - aliasedProbe α p m f u₂) ^ 2 =
        ((1 - α) * |p u₁ - p u₂|) ^ 2 := by
    rw [← sq_abs (aliasedProbe α p m f u₁ - aliasedProbe α p m f u₂),
      aliased_fiber_gap hα1 p m f hf]
  have h1 :
      |measYoudenJ (gaussianAliasedLaw α p m f v u₁) (gaussianAliasedLaw α p m f v u₂) A| ≤
        Real.sqrt (1 - Real.exp (-((1 - α) * |p u₁ - p u₂|) ^ 2 / (4 * (v : ℝ)))) := by
    unfold gaussianAliasedLaw
    calc |measYoudenJ (ProbabilityTheory.gaussianReal (aliasedProbe α p m f u₁) v)
            (ProbabilityTheory.gaussianReal (aliasedProbe α p m f u₂) v) A|
        ≤ (1 / 2 : ℝ) * ∫ x : ℝ,
            |ProbabilityTheory.gaussianPDFReal (aliasedProbe α p m f u₂) v x -
              ProbabilityTheory.gaussianPDFReal (aliasedProbe α p m f u₁) v x| :=
          gaussian_measYoudenJ_le_tv _ _ hv hA
      _ ≤ Real.sqrt (1 - Real.exp
            (-(aliasedProbe α p m f u₁ - aliasedProbe α p m f u₂) ^ 2 / (4 * (v : ℝ)))) :=
          gaussian_tv_le_hellinger _ _ hv
      _ = Real.sqrt (1 - Real.exp (-((1 - α) * |p u₁ - p u₂|) ^ 2 / (4 * (v : ℝ)))) := by
          rw [hgap]
  have h2 :
      Real.sqrt (1 - Real.exp (-((1 - α) * |p u₁ - p u₂|) ^ 2 / (4 * (v : ℝ)))) ≤
        (1 - α) * |p u₁ - p u₂| / (2 * Real.sqrt (v : ℝ)) := by
    set Δ : ℝ := (1 - α) * |p u₁ - p u₂|
    have hΔ0 : 0 ≤ Δ := mul_nonneg (by linarith) (abs_nonneg _)
    have hexp : 1 - Real.exp (-(Δ ^ 2 / (4 * (v : ℝ)))) ≤ Δ ^ 2 / (4 * (v : ℝ)) := by
      linarith [Real.add_one_le_exp (-(Δ ^ 2 / (4 * (v : ℝ))))]
    have hneg_div : -Δ ^ 2 / (4 * (v : ℝ)) = -(Δ ^ 2 / (4 * (v : ℝ))) := by ring
    have hsqrt_rhs :
        Real.sqrt (Δ ^ 2 / (4 * (v : ℝ))) = Δ / (2 * Real.sqrt (v : ℝ)) := by
      have hrew : Δ ^ 2 / (4 * (v : ℝ)) = (Δ / (2 * Real.sqrt (v : ℝ))) ^ 2 := by
        calc Δ ^ 2 / (4 * (v : ℝ))
            = Δ ^ 2 / (2 ^ 2 * Real.sqrt (v : ℝ) ^ 2) := by rw [Real.sq_sqrt hvpos.le]; ring
          _ = (Δ / (2 * Real.sqrt (v : ℝ))) ^ 2 := by ring
      rw [hrew]
      exact Real.sqrt_sq (div_nonneg hΔ0 (by positivity))
    rw [hneg_div]
    calc Real.sqrt (1 - Real.exp (-(Δ ^ 2 / (4 * (v : ℝ)))))
        ≤ Real.sqrt (Δ ^ 2 / (4 * (v : ℝ))) := Real.sqrt_le_sqrt hexp
      _ = Δ / (2 * Real.sqrt (v : ℝ)) := hsqrt_rhs
  have h3 :
      0 < 1 - Real.sqrt (1 - Real.exp (-((1 - α) * |p u₁ - p u₂|) ^ 2 / (4 * (v : ℝ)))) := by
    have hlt1 : 1 - Real.exp (-((1 - α) * |p u₁ - p u₂|) ^ 2 / (4 * (v : ℝ))) < 1 := by
      linarith [Real.exp_pos (-((1 - α) * |p u₁ - p u₂|) ^ 2 / (4 * (v : ℝ)))]
    have hsqrt_lt :
        Real.sqrt (1 - Real.exp (-((1 - α) * |p u₁ - p u₂|) ^ 2 / (4 * (v : ℝ)))) < 1 :=
      (Real.sqrt_lt' one_pos).mpr (by norm_num; exact Real.exp_pos _)
    linarith
  have h4 :
      1 - Real.sqrt (1 - Real.exp (-((1 - α) * |p u₁ - p u₂|) ^ 2 / (4 * (v : ℝ)))) ≤
        measErrorSum (gaussianAliasedLaw α p m f v u₁) (gaussianAliasedLaw α p m f v u₂) A := by
    have heq := @measYoudenJ_eq_one_sub_errorSum
      (gaussianAliasedLaw α p m f v u₁) (gaussianAliasedLaw α p m f v u₂)
      (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _)
      (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _) A hA
    have hle := (abs_le.mp h1).2
    linarith
  exact ⟨h1, h2, h3, h4⟩

/-- **Gaussian Aliased Sharpness & Complete Blindness (`gaussian_aliased_midpoint_sharp`):** for
`α < 1`, `f u₁ = f u₂`, `p u₁ < p u₂`, `v ≠ 0`, the midpoint threshold achieves at least
`1 - exp (-((1 - α) |p u₁ - p u₂|)^2 / (8 v)) > 0`; at `α = 1`, every measurable event has
`measYoudenJ = 0` and `measErrorSum = 1`. -/
theorem gaussian_aliased_midpoint_sharp {U O : Type*} {α : ℝ} (hα1 : α < 1)
    (p : U → ℝ) (m : O → ℝ) (f : U → O) {u₁ u₂ : U} (hf : f u₁ = f u₂) (hp : p u₁ < p u₂)
    {v : NNReal} (hv : v ≠ 0) :
    0 < 1 - Real.exp (-((1 - α) * |p u₁ - p u₂|) ^ 2 / (8 * (v : ℝ))) ∧
    1 - Real.exp (-((1 - α) * |p u₁ - p u₂|) ^ 2 / (8 * (v : ℝ))) ≤
      measYoudenJ (gaussianAliasedLaw α p m f v u₁) (gaussianAliasedLaw α p m f v u₂)
        (Set.Ioi ((aliasedProbe α p m f u₁ + aliasedProbe α p m f u₂) / 2)) ∧
    (∀ A : Set ℝ, MeasurableSet A →
      measYoudenJ (gaussianAliasedLaw 1 p m f v u₁) (gaussianAliasedLaw 1 p m f v u₂) A = 0 ∧
      measErrorSum (gaussianAliasedLaw 1 p m f v u₁) (gaussianAliasedLaw 1 p m f v u₂) A = 1) := by
  have hvpos : (0 : ℝ) < v := NNReal.coe_pos.mpr (pos_iff_ne_zero.mpr hv)
  have h1α : 0 < 1 - α := sub_pos.mpr hα1
  have hp_pos : 0 < |p u₁ - p u₂| := abs_pos.mpr (sub_ne_zero.mpr hp.ne)
  have hpos_num : 0 < ((1 - α) * |p u₁ - p u₂|) ^ 2 / (8 * (v : ℝ)) := by positivity
  have h1 : 0 < 1 - Real.exp (-((1 - α) * |p u₁ - p u₂|) ^ 2 / (8 * (v : ℝ))) := by
    have hlt : Real.exp (-((1 - α) * |p u₁ - p u₂|) ^ 2 / (8 * (v : ℝ))) < 1 :=
      Real.exp_lt_one_iff.mpr (by rw [neg_div]; exact neg_lt_zero.mpr hpos_num)
    linarith
  have hμ : aliasedProbe α p m f u₁ < aliasedProbe α p m f u₂ := by
    unfold aliasedProbe
    rw [hf]
    nlinarith
  have hgap :
      (aliasedProbe α p m f u₁ - aliasedProbe α p m f u₂) ^ 2 =
        ((1 - α) * |p u₁ - p u₂|) ^ 2 := by
    rw [← sq_abs (aliasedProbe α p m f u₁ - aliasedProbe α p m f u₂),
      aliased_fiber_gap hα1.le p m f hf]
  have h2 :
      1 - Real.exp (-((1 - α) * |p u₁ - p u₂|) ^ 2 / (8 * (v : ℝ))) ≤
        measYoudenJ (gaussianAliasedLaw α p m f v u₁) (gaussianAliasedLaw α p m f v u₂)
          (Set.Ioi ((aliasedProbe α p m f u₁ + aliasedProbe α p m f u₂) / 2)) := by
    unfold gaussianAliasedLaw
    rw [gaussian_midpoint_attains_tv hμ hv, ← hgap]
    exact gaussian_tv_ge_hellinger _ _ hv
  refine ⟨h1, h2, fun A hA => ?_⟩
  have hlaw : gaussianAliasedLaw 1 p m f v u₁ = gaussianAliasedLaw 1 p m f v u₂ := by
    simp [gaussianAliasedLaw, aliasedProbe, hf]
  have hj : measYoudenJ (gaussianAliasedLaw 1 p m f v u₁) (gaussianAliasedLaw 1 p m f v u₂) A = 0 := by
    rw [hlaw]
    unfold measYoudenJ
    exact sub_self _
  have he : measErrorSum (gaussianAliasedLaw 1 p m f v u₁) (gaussianAliasedLaw 1 p m f v u₂) A = 1 := by
    have hsum := @measYoudenJ_eq_one_sub_errorSum
      (gaussianAliasedLaw 1 p m f v u₁) (gaussianAliasedLaw 1 p m f v u₂)
      (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _)
      (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _) A hA
    linarith
  exact ⟨hj, he⟩

/-- **Gaussian Aliased Lab Witness (`gaussian_aliased_lab_witness`):** under B5's Gaussian model
(`p u₂ - p u₁ = 6/5`, `f u₁ = f u₂`, `sd(α) = 3/100 + 4/100 * α`):
- at `α = 19/20` (`sd = 17/250`), every measurable event has `|measYoudenJ| ≤ 15/34` and
  `measErrorSum ≥ 19/34`;
- at `α = 1` (`sd = 7/100`), every measurable event has `measYoudenJ = 0` and `measErrorSum = 1`;
- at `α = 1/20` (`sd = 4/125`), the midpoint threshold achieves `measYoudenJ ≥ 99/100` and
  `measErrorSum ≤ 1/100`. -/
theorem gaussian_aliased_lab_witness {U O : Type*} (p : U → ℝ) (m : O → ℝ) (f : U → O)
    {u₁ u₂ : U} (hf : f u₁ = f u₂) (hp : p u₂ - p u₁ = 6 / 5) :
    let v₁₉ : NNReal := ⟨(17 / 250) ^ 2, by positivity⟩
    let v₁ : NNReal := ⟨(7 / 100) ^ 2, by positivity⟩
    let v₁_₂₀ : NNReal := ⟨(4 / 125) ^ 2, by positivity⟩
    (∀ A : Set ℝ, MeasurableSet A →
      |measYoudenJ (gaussianAliasedLaw (19 / 20) p m f v₁₉ u₁)
          (gaussianAliasedLaw (19 / 20) p m f v₁₉ u₂) A| ≤ 15 / 34 ∧
      (19 / 34 : ℝ) ≤ measErrorSum (gaussianAliasedLaw (19 / 20) p m f v₁₉ u₁)
          (gaussianAliasedLaw (19 / 20) p m f v₁₉ u₂) A) ∧
    (∀ A : Set ℝ, MeasurableSet A →
      measYoudenJ (gaussianAliasedLaw 1 p m f v₁ u₁)
          (gaussianAliasedLaw 1 p m f v₁ u₂) A = 0 ∧
      measErrorSum (gaussianAliasedLaw 1 p m f v₁ u₁)
          (gaussianAliasedLaw 1 p m f v₁ u₂) A = 1) ∧
    ((99 / 100 : ℝ) ≤ measYoudenJ (gaussianAliasedLaw (1 / 20) p m f v₁_₂₀ u₁)
        (gaussianAliasedLaw (1 / 20) p m f v₁_₂₀ u₂)
        (Set.Ioi ((aliasedProbe (1 / 20) p m f u₁ + aliasedProbe (1 / 20) p m f u₂) / 2)) ∧
      measErrorSum (gaussianAliasedLaw (1 / 20) p m f v₁_₂₀ u₁)
        (gaussianAliasedLaw (1 / 20) p m f v₁_₂₀ u₂)
        (Set.Ioi ((aliasedProbe (1 / 20) p m f u₁ + aliasedProbe (1 / 20) p m f u₂) / 2)) ≤
        1 / 100) := by
  intro v₁₉ v₁ v₁_₂₀
  have hgap : |p u₁ - p u₂| = 6 / 5 := by
    rw [abs_sub_comm, hp, abs_of_pos (by norm_num)]
  have hplt : p u₁ < p u₂ := by linarith
  have hv19_coe : (v₁₉ : ℝ) = (17 / 250) ^ 2 := rfl
  have hv1_coe : (v₁ : ℝ) = (7 / 100) ^ 2 := rfl
  have hv20_coe : (v₁_₂₀ : ℝ) = (4 / 125) ^ 2 := rfl
  have hv19_ne : v₁₉ ≠ 0 := by
    intro h
    have hval : (v₁₉ : ℝ) = 0 := by rw [h]; rfl
    rw [hv19_coe] at hval
    norm_num at hval
  have hv1_ne : v₁ ≠ 0 := by
    intro h
    have hval : (v₁ : ℝ) = 0 := by rw [h]; rfl
    rw [hv1_coe] at hval
    norm_num at hval
  have hv20_ne : v₁_₂₀ ≠ 0 := by
    intro h
    have hval : (v₁_₂₀ : ℝ) = 0 := by rw [h]; rfl
    rw [hv20_coe] at hval
    norm_num at hval
  refine ⟨fun A hA => ?_, fun A hA => ?_, ?_⟩
  · obtain ⟨hJ, hlin, -, -⟩ :=
      gaussian_aliased_youdenJ_wall (by norm_num : (19 / 20 : ℝ) ≤ 1) p m f hf hv19_ne hA
    have hval : (1 - (19 / 20 : ℝ)) * |p u₁ - p u₂| / (2 * Real.sqrt (v₁₉ : ℝ)) = 15 / 34 := by
      have hsq : Real.sqrt (v₁₉ : ℝ) = 17 / 250 := by
        change Real.sqrt ((17 / 250 : ℝ) ^ 2) = 17 / 250
        exact Real.sqrt_sq (by norm_num)
      rw [hgap, hsq]
      norm_num
    have hJle : |measYoudenJ (gaussianAliasedLaw (19 / 20) p m f v₁₉ u₁)
        (gaussianAliasedLaw (19 / 20) p m f v₁₉ u₂) A| ≤ 15 / 34 := by
      linarith
    have hsum := @measYoudenJ_eq_one_sub_errorSum
      (gaussianAliasedLaw (19 / 20) p m f v₁₉ u₁)
      (gaussianAliasedLaw (19 / 20) p m f v₁₉ u₂)
      (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _)
      (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _) A hA
    have hle := (abs_le.mp hJle).2
    exact ⟨hJle, by linarith⟩
  · exact (gaussian_aliased_midpoint_sharp (by norm_num : (1 / 20 : ℝ) < 1) p m f hf hplt
      hv1_ne).2.2 A hA
  · have hsharp := (gaussian_aliased_midpoint_sharp (by norm_num : (1 / 20 : ℝ) < 1) p m f hf hplt
      hv20_ne).2.1
    have hexp_val :
        -((1 - (1 / 20 : ℝ)) * |p u₁ - p u₂|) ^ 2 / (8 * (v₁_₂₀ : ℝ)) = -(81225 / 512) := by
      rw [hgap, hv20_coe]
      norm_num
    have hexp_le : Real.exp (-(81225 / 512 : ℝ)) ≤ 1 / 100 := by
      have hadd := Real.add_one_le_exp (81225 / 512 : ℝ)
      have h100 : (100 : ℝ) ≤ Real.exp (81225 / 512) := by linarith
      rw [Real.exp_neg]
      exact (inv_le_comm₀ (Real.exp_pos _) (by norm_num)).mpr (by norm_num; exact h100)
    rw [hexp_val] at hsharp
    have hj : (99 / 100 : ℝ) ≤ measYoudenJ (gaussianAliasedLaw (1 / 20) p m f v₁_₂₀ u₁)
        (gaussianAliasedLaw (1 / 20) p m f v₁_₂₀ u₂)
        (Set.Ioi ((aliasedProbe (1 / 20) p m f u₁ + aliasedProbe (1 / 20) p m f u₂) / 2)) := by
      linarith
    have hsum := @measYoudenJ_eq_one_sub_errorSum
      (gaussianAliasedLaw (1 / 20) p m f v₁_₂₀ u₁)
      (gaussianAliasedLaw (1 / 20) p m f v₁_₂₀ u₂)
      (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _)
      (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _)
      (Set.Ioi ((aliasedProbe (1 / 20) p m f u₁ + aliasedProbe (1 / 20) p m f u₂) / 2))
      measurableSet_Ioi
    exact ⟨hj, by linarith⟩

/-! ## Part 7: Zero-Variance Dirac Limit (`v = 0`) -/

/-- At zero variance (`v = 0`), `gaussianAliasedLaw` collapses to the Dirac measure at
`aliasedProbe α p m f u`. -/
theorem gaussian_zero_var_eq_dirac {U O : Type*} (α : ℝ) (p : U → ℝ) (m : O → ℝ) (f : U → O)
    (u : U) :
    gaussianAliasedLaw α p m f 0 u = MeasureTheory.Measure.dirac (aliasedProbe α p m f u) :=
  ProbabilityTheory.gaussianReal_zero_var _

/-- **Zero-Variance Dichotomy (`gaussian_zero_var_dichotomy`):** for same-fiber states `f u₁ = f u₂`
at variance `v = 0`:
- (a) if `α = 1 ∨ p u₁ = p u₂`, every measurable event has `measYoudenJ = 0` and `measErrorSum = 1`;
- (b) if `α ≠ 1 ∧ p u₁ ≠ p u₂`, the singleton `{aliasedProbe α p m f u₂}` is measurable and
  achieves exact separation (`measYoudenJ = 1`, `measErrorSum = 0`). -/
theorem gaussian_zero_var_dichotomy {U O : Type*} (α : ℝ) (p : U → ℝ) (m : O → ℝ) (f : U → O)
    {u₁ u₂ : U} (hf : f u₁ = f u₂) :
    ((α = 1 ∨ p u₁ = p u₂) →
      ∀ A : Set ℝ, MeasurableSet A →
        measYoudenJ (gaussianAliasedLaw α p m f 0 u₁) (gaussianAliasedLaw α p m f 0 u₂) A = 0 ∧
        measErrorSum (gaussianAliasedLaw α p m f 0 u₁) (gaussianAliasedLaw α p m f 0 u₂) A = 1) ∧
    ((α ≠ 1 ∧ p u₁ ≠ p u₂) →
      MeasurableSet ({aliasedProbe α p m f u₂} : Set ℝ) ∧
      measYoudenJ (gaussianAliasedLaw α p m f 0 u₁) (gaussianAliasedLaw α p m f 0 u₂)
        ({aliasedProbe α p m f u₂} : Set ℝ) = 1 ∧
      measErrorSum (gaussianAliasedLaw α p m f 0 u₁) (gaussianAliasedLaw α p m f 0 u₂)
        ({aliasedProbe α p m f u₂} : Set ℝ) = 0) := by
  constructor
  · intro h A hA
    have hprobe : aliasedProbe α p m f u₁ = aliasedProbe α p m f u₂ := by
      unfold aliasedProbe
      rcases h with rfl | hp
      · rw [hf]; ring
      · rw [hf, hp]
    have hlaw : gaussianAliasedLaw α p m f 0 u₁ = gaussianAliasedLaw α p m f 0 u₂ := by
      simp [gaussianAliasedLaw, hprobe]
    have hj : measYoudenJ (gaussianAliasedLaw α p m f 0 u₁)
        (gaussianAliasedLaw α p m f 0 u₂) A = 0 := by
      rw [hlaw]
      unfold measYoudenJ
      exact sub_self _
    have he : measErrorSum (gaussianAliasedLaw α p m f 0 u₁)
        (gaussianAliasedLaw α p m f 0 u₂) A = 1 := by
      have hsum := @measYoudenJ_eq_one_sub_errorSum
        (gaussianAliasedLaw α p m f 0 u₁) (gaussianAliasedLaw α p m f 0 u₂)
        (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _)
        (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _) A hA
      linarith
    exact ⟨hj, he⟩
  · rintro ⟨hα, hp⟩
    have hA : MeasurableSet ({aliasedProbe α p m f u₂} : Set ℝ) := measurableSet_singleton _
    have hneq : aliasedProbe α p m f u₁ ≠ aliasedProbe α p m f u₂ := by
      intro heq
      have hdiff : (1 - α) * (p u₁ - p u₂) = 0 := by
        have h1 : aliasedProbe α p m f u₁ - aliasedProbe α p m f u₂ = 0 := sub_eq_zero.mpr heq
        unfold aliasedProbe at h1
        rw [hf] at h1
        linarith
      rcases mul_eq_zero.mp hdiff with h1α | hpu
      · exact hα (by linarith)
      · exact hp (sub_eq_zero.mp hpu)
    have hm₁ : gaussianAliasedLaw α p m f 0 u₁ ({aliasedProbe α p m f u₂} : Set ℝ) = 0 := by
      rw [gaussian_zero_var_eq_dirac, MeasureTheory.Measure.dirac_apply' _ hA,
        Set.indicator_of_notMem (Set.mem_singleton_iff.not.mpr hneq)]
    have hm₂ : gaussianAliasedLaw α p m f 0 u₂ ({aliasedProbe α p m f u₂} : Set ℝ) = 1 := by
      rw [gaussian_zero_var_eq_dirac, MeasureTheory.Measure.dirac_apply' _ hA,
        Set.indicator_of_mem (Set.mem_singleton _), Pi.one_apply]
    have hj : measYoudenJ (gaussianAliasedLaw α p m f 0 u₁) (gaussianAliasedLaw α p m f 0 u₂)
        ({aliasedProbe α p m f u₂} : Set ℝ) = 1 := by
      unfold measYoudenJ
      rw [hm₁, hm₂]
      norm_num
    have he : measErrorSum (gaussianAliasedLaw α p m f 0 u₁) (gaussianAliasedLaw α p m f 0 u₂)
        ({aliasedProbe α p m f u₂} : Set ℝ) = 0 := by
      have hsum := @measYoudenJ_eq_one_sub_errorSum
        (gaussianAliasedLaw α p m f 0 u₁) (gaussianAliasedLaw α p m f 0 u₂)
        (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _)
        (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _) _ hA
      linarith
    exact ⟨hA, hj, he⟩

/-! ## Part 8: Multi-Step (`T`-Sample) Sequential Gaussian Aliasing & Lag-Sample Wall -/

section SequentialGaussian

open scoped MeasureTheory

/-- `T`-fold convolution power of a real measure (`convPow μ 0 = dirac 0`,
`convPow μ (n + 1) = (convPow μ n) ∗ μ`). -/
noncomputable def convPow (μ : MeasureTheory.Measure ℝ) : ℕ → MeasureTheory.Measure ℝ
  | 0 => MeasureTheory.Measure.dirac 0
  | n + 1 => MeasureTheory.Measure.conv (convPow μ n) μ

/-- The `T`-fold convolution power of `gaussianReal μ v` is `gaussianReal (T * μ) (T * v)`. -/
theorem convPow_gaussianReal (μ : ℝ) (v : NNReal) (T : ℕ) :
    convPow (ProbabilityTheory.gaussianReal μ v) T =
      ProbabilityTheory.gaussianReal ((T : ℝ) * μ) ((T : NNReal) * v) := by
  induction T with
  | zero =>
    simp [convPow, ProbabilityTheory.gaussianReal_zero_var]
  | succ n ih =>
    rw [convPow, ih, ProbabilityTheory.gaussianReal_conv_gaussianReal]
    congr 1 <;> push_cast <;> ring

/-- `T`-step cumulative-sum observation law for `gaussianAliasedLaw`. -/
noncomputable def gaussianSeqLaw {U O : Type*} (T : ℕ) (α : ℝ) (p : U → ℝ) (m : O → ℝ)
    (f : U → O) (v : NNReal) (u : U) : MeasureTheory.Measure ℝ :=
  convPow (gaussianAliasedLaw α p m f v u) T

/-- Closed form of the `T`-step cumulative Gaussian aliased law. -/
theorem gaussianSeqLaw_eq_gaussianReal {U O : Type*} (T : ℕ) (α : ℝ) (p : U → ℝ) (m : O → ℝ)
    (f : U → O) (v : NNReal) (u : U) :
    gaussianSeqLaw T α p m f v u =
      ProbabilityTheory.gaussianReal ((T : ℝ) * aliasedProbe α p m f u) ((T : NNReal) * v) :=
  convPow_gaussianReal (aliasedProbe α p m f u) v T

/-- For `0 < T`, pushing forward `gaussianSeqLaw T` by `(· / T)` gives the sample-mean Gaussian
with mean `aliasedProbe α p m f u` and variance `v / T`. -/
theorem gaussianSeqMean_map_eq {U O : Type*} {T : ℕ} (hT : 0 < T) (α : ℝ) (p : U → ℝ)
    (m : O → ℝ) (f : U → O) (v : NNReal) (u : U) :
    (gaussianSeqLaw T α p m f v u).map (· / (T : ℝ)) =
      ProbabilityTheory.gaussianReal (aliasedProbe α p m f u)
        (v / ⟨(T : ℝ), Nat.cast_nonneg T⟩) := by
  have hTne : (T : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr hT.ne'
  rw [gaussianSeqLaw_eq_gaussianReal, ProbabilityTheory.gaussianReal_map_div_const]
  congr 1
  · field_simp
  · ext
    change ((T : ℝ) * (v : ℝ)) / (T : ℝ) ^ 2 = (v : ℝ) / (T : ℝ)
    field_simp

/-- **Sequential Gaussian Aliased Youden Wall (`gaussian_seq_youdenJ_wall`):** for `0 < T`,
`α ≤ 1`, same-fiber states `f u₁ = f u₂`, `v ≠ 0`, and every measurable event `A`:
- `|measYoudenJ| ≤ √(1 - exp (-(T * ((1 - α) |p u₁ - p u₂|)^2) / (4 v)))`
- `√(1 - exp (-(T * ((1 - α) |p u₁ - p u₂|)^2) / (4 v))) ≤ √T * ((1 - α) |p u₁ - p u₂|) / (2 √v)`
- `0 < 1 - √(1 - exp (...)) ≤ measErrorSum`. -/
theorem gaussian_seq_youdenJ_wall {U O : Type*} {T : ℕ} (hT : 0 < T) {α : ℝ} (hα1 : α ≤ 1)
    (p : U → ℝ) (m : O → ℝ) (f : U → O) {u₁ u₂ : U} (hf : f u₁ = f u₂)
    {v : NNReal} (hv : v ≠ 0) {A : Set ℝ} (hA : MeasurableSet A) :
    |measYoudenJ (gaussianSeqLaw T α p m f v u₁) (gaussianSeqLaw T α p m f v u₂) A| ≤
        Real.sqrt (1 - Real.exp
          (-((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (4 * (v : ℝ)))) ∧
      Real.sqrt (1 - Real.exp
          (-((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (4 * (v : ℝ)))) ≤
        Real.sqrt (T : ℝ) * ((1 - α) * |p u₁ - p u₂|) / (2 * Real.sqrt (v : ℝ)) ∧
      0 < 1 - Real.sqrt (1 - Real.exp
        (-((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (4 * (v : ℝ)))) ∧
      1 - Real.sqrt (1 - Real.exp
          (-((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (4 * (v : ℝ)))) ≤
        measErrorSum (gaussianSeqLaw T α p m f v u₁) (gaussianSeqLaw T α p m f v u₂) A := by
  have hTpos : (0 : ℝ) < T := Nat.cast_pos.mpr hT
  have hTne : (T : NNReal) ≠ 0 := Nat.cast_ne_zero.mpr hT.ne'
  have hvT : (T : NNReal) * v ≠ 0 := mul_ne_zero hTne hv
  have hvpos : (0 : ℝ) < v := NNReal.coe_pos.mpr (pos_iff_ne_zero.mpr hv)
  have hgap :
      ((T : ℝ) * aliasedProbe α p m f u₁ - (T : ℝ) * aliasedProbe α p m f u₂) ^ 2 /
          (4 * (((T : NNReal) * v : NNReal) : ℝ)) =
        ((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (4 * (v : ℝ)) := by
    have hsub :
        ((T : ℝ) * aliasedProbe α p m f u₁ - (T : ℝ) * aliasedProbe α p m f u₂) ^ 2 =
          (T : ℝ) ^ 2 * ((1 - α) * |p u₁ - p u₂|) ^ 2 := by
      rw [← mul_sub, mul_pow, ← sq_abs (aliasedProbe α p m f u₁ - aliasedProbe α p m f u₂),
        aliased_fiber_gap hα1 p m f hf]
    rw [hsub, NNReal.coe_mul, NNReal.coe_natCast]
    field_simp [hTpos.ne', hvpos.ne']
  have h1 :
      |measYoudenJ (gaussianSeqLaw T α p m f v u₁) (gaussianSeqLaw T α p m f v u₂) A| ≤
        Real.sqrt (1 - Real.exp
          (-((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (4 * (v : ℝ)))) := by
    rw [gaussianSeqLaw_eq_gaussianReal, gaussianSeqLaw_eq_gaussianReal]
    calc |measYoudenJ (ProbabilityTheory.gaussianReal ((T : ℝ) * aliasedProbe α p m f u₁) ((T : NNReal) * v))
            (ProbabilityTheory.gaussianReal ((T : ℝ) * aliasedProbe α p m f u₂) ((T : NNReal) * v)) A|
        ≤ (1 / 2 : ℝ) * ∫ x : ℝ,
            |ProbabilityTheory.gaussianPDFReal ((T : ℝ) * aliasedProbe α p m f u₂) ((T : NNReal) * v) x -
              ProbabilityTheory.gaussianPDFReal ((T : ℝ) * aliasedProbe α p m f u₁) ((T : NNReal) * v) x| :=
          gaussian_measYoudenJ_le_tv _ _ hvT hA
      _ ≤ Real.sqrt (1 - Real.exp
            (-((T : ℝ) * aliasedProbe α p m f u₁ - (T : ℝ) * aliasedProbe α p m f u₂) ^ 2 /
              (4 * (((T : NNReal) * v : NNReal) : ℝ)))) :=
          gaussian_tv_le_hellinger _ _ hvT
      _ = Real.sqrt (1 - Real.exp
            (-((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (4 * (v : ℝ)))) := by
          rw [neg_div, neg_div, hgap]
  have h2 :
      Real.sqrt (1 - Real.exp (-((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (4 * (v : ℝ)))) ≤
        Real.sqrt (T : ℝ) * ((1 - α) * |p u₁ - p u₂|) / (2 * Real.sqrt (v : ℝ)) := by
    set Δ : ℝ := (1 - α) * |p u₁ - p u₂|
    have hΔ0 : 0 ≤ Δ := mul_nonneg (by linarith) (abs_nonneg _)
    have hexp :
        1 - Real.exp (-((T : ℝ) * Δ ^ 2 / (4 * (v : ℝ)))) ≤ (T : ℝ) * Δ ^ 2 / (4 * (v : ℝ)) := by
      linarith [Real.add_one_le_exp (-((T : ℝ) * Δ ^ 2 / (4 * (v : ℝ))))]
    have hneg_div :
        -((T : ℝ) * Δ ^ 2) / (4 * (v : ℝ)) = -((T : ℝ) * Δ ^ 2 / (4 * (v : ℝ))) := by ring
    have hsqrt_rhs :
        Real.sqrt ((T : ℝ) * Δ ^ 2 / (4 * (v : ℝ))) =
          Real.sqrt (T : ℝ) * Δ / (2 * Real.sqrt (v : ℝ)) := by
      have hrew :
          (T : ℝ) * Δ ^ 2 / (4 * (v : ℝ)) =
            (Real.sqrt (T : ℝ) * Δ / (2 * Real.sqrt (v : ℝ))) ^ 2 := by
        calc (T : ℝ) * Δ ^ 2 / (4 * (v : ℝ))
            = (Real.sqrt (T : ℝ) ^ 2 * Δ ^ 2) / (2 ^ 2 * Real.sqrt (v : ℝ) ^ 2) := by
              rw [Real.sq_sqrt hTpos.le, Real.sq_sqrt hvpos.le]; ring
          _ = (Real.sqrt (T : ℝ) * Δ / (2 * Real.sqrt (v : ℝ))) ^ 2 := by ring
      rw [hrew]
      exact Real.sqrt_sq (div_nonneg (mul_nonneg (Real.sqrt_nonneg _) hΔ0) (by positivity))
    rw [hneg_div]
    calc Real.sqrt (1 - Real.exp (-((T : ℝ) * Δ ^ 2 / (4 * (v : ℝ)))))
        ≤ Real.sqrt ((T : ℝ) * Δ ^ 2 / (4 * (v : ℝ))) := Real.sqrt_le_sqrt hexp
      _ = Real.sqrt (T : ℝ) * Δ / (2 * Real.sqrt (v : ℝ)) := hsqrt_rhs
  have h3 :
      0 < 1 - Real.sqrt (1 - Real.exp
        (-((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (4 * (v : ℝ)))) := by
    have hsqrt_lt :
        Real.sqrt (1 - Real.exp
          (-((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (4 * (v : ℝ)))) < 1 :=
      (Real.sqrt_lt' one_pos).mpr (by norm_num; exact Real.exp_pos _)
    linarith
  have h4 :
      1 - Real.sqrt (1 - Real.exp
          (-((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (4 * (v : ℝ)))) ≤
        measErrorSum (gaussianSeqLaw T α p m f v u₁) (gaussianSeqLaw T α p m f v u₂) A := by
    have hsum :
        measYoudenJ (gaussianSeqLaw T α p m f v u₁) (gaussianSeqLaw T α p m f v u₂) A =
          1 - measErrorSum (gaussianSeqLaw T α p m f v u₁) (gaussianSeqLaw T α p m f v u₂) A := by
      rw [gaussianSeqLaw_eq_gaussianReal, gaussianSeqLaw_eq_gaussianReal]
      exact @measYoudenJ_eq_one_sub_errorSum
        (ProbabilityTheory.gaussianReal ((T : ℝ) * aliasedProbe α p m f u₁) ((T : NNReal) * v))
        (ProbabilityTheory.gaussianReal ((T : ℝ) * aliasedProbe α p m f u₂) ((T : NNReal) * v))
        (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _)
        (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _) A hA
    have hle := (abs_le.mp h1).2
    linarith
  exact ⟨h1, h2, h3, h4⟩

/-- **Sequential Gaussian Sample-Complexity Lower Bound (`gaussian_seq_sample_complexity_lower_bound`):**
attaining advantage `J_target > 0` under `α < 1`, `f u₁ = f u₂`, `p u₁ ≠ p u₂`, `v ≠ 0` requires at
least `4 v J_target^2 / ((1 - α) |p u₁ - p u₂|)^2 ≤ T` steps. -/
theorem gaussian_seq_sample_complexity_lower_bound {U O : Type*} {T : ℕ} (hT : 0 < T)
    {α : ℝ} (hα1 : α < 1) (p : U → ℝ) (m : O → ℝ) (f : U → O) {u₁ u₂ : U} (hf : f u₁ = f u₂)
    (hp : p u₁ ≠ p u₂) {v : NNReal} (hv : v ≠ 0) {A : Set ℝ} (hA : MeasurableSet A)
    {J_target : ℝ} (hJ0 : 0 < J_target)
    (hJ : J_target ≤ |measYoudenJ (gaussianSeqLaw T α p m f v u₁)
      (gaussianSeqLaw T α p m f v u₂) A|) :
    4 * (v : ℝ) * J_target ^ 2 / ((1 - α) * |p u₁ - p u₂|) ^ 2 ≤ (T : ℝ) := by
  have hvpos : (0 : ℝ) < v := NNReal.coe_pos.mpr (pos_iff_ne_zero.mpr hv)
  have hTpos : (0 : ℝ) < T := Nat.cast_pos.mpr hT
  set Δ : ℝ := (1 - α) * |p u₁ - p u₂|
  have hΔpos : 0 < Δ := mul_pos (sub_pos.mpr hα1) (abs_pos.mpr (sub_ne_zero.mpr hp))
  obtain ⟨h1, h2, -, -⟩ := gaussian_seq_youdenJ_wall hT hα1.le p m f hf hv hA
  have hlin : J_target ≤ Real.sqrt (T : ℝ) * Δ / (2 * Real.sqrt (v : ℝ)) := by linarith
  have hsqrt_v_pos : 0 < 2 * Real.sqrt (v : ℝ) := by positivity
  have hmul : 2 * Real.sqrt (v : ℝ) * J_target ≤ Real.sqrt (T : ℝ) * Δ := by
    have := (le_div_iff₀ hsqrt_v_pos).mp hlin
    linarith
  have hsq : (2 * Real.sqrt (v : ℝ) * J_target) ^ 2 ≤ (Real.sqrt (T : ℝ) * Δ) ^ 2 :=
    pow_le_pow_left₀ (by positivity) hmul 2
  have hsq_lhs : (2 * Real.sqrt (v : ℝ) * J_target) ^ 2 = 4 * (v : ℝ) * J_target ^ 2 := by
    calc (2 * Real.sqrt (v : ℝ) * J_target) ^ 2
        = 4 * Real.sqrt (v : ℝ) ^ 2 * J_target ^ 2 := by ring
      _ = 4 * (v : ℝ) * J_target ^ 2 := by rw [Real.sq_sqrt hvpos.le]
  have hsq_rhs : (Real.sqrt (T : ℝ) * Δ) ^ 2 = (T : ℝ) * Δ ^ 2 := by
    calc (Real.sqrt (T : ℝ) * Δ) ^ 2
        = Real.sqrt (T : ℝ) ^ 2 * Δ ^ 2 := by ring
      _ = (T : ℝ) * Δ ^ 2 := by rw [Real.sq_sqrt hTpos.le]
  rw [hsq_lhs, hsq_rhs] at hsq
  exact (div_le_iff₀ (sq_pos_of_pos hΔpos)).mpr hsq

/-- **Sequential Gaussian Midpoint Sharpness (`gaussian_seq_midpoint_sharp`):** for `0 < T`,
`α < 1`, `f u₁ = f u₂`, `p u₁ < p u₂`, `v ≠ 0`, the `T`-sample midpoint threshold attains at least
`1 - exp (-(T * ((1 - α) |p u₁ - p u₂|)^2) / (8 v)) > 0`. -/
theorem gaussian_seq_midpoint_sharp {U O : Type*} {T : ℕ} (hT : 0 < T) {α : ℝ} (hα1 : α < 1)
    (p : U → ℝ) (m : O → ℝ) (f : U → O) {u₁ u₂ : U} (hf : f u₁ = f u₂) (hp : p u₁ < p u₂)
    {v : NNReal} (hv : v ≠ 0) :
    0 < 1 - Real.exp (-((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (8 * (v : ℝ))) ∧
    1 - Real.exp (-((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (8 * (v : ℝ))) ≤
      measYoudenJ (gaussianSeqLaw T α p m f v u₁) (gaussianSeqLaw T α p m f v u₂)
        (Set.Ioi (((T : ℝ) * aliasedProbe α p m f u₁ +
          (T : ℝ) * aliasedProbe α p m f u₂) / 2)) := by
  have hTpos : (0 : ℝ) < T := Nat.cast_pos.mpr hT
  have hTne : (T : NNReal) ≠ 0 := Nat.cast_ne_zero.mpr hT.ne'
  have hvT : (T : NNReal) * v ≠ 0 := mul_ne_zero hTne hv
  have hvpos : (0 : ℝ) < v := NNReal.coe_pos.mpr (pos_iff_ne_zero.mpr hv)
  have h1α : 0 < 1 - α := sub_pos.mpr hα1
  have hp_pos : 0 < |p u₁ - p u₂| := abs_pos.mpr (sub_ne_zero.mpr hp.ne)
  have hpos_num : 0 < ((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (8 * (v : ℝ)) := by positivity
  have h1 :
      0 < 1 - Real.exp (-((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (8 * (v : ℝ))) := by
    have hlt : Real.exp (-((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (8 * (v : ℝ))) < 1 :=
      Real.exp_lt_one_iff.mpr (by rw [neg_div]; exact neg_lt_zero.mpr hpos_num)
    linarith
  have hμ12 : aliasedProbe α p m f u₁ < aliasedProbe α p m f u₂ := by
    unfold aliasedProbe
    rw [hf]
    nlinarith
  have hμ : (T : ℝ) * aliasedProbe α p m f u₁ < (T : ℝ) * aliasedProbe α p m f u₂ :=
    mul_lt_mul_of_pos_left hμ12 hTpos
  have hgap :
      ((T : ℝ) * aliasedProbe α p m f u₁ - (T : ℝ) * aliasedProbe α p m f u₂) ^ 2 /
          (8 * (((T : NNReal) * v : NNReal) : ℝ)) =
        ((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (8 * (v : ℝ)) := by
    have hsub :
        ((T : ℝ) * aliasedProbe α p m f u₁ - (T : ℝ) * aliasedProbe α p m f u₂) ^ 2 =
          (T : ℝ) ^ 2 * ((1 - α) * |p u₁ - p u₂|) ^ 2 := by
      rw [← mul_sub, mul_pow, ← sq_abs (aliasedProbe α p m f u₁ - aliasedProbe α p m f u₂),
        aliased_fiber_gap hα1.le p m f hf]
    rw [hsub, NNReal.coe_mul, NNReal.coe_natCast]
    field_simp [hTpos.ne', hvpos.ne']
  have h2 :
      1 - Real.exp (-((T : ℝ) * ((1 - α) * |p u₁ - p u₂|) ^ 2) / (8 * (v : ℝ))) ≤
        measYoudenJ (gaussianSeqLaw T α p m f v u₁) (gaussianSeqLaw T α p m f v u₂)
          (Set.Ioi (((T : ℝ) * aliasedProbe α p m f u₁ +
            (T : ℝ) * aliasedProbe α p m f u₂) / 2)) := by
    rw [gaussianSeqLaw_eq_gaussianReal, gaussianSeqLaw_eq_gaussianReal,
      gaussian_midpoint_attains_tv hμ hvT]
    have hge := gaussian_tv_ge_hellinger
      ((T : ℝ) * aliasedProbe α p m f u₁) ((T : ℝ) * aliasedProbe α p m f u₂) hvT
    rw [neg_div, hgap, ← neg_div] at hge
    exact hge
  exact ⟨h1, h2⟩

/-- **Joint Lag + Sequential Aliasing Wall (`sequential_gaussian_lag_sample_wall`):** whenever the
lag-bounded horizon `(x 0 - x_crit) / H₁ < L` is strictly shorter than the required sample
complexity `4 v J_target^2 / ((1 - α) |p u₁ - p u₂|)^2`, the reserve hits `x_crit` at some
`t ≤ (x 0 - x_crit) / H₁ < L` and every detector using `0 < T ≤ t` samples has
`|measYoudenJ| < J_target` on every measurable event `A`. -/
theorem sequential_gaussian_lag_sample_wall {U O : Type*} {x : ℝ → ℝ} {H₁ L x_crit : ℝ}
    (hH : 0 < H₁) (hx0 : x_crit ≤ x 0) (hL : (x 0 - x_crit) / H₁ < L)
    (hcont : ContinuousOn x (Icc 0 L)) (hdiff : DifferentiableOn ℝ x (Ioo 0 L))
    (hder : ∀ t ∈ Ioo 0 L, deriv x t ≤ -H₁)
    {α : ℝ} (hα1 : α < 1) (p : U → ℝ) (m : O → ℝ) (f : U → O) {u₁ u₂ : U} (hf : f u₁ = f u₂)
    (hp : p u₁ ≠ p u₂) {v : NNReal} (hv : v ≠ 0) {J_target : ℝ} (hJ0 : 0 < J_target)
    (hwall : (x 0 - x_crit) / H₁ < 4 * (v : ℝ) * J_target ^ 2 / ((1 - α) * |p u₁ - p u₂|) ^ 2) :
    ∃ t ∈ Icc 0 ((x 0 - x_crit) / H₁), t < L ∧ x t = x_crit ∧
      ∀ T : ℕ, 0 < T → (T : ℝ) ≤ t → ∀ A : Set ℝ, MeasurableSet A →
        |measYoudenJ (gaussianSeqLaw T α p m f v u₁) (gaussianSeqLaw T α p m f v u₂) A| <
          J_target := by
  obtain ⟨⟨t, ht, htl, hxt⟩, -⟩ := lag_horizon_wall hH hx0 hL hcont hdiff hder
  refine ⟨t, ht, htl, hxt, fun T hT hTt A hA => ?_⟩
  by_contra hnot
  have hle : J_target ≤ |measYoudenJ (gaussianSeqLaw T α p m f v u₁)
      (gaussianSeqLaw T α p m f v u₂) A| := not_lt.mp hnot
  have hcomp := gaussian_seq_sample_complexity_lower_bound hT hα1 p m f hf hp hv hA hJ0 hle
  linarith [ht.2]

/-- **Sequential Gaussian Lab Witness (`gaussian_seq_lab_witness`):** under B5 (`α = 19/20`,
`p u₂ - p u₁ = 6/5`, `f u₁ = f u₂`, `v₁₉ = (17/250)^2`):
- at `T = 4`: every measurable event has `|measYoudenJ| ≤ 15/17 < 9/10` and `measErrorSum ≥ 2/17`;
- at `T = 100`: the `100`-sample midpoint threshold achieves `measYoudenJ ≥ 9/10` and
  `measErrorSum ≤ 1/10`. -/
theorem gaussian_seq_lab_witness {U O : Type*} (p : U → ℝ) (m : O → ℝ) (f : U → O)
    {u₁ u₂ : U} (hf : f u₁ = f u₂) (hp : p u₂ - p u₁ = 6 / 5) :
    let v₁₉ : NNReal := ⟨(17 / 250) ^ 2, by positivity⟩
    (∀ A : Set ℝ, MeasurableSet A →
      |measYoudenJ (gaussianSeqLaw 4 (19 / 20) p m f v₁₉ u₁)
          (gaussianSeqLaw 4 (19 / 20) p m f v₁₉ u₂) A| ≤ 15 / 17 ∧
      (15 / 17 : ℝ) < 9 / 10 ∧
      (2 / 17 : ℝ) ≤ measErrorSum (gaussianSeqLaw 4 (19 / 20) p m f v₁₉ u₁)
          (gaussianSeqLaw 4 (19 / 20) p m f v₁₉ u₂) A) ∧
    ((9 / 10 : ℝ) ≤ measYoudenJ (gaussianSeqLaw 100 (19 / 20) p m f v₁₉ u₁)
        (gaussianSeqLaw 100 (19 / 20) p m f v₁₉ u₂)
        (Set.Ioi (((100 : ℝ) * aliasedProbe (19 / 20) p m f u₁ +
          (100 : ℝ) * aliasedProbe (19 / 20) p m f u₂) / 2)) ∧
      measErrorSum (gaussianSeqLaw 100 (19 / 20) p m f v₁₉ u₁)
        (gaussianSeqLaw 100 (19 / 20) p m f v₁₉ u₂)
        (Set.Ioi (((100 : ℝ) * aliasedProbe (19 / 20) p m f u₁ +
          (100 : ℝ) * aliasedProbe (19 / 20) p m f u₂) / 2)) ≤ 1 / 10) := by
  intro v₁₉
  have hgap : |p u₁ - p u₂| = 6 / 5 := by
    rw [abs_sub_comm, hp, abs_of_pos (by norm_num)]
  have hplt : p u₁ < p u₂ := by linarith
  have hv19_coe : (v₁₉ : ℝ) = (17 / 250) ^ 2 := rfl
  have hv19_ne : v₁₉ ≠ 0 := by
    intro h
    have hval : (v₁₉ : ℝ) = 0 := by rw [h]; rfl
    rw [hv19_coe] at hval
    norm_num at hval
  refine ⟨fun A hA => ?_, ?_⟩
  · obtain ⟨hJ, hlin, -, -⟩ := gaussian_seq_youdenJ_wall (by norm_num : 0 < 4)
      (by norm_num : (19 / 20 : ℝ) ≤ 1) p m f hf hv19_ne hA
    have hval :
        Real.sqrt (4 : ℝ) * ((1 - (19 / 20 : ℝ)) * |p u₁ - p u₂|) / (2 * Real.sqrt (v₁₉ : ℝ)) =
          15 / 17 := by
      have hsq4 : Real.sqrt (4 : ℝ) = 2 := by
        rw [show (4 : ℝ) = 2 ^ 2 by norm_num]
        exact Real.sqrt_sq (by norm_num)
      have hsqv : Real.sqrt (v₁₉ : ℝ) = 17 / 250 := by
        change Real.sqrt ((17 / 250 : ℝ) ^ 2) = 17 / 250
        exact Real.sqrt_sq (by norm_num)
      rw [hgap, hsq4, hsqv]
      norm_num
    have hJle : |measYoudenJ (gaussianSeqLaw 4 (19 / 20) p m f v₁₉ u₁)
        (gaussianSeqLaw 4 (19 / 20) p m f v₁₉ u₂) A| ≤ 15 / 17 := by
      linarith
    have hsum :
        measYoudenJ (gaussianSeqLaw 4 (19 / 20) p m f v₁₉ u₁)
            (gaussianSeqLaw 4 (19 / 20) p m f v₁₉ u₂) A =
          1 - measErrorSum (gaussianSeqLaw 4 (19 / 20) p m f v₁₉ u₁)
            (gaussianSeqLaw 4 (19 / 20) p m f v₁₉ u₂) A := by
      rw [gaussianSeqLaw_eq_gaussianReal, gaussianSeqLaw_eq_gaussianReal]
      exact @measYoudenJ_eq_one_sub_errorSum
        (ProbabilityTheory.gaussianReal ((4 : ℝ) * aliasedProbe (19 / 20) p m f u₁)
          ((4 : NNReal) * v₁₉))
        (ProbabilityTheory.gaussianReal ((4 : ℝ) * aliasedProbe (19 / 20) p m f u₂)
          ((4 : NNReal) * v₁₉))
        (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _)
        (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _) A hA
    have hle := (abs_le.mp hJle).2
    exact ⟨hJle, by norm_num, by linarith⟩
  · have hsharp := (gaussian_seq_midpoint_sharp (by norm_num : 0 < 100)
      (by norm_num : (19 / 20 : ℝ) < 1) p m f hf hplt hv19_ne).2
    push_cast at hsharp
    have hexp_val :
        -((100 : ℝ) * ((1 - (19 / 20 : ℝ)) * |p u₁ - p u₂|) ^ 2) / (8 * (v₁₉ : ℝ)) =
          -(5625 / 578) := by
      rw [hgap, hv19_coe]
      norm_num
    have hexp_le : Real.exp (-(5625 / 578 : ℝ)) ≤ 1 / 10 := by
      have hadd := Real.add_one_le_exp (5625 / 578 : ℝ)
      have h10 : (10 : ℝ) ≤ Real.exp (5625 / 578) := by linarith
      rw [Real.exp_neg]
      exact (inv_le_comm₀ (Real.exp_pos _) (by norm_num)).mpr (by norm_num; exact h10)
    rw [hexp_val] at hsharp
    have hj :
        (9 / 10 : ℝ) ≤ measYoudenJ (gaussianSeqLaw 100 (19 / 20) p m f v₁₉ u₁)
          (gaussianSeqLaw 100 (19 / 20) p m f v₁₉ u₂)
          (Set.Ioi (((100 : ℝ) * aliasedProbe (19 / 20) p m f u₁ +
            (100 : ℝ) * aliasedProbe (19 / 20) p m f u₂) / 2)) := by
      linarith
    have hsum :
        measYoudenJ (gaussianSeqLaw 100 (19 / 20) p m f v₁₉ u₁)
            (gaussianSeqLaw 100 (19 / 20) p m f v₁₉ u₂)
            (Set.Ioi (((100 : ℝ) * aliasedProbe (19 / 20) p m f u₁ +
              (100 : ℝ) * aliasedProbe (19 / 20) p m f u₂) / 2)) =
          1 - measErrorSum (gaussianSeqLaw 100 (19 / 20) p m f v₁₉ u₁)
            (gaussianSeqLaw 100 (19 / 20) p m f v₁₉ u₂)
            (Set.Ioi (((100 : ℝ) * aliasedProbe (19 / 20) p m f u₁ +
              (100 : ℝ) * aliasedProbe (19 / 20) p m f u₂) / 2)) := by
      rw [gaussianSeqLaw_eq_gaussianReal, gaussianSeqLaw_eq_gaussianReal]
      exact @measYoudenJ_eq_one_sub_errorSum
        (ProbabilityTheory.gaussianReal ((100 : ℝ) * aliasedProbe (19 / 20) p m f u₁)
          ((100 : NNReal) * v₁₉))
        (ProbabilityTheory.gaussianReal ((100 : ℝ) * aliasedProbe (19 / 20) p m f u₂)
          ((100 : NNReal) * v₁₉))
        (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _)
        (ProbabilityTheory.instIsProbabilityMeasureGaussianReal _ _)
        (Set.Ioi (((100 : ℝ) * aliasedProbe (19 / 20) p m f u₁ +
          (100 : ℝ) * aliasedProbe (19 / 20) p m f u₂) / 2))
        measurableSet_Ioi
    exact ⟨hj, by linarith⟩

end SequentialGaussian

end QuantitativeTransfer
