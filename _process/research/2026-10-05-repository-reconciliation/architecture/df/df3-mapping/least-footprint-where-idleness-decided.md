# Migration map: least-footprint-where-idleness-decided

Old record sha256 `cad0984e279b9957d2898074ff3d3be3790fdd5089f4b06f28aedf7b72731a3e`; snapshot `_process/architecture/history/cad0984e279b9957/least-footprint-where-idleness-decided.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations in `Becoming/OrderNormal.lean` (the section "The least footprint": `DecidesIdle`, `least`, `least_contains`, `least_touch_iff`, `least_le`, `least_joined`, `least_precedes`, `least_keeps`, `least_exists_iff`, `inList`, `inList_iff`, `decidesIdle_iff`) and `Becoming/Reordering.lean` (`Footprinted`, `Contains`, `Joined`, `Precedes`, their `mono` laws, `Keeps`, `Independent`, `Reindexes`, `sorts_iff`, `Web.Unmoved`), at the bytes bound by the record's proof bindings. Every condition is kept: the idleness decision for every law about `least` (laws 1–4), decided equality of relata for `least_exists_iff` and `decidesIdle_iff` (laws 5–6, as hypotheses[2] says), the containing footprint on the same flow and web for `least_le`, `least_joined`, `least_precedes` and `least_keeps` (laws 2–3), and for `sorts_iff` a containing footprint and a renumbering of the stretch with its inverse (law 4). Law 4's second clause is `least_keeps` followed by `sorts_iff` at the least footprint, which contains the exchanges (`least_contains`); both are named. `Footprinted.Joined`, `Footprinted.Precedes`, `Footprinted.Independent` and `Reindexes` were added to the Reordering.lean references.

| Old text | Type | New place |
|---|---|---|
| T0 "The least footprint and least order where idleness is decided" | title | title (unchanged) |
| S0–S1 | statement | statement (unchanged) |
| C0a "Given a Boolean decision of idleness at every step and relatum (DecidesIdle: taking no part and being Unmoved), Footprinted.least touches exactly what is not idle," | law | law 1 |
| C0b "contains the exchanges, and is contained in every containing footprint (least_touch_iff, least_contains, least_le)." | law | law 2 (with `Contains` written out) |
| C1 "Its Joined and Precedes are contained in the corresponding relations of every containing footprint (least_joined, least_precedes);" | law | law 3 (with `Joined.mono` and `Precedes.mono`: joining and order grow with what a footprint touches) |
| C2a "every renumbering those footprints keep is also kept by it (least_keeps)," | law | law 3 |
| C2b "connected to reachable arrangements by sorts_iff." | law | law 4 |
| C3 "With decidable equality of relata, a least Boolean containing footprint exists exactly where an idleness decision exists (least_exists_iff)." | law | law 5 |
| C4 "Participation is then decided by list membership, and idleness is decided exactly where being unmoved is decided for nonparticipants (decidesIdle_iff)." | law | law 6 ("membership in the list of present relata", `inList` and `inList_iff`) |
| L0 "Idleness is not derived decidable for every world, and no least Boolean footprint is constructed without that decision." | non-implication | does_not_show[0] |
| L1 "Necessity is the equivalence under DecidableEq, not a concrete undecidable-idleness world." | scope | does_not_show[1] (witness `least_exists_iff`) |
| L2 "Leastness is relative to the existing Boolean footprint and Contains definitions;" | scope | does_not_show[2] |
| L3a "it does not eliminate the supplied sides of Reorders" | scope | does_not_show[3] (the sides are the `side` each `Reorders.swap` takes) |
| L3b "or give an ethical ranking." | standard boundary | standard_boundaries: no-evaluation; and no-ethical-premise (the hypotheses hold no ethical premise; the bound receipts report empty axioms for every cited declaration) |
| — | standard boundary | standard_boundaries: decidability (the idleness decision and decided equality are hypotheses, as hypotheses[1] and [2] say) |
| V0 "Successful Lean 4.29.1 consolidated check (20261013T094743.528770Z): the 101 theorems of Becoming.OrderNormal all have empty axiom reports, among them …" | evidence | validation_scope ("every cited declaration has an empty axiom report"); the receipt named is no longer a binding (the bindings are 20261020T051144.879480Z and 20261021T133545.845568Z), and the count and list stay in that receipt and the snapshot |
| V1–V2 "The same receipt covers the package's 75 modules … periphery receipt 20261013T095049.338744Z passed." | evidence (counts) | receipt + snapshot (the record cites no periphery declaration) |
| V3 "The checker also verifies core purity: …" | evidence (core purity) | validation_scope ("core purity is verified"); the closure list and the injEq/propext detail stay in the receipts and the snapshot |
| V4 "The author's counterreview is in §109 of the integration note;" | evidence | validation_scope ("Author counterreview in the integration note"); §109 is in history entries 0 and 1 |
| V5 "there is no independent review yet." | evidence | validation_scope |
| R0 "P88 connects P78/P78b's supplied footprint to idleness in the world: first state how relations remain unmoved across a step, then use the decision to read off the least touched region." | correspondence + work-item labels | correspondence ("This result connects the footprint supplied in the laws of the order of exchanges (exchanges-commute-unless-joined, order-of-exchanges-is-the-invariant)", the records of the P78 package); P88 is in history entry 0 |
| R1 "The formal condition does not establish that actual worlds have this decision." | correspondence | correspondence (unchanged) |
| R2 "The reading is AI-authored, adopted on Ren's delegation;" | reading label + provenance | correspondence ("The reading is the AI's"); standard_boundaries: names-provisional; the delegation is provenance, kept in the history entry of 16 October 2026 (P110, D30), not a standing for the reading |
| R3 "see integration §109." | provenance | history entries 0 and 1 (existing: "see integration §109") |
| N0 | next step | next_delta (unchanged) |
| H0.0–H2.1 | premises | hypotheses[0]–[2] (unchanged) |
| X0 | counterexample | counterexamples[0] (unchanged; its text repeats the old limitations, now does_not_show[0]–[3]) |

The cold read removed the counterexample, which no declaration witnesses and which does_not_show[0]–[3] and the standard boundaries no-evaluation and no-ethical-premise already carry: X0 goes to those items.
