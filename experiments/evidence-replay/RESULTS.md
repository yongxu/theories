# Track S3 Verified Results

*AI-written (Track S3 `@entry-and-replay`). All numbers below come directly from local execution outputs of [check_encounter_entry.py](../integrated-correction/general-framework/generative-basis/lean/encounter-entry/check_encounter_entry.py) and the scripts/tests in `experiments/evidence-replay/`.*

## Part A: `EncounterEntry.lean` (0-Axiom Lean 4 Verification)

Target file: [EncounterEntry.lean](../integrated-correction/general-framework/generative-basis/lean/encounter-entry/EncounterEntry.lean)  
Report file: [encounter-entry-verification.json](../integrated-correction/general-framework/generative-basis/lean/encounter-entry/encounter-entry-verification.json)

- **Lean toolchain:** `Lean (version 4.29.1, arm64-apple-darwin24.6.0, commit f72c35b3f637c8c6571d353742168ab66cc22c00, Release)`
- **Imports:** `Init` only
- **Declarations / Theorems:** `91` declarations, `35` theorems
- **Axioms (`nonempty_axioms`):** `{}` (`0` axioms — no `propext`, `Quot.sound`, `Classical.choice`, `sorryAx`, or `.injEq`)
- **Transitive `.injEq` dependencies:** `{}` (14 unused generated `.injEq` constants, `0` sourced dependencies)
- **Market words (`MARKET_WORDS` check):** `0`
- **Negative self-tests passed:** `4` (`reject_omega_propext`, `reject_injEq_via_simp`, `reject_sorryAx`, `reject_market_word`)
- **Leaked `.olean` files:** `0` (`[]`)
- **Key formalized theorems:**
  1. Inquiry separation: `adaptive_two_step_identifies_pair`, `fixed_two_step_oracle_collision`, `fixed_two_step_misses_pair`, `fixed_two_step_recovers_value_only`.
  2. Branching vs path-count `2xa + 2xb`: `sysA_path_counts_2xa_2xb`, `pathCount_eq`, `sysA_completes_all`, `sysB_branch_stuck`.
  3. Open non-sealing entry from `.resolved`: `drainQueue_reduces_prefix`, `fair_open_entry_after_any_revision`, `clause1_acquisition_and_independent_verification`, `clause2a_causal_uptake_vs_masking`, `clause2b_false_objection_rejected`, `sealing_gate_blocks_entrants`, `clause3_second_entrant_after_revision1`, `encounter_refines_and_preserves_entry`.

## Part B1: IN1 Trajectory Replay & Synthetic Alignment ([fixtures/in1_replay_table.json](fixtures/in1_replay_table.json))

- **Saved runs replayed:** `20` (`DIR_SEEN_TALK`, `gpt-5.4-mini` and `gpt-4.1-mini`)
- **Months verified under `lake.py` transition equations:** `229` (`all_identities_passed: true`, `0` violations)
- **`gpt-5.4-mini` summary (`months_bed_alive_before = 113`):**
  - `[10, 10, 10]` announcements while bed alive: `113 / 113`
  - Exact `[10, 10, 10]` executed catches: `109`
  - Lower-catch survivals: `2` (Seed 7 Month 3: `[10, 10, 0] -> left=80, next_stock=100`; Seed 7 Month 5: `[0, 10, 0] -> left=90, next_stock=100`)
  - Fatal overtakes despite `[10, 10, 10]` announcement: `2` (Seed 4 Month 8: `[30, 10, 10] -> left=50, bed_alive_after=false, next_stock=100`; Seed 9 Month 9: `[10, 20, 10] -> left=60, bed_alive_after=false, next_stock=100`)
- **`View1` vs `View2` separation (`gpt-5.4-mini` Seed 0 vs Seed 4) & endpoint-vs-monthly audit:**
  - Months 1–8 endpoint `View1` (`opening_stock=100`, 8 `[10, 10, 10]` `announcements`, endpoint `next_stock=100`, `view1_prefix8_equal: true`) and `monthly_trace_prefix8` match while `View2` separates at Month 8 (`bed_alive_throughout: true` vs `false`). Across all `229` non-empty saved prefixes (`test_replay_suite.py`), endpoint `Pass1` diverges from monthly `all_next_stocks_ge_need` on `18` prefixes while `Pass2` matches on all `229` (plus empty-prefix `opening_stock` and oversubscribed `Lake.step` rationing checks).
- **`gpt-4.1-mini` revisions:**
  - Seed 3 Month 1 (faithful harmful): catches `[20, 20, 20] -> left=40`, bed dies, `next_stock=80`.
  - Seed 7 double revision: Month 1 `[10, 20, 10] -> [10, 10, 10]` (`left=70` vs counterfactual `60`); Month 2 `[10, 10, 20] -> [10, 10, 10]` (`left=70` vs counterfactual `60`); `bed_kept=true`, `lake_kept=true`.
- **Synthetic `EncounterEntry` handshake rows:**
  - Inquiry puzzle: adaptive hits `4/4`, all `9` fixed pairs `< 4/4`, value-only fixed schedule `[readL, readR]` hits `4/4`.
  - `2xa + 2xb` branching: `sysA` and `sysB` share path counts `{xa: 2, xb: 2}`; `sysA` completes `4/4` post-branch requests while `sysB` completes `2/4`.
  - Clause 2a reserve check: delivered `6 >= 5` vs masked `1 < 5`.

## Part B2: Exact Rational Primal-Dual Verifier ([fixtures/duality_handshake.json](fixtures/duality_handshake.json))

- **§7.1 absorption:** `["1/4", "3/4"]`
  - Public-only minimax error across `ε ∈ {0, 1/16, 1/8, 1/4}`: `1/4`
  - With recipient contact (`min(1/4, 2*ε)`): `0`, `1/8`, `1/4`, `1/4`
  - Dropping recipient contact restores `1/4`.
- **B2 `CoupledPhaseGoodhartEnv` 1,000-seed paired empirical run (`seed = 30000 + i`, initial `m = 1`):**
  - Macro counts at `t = 0`: `[108, 188, 547, 157]` (identical for strained vs intact across `alpha ∈ {0.0, 0.8, 1.0}`)
  - Horizon-10 survival: `0/1000` (strained) vs `1000/1000` (intact)
  - Positive interventional probe counts `(strained, intact)`:
    - `alpha = 0.0`: `(0, 1000)`, exact minimax at `ε = 1/20` is `1/20`
    - `alpha = 0.8`: `(285, 632)`, exact minimax at `ε = 1/20` is `50/347` (verified primal `μ=(247/347, 100/347)` vs `ν=(1, 0)` and dual `b=-285/347, c=[1000/347]`, matching Track S2's symmetric primal `(0, 1)` vs `(100/347, 247/347)`)
    - `alpha = 1.0`: `(434, 434)`, exact minimax is `1/2`
- **Track B `diag(1, 1 - δ)` multi-step survival errors `(1 - (1 - δ)^n) * min(1/2, ε/δ)`:**
  - `(δ=1/4, n=1, ε=1/16) -> 1/16`
  - `(δ=1/4, n=2, ε=1/16) -> 7/64`
  - `(δ=1/4, n=3, ε=1/16) -> 37/256`
  - `(δ=1/4, n=3, ε=1/4) -> 37/128`
  - `(δ=1/5, n=4, ε=1/20) -> 369/2500`
  - `(δ=1/2, n=3, ε=1/8) -> 7/32`
- **Negative tamper checks (`4/4` rejected):** `tampered_L_gt_U`, `primal_eps_violation`, `nonzero_duality_gap`, `invalid_distribution`.

## Part B3: Phase 2 Disentangled 2D Sweep & Breach Bound ([fixtures/phase2_disentangled.json](fixtures/phase2_disentangled.json))

- **2D Sweep (`25` cells, `60` seeds/cell, fixed `x0=25.0, renewal=2.6, warn_onset=21.0, x_crit=5.0, cap=28.0, horizon=150, lr=0.25, eps=0.05`):**
  - Varying `rho_reward ∈ {0.0, 0.4, 0.8, 1.4, 2.2}` and `rho_feat ∈ {0.0, 0.35, 0.70, 0.90, 0.98}` independently avoids confounding onset/reserve dynamics.
  - At `rho_reward = 1.4`: across `rho_feat ∈ {0.0, 0.35, 0.7, 0.9, 0.98}`, `pre_switch_death_rate` climbs `0.0 -> 0.0 -> 0.45 -> 0.6333 -> 0.75`. Conditional switch-time means (`14.1 -> 16.35 -> 15.697 -> 16.364 -> 26.067`) under-report harm when dead runs are dropped, whereas competing-risk imputed means expose it (`14.1 -> 16.35 -> 76.133 -> 101.0 -> 119.017`).
- **Stochastic breach checks (`400` trials × `24` `(x0, sigma, p_spike)` regimes):**
  - `all_exact_bounds_hold_eta_zero: true` (`Pr(breach) == Pr(C_excursion > B)` everywhere, e.g., at `x0=27`: `0.0 -> 0.3625` across `(0, 0) -> (5.0, 0.25)`; at `x0=39`: `0.0 -> 0.2175`).
  - `all_surrogate_bounds_hold_with_eta: true`.

## Part B4: §5 Communication-Order & Protocol Benchmarks ([fixtures/protocol_8slot.json](fixtures/protocol_8slot.json))

- **2-item order & causal-uptake benchmark (`200` episodes):**
  - `diagnostic_coupled_accuracy = 1.0`, `no_diagnostic = 0.475`, `scrambled_reply = 0.50`, `false_receipt = 0.0`, `late_probe = 0.475`.
- **8-slot 4-bit communication-order separation (`2048` pairs):**
  - `pigeonhole_upper_bound = 1696`, `warehouse_first_prefix4 = 1536`, `warehouse_first_rep4 = 1536`, `requester_first_3plus1 = 2048`.
- **Private naming & dynamic shift (`30` trials):**
  - `mean_unaligned = 1130.67`, `mean_learned = 2048.0` (`21` paid queries / `84` bits), `mean_shifted_stale = 1130.67`, `mean_relearned = 2048.0`, `mean_scrambled_control = 1156.27`.
- **B2 / B4 probe-budget comparison:**
  - B2 4-probe separation drops `1.0` (`alpha=0.0, 0.5`) → `0.816` (`0.8`) → `0.40` (`1.0`).
  - B4 (`12` seeds) collapse rates: `unguarded_nominal = 1.0`, `guarded_targeted_low_alias = 0.0`, `guarded_blind_high_alias = 0.3333`, `guarded_late_lag8 = 0.1667`.
