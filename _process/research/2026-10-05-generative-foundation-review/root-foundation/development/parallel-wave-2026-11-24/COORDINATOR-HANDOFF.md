# Coordinator Handoff — Parallel Wave 1 & 2 (`wave12-spec-duality-entry`)

*AI-written (Wave 2, 2026-11-24). Local Mac only; zero pushes, zero network calls.*

## 1. Branch & Scope
- **Branch:** `wave12-spec-duality-entry` (branched from `main` `53f9cf598`).
- **Base commits:** Wave 1 (`c84f28cbf`, `8fef10d16`, `190c7e784`) + Wave 2 Step 2 (`31cf10d27`), plus Step 3/4 commit adding `DualityBridges` + these docs.
- **Additive-only surface (0 overlap):** touches NO core `Becoming/*.lean`, NO `ObservationalFidelity.lean` / `SurvivalDistinguishability.lean` / `AlignmentReals.lean`, NO generated map/manifests, NO `ZETA-AND-THE-FULL-MAP.zh.md`, and NO `.claude/worktrees/*`.

### File Groups Added
1. **Decoupled Spec & Comparator (S1 + Wave 2 Entry):**
   - `experiments/integrated-correction/general-framework/generative-basis/lean/becoming-spec/` (`BecomingSpec/V1/Targets.lean`, `V2/Targets.lean`, `Revision/IN1.lean`, `Extensions/OplaxTargets.lean`, `Extensions/EntryTargets.lean`, `lean-toolchain`)
   - `experiments/integrated-correction/general-framework/generative-basis/lean/becoming-spec-check/` (`Challenge.lean`, `Solution.lean`, `check_becoming_spec.py`, `becoming-spec-verification.json`, `lean-toolchain`)
2. **Consequence Duality & Bridges (S2 + Wave 2):**
   - `experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/` (`ConsequenceDuality.lean`, `DualityBridges.lean`, `check_consequence_duality.py`, `consequence-duality-verification.json`, `check_duality_bridges.py`, `duality-bridges-verification.json`, `lean-toolchain`)
3. **Open Entry & Replay (S3):**
   - `experiments/integrated-correction/general-framework/generative-basis/lean/encounter-entry/` (`EncounterEntry.lean`, `check_encounter_entry.py`, `encounter-entry-verification.json`, `lean-toolchain`)
   - `experiments/evidence-replay/` (`README.md`, `RESULTS.md`, `test_replay_suite.py`, 4 runner scripts, 4 fixtures)
4. **Wave 1–2 Coordination Docs:**
   - `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/parallel-wave-2026-11-24/{COORDINATOR-HANDOFF.md,NOTE.md}`

## 2. Verification Summary (All 5 Checks Self-Contained on `53f9cf598`)
1. `check_becoming_spec.py`: `PASS` — `V1+V2+IN1=277 lines`, `22` comparator targets + `211` closure constants, `0 .injEq`, `0` axioms (`v4.29.1` & `v4.30.0-rc2`), `tamper tests=4/4 rejected`.
2. `check_consequence_duality.py`: `PASSED` — `50` decls (`30` thms, `19` defs, `1` struct), `['Classical.choice', 'Quot.sound', 'propext']`, `sorryAx=0`, `private=0`, `unnamed_instances=0`, `market_word_hits=0`.
3. `check_duality_bridges.py`: `PASSED` — `28` decls (`17` thms, `11` defs, `0` structs), `['Classical.choice', 'Quot.sound', 'propext']`, `sorryAx=0`, `private=0`, `unnamed_instances=0`, `market_word_hits=0`.
4. `check_encounter_entry.py`: `passed` (`Lean 4.29.1`), `91` decls (`35` thms), `nonempty_axioms: {}`, `transitive_injEq_dependencies: {}`, `4` negative self-tests.
5. `python3 -m unittest discover -s experiments/evidence-replay -p 'test_*.py' -v`: `Ran 5 tests ... OK`.

## 3. Wave 3 Merge-After-Track-B Plan (~10 lines)
Once Track B lands (`SurvivalDistinguishability.lean`, `ObservationalFidelity.lean`), add one thin bridge module importing `SurvivalDistinguishability` + `DualityBridges`:
- Map `DualityBridges.stepOp M` to `SurvivalDistinguishability.stepOp` (definitional / `Finset.sum` congruence) and `DualityBridges.survVec` to `SurvivalDistinguishability.survVec`.
- Instantiate `DualityBridges.finite_krylov_zero_minimax_radius` directly on `SurvivalDistinguishability`'s kernel `K` and horizon `≤ Fintype.card S - 1` so `survival_indistinguishable_iff_le_card_pred` implies zero `ε = 0` §7.2 minimax gap for arbitrary-length survival queries, without modifying Track B or `ConsequenceDuality.lean`.

## 4. Guidance for Coordinator (Speed, Quality, Token Wisdom — from Ren)
1. **Disjoint additive tracks first:** Partition parallel sessions onto non-overlapping paths/branches and integrate cross-track bridges (like `EntryTargets` and Wave 3) only after base pieces stabilize.
2. **Consolidate instead of re-swarming:** When base tracks are already verified on isolated branches, combine them inside one worktree directly rather than spawning redundant multi-agent swarms.
3. **Freeze thin specs + mechanical gates:** Keep target specifications tiny (`import Init`, 0 axioms, 0 `.injEq`) and pair every Lean/Python module with a fast local verifier + negative tamper checks so refactors are machine-checked, not re-argued in prose.
4. **Never race active queue landings:** Inspect live `gate.py` / `cx -m` / `BECOMING-WORKBOARD.md` Queue before `merge --ff-only`; if `main` or an audit gate is busy, park the cleanly committed, verified branch in git and hand off rather than colliding or burning rework tokens.
5. **Concise SHA-backed handoffs:** Communicate via exact commit SHAs, file lists, and verbatim verifier receipts rather than re-summarizing long exploration trajectories.
