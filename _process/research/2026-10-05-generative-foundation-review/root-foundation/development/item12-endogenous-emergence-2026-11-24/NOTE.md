# Item 12 Endogenous Perceptual & Order Emergence + Top-Level Guarded-Oplax Bridge

*AI-written (`item12` worker, 24 November 2026, following pre-Lean adversarial review by `item12-critic` on `gemini-4-neon-high`). Strictly local verification under `AGENTS.md` Rules 1–7; `Becoming.lean`, `check_becoming.py`, and all shared global files untouched.*

---

## 1. Files in This Folder

- [`PAPER-ATTACK.md`](PAPER-ATTACK.md) — Pre-Lean mathematical design, six pre-registered anti-cheat / falsification gates (`F1`–`F6`), and post-critic refinements.
- [`CRITIC-REVIEW.md`](CRITIC-REVIEW.md) — Adversarial Neon (`gemini-4-neon-high`) pre-Lean audit surfacing 2 hard Lean blockers (`n = 0` uninhabited `GuardedProof` `.idExpr` goals; sidecar `OrderUpdater` / `own` / Mealy timing) and 5 sharpness/type traps before any Lean was written.
- [`scratch/Becoming/EndogenousEmergence.lean.txt`](scratch/Becoming/EndogenousEmergence.lean.txt) — Verified 0-axiom `Init`-only Lean 4 prototype (`Becoming.EndogenousEmergence`, `1,641` lines, `100` declarations, `42` theorems, `0` warnings, `0` axioms). Stored with `.lean.txt` suffix because `tools/research/lean_catalogue.py` (`path_role` line 214) indexes `*.lean` under `_process/` as `development-attempt`, so `.lean.txt` keeps `python3 tools/research/lean_catalogue.py --check` passing cleanly without running `research.py render`.

---

## 2. What `Becoming.EndogenousEmergence` Proves (`0` Axioms, `Init`-Only)

### Part A — Sharp Endogenous Emergence Necessity & Sufficiency Dichotomy (`08 §12` Item 12)

1. **Strict Moore-Machine `Obs`-Only Firewall (`UnguidedLoop`, `unguided_obs_lockstep`):**
   An unguided adaptive loop (`init : S`, `act : S → Act`, `update : S → Obs → S`) reads only its internal state and primary task return `y : Nat` — zero `t = 0` dummy observation, zero raw substrate `x` port, zero `xCrit` threshold constant, and zero regime label. Any two worlds producing equal observations prior to `T` keep `L` in identical states and actions at `T`.
2. **Non-Myopic Landscape & Live `OrderUpdater`-Driven Policy (`worlds_strictly_greedy_everywhere`, `emergent_pos_eq_orderUpdater`, `emergent_act_governed_by_orderUpdater`):**
   - Across `wEndo`, `wExo`, `wExoShift`, and `wThinStrain`, immediate 1-step return strictly favours extraction at *every* stock `x` (`sense x .safe < sense x .extract`), ruling out 1-step `ServiceTaskModel` crossover.
   - `LearnerPhase` carries **no** `recovered : Bool` flag (`coarse | probingSafe | probingVerify | resolved`). `LearnerState` stores live weights `pos` and empirical causal-return scope `ownHat` (initialized to `.immYield ↦ true`, `.sustainedContinuation ↦ false`, `.downstreamDependent ↦ false`). In `.coarse` and `.resolved`, `emergentLoop` chooses `.safe` iff `EndogenousOrder.OrderUpdater.ranksAt` strictly ranks `cSafe` above `cExt` (`selectByOrder`).
3. **Constructive Sufficiency & Exogenous Separation (`endogenous_emergence_sufficiency`, `emergentLoop_separates_exo`):**
   - In `wEndo` from `x₀ = 14`: at `t = 0`, `OrderUpdater` strictly ranks `cExt` above `cSafe` (`initPos .sustainedContinuation = 0 < 1 = base`); at `t = 1`, stationary right-determinism breaks (`14 ≠ 16`), splitting `.coarse (some 16) → .probingSafe 14`; at `t = 2, 3`, the 2-step counterfactual `.safe` perturbation observes `11 ≤ 11` and emits an endogenous pulse; for all `t ≥ 4`, `ownHat = worldOwnEndo`, `Weighting.IncreasingInOwn` holds, `ranksAt` flips to `cSafe > cExt`, `selectByOrder` chooses `.safe`, and `(14, emergentLoop.init)` remains eternally in `Viability.Kernel` (`x_t = 10 ≥ 6`).
   - In `wExo` (autonomous decay under both `.extract` and `.safe`) from `x₀ = 14`: residual splitting fires at `t = 1`, the 2-step probe observes `9 → 7`, zero false-positive pulses fire, `ownHat = worldOwnExo`, `Weighting.IncreasingInOwn` holds with respect to `worldOwnExo`, and `emergentLoop` resumes `.extract` at `t = 4`.
4. **Three-Way Universal Necessity Over ALL `UnguidedLoop`s:**
   - **Drop P1 (`silent_cliff_universal_lockstep`, `silent_cliff_universal_collapse`):** Without pre-collapse sensory strain (`∀ x ≥ xCrit, sense x a = plateau a`), *every* `UnguidedLoop` matches its infinite-plateau run until `x < xCrit`; every plateau-extracting loop (including `emergentLoop` on `wCliff`) breaches `x < xCrit` with zero prior warning.
   - **Drop P2 (`zero_probe_endo_exo_indistinguishable`, `separation_requires_safe_perturbation`, `one_probe_universal_insufficiency`):** Without executing `.safe`, *no* `UnguidedLoop` can separate recoverable `wEndo` from exogenous `wExo` (even after nonzero strain residual `14 ≠ 16`); moreover, even after a **1-step** `.safe` probe at `t = 2`, `wEndo` and `wExoShift` emit the exact same trace `[16, 14, 11]`, leaving *every* `UnguidedLoop` identical at `t = 3` — proving 2-step counterfactual trend verification is minimal.
   - **Drop P3 (`thin_strain_band_universal_collapse`):** On `wThinStrain` (`xCrit = 6, x_plateau = 7`, where P1 still holds strictly at `x = 6`: `sense 6 .extract = 10 < 11`), from `x₀ = 13`, *every* plateau-extracting `UnguidedLoop` steps `13 → 11 → 9 → 7 → 4 < 6`, overshooting the strain band in one step before any residual fires.
5. **Grammar Lumping, Pre-Split `FiberViabilitySplit`, & Metaethical Firewall (`emergent_grammar_lumping_and_fiber_split`, `emergent_order_firewall`):**
   - Projecting out `x` via `projInternal (x, s) := s` on `loopProcess wEndo emergentLoop` refutes `«定后» («像» projInternal R)` and `«同行»` (`OplaxHistory.span_step_grammar_lumping`), and exhibits an initially-viable `OplaxHistory.FiberViabilitySplit` between `(12, s_coarse16)` and `(7, s_coarse16)`.
   - Across all `t : Nat`, `.downstreamDependent` keeps `pos = 0` and `ownHat = false`, leaving `cFull` vs `cSafe` unranked forever (`EndogenousOrder.uncoupled_blindness_firewall`), while `ScopeDynamics.scopeLaw_admits_rival`, `ScopeDynamics.scopeLaw_cannot_entail_unrestricted`, and `Clearing.center_not_derived` hold on `EmergentOrderSystem`.

### Part B — Top-Level Guarded-Oplax Bridge (`MasterSpine` ↔ `OplaxHistory` / `DoubleKernel`)

1. **Constructive Trajectory-to-Pullback Lifting & Causal-Grammar Bridge (`runToFlatSpanFrom`, `wholeArchitectureExactAbs`, `wholeArchitecture_oplax_guarded_bridge`):**
   For every `A : MasterSpine.WholeArchitecture` and `n : Nat`, `A.rOp` constructively inhabits `(OplaxHistory.constFlatSpan (processStepSpan (wholeOpClosedProcess A)) n).W` with `Viability.Kernel` and multi-site `ReadOffExchange`, while `wholeArchitectureExactAbs A` projects `n`-step open-component pullback chains via `OplaxHistory.exactAbsChainMap` without `Classical.choice` and links `A.π_causal` to `«像定后当且仅当同行»`.
2. **Positive-Horizon `(n + 1)`-Step `GuardedProof` Calculus (`seqChainPos`, `posChainFlatSpanBij`, `chiChainProof`, `chiChainInvProof`, `parSeqChainLR`/`RL`, `parSeqChain_left_inv`, `chiChainProof_commutes_chiConstFlat`):**
   Resolves the `n = 0` `.idExpr` non-inhabitability of `DoubleKernel.GuardedProof`, proves two-sided invertibility of `parSeqChainLR`/`RL` across all `n`, proves elementwise commutation of `chiChainProof` with `OplaxHistory.chiConstFlat` across the right-unit bijection `posChainToFlatSpan`, and requires seam-by-seam `Bij` / Beck–Chevalley guards for `chiChainInvProof`.
3. **Dynamic Sensory+Internal `FiberViabilitySplit` on `WholeBecomingWitness.witnessArchitecture` (`witnessArchitecture_sensory_fiber_split`, `item12_endogenous_emergence_and_oplax_master_bridge`):**
   `u₁ = witnessArchitecture.rOp.state 0` (`x = 21`) and `u₂ = (fun _ => 8, u₁.2)` (`x = 8`) both satisfy `OpenComposition.closedGuard` at `t = 0` and satisfy `witnessSensoryInternalProj u₁ = witnessSensoryInternalProj u₂` by `rfl` (both emit binary warning `(true, true)` under `< 22` and share exact composite state `u₁.2`), yet `u₁` stays in `Viability.Kernel` forever while `u₂` drops `8 → 3 < 8` in 1 step (`¬ Viability.Kernel`), refuting macro soundness via `OplaxHistory.fiberSplit_refutes_macro_viability_soundness`.

---

## 3. Adversarial Critic Findings & Resolutions (`CRITIC-REVIEW.md`)

| Critic Catch (`item12-critic`) | Resolution Implemented in `EndogenousEmergence.lean.txt` |
| :--- | :--- |
| **Blocker 1:** `GuardedProof` has no constructors equating `.assemble S (.idExpr A)` or `.par (.idExpr A) (.idExpr A')` to `.idExpr`, making `n = 0` uninhabited | Replaced with `(n + 1)`-step `seqChainPos` (base `.refl`) + constructive right-unit `SpanHom`/`Bij` (`posChainFlatSpanBij`) to `constFlatSpan _ (n + 1)`. |
| **Blocker 2:** `.adapted (recovered : Bool)` made `OrderUpdater` a sidecar; `own` was hardcoded; Mealy `step` leaked `t = 0` dummy `Obs` | Removed `recovered`; stored live `pos` & `ownHat` in `LearnerState`; drove `.coarse`/`.resolved` via `selectByOrder` (`Weighting.ranksNet`); used Moore machine `UnguidedLoop`. |
| **High 3 & 4:** Drop P2 and Drop P3 were single-learner statements; `x₀ = 9` collapsed before residual | Proved universal theorems over **all** `UnguidedLoop`s for Drop P1, Drop P2 (0-probe + 1-probe `wExoShift` insufficiency), and Drop P3 (`wThinStrain`, `x_plateau = 7`). |
| **High 5:** `OpenComposition.closedGuard` checks exposed `x_crit ≤ st.1` (not hidden `x_hide`), and `funext` uses `Quot.sound` | Proved dynamic `t = 0`-guarded `FiberViabilitySplit` on exposed `x = 21` vs `x = 8` sharing `(opObs, u₁.2)` by `rfl` (`0` axioms). |
| **Audit catch during Lean build:** Non-structural recursion on `T` in `closedOrbit_eq_pureExtract_of_plateau` introduced Lean's `WellFounded` `propext` | Refactored to structural `Nat` induction (`closedOrbit_eq_pureExtract_upto`), bringing `with_axioms` to `{}` across all `100` declarations. |

---

## 4. Exact Verification Command & Output

Reproduce from repository root:

```sh
mkdir -p /Users/ren/tmp/item12-scratch/Becoming && \
cp _process/research/2026-10-05-generative-foundation-review/root-foundation/development/item12-endogenous-emergence-2026-11-24/scratch/Becoming/EndogenousEmergence.lean.txt \
   /Users/ren/tmp/item12-scratch/Becoming/EndogenousEmergence.lean && \
python3 -B experiments/integrated-correction/general-framework/generative-basis/lean/becoming/scratch_build.py \
   /Users/ren/tmp/item12-scratch Becoming.EndogenousEmergence
```

Verbatim output:

```json
{
  "tree": "/Users/ren/tmp/item12-scratch",
  "modules": 239,
  "ran": [
    "Becoming.EndogenousEmergence",
    "BecomingEndogenousEmergenceAxiomAudit"
  ],
  "reused": 238,
  "unclean": [],
  "audits": {
    "Becoming.EndogenousEmergence": {
      "theorems": 42,
      "declarations": 100,
      "with_axioms": {}
    }
  },
  "seconds": {
    "Becoming.EndogenousEmergence": 5.27,
    "BecomingEndogenousEmergenceAxiomAudit": 0.834
  }
}
```

Additional local checks passed:
- `check_becoming` prelude-only (`Init`-only, `import Std` stripped) compile across all `479` steps: `bad_steps: []`, `not_audited_by_name: []`, `forbidden_kinds: []`.
- `python3 tools/research/lean_catalogue.py --check` → `Catalogue matches current source inventory.`
- Forbidden economic-word scan across `item12-endogenous-emergence-2026-11-24/` → `0` matches.

---

## 5. Rule 2 Boundaries — What Remains Unproved

1. **Step of Invariance & One-Way Downstream Dependents (`08 §12` item 12, `07 §4.2`, `07 §4.6` P2/P4):**
   This prototype closes the dynamical formation of a *self-concerned* order over causally returning support (`worldOwnEndo`) under non-myopic greed, and proves that the **same** purely dynamical mechanism leaves one-way downstream dependents (`.downstreamDependent`) at weight `0` and `ownHat = false` forever (`emergent_order_firewall`), never entailing `Unrestricted sig`. How or why a standpoint counts losses that never return to its own continuation remains an offered commitment (`07 §4.2`), not a theorem of survival learning.
2. **Stochastic Noise, Non-Stationary Confounders, and Function-Approximation Leakage:**
   In `wEndo` vs `wExo`, deterministic monotonicity allows a 2-step `.safe` perturbation (`ySafe1 ≤ y`) to separate stationary renewal from exogenous decay cleanly. Under observation noise, periodic exogenous weather, or shared neural features, deterministic 2-step sign checks incur false-positive and false-negative floors requiring multi-step statistical margins (`AlignmentReals` / `ObservationalFidelity`).
3. **Empirical Recognition (`AGENTS.md` Rule 2):**
   That any actual trained AI, market, or institution possesses a pre-collapse sensory strain band (`P1`) wide enough for detection + perturbation (`P3`) and executes uncaptured counterfactual perturbations (`P2`) before crossing no-return is an empirical claim that can fail in practice, not a deductive consequence of Lean.
