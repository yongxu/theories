# Cold read 2: the fix commit 3fb83fa96, read on its diff against round 1 and the same sources

Checked: each round-1 fix against its source; the new exit (unselected-beyond-the-coupling-closure → mutual-dependence-and-its-pace) for law, `to`, strength, records and source anchor; the two split argued exits against `#direction`; the validator (`python3 -B tools/research/atlas.py`, exit 0, no error output).

Fixes found as said: the vacuous exit from mutual dependence is gone; readings-carried-and-filtered's name now says "standing late"; the filter's open item now matches the study note's sense; the pool-read-off-the-course exit is argued with no law; the selection term's exit cites `SelectionTerm.Generations.persists_of_alive` and names exactly the six premises of `Flow.persists_never_overdraws` (balance, only active formations giving, activity needing support, descent, the gate, every cohort coupled at need ≥ m); the `beyond` sentence carries "read as own closure along affecting and held de se"; the instrumental-convergence exit's source `#route-b-joined` (07:698) carries the reward-channel reading, AJ's plan and "the scope, not the order", and AJ's PLAN.md names horizon-optima; the witness `to` is now the witness only; the closed-capture edge says "a likeness of shape"; `#direction` carries both halves of the split argued exits with links to the two 05 records, and the-rest-outruns-the-renewal is an atlas entry.

## Findings

### 1. medium — unselected-beyond-the-coupling-closure, new exit to mutual-dependence-and-its-pace (law Becoming.Flow.withinCoupling_of_withinInfluence, strength sufficient, source `#r-selection-read-off-continuations`); and the sentence added to mutual-dependence-and-its-pace's mechanism

**Said.** "The blindness has no content where the flow is mutually dependent: … nothing lies beyond any formation's coupling closure (Flow.MutuallyDependent with Flow.withinCoupling_of_withinInfluence; the one-line composition is not stated as a lemma). Route (b)'s bound bites only where the flow is not mutually dependent"; and in the mechanism, "Under mutual dependence nothing lies beyond any formation's coupling closure, so route (b)'s bound beyond coupling has no content there."

**Source.** The composition is true (MutualDependence.lean:99–100 with Testing.lean:465–466), but no source says it. The cited anchor (07:231) carries only "the influence closure lying within the coupling closure", as the step of the pool's covering, and never mentions mutual dependence; no sentence in 03, 05 or 07 joins "mutually dependent" with "coupling closure"; no Lean declaration composes them (grep over Becoming/). The nearest home statements are weaker: under mutual dependence every formation's acts return (§4.8, `Flow.MutuallyDependent.reachReturns`) and, on a finite flow with reach decided, the pool of every returning formation leaves nothing beyond (§3.5, §4.13, `Flow.returning_pool_covers`), which is the pooled closure under finiteness, not each formation's own closure with no premise. So the atlas now states, as a mechanism sentence and a law-shown exit, a claim with no home and no record, which the atlas's own rule forbids ("creates no result … holds no standing of its own"); and the law in the exit's `law` field proves half the edge, the edge saying so.

**Fix.** Either state the one-line lemma in Lean (`Flow.MutuallyDependent.withinCoupling`, or in the existing BeyondCoupling module) with a sentence at §4.13 "The bound there", and cite it; or, until then, make the exit argued (law and strength null, source `#r-route-b-joined`, edge giving the composition) and mark the mechanism sentence as the atlas's composition from the two laws named.

### 2. low — persisting-filters-what-was-chosen, `open[1]`

**Said.** "… alternatives that are flows would not make what a course does to the line a law by themselves; a chooser whose acts determine its own continuation would." Source: the record's does_not_show.

**Source.** Now matches za-concern-formed/NOTE.md:45 in sense, but the clause is still not at the cited source: the record's does_not_show 5 ends at "among such courses". The note's "What would extend it" is where it lives.

**Fix.** Cite the note beside the record, or drop the clause.

### 3. low — unselected-beyond-the-coupling-closure, exit to selection-read-off-its-own-survivors (argued, source `#readings-persist`)

**Said.** "a selection that removes its own readers needs the pool read off the course … (the change of what the pool is read off is the step argued)".

**Source.** The argued step is stated at `#beyond-coupling` (07:239: "The group and the pool are fixed across the two courses … a selection that removes its own readers … is not stated here, and needs the pool read off the course") and again in §4.13 "Where it stops"; `#readings-persist` (07:677) only says "the pool fixed across courses" in its lead and then holds the destination's laws. The anchor carries the destination, not the argument.

**Fix.** Source `#beyond-coupling` (the entry's own home), keeping `#readings-persist` for the destination if a second anchor is wanted.

### 4. low — persisting-filters-what-was-chosen, exit to instrumental convergence (reading, source `#route-b-joined`)

**Said.** "No law joins the two sides: the filter shows no order held, and the horizon law takes one."

**Source.** Neither §4.13's reading nor §4.9's says this; it is the atlas's own sentence. It is true of the records (route-b-joined does_not_show 2; horizon-optima-hold-the-greatest-renewal's statement quantifies over orders), but a negative about the Lean stated only in the atlas.

**Fix.** Drop the sentence, or rephrase as what the records say ("the filter shows no order held; the horizon law takes an order").

## Count

high 0, medium 1, low 3.
