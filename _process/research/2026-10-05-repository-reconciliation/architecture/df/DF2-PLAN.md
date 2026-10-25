# DF2: the plan

DF2 makes what DF1 left ([LEFT](LEFT.md)). Main at `4b8ccf0a7` has no record for any of the results below; none of their proposed ids exists, and no existing record cites their declarations. The rows are indices into [`triage.json`](triage.json), where each row's `fix` gives the proposed title, home, laws and regions entry, all checked against the Lean at `0e368fbf2` and to be rechecked against main.

## New records (30)

Each record is schema 2 and gets its `r-<id>` anchor in one home section, a link from any other place that states it, and a regions entry. One result gets one record: rows 140 and 284 are the same law (`MoveOutcomeProcesses`: covering exactly where every one-move goal is carried), so they make one record, `one-move-covering`, at home where the theorem is stated in full, with the other place linking to it. Row 96 is law 1 of `readings-a-response-needs`; row 113 is covered by rows 148-151.

| Unit | Chapter | Records (triage rows) |
|---|---|---|
| A | 03 | when-to-inquire-and-when-to-respond (94), certificates-sound-and-available (131), adaptive-closure-cannot-resolve (132), evidence-through-change (133), correction-is-not-calibration (134), learning-a-rule-by-narrowing (135), readings-a-response-needs (136, 96), composition-route (137), what-a-total-keeps (138), access-yet-to-form (139), one-move-covering (140, 284) |
| B | 04 | stronger-arrangement-formed-by-reconfiguration (144), a-selected-template-need-not-raise-structure (145), groups-formed-by-bonds-share-a-founder (146), recurrence-without-selector-revision (148), equal-totals-can-hide-what-a-capacity-carries (149), the-updater-line (150), same-carrier-need-not-fix-the-response (151) |
| C | 05, 07, 02 | market-model-share-margin-and-ends (194), joint-plans-from-a-supported-start (195, its checker run first), a-swap-symmetric-assignment-singles-out-none (196), reviewers-count-by-independent-causes (197), succession-on-a-funded-carrier (198), finite-agreement-does-not-identify-priority (267), significance-through-a-common-condition (36, with becoming-renewal-reading's statement and 02-MAP line 105's link) |
| D | 01, 08 | reach-from-a-seed (55), what-a-summary-keeps (283), type-formation-gives-no-dynamics (285), contraction-where-duplication-is-reachable (286), self-reference-does-not-certify-itself (287) |

## The rest (by the lander)

Statements for least-footprint-where-idleness-decided and normal-forms-need-decided-apartness (from 01's home sections); schema-2 migrations with laws arrays for the records LEFT lists; the two renames (selection-under-registration-revision → selection-when-the-lumping-changes, formed-copying-registration → formed-contacts-change-copying-fidelity) with stubs, regions, anchors and inbound links; decision entry D69 for the grammar's readings (01 §2, §8.6, §8.7).

## How

Per unit, one drafter writes the records as files (statement, laws, hypotheses, does-not-show, references with declarations, proof bindings to the receipt that binds each file's current bytes), each sentence against the current Lean, and returns the anchor and regions entries rather than editing shared files; one skeptical reviewer per unit checks every sentence against the Lean and the receipt; the lander applies the findings, inserts anchors and regions entries by script, and lands through the queue: no new Lean, so no core checker run unless a binding needs one (joint-plans-from-a-supported-start's periphery checker runs first). Eight agents in all.
