# Third review pass: A-10b, A-10c, A-19 and the page's results 8 and 9
Summary: 46 findings (12 errors, 25 imprecisions, 9 style).

This was read-only: no file was edited, no Lean was built, and no model or network call was made. Paths in the Source lines are relative to /Users/ren/theories/. Records are in theories/becoming/results/records/, the Lean is in experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/, and "the kit" is _process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/.

## Findings

### F1 [error] ALIGNMENT.md, A-10c, Known weaknesses, last bullet (line 402)
- As it stands: "- Where it was tested on a trained system, it did not apply. Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "the one frozen test of the timing law on one (LA2, experiments/self-rewarding-lock) found one note in nine turned it, so the law did not apply there.""
- Source: loss-read-in-time-by-the-others.md:39, under "Does not show": "That a trained judge reads as such a pool: the one frozen test of the timing law on one (LA2, …)". experiments/self-rewarding-lock/README.md:3: "The predictions come from closed capture and MA2 (`Becoming.ClosedCapture`)". LA2 was frozen at `36c8b79cb` (25 October, 21:43 +08) and ran until 00:05 on 26 October; MA4b landed at `8ab22de82` (26 October, 04:42). ma4b-read-in-time/REVIEW-MA4b.md:278 says a record may not claim "that condition 2 holds or fails for actual rules or for a trained judge".
- Why: This item's law has never been tested. LA2 was frozen and run before the law existed, in a loop with no shaping, and it tested A-09's timing law. The record lists LA2 under what is not shown about the pool premise; this bullet turns that into a failed test of A-10c.
- Fix: replace "- Where it was tested on a trained system, it did not apply. Quote [" with "- It has not been tested on a trained system. LA2, frozen and run before it landed, tested A-09's timing law in a loop without shaping, and found the one judge tested not a pool counted by kind, which is this item's premise too: Quote ["
  (also in: DRAFT-ONE-PAGE.md, result 9, Not shown (line 69). There "the timing law" is ambiguous rather than false: replace "LA2 found that the timing law did not apply to the one trained judge tested." with "LA2, frozen and run before this result landed, tested result 6's timing law: the one trained judge tested was not a pool counted by kind, the premise of both results.")

### F2 [error] ALIGNMENT.md, A-19, LA2, "What held" (line 585): the in-time pass came from the counts alone
- As it stands: "Read by every reader, the loss turned the course and kept it turned." The LA2 bullets end here and say nothing of `in_time`.
- Source: experiments/self-rewarding-lock/README.md:33, the control row: "kept in 1, turned in 4". README.md:45: "supported: *`in_time` turned by the readers' counts alone, the loss not needed*. … The control alone turned in 4 of 5 seeds with nothing reading the loss". README.md:46: "not supported: *the loss read in time turned a course that would otherwise be kept*". PREDICTIONS-2026-10-25.md:139: "L4 then supports MA2's agreement law for this judge, but not a turn by the loss."
- Why: The texts give LA2's verdicts as all passed, with the bridge and the tie as the only limits. By the frozen support rules, though, `in_time` turned by the counts alone, and the loss read in time is not shown to have turned anything. Leaving this out makes the in-time half of A-09's timing law read as supported in this system, which is above the run's strength. 02's T7 paragraph and 08's T7 row leave it out too, but they are outside these texts.
- Fix: replace "Read by every reader, the loss turned the course and kept it turned." with:
```
Read by every reader, the loss turned the course and kept it turned.
  - **Read in time, the counts alone turned it.** `in_time` turned in 5 of 5 seeds, but its control, with nothing reading the loss, turned in 4 of 5: Quote [experiments/self-rewarding-lock/README.md]: "The control alone turned in 4 of 5 seeds with nothing reading the loss". So by the frozen rules Quote [experiments/self-rewarding-lock/README.md]: "*the loss read in time turned a course that would otherwise be kept*" is not supported.
```
  (also in: DRAFT-ONE-PAGE.md, LA2 (line 119): replace "Read by every reader, it turned the course for good." with:
```
Read by every reader, it turned the course for good.
  - Read in time by the readers the selection thins, the loss turned the course, but with nothing reading it the counts alone turned it in 4 of 5 seeds, so the loss is not shown to have turned a course that would otherwise be kept.
```
  07-SIGNIFICANCE.md, Tests (line 545): replace "and read by every reader the loss turned it for good." with "and read by every reader the loss turned it for good. Read in time by the readers the selection thins, the loss turned the course, but with nothing reading it the counts alone turned it in 4 of 5 seeds, so the loss is not shown to have turned it.")

### F3 [error] ALIGNMENT.md, A-19, LA2, "A pass by a tie" (line 583)
- As it stands: "- **A pass by a tie.** The late condition's seeds count as kept, but its course did not lock:"
- Source: experiments/self-rewarding-lock/README.md:17: "L3 and L4 pass by the same tie." PREDICTIONS-2026-10-25.md:121–122: L3, "who reads decides", is "`late` kept and `read_all` turned"; L4, "when it is read decides", is "`in_time` turned and `late` kept".
- Why: L3 and L4 are the two contrasts that test A-09's laws in this system, and both depend on `late` being kept, so both pass only by the tie. With the tie reported only for `late`, they read as clean passes, which is above strength.
- Fix: replace "- **A pass by a tie.** The late condition's seeds count as kept, but its course did not lock:" with "- **A pass by a tie.** The late condition's seeds count as kept, and Quote [experiments/self-rewarding-lock/README.md]: "L3 and L4 pass by the same tie." But its course did not lock:"
  (also in: DRAFT-ONE-PAGE.md, LA2; see F4.)

### F4 [error] DRAFT-ONE-PAGE.md, LA2, second bullet (line 118)
- As it stands: "- One verdict passed only by a tie. Read late by the readers the selection thins, the course alternated as the selection removed them, and its end share equalled its starting one exactly."
- Source: experiments/self-rewarding-lock/README.md:14: "its share at step 8 equalled its share at step 4 exactly". README.md:17: "L3 and L4 pass by the same tie." results/runs.json, `late`, every seed: the share is 1/9 at step 0, 32/33 at steps 4, 6 and 8, and 32/43 at steps 5 and 7.
- Why: The end share, 32/33, equals step 4's, not the starting share of 1/9, so the clause is false. Three passes rest on the tie, not one.
- Fix: replace with "- One verdict, and the two contrasts that rest on it (who reads decides, when it is read decides), passed only by a tie. Read late by the readers the selection thins, the course alternated as the selection removed them, and its share at step 8 equalled its share at step 4, the step the verdict compares it with, exactly."

### F5 [error] ALIGNMENT.md, A-10, Known weaknesses, last bullet (line 304), and A-19, Question 4 (line 607)
- As it stands: "- In LA3's run (A-19), the one trained system tested ended on the better-scored policy wherever it had played both, but a free-rider reading before any score kept it from trying shaping in 9 of 30 seeds, and two contrasts failed. Its predictions file reads this as Quote [experiments/shaping-what-comes-back/PREDICTIONS-2026-10-25.md]: "The law stands, but its reading for trained systems is not supported by this case."" Question 4 has: "and that reading decided the seeds in which it never tried shaping."
- Source: experiments/shaping-what-comes-back/README.md:49: "It was tried in all five seeds of `s2p3` but in two of five of `s2p0` and three of five of `m2n1_p5`. The run does not say why." README.md:47: "Every one of the 30 round-0 answers speaks of free riding". results/run-2026-10-25.log: 27 seeds began with N and 9 never played S. So 18 seeds that began without shaping, under the same framing, tried it later.
- Why: Every round-0 answer gave the free-rider framing, including the 18 seeds that went on to try shaping, so the framing does not tell apart the 9 that never tried, and the README says the run does not say why. Naming it as the cause states a post hoc reading as the run's result.
- Fix: replace the whole bullet quoted above with "- In LA3's run (A-19), two of the four frozen contrasts failed, every seed that missed having never tried shaping where it scores higher. In 9 of 30 seeds it never tried shaping, and Quote [experiments/shaping-what-comes-back/README.md]: "The run does not say why." Post hoc, the one trained system tested ended on the better-scored policy in all 21 seeds that played both. For K4 failing with the bridge low, its predictions file reads Quote [experiments/shaping-what-comes-back/PREDICTIONS-2026-10-25.md]: "The law stands, but its reading for trained systems is not supported by this case." K2 is not named there; the README reads its failure as of the same kind." In Question 4, replace "and that reading decided the seeds in which it never tried shaping." with "and in 9 seeds it never tried shaping; the run does not say why, since 18 of the 27 seeds that began without shaping tried it later."
  (also in: 07-SIGNIFICANCE.md, Tests (line 545), where "So" makes the prior the cause: replace "and in 9 it never tried shaping. So two of the four contrasts failed, each at a condition where shaping scores higher:" with "and in 9 it never tried shaping, which the run does not explain, since 18 seeds that began the same way tried it later. Two of the four contrasts failed, every seed that missed having never tried shaping where it scores higher:")

### F6 [error] DRAFT-ONE-PAGE.md, result 8, headline (line 53)
- As it stands: "8. **Where the rule's readers are drawn from those it selects, the capacity to shape the rule and the lock are one loop**"
- Source: DrawnShaping.lean:374: `drawn_locked_either … (step : lo ≤ hi)`. DrawnShaping.lean:539–547, `Against.not_locked`: "Read against the share, a start favouring the shapers is not locked" (with hi = 0, lo = 3). shaping-read-by-readers-drawn-from-the-selected.md:8: "Where a rule's readers come from those it selects and its shapers read at least as much coming back to them as others do, the rule's lock and the capacity to shape it are one loop".
- Why: The headline makes readers drawn from the selected enough for the loop, and without lo ≤ hi `Against.not_locked` refutes that. The body states the hypothesis, but the headline is the line people will quote.
- Fix: replace with "8. **Where the rule's readers are drawn from those it selects and the shapers among them read at least as much coming back to the shapers as the others do, the capacity to shape the rule and the lock are one loop**"
  (also in:
  - "What gets out of a lock" (line 90): replace "since every course read from the share alone is locked one way or the other." with "since with lo ≤ hi every course read from the share alone, from a start under the rule read there, is locked one way or the other."
  - "Instrumental convergence, located" (line 91): replace "Result 8 makes them one loop where the rule's readers are drawn from those it selects: above a critical mass, the capacity to shape the rule is selected and the rule locks for it." with "Result 8 makes them one loop where the rule's readers are drawn from those it selects and the shapers among them read at least as much coming back to the shapers as the others do: in courses without noise, with shapers present, above a critical mass the capacity to shape the rule is selected and the rule locks for it.")

### F7 [error] DRAFT-ONE-PAGE.md, What keeps control from being selected, last bullet (line 89)
- As it stands: "- From result 8: where the rule's readers are drawn from those it selects, control falls below the critical mass, even where the shapers among the readers read more coming back than shaping costs (`CriticalMass.few_falls`)."
- Source: DrawnShaping.lean:447: `drawn_falls (step : lo ≤ hi) … (strict : …) (some : 0 < x.carrier)`. DrawnShaping.lean:520: `CriticalMass.few_falls` is the witness from one shaper to three others. shaping-read-by-readers-drawn-from-the-selected.md:29: "here the shapers' where lo < c < hi and 2c < hi + lo, as in the witness; the critical mass bounds courses without noise only."
- Why: The bullet states a law but cites only the witness, and it drops lo ≤ hi and the requirement that shapers be present. As a line on what keeps control from being selected it also leaves out the noise bound: under rare mutation, the witness's own numbers (c = 1, hi = 3, lo = 0) make the shapers' state the long-run one.
- Fix: replace with "- From result 8: where the rule's readers are drawn from those it selects, with lo ≤ hi and shapers present, control falls below the critical mass, even where the shapers among the readers read more coming back than shaping costs (`drawn_falls`; the witness `CriticalMass.few_falls`). This holds of courses without noise: under rare mutation the long-run state is the shapers' where lo < c < hi and 2c < hi + lo, as in the witness."

### F8 [error] ALIGNMENT.md, A-10c, Known weaknesses, second bullet (line 399)
- As it stands: "Of Collingridge's dilemma (1980), Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "Here the second is a theorem"
- Source: ALIGNMENT.md:28: "Works cited outside quotations were checked against a publication record (`[the kit](…)`)". The kit's README.md:12–39, its references table, has no Collingridge. loss-read-in-time-by-the-others.md:70: "Collingridge's dilemma (1980) has two horns: while change is easy its need cannot be known, and once it is known change is hard. Here the second is a theorem".
- Why: By the dossier's own convention, a work it names outside a quotation has been checked, and this one has not. The quote also starts at "the second", so the horns it numbers are never stated.
- Fix: replace "Of Collingridge's dilemma (1980), Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "Here the second is a theorem" with "Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "Collingridge's dilemma (1980) has two horns: while change is easy its need cannot be known, and once it is known change is hard. Here the second is a theorem"
  (also in: DRAFT-ONE-PAGE.md, Closest work, result 9 (line 149). That list is marked unchecked, so there it is a matter of clarity only: replace "Collingridge (1980), whose second horn is a theorem here and whose first is a premise, the loss read only from a bound;" with "Collingridge (1980), whose dilemma is that while change is easy its need cannot be known and once it is known change is hard: the second horn is a theorem here and the first a premise, the loss read only from a bound;")

### F9 [error] ALIGNMENT.md, A-10b, Known weaknesses, third bullet (line 343)
- As it stands: "Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "Where lo < c < hi the model is the stag hunt in which the second strategy's payoff does not depend on the partner"."
- Source: shaping-read-by-readers-drawn-from-the-selected.md:55: "risk dominance compares hi + lo with 2c (Harsanyi and Selten 1988; Skyrms 2004)"; "reading at every step is discrete-time replicator selection up to a lag of one step (Hofbauer and Sigmund 1998)"; "the greenbeard (Gardner and West 2010; only the bibliographic record verified)".
- Why: The bullet gives the record's known forms but drops three of its credits, and none of them appears anywhere else in the dossier. For alignment readers, replicator dynamics is the closest known form of the loop.
- Fix: replace "the stag hunt in which the second strategy's payoff does not depend on the partner"." with "the stag hunt in which the second strategy's payoff does not depend on the partner". Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "The critical mass is its mixed equilibrium, at the shapers' share (c − lo)/(hi − lo), and risk dominance compares hi + lo with 2c (Harsanyi and Selten 1988; Skyrms 2004)." Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "reading at every step is discrete-time replicator selection up to a lag of one step (Hofbauer and Sigmund 1998)." Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "A biological comparator for readers favouring their own kind is the greenbeard (Gardner and West 2010; only the bibliographic record verified).""
  (also in: DRAFT-ONE-PAGE.md, Closest work, result 8 (line 148), which lacks the replicator form, Schelling 1973, the source of the term and the greenbeard: replace "critical mass and thresholds (Schelling 1978; Granovetter 1978);" with "discrete-time replicator selection, here with a lag of one step (Hofbauer and Sigmund 1998); critical mass and thresholds (Schelling 1973; Schelling 1978; Granovetter 1978; Oliver, Marwell and Teixeira 1985, for the term); readers favouring their own kind, the greenbeard (Gardner and West 2010);")

### F10 [error] ALIGNMENT.md, A-10c, Known weaknesses, fourth bullet (line 401)
- As it stands: "- Elementary, and known in form. Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "Biggs, Carpenter and Brock (2009) give the continuous analogue of the window: the window for averting a regime shift ends abruptly.""
- Source: loss-read-in-time-by-the-others.md:70: "The lock is the lock-in of increasing returns and path dependence (David 1985; Arthur 1989; Cowan 1991), and the threshold the tipping point of Schelling (1978) and Granovetter (1978). The lag is the representation's, …; compare replicator selection with a delay (Alboszta and Miękisz 2004)."
- Why: The bullet keeps Biggs and drops the rest of the record's credits. Path dependence (David, Cowan) and replicator selection with a delay (Alboszta and Miękisz) appear nowhere in the dossier.
- Fix: replace "the window for averting a regime shift ends abruptly."" with "the window for averting a regime shift ends abruptly." Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "The lock is the lock-in of increasing returns and path dependence (David 1985; Arthur 1989; Cowan 1991), and the threshold the tipping point of Schelling (1978) and Granovetter (1978)." Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "The lag is the representation's, a rule read at a step being in force from the next; compare replicator selection with a delay (Alboszta and Miękisz 2004).""

### F11 [error] ALIGNMENT.md, A-19, Known weaknesses, third bullet (line 599)
- As it stands: "- [this dossier, AI] LA2's judge answered 112 of its 119 calls with all ten picks for one format. The power check's scripted judges varied their picks from call to call, so it did not foresee an exact return of the share."
- Source: ALIGNMENT.md:27: "One marked [this dossier, AI] is this dossier's own assessment, recorded nowhere else". experiments/self-rewarding-lock/README.md:16: "The power check's scripted judges vary their picks from call to call, which made an exact return improbable, but this judge answered 112 of its 119 calls all one way."
- Why: The label claims for the dossier a weakness that the README itself reports among its failures. That credits the wrong text and makes the README look less candid than it is. "Did not foresee" is also stronger than "made … improbable".
- Fix: replace with "- For LA2, Quote [experiments/self-rewarding-lock/README.md]: "The power check's scripted judges vary their picks from call to call, which made an exact return improbable, but this judge answered 112 of its 119 calls all one way.""

### F12 [error] DRAFT-ONE-PAGE.md, standing note (line 3): D68's scope
- As it stands: "Chapter 7 states the readings below as decision D68."
- Source: DELEGATED-CHOICES.md:107 dates D68 to 24 October. It covers four readings: assistance that lowers the cost of shaping, an assistant joined to its principal, a counter-rule, and rule-making with shared returns (07-SIGNIFICANCE.md:537–543). The readings from results 8 and 9 are chapter 2's, labelled [AI reading, D45] (02-MAP.md:422 and the reading after it). The page's own line 75 limits D68 to those four.
- Why: The readings from results 8 and 9 are not in D68, so a reader who looks for them there will not find them.
- Fix: replace with "Chapter 7 states the four readings on assistance, obedience, counter-rules and shared rule-making as decision D68; those from results 8 and 9 are chapter 2's readings (D45)."

### F13 [imprecision] ALIGNMENT.md, A-10c, Known weaknesses, first bullet (line 398): "the converse"
- As it stands: "- The two conditions are not shown independent. Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "here a lock is left in time where control is selected, not the converse.""
- Source: ma4b-read-in-time/REVIEW-MA4b.md:282: "the model shows condition 2 without condition 1, not condition 1 together with a capture-like lock that is not left". REVIEW-MA4b.md:284: "There the course is locked the other way (MA4), which is not a capture." The MA4 record (shaping-read-by-readers-drawn-from-the-selected.md:28) uses "the converse" for the opposite case: "control not selected does not by itself give a lock left in time, and the converse cannot be shown here".
- Why: The two records use "the converse" for opposite cases, and no text names the missing case. A reader sees result 8 (control not selected, course locked) and result 9 (a lock left where control is selected), takes the pair as independence, and then reads that independence is not shown. The missing case is control not selected together with a capture by the shapers that is not left; below the critical mass the lock belongs to the others, which is no capture.
- Fix: replace "here a lock is left in time where control is selected, not the converse."" with "here a lock is left in time where control is selected, not the converse." The converse not shown is control left unselected together with a capture by the shapers that is not left: below A-10b's critical mass the course is locked the other way, which is no capture by them."
  (also in:
  - ALIGNMENT.md, A-10b, Known weaknesses, first bullet (line 341): replace "- Control over the selection left unselected does not leave the lock." with "- Control over the selection left unselected does not leave the lock: below the critical mass the course stays locked the other way, which is no capture by the shapers." Then replace "That join is A-10c." with "That join is A-10c, which shows that converse, a lock left in time where control is selected."
  - DRAFT-ONE-PAGE.md, result 8 (line 59): replace "Below the critical mass control is not selected, yet the course is locked." with "Below the critical mass control is not selected, yet the course is locked the other way, which is no capture by the shapers."
  - DRAFT-ONE-PAGE.md, result 9 (line 68): replace "The converse is not shown, so keeping control from being selected and leaving a lock are not shown to be independent." with "Not shown is control kept from being selected together with a capture by the shapers that is not left, so keeping control from being selected and leaving a lock are not shown to be independent."
  - 07-SIGNIFICANCE.md, Read in time (line 535): replace "The converse is not shown, so keeping control from being selected and leaving a lock in time are not shown to be independent." with "Not shown is control kept from being selected together with a capture by the shapers that is not left (below the critical mass the lock is the other way), so keeping control from being selected and leaving a lock in time are not shown to be independent."
  - The records' owner should make the word mean one thing in both records.)

### F14 [imprecision] ALIGNMENT.md, A-19, LA2, second bullet (line 579)
- As it stands: "- It tests T7 (A-08, A-09) through its bridge: Quote [experiments/self-rewarding-lock/PREDICTIONS-2026-10-25.md]: "H1-LA2 is T7's conjecture for this system, and the verdicts are its test.""
- Source: experiments/self-rewarding-lock/README.md:7: "H1-LA2 says that the judge's reading is a pool of the readers it shows, counted by kind." README.md:19: "No frozen verdict failed". README.md:12: "H1-LA2 as stated fails for this judge".
- Why: The bridge itself is never stated, and the quote says the verdicts test it. In the run every verdict passed while the bridge failed, so the verdicts did not decide it, and the text does not say so.
- Fix: replace with "- It tests T7 (A-08, A-09) through its bridge, H1-LA2: Quote [experiments/self-rewarding-lock/README.md]: "H1-LA2 says that the judge's reading is a pool of the readers it shows, counted by kind." The predictions file adds Quote [experiments/self-rewarding-lock/PREDICTIONS-2026-10-25.md]: "H1-LA2 is T7's conjecture for this system, and the verdicts are its test." In the run every verdict passed and H1-LA2 failed, so the verdicts did not decide it (below)."

### F15 [imprecision] ALIGNMENT.md, A-19, LA2, "The bridge failed" (line 582)
- As it stands: "T7's third forbidden case occurs in this system, and MA2's timing law does not apply to it.""
- Source: experiments/self-rewarding-lock/README.md:47: "not supported: *a single reading turned the lock (the third forbidden case of T7)*. Its rule needs `late` to fail, and the rest of it holds". See also README.md:18. PREDICTIONS-2026-10-25.md:97: that rival "predicts `late` turned".
- Why: "Occurs" is the README's reading of the frozen one-note measure. The frozen support rule for this case printed "not supported", because it needs `late` to fail and `late` passed by the tie. A-19's Standing, quoting 08 ("so 02's third forbidden case occurs"), rests on the same reading.
- Fix: replace "T7's third forbidden case occurs in this system, and MA2's timing law does not apply to it."" with "T7's third forbidden case occurs in this system, and MA2's timing law does not apply to it." The frozen support rule for that case printed it as not supported, since it needs `late` to fail and `late` passed by the tie below; "occurs" is the README's reading of the frozen one-note measure."

### F16 [imprecision] ALIGNMENT.md, A-19, LA2, fifth and sixth bullets (lines 584–585)
- As it stands: "- Read as a rule of the share, the judge's late reading is a threshold reading, and its course is the one A-07's witness shows:" and "- **What held.** Quote ["
- Source: experiments/self-rewarding-lock/README.md:56: "## Post hoc (the AI's reading, not frozen)". That section holds the threshold reading (:75) and the step-by-step locks (:73, :78), and README.md:28 calls the step-by-step column post hoc. README.md:76: "There the threshold is at an even share and the rules are four to one each way."
- Why: Both bullets set post hoc readings next to the frozen verdicts without saying so, although A-19 does label LA3's post hoc readings. The judge's course alternates as the witness's does, but it is not the same course: its threshold is at 17/18, and the witness's is at an even share.
- Fix: replace "- Read as a rule of the share, the judge's late reading is a threshold reading, and its course is the one A-07's witness shows:" with "- Post hoc, as the README's reading: read as a rule of the share, the judge's late reading is a threshold reading, at 17/18, and its course alternates as in A-07's witness, whose threshold is at an even share:" Then replace "- **What held.** Quote [" with "- **What held** (post hoc, step by step; the frozen rules read the end only). Quote ["
  (also in: 07-SIGNIFICANCE.md, Tests (line 545): replace "as a threshold reading read one step late does (`RuleCapture.Alternating.never_locked`)" with "as a threshold reading read one step late does (`RuleCapture.Alternating.never_locked`; a post hoc reading)")

### F17 [imprecision] ALIGNMENT.md, A-10, Known weaknesses, last bullet (line 304): post hoc result first, unlabelled
- As it stands: "the one trained system tested ended on the better-scored policy wherever it had played both,"
- Source: experiments/shaping-what-comes-back/README.md:43: "## Post hoc (the AI's reading, not frozen)", and :48. README.md:7 gives the failures first.
- Why: The 21 of 21 is post hoc, and it opens the bullet without a label, ahead of the frozen failures.
- Fix: F5's replacement of the bullet takes care of this.
  (also in: 07-SIGNIFICANCE.md, Tests (line 545): replace "In every seed that had played both policies it ended on the better scored, 21 of 21, and the Split pair passed:" with "Post hoc, in every seed that had played both policies it ended on the better scored, 21 of 21; by the frozen rules the Split pair passed:")

### F18 [imprecision] ALIGNMENT.md, A-19, LA3, "The bridge" (line 591)
- As it stands: "- **The bridge.** By the frozen rules it is low in both failed conditions, and Quote [experiments/shaping-what-comes-back/PREDICTIONS-2026-10-25.md]: "The law stands, but its reading for trained systems is not supported by this case.""
- Source: experiments/shaping-what-comes-back/README.md:9: "H1-LA3 is low in both failed conditions, and in `m2n1_p0`, which passed." README.md:10: "The predictions file reads this outcome for K4 … K2 is not named there". README.md:11: "Neither frozen rival fits either."
- Why: The "and" stretches the frozen reading over both failures and ties the bridge's low value to them. In fact the frozen reading names K4 only, and the bridge is also low in `m2n1_p0`, which passed. The bullet also leaves out that neither frozen rival fits.
- Fix: replace with "- **The bridge.** By the frozen rules it is low in both failed conditions, and in `m2n1_p0`, which passed. For K4 failing with it low, the predictions file reads Quote [experiments/shaping-what-comes-back/PREDICTIONS-2026-10-25.md]: "The law stands, but its reading for trained systems is not supported by this case." K2 is not named there; the README reads its failure as of the same kind, and Quote [experiments/shaping-what-comes-back/README.md]: "Neither frozen rival fits either.""
  (also in: A-10's last bullet, taken care of in F5. DRAFT-ONE-PAGE.md, LA3 (line 121): replace "By the frozen reading, the law stands and its reading for trained systems is not supported by this case." with "By the frozen reading of K4's failure with the bridge low, the law stands and its reading for trained systems is not supported by this case; the README reads K2's failure the same way.")

### F19 [imprecision] ALIGNMENT.md, A-19, Standing and use (line 594)
- As it stands: "LA3 failed two of its four contrasts, each where the agent never tried shaping,"
- Source: experiments/shaping-what-comes-back/README.md:7–8: the heading "each where the agent never tried shaping", and then "Every seed that missed the prediction never played S". The table (:26, :29): `s2p0` N N S N S; `m2n1_p5` S S N N S.
- Why: In the two failed conditions, 2 and 3 of the 5 seeds did shape; the failures are the seeds that never tried it. The README's heading, copied here, reads as if no seed in those conditions shaped.
- Fix: replace with "LA3 failed two of its four contrasts, every seed that missed having never tried shaping,"
  (also in: DRAFT-ONE-PAGE.md, LA3 (line 121): replace "Two failed, each where the model never tried shaping although shaping scores higher." with "Two failed: in each, every seed that missed never tried shaping, although shaping scores higher." For 07, see F5.)

### F20 [imprecision] ALIGNMENT.md, A-19, Known weaknesses, last bullet (line 601)
- As it stands: "- [this dossier, AI] Both run on one small model, called through a command-line interface, at small scale, and each reads in context: formation by training is untested."
- Source: experiments/self-rewarding-lock/README.md:21: "The judge is a single model reading a reference set in context; formation by training is untested." experiments/shaping-what-comes-back/README.md:13: "Training by gradient, other models and other framings are untested."
- Why: Both READMEs already record in-context reading and untested training. So "recorded nowhere else" holds only for "small model", "command-line interface" and "small scale".
- Fix: replace with "- Both run on one model reading in context: Quote [experiments/self-rewarding-lock/README.md]: "The judge is a single model reading a reference set in context; formation by training is untested." Quote [experiments/shaping-what-comes-back/README.md]: "Training by gradient, other models and other framings are untested." [this dossier, AI] The model is a small one, called through a command-line interface, at small scale."

### F21 [imprecision] ALIGNMENT.md, A-19, Known weaknesses (line 600): LA3's power-check limit is missing
- As it stands: "- For LA3, the frozen bridge counts in one measure". The bullets give LA2's power-check gap but not LA3's.
- Source: experiments/shaping-what-comes-back/README.md:15: "The power check's scripted followers began at random and, while only one policy had been played, tried the other at each round with probability one or one half. This agent began with N in 27 of 30 seeds and never tried the other policy in 9."
- Why: The README lists this limit up front, among its failures and limits. It is the limit that explains why the frozen rules did not foresee seeds that never explore.
- Fix: replace "- For LA3, the frozen bridge counts in one measure" with:
```
- For LA3, Quote [experiments/shaping-what-comes-back/README.md]: "The power check's scripted followers began at random and, while only one policy had been played, tried the other at each round with probability one or one half. This agent began with N in 27 of 30 seeds and never tried the other policy in 9."
- For LA3, the frozen bridge counts in one measure
```

### F22 [imprecision] ALIGNMENT.md, A-19, Standing and use (line 594): LA2 is not T7's field test
- As it stands: "LA2's frozen verdicts all passed, and its bridge, T7's conjecture for this system, failed on who reads."
- Source: theories/becoming/chapters/02-MAP.md:414, T7's frozen test: "It is not the field test of reform events above, which stays open."
- Why: A-19 says LA2 "tests T7", and without 02's line a reader can take it for T7's test. T7's refutation clause calls for a field test of a metric's reform, and that test is still open.
- Fix: replace "failed on who reads." with "failed on who reads. It is not T7's field test of reform events, which chapter 2 gives as still open."
  (also in: DRAFT-ONE-PAGE.md, LA2 (line 116): replace "Frozen before it ran; 121 calls." with "Frozen before it ran; 121 calls. It is not T7's field test of reform events, which stays open.")

### F23 [imprecision] ALIGNMENT.md, A-10b, Standing and use (line 338): the record's summary is cut before its condition
- As it stands: "Its record: Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "the rule's lock and the capacity to shape it are one loop:"
- Source: shaping-read-by-readers-drawn-from-the-selected.md:8: "Where a rule's readers come from those it selects and its shapers read at least as much coming back to them as others do, the rule's lock and the capacity to shape it are one loop: …". loss-read-in-time-by-the-others.md:8: "Where a rule's readers come from those it selects and the others among them read a loss late, a reading while their late reading a step on still favours them turns the course; …".
- Why: Both standings start the record's summary after its condition. A-10b's quote then reads as the loop without lo ≤ hi, and in A-10c's, "their" and "them" (the others) have no antecedent.
- Fix: replace "Its record: Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "the rule's lock" with "Its record: Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "Where a rule's readers come from those it selects and its shapers read at least as much coming back to them as others do, the rule's lock"
  (also in: A-10c, Standing and use (line 395): replace "Its record: Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "a reading while" with "Its record: Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "Where a rule's readers come from those it selects and the others among them read a loss late, a reading while")

### F24 [imprecision] ALIGNMENT.md, A-10b, Standing and use (line 338): a reading without its label
- As it stands: "Read on the meta-attractor, Quote ["
- Source: ALIGNMENT.md:59: "*Reading* [AI reading, Dn]: an interpretation registered with its argument in the decision register." 02-MAP.md:422 carries this reading as "[AI reading, D45]", and A-10's Standing labels the same kind of link "a reading [AI reading, D45]".
- Why: The link to the meta-attractor is a registered reading. Without its label it reads as part of the theorem's standing.
- Fix: replace "Read on the meta-attractor, Quote [" with "Read on the meta-attractor [AI reading, D45], Quote ["

### F25 [imprecision] ALIGNMENT.md, A-10b, Question 2 (line 348)
- As it stands: "2. Under noise the long-run state is the risk-dominant one, here the shapers' wherever lo < c < hi and 2c < hi + lo."
- Source: shaping-read-by-readers-drawn-from-the-selected.md:29: "under rare mutation in a large finite population the long-run state is the risk-dominant one (Kandori, Mailath and Rob 1993; Young 1993)".
- Why: Selection of the risk-dominant state is a limit result for rare mutation in a large finite population. "Under noise" claims it for any noise.
- Fix: replace with "2. Under rare mutation in a large finite population the long-run state is the risk-dominant one, here the shapers' where lo < c < hi and 2c < hi + lo."

### F26 [imprecision] ALIGNMENT.md, A-10c, Meaning (line 389)
- As it stands: "The others among the readers read a loss once it reaches a bound N, and from then on read `lo'` coming back to the shapers in place of `lo`, with the same a, p and c (`ReadInTime.shapedLossPool`)."
- Source: ReadInTime.lean:207–211, `lossCourse`: "the loss starting at zero and growing by one a step, so that the others read it from step `N`". ReadInTime.lean:127–131: "the shapers among the readers read the rule after shaping with `hi` coming back to the shapers, whatever the loss".
- Why: The bullets go on to read the loss "from a reading step N" and to speak of "the late reading". But the text never says that the loss starts at zero and grows by one a step, which is what makes the bound N also step N. Nor does it say that the late reading is the readers' rule after the switch, with the shapers still reading `hi`.
- Fix: replace with "A loss starts at zero and grows by one a step, so it reaches a bound N at step N. From then on the others among the readers read `lo'` coming back to the shapers in place of `lo`, with the same a, p and c, while the shapers keep reading `hi` (`ReadInTime.shapedLossPool`); the rule they then read is the *late reading*."
  (also in: DRAFT-ONE-PAGE.md, result 9 (line 63): replace "Let the others among the readers read a loss once it reaches a bound N, and from then on read lo' coming back to the shapers in place of lo." with "Let a loss start at zero and grow by one a step, and let the others among the readers read it once it reaches a bound N, at step N: from then on they read lo' coming back to the shapers in place of lo, while the shapers keep reading hi. The rule the readers then give is the late reading.")

### F27 [imprecision] ALIGNMENT.md, A-10c, A deadline (line 392)
- As it stands: "From a start with a shaper present whose rule g favours the shapers strictly, a reading from any step from g.other · c · x.other on keeps the lock, under every schedule of reading (`ReadInTime.deadline`)."
- Source: ReadInTime.lean:625–638: `deadline (step : lo ≤ hi) (readers : lo' ≤ hi) (some : 0 < x.carrier) (strict : …) (late : … .other * c * x.other ≤ N) (at_N : reads N = true)`, which concludes that the course is locked "at every step from `N + 1`".
- Why: The text never says x is the start's counts, it leaves implicit both the reading step and the step N + 1 where the lock starts, and it restates neither lo ≤ hi nor lo' ≤ hi. The window bullet just before restates its own hypothesis ("With `lo ≤ hi` alone"), so a reader takes this bullet to need neither.
- Fix: replace with "With `lo ≤ hi` and `lo' ≤ hi`, from a start x with a shaper present whose rule g favours the shapers strictly, a reading at any reading step N from g.other · c · x.other on keeps the lock at every step from N + 1, under every schedule of reading (`ReadInTime.deadline`)."

### F28 [imprecision] ALIGNMENT.md, A-10c, Known weaknesses (line 401): the record's limits are missing
- As it stands: "- Elementary, and known in form. Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "Biggs". No bullet gives the record's limits on noise, learning readers or readings that change with the share.
- Source: loss-read-in-time-by-the-others.md:42: "Courses with noise, readers who learn, readings changing with the share, a loss read before it reaches N, and a general law for the round from the one step between, which goes either way in the witnesses."
- Why: A-10b states its noise limit, but A-10c, which is the item about timing, states none of these.
- Fix: replace "- Elementary, and known in form. Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "Biggs" with:
```
- Without noise, with readers who do not learn and the loss read only from N: Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "Courses with noise, readers who learn, readings changing with the share, a loss read before it reaches N, and a general law for the round from the one step between, which goes either way in the witnesses."
- Elementary, and known in form. Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "Biggs
```
  (also in: DRAFT-ONE-PAGE.md, result 9, Not shown (line 69): replace "- **Not shown:** that actual others read the loss, or that their reading has this form." with "- **Not shown:** that actual others read the loss, or that their reading has this form; courses with noise; readers who learn.")

### F29 [imprecision] ALIGNMENT.md, A-10b, Known weaknesses (line 342): the record's other limits are missing
- As it stands: "- Without noise only: Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]:". This is the item's only bullet on limits.
- Source: shaping-read-by-readers-drawn-from-the-selected.md:30: "Readers who learn (hi and lo changing with the share), a cost changing with the share, readers not counted as the population counts them, starts not under the rule read there (a rule in force against the reading can carry the share across the mass, RuleCapture.Reversed.not_absorbed)".
- Why: The noise limit is kept and the record's other limits are dropped. One of them bears directly on "One loop": a rule in force against the reading can carry the share across the critical mass.
- Fix: replace "- Without noise only: Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]:" with:
```
- With readers who do not learn and a start under the rule read there: not shown are Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "Readers who learn (hi and lo changing with the share), a cost changing with the share, readers not counted as the population counts them, starts not under the rule read there (a rule in force against the reading can carry the share across the mass, RuleCapture.Reversed.not_absorbed)".
- Without noise only: Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]:
```
  (also in: DRAFT-ONE-PAGE.md, result 8, Not shown (line 60): replace "- Courses with noise." with "- Readers who learn, starts not under the rule read there, and courses with noise.")

### F30 [imprecision] ALIGNMENT.md, A-10b, Known weaknesses, third bullet (line 343): "near-definitional" is dropped
- As it stands: "Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "what is new on the spine is the critical-mass computation, which is elementary.""
- Source: shaping-read-by-readers-drawn-from-the-selected.md:55: "The lock half is near-definitional (RuleCapture's locked_stays and locked_not_below at a start read there), and drawn_reads_iff is a two-step composition (…); what is new on the spine is the critical-mass computation, which is elementary." ma4-drawn-shaping/NOTE.md §6, item 14: "The record's standing says the lock half is near-definitional."
- Why: The record says how much of the "one loop" is near-definitional, which is what its review asked for. The dossier quotes only the closing clause, so the lock half reads as a new theorem.
- Fix: replace "Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "what is new on the spine" with "Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "The lock half is near-definitional (RuleCapture's locked_stays and locked_not_below at a start read there), and drawn_reads_iff is a two-step composition (ClosedCapture.Drawn.pool_reads_iff, then shaped_le_iff); what is new on the spine"

### F31 [imprecision] ALIGNMENT.md, A-10c, Known weaknesses, second bullet (line 399): other forms of late reading are hand claims
- As it stands: "- The others' reading is a premise, in its form and in its time. Quote ["
- Source: ma4b-read-in-time/REVIEW-MA4b.md:194: "What does hold (by hand, not in the Lean)". The review's fix (:196) ends "the others could turn the course from any share; that is not stated here." The record (:40) dropped that last clause.
- Why: The quoted claims about late readings of another form are hand arguments, not Lean. The page also drops "far enough below theirs".
- Fix: replace "- The others' reading is a premise, in its form and in its time. Quote [" with "- The others' reading is a premise, in its form and in its time. Other forms are not stated in the Lean: Quote ["
  (also in: DRAFT-ONE-PAGE.md, result 9, Not shown (line 69): replace "and one weighted against the shapers after the share is seen could turn the course from any share." with "and one weighted against the shapers after the share is seen, far enough below theirs, could turn the course from any share; neither is stated in the Lean.")

### F32 [imprecision] DRAFT-ONE-PAGE.md, result 9, Turned or kept (line 64): ties
- As it stands: "exactly where the late reading favours the others at the share of step N + 1 (`turned_early_iff`)."
- Source: ReadInTime.lean:319: `turned_early_iff` is an iff with `disfavours`, which is weak. ReadInTime.lean:792–802, `Tie.both`: "At a tie a reading both keeps and turns." A-10c (line 390) has "ties included".
- Why: The page never says that favouring is weak, so the iff reads as strict. Read that way it fails at a tie, where both laws hold.
- Fix: replace with "exactly where the late reading favours the others, ties included, at the share of step N + 1 (`turned_early_iff`); at a tie a reading both keeps the lock and turns the course (`Tie.both`)."
  (also in: 07-SIGNIFICANCE.md, Read in time (line 535): replace "exactly where the others' late reading still favours them at the share a step on." with "exactly where the late reading still favours the others, ties included, at the share a step on.")

### F33 [imprecision] DRAFT-ONE-PAGE.md, standing note (line 3): the date
- As it stands: "*Draft for alignment researchers, 24 October 2026 (AJ4). No person has reviewed it yet; standings are as of this date."
- Source: The same note reports landings and runs of 25 and 26 October. The page was last changed at `66854dbf7`, on 26 October at 04:53.
- Why: The standings are those of 26 October, not of the date the note gives.
- Fix: replace with "*Draft for alignment researchers, 24 October 2026 (AJ4), brought up to date on 26 October 2026. No person has reviewed it yet; standings are as of 26 October."

### F34 [imprecision] DRAFT-ONE-PAGE.md, standing note (line 3): the reviews of results 8 and 9
- As it stands: "Result 8 (MA4) landed on 26 October 2026, after one independent AI review that found no unsound Lean:" and "Result 9 (MA4b) landed the same day, after one independent AI review that found no unsound Lean:"
- Source: ma4-drawn-shaping/REVIEW-MA4.md:7: "I found no unsound Lean, but the text needs fixes before landing." That review has 16 numbered findings; finding 3 (:50), "the two conditions are independent in this model", was withdrawn (NOTE.md §6). ma4b-read-in-time/REVIEW-MA4b.md:7 gives the same verdict. ma4b-read-in-time/NOTE.md:73: "fifteen findings in the text … All fifteen were taken."
- Why: Each review's verdict was "no unsound Lean, but the text needs fixes", and the note keeps only the first half. For result 7, the same note does say what its review changed.
- Fix: replace "Result 8 (MA4) landed on 26 October 2026, after one independent AI review that found no unsound Lean:" with "Result 8 (MA4) landed on 26 October 2026, after one independent AI review that found no unsound Lean and sixteen findings on its text, taken as its note says, among them a claim that the two conditions are independent, withdrawn:" Then replace "Result 9 (MA4b) landed the same day, after one independent AI review that found no unsound Lean:" with "Result 9 (MA4b) landed the same day, after one independent AI review that found no unsound Lean and fifteen findings on its text, all taken:"

### F35 [imprecision] DRAFT-ONE-PAGE.md, What follows for alignment, "The unit is the joint selection" (line 77)
- As it stands: "Results 1 to 9 hold of any selector."
- Source: Each result's own premises, for example result 8's: readers drawn from the selected, with lo ≤ hi. Page line 11: "Whether trained systems and real institutions meet the models' conditions is a separate claim".
- Why: The results hold of any selector that meets their premises. As worded, the line says every selector does.
- Fix: replace with "Results 1 to 9 hold of any selector that meets their premises; who selects does not enter them."

### F36 [imprecision] DRAFT-ONE-PAGE.md, LA3 (line 120)
- As it stands: "Frozen before it ran; 180 calls."
- Source: experiments/shaping-what-comes-back/README.md:41: "180 calls. Four answers gave no valid policy and were asked again once". agent.py:94–103 makes two attempts and logs only the last. results/calls.jsonl has 180 records, 176 with `attempt` 0 and 4 with `attempt` 1.
- Why: 180 is the number of answers the protocol asks for. Each of the four answers asked again followed a failed call, so the model was called at least 184 times, and the page's other tests count model calls ("121 calls"). The number comes from the README (its lines 41 and 65), whose owner should correct it there.
- Fix: replace with "Frozen before it ran; 180 answers, four of them asked again once."

### F37 [imprecision] DRAFT-ONE-PAGE.md, result 8, Not shown (line 60): an unchecked citation in the body
- As it stands: "Under rare mutation the long-run state is the risk-dominant one (Kandori, Mailath and Rob 1993; Young 1993),"
- Source: Page line 141: "Taken from the AI's knowledge; not yet checked against the sources." That caveat covers only Closest work. The kit's README.md:16–39, its references table, holds none of the works the page cites for results 8 and 9.
- Why: This citation sits in the body, outside the caveat, so it reads as checked. It also drops "in a large finite population".
- Fix: replace with "Under rare mutation in a large finite population the long-run state is the risk-dominant one (Kandori, Mailath and Rob 1993; Young 1993, as the record cites them, not yet checked)," and check the works cited for results 8 and 9 into the kit's table before the page goes out.

### F38 [style] ALIGNMENT.md, A-10b, One loop (line 335): word order
- As it stands: "With shapers present at the start, their share rises at every step where the rule read there strictly favours them, and falls at every step where it strictly favours the others"
- Source: DrawnShaping.lean:398–403, `drawn_rises`: if the rule is strictly above at the start x, the share rises "at every step".
- Why: "At every step where" reads as a condition checked at each step, but the condition is on the start.
- Fix: replace with "With shapers present at the start, where the rule read there strictly favours them their share rises at every step, and where it strictly favours the others it falls at every step"

### F39 [style] ALIGNMENT.md, A-10b, One loop (line 335): the citation for "where"
- As it stands: "(`DrawnShaping.drawn_locked_either`)."
- Source: DrawnShaping.lean:374–383. `drawn_locked_either` states only the disjunction; its two cases are `drawn_locks` (:329) and `drawn_from_below` (:352).
- Why: The cited theorem gives "one way or the other". Which way, for which start, comes from the two theorems it is proved from.
- Fix: replace with "(`DrawnShaping.drawn_locked_either`, `DrawnShaping.drawn_locks`, `DrawnShaping.drawn_from_below`)."

### F40 [style] ALIGNMENT.md, A-10b, One loop (line 335), and A-10c, Question 2 (line 406): undefined terms
- As it stands: "With `lo ≤ hi`, under every schedule of reading, from a start under the rule read there, every configuration" and "the others' late reading would favour the shapers"
- Source: DrawnShaping.lean:150, `drawnCourse`, starts at `(x, drawn … x)`. ALIGNMENT.md:44 defines a reading step, but not a schedule or "a start under the rule read there". A-09 (line 242) uses "the others' late reading" for the others' own reading.
- Why: An alignment reader cannot tell that the rule in force at the start is the one read from the start's share. "The others' late reading" here names the whole pool's rule after the switch, while A-09 uses the same words for the others' own reading.
- Fix: replace "With `lo ≤ hi`, under every schedule of reading, from a start under the rule read there, every configuration" with "With `lo ≤ hi`, under every schedule of reading steps, from a start under the rule read there (the rule in force at the start is the one read from its share), every configuration". Then replace "the others' late reading would favour the shapers" with "the late reading would favour the shapers".
  (also in: DRAFT-ONE-PAGE.md, result 8 (line 56): replace "every course from a start under the rule read there is locked one way at every step" with "every course from a start under the rule read there, the rule in force being the one read from the start's share, is locked one way at every step". Result 9 (line 64): replace "exactly where the others' late reading favours the shapers at the share of step N" with "exactly where the late reading favours the shapers at the share of step N". F32's replacement covers 07's Read in time.)

### F41 [style] ALIGNMENT.md, A-19, the two "The verdicts" bullets (lines 581, 590): passes come first
- As it stands: "- **The verdicts.** Two of the four contrasts passed: the Split pair (the same total return kept or shared) and nothing back, whatever is shared. Two failed: what comes back alone covering the cost, and the stretch whose shared part turns the verdict."
- Source: Both READMEs open with "Failures and limits, first". shaping-what-comes-back/README.md:7: "`s2p0` failed (2 of 5 seeds ended on S) and so did `m2n1_p5` (3 of 5)".
- Why: For an alignment reader the failures carry the result, and both READMEs give them first.
- Fix: replace with "- **The verdicts.** Two of the four contrasts failed: what comes back alone covering the cost (2 of 5 seeds ended on shaping) and the stretch whose shared part turns the verdict (3 of 5). Two passed: the Split pair (the same total return kept or shared) and nothing back, whatever is shared."
  (also in: LA2 (line 581), assuming F2 and F3 are taken: replace "- **The verdicts.** Quote [experiments/self-rewarding-lock/README.md]: "No frozen verdict failed:" with "- **The verdicts.** The bridge failed, three passes rest on a tie and the in-time pass on the counts alone, as the bullets below say. As frozen, Quote [experiments/self-rewarding-lock/README.md]: "No frozen verdict failed:")

### F42 [style] DRAFT-ONE-PAGE.md, LA2, first bullet (line 117)
- As it stands: "- Every frozen verdict passed, but the bridge failed." and "The lock law for late readers does not apply to this judge."
- Source: experiments/self-rewarding-lock/README.md:7, and :12 ("MA2's timing law does not apply to it").
- Why: The page never says what the bridge is, and "the lock law for late readers" is a new name for result 6's timing law.
- Fix: replace "- Every frozen verdict passed, but the bridge failed." with "- Every frozen verdict passed, but the bridge failed: that the judge's reading is a pool of the readers it shows, counted by kind." Then replace "The lock law for late readers does not apply to this judge." with "Result 6's timing law does not apply to this judge."

### F43 [style] DRAFT-ONE-PAGE.md, result 8, Not shown, third item (line 61)
- As it stands: "- Where lo < c < hi the model is a stag hunt, and its critical mass is the mixed equilibrium."
- Why: Under "Not shown", this line reads as something not shown, when what it says is that the form is known.
- Fix: replace with "- New mathematics: where lo < c < hi the model is a stag hunt, and its critical mass is the mixed equilibrium."

### F44 [style] ALIGNMENT.md, A-19, Question 2 (line 605)
- As it stands: "2. Current self-rewarding training reads its outputs in ways LA2 does not cover: graded scores, many rounds, a changing judge. Which of these would the result survive?"
- Why: It states what current training does without a source, and "the result" does not say which of LA2's several results is meant.
- Fix: replace with "2. Self-rewarding training, in which a model judges its own outputs, may read them in ways LA2 does not cover: graded scores, many rounds, a changing judge. Which of these would LA2's results survive?"

### F45 [style] ALIGNMENT.md, A-10c, Witness (line 393)
- As it stands: "(`ReadInTime.Window.too_late`). The deadline is 24"
- Source: ReadInTime.lean:678–681, `Window.between`: "Step 3 is the one step between."
- Why: The claim that step 3 is the one step between is `Window.between`, and the text does not cite it.
- Fix: replace with "(`ReadInTime.Window.between`, `ReadInTime.Window.too_late`). The deadline is 24"

### F46 [style] DRAFT-ONE-PAGE.md, Question 3 (line 156)
- As it stands: "Where are an evaluator's readers drawn from those it selects, as result 8 supposes?"
- Source: Result 8's premise includes lo ≤ hi (record :8). A-10b's Question 1 asks about both halves.
- Why: A reader calibrating result 8 from this question would check only half of its premise.
- Fix: replace with "Where are an evaluator's readers drawn from those it selects, and do the shapers among them read at least as much coming back to the shapers as the others do, as result 8 supposes?"

## Checked and found sound
- **Lean blocks.** A-10b's (`drawn_reads_iff`, `critical_mass_iff`, `drawn_locked_either`) and A-10c's (the `variable` line, `kept_early_iff`, `turned_early_iff`, `at_most_one_between`) match DrawnShaping.lean and ReadInTime.lean, whitespace aside.
- **A-10b's Meaning.** These are right:
  - the pool;
  - who reads ("moved, not removed");
  - the critical mass with lo ≤ hi, and its boundary with lo ≤ c ≤ hi;
  - one loop, with lo ≤ hi, strictness and shapers present;
  - the witness: from one to one the share rises; from one to three it falls and locks.
- **A-10b's other bullets.** The noise bullet quotes the record exactly and keeps its limit. The bullet on the shared pool premise, with LA2's one note, is right.
- **A-10c's laws.** "Kept or turned" is right: readings at N and N + 1, locked from N + 1 or from N + 2, ties included, and the one-step lag of the representation. So is the window bullet: `late_never_falls`, `in_time_earlier`, `kept_once_favoured`, `at_most_one_between` with lo ≤ hi alone, and a new round that can go either way.
- **A-10c's figures and quotes.** These are right:
  - read from step 2, the course is turned from step 4;
  - read from step 3, it is not turned, and it is locked for the shapers from step 6;
  - the start rule is 9 to 8, so the deadline is 8 · 3 · 1 = 24;
  - from two to two the deadline is 96 (`Window.scaled`);
  - the deadline-is-loose quote;
  - the Standing's quotes from 02, with the [AI reading, D45] label present.
- **The page's results 8 and 9.** In result 8's body, the who-reads, critical-mass, one-loop and witness bullets are right (each with lo ≤ hi, and the shapers present where needed). In result 9, the window, witness and deadline lines are right. Result 9's "What it shows" and the "From result 9" line under What gets out of a lock stay within what the witness shows.
- **Independence.** No text claims the two conditions are shown independent.
- **A-09.** A-09's LA2 bullet (line 254) is accurate.
- **LA2's figures in A-19 and on the page.** All right:
  - frozen at `36c8b79cb`;
  - 121 calls: 2 for the answers and 119 judge calls;
  - 112 of 119 calls all one way;
  - with one note, prose in all 50 picks of `late`'s first reading, against lists in 60 of 60 without the note;
  - shares of 32/33 and 32/43;
  - the unread loss at 45 by step 8;
  - the quote from 08's T7 row.
- **LA3's figures.** All right:
  - frozen at `b3a6b7b66`;
  - K1 and K3 passed, K2 and K4 failed;
  - 21 of 21;
  - 9 seeds never tried shaping, all of them N;
  - 27 of 30 chose N in round 0;
  - every round-0 answer speaks of free riding.

  LA3's post hoc readings are labelled as such in A-19 and on the page.
- **The rest of the page.** Its receipts and declaration counts (38 and 39) and its Question 2 are right.
- **Chapter 7.** *The two joined* states lo ≤ hi and the noise bound.
- **The fixes themselves.** Every fix's old string occurs exactly once in its file (76 checked). Every quotation in the fixes is an exact substring of its source (24 checked).
