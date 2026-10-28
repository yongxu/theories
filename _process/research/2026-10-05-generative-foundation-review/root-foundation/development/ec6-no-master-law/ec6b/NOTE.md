# EC6b: EC6's cases of closure and balance derived

Board item EC6b, claimed 28 October 2026 by the session Unification and coherence progress (fork 2), as the coordinating note ordered ([WHAT-REMAINS](../../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), "After EC6's audit"). It carries out EC6's proposals 1–5 ([audit](../AUDIT.md), reviewed twice):
- the derivations are bridges and re-proofs, with every statement and definition unchanged;
- they go through `WithinClosure`, closure's anchor, or `balance_over_stretch_on`, balance's, so that the rows reach their master law.

No module's owner is active, so board rule 3's fallback applies. No file overlaps OU3d, which edits `GrammarLaws` only.

## What changed, by module

- **`Pace`.**
  - `stays`: a region of the paced law's joint state (fast configuration, rule, step count) closed under its step holds at every later step of its run. It goes by `Invariant.reach` with `Run.reach`, which reaches closure through `reach_iff_withinClosure`.
  - `stays_turned`: the same read on the two levels, for a region every turn keeps.
  - `rule_until_reading`: re-proved by `stays` at the region where the counter at most `r` gives the start's rule, read with `paced_count`.
- **`RuleCapture`.** `locked_stays`, `favours_throughout`, `favours_after_reading` and `locked_not_below` are re-proved by `stays_turned`:
  - the first by `turn_locked`;
  - the next two by a new `turn_favours` (every turn keeps a favouring rule where the reading favours at every share);
  - the last at the region of locked configurations at or above the start, by `turn_locked` with the orders' transitivity.

  `locked_rises` is unchanged. `ClosedCapture.lock_outlives_loss` moves with `locked_stays` and `locked_not_below`, and keeps its own `join_course` and `loss_grows`.
- **`Lasting`.** `orbit_mono` is re-proved by `Invariant.reach` at the product law `(a, b) ↦ (g a, g b)`, whose closedness is `mono`. A new `orbit_pair` says the product law's orbit is the pair of orbits. Every caller of `orbit_mono` (in `RegimeMargin`, `LoopReturn` and `Lasting`) moves with it.
- **`RegimeMargin`.**
  - `Coupled.Indexed.downstream_within`: a condition downstream of `k` lies within `k`'s closure under the converse of dependence.
  - `ends_downstream`: re-proved from it, the ended conditions being closed under that relation (`ends_of_partner`).
- **`Closing`.**
  - `Upstream.within`: a chain of couplings is within the closure of coupling, by `«线则所闭»`.
  - `Coupled.of_reach`: a reach of couplings is a chain of positive length, by induction with `Coupled.one` and `Coupled.append`.
  - `onLoop_of_closing`: re-proved by `«及当且仅当一步而所闭»`, `«所闭当且仅当同一或及»` and `«及之传递»`.
- **`Decidedness`.** `Counts.over_stretch_decided` is re-proved from `balance_over_stretch_on`, through these new lemmas:
  - `steps_choice`: finite choice on a stretch, with no choice principle;
  - `CountsAcross.eq_total`: counted across steps, the total is the total of the steps' counts, by `Counts.unique`;
  - `Decided.comes` and `Decided.ceases`.

  `Population.steps_of_within` gives the converse of `between_of_mem_steps`. Weightings' `mem_steps_of_between` is its twin, left with its owner. `CountsAcross.keep_pace` and `CensusWebs.keep_pace` move with it.

## Checks

Built in scratch module by module, and every axiom report empty. Every touched theorem's statement text is identical to main's: compared from its name to its proof, whitespace normalized.
