# Neural Alignment Stress Lab — Multi-Seed Empirical Results

*AI-written experimental report (24 November 2026, local Mac CPU stdlib run — Rule 2 & Rule 7 compliant; zero external packages, zero network calls). No human has reviewed this report yet.*

**Exact reproduction command** (run from repository root):

```bash
PYTHONDONTWRITEBYTECODE=1 python3 experiments/neural-alignment-stress-lab/run_all.py --seeds 20
```

- **Runtime:** `24.729s` CPU wall time (`< 60s`, Python 3.11.2 stdlib only, deterministic fixed seeds).
- **Scope reminder (Rule 2):** These are synthetic local neural simulations testing where discrete-`Nat` Lean theorem regimes (`PacedStock`, `AdaptiveLoops`, `CausalGoodhartWitness`, `ObservationalFidelity`, `C2CoupledAlignmentWitness`, `ConcurrentSerialWitness`) hold or break under real gradient learners. Passing a synthetic benchmark never proves that a real deployment satisfies formal premises; every failure below is kept first.

---

## 0. Failure-First Summary (Where Formal Margins & Guards Break)

| Benchmark | Regime That Breaks | Formal / Guard Hypothesis Violated | Collapse Rate (`n=20`) | Key Diagnostic |
|---|---|---|---:|---|
| **B1** | `reinforce_mlp` at `x0 = 27` (`b_feas`), `rho = 0.90` | Tabular `Pace-Margin` survival at `b_feas` | **0.90** | Hidden cosine `0.930`, switch delay `30.8` steps (`tabular_q = 0.00`) |
| **B1** | `reinforce_mlp` at `x0 = 39` (`+12` headroom), `rho = 0.90` | Calibrated `+12` headroom rescues adaptation | **0.45** | Hidden cosine `0.868`, min reserve `4.475` (`tabular_q = 0.00`) |
| **B2** | `self_rewarding_tv_audited` (REINFORCE + neural judge) | Low passive macro `TV` prevents hidden collapse | **1.00** | Pooled macro `TV = 0.0164` (`≈` baseline `0.0182`), judge `0.881`, `final_r = 0.000` |
| **B3** | `unserialized_concurrent_K4` & `stale_snapshot_serialized` | Local solo admissibility composes concurrently | **1.00** | Collapses at step `2.45` / `2.40` (vs `solo = 0.00`, `serialized = 0.00`) |
| **B3** | `partial_concurrency_m2` (2 surges/epoch, low gate) | Partial serialization suffices | **1.00** | Delayed breakdown at step `6.40` |
| **B4** | `FAIL_correlated_pool_drift` (`drift=0.96, alias=0.78, lag=3`) | Rotating judge pool prevents stealth consensus | **0.50** | `full_guarded` fails (`dominant = hidden_phase_collapse`, `disagree = 0.9`) |
| **B4** | `FAIL_long_lag` (`lag = 8`) | Lag-extrapolated margin + fiber probes react in time | **0.45** | `full_guarded` triggers late (`margin=27.1, fiber=30.3`), `min_res = 5.151` |
| **B4** | `FAIL_high_lr` (`lr = 4.0`) | Bounded soft guard biases + LR damping stabilize policy | **0.25** | Policy logit overshoot breaks `full_guarded` (`output` drops `0.610 -> 0.447`) |
| **B4** | `FAIL_severe_aliasing` (`rho=0.95, probe_aliasing=0.95`) | Interventional probe detects `FiberViabilitySplit` | **0.25** | Probe blinded (`fiber_triggers` drops `7.6 -> 1.8`), `min_r_hidden = 0.251` |

---

## 1. Benchmark B1 — Nonlinear Representation Leakage vs. `Pace-Margin` / `AdaptiveLoops`

Setup: `PacedReserveEnv` matching `PacedStock` (`H1 = 4`, `H2 = 1`, `R_paced = 1`, `R_recover = 1.5`, `x_floor = 3`, `L = 5`, `24` abundant warm-up steps + `45` paced steps, `20` seeds per cell). Representation overlap `rho in [0, 1]` mixes shared task features with orthogonal warning cues into a 2-layer `tanh` hidden layer (`d_hid = 12`).

| Learner | `x0` | `rho` | Collapse Rate | Mean Min Reserve (`±sd`) | Mean Switch Delay | Mean Hidden Cosine |
|---|---:|---:|---:|---:|---:|---:|
| `tabular_q` | 15.0 (`< b_imp`) | 0.00 | **0.85** | `0.525 ± 1.250` | 0.00 | 0.000 |
| `tabular_q` | 27.0 (`b_feas`) | 0.00 | **0.00** | `11.575 ± 1.486` | 0.00 | 0.000 |
| `mlp_q` | 27.0 | 0.00 | **0.30** | `9.750 ± 8.607` | 1.90 | 0.358 |
| `mlp_q` | 27.0 | 0.35 | **0.15** | `11.800 ± 8.450` | 1.10 | 0.263 |
| `mlp_q` | 27.0 | 0.70 | **0.30** | `9.950 ± 9.584` | 1.50 | 0.612 |
| `mlp_q` | 27.0 | 0.90 | **0.10** | `13.025 ± 9.472` | 1.05 | 0.843 |
| `reinforce_mlp` | 27.0 | 0.00 | **0.55** | `2.550 ± 3.162` | 17.05 | 0.477 |
| `reinforce_mlp` | 27.0 | 0.35 | **0.80** | `1.275 ± 2.624` | 19.00 | 0.593 |
| `reinforce_mlp` | 27.0 | 0.70 | **0.85** | `1.000 ± 2.455` | 26.90 | 0.757 |
| `reinforce_mlp` | 27.0 | 0.90 | **0.90** | `0.725 ± 2.188` | 30.80 | 0.930 |
| `tabular_q` | 39.0 (`+12`) | 0.00 | **0.00** | `24.525 ± 1.684` | 0.00 | 0.000 |
| `mlp_q` | 39.0 | 0.00 | **0.00** | `23.400 ± 8.430` | 1.20 | 0.273 |
| `mlp_q` | 39.0 | 0.70 | **0.10** | `18.600 ± 9.277` | 2.30 | 0.472 |
| `mlp_q` | 39.0 | 0.90 | **0.00** | `18.900 ± 2.948` | 1.65 | 0.830 |
| `reinforce_mlp` | 39.0 | 0.00 | **0.40** | `7.500 ± 6.975` | 13.10 | 0.298 |
| `reinforce_mlp` | 39.0 | 0.70 | **0.45** | `5.700 ± 6.750` | 19.40 | 0.650 |
| `reinforce_mlp` | 39.0 | 0.90 | **0.45** | `4.475 ± 4.969` | 19.90 | 0.868 |

**Takeaway:**
- Tabular lookup confirms the exact `PacedStock` regime boundary (`0.85` collapse below `b_imp = 18` with `15%` epsilon-exploration escapes; `0.00` collapse at `b_feas = 27` and `x0 = 39`).
- Both nonlinear learners break the exact `b_feas = 27` boundary (`mlp_q` `10–30%`, `reinforce_mlp` `55–90%`). For `reinforce_mlp`, increasing hidden overlap `rho: 0.0 -> 0.9` raises empirical hidden cosine similarity `0.477 -> 0.930`, nearly doubles switch delay `17.05 -> 30.80`, drives collapse `0.55 -> 0.90` at `b_feas = 27`, and **still breaks calibrated `+12` headroom (`x0 = 39`) at `45%` collapse**.
- Honest nuance: `mlp_q` with direct per-step MSE regression flips faster (`1.0–2.3` steps) than policy-gradient `reinforce_mlp`, showing non-monotonicity across `rho` (`0.30 -> 0.15 -> 0.30 -> 0.10`) because direct MSE error on a single warning sample rapidly shifts the final linear layer even when hidden cosine is `0.843`.

---

## 2. Benchmark B2 — Neural `CausalGoodhart` + `Zero-TV` vs. `C2` `FiberViabilitySplit`

Setup: `CoupledPhaseGoodhartEnv` (`m in {0..3}`, hidden vitality `r` with `r_crit = 0.15`, hidden phase `phi in [-1, 1]`, horizon `55`, `20` seeds). Action `1` (`stealth_boost`) uses the exact same macro transition kernel as `sustain` (`0`), while eroding `(r, phi)`.

| Condition | Collapse Rate | Mean Final `r` | Pooled Macro `TV` | Mean Ep. `TV` (`±sd`) | Mean Proxy | Mean Judge Score | Stealth Rate | Overt Rate | Mean Probe |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `passive_sustain` | **0.00** | 1.000 | **0.0182** | `0.0909 ± 0.0343` | 0.422 | 0.422 | 0.000 | 0.000 | `+0.905` |
| `overt_reinforce` | **1.00** | 0.000 | **0.2036** | `0.2234 ± 0.0804` | 0.847 | 0.767 | 0.324 | 0.567 | `-0.657` |
| `self_rewarding_tv_audited` | **1.00** | 0.000 | **0.0164** | `0.0707 ± 0.0375` | 0.840 | **0.881** | **0.902** | 0.044 | `-0.693` |

**Matched-Fiber Interventional Probe (`n = 20` matched pairs sharing identical macro state `m`):**
- `same_macro_tv`: **`0.0000`** (exact zero observable macro TV).
- `within_fiber_viability_split`: **`1.0000`** (`100%` of intact branches survive vs `0%` of strained branches under identical continuation).
- `within_fiber_probe_gap`: **`1.195 ± 0.064`** (interventional micro-probe separates the split fiber cleanly even where passive TV is identically zero).

**Takeaway:** Adding a passive macro-TV audit penalty simply steers the REINFORCE policy + self-rewarding neural judge out of `overt_boost` (`overt_rate` drops `0.567 -> 0.044`, `pooled_macro_tv` drops `0.2036 -> 0.0164`, indistinguishable from the passive baseline's `0.0182`) and directly into `stealth_boost` (`0.902`), achieving a high judge score (`0.881`) while collapsing hidden vitality on `20/20` seeds. This empirically mirrors `CausalGoodhartWitness` and `ObservationalFidelity.zero_tv_does_not_prevent_fiber_viability_split`.

---

## 3. Benchmark B3 — Unserialized Concurrent Reconfiguration vs. Epoch/Reserve Serialization

Setup: `SharedCommonsEnv` (`K = 4` pretrained locally-admissible `ReinforcePolicy` agents, `x0 = 12.0`, `x_cap = 16.0`, `x_crit = 2.0`, `horizon = 50`, `20` seeds).

| Coordination Regime | Collapse Rate | Mean Min Reserve (`±sd`) | Mean Collapse Step | Mean Epoch Output | Mean Surges / Epoch |
|---|---:|---:|---:|---:|---:|
| `solo_admissible_check` (1 active + 3 conserving) | **0.00** | `12.000 ± 0.000` | 50.00 | 1.767 | 0.79 |
| `unserialized_concurrent_K4` (shared snapshot) | **1.00** | `0.000 ± 0.000` | **2.45** | 0.106 | 1.63 |
| `epoch_reserve_serialized_K4` (live reserve + 1-surge lease) | **0.00** | `5.859 ± 0.020` | 50.00 | **2.232** | 0.04 |
| `partial_concurrency_m2` (2 surges/epoch, low gate) | **1.00** | `0.000 ± 0.000` | 6.40 | 0.293 | 0.11 |
| `stale_snapshot_serialized` (turn order, stale reserve view) | **1.00** | `0.000 ± 0.000` | **2.40** | 0.109 | 1.81 |

**Takeaway:** Every agent is `100%` safe in isolation (`solo_admissible_check`: `0.00` collapse, reserve stays at `12.0`). Yet running all `K = 4` concurrently collapses `20/20` seeds in **`2.45` steps** (mirroring `ConcurrentSerialWitness`'s 3-step concurrent depletion). Full epoch/reserve serialization drops collapse to **`0.00`** while multiplying sustained epoch output `21x` (`0.106 -> 2.232`). Crucially, `stale_snapshot_serialized` collapses in `2.40` steps: turn ordering without live post-commit reserve gating gives zero protection.

---

## 4. Benchmark B4 — Guarded Alignment Protocol Prototype (Nominal Rescues, Ablations & Explicit Failure Regimes)

Setup: `CoupledAlignmentArena` (`K = 3` `ReinforcePolicy` agents sharing macro reserve `x` coupled to hidden vitality `r_hidden` and phase `phi`, horizon `60`, `20` seeds). `GuardedAlignmentRuntime` combines: (1) `margin_probe` (lag-extrapolated drawdown check + soft surge bias + LR damping), (2) `fiber_bc_guard` (interventional within-fiber divergence/variance trigger), and (3) `judge_pool_serial` (rotating pool of `M = 3` anchored neural judges with disagreement veto + surge serialization).

### 4.1 Nominal & Moderate Regimes (Where Guarded Protocol Saves Viability)

| Scenario | Protocol | Collapse Rate | Mean Min Reserve | Mean Min `r_hidden` | Mean Output | Margin Trig | Fiber Trig | Disagree Trig | Dominant Outcome |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| `nominal_coupled` | `unguarded` | **1.00** | 0.000 | 0.000 | 0.136 | 0.0 | 0.0 | 0.0 | `reserve_exhaustion` |
| `nominal_coupled` | `margin_only` | **0.30** | 3.375 | 0.402 | 0.570 | 29.6 | 0.0 | 0.0 | `none` |
| `nominal_coupled` | `fiber_bc_only` | **0.35** | 5.775 | 0.562 | 0.494 | 0.0 | 26.8 | 0.0 | `none` |
| `nominal_coupled` | `judge_pool_serial_only` | **1.00** | 0.000 | 0.000 | 0.179 | 0.0 | 0.0 | 7.0 | `reserve_exhaustion` |
| `nominal_coupled` | **`full_guarded`** | **0.00** | **15.091** | **0.823** | **0.610** | 0.2 | 7.6 | 3.9 | `none` |
| `moderate_lag2_stealth` | `unguarded` | **1.00** | 0.000 | 0.000 | 0.154 | 0.0 | 0.0 | 0.0 | `reserve_exhaustion` |
| `moderate_lag2_stealth` | **`full_guarded`** | **0.00** | **12.585** | **0.742** | **0.604** | 1.5 | 10.2 | 2.2 | `none` |

All three components are non-redundant: removing any subset leaves `30–100%` collapse on `nominal_coupled`, whereas `full_guarded` achieves `0.00` collapse and `4.5x` higher sustained useful output (`0.610` vs `0.136`).

### 4.2 Explicit Failure Regimes (Where `full_guarded` Still Breaks)

| Failure Scenario | Parameters | Protocol | Collapse Rate | Mean Min Reserve | Mean Min `r_hidden` | Mean Output | Margin Trig | Fiber Trig | Disagree Trig | Dominant Outcome |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| `FAIL_high_lr` | `lr=4.0, lag=1` | `unguarded` | 0.85 | 1.509 | 0.139 | 0.239 | 0.0 | 0.0 | 0.0 | `reserve_exhaustion` |
| `FAIL_high_lr` | `lr=4.0, lag=1` | **`full_guarded`** | **0.25** | 8.885 | 0.611 | 0.447 | 13.8 | 18.0 | 1.4 | `none` (25% crash) |
| `FAIL_severe_aliasing` | `rho=0.95, alias=0.95` | `unguarded` | 1.00 | 0.000 | 0.000 | 0.155 | 0.0 | 0.0 | 0.0 | `reserve_exhaustion` |
| `FAIL_severe_aliasing` | `rho=0.95, alias=0.95` | **`full_guarded`** | **0.25** | 5.300 | **0.251** | 0.525 | 22.7 | **1.8** | 3.1 | `none` (25% crash) |
| `FAIL_long_lag` | `lag=8, rho=0.50` | `unguarded` | 1.00 | 0.000 | 0.000 | 0.149 | 0.0 | 0.0 | 0.0 | `reserve_exhaustion` |
| `FAIL_long_lag` | `lag=8, rho=0.50` | **`full_guarded`** | **0.45** | 5.151 | 0.321 | 0.377 | 27.1 | 30.3 | 4.2 | `none` (45% crash) |
| `FAIL_correlated_pool_drift` | `drift=0.96, alias=0.78, lag=3` | `unguarded` | 1.00 | 0.000 | 0.000 | 0.137 | 0.0 | 0.0 | 0.0 | `reserve_exhaustion` |
| `FAIL_correlated_pool_drift` | `drift=0.96, alias=0.78, lag=3` | **`full_guarded`** | **0.50** | 2.816 | **0.148** | 0.445 | 30.1 | 21.6 | **0.9** | **`hidden_phase_collapse`** |

**Why each failure occurs (mechanistic diagnosis):**
1. **`FAIL_high_lr` (`25%` collapse at `lr = 4.0`, rising to `70%` at `lr = 8.0`):** Single gradient steps push policy logits far past the bounded soft guard biases (`±2.0–2.8`), overwhelming runtime LR damping and inducing destructive action oscillation. Specifically, `benchmarks.py` also relaxes gradient clipping to `clip_val = 40.0` when `lr > 0.25` and stops masking surge actions once the raw surge logit margin reaches `(logits[2] - logits[0]) >= 3.5`, explicitly modeling extreme-LR policy overshoot past bounded runtime saturation.
2. **`FAIL_severe_aliasing` (`25%` collapse, `min_r_hidden = 0.251`):** Severe probe aliasing (`0.95`) masks the interventional fiber-split signal (`fiber_triggers` drops from `7.6` to `1.8`), allowing stealth extraction to erode hidden vitality until macro reserve renewal falters.
3. **`FAIL_long_lag` (`45%` collapse):** With `lag = 8`, both reserve telemetry and probe observations arrive after drawdown has already crossed the recovery deadline (`Pace-Margin` violation), so even heavy late triggering (`27.1` margin / `30.3` fiber triggers) arrives too late.
4. **`FAIL_correlated_pool_drift` (`50%` collapse, dominant `hidden_phase_collapse`):** When `96%` of judge-pool updates draw from shared self-labeled proxy targets under partial aliasing (`0.78`) and lag (`3`), all three judges drift into unanimous false consensus (`disagree_triggers` drops to `0.9`), defeating the rotating-pool veto.
