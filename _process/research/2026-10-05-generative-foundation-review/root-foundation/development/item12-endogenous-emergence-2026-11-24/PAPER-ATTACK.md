# Paper Attack: Endogenous Perceptual & Order Emergence (`08 §12` Item 12) and Top-Level Guarded-Oplax Unification

*AI-written (item12 worker, 24 November 2026; revised after pre-Lean adversarial audit in [`CRITIC-REVIEW.md`](CRITIC-REVIEW.md)). Follows `AGENTS.md` Rules 1–7.*

---

## 1. The Question and Why Existing Spine Modules Leave It Open

In [`08-METHOD.md` §12 item 12](../../../../../../theories/becoming/chapters/08-METHOD.md#open-items-ranked) and [`_process/DIRECTION.md`](../../../../../DIRECTION.md) ("What we do not know"), two structural gaps meet:

1. **Endogenous Perception, Scope Marking, and Self-Concerned Order Formation (`08 §12` item 12):**
   - `Becoming.PersistingChoices` (`07 §4.9`) characterizes a survival *filter* on choices already taken, not a dynamical mechanism forming an order.
   - `Becoming.EndogenousTurning` (`ServiceTaskModel`) assumes a 1-step throughput objective that *already* flips 1-step score in favour of restraint below `B_task`; no perceptual equivalence class refines and no course-ranking order updates.
   - `Becoming.ActiveInquiryLoop` supplies upfront a typed regime hypothesis space `Θ`, a dedicated `probeObs` channel, an `infer` map, and post-probe `warnObs`/`emitAlarm` ports.
   - `Becoming.EndogenousOrder` (`OrderUpdater`) proves convergence to `Weighting.IncreasingInOwn` *given* an exogenous pulse stream `feedback : Nat → X → Bool` and a fixed `own : X → Bool` marking, leaving open how an unguided loop reading **only** its primary task return `y : Nat` — facing a strictly greedy 1-step landscape where extraction beats restraint at *every* viable stock `x ≥ x_crit` — endogenously refines its internal equivalence class, discovers its causal support marking `ownHat`, and flips its live `OrderUpdater` policy before crossing no-return, without forcing the step of invariance (`Unrestricted`).
2. **Top-Level Structural Seam (`MasterSpine` ↔ `OplaxHistory` / `DoubleKernel`):**
   - Wave `U5` landed `Becoming.MasterSpine.WholeArchitecture` and Wave `U6` landed `Becoming.OplaxHistory` + `Becoming.DoubleKernel.GuardedProof` as sibling leaves under `Becoming.lean`. Joining them connects `WholeArchitecture`'s operational trajectories (`rOp`) and `CausalGoAlike` abstractions to `constFlatSpan` pullback histories, positive-horizon `GuardedProof` oplax derivations, and `FiberViabilitySplit` obstructions.

---

## 2. Pre-Registered Anti-Cheat & Falsification Criteria (Rule 2, Strengthened Post-Critic)

1. **Gate F1 — Strict Moore-Machine `Obs`-Only Interface (`unguided_obs_lockstep`):**
   `UnguidedLoop S Obs Act` has `init : S`, `act : S → Act`, `update : S → Obs → S` (zero `t = 0` dummy observation, zero `x : Nat`, zero `x < warnLevel`, zero `x_crit`, zero `θ`). Any two worlds emitting equal `Obs` along chosen actions up to step `t` induce identical internal states and actions at step `t`.
2. **Gate F2 — Non-Myopic Trap & Live `OrderUpdater` Policy (Zero Sidecar Cheating):**
   - Throughout `x ≥ x_crit`, immediate 1-step sensory return strictly favours extraction: `sense x .safe < sense x .extract`.
   - `LearnerPhase` carries **no** `recovered : Bool` flag (`coarse | probingSafe | probingVerify | resolved`). Instead, `LearnerState` stores live weights `pos : EmergenceItem → Nat` and live empirical scope marking `ownHat : EmergenceItem → Bool` (initialized to `.immYield ↦ true`, `.sustainedContinuation ↦ false`, `.downstreamDependent ↦ false`). In both `.coarse` and `.resolved`, action selection is computed **exclusively** via decidable `Weighting.ranksNet` (`selectByOrder`).
3. **Gate F3 — Equivalence-Class Refinement & Grammar Lumping (`«像定后当且仅当同行»`):**
   Perceptual splitting triggers strictly on stationary right-determinism failure (`y ≠ baselineExt`). On the closed-loop emergent process `P_emergent`, projecting out substrate `x` via `π_internal (x, s) := s` refutes `«定后» («像» π_internal R)` and hence `«同行»` via `OplaxHistory.span_step_grammar_lumping`, and exhibits an initially-viable `OplaxHistory.FiberViabilitySplit` between `(12, .coarse (some 16))` and `(7, .coarse (some 16))`.
4. **Gate F4 — Three-Way Universal Necessity Over All `UnguidedLoop`s:**
   - **Drop P1 (Silent Cliff):** For *every* `UnguidedLoop S Nat EmergenceAct`, if `sense x a = plateau a` for all `x ≥ x_crit`, its trajectory matches its infinite-plateau trajectory until `x < x_crit`; any plateau-extracting loop crosses `< x_crit` with zero prior residual.
   - **Drop P2 (Counterfactual Perturbation Necessity — 0-Probe and 1-Probe Universal Impossibility):**
     * **0-Probe Impossibility:** Construct $W_{\mathrm{endo}}$ (`.safe` stabilizes $x$) and $W_{\mathrm{exo}}$ ($x$ decays identically under `.extract` and `.safe`) sharing `x_crit`, `x₀`, and `sense`. For *every* `UnguidedLoop`, while `act = .extract`, both worlds emit identical observations and identical nonzero residuals (`14 ≠ 16`), so no loop can turn to `.safe` in $W_{\mathrm{endo}}$ while keeping dominating `.extract` in $W_{\mathrm{exo}}$ without taking at least one `.safe` perturbation.
     * **1-Probe Insufficiency:** Construct $W_{\mathrm{exo}}'$ (`sense' x .safe = min x 12 + 3 < sense' x .extract`) matching $W_{\mathrm{endo}}$ on all `.extract` returns *and* on the first `.safe` probe return (`11` at `t = 2`), proving that even a single `.safe` probe step cannot separate recoverable strain from exogenous decay — establishing sharpness of the 2-step trend check (`y_safe2 ≥ y_safe1`).
   - **Drop P3 (Strain-Band Headroom Impossibility):** With `x_plateau = 7, x_crit = 6` (where P1 still holds strictly: `sense 6 .extract = 10 < 11 = plateau .extract`), starting from `x₀ = 13`, *every* plateau-extracting `UnguidedLoop` steps `13 → 11 → 9 → 7 → 4 < 6`, overshooting the entire strain band in one step before any residual occurs.
5. **Gate F5 — Metaethical Firewall & Scope Honesty (`08 §12` Item 12):**
   - Across the entire emergent run (`∀ t : Nat`), `.downstreamDependent` keeps `pos t = 0` and `ownHat t = false`, leaving widening by `.downstreamDependent` unranked forever (`EndogenousOrder.uncoupled_blindness_firewall`), while for `t ≥ 4`, `ownHat t = worldCoupled W` and `Weighting.IncreasingInOwn` holds in both $W_{\mathrm{endo}}$ and $W_{\mathrm{exo}}$.
   - On the `Type 0` `EmergentOrderSystem`, `ScopeDynamics.scopeLaw_admits_rival`, `ScopeDynamics.scopeLaw_cannot_entail_unrestricted`, and `Clearing.center_not_derived` hold. This establishes endogenous formation of *self-concern over causally returning support* and explicitly does **not** settle the step of invariance (`Unrestricted`) or concern for one-way downstream dependents.
6. **Gate F6 — Top-Level Guarded-Oplax Bridge (`WholeArchitecture` ↔ `OplaxHistory` / `GuardedProof`):**
   - Offset-recursive `runToFlatSpanFrom` constructively lifts any `Run P` and `WholeArchitecture.rOp` into `(constFlatSpan (processStepSpan P) n).W` with vertex-wise `Viability.Kernel` and `ReadOffExchange`, plus `exactAbsChainMap` and `span_step_grammar_lumping` on `(CausalSystem.ofOpenComponent A.compOp A.cOp.tol).proc j`.
   - Positive-length (`n + 1`-step) `seqChainPos` in `DoubleKernel.GuardedExpr` avoids uninhabited `n = 0` `.idExpr` goals, yielding constructive `Type 1` derivations `chiChainProof`, `chiChainInvProof` (certifying step-by-step `FImageIsPullback` & universal Beck–Chevalley), and two-sided `parSeqChainLR`/`RL`, bridged via right-unit `SpanHom` bijection to `constFlatSpan H (n + 1)` and `chiConstFlat`.
   - Initially-guarded dynamic `FiberViabilitySplit` on `MasterSpine.WholeBecomingWitness.witnessArchitecture` under `π_sensoryAndInternal (st) := (opObs st.1, st.2)`: `u₁ = rOp.state 0` (`x = 21`) and `u₂ = (fun _ => 8, u₁.2)` both satisfy `OpenComposition.closedGuard` at `t = 0` and satisfy `π_sensoryAndInternal u₁ = π_sensoryAndInternal u₂` by `rfl`, yet `u₁` stays in `Viability.Kernel` forever while `u₂` drops `8 → 3 < 8` in 1 step (`¬ Viability.Kernel`), refuting macro soundness via `OplaxHistory.fiberSplit_refutes_macro_viability_soundness`.
