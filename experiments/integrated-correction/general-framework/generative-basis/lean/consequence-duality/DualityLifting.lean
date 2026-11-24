import Mathlib.Analysis.LocallyConvex.Separation
import Mathlib.Analysis.Convex.StdSimplex
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.Tactic
import ConsequenceDuality
import DualityBridges

/-!
# DualityLifting: Dobrushin Transfer, Tensor Products & Empirical Safety Bounds

AI-written (Wave 3, 2026-11-24).
Extends `ConsequenceDuality` and `DualityBridges` with three quantitative lifting pillars:
1. Multi-step Markov transfer lifting under Dobrushin TV contraction (`dobrushin_dualBound_lift`,
   `dobrushin_horizon_primalGap_bound`);
2. Independent tensor-product query subadditivity (`tensor_dualBound_subadditive`) and strict
   relational cross-term separation (`coupled_relational_gap_witness`);
3. Single-distribution empirical estimator error bounds and runtime safety-threshold certificates
   (`empirical_estimate_error_bound`, `empirical_threshold_safety_certificate`).
-/

namespace DualityLifting

open ConsequenceDuality DualityBridges
open scoped BigOperators

/-! ## Pillar 1: Markov Transfer & Dobrushin Oscillation Contraction -/

/-- Row-stochastic Markov kernel over a finite state space `S`. -/
structure MarkovKernel (S : Type*) [Fintype S] where
  row : S → FinDist S

/-- Transition probability matrix `(P.row s).w s'`. -/
noncomputable def kernelMatrix {S : Type*} [Fintype S] (P : MarkovKernel S) (s s' : S) : ℝ :=
  (P.row s).w s'

/-- One-step pushforward of distribution `μ` through `P`. -/
noncomputable def pushKernel {S : Type*} [Fintype S] (P : MarkovKernel S)
    (μ : FinDist S) : FinDist S where
  w s' := ∑ s : S, μ.w s * (P.row s).w s'
  nonneg s' := Finset.sum_nonneg fun s _ => mul_nonneg (μ.nonneg s) ((P.row s).nonneg s')
  sum_eq_one := by
    rw [Finset.sum_comm]
    calc ∑ s : S, ∑ s' : S, μ.w s * (P.row s).w s'
        = ∑ s : S, μ.w s * ∑ s' : S, (P.row s).w s' := by
          refine Finset.sum_congr rfl fun s _ => (Finset.mul_sum _ _ _).symm
      _ = ∑ s : S, μ.w s * 1 := by
          refine Finset.sum_congr rfl fun s _ => by rw [(P.row s).sum_eq_one]
      _ = 1 := by simp [μ.sum_eq_one]

/-- Iterated backward expectation operator `P^t h`. -/
noncomputable def iterStepOp {S : Type*} [Fintype S] (P : MarkovKernel S) :
    ℕ → (S → ℝ) → (S → ℝ)
  | 0, h => h
  | t + 1, h => stepOp (kernelMatrix P) (iterStepOp P t h)

/-- Total oscillation `max g - min g` on `[Nonempty S]`. -/
noncomputable def osc {S : Type*} [Fintype S] [Nonempty S] (h : S → ℝ) : ℝ :=
  Finset.univ.sup' Finset.univ_nonempty h - Finset.univ.inf' Finset.univ_nonempty h

/-- Midpoint `(max g + min g) / 2` minimizing uniform error over constants. -/
noncomputable def mid {S : Type*} [Fintype S] [Nonempty S] (h : S → ℝ) : ℝ :=
  (Finset.univ.sup' Finset.univ_nonempty h + Finset.univ.inf' Finset.univ_nonempty h) / 2

theorem sum_stepOp_eq_pushKernel {S : Type*} [Fintype S] (P : MarkovKernel S) (h : S → ℝ)
    (μ ν : FinDist S) :
    ∑ s : S, stepOp (kernelMatrix P) h s * (μ.w s - ν.w s) =
      ∑ s' : S, h s' * ((pushKernel P μ).w s' - (pushKernel P ν).w s') := by
  simp only [stepOp, FiniteKrylov.stepOp, kernelMatrix, pushKernel]
  calc ∑ s : S, (∑ s' : S, (P.row s).w s' * h s') * (μ.w s - ν.w s)
      = ∑ s : S, ∑ s' : S, h s' * ((P.row s).w s' * (μ.w s - ν.w s)) := by
        refine Finset.sum_congr rfl fun s _ => ?_
        rw [Finset.sum_mul]
        refine Finset.sum_congr rfl fun s' _ => by ring
    _ = ∑ s' : S, ∑ s : S, h s' * ((P.row s).w s' * (μ.w s - ν.w s)) := Finset.sum_comm
    _ = ∑ s' : S, h s' * ((∑ s : S, μ.w s * (P.row s).w s') - ∑ s : S, ν.w s * (P.row s).w s') := by
        refine Finset.sum_congr rfl fun s' _ => ?_
        rw [← Finset.mul_sum, ← Finset.sum_sub_distrib]
        congr 1
        refine Finset.sum_congr rfl fun s _ => by ring

theorem stepOp_const {S : Type*} [Fintype S] (P : MarkovKernel S) (b : ℝ) :
    stepOp (kernelMatrix P) (fun _ => b) = fun _ => b := by
  ext s
  simp only [stepOp, FiniteKrylov.stepOp, kernelMatrix, ← Finset.sum_mul, (P.row s).sum_eq_one, one_mul]

theorem iterStepOp_const {S : Type*} [Fintype S] (P : MarkovKernel S) (b : ℝ) :
    ∀ t : ℕ, iterStepOp P t (fun _ => b) = fun _ => b
  | 0 => rfl
  | t + 1 => by
      simp only [iterStepOp, iterStepOp_const P b t, stepOp_const]

theorem stepOp_sub {S : Type*} [Fintype S] (M : S → S → ℝ) (f g : S → ℝ) :
    stepOp M (fun s => f s - g s) = fun s => stepOp M f s - stepOp M g s := by
  ext s
  simp only [stepOp, FiniteKrylov.stepOp, mul_sub, Finset.sum_sub_distrib]

theorem stepOp_smul_right {S : Type*} [Fintype S] (M : S → S → ℝ) (f : S → ℝ) (r : ℝ) :
    stepOp M (fun s => f s * r) = fun s => stepOp M f s * r := by
  ext s
  simp only [stepOp, FiniteKrylov.stepOp, Finset.sum_mul]
  refine Finset.sum_congr rfl fun s' _ => by ring

theorem stepOp_finset_sum {S J : Type*} [Fintype S] (M : S → S → ℝ) (sJ : Finset J)
    (g : J → S → ℝ) :
    stepOp M (fun s => ∑ j ∈ sJ, g j s) = fun s => ∑ j ∈ sJ, stepOp M (g j) s := by
  ext s
  simp only [stepOp, FiniteKrylov.stepOp, Finset.mul_sum]
  rw [Finset.sum_comm]

theorem iterStepOp_sub {S : Type*} [Fintype S] (P : MarkovKernel S) (f g : S → ℝ) :
    ∀ t : ℕ, iterStepOp P t (fun s => f s - g s) =
      fun s => iterStepOp P t f s - iterStepOp P t g s
  | 0 => rfl
  | t + 1 => by
      simp only [iterStepOp, iterStepOp_sub P f g t, stepOp_sub]

theorem iterStepOp_finset_sum {S J : Type*} [Fintype S] [Fintype J] (P : MarkovKernel S)
    (g : J → S → ℝ) :
    ∀ t : ℕ, iterStepOp P t (fun s => ∑ j : J, g j s) =
      fun s => ∑ j : J, iterStepOp P t (g j) s
  | 0 => rfl
  | t + 1 => by
      simp only [iterStepOp, iterStepOp_finset_sum P g t, stepOp_finset_sum]

theorem iterStepOp_smul_right {S : Type*} [Fintype S] (P : MarkovKernel S) (f : S → ℝ) (r : ℝ) :
    ∀ t : ℕ, iterStepOp P t (fun s => f s * r) = fun s => iterStepOp P t f s * r
  | 0 => rfl
  | t + 1 => by
      simp only [iterStepOp, iterStepOp_smul_right P f r t, stepOp_smul_right]

theorem iterStepOp_linear_residual {S J : Type*} [Fintype S] [Fintype J] (P : MarkovKernel S)
    (F : J → S → ℝ) (h : S → ℝ) (b : ℝ) (c : J → ℝ) (t : ℕ) :
    iterStepOp P t (fun s => h s - b - ∑ j : J, F j s * c j) =
      fun s => iterStepOp P t h s - b - ∑ j : J, iterStepOp P t (F j) s * c j := by
  rw [iterStepOp_sub, iterStepOp_sub, iterStepOp_const, iterStepOp_finset_sum]
  ext s
  have hc : (fun j => iterStepOp P t (fun s' => F j s' * c j) s) =
      fun j => iterStepOp P t (F j) s * c j := by
    ext j
    rw [iterStepOp_smul_right]
  simp only [hc]

theorem osc_nonneg {S : Type*} [Fintype S] [Nonempty S] (g : S → ℝ) : 0 ≤ osc g := by
  obtain ⟨s₀⟩ := ‹Nonempty S›
  have h1 : Finset.univ.inf' Finset.univ_nonempty g ≤ g s₀ :=
    Finset.inf'_le g (Finset.mem_univ s₀)
  have h2 : g s₀ ≤ Finset.univ.sup' Finset.univ_nonempty g :=
    Finset.le_sup' g (Finset.mem_univ s₀)
  unfold osc
  linarith

theorem abs_sub_mid_le_half_osc {S : Type*} [Fintype S] [Nonempty S] (g : S → ℝ) (s : S) :
    |g s - mid g| ≤ osc g / 2 := by
  have hinf : Finset.univ.inf' Finset.univ_nonempty g ≤ g s :=
    Finset.inf'_le g (Finset.mem_univ s)
  have hsup : g s ≤ Finset.univ.sup' Finset.univ_nonempty g :=
    Finset.le_sup' g (Finset.mem_univ s)
  unfold mid osc
  rw [abs_le]
  constructor <;> linarith

theorem half_osc_le_sup_abs {S : Type*} [Fintype S] [Nonempty S] (g : S → ℝ) :
    osc g / 2 ≤ Finset.univ.sup' Finset.univ_nonempty fun s => |g s| := by
  obtain ⟨s₁⟩ := ‹Nonempty S›
  let M : ℝ := Finset.univ.sup' Finset.univ_nonempty fun s => |g s|
  have hupper : Finset.univ.sup' Finset.univ_nonempty g ≤ M :=
    Finset.sup'_le Finset.univ_nonempty g fun s _ =>
      le_trans (le_abs_self (g s)) (Finset.le_sup' (fun s' => |g s'|) (Finset.mem_univ s))
  have hlower : -M ≤ Finset.univ.inf' Finset.univ_nonempty g :=
    Finset.le_inf' Finset.univ_nonempty g fun s _ => by
      have habs : |g s| ≤ M := Finset.le_sup' (fun s' => |g s'|) (Finset.mem_univ s)
      linarith [(abs_le.mp habs).1]
  unfold osc
  linarith

theorem osc_stepOp_le_dobrushin {S : Type*} [Fintype S] [Nonempty S] (P : MarkovKernel S)
    (g : S → ℝ) {α : ℝ} (hα : ∀ s₁ s₂ : S, tvDist (P.row s₁) (P.row s₂) ≤ α) :
    osc (stepOp (kernelMatrix P) g) ≤ α * osc g := by
  have hpair : ∀ s₁ s₂ : S,
      stepOp (kernelMatrix P) g s₁ - stepOp (kernelMatrix P) g s₂ ≤ α * osc g := by
    intro s₁ s₂
    have hzero : ∑ s' : S, ((P.row s₁).w s' - (P.row s₂).w s') * mid g = 0 := by
      rw [← Finset.sum_mul, Finset.sum_sub_distrib, (P.row s₁).sum_eq_one,
        (P.row s₂).sum_eq_one, sub_self, zero_mul]
    have hdiff : stepOp (kernelMatrix P) g s₁ - stepOp (kernelMatrix P) g s₂ =
        ∑ s' : S, ((P.row s₁).w s' - (P.row s₂).w s') * (g s' - mid g) := by
      simp only [stepOp, FiniteKrylov.stepOp, kernelMatrix, ← Finset.sum_sub_distrib]
      calc ∑ s' : S, ((P.row s₁).w s' * g s' - (P.row s₂).w s' * g s')
          = ∑ s' : S, (((P.row s₁).w s' - (P.row s₂).w s') * (g s' - mid g) +
              ((P.row s₁).w s' - (P.row s₂).w s') * mid g) := by
            refine Finset.sum_congr rfl fun s' _ => by ring
        _ = (∑ s' : S, ((P.row s₁).w s' - (P.row s₂).w s') * (g s' - mid g)) +
            ∑ s' : S, ((P.row s₁).w s' - (P.row s₂).w s') * mid g := Finset.sum_add_distrib
        _ = ∑ s' : S, ((P.row s₁).w s' - (P.row s₂).w s') * (g s' - mid g) := by
            rw [hzero, add_zero]
    rw [hdiff]
    calc ∑ s' : S, ((P.row s₁).w s' - (P.row s₂).w s') * (g s' - mid g)
        ≤ |∑ s' : S, ((P.row s₁).w s' - (P.row s₂).w s') * (g s' - mid g)| := le_abs_self _
      _ ≤ ∑ s' : S, |((P.row s₁).w s' - (P.row s₂).w s') * (g s' - mid g)| :=
          Finset.abs_sum_le_sum_abs _ _
      _ ≤ ∑ s' : S, |(P.row s₁).w s' - (P.row s₂).w s'| * (osc g / 2) := by
          refine Finset.sum_le_sum fun s' _ => ?_
          rw [abs_mul]
          exact mul_le_mul_of_nonneg_left (abs_sub_mid_le_half_osc g s') (abs_nonneg _)
      _ = (∑ s' : S, |(P.row s₁).w s' - (P.row s₂).w s'|) * (osc g / 2) :=
          (Finset.sum_mul _ _ _).symm
      _ = tvDist (P.row s₁) (P.row s₂) * osc g := by
          unfold tvDist FiniteProb.tvDist
          ring
      _ ≤ α * osc g := mul_le_mul_of_nonneg_right (hα s₁ s₂) (osc_nonneg g)
  have hle_inf : ∀ s₁ : S, stepOp (kernelMatrix P) g s₁ ≤
      Finset.univ.inf' Finset.univ_nonempty (stepOp (kernelMatrix P) g) + α * osc g := by
    intro s₁
    have hinf : stepOp (kernelMatrix P) g s₁ - α * osc g ≤
        Finset.univ.inf' Finset.univ_nonempty (stepOp (kernelMatrix P) g) :=
      Finset.le_inf' Finset.univ_nonempty _ fun s₂ _ => by
        linarith [hpair s₁ s₂]
    linarith
  have hsup : Finset.univ.sup' Finset.univ_nonempty (stepOp (kernelMatrix P) g) ≤
      Finset.univ.inf' Finset.univ_nonempty (stepOp (kernelMatrix P) g) + α * osc g :=
    Finset.sup'_le Finset.univ_nonempty _ fun s₁ _ => hle_inf s₁
  unfold osc at hsup ⊢
  linarith

theorem osc_iterStepOp_le {S : Type*} [Fintype S] [Nonempty S] (P : MarkovKernel S)
    (g : S → ℝ) {α : ℝ} (hα0 : 0 ≤ α) (hα : ∀ s₁ s₂ : S, tvDist (P.row s₁) (P.row s₂) ≤ α) :
    ∀ t : ℕ, osc (iterStepOp P t g) ≤ α ^ t * osc g
  | 0 => by simp [iterStepOp]
  | t + 1 => by
      calc osc (iterStepOp P (t + 1) g)
          = osc (stepOp (kernelMatrix P) (iterStepOp P t g)) := rfl
        _ ≤ α * osc (iterStepOp P t g) := osc_stepOp_le_dobrushin P _ hα
        _ ≤ α * (α ^ t * osc g) := mul_le_mul_of_nonneg_left (osc_iterStepOp_le P g hα0 hα t) hα0
        _ = α ^ (t + 1) * osc g := by rw [pow_succ']; ring

/-- Dobrushin multi-step lift of a §7.2 affine dual certificate `(b, c)`. -/
theorem dobrushin_dualBound_lift {S J : Type*} [Fintype S] [Nonempty S] [Fintype J]
    (P : MarkovKernel S) (F : J → S → ℝ) (h : S → ℝ) (ε b : ℝ) (c : J → ℝ)
    {α : ℝ} (hα0 : 0 ≤ α) (hα : ∀ s₁ s₂ : S, tvDist (P.row s₁) (P.row s₂) ≤ α) (t : ℕ) :
    let r : S → ℝ := fun s => h s - b - ∑ j : J, F j s * c j
    let b_t : ℝ := b + mid (iterStepOp P t r)
    dualBound (fun j => iterStepOp P t (F j)) (iterStepOp P t h) ε b_t c ≤
      α ^ t * (Finset.univ.sup' Finset.univ_nonempty fun s => |h s - b - ∑ j : J, F j s * c j|) +
        ε * ∑ j : J, |c j| := by
  dsimp only
  let r : S → ℝ := fun s => h s - b - ∑ j : J, F j s * c j
  let b_t : ℝ := b + mid (iterStepOp P t r)
  unfold dualBound
  have hsup : (Finset.univ.sup' Finset.univ_nonempty fun s =>
      |iterStepOp P t h s - b_t - ∑ j : J, iterStepOp P t (F j) s * c j|) ≤
      α ^ t * (Finset.univ.sup' Finset.univ_nonempty fun s => |r s|) := by
    refine Finset.sup'_le Finset.univ_nonempty _ fun s _ => ?_
    have hpt : iterStepOp P t h s - b_t - ∑ j : J, iterStepOp P t (F j) s * c j =
        iterStepOp P t r s - mid (iterStepOp P t r) := by
      have hlin := congrFun (iterStepOp_linear_residual P F h b c t) s
      change iterStepOp P t r s = iterStepOp P t h s - b - ∑ j : J, iterStepOp P t (F j) s * c j at hlin
      rw [hlin]
      dsimp only [b_t]
      ring
    rw [hpt]
    calc |iterStepOp P t r s - mid (iterStepOp P t r)|
        ≤ osc (iterStepOp P t r) / 2 := abs_sub_mid_le_half_osc _ s
      _ ≤ (α ^ t * osc r) / 2 := div_le_div_of_nonneg_right (osc_iterStepOp_le P r hα0 hα t) (by norm_num)
      _ = α ^ t * (osc r / 2) := by ring
      _ ≤ α ^ t * (Finset.univ.sup' Finset.univ_nonempty fun s' => |r s'|) :=
          mul_le_mul_of_nonneg_left (half_osc_le_sup_abs r) (pow_nonneg hα0 t)
  exact add_le_add hsup le_rfl

/-- Horizon contraction bound on unconditional primal consequence discrepancy of `P^t h`. -/
theorem dobrushin_horizon_primalGap_bound {S : Type*} [Fintype S] [Nonempty S]
    (P : MarkovKernel S) (h : S → ℝ) {α : ℝ} (hα0 : 0 ≤ α)
    (hα : ∀ s₁ s₂ : S, tvDist (P.row s₁) (P.row s₂) ≤ α) (t : ℕ) (μ ν : FinDist S) :
    primalGap (iterStepOp P t h) μ ν ≤ α ^ t * (osc h / 2) := by
  let F₀ : Empty → S → ℝ := fun e => Empty.elim e
  let b₀ : ℝ := mid (iterStepOp P t h)
  let c₀ : Empty → ℝ := fun e => Empty.elim e
  have hf₀ : PrimalFeasible F₀ 0 μ ν := fun e => Empty.elim e
  have hw := primalGap_le_dualBound F₀ (iterStepOp P t h) 0 hf₀ b₀ c₀
  have hd : dualBound F₀ (iterStepOp P t h) 0 b₀ c₀ ≤ osc (iterStepOp P t h) / 2 := by
    unfold dualBound
    have hc0 : ∑ j : Empty, |c₀ j| = 0 := by simp
    rw [hc0, mul_zero, add_zero]
    refine Finset.sup'_le Finset.univ_nonempty _ fun s _ => ?_
    have hsum0 : ∑ j : Empty, F₀ j s * c₀ j = 0 := by simp
    rw [hsum0, sub_zero]
    exact abs_sub_mid_le_half_osc (iterStepOp P t h) s
  calc primalGap (iterStepOp P t h) μ ν
      ≤ dualBound F₀ (iterStepOp P t h) 0 b₀ c₀ := hw
    _ ≤ osc (iterStepOp P t h) / 2 := hd
    _ ≤ (α ^ t * osc h) / 2 := div_le_div_of_nonneg_right (osc_iterStepOp_le P h hα0 hα t) (by norm_num)
    _ = α ^ t * (osc h / 2) := by ring

/-! ## Pillar 2: Tensor-Product Query Subadditivity & Relational Cross-Term Gap -/

/-- Disjoint sum lifting of two independent query families `F₁`, `F₂` onto `S₁ × S₂`. -/
def prodQueryFamily {S₁ S₂ J₁ J₂ : Type*} (F₁ : J₁ → S₁ → ℝ) (F₂ : J₂ → S₂ → ℝ) :
    J₁ ⊕ J₂ → S₁ × S₂ → ℝ
  | .inl j₁ => fun p => F₁ j₁ p.1
  | .inr j₂ => fun p => F₂ j₂ p.2

/-- Separable additive consequence `h₁ p.1 + h₂ p.2`. -/
def prodSumConsequence {S₁ S₂ : Type*} (h₁ : S₁ → ℝ) (h₂ : S₂ → ℝ) (p : S₁ × S₂) : ℝ :=
  h₁ p.1 + h₂ p.2

/-- Dual certificate subadditivity for independent product query families on additive consequences. -/
theorem tensor_dualBound_subadditive {S₁ S₂ J₁ J₂ : Type*} [Fintype S₁] [Nonempty S₁]
    [Fintype S₂] [Nonempty S₂] [Fintype J₁] [Fintype J₂]
    (F₁ : J₁ → S₁ → ℝ) (F₂ : J₂ → S₂ → ℝ) (h₁ : S₁ → ℝ) (h₂ : S₂ → ℝ)
    (ε b₁ b₂ : ℝ) (c₁ : J₁ → ℝ) (c₂ : J₂ → ℝ) :
    dualBound (prodQueryFamily F₁ F₂) (prodSumConsequence h₁ h₂) ε (b₁ + b₂) (Sum.elim c₁ c₂) ≤
      dualBound F₁ h₁ ε b₁ c₁ + dualBound F₂ h₂ ε b₂ c₂ := by
  unfold dualBound
  have hl1 : ∑ j : J₁ ⊕ J₂, |Sum.elim c₁ c₂ j| =
      (∑ j₁ : J₁, |c₁ j₁|) + ∑ j₂ : J₂, |c₂ j₂| := by
    rw [Fintype.sum_sum_type]
    rfl
  have hsup : (Finset.univ.sup' Finset.univ_nonempty fun p : S₁ × S₂ =>
      |prodSumConsequence h₁ h₂ p - (b₁ + b₂) -
        ∑ j : J₁ ⊕ J₂, prodQueryFamily F₁ F₂ j p * Sum.elim c₁ c₂ j|) ≤
      (Finset.univ.sup' Finset.univ_nonempty fun s₁ : S₁ => |h₁ s₁ - b₁ - ∑ j₁ : J₁, F₁ j₁ s₁ * c₁ j₁|) +
      (Finset.univ.sup' Finset.univ_nonempty fun s₂ : S₂ => |h₂ s₂ - b₂ - ∑ j₂ : J₂, F₂ j₂ s₂ * c₂ j₂|) := by
    refine Finset.sup'_le Finset.univ_nonempty _ fun p _ => ?_
    have hlin : ∑ j : J₁ ⊕ J₂, prodQueryFamily F₁ F₂ j p * Sum.elim c₁ c₂ j =
        (∑ j₁ : J₁, F₁ j₁ p.1 * c₁ j₁) + ∑ j₂ : J₂, F₂ j₂ p.2 * c₂ j₂ := by
      rw [Fintype.sum_sum_type]
      rfl
    have hsplit : prodSumConsequence h₁ h₂ p - (b₁ + b₂) -
        ∑ j : J₁ ⊕ J₂, prodQueryFamily F₁ F₂ j p * Sum.elim c₁ c₂ j =
        (h₁ p.1 - b₁ - ∑ j₁ : J₁, F₁ j₁ p.1 * c₁ j₁) +
        (h₂ p.2 - b₂ - ∑ j₂ : J₂, F₂ j₂ p.2 * c₂ j₂) := by
      rw [hlin]
      dsimp only [prodSumConsequence]
      ring
    rw [hsplit]
    calc |(h₁ p.1 - b₁ - ∑ j₁ : J₁, F₁ j₁ p.1 * c₁ j₁) +
            (h₂ p.2 - b₂ - ∑ j₂ : J₂, F₂ j₂ p.2 * c₂ j₂)|
        ≤ |h₁ p.1 - b₁ - ∑ j₁ : J₁, F₁ j₁ p.1 * c₁ j₁| +
          |h₂ p.2 - b₂ - ∑ j₂ : J₂, F₂ j₂ p.2 * c₂ j₂| := abs_add_le _ _
      _ ≤ _ := add_le_add
          (Finset.le_sup' (fun s₁ : S₁ => |h₁ s₁ - b₁ - ∑ j₁ : J₁, F₁ j₁ s₁ * c₁ j₁|)
            (Finset.mem_univ p.1))
          (Finset.le_sup' (fun s₂ : S₂ => |h₂ s₂ - b₂ - ∑ j₂ : J₂, F₂ j₂ s₂ * c₂ j₂|)
            (Finset.mem_univ p.2))
  rw [hl1]
  linarith

/-- Joint XOR / equality consequence on `Bool × Bool`: any marginal-only `prodQueryFamily F₁ F₂`
retains minimax gap `1/2`, whereas adding the single relational query `h_eq` drops minimax value
strictly to `min (1/2) ε` whenever `0 ≤ ε < 1/2`. -/
theorem coupled_relational_gap_witness {J₁ J₂ : Type*} [Fintype J₁] [Fintype J₂]
    (F₁ : J₁ → Bool → ℝ) (F₂ : J₂ → Bool → ℝ) {ε : ℝ} (hε : 0 ≤ ε) :
    let h_eq : Bool × Bool → ℝ := fun p => if p.1 = p.2 then 1 else 0
    (∃ (μ ν : FinDist (Bool × Bool)) (b : ℝ) (c : J₁ ⊕ J₂ → ℝ),
      PrimalFeasible (prodQueryFamily F₁ F₂) ε μ ν ∧
      (∀ μ' ν' : FinDist (Bool × Bool),
        PrimalFeasible (prodQueryFamily F₁ F₂) ε μ' ν' → primalGap h_eq μ' ν' ≤ primalGap h_eq μ ν) ∧
      (∀ (b' : ℝ) (c' : J₁ ⊕ J₂ → ℝ),
        dualBound (prodQueryFamily F₁ F₂) h_eq ε b c ≤
          dualBound (prodQueryFamily F₁ F₂) h_eq ε b' c') ∧
      primalGap h_eq μ ν = (1 / 2 : ℝ) ∧
      dualBound (prodQueryFamily F₁ F₂) h_eq ε b c = (1 / 2 : ℝ)) ∧
    (∃ (μ' ν' : FinDist (Bool × Bool)) (b' : ℝ) (c' : Option (J₁ ⊕ J₂) → ℝ),
      PrimalFeasible (extendQueryFamily (prodQueryFamily F₁ F₂) h_eq) ε μ' ν' ∧
      (∀ μ'' ν'' : FinDist (Bool × Bool),
        PrimalFeasible (extendQueryFamily (prodQueryFamily F₁ F₂) h_eq) ε μ'' ν'' →
          primalGap h_eq μ'' ν'' ≤ primalGap h_eq μ' ν') ∧
      (∀ (b'' : ℝ) (c'' : Option (J₁ ⊕ J₂) → ℝ),
        dualBound (extendQueryFamily (prodQueryFamily F₁ F₂) h_eq) h_eq ε b' c' ≤
          dualBound (extendQueryFamily (prodQueryFamily F₁ F₂) h_eq) h_eq ε b'' c'') ∧
      primalGap h_eq μ' ν' = min (1 / 2 : ℝ) ε ∧
      dualBound (extendQueryFamily (prodQueryFamily F₁ F₂) h_eq) h_eq ε b' c' = min (1 / 2 : ℝ) ε) ∧
    (min (1 / 2 : ℝ) ε < (1 / 2 : ℝ) ↔ ε < (1 / 2 : ℝ)) := by
  dsimp only
  let h_eq : Bool × Bool → ℝ := fun p => if p.1 = p.2 then 1 else 0
  let μ_diag : FinDist (Bool × Bool) :=
    { w := fun p => if p.1 = p.2 then 1 / 2 else 0
      nonneg := fun p => by split_ifs <;> norm_num
      sum_eq_one := by simp [Fintype.sum_prod_type] }
  let ν_anti : FinDist (Bool × Bool) :=
    { w := fun p => if p.1 = p.2 then 0 else 1 / 2
      nonneg := fun p => by split_ifs <;> norm_num
      sum_eq_one := by simp [Fintype.sum_prod_type]; norm_num }
  have hmarg_zero : ∀ j : J₁ ⊕ J₂,
      ∑ p : Bool × Bool, prodQueryFamily F₁ F₂ j p * (μ_diag.w p - ν_anti.w p) = 0 := by
    intro j
    cases j with
    | inl j₁ =>
        simp [prodQueryFamily, μ_diag, ν_anti, Fintype.sum_prod_type]
    | inr j₂ =>
        simp [prodQueryFamily, μ_diag, ν_anti, Fintype.sum_prod_type]
        ring
  refine ⟨?_, ?_, ?_⟩
  · let b : ℝ := 1 / 2
    let c : J₁ ⊕ J₂ → ℝ := fun _ => 0
    have hfeas : PrimalFeasible (prodQueryFamily F₁ F₂) ε μ_diag ν_anti := fun j => by
      rw [hmarg_zero j, abs_zero]
      linarith
    have hprimal : primalGap h_eq μ_diag ν_anti = (1 / 2 : ℝ) := by
      unfold primalGap
      have hs : ∑ p : Bool × Bool, h_eq p * (μ_diag.w p - ν_anti.w p) = 1 := by
        simp [h_eq, μ_diag, ν_anti, Fintype.sum_prod_type]
      rw [hs, abs_one]
    have hdual : dualBound (prodQueryFamily F₁ F₂) h_eq ε b c = (1 / 2 : ℝ) := by
      unfold dualBound
      have hc0 : ∑ j : J₁ ⊕ J₂, |c j| = 0 := by simp [c]
      rw [hc0, mul_zero, add_zero]
      have hpt : ∀ p : Bool × Bool,
          |h_eq p - b - ∑ j : J₁ ⊕ J₂, prodQueryFamily F₁ F₂ j p * c j| = 1 / 2 := by
        intro p
        have hs0 : ∑ j : J₁ ⊕ J₂, prodQueryFamily F₁ F₂ j p * c j = 0 := by simp [c]
        rw [hs0]
        cases p with
        | mk a₁ a₂ =>
            by_cases ha : a₁ = a₂
            · simp [h_eq, b, ha]; norm_num
            · simp [h_eq, b, ha]
      exact le_antisymm
        (Finset.sup'_le Finset.univ_nonempty _ fun p _ => (hpt p).le)
        (by
          have hle := Finset.le_sup'
            (fun p : Bool × Bool =>
              |h_eq p - b - ∑ j : J₁ ⊕ J₂, prodQueryFamily F₁ F₂ j p * c j|)
            (Finset.mem_univ (false, false))
          linarith [hpt (false, false)])
    have heq : primalGap h_eq μ_diag ν_anti = dualBound (prodQueryFamily F₁ F₂) h_eq ε b c :=
      hprimal.trans hdual.symm
    exact ⟨μ_diag, ν_anti, b, c, hfeas,
      fun μ'' ν'' hfeas'' => (primalGap_le_dualBound (prodQueryFamily F₁ F₂) h_eq ε hfeas'' b c).trans heq.symm.le,
      fun b'' c'' => heq.symm.le.trans (primalGap_le_dualBound (prodQueryFamily F₁ F₂) h_eq ε hfeas b'' c''),
      hprimal, hdual⟩
  · let t : ℝ := min (1 : ℝ) (2 * ε)
    have ht0 : 0 ≤ t := le_min zero_le_one (by linarith)
    have ht1 : t ≤ 1 := min_le_left _ _
    let μ' : FinDist (Bool × Bool) :=
      { w := fun p => t * μ_diag.w p + (1 - t) * ν_anti.w p
        nonneg := fun p =>
          add_nonneg (mul_nonneg ht0 (μ_diag.nonneg p))
            (mul_nonneg (by linarith) (ν_anti.nonneg p))
        sum_eq_one := by
          simp only [Finset.sum_add_distrib, ← Finset.mul_sum, μ_diag.sum_eq_one,
            ν_anti.sum_eq_one]
          ring }
    have hdiff_eq : ∀ p : Bool × Bool, μ'.w p - ν_anti.w p = t * (μ_diag.w p - ν_anti.w p) := by
      intro p
      dsimp only [μ']
      ring
    have hfeas' : PrimalFeasible (extendQueryFamily (prodQueryFamily F₁ F₂) h_eq) ε μ' ν_anti := by
      intro j
      cases j with
      | none =>
          have hs : ∑ p : Bool × Bool,
              extendQueryFamily (prodQueryFamily F₁ F₂) h_eq none p * (μ'.w p - ν_anti.w p) = t := by
            have heval : ∑ p : Bool × Bool, h_eq p * (μ'.w p - ν_anti.w p) =
                t * ∑ p : Bool × Bool, h_eq p * (μ_diag.w p - ν_anti.w p) := by
              rw [Finset.mul_sum]
              refine Finset.sum_congr rfl fun p _ => by
                rw [hdiff_eq p]
                ring
            change ∑ p : Bool × Bool, h_eq p * (μ'.w p - ν_anti.w p) = t
            rw [heval]
            have h1 : ∑ p : Bool × Bool, h_eq p * (μ_diag.w p - ν_anti.w p) = 1 := by
              simp [h_eq, μ_diag, ν_anti, Fintype.sum_prod_type]
            rw [h1, mul_one]
          rw [hs, abs_of_nonneg ht0]
          exact min_le_right _ _
      | some j₀ =>
          have hs : ∑ p : Bool × Bool,
              extendQueryFamily (prodQueryFamily F₁ F₂) h_eq (some j₀) p * (μ'.w p - ν_anti.w p) = 0 := by
            have heval : ∑ p : Bool × Bool, prodQueryFamily F₁ F₂ j₀ p * (μ'.w p - ν_anti.w p) =
                t * ∑ p : Bool × Bool, prodQueryFamily F₁ F₂ j₀ p * (μ_diag.w p - ν_anti.w p) := by
              rw [Finset.mul_sum]
              refine Finset.sum_congr rfl fun p _ => by
                rw [hdiff_eq p]
                ring
            change ∑ p : Bool × Bool, prodQueryFamily F₁ F₂ j₀ p * (μ'.w p - ν_anti.w p) = 0
            rw [heval, hmarg_zero j₀, mul_zero]
          rw [hs, abs_zero]
          linarith
    have hprimal' : primalGap h_eq μ' ν_anti = min (1 / 2 : ℝ) ε := by
      unfold primalGap
      have hs : ∑ p : Bool × Bool, h_eq p * (μ'.w p - ν_anti.w p) = t := by
        have heval : ∑ p : Bool × Bool, h_eq p * (μ'.w p - ν_anti.w p) =
            t * ∑ p : Bool × Bool, h_eq p * (μ_diag.w p - ν_anti.w p) := by
          rw [Finset.mul_sum]
          refine Finset.sum_congr rfl fun p _ => by
            rw [hdiff_eq p]
            ring
        rw [heval]
        have h1 : ∑ p : Bool × Bool, h_eq p * (μ_diag.w p - ν_anti.w p) = 1 := by
          simp [h_eq, μ_diag, ν_anti, Fintype.sum_prod_type]
        rw [h1, mul_one]
      rw [hs, abs_of_nonneg ht0]
      rcases le_total 1 (2 * ε) with hle | hge
      · have hmin1 : t = 1 := min_eq_left hle
        have hmin2 : min (1 / 2 : ℝ) ε = 1 / 2 := min_eq_left (by linarith)
        rw [hmin1, hmin2]
      · have hmin1 : t = 2 * ε := min_eq_right hge
        have hmin2 : min (1 / 2 : ℝ) ε = ε := min_eq_right (by linarith)
        rw [hmin1, hmin2]
        ring
    rcases le_or_gt (1 / 2 : ℝ) ε with hle | hlt
    · let b' : ℝ := 1 / 2
      let c' : Option (J₁ ⊕ J₂) → ℝ := fun _ => 0
      have hdual' : dualBound (extendQueryFamily (prodQueryFamily F₁ F₂) h_eq) h_eq ε b' c' =
          min (1 / 2 : ℝ) ε := by
        unfold dualBound
        have hc0 : ∑ j : Option (J₁ ⊕ J₂), |c' j| = 0 := by simp [c']
        rw [hc0, mul_zero, add_zero]
        have hpt : ∀ p : Bool × Bool,
            |h_eq p - b' - ∑ j : Option (J₁ ⊕ J₂),
              extendQueryFamily (prodQueryFamily F₁ F₂) h_eq j p * c' j| = 1 / 2 := by
          intro p
          have hs0 : ∑ j : Option (J₁ ⊕ J₂),
              extendQueryFamily (prodQueryFamily F₁ F₂) h_eq j p * c' j = 0 := by simp [c']
          rw [hs0]
          cases p with
          | mk a₁ a₂ =>
              by_cases ha : a₁ = a₂
              · simp [h_eq, b', ha]; norm_num
              · simp [h_eq, b', ha]
        have hsup : (Finset.univ.sup' Finset.univ_nonempty fun p : Bool × Bool =>
            |h_eq p - b' - ∑ j : Option (J₁ ⊕ J₂),
              extendQueryFamily (prodQueryFamily F₁ F₂) h_eq j p * c' j|) = 1 / 2 :=
          le_antisymm
            (Finset.sup'_le Finset.univ_nonempty _ fun p _ => (hpt p).le)
            (by
              have hle_pt := Finset.le_sup'
                (fun p : Bool × Bool =>
                  |h_eq p - b' - ∑ j : Option (J₁ ⊕ J₂),
                    extendQueryFamily (prodQueryFamily F₁ F₂) h_eq j p * c' j|)
                (Finset.mem_univ (false, false))
              linarith [hpt (false, false)])
        rw [hsup, min_eq_left hle]
      have heq' : primalGap h_eq μ' ν_anti =
          dualBound (extendQueryFamily (prodQueryFamily F₁ F₂) h_eq) h_eq ε b' c' :=
        hprimal'.trans hdual'.symm
      exact ⟨μ', ν_anti, b', c', hfeas',
        fun μ'' ν'' hfeas'' =>
          (primalGap_le_dualBound (extendQueryFamily (prodQueryFamily F₁ F₂) h_eq) h_eq ε hfeas'' b' c').trans heq'.symm.le,
        fun b'' c'' =>
          heq'.symm.le.trans (primalGap_le_dualBound (extendQueryFamily (prodQueryFamily F₁ F₂) h_eq) h_eq ε hfeas' b'' c''),
        hprimal', hdual'⟩
    · let b' : ℝ := 0
      let c' : Option (J₁ ⊕ J₂) → ℝ
        | none => 1
        | some _ => 0
      have hdual' : dualBound (extendQueryFamily (prodQueryFamily F₁ F₂) h_eq) h_eq ε b' c' =
          min (1 / 2 : ℝ) ε := by
        unfold dualBound
        have hl1 : ∑ j : Option (J₁ ⊕ J₂), |c' j| = 1 := by
          rw [Fintype.sum_option]
          simp [c']
        have hsup : (Finset.univ.sup' Finset.univ_nonempty fun p : Bool × Bool =>
            |h_eq p - b' - ∑ j : Option (J₁ ⊕ J₂),
              extendQueryFamily (prodQueryFamily F₁ F₂) h_eq j p * c' j|) = 0 := by
          have hzero : ∀ p : Bool × Bool,
              |h_eq p - b' - ∑ j : Option (J₁ ⊕ J₂),
                extendQueryFamily (prodQueryFamily F₁ F₂) h_eq j p * c' j| = 0 := by
            intro p
            rw [Fintype.sum_option]
            simp [extendQueryFamily, b', c']
          exact le_antisymm
            (Finset.sup'_le Finset.univ_nonempty _ fun p _ => (hzero p).le)
            (by
              have hle_pt := Finset.le_sup'
                (fun p : Bool × Bool =>
                  |h_eq p - b' - ∑ j : Option (J₁ ⊕ J₂),
                    extendQueryFamily (prodQueryFamily F₁ F₂) h_eq j p * c' j|)
                (Finset.mem_univ (false, false))
              linarith [hzero (false, false)])
        rw [hsup, hl1, zero_add, mul_one, min_eq_right hlt.le]
      have heq' : primalGap h_eq μ' ν_anti =
          dualBound (extendQueryFamily (prodQueryFamily F₁ F₂) h_eq) h_eq ε b' c' :=
        hprimal'.trans hdual'.symm
      exact ⟨μ', ν_anti, b', c', hfeas',
        fun μ'' ν'' hfeas'' =>
          (primalGap_le_dualBound (extendQueryFamily (prodQueryFamily F₁ F₂) h_eq) h_eq ε hfeas'' b' c').trans heq'.symm.le,
        fun b'' c'' =>
          heq'.symm.le.trans (primalGap_le_dualBound (extendQueryFamily (prodQueryFamily F₁ F₂) h_eq) h_eq ε hfeas' b'' c''),
        hprimal', hdual'⟩
  · constructor
    · intro hlt
      by_contra hge
      rw [min_eq_left (not_lt.mp hge)] at hlt
      exact lt_irrefl _ hlt
    · intro hlt
      exact min_lt_of_right_lt hlt

/-! ## Pillar 3: Single-Distribution Empirical Estimator & Runtime Safety Certificates -/

/-- Single-distribution empirical approximation bound combining uniform residual error, sampling
tolerance `ε j`, and entrywise model discrepancy `δ j`. -/
theorem empirical_estimate_error_bound {S J : Type*} [Fintype S] [Nonempty S] [Fintype J]
    (μ : FinDist S) (F_true F_approx : J → S → ℝ) (h : S → ℝ) (y ε δ : J → ℝ)
    (hy : ∀ j : J, |y j - ∑ s : S, F_true j s * μ.w s| ≤ ε j)
    (herr : ∀ j s, |F_true j s - F_approx j s| ≤ δ j)
    (b : ℝ) (c : J → ℝ) :
    |∑ s : S, h s * μ.w s - (b + ∑ j : J, c j * y j)| ≤
      (Finset.univ.sup' Finset.univ_nonempty fun s => |h s - b - ∑ j : J, F_approx j s * c j|) +
        ∑ j : J, |c j| * (ε j + δ j) := by
  let R_inf : ℝ := Finset.univ.sup' Finset.univ_nonempty fun s => |h s - b - ∑ j : J, F_approx j s * c j|
  have hdecomp : ∑ s : S, h s * μ.w s - (b + ∑ j : J, c j * y j) =
      (∑ s : S, (h s - b - ∑ j : J, F_approx j s * c j) * μ.w s) +
      ∑ j : J, c j * ((∑ s : S, F_approx j s * μ.w s - ∑ s : S, F_true j s * μ.w s) +
        (∑ s : S, F_true j s * μ.w s - y j)) := by
    calc ∑ s : S, h s * μ.w s - (b + ∑ j : J, c j * y j)
        = (∑ s : S, (h s - b - ∑ j : J, F_approx j s * c j) * μ.w s) +
          b * ∑ s : S, μ.w s +
          ∑ s : S, (∑ j : J, F_approx j s * c j) * μ.w s -
          (b + ∑ j : J, c j * y j) := by
            rw [Finset.mul_sum, ← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
            congr 1
            refine Finset.sum_congr rfl fun s _ => by ring
      _ = (∑ s : S, (h s - b - ∑ j : J, F_approx j s * c j) * μ.w s) +
          ((∑ j : J, c j * ∑ s : S, F_approx j s * μ.w s) - ∑ j : J, c j * y j) := by
            rw [μ.sum_eq_one, mul_one]
            have hswap : ∑ s : S, (∑ j : J, F_approx j s * c j) * μ.w s =
                ∑ j : J, c j * ∑ s : S, F_approx j s * μ.w s := by
              calc ∑ s : S, (∑ j : J, F_approx j s * c j) * μ.w s
                  = ∑ s : S, ∑ j : J, c j * (F_approx j s * μ.w s) := by
                    refine Finset.sum_congr rfl fun s _ => ?_
                    rw [Finset.sum_mul]
                    refine Finset.sum_congr rfl fun j _ => by ring
                _ = ∑ j : J, ∑ s : S, c j * (F_approx j s * μ.w s) := Finset.sum_comm
                _ = ∑ j : J, c j * ∑ s : S, F_approx j s * μ.w s := by
                    refine Finset.sum_congr rfl fun j _ => (Finset.mul_sum _ _ _).symm
            rw [hswap]
            ring
      _ = (∑ s : S, (h s - b - ∑ j : J, F_approx j s * c j) * μ.w s) +
          ∑ j : J, c j * ((∑ s : S, F_approx j s * μ.w s - ∑ s : S, F_true j s * μ.w s) +
            (∑ s : S, F_true j s * μ.w s - y j)) := by
            rw [← Finset.sum_sub_distrib]
            congr 1
            refine Finset.sum_congr rfl fun j _ => by ring
  rw [hdecomp]
  have h1 : |∑ s : S, (h s - b - ∑ j : J, F_approx j s * c j) * μ.w s| ≤ R_inf := by
    calc |∑ s : S, (h s - b - ∑ j : J, F_approx j s * c j) * μ.w s|
        ≤ ∑ s : S, |(h s - b - ∑ j : J, F_approx j s * c j) * μ.w s| :=
          Finset.abs_sum_le_sum_abs _ _
      _ ≤ ∑ s : S, R_inf * μ.w s := by
          refine Finset.sum_le_sum fun s _ => ?_
          rw [abs_mul, abs_of_nonneg (μ.nonneg s)]
          exact mul_le_mul_of_nonneg_right
            (Finset.le_sup' (fun s' => |h s' - b - ∑ j : J, F_approx j s' * c j|) (Finset.mem_univ s))
            (μ.nonneg s)
      _ = R_inf * ∑ s : S, μ.w s := (Finset.mul_sum _ _ _).symm
      _ = R_inf := by rw [μ.sum_eq_one, mul_one]
  have h2 : |∑ j : J, c j * ((∑ s : S, F_approx j s * μ.w s - ∑ s : S, F_true j s * μ.w s) +
        (∑ s : S, F_true j s * μ.w s - y j))| ≤ ∑ j : J, |c j| * (ε j + δ j) := by
    calc |∑ j : J, c j * ((∑ s : S, F_approx j s * μ.w s - ∑ s : S, F_true j s * μ.w s) +
          (∑ s : S, F_true j s * μ.w s - y j))|
        ≤ ∑ j : J, |c j * ((∑ s : S, F_approx j s * μ.w s - ∑ s : S, F_true j s * μ.w s) +
          (∑ s : S, F_true j s * μ.w s - y j))| := Finset.abs_sum_le_sum_abs _ _
      _ ≤ ∑ j : J, |c j| * (ε j + δ j) := by
          refine Finset.sum_le_sum fun j _ => ?_
          rw [abs_mul]
          refine mul_le_mul_of_nonneg_left ?_ (abs_nonneg _)
          have hmod : |∑ s : S, F_approx j s * μ.w s - ∑ s : S, F_true j s * μ.w s| ≤ δ j := by
            rw [← Finset.sum_sub_distrib]
            calc |∑ s : S, (F_approx j s * μ.w s - F_true j s * μ.w s)|
                ≤ ∑ s : S, |F_approx j s * μ.w s - F_true j s * μ.w s| :=
                  Finset.abs_sum_le_sum_abs _ _
              _ ≤ ∑ s : S, δ j * μ.w s := by
                  refine Finset.sum_le_sum fun s _ => ?_
                  rw [← sub_mul, abs_mul, abs_sub_comm, abs_of_nonneg (μ.nonneg s)]
                  exact mul_le_mul_of_nonneg_right (herr j s) (μ.nonneg s)
              _ = δ j * ∑ s : S, μ.w s := (Finset.mul_sum _ _ _).symm
              _ = δ j := by rw [μ.sum_eq_one, mul_one]
          have hsam : |∑ s : S, F_true j s * μ.w s - y j| ≤ ε j := by
            rw [abs_sub_comm]
            exact hy j
          calc |(∑ s : S, F_approx j s * μ.w s - ∑ s : S, F_true j s * μ.w s) +
                (∑ s : S, F_true j s * μ.w s - y j)|
              ≤ |∑ s : S, F_approx j s * μ.w s - ∑ s : S, F_true j s * μ.w s| +
                |∑ s : S, F_true j s * μ.w s - y j| := abs_add_le _ _
            _ ≤ δ j + ε j := add_le_add hmod hsam
            _ = ε j + δ j := add_comm _ _
  calc |(∑ s : S, (h s - b - ∑ j : J, F_approx j s * c j) * μ.w s) +
          ∑ j : J, c j * ((∑ s : S, F_approx j s * μ.w s - ∑ s : S, F_true j s * μ.w s) +
            (∑ s : S, F_true j s * μ.w s - y j))|
      ≤ |∑ s : S, (h s - b - ∑ j : J, F_approx j s * c j) * μ.w s| +
        |∑ j : J, c j * ((∑ s : S, F_approx j s * μ.w s - ∑ s : S, F_true j s * μ.w s) +
          (∑ s : S, F_true j s * μ.w s - y j))| := abs_add_le _ _
    _ ≤ R_inf + ∑ j : J, |c j| * (ε j + δ j) := add_le_add h1 h2

/-- Certified runtime safety gate: if empirical surrogate `b + ∑ j, c j * y j` clears safety
margin `R_tot`, the unobserved expectation `∑ s, h s * μ.w s` satisfies the threshold `τ`. -/
theorem empirical_threshold_safety_certificate {S J : Type*} [Fintype S] [Nonempty S] [Fintype J]
    (μ : FinDist S) (F_true F_approx : J → S → ℝ) (h : S → ℝ) (y ε δ : J → ℝ)
    (hy : ∀ j : J, |y j - ∑ s : S, F_true j s * μ.w s| ≤ ε j)
    (herr : ∀ j s, |F_true j s - F_approx j s| ≤ δ j)
    (b : ℝ) (c : J → ℝ) (τ : ℝ) :
    let R_tot : ℝ :=
      (Finset.univ.sup' Finset.univ_nonempty fun s => |h s - b - ∑ j : J, F_approx j s * c j|) +
        ∑ j : J, |c j| * (ε j + δ j)
    (τ + R_tot ≤ b + ∑ j : J, c j * y j → τ ≤ ∑ s : S, h s * μ.w s) ∧
    (b + ∑ j : J, c j * y j + R_tot ≤ τ → ∑ s : S, h s * μ.w s ≤ τ) := by
  dsimp only
  have hbd := empirical_estimate_error_bound μ F_true F_approx h y ε δ hy herr b c
  rw [abs_le] at hbd
  constructor
  · intro hlow
    linarith [hbd.1]
  · intro hhigh
    linarith [hbd.2]

end DualityLifting
