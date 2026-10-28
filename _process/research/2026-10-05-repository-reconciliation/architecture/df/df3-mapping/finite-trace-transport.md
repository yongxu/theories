# Migration map: finite-trace-transport

Old record sha256 `5a7a222484debc22b2761f4fd1373af507678ea261f438483e45e35369986a65`; snapshot `_process/architecture/history/5a7a222484debc22/finite-trace-transport.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declaration in `GenerativeCore.lean` (`Generative.trace_map`, `Generative.trace_lift`, `Generative.projection_exact_iff`, with `Generative.Trace` and `Generative.Process` as defined there). Every condition the Lean takes is kept: step preservation `hstep` (law 1), the lifting condition `hlift` at every configuration of a fiber (law 2), and both as the two sides of the condition of the equivalence (law 3, an iff proved in both directions). The bound receipts (`lean/verification.json`, `becoming-checks/20261014T100026.593496Z`) report empty axioms for all three, so `no-ethical-premise` is cited.

| Old text | Type | New place |
|---|---|---|
| T0 “Step-preserving maps transport finite traces” | title | title (unchanged) |
| S0 “A map preserving each step of one process into another sends every finite course to a course with the same moves” | statement | statement (unchanged) |
| S1 “the converse, endpoints included, holds exactly where every step from an image lifts from each configuration with that image.” | statement | statement (unchanged; exact for a map preserving steps, since then the equivalence of law 3 reduces to the lifting condition) |
| C0 “Where a map f takes every step of P to a step of Q with the same move, every finite trace of P from s to t is a trace of Q from f s to f t with the same moves.” | law | law 1 (“by the same move”) |
| C1 “Through a map q, the traces of Q from q s are exactly the images of the traces of P from s, endpoints included, for every s, exactly where q preserves every step and every step of Q from q s lifts to a step of P from s by the same move into the fiber of its target.” | law | law 3 (unchanged wording) |
| — | added law | law 2: the lifting half alone (`Generative.trace_lift`, already in the references), read against its statement |
| H0 “Two supplied processes, one action type and the pointwise hstep preservation hypothesis.” | premise | hypotheses[0], restated to say which law takes which condition (hstep for transport, hlift for lifting, both as the condition of the exactness law); hypotheses[1] adds that traces are finite, as `Generative.Trace` defines them |
| R0 “The state map and its actual meaning require correspondence” | correspondence | correspondence (unchanged) |
| R1 “this only transports a supplied trace.” | correspondence | correspondence (unchanged) |
| X0 “Step preservation alone does not give converse lifting; lifting needs a condition at every starting fiber.” | counterexample | counterexamples[0] (unchanged) |
| L0 “Step preservation alone does not give converse lifting” | non-implication | counterexamples[0], which carries the same sentence; not repeated as a does-not-show item, so it is not rendered twice; law 3 shows the lifting condition is necessary for exactness |
| L1 “lifting needs a condition at every starting fiber.” | non-implication | counterexamples[0] (same sentence); law 2 and law 3 state the condition |
| V0 “Credits the linked existing Lean receipt.” | evidence | validation_scope (the two binding receipts named by location) |
| V1 “This migration reads source and checks declaration presence and receipt hash binding” | evidence (bookkeeping of the 8 October migration) | snapshot; history entry 0 records that migration; the present migration's reading is in this table and the new history entry |
| V2 “it does not rerun Lean.” | evidence (bookkeeping) | snapshot; the new history entry says no source hash changed |
| N0 “Reuse trace_map for finite-history preservation” | next step | next_delta (“State transport and exact reading through a map for runs without end”); reuse of trace_map is shown by the records that depend on it (becoming-context-coherence, trace-law-equivalence, derived-history-law-exactness) |
| N1 “additional endpoint or actual correspondence requirements remain explicit.” | next step | next_delta (“the correspondence of a state map to an actual system, each with its conditions stated as hypotheses”), stated positively |
| — | standard boundary | standard_boundaries: no-ethical-premise (the hypotheses hold no ethical premise; both bound receipts report empty axioms for the cited declarations) |

The review moved the old counterexample, which no declaration of GenerativeCore.lean witnesses, to a does-not-show item (converse, witness `Generative.projection_exact_iff`): X0, L0 and L1 now go to that item.
