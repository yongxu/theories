# Wave 2 Results — Real-Learner B1, B2, and Paired Rotating-PCA B3 Study

*AI-written (Wave 2, 25 November 2026; local verification on this MacBook, Rule 7, not pushed). Strictly prospective protocol locked in [PROTOCOL.md](PROTOCOL.md) before training/prediction (`run.py predict`) and SHA-gated before evaluation (`run.py evaluate --prediction-sha <sha>`).*

## 1. Digest Lock, Environment Cleanliness, and Timing

| Item | Verified value |
|---|---|
| `checkpoints.json` SHA-256 | `bc5de3fc80f0f55a805d8988f52f8578b0fdcd7509b7d3ce63446e3fdd077614` |
| `predictions.json` SHA-256 | `a72760f4513cd98480d1a9fe7bf0613b50e0be520f318a6bd08a75e78d2561df` |
| `-O` mismatch gate test (`--prediction-sha deadbeef`) | Failed closed with `ValueError: Prediction SHA mismatch` under `python3 -B -O` |
| `predict` CPU time | `0.3604s` (`0.360394s` raw) |
| `evaluate` CPU time | `1.2727s` (`1.27268s` raw) |
| Total CPU time (`<= 18.0s` cap) | `1.6331s` (`1.633074s` raw) |
| Read-only invariants | `experiments/` diff empty vs `fe748cd10`; zero `__pycache__` / `*.pyc` |

## 2. Epistemic Boundary: Proved vs Tested vs Boundary / Failed (Rules 1 & 2)

- **Proved in Lean (cited only, not re-proved here):** `ObservationalFidelity.tvDist_pushKernel_iter_bound`, `ObservationalFidelity.viability_risk_transfer_bound`, `SurvivalDistinguishability.survival_indistinguishable_iff_le_card_pred` (`FiniteProbKrylov.krylovSub_stabilizes_before_rank`), and `QuantitativeTransfer` continuous lag bounds hold **given their hypotheses**. Agreement on finite rollouts does not prove that a general neural learner satisfies Lean premises.
- **Tested & Confirmed (implementation fidelity, Arm A/B Krylov audits, B3 causal shift):**
  - Exact 53-bit `Random.random()` transition probabilities extracted from `ReinforcePolicy(6, 4, 2)` match held-out `PacedReserveEnv.step` trajectories (`max_emp_vs_exact_micro_tv = 0.03757 <= tv_allow 0.07657`, `impl_sanity_passed = true`).
  - Finite-horizon `m=8` fallback tube (`0` exact violations, `0` empirical violations across `128` marginal & `256` scalar risk checks) and 2-step projected path laws (`<= 0.04565 = 2 * eps_1`) hold cleanly.
  - B2 Arm A (frozen `ckpt_1`) and Arm B (exogenous `ckpt_0`/`ckpt_1`) returned `GUARDED` via `check_survival_distinguishability` and matched `2,048` held-out rollouts/cell well within simultaneous `0.05` binomial allowances (`max_err_A = 0.00148 <= 0.03825`, `max_err_B = 0.01451 <= 0.03658`, hashes verified unchanged).
  - B3 paired interventions on `64` rotating-PCA streams eliminated collapses (`61/64` natural collapses -> `0/64` clamped at `z = (0, 1)`) and shifted protection requests and executions earlier on `64/64` streams.
- **Honest Boundary & Underpowered Pre-Registered Tests (kept unmodified without post-hoc tuning):**
  - **B1 Contractive Block Horizon (`chosen_m = null`):** `ckpt_1` learns strong restraint (`p0(1..4) ∈ [0.9544, 0.9567]`), keeping depth-8 survival mass `>= 0.953` outside the `[0.1, 0.9]` informative collapse band. Hence `eps_m + alpha_m >= 1` for every `m ∈ {1, 2, 4, 8}`, and the infinite-horizon contractive threshold never fires by `m = 8`. All B1 tube/risk checks hold only for the **finite-horizon fallback `m=8` tube** (`r_16 = 0.28215`), not as an all-horizon contraction certificate.
  - **B2 Arm C Statistical Detection (`online_passed = false`):** While deterministic non-stationary updates shifted `ckpt_1` at `x = 1, j = 1` (`0.958024 -> 0.966451`, exact gap `0.008426` vs frozen `0.0` and equal-clock `0.000678`), both the `0.008426` exact shift (< pre-registered `0.05`) and the empirical difference (`0.002686`, simultaneous Hoeffding CI `[-0.04357, 0.04894]`) were swamped near softmax saturation (`p0 ~ 0.96`) at `n_forks = 4,096`.

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

| `m` | `eps_m` | `alpha_m` | `eps_m + alpha_m` | `cond_e_plus` | `cond_a_plus` | `min_live_surv_denom` | Live `[0.1, 0.9]`? |
|---:|---:|---:|---:|---:|---:|---:|---|
| `1` | `0.022825` | `1.0` | `1.022825` | `0.022825` | `1.0` | `0.955978` | `false` (`1.0`) |
| `2` | `0.043647` | `1.0` | `1.043647` | `0.043699` | `1.0` | `0.913894` | `false` (`>= 0.9980`) |
| `4` | `0.080892` | `0.999834` | `1.080726` | `0.080768` | `1.0` | `0.835202` | `false` (`>= 0.9887`) |
| `8` | `0.141222` | `0.997918` | `1.139140` | `0.140147` | `1.0` | `0.697563` | `false` (`>= 0.9530`) |

- Held-out verification (`1,024` rollouts/cell × `8` `(start, schedule)` cells; `tv_allow = 0.076568`, `risk_allow = 0.069622`):
  - `max_emp_vs_exact_micro_tv = 0.037570` (`s3_2^16`).
  - `max_exact_tv_vs_macro = 0.215674` (`s3_1^16`), `max_emp_tv_vs_macro = 0.220556` (`s3_2^16`), both below the fallback `m=8` `t=16` bound `0.282149` (and empirical `<= 0.282149 + 0.076568`).
  - `exact_tube_violations = 0`, `emp_tube_violations_beyond_allow = 0`, `exact_risk_violations = 0`, `emp_risk_violations_beyond_allow = 0`.
  - All `8` two-step projected path laws satisfy `exact_path2_tv_micro_macro ∈ [0.042260, 0.044617] <= 0.045649 = 2 * eps_1` (`within_2e1_bound = true`), with `emp_vs_exact_micro_path2_tv <= 0.016885`.

## 5. B2 — Frozen, Exogenous, and Online Survival Distinguishability

| Arm | Pre-Registered Check / Witness | Exact Prediction | Empirical (`n/cell`) | Result |
|---|---|---:|---:|---|
| **Arm A** (Frozen `ckpt_1`) | `check_survival_distinguishability` `GUARDED` (`['2', '1']`, cutoff `3`) | `[1,2]_s3 = 0.998027` vs `s4 = 1.0` | `max_err = 0.001478 <= 0.038246` (`2,048`) | Passed (`[1,2]_s3 = 2041/2048 = 0.996582`) |
| **Arm B** (Exogenous `ckpt_0,1`) | 4-mode `GUARDED` (`['2_c0', '1_c0']`, cutoff `3`); phase `GUARDED` (`['2', '1']`, cutoff `7`) | `alt21_len8_s3 = 0.484201`, `s4 = 0.538928` | `max_err = 0.014510 <= 0.036579` (`2,048`) | Passed; checkpoint SHA-256 unchanged |
| **Arm C** (Online `1` vs `24` at `x=1`) | Fork gap `q0(1)` under `lr=0.25` | `exact_gap = 0.008426` (`0.958024 -> 0.966451`) | `emp_gap = 0.002686`, CI `[-0.043571, 0.048942]` (`4,096`) | **Failed detection** (`online_passed = false`) |
| **Arm C Controls** | Frozen `1` vs `24`; Equal-clock `x=2, j=1` | Frozen `0.0`; Equal-clock `0.000678` | Frozen `0.001221`; Equal-clock `-0.000488` (`4,096`) | Consistent null controls (`excludes_zero = false`) |

## 6. B3 — Paired Rolling-PCA Lag & Two-Stage Rotation-Relapse Mechanism

Across `64` paired streams (`d=2, n=64, lam=3.0, sigma2=0.0625`, `theta_0=(-1.0, -0.125)`, `lr=1/32`, initial headroom `24` + 1 pending aggressive step):

| Metric | Natural Rolling PCA | Clamped `z = (0, 1)` | Paired Contrast / Interpretation |
|---|---:|---:|---|
| Collapses (`t <= 64`) | `61 / 64` | `0 / 64` | Clamping eliminates all collapses |
| First cone entry `t_cone_hit` | `mean 33.2656` (`min 19, max 46`, `0` censored) | — | Estimator lag well past physical switch `t=0` |
| Protection request `t_req` | `mean 23.2031` (`23..26`, `0` censored) | `mean 5.0` (`5..5`, `0` censored) | Clamped earlier on `64/64` (`mean shift = 18.2031`) |
| Protection execution `t_exec` | `mean 24.0` (`24..24`, `10` censored) | `mean 6.0` (`6..6`, `0` censored) | Clamped earlier on `64/64` (`5` head updates + `1` pending lag) |
| Protected before no-return | `54 / 64` (`53` before `t_cone_hit`) | `64 / 64` | **Two-stage rotation-relapse** explains `54 -> 61` |

**Why `54` momentary pre-no-return protections still yield `61/64` natural collapses:** before the covariance window rotates (`z ≈ (1, 0)`), online updates drive `theta[0]` positive enough to trigger a single protective request right around `t = 23` (`t_exec = 24`, at `x = 1`, before no-return). Once post-change variance actually rotates into `v` (toward `t_cone_hit`), `z[1]` grows while `theta[1]` is still negative (`-0.125`), flipping `theta^T z < 0` back to aggressive draw at low headroom and triggering a second-stage collapse on `51 / 54` temporarily rescued streams (`10` already collapsed before `t_exec`, plus `51` relapsed after `t_exec`, leaving `61/64` collapsed and `3/64` surviving). Clamping `z = (0, 1)` trains `theta[1]` immediately (`5` updates), locking protection at `t_exec = 6` (`x = 18`) permanently.
