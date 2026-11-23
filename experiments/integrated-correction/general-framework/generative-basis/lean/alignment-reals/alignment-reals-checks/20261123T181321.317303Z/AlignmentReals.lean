import Mathlib.Algebra.Order.Field.GeomSum
import Mathlib.Algebra.Order.Floor.Semiring
import Mathlib.Analysis.SpecificLimits.Basic
import Mathlib.Data.Real.Archimedean
import Mathlib.Data.Matrix.Mul
import Mathlib.Topology.MetricSpace.Pseudo.Defs
import Mathlib.Tactic
import Becoming.PacedStock
import Becoming.AdaptiveLoops
import Becoming.MultiScaleViability

/-!
# Alignment over the reals: inertia, stochastic delay, metric lax tubes, and feature leakage

AI-written, 23 November 2026.

This periphery module extends the pure `Nat`-level Becoming core (`Becoming.PacedStock`,
`Becoming.AdaptiveLoops`, `Becoming.MultiScaleViability`) over Mathlib's `ℝ` in four directions:

1. **Policy inertia lag headroom penalty (`inertiaWeight`, `inertiaStock`,
   `inertia_lag_headroom_penalty`, `inertia_witness_phase2`).** Exponential blending of a
   transitioning draw rule with rate `α ∈ (0, 1)` adds a cumulative lag drawdown bounded by
   `((1 - α) / α) * (H₁ - H₂)`. When `H₁ + L * Y < ((1 - α) / α) * (H₁ - H₂)`, the deterministic
   `Becoming.PacedStock.pace_margin_feasibility_window` buffer `b_feas = (H₂ + y₂) + H₁ * (L + 1)`
   is breached below `H₂ + y₂` in finite time.
2. **Finite-distribution stochastic delay and demand-shock headroom (`FiniteLaw`, `markov_prob_ge`,
   `markov_survival_sufficient`, `reverse_markov_failure_bound`, `spike_threshold_survival_upper`,
   `survProb`, `productBoolLaw`, `stochastic_delay_survival_bound`).** Distribution-free Markov
   and reverse-Markov bounds, exact binomial survival recurrence over `Fin n → Bool`, and bridges to
   `Becoming.PacedStock.unrecoverable_cadence_impossibility` and `Becoming.RegimeMargin.falls_within`.
3. **Continuous metric `LaxSim` contraction tubes (`MetricLaxSim`, `metric_laxSim_contraction_tube`,
   `scaledSlackDist`, `toDiscreteLaxSim`, `metric_to_discrete_kernel`,
   `metric_to_discrete_kernel_of_strict_margin`).** Real-valued `(α, ε)` contraction and `(β, η)`
   inter-sample excursions certify `Becoming.Viability.Kernel` directly over `ℝ` and round cleanly
   onto `Becoming.LaxSim` via `Becoming.lax_kernel_of_certificate` with zero rounding loss on
   `α * Δ_nat`.
4. **Linear function-approximation feature-leakage hysteresis (`faSafeUpdate`, `faWarnUpdate`,
   `linear_fa_margin_shift`, `linear_fa_leakage_hysteresis`, `linear_fa_witness_rho_4_5`).**
   Coupling `φ_safe` and `φ_warn` with inner product `ρ = φ_safe ⬝ᵥ φ_warn` leaks safe-phase
   updates into the warning classifier, inducing a finite switchover delay `M_delay`. Instantiated
   on an explicit `Becoming.AdaptiveLoops.OpenLoop (Fin 2 → ℝ) Bool Unit Unit` and `jointProcess`,
   `ρ = 0` satisfies `Becoming.AdaptiveLoops.assume_guarantee_joint_kernel` (`maxLag = 0`), while
   `ρ = 4/5` crashes below `x_crit = 5` at step `18` (`x = 4`) and violates `warn_margin` for
   `18 ≤ maxLag`.

Every declaration is named and non-private, uses only Lean's standard axioms
(`propext`, `Classical.choice`, `Quot.sound`) through Mathlib, and contains zero `sorry`.
-/

namespace Becoming.AlignmentReals

universe u v w z

/-! ## Section 1: Policy Inertia Lag Headroom Penalty over `ℝ` -/

/-- Exponential policy-blending weight starting at `0` and approaching `1` at rate `α`. -/
noncomputable def inertiaWeight (α : ℝ) : ℕ → ℝ
  | 0 => 0
  | t + 1 => (1 - α) * inertiaWeight α t + α * 1

/-- Blended draw between `d_high` and `d_safe` at policy weight `u`. -/
noncomputable def blendedDraw (d_high d_safe u : ℝ) : ℝ :=
  (1 - u) * d_high + u * d_safe

/-- Stock trajectory under `L` steps of net drain `H₁ - Y` followed by blended recovery draw `H₁ → H₂`. -/
noncomputable def inertiaStock (H₁ H₂ Y : ℝ) (L : ℕ) (α x₀ : ℝ) : ℕ → ℝ
  | 0 => x₀
  | t + 1 =>
    if t < L then inertiaStock H₁ H₂ Y L α x₀ t - (H₁ - Y)
    else inertiaStock H₁ H₂ Y L α x₀ t - (blendedDraw H₁ H₂ (inertiaWeight α (t - L + 1)) - H₂)

theorem inertia_error_closed_form (α : ℝ) : ∀ t : ℕ, 1 - inertiaWeight α t = (1 - α) ^ t
  | 0 => by simp [inertiaWeight]
  | t + 1 => by
    have ih := inertia_error_closed_form α t
    simp only [inertiaWeight]
    calc
      1 - ((1 - α) * inertiaWeight α t + α * 1)
          = (1 - α) * (1 - inertiaWeight α t) := by ring
      _ = (1 - α) * (1 - α) ^ t := by rw [ih]
      _ = (1 - α) ^ (t + 1) := by rw [pow_succ']

theorem blendedDraw_sub_safe (d_high d_safe u : ℝ) :
    blendedDraw d_high d_safe u - d_safe = (d_high - d_safe) * (1 - u) := by
  simp only [blendedDraw]
  ring

theorem inertia_excess_draw_eq (d_high d_safe α : ℝ) (hα : α ≠ 0) (k : ℕ) :
    ∑ t ∈ Finset.range k, (blendedDraw d_high d_safe (inertiaWeight α t) - d_safe) =
      (d_high - d_safe) * ((1 - (1 - α) ^ k) / α) := by
  have h1α : (1 - α) ≠ 1 := by
    intro h
    apply hα
    linarith
  have hsum :
      ∑ t ∈ Finset.range k, (blendedDraw d_high d_safe (inertiaWeight α t) - d_safe) =
        (d_high - d_safe) * ∑ t ∈ Finset.range k, (1 - α) ^ t := by
    rw [Finset.mul_sum]
    refine Finset.sum_congr rfl fun t _ => ?_
    rw [blendedDraw_sub_safe, inertia_error_closed_form]
  rw [hsum, geom_sum_eq h1α k]
  field_simp [hα, sub_ne_zero.mpr h1α]
  ring

theorem inertia_excess_draw_shifted_eq (d_high d_safe α : ℝ) (hα : α ≠ 0) (k : ℕ) :
    ∑ t ∈ Finset.range k, (blendedDraw d_high d_safe (inertiaWeight α (t + 1)) - d_safe) =
      (d_high - d_safe) * ((1 - α) * (1 - (1 - α) ^ k) / α) := by
  have h1α : (1 - α) ≠ 1 := by
    intro h
    apply hα
    linarith
  have hsum :
      ∑ t ∈ Finset.range k, (blendedDraw d_high d_safe (inertiaWeight α (t + 1)) - d_safe) =
        (d_high - d_safe) * (1 - α) * ∑ t ∈ Finset.range k, (1 - α) ^ t := by
    rw [Finset.mul_sum]
    refine Finset.sum_congr rfl fun t _ => ?_
    rw [blendedDraw_sub_safe, inertia_error_closed_form, pow_succ']
    ring
  rw [hsum, geom_sum_eq h1α k]
  field_simp [hα, sub_ne_zero.mpr h1α]
  ring

theorem inertia_excess_draw_lt (d_high d_safe α : ℝ)
    (hd : d_safe < d_high) (hα0 : 0 < α) (hα1 : α < 1) (k : ℕ) :
    ∑ t ∈ Finset.range k, (blendedDraw d_high d_safe (inertiaWeight α t) - d_safe) <
      (d_high - d_safe) / α := by
  rw [inertia_excess_draw_eq d_high d_safe α hα0.ne' k]
  have hpow : 0 < (1 - α) ^ k := pow_pos (sub_pos.mpr hα1) k
  have hnum : (1 - (1 - α) ^ k) / α < 1 / α :=
    div_lt_div_of_pos_right (by linarith) hα0
  calc
    (d_high - d_safe) * ((1 - (1 - α) ^ k) / α)
        < (d_high - d_safe) * (1 / α) := mul_lt_mul_of_pos_left hnum (sub_pos.mpr hd)
    _ = (d_high - d_safe) / α := by ring

theorem inertia_excess_draw_shifted_lt (d_high d_safe α : ℝ)
    (hd : d_safe < d_high) (hα0 : 0 < α) (hα1 : α < 1) (k : ℕ) :
    ∑ t ∈ Finset.range k, (blendedDraw d_high d_safe (inertiaWeight α (t + 1)) - d_safe) <
      ((1 - α) / α) * (d_high - d_safe) := by
  rw [inertia_excess_draw_shifted_eq d_high d_safe α hα0.ne' k]
  have hpow : 0 < (1 - α) ^ k := pow_pos (sub_pos.mpr hα1) k
  have h1α : 0 < 1 - α := sub_pos.mpr hα1
  have hnum : (1 - α) * (1 - (1 - α) ^ k) / α < (1 - α) / α :=
    div_lt_div_of_pos_right (by nlinarith) hα0
  calc
    (d_high - d_safe) * ((1 - α) * (1 - (1 - α) ^ k) / α)
        < (d_high - d_safe) * ((1 - α) / α) := mul_lt_mul_of_pos_left hnum (sub_pos.mpr hd)
    _ = ((1 - α) / α) * (d_high - d_safe) := by ring

theorem inertia_stock_prefix (H₁ H₂ Y : ℝ) (L : ℕ) (α x₀ : ℝ) :
    ∀ t : ℕ, t ≤ L → inertiaStock H₁ H₂ Y L α x₀ t = x₀ - (t : ℝ) * (H₁ - Y)
  | 0, _ => by simp [inertiaStock]
  | t + 1, ht => by
    have htL : t < L := _root_.Nat.lt_of_succ_le ht
    have ih := inertia_stock_prefix H₁ H₂ Y L α x₀ t (_root_.Nat.le_of_lt htL)
    simp only [inertiaStock, if_pos htL, ih, Nat.cast_succ]
    ring

theorem inertia_stock_eq_sum (H₁ H₂ Y : ℝ) (L : ℕ) (α x₀ : ℝ) :
    ∀ k : ℕ, inertiaStock H₁ H₂ Y L α x₀ (L + k) =
      x₀ - (L : ℝ) * (H₁ - Y) -
        ∑ t ∈ Finset.range k, (blendedDraw H₁ H₂ (inertiaWeight α (t + 1)) - H₂)
  | 0 => by
    simpa using inertia_stock_prefix H₁ H₂ Y L α x₀ L (_root_.Nat.le_refl L)
  | k + 1 => by
    have ih := inertia_stock_eq_sum H₁ H₂ Y L α x₀ k
    have hnot : ¬ L + k < L := _root_.Nat.not_lt_of_ge (_root_.Nat.le_add_right L k)
    have hind : L + k - L + 1 = k + 1 := by omega
    rw [show L + (k + 1) = (L + k) + 1 from rfl]
    simp only [inertiaStock, if_neg hnot, hind, ih, Finset.sum_range_succ]
    ring

theorem inertia_stock_closed_form (H₁ H₂ Y : ℝ) (L : ℕ) {α : ℝ} (hα : α ≠ 0) (x₀ : ℝ) (k : ℕ) :
    inertiaStock H₁ H₂ Y L α x₀ (L + k) =
      x₀ - (L : ℝ) * (H₁ - Y) - (H₁ - H₂) * ((1 - α) * (1 - (1 - α) ^ k) / α) := by
  rw [inertia_stock_eq_sum, inertia_excess_draw_shifted_eq H₁ H₂ α hα k]

/-- **Theorem 1 (`inertia_lag_headroom_penalty`).**
1. Sufficiency: an extra lag buffer `((1 - α) / α) * (H₁ - H₂)` above `floor + L * (H₁ - Y)` keeps
   `inertiaStock` at or above `floor` for all `t`.
2. Strict breach of the deterministic feasibility threshold `b_feas := (H₂ + y₂) + H₁ * (L + 1)` from
   `Becoming.PacedStock.pace_margin_feasibility_window`: whenever
   `H₁ + L * Y < ((1 - α) / α) * (H₁ - H₂)`, `inertiaStock` drops strictly below `H₂ + y₂` in
   finite time. -/
theorem inertia_lag_headroom_penalty (H₁ H₂ y₂ Y L : ℕ) (α : ℝ)
    (hα0 : 0 < α) (hα1 : α < 1) (hHY : Y ≤ H₁) (hH : H₂ < H₁) :
    (∀ floor x₀ : ℝ,
      floor + (L : ℝ) * ((H₁ : ℝ) - (Y : ℝ)) + ((1 - α) / α) * ((H₁ : ℝ) - (H₂ : ℝ)) ≤ x₀ →
      ∀ t : ℕ, floor ≤ inertiaStock (H₁ : ℝ) (H₂ : ℝ) (Y : ℝ) L α x₀ t) ∧
    ((H₁ : ℝ) + (L : ℝ) * (Y : ℝ) < ((1 - α) / α) * ((H₁ : ℝ) - (H₂ : ℝ)) →
      ∃ t : ℕ, inertiaStock (H₁ : ℝ) (H₂ : ℝ) (Y : ℝ) L α
        (((H₂ + y₂) + H₁ * (L + 1) : ℕ) : ℝ) t < ((H₂ + y₂ : ℕ) : ℝ)) := by
  have hH_real : (H₂ : ℝ) < (H₁ : ℝ) := Nat.cast_lt.mpr hH
  have hHY_real : (Y : ℝ) ≤ (H₁ : ℝ) := Nat.cast_le.mpr hHY
  constructor
  · intro floor x₀ hx₀ t
    rcases _root_.Nat.lt_or_ge t L with htL | htL
    · rw [inertia_stock_prefix _ _ _ L α x₀ t (_root_.Nat.le_of_lt htL)]
      have ht_le : (t : ℝ) ≤ (L : ℝ) := Nat.cast_le.mpr (_root_.Nat.le_of_lt htL)
      have hHY_nonneg : 0 ≤ (H₁ : ℝ) - (Y : ℝ) := sub_nonneg.mpr hHY_real
      have hlag_nonneg : 0 ≤ ((1 - α) / α) * ((H₁ : ℝ) - (H₂ : ℝ)) :=
        mul_nonneg (div_nonneg (sub_nonneg.mpr hα1.le) hα0.le) (sub_nonneg.mpr hH_real.le)
      have h1 : (t : ℝ) * ((H₁ : ℝ) - (Y : ℝ)) ≤ (L : ℝ) * ((H₁ : ℝ) - (Y : ℝ)) :=
        mul_le_mul_of_nonneg_right ht_le hHY_nonneg
      linarith
    · obtain ⟨k, rfl⟩ := _root_.Nat.exists_eq_add_of_le htL
      rw [inertia_stock_eq_sum]
      have hex := inertia_excess_draw_shifted_lt (H₁ : ℝ) (H₂ : ℝ) α hH_real hα0 hα1 k
      linarith
  · intro hthresh
    let pen := ((1 - α) / α) * ((H₁ : ℝ) - (H₂ : ℝ))
    let gap := pen - ((H₁ : ℝ) + (L : ℝ) * (Y : ℝ))
    have hgap : 0 < gap := sub_pos.mpr hthresh
    have hpen : 0 < pen := mul_pos (div_pos (sub_pos.mpr hα1) hα0) (sub_pos.mpr hH_real)
    obtain ⟨k, hk⟩ := exists_pow_lt_of_lt_one (div_pos hgap hpen) (by linarith : 1 - α < 1)
    have hk_mul : pen * (1 - α) ^ k < gap := by
      have := mul_lt_mul_of_pos_left hk hpen
      rwa [mul_div_cancel₀ _ hpen.ne'] at this
    refine ⟨L + k, ?_⟩
    rw [inertia_stock_closed_form (H₁ : ℝ) (H₂ : ℝ) (Y : ℝ) L hα0.ne']
    have hcast :
        ((((H₂ + y₂) + H₁ * (L + 1) : ℕ) : ℝ)) =
          ((H₂ + y₂ : ℕ) : ℝ) + (H₁ : ℝ) * ((L : ℝ) + 1) := by
      push_cast
      ring
    rw [hcast]
    have hpen_eq :
        ((H₁ : ℝ) - (H₂ : ℝ)) * ((1 - α) * (1 - (1 - α) ^ k) / α) =
          pen - pen * (1 - α) ^ k := by
      simp only [pen]
      ring
    rw [hpen_eq]
    have hsub :
        ((H₂ + y₂ : ℕ) : ℝ) + (H₁ : ℝ) * ((L : ℝ) + 1) - (L : ℝ) * ((H₁ : ℝ) - (Y : ℝ)) -
            (pen - pen * (1 - α) ^ k) =
          ((H₂ + y₂ : ℕ) : ℝ) - (gap - pen * (1 - α) ^ k) := by
      simp only [gap]
      ring
    rw [hsub]
    linarith

/-- Direct contrast with `Becoming.PacedStock.pace_margin_feasibility_window` at the deterministic
lag buffer `b_feas := (H₂ + y₂) + H₁ * (L + 1)`: deterministic switching keeps `H₂ + y₂ ≤ x`
forever for `t ≥ L + 1`, while exponential policy inertia `α` violates `H₂ + y₂` when
`H₁ + L * Y < ((1 - α) / α) * (H₁ - H₂)`. -/
theorem inertia_lag_contrasts_pace_window {A U R O : Type}
    {fA : A → R → A} {need : U → ℕ} {kids : R → U → List U}
    {giving : ℕ → ℕ} {use : U → ℕ}
    {h : Becoming.PacedStock.StockState A U → R → R} {reads : ℕ → Bool} {σ : ℕ → ℕ}
    {N L H₁ H₂ y₂ hi Y : ℕ} {x_o y_o : O} (two : x_o ≠ y_o)
    (σ0 : σ 0 = 0) (σ1 : σ 1 = L)
    (strict : Becoming.Strict σ) (cadence : Becoming.PacedStock.ReadAtSpanEnd σ reads)
    (paceOK : 2 * N - 1 ≤ L)
    {a₀ : A} {w₀ : List U} {g_bad g_safe : R}
    (high0 : (H₂ + y₂) + H₁ * (L + 1) ≤ hi)
    (keeps0 : Becoming.RegimeMargin.Keeps giving 0 hi)
    (short2 : Becoming.RegimeMargin.Short giving H₂ y₂)
    (meets2 : Becoming.RegimeMargin.Meets giving H₂ y₂ hi)
    (keeps2 : Becoming.RegimeMargin.Keeps giving H₂ hi)
    (room : H₂ + H₂ + y₂ ≤ hi)
    (needsPos : ∀ u, 0 < need u ∧ need u ≤ H₂ + y₂)
    (ne0 : w₀ ≠ [])
    (hasKids : ∀ g u, kids g u ≠ [])
    (safeEntry : Becoming.LineOnAStock.taken use
      (Becoming.LineOnAStock.allKids (kids g_safe)
        (Becoming.LineOnAStock.generation (kids g_bad) L w₀)) ≤ H₂)
    (safeClose : ∀ w, Becoming.LineOnAStock.taken use w ≤ H₂ →
      Becoming.LineOnAStock.taken use (Becoming.LineOnAStock.allKids (kids g_safe) w) ≤ H₂)
    (upperBad : Becoming.PacedStock.UpperDraw need use kids giving H₁ g_bad w₀
      ((H₂ + y₂) + H₁ * (L + 1)) (L + 1))
    (switches : (Becoming.PacedStock.pacedCourse fA need kids giving use h reads
      ((a₀, (w₀, (H₂ + y₂) + H₁ * (L + 1))), g_bad) (σ 1)).2 = g_safe)
    (persists : ∀ s, h s g_safe = g_safe)
    (α : ℝ) (hα0 : 0 < α) (hα1 : α < 1) (hHY : Y ≤ H₁) (hH : H₂ < H₁)
    (hthresh : (H₁ : ℝ) + (L : ℝ) * (Y : ℝ) < ((1 - α) / α) * ((H₁ : ℝ) - (H₂ : ℝ))) :
    Becoming.Pace.StretchFixes O N L ∧
      (∀ t, L + 1 ≤ t →
        H₂ + y₂ ≤ (Becoming.PacedStock.pacedCourse fA need kids giving use h reads
          ((a₀, (w₀, (H₂ + y₂) + H₁ * (L + 1))), g_bad) t).1.2.2 ∧
        (Becoming.PacedStock.pacedCourse fA need kids giving use h reads
          ((a₀, (w₀, (H₂ + y₂) + H₁ * (L + 1))), g_bad) t).1.2.2 ≤ hi ∧
        Becoming.LineOnAStock.Goes need (Becoming.PacedStock.pacedCourse fA need kids giving use h
          reads ((a₀, (w₀, (H₂ + y₂) + H₁ * (L + 1))), g_bad) t).1.2) ∧
      ∃ t : ℕ, inertiaStock (H₁ : ℝ) (H₂ : ℝ) (Y : ℝ) L α
        (((H₂ + y₂) + H₁ * (L + 1) : ℕ) : ℝ) t < ((H₂ + y₂ : ℕ) : ℝ) := by
  have hpace := Becoming.PacedStock.pace_margin_feasibility_window two σ0 σ1 strict cadence paceOK
    high0 keeps0 short2 meets2 keeps2 room needsPos ne0 hasKids safeEntry safeClose upperBad
    (_root_.Nat.le_refl _) switches persists
  exact ⟨hpace.1, hpace.2,
    (inertia_lag_headroom_penalty H₁ H₂ y₂ Y L α hα0 hα1 hHY hH).2 hthresh⟩

/-! ### Phase 2 Witness for Theorem 1 (`N = 3, L = 5, H₁ = 4, H₂ = 1, y₂ = 2, x₀ = 27`) -/

/-- Two unit modes for the Phase 2 policy-inertia / stochastic witness (`bad` uses `4`, `safe` uses `1`). -/
inductive P2Unit where
  | bad
  | safe
  deriving DecidableEq

/-- Unit need (`1`) for Phase 2 witness. -/
def p2Need (_ : P2Unit) : ℕ := 1

/-- Unit draw (`4` for `bad`, `1` for `safe`). -/
def p2Use : P2Unit → ℕ
  | .bad => 4
  | .safe => 1

/-- Replacement rule: `(0, 2)` spawns `[.safe]`, all others `[.bad]`. -/
def p2Kids (g : ℕ × ℕ) (_ : P2Unit) : List P2Unit :=
  if g = (0, 2) then [.safe] else [.bad]

/-- Phase 2 substrate renewal (`Y = 1` from `z ≥ 2`, `0` below `2`, capped at `hi = 60`). -/
def p2Giving (z : ℕ) : ℕ :=
  if 2 ≤ z then min 1 (60 - z) else 0

/-- Phase 2 rule update switching from `(1, 1)` to `(0, 2)` at `s.1 = 2` (observed at `t = 4`). -/
def p2RuleH (s : Becoming.PacedStock.StockState ℕ P2Unit) (g : ℕ × ℕ) : ℕ × ℕ :=
  if g = (0, 2) then (0, 2) else if s.1 = 2 then (0, 2) else g

/-- Concrete `PacedStock.pacedCourse` for `(N = 3, L = 5, H₁ = 4, H₂ = 1, y₂ = 2, x₀ = 27)`. -/
def p2Course (t : ℕ) : Becoming.PacedStock.StockState ℕ P2Unit × (ℕ × ℕ) :=
  Becoming.PacedStock.pacedCourse Becoming.Pace.lassoStep p2Need p2Kids p2Giving p2Use p2RuleH
    (Becoming.PacedStock.SandwichWitness.periodReads 4) ((0, ([.bad], 27)), (1, 1)) t

theorem p2Giving_fromNothing : Becoming.RegimeMargin.FromNothing p2Giving := rfl

theorem p2Giving_atMost1 : Becoming.RegimeMargin.AtMost p2Giving 1 := fun z => by
  dsimp [p2Giving]
  split_ifs <;> omega

theorem p2Giving_short1 : Becoming.RegimeMargin.Short p2Giving 1 2 := fun z hz => by
  dsimp [p2Giving]
  split_ifs <;> omega

theorem p2Giving_meets1 : Becoming.RegimeMargin.Meets p2Giving 1 2 60 := fun z hz1 hz2 => by
  dsimp [p2Giving]
  rw [if_pos hz1]
  omega

theorem p2Giving_keeps0 : Becoming.RegimeMargin.Keeps p2Giving 0 60 := fun x hx => by
  dsimp [Becoming.RegimeMargin.step, p2Giving]
  split_ifs <;> omega

theorem p2Giving_keeps1 : Becoming.RegimeMargin.Keeps p2Giving 1 60 := fun x hx => by
  dsimp [Becoming.RegimeMargin.step, p2Giving]
  split_ifs <;> omega

theorem p2Course_len_le_one (g : ℕ × ℕ) (x₀ : ℕ) :
    ∀ t, (Becoming.LineOnAStock.course p2Need (p2Kids g) p2Giving p2Use ([.bad], x₀) t).1.length ≤ 1
  | 0 => _root_.Nat.le_refl 1
  | t + 1 => by
    have ih := p2Course_len_le_one g x₀ t
    dsimp [Becoming.LineOnAStock.course, Becoming.Law.orbit, Becoming.LineOnAStock.step,
      Becoming.TurningInTime.pair]
    match hw : (Becoming.LineOnAStock.course p2Need (p2Kids g) p2Giving p2Use ([.bad], x₀) t).1, ih with
    | [], _ => simp [Becoming.LineOnAStock.after]
    | [u], _ =>
      dsimp [Becoming.LineOnAStock.after]
      cases decide (p2Need u ≤
          (Becoming.LineOnAStock.course p2Need (p2Kids g) p2Giving p2Use ([.bad], x₀) t).2) <;>
        simp [p2Kids]
      split_ifs <;> simp
    | _ :: _ :: _, hlen =>
      simp at hlen

theorem p2_upper_draw_4 (g : ℕ × ℕ) (x₀ k : ℕ) :
    Becoming.PacedStock.UpperDraw p2Need p2Use p2Kids p2Giving 4 g [.bad] x₀ k := by
  intro t _
  have hlen := p2Course_len_le_one g x₀ t
  match hw : (Becoming.LineOnAStock.course p2Need (p2Kids g) p2Giving p2Use ([.bad], x₀) t).1, hlen with
  | [], _ => simp [Becoming.LineOnAStock.taken, Becoming.total]
  | [u], _ =>
    cases u <;> simp [Becoming.LineOnAStock.taken, Becoming.total, p2Use]
  | _ :: _ :: _, h =>
    simp at h

theorem p2_safeClose (w : List P2Unit) (hw : Becoming.LineOnAStock.taken p2Use w ≤ 1) :
    Becoming.LineOnAStock.taken p2Use (Becoming.LineOnAStock.allKids (p2Kids (0, 2)) w) ≤ 1 := by
  cases w with
  | nil => simp [Becoming.LineOnAStock.allKids, Becoming.LineOnAStock.taken, Becoming.total]
  | cons u rest =>
    cases rest with
    | nil =>
      simp [Becoming.LineOnAStock.allKids, p2Kids, Becoming.LineOnAStock.taken, Becoming.total,
        p2Use]
    | cons v vs =>
      have hu : 1 ≤ p2Use u := by cases u <;> decide
      have hv : 1 ≤ p2Use v := by cases v <;> decide
      have hge : 2 ≤ Becoming.LineOnAStock.taken p2Use (u :: v :: vs) := by
        simp only [Becoming.LineOnAStock.taken, Becoming.total]
        omega
      omega

theorem p2Course_after_six : ∀ m : ℕ, (p2Course (6 + m)).1.2 = ([.safe], 9) ∧ (p2Course (6 + m)).2 = (0, 2)
  | 0 => ⟨rfl, rfl⟩
  | m + 1 => by
    have ih := p2Course_after_six m
    dsimp only [p2Course, Becoming.PacedStock.pacedCourse] at ih ⊢
    rw [(_root_.Nat.add_assoc 6 m 1).symm,
      Becoming.Pace.paced_succ
        (f := Becoming.PacedStock.fineStep Becoming.Pace.lassoStep p2Need p2Kids p2Giving p2Use)
        (h := p2RuleH)
        (reads := Becoming.PacedStock.SandwichWitness.periodReads 4)
        ((0, ([P2Unit.bad], 27)), (1, 1)) (6 + m)]
    rcases ih with ⟨hst, hrule⟩
    cases Becoming.PacedStock.SandwichWitness.periodReads 4 (6 + m) with
    | false =>
      simp only [Becoming.Pace.turn, Becoming.PacedStock.fineStep, hst, hrule]
      exact ⟨rfl, trivial⟩
    | true =>
      simp only [Becoming.Pace.turn, Becoming.PacedStock.fineStep, hst, hrule]
      exact ⟨rfl, rfl⟩

/-- **Phase 2 Witness (`inertia_witness_phase2`)** on `(N = 3, L = 5, H₁ = 4, H₂ = 1, y₂ = 2, x₀ = 27)`:
1. Instantiates `Becoming.PacedStock.pace_margin_feasibility_window`, proving `Pace.StretchFixes Bool 3 5`
   and permanent viability `≥ 3` for `t ≥ 6`, noting the 1-step way-replacement lag
   (`x₅ = 12` at rule switch, `x₆ = 9` once `[.bad]` is replaced by `[.safe]`, holding at `9` forever).
2. With `α = 1` (zero inertia), `inertiaStock` stays at `12` from `t = 5` onward.
3. With `α = 1/8` at `x₀ = 27`, `inertiaStock` equals `58035 / 32768 < 3` at `t = 10` and drops
   `< 0` at `t = 12` and `t = 21`.
4. With `α = 1/8` at the lag-compensated budget `x₀ = 39`, `3 ≤ inertiaStock` holds for all `t`. -/
theorem inertia_witness_phase2 :
    Becoming.Pace.StretchFixes Bool 3 5 ∧
      (∀ t, 6 ≤ t → 3 ≤ (p2Course t).1.2.2 ∧ (p2Course t).1.2.2 ≤ 60 ∧
        Becoming.LineOnAStock.Goes p2Need (p2Course t).1.2) ∧
      ((p2Course 5).1.2.2 = 12 ∧ (p2Course 6).1.2.2 = 9 ∧ ∀ t, 6 ≤ t → (p2Course t).1.2.2 = 9) ∧
      (∀ t, 12 ≤ inertiaStock 4 1 1 5 1 27 t) ∧
      (inertiaStock 4 1 1 5 (1 / 8) 27 10 = 58035 / 32768 ∧
        inertiaStock 4 1 1 5 (1 / 8) 27 10 < 3 ∧
        inertiaStock 4 1 1 5 (1 / 8) 27 12 < 0 ∧
        inertiaStock 4 1 1 5 (1 / 8) 27 21 < 0) ∧
      (∀ t, 3 ≤ inertiaStock 4 1 1 5 (1 / 8) 39 t) := by
  have hpace := Becoming.PacedStock.pace_margin_feasibility_window
    (N := 3) (L := 5) (H₁ := 4) (H₂ := 1) (y₂ := 2) (hi := 60)
    (σ := Becoming.PacedStock.SandwichWitness.periodSigma 4)
    (reads := Becoming.PacedStock.SandwichWitness.periodReads 4)
    (h := p2RuleH) (need := p2Need) (kids := p2Kids) (giving := p2Giving) (use := p2Use)
    (fA := Becoming.Pace.lassoStep) (a₀ := 0) (w₀ := [.bad]) (x₀ := 27)
    (g_bad := (1, 1)) (g_safe := (0, 2))
    Bool.false_ne_true rfl rfl
    (Becoming.PacedStock.SandwichWitness.periodSigma_strict 4)
    (Becoming.PacedStock.SandwichWitness.periodReads_cadence 4)
    (by decide) (by decide) p2Giving_keeps0 p2Giving_short1 p2Giving_meets1 p2Giving_keeps1
    (by decide) (fun u => ⟨_root_.Nat.succ_pos 0, by cases u <;> decide⟩) (List.cons_ne_nil _ _)
    (fun g _ => by dsimp [p2Kids]; split_ifs <;> simp)
    (by decide) p2_safeClose (p2_upper_draw_4 (1, 1) 27 6) (by decide) rfl
    (fun s => by simp [p2RuleH])
  have hlag : ∀ t, 6 ≤ t → (p2Course t).1.2.2 = 9 := fun t ht => by
    obtain ⟨m, rfl⟩ := _root_.Nat.exists_eq_add_of_le ht
    exact congrArg Prod.snd (p2Course_after_six m).1
  have h1 : ∀ t, 12 ≤ inertiaStock 4 1 1 5 1 27 t := fun t => by
    rcases _root_.Nat.lt_or_ge t 5 with ht | ht
    · rw [inertia_stock_prefix 4 1 1 5 1 27 t (_root_.Nat.le_of_lt ht)]
      have hcast : (t : ℝ) ≤ 4 := by exact_mod_cast _root_.Nat.le_of_lt_succ ht
      linarith
    · obtain ⟨k, rfl⟩ := _root_.Nat.exists_eq_add_of_le ht
      rw [inertia_stock_closed_form 4 1 1 5 (by norm_num) 27 k]
      norm_num
  have h10 : inertiaStock 4 1 1 5 (1 / 8) 27 10 = 58035 / 32768 := by
    rw [show (10 : ℕ) = 5 + 5 from rfl, inertia_stock_closed_form 4 1 1 5 (by norm_num) 27 5]
    norm_num
  have h12 : inertiaStock 4 1 1 5 (1 / 8) 27 12 < 0 := by
    rw [show (12 : ℕ) = 5 + 7 from rfl, inertia_stock_closed_form 4 1 1 5 (by norm_num) 27 7]
    norm_num
  have h21 : inertiaStock 4 1 1 5 (1 / 8) 27 21 < 0 := by
    rw [show (21 : ℕ) = 5 + 16 from rfl, inertia_stock_closed_form 4 1 1 5 (by norm_num) 27 16]
    norm_num
  have h39 : ∀ t, 3 ≤ inertiaStock 4 1 1 5 (1 / 8) 39 t := by
    simpa using (inertia_lag_headroom_penalty 4 1 2 1 5 (1 / 8) (by norm_num) (by norm_num)
      (by decide) (by decide)).1 3 39 (by norm_num)
  refine ⟨hpace.1, hpace.2, ⟨rfl, rfl, hlag⟩, h1, ⟨h10, ?_, h12, h21⟩, h39⟩
  rw [h10]
  norm_num

/-! ## Section 2: Finite-Distribution Stochastic Delay & Demand-Shock Headroom -/

/-- A finite probability distribution over a `Finset Ω`. -/
structure FiniteLaw {Ω : Type*} (S : Finset Ω) where
  w : Ω → ℝ
  nonneg : ∀ ω ∈ S, 0 ≤ w ω
  total : ∑ ω ∈ S, w ω = 1

/-- Probability of a decidable event under a `FiniteLaw`. -/
noncomputable def FiniteLaw.prob {Ω : Type*} {S : Finset Ω} (L : FiniteLaw S) (E : Ω → Prop)
    [DecidablePred E] : ℝ :=
  ∑ ω ∈ S, if E ω then L.w ω else 0

/-- Expectation of a real random variable under a `FiniteLaw`. -/
noncomputable def FiniteLaw.expect {Ω : Type*} {S : Finset Ω} (L : FiniteLaw S) (X : Ω → ℝ) : ℝ :=
  ∑ ω ∈ S, L.w ω * X ω

theorem FiniteLaw.prob_nonneg {Ω : Type*} {S : Finset Ω} (L : FiniteLaw S) (E : Ω → Prop)
    [DecidablePred E] : 0 ≤ L.prob E := by
  refine Finset.sum_nonneg fun ω hω => ?_
  split_ifs
  · exact L.nonneg ω hω
  · exact le_rfl

theorem FiniteLaw.prob_le_one {Ω : Type*} {S : Finset Ω} (L : FiniteLaw S) (E : Ω → Prop)
    [DecidablePred E] : L.prob E ≤ 1 := by
  calc
    L.prob E = ∑ ω ∈ S, (if E ω then L.w ω else 0) := rfl
    _ ≤ ∑ ω ∈ S, L.w ω := by
      refine Finset.sum_le_sum fun ω hω => ?_
      split_ifs
      · exact le_rfl
      · exact L.nonneg ω hω
    _ = 1 := L.total

theorem FiniteLaw.prob_add_compl {Ω : Type*} {S : Finset Ω} (L : FiniteLaw S) (E : Ω → Prop)
    [DecidablePred E] [DecidablePred (fun ω => ¬ E ω)] :
    L.prob E + L.prob (fun ω => ¬ E ω) = 1 := by
  simp only [FiniteLaw.prob, ← Finset.sum_add_distrib]
  rw [← L.total]
  refine Finset.sum_congr rfl fun ω _ => ?_
  by_cases hE : E ω <;> simp [hE]

/-- Division-free Markov bound: `B * P(B < X) ≤ E[X]` for nonnegative `X`. -/
theorem markov_prob_ge {Ω : Type*} {S : Finset Ω} (law : FiniteLaw S) (X : Ω → ℝ)
    (hX : ∀ ω ∈ S, 0 ≤ X ω) (B : ℝ) :
    B * law.prob (fun ω => B < X ω) ≤ law.expect X := by
  simp only [FiniteLaw.prob, FiniteLaw.expect, Finset.mul_sum]
  refine Finset.sum_le_sum fun ω hω => ?_
  split_ifs with hlt
  · rw [mul_comm B (law.w ω)]
    exact mul_le_mul_of_nonneg_left hlt.le (law.nonneg ω hω)
  · rw [mul_zero]
    exact mul_nonneg (law.nonneg ω hω) (hX ω hω)

/-- Markov survival sufficiency: if `0 < B`, `0 < δ`, `0 ≤ X`, and `E[X] / δ ≤ B`, then
`1 - δ ≤ P(X ≤ B)`. -/
theorem markov_survival_sufficient {Ω : Type*} {S : Finset Ω} (law : FiniteLaw S) (X : Ω → ℝ)
    (hX : ∀ ω ∈ S, 0 ≤ X ω) {B δ : ℝ} (hB : 0 < B) (hδ : 0 < δ)
    (hbound : law.expect X / δ ≤ B) :
    1 - δ ≤ law.prob (fun ω => X ω ≤ B) := by
  have h1 : B * law.prob (fun ω => B < X ω) ≤ B * δ := by
    calc
      B * law.prob (fun ω => B < X ω) ≤ law.expect X := markov_prob_ge law X hX B
      _ ≤ B * δ := (div_le_iff₀ hδ).mp hbound
  have hlt_le : law.prob (fun ω => B < X ω) ≤ δ := le_of_mul_le_mul_left h1 hB
  have hcomp : law.prob (fun ω => X ω ≤ B) + law.prob (fun ω => B < X ω) = 1 := by
    simp only [FiniteLaw.prob, ← Finset.sum_add_distrib]
    rw [← law.total]
    refine Finset.sum_congr rfl fun ω _ => ?_
    by_cases hle : X ω ≤ B
    · have hnot : ¬ B < X ω := not_lt.mpr hle
      simp [hle, hnot]
    · have hlt : B < X ω := lt_of_not_ge hle
      simp [hle, hlt]
  linarith

/-- Reverse-Markov survival upper bound for bounded nonnegative `X ≤ X_max` when `B < X_max`. -/
theorem reverse_markov_failure_bound {Ω : Type*} {S : Finset Ω} (law : FiniteLaw S) (X : Ω → ℝ)
    {B X_max : ℝ} (_hX0 : ∀ ω ∈ S, 0 ≤ X ω) (hXmax : ∀ ω ∈ S, X ω ≤ X_max)
    (hBX : B < X_max) :
    law.prob (fun ω => X ω ≤ B) ≤ 1 - (law.expect X - B) / (X_max - B) := by
  have hex :
      law.expect X ≤ B * law.prob (fun ω => X ω ≤ B) +
        X_max * law.prob (fun ω => B < X ω) := by
    simp only [FiniteLaw.expect, FiniteLaw.prob, Finset.mul_sum, ← Finset.sum_add_distrib]
    refine Finset.sum_le_sum fun ω hω => ?_
    by_cases hle : X ω ≤ B
    · have hnot : ¬ B < X ω := not_lt.mpr hle
      simp only [hle, hnot, ↓reduceIte, mul_zero, add_zero]
      rw [mul_comm B (law.w ω)]
      exact mul_le_mul_of_nonneg_left hle (law.nonneg ω hω)
    · have hlt : B < X ω := lt_of_not_ge hle
      simp only [hle, hlt, ↓reduceIte, mul_zero, zero_add]
      rw [mul_comm X_max (law.w ω)]
      exact mul_le_mul_of_nonneg_left (hXmax ω hω) (law.nonneg ω hω)
  have hcomp : law.prob (fun ω => X ω ≤ B) + law.prob (fun ω => B < X ω) = 1 := by
    simp only [FiniteLaw.prob, ← Finset.sum_add_distrib]
    rw [← law.total]
    refine Finset.sum_congr rfl fun ω _ => ?_
    by_cases hle : X ω ≤ B
    · simp [hle, not_lt.mpr hle]
    · simp [hle, lt_of_not_ge hle]
  have hdiff : 0 < X_max - B := sub_pos.mpr hBX
  have hp2 : law.prob (fun ω => B < X ω) = 1 - law.prob (fun ω => X ω ≤ B) := by linarith
  rw [hp2] at hex
  have halg :
      B * law.prob (fun ω => X ω ≤ B) + X_max * (1 - law.prob (fun ω => X ω ≤ B)) =
        X_max - (X_max - B) * law.prob (fun ω => X ω ≤ B) := by
    ring
  rw [halg] at hex
  have hdiv : law.prob (fun ω => X ω ≤ B) ≤ (X_max - law.expect X) / (X_max - B) :=
    (le_div_iff₀ hdiff).mpr (by linarith)
  calc
    law.prob (fun ω => X ω ≤ B) ≤ (X_max - law.expect X) / (X_max - B) := hdiv
    _ = 1 - (law.expect X - B) / (X_max - B) := by
      field_simp [hdiff.ne']
      ring

/-- Spike-threshold survival upper bound: a lower bound `p ≤ P(M ≤ X)` with `B < M` forces
`P(X ≤ B) ≤ 1 - p`. -/
theorem spike_threshold_survival_upper {Ω : Type*} {S : Finset Ω} (law : FiniteLaw S) (X : Ω → ℝ)
    {B M p : ℝ} (hBM : B < M) (hp : p ≤ law.prob (fun ω => M ≤ X ω)) :
    law.prob (fun ω => X ω ≤ B) ≤ 1 - p := by
  have hsum : law.prob (fun ω => X ω ≤ B) + law.prob (fun ω => M ≤ X ω) ≤ 1 := by
    simp only [FiniteLaw.prob, ← Finset.sum_add_distrib]
    rw [← law.total]
    refine Finset.sum_le_sum fun ω hω => ?_
    by_cases h1 : X ω ≤ B
    · have h2 : ¬ M ≤ X ω := by linarith
      simp [h1, h2]
    · by_cases h2 : M ≤ X ω
      · simp [h1, h2]
      · simp [h1, h2, law.nonneg ω hω]
  linarith

/-- Exact binomial survival probability `P(Binomial(n, p) ≤ k)` via clean `0` / `k + 1` split. -/
noncomputable def survProb : ℕ → ℕ → ℝ → ℝ
  | 0, _, _ => 1
  | n + 1, 0, p => (1 - p) * survProb n 0 p
  | n + 1, k + 1, p => (1 - p) * survProb n (k + 1) p + p * survProb n k p

/-- Product Bernoulli weight on `Fin n → Bool` with spike probability `p`. -/
noncomputable def productBoolWeight (n : ℕ) (p : ℝ) (ω : Fin n → Bool) : ℝ :=
  ∏ i : Fin n, if ω i then p else 1 - p

/-- Product Bernoulli `FiniteLaw` on `Fin n → Bool` for `0 ≤ p ≤ 1`. -/
noncomputable def productBoolLaw (n : ℕ) (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1) :
    FiniteLaw (Finset.univ : Finset (Fin n → Bool)) where
  w := productBoolWeight n p
  nonneg ω _ := Finset.prod_nonneg fun i _ => by
    cases ω i <;> simp <;> linarith
  total := by
    change ∑ ω : Fin n → Bool, ∏ i : Fin n, (if ω i then p else 1 - p) = 1
    rw [← Fintype.prod_sum (fun (_ : Fin n) (b : Bool) => if b then p else 1 - p)]
    refine Finset.prod_eq_one fun i _ => ?_
    simp

/-- Number of demand spikes along `ω : Fin n → Bool`. -/
def spikeCount {n : ℕ} (ω : Fin n → Bool) : ℕ :=
  ∑ i : Fin n, if ω i then 1 else 0

theorem spikeCount_le {n : ℕ} (ω : Fin n → Bool) : spikeCount ω ≤ n := by
  calc
    spikeCount ω = ∑ i : Fin n, (if ω i then 1 else 0) := rfl
    _ ≤ ∑ _i : Fin n, 1 := Finset.sum_le_sum fun i _ => by cases ω i <;> decide
    _ = n := by simp

theorem spikeCount_cons {n : ℕ} (b : Bool) (ω : Fin n → Bool) :
    spikeCount (Fin.cons b ω) = (if b then 1 else 0) + spikeCount ω := by
  rw [spikeCount, Fin.sum_univ_succ]
  rfl

theorem productBoolWeight_cons {n : ℕ} (p : ℝ) (b : Bool) (ω : Fin n → Bool) :
    productBoolWeight (n + 1) p (Fin.cons b ω) =
      (if b then p else 1 - p) * productBoolWeight n p ω := by
  simp [productBoolWeight, Fin.prod_univ_succ]

/-- Equivalence splitting `Fin (n + 1) → Bool` into head bit and tail via `Fin.cons` / `Fin.tail`. -/
def boolPiEquiv (n : ℕ) : Bool × (Fin n → Bool) ≃ (Fin (n + 1) → Bool) where
  toFun := fun (b, ω) => Fin.cons b ω
  invFun := fun ω => (ω 0, Fin.tail ω)
  left_inv := fun ⟨_, _⟩ => rfl
  right_inv := fun ω => by
    funext i
    exact Fin.cases rfl (fun _ => rfl) i

theorem productBool_prob_spikeCount_le (n k : ℕ) (p : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1) :
    (productBoolLaw n p hp0 hp1).prob (fun ω => spikeCount ω ≤ k) = survProb n k p := by
  induction n generalizing k with
  | zero =>
    simp only [FiniteLaw.prob, survProb]
    have hcard : (Finset.univ : Finset (Fin 0 → Bool)).card = 1 := by simp
    have hall : ∀ ω : Fin 0 → Bool, spikeCount ω ≤ k := fun ω => by
      simp [spikeCount]
    have hsum :
        (∑ ω : Fin 0 → Bool, if spikeCount ω ≤ k then productBoolWeight 0 p ω else 0) =
          ∑ ω : Fin 0 → Bool, productBoolWeight 0 p ω :=
      Finset.sum_congr rfl fun ω _ => if_pos (hall ω)
    change ∑ ω : Fin 0 → Bool, (if spikeCount ω ≤ k then productBoolWeight 0 p ω else 0) = 1
    rw [hsum]
    exact (productBoolLaw 0 p hp0 hp1).total
  | succ n ih =>
    change ∑ ω : Fin (n + 1) → Bool,
        (if spikeCount ω ≤ k then productBoolWeight (n + 1) p ω else 0) = survProb (n + 1) k p
    rw [← Equiv.sum_comp (boolPiEquiv n)]
    rw [Fintype.sum_prod_type, Fintype.sum_bool]
    simp only [boolPiEquiv, Equiv.coe_fn_mk, productBoolWeight_cons, spikeCount_cons]
    cases k with
    | zero =>
      have htrue : (∑ ω : Fin n → Bool,
          if 1 + spikeCount ω ≤ 0 then p * productBoolWeight n p ω else 0) = 0 := by
        refine Finset.sum_eq_zero fun ω _ => ?_
        rw [if_neg (by omega)]
      have hfalse :
          (∑ ω : Fin n → Bool,
            if 0 + spikeCount ω ≤ 0 then (1 - p) * productBoolWeight n p ω else 0) =
            (1 - p) * survProb n 0 p := by
        calc
          ∑ ω : Fin n → Bool,
              (if 0 + spikeCount ω ≤ 0 then (1 - p) * productBoolWeight n p ω else 0)
              = ∑ ω : Fin n → Bool,
                  (1 - p) * (if spikeCount ω ≤ 0 then productBoolWeight n p ω else 0) := by
                refine Finset.sum_congr rfl fun ω _ => ?_
                by_cases h : spikeCount ω ≤ 0 <;> simp [h]
          _ = (1 - p) * ∑ ω : Fin n → Bool,
                (if spikeCount ω ≤ 0 then productBoolWeight n p ω else 0) := by
                rw [← Finset.mul_sum]
          _ = (1 - p) * survProb n 0 p := by
                have ih0 : (∑ ω : Fin n → Bool,
                    if spikeCount ω ≤ 0 then productBoolWeight n p ω else 0) = survProb n 0 p := ih 0
                rw [ih0]
      simp only [ite_true]
      change (∑ ω : Fin n → Bool, if 1 + spikeCount ω ≤ 0 then p * productBoolWeight n p ω else 0) +
          (∑ ω : Fin n → Bool, if 0 + spikeCount ω ≤ 0 then (1 - p) * productBoolWeight n p ω else 0) =
        survProb (n + 1) 0 p
      rw [htrue, zero_add, hfalse, survProb]
    | succ k =>
      have htrue :
          (∑ ω : Fin n → Bool,
            if 1 + spikeCount ω ≤ k + 1 then p * productBoolWeight n p ω else 0) =
            p * survProb n k p := by
        calc
          ∑ ω : Fin n → Bool,
              (if 1 + spikeCount ω ≤ k + 1 then p * productBoolWeight n p ω else 0)
              = ∑ ω : Fin n → Bool,
                  p * (if spikeCount ω ≤ k then productBoolWeight n p ω else 0) := by
                refine Finset.sum_congr rfl fun ω _ => ?_
                have hiff : 1 + spikeCount ω ≤ k + 1 ↔ spikeCount ω ≤ k := by omega
                by_cases h : spikeCount ω ≤ k
                · simp [hiff.mpr h, h]
                · simp [hiff.not.mpr h, h]
          _ = p * ∑ ω : Fin n → Bool,
                (if spikeCount ω ≤ k then productBoolWeight n p ω else 0) := by
                rw [← Finset.mul_sum]
          _ = p * survProb n k p := by
                have ihk : (∑ ω : Fin n → Bool,
                    if spikeCount ω ≤ k then productBoolWeight n p ω else 0) = survProb n k p := ih k
                rw [ihk]
      have hfalse :
          (∑ ω : Fin n → Bool,
            if 0 + spikeCount ω ≤ k + 1 then (1 - p) * productBoolWeight n p ω else 0) =
            (1 - p) * survProb n (k + 1) p := by
        calc
          ∑ ω : Fin n → Bool,
              (if 0 + spikeCount ω ≤ k + 1 then (1 - p) * productBoolWeight n p ω else 0)
              = ∑ ω : Fin n → Bool,
                  (1 - p) * (if spikeCount ω ≤ k + 1 then productBoolWeight n p ω else 0) := by
                refine Finset.sum_congr rfl fun ω _ => ?_
                by_cases h : spikeCount ω ≤ k + 1 <;> simp [h]
          _ = (1 - p) * ∑ ω : Fin n → Bool,
                (if spikeCount ω ≤ k + 1 then productBoolWeight n p ω else 0) := by
                rw [← Finset.mul_sum]
          _ = (1 - p) * survProb n (k + 1) p := by
                have ihk1 : (∑ ω : Fin n → Bool,
                    if spikeCount ω ≤ k + 1 then productBoolWeight n p ω else 0) =
                    survProb n (k + 1) p := ih (k + 1)
                rw [ihk1]
      simp only [ite_true]
      change (∑ ω : Fin n → Bool, if 1 + spikeCount ω ≤ k + 1 then p * productBoolWeight n p ω else 0) +
          (∑ ω : Fin n → Bool, if 0 + spikeCount ω ≤ k + 1 then (1 - p) * productBoolWeight n p ω else 0) =
        survProb (n + 1) (k + 1) p
      rw [htrue, hfalse, survProb]
      ring

/-- **Theorem 2 (`stochastic_delay_survival_bound`).**
Combines finite-distribution Markov sufficiency and spike-threshold impossibility bounds for random
cadence delay `D : Ω → ℕ` with the exact `Becoming.PacedStock.unrecoverable_cadence_impossibility`
(for `2 * N - 1 ≤ L` delays) and `Becoming.RegimeMargin.falls_within` collapses on any
realization exceeding deterministic headroom (via `D ω` and `2 * N - 1`), together with the
product-law spike survival formula `survProb`. -/
theorem stochastic_delay_survival_bound {Ω : Type*} {S : Finset Ω} (law : FiniteLaw S)
    (D : Ω → ℕ)
    {A U R O : Type} {fA : A → R → A} {need : U → ℕ} {kids : R → U → List U}
    {giving : ℕ → ℕ} {use : U → ℕ} {N Y H₁ H₂ y₂ x₀ : ℕ} {x_o y_o : O}
    (nGe2 : 2 ≤ N) (two : x_o ≠ y_o)
    (nothing : Becoming.RegimeMargin.FromNothing giving)
    (most : Becoming.RegimeMargin.AtMost giving Y)
    (yLtH1 : Y < H₁) (h1Le : H₁ ≤ H₂ + y₂)
    (short2 : Becoming.RegimeMargin.Short giving H₂ y₂)
    (needsPos : ∀ u, 0 < need u ∧ need u ≤ H₂ + y₂)
    {g_bad : R} {w₀ : List U}
    (lower : Becoming.PacedStock.LowerDrawWhileMet H₁ need kids giving use g_bad w₀ x₀ (2 * N - 1))
    (floorDraw : ∀ w, w ≠ [] → H₂ ≤ Becoming.LineOnAStock.taken use w)
    (hH2x0 : H₂ + y₂ < x₀) :
    (∀ δ : ℝ, 0 < δ →
      law.expect (fun ω => (D ω : ℝ) * ((H₁ : ℝ) - (Y : ℝ))) / δ ≤
        ((x₀ : ℝ) - ((H₂ + y₂ : ℕ) : ℝ)) →
      1 - δ ≤ law.prob (fun ω => (D ω : ℝ) * ((H₁ : ℝ) - (Y : ℝ)) ≤
        (x₀ : ℝ) - ((H₂ + y₂ : ℕ) : ℝ))) ∧
    (∀ (M : ℕ) (p_fail : ℝ),
      ((x₀ : ℝ) - ((H₂ + y₂ : ℕ) : ℝ) < (M : ℝ) * ((H₁ : ℝ) - (Y : ℝ))) →
      p_fail ≤ law.prob (fun ω => (M : ℝ) * ((H₁ : ℝ) - (Y : ℝ)) ≤
        (D ω : ℝ) * ((H₁ : ℝ) - (Y : ℝ))) →
      law.prob (fun ω => (D ω : ℝ) * ((H₁ : ℝ) - (Y : ℝ)) ≤
        (x₀ : ℝ) - ((H₂ + y₂ : ℕ) : ℝ)) ≤ 1 - p_fail) ∧
    (∀ ω : Ω, (x₀ : ℝ) - ((H₂ + y₂ : ℕ) : ℝ) < (D ω : ℝ) * ((H₁ : ℝ) - (Y : ℝ)) →
      ∃ k ≤ D ω, (Becoming.Law.run (Becoming.RegimeMargin.step giving H₁) x₀).state k < H₂ + y₂) ∧
    (x₀ < (H₂ + y₂) + (H₁ - Y) * (2 * N - 1) →
      ∀ (ω : Ω) (σ : ℕ → ℕ) (reads : ℕ → Bool)
        (h : Becoming.PacedStock.StockState A U → R → R) (a₀ : A),
        2 * N - 1 ≤ D ω → σ 0 = 0 → σ 1 = D ω →
        Becoming.Strict σ → Becoming.PacedStock.ReadAtSpanEnd σ reads →
        ∃ t, ¬ Becoming.LineOnAStock.Goes need
          (Becoming.PacedStock.pacedCourse fA need kids giving use h reads
            ((a₀, (w₀, x₀)), g_bad) t).1.2) ∧
    (∀ (n k : ℕ) (p Δ slack : ℝ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1),
      0 < Δ → (k : ℝ) * Δ ≤ slack → slack < ((k + 1 : ℕ) : ℝ) * Δ →
      (productBoolLaw n p hp0 hp1).prob (fun ω => (spikeCount ω : ℝ) * Δ ≤ slack) =
        survProb n k p) := by
  have hposB : 0 < (x₀ : ℝ) - ((H₂ + y₂ : ℕ) : ℝ) := by
    have : ((H₂ + y₂ : ℕ) : ℝ) < (x₀ : ℝ) := Nat.cast_lt.mpr hH2x0
    linarith
  have hnonnegX : ∀ ω ∈ S, 0 ≤ (D ω : ℝ) * ((H₁ : ℝ) - (Y : ℝ)) := fun ω _ =>
    mul_nonneg (Nat.cast_nonneg _) (sub_nonneg.mpr (Nat.cast_le.mpr yLtH1.le))
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · intro δ hδ hbound
    exact markov_survival_sufficient law (fun ω => (D ω : ℝ) * ((H₁ : ℝ) - (Y : ℝ)))
      hnonnegX hposB hδ hbound
  · intro M p_fail hBM hp
    exact spike_threshold_survival_upper law (fun ω => (D ω : ℝ) * ((H₁ : ℝ) - (Y : ℝ))) hBM hp
  · intro ω hlt
    have hnat : x₀ < (H₂ + y₂) + (H₁ - Y) * D ω := by
      have hcast :
          ((x₀ : ℝ) < ((H₂ + y₂ + (H₁ - Y) * D ω : ℕ) : ℝ)) := by
        rw [Nat.cast_add, Nat.cast_mul, Nat.cast_sub yLtH1.le]
        linarith
      exact Nat.cast_lt.mp hcast
    exact Becoming.RegimeMargin.falls_within most yLtH1.le h1Le hnat
  · intro hunder ω σ reads h a₀ hD σ0 σ1 strict cadence
    exact ((Becoming.PacedStock.unrecoverable_cadence_impossibility nGe2 two nothing most yLtH1
      h1Le short2 needsPos lower floorDraw hunder).2 (D ω) σ reads h a₀ hD σ0 σ1 strict cadence).2
  · intro n k p Δ slack hp0 hp1 hΔ hlow hhi
    have hiff : ∀ ω : Fin n → Bool, (spikeCount ω : ℝ) * Δ ≤ slack ↔ spikeCount ω ≤ k := by
      intro ω
      constructor
      · intro hle
        by_contra hgt
        have hk1 : k + 1 ≤ spikeCount ω := _root_.Nat.lt_of_not_ge hgt
        have hk1_real : ((k + 1 : ℕ) : ℝ) ≤ (spikeCount ω : ℝ) := Nat.cast_le.mpr hk1
        have hmul : ((k + 1 : ℕ) : ℝ) * Δ ≤ (spikeCount ω : ℝ) * Δ :=
          mul_le_mul_of_nonneg_right hk1_real hΔ.le
        linarith
      · intro hle
        have hk_real : (spikeCount ω : ℝ) ≤ (k : ℝ) := Nat.cast_le.mpr hle
        have hmul : (spikeCount ω : ℝ) * Δ ≤ (k : ℝ) * Δ :=
          mul_le_mul_of_nonneg_right hk_real hΔ.le
        linarith
    have hprob_eq :
        (productBoolLaw n p hp0 hp1).prob (fun ω => (spikeCount ω : ℝ) * Δ ≤ slack) =
          (productBoolLaw n p hp0 hp1).prob (fun ω => spikeCount ω ≤ k) := by
      simp only [FiniteLaw.prob]
      refine Finset.sum_congr rfl fun ω _ => ?_
      by_cases hk : spikeCount ω ≤ k
      · simp [hk, (hiff ω).mpr hk]
      · simp [hk, (hiff ω).not.mpr hk]
    rw [hprob_eq, productBool_prob_spikeCount_le n k p hp0 hp1]

/-- **Phase 2 Stochastic Spike Witness (`stochastic_spike_witness_phase2`)**:
For `L = 5`, `H₁ = 4`, `H₂ = 1`, `y₂ = 2`, `Y = 1` (`detMin = 18`) and demand spikes of size
`Δ = 4`:
- at `x₀ = 27` (`slack = 9`), at most `2` spikes survive (`survProb 5 2 (3/10) = 20923 / 25000 < 1`),
- at `x₀ = 39` (`slack = 21 ≥ 20`), survival probability is `1` for all `p ∈ [0, 1]`. -/
theorem stochastic_spike_witness_phase2 :
    survProb 5 2 (3 / 10) = 20923 / 25000 ∧
    (productBoolLaw 5 (3 / 10) (by norm_num) (by norm_num)).prob
      (fun ω => (spikeCount ω : ℝ) * 4 ≤ (27 - 18 : ℝ)) = 20923 / 25000 ∧
    (productBoolLaw 5 (3 / 10) (by norm_num) (by norm_num)).prob
      (fun ω => (spikeCount ω : ℝ) * 4 ≤ (27 - 18 : ℝ)) < 1 ∧
    ∀ p : ℝ, ∀ (hp0 : 0 ≤ p) (hp1 : p ≤ 1),
      (productBoolLaw 5 p hp0 hp1).prob
        (fun ω => (spikeCount ω : ℝ) * 4 ≤ (39 - 18 : ℝ)) = 1 := by
  have hsurv : survProb 5 2 (3 / 10) = 20923 / 25000 := by
    simp only [survProb]
    norm_num
  have h27 :
      (productBoolLaw 5 (3 / 10) (by norm_num) (by norm_num)).prob
        (fun ω => (spikeCount ω : ℝ) * 4 ≤ (27 - 18 : ℝ)) = 20923 / 25000 := by
    have hiff : ∀ ω : Fin 5 → Bool, (spikeCount ω : ℝ) * 4 ≤ (27 - 18 : ℝ) ↔ spikeCount ω ≤ 2 := by
      intro ω
      constructor
      · intro h
        by_contra hgt
        have h3 : (3 : ℝ) ≤ (spikeCount ω : ℝ) := Nat.cast_le.mpr (_root_.Nat.lt_of_not_ge hgt)
        linarith
      · intro h
        have h2 : (spikeCount ω : ℝ) ≤ (2 : ℝ) := Nat.cast_le.mpr h
        linarith
    have hprob :
        (productBoolLaw 5 (3 / 10) (by norm_num) (by norm_num)).prob
            (fun ω => (spikeCount ω : ℝ) * 4 ≤ (27 - 18 : ℝ)) =
          (productBoolLaw 5 (3 / 10) (by norm_num) (by norm_num)).prob
            (fun ω => spikeCount ω ≤ 2) := by
      simp only [FiniteLaw.prob]
      refine Finset.sum_congr rfl fun ω _ => ?_
      by_cases hk : spikeCount ω ≤ 2
      · simp [hk, (hiff ω).mpr hk]
      · simp [hk, (hiff ω).not.mpr hk]
    rw [hprob, productBool_prob_spikeCount_le 5 2 (3 / 10) (by norm_num) (by norm_num), hsurv]
  refine ⟨hsurv, h27, ?_, ?_⟩
  · rw [h27]
    norm_num
  · intro p hp0 hp1
    have hall : ∀ ω : Fin 5 → Bool, (spikeCount ω : ℝ) * 4 ≤ (39 - 18 : ℝ) := fun ω => by
      have h5 : (spikeCount ω : ℝ) ≤ 5 := Nat.cast_le.mpr (spikeCount_le ω)
      linarith
    simp only [FiniteLaw.prob]
    have hsum :
        ∑ ω : Fin 5 → Bool,
            (if (spikeCount ω : ℝ) * 4 ≤ (39 - 18 : ℝ) then productBoolWeight 5 p ω else 0) =
          ∑ ω : Fin 5 → Bool, productBoolWeight 5 p ω :=
      Finset.sum_congr rfl fun ω _ => if_pos (hall ω)
    change ∑ ω : Fin 5 → Bool,
        (if (spikeCount ω : ℝ) * 4 ≤ (39 - 18 : ℝ) then productBoolWeight 5 p ω else 0) = 1
    rw [hsum]
    exact (productBoolLaw 5 p hp0 hp1).total

/-- Three-point stochastic delay law on `Fin 3` with delays `0, 5, 10`. -/
noncomputable def delayLaw3 (p₀ p₅ p₁₀ : ℝ) (hp0 : 0 ≤ p₀) (hp5 : 0 ≤ p₅) (hp10 : 0 ≤ p₁₀)
    (htot : p₀ + p₅ + p₁₀ = 1) : FiniteLaw (Finset.univ : Finset (Fin 3)) where
  w := ![p₀, p₅, p₁₀]
  nonneg i _ := by fin_cases i <;> simp [hp0, hp5, hp10]
  total := by
    simp only [Fin.sum_univ_three, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val]
    linarith

/-- **Phase 2 Stochastic Delay Witness (`stochastic_delay_witness_phase2`)**:
With random cadence delay `D ∈ {0, 5, 10}` and `(H₁ = 4, H₂ = 1, y₂ = 2, Y = 1)`:
- at `x₀ = 27` (`slack = 24`), `D = 0, 5` survive while `D = 10` exceeds `24` (`30 > 24`) and
  collapses `< 3` within `10` steps (`RegimeMargin.falls_within`), giving survival probability
  `1 - p₁₀` (and `3/4 < 1` at `(1/2, 1/4, 1/4)`, even though `E[3 * D] = 45/4 ≤ 24`);
- at `x₀ = 39` (`slack = 36 ≥ 30`), all `D ∈ {0, 5, 10}` survive (`prob = 1`). -/
theorem stochastic_delay_witness_phase2 :
    (∀ (p₀ p₅ p₁₀ : ℝ) (hp0 : 0 ≤ p₀) (hp5 : 0 ≤ p₅) (hp10 : 0 ≤ p₁₀)
        (htot : p₀ + p₅ + p₁₀ = 1),
      (delayLaw3 p₀ p₅ p₁₀ hp0 hp5 hp10 htot).prob
          (fun i => ((![0, 5, 10] i : ℕ) : ℝ) * 3 ≤ (27 - 3 : ℝ)) = 1 - p₁₀ ∧
        (delayLaw3 p₀ p₅ p₁₀ hp0 hp5 hp10 htot).prob
          (fun i => ((![0, 5, 10] i : ℕ) : ℝ) * 3 ≤ (39 - 3 : ℝ)) = 1) ∧
    ((delayLaw3 (1 / 2) (1 / 4) (1 / 4) (by norm_num) (by norm_num) (by norm_num)
        (by norm_num)).expect (fun i => ((![0, 5, 10] i : ℕ) : ℝ) * 3) = 45 / 4 ∧
      (delayLaw3 (1 / 2) (1 / 4) (1 / 4) (by norm_num) (by norm_num) (by norm_num)
        (by norm_num)).prob (fun i => ((![0, 5, 10] i : ℕ) : ℝ) * 3 ≤ (27 - 3 : ℝ)) = 3 / 4) ∧
    (∃ k ≤ 10, (Becoming.Law.run (Becoming.RegimeMargin.step p2Giving 4) 27).state k < 3) := by
  refine ⟨fun p₀ p₅ p₁₀ hp0 hp5 hp10 htot => ⟨?_, ?_⟩, ⟨?_, ?_⟩, ?_⟩
  · simp [FiniteLaw.prob, delayLaw3, Fin.sum_univ_three]
    norm_num
    linarith
  · simp [FiniteLaw.prob, delayLaw3, Fin.sum_univ_three]
    norm_num
    linarith
  · simp [FiniteLaw.expect, delayLaw3, Fin.sum_univ_three]
    norm_num
  · simp [FiniteLaw.prob, delayLaw3, Fin.sum_univ_three]
    norm_num
  · obtain ⟨k, hk_le, hk_lt⟩ := Becoming.RegimeMargin.falls_within (g := p2Giving) (H := 4)
      (Y := 1) (b := 4) (x := 27) (n := 9) p2Giving_atMost1 (by decide) (by decide) (by decide)
    rcases _root_.Nat.lt_or_ge ((Becoming.Law.run (Becoming.RegimeMargin.step p2Giving 4) 27).state k) 3 with
      hlt3 | hge3
    · exact ⟨k, _root_.Nat.le_trans hk_le (by decide), hlt3⟩
    · have h3 : (Becoming.Law.run (Becoming.RegimeMargin.step p2Giving 4) 27).state k = 3 := by omega
      refine ⟨k + 1, by omega, ?_⟩
      change Becoming.RegimeMargin.step p2Giving 4
        ((Becoming.Law.run (Becoming.RegimeMargin.step p2Giving 4) 27).state k) < 3
      rw [h3]
      decide

/-! ## Section 3: Continuous Metric `LaxSim` Contraction Tube & Core Bridge -/

/-- Continuous pseudo-metric lax `(π, σ)`-viability simulation with boundary contraction
`(α, ε)` (`0 ≤ α < 1`) and inter-sample excursion bound `(β, η)` (`1 ≤ β`). -/
structure MetricLaxSim {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    (P : Generative.Process S A) (R : Generative.Process Q B)
    (π : S → Q) (σ : ℕ → ℕ) [PseudoMetricSpace Q] where
  strict : Becoming.Strict σ
  Epoch : ℕ → S → Prop
  EpochQ : ℕ → Q → Prop
  epoch_step : ∀ t s a s', Epoch t s → P.step s a s' → Epoch (t + 1) s'
  epoch_proj : ∀ k s, Epoch (σ k) s → EpochQ k (π s)
  α : ℝ
  β : ℝ
  ε : ℝ
  η : ℝ
  α_nonneg : 0 ≤ α
  α_lt_one : α < 1
  β_ge_one : 1 ≤ β
  ε_nonneg : 0 ≤ ε
  η_nonneg : 0 ≤ η
  sim_block : ∀ k s q r w s', 0 ≤ r →
    Epoch (σ k) s → EpochQ k q → dist (π s) q ≤ r →
    w.length = σ (k + 1) - σ k → Generative.Trace P s w s' →
    ∃ b q', R.step q b q' ∧ EpochQ (k + 1) q' ∧ dist (π s') q' ≤ α * r + ε
  excursion : ∀ k s q r w₁ u, 0 ≤ r →
    Epoch (σ k) s → EpochQ k q → dist (π s) q ≤ r →
    w₁.length < σ (k + 1) - σ k → Generative.Trace P s w₁ u →
    dist (π u) q ≤ β * r + η

/-- Real-valued iterated boundary slack over `m` blocks starting from radius `r`. -/
noncomputable def metricSlack (α ε : ℝ) : ℕ → ℝ → ℝ
  | 0, r => r
  | m + 1, r => metricSlack α ε m (α * r + ε)

theorem metricSlack_nonneg {α ε : ℝ} (hα : 0 ≤ α) (hε : 0 ≤ ε) :
    ∀ m r, 0 ≤ r → 0 ≤ metricSlack α ε m r
  | 0, _, hr => hr
  | m + 1, r, hr => metricSlack_nonneg hα hε m (α * r + ε) (add_nonneg (mul_nonneg hα hr) hε)

theorem metricSlack_eq {α : ℝ} (hα : α ≠ 1) (ε : ℝ) :
    ∀ m r, metricSlack α ε m r = α ^ m * r + ε * ((1 - α ^ m) / (1 - α))
  | 0, r => by simp [metricSlack]
  | m + 1, r => by
    rw [metricSlack, metricSlack_eq hα ε m (α * r + ε)]
    field_simp [sub_ne_zero.mpr hα.symm]
    ring

theorem metricSlack_le {α ε : ℝ} (hα0 : 0 ≤ α) (hα1 : α < 1) (hε : 0 ≤ ε) (m : ℕ) (r : ℝ) :
    metricSlack α ε m r ≤ α ^ m * r + ε / (1 - α) := by
  rw [metricSlack_eq hα1.ne ε m r]
  have h1α : 0 < 1 - α := sub_pos.mpr hα1
  have hpow : 0 ≤ α ^ m := pow_nonneg hα0 m
  have hdiv : (1 - α ^ m) / (1 - α) ≤ 1 / (1 - α) :=
    div_le_div_of_nonneg_right (by linarith) h1α.le
  have hmul : ε * ((1 - α ^ m) / (1 - α)) ≤ ε * (1 / (1 - α)) :=
    mul_le_mul_of_nonneg_left hdiv hε
  linarith [show ε * (1 / (1 - α)) = ε / (1 - α) from by ring]

theorem metricSlack_le_max {α ε : ℝ} (hα0 : 0 ≤ α) (hα1 : α < 1) (hε : 0 ≤ ε) :
    ∀ m r, metricSlack α ε m r ≤ max r (ε / (1 - α))
  | 0, r => le_max_left r (ε / (1 - α))
  | m + 1, r => by
    have h1α : 0 < 1 - α := sub_pos.mpr hα1
    let M := max r (ε / (1 - α))
    have hstep : α * r + ε ≤ M := by
      have hr : r ≤ M := le_max_left r (ε / (1 - α))
      have hεM : ε ≤ (1 - α) * M := by
        have h' := (div_le_iff₀ h1α).mp (le_max_right r (ε / (1 - α)))
        rwa [mul_comm] at h'
      have h1 : α * r + ε ≤ α * M + ε := add_le_add_left (mul_le_mul_of_nonneg_left hr hα0) ε
      linarith
    exact (metricSlack_le_max hα0 hα1 hε m (α * r + ε)).trans
      (max_le hstep (le_max_right r (ε / (1 - α))))

theorem MetricLaxSim.epoch_trace {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    {P : Generative.Process S A} {R : Generative.Process Q B}
    {π : S → Q} {σ : ℕ → ℕ} [PseudoMetricSpace Q] (sim : MetricLaxSim P R π σ) :
    ∀ {t₀ : ℕ} {s : S} {w : List A} {u : S},
      sim.Epoch t₀ s → Generative.Trace P s w u → sim.Epoch (t₀ + w.length) u
  | _, _, [], _, ep, .nil _ => ep
  | t₀, s, _ :: rest, u, ep, .cons step tr => by
    have ep' := sim.epoch_step t₀ s _ _ ep step
    rw [show t₀ + (_ :: rest).length = (t₀ + 1) + rest.length by simp; omega]
    exact MetricLaxSim.epoch_trace sim ep' tr

/-- Advance `m` blocks in `MetricLaxSim` starting from block index `j₀` with initial radius `r`. -/
theorem MetricLaxSim.advance_blocks {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    {P : Generative.Process S A} {R : Generative.Process Q B}
    {π : S → Q} {σ : ℕ → ℕ} [PseudoMetricSpace Q] (sim : MetricLaxSim P R π σ) :
    ∀ (m j₀ : ℕ) {s : S} {q : Q} {r : ℝ} {w : List A} {t : S},
      0 ≤ r → sim.Epoch (σ j₀) s → sim.EpochQ j₀ q → dist (π s) q ≤ r →
      σ (j₀ + m) - σ j₀ ≤ w.length → Generative.Trace P s w t →
      ∃ u w_rem wR q_m,
        w_rem.length + (σ (j₀ + m) - σ j₀) = w.length ∧
        wR.length = m ∧
        Generative.Trace R q wR q_m ∧
        Generative.Trace P u w_rem t ∧
        sim.Epoch (σ (j₀ + m)) u ∧
        sim.EpochQ (j₀ + m) q_m ∧
        dist (π u) q_m ≤ metricSlack sim.α sim.ε m r
  | 0, j₀, s, q, _, w, t, _, epS, epQ, d_le, _, tr =>
    ⟨s, w, [], q, by simp, rfl, .nil q, tr, epS, epQ, d_le⟩
  | m + 1, j₀, s, q, r, w, t, hr, epS, epQ, d_le, len_ge, tr => by
    have h_j0_le_j1 : σ j₀ ≤ σ (j₀ + 1) := _root_.Nat.le_of_lt (sim.strict j₀)
    have h_j1_le_jm : σ (j₀ + 1) ≤ σ (j₀ + (m + 1)) :=
      Becoming.strict_mono_le sim.strict (_root_.Nat.succ_le_succ (_root_.Nat.le_add_right j₀ m))
    have h_j0_le_jm : σ j₀ ≤ σ (j₀ + (m + 1)) := _root_.Nat.le_trans h_j0_le_j1 h_j1_le_jm
    have step_le_block : σ (j₀ + 1) - σ j₀ ≤ σ (j₀ + (m + 1)) - σ j₀ := by omega
    obtain ⟨w₁, w₂, s₁, len₁, sum_len, tr₁, tr₂⟩ :=
      Becoming.trace_split (σ (j₀ + 1) - σ j₀) (_root_.Nat.le_trans step_le_block len_ge) tr
    obtain ⟨b, q₁, stepQ, epQ₁, d_le₁⟩ := sim.sim_block j₀ s q r w₁ s₁ hr epS epQ d_le len₁ tr₁
    have epS₁ : sim.Epoch (σ (j₀ + 1)) s₁ := by
      have htrace := MetricLaxSim.epoch_trace sim epS tr₁
      have heq : σ j₀ + w₁.length = σ (j₀ + 1) := by
        rw [len₁]
        exact _root_.Nat.add_sub_of_le h_j0_le_j1
      exact heq ▸ htrace
    have eq_idx : (j₀ + 1) + m = j₀ + (m + 1) := _root_.Nat.add_right_comm j₀ 1 m
    have block_split :
        (σ (j₀ + 1) - σ j₀) + (σ ((j₀ + 1) + m) - σ (j₀ + 1)) = σ (j₀ + (m + 1)) - σ j₀ := by
      rw [eq_idx]
      omega
    have rem_ge : σ ((j₀ + 1) + m) - σ (j₀ + 1) ≤ w₂.length := by
      omega
    have hr' : 0 ≤ sim.α * r + sim.ε := add_nonneg (mul_nonneg sim.α_nonneg hr) sim.ε_nonneg
    obtain ⟨u, w_rem, wR, q_m, rem_eq, rlen, trR, tr_rem, epU, epQm, d_m⟩ :=
      MetricLaxSim.advance_blocks sim m (j₀ + 1) hr' epS₁ epQ₁ d_le₁ rem_ge tr₂
    have total_rem : w_rem.length + (σ (j₀ + (m + 1)) - σ j₀) = w.length := by
      omega
    exact ⟨u, w_rem, b :: wR, q_m, total_rem, congrArg Nat.succ rlen, .cons stepQ trR, tr_rem,
      eq_idx ▸ epU, eq_idx ▸ epQm, d_m⟩

/-- **Theorem 3A (`metric_laxSim_contraction_tube`).**
Under a `MetricLaxSim`, any coarse `Becoming.Viability.Certificate R guardQ K` holding `q₀` at
distance `dist (π s₀) q₀ ≤ d₀` induces:
1. the contracting excursion tube `dist (π t) q_k ≤ β * (α ^ k * d₀ + ε / (1 - α)) + η` and
   `dist (π t) q_k ≤ β * max d₀ (ε / (1 - α)) + η` at block `k` for every fine trace from `s₀`;
2. fine `Becoming.Viability.Kernel P guardS s₀` directly over `ℝ` whenever `margin` covers
   `sim.β * max d₀ (sim.ε / (1 - sim.α)) + sim.η` (including when `d₀ > 0`). -/
theorem metric_laxSim_contraction_tube {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    {P : Generative.Process S A} {R : Generative.Process Q B}
    {π : S → Q} {σ : ℕ → ℕ} [PseudoMetricSpace Q]
    (sim : MetricLaxSim P R π σ)
    {guardQ : Q → Prop} {K : Q → Prop} {guardS : S → Prop}
    (cert : Becoming.Viability.Certificate R guardQ K)
    (d₀ : ℝ) (hd₀ : 0 ≤ d₀)
    (margin : ∀ q u, guardQ q →
      dist (π u) q ≤ sim.β * max d₀ (sim.ε / (1 - sim.α)) + sim.η → guardS u)
    {s₀ : S} (q₀ : Q) (epoch₀ : sim.Epoch (σ 0) s₀) (epochQ₀ : sim.EpochQ 0 q₀)
    (dist₀ : dist (π s₀) q₀ ≤ d₀) (init : K q₀) :
    (∀ {t : S} {w : List A}, Generative.Trace P s₀ w t →
      ∃ (k : ℕ) (q_k : Q) (wR : List B),
        wR.length = k ∧
        σ k ≤ σ 0 + w.length ∧ σ 0 + w.length < σ (k + 1) ∧
        Generative.Trace R q₀ wR q_k ∧ K q_k ∧ guardQ q_k ∧
        dist (π t) q_k ≤ sim.β * (sim.α ^ k * d₀ + sim.ε / (1 - sim.α)) + sim.η ∧
        dist (π t) q_k ≤ sim.β * max d₀ (sim.ε / (1 - sim.α)) + sim.η) ∧
      Becoming.Viability.Kernel P guardS s₀ := by
  have tube : ∀ {t : S} {w : List A}, Generative.Trace P s₀ w t →
      ∃ (k : ℕ) (q_k : Q) (wR : List B),
        wR.length = k ∧
        σ k ≤ σ 0 + w.length ∧ σ 0 + w.length < σ (k + 1) ∧
        Generative.Trace R q₀ wR q_k ∧ K q_k ∧ guardQ q_k ∧
        dist (π t) q_k ≤ sim.β * (sim.α ^ k * d₀ + sim.ε / (1 - sim.α)) + sim.η ∧
        dist (π t) q_k ≤ sim.β * max d₀ (sim.ε / (1 - sim.α)) + sim.η := by
    intro t w tr
    obtain ⟨k, hk_le, hk_lt⟩ := Becoming.block_of_strict sim.strict (_root_.Nat.le_add_right (σ 0) w.length)
    have h0k : σ 0 ≤ σ k := Becoming.strict_mono_le sim.strict (_root_.Nat.zero_le k)
    have hlen : σ (0 + k) - σ 0 ≤ w.length := by
      rw [_root_.Nat.zero_add]
      omega
    obtain ⟨u, w_rem, wR, q_k, rem_eq, wR_len, trR, tr_rem, epU, epQk, d_k⟩ :=
      MetricLaxSim.advance_blocks sim k 0 hd₀ epoch₀ epochQ₀ dist₀ hlen tr
    rw [_root_.Nat.zero_add] at rem_eq epU epQk
    have h_rem_lt : w_rem.length < σ (k + 1) - σ k := by omega
    have hslack_nonneg : 0 ≤ metricSlack sim.α sim.ε k d₀ :=
      metricSlack_nonneg sim.α_nonneg sim.ε_nonneg k d₀ hd₀
    have d_ex := sim.excursion k u q_k (metricSlack sim.α sim.ε k d₀) w_rem t
      hslack_nonneg epU epQk d_k h_rem_lt tr_rem
    have hβ_nonneg : 0 ≤ sim.β := le_trans (by norm_num) sim.β_ge_one
    have h_decay : dist (π t) q_k ≤ sim.β * (sim.α ^ k * d₀ + sim.ε / (1 - sim.α)) + sim.η := by
      have hm := mul_le_mul_of_nonneg_left (metricSlack_le sim.α_nonneg sim.α_lt_one sim.ε_nonneg k d₀)
        hβ_nonneg
      linarith
    have h_unif : dist (π t) q_k ≤ sim.β * max d₀ (sim.ε / (1 - sim.α)) + sim.η := by
      have hm := mul_le_mul_of_nonneg_left
        (metricSlack_le_max sim.α_nonneg sim.α_lt_one sim.ε_nonneg k d₀) hβ_nonneg
      linarith
    have hK : K q_k := cert.closed.reach ⟨wR, trR⟩ init
    have hgQ : guardQ q_k := cert.within q_k hK
    exact ⟨k, q_k, wR, wR_len, hk_le, hk_lt, trR, hK, hgQ, h_decay, h_unif⟩
  refine ⟨tube, fun t ⟨w, tr⟩ => ?_⟩
  obtain ⟨_, q_k, _, _, _, _, _, _, hgQ, _, h_unif⟩ := tube tr
  exact margin q_k t hgQ h_unif

/-- Discretized `SlackDist` on a pseudo-metric space `Q` at grid resolution `δ > 0`. -/
noncomputable def scaledSlackDist (Q : Type w) [PseudoMetricSpace Q] (δ : ℝ) (hδ : 0 < δ) :
    Becoming.SlackDist Q where
  d x y := Nat.ceil (dist x y / δ)
  refl x := by simp
  tri x y z := by
    have h1 : dist x z / δ ≤ dist x y / δ + dist y z / δ := by
      rw [← add_div]
      exact div_le_div_of_nonneg_right (dist_triangle x y z) hδ.le
    exact (Nat.ceil_mono h1).trans (Nat.ceil_add_le _ _)

/-- Discrete `Becoming.LaxSim` obtained by rounding `MetricLaxSim` at resolution `δ > 0`. -/
noncomputable def toDiscreteLaxSim {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    {P : Generative.Process S A} {R : Generative.Process Q B}
    {π : S → Q} {σ : ℕ → ℕ} [PseudoMetricSpace Q]
    (sim : MetricLaxSim P R π σ) (δ : ℝ) (hδ : 0 < δ) :
    Becoming.LaxSim P R π σ (scaledSlackDist Q δ hδ) where
  strict := sim.strict
  Epoch := sim.Epoch
  EpochQ := sim.EpochQ
  epoch_step := sim.epoch_step
  epoch_proj := sim.epoch_proj
  α r := Nat.ceil (sim.α * (r : ℝ))
  β r := Nat.ceil (sim.β * (r : ℝ))
  α_mono {r₁ r₂} h := Nat.ceil_mono (mul_le_mul_of_nonneg_left (Nat.cast_le.mpr h) sim.α_nonneg)
  β_mono {r₁ r₂} h :=
    Nat.ceil_mono (mul_le_mul_of_nonneg_left (Nat.cast_le.mpr h) (le_trans zero_le_one sim.β_ge_one))
  β_ge_id r := by
    calc
      r = Nat.ceil (r : ℝ) := (Nat.ceil_natCast (R := ℝ) r).symm
      _ ≤ Nat.ceil (sim.β * (r : ℝ)) :=
        Nat.ceil_mono (le_mul_of_one_le_left (Nat.cast_nonneg r) sim.β_ge_one)
  ε := Nat.ceil (sim.ε / δ)
  η := Nat.ceil (sim.η / δ)
  sim_block k s q r w s' epS epQ hd hlen tr := by
    have hd_real : dist (π s) q ≤ δ * (r : ℝ) := by
      have h1 : dist (π s) q / δ ≤ (r : ℝ) := Nat.ceil_le.mp hd
      calc
        dist (π s) q = (dist (π s) q / δ) * δ := by field_simp [hδ.ne']
        _ ≤ (r : ℝ) * δ := mul_le_mul_of_nonneg_right h1 hδ.le
        _ = δ * (r : ℝ) := mul_comm _ _
    have hdr0 : 0 ≤ δ * (r : ℝ) := mul_nonneg hδ.le (Nat.cast_nonneg r)
    obtain ⟨b, q', stepQ, epQ', hd'⟩ := sim.sim_block k s q (δ * (r : ℝ)) w s' hdr0 epS epQ hd_real hlen tr
    refine ⟨b, q', stepQ, epQ', ?_⟩
    have hdiv : dist (π s') q' / δ ≤ sim.α * (r : ℝ) + sim.ε / δ := by
      calc
        dist (π s') q' / δ ≤ (sim.α * (δ * (r : ℝ)) + sim.ε) / δ :=
          div_le_div_of_nonneg_right hd' hδ.le
        _ = sim.α * (r : ℝ) + sim.ε / δ := by
          field_simp [hδ.ne']
    exact (Nat.ceil_mono hdiv).trans (Nat.ceil_add_le _ _)
  excursion k s q r w₁ u epS epQ hd hlt tr := by
    have hd_real : dist (π s) q ≤ δ * (r : ℝ) := by
      have h1 : dist (π s) q / δ ≤ (r : ℝ) := Nat.ceil_le.mp hd
      calc
        dist (π s) q = (dist (π s) q / δ) * δ := by field_simp [hδ.ne']
        _ ≤ (r : ℝ) * δ := mul_le_mul_of_nonneg_right h1 hδ.le
        _ = δ * (r : ℝ) := mul_comm _ _
    have hdr0 : 0 ≤ δ * (r : ℝ) := mul_nonneg hδ.le (Nat.cast_nonneg r)
    have hd' := sim.excursion k s q (δ * (r : ℝ)) w₁ u hdr0 epS epQ hd_real hlt tr
    have hdiv : dist (π u) q / δ ≤ sim.β * (r : ℝ) + sim.η / δ := by
      calc
        dist (π u) q / δ ≤ (sim.β * (δ * (r : ℝ)) + sim.η) / δ :=
          div_le_div_of_nonneg_right hd' hδ.le
        _ = sim.β * (r : ℝ) + sim.η / δ := by
          field_simp [hδ.ne']
    exact (Nat.ceil_mono hdiv).trans (Nat.ceil_add_le _ _)

/-- Exact discrete absorption at `Δ_nat := ⌈⌈sim.ε / δ⌉₊ / (1 - sim.α)⌉₊` via `Nat.ceil_le`. -/
theorem discrete_absorb_of_metric {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    {P : Generative.Process S A} {R : Generative.Process Q B}
    {π : S → Q} {σ : ℕ → ℕ} [PseudoMetricSpace Q]
    (sim : MetricLaxSim P R π σ) (δ : ℝ) (hδ : 0 < δ) :
    let ε_nat : ℕ := Nat.ceil (sim.ε / δ)
    let Δ_nat : ℕ := Nat.ceil ((ε_nat : ℝ) / (1 - sim.α))
    (toDiscreteLaxSim sim δ hδ).α Δ_nat + (toDiscreteLaxSim sim δ hδ).ε ≤ Δ_nat := by
  intro ε_nat Δ_nat
  have h1α : 0 < 1 - sim.α := sub_pos.mpr sim.α_lt_one
  have h1α_le : 1 - sim.α ≤ 1 := by linarith [sim.α_nonneg]
  have hε_le_Δ_real : (ε_nat : ℝ) ≤ (Δ_nat : ℝ) := by
    calc
      (ε_nat : ℝ) ≤ (ε_nat : ℝ) / (1 - sim.α) :=
        le_div_self (Nat.cast_nonneg ε_nat) h1α h1α_le
      _ ≤ (Δ_nat : ℝ) := Nat.le_ceil _
  have hε_le_Δ : ε_nat ≤ Δ_nat := Nat.cast_le.mp hε_le_Δ_real
  have hceil : Nat.ceil (sim.α * (Δ_nat : ℝ)) ≤ Δ_nat - ε_nat := by
    rw [Nat.ceil_le, Nat.cast_sub hε_le_Δ]
    have hmul : (ε_nat : ℝ) ≤ (1 - sim.α) * (Δ_nat : ℝ) := by
      have h' := (div_le_iff₀ h1α).mp (Nat.le_ceil ((ε_nat : ℝ) / (1 - sim.α)))
      rwa [mul_comm] at h'
    linarith
  change Nat.ceil (sim.α * (Δ_nat : ℝ)) + ε_nat ≤ Δ_nat
  omega

/-- **Theorem 3B (`metric_to_discrete_kernel`).**
Directly invokes the core's `Becoming.lax_kernel_of_certificate` at resolution `δ > 0` (`q₀ = π s₀`),
requiring the exact discretized radius `δ * ((⌈sim.β * Δ_nat⌉₊ : ℝ) + (⌈sim.η / δ⌉₊ : ℝ))`. -/
theorem metric_to_discrete_kernel {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    {P : Generative.Process S A} {R : Generative.Process Q B}
    {π : S → Q} {σ : ℕ → ℕ} [PseudoMetricSpace Q]
    (sim : MetricLaxSim P R π σ) (δ : ℝ) (hδ : 0 < δ)
    {guardQ : Q → Prop} {K : Q → Prop} {guardS : S → Prop}
    (cert : Becoming.Viability.Certificate R guardQ K)
    (margin : ∀ q u, guardQ q →
      dist (π u) q ≤
        δ * ((Nat.ceil (sim.β * (Nat.ceil ((Nat.ceil (sim.ε / δ) : ℝ) / (1 - sim.α)) : ℝ)) : ℝ) +
          (Nat.ceil (sim.η / δ) : ℝ)) →
      guardS u)
    {s₀ : S} (epoch₀ : sim.Epoch (σ 0) s₀) (init : K (π s₀)) :
    Becoming.Viability.Kernel P guardS s₀ := by
  let Δ_nat : ℕ := Nat.ceil ((Nat.ceil (sim.ε / δ) : ℝ) / (1 - sim.α))
  refine Becoming.lax_kernel_of_certificate (toDiscreteLaxSim sim δ hδ) cert Δ_nat
    (discrete_absorb_of_metric sim δ hδ) (fun q u gQ hd => ?_) epoch₀ init
  have hdiv : dist (π u) q / δ ≤
      ((Nat.ceil (sim.β * (Δ_nat : ℝ)) + Nat.ceil (sim.η / δ) : ℕ) : ℝ) :=
    Nat.ceil_le.mp hd
  have hdist : dist (π u) q ≤
      δ * ((Nat.ceil (sim.β * (Δ_nat : ℝ)) : ℝ) + (Nat.ceil (sim.η / δ) : ℝ)) := by
    have hmul : dist (π u) q / δ * δ ≤
        ((Nat.ceil (sim.β * (Δ_nat : ℝ)) : ℝ) + (Nat.ceil (sim.η / δ) : ℝ)) * δ := by
      rw [← Nat.cast_add]
      exact mul_le_mul_of_nonneg_right hdiv hδ.le
    calc
      dist (π u) q = dist (π u) q / δ * δ := by field_simp [hδ.ne']
      _ ≤ ((Nat.ceil (sim.β * (Δ_nat : ℝ)) : ℝ) + (Nat.ceil (sim.η / δ) : ℝ)) * δ := hmul
      _ = δ * ((Nat.ceil (sim.β * (Δ_nat : ℝ)) : ℝ) + (Nat.ceil (sim.η / δ) : ℝ)) := mul_comm _ _
  exact margin q u gQ hdist

/-- Choice of grid resolution `δ > 0` fitting any strict tube margin
`R_tube > sim.β * (sim.ε / (1 - sim.α)) + sim.η`. -/
theorem strict_margin_discretization_step {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    {P : Generative.Process S A} {R : Generative.Process Q B}
    {π : S → Q} {σ : ℕ → ℕ} [PseudoMetricSpace Q]
    (sim : MetricLaxSim P R π σ) {R_tube : ℝ}
    (hstrict : sim.β * (sim.ε / (1 - sim.α)) + sim.η < R_tube) :
    ∃ δ : ℝ, 0 < δ ∧
      δ * ((Nat.ceil (sim.β * (Nat.ceil ((Nat.ceil (sim.ε / δ) : ℝ) / (1 - sim.α)) : ℝ)) : ℝ) +
        (Nat.ceil (sim.η / δ) : ℝ)) ≤ R_tube := by
  have h1α : 0 < 1 - sim.α := sub_pos.mpr sim.α_lt_one
  have hβ_pos : 0 < sim.β := lt_of_lt_of_le zero_lt_one sim.β_ge_one
  let C : ℝ := sim.β * (1 / (1 - sim.α) + 1) + 2
  have hC : 0 < C := by
    have : 0 < 1 / (1 - sim.α) + 1 := add_pos (one_div_pos.mpr h1α) zero_lt_one
    linarith [mul_pos hβ_pos this]
  let gap : ℝ := R_tube - (sim.β * (sim.ε / (1 - sim.α)) + sim.η)
  have hgap : 0 < gap := sub_pos.mpr hstrict
  let δ : ℝ := gap / C
  have hδ : 0 < δ := div_pos hgap hC
  refine ⟨δ, hδ, ?_⟩
  have hε_nonneg : 0 ≤ sim.ε / δ := div_nonneg sim.ε_nonneg hδ.le
  have hη_nonneg : 0 ≤ sim.η / δ := div_nonneg sim.η_nonneg hδ.le
  have h1 : (Nat.ceil (sim.ε / δ) : ℝ) ≤ sim.ε / δ + 1 := (Nat.ceil_lt_add_one hε_nonneg).le
  have hΔ_nonneg : 0 ≤ (Nat.ceil (sim.ε / δ) : ℝ) / (1 - sim.α) :=
    div_nonneg (Nat.cast_nonneg _) h1α.le
  have h2 : (Nat.ceil ((Nat.ceil (sim.ε / δ) : ℝ) / (1 - sim.α)) : ℝ) ≤
      sim.ε / (δ * (1 - sim.α)) + 1 / (1 - sim.α) + 1 := by
    have ha := (Nat.ceil_lt_add_one hΔ_nonneg).le
    have hb : (Nat.ceil (sim.ε / δ) : ℝ) / (1 - sim.α) ≤ (sim.ε / δ + 1) / (1 - sim.α) :=
      div_le_div_of_nonneg_right h1 h1α.le
    have hc : (sim.ε / δ + 1) / (1 - sim.α) = sim.ε / (δ * (1 - sim.α)) + 1 / (1 - sim.α) := by
      field_simp [hδ.ne', h1α.ne']
    linarith
  have hβΔ_nonneg : 0 ≤ sim.β * (Nat.ceil ((Nat.ceil (sim.ε / δ) : ℝ) / (1 - sim.α)) : ℝ) :=
    mul_nonneg hβ_pos.le (Nat.cast_nonneg _)
  have h3 : (Nat.ceil (sim.β * (Nat.ceil ((Nat.ceil (sim.ε / δ) : ℝ) / (1 - sim.α)) : ℝ)) : ℝ) ≤
      sim.β * (sim.ε / (δ * (1 - sim.α)) + 1 / (1 - sim.α) + 1) + 1 := by
    have ha := (Nat.ceil_lt_add_one hβΔ_nonneg).le
    have hb := mul_le_mul_of_nonneg_left h2 hβ_pos.le
    linarith
  have h4 : (Nat.ceil (sim.η / δ) : ℝ) ≤ sim.η / δ + 1 := (Nat.ceil_lt_add_one hη_nonneg).le
  have h5 : δ * ((Nat.ceil (sim.β * (Nat.ceil ((Nat.ceil (sim.ε / δ) : ℝ) / (1 - sim.α)) : ℝ)) : ℝ) +
      (Nat.ceil (sim.η / δ) : ℝ)) ≤
      sim.β * (sim.ε / (1 - sim.α)) + sim.η + δ * C := by
    have hsum := mul_le_mul_of_nonneg_left (add_le_add h3 h4) hδ.le
    have heq : δ * (sim.β * (sim.ε / (δ * (1 - sim.α)) + 1 / (1 - sim.α) + 1) + 1 + (sim.η / δ + 1)) =
        sim.β * (sim.ε / (1 - sim.α)) + sim.η + δ * C := by
      simp only [C]
      field_simp [hδ.ne', h1α.ne']
      ring
    linarith
  have hδC : δ * C = gap := div_mul_cancel₀ gap hC.ne'
  linarith

/-- **Strict-margin discrete kernel corollary (`metric_to_discrete_kernel_of_strict_margin`).**
For any strict tube margin `R_tube > sim.β * (sim.ε / (1 - sim.α)) + sim.η`, there exists a
grid resolution `δ > 0` such that `Becoming.lax_kernel_of_certificate` yields
`Becoming.Viability.Kernel P guardS s₀`. -/
theorem metric_to_discrete_kernel_of_strict_margin {S : Type u} {A : Type v} {Q : Type w} {B : Type z}
    {P : Generative.Process S A} {R : Generative.Process Q B}
    {π : S → Q} {σ : ℕ → ℕ} [PseudoMetricSpace Q]
    (sim : MetricLaxSim P R π σ) {R_tube : ℝ}
    (hstrict : sim.β * (sim.ε / (1 - sim.α)) + sim.η < R_tube)
    {guardQ : Q → Prop} {K : Q → Prop} {guardS : S → Prop}
    (cert : Becoming.Viability.Certificate R guardQ K)
    (margin : ∀ q u, guardQ q → dist (π u) q ≤ R_tube → guardS u)
    {s₀ : S} (epoch₀ : sim.Epoch (σ 0) s₀) (init : K (π s₀)) :
    Becoming.Viability.Kernel P guardS s₀ := by
  obtain ⟨δ, hδ, hrad⟩ := strict_margin_discretization_step sim hstrict
  exact metric_to_discrete_kernel sim δ hδ cert (fun q u gQ hd => margin q u gQ (hd.trans hrad))
    epoch₀ init

/-! ## Section 4: Linear Function-Approximation Feature-Leakage Hysteresis -/

/-- Linear function-approximation update along `φ_safe` with step size `η` and TD signals `δ`. -/
noncomputable def faSafeUpdate {d : ℕ} (φ_safe : Fin d → ℝ) (η : ℝ) (δ : ℕ → ℝ) (θ₀ : Fin d → ℝ) :
    ℕ → Fin d → ℝ
  | 0 => θ₀
  | t + 1 => faSafeUpdate φ_safe η δ θ₀ t + (η * δ t) • φ_safe

/-- Warning-phase linear function-approximation descent along `φ_warn` with step size `η` and signals `p`. -/
noncomputable def faWarnUpdate {d : ℕ} (φ_warn : Fin d → ℝ) (η : ℝ) (p : ℕ → ℝ) (θ_enter : Fin d → ℝ) :
    ℕ → Fin d → ℝ
  | 0 => θ_enter
  | m + 1 => faWarnUpdate φ_warn η p θ_enter m - (η * p m) • φ_warn

theorem linear_fa_margin_shift {d : ℕ} (φ_safe φ_warn : Fin d → ℝ) (η : ℝ) (δ : ℕ → ℝ)
    (θ₀ : Fin d → ℝ) :
    ∀ t : ℕ, (faSafeUpdate φ_safe η δ θ₀ t) ⬝ᵥ φ_warn =
      θ₀ ⬝ᵥ φ_warn + η * (φ_safe ⬝ᵥ φ_warn) * ∑ k ∈ Finset.range t, δ k
  | 0 => by simp [faSafeUpdate]
  | t + 1 => by
    have ih := linear_fa_margin_shift φ_safe φ_warn η δ θ₀ t
    simp only [faSafeUpdate, add_dotProduct, smul_dotProduct, smul_eq_mul, Finset.sum_range_succ]
    rw [ih]
    ring

theorem linear_fa_tabular_invariant {d : ℕ} (φ_safe φ_warn : Fin d → ℝ)
    (horth : φ_safe ⬝ᵥ φ_warn = 0) (η : ℝ) (δ : ℕ → ℝ) (θ₀ : Fin d → ℝ) (t : ℕ) :
    (faSafeUpdate φ_safe η δ θ₀ t) ⬝ᵥ φ_warn = θ₀ ⬝ᵥ φ_warn := by
  rw [linear_fa_margin_shift, horth]
  ring

theorem linear_fa_warn_eq {d : ℕ} (φ_warn : Fin d → ℝ) (η : ℝ) (p : ℕ → ℝ) (θ_enter : Fin d → ℝ) :
    ∀ m : ℕ, (faWarnUpdate φ_warn η p θ_enter m) ⬝ᵥ φ_warn =
      θ_enter ⬝ᵥ φ_warn - η * (φ_warn ⬝ᵥ φ_warn) * ∑ k ∈ Finset.range m, p k
  | 0 => by simp [faWarnUpdate]
  | m + 1 => by
    have ih := linear_fa_warn_eq φ_warn η p θ_enter m
    simp only [faWarnUpdate, sub_dotProduct, smul_dotProduct, smul_eq_mul, Finset.sum_range_succ]
    rw [ih]
    ring

theorem linear_fa_warn_lower {d : ℕ} (φ_warn : Fin d → ℝ) (η p_max : ℝ) (hη : 0 ≤ η)
    (p : ℕ → ℝ) (hp : ∀ k, p k ≤ p_max) (θ_enter : Fin d → ℝ) (m : ℕ) :
    θ_enter ⬝ᵥ φ_warn - (m : ℝ) * (η * p_max * (φ_warn ⬝ᵥ φ_warn)) ≤
      (faWarnUpdate φ_warn η p θ_enter m) ⬝ᵥ φ_warn := by
  rw [linear_fa_warn_eq]
  have hnorm : 0 ≤ φ_warn ⬝ᵥ φ_warn :=
    Finset.sum_nonneg fun i _ => mul_self_nonneg (φ_warn i)
  have hsum : ∑ k ∈ Finset.range m, p k ≤ (m : ℝ) * p_max := by
    calc
      ∑ k ∈ Finset.range m, p k ≤ ∑ _k ∈ Finset.range m, p_max :=
        Finset.sum_le_sum fun k _ => hp k
      _ = (m : ℝ) * p_max := by simp [nsmul_eq_mul]
  have hmul : η * (φ_warn ⬝ᵥ φ_warn) * ∑ k ∈ Finset.range m, p k ≤
      (m : ℝ) * (η * p_max * (φ_warn ⬝ᵥ φ_warn)) := by
    calc
      η * (φ_warn ⬝ᵥ φ_warn) * ∑ k ∈ Finset.range m, p k
          ≤ η * (φ_warn ⬝ᵥ φ_warn) * ((m : ℝ) * p_max) :=
        mul_le_mul_of_nonneg_left hsum (mul_nonneg hη hnorm)
      _ = (m : ℝ) * (η * p_max * (φ_warn ⬝ᵥ φ_warn)) := by ring
  linarith

/-- Resource stock trajectory during warning phase under active score `v_rest < θ ⬝ᵥ φ_warn`. -/
noncomputable def warnStock (d_agg d_rest R : ℝ) (φ_warn : Fin d → ℝ) (v_rest η : ℝ)
    (p : ℕ → ℝ) (θ_enter : Fin d → ℝ) (x_warn : ℝ) : ℕ → ℝ
  | 0 => x_warn
  | m + 1 =>
    let draw := if v_rest < (faWarnUpdate φ_warn η p θ_enter m) ⬝ᵥ φ_warn then d_agg else d_rest
    warnStock d_agg d_rest R φ_warn v_rest η p θ_enter x_warn m - (draw - R)

/-- **Theorem 4 (`linear_fa_leakage_hysteresis`).**
1. In the orthogonal (`ρ = φ_safe ⬝ᵥ φ_warn = 0`) tabular case, safe updates leave the warning
   score invariant (`= θ₀ ⬝ᵥ φ_warn ≤ v_rest`), yielding `0` switchover lag.
2. When feature leakage `ρ = φ_safe ⬝ᵥ φ_warn` pushes `θ_enter ⬝ᵥ φ_warn` above
   `v_rest + ((M_delay - 1 : ℕ) : ℝ) * (η * p_max * (φ_warn ⬝ᵥ φ_warn))`, the aggressive draw
   `d_agg` persists for every `m < M_delay` (all `M_delay` steps `0 .. M_delay - 1`), so
   `x_warn - x_crit < (d_agg - R) * M_delay` forces exhaustion strictly below `x_crit` by step
   `M_delay`. -/
theorem linear_fa_leakage_hysteresis {d : ℕ} (φ_safe φ_warn : Fin d → ℝ)
    (η p_max v_rest d_agg d_rest R x_warn x_crit : ℝ)
    (hη : 0 ≤ η) (hp_nonneg : 0 ≤ p_max) (δ p : ℕ → ℝ) (hp : ∀ k, p k ≤ p_max)
    (θ₀ : Fin d → ℝ) (T_safe M_delay : ℕ) (_hM : 0 < M_delay) :
    (φ_safe ⬝ᵥ φ_warn = 0 → θ₀ ⬝ᵥ φ_warn ≤ v_rest →
      (faSafeUpdate φ_safe η δ θ₀ T_safe) ⬝ᵥ φ_warn ≤ v_rest) ∧
    (v_rest < θ₀ ⬝ᵥ φ_warn + η * (φ_safe ⬝ᵥ φ_warn) * (∑ k ∈ Finset.range T_safe, δ k) -
        ((M_delay - 1 : ℕ) : ℝ) * (η * p_max * (φ_warn ⬝ᵥ φ_warn)) →
      let θ_enter := faSafeUpdate φ_safe η δ θ₀ T_safe
      (∀ m, m < M_delay → v_rest < (faWarnUpdate φ_warn η p θ_enter m) ⬝ᵥ φ_warn) ∧
      (∀ m, m ≤ M_delay →
        warnStock d_agg d_rest R φ_warn v_rest η p θ_enter x_warn m =
          x_warn - (m : ℝ) * (d_agg - R)) ∧
      (x_warn - x_crit < (d_agg - R) * (M_delay : ℝ) →
        warnStock d_agg d_rest R φ_warn v_rest η p θ_enter x_warn M_delay < x_crit)) := by
  constructor
  · intro horth hθ0
    rw [linear_fa_tabular_invariant φ_safe φ_warn horth]
    exact hθ0
  · intro hlag θ_enter
    have hscore : ∀ m, m < M_delay →
        v_rest < (faWarnUpdate φ_warn η p θ_enter m) ⬝ᵥ φ_warn := by
      intro m hm
      have hlow := linear_fa_warn_lower φ_warn η p_max hη p hp θ_enter m
      have hθ_enter :
          θ_enter ⬝ᵥ φ_warn =
            θ₀ ⬝ᵥ φ_warn + η * (φ_safe ⬝ᵥ φ_warn) * (∑ k ∈ Finset.range T_safe, δ k) :=
        linear_fa_margin_shift φ_safe φ_warn η δ θ₀ T_safe
      have hm_le : (m : ℝ) ≤ ((M_delay - 1 : ℕ) : ℝ) :=
        Nat.cast_le.mpr (_root_.Nat.le_pred_of_lt hm)
      have hnorm : 0 ≤ φ_warn ⬝ᵥ φ_warn :=
        Finset.sum_nonneg fun i _ => mul_self_nonneg (φ_warn i)
      have hrate : 0 ≤ η * p_max * (φ_warn ⬝ᵥ φ_warn) :=
        mul_nonneg (mul_nonneg hη hp_nonneg) hnorm
      have hpen : (m : ℝ) * (η * p_max * (φ_warn ⬝ᵥ φ_warn)) ≤
          ((M_delay - 1 : ℕ) : ℝ) * (η * p_max * (φ_warn ⬝ᵥ φ_warn)) :=
        mul_le_mul_of_nonneg_right hm_le hrate
      linarith
    have hstock : ∀ m, m ≤ M_delay →
        warnStock d_agg d_rest R φ_warn v_rest η p θ_enter x_warn m =
          x_warn - (m : ℝ) * (d_agg - R) := by
      intro m hm
      induction m with
      | zero => simp [warnStock]
      | succ m ih =>
        have hm_lt : m < M_delay := _root_.Nat.lt_of_succ_le hm
        have ih' := ih (_root_.Nat.le_of_lt hm_lt)
        change (warnStock d_agg d_rest R φ_warn v_rest η p θ_enter x_warn m -
          ((if v_rest < (faWarnUpdate φ_warn η p θ_enter m) ⬝ᵥ φ_warn then d_agg else d_rest) - R)) =
          x_warn - ((m + 1 : ℕ) : ℝ) * (d_agg - R)
        rw [if_pos (hscore m hm_lt), ih', Nat.cast_succ]
        ring
    refine ⟨hscore, hstock, fun hex => ?_⟩
    rw [hstock M_delay (_root_.Nat.le_refl M_delay)]
    linarith

/-! ### `Becoming.AdaptiveLoops.OpenLoop` Coupling & Phase 2 Witness (`ρ = 0` vs `ρ = 4/5`) -/

/-- Open adaptive loop driven by linear FA weights `θ : Fin 2 → ℝ`.
When `alarm = true`, updates along `φ_warn`; otherwise updates along `φ_safe`. -/
noncomputable def faOpenLoop (φ_safe φ_warn : Fin 2 → ℝ) (v_rest η p_warn : ℝ) :
    Becoming.AdaptiveLoops.OpenLoop (Fin 2 → ℝ) Bool Unit Unit where
  next θ oa _ :=
    if oa.2 then θ - (η * p_warn) • φ_warn
    else θ + (η * (1 - θ ⬝ᵥ φ_safe)) • φ_safe
  draw θ _ := if v_rest < θ ⬝ᵥ φ_warn then 4 else 3
  emitAlarm _ obs := obs
  silenceLoad _ := 0
  favours θ := v_rest < θ ⬝ᵥ φ_warn

/-- Observation map firing below `warnLevel = 23`. -/
def faObs (_ : Unit) (x : Unit → ℕ) : Bool := Nat.blt (x ()) 23

/-- Blind communication channel: sees only `emit`, `load`, and `env`. -/
def faChannel (emit : Unit → Bool) (load : Unit → ℕ) (_ : Unit) : Bool :=
  emit () && Nat.ble (load ()) 0

/-- Substrate renewal law (`R = 3` whenever `1 ≤ x - H`, `0` at `0`). -/
def faG (_ : Unit) (e : Unit → ℕ) : ℕ := if 1 ≤ e () then 3 else 0

theorem faG_rises : ∀ i : Unit,
    Becoming.RegimeMargin.Coupled.Indexed.Rises Becoming.RegimeMargin.Drawn.whole (faG i) := by
  intro _ e₁ e₂ hbelow
  dsimp [faG]
  split_ifs with h1 h2 h2
  · exact _root_.Nat.le_refl 3
  · exact absurd (_root_.Nat.le_trans h1 (hbelow ())) h2
  · exact _root_.Nat.zero_le 3
  · exact _root_.Nat.le_refl 0

/-- Clean safe-phase weight sequence `θ_{t+1} = θ_t + (3/20 * (1 - θ_t ⬝ᵥ ![1,0])) • ![1, 0]`. -/
noncomputable def faSafeSeq : ℕ → Fin 2 → ℝ
  | 0 => 0
  | t + 1 => faSafeSeq t + ((3 / 20 : ℝ) * (1 - faSafeSeq t ⬝ᵥ ![1, 0])) • ![1, 0]

theorem faSafeSeq_coords : ∀ t : ℕ, faSafeSeq t 0 = 1 - (17 / 20 : ℝ) ^ t ∧ faSafeSeq t 1 = 0
  | 0 => by simp [faSafeSeq]
  | t + 1 => by
    have ih := faSafeSeq_coords t
    have hdot : faSafeSeq t ⬝ᵥ ![1, 0] = faSafeSeq t 0 := by
      simp [dotProduct, Fin.sum_univ_two]
    simp only [faSafeSeq, Pi.add_apply, Pi.smul_apply, smul_eq_mul, hdot, ih.1, ih.2,
      Matrix.cons_val_zero, Matrix.cons_val_one]
    constructor <;> ring

theorem faSafeSeq_eq_update (t : ℕ) :
    faSafeSeq t = faSafeUpdate ![1, 0] (3 / 20) (fun k => 1 - faSafeSeq k ⬝ᵥ ![1, 0]) 0 t := by
  induction t with
  | zero => rfl
  | succ t ih => simp only [faSafeSeq, faSafeUpdate, ih]

/-- Concrete post-safe entry weight vector at `T_safe = 12`: `(1 - (17/20)^12) • ![1, 0]`. -/
noncomputable def faThetaEnter : Fin 2 → ℝ := faSafeSeq 12

theorem faThetaEnter_coords :
    faThetaEnter 0 = 1 - (17 / 20 : ℝ) ^ 12 ∧ faThetaEnter 1 = 0 :=
  faSafeSeq_coords 12

/-- `LoopCertificate` with `maxLag = 0` for the orthogonal (`ρ = 0`, `φ_warn = ![0, 1]`) loop. -/
noncomputable def faCertZero (init : Fin 2 → ℝ) (hinit : init ⬝ᵥ ![0, 1] ≤ 3 / 5) :
    Becoming.AdaptiveLoops.LoopCertificate
      (faOpenLoop ![1, 0] ![0, 1] (3 / 5) (3 / 20) (1 / 40)) init where
  tol _ _ := True
  warnObs obs := obs = true
  preCap _ := 4
  postBudget _ := 3
  maxSilence := 0
  maxLag := 0
  K θ := θ ⬝ᵥ ![0, 1] ≤ 3 / 5
  eta _ := 0
  init_in := hinit
  cert := Becoming.Viability.certificate_disturbed_iff.mpr
    ⟨fun θ hθ => by
      have hnot : ¬ (3 / 5 : ℝ) < θ ⬝ᵥ ![0, 1] := not_lt.mpr hθ
      refine ⟨fun _ => ?_, _root_.Nat.le_refl 0, fun _ => ⟨?_, fun _ => ?_⟩⟩
      · simp only [faOpenLoop, if_neg hnot]
        decide
      · simp only [faOpenLoop]
        exact hnot
      · simp only [faOpenLoop, if_neg hnot]
        exact _root_.Nat.le_refl 3,
     fun θ oa _ hθ => by
      simp only [faOpenLoop]
      split_ifs with ha
      · rw [sub_dotProduct, smul_dotProduct, smul_eq_mul]
        have hdot : (![0, 1] : Fin 2 → ℝ) ⬝ᵥ ![0, 1] = 1 := by
          simp [dotProduct, Fin.sum_univ_two]
        rw [hdot]
        linarith
      · rw [add_dotProduct, smul_dotProduct, smul_eq_mul]
        have hdot : (![1, 0] : Fin 2 → ℝ) ⬝ᵥ ![0, 1] = 0 := by
          simp [dotProduct, Fin.sum_univ_two]
        rw [hdot]
        linarith⟩
  eta_bound _ _ := _root_.Nat.le_refl 0
  emits_on_warn _ _ _ warn := warn
  eta_alarm_step _ _ _ _ _ pos := absurd pos (_root_.Nat.lt_irrefl 0)
  eta_alarm_zero _ _ _ _ _ _ := rfl

/-- `LoopCertificate` for the coupled (`ρ = 4/5`, `φ_warn = ![4/5, 3/5]`) loop (`maxLag = 54`). -/
noncomputable def faCertCoupled (init : Fin 2 → ℝ) (hinit0 : init 0 ≤ 1) (hinit1 : init 1 ≤ 0) :
    Becoming.AdaptiveLoops.LoopCertificate
      (faOpenLoop ![1, 0] ![4 / 5, 3 / 5] (3 / 5) (3 / 20) (1 / 40)) init where
  tol _ _ := True
  warnObs obs := obs = true
  preCap _ := 4
  postBudget _ := 3
  maxSilence := 0
  maxLag := 54
  K θ := θ 0 ≤ 1 ∧ θ 1 ≤ 0
  eta θ := Nat.ceil (max (θ ⬝ᵥ ![4 / 5, 3 / 5] - 3 / 5) 0 / ((3 / 20 : ℝ) * (1 / 40)))
  init_in := ⟨hinit0, hinit1⟩
  cert := Becoming.Viability.certificate_disturbed_iff.mpr
    ⟨fun θ _ => by
      refine ⟨fun _ => ?_, _root_.Nat.le_refl 0, fun heta => ?_⟩
      · dsimp [faOpenLoop]
        split_ifs <;> decide
      · have hle0 : max (θ ⬝ᵥ ![4 / 5, 3 / 5] - 3 / 5) 0 / ((3 / 20 : ℝ) * (1 / 40)) ≤ 0 := by
          simpa using Nat.ceil_le.mp (_root_.Nat.le_of_eq heta)
        have hmax : max (θ ⬝ᵥ ![4 / 5, 3 / 5] - 3 / 5) 0 ≤ 0 := by
          have h' := (div_le_iff₀ (show (0 : ℝ) < (3 / 20 : ℝ) * (1 / 40) by norm_num)).mp hle0
          linarith
        have hnot : ¬ (3 / 5 : ℝ) < θ ⬝ᵥ ![4 / 5, 3 / 5] := by
          have : θ ⬝ᵥ ![4 / 5, 3 / 5] - 3 / 5 ≤ 0 := le_trans (le_max_left _ _) hmax
          linarith
        refine ⟨hnot, fun _ => ?_⟩
        simp only [faOpenLoop, if_neg hnot]
        exact _root_.Nat.le_refl 3,
     fun θ oa _ ⟨h0, h1⟩ => by
      dsimp [faOpenLoop]
      split_ifs
      · constructor <;> simp <;> linarith
      · have hdot : θ ⬝ᵥ ![1, 0] = θ 0 := by simp [dotProduct, Fin.sum_univ_two]
        rw [hdot]
        constructor
        · simp; linarith
        · simp; linarith⟩
  eta_bound θ hK := by
    rcases hK with ⟨h0, h1⟩
    rw [Nat.ceil_le]
    have hdot : θ ⬝ᵥ ![4 / 5, 3 / 5] = (4 / 5 : ℝ) * θ 0 + (3 / 5 : ℝ) * θ 1 := by
      simp [dotProduct, Fin.sum_univ_two]
      ring
    have hle : θ ⬝ᵥ ![4 / 5, 3 / 5] ≤ 4 / 5 := by
      rw [hdot]
      linarith
    have hmax : max (θ ⬝ᵥ ![4 / 5, 3 / 5] - 3 / 5) 0 ≤ 1 / 5 :=
      max_le (by linarith) (by norm_num)
    have hdiv : max (θ ⬝ᵥ ![4 / 5, 3 / 5] - 3 / 5) 0 / ((3 / 20 : ℝ) * (1 / 40)) ≤
        (1 / 5 : ℝ) / ((3 / 20 : ℝ) * (1 / 40)) :=
      div_le_div_of_nonneg_right hmax (by norm_num)
    linarith [show (1 / 5 : ℝ) / ((3 / 20 : ℝ) * (1 / 40)) ≤ (54 : ℝ) by norm_num]
  emits_on_warn _ _ _ warn := warn
  eta_alarm_step θ obs dist _ _ pos := by
    cases dist
    let rate : ℝ := (3 / 20 : ℝ) * (1 / 40)
    have hrate : 0 < rate := by norm_num
    let y : ℝ := max (θ ⬝ᵥ ![4 / 5, 3 / 5] - 3 / 5) 0 / rate
    change 0 < Nat.ceil y at pos
    change Nat.ceil (max ((faOpenLoop ![1, 0] ![4 / 5, 3 / 5] (3 / 5) (3 / 20) (1 / 40)).next θ
      (obs, true) () ⬝ᵥ ![4 / 5, 3 / 5] - 3 / 5) 0 / rate) < Nat.ceil y
    have hdot_next :
        (faOpenLoop ![1, 0] ![4 / 5, 3 / 5] (3 / 5) (3 / 20) (1 / 40)).next θ (obs, true) () ⬝ᵥ
            ![4 / 5, 3 / 5] =
          θ ⬝ᵥ ![4 / 5, 3 / 5] - rate := by
      simp only [faOpenLoop, ↓reduceIte, sub_dotProduct, smul_dotProduct, smul_eq_mul]
      have hnorm : (![4 / 5, 3 / 5] : Fin 2 → ℝ) ⬝ᵥ ![4 / 5, 3 / 5] = 1 := by
        simp [dotProduct, Fin.sum_univ_two]
        norm_num
      rw [hnorm]
      dsimp [rate]
      ring
    have hpos_diff : 0 < θ ⬝ᵥ ![4 / 5, 3 / 5] - 3 / 5 := by
      by_contra hle
      have hmax0 : max (θ ⬝ᵥ ![4 / 5, 3 / 5] - 3 / 5) 0 = 0 := max_eq_right (not_lt.mp hle)
      have hy0 : Nat.ceil y = 0 := by
        dsimp only [y]
        rw [hmax0, zero_div, Nat.ceil_zero]
      omega
    have hy_eq : y = (θ ⬝ᵥ ![4 / 5, 3 / 5] - 3 / 5) / rate := by
      dsimp only [y]
      rw [max_eq_left hpos_diff.le]
    cases hc : Nat.ceil y with
    | zero => omega
    | succ m =>
      have hy_le : y ≤ (m + 1 : ℝ) := by
        have := Nat.le_ceil y
        rw [hc] at this
        exact_mod_cast this
      have hm_ge : max (y - 1) 0 ≤ (m : ℝ) := max_le (by linarith) (Nat.cast_nonneg m)
      have hfinal :
          Nat.ceil (max ((faOpenLoop ![1, 0] ![4 / 5, 3 / 5] (3 / 5) (3 / 20) (1 / 40)).next θ
              (obs, true) () ⬝ᵥ ![4 / 5, 3 / 5] - 3 / 5) 0 / rate) ≤ m := by
        rw [Nat.ceil_le]
        exact le_trans (by
          rw [hdot_next]
          have hsub : (θ ⬝ᵥ ![4 / 5, 3 / 5] - rate - 3 / 5) / rate = y - 1 := by
            rw [hy_eq]
            field_simp [hrate.ne']
            ring
          by_cases h1 : 0 ≤ θ ⬝ᵥ ![4 / 5, 3 / 5] - rate - 3 / 5
          · rw [max_eq_left h1, hsub]
            exact le_max_left _ _
          · rw [max_eq_right (lt_of_not_ge h1).le, zero_div]
            exact le_max_right _ _) hm_ge
      exact _root_.Nat.lt_succ_of_le hfinal
  eta_alarm_zero θ obs _ _ _ heta := by
    have hle0 : max (θ ⬝ᵥ ![4 / 5, 3 / 5] - 3 / 5) 0 / ((3 / 20 : ℝ) * (1 / 40)) ≤ 0 := by
      simpa using Nat.ceil_le.mp (_root_.Nat.le_of_eq heta)
    have hmax : max (θ ⬝ᵥ ![4 / 5, 3 / 5] - 3 / 5) 0 ≤ 0 := by
      have h' := (div_le_iff₀ (show (0 : ℝ) < (3 / 20 : ℝ) * (1 / 40) by norm_num)).mp hle0
      linarith
    have hθ : θ ⬝ᵥ ![4 / 5, 3 / 5] ≤ 3 / 5 := by
      have := le_trans (le_max_left _ _) hmax
      linarith
    have hdot_next :
        (faOpenLoop ![1, 0] ![4 / 5, 3 / 5] (3 / 5) (3 / 20) (1 / 40)).next θ (obs, true) () ⬝ᵥ
            ![4 / 5, 3 / 5] =
          θ ⬝ᵥ ![4 / 5, 3 / 5] - (3 / 20 : ℝ) * (1 / 40) := by
      simp only [faOpenLoop, ↓reduceIte, sub_dotProduct, smul_dotProduct, smul_eq_mul]
      have hnorm : (![4 / 5, 3 / 5] : Fin 2 → ℝ) ⬝ᵥ ![4 / 5, 3 / 5] = 1 := by
        simp [dotProduct, Fin.sum_univ_two]
        norm_num
      rw [hnorm]
      ring
    have hmax' :
        max ((faOpenLoop ![1, 0] ![4 / 5, 3 / 5] (3 / 5) (3 / 20) (1 / 40)).next θ
            (obs, true) () ⬝ᵥ ![4 / 5, 3 / 5] - 3 / 5) 0 = 0 := by
      rw [hdot_next]
      exact max_eq_right (by linarith)
    change Nat.ceil (max _ 0 / ((3 / 20 : ℝ) * (1 / 40))) = 0
    rw [hmax', zero_div, Nat.ceil_zero]

theorem faOpenLoop_coupled_warn_trace (m : ℕ) (hm : m ≤ 18) :
    let L := fun _ : Unit => faOpenLoop ![1, 0] ![4 / 5, 3 / 5] (3 / 5) (3 / 20) (1 / 40)
    let cert := fun _ : Unit => faCertCoupled faThetaEnter
      (by rw [faThetaEnter_coords.1]; norm_num)
      (by rw [faThetaEnter_coords.2])
    let P := Becoming.AdaptiveLoops.jointProcess [()] L cert faObs faChannel faG
      (fun _ _ => 0) (fun _ => True)
    ∃ st : (Unit → ℕ) × (Unit → Fin 2 → ℝ),
      Generative.Trace P (fun _ => 22, fun _ => faThetaEnter) (List.replicate m ((), fun _ => ())) st ∧
      st.1 () = 22 - m ∧
      st.2 () = faWarnUpdate ![4 / 5, 3 / 5] (3 / 20) (fun _ => 1 / 40) faThetaEnter m := by
  intro L cert P
  induction m with
  | zero =>
    exact ⟨(fun _ => 22, fun _ => faThetaEnter), .nil _, rfl, rfl⟩
  | succ m ih =>
    obtain ⟨st, htr, hx, hθ⟩ := ih (_root_.Nat.le_of_lt (_root_.Nat.lt_of_succ_le hm))
    have hm_lt : m < 18 := _root_.Nat.lt_of_succ_le hm
    have hscore : (3 / 5 : ℝ) < st.2 () ⬝ᵥ ![4 / 5, 3 / 5] := by
      rw [hθ, linear_fa_warn_eq]
      have hdot_enter : faThetaEnter ⬝ᵥ ![4 / 5, 3 / 5] =
          (4 / 5 : ℝ) * (1 - (17 / 20 : ℝ) ^ 12) := by
        simp only [dotProduct, Fin.sum_univ_two, faThetaEnter_coords.1, faThetaEnter_coords.2,
          Matrix.cons_val_zero, Matrix.cons_val_one]
        ring
      have hnorm : (![4 / 5, 3 / 5] : Fin 2 → ℝ) ⬝ᵥ ![4 / 5, 3 / 5] = 1 := by
        simp [dotProduct, Fin.sum_univ_two]
        norm_num
      rw [hdot_enter, hnorm]
      simp only [Finset.sum_const, Finset.card_range, nsmul_eq_mul]
      have hm17 : (m : ℝ) ≤ 17 := Nat.cast_le.mpr (_root_.Nat.le_pred_of_lt hm_lt)
      have hnum : (3 / 5 : ℝ) < (4 / 5 : ℝ) * (1 - (17 / 20 : ℝ) ^ 12) -
          (3 / 20 : ℝ) * 1 * (17 * (1 / 40)) := by
        norm_num
      have hmul : (3 / 20 : ℝ) * 1 * ((m : ℝ) * (1 / 40)) ≤
          (3 / 20 : ℝ) * 1 * (17 * (1 / 40)) :=
        mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_right hm17 (by norm_num)) (by norm_num)
      linarith
    have hx_lt23 : st.1 () < 23 := by omega
    have hstep : P.step st ((), fun _ => ())
        (Becoming.AdaptiveLoops.jointStep [()] L faObs faChannel faG (fun _ _ => 0)
          st ((), fun _ => ())) := by
      exact ⟨⟨trivial, fun _ _ _ => trivial⟩, rfl⟩
    have htr' : Generative.Trace P (fun _ => 22, fun _ => faThetaEnter)
        (List.replicate (m + 1) ((), fun _ => ()))
        (Becoming.AdaptiveLoops.jointStep [()] L faObs faChannel faG (fun _ _ => 0)
          st ((), fun _ => ())) := by
      rw [List.replicate_succ']
      exact Generative.trace_append_iff.mpr ⟨st, htr, Generative.trace_singleton_iff.mpr hstep⟩
    have hx_ge5 : 5 ≤ st.1 () := by omega
    have hdraw : (L ()).draw (st.2 ()) () = 4 := by
      simp only [L, faOpenLoop, if_pos hscore]
    have halarm : faChannel (fun i => (L i).emitAlarm (st.2 i) (faObs i st.1))
        (fun i => (L i).silenceLoad (st.2 i)) () = true := by
      simp only [faChannel, faObs, L, faOpenLoop]
      rw [Becoming.AdaptiveLoops.natBlt_true_iff.mpr hx_lt23]
      rfl
    have hx' : (Becoming.AdaptiveLoops.jointStep [()] L faObs faChannel faG (fun _ _ => 0)
        st ((), fun _ => ())).1 () = 22 - (m + 1) := by
      change (st.1 () - ((L ()).draw (st.2 ()) () + 0)) +
          faG () (fun _ => st.1 () - ((L ()).draw (st.2 ()) () + 0)) = 22 - (m + 1)
      rw [hdraw, _root_.Nat.add_zero]
      dsimp [faG]
      have hge1 : 1 ≤ st.1 () - 4 := by omega
      rw [if_pos hge1]
      omega
    have hθ' : (Becoming.AdaptiveLoops.jointStep [()] L faObs faChannel faG (fun _ _ => 0)
        st ((), fun _ => ())).2 () =
        faWarnUpdate ![4 / 5, 3 / 5] (3 / 20) (fun _ => 1 / 40) faThetaEnter (m + 1) := by
      change (L ()).next (st.2 ()) (faObs () st.1,
        faChannel (fun i => (L i).emitAlarm (st.2 i) (faObs i st.1))
          (fun i => (L i).silenceLoad (st.2 i)) ()) () = _
      rw [halarm]
      simp only [L, faOpenLoop, ↓reduceIte, faWarnUpdate, hθ]
    exact ⟨_, htr', hx', hθ'⟩

theorem faWarn_coupled_score_gt (m : ℕ) (hm : m < 18) :
    (3 / 5 : ℝ) <
      (faWarnUpdate ![4 / 5, 3 / 5] (3 / 20) (fun _ => 1 / 40) faThetaEnter m) ⬝ᵥ ![4 / 5, 3 / 5] := by
  have hscore := (linear_fa_leakage_hysteresis ![1, 0] ![4 / 5, 3 / 5]
    (3 / 20) (1 / 40) (3 / 5) 4 3 3 22 5 (by norm_num) (by norm_num)
    (fun k => 1 - faSafeSeq k ⬝ᵥ ![1, 0]) (fun _ => 1 / 40) (fun _ => le_rfl) 0 12 18 (by decide)).2
  have hthr : (3 / 5 : ℝ) <
      (0 : Fin 2 → ℝ) ⬝ᵥ ![4 / 5, 3 / 5] +
        (3 / 20 : ℝ) * ((![1, 0] : Fin 2 → ℝ) ⬝ᵥ ![4 / 5, 3 / 5]) *
          (∑ k ∈ Finset.range 12, (1 - faSafeSeq k ⬝ᵥ ![1, 0])) -
        ((18 - 1 : ℕ) : ℝ) * ((3 / 20 : ℝ) * (1 / 40) * ((![4 / 5, 3 / 5] : Fin 2 → ℝ) ⬝ᵥ ![4 / 5, 3 / 5])) := by
    have h12 : (faSafeSeq 12) ⬝ᵥ ![4 / 5, 3 / 5] =
        (0 : Fin 2 → ℝ) ⬝ᵥ ![4 / 5, 3 / 5] +
          (3 / 20 : ℝ) * ((![1, 0] : Fin 2 → ℝ) ⬝ᵥ ![4 / 5, 3 / 5]) *
            (∑ k ∈ Finset.range 12, (1 - faSafeSeq k ⬝ᵥ ![1, 0])) := by
      rw [faSafeSeq_eq_update 12]
      exact linear_fa_margin_shift ![1, 0] ![4 / 5, 3 / 5] (3 / 20)
        (fun k => 1 - faSafeSeq k ⬝ᵥ ![1, 0]) 0 12
    rw [← h12]
    have hdot : (faSafeSeq 12) ⬝ᵥ ![4 / 5, 3 / 5] = (4 / 5 : ℝ) * (1 - (17 / 20 : ℝ) ^ 12) := by
      simp only [dotProduct, Fin.sum_univ_two, (faSafeSeq_coords 12).1, (faSafeSeq_coords 12).2,
        Matrix.cons_val_zero, Matrix.cons_val_one]
      ring
    have hnorm : (![4 / 5, 3 / 5] : Fin 2 → ℝ) ⬝ᵥ ![4 / 5, 3 / 5] = 1 := by
      simp [dotProduct, Fin.sum_univ_two]
      norm_num
    rw [hdot, hnorm]
    norm_num
  rw [← faSafeSeq_eq_update 12] at hscore
  exact (hscore hthr).1 m hm

theorem any_cert_coupled_maxLag_ge_18
    (c : Becoming.AdaptiveLoops.LoopCertificate
      (faOpenLoop ![1, 0] ![4 / 5, 3 / 5] (3 / 5) (3 / 20) (1 / 40)) faThetaEnter)
    (htol : c.tol (true, true) ()) :
    18 ≤ c.maxLag := by
  let L := faOpenLoop ![1, 0] ![4 / 5, 3 / 5] (3 / 5) (3 / 20) (1 / 40)
  have hrun : ∀ m : ℕ, m ≤ 17 →
      c.K (faWarnUpdate ![4 / 5, 3 / 5] (3 / 20) (fun _ => 1 / 40) faThetaEnter m) ∧
      c.eta (faWarnUpdate ![4 / 5, 3 / 5] (3 / 20) (fun _ => 1 / 40) faThetaEnter m) + m ≤ c.maxLag := by
    intro m hm
    induction m with
    | zero =>
      exact ⟨c.init_in, c.eta_bound faThetaEnter c.init_in⟩
    | succ m ih =>
      obtain ⟨hKm, hetam⟩ := ih (_root_.Nat.le_of_lt (_root_.Nat.lt_of_succ_le hm))
      have hnext : L.next (faWarnUpdate ![4 / 5, 3 / 5] (3 / 20) (fun _ => 1 / 40) faThetaEnter m)
          (true, true) () =
          faWarnUpdate ![4 / 5, 3 / 5] (3 / 20) (fun _ => 1 / 40) faThetaEnter (m + 1) := rfl
      have hK' : c.K (faWarnUpdate ![4 / 5, 3 / 5] (3 / 20) (fun _ => 1 / 40) faThetaEnter (m + 1)) := by
        rw [← hnext]
        exact c.cert.closed _ ((true, true), ()) _ ⟨htol, rfl⟩ hKm
      have hpos : 0 < c.eta (faWarnUpdate ![4 / 5, 3 / 5] (3 / 20) (fun _ => 1 / 40) faThetaEnter m) := by
        by_contra h0
        have hzero : c.eta (faWarnUpdate ![4 / 5, 3 / 5] (3 / 20) (fun _ => 1 / 40) faThetaEnter m) = 0 :=
          _root_.Nat.eq_zero_of_le_zero (_root_.Nat.le_of_not_lt h0)
        have hnotfav := (c.cert.within _ hKm).2.2 hzero
        exact hnotfav.1 (faWarn_coupled_score_gt m (by omega))
      have hlt : c.eta (faWarnUpdate ![4 / 5, 3 / 5] (3 / 20) (fun _ => 1 / 40) faThetaEnter (m + 1)) <
          c.eta (faWarnUpdate ![4 / 5, 3 / 5] (3 / 20) (fun _ => 1 / 40) faThetaEnter m) := by
        rw [← hnext]
        exact c.eta_alarm_step _ true () htol hKm hpos
      refine ⟨hK', by omega⟩
  obtain ⟨hK17, heta17⟩ := hrun 17 (_root_.Nat.le_refl 17)
  have hpos17 : 0 < c.eta (faWarnUpdate ![4 / 5, 3 / 5] (3 / 20) (fun _ => 1 / 40) faThetaEnter 17) := by
    by_contra h0
    have hzero : c.eta (faWarnUpdate ![4 / 5, 3 / 5] (3 / 20) (fun _ => 1 / 40) faThetaEnter 17) = 0 :=
      _root_.Nat.eq_zero_of_le_zero (_root_.Nat.le_of_not_lt h0)
    exact (c.cert.within _ hK17).2.2 hzero |>.1 (faWarn_coupled_score_gt 17 (by decide))
  omega

/-- **Phase 2 Witness (`linear_fa_witness_rho_4_5`)** on `Fin 2 → ℝ` (`φ_safe = ![1, 0]`,
`η = 3/20`, `v_rest = 3/5`, `p_warn = 1/40`, `T_safe = 12`, `x_warn = 22`, `x_crit = 5`, `R = 3`,
`d_agg = 4`, `d_rest = 3`, `warnLevel = 23`):
1. With `ρ = 0` (`φ_warn = ![0, 1]`), safe training keeps `θ ⬝ᵥ φ_warn = 0`, and
   `Becoming.AdaptiveLoops.assume_guarantee_joint_kernel` (`maxLag = 0`) certifies
   `Becoming.Viability.Kernel` from `(fun _ => 22, fun _ => faThetaEnter)`.
2. With `ρ = 4/5` (`φ_warn = ![4/5, 3/5]`), `faThetaEnter ⬝ᵥ φ_warn = (4/5)*(1 - (17/20)^12) > 3/5`,
   remains `> 3/5` through `m = 17` (`m < 18`), and the exact same `jointProcess` starting at
   `(fun _ => 22, fun _ => faThetaEnter)` reaches `x 18 = 4 < 5`, refuting `Viability.Kernel`.
3. Moreover, any `LoopCertificate` for `(true, true)` at `faThetaEnter` requires `18 ≤ maxLag`, and
   `assume_guarantee_joint_viable`'s `warn_margin` (`5 + (maxLag + 1) * 4 ≤ 23`) fails for all
   `18 ≤ maxLag`. -/
theorem linear_fa_witness_rho_4_5 :
    (∀ t, (faSafeSeq t) ⬝ᵥ ![0, 1] = 0) ∧
    Becoming.Viability.Kernel
      (Becoming.AdaptiveLoops.jointProcess [()]
        (fun _ => faOpenLoop ![1, 0] ![0, 1] (3 / 5) (3 / 20) (1 / 40))
        (fun _ => faCertZero faThetaEnter (by
          simp [dotProduct, Fin.sum_univ_two, faThetaEnter_coords.2]; norm_num))
        faObs faChannel faG (fun _ _ => 0) (fun _ => True))
      (Becoming.AdaptiveLoops.jointGuard [()]
        (fun _ => faOpenLoop ![1, 0] ![0, 1] (3 / 5) (3 / 20) (1 / 40))
        (fun _ => faCertZero faThetaEnter (by
          simp [dotProduct, Fin.sum_univ_two, faThetaEnter_coords.2]; norm_num))
        (fun _ => 5))
      (fun _ => 22, fun _ => faThetaEnter) ∧
    (faThetaEnter ⬝ᵥ ![4 / 5, 3 / 5] = (4 / 5 : ℝ) * (1 - (17 / 20 : ℝ) ^ 12) ∧
      (∀ m, m < 18 → (3 / 5 : ℝ) <
        (faWarnUpdate ![4 / 5, 3 / 5] (3 / 20) (fun _ => 1 / 40) faThetaEnter m) ⬝ᵥ ![4 / 5, 3 / 5])) ∧
    (¬ Becoming.Viability.Kernel
      (Becoming.AdaptiveLoops.jointProcess [()]
        (fun _ => faOpenLoop ![1, 0] ![4 / 5, 3 / 5] (3 / 5) (3 / 20) (1 / 40))
        (fun _ => faCertCoupled faThetaEnter
          (by rw [faThetaEnter_coords.1]; norm_num)
          (by rw [faThetaEnter_coords.2]))
        faObs faChannel faG (fun _ _ => 0) (fun _ => True))
      (Becoming.AdaptiveLoops.jointGuard [()]
        (fun _ => faOpenLoop ![1, 0] ![4 / 5, 3 / 5] (3 / 5) (3 / 20) (1 / 40))
        (fun _ => faCertCoupled faThetaEnter
          (by rw [faThetaEnter_coords.1]; norm_num)
          (by rw [faThetaEnter_coords.2]))
        (fun _ => 5))
      (fun _ => 22, fun _ => faThetaEnter)) ∧
    (∀ c : Becoming.AdaptiveLoops.LoopCertificate
        (faOpenLoop ![1, 0] ![4 / 5, 3 / 5] (3 / 5) (3 / 20) (1 / 40)) faThetaEnter,
      c.tol (true, true) () → 18 ≤ c.maxLag) ∧
    (∀ maxLag : ℕ, 18 ≤ maxLag → ¬ (5 + (maxLag + 1) * 4 ≤ 23)) := by
  refine ⟨?_, ?_, ⟨?_, ?_⟩, ?_, any_cert_coupled_maxLag_ge_18, fun maxLag hM => by omega⟩
  · intro t
    simp [dotProduct, Fin.sum_univ_two, (faSafeSeq_coords t).2]
  · refine Becoming.AdaptiveLoops.assume_guarantee_joint_kernel [()] [()]
      (fun j => by cases j; exact .head _)
      (fun _ => faOpenLoop ![1, 0] ![0, 1] (3 / 5) (3 / 20) (1 / 40))
      (fun _ => faThetaEnter)
      (fun _ => faCertZero faThetaEnter (by
        simp [dotProduct, Fin.sum_univ_two, faThetaEnter_coords.2]; norm_num))
      faObs faChannel faG (fun _ _ => 0) (fun _ => 0) (fun _ => True)
      (fun _ _ _ => _root_.Nat.zero_le 0)
      (fun _ => 5) (fun _ => 23) (fun _ => 3) (fun _ => 22)
      (fun _ _ => True)
      (fun _ _ x j _ lt => by
        cases j
        exact Becoming.AdaptiveLoops.natBlt_true_iff.mpr lt)
      (fun j _ => ⟨(), .head _, trivial⟩)
      (fun emit load _ _ ⟨_, _, hemit, hload⟩ _ => by
        simp only [faChannel]
        exact Becoming.ListTests.and_true_iff.mpr ⟨hemit, Nat.ble_eq_true_of_le hload⟩)
      faG_rises
      (fun j => by cases j; show 5 ≤ 5 - 3 + faG () (fun _ => 5 - 3); decide)
      (fun j => by cases j; show 3 + 0 + 0 ≤ 3; decide)
      (fun j => by
        cases j
        show 5 + (Becoming.AdaptiveLoops.foldNatMax [()] (fun _ => 0) + 1) *
          (Becoming.AdaptiveLoops.sumDraws [()] (fun _ _ => 4) () + 0) ≤ 23
        decide)
      (fun j => by
        cases j
        show 5 + Becoming.AdaptiveLoops.foldNatMax [()] (fun _ => 0) *
          (Becoming.AdaptiveLoops.sumDraws [()] (fun _ _ => 4) () + 0) ≤ 22
        decide)
  · simp only [dotProduct, Fin.sum_univ_two, faThetaEnter_coords.1, faThetaEnter_coords.2,
      Matrix.cons_val_zero, Matrix.cons_val_one]
    ring
  · exact faWarn_coupled_score_gt
  · intro hkern
    obtain ⟨st, htr, hx, _⟩ := faOpenLoop_coupled_warn_trace 18 (by decide)
    have hguard := hkern st ⟨_, htr⟩
    have h54 : 5 ≤ st.1 () := hguard.1 ()
    omega

end Becoming.AlignmentReals
