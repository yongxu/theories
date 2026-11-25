# Independent 1-Hour External Audit Guide (Becoming & Alignment Pack)

[Home](../../README.md) · [中文](HUMAN-AUDIT-GUIDE.zh.md) · **Human audit guide** · [Alignment foundation](ALIGNMENT-FOUNDATION.md) · [Canonical map](CANONICAL-MAP.md) · [One page](ONE-PAGE.md) · [Results](../../RESULTS.md) · [Tests](../../TESTS.md) · [Reviewers](review/README.md)

*AI-written verification checklist (promoted from `_process/` 24 November 2026; synced to live receipts). No human has reviewed this guide yet. Designed so an external Lean / AI-alignment researcher can audit the claims in [ALIGNMENT-FOUNDATION.md](ALIGNMENT-FOUNDATION.md) without trusting any summary prose.*

Total expected wall time: **~60 minutes** on a clean checkout with Python 3.11+ (plus Lean `v4.29.1` if optionally rebuilding the core, and Lean `v4.30.0-rc2` with pinned Mathlib `ea11ccc0c5c7c4c562742e918fe2e0b2814a58aa` if optionally rebuilding Mathlib periphery modules in Step 2). Run Python verification commands with `-B` / `PYTHONDONTWRITEBYTECODE=1` to keep the working tree free of bytecode caches.

---

## Step 1 (~10 min) — Core `0`-Axiom Receipt Audit (Primary)

1. Inspect the retained core receipt [`becoming-verification.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json) directly rather than trusting markdown summaries, and verify all `31,228` declarations' `axiom_dependencies` in Python:

```bash
python3 -B -c "
import json
from pathlib import Path
v = json.loads(Path('experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json').read_text())
bad = [(m['module'], k, d) for m in v['modules'] for k, d in m['axiom_dependencies'].items() if d]
print('status=', v['status'], 'toolchain=', v['toolchain'], 'retained_run=', v['retained_run'])
print('closure=', len(v['core_closure']), 'core=', len(v['core_modules']),
      'decls=', sum(len(m['declarations']) for m in v['modules']),
      'thms=', sum(m['theorems'] for m in v['modules']),
      'nonempty_axiom_deps=', len(bad))
assert v['status'] == 'passed' and not bad
"
```

   - Confirm `"status": "passed"`, `"toolchain": "leanprover/lean4:v4.29.1"`, `"retained_run": "becoming-checks/20261124T233040.232087Z"`, `core_closure` size (`439`, `418` core modules), declaration count (`31,228`), theorem count (`22,087`), and `nonempty_axiom_deps= 0`.
   - Cross-check the live register summary in [`RESULTS.md`](../../RESULTS.md): **`600` registered results** (`569` `recorded-checked`, `20` `reviewed-scoped`, `3` `open`, `7` `superseded`, `1` `withdrawn`).

2. **Optional (slow full rebuild, outside the 60-minute window if uncached):** re-run the core checker through the worktree lock wrapper. Note that [`check_becoming.py`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/check_becoming.py) compiles all `439` modules, takes **no CLI flags**, and writes a fresh timestamped retained run under `becoming-checks/`; inspect or clean only what you create if keeping a clean tree:

```bash
make lean-check
```

3. For fast scratch isolation of individual edited `.lean` files without full receipt writes, use [`scratch_build.py`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/scratch_build.py):

```bash
python3 -B experiments/integrated-correction/general-framework/generative-basis/lean/becoming/scratch_build.py <scratch_dir> Becoming.PacedStock
```

---

## Step 2 (~10 min) — Periphery Isolation (`16` Mathlib + `2` Non-Mathlib) & Standalone Tracks

1. Verify that all **`18`** periphery checkers (**`16` Mathlib `v4.30.0-rc2` modules** including Wave 1's shared `FiniteProbKrylov` leaf, `FiberLumpable` B1–B2 join, `QuantitativeTransfer` Parts 1–9, and Wave 4's `InterfaceBits` and `MovingFeatureCone`, plus **`2` non-Mathlib periphery modules** — `Becoming.FallibleInquiry` and `RenewalBridge` — on `v4.29.1`) stay separated from the `0`-axiom core and pass SHA-256 freshness (`0` stale) via [`check_periphery.py`](../../experiments/integrated-correction/general-framework/generative-basis/lean/check_periphery.py) and [`periphery-manifest.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/periphery-manifest.json):

```bash
python3 -B experiments/integrated-correction/general-framework/generative-basis/lean/check_periphery.py --check-stale
```

2. Optionally re-verify the six primary alignment periphery checkers directly (requires Lean `v4.30.0-rc2` + pinned Mathlib `ea11ccc0c5c7c4c562742e918fe2e0b2814a58aa`; `--module` expects exact PascalCase `module` names from `periphery-manifest.json`):

```bash
python3 -B experiments/integrated-correction/general-framework/generative-basis/lean/check_periphery.py \
  --module FiniteProbKrylov --module ObservationalFidelity --module SurvivalDistinguishability \
  --module QuantitativeTransfer --module AlignmentReals --module BecomingReals
```

3. Also inspect the standalone tracks — separating **`0`-axiom standalone tracks (`BecomingSpec` `26` targets, `EncounterEntry` `35` theorems, held-out `RelSpanEncounterAdapter` `7` theorems / `13` declarations [`0` source/transitive axioms, unused `ExitOcc.mk.injEq` `[propext]`])** from **Mathlib-backed standalone checks (`ConsequenceDuality` + `DualityBridges` + `DualityLifting` + `TrackBKrylovBridge`, using standard Mathlib axioms `Classical.choice`, `Quot.sound`, `propext`)** — plus [`experiments/evidence-replay/`](../../experiments/evidence-replay/README.md) (`16/16` tests, adding `R5` middle-band trichotomy/monotonicity, `R6` closed-loop split/weighted tags, and the 8-slot endogenous silent-drift self-detection benchmark):
   - [`becoming-spec-verification.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming-spec-check/becoming-spec-verification.json) (`0`-axiom dual-toolchain `26` targets across `v4.29.1` & `v4.30.0-rc2`, `4/4` tamper self-tests rejected)
   - [`encounter-entry-verification.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/encounter-entry/encounter-entry-verification.json) (`0`-axiom `Init`-only open entry, `35` theorems, `4/4` negative self-tests rejected) and [`relspan-encounter-verification.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/encounter-entry/relspan-encounter-verification.json) (`0` source/transitive axioms, `7` theorems, `RelSpan.mapTrace` + `EncounterEntry` held-out negative adapter)
   - [`consequence-duality-verification.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/consequence-duality-verification.json), [`duality-bridges-verification.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/duality-bridges-verification.json), [`duality-lifting-verification.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/duality-lifting-verification.json), and [`trackb-krylov-bridge-verification.json`](../../experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/trackb-krylov-bridge-verification.json) (Mathlib-backed standalone checks)

---

## Step 3 (~15 min) — Read Entry Modules for Vacuity & Sharpness

Bypass all summaries and inspect statement hypotheses directly in Lean:

1. **Unread substrate blindness & optimum drain:** [`Selection.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Selection.lean) (`Becoming.Flow.unselected_beyond_coupling`, `Becoming.Flow.unselected_beyond_coupling_all`) and [`Optimum.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Optimum.lean) (`Optimum.least_of_room`, `Optimum.Room`, `Web.optimum_broken_iff`). Check whether couplings are fixed externally or endogenously, and check `Optimum.Room`'s strict-exceeding condition on the coupled family.
2. **Closed self-refit lock & endogenous capture race:** [`ClosedCapture.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ClosedCapture.lean) (`Becoming.ClosedCapture.lock_outlives_loss` — inspect `Locked`, `Raises`, `ReadsShare`, upward favour closure, `Accrues`, and no-noise premises), [`EndogenousEmergence.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/EndogenousEmergence.lean) (`endogenous_emergence_sufficiency`, `emergent_order_firewall`), and [`EndogenousDetectionRace.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/EndogenousDetectionRace.lean) (`mark_eq_thinned`, `mark_turned_admits_iff`, `mark_middle_band_trichotomy`, `mark_middle_band_monotone_partition`, `cadence2_readAtSpanEnd`, `split_marginal_count_eq`, `split_silenced_trapped`, `split_exchange_turns`). Check determinism and `Obs`-only boundaries.
3. **Pace-vs-margin & unrecoverable cadence:** [`PacedStock.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PacedStock.lean) (`blocks_kernel_iff_fine_kernel` with `CoveredByBlocks`/`SpanGuard`, `slack_certifies_fine_kernel` with `stepDrop * (L - 1)`, `pace_margin_feasibility_window`, `unrecoverable_cadence_impossibility`). Check integer premises (`nGe2 : 2 ≤ N`, `yLtH1 : Y < H₁`, `h1Le : H₁ ≤ H₂ + y₂`).
4. **Concurrent race, assume-guarantee, & open-ended epochs:** [`AdaptiveLoops.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/AdaptiveLoops.lean) (`coupled_race_theorem`, `assume_guarantee_joint_viable`), [`PolyComposition.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PolyComposition.lean) (`ConcurrentSerialWitness.concurrent_serial_dichotomy`), and [`OpenEndedComposition.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OpenEndedComposition.lean) (`constantEpoch_iff_transformsViably`, `epochChain_viability_kernel_on_K`, `epochChain_nonDeadlock`, `reciprocal_evolve_rejects_8_and_certifies_11`, `jointEpochFamily_gate_iff_reciprocalGate`, `jointBool_simultaneous_refused_at_8`, `jointBool_simultaneous_certified_at_11`).
5. **B1–B2 shared probability/Krylov leaf & observable lumpability join:** [`FiniteProbKrylov.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/finite-prob-krylov/FiniteProbKrylov.lean) (`FiniteProb.optimal_query_tv_floor`, `FiniteKrylov.krylovSub_stabilizes_before_rank`, `FiniteKrylov.FiberLumpable`, `FiniteKrylov.survival_indistinguishable_iff_le_obs_pred`, `FiniteKrylov.lumpable_obs_horizon_one_witness`), [`ObservationalFidelity.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/observational-fidelity/ObservationalFidelity.lean) (`fiberLumpable_iff_exists_zero_rowDefect`, `fixed_macro_nonzero_rowDefect_witness`), and [`SurvivalDistinguishability.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/survival-distinguishability/SurvivalDistinguishability.lean) (`survival_indistinguishable_iff_le_card_pred` over all mode words, `survival_indistinguishable_iff_le_obs_pred`, `countdown_attains_card_pred`, `three_state_mode_switch_counterexample`). Verify that observable-horizon compression only carries distinguishing power for substochastic survival matrices (normalized Markov kernels yield `survVec = 1`).
6. **End-to-end spine, sharpness countermodels, & `not_entails` firewall:** [`AlignmentSpine.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/AlignmentSpine.lean) (`SharpnessSuite`, `master_sharpness_suite_complete`, `alignment_spine_end_to_end`, `alignmentSpine_not_entails`), [`MasterSpine.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/MasterSpine.lean) (`whole_becoming_master_theorem`, `masterSpine_cannot_entail_unrestricted`), and [`ScopeDynamics.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ScopeDynamics.lean) (`scopeLaw_cannot_entail_unrestricted`). Look specifically for non-vacuity (`Inhabited` / concrete witnesses proving hypotheses are satisfiable AND droppable).

---

## Step 4 (~10 min) — Reproduce Runtime Grammar, Replay, & Stress-Lab Failures

1. Run the 6-test alignment proposal runtime tests (`28` unit tests, `14` built-in examples with `7` of kind `alignment_proposal` — stylised, AI-authored specs) in a subshell from repo root and inspect `OBSTRUCTED` vs. `GUARDED` JSON reports in [`experiments/guarded-alignment-runtime/`](../../experiments/guarded-alignment-runtime/README.md):

```bash
(cd experiments/guarded-alignment-runtime && \
  PYTHONDONTWRITEBYTECODE=1 python3 -B -m unittest discover -s tests -v && \
  PYTHONDONTWRITEBYTECODE=1 python3 -B -m guarded_alignment run all && \
  PYTHONDONTWRITEBYTECODE=1 python3 -B -m guarded_alignment run proposal_guarded_open_alignment --json)
```

2. From repo root, run the local neural stress lab (`B1`–`B5` + post-hoc `b5_controls.py`, `19` unit tests, `B5` keeps its `4/11` failed pre-registered predictions `P8`–`P11` upfront) and the evidence-replay suite (`16` tests, including `R5` middle-band trichotomy/monotonicity, `R6` closed-loop split/weighted tags, and 8-slot endogenous silent-drift self-detection) documented in [`experiments/neural-alignment-stress-lab/RESULTS.md`](../../experiments/neural-alignment-stress-lab/RESULTS.md) and [`experiments/evidence-replay/README.md`](../../experiments/evidence-replay/README.md), plus the Wave 2 [`real-learner-b1-b2-b3`](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/dual-track-waves-2026-11-24/real-learner-b1-b2-b3/RESULTS.md) boundary study (`chosen_m = null`, `online_passed = false`):

```bash
PYTHONDONTWRITEBYTECODE=1 python3 -B -m unittest discover -s experiments/neural-alignment-stress-lab -p 'test_*.py' -v
PYTHONDONTWRITEBYTECODE=1 python3 -B experiments/neural-alignment-stress-lab/run_all.py --with-b5 --seeds 20
PYTHONDONTWRITEBYTECODE=1 python3 -B -m unittest discover -s experiments/evidence-replay -p 'test_*.py' -v
```

---

## Step 5 (~15 min) — Skeptical Reviewer Scorecard

Before signing off on any external summary claim, score these six questions strictly from Steps 1–4:

| # | Audit Question | Where to Falsify It |
|---|---|---|
| 1 | **Empty-type or vacuous hypothesis trap?** Do all impossibility and guard theorems instantiate concrete inhabited witnesses (`SharpnessSuite`, `OplaxHistory` non-empty families)? | [`AlignmentSpine.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/AlignmentSpine.lean), [`OplaxHistory.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OplaxHistory.lean) |
| 2 | **Prior-literature candor?** Are restatements (Zhuang & Hadfield-Menell, Hubinger et al., Arthur, Stigler, Hardin, Hadfield-Menell et al.) explicitly acknowledged rather than claimed as brand-new theorems? | [`08-METHOD.md#known-results`](chapters/08-METHOD.md#known-results), [`DEBTS.md`](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/kd-known-results-debts/DEBTS.md) |
| 3 | **Empirical, stress-lab, & Wave 2 failure honesty?** Are `MQ3`, `EM1`, `IN1`, `UE31b`, `LA2`, `B4`'s `25–50%` guarded collapse rates, `B5`'s failed `P8`–`P11` predictions, and Wave 2 `real-learner-b1-b2-b3` (`chosen_m = null`, B2 Arm C `online_passed = false`) reported ahead of favorable cases? | [`TESTS.md#by-thesis`](../../TESTS.md#by-thesis), [`neural-alignment-stress-lab/RESULTS.md`](../../experiments/neural-alignment-stress-lab/RESULTS.md), [`real-learner-b1-b2-b3/RESULTS.md`](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/dual-track-waves-2026-11-24/real-learner-b1-b2-b3/RESULTS.md) |
| 4 | **Rule 2 model-to-world separation?** Does every runtime verdict and document deny automatic transfer from finite `Nat`/`Fraction` models (and stylised AI-authored specs) to real neural policies? | [`proposal_audit.py`](../../experiments/guarded-alignment-runtime/guarded_alignment/proposal_audit.py), [`ALIGNMENT-FOUNDATION.md`](ALIGNMENT-FOUNDATION.md) |
| 5 | **Dynamics-vs-ethics firewall (`not_entails`)?** Does every document state `not_entails` strictly — given at least one standpoint and one formation (`p : Pos`, `f : F`), no satisfiable law reading only dynamics entails `Unrestricted` for every significance assignment (holds by construction)? | [`ScopeDynamics.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ScopeDynamics.lean), [`MasterSpine.lean`](../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/MasterSpine.lean) |
| 6 | **Front-to-source alignment?** Do all claims in `ALIGNMENT-FOUNDATION.md`, `CANONICAL-MAP.md`, and `ONE-PAGE.md` match [`RESULTS.md`](../../RESULTS.md), [`TESTS.md`](../../TESTS.md), and [`08-METHOD.md`](chapters/08-METHOD.md) without stronger front-page prose than the underlying records and receipts support? | [`RESULTS.md`](../../RESULTS.md), [`TESTS.md`](../../TESTS.md), [`08-METHOD.md`](chapters/08-METHOD.md) |
