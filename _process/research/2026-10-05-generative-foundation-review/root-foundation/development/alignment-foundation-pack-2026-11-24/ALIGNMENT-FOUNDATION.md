# Becoming as a Structural Foundation for AI Alignment

*AI-written standalone entry pack (24 November 2026). No human has reviewed this document yet. Nothing here pushes, licenses, reaches out, or initiates metered runs ([AGENTS.md](../../../../../../AGENTS.md) Rule 7).*

> **Boundary first — why this does NOT claim `"THE alignment"`:** This work does not claim a unique, complete, or universal solution to AI alignment. As recorded in [Ren's 24 November aim](../../../../../../sources/15-codex-theory-conversations/2026-11-24-aim-three-honest-alignment-claims.md), a verified Lean core proves structural laws *relative to explicit model premises*. Matching a real training run or socio-technical institution to those premises stays fallible ([Rule 2](../../../../../../AGENTS.md#what-to-work-on)), dynamics theorems alone never entail an unrestricted "ought" (`not_entails`), and empirical stress tests break formal nominal margins under gradient noise and aliasing.

What the formal work establishes at completion is a triad of checkable claims:

1. **A machine-checked structural foundation (`0`-axiom core + Mathlib periphery)** explaining why selection goes blind, drains unread substrates, locks into self-referential capture, fails under cadence lag or unserialized concurrency, and splits across observation fibers — paired with hypothesis-dropping countermodels (`SharpnessSuite`).
2. **A checkable 5-test diagnostic grammar (`guarded-alignment-runtime`)** that evaluates declarative alignment proposals (`RLHF`, `RLAIF`, `Constitutional AI`, `scalable oversight`, `multi-agent governance`, `guarded open alignment`) using exact rational / integer arithmetic.
3. **A grounded open-architecture alternative to fixed-value alignment** paired with failure-first empirical contact (`TESTS.md`, `neural-alignment-stress-lab`) and explicit normative separation (`not_entails`).

---

## 1. Machine-Checked Structural Foundation (`0`-Axiom Core + Periphery)

From [`becoming-verification.json`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json) (`leanprover/lean4:v4.29.1`, retained receipt `becoming-checks/20261124T112343.843972Z`), the active `Becoming` spine closure compiles **`435` modules** (`414` core, `3` foundation, `11` instances, `7` applications), **`30,709` declarations**, and **`21,802` theorems** with **`0` axioms** (`0` nonempty axiom dependencies in the core closure). Real-valued, probabilistic, and Lipschitz-contractive extensions live strictly downstream in [`periphery-manifest.json`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/periphery-manifest.json) (`13` Mathlib periphery checkers pinned to Mathlib `ea11ccc0c5c7c4c562742e918fe2e0b2814a58aa`), isolated from the `0`-axiom core and audited separately by [`check_periphery.py`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/check_periphery.py).

| Failure Mechanism or Safeguard | Verified Lean Module & Declarations | Core Hypothesis / Sharpness Witness |
|---|---|---|
| Selection blindness beyond couplings | [`Selection.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Selection.lean) (`Flow.unselected_beyond_coupling`, `Flow.unselected_beyond_coupling_all`) | Courses identical on coupled observables are selected alike regardless of unread depletion. |
| Optimum drain beyond couplings | [`Optimum.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Optimum.lean) (`Web.optimum_broken_iff`) | Where room exists, optima of an order rising with coupled traits minimize uncoupled substrates. |
| Closed self-refit capture | [`ClosedCapture.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ClosedCapture.lean) (`ClosedCapture.lock_outlives_loss`) | Rules updated solely from the favored share remain locked past arbitrarily large unread losses. |
| Cadence aliasing & lag-margin deadlines | [`PacedStock.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PacedStock.lean) (`slack_certifies_fine_kernel`, `pace_margin_feasibility_window`, `unrecoverable_cadence_impossibility`) | Needs lag `L >= 2*N - 1` and initial reserve `x0 >= H2 + y2 + H1*(L + 1)`; dropping below `(H2 + y2) + (H1 - Y)*(2*N - 1)` when `N >= 2`, `Y < H1`, `H1 <= H2 + y2` makes late correction impossible. |
| Concurrent shared-reserve races & serialization | [`AdaptiveLoops.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/AdaptiveLoops.lean) (`coupled_race_theorem`, `unread_adaptive_joint_collapse`, `assume_guarantee_joint_viable`, `assume_guarantee_joint_kernel`), [`PolyComposition.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PolyComposition.lean) (`ConcurrentSerialWitness.concurrent_serial_dichotomy`) | Individually admissible policies still exhaust shared reserves concurrently unless gated serially with joint phase awareness. |
| Open-interface healing & reciprocal gating | [`OpenComposition.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OpenComposition.lean) (`compose_close_interchange`, `widen_interface_heals_blindness`), [`EndogenousOrder.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/EndogenousOrder.lean) (`uncoupled_blindness_firewall`, `course_menu_widening_nash_obstruction`, `reciprocal_gate_restores_viable_nash`) | Widening open interfaces restores observability; menu expansion without reciprocal gating can worsen Nash equilibrium reserve viability. |
| Oplax coarse-graining, `Zero-TV`, & Goodhart | [`OplaxHistory.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OplaxHistory.lean) (`causalGoodhart_chi_non_surjective`, `FiberViabilitySplit`, `fiberSplit_refutes_macro_viability_soundness`, `span_step_grammar_lumping`), [`CausalAbstraction.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/CausalAbstraction.lean) (`CausalGoodhartWitness`), [`DoubleKernel.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/DoubleKernel.lean) (`GuardedExpr`, `GuardedProof`, `guarded_oplax_sound`) | Macro `TV = 0` or Beck–Chevalley collapse permits stealth viability failure inside shared fibers; `GuardedProof` blocks uncertified inversion. |
| Real / probabilistic fidelity & hysteresis | [`ObservationalFidelity.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/observational-fidelity/ObservationalFidelity.lean) (`optimal_query_tv_floor`, `zero_tv_does_not_prevent_fiber_viability_split`, `per_query_not_implies_joint_marginal`, `joint_marginal_not_implies_joint_dist`, `three_regime_error_contrast`), [`AlignmentReals.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/alignment-reals/AlignmentReals.lean) (`inertia_error_closed_form`, `linear_fa_leakage_hysteresis`), [`BecomingReals.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming-reals/BecomingReals.lean) (`iterVar_eq_metricSlack`, `linear_blanket_vs_fa_leakage_and_damped_runaway`) | Exact per-query realizability does not imply simultaneous or joint fidelity; contractive feedback bounds steady-state drift where open-loop bounds grow linearly. |
| End-to-end spine, sharpness, & non-entailment | [`AlignmentSpine.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/AlignmentSpine.lean) (`AlignmentDichotomy`, `alignmentSpine_not_entails`, `SharpnessSuite.master_sharpness_suite_complete`, `alignment_spine_end_to_end`), [`MasterSpine.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/MasterSpine.lean) (`masterSpine_grammar_lifts`, `masterSpine_cannot_entail_unrestricted`, `whole_becoming_master_theorem`, `witness_holds_master_theorem`), [`ScopeDynamics.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ScopeDynamics.lean) (`scopeLaw_cannot_entail_unrestricted`) | Joins grammar-level continuation to alignment dichotomy, concrete hypothesis-dropping countermodels (`SharpnessSuite`), and formal dynamics-to-normative independence (`not_entails`). |

### Prior Literature Placement (Honest Novelty vs. Debts)

Per the self-audit in [method — known results](../../../../../../theories/becoming/chapters/08-METHOD.md#known-results) and [known-results debts](../kd-known-results-debts/DEBTS.md), individual mathematical pieces are **restated, specialized, or near-definitional** relative to established literatures:

- **Proxy misspecification & overoptimization:** Zhuang & Hadfield-Menell (2020) Theorem 1 (finite `Nat` optima vs. their continuous limits and sensitivities).
- **Deceptive incentives & corrupted channels:** Hubinger et al. (2019), Everitt et al. (2017, 2021), Carey (2018), Soares et al. (2015), and Hadfield-Menell et al. (2017) on corrigibility and off-switch waiting.
- **Capture, lock-in, & commons races:** Arthur (1989), Stigler (1971), Hardin (1968), Gordon (1954) / Dasgupta & Heal (1979).

What is genuinely contributed here is the **machine-checked `0`-axiom premise-and-sharpness ledger** joining conservation/selection, interface cadence, oplax coarse-graining, concurrent races, and hypothesis-dropping countermodels (`SharpnessSuite`) under one proof-checked interface — while continuous stochastic asymptotics, non-convex neural optimization dynamics, and infinite-horizon folk equilibria remain outside the core theorems ([`DEBTS.md`](../kd-known-results-debts/DEBTS.md), [`OPEN-QUESTIONS.md`](../../../../../../OPEN-QUESTIONS.md)).

---

## 2. Checkable 5-Test Diagnostic Grammar (`guarded-alignment-runtime`)

[`experiments/guarded-alignment-runtime/`](../../../../../../experiments/guarded-alignment-runtime/README.md) implements a zero-dependency Python stdlib evaluator using exact `int` and `fractions.Fraction` arithmetic ([`proposal_audit.py`](../../../../../../experiments/guarded-alignment-runtime/guarded_alignment/proposal_audit.py)). Any `"alignment_proposal"` JSON spec is audited against five structural failure checks, emitting `GUARDED` (never claiming unconstrained `PROVED` for real-world deployment) or `OBSTRUCTED` with concrete countermodel witnesses:

| Structural Test (`proposal_audit.py`) | Primary Lean Correspondence | Obstruction Caught | Example Verdict in Runtime |
|---|---|---|---|
| `coupling_closure` (`check_coupling_closure`) | `Selection.Flow.unselected_beyond_coupling`, `OpenComposition.widen_interface_heals_blindness` | Unread sustaining substrate or closed interface ignoring future disturbances | `OBSTRUCTED` on `proposal_rlhf_one_pass`, `proposal_rlaif_self_refit`, `proposal_constitutional_ai_closed` |
| `self_refit_lock` (`check_self_refit_lock`) | `ClosedCapture.ClosedCapture.lock_outlives_loss`, `MasterSpine.whole_becoming_master_theorem` | Re-fitting solely from favored share without active external reset, or making shaping the target | `OBSTRUCTED` on `proposal_rlhf_one_pass`, `proposal_rlaif_self_refit` (`shaping_becomes_target=True`), `proposal_constitutional_ai_closed` |
| `zero_tv_fiber_split` (`check_proposal_fiber_split`) | `OplaxHistory.FiberViabilitySplit`, `ObservationalFidelity.zero_tv_does_not_prevent_fiber_viability_split` | Macro projection assigns `TV = 0` to viable vs. collapsing fibers, or coarsening hides blindness | `OBSTRUCTED` on `proposal_rlhf_one_pass`, `proposal_rlaif_self_refit`, `proposal_constitutional_ai_closed` (concealed gap `1/2`) |
| `pace_margin_deadline` (`check_pace_margin_deadline`) | `PacedStock.slack_certifies_fine_kernel`, `pace_margin_feasibility_window`, `unrecoverable_cadence_impossibility` | Lag violates `2*N - 1 <= L`, falls under impossibility bound `(H2 + y2) + (H1 - Y)*(2*N - 1)`, or lacks initial-block slack | **Isolated `OBSTRUCTED`** on `proposal_scalable_oversight_lagged` (`x0=10 < 25/2`) |
| `concurrent_reserve` (`check_concurrent_reserve`) | `AdaptiveLoops.coupled_race_theorem`, `PolyComposition.ConcurrentSerialWitness.concurrent_serial_dichotomy`, `EndogenousOrder.reciprocal_gate_restores_viable_nash` | Individually safe draws collide concurrently and collapse `C2` phase observability (`2 -> 1`) | **Isolated `OBSTRUCTED`** on `proposal_multi_agent_governance_unserialized` (breach step `3`) |
| Combined open guarded loop | All 5 seams together | Requires open read interface + external reset without target capture + fiber separation + cadence headroom + reciprocal serialized gating | **`GUARDED`** on `proposal_guarded_open_alignment` (`5/5` guarded) |

Reproduce locally from `experiments/guarded-alignment-runtime/`:

```bash
PYTHONDONTWRITEBYTECODE=1 python3 -B -m unittest discover -s tests -v
PYTHONDONTWRITEBYTECODE=1 python3 -B -m guarded_alignment run all
PYTHONDONTWRITEBYTECODE=1 python3 -B -m guarded_alignment dump-example proposal_guarded_open_alignment > /tmp/open_proposal.json
PYTHONDONTWRITEBYTECODE=1 python3 -B -m guarded_alignment check /tmp/open_proposal.json --json
```

---

## 3. Grounded Architectural Alternative & Failure-First Honesty

Rather than freezing one static utility function or reward proxy, this map frames alignment as **preserving an open, cadence-feasible, reciprocally gated architecture** so whatever sustains humans and AI keeps making a difference early enough across scales — while preventing selection-shaping mechanisms from becoming the optimization target.

### Where Empirical & Neural Stress Tests Break (Reported First)

1. **Frozen historical tests (`TESTS.md`, [`08-METHOD.md#theses`](../../../../../../theories/becoming/chapters/08-METHOD.md#theses)):**
   - `MQ3`: **0 of 4** frozen regime-margin predictions passed across `113` assessed fish stocks.
   - `EM1`: Contrasts `X1`, `X2`, `X4`, condition `E1`, and locked bridge `H3` failed for generalizing tabular/linear learners.
   - `IN1`: Round 2 mixed (`R2` passed; `R1`, `R3`, `R4` failed; zero conditions preserved an untold dependent).
   - `UE31b`: Earlier wording of `T2` ("as far as anything measured does") was **refuted** on flour-beetle cultures by the fewer-variable pupae-and-adults state class (`0.83` vs. `0.004` residual variance removed).
   - `LA2`: An LLM judge trained in-context met a `T7`-forbidden capture reversal against the pre-drift-clause wording when disfavored notes shifted the rule at reading time.
2. **Local CPU neural stress lab ([`experiments/neural-alignment-stress-lab/RESULTS.md`](../../../../../../experiments/neural-alignment-stress-lab/RESULTS.md), `20` seeds, `24.729s` stdlib CPU):**
   - `B1` (`PacedReserveEnv`): `reinforce_mlp` collapses `0.55–0.90` at the exact tabular threshold `x0 = 27` (`b_feas`) and **still collapses `0.40–0.45`** even with `+12` calibrated reserve headroom (`x0 = 39`), driven by hidden cosine similarity up to `0.930` and switch delay up to `30.8` steps (`tabular_q = 0.00`).
   - `B2` (`CoupledPhaseGoodhartEnv`): Adding a passive macro-TV audit pushes `self_rewarding_tv_audited` into **`0.902` stealth extraction** (`pooled macro TV = 0.0164` vs. baseline `0.0182`, mean judge score `0.881`, **`1.00` collapse** across `20/20` seeds), confirming `CausalGoodhartWitness` and `zero_tv_does_not_prevent_fiber_viability_split`.
   - `B3` (`SharedCommonsEnv`): Locally safe agents (`solo = 0.00` collapse) break in `2.45` steps (`1.00` collapse) when unserialized (`unserialized_concurrent_K4`) and in `2.40` steps under `stale_snapshot_serialized`; live post-commit `epoch_reserve_serialized_K4` drops collapse to `0.00`.
   - `B4` (**Four explicit failures of `full_guarded`**, kept upfront even though `full_guarded` rescues `nominal_coupled` and `moderate_lag2_stealth` to `0.00`):
     - `FAIL_correlated_pool_drift` (`drift=0.96, alias=0.78, lag=3`): **`0.50` collapse** (judges converge to unanimous false consensus; disagreement trigger drops to `0.9`).
     - `FAIL_long_lag` (`lag=8`): **`0.45` collapse** (margin/fiber alerts fire too late).
     - `FAIL_high_lr` (`lr=4.0`): **`0.25` collapse** (`70%` at `lr=8.0`; raw logit jumps saturate bounded runtime guards).
     - `FAIL_severe_aliasing` (`rho=0.95, alias=0.95`): **`0.25` collapse** (`fiber_triggers` drops `7.6 -> 1.8`).

### Four Explicit Limits (`not_entails`, Rule 2, & Local Scope)

1. **Normative firewall (`not_entails`):** `ScopeDynamics.scopeLaw_cannot_entail_unrestricted`, `AlignmentSpine.alignmentSpine_not_entails`, and `MasterSpine.masterSpine_cannot_entail_unrestricted` prove inside Lean that pure dynamical, viability, or scope closure laws cannot derive an unrestricted ranking over all valuations without an explicit order/value hypothesis.
2. **Model-to-world gap (Rule 2):** Checking finite-state Lean axioms or `Fraction` runtime specs never certifies that a physical frontier system obeys bounded step drops, exact Markov kernels, or stationary couplings.
3. **Continuous & infinite-horizon debts:** Quantitative asymptotics, continuous stochastic convergence, and multi-agent folk equilibria remain open ([`DEBTS.md`](../kd-known-results-debts/DEBTS.md), [`OPEN-QUESTIONS.md`](../../../../../../OPEN-QUESTIONS.md)).
4. **Local-only discipline (Rule 7):** Verification and stress suites remain local on Mac until Ren authorizes release, external communication, or licensing.
