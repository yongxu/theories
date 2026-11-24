# Wave 2 Results — Real-Learner B1, B2, and Paired Rotating-PCA B3 Study

*AI-written (Wave 2, 25 November 2026; local verification on this MacBook, Rule 7, not pushed). Protocol documented in [PROTOCOL.md](PROTOCOL.md) and gated in [run.py](run.py) via single-read atomic SHA-256 verification before evaluation (`--prediction-sha`). Note on git provenance: protocol, predictions, and evaluation artifacts enter this single Wave 2 commit together, so commit history alone does not establish temporal ordering; runtime prospectivity rests on disjoint training vs. held-out seeds and the `-O`-safe SHA gate.*

## 1. Digest Lock, Environment Cleanliness, and Timing

| Item | Verified value |
|---|---|
| `checkpoints.json` SHA-256 | `ad94bdd185d865821a728c52d825a0932fd1fde4ce9894d38335db0776f5df56` |
| `predictions.json` SHA-256 | `5ae46462dc918e1075300c285b7add09c939f94517de8ac3ca8bcf351fcbd772` |
| `-O` mismatch gate test (`--prediction-sha deadbeef`) | Failed closed with `ValueError: Prediction SHA mismatch` under `python3 -B -O` |
| `predict` CPU time | `0.3682s` (`0.368209s` raw) |
| `evaluate` CPU time | `1.6311s` (`1.631090s` raw) |
| Total CPU time (`<= 18.0s` cap) | `1.9993s` (`1.999299s` raw) |
| Read-only invariants | `experiments/` diff empty vs `fe748cd10`; zero `__pycache__` / `*.pyc` |

## 2. Epistemic Boundary: Proved vs Tested vs Boundary / Failed (Rules 1 & 2)

- **Proved in Lean (cited only, not re-proved here):** `ObservationalFidelity.tvDist_pushKernel_iter_bound`, `ObservationalFidelity.viability_risk_transfer_bound`, `SurvivalDistinguishability.survival_indistinguishable_iff_le_card_pred` (`FiniteKrylov.krylovSub_stabilizes_before_rank`), and `QuantitativeTransfer` continuous lag bounds hold **given their hypotheses**. Agreement on finite rollouts does not prove that a general neural learner satisfies Lean premises.
- **Tested & Confirmed (implementation fidelity, Arm A/B Krylov audits, B3 causal shift):**
  - Exact 53-bit `Random.random()` transition probabilities extracted from `ReinforcePolicy(6, 4, 2)` match held-out `PacedReserveEnv.step` trajectories (`max_emp_vs_exact_micro_tv = 0.03757 <= tv_allow 0.07657`, `impl_sanity_passed = true`).
  - Finite-horizon `m=8` fallback tube (`0` exact `Fraction` theoretical violations across `128` marginal & `256` scalar risk inequalities with `0` slack, `0` empirical violations against float `tube + sqrt/log` allowances, and `8/8` exact-`Fraction` 2-step projected path laws `<= 0.045649 = 2 * eps_1`) hold cleanly.
  - B2 Arm A (frozen `ckpt_1`) and Arm B (exogenous `ckpt_0`/`ckpt_1`) returned `GUARDED` via `check_survival_distinguishability` and matched `2,048` held-out rollouts/cell well within simultaneous `0.05` binomial allowances (`max_err_A = 0.001478 <= 0.038246`, `max_err_B = 0.014510 <= 0.036579`, checkpoint hashes verified unchanged).
  - B3 paired interventions on `64` rotating-PCA streams eliminated collapses (`61/64` natural collapses -> `0/64` clamped at `z = (0, 1)`) and shifted protection requests earlier on `64/64` streams and execution earlier on all `54/54` uncensored natural executions (`64/64` overall including `10` censored natural runs).
- **Honest Boundary & Underpowered Pre-Registered Tests (kept unmodified without post-hoc tuning):**
  - **B1 Contractive Block Horizon (`chosen_m = null`):** Strictly because `eps_m + alpha_m >= 1` for every pre-registered block length `m ∈ {1, 2, 4, 8}`, no tested block meets the contractive criterion `eps_m + alpha_m < 1` (for diagnostics, start states `{3, 4}` kept survival mass `>= 0.9530` through `m = 8`, outside `[0.1, 0.9]`). All B1 tube/risk checks hold only for the **finite-horizon fallback `m=8` tube** (`r_16 = 0.282149`), not as an all-horizon contraction certificate.
  - **B2 Arm C Statistical Detection (`online_passed = false`):** Deterministic non-stationary updates shifted `ckpt_1` at `x = 1, j = 1` (`0.958024 -> 0.966451`, exact gap `0.008426` vs frozen `0.0` and equal-clock `0.000678`), missing both the pre-registered `>= 0.05` exact threshold (regardless of fork count) and the `n_forks = 4,096` simultaneous Hoeffding CI (`emp_gap = 0.002686`, CI `[-0.043571, 0.048942]`) near softmax saturation (`p0 ~ 0.96`).

## 3. Learner Training & 53-bit Exact Action Extraction

Training ran `16` episodes (`92` total `ReinforcePolicy.update_step` calls) in [checkpoints.json](checkpoints.json):

| Checkpoint | Episode | `p0(1)` | `p0(2)` | `p0(3)` | `p0(4)` | Max `|Δp0|` vs init |
|---|---:|---:|---:|---:|---:|---:|
| `init` | 0 | `0.418823` | `0.417794` | `0.416740` | `0.415663` | `0.0` |
| `ckpt_0` | 4 | `0.642728` | `0.640757` | `0.638697` | `0.636549` | `0.223905` |
| `ckpt_1` | 16 | `0.956712` | `0.955978` | `0.955192` | `0.954351` | `0.538688` |

## 4. B1 — Word-Block Contraction vs Finite-Horizon Fallback ([predictions.json](predictions.json), [results.json](results.json))

- Runtime cross-check (`guarded_alignment.observational_fidelity`): `alpha_1 = 1.0` (exact `1/1`), max single-step row defect `0.022404` (`mode 1`, `201795856660733/9007199254740992`) and `0.022825` (`mode 2`, `411172657483795/18014398509481984`), `k_diff_self_zero = true`.
- Exact block word bounds (`m ∈ {1, 2, 4, 8}`):

| `m` | `eps_m` | `alpha_m` | `eps_m + alpha_m` | `cond_e_plus` | `cond_a_plus` | `min_live_surv_denom` | Starts `{3,4}` Live `[0.1, 0.9]`? |
|---:|---:|---:|---:|---:|---:|---:|---|
| `1` | `0.022825` | `1.0` | `1.022825` | `0.022825` | `1.0` | `0.955978` | `false` (`1.0`) |
| `2` | `0.043647` | `1.0` | `1.043647` | `0.043699` | `1.0` | `0.913894` | `false` (`>= 0.997990`) |
| `4` | `0.080892` | `0.999834` | `1.080726` | `0.080768` | `1.0` | `0.835202` | `false` (`>= 0.988651`) |
| `8` | `0.141222` | `0.997918` | `1.139140` | `0.140147` | `1.0` | `0.697563` | `false` (`>= 0.953014`) |

- Held-out verification (`1,024` rollouts/cell × `8` `(start, schedule)` cells; `tv_allow = 0.076568`, `risk_allow = 0.069622`):
  - `max_emp_vs_exact_micro_tv = 0.037570` (`s3_2^16`).
  - `max_exact_tv_vs_macro = 0.215674` (`s3_1^16`), `max_emp_tv_vs_macro = 0.220556` (`s3_2^16`), both below the fallback `m=8` `t=16` bound `0.282149` (and empirical `<= 0.282149 + 0.076568`).
  - `exact_tube_violations = 0`, `exact_risk_violations = 0` (`128` theoretical marginal and `256` theoretical scalar risk inequalities verified in exact `Fraction` arithmetic against the exact rational fallback `m=8` tube with `0` slack); `emp_tube_violations_beyond_allow = 0`, `emp_risk_violations_beyond_allow = 0` (Monte Carlo frequencies vs float `tube_r + sqrt/log` allowances).
  - All `8` two-step projected path laws satisfy `exact_path2_tv_micro_macro ∈ [0.042260, 0.044617] <= 0.045649 = 2 * eps_1` in exact `Fraction` arithmetic (`within_2e1_bound = true`), with `emp_vs_exact_micro_path2_tv <= 0.016885`.

## 5. B2 — Frozen, Exogenous, and Online Survival Distinguishability

| Arm | Pre-Registered Check / Witness | Exact Prediction | Empirical (`n/cell`) | Result |
|---|---|---:|---:|---|
| **Arm A** (Frozen `ckpt_1`) | `check_survival_distinguishability` `GUARDED` (`['2', '1']`, cutoff `3`) | `[1,2]_s3 = 0.998027` vs `s4 = 1.0` | `max_err = 0.001478 <= 0.038246` (`2,048`) | Passed (`[1,2]_s3 = 2041/2048 = 0.996582`) |
| **Arm B** (Exogenous `ckpt_0,1`) | 4-mode `GUARDED` (`['2_c0', '1_c0']`, cutoff `3`); phase `GUARDED` (`['2', '1']`, cutoff `7`) | `alt21_len8_s3 = 0.484201`, `s4 = 0.538928` | `max_err = 0.014510 <= 0.036579` (`2,048`) | Passed; checkpoint SHA-256 unchanged |
| **Arm C** (Online `1` vs `24` at `x=1`) | Fork gap `q0(1)` under `lr=0.25` | `exact_gap = 0.008426 < 0.05` (`0.958024 -> 0.966451`) | `emp_gap = 0.002686`, CI `[-0.043571, 0.048942]` (`4,096`) | **Failed detection** (`online_passed = false`) |
| **Arm C Controls** | Frozen `1` vs `24`; Equal-clock `x=2, j=1` | Frozen `0.0`; Equal-clock `0.000678` | Frozen `0.001221`; Equal-clock `-0.000488` (`4,096`) | Consistent null controls (`excludes_zero = false`) |

## 6. B3 — Paired Rolling-PCA Lag & Two-Stage Rotation-Relapse Mechanism

Across `64` paired streams (`d=2, n=64, lam=3.0, sigma2=0.0625`, `theta_0=(-1.0, -0.125)`, `lr=1/32`, initial headroom `24` + 1 pending aggressive step):

| Metric | Natural Rolling PCA | Clamped `z = (0, 1)` | Paired Contrast / Interpretation |
|---|---:|---:|---|
| Collapses (`t <= 64`) | `61 / 64` | `0 / 64` | Clamping eliminates all collapses |
| First cone entry `t_cone_hit` | `mean 33.2656` (`19..46`, `0` censored) | — | Estimator lag well past physical switch `t=0` |
| Protection request `t_req` | `mean 23.2031` (`23..26`, `0` censored; `54` pre-collapse at `23`, `10` post-collapse shadow) | `mean 5.0` (`5..5`, `0` censored) | Clamped earlier on `64/64` (`mean shift = 18.2031`, after **`4`** completed updates) |
| Protection execution `t_exec` | `mean 24.0` (`24..24`, `54` uncensored, `10` censored) | `mean 6.0` (`6..6`, `0` censored) | Clamped earlier on `54/54` uncensored (`64/64` overall), locking **`x = 19`** |
| Protected before no-return | `54 / 64` (`53` before `t_cone_hit`) | `64 / 64` | **Two-stage rotation-relapse** (`54 -> 51` relapsed -> `61` collapsed) |

**Exact two-stage rotation-relapse mechanics:**
- Of the `64` natural streams, `10` collapsed physically before protective execution (`t_nr = 24`); those `10` later triggered protection requests (`t_req ∈ [24, 26]`) only via the post-collapse shadow head, so their physical executions are censored.
- The remaining `54` natural streams requested protection at `t_req = 23` and executed protection at `t_exec = 24` (`x = 1`). Of these `54`, `53` executed protection prior to `t_cone_hit`, whereas stream `31` entered the cone earlier (`t_cone_hit = 19`) yet still waited until `t_req = 23` / `t_exec = 24` for `theta^T z >= 0`. Each of the `3` surviving natural streams executed `41` consecutive protective steps (`t = 24..64`), whereas each of the `51` relapsing streams executed **`2` to `23`** protective steps before post-change variance on `e_2` pulled `theta^T z < 0` (at first aggressive reversion, `theta[1]` had partially updated to `[-0.124729, -0.031301]`), resuming aggressive draw and collapsing (`61/64` natural collapses total).
- Clamping `z = (0, 1)` completes **`4`** head updates at `t = 1..4` while physical headroom steps `24 -> 20`, requests protection at `t = 5` (headroom `19` after executing step 5's pending draw), and executes permanent protection at `t = 6` with **`19`** reserve remaining.
