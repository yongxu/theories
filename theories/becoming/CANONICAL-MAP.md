# The Canonical Map of Becoming

*AI-written synthesis for Ren's cold read (23 November 2026; produced on `main` across Phases 0–3, held loosely under [AGENTS.md](../../AGENTS.md)). This page joins what was proved, tested, and archived in one place; every theorem, premise, failure, and boundary stays anchored to its single-telling record rather than repeated here.*

---

## 1. What This Map Is & Live Repository Ledger

This repository asks how anything forms, persists, adapts, learns, and ends inside one relational unfolding, and how humans and AI can align before what sustains them gives out. Following your 23 November direction and north-star question ([DIRECTION.md](../../_process/DIRECTION.md)), the map stands in three cooperating layers that never blur into one another:

1. **Formal core & bridges (Layer 1):** A **0-axiom** relational premise ledger in Lean (`Grammar` → `Flow` → `Selection`, `ClosedCapture`, `WayUnderARule`) plus newly built connective modules bridging cadences to fine stocks (`Becoming.PacedStock`), open adaptive loops (`Becoming.AdaptiveLoops`), and cross-scale / transformative / flow continuity (`Becoming.MultiScaleViability`, `Becoming.TransformativeViability`, `Becoming.StockFlowBridge`).
2. **Empirical contact & stress tests (Layer 2):** 66 frozen empirical/model tests bound in [BINDINGS.md](results/atlas/BINDINGS.md), 4 graph/time-checked alignment situations in [SITUATIONS.md](results/atlas/SITUATIONS.md), and local CPU adversarial stress tests against stochastic and generalizing learners.
3. **Wisdom, ethics of 生生, and epistemic bounds (Layer 3):** Non-entailment from dynamics to "ought" ([07-SIGNIFICANCE.md](chapters/07-SIGNIFICANCE.md), [08-METHOD.md](chapters/08-METHOD.md)) and an AI-read wisdom crosswalk ([CROSSWALK.md](results/atlas/CROSSWALK.md)), held beside the formal spine as our lens and recognition, never forced into Lean slogans.

| Store / Gate | Live State at Phase 3 | Authority & Where It Lives |
|---|---|---|
| **Formal Register** | `576` registered (`545` `recorded-checked` at `0` core axioms, `20` `reviewed-scoped`, `3` `open`, `7` `superseded`, `1` `withdrawn`) | [RESULTS.md](../../RESULTS.md) |
| **Dynamics Atlas** | `198` dynamics across 8 families (`A:31, B:28, C:21, D:25, E:10, F:24, G:18, H:41`); `1,728` premises; `350` exits (`333` law-shown, `17` argued/open); `97/110` transitions | [ATLAS.md](results/atlas/ATLAS.md), [JOINS.md](results/atlas/JOINS.md) |
| **Test Bindings** | `66/66` tests entered (`57` bearing on atlas dynamics; `9` calibration/no-prediction rows with empty `bears_on`) | [TESTS.md](../../TESTS.md), [BINDINGS.md](results/atlas/BINDINGS.md) |
| **Situations** | `4` checked situations (`1` static RLHF baseline + `3` time/refit/shared-substrate alignment loops) | [SITUATIONS.md](results/atlas/SITUATIONS.md) |
| **Completion Audit** | `K1–K7` all met (`0` findings; receipt `20261123T131636.294555Z`) | [COMPLETION.md](results/completion/COMPLETION.md) |
| **Wisdom Crosswalk** | `1,183` AI-read correspondence entries across `28` groups | [CROSSWALK.md](results/atlas/CROSSWALK.md) |
| **Frozen Public Snapshot** | Snapshot frozen at `186` dynamics / `66` tests pending Phase 3 disposition | [results/map/README.md](results/map/README.md) |

---

## 2. Layer 1 — The 0-Axiom Formal Spine & the New Connective Bridges

Every formal claim in Layer 1 sits in pure Lean (`Nat`/relational core, `0` axioms, `0` `sorry`). Each states theorems of the form *if a system satisfies these explicit structural premises, then this consequence holds* — never that the physical or ML world automatically satisfies them.

### 2.1 The Shared Trunk

At the center stands one relational root ([ONE-PAGE.md](ONE-PAGE.md), [continuation-relative-to-a-class](results/records/continuation-relative-to-a-class.md)): whatever persists is re-made step by step under 缘 (dependencies / conditions) relative to an invariance class. Four structural results trace what happens when a selector reads only part of that unfolding:

- **Blindness beyond couplings** ([selection-through-couplings](results/records/selection-through-couplings.md)): Two histories identical on everything that couples into a selector cannot be told apart by it (`Flow.unselected_beyond_coupling`).
- **Optimization drains the unread** ([what-an-optimum-does-beyond-what-couples-in](results/records/what-an-optimum-does-beyond-what-couples-in.md)): Given *room* (an uncoupled quantity can be sacrificed while holding coupled quantities at least as high), optima on coupled criteria drive unread dependencies down as low as any feasible outcome permits (`Web.optimum_broken_iff`).
- **Closed capture / meta-attractor** ([closed-capture](results/records/closed-capture.md)): When a selection rule — and the rule reading that rule — is updated only from the share it already selects, losses outside the loop accumulate unseen while the loop stays locked (`ClosedCapture.lock_outlives_loss`). Under finite-step one-at-a-time noise, critical-mass locks remain vulnerable to drift, not deterministic erasure.
- **Joint excess under locally sane bounds** ([own-count-misses-joint-excess](results/records/own-count-misses-joint-excess.md), [a-way-of-units-under-a-rule-set-again](results/records/a-way-of-units-under-a-rule-set-again.md)): Multiple actors each drawing within what renewal supplies can together outrun it (`Web.Whole.family_excess_ends`). Under `WayUnderARule`, units needing a level and reproducing under a re-set rule either hit a step that holds without favouring/rule (`Tested`) or reach a first step where no need is met.

Before 23 November's Phase 1 build, proof-term audits (`e2dcc5ce5`) showed this trunk sitting alongside ~136 disconnected leaf modules lacking three bridges: cadence-to-stock coupling, multi-agent loop composition, and cross-scale / transformative / flow translation. Milestones 1A, 1B, and 1C built all three.

### 2.2 Milestone 1A — Coarse Cadences Coupled to Fine Stocks (`Becoming.PacedStock`)

Real policies, oversight reviews, and evaluations update only at coarse reading instants, while underlying stocks drain every fine step. [Becoming.PacedStock](results/records/paced-stock-and-cadence-margin-sandwich.md) links `Pace` / `Sampling` reading schedules to `Frame.blocks` kernels and `RegimeMargin` drawdowns:

- **Intra-span block slack transport:** Under `Becoming.Strict σ`, `ReadAtSpanEnd`, `CoveredByBlocks`, and explicit choice for non-deterministic `Keepable`, macro block viability equates cleanly to fine viability only at span boundaries (`blocks_kernel_iff_fine_kernel`), and intra-span excursions break fine safety unless certified by `stepDrop ≤ blockSlack` (`slack_certifies_fine_kernel`). Concrete witness theorems (`atFive_block_kernel`, `atFive_not_fine_kernel`, `atSix_fine_kernel_by_slack`) prove a block kernel at threshold `5` fails intra-span at `5` and recovers only at `6`.
- **The Pace–Margin Sandwich:** Any rule identification needing `2N - 1 ≤ L` steps over `Pace.StretchFixes` creates an unmistakable viability window: if initial stock falls below what drains across `2N - 1` pre-identification steps, collapse is unavoidable (`unrecoverable_cadence_impossibility`, lifted to two coupled rules in `coupled_two_rule_impossibility`); if initial stock clears `2N - 1` draw plus safe recovery margin under `RegimeMargin.Short`/`Meets`/`Keeps`, the course stabilizes (`pace_margin_feasibility_window`).
- **Explicit boundary:** Assumes exact span-end reads, deterministic or choice-equipped trajectories, and fixed `H₁/H₂` drop bounds; it does not prove equivalence for arbitrary real-valued or stochastic feedback delays without peripheral calibration.

### 2.3 Milestone 1B — Open Adaptive Loops & the Coupled Race (`Becoming.AdaptiveLoops`)

Earlier collective theorems handled fixed dynamics cleanly, yet real aligned agents inspect black-box neighbors and shift policies dynamically. [Becoming.AdaptiveLoops](results/records/coupled-adaptive-loops-and-race.md) turns adaptive closure outward:

- **Black-box assume-guarantee composition:** Modeling each agent as an opaque `OpenLoop` with a `LoopCertificate` (bounded observation lag `maxSilence`, bounded per-step draw, and admissible transitions independent of internal neighbor state), `assume_guarantee_joint_viable` and `assume_guarantee_joint_kernel` prove joint substrate survival above `x_crit` whenever initial buffer clears `x_crit + maxEta * preTotal` and alarm margin covers `(globalMaxLag + 1) * preTotal`.
- **The Coupled Race Theorem (`coupled_race_theorem`):** Five constructed witnesses inside one parametric mechanism prove that alignment survival turns on a four-way quantitative race: (1) warning discovery rate, (2) majority/pool silencing (`WitnessSilenced` vs. epistemic alert), (3) post-turn coordination among drawers (`WitnessUncoordinated` vs. `WitnessGood`), and (4) feedback lag against stock margin (`WitnessTooSlow`, `WitnessNoDiscovery`).
- **Unread joint collapse & endogenous rule switching:** Even if every agent preserves substrate individually, composition fails if their joint draw outruns monotone renewal while unread (`unread_adaptive_joint_collapse`). Conversely, when coupled agents read mutual signals and switch internal rules (`endog_joint_viable`, `endog_bidirectional_adaptation`), safe coordination survives rule turnover instead of relying on dominant-kind extinction.
- **Explicit boundary:** Certifies safety above `x_crit` (not capability optimality inside the safe set) and assumes finite covered sites, monotone `Coupled.Indexed.Rises Drawn.whole`, and deterministic `Nat` arithmetic.

### 2.4 Milestone 1C — Three Missing Connective Pillars

Milestone 1C closed the remaining three structural gaps without inflating the trusted core:

1. **Lax Multi-Scale Abstraction** (`Becoming.MultiScaleViability`, [record](results/records/lax-multi-scale-viability.md)): When exact fibre-lumping (`ProjectedLaws.Commuting`) fails due to micro-phase wobble, `LaxSim` with a `SlackDist` metric tracks one-step projection slip `ε` and excursion slip `η`, transferring macro `Viability.Kernel` down to micro runs (`lax_kernel_of_certificate`, `lax_kernel_of_kernel`) and composing vertically across `TowerSimPack`. An explicit worked model proves `viability_kernel` holds across a two-tier hierarchy even while `not_fibreConsistent₁`, `no_reduced_law₁`, `not_fibreConsistent₁₂`, and `no_reduced_law₁₂` refute exact commuting lumping at every level. *Limit:* discrete `SlackDist` absorption (`α Δ + ε ≤ Δ`), leaving continuous probabilistic metrics (`ε / (1 - α)`) for future peripheral Mathlib work.
2. **Transformative Viability Order** (`Becoming.TransformativeViability`, [record](results/records/transformative-viability-order.md)): Strictly separates constructive transformation (`TransformativeViable`, `TransformsViably`, `TransformsViablyAlong`) — preserving substrate `ReserveGuarded` safety and coarse `MacroAdmits` capability across micro-turnover as obsolete forms retire — from both zero-loss `Widens` (`three_regime_separation`, `finite_gainless_transformsViably`) and unguarded churn (`not_keepsWidening`, `micro_turnover`). *Limit:* takes the capability projection `cap : F → K` and `Safe` predicate as inputs over closed finite `ClosedAt` webs.
3. **Unclamped Stock–Flow Bridge** (`Becoming.StockFlowBridge`, [record](results/records/unclamped-stock-flow-bridge.md)): Resolves the mismatch between `Nat`-truncated stocks and `Flow.BalancesOn` without artificial `min`-clamping: strictly prior to overdraw (`Goes ≤ T + N`, and globally on unending lines), `LineOnAStock` and `WayUnderARule` trajectories embed verbatim into `Flow.BalancesOn` (`line_balancesOn_of_within`, `way_balancesOn_of_within`), importing finite-horizon no-return drawdown bounds (`line_never_returns_below_within`, `way_never_returns_below_within`) and linking directly to `RegimeMargin.Coupled.Indexed` (`line_coupled_indexed_correspondence`, `way_coupled_indexed_correspondence`). *Limit:* stops at the overdraw step where `Nat` subtraction truncates, and leaves `WayUnderARule`'s `ends_all` Stage 2 refactoring open for your decision.

---

## 3. Layer 2 — Empirical Contact: 66/66 Bindings, 4 Situations & CPU Stress Tests

A Lean theorem only says what follows *if* a system instantiates its premises. Layer 2 tests where those identifications hold and where real systems break them — putting failures first.

### 3.1 The 66 Bound Tests (Failures & Broken Bridges First)

All `66` tests in [TESTS.md](../../TESTS.md) now appear in [BINDINGS.md](results/atlas/BINDINGS.md) (`57` bound to atlas dynamics; `9` calibration/no-prediction rows marked with empty `bears_on`). Per our honesty standard, **verdict counts** reflect pre-registered frozen rules:

- **4 Failed (`MQ3`, `MQ7`, `VD1`, `UE31b`):**
  - `UE31b` (flour beetle life stages) **marked `the law`**: T2's former wording (*level, recent giving, and one lag suffices as far as anything measured does*) failed directly when pupae and adults formed a smaller sufficient variable set.
  - `MQ3` (113 assessed fish stocks, `0/4` predictions) and `VD1` (valuer agreement, every frozen rule failed) **marked `the binding`**.
  - `MQ7` (21 unread fish stocks, `0/1` testable passed) **marked `the measurement`**.
- **20 Mixed (partial passes or intact Lean law / broken identification bridge):**
  - `LA2` (self-rewarding trained judge): every frozen verdict passed (`5/5` seeds, with an exact tie on `L3`/`L4`), yet **the bridge `H1-LA2` failed**: inserting one loss-note among nine readers flipped the judge 50/50 choices vs. 60/60 without it, showing the trained judge did not act as a kind-counted `ClosedCapture` pool (`02 §T7`).
  - `IN1 (round 2)` (GovSim-style multi-agent LLM fishers with 1 round of pre-move talk): `DIR_UNSEEN_TALK` kept `0/10` beds for both models (confirming `Flow.unselected_beyond_pool`), while on seen beds **`gpt-5.4-mini` passed R1–R4 (`8/10` seasons vs. `3/10` under `COMM`) whereas `gpt-4.1-mini` collapsed (`1/10`)** by misreading joint catch (`Stationary.model_error`). Under the joint frozen rule, R1/R3/R4 failed overall (`mixed`).
  - `EM1` (generalizing RL agents): contrasts `X1`, `X2`, `X4` and bridge `H3` failed where function-approximation leakage blurred the tabular coupling boundary. Similarly `CG1`–`CG3c`, `LA1`, `LA3`, `MQ1`–`MQ6`, `VD2`, and `LCA` show exactly where tabular/equilibrium approximations diverge from fitted learners.
- **Remaining 42 tests:** `2` refused pre-scoring (`T1N`, `T1R` — no need measured), `1` decided nothing (`UE31`), `2` partly passed (`FC1`, `LA4 Stage A`), `3` not rejected (`EW2`, `EW3`, `EW4`), `5` passed (`UE32`, `LA1b`, `LA1c`, `SE1`, `TR7A`), `2` registered rule, `2` no verdict, `11` frozen not run, `3` held, `1` dropped, and `10` with no prediction.

### 3.2 Time-Indexed & Shared-Substrate Situation Checking

Phase 2 upgraded `tools/research/atlas.py` from static graphs to finite-horizon time/refit/substrate unrolling, catching deadline contradictions automatically ([SITUATIONS.md](results/atlas/SITUATIONS.md)):

| Situation | Horizon & Mechanism | Critical Check Finding |
|---|---|---|
| `a-reward-model-pipeline` | Static 1-pass baseline RLHF | `correctness-unchecked` and post-transcript `users`/`third-parties` sit beyond rater and RM closure |
| `iterated-rlhf-rlaif-refit-loop` | `t = 0..6`, periodic RM refit at `[3, 6]` | Shared `rater-capacity` (`initial=4, renewal=2, draw=3`) **exhausts at `t=4`** before refit oversight reads; triggers `readintime-deadline` contradiction |
| `eval-benchmark-gaming` | `t = 0..5`, proxy benchmark vs. held-out safety | Proxy selection meets `Web.SelectsThrough` while leaving real deployment hazards beyond evaluator closure |
| `multi-agent-deployment-loop` | `t = 0..6`, fleet cadence `[2, 4, 6]` | `shared-oversight-substrate` **exhausts at `t=4`** while lagged telemetry arrives at `t=5`, outrunning renewal |

*Standing note:* Situations are `model` / `reading` consistency checks of our own coupling descriptions, never external evidence.

### 3.3 Phase 2 Local CPU Stress Tests (Noisy & Generalizing Learners)

Under Rule 7 (100% local CPU, zero paid API calls), we tested Milestones 1A and 1B against discrete noise, inertia, multi-agent bandits, tabular Q-learning, and linear function approximation ([NOTE.md](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/p2-alignment-stress-test-2026-11-23/NOTE.md)):

- **1A Pace–Margin Sandwich under perturbations (`b_imp = 18, b_feas = 27`):**
  - *Exact model:* `21/21` deterministic grid checks match theorem bounds cleanly (`x0 = 15 < 18` collapses `0.0` survival; `x0 = 27` survives `1.0` unless perturbed).
  - *Noisy alarm delay / spikes / policy inertia at boundary `x0 = 27`:* Gaussian alarm delay degrades survival smoothly `1.0 (σ=0) → 0.99 (1.5) → 0.875 (3.0) → 0.81 (5.0) → 0.68 (8.0)`; random `+4` demand spikes drop survival to `0.835` at `p = 0.30`; slow rule inertia (`α = 0.125`) collapses `x0 = 27` (`final_x = 0.0`) completely while extra initial headroom (`x0 = 39`) restores survival (`3.0` final_x under inertia, `1.0` under spikes, `0.915` at `σ = 8.0`). Jitter below `b_imp` (`x0 = 15`) barely leaks (`0.025` at `jitter = 1.0`).
- **1B AdaptiveLoops & Generalization Leakage (`40` seeds each, `x_crit = 5`):**
  - *Unread adaptive bandits:* Collapse rate is `1.0` at renewal `R = 2` across all `ε ∈ [0.05, 0.90]` (`0.975 / 1.0 / 0.575` at `R = 3`).
  - *CoupledRace Q-learning:* `good_buffered_coordinated` yields `0.0` eval collapse (`mean min_x = 8.25`); `too_slow_lag3_unbuffered` and `uncoordinated_post_turn` yield `1.0` collapse (`min_x = 0.0`); `silenced_pool_q05` yields `0.25` collapse (`min_x = 5.9`).
  - *Linear function approximation leakage:* Introducing feature coupling `ρ` between safe and warning regimes breaks tabular guarantees: collapse reaches `1.0` at `warn_onset = 10` (`ρ = 0.0..0.80`) and remains **`0.975` (`mean final_x = 0.35`) even at generous `warn_onset = 22, ρ = 0.8`** due to single-episode gradient hysteresis.

**Concrete takeaway:** Discrete `Nat` theorem bounds sharply diagnose exact failure floors and race bottlenecks, *and* gradient generalization / alarm inertia eat into nominal safety margins (`b_feas` alone is brittle without real learner headroom).

---

## 4. Layer 3 — Wisdom, Ethics of 生生, Limits & Decisions Waiting on Ren

### 4.1 Ethics Beside Dynamics (Not Forced From Them)

Nothing proved in Lean prescribes a final end ([07-SIGNIFICANCE.md](chapters/07-SIGNIFICANCE.md), [08-METHOD.md](chapters/08-METHOD.md)):

- **Non-entailment:** `ReadsOnlyDynamics.not_entails` shows purely dynamical premises entail no evaluative verdict. Dynamics fix what couples, closes, drains, or remains reachable — never what one *should* want.
- **How continuation, self-concern, and widening sit:** The unrestricted continuation condition (`«续无外»`) varies with the net (holding on endless descent, failing where decoupled lines share no condition). On a finite listing, widening — keeping more paths alive without needless exclusion — coincides precisely with what every strictly positive additive weighting ranks higher (`Weighting.widens_iff_every_positive`). Self-concern (`increasingInOwn`) reproduces `Comparison` (C) only *given* de-se continuation and decided admission as explicit hypotheses.
- **AI alignment framing:** Rather than programming fixed values (which fail whenever they miss coupled substrates or lose against uncoordinated loops), the ethics of 生生 asks whether an evaluation arrangement keeps what sustains humans and AI *making a difference early enough* before crossing irreversible drawdowns, without letting reward-shaping become the target.

### 4.2 Wisdom Crosswalk (`1,183` Entries)

[CROSSWALK.md](results/atlas/CROSSWALK.md) maps `1,183` AI-read correspondence entries across `28` groups (Daoist, Confucian/Yizhuan, Buddhist, systems/cybernetics, political economy, ML/alignment traditions): `3` `carried`, `488` `carried-in-part`, `189` `changed`, `22` `history-only`, `105` `not-carried`, and `376` `fresh-reading`; relationally `338` `agreement`, `371` `scope`, `325` `divergence`, and `25` `contrary-reading`. **Warning:** Every entry is an AI reading, not scholarly or Ren-verified consensus; structural matches do not validate metaphysics, and divergences mark where traditions name phenomena our Lean core still omits.

### 4.3 What Lean Does NOT Establish

1. **No automatic real-world recognition (Rule 2):** Checking a theorem in Lean never proves a real lab, judge, market, or LLM meets its hypotheses (as `LA2`, `MQ3`, `EM1`, and Phase 2 linear-FA leakage confirm).
2. **Stochastic & continuous learners stay in the periphery:** Current Phase 1 bridges live in discrete `Nat` arithmetic; continuous Lipschitz/martingale bounds belong in the Mathlib periphery where future experiments calibrate them.
3. **Chapter prose lags 15 Nov builds:** Systematic chapter updates (`01`–`08`) were held until this canonical map settled so no prose was rewritten twice.

### 4.4 Open Decisions Waiting on Ren

Before expanding formal scope, opening external API runs, or rewriting chapters, five items await your word (matching [_process/HANDOVER.md](../../_process/HANDOVER.md) and Phases 0–3):

1. **Aim wording in [AGENTS.md](../../AGENTS.md):** Row DJ's draft retiring *"two ways"* (and row GR's filed sentence) waits on your approval before touching `AGENTS.md` (meanwhile [_process/DIRECTION.md](../../_process/DIRECTION.md) already carries your 23 November 3-layer framing).
2. **Reading `WayUnderARule` with need at 27 (`Tested` vs. `Turned`):** Confirm whether halting when the counted unit itself goes without captures what you mean by *turning in time*, or counts purely as ecological exhaustion.
3. **Formal cleanup queue:** Stage 2 of `WayUnderARule` (calling two `LineOnAStock` laws from it / whether `StockFlowBridge` absorbs or leaves `ends_all`) and the 6 scratch proofs held outside the core package.
4. **Repository compaction & frozen views:** Whether to finalize Phase 0 archive splits on `DIRECTION.md` / `BECOMING-WORKBOARD.md` (currently shrunk to compact fronts + archives on `main`) and whether to unfreeze or retire `theories/becoming/results/map/`.
5. **Chapter synchronization & external tests (Rule 7):** When you are ready to sync `theories/becoming/chapters/` (`01`–`08`) to `CANONICAL-MAP.md` and whether any held/blocked empirical runs (`LA4 Stage B`, `T2O`, `T1B`, real-learner stress calibration) should eventually leave local Mac execution.
