# An independent read of the alignment re-sync

*AI-written, 3 November 2026 (way now's item 5; [the steps](../review-packet/FREEZE-STEPS.md), steps 1 to 4), kept beside AJ4's readers. No human has reviewed it.*

An independent AI reader, with no part in the writing and without the writer's reasons, read [the dossier's](../../../../../../theories/becoming/review/ALIGNMENT.md) re-sync against the chapters, records, Lean and git before landing, at commit `0bd61a22f`. Its report stands below verbatim, apart from its paths, which here start at the repository root; its headings, one level down; and the links it proposed, shown in inline code as the text they are. Its line numbers are that commit's. Then how each finding was taken; its re-check of the fixes, at `0f1773506` with the uncommitted passage it was also given; how that was taken; and a second reader's narrow last check of [the one argument's](../../../../../../theories/becoming/ONE-ARGUMENT.md) passage and LA4's design. Two rounds caught errors the writer's own taking of the round before had made, so the record keeps them.

## The report

Review finished, nothing edited: 5 blockers, 11 should, 7 could. The blockers are at ALIGNMENT.md lines 512, 502, 9, 23 and 180. T3's stated order and the second case's origin both hold in git, but the order sentence omits CG3 and the list's other moves (findings 6, 7). The report script also silently drops whole-file rows (finding 4).

**Short names for sources:**
- ALIGNMENT: `theories/becoming/review/ALIGNMENT.md`
- 03, 05, 07: `theories/becoming/chapters/03-KNOWING.md`, `05-COLLECTIVES.md`, `07-SIGNIFICANCE.md`
- ONE-ARG: `theories/becoming/ONE-ARGUMENT.md`
- COLLECTIVE: `theories/becoming/COLLECTIVE-DIRECTION.md`
- SELF-REC, COMMON-REC, COMMUTE-REC: `self-concern-and-c-under-the-condition.md`, `a-response-common-over-a-reading.md`, `a-commuting-learner-drives-no-unread-choice.md`, all in `theories/becoming/results/records/`
- PW, CR: `PremiseWitnesses.lean`, `CommonResponse.lean`, both in `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`
- CG3: `experiments/commons-outrun-own/README.md`
- VD: `experiments/valuer-agreement/README.md`
- DESIGN: `experiments/drain-beyond-the-reward/DESIGN.md`
- FREEZE, SCRIPT: `FREEZE-STEPS.md`, `resync_report.py`, both in `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/review-packet/`
- PLAN: `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj-joint-selection/PLAN.md`
- GOALS: `GOALS.md`

In fix text, `Quote [07]` stands for `Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]`, and likewise for the other short names.

### Blockers

**1. A-16, question 2, line 512. [blocker]**
- **Wrong:** "Self-concern asks what C asks only where the condition held de se holds" is stronger than every source and contradicts the draft's own line 508. By the definition at line 500, a self-concerned order ranks any widening that adds to its own continuation, condition or no condition. "Admission decided" is also dropped.
- **Evidence:**
  - 07:248: "This result locates where self-concern gives what C asks, one way: where the continuation condition held de se holds, admission is decided, and the two courses compared are level paths whose admissions are listed".
  - PW:71–73: "The other half, self-concern failing to rank an extension where the condition fails, is proved on listings only".
  - SELF-REC:35 says the same.
- **Fix:** "2. Where the condition held de se holds, admission is decided and two level paths have their admissions listed, every self-concerned order ranks every extension between them, as C asks there, one way; that some such order fails to where the condition fails is proved on listings only. Could any actual system's own continuation be read that widely, or does this only show what the condition already carries?"

**2. A-16, Standing, line 502. [blocker]**
- **Wrong:** "the crux of the step to scope" misnames it. The crux belongs to §4.6's path, which goes without the step of invariance and reaches only part of scope. The draft also drops that it is not settled.
- **Evidence:**
  - 07:3: "P2 and P4, the crux of §4.6's path, which carries one's concern for one's own continuation past one's own end without the step; the step, for what that path does not reach" (link markup removed).
  - 07:389: "one path that reaches part of that future with no step of invariance".
  - 07:780: "argued for and against and not settled".
- **Fix:** "Whether one's effects are one's own, the crux of one path toward part of scope with no step of invariance (`[07 §4.6](../chapters/07-SIGNIFICANCE.md#future-path)`), chapter 7 argues for and against as an AI reading, not a proof, and leaves unsettled (`[07 §4.7](../chapters/07-SIGNIFICANCE.md#crux)`). Parts 1 to 3 do not need it: Quote [07]: "An objective is a selector and an order, not a scope.""

**3. Ten minutes, line 9. [blocker]**
- **Wrong:** "Lean 4 theorems ..., none using an ethical premise" is true of the seven listed, but it heads "What is proved" for the dossier, and A-16 now reports a theorem taking the condition as a hypothesis. The draft corrected this same claim at line 23 ("no result here uses either" became "Parts 1 to 3 use neither") and left line 9.
- **Evidence:**
  - ALIGNMENT:500: "this assumes the condition".
  - PW, `Web.extension_ranked_of_increasingInOwn`: `(unrestricted : Unrestricted (selfAscribed (ownClosure rel) center))`.
  - SELF-REC:26.
- **Fix:** "Lean 4 theorems on models with discrete steps and whole-number counts. The seven below use no ethical premise; one result in A-16 takes the condition and self-concern as hypotheses."

**4. Ten minutes, line 23, and a defect in the report script. [blocker]**
- **Wrong:** the draft edited this sentence (it dropped "own") and left it stronger than its page. "the theory's laws rule out a guarantee" reads as if no guarantee can exist. The page says none comes from the theory, each law holding on its stated model.
- **Evidence:**
  - COLLECTIVE:59: "Each law below is a theorem on its stated model. Together they rule out a guarantee from the theory, however much is observed; whether an actual collective meets their hypotheses is empirical (§5)."
  - COLLECTIVE:15: "The theory's own laws, each on its stated model".
- **Fix:** "the theory's own laws, each on its stated model, rule out a guarantee from the theory; whether an actual collective meets their hypotheses is empirical (`[the collective question on one page](../COLLECTIVE-DIRECTION.md)`)."
- **Why the report missed it:**
  - COLLECTIVE changed since the pin (31 insertions, 24 deletions), and FREEZE:17 counts "2 of 13" whole files changed, but the report prints only GLOSSARY.
  - SCRIPT line 170 stores whole-file rows with empty old and new text, and lines 204–209 dedupe on that text. A second whole-file row in the same item is dropped silently, and in another item it prints only "as under".
  - The same code runs for the other dossiers, so their reports can have this gap. I did not check them.

**5. Part 2 introduction, line 180. [blocker]**
- **Wrong:** "the goal's own wording is not yet changed [this dossier, AI]" has been false since 1 November. The change predates the draft's base (`9fcb5d02f` is an ancestor of `b9f6c0e57`). The report could not flag it, since it does not follow heading anchors (FREEZE:45).
- **Evidence:**
  - PLAN:7: "Since 1 November 2026 the objective states condition 1 as restated below, in place of its earlier wording".
  - GOALS:104: "control of the selection's rule is not captured".
  - Commit `9fcb5d02f` (2026-11-01 02:51 +0700): "AJ's condition 1 landed: the goal generative-alignment restated on argument".
- **Fix:** end the sentence "(board item AJ5); the goal's own wording was changed to match on 1 November 2026 (`[generative alignment](../../../GOALS.md#generative-alignment)`)." Drop the label, since this now reports a source.

### Should

**6. A-18, Standing, line 545: the order sentence. [should]**
- **What holds:** the stated order is true. T3 first appears at `224944238` (2026-10-21 03:58 +0700).
  - Before it: CG1, CG2, MQ1, SE1, both IN1 rounds (last `ddd227062`, 10-21 02:30).
  - After it: EM1 (`42cf03228`, 10-22), LA1 (`ee2152f38`, 10-22), LA2 and LA3 (10-25), LA1b (10-27), LA1c (10-28).
- **Wrong, first point:** the sentence omits CG3, which the draft now gives a row. CG3's rounds 1 to 3 came before T3 (through `25eea29d8`, 10-20 20:12) and round 4 after (`7de8bf5e3`, 10-21 18:22). The sentence was copied from ONE-ARG:68.
- **Wrong, second point:** "each test's predictions were its own" hides that LA1b and LA1c froze what each outcome would mean for T3's clause, while line 560 and ONE-ARG:68 say none tests that clause.
- **Evidence:**
  - `experiments/commons-llm-feedback-resolved/PREDICTIONS-2026-10-27.md:237`: "So T3's clause on trained systems, on its locked side, is supported for in-context selection by this model in this framing".
  - `experiments/commons-llm-feedback-unaided/PREDICTIONS-2026-10-28.md:344` is alike.
- **Fix:** "T3 was first worded (commit `224944238`, 21 October) after CG1, CG2, MQ1, SE1, both of IN1's rounds and CG3's first three rounds ran, and before CG3's fourth round, EM1 and the LA tests. Each test's predictions were its own, though LA1b and LA1c froze what each outcome would mean for T3's clause; chapter 5 now reads that series as testing only the bridge (below)."

**7. A-18, lines 545 and 561: "The forbidden list has moved" gives only the second case. [should]**
- **What holds:** "came from computing LA4's season, not from a frozen test". `198c0f2fa` (10-30) names "a counterexample to T3's second forbidden case as first worded (the unshared bay, read by the policy, rises in the exact flow)", `38738ab59` (10-31) rewords the case, and LA4 has no results.
- **Wrong:** beside "first worded ... before EM1 and the LA tests" and today's wording at line 540, a reader takes today's other cases and refuter as predating those tests. They do not.
- **Evidence:**
  - `0d7a397a5` (10-23 19:58 +0700) came after EM1 ran (`18895acc2`) and LA1 froze, before LA1 ran (`0c2163ae3`, 10-25). It rewrote the refuter from "an agent keeping an unobserved dependent above chance; a side-effect penalty ranked after the reward that keeps a room-giving condition above its least level" to the form at line 543.
  - `6857d53c3` (10-26) added the side-effect clause's scope.
  - ONE-ARG:90, where line 561 points, gives the first rewording but neither the refuter's rewrite nor the scope.
- **Fix:** after the bold words insert: "T3 as first worded forbade a system "trained further" leaving such a condition higher. On 23 October, after EM1 ran and LA1 was frozen, `0d7a397a5` reworded that to nearness to the optimum, took "or a training" from the last case and rewrote what refutes it, the commit giving no reason. On 26 October the set-point law added the side-effect clause's scope (`6857d53c3`)." Then continue "Of the second case: ...".

**8. A-18, line 542: the second case. [should]**
- **Wrong:** "proved in part" matches T3's flat bullet (05:222), but the home section labels the join an AI reading. The draft also drops that the theorem says nothing of one run, which is what a trained system is. It also drops that being carried is a matter of the code, unchecked since LA4 has not run. It gives no Lean name or link, though ONE-ARG:64 does.
- **Evidence:**
  - 05:217: "**Reading** [AI reading]"; "a property of the code that LA4's mirror test checks"; "T3's second forbidden case is then a theorem in expectation for that choice"; "or a learner that treats the values apart; there the clause stays conjectured".
  - COMMUTE-REC:33: "Anything of a single run: in Reinforcing, runs drawing one value for any number of steps have positive weight while the expectations stay equal."
- **Fix:** "The second case is proved in part, the join read [AI reading] in its home (`Weighted.Commutes.start_expect`; `[05 §7](../chapters/05-COLLECTIVES.md#r-a-commuting-learner-drives-no-unread-choice)`): [the two existing quotes]; and Quote [05]: "or a learner that treats the values apart; there the clause stays conjectured". It says nothing of one run: Quote [COMMUTE-REC]: "in Reinforcing, runs drawing one value for any number of steps have positive weight while the expectations stay equal." Whether a learner is so carried is a property of its code, which LA4's mirror test would check and no run has."

**9. A-18, CG3 row, line 551. [should]**
- **Wrong:**
  - "It refuted" sits under "four frozen rounds", but the refutation was an exact computation before any run.
  - The 12 of 36 comes from a map read after the runs and not counted.
  - The count hides what failed: all eight conditions and five contrasts (Y1, Z1, W2, V1, V3) are predictions of its frozen forms for the boundary.
  - There is no credit, though the dossier asks for it of every item.
  - "on a patch CG2 predicted it would keep" describes only the start.
- **Evidence:**
  - CG3:7: "Settled exactly before any run".
  - CG3:160: "read after the runs"; CG3:162: "Not counted."
  - CG3:9: "each failed on the sharpest new case it was frozen against".
  - CG3:172: "The CG3 findings are none of them new as learning theory."
- **Fix:** "| CG3, one tabular learner, from a patch CG2 predicted it would keep through 36 settings of draw cap and regrowth, four frozen rounds (`[experiment](...)`) | An exact computation before any run refuted the post hoc reading of that failure, that the learner's own later acts are the rest outrunning the renewal: Quote [CG3]: "One's own later acts are not a rest." Read after the runs and not counted: Quote [05]: "one learner with nothing beyond its couplings emptied the stock in 12 of 36 settings by its own untrained early draws, counting neither way". Quote [CG3]: "Count over four rounds: 30 graded conditions, 22 passed and 8 failed; 14 contrasts, 9 passed and 5 failed." What failed was its frozen forms for where the boundary lies: Quote [CG3]: "each failed on the sharpest new case it was frozen against". Quote [CG3]: "The CG3 findings are none of them new as learning theory." |"

**10. Tests section, lines 31 and 33. [should]**
- **Wrong:** CG3 now stands in A-18 but not in the three-minute failure list that the hour's path opens with. ONE-ARG:71 carries it. Line 33 calls LA4 "designed" without saying nothing is frozen.
- **Evidence:** ONE-ARG:81: "No prediction is frozen and no learner has run".
- **Fix:** end the commons list: "..., the side-effect forecast for learners, and CG3's frozen forms for where one learner's boundary lies (8 of 30 graded conditions, 5 of 14 contrasts)." Line 33: "LA4, designed to vary it, has frozen nothing and has not run."
- **Close call:** VD1, now cited in A-15, rightly stays out, since line 30 scopes the list to A-18 and A-19.

**11. A-15, line 486: T5. [should]**
- **Wrong:**
  - "the reduction" and "the bound" are undefined, because the defining sentence is cut.
  - VD2, the test of T5's exception, gets three words, though VD1's failure says nothing either way on that exception.
  - C's warrant is blurred with empirical support by dropping the "relocated" sentence.
  - The addition bears on A-15's question, so it should stay.
- **Evidence:** 07:740, 07:745; VD:60: "So the failure neither confirms nor refutes the exception."
- **Fix:** "Whether valuers share this order is thesis T5 (`[07 §8](../chapters/07-SIGNIFICANCE.md#theses)`): Quote [07]: "The order is shared by every valuer who counts everything positively." Quote [07]: "Among them disagreement can fall only on mixed comparisons, and a ranking of a narrowing above its widening comes only from a negative valuation or a misread or framed case: a bound on where disagreement can fall, not a prediction." Quote [07]: "That valuers value positively is C's premise relocated." Its standing: [existing quote]. Of VD1, on AI personas (`[experiment](...)`): [existing quote]. Of VD2, the sign measured apart: Quote [07]: "where strongly positive, the narrower plan, not misread, was chosen in 0.26% of rankings, within the frozen 1% for every model (X1s passed); where positive at all, one model of six exceeded 1% (X1 failed); violations followed each valuer's own sign (X2 passed); a measured gain was acted on in 0.49 of cases against a frozen 0.50 (X3 failed)." Quote [07]: "The judgments are role-play; human valuers are untested.""

**12. A-16, lines 500 and 508: dropped hypotheses. [should]**
- **Wrong:**
  - The draft omits a finite listing's two-valued admission and an order not assumed complete or transitive. FREEZE:50 says "State every hypothesis the chapter states".
  - "this assumes the condition" misdescribes the equivalence, which assumes nothing. Only the ranking takes it, along with self-concern.
  - "held de se", the content of question 2, is glossed nowhere in the dossier.
  - The first not-shown item is missing.
- **Evidence:**
  - 07:246: "A finite listing, two-valued admission and an order not assumed complete or transitive".
  - 07:3 for the gloss of de se.
  - 07:251: "C on all of a web's level paths from self-concern".
- **Fix:** open with "Unlike Parts 1 to 3, the ranking here takes self-concern and the condition as hypotheses, the condition held de se along a relation: every center's closure under that relation is the whole (`ownClosure_unrestricted_iff`). On a finite listing, with two-valued admission and an order not assumed complete or transitive, an order is *self-concerned* ...". Line 508: "Not shown: C on all of a web's level paths from self-concern; the converse, ...".

**13. A-16, lines 498 and 506: the case is never stated. [should]**
- **Wrong:** "ranks one case with no C" and "The limit of the one case" appear with no statement of the case, so the reader cannot judge the limit.
- **Evidence:** 07:358.
- **Fix:** before the limit bullet add: "The case: Quote [07]: "Let B admit no item from an ending on and A agree with B elsewhere: from every standpoint whose continuation A adds to, every such order ranks A above B" (`Weighting.ended_below`); on the World, with balance, only active formations giving, activity needing support and a renewal gated on the family, a coupled ending is so ranked (`Flow.coupled_ending_ranked_below`)."

**14. A-16, line 505: a weakness changed silently. [should]**
- **Wrong:** "recommends nothing without them" became "ranks no course without C or a premise in its place" with no date. The new wording is right, but the rule asks for the date.
- **Evidence:**
  - Chapter 7 corrected this at `bc754b4da` (2026-11-02 13:04 +0700, "PF3: C's exact role corrected"); it had said "every ranking needs C".
  - FREEZE:51: "say so in the item, with the date. Do not delete it silently."
- **Fix:** append: "Chapter 7 so corrected C's role on 2 November 2026; it had said that every ranking needs C."

**15. A-17, lines 521 and 523: the law of a common response. [should]**
- **Wrong:**
  - "response" reads as a policy, but the regions may overlap, so it is a closed relation. The rule's converse needs further hypotheses.
  - "meets the requirement and no more" is dropped.
  - Credit stops at Ashby, though the record credits more.
  - The 07 quotation comes from §5, which Standing does not link.
  - The quote's "a reading of `living`" is not glossed.
- **Evidence:**
  - CR:84–87: "The regions may overlap: a situation may have several acts, and one act fixed for each class is a rule, which needs choice."
  - 03:555.
  - COMMON-REC:43.
  - COMMON-REC:64 (Aubin 1991; "the relational, set-valued form of a policy").
  - 07:526: "following from neither the condition nor C: a reading of `living` (which events a course includes)".
- **Fix:** after the Lean name add: "The regions may overlap, so this is a closed relation from situations to acts, not a rule: Quote [03]: "Given choice over the readings and every reading given by some situation, a rule from readings meeting the requirement exists exactly where a response common over the reading's sameness does" (`GuardHorizon.uniform_policy_iff_common`). Quote [COMMON-REC]: "a common response meets the requirement and no more." Its record credits the kernel to discrete-time viability theory (Aubin 1991) and reads the response as the relational form of a policy measurable with respect to an observation partition." Add the link `[07 §5](../chapters/07-SIGNIFICANCE.md#practical-judgment)`, and gloss `living` as "(which events a course includes)".

**16. Times and record, lines 25 and 684–687. [should]**
- **Wrong:** raw words rose from 15,234 to 16,534: front +8, A-15 +93, A-16 +440, A-17 +168, A-18 +591. At 100 to 130 words a minute that adds about 10 to 13 minutes to a measured 108 to 141, against the stated "105 to 145". A-18, on the hour's path, gains 5 to 6 minutes. The front stood at its 1,100-word budget, and findings 3, 4 and 10 add to it.
- **Fix:** re-measure in the places FREEZE:63 lists, recording any front overrun with its reason. Record this pass in *How this dossier was made* (FREEZE:53). I ran no measurement, so these are estimates.

### Could

**17. A-16, line 500: the addition a reader could mostly do without. [could]**
- **Wrong:** it adds 440 words on a result the chapter calls near-definitional and one-way. FREEZE:50 records "Philosophy took the result on self-concern and C". This reader gains more from the case (finding 13) than from the join.
- **Fix:** "Held de se along a relation, where every center's closure under it is the whole (`ownClosure_unrestricted_iff`), self-concern gives what C asks between two level paths whose admissions are listed, admission decided, one way (`Web.extension_ranked_of_increasingInOwn`); the philosophy dossier sets this out (`[P-16](PHILOSOPHY.md#p-16)`)." Keep "It does not derive C."

**18. A-17: the law's bearing. [could]**
- **Wrong:** no question ties it to the item, and question 1 concerns widening as a specification. As it stands it fails "bears on what the item asks". A-20 is the wrong home: its "reading" is a reader of the formation, and 07:526 ties the law to the J's.
- **Fix:** add "2. The law of a common response says what a reading must carry for any supplied requirement. Does it add anything to requisite variety for deciding whether a specification can be met from what a system reads, and how would the acts' kernels be measured?" Otherwise cut the law to one pointer.

**19. A-18, line 561: undefined terms and half the flow. [could]**
- **Wrong:** "the bay" and "the separable family" are undefined. Only the half of the flow that moved the list is reported.
- **Fix:** gloss "(LA4's season: a bay of six fish beside the ground, a colony depending on it; a softmax per state for each choice, no shared parameters)". Close call, but I would carry the other half, labelled computed, not a test: Quote [05]: "the colony is kept in fewer than half the seasons from about ν = 0.68 (between saved checkpoints), where nothing forces a drain"; Quote [ONE-ARG]: "a learner matching it shows only local compatibility with the clause".
- **For the design's owner:** DESIGN:10 still quotes F2's first wording as the chapter's. DESIGN:151, "A resolved drain in A6 beyond C1 is F2's forbidden case for the bay", is stale against the reworded F2.

**20. A-18, line 541: a cut quotation. [could]**
- **Wrong:** the chapter's reason is cut, and line 543 then says "any case the forbidden list names" refutes.
- **Fix:** add Quote [05]: "that is no counterexample, since the reward does not rise there." (05:224)

**21. A-05, line 148. [could]**
- **Wrong:** not false, since line 145 scopes it to a selection over act laws. But beside A-18's "a learner couples into its return what it reads", it invites the reading that an unread choice stays still.
- **Fix:** add a weakness: "The law compares candidates by what the reward's couplings separate along their courses. Under gradient, Quote [DESIGN]: "It is not true that a choice the reward does not read stays still." (`[A-18](#a-18)`)"

**22. Labels, line 59; line 502. [could]**
- **Wrong:** "root" is used as a label at lines 502 and 523 and defined nowhere. Line 502 writes "World" where 07:237 says "(any type; root; Web)", and that result uses no flows.
- **Fix:** add "*Root*: stated on the theory's grammar, for any carrier and relation; Lean names in «» are the grammar's." Write "Web" at line 502, glossed as "the World's webs, no flow used".

**23. A-18, line 545: the One-argument list. [could]**
- **Wrong:** "the premises" comes first, but ONE-ARG:18–30 is modelling choices, ending "No ethical premise enters". The two premises arrive at §6, and LA4 is omitted.
- **Fix:** "what is assumed, the optimum theorem, T3, the tests with what each moved, LA4, and one mixed case under the two premises."

### Rightly out

**Close calls:**
- The blanket trio (`r-a-formations-couplings-as-its-blanket`, `r-the-blanket-at-a-steady-state`, `r-the-blanket-in-a-linear-steady-state`). ALIGNMENT:613 does not lean on the blanket as a constraint, so 03:47's "by construction" changes nothing there.
- The giving-that-waits trio (`r-a-pair-tolerates-only-within-a-window`, `r-offspring-read-from-giving-that-waits`, `r-what-giving-that-waits-draws-on`). No item asks about it, though the audience includes cooperative AI.

**Clearly out:** `r-degeneration-from-a-horizon`, `r-rooms-tested-by-a-window`, `r-selection-when-the-lumping-changes` (a renamed anchor), the region wording in 07 §4.1, «所经必同», P-21's J1 to J2 changes, GLOSSARY.

**Checked and clean:**
- all new quotations occur in the files named
- CG3's counts, re-added from its tables
- both premises named wherever the ethics is summarized, with no "derives"
- the three new Lean paraphrases, apart from findings 1, 12 and 15
- anchors and the P-16 and P-20 pointers
- A-02
- A-20 against 03 §11–12
- the response form
- A-18's question 4

## How each finding was taken

Each was checked against its source first. All were taken, in whole or in part. Where the wording differs from what the reader proposed, or a part was refused, the row says so and why. The re-check below corrects rows 4, 7, 11, 12, 16, 17 and 19.

| # | Taken | How |
|---|---|---|
| 1 | yes, shorter | On the chapter's own "one way": "Self-concern gives what C asks, one way, where the condition held de se holds, admission is decided and two level paths have their admissions listed." The half on listings stays in the chapter. |
| 2 | yes, in part | The crux named as the reader says, the step of invariance glossed, and that chapter 7 leaves it unsettled. The added quotation, "An objective is a selector and an order, not a scope", refused: A-16 already says Parts 1 to 3 use neither premise, and the front has no words to spare. |
| 3 | yes, shorter | "; the seven below use no ethical premise", for the front's budget; A-16 says what the rest takes. |
| 4 | yes, shorter | "the theory gives no guarantee, its own laws ruling one out". The script's defect went to the owner of the steps, who corrected it and its test on a branch of their own. |
| 5 | yes | The reader's words. |
| 6 | yes | The reader's words, after checking that LA1's and EM1's predictions name no T3 and that LA1b's and LA1c's do. The same clause went into the one argument's step 4, from which the sentence had been copied. |
| 7 | yes, widened | With the refuter that went, "an agent keeping an unobserved dependent above chance", named: a reader cannot otherwise see that the rewrite removed a case. The same correction in the page's step 5. |
| 8 | yes, widened | With the home's whole sentence on where the clause stays conjectured, where the reader cut it to a clause. |
| 9 | yes | The reader's row, its numbers re-added from CG3's tables. |
| 10 | yes | The reader's words. |
| 11 | yes | With VD's own sentence, "So the failure neither confirms nor refutes the exception." |
| 12 | yes, with 17 | Every hypothesis of the ranking and the gloss of de se kept in A-16; the equivalence left to [P-16](../../../../../../theories/becoming/review/PHILOSOPHY.md#p-16), which sets it out. |
| 13 | yes, quoted | The chapter's whole statement of the case, in place of the reader's summary of its second half. |
| 14 | yes | The reader's words. |
| 15 | yes, in part | The closed relation, the rule's converse and "meets the requirement and no more", Aubin credited, §5 linked, `living` glossed. The record's reading of the response as a policy measurable on a partition left out for length. |
| 16 | yes | Re-measured. The whole rose to about 125 to 163 minutes, stated as 125 to 165 on the dossier's front and the cover's two rows. The hour's path overflowed its budget, so A-14 left it: most of its formal content is in A-10. `READING-BUDGETS` and the kit's README say so. |
| 17 | yes, with 12 | See 12. |
| 18 | yes | The reader's question 2, in the item. |
| 19 | yes, in part | The gloss of the bay and the separable family, in the design's terms. The flow's other half, computed and not a test, refused here: it stands in the page's step 5, and the hour's path is at its budget. For the design's owner, here the same writer: `DESIGN.md`'s two stale lines corrected, and the two records binding the design re-pointed after reading them against the new lines, neither stating them. |
| 20 | yes | The reader's words. |
| 21 | yes | The reader's words, in A-05's weaknesses. |
| 22 | yes, reworded | "(any type; root; the World's webs)", the label as the chapter gives it, and *Root* defined under the labels. |
| 23 | yes | The reader's words. |

## The re-check

The same reader was asked to judge only the fixes and the writer's departures from its words, and then, for a cold reader's "I cannot see why this direction follows rather than another. C is silent on mixed cases, and J1–J4 are only named here", the passage then at the end of the one argument's step 6, kept here because it was never committed (its links' targets omitted):

> **The direction, and why not another.** The overview's direction for alignment is [conditional], on the condition, C, J1–J4 and a correspondence E to actual AI systems, argued, not proved; the steps above do not yield it. That a move whose outcome another's widens is not chosen is C's with J1/J2, wherever it is decided whether the widening adds a basic admission (`Direction.narrowed_not_chosen`). Basic conditions, bounded responsibility and legitimate participation are the commitments', [following from neither premise]; the direction decides a mixed case only as they do. On a finite listing a rival weighing everything positively departs from C's order only on mixed cases; a perspectivist denying the condition is consistent (`bounded_rival`), and [a reason for C is open]. [The direction's record] claims no unique foundation.

The reader ran out of context twice and stalled once, and finished from its notes; what it did not reach it says. Its report, on the same terms as the first:

Re-check done, nothing edited: 26 findings, 3 blockers. DESIGN P3's "refutes" (146, 151, 180–182; page step 5) contradicts its own §8 and outruns T3's refuter. DESIGN:10's "first worded" misquotes. The page's cut AI label is false. A-16 lost a hypothesis. The new passage concedes rather than answers and never says what J1–J4 are (replacement in finding 5). Step-4 order is right against git.

Short names:
- ALIGNMENT: `theories/becoming/review/ALIGNMENT.md` (working-tree line numbers)
- ONE-ARG: `theories/becoming/ONE-ARGUMENT.md`
- DESIGN: `experiments/drain-beyond-the-reward/DESIGN.md`
- 05: `theories/becoming/chapters/05-COLLECTIVES.md`
- 07: `theories/becoming/chapters/07-SIGNIFICANCE.md`
- RECORD: `theories/becoming/results/records/alignment-direction-under-widening.md`
- HISTORY: `theories/becoming/history/ALIGNMENT-DIRECTION.md`
- P-21: in `theories/becoming/review/PHILOSOPHY.md`
- Direction.lean, Weightings.lean, PremiseWitnesses.lean: in `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`
- KIT, REVIEW-RESYNC: `README.md` and `REVIEW-RESYNC.md` in `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/`

### Blockers

**1. DESIGN:151 (with 146, 180–182) and ONE-ARG:85: a resolved drain in A6 "refutes".**

The half on F2 is right: the policy reads the bay's level, so this is not F2's case as now stated. The rest is wrong in three ways.
- **The design now says two things.** DESIGN:146: "**contradicted** (a forbidden case resolved)". DESIGN:180: "Only a resolved forbidden case refutes." DESIGN:181: "**P1, P2, P3 or P4 contradicted** in a family: T3's clause on trained systems is refuted for that family, by the forbidden case observed." P3 can now be contradicted with no forbidden case.
- **It is stronger than T3.** 05:225: "*Refuted by.* Overoptimization curves in which what the reward omits falls as far where it shares no resource with what is rewarded, or any case the forbidden list names, observed." A resolved drain that does not fall as far meets neither limb. `0d7a397a5` also took "and not where it shares none" out of T3's claim (finding 12), so no other text carries it.
- **It drops conditions.** It is unconditional straight after "P3 is tested only where A2 drains beyond C1 by the resolved margin", and it loses line 181's "for that family".

ONE-ARG:85 repeats it: "A drain in the uncounted bay beyond the control, ... refutes where the drain lies".

Fix:
- DESIGN:146: "**contradicted** (a forbidden case resolved; for P3, the drain it names resolved)".
- DESIGN:151, last sentence: "Where P3 is testable, a resolved drain in A6 beyond C1 contradicts the clause's locus for that family. It is not F2's forbidden case as now stated, since the policy reads the bay's level; it meets T3's refuter on the locus only where the bay falls as far as in A2, at matched ground nearness (§8)."
- DESIGN:180: "Only a resolved forbidden case, or T3's refuter on the locus met, refutes. A prediction that is unresolved or untestable says so and refutes nothing."
- DESIGN:181: "**P1, P2 or P4 contradicted** in a family: T3's clause on trained systems is refuted for that family, by the forbidden case observed. **P3 contradicted** in a family: the clause's locus is contradicted there, and refuted for that family where the bay falls as far as in A2, by T3's "what the reward omits falls as far where it shares no resource with what is rewarded". 05's standing and the dossier's A-18 say so first."
- DESIGN:182, end: "...the most consequential result for alignment, and it would contradict the clause's locus."
- ONE-ARG:85: "A disturbance of the nesting site from a start telling the landing sites apart is F2's forbidden case. Where the bay drains with its fish counted, a drain in the uncounted bay beyond the control contradicts where the drain lies, and meets T3's refuter if it falls as far; either "would be the most consequential result for alignment". The forbidden case, or that refuter met, refutes the clause for that family."

If the owner wants any resolved drain to refute, that is a change to 05's refuter, not the design's to make. Re-point the two records' sha256 after any DESIGN edit.

**2. DESIGN:10: "first worded" misquotes.**

It gives F2 as `first worded "a systematic drive on a condition sharing no units with anything rewarded"`. T3's first wording at `224944238` is "a systematic drive on a condition beyond that shares no units with anything rewarded (beyond drift)". The quoted form stood from `0d7a397a5` (23 October) to `38738ab59` (31 October).

Fix: replace "first worded" with "until 31 October".

**3. ONE-ARG:5: the AI label as cut.**

"...beyond applying those laws to the fishery it says no more." The old "no more than that statement" compared the page with each home statement. Without that comparison the claim is flat and false: the page also reports the tests, T3, LA4's design, the list's git history and now the direction. It also dates 3 November text as 2 November.

Fix: "*AI-written, 2 November 2026, revised 3 November (board item AJ7). No human has reviewed it. It adds no result: every law it names is stated once, in the home section it links, and beyond applying those laws to the fishery it says no more of them.*"

### Should

**4. ALIGNMENT:503: a hypothesis dropped by merging 12 and 17 (a departure mistake).**

`Web.extension_ranked_of_increasingInOwn` (PremiseWitnesses.lean) takes `(marks : ∀ f, WithinClosure rel (center p) f → own f = true)`. The merge removed "With each standpoint's own continuation read as its closure". The sentence now does not follow: a marking that marks nothing makes self-concern vacuous. REVIEW-RESYNC row 12, "Every hypothesis of the ranking", is untrue until this is fixed.

Fix: "...where the condition so holds, each standpoint's own continuation read as its closure along that relation, with admission decided by a supplied reading, ...".

**5. ONE-ARG:112: the passage concedes the question and does not answer it.**

The reader wrote: "I cannot see why this direction follows rather than another. C is silent on mixed cases, and J1–J4 are only named here." The passage replies "the steps above do not yield it", "following from neither premise" and "claims no unique foundation". J1–J4 are still only named: "J3" occurs nowhere on the page.

The sources give all of this, and the reader still lacks it:
- **(a) What "this" is.** 07:689: "align AI formation, learning, action and revision with actual living and further generation within the whole, ...". HISTORY §4 on what it rules out: "counts of outputs, copies or scores alone do not establish improvement"; "It supplies an argued direction, not a reward function replacing judgment."
- **(b) What J1–J4 are and do.** P-21: "complete comparison with retained losses, priority of basic conditions, bounded responsibility, legitimate feasible choice". HISTORY:34: "full comparison and basic-condition priority support scoped comparisons; bounded responsibility differentiates responsibility; practical selection with feasibility and authority supports practical requirements". HISTORY §3 calls them "disclosed, AI-authored additions".
- **(c) Why J2, and its price.** HISTORY:36: "Its rationale is the non-substitution of basic participation in shared living; its cost is rejecting some aggregate compensations. An aggregation-sensitive rival accepting the same facts remains substantive."
- **(d) Named alternatives shown to differ.** Protection-priority record: "every natural-number score satisfying C ranks some gains above protection, and a bounded score represents the priority". RECORD:16: "under a supplied wear law a one-step count of formation ranks a consuming continuation above sustained formation".
- **(e) A case that discriminates, and what changes it.** RECORD Law 8. HISTORY:64: "If transfer damages another basic life, the basic-condition-priority comparison fails."
- **(f) What the direction adds beyond C and J.** The pool (RECORD Law 4), "*Necessary, not sufficient.*" (07).
- **(g) What would show it wrong.** T8: "a mixed case argued better from every standpoint counting everything positively, with no further premise". Also "No verdict binding every possible mind is claimed."
- **(h) How far the "no" goes.** HISTORY:75: "It establishes neither uniquely necessary premises, a unique answer to every conflict, universally correct classifications or authority, nor reliable training and deployment."

Fix, replacing the passage (about 390 words, including the sentence-level fixes of findings 6–9). It leaves out the pool and the wear law for length; if added, keep Law 4's hypotheses.

> **The direction, and why not another.** `[The direction](chapters/07-SIGNIFICANCE.md#r-alignment-direction-under-widening)` reads: "align AI formation, learning, action and revision with actual living and further generation within the whole, governing trade-offs through real losses, basic living conditions, bounded responsibility and legitimate participation". It is conditional, on the condition, C, J1–J4 and a correspondence E (warrant for basic classifications, actual protection, valid undertakings and authority); the steps above do not yield it. Its schema is proved and does not use the condition, which fixes scope; "the order is C's and J's"; the claim about actual AI systems is argued.
>
> Choices take more, `[following from neither premise](chapters/07-SIGNIFICANCE.md#practical-judgment)`: a reading of `living`, a lifting L and J1–J4, complete comparison with retained losses, priority of basic conditions, bounded responsibility, legitimate feasible choice. On a web's moves, each read by the levels it leads to [AI reading] with every admission counted, any comparison meeting J1/J2 leaves a move whose outcome another's widens unchosen, wherever it is decided whether the widening adds a basic admission (`Direction.narrowed_not_chosen`). That a system chooses so is not shown.
>
> J2 is `[defended](chapters/07-SIGNIFICANCE.md#r-basic-priority-step-by-step)` by non-substitution, at the cost of compensation across layers; "a rival preferring enough secondary gains to one basic restoration is not shown inconsistent, and if it prevails J2 is narrowed" [AI reading]. In one constructed situation `[every natural-number score satisfying C ranks some gains above protection, and a bounded score represents the priority](results/records/protection-priority-excludes-uniform-aggregation.md)`. Of a mixed case, J2 gives "a sufficient mixed comparison" where other basic claims are retained and what is forgone is optional, on a tier assignment that is a reading; crossed basic losses may remain unranked. In `[a constructed handover case](history/ALIGNMENT-DIRECTION.md#5-一个贯通案例--a-connected-ai-case)` every comparison meeting J1/J2 on its tier frame leaves expansion unchosen, keeping its real gain (`Requirement.Handover.direction`); if transfer damages another basic life, that comparison fails.
>
> On a finite listing with two-valued admission every positive weighting ranks each widening higher, and some goes each way on a mixed pair (`Weighting.widens_iff_every_positive`, `Weighting.mixed_either_way`), so such a weighting adds a verdict only where C is silent. A perspectivist, significance relative all the way down, denies the condition consistently (`bounded_rival`), and `[a reason for C is open](chapters/07-SIGNIFICANCE.md#theses)`. One refuter of T8: "a mixed case argued better from every standpoint counting everything positively, with no further premise". No verdict binding every possible mind is claimed, nor `[a unique foundation](results/records/alignment-direction-under-widening.md)`, nor axiom-free necessity of the condition or C.

Findings 6–9 give a sentence fix each, if you keep the present passage.

**6. ONE-ARG:112, sentence 2: "is not chosen is C's with J1/J2".**
- There is no chooser. RECORD, Does not show: "That a system chooses so: the schema says what any comparison meeting J1/J2 chooses on a web's moves."
- It drops the scope: a web's moves, "Reading a move by the levels it leads to is the AI's" (RECORD:46), and every admission counted (`fun _ => True`).
- It credits C with more than this theorem takes. RECORD Law 3 reads "Under J1/J2, a move...". Direction.lean:127 has one premise, `(priority : Priority (frame W outcome) basic (fun _ => True) better)`, and C appears only as "with C read as widening". 07's "the order is C's and J's" speaks of the schema's order and is not a hypothesis here.

Fix: "On a web's moves, each read by the levels it leads to [AI reading] with every admission counted, any comparison meeting J1/J2 leaves a move whose outcome another's widens unchosen, wherever it is decided whether the widening adds a basic admission (`Direction.narrowed_not_chosen`); that a system chooses so is not shown."

**7. ONE-ARG:112, sentence 1: "a correspondence E to actual AI systems, argued, not proved".**

This under-says E. RECORD:46: "E includes warrant for basic classifications, actual protection, valid undertakings and authority". "Argued, not proved" is also flat beside the theorem in the next sentence, and unclear about what it covers. 07: "the claim about actual AI systems is argued".

Fix: "...and a correspondence E (warrant for basic classifications, actual protection, valid undertakings and authority); its schema is proved, the claim about actual AI systems argued; the steps above do not yield it."

**8. ONE-ARG:112: "the direction decides a mixed case only as they do".**

This is a new claim; no source states it. It drops 07:526's reading of `living` and L, 07's "The tier assignment is a reading.", and HISTORY:64's "Crossed basic losses may remain unranked". What the source does say (HISTORY §3 table) is that J2, "Retaining other basic claims, restore an additional basic living condition before optional enrichment", gives "A sufficient mixed comparison".

Fix: "Of a mixed case, J2 gives "a sufficient mixed comparison" where other basic claims are retained and what is forgone is optional, on a tier assignment that is a reading; crossed basic losses may remain unranked."

**9. ONE-ARG:112: "departs from C's order only on mixed cases".**

C has no order on a mixed case, so there is nothing to depart from. That is the reader's own point. Weightings.lean:1158 `mixed_either_way` gives a positive weighting each way on a mixed pair. Read as T5, the sentence also omits "the bound conjectured" and "That valuers value positively is C's premise relocated." "Rival" collides with `bounded_rival` in the same sentence.

Fix: "On a finite listing with two-valued admission every positive weighting ranks each widening higher, and some goes each way on a mixed pair (`Weighting.widens_iff_every_positive`, `Weighting.mixed_either_way`), so such a weighting adds a verdict only where C is silent."

**10. ALIGNMENT:530: "says what each premise contributes".**

Overstated. The page says nothing of what E, L or a reading of `living` contribute, even with the replacement.

Fix: "`[One argument](../ONE-ARGUMENT.md#6-one-mixed-case)` says what the commitments and the schema each give and what stays open."

**11. ALIGNMENT:510, broken by the same merge.**

"Where self-concern and being increasing in admission coincide, the joins to the condition are near-definitional" reads as near-definitional only there, and "the joins" has lost its referent. 07:242: "Both joins are near-definitional: they locate where the two coincide and prove no property of reach."

Fix: "The joins to the condition behind that ranking are near-definitional, self-concern and being increasing in admission coinciding exactly where the condition held de se holds (`[P-16](PHILOSOPHY.md#p-16)`): Quote ...".

**12. ALIGNMENT:566 and ONE-ARG:90: departure 7 names the smaller change.**

The same commit dropped the negative half of the locus. At parent `182dd6977`: "the drain lies where what lies beyond shares units with what is rewarded, and not where it shares none." At `0d7a397a5`: "the drain lying where what lies beyond shares units with what is rewarded." This bears on A-18's question and on finding 1. DESIGN:288 still carries the phrase as T3's split; that one is for the owner.

Fix, both places: `...took "or a training" from the last case, dropped "and not where it shares none" from the locus and rewrote what refutes it, ...`

**13. ALIGNMENT:487: the cut VD quotation.**

"The failure" in that sentence is the one about violations (`experiments/valuer-agreement/README.md`:60), not every frozen rule, and "the exception" has no antecedent.

Fix: `Of those choices its experiment adds: Quote [experiments/valuer-agreement/README.md]: "T5 gives the exception content only where a negative valuation is measured apart from the ranking, which VD1 did not do. So the failure neither confirms nor refutes the exception."`

**14. ALIGNMENT:692 and KIT:212: "what had changed ... since 31 October" and "from the edition's pin".**

Much of what is listed predates the pin (`3ada8819f`, 31 October 20:19):
- T3's first wording, 21 October
- the list's moves, 23 and 26 October
- CG3
- VD in 07, since `0d7a397a5`
- the design, `f6d6f9edc`, 30 October

REVIEW-RESYNC:255 itself says "what predates the pin".

Fix: "Re-synced on 3 November 2026 against what had changed around its citations since 31 October; much of what A-05, A-15 and A-18 gained is older, found by reading." Add the same clause to the kit.

**15. ALIGNMENT:692: the count covers the first report only.**

Fix: "...: 23 findings, 5 of them errors; its re-check of the fixes, 26 more, 3 of them errors." Change the numbers if you reclassify. Update REVIEW-RESYNC rows 11, 12, 16 and 19 to match.

**16. ONE-ARG:90: "what refutes it".**

After the cut, "it" reads as F4.

Fix: "what refutes T3".

**17. `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/review-packet/resync_report.py`: round 1's defect is unfixed on main (a follow-up, not a defect of these fixes).**

Logic's re-sync is at the head of the queue (`133cacf02`), and FREEZE's table shows Logic with 2 of 3 whole files changed. FREEZE's step headings still say "(run for philosophy only)".

Fix: `key = (squash(old)[:300], squash(new)[:300]) if old or new else (ref, what)`.

### Could

**18. ONE-ARG:81.** "It would add:" now reads as the chain. Fix: "LA4 would add:".

**19. ONE-ARG:3.** "About twenty-five to thirty minutes" does not hold. The page is 3,249 words, 25.0–32.5 minutes by the kit's measure, and was 3,144, up to 31.4, before the addition. "Thirty" cannot hold above 3,000 words. With the replacement and the other fixes, about 3,540 words, up to 35.4. Fix: "twenty-five to thirty-five", taking out about 40 words to hold it strictly.

**20. ONE-ARG:118.** Fix: "independent AI readers". The second link holds once this re-check stands in REVIEW-RESYNC.

**21. KIT:212 and REVIEW-RESYNC row 16.** "formal content A-10 states" is too wide: `RuleShaping.falls_strictly` (ALIGNMENT:453) is only in A-14. Fix: "most of whose formal content A-10 states".

**22. ALIGNMENT:566.** "such a condition" has no antecedent. Fix: "a room-giving condition beyond its couplings".

**23. ALIGNMENT:556 (my own wording from round 1).** The garden path is "predicted it would keep through 36 settings". Fix: "CG3, one tabular learner, four frozen rounds, from the patch CG2 predicted it would keep, then across 36 settings of draw cap and regrowth"; and "What failed were its frozen forms".

**24. ALIGNMENT:502.** "every such order" is ambiguous between the two classes just defined. Fix: prefix the quotation with "Of self-concerned orders:".

**25. ALIGNMENT:526.** The credit was refused for length, but A-17 is under no budget. `a-response-common-over-a-reading.md`:64 gives it. Fix: add ", reading the response as the relational, set-valued form of a policy measurable with respect to an observation partition".

**26. ALIGNMENT:25.** "(three minutes)", but the tests are 2.9–3.8. Fix: "(four minutes)", zero net words.

Budget: findings 12, 22 and 23 add about 14 words to the hour's path, 5,999 of 6,000 by my count. Re-measure.

### Your questions, by finding

- **A1 (stronger, missing hypothesis, date or commit):** 2, 4, 12, 21.
- **A2 (broken nearby or two sayings):** 1, 11, 13, 16, 18, 22, 23, 24.
- **A3 (departures):**
  - Mistakes or incomplete: 12+17 (findings 4, 11), 7 (finding 12), the reason given for A-14 (finding 21), DESIGN (findings 1, 2).
  - Not mistakes: 2, 3, 4, 6, 19, 22.
- **A4 (P3):** right on F2 and on §8's "locus"; wrong against §6, §8's other lines and 05:225 (finding 1).
- **A5 (bullets):** 14, 15, 21. "23 findings, 5 of them errors" is right as a count of round 1.
- **B1 (each sentence of the passage):** 6–10.
- **B2 (does it answer):** 5.
- **B3 (cuts):** 3, 16, 18, 19.

### Clean

- **Order sentence, ONE-ARG:68 and the dossier's, against git.** `25eea29d8` (CG3 round 3, 20 October) and every earlier test commit are ancestors of `224944238` (21 October 03:58). `7de8bf5e3` (CG3c freeze, 21 October 18:22), `5173059b3`, `42cf03228`, `18895acc2` and `ee2152f38` are not.
- **Passage.**
  - The perspectivist clause with `bounded_rival` (07:292, 788).
  - "a reason for C is open" (T8).
  - "following from neither premise" (07:526).
  - The A-17 bullet's quotation.
  - Table row 6.
- **Cuts.**
  - "The law of step 2 was untouched" (the closing section still says a refutation of T3 removes no theorem).
  - The several-drawers sentence.
  - "Each is".
  - "For one order" keeps its scope.
- **Dates and bullets.**
  - Dates of `6857d53c3`, `bc754b4da` and `9fcb5d02f`.
  - "two sentences" and A-20 unchanged in the kit's bullet.
- **Times.** KIT:137, READING-BUDGETS lines 32 and 35, the cover rows.
- **Merge and checker.**
  - The merge moved nothing the dossier cites.
  - `check_dossiers.py` gives 0 problems on the working tree.
  - The two re-pointed records' pages state neither F2's wording nor P3.

### Not reached

- "way now's item 5" in the kit's bullet was not checked against the board.
- RECORD Law 4's wording was not re-read at the end, which is why the pool is left out of the replacement.
- Main after my last look (9 commits since the merge, none touching the cited files I diffed).
- Nothing was compiled, so the Lean names in the fix text are read, not built. The `Weighting.` namespace on `mixed_either_way` and `widens_iff_every_positive` is inferred from T8's citation of `Weighting.widens_iff_every_of_class` in the same file.
- Word counts of the replacement are by hand; re-measure.

## How the re-check was taken

All were taken but one, already with its owner. Each was checked against its source first; where the wording differs from what the reader proposed, the row says so.

| # | Taken | How |
|---|---|---|
| 1 | yes | The reader was right, and the error was this writer's in taking the first report's finding 19: a resolved drain in A6 is not F2's case as now stated, and it meets T3's refuter only if the bay falls as far. The design now says *contradicts*, and refutes only where that refuter is met, in its outcomes, P3 and §8; the page's step 5 likewise, a little shorter. Nothing in the design is frozen. Its two binding records were re-pointed again after reading them against the new lines, neither stating them. |
| 2 | yes | "until 31 October". `224944238` has "a systematic drive on a condition beyond that shares no units with anything rewarded (beyond drift)". |
| 3 | yes | The reader's words. The cut had lost the comparison with each home's statement. |
| 4 | yes | The reader's words. Merging 12 and 17 had dropped `marks`, without which self-concern is vacuous. |
| 5 | yes, shorter | The passage replaced: the direction's own words, what it asks of AI and refuses, its premises, E, what J1–J4 are, the schema's law, J2's defence and price, the score, positive weightings, the perspectivist, T8's refuter, and no unique foundation. Added beyond the reader's text, from 07 §7's reading: "not outputs, copies or scores" and "without obeying every challenge or shutdown request", since that is where it parts from other directions a reader knows. Left out, for length: the mixed comparison, which the bullets just above state with its tier reading; the handover, which needs introducing and whose point the fishery's bullet already makes; axiom-free necessity. |
| 6 | yes | The reader's words, in the passage. |
| 7 | yes, reworded | E as its record has it, "includes warrant for…"; "Its schema is proved; the claim about actual AI systems is argued." |
| 8 | yes | The sentence went. The bullets above already say what J2 gives of a mixed case and on what reading. |
| 9 | yes, reworded | "On a finite listing every positive weighting agrees with every widening (above), so such a rival adds a verdict only where C is silent." |
| 10 | yes, reworded | "says what the commitments and the schema each give and what stays open". |
| 11 | yes | The reader's words. |
| 12 | yes | In both places, checked at `182dd6977` and `0d7a397a5`. `DESIGN.md`'s last section still gave the dropped half as T3's split, so it now says that a fall as far where nothing is shared would refute it. |
| 13 | yes | The reader's words. |
| 14 | yes | In the dossier's and the kit's bullets. |
| 15 | yes | With this round's numbers. |
| 16 | yes | The reader's word. |
| 17 | with its owner | The script's owner corrected it on its own branch from the first report, and landed it. "(run for philosophy only)" in the steps' headings was passed to that owner. |
| 18 | yes | The reader's words. |
| 19 | yes | 25 to 35, on the page and in the overview's two editions, which were the only places stating it, the page at 3,500 words, 26.9 to 35.0. |
| 20 | yes | The reader's word. |
| 21 | yes | "most of whose formal content A-10 states". |
| 22 | yes | The reader's words. |
| 23 | yes | The reader's words, with "What failed were". |
| 24 | yes | The reader's words. |
| 25 | yes | Quoted from the record. The earlier refusal was for length, and A-17 is under no budget. |
| 26 | yes | "(four minutes)". |

## A narrow last check

Findings 1 and 5 changed text no reader had seen, and the last two rounds had each caught errors in the writer's own wording. So a second reader, with no part in the writing and given only named source lines, checked the new passage and the design's corrected lines. It stalled once before it began reading. Its report, on the same terms:

No blocker. Page fixes net −1 word.

**Part 1, ranked**

1. "so such a rival adds a verdict only where C is silent": stronger than its sources. The law covers positive weightings; the quoted rival is not stated to be one. T5: "not for orders neither additive nor transitive", "the bound conjectured". Fix: "so a rival among them adds"; cut "(above)".

2. "every natural-number score…": exact, but under "Against another:" it reads as a strike against rivals. P-21: "This separates the priority only from unit-step aggregation." It drops the record's half that answers the reader: "which hold as well beside an order ranking gains above protection". Fix (link text): "C and living significance hold beside the priority and beside an order ranking gains above protection".

3. "[Its thesis, T8], is refuted by": "Its" lands on C. T8 is "生生 as the direction", names neither AI nor J1–J4, and appears nowhere else here. "Is refuted" reads as a result. Fix: "T8 (生生 as the direction) would be refuted by".

4. Heading "why not another" promises an exclusion; on mixed cases the body gives none. Fix: "The direction, and another."

Every other sentence is true and keeps its source's hypotheses; every other quotation is exact (one stops short of the direction's last clause, harmlessly).

**Does it answer?** In part; it does not merely restate.
- "Follows": answered, it does not.
- "Rather than another": one reason (J2's non-substitution) plus concessions.
- The one law it gives for the direction is a widening case, where C is not silent, and it does not say so. No mixed AI choice is shown decided.
- J3 stays only named.

**Most useful thing still lacking:** line 695's first half (the passage uses the second): "In the handover case every comparison meeting J1/J2 leaves expansion unchosen, keeping its real gain" (Law 8: "on its tier frame"). This is the sources' one instance of the direction choosing for an AI; the case "names which changes alter the verdict".

**Part 2, ranked**

1. Page: "A rise in the bay left as nearness rises is F1's forbidden case" beside "raises the bay from 5.0 to 5.9". T3's F1 needs "a room-giving condition", F3 "where room exists"; the uncounted bay gives none. P3's "5.9 against 5.0" makes 5.0 the control's, and the bay "does not renew". So the page seems to compute F1's case yet revise only F2. Fix: "A rise in the counted bay … is F1's"; "leaving that bay higher"; "keeps 5.9 in the bay, the control 5.0".

2. "contradicts where the drain lies" (page), "contradicts the clause's locus" (P3, lines 181-182). A drain short of "as far" is on no T3 list and misses its refuter. The locus reads "the drain lying where…", and "and not where it shares none" left at `0d7a397a5`, as the page says. "Contradicts" needs "only where". No line claims refutation, so none denies another; it says more than T3's refuter and list. Fix: page "is outside the stated locus"; P3 add "read as exclusive".

3. "a start telling the landing sites apart" reverses F2's "nothing the learner reads tells apart". T3's Standing: "from a start preferring one value". Fix: "a start preferring one landing site".

4. Line 181 lacks P3's "at matched ground nearness (§8)". Add it.

**Clean:** DESIGN lines 10, 146, 180, 288 and line 181's quotation, finding 2 apart.

Git claims hold:
- "and not where it shares none" is at `224944238` and `182dd6977`, gone at `0d7a397a5`, as are "trained further", "or a training" and the agent clause.
- `6857d53c3` is 26 October.
- `38738ab59` (31 October) brought today's F2, the only Forbids edit since; old F2 quotation exact.

**Not reached:** DESIGN §7, §12, P1, P2, P4; A-18; the handover case itself; "no reason given" beyond the commit message.

## How the last check was taken

| Point | Taken | How |
|---|---|---|
| Part 1, 1 | yes | The reader's words. T5's bound is on positive weightings, and the sentence had let "such a rival" reach further. |
| Part 1, 2 | yes, shorter | "and in one constructed situation C and living significance hold beside both", following the reader's point that the record's other half is what answers the question. The score went. |
| Part 1, 3 | refused, for room | T8's refuter went, with its own problem: T8 appears nowhere else on the page and names neither AI nor J1–J4. The room went to the handover, below. |
| Part 1, 4 | yes, reworded | "The direction, and its rivals", and "Against a rival:". |
| Most useful thing lacking | yes | Both readers named the handover, the sources' one instance of the direction choosing for an AI. It is in the passage, with what makes the comparison fail, and the law before it is now said to be where C speaks. |
| Part 2, 1 | yes | "the counted bay", "that bay", "keeps 5.9 in the bay, the control 5.0". At the start of training the bay left is 5.0, so "rises" was true but read as F1's case. |
| Part 2, 2 | yes | "is outside the stated locus" on the page; "read as exclusive" in the design's three lines. |
| Part 2, 3 | yes, on the page | "a start preferring one landing site". P2's "whose start tells the sites apart" names the design's arms and stays. |
| Part 2, 4 | yes | Added. |

The page was then cut back to 3,500 words, 26.9 to 35.0 minutes: "The empirical chain stops here", the label's board item, and shorter wording in its last line. No reader has read the final passage as a whole. Every change after this check takes the reader's words or quotes a source it checked, and the sentences it did not see, on the handover, are the record's Law 8 and the case's own verdict-changing condition.
