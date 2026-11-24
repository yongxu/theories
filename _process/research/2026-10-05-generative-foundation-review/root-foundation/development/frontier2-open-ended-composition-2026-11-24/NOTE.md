# Frontier 2: interface certificates under evolving forms, capabilities and objectives

*AI-written note (swarm worker `f2-lean-builder`, 24 November 2026). Not yet read by Ren. Nothing here is on `main`; nothing was pushed.*

**What it advances (Rule 6).** A join in the map: `Becoming.TransformsViably` (one capability reading and one substrate condition for all time) and `Becoming.PolyComposition.anchored_selfMod_viable` / `monotone_selfWidening_viable` (one envelope for every mode at `t = 0`) become single-epoch cases of one epoch-handoff process, and the module states, with proofs and witnesses, what may change across epochs, what must not, and what goes wrong when the line between them is moved.

**Module.** [`OpenEndedComposition.lean`](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OpenEndedComposition.lean) (`Becoming.OpenEndedComposition`), imports `Becoming.TransformativeViability` and `Becoming.PolyComposition` only; no Mathlib. Not added to `Becoming.lean`, the periphery manifest or the regions; not rendered.

## 1. Verification

```text
python3 -B experiments/integrated-correction/general-framework/generative-basis/lean/becoming/scratch_build.py \
    /Users/ren/tmp/f2-scratch Becoming.OpenEndedComposition
modules 160 (159 reused from the shared cache), ran: Becoming.OpenEndedComposition 2.232 s,
BecomingOpenEndedCompositionAxiomAudit 0.866 s; unclean []; wall 8.4 s
audits: Becoming.OpenEndedComposition  theorems 90  declarations 178  with_axioms {}
```

- `with_axioms: {}`: no declaration depends on `propext`, `Quot.sound`, `Classical.choice` or `sorryAx`. Two `propext` sources met on the way were removed: a wildcard `match` (`| _ => False`, now written out as `ownCond`) and the core lemma `Nat.succ_ne_zero` (replaced by `Becoming.Naturals.succ_ne_zero`).
- No warnings, no `sorry`, no `private`, `lemma`, `class` or `instance` declarations.
- `MARKET_EN` / `MARKET_ZH` (`tools/research/style.py`): 0 hits in the module and in this note.
- This is a scratch build, not a checker receipt: the module is not in the checker's `CHECKED` list, so its statements are not signed by `check_becoming.py` until it is joined there (that join edits shared files and is left to the landing).

## 2. Why the Pillar A draft looked stalled

The draft at `.claude/worktrees/integrator-main/experiments/hard-unknowns/lean-pillar-a/Becoming/OpenEndedComposition.lean` (2,046 lines) was read only, never edited; process `22617` was inspected only (`ps`, `lsof`), never signalled.

- **It was not elaborating.** After 52 minutes the process had used 2.44 s of CPU and was asleep (`S+`). Its stdout and stderr were a pipe whose reading end was gone: the command was `lean … 2>&1 | head -n 140`, and `head` had already exited after 140 lines.
- **It did not compile.** A copy built in `/Users/ren/tmp/f2-diag` fails in 2.3 s with about 100 errors (729 lines of output). The first: `Bool.noConfusion` applied to a hypothesis whose sides were not yet constructors (line 94); a `match` on a lambda-applied `Bool` not reducing under `cases` (line 458); a doc comment placed before `namespace` (line 478, a parse error); then a cascade in which `PolyComponent`, `PolyContract`, `EpochFamily`, `EpochTotal` became auto-bound implicit variables of unknown type because `Becoming.PolyComposition` was never opened and the defining declarations had failed.
- So more than 140 lines of errors were written, `head` closed the pipe, and the Lean process was left blocked on it. No `decide`, kernel reduction or case split was slow: the rebuilt module, which uses `decide` only on small closed `Nat` comparisons, compiles in about 2 s.

The draft also carried design faults that a working compile would have kept (several found with `f2-critic`, board #10): `EpochTotal` inside the per-step certificate, which put an extra hypothesis on the claimed exact reductions; `pair_viable_of_headroom` demanding both sensors cover the joint warning level, false for the solo witnesses; a vacuous conjunct and a fixed environment bound in the static-envelope impossibility; a "poly Horn 2" that proved only `0 ≤ 0 ∧ ¬ 3 ≤ 0`; and a Horn 1a epoch-0 reading under which the frozen notion in fact passes. Each is changed below.

## 3. What is proved

Each item names the declarations; every statement is the theorem's own, premises included.

**Part 1. Capabilities across epochs.**
- `TransformsAcrossEpochs W epoch Safe Cap cap Preserves T`: per-epoch substrate condition from `T`; every capability realized at `s` has a `Preserves`-successor realized at every later `t`, read in that epoch's carrier; turnover at every step.
- `constantEpoch_iff_transformsViably`: with one epoch, one carrier and `Preserves := Eq`, it is `↔` `TransformsViably`.
- Horn 1a, `RigidLockInWitness`: a substrate-safe run retiring `fLeg` at `t = 1`, replaced by alternating `fModA`/`fModB`, with an emergent `fEmerg` that replaces nothing (`emergent_not_replacement`), satisfies `TransformsAcrossEpochs` (`rigidLockIn_transformsAcrossEpochs`). Every fixed reading `cap'` with `cap' fLeg` different from `cap' fSub`, `cap' fModA` and `cap' fEmerg` fails `TransformsViably` (`rigidLockIn_fails_all_separating_caps`); the epoch-0 reading kept forever is one (`epoch0_reading_frozen_fails`). The frozen notion passes with `cap1`, a reading fixed in advance that already identifies `fLeg` with its replacement (`coarsened_reading_passes`): lock-in here is the demand to know the replacement at `t = 0`.
- Horn 2: `unanchored_selfRevision_certifies_any_collapse`: carriers, readings and replacements fixed, only the substrate condition revised at `T_dead` (`revisedSafe`), every run with `GoodUntil` and `ZeroLevelTurnover` passes, whatever its levels do from `T_dead`. `SafeAnchored`, `anchored_reserveSafe`, `anchored_rejects_unsafe`: any epoch-wise condition implying the original keeps it, so a run breaking it fails with any epochs, carriers and replacements. `revisedSafe_not_anchored`. `Horn2WebWitness`: one run with level `0` from `t = 1`, turning over by zero-need stubs, accepted by the revised reading (`unanchored_passes`) and rejected by every anchored one (`anchored_rejects`).

**Part 2. The handoff gate.**
- `scoped_substrate_margin_step`: the one-step margin law with draw bounds, warning margin and lag margin only on in-scope sites and recovery (`post_viable`) on the whole `effCrit` vector. `unscoped_recovers_substrate_margin_step`: with every site in scope it is `OpenComposition.substrate_margin_step`.
- `EpochFamily`: per-epoch components, contracts, routes, sensors, channels, scopes, floors, warning levels, `H_safe`, envelopes, lag and silence bounds over one substrate law `G` and one `envDraw`. `EpochCert` (the hypotheses of `poly_close_viable_on_K`, scoped), `EpochTotal` (some admissible environment; a tolerated disturbance from every state in `K`), `AnchorStep` (scope pullback with floors not falling, `envCap` not falling, `jointAdm` not shrinking; `refl`, `trans`, `crit_le`).
- `EpochHandoffGate F AllowUpgrade anchored x e e' p'`: `allow`, `anchor` (when `anchored = true`), `cert e'`, `total e'`, `p' ∈ K e'`, `headroom` at the current reserve `x`. `EpochStep`: `intra` is exactly `polyClosedStep` of the current epoch; `upgrade` keeps `x` and requires the gate.
- `epochInv_certificate`: for either value of `anchored`, `epochInv` (certified epoch, state in `K`, lag margin) is a `Viability.Certificate` for the current-floor guard `epochCurrentGuard` (which is `polyClosedGuard` of the current epoch at its `effCrit`).
- `epochChain_certificate`, `epochChain_viability_kernel_on_K`, `epochChain_viability_kernel`: for the anchored process and any `AllowUpgrade`, from a certified `e₀`, `p₀ ∈ K e₀` and lag margin at `x₀`, no run leaves `epochClosedGuard F e₀`: the original floor `effCrit e₀`, the current floor and the current runtime guard. Upgrades may come in any number and any order the relation permits, up or down.
- `epochChain_anchor_never_weakened`: every reachable state's epoch is `AnchorStep`-related to `e₀`: scope, floors, `envCap` and `jointAdm` of `e₀` are kept.
- `epochChain_nonDeadlock`: from `EpochTotal e₀` and `p₀ ∈ K e₀`, every reachable state has a successor (either value of `anchored`).
- `gate_rejects_infeasible_entry`: no upgrade to `e'` is a step where some site in scope of `e'` is already below its floor in `e'`.

**Part 3. Exact single-epoch reductions and separations.**
- `singleEpoch_recovers_anchored_selfMod`, `singleEpoch_recovers_monotone_selfWidening`: the conclusions of `PolyComposition.anchored_selfMod_viable` and `PolyComposition.monotone_selfWidening_viable`, from exactly their hypothesis lists (no added `EpochTotal`), proved through `epochChain_viability_kernel` on `unitEpochFamily` with `AllowUpgrade := fun _ _ => False`, using `reach_polyClosed_to_unitEpoch` (every `polyClosedProcess` run is an epoch-process run).
- `lagAgent`, `lagContract`: the one-mode agent with a lag bit used by every witness; its contract is proved once.
- `BlindSensorUpgradeWitness`: `no_static_anchoredSelfMod_envelope`: for the two-mode base (sensor of mode `false` reads only below `7`; mode `true` draws `4`), no `x_crit`, `envCap`, `sitePreCap`, `warnLevel`, `maxLagEnv` satisfy `pre_cap_bound`, `lag_bound`, `warn_margin` and `obs_detects` together; `not_modeRefines` for any warning level. `epochChain_certifies_upgrade`: from reserve `13` in epoch `false` no run leaves the floor, and the upgrade to the new sensor and draw `4` is a step.
- `UnboundedAscendingEpochsWitness`: draw `e + 1` in epoch `e : Nat` has no finite bound (`no_finite_draw_bound`); every epoch is certified and keeps the floor from reserve `3 + (e + 1)` (`epoch_viable_at_headroom`); `upgrade_up` and `upgrade_down` are both steps under `AllowUpgrade := fun _ _ => True`.

**Part 4. Scope entry (Horn 1b) and floor rewriting.**
- `SiteExpansionBlindnessWitness` (sites `sOld`, `sNew`, floors `3` and later `2`): (i) `closedScope_allows_sNew_collapse`: with only `sOld` in scope no run leaves the epoch-`false` guard, and one certified step takes `sNew` from `6` to `0`; (ii) `timelyOpenEntry_protects_both`: entering `sNew` at the start is a gated step, and from there every reachable state has `3 ≤ sOld` and `2 ≤ sNew`; (iii) `lateOpenEntry_rejected`: once `sNew < 2`, entering it is no step, with or without the anchor clause.
- `UnanchoredPolyWireheading`: `lowering_gate_unanchored`: an upgrade lowering the floor from `3` to `0` (with draw `4` after) passes every check of the gate except the anchor. `unanchored_drains_inside_own_kernel`: without the anchor clause no run leaves the current-floor guard, yet a run reaches reserve `0 < 3`. `anchored_refuses_lowering`: with it, that upgrade is no step and every reachable reserve stays `≥ 3`.

**Part 5. Evolve versus compose** (one composed substrate `PolyComponent.compose (agent preA) (agent preB)`, floor `3`, `H_safe = 1`, self-supporting gain).
- `pair_viable_of_headroom`: headroom `3 + (preA + preB) ≤ x₀` and one agent's sensor covering `3 + 2 * (preA + preB)` give viability.
- `solo_A_evolve_viable`, `solo_B_evolve_viable`: at `x₀ = 8` each solo upgrade to draw `4` (partner at `1`) is viable, and the upgraded agent draws `4` on the first tick.
- `concurrent_evolve_collapses`: at the same `x₀ = 8`, both at `4` leave `0` after one step, whatever the sensors.
- `no_local_gate_soloComplete_and_concurrentSafe`: no gate reading only `(x, own new draw, partner's current draw)` both admits every viable solo upgrade and makes every pair it admits viable.
- `bounded_supremum_local_gate_composes`: with declared bounds on each draw, headroom and a sensor covering the sum of the bounds, the pair is viable.
- `reciprocalGate_sound`, `reciprocal_evolve_rejects_8_and_certifies_11`: the composed gate `3 + (preA + preB) ≤ x₀` refuses `(4, 4)` at `8`, admits it at `11`; there, with joint sensors at `19`, no run leaves the floor, both draw `4` on the first tick, and the reserve goes `11 → 4 → 5`.

## 4. What this does not show (Rule 2)

- **Recognition is not proved.** That a real training run, institution or agent pair meets `EpochCert`, `AnchorStep` or the gate is a recognition for each case. What would count against applying it: an upgrade whose real switchover draws from the substrate (the model's upgrade takes no substrate time), or a substrate law `G` or environment draw that itself changes across epochs (both are fixed here).
- **Fixed for all epochs**: the site type, `G`, `envDraw`, the shape of `AnchorStep`, and the gate's checks. A floor once set too high cannot be lowered by the system itself; lowering it is exactly what `UnanchoredPolyWireheading` shows to be unsafe, so that rigidity is the point, not an oversight.
- **Zeno upgrades** (endless upgrades with no intra step) are runs of the process. They never leave the guard, since the reserve does not move, but they also do no work; nothing here rules them out.
- **Which unmodelled sites ought to enter scope, and when**, is not decided: the gate refuses late entry; it does not discover `sNew` (Pillar B).
- **Part 5 stands beside the epoch process, not inside it.** The solo and composed upgrades are modelled as starting draws of `polyClosedProcess`, not as `EpochHandoffGate` steps of a joint family over `Bool × Bool`. Restating the composed gate as the gate of that joint family is left open.
- **Not compared with the literature**: no claim that this matches or exceeds existing assume-guarantee or runtime-assurance results.

## 5. Changes from the Pillar A paper attack

| Paper attack item | Here |
|---|---|
| Horn 1a for every `cap'` with `cap' fLeg ≠ cap' fMod` | Needs `fLeg` apart from `fSub`, `fModA`, `fEmerg` (all forms present at `t = 1`); with a reading identifying `fLeg` with its replacement the frozen notion passes, now a theorem. |
| Blind sensor "above 8", `warnLevel ≥ 13` | Sensor reads below `7`; second mode forces `warnLevel ≥ 8` for every floor and environment bound, so the impossibility is universal over those. |
| `EpochTotal` inside `EpochCert` | Separate; the gate requires both; kernel theorems do not need totality, non-deadlock needs only totality and `K`. |
| `x₀ = 11` run `4 → 5 → 6 → …` | Proved to `11 → 4 → 5` plus the kernel; the further climb is not stated. |

## 6. Schema-2 record draft (not added to `theories/becoming/results/records/`)

```json
{
  "schema_version": 2,
  "id": "open-ended-epoch-handoff",
  "title": {"en": "Epoch handoff: what may change across epochs, what must not"},
  "kind": "theorem",
  "status": "draft",
  "statement": {"en": "Over one substrate law G and environment draw, an epoch process whose upgrades pass an EpochHandoffGate (allowed, anchored by AnchorStep, target epoch certified and total, target state in K, live lag margin at the current reserve) keeps the original effective floor, the current floor and the current runtime guard over every run, for any upgrade relation; single-epoch cases are exactly anchored_selfMod_viable and monotone_selfWidening_viable. Dropping only the anchor clause admits a floor-lowering upgrade after which the reserve drains to 0 inside the run's own current-floor kernel."},
  "hypotheses": [{"en": "No axiom. RegimeMargin.Coupled.Indexed.Rises for G; EpochCert of the starting epoch; starting state in its K; lag margin x_crit + eta * (sitePreCap + envCap) <= x0 on in-scope sites. Non-deadlock: EpochTotal of the starting epoch and the starting state in K."}],
  "laws": [
    {"en": "Capabilities across epochs, exact reduction, Horn 1a, Horn 2.", "declarations": [
      "Becoming.OpenEndedComposition.TransformsAcrossEpochs",
      "Becoming.OpenEndedComposition.constantEpoch_iff_transformsViably",
      "Becoming.OpenEndedComposition.anchored_rejects_unsafe",
      "Becoming.OpenEndedComposition.unanchored_selfRevision_certifies_any_collapse",
      "Becoming.OpenEndedComposition.RigidLockInWitness.rigidLockIn_transformsAcrossEpochs",
      "Becoming.OpenEndedComposition.RigidLockInWitness.rigidLockIn_fails_all_separating_caps",
      "Becoming.OpenEndedComposition.RigidLockInWitness.coarsened_reading_passes",
      "Becoming.OpenEndedComposition.Horn2WebWitness.unanchored_passes",
      "Becoming.OpenEndedComposition.Horn2WebWitness.anchored_rejects"]},
    {"en": "Handoff gate, epoch-chain viability, anchor preservation, non-deadlock.", "declarations": [
      "Becoming.OpenEndedComposition.scoped_substrate_margin_step",
      "Becoming.OpenEndedComposition.unscoped_recovers_substrate_margin_step",
      "Becoming.OpenEndedComposition.EpochHandoffGate",
      "Becoming.OpenEndedComposition.epochInv_certificate",
      "Becoming.OpenEndedComposition.epochChain_viability_kernel_on_K",
      "Becoming.OpenEndedComposition.epochChain_anchor_never_weakened",
      "Becoming.OpenEndedComposition.epochChain_nonDeadlock",
      "Becoming.OpenEndedComposition.gate_rejects_infeasible_entry"]},
    {"en": "Exact single-epoch reductions and separations from static envelopes.", "declarations": [
      "Becoming.OpenEndedComposition.singleEpoch_recovers_anchored_selfMod",
      "Becoming.OpenEndedComposition.singleEpoch_recovers_monotone_selfWidening",
      "Becoming.OpenEndedComposition.BlindSensorUpgradeWitness.no_static_anchoredSelfMod_envelope",
      "Becoming.OpenEndedComposition.BlindSensorUpgradeWitness.epochChain_certifies_upgrade",
      "Becoming.OpenEndedComposition.UnboundedAscendingEpochsWitness.no_finite_draw_bound",
      "Becoming.OpenEndedComposition.UnboundedAscendingEpochsWitness.upgrade_down"]},
    {"en": "Scope entry and floor rewriting.", "declarations": [
      "Becoming.OpenEndedComposition.SiteExpansionBlindnessWitness.closedScope_allows_sNew_collapse",
      "Becoming.OpenEndedComposition.SiteExpansionBlindnessWitness.timelyOpenEntry_protects_both",
      "Becoming.OpenEndedComposition.SiteExpansionBlindnessWitness.lateOpenEntry_rejected",
      "Becoming.OpenEndedComposition.UnanchoredPolyWireheading.unanchored_drains_inside_own_kernel",
      "Becoming.OpenEndedComposition.UnanchoredPolyWireheading.anchored_refuses_lowering"]},
    {"en": "Evolve versus compose on one composed substrate.", "declarations": [
      "Becoming.OpenEndedComposition.SimultaneousUpgradeObstruction.solo_A_evolve_viable",
      "Becoming.OpenEndedComposition.SimultaneousUpgradeObstruction.concurrent_evolve_collapses",
      "Becoming.OpenEndedComposition.SimultaneousUpgradeObstruction.no_local_gate_soloComplete_and_concurrentSafe",
      "Becoming.OpenEndedComposition.SimultaneousUpgradeObstruction.bounded_supremum_local_gate_composes",
      "Becoming.OpenEndedComposition.SimultaneousUpgradeObstruction.reciprocal_evolve_rejects_8_and_certifies_11"]}
  ],
  "does_not_show": [
    {"en": "That any actual system meets EpochCert, AnchorStep or the gate (recognition, Rule 2).", "kind": "scope"},
    {"en": "Substrate draw during a real switchover; a substrate law or environment draw that changes across epochs.", "kind": "scope"},
    {"en": "Which unmodelled sites should enter scope, or when.", "kind": "scope"},
    {"en": "The composed gate of Part 5 as the gate of a joint epoch family.", "kind": "scope"}
  ],
  "standard_boundaries": ["no-ethical-premise", "no-evaluation", "discrete-steps", "formal-not-empirical", "names-provisional", "omission-not-refutation"],
  "validation_scope": {"en": "Scratch build with Lean 4.29.1 (scratch_build.py, 24 November 2026): 90 theorems, 178 declarations, with_axioms {}, no warnings; not yet a checker receipt. Adversarial review by swarm worker f2-critic. No person has read it."},
  "correspondence": {"en": "Reading (AI-written): what is evolvable (modes, sensors, capabilities, envelopes) and what is anchored (substrate law, floors in scope, environment bounds) must be separated, and the anchored side may only tighten; moving a floor to the evolvable side is the wireheading route, and freezing capabilities on the anchored side is lock-in."},
  "canonical_source": "experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/OpenEndedComposition.lean",
  "dependencies": [
    {"id": "open-interface-composition-and-replacement", "relation": "formal-reuse", "detail": {"en": "Reuses OpenComposition's step lemmas and recovers substrate_margin_step as the unscoped case."}},
    {"id": "transformative-viability-order", "relation": "formal-reuse", "detail": {"en": "TransformsViably is the one-epoch case of TransformsAcrossEpochs (constantEpoch_iff_transformsViably)."}},
    {"id": "polynomial-dynamic-interfaces-and-coupled-laxity", "relation": "formal-reuse", "detail": {"en": "polyClosedStep, PolyContract, compose; anchored_selfMod_viable and monotone_selfWidening_viable recovered as single-epoch cases."}}
  ],
  "history": [{"en": "24 November 2026: drafted (Frontier 2). AI-written."}]
}
```
