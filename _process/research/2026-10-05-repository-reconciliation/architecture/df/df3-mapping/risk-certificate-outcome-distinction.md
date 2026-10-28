# Migration map: risk-certificate-outcome-distinction

Old record sha256 `e1684e0682dec09954c00d1cb749ce4a220a058b2593be54f92651b59211332c`; snapshot `_process/architecture/history/e1684e0682dec099/risk-certificate-outcome-distinction.json`.

Labels number the old English sentences and clauses (split at full stops and semicolons outside parentheses): T title, S statement, C claim, L limitations, V validation_scope, R correspondence, N next_delta, H hypotheses, X counterexamples. The Chinese text of each field goes to the same place as its English counterpart; the old Chinese was read alongside, sentence by sentence.

Each law was read against its declarations: `LumpedOn`, `Judges`, `judges_iff_lumpedOn`, `lumpedOn_of_judges`, `firstJudge`, `firstJudge_judges` and `no_judge_of_merged` in `Becoming/Readout.lean`; `reducedRun`, `run_judges_iff` and `no_run_judge_of_merged` in `Becoming/Courses.lean`; the five theorems of the periphery `deeper/WisdomFallibleJudgment.lean`; and the seven declarations of the periphery `deeper/JudgingCorrespondence.lean`. Every condition the Lean takes is kept: decidable equality of the reduced values for the existence of a judge (`judges_iff_lumpedOn`, `run_judges_iff`, in the `variable [DecidableEq K]` of their sections), not taken by the two failure laws (`no_judge_of_merged` lies outside that section, `no_run_judge_of_merged` takes none), which laws 2 and 3 say; the three-route process, the two equal-weight event laws and route 0 for the periphery (laws 4–6, hypotheses). The core receipts bind Readout.lean and Courses.lean and report empty axioms; the periphery receipts report propext only (WisdomFallibleJudgment, Lean 4.29.1) and at most propext and Quot.sound (JudgingCorrespondence, Lean 4.30.0-rc2), so `no-ethical-premise-core-axiom-free` is cited.

| Old text | Type | New place |
|---|---|---|
| T0 “Risk bounds and realized outcomes” | title | title (unchanged) |
| C0 “In the supplied three-route process with two finite equal-weight event laws, a true one-third risk bound permits actual failure” | law | statement (second clause); law 4 (`uniform_failure_weight`, `bounded_risk_without_uniform_completion`, `biased_bound_fails`) |
| C1 “no judge using only the mode/arrival projection correctly classifies that prior bound for every admitted realization of both laws.” | law | statement (last clause); law 5 (`matching_realizations_with_different_certificates`, `no_endpoint_only_prior_certificate`) and law 6 (its reading on the core law, `JudgingCorrespondence`) |
| — | added laws | statement (first clause) and laws 1–3: the core law the impossibility is an instance of, which the home section states (“a judgment through a projection is right only where it does not merge what must be told apart”) and the record cited (`judges_iff_lumpedOn`, `no_judge_of_merged`, and the run form `run_judges_iff`, `no_run_judge_of_merged`) |
| H0.0 “Arrival fails exactly when the mode equals the selected route.” | premise | hypotheses[0] (unchanged) |
| H0.1 “Supplied event lists are [0,1,2] and [0,0,1,2], with equal weight per entry” | premise | hypotheses[0] (unchanged) |
| H0.2 “duplicate modes denote distinct events, not duplicate observations.” | premise | hypotheses[0] (unchanged) |
| H1.0 “One third is a numerical specification.” | premise | hypotheses[1] (unchanged) |
| H1.1 “The endpoint judge receives only the mode/result projection, not the law or full history.” | premise | hypotheses[1] (unchanged) |
| L0 “A local application, not new probability theory.” | scope | does_not_show[0] |
| L1 “Ethical risk acceptance, probability learning and the complete wisdom root remain unproved” | non-implication | does_not_show[1] (ethical acceptability of a risk, learning of event probabilities) and does_not_show[2] (“It does not establish the whole of wise judgment”); “remain unproved” is read as a non-implication, the status being the status field's |
| L2 “the event laws and process are supplied.” | premise | hypotheses[0] (the supplied process and event lists), which already says it |
| X0.0 “The risk statement is true while the target realization fails” | counterexample | law 4 (under the first law every route is within the bound yet fails at its own mode, `bounded_risk_without_uniform_completion`); the entry's source is the study, not a declaration, so the case is carried by the law that proves it and counterexamples is empty |
| X0.1 “warranted false belief is not established.” | non-implication | does_not_show[3] (witness `bounded_risk_without_uniform_completion`: the risk statement stays true when the realization fails) |
| X0.2 “Endpoint insufficiency does not make outcomes irrelevant to updating.” | non-implication | does_not_show[4] |
| V0 “Lean 4.29.1 actually checked five new application theorems, each using only propext” | evidence | validation_scope (WisdomFallibleJudgment's receipt under wisdom-fallible-judgment-checks, Lean 4.29.1, five theorems with propext only) |
| V1 “59 inherited audits are separate, 64 overall with 44 empty / 20 standard.” | evidence (counts of the 8 October run) | snapshot and the periphery receipt, which records them |
| V2 “Frozen source and receipt are bound” | evidence | validation_scope (each binding named) |
| V3 “no repository-wide acceptance.” | evidence | snapshot; the periphery receipt's own scope says it |
| R0 “Inherited assured_route_iff connects counted failures with failed arrival.” | correspondence | correspondence (unchanged) |
| R1 “A probability interpretation still needs warranted event weights” | correspondence | correspondence (unchanged) |
| R2 “ethical permission does not follow from the bound.” | correspondence | correspondence (unchanged); does_not_show[1] states the related non-implication of L1 |
| N0 “Reuse this completed scope correction.” | instruction | not in next_delta (an instruction to reuse the result); the sentence stays in the snapshot |
| N1 “The full-root study must examine independent wisdom content and the entire substantive core, rather than substitute more risk examples.” | next step | next_delta, stated positively (“Examine the content of wise judgment beyond risk bounds, and the whole of its substantive commitments”) |
| — | standard boundary | standard_boundaries: no-ethical-premise-core-axiom-free (no ethical premise in the hypotheses, the bound so read a numerical specification; core declarations with empty axiom reports; periphery declarations with propext and Quot.sound only) |

The dependency on assured-route-criterion, the aliases, the references' paths, hashes and declarations and the proof bindings are unchanged; no declaration was added, every law naming declarations the references already listed. The second text_versions entry is the compaction snapshot named by the 20 October history note.

**Chapter edit proposed (not made).** The home section in `theories/becoming/chapters/03-KNOWING.md` says the application theorems use propext; the record's JudgingCorrespondence declarations, which read the endpoint test on the core law, use propext and Quot.sound as their receipt reports. Old: “(any process; a supplied three-route process; the application theorems use propext)”. New: “(any process; a supplied three-route process; the application theorems use propext, their reading on the core law propext and Quot.sound)”.
