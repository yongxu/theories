# Wave 0 Freeze — Dual-Track Waves 1–4 Execution Specification

*AI-written (Wave 0, 24 November 2026). Archived ahead of Wave 1 Commit B under Ren's 22:10 & 22:49 WIB directives ([source](../../../../../../sources/15-codex-theory-conversations/2026-11-24-wave0-to-wave4-dual-track-roadmap.md)). Nothing pushed, sent out, or licensed (Rule 7).*

## Scope & Ordering Across Waves 0–4

1. **Wave 0 (Literature Check & Freeze):** Verify external Track B4 Shannon-capacity / chromatic-rate citations before quoting them and freeze all heavy brute-force CPU work per Ren's 22:49 WIB directive (run Lean verification strictly serial `BECOMING_JOBS=1 BECOMING_LEAN_SLOTS=1`; skip exhaustive `C_7^{⊠3}`/`C_7^{⊠4}` searches and `n = 2048` dense Jacobi sweeps).
2. **Wave 1 (Periphery Deduplication & B1–B2 Join):** Extract shared `FiniteProb` + `FiniteKrylov` Mathlib `v4.30.0-rc2` leaf `FiniteProbKrylov.lean` imported by `ObservationalFidelity`, `SurvivalDistinguishability`, `ConsequenceDuality`, and `DualityBridges` (preserving explicit theorem signatures and `TrackBKrylovBridge` compatibility while `FinDist` becomes an `abbrev` for `FiniteProb.FinDist`), add rank-form Krylov stabilization `krylovSub_stabilizes_before_rank`, and prove exact `FiberLumpable` B1–B2 bridges (`rowDefect_eq_zero_iff_pushforward`, `fiberLumpable_iff_exists_zero_rowDefect`, `fixed_macro_nonzero_rowDefect_witness`, `survival_indistinguishable_iff_le_obs_pred`).
3. **Wave 2 (Item 4 — Lightweight `< 20s` Real-Learner B1/B2/B3):** Prospective `--prediction-sha`-gated Python study under `real-learner-b1-b2-b3/` importing `neural-alignment-stress-lab` and `guarded-alignment-runtime` read-only.
4. **Wave 3 (Track A3 — `Becoming.RelSpan` Core Inversion):** Extract `OplaxHistory.lean:49–1059` into `Becoming.RelSpan`, add `Becoming.RelSpan.mapTrace` with verified net body-token compression across `CausalAbstraction` and `PolyComposition`, add held-out `EncounterEntry` test, preserving all 22 `BecomingSpec` targets and `0` core axioms.
5. **Wave 4 (Track B4 `InterfaceBits.lean` & Track B3 Analytic/LDL/`MovingFeatureCone.lean`):** Pure algebraic + small-`decide` `InterfaceBits.lean` (`0` `native_decide`, joined to `C2RelativeLossWitness.c2_n_step_collapse`), plus analytic Schur/BBP derivation, sub-15s Dumitriu–Edelman/LDL check, and deterministic `MovingFeatureCone.lean` joined to `AlignmentReals`.

## Verified Literature Benchmarks (Track B4, Held Under Rule 1 Attribution)

- **`C_7^{⊠3}` independence number:** $\alpha(C_7^{\boxtimes 3}) = 33$ established by Baumert, McEliece, Rodemich, Rumsey, Stanley & Taylor (1971), giving $M_3(1) \ge \lceil 343 / 33 \rceil = 11$ by counting, which with the separate 12-color upper bound places $M_3(1) \in \{11, 12\}$ without local brute search (exact value not resolved here).
- **Higher odd-cycle powers:** Vesel & Žerovnik lower-bound $\alpha(C_7^{\boxtimes 4}) \ge 108$, and Polak & Schrijver (2019) prove $\alpha(C_7^{\boxtimes 5}) \ge 367$, yielding $\Theta(C_7) \ge 367^{1/5} \approx 3.2579$ (upper-bounded by Lovász $\vartheta(C_7) = \frac{7 \cos(\pi/7)}{1 + \cos(\pi/7)} \approx 3.3177$).
- **Witsenhausen (1976) chromatic rate:** For vertex-transitive $C_7$, $\lim_{n\to\infty} \frac{1}{n}\log_2 \chi(C_7^{\boxtimes n}) = \log_2 7 - \log_2 \Theta(C_7) \in [1.0771, 1.1035]$ bits/dimension.

## Epistemic Boundaries (Rules 1 & 2)

- **Proved (Lean):** Only exact module statements verified by Lean receipts with explicit assumptions (`FiniteKrylov.FiberLumpable` observable-horizon reduction `card O - 1` is non-trivial only for substochastic/real survival matrices because normalized Markov kernels satisfy `survVec = 1` unconditionally; fixed-macro `rowDefect = 0` additionally requires a matching macro kernel `L`, witnessed by `fixed_macro_nonzero_rowDefect_witness`).
- **Tested (Python):** Prior Landing 2 empirical checks (`frozen_q_survival_test.py` and finite B3/B4 probes) falsify false invariants on concrete runs without proving Lean hypotheses hold in general systems.
- **Planned / Pending (not yet run at Wave 0–1):** Wave 2 real-learner `PacedReserveEnv` / `ReinforcePolicy` B1/B2/B3 tests and Wave 4 sub-15s Dumitriu–Edelman/LDL checks.
- **Open:** Asymptotic B3 cone scaling as $n \to \infty$ (paper/numerical unless proved), exact $M_3(1) \in \{11, 12\}$ / $K_3$-free B4 separation, and continuous/non-stationary extensions of B1/B2.
