# Dual-Track Milestone Cold-Read Summary (Tracks A1, B1, B2, and B3/B4 Probes)

> AI-written (24 November 2026). Prepared for Ren's cold read; no human has reviewed these four tracks yet. Strict Rule 1 & Rule 2 separation: every mathematical result lists exact Lean premises and scope; empirical Python scripts are local CPU runs only (`Rule 7`).

---

## 1. Pilot Cleanup & Track A1 — Net Core Compression (Landed in `53f9cf598`)

- **What changed and why:** Before adding new Lean theorems, we fixed a vacuity in `Becoming.DoubleKernel` (restricting macro functors to `SumPreservingFunctor` forced bijectivity on all finite spans, proved with `0` axioms in `sumPreserving_finPres_chi_bijective`) and tested Board Rule 9 ("generalize below, not beside") on two existing core duplication clusters.
- **Proved (`0` core axioms, `PreludeOnly` checked, receipt `20261124T112343.843972Z`, audited `PASS` by `gpt-6.2-astra/high` `01a20d43`):**
  - `Becoming.OplaxHistory` (`59` thms / `148` decls): finite-presentation rigidity (`sumPreserving_finPres_chi_bijective`), constructive `0`-axiom `1 → 2` witness `inhabitedOptionFunctor_chi_not_surjective`, and full-chain lifting `exactCausal_lifts_implies_chain_lift`.
  - `Becoming.DoubleKernel` (`36` thms / `71` decls): relaxed guarded oplax syntax to general `SpanFunctor` + `finite_non_invertible_chiStep_witness`.
  - **Track A1-a (`Becoming.StockFlowBridge` `58` thms / `69` decls):** factored `Nat`-clamped overdraw arithmetic (`clampedStep_balance_discrepancy`, `clampedStep_balance_iff_le`) below `UnifiedDrawdown` and `EvolutionaryDrawdown`, cutting proof-body tokens across the 4 refactored theorems (`+ 2` shared helpers) by **`-42.2%` (`1,742 → 1,007`)** and total tokens by **`-23.7%` (`2,748 → 2,097`)**; held-out finite-list aggregate conservation `list_clampedStep_exact_balance_iff_all_covered` required `29` lines (`382` total / `203` body tokens) using existing `Becoming.total_congr`, `Becoming.total_add`, and `Becoming.le_total_of_mem`.
  - **Track A1-b (`Becoming.OpenComposition` `39` thms / `99` decls):** factored `replace_contract_viable` below `replace_left_viable`, `replace_right_viable`, and `composeList_replace_head_viable`, cutting proof bodies **`-59.6%` (`806 → 326`)** on `left+right` and **`-46.5%` (`1,328 → 710`)** across all 3 callers while preserving every existing downstream signature unchanged.
- **Open:** Track A3 (`RelSpan` minimal 4-primitive calculus) waits on planner review after this landing; human review of edited core modules remains open.

---

## 2. Track B1 — Quantitative Beck–Chevalley Defect to Contractive Viability Tubes (`ObservationalFidelity.lean`, `+298` lines)

- **Headline problem:** Link categorical `Oplax` commutation defects (`chi` failure) quantitatively to probabilistic TV trajectory divergence, macro risk readout error, and closed-loop control collapse.
- **Proved (Lean `v4.30.0-rc2` + Mathlib periphery `#13`, `35` thms / `56` decls, standard axioms `{propext, Classical.choice, Quot.sound}`, `0` `sorryAx`, receipt `20261124T140733.167446Z`):**
  - `optimal_floor_le_rowDefect`: for the identity query on macro states `O`, `massOutside f (L (f u))` (query-blindness mass outside `im f`) is bounded above by one-step `rowDefect f K L u`.
  - `tvDist_pushKernel_dobrushin` & `tvDist_pushKernel_dobrushin_step`: explicit Dobrushin contraction bound `tvDist (f_* K_* p) (L_* lam) ≤ ∑ p_u · rowDefect + α · tvDist (f_* p) lam`.
  - `kernelMetricLaxSim` & `kernel_contraction_tube_via_metricLaxSim`: literal instantiation of `Becoming.AlignmentReals.MetricLaxSim` on finite distributions (`FinDist`), upgrading a macro `Viability.Certificate (guardQ, invQ)` on `pushKernel L` to micro `Viability.Kernel guardS p0` on `pushKernel K` under the explicit premises `0 ≤ α < 1`, uniform Dobrushin bound `≤ α`, uniform `rowDefect ≤ ε` (`ε ≥ 0`), initial macro state `invQ lam0` within `tvDist (f_* p0) lam0 ≤ d0` (`d0 ≥ 0`), and micro-guard implication `guardQ lam ∧ tvDist (f_* p) lam ≤ max d0 (ε / (1 - α)) → guardS p` throughout the tube.
  - `viability_risk_transfer_bound` & `fiber_split_readout_floor`: for `[0, 1]`-bounded macro readout `b` with fiber defect `γ`, expected risk discrepancy `≤ γ + tvDist`; a `{0, 1}` fiber split forces `1/2 ≤ γ`.
  - **Sharpness & negative control:** `sharp_oplax_dobrushin_attainment` hits exact `d_n = ε (1 - α^n) / (1 - α)` for every `n` on a 2-tag `Bool` witness; `feedback_destroys_openloop_contraction` shows two constant open-loop contractive (`α = 0`) kernels become the identity (`α = 1`) under state-dependent switching.
- **Rule 2 boundary & open:** Applies only to finite state/action spaces (`[Fintype]`) with time-homogeneous Markov steps and Dobrushin contraction `α < 1`; continuous spaces and finite-sample estimation error remain open.

---

## 3. Track B2 — Finite-Mode Survival Distinguishability (`SurvivalDistinguishability.lean` `279` lines + Frozen-Q CPU Test)

- **Headline problem:** Determine the exact horizon needed to distinguish two states by finite-word operator evaluation under arbitrary mode sequences, and test whether frozen Q-learning policies follow it once online-update contamination (`stress_test.py.txt:260`) is removed.
- **Proved (Lean `v4.30.0-rc2` + Mathlib periphery `#14`, `13` thms / `21` decls, standard axioms only, receipt `20261124T140857.994394Z`):**
  - `survival_indistinguishable_iff_le_card_pred`: via Krylov subspace stabilization on `(S → ℝ)` for arbitrary real matrices `K : Mode → S → S → ℝ` on finite nonempty `[Fintype S]` `[Nonempty S]`, two states agree on `survVec K w` (interpreted as survival probabilities when rows of `K` are nonnegative substochastic) on *all* finite mode sequences `w : List Mode` iff they agree on all sequences of length **`≤ Fintype.card S - 1`**.
  - `countdown_attains_card_pred`: on `Fin (n + 1)` (`n ≥ 1`), states `0` and `1` agree on every word `< n` and separate at exact length `n = Fintype.card - 1`.
  - `three_state_mode_switch_counterexample`: on `Fin 3`, states `0` and `1` agree (`= 1`) on every constant sequence `[false]*k` and `[true]*k`, yet separate (`1` vs `0`) on the mode switch `[false, true]`.
  - `c2_coupled_survival_separation`: instantiates the bound on `Becoming.OplaxHistory.C2CoupledAlignmentWitness`, separating equal-projection states `finInPhase` and `finAntiPhase` at word length `1 ≤ Fintype.card C2FinState - 1`.
- **Tested (local CPU stdlib, [PREDICTIONS.md](PREDICTIONS.md) & [frozen_q_survival_test.py](frozen_q_survival_test.py) → [RESULTS.md](RESULTS.md)):**
  - Froze Q-table trained on `good_buffered_coordinated` (`|S_alive| = 63` alive states giving a `63 × 63` sub-stochastic alive-state operator, theorem cutoff `|S_alive| - 1 = 62`; `64` total MDP states when counting the excluded collapsed cemetery), removed online episode updates, required `-O`-safe `--pred-sha` verification (using `ValueError` instead of `assert`), and ran a deterministic replay (`seed_base = 21161124`, reproducing the initial `2026-11-24T11:12:36Z` counts) evaluating `idle = (10, 0)` vs `pending = (10, 1)` across `N = 500` held-out seeds/arm (`shortest separating length = 3 ≤ 62`): **`PASS` across all 4 arms and all 4 enforced criteria** (`DR` len-2 control: `500/500` vs `500/500`, gap `+0.0000`; `RRR`: `492/500` vs `500/500`, gap `+0.0160` vs pred `+0.021994`; `DDD`: `178/500` (`0.3560`) vs `429/500` (`0.8580`), gap `+0.5020` vs `+0.550400`; `DRD`: `157/500` (`0.3140`) vs `495/500` (`0.9900`), gap `+0.6760` vs `+0.671900`; `all_wilson_covers_exact=True`, `all_within_normal_95=True`, `all_within_hoeffding_95=True`, `all_separation_criteria=True`). Provenance note: the regenerated analytical specification and replay output land together in Commit B.
- **Rule 2 boundary & open:** Applies to frozen finite stationary policies; non-stationary/online-learning policies violate stationary matrix linearity.

---

## 4. Track B3 & B4 First-Strike Local CPU Probes ([PROBE-REPORT.md](../dual-track-b3-b4-probes-2026-11-24/PROBE-REPORT.md))

- **B3 (Moving Rank-1 Covariance First-Passage, `probe_b3_moving_feature.py`, `seed = 20261124`):**
  - **Finite-grid rolling vs independent-window comparison (`n ∈ {128, 256, 512}`, `b ∈ {-1..1}`):** Regime B (`d = 2`) solves the exact `2 × 2` cone system (`w_v² ≥ 3 w_u² ⇔ S_vv - S_uu ≥ (2/√3) |S_uv|`), and Regime A (`d = n/16 ∈ {8, 16, 32}`) uses a spike-aligned local 2D Rayleigh-Ritz solver seeded on `span(e_0, e_1)` with `λ₁ ≥ max_i S_{ii}` lower-bound guard and residual fallback to full symmetric Jacobi (not a universal global guarantee on arbitrary non-spiked matrices), cross-verified by `1,350` full Jacobi checks (`0` mismatches). Across all `30` finite-grid points, rolling `FP` remained within `≤ 0.007` of rolling `EP` (`0.3733` vs `0.3733` in Regime A `n=512, b=0`; `0.4815` vs `0.4810` in Regime B `n=512, b=0`) while `IndFP` hit `0.960–1.000` (at `b = 0.0`).
  - **Naive 1D `G1D` rejected on finite grid (`G2D` heuristic vs open asymptotic limit):** 1D `G1D` overpredicted Regime A (`0.500` vs `0.373–0.390` at `b = 0.0`), whereas the 2D cone `G2D = P(Z_Δ + μ ≥ (2 / √3) |Z_c|)` (`0.380` in Regime A, `0.463` in Regime B at `b = 0.0`) tracks the tested finite-grid values closely. High-dimensional (`d/n → γ`) asymptotic cone convergence and any Lean B3 theorem remain open.
- **B4 (Exact $C_7^{\boxtimes n}$ Combinatorial Interface Bits, `probe_b4_c7_interface_bits.py`, exact branch-and-bound + partition verifier):**
  - **CONFIRMED across `n ∈ {1, 2, 3}` under both survival `≥ 1/2` formulations (`cc ≤ 2` and `K_3`-free):** exact zero-error `M_n(1)` vs `1/2`-survival `M_n(2)` bits/dim strictly decrease:
    - `n = 1` (`|V| = 7, α = 3`): `M_1(1) = 3` (`1.5850 b/d`) vs `M_1^{cc≤2}(2) = 2` (`1.0000 b/d`), `M_1^{K_3}(2) = 1` (`0.0000 b/d`).
    - `n = 2` (`|V| = 49, α = 10` exact): `M_2(1) = 5` (`1.1610 b/d`) vs `M_2^{cc≤2}(2) = 4` (`1.0000 b/d`, `k = 3` UNSAT in `1,125` nodes), `M_2^{K_3}(2) = 3` (`0.7925 b/d`).
    - `n = 3` (`|V| = 343, α ∈ [29, 35]`): `M_3(1) ∈ [10, 12]` (`[1.1073, 1.1950] b/d`) vs `M_3^{cc≤2}(2) ∈ [5, 8]` (`≤ 1.0000 b/d`), `M_3^{K_3}(2) = 5` exact (`0.7740 b/d`).
  - **Certified asymptotic upper bound & `cc ≤ 2` factor-2 rate equality:** repeating the verified 5-independent-set coloring of $C_7^{\boxtimes 2}$ across coordinate pairs (and a 3-coloring on a leftover odd coordinate) proves $\limsup_{n\to\infty} \frac{1}{n}\log_2 M_n^{cc\le 2}(2) \le \limsup_{n\to\infty} \frac{1}{n}\log_2 M_n(1) \le \frac{1}{2}\log_2 5 \approx 1.1610$ bits/dim (with $\log_2 \Theta(C_7) \ge \frac{1}{2}\log_2 10 \approx 1.6610$). Furthermore, every `cc ≤ 2` class is isolated vertices + disjoint edges (2-colorable), forcing $M_n^{cc\le 2}(2) \le M_n(1) \le 2 M_n^{cc\le 2}(2)$ (`0 ≤ rate gap ≤ 1/n → 0`), so no strict limiting log-rate separation is possible for `cc ≤ 2` (only finite-$n$ / factor-$\le 2$ savings).
- **Open:** Whether `(1/n) log₂ M_n^{K_3-free}(2)` separates strictly below zero-error `(1/n) log₂ M_n(1)` as `n → ∞`, and exact $n = 3$ values for $\alpha(C_7^{\boxtimes 3})$, $M_3(1)$, and $M_3^{cc\le 2}(2)$.
