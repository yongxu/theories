# Cold read 1: K4, route (b)'s dynamics on the atlas (commit 9953e82fe, with 5411279cb)

Read against the records' statement, laws, hypotheses and does_not_show, the home sections of 07 (§3.5, §4.8–4.13, §7), the Lean statements of every exit law, and the atlas's rules (atlas.py docstring and `_dynamic`, vocabulary.json). Every law an exit names exists in the Lean under its namespace; every `source` anchor exists; every hypothesis index is within its record's count; the two readings cited as sources (§3.5 "Reading [AI reading, board item ZB]", §4.9 "Reading [AI reading, new]", §4.12 "Reading [AI reading, route (b)'s J2]") are marked AI readings at their anchors; the "argued" exit's argument is at `#direction` ("Necessary, not sufficient"). No entry duplicates one already on the atlas (180 entries listed; nothing else states persisting as a filter, readings carried along a line, or a selection read off its own survivors). No evaluative word marks a dynamic good or bad; every valence is "none asserted".

## Findings

### 1. high — mutual-dependence-and-its-pace, exit to unselected-beyond-the-coupling-closure (law Becoming.Flow.returning_beyond_coupling, strength sufficient)

**Said.** "Under mutual dependence every formation's acts return (Flow.MutuallyDependent.reachReturns); at a formation whose acts return, for any coupling by level, what lies beyond its coupling closure has no significance from it and the significance is a rival. Pooled over every returning formation of a finite flow with reach decided nothing lies beyond (Flow.returning_pool_covers): the bound bites only for a pool that leaves one out." Read as an exit, mutual dependence leads into the blindness beyond the coupling closure.

**Source.** The exit is vacuous under its own source dynamic. `MutuallyDependent` is `∀ f g, L.WithinInfluence W f g` (MutualDependence.lean:97–100), and `withinCoupling_of_withinInfluence` (Testing.lean:465–466) turns that into `L.WithinCoupling W obs f g` for every coupling `obs`. So in a mutually dependent flow nothing lies beyond any single formation's coupling closure, pooled or not, and the hypothesis `beyond : ¬ L.WithinCoupling W obs c.1 h` of `returning_beyond_coupling` (FromTheDynamics.lean:123–129) can never be met. The last clause ("bites only for a pool that leaves one out") understates this: under mutual dependence it bites for no formation at all, with no finiteness or decided reach needed. The home (§4.13 "The bound there") states the bound at the returning standpoints of a flow, not under mutual dependence; record route-b-joined law 2 likewise. A reader of the atlas would take mutual dependence to open a route into B's blindness, when it closes it.

**Fix.** Drop the exit, or re-edge it as what the Lean gives: under mutual dependence every formation lies within every coupling closure (MutuallyDependent with withinCoupling_of_withinInfluence), so route (b)'s bound is empty there and bites only at a returning standpoint of a flow that is not mutually dependent (Clearing's shape).

### 2. medium — readings-carried-and-filtered, `name`

**Said.** "Readings carried along a line, told apart by its persistence only within its coupling closure."

**Source.** The law tells readings apart by the line's *standing late*, not its persistence: `line_standing_unselected` (ReadingsPersist.lean:410–427) concludes `StandsLate slots … ↔ StandsLate slots …`; persistence gives standing late only one way (`Flow.lineOf_standsLate`, ReadingsPersist.lean:387; record which-readings-persist does_not_show 3: "only the first direction is proved"; home §4.12: "the converse is not claimed … so the law is about standing late, which persistence implies"). The record's own statement says "A line's standing late tells readings apart". The entry's mechanism gets this right; the name does not.

**Fix.** "told apart by its standing late only within its coupling closure".

### 3. medium — persisting-filters-what-was-chosen, `open[1]` (second item)

**Said.** "That a chosen ending is realized as an overdraw, or that actual formations choose by a strict order among such courses: alternatives that are flows would make what a course does to the line a law and not a premise." Source given: the record's does_not_show.

**Source.** The record's does_not_show 5 has only the first sentence. The added clause reverses the study note it comes from: za-concern-formed/NOTE.md:45, "A chooser whose acts determine its own continuation, so that what a chosen course does to the line is proved, not the premise `realized`; alternatives that are flows would **not** do this by themselves." A reader would believe a known extension (make the alternatives flows) discharges the realization premise, which the note denies.

**Fix.** Delete the clause after the colon, or restate it as the note has it ("alternatives that are flows would not do this by themselves; a chooser whose acts determine its own continuation would").

### 4. medium — unselected-beyond-the-coupling-closure, exit to selection-read-off-its-own-survivors (law Becoming.survivorsPersist_of_settled, strength sufficient)

**Said.** "Here the group and the pool are fixed across the two courses … Read the pool off the course instead … selection by persistence read off it passes every course whose lines settle, a course removing every line included", as a sufficient exit shown by a law.

**Source.** `survivorsPersist_of_settled` (ReadingsPersist.lean:520–526) is a law of the destination alone: `settled → SurvivorsPersist`. It mentions no coupling closure, no two courses and no selection through couplings; it gives no condition under which the blindness is left, which is what the atlas's `sufficient` means ("an exact or a sufficient exit gives a condition under which the course leaves", atlas.py ROUTE_STRENGTH). The join is in prose only: §3.5's "Two limits" paragraph ("a selection that removes its own readers … is not stated here, and needs the pool read off the course") and record selection-read-off-continuations does_not_show 5. The exit therefore ranks on a route as a law-shown step while the step is a change of what the pool is read off.

**Fix.** Make it an exit no law shows (`standing_without_law: "argued"`, law and strength null, records empty, source `#beyond-coupling`), naming `survivorsPersist_of_settled` in the edge text only.

### 5. medium — the-selection-term-and-a-lineages-fate, exit to persisting-filters-what-was-chosen (law Becoming.SelectionShift.Generations.never_empties_of_unbounded)

**Said.** "every generation is nonempty, so the line has members in arbitrarily late cohorts, which is what persisting is (the one-line step from a nonempty cohort is not stated as a lemma); under the World laws such a line never overdrew its family".

**Source.** The step is stated as a lemma: `SelectionTerm.Generations.persists_of_alive (alive : ∀ t, ∃ y, y ∈ G.family t) : G.Persists` (ReadingsPersist.lean:610–612), on the same `SelectionTerm.Generations` the SelectionShift law uses (SelectionShift.lean:257), and record which-readings-persist lists it (law 3). The edge tells a reader a gap in the Lean exists where none does. The second clause drops the persistence laws' premises (balance, only active formations giving, activity needing support, descent, the gate, every cohort coupled at need ≥ m; `Flow.persists_never_overdraws`, PersistingChoices.lean:455–466) into "under the World laws".

**Fix.** Cite `persists_of_alive` for the step and name the six premises (or "under the persistence laws' premises") in place of "under the World laws".

### 6. low — family of the two filtered-selection entries

**Said.** selection-read-off-its-own-survivors is in B (drains beyond what couples in); readings-carried-and-filtered is in H (kept regions, renewal, generation).

**Source.** The first's record and mechanism call it "the shape of the meta-attractor with persistence for the share" and its only exit to an entry goes to C's closed-capture; the second's one general law is an instance of B's blindness (`act_courses_unselected_throughout` with standing late as the selection, ReadingsPersist.lean:400–409) and its `beyond` is a drain beyond the line's closure. B is defensible for the first (a selection blind to what it removes) and the commit says "Nothing in C or D" by design; the placements are a judgment, not an error, but a reader looking for the meta-attractor's shape under C, or the blindness under B, will not find these there.

**Fix.** Either move readings-carried-and-filtered to B beside the blindness it instantiates, or say in its mechanism why H (a line of descent and which of its readings persist).

### 7. low — unselected-beyond-the-coupling-closure `beyond` (last sentence), and the mutual-dependence exit edge of finding 1

**Said.** "From a returning standpoint, for any coupling by level, what lies beyond its coupling closure has no significance from it at any step (Flow.returning_beyond_coupling)."

**Source.** The Lean's significance is `selfAscribed (ownClosure (L.Affects W))` (FromTheDynamics.lean:126–129): significance read as own closure along affecting, held de se, which the record's hypothesis calls a reading and the entry's mechanism states ("For a significance read as each center's own closure"). The `beyond` sentence and the edge drop the qualifier, so "no significance" reads as a fact of any significance.

**Fix.** "has, read as own closure along affecting and held de se, no significance from it".

### 8. low — persisting-filters-what-was-chosen, exit to "the self-preservation half of instrumental convergence" (reading, source `#what-persisting-shows`)

**Said.** "AJ's plan reads its resource-keeping side, under a fixed order, as courses over a horizon holding a base at its greatest renewal (horizon-optima-hold-the-greatest-renewal) … What tells an ethics from self-keeping here is the scope, not the order."

**Source.** At `#what-persisting-shows` (07:619) the plan's resource-keeping side is read "as of the same kind as the drain beyond the couplings" with a link to 05's what-an-optimum-does-beyond-what-couples-in; horizon-optima is not named there (it is in AJ's PLAN). "The scope, not the order" is §4.13's reading (07:739), not the cited anchor's.

**Fix.** Cite `#r-route-b-joined` as well, or drop the two clauses the cited anchor does not carry.

### 9. low — readings-carried-and-filtered, witness exit `to` text

**Said.** `to`: "a reading that does not keep what returns to its line ends with it: where the dweller's line renews the source, the line that clears its habitat ends after it" (strength witness).

**Source.** The first clause is the §4.12 AI reading's general sentence ("Read with Ren's words of 8 November, a reading that does not keep what returns to its line ceases with it"); the law `Habitat.back_which_persist` (ReadingsPersist.lean:1224–1228) is one model. A witness "shows one constructed course that leaves, with no condition" (atlas.py); the `to` state reads as a general law.

**Fix.** Keep only the clause after the colon as the state, or mark the first clause as the reading.

### 10. low — selection-read-off-its-own-survivors, exit to closed-capture (open)

**Said.** A route from this entry to closed-capture, "Read off the pool its course gives, selection by persistence reads nothing beyond its survivors, as 02's closed capture reads nothing beyond its share … that join is not made."

**Source.** Record does_not_show 1: "RuleShaping's counts are not joined here." The edge says so and the standing is open, which is right; but the connection as stated is a shared shape ("reads nothing beyond"), and the atlas warns that a shared word is not a correspondence. A route to closed-capture now exists on the atlas, ranked last.

**Fix.** Acceptable as is; if kept, say in the edge that the likeness is of shape (Unread vs. SurvivorsPersist), not of a law.

### 11. low — unselected-beyond-the-coupling-closure, exit to several-optimizers-drain-by-their-joint-capacity (argued)

**Said.** The edge's second half, "where the rest outruns the renewal no weight of a later reading selects a member's restraint", is the-rest-outruns-the-renewal's law, which has its own entry; the exit's `to` names only several-optimizers.

**Source.** 07 `#direction` "Necessary, not sufficient" cites both 05 records; the atlas has an entry the-rest-outruns-the-renewal.

**Fix.** Either drop the second half from this edge or add a second argued exit to the-rest-outruns-the-renewal.

### 12. low — commit message 9953e82fe

**Said.** "Sixteen exits added, one amended: eleven a law shows, four readings, one argued, one open."

**Source.** Counting the added exits in dynamics.json: ten with a law (1 + 1 + 2 + 1 + 1 + 4), four readings, one argued, one open = sixteen. The atlas itself is not wrong; the message is.

**Fix.** None needed in the atlas; note it if the message is quoted on the board.

## Checked and found as said (for the record)

- selection-read-off-its-own-survivors mechanism, exits to the fixed-pool state and to readers-drawn-from-the-selected: match record laws 1–3, 5 and the §4.12 reading; "classically every course with finitely many lines settles (argued, not in Lean)" is at the home verbatim.
- readings-carried-and-filtered mechanism, exits via `carried_keeping_above_ending`, `line_standing_unselected`, `Habitat.cleared_removes_its_readers`; `beyond`: match the Lean and records.
- persisting-filters-what-was-chosen mechanism, exit via `coupled_generation_childless` to selection-among-groups-by-ending (the right destination: that entry carries the coupled ending), exit to what-training-installs (reading at the home, `reversed_off_met` says what the edge says).
- mutual-dependence-and-its-pace mechanism additions, the amended `to` of `Drawing.lapses`, the mutual-drain witness (Drawing's model: one unit each across the first step, need one, both at level 0 from step 1), `beyond`, and the `#own-class` open item ("only granted P4", "loop … threshold only" are at 07 §4.10).
- unselected-beyond-the-coupling-closure mechanism additions (per-center bound, Clearing's dweller beyond every coupling and within reach, the pool's covering, "the clearer alone leaves out the dweller"), the reading exit to readers-drawn-from-the-selected (§3.5 reading, "supplied, not proved" carried), the argued exit's argument at `#direction`.

## Count

high 1, medium 4, low 7.
