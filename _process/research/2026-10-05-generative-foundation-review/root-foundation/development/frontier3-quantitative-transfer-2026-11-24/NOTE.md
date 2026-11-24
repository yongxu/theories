# Frontier 3 — `QuantitativeTransfer`: landing note, manifest entry #15 draft, schema-2 record draft

*AI-written (f3-mathlib-builder, 24 November 2026). No human has reviewed it. Drafts only: `periphery-manifest.json`, `Becoming.lean`, `BECOMING-WORKBOARD.md` and `theories/becoming/results/records/` are **not** edited here; the coordinator lands them.*

**What this advances (Rule 6).** A join (four `B4` failure regimes read onto `ObservationalFidelity` and `AlignmentReals`) and a claim put to a test that could fail (`B5`, `@f3-stresslab-builder`). Pre-Lean plan: [`PAPER-ATTACK.md`](PAPER-ATTACK.md) (`@f3-critic` PASS, board #14).

## 1. What was checked

`python3 -B experiments/integrated-correction/general-framework/generative-basis/lean/quantitative-transfer/check_quantitative_transfer.py`

- `status: passed`; receipt `quantitative-transfer-checks/20261124T154706.011836Z`; `59` declarations audited, `45` theorems.
- Axioms: `[Classical.choice, Quot.sound, propext]` only; `0` `sorryAx`; `0` `private`, `0` unnamed instances, `0` `lemma`/`class`; `0` market words in declaration names.
- Imports `ObservationalFidelity` (206 inherited modules, all matched to passed receipts and reused from the step cache; `4` Lean steps run). Source sha256 `8dc6d2bc…02ac`.

## 2. What the Lean says (each sentence is a theorem, premises stated)

1. **Correlated pool.** For scores `s i x = γ c x + (1 - γ) u i x`, `γ ≤ 1`, residuals in `[0, 1]`: every pairwise disagreement and every deviation from the pool mean is `≤ 1 - γ`, for every pool size (`pool_disagreement_ceiling`); the pool mean misses a truth `t ∈ [0, 1]` by `≥ γ |c - t| - (1 - γ)` for every `M ≥ 1`, with equality `γ |c - t|` when residuals are truthful (`pool_shared_bias_floor`); `1 - γ` is attained for `M ≥ 2` (`pool_ceiling_attained`); an anchor with `|a - t| ≤ εₐ` departs from the mean and from each judge by `≥ γ |c - t| - (1 - γ) - εₐ` (`anchor_detects_shared_drift`); hence with `τ ≥ 1 - γ` the internal veto never fires while the anchor veto fires once `τ + (1 - γ) + εₐ < γ |c - t|` (`correlated_pool_blindness_vs_anchor`); witness at `γ = 24/25`, `τ = 7/50`, `M = 3`, threshold `|c - t| > 3/16`, with a concrete course where the judges agree exactly and the anchor sees `24/25` (`correlated_pool_lab_witness`).
2. **Aliased probe.** For `pα u = (1 - α) p u + α m (f u)` and same-fiber `u₁, u₂`: the gap is exactly `(1 - α) |p u₁ - p u₂|` (`aliased_fiber_gap`); some rule separates all `ε`-admissible observations iff `2ε < (1 - α) |p u₁ - p u₂|` (`aliased_separable_iff`, from `noisy_readout_floor` + `noisy_readout_separates`); inside the wall every real predictor of a viability split errs by `≥ 1/2`, obtained by applying `ObservationalFidelity.fiber_split_readout_floor` to admissible (state, observation) pairs (`aliased_readout_floor`); witness gap `6/5`: `α = 19/20` blind for `ε ≥ 3/100`, `α = 1/20` separable for `ε < 57/100` (`aliased_lab_witness`). Finite mixture laws `(1 - α) K u + α N (f u)`: `tvDist` of same-fiber laws is `(1 - α) tvDist (K u₁) (K u₂)` and every test's error sum is `≥ 1 - (1 - α) tvDist ≥ α` (`two_point_test_floor`, `mixture_aliasing_test_floor`), attained on `Bool` (`mixture_floor_attained`).
3. **Lag horizon.** Continuous on `[0, L]`, differentiable inside, `deriv x ≤ -H₁`, `H₁ > 0`, `x_crit ≤ x 0`, `(x 0 - x_crit)/H₁ < L` ⟹ `x t* = x_crit` for some `t* ≤ (x 0 - x_crit)/H₁ < L`, and `x L < x_crit` (`lag_horizon_wall`); for the linear trajectory crossing within `[0, L]` holds iff `(x₀ - x_crit)/H₁ < L` (`lag_wall_iff_linear`, premises met by `linear_trajectory_premises`). A score entering at `s₀ + η ρ S` and falling at rate `≤ η p n2` stays above `v_rest` before `switchLag` (`switching_score_persists`); `switchLag` is strictly increasing in `ρ` and `≤ 0` at `ρ = 0`, `s₀ ≤ v_rest` (`switchLag_strictMono_rho`, `switchLag_nonpos_tabular`); `leakage_lag_wall` combines them; at `x_crit = 3`, `H₁ = 4`, `L = 5`: from `27` crossing iff `M > 1`, from `39` iff `M > 4` (`b1_headroom_witness`).
4. **Trust region.** For `T` `α`-Lipschitz (`0 ≤ α < 1`), `0 ≤ Δ`: `z ↦ T z + trustProj Δ (lr • g)` is an `AlignmentReals.MetricLaxSim` of `T` with `(α, 1, Δ, 0)` for every `lr` (`trustRegionMetricLaxSim`); every run of length `n` stays within `α^n d₀ + Δ (1 - α^n)/(1 - α)` of `T^[n] q₀` (`trust_region_tube`, via `MetricLaxSim.advance_blocks`), attained on `ℝ` (`trust_region_tube_attained`); with `T c = c` and `max d₀ (Δ/(1 - α)) ≤ B`, `Viability.Kernel` holds for the band `dist z c ≤ B` (`trust_region_viability`, via `metric_laxSim_contraction_tube`); on nontrivial `E` the unprojected step leaves every band in one step for every `lr > 0` (`unprojected_step_overshoots`); witness `Δ = 1`, `α = 1/2`, `B = 2` (`trust_region_lab_witness`).

## 3. Against `B5` (recognition, Rule 2; numbers from board #20, `@f3-critic` PASS #19)

- **Pool (P6 held, P7 held, P8 failed).** `M3 0.35 → M9 0.35` fits the ceiling's `M`-independence. `M9+anchor 0.00` fits the anchor theorem, **but** the aliased anchor also gave `0.05`: the lab's gain does not need the anchor to carry information (`εₐ` small). Read against the Lean: a judge outside the drift enters with residual weight `1` instead of `1 - γ`, so the pool is no longer in the premises of `pool_disagreement_ceiling` (all judges sharing `γ`) and internal disagreement can exceed `τ`. That is the reading `B5` supports ("independence breaks the rank-1 ceiling"); "the anchor supplied the missing information" is withheld. No Lean statement is contradicted; the anchor theorem's `εₐ` premise is shown not to be what mattered in this simulator.
- **Aliasing (P10 failed).** `G1` reaches `0.00` at `alias = 0.95` with output `0.575`, and `0.00` even at `alias = 1.0`: survival here is not evidence of separation. Open-loop detectability `J = 0.016` (G0) / `0.302` (G1) at `alias = 0.95`. The lab's noise is Gaussian, outside the bounded-noise premise of `aliased_separable_iff`; the mixture floor is the stochastic statement, the Gaussian-additive floor stays unproved.
- **Lag (P9 held).** Open-loop `lag = 8`: Youden `J = 0.000`, no alert before collapse in `20/20`; consistent with `lag_horizon_wall`. Partial collapse rates are not predicted by the theorem (sufficient condition only).
- **Trust region (P1, P3–P5 held).** `tr` alone `0.00` at `lr = 8.0` (out `0.604`) and across `Δ_max ∈ {0.5, 1, 2, 4}`: consistent with the remedy; the runtime is not shown to be an `α`-Lipschitz guard map.
- **Lesson for the map:** collapse rate does not identify a wall; detectability (`J`) does. A future Lean target: state the walls as bounds on detector advantage, which is what items 2–3 bound, not on collapse.

## 4. Draft `periphery-manifest.json` entry #15 (not applied)

```json
{
  "module": "QuantitativeTransfer",
  "region": "map",
  "toolchain": "leanprover/lean4:v4.30.0-rc2",
  "mathlib": true,
  "source": "quantitative-transfer/QuantitativeTransfer.lean",
  "receipt": "quantitative-transfer/quantitative-transfer-verification.json",
  "checker": "quantitative-transfer/check_quantitative_transfer.py",
  "record": "quantitative-transfer-of-four-guard-failure-regimes"
}
```

## 5. Draft schema-2 record `quantitative-transfer-of-four-guard-failure-regimes` (not applied)

```json
{
  "schema_version": 2,
  "id": "quantitative-transfer-of-four-guard-failure-regimes",
  "title": {"en": "Limits and remedies for four guarded-runtime failure regimes over the reals"},
  "kind": "theorem",
  "status": "recorded-checked",
  "family": "F01",
  "statement": {"en": "A rank-1 shared drift caps pool disagreement at 1 - γ for every pool size while an anchor outside the drift detects it; aliased probes are separable iff 2ε < (1 - α) times the fiber gap; drawdown at rate H₁ crosses x_crit before a correction delayed past (x₀ - x_crit)/H₁; projected steps after an α-Lipschitz guard stay in a tube of radius Δ/(1 - α), unprojected steps leave every band."},
  "laws": [
    {"en": "Scores γ c + (1 - γ) u_i with residuals in [0, 1]: disagreement ≤ 1 - γ for every M, attained for M ≥ 2; pool-mean error ≥ γ|c - t| - (1 - γ) for every M, equal to γ|c - t| at truthful residuals; anchor veto fires when τ + (1 - γ) + εₐ < γ|c - t| while internal veto with τ ≥ 1 - γ never fires.",
     "declarations": ["QuantitativeTransfer.pool_disagreement_ceiling", "QuantitativeTransfer.pool_shared_bias_floor", "QuantitativeTransfer.pool_ceiling_attained", "QuantitativeTransfer.anchor_detects_shared_drift", "QuantitativeTransfer.correlated_pool_blindness_vs_anchor", "QuantitativeTransfer.correlated_pool_lab_witness"]},
    {"en": "Aliased readings (1 - α) p + α m∘f under bounded noise ε separate two same-fiber states iff 2ε < (1 - α)|p u₁ - p u₂|; inside, every predictor of a viability split errs by ≥ 1/2 (fiber_split_readout_floor on admissible pairs); finite mixture laws give test error sum ≥ 1 - (1 - α) tvDist ≥ α, attained.",
     "declarations": ["QuantitativeTransfer.aliased_fiber_gap", "QuantitativeTransfer.aliased_separable_iff", "QuantitativeTransfer.aliased_readout_floor", "QuantitativeTransfer.aliased_lab_witness", "QuantitativeTransfer.two_point_test_floor", "QuantitativeTransfer.mixture_aliasing_test_floor", "QuantitativeTransfer.mixture_floor_attained"]},
    {"en": "Continuous drawdown at rate ≥ H₁ on [0, L] with (x₀ - x_crit)/H₁ < L reaches x_crit before L, exact on the linear trajectory; the leakage switching lag is strictly increasing in ρ and nonpositive at ρ = 0.",
     "declarations": ["QuantitativeTransfer.lag_horizon_wall", "QuantitativeTransfer.lag_wall_iff_linear", "QuantitativeTransfer.switching_score_persists", "QuantitativeTransfer.switchLag_strictMono_rho", "QuantitativeTransfer.switchLag_nonpos_tabular", "QuantitativeTransfer.leakage_lag_wall", "QuantitativeTransfer.b1_headroom_witness"]},
    {"en": "Trust-region steps after an α-Lipschitz guard form a MetricLaxSim (α, 1, Δ, 0), giving the tube α^n d₀ + Δ(1 - α^n)/(1 - α) (attained on ℝ) and a Viability.Kernel for bands B ≥ max d₀ (Δ/(1 - α)); unprojected steps leave every band in one step.",
     "declarations": ["QuantitativeTransfer.trustRegionMetricLaxSim", "QuantitativeTransfer.trust_region_tube", "QuantitativeTransfer.trust_region_tube_attained", "QuantitativeTransfer.trust_region_viability", "QuantitativeTransfer.unprojected_step_overshoots", "QuantitativeTransfer.trust_region_lab_witness"]}
  ],
  "hypotheses": [{"en": "Lean v4.30.0-rc2 + Mathlib standard axioms (propext, Classical.choice, Quot.sound), Mathlib periphery #15 importing ObservationalFidelity; bounded residuals in [0, 1]; bounded observation noise; continuity and a derivative bound on [0, L]; an α-Lipschitz guard map with 0 ≤ α < 1."}],
  "does_not_show": [
    {"kind": "scope", "en": "Does not prove a floor for Gaussian additive aliasing; the bounded-noise wall and the finite mixture floor are the statements proved."},
    {"kind": "correspondence", "en": "Does not show that the stress lab's judges share one drift weight, that its guard is an α-Lipschitz map, or that its drawdown keeps rate H₁ through the lag; in B5 an aliased anchor helped as much as a clear one, so the anchor's information premise was not what mattered there."},
    {"kind": "non-implication", "en": "A collapse rate does not identify a wall: survival under a throttled guard is not separation.", "witness": "QuantitativeTransfer.aliased_separable_iff"}
  ],
  "standard_boundaries": ["no-evaluation", "formal-not-empirical", "names-provisional", "omission-not-refutation"],
  "validation_scope": {"en": "AI-written; machine-checked by the Lean 4.30.0-rc2 Mathlib checker (receipt 20261124T154706.011836Z): 59 declarations (45 theorems, 0 private) under standard axioms only, 0 sorryAx, 0 market words. Compared against B5 (20 seeds; P1–P7 held, P8–P11 failed, kept)."},
  "next_delta": {"en": "Human read by Ren; state the walls as bounds on detector advantage (Youden J), and prove a Gaussian-additive aliasing floor once measure-theoretic laws are admitted to the periphery."},
  "correspondence": {"en": "Reads RESULTS.md §4.2 FAIL_correlated_pool_drift, FAIL_severe_aliasing, FAIL_long_lag and FAIL_high_lr onto ObservationalFidelity.fiber_split_readout_floor, tvDist, AlignmentReals.MetricLaxSim and metric_laxSim_contraction_tube."},
  "canonical_source": "experiments/integrated-correction/general-framework/generative-basis/lean/quantitative-transfer/QuantitativeTransfer.lean",
  "dependencies": [
    {"id": "observational-fidelity-and-multi-regime-error", "relation": "formal-reuse", "detail": {"en": "Imports FinDist, tvDist, diracDist and fiber_split_readout_floor."}},
    {"id": "continuous-stochastic-alignment-reals", "relation": "formal-reuse", "detail": {"en": "Instantiates MetricLaxSim; uses advance_blocks, metricSlack_eq, metricSlack_le, metric_laxSim_contraction_tube."}}
  ],
  "proof_bindings": [
    {"source": "experiments/integrated-correction/general-framework/generative-basis/lean/quantitative-transfer/QuantitativeTransfer.lean",
     "receipt": "experiments/integrated-correction/general-framework/generative-basis/lean/quantitative-transfer/quantitative-transfer-checks/20261124T154706.011836Z/verification.json",
     "sha256_pointer": "/source_sha256/QuantitativeTransfer", "success_pointer": "/status", "success_value": "passed"}
  ],
  "history": [{"en": "24 November 2026: added as Mathlib periphery #15 (Frontier 3), paired with neural stress-lab B5. AI-written."}]
}
```

The `family`, `reviewed_at_utc`, `references` sha256 list and the record's `.md` twin are left for the landing step (`make research-render` is not run here).
