import AlignmentReals
import FreeEnergyReals
import ExpectedFreeEnergyReals
import CellsUnderNoise
import LinearBlankets
import EntropyProduction
import RegimeReals
import Representation
import SlowingDown
import Mathlib.Analysis.Normed.Lp.PiLp

/-!
# Becoming over the reals: unified cross-silo bridges and witnesses

AI-written (Wave U5, November 2026).

This periphery module unifies all nine Mathlib periphery modules (`AlignmentReals`,
`FreeEnergyReals`, `ExpectedFreeEnergyReals`, `CellsUnderNoise`, `LinearBlankets`,
`EntropyProduction`, `RegimeReals`, `Representation`, `SlowingDown`) across five cross-silo
constructions:

1. **Slowing down, iterated variance, policy inertia, and regime collapse**
   (`iterVar`, `metricSlack_succ_unfold`, `iterVar_eq_metricSlack`,
   `iterVar_tendsto_stationaryVariance`, `metricSlack_stationaryVariance_bridge`,
   `slowingDown_inertia_regime_collapse`): couples `SlowingDown.variance_step` and
   `SlowingDown.stationaryVariance` to `AlignmentReals.metricSlack`, and routes transcritical
   relaxation (`SlowingDown.drawnMultiplier`) via `AlignmentReals.inertia_lag_headroom_penalty`
   and `Real.toNNReal` into `Becoming.RegimeMargin.Drawn.falls_of_below`, while retaining
   `SlowingDown.drawn_level_read` and `SlowingDown.need_not_read`.
2. **Finite probability measures, exergy dissipation, Markov survival, and fluctuation bounds**
   (`finiteLawOfMeasure`, `finiteLawOfMeasure_expect_eq_integral`,
   `finiteLawOfMeasure_prob_eq_real`, `fluctuation_complement_survival_ge`,
   `finiteLawOfMeasure_exergy_fluctuation_survival`): bridges `MeasureTheory.Measure` on finite
   types (`{F C Ω : Type}`) to `AlignmentReals.FiniteLaw`, joins
   `EntropyProduction.ExpectedDissipatesOn.of_exergy`, `expected_takers_within`, and
   `Representation.expected_balance` to `AlignmentReals.markov_survival_sufficient`, and couples
   `EntropyProduction.gain_probability_le` honestly with
   `AlignmentReals.spike_threshold_survival_upper`.
3. **Gibbs variational inference, exchangeability, and expected-free-energy seeking**
   (`gibbsWeight`, `gibbsWeight_eq_posterior`, `gibbsWeight_eq_softmax`,
   `gibbs_minimizes_freeEnergy_exchangeable`): unites `FreeEnergy.posterior` /
   `FreeEnergy.minimizes_iff_posterior`, `ExpectedFreeEnergy.softmax` /
   `ExpectedFreeEnergy.seeking_blind_to_split`, and `CellsUnderNoise.Exchangeable` /
   `marginal_eq` / `distinct_le`.
4. **Linear blankets, Euler contraction, feature-leakage hysteresis, and damped runaway**
   (`LocalMatrixOpNorm`, `euler_iterate_eq_pow_mulVec`, `euler_unit_iterate_eq_drawnMultiplier`,
   `emA_pow_four_norm_lt_one`, `emA_rate_lt_one`,
   `linear_blanket_vs_fa_leakage_and_damped_runaway`): proves `(LinearBlankets.euler B h)^[t] x`
   equals `((1 - h • B) ^ t) *ᵥ x`, specializes 1D to `SlowingDown.drawnMultiplier`, proves
   `‖LinearBlankets.Autonomous.emA ^ 4‖ < 1` and `Representation.rate emA < 1` under the
   self-contained `L_∞` operator norm (`LocalMatrixOpNorm` over `Mathlib.Analysis.Normed.Lp.PiLp`),
   and contrasts synchronous blanket loss (`em_loses_internal_external` vs
   `precision_zero_of_footnote13` and `mode_unread_iff`) with
   `AlignmentReals.{linear_fa_tabular_invariant, linear_fa_leakage_hysteresis}`.
5. **Cross-module concrete numerical witness** (`becoming_reals_cross_module_witness`):
   verifies explicit instances across all nine imported Mathlib periphery modules.

Every declaration is named and non-private, uses no `lemma` or `class`, and depends only on
Lean's standard axioms (`propext`, `Classical.choice`, `Quot.sound`) through Mathlib.
-/

namespace Becoming.Reals

/-! ## Section 1: `SlowingDown` ↔ `AlignmentReals` ↔ `RegimeReals` -/

section SlowingInertiaRegime

open MeasureTheory ProbabilityTheory Filter Topology Set

/-- Iterated one-step AR(1) deviation variance from initial variance `v₀`. -/
noncomputable def iterVar (a s : ℝ) : ℕ → ℝ → ℝ
  | 0, v₀ => v₀
  | m + 1, v₀ => a ^ 2 * iterVar a s m v₀ + s

/-- Outer-step unfolding of `AlignmentReals.metricSlack`, proved by induction generalizing `r`. -/
theorem metricSlack_succ_unfold (α ε : ℝ) (m : ℕ) (r : ℝ) :
    AlignmentReals.metricSlack α ε (m + 1) r = α * AlignmentReals.metricSlack α ε m r + ε := by
  induction m generalizing r with
  | zero => rfl
  | succ m ih =>
    rw [AlignmentReals.metricSlack, ih (α * r + ε)]
    rfl

/-- Iterated AR(1) variance equals `AlignmentReals.metricSlack (a ^ 2) s m v₀`. -/
theorem iterVar_eq_metricSlack (a s : ℝ) (m : ℕ) (v₀ : ℝ) :
    iterVar a s m v₀ = AlignmentReals.metricSlack (a ^ 2) s m v₀ := by
  induction m with
  | zero => rfl
  | succ m ih => rw [iterVar, ih, metricSlack_succ_unfold]

/-- When `0 ≤ a ^ 2 < 1`, iterated variance converges to `SlowingDown.stationaryVariance a s`. -/
theorem iterVar_tendsto_stationaryVariance {a s v₀ : ℝ}
    (ha0 : 0 ≤ a ^ 2) (ha1 : a ^ 2 < 1) :
    Filter.Tendsto (fun m => iterVar a s m v₀) Filter.atTop
      (nhds (SlowingDown.stationaryVariance a s)) := by
  have heq : (fun m => iterVar a s m v₀) =
      fun m => (a ^ 2) ^ m * v₀ + s * ((1 - (a ^ 2) ^ m) / (1 - a ^ 2)) := by
    funext m
    rw [iterVar_eq_metricSlack, AlignmentReals.metricSlack_eq ha1.ne]
  rw [heq]
  have hpow : Filter.Tendsto (fun m => (a ^ 2) ^ m) Filter.atTop (nhds 0) :=
    tendsto_pow_atTop_nhds_zero_of_lt_one ha0 ha1
  have h1 : Filter.Tendsto (fun m => (a ^ 2) ^ m * v₀) Filter.atTop (nhds (0 * v₀)) :=
    hpow.mul_const v₀
  have h2 : Filter.Tendsto (fun m => s * ((1 - (a ^ 2) ^ m) / (1 - a ^ 2))) Filter.atTop
      (nhds (s * ((1 - 0) / (1 - a ^ 2)))) :=
    ((tendsto_const_nhds.sub hpow).div_const (1 - a ^ 2)).const_mul s
  simpa [SlowingDown.stationaryVariance] using h1.add h2

/-- **Theorem 1A (`metricSlack_stationaryVariance_bridge`).**
For an AR(1) deviation process `Y (m + 1) = SlowingDown.step a (Y m) (E m)` with independent
finite-variance noise of variance `s` and `a ^ 2 < 1`:
1. `Var[Y m; μ] = iterVar a s m Var[Y 0; μ] = AlignmentReals.metricSlack (a ^ 2) s m Var[Y 0; μ]`.
2. Every variance along the trajectory is bounded by `max Var[Y 0; μ] (stationaryVariance a s)` via
   `AlignmentReals.metricSlack_le_max`.
3. `Var[Y m; μ]` converges to `SlowingDown.stationaryVariance a s`. -/
theorem metricSlack_stationaryVariance_bridge {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {a s : ℝ} (ha1 : a ^ 2 < 1) {Y E : ℕ → Ω → ℝ}
    (hY : ∀ m, MemLp (Y m) 2 μ) (hE : ∀ m, MemLp (E m) 2 μ)
    (hind : ∀ m, Y m ⟂ᵢ[μ] E m)
    (hstep : ∀ m, Y (m + 1) = SlowingDown.step a (Y m) (E m))
    (hvarE : ∀ m, Var[E m; μ] = s) :
    (∀ m, Var[Y m; μ] = iterVar a s m Var[Y 0; μ]) ∧
    (∀ m, Var[Y m; μ] = AlignmentReals.metricSlack (a ^ 2) s m Var[Y 0; μ]) ∧
    (∀ m, Var[Y m; μ] ≤ max Var[Y 0; μ] (SlowingDown.stationaryVariance a s)) ∧
    Filter.Tendsto (fun m => Var[Y m; μ]) Filter.atTop
      (nhds (SlowingDown.stationaryVariance a s)) := by
  have ha0 : 0 ≤ a ^ 2 := sq_nonneg a
  have hs0 : 0 ≤ s := by
    rw [← hvarE 0]
    exact variance_nonneg (E 0) μ
  have hiter : ∀ m, Var[Y m; μ] = iterVar a s m Var[Y 0; μ] := by
    intro m
    induction m with
    | zero => rfl
    | succ m ih =>
      rw [hstep m, SlowingDown.variance_step a (hY m) (hE m) (hind m), hvarE m, ih, iterVar]
  have hslack : ∀ m, Var[Y m; μ] = AlignmentReals.metricSlack (a ^ 2) s m Var[Y 0; μ] :=
    fun m => (hiter m).trans (iterVar_eq_metricSlack a s m Var[Y 0; μ])
  have hmax : ∀ m, Var[Y m; μ] ≤ max Var[Y 0; μ] (SlowingDown.stationaryVariance a s) := by
    intro m
    rw [hslack m]
    simpa [SlowingDown.stationaryVariance] using
      AlignmentReals.metricSlack_le_max ha0 ha1 hs0 m Var[Y 0; μ]
  have hlim : Filter.Tendsto (fun m => Var[Y m; μ]) Filter.atTop
      (nhds (SlowingDown.stationaryVariance a s)) := by
    have hfun : (fun m => Var[Y m; μ]) = fun m => iterVar a s m Var[Y 0; μ] := funext hiter
    rw [hfun]
    exact iterVar_tendsto_stationaryVariance ha0 ha1
  exact ⟨hiter, hslack, hmax, hlim⟩

/-- **Theorem 1B (`slowingDown_inertia_regime_collapse`).**
Coupling `a := SlowingDown.drawnMultiplier h r q ∈ (0, 1)` with blending rate `α := 1 - a`
(so `(1 - α) / α = a / (1 - a)`):
1. `SlowingDown.drawn_level_read` recovers the transcritical rest `drawnRest r K q`.
2. When `H₁ + L * Y < (a / (1 - a)) * (H₁ - H₂)`, `AlignmentReals.inertia_lag_headroom_penalty`
   breaches `((H₂ + y₂ : ℕ) : ℝ)` at finite time `t`, and casting via `Real.toNNReal` into
   `Becoming.RegimeMargin.Drawn.falls_of_below` certifies `Becoming.RegimeMargin.Drawn.Falls` from
   `(Real.toNNReal (inertiaStock ... t), r_init)` whenever a threshold state `q_crit` at or above
   `((H₂ + y₂ : ℕ) : NNReal)` falls.
3. By `SlowingDown.need_not_read`, no reading from the autocorrelation `a` alone detects an
   unmeasured dependent's need. -/
theorem slowingDown_inertia_regime_collapse (H₁ H₂ y₂ Y L : ℕ) (hHY : Y ≤ H₁) (hH : H₂ < H₁)
    {h r K q : ℝ} (hh : 0 < h) (hr : 0 < r) (hK : K ≠ 0) (hq : q < r) (hstep : h * (r - q) < 1)
    {A : NNReal → NNReal → NNReal} {H hi : NNReal}
    (rises : Becoming.RegimeMargin.Drawn.reals.Rises A)
    (band : Becoming.RegimeMargin.Drawn.reals.Band A H hi)
    {q_crit : NNReal × NNReal} (hcrit_low : ((H₂ + y₂ : ℕ) : NNReal) ≤ q_crit.1)
    (hcrit_hi1 : q_crit.1 ≤ hi) (hcrit_hi2 : q_crit.2 ≤ hi)
    (hcrit_falls : Becoming.RegimeMargin.Drawn.Falls A H q_crit)
    (hthresh : (H₁ : ℝ) + (L : ℝ) * (Y : ℝ) <
      (SlowingDown.drawnMultiplier h r q / (1 - SlowingDown.drawnMultiplier h r q)) *
        ((H₁ : ℝ) - (H₂ : ℝ)))
    (r_init : NNReal) (hr_init : r_init ≤ q_crit.2) (x_ref : ℝ) (R_read : ℝ → ℝ) :
    let a := SlowingDown.drawnMultiplier h r q
    let α := 1 - a
    a ∈ Ico (0 : ℝ) 1 ∧
    (1 - α) / α = a / (1 - a) ∧
    SlowingDown.drawnRest r K q = K * (1 - a) / (h * r) ∧
    (∃ t : ℕ,
      AlignmentReals.inertiaStock (H₁ : ℝ) (H₂ : ℝ) (Y : ℝ) L α
        (((H₂ + y₂) + H₁ * (L + 1) : ℕ) : ℝ) t < ((H₂ + y₂ : ℕ) : ℝ) ∧
      Becoming.RegimeMargin.Drawn.Falls A H
        (Real.toNNReal (AlignmentReals.inertiaStock (H₁ : ℝ) (H₂ : ℝ) (Y : ℝ) L α
          (((H₂ + y₂) + H₁ * (L + 1) : ℕ) : ℝ) t), r_init)) ∧
    (∃ d : ℝ, R_read a ≠ x_ref - d) := by
  intro a α
  have hmul_pos : 0 < h * (r - q) := mul_pos hh (sub_pos.mpr hq)
  have ha0 : 0 < a := by dsimp [a, SlowingDown.drawnMultiplier]; linarith
  have ha1 : a < 1 := by dsimp [a, SlowingDown.drawnMultiplier]; linarith
  have hα0 : 0 < α := by dsimp [α]; linarith
  have hα1 : α < 1 := by dsimp [α]; linarith
  have hratio : (1 - α) / α = a / (1 - a) := by
    dsimp [α]
    ring
  have hthresh' : (H₁ : ℝ) + (L : ℝ) * (Y : ℝ) < ((1 - α) / α) * ((H₁ : ℝ) - (H₂ : ℝ)) := by
    rw [hratio]
    exact hthresh
  obtain ⟨t, hbreach⟩ :=
    (AlignmentReals.inertia_lag_headroom_penalty H₁ H₂ y₂ Y L α hα0 hα1 hHY hH).2 hthresh'
  have hcast_le : Real.toNNReal (AlignmentReals.inertiaStock (H₁ : ℝ) (H₂ : ℝ) (Y : ℝ) L α
      (((H₂ + y₂) + H₁ * (L + 1) : ℕ) : ℝ) t) ≤ ((H₂ + y₂ : ℕ) : NNReal) :=
    Real.toNNReal_le_iff_le_coe.mpr (le_of_lt hbreach)
  have hbelow : Becoming.RegimeMargin.Drawn.reals.Below
      (Real.toNNReal (AlignmentReals.inertiaStock (H₁ : ℝ) (H₂ : ℝ) (Y : ℝ) L α
        (((H₂ + y₂) + H₁ * (L + 1) : ℕ) : ℝ) t), r_init) q_crit :=
    ⟨le_trans hcast_le hcrit_low, hr_init⟩
  have hfalls : Becoming.RegimeMargin.Drawn.Falls A H
      (Real.toNNReal (AlignmentReals.inertiaStock (H₁ : ℝ) (H₂ : ℝ) (Y : ℝ) L α
        (((H₂ + y₂) + H₁ * (L + 1) : ℕ) : ℝ) t), r_init) :=
    Becoming.RegimeMargin.Drawn.falls_of_below rises band hbelow hcrit_hi1 hcrit_hi2 hcrit_falls
  exact ⟨⟨ha0.le, ha1⟩, hratio, SlowingDown.drawn_level_read q hh.ne' hr.ne' hK,
    ⟨t, hbreach, hfalls⟩, SlowingDown.need_not_read x_ref a R_read⟩

end SlowingInertiaRegime

/-! ## Section 2: `EntropyProduction` ↔ `Representation` ↔ `AlignmentReals` -/

section EntropyMarkovFluctuation

open MeasureTheory

/-- Finite-space probability law `AlignmentReals.FiniteLaw` induced by a `MeasureTheory.Measure`
on a finite measurable singleton space `{Ω : Type}`. -/
noncomputable def finiteLawOfMeasure {Ω : Type} [Fintype Ω] [MeasurableSpace Ω]
    [MeasurableSingletonClass Ω] (μ : Measure Ω) [IsProbabilityMeasure μ] :
    AlignmentReals.FiniteLaw (Finset.univ : Finset Ω) where
  w ω := μ.real {ω}
  nonneg _ _ := MeasureTheory.measureReal_nonneg
  total := by
    have hdisj : ((Finset.univ : Finset Ω) : Set Ω).PairwiseDisjoint (fun ω => ({ω} : Set Ω)) := by
      intro x _ y _ hxy
      simp [hxy]
    have hsum : μ (⋃ ω ∈ (Finset.univ : Finset Ω), ({ω} : Set Ω)) =
        ∑ ω ∈ (Finset.univ : Finset Ω), μ {ω} :=
      measure_biUnion_finset hdisj (fun ω _ => measurableSet_singleton ω)
    have huniv : (⋃ ω ∈ (Finset.univ : Finset Ω), ({ω} : Set Ω)) = Set.univ := by
      ext ω
      simp
    rw [huniv, measure_univ] at hsum
    have hreal : ∑ ω : Ω, μ.real {ω} = (∑ ω : Ω, μ {ω}).toReal := by
      rw [ENNReal.toReal_sum (fun ω _ => measure_ne_top μ {ω})]
      rfl
    rw [hreal, ← hsum, ENNReal.toReal_one]

/-- Expectation under `finiteLawOfMeasure μ` equals the Bochner integral against `μ`. -/
theorem finiteLawOfMeasure_expect_eq_integral {Ω : Type} [Fintype Ω] [MeasurableSpace Ω]
    [MeasurableSingletonClass Ω] (μ : Measure Ω) [IsProbabilityMeasure μ] (f : Ω → ℝ) :
    (finiteLawOfMeasure μ).expect f = ∫ ω, f ω ∂μ := by
  rw [integral_fintype]
  · refine Finset.sum_congr rfl fun ω _ => ?_
    simp [finiteLawOfMeasure, Measure.real, smul_eq_mul]
  · exact Integrable.of_finite

/-- Event probability under `finiteLawOfMeasure μ` equals `μ.real {ω | E ω}`. -/
theorem finiteLawOfMeasure_prob_eq_real {Ω : Type} [Fintype Ω] [MeasurableSpace Ω]
    [MeasurableSingletonClass Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (E : Ω → Prop) [DecidablePred E] :
    (finiteLawOfMeasure μ).prob E = μ.real {ω | E ω} := by
  have hdisj : ((Finset.univ.filter E : Finset Ω) : Set Ω).PairwiseDisjoint
      (fun ω => ({ω} : Set Ω)) := by
    intro x _ y _ hxy
    simp [hxy]
  have hsum : μ (⋃ ω ∈ Finset.univ.filter E, ({ω} : Set Ω)) =
      ∑ ω ∈ Finset.univ.filter E, μ {ω} :=
    measure_biUnion_finset hdisj (fun ω _ => measurableSet_singleton ω)
  have hset : (⋃ ω ∈ Finset.univ.filter E, ({ω} : Set Ω)) = {ω | E ω} := by
    ext ω
    simp
  rw [hset] at hsum
  have hreal : μ.real {ω | E ω} = ∑ ω ∈ Finset.univ.filter E, μ.real {ω} := by
    rw [Measure.real, hsum, ENNReal.toReal_sum (fun ω _ => measure_ne_top μ {ω})]
    rfl
  rw [hreal, AlignmentReals.FiniteLaw.prob, Finset.sum_filter]
  rfl

/-- Complement survival lower bound from `EntropyProduction.gain_probability_le`:
under `E[exp (-S)] = 1`, `1 - exp (-a) ≤ P(-S < a)`. -/
theorem fluctuation_complement_survival_ge {Ω : Type} [Fintype Ω] [MeasurableSpace Ω]
    [MeasurableSingletonClass Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {S : Ω → ℝ} (fluctuation : ∫ ω, Real.exp (-S ω) ∂μ = 1) (a : ℝ) :
    1 - Real.exp (-a) ≤ (finiteLawOfMeasure μ).prob (fun ω => -S ω < a) := by
  classical
  have hexp : Integrable (fun ω => Real.exp (-S ω)) μ := Integrable.of_finite
  have hgain := EntropyProduction.gain_probability_le hexp fluctuation a
  have hcomp := (finiteLawOfMeasure μ).prob_add_compl (fun ω => -S ω < a)
  have hset : {ω | ¬ (-S ω < a)} = {ω | S ω ≤ -a} := by
    ext ω
    simp only [Set.mem_setOf_eq, not_lt]
    constructor <;> intro h <;> linarith
  have hnot : (finiteLawOfMeasure μ).prob (fun ω => ¬ (-S ω < a)) = μ.real {ω | S ω ≤ -a} := by
    rw [finiteLawOfMeasure_prob_eq_real, hset]
  linarith

/-- **Theorem 2 (`finiteLawOfMeasure_exergy_fluctuation_survival`).**
On `{F C Ω : Type}` with `[Fintype Ω] [MeasurableSpace Ω] [MeasurableSingletonClass Ω]` and
`[IsProbabilityMeasure μ]`:
1. Pathwise balance (`(L ω).Balances (W ω)`) transfers to `Representation.expected_balance` on
   `((W ω).stock cs t : ℝ)`.
2. Exergy balance and expected destruction floor (`u * E[takers] ≤ E[D t]`) imply
   `EntropyProduction.ExpectedDissipatesOn`, hence `expected_takers_within`, and via
   `AlignmentReals.markov_survival_sufficient` on `finiteLawOfMeasure μ` yield the survival lower
   bound `1 - δ ≤ prob (X_takers ≤ B)` for `X_takers ω := ∑ i ∈ range N, ((L ω).takers cs (T + i) : ℝ)`.
3. Under the integral fluctuation theorem `E[exp (-S)] = 1`, `1 - exp (-a) ≤ prob (-S < a)`, and
   for any gain event with lower-bounded probability `p ≤ μ.real {ω | S ω ≤ -M}` and `B_gain < M`,
   `AlignmentReals.spike_threshold_survival_upper` bounds `prob (-S ≤ B_gain) ≤ 1 - p` while
   `EntropyProduction.gain_probability_le` forces `p ≤ exp (-M)`. -/
theorem finiteLawOfMeasure_exergy_fluctuation_survival {F C Ω : Type} [Fintype Ω]
    [MeasurableSpace Ω] [MeasurableSingletonClass Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (L : Ω → Becoming.Flow F C) (W : Ω → Becoming.Web F C) (cs : List C) (T : ℕ)
    {u : ℝ} (unit : 0 < u) (D : ℕ → Ω → ℝ)
    (balances : ∀ ω, (L ω).Balances (W ω))
    (exergy_bal : ∀ t, T ≤ t → ∀ ω,
      u * ((L ω).replenishment cs t : ℝ) + D t ω = u * ((L ω).uptake cs t : ℝ))
    (exergy_floor : ∀ t, T ≤ t → u * ∫ ω, ((L ω).takers cs t : ℝ) ∂μ ≤ ∫ ω, D t ω ∂μ)
    {S : Ω → ℝ} (fluctuation : ∫ ω, Real.exp (-S ω) ∂μ = 1) :
    (∀ t,
      ∫ ω, ((W ω).stock cs (t + 1) : ℝ) ∂μ + ∫ ω, ((L ω).uptake cs t : ℝ) ∂μ =
        ∫ ω, ((W ω).stock cs t : ℝ) ∂μ + ∫ ω, ((L ω).replenishment cs t : ℝ) ∂μ) ∧
    (∀ N : ℕ, ∀ B δ : ℝ, 0 < B → 0 < δ →
      (∫ ω, ((W ω).stock cs T : ℝ) ∂μ) / δ ≤ B →
      1 - δ ≤ (finiteLawOfMeasure μ).prob
        (fun ω => ∑ i ∈ Finset.range N, ((L ω).takers cs (T + i) : ℝ) ≤ B)) ∧
    (∀ a : ℝ, 1 - Real.exp (-a) ≤ (finiteLawOfMeasure μ).prob (fun ω => -S ω < a)) ∧
    (∀ B_gain M p : ℝ, B_gain < M → p ≤ μ.real {ω | S ω ≤ -M} →
      (finiteLawOfMeasure μ).prob (fun ω => -S ω ≤ B_gain) ≤ 1 - p ∧ p ≤ Real.exp (-M)) := by
  classical
  have hhas : ∀ t, EntropyProduction.HasExpectations μ L W cs t := fun t =>
    ⟨Integrable.of_finite, Integrable.of_finite, Integrable.of_finite, Integrable.of_finite⟩
  have hbal_exp : ∀ t,
      ∫ ω, ((W ω).stock cs (t + 1) : ℝ) ∂μ + ∫ ω, ((L ω).uptake cs t : ℝ) ∂μ =
        ∫ ω, ((W ω).stock cs t : ℝ) ∂μ + ∫ ω, ((L ω).replenishment cs t : ℝ) ∂μ := by
    intro t
    exact Representation.expected_balance μ
      (fun ω k => ((W ω).stock cs k : ℝ))
      (fun ω k => ((L ω).replenishment cs k : ℝ))
      (fun ω k => ((L ω).uptake cs k : ℝ))
      (fun ω k => by dsimp only; exact_mod_cast (balances ω).over cs k)
      t Integrable.of_finite Integrable.of_finite Integrable.of_finite Integrable.of_finite
  have hdiss : ∀ t, T ≤ t → EntropyProduction.ExpectedDissipatesOn μ L cs t := fun t ht =>
    EntropyProduction.ExpectedDissipatesOn.of_exergy unit (exergy_bal t ht) (exergy_floor t ht)
      Integrable.of_finite Integrable.of_finite
  refine ⟨hbal_exp, ?_, ?_, ?_⟩
  · intro n B δ hB hδ hbound
    let X : Ω → ℝ := fun ω => ∑ i ∈ Finset.range n, ((L ω).takers cs (T + i) : ℝ)
    have hX_nonneg : ∀ ω ∈ (Finset.univ : Finset Ω), 0 ≤ X ω := fun ω _ =>
      Finset.sum_nonneg fun i _ => Nat.cast_nonneg _
    have hX_expect : (finiteLawOfMeasure μ).expect X =
        ∑ i ∈ Finset.range n, ∫ ω, ((L ω).takers cs (T + i) : ℝ) ∂μ := by
      rw [finiteLawOfMeasure_expect_eq_integral]
      exact integral_finsetSum (Finset.range n) fun i _ => Integrable.of_finite
    have hwithin := EntropyProduction.expected_takers_within balances hhas hdiss n
    have hstock_nonneg : 0 ≤ ∫ ω, ((W ω).stock cs (T + n) : ℝ) ∂μ :=
      EntropyProduction.expected_stock_nonneg (T + n)
    have hexpect_le : (finiteLawOfMeasure μ).expect X ≤ ∫ ω, ((W ω).stock cs T : ℝ) ∂μ := by
      linarith
    have hmarkov_bound : (finiteLawOfMeasure μ).expect X / δ ≤ B :=
      le_trans (div_le_div_of_nonneg_right hexpect_le hδ.le) hbound
    exact AlignmentReals.markov_survival_sufficient (finiteLawOfMeasure μ) X hX_nonneg hB hδ
      hmarkov_bound
  · intro a
    exact fluctuation_complement_survival_ge μ fluctuation a
  · intro B_gain M p hBM hp
    have hp_prob : p ≤ (finiteLawOfMeasure μ).prob (fun ω => M ≤ -S ω) := by
      rw [finiteLawOfMeasure_prob_eq_real]
      have hset : {ω | M ≤ -S ω} = {ω | S ω ≤ -M} := by
        ext ω
        simp only [Set.mem_setOf_eq]
        constructor <;> intro h <;> linarith
      rwa [hset]
    have hupper := AlignmentReals.spike_threshold_survival_upper (finiteLawOfMeasure μ)
      (fun ω => -S ω) hBM hp_prob
    have hfluct := EntropyProduction.gain_probability_le
      (Integrable.of_finite : Integrable (fun ω => Real.exp (-S ω)) μ) fluctuation M
    exact ⟨hupper, le_trans hp hfluct⟩

end EntropyMarkovFluctuation

/-! ## Section 3: `FreeEnergyReals` ↔ `ExpectedFreeEnergyReals` ↔ `CellsUnderNoise` -/

section GibbsExchangeableSeeking

open Equiv

/-- Normalized Gibbs distribution `exp (-κ F c) / ∑ c', exp (-κ F c')` on configurations
`ι → S` (`{ι S : Type}`, nonempty finite state type `S`). -/
noncomputable def gibbsWeight {ι S : Type} [Fintype ι] [DecidableEq ι] [Fintype S]
    [DecidableEq S] [Nonempty S] (κ : ℝ) (F : (ι → S) → ℝ) (c : ι → S) : ℝ :=
  Real.exp (-κ * F c) / ∑ c' : ι → S, Real.exp (-κ * F c')

theorem gibbsWeight_eq_posterior {ι S : Type} [Fintype ι] [DecidableEq ι] [Fintype S]
    [DecidableEq S] [Nonempty S] (κ : ℝ) (F : (ι → S) → ℝ) (c : ι → S) :
    gibbsWeight κ F c =
      Becoming.FreeEnergy.posterior Finset.univ (fun c' => Real.exp (-κ * F c')) c :=
  rfl

theorem gibbsWeight_eq_softmax {ι S : Type} [Fintype ι] [DecidableEq ι] [Fintype S]
    [DecidableEq S] [Nonempty S] (κ : ℝ) (F : (ι → S) → ℝ) (c : ι → S) :
    gibbsWeight κ F c = Becoming.ExpectedFreeEnergy.softmax κ F c :=
  rfl

theorem gibbsWeight_pos {ι S : Type} [Fintype ι] [DecidableEq ι] [Fintype S]
    [DecidableEq S] [Nonempty S] (κ : ℝ) (F : (ι → S) → ℝ) (c : ι → S) :
    0 < gibbsWeight κ F c :=
  div_pos (Real.exp_pos _) (Finset.sum_pos (fun _ _ => Real.exp_pos _) Finset.univ_nonempty)

theorem gibbsWeight_sum_one {ι S : Type} [Fintype ι] [DecidableEq ι] [Fintype S]
    [DecidableEq S] [Nonempty S] (κ : ℝ) (F : (ι → S) → ℝ) :
    ∑ c : ι → S, gibbsWeight κ F c = 1 :=
  Becoming.ExpectedFreeEnergy.sum_softmax κ F

/-- **Theorem 3 (`gibbs_minimizes_freeEnergy_exchangeable`).**
Unites `FreeEnergyReals`, `ExpectedFreeEnergyReals`, and `CellsUnderNoise` on `{ι S : Type}`:
1. `gibbsWeight κ F` equals `FreeEnergy.posterior Finset.univ (fun c => Real.exp (-κ * F c))` and
   `ExpectedFreeEnergy.softmax κ F`.
2. It uniquely minimizes `FreeEnergy.freeEnergy Finset.univ q (fun c => Real.exp (-κ * F c))`
   over all distributions `q` (`0 ≤ q`, `∑ q = 1`), achieving
   `FreeEnergy.surprisal (∑ c, Real.exp (-κ * F c))`.
3. When `F` is invariant under cell permutations (`∀ σ c, F (c ∘ σ) = F c`), `gibbsWeight κ F`
   is `CellsUnderNoise.Exchangeable`, equalizes all cell marginals (`CellsUnderNoise.marginal_eq`),
   and bounds every injective configuration by `1 / (Fintype.card ι).factorial`
   (`CellsUnderNoise.distinct_le`).
4. For any coarse-matching priors `Q, Q'` over lumping `π`, `ExpectedFreeEnergy.seeking_blind_to_split`
   with `rule := ExpectedFreeEnergy.softmax κ` (equal to `gibbsWeight κ` over experiment space
   `ι → S`) yields identical choice distributions, `courseWeight`, and state-course weights. -/
theorem gibbs_minimizes_freeEnergy_exchangeable {ι S : Type} [Fintype ι] [DecidableEq ι]
    [Fintype S] [DecidableEq S] [Nonempty S] (κ : ℝ) (F : (ι → S) → ℝ)
    (symmetric : ∀ σ : Perm ι, ∀ c, F (c ∘ σ) = F c)
    {σ ω κ_cls : Type} [DecidableEq κ_cls]
    (S_st : Finset σ) (O : Finset ω) {Q Q' : σ → ℝ} (π : σ → κ_cls)
    (B : (ι → S) → κ_cls → ω → ℝ) (P : ω → ℝ)
    (alike : ∀ k, Becoming.ExpectedFreeEnergy.coarse S_st Q π k =
      Becoming.ExpectedFreeEnergy.coarse S_st Q' π k) :
    (gibbsWeight κ F =
        Becoming.FreeEnergy.posterior Finset.univ (fun c => Real.exp (-κ * F c)) ∧
      gibbsWeight κ F = Becoming.ExpectedFreeEnergy.softmax κ F) ∧
    (Becoming.FreeEnergy.freeEnergy Finset.univ (gibbsWeight κ F)
        (fun c => Real.exp (-κ * F c)) =
      Becoming.FreeEnergy.surprisal (∑ c : ι → S, Real.exp (-κ * F c))) ∧
    (∀ q : (ι → S) → ℝ, (∀ c, 0 ≤ q c) → ∑ c, q c = 1 →
      ((∀ q' : (ι → S) → ℝ, (∀ c, 0 ≤ q' c) → ∑ c, q' c = 1 →
          Becoming.FreeEnergy.freeEnergy Finset.univ q (fun c => Real.exp (-κ * F c)) ≤
            Becoming.FreeEnergy.freeEnergy Finset.univ q' (fun c => Real.exp (-κ * F c))) ↔
        ∀ c, q c = gibbsWeight κ F c)) ∧
    Becoming.CellsUnderNoise.Exchangeable (gibbsWeight κ F) ∧
    (∀ i j : ι, ∀ s : S,
      Becoming.CellsUnderNoise.marginal (gibbsWeight κ F) i s =
        Becoming.CellsUnderNoise.marginal (gibbsWeight κ F) j s) ∧
    (∀ c : ι → S, Function.Injective c →
      gibbsWeight κ F c ≤ 1 / (Fintype.card ι).factorial) ∧
    ((∀ c, Becoming.ExpectedFreeEnergy.efeChoice (Becoming.ExpectedFreeEnergy.softmax κ)
        S_st O Q (fun e s => B e (π s)) P c =
      Becoming.ExpectedFreeEnergy.efeChoice (Becoming.ExpectedFreeEnergy.softmax κ)
        S_st O Q' (fun e s => B e (π s)) P c) ∧
     (∀ c, Becoming.ExpectedFreeEnergy.courseWeight S_st Q (fun e s => B e (π s))
        (Becoming.ExpectedFreeEnergy.efeChoice (Becoming.ExpectedFreeEnergy.softmax κ)
          S_st O Q (fun e s => B e (π s)) P) c =
      Becoming.ExpectedFreeEnergy.courseWeight S_st Q' (fun e s => B e (π s))
        (Becoming.ExpectedFreeEnergy.efeChoice (Becoming.ExpectedFreeEnergy.softmax κ)
          S_st O Q' (fun e s => B e (π s)) P) c) ∧
     (∀ s c, Becoming.ExpectedFreeEnergy.choiceWeight
          (Becoming.ExpectedFreeEnergy.efeChoice (Becoming.ExpectedFreeEnergy.softmax κ)
            S_st O Q (fun e s => B e (π s)) P) c *
          Becoming.ExpectedFreeEnergy.courseLik (fun e s => B e (π s)) s c =
        Becoming.ExpectedFreeEnergy.choiceWeight
          (Becoming.ExpectedFreeEnergy.efeChoice (Becoming.ExpectedFreeEnergy.softmax κ)
            S_st O Q' (fun e s => B e (π s)) P) c *
          Becoming.ExpectedFreeEnergy.courseLik (fun e s => B e (π s)) s c)) := by
  have hsum_pos : 0 < ∑ c : ι → S, Real.exp (-κ * F c) :=
    Finset.sum_pos (fun _ _ => Real.exp_pos _) Finset.univ_nonempty
  have hfe_val : Becoming.FreeEnergy.freeEnergy Finset.univ (gibbsWeight κ F)
      (fun c => Real.exp (-κ * F c)) =
      Becoming.FreeEnergy.surprisal (∑ c : ι → S, Real.exp (-κ * F c)) := by
    rw [funext (gibbsWeight_eq_posterior κ F)]
    exact Becoming.FreeEnergy.freeEnergy_posterior Finset.univ (fun c => Real.exp (-κ * F c))
      (fun _ _ => (Real.exp_pos _).le) hsum_pos
  have hmin : ∀ q : (ι → S) → ℝ, (∀ c, 0 ≤ q c) → ∑ c, q c = 1 →
      ((∀ q' : (ι → S) → ℝ, (∀ c, 0 ≤ q' c) → ∑ c, q' c = 1 →
          Becoming.FreeEnergy.freeEnergy Finset.univ q (fun c => Real.exp (-κ * F c)) ≤
            Becoming.FreeEnergy.freeEnergy Finset.univ q' (fun c => Real.exp (-κ * F c))) ↔
        ∀ c, q c = gibbsWeight κ F c) := by
    intro q hq hq1
    have hiff := Becoming.FreeEnergy.minimizes_iff_posterior Finset.univ q
      (fun c => Real.exp (-κ * F c)) (fun c _ => hq c) hq1
      (fun c _ => (Real.exp_pos _).le) (fun c _ hzero => absurd hzero (Real.exp_ne_zero _))
    constructor
    · intro hleast c
      have hpost := hiff.mp (fun q' hq' hq1' _ => hleast q' (fun c' => hq' c' (Finset.mem_univ c')) hq1')
        c (Finset.mem_univ c)
      rw [hpost]
      rfl
    · intro hsame q' hq' hq1'
      exact hiff.mpr (fun c _ => (hsame c).trans (gibbsWeight_eq_posterior κ F c))
        q' (fun c _ => hq' c) hq1' (fun c _ hzero => absurd hzero (Real.exp_ne_zero _))
  have hexch : Becoming.CellsUnderNoise.Exchangeable (gibbsWeight κ F) :=
    Becoming.CellsUnderNoise.gibbs_exchangeable κ symmetric
  have hmarg : ∀ i j : ι, ∀ s : S,
      Becoming.CellsUnderNoise.marginal (gibbsWeight κ F) i s =
        Becoming.CellsUnderNoise.marginal (gibbsWeight κ F) j s :=
    fun i j s => Becoming.CellsUnderNoise.marginal_eq hexch i j s
  have hdist : ∀ c : ι → S, Function.Injective c →
      gibbsWeight κ F c ≤ 1 / (Fintype.card ι).factorial :=
    fun c hinj => Becoming.CellsUnderNoise.distinct_le hexch
      (fun c' => (gibbsWeight_pos κ F c').le) (gibbsWeight_sum_one κ F) hinj
  have hblind := Becoming.ExpectedFreeEnergy.seeking_blind_to_split S_st O π B P alike
    (Becoming.ExpectedFreeEnergy.softmax κ)
  exact ⟨⟨rfl, rfl⟩, hfe_val, hmin, hexch, hmarg, hdist, hblind⟩

end GibbsExchangeableSeeking

/-! ## Section 4: `LinearBlankets` ↔ `AlignmentReals` ↔ `Representation` ↔ `SlowingDown` -/

section LinearBlanketsAndRunaway

open Matrix

namespace LocalMatrixOpNorm

open scoped NNReal

@[instance_reducible]
noncomputable def linftyOpSeminormedAddCommGroup {m n α : Type*} [Fintype m] [Fintype n]
    [SeminormedAddCommGroup α] : SeminormedAddCommGroup (Matrix m n α) :=
  @Pi.seminormedAddCommGroup m _ _ (fun _ => PiLp.seminormedAddCommGroupToPi 1 (fun _ : n => α))

@[instance_reducible]
noncomputable def linftyOpNormedAddCommGroup {m n α : Type*} [Fintype m] [Fintype n]
    [NormedAddCommGroup α] : NormedAddCommGroup (Matrix m n α) :=
  @Pi.normedAddCommGroup m _ _ (fun _ => PiLp.normedAddCommGroupToPi 1 (fun _ : n => α))

section LocalLinftyDefs

attribute [local instance] linftyOpSeminormedAddCommGroup linftyOpNormedAddCommGroup

theorem linftyOp_norm_def {m n α : Type*} [Fintype m] [Fintype n] [SeminormedAddCommGroup α]
    (A : Matrix m n α) :
    ‖A‖ = ((Finset.univ : Finset m).sup fun i : m => ∑ j : n, ‖A i j‖₊ : ℝ≥0) := by
  change ‖fun i => WithLp.toLp 1 (A i)‖ = _
  simp [Pi.norm_def, PiLp.nnnorm_eq_of_L1]

theorem linftyOp_nnnorm_def {m n α : Type*} [Fintype m] [Fintype n] [SeminormedAddCommGroup α]
    (A : Matrix m n α) :
    ‖A‖₊ = (Finset.univ : Finset m).sup fun i : m => ∑ j : n, ‖A i j‖₊ :=
  Subtype.ext <| linftyOp_norm_def A

theorem linftyOp_nnnorm_mul {l m n α : Type*} [Fintype l] [Fintype m] [Fintype n]
    [NonUnitalSeminormedRing α] (A : Matrix l m α) (B : Matrix m n α) :
    ‖A * B‖₊ ≤ ‖A‖₊ * ‖B‖₊ := by
  simp_rw [linftyOp_nnnorm_def, Matrix.mul_apply]
  calc
    (Finset.univ.sup fun i => ∑ k, ‖∑ j, A i j * B j k‖₊) ≤
        Finset.univ.sup fun i => ∑ k, ∑ j, ‖A i j‖₊ * ‖B j k‖₊ :=
      Finset.sup_mono_fun fun i _ =>
        Finset.sum_le_sum fun k _ => nnnorm_sum_le_of_le _ fun j _ => nnnorm_mul_le _ _
    _ = Finset.univ.sup fun i => ∑ j, ‖A i j‖₊ * ∑ k, ‖B j k‖₊ := by
      simp_rw [@Finset.sum_comm m, Finset.mul_sum]
    _ ≤ Finset.univ.sup fun i => ∑ j, ‖A i j‖₊ * Finset.univ.sup fun i => ∑ j, ‖B i j‖₊ := by
      refine Finset.sup_mono_fun fun i _ => ?_
      gcongr with j hj
      exact Finset.le_sup (f := fun i => ∑ k : n, ‖B i k‖₊) hj
    _ ≤ (Finset.univ.sup fun i => ∑ j, ‖A i j‖₊) * Finset.univ.sup fun i => ∑ j, ‖B i j‖₊ := by
      simp_rw [← Finset.sum_mul, ← NNReal.finset_sup_mul]
      rfl

theorem linftyOp_norm_mul {l m n α : Type*} [Fintype l] [Fintype m] [Fintype n]
    [NonUnitalSeminormedRing α] (A : Matrix l m α) (B : Matrix m n α) :
    ‖A * B‖ ≤ ‖A‖ * ‖B‖ :=
  linftyOp_nnnorm_mul _ _

@[instance_reducible]
noncomputable def linftyOpNormedRing {n α : Type*} [Fintype n] [DecidableEq n]
    [NormedRing α] : NormedRing (Matrix n n α) :=
  { linftyOpNormedAddCommGroup, Matrix.instRing with
    norm_mul_le := linftyOp_norm_mul }

theorem linftyOp_nnnorm_diagonal {m α : Type*} [Fintype m] [DecidableEq m]
    [SeminormedAddCommGroup α] (v : m → α) : ‖diagonal v‖₊ = ‖v‖₊ := by
  rw [linftyOp_nnnorm_def, Pi.nnnorm_def]
  congr 1 with i : 1
  refine (Finset.sum_eq_single_of_mem _ (Finset.mem_univ i) fun j _ hij => ?_).trans ?_
  · rw [diagonal_apply_ne' _ hij, nnnorm_zero]
  · rw [diagonal_apply_eq]

theorem linftyOp_norm_diagonal {m α : Type*} [Fintype m] [DecidableEq m]
    [SeminormedAddCommGroup α] (v : m → α) : ‖diagonal v‖ = ‖v‖ :=
  congr_arg ((↑) : ℝ≥0 → ℝ) <| linftyOp_nnnorm_diagonal v

end LocalLinftyDefs

attribute [scoped instance] linftyOpSeminormedAddCommGroup linftyOpNormedAddCommGroup linftyOpNormedRing

scoped instance linftyOpNormOneClass {n α : Type*} [Fintype n] [DecidableEq n] [Nonempty n]
    [SeminormedRing α] [NormOneClass α] : NormOneClass (Matrix n n α) where
  norm_one := (linftyOp_norm_diagonal _).trans norm_one

end LocalMatrixOpNorm

open scoped LocalMatrixOpNorm

theorem euler_eq_mulVec {n : Type} [Fintype n] [DecidableEq n]
    (B : Matrix n n ℝ) (h : ℝ) (x : n → ℝ) :
    Becoming.LinearBlankets.euler B h x = (1 - h • B) *ᵥ x := by
  simp only [Becoming.LinearBlankets.euler, sub_mulVec, one_mulVec, smul_mulVec]

theorem euler_iterate_eq_pow_mulVec {n : Type} [Fintype n] [DecidableEq n]
    (B : Matrix n n ℝ) (h : ℝ) (x : n → ℝ) :
    ∀ t : ℕ, (Becoming.LinearBlankets.euler B h)^[t] x = ((1 - h • B) ^ t) *ᵥ x
  | 0 => by simp [one_mulVec]
  | t + 1 => by
    rw [Function.iterate_succ_apply', euler_eq_mulVec, euler_iterate_eq_pow_mulVec B h x t,
      mulVec_mulVec, pow_succ']

theorem euler_unit_iterate_eq_drawnMultiplier (h r q : ℝ) (x : Unit → ℝ) :
    ∀ t : ℕ, (Becoming.LinearBlankets.euler (fun (_ _ : Unit) => r - q) h)^[t] x () =
      (Becoming.SlowingDown.drawnMultiplier h r q) ^ t * x ()
  | 0 => by simp
  | t + 1 => by
    rw [Function.iterate_succ_apply']
    have ih := euler_unit_iterate_eq_drawnMultiplier h r q x t
    simp only [Becoming.LinearBlankets.euler, Pi.sub_apply, Pi.smul_apply, smul_eq_mul, mulVec,
      dotProduct, Fintype.sum_unique, ih, Becoming.SlowingDown.drawnMultiplier, pow_succ']
    ring

theorem emA_sq_eq :
    Becoming.LinearBlankets.Autonomous.emA ^ 2 =
      !![3 / 4, 29 / 100, 13 / 100, -3 / 100;
        -9 / 20, 31 / 100, -3 / 20, 3 / 100;
        3 / 100, -3 / 20, 31 / 100, -9 / 20;
        -3 / 100, 13 / 100, 29 / 100, 3 / 4] := by
  rw [sq]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Becoming.LinearBlankets.Autonomous.emA, Becoming.LinearBlankets.Autonomous.B,
      Matrix.mul_apply, Fin.sum_univ_four] <;> norm_num

theorem emA_pow_four_eq :
    Becoming.LinearBlankets.Autonomous.emA ^ 4 =
      !![273 / 625, 71 / 250, 107 / 1250, -237 / 2500;
        -603 / 1250, -1 / 125, -357 / 2500, 141 / 1250;
        141 / 1250, -357 / 2500, -1 / 125, -603 / 1250;
        -237 / 2500, 107 / 1250, 71 / 250, 273 / 625] := by
  have hsplit : Becoming.LinearBlankets.Autonomous.emA ^ 4 =
      Becoming.LinearBlankets.Autonomous.emA ^ 2 * Becoming.LinearBlankets.Autonomous.emA ^ 2 := by
    change Becoming.LinearBlankets.Autonomous.emA ^ (2 + 2) = _
    exact pow_add Becoming.LinearBlankets.Autonomous.emA 2 2
  rw [hsplit, emA_sq_eq]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four] <;> norm_num

theorem emA_pow_four_norm_lt_one :
    ‖Becoming.LinearBlankets.Autonomous.emA ^ 4‖ < 1 := by
  rw [← coe_nnnorm, NNReal.coe_lt_one, LocalMatrixOpNorm.linftyOp_nnnorm_def,
    Finset.sup_lt_iff (by norm_num : (0 : NNReal) < 1)]
  intro i _
  rw [← NNReal.coe_lt_one, NNReal.coe_sum]
  simp only [coe_nnnorm, Real.norm_eq_abs]
  fin_cases i <;> simp [emA_pow_four_eq, Fin.sum_univ_four] <;> norm_num

theorem emA_rate_lt_one :
    Becoming.Representation.rate Becoming.LinearBlankets.Autonomous.emA < 1 := by
  have hr : Becoming.Representation.rate Becoming.LinearBlankets.Autonomous.emA ≤
      ‖Becoming.LinearBlankets.Autonomous.emA ^ 4‖ ^ ((1 : ℝ) / 4) := by
    have h3 := Becoming.Representation.rate_le Becoming.LinearBlankets.Autonomous.emA 3
    norm_num at h3
    exact h3
  have hpow : ‖Becoming.LinearBlankets.Autonomous.emA ^ 4‖ ^ ((1 : ℝ) / 4) < 1 :=
    Real.rpow_lt_one (norm_nonneg _) emA_pow_four_norm_lt_one (by norm_num)
  exact lt_of_le_of_lt hr hpow

/-- **Theorem 4 (`linear_blanket_vs_fa_leakage_and_damped_runaway`).**
Joins `LinearBlankets`, `AlignmentReals`, `Representation`, and `SlowingDown` under operator norm:
1. Any Euler iterate `(euler B h)^[t] x` equals `((1 - h • B) ^ t) *ᵥ x`, with `vanishes_iff`
   and `unbounded_of_one_lt` governing `1 - h • B` via `Representation.rate`.
2. In 1D (`n = Unit`, `B = fun _ _ => r - q`), `(euler B h)^[t] x ()` equals
   `(SlowingDown.drawnMultiplier h r q) ^ t * x ()`.
3. For `LinearBlankets.Autonomous.emA = 1 - (1 / 10) • B`, `‖emA ^ 4‖ < 1` so
   `Representation.rate emA < 1` and `‖emA ^ t‖ → 0`, yet `em_loses_internal_external` holds
   (`emM 3 0 = -27800 / 984581 ≠ 0` while `P 3 0 = 0`, contrasting `precision_zero_of_footnote13`
   and `mode_unread_iff`).
4. Alongside, `AlignmentReals.linear_fa_tabular_invariant` preserves warning boundary under
   orthogonal features while `AlignmentReals.linear_fa_leakage_hysteresis` forces finite-time
   breach below `x_crit` under feature leakage. -/
theorem linear_blanket_vs_fa_leakage_and_damped_runaway
    {n : Type} [Fintype n] [DecidableEq n] [Nonempty n]
    (B : Matrix n n ℝ) (h : ℝ) (x : n → ℝ)
    (h_1d r_1d q_1d : ℝ) (x_1d : Unit → ℝ)
    {m_int k_bl l_ext : Type*} [Fintype m_int] [Fintype k_bl] [Fintype l_ext]
    [DecidableEq m_int] [DecidableEq l_ext]
    (Pmm : Matrix m_int m_int ℝ) (Pmk : Matrix m_int k_bl ℝ) (Pml : Matrix m_int l_ext ℝ)
    (hPmm : IsUnit Pmm.det)
    {d_fa : ℕ} (φ_safe φ_warn : Fin d_fa → ℝ)
    (η p_max v_rest d_agg d_rest R_fa x_warn x_crit : ℝ)
    (hη : 0 ≤ η) (hp_nonneg : 0 ≤ p_max) (δ_fa p_fa : ℕ → ℝ) (hp_fa : ∀ k, p_fa k ≤ p_max)
    (θ₀ : Fin d_fa → ℝ) (T_safe M_delay : ℕ) (hM : 0 < M_delay) :
    (∀ t, (Becoming.LinearBlankets.euler B h)^[t] x = ((1 - h • B) ^ t) *ᵥ x) ∧
    (Filter.Tendsto (fun t => ‖(1 - h • B) ^ t‖) Filter.atTop (nhds 0) ↔
      Becoming.Representation.rate (1 - h • B) < 1) ∧
    (1 < Becoming.Representation.rate (1 - h • B) → ∀ K : ℝ, ∃ t, K < ‖(1 - h • B) ^ t‖) ∧
    (∀ t, (Becoming.LinearBlankets.euler (fun (_ _ : Unit) => r_1d - q_1d) h_1d)^[t] x_1d () =
      (Becoming.SlowingDown.drawnMultiplier h_1d r_1d q_1d) ^ t * x_1d ()) ∧
    ‖Becoming.LinearBlankets.Autonomous.emA ^ 4‖ < 1 ∧
    Becoming.Representation.rate Becoming.LinearBlankets.Autonomous.emA < 1 ∧
    Filter.Tendsto (fun t => ‖Becoming.LinearBlankets.Autonomous.emA ^ t‖) Filter.atTop (nhds 0) ∧
    (Becoming.LinearBlankets.Autonomous.emM 3 0 = -27800 / 984581 ∧
      Becoming.LinearBlankets.Autonomous.P 3 0 = 0) ∧
    ((∀ b η_ext η_ext',
        Becoming.LinearBlankets.mode Pmm Pmk Pml b η_ext =
          Becoming.LinearBlankets.mode Pmm Pmk Pml b η_ext') ↔ Pml = 0) ∧
    (∀ (B_a Q_a P_a : Matrix n n ℝ) (part_a : n → Becoming.LinearBlankets.Part) (d_a : n → ℝ),
      (∀ i, 0 < d_a i) → Q_aᵀ = -Q_a → B_a = (diagonal d_a - Q_a) * P_a →
      Becoming.LinearBlankets.SparseCoupling part_a B_a →
      (∀ i k, (part_a i = .internal ∨ part_a i = .active) →
        ¬ (part_a k = .internal ∨ part_a k = .active) → Q_a i k = 0) →
      ∀ {i j : n}, (part_a i = .internal ∨ part_a i = .active) → part_a j = .external →
      P_a i j = 0) ∧
    ((φ_safe ⬝ᵥ φ_warn = 0 → θ₀ ⬝ᵥ φ_warn ≤ v_rest →
      (AlignmentReals.faSafeUpdate φ_safe η δ_fa θ₀ T_safe) ⬝ᵥ φ_warn ≤ v_rest) ∧
     (v_rest < θ₀ ⬝ᵥ φ_warn + η * (φ_safe ⬝ᵥ φ_warn) * (∑ k ∈ Finset.range T_safe, δ_fa k) -
        ((M_delay - 1 : ℕ) : ℝ) * (η * p_max * (φ_warn ⬝ᵥ φ_warn)) →
      let θ_enter := AlignmentReals.faSafeUpdate φ_safe η δ_fa θ₀ T_safe
      (∀ m, m < M_delay → v_rest < (AlignmentReals.faWarnUpdate φ_warn η p_fa θ_enter m) ⬝ᵥ φ_warn) ∧
      (∀ m, m ≤ M_delay →
        AlignmentReals.warnStock d_agg d_rest R_fa φ_warn v_rest η p_fa θ_enter x_warn m =
          x_warn - (m : ℝ) * (d_agg - R_fa)) ∧
      (x_warn - x_crit < (d_agg - R_fa) * (M_delay : ℝ) →
        AlignmentReals.warnStock d_agg d_rest R_fa φ_warn v_rest η p_fa θ_enter x_warn M_delay <
          x_crit))) := by
  have hlin := AlignmentReals.linear_fa_leakage_hysteresis φ_safe φ_warn η p_max v_rest d_agg d_rest
    R_fa x_warn x_crit hη hp_nonneg δ_fa p_fa hp_fa θ₀ T_safe M_delay hM
  refine ⟨euler_iterate_eq_pow_mulVec B h x,
    Becoming.Representation.vanishes_iff (1 - h • B),
    fun hgt K => Becoming.Representation.unbounded_of_one_lt hgt K,
    euler_unit_iterate_eq_drawnMultiplier h_1d r_1d q_1d x_1d,
    emA_pow_four_norm_lt_one,
    emA_rate_lt_one,
    (Becoming.Representation.vanishes_iff Becoming.LinearBlankets.Autonomous.emA).mpr emA_rate_lt_one,
    Becoming.LinearBlankets.Autonomous.em_loses_internal_external,
    Becoming.LinearBlankets.mode_unread_iff Pmm Pmk Pml hPmm,
    ?_,
    hlin⟩
  intro B_a Q_a P_a part_a d_a dpos anti helm sparse noQ i j hi hj
  exact Becoming.LinearBlankets.precision_zero_of_footnote13 (part := part_a) d_a dpos anti helm
    sparse noQ hi hj

end LinearBlanketsAndRunaway

/-! ## Section 5: Concrete Cross-Module Numerical Witness -/

section CrossModuleWitness

open scoped LocalMatrixOpNorm

/-- Symmetric energy on two binary cells `Becoming.CellsUnderNoise.Witness.Two := Fin 2 → Bool`. -/
noncomputable def twoCellSymEnergy (c : Becoming.CellsUnderNoise.Witness.Two) : ℝ :=
  if c 0 ≠ c 1 then 1 else 0

theorem twoCellSymEnergy_symm (σ : Equiv.Perm (Fin 2))
    (c : Becoming.CellsUnderNoise.Witness.Two) :
    twoCellSymEnergy (c ∘ σ) = twoCellSymEnergy c := by
  simp only [twoCellSymEnergy, Function.comp_apply,
    Becoming.CellsUnderNoise.Witness.parted_rearranged]

theorem twoCellParted_injective : Function.Injective (![false, true] : Fin 2 → Bool) := by
  intro i j hij
  fin_cases i <;> fin_cases j <;> simp_all

/-- **Theorem 5 (`becoming_reals_cross_module_witness`).**
Concrete verified witness spanning all 9 Mathlib periphery modules:
- `SlowingDown`: `(h = 1/10, r = 10, K = 20, q = 6, s = 1)` gives `drawnRest = 8`,
  `drawnMultiplier = 3/5`, and `stationaryVariance (3/5) 1 = 25/16`.
- `AlignmentReals`: `inertia_witness_phase2`, `stochastic_delay_witness_phase2`, and
  `linear_fa_witness_rho_4_5`.
- `RegimeReals`: `Becoming.RegimeMargin.Drawn.Relaxation.never_rests`.
- `LinearBlankets`: `Becoming.LinearBlankets.Autonomous.em_loses_internal_external` alongside
  `emA_rate_lt_one`.
- `EntropyProduction`: `Becoming.EntropyProduction.Fluctuation.gains_in_one_run`.
- `Representation`: `Becoming.Representation.shear_rate`.
- `CellsUnderNoise` + `FreeEnergyReals` + `ExpectedFreeEnergyReals`: 2-cell binary Gibbs
  distribution on `Becoming.CellsUnderNoise.Witness.Two` (`![false, true]` injective,
  `gibbsWeight 1 twoCellSymEnergy ![false, true] ≤ 1/2`, unique free-energy minimizer via
  `FreeEnergy.minimizes_iff_posterior`, `gibbsWeight_eq_softmax`) and
  `Becoming.ExpectedFreeEnergy.Witness.split_unseen`. -/
theorem becoming_reals_cross_module_witness :
    (Becoming.SlowingDown.drawnRest 10 20 6 = 8 ∧
      Becoming.SlowingDown.drawnMultiplier (1 / 10) 10 6 = 3 / 5 ∧
      Becoming.SlowingDown.stationaryVariance (3 / 5) 1 = 25 / 16) ∧
    (Becoming.Pace.StretchFixes Bool 3 5 ∧
      (∀ t, 6 ≤ t → 3 ≤ (AlignmentReals.p2Course t).1.2.2 ∧
        (AlignmentReals.p2Course t).1.2.2 ≤ 60 ∧
        Becoming.LineOnAStock.Goes AlignmentReals.p2Need (AlignmentReals.p2Course t).1.2) ∧
      ((AlignmentReals.p2Course 5).1.2.2 = 12 ∧ (AlignmentReals.p2Course 6).1.2.2 = 9 ∧
        ∀ t, 6 ≤ t → (AlignmentReals.p2Course t).1.2.2 = 9) ∧
      (∀ t, 12 ≤ AlignmentReals.inertiaStock 4 1 1 5 1 27 t) ∧
      (AlignmentReals.inertiaStock 4 1 1 5 (1 / 8) 27 10 = 58035 / 32768 ∧
        AlignmentReals.inertiaStock 4 1 1 5 (1 / 8) 27 10 < 3 ∧
        AlignmentReals.inertiaStock 4 1 1 5 (1 / 8) 27 12 < 0 ∧
        AlignmentReals.inertiaStock 4 1 1 5 (1 / 8) 27 21 < 0) ∧
      (∀ t, 3 ≤ AlignmentReals.inertiaStock 4 1 1 5 (1 / 8) 39 t)) ∧
    ((AlignmentReals.delayLaw3 (1 / 2) (1 / 4) (1 / 4) (by norm_num) (by norm_num) (by norm_num)
        (by norm_num)).expect (fun i => ((![0, 5, 10] i : ℕ) : ℝ) * 3) = 45 / 4 ∧
      (AlignmentReals.delayLaw3 (1 / 2) (1 / 4) (1 / 4) (by norm_num) (by norm_num) (by norm_num)
        (by norm_num)).prob (fun i => ((![0, 5, 10] i : ℕ) : ℝ) * 3 ≤ (27 - 3 : ℝ)) = 3 / 4 ∧
      ∃ k ≤ 10, (Becoming.Law.run (Becoming.RegimeMargin.step AlignmentReals.p2Giving 4) 27).state k < 3) ∧
    (∀ t, (AlignmentReals.faSafeSeq t) ⬝ᵥ ![0, 1] = 0) ∧
    (¬ Becoming.Viability.Kernel
      (Becoming.AdaptiveLoops.jointProcess [()]
        (fun _ => AlignmentReals.faOpenLoop ![1, 0] ![4 / 5, 3 / 5] (3 / 5) (3 / 20) (1 / 40))
        (fun _ => AlignmentReals.faCertCoupled AlignmentReals.faThetaEnter
          (by rw [AlignmentReals.faThetaEnter_coords.1]; norm_num)
          (by rw [AlignmentReals.faThetaEnter_coords.2]))
        AlignmentReals.faObs AlignmentReals.faChannel AlignmentReals.faG (fun _ _ => 0) (fun _ => True))
      (Becoming.AdaptiveLoops.jointGuard [()]
        (fun _ => AlignmentReals.faOpenLoop ![1, 0] ![4 / 5, 3 / 5] (3 / 5) (3 / 20) (1 / 40))
        (fun _ => AlignmentReals.faCertCoupled AlignmentReals.faThetaEnter
          (by rw [AlignmentReals.faThetaEnter_coords.1]; norm_num)
          (by rw [AlignmentReals.faThetaEnter_coords.2]))
        (fun _ => 5))
      (fun _ => 22, fun _ => AlignmentReals.faThetaEnter)) ∧
    (Becoming.RegimeMargin.Drawn.reals.Rises Becoming.RegimeMargin.Drawn.Relaxation.giving ∧
      Becoming.RegimeMargin.Drawn.reals.Band Becoming.RegimeMargin.Drawn.Relaxation.giving 1 1 ∧
      (∃ L, Filter.Tendsto (fun n => (Becoming.Law.run
          (Becoming.RegimeMargin.Drawn.reals.step Becoming.RegimeMargin.Drawn.Relaxation.giving 1)
          (0, 0)).state n) Filter.atTop (nhds L)) ∧
      ∀ T, ¬ Becoming.LastChange.StillFrom (Becoming.Law.run
          (Becoming.RegimeMargin.Drawn.reals.step Becoming.RegimeMargin.Drawn.Relaxation.giving 1)
          (0, 0)) T) ∧
    (Becoming.LinearBlankets.Autonomous.emM 3 0 = -27800 / 984581 ∧
      Becoming.LinearBlankets.Autonomous.P 3 0 = 0 ∧
      Becoming.Representation.rate Becoming.LinearBlankets.Autonomous.emA < 1) ∧
    ((∀ t, Becoming.EntropyProduction.ExpectedDissipatesOn Becoming.EntropyProduction.Fluctuation.coin
        Becoming.EntropyProduction.Fluctuation.flow [()] t) ∧
      ¬ (Becoming.EntropyProduction.Fluctuation.flow true).GainlessOn [()] 0 ∧
      ¬ (Becoming.EntropyProduction.Fluctuation.flow true).Dissipative) ∧
    (Becoming.Representation.rate Becoming.Representation.shear = 1 ∧
      ∀ K : ℝ, ∃ n, K < ‖Becoming.Representation.shear ^ n‖) ∧
    (gibbsWeight 1 twoCellSymEnergy ![false, true] ≤ 1 / 2 ∧
      gibbsWeight 1 twoCellSymEnergy = Becoming.ExpectedFreeEnergy.softmax 1 twoCellSymEnergy ∧
      ((∀ q' : Becoming.CellsUnderNoise.Witness.Two → ℝ, (∀ c, 0 ≤ q' c) → ∑ c, q' c = 1 →
        (∀ c, Real.exp (-1 * twoCellSymEnergy c) = 0 → q' c = 0) →
        Becoming.FreeEnergy.freeEnergy Finset.univ (gibbsWeight 1 twoCellSymEnergy)
            (fun c => Real.exp (-1 * twoCellSymEnergy c)) ≤
          Becoming.FreeEnergy.freeEnergy Finset.univ q'
            (fun c => Real.exp (-1 * twoCellSymEnergy c))) ↔
        ∀ c, gibbsWeight 1 twoCellSymEnergy c =
          Becoming.FreeEnergy.posterior Finset.univ
            (fun c => Real.exp (-1 * twoCellSymEnergy c)) c)) ∧
    (Becoming.ExpectedFreeEnergy.coursePosterior Becoming.LumpedSeeking.Agree.hypotheses.toFinset
        (fun h => (Becoming.LumpedSeeking.Agree.prior h : ℝ))
        Becoming.ExpectedFreeEnergy.Witness.agreeOrNothing
        [(true, (true, true))] Becoming.LumpedSeeking.Agree.Bias.heads ≠
      Becoming.ExpectedFreeEnergy.coursePosterior Becoming.LumpedSeeking.Agree.hypotheses.toFinset
        (fun h => (Becoming.ExpectedFreeEnergy.Witness.swappedPrior h : ℝ))
        Becoming.ExpectedFreeEnergy.Witness.agreeOrNothing
        [(true, (true, true))] Becoming.LumpedSeeking.Agree.Bias.heads) := by
  have hsd : Becoming.SlowingDown.drawnRest 10 20 6 = 8 ∧
      Becoming.SlowingDown.drawnMultiplier (1 / 10) 10 6 = 3 / 5 ∧
      Becoming.SlowingDown.stationaryVariance (3 / 5) 1 = 25 / 16 := by
    refine ⟨?_, ?_, ?_⟩
    · unfold Becoming.SlowingDown.drawnRest; norm_num
    · unfold Becoming.SlowingDown.drawnMultiplier; norm_num
    · unfold Becoming.SlowingDown.stationaryVariance; norm_num
  have hi := AlignmentReals.inertia_witness_phase2
  have hd := AlignmentReals.stochastic_delay_witness_phase2
  have hfa := AlignmentReals.linear_fa_witness_rho_4_5
  have hr := Becoming.RegimeMargin.Drawn.Relaxation.never_rests
  have hlb := Becoming.LinearBlankets.Autonomous.em_loses_internal_external
  have hep := Becoming.EntropyProduction.Fluctuation.gains_in_one_run
  have hrep := Becoming.Representation.shear_rate
  have hexch : Becoming.CellsUnderNoise.Exchangeable (gibbsWeight 1 twoCellSymEnergy) :=
    Becoming.CellsUnderNoise.gibbs_exchangeable 1 twoCellSymEnergy_symm
  have hdist : gibbsWeight 1 twoCellSymEnergy ![false, true] ≤ 1 / 2 := by
    have h := Becoming.CellsUnderNoise.distinct_le hexch
      (fun c => (gibbsWeight_pos 1 twoCellSymEnergy c).le)
      (gibbsWeight_sum_one 1 twoCellSymEnergy) twoCellParted_injective
    simpa using h
  have hmin : (∀ q' : Becoming.CellsUnderNoise.Witness.Two → ℝ, (∀ c, 0 ≤ q' c) → ∑ c, q' c = 1 →
      (∀ c, Real.exp (-1 * twoCellSymEnergy c) = 0 → q' c = 0) →
      Becoming.FreeEnergy.freeEnergy Finset.univ (gibbsWeight 1 twoCellSymEnergy)
          (fun c => Real.exp (-1 * twoCellSymEnergy c)) ≤
        Becoming.FreeEnergy.freeEnergy Finset.univ q'
          (fun c => Real.exp (-1 * twoCellSymEnergy c))) ↔
      ∀ c, gibbsWeight 1 twoCellSymEnergy c =
        Becoming.FreeEnergy.posterior Finset.univ
          (fun c => Real.exp (-1 * twoCellSymEnergy c)) c := by
    have hm := Becoming.FreeEnergy.minimizes_iff_posterior Finset.univ
      (gibbsWeight 1 twoCellSymEnergy) (fun c => Real.exp (-1 * twoCellSymEnergy c))
      (fun c _ => (gibbsWeight_pos 1 twoCellSymEnergy c).le)
      (gibbsWeight_sum_one 1 twoCellSymEnergy)
      (fun c _ => (Real.exp_pos _).le)
      (fun c _ hz => absurd hz (Real.exp_ne_zero _))
    simpa using hm
  have hefe := Becoming.ExpectedFreeEnergy.Witness.split_unseen
  exact ⟨hsd, hi, ⟨hd.2.1.1, hd.2.1.2, hd.2.2⟩, hfa.1, hfa.2.2.2.1, hr,
    ⟨hlb.1, hlb.2, emA_rate_lt_one⟩, ⟨hep.1, hep.2.2.2.1, hep.2.2.2.2⟩, hrep,
    ⟨hdist, rfl, hmin⟩, hefe.1⟩

end CrossModuleWitness

end Becoming.Reals
