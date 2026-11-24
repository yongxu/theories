# Paper Attack: Quantitative Transfer for the four `B4` failure regimes (`QuantitativeTransfer`)

*AI-written (f3-mathlib-builder, 24 November 2026), before any Lean of this package was written. No human has reviewed it. Every sentence below is either a statement planned for proof (marked **Lean**), or a reading of the stress lab (marked **recognition**, Rule 2), with what would count against it.*

**What this advances (Rule 6).** A join and a claim put to a test that could fail. `RESULTS.md` §4.2 lists four regimes where `full_guarded` still breaks. The Lean periphery has the pieces (`ObservationalFidelity.fiber_split_readout_floor`, `AlignmentReals.MetricLaxSim`, `metric_laxSim_contraction_tube`, `linear_fa_leakage_hysteresis`) but no statement that says, per regime, which part is a limit no runtime change removes and which part a runtime change can remove. `B5` (`B5-PREDICTIONS.md`, `@f3-stresslab-builder`) asks the lab the same question. This package says it over `ℝ`, with each limit paired with the sharpness witness or remedy that shows the limit is exactly where it is stated.

**Package.** `lean/quantitative-transfer/QuantitativeTransfer.lean`, Lean `v4.30.0-rc2`, Mathlib `ea11ccc0…`, `import ObservationalFidelity` (which brings `AlignmentReals`, `BecomingReals`, `Becoming.OplaxHistory`; their compiled steps are already in the shared step cache, so the import is reused, not rebuilt) plus the Mathlib calculus files needed for §3. Standard axioms only, `0` `sorryAx`, `0` `private`/`lemma`/`class`/unnamed `instance`, `0` market words. Checker mirrors `check_survival_distinguishability.py` exactly.

---

## 1. `FAIL_correlated_pool_drift`: the shared component no pool size averages away

**Model.** Courses `x : X`; `M ≥ 1` judges `i : Fin M`; shared channel `c : X → ℝ` (the self-labelled pseudo-target every judge is refit toward); per-judge residuals `u i : X → ℝ` in `[0, 1]`; shared drift `γ ∈ [0, 1]`. Judge score `s i x = γ * c x + (1 - γ) * u i x`; pool mean `s̄ x = (1/M) ∑ i, s i x`. The score matrix is a rank-1 term `γ · 1 cᵀ` plus a residual scaled by `1 - γ`.

**Lean (planned).**
1. `pool_disagreement_ceiling`: for every `M`, `i k`, `x`: `|s i x - s k x| ≤ 1 - γ` and `|s i x - s̄ x| ≤ 1 - γ`. For `c x = c y` (courses the shared channel conflates): `|s̄ x - s̄ y| ≤ 1 - γ`. No hypothesis on `M` beyond `0 < M`.
2. `pool_shared_bias_floor`: for truth `t : X → ℝ` in `[0, 1]` and every `M ≥ 1`: `γ * |c x - t x| - (1 - γ) ≤ |s̄ x - t x|`; attained with equality `|s̄ x - t x| = γ * |c x - t x|` when every residual is truthful (`u i = t`), for every `M`. So the pool's error from the shared channel is not reduced by adding judges.
3. `pool_ceiling_attained` (sharpness): for `M ≥ 2` there are residuals in `[0, 1]` with `|s 0 x - s 1 x| = 1 - γ`.
4. `anchor_detects_shared_drift` (remedy): an anchor channel `a` outside the drift, with `|a x - t x| ≤ εₐ`, satisfies `γ * |c x - t x| - (1 - γ) - εₐ ≤ |a x - s̄ x|`.
5. `correlated_pool_blindness_vs_anchor` (the pair): for any veto threshold `τ ≥ 1 - γ`, the internal disagreement veto (`∃ i k, τ < |s i x - s k x|`) never fires, whatever `|c x - t x|` is and whatever `M` is; the anchor veto (`τ < |a x - s̄ x|`) fires whenever `τ + (1 - γ) + εₐ < γ * |c x - t x|`.
6. Witness at the lab's numbers: `γ = 24/25`, `τ = 7/50`, `M = 3`, `εₐ = 0`: internal veto silent for every course; anchor veto fires for every course with `|c x - t x| > 3/16`.

**Not claimed.** Nothing probabilistic: the residuals are bounded, not independent draws, so no `1/√M` statement is made or needed. The ceiling is a statement about the score model, not about how `ReinforcePolicy` judges are trained.

**Recognition and what counts against it.** The lab's drift (`96%` of pool updates toward one shared pseudo-label) is read as `γ ≈ 0.96`. `B5` P6 (`M9 ≥ M3 − 0.20`) and P7/P8 (anchor helps, aliased anchor does not) test the reading. If `M9` collapse falls well below `M3`, the lab's judges keep more independent residual than `1 - γ`, i.e. the lab is not in this model's premises; the theorem stands, its application fails, and that is recorded.

## 2. `FAIL_severe_aliasing`: the readout floor inside `2ε`

**Model (matches `substrates.py` `interventional_probe` term for term).** Fine states `u : U`, macro readout `f : U → O`, true probe `p : U → ℝ`, macro alias `m : O → ℝ`, aliasing `α ∈ [0, 1]`: `pα u = (1 - α) * p u + α * m (f u)`. An observation of `u` is any `y` with `|y - pα u| ≤ ε` (bounded noise).

**Lean (planned).**
1. `aliased_fiber_gap`: `f u₁ = f u₂ → |pα u₁ - pα u₂| = (1 - α) * |p u₁ - p u₂|`.
2. `aliased_readout_floor` (limit): if `(1 - α) * |p u₁ - p u₂| ≤ 2ε` then (a) no rule `g : ℝ → Bool` answers `false` on every admissible observation of `u₁` and `true` on every admissible observation of `u₂`; (b) any real predictor `b : ℝ → ℝ` of viability `h` with `h u₁ = 0`, `h u₂ = 1`, `|h u - b y| ≤ γ` on admissible pairs has `1/2 ≤ γ`. Part (b) is **derived** from `ObservationalFidelity.fiber_split_readout_floor`, instantiated on the subtype of admissible pairs `{(u, y) // |y - pα u| ≤ ε}` with readout `Prod.snd`: the aliased floor is a case of the existing floor, not a new one.
3. `aliased_readout_separates` (sharpness): if `2ε < (1 - α) * |p u₁ - p u₂|`, the midpoint threshold rule separates every admissible observation of `u₁` from every admissible observation of `u₂`. So the floor is exactly at `α* = 1 - 2ε / |p u₁ - p u₂|`.
4. `mixture_aliasing_test_floor` (stochastic version over `ObservationalFidelity.FinDist`): with observation laws `(1 - α) • K u + α • N (f u)` on a finite observation type, `tvDist` of two same-fiber laws equals `(1 - α) * tvDist (K u₁) (K u₂)`, and every test `g : Y → Bool` has error sum `P₁(g) + P₂(¬g) ≥ 1 - (1 - α) * tvDist (K u₁) (K u₂) ≥ α` (two-point Le Cam bound, proved here from `tvDist`). Attained by the support test when `K u₁`, `K u₂` have disjoint supports.
5. Witness: `|p u₁ - p u₂| = 6/5` (the lab's measured gap `1.195`), `α = 19/20` gives separation `3/50`, blind for every `ε ≥ 3/100`; `α = 1/20` gives `57/50`, separable for every `ε < 57/100`.

**Not claimed.** The lab's noise is Gaussian, unbounded: there `TV < 1` and a rule keeps some advantage. Items 2–3 are the worst-case (bounded-noise) wall; item 4 is the stochastic floor for mixture aliasing on finite observation types. The Gaussian-additive floor `1 - TV(N(μ₁, s²), N(μ₂, s²))` is not proved (it needs measure-theoretic laws; left open).

**Recognition.** `B5` P10 predicts no guard-gain variant rescues `alias = 0.95`. If one does, the lab leaves usable information inside its noise (consistent with item 4 not being tight for Gaussian noise), not a refutation.

## 3. `FAIL_long_lag`: the lag-horizon wall, with switching lag `M(ρ, η)`

**Model (continuous time).** Reserve `x : ℝ → ℝ`, continuous on `[0, T]`, differentiable inside, net drawdown `deriv x ≤ -H₁` (`H₁ > 0`) for as long as no correction acts. Correction cannot act before the observation lag `L` plus the policy's switching lag `M`. Switching lag from leakage (continuous analogue of `AlignmentReals.linear_fa_leakage_hysteresis`): warning score enters at `s_enter = s₀ + η ρ S` (safe-phase leakage `ρ = φ_safe ⬝ φ_warn`, accumulated safe signal `S`) and falls at rate at most `η p n²`; `M(ρ, η) = (s₀ + η ρ S - v_rest) / (η p n²)`.

**Lean (planned).**
1. `drawdown_le_of_deriv_le`: `x t ≤ x 0 - H₁ * t` on `[0, T]` (via `monotoneOn_of_deriv_nonneg` on `x t + H₁ t`).
2. `lag_horizon_wall` (limit): if `x crit ≤ x 0` and `(x 0 - x_crit) / H₁ < L`, then there is `t* ∈ [0, (x 0 - x_crit)/H₁]`, `t* < L`, with `x t* = x_crit` (intermediate value theorem), and `x L < x_crit`. Holds for every controller whose correction starts no earlier than `L`: the premise is only about `x` on `[0, L]`.
3. `lag_horizon_wall_sharp`: for `L ≤ (x₀ - x_crit)/H₁` the trajectory `x₀ - H₁ t` stays `≥ x_crit` on `[0, L]`. The wall is exactly `x₀ = x_crit + H₁ L`.
4. `switching_score_persists`: score with `deriv s ≥ -η p n²` stays `> v_rest` for `t < M(ρ, η)`.
5. `switchLag_strictMono_rho`, `switchLag_nonpos_tabular`: `M` strictly increasing in `ρ` (for `η, S, p, n² > 0`); `ρ = 0` with `s₀ ≤ v_rest` gives `M ≤ 0` (no switching lag, the orthogonal case of Theorem 4).
6. `leakage_lag_wall`: if `x 0 < x_crit + H₁ * (L + M(ρ, η))` and drawdown persists until `L + M`, the reserve reaches `x_crit` before the policy has switched; the threshold `x_crit + H₁ (L + M(ρ, η))` is strictly increasing in `ρ`.
7. Witness at `B1`'s numbers (`x_crit = 3`, `H₁ = 4`, `L = 5`): `x₀ = 27` tolerates `L + M ≤ 6`; `x₀ = 39` (`+12`) tolerates `L + M ≤ 9`, i.e. `M ≤ 4`.

**Not claimed.** Item 2 is a sufficient condition for crossing (drawdown at full rate during the whole lag). The lab's learners draw down at varying rates, so the wall predicts *which* runs must cross, not the collapse rate.

**Recognition.** `B1` `reinforce_mlp` at `x₀ = 39` records switch delays `13–20` steps, above the `M ≤ 4` that `+12` buys; partial collapse (`0.40–0.45`) is consistent with partial-rate drawdown. A run with `x₀ < x_crit + H₁(L + M)` and drawdown rate `≥ H₁` throughout that does *not* cross would mean the mapping of the lab's variables onto `(x, H₁, L, M)` is wrong (the theorem cannot fail). `B5` P9 tests that guard gains cannot rescue `lag = 8`.

## 4. `FAIL_high_lr`: the trust-region tube (remedy) and the unprojected overshoot (limit of the old guard)

**Model.** Logits in a real normed space `E`. Guard map `T : E → E`, `α`-Lipschitz (`0 ≤ α < 1`) with fixed point `c` (the guarded centre: soft guard biases plus damping). Fine step: `z ↦ T z + proj_Δ (lr • g)` for any gradient proposal `g` and any `lr`; `proj_Δ v = v` if `‖v‖ ≤ Δ_max`, else `(Δ_max / ‖v‖) • v`. Coarse reference: `q ↦ T q`. Unprojected step: `z ↦ T z + lr • g`.

**Lean (planned).**
1. `norm_trustProj_le`, `trustProj_of_norm_le`: `‖proj_Δ v‖ ≤ Δ_max`; small steps unchanged.
2. `trustRegionMetricLaxSim`: an instance of `AlignmentReals.MetricLaxSim` (fine trust-region process, coarse `T`, `π = id`, `σ = id`, `(α, β, ε, η) = (α, 1, Δ_max, 0)`).
3. `trust_region_tube` (derived via `MetricLaxSim.advance_blocks` and `metricSlack_eq`): every `n`-step run, for every gradient sequence and every `lr`: `dist z_n (T^[n] q₀) ≤ α^n d₀ + Δ_max (1 - α^n)/(1 - α) ≤ α^n d₀ + Δ_max/(1 - α)`.
4. `trust_region_viability` (derived via `metric_laxSim_contraction_tube`): with the coarse certificate `{c}` (closed since `T c = c`), `Viability.Kernel` of the trust-region process for the guard band `dist z c ≤ B` holds whenever `dist z₀ c ≤ d₀` and `max d₀ (Δ_max/(1 - α)) ≤ B`.
5. `unprojected_step_overshoots` (limit of the old guard, for nontrivial `E`): for every `B`, every `lr > 0`, every `α`-Lipschitz `T` with `T c = c`, some gradient proposal leaves the band in one step from `c`: `¬ Viability.Kernel` of the unprojected process. No bounded guard band holds against unbounded steps.
6. `trust_region_tube_attained` (sharpness) on `ℝ`, `T z = α z`, `z₀ = q₀ = 0`, constant proposal `g = Δ_max / lr`: `z_n = Δ_max (1 - α^n)/(1 - α)` exactly, so the tube radius cannot be lowered.

**Not claimed.** That the lab's runtime is an `α`-Lipschitz guard map. The theorem says: if the guard pulls back by `α` per step and steps are projected to `Δ_max ≤ (1 - α) B`, the band holds for every gradient sequence.

**Recognition.** `B5` Test 1 (`tr`, `Δ_max = 1.0`, P1/P3/P5) tests whether projection remedies `FAIL_high_lr`. If `tr` alone does not help while `mask` does, the lab's failure is not mainly step size past a contracting guard (premise mismatch), recorded as such.

---

## 5. Anti-vacuity gates (for `@f3-critic`)

- **G1** Every limit is paired with a sharpness or remedy theorem at the same threshold (`1 - γ` / anchor; `2ε` / midpoint rule; `(x₀ - x_crit)/H₁` / linear trajectory; unprojected overshoot / trust-region tube + attained tube).
- **G2** Every hypothesis set is shown satisfiable by a closed witness at the lab's numbers (§1.6, §2.5, §3.7, §4.6).
- **G3** No conclusion is a restatement of a hypothesis: §2.2(b) and §4.3–4.4 are derived from existing theorems (`fiber_split_readout_floor`, `advance_blocks`, `metric_laxSim_contraction_tube`), the joins this package exists for.
- **G4** `M` in §1 is quantified universally; `lr` and gradients in §4 universally; controllers in §3 enter only through the premise on `[0, L]`.
- **G5** The checker records `#print axioms` and `#check` for every declaration; receipts as for periphery #14.
