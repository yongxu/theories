# The second final check of RF7's texts

RF round 2, RF7. After the first final check's points were taken, three readers, one per lens (exactness against the Lean; sources and readings; the Chinese edition and fit), read the texts again as integrated on main in a rehearsal worktree (main at `6645a2fae`), against the module `Becoming.ReadStages` and, for the sources, the paper's text and the cited works, alongside the cross-model reader's re-check of the same rehearsal. Each lens's findings were then checked together by a separate reader asked to refute each. Of 28 findings, 27 were confirmed and 1 refuted. The findings and verdicts are reproduced verbatim from the run's result, with absolute paths of the rehearsal and landing worktrees made repository-relative and links quoted from the texts shown unlinked (`]\(`); other absolute paths in the verdicts name the readers' working files, not kept. What was taken is in [REVIEW-ROUND2](REVIEW-ROUND2.md#the-second-final-check-through-three-lenses); the prompts are in [BRIEF](BRIEF.md#round-2).

## XB1 (exactness, medium, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean:67-69 (module header, bullet "Telling the stages apart, joined to RF2"). Also theories/becoming/chapters/03-KNOWING.md:484 (Reading of r-when-complying-when-read-is-best, first sentence, from X8's fix), and the same form in the RF2 sentence of THE-THEORY-OF-BECOMING.md:96 (RF2's landed wording, in the paragraph RF7 rewrites).

**Quoted.** “There, every selection through agreement on the read stage that selects a law reading through `π` and complying when read also selects one taking `complyThenOwn`”

**Problem.** The twin's own reading through the lumping is dropped from the conclusion. `twin_complyThenOwn` (ReadStages.lean:521-526) concludes `∃ h, Learning.Lumped π h ∧ select h ∧ (h true, h false) = complyThenOwn`, and its docstring (516-519) says "also selects one reading through it". Without that half, the clause "There" (π telling the stages apart) does nothing. `Training.Through` (Learning.lean:931-932) with `AgreeOn (· = true)` asks agreement at `true` only. So any selected g with g true = comply makes (comply, own) selected whatever π is, even for a constant π with g = (comply, comply). Only the twin's reading through π needs π true ≠ π false.

03's Reading has the same gap for RF2's law: "a selection through the readings that selects a law reading through the lumping also selects one taking any act there". `twin_selected` (Unread.lean:104-107) concludes `∃ h, Lumped π h ∧ select h ∧ AgreeOn R h g ∧ h x = v`. Without `Lumped π h`, any unread x gets every value from `Through` alone.

X1 asked for both halves and was taken in 03's theorem, record law 7 and the study. X1's and S10's verdicts said the header kept both, but its conclusion lacks the second half. X8's replacement then put the same half form into 03's Reading.

**Replacement.** Header: "There, every selection through agreement on the read stage that selects a law reading through `π` and complying when read also selects one reading through `π` that takes `complyThenOwn` (`twin_complyThenOwn`, RF2's `Learning.twin_selected`)". 03's Reading: "a selection through the readings that selects a law reading through the lumping also selects one reading through it that takes any act there". In the overview's RF2 sentence, likewise: "also selects one reading through it that takes any value there".

**Verdict: real.** Real, low severity: the sentence is ambiguous, not false. In ReadStages.lean, twin_complyThenOwn (520-526) concludes `∃ h, Learning.Lumped π h ∧ select h ∧ (h true, h false) = complyThenOwn`, and its own docstring (516-519) says "also selects one reading through it". The header (67-69) says only "also selects one taking `complyThenOwn`". `Training.Through` (Learning.lean:931-932) with `AgreeOn (· = true)` (935) makes the selection depend only on the act at `true`. Bool has decidable equality, so h = (comply, own) is selected for every π whenever the selected g complies at `true`. If "one" means just "a law", the clause "There" (π telling the stages apart) does no work. 03's Reading (03-KNOWING.md:484, from X8) and the overview's RF2 sentence (THE-THEORY-OF-BECOMING.md:96, unchanged since RF2's landing) use the same form. RF2's home theorem (03:477) and RF2's record law are explicit ("a selected law reading through `π`", "a selected twin reading through the lumping"). So is the X1 fix taken in 03:482, record law 7 and the study ("one reading through it that takes the plan"), even though the hypothesis half was also present there. Against the finding: "one" can be read as "a law reading through π", as the X1 and S10 finders and the X8 verifier read it, and RF2's own record statement leaves the twin implicit ("also selects twins"). One slip in the finding: the remarks that the header "kept both" were in X1's and S10's finding texts, not their verdicts; X1's verifier cited the docstring (515-518) instead. The replacements are exact and harmless. Changing the header changes the module source, so it needs the rebuild and fresh receipt that landing makes anyway.

## XB2 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/board_rf2.py:60-63 (land7's new statements sentence). Also _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:179 (§4.6, RF7 bullet).

**Quoted.** “a law drawing its act afresh at each stage still does better than acting by its own law at both, with some chance of complying, exactly where the weight of being kept after complying, less twice that after acting by its own law, times the value, exceeds the loss”

**Problem.** This is X4's defect, still present in two places X4 and F7(4) did not cover. `FreshDrawAbove m r` (ReadStages.lean:279-281) uses one chance at both stages. The module lists "chances where the stages are told apart" among what it leaves out (lines 180-181). So `freshDraw_above_iff` concerns only a law that cannot tell the stages apart.

For a law that can tell them apart and draws a chance per stage, the "only where" fails. Chance one at the read stage and nought at the unread one is complyThenOwn, which stands above ownAtBoth wherever k_O V + c T < k_C V (`complyThenOwn_best_iff`). Take the valid prospects T=10, k_C=9, k_O=4, V=10, c=1: then 50 < 90, but 2 k_O V + c T = 90 is not below 90.

The root bullet and the checker now say "a law that cannot tell the stages apart" (X4), and so does the dossier (F7(4)). Two places do not:
- The board, where only "still" after the third exit hints at the restriction. F7(4) found that hint insufficient in the dossier.
- The plan's bullet: "and drawing the act afresh, which, complying with some chance at each stage, stands above acting by its own law at both exactly where `k_C V > 2 k_O V + c T`". It comes right after the clause on laws that do tell the stages apart.

The board's clause also lacks the probability frame its first clause carries. F7's replacement had that frame.

**Replacement.** Board: "a law that cannot tell the stages apart but draws its act afresh at each stage still does better than acting by its own law at both, with some chance of complying, exactly where, read as probabilities, the weight of being kept after complying, less twice that after acting by its own law, times the value, exceeds the loss". Plan: "and, for a law that cannot tell the stages apart, drawing the act afresh, which, complying with some chance at each stage, stands above acting by its own law at both exactly where `k_C V > 2 k_O V + c T`".

**Verdict: real.** Confirmed. The land7 text (board_rf2.py:60-63) and PLAN.md:179 state the fresh-draw law for any law. `FreshDrawAbove` (ReadStages.lean:278-280) has one chance m/(m+r) at both stages, and the module lists "chances where the stages are told apart" among what it leaves out (179-180). I recomputed the counterexample with valid prospects T=10, k_C=9, k_O=4, V=10, c=1: k_O V + c T = 50 < 90, so complyThenOwn_best_iff puts complyThenOwn (value 8) above ownAtBoth (value 4). But 2 k_O V + c T = 90 is not below 90, and the best single chance only reaches 4. Per-stage chances 0.99 and 0.01 give about 7.87 > 4. So for a law that tells the stages apart, "only where" fails. F7(4) (REVIEW-RF7-COLDREAD.md:1660) confirmed the same unrestricted subject in the dossier, with the same "still" after the third exit, and the dossier now says "A law that cannot tell the stages apart". X4 fixed the root bullet and the checker only. In the plan, the restriction appears only in a later sentence about §4.5, not on the law. The probability-frame point is weaker but matches X10's standard: "read as probabilities" sits inside the first clause, and in natural numbers the second clause would say (k_C − 2k_O)V > c, off by the factor T. Outside this finding, the dossier's fresh-draw sentence (ALIGNMENT.md:28) also lacks that frame. The replacements are correct.

## XB3 (exactness, low, confirmed)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:96 (§3, the reading clause added by S4's fix). Also theories/becoming/chapters/07-SIGNIFICANCE.md:651 (row "Which function is learned", from S2's fix).

**Quoted.** “taking the selection's keeping to respond to the act read as evidence of the formation's law, the incentive deceptive alignment names”

**Problem.** The concealment premise is stated in the weaker form that the re-check rejected. The module's Readings (ReadStages.lean:128-131) and 03's Reading (03-KNOWING.md:484) take the premise as the keeping responding to the act as evidence of the law "so that a selection shown the law would keep it less". They add that "the weights alone fit equally a selection that knows the law and keeps it on compliance, under which complying when read hides nothing".

The cross-model re-check (item 6) found the evidence-only form too weak, since "Evidence can be accurate". That fix was taken in 03, the record and the study's Boundary, and the dossier states the full premise. The overview and 07's row ("taking the selection's keeping to respond to the act read as evidence of the law and the prospects as the formation's own assessment") now carry the evidence-only form again. An informed selection meets that form, so the incentive reading does not follow from it.

**Replacement.** Overview: "Read as inner alignment, evaluation awareness and, taking the selection's keeping to respond to the act read as evidence of the formation's law, so that a selection shown the law would keep it less, the incentive deceptive alignment names, these locate …". 07: "and, taking the selection's keeping to respond to the act read as evidence of the law, so that a selection shown the law would keep it less, and the prospects as the formation's own assessment, as the incentive deceptive alignment names (…)". The row's prefix, which ALIGNMENT.md quotes, is unchanged.

**Verdict: real.** Confirmed. THE-THEORY-OF-BECOMING.md:96 and 07-SIGNIFICANCE.md:651 state the premise as "taking the selection's keeping to respond to the act read as evidence of the [formation's] law" and stop there. The module's Readings (ReadStages.lean:127-131), 03's Reading (03-KNOWING.md:484) and the dossier (ALIGNMENT.md:28) add "so that a selection shown the law would keep it less". The module and 03 also note that the weights fit an informed selection, under which complying "hides nothing". The cross-model re-check's item 6 (REVIEW-ROUND2.md:1313-1316) rejected the evidence-only form ("Evidence can be accurate"). That fix was taken in 03, the record and the study's Boundary (line 1330; the record's correspondence and does_not_show item 2, study Boundary 70-72). S2's and S4's replacements (REVIEW-RF7-FINAL.md:203, 239) used the evidence-only form, and S4's verdict accepted it as "the concealment clause". So these fixes brought back the weaker premise, under which the identification with the source's "deceptive" does not follow. 08's bullet only points to "the concealment premise of 03 §11" and is fine. Both replacements are grammatical, and 07's prefix that ALIGNMENT.md quotes stays unchanged.

## XB4 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:85 ("The reviews, and what was taken", the nine-point re-check)

**Quoted.** “the plan drawing afresh is a behavioural plan, renamed `FreshDrawAbove`, with a single mixture of the uniform plans shown never to gain (`mixture_never_above`)”

**Problem.** This is X2/Z6, still present in the study. The study's Delta defines gain (study_rf7.txt:12-15: "A plan's gain and loss are the two parts of its expected value times the total", `Prospects.gain`). Read in that sense, "never to gain" is false. `MixtureAbove a b` (ReadStages.lean:286-287) gives the mixture the gain b·k_O V, which is positive wherever b and k_O V are. `mixture_never_above` proves only ¬MixtureAbove, that the mixture never stands above ownAtBoth.

The same paragraph (line 87) says the final check kept "gain" to its defined sense. Also, `FreshDrawAbove` is the comparison with ownAtBoth (a Prop), not the plan.

**Replacement.** "the plan drawing afresh is a behavioural plan, its comparison with acting by its own law at both renamed `FreshDrawAbove`, with a single mixture of the uniform plans shown never to stand above acting by its own law at both (`mixture_never_above`)"

**Verdict: real.** Confirmed, low severity. study_rf7.txt:85 says a single mixture is "shown never to gain (`mixture_never_above`)". The same section defines gain as part of a plan's expected value times the total (lines 12-15, `Prospects.gain`). `MixtureAbove` (ReadStages.lean:285-286, docstring 282-284, "its gain") gives the mixture a gain of b·k_O V, which is positive wherever b and k_O V are. `mixture_never_above` (698) proves only ¬MixtureAbove, and its docstring keeps the comparison ("gains nothing on the second"). X2 and Z6 confirmed this comparator-less use of "never gains" in 03. Their fix covered the study's Standing but not this paragraph, while line 87 says "gain" was kept to its defined sense, so the study contradicts itself. A second point: `FreshDrawAbove` (278-280) is a Prop comparing with ownAtBoth, renamed from `MixedAbove` (REVIEW-ROUND2.md:1065-1069, 1106). The module has no declaration for the plan itself, so "the plan … renamed `FreshDrawAbove`" misdescribes what was renamed. The replacement is correct.

## XB5 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:85 ("The reviews, and what was taken", the four-lens review's confirmed points)

**Quoted.** “a law drawing its act afresh at each stage does better than the uniform exit, now a law”

**Problem.** The claim is unconditional, which is stronger than the law it reports. `freshDraw_above_iff` says only that some chance stands above ownAtBoth, exactly where 2 k_O V + c T < k_C V. `freshDraw_above_iff_chance` says which chances. On `Example.prospects`, where the gap holds (70 < 90), chance one in four does not (`Example.freshDraw_boundary`). With no value, no chance does (`freshDraw_not_above_without_value`).

**Replacement.** "a law that cannot tell the stages apart but draws its act afresh at each stage can do better than the uniform exit, now a law saying exactly where and with which chances (`freshDraw_above_iff`, `freshDraw_above_iff_chance`)"

**Verdict: real.** Confirmed, low severity. study_rf7.txt:85 says without condition that "a law drawing its act afresh at each stage does better than the uniform exit, now a law". `freshDraw_above_iff` (ReadStages.lean:675-679) says only that some chance with 0 < m stands above ownAtBoth, exactly where 2 k_O V + c T < k_C V. `Example.freshDraw_boundary` (769-773) has chance one in four failing where that gap holds (70 < 90), and `freshDraw_not_above_without_value` (682-685) rules out every chance when there is no value. D1's own point (REVIEW-RF7-LENSES.md, D1) carried the condition "exactly where 2 k_O V + c T < k_C V". E21 was confirmed for the board's less sweeping form ("still gains where …"), so this one is stronger than the Lean by the same standard. A note on the replacement: `freshDraw_above_iff_chance` came with the later re-check (REVIEW-ROUND2.md:1103), which the same paragraph credits next. Better to cite only `freshDraw_above_iff` here: "can do better than the uniform exit, now a law saying exactly where (`freshDraw_above_iff`)".

## XB6 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:323-328 (AMEND[what-readings-fix-of-the-unread]['correspondence'], English new text, written into RF2's landed record)

**Quoted.** “a law drawing its act afresh can stand above acting by its own law at both without telling the stages apart, as their §4.5 notes (when-complying-when-read-is-best)”

**Problem.** RF2's record has no stages and no plans. Its laws are over "Any types of occasions, values and lumps" (its hypotheses), and this landing removes its next step, the only earlier mention of two stages. So "the stages" and "at both" have no antecedent in that record. This is the misdescription X11 corrected in the related entry ("The same two stages"); S1's fix brings it back. The Chinese already says 不分两阶段 ("two stages"), so the two editions differ slightly.

**Replacement.** English: "in two stages, a law drawing its act afresh can stand above acting by its own law at both without telling them apart, as their §4.5 notes (when-complying-when-read-is-best)". The amended correspondence is then 1199 of its 1200-character cap, so capped('correspondence') passes. The Chinese is unchanged.

**Verdict: real.** Real, low severity. RF2's record (what-readings-fix-of-the-unread.json) is over "Any types of occasions, values and lumps". Its only mention of stages is the next_delta, which this landing replaces with "A frozen test". The amended English correspondence (make_records_rf7.py:323-328) says "stand above acting by its own law at both without telling the stages apart". That uses RF7's plan name and "the stages" with no antecedent in the field; only the cited record id hints at them. S1's verifier proposed "a law drawing its act afresh at each stage …", and the taken text dropped "at each stage". X11, confirmed, judged a similar presupposition of two stages in the same amendment a misdescription, and said another section's "in two stages" does not rescue it. The Chinese (每阶段重抽其行之律不分两阶段…) names "each stage" and "two stages". That is a difference of wording, not of content, so it does not add an English–Chinese finding. Caps, computed: the amended English is 1190 of 1200 characters, the proposed text 1199 of 1200, and the unchanged Chinese 342 of 500, so capped('correspondence') passes.

## XB7 (exactness, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:292-294 (the done() call: the new record's history, what_en and what_zh)

**Quoted.** “每阶段重抽其行而较之单一混合”

**Problem.** Z5's replacement makes the Chinese say the fresh draw is compared with a single mixture (较之). The English "drawing the act afresh against a single mixture" reads the same way. No theorem compares the two plans: `FreshDrawAbove` and `MixtureAbove` (ReadStages.lean:279-287) each compare only with ownAtBoth. X2's verdict confirmed this point against the correspondence's "its gain over a single mixture", which has since been reworded.

**Replacement.** English: "…, its join to RF2, and drawing the act afresh, beside a single mixture, which never stands above acting by its own law at both". Chinese: "…、与 RF2 之接、每阶段重抽其行，并单一混合永不居两阶段皆依己律之上". The history field has no cap.

**Verdict: refuted.** Refuted. The history line (make_records_rf7.py:292-294) lists what was added. "Drawing the act afresh against a single mixture" (zh 每阶段重抽其行而较之单一混合) names a contrast the record itself states. Law 8 says "a single mixture of the two uniform plans never does"; the correspondence says "its standing above acting by its own law at both where no single mixture does is the advantage of behavioural strategies" (zh 其可居两阶段皆依己律之上而单一混合永不能者); the module's Standing (ReadStages.lean:115-118) draws the same contrast. The line asserts no result of a direct comparison. X2's defect was "its gain over a single mixture", which claimed the fresh draw beats the mixture, and X2's own fix kept the contrast through ownAtBoth. The Chinese is Z5's confirmed replacement, adopted to match the English (X13). Nothing here is stronger than the files support. The proposed wording is acceptable but optional.

## SB1 (sources, medium, confirmed)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:96 (§3, the reading clause) and theories/becoming/chapters/07-SIGNIFICANCE.md:651 (row "Which function is learned"); the claim about them is in kit/round2/study_rf7.txt:87

**Quoted.** “Read as inner alignment, evaluation awareness and, taking the selection's keeping to respond to the act read as evidence of the formation's law, the incentive deceptive alignment names (overview); and, taking the selection's keeping to respond to the act read as evidence of the law and the prospects as the formation's own assessment, as the incentive deceptive alignment names (07)”

**Problem.** Both texts state only the evidence half of 03 §11's concealment premise. They drop its counterfactual, "so that a selection shown the law would keep it less" (03-KNOWING.md:484; ReadStages.lean:128-130). The cross-model re-check (REVIEW-ROUND2.md:1313-1316 and 1330, item 6) found the evidence clause alone too weak. Evidence can be accurate, and 03 itself says the weights fit equally a selection that knows the law and keeps it on compliance, "under which complying when read hides nothing". Only the counterfactual gives the source's sense of deceptive: seeming fitter to the base optimizer than it actually is (rlo.txt:1687-1689, §7.4 glossary). The final check's S2 and S4 fixes carried the premise into 07 and the overview in this weak form. The dossier (S3) and the study's Boundary have it whole. The study's account therefore claims more than these two texts show: "the concealment premise stated wherever the incentive is read (07, the overview, the dossier, this Standing)".

**Replacement.** Overview: "Read as inner alignment, evaluation awareness and, taking the selection's keeping to respond to the act read as evidence of the formation's law, so that a selection shown the law would keep it less, the incentive deceptive alignment names, these locate …". 07: "and, taking the selection's keeping to respond to the act read as evidence of the law, so that a selection shown the law would keep it less, and the prospects as the formation's own assessment, as the incentive deceptive alignment names (…)". ALIGNMENT.md quotes only the row's prefix, which is unchanged, and with these fixes the study's sentence becomes true.

**Verdict: real.** Confirmed. THE-THEORY-OF-BECOMING.md:96 and 07-SIGNIFICANCE.md:651 both say only 'taking the selection's keeping to respond to the act read as evidence of the [formation's] law'. A grep finds 'shown the law' in 03 and ALIGNMENT.md but in neither of these two texts. 03-KNOWING.md:484 states the premise with its counterfactual and adds that the weights alone fit a selection that knows the law, 'under which complying when read hides nothing'. The cross-model re-check (REVIEW-ROUND2.md:1313-1316, item 6) judged this evidence-only form too weak: 'Evidence can be accurate ... The new identification therefore does not follow.' It was taken with the counterfactual in 03, the record and the study's Boundary (line 1330). The source's sense is 'to seem more fit from the perspective of the base optimizer than it actually is' (dl-rlo/rlo.txt:1687-1689). S2's and S4's replacements (REVIEW-RF7-FINAL.md) supplied only the evidence half, so these fixes introduced the gap; nobody raised or refuted it for these two texts. study_rf7.txt:87 says the premise is stated in 07 and the overview, which is more than they show. The replacement is right, and ALIGNMENT.md quotes only the 07 row's prefix, which it leaves unchanged.

## SB2 (sources, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:484 (Reading at r-when-complying-when-read-is-best); ReadStages.lean:112-114 (Standing); kit/round2/study_rf7.txt:59-61 (Standing)

**Quoted.** “similar to the absent-minded driver problem (Aumann, Hart and Perry 1997; Piccione and Rubinstein 1997), whose planning-optimal policy defects at random”

**Problem.** This is a misattribution, introduced by a fix. Before S6's change the text read "the problem is an absent-minded driver's (…), whose planning-optimal policy defects at random", and "whose" was the toy problem itself (REVIEW-RF7-COLDREAD.md:885). After the change to "similar to the absent-minded driver problem (…), whose …", the clause attaches to the absent-minded driver problem. In that problem the planning-optimal decision, in Aumann, Hart and Perry's own term (their §2), is to continue with probability 2/3 and exit with probability 1/3. Nothing defects. The random defection belongs to the toy: Hubinger and others apply the driver's reasoning to their figure-3 example and find that the toy's planning-optimal policy defects with probability about 0.61 (rlo.txt:1469-1471).

**Replacement.** 03: "…similar to the absent-minded driver problem (Aumann, Hart and Perry 1997; Piccione and Rubinstein 1997), by whose reasoning the toy's planning-optimal policy defects at random." The module's Standing and the study's Standing take the same clause with their single citation: "…(Aumann, Hart and Perry 1997), by whose reasoning the toy's planning-optimal policy defects at random; …". The module's prose change needs its rebuild.

**Verdict: real.** Confirmed. In 03:484, ReadStages.lean:112-114 and study_rf7.txt:59-61, 'whose planning-optimal policy defects at random' now follows 'similar to the absent-minded driver problem (...)'. That problem is its nearest antecedent. R1's earlier wording (REVIEW-RF7-COLDREAD.md:885) was 'the problem is an absent-minded driver's (...), whose ...', which made the toy problem the antecedent, so taking S6 moved the attachment. Aumann, Hart and Perry, §2 (scratchpad tools-pdf/ahp.txt): 'the optimal randomized decision is CONTINUE with probability 2/3 and EXIT with probability 1/3 ... We call this the planning-optimal decision'. Nothing in it defects. The random defection belongs to the toy: 'If we apply the same reasoning as in the absent-minded driver problem to our example in figure 3, the planning-optimal policy for the mesa-optimizer is to defect with probability p ≈0.61' (dl-rlo/rlo.txt:1469-1471). S6 refuted a different point, and this problem came from taking it all the same. 'By whose reasoning the toy's planning-optimal policy defects at random' matches the source. 08's bullet has no such clause.

## SB3 (sources, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:484 (Reading, the "Under this reading" sentence); ReadStages.lean:136-137 (Readings)

**Quoted.** “Under this reading, strict optimality needs a positive value at the unread stage and an assessed rise in being kept from complying, numerical counterparts of parts of the first two conditions”

**Problem.** "Assessed" makes the weights the formation's own assessment. That is a premise this reading has not taken. The Reading states it only later and conditionally ("If the prospects are the formation's own expected-value assessment"), and the module header (ReadStages.lean:36-37) and the record's first non-implication keep it open as a reading ("whose the weights are … is a reading, not part of the model"). The clause just before says the weights "stand for what the second condition's model is of, the training's selection and what it asks, not for the model". So the sentence uses an unstated premise, in tension with that clause. `outweighs_needs` concludes only `0 < s.value ∧ s.keptOwn < s.keptComplying`.

**Replacement.** 03: "Under this reading, with the prospects taken as the formation's own assessment, strict optimality needs a positive value at the unread stage and an assessed rise in being kept from complying, numerical counterparts of parts of the first two conditions; …". Module: "Under this reading, with the prospects taken as the formation's own assessment, `outweighs_needs` shows that strict optimality needs …", which needs a rebuild.

**Verdict: real.** Confirmed, low severity. In 03:484 the reading first says the weights 'stand for what the second condition's model is of, the training's selection and what it asks, not for the model'. It then says 'an assessed rise'. Only later, and conditionally, does it say 'If the prospects are the formation's own expected-value assessment'. The module header (ReadStages.lean:35-37) and the record's does_not_show[0] (make_records_rf7.py:224-227) keep whose the weights are open as a reading, and they set 'the formation's own assessment' against 'the selection actually applied'. So 'assessed' takes one side without saying so, against the clause just before it. outweighs_needs (ReadStages.lean:435-436) concludes only 0 < s.value ∧ s.keptOwn < s.keptComplying. The word came from the cross-model re-check's replacement, which was framed 'even when the numbers represent an assessment' (REVIEW-ROUND2.md:1055-1057). The R5 verifier noted that it 'suggests' the own assessment while the text leaves it open (REVIEW-RF7-COLDREAD.md:1006), but nobody raised it as a finding. The replacement states the premise where it is used; the module's change needs a rebuild.

## SB4 (sources, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:484 (Reading at r-when-complying-when-read-is-best)

**Quoted.** “with the toy's episodes not told apart the problem is, in their words, similar to the absent-minded driver problem”

**Problem.** This reference to the source has no antecedent in the home section. It is the only occurrence of "toy" in 03. Neither the theorem paragraph nor the Reading says which toy is meant, or that the comparison generalizes the toy example opening Hubinger and others' §4. Only 08's bullet, the module's Standing, the record's correspondence and the study say so. A reader of the result's home section cannot tell which toy or which episodes are meant. The phrase came in with the cold read's R1 replacement (REVIEW-RF7-COLDREAD.md:885).

**Replacement.** "with the episodes of the toy example opening their §4 not told apart, the problem is, in their words, similar to the absent-minded driver problem (…)". This composes with the previous finding's change to the end of the same sentence.

**Verdict: real.** Confirmed, low severity. A grep of 03 finds 'toy' and 'episodes' only at line 484. The section's opening, the theorem paragraph (482) and the Reading never introduce a toy, and 03 cites Hubinger and others only for §4.2 and §4.5. That RF7's comparison generalizes the toy example opening their §4 is said only in 08:485, the module's Standing, the record's correspondence (make_records_rf7.py:261) and the study. The source's §4.5 points back to 'the example in figure 3' (dl-rlo/rlo.txt:1466), the toy that opens §4 (1047-1091). The phrase came in with R1's replacement (REVIEW-RF7-COLDREAD.md:885). The cold read treated undefined references in this home section as real before (E3, the letters). The replacement is accurate and composes with #1's change.

## SB5 (sources, low, confirmed)

**Location.** kit/round2/make_records_rf7.py:323-330 (AMEND[RF2]['correspondence'], en and zh, written into theories/becoming/results/records/what-readings-fix-of-the-unread.json); also RF's PLAN.md:227 (literature row)

**Quoted.** “a law drawing its act afresh can stand above acting by its own law at both without telling the stages apart, as their §4.5 notes (when-complying-when-read-is-best); zh: 如其 §4.5 所言（when-complying-when-read-is-best）”

**Problem.** This is an ambiguous attribution, introduced by S1's fix. "Their" follows a citation of two works, "(Hubinger and others 2019; Greenblatt and others 2024)". The remark is Hubinger and others' alone (rlo.txt:1464-1473). Greenblatt and others' paper has no §4.5: its §4, on synthetic document fine-tuning, ends at §4.3 (arXiv 2412.14093v2). RF2's own new history entry names it "Hubinger and others' §4.5". The plan's row has the same ambiguity after Z15's fix: after "(Hubinger and others 2019, §4; Greenblatt and others 2024)" it says "their §4's toy …; their §4.5's random defection", and Greenblatt and others do have a §4, with no toy in it.

**Replacement.** En: "…without telling the stages apart (Hubinger and others' §4.5; when-complying-when-read-is-best)." The amended field becomes 1196 of the 1200 cap. Zh: "…不分两阶段亦可居两阶段皆依己律之上（Hubinger 等 §4.5；when-complying-when-read-is-best）。" (347 of 500). PLAN.md:227: "(Hubinger and others' §4 toy with weights; their §4.5's random defection with an exact threshold)".

**Verdict: real.** Confirmed, low severity. Applying make_records_rf7.py:319-330 to what-readings-fix-of-the-unread.json gives a correspondence of 1190/1200 en and 342/500 zh characters. It reads '(Hubinger and others 2019; Greenblatt and others 2024), whose ... ; a law drawing its act afresh ..., as their §4.5 notes'. Two works are cited, and the nearer is Greenblatt and others. Their paper's §4 (arXiv 2412.14093v2, 'Synthetic document fine-tuning') has only 4.1, 4.2 (with 4.2.1) and 4.3, so it has no §4.5. The remark is Hubinger and others' (dl-rlo/rlo.txt:1464-1473), as RF2's own new history names it. 如其 §4.5 has the same ambiguity. With the replacement the field is 1196/1200 en and 347/500 zh (computed), and correspondence is not a lint-public field. PLAN.md:227's 'their §4's toy; their §4.5's', after the same two works, is a milder instance, since Greenblatt and others' §4 has no toy.

## SB6 (sources, low, confirmed)

**Location.** kit/round2/make_records_rf7.py:340-345 (AMEND[RF2]['history'], en and zh, written into what-readings-fix-of-the-unread.json)

**Quoted.** “the correspondence's necessary condition is for a deterministic law, a law drawing its act afresh needing none (Hubinger and others' §4.5); zh: 对应中之必要条件为确定律者，每阶段重抽其行之律无需之（Hubinger 等 §4.5）”

**Problem.** The history keeps the wording S1's verifier rejected, and it says more than the sources. S1's verifier found that "needs no such lumping" conflicts with the module's convention that the lumping carries everything the law reads, any chance it draws included (REVIEW-RF7-FINAL.md:184; ReadStages.lean:75-76). The correspondence took "can stand above acting by its own law at both without telling the stages apart" instead, but the history did not. The necessary condition is "of what deceptive alignment and alignment faking describe". Greenblatt and others' abstract defines alignment faking as complying selectively in training, and says the free/paid cue was supplied so the model could infer when it was in training. A law drawing afresh that cannot tell the conditions apart has one compliance rate in both, so it shows no gap. Hubinger and others' §4.5 concerns only deceptive alignment's incentive to defect at random. "Needing none" is therefore false for alignment faking.

**Replacement.** En: "the correspondence's necessary condition is stated for a deterministic law, a law drawing its act afresh being able to stand above acting by its own law at both without telling the stages apart (Hubinger and others' §4.5)". Zh: "对应中之必要条件限于确定律，每阶段重抽其行之律不分两阶段亦可居两阶段皆依己律之上（Hubinger 等 §4.5）". The history field has no cap in tools/research/style.py.

**Verdict: real.** Confirmed. AMEND[RF2]['history'] (make_records_rf7.py:340-345) says 'a law drawing its act afresh needing none (Hubinger and others' §4.5)'. S1's verifier rejected this claim (REVIEW-RF7-FINAL.md:184: "'needs no such lumping' conflicts with the module's convention that the lumping carries everything the law reads, any chance it draws included"). The correspondence took 'can stand above acting by its own law at both without telling the stages apart' instead (lines 323-328), so the history now says more than the field it describes. The condition is 'of what deceptive alignment and alignment faking describe'. Greenblatt and others' abstract defines alignment faking as selectively complying in training, and the free/paid cue is there so the model can infer when it is trained. A law that cannot tell the conditions apart has one compliance rate in both, so it shows no gap. Hubinger and others' §4.5 (dl-rlo/rlo.txt:1464-1473) concerns only deceptive alignment's incentive. study_rf7.txt:87 repeats 'needing none'. tools/research/style.py has no cap on history. The replacement is accurate in both languages.

## SB7 (sources, low, confirmed)

**Location.** kit/round2/board_rf2.py:74-75 (land7 branch, the RF row's readings sentence on the work board)

**Quoted.** “concealment as shaping an analogy, which RF7's law replaces.”

**Problem.** This presents a reading as a result. Saying RF7's law replaces the concealment analogy makes concealment what the law states. RF7's record lists concealment among what it does not show: complying when read conceals only where it makes the law seem fitter to the selection than it is, "which the prospects do not give". The plan, corrected after the cross-model re-check's item 7, says "The connection to RuleShaping stays an analogy; RF7 states the separate two-stage comparison (§4.6), with disclosure and concealment as labelled readings" (PLAN.md:127).

**Replacement.** Replace the new string with "concealment as shaping an analogy; RF7 states a separate two-stage comparison, disclosure and concealment readings of it.", keeping the assert on the old string.

**Verdict: real.** Confirmed, low severity. The land7 string (board_rf2.py:74-75) makes the RF row read 'Readings, no new Lean: ...; concealment as shaping an analogy, which RF7's law replaces.' That makes the law what replaces the concealment reading. RF7's record lists concealment among what it does not show ('which the prospects do not give', make_records_rf7.py:228-231). PLAN.md:127, corrected after the re-check's item 7, says 'The connection to RuleShaping stays an analogy; RF7 states the separate two-stage comparison (§4.6), with disclosure and concealment as labelled readings.' The final check confirmed the same kind of overclaim in RF2's history (S5, 'now done there') and took it as 'disclosure and concealment readings of it' (lines 340-342). R17/F15 also removed 'concealment' as a name for the result. The module's Standing, the study and the plan's §4.6 do say RF7 replaces the analogy, but they mean the analogy with RuleShaping, replaced by a strict comparison of expected values, and concealment stays a labelled reading. The board ties the replacement to concealment and drops that qualification. The replacement fixes this and keeps the assert on the old string (line 71).

## ZB1 (zh-and-fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/board_rf2.py:60-63 (land7 branch, the `new` string); also _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:179 (§4.6, RF7 bullet: "and drawing the act afresh, which, complying with some chance at each stage, stands above acting by its own law at both exactly where `k_C V > 2 k_O V + c T`")

**Quoted.** “a law drawing its act afresh at each stage still does”

**Problem.** A dropped hypothesis. `FreshDrawAbove m r` uses one chance m/(m+r) at both stages, so `freshDraw_above_iff` covers only a law that cannot tell the stages apart. For a law that tells the stages apart and has a chance per stage, the board's "exactly where" is false. Take valid prospects T=10, k_C=9, k_O=4, V=10, c=1. Complying with chance 9/10 when read and 1/10 when not has expected value 0.9·0.85·10 − 0.9 = 6.75, against 4 for acting by its own law at both; `complyThenOwn` itself stands above it, since k_O V + c T = 50 < 90 = k_C V. Yet 2 k_O V + c T = 90 is not below 90. The final check's X4 restricted this subject in the root bullet and the checker, and the cold read's F7 did so in the dossier. The board's land7 sentence and the plan's §4.6 bullet were not changed. "Still" leans on the preceding exit but restricts nothing. The board's fresh-draw threshold is also given in probabilities without saying so: the earlier "read as probabilities" is several clauses back, past the exits.

**Replacement.** Board: "a law that cannot tell the stages apart but draws its act afresh at each stage still does better than acting by its own law at both, with some chance of complying, exactly where, read as probabilities, the weight of being kept after complying, less twice that after acting by its own law, times the value, exceeds the loss". Plan §4.6: "and drawing the act afresh where the stages cannot be told apart, which, complying with some chance at each stage, stands above acting by its own law at both exactly where `k_C V > 2 k_O V + c T`".

**Verdict: real.** Confirmed. The land7 `new` string (board_rf2.py:55-63) says 'a law drawing its act afresh at each stage still does better ... exactly where ...'. PLAN.md:179 says 'drawing the act afresh, which, complying with some chance at each stage, stands above ... exactly where `k_C V > 2 k_O V + c T`'. Neither restricts the subject. `FreshDrawAbove m r` (ReadStages.lean:278-280) has one chance m/(m+r) at both stages, and the module's modelling choices leave out 'chances where the stages are told apart' (179-180). X4 restricted the subject only in Becoming.lean and check_becoming.py, which now say 'a law that cannot tell the stages apart but draws its act afresh'. F7(4) did the same for the dossier, even though its verifier noted that 'still' only implies the restriction. So by the reviews' own standard, the board's 'still' is not enough. I recomputed the counterexample. The chances 0.9 when read and 0.1 when not give −0.9 + 0.9·(0.81+0.04)·10 = 6.75 > 4. A single chance p at both stages gives 4 − 5p² ≤ 4, which agrees with 2k_O V + c T = 90 not being below 90. The secondary point also holds. By X10's verdict, 'read as probabilities' in an earlier semicolon item does not carry to a later one. Read in natural numbers, the board's words state (k_C − 2k_O)V > c, which is off by T. The replacements are correct.

## ZB2 (zh-and-fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py, Chinese of the new record: statement (line 150), law 8 (204, twice), law 9 (215), hypotheses (223), does_not_show 4 (237), counterexample 3 (246)

**Quoted.** “每阶段重抽、以某机从者居两阶段皆依己律之上”

**Problem.** The Chinese uses 机 alone for "chance". In this repository 机 is the glossary's term for juncture (GLOSSARY.md: "juncture (机) | where a loss passes"), and records use it in that sense: a-source-before-a-juncture has "来源须在机前到达" and "x 是机". Records render "chance" as 机会 (typicality-by-counting "机会是同类情境之数", fulfillment-chance-floor "机会下界", fixation-by-drift "展开中的机会") or 概率 (selection-through-a-model-of-the-options "等概率"). Read in the glossary's sense, the Chinese departs from the English: 以某机从者 reads "one complying at some juncture", 两阶段可分时之机 reads "the juncture where the stages are told apart", and 每阶段独立重抽一机 reads "redraws a juncture independently at each stage". So one term carries two senses, and the Chinese differs in content from the English. The cold read's E28 on "stage" was refuted because the glossary reserves the Chinese 层, not the English word. 机 is exactly such a reserved Chinese term.

**Replacement.** Write 机会 for 机 in all seven places. Statement: "每阶段重抽、以某机会从者居两阶段皆依己律之上" (99/150). Law 8: "以 m/(m+r)（0 < m）之机会从之律" and "故于某机会恰当" (148/190). Law 9: "以八分之一或五分之一之机会从者" (95/190). Hypotheses: "或每阶段独立重抽一机会" (118/190). does_not_show 4: "两阶段可分时之机会" (42/110). Counterexample 3: "每阶段以八分之一之机会从者居其上".

**Verdict: real.** Confirmed. GLOSSARY.md:35 gives 'juncture (机) | where a loss passes', and 02-MAP.md:68 defines '机 (jī, juncture)'. Landed records use 机 alone in that sense: a-source-before-a-juncture has 来源须在机前到达 and x 是机, and reaching-before-and-after-a-juncture has 机前与机后之可得. RF7's zh uses 机 alone for 'chance' at the seven listed places (make_records_rf7.py:150, 204 twice, 215, 223, 237, 246). I counted every record field whose English has 'chance': its Chinese is 机会 (13) or 概率 (3), never 之机 or 某机. This is E12's ground (二阶 has another sense here), and S11's verdict restates it. E28 was refuted because the glossary reserves the Chinese 层; here the reserved term is the Chinese 机 itself. Read in the glossary's sense, 两阶段可分时之机 says 'the juncture when the stages can be told apart', which differs from 'chances where the stages are told apart'. No earlier review raised 机. The replacements fit: 99/150, 148/190, 95/190, 118/190, 42/110, and counterexamples have no cap.

## ZB3 (zh-and-fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:87 (paragraph "The cold read of the texts", its last two sentences)

**Quoted.** “Of the refuted, the source's "similar to" was taken all the same. The refuted points: the review sections, present in the kit; the stage word, used so in practice; the README row's form, its siblings';”

**Problem.** A misattribution. This list follows the sentence on the final check ("50 points, 42 confirmed and 8 refuted"), so it reads as that check's refuted points. It lists instead the cold read's five refuted points: E23/F2 (the review sections), E28 (the stage word), F27 (the README row) and E27 (the alias), as in REVIEW-ROUND2's cold-read table. Seven of the final check's eight refuted points go unmentioned. They are S7 (the Greenblatt settings), S8 (08 and the third condition), S11 (欺骗式对齐, taken with Z11), Z19 (03's Open's short name), Z20 (the overview's "doing so"), Z23 (the nine-point re-check's name) and Z25 (the field `cost`). The eighth, S6, is the "similar to" the paragraph does name. The list was left in place when the final-check sentences were inserted before it.

**Replacement.** Move "The refuted points: the review sections, present in the kit; the stage word, used so in practice; the README row's form, its siblings'; and that an alias must mean what the statement means, which no rule asks, though a confirmed point asked the same and was taken, concealment staying searchable among what the record does not show." to just after "75 confirmed and 5 refuted", headed "The cold read's refuted points:". After the final check's list, write: "Its refuted points: the source's "similar to" and 欺骗式对齐, both taken all the same; the Greenblatt sentence's settings; the third condition in 08's reading; 03's Open's short name; the overview's "doing so"; the nine-point re-check's name; and the field `cost`."

**Verdict: real.** Confirmed. study_rf7.txt:87 lists 'the review sections ...; the stage word ...; the README row's form ...; and that an alias must mean what the statement means'. These are the cold read's five refuted points (E23 and F2, E28, F27, E27 in REVIEW-ROUND2's cold-read table). The list comes right after the final check's '50 points, 42 confirmed and 8 refuted' and after 'Of the refuted, the source's "similar to" was taken all the same', which is S6, a final-check point. So the list reads as the final check's refuted points. Those are S6, S7, S8, S11, Z19, Z20, Z23 and Z25 (REVIEW-RF7-FINAL), and seven of them go unnamed. The replacement is accurate: S11's 欺骗对齐 was taken through Z11.

## ZB4 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:323-330 (AMEND for what-readings-fix-of-the-unread, correspondence en_new and zh_new); also study_rf7.txt:87 ("a law drawing afresh needing none by their §4.5")

**Quoted.** “above acting by its own law at both without telling the stages apart, as their ”

**Problem.** Two problems, the first a misattribution. (1) "their §4.5" (zh 如其 §4.5 所言) follows "(Hubinger and others 2019; Greenblatt and others 2024)", two works, so it can be read as Greenblatt and others' §4.5. The same amendment's history writes "Hubinger and others' §4.5", and the source is Hubinger et al.'s closing §4.5 paragraph. The study's final-check list has the same dangling "their §4.5" with no author named. (2) RF2's record speaks of occasions, read and unread. "The stages" and "at both" are RF7's terms, defined nowhere in RF2's record.

**Replacement.** en_new, ending: "…whose intention, anticipation and incentive are not represented; a law drawing its act afresh, not telling read from unread, can stand above acting by its own law at both (Hubinger and others' §4.5; when-complying-when-read-is-best)." (field 1194 of 1200). zh_new, ending: "…其意图、预期与诱因未表；每阶段重抽其行之律不分读与不读，亦可居两阶段皆依己律之上（Hubinger 等 §4.5；when-complying-when-read-is-best）。" (349 of 500). Study: "a law drawing afresh needing none by Hubinger and others' §4.5".

**Verdict: real.** Confirmed for part (1). make_records_rf7.py:323-330 writes 'as their §4.5 notes' (zh 如其 §4.5 所言) right after '(Hubinger and others 2019; Greenblatt and others 2024)'. The nearer work is Greenblatt's. The same amendment's history (340-345) writes 'Hubinger and others' §4.5'. study_rf7.txt:87's 'needing none by their §4.5' has no antecedent in its clause. F24 and Z15 confirmed section references that could point to the wrong document. Part (2) is weaker. The amended related entry introduces 'two stages, read and unread', so 'the stages' has a referent in RF2's record, though not in this field. 'At both' stays undefined there, and the replacement keeps it. Lengths: the amended field is now 1190/342, and the replacement 1194/1200 en and 349/500 zh, so it fits.

## ZB5 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:179 (§4.6, RF7 bullet)

**Quoted.** “the exits and what the plan needs; its join to RF2, the plan open to some law reading through a lumping exactly where the lumping tells the stages apart”

**Problem.** One term in two senses. In PLAN.md "the plan" is the document itself ("The plan rests on evidence kept in evidence/"). Here it names complying when read and acting by its own law when not, so "what the plan needs" reads as what RF's plan needs. Z8 removed the same double sense from the record but not from the plan. The module header also uses both senses: line 11 "what the plan needs of the formation's lumping", against lines 119 and 182, "the plan's analogy" and "the plan's open item on deception". "Some law" is also the generic subject E15/X3 replaced with "some act law".

**Replacement.** "the exits and what that plan needs; its join to RF2, that plan open to some act law reading the stages through a lumping exactly where the lumping tells them apart"

**Verdict: real.** Confirmed on the main point. PLAN.md:3 ('The plan rests on evidence...') and 333 ('this plan') use 'the plan' for the document. Line 179 uses it for complyThenOwn ('what the plan needs', 'the plan open to some law'). X7 and Z8 confirmed this kind of double use in the record and fixed it only there. The module header likewise has line 11 against lines 118-119 and 182. The sub-point on 'some law' is not a problem. 'Some' is already existential. E15/X3's defect was the generic 'an act law', and E15's verdict counted the plan's 'open' wording among the correct summaries. 'Act law' would only be more exact.

## ZB6 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:346-348 (AMEND for shaping-the-rule-selected-by-what-comes-back, related, en and zh)

**Quoted.** “Complying when read so that the law is kept, which the plan first read as this”

**Problem.** In RuleShaping's record "the plan" has no antecedent, since that record never mentions RF's plan. In RF7's texts "the plan" also names complying when read and acting by its own law when not, so the sentence can read as that plan reading itself as shaping. Z8 fixed exactly this in the new record's related field ("The earlier analogy for concealment in RF's plan") but not in this amendment. The zh 计划 likewise names no RF.

**Replacement.** en: "Complying when read so that the law is kept, which RF's plan first read as this shaping by analogy: there a strict comparison of expected values in two stages." zh: "读时从以使其律被守，RF 之计划初以类比读为此塑；彼处为两阶段中期望值之严格比较。" (related details carry no cap).

**Verdict: real.** Confirmed. shaping-the-rule-selected-by-what-comes-back.json never mentions RF's plan. The only plan it names is 'board item AJ's plan' (zh 看板项 AJ 之计划) in its correspondence, so 'the plan' / 计划 in the new related detail (make_records_rf7.py:346-348) points there if anywhere. Z8 changed the new record's related field to 'in RF's plan' (287-288) but not this amendment. Related details have no cap (style.py CAPS_V2 and ITEM_CAPS_V2), so the replacement needs no length check.

## ZB7 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:30-32 (Delta, "Telling the stages apart" bullet)

**Quoted.** “uniform or the lumping tells the stages apart (plan_realized_iff, lumped_uniform), so the plan is open exactly”

**Problem.** This is the slip Z8 confirmed and fixed in the record's law 6, still present in the study. "A plan" first names an arbitrary plan. "The plan" then names complying when read and acting by its own law when not, the sense it has in the rest of the study. "Exactly there" includes "uniform", so the clause restates the first and loses what `complyThenOwn_realized_iff` says: the plan, not uniform, is open exactly where the lumping tells the stages apart.

**Replacement.** "uniform or the lumping tells the stages apart (plan_realized_iff, lumped_uniform), so the plan, not uniform (complyThenOwn_not_uniform), is open exactly where the lumping tells the stages apart (complyThenOwn_realized_iff)"

**Verdict: real.** Confirmed. study_rf7.txt:29-32 reads 'a plan is open ... exactly where it is uniform or the lumping tells the stages apart ..., so the plan is open exactly there (complyThenOwn_realized_iff)'. This is the structure X7 and Z8 confirmed in the record's law 6. The record now reads 'so the plan, not uniform, is open exactly where the lumping tells them apart', while the study was left unchanged and never states complyThenOwn_not_uniform. As X7's verdict says, nothing is false under the intended reading, so this is low severity.

## ZB8 (zh-and-fit, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:484 (Reading after r-when-complying-when-read-is-best)

**Quoted.** “with the toy's episodes not told apart the problem is, in their words, similar to the absent-minded driver problem”

**Problem.** "The toy" has no antecedent in the home section. Neither 03's theorem paragraph nor its Reading says that the comparison generalizes the toy example opening Hubinger and others' §4. That is said only in 08 §8, the module, the record and the study, so a reader of 03 §11 cannot tell which toy is meant.

**Replacement.** "with the episodes of the toy example opening their §4 not told apart, the problem is, in their words, similar to the absent-minded driver problem"

**Verdict: real.** Confirmed. 'toy' occurs once in 03-KNOWING.md, at line 484 in the Reading. Neither §11's opening, the theorem paragraph (482) nor the Reading introduces a toy. Only 08 §8, the module's Standing and the study say 'the toy example opening §4 of Hubinger...'. This is the kind of reference F10 confirmed: 'the first two exits', never named.

## ZB9 (zh-and-fit, low, confirmed)

**Location.** theories/becoming/review/ALIGNMENT.md:41 ("How it was made", RF's entry)

**Quoted.** “Added on 29 and 30 October 2026 (board item RF, formations that read): the paragraph on RF's rounds in the box above and its clauses on deception and assistance games.”

**Problem.** The account of how the dossier was made is incomplete. The diff shows RF7 also made three other changes to the box. It added ", or addresses only in part" to the box's title and ", or only part," to its lead, and it shortened the box's quotation of chapter 7 in the inner-alignment clause, dropping ", nor anything of deception" because 07's row changed. The AJ5 entry still credits "the box on what the theory does not address" to 29 October's AJ5 work, so RF's edits to the title, lead and quotation are attributed to AJ5.

**Replacement.** "Added on 29 and 30 October 2026 (board item RF, formations that read): the paragraph on RF's rounds in the box above, its clauses on deception and assistance games, "or addresses only in part" in its title and "or only part" in its lead, and its quotation of chapter 7, shortened where chapter 7's row changed."

**Verdict: real.** Confirmed, low. ALIGNMENT.md's diff adds ', or addresses only in part' to the box's title and ', or only part,' to its lead, and drops ', nor anything of deception' from the inner-alignment clause's quotation of 07. RF's entry (line 41) lists only the paragraph on RF's rounds and the deception and assistance clauses. AJ5's entry (line 40) still lists 'the box on what the theory does not address' as AJ5's. F28's verdict says the list's pattern is to record each later addition, so the title and lead changes, which alter the box's claim, are left unrecorded and implicitly AJ5's.

## ZB10 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:286 (§12, Coordination); kit/round2/board_rf2.py:73 (land7, feeds cell)

**Quoted.** “**AJ5's scope box** names RF's landed results, with links to their home sections (03 §11 and §12, 05 §8).”

**Problem.** Stronger than the files support; Z18's replacement introduced it. RF6.1 has landed (`Becoming.OpenedCorrection`, home 03 §8, study §457), and the box names it nowhere. Its RF paragraph names only RF1, RF2, RF4, the reading loop and RF7. The board's feeds cell, "AJ5's scope box (RF's results named)", says the same.

**Replacement.** Plan: "**AJ5's scope box** names RF's landed results on the questions it lists (all but RF6.1, 03 §8), with links to their home sections (03 §11 and §12, 05 §8)." Board: "AJ5's scope box (RF's results on its questions named)".

**Verdict: real.** Confirmed, low. RF6.1 has landed (580cd9d62, §457, home 03 §8). The plan itself says 'then RF6.1 (landed, §4.6)' (PLAN.md:282). ALIGNMENT.md never mentions OpenedCorrection, RF6.1, 03 §8 or a revision opening a correction. Its RF paragraph covers round 1, the reading loop with the reflexive prediction, and RF7. So 'names RF's landed results' (PLAN.md:286, Z18's replacement) and the board's '(RF's results named)' (board_rf2.py:73) say more than the box does.

## ZB11 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:227 (§8, row "Deceptive alignment, alignment faking")

**Quoted.** “the third condition assumed”

**Problem.** A term with no definition where it is used. The plan never names the three conditions of Hubinger and others' §4.2, so "the third condition" has no antecedent anywhere in the plan. The condition meant is the expectation that the threat of modification will go away.

**Replacement.** "the third of Hubinger and others' §4.2 conditions, that the threat of modification will go away, assumed"

**Verdict: real.** Confirmed, low. PLAN.md never names the three conditions of Hubinger and others' §4.2. Its other uses of 'condition' are unrelated (lines 96, 146-148, 175, 197), and line 148 even has another triple, RF6.1's 'three things'. So 'the third condition assumed' at line 227 (from R20's taken replacement) has no antecedent. This is the kind of undefined reference F10 and E3 confirmed.

## ZB12 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:179 (§4.6, RF7 bullet); kit/round2/study_rf7.txt:67-68 (Standing: "It replaces the analogy with RuleShaping in the plan's §4.2.")

**Quoted.** “It replaces §4.2's analogy with RuleShaping; a recipient's belief and an intention to cause one are not represented.”

**Problem.** "Replace X with Y" reads as putting Y in X's place, here RuleShaping in place of §4.2's analogy, which is the reverse of what is meant. The plan's own §4.2 now says "The connection to RuleShaping stays an analogy". The module states the point without the ambiguity: "replaces the plan's analogy with `RuleShaping.favours_iff`, … by a strict comparison of expected values".

**Replacement.** Plan: "In place of §4.2's analogy with RuleShaping it states its own comparison of expected values; a recipient's belief and an intention to cause one are not represented." Study: "In place of the analogy with RuleShaping in the plan's §4.2, it states a strict comparison of expected values."

**Verdict: real.** Confirmed, low. PLAN.md:179 says 'It replaces §4.2's analogy with RuleShaping', and study_rf7.txt:67-68 says 'It replaces the analogy with RuleShaping in the plan's §4.2'. Under the idiom 'replace X with Y', both put RuleShaping in the analogy's place. That is the misreading the cross-model re-check's item 7 removed from PLAN.md:127, which now says 'The connection to RuleShaping stays an analogy'. The module (ReadStages.lean:118-120) avoids the ambiguity with 'by a strict comparison of expected values', which the plan and the study drop.

## ZB13 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:22, 26, 37, 39, 47, 48, 58, 61

**Quoted.** “with either absent the choice is the own law at both”

**Problem.** One plan carries two names. The study names `ownAtBoth` "the own law at both" eight times and "acting by its own law at both" twice. Every other text, the record included, says "acting by its own law at both". REVIEW-ROUND2's table says Z21 was taken by writing "acting by its own law at both" in the record and in the study, but the study was not changed that way.

**Replacement.** Write "acting by its own law at both" for "the own law at both" at each of the eight places, e.g. "with either absent the choice is acting by its own law at both".

**Verdict: real.** Confirmed, low. The counts check out: 'the own law at both' at study lines 22, 26, 37, 39, 47, 48, 58 and 61, and 'acting by its own law at both' at 17 and 87. 03, 08, the dossier, the overview, the plan and the record use only the long form. REVIEW-ROUND2's Z21 row says the study took 'acting by its own law at both', which is false of the study. Caveat: the module's drawing-afresh docstrings (ReadStages.lean:272, 282, 598, 603, 634, 673, 681, 696) also write 'the own law at both', so 'every other text' is overstated. Correcting the Z21 row would resolve the discrepancy equally well.

## ZB14 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/register_rf7.py:34-36 (WITNESS); its reasons land in THEOREM-CONNECTIVITY-APART.json

**Quoted.** “'.Example.': 'prospects of a total of 10, weights 9 and 1, a value of 10 and a loss of 5, and their variations (RF)',”

**Problem.** The register would misdescribe one witness. Every `ReadStages.Example` root gets this reason. That includes `Example.no_total`, which nothing uses, so it is an apart root. Its prospects (total 0, weights 1 and 0, value 1, loss 100) are neither these nor a variation of them; they are the invalid witness. The register would record a wrong model for it.

**Replacement.** WITNESS = {'.Example.no_total': 'prospects with a total of 0, weights 1 and 0, a value of 1 and a loss of 100, not valid (RF)', '.Example.': 'prospects of a total of 10, weights 9 and 1, a value of 10 and a loss of 5, and their variations (RF)'} (the first matching key is taken, so no_total's entry must come first).

**Verdict: real.** Confirmed, low, but the location's path lacks round2/: the file is kit/round2/register_rf7.py, lines 34-36. The key '.Example.' matches every Example name (line 42). Example.no_total (ReadStages.lean:778-782) is a theorem nothing uses; grep finds it only at its definition and in a header comment. By THEOREM-CONNECTIVITY.py:311-322 it is therefore an apart root that the script registers. Its prospects are {0, 1, 0, 1, 100}, neither ⟨10, 9, 1, 10, 5⟩ nor one of the `{ prospects with … }` variations, and the header lists it separately ('prospects with a total of nothing'). The replacement works because dict order makes '.Example.no_total' match first.
