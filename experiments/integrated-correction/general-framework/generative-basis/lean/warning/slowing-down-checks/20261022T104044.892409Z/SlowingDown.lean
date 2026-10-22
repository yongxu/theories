import Mathlib.Probability.Moments.Variance
import Mathlib.Probability.Independence.Basic
import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.Analysis.Calculus.Deriv.Pow
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Topology.Algebra.Order.Field

/-!
# Slowing down before a condition's own end

Thesis T6 has two halves. Its unseen half is the core's `Web.break_not_bounded`: where a stock a
formation requires couples into it by threshold only, nothing it couples into bounds how far off
its break is. This module proves the seen half in the model statistical early warnings are read
in, over the reals, with Mathlib: where the drawn condition is itself observed, the margin to an
end of its own renewal couples into its fluctuations, and is read from them.

* **One step about a rest** (`variance_step`, `covariance_step`). The deviation from a rest, one
  step on, is the return multiplier `a` times the deviation now plus noise independent of it. Its
  variance is `a² Var Y + Var E`, and its covariance with the deviation now is `a Var Y`.
* **Stationary statistics are the multiplier's** (`stationary_variance`, `stationary_lag1`). Where
  the variance stays the same across the step and `a² < 1`, it is `Var E / (1 − a²)`, and the
  lag-1 autocorrelation is `a` itself.
* **Both rise without bound as the multiplier rises to one** (`stationaryVariance_tendsto`,
  `stationaryVariance_strictMonoOn`): the variance tends to infinity and rises strictly with the
  multiplier on `[0, 1)`; the autocorrelation tends to one.
* **At a fold** (`foldStep`: the step `x + h (m − x²)`, its rest `√m`) the multiplier is
  `1 − 2 h √m` (`foldStep_hasDerivAt`); it tends to one as the margin `m` to the fold goes to
  zero (`foldMultiplier_tendsto`), so the variance rises strictly as the margin shrinks
  (`fold_variance_strictAntiOn`) and tends to infinity (`fold_variance_tendsto`), and
  the margin is read back exactly from the autocorrelation, `m = ((1 − a) / (2 h))²`
  (`fold_margin_read`).
* **At a transcritical end** (`drawnStep`: logistic renewal `r x (1 − x / K)` under a
  proportional draw `q x`, rest `K (1 − q / r)`) the multiplier is `1 − h (r − q)`
  (`drawnStep_hasDerivAt`), which is `1 − h r x* / K`: the stock slows in proportion to its own
  level (`drawn_multiplier_level`), and the level is read back from the autocorrelation
  (`drawn_level_read`). As the draw rises to the renewal rate the multiplier tends to one
  (`drawnMultiplier_tendsto`), and the variance rises strictly with the draw
  (`drawn_variance_strictMonoOn`) and tends to infinity (`drawn_variance_tendsto`).
* **A dependent's need is not read** (`need_not_read`, `need_margin_read`). The multiplier and the
  noise are all the stationary statistics depend on, and a dependent's need enters neither. So no
  reading of the margin to a dependent's need from the multiplier is right for every need; and
  with the need measured, the margin is read exactly. This half holds by construction: the need
  enters nothing the stock's law depends on. Its content in the world is the premise that the
  dependent's feedback onto the stock is negligible, which the field tests measure apart.

Discrete steps, the deviation read in the linearization about a rest (the step's derivative at the
rest, `HasDerivAt`), noise independent of the deviation with finite variance, and stationarity
supplied are the representation's commitments. The declarations here use Lean's standard axioms
through Mathlib. No ethical premise occurs.
-/

open MeasureTheory ProbabilityTheory Filter Topology Set

namespace Becoming.SlowingDown

/-! ## One step about a rest -/

section Step

variable {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}

/-- **One step of a deviation about a rest:** the return multiplier `a` times the deviation now,
plus noise. -/
def step (a : ℝ) (Y E : Ω → ℝ) : Ω → ℝ := fun ω => a * Y ω + E ω

theorem memLp_step (a : ℝ) {Y E : Ω → ℝ} (hY : MemLp Y 2 μ) (hE : MemLp E 2 μ) :
    MemLp (step a Y E) 2 μ :=
  (hY.const_mul a).add hE

/-- **The variance one step on** is `a² Var Y + Var E`, the noise independent of the deviation. -/
theorem variance_step (a : ℝ) {Y E : Ω → ℝ} (hY : MemLp Y 2 μ) (hE : MemLp E 2 μ)
    (h : Y ⟂ᵢ[μ] E) : Var[step a Y E; μ] = a ^ 2 * Var[Y; μ] + Var[E; μ] := by
  have h' : (fun ω => a * Y ω) ⟂ᵢ[μ] E :=
    h.comp (φ := fun x => a * x) (ψ := id) (measurable_const_mul a) measurable_id
  unfold step
  rw [h'.variance_fun_add (hY.const_mul a) hE, variance_const_mul]

/-- **The covariance across the step** is `a Var Y`. -/
theorem covariance_step [IsFiniteMeasure μ] (a : ℝ) {Y E : Ω → ℝ} (hY : MemLp Y 2 μ)
    (hE : MemLp E 2 μ) (h : Y ⟂ᵢ[μ] E) : cov[Y, step a Y E; μ] = a * Var[Y; μ] := by
  have hsum : step a Y E = (fun ω => a * Y ω) + E := rfl
  rw [hsum, covariance_add_right hY (hY.const_mul a) hE, covariance_const_mul_right,
    covariance_self hY.aemeasurable, h.covariance_eq_zero hY hE, add_zero]

/-- **The stationary variance** of a deviation with multiplier `a` and noise variance `s`. -/
noncomputable def stationaryVariance (a s : ℝ) : ℝ := s / (1 - a ^ 2)

/-- **Stationary, the variance is the multiplier's**: where the variance stays the same across the
step and `a² < 1`, it is `Var E / (1 − a²)`. -/
theorem stationary_variance (a : ℝ) {Y E : Ω → ℝ} (hY : MemLp Y 2 μ) (hE : MemLp E 2 μ)
    (h : Y ⟂ᵢ[μ] E) (ha : a ^ 2 < 1) (hs : Var[step a Y E; μ] = Var[Y; μ]) :
    Var[Y; μ] = stationaryVariance a Var[E; μ] := by
  rw [variance_step a hY hE h] at hs
  have hpos : (0 : ℝ) < 1 - a ^ 2 := by linarith
  unfold stationaryVariance
  rw [eq_div_iff hpos.ne']
  linarith

/-- **The lag-1 autocorrelation** of a deviation and the deviation one step on. -/
noncomputable def lag1 (Y Y' : Ω → ℝ) (μ : Measure Ω) : ℝ :=
  cov[Y, Y'; μ] / (Real.sqrt Var[Y; μ] * Real.sqrt Var[Y'; μ])

/-- **Stationary, the lag-1 autocorrelation is the multiplier**: where the variance stays the same
across the step and is positive, the autocorrelation is `a`. -/
theorem stationary_lag1 [IsFiniteMeasure μ] (a : ℝ) {Y E : Ω → ℝ} (hY : MemLp Y 2 μ)
    (hE : MemLp E 2 μ) (h : Y ⟂ᵢ[μ] E) (hs : Var[step a Y E; μ] = Var[Y; μ])
    (hv : 0 < Var[Y; μ]) : lag1 Y (step a Y E) μ = a := by
  unfold lag1
  rw [covariance_step a hY hE h, hs, Real.mul_self_sqrt hv.le, mul_div_assoc,
    div_self hv.ne', mul_one]

end Step

/-! ## Rising to one -/

/-- **The stationary variance tends to infinity as the multiplier rises to one.** -/
theorem stationaryVariance_tendsto {s : ℝ} (hs : 0 < s) :
    Tendsto (fun a => stationaryVariance a s) (𝓝[<] 1) atTop := by
  have hg : Tendsto (fun a : ℝ => 1 - a ^ 2) (𝓝[<] 1) (𝓝[>] 0) := by
    apply tendsto_nhdsWithin_of_tendsto_nhds_of_eventually_within
    · have hc : Continuous (fun a : ℝ => 1 - a ^ 2) := by fun_prop
      have := hc.tendsto 1
      simpa using this.mono_left nhdsWithin_le_nhds
    · have hmem : Ioo (0 : ℝ) 1 ∈ 𝓝[<] (1 : ℝ) := Ioo_mem_nhdsLT (by norm_num)
      filter_upwards [hmem] with a ha
      have : a ^ 2 < 1 := by nlinarith [ha.1, ha.2]
      simp only [mem_Ioi]
      linarith
  have := (tendsto_inv_nhdsGT_zero.comp hg).const_mul_atTop hs
  refine this.congr (fun a => ?_)
  simp [stationaryVariance, div_eq_mul_inv]

/-- **The stationary variance rises strictly with the multiplier on `[0, 1)`.** -/
theorem stationaryVariance_strictMonoOn {s : ℝ} (hs : 0 < s) :
    StrictMonoOn (fun a => stationaryVariance a s) (Ico 0 1) := by
  intro a ha b hb hab
  simp only [stationaryVariance]
  have hb2 : b ^ 2 < 1 := by nlinarith [hb.1, hb.2]
  have hab2 : a ^ 2 < b ^ 2 := by nlinarith [ha.1]
  apply div_lt_div_of_pos_left hs (by linarith) (by linarith)

/-! ## At a fold -/

/-- **A step near a fold**: `x + h (m − x²)`, with step length `h` and margin `m` to the fold. -/
def foldStep (h m x : ℝ) : ℝ := x + h * (m - x ^ 2)

/-- `√m` is a rest of the fold step for `m ≥ 0`. -/
theorem foldStep_rest (h : ℝ) {m : ℝ} (hm : 0 ≤ m) : foldStep h m (Real.sqrt m) = Real.sqrt m := by
  simp [foldStep, Real.sq_sqrt hm]

/-- **The multiplier at the fold's rest.** -/
noncomputable def foldMultiplier (h m : ℝ) : ℝ := 1 - 2 * h * Real.sqrt m

/-- **The fold step's derivative at the rest is its multiplier.** -/
theorem foldStep_hasDerivAt (h m : ℝ) :
    HasDerivAt (foldStep h m) (foldMultiplier h m) (Real.sqrt m) := by
  have h1 : HasDerivAt (fun x : ℝ => x ^ 2) (2 * Real.sqrt m) (Real.sqrt m) := by
    simpa using hasDerivAt_pow 2 (Real.sqrt m)
  have := (hasDerivAt_id (Real.sqrt m)).add (HasDerivAt.const_mul h (HasDerivAt.const_sub m h1))
  unfold foldStep foldMultiplier
  convert this using 1
  ring

/-- **The multiplier rises to one as the margin to the fold goes to zero.** -/
theorem foldMultiplier_tendsto {h : ℝ} (hh : 0 < h) :
    Tendsto (foldMultiplier h) (𝓝[>] 0) (𝓝[<] 1) := by
  apply tendsto_nhdsWithin_of_tendsto_nhds_of_eventually_within
  · have hc : Continuous (foldMultiplier h) := by unfold foldMultiplier; fun_prop
    have := hc.tendsto 0
    simpa [foldMultiplier] using this.mono_left nhdsWithin_le_nhds
  · filter_upwards [self_mem_nhdsWithin] with m hm
    have : 0 < Real.sqrt m := Real.sqrt_pos.mpr hm
    simp only [mem_Iio, foldMultiplier]
    nlinarith

/-- **Before a fold the variance tends to infinity.** -/
theorem fold_variance_tendsto {h s : ℝ} (hh : 0 < h) (hs : 0 < s) :
    Tendsto (fun m => stationaryVariance (foldMultiplier h m) s) (𝓝[>] 0) atTop :=
  (stationaryVariance_tendsto hs).comp (foldMultiplier_tendsto hh)

/-- **Before a fold the variance rises as the margin shrinks**: strictly, wherever the multiplier
lies in `[0, 1)`, that is for margins in `(0, (2 h)⁻²]`. -/
theorem fold_variance_strictAntiOn {h s : ℝ} (hh : 0 < h) (hs : 0 < s) :
    StrictAntiOn (fun m => stationaryVariance (foldMultiplier h m) s) (Ioc 0 ((2 * h)⁻¹ ^ 2)) := by
  intro m₁ h₁ m₂ h₂ hlt
  have mem : ∀ m ∈ Ioc (0 : ℝ) ((2 * h)⁻¹ ^ 2), foldMultiplier h m ∈ Ico (0 : ℝ) 1 := by
    intro m hm
    have hs0 : 0 < Real.sqrt m := Real.sqrt_pos.mpr hm.1
    have hs1 : Real.sqrt m ≤ (2 * h)⁻¹ := by
      calc Real.sqrt m ≤ Real.sqrt ((2 * h)⁻¹ ^ 2) := Real.sqrt_le_sqrt hm.2
        _ = (2 * h)⁻¹ := Real.sqrt_sq (by positivity)
    have hle : 2 * h * Real.sqrt m ≤ 1 := by
      calc 2 * h * Real.sqrt m ≤ 2 * h * (2 * h)⁻¹ := by gcongr
        _ = 1 := by field_simp
    simp only [foldMultiplier, mem_Ico]
    constructor <;> nlinarith
  apply stationaryVariance_strictMonoOn hs (mem m₂ h₂) (mem m₁ h₁)
  have : Real.sqrt m₁ < Real.sqrt m₂ := Real.sqrt_lt_sqrt h₁.1.le hlt
  simp only [foldMultiplier]
  nlinarith

/-- **The margin to the fold is read from the autocorrelation**: `m = ((1 − a) / (2 h))²`. -/
theorem fold_margin_read {h m : ℝ} (hh : 0 < h) (hm : 0 ≤ m) :
    m = ((1 - foldMultiplier h m) / (2 * h)) ^ 2 := by
  have : (1 - foldMultiplier h m) / (2 * h) = Real.sqrt m := by
    unfold foldMultiplier
    field_simp
    ring
  rw [this, Real.sq_sqrt hm]

/-! ## At a transcritical end -/

/-- **A drawn renewal**: logistic renewal at rate `r` with capacity `K`, under a proportional draw
`q`, one step of length `h`. -/
noncomputable def drawnStep (h r K q x : ℝ) : ℝ := x + h * (r * x * (1 - x / K) - q * x)

/-- **The drawn rest** `K (1 − q / r)`. -/
noncomputable def drawnRest (r K q : ℝ) : ℝ := K * (1 - q / r)

theorem drawnStep_rest (h : ℝ) {r K : ℝ} (q : ℝ) (hr : r ≠ 0) (hK : K ≠ 0) :
    drawnStep h r K q (drawnRest r K q) = drawnRest r K q := by
  unfold drawnStep drawnRest
  field_simp
  ring

/-- **The multiplier at the drawn rest**: `1 − h (r − q)`. -/
noncomputable def drawnMultiplier (h r q : ℝ) : ℝ := 1 - h * (r - q)

/-- **The drawn step's derivative at the rest is its multiplier.** -/
theorem drawnStep_hasDerivAt (h : ℝ) {r K : ℝ} (q : ℝ) (hr : r ≠ 0) (hK : K ≠ 0) :
    HasDerivAt (drawnStep h r K q) (drawnMultiplier h r q) (drawnRest r K q) := by
  set x := drawnRest r K q
  have hpoly : drawnStep h r K q = fun y => y + h * ((r - q) * y - (r / K) * y ^ 2) := by
    funext y; unfold drawnStep; field_simp; ring
  have h1 : HasDerivAt (fun y : ℝ => y ^ 2) (2 * x) x := by simpa using hasDerivAt_pow 2 x
  have := (hasDerivAt_id x).add (HasDerivAt.const_mul h
    (HasDerivAt.sub (HasDerivAt.const_mul (r - q) (hasDerivAt_id x))
      (HasDerivAt.const_mul (r / K) h1)))
  rw [hpoly]
  convert this using 1
  simp only [x, drawnRest, drawnMultiplier]
  field_simp
  ring

/-- **The drawn stock slows in proportion to its own level**: the multiplier is
`1 − h r x* / K`. -/
theorem drawn_multiplier_level (h : ℝ) {r K : ℝ} (q : ℝ) (hr : r ≠ 0) (hK : K ≠ 0) :
    drawnMultiplier h r q = 1 - h * r * drawnRest r K q / K := by
  unfold drawnMultiplier drawnRest
  field_simp

/-- **The level is read from the autocorrelation**: `x* = K (1 − a) / (h r)`. -/
theorem drawn_level_read {h r K : ℝ} (q : ℝ) (hh : h ≠ 0) (hr : r ≠ 0) (hK : K ≠ 0) :
    drawnRest r K q = K * (1 - drawnMultiplier h r q) / (h * r) := by
  unfold drawnMultiplier drawnRest
  field_simp
  ring

/-- **The multiplier rises to one as the draw rises to the renewal rate.** -/
theorem drawnMultiplier_tendsto {h : ℝ} (hh : 0 < h) (r : ℝ) :
    Tendsto (drawnMultiplier h r) (𝓝[<] r) (𝓝[<] 1) := by
  apply tendsto_nhdsWithin_of_tendsto_nhds_of_eventually_within
  · have hc : Continuous (drawnMultiplier h r) := by unfold drawnMultiplier; fun_prop
    have := hc.tendsto r
    simpa [drawnMultiplier] using this.mono_left nhdsWithin_le_nhds
  · filter_upwards [self_mem_nhdsWithin] with q hq
    simp only [mem_Iio, drawnMultiplier] at hq ⊢
    nlinarith

/-- **Before a transcritical end the variance tends to infinity.** -/
theorem drawn_variance_tendsto {h s : ℝ} (hh : 0 < h) (hs : 0 < s) (r : ℝ) :
    Tendsto (fun q => stationaryVariance (drawnMultiplier h r q) s) (𝓝[<] r) atTop :=
  (stationaryVariance_tendsto hs).comp (drawnMultiplier_tendsto hh r)

/-- **As the draw rises toward the renewal rate the variance rises**: strictly, wherever the
multiplier lies in `[0, 1)`, that is for draws in `[r − h⁻¹, r)`. -/
theorem drawn_variance_strictMonoOn {h s : ℝ} (hh : 0 < h) (hs : 0 < s) (r : ℝ) :
    StrictMonoOn (fun q => stationaryVariance (drawnMultiplier h r q) s) (Ico (r - h⁻¹) r) := by
  intro q₁ h₁ q₂ h₂ hlt
  have e : h * h⁻¹ = 1 := by field_simp
  have mem : ∀ q ∈ Ico (r - h⁻¹) r, drawnMultiplier h r q ∈ Ico (0 : ℝ) 1 := by
    intro q hq
    have hle := mul_le_mul_of_nonneg_left (show r - q ≤ h⁻¹ by linarith [hq.1]) hh.le
    have hpos := mul_pos hh (show 0 < r - q by linarith [hq.2])
    simp only [drawnMultiplier, mem_Ico]
    constructor <;> linarith
  apply stationaryVariance_strictMonoOn hs (mem q₁ h₁) (mem q₂ h₂)
  simp only [drawnMultiplier]
  nlinarith

/-! ## A dependent's need is not read -/

/-- **No reading of the margin to a dependent's need from the multiplier is right for every
need.** Whatever the level `x` and multiplier `a`, every reading `R` of the margin `x − n` from
`a` is wrong for some need `n`; the need enters nothing the stock's statistics depend on. -/
theorem need_not_read (x a : ℝ) (R : ℝ → ℝ) : ∃ n : ℝ, R a ≠ x - n :=
  ⟨x - R a - 1, by linarith⟩

/-- **With the need measured, the margin to it is read exactly** from the autocorrelation:
`x* − n = K (1 − a) / (h r) − n`. -/
theorem need_margin_read {h r K : ℝ} (q n : ℝ) (hh : h ≠ 0) (hr : r ≠ 0) (hK : K ≠ 0) :
    drawnRest r K q - n = K * (1 - drawnMultiplier h r q) / (h * r) - n := by
  rw [drawn_level_read q hh hr hK]

end Becoming.SlowingDown
