# Migration map: continuous-time-as-tower

Old record sha256 `294668882e74f97ff56bfaffa02fb31f515df0245df80fff783917e3bc02b4a0`; snapshot `_process/architecture/history/294668882e74f97f/continuous-time-as-tower.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations in `Becoming/Tower.lean` (`Tower`, `Tower.reads`, `Tower.reads_strict`, `Tower.web_zero`, `Tower.level_zero`, `Tower.balances_coarser`, `Tower.dissipative_coarser`, `Tower.changes_within`), `Becoming/Sampling.lean` (`Strict`, `Web.sample`, `Flow.Once`, `Flow.sample_balances`, `Flow.sample_dissipative`) and `Becoming/Locality.lean` (`Web.StandingCensus`). Every condition the Lean takes is kept: each relatum listed once at every step of the finer flow for balance (law 2; `Tower.balances_coarser` takes `Flow.Once`); the census of what stands at the level used and running down not refuted at each fine step of the stretch (law 3); the decided equality of relata of the tower's type parameter (`[DecidableEq F]`, hypotheses[2], new). `Tower.changes_within` counts the fine steps at which the total standing falls; the further reading in its docstring and in that of `Flow.runsDown_bounds_change` (under running down those are the steps at which some standing changes) is not in either statement, so the law says falls only. The bound receipts report empty axioms for every cited declaration, so `no-ethical-premise` is cited.

| Old text | Type | New place |
|---|---|---|
| T0 “Time scales as a tower of discrete readings” | title | title (unchanged) |
| S0 “Each level reads the next finer at strictly increasing times” | statement | statement (unchanged) |
| S1 “balance (relata listed once) and dissipation pass to coarser ones.” | statement | statement (unchanged) |
| S2 “At any level, under a census of what stands and running down not refuted at each fine step, a coarsest stretch has no more falls of total standing than its starting total.” | statement | statement (unchanged) |
| C0 “A tower (Tower): at each level a web and a flow, level n being level n+1 read at the strictly increasing times refine n (web_sample, flow_sample).” | definition | law 1 |
| C1 “Step s of the coarsest level is step reads n s of level n” | law | law 1 (“is read at step reads n s”) |
| C2 “the coarsest level is level n read at those times (Tower.web_zero, Tower.level_zero), which are strictly increasing (Tower.reads_strict).” | law | law 1 (“the coarsest level's web is level n's read at them, so each condition's standing at step s is its standing there”: `web_zero` is of the web, `level_zero` of each standing) |
| C3 “Laws at every level: balance with each relatum listed once, and dissipation, pass to the coarser level (Tower.balances_coarser, Tower.dissipative_coarser).” | law | law 2 (listing once at every step of level n + 1, as `Flow.Once`; with the sampling laws they come from) |
| C4 “Change bounded however finely divided: a stretch of N steps of the coarsest level from S, read at level n, under a census of what stands at level n and with what stands not refuted to run down at each of its fine steps, has at most as many fine steps at which the total standing falls, the steps at which some standing changes, as the coarsest level's total standing at S (Tower.changes_within)” | law | law 3 (the census written out from `Web.StandingCensus`; the clause “the steps at which some standing changes” is not in `changes_within`'s statement, see above, and stays in the snapshot) |
| C5 “the bound does not depend on n.” | law | law 3 (“the bound is the same at every level”) |
| H0 “No global premise: running down and the census only at the level and fine steps used.” | premise | hypotheses[0] (unchanged) |
| H1 “Representation: time as a family of discrete readings linked by the reading of Sampling; the core takes no real numbers.” | premise | hypotheses[1] (unchanged); standard_boundaries: discrete-steps |
| — | premise | hypotheses[2] (new): decided equality of relata, which `Tower` takes as `[DecidableEq F]`; standard_boundaries: decidability |
| R0 “Ren decided on 12 October that continuous time is built in the core as a tower of ever-finer discrete readings, a law of continuous time being a law at every level, real-valued time a later periphery correspondence.” | provenance | correspondence (the date “on 12 October” removed as a process marker; it is in history entry 0 and the provenance source `2026-10-12-unit-of-need-and-tower-of-time.md`) |
| R1 “This result gives the tower and the first of its laws: dividing time more finely adds no change.” | reading | correspondence (unchanged) |
| R2 “It rests on the laws of one step (Flow.runsDown_bounds_change) and the least loss per exchange, with no premise added.” | reading | correspondence (unchanged); the dependency on laws-of-one-step (unchanged) |
| X0 “Boundary: the bound needs what stands to run down at the fine steps.” | counterexample | counterexamples[0], narrowed: `Strobe.converse_fails` is a web in which nothing stands (every level 0) and activity flickers; it shows unbounded arising and ceasing at fine steps that the coarser reading does not show, not that the bound on falls of standing needs running down (in Strobe the count of falls is 0); the detail now says what it shows and that the tower's bound counts falls of standing and does not bound changes of activity |
| X1 “In Strobe a relatum arises and ceases at fine steps inside every coarse step while every sampling time is quiet (Strobe.converse_fails): without running down, a finer level can show unbounded change that a coarser one does not.” | counterexample | counterexamples[0] (first part unchanged; “without running down … unbounded change” narrowed to “unbounded arising and ceasing”, as above) |
| L0 “Not done: real-valued time (a periphery correspondence)” | scope | does_not_show[0] |
| L1 “towers with no coarsest level” | scope | does_not_show[1] (witness `Becoming.Tower`, indexed from level 0) |
| L2 “the exact form of the bound as levels refine.” | non-implication | does_not_show[2] (witness `Becoming.Tower.changes_within`) |
| L3 “The count uses a census” | premise | hypotheses[0] (which says it); law 3 |
| L4 “running down is a condition at the level used.” | premise | hypotheses[0] (which says it); law 3 |
| L5 “The names (Tower, reads, refine) are the AI's.” | standard boundary | standard_boundaries: names-provisional |
| V0 “Successful Lean 4.29.1 consolidated check (20261013T094743.528770Z): the 6 theorems of the new core module Becoming.Tower all have empty axiom reports” | evidence | validation_scope (the core receipts under becoming-checks, empty axiom reports; the receipt stays in references and the count in the receipt and the snapshot) |
| V1 “the same receipt covers the package's 75 modules with 4518 theorems/6370 declaration audits” | evidence (counts) | receipt + snapshot |
| V2 “periphery receipt 20261013T095049.338744Z passed.” | evidence | snapshot (the record cites no periphery declaration) |
| V3 “It was first compiled from the prelude in a scratch tree, with no warnings and every #print axioms empty.” | evidence | validation_scope (“The module was first compiled from the prelude in a scratch tree, with no warnings”; the axiom reports are the receipts') |
| V4 “The core closure is 49 modules.” | evidence (counts) | receipt + snapshot; validation_scope says the checker verifies core purity |
| V5 “There is no independent review yet” | evidence | validation_scope |
| V6 “the author's counterreview is in §82 of the integration note.” | evidence | validation_scope (“in the integration note”); §82 is in history entry 0 |
| N0 “More laws at every level of the tower (dependence, reserve and support; arising needing an active giver)” | next step | next_delta (unchanged) |
| N1 “refining time and the unit together” | next step | next_delta (unchanged) |
| N2 “the periphery correspondence to real-valued time.” | next step | next_delta (unchanged) |
| — | standard boundary | standard_boundaries: no-ethical-premise (the hypotheses hold no ethical premise; the bound receipts report empty axioms for every cited declaration) |
