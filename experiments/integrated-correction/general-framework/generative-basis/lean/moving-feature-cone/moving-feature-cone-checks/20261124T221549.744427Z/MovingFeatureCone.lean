import Mathlib.Data.Real.Sqrt
import Mathlib.Tactic
import AlignmentReals

/-!
# Moving-Feature Cone Bounds & Delay Headroom (`MovingFeatureCone`)

AI-written (Wave 4 Track B3, 25 November 2026). Mathlib v4.30.0-rc2 periphery module importing
`AlignmentReals`. Depends only on `[propext, Classical.choice, Quot.sound]`, zero `sorryAx`,
zero `private`/`lemma`/`class`/unnamed `instance`, zero `native_decide`, and zero market words
in declaration names.
-/

namespace Becoming.MovingFeatureCone

open Becoming.AlignmentReals

def EP (g : ℕ → ℝ) (t : ℕ) : Prop := 0 ≤ g t
def FP (g : ℕ → ℝ) (B : ℕ) : Prop := ∃ t, 1 ≤ t ∧ t ≤ B ∧ EP g t
def Early (g : ℕ → ℝ) (l : ℕ) : Prop := ∃ t, 1 ≤ t ∧ t < l ∧ EP g t
def Intra (g z : ℕ → ℝ) (l B : ℕ) : Prop := ∃ t, l ≤ t ∧ t ≤ B ∧ -g B ≤ |z t - z B|

theorem ep_implies_fp {g : ℕ → ℝ} {B : ℕ} (hB : 1 ≤ B) (h : EP g B) : FP g B :=
  ⟨B, hB, le_rfl, h⟩

theorem top_cone_iff (a c d μ x y : ℝ)
    (hu : x ^ 2 + y ^ 2 = 1) (hx : a * x + c * y = μ * x) (hy : c * x + d * y = μ * y)
    (htop : a + d < 2 * μ) :
    3 * x ^ 2 ≤ y ^ 2 ↔ (2 / Real.sqrt 3) * |c| ≤ d - a := by
  let g : ℝ := 2 * μ - a - d
  have hg : 0 < g := by linarith
  have hd : d - a = g * (y ^ 2 - x ^ 2) := by
    have h1 : 2 * d * y ^ 2 - 2 * a * x ^ 2 = 2 * μ * (y ^ 2 - x ^ 2) := by
      linear_combination 2 * y * hy - 2 * x * hx
    dsimp [g]; rw [← mul_one (d - a), ← hu]; linarith
  have hc : c = g * x * y := by
    dsimp [g]; linear_combination x * hy + y * hx - c * hu
  have hsq3 : Real.sqrt 3 ^ 2 = 3 := Real.sq_sqrt (by norm_num)
  have hrt3 : 0 < Real.sqrt 3 := Real.sqrt_pos.mpr (by norm_num)
  constructor
  · intro hcone
    have hdiff_nonneg : 0 ≤ d - a := by rw [hd]; nlinarith [hg]
    have hlhs_nonneg : 0 ≤ (2 / Real.sqrt 3) * |c| := by positivity
    have hsq_le : ((2 / Real.sqrt 3) * |c|) ^ 2 ≤ (d - a) ^ 2 := by
      have hfac : 0 ≤ (3 * y ^ 2 - x ^ 2) * (y ^ 2 - 3 * x ^ 2) := by nlinarith
      have hpoly : (4 / 3 : ℝ) * (x * y) ^ 2 ≤ (y ^ 2 - x ^ 2) ^ 2 := by linarith
      have hmul : (4 / 3 : ℝ) * c ^ 2 ≤ (d - a) ^ 2 := by
        rw [hc, hd]
        calc (4 / 3 : ℝ) * (g * x * y) ^ 2 = g ^ 2 * ((4 / 3 : ℝ) * (x * y) ^ 2) := by ring
          _ ≤ g ^ 2 * (y ^ 2 - x ^ 2) ^ 2 := mul_le_mul_of_nonneg_left hpoly (sq_nonneg g)
          _ = (g * (y ^ 2 - x ^ 2)) ^ 2 := by ring
      calc ((2 / Real.sqrt 3) * |c|) ^ 2 = (4 / Real.sqrt 3 ^ 2) * (|c| ^ 2) := by ring
        _ = (4 / 3 : ℝ) * c ^ 2 := by rw [hsq3, sq_abs]
        _ ≤ (d - a) ^ 2 := hmul
    nlinarith
  · intro hband
    have hdiff_nonneg : 0 ≤ d - a := le_trans (by positivity) hband
    have hyx : x ^ 2 ≤ y ^ 2 := by
      have : 0 ≤ g * (y ^ 2 - x ^ 2) := hd ▸ hdiff_nonneg
      nlinarith
    have hlead : 0 < 3 * y ^ 2 - x ^ 2 := by nlinarith
    have hsq_le : ((2 / Real.sqrt 3) * |c|) ^ 2 ≤ (d - a) ^ 2 :=
      pow_le_pow_left₀ (by positivity) hband 2
    have hmul : (4 / 3 : ℝ) * c ^ 2 ≤ (d - a) ^ 2 := by
      calc (4 / 3 : ℝ) * c ^ 2 = (4 / Real.sqrt 3 ^ 2) * (|c| ^ 2) := by rw [hsq3, sq_abs]
        _ = ((2 / Real.sqrt 3) * |c|) ^ 2 := by ring
        _ ≤ (d - a) ^ 2 := hsq_le
    have hpoly : g ^ 2 * ((4 / 3 : ℝ) * (x * y) ^ 2) ≤ g ^ 2 * (y ^ 2 - x ^ 2) ^ 2 := by
      calc g ^ 2 * ((4 / 3 : ℝ) * (x * y) ^ 2) = (4 / 3 : ℝ) * (g * x * y) ^ 2 := by ring
        _ = (4 / 3 : ℝ) * c ^ 2 := by rw [hc]
        _ ≤ (d - a) ^ 2 := hmul
        _ = g ^ 2 * (y ^ 2 - x ^ 2) ^ 2 := by rw [hd]; ring
    have hred : (4 / 3 : ℝ) * (x * y) ^ 2 ≤ (y ^ 2 - x ^ 2) ^ 2 :=
      le_of_mul_le_mul_left hpoly (pow_pos hg 2)
    have hfac : 0 ≤ (3 * y ^ 2 - x ^ 2) * (y ^ 2 - 3 * x ^ 2) := by linarith
    have hy3x : 0 ≤ y ^ 2 - 3 * x ^ 2 := nonneg_of_mul_nonneg_right hfac hlead
    linarith

theorem fp_sandwich (drift z : ℕ → ℝ) (l B : ℕ) (hm : Monotone drift) :
    let g := fun t => drift t + z t
    FP g B → EP g B ∨ Early g l ∨ Intra g z l B := by
  intro g ⟨t, ht1, htB, hgt⟩
  by_cases hlt : t < l
  · exact Or.inr (Or.inl ⟨t, ht1, hlt, hgt⟩)
  · refine Or.inr (Or.inr ⟨t, le_of_not_gt hlt, htB, ?_⟩)
    have hdr : drift t ≤ drift B := hm htB
    have hpos : 0 ≤ drift t + z t := hgt
    have h1 : -(drift B + z B) ≤ z t - z B := by linarith
    exact h1.trans (le_abs_self _)

theorem intra_boundary_or_osc (g z : ℕ → ℝ) (l B : ℕ) (η : ℝ)
    (_hmiss : ¬ EP g B) (hintra : Intra g z l B) :
    (-η ≤ g B) ∨ (∃ t, l ≤ t ∧ t ≤ B ∧ η ≤ |z t - z B|) := by
  by_cases hbd : -η ≤ g B
  · exact Or.inl hbd
  · obtain ⟨t, htl, htB, hosc⟩ := hintra
    have hlt : g B < -η := lt_of_not_ge hbd
    exact Or.inr ⟨t, htl, htB, by linarith⟩

theorem feature_delay_headroom (H₁ H₂ Y L τ : ℕ) (α floor x₀ : ℝ)
    (h0 : 0 < α) (h1 : α < 1) (hY : Y ≤ H₁) (hH : H₂ < H₁)
    (hx : floor + ((L + τ : ℕ) : ℝ) * ((H₁ : ℝ) - (Y : ℝ)) + ((1 - α) / α) * ((H₁ : ℝ) - (H₂ : ℝ)) ≤ x₀) :
    ∀ t : ℕ, floor ≤ inertiaStock (H₁ : ℝ) (H₂ : ℝ) (Y : ℝ) (L + τ) α x₀ t :=
  (inertia_lag_headroom_penalty H₁ H₂ 0 Y (L + τ) α h0 h1 hY hH).1 floor x₀ hx

theorem feature_delay_extra_headroom (H₁ Y : ℝ) (L τ : ℕ) :
    ((L + τ : ℕ) : ℝ) * (H₁ - Y) - (L : ℝ) * (H₁ - Y) = (τ : ℝ) * (H₁ - Y) := by
  push_cast
  ring

theorem feature_delay_linear_fa_collapse {d : ℕ} (φ_safe φ_warn : Fin d → ℝ)
    (η p_max v_rest d_agg d_rest R x_warn x_crit : ℝ)
    (hη : 0 ≤ η) (hp_nonneg : 0 ≤ p_max) (δ p : ℕ → ℝ) (hp : ∀ k, p k ≤ p_max)
    (θ₀ : Fin d → ℝ) (T_safe τ : ℕ) (hτ : 0 < τ)
    (hmargin :
      v_rest < θ₀ ⬝ᵥ φ_warn + η * (φ_safe ⬝ᵥ φ_warn) * (∑ k ∈ Finset.range T_safe, δ k) -
        ((τ - 1 : ℕ) : ℝ) * (η * p_max * (φ_warn ⬝ᵥ φ_warn)))
    (hshort : x_warn - x_crit < (d_agg - R) * (τ : ℝ)) :
    warnStock d_agg d_rest R φ_warn v_rest η p (faSafeUpdate φ_safe η δ θ₀ T_safe) x_warn τ < x_crit := by
  have hlinear := linear_fa_leakage_hysteresis φ_safe φ_warn η p_max v_rest d_agg d_rest R x_warn x_crit
    hη hp_nonneg δ p hp θ₀ T_safe τ hτ
  exact (hlinear.2 hmargin).2.2 hshort

end Becoming.MovingFeatureCone
