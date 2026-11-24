# Wave 3 Handoff — `wave3-spec-duality-finish`

*AI-written (Wave 3, 2026-11-24). Local Mac only (Rule 7 compliant: zero pushes, zero network calls).*

## 1. Branch & Disjoint Payload Scope
- **Branch:** `wave3-spec-duality-finish` (branched cleanly from `main` `c35573bd0`).
- **Ready for Merge Integrator (`6221b989`) batched train integration:** zero edits to `Becoming/*.lean`, `ObservationalFidelity.lean`, `SurvivalDistinguishability.lean`, `periphery-manifest.json`, `regions.json`, `BECOMING-WORKBOARD.md`, `CANONICAL-MAP.md`, or `ZETA-AND-THE-FULL-MAP.zh.md`.

### Touched / Added Files
1. **Direction 1 — `BecomingSpec` + `comparator` (`22 → 26` targets):**
   - `experiments/integrated-correction/general-framework/generative-basis/lean/becoming-spec/BecomingSpec/Extensions/SpineTargets.lean` (pure `import Init`, `set_option genInjectivity false`, 0 axioms, 0 `.injEq`)
   - `experiments/integrated-correction/general-framework/generative-basis/lean/becoming-spec-check/` (`Challenge.lean`, `Solution.lean` Adapter 9, `check_becoming_spec.py`, `becoming-spec-verification.json`)
2. **Direction 2 — `DualityLifting` + `check_consequence_duality.py` `cwd=HERE` fix:**
   - `experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/DualityLifting.lean` (Dobrushin `osc` TV contraction lifts `dobrushin_dualBound_lift` & `dobrushin_horizon_primalGap_bound`; product query `tensor_dualBound_subadditive` & XOR `coupled_relational_gap_witness` `1/2 → min(1/2, ε)`; single-distribution runtime safety `empirical_estimate_error_bound` & `empirical_threshold_safety_certificate`)
   - `experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/check_duality_lifting.py` & `duality-lifting-verification.json`
   - `experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/check_consequence_duality.py` (sets `cwd=HERE` / `cwd=tmp_dir` so invocation works from any directory)
3. **Empirical Replay Handshake (`TestDualityLiftingHandshake`):**
   - `experiments/evidence-replay/test_replay_suite.py` (added exact rational Dobrushin `α=1/2` vs `1` lift, `Bool×Bool` XOR LP duality `1/2 → min(1/2, ε)`, and B2 empirical safety threshold + exceeded-drift negative test)
4. **This Handoff:**
   - `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/parallel-wave-2026-11-24/WAVE3-HANDOFF.md`

## 2. Verification Summary (All 6 Suites Re-Verified on Committed Branch)
1. `check_becoming_spec.py`: `PASS` — `V1+V2+IN1=277 lines`, `26` comparator targets + `219` closure constants, `0 .injEq`, `0` axioms (`v4.29.1` & `v4.30.0-rc2`), `Solution constants=167 (adapters=24, 0 axioms)`, `tamper tests=4/4 rejected`.
2. `check_consequence_duality.py` (invoked from `/Users/ren/theories`): `PASSED` — `50` decls (`30` thms, `19` defs, `1` struct), `['Classical.choice', 'Quot.sound', 'propext']`, `sorryAx=0`, `private=0`, `unnamed_instances=0`, `market_word_hits=0`.
3. `check_duality_bridges.py`: `PASSED` — `28` decls (`17` thms, `11` defs, `0` structs), standard axioms only, `sorryAx=0`, static clean.
4. `check_duality_lifting.py`: `PASSED` — `29` decls (`21` thms, `7` defs, `1` struct), `['Classical.choice', 'Quot.sound', 'propext']`, `sorryAx=0`, `private=0`, `unnamed_instances=0`, `market_word_hits=0`.
5. `check_encounter_entry.py`: `passed` (`Lean 4.29.1`), `91` decls (`35` thms), `nonempty_axioms: {}`, `transitive_injEq_dependencies: {}`, `4` negative self-tests.
6. `python3 -m unittest discover -s experiments/evidence-replay -p 'test_*.py' -v`: `Ran 6 tests ... OK`.

## 3. Clean Follow-Up After Track B Lands
Once `landing2-track-b` (`SurvivalDistinguishability.lean`) lands on `main`, a single ~15-line additive module `TrackBKrylovBridge.lean` can map `DualityBridges.survVec` ↔ `SurvivalDistinguishability.survVec` and instantiate `finite_krylov_zero_minimax_radius` directly on Track B without modifying Track B or `DualityBridges.lean`.
