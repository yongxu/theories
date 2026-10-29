# Migration map: separation-loses-the-relation

Old record sha256 `8b8a5151ff906ea7272b0ca64843c9888e074346017c37e1b8140db23b27bae8`; snapshot `_process/architecture/history/8b8a5151ff906ea7/separation-loses-the-relation.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations: `Rectangular`, `Separated`, `separated_of_whole`, `separation_faithful_iff`, `separation_admits_extra`, `flipIf`, `EvenThree`, `whole_not_in_pairs`, `evenBoxes`, `evenBoxes_glued`, `evenBoxes_not_determined`, `imageOf`, `Rectangular.image_of_separate`, `copy_relates`, `Rectangular.of_image_injective`, `relation_persists`, `forgetting_unrelates`, `couple`, `couple_couple` and `coupling_relates_and_unrelates` in `Becoming/Description.lean`; `restrict`, `Glued`, `PartsDetermine`, `Specker.Box` and `Specker.within` in `Becoming/Context.lean`; `Courses.reachedFrom`, `Courses.courses_keep_unrelated`, `Courses.relation_persists_courses`, `Courses.copy_relates_course`, `Courses.forgetting_unrelates_courses` and `Courses.coupling_course` in `Becoming/Courses.lean` (all in the namespace `Becoming`). Every condition the Lean takes is kept: `relation_persists` and `Rectangular.of_image_injective` need f and g to merge nothing that occurs in the whole (law 6); `relation_persists_courses` needs them to merge nothing at all, a stronger condition (law 9, hypotheses[1]); `evenBoxes_not_determined` is a negated universal, read as “not every reading the pairs allow is of even parity” (law 4). The Courses declarations were already in the references and aliases (added 16 October with the reading on the shared base) but stated in no law; laws 9 and 10 state them. No declaration was added to the references. The bound core receipts report empty axioms for every cited declaration and the hypotheses hold no ethical premise, so `no-ethical-premise` is cited.

| Old text | Type | New place |
|---|---|---|
| T0 “Separation loses exactly the relation” | title | title (unchanged) |
| S0 “Describing the parts separately gives back the whole exactly where it is rectangular” | statement | statement (unchanged) |
| S1 “a relation forms only by joint action, lasts under separate laws that lose nothing, and ends only by loss or joint action” | statement | statement, “that lose nothing” narrowed to “that merge nothing that occurs”, the condition `relation_persists` takes and the home section states |
| S2 “parity is a whole its pairs do not give back.” | statement | statement (unchanged) |
| C0 “Let whole be a whole on A × B (which combinations occur).” | definition | law 1 |
| C1 “It is rectangular (Rectangular) when whole (a, b) and whole (a′, b′) give whole (a, b′)” | definition | law 1 |
| C2 “the separated description (Separated whole p) says only that each part of p occurs.” | definition | law 1 (“admits a pair where each part occurs with something”, as `Separated` has it) |
| C3 “Separation keeps every combination that occurs (separated_of_whole), and it contains only what occurs exactly when whole is rectangular (separation_faithful_iff)” | law | law 1 |
| C4 “two parts that always go alike can go apart when described separately (separation_admits_extra).” | law | law 2 (the witness written out: equal parts on Bool × Bool, (true, false) admitted and not occurring); counterexamples[0] |
| C5 “Three parts can be related as a whole while every two are free: in the even-parity triples any two values complete to an even triple, and (true, false, false) is not one (whole_not_in_pairs)” | law | law 3 |
| C6 “on Specker's three boxes and three pairs (restrict, Glued and PartsDetermine of Becoming.Context) every reading is allowed by every pair (evenBoxes_glued) and the pairs do not give the whole back (evenBoxes_not_determined).” | law | law 4 (the negated universal kept as one: not every reading the pairs allow is of even parity) |
| C7 “Write imageOf next whole for the configurations a law next leads to from whole.” | definition | law 5 |
| C8 “A law moving each part by itself (f × g) keeps a whole rectangular, lossy or not (Rectangular.image_of_separate)” | law | law 5 (“for any f and g”) |
| C9 “the law copying the first part into the second turns the full whole into the parts being equal, which is not rectangular (copy_relates).” | law | law 5 |
| C10 “Where f merges no two first parts that occur and g no two second parts, a rectangular image under f × g gives a rectangular whole (Rectangular.of_image_injective), so a whole that is not rectangular stays so under such a law (relation_persists).” | law | law 6 |
| C11 “A law sending the first part to one value, however it moves the second, leads to a rectangular whole (forgetting_unrelates).” | law | law 7 |
| C12 “For example, couple (x, y) = (x, flipIf x y) on Bool × Bool is an involution (couple_couple)” | law | law 8 (“undoes itself”) |
| C13 “it leads from “the second part is false” (rectangular) to a whole that is not rectangular, and acting again back to “the second part is false” (coupling_relates_and_unrelates).” | law | law 8; counterexamples[0] |
| C14 “No Lean axiom is used.” | standard boundary | standard_boundaries: no-ethical-premise |
| — | added laws | laws 9 and 10: the laws along the courses of a determined law's process (`Courses.reachedFrom` and the five course theorems), referenced since 16 October and stated in no law before; law 9 writes in that `relation_persists_courses` needs f and g to merge nothing at all |
| H0 “No premise: separation_faithful_iff is two-way and holds for every whole” | premise | hypotheses[0] (unchanged) |
| H1 “Rectangular.image_of_separate holds for any f and g.” | premise | hypotheses[0] (unchanged) |
| H2 “relation_persists needs f and g to merge nothing that occurs (a local condition, written into the theorem).” | premise | hypotheses[1], with relation_persists_courses' condition, merging nothing at all, added |
| H3 “For the witnesses: parity, copying and couple are on Bool.” | premise | hypotheses[2] (unchanged) |
| X0 “A whole that is not rectangular gains combinations when described separately (separation_admits_extra)” | counterexample | counterexamples[0] (unchanged; `separation_admits_extra` witnesses it) |
| X1 “the even parity of three parts is held by no pair (whole_not_in_pairs)” | counterexample | counterexamples[0] (unchanged; `whole_not_in_pairs`) |
| X2 “a lossless coupling can end a relation (coupling_relates_and_unrelates), so losing nothing does not keep a relation without “moving each part by itself”.” | counterexample | counterexamples[0] (unchanged; `coupling_relates_and_unrelates`) |
| L0 “Relation is stated for wholes of two parts (rectangularity is the standard product criterion), parity witnessing three” | scope | does_not_show[0] (scope) |
| L1 “which joint laws keep wholes rectangular is not characterized” | non-implication | does_not_show[1] (non-implication); the next step (N0) |
| L2 “a coupling ending a relation has one witness” | scope | does_not_show[2] (scope, witness `coupling_relates_and_unrelates`) |
| L3 “PartsDetermine and separation_faithful_iff are not related as instance and law (the two parts have different types)” | non-implication | does_not_show[3] (non-implication), in words: parts giving back a whole across contexts and the separation of two parts |
| L4 “the readings are the AI's” | reading label | correspondence, which carries the readings with their AI label (R2) |
| L5 “contains no ethical predicate.” | standard boundary | standard_boundaries: no-evaluation |
| — | standard boundary | discrete-steps (the courses are counted in natural-number moves) |
| V0 “14 October 2026: the current bytes of Becoming.Description are bound to consolidated receipt 20261013T204910.042715Z (passed: 85 package modules, 4861 theorems, 6856 declaration audits, every source declaration with an empty axiom report; the 86-module core closure compiles from the prelude).” | evidence (bookkeeping of the 14 October binding) | validation_scope names the receipts that bind the current bytes now (Description `becoming-checks/20261019T231053.882924Z`, Context `becoming-checks/20261019T213206.644158Z`, Courses `becoming-checks/20261020T051144.879480Z`); the 14 October receipt and its counts stay in references and the snapshot |
| V1 “Earlier receipts below checked the same statements under the former names, tabulated in plan section 10.” | evidence (bookkeeping) | snapshot; the renames are in history |
| V2 “Successful Lean 4.29.1 consolidated check (20261013T094743.528770Z): the 53 theorems of Becoming.Description all have empty axiom reports, among them separation_faithful_iff, separation_admits_extra, whole_not_in_pairs, evenBoxes_glued, evenBoxes_not_determined, Rectangular.image_of_separate, copy_relates, relation_persists, forgetting_unrelates and coupling_relates_and_unrelates” | evidence | validation_scope (“every cited declaration has an empty axiom report”, read from the current bound receipts) |
| V3 “the same receipt covers the package's 75 modules (including the import-only root and the bridge) with 4518 theorems/6370 declaration audits, and 22 inherited modules whose current bytes match passed receipts” | evidence (bookkeeping) | snapshot |
| V4 “periphery receipt 20261013T095049.338744Z passed.” | evidence (bookkeeping) | snapshot |
| V5 “The checker also verifies core purity: the import closure of the core (GenerativeCore, InquirySufficiency, RelationalRenewal, L1–L4 and the root module Becoming) is exactly these 77 modules, every source declaration in it has an empty axiom report (of the constants Lean generates, only the injectivity lemmas of constructors with fields, injEq, depend on propext; no source declaration uses them, and the checker lists them), and it compiles from Lean's prelude alone (the foundation's import Std removed for that run).” | evidence (what the checker does, true of every core receipt) | snapshot; validation_scope says the receipts are core receipts of the consolidated checker |
| V6 “The author's counterreview is in §94 of the integration note, with the scope of the independent review.” | evidence | validation_scope; the section number stays in the correspondence (R5) |
| R0 “The first part of P70 (work board), following Ren's “push the frontier, as far as possible” of 12 October 2026, answering Ren's “the framing may lose something” and “what makes a pair, a pair?”: what describing the parts separately deducts is exactly the relation” | correspondence | correspondence, the process marker “The first part of P70 (work board),” cut; Ren's words kept verbatim with their date |
| R1 ““what can go together” is the record at a moment of “how they go on”.” | correspondence | correspondence (unchanged) |
| R2 “Readings (the AI's, adopted on Ren's delegation; Ren agreed with the reply containing them): a correlation is the memory of a meeting” | reading | correspondence (unchanged) |
| R3 “三生万物 read as three being the least number at which a whole holds a relation no part holds.” | reading | correspondence (unchanged) |
| R4 “The other way parts fail a whole (parts allowing what no whole has) is no_whole of claims-shown-in-context, on the same three pairs.” | correspondence | correspondence (unchanged); the dependency on claims-shown-in-context |
| R5 “See §94 of the integration note.” | pointer | correspondence (unchanged) |
| N0 “Characterizing the joint laws that keep wholes rectangular” | next step | next_delta (stated positively) |
| N1 “one statement of separation and of parts giving back the whole for n parts.” | next step | next_delta |

The correspondence's former id (contextual-registration, triage row 78) was already replaced by claims-shown-in-context on 25 October; nothing of it remains.
