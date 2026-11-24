# Independent 1-Hour External Audit Guide (Becoming & Alignment Pack)

*AI-written verification checklist (24 November 2026). No human has reviewed this guide yet. Designed so an external Lean / AI-alignment researcher can audit the claims in [ALIGNMENT-FOUNDATION.md](ALIGNMENT-FOUNDATION.md) without trusting any summary prose.*

Total expected wall time: **~60 minutes** on a clean checkout with Lean `v4.29.1` and Python 3.11+. Run Python verification commands with `-B` / `PYTHONDONTWRITEBYTECODE=1` if you want to keep the working tree free of bytecode caches.

---

## Step 1 (~10 min) — Core `0`-Axiom Lean Check & Receipt Audit

1. Inspect the retained core receipt directly rather than reading markdown claims:
   - [`becoming-verification.json`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json)
   - Verify `"status": "passed"`, `"toolchain": "leanprover/lean4:v4.29.1"`, `"retained_run": "becoming-checks/20261124T162330.082121Z"`, `core_closure` size (`438`), declaration count (`31,122`), theorem count (`22,020`), and check that every core module's `axiom_dependencies` maps to `[]`.
2. Re-run the core checker through the worktree lock wrapper (note: [`check_becoming.py`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/check_becoming.py) takes **no CLI flags** and writes a fresh timestamped retained run; inspect or clean only what you create if keeping a clean tree):

```bash
make lean-check
```

3. For fast scratch isolation of individual edited `.lean` files without full receipt writes, use [`scratch_build.py`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/scratch_build.py):

```bash
python3 -B experiments/integrated-correction/general-framework/generative-basis/lean/becoming/scratch_build.py <scratch_dir> Becoming.PacedStock
```

---

## Step 2 (~10 min) — Mathlib Periphery Isolation & Standalone Tracks

1. Verify that all `15` Mathlib periphery checkers (`ObservationalFidelity`, `SurvivalDistinguishability`, `QuantitativeTransfer`, `AlignmentReals`, `BecomingReals`, etc.) stay separated from the `0`-axiom core and check SHA-256 freshness via [`check_periphery.py`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/check_periphery.py) and [`periphery-manifest.json`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/periphery-manifest.json):

```bash
python3 -B experiments/integrated-correction/general-framework/generative-basis/lean/check_periphery.py --check-stale
```

2. Optionally re-verify the five primary alignment periphery checkers directly (note: `--module` expects exact PascalCase `module` names from `periphery-manifest.json`):

```bash
python3 -B experiments/integrated-correction/general-framework/generative-basis/lean/check_periphery.py \
  --module ObservationalFidelity --module SurvivalDistinguishability \
  --module QuantitativeTransfer --module AlignmentReals --module BecomingReals
```

3. Also inspect the standalone comparator, duality-lifting, Track B Krylov bridge, and `0`-axiom open-entry receipts plus [`experiments/evidence-replay/`](../../../../../../experiments/evidence-replay/README.md) (`10/10` tests):
   - [`becoming-spec-verification.json`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming-spec-check/becoming-spec-verification.json) (`26` specification targets audited across `v4.29.1` & `v4.30.0-rc2`, `4/4` tamper self-tests rejected)
   - [`consequence-duality-verification.json`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/consequence-duality-verification.json), [`duality-bridges-verification.json`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/duality-bridges-verification.json), [`duality-lifting-verification.json`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/duality-lifting-verification.json), and [`trackb-krylov-bridge-verification.json`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/trackb-krylov-bridge-verification.json)
   - [`encounter-entry-verification.json`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/encounter-entry/encounter-entry-verification.json) (`0`-axiom `Init`-only open entry, `35` theorems, `4/4` negative self-tests rejected)

---

## Step 3 (~15 min) — Read Entry Modules for Vacuity & Sharpness

Bypass all summaries and inspect statement hypotheses directly in Lean:

1. **Unread substrate blindness:** [`Selection.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Selection.lean) (`Flow.unselected_beyond_coupling`, `Flow.unselected_beyond_coupling_all`). Check whether couplings are fixed externally or endogenously.
2. **Closed self-refit lock & endogenous capture race:** [`ClosedCapture.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ClosedCapture.lean) (`ClosedCapture.lock_outlives_loss`), [`EndogenousEmergence.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/EndogenousEmergence.lean) (`endogenous_emergence_sufficiency`, `emergent_order_firewall`), and [`EndogenousDetectionRace.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/EndogenousDetectionRace.lean) (`mark_eq_thinned`, `mark_turned_admits_iff`, `split_marginal_count_eq`, `split_silenced_trapped`, `split_exchange_turns`). Check determinism and `Obs`-only boundaries.
3. **Pace-vs-margin & unrecoverable cadence:** [`PacedStock.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PacedStock.lean) (`slack_certifies_fine_kernel`, `pace_margin_feasibility_window`, `unrecoverable_cadence_impossibility`). Check integer premises (`nGe2 : 2 ≤ N`, `yLtH1 : Y < H₁`, `h1Le : H₁ ≤ H₂ + y₂`).
4. **Concurrent race, assume-guarantee, & open-ended epochs:** [`AdaptiveLoops.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/AdaptiveLoops.lean) (`coupled_race_theorem`, `assume_guarantee_joint_viable`), [`PolyComposition.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PolyComposition.lean) (`ConcurrentSerialWitness.concurrent_serial_dichotomy`), and [`OpenEndedComposition.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OpenEndedComposition.lean) (`constantEpoch_iff_transformsViably`, `epochChain_viability_kernel_on_K`, `epochChain_nonDeadlock`, `reciprocal_evolve_rejects_8_and_certifies_11`).
5. **End-to-end spine, sharpness countermodels, & `not_entails` firewall:** [`AlignmentSpine.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/AlignmentSpine.lean) (`SharpnessSuite`, `master_sharpness_suite_complete`, `alignment_spine_end_to_end`, `alignmentSpine_not_entails`), [`MasterSpine.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/MasterSpine.lean) (`whole_becoming_master_theorem`, `masterSpine_cannot_entail_unrestricted`), and [`ScopeDynamics.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ScopeDynamics.lean) (`scopeLaw_cannot_entail_unrestricted`). Look specifically for non-vacuity (`Inhabited` / concrete witnesses proving hypotheses are satisfiable AND droppable).

---

## Step 4 (~10 min) — Reproduce Runtime Grammar, Replay, & Stress-Lab Failures

1. Run the 6-test alignment proposal runtime tests (`28` unit tests, `14` built-in examples) and inspect `OBSTRUCTED` vs. `GUARDED` JSON reports in [`experiments/guarded-alignment-runtime/`](../../../../../../experiments/guarded-alignment-runtime/README.md):

```bash
cd experiments/guarded-alignment-runtime
PYTHONDONTWRITEBYTECODE=1 python3 -B -m unittest discover -s tests -v
PYTHONDONTWRITEBYTECODE=1 python3 -B -m guarded_alignment run all
```

2. Run the local neural stress lab (`B1`–`B5`, `18` unit tests, `B5` keeps failed pre-registered predictions `P8–P11` upfront) and the `10`-test evidence-replay suite documented in [`experiments/neural-alignment-stress-lab/RESULTS.md`](../../../../../../experiments/neural-alignment-stress-lab/RESULTS.md) and [`experiments/evidence-replay/README.md`](../../../../../../experiments/evidence-replay/README.md):

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
| 1 | **Empty-type or vacuous hypothesis trap?** Do all impossibility and guard theorems instantiate concrete inhabited witnesses (`SharpnessSuite`, `OplaxHistory` non-empty families)? | [`AlignmentSpine.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/AlignmentSpine.lean), [`OplaxHistory.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OplaxHistory.lean) |
| 2 | **Prior-literature candor?** Are restatements (Zhuang & Hadfield-Menell, Hubinger et al., Arthur, Stigler, Hardin, Hadfield-Menell et al.) explicitly acknowledged rather than claimed as brand-new theorems? | [`08-METHOD.md#known-results`](../../../../../../theories/becoming/chapters/08-METHOD.md#known-results), [`DEBTS.md`](../kd-known-results-debts/DEBTS.md) |
| 3 | **Empirical & stress-lab honesty?** Are `MQ3`, `EM1`, `IN1`, `UE31b`, `LA2`, and `B4`'s `25–50%` guarded collapse rates reported ahead of favorable cases? | [`TESTS.md#by-thesis`](../../../../../../TESTS.md#by-thesis), [`RESULTS.md`](../../../../../../experiments/neural-alignment-stress-lab/RESULTS.md) |
| 4 | **Rule 2 model-to-world separation?** Does every runtime verdict and document deny automatic transfer from finite `Nat`/`Fraction` models to real neural policies? | [`proposal_audit.py`](../../../../../../experiments/guarded-alignment-runtime/guarded_alignment/proposal_audit.py), [`ALIGNMENT-FOUNDATION.md`](ALIGNMENT-FOUNDATION.md) |
| 5 | **Dynamics-vs-ethics firewall (`not_entails`)?** Are normative values kept out of Lean core conclusions unless injected as explicit hypotheses? | [`ScopeDynamics.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ScopeDynamics.lean), [`MasterSpine.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/MasterSpine.lean) |
| 6 | **Repo & terminology hygiene?** Do `research.py check`, `lean_catalogue.py --check`, and [`AGENTS.md`](../../../../../../AGENTS.md) rules pass without exchange/market terminology leaks? | [`tools/research/style.py`](../../../../../../tools/research/style.py), [`test_cli_and_hygiene.py`](../../../../../../experiments/guarded-alignment-runtime/tests/test_cli_and_hygiene.py) |
