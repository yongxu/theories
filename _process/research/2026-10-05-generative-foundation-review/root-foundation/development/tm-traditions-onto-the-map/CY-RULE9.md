*Rule 9 for CY's first law, read off the Lean on main `708404bd4` (10 November 2026; AI-written, Claude Opus 5.5). Read, not built. AA handed CY to TM the same night (its holder's message to TM); the row is claimed after AA's step 2 lands.*

# Does one law already sit below R1 and the capture lock?

**The question (AA's, from the joint reading §五·二).** R1 says a step that keeps the order never reverses its run. Does `Lasting.orbit_mono` already sit below both the regime's run moving one way (through `RegimeMargin.step_mono`) and the capture lock's not falling (through `Pace.stays_turned`)? Or can one law sit below both? Or is a gathering leaf all that is honest?

**The answer: one law already sits below both, and R1 is its corollary.** The law is the closure law, a closed region holds what is reached (`Invariant.reach`). Both cases go through it today, by different routes:

- **The regime.** `Lasting.orbit_mono` (for any relation, a step keeping it keeps it between two runs) is proved by `Invariant.reach` on pairs of runs (`orbit_pair`). `RegimeMargin.rests_within` takes it with the second run started one step later. With `Law.orbit_shift`, a run whose first step does not lower then never lowers, and likewise for not raising. The same few lines recur inline at least six times in `RegimeMargin.lean` (lines 1128, 1141, 1212, 1220, 2002, 2011 on `708404bd4`).
- **The capture lock.** `RuleCapture.locked_rises` takes the locked region. One turn keeps it and lowers neither the share nor the rule (`turn_locked`). The region is closed along the paced course (`Pace.stays_turned`, which is `Pace.stays`, which is `Invariant.reach`).

Both are one shape: a region the step keeps, on which the step does not lower. From inside it, the course never falls.
- For a step that keeps the order, the region is the levels the step does not lower, `{x | x ≤ g x}`. It is closed because the step keeps the order: from x ≤ g x follows g x ≤ g (g x).
- For the capture, the region is `Locked`.

So R1 adds no new mathematics. Its reason is the closure law, which is already the reason for both.

**What is worth landing, by rule 9.**

1. **R1, once, at `Lasting`.** For any relation, a step that keeps it, and a start the step does not lower, the run does not lower at any step. Proved from `orbit_mono` and `orbit_shift`, or from `closed_orbit` on the region above. `RegimeMargin`'s inline repetitions can then cite it. That is a cleanup of six proofs, not a new reason; it is optional and touches a module others build on, so only with AA's word.
2. **Where a reversal shows the step breaking the order.** This is new as a statement, though it rests on R1. For a decidable relation: if the step does not lower the start and the run lowers at step n, there is a k < n at which the run has not lowered so far, and the step does not keep the order between run(k) and run(k+1). The witness is on the run itself. Read on the regime's step `(x − H) + g(x − H)` over whole numbers, it gives two levels a < b with g(a − H) > g(b − H): more left, less given, which is overcompensation. 06's reading of 物极必反 then gets a premise it can name.
3. **R2 (an order-reversing step ends at rest or period two, with a bound) and R3 (the period-three witness).** New statements: elementary, but nothing on main states them (both readers searched; not exhaustive).
4. **Hysteresis (CY (b)), the loop under a parameter moved and moved back.** CY's own open item, still unstated. The plane result `RegimeMargin.Adjusted.falls_iff_below` is its nearest neighbour, as Fable noted.

**What R1 to R3 do not say.** They are laws of scalar steps on levels, as AA asked. They rank no courses, and they say nothing of a step with memory: late reading, `Regulation.relay_threshold`, puts history into the state.

**The order of the Lean.**
1. Items 2 and 3, each a leaf importing `Lasting` and `RegimeMargin`, with one reader.
2. Then item 1, on AA's word.
3. Then item 4.

Each lands through the queue under CY's row.
