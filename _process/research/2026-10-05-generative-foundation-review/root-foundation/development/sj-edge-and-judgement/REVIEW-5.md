# REVIEW-5: two independent reads of the note on how evaluation forms

Two AI readers, 2 November 2026, read [the note](HOW-EVALUATION-FORMS.md) and its block at 07 §1 as first landed (6500dce37): one for exactness against the Lean and the records, one adversarially on the argument. Each worked alone and read only. The note's author checked the main citations against the Lean before taking them. Their reports are kept verbatim below. No person has read this.

## What was taken

**From the first reader.** All fifteen findings. The wrong declaration for a dependence forming anew, with its dropped conjunct; "fixed by the exchange" narrowed to a bound on what a requirement can say; `«续无外随网»` moved to the tied reading; "no law joins" narrowed, since one link runs through the relation; §5's search claim narrowed, since a dependence does form anew and a goal or code can go from none to one with its source supplied; significance from dynamics alone narrowed to the free parameter; the instance of `rival_of_outside` stated through `bounded_is_rival` and said to be unstated in Lean; the rule-shaping row at one step and weak; §3's bound and its witness withdrawn; "no law here picks"; the inhabitants of `admits_rival`; the supplied list completed; the base columns; `GoalFormationRevision` off the spine, not in the history; "can be reached"; a glossary row for *standard*.

**From the second reader.** The dilemma against "that is why it is a premise" (withdrawn); "bounded by what comes back" (withdrawn: the laws say which carriers spread, not what a standard is about); the 07 block's unlabelled statement of a standard (now said of the significance); the fronts' sentences rewritten, with *by construction*, the right join, and order named; "Neither half" replaced by the first half made precise; three things and a limit in place of four standings; the sorting's basis, scope and omissions stated; *standard* defined; the identification named as what no law alone could supply; no time of holding stated; route (b), P1 and the de se question brought in; §5's missing items added; the phrase on one standard's reach being better than another's withdrawn, and both premises named in the warrant's sentence.

**Not taken as proposed.**
- The second reader's suggested opening, "how far evaluation is shown to", became "how far evaluation does", a matter of wording.
- 07 §1's title and first sentence ("Positions, regions and standards form") stay, because records cite that section. The block says how much the title covers. A reader may still count this as a caveat beside a headline; the chapter's Thesis and the fronts carry the correction.
- The named philosophers in the second reader's reading (Railton, Street, Korsgaard, Thompson, Di Paolo) are from its memory and unchecked, so the note does not cite them. Relational constitution of value is the serious rival to the account's sorting, and belongs with P4's philosophers, not in this note.

## The first reader: exactness against the Lean

### Independent read of HOW-EVALUATION-FORMS.md and its 07 §1 block

Eleven of the fifteen findings need a change to the text, and §5's search claim is refuted at one grain. The most serious are findings 1 to 6. I changed nothing and compiled nothing. Line numbers are in `Becoming/` unless another path is given.

### Findings

**1. §2 row 2 cites the wrong declaration and drops a conjunct.**
- Sentence: "a dependence forms anew at a descent exactly where the giver drew on what it did not depend on (... `Web.formsAnew_iff_drawn_or_neither`)".
- Lean, wrong declaration: that theorem (`Transmission.lean:310`) is the split without the reading, whose right side has both a drawn and a not-drawn case. The stated law is `Web.formsAnew_iff_drawn_unheld` (`Transmission.lean:324`), which 04 §r-dependence cites correctly.
- Lean, dropped conjunct: its right side also has `W.requires (t+1) x c`, the descendant depending. The note's sentence drops it, as does the record's one-line statement.
- Strength: `FormsAnewAt` is defined as requires ∧ ¬requires (line 244), and the hypothesis `DependsOnDrawnAt` is requires → draws (line 278). So the law is one step from its definition plus its hypothesis. It takes no descent premise either: `x` and `g` are bare arguments.
- Reword: "under the reading of drawing at the descent, a hypothesis, a dependence forms anew exactly where the descendant depends and the giver drew on what it did not depend on (`Web.formsAnew_iff_drawn_unheld`); near-definitional". Change the label "A need forms" to "Where a new need comes from".

**2. §2 row 1 and the 07 table: "A requirement is fixed by the exchange, not by an evaluator".**
- `respondsBelow_weakest` (`OverExchange.lean:741`) takes `sound` and `local_` as hypotheses and concludes R → RespondsBelow. That is an upper bound on what any such reading can say. It does not fix a requirement.
- By inspection of `Supports` and `Local`, R := False is sound and local.
- `requires` stays a given field of `Web`.
- The need is given in the reading (`requirement-over-open-exchanges`, hypotheses).
- `premises-read-off-the-exchange`, law 6 (`ExchangeLaw.responsive`, `unresponsive`) says "Requirement is not in the course". So "the exchange" must mean the law of exchange, not what is exchanged.
- The record also says locality is argued, not proved.
- Reword the label: "What a requirement can say is bounded by the law of exchange, with no evaluator in the statement". Base column: "over every relation of exchange (01 labels it World); thresholds; soundness and locality are hypotheses, locality argued, not proved".

**3. §2 "Out of reach": `«续无外随网»` is under the wrong heading.**
- Sentence: "Out of reach of the represented dynamics, for the free parameter ... The condition's root form varies with the net (`«续无外随网»`...)".
- `«续无外» rel «一» center` (`GrammarScope.lean:87`) is exactly the tied reading, by `ownClosure_unrestricted_iff_noOutside` (`GrammarScope.lean:264`).
- So this theorem (`PremiseWitnesses.lean:136`) concerns the second standing, not untied `sig`. It shows that at a given net the tied condition is settled, holding at one net and failing at another. That is the opposite of out of reach.
- The 07 table is right to omit it.
- Reword: move the sentence to "Read": "Tied along 缘, whether the condition holds varies with the net (`«续无外随网»`, root, on two constructed nets)".

**4. §3 and 07 block: "No law joins the first standing to the second" is refuted as worded.**
- `Flow.ownClosure_feeding_invariant_of_common` (`Weightings.lean:~1708-1711`, record `self-concern-through-dependence`) takes `W.requires t (center p) c ∧ 0 < L.give ...` and concludes `StandpointInvariant (selfAscribed (ownClosure (L.FedFrom W)) center)`.
- `FedBy` reads `requires` (`Continuation.lean:1117`).
- `Web.selfValuation_feeding_own` (`Boundaries.lean`) and `Flow.feedingFrom_permits` (`feeding-from-a-step`, law 2) run the same way. A need's change moves the tied significance's region.
- The next sentence ("Nothing proved says that a standard which formed is thereby a significance") survives.
- Reword: "No law says that a standard which formed is a significance. The one formal link runs through the relation: along feeding a center's closure reads what requires what, so a need that forms or lapses moves the tied region (`Web.selfValuation_feeding_own`, `Flow.feedingFrom_permits`). That is a need changing the reach, not a need being a significance."

**5. §5 first item (your question 6): refuted at the grain of one formation and one condition.** The sentence: "Each law in §2 starts from something standard-like already there ... no law whose start has no standard and whose end has one". Counterexamples, strongest first:
- `dependence-formed-from-drawing`, `Web.formsAnew_iff_drawn_unheld`, witness `World.droppedHatch_formed`: a requirement on `c` at the descendant where the giver had none. This is §2's own row 2, and nothing in the note's list ("a carried capacity to shape, a rule, a task, a hearing, a threshold") names its start.
- `World.novel_formed_undrawn` (`Transmission.lean:1067`, also `map-of-premises` law 9, "a dependence the parent never had"): the giver neither held nor drew on it.
- `ceasing-needs-arising` law 4, `Web.DependenceCensus.forming_of_dissolving`; `coming-and-ceasing-keep-pace` law 1; `becoming-dependence-dynamics`: dependences forming, as general laws. These state forming in general and do not generate it.
- `formed-goal-revision-continuation`, `GoalFormationRevision.experience`: `goal` starts `none` (`GoalFormationRevision.lean:230`) and becomes `learnedGoal a b` (lines 238, 256). This is literally none to one, with Goal, practices and feedback supplied.
- `composition-route`, `CodeAcquisition.installed_not_executed` (`CodeAcquisition.lean:288`, `:300`): "A learner with no code" ends with `some usual`, from a supplied training code. Weak, since the code is already present elsewhere.
- `a-code-formed-between-formations`, `run_agrees_every_start_iff`, `TwoFormations.three_agree`: a shared code where forms differed. Hearing makes no form (law 1, `shared_iff_in_use`), so individual codes are there. Row 4's start is codes, not "a hearing".
- `requirement-over-open-exchanges`, `ExchangeRelation.readWeb`: a requirement read from a relation with no requirement field, the need given. Static, not a transition, but row 1's "threshold" is a quantified `n`, not something already there.

The candidates I read and rejected, all with the standard supplied:
- `one-move-covering`, `setting_covers_and_gains`, whose goals are arbitrary predicates
- `a-goal-along-a-lineage`
- `organizational-rule-inheritance`
- `capture-through-the-rule`
- `what-training-installs`, from its one-line statement only

What survives is narrower. Suggested wording: "No record states a law in which a requirement, rule, task or goal is generated by dynamics that supply none. `requires` is a field of `Web`, and the laws on forming anew classify its values, under a hypothesis on where it comes from. Where a goal or code goes from none to one, the source, feedback law or Goal type is supplied (`GoalFormationRevision.experience`, `CodeAcquisition.step_installs`). Agreement goes from none to one only among codes already held. The search was by the records' statements, so this is 'none found', not 'none'."

The same point undercuts §4's reason for "shaped, not form". The note treats a requirement as a standard in row 7, while saying "needs form" in row 2.

**6. §5 third item: "Significance from dynamics alone. Not available in this representation, by the theorems in §2".**
- The theorems cover statements where `sig` is a free argument and truth does not vary with it (`Significance.lean:276`).
- `selfAscribed (ownClosure (L.FedFrom W)) center` is a significance computed from the flow, the web and the centers. It is the note's own second standing, and such a definition falls outside `ReadsOnlyDynamics`.
- Reword: "No statement reading only the dynamics fixes the free `sig` (§2). A significance defined from the dynamics is available, the tied reading along feeding, given centers. What it lacks is any law that it is the significance, and calling it so is the reading."

**7. §3 and 07 block: "A standard held de se along a relation is the continuation condition exactly where..." (your question 5).**
- Both theorems are about one content, `ownClosure`, not any standard held de se. `selfAscribed content center` for another content has no such iff.
- The instance does hold, by reading, with no extra hypothesis. Take `region := fun i => WithinClosure rel (center i.1) i.2.2`, and `fun p t f => region (p,t,f)` unfolds to `selfAscribed (ownClosure rel) center`. No decidability is needed, and the standpoint and formation come from the outside witness.
- No Lean declaration states this instance, and I did not compile it.
- `rival_of_outside` (`Significance.lean:188`) concludes `¬ Unrestricted` and a trivial `Within`, not `Rival`. Since `bounded region` is `fun p _ f => region p f` (`Retaining.lean:58`), the tied reading is `bounded` of that region, and `bounded_is_rival` (line 233) gives `Rival` directly.
- "Where something lies outside" needs a positive witness. The two clauses are not exhaustive constructively, since `¬∀` does not give `∃¬`.
- 07's block carries this as a bare statement, outside a Reading label.
- Reword for both: "Read as a center's closure along a relation (`selfAscribed (ownClosure rel) center`), significance is the condition exactly where every center's closure is the whole (`ownClosure_unrestricted_iff`), and a rival given a point outside (`bounded_is_rival`; this instance of `rival_of_outside` is not stated in Lean). Whether a formed standard has this form is the reading."

**8. §2 row 3: "the rule favours them exactly where what comes back to them alone covers the cost".**
- `favours_iff` (`RuleShaping.lean:135`) is at one step and weak. The record gives counterexamples across a stretch: `Timing.late_falls`, `shorter_falls`, `SharedFlips`, with c < s and the share falling.
- `a`, `s`, `p`, `c` are supplied constants, and transmission is a premise.
- What gains share is the capacity, not a standard.
- Reword: "at a step the rule favours them, weakly, exactly where..." and add to the base column: "across a stretch, the counts of steps before and with it decide". Change the label to "A capacity to shape a rule gains share".

**9. §3 Reading goes beyond what it can lean on, even as a reading.**
- "Standards that form by what comes back are bounded by what comes back." No theorem states a bound on a region. `favours_iff` is about counts, and rows 2, 4, 5 and 7 are not "by what comes back".
- "that is why it is a premise." 07 gives the reason differently: the theory asserts neither premise, its warrant is open, and no reading-only statement entails it. Delete the clause, or write: "it asks more than a bounded standard gives; whether that is warranted stays open".
- "The clearer's witness ... shows the difference in one world." `Clearing.time_bounded_permits` is a stipulated time bound, not a formed standard and not an own-closure reading, since `ownClosure` ignores `t`. Reword: "shows a rival and the condition parting in one world; that rival is stipulated, not formed".

**10. §4: "along a relation no law picks".**
- The docstring says "not derived here" (`Boundaries.lean:36-38`). The record `not-going-out-of-a-region` says the laws "choose neither". My search found no law picking one, so this is a search result, not a theorem.
- 07's thesis also leaves open which occurrences are centers.
- Reword: "along a relation no law here picks, from centers no law here picks".

**11. §4: "laws show how needs form".**
- 04's home section says "where a new dependence comes from, not why". The record's Does not show has "Why a descendant comes to depend", and its Next has "Why drawing becomes depending".
- Suggested sentence: "Under stated conditions, laws show where new needs come from, how standards are shaped and gain influence, and what a response within a standard takes; that any of it has significance they do not show: significance is supplied, where no satisfiable statement reading only the represented dynamics fixes it (by construction of the representation), or read from a center's closure along a relation no law here picks."
- Change §2's bold line to match.

**12. §2: "No satisfiable statement ... excludes a rival or, with a standpoint and a formation, entails the condition".**
- `admits_rival` (`Significance.lean:287`) takes `outside : ∃ p f, ¬ region p f`. With no standpoint or formation there is no rival, so every statement excludes rivals vacuously. The inhabitants are needed for both clauses.
- Reword: "Where there is a standpoint and a formation, no satisfiable statement reading only the dynamics excludes a rival or entails the condition."
- The same applies to 07's table row, in its short form.

**13. "Supplied" and §1's "exact".**
- The list omits A, D and E, which 07's Bases names beside L and J1–J4.
- It omits the reading itself (`a-response-common-over-a-reading`, Conditions: "A reading is a relation on situations, supplied"; `KeptBy`'s `B` in `keeps_continues_iff`).
- It omits the reference valuation and the reading formation's valuation in row 6.
- So §1's "'the one evaluative parameter supplied' is exact" holds only for `Web.selfValuation` (`Boundaries.lean:~27-28`) and 07's definition. `ListingValuation` takes a supplied evaluative parameter that is not `sig`.
- Reword §1: "is exact of the World's significance". Add the three omissions to the list, and to 07's Supplied row.

**14. §2 row 6: the base column omits the evaluative input.**
- The record has "the reference valuation and the holding formation's model supplied", cells listed once and covering, and their equality decidable.
- "A finer map never raises what the map loses" is `least_falls` (`ListingValuation.lean:741`), which needs the coarser map to factor through the finer. It is true of the least shortfall only: a finer map can move the residual either way and lower the worth (law 17, `WeightsApart.weights_matter`).
- Reword: add to the base "by a supplied reference" and "the residual can rise".

**15. Smaller points.**
- §5: "(`GoalFormationRevision`, in the history)". The record `formed-goal-revision-continuation` is live, recorded-checked, and its canonical source is `lean/universal-ethics/generative-capacity/GoalFormationRevision.lean`. Only copies are under `lean/history`. Reword: "off the Becoming spine (record `formed-goal-revision-continuation`)". The "explicit local premises" clause is right; the file's header says it, and adds the calibrated reference, protected claims, authority and costs.
- §2 row 4: "A shared standard is reached" should be "can be reached", since `never_agrees` and `crossing_never_agrees` exist. The base omits that the rule is given and that "the start and the order fix the form" needs hearings that take the form heard. A code has no acceptance criterion, so calling it a standard is a reading.
- §5's list: "a hearing" should be "codes".
- "Standard" has no GLOSSARY entry, while the note uses it for rule, code, threshold, order and requirement. AGENTS asks for one sense per term.

### Checked and correct

- `Web.selfValuation_own_least` (`Boundaries.lean:232`) says own events held, a boundary, and within every boundary, so "least boundary" is exact. It is near-definitional.
- `selfAscribed (ownClosure rel) center` reads only `rel` and `center`, and ignores `t` (`Weightings.lean:1544`, plus the `ownClosure` definition).
- `ownClosure_unrestricted_iff` (`Weightings.lean:1592`) is as stated.
- `Becoming.Boundaries` says the relation is not derived, with the word "here".
- The task `K` is a supplied variable in `keeps_continues_iff` (`ReadingLoop.lean:231`).
- The set level is a field of the rule in `ReaderRebuilding` (line 78).
- `not_entails` (`Significance.lean:296`) and the confinement to untied `sig` hold.
- The caveat on the representation matches 07 line 23, which adds "or needs the condition".
- `«续无外随网»` is root and on constructed nets. Only its placement is wrong (finding 3).
- Row 5's base, including "near-definitional", matches 03 §11.
- Row 7's law and base match `CommonResponse.lean:88,153`.
- Row 4's "any type; equality decided for runs" matches 05's label and `SharedCodes.lean:196`.
- Row 3's "counts" and row 1's "World" match their home labels.
- "None reads significance": `sig` and `Unrestricted` do not occur in Transmission, RuleShaping, SharedCodes, ShownOrder, ListingValuation or CommonResponse. They do occur elsewhere in OverExchange, but not in `respondsBelow_weakest`.
- All 07 table links resolve to existing anchors, and 03 §11 and §12 are numbered as cited.
- "That any of it has significance they do not show" holds of those laws. Significance reaches them only under the condition (`Web.selfValuation_of_unrestricted`).
- The fronts' phrase is real: `ONE-PAGE.md:7`, "how life, knowing and evaluation form".

### Not fully checked

- Rows 4 and 5, and the kernel laws other than the one cited, were read through the record and home text, not each Lean statement.
- "A revaluation changes only the residual" has no single declaration that I found. It follows because `leastThrough m gain loss π` takes no reader valuation, but I read `least_falls` and did not read `cond_split_least`.
- My search for question 6 used English regexes over the 527 records' statements, laws and does-not-show entries, plus some Lean docstrings. It is "none further found", not "none".

The note is at `/Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/sj-edge-and-judgement/HOW-EVALUATION-FORMS.md` and the block at `/Users/ren/theories/theories/becoming/chapters/07-SIGNIFICANCE.md`, lines 32-42.

## The second reader: adversarial on the argument

### Adversarial read of `HOW-EVALUATION-FORMS.md` and its block at 07 §1

**Verdict.** The sorting in §2 survives, and the note's care about the representation is real. Four things do not survive:
- §3's central sentence;
- the second sentence of the paragraph under the 07 block's table;
- the fronts' sentence in §4;
- §4's fallback of narrowing *evaluation* to *standards*.

I changed nothing and ran no Lean. The note is on main, landed in 6500dce37. Its sentence has gone to the reader revision and is not yet on the fronts.

### 1. §3's "that is why it is a premise" fails, and it imports a claim about warrant

**Hits:** "This is one reason the condition cannot be offered as a description of how evaluation forms: it asks more than what forms, and that is why it is a premise."

The sentence fails on a dilemma.
- **If a formed standard is what significance is:** the condition is true or false of a net (07 §4.5: "true or false once the net, the class and the centers are given"). Where something lies outside, it is simply false. Its warrant is then settled net by net, not open.
- **If a formed standard is not what significance is:** a standard falling short of the condition says nothing about the condition. It compares what is with what is asked, so it cannot be why the condition is a premise.

A test case shows the problem. Where every closure is the whole, what forms would be the condition (`ownClosure_unrestricted_of_whole`). "That is why" then implies no premise is needed there. That contradicts the next paragraph's "does not settle the premises' warrant" and 07 §1's "learning a disposition is not learning a reason".

The sentence also slides from "one reason" to "that is why" within one line.

**Change:** see the replacement for §3 at the end of this report.

### 2. "Bounded by what comes back" confuses what spreads a standard with what it is about

**Hits:** "Standards that form by what comes back are bounded by what comes back. So, read this way, what forms in the unfolding is in general a rival of the condition, not the condition."

- **The law has nothing to bound.** `RuleShaping` has counts `a, c, s, p` and two kinds of carrier. It has no content, region or reach. It governs the shapers' share, not what they hold.
- **The share is not bounded either.** `c_zero_favours`: with no cost, the rule favours the shapers "whatever comes back".
- **The premise covers one row and the conclusion covers all.** Most of §2 does not form by return: codes form by hearing, and orders are read off acts. "What forms in the unfolding" still generalizes over everything.
- **"In general" ranges over a parameter the note says no law picks.** The relation is unpicked, along the total relation the presupposition is the condition (`presupposition_scopes`), and the root form is "met by some nets and failed by others".
- **It leaves the representation.** "In the unfolding" is the kind of claim §2 and 07 §1 refuse to make from a model.
- **The witness does not help.** `Clearing.time_bounded_permits` uses a stipulated `boundedInTime T`, which is not a standard that formed.

*My reading, not a proof:* standards whose content outruns their selection look like a real counterexample. A concern for those who cannot reciprocate is selected for its carriers while being about others. The chapter's own reading holds a place for this: ZERO-AXIOM §19 has "no return to oneself is presupposed". Whether actual standards fall short of the condition is empirical, and the note offers no evidence.

**Change:** see the replacement for §3 at the end of this report.

### 3. The 07 block says more than the Lean proves

**Hits (07 §1, not marked as a reading):** "Held de se along a relation, a standard is the condition exactly where every center's closure under that relation is the whole (`ownClosure_unrestricted_iff`), and a rival where something lies outside (`rival_of_outside`)."

- **The theorem has no standard in it.** It concerns `selfAscribed (ownClosure rel) center`, and its docstring says "the presupposition". AGENTS.md requires a proof claim to say exactly what the Lean proves.
- **No map exists.** Nothing takes a threshold, count rule, code or strict order to a `(rel, center)` pair. So the note's "What can be said exactly is how the two would stand if joined" is exact only on the significance side.
- **"Rival" is near-empty and reads as hostile.** `rival_iff_lacks` says a rival is just some point lacking significance. 07 §4.1 calls route (b) and the condition one presupposition at narrow and wide scope.

**Change to 07:** "Read as a significance held de se along a relation, a standard's reach would be the condition exactly where every center's closure under that relation is the whole (`ownClosure_unrestricted_iff`), and would leave something out otherwise (`rival_of_outside`); the Lean states this of the significance, not of any standard."

### 4. The fronts' sentence has four faults

**Hits:** the §4 sentence.

- **It inverts the direction.** "Significance is supplied, where no satisfiable statement... fixes it" reads as a finding: we looked, nothing fixes it, so we supply it. In fact it is free by construction, so nothing can fix it (`not_entails` is one line). ONE-PAGE and the overview both say "by construction"; this sentence drops it. This is where a fair reader would feel evaded.
- **It states the wrong join.** "That any of it has significance" is a different claim from §3's "a standard which formed is thereby a significance". The first asks whether something matters. The second asks whether a standard is what mattering is.
- **"A relation no law picks" is too strong.**
  - 07 §4.3 says "The relation a self is drawn along is not free".
  - 07 §4.2 says a privileged relation is costly, not refuted.
  - The docstring says "not derived here", and §5 says "Not attempted here".
- **It omits order.** `sig` has no valence and ranks nothing, while what most readers mean by evaluation is better and worse. See also item 12.

**Change:**

> Under stated conditions, laws show where a new need comes from, how a rule's carriers gain share, and what a response within a requirement takes. They do not show that a standard which formed is what has significance, or that one course is better than another. Significance is either a free parameter, which by construction no statement reading only the represented dynamics can fix, or read as what lies within a center's closure along a relation no law here picks. Scope is the continuation condition and order is C, both premises.

### 5. The promise is withdrawn while the headline stays

**Hits:** "Neither half of the choice is right as put." and "The openings... keep their scope only with this sentence near them, or with *evaluation* narrowed to *standards*."

- **"Neither" is rhetoric.** The outcome is the reader's first half: the fronts say that much, and the work shows no more now (§5: "None of these is needed"). Refining a half is not rejecting it.
- **The fallback re-promises what the note denies.** "How life, knowing and standards form" asserts what §4 avoids ("says *shaped*, not *form*") and what §5's first bullet says was not found.
- **A caveat beside a headline does not repair it.** A fair reader would call this quiet withdrawal.
- **Other live text still says otherwise:**
  - 07 §1: "Positions, regions and standards form";
  - the overview: "Positions and standards form";
  - 07 Bases: "Evaluation enters through the ethics' two premises", under a section titled "How evaluation forms";
  - AGENTS.md's programme: show how evaluation differentiates.

**Change:** replace "Neither half..." with: "The first half, made precise: the fronts should say what is shown and what is not, and the work does not now show more."

Replace the openings sentence with: "The openings change, rather than carrying a caveat: 'of how life and knowing form within it, and how far evaluation is shown to' (the fronts' sentence follows)." Also change 07 §1's and the overview's "standards form".

### 6. There are not four standings, and "read" collapses into "supplied"

**Hits:** "The word *evaluation*... covers four things, and they have four standings."

- **The fourth is not part of evaluation.** It is a theorem about the third, as its own heading admits ("for the free parameter"). §4's sentence already folds it into a clause.
- **No criterion separates read from supplied.**
  - "A reading of `living`" is listed under Supplied, while the tied significance is a reading listed under Read.
  - 08 §7: "Each net's relation, class and center are supplied."
  - 07 §4.2: P2 holds "only because the relation is supplied".
  - The only real difference is that the tie has no free predicate.
- **"Exact" is false as stated.** "'The one evaluative parameter supplied', is exact and stays" sits above a Supplied list holding C, L, J1–J4 and the weights. 07 §4.4 calls C's content "supplied, not shown".
- **§5's third bullet has the same fault.** "Not available in this representation" holds only for the free `sig`, yet the tie is in this representation. "Such a change would be a new premise" then either makes the tie a premise, so Read is Supplied, or is false.

**Changes:**
- §1: "covers three things, and a limit on one of them".
- Read: "the one form of significance with no free predicate; its relation, its centers and the identification are still brought in".
- "Exact": "exact for the one free predicate in the statement of significance; the rest of what is evaluative and supplied is listed below".
- Bullet 3: "Not available for the free parameter. The tied reading is significance from the dynamics given a relation, centers and an identification; what no law gives is the identification."

### 7. "Standard" is undefined, and it hides readings inside "Shown" (question 4)

**Hits:** the §2 heading and the row labels "A standard gains influence", "A shared standard is reached", "What acts show of a standard".

**Checked:**
- The glossary has no row for standard, need, requirement or evaluation.
- Each of the seven records uses "standard" only in the "Standard boundaries" boilerplate. The count is 1 in the five I could confirm; I did not see the count lines for the last two.

**What it covers in the note:** a threshold, a selection rule of counts, a code, an order consistent with choices, and a weighted valuation. §5 concedes "standard-like", listing "a carried capacity to shape... a hearing", which are not standards in any sense.

**Consequences:**
- 07 §1's sense (a standard "recognizes its target" and "can be wrong") excludes a count rule, which has no target and cannot be wrong.
- That those laws concern standards at all is a reading, placed under "Shown" with no label. So the line between the first and second standings is not clean.
- "None found" cannot be tested, because "whose start has no standard" has no meaning yet.
- "Requirement" also has two senses: a threshold under Shown and an acceptable set under Supplied.

**Change:** define it in the glossary, not only the note, because the term is meant for the fronts. Suggested row:

> standard | what something is read against, so that it can be met or missed: a requirement on a level, an acceptable set of acts, a task. A selection rule, a code or an order read off choices is one only under a reading. Not a significance: that a standard is met says nothing of whether meeting it has significance. | 07 §1

Then add under §2's heading: "The laws are about rules, codes and orders; that these are standards is a reading [AI reading]."

### 8. The constitutive objection lands in part

**Hits:** "No law joins the first standing to the second."

**Where it fails:** "limit of the representation only" is right for the free `sig`, but it does not cover the tied standing. Nothing bars a law there saying a center carrying a rule has a given region.

**Where it lands, three ways:**
- **The join is an identification.** Any law stating it would take the identification as its reading. So the sentence reads as if a law were missing, when no law alone could supply one. The note should say this.
- **Significance has no time of being held.** In `sig : Pos → Nat → F → Prop`, the `Nat` is the step of the continuation being valued, and `ownClosure` discards it. So at the second standing nothing forms at all, in a note titled "How evaluation forms". Pairs as standpoints could encode a time of holding. A grep of three modules found no law doing that, so this is limited evidence. `feedingFrom` varies the valued step, which is a different thing.
- **The chapter's own bridges are absent.** The note never mentions P1 (acting presupposes significance), route (b) ("should" as what a center does), or the de se question. "Presupposition", "route (b)" and "step of invariance" occur zero times. A reader is told nothing joins while 07 §4 argues the nearest thing to a join.

*My reading:* relational constitution of value (Railton, Street, Korsgaard, Thompson, Di Paolo) is the serious rival. These names are from memory and unchecked.

**Change:** see the replacement for §3 at the end of this report.

### 9. The split does not state its basis, scope and omissions (question 2)

**Hits:** §1, and "Supplied", which names no supplier beside 07 §1's "none outside it owns value".

It is a fact/value split with no label. It smuggles something only if read as sorting kinds of thing, and "four things" invites that reading.

**Change (insert after §1):**

> The standings sort the account's statements, not what is in the unfolding. *Basis:* each is a relation between a statement and its model: proved of it, read onto it, taken as a hypothesis, or shown not to follow. *Supplied* means entering as a hypothesis, stated by writers and readers who are themselves formations; nothing comes from outside. *Scope:* what is represented. *Omits:* holding a standard from within. Coming to care, which 07 §1 reads as able both to recognize a prior reason and to create new ones; a time of holding; motivation and recognition. A split of statements cannot show that the things are two.

### 10. Rows overstate their records

- **"laws show how needs form" and "A need forms".** The record's Does not show: "Why a descendant comes to depend... the law says where a new dependence comes from". Its witness `novel_formed_undrawn` shows a dependence formed from nothing drawn.
- **"A requirement is fixed by the exchange, not by an evaluator".** The law is weakest among *local* sound readings, and the record says locality is "argued..., not proved". No evaluator appears in the Lean. Change it to: "necessary response is the weakest sound local reading of requirement; locality is argued".
- **"`GoalFormationRevision`, in the history".** A live copy exists at `lean/universal-ethics/generative-capacity/`, and the record points there.

### 11. §5 names real items but omits the most relevant ones (question 5)

Its bullets are right apart from the third (item 6). The second should cite 07 §4.2–4.5, not only "what requirement and need fix", including `Clearing.center_not_derived`. Missing:
- **The map itself:** which kinds of standard yield a `(rel, center)`, so that §3 becomes a statement.
- **A cheap witness:** carriers selected by return whose rule's reach is the whole. This would test item 2.
- **A time of holding,** without which "significance forms" cannot be stated directly.
- **Self-maintenance as the candidate for a standard from none:** a formation whose going on depends on its own activity, with its set level formed, not given. `ReaderRebuilding` supplies it today, and §5 names no candidate at all.
- **The non-formal route:** P1 and the de se question. §5 lists only what could be proved, though 07's thesis names these as open.

### 12. Name both premises; keep the distinctions (questions 6 and 7)

**Derivation:** no change needed. Nothing writes that the ethics derives from the condition, and §2 and the block name both premises in their roles.

**One defect:** "what would make one standard's reach better than another's" puts C's word *better* on scope. The condition ranks nothing, and C orders courses by widening, not standards by reach. So this asks a question neither premise answers, and it says nothing of C's own open warrant. "The premises' warrant" names neither premise. The replacement for §3 fixes this.

**The five distinctions:** the rows themselves are careful. "Exists" is implementation and "gains influence" is share. The one real collapse is item 1, where reach is put in place of warrant. The note is also silent on recognition, motivation and compliance, and does not say so. Item 9's omissions line covers motivation and recognition; add compliance there.

### Objections I tried that fail

- **§2's limit overclaims about becoming.** No change: it says "not that becoming leaves significance undetermined".
- **Any such sorting is dualist in itself.** No change once item 9 is added: AGENTS.md itself demands keeping premises, proofs and warrant distinct.
- **The cited declarations do not exist.** All the ones I checked exist. I checked `ReadsOnlyDynamics`, `rival_of_outside`, `ownClosure`, `selfAscribed`, `setLevel`, `keeps_continues_iff` and `«续无外随网»`, and the Boundaries docstring says what the note claims. I checked statements for those I read, and only existence for the last two.

### Replacement for §3

> **Reading** [AI reading, new]. No law joins the first standing to the second, and none could alone. A standard is a threshold, rule, code or order; a significance is a predicate on standpoints, steps and formations; calling one the other is an identification, which a law stating it would take as its reading. Three positions stay open. If a standard's reach is what significance is, the condition is true or false of a net (`ownClosure_unrestricted_iff`, `rival_of_outside`), false wherever something lies outside, and its warrant is no longer the open question. If it is not, a standard's reach counts neither for nor against the condition. If acting presupposes significance (07 §4.2, P1), the question is the de se one 07 §4.2 leaves open. No theorem here chooses among them. Whether standards that actually form are narrower than the condition is empirical; the selection laws bound which carriers spread, not what a standard is about.
>
> This leaves both premises' warrant open: the continuation condition for scope, C for order.

