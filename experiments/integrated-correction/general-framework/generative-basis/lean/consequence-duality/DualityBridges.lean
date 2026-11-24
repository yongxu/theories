import Mathlib.Analysis.LocallyConvex.Separation
import Mathlib.Analysis.Convex.StdSimplex
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.Tactic
import FiniteProbKrylov
import ConsequenceDuality

/-!
# DualityBridges: Model Error, Open-Entry Monotonicity, Affine Span & Krylov Zero-Radius

AI-written (Wave 2, 2026-11-24).
Bridges `ConsequenceDuality` (§7.2 minimax duality) to:
1. Bounded model-error propagation (`dualBound_with_model_error`, `dualBound_with_uniform_model_error`);
2. Monotone minimax improvement under new-query / new-entry extension (`monotone_entry_value`,
   `monotone_entry_value_exists`, `strict_entry_improvement_witness`);
3. Exact affine-span characterization of zero dual objective (`zero_dualBound_iff_affine_span`);
4. Self-contained finite Krylov stabilization over bounded-length action words
   (`finite_krylov_zero_minimax_radius`), showing zero attained `ε = 0` minimax gap from
   horizon-`≤ |S| - 1` survival queries.
-/

namespace DualityBridges

open ConsequenceDuality
open scoped BigOperators

/-! ## Bridge 1: Model-Error Propagation -/

/-- Per-query tolerance feasibility for `μ, ν : FinDist S`. -/
def PrimalFeasibleVec {S J : Type*} [Fintype S] (F : J → S → ℝ) (ε : J → ℝ)
    (μ ν : FinDist S) : Prop :=
  ∀ j : J, |∑ s : S, F j s * (μ.w s - ν.w s)| ≤ 2 * ε j

/-- Dual objective with per-query tolerance vector `ε : J → ℝ`. -/
noncomputable def dualBoundVec {S J : Type*} [Fintype S] [Nonempty S] [Fintype J]
    (F : J → S → ℝ) (h : S → ℝ) (ε : J → ℝ) (b : ℝ) (c : J → ℝ) : ℝ :=
  (Finset.univ.sup' Finset.univ_nonempty fun s => |h s - b - ∑ j : J, F j s * c j|) +
    ∑ j : J, |c j| * ε j

/-- Bounded model discrepancy `|F_true j s - F_approx j s| ≤ δ j` enlarges feasible tolerances from
`ε j` to `ε j + δ j`. -/
theorem approx_feasible_of_model_error {S J : Type*} [Fintype S]
    (F_true F_approx : J → S → ℝ) (ε δ : J → ℝ) {μ ν : FinDist S}
    (hfeas : PrimalFeasibleVec F_true ε μ ν)
    (herr : ∀ j s, |F_true j s - F_approx j s| ≤ δ j) :
    PrimalFeasibleVec F_approx (fun j => ε j + δ j) μ ν := by
  intro j
  have hsum_abs : ∑ s : S, |μ.w s - ν.w s| ≤ 2 := by
    calc ∑ s : S, |μ.w s - ν.w s|
        ≤ ∑ s : S, (μ.w s + ν.w s) := Finset.sum_le_sum fun s _ => by
          have h1 : |μ.w s - ν.w s| ≤ |μ.w s| + |ν.w s| := abs_sub _ _
          rwa [abs_of_nonneg (μ.nonneg s), abs_of_nonneg (ν.nonneg s)] at h1
      _ = 2 := by rw [Finset.sum_add_distrib, μ.sum_eq_one, ν.sum_eq_one]; norm_num
  have hsplit : ∑ s : S, F_approx j s * (μ.w s - ν.w s) =
      (∑ s : S, F_true j s * (μ.w s - ν.w s)) +
        ∑ s : S, (F_approx j s - F_true j s) * (μ.w s - ν.w s) := by
    rw [← Finset.sum_add_distrib]
    refine Finset.sum_congr rfl fun s _ => by ring
  have herr_sum : |∑ s : S, (F_approx j s - F_true j s) * (μ.w s - ν.w s)| ≤ 2 * δ j := by
    calc |∑ s : S, (F_approx j s - F_true j s) * (μ.w s - ν.w s)|
        ≤ ∑ s : S, |(F_approx j s - F_true j s) * (μ.w s - ν.w s)| :=
          Finset.abs_sum_le_sum_abs _ _
      _ ≤ ∑ s : S, δ j * |μ.w s - ν.w s| := Finset.sum_le_sum fun s _ => by
          rw [abs_mul, abs_sub_comm]
          exact mul_le_mul_of_nonneg_right (herr j s) (abs_nonneg _)
      _ = δ j * ∑ s : S, |μ.w s - ν.w s| := (Finset.mul_sum _ _ _).symm
      _ ≤ δ j * 2 := by
          have hne : Nonempty S := by
            by_contra hempty
            exact (empty_source_infeasible (not_nonempty_iff.mp hempty)).false μ
          rcases hne with ⟨s₀⟩
          have hδ0 : 0 ≤ δ j := (abs_nonneg _).trans (herr j s₀)
          exact mul_le_mul_of_nonneg_left hsum_abs hδ0
      _ = 2 * δ j := by ring
  rw [hsplit]
  calc |(∑ s : S, F_true j s * (μ.w s - ν.w s)) +
          ∑ s : S, (F_approx j s - F_true j s) * (μ.w s - ν.w s)|
      ≤ |∑ s : S, F_true j s * (μ.w s - ν.w s)| +
        |∑ s : S, (F_approx j s - F_true j s) * (μ.w s - ν.w s)| := abs_add_le _ _
    _ ≤ 2 * ε j + 2 * δ j := add_le_add (hfeas j) herr_sum
    _ = 2 * (ε j + δ j) := by ring

/-- Weak duality for per-query tolerance vector `ε : J → ℝ`. -/
theorem primalGap_le_dualBoundVec {S J : Type*} [Fintype S] [Nonempty S] [Fintype J]
    (F : J → S → ℝ) (h : S → ℝ) (ε : J → ℝ) {μ ν : FinDist S}
    (hfeas : PrimalFeasibleVec F ε μ ν) (b : ℝ) (c : J → ℝ) :
    primalGap h μ ν ≤ dualBoundVec F h ε b c := by
  let R : ℝ := Finset.univ.sup' Finset.univ_nonempty fun s => |h s - b - ∑ j : J, F j s * c j|
  have hR_nonneg : 0 ≤ R := by
    obtain ⟨s₀⟩ := ‹Nonempty S›
    exact (abs_nonneg _).trans (Finset.le_sup' (fun s => |h s - b - ∑ j : J, F j s * c j|)
      (Finset.mem_univ s₀))
  have hsum_zero : ∑ s : S, (μ.w s - ν.w s) = 0 := by
    rw [Finset.sum_sub_distrib, μ.sum_eq_one, ν.sum_eq_one, sub_self]
  have hsum_abs : ∑ s : S, |μ.w s - ν.w s| ≤ 2 := by
    calc ∑ s : S, |μ.w s - ν.w s|
        ≤ ∑ s : S, (μ.w s + ν.w s) := Finset.sum_le_sum fun s _ => by
          have h1 : |μ.w s - ν.w s| ≤ |μ.w s| + |ν.w s| := abs_sub _ _
          rwa [abs_of_nonneg (μ.nonneg s), abs_of_nonneg (ν.nonneg s)] at h1
      _ = 2 := by rw [Finset.sum_add_distrib, μ.sum_eq_one, ν.sum_eq_one]; norm_num
  have hdecomp : ∑ s : S, h s * (μ.w s - ν.w s) =
      (∑ s : S, (h s - b - ∑ j : J, F j s * c j) * (μ.w s - ν.w s)) +
      ∑ j : J, c j * (∑ s : S, F j s * (μ.w s - ν.w s)) := by
    calc ∑ s : S, h s * (μ.w s - ν.w s)
        = (∑ s : S, (h s - b - ∑ j : J, F j s * c j) * (μ.w s - ν.w s)) +
          b * (∑ s : S, (μ.w s - ν.w s)) +
          ∑ s : S, (∑ j : J, F j s * c j) * (μ.w s - ν.w s) := by
            rw [Finset.mul_sum, ← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
            refine Finset.sum_congr rfl fun s _ => by ring
      _ = (∑ s : S, (h s - b - ∑ j : J, F j s * c j) * (μ.w s - ν.w s)) +
          ∑ j : J, c j * (∑ s : S, F j s * (μ.w s - ν.w s)) := by
            rw [hsum_zero, mul_zero, add_zero]
            congr 1
            have hswap : (∑ s : S, (∑ j : J, F j s * c j) * (μ.w s - ν.w s)) =
                ∑ s : S, ∑ j : J, c j * (F j s * (μ.w s - ν.w s)) := by
              refine Finset.sum_congr rfl fun s _ => ?_
              rw [Finset.sum_mul]
              refine Finset.sum_congr rfl fun j _ => by ring
            rw [hswap, Finset.sum_comm]
            refine Finset.sum_congr rfl fun j _ => (Finset.mul_sum _ _ _).symm
  have hbound : |∑ s : S, h s * (μ.w s - ν.w s)| ≤ 2 * dualBoundVec F h ε b c := by
    rw [hdecomp]
    calc |(∑ s : S, (h s - b - ∑ j : J, F j s * c j) * (μ.w s - ν.w s)) +
            ∑ j : J, c j * (∑ s : S, F j s * (μ.w s - ν.w s))|
        ≤ |∑ s : S, (h s - b - ∑ j : J, F j s * c j) * (μ.w s - ν.w s)| +
          |∑ j : J, c j * (∑ s : S, F j s * (μ.w s - ν.w s))| := abs_add_le _ _
      _ ≤ (∑ s : S, |(h s - b - ∑ j : J, F j s * c j) * (μ.w s - ν.w s)|) +
          ∑ j : J, |c j * (∑ s : S, F j s * (μ.w s - ν.w s))| :=
          add_le_add (Finset.abs_sum_le_sum_abs _ _) (Finset.abs_sum_le_sum_abs _ _)
      _ ≤ (∑ s : S, R * |μ.w s - ν.w s|) + ∑ j : J, |c j| * (2 * ε j) := by
          refine add_le_add (Finset.sum_le_sum fun s _ => ?_) (Finset.sum_le_sum fun j _ => ?_)
          · rw [abs_mul]
            exact mul_le_mul_of_nonneg_right
              (Finset.le_sup' (fun s' => |h s' - b - ∑ j : J, F j s' * c j|) (Finset.mem_univ s))
              (abs_nonneg _)
          · rw [abs_mul]
            exact mul_le_mul_of_nonneg_left (hfeas j) (abs_nonneg _)
      _ = R * (∑ s : S, |μ.w s - ν.w s|) + 2 * (∑ j : J, |c j| * ε j) := by
          rw [← Finset.mul_sum]
          congr 1
          rw [Finset.mul_sum]
          exact Finset.sum_congr rfl fun j _ => by ring
      _ ≤ R * 2 + 2 * (∑ j : J, |c j| * ε j) := by
          gcongr
      _ = 2 * dualBoundVec F h ε b c := by
          simp only [dualBoundVec, R]
          ring
  unfold primalGap
  linarith

/-- Model-error propagation for §7.2 duality: feasibility under `F_true` with tolerance `ε j` and
entrywise model error `|F_true j s - F_approx j s| ≤ δ j` controls `primalGap h μ ν` via the
approximate model `F_approx` at enlarged tolerance `ε j + δ j`. -/
theorem dualBound_with_model_error {S J : Type*} [Fintype S] [Nonempty S] [Fintype J]
    (F_true F_approx : J → S → ℝ) (h : S → ℝ) (ε δ : J → ℝ) {μ ν : FinDist S}
    (hfeas : PrimalFeasibleVec F_true ε μ ν)
    (herr : ∀ j s, |F_true j s - F_approx j s| ≤ δ j)
    (b : ℝ) (c : J → ℝ) :
    primalGap h μ ν ≤
      (Finset.univ.sup' Finset.univ_nonempty fun s => |h s - b - ∑ j : J, F_approx j s * c j|) +
        ∑ j : J, |c j| * (ε j + δ j) :=
  primalGap_le_dualBoundVec F_approx h (fun j => ε j + δ j)
    (approx_feasible_of_model_error F_true F_approx ε δ hfeas herr) b c

/-- Uniform scalar-tolerance specialization connecting directly to `ConsequenceDuality.PrimalFeasible`
and `ConsequenceDuality.dualBound`. -/
theorem dualBound_with_uniform_model_error {S J : Type*} [Fintype S] [Nonempty S] [Fintype J]
    (F_true F_approx : J → S → ℝ) (h : S → ℝ) {ε δ : ℝ} {μ ν : FinDist S}
    (hfeas : PrimalFeasible F_true ε μ ν)
    (herr : ∀ j s, |F_true j s - F_approx j s| ≤ δ)
    (b : ℝ) (c : J → ℝ) :
    primalGap h μ ν ≤ dualBound F_approx h (ε + δ) b c := by
  have hfeas_vec : PrimalFeasibleVec F_true (fun _ => ε) μ ν := hfeas
  have happrox : PrimalFeasible F_approx (ε + δ) μ ν :=
    approx_feasible_of_model_error F_true F_approx (fun _ => ε) (fun _ => δ) hfeas_vec herr
  exact primalGap_le_dualBound F_approx h (ε + δ) happrox b c

/-! ## Bridge 2: Monotone Value under Query / Entry Extension & Strict Witnesses -/

/-- Extend query family `F : J → S → ℝ` with one additional query row `fNew : S → ℝ`. -/
def extendQueryFamily {S J : Type*} (F : J → S → ℝ) (fNew : S → ℝ) : Option J → S → ℝ
  | none => fNew
  | some j => F j

/-- Pad dual coefficients with `0` on the newly added query slot `none`. -/
def extendDualCoeff {J : Type*} (c : J → ℝ) : Option J → ℝ
  | none => 0
  | some j => c j

/-- Extending `F` by `fNew` and `c` by `0` preserves `dualBound` identically. -/
theorem dualBound_extendQueryFamily {S J : Type*} [Fintype S] [Nonempty S] [Fintype J]
    (F : J → S → ℝ) (fNew h : S → ℝ) (ε b : ℝ) (c : J → ℝ) :
    dualBound (extendQueryFamily F fNew) h ε b (extendDualCoeff c) = dualBound F h ε b c := by
  unfold dualBound
  have hlin : ∀ s : S,
      (∑ j : Option J, extendQueryFamily F fNew j s * extendDualCoeff c j) =
        ∑ j : J, F j s * c j := by
    intro s
    rw [Fintype.sum_option]
    simp [extendQueryFamily, extendDualCoeff]
  have hl1 : (∑ j : Option J, |extendDualCoeff c j|) = ∑ j : J, |c j| := by
    rw [Fintype.sum_option]
    simp [extendDualCoeff]
  simp only [hlin, hl1]

/-- Any query-family map `embed : J₁ → J₂` preserves primal feasibility backwards and weakly lowers
every minimax optimal consequence gap. -/
theorem monotone_entry_value {S J₁ J₂ : Type*} [Fintype S] [Nonempty S] [Fintype J₁] [Fintype J₂]
    (F₁ : J₁ → S → ℝ) (F₂ : J₂ → S → ℝ) (h : S → ℝ) {ε : ℝ}
    (embed : J₁ → J₂) (hsub : ∀ j s, F₂ (embed j) s = F₁ j s)
    {μ₁ ν₁ μ₂ ν₂ : FinDist S}
    (hopt₁ : ∀ μ' ν' : FinDist S, PrimalFeasible F₁ ε μ' ν' → primalGap h μ' ν' ≤ primalGap h μ₁ ν₁)
    (hfeas₂ : PrimalFeasible F₂ ε μ₂ ν₂) :
    primalGap h μ₂ ν₂ ≤ primalGap h μ₁ ν₁ := by
  refine hopt₁ μ₂ ν₂ fun j => ?_
  have hj := hfeas₂ (embed j)
  have heq : (∑ s : S, F₁ j s * (μ₂.w s - ν₂.w s)) =
      ∑ s : S, F₂ (embed j) s * (μ₂.w s - ν₂.w s) := by
    refine Finset.sum_congr rfl fun s _ => ?_
    rw [hsub j s]
  rw [heq]
  exact hj

/-- Existence of attained §7.2 minimax saddles before and after adding a new query `fNew`, with
monotone decrease in optimal minimax value (`v₂ ≤ v₁`). -/
theorem monotone_entry_value_exists {S J : Type*} [Fintype S] [Nonempty S] [Fintype J]
    (F : J → S → ℝ) (fNew h : S → ℝ) {ε : ℝ} (hε : 0 ≤ ε) :
    ∃ (μ₁ ν₁ : FinDist S) (b₁ : ℝ) (c₁ : J → ℝ)
      (μ₂ ν₂ : FinDist S) (b₂ : ℝ) (c₂ : Option J → ℝ),
      PrimalFeasible F ε μ₁ ν₁ ∧
      (∀ μ' ν' : FinDist S, PrimalFeasible F ε μ' ν' → primalGap h μ' ν' ≤ primalGap h μ₁ ν₁) ∧
      (∀ (b' : ℝ) (c' : J → ℝ), dualBound F h ε b₁ c₁ ≤ dualBound F h ε b' c') ∧
      primalGap h μ₁ ν₁ = dualBound F h ε b₁ c₁ ∧
      PrimalFeasible (extendQueryFamily F fNew) ε μ₂ ν₂ ∧
      (∀ μ' ν' : FinDist S, PrimalFeasible (extendQueryFamily F fNew) ε μ' ν' →
        primalGap h μ' ν' ≤ primalGap h μ₂ ν₂) ∧
      (∀ (b' : ℝ) (c' : Option J → ℝ),
        dualBound (extendQueryFamily F fNew) h ε b₂ c₂ ≤
          dualBound (extendQueryFamily F fNew) h ε b' c') ∧
      primalGap h μ₂ ν₂ = dualBound (extendQueryFamily F fNew) h ε b₂ c₂ ∧
      primalGap h μ₂ ν₂ ≤ primalGap h μ₁ ν₁ ∧
      dualBound (extendQueryFamily F fNew) h ε b₂ c₂ ≤ dualBound F h ε b₁ c₁ := by
  obtain ⟨μ₁, ν₁, b₁, c₁, hf₁, hp₁, hd₁, heq₁⟩ := consequence_minimax_duality F h hε
  obtain ⟨μ₂, ν₂, b₂, c₂, hf₂, hp₂, hd₂, heq₂⟩ :=
    consequence_minimax_duality (extendQueryFamily F fNew) h hε
  have hp_le : primalGap h μ₂ ν₂ ≤ primalGap h μ₁ ν₁ :=
    monotone_entry_value F (extendQueryFamily F fNew) h some (fun _ _ => rfl) hp₁ hf₂
  have hd_le : dualBound (extendQueryFamily F fNew) h ε b₂ c₂ ≤ dualBound F h ε b₁ c₁ := by
    rw [← heq₂, ← heq₁]
    exact hp_le
  exact ⟨μ₁, ν₁, b₁, c₁, μ₂, ν₂, b₂, c₂, hf₁, hp₁, hd₁, heq₁, hf₂, hp₂, hd₂, heq₂, hp_le, hd_le⟩

/-- Concrete strict-improvement witnesses across §7.1 and §7.2:
1. For any constant public family `F_pub` and `0 ≤ ε < 1/8`, adding the recipient port strictly
   lowers minimax value `1/4 → min (1/4) (2*ε)`;
2. On the B2 aliasing-08 task `h = ![0, 1]` at `ε = 1/20`, adding the recipient probe strictly
   lowers minimax value `1/2 → 50/347`. -/
theorem strict_entry_improvement_witness {J_pub : Type*} [Fintype J_pub]
    (F_pub : J_pub → Fin 2 → ℝ) (hconst : ∀ j, F_pub j 0 = F_pub j 1)
    {ε : ℝ} (hε : 0 ≤ ε) (hε_lt : ε < 1 / 8) :
    (let h : Fin 2 → ℝ := ![1 / 4, 3 / 4]
     let F_rec : Fin 2 → Fin 2 → ℝ := ![ ![1 / 2, 1 / 2], ![1 / 8, 3 / 8] ]
     ∃ (μ₁ ν₁ : FinDist (Fin 2)) (b₁ : ℝ) (c₁ : J_pub → ℝ)
       (μ₂ ν₂ : FinDist (Fin 2)) (b₂ : ℝ) (c₂ : Fin 2 → ℝ),
       primalGap h μ₁ ν₁ = (1 / 4 : ℝ) ∧ dualBound F_pub h ε b₁ c₁ = (1 / 4 : ℝ) ∧
       primalGap h μ₂ ν₂ = min (1 / 4 : ℝ) (2 * ε) ∧
       dualBound F_rec h ε b₂ c₂ = min (1 / 4 : ℝ) (2 * ε) ∧
       primalGap h μ₂ ν₂ < primalGap h μ₁ ν₁) ∧
    (let F_blind : Fin 1 → Fin 2 → ℝ := ![ ![1, 1] ]
     let probe : Fin 1 → Fin 2 → ℝ := ![ ![285 / 1000, 632 / 1000] ]
     let h_b2 : Fin 2 → ℝ := ![0, 1]
     let ε_b2 : ℝ := 1 / 20
     ∃ (μ₁ ν₁ : FinDist (Fin 2)) (b₁ : ℝ) (c₁ : Fin 1 → ℝ)
       (μ₂ ν₂ : FinDist (Fin 2)) (b₂ : ℝ) (c₂ : Fin 1 → ℝ),
       PrimalFeasible F_blind ε_b2 μ₁ ν₁ ∧
       (∀ μ' ν' : FinDist (Fin 2), PrimalFeasible F_blind ε_b2 μ' ν' →
         primalGap h_b2 μ' ν' ≤ primalGap h_b2 μ₁ ν₁) ∧
       primalGap h_b2 μ₁ ν₁ = (1 / 2 : ℝ) ∧ dualBound F_blind h_b2 ε_b2 b₁ c₁ = (1 / 2 : ℝ) ∧
       PrimalFeasible probe ε_b2 μ₂ ν₂ ∧
       (∀ μ' ν' : FinDist (Fin 2), PrimalFeasible probe ε_b2 μ' ν' →
         primalGap h_b2 μ' ν' ≤ primalGap h_b2 μ₂ ν₂) ∧
       primalGap h_b2 μ₂ ν₂ = (50 / 347 : ℝ) ∧ dualBound probe h_b2 ε_b2 b₂ c₂ = (50 / 347 : ℝ) ∧
       primalGap h_b2 μ₂ ν₂ < primalGap h_b2 μ₁ ν₁) := by
  dsimp only
  refine ⟨?_, ?_⟩
  · obtain ⟨⟨μ₁, ν₁, b₁, c₁, _, _, _, hp₁, hd₁⟩,
            ⟨μ₂, ν₂, b₂, c₂, _, _, _, hp₂, hd₂⟩, hiff⟩ :=
      public_port_vs_recipient_exact F_pub hconst hε
    have hlt : min (1 / 4 : ℝ) (2 * ε) < 1 / 4 := hiff.mpr hε_lt
    exact ⟨μ₁, ν₁, b₁, c₁, μ₂, ν₂, b₂, c₂, hp₁, hd₁, hp₂, hd₂, by linarith⟩
  · let probe : Fin 1 → Fin 2 → ℝ := ![ ![285 / 1000, 632 / 1000] ]
    let F_blind : Fin 1 → Fin 2 → ℝ := ![ ![1, 1] ]
    let h_b2 : Fin 2 → ℝ := ![0, 1]
    let ε_b2 : ℝ := 1 / 20
    let μ₂ : FinDist (Fin 2) :=
      { w := ![247 / 347, 100 / 347]
        nonneg := fun s => by fin_cases s <;> norm_num
        sum_eq_one := by simp [Fin.sum_univ_two]; norm_num }
    let ν₂ : FinDist (Fin 2) :=
      { w := ![1, 0]
        nonneg := fun s => by fin_cases s <;> norm_num
        sum_eq_one := by simp [Fin.sum_univ_two] }
    let b₂ : ℝ := -285 / 347
    let c₂ : Fin 1 → ℝ := ![1000 / 347]
    obtain ⟨hf₂, hp_opt₂, _, hp₂, hd₂⟩ := b2_aliasing_08_exact_certificate
    let μ₁ : FinDist (Fin 2) := diracDist 1
    let ν₁ : FinDist (Fin 2) := diracDist 0
    let b₁ : ℝ := 1 / 2
    let c₁ : Fin 1 → ℝ := fun _ => 0
    have hf₁ : PrimalFeasible F_blind ε_b2 μ₁ ν₁ := fun j => by
      have h0 : (∑ s : Fin 2, F_blind j s * (μ₁.w s - ν₁.w s)) = 0 := by
        fin_cases j
        simp [F_blind, μ₁, ν₁, FiniteProb.diracDist, Fin.sum_univ_two]
      rw [h0, abs_zero]
      norm_num [ε_b2]
    have hd₁ : dualBound F_blind h_b2 ε_b2 b₁ c₁ = (1 / 2 : ℝ) := by
      unfold dualBound
      have hsub0 : |h_b2 0 - b₁ - ∑ j : Fin 1, F_blind j 0 * c₁ j| = 1 / 2 := by
        simp [h_b2, b₁, c₁]
      have hc0 : (∑ j : Fin 1, |c₁ j|) = 0 := by simp [c₁]
      rw [hc0, mul_zero, add_zero]
      exact le_antisymm
        (Finset.sup'_le Finset.univ_nonempty _ fun s _ => by
          fin_cases s <;> simp [h_b2, b₁, c₁] <;> norm_num)
        (by
          have hle := Finset.le_sup' (fun s : Fin 2 => |h_b2 s - b₁ - ∑ j : Fin 1, F_blind j s * c₁ j|)
            (Finset.mem_univ 0)
          linarith [hsub0, hle])
    have hp₁ : primalGap h_b2 μ₁ ν₁ = (1 / 2 : ℝ) := by
      unfold primalGap
      simp [h_b2, μ₁, ν₁, FiniteProb.diracDist, Fin.sum_univ_two]
    have hp_opt₁ : ∀ μ' ν' : FinDist (Fin 2), PrimalFeasible F_blind ε_b2 μ' ν' →
        primalGap h_b2 μ' ν' ≤ primalGap h_b2 μ₁ ν₁ := by
      intro μ' ν' hf'
      calc primalGap h_b2 μ' ν'
          ≤ dualBound F_blind h_b2 ε_b2 b₁ c₁ := primalGap_le_dualBound F_blind h_b2 ε_b2 hf' b₁ c₁
        _ = primalGap h_b2 μ₁ ν₁ := hd₁.trans hp₁.symm
    exact ⟨μ₁, ν₁, b₁, c₁, μ₂, ν₂, b₂, c₂, hf₁, hp_opt₁, hp₁, hd₁, hf₂, hp_opt₂, hp₂, hd₂,
      by linarith⟩

/-! ## Bridge 3: Affine-Span Characterization of Zero Dual Objective -/

/-- At `ε = 0`, `dualBound F h 0 b c = 0` iff `h` equals the exact affine combination `b + ∑ j, F j · * c j`. -/
theorem dualBound_zero_eq_zero_iff {S J : Type*} [Fintype S] [Nonempty S] [Fintype J]
    (F : J → S → ℝ) (h : S → ℝ) (b : ℝ) (c : J → ℝ) :
    dualBound F h 0 b c = 0 ↔ ∀ s : S, h s = b + ∑ j : J, F j s * c j := by
  unfold dualBound
  rw [zero_mul, add_zero]
  constructor
  · intro hsup s
    have hle : |h s - b - ∑ j : J, F j s * c j| ≤ 0 := by
      calc |h s - b - ∑ j : J, F j s * c j|
          ≤ Finset.univ.sup' Finset.univ_nonempty (fun s' => |h s' - b - ∑ j : J, F j s' * c j|) :=
            Finset.le_sup' (fun s' => |h s' - b - ∑ j : J, F j s' * c j|) (Finset.mem_univ s)
        _ = 0 := hsup
    have habs0 : |h s - b - ∑ j : J, F j s * c j| = 0 := le_antisymm hle (abs_nonneg _)
    linarith [abs_eq_zero.mp habs0]
  · intro hpt
    obtain ⟨s₀⟩ := ‹Nonempty S›
    have hle : (Finset.univ.sup' Finset.univ_nonempty fun s => |h s - b - ∑ j : J, F j s * c j|) ≤ 0 :=
      Finset.sup'_le Finset.univ_nonempty _ fun s _ => by
        rw [hpt s]
        simp
    have hge : 0 ≤ Finset.univ.sup' Finset.univ_nonempty fun s => |h s - b - ∑ j : J, F j s * c j| :=
      (abs_nonneg _).trans
        (Finset.le_sup' (fun s => |h s - b - ∑ j : J, F j s * c j|) (Finset.mem_univ s₀))
    exact le_antisymm hle hge

/-- Exact span equivalence: `∃ b c, dualBound F h 0 b c = 0` iff `h` lies in the linear span of the
constant `1` function and the query rows `F`. -/
theorem zero_dualBound_iff_affine_span {S J : Type*} [Fintype S] [Nonempty S] [Fintype J]
    (F : J → S → ℝ) (h : S → ℝ) :
    (∃ (b : ℝ) (c : J → ℝ), dualBound F h 0 b c = 0) ↔
      h ∈ Submodule.span ℝ (insert (fun _ : S => (1 : ℝ)) (Set.range F)) := by
  constructor
  · rintro ⟨b, c, hzero⟩
    have hpt := (dualBound_zero_eq_zero_iff F h b c).mp hzero
    have hEq : h = b • (fun _ : S => (1 : ℝ)) + ∑ j : J, c j • F j := by
      ext s
      simp [hpt s, mul_comm]
    rw [hEq]
    refine Submodule.add_mem _ (Submodule.smul_mem _ b (Submodule.subset_span (Set.mem_insert _ _)))
      (Submodule.sum_mem _ fun j _ => Submodule.smul_mem _ (c j)
        (Submodule.subset_span (Set.mem_insert_of_mem _ ⟨j, rfl⟩)))
  · intro hmem
    rw [Submodule.mem_span_insert] at hmem
    obtain ⟨b, z, hz, hEq⟩ := hmem
    rw [Submodule.mem_span_range_iff_exists_fun ℝ] at hz
    obtain ⟨c, hc⟩ := hz
    refine ⟨b, c, (dualBound_zero_eq_zero_iff F h b c).mpr fun s => ?_⟩
    have hs := congrFun hEq s
    have hcs := congrFun hc s
    simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul, mul_one, Finset.sum_apply] at hs hcs
    rw [hs, ← hcs]
    congr 1
    exact Finset.sum_congr rfl fun j _ => mul_comm (c j) (F j s)

/-! ## Bridge 4: Finite Krylov Stabilization & Zero Minimax Error -/

/-- One-step linear transfer operator for transition matrix `M : S → S → ℝ` (re-exported from `FiniteKrylov`). -/
noncomputable abbrev stepOp {S : Type*} [Fintype S] (M : S → S → ℝ) (v : S → ℝ) : S → ℝ :=
  FiniteKrylov.stepOp M v

/-- `stepOp` as a linear map on `S → ℝ`. -/
noncomputable abbrev stepLinearMap {S : Type*} [Fintype S] (M : S → S → ℝ) :
    (S → ℝ) →ₗ[ℝ] (S → ℝ) :=
  FiniteKrylov.stepLinearMap M

/-- Action-word transfer applied to initial potential `v₀ : S → ℝ`. -/
noncomputable abbrev wordVec {S Act : Type*} [Fintype S] (K : Act → S → S → ℝ) (v₀ : S → ℝ) :
    List Act → S → ℝ :=
  FiniteKrylov.wordVec K v₀

/-- Finite-horizon survival vector `wordVec K (fun _ => 1) w`. -/
noncomputable abbrev survVec {S Act : Type*} [Fintype S] (K : Act → S → S → ℝ) : List Act → S → ℝ :=
  FiniteKrylov.survVec K

/-- Subspace spanned by all `wordVec K v₀ w` of word length at most `k`. -/
noncomputable abbrev krylovSub {S Act : Type*} [Fintype S] (K : Act → S → S → ℝ) (v₀ : S → ℝ)
    (k : ℕ) : Submodule ℝ (S → ℝ) :=
  FiniteKrylov.krylovSub K v₀ k

theorem krylovSub_mono {S Act : Type*} [Fintype S] (K : Act → S → S → ℝ) (v₀ : S → ℝ)
    {j k : ℕ} (hjk : j ≤ k) :
    krylovSub K v₀ j ≤ krylovSub K v₀ k :=
  FiniteKrylov.krylovSub_mono K v₀ hjk

theorem stepLinearMap_mem_krylovSub_succ {S Act : Type*} [Fintype S]
    (K : Act → S → S → ℝ) (v₀ : S → ℝ) (k : ℕ) (a : Act) :
    Submodule.map (stepLinearMap (K a)) (krylovSub K v₀ k) ≤ krylovSub K v₀ (k + 1) :=
  FiniteKrylov.stepLinearMap_mem_krylovSub_succ K v₀ k a

theorem krylovSub_step_eq_of_eq {S Act : Type*} [Fintype S]
    (K : Act → S → S → ℝ) (v₀ : S → ℝ) {k : ℕ}
    (hk : krylovSub K v₀ k = krylovSub K v₀ (k + 1)) :
    krylovSub K v₀ (k + 1) = krylovSub K v₀ (k + 2) :=
  FiniteKrylov.krylovSub_step_eq_of_eq K v₀ hk

theorem krylovSub_stabilizes_from {S Act : Type*} [Fintype S]
    (K : Act → S → S → ℝ) (v₀ : S → ℝ) {k : ℕ}
    (hk : krylovSub K v₀ k = krylovSub K v₀ (k + 1)) :
    ∀ m : ℕ, k ≤ m → krylovSub K v₀ m = krylovSub K v₀ k :=
  FiniteKrylov.krylovSub_stabilizes_from K v₀ hk

theorem krylovSub_stabilizes_before_card {S Act : Type*} [Fintype S] [Nonempty S]
    (K : Act → S → S → ℝ) (v₀ : S → ℝ) :
    ∃ k ≤ Fintype.card S - 1, krylovSub K v₀ k = krylovSub K v₀ (k + 1) :=
  FiniteKrylov.krylovSub_stabilizes_before_card K v₀

theorem wordVec_mem_krylovSub_pred {S Act : Type*} [Fintype S] [Nonempty S]
    (K : Act → S → S → ℝ) (v₀ : S → ℝ) (w : List Act) :
    wordVec K v₀ w ∈ krylovSub K v₀ (Fintype.card S - 1) :=
  FiniteKrylov.wordVec_mem_krylovSub_pred K v₀ w

/-- Finite index of all action words of length `< Fintype.card S` (i.e. `≤ Fintype.card S - 1`). -/
abbrev ShortWord (S Act : Type*) [Fintype S] :=
  Σ len : Fin (Fintype.card S), (Fin len.1 → Act)

/-- Query matrix over all bounded-length survival words `≤ Fintype.card S - 1`. -/
noncomputable def shortWordQuery {S Act : Type*} [Fintype S] (K : Act → S → S → ℝ)
    (v₀ : S → ℝ) (q : ShortWord S Act) : S → ℝ :=
  wordVec K v₀ (List.ofFn q.2)

/-- Finite Krylov stabilization implies zero `ε = 0` §7.2 minimax error for any survival query
`survVec K w₀` conditioned on words of length `≤ Fintype.card S - 1`. -/
theorem finite_krylov_zero_minimax_radius {S Act : Type*} [Fintype S] [Nonempty S] [Fintype Act]
    (K : Act → S → S → ℝ) (w₀ : List Act) :
    let F_short : ShortWord S Act → S → ℝ := shortWordQuery K (fun _ => 1)
    let h : S → ℝ := survVec K w₀
    (∃ (b : ℝ) (c : ShortWord S Act → ℝ), dualBound F_short h 0 b c = 0) ∧
    (∃ (μ ν : FinDist S) (b : ℝ) (c : ShortWord S Act → ℝ),
      PrimalFeasible F_short 0 μ ν ∧
      (∀ μ' ν' : FinDist S, PrimalFeasible F_short 0 μ' ν' → primalGap h μ' ν' ≤ primalGap h μ ν) ∧
      (∀ (b' : ℝ) (c' : ShortWord S Act → ℝ), dualBound F_short h 0 b c ≤ dualBound F_short h 0 b' c') ∧
      primalGap h μ ν = 0 ∧ dualBound F_short h 0 b c = 0) := by
  dsimp only
  let F_short : ShortWord S Act → S → ℝ := shortWordQuery K (fun _ => 1)
  let h : S → ℝ := survVec K w₀
  have hk_le_span : krylovSub K (fun _ : S => (1 : ℝ)) (Fintype.card S - 1) ≤
      Submodule.span ℝ (Set.range F_short) := by
    rw [krylovSub, FiniteKrylov.krylovSub, Submodule.span_le]
    rintro v ⟨w, hw, rfl⟩
    have hw_lt : w.length < Fintype.card S := by
      have hpos : 0 < Fintype.card S := Fintype.card_pos
      omega
    let len : Fin (Fintype.card S) := ⟨w.length, hw_lt⟩
    let q : ShortWord S Act := ⟨len, fun i : Fin len.1 => w[i]⟩
    have hword : List.ofFn q.2 = w := by
      apply List.ext_getElem
      · simp [q, len]
      · intro i hi1 hi2
        simp [q]
    have hmem : FiniteKrylov.wordVec K (fun _ => 1) w = F_short q := by
      simp [F_short, shortWordQuery, hword]
    rw [hmem]
    exact Submodule.subset_span ⟨q, rfl⟩
  have hmem_span : h ∈ Submodule.span ℝ (insert (fun _ : S => (1 : ℝ)) (Set.range F_short)) :=
    Submodule.span_mono (Set.subset_insert _ _) (hk_le_span (wordVec_mem_krylovSub_pred K _ w₀))
  obtain ⟨b₀, c₀, hzero0⟩ := (zero_dualBound_iff_affine_span F_short h).mpr hmem_span
  obtain ⟨μ, ν, b, c, hfeas, hpop, hdop, heq⟩ := consequence_minimax_duality F_short h (ε := 0) le_rfl
  have hdle : dualBound F_short h 0 b c ≤ 0 := by
    calc dualBound F_short h 0 b c
        ≤ dualBound F_short h 0 b₀ c₀ := hdop b₀ c₀
      _ = 0 := hzero0
  have hp_nonneg : 0 ≤ primalGap h μ ν := by
    unfold primalGap
    positivity
  have hpeq0 : primalGap h μ ν = 0 := le_antisymm (heq ▸ hdle) hp_nonneg
  have hdeq0 : dualBound F_short h 0 b c = 0 := heq.symm.trans hpeq0
  exact ⟨⟨b₀, c₀, hzero0⟩, ⟨μ, ν, b, c, hfeas, hpop, hdop, hpeq0, hdeq0⟩⟩

end DualityBridges
