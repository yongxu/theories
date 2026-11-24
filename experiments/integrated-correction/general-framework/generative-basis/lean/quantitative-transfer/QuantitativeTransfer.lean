import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Topology.Order.IntermediateValue
import Mathlib.Tactic
import ObservationalFidelity

/-!
# Quantitative Transfer for Four Guarded-Runtime Failure Regimes (`QuantitativeTransfer`)

AI-written (Frontier 3, 24 November 2026). Formalized with Lean 4.30.0-rc2 and Mathlib over `ℝ`,
importing `ObservationalFidelity` (and through it `AlignmentReals`, `BecomingReals`,
`Becoming.OplaxHistory`). Every declaration depends only on Lean's three standard axioms
(`propext`, `Classical.choice`, `Quot.sound`), with `0` `sorryAx`, `0` `private` declarations,
`0` `lemma`/`class`/unnamed `instance` declarations, and `0` forbidden market words.

The neural stress lab (`experiments/neural-alignment-stress-lab/RESULTS.md` §4.2) records four
regimes where the guarded runtime still breaks. For each, this module proves a limit together with
the theorem that shows the limit sits exactly at its stated threshold (a sharpness witness or a
remedy):

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
  unfold ObservationalFidelity.tvDist
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
    unfold testMass ObservationalFidelity.tvDist
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
  unfold ObservationalFidelity.tvDist mixDist
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
  simp [testMass, mixDist, ObservationalFidelity.diracDist]
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

end QuantitativeTransfer
