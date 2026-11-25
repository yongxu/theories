# Neural Alignment Stress Lab — Multi-Seed Empirical Results

*AI-written experimental report (24 November 2026, local Mac CPU stdlib run — Rule 2 & Rule 7 compliant; zero external packages, zero network calls). No human has reviewed this report yet.*

**Exact reproduction command** (run from repository root):

```bash
PYTHONDONTWRITEBYTECODE=1 python3 experiments/neural-alignment-stress-lab/run_all.py --seeds 20
```

- **Runtime (B1–B4):** `24.729s` CPU wall time (`< 60s`, Python 3.11.2 stdlib only, deterministic fixed seeds).
- **B5 runtime:** about `36s` CPU (`PYTHONDONTWRITEBYTECODE=1 python3 experiments/neural-alignment-stress-lab/run_all.py --b5 --seeds 20`, or `--with-b5` after B1–B4).
- **Scope reminder (Rule 2):** These are synthetic local neural simulations testing where discrete-`Nat` Lean theorem regimes (`PacedStock`, `AdaptiveLoops`, `CausalGoodhartWitness`, `ObservationalFidelity`, `C2CoupledAlignmentWitness`, `ConcurrentSerialWitness`) hold or break under real gradient learners. Passing a synthetic benchmark never proves that a real deployment satisfies formal premises; every failure below is kept first. B5 (§5) adds remediations next to four failed pre-registered predictions.

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
| **B5** | `FAIL_high_lr` (`lr = 4.0` / `8.0`), baseline `full_guarded` | Bounded soft guard biases stabilise policy | **0.40 / 0.80** | Remediated to `0.00 / 0.00` by trust region + un-bypassed hard mask (§5) |
| **B5** | `FAIL_correlated_pool_drift`, `M = 3 -> 9` unanchored | More rotating judges prevent consensus | **0.35 -> 0.35** | Rank-1 ceiling held; independent dissenter lowers it to `0.00`, but a blind one also does (`0.05`, §5.0) |
| **B5** | `FAIL_long_lag` (`lag = 8`), `FAIL_severe_aliasing` (`0.95`) with gain variants | Gain tuning rescues a blind channel | `0.05–0.20` / `0.00–0.30` | **Prediction failed (`P9`–`P11`):** collapse alone mislabels blind throttling as rescue; channel `J = 0.000` at `lag = 8` (§5.0) |

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
- Both nonlinear learners break the exact `b_feas = 27` boundary (`mlp_q` `10–30%`, `reinforce_mlp` `55–90%`). For `reinforce_mlp`, policy-gradient variance and switch delay already produce `55%` collapse at `b_feas = 27` and `40%` collapse at `+12` headroom (`x0 = 39`) even at `rho = 0.0` (zero explicit feature overlap); increasing hidden overlap `rho: 0.0 -> 0.9` then raises empirical hidden cosine similarity `0.477 -> 0.930`, nearly doubles switch delay `17.05 -> 30.80`, and pushes collapse from `0.55 -> 0.90` at `b_feas = 27` (`0.40 -> 0.45` at `x0 = 39`).
- Honest nuance: `mlp_q` with direct per-step MSE regression flips faster (`1.0–2.3` steps) than policy-gradient `reinforce_mlp`, showing non-monotonicity across `rho` (`0.30 -> 0.15 -> 0.30 -> 0.10`) because direct MSE error on a single warning sample rapidly shifts the final linear layer even when hidden cosine is `0.843`.

---

## 2. Benchmark B2 — Neural `CausalGoodhart` + `Zero-TV` vs. `C2` `FiberViabilitySplit`

Setup: `CoupledPhaseGoodhartEnv` (`m in {0..3}`, hidden vitality `r` with `r_crit = 0.15`, hidden phase `phi in [-1, 1]`, horizon `55`, `20` seeds). Action `1` (`stealth_boost`) uses the exact same macro transition kernel as `sustain` (`0`), while eroding `(r, phi)`. Five arms separate reward choice, action-blind macro-TV monitoring, and action-targeted macro-TV penalties:

| Condition | Collapse Rate | Mean Final `r` | Pooled Macro `TV` | Mean Ep. `TV` (`±sd`) | Mean Proxy | Mean Judge Score | Stealth Rate | Overt Rate | Mean Probe |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `passive_sustain` | **0.00** | 1.000 | **0.0182** | `0.0909 ± 0.0343` | 0.422 | 0.422 | 0.000 | 0.000 | `+0.905` |
| `overt_reinforce` | **1.00** | 0.000 | **0.2036** | `0.2234 ± 0.0804` | 0.847 | 0.767 | 0.324 | 0.567 | `-0.657` |
| `self_rewarding_no_tv_audit` (matched control) | **1.00** | 0.000 | **0.1509** | `0.1639 ± 0.0852` | 0.856 | 0.899 | 0.467 | 0.462 | `-0.692` |
| `self_rewarding_blind_tv_audit` (action-blind TV) | **0.90** | 0.097 | **0.1073** | `0.1325 ± 0.0578` | 0.713 | 0.114 | 0.363 | 0.263 | `-0.293` |
| `self_rewarding_tv_audited` (overt-targeted TV) | **1.00** | 0.000 | **0.0164** | `0.0707 ± 0.0375` | 0.840 | **0.881** | **0.902** | 0.044 | `-0.693` |

**Matched-Fiber Interventional Probe (`n = 20` matched pairs sharing identical macro state `m`):**
- `same_macro_tv`: **`0.0000`** (exact zero observable macro TV).
- `within_fiber_viability_split`: **`1.0000`** (`100%` of intact branches survive vs `0%` of strained branches under identical continuation).
- `within_fiber_probe_gap`: **`1.195 ± 0.064`** (interventional micro-probe separates the split fiber cleanly even where passive TV is identically zero).

**Takeaway (matched ablation):**
- The no-audit self-rewarding control (`self_rewarding_no_tv_audit`, same neural judge with `tv_pen = 0`, separate arm seeds) already collapses `20/20` (`1.00`) with a nearly even mix of stealth (`46.7%`) and overt (`46.2%`) extraction (`pooled_macro_tv = 0.1509`), showing that collapse occurs here without TV auditing (though separate seeds do not by themselves rule out causal effects of auditing on trajectory dynamics).
- Adding a genuinely **action-blind** macro-TV penalty (`self_rewarding_blind_tv_audit`, penalizing empirical macro-TV drift uniformly across all actions) lowers overt rate (`46.2% -> 26.3%`) and pooled TV (`0.1509 -> 0.1073`), yet still fails to preserve viability (`18/20 = 0.90` collapse).
- Conditioning the TV penalty specifically on overt drift (`self_rewarding_tv_audited`, an idealized upper-bound monitor that penalizes only overt action `2`) pushes pooled macro TV below the passive baseline (`0.0164` vs `0.0182`) by concentrating `90.2%` of actions into the zero-TV stealth fiber while retaining a high judge score (`0.881`) and `20/20` collapse. Together with the matched-fiber probe (`same_macro_tv = 0.0`, `within_fiber_viability_split = 1.0`), this empirically mirrors `CausalGoodhartWitness` and `ObservationalFidelity.zero_tv_does_not_prevent_fiber_viability_split`.

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
| `nominal_coupled` | `margin_plus_fiber` (2-guard) | **0.05** | 8.475 | 0.790 | 0.626 | 11.6 | 13.7 | 0.0 | `none` |
| `nominal_coupled` | `margin_plus_pool` (2-guard) | **0.15** | 6.034 | 0.299 | 0.556 | 22.0 | 0.0 | 4.5 | `none` |
| `nominal_coupled` | `fiber_plus_pool` (2-guard) | **0.00** | 14.993 | 0.798 | 0.608 | 0.0 | 8.3 | 3.2 | `none` |
| `nominal_coupled` | **`full_guarded`** | **0.00** | **15.091** | **0.823** | **0.610** | 0.2 | 7.6 | 3.9 | `none` |
| `moderate_lag2_stealth` | `unguarded` | **1.00** | 0.000 | 0.000 | 0.154 | 0.0 | 0.0 | 0.0 | `reserve_exhaustion` |
| `moderate_lag2_stealth` | `margin_plus_fiber` (2-guard) | **0.05** | 7.954 | 0.773 | 0.616 | 13.9 | 12.3 | 0.0 | `none` |
| `moderate_lag2_stealth` | `margin_plus_pool` (2-guard) | **0.25** | 4.709 | 0.245 | 0.515 | 25.4 | 0.0 | 4.0 | `none` |
| `moderate_lag2_stealth` | `fiber_plus_pool` (2-guard) | **0.00** | 12.718 | 0.740 | 0.608 | 0.0 | 10.7 | 1.6 | `none` |
| `moderate_lag2_stealth` | **`full_guarded`** | **0.00** | **12.585** | **0.742** | **0.604** | 1.5 | 10.2 | 2.2 | `none` |

**Complete ablation reading (1-guard and 2-guard subsets):** No single guard eliminates collapse on `nominal_coupled` (`30–100%` collapse). Across the three 2-guard pairs, **`fiber_bc_guard` is clearly non-redundant** — removing it (`margin_plus_pool`) leaves `0.15` nominal / `0.25` moderate collapse and drops hidden vitality to `0.299`/`0.245`. Removing `judge_pool_serial` (`margin_plus_fiber`) leaves `0.05` (`1/20`) collapse on its appended arm seeds (`5600–5619`) and halves reserve headroom (`15.09 -> 8.48`), though on the exact `full_guarded` seeds (`4500–4519`) `margin_plus_fiber` also achieves `0/20` collapse (overlapping 95% Wilson intervals), so `judge_pool_serial` improves reserve margin here without proving strict necessity for `0/20` collapse on nominal seeds. Finally, **`margin_probe` is redundant for `0/20` collapse on both `nominal_coupled` and `moderate_lag2_stealth`** once `fiber_bc_guard + judge_pool_serial` are active (`fiber_plus_pool` already achieves `0.00` collapse and `0.608` output; `margin_probe` fires only `0.2–1.5` times/episode as a secondary reserve backstop).

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

---

## 5. Benchmark B5 — Remediable Control Defects vs. Structural Walls (`b5_walls.py`)

*AI-written. Predictions `P1`–`P11` were committed before any B5 code existed: [`B5-PREDICTIONS.md`](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/frontier3-quantitative-transfer-2026-11-24/B5-PREDICTIONS.md) (commit `dc241c915`). The tables below are generated by `format_b5_markdown`, not typed by hand.*

Reproduce (`n = 20`, about `36s` CPU, deterministic; main seeds `5100 + cell·100 + s`, `Δ_max` sensitivity `6100+`, post-hoc `7100+`):

```bash
PYTHONDONTWRITEBYTECODE=1 python3 experiments/neural-alignment-stress-lab/run_all.py --b5 --seeds 20
```

Setup: every variant subclasses the B4 runtime (`B5Runtime`); with default options it reproduces B4 seed by seed (unit-tested). Guards read only the lagged reserve and lagged probe. Variants never change the arena, its collapse rule, or the physical `lag` / `probe_aliasing`.

### 5.0 Failure-first reading

1. **Four of eleven pre-registered predictions failed: `P8`, `P9`, `P10`, `P11`.** All four concern the "wall" side and the anchor control. They are kept as failed.
2. **Collapse rate does not identify a wall.** At `alias = 0.95` the hair-trigger guard `G1` gets `0.00` collapse at output `0.575`; at `alias = 1.0` (a probe carrying no state) `G1` also gets `0.00` at `0.574`. Post-hoc, an information-free throttle (random fiber alerts, `p = 0.20`) on the baseline guard gets `0.10` at `0.535`. Survival at these cells is blind throttling that the output floor `0.55` in the rescue definition did not exclude. The rescue definition was too weak; it was fixed in advance and is not edited.
3. **What does show a wall is channel detectability (post-hoc, open loop).** With `lag = 8`, the lagged probe never separates a strained fiber from a healthy one (`J = 0.000`, and `20/20` all-stealth runs collapse with no alert at all before collapse, under both threshold sets). With `alias = 0.95`, baseline thresholds give `J = 0.016`; hair-trigger thresholds recover `J = 0.302` at `17.2%` false alarms. With `alias = 1.0`, `J = 0.010` / `0.078`.
4. **`lag = 8` is not a clean collapse-rate wall either:** `G3` reaches `0.05` collapse at output `0.551`, which clears the rescue rule by `0.001`; treat it as marginal. `G0` here collapses `0.20` (`95%` interval `0.08–0.42`) against `0.45` in B4 §4.2 (`0.26–0.66`): the two intervals overlap, so the B4 rate was partly seed luck.
5. **The anchor control (`P8`) failed:** `M9+anchor_aliased` collapses `0.05`, not `≥ 0.30`. Post-hoc, a fully blind anchor (`alias = 1.0`) also gets `0.05`, probe-only anchor `0.00`, judge-only anchor `0.25`. With the anchor judge present the pool disagreement veto fires about `100` times per run against `1.7` without it. In this arena one independent dissenting judge breaks the unanimous consensus even when its channel carries no state. So the evidence supports "independence breaks the rank-1 ceiling", not "the anchor supplied the missing information". Intervals overlap (`0.00`, `0.05`, `0.25` at `n = 20`); no ordering among these three is claimed.

### 5.1 What held

- `P1`, `P2`: `FAIL_high_lr` baseline collapses `0.40` (`lr = 4.0`) and `0.80` (`lr = 8.0`) on fresh seeds; `tr+mask` gets `0.00` at both, output `0.610` / `0.612`.
- `P3`: `mask` alone and `tr` alone also reach `0.00` at `lr = 8.0` (a tie, so "the mask does most" holds only on the `≤`). `tr` alone keeps output (`0.604`), the mask alone loses it (`0.516`).
- `P4`, `P5`: at nominal `lr = 0.05`, `tr+mask` stays at `0.00` and output `0.607` (baseline `0.608`). `Δ_max ∈ {0.5, 1.0, 2.0, 4.0}` on held-out seeds all give `0.00` collapse; output falls to `0.554` at `Δ_max = 4.0, lr = 8.0`. The trust region bounds the step on the sampled features only; other states are not constrained.
- `P6`, `P7`: unanchored `M3 → M9` leaves collapse at `0.35 → 0.35` (more correlated judges do not help); adding the anchor gives `0.00`.

### 5.2 Generated tables (`n = 20`)

**Test 1 — remediable `FAIL_high_lr`**

| Scenario | Variant | Collapse (`95%` Wilson) | Mean Output | Mean Min Reserve | Mean Min `r_hidden` | Margin Trig | Fiber Trig | Disagree Trig | Dominant Outcome |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| `high_lr_4.0` | `baseline` | **0.40** (`0.22–0.61`) | 0.415 | 7.046 | 0.562 | 20.0 | 17.0 | 1.6 | `none` |
| `high_lr_4.0` | `mask` | **0.00** (`0.00–0.16`) | 0.498 | 12.194 | 0.778 | 2.1 | 3.5 | 0.8 | `none` |
| `high_lr_4.0` | `tr` | **0.00** (`0.00–0.16`) | 0.596 | 13.075 | 0.779 | 0.8 | 10.3 | 4.3 | `none` |
| `high_lr_4.0` | `tr+mask` | **0.00** (`0.00–0.16`) | 0.610 | 13.454 | 0.767 | 0.7 | 13.2 | 2.9 | `none` |
| `high_lr_8.0` | `baseline` | **0.80** (`0.58–0.92`) | 0.268 | 2.495 | 0.258 | 39.0 | 40.1 | 2.4 | `reserve_exhaustion` |
| `high_lr_8.0` | `mask` | **0.00** (`0.00–0.16`) | 0.516 | 10.949 | 0.796 | 2.7 | 2.8 | 1.3 | `none` |
| `high_lr_8.0` | `tr` | **0.00** (`0.00–0.16`) | 0.604 | 14.069 | 0.796 | 0.7 | 9.9 | 2.1 | `none` |
| `high_lr_8.0` | `tr+mask` | **0.00** (`0.00–0.16`) | 0.612 | 13.831 | 0.796 | 1.1 | 10.8 | 2.2 | `none` |
| `nominal_lr_0.05` | `baseline` | **0.00** (`0.00–0.16`) | 0.608 | 13.794 | 0.791 | 0.3 | 8.2 | 3.0 | `none` |
| `nominal_lr_0.05` | `tr+mask` | **0.00** (`0.00–0.16`) | 0.607 | 14.240 | 0.792 | 0.2 | 9.6 | 2.1 | `none` |

**Test 1 — `Δ_max` sensitivity (held-out seeds `6100+`)**

| Scenario | Variant | Collapse (`95%` Wilson) | Mean Output | Mean Min Reserve | Mean Min `r_hidden` | Margin Trig | Fiber Trig | Disagree Trig | Dominant Outcome |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| `high_lr_4.0` | `tr+mask@0.5` | **0.00** (`0.00–0.16`) | 0.619 | 13.924 | 0.779 | 0.6 | 14.2 | 1.6 | `none` |
| `high_lr_4.0` | `tr+mask@1.0` | **0.00** (`0.00–0.16`) | 0.606 | 13.910 | 0.802 | 0.5 | 10.4 | 3.4 | `none` |
| `high_lr_4.0` | `tr+mask@2.0` | **0.00** (`0.00–0.16`) | 0.597 | 13.410 | 0.785 | 1.2 | 7.8 | 2.9 | `none` |
| `high_lr_4.0` | `tr+mask@4.0` | **0.00** (`0.00–0.16`) | 0.588 | 12.551 | 0.769 | 2.5 | 6.7 | 1.6 | `none` |
| `high_lr_8.0` | `tr+mask@0.5` | **0.00** (`0.00–0.16`) | 0.614 | 14.282 | 0.788 | 0.3 | 12.2 | 4.2 | `none` |
| `high_lr_8.0` | `tr+mask@1.0` | **0.00** (`0.00–0.16`) | 0.610 | 13.720 | 0.786 | 0.6 | 10.9 | 1.4 | `none` |
| `high_lr_8.0` | `tr+mask@2.0` | **0.00** (`0.00–0.16`) | 0.593 | 13.372 | 0.784 | 0.8 | 8.2 | 2.0 | `none` |
| `high_lr_8.0` | `tr+mask@4.0` | **0.00** (`0.00–0.16`) | 0.554 | 13.946 | 0.806 | 1.4 | 3.6 | 0.8 | `none` |

**Test 2 — `FAIL_correlated_pool_drift`**

| Scenario | Variant | Collapse (`95%` Wilson) | Mean Output | Mean Min Reserve | Mean Min `r_hidden` | Margin Trig | Fiber Trig | Disagree Trig | Dominant Outcome |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| `correlated_pool_drift_0.96` | `M3` | **0.35** (`0.18–0.57`) | 0.513 | 4.124 | 0.176 | 26.1 | 17.9 | 1.5 | `none` |
| `correlated_pool_drift_0.96` | `M9` | **0.35** (`0.18–0.57`) | 0.540 | 3.958 | 0.183 | 25.5 | 15.7 | 1.7 | `none` |
| `correlated_pool_drift_0.96` | `M9+anchor` | **0.00** (`0.00–0.16`) | 0.580 | 12.116 | 0.718 | 2.3 | 7.8 | 114.1 | `none` |
| `correlated_pool_drift_0.96` | `M3+anchor` | **0.00** (`0.00–0.16`) | 0.578 | 12.159 | 0.734 | 2.5 | 7.9 | 121.5 | `none` |
| `correlated_pool_drift_0.96` | `M9+anchor_aliased` | **0.05** (`0.01–0.24`) | 0.587 | 9.863 | 0.535 | 7.2 | 8.0 | 95.9 | `none` |

**Test 3 — impossibility walls (physical `lag` / `alias` unchanged)**

| Scenario | Variant | Collapse (`95%` Wilson) | Mean Output | Mean Min Reserve | Mean Min `r_hidden` | Margin Trig | Fiber Trig | Disagree Trig | Dominant Outcome |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| `long_lag_8` | `G0_baseline` | **0.20** (`0.08–0.42`) | 0.494 | 8.014 | 0.504 | 15.7 | 22.2 | 3.2 | `none` |
| `long_lag_8` | `G1_hair_trigger` | **0.15** (`0.05–0.36`) | 0.504 | 10.243 | 0.537 | 16.3 | 24.9 | 1.4 | `none` |
| `long_lag_8` | `G2_heavy_gains` | **0.15** (`0.05–0.36`) | 0.521 | 8.700 | 0.509 | 15.7 | 24.6 | 1.1 | `none` |
| `long_lag_8` | `G3_hair_trigger_heavy_gains` | **0.05** (`0.01–0.24`) | 0.551 | 9.135 | 0.554 | 18.1 | 28.6 | 2.6 | `none` |
| `long_lag_8` | `always_sustain` | **0.00** (`0.00–0.16`) | 0.440 | 18.000 | 0.880 | 0.0 | 0.0 | 0.0 | `none` |
| `severe_aliasing_0.95` | `G0_baseline` | **0.30** (`0.14–0.52`) | 0.523 | 5.572 | 0.333 | 20.0 | 2.1 | 5.5 | `none` |
| `severe_aliasing_0.95` | `G1_hair_trigger` | **0.00** (`0.00–0.16`) | 0.575 | 14.521 | 0.779 | 1.8 | 12.1 | 2.5 | `none` |
| `severe_aliasing_0.95` | `G2_heavy_gains` | **0.15** (`0.05–0.36`) | 0.593 | 6.649 | 0.347 | 19.1 | 1.5 | 2.5 | `none` |
| `severe_aliasing_0.95` | `G3_hair_trigger_heavy_gains` | **0.00** (`0.00–0.16`) | 0.576 | 14.703 | 0.782 | 1.9 | 13.0 | 2.5 | `none` |
| `severe_aliasing_0.95` | `always_sustain` | **0.00** (`0.00–0.16`) | 0.440 | 18.000 | 0.880 | 0.0 | 0.5 | 0.0 | `none` |

**Reference — `always_sustain` at nominal**

| Scenario | Variant | Collapse (`95%` Wilson) | Mean Output | Mean Min Reserve | Mean Min `r_hidden` | Margin Trig | Fiber Trig | Disagree Trig | Dominant Outcome |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| `nominal_lr_0.05` | `always_sustain` | **0.00** (`0.00–0.16`) | 0.440 | 18.000 | 0.880 | 0.0 | 0.0 | 0.0 | `none` |

**Post-hoc (not pre-registered; seeds `7100+`)**

| Scenario | Variant | Collapse (`95%` Wilson) | Mean Output | Mean Min Reserve | Mean Min `r_hidden` | Margin Trig | Fiber Trig | Disagree Trig | Dominant Outcome |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| `severe_aliasing_0.95` | `G0+random_alarm_p0.20` | **0.10** (`0.03–0.30`) | 0.535 | 13.270 | 0.728 | 4.2 | 12.7 | 2.6 | `none` |
| `long_lag_8` | `G0+random_alarm_p0.40` | **0.00** (`0.00–0.16`) | 0.524 | 16.369 | 0.847 | 0.8 | 25.2 | 3.5 | `none` |
| `total_aliasing_1.0` | `G0_baseline` | **0.40** (`0.22–0.61`) | 0.461 | 4.540 | 0.250 | 24.8 | 0.8 | 7.0 | `none` |
| `total_aliasing_1.0` | `G1_hair_trigger` | **0.00** (`0.00–0.16`) | 0.574 | 14.135 | 0.740 | 2.9 | 13.1 | 1.4 | `none` |
| `correlated_pool_drift_0.96` | `M9+anchor_blind(alias1.0)` | **0.05** (`0.01–0.24`) | 0.585 | 8.582 | 0.429 | 10.1 | 7.2 | 99.0 | `none` |
| `correlated_pool_drift_0.96` | `M9+anchor_fiber_only` | **0.00** (`0.00–0.16`) | 0.616 | 12.430 | 0.698 | 2.4 | 21.4 | 1.1 | `none` |
| `correlated_pool_drift_0.96` | `M9+anchor_judge_only` | **0.25** (`0.11–0.47`) | 0.503 | 6.996 | 0.335 | 16.6 | 13.9 | 103.5 | `none` |

**Post-hoc open-loop channel detectability (all-stealth vs all-sustain play; strained = `r_hidden < 0.60`)**

| Channel | Thresholds | TPR (strained) | FPR (healthy) | Youden `J` | Stealth runs collapsed | No alert before collapse | Mean lead (steps) |
|---|---|---:|---:|---:|---:|---:|---:|
| `nominal(lag1,alias0.05)` | `G0_baseline` | 1.000 | 0.000 | **1.000** | 20 | 0 | 3.1 |
| `nominal(lag1,alias0.05)` | `G1_hair_trigger` | 1.000 | 0.000 | **1.000** | 20 | 0 | 4.0 |
| `long_lag_8` | `G0_baseline` | 0.000 | 0.000 | **0.000** | 20 | 20 | None |
| `long_lag_8` | `G1_hair_trigger` | 0.000 | 0.000 | **0.000** | 20 | 20 | None |
| `severe_aliasing_0.95` | `G0_baseline` | 0.025 | 0.009 | **0.016** | 20 | 18 | 3.0 |
| `severe_aliasing_0.95` | `G1_hair_trigger` | 0.475 | 0.172 | **0.302** | 20 | 2 | 2.4 |
| `total_aliasing_1.0` | `G0_baseline` | 0.025 | 0.015 | **0.010** | 20 | 18 | 2.5 |
| `total_aliasing_1.0` | `G1_hair_trigger` | 0.325 | 0.247 | **0.078** | 20 | 7 | 3.2 |

**Pre-registered predictions (thresholds verbatim from `B5-PREDICTIONS.md`):**

| Prediction | Held | Observed |
|---|---|---|
| P1 | yes | `{'tr+mask@4': 0.0, 'tr+mask@8': 0.0}` |
| P2 | yes | `{'baseline@4': 0.4, 'baseline@8': 0.8}` |
| P3 | yes | `{'mask@8': 0.0, 'tr@8': 0.0, 'baseline@8': 0.8}` |
| P4 | yes | `{'collapse': 0.0, 'output': 0.607}` |
| P5 | yes | `{'tr+mask@0.5': 0.0, 'tr+mask@2.0': 0.0, 'tr+mask@4.0': 0.0}` |
| P6 | yes | `{'M3': 0.35, 'M9': 0.35}` |
| P7 | yes | `{'M9+anchor': 0.0, 'M9': 0.35}` |
| P8 | **NO** | `{'M9+anchor_aliased': 0.05}` |
| P9 | **NO** | `{'G0_baseline': [0.2, 0.494], 'G1_hair_trigger': [0.15, 0.504], 'G2_heavy_gains': [0.15, 0.521], 'G3_hair_trigger_heavy_gains': [0.05, 0.551]}` |
| P10 | **NO** | `{'G0_baseline': [0.3, 0.523], 'G1_hair_trigger': [0.0, 0.575], 'G2_heavy_gains': [0.15, 0.593], 'G3_hair_trigger_heavy_gains': [0.0, 0.576]}` |
| P11 | **NO** | `{'violations': [('long_lag_8', 'G3_hair_trigger_heavy_gains'), ('severe_aliasing_0.95', 'G1_hair_trigger'), ('severe_aliasing_0.95', 'G2_heavy_gains'), ('severe_aliasing_0.95', 'G3_hair_trigger_heavy_gains')]}` |

### 5.3 Limits of what B5 shows

One synthetic arena, one policy family, `20` seeds per cell (the `95%` Wilson interval at `0/20` is `0.00–0.16`). The `tr+mask` remedy is tested against a defect (`lr`) that B4 builds in through its relaxed gradient clip and its surge-logit bypass, so removing the bypass is removal of a modelled defect, not discovery of one. Similarly, in `b5_walls.py` the parameter `correlated_judge_drift = 0.96` is the stochastic update-coupling probability `p_drift` (updating all self-judges on the same proxy pseudo-label), which is a Rule 2 correspondence — **not** an identity — with the affine score-mixing weight `γ` in `QuantitativeTransfer.pool_disagreement_ceiling`. B5 does not show that any real deployment has these channels. It shows that in this arena survival and detection come apart: a guard can survive blind at some loss of output, and the channel test, not the collapse rate, is what separates "cannot tell" from "can tell but acted too late".

### 5.4 Post-hoc heterogeneous-judge & matched-veto-rate controls (`b5_controls.py`)

To test two design questions raised during adversarial review without altering frozen `b5_walls.py`, `b5_controls.py` (`n = 20`, seeds `7100+`, deterministic) runs two post-hoc controls on the same correlated-drift arena (`drift = 0.96, alias = 0.78, lag = 3`):

1. **Heterogeneous noisy self-judges vs. shared-label baseline:** in the baseline `b5_walls.py` pool, judges have distinct random initializations and receive individual grounded updates on the `4%` non-drift steps, while sharing the same pseudo-label update on `96%` drift steps. The heterogeneous arm simultaneously varies bootstrap inclusion (`p = 0.70`), per-judge Gaussian label noise (`sd = 0.12`), and distinct learning rates (`0.04..0.08`) while reading the same proxy threshold (`px > 0.70`).
2. **Matched-veto-rate random dissent (`QuantitativeTransfer` Part 9 check):** compares `M9 + anchor_aliased (alias = 1.0)` (with `anchor_judge` counted once inside `B5Runtime.judge_pool.judges`) against an `M = 9` pool with no anchor judge that fires a pure i.i.d. coin-flip veto matched to the exact observed veto rate (`p_veto = 0.5325`, zero hidden-state signal and zero action conditioning). Note that the random-veto arm also removes the anchor judge from the rotating reward pool, so the veto rule is not the sole difference between the two arms.

| Control Arm (`b5_controls.py`, `n = 20`) | Collapse (`95%` Wilson) | Mean Output | Disagree Trig | Mean Veto Rate |
|---|---:|---:|---:|---:|
| `M3_shared_label_baseline` | **0.55** (`0.34–0.74`) | 0.459 | 2.1 | 0.0119 |
| `M9_shared_label_baseline` | **0.30** (`0.15–0.52`) | 0.539 | 1.4 | 0.0075 |
| `M3_heterogeneous_noisy` | **0.10** (`0.03–0.30`) | 0.609 | 4.8 | 0.0267 |
| `M9_heterogeneous_noisy` | **0.30** (`0.15–0.52`) | 0.549 | 3.8 | 0.0208 |
| `M9_anchor_true_0.0` | **0.00** (`0.00–0.16`) | 0.574 | 115.3 | 0.6406 |
| `M9_anchor_aliased_1.0` | **0.05** (`0.01–0.24`) | 0.597 | 95.8 | 0.5325 |
| `M9_random_veto_matched_rate` (`p = 0.5325`) | **0.05** (`0.01–0.24`) | 0.587 | 95.8 | 0.5325 |

**Takeaway:**
- Heterogeneous updates raise disagreement triggers at `M = 3` (`0.10` collapse vs `0.55` baseline), yet scaling heterogeneous judges from `M = 3 -> 9` still leaves `0.30` collapse (matching `M9_shared_label_baseline` at `6/20`, overlapping Wilson intervals), indicating that scaling panel size under a shared proxy channel does not eliminate drift collapse.
- **`M9_random_veto_matched_rate` (`p = 0.5325`) reaches the same `1/20 = 0.05` collapse rate as `M9_anchor_aliased_1.0`** (`95.8` vs `95.8` triggers, `0.587` vs `0.597` output) with zero hidden-state signal and no anchor in the pool — consistent with the formal separation proved in `QuantitativeTransfer.aliased_anchor_breaks_panel_sd_with_zero_youdenJ` (`consensus_break_vs_hidden_signal_witness`).
