*CY item (a), its one reader (GPT astra through Codex, effort high; AI-written), 10 November 2026: its final message, kept as returned. Its links pointed into a review copy that is not kept; they are given here as paths in code. The findings were taken as the record's history says.*

No theorem-type changes found. The proof refactor is sound by inspection; two record-wording issues remain.

**High: none.**

**Medium:**

1. **[where-a-run-turns.json:63] (`where-a-run-turns.json:63`), `hypotheses`, English and Chinese:** “for the first law a relation decided on every pair, for the rest natural-number levels” is stale after inserting R1. `keeps_one_way` requires neither decidability nor order properties. The *second* law, `turns_where_order_breaks`, requires decidability and also permits any carrier. The umbrella qualification in [02-MAP.diff:8] (`02-MAP.diff:8`) similarly understates R1’s scope.

   **Corrected wording:** “For the first law, any carrier and relation, a step preserving that relation, and a start satisfying `rel x (g x)`; for the second, any carrier with a decidable relation; for the remaining laws, natural-number levels.” Adjust the home qualification correspondingly.

2. **[where-a-run-turns.json:161] (`where-a-run-turns.json:161`), `related` → late reading, English and Chinese:** “a turn with history in the state, which the first law covers” now points to the wrong law. R1 preserves an initially satisfied relation under a relation-preserving step; it does not locate the failure responsible for an oscillating run’s turn.

   **Corrected wording:** “A rule reading late oscillates for ever beyond its threshold: a turn with history in the state, covered by the second law, `RunTurns.turns_where_order_breaks`, and outside the scalar laws.”

**Low: none.**

The answers to the four questions are:

1. **Only proofs change in `RegimeMargin.diff`.** No parameter, hypothesis, quantifier, or conclusion changes. In `run_rises` and `run_falls`, `fun n =>` moves out of the proof because the helper supplies the whole quantified result. The other two replacements change orbit rewriting and the invoked lemma.

2. **The requested new explanatory passages accurately describe R1**, apart from the surrounding scope errors above. Its premises are global relation preservation, `∀ a b, rel a b → rel (g a) (g b)`, and `rel x (g x)`; its conclusion concerns every adjacent pair along that orbit. No reflexivity, transitivity, totality, or decidability is required.

   Condition (3) is substantively met across the docstring and record: closure on `{x | rel x (g x)}`, placement in `BandRest` below `RegimeMargin`, reuse by its one-way proofs, the capture route through `Pace.stays_turned` remaining unchanged, and no mathematical novelty. “Same law” is accurate as **the same closure principle**: `locked_rises` uses preservation of `Locked`, followed by `turn_locked`’s nondecrease conclusion; it does not establish R1’s global relation-preservation premise. The earlier history entry saying R1 was not stated records the earlier decision, superseded by the final entry.

3. **Yes.** The four replacements are `Adjusted.run_rises`, `Adjusted.run_falls`, `Drawn.rising_on`, and `Drawn.falling_on`, all within `RegimeMargin`. The latter pair restart the orbit at time `n`; falling uses the converse relation.

   All four remaining executable `Lasting.orbit_mono` calls correctly compare two starting states: `Adjusted.falls_of_below`, `Coupled.Indexed.run_below`, `Coupled.run_below`, and `Coupled.Indexed.run_below_of`.

4. **Yes.** `keeps_one_way` applies `Lasting.orbit_mono` to starts `x` and `g x`, then identifies the second orbit using `Law.orbit_shift`. `orbit_mono` itself applies `Invariant.reach` to the region `{p | rel p.1 p.2}` under `(a,b) ↦ (g a,g b)`, then uses `orbit_pair`. `Lasting.closed_orbit` expresses the corresponding unary closure fact by induction, but neither proof invokes it.

Read-only review completed; no edits, builds, Lean runs, or tests. The reported checker success was not rerun.

