# The fourth pass: an independent reading of the edition of 31 October 2026

*AI review, 31 October 2026. An independent AI reader, with no part in writing the edition, read the alignment dossier at `b61aa5bbd` (branch `aj4-human`) and the kit's README, read-only, against the chapters, records, experiment READMEs and Lean on main. Its report is kept below as it was returned. Line numbers are the dossier's at `b61aa5bbd`. Links in the proposed text were relative to the dossier and are shown as plain text. How each finding was taken is in [the kit's README](README.md#the-fourth-pass-taken). The same reader's re-check of the fixes follows it ([below](#the-re-check-at-13367d5f5)).*

ALIGNMENT.md at b61aa5bbd (unchanged since; the kit README too), reviewed read-only: 42 findings, 16 of them errors. It is not ready to put before a person. The ten-minute section drops hypotheses that decide its results and misreports the tests, and the provenance section claims citation checks that were not made.

## Errors

**F1 · ten-minute section, result 1 (l.10)** "A selection treats two histories alike exactly when they are alike in what it reads"
- What is wrong: `Web.selects_alike_iff` is `(∀ select, SelectsThrough … → (select l ↔ select l')) ↔ AlikeThroughUpTo …`. The iff holds for every selection taken together; for a single selection only the "if" holds. A-01 itself quotes 03: "A particular selection may ignore what its couplings carry." The record's "near-definitional" is also lost.
- Fix: "1. **Blindness.** Two histories are treated alike by every selection through a formation's couplings exactly when they are alike in what those couplings carry. A single selection may ignore part of that, but none sees beyond it (near-definitional, by its record) (A-01)."

**F2 · A-01, first weakness (l.81)** "The record calls the main law near-definitional (quoted above)."
- What is wrong: nothing above quotes it. The quotation was in the preface that was cut (old edition l.47).
- Fix: "- Quote [theories/becoming/results/records/selection-through-couplings.md]: "The main law is near-definitional and the blindness a one-line corollary of the theorems of testing-within-couplings; the contribution is conceptual.""

**F3 · result 2, the A-03 sentence (l.11)** "keeps a renewing resource at its most productive level until its last step, then takes everything, and at once breaks any dependent needing more than that level"
- What is wrong: `Web.frontier_broken` breaks the dependent at the first step, but "at once" after "then takes everything" reads as the last step. "That level" is wrong where several levels renew equally: in `Optimum.Holding.gated_alike` one optimum keeps a dependent and another breaks it. The sentence also drops reachability from the start, the bounds on the draw, the horizon of at least two steps and "met at the start".
- Fix: "A far-sighted optimizer, over a horizon of two or more steps, with a level of greatest renewal reachable from the start and its draw within stated bounds, holds a renewing resource at a level of greatest renewal until its last step and then takes everything; a dependent met at the start whose need lies above every such level is broken at the first step (A-03)."

**F4 · result 5 (l.14)** "one loop with a critical mass: above it control rises … below it the reverse"
- What is wrong: by `critical_mass_iff`, a mass exists only where `lo < c < hi`. With c ≤ lo the rule favours the shapers at every share. `drawn_locked_either` holds only "from a start under the rule read there", and the record lists other starts as not shown.
- Fix: "…as the others do, then from a start under the rule read there every course is locked one way or the other; where the cost lies strictly between what the two kinds of reader read coming back, a critical mass divides them: above it control rises and the rule locks for it, below it the reverse (A-10b; without noise only)."

**F5 · What follows, first bullet (l.19)** "An assistant whose order rises with its principal's signal adds capacity, not reading"
- What is wrong: it drops D68's premise. 07 §6 says: "At a mutual best response (its existence not shown in general)".
- Fix: "- Read as two optimizers at a mutual best response (its existence not shown in general), an assistant whose order rises with its principal's signal adds capacity, not reading: what neither reads stands where one optimizer of their joint capacity would leave it (A-12)."

**F6 · l.20** "Help that lowers the cost of shaping a rule never lowers the selection for control"
- What is wrong: it drops "with nothing else changed". 07 §6: "Help that also raises the shared part pulls the rule toward even at a step" (`shared_lowers`).
- Fix: "Help that lowers the cost of shaping a rule, with nothing else changed, never lowers the selection for control; help that also raises the shared part pulls the rule toward even (A-11)."

**F7 · l.20** "A counter-rule read from its own share locks as the rule it replaced did"
- What is wrong: A-13 limits this to "where every rule it reads favours its carriers". D68 says: "A counter-rule whose reading can favour the others need not lock" (`Alternating.never_locked`).
- Fix: "A counter-rule read from its own share locks as the rule it replaced did where every rule it reads favours its carriers, and need not lock where its reading can favour the others (A-13)."

**F8 · l.21** "These models do not tell the two apart"
- What is wrong: 07 §6 says "With nothing read beyond the share, control selected above the critical mass is capture", and that the models do not tell the two apart "by what the shaping changes". Part 2's opening has the right form.
- Fix: "In these models what the rule reads is fixed by a premise on its readers, not by the shaping: with nothing read beyond the share, control selected above the critical mass is capture. So they do not tell capture from accountable revision by what the shaping changes (Part 2)."

**F9 · tests lead (l.24)** "All are small, on one model choosing in context; none trained a model by gradient."
- What is wrong: this is true of LA1–LA3 only.
  - CG1 and CG2 trained tabular Q-learners.
  - IN1 ran gpt-5.4-mini and gpt-4.1-mini.
  - MQ1 and SE1 used an exact best response, and MQ1 also tabular learners.
  - EM1, not listed in the dossier, trained "a linear softmax policy … by REINFORCE".
- Fix: "All are small. LA1 to LA3 ran one model (Claude Haiku) choosing in context and IN1 two GPT models; CG1, CG2 and MQ1 trained tabular learners, MQ1 and SE1 also used an exact best response, and EM1 trained a linear policy by policy gradient. No language model was trained."

**F10 · LA2 bullet (l.25)** "so result 6's timing law does not apply to it"
- What is wrong: this regresses the third pass's F1 and F2. LA2 tested A-09's law (README: "MA2's timing law does not apply to it"). Result 6 is stated in A-10c's form, which landed after LA2 was frozen. The bullet also omits that the in-time turn came from the readers' counts alone (the control turned in 4 of 5).
- Fix: "…turned the judge, so A-09's timing law does not apply to it; result 6's join with shaping came later and is untested. Three passes rest on an exact tie, and the in-time turn came from the readers' counts alone (A-19)."

**F11 · l.27** "no test yet tests a drain beyond the reward's couplings"; also A-18 (l.546) "No test here tests that."
- What is wrong: two tests do test it.
  - CG1's C1, in A-18's own row: "an own-reward learner spends the last apple … a learner whose reward reads the level after the last step never does (C1). The difference between the two lies wholly beyond the own learner's reward".
  - IN1: the fishers "kept no dependent they were not told of".
  - What is untested is T3's added clause, "in proportion to how near they come to their reward's optimum". 05 T3 has the same flaw, which is for its owner.
- Fix (l.27): "These test that choice follows a stated reward to its optimum. CG1 and IN1 show a drain beyond the reward's couplings in tabular learners and LLM agents; no test yet varies how near a trained system comes to its optimum, the clause T3 adds (A-18)."
- Fix (l.546): "CG1 (C1) and IN1 test that drain; no test varies how near a trained system comes to its reward's optimum, the clause T3 adds."

**F12 · A-18, MQ1/SE1 row (l.540)** "in 8 of 8 variants"
- What is wrong: the MQ1 README says it "predicted which cells die in five thin-margin variants and when: 8/8". Its B4 row also has "learners failed (80/151)", which the dossier drops. The row links only SE1's README.
- Fix: "For an exact best response, the blind draw against margin predicted which cells die, and when, in five thin-margin variants: 8 of 8, against 0 of 8 for a reference outcome; for tabular learners it failed, 80 of 151 (MQ1). Given the same information…"

**F13 · A-18, CG1 row (l.537)**
- What is wrong: it drops what CG1's README calls "the substantive failure". The old row had it.
- Fix: append "Quote [experiments/commons-gated-renewal/README.md]: "Coupling every member into the stock did not keep it (D2b, both rounds).""

**F14 · A-19, Q3 (l.582)** "and in 9 seeds it never tried shaping. Do agents' priors …"
- What is wrong: this regresses the third pass's F5. Put side by side, the two clauses imply the prior is the cause; the README says "The run does not say why."
- Fix: "…and in 9 seeds it never tried shaping; the run does not say why, since 18 of the 27 seeds that began without shaping tried it later. Do agents' priors…"

**F15 · provenance (l.657)** "Works cited outside quotations were checked against a publication record"
- What is wrong: the cut items now list their records' credits outside quotations, and the kit's table lacks fourteen of them:
  - A-10: Odling-Smee, Laland and Feldman 2003.
  - A-10b and A-10c: Harsanyi and Selten 1988; Skyrms 2004; Hofbauer and Sigmund 1998; Gardner and West 2010; Schelling 1973/1978; Granovetter 1978; Oliver, Marwell and Teixeira 1985; Arthur 1989.
  - A-10c: Biggs, Carpenter and Brock 2009; David 1985; Cowan 1991; Alboszta and Miękisz 2004.
  - A-20: Soares, Fallenstein, Yudkowsky and Armstrong 2015.
  - RF's checks of Hubinger, Hadfield-Menell, Good and Carey are recorded only in a clause that was dropped (kit l.133). This is the third pass's F8 at scale.
- Fix: check them into the table, or write "Works cited outside quotations were checked against a publication record (the kit), except credits an item lists from its record, which are the record's citations, as are works named inside a quotation. The works A-20 cites from RF were checked against their texts, as the kit's provenance says."

**F16 · A-20, drawing afresh (l.592/598)** credited only to Hubinger and others' §4.5.
- What is wrong: RF7's record credits "the advantage of behavioural strategies under absent-mindedness (Piccione and Rubinstein 1997)", and 03 §11 adds Aumann, Hart and Perry 1997.
- Fix: append to l.598 "Its standing above acting by its own law at both, where no single mixture does, is the advantage of behavioural strategies under absent-mindedness (Piccione and Rubinstein 1997; Aumann, Hart and Perry 1997)." Then check both into the table.

## Imprecisions

**F17 · result 2 (l.11)** It drops "eligible": `Room` and `Least` range over eligible outcomes.
- Fix: "Where every eligible outcome that keeps more of an unread condition than another eligible outcome is beaten, on what is read, by some eligible outcome (*room*), … at its least among the eligible outcomes".

**F18 · result 3 (l.12)** "If how it is read is also formed from the share, a loss the loop does not read never unlocks it"
- What is wrong: `lock_outlives_loss` needs no reading formed from the share. The law that does need it, `reading_absorbed` ("a change of the reading of any size is absorbed"), is lost, and `Raises` is dropped.
- Fix: "A rule read monotonically from the share it selects, under which selection does not lower the selected share, locks where every rule it can read favours the selected, and from a locked configuration a loss it does not read grows past every bound while it stays locked. If how the rule is read is also formed from the share, a change of that reading, of any size, is absorbed at the next reading step."

**F19 · result 4 (l.13)** "favours … exactly where … covers the cost"; "decides nothing at a step"
- What is wrong: favouring is weak, so at c = s neither kind is selected, and the reader only meets the Terms later. p fixes no direction, but it pulls the rule toward even. Stretch verdicts rest on the form of the cost.
- Fix: "At a step, the rule weakly favours shaping it exactly where what comes back to the shapers alone covers the cost; at equality neither kind is selected. What comes back to everyone alike does not change that direction, though a larger part pulls the rule toward even, and across a stretch it can turn the verdict, the cost being counted as extra offspring to the others."

**F20 · result 6 (l.15)**
- What is wrong:
  - It drops `lo ≤ hi`, `lo' ≤ hi`, a start favouring the shapers, the readings at N and N + 1, and "ties included".
  - "Their new reading" is the pool's rule, not the others' own (the third pass's F40).
  - The last sentence is the home section's [AI reading, D45], stated here as proved.
- Fix: "From a start whose rule favours the shapers, let the other readers read a loss only once it reaches a bound, the shapers still reading at least as much coming back to them as the others do, before and after; call the rule then read the *late reading*. Read at that step and the next, the course turns for good exactly where the late reading favours the others, ties included, at the next step's share, even above the critical mass, where control is selected. Once the late reading favours the shapers, the lock stays; at most one step lies between. Its home section reads this as a window that closes on the share's course, the loss only timing the reading [AI reading, D45]."

**F21 · l.9 "a witness where each fails"; l.30 "results 1 to 6 use neither"**
- What is wrong: not every condition has a witness (`Raises` has none). Result 7 uses neither premise either.
- Fix: "witnesses bounding many of them"; "and no result here uses either".

**F22 · l.30** "Inner alignment, mesa-optimization or goal misgeneralization; … in counts"
- What is wrong: the clause has no predicate. A-05 says where training leaves a learner free. A-20 locates goal misgeneralization, which 03 §11 calls "a possibility located exactly, not a failure shown". "In counts" clashes with the *Counts* label.
- Fix: "That training installs a given function (inner alignment, mesa-optimization): A-05 says where training leaves a learner free, not what it learns there. Goal misgeneralization is located as a possibility, not shown; deception, assistance games and corrigibility are reached only in part, in natural-number weights (A-20)."

**F23 · tests summary (l.24–28)** It is selective for a list titled "as they fell".
- Missing passes: C1's 118/118 against 0/2,360, MQ1's 8/8, LA1b's 30/30, LA1c's 29/30 and 8/10.
- Missing failures: CG2's two keeps, D2b, MQ1's learners, EM1's E1.
- Missing limits: LA3 "cannot refute A-10", and LA1b's "or never showed it".
- Fix:
  - Write "**LA3**, shaping an evaluator, which cannot refute A-10's law: …".
  - Replace the LA1 bullet with: "LA1's locked side failed in two of four settings, which LA1b reads as feedback that barely resolved the best choice, or never showed it; with it resolved and assigned (LA1b) all 30 locked seeds ended at the best, and unaided (LA1c) 29 of 30 locked and 8 of 10 open seeds", followed by F11's sentence.
  - Replace the last bullet with: "**CG1, CG2, EM1, IN1, MQ1, SE1**: the own-reward learner took the last apple every time and the coupled one never did, but the coupled learner kept the stock to the end in 59% of episodes against 90% predicted, and three coupled learners together did not keep it; two predicted keeps failed, and a sixteenfold weight on the end changed nothing for tabular learners, though learners that generalize across states kept the stock in three of six locked settings; LLM fishers kept no dependent they were not told of; the side-effect forecast held for an exact best response, failed for learners, and matches relative reachability and attainable utility preservation while deciding less (A-18)."

**F24 · Part 2 opening (l.184)** "Capture is shaping whose rule is then read from the shapers' share alone"
- What is wrong: it drops 07's "selected by what comes back to the shapers alone" and "may need the capacity rewarded, and so selected", which is the reason for the restatement.
- Fix: "Capture is shaping selected by what comes back to the shapers alone whose rule is then read from their share, so that the losses it causes are read by no one in the loop. Accountable revision keeps a reader of what lies beyond that share and may need the capacity rewarded, and so selected. With nothing read beyond the share, control selected above the critical mass is capture, and Quote …".

**F25 · A-10 (l.292–293)**
- What is wrong:
  - The stretch drops "the shapers present" (`stretch_iff`'s `some : 0 < x.carrier`; the old edition had it).
  - `wait_not_more` states one step, not "more steps".
  - "At a step" drops "toward even".
- Fix: "…then n steps with something back, the shapers present"; "one more step with nothing back never helps (`RuleShaping.wait_not_more`), so neither do more"; "The shared part does not change the direction at a step, though a larger one pulls the rule toward even (`RuleShaping.shared_lowers`, `RuleShaping.shared_raises`)."

**F26 · A-10 LA3 bullet (l.303) and A-19 (l.569)**
- What is wrong: the frozen reading names K4 only. The README says "H1-LA3 is low in both failed conditions, and in `m2n1_p0`, which passed" and "Neither frozen rival fits either" (the third pass's F18).
- Fix (A-19): "By the frozen rules the bridge is low in both failed conditions and in `m2n1_p0`, which passed. For K4 the predictions file reads Quote […]: "The law stands, but its reading for trained systems is not supported by this case." The README reads K2's failure the same way, and Quote [experiments/shaping-what-comes-back/README.md]: "Neither frozen rival fits either.""
- Fix (A-10): "In LA3 (A-19), which cannot refute this law, two of four frozen contrasts failed, every seed that missed having never tried shaping; for K4 the frozen reading is that the law stands and its reading for trained systems is not supported."

**F27 · A-10b** Five regressions of third-pass fixes.
- (a) l.343, F30: restore the full quotation: "The lock half is near-definitional (RuleCapture's locked_stays and locked_not_below at a start read there), and drawn_reads_iff is a two-step composition (ClosedCapture.Drawn.pool_reads_iff, then shaped_le_iff); what is new on the spine is the critical-mass computation, which is elementary."
- (b) l.340, F13: "That join is A-10c, which shows that converse: a lock left in time where control is selected."
- (c) l.334, F39 and F38: cite "(`DrawnShaping.drawn_locked_either`, `DrawnShaping.drawn_locks`, `DrawnShaping.drawn_from_below`)", and write "With shapers present at the start, where the rule read there strictly favours them their share rises at every step, and where it strictly favours the others it falls at every step".
- (d) l.344: "did not meet" is stronger than LA2's README ("not every pool"). Write "the one judge LA2 tested was not such a pool with the readings it was shown, which leaves other pools open (A-19)."
- (e) Q2, l.348: write "Under rare mutation in a large finite population the long-run state is the risk-dominant one, here the shapers' where lo < c < hi and 2c < hi + lo."

**F28 · A-10c**
- (a) l.374: "the second condition … the first" refers to conditions the dossier never names; the old edition named them. Fix: "Its home section reads it for the joint selection's first two conditions, in their earlier wording control left unselected and a lock left in time [AI reading, D45]:".
- (b) l.372, the third pass's F45: cite "(`ReadInTime.Window.between`, `ReadInTime.Window.too_late`)".

**F29 · A-18, LA1c row (l.543)**
- What is wrong: it reads as if the rates were predicted. The README says: "The prediction tests selection only … What the search found is in the rates and the readings, which the account does not predict." It also omits the `k3s8` limit.
- Fix: "Its one prediction, which tests selection only (on each side at most one seed ends below a threshold it played that the rounds resolve as better), passed on both sides. Not predicted: 29 of 30 locked and 8 of 10 open seeds ended at the best threshold; the two open misses never tried the thresholds where restraint pays, and in `k3s8` 7 of 15 seeds had not played the best by round 6."

**F30 · A-18**
- (a) l.546: the "[this dossier, AI]" label sits on text that chapter 5 states (05 T3, "What the LA1 series tests"). Fix: "Chapter 5 states it (05 T3):".
- (b) The CG2 row's sixteenfold result holds only for tabular learners (EM1 README: "a finding about tabular learners, not about learning in general"). Fix: add the row "| EM1, learners that generalize across states on CG2's conditions (experiment) | Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "learners that generalize across states, run on CG2's conditions, kept the stock in three of the six locked settings, each one where restraint by all is also an equilibrium". Its frozen E1 failed, so CG2's sixteenfold result holds for tabular learners. |"
- (c) l.547: write "It also decides less (2 of 10 cells open) and covers less."

**F31 · A-20 standing (l.597)** "Theorems (counts)"
- What is wrong: *Counts* is defined as "two whole-number counts of carriers and others". The home sections say natural-number weights, near-definitional, with witnesses.
- Fix: "Theorems (natural-number weights, read as probabilities where valid; near-definitional, with witnesses, none claimed new as mathematics), landed …".

**F32 · A-20, holding (l.593)** The record's premise is missing.
- Fix: append "The stopping reading values by the formation's own gains and losses, one valuation shared, as in the off-switch game's common payoff; a reading stopping by other values enters as a rule."

**F33 · A-20, What acts show (l.595)** "these results locate…"
- What is wrong: the bullet cites RF's other laws (03 §11, §12), not the three results above it, and names no theorem. It drops 03 §11's "That a training installs either, or that either disagrees with an independently stated objective, is not proved". "Blanketed law" is undefined.
- Fix: "Read [AI reading], RF's laws of what a formation's acts show (03 §11) and of the reading loop (03 §12) locate … ; that a training installs either reading, or that either disagrees with an independently stated objective, is not proved. For one law with a Markov blanket (03 §1), from one start, …". Name the theorems.

**F34 · A-20 last weakness (l.608)** "Otherwise shutdown appears only as a protocol"
- What is wrong: "Otherwise" has lost its referent, and "that completes under stated conditions" has gone.
- Fix: "Outside a formation's own prospects, shutdown appears only as a protocol that completes under stated conditions: Quote …".

**F35 · Terms (l.60, l.64)**
- What is wrong:
  - "the others quote a chapter, record or study" is false for paraphrased bullets, such as A-10's line on reading the cost and A-20's "Nor is concealment".
  - "[AI reading]" without a number is used five times in A-20 and is undefined.
  - Shapers "In A-10 to A-14": A-12 and A-13 have no shapers.
- Fix: "the others state or quote a chapter, record or study. [AI reading] without a number: an interpretation its record states, not registered."; "In A-10 to A-10c, A-11 and A-14".

**F36 · provenance (l.656)** "were read by those items' own reviewers"
- What is wrong: that holds only for the box those passages first stood in. A-20 is recomposed from it (F31–F34 arise there), and the ten-minute section and the cut items are new text.
- Fix: "…in the box where they first stood. The ten-minute section, the cut items and A-20 as now written were read by a fourth reader:", followed by REVIEW_LINE.

## Readability and style

**F37 · ten-minute section** It uses "rising", "favours" (weakly), "reads", "locks", "critical mass", "reading step" and "generation" before the Terms define them; "generation" is not defined anywhere.
- Fix: after the lead of "What is proved", add "A selection *reads* what its signal depends on; an order is *rising* when it ranks higher whatever exceeds on what is read; a rule *favours* a kind when each of it leaves at least as many offspring; a course is *locked* when neither share nor rule falls again (the Terms give each exactly)." Link "generation" to the glossary.

**F38 · the three conditions are never stated**, though Part 2, A-10c and its Q3 rely on them.
- Fix: add to "The question": "In AJ's plan it is aligned where three conditions hold: control of the rule is not captured, a lock is left in time, and courses are compared by widening."

**F39 · A-19 uses undefined labels:** L1–L4, `late`, "T7's third forbidden case", MA2, S, K2, K4.
- Fix: gloss each at first use: "(LA2's frozen contrasts)", "(the condition read late)", "(a single reading turning the lock)", "(A-09's law)", "S (shaping)", and label the failed contrasts "(K2)" and "(K4)" at l.568.

**F40 · A-20 (l.594)** The symbols are undefined.
- Fix: after the quotation add "(T: the formation's total prospects; V: the value of its law acting later, where kept; k₀, c₀: the weight of that acting after the revision goes through, and the revision's own loss; kρ, cρ: the weight of the law's being kept along route ρ, and that route's loss)".

**F41 · What we ask, Q3 (l.35)** It asks about only half of result 5's premise (the third pass's F46).
- Fix: "…drawn from those it selects, and do the shapers among them read at least as much coming back to the shapers as the others do?"

**F42 · small points**
- Result 7: "a finite list of what can be allowed" becomes "a finite list of formations".
- A-19, l.577: "one small model" becomes "one model" ("small" is unlabelled; the third pass's F20).
- A-10, l.302: give the record's reasons, "Price (1970), who keeps the accounts of such selection; Olson (1965), on why a benefit shared by all selects nothing in those who bear its cost".

## Times
Measured on visible text at 100–130 words a minute:
- **Ten-minute section:** 1,092 words, 8.4–10.9 minutes, so the claim holds. A first reader needs the Terms as well, which makes 13.5–17.5 minutes (see F37).
- **One-hour path:** 4,630 words with the section, 36–46 minutes. With the Terms it is 41–53, and with A-04 and A-09, on which A-12 and A-19 rest, 45–59. The hour holds.
- **READING_TIME:** 12,033 words by my count (the kit says 12,200), so 93–122 minutes: "about two hours".
- **REVIEW_LINE, suggested:** "A fourth independent AI reader read this edition's new text (the ten-minute section, A-10 to A-10c, A-18 to A-20 and this section) on 31 October 2026: 42 problems, 16 of them errors." Add how they were taken.

## Checked and found correct
- Every quotation is an exact substring of its file, and every Lean name exists (the packet's script reported 0 problems).
- All 14 Lean blocks match their source declarations, up to whitespace.
- A-20's three statements match RF7, the holding record, RR's record and the Lean.
- A-10: "an equivalence, not a derivation", `favours_iff` and `disfavours_iff`, `nothing_back_falls` with the shapers present, and the SharedFlips and Split witnesses.
- A-10b: `lo ≤ hi` on its laws, the noise bound, and "a start under the rule read there".
- A-10c keeps the third pass's fixes (F1, F26, F28, F31): ties included, the one-step lag, and the deadline as a bound.
- A-19 keeps the tie, the "occurs" note and the counts-only in-time turn.
- The COLLECTIVE-DIRECTION link and "rule out a guarantee" match that page; the goal's wording is still the old one, as Part 2 says.
- The LA1, LA1b and LA1c figures match their READMEs and chapter 5; A-01's new bullet matches chapter 8's table and the kit's table.

## Overall judgment
The cut items are mostly sound; their faults are regressions of fixes the third pass made. The ten-minute section, which most readers will read alone, is where the work is needed. It states results 1, 3, 5 and 6 and three of the four readings without hypotheses that decide them, and it gets the test summary wrong in three places (the "one model" line, "no drain test", and LA2 set against the wrong law). The provenance section also claims citation checks that were not made.

Fix in this order: the hypotheses (F1, F3–F8); the test claims (F9–F13); provenance (F15); then F2, F14 and F16; then A-20's labels and premises (F31–F34) and the three conditions (F38). Every fix is a text edit; no result, record or Lean changes.

<a id="the-re-check-at-13367d5f5"></a>
## The re-check at 13367d5f5

*AI review, 31 October 2026. The same reader, asked to check whether each finding was resolved and whether its fix introduced a new error, read the edition at `13367d5f5` and the kit's README read-only, ran the kit's measure, and returned the report below. It is kept as returned, with its headings one level down and its one dossier-relative link shown as plain text. Line numbers are the dossier's at `13367d5f5`. How each point was taken is in [the kit's README](README.md#the-re-check-taken).*

I re-checked 13367d5f5 read-only and changed no file. 38 of the 42 findings are resolved, 4 only partly, and the fixes introduced no new errors. I found 12 new points: 7 imprecisions and 5 of readability, style or timing. None is an error.

The dossier and the kit's README are the same at HEAD (9b2e7b0ce). That commit only merges main and edits READING-BUDGETS.md, and the merged chapter edits touch nothing the dossier says. `check_dossiers.py` still reports 0 problems.

### Errors
None.

### Imprecisions

**R1 · result 1 (l.10)** "Every selection through a formation's couplings treats two histories alike exactly when they are alike in what those couplings carry: a single one may ignore part of that"
- Source: `Web.selects_alike_iff` makes the "exactly when" hold for all such selections together. Read for one selection, it says "only when", which the next clause denies. This is what remains of F1.
- Fix: "1. **Blindness.** Two histories are treated alike by every selection through a formation's couplings exactly when they are alike in what those couplings carry: a single selection may ignore part of that, and none reaches beyond it (near-definitional, by its record; A-01)."

**R2 · A-20 standing (l.594) and its Meaning lead (l.588)** "Theorems (natural-number weights and values, read as probabilities where valid; near-definitional, with witnesses; …)"; "in natural-number counts and weights"
- Source: these are the labels of the first three results only. The six theorems now named under "What acts show" are labelled differently in their home sections:
  - 03 §11 gives "(root: any carrier of alternatives and any occasions; no premise; near-definitional)" and "(any type; being in the target's lump decided; near-definitional)".
  - 03 §12 gives "(any types, on a blanketed law; …; a witness, with two laws …)" and "(any types for the law; a witness)".
- Also, the sentence drops the "With no cycle shown" hypothesis of `above_in_every_iff_reach` and `both_ways_of_unreached`.
- Fix:
  - Standing: "Theorems. The first three: natural-number weights and values, read as probabilities where valid; near-definitional, with witnesses; for holding, none claimed new as mathematics. What acts show: any types, near-definitional laws and witnesses, as 03 §11–12 label them."
  - Lead: "…acts are read: the first three in natural-number weights, read as probabilities only where they are valid; the last for any types."
  - Sentence: "…in the comparisons the shown reach leaves open, no cycle being shown (…)".

**R3 · A-18, first weakness (l.543)** "as chapter 5 states it (05 T3). … [this dossier, AI] CG1 (C1) and IN1 test that drain"
- Source: the 05 T3 bullet it cites ends "no frozen test on a trained system yet does". The dossier now says the opposite and does not say that the chapter disagrees. The kit leaves this "for its owner".
- Fix: have chapter 5's owner correct T3 before release. Until then, add "Chapter 5 adds that no frozen test on a trained system yet does; [this dossier, AI] CG1 (C1) and IN1 do, …".

**R4 · A-10c, last weakness (l.375)** "found the one judge tested not a pool counted by kind, this item's premise too."
- Source: F27(d) softened the same claim in A-10b to the README's "a pool counted by kind with these readings, not every pool". I missed this one in the fourth pass.
- Fix: "found the one judge tested not such a pool with the readings it was shown, this item's premise too."

**R5 · A-18, EM1 row (l.535)** "Its frozen E1 failed, so CG2's sixteenfold result holds for tabular learners."
- Source: EM1's README draws that conclusion from X2's condition: "In `k3s1_lam32` the end reading weighted 32 opened the lock that weight 2 (`k3s1`) did not". E1, the predicted depletion across all six locked settings, does not by itself bear on the weight.
- Fix: "Its frozen E1 and X2 failed: with the end reading weighted sixteenfold (`k3s1_lam32`) these learners kept the stock, so CG2's sixteenfold result holds for tabular learners."

**R6 · tests section (l.30–31) and A-18's IN1 row (l.536)** H3 ("coupling needed") is counted among IN1's failures, while "kept [no] dependent they were not told of" is listed as held.
- Source: IN1's README says "H3 … **failed** on its gap clause, though `DIR_UNSEEN` kept nothing". The seen bed was kept in only 0.10 of seasons, and R2 passed for both models.
- Fix (A-18 row): "…H1 to H3, H5 and D1 failed (H3 on its gap clause only, the seen bed kept in one season in ten), … only R2, the unseen bed not kept, for gpt-4.1-mini."
- Fix (tests section, Held): "…a dependent they were not told of (IN1's R2, and H3's first clause)."

**R7 · provenance (l.660)** "…and A-20 as now written were read by a fourth: REVIEW_LINE"
- Source: the fourth pass read b61aa5bbd. The text as now written is 13367d5f5, which only this re-check has read.
- Fix: "…were read by a fourth reader, before its findings were taken and again after:". Suggested REVIEW_LINE: "42 problems, 16 of them errors, all taken; the re-check at 13367d5f5 found no errors and 12 small points."

### Readability, style and times

**R8 · tests section, Failed (l.30)** "Three of its passes rest on an exact tie … not shown to have turned it" limits passes but sits under Failed.
- Fix: move it to Held: "LA2's frozen verdicts, three of them by an exact tie; its in-time turn came from the readers' counts alone (the control turned in 4 of 5), so the loss read in time is not shown to have turned it."

**R9 · A-10 (l.297)** "(K4)" appears before A-19 defines it.
- Fix: "(K4, the stretch whose shared part turns the verdict)".

**R10 · A-10c standing (l.368)** "in their earlier wording control left unselected and a lock left in time": only the first condition was reworded, and the paragraph's last sentence repeats it.
- Fix: "…first two conditions, control left unselected (the first, in its earlier wording) and a lock left in time [AI reading, D45]:". End the paragraph with "Restated, the first asks that control of the rule not be captured (Part 2's opening) [this dossier, AI]."

**R11 · result 7 (l.16)** "Over a finite list of formations". `Weightings` lists "items (steps and formations)"; the wording came from my own F42 and was loose.
- Fix: "Over a finite list of formations at steps".

**R12 · times and the kit**
- The hour with A-20 added runs 49.8–64.8 minutes, so "adding A-20" leaves the hour. Write "adding A-20 (ten minutes more)".
- The kit's "the tests, 2 to 3" measures 2.7–3.5; write "3 to 3.5".
- The kit's new table sits under the heading "References, as checked on 25 October 2026", which is what the dossier links to. Add an anchor and a lead line for the 31 October table, keeping the old anchor.

### The departures you asked me to judge
- **(a)** Acceptable. A-03 states its result with its hypotheses, and the convergence note sits under the dossier's own label there.
- **(b)** Acceptable. The front is 1,097 words, 8.4–11.0 minutes. The tests section is 355 words, 2.7–3.5 minutes, so "three minutes" holds.
- **(c)** Confirmed against `experiments/direction-installation/README.md`. In round 1, H1–H3, H5 and D1 failed; a prediction passes only if it passes for both models, so 5 of 7 failed, while H4 and I passed. With talk, R1–R4 held for gpt-5.4-mini and only R2 for gpt-4.1-mini. The only issue is the clarity point in R6.
- **(d)** All six names exist (`Becoming/ShownOrder.lean`, `Becoming/Unread.lean`, `Becoming/ReadingLoop.lean`), and their docstrings support the sentences. The dropped hypothesis is in R2.
- **(e)** The label is right for the first three results only (R2).
- **(f)** The restored caveat matches the old box (old edition, l.23) and agrees with A-12's first weakness.

### The 17 references and the times
- **References.** All 17 entries are plausible: journal, volume and pages match the records as I know them, for example Arthur (EJ 99(394):116–131), Aumann, Hart and Perry (GEB 20(1):102–116), Piccione and Rubinstein (GEB 20(1):3–24), Granovetter (AJS 83(6):1420–1443) and Schelling 1973 (JCR 17(3):381–428). I had no web access, so this is a check from memory. A scan found every work cited outside quotations in one of the two tables, except Hubinger, Hadfield-Menell, Good and Carey, which RF checked against their texts, as the provenance now says.
- **Times.** `measure_layers.py` gives:

| Part | Words | Minutes | Note |
|---|---:|---|---|
| Front | 1,097 | 8.4–11.0 | within 1,100 |
| The hour | 5,274 | 40.6–52.7 | 45.9–59.7 with the Terms |
| Whole dossier | 13,234 | 101.8–132.3 | plus 50 lines of Lean; "about two hours" holds |

### Checked and found correct
- The three conditions match AJ's plan §1, and the inline definitions match the Terms and the Lean.
- Results 2 to 6 state the hypotheses their theorems need:
  - room over eligible outcomes;
  - `favouring_locks`, `lock_outlives_loss` and `reading_absorbed`;
  - `favours_iff`, `favours_alike`, `shared_lowers` and `shared_raises`, with SharedFlips;
  - `drawn_locked_either`, `critical_mass_iff`, `drawn_rises` and `drawn_falls`;
  - `kept_early_iff`, `turned_early_iff` (readings at N and N + 1, ties included) and `at_most_one_between`, with `Window.in_time` as the witness above the mass and the D45 label.
- The three readings match 07 §6 and D68.
- Every figure in the tests section matches its README: LA1, LA1b, LA1c, LA2, LA3, IN1, CG1, CG2, EM1, MQ1 and SE1.
- "None trained a language model" holds, because IN2 was dropped before any training job ran.
- The restorations in A-01, A-10, A-10b, A-19 and A-20 all hold. L1–L4 are LA2's contrasts, per its predictions file.

### Resolved, by finding number
- **Resolved (38):** F2–F27, F29, F30, F32–F35 and F37–F42.
  - F3 and F7 by moving the text into A-03 and Part 3.
  - F11 in the dossier; 05 T3 is still open (R3).
  - F30 and F33 each with one wording point (R5, R2).
  - F42 with R11.
- **Partly (4):** F1 (R1), F28 (R10), F31 (R2), F36 (R7).

### Overall
The edition is ready to put before a person once R1 to R4 are taken, each a one-line edit, and 05 T3's sentence is settled with chapter 5's owner. The other points are small.
