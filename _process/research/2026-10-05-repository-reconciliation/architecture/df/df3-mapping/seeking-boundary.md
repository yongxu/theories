# Migration map: seeking-boundary

Old record sha256 `c9293645b3b02a7b2c0829f82c7b1ccbbd9f512ad6ed942d46de5c094d54cf33`; snapshot `_process/architecture/history/c9293645b3b02a7b/seeking-boundary.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations: `MoreThanNow`, `RestsAt`, `AboveAll`, `more_not_at_rest`, `more_rises`, `more_new`, `more_needs_open`, `succ_more`, `aboveAll_unique`, `aboveAll_not_two`, `Law.fixed_rests`, `Law.rests_iff`, `Law.more_never_rests`, `Law.aboveAll_never_rests`, `Flow.more_needs_unrun` and `Flow.more_exhausted` in `Becoming/Seeking.lean`; `SeekingRuns.rests_iff`, `more_never_rests`, `aboveAll_never_rests` and `aboveAll_not_two` in `Becoming/SeekingRuns.lean`; `Web.StandingCensus`, `Flow.RunsDown` and `Flow.change_recurs_iff` in `Becoming/Locality.lean`; `Law.orbit` and `unlisted_of_new` in `Becoming/Recurrence.lean` (`le_dest` of `Becoming/Prelude.lean` and `gap_of_lt` are lemmas of the proofs, kept in the references). Every condition the Lean takes is kept: a determined law for the boundary of enough (law 3, an iff proved both ways), more than now met at every step (from N on) for the rises and the open world (law 5), two different seekers for above all others (law 6), the census for the rises and running down (laws 7 and 8). `Flow.more_exhausted` proves a negated universal (no condition rises at arbitrarily late steps), and law 8 and the statement say that, not that the rises stop after some step. Every declaration a law names was already in the references; none is added. The bound core receipts (`becoming-checks/20261019T231053.882924Z` for Seeking and SeekingRuns, `20261016T121942.514802Z` for Locality, `20261025T182341.971697Z` for Recurrence, `20261021T133545.845568Z` for Prelude) hold the current bytes and report empty axioms for every cited declaration, and the hypotheses hold no ethical premise, so `no-ethical-premise` is cited.

| Old text | Type | New place |
|---|---|---|
| T0 “Where seeking rests: more than now never does, above all others never for two” | title | title (unchanged) |
| S0 “Under a determined law, seeking rests exactly at a state the law leaves unchanged that meets its target: more than now needs an open world, and above all others never holds of two;” | statement | statement (kept; the colon a semicolon and “, and” a comma, to make room) |
| S1 “where what stands is listed, rising without end needs steps that do not run down, and running down stops it.” | statement | statement, narrowed: “and running down from a step on rules it out”, as `Flow.more_exhausted` proves (running down at every step from some step on; no condition rises at arbitrarily late steps); “where what stands is listed” shortened to “with what stands listed” |
| C0 “Under a determined law next, the orbit from s comes to rest with its target met from some step on exactly when it reaches a state next leaves unchanged that meets the target (Law.rests_iff);” | law | law 3, with the run form `SeekingRuns.rests_iff` |
| C1 “a target met at such a state is met at every later step (Law.fixed_rests).” | law | law 2 (the orbit from the state stays at it and meets the target at every step) |
| C2 “More than now, a quantity q of one's own rising across the step (MoreThanNow), is met only by change (more_not_at_rest, Law.more_never_rests);” | law | law 1 (definition) and law 4, with the run form `SeekingRuns.more_never_rests` |
| C3 “met at every step, q rises between any two later steps (more_rises), so every configuration is new (more_new) and no list holds them (more_needs_open, an instance of unlisted_of_new);” | law | law 5 (`more_rises` stated from N on, as the Lean has it) |
| C4 “counting on meets it (succ_more).” | law | law 5 (“at every step”); counterexamples[0] |
| C5 “Above all others, every other seeker's quantity below one's own (AboveAll), is met at a state by at most one seeker (aboveAll_unique, aboveAll_not_two), so under any law no state left unchanged meets it for two seekers (Law.aboveAll_never_rests).” | law | law 1 (definition) and law 6, with the run forms `SeekingRuns.aboveAll_not_two` and `SeekingRuns.aboveAll_never_rests` |
| C6 “Where what stands is listed at each step (Web.StandingCensus), a condition rising at arbitrarily late steps needs, at arbitrarily late steps, steps across which what stands does not run down (Flow.more_needs_unrun, from Flow.change_recurs_iff);” | law | law 8; law 7 defines running down and the census and states `change_recurs_iff`, the law it rests on |
| C7 “where what stands runs down at every step from some step on, no condition rises at arbitrarily late steps (Flow.more_exhausted).” | law | law 8 |
| C8 “No Lean axiom is used.” | boundary | standard_boundaries: no-ethical-premise |
| H0 “A target is any condition on the configuration;” | premise | hypotheses[0] (unchanged) |
| H1 “how a target forms is not modelled.” | premise | hypotheses[0] (unchanged) |
| H2 “rests_iff assumes a determined law;” | premise | hypotheses[0] (“The boundary of enough assumes a determined law”) |
| H3 “B2 assumes what stands is listed at each step, a local condition written into the theorems.” | premise | hypotheses[0] (“the laws of rising and running down assume …”; the plan's label B2 is kept in the correspondence, which maps the plan) |
| H4 “Discrete steps, counted from step 0;” | premise | standard_boundaries: discrete-steps; hypotheses[1] (“Steps are counted from step 0”) |
| H5 “natural-number quantities.” | premise | hypotheses[1] |
| R0 “Ren on 10 October: “the seeking system got locked in, what they are pursuing is illusion(in south asia and Buddhism)” and “find the boundary condition for 无明”;” | correspondence | correspondence (Ren's words verbatim, the year added and the source files named: 2026-10-10-truth-exists-opening, line 62) |
| R1 “on 11 October: “yes let's do 无明”.” | correspondence | correspondence (verbatim; 2026-10-11-wisdom-from-registration, line 33) |
| R2 “B1 (enough) and B2 (expansion or exhaustion) of the 无明 boundary plan are stated here;” | correspondence | correspondence (unchanged) |
| R3 “B3 (feedback) and B4 (明) are the theorems of P49, P53 and P55 read for seeking, not restated;” | correspondence | correspondence: “theorems already on the spine, read for seeking”; the board item numbers P49, P53 and P55 cut (process markers; the module docstring of Seeking.lean names the theorems) |
| R4 “B5 (hijacking) is not stated.” | correspondence | correspondence (unchanged); does_not_show[1] |
| R5 “Readings (the AI's, adopted on Ren's delegation): 无明 is the not-seeing that keeps seeking locked onto a target that cannot be met at rest, and its boundary is B1;” | correspondence | correspondence, labelled “AI readings”; “adopted on Ren's delegation” cut: a reading stands by its place in the account, and its provenance is in history (16 October, P110, D26) and the snapshot |
| R6 “明 is coupling that lets in what support does not mark;” | correspondence | correspondence (unchanged) |
| R7 “知足 and 知止 are targets within the boundary;” | correspondence | correspondence (unchanged) |
| R8 “dominance as such is not the target ruled out.” | correspondence | correspondence (unchanged) |
| R9 “See §83 of the integration note.” | correspondence | correspondence (unchanged) |
| X0 “Boundary: more than now can be met at every step, but only by change and only in an open world: …” | counterexample | counterexamples[0] (unchanged; witnessed by `succ_more`, `Law.more_never_rests`, `more_needs_open`) |
| X1 “Boundary: above all others is met by at most one seeker at a state … (`Law.aboveAll_never_rests`).” | counterexample | counterexamples[1] (unchanged; witnessed by `aboveAll_unique`, `aboveAll_not_two`, `Law.aboveAll_never_rests`) |
| L0 “How a target forms or is revised, that a seeker pursues it, and which targets actual formations hold are not derived;” | non-implication | does_not_show[0] |
| L1 “hijacking (B5) is stated separately, in target-capture;” | scope + another record | does_not_show[1] (hijacking not stated here); the pointer to target-capture moves to `related`, since a public field does not state another record's scope |
| L2 “rests_iff is for determined laws only;” | scope | does_not_show[2]; the undetermined case is the related record the-boundary-of-enough-under-undetermined-laws, added to `related` |
| L3 “B2 says only that the rises stop recurring, not that exhaustion ends the seekers themselves;” | non-implication | does_not_show[3] (“do not recur at arbitrarily late steps”, as `Flow.more_exhausted` has it); exhaustion ending the seeker is where-a-rising-take-ends, already related |
| L4 “B1 is elementary (a strict maximum holds of one; rest under run-down is ranking-function termination);” | scope | does_not_show[4] (“at most one”; “the rises not recurring under running down”, the law the parenthesis names) |
| L5 “the readings are the AI's, adopted on Ren's delegation;” | correspondence | standard_boundaries: names-provisional; correspondence (“AI readings”); the delegation clause in history |
| L6 “contains no ethical predicate.” | boundary | standard_boundaries: no-evaluation |
| V0 “Successful Lean 4.29.1 consolidated check (20261013T094743.528770Z): the 13 theorems of Becoming.Seeking all have empty axiom reports, among them …;” | evidence | validation_scope, which names the receipts now bound (the 13 October receipt stays in the references as history) |
| V1 “the same receipt covers the package's 75 modules … and 22 inherited modules whose current bytes match passed receipts;” | evidence (bookkeeping) | snapshot and the receipt |
| V2 “periphery receipt 20261013T095049.338744Z passed.” | evidence (bookkeeping) | snapshot |
| V3 “The checker also verifies core purity: … and it compiles from Lean's prelude alone (…).” | evidence | validation_scope (“that the core compiles from Lean's prelude alone”, as each bound receipt's `core_compiles_from_prelude` records); the injEq detail stays in the snapshot and the receipts |
| V4 “The author's counterreview is in §83 of the integration note;” | evidence | validation_scope |
| V5 “not independently reviewed;” | evidence | validation_scope (“it has had no independent review”) |
| V6 “it needs a review such as the eighteenth was (DELEGATED-CHOICES D45 (4)).” | next step | next_delta (“an independent review”); the delegated-choice reference stays in history (19 October, A4) |
| N0 “B5, hijacking: how targets form and are transmitted, and how winning that buys more power to win selects targets that cannot rest, joined to the meta-attractor's results;” | next step | next_delta, without the label B5 and with “buys” (a word of exchange) rewritten “brings” |
| N1 “exhaustion ending the seekers where the seeking is not a take more than now from a bounded giving;” | next step | next_delta (unchanged) |
| N2 “the boundary of enough under undetermined laws.” | next step done elsewhere | dropped from next_delta: the-boundary-of-enough-under-undetermined-laws states it, and it is added to `related` |
| — | standard boundaries | discrete-steps, no-ethical-premise, no-evaluation, names-provisional |

**Chapter edit (made).** The home section says “Where what stands runs down from some step on, rises stop by exhaustion, not by enough.” `Flow.more_exhausted` proves that no condition rises at arbitrarily late steps, a negated universal, not that the rises stop after some step. In 03-KNOWING.md, `r-seeking-boundary`:

- old: “Where what stands runs down from some step on, rises stop by exhaustion, not by enough.”
- new: “Where what stands runs down at every step from some step on, no condition rises at arbitrarily late steps: exhaustion, not enough.”
