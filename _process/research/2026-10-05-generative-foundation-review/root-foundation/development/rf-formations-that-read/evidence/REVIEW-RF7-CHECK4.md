# The fourth check of RF7's texts

RF round 2, RF7. After the third check's points and the cross-model reader's were taken, two readers, one per lens (exactness and sources; the Chinese edition and fit), read the round's changes in context, as integrated on main in a rehearsal worktree (main at `119d464ca`, with the round's diff at its root), against the modules `Becoming.ReadStages`, `Becoming.Unread` and `Becoming.Learning` and the cited works, alongside the cross-model reader's re-check of the same rehearsal. Each lens's findings were then checked together by a separate reader asked to refute each. Of 9 findings, 4 were confirmed and 5 refuted. The findings and verdicts are reproduced verbatim from the run's result, with absolute paths of the rehearsal and landing worktrees made repository-relative and links quoted from the texts shown unlinked (`]\(`); other absolute paths in the verdicts name the readers' working files, not kept. What was taken is in [REVIEW-ROUND2](REVIEW-ROUND2.md#the-fourth-check-through-two-lenses); the prompts are in [BRIEF](BRIEF.md#round-2).

## ED1 (exactness-and-sources, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:3 (the section's opening paragraph; XC4 and ZC2 are about this line). The claims that it was taken are at study_rf7.txt:90 ("and this section's account of the re-checks"), evidence/REVIEW-ROUND2.md:1523 and :1527 (XC4 and ZC2 "Taken") and the "every confirmed finding was taken" in REVIEW-ROUND2.md:1516 and PLAN.md:327.

**Quoted.** “then checked twice more through three lenses and re-checked by the cross-model reader after each round of fixes”

**Problem.** Two confirmed points, XC4 and ZC2, were not taken, although the texts say they were. Both found that this sentence claims more review than the files record. REVIEW-ROUND2 records them as taken ("the re-checks named as they ran"; "as XC4"), and the study's account lists "this section's account of the re-checks" among what was taken. But the round's diff never touches line 3: the study's only hunk is @@ -87,5 +87,5 @@, and the line is word for word what XC4 quoted. This round made it worse in two ways. (1) The cold-read paragraph (line 90) and PLAN §13 now record three checks through three lenses after the cold read: the final check, the second final check, and "a third check through the three lenses scoped to the round's changes". So "twice more" contradicts the section's own account. (2) No cross-model re-check of the round that took the third check's points is recorded. REVIEW-ROUND2 ends with the third check's table, and BRIEF ends with its prompts. So "after each round of fixes" is still stronger than the files support. As a result, the statements that every confirmed finding was taken (study:90, REVIEW-ROUND2:1516, PLAN:327) do not yet hold.

**Replacement.** "then checked three times more through three lenses, the cross-model reader re-checking what was taken after the cold read and alongside the second and the third of those checks". If this check and a re-check run alongside it are recorded before landing, count them too: "four times more", "alongside the last three". The study has no cap.

**Verdict: real.** Confirmed. study_rf7.txt:3 was not changed this round. The round diff's only study hunk is @@ -87,5 +87,5 @@, and reland_rf7.py:62 only fills in {N} and {RECEIPT}. The line is word for word what XC4 and ZC2 quoted. It now contradicts the section's own account: line 90 and PLAN.md:327 record three checks through three lenses after the cold read (the final check, the second final check, and 'a third check through the three lenses scoped to the round's changes'), so 'twice more' is wrong. No cross-model re-check of the round that took the third check's points is recorded: REVIEW-ROUND2.md ends at line 1530 with the third check's table, and BRIEF.md ends with the third check's prompts (592-622). So 'after each round of fixes' still claims more than the files show. Yet REVIEW-ROUND2.md:1523 and :1527 mark XC4 and ZC2 as taken, and study:90 lists 'this section's account of the re-checks' as taken. The 'every confirmed finding was taken' statements (study:90, REVIEW-ROUND2.md:1516, PLAN.md:327) therefore do not yet hold. The replacement is accurate: the first re-check followed the cold read (1278); the re-check after the final check ran 'On the same rehearsal' as the second final check (1441); the re-check after the second final check ran 'Alongside' the third check (1516).

## ED2 (exactness-and-sources, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/make_records_rf7.py:342-351, AMEND['what-readings-fix-of-the-unread']['history'], en and zh (appended to RF2's record).

**Quoted.** “and no longer calls telling the occasion apart a necessary condition of what deceptive alignment and alignment faking describe; a law drawing afresh can act otherwise unread without telling read from unread (Hubinger and others' §4.5); no statement or declaration changed.”

**Problem.** The history does not fully describe the field it amends. The landed correspondence (theories/becoming/results/records/what-readings-fix-of-the-unread.json) has no fresh-draw sentence; this amendment adds "a law drawing afresh can act otherwise unread without telling read from unread (Hubinger and others' §4.5)". The history lists what the correspondence now says and no longer says, closes that list with "and no longer calls …", and then gives the fresh-draw clause after a semicolon. It reads as the history's own assertion, not a record that the field gained it. In the previous round the clause was attached by "since", which this rewrite (for XC2) dropped. The zh has the same structure: …之必要条件；每处重抽其行之律…（Hubinger 等 §4.5）；无一陈述或声明改变.

**Replacement.** en: "…, says differing rates, as in alignment faking, are not so bounded, adds that a law drawing afresh can act otherwise unread without telling read from unread (Hubinger and others' §4.5), and no longer calls telling the occasion apart a necessary condition of what deceptive alignment and alignment faking describe; no statement or declaration changed." zh: "…言率之差，如对齐伪装，不受此界；增言每处重抽其行之律不分读与未读亦可于未读处行异（Hubinger 等 §4.5）；不复称分此时为欺骗对齐与对齐伪装所述者之必要条件；无一陈述或声明改变。" tools/research/style.py puts no cap on history.

**Verdict: refuted.** A matter of presentation, not a problem. The finding's facts are right: the landed correspondence in what-readings-fix-of-the-unread.json has no fresh-draw sentence, the amendment adds one (make_records_rf7.py:329-331), and the history gives that clause after a semicolon. But every clause of the history is true, and the fresh-draw clause sits in the history's account of the correspondence, just before 'no statement or declaration changed', in English and Chinese alike. Nothing is false, overstated, dropped or misattributed, and the two languages agree. Nor did this round introduce the feature objected to. The previous round's form ('since a law drawing its act afresh can …') also gave the clause in the history's own words without saying the field gained it. Both of XC2's replacements, confirmed last round, did the same. Writing 'adds that' would be clearer, but it is optional.

## ED3 (exactness-and-sources, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:84-85 (Output → input). The passage is unchanged, but this round's amendment of RF2's correspondence made it wrong.

**Quoted.** “RF2's record (its next step, a scope item, its correspondence's necessary condition and a related”

**Problem.** This round's change introduced the problem. Until this round, the amendment narrowed the correspondence's necessary condition ("for deterministic laws, a necessary condition of what deceptive alignment and alignment faking describe"). The amendment now removes it: the field states the twins' bound and reads it with deceptive alignment, and RF2's new history says the correspondence "no longer calls telling the occasion apart a necessary condition of what deceptive alignment and alignment faking describe". So the study's Output → input names a part RF2's record will not have after landing. A reader will look in RF2's correspondence for a necessary condition RF7 fed into it, and find none.

**Replacement.** "RF2's record (its next step, a scope item, its correspondence's reading of deceptive alignment and alignment faking, and a related record)". The study has no cap.

**Verdict: refuted.** The correspondence keeps a necessary condition, so the label still has something to name. I applied the amendment in memory to the landed JSON (1187/338 characters). It still states the twins' necessary condition: 'can agree on every reading and differ unread only where the lumping tells the occasion from every read one', and 'acts otherwise unread only there'. RF2's home Reading (03-KNOWING.md:479) has the same 'and only there'. The new history says only that the correspondence 'no longer calls telling the occasion apart a necessary condition of what deceptive alignment and alignment faking describe', which concerns the phenomena, not the twins' condition. So 'its correspondence's necessary condition' at study_rf7.txt:84-85 names a part RF2's record keeps after landing, the part RF7's amendment rewrote. A reader looking for it will find it. This round's change does not make the unchanged passage wrong.

## ED4 (exactness-and-sources, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:327 (§13, "The reviews of RF7."), written by kit/round2/integrate_rf7.py:300-301. Both were rewritten this round, the ZC5 phrase "made clearer".

**Quoted.** “the cross-model reader's re-check of how its points were taken (four points still wanting)”

**Problem.** The rewrite makes "its" attach most naturally to "the cross-model reader's". Read that way, the sentence says the reader re-checked how its own points were taken, which is false. REVIEW-ROUND2 ("The re-check after the final check") says it re-checked "how the texts took the final check's 42 confirmed points", and its four residual points concern final-check findings: S1, S2/S4, X4 and X2/Z6. The same sentence then uses "its points" for the reader's own points: "the reader's re-check of that round (one of its points taken only in part)". So two uses of "its points" in one sentence take different antecedents, and only one reading of the first is true.

**Replacement.** "the cross-model reader's re-check of how the final check's points were taken (four points still wanting)", in PLAN.md and in integrate_rf7.py:300-301. The plan has no cap.

**Verdict: refuted.** The finding's facts are right, but the misreading it needs is not the natural one in context. REVIEW-ROUND2.md:1396 confirms that this re-check covered 'how the texts took the final check's 42 confirmed points'. In PLAN.md:327 the clause comes straight after 'a final check through three lenses (42 confirmed, 8 refuted)', in a sequence where each re-check follows the check it re-checks. The sentence has also just said that the reader's own earlier points were 'then all seven taken correctly'. Reading 'its points' as the reader's own would therefore contradict the sentence itself; read as the final check's points, the clause is accurate, and so is '(four points still wanting)'. The later 'one of its points taken only in part' is true whether 'its' means the reader or 'that round', so the two uses need not have different antecedents. Nothing is misattributed: this is the same standard by which ZC5 was refuted. Writing 'the final check's points' would be clearer, but it is optional.

## ED5 (exactness-and-sources, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-ROUND2.md:1516 ("The third check through three lenses", first paragraph, new this round).

**Quoted.** “Its first finding is the re-check's point; its verifier added that alignment faking's differing rates can arise where no unread occasion is told from every read one, so that reading them as a difference of twins does not hold either.”

**Problem.** This misattributes the observation. It is the finding's own, not its verifier's. XC1's Problem paragraph in REVIEW-RF7-CHECK3.md gives the compliance-gap counterexample: "For alignment faking's compliance gap the condition is not necessary even for a deterministic law. Take read occasions (free,q1)↦A …". SC1, the sources lens, makes the same observation from Greenblatt and others' abstract. XC1's verifier "checked the counterexample" and added only that it "bears on that wording too", meaning the live kit's interim "is read as such a difference". As written, XC1 is presented as just the re-check's point, and its new content is credited to the verifier.

**Replacement.** "Its first finding is the re-check's point, with the observation, made also by SC1, that alignment faking's differing rates can arise where no unread occasion is told from every read one; its verifier added that reading them as a difference of twins does not hold either." The evidence file has no cap.

**Verdict: real.** Confirmed misattribution. The observation belongs to the finding itself. XC1's own Problem (REVIEW-RF7-CHECK3.md:21) gives the compliance-gap counterexample: 'For alignment faking's compliance gap the condition is not necessary even for a deterministic law … Yet every unread occasion shares a lump with a read one'. SC1 makes the same observation (line 101: 'Yet no unread occasion is told from every read one'). XC1's verdict (line 31) checked the counterexample and added only that 'The compliance-gap counterexample bears on that wording too', meaning the live kit's interim 'is read as such a difference'. The re-check's point itself (REVIEW-ROUND2.md:1476-1508) says nothing about rates. So REVIEW-ROUND2.md:1516, new this round, understates XC1 as just 'the re-check's point' and credits its observation to the verifier. It also contradicts study_rf7.txt:90, which credits the observation to the third check's finding ('the same point, with the observation that …'). The proposed replacement matches the files.

## ZD1 (zh-and-fit, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:3 (the section's opening paragraph, which XC4 and ZC2 located). The claims that it was taken are at evidence/REVIEW-ROUND2.md:1523 (XC4's Taken cell), :1527 (ZC2's) and :1516 ("Every confirmed finding was taken"), at study_rf7.txt:90 ("and this section's account of the re-checks") and at PLAN.md:327 ("every confirmed finding was taken").

**Quoted.** “then checked twice more through three lenses and re-checked by the cross-model reader after each round of fixes”

**Problem.** Two confirmed points were not taken, although three texts say they were. XC4 and ZC2 (REVIEW-RF7-CHECK3.md, both confirmed) found this exact sentence stronger than the record. Each asked for the re-checks to be named as they ran, and for "after each round of fixes" to stay only if the latest round's re-check is recorded. The round's diff has no hunk at line 3: the study's only hunk is @@ -87,5 +87,5 @@, and a comparison with the before snapshot shows lines 88 and 90 changed and nothing else. Even so, REVIEW-ROUND2.md:1523 says XC4 was taken as "the re-checks named as they ran", :1527 gives ZC2 "as XC4", and study:90 lists "this section's account of the re-checks" among what was taken.

The sentence is now also contradicted by this round's own addition at line 90. After the cold read, the study records three checks through three lenses: the final check, the second final check, and "a third check through the three lenses scoped to the round's changes". So "twice more" is wrong, as ZC2's verdict predicted: "'twice more' will be stale once this check is recorded".

"After each round of fixes" still fails as XC4 found. In the rehearsal, no cross-model re-check is recorded for this round's fixes, the ones taking the third check's nine points and the re-check's point. REVIEW-ROUND2 ends with the third check's table, and BRIEF has no such prompt. XC4's verdict already warned that "'after each round' would still fail for the fixes that took its point unless they too are re-checked". So the two Taken cells, the study's list item, and "every confirmed finding was taken" (PLAN §13; REVIEW-ROUND2:1516) all overstate.

**Replacement.** study_rf7.txt:3: "... and its texts cold-read, by the cross-model reader and through three lenses with each finding verified, then checked three times more through three lenses, the cross-model reader re-checking what was taken after the cold read and after the first two of those checks ([REVIEW-ROUND2]\(development/rf-formations-that-read/evidence/REVIEW-ROUND2.md))." If this round's cross-model re-check and the present check are recorded before landing, extend the sentence to them as recorded. Do not restore "after each round of fixes" unless the last round is also re-checked. With that change, XC4's Taken cell ("the re-checks named as they ran", now including the section's opening) and the study's "this section's account of the re-checks" become true.

**Verdict: real.** Real. Line 3 of study_rf7.txt is byte-identical to the before snapshot (scratchpad/rf7-before5) and still reads "then checked twice more through three lenses and re-checked by the cross-model reader after each round of fixes". The round's only study hunk is @@ -87,5 +87,5 @@, which changes lines 88 and 90 only. reland_rf7.py appends the template as written, replacing only placeholders, so this sentence would land unchanged.

XC4 and ZC2 (REVIEW-RF7-CHECK3.md, both confirmed) located exactly this sentence. Yet three texts say they were taken: REVIEW-ROUND2.md:1523 ("the re-checks named as they ran"), :1527 ("as XC4") and study:90 ("and this section's account of the re-checks"). REVIEW-ROUND2:1516 and PLAN.md:327 say every confirmed finding was taken.

"Twice more" is now false by the study's own account. This round's line 90 records three checks through three lenses after the cold read: the final check, the second final check, and "a third check through the three lenses scoped to the round's changes". ZC2's verdict foresaw this ("'twice more' will be stale once this check is recorded").

"After each round of fixes" also still overstates. REVIEW-ROUND2 ends with the third check's table, and BRIEF ends with the third check's prompt (line 592). No cross-model re-check of the fixes that took the third check's points is recorded, which is the case XC4's verdict warned about.

The proposed replacement matches the record: re-checks after the cold read (1278, continued at 1333), after the final check (1394) and after the second final check (1474). Outside the rehearsal, the cross-model reader's re-check of this round (/private/tmp/claude-501/-Users-ren-theories/50635de9-b91e-4f4c-a63c-8413ce8c4652/scratchpad/rf7-recheck5-astra.md) independently raised the same point.

## ZD2 (zh-and-fit, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:327 (§13, "The reviews of RF7."), written by kit/round2/integrate_rf7.py:300-301; and evidence/REVIEW-ROUND2.md:1530 (ZC5's Taken cell: "made clearer all the same")

**Quoted.** “the cross-model reader's re-check of how its points were taken (four points still wanting)”

**Problem.** This round replaced "what it took" with "how its points were taken" for ZC5, and REVIEW-ROUND2:1530 calls the result clearer. It is not. "Its" follows "the cross-model reader's re-check of how", so it most naturally refers to the cross-model reader. The same sentence's next clause, "then the reader's re-check of that round (one of its points taken only in part)", does use "its" for the reader's own points (REVIEW-ROUND2:1476: "how the texts took its own four points").

Read the same way, the first clause says the reader re-checked how its own points were taken and found four still wanting. In fact that re-check checked "how the texts took the final check's 42 confirmed points" (REVIEW-ROUND2:1396). The reader's own earlier points had already been found "all seven taken correctly", as the same sentence says. So the new wording invites a misattribution of whose points were re-checked, and the Taken cell's "made clearer" is not accurate.

**Replacement.** PLAN.md:327 and integrate_rf7.py:301: "the cross-model reader's re-check of how the final check's points were taken (four points still wanting)". REVIEW-ROUND2.md:1530, ZC5's Taken cell: "made clearer all the same: “re-check of how the final check's points were taken”".

**Verdict: refuted.** Not real: a matter of clarity, with nothing false. PLAN.md:327 does now read "the cross-model reader's re-check of how its points were taken (four points still wanting)". But "its" has natural readings that are accurate.

One is the final check named just before ("42 confirmed, 8 refuted"). Its points are what that re-check checked (REVIEW-ROUND2:1396; BRIEF:541-548, "Check that each confirmed point is taken correctly").

Another is `Becoming.ReadStages`, the sentence's subject, which the same sentence already calls "its texts". ZC5's verdict read the old "it" this way.

The reading as the reader's own points is ruled out by the sentence itself. It has just said of the reader's points "then all seven taken correctly", so the four still wanting cannot be its own. In the next clause, "one of its points taken only in part" can mean the reader's or that round's, and both are true.

The change removed what ZC5 objected to, an agent of the taking ("what it took"), and now states the result ("still wanting"). So the Taken cell's "made clearer" is a fair description. What remains is a loose pronoun, which ZC5's verdict judged not a misattribution. "How the final check's points were taken" is clearer and harmless, but optional.

## ZD3 (zh-and-fit, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-ROUND2.md:1516 (opening paragraph of "The third check through three lenses", added this round)

**Quoted.** “Its first finding is the re-check's point; its verifier added that alignment faking's differing rates can arise where no unread occasion is told from every read one, so that reading them as a difference of twins does not hold either.”

**Problem.** This misattributes the observation. It comes from the findings themselves, not from the verifier. XC1's own Problem (REVIEW-RF7-CHECK3.md, XC1) gives the compliance-gap counterexample: "For alignment faking's compliance gap the condition is not necessary even for a deterministic law. Take read occasions (free,q1)↦A ... Yet every unread occasion shares a lump with a read one". SC1's Problem gives a second one independently: "Yet no unread occasion is told from every read one".

XC1's verifier only checked it ("I checked the counterexample"). It then added that the counterexample "bears on that wording too", meaning the then-taken "is read as such a difference". That is the "so that ... does not hold either" part. The study (line 90) credits the observation correctly to the third check, so this paragraph and the study also disagree on who found it.

**Replacement.** "Its first finding is the re-check's point, with a counterexample, as SC1 gave too: alignment faking's differing rates can arise where no unread occasion is told from every read one; its verifier checked it and added that reading those rates as a difference of twins does not hold either."

**Verdict: real.** Real, low severity. REVIEW-ROUND2.md:1516 was added this round. It says "Its first finding is the re-check's point; its verifier added that alignment faking's differing rates can arise where no unread occasion is told from every read one".

REVIEW-RF7-CHECK3.md reproduces the findings verbatim (its preamble says so, and its generator only rewrites paths). There, the observation is the finding's own:
- XC1's Problem: "For alignment faking's compliance gap the condition is not necessary even for a deterministic law ... Yet every unread occasion shares a lump with a read one, and `lumped_determines` fixes its act from the readings".
- SC1's Problem, independently: "Yet no unread occasion is told from every read one".

XC1's verifier only says "I checked the counterexample". Its addition is that the counterexample "bears on that wording too", meaning the live kit's interim "is read as such a difference". That is the paragraph's "so that ... does not hold either".

The same new section contradicts the paragraph. Its table's XC1 row puts "a compliance gap can arise without it" in the Finding column. Study:90 also attaches the observation to the third check's point ("the same point, with the observation that ...").

The proposed replacement matches the files: SC1 gave a counterexample too, and the verifier checked it and added the bearing on reading the rates as a difference of twins. An evidence file has no cap.

## ZD4 (zh-and-fit, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2/study_rf7.txt:84 (Output → input). The line itself is unchanged, but this round's rewrite of RF2's correspondence (make_records_rf7.py:324-332) made it stale. Also evidence/REVIEW-ROUND2.md:1512 ("the history and the study likewise")

**Quoted.** “RF2's record (its next step, a scope item, its correspondence's necessary condition and a related”

**Problem.** After this round, RF2's amended correspondence states no necessary condition. It says two laws reading through one lumping can agree on every reading and differ unread only where the lumping tells the occasion apart. It reads that with deceptive alignment, and it says differing rates are not so bounded. RF2's history now says it "no longer calls telling the occasion apart a necessary condition of what deceptive alignment and alignment faking describe".

The study's Output → input still names "its correspondence's necessary condition" as what RF7 feeds into, a part RF2's record no longer has once RF7 lands. The cross-model re-check's point asked that "The same correction must reach the accounts of this amendment". REVIEW-ROUND2:1512 says it did ("the history and the study likewise"), but this account was missed.

**Replacement.** "RF2's record (its next step, a scope item, its correspondence's reading with deceptive alignment and alignment faking, and a related record)"

**Verdict: refuted.** Not real. study_rf7.txt:84 is unchanged this round, and the round's change does not make it false.

Output → input names the parts of RF2's landed record that RF7 changes. RF2's landed correspondence (theories/becoming/results/records/what-readings-fix-of-the-unread.json) reads "only where the formation's lumping tells the occasion from every read one: a necessary condition of what deceptive alignment and alignment faking describe", and AMEND replaces exactly that clause. So "its correspondence's necessary condition" names the part that changes, as "its next step" names a part whose content also changes.

The finding's premise is also false: the amended correspondence still states a necessary condition. "Two laws reading through one lumping can agree on every reading and differ unread only where the lumping tells the occasion from every read one" is one, for the twins, by Learning.lumped_determines. The history says only that the correspondence "no longer calls telling the occasion apart a necessary condition of what deceptive alignment and alignment faking describe", not that it states none.

The cross-model re-check's point (REVIEW-ROUND2:1498) named the accounts to correct: history:345, study:90 and the Taken row at 1434. All three now give the final form, so "the history and the study likewise" (1512) is accurate. The proposed wording is an alternative description, a matter of taste.
