# Evidence Replay & Verification Suite (`experiments/evidence-replay/`)

*AI-written (Track S3 `@entry-and-replay`). Generated and checked locally on this Mac using Python 3 stdlib only (no external packages, no network calls, no remote pushes).*

This directory provides the pure-local empirical cross-check suite for Track S3, paired with the 0-axiom Lean 4 formalization in [EncounterEntry.lean](../integrated-correction/general-framework/generative-basis/lean/encounter-entry/EncounterEntry.lean) (checked by [check_encounter_entry.py](../integrated-correction/general-framework/generative-basis/lean/encounter-entry/check_encounter_entry.py)).

## Scope & Methodological Note

Per `AGENTS.md` Rules 1–2:
- Formal guarantees live in `EncounterEntry.lean` (`import Init`, 91 declarations, 35 theorems, `0` axioms, `0` transitive `.injEq` dependencies, `0` forbidden market words) under its explicit hypotheses.
- Scripts here replay recorded trajectories, compute exact `fractions.Fraction` minimax primal/dual certificates, run deterministic/seeded synthetic sweeps on local CPU, and assert structural alignment with the Lean models. Whether an empirical run satisfies a theorem's premises is a recognition check, not an automatic entailment beyond those assumptions.

## Files

- [replay_in1_handshake.py](replay_in1_handshake.py) → [fixtures/in1_replay_table.json](fixtures/in1_replay_table.json):
  Replays all 20 saved `DIR_SEEN_TALK` runs (`gpt-5.4-mini`, `gpt-4.1-mini`) under [lake.py](../direction-installation/lake.py)'s exact transition rule and appends synthetic branch/entry rows aligned with `EncounterEntry.lean` (`InquiryTree`, `sysA`/`sysB`, `clause2a`).
- [verify_duality_handshake.py](verify_duality_handshake.py) → [fixtures/duality_handshake.json](fixtures/duality_handshake.json):
  Independent exact `fractions.Fraction` primal-vs-dual certificate checker covering §7.1 (`1/4` vs `min(1/4, 2*ε)`), the 1,000-seed B2 `CoupledPhaseGoodhartEnv` empirical simulation ([substrates.py](../neural-alignment-stress-lab/substrates.py)), Track B `diag(1, 1 - δ)` survival errors, and negative tamper rejections (`L > U`, `primal_eps_violation`, `nonzero_duality_gap`, `invalid_distribution`).
- [phase2_disentangled_stress.py](phase2_disentangled_stress.py) → [fixtures/phase2_disentangled.json](fixtures/phase2_disentangled.json):
  Disentangled 2D local sweep independently varying `rho_reward` and `rho_feat` while holding `x0`, `renewal`, and `warn_onset` fixed, reporting competing-risk switch-time + pre-switch-death counts without dropping collapsed runs, plus stochastic excursion/breach probability checks.
- [protocol_8slot_benchmark.py](protocol_8slot_benchmark.py) → [fixtures/protocol_8slot.json](fixtures/protocol_8slot.json):
  Local benchmark for §5 communication-order and inquiry bottlenecks: 2-item inquiry with causal controls, 8-slot 4-bit warehouse-first vs requester-first separation, private naming alignment + scrambled-reply control, and B2/B4 probe-budget comparison.
- [test_replay_suite.py](test_replay_suite.py):
  `unittest` suite exercising all four generators, verifying regenerated output consistency, exact rational invariants, and negative tamper detections.
- [RESULTS.md](RESULTS.md):
  Exact verified metrics from both Part A (Lean) and Part B (empirical replay).

## How to Run Locally

```bash
# Part A: 0-axiom Lean verification + negative self-tests (v4.29.1, zero leaked .olean files)
python3 experiments/integrated-correction/general-framework/generative-basis/lean/encounter-entry/check_encounter_entry.py

# Regenerate Part B fixtures (optional; fixtures/*.json are deterministic under fixed seeds)
python3 experiments/evidence-replay/replay_in1_handshake.py
python3 experiments/evidence-replay/verify_duality_handshake.py
python3 experiments/evidence-replay/phase2_disentangled_stress.py
python3 experiments/evidence-replay/protocol_8slot_benchmark.py

# Run Part B unittest suite
python3 -m unittest discover -s experiments/evidence-replay -p 'test_*.py' -v
```

## Connections to Track S1 & Track S2

- **Track S1 (v1/v2 spec & open revision):**
  `replay_in1_handshake.py` documents IN1 `View1` indistinguishability vs `View2` separation (`gpt-5.4-mini` Seed 0 vs Seed 4 across Months 1–8) and concrete revision trajectories (`gpt-4.1-mini` Seed 3 faithful harmful `[20, 20, 20] -> left=40`, and Seed 7 double revision in Months 1 and 2 `[10, 20, 10] -> [10, 10, 10]` and `[10, 10, 20] -> [10, 10, 10]`). In Part A, `encounter_refines_and_preserves_entry` formalizes constructive acquisition, verified causal uptake vs masking, false-objection rejection, and open post-revision re-entry (`fair_open_entry_after_any_revision`) separated from `sealing_gate_blocks_entrants`.
- **Track S2 (§7.2 primal/dual error bounds & multi-step extensions):**
  `verify_duality_handshake.py` cross-checks exact rational LP certificates against S2's formulas on §7.1, the 1,000-seed B2 simulation (`50/347` at `alpha=0.8`, `ε=1/20`), and multi-step `diag(1, 1 - δ)` survival factors, while rejecting tampered certificates where `L > U` or constraints fail.
