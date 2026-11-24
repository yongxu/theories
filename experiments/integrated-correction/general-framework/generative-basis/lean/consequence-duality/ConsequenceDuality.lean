import Mathlib.Analysis.LocallyConvex.Separation
import Mathlib.Analysis.Convex.StdSimplex
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.Tactic
import FiniteProbKrylov

/-!
# Quantitative Consequence Duality, Multi-Query Realizability, & Decision Margins (`ConsequenceDuality`)

AI-written (`Track S2`, 24 November 2026). Self-contained Mathlib periphery module over `ℝ`
compiled with Lean `v4.30.0-rc2` against `~/repos/生生不息`. Every declaration uses only Lean's
three standard axioms (`propext`, `Classical.choice`, `Quot.sound`), with `0` `sorryAx`, `0`
`private` declarations, `0` `lemma`/`class`/unnamed `instance` declarations, and `0` forbidden
market words in declaration names.

This module proves the §7.2 quantitative consequence duality architecture of
`ZETA-AND-THE-FULL-MAP.zh.md`:

1. **Self-contained finite probability & query TV definitions:** `FinDist`, `diracDist`,
   `pushforward`, `tvDist`, `tvDist_pushforward_le`, `massOutside`, `optimal_query_tv_floor`,
   and `empty_source_infeasible`.
2. **§7.2 Finite LP / Polyhedral Consequence Minimax Duality:** Weak duality
   (`primalGap_le_dualBound`) and strong attained equality for ALL `0 ≤ ε` including `ε = 0`
   (`consequence_minimax_duality`), proved via sublinear Hahn–Banach extension
   (`exists_extension_of_le_sublinear`) and finite-dimensional attainment.
3. **Multi-Query Common-History TV Realizability Duality (`common_history_tv_duality`):**
   Weak duality (`multiQueryDualObj_le_multiQueryTvError`) and strong attained minimax duality
   via compact convex Hahn–Banach separation (`geometric_hahn_banach_point_closed`), plus
   corollaries for the 1-query TV floor (`one_query_tv_floor_via_duality`), the `3/5` 2-query
   diagonal separation witness (`two_query_diagonal_three_fifths_witness`), and the `1/2`
   joint-distribution separation witness (`joint_distribution_one_half_witness`).
4. **Finite Decision-Margin Minimax Equality (`decision_margin_minimax`):** Exact equality
   between the best observation-factored policy margin and the worst reachable fiber margin,
   plus `decision_margin_pos_iff_common_action`.
5. **Four Exact Handshake Certificates:** `two_state_exact_minimax`,
   `public_port_vs_recipient_exact`, `b2_aliasing_08_exact_certificate`, and
   `noisy_short_word_amplification`.

What is not shown: empirical transition estimation or finite-sample convergence (`Rule 2`).
-/

namespace ConsequenceDuality

open scoped BigOperators
open Classical

/-! ## Part 1: Finite Probability Laws, Pushforward, TV Distance, & Query Floor -/

/-- Probability distribution on a finite carrier `U` with nonnegative weights summing to `1` (re-exported from `FiniteProb`). -/
abbrev FinDist (U : Type*) [Fintype U] : Type _ := FiniteProb.FinDist U

theorem FinDist.ext {U : Type*} [Fintype U] {p q : FinDist U} (h : ∀ u, p.w u = q.w u) :
    p = q :=
  FiniteProb.FinDist.ext h

/-- Point-mass (Dirac) distribution at `u₀ : U`. -/
noncomputable abbrev diracDist {U : Type*} [Fintype U] [DecidableEq U] (u₀ : U) : FinDist U :=
  FiniteProb.diracDist u₀

/-- Pushforward distribution `f_* p` along any total map `f : U → Y`. -/
noncomputable abbrev pushforward {U Y : Type*} [Fintype U] [Fintype Y]
    (f : U → Y) (p : FinDist U) : FinDist Y :=
  FiniteProb.pushforward f p

theorem pushforward_comp {U Y Z : Type*} [Fintype U] [Fintype Y] [Fintype Z]
    (g : Y → Z) (f : U → Y) (p : FinDist U) :
    pushforward (g ∘ f) p = pushforward g (pushforward f p) :=
  FiniteProb.pushforward_comp g f p

/-- Normalized total variation distance `(1/2) * ∑ y, |μ.w y - ν.w y|` on finite `Y`. -/
noncomputable abbrev tvDist {Y : Type*} [Fintype Y] (μ ν : FinDist Y) : ℝ :=
  FiniteProb.tvDist μ ν

theorem tvDist_nonneg {Y : Type*} [Fintype Y] (μ ν : FinDist Y) : 0 ≤ tvDist μ ν :=
  FiniteProb.tvDist_nonneg μ ν

theorem tvDist_self {Y : Type*} [Fintype Y] (μ : FinDist Y) : tvDist μ μ = 0 :=
  FiniteProb.tvDist_self μ

theorem tvDist_symm {Y : Type*} [Fintype Y] (μ ν : FinDist Y) : tvDist μ ν = tvDist ν μ :=
  FiniteProb.tvDist_symm μ ν

theorem tvDist_triangle {Y : Type*} [Fintype Y] (μ ρ ν : FinDist Y) :
    tvDist μ ν ≤ tvDist μ ρ + tvDist ρ ν :=
  FiniteProb.tvDist_triangle μ ρ ν

/-- Data-processing inequality: post-composing by any total map `g : Y → Z` cannot increase TV distance. -/
theorem tvDist_pushforward_le {Y Z : Type*} [Fintype Y] [Fintype Z]
    (g : Y → Z) (μ ν : FinDist Y) :
    tvDist (pushforward g μ) (pushforward g ν) ≤ tvDist μ ν :=
  FiniteProb.tvDist_pushforward_le g μ ν

/-- Query mass of `lam0` lying outside the image `im(f)` of a total map `f : U → O`. -/
noncomputable abbrev massOutside {U O : Type*} [Fintype U] [Fintype O]
    (f : U → O) (lam0 : FinDist O) : ℝ :=
  FiniteProb.massOutside f lam0

theorem massOutside_nonneg {U O : Type*} [Fintype U] [Fintype O]
    (f : U → O) (lam0 : FinDist O) : 0 ≤ massOutside f lam0 :=
  FiniteProb.massOutside_nonneg f lam0

/-- Exact query-image TV blindness floor (`O1` / `G.1`). -/
theorem optimal_query_tv_floor {U V O : Type*} [Fintype U] [Fintype V] [Fintype O]
    (χ : U → V) (q : V → O) (μ : FinDist V) :
    (∀ ν : FinDist U,
      massOutside (q ∘ χ) (pushforward q μ) ≤ tvDist (pushforward (q ∘ χ) ν) (pushforward q μ)) ∧
    (Nonempty U → ∃ ν : FinDist U,
      tvDist (pushforward (q ∘ χ) ν) (pushforward q μ) = massOutside (q ∘ χ) (pushforward q μ)) :=
  FiniteProb.optimal_query_tv_floor χ q μ

/-- When `U` is empty, `FinDist U` is empty (no local probability law exists). -/
theorem empty_source_infeasible {U : Type*} [Fintype U] (h : IsEmpty U) : IsEmpty (FinDist U) :=
  FiniteProb.empty_source_infeasible h

/-! ## Part 2: §7.2 Finite LP / Polyhedral Consequence Minimax Duality -/

/-- Two source laws `(μ, ν)` are `ε`-compatible with query expectations `F : J → S → ℝ`. -/
def PrimalFeasible {S J : Type*} [Fintype S] (F : J → S → ℝ) (ε : ℝ)
    (μ ν : FinDist S) : Prop :=
  ∀ j : J, |∑ s : S, F j s * (μ.w s - ν.w s)| ≤ 2 * ε

/-- Half the consequence discrepancy between `μ` and `ν` on `h : S → ℝ`. -/
noncomputable def primalGap {S : Type*} [Fintype S] (h : S → ℝ) (μ ν : FinDist S) : ℝ :=
  |∑ s : S, h s * (μ.w s - ν.w s)| / 2

/-- Dual affine-estimator error bound `‖h - b·1 - Fᵀc‖_∞ + ε·‖c‖_1`. -/
noncomputable def dualBound {S J : Type*} [Fintype S] [Nonempty S] [Fintype J]
    (F : J → S → ℝ) (h : S → ℝ) (ε b : ℝ) (c : J → ℝ) : ℝ :=
  (Finset.univ.sup' Finset.univ_nonempty fun s => |h s - b - ∑ j : J, F j s * c j|) +
    ε * ∑ j : J, |c j|

/-- Weak duality for §7.2 consequence minimax: every feasible pair has `primalGap ≤ dualBound`. -/
theorem primalGap_le_dualBound {S J : Type*} [Fintype S] [Nonempty S] [Fintype J]
    (F : J → S → ℝ) (h : S → ℝ) (ε : ℝ) {μ ν : FinDist S}
    (hfeas : PrimalFeasible F ε μ ν) (b : ℝ) (c : J → ℝ) :
    primalGap h μ ν ≤ dualBound F h ε b c := by
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
  have hbound : |∑ s : S, h s * (μ.w s - ν.w s)| ≤ 2 * dualBound F h ε b c := by
    rw [hdecomp]
    calc |(∑ s : S, (h s - b - ∑ j : J, F j s * c j) * (μ.w s - ν.w s)) +
            ∑ j : J, c j * (∑ s : S, F j s * (μ.w s - ν.w s))|
        ≤ |∑ s : S, (h s - b - ∑ j : J, F j s * c j) * (μ.w s - ν.w s)| +
          |∑ j : J, c j * (∑ s : S, F j s * (μ.w s - ν.w s))| := abs_add_le _ _
      _ ≤ (∑ s : S, |(h s - b - ∑ j : J, F j s * c j) * (μ.w s - ν.w s)|) +
          ∑ j : J, |c j * (∑ s : S, F j s * (μ.w s - ν.w s))| :=
          add_le_add (Finset.abs_sum_le_sum_abs _ _) (Finset.abs_sum_le_sum_abs _ _)
      _ ≤ (∑ s : S, R * |μ.w s - ν.w s|) + ∑ j : J, |c j| * (2 * ε) := by
          refine add_le_add (Finset.sum_le_sum fun s _ => ?_) (Finset.sum_le_sum fun j _ => ?_)
          · rw [abs_mul]
            exact mul_le_mul_of_nonneg_right
              (Finset.le_sup' (fun s' => |h s' - b - ∑ j : J, F j s' * c j|) (Finset.mem_univ s))
              (abs_nonneg _)
          · rw [abs_mul]
            exact mul_le_mul_of_nonneg_left (hfeas j) (abs_nonneg _)
      _ = R * (∑ s : S, |μ.w s - ν.w s|) + 2 * (ε * ∑ j : J, |c j|) := by
          rw [← Finset.mul_sum, ← Finset.sum_mul]
          ring
      _ ≤ R * 2 + 2 * (ε * ∑ j : J, |c j|) := by
          gcongr
      _ = 2 * dualBound F h ε b c := by
          dsimp only [R, dualBound]
          ring
  unfold primalGap
  linarith

/-- Continuity of finite `Finset.sup'` over real-valued continuous functions. -/
theorem continuous_finset_sup' {X ι : Type*} [TopologicalSpace X] {s : Finset ι}
    (hs : s.Nonempty) {f : ι → X → ℝ} (hf : ∀ i ∈ s, Continuous (f i)) :
    Continuous fun x => s.sup' hs (fun i => f i x) := by
  induction s using Finset.induction_on with
  | empty => exact absurd hs (Finset.not_nonempty_empty)
  | @insert a s ha ih =>
    by_cases hs' : s.Nonempty
    · have h_eq : (fun x => (insert a s).sup' hs (fun i => f i x)) =
          fun x => max (f a x) (s.sup' hs' (fun i => f i x)) := by
        ext x
        exact Finset.sup'_insert hs' _
      rw [h_eq]
      exact (hf a (Finset.mem_insert_self a s)).max
        (ih hs' fun i hi => hf i (Finset.mem_insert_of_mem hi))
    · rw [Finset.not_nonempty_iff_eq_empty] at hs'
      subst hs'
      simpa using hf a (Finset.mem_insert_self a ∅)

/-- Sup-norm on finite function space `S → ℝ` equals `Finset.univ.sup'`. -/
theorem pi_norm_eq_sup' {S : Type*} [Fintype S] [Nonempty S] (x : S → ℝ) :
    ‖x‖ = Finset.univ.sup' Finset.univ_nonempty (fun s => |x s|) := by
  rw [Pi.norm_def]
  have hnonneg : (0 : ℝ) ≤ Finset.univ.sup' Finset.univ_nonempty (fun s => |x s|) := by
    obtain ⟨s₀⟩ := ‹Nonempty S›
    exact (abs_nonneg _).trans (Finset.le_sup' (fun s => |x s|) (Finset.mem_univ s₀))
  apply le_antisymm
  · rw [← Real.coe_toNNReal (Finset.univ.sup' Finset.univ_nonempty fun s => |x s|) hnonneg]
    refine NNReal.coe_le_coe.mpr (Finset.sup_le fun s _ => ?_)
    rw [← NNReal.coe_le_coe, coe_nnnorm, Real.norm_eq_abs, Real.coe_toNNReal _ hnonneg]
    exact Finset.le_sup' (fun s' => |x s'|) (Finset.mem_univ s)
  · refine Finset.sup'_le _ _ fun s _ => ?_
    rw [← Real.norm_eq_abs]
    exact norm_le_pi_norm x s

/-- Dual minimum attainment for `dualBound` for every `0 ≤ ε`. -/
theorem dualBound_attained {S J : Type*} [Fintype S] [Nonempty S] [Fintype J]
    (F : J → S → ℝ) (h : S → ℝ) {ε : ℝ} (hε : 0 ≤ ε) :
    ∃ (b : ℝ) (c : J → ℝ), ∀ (b' : ℝ) (c' : J → ℝ), dualBound F h ε b c ≤ dualBound F h ε b' c' := by
  rcases hε.eq_or_lt with rfl | hεpos
  · let T₁ : (ℝ × (J → ℝ)) →ₗ[ℝ] (S → ℝ) :=
      { toFun := fun p s => p.1 + ∑ j : J, F j s * p.2 j
        map_add' := fun p q => by
          ext s
          simp only [Pi.add_apply, Prod.fst_add, Prod.snd_add, mul_add, Finset.sum_add_distrib]
          ring
        map_smul' := fun r p => by
          ext s
          simp only [Pi.smul_apply, Prod.smul_fst, Prod.smul_snd, smul_eq_mul, RingHom.id_apply]
          rw [mul_add, Finset.mul_sum]
          refine congrArg (r * p.1 + ·) (Finset.sum_congr rfl fun j _ => by ring) }
    let W₁ : Submodule ℝ (S → ℝ) := LinearMap.range T₁
    have hW₁_closed : IsClosed (W₁ : Set (S → ℝ)) := Submodule.closed_of_finiteDimensional W₁
    let K : Set (S → ℝ) := (W₁ : Set (S → ℝ)) ∩ Metric.closedBall h ‖h‖
    have hK_compact : IsCompact K := (isCompact_closedBall h ‖h‖).inter_left hW₁_closed
    have hK_ne : K.Nonempty := ⟨0, W₁.zero_mem, by simp [Metric.mem_closedBall]⟩
    have hcont : ContinuousOn (fun w : S → ℝ => ‖h - w‖) K :=
      (continuous_const.sub continuous_id).norm.continuousOn
    obtain ⟨w, hwK, hwMin⟩ := hK_compact.exists_isMinOn hK_ne hcont
    obtain ⟨⟨b, c⟩, hbc⟩ := hwK.1
    refine ⟨b, c, fun b' c' => ?_⟩
    have hdb : ∀ b'' c'', dualBound F h 0 b'' c'' = ‖h - T₁ (b'', c'')‖ := by
      intro b'' c''
      unfold dualBound
      rw [zero_mul, add_zero, pi_norm_eq_sup']
      congr 1
      ext s
      simp [T₁, sub_sub]
    rw [hdb b c, hdb b' c', hbc]
    by_cases hball : T₁ (b', c') ∈ Metric.closedBall h ‖h‖
    · exact hwMin ⟨LinearMap.mem_range_self T₁ (b', c'), hball⟩
    · rw [Metric.mem_closedBall, dist_eq_norm, norm_sub_rev] at hball
      have hlt : ‖h‖ < ‖h - T₁ (b', c')‖ := not_le.mp hball
      have h0 : ‖h - w‖ ≤ ‖h - 0‖ := hwMin ⟨W₁.zero_mem, by simp [Metric.mem_closedBall]⟩
      rw [sub_zero] at h0
      exact h0.trans hlt.le
  · let R : ℝ := dualBound F h ε 0 0
    have hR_nonneg : 0 ≤ R := by
      obtain ⟨s₀⟩ := ‹Nonempty S›
      dsimp only [R, dualBound]
      exact add_nonneg
        ((abs_nonneg _).trans (Finset.le_sup' (fun s => |h s - 0 - ∑ j : J, F j s * 0|) (Finset.mem_univ s₀)))
        (mul_nonneg hεpos.le (Finset.sum_nonneg fun j _ => abs_nonneg _))
    obtain ⟨s₀⟩ := ‹Nonempty S›
    let C₀ : ℝ := R / ε
    let B₀ : ℝ := R + |h s₀| + C₀ * ∑ j : J, |F j s₀|
    have hC₀_nonneg : 0 ≤ C₀ := div_nonneg hR_nonneg hεpos.le
    have hB₀_nonneg : 0 ≤ B₀ := add_nonneg (add_nonneg hR_nonneg (abs_nonneg _))
      (mul_nonneg hC₀_nonneg (Finset.sum_nonneg fun j _ => abs_nonneg _))
    let K : Set (ℝ × (J → ℝ)) :=
      Set.Icc (-B₀) B₀ ×ˢ Set.pi Set.univ (fun _ => Set.Icc (-C₀) C₀)
    have hK_compact : IsCompact K :=
      isCompact_Icc.prod (isCompact_univ_pi fun _ => isCompact_Icc)
    have h0mem : ((0 : ℝ), (0 : J → ℝ)) ∈ K :=
      ⟨⟨by linarith, hB₀_nonneg⟩, fun _ _ => ⟨by simp; linarith, by simp; exact hC₀_nonneg⟩⟩
    have hK_ne : K.Nonempty := ⟨(0, 0), h0mem⟩
    let obj : (ℝ × (J → ℝ)) → ℝ := fun p => dualBound F h ε p.1 p.2
    have hcont : Continuous obj := by
      unfold obj dualBound
      refine Continuous.add ?_ ?_
      · refine continuous_finset_sup' Finset.univ_nonempty fun s _ => ?_
        refine Continuous.abs ?_
        refine ((continuous_const.sub continuous_fst).sub ?_)
        exact continuous_finsetSum Finset.univ fun j _ =>
          continuous_const.mul ((continuous_apply j).comp continuous_snd)
      · exact continuous_const.mul (continuous_finsetSum Finset.univ fun j _ =>
          ((continuous_apply j).comp continuous_snd).abs)
    obtain ⟨⟨b, c⟩, _, hmin⟩ := hK_compact.exists_isMinOn hK_ne hcont.continuousOn
    refine ⟨b, c, fun b' c' => ?_⟩
    by_cases hmem : (b', c') ∈ K
    · exact hmin hmem
    · have hleR : dualBound F h ε b c ≤ R := by
        have h0 : obj (b, c) ≤ obj (0, 0) := hmin h0mem
        exact h0
      have hR_le : R ≤ dualBound F h ε b' c' := by
        by_cases hc : ∀ j : J, |c' j| ≤ C₀
        · have hb : B₀ < |b'| := by
            by_contra hle
            push Not at hle
            exact hmem ⟨abs_le.mp hle, fun j _ => abs_le.mp (hc j)⟩
          have htri : |b'| ≤ |h s₀ - b' - ∑ j : J, F j s₀ * c' j| + |h s₀| + ∑ j : J, |F j s₀| * |c' j| := by
            have h1 : b' = (h s₀ - (h s₀ - b' - ∑ j : J, F j s₀ * c' j)) + (-(∑ j : J, F j s₀ * c' j)) := by ring
            calc |b'|
                = |(h s₀ - (h s₀ - b' - ∑ j : J, F j s₀ * c' j)) + (-(∑ j : J, F j s₀ * c' j))| :=
                  congrArg abs h1
              _ ≤ |h s₀ - (h s₀ - b' - ∑ j : J, F j s₀ * c' j)| + |-(∑ j : J, F j s₀ * c' j)| := abs_add_le _ _
              _ ≤ (|h s₀| + |h s₀ - b' - ∑ j : J, F j s₀ * c' j|) + ∑ j : J, |F j s₀ * c' j| := by
                  rw [abs_neg]
                  exact add_le_add (abs_sub _ _) (Finset.abs_sum_le_sum_abs _ _)
              _ = |h s₀ - b' - ∑ j : J, F j s₀ * c' j| + |h s₀| + ∑ j : J, |F j s₀| * |c' j| := by
                  simp_rw [abs_mul]
                  ring
          have hsumc : ∑ j : J, |F j s₀| * |c' j| ≤ C₀ * ∑ j : J, |F j s₀| := by
            rw [Finset.mul_sum]
            refine Finset.sum_le_sum fun j _ => ?_
            rw [mul_comm C₀]
            exact mul_le_mul_of_nonneg_left (hc j) (abs_nonneg _)
          have hsup : |h s₀ - b' - ∑ j : J, F j s₀ * c' j| ≤
              Finset.univ.sup' Finset.univ_nonempty fun s => |h s - b' - ∑ j : J, F j s * c' j| :=
            Finset.le_sup' (fun s => |h s - b' - ∑ j : J, F j s * c' j|) (Finset.mem_univ s₀)
          have hnonneg_tail : 0 ≤ ε * ∑ j : J, |c' j| :=
            mul_nonneg hεpos.le (Finset.sum_nonneg fun j _ => abs_nonneg _)
          unfold dualBound
          dsimp only [B₀] at hb
          linarith
        · push Not at hc
          obtain ⟨j₀, hj₀⟩ := hc
          have hj₀_le : |c' j₀| ≤ ∑ j : J, |c' j| :=
            Finset.single_le_sum (fun j _ => abs_nonneg (c' j)) (Finset.mem_univ j₀)
          have h1 : R < ε * ∑ j : J, |c' j| := by
            have hmul : C₀ * ε < |c' j₀| * ε := mul_lt_mul_of_pos_right hj₀ hεpos
            rw [div_mul_cancel₀ _ hεpos.ne', mul_comm] at hmul
            exact hmul.trans_le (mul_le_mul_of_nonneg_left hj₀_le hεpos.le)
          have hsup_nn : 0 ≤ Finset.univ.sup' Finset.univ_nonempty fun s => |h s - b' - ∑ j : J, F j s * c' j| :=
            (abs_nonneg _).trans (Finset.le_sup' (fun s => |h s - b' - ∑ j : J, F j s * c' j|)
              (Finset.mem_univ s₀))
          unfold dualBound
          linarith
      exact hleR.trans hR_le

/-- Convert a zero-sum vector `d : S → ℝ` with `∑ s, |d s| ≤ 1` into `μ - ν = 2 * d`. -/
theorem finDistPair_of_zeroSum_l1Le {S : Type*} [Fintype S] [Nonempty S]
    (d : S → ℝ) (hd_sum : ∑ s : S, d s = 0) (hd_l1 : ∑ s : S, |d s| ≤ 1) :
    ∃ μ ν : FinDist S, ∀ s : S, μ.w s - ν.w s = 2 * d s := by
  obtain ⟨s₀⟩ := ‹Nonempty S›
  let pos : S → ℝ := fun s => max (d s) 0
  let neg : S → ℝ := fun s => max (-d s) 0
  let m : ℝ := ∑ s : S, pos s
  have hdiff : ∀ s : S, pos s - neg s = d s := fun s => by
    dsimp only [pos, neg]
    rcases le_total 0 (d s) with h | h
    · rw [max_eq_left h, max_eq_right (by linarith), sub_zero]
    · rw [max_eq_right h, max_eq_left (by linarith), zero_sub, neg_neg]
  have hsum_abs : ∀ s : S, pos s + neg s = |d s| := fun s => by
    dsimp only [pos, neg]
    rcases le_total 0 (d s) with h | h
    · rw [abs_of_nonneg h, max_eq_left h, max_eq_right (by linarith), add_zero]
    · rw [abs_of_nonpos h, max_eq_right h, max_eq_left (by linarith), zero_add]
  have hneg_sum : ∑ s : S, neg s = m := by
    have h0 : ∑ s : S, (pos s - neg s) = 0 := by
      simpa [hdiff] using hd_sum
    rw [Finset.sum_sub_distrib] at h0
    linarith
  have hm_le : 2 * m ≤ 1 := by
    have h2 : m + ∑ s : S, neg s = ∑ s : S, (pos s + neg s) := by
      rw [Finset.sum_add_distrib]
    rw [hneg_sum] at h2
    have h3 : ∑ s : S, (pos s + neg s) = ∑ s : S, |d s| :=
      Finset.sum_congr rfl fun s _ => hsum_abs s
    linarith
  have hrem : 0 ≤ 1 - 2 * m := by linarith
  let μ : FinDist S :=
    { w := fun s => 2 * pos s + if s = s₀ then 1 - 2 * m else 0
      nonneg := fun s => add_nonneg (mul_nonneg (by norm_num) (le_max_right _ _))
        (by split_ifs <;> [exact hrem; exact le_rfl])
      sum_eq_one := by
        rw [Finset.sum_add_distrib, ← Finset.mul_sum]
        simp [m] }
  let ν : FinDist S :=
    { w := fun s => 2 * neg s + if s = s₀ then 1 - 2 * m else 0
      nonneg := fun s => add_nonneg (mul_nonneg (by norm_num) (le_max_right _ _))
        (by split_ifs <;> [exact hrem; exact le_rfl])
      sum_eq_one := by
        rw [Finset.sum_add_distrib, ← Finset.mul_sum, hneg_sum]
        simp }
  refine ⟨μ, ν, fun s => ?_⟩
  dsimp only [μ, ν]
  have h1 := hdiff s
  linarith

/-- **§7.2 Strong Consequence Minimax Duality (Attained for ALL `0 ≤ ε`, including `ε = 0`):**
The maximum half-consequence gap among `ε`-compatible distribution pairs equals the minimum
worst-case affine reconstruction error `dualBound`. -/
theorem consequence_minimax_duality {S J : Type*} [Fintype S] [Nonempty S] [Fintype J]
    (F : J → S → ℝ) (h : S → ℝ) {ε : ℝ} (hε : 0 ≤ ε) :
    ∃ (μ ν : FinDist S) (b : ℝ) (c : J → ℝ),
      PrimalFeasible F ε μ ν ∧
      (∀ μ' ν' : FinDist S, PrimalFeasible F ε μ' ν' → primalGap h μ' ν' ≤ primalGap h μ ν) ∧
      (∀ (b' : ℝ) (c' : J → ℝ), dualBound F h ε b c ≤ dualBound F h ε b' c') ∧
      primalGap h μ ν = dualBound F h ε b c := by
  obtain ⟨b, c, hmin⟩ := dualBound_attained F h hε
  let ρ : ℝ := dualBound F h ε b c
  obtain ⟨s₀⟩ := ‹Nonempty S›
  have hρ_nonneg : 0 ≤ ρ := by
    dsimp only [ρ, dualBound]
    exact add_nonneg
      ((abs_nonneg _).trans (Finset.le_sup' (fun s => |h s - b - ∑ j : J, F j s * c j|)
        (Finset.mem_univ s₀)))
      (mul_nonneg hε (Finset.sum_nonneg fun j _ => abs_nonneg _))
  rcases hρ_nonneg.eq_or_lt with hρ0 | hρpos
  · let μ := diracDist s₀
    have hfeas : PrimalFeasible F ε μ μ := fun j => by
      simp [sub_self]
      linarith
    have hgap0 : primalGap h μ μ = 0 := by simp [primalGap]
    have heq : primalGap h μ μ = dualBound F h ε b c := by rw [hgap0, hρ0]
    exact ⟨μ, μ, b, c, hfeas,
      fun μ' ν' hfeas' => (primalGap_le_dualBound F h ε hfeas' b c).trans heq.symm.le,
      hmin, heq⟩
  · let E := (S → ℝ) × (J → ℝ)
    let N : E → ℝ := fun p =>
      (Finset.univ.sup' Finset.univ_nonempty fun s => |p.1 s|) + ε * ∑ j : J, |p.2 j|
    have hN_nonneg : ∀ p : E, 0 ≤ N p := fun p =>
      add_nonneg ((abs_nonneg _).trans (Finset.le_sup' (fun s => |p.1 s|) (Finset.mem_univ s₀)))
        (mul_nonneg hε (Finset.sum_nonneg fun j _ => abs_nonneg _))
    have hN_hom : ∀ (t : ℝ), 0 < t → ∀ p : E, N (t • p) = t * N p := by
      intro t ht p
      have hsup : (Finset.univ.sup' Finset.univ_nonempty fun s => |(t • p).1 s|) =
          t * Finset.univ.sup' Finset.univ_nonempty fun s => |p.1 s| := by
        apply le_antisymm
        · refine Finset.sup'_le _ _ fun s _ => ?_
          change |t * p.1 s| ≤ _
          rw [abs_mul, abs_of_pos ht]
          exact mul_le_mul_of_nonneg_left (Finset.le_sup' (fun s' => |p.1 s'|) (Finset.mem_univ s)) ht.le
        · obtain ⟨sm, _, hsm⟩ := Finset.exists_mem_eq_sup' Finset.univ_nonempty (fun s => |p.1 s|)
          have hrew : t * |p.1 sm| = |(t • p).1 sm| := by
            change t * |p.1 sm| = |t * p.1 sm|
            rw [abs_mul, abs_of_pos ht]
          rw [hsm, hrew]
          exact Finset.le_sup' (fun s => |(t • p).1 s|) (Finset.mem_univ sm)
      have hsum : (∑ j : J, |(t • p).2 j|) = t * ∑ j : J, |p.2 j| := by
        rw [Finset.mul_sum]
        refine Finset.sum_congr rfl fun j _ => ?_
        change |t * p.2 j| = t * |p.2 j|
        rw [abs_mul, abs_of_pos ht]
      change (Finset.univ.sup' Finset.univ_nonempty fun s => |(t • p).1 s|) + ε * ∑ j : J, |(t • p).2 j| =
          t * ((Finset.univ.sup' Finset.univ_nonempty fun s => |p.1 s|) + ε * ∑ j : J, |p.2 j|)
      rw [hsup, hsum]
      ring
    have hN_add : ∀ p q : E, N (p + q) ≤ N p + N q := by
      intro p q
      have hsup : (Finset.univ.sup' Finset.univ_nonempty fun s => |(p + q).1 s|) ≤
          (Finset.univ.sup' Finset.univ_nonempty fun s => |p.1 s|) +
          (Finset.univ.sup' Finset.univ_nonempty fun s => |q.1 s|) := by
        refine Finset.sup'_le _ _ fun s _ => ?_
        change |p.1 s + q.1 s| ≤ _
        exact (abs_add_le _ _).trans (add_le_add
          (Finset.le_sup' (fun s' => |p.1 s'|) (Finset.mem_univ s))
          (Finset.le_sup' (fun s' => |q.1 s'|) (Finset.mem_univ s)))
      have hsum : ε * ∑ j : J, |(p + q).2 j| ≤ ε * ∑ j : J, |p.2 j| + ε * ∑ j : J, |q.2 j| := by
        rw [← mul_add, ← Finset.sum_add_distrib]
        refine mul_le_mul_of_nonneg_left (Finset.sum_le_sum fun j _ => ?_) hε
        change |p.2 j + q.2 j| ≤ |p.2 j| + |q.2 j|
        exact abs_add_le _ _
      change (Finset.univ.sup' Finset.univ_nonempty fun s => |(p + q).1 s|) + ε * ∑ j : J, |(p + q).2 j| ≤
          ((Finset.univ.sup' Finset.univ_nonempty fun s => |p.1 s|) + ε * ∑ j : J, |p.2 j|) +
          ((Finset.univ.sup' Finset.univ_nonempty fun s => |q.1 s|) + ε * ∑ j : J, |q.2 j|)
      linarith
    let T : (ℝ × (J → ℝ)) →ₗ[ℝ] E :=
      { toFun := fun q => (fun s => q.1 + ∑ j : J, F j s * q.2 j, fun j => -q.2 j)
        map_add' := fun q₁ q₂ => by
          ext s
          · change (q₁.1 + q₂.1) + ∑ j : J, F j s * (q₁.2 j + q₂.2 j) =
                (q₁.1 + ∑ j : J, F j s * q₁.2 j) + (q₂.1 + ∑ j : J, F j s * q₂.2 j)
            simp only [mul_add, Finset.sum_add_distrib]
            ring
          · change -(q₁.2 s + q₂.2 s) = -q₁.2 s + -q₂.2 s
            ring
        map_smul' := fun r q => by
          ext s
          · change (r * q.1) + ∑ j : J, F j s * (r * q.2 j) =
                r * (q.1 + ∑ j : J, F j s * q.2 j)
            rw [mul_add, Finset.mul_sum]
            refine congrArg (r * q.1 + ·) (Finset.sum_congr rfl fun j _ => by ring)
          · change -(r * q.2 s) = r * (-q.2 s)
            ring }
    let W : Submodule ℝ E := LinearMap.range T
    let p₀ : E := (h, 0)
    have hp₀_notMem : p₀ ∉ W := by
      rintro ⟨⟨b', c'⟩, hbc'⟩
      have hc' : c' = 0 := by
        ext j
        have h2 := congrArg (fun p : E => p.2 j) hbc'
        simp only [T, p₀, LinearMap.coe_mk, AddHom.coe_mk, Pi.zero_apply] at h2
        change c' j = 0
        linarith
      have hh' : ∀ s : S, h s - b' - ∑ j : J, F j s * c' j = 0 := by
        intro s
        have h1 := congrArg (fun p : E => p.1 s) hbc'
        simp only [T, p₀, LinearMap.coe_mk, AddHom.coe_mk] at h1
        linarith
      have hzero : dualBound F h ε b' c' = 0 := by
        unfold dualBound
        have hsup0 : (Finset.univ.sup' Finset.univ_nonempty fun s => |h s - b' - ∑ j : J, F j s * c' j|) = 0 := by
          apply le_antisymm
          · exact Finset.sup'_le _ _ fun s _ => by rw [hh' s, abs_zero]
          · exact (abs_nonneg _).trans (Finset.le_sup' (fun s => |h s - b' - ∑ j : J, F j s * c' j|)
              (Finset.mem_univ s₀))
        rw [hsup0, hc']
        simp
      linarith [hmin b' c']
    let f₀ : E →ₗ.[ℝ] ℝ := (0 : E →ₗ[ℝ] ℝ).toPMap W
    let f : E →ₗ.[ℝ] ℝ := f₀.supSpanSingleton p₀ ρ hp₀_notMem
    have hf_le : ∀ x : f.domain, f x ≤ N x := by
      rintro ⟨x, hx⟩
      have hx' : x ∈ W ⊔ Submodule.span ℝ {p₀} := hx
      rcases Submodule.mem_sup.1 hx' with ⟨w, hw, y, hy, rfl⟩
      rcases Submodule.mem_span_singleton.1 hy with ⟨t, rfl⟩
      have hval : f ⟨w + t • p₀, hx⟩ = t * ρ := by
        dsimp only [f]
        have happly := LinearPMap.supSpanSingleton_apply_mk f₀ p₀ ρ hp₀_notMem w hw t
        have hzero : f₀ ⟨w, hw⟩ = 0 := rfl
        simpa [hzero] using happly
      rw [hval]
      rcases le_or_gt t 0 with ht | ht
      · exact (mul_nonpos_of_nonpos_of_nonneg ht hρ_nonneg).trans (hN_nonneg _)
      · obtain ⟨⟨b', c'⟩, hbc'⟩ := hw
        have hN_eq : N (w + t • p₀) = t * dualBound F h ε (-t⁻¹ * b') (-t⁻¹ • c') := by
          have hscale : w + t • p₀ = t • (p₀ - T (-t⁻¹ * b', -t⁻¹ • c')) := by
            ext s
            · have hs := congrArg (fun p : E => p.1 s) hbc'
              change w.1 s + t * h s =
                  t * (h s - (-t⁻¹ * b' + ∑ j : J, F j s * (-t⁻¹ * c' j)))
              have hs' : b' + ∑ j : J, F j s * c' j = w.1 s := hs
              rw [← hs', mul_sub, mul_add, Finset.mul_sum]
              have hsum_eq : ∑ j : J, t * (F j s * (-t⁻¹ * c' j)) = -∑ j : J, F j s * c' j := by
                rw [← Finset.sum_neg_distrib]
                refine Finset.sum_congr rfl fun j _ => ?_
                field_simp [ht.ne']
              rw [hsum_eq]
              have htb : t * (-t⁻¹ * b') = -b' := by field_simp [ht.ne']
              rw [htb]
              ring
            · have hj := congrArg (fun p : E => p.2 s) hbc'
              change w.2 s + t * (0 : ℝ) = t * (0 - (-(-t⁻¹ * c' s)))
              have hj' : -c' s = w.2 s := hj
              rw [← hj']
              field_simp [ht.ne']
              ring
          rw [hscale, hN_hom t ht]
          congr 1
          dsimp only [N, dualBound]
          congr 1
          · congr 1
            ext s
            change |h s - (-t⁻¹ * b' + ∑ j : J, F j s * (-t⁻¹ * c' j))| =
                |h s - (-t⁻¹ * b') - ∑ j : J, F j s * (-t⁻¹ * c' j)|
            exact congrArg abs (by ring)
          · congr 1
            refine Finset.sum_congr rfl fun j _ => ?_
            have hj2 : (p₀ - T (-t⁻¹ * b', -t⁻¹ • c')).2 j = (-t⁻¹ • c') j := by
              change (0 : ℝ) - (-((-t⁻¹ • c') j)) = (-t⁻¹ • c') j
              ring
            exact congrArg abs hj2
        rw [hN_eq]
        exact mul_le_mul_of_nonneg_left (hmin (-t⁻¹ * b') (-t⁻¹ • c')) ht.le
    obtain ⟨g, hg_eq, hg_le⟩ := exists_extension_of_le_sublinear f N hN_hom hN_add hf_le
    let d : S → ℝ := fun s => g (Pi.single s 1, 0)
    let q : J → ℝ := fun j => g (0, Pi.single j 1)
    have hg_decomp : ∀ (x : S → ℝ) (y : J → ℝ), g (x, y) = (∑ s : S, x s * d s) + ∑ j : J, y j * q j := by
      intro x y
      have hxy : (x, y) = (∑ s : S, x s • (Pi.single s (1 : ℝ), (0 : J → ℝ))) +
          ∑ j : J, y j • ((0 : S → ℝ), Pi.single j (1 : ℝ)) := by
        ext s
        · simp [Prod.fst_sum, Pi.single_apply]
        · simp [Prod.snd_sum, Pi.single_apply]
      conv_lhs => rw [hxy]
      simp only [map_add, map_sum, LinearMap.map_smul, smul_eq_mul, d, q]
    have hg_W : ∀ (b' : ℝ) (c' : J → ℝ), g (T (b', c')) = 0 := by
      intro b' c'
      have hmemW : T (b', c') ∈ f.domain := by
        change T (b', c') ∈ W ⊔ Submodule.span ℝ {p₀}
        exact Submodule.mem_sup_left (LinearMap.mem_range_self T (b', c'))
      rw [hg_eq ⟨T (b', c'), hmemW⟩]
      have happly := LinearPMap.supSpanSingleton_apply_mk f₀ p₀ ρ hp₀_notMem (T (b', c'))
        (LinearMap.mem_range_self T (b', c')) 0
      simpa [f, f₀] using happly
    have hd_sum : ∑ s : S, d s = 0 := by
      have h0 := hg_W 1 0
      rw [hg_decomp] at h0
      simpa [T] using h0
    have hq_eq : ∀ j : J, q j = ∑ s : S, F j s * d s := by
      intro j
      have h0 := hg_W 0 (Pi.single j 1)
      rw [hg_decomp] at h0
      have h1 : (∑ s : S, (0 + ∑ j' : J, F j' s * (Pi.single j (1 : ℝ) : J → ℝ) j') * d s) +
          ∑ j' : J, (-(Pi.single j (1 : ℝ) : J → ℝ) j') * q j' = 0 := by simpa [T] using h0
      have h2 : (∑ s : S, (0 + ∑ j' : J, F j' s * (Pi.single j (1 : ℝ) : J → ℝ) j') * d s) =
          ∑ s : S, F j s * d s := by
        refine Finset.sum_congr rfl fun s _ => ?_
        simp [Pi.single_apply]
      have h3 : (∑ j' : J, (-(Pi.single j (1 : ℝ) : J → ℝ) j') * q j') = -q j := by
        simp [Pi.single_apply]
      linarith
    have hd_l1 : ∑ s : S, |d s| ≤ 1 := by
      let x : S → ℝ := fun s => if 0 ≤ d s then 1 else -1
      have hle := hg_le (x, 0)
      rw [hg_decomp] at hle
      have hsumx : ∑ s : S, x s * d s = ∑ s : S, |d s| :=
        Finset.sum_congr rfl fun s _ => by
          dsimp only [x]
          split_ifs with hs
          · rw [one_mul, abs_of_nonneg hs]
          · rw [neg_one_mul, abs_of_neg (not_le.mp hs)]
      have hNx : N (x, 0) = 1 := by
        dsimp only [N]
        have hsupx : (Finset.univ.sup' Finset.univ_nonempty fun s => |x s|) = 1 := by
          apply le_antisymm
          · exact Finset.sup'_le _ _ fun s _ => by dsimp only [x]; split_ifs <;> norm_num
          · calc (1 : ℝ) = |x s₀| := by dsimp only [x]; split_ifs <;> norm_num
              _ ≤ _ := Finset.le_sup' (fun s => |x s|) (Finset.mem_univ s₀)
        rw [hsupx]
        simp
      simp only [Pi.zero_apply, zero_mul, Finset.sum_const_zero, add_zero] at hle
      linarith
    have hq_le : ∀ j : J, |q j| ≤ ε := by
      intro j
      let y : J → ℝ := Pi.single j (if 0 ≤ q j then 1 else -1)
      have hle := hg_le (0, y)
      rw [hg_decomp] at hle
      have hsumy : ∑ j' : J, y j' * q j' = |q j| := by
        have h1 : ∑ j' : J, y j' * q j' = (if 0 ≤ q j then 1 else -1) * q j := by
          dsimp only [y]
          simp [Pi.single_apply]
        rw [h1]
        split_ifs with hqj
        · rw [one_mul, abs_of_nonneg hqj]
        · rw [neg_one_mul, abs_of_neg (not_le.mp hqj)]
      have hNy : N (0, y) = ε := by
        dsimp only [N]
        have hsup0 : (Finset.univ.sup' Finset.univ_nonempty fun s : S => |(0 : S → ℝ) s|) = 0 := by
          simp
        have hsumabs : ∑ j' : J, |y j'| = 1 := by
          have h1 : ∀ j' : J, |y j'| = if j' = j then 1 else 0 := fun j' => by
            dsimp only [y]
            by_cases hjj : j' = j
            · subst hjj; simp; split_ifs <;> norm_num
            · simp [hjj]
          simp [h1]
        rw [hsup0, zero_add, hsumabs, mul_one]
      simp only [Pi.zero_apply, zero_mul, Finset.sum_const_zero, zero_add] at hle
      linarith
    have hh_eq : ∑ s : S, h s * d s = ρ := by
      have hp₀_mem : p₀ ∈ f.domain := by
        change p₀ ∈ W ⊔ Submodule.span ℝ {p₀}
        exact Submodule.mem_sup_right (Submodule.mem_span_singleton_self p₀)
      have hgp₀ := hg_eq ⟨p₀, hp₀_mem⟩
      have hfp₀ : f ⟨p₀, hp₀_mem⟩ = ρ := by
        dsimp only [f]
        have happly := LinearPMap.supSpanSingleton_apply_mk f₀ p₀ ρ hp₀_notMem 0 W.zero_mem 1
        simpa [f₀] using happly
      rw [hg_decomp] at hgp₀
      simpa [p₀, hfp₀] using hgp₀
    obtain ⟨μ, ν, hμν⟩ := finDistPair_of_zeroSum_l1Le d hd_sum hd_l1
    have hfeas : PrimalFeasible F ε μ ν := by
      intro j
      have h1 : ∑ s : S, F j s * (μ.w s - ν.w s) = 2 * q j := by
        rw [hq_eq j, Finset.mul_sum]
        refine Finset.sum_congr rfl fun s _ => ?_
        rw [hμν s]
        ring
      rw [h1, abs_mul, abs_of_nonneg (by norm_num)]
      exact mul_le_mul_of_nonneg_left (hq_le j) (by norm_num)
    have hgap : primalGap h μ ν = ρ := by
      unfold primalGap
      have h1 : ∑ s : S, h s * (μ.w s - ν.w s) = 2 * ρ := by
        rw [← hh_eq, Finset.mul_sum]
        refine Finset.sum_congr rfl fun s _ => ?_
        rw [hμν s]
        ring
      rw [h1, abs_mul, abs_of_nonneg (by norm_num), abs_of_pos hρpos]
      ring
    exact ⟨μ, ν, b, c, hfeas,
      fun μ' ν' hfeas' => (primalGap_le_dualBound F h ε hfeas' b c).trans hgap.symm.le,
      hmin, hgap⟩

/-! ## Part 3: Client 2 — Multi-Query Common-History TV Realizability Duality -/

/-- Total query TV discrepancy of a single common source distribution `ν` across queries `f i`. -/
noncomputable def multiQueryTvError {I U : Type*} [Fintype I] [Fintype U] {O : I → Type*}
    [∀ i, Fintype (O i)] (f : (i : I) → U → O i) (lamq : (i : I) → FinDist (O i))
    (ν : FinDist U) : ℝ :=
  ∑ i : I, tvDist (pushforward (f i) ν) (lamq i)

/-- Dual witness objective on `[0, 1]`-valued test functions `test : ∀ i, O i → Set.Icc 0 1`. -/
noncomputable def multiQueryDualObj {I U : Type*} [Fintype I] [Fintype U] [Nonempty U]
    {O : I → Type*} [∀ i, Fintype (O i)] (f : (i : I) → U → O i) (lamq : (i : I) → FinDist (O i))
    (test : ∀ i : I, O i → Set.Icc (0 : ℝ) 1) : ℝ :=
  (∑ i : I, ∑ o : O i, (lamq i).w o * (test i o).1) -
    Finset.univ.sup' Finset.univ_nonempty (fun u : U => ∑ i : I, (test i (f i u)).1)

/-- Weak duality for multi-query TV realizability. -/
theorem multiQueryDualObj_le_multiQueryTvError {I U : Type*} [Fintype I] [Fintype U] [Nonempty U]
    {O : I → Type*} [∀ i, Fintype (O i)] (f : (i : I) → U → O i) (lamq : (i : I) → FinDist (O i))
    (ν : FinDist U) (test : ∀ i : I, O i → Set.Icc (0 : ℝ) 1) :
    multiQueryDualObj f lamq test ≤ multiQueryTvError f lamq ν := by
  have h1 : ∀ i : I,
      ∑ o : O i, ((lamq i).w o - (pushforward (f i) ν).w o) * (test i o).1 ≤
      tvDist (pushforward (f i) ν) (lamq i) := by
    intro i
    have hzero : ∑ o : O i, ((lamq i).w o - (pushforward (f i) ν).w o) * (1 / 2 : ℝ) = 0 := by
      rw [← Finset.sum_mul, Finset.sum_sub_distrib, (lamq i).sum_eq_one, (pushforward (f i) ν).sum_eq_one,
        sub_self, zero_mul]
    have hshift : (∑ o : O i, ((lamq i).w o - (pushforward (f i) ν).w o) * (test i o).1) =
        ∑ o : O i, ((lamq i).w o - (pushforward (f i) ν).w o) * ((test i o).1 - 1 / 2) := by
      have hsub : (∑ o : O i, ((lamq i).w o - (pushforward (f i) ν).w o) * ((test i o).1 - 1 / 2)) =
          (∑ o : O i, ((lamq i).w o - (pushforward (f i) ν).w o) * (test i o).1) -
          (∑ o : O i, ((lamq i).w o - (pushforward (f i) ν).w o) * (1 / 2 : ℝ)) := by
        rw [← Finset.sum_sub_distrib]
        refine Finset.sum_congr rfl fun o _ => by ring
      linarith
    rw [hshift]
    calc ∑ o : O i, ((lamq i).w o - (pushforward (f i) ν).w o) * ((test i o).1 - 1 / 2)
        ≤ ∑ o : O i, |((lamq i).w o - (pushforward (f i) ν).w o) * ((test i o).1 - 1 / 2)| :=
          Finset.sum_le_sum fun o _ => le_abs_self _
      _ ≤ ∑ o : O i, |(pushforward (f i) ν).w o - (lamq i).w o| * (1 / 2 : ℝ) := by
          refine Finset.sum_le_sum fun o _ => ?_
          rw [abs_mul, abs_sub_comm ((lamq i).w o)]
          exact mul_le_mul_of_nonneg_left (abs_le.2 ⟨by linarith [(test i o).2.1],
            by linarith [(test i o).2.2]⟩) (abs_nonneg _)
      _ = tvDist (pushforward (f i) ν) (lamq i) := by
          rw [← Finset.sum_mul, tvDist, FiniteProb.tvDist]
          ring
  have hpush : ∑ i : I, ∑ o : O i, (pushforward (f i) ν).w o * (test i o).1 ≤
      Finset.univ.sup' Finset.univ_nonempty (fun u : U => ∑ i : I, (test i (f i u)).1) := by
    have heq : (∑ i : I, ∑ o : O i, (pushforward (f i) ν).w o * (test i o).1) =
        ∑ u : U, ν.w u * (∑ i : I, (test i (f i u)).1) := by
      calc ∑ i : I, ∑ o : O i, (∑ u : U, if f i u = o then ν.w u else 0) * (test i o).1
          = ∑ i : I, ∑ o : O i, ∑ u : U, (if f i u = o then ν.w u * (test i o).1 else 0) := by
            refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun o _ => ?_
            rw [Finset.sum_mul]
            exact Finset.sum_congr rfl fun u _ => by split_ifs <;> ring
        _ = ∑ i : I, ∑ u : U, ∑ o : O i, (if f i u = o then ν.w u * (test i o).1 else 0) := by
            refine Finset.sum_congr rfl fun i _ => Finset.sum_comm
        _ = ∑ i : I, ∑ u : U, ν.w u * (test i (f i u)).1 := by
            refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun u _ => by simp
        _ = ∑ u : U, ∑ i : I, ν.w u * (test i (f i u)).1 := Finset.sum_comm
        _ = ∑ u : U, ν.w u * ∑ i : I, (test i (f i u)).1 := by
            refine Finset.sum_congr rfl fun u _ => (Finset.mul_sum _ _ _).symm
    rw [heq]
    calc ∑ u : U, ν.w u * (∑ i : I, (test i (f i u)).1)
        ≤ ∑ u : U, ν.w u * Finset.univ.sup' Finset.univ_nonempty (fun u' : U => ∑ i : I, (test i (f i u')).1) :=
          Finset.sum_le_sum fun u _ => mul_le_mul_of_nonneg_left
            (Finset.le_sup' (fun u' : U => ∑ i : I, (test i (f i u')).1) (Finset.mem_univ u)) (ν.nonneg u)
      _ = Finset.univ.sup' Finset.univ_nonempty (fun u' : U => ∑ i : I, (test i (f i u')).1) := by
          rw [← Finset.sum_mul, ν.sum_eq_one, one_mul]
  have hsum1 := Finset.sum_le_sum fun i (_ : i ∈ Finset.univ) => h1 i
  have hsplit : (∑ i : I, ∑ o : O i, ((lamq i).w o - (pushforward (f i) ν).w o) * (test i o).1) =
      (∑ i : I, ∑ o : O i, (lamq i).w o * (test i o).1) -
      ∑ i : I, ∑ o : O i, (pushforward (f i) ν).w o * (test i o).1 := by
    rw [← Finset.sum_sub_distrib]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [← Finset.sum_sub_distrib]
    refine Finset.sum_congr rfl fun o _ => by ring
  unfold multiQueryDualObj multiQueryTvError
  linarith

/-- **Multi-Query Common-History TV Realizability Duality (`common_history_tv_duality`):**
Minimizing total query TV error over one common distribution `ν : FinDist U` equals maximizing
the multi-query test discrepancy over `[0, 1]`-valued tests, with attainment on both sides. -/
theorem common_history_tv_duality {I U : Type*} [Fintype I] [Fintype U] [Nonempty U]
    {O : I → Type*} [∀ i, Fintype (O i)] (f : (i : I) → U → O i) (lamq : (i : I) → FinDist (O i)) :
    ∃ (ν : FinDist U) (test : ∀ i : I, O i → Set.Icc (0 : ℝ) 1),
      (∀ ν' : FinDist U, multiQueryTvError f lamq ν ≤ multiQueryTvError f lamq ν') ∧
      (∀ test' : ∀ i : I, O i → Set.Icc (0 : ℝ) 1,
        multiQueryDualObj f lamq test' ≤ multiQueryDualObj f lamq test) ∧
      multiQueryTvError f lamq ν = multiQueryDualObj f lamq test := by
  let tvFun : (U → ℝ) → ℝ := fun w =>
    ∑ i : I, (1 / 2 : ℝ) * ∑ o : O i, |(∑ u : U, if f i u = o then w u else 0) - (lamq i).w o|
  have htvCont : Continuous tvFun := by
    refine continuous_finsetSum Finset.univ fun i _ =>
      continuous_const.mul (continuous_finsetSum Finset.univ fun o _ => Continuous.abs ?_)
    exact (continuous_finsetSum Finset.univ fun u _ => by
      by_cases h : f i u = o
      · simp [h]; exact continuous_apply u
      · simp [h]; exact continuous_const).sub continuous_const
  obtain ⟨u₀⟩ := ‹Nonempty U›
  have hSimp_ne : (stdSimplex ℝ U).Nonempty :=
    ⟨(diracDist u₀).w, (diracDist u₀).nonneg, (diracDist u₀).sum_eq_one⟩
  obtain ⟨wOpt, hwOpt_mem, hwOpt_min⟩ :=
    (isCompact_stdSimplex ℝ U).exists_isMinOn hSimp_ne htvCont.continuousOn
  let νOpt : FinDist U := ⟨wOpt, hwOpt_mem.1, hwOpt_mem.2⟩
  let M : ℝ := multiQueryTvError f lamq νOpt
  have hνOpt_min : ∀ ν' : FinDist U, M ≤ multiQueryTvError f lamq ν' := fun ν' =>
    hwOpt_min ⟨ν'.nonneg, ν'.sum_eq_one⟩
  have hM_nonneg : 0 ≤ M := Finset.sum_nonneg fun i _ => tvDist_nonneg _ _
  let P := (i : I) × O i
  let E := (P → ℝ) × ℝ
  let E_dom := (U → ℝ) × (P → ℝ) × (P → ℝ)
  let Φ : E_dom →ₗ[ℝ] E :=
    { toFun := fun z =>
        (fun p => (∑ u : U, if f p.1 u = p.2 then z.1 u else 0) + z.2.1 p - z.2.2 p,
         ∑ p : P, z.2.1 p)
      map_add' := fun z₁ z₂ => by
        ext p
        · change (∑ u : U, if f p.1 u = p.2 then z₁.1 u + z₂.1 u else 0) + (z₁.2.1 p + z₂.2.1 p) -
              (z₁.2.2 p + z₂.2.2 p) =
              ((∑ u : U, if f p.1 u = p.2 then z₁.1 u else 0) + z₁.2.1 p - z₁.2.2 p) +
              ((∑ u : U, if f p.1 u = p.2 then z₂.1 u else 0) + z₂.2.1 p - z₂.2.2 p)
          have hsum : ∑ u : U, (if f p.1 u = p.2 then z₁.1 u + z₂.1 u else 0) =
              (∑ u : U, if f p.1 u = p.2 then z₁.1 u else 0) +
              (∑ u : U, if f p.1 u = p.2 then z₂.1 u else 0) := by
            rw [← Finset.sum_add_distrib]
            refine Finset.sum_congr rfl fun u _ => by split_ifs <;> ring
          linarith
        · change ∑ p : P, (z₁.2.1 p + z₂.2.1 p) = (∑ p : P, z₁.2.1 p) + ∑ p : P, z₂.2.1 p
          exact Finset.sum_add_distrib
      map_smul' := fun r z => by
        ext p
        · change (∑ u : U, if f p.1 u = p.2 then r * z.1 u else 0) + r * z.2.1 p - r * z.2.2 p =
              r * ((∑ u : U, if f p.1 u = p.2 then z.1 u else 0) + z.2.1 p - z.2.2 p)
          have hsum : ∑ u : U, (if f p.1 u = p.2 then r * z.1 u else 0) =
              r * ∑ u : U, if f p.1 u = p.2 then z.1 u else 0 := by
            rw [Finset.mul_sum]
            refine Finset.sum_congr rfl fun u _ => by split_ifs <;> ring
          linarith
        · change ∑ p : P, r * z.2.1 p = r * ∑ p : P, z.2.1 p
          exact (Finset.mul_sum _ _ _).symm }
  let B : Set (P → ℝ) := Set.pi Set.univ (fun _ => Set.Icc (0 : ℝ) 2)
  let K_dom : Set E_dom := stdSimplex ℝ U ×ˢ (B ×ˢ B)
  have hK_conv : Convex ℝ K_dom :=
    (convex_stdSimplex ℝ U).prod ((convex_pi fun _ _ => convex_Icc 0 2).prod
      (convex_pi fun _ _ => convex_Icc 0 2))
  have hB_compact : IsCompact B := isCompact_univ_pi fun _ => isCompact_Icc
  have hK_compact : IsCompact K_dom :=
    (isCompact_stdSimplex ℝ U).prod (hB_compact.prod hB_compact)
  have hΦ_cont : Continuous Φ := by
    refine Continuous.prodMk ?_ ?_
    · refine continuous_pi fun p => ?_
      refine ((Continuous.add ?_ ?_).sub ?_)
      · exact continuous_finsetSum Finset.univ fun u _ => by
          by_cases h : f p.1 u = p.2
          · simp [h]; exact (continuous_apply u).comp continuous_fst
          · simp [h]; exact continuous_const
      · exact (continuous_apply p).comp (continuous_fst.comp continuous_snd)
      · exact (continuous_apply p).comp (continuous_snd.comp continuous_snd)
    · exact continuous_finsetSum Finset.univ fun p _ =>
        (continuous_apply p).comp (continuous_fst.comp continuous_snd)
  let K : Set E := Φ '' K_dom
  have hK_convex : Convex ℝ K := hK_conv.linear_image Φ
  have hK_closed : IsClosed K := (hK_compact.image hΦ_cont).isClosed
  let lamVec : P → ℝ := fun p => (lamq p.1).w p.2
  have htv_pos_part : ∀ (ν : FinDist U),
      multiQueryTvError f lamq ν =
      ∑ p : P, max ((lamq p.1).w p.2 - (pushforward (f p.1) ν).w p.2) 0 := by
    intro ν
    unfold multiQueryTvError tvDist FiniteProb.tvDist
    rw [Fintype.sum_sigma]
    refine Finset.sum_congr rfl fun i _ => ?_
    have hdiff0 : ∑ o : O i, ((lamq i).w o - (pushforward (f i) ν).w o) = 0 := by
      rw [Finset.sum_sub_distrib, (lamq i).sum_eq_one, (pushforward (f i) ν).sum_eq_one, sub_self]
    have hmax : ∀ o : O i, max ((lamq i).w o - (pushforward (f i) ν).w o) 0 =
        (1 / 2 : ℝ) * (|(pushforward (f i) ν).w o - (lamq i).w o| +
          ((lamq i).w o - (pushforward (f i) ν).w o)) := fun o => by
      rw [abs_sub_comm]
      rcases le_total 0 ((lamq i).w o - (pushforward (f i) ν).w o) with h | h
      · rw [max_eq_left h, abs_of_nonneg h]; ring
      · rw [max_eq_right h, abs_of_nonpos h]; ring
    calc (1 / 2 : ℝ) * ∑ o : O i, |(pushforward (f i) ν).w o - (lamq i).w o|
        = (1 / 2 : ℝ) * ((∑ o : O i, |(pushforward (f i) ν).w o - (lamq i).w o|) +
            ∑ o : O i, ((lamq i).w o - (pushforward (f i) ν).w o)) := by
          rw [hdiff0, add_zero]
      _ = ∑ o : O i, (1 / 2 : ℝ) * (|(pushforward (f i) ν).w o - (lamq i).w o| +
            ((lamq i).w o - (pushforward (f i) ν).w o)) := by
          rw [← Finset.sum_add_distrib, Finset.mul_sum]
      _ = ∑ o : O i, max ((lamq i).w o - (pushforward (f i) ν).w o) 0 :=
          Finset.sum_congr rfl fun o _ => (hmax o).symm
  let rStar : P → ℝ := fun p => max (lamVec p - (pushforward (f p.1) νOpt).w p.2) 0
  let sStar : P → ℝ := fun p => max ((pushforward (f p.1) νOpt).w p.2 - lamVec p) 0
  have hrStar_le1 : ∀ p : P, rStar p ≤ 1 := fun p => by
    dsimp only [rStar, lamVec]
    have h1 : (lamq p.1).w p.2 ≤ 1 :=
      (lamq p.1).sum_eq_one ▸ Finset.single_le_sum (fun o _ => (lamq p.1).nonneg o) (Finset.mem_univ p.2)
    have h2 : 0 ≤ (pushforward (f p.1) νOpt).w p.2 := (pushforward (f p.1) νOpt).nonneg p.2
    exact max_le (by linarith) (by norm_num)
  have hsStar_le1 : ∀ p : P, sStar p ≤ 1 := fun p => by
    dsimp only [sStar, lamVec]
    have h1 : (pushforward (f p.1) νOpt).w p.2 ≤ 1 :=
      (pushforward (f p.1) νOpt).sum_eq_one ▸
        Finset.single_le_sum (fun o _ => (pushforward (f p.1) νOpt).nonneg o) (Finset.mem_univ p.2)
    have h2 : 0 ≤ (lamq p.1).w p.2 := (lamq p.1).nonneg p.2
    exact max_le (by linarith) (by norm_num)
  have hrStar_mem : rStar ∈ B := fun p _ => ⟨le_max_right _ _, (hrStar_le1 p).trans (by norm_num)⟩
  have hsStar_mem : sStar ∈ B := fun p _ => ⟨le_max_right _ _, (hsStar_le1 p).trans (by norm_num)⟩
  have hΦ_lam : Φ (νOpt.w, rStar, sStar) = (lamVec, M) := by
    ext p
    · change (∑ u : U, if f p.1 u = p.2 then νOpt.w u else 0) + rStar p - sStar p = lamVec p
      dsimp only [rStar, sStar, lamVec, pushforward, FiniteProb.pushforward]
      rcases le_total 0 ((lamq p.1).w p.2 - ∑ u : U, if f p.1 u = p.2 then νOpt.w u else 0) with h | h
      · rw [max_eq_left h, max_eq_right (by linarith)]; ring
      · rw [max_eq_right h, max_eq_left (by linarith)]; ring
    · change ∑ p : P, rStar p = M
      exact (htv_pos_part νOpt).symm
  have hlamM_mem : (lamVec, M) ∈ K :=
    ⟨(νOpt.w, rStar, sStar), ⟨⟨νOpt.nonneg, νOpt.sum_eq_one⟩, hrStar_mem, hsStar_mem⟩, hΦ_lam⟩
  have happrox : ∀ (δ : ℝ), 0 < δ →
      ∃ test : ∀ i : I, O i → Set.Icc (0 : ℝ) 1,
        (M - δ) / (1 + 2 * δ) < multiQueryDualObj f lamq test := by
    intro δ hδ
    have hnotMem : (lamVec, M - δ) ∉ K := by
      rintro ⟨⟨w, r, s⟩, ⟨hw, hr, hs⟩, heq⟩
      let ν' : FinDist U := ⟨w, hw.1, hw.2⟩
      have hlam_eq : ∀ p : P, lamVec p = (pushforward (f p.1) ν').w p.2 + r p - s p := fun p =>
        (congrArg (fun z : E => z.1 p) heq).symm
      have hsum_eq : ∑ p : P, r p = M - δ := congrArg (fun z : E => z.2) heq
      have hle_r : ∀ p : P, max ((lamq p.1).w p.2 - (pushforward (f p.1) ν').w p.2) 0 ≤ r p := fun p => by
        have hr0 : 0 ≤ r p := (hr p (Set.mem_univ p)).1
        have hs0 : 0 ≤ s p := (hs p (Set.mem_univ p)).1
        have h1 : (lamq p.1).w p.2 - (pushforward (f p.1) ν').w p.2 = r p - s p := by
          have := hlam_eq p
          dsimp only [lamVec] at this
          linarith
        exact max_le (by linarith) hr0
      have hMle := hνOpt_min ν'
      rw [htv_pos_part ν'] at hMle
      have hsumle := Finset.sum_le_sum fun p (_ : p ∈ Finset.univ) => hle_r p
      linarith
    obtain ⟨ℓ, u, hsep_lt, hsep_gt⟩ :=
      geometric_hahn_banach_point_closed hK_convex hK_closed hnotMem
    let a : P → ℝ := fun p => ℓ (Pi.single p 1, 0)
    let β : ℝ := ℓ (0, 1)
    have hℓ_decomp : ∀ (w : P → ℝ) (t : ℝ), ℓ (w, t) = (∑ p : P, w p * a p) + β * t := by
      intro w t
      have hwt : (w, t) = (∑ p : P, w p • (Pi.single p (1 : ℝ), (0 : ℝ))) + t • ((0 : P → ℝ), (1 : ℝ)) := by
        ext p
        · simp [Prod.fst_add, Prod.fst_sum, Pi.single_apply]
          rw [Finset.sum_eq_single p (fun x _ hx => if_neg (Ne.symm hx))
            (fun hm => absurd (Finset.mem_univ p) hm), if_pos rfl]
        · simp [Prod.snd_add, Prod.snd_sum]
      conv_lhs => rw [hwt]
      simp only [map_add, map_sum, ContinuousLinearMap.map_smul, smul_eq_mul, a, β]
      ring
    have hβ_pos : 0 < β := by
      have hlt : ℓ (lamVec, M - δ) < ℓ (lamVec, M) := hsep_lt.trans (hsep_gt _ hlamM_mem)
      rw [hℓ_decomp, hℓ_decomp] at hlt
      have h0 : 0 < β * δ := by linarith
      exact pos_of_mul_pos_left h0 hδ.le
    let c : P → ℝ := fun p => -a p / β
    have ha_eq : ∀ p : P, a p = -β * c p := fun p => by
      dsimp only [c]
      field_simp [hβ_pos.ne']
    have hc_upper : ∀ p₀ : P, c p₀ < 1 + δ := by
      intro p₀
      let r1 : P → ℝ := fun p => rStar p + (Pi.single p₀ (1 : ℝ) : P → ℝ) p
      have hr1_mem : r1 ∈ B := fun p _ => by
        dsimp only [r1]
        by_cases hp : p = p₀
        · subst hp
          have hr0 : 0 ≤ rStar p := le_max_right _ _
          simp only [Pi.single_eq_same]
          exact ⟨by linarith, by linarith [hrStar_le1 p]⟩
        · simp only [Pi.single_eq_of_ne hp, add_zero]
          exact hrStar_mem p (Set.mem_univ p)
      have hz_mem : Φ (νOpt.w, r1, sStar) ∈ K :=
        ⟨(νOpt.w, r1, sStar), ⟨⟨νOpt.nonneg, νOpt.sum_eq_one⟩, hr1_mem, hsStar_mem⟩, rfl⟩
      have hlt : ℓ (lamVec, M - δ) < ℓ (Φ (νOpt.w, r1, sStar)) := hsep_lt.trans (hsep_gt _ hz_mem)
      have hΦ1 : (Φ (νOpt.w, r1, sStar)).1 = lamVec + Pi.single p₀ 1 := by
        ext p
        have heqp := congrArg (fun z : E => z.1 p) hΦ_lam
        change (∑ u : U, if f p.1 u = p.2 then νOpt.w u else 0) + r1 p - sStar p =
            lamVec p + (Pi.single p₀ (1 : ℝ) : P → ℝ) p
        have heqp' : (∑ u : U, if f p.1 u = p.2 then νOpt.w u else 0) + rStar p - sStar p = lamVec p := heqp
        dsimp only [r1]
        linarith
      have hΦ2 : (Φ (νOpt.w, r1, sStar)).2 = M + 1 := by
        change ∑ p : P, r1 p = M + 1
        dsimp only [r1]
        rw [Finset.sum_add_distrib, ← htv_pos_part νOpt]
        simp [M]
      have hpair : Φ (νOpt.w, r1, sStar) = (lamVec + Pi.single p₀ 1, M + 1) := Prod.ext hΦ1 hΦ2
      rw [hpair, hℓ_decomp, hℓ_decomp] at hlt
      simp only [Pi.add_apply] at hlt
      have hsum1 : ∑ p : P, (lamVec p + (Pi.single p₀ (1 : ℝ) : P → ℝ) p) * a p =
          (∑ p : P, lamVec p * a p) + a p₀ := by
        have h2 : ∑ p : P, (lamVec p + (Pi.single p₀ (1 : ℝ) : P → ℝ) p) * a p =
            (∑ p : P, lamVec p * a p) + ∑ p : P, (Pi.single p₀ (1 : ℝ) : P → ℝ) p * a p := by
          rw [← Finset.sum_add_distrib]
          refine Finset.sum_congr rfl fun p _ => by ring
        have h_single : ∑ p : P, (Pi.single p₀ (1 : ℝ) : P → ℝ) p * a p = a p₀ := by
          rw [Finset.sum_eq_single p₀ (fun p _ hp => by rw [Pi.single_eq_of_ne hp, zero_mul])
            (fun hm => absurd (Finset.mem_univ p₀) hm), Pi.single_eq_same, one_mul]
        rw [h2, h_single]
      rw [hsum1, ha_eq p₀] at hlt
      have hmul : β * c p₀ < β * (1 + δ) := by linarith
      exact (mul_lt_mul_iff_right₀ hβ_pos).mp hmul
    have hc_lower : ∀ p₀ : P, -δ < c p₀ := by
      intro p₀
      let s1 : P → ℝ := fun p => sStar p + (Pi.single p₀ (1 : ℝ) : P → ℝ) p
      have hs1_mem : s1 ∈ B := fun p _ => by
        dsimp only [s1]
        by_cases hp : p = p₀
        · subst hp
          have hs0 : 0 ≤ sStar p := le_max_right _ _
          simp only [Pi.single_eq_same]
          exact ⟨by linarith, by linarith [hsStar_le1 p]⟩
        · simp only [Pi.single_eq_of_ne hp, add_zero]
          exact hsStar_mem p (Set.mem_univ p)
      have hz_mem : Φ (νOpt.w, rStar, s1) ∈ K :=
        ⟨(νOpt.w, rStar, s1), ⟨⟨νOpt.nonneg, νOpt.sum_eq_one⟩, hrStar_mem, hs1_mem⟩, rfl⟩
      have hlt : ℓ (lamVec, M - δ) < ℓ (Φ (νOpt.w, rStar, s1)) := hsep_lt.trans (hsep_gt _ hz_mem)
      have hΦ1 : (Φ (νOpt.w, rStar, s1)).1 = lamVec - Pi.single p₀ 1 := by
        ext p
        have heqp := congrArg (fun z : E => z.1 p) hΦ_lam
        change (∑ u : U, if f p.1 u = p.2 then νOpt.w u else 0) + rStar p - s1 p =
            lamVec p - (Pi.single p₀ (1 : ℝ) : P → ℝ) p
        have heqp' : (∑ u : U, if f p.1 u = p.2 then νOpt.w u else 0) + rStar p - sStar p = lamVec p := heqp
        dsimp only [s1]
        linarith
      have hΦ2 : (Φ (νOpt.w, rStar, s1)).2 = M := by
        change ∑ p : P, rStar p = M
        exact (htv_pos_part νOpt).symm
      have hpair : Φ (νOpt.w, rStar, s1) = (lamVec - Pi.single p₀ 1, M) := Prod.ext hΦ1 hΦ2
      rw [hpair, hℓ_decomp, hℓ_decomp] at hlt
      simp only [Pi.sub_apply] at hlt
      have hsum1 : ∑ p : P, (lamVec p - (Pi.single p₀ (1 : ℝ) : P → ℝ) p) * a p =
          (∑ p : P, lamVec p * a p) - a p₀ := by
        have h2 : ∑ p : P, (lamVec p - (Pi.single p₀ (1 : ℝ) : P → ℝ) p) * a p =
            (∑ p : P, lamVec p * a p) - ∑ p : P, (Pi.single p₀ (1 : ℝ) : P → ℝ) p * a p := by
          rw [← Finset.sum_sub_distrib]
          refine Finset.sum_congr rfl fun p _ => by ring
        have h_single : ∑ p : P, (Pi.single p₀ (1 : ℝ) : P → ℝ) p * a p = a p₀ := by
          rw [Finset.sum_eq_single p₀ (fun p _ hp => by rw [Pi.single_eq_of_ne hp, zero_mul])
            (fun hm => absurd (Finset.mem_univ p₀) hm), Pi.single_eq_same, one_mul]
        rw [h2, h_single]
      rw [hsum1, ha_eq p₀] at hlt
      have hmul : β * (-δ) < β * c p₀ := by linarith
      exact (mul_lt_mul_iff_right₀ hβ_pos).mp hmul
    have hu_gap : ∀ u : U, M - δ <
        (∑ i : I, ∑ o : O i, (lamq i).w o * c ⟨i, o⟩) - ∑ i : I, c ⟨i, f i u⟩ := by
      intro u
      let dir : U → ℝ := fun u' => if u' = u then 1 else 0
      have hdir_mem : dir ∈ stdSimplex ℝ U := ⟨fun u' => by dsimp [dir]; split_ifs <;> norm_num, by simp [dir]⟩
      have hz_mem : Φ (dir, 0, 0) ∈ K :=
        ⟨(dir, 0, 0), ⟨hdir_mem, fun _ _ => ⟨le_rfl, by norm_num⟩, fun _ _ => ⟨le_rfl, by norm_num⟩⟩, rfl⟩
      have hlt : ℓ (lamVec, M - δ) < ℓ (Φ (dir, 0, 0)) := hsep_lt.trans (hsep_gt _ hz_mem)
      rw [hℓ_decomp, hℓ_decomp] at hlt
      have hsum_lam : ∑ p : P, lamVec p * a p = -β * ∑ i : I, ∑ o : O i, (lamq i).w o * c ⟨i, o⟩ := by
        rw [Fintype.sum_sigma, Finset.mul_sum]
        refine Finset.sum_congr rfl fun i _ => ?_
        rw [Finset.mul_sum]
        refine Finset.sum_congr rfl fun o _ => ?_
        dsimp only [lamVec]
        rw [ha_eq ⟨i, o⟩]
        ring
      have hsum_dir : ∑ p : P, (Φ (dir, 0, 0)).1 p * a p = -β * ∑ i : I, c ⟨i, f i u⟩ := by
        rw [Fintype.sum_sigma, Finset.mul_sum]
        refine Finset.sum_congr rfl fun i _ => ?_
        have hi : (∑ o : O i, (Φ (dir, 0, 0)).1 ⟨i, o⟩ * a ⟨i, o⟩) = a ⟨i, f i u⟩ := by
          have h1 : ∀ o : O i, (Φ (dir, 0, 0)).1 ⟨i, o⟩ = if f i u = o then 1 else 0 := fun o => by
            change (∑ u' : U, if f i u' = o then (if u' = u then (1 : ℝ) else 0) else 0) + 0 - 0 =
                if f i u = o then 1 else 0
            rw [Finset.sum_eq_single u (fun u' _ hne => by simp [hne]) (fun h => absurd (Finset.mem_univ u) h)]
            simp
          simp [h1]
        rw [hi, ha_eq ⟨i, f i u⟩]
      have hΦ0 : (Φ (dir, 0, 0)).2 = 0 := by simp [Φ]
      rw [hsum_lam, hsum_dir, hΦ0, mul_zero, add_zero] at hlt
      have hmul : β * (M - δ) < β * ((∑ i : I, ∑ o : O i, (lamq i).w o * c ⟨i, o⟩) -
          ∑ i : I, c ⟨i, f i u⟩) := by linarith
      exact (mul_lt_mul_iff_right₀ hβ_pos).mp hmul
    let test : ∀ i : I, O i → Set.Icc (0 : ℝ) 1 := fun i o =>
      ⟨(c ⟨i, o⟩ + δ) / (1 + 2 * δ),
        ⟨div_nonneg (by linarith [hc_lower ⟨i, o⟩]) (by linarith),
         (div_le_one (by linarith)).2 (by linarith [hc_upper ⟨i, o⟩])⟩⟩
    refine ⟨test, ?_⟩
    have htest_u : ∀ u : U, (M - δ) / (1 + 2 * δ) <
        (∑ i : I, ∑ o : O i, (lamq i).w o * (test i o).1) - ∑ i : I, (test i (f i u)).1 := by
      intro u
      have hden : 0 < 1 + 2 * δ := by linarith
      have heq : (∑ i : I, ∑ o : O i, (lamq i).w o * (test i o).1) - ∑ i : I, (test i (f i u)).1 =
          ((∑ i : I, ∑ o : O i, (lamq i).w o * c ⟨i, o⟩) - ∑ i : I, c ⟨i, f i u⟩) / (1 + 2 * δ) := by
        have h1 : (∑ i : I, ∑ o : O i, (lamq i).w o * (test i o).1) =
            ((∑ i : I, ∑ o : O i, (lamq i).w o * c ⟨i, o⟩) + δ * (Fintype.card I : ℝ)) / (1 + 2 * δ) := by
          have h2 : ∀ i : I, ∑ o : O i, (lamq i).w o * ((c ⟨i, o⟩ + δ) / (1 + 2 * δ)) =
              ((∑ o : O i, (lamq i).w o * c ⟨i, o⟩) + δ) / (1 + 2 * δ) := fun i => by
            calc ∑ o : O i, (lamq i).w o * ((c ⟨i, o⟩ + δ) / (1 + 2 * δ))
                = ∑ o : O i, ((lamq i).w o * c ⟨i, o⟩ / (1 + 2 * δ) + (lamq i).w o * δ / (1 + 2 * δ)) :=
                  Finset.sum_congr rfl fun o _ => by ring
              _ = (∑ o : O i, (lamq i).w o * c ⟨i, o⟩) / (1 + 2 * δ) +
                    (∑ o : O i, (lamq i).w o) * δ / (1 + 2 * δ) := by
                  rw [Finset.sum_add_distrib, ← Finset.sum_div, ← Finset.sum_div, ← Finset.sum_mul]
              _ = ((∑ o : O i, (lamq i).w o * c ⟨i, o⟩) + δ) / (1 + 2 * δ) := by
                  rw [(lamq i).sum_eq_one, one_mul, add_div]
          dsimp only [test]
          simp_rw [h2, ← Finset.sum_div, Finset.sum_add_distrib, Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
          ring_nf
        have h2 : ∑ i : I, (test i (f i u)).1 =
            ((∑ i : I, c ⟨i, f i u⟩) + δ * (Fintype.card I : ℝ)) / (1 + 2 * δ) := by
          dsimp only [test]
          simp_rw [← Finset.sum_div, Finset.sum_add_distrib, Finset.sum_const, Finset.card_univ, nsmul_eq_mul]
          ring_nf
        rw [h1, h2]
        ring
      rw [heq]
      exact div_lt_div_of_pos_right (hu_gap u) hden
    obtain ⟨u_max, _, hu_max⟩ :=
      Finset.exists_mem_eq_sup' Finset.univ_nonempty (fun u : U => ∑ i : I, (test i (f i u)).1)
    unfold multiQueryDualObj
    rw [hu_max]
    exact htest_u u_max
  have hdualCont : Continuous (multiQueryDualObj f lamq) := by
    unfold multiQueryDualObj
    refine Continuous.sub ?_ ?_
    · exact continuous_finsetSum Finset.univ fun i _ =>
        continuous_finsetSum Finset.univ fun o _ =>
          continuous_const.mul (continuous_subtype_val.comp ((continuous_apply o).comp (continuous_apply i)))
    · refine continuous_finset_sup' Finset.univ_nonempty fun u _ =>
        continuous_finsetSum Finset.univ fun i _ =>
          continuous_subtype_val.comp ((continuous_apply (f i u)).comp (continuous_apply i))
  let zeroTest : ∀ i : I, O i → Set.Icc (0 : ℝ) 1 := fun _ _ => ⟨0, ⟨le_rfl, zero_le_one⟩⟩
  have hTest_ne : (Set.univ : Set (∀ i : I, O i → Set.Icc (0 : ℝ) 1)).Nonempty := ⟨zeroTest, Set.mem_univ _⟩
  obtain ⟨testOpt, _, htestOpt_max⟩ :=
    isCompact_univ.exists_isMaxOn hTest_ne hdualCont.continuousOn
  have htestOpt_le : multiQueryDualObj f lamq testOpt ≤ M :=
    multiQueryDualObj_le_multiQueryTvError f lamq νOpt testOpt
  have htestOpt_ge : M ≤ multiQueryDualObj f lamq testOpt := by
    by_contra hlt
    push Not at hlt
    let d : ℝ := M - multiQueryDualObj f lamq testOpt
    have hd_pos : 0 < d := by linarith
    have hzero_val : multiQueryDualObj f lamq zeroTest = 0 := by
      unfold multiQueryDualObj zeroTest
      simp
    have hopt_nn : 0 ≤ multiQueryDualObj f lamq testOpt := by
      simpa [hzero_val] using htestOpt_max (Set.mem_univ zeroTest)
    let δ : ℝ := d / (2 * M + 2)
    have hδ_pos : 0 < δ := div_pos hd_pos (by linarith)
    obtain ⟨testδ, htestδ⟩ := happrox δ hδ_pos
    have hmax_le : multiQueryDualObj f lamq testδ ≤ multiQueryDualObj f lamq testOpt :=
      htestOpt_max (Set.mem_univ testδ)
    have hgap_lt : multiQueryDualObj f lamq testOpt < (M - δ) / (1 + 2 * δ) := by
      rw [lt_div_iff₀ (by linarith)]
      have hmul : δ * (2 * M + 2) = d := div_mul_cancel₀ d (by linarith)
      nlinarith
    linarith
  exact ⟨νOpt, testOpt, hνOpt_min, fun test' => htestOpt_max (Set.mem_univ test'),
    le_antisymm htestOpt_ge htestOpt_le⟩

/-- Corollary: 1-query case of `common_history_tv_duality` recovers `massOutside` TV blindness floor. -/
theorem one_query_tv_floor_via_duality {U O : Type*} [Fintype U] [Nonempty U] [Fintype O]
    (f : U → O) (lam0 : FinDist O) :
    ∃ (ν : FinDist U) (test : Unit → O → Set.Icc (0 : ℝ) 1),
      (∀ ν' : FinDist U, tvDist (pushforward f ν) lam0 ≤ tvDist (pushforward f ν') lam0) ∧
      tvDist (pushforward f ν) lam0 = massOutside f lam0 ∧
      multiQueryDualObj (fun (_ : Unit) => f) (fun (_ : Unit) => lam0) test = massOutside f lam0 := by
  let testOut : Unit → O → Set.Icc (0 : ℝ) 1 := fun _ o =>
    if ∃ u : U, f u = o then ⟨0, ⟨le_rfl, zero_le_one⟩⟩ else ⟨1, ⟨zero_le_one, le_rfl⟩⟩
  have hobj : multiQueryDualObj (fun (_ : Unit) => f) (fun (_ : Unit) => lam0) testOut =
      massOutside f lam0 := by
    unfold multiQueryDualObj massOutside FiniteProb.massOutside testOut
    simp only [Finset.univ_unique, PUnit.default_eq_unit, Finset.sum_singleton]
    have hsup0 : (Finset.univ.sup' Finset.univ_nonempty fun u : U =>
        (if ∃ u' : U, f u' = f u then (⟨0, ⟨le_rfl, zero_le_one⟩⟩ : Set.Icc (0 : ℝ) 1)
          else ⟨1, ⟨zero_le_one, le_rfl⟩⟩).1) = 0 := by
      obtain ⟨u₀⟩ := ‹Nonempty U›
      apply le_antisymm
      · refine Finset.sup'_le _ _ fun u _ => ?_
        rw [if_pos ⟨u, rfl⟩]
      · refine le_trans ?_ (Finset.le_sup' (fun u : U =>
          (if ∃ u' : U, f u' = f u then (⟨0, ⟨le_rfl, zero_le_one⟩⟩ : Set.Icc (0 : ℝ) 1)
            else ⟨1, ⟨zero_le_one, le_rfl⟩⟩).1) (Finset.mem_univ u₀))
        rw [if_pos ⟨u₀, rfl⟩]
    rw [hsup0, sub_zero]
    refine Finset.sum_congr rfl fun o _ => ?_
    split_ifs <;> ring
  have hdual_le : ∀ test' : Unit → O → Set.Icc (0 : ℝ) 1,
      multiQueryDualObj (fun (_ : Unit) => f) (fun (_ : Unit) => lam0) test' ≤ massOutside f lam0 := by
    intro test'
    let s : ℝ := Finset.univ.sup' Finset.univ_nonempty fun u : U => (test' () (f u)).1
    obtain ⟨u_s, _, hu_s⟩ :=
      Finset.exists_mem_eq_sup' Finset.univ_nonempty (fun u : U => (test' () (f u)).1)
    have hs0 : 0 ≤ s := by
      dsimp only [s]
      rw [hu_s]
      exact (test' () (f u_s)).2.1
    have hs1 : s ≤ 1 := by
      dsimp only [s]
      rw [hu_s]
      exact (test' () (f u_s)).2.2
    have hsum_le : (∑ o : O, lam0.w o * (test' () o).1) ≤
        s * (∑ o : O, if ∃ u : U, f u = o then lam0.w o else 0) + massOutside f lam0 := by
      have hterm : ∀ o : O, lam0.w o * (test' () o).1 ≤
          (if ∃ u : U, f u = o then s * lam0.w o else 0) +
          (if ∃ u : U, f u = o then 0 else lam0.w o) := by
        intro o
        by_cases ho : ∃ u : U, f u = o
        · obtain ⟨u, hu⟩ := ho
          rw [if_pos ⟨u, hu⟩, if_pos ⟨u, hu⟩, add_zero]
          have htu : (test' () o).1 ≤ s := by
            rw [← hu]
            exact Finset.le_sup' (fun u' : U => (test' () (f u')).1) (Finset.mem_univ u)
          rw [mul_comm s]
          exact mul_le_mul_of_nonneg_left htu (lam0.nonneg o)
        · rw [if_neg ho, if_neg ho, zero_add]
          exact mul_le_of_le_one_right (lam0.nonneg o) (test' () o).2.2
      calc ∑ o : O, lam0.w o * (test' () o).1
          ≤ ∑ o : O, ((if ∃ u : U, f u = o then s * lam0.w o else 0) +
              (if ∃ u : U, f u = o then 0 else lam0.w o)) :=
            Finset.sum_le_sum fun o _ => hterm o
        _ = (∑ o : O, if ∃ u : U, f u = o then s * lam0.w o else 0) + massOutside f lam0 := by
            rw [Finset.sum_add_distrib]
            rfl
        _ = s * (∑ o : O, if ∃ u : U, f u = o then lam0.w o else 0) + massOutside f lam0 := by
            congr 1
            rw [Finset.mul_sum]
            refine Finset.sum_congr rfl fun o _ => by split_ifs <;> ring
    have hlam_split : (∑ o : O, if ∃ u : U, f u = o then lam0.w o else 0) + massOutside f lam0 = 1 := by
      unfold massOutside FiniteProb.massOutside
      rw [← Finset.sum_add_distrib]
      calc ∑ o : O, ((if ∃ u, f u = o then lam0.w o else 0) + (if ∃ u, f u = o then 0 else lam0.w o))
          = ∑ o : O, lam0.w o := Finset.sum_congr rfl fun o _ => by split_ifs <;> ring
        _ = 1 := lam0.sum_eq_one
    unfold multiQueryDualObj
    simp only [Finset.univ_unique, PUnit.default_eq_unit, Finset.sum_singleton]
    have hms := massOutside_nonneg f lam0
    nlinarith
  obtain ⟨ν, testOpt, hmin, hmax, heq⟩ :=
    common_history_tv_duality (fun (_ : Unit) => f) (fun (_ : Unit) => lam0)
  have htv_eq_err : ∀ ν' : FinDist U,
      multiQueryTvError (fun (_ : Unit) => f) (fun (_ : Unit) => lam0) ν' =
      tvDist (pushforward f ν') lam0 := fun ν' => by
    simp [multiQueryTvError]
  have hν_eq : tvDist (pushforward f ν) lam0 = massOutside f lam0 := by
    apply le_antisymm
    · rw [← htv_eq_err ν, heq]
      exact hdual_le testOpt
    · rw [← hobj]
      exact (multiQueryDualObj_le_multiQueryTvError (fun (_ : Unit) => f)
        (fun (_ : Unit) => lam0) ν testOut).trans_eq (htv_eq_err ν)
  refine ⟨ν, testOut, fun ν' => ?_, hν_eq, hobj⟩
  rw [← htv_eq_err ν, ← htv_eq_err ν']
  exact hmin ν'

/-- Support predicate restricting a `FinDist (Bool × Bool)` to the diagonal `{(false,false), (true,true)}`. -/
def diagSupport (ν : FinDist (Bool × Bool)) : Prop :=
  ν.w (false, true) = 0 ∧ ν.w (true, false) = 0

theorem diagSupport_fst_eq_snd {ν : FinDist (Bool × Bool)} (h : diagSupport ν) :
    pushforward Prod.fst ν = pushforward Prod.snd ν := by
  refine FinDist.ext fun b => ?_
  dsimp only [pushforward, FiniteProb.pushforward]
  cases b <;> simp [Fintype.sum_prod_type, h.1, h.2]

/-- Explicit target marginal `(4/5, 1/5)` on `Bool`. -/
noncomputable def fourFifthsBool : FinDist Bool where
  w b := if b = false then (4 / 5 : ℝ) else (1 / 5 : ℝ)
  nonneg b := by cases b <;> norm_num
  sum_eq_one := by simp; norm_num

/-- Explicit opposite target marginal `(1/5, 4/5)` on `Bool`. -/
noncomputable def oneFifthBool : FinDist Bool where
  w b := if b = false then (1 / 5 : ℝ) else (4 / 5 : ℝ)
  nonneg b := by cases b <;> norm_num
  sum_eq_one := by simp; norm_num

/-- Constructive diagonal law lifting any `p : FinDist Bool` onto `Bool × Bool`. -/
noncomputable def diagLift (p : FinDist Bool) : FinDist (Bool × Bool) where
  w uv := if uv.1 = uv.2 then p.w uv.1 else 0
  nonneg uv := by
    split_ifs
    · exact p.nonneg uv.1
    · exact le_rfl
  sum_eq_one := by
    have h := p.sum_eq_one
    simp [Fintype.sum_prod_type] at h ⊢
    linarith

/-- Corollary: `3/5` 2-query diagonal minimax separation witness (primal + dual attainment). -/
theorem two_query_diagonal_three_fifths_witness :
    let f : Bool → Bool → Bool := fun _ b => b
    let lamq : Bool → FinDist Bool := fun i => if i = false then fourFifthsBool else oneFifthBool
    (∃ ν₁ : FinDist (Bool × Bool), diagSupport ν₁ ∧
      tvDist (pushforward Prod.fst ν₁) fourFifthsBool = 0) ∧
    (∃ ν₂ : FinDist (Bool × Bool), diagSupport ν₂ ∧
      tvDist (pushforward Prod.snd ν₂) oneFifthBool = 0) ∧
    (∃ (ν : FinDist Bool) (test : Bool → Bool → Set.Icc (0 : ℝ) 1),
      (∀ ν' : FinDist Bool, multiQueryTvError f lamq ν ≤ multiQueryTvError f lamq ν') ∧
      (∀ test' : Bool → Bool → Set.Icc (0 : ℝ) 1,
        multiQueryDualObj f lamq test' ≤ multiQueryDualObj f lamq test) ∧
      multiQueryTvError f lamq ν = (3 / 5 : ℝ) ∧
      multiQueryDualObj f lamq test = (3 / 5 : ℝ)) := by
  dsimp only
  refine ⟨⟨diagLift fourFifthsBool, ⟨rfl, rfl⟩, ?_⟩,
          ⟨diagLift oneFifthBool, ⟨rfl, rfl⟩, ?_⟩, ?_⟩
  · have hpf : pushforward Prod.fst (diagLift fourFifthsBool) = fourFifthsBool := by
      refine FinDist.ext fun b => ?_
      cases b <;> simp [FiniteProb.pushforward, diagLift, Fintype.sum_prod_type]
    rw [hpf, tvDist_self]
  · have hpf : pushforward Prod.snd (diagLift oneFifthBool) = oneFifthBool := by
      refine FinDist.ext fun b => ?_
      cases b <;> simp [FiniteProb.pushforward, diagLift, Fintype.sum_prod_type]
    rw [hpf, tvDist_self]
  · let f : Bool → Bool → Bool := fun _ b => b
    let lamq : Bool → FinDist Bool := fun i => if i = false then fourFifthsBool else oneFifthBool
    let test : ∀ i : Bool, Bool → Set.Icc (0 : ℝ) 1 := fun i b =>
      if i = b then ⟨1, ⟨zero_le_one, le_rfl⟩⟩ else ⟨0, ⟨le_rfl, zero_le_one⟩⟩
    have hdual : multiQueryDualObj f lamq test = (3 / 5 : ℝ) := by
      unfold multiQueryDualObj test lamq fourFifthsBool oneFifthBool f
      have hsup : (Finset.univ.sup' Finset.univ_nonempty fun u : Bool =>
          ∑ i : Bool, (if i = u then (⟨1, ⟨zero_le_one, le_rfl⟩⟩ : Set.Icc (0 : ℝ) 1)
            else ⟨0, ⟨le_rfl, zero_le_one⟩⟩).1) = 1 := by
        apply le_antisymm
        · refine Finset.sup'_le _ _ fun u _ => ?_
          cases u <;> simp
        · exact le_trans (by simp) (Finset.le_sup' (fun u : Bool =>
            ∑ i : Bool, (if i = u then (⟨1, ⟨zero_le_one, le_rfl⟩⟩ : Set.Icc (0 : ℝ) 1)
              else ⟨0, ⟨le_rfl, zero_le_one⟩⟩).1) (Finset.mem_univ false))
      rw [hsup]
      simp
      norm_num
    have hprimal : multiQueryTvError f lamq fourFifthsBool = (3 / 5 : ℝ) := by
      unfold multiQueryTvError tvDist FiniteProb.tvDist f lamq
      have hpf : pushforward (fun b : Bool => b) fourFifthsBool = fourFifthsBool := by
        refine FinDist.ext fun b => ?_
        cases b <;> simp [FiniteProb.pushforward]
      simp only [Fintype.sum_bool, Bool.true_eq_false, ↓reduceIte, hpf]
      simp [fourFifthsBool, oneFifthBool]
      norm_num
    refine ⟨fourFifthsBool, test, fun ν' => ?_, fun test' => ?_, hprimal, hdual⟩
    · rw [hprimal, ← hdual]
      exact multiQueryDualObj_le_multiQueryTvError f lamq ν' test
    · rw [hdual, ← hprimal]
      exact multiQueryDualObj_le_multiQueryTvError f lamq fourFifthsBool test'

/-- Uniform `(1/4, 1/4, 1/4, 1/4)` distribution on `Bool × Bool`. -/
noncomputable def uniformPairBool : FinDist (Bool × Bool) where
  w _ := (1 / 4 : ℝ)
  nonneg _ := by norm_num
  sum_eq_one := by norm_num

/-- Uniform `(1/2, 1/2)` distribution on `Bool`. -/
noncomputable def fairBool : FinDist Bool where
  w _ := (1 / 2 : ℝ)
  nonneg _ := by norm_num
  sum_eq_one := by simp

/-- Corollary: `1/2` joint-distribution witness via `common_history_tv_duality` shape
(marginals match `uniformPairBool` at TV `0`, while the joint query on diagonal `Bool` has minimax `1/2`). -/
theorem joint_distribution_one_half_witness :
    let fJoint : Unit → Bool → Bool × Bool := fun _ b => (b, b)
    let lamJoint : Unit → FinDist (Bool × Bool) := fun _ => uniformPairBool
    (∃ ν : FinDist (Bool × Bool), diagSupport ν ∧
      tvDist (pushforward Prod.fst ν) (pushforward Prod.fst uniformPairBool) = 0 ∧
      tvDist (pushforward Prod.snd ν) (pushforward Prod.snd uniformPairBool) = 0) ∧
    (∃ (ν : FinDist Bool) (test : Unit → Bool × Bool → Set.Icc (0 : ℝ) 1),
      (∀ ν' : FinDist Bool, multiQueryTvError fJoint lamJoint ν ≤ multiQueryTvError fJoint lamJoint ν') ∧
      (∀ test' : Unit → Bool × Bool → Set.Icc (0 : ℝ) 1,
        multiQueryDualObj fJoint lamJoint test' ≤ multiQueryDualObj fJoint lamJoint test) ∧
      multiQueryTvError fJoint lamJoint ν = (1 / 2 : ℝ) ∧
      multiQueryDualObj fJoint lamJoint test = (1 / 2 : ℝ)) := by
  dsimp only
  have hfst : pushforward Prod.fst uniformPairBool = fairBool := by
    refine FinDist.ext fun b => ?_
    cases b <;> simp [FiniteProb.pushforward, uniformPairBool, fairBool, Fintype.sum_prod_type] <;> norm_num
  have hsnd : pushforward Prod.snd uniformPairBool = fairBool := by
    refine FinDist.ext fun b => ?_
    cases b <;> simp [FiniteProb.pushforward, uniformPairBool, fairBool, Fintype.sum_prod_type] <;> norm_num
  constructor
  · refine ⟨diagLift fairBool, ⟨rfl, rfl⟩, ?_, ?_⟩
    · have hpf : pushforward Prod.fst (diagLift fairBool) = fairBool := by
        refine FinDist.ext fun b => ?_
        cases b <;> simp [FiniteProb.pushforward, diagLift, fairBool, Fintype.sum_prod_type]
      rw [hpf, hfst, tvDist_self]
    · have hpf : pushforward Prod.snd (diagLift fairBool) = fairBool := by
        refine FinDist.ext fun b => ?_
        cases b <;> simp [FiniteProb.pushforward, diagLift, fairBool, Fintype.sum_prod_type]
      rw [hpf, hsnd, tvDist_self]
  · let fJoint : Unit → Bool → Bool × Bool := fun _ b => (b, b)
    let lamJoint : Unit → FinDist (Bool × Bool) := fun _ => uniformPairBool
    let test : Unit → Bool × Bool → Set.Icc (0 : ℝ) 1 := fun _ uv =>
      if uv.1 = uv.2 then ⟨0, ⟨le_rfl, zero_le_one⟩⟩ else ⟨1, ⟨zero_le_one, le_rfl⟩⟩
    have hdual : multiQueryDualObj fJoint lamJoint test = (1 / 2 : ℝ) := by
      unfold multiQueryDualObj test lamJoint uniformPairBool fJoint
      have hsup : (Finset.univ.sup' Finset.univ_nonempty fun u : Bool =>
          ∑ i : Unit, (if (u, u).1 = (u, u).2 then (⟨0, ⟨le_rfl, zero_le_one⟩⟩ : Set.Icc (0 : ℝ) 1)
            else ⟨1, ⟨zero_le_one, le_rfl⟩⟩).1) = 0 := by
        apply le_antisymm
        · refine Finset.sup'_le _ _ fun u _ => by simp
        · exact le_trans (by simp) (Finset.le_sup' (fun u : Bool =>
            ∑ i : Unit, (if (u, u).1 = (u, u).2 then (⟨0, ⟨le_rfl, zero_le_one⟩⟩ : Set.Icc (0 : ℝ) 1)
              else ⟨1, ⟨zero_le_one, le_rfl⟩⟩).1) (Finset.mem_univ false))
      rw [hsup, sub_zero]
      simp [Fintype.sum_prod_type]
      norm_num
    have hprimal : multiQueryTvError fJoint lamJoint fairBool = (1 / 2 : ℝ) := by
      unfold multiQueryTvError tvDist FiniteProb.tvDist fJoint lamJoint uniformPairBool
      simp [FiniteProb.pushforward, fairBool, Fintype.sum_prod_type]
      norm_num
    refine ⟨fairBool, test, fun ν' => ?_, fun test' => ?_, hprimal, hdual⟩
    · rw [hprimal, ← hdual]
      exact multiQueryDualObj_le_multiQueryTvError fJoint lamJoint ν' test
    · rw [hdual, ← hprimal]
      exact multiQueryDualObj_le_multiQueryTvError fJoint lamJoint fairBool test'

/-! ## Part 4: Client 3 — Finite Decision-Margin Minimax Equality -/

/-- Worst-case margin across all histories `H` of an observation-factored policy `p : O → A`. -/
noncomputable def policyMargin {H A O : Type*} [Fintype H] [Nonempty H]
    (q : H → O) (m : H → A → ℝ) (p : O → A) : ℝ :=
  Finset.univ.inf' Finset.univ_nonempty fun h => m h (p (q h))

/-- Worst-case margin of action `a` on the nonempty observation fiber `{h | q h = o}`. -/
noncomputable def fiberActionMargin {H A O : Type*} [Fintype H] [DecidableEq O]
    (q : H → O) (m : H → A → ℝ) (o : O) (ho : ∃ h : H, q h = o) (a : A) : ℝ :=
  (Finset.univ.filter fun h : H => q h = o).inf'
    (by obtain ⟨h, hh⟩ := ho; exact ⟨h, Finset.mem_filter.2 ⟨Finset.mem_univ h, hh⟩⟩)
    fun h => m h a

/-- Best achievable fiber margin at reachable observation `o`. -/
noncomputable def fiberBestMargin {H A O : Type*} [Fintype H] [Fintype A] [Nonempty A]
    [DecidableEq O] (q : H → O) (m : H → A → ℝ) (o : O) (ho : ∃ h : H, q h = o) : ℝ :=
  Finset.univ.sup' Finset.univ_nonempty fun a => fiberActionMargin q m o ho a

/-- Weak minimax bound: any policy's worst-case margin is at most any reachable fiber's best margin. -/
theorem policyMargin_le_fiberBestMargin {H A O : Type*} [Fintype H] [Nonempty H]
    [Fintype A] [Nonempty A] [DecidableEq O] (q : H → O) (m : H → A → ℝ)
    (p : O → A) (o : O) (ho : ∃ h : H, q h = o) :
    policyMargin q m p ≤ fiberBestMargin q m o ho := by
  rcases ho with ⟨h₁, hh₁⟩
  have ho' : ∃ h : H, q h = o := ⟨h₁, hh₁⟩
  have hmem : h₁ ∈ Finset.univ.filter fun h : H => q h = o :=
    Finset.mem_filter.2 ⟨Finset.mem_univ h₁, hh₁⟩
  have hne : (Finset.univ.filter fun h : H => q h = o).Nonempty := ⟨h₁, hmem⟩
  obtain ⟨h₀, hh₀, hmin⟩ := Finset.exists_mem_eq_inf' hne (fun h => m h (p o))
  have hq0 : q h₀ = o := (Finset.mem_filter.1 hh₀).2
  have h1 : policyMargin q m p ≤ m h₀ (p (q h₀)) :=
    Finset.inf'_le (fun h => m h (p (q h))) (Finset.mem_univ h₀)
  rw [hq0] at h1
  have h2 : m h₀ (p o) = fiberActionMargin q m o ho' (p o) := by
    dsimp only [fiberActionMargin]
    exact hmin.symm
  exact h1.trans (h2.le.trans (Finset.le_sup' (fun a => fiberActionMargin q m o ho' a)
    (Finset.mem_univ (p o))))

/-- **Finite Decision-Margin Minimax Equality (`decision_margin_minimax`):**
The maximum worst-case margin over observation-factored policies `p : O → A` equals the minimum
of `fiberBestMargin` over reachable observations `o₀`, with attainment on both sides. -/
theorem decision_margin_minimax {H A O : Type*} [Fintype H] [Nonempty H]
    [Fintype A] [Nonempty A] [DecidableEq O] (q : H → O) (m : H → A → ℝ) :
    ∃ (p : O → A) (o₀ : O) (ho₀ : ∃ h : H, q h = o₀),
      (∀ p' : O → A, policyMargin q m p' ≤ policyMargin q m p) ∧
      (∀ (o' : O) (ho' : ∃ h : H, q h = o'),
        fiberBestMargin q m o₀ ho₀ ≤ fiberBestMargin q m o' ho') ∧
      policyMargin q m p = fiberBestMargin q m o₀ ho₀ := by
  obtain ⟨a₀⟩ := ‹Nonempty A›
  let chooseAct : ∀ o : O, (∃ h : H, q h = o) → A := fun o ho =>
    Classical.choose (Finset.exists_mem_eq_sup' Finset.univ_nonempty
      (fun a => fiberActionMargin q m o ho a))
  have hchooseAct : ∀ (o : O) (ho : ∃ h : H, q h = o),
      fiberBestMargin q m o ho = fiberActionMargin q m o ho (chooseAct o ho) := fun o ho =>
    (Classical.choose_spec (Finset.exists_mem_eq_sup' Finset.univ_nonempty
      (fun a => fiberActionMargin q m o ho a))).2
  let p : O → A := fun o => if ho : ∃ h : H, q h = o then chooseAct o ho else a₀
  obtain ⟨h₀, _, hh₀⟩ := Finset.exists_mem_eq_inf' Finset.univ_nonempty (fun h => m h (p (q h)))
  let o₀ : O := q h₀
  let ho₀ : ∃ h : H, q h = o₀ := ⟨h₀, rfl⟩
  have hpol_ge : fiberBestMargin q m o₀ ho₀ ≤ policyMargin q m p := by
    rw [policyMargin, hh₀]
    have hp_eq : p o₀ = chooseAct o₀ ho₀ := by
      dsimp only [p]
      exact dif_pos ho₀
    have hact_eq : p (q h₀) = chooseAct o₀ ho₀ := hp_eq
    rw [hact_eq, hchooseAct o₀ ho₀]
    have hmem₀ : h₀ ∈ Finset.univ.filter (fun h : H => q h = o₀) :=
      Finset.mem_filter.2 ⟨Finset.mem_univ h₀, rfl⟩
    exact Finset.inf'_le (fun h => m h (chooseAct o₀ ho₀)) hmem₀
  have hpol_le : policyMargin q m p ≤ fiberBestMargin q m o₀ ho₀ :=
    policyMargin_le_fiberBestMargin q m p o₀ ho₀
  have heq : policyMargin q m p = fiberBestMargin q m o₀ ho₀ := le_antisymm hpol_le hpol_ge
  refine ⟨p, o₀, ho₀, ?_, ?_, heq⟩
  · intro p'
    rw [heq]
    exact policyMargin_le_fiberBestMargin q m p' o₀ ho₀
  · intro o' ho'
    rw [← heq]
    exact policyMargin_le_fiberBestMargin q m p o' ho'

/-- Strict positive decision margin exists across all histories iff every reachable fiber has a common action. -/
theorem decision_margin_pos_iff_common_action {H A O : Type*} [Fintype H] [Nonempty H]
    [Fintype A] [Nonempty A] [DecidableEq O] (q : H → O) (m : H → A → ℝ) :
    (∃ p : O → A, ∀ h : H, 0 < m h (p (q h))) ↔
      (∀ o : O, (∃ h : H, q h = o) → ∃ a : A, ∀ h : H, q h = o → 0 < m h a) := by
  constructor
  · rintro ⟨p, hp⟩ o _
    exact ⟨p o, fun h hq => hq ▸ hp h⟩
  · intro hfib
    obtain ⟨p, o₀, ho₀, hmax, _, heq⟩ := decision_margin_minimax q m
    obtain ⟨a, ha⟩ := hfib o₀ ho₀
    have hpos_fib : 0 < fiberBestMargin q m o₀ ho₀ := by
      have hact : 0 < fiberActionMargin q m o₀ ho₀ a := by
        dsimp only [fiberActionMargin]
        rw [Finset.lt_inf'_iff]
        intro h hh
        exact ha h (Finset.mem_filter.1 hh).2
      exact hact.trans_le (Finset.le_sup' (fun a' => fiberActionMargin q m o₀ ho₀ a')
        (Finset.mem_univ a))
    rw [← heq] at hpos_fib
    refine ⟨p, fun h => hpos_fib.trans_le ?_⟩
    exact Finset.inf'_le (fun h' => m h' (p (q h'))) (Finset.mem_univ h)

/-! ## Part 5: Four Exact Handshake Certificates -/

/-- Exact minimax theorem for two states `h = (0, 1)` and single row `(a, a + δ)` (`0 < δ`). -/
theorem two_state_exact_minimax (a δ ε : ℝ) (hδ : 0 < δ) (hε : 0 ≤ ε) :
    let F : Fin 1 → Fin 2 → ℝ := ![ ![a, a + δ] ]
    let h : Fin 2 → ℝ := ![0, 1]
    ∃ (μ ν : FinDist (Fin 2)) (b : ℝ) (c : Fin 1 → ℝ),
      PrimalFeasible F ε μ ν ∧
      (∀ μ' ν' : FinDist (Fin 2), PrimalFeasible F ε μ' ν' → primalGap h μ' ν' ≤ primalGap h μ ν) ∧
      (∀ (b' : ℝ) (c' : Fin 1 → ℝ), dualBound F h ε b c ≤ dualBound F h ε b' c') ∧
      primalGap h μ ν = min (1 / 2 : ℝ) (ε / δ) ∧
      dualBound F h ε b c = min (1 / 2 : ℝ) (ε / δ) := by
  dsimp only
  let F : Fin 1 → Fin 2 → ℝ := ![ ![a, a + δ] ]
  let h : Fin 2 → ℝ := ![0, 1]
  let t : ℝ := min (1 : ℝ) (2 * ε / δ)
  have ht0 : 0 ≤ t := le_min zero_le_one (div_nonneg (mul_nonneg (by norm_num) hε) hδ.le)
  have ht1 : t ≤ 1 := min_le_left _ _
  let μ : FinDist (Fin 2) :=
    { w := ![1 - t, t]
      nonneg := fun s => by fin_cases s <;> simp <;> linarith
      sum_eq_one := by simp [Fin.sum_univ_two] }
  let ν : FinDist (Fin 2) :=
    { w := ![1, 0]
      nonneg := fun s => by fin_cases s <;> norm_num
      sum_eq_one := by simp [Fin.sum_univ_two] }
  have hfeas : PrimalFeasible F ε μ ν := by
    intro j
    fin_cases j
    change |∑ s : Fin 2, F 0 s * (μ.w s - ν.w s)| ≤ 2 * ε
    have hsum : ∑ s : Fin 2, F 0 s * (μ.w s - ν.w s) = δ * t := by
      simp [F, μ, ν, Fin.sum_univ_two]
      ring
    rw [hsum, abs_mul, abs_of_pos hδ, abs_of_nonneg ht0]
    calc δ * t ≤ δ * (2 * ε / δ) := mul_le_mul_of_nonneg_left (min_le_right _ _) hδ.le
      _ = 2 * ε := mul_div_cancel₀ (2 * ε) hδ.ne'
  have hprimal : primalGap h μ ν = min (1 / 2 : ℝ) (ε / δ) := by
    unfold primalGap
    have hsum : ∑ s : Fin 2, h s * (μ.w s - ν.w s) = t := by
      simp [h, μ, ν, Fin.sum_univ_two]
    rw [hsum, abs_of_nonneg ht0]
    rcases le_total 1 (2 * ε / δ) with hle | hge
    · have ht_eq : t = 1 := min_eq_left hle
      have hmin_eq : min (1 / 2 : ℝ) (ε / δ) = 1 / 2 := by
        apply min_eq_left
        rw [le_div_iff₀ hδ] at hle
        rw [le_div_iff₀ hδ]
        linarith
      rw [ht_eq, hmin_eq]
    · have ht_eq : t = 2 * ε / δ := min_eq_right hge
      have hmin_eq : min (1 / 2 : ℝ) (ε / δ) = ε / δ := by
        apply min_eq_right
        rw [div_le_iff₀ hδ] at hge
        rw [div_le_iff₀ hδ]
        linarith
      rw [ht_eq, hmin_eq]
      ring
  rcases le_or_gt δ (2 * ε) with hle | hgt
  · let b : ℝ := 1 / 2
    let c : Fin 1 → ℝ := ![0]
    have hdual : dualBound F h ε b c = min (1 / 2 : ℝ) (ε / δ) := by
      unfold dualBound
      have hmin_eq : min (1 / 2 : ℝ) (ε / δ) = 1 / 2 := by
        apply min_eq_left
        rw [le_div_iff₀ hδ]
        linarith
      have hsup : (Finset.univ.sup' Finset.univ_nonempty fun s : Fin 2 =>
          |h s - b - ∑ j : Fin 1, F j s * c j|) = 1 / 2 := by
        apply le_antisymm
        · refine Finset.sup'_le _ _ fun s _ => ?_
          fin_cases s
          · simp [h, b, c]
          · simp [h, b, c]
            norm_num
        · exact le_trans (by simp [h, b, c])
            (Finset.le_sup' (fun s : Fin 2 => |h s - b - ∑ j : Fin 1, F j s * c j|) (Finset.mem_univ 0))
      rw [hsup, hmin_eq]
      simp [c]
    have heq : primalGap h μ ν = dualBound F h ε b c := hprimal.trans hdual.symm
    exact ⟨μ, ν, b, c, hfeas,
      fun μ' ν' hfeas' => (primalGap_le_dualBound F h ε hfeas' b c).trans heq.symm.le,
      fun b' c' => heq.symm.le.trans (primalGap_le_dualBound F h ε hfeas b' c'),
      hprimal, hdual⟩
  · let b : ℝ := -a / δ
    let c : Fin 1 → ℝ := ![1 / δ]
    have hdual : dualBound F h ε b c = min (1 / 2 : ℝ) (ε / δ) := by
      unfold dualBound
      have hmin_eq : min (1 / 2 : ℝ) (ε / δ) = ε / δ := by
        apply min_eq_right
        rw [div_le_iff₀ hδ]
        linarith
      have h0 : |h 0 - b - ∑ j : Fin 1, F j 0 * c j| = 0 := by
        simp [h, F, b, c]
        field_simp [hδ.ne']
        ring
      have h1 : |h 1 - b - ∑ j : Fin 1, F j 1 * c j| = 0 := by
        simp [h, F, b, c]
        field_simp [hδ.ne']
        ring
      have hsup : (Finset.univ.sup' Finset.univ_nonempty fun s : Fin 2 =>
          |h s - b - ∑ j : Fin 1, F j s * c j|) = 0 := by
        apply le_antisymm
        · refine Finset.sup'_le _ _ fun s _ => ?_
          fin_cases s
          · exact h0.le
          · exact h1.le
        · rw [← h0]
          exact Finset.le_sup' (fun s : Fin 2 => |h s - b - ∑ j : Fin 1, F j s * c j|) (Finset.mem_univ 0)
      rw [hsup, zero_add, hmin_eq]
      simp [c, abs_of_pos hδ]
      ring
    have heq : primalGap h μ ν = dualBound F h ε b c := hprimal.trans hdual.symm
    exact ⟨μ, ν, b, c, hfeas,
      fun μ' ν' hfeas' => (primalGap_le_dualBound F h ε hfeas' b c).trans heq.symm.le,
      fun b' c' => heq.symm.le.trans (primalGap_le_dualBound F h ε hfeas b' c'),
      hprimal, hdual⟩

/-- §7.1 Public-port vs. recipient-port exact minimax certificate:
with `h = (1/4, 3/4)`, any constant public row family yields `1/4`; adding recipient row
`f = (1/8, 3/8)` yields `min (1/4) (2 * ε)` (strictly `< 1/4` iff `ε < 1/8`). -/
theorem public_port_vs_recipient_exact {J_pub : Type*} [Fintype J_pub]
    (F_pub : J_pub → Fin 2 → ℝ) (hconst : ∀ j, F_pub j 0 = F_pub j 1)
    {ε : ℝ} (hε : 0 ≤ ε) :
    let h : Fin 2 → ℝ := ![1 / 4, 3 / 4]
    let F_rec : Fin 2 → Fin 2 → ℝ := ![ ![1 / 2, 1 / 2], ![1 / 8, 3 / 8] ]
    (∃ (μ ν : FinDist (Fin 2)) (b : ℝ) (c : J_pub → ℝ),
      PrimalFeasible F_pub ε μ ν ∧
      (∀ μ' ν' : FinDist (Fin 2), PrimalFeasible F_pub ε μ' ν' → primalGap h μ' ν' ≤ primalGap h μ ν) ∧
      (∀ (b' : ℝ) (c' : J_pub → ℝ), dualBound F_pub h ε b c ≤ dualBound F_pub h ε b' c') ∧
      primalGap h μ ν = (1 / 4 : ℝ) ∧ dualBound F_pub h ε b c = (1 / 4 : ℝ)) ∧
    (∃ (μ ν : FinDist (Fin 2)) (b : ℝ) (c : Fin 2 → ℝ),
      PrimalFeasible F_rec ε μ ν ∧
      (∀ μ' ν' : FinDist (Fin 2), PrimalFeasible F_rec ε μ' ν' → primalGap h μ' ν' ≤ primalGap h μ ν) ∧
      (∀ (b' : ℝ) (c' : Fin 2 → ℝ), dualBound F_rec h ε b c ≤ dualBound F_rec h ε b' c') ∧
      primalGap h μ ν = min (1 / 4 : ℝ) (2 * ε) ∧
      dualBound F_rec h ε b c = min (1 / 4 : ℝ) (2 * ε)) ∧
    (min (1 / 4 : ℝ) (2 * ε) < (1 / 4 : ℝ) ↔ ε < (1 / 8 : ℝ)) := by
  dsimp only
  let h : Fin 2 → ℝ := ![1 / 4, 3 / 4]
  let F_rec : Fin 2 → Fin 2 → ℝ := ![ ![1 / 2, 1 / 2], ![1 / 8, 3 / 8] ]
  refine ⟨?_, ?_, ?_⟩
  · let μ : FinDist (Fin 2) := diracDist 1
    let ν : FinDist (Fin 2) := diracDist 0
    let b : ℝ := 1 / 2
    let c : J_pub → ℝ := fun _ => 0
    have hfeas : PrimalFeasible F_pub ε μ ν := fun j => by
      have h0 : ∑ s : Fin 2, F_pub j s * (μ.w s - ν.w s) = 0 := by
        simp [μ, ν, FiniteProb.diracDist, Fin.sum_univ_two, hconst j]
      rw [h0, abs_zero]
      linarith
    have hprimal : primalGap h μ ν = (1 / 4 : ℝ) := by
      unfold primalGap
      simp [h, μ, ν, FiniteProb.diracDist, Fin.sum_univ_two]
      norm_num
    have hdual : dualBound F_pub h ε b c = (1 / 4 : ℝ) := by
      unfold dualBound
      have hsup : (Finset.univ.sup' Finset.univ_nonempty fun s : Fin 2 =>
          |h s - b - ∑ j : J_pub, F_pub j s * c j|) = 1 / 4 := by
        apply le_antisymm
        · refine Finset.sup'_le _ _ fun s _ => ?_
          fin_cases s <;> (simp [h, b, c]; norm_num)
        · exact le_trans (by simp [h, b, c]; norm_num)
            (Finset.le_sup' (fun s : Fin 2 => |h s - b - ∑ j : J_pub, F_pub j s * c j|)
              (Finset.mem_univ 0))
      rw [hsup]
      simp [c]
    have heq : primalGap h μ ν = dualBound F_pub h ε b c := hprimal.trans hdual.symm
    exact ⟨μ, ν, b, c, hfeas,
      fun μ' ν' hfeas' => (primalGap_le_dualBound F_pub h ε hfeas' b c).trans heq.symm.le,
      fun b' c' => heq.symm.le.trans (primalGap_le_dualBound F_pub h ε hfeas b' c'),
      hprimal, hdual⟩
  · let t : ℝ := min (1 : ℝ) (8 * ε)
    have ht0 : 0 ≤ t := le_min zero_le_one (by linarith)
    have ht1 : t ≤ 1 := min_le_left _ _
    let μ : FinDist (Fin 2) :=
      { w := ![1 - t, t]
        nonneg := fun s => by fin_cases s <;> simp <;> linarith
        sum_eq_one := by simp [Fin.sum_univ_two] }
    let ν : FinDist (Fin 2) :=
      { w := ![1, 0]
        nonneg := fun s => by fin_cases s <;> norm_num
        sum_eq_one := by simp [Fin.sum_univ_two] }
    have hfeas : PrimalFeasible F_rec ε μ ν := by
      intro j
      fin_cases j
      · change |∑ s : Fin 2, F_rec 0 s * (μ.w s - ν.w s)| ≤ 2 * ε
        have hsum : ∑ s : Fin 2, F_rec 0 s * (μ.w s - ν.w s) = 0 := by
          simp [F_rec, μ, ν, Fin.sum_univ_two]
        rw [hsum, abs_zero]
        linarith
      · change |∑ s : Fin 2, F_rec 1 s * (μ.w s - ν.w s)| ≤ 2 * ε
        have hsum : ∑ s : Fin 2, F_rec 1 s * (μ.w s - ν.w s) = t / 4 := by
          simp [F_rec, μ, ν, Fin.sum_univ_two]
          ring
        rw [hsum, abs_of_nonneg (by linarith)]
        have ht8 : t ≤ 8 * ε := min_le_right _ _
        linarith
    have hprimal : primalGap h μ ν = min (1 / 4 : ℝ) (2 * ε) := by
      unfold primalGap
      have hsum : ∑ s : Fin 2, h s * (μ.w s - ν.w s) = t / 2 := by
        simp [h, μ, ν, Fin.sum_univ_two]
        ring
      rw [hsum, abs_of_nonneg (by linarith)]
      rcases le_total 1 (8 * ε) with hle | hge
      · have ht_eq : t = 1 := min_eq_left hle
        have hmin_eq : min (1 / 4 : ℝ) (2 * ε) = 1 / 4 := min_eq_left (by linarith)
        rw [ht_eq, hmin_eq]
        norm_num
      · have ht_eq : t = 8 * ε := min_eq_right hge
        have hmin_eq : min (1 / 4 : ℝ) (2 * ε) = 2 * ε := min_eq_right (by linarith)
        rw [ht_eq, hmin_eq]
        ring
    rcases le_or_gt (1 / 8 : ℝ) ε with hle | hgt
    · let b : ℝ := 1 / 2
      let c : Fin 2 → ℝ := ![0, 0]
      have hdual : dualBound F_rec h ε b c = min (1 / 4 : ℝ) (2 * ε) := by
        unfold dualBound
        have hmin_eq : min (1 / 4 : ℝ) (2 * ε) = 1 / 4 := min_eq_left (by linarith)
        have hsup : (Finset.univ.sup' Finset.univ_nonempty fun s : Fin 2 =>
            |h s - b - ∑ j : Fin 2, F_rec j s * c j|) = 1 / 4 := by
          apply le_antisymm
          · refine Finset.sup'_le _ _ fun s _ => ?_
            fin_cases s <;> simp [h, F_rec, b, c, Fin.sum_univ_two] <;> norm_num
          · exact le_trans (by simp [h, F_rec, b, c, Fin.sum_univ_two]; norm_num)
              (Finset.le_sup' (fun s : Fin 2 => |h s - b - ∑ j : Fin 2, F_rec j s * c j|)
                (Finset.mem_univ 0))
        rw [hsup, hmin_eq]
        simp [c, Fin.sum_univ_two]
      have heq : primalGap h μ ν = dualBound F_rec h ε b c := hprimal.trans hdual.symm
      exact ⟨μ, ν, b, c, hfeas,
        fun μ' ν' hfeas' => (primalGap_le_dualBound F_rec h ε hfeas' b c).trans heq.symm.le,
        fun b' c' => heq.symm.le.trans (primalGap_le_dualBound F_rec h ε hfeas b' c'),
        hprimal, hdual⟩
    · let b : ℝ := 0
      let c : Fin 2 → ℝ := ![0, 2]
      have hdual : dualBound F_rec h ε b c = min (1 / 4 : ℝ) (2 * ε) := by
        unfold dualBound
        have hmin_eq : min (1 / 4 : ℝ) (2 * ε) = 2 * ε := min_eq_right (by linarith)
        have h0 : |h 0 - b - ∑ j : Fin 2, F_rec j 0 * c j| = 0 := by
          simp [h, F_rec, b, c, Fin.sum_univ_two]
          norm_num
        have h1 : |h 1 - b - ∑ j : Fin 2, F_rec j 1 * c j| = 0 := by
          simp [h, F_rec, b, c, Fin.sum_univ_two]
          norm_num
        have hsup : (Finset.univ.sup' Finset.univ_nonempty fun s : Fin 2 =>
            |h s - b - ∑ j : Fin 2, F_rec j s * c j|) = 0 := by
          apply le_antisymm
          · refine Finset.sup'_le _ _ fun s _ => ?_
            fin_cases s
            · exact h0.le
            · exact h1.le
          · rw [← h0]
            exact Finset.le_sup' (fun s : Fin 2 => |h s - b - ∑ j : Fin 2, F_rec j s * c j|)
              (Finset.mem_univ 0)
        rw [hsup, zero_add, hmin_eq]
        simp [c, Fin.sum_univ_two]
        ring
      have heq : primalGap h μ ν = dualBound F_rec h ε b c := hprimal.trans hdual.symm
      exact ⟨μ, ν, b, c, hfeas,
        fun μ' ν' hfeas' => (primalGap_le_dualBound F_rec h ε hfeas' b c).trans heq.symm.le,
        fun b' c' => heq.symm.le.trans (primalGap_le_dualBound F_rec h ε hfeas b' c'),
        hprimal, hdual⟩
  · constructor
    · intro hlt
      rcases min_lt_iff.1 hlt with h1 | h2
      · exact absurd h1 (lt_irrefl _)
      · linarith
    · intro hlt
      exact min_lt_of_right_lt (by linarith)

/-- B2 aliasing-08 exact rational handshake certificate:
`probe = (285/1000, 632/1000)`, `h = (0, 1)`, `ε = 1/20`, primal `(0, 100/347)`,
dual `(1000y - 285)/347`, exact minimax value `50 / 347`. -/
theorem b2_aliasing_08_exact_certificate :
    let probe : Fin 1 → Fin 2 → ℝ := ![ ![285 / 1000, 632 / 1000] ]
    let h : Fin 2 → ℝ := ![0, 1]
    let ε : ℝ := 1 / 20
    let μ : FinDist (Fin 2) :=
      { w := ![247 / 347, 100 / 347]
        nonneg := fun s => by fin_cases s <;> norm_num
        sum_eq_one := by simp [Fin.sum_univ_two]; norm_num }
    let ν : FinDist (Fin 2) :=
      { w := ![1, 0]
        nonneg := fun s => by fin_cases s <;> norm_num
        sum_eq_one := by simp [Fin.sum_univ_two] }
    let b : ℝ := -285 / 347
    let c : Fin 1 → ℝ := ![1000 / 347]
    PrimalFeasible probe ε μ ν ∧
    (∀ μ' ν' : FinDist (Fin 2), PrimalFeasible probe ε μ' ν' → primalGap h μ' ν' ≤ primalGap h μ ν) ∧
    (∀ (b' : ℝ) (c' : Fin 1 → ℝ), dualBound probe h ε b c ≤ dualBound probe h ε b' c') ∧
    primalGap h μ ν = (50 / 347 : ℝ) ∧
    dualBound probe h ε b c = (50 / 347 : ℝ) := by
  dsimp only
  let probe : Fin 1 → Fin 2 → ℝ := ![ ![285 / 1000, 632 / 1000] ]
  let h : Fin 2 → ℝ := ![0, 1]
  let ε : ℝ := 1 / 20
  let μ : FinDist (Fin 2) :=
    { w := ![247 / 347, 100 / 347]
      nonneg := fun s => by fin_cases s <;> norm_num
      sum_eq_one := by simp [Fin.sum_univ_two]; norm_num }
  let ν : FinDist (Fin 2) :=
    { w := ![1, 0]
      nonneg := fun s => by fin_cases s <;> norm_num
      sum_eq_one := by simp [Fin.sum_univ_two] }
  let b : ℝ := -285 / 347
  let c : Fin 1 → ℝ := ![1000 / 347]
  have hfeas : PrimalFeasible probe ε μ ν := by
    intro j
    fin_cases j
    simp [probe, μ, ν, ε, Fin.sum_univ_two]
    norm_num
  have hprimal : primalGap h μ ν = (50 / 347 : ℝ) := by
    unfold primalGap
    simp [h, μ, ν, Fin.sum_univ_two]
    norm_num
  have hdual : dualBound probe h ε b c = (50 / 347 : ℝ) := by
    unfold dualBound
    have h0 : |h 0 - b - ∑ j : Fin 1, probe j 0 * c j| = 0 := by
      simp [h, probe, b, c]
      norm_num
    have h1 : |h 1 - b - ∑ j : Fin 1, probe j 1 * c j| = 0 := by
      simp [h, probe, b, c]
      norm_num
    have hsup : (Finset.univ.sup' Finset.univ_nonempty fun s : Fin 2 =>
        |h s - b - ∑ j : Fin 1, probe j s * c j|) = 0 := by
      apply le_antisymm
      · refine Finset.sup'_le _ _ fun s _ => ?_
        fin_cases s
        · exact h0.le
        · exact h1.le
      · rw [← h0]
        exact Finset.le_sup' (fun s : Fin 2 => |h s - b - ∑ j : Fin 1, probe j s * c j|) (Finset.mem_univ 0)
    rw [hsup, zero_add]
    simp [ε, c]
    norm_num
  have heq : primalGap h μ ν = dualBound probe h ε b c := hprimal.trans hdual.symm
  exact ⟨hfeas,
    fun μ' ν' hfeas' => (primalGap_le_dualBound probe h ε hfeas' b c).trans heq.symm.le,
    fun b' c' => heq.symm.le.trans (primalGap_le_dualBound probe h ε hfeas b' c'),
    hprimal, hdual⟩

/-- Diagonal 2-state survival kernel `K = diag(1, 1 - δ)` applied `n` times to `(1, 1)`. -/
noncomputable def diagSurvivalProb (δ : ℝ) : ℕ → Fin 2 → ℝ
  | 0, _ => 1
  | n + 1, s => (if s = 0 then (1 : ℝ) else 1 - δ) * diagSurvivalProb δ n s

theorem diagSurvivalProb_eq (δ : ℝ) : ∀ (n : ℕ) (s : Fin 2),
    diagSurvivalProb δ n s = if s = 0 then 1 else (1 - δ) ^ n
  | 0, s => by fin_cases s <;> simp [diagSurvivalProb]
  | n + 1, s => by
    rw [diagSurvivalProb, diagSurvivalProb_eq δ n s]
    fin_cases s
    · simp
    · simp [pow_succ']

/-- Noisy short-word amplification certificate:
for `K = diag(1, 1 - δ)` (`0 < δ < 1`), length-`n` survival `(1, (1 - δ)^n)` probed via
length-1 row `(1, 1 - δ)` attains exact minimax gap `(1 - (1 - δ)^n) * min (1/2) (ε / δ)`. -/
theorem noisy_short_word_amplification (δ ε : ℝ) (hδ0 : 0 < δ) (hδ1 : δ < 1)
    (hε : 0 ≤ ε) (n : ℕ) :
    let F : Fin 1 → Fin 2 → ℝ := ![ ![1, 1 - δ] ]
    let h : Fin 2 → ℝ := diagSurvivalProb δ n
    ∃ (μ ν : FinDist (Fin 2)) (b : ℝ) (c : Fin 1 → ℝ),
      PrimalFeasible F ε μ ν ∧
      (∀ μ' ν' : FinDist (Fin 2), PrimalFeasible F ε μ' ν' → primalGap h μ' ν' ≤ primalGap h μ ν) ∧
      (∀ (b' : ℝ) (c' : Fin 1 → ℝ), dualBound F h ε b c ≤ dualBound F h ε b' c') ∧
      primalGap h μ ν = (1 - (1 - δ) ^ n) * min (1 / 2 : ℝ) (ε / δ) ∧
      dualBound F h ε b c = (1 - (1 - δ) ^ n) * min (1 / 2 : ℝ) (ε / δ) := by
  dsimp only
  let F : Fin 1 → Fin 2 → ℝ := ![ ![1, 1 - δ] ]
  let h : Fin 2 → ℝ := diagSurvivalProb δ n
  have h1mδ_pos : 0 < 1 - δ := by linarith
  have hpow_le : (1 - δ) ^ n ≤ 1 := pow_le_one₀ h1mδ_pos.le (by linarith)
  have hpow_nn : 0 ≤ (1 - δ) ^ n := pow_nonneg h1mδ_pos.le n
  have hamp_nn : 0 ≤ 1 - (1 - δ) ^ n := by linarith
  let t : ℝ := min (1 : ℝ) (2 * ε / δ)
  have ht0 : 0 ≤ t := le_min zero_le_one (div_nonneg (mul_nonneg (by norm_num) hε) hδ0.le)
  have ht1 : t ≤ 1 := min_le_left _ _
  let μ : FinDist (Fin 2) :=
    { w := ![1 - t, t]
      nonneg := fun s => by fin_cases s <;> simp <;> linarith
      sum_eq_one := by simp [Fin.sum_univ_two] }
  let ν : FinDist (Fin 2) :=
    { w := ![1, 0]
      nonneg := fun s => by fin_cases s <;> norm_num
      sum_eq_one := by simp [Fin.sum_univ_two] }
  have hfeas : PrimalFeasible F ε μ ν := by
    intro j
    fin_cases j
    change |∑ s : Fin 2, F 0 s * (μ.w s - ν.w s)| ≤ 2 * ε
    have hsum : ∑ s : Fin 2, F 0 s * (μ.w s - ν.w s) = -(δ * t) := by
      simp [F, μ, ν, Fin.sum_univ_two]
      ring
    rw [hsum, abs_neg, abs_mul, abs_of_pos hδ0, abs_of_nonneg ht0]
    calc δ * t ≤ δ * (2 * ε / δ) := mul_le_mul_of_nonneg_left (min_le_right _ _) hδ0.le
      _ = 2 * ε := mul_div_cancel₀ (2 * ε) hδ0.ne'
  have hprimal : primalGap h μ ν = (1 - (1 - δ) ^ n) * min (1 / 2 : ℝ) (ε / δ) := by
    unfold primalGap
    have hsum : ∑ s : Fin 2, h s * (μ.w s - ν.w s) = -((1 - (1 - δ) ^ n) * t) := by
      simp [h, diagSurvivalProb_eq, μ, ν, Fin.sum_univ_two]
      ring
    rw [hsum, abs_neg, abs_mul, abs_of_nonneg hamp_nn, abs_of_nonneg ht0]
    rcases le_total 1 (2 * ε / δ) with hle | hge
    · have ht_eq : t = 1 := min_eq_left hle
      have hmin_eq : min (1 / 2 : ℝ) (ε / δ) = 1 / 2 := by
        apply min_eq_left
        rw [le_div_iff₀ hδ0] at hle
        rw [le_div_iff₀ hδ0]
        linarith
      rw [ht_eq, hmin_eq]
      ring
    · have ht_eq : t = 2 * ε / δ := min_eq_right hge
      have hmin_eq : min (1 / 2 : ℝ) (ε / δ) = ε / δ := by
        apply min_eq_right
        rw [div_le_iff₀ hδ0] at hge
        rw [div_le_iff₀ hδ0]
        linarith
      rw [ht_eq, hmin_eq]
      ring
  rcases le_or_gt δ (2 * ε) with hle | hgt
  · let b : ℝ := (1 + (1 - δ) ^ n) / 2
    let c : Fin 1 → ℝ := ![0]
    have hdual : dualBound F h ε b c = (1 - (1 - δ) ^ n) * min (1 / 2 : ℝ) (ε / δ) := by
      unfold dualBound
      have hmin_eq : min (1 / 2 : ℝ) (ε / δ) = 1 / 2 := by
        apply min_eq_left
        rw [le_div_iff₀ hδ0]
        linarith
      have h0 : |h 0 - b - ∑ j : Fin 1, F j 0 * c j| = (1 - (1 - δ) ^ n) / 2 := by
        simp [h, diagSurvivalProb_eq, F, b, c]
        rw [show (1 : ℝ) - (1 + (1 - δ) ^ n) / 2 = (1 - (1 - δ) ^ n) / 2 by ring]
        exact abs_of_nonneg (by linarith)
      have h1 : |h 1 - b - ∑ j : Fin 1, F j 1 * c j| = (1 - (1 - δ) ^ n) / 2 := by
        simp [h, diagSurvivalProb_eq, F, b, c]
        rw [show (1 - δ) ^ n - (1 + (1 - δ) ^ n) / 2 = -((1 - (1 - δ) ^ n) / 2) by ring, abs_neg]
        exact abs_of_nonneg (by linarith)
      have hsup : (Finset.univ.sup' Finset.univ_nonempty fun s : Fin 2 =>
          |h s - b - ∑ j : Fin 1, F j s * c j|) = (1 - (1 - δ) ^ n) / 2 := by
        apply le_antisymm
        · refine Finset.sup'_le _ _ fun s _ => ?_
          fin_cases s
          · exact h0.le
          · exact h1.le
        · rw [← h0]
          exact Finset.le_sup' (fun s : Fin 2 => |h s - b - ∑ j : Fin 1, F j s * c j|) (Finset.mem_univ 0)
      rw [hsup, hmin_eq]
      simp [c]
      ring
    have heq : primalGap h μ ν = dualBound F h ε b c := hprimal.trans hdual.symm
    exact ⟨μ, ν, b, c, hfeas,
      fun μ' ν' hfeas' => (primalGap_le_dualBound F h ε hfeas' b c).trans heq.symm.le,
      fun b' c' => heq.symm.le.trans (primalGap_le_dualBound F h ε hfeas b' c'),
      hprimal, hdual⟩
  · let b : ℝ := 1 - (1 - (1 - δ) ^ n) / δ
    let c : Fin 1 → ℝ := ![(1 - (1 - δ) ^ n) / δ]
    have hdual : dualBound F h ε b c = (1 - (1 - δ) ^ n) * min (1 / 2 : ℝ) (ε / δ) := by
      unfold dualBound
      have hmin_eq : min (1 / 2 : ℝ) (ε / δ) = ε / δ := by
        apply min_eq_right
        rw [div_le_iff₀ hδ0]
        linarith
      have h0 : |h 0 - b - ∑ j : Fin 1, F j 0 * c j| = 0 := by
        simp [h, diagSurvivalProb_eq, F, b, c]
      have h1 : |h 1 - b - ∑ j : Fin 1, F j 1 * c j| = 0 := by
        simp only [h, diagSurvivalProb_eq, F, b, c, Fin.isValue, Finset.univ_unique,
          Fin.default_eq_zero, Finset.sum_singleton, Matrix.cons_val_one,
          Matrix.cons_val_fin_one, one_ne_zero, ↓reduceIte]
        have hcalc : (1 - δ) ^ n - (1 - (1 - (1 - δ) ^ n) / δ) - (1 - δ) * ((1 - (1 - δ) ^ n) / δ) = 0 := by
          field_simp [hδ0.ne']
          ring
        rw [hcalc, abs_zero]
      have hsup : (Finset.univ.sup' Finset.univ_nonempty fun s : Fin 2 =>
          |h s - b - ∑ j : Fin 1, F j s * c j|) = 0 := by
        apply le_antisymm
        · refine Finset.sup'_le _ _ fun s _ => ?_
          fin_cases s
          · exact h0.le
          · exact h1.le
        · rw [← h0]
          exact Finset.le_sup' (fun s : Fin 2 => |h s - b - ∑ j : Fin 1, F j s * c j|) (Finset.mem_univ 0)
      rw [hsup, zero_add, hmin_eq]
      simp [c, abs_of_nonneg (div_nonneg hamp_nn hδ0.le)]
      ring
    have heq : primalGap h μ ν = dualBound F h ε b c := hprimal.trans hdual.symm
    exact ⟨μ, ν, b, c, hfeas,
      fun μ' ν' hfeas' => (primalGap_le_dualBound F h ε hfeas' b c).trans heq.symm.le,
      fun b' c' => heq.symm.le.trans (primalGap_le_dualBound F h ε hfeas b' c'),
      hprimal, hdual⟩

end ConsequenceDuality
