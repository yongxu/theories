# The third check of RF7's texts

RF round 2, RF7. After the second final check's points and the cross-model reader's four were taken, three readers, one per lens (exactness against the Lean; sources and readings; the Chinese edition and fit), read the round's changes in context, as integrated on main in a rehearsal worktree (main at `6645a2fae`, with the round's diff at its root), against the module `Becoming.ReadStages` and, for the sources, the paper's text and the cited works, alongside the cross-model reader's re-check of the same rehearsal. Each lens's findings were then checked together by a separate reader asked to refute each. Of 11 findings, 9 were confirmed and 2 refuted. The findings and verdicts are reproduced verbatim from the run's result, with absolute paths of the rehearsal and landing worktrees made repository-relative and links quoted from the texts shown unlinked (`]\(`); other absolute paths in the verdicts name the readers' working files, not kept. What was taken is in [REVIEW-ROUND2](REVIEW-ROUND2.md#the-third-check-through-three-lenses); the prompts are in [BRIEF](BRIEF.md#round-2).

## XC1 (exactness, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:324-332, AMEND['what-readings-fix-of-the-unread']['correspondence'], en_new and zh_new (written into theories/becoming/results/records/what-readings-fix-of-the-unread.json). This is how the cross-model re-check's point 1 was taken (evidence/REVIEW-ROUND2.md:1434).

**Quoted.** “it locates where two laws reading through the formation's lumping can agree on every reading and differ unread, only where the lumping tells the occasion from every read one: for deterministic laws, a necessary condition of what deceptive alignment and alignment faking describe (Hubinger and others 2019; Greenblatt and others 2024); zh: 唯在此归并分此时于每一读处者：于确定律，为欺骗对齐与对齐伪装所述者之必要条件”

**Problem.** A confirmed point taken only in part. The cross-model re-check's point 1 (REVIEW-ROUND2.md:1404-1406) found that the amendment "promotes this particular behavioural boundary into a necessary condition of the broader phenomenon". It asked for the necessary condition to be stated for two deterministic laws reading through one lumping that agree on every read occasion and differ at the unread one, and for the literature to be introduced separately ("Read with deceptive alignment and alignment faking …").

The taken text makes the twins what is located. But after the colon it still calls the boundary, for deterministic laws, a necessary condition of what deceptive alignment and alignment faking describe. The Taken cell at REVIEW-ROUND2.md:1434 says the same.

Unread.lean bounds only twins:
- `twin_selected`: two laws reading through π agree on every reading (`AgreeOn R h g`) and differ at x, where no read occasion shares x's lump and being in it is decided.
- `Learning.lumped_determines`: where a read occasion does share x's lump, laws agreeing on the readings agree at x.

RF2's home section (03-KNOWING.md:479) reads this only as "so where the formation can tell being read from not being read", and it puts a reader misled outside that chain.

For alignment faking's compliance gap the condition is not necessary even for a deterministic law. Take read occasions (free,q1)↦A and (free,q2)↦B, unread occasions (paid,q1)↦B and (paid,q2)↦B, and a law complying exactly at A. It complies on 1/2 of read occasions and 0 of unread ones, with the same queries in both conditions and the tier coupling in for q1. Yet every unread occasion shares a lump with a read one, and `lumped_determines` fixes its act from the readings.

The condition is necessary only for the twin pattern: agreeing with another law on every reading and acting otherwise unread. Deceptive alignment's idealization fits that pattern; a compliance gap need not.

**Replacement.** en_new: "it locates where two deterministic laws reading through the formation's lumping can agree on every reading and differ unread, only where the lumping tells the occasion from every read one, read with deceptive alignment and alignment faking (Hubinger and others 2019; Greenblatt and others 2024), whose intention, anticipation and incentive are not represented; a law drawing its act afresh can act otherwise unread without telling read from unread (Hubinger and others' §4.5; when-complying-when-read-is-best)." This brings the amended field to 1155 of its 1200 cap.

zh_new: "其示经形成之归并而读之二确定律可于每一读处皆合而于未读处相异之处，唯在此归并分此时于每一读处者，与欺骗对齐及对齐伪装并读（Hubinger 等 2019；Greenblatt 等 2024），其意图、预期与诱因未表；每处重抽其行之律，不分读与未读，亦可于未读处行异（Hubinger 等 §4.5；when-complying-when-read-is-best）。" This is 345 of 500.

Then bring these to match it: the history (next finding), the study's RF2 sentences and REVIEW-ROUND2.md:1434's Taken cell.

**Verdict: real.** The re-check's point is taken only in part. In the scratch kit, make_records_rf7.py:324-332 makes the twins what is located, but it keeps the clause 'for deterministic laws, a necessary condition of what deceptive alignment and alignment faking describe' (zh 于确定律，为欺骗对齐与对齐伪装所述者之必要条件). That is the clause the cross-model re-check's point 1 quoted (REVIEW-ROUND2.md:1400-1406). The point said the clause 'promotes this particular behavioural boundary into a necessary condition of the broader phenomenon', and asked for the condition to be stated for the twins, with the literature introduced separately ('Read with …'). The Taken cell at 1434 keeps the claim. The Lean bounds only the twins: Unread.lean:104-110 twin_selected concludes Lumped π h ∧ select h ∧ AgreeOn R h g ∧ h x = v, and Learning.lean:858-862 lumped_determines fixes the act only among laws in Lumped π that agree on the data. I checked the counterexample. With π(free,q1)=A and every other occasion in B, the law that complies exactly at A is in Lumped π. It complies at 1/2 of read and 0 of unread occasions, and the tier couples in for q1. Yet both unread occasions share lump B with the read (free,q2), so lumped_determines fixes their acts. That is a compliance gap with RF2's condition failing at every unread occasion. 03-KNOWING.md:479 reads RF2 only as 'where the formation can tell being read from not being read' and puts a reader misled outside the chain. I computed the replacement: the field becomes 1155/1200 en and 345/500 zh. Correspondence is not a lint-public field, and its one '§4' does not trigger round-accretion. Outside the snapshot: the live kit (rf-landing) has a later section, 'The re-check after the second final check'. There the cross-model reader raised the same point on this round's texts, and it was taken as 'is read as such a difference'. The compliance-gap counterexample bears on that wording too; 'read with' avoids the problem.

## XC2 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:342-349, AMEND['what-readings-fix-of-the-unread']['history'], en and zh (written into RF2's record). Also REVIEW-ROUND2.md:1434, whose Taken cell says "the history and the study likewise".

**Quoted.** “the correspondence locates where two laws reading through the formation's lumping can differ when not read, its necessary condition stated for deterministic laws; zh: 对应示经形成之归并而读之二律于未读处可异之处，其必要条件限于确定律”

**Problem.** A dropped hypothesis, introduced when this round rewrote the history.

The correspondence it describes locates where two laws reading through the lumping "can agree on every reading and differ unread". Without the agreement the location is everywhere: two laws reading through π that differ at a read occasion d also differ at every unread x with π x = π d.

The agreement is what the cross-model re-check's point 1 turned on. RF2's boundary is for twins agreeing on every read occasion: `twin_selected` concludes `AgreeOn R h g`, and `lumped_determines` fixes only laws that agree on the readings. The reader asked for the history to be matched to that narrower scope, and REVIEW-ROUND2.md:1434 says it was. Both languages drop the agreement alike.

**Replacement.** If the correspondence is kept, en: "the correspondence locates where two laws reading through the formation's lumping can agree on every reading and differ when not read, its necessary condition stated for deterministic laws, since a law drawing its act afresh can act otherwise unread without telling read from unread (Hubinger and others' §4.5)"; zh: "对应示经形成之归并而读之二律可于每一读处皆合而于未读处相异之处，其必要条件限于确定律，因每处重抽其行之律不分读与未读亦可于未读处行异（Hubinger 等 §4.5）".

If the previous finding's correspondence is taken instead, en: "the correspondence locates where two deterministic laws reading through the formation's lumping can agree on every reading and differ when not read, read with deceptive alignment and alignment faking, a law drawing its act afresh able to act otherwise unread without telling read from unread (Hubinger and others' §4.5)"; zh: "对应示经形成之归并而读之二确定律可于每一读处皆合而于未读处相异之处，与欺骗对齐及对齐伪装并读，每处重抽其行之律不分读与未读亦可于未读处行异（Hubinger 等 §4.5）".

tools/research/style.py has no cap on history.

**Verdict: real.** The history drops the agreement in both languages. make_records_rf7.py:345-349 reads en 'the correspondence locates where two laws reading through the formation's lumping can differ when not read' and zh 对应示经形成之归并而读之二律于未读处可异之处. Both leave out the agreement on every reading that the correspondence it describes (324-332) carries ('can agree on every reading and differ unread', 可于每一读处皆合而于未读处相异). Without that hypothesis the location is not RF2's: two laws in Lumped π that differ at a read d also differ at every x with π x = π d, by the definition at Learning.lean:834. So the history no longer describes the 'only where the lumping tells the occasion from every read one' that the correspondence states. The before text (round diff 707-709) described no location, so this round's rewrite introduced the omission. Point 1 asked for the history to be matched to the narrower scope (REVIEW-ROUND2.md:1406), and the Taken cell (1434) says 'the history and the study likewise'; it is not matched. tools/research/style.py has no cap on history (it is in neither CAPS_V2 nor ITEM_CAPS_V2). Outside the snapshot, the live kit's history now states the agreement.

## XC3 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:90 ("The cold read of the texts", in the list of what was taken from the first final check)

**Quoted.** “RF2's record, whose reading called telling the occasion apart a necessary condition of deceptive alignment, now saying so only for deterministic laws reading through one lumping, a law drawing its act afresh able to act otherwise unread without telling read from unread (Hubinger and others' §4.5)”

**Problem.** A misattribution, introduced when this round rewrote the item.

The first final check's S1 was taken as "for a deterministic law; a law drawing afresh can stand above without telling the stages apart (§4.5)" (REVIEW-ROUND2.md, final check table, row S1), with "needing none" in the history. The wording now credited to it came later:
- "reading through one lumping" from the cross-model re-check's point 1;
- "act otherwise unread without telling read from unread" and "Hubinger and others' §4.5" from the second final check's XB6, SB5 and SB6.

The same paragraph then credits those two checks with the same changes: "RF2's necessary condition claimed beyond its laws", and "RF2's record speaking of read and unread occasions, naming Hubinger and others' §4.5, and no longer saying that a law drawing afresh needs no telling apart". So the first final check's fix is shown in a form the re-check later found still wanting, and RF2's change is counted twice.

**Replacement.** "RF2's record, whose reading called telling the occasion apart a necessary condition of deceptive alignment, now saying so for a deterministic law only, by Hubinger and others' §4.5 on a law drawing its act afresh". Optionally, in the re-check's list: "RF2's necessary condition claimed beyond its laws, now located for two laws reading through one lumping that agree on every reading".

**Verdict: real.** The study now credits the first final check with later changes. Before this round (round diff 831), study_rf7.txt:90's list for the first final check read 'now saying so for a deterministic law only, a law drawing afresh needing none by their §4.5', which matches S1's Taken cell (REVIEW-ROUND2.md:1356). It now reads 'only for deterministic laws reading through one lumping … act otherwise unread without telling read from unread (Hubinger and others' §4.5)'. Each of those changes came later: 'reading through one lumping' from re-check point 1 (1406, 1434); 'read from unread' from XB6 (1450); 'Hubinger and others' §4.5' in the correspondence from SB5 (1456); and dropping 'needing none' from SB6 (1457). The same paragraph then credits the re-check ('RF2's necessary condition claimed beyond its laws') and the second final check ('speaking of read and unread occasions, naming Hubinger and others' §4.5, and no longer saying that a law drawing afresh needs no telling apart') with the same changes. After the rewrite, the study never shows that the record said 'needs none', so RF2's change is counted twice. The paragraph's other items for the first check describe first takings: for example, the concealment premise is 'stated' in 07 and the overview, which the re-check later found incomplete. So the RF2 item is out of step with them. Point 1 and SB6 did ask for the study's wording to change, but the finding's split meets both: S1's form without 'needing none', and the narrower scope under the re-check's item. The garbled phrase 'shown in a form the re-check later found still wanting' does not change the problem the files show. Outside the snapshot, the live kit's line 90 keeps the same problem, now with the third re-check's wording too.

## XC4 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:3 (the section's opening paragraph, changed this round)

**Quoted.** “then checked twice more through three lenses and re-checked by the cross-model reader after each round of fixes”

**Problem.** Stronger than the review record supports. REVIEW-ROUND2.md records cross-model re-checks after two rounds of fixes:
- after the cold read's fixes ("The re-check of what was taken", with its continued session);
- after the first final check's fixes ("The re-check after the final check").

The second final check ran on the same texts as that second re-check ("On the same rehearsal as the cross-model reader's re-check above"). No cross-model re-check is recorded for the round of fixes that took both, and the study's own account ends with that round taken.

**Replacement.** "then checked twice more through three lenses, the cross-model reader re-checking what was taken after the cold read and after the first of those checks". Keep "after each round of fixes" only if a cross-model re-check of this round is run and recorded before landing.

**Verdict: real.** In this snapshot no cross-model re-check follows the latest round of fixes. study_rf7.txt:3, added this round (round diff 740-741), says 're-checked by the cross-model reader after each round of fixes'. The scratch REVIEW-ROUND2.md records cross-model re-checks at 'The re-check of what was taken' (1278, continued at 1333) and 'The re-check after the final check' (1394). 'The second final check through three lenses' (1439) ran 'On the same rehearsal'. The re-check's four points and that check's 27 were taken in one round, and no later section follows. The scratch BRIEF.md has no prompt for a later re-check, and the study's own line 90 ends with that round taken. I also tried the reading 'two rounds, each followed by both checks': it would leave out the round line 90 itself records, so on either reading the latest fixes are claimed as re-checked when the files do not show it. Outside the snapshot: the live kit's REVIEW-ROUND2.md now has 'The re-check after the second final check' (line 1474), and its study records it, with that re-check's one point taken afterwards. Applied there, the replacement should also name this third re-check, and 'after each round' would still fail for the fixes that took its point unless they too are re-checked.

## SC1 (sources, medium, confirmed)

**Location.** kit/round2/make_records_rf7.py:324-332. This is the AMEND for what-readings-fix-of-the-unread, correspondence en_new and zh_new, written into theories/becoming/results/records/what-readings-fix-of-the-unread.json inside its "AI reading:" sentence. Also its history at 342-349, and the account of the fix at evidence/REVIEW-ROUND2.md:1434 ("The re-check after the final check", row 1).

**Quoted.** “only where the lumping tells the occasion from every read one: for deterministic laws, a necessary condition of what deceptive alignment and alignment faking describe (Hubinger and others 2019; Greenblatt and others 2024)”

**Problem.** The cross-model reader's point 1 was not taken as recorded. Its point (REVIEW-ROUND2.md:1400-1406) was that this behavioural boundary is promoted into "a necessary condition of the broader phenomenon"; it asked for the necessity to be stated for the twins and the literature to come in separately ("Read with deceptive alignment and alignment faking …"). The round now states the twins but keeps the necessity for both works. The "Taken" cell (1434) says the field now reads "for deterministic laws a necessary condition of what deceptive alignment describes", which is not what the field says.

For deceptive alignment the narrower claim holds. Take a deterministic law reading through the lumping that complies at every read occasion, as the §4 mesa-optimizer does throughout training, and acts otherwise at x. Then x's lump holds no read occasion (Learning.lumped_determines, which RF2's hypotheses cite).

For alignment faking it fails. Greenblatt and others describe a rate gap between paired conditions: the model "complies with harmful queries from free users 14% of the time, versus almost never for paid users" (arXiv 2412.14093, abstract). So it refuses on most read occasions too, and 03 §11 itself says "the difference is one of rates". A counterexample within RF2's hypotheses ("Any types of occasions, values and lumps"):
- the read occasions are (q, free) and the unread ones (q, paid);
- the lumping keeps each (q, free) apart and sends each (q, paid) to the lump of some (q′, free) on which the law refuses;
- the law complies at (q, free) for q in a set S and refuses everywhere else.
It reads through that lumping and shows the gap. Yet no unread occasion is told from every read one, so by lumped_determines no twin differs anywhere unread. The gap needs only each paid occasion told from its own free counterpart.

07's row reads RF2 with deceptive alignment alone ("as deceptive alignment describes"), and so do this account and the study ("now saying so only for deterministic laws").

**Replacement.** en_new: "it locates where two laws reading through the formation's lumping can agree on every reading and differ unread, only where the lumping tells the occasion from every read one: for deterministic laws, a necessary condition of what deceptive alignment describes (Hubinger and others 2019), read with alignment faking (Greenblatt and others 2024), whose intention, anticipation and incentive are not represented; a law drawing afresh can act otherwise unread without telling read from unread (Hubinger and others' §4.5; when-complying-when-read-is-best)."

zh_new: "其示经形成之归并而读之二律可于每一读处皆合而于未读处相异之处，唯在此归并分此时于每一读处者：于确定律，为欺骗对齐所述者之必要条件（Hubinger 等 2019），与对齐伪装并读（Greenblatt 等 2024），其意图、预期与诱因未表；每处重抽其行之律，不分读与未读，亦可于未读处行异（Hubinger 等 §4.5；when-complying-when-read-is-best）。"

Caps, computed by applying the amendment to the current JSON against style.CAPS_V2['correspondence'] = (1200, 500): 1195/1200 in English ("its act" dropped to fit) and 358/500 in Chinese; style.lint reports nothing.

History (no cap): en "…its necessary condition stated for deterministic laws and for deceptive alignment, alignment faking read with it, since a law drawing its act afresh …"; zh "…其必要条件限于确定律与欺骗对齐，对齐伪装与之并读，因每处重抽其行之律……".

With these, REVIEW-ROUND2's row 1 and the study's account become accurate.

**Verdict: real.** Real. I applied AMEND[RF2] in memory to the current what-readings-fix-of-the-unread.json (1194/354 characters). The field reads 'for deterministic laws, a necessary condition of what deceptive alignment and alignment faking describe (Hubinger and others 2019; Greenblatt and others 2024)'. Three texts changed this round say otherwise:
- REVIEW-ROUND2.md:1434's Taken cell says the field reads 'for deterministic laws a necessary condition of what deceptive alignment describes'.
- study_rf7.txt:90 says 'a necessary condition of deceptive alignment, now saying so only for deterministic laws'.
- 07:651 reads RF2 'as deceptive alignment describes'.

So the account does not match the field. The cross-model point (REVIEW-ROUND2.md:1400-1406) objected that the boundary was 'promote[d] ... into a necessary condition of the broader phenomenon'. The round restated the twins (make_records_rf7.py:324-326) but kept that necessity for both works, so the point was taken only in part.

The substance holds. RF2's hypotheses allow 'Any types of occasions, values and lumps'. Learning.lumped_determines (Learning.lean:858) fixes the act wherever an occasion is lumped with a read one. The counterexample sends each (q, paid) to the lump of a refusing (q0, free) and complies at (q, free) for q in S. That law is Lumped, shows the free/paid gap, and has no unread occasion told from every read one. The paper describes a rate gap: 'selectively complying with its training objective in training', 'complies with harmful queries from free users 14% of the time, versus almost never for paid users' (arXiv 2412.14093 abstract, fetched). 03:484 itself says 'the difference is one of rates'. RF2's home section (03:479) also separates the twin's condition from 'behaviour changing when read', which needs only the paired occasions' states apart.

For deceptive alignment the narrower claim holds. The §4 toy goes to A in both training episodes (rlo.txt:1084-1089), so lumped_determines forces the condition.

This was not raised and refuted before. S1 accepted 'for a deterministic law' without considering rates, and SB6 concerned laws drawing afresh. The replacement measures 1195/1200 (en) and 358/500 (zh) against style.CAPS_V2, style.lint returns [], and history has no cap.

## SC2 (sources, low, confirmed)

**Location.** RF's PLAN.md:227 (§8, row "Deceptive alignment, alignment faking", third cell), written by kit/round2/integrate_rf7.py:290-292 (the change taken for ZB11).

**Quoted.** “the third of their §4.2 conditions, that the threat of modification will go away, assumed”

**Problem.** This misstates the source. Hubinger and others' third condition is the mesa-optimizer's expectation, not the fact: "The mesa-optimizer must expect the threat of modification to eventually go away" (dl-rlo/rlo.txt:1155). They stress that "this condition is a statement about the mesa-optimizer's expectations, not necessarily the actual truth" (rlo.txt:1233-1234).

The row states the condition as the fact. 03 §11's Reading, the module's Readings and the dossier all write "an expectation that the threat of modification will go away". The module adds that it "represents neither a mistaken expectation nor a threat the formation removes". So the plan now gives the condition a second sense.

ZB11's own problem named "the expectation that the threat of modification will go away". Its replacement dropped "expectation", and this round took that replacement verbatim.

**Replacement.** "the third of their §4.2 conditions, an expectation that the threat of modification will go away, assumed". Make the same change in integrate_rf7.py:291-292. The plan has no cap.

**Verdict: real.** Real, low severity. This round changed PLAN.md:227 (written by integrate_rf7.py:291-292) from 'the third condition assumed' to 'the third of their §4.2 conditions, that the threat of modification will go away, assumed'. That states the condition as the fact.

The source states it as the mesa-optimizer's expectation:
- rlo.txt:1155: '3. The mesa-optimizer must expect the threat of modification to eventually go away'.
- rlo.txt:1233-1234: 'this condition is a statement about the mesa-optimizer's expectations, not necessarily the actual truth'.
- rlo.txt:1239: a mesa-optimizer that 'mistakenly believes it has an opportunity to defect' also counts.

So the plan misstates the cited condition. The other texts of this landing all write 'an expectation that the threat of modification will go away': 03:484, ALIGNMENT.md:28 (written by integrate_rf7.py:214) and ReadStages.lean:142-143. The module adds that it 'represents neither a mistaken expectation nor a threat the formation removes' (ReadStages.lean:145). The plan therefore gives 'the third condition' a second sense.

ZB11's own problem named 'the expectation that the threat of modification will go away', but its replacement, taken as written, dropped 'expectation'. This was not refuted before: S8 concerned 08's reading. The plan has no Chinese edition and no cap, so the one-word replacement fits.

## ZC1 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:90 (paragraph "The cold read of the texts", in the sentences added this round on the cross-model re-check and the second final check)

**Quoted.** “the fresh-draw law given in the plan and on the board to any law drawing afresh”

**Problem.** "The plan" now has two senses in RF7's study section, and this round added two of the RF's-plan uses. In this section "the plan" names complying when read and acting by its own law when not. Delta: "stands above the plan", "so the plan, not uniform (complyThenOwn_not_uniform), is open", "takes the plan", "the plan is uniquely best and chosen". Standing: "what the plan needs". Line 88: "what the plan needs, now theorems". This same round's ZB12 fix rewrote the Standing's "the plan's §4.2" as "§4.2 of RF's plan" to keep RF's PLAN.md named, and ZB5, ZB6 and ZB7 confirmed this kind of double sense in the plan, RuleShaping's record and this study. The new sentences use "the plan" for RF's PLAN.md twice: "given in the plan and on the board" and "the board's reading of concealment, its fresh-draw clause and the plan's §4.6, §8 and §12 brought to what the texts say". The same paragraph has four older uses in that sense: "the plan's TR2", "the plan's literature row, intro and section notes", "the plan reading RF7 as turning the analogy with RuleShaping into an instance", "the plan's stale lines". This breaks the one-sense rule (AGENTS.md: each term in the one sense).

**Replacement.** "the fresh-draw law given in RF's plan and on the board to any law drawing afresh" and "the board's reading of concealment, its fresh-draw clause and §4.6, §8 and §12 of RF's plan brought to what the texts say". In the same paragraph, for one sense throughout: "its next step no longer TR2 of RF's plan", "RF's plan's literature row, intro and section notes", "RF's plan reading RF7 as turning the analogy with RuleShaping into an instance", "RF's plan's stale lines".

**Verdict: real.** Real, low severity. Both quoted clauses are new this round (the study hunk @@ -84,5 +87,5 @@ in RF7-ROUND4-DIFF.txt), and both use "the plan" for RF's PLAN.md. "Given in the plan and on the board" summarizes the re-check's point 3, which is about PLAN.md:179 and board_rf2.py:60. The other clause is "the plan's §4.6, §8 and §12". The same section uses "the plan" for complyThenOwn at study_rf7.txt lines 27, 32, 35, 48 and 68, and at line 88 ("what the plan needs, now theorems"). It names the document "RF's plan" at line 83, and at line 70 since this round's ZB12 taking ("§4.2 of RF's plan"). The reviews treat this as a defect even where context makes the meaning clear. Z8 (REVIEW-RF7-FINAL.md:461-471) confirmed the record's "The plan's earlier analogy" as a further sense of "the plan" in one record, and it was taken as "in RF's plan". ZB5's taking named RF's plan in the module, and ZB6's in RuleShaping's record. The new clauses go against that standard, which this round applied to the same section. The four older document-sense uses the finding lists are in clauses this round did not change, so they are outside this check. So is a fifth it misses at the paragraph's start, "the dossier, the plan and the board's text". Aligning all of them is harmless but optional. The two replacements for the new clauses are correct, and no cap applies.

## ZC2 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:3 (the section's opening paragraph, changed this round)

**Quoted.** “then checked twice more through three lenses and re-checked by the cross-model reader after each round of fixes”

**Problem.** This claims more review than the evidence records. The cross-model reader re-checked the cold read's fixes (REVIEW-ROUND2 "The re-check of what was taken") and the first final check's fixes ("The re-check after the final check", run alongside the second final check, per REVIEW-RF7-FINAL2's preamble). No re-check of the second final check's fixes, this round's, appears anywhere: not in REVIEW-ROUND2, which ends with that check's table; not in BRIEF, which has no such prompt; and not in the study's own account, which ends with "Its refuted point ... was kept". RF's plan §13 (PLAN.md:327) likewise lists only the two re-checks.

**Replacement.** "then checked twice more through three lenses, the cross-model reader re-checking the cold read's fixes before the first and the first's fixes alongside the second". Keep the present wording only if a cross-model re-check of this round's fixes is run and recorded in REVIEW-ROUND2 and BRIEF, and added to the study's account and the plan's §13, before landing.

**Verdict: real.** Real for the rehearsal as given. Read naturally, study_rf7.txt:3 says every round of fixes was re-checked by the cross-model reader. In this checkout nothing records a re-check of the last round, the fixes for the second final check and for the re-check's four points. REVIEW-ROUND2.md ends with the second final check's table. BRIEF's new prompts cover only the re-check after the first final check and the second final check. The study's own account at line 90 ends "Its refuted point ... was kept". PLAN.md:327 lists two cross-model re-checks. Context: the live kit at _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read now records that re-check. It has a REVIEW-ROUND2.md section "The re-check after the second final check", a BRIEF prompt for it, and a new closing sentence in study_rf7.txt:90. That meets most of the finding's own condition for keeping the wording. Two gaps remain. First, integrate_rf7.py, identical in both trees, still writes the §13 sentence with only two re-checks. Second, that re-check's point 1 led to a further fix, so "after each round of fixes" holds only if that fix is re-checked too; otherwise narrow the wording as proposed. Also, the live BRIEF calls this check "The third check", so "twice more" will be stale once this check is recorded.

## ZC3 (zh-and-fit, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:90 (the first final check's list of what was taken, rewritten this round, and the next sentence on the cross-model re-check)

**Quoted.** “RF2's record, whose reading called telling the occasion apart a necessary condition of deceptive alignment, now saying so only for deterministic laws reading through one lumping, a law drawing its act afresh able to act otherwise unread without telling read from unread (Hubinger and others' §4.5)”

**Problem.** The study credits the first final check with what two later rounds produced, and its own next sentences then contradict that. REVIEW-ROUND2's S1 row records that check's take as "RF2's correspondence: for a deterministic law; a law drawing afresh can stand above without telling the stages apart (§4.5)". The narrowing to two laws reading through one lumping came from the cross-model re-check's point 1. "Read from unread" came from XB6, and "Hubinger and others' §4.5" from SB5 and ZB4, both in the second final check. The study then reports those same changes as the re-check's ("RF2's necessary condition claimed beyond its laws") and the second check's ("RF2's record speaking of read and unread occasions, naming Hubinger and others' §4.5"). As written, the record is narrowed and its source named twice. The re-check's finding also contradicts the narrowed state just credited to the check before it.

**Replacement.** In the final check's list: "RF2's record, whose reading called telling the occasion apart a necessary condition of deceptive alignment, saying so for a deterministic law only, since a law drawing its act afresh can stand above acting by its own law at both without telling the stages apart". In the re-check's sentence: "RF2's necessary condition claimed beyond its laws, now stated for deterministic laws reading through one lumping". This keeps the re-check's request that the study's summary give the narrower scope, without the narrowing appearing twice and without SB6's "needing none" or ZB4's unattributed "their §4.5".

**Verdict: refuted.** Not real. The rewrite is what three confirmed points asked for. The cross-model re-check's point 1 says "Match the amendment's history and the study's final-review summary to this narrower scope" (REVIEW-ROUND2.md:1406). SB6's Taken says "the study likewise" (1457). ZB4 asked for Hubinger and others' §4.5 to be named in the study. Each item in that list states how things stand now ("now saying so"). Its unchanged item "the concealment premise stated wherever the incentive is read (07, the overview, the dossier, this Standing)" became true only with this round's XB3/SB1 fix. SB1's verifier said that "with these fixes the study's sentence becomes true", and REVIEW-ROUND2.md:1452 says "with it the study's sentence holds". So the reviews read these items as claims about the current state. The S1 item matches the rehearsal's amended RF2 correspondence (make_records_rf7.py:323-330). The later sentences report the points that led there, so nothing is false or contradictory, only told twice. The proposed text would bring back "for a deterministic law only", the scope the re-check rejected. The parallel re-check in the live kit (REVIEW-ROUND2.md:1498 there) again asks that this study clause follow the record's current scope. This is a matter of presentation.

## ZC4 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:88 (paragraph "The reviews, and what was taken"); experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadStages.lean:566 (docstring of square_split; the same line in kit/round2/tree/Becoming/ReadStages.lean)

**Quoted.** “so a choice with ties to the own law”

**Problem.** Two other names for acting by its own law at both remain, so two claims added this round are stronger than the files. The study now says "one name, acting by its own law at both, for that plan", and REVIEW-ROUND2's ZB13 row says it was taken "throughout the study and the module's docstrings". The study still has "ties to the own law". The module's square_split docstring still reads "The own law's weighted value times a square, split": the value there is k_O V, the gain of acting by its own law at both, and this same round rewrote the matching freshDraw_bound docstring from "the own law's gain at both" to "the gain of acting by its own law at both". Z21 (first final check) established that "the own law" names no plan, since complyThenOwn also acts by its own law at the unread stage.

**Replacement.** Study: "so a choice with ties going to acting by its own law at both". Module: "The weighted value of acting by its own law at both times a square, split: `(m + r) ((m + r) A)` is ...". This docstring change needs the rebuild and fresh receipt, in both the package and kit copies. If the module is not to be rebuilt again, narrow ZB13's Taken in REVIEW-ROUND2 to "the study and the drawing-afresh docstrings" instead.

**Verdict: real.** Real, low severity. Two claims made this round go beyond the files. One is study_rf7.txt:90's "one name, acting by its own law at both, for that plan". The other is REVIEW-ROUND2.md:1471's Taken for ZB13: "throughout the study and the module's docstrings". study_rf7.txt:88 still says "so a choice with ties to the own law". This paraphrases REVIEW-ROUND2.md:932 ("ties to the own law"), and that re-check says "`choose` explicitly resolves ties toward `ownAtBoth`" (947). So "the own law" names the plan chosen on ties, the use Z21 confirmed as a defect (REVIEW-RF7-FINAL.md:617-627: "the choice is the own law" turns it into a plan). In the module, whose package and kit copies are identical, square_split's docstring (ReadStages.lean:566) says "The own law's weighted value". ownAtBoth_best_iff (312) calls k_O V ownAtBoth's "weighted value", so this is the same possessive form this round removed from freshDraw_bound. The study fix is correct and needs no rebuild. The module fix needs the rebuild and a fresh receipt. The proposed fallback is inaccurate: square_split sits under the module's heading "Drawing the act afresh at each stage" (563), so a Taken narrowed to "the drawing-afresh docstrings" would still cover it. A narrowed Taken must name the docstrings ZB13 listed instead.

## ZC5 (zh-and-fit, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:327 (§13, "The reviews of RF7.", the clause added this round)

**Quoted.** “the cross-model reader's re-check of what it took (four points)”

**Problem.** This attributes the taking to the wrong party. "It" can only be the final check just named or the cross-model reader, and neither took anything: the final check's points were taken in the texts, and the re-check checked how. REVIEW-ROUND2 says the reader re-checked "how the texts took the final check's 42 confirmed points". The same sentence describes the earlier re-check correctly as "re-check of what was taken".

**Replacement.** "the cross-model reader's re-check of how the final check's points were taken (four points still wanting, all taken)"

**Verdict: refuted.** Not real. The finding assumes "it" can only mean the final check or the cross-model reader. That is wrong. In PLAN.md:327 the sentence's subject is `Becoming.ReadStages`, and the same sentence already refers back to it with "a cold read of its texts". So "the cross-model reader's re-check of what it took" naturally reads as what RF7, the module and its texts, took from the final check just named. That is accurate: REVIEW-ROUND2 says the reader re-checked "how the texts took the final check's 42 confirmed points", and the sentence ends "every confirmed finding was taken". Read against the nearest noun the phrase is loose, but it credits no fix to the final check or to the reader, so nothing is misattributed. The replacement is clearer and harmless, but optional.
