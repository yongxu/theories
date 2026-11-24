# Adversarial Critic Review: `PAPER-ATTACK.md` (Item 12 & Guarded-Oplax Unification)

*AI-written (item12-critic helper, 24 November 2026). Pre-Lean adversarial audit of [`PAPER-ATTACK.md`](PAPER-ATTACK.md) against `Becoming/EndogenousOrder.lean`, `Becoming/MasterSpine.lean`, `Becoming/OplaxHistory.lean`, `Becoming/DoubleKernel.lean`, and `theories/becoming/chapters/08-METHOD.md`.*

---

## Executive Verdict

`PAPER-ATTACK.md` has the right core idea (non-myopic strain band + counterfactual verification + `OrderUpdater` reversal + `WholeArchitecture` ↔ `OplaxHistory` unification), **but contains 2 hard Lean blockers, 3 smuggling/sharpness defects in Part A, and 4 type/arithmetic traps in Part B that must be fixed before writing Lean.**

| Severity | Finding | Location in `PAPER-ATTACK.md` | Required Action |
| :--- | :--- | :--- | :--- |
| **BLOCKER** | `GuardedProof (.assemble S (.idExpr A)) (.idExpr (S.obj A))` and `GuardedProof (.par (.idExpr A) (.idExpr A')) (.idExpr (A ⊕ A'))` are **uninhabited** in `DoubleKernel.GuardedProof` (`n = 0` fails!) | §3 Part B.2 (lines 166–171) | Switch `GuardedProof` chains to positive-length `seqChainPos` (`n + 1` steps, base `.refl`), bridged to `constFlatSpan H (n + 1)` via right-unit bijection. |
| **BLOCKER** | `OrderUpdater` is a **decorative sidecar** if `.adapted (recovered : Bool)` drives action choice; `own` is hardcoded rather than derived; `UnguidedLoop` signature `S → Obs → S × Act` needs a `t = 0` dummy `Obs` | §2 Gate F1, §3 A.2 (lines 27, 73–104) | Remove `recovered : Bool`; store live `pos` and `ownHat` in `LearnerState`; select actions purely via decidable `Weighting.ranksNet`; use Moore machine `UnguidedLoop`. |
| **HIGH** | **Drop P2** is non-universal (`probeEnabled = false` on one learner is a strawman; blind panic switching survives $W_{\mathrm{endo}}$!) | §2 Gate F4, §3 A.3 (lines 38–41, 141–143) | Prove universal two-world zero-probe indistinguishability over **all** `UnguidedLoop S Obs Act` separating $W_{\mathrm{endo}}$ from $W_{\mathrm{exo}}$. |
| **HIGH** | **Drop P3** contradicts its own prose: at `x₀ = 9`, collapse happens at `t = 1` *before* any residual; and in §A.3 (`stepStock x .safe = x` for `x ≥ 6`), any post-residual `.safe` survives! | §2 Gate F4, §3 A.3 (lines 42, 144–159) | Prove universal step-margin overshoot (`x_plateau = 7, x_crit = 6, x₀ = 13`, stepping `7 → 4 < 6` while P1 holds at `x = 6`), plus same-world `FiberViabilitySplit` at `(12, s)` vs `(7, s)`. |
| **HIGH** | `witnessArchitecture_hidden_fiber_split` (`x_hide = 8 → 5 < 8`) is unverified against `wG_hide` (`hide_post_viable` forces `wG_hide 6 ≥ 2`), `OpenComponent.hide.guard`, and `h0Init` non-`rfl` equality | §3 Part B.3 (lines 172–174) | Check exact `wSp₁`/`wSp₂` `ExtHide` draw, `wG_hide 5`, and `hide.guard` before freezing numbers; build `u₂` by reusing `u₁.1, u₁.2.1.1, u₁.2.2` for `rfl` projection equality. |
| **MEDIUM** | `evalGuardedExpr (seqChainExpr (.atom H) n) = constFlatSpan H n` is **not** `rfl` for symbolic `n : Nat`; `GuardedProof : Type 1` cannot live in `Type 0` firewall structures; `A.π_causal` acts on `S_op`, not `closedProcess` state; `runToFlatSpan` needs offset recursion | §3 Part B.1–B.2 (lines 163–171) | Prove `evalGuardedExpr` chain equality by induction; keep `GuardedProof` in `Type 1` defs outside `Type 0` structs; apply `span_step_grammar_lumping` to `(CausalSystem.ofOpenComponent ...).proc j`; define `runToFlatSpanFrom r k n`. |
| **MEDIUM** | Metaethical firewall & `08-METHOD.md` scope honesty: `ReadsOnlyDynamics.not_entails` has a different carrier type; missing `initPos`/`base` bounds for `ranksNet_increasingInOwn_of_bounds`; `own` vs `Unrestricted` firewall must stay explicit | §2 Gate F5, §3 A.2 (lines 43–49, 91–104) | Use `ScopeDynamics.scopeLaw_cannot_entail_unrestricted` + `scopeLaw_admits_rival` + `Clearing.center_not_derived`; enforce `base .immYield < initPos .immYield` and `base .downstreamDependent = 0`; state clearly that Item 12's step of invariance remains open. |

---

## Attack 1: Oracle / Sidecar-Order Smuggling (`EmergentLearner` & `OrderUpdater`)

### Flaw 1.1 — Decorative Sidecar `OrderUpdater` via `.adapted (recovered : Bool)`
In `PAPER-ATTACK.md` §A.2 (lines 74–78), `LearnerPhase` includes `.adapted (recovered : Bool)`. Meanwhile `EndogenousOrder.OrderUpdater.ranksAt` (`EndogenousOrder.lean:164–166`) is evaluated externally at time `t : Nat` against an external stream `feedback : Nat → X → Bool`. If the learner selects `.safe` by pattern-matching `phase = .adapted true`, then `OrderUpdater` is an irrelevant post-hoc sidecar rather than the mechanism driving the turn.

**Exact Fix:**
1. Remove `recovered : Bool` from `LearnerPhase`:
   ```lean
   inductive LearnerPhase where
     | coarse (baselineExt : Option Nat)
     | probingSafe (y_strain : Nat)
     | probingVerify (y_strain y_safe1 : Nat)
     | resolved
   ```
2. Store the live internal weight map `pos : EmergenceItem → Nat` directly in `LearnerState` (initialized to `U.initPos`), and update it inside `update` using an endogenous `Obs`-only pulse `pulse : LearnerState → Nat → EmergenceItem → Bool`:
   - `pulse s y .sustainedContinuation = true` iff `s.phase = .probingVerify _ y_safe1` and `y_safe1 ≤ y`;
   - `pulse s y _ = false` for `.immYield` and `.downstreamDependent`.
   - `pos' i := s.pos i + cond (pulse s y i) U.stepGain 0`.
3. In **both** `.coarse _` and `.resolved`, determine the learner's action **purely** by a decidable check of `Weighting.ranksNet U.items s.pos U.base c_ext c_safe`:
   ```lean
   def selectByOrder (U : OrderUpdater EmergenceItem) (pos : EmergenceItem → Nat) : EmergenceAct :=
     if decide (Weighting.weighed U.items pos c_ext + Weighting.weighed U.items U.base c_safe <
                Weighting.weighed U.items pos c_safe + Weighting.weighed U.items U.base c_ext)
     then .safe else .extract
   ```
   (During `.probingSafe` and `.probingVerify` the learner executes its counterfactual `.safe` probe.)
4. Prove the exact lockstep identity along the closed-loop run:
   - `∀ t i, (run t).state.pos i = U.posAt (endogFeedback run) t i`,
   - hence in `.coarse` and `.resolved`, `act (run t).state = .safe ↔ U.ranksAt (endogFeedback run) t c_ext c_safe`.

### Flaw 1.2 — Hardcoded `own .sustainedContinuation = true` & Unchecked `OrderUpdater` Weight Bounds
1. **Smuggling `own`:** Line 92 fixes `own .sustainedContinuation = true` globally, which fails conceptually in $W_{\mathrm{exo}}$ (where `.sustainedContinuation` is *not* causally coupled to the agent's action choice) and bypasses Item 12's question of how a learner's own scope marking forms.
   - **Exact Fix:** Separate:
     * **Objective world coupling** `worldCoupled (W) : EmergenceItem → Bool` (`.sustainedContinuation ↦ true` in $W_{\mathrm{endo}}$, `false` in $W_{\mathrm{exo}}$, `.downstreamDependent ↦ false` in both);
     * **Learner's internal scope marking** `ownHat : EmergenceItem → Bool` stored in `LearnerState`, initialized at `t = 0` to `fun i => match i with | .immYield => true | _ => false` (`ownHat₀ .sustainedContinuation = false`!), updated purely from sensed counterfactual pulses (`ownHat' i := s.ownHat i || pulse s y i`).
     * Neither `act` nor `update` reads `worldCoupled W`! Yet for `t ≥ 4`, prove `ownHat_t = worldCoupled W` AND `Weighting.IncreasingInOwn U.items (worldCoupled W) (U.ranksAt endogFeedback t)` in **both** $W_{\mathrm{endo}}$ and $W_{\mathrm{exo}}$.
2. **Missing bounds for `ranksNet_increasingInOwn_of_bounds` (`EndogenousOrder.lean:284–288`):**
   `ranksNet_increasingInOwn_of_bounds` requires:
   - `ownPos : ∀ x ∈ items, own x = true → base x < pos x`,
   - `offBase : ∀ y ∈ items, own y = false → base y ≤ pos y`.
   `PAPER-ATTACK.md` never fixes `initPos`/`base` for `.immYield` or `.downstreamDependent`.
   - **Exact Fix:** Explicitly set:
     * `.immYield`: `initPos = 1`, `base = 0` (so `0 < 1` satisfies `ownPos` from `t = 0`),
     * `.sustainedContinuation`: `initPos = 0`, `base = 1`, `stepGain = 2` (so at `t = 0`, `0 < 1` strictly ranks `c_ext` over `c_safe`; after 1 pulse, `1 < 2` strictly ranks `c_safe` over `c_ext` and satisfies `ownPos`!),
     * `.downstreamDependent`: `initPos = 0`, `base = 0` (so `0 ≤ 0` satisfies `offBase` forever, keeping `IncreasingInOwn` globally valid while leaving widening by `.downstreamDependent` unranked forever via `Weighting.ranksNet_ties`).

### Flaw 1.3 — `UnguidedLoop` Timing & `t = 0` Observation Leak
Line 27 defines `step : S → Obs → S × Act`, but the trace in lines 122–137 plays `a₀ = .extract` **before** observing `y₀ = sense x₁ a₀`. A Mealy signature `S → Obs → S × Act` forces a synthetic `Obs₀` at `t = 0` (which risks leaking `x₀`).

**Exact Fix:** Define `UnguidedLoop` as a strict **Moore machine**:
```lean
structure UnguidedLoop (S Obs Act : Type) : Type where
  init : S
  act : S → Act
  update : S → Obs → S
```
Closed-loop step from `(x, s)`:
- `a := L.act s`,
- `x' := W.stepStock x a`,
- `y := W.sense x' a`,
- `s' := L.update s y`.
Then `unguided_obs_lockstep` holds cleanly by induction on `t`: if `∀ k < t, y₁ k = y₂ k`, then `s₁ t = s₂ t` and `a₁ t = a₂ t` (at `t = 0`, `s₁ 0 = L.init = s₂ 0` with zero observations read!).

### Flaw 1.4 — Residual Test Consistency & $W_{\mathrm{exo}}$ Floor Degeneracy
1. Lines 34 & 128 write `y_t ≠ baselineExt` while line 76 writes `y < baselineExt`. Pick one and stick to it: `y ≠ baselineExt` directly expresses violation of stationary right-determinism (matching Gate F3).
2. In $W_{\mathrm{exo}}$, if stock ever hits the floor `0` during the 2-step `.safe` probe (`x₃ = 0, x₄ = 0`), then `y₂ = sense 0 .safe = y₃`, making `y₂ ≤ y₃` falsely true! In the witness (`x₀ = 14`), `x₂ = 10 → x₃ = 8 → x₄ = 6`, so `y₂ = 9 > 7 = y₃` cleanly avoids the floor. In any general theorem over $W_{\mathrm{exo}}$, explicitly assume strict sensory decline during the probe (`y_safe2 < y_safe1`).

---

## Attack 2: Premise Independence & Sharpness (P1, P2, P3 & Gate F3)

### Flaw 2.1 — Drop P1 Scope Guard
Line 37 claims every `UnguidedLoop` fails under a silent cliff (`sense x a = plateau a` for all `x ≥ x_crit`), omitting the obvious counterexample of a **blind constant-`.safe` loop** (`act _ = .safe`) that never extracts even on an infinite plateau.

**Exact Fix:** State the universal Drop P1 theorem sharply:
- For **every** `L : UnguidedLoop S Obs EmergenceAct`, as long as `∀ k < t, x_crit ≤ x_k` (for post-step `sense`, `∀ k ≤ t, x_crit ≤ x_k` for `k < t`, i.e., `∀ k, 1 ≤ k → k ≤ t → x_crit ≤ x_k`), `L`'s state and action at step `t` in the silent-cliff world are **identical** to its infinite-plateau trajectory (`sense_inf _ a = plateau a`).
- Corollary: for **every** `L` whose infinite-plateau run plays `.extract` (e.g., any greedy plateau loop), `L` inevitably crosses `x < x_crit` (`x₅ = 3 < 6` from `x₀ = 14`) with zero prior residual.

### Flaw 2.2 — Drop P2 Is Non-Universal & Vulnerable to Blind Panic Switching
`PAPER-ATTACK.md` lines 141–143 weaken Drop P2 to setting `probeEnabled = false` on *one* learner. Worse, an unprobing **blind panic switcher** (`if y ≠ baseline then always .safe`) *does* survive in $W_{\mathrm{endo}}$! Why is counterfactual perturbation (P2) genuinely necessary? Because without probing, **no** unguided loop can separate $W_{\mathrm{endo}}$ from $W_{\mathrm{exo}}$: a blind panic switcher wrongfully sacrifices `3` yield/step in $W_{\mathrm{exo}}$ while still crashing at the exact same time.

**Exact Fix — Universal Two-World Zero-Probe Impossibility:**
1. Prove universally for **all** `L : UnguidedLoop S Obs EmergenceAct` and all `T` before collapse:
   - If `∀ t < T, act_endo L t = .extract` (zero counterfactual `.safe` perturbations before `T`), then `state_endo L T = state_exo L T` and `act_endo L T = act_exo L T` (even though at `t = 1` both worlds already emitted the identical nonzero residual `14 ≠ 16`!).
   - Consequently, **no** `UnguidedLoop` can simultaneously choose `.safe` at step `T` in $W_{\mathrm{endo}}$ and keep `.extract` at step `T` in $W_{\mathrm{exo}}$ without previously taking at least one `.safe` action (`∃ k < T, act_endo L k = .safe`).
   - In particular, any unguided learner that never plays `.safe` in $W_{\mathrm{exo}}$ never plays `.safe` in $W_{\mathrm{endo}}$ and crashes to `x < x_crit`.
2. Pair this with our probing `EmergentLearner`, which executes the 2-step `.safe` counterfactual probe and **strictly separates** both worlds for all `t ≥ 4`:
   - in $W_{\mathrm{endo}}$: `act t = .safe` forever, `x_t = 10 ≥ 6` (`Viability.Kernel`), `ownHat_t = worldCoupled W_endo`, `IncreasingInOwn`;
   - in $W_{\mathrm{exo}}$: `act t = .extract` for all `t ≥ 4` (zero false-positive turn), `ownHat_t = worldCoupled W_exo`.
3. *(Optional sharpness bonus)* A shifted exogenous world $W_{\mathrm{exo}}'$ with `sense' x .safe = min x 12 + 3` (still `< min x 12 + 4` everywhere!) produces the **exact same** 1-step probe return `11` at `t = 2` as $W_{\mathrm{endo}}$, proving that even 1-step probing is insufficient without prior knowledge of `sense(_, .safe)`'s vertical offset — making the 2-step probe (`y_safe2 ≥ y_safe1`) information-theoretically minimal.

### Flaw 2.3 — Drop P3 Contradicts Its Own Concrete Arithmetic
Line 42 states: *"residual detection begins, yet the substrate crosses `x < x_crit` before counterfactual probing and order shift complete."*
Check §A.3's concrete witness (`x_crit = 6, draw .extract = 3, draw .safe = 1, g(z) = if 5 ≤ z then 1 else 0`):
- At `x₀ = 9` (lines 148–151): `t = 0` gives `x₁ = 7, y₀ = 11` (recorded as `baselineExt = some 11`), and `t = 1` drops `x₂ = 4 < 6` **before any residual fires**!
- Even worse: because `stepStock x .safe = (x - 1) + 1 = x` for **every** `x ≥ 6`, once a residual fires at ANY `x ≥ 6`, switching immediately to `.safe` on the next step **always survives**! So the prose of line 42 is **false** for §A.3's dynamics!

**Exact Fix — Make Drop P3 Universal AND Consistent:**
Replace line 42's claim with the exact **Universal Strain-Band Step-Margin Impossibility**:
1. Keep `x_crit = 6`, `draw .extract = 3`, `draw .safe = 1`, `g`, and `sense x a = min x x_plateau + offset a`, but tighten `x_plateau := 7` (`x_plateau - x_crit = 1 < 3 = draw .extract`).
   - **P1 STILL holds strictly:** `x_crit = 6 < 7 = x_plateau` and `sense 6 .extract = 10 < 11 = plateauYield .extract`!
   - Starting from the plateau at `x₀ = 13`:
     * `t = 0`: `13 → 11`, `y₀ = 11`,
     * `t = 1`: `11 → 9`, `y₁ = 11`,
     * `t = 2`: `9 → 7`, `y₂ = 11`,
     * `t = 3`: `7 → (7 - 3) + 0 = 4 < 6 = x_crit`!
   - Because `x_plateau - x_crit < netDrop(.extract)`, the trajectory **overshoots the entire strain band in a single step** while every prior observation equals `11 = plateau`. By `unguided_obs_lockstep`, this crashes **every** plateau-extracting `UnguidedLoop S Obs EmergenceAct` (not just one learner!).
2. Keep the same-world (`x_plateau = 12`) initial-margin failure at `(7, .coarse (some 16))` alongside `(12, .coarse (some 16))` as the clean **`OplaxHistory.FiberViabilitySplit`** witness on the emergent closed-loop process `P_emergent` under `π_internal (x, s) := s`!

### Flaw 2.4 — Gate F3 (`«像定后当且仅当同行»`) Applies to State Projection `π₀`, Not `M₀`
`OplaxHistory.span_step_grammar_lumping` (`OplaxHistory.lean:1511–1514`) takes a `Process S A` and a **state projection `π : S → Q`**, NOT an observation predictor `M₀`.

**Exact Fix:** Instantiate `span_step_grammar_lumping` directly on the closed-loop emergent process `P_emergent` (state `Nat × LearnerState`) with `π₀ (x, s) := s`:
- `u₁ = (14, .coarse (some 16))` steps to `(12, .coarse (some 16))` (`π₀ = .coarse (some 16)`),
- `u₂ = (12, .coarse (some 16))` steps to `(10, .probingSafe 14)` (`π₀ = .probingSafe 14`),
- `π₀ u₁ = π₀ u₂` yet `π₀ u₁' ≠ π₀ u₂'`, directly witnessing `¬ «定后» («像» π₀ R)` and hence `¬ «同行» R (fun u v => π₀ u = π₀ v)` via `span_step_grammar_lumping`!

---

## Attack 3: Metaethical Firewall (`not_entails`) & `08-METHOD.md` Scope Honesty

### Flaw 3.1 — Wrong Firewall Theorem Signature (`ReadsOnlyDynamics.not_entails`)
Line 49 says: *"`ReadsOnlyDynamics.not_entails` and `ScopeDynamics.scopeLaw_cannot_entail_unrestricted` hold for any satisfied dynamical law on the emergent system."*
- `ReadsOnlyDynamics.not_entails` is typed on `ReadsOnlyDynamics`, NOT on a custom `EmergentSystem`.
- In `EndogenousOrder.lean:3548–3568`, the reusable firewall theorems are `ScopeDynamics.scopeLaw_admits_rival` and `ScopeDynamics.scopeLaw_cannot_entail_unrestricted`, paired with `Clearing.center_not_derived` (`EndogenousOrder.lean:537–548`).

**Exact Fix:**
1. Package Part A's complete emergent system in a `Type 0` structure `EmergentOrderSystem` (no `Type 1` `GuardedProof` fields inside it!).
2. Prove for any `Law : EmergentOrderSystem → Prop` satisfied by the witness:
   - `ScopeDynamics.scopeLaw_admits_rival Law holds ...` (admits bounded rival significance excluding `.downstreamDependent`),
   - `ScopeDynamics.scopeLaw_cannot_entail_unrestricted Law p f holds`,
   - `Clearing.valuation.Held ∧ ¬ Clearing.valuation.Significant`,
   - `∀ t, posAt t .downstreamDependent = 0`, `∀ t, ownHat t .downstreamDependent = false`, and `∀ t, ¬ U.ranksAt endogFeedback t c_safe c_full ∧ ¬ U.ranksAt endogFeedback t c_full c_safe` (via `EndogenousOrder.uncoupled_blindness_firewall` with `base .downstreamDependent = 0`).
3. **Scope honesty (`08-METHOD.md:778, 801–804`):** State explicitly in the docstrings and records that Part A closes the dynamical formation of a **self-concerned** order over causally returning support (`own` / `worldCoupled`), and does **not** settle the step of invariance (`Unrestricted`), `07 §4.6`'s P2/P4, or concern for one-way downstream dependents. Never call `worldCoupled` or `ownHat` "normative significance".

---

## Attack 4: Part B Type, Universe, and Proof Traps (`WholeArchitecture` ↔ `OplaxHistory` / `GuardedProof`)

### Flaw 4.1 (HARD BLOCKER) — `chiChainProof`, `chiChainInvProof`, `parSeqChainLR/RL` Are Uninhabited at `n = 0`!
Look at the constructors of `DoubleKernel.GuardedProof` (`DoubleKernel.lean:1614–1645`):
`refl`, `trans`, `seqCong`, `parCong`, `assembleCong`, `parSeqDistLR`, `parSeqDistRL`, `chiStep`, `chiInv`.

Check the `n = 0` base cases of the definitions proposed in `PAPER-ATTACK.md` lines 168–171:
1. `chiChainProof S e 0` requires:
   `GuardedProof (.assemble S (.idExpr A)) (.idExpr (S.toFunctor.obj A))`
   — **UNINHABITED!** No constructor in `GuardedProof` relates `.assemble S (.idExpr A)` to `.idExpr (S.toFunctor.obj A)`.
2. `parSeqChainLR e₁ e₂ 0` requires:
   `GuardedProof (.par (.idExpr A) (.idExpr A')) (.idExpr (Sum A A'))`
   — **UNINHABITED!** No constructor in `GuardedProof` relates `.par (.idExpr A) (.idExpr A')` to `.idExpr (Sum A A')`.

**Exact Fix:**
Define **positive-length** (`n + 1`-step) chains with zero `.idExpr` terms:
```lean
def seqChainPos {S : Type} (e : DoubleKernel.GuardedExpr S S) : Nat → DoubleKernel.GuardedExpr S S
  | 0 => e
  | n + 1 => .seq e (seqChainPos e n)
```
Then EVERY single inductive `GuardedProof` typechecks cleanly with base case `.refl`:
- `chiChainProof S e 0 := .refl (.assemble S e)`
- `chiChainProof S e (n + 1) := .trans (.chiStep S e (seqChainPos e n)) (.seqCong (.refl (.assemble S e)) (chiChainProof S e n))`
- `chiChainInvProof S e 0 _ := .refl (.assemble S e)`
- `chiChainInvProof S e (n + 1) b := .trans (.seqCong (.refl (.assemble S e)) (chiChainInvProof S e n ...)) (.chiInv S e (seqChainPos e n) ...)`
- `parSeqChainLR e₁ e₂ 0 := .refl (.par e₁ e₂)`
- `parSeqChainLR e₁ e₂ (n + 1) := .trans (.parSeqDistLR e₁ (seqChainPos e₁ n) e₂ (seqChainPos e₂ n)) (.seqCong (.refl (.par e₁ e₂)) (parSeqChainLR e₁ e₂ n))`
- `parSeqChainRL e₁ e₂ 0 := .refl (.par e₁ e₂)`
- `parSeqChainRL e₁ e₂ (n + 1) := .trans (.seqCong (.refl (.par e₁ e₂)) (parSeqChainRL e₁ e₂ n)) (.parSeqDistRL e₁ (seqChainPos e₁ n) e₂ (seqChainPos e₂ n))`

Then bridge `constFlatSpanPos H n` (`0 => H`, `n + 1 => compSpan H (constFlatSpanPos H n)`) to `OplaxHistory.constFlatSpan H (n + 1)` via a constructive right-unit `SpanHom` isomorphism (stripping/adding the trailing `idSpan S`), and prove `evalGuardedProof (chiChainProof S (.atom H) n)` commutes with `OplaxHistory.chiConstFlat S.toFunctor H (n + 1)` under that isomorphism!

### Flaw 4.2 — `evalGuardedExpr` Chain Equality Is Not `rfl`; Universe-Level Hygiene (`Type 1`)
1. Line 169 claims `evalGuardedExpr (seqChainExpr (.atom H) n) = OplaxHistory.constFlatSpan H n` holds by **definitional `rfl`**. For symbolic `n : Nat`, both sides pattern-match `n`, so it is **not** `rfl` — prove it by induction on `n` (`0 => rfl`, `n + 1 => congrArg (OplaxHistory.compSpan H) (ih)`).
2. `GuardedExpr : Type → Type → Type 1` and `GuardedProof : ... → Type 1` (`DoubleKernel.lean:1592, 1614`). Keep them as top-level `def`s (or inside `Prop` existential statements) and **never** embed them inside any `Type 0` structure passed to `ScopeDynamics.scopeLaw_cannot_entail_unrestricted`.

### Flaw 4.3 — `runToFlatSpan` Recursion Direction & `A.causal_goAlike` Carrier Mismatch
1. **`runToFlatSpan` direction:** `OplaxHistory.constFlatSpan H (n + 1) = compSpan H (constFlatSpan H n)` peels the **first** step (`0 → 1`) on the left (`OplaxHistory.lean:1080`). Define an offset-indexed version returning a bundled endpoint record:
   `runToFlatSpanFrom (r : Run P) (k n : Nat) : { w : (constFlatSpan (processStepSpan P) n).W // left w = r.state k ∧ right w = r.state (k + n) }`
   so `runToFlatSpan r n := (runToFlatSpanFrom r 0 n).1` avoids mutual recursion and needs zero `Run.shift` boilerplate.
2. **`A.causal_goAlike` carrier mismatch (`MasterSpine.lean:1330–1334`):**
   `A.π_causal : S_op → QCausal` projects the **open component state `S_op`** of `CausalSystem.ofOpenComponent A.compOp A.cOp.tol`, NOT the closed-loop state `(Site → Nat) × S_op` of `OpenComposition.closedProcess A.compOp ...`!
   - **Exact Fix:** Apply `OplaxHistory.exactAbsChainMap` and `OplaxHistory.span_step_grammar_lumping` to the input-indexed processes `(CausalSystem.ofOpenComponent A.compOp A.cOp.tol).proc j` for every input `j`.

### Flaw 4.4 — Unverified Arithmetic & Guard Traps in `witnessArchitecture_hidden_fiber_split`
Line 174 asserts that `u₂` (`x_hide = 8`, same exposed state as `u₁ = witnessArchitecture.rOp.state 0`) satisfies `OpenComposition.closedGuard` at `t = 0` and drops to `x_hide = 5 < 8` in 1 step, with zero `propext` or `Classical.choice`. **Verify three concrete hazards in `MasterSpine.lean` (around lines 3180–3255) before writing Lean:**

1. **Exact `wG_hide 5` and `wSp₁ + wSp₂` `ExtHide` draw:**
   In `MasterSpine.lean:769–770, 3268`, `wCLeft` has `x_crit_hide = 8`, `H_safe_hide = 2`, `x₀_hide = 11`, and `hide_post_viable` forces `8 ≤ (8 - 2) + wG_hide 6`, i.e., **`wG_hide 6 ≥ 2`**.
   - Check the actual pre-alarm `ExtHide` draw `d_pre` of `wSp₁` + `wSp₂` at `(((), 1), ((), 1))`:
     * If `d_pre = 3` and `wG_hide 5 = 0`, then `x_hide' = 5 < 8` (exact!).
     * If `d_pre = 3` and `wG_hide 5 = 2`, then `x_hide' = 7 < 8` (still crashes, but `7`, not `5`!).
     * If `d_pre ≤ 2`, then `8 - d_pre ≥ 6` and `wG_hide 6 ≥ 2`, so **`x_hide = 8` WOULD NOT CRASH AT ALL**! Verify `d_pre` and `wG_hide` before committing to `x_hide = 8 → 5`.
2. **Verify `OpenComponent.hide.guard`:** Confirm that `OpenComposition.closedGuard` on `wholeSealedLeft` checks only `∀ k, x_crit_hide k ≤ x_hide k` (and `inner.guard`), with no extra `eta * preCap` margin inside `guard`; otherwise `x_hide = 8` would already fail `closedGuard` at `t = 0`.
3. **Zero-`funext` / Zero-`propext` construction of `u₂`:**
   - Do **not** construct `u₂` from scratch with a fresh `fun _ => 20`; instead reuse `u₁`'s exact components:
     `def u₂ := (u₁.1, ((u₁.2.1.1, fun _ => 8), u₁.2.2))`
     with `def π_exposedOnly (u : (Unit → Nat) × WOpS) := (u.1, (u.2.1.1, u.2.2))`.
     Then `π_exposedOnly u₁ = π_exposedOnly u₂` holds by **`rfl`** (zero `funext`, zero `propext`, zero `Classical.choice`!).
   - Note that `(witnessArchitecture.rOp.state 0).2 = wInitOp` is proved **propositionally** (`h0Init` in `MasterSpine.lean:1271`), not by `rfl`. Rewrite `u₁.2.1.1` and `u₁.2.2` using `h0Init` when computing the 1-step transition `step u₂ ((), (((), ()), ())) u₂'`, avoiding any `funext` on `u₁.1`.

---

## Recommended Revised Proof Plan (Before Writing Lean)

1. **Part A (`EmergentLearner` + Universal 3-Way Necessity & Sufficiency):**
   - Moore machine `UnguidedLoop S Obs Act` + `unguided_obs_lockstep`.
   - `LearnerState` stores `(phase, pos, ownHat)` with NO `recovered : Bool`; `selectByOrder` evaluates `Weighting.ranksNet` in `.coarse` and `.resolved`; `initPos = (1, 0, 0)`, `base = (0, 1, 0)`, `stepGain = 2`.
   - Prove **sufficiency** in $W_{\mathrm{endo}}$ (`x₀ = 14`): residual split at `t = 1` (witnessing `¬ «同行»` via `OplaxHistory.span_step_grammar_lumping` on `π₀ (x, s) := s`), 2-step counterfactual `.safe` probe at `t = 2, 3`, `ownHat_t = worldCoupled W_endo` and `IncreasingInOwn` for `t ≥ 4`, eternal `Viability.Kernel` at `x_t = 10 ≥ 6`.
   - Prove **universal necessity** of ALL THREE premises over arbitrary `UnguidedLoop S Obs EmergenceAct`:
     * **Drop P1 (Silent Cliff):** plateau lockstep → every plateau-extracting loop crosses `x < 6`.
     * **Drop P2 (Zero Counterfactual Probe):** $W_{\mathrm{endo}}$ vs $W_{\mathrm{exo}}$ lockstep → no loop distinguishes them before taking `.safe`; whereas our probing learner separates them (`act_endo = .safe`, `act_exo = .extract` for `t ≥ 4`).
     * **Drop P3 (Insufficient Strain-Band Headroom):** `x_plateau = 7, x_crit = 6, x₀ = 13` (P1 holds strictly at `x = 6`) → every plateau-extracting loop steps `7 → 4 < 6` before any residual; plus same-world `FiberViabilitySplit` at `(12, s)` vs `(7, s)`.
   - Prove **Metaethical Firewall** on `Type 0` `EmergentOrderSystem`: `posAt t .downstreamDependent = 0`, `ownHat t .downstreamDependent = false`, unranked widening (`uncoupled_blindness_firewall`), `ScopeDynamics.scopeLaw_admits_rival`, `ScopeDynamics.scopeLaw_cannot_entail_unrestricted`, `Clearing.center_not_derived`.
2. **Part B (`WholeArchitecture` ↔ `OplaxHistory` / `DoubleKernel.GuardedProof`):**
   - `runToFlatSpanFrom` lifting `Run P` and `A.rOp` into `constFlatSpan (processStepSpan P) n` with vertex-wise `Viability.Kernel` and `ReadOffExchange`.
   - `A.causal_goAlike` → `OplaxHistory.exactAbsChainMap` & `span_step_grammar_lumping` on `(CausalSystem.ofOpenComponent A.compOp A.cOp.tol).proc j`.
   - Positive-length `seqChainPos`, `chiChainProof`, `chiChainInvProof`, `parSeqChainLR`/`RL` in `Type 1`, plus right-unit bijection to `constFlatSpan H (n + 1)` and `chiConstFlat`.
   - Verify `wG_hide 5`, `d_pre`, and `hide.guard` in `MasterSpine.lean`, then prove `witnessArchitecture_hidden_fiber_split` using `u₂ := (u₁.1, ((u₁.2.1.1, fun _ => 8), u₁.2.2))` (`π_exposedOnly` equal by `rfl`).
