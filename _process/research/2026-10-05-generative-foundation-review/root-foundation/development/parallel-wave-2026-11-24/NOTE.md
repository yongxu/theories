# Wave 1–2 Technical Note: Decoupled Spec, Consequence Duality, and Open Entry

*AI-written (2026-11-24). Branch `wave12-spec-duality-entry` off `main` `53f9cf598`.*

## What Changed and How the Parts Meet

This branch implements two structural upgrades inspired by recent large-scale formalization practice plus an open-entry and empirical-replay track, kept completely additive so existing `Becoming/*.lean` proofs and sibling landing queues stay untouched:

1. **Decoupled Minimal Spec & Comparator (`lean/becoming-spec/`, `lean/becoming-spec-check/`):**
   - `BecomingSpec.V1.Targets`, `BecomingSpec.V2.Targets`, `BecomingSpec.Revision.IN1` (`277` lines combined), `BecomingSpec.Extensions.OplaxTargets`, and `BecomingSpec.Extensions.EntryTargets` state core targets using `import Init` only (`set_option genInjectivity false`, `0` axioms, `0` `.injEq`).
   - `Challenge.lean` defines open `sorry`-style holes referencing `BecomingSpec.*` targets; `Solution.lean` supplies Adapter 1–8 witnesses connecting the library `Becoming.*` and `EncounterEntry.*` theorems to those holes.
   - `check_becoming_spec.py` verifies both Lean `v4.29.1` and `v4.30.0-rc2`, checks `Solution` closure constants (`0` axioms across all `22` matched targets), and confirms `4/4` tamper tests are rejected.

2. **Positive Quantitative Consequence Duality & Bridges (`lean/consequence-duality/`):**
   - `ConsequenceDuality.lean` (`50` declarations: `30` theorems, `19` defs, `1` structure) proves §7.2 finite LP/polyhedral minimax (`consequence_minimax_duality`), multi-query TV duality (`common_history_tv_duality`), decision-margin minimax (`decision_margin_minimax`), the public-port vs recipient witness (`public_port_vs_recipient_exact`: `1/4` vs `min (1/4) (2*ε)`), and the B2 aliasing-08 exact rational certificate (`b2_aliasing_08_exact_certificate`: `50/347`).
   - `DualityBridges.lean` (`28` declarations: `17` theorems, `11` defs) adds four structural bridges on top of `ConsequenceDuality` alone:
     - *Model-error propagation:* `dualBound_with_model_error` and `dualBound_with_uniform_model_error` show entrywise discrepancy `|F_true j s - F_approx j s| ≤ δ j` enlarges feasible query tolerances cleanly to `ε j + δ j`.
     - *Open-entry monotonicity & strict drops:* `monotone_entry_value`, `monotone_entry_value_exists` (`Option J` query extension weakly lowers attained minimax value), and `strict_entry_improvement_witness` (`1/4 → min (1/4) (2*ε)` when `0 ≤ ε < 1/8`; B2 `1/2 → 50/347`).
     - *Affine-span equivalence:* `zero_dualBound_iff_affine_span` proves `(∃ b c, dualBound F h 0 b c = 0) ↔ h ∈ Submodule.span ℝ (insert (fun _ => 1) (Set.range F))`.
     - *Finite Krylov zero-radius:* `finite_krylov_zero_minimax_radius` shows self-contained `krylovSub` stabilizes at word length `k ≤ Fintype.card S - 1`, forcing attained `ε = 0` §7.2 minimax error `0` for any survival query `survVec K w₀` conditioned on bounded words `ShortWord S Act`.
   - Both modules use only `['Classical.choice', 'Quot.sound', 'propext']`, `sorryAx=0`, `private=0`, `unnamed_instances=0`, and `market_word_hits=0`.

3. **Open Entry & Local Replay (`lean/encounter-entry/`, `experiments/evidence-replay/`):**
   - `EncounterEntry.lean` (`91` declarations, `35` theorems, `0` nonempty axioms, `0` transitive `.injEq`, `Lean 4.29.1`) formalizes adaptive two-step inquiry beating fixed two-query schedules, labeled path-count equivalence hiding blocked post-branch completion, and `encounter_refines_and_preserves_entry` (preserving open second entry while separating false submissions and masking). `Solution.lean` Adapter 8 unifies all three theorems under `BecomingSpec.Extensions.EntryTargets`.
   - `experiments/evidence-replay/` runs deterministic offline replay checks across four fixture-backed scenarios (`duality_handshake`, `in1_replay_table`, `phase2_disentangled`, `protocol_8slot`) verified by `test_replay_suite.py` (`Ran 5 tests`).

## Premises, Limits, and What Would Falsify This Account

- Each Lean theorem holds strictly under its stated finite-type and tolerance hypotheses (`[Fintype S]`, `[Nonempty S]`, bounded `δ j`, exact Markov operator `K`). Recognizing whether an actual system meets them stays an empirical judgment outside the proof.
- `dualBound_with_model_error` ceases to bound worst-case consequence gap if empirical query drift exceeds `δ j`.
- `finite_krylov_zero_minimax_radius` guarantees zero error at `ε = 0` over finite `S`; non-Markovian state growth or nonzero query tolerance `ε > 0` with ill-conditioned short-word coefficients reopens minimax risk (`noisy_short_word_amplification` in `ConsequenceDuality.lean`).
- Comparator integrity fails immediately if any tamper test passes or any `BecomingSpec` / `EncounterEntry` target acquires `sorry`, `.injEq`, or extra axioms.

## Exact Verification Commands (from repo/worktree root)

```bash
python3 experiments/integrated-correction/general-framework/generative-basis/lean/becoming-spec-check/check_becoming_spec.py
python3 experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/check_consequence_duality.py
python3 experiments/integrated-correction/general-framework/generative-basis/lean/consequence-duality/check_duality_bridges.py
python3 experiments/integrated-correction/general-framework/generative-basis/lean/encounter-entry/check_encounter_entry.py
python3 -m unittest discover -s experiments/evidence-replay -p 'test_*.py' -v
```
