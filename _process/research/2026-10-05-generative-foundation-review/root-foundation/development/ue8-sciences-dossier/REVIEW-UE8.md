# UE8 review, first pass: the sciences dossier

AI-authored, 26 October 2026. This is the first of two review passes, made by an independent AI reader who had no part in writing the dossier. It reviews [SCIENCES.md](../../../../../../theories/becoming/review/SCIENCES.md) as it stood at 04:06 on 26 October (634 lines, untracked), with the kit's [README.md](README.md) and [PLAN.md](PLAN.md). This file is the only one created; nothing else was changed, staged or committed.

## How I checked

- **Reading.** I read `AGENTS.md`, then the dossier in full twice. The second reading followed a context reset, so every line number below refers to the current file. I also read the kit's README and plan.
- **Each item.** I compared its **Meaning** and **Standing and use** with three sources:
  - the result's home section in chapters 01–05, 07 and 08, found by its `r-` anchor;
  - the records the item quotes;
  - the Lean: each block's source, and the declarations behind the main named laws.
- **The Lean read.** In the pure core: `Openness`, `Dissipation`, `Entropy`, `Continuation`, `ChoiceCountCapture`, `SelectionTerm`, `SelectionPace`, `Optimum`, `Admission` and `Premises`. In the periphery: `lean/physics/EntropyProduction.lean`, and `lean/warning` through its chapter statement. I read statements and docstrings only. I built nothing, and I relied on the kit's mechanical checks of quotations, names and block text.
- **Test results.** I compared every result the dossier gives with the frozen ledgers of `experiments/margin-measured`, `commons-gated-renewal`, `commons-outrun` and `break-warnings`, and with study §266 (MQ2) in `BECOMING-RENEWAL-READING.md`.
- **Studies.** I read those the dossier cites:
  - UE0 `AUDIT.md`;
  - UE1 `NOTE.md`;
  - UE5 `REVIEW-UE5.md`;
  - UE6 `VERDICT.md`, `ASTRA-NOVELTY.md` and `ROUND-2-ROOT.md`;
  - the early-warning check in `BECOMING-SIGNIFICANCE-REVIEW.md`.
- **The kit's own list.** I checked the README's list "Found in the account while drafting" item by item (see the table below).
- **Web search.** I read search results only and downloaded nothing. I checked the abstracts of Myers et al. 1995 and Keith and Hutchings 2012.
- **Marked judgments.** A field judgment resting on my own knowledge (bioeconomics, sharper probability bounds) is marked [reviewer, AI]. The second pass and the readers should confirm these.

**Kinds.**
- *Error*: the dossier states something the Lean or the account contradicts, or gives a result to the wrong claim.
- *Imprecision*: a hypothesis, condition, number or standing is dropped or blurred, or a recorded weakness is missing.
- *Credit*: a known work or neighbour is missing or misdescribed.
- *Style*: wording, framing or bookkeeping.

*Major* marks what would mislead a reader from the field. Paths are relative to the repository root, and `SCIENCES.md:n` is a line of the dossier.

## Summary

- **Counts.** 3 errors; 29 imprecisions (11 major); 12 credit (3 major); 6 style. 50 findings in all.
- **The five most serious.**
  1. **E1 (S-06).** The rest theorem and `World.arising_opens` are stated without their premises. As written, both are false: the theory's own witness `World.rest_needs_standing` refutes them.
  2. **E3 (S-17).** The counted lock is stated without its in-sync start. As written, it is false (`Witness.Stale.above_but_stale_locks_down`).
  3. **E2 (S-14).** A result for the frozen-rest margin in fish stocks is given as T1's evidence. T1's own exclusion of that margin is cut from its quotation, and T1's own fish test (MQ3 F3) failed.
  4. **I16–I18 (S-14).** T1's frozen tests are not given as they fell:
     - counts are missing, and passes built to pass are left unlabelled;
     - two frozen failures are softened;
     - the salt-shock result was no better than the null, which is T1's own refutation clause, yet it is offered with the chapter's post hoc reading.
  5. **I21–I23 and C7 (S-16).** Several things T6's reader needs are left out:
     - that the literature refuted T6's first wording;
     - EW3's new-row estimates, which point in the refuting direction;
     - the law that a measured need's margin can be read off the multiplier;
     - the closest prior work, Dekker et al. 2018.
- **Verdict.** The dossier can be offered after these fixes and a second pass (see the end).

## Findings

### Opening sections

**I1 (imprecision, major).** "In plain terms" (SCIENCES.md:10): "each result is reported as it fell (S-14 to S-16)".
- *What is wrong.* S-14 to S-16 quote the chapters' summaries of the tests and give only one ledger count (MQ6, 3 of 10). Missing:
  - the frozen counts of MQ1 on real yeast (1 of 2), MQ2 (4 of 8), MQ3 (0 of 4), MQ4 (7 of 12), MQ5 (6 of 8) and MQ7 (0 of 1, one not testable);
  - EW2's frozen p-value;
  - EW3's estimates on new rows.
  See I16, I19 and I22.
- *Evidence.* `experiments/margin-measured/README.md:150–232` (ledgers); `experiments/break-warnings/README.md:42, 45, 87`.
- *Fix.* Under each thesis, give one ledger line per test: its count, and each failed prediction by name with its number. Otherwise, reword the claim to say that the chapters' summaries are quoted and the ledgers linked.

**I2 (imprecision).** Conventions (SCIENCES.md:22): "The modelling choices are listed as commitments of the representation (08 §4): discrete steps …, natural-number amounts …, activity as a proposition, and requirements as thresholds."
- *What is wrong.* 08 §4 lists nine commitments, and the dossier gives four as if they were the whole list. Two of the five left out, identity by naming and the naming of relata, are what S-21 and S-22 turn on: their laws are read "by name".
- *Evidence.* `theories/becoming/chapters/08-METHOD.md:172–182`.
- *Fix.* Write "among them", and add identity by naming (which formation continues which is named), pointing to S-21 and S-22.

**I3 (imprecision).** The terms (SCIENCES.md:24–35); S-22 (SCIENCES.md:570).
- *What is wrong.* "First law" is not among the terms.
  - S-04 explains, in a known weakness, that the theory's first law is `Flow.Gainless`, the second law read in available work.
  - S-22 then uses "Under the first law" and "a finite balanced world under the first law" with no pointer back.
  - A physicist will read thermodynamics' first law, which is what S-04's balance theorem uses.
  - So the README's second item is carried into S-04 only.
- *Evidence.* `theories/becoming/chapters/02-MAP.md:209` ("the second law in available work is the spine's first law"); `Becoming/Entropy.lean:156` (`Gainless`).
- *Fix.* Add a term: "*the theory's first law*: across every step no formation gives a closed family without repetition more than it takes from it; in thermodynamics, the second law read in available work (S-04)". In S-22, write "the theory's first law".

**I4 (imprecision).** "What this is" (SCIENCES.md:3) names control theorists among the readers. S-01's list of results beyond the table (SCIENCES.md:56) is incomplete.
- *What is wrong.*
  - The only item bearing on control theory is S-20 (supervisory control). No item treats the regulation laws. 08 §8 places them: "Regulation restates deadbeat control and requisite variety (Dahleh and Pearson 1987; Ashby 1956)". The late return's band was also tested in CG1: E1 and E2 are of the identity class, and E3 passed 80 of 80.
  - The beyond-the-table list also omits what keeping widening needs, which S-22 treats.
- *Evidence.* `08-METHOD.md:456, 466`; `02-MAP.md:357` (`r-regulation-from-one-side-and-locally`); `experiments/commons-gated-renewal/README.md:42–44`.
- *Fix.* Either add a short item on regulation (02's home section, 08's verdict, CG1's E rows), or drop control theorists from the readership. Add S-22 to the list.

**St1 (style).** "How it was made" (SCIENCES.md:15): "every Lean name against the sources".
- *What is wrong.* The packet's checker does not search `lean/warning`, so S-16's three slowing-down names are written without backticks and go unchecked, as the kit says.
- *Fix.* Write "every backticked Lean name".

### Part 1

**I5 (imprecision).** S-01 (SCIENCES.md:56): "What survives: Quote [08]: 'one vocabulary for conservation, selection limited by observation, and comparison of opportunity sets.'"
- *What is wrong.* 08 introduces its survivors as "Three things survive, none of them a discovery". The qualifier is dropped, so the vocabulary stands without it.
- *Evidence.* `08-METHOD.md:477`.
- *Fix.* Quote the qualifier.

**St2 (style).** S-01's table (SCIENCES.md:49, 51).
- *What is wrong.* Two row labels are shortened:
  - "Recurrence" is 08's "Recurrence and attraction";
  - "Fed from beyond, entropy" is 08's "Fed from beyond, entropy, nets", though the verdict quoted beside it speaks of the nets.
- *Evidence.* `08-METHOD.md:440, 449`.
- *Fix.* Restore the labels.

**St3 (style).** S-02, Standing (SCIENCES.md:74): the audit quotation begins "So are the exactness …".
- *What is wrong.* The audit's preceding sentence is cut: "Within the third parts, the generality is the theory's: every order rising with what couples in, every relation, every renewal law bounded by `r`." Without it, "So are" has nothing to refer to.
- *Evidence.* `_process/…/ue0-third-parts/AUDIT.md:340`.
- *Fix.* Quote both sentences.

**I6 (imprecision).** S-03 (SCIENCES.md:94): Quote [08]: "Read as a thesis, it forbids what the source fields leave open."
- *What is wrong.* 08 states both readings, and only the stronger is quoted. Two sentences are dropped:
  - "Read as a correspondence, a unification adds no theorem and changes no verdict of §8";
  - "The literature here is from the AI's knowledge unless a linked check read it".
- *Evidence.* `08-METHOD.md:511`.
- *Fix.* Quote the paragraph's sentences together.

### Part 2. Physics

**I7 (imprecision, major).** S-04 Meaning (SCIENCES.md:114): "Irreversibility of every taking with whole units gives it".
- *What is wrong.* Irreversibility gives a least loss only at a fixed unit. At a finer unit the least loss can vanish, and the record says so. For a physicist this is the crux, and it is missing from Known weaknesses.
- *Evidence.* `theories/becoming/results/records/least-loss-from-entropy-production.md:36`: "That strict irreversibility gives a least loss at a refining unit: a strict loss without a floor can fall below every unit; only a floor in energy or a proportion survives refinement."
- *Fix.* Add the bullet to Known weaknesses.

**I8 (imprecision).** S-04 Meaning (SCIENCES.md:114): "Balanced on each run, with a finite measure, dissipation in expectation from some step on gives, almost surely, no taking from some step on".
- *What is wrong.* Three things are missing or unclear:
  - the theorem also needs expectations at each step (`HasExpectations`; 02: "with a finite measure and expectations at each step");
  - "dissipation in expectation" is not defined;
  - the statement is about one family.
- *Evidence.* `experiments/integrated-correction/general-framework/generative-basis/lean/physics/EntropyProduction.lean:644, 758`; `02-MAP.md:209`.
- *Fix.* For example: "with a finite measure and integrable amounts at each step, if from some step on a family's expected replenishment and expected takers together are at most its expected uptake, then almost surely nothing takes from the family from some step on".

**C1 (credit, major).** S-04.
- *What is wrong.* The item names no physics source, though the record names several:
  - Gouy–Stodola (exergy destroyed is T0 times the entropy generated);
  - Kelvin–Planck;
  - the fluctuation theorems (Jarzynski, Crooks, Seifert), with their observations (Wang et al. 2002; Collin et al. 2005);
  - Landauer's bound, confirmed by Bérut et al. 2012 and by Jun, Gavrilov and Bechhoefer 2014, and disputed by Norton.

  Two theorems are also known results:
  - `EntropyProduction.gain_probability_le` is the integral fluctuation theorem's Markov bound (the audit, §2.11). It is the textbook exponential bound on fluctuations that lower entropy, and a physicist will recognize it at once.
  - `EntropyProduction.taking_not_recurring_ae` is a Borel–Cantelli argument.
- *Evidence.* `least-loss-from-entropy-production.md:61`; `AUDIT.md:168` ("The probability bound on a gain is the integral fluctuation theorem's Markov bound"); `lean/physics/EntropyProduction.lean`: the Borel–Cantelli import at line 2, its use (`ae_eventually_notMem`) in the proof of `taking_not_recurring_ae`, and Markov's inequality at lines 863–867.
- *Fix.* Give these under Standing and use, and add them to the kit's references.

**C2 (credit).** S-05, Known weaknesses and Q3 (SCIENCES.md:146, 153): "Is the credit to Landauer (1961) and Bennett (1973) complete, given later work on the thermodynamics of computation?"
- *What is wrong.* The record already cites the later work:
  - Bennett 2003;
  - Ladyman, Presnell, Short and Groisman 2007, disputed by Norton;
  - the finite-rest floor as "the counting shadow of Reeb and Wolf's finite-bath correction (NJP 16, 2014) and Masanes and Oppenheim's unattainability (Nat. Commun. 8, 2017)".

  UE6's first round adds Sagawa 2014. The question asks for what the account already has.
- *Evidence.* `merge-of-a-part-kept-by-the-rest.md:49`; `_process/…/ue6-beyond-the-sciences/VERDICT.md:13`.
- *Fix.* Name these works, then ask whether anything beyond them is missing.

**E1 (error).** S-06 Meaning, the rest theorem (SCIENCES.md:169): "With a census, what arises embodied, balance, dissipation and every step from some step on enclosed, rest from some step on cannot be refuted (`World.comes_to_rest_unrefuted`). Arising without end leaves no step from which every step is enclosed (`World.arising_opens`)".
- *What is wrong.* As written, both sentences are false, by the theory's own witness.
  - The rest theorem needs two censuses, of what is active and of what stands, and enclosure around what stands. The dossier's terms define "census" as a census of the active relata only (SCIENCES.md:27).
  - `World.arising_opens` needs every relatum embodied, not only what arises. Read with the previous sentence's premises, the dossier gives it only arising embodied.
  - `World.rest_needs_standing` builds two worlds:
    - the first has a census of the active, arising embodied, balance, dissipation, and every step enclosed around a fixed family, yet arising recurs, which refutes both sentences as written;
    - the second has every relatum embodied and every step enclosed, and arises without end with no census.
- *Evidence.* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Openness.lean`:
  - lines 599–603, whose hypotheses include `standing : w.web.StandingCensus stand` and `around : ∀ t, T ≤ t → w.flow.AroundStanding stand t`;
  - lines 676–678 (`embodied : w.Embodied`);
  - lines 1168–1182 ("The rest theorem needs its census of what stands").

  Also `02-MAP.md:195`: "with only arising embodied, a world can be enclosed at every step and arise without end (`World.rest_needs_standing`)".
- *Fix.*
  - Write: "With censuses of what is active and of what stands, arising embodied, balance, dissipation, and every step from some step on enclosed around what stands, rest from some step on cannot be refuted. With a census of what is active, every relatum embodied, balance and dissipation, arising without end leaves …".
  - Cite `World.rest_needs_standing` as the witness that the census of what stands and full embodiment are needed.
  - Fed from beyond, in the next bullet, holds "with equality of conditions decided", as 02 says. The block shows `[DecidableEq C]`, so this is a small addition.

### Part 3. Evolution

**C3 (credit, minor).** S-07 (SCIENCES.md:193): "mutation–selection balance and the error threshold".
- *What is wrong.* The error threshold is Eigen's (1971; in the audit's literature list). It is not named after its author, so the README's rule for named results does not cover it.
- *Fix.* Cite it.

**I9 (imprecision).** S-09 Meaning (SCIENCES.md:252) and Q3 (SCIENCES.md:265): "Do any natural populations meet exact transmission of offspring number and parents capped at `m`, even approximately?"
- *What is wrong.* The question mixes the premises of two laws:
  - In the block, `exact` is exact transmission of the amount carried (each offspring carries its parent's amount), not of offspring number. Exact transmission of offspring number is the premise of the squared-response law.
  - `whole` (the final total at least the final size) means "every member carrying the amount" only for an amount of zero or one.
- *Evidence.* `Becoming/SelectionTerm.lean:365–366` (`Exact … : ∀ p ∈ ps, ∀ k ∈ kids p, b k = a p`); `Becoming/SelectionPace.lean:776–780` (docstring: "for an amount of zero or one: every member of the final generation carries it"); `08-METHOD.md:465` ("The variance bound is … under exact transmission of offspring number").
- *Fix.* In Q3, write "exact transmission of the amount carried, and parents standing at no more than `m`". In the Meaning, write "(for a 0/1 amount, every member carrying it)".

**I10 (imprecision, minor).** S-10 Meaning (SCIENCES.md:270): "The difference carried to a step is at most … (`carried_le_count`)".
- *What is wrong.* 02 states the bound "Under the standard bounds" and adds "attained by a self-loop", which shows that it is tight.
- *Evidence.* `02-MAP.md:332`.
- *Fix.* Restore both.

**St4 (style).** S-10 Standing (SCIENCES.md:272): Quote [02]: "settling is deciding whether a coupling acts again".
- *What is wrong.* In 02 this belongs to a calibration: that every schedule settles is exactly the dichotomy `RecursOrStops`, which gives LPO. Quoted alone, it reads as a claim about systems.
- *Evidence.* `02-MAP.md:334`.
- *Fix.* Quote the calibration's first clause with it.

### Part 4. Ecology and renewable resources

**I11 (imprecision, major; plain language).** S-11, the [this dossier, AI] bullet (SCIENCES.md:310): "How far the law reaches depends on how often renewal is so gated: significant depensation was found in 3 of 128 fish stocks…". Also Q1 (SCIENCES.md:313).
- *What is wrong.* The bullet equates the gate with the depensation found in data, but the gate is stronger.
  - Under the gate every giver depends on the condition at a need of at least `m`, so renewal is exactly zero below `m`. With nothing drawn, a gated level below `m` stays where it is.
  - Depensation in Myers et al.'s sense is per-capita recruitment falling at low abundance, while recruitment stays positive.
  - Critical depensation is growth below zero beneath a threshold, even without harvest.
  - With a standing draw the gate acts like critical depensation; without one it is neither.

  So "3 of 128" does not count gated stocks; at most it bounds them from above. An ecologist reading Q1 should be told the difference.
- *Evidence.* SCIENCES.md:28 (definition of the gate); `Becoming/Continuation.lean:542` (`gated`). [reviewer, AI] Clark 1976 defines depensation and critical depensation.
- *Fix.* Say that the gate is the limiting form of critical depensation in which renewal below the need is zero, and that the cited frequencies of depensation bound how often it applies from above.

**I12 (imprecision, minor).** S-11 Standing (SCIENCES.md:303).
- *What is wrong.* The identity class's disclaimer is quoted, but not that CG1's one informative prediction passed. That is the scope test A2: the law fails for a patch read alone that a neighbour reseeds, and holds for the two read as one. The account calls it "the informative one".
- *Evidence.* `experiments/commons-gated-renewal/README.md:33, 50`.
- *Fix.* Give A2 beside the disclaimer.

**C4 (credit, minor).** S-11, the [this dossier, AI] bullet (SCIENCES.md:310): "a meta-analysis of 207 stocks found compensation weaker than expected in many and evidence of depensation in some (Keith and Hutchings 2012)".
- *What is wrong.* As far as search summaries of the abstract show, the paper reports compensation strong in some species and weak or absent in others, with possible Allee effects in Atlantic cod and Alaskan walleye pollock. "In many" may overstate it. Myers et al. 1995's "3 of 128" is confirmed.
- *Fix.* Check the wording against the abstract itself and follow it.

**C5 (credit).** S-12 Q3 (SCIENCES.md:340): "Is the super-additivity of harms under added draws known, and has it been measured?"
- *What is wrong.* The account answers both halves:
  - The record answers the first: "Super-additive joint harm is the convexity of the inverse of a concave, increasing renewal". The audit repeats this.
  - The tests measured it in a simulated yeast: MQ1's A4a–A4c passed (12/12, 4/4, 8/8).
- *Evidence.* `margin-of-a-regime.md:59`; `AUDIT.md` §3.4; `experiments/margin-measured/README.md`, MQ1 ledger (A4 rows).
- *Fix.* Say so, and ask instead whether it has been measured in a real system.

**I13 (imprecision).** S-13 Meaning (SCIENCES.md:359–360).
- *What is wrong.* Three laws are given without what makes them hold or exact:
  - "one step of exchange gives room (`Optimum.Above.room`)". 05 states it "Over one step where a part's members take at most their capacity and give no more than they take, the rest exchanging as it does", with decidable equality and with the family set apart from what lies beyond.
  - "With room, every optimum of a rising order leaves each condition beyond at its least eligible level (`Optimum.least_iff`)". The law is an equivalence: room is necessary as well as sufficient. The audit counts that exactness as the theory's own (S-02).
  - `Optimum.frontier_exhausts` also needs a capacity covering `s + R s` and `R 0`. Its converse, `Optimum.frontier_leaves`, is what makes the condition exact, and Q2 asks about exactly that. The converse states that where `R 0 = 0` and a level within reach renews faster than the weighting falls, every optimum leaves something.
- *Evidence.* `05-COLLECTIVES.md:147, 178, 187`.
- *Fix.* State the hypotheses, the equivalence and the converse.

**I14 (imprecision).** S-13 (SCIENCES.md:361): "drawers in turn without floors draw everything at every perfect profile (`Optimum.InTurn.perfect_at_floors`): Quote [05]: 'the discrete form of open access dissipating what a sole owner would keep (Gordon 1954)'".
- *What is wrong.* In 05 the quoted phrase describes another result: the witness in which others draw first (`Optimum.Next.frontier_ends_drawn_first`, with the others' rule supplied). 05 then says that "(c) derives the case `K t z = 0` for drawers in turn without floors".
- *Evidence.* `05-COLLECTIVES.md:158–161`.
- *Fix.* Attach the quotation to that witness, or say that the drawers-in-turn law derives its case.

**I15 (imprecision, major; plain language).** S-13 (SCIENCES.md:359–361, 369). [reviewer, AI]
- *What is wrong.* No cost of drawing is represented: the orders rank by the (weighted) total drawn. In bioeconomics the cost is what decides the two results quoted.
  - Clark's extinction under fast discounting needs a price above the cost of harvesting at low stock, besides a discount rate above the greatest rate of renewal.
  - Gordon's open access dissipates the rent. With positive costs it settles at a positive stock, the bionomic equilibrium, not at nothing.

  A resource economist will read the two quoted phrases as limits with zero cost: "the discrete form of a discount rate above the greatest rate of renewal making extinction optimal" and "open access dissipating what a sole owner would keep".
- *Fix.* Add a [this dossier, AI] weakness saying so, and ask in Q3 whether a cost of drawing would change the laws.

**C6 (credit, major).** S-13.
- *What is wrong.* The audit says where each part of these laws is known:
  - the maximum sustainable yield (Schaefer 1954);
  - the sole owner (Scott 1955);
  - open access (Gordon 1954);
  - extinction under fast discounting (Clark 1973);
  - the most rapid approach path (Spence and Starrett 1975);
  - the dynamic commons (Levhari and Mirman 1980).

  The dossier gives only Clark, in a question, and Gordon, inside a quotation. The item claims a third part, so the reader needs to see where each forbidden statement is already known.
- *Evidence.* `AUDIT.md:288`.
- *Fix.* Name them under Standing and use, and add them to the kit's references.

**E2 (error).** S-14 Meaning (SCIENCES.md:379) quotes T1 as "… kept within the regime's margin". S-14 Standing (SCIENCES.md:381) then adds: "And Quote [margin-measured]: 'In managed fish stocks, it ranks the risk of a break but does not time it.'"
- *What is wrong.* A result for a margin T1 disclaims is presented as T1's partial success in the field.
  - The quotation of T1 stops just before T1's own exclusion: "(its point of no return, not the withheld-levels margin)".
  - The fish-stock ranking is a result for the frozen-rest margin, and the frozen-rest margin is the withheld-levels margin that T1 excludes. (The prediction is MQ4's, labelled "T1"; that is a test label, not the thesis.)
  - "Break" there means falling below half the level within ten years.
  - T1's own fish test failed: MQ3's F3 predicted that under held catch at least 80% of stocks below the regime's point fall, and only 63% fell.
  - S-12 gives the same result correctly, as the frozen-rest margin's.
- *Evidence.* `02-MAP.md:264` (T1 with its parenthesis); `02-MAP.md:232`; `experiments/margin-measured/README.md`:
  - line 17 (the summary bullet the dossier quotes);
  - lines 22–25 (the frozen-rest margin is the withheld-levels margin);
  - line 97 ("The frozen-rest margin over the net draw ranks the risk that a stock falls below half its level within ten years");
  - line 178 (F3, failed, 63%);
  - line 193 (MQ4's "T1 the frozen-rest time to break ranks the risk").
- *Fix.*
  - Restore the parenthesis in T1's quotation.
  - Remove the fish-ranking quotation from T1's standing, or label it: "of the frozen-rest margin, which T1 excludes; a break there is falling below half the level within ten years".
  - Give MQ3's F3 failure with its number.

**I16 (imprecision, major).** S-14 Standing (SCIENCES.md:381).
- *What is wrong.* The results are not given as they fell. Three tests are missing their counts:
  - MQ1 on real yeast passed 1 of 2 (D2, the sharp need, failed at the instrument's floor);
  - MQ2 passed 4 of 8 (the levels, S and S2, failed; after the salt shock, C1 and C2 failed, C1 no better than the null);
  - MQ3 passed 0 of 4.

  Two of the three passes the chapter lists belong to classes built to pass:
  - the simulated Allee yeast's passes are "deterministic limit" checks, run on a model built with a need;
  - CG1's passes are identity and scope predictions. The account says the identity class "gives no empirical support to the theory beyond the correctness of its identification", and the dossier quotes that in S-11, not here.

  The summary "In the laboratory, it predicts thresholds" is quoted without the threshold tests that failed (MQ1 D2; MQ6 A1 and A2). MQ2's own self-review says: "What passed is the need. The level failed".
- *Evidence.* `experiments/margin-measured/README.md:124–178` (the classes and the ledgers); `experiments/commons-gated-renewal/README.md:28, 46, 60`; study §266, verdicts and self-review (`BECOMING-RENEWAL-READING.md`, from line 11323).
- *Fix.* Put a ledger under Standing: for each test, its count, each failure by name and number, and the class of each pass.

**I17 (imprecision, major; softened).** S-14 Known weaknesses (SCIENCES.md:387): "[this dossier, AI] … Two failures (MQ1, and MQ6's A1) were fate readings at the instrument's floor, so a failure can be laid on the measurement rather than on the thesis."
- *What is wrong.* This invites the reader to discount two frozen failures. The account keeps both as failures:
  - the floor reading that rescues A1 (97–100%) is post hoc;
  - "None of them changes a verdict";
  - the same flaw recurred after MQ1 had found it: "The lesson is MQ1's again: read the instrument's floor before freezing a fate rule".
- *Evidence.* `experiments/margin-measured/README.md:215, 233, 256`.
- *Fix.* Replace the clause with the account's own reading: both failed under their frozen rules; read post hoc by the floor, A1 separates 97–100%, which changes no verdict. Then give the account's lesson.

**I18 (imprecision, major; leading).** S-14 Q3 (SCIENCES.md:392): "Should the deaths above the predicted need after a salt shock count against T1, or show that a shock changes the regime and its need, as the chapter reads them?"
- *What is wrong.* The question offers the chapter's reading without the frozen facts:
  - C1's accuracy was 0.78, and so was the null's; C2's was 0.81.
  - T1's own refutation clause names "fates across a predicted point separated no better than by a null".
  - The change of regime rests on a post hoc analysis (P3): pre-shock levels were 8–20% lower, and needs located for each column are right at DF 825 and wrong at 750.
  - The account records that "Four days after the shock is too short to settle fates near the need".
  - The chapter also says "the scope is not chosen afterwards", and the reading should be put beside that claim.
- *Evidence.* `experiments/margin-measured/README.md:168, 280`; study §266, verdicts and post hoc P3; `02-MAP.md:264` (T1's "Refuted by", "the converse, not claimed", and "the scope is not chosen afterwards").
- *Fix.* Give these facts, then ask neutrally whether the test was a fair test of T1 and how its result should count.

**I19 (imprecision).** S-15 Standing (SCIENCES.md:399): "MQ4 failed its whole-state verdict; MQ5 passed; MQ7 missed its frozen bound".
- *What is wrong.* The counts are missing:
  - MQ4: 7 of 12 (G3, F5a, F10a, F10b and T2 failed);
  - MQ5: 6 of 8 (D1 and D2, the draw's response, failed);
  - MQ7: 0 of 1, with C2 not testable and 62 episodes from 5 stocks.
- *Evidence.* `experiments/margin-measured/README.md:181–232`.
- *Fix.* Give the counts.

**I20 (imprecision).** S-15 Standing (SCIENCES.md:399): Quote [08]: "in yeast past its fold (MQ6) residuals carry nothing day to day".
- *What is wrong.* The prediction (L) was tested at constant dilution, not past the fold, and 02 says so exactly. Its bearing on T2 is not stated.
  - At constant dilution the level alone was the whole state. That is the end of T2's law at which recent giving and the lag carry nothing.
  - [reviewer, AI] T2's second forbidden item, read for yeast, would forbid exactly that.
  - The account sets MQ6 aside for T2 ("not T2's three forbidden items"), and the dossier quotes that two lines later.
- *Evidence.* `02-MAP.md:267` ("residuals at constant dilution carry nothing day to day (lag-1 −0.14, passed)"); `experiments/margin-measured/README.md:224`.
- *Fix.* Quote 02's sentence instead, and say how it bears on T2, or that the account does not count it.

**I21 (imprecision, major).** S-16 Standing (SCIENCES.md:429): Quote [08]: "EW1, the literature, consistent".
- *What is wrong.* Three recorded qualifications are missing:
  - 03 says the literature "is consistent and refuted the first wording";
  - the audit's T6 row ends "its first wording was refuted";
  - 08 §8 lists, among prose that said more than the theorems: "that nothing a part senses shows how near a break is. The theorem assumes the stock is not sensed, and the early-warning literature (Scheffer and others 2009) shows the general claim false". That bullet points to this item's own block.

  None of this is in S-16, nor in S-10, whose `break_carried_nowhere` invites the same reading.
- *Evidence.* `03-KNOWING.md:415`; `AUDIT.md:332`; `08-METHOD.md:474`.
- *Fix.* Add all three as known weaknesses.

**I22 (imprecision, major; selective).** S-16 Known weaknesses (SCIENCES.md:432).
- *What is wrong.* The test numbers a reader needs to answer Q2 (whether the tests were fair) are cut:
  - The quotation of EW3 stops just before the account's next sentence: "On the rows EW2 did not test (R5), Benguela's estimates are 0.64 and 0.61 on 15 rows with six covariates, Røst's −0.15 and −0.30". These numbers are reported only, but for one stock they point in the refuting direction.
  - EW2's frozen p was 0.048 against a familywise threshold of 0.025: "AR1's one-sided p would have been below 0.05 as a single test".
  - EW2's combined partial correlation was 0.30 (−0.06 to 0.59).
- *Evidence.* `experiments/break-warnings/README.md:42, 45, 87`.
- *Fix.* Give the numbers, marked "reported only" where they are.

**I23 (imprecision, major).** S-16 Meaning, the seen half (SCIENCES.md:425), and Standing (SCIENCES.md:429).
- *What is wrong.*
  - (a) None of the law's conditions is stated: the variance is the same across the step, a² < 1, deviation and noise are independent with finite second moments, and the measure is finite.
  - (b) `SlowingDown.need_margin_read` is left out: "in the logistic drawn model with h, r, K nonzero a measured need's margin is read off the multiplier". So with the model known and the need measured, the multiplier does give the margin to a dependent's need; what fails is a single function that does so for every need. Without this law, "A dependent's need enters neither statistic" reads more strongly than the account supports.
  - (c) The standing drops 08's scope: "the seen half proved in the periphery, in the linearized and logistic models; one law across domains, and 'only where' beyond these models, conjectured".
- *Evidence.* `03-KNOWING.md:408, 412`; `08-METHOD.md:506`.
- *Fix.* Add the conditions, the law and the scope.

**C7 (credit, major).** S-16.
- *What is wrong.* The closest prior work is not named. The early-warning check found:
  - Dekker, von der Heydt and Dijkstra (2018): "the closest prior form of the uncoupled side, with a matched comparison". In one-way coupled bistable systems, the leading system's indicators did not differ whether or not the follower tipped.
  - Boerlijst, Oudman and de Roos (2013), for the coupled side: the warning appears in what carries the critical eigenvector.
  - Kéfi et al. 2013, Drake and Griffen 2010 and Clements et al. 2017, against whose unmatched controls the first wording fails.

  03's T6 evidence names Boerlijst 2013 and Dekker 2018. The audit quotation ("is the eigenvector literature's") leaves the reader to guess which works it means.
- *Evidence.* `_process/…/BECOMING-SIGNIFICANCE-REVIEW.md:690–692, 713–714`; `03-KNOWING.md:415`.
- *Fix.* Name them.

### Part 5. Mind and inference

**E3 (error).** S-17 Meaning (SCIENCES.md:449): "From counts at or above the threshold `κo · other ≤ κc · carrier`, along every schedule of reading, the course is locked at every step and neither the share nor the rule falls, even where the score favours the second policy (`ChoiceCountCapture.counted_locks`)."
- *What is wrong.* The hypothesis is dropped that the rule in force at the start is the one read from the counts under the same score. Without it the statement is false. In the theory's own witness, counts of three to one stand above the threshold of the score one to two; under a rule an older score left in force, they lock the other way from step 5 (`Witness.Stale.above_but_stale_locks_down`). The dossier's description of the rule as "read from the counts" does not supply the start either: along a schedule of reading, the rule is read only at reading steps.
- *Evidence.*
  - `Becoming/ChoiceCountCapture.lean:286–296`: the docstring says "and the rule in force read from them", and the course starts at `(x, weighted κc κo pos x x)`. Also lines 511–518.
  - `02-MAP.md:403`: "with the rule in force read from the counts at the start".
  - The record `capture-by-counted-choices.md`: line 8 ("in sync under a standing score"), and lines 20 and 37.
  - UE1 `NOTE.md:59`: "The in-sync start is a hypothesis".
- *Fix.* Write "Under a standing score, with the rule in force read from the counts at the start, …". Add the stale witness as a counterexample under Known weaknesses.

**I24 (imprecision, major).** S-17 Meaning (SCIENCES.md:449): "on a chooser of the kind active inference describes". S-17 Standing (SCIENCES.md:451): Quote [08]: "active inference's own simulation of devaluation shows the persistence".
- *What is wrong.* The kit's chooser is a simplification that the record says active inference does not use. It has two policies, chooses at the argmax, counts the executed policy, and uses the counts themselves as its prior. The record's "Does not show" says so in two places:
  - "Active inference's own scheme: it counts the end-of-trial posterior over policies, close to the executed policy where outcomes reveal it and split among policies that explain the trial equally; its prior is the counts' expected log, not the counts; it has a free-energy term, sampling and inferred precision. The threshold is the model's, not SPM's";
  - "Any probability, surprisal, free energy or expected free energy".

  UE1 adds two points:
  - the split the kit does not model is where the 2016 paper places the habit's advantage;
  - the simulation's persistence "is consistent with a lock and with slow decay alike".

  The verdict quoted later ("exactness for a simplified model") softens this, but the Meaning contradicts it.
- *Evidence.* `capture-by-counted-choices.md:29–34`; UE1 `NOTE.md:63, 65`.
- *Fix.* Write "on a simplified chooser (two policies, choice at the argmax, counts of the executed policy)". Quote both passages as known weaknesses, and let Q2 ask about the difference.

**I25 (imprecision, minor).** S-18 Meaning (SCIENCES.md:476): "Given a record that leaves the level `m′` above the need, the share is that from `m′`".
- *What is wrong.* Two of 02's conditions are dropped:
  - the record is of the earliest steps and leaves the level `m′` above the need "without having reached it";
  - the share is of the courses reaching the need "within the n steps left".
- *Evidence.* `02-MAP.md:243`.
- *Fix.* Restore both conditions.

**C8 (credit, optional).** S-18. [reviewer, AI]
- *What is wrong.* Kolmogorov's inequality is the weakest of the standard maximal bounds. For steps bounded as they are here, exponential martingale bounds are much tighter in the tail. UE6's first round also found a sharper one-sided bound already stated for the audit's candidate built on this bound (survival under expected joint excess): Bertsimas and Popescu 2005, Proposition 6.3. A probabilist will point this out, and the dossier can say it first.
- *Evidence.* `_process/…/ue6-beyond-the-sciences/ASTRA-NOVELTY.md:7`; `AUDIT.md:354–358`.
- *Fix.* Add a sentence under Standing and use or Known weaknesses.

**I26 (imprecision).** S-19 Meaning (SCIENCES.md:492).
- *What is wrong.* Two laws lose their conditions:
  - "Below the set point a nearing order drains as a rising order does (`Optimum.least_below_iff`)". 05 says its optima stand at the least level beyond "exactly where room holds there".
  - "In a balanced step what lies beyond then falls … (`Flow.Balances.atSetPoint_draws`)". 05 says "In a balanced step in which the whole gains nothing".
- *Evidence.* `05-COLLECTIVES.md:151`.
- *Fix.* Restore both conditions.

**C9 (credit).** S-19 Standing (SCIENCES.md:494): Quote [08]: "Neighbours, not containments: the laws restate them for one step …".
- *What is wrong.* "Them" are the neighbours 08 names just before, and none is given:
  - satisficing (Simon 1955);
  - mild optimization, or quantilizers (Taylor 2016);
  - homeostatic reinforcement learning (Keramati and Gutkin 2014).

  UE6's first round also found the joint-excess side stated qualitatively within active inference itself: Albarracin and others (2024, *Systems* 12:163), on component resilience depleting a collective's resources.
- *Evidence.* `08-METHOD.md:464`; `_process/…/ue6-beyond-the-sciences/VERDICT.md:13`; `ASTRA-NOVELTY.md:17`.
- *Fix.* Name them.

**I27 (imprecision).** S-20 Meaning (SCIENCES.md:508): "With balance on what couples in, a part beyond a formation's coupling closure is not selected for or against by any selection through the couplings of a formation within it (`Flow.unselected_beyond_coupling`)".
- *What is wrong.* The law's main premise is dropped. 03 states it as a counterfactual: "With a part withheld and the rest of the exchange fixed, balance at each step on the conditions coupled into members of a formation's coupling closure, and every member of the part beyond that closure, every selection … treats the levels with and without the part alike". Where the rest responds instead, a second version holds, with further hypotheses.
- *Evidence.* `03-KNOWING.md:25`.
- *Fix.* Restore the counterfactual, and mention the second version.

### Part 6. Order and open-endedness

**I28 (imprecision).** S-21 Meaning (SCIENCES.md:540): Quote [07]: "Eventual widening needs no growth, a steady course eventually widening one that collapses, and it is silent where a course keeps every formation of another one step later." (`LagWitness.lag`)
- *What is wrong.* The sentence comes from a Reading [AI reading, D45] (07, line 81), yet it is presented as the theorem's meaning.
  - Its second clause is the witness `LagWitness.lag`.
  - Its first clause, a steady course eventually widening one that collapses, follows from the definition but is not a Lean statement. The record gives it only under "Does not show".
- *Evidence.* `07-SIGNIFICANCE.md:79` (the theorem paragraph: "a course keeping every formation of another from one step later is mixed with it in every tail (`LagWitness.lag`)"); `07-SIGNIFICANCE.md:81` (the Reading); `eventual-widening.md:35`.
- *Fix.* Quote the theorem paragraph for the lag. Mark the first clause [AI reading, D45], or say that it follows from the definition and is not proved in Lean.

**C10 (credit).** S-21 Standing (SCIENCES.md:542) and Q2 (SCIENCES.md:551): "Is it a known feature of definitions of open-endedness that their verdicts are neither verifiable nor refutable from a finite record?"
- *What is wrong.* 08 places this already: "That its verdicts are dense both ways is liveness in Alpern and Schneider's sense (1985)". 08 adds that its entailing overtaking (von Weizsäcker 1965; Gale 1967) "is an argument, not proved in Lean". Both sentences fall between the two the dossier quotes and are skipped.
- *Evidence.* `08-METHOD.md:463`; `03-KNOWING.md:160`.
- *Fix.* Give both sentences, and aim Q2 at the open-endedness literature in particular.

**I29 (imprecision).** S-22 Meaning (SCIENCES.md:570).
- *What is wrong.*
  - The phrase "under the World premises (balance, only active formations giving, activity needing support, requirements never loosening)" counts requirements never loosening (`Unloosened`) as a World premise. It is a local hypothesis, not one of the World's eight premises (08 §4; `Becoming/Premises.lean`). The chapter's own "Under the World premises" has the same slip, and the parenthesis puts the hypothesis on the list.
  - `Web.KeepsWidening.from_rest_or_open` needs a family without repetition.
  - `Web.KeepsWidening.renewers_unbounded` needs the family balanced on from a step, and counts entries with repetition.
  - "The course has ever more takers" is `Web.KeepsWidening.more`, not `renewers_unbounded`.
  - "Under the first law" appears twice; see I3.
- *Evidence.* `08-METHOD.md:195–204`; `Becoming/Admission.lean:135`; `07-SIGNIFICANCE.md:84`.
- *Fix.* Write "under balance, only active giving and activity needing support, with requirements never loosening", and restore the dropped conditions.

**C11 (credit, minor).** S-22.
- *What is wrong.* 08 names one neighbour the item omits: "autocatalytic sets are food-generated (Hordijk and Steel 2012)". This is the origin-of-life form of fed from beyond.
- *Evidence.* `08-METHOD.md:466`.
- *Fix.* Add it.

**C12 (credit).** S-23 Meaning (SCIENCES.md:588) and Q1 (SCIENCES.md:597).
- *What is wrong.*
  - "Computational closure" is uncited. The record credits it to Rosas et al. (2024), and lumpability to Kemeny and Snell (1960).
  - Q1's "causal states of computational mechanics" needs a citation: Crutchfield and Young (1989), or Shalizi and Crutchfield (2001).
  - The exact probabilistic counterpart of the lumpability remark is probabilistic bisimulation (Larsen and Skou 1991), which the logic dossier names.
- *Evidence.* `continuation-relative-to-a-class.md:65`; `theories/becoming/review/LOGIC.md:254`.
- *Fix.* Add these citations.

### Questions and the kit

**St5 (style).** Leading questions.
- *What is wrong.* Three questions put the dossier's deflationary verdict as the expected answer:
  - S-07 Q1: "Is anything here more than a restatement in counts?"
  - S-10 Q1: "Are these laws more than the combinatorics of walks …?"
  - S-16 Q1: "Is T6 more than the statement that …?" This one also restates the item's own [AI] bullet.

  S-14 Q3 is treated under I18.
- *Fix.* Use neutral forms, such as "What, if anything, do these laws add to …?" and "What does T6 claim beyond the case without feedback, and could data show it?".

**St6 (style; the kit).** README.
- *What is wrong.* Its counts disagree:
  - "the ten blocks (eleven declarations)" against "13 of 13 declarations in 11 blocks", since S-22's block was added later;
  - "23 items (635 lines)", while the file has 634 lines.
- *Fix.* Update the counts.

## The kit's list "Found in the account while drafting"

| Kit item | Where the dossier states it | Reflected |
|---|---|---|
| Landauer's bound as 02's floor, against UE6 | S-04 | yes |
| Two senses of *first law* | S-04 | partly: S-22 uses the name without it (I3) |
| `Closing.Onset` is a namespace | S-10 | yes |
| Fixation "in the limit" | S-07 | yes |
| Nei and Felsenstein written as one work | S-09 | yes |
| No evolution row in 08 §8 | S-01, S-07 | yes |
| 08 §9 names only MQ6's timing | S-14 | yes, but the note softens the failures (I17) |
| T2's standing differs between chapters | S-15 | yes |
| Test accounts link to a history copy | none | not for readers; left for the owners |
| The Gao, Schulman and Hilton year | none | not used |
| The checker does not search `lean/warning` | kit | yes; the opening's claim needs narrowing (St1) |

Weaknesses recorded in the account but missing from the dossier:
- the refinement of the least loss (I7);
- the refuted first wording of T6 and 08's "general claim false" (I21);
- `need_margin_read` and T6's conjectured scope (I23);
- the record's caveats on active inference's scheme (I24);
- the four-day limit after the salt shock (I18);
- the record's answer on super-additive harms (C5).

## Counts

| Kind | Number | Findings |
|---|---|---|
| Error | 3 | E1 (S-06), E2 (S-14), E3 (S-17) |
| Imprecision | 29, of them 11 major | I1–I29; major: I1, I7, I11, I15, I16, I17, I18, I21, I22, I23, I24 |
| Credit | 12, of them 3 major | C1–C12; major: C1, C6, C7 |
| Style | 6 | St1–St6 |
| **Total** | **50** | |

## Verdict

**Yes, the dossier can be offered after the fixes**, and after a second pass confirms them. The three errors are local:
- each is a dropped hypothesis or a misattributed quotation;
- each can be corrected from the chapter, record or Lean that the item already cites;
- none changes a verdict of the theory or needs new Lean.

The largest piece of work is S-14 to S-16, where the opening promises results "as they fell". That needs:
- a ledger line per test;
- the class of each pass;
- the salt-shock and seabird numbers;
- the account's own lessons, given in place of the dossier's softening note.

Most of the missing credits are already in the repository's records and studies. A few are field knowledge marked [reviewer, AI]: Clark's and Gordon's costs, sharper bounds, and the citations for causal states. The drafter should check those, and the second pass should check them against publication records.

The second pass should read in full:
- E1–E3 and S-14 to S-17;
- every credit added;
- the README's references table, since the new citations need entries there.

## Second pass

AI-authored, 26 October 2026, by the same independent reader. It rechecks [SCIENCES.md](../../../../../../theories/becoming/review/SCIENCES.md) as revised against the first pass (05:03, 659 lines) and the kit's [README.md](README.md) as revised (05:05, 189 lines), comparing both with the reviewed versions kept outside the repository. Line numbers below are of the revised files. Nothing but this section was written; nothing was staged or committed.

### How I checked

- **The changes.** I diffed the revised dossier and README against the reviewed versions and read every changed passage. I read E1–E3 and S-14 to S-17 in full.
- **Mechanical checks.**
  - `check_dossiers.py SCIENCES.md` reports 0 problems.
  - The kit's block comparison matches 13 of 13 declarations in 11 blocks.
  - My own link check finds 100 relative links and anchors in the two files (the kit counts 99), none broken.

  The checker confirms that each quotation occurs in the file it names and that each backticked name exists. It does not confirm that a quotation supports the claim it is attached to, so I read the source around every new quotation.
- **The Lean read** (statements and docstrings):
  - `Openness.lean`: the rest theorem, `arising_opens`, `rest_needs_census`, `rest_needs_standing`;
  - `ChoiceCountCapture.lean` and `lean/warning/SlowingDown.lean`, both in full;
  - `Runaway.lean:193`, `Continuation.lean:439`, `Regulation.lean:477` and `894`, `Optimum.lean:6585` and `6638`, `Reproduction.lean:766–775`, `Entropy.lean:146–157`;
  - `lean/physics/EntropyProduction.lean:644–650` and `758`.
- **The tests.** The ledgers of `experiments/margin-measured/README.md` (lines 122–234), `commons-gated-renewal/README.md` and `break-warnings/README.md`, and MQ2's and MQ3's entries in `BECOMING-RENEWAL-READING.md`.
- **Credits.** I read every quotation added for credit in its source. I checked publication records by web search, reading results only and downloading nothing, for:
  - Boerlijst, Oudman and de Roos 2013;
  - Crutchfield and Young 1989;
  - Dekker, von der Heydt and Dijkstra 2018;
  - Eigen 1971;
  - Keith and Hutchings 2012;
  - Myers et al. 1995;
  - Gordon 1954;
  - Hordijk and Steel 2004.
- **My own first pass.** Four findings below go back to it:
  - E4, I31 (in part) and I34 trace to wording I proposed;
  - St7 traces to a claim I repeated from the kit without checking.

  Each is marked.

### Summary

- **Counts.** 15 findings: 1 error; 8 imprecisions (1 major); 3 credit; 3 style.
- **The fixes.**
  - All 50 first-pass findings were acted on, and most fixes are right as made.
  - E1, E2 and E3 are corrected against the Lean and the ledgers.
  - No quotation added for credit is attached to the wrong claim.
  - The four new references agree with publication records.
- **What remains.** Local text, in seven places:
  - a wrong unit in a frozen verdict (E4);
  - a completeness claim that the ledger lines do not keep (I30);
  - an [AI] bullet on T2 that contradicts the quotation above it and leaves out T2's refutation scope (I31);
  - a test label that reads as the thesis (I32);
  - a dropped condition in the posterior contrast (I33);
  - a loose inference from detection rates (I34);
  - a false sentence about the slowing-down names (St7).
- **Verdict.** Offer after the named fixes (end of this section).

### E1–E3

- **E1 (S-06), fixed.**
  - SCIENCES.md:172 now matches `World.comes_to_rest_unrefuted` (Openness.lean:599–606: `counted`, `standing`, `embodied`, `balanced`, `dissipative`, and `around` taken around what stands).
  - It matches `World.arising_opens` (676–679, `w.Embodied`).
  - The parenthesis describes the two worlds of `World.rest_needs_standing` exactly (1175–1181).
  - Fed from beyond carries "with equality of conditions decided".
  - One small addition is I36.
- **E2 (S-14), fixed.**
  - T1's quotation keeps its parenthesis.
  - The fish-stock ranking is labelled as the frozen-rest margin's, with MQ4's "T1" marked as a test label and a break defined (margin-measured README:97, 193).
  - The ledger line for MQ3 has a wrong unit, which comes from my own first-pass wording (E4).
- **E3 (S-17), fixed.**
  - The counted lock carries its in-sync start: "with the rule in force read from the counts at the start". This matches `counted_locks`, which starts from `(x, weighted κc κo pos x x)` (ChoiceCountCapture.lean:286–296).
  - The stale witness is stated correctly: three to one under the score one to two, with the stale rule ⟨1, 4⟩ read at every step, locks the other way from step 5 (lines 510–518).
  - The new contrast sentence beside it drops a condition (I33).

### The choices the coordinator asked me to judge

- **I4: S-10 as "Loops and regulation".** The right choice, since control theorists now have an item.
  - The regulation paragraph matches 02:353–358 and the Lean:
    - `Regulation.no_narrower_band` (Regulation.lean:894–897; its conclusion is `a + (ℓ + 1) * (d + d) ≤ b`);
    - `Flow.never_returns_below` (Continuation.lean:439: balance at the condition from `T`, and below `m` given at most taken);
    - `Flow.stock_settles` (Regulation.lean:477).
  - CG1's rows are given as they fell: E1 and E2 of the identity class, E3 80 of 80 (commons-gated-renewal README:42–44).
  - The quotation "The late reading's bound is realised by learners" stands in its context (line 56).
  - What is missing is any recorded weakness of the regulation laws (I35).
- **I20: S-15's [this dossier, AI] bullet on MQ6.**
  - It is right to say how MQ6 bears on T2, and 02's exact sentence (at constant dilution) is now quoted.
  - The bullet's content needs I31. Its gap goes back to my first pass, which left out T2's refutation scope.
- **I15: S-13's cost bullet.** Correct as a field statement.
  - In Clark (1973), extinction is optimal only with both a discount rate above the stock's greatest rate of growth and a price above the cost of harvesting the last units.
  - Gordon's open access, with a positive cost, settles at the bionomic equilibrium, a positive stock at which revenue meets cost.
  - With zero cost, both reduce to the readings the item quotes.
  - Gordon 1954 needs a row in the references table (C13).
- **C8: S-18's bullet.** Correct.
  - With steps of +q and −p balanced under the weights, the variance per step is pq, and Kolmogorov's bound npq/m² uses only second moments.
  - For steps of range p + q, the Azuma–Hoeffding bound exp(−2m²/(n(p + q)²)) is far smaller in the tail.
  - The Bertsimas–Popescu quotation is attached to the right candidate: UE6's answer gives it, as their Proposition 6.3, for survival under expected joint excess (ASTRA-NOVELTY.md:7).
- **Credits by quotation.** A sound choice. Each credit keeps its provenance, and the opening says that works named inside a quotation are the quoted text's citations, not checked by the dossier. I read every added quotation in its source, and each supports the claim it is attached to:
  - S-04's physics: least-loss-from-entropy-production.md;
  - S-05's later work: merge-of-a-part-kept-by-the-rest.md:49 and VERDICT.md:13;
  - S-13's bioeconomics: AUDIT.md;
  - S-16's early-warning work: BECOMING-SIGNIFICANCE-REVIEW.md:690–691 and 713;
  - S-19's neighbours: 08 and ASTRA-NOVELTY.md:17;
  - S-21's liveness and overtaking, and S-22's autocatalytic sets: 08;
  - S-23's closure and bisimulation: the record and LOGIC.md.

  Two small points remain (C14, C15).
- **The references table.** The four new rows agree with the records found:
  - Boerlijst, Oudman and de Roos 2013: *PLoS ONE* 8(4):e62033, doi 10.1371/journal.pone.0062033 (PMC3623932). The abstract puts the silent warnings down to the direction of the eigenvectors, as S-16's reading has it.
  - Crutchfield and Young 1989: *Phys. Rev. Lett.* 63(2):105–108, doi 10.1103/PhysRevLett.63.105 (APS issue listing).
  - Dekker, von der Heydt and Dijkstra 2018: *Earth Syst. Dynam.* 9(4):1243–1260, doi 10.5194/esd-9-1243-2018 (the journal's page).
  - Eigen 1971: *Naturwissenschaften* 58(10):465–523, doi 10.1007/BF00623322 (PubMed 4942363).
    - The credit fits the Lean. With `k ≤ w` (a carrier's carrying offspring not outnumbering another's offspring, Eigen's Qσ ≤ 1 without back mutation) and any loss to mutation, the carriers' share falls (`Mutation.falls_of_outrun`, Reproduction.lean:766). The module's statement calls this the error threshold (lines 84–87).
  - The reworded Keith and Hutchings note agrees with the abstract:
    - 207 stocks of 104 species;
    - strong compensation in many species, and much weaker than expected in others;
    - evidence of depensation in some, among them Atlantic cod and Alaskan walleye pollock.

  One work is missing (C13), and one row is out of order (St9).

### Findings

**E4 (error; from my first pass).** S-14, the ledger line for MQ3 (SCIENCES.md:396): "F3 predicted that under held catch at least 80% of stocks below the regime's point fall; 63% fell."
- *What is wrong.* F3 counts episodes, not stocks. Under a held catch, 63% of 754 episodes below the regime's point fell (from 75 stocks), against a frozen 80%. Its second clause, at least 90% of episodes above the point holding, was met: 99.5% of 425 held. The wording "of stocks" is mine, from the first pass's E2, and the fix copied it.
- *Evidence.*
  - `_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md:11621–11624` (MQ3's verdicts) and 13214 ("of 754 episodes below it, 63% fell");
  - `experiments/margin-measured/README.md:178` (F3's row), and its finding 2 ("63% of episodes below it fell, against the 80% required (F3)").
- *Fix.* "F3 predicted that under a held catch at least 80% of episodes below the regime's point fall and at least 90% above it hold; of 754 episodes below it, 63% fell (99.5% of those above held)."

**I30 (imprecision).** "In plain terms" (SCIENCES.md:10): "under each thesis every test is given as it fell, with its frozen count, each failure by name and the class of each pass (S-14 to S-16)". The README's Review section makes the same claim for S-14 (README:180).
- *What is wrong.* The ledger lines do not keep the claim.
  - MQ3 (0 of 4) names one failure, F3. Not named: F0 (last year's escapement adds 0.22, against a bound of 0.10), F1 and F2 (the one-year and five-year forecasts).
  - MQ6 (3 of 10) names A1 and A2, then "five of the six timing predictions":
    - only two of the six time the break (T2-DF and T2-SUC);
    - four compare forecasts of the level away from and near the break: T1a-DF, T1b-DF and T1b-SUC failed, and T1a-SUC passed;
    - the passes, T1a-SUC, C1 and L, are not named.
  - MQ7, in S-15, is given as "0 of 1" without naming the failed prediction, C1.
  - S-16 gives no frozen count: EW2, EW3 and EW4 each passed both of their verdicts, V1 (autocorrelation) and V2 (variance).
  - Classes exist only in the ledgers of MQ1's simulation and of CG1, and those are given. MQ2's and MQ6's ledgers have none, so "the class of each pass" cannot be kept for them.
- *Evidence.*
  - `experiments/margin-measured/README.md`: lines 175–178 (MQ3), 215–224 (MQ6), 230 (MQ7) and 124–129 (classes, given for MQ1 only);
  - `experiments/break-warnings/README.md:42–43, 84–85, 106–107`.
- *Fix.*
  - In the ledger lines, name the failures and MQ6's passes, and call MQ6's six "forecast and timing predictions".
  - Give S-16's counts (each test passed V1 and V2).
  - Narrow the opening to "with its frozen count, each failure by name and, where its ledger classes them, the class of each pass", and bring the README's sentence into line.

**I31 (imprecision, major; partly from my first pass).** S-15, the [this dossier, AI] bullet (SCIENCES.md:423): "while T2's second forbidden item, read for yeast at a comparable horizon, would forbid the level alone forecasting as well. The account does not count MQ6 among T2's tests (above)."
- *What is wrong.*
  - The last sentence contradicts the bullet just above it, which quotes the method chapter's standing: "conjectured, on three frozen fish-stock tests and one in yeast past its fold". The method chapter counts MQ6. The home chapter's standing and the tests' account do not, though the home chapter lists the result under T2's evidence.
  - T2's refutation clause names yeast only "in deteriorating environments", and MQ6's prediction L was tested on the constant group, outside that clause.
    - So the result is the regime's-step end of T2's law and tests nothing T2 forbids, as the tests' account says ("not T2's three forbidden items").
    - Reading the second forbidden item "for yeast at a comparable horizon" sets the clause aside, and suggests that T2's own terms would count the result against it.
    - The problem the evidence shows is that the method chapter counts among T2's tests a result that cannot refute T2.
  - My first pass (I20) proposed the "read for yeast" reading without the refutation clause.
- *Evidence.*
  - `theories/becoming/chapters/02-MAP.md:267`: "*Refuted by*: any of these on survey series of fish stocks, grazed grassland, harvested forests, or yeast in deteriorating environments", and "*Standing*: conjectured, on the three frozen fish-stock tests above";
  - `08-METHOD.md:502`;
  - `experiments/margin-measured/README.md:224` (L, at a constant dilution);
  - the quotations at SCIENCES.md:422.
- *Fix.* For example: "[this dossier, AI] How MQ6 bears on T2 is not stated. At constant dilution the level alone was the whole state: the regime's-step end of T2's law, at which recent giving and the lag carry nothing. T2's refutation clause names yeast only in deteriorating environments, so this result is consistent with T2 but tests none of what it forbids, as the tests' account says. The method chapter's standing counts it among T2's tests; the home chapter's does not, though it lists the result as evidence."

**I32 (imprecision).** S-15 Standing (SCIENCES.md:419): "MQ4 passed 7 of 12, failing G3 (…), F5a, F10a, F10b and T2; … MQ7 passed 0 of 1, C2 not testable, on 62 episodes from 5 stocks."
- *What is wrong.*
  - MQ4's "T2" is a test label, not the thesis. It is the frozen-rest time to break ("half of the origins with n̂ ≤ 5 break within ten years", 0.32), a prediction about the withheld-levels margin. In T2's own item it reads as the thesis failing. S-14 labels MQ4's "T1" as a test label, and S-15 does not do the same for its "T2".
  - In the same sentence MQ7's failed prediction, C1, goes unnamed, and its sample (62 episodes from 5 stocks) reads as C2's.
- *Evidence.* `experiments/margin-measured/README.md:194, 230–231`; SCIENCES.md:399 (S-14's label).
- *Fix.* Write "… F10b and T2 (a test label: the frozen-rest time to break, half of the origins put within five years breaking within ten; 0.32)", and "MQ7 passed 0 of 1: C1 failed (0.39, lower bound 0.00, on 62 episodes from 5 stocks), and C2 was not testable".

**I33 (imprecision).** S-17 Meaning (SCIENCES.md:471): "Counted instead from the posterior at the time of choosing, a contrast case, a score favouring the second policy lowers the first policy's share strictly at every step (`ChoiceCountCapture.posterior_count_falls`)."
- *What is wrong.* The sentence is new in the fix.
  - `posterior_count_falls` is a one-step law, whatever the scale, with the hypothesis that carriers are present (`0 < x.carrier`).
  - Falling at every step is `posterior_course_falls`, which needs a positive fixed scale (`0 < s`).
  - Without that hypothesis, a zero scale with `κc = 0` leaves no carriers after one step, and the share then falls no further.
- *Evidence.* `Becoming/ChoiceCountCapture.lean`:
  - lines 50–52, the module's statement: "at that step, carriers present" and "along a course with a positive fixed scale at every step";
  - lines 388–391 and 399–400.
- *Fix.* "… lowers the first policy's share strictly at each step at which it has carriers (`ChoiceCountCapture.posterior_count_falls`), and at every step of a course at a positive fixed scale (`ChoiceCountCapture.posterior_course_falls`)."

**I34 (imprecision; from my first pass).** S-11, the [this dossier, AI] bullet (SCIENCES.md:317): "how often depensation is detected bounds from above how often the law applies".
- *What is wrong.* A gated renewal is depensatory, so how often depensation occurs bounds from above how often the law applies. How often it is detected does not, since depensation at levels below those observed goes undetected.
  - Myers et al.'s abstract says that their estimates of power strengthen the conclusion that depensatory dynamics "are not apparent for fish populations at the levels studied".
  - A need below the observed levels lies outside those levels.
  - The wording follows my first pass's fix for I11.
- *Evidence.* SCIENCES.md:29 (the gate); search records of the abstract of Myers, Barrowman, Hutchings and Rosenberg 1995 (*Science* 269:1106–1108).
- *Fix.* "… how often depensation occurs bounds from above how often the law applies; at the levels studied it has rarely been detected: significant depensation …".

**I35 (imprecision).** S-10, Known weaknesses (SCIENCES.md:279–281).
- *What is wrong.* The new regulation paragraph has no recorded weakness. Its records and sources state what they do not show:
  - "That a given system regulates a level, which level, how late it reads, or the size of its step."
  - "One policy keeping a band from every start in it under late reading; several regulated levels lumped into one; regulation of several conditions at once."
  - "That actual formations read only their own conditions."
  - From 02: "opposition alone permits overshoot".
  - From CG1's limits: "E is the law's own one-condition setting, not the commons' dynamics."
- *Evidence.*
  - `theories/becoming/results/records/two-sided-regulation-and-late-reading.md:33–34`;
  - `regulation-from-one-side-and-locally.md:26`;
  - `02-MAP.md:358`;
  - `experiments/commons-gated-renewal/README.md:69`.
- *Fix.* Add the first two and CG1's limit as known weaknesses.

**I36 (imprecision, minor).** S-06 (SCIENCES.md:172): "Each census and full embodiment are needed: … (`World.rest_needs_standing`: its first world has a census of what is active and none of what stands, its second every relatum embodied and no census of what is active)".
- *What is wrong.* The parenthesis is exact, but its second world bears on `World.arising_opens`. A separate witness shows that the rest theorem needs its census of what is active: in `attrition` nothing stands, every other premise holds, every step is enclosed around what stands, and ceasing recurs.
- *Evidence.* `Becoming/Openness.lean:85–91` ("Each census does work") and 626–631 (`rest_needs_census`).
- *Fix.* Add "; for the rest theorem's census of what is active, `World.rest_needs_census`".

**I37 (imprecision, minor).** S-12, Known weaknesses (SCIENCES.md:343): "It held in the simulated Allee yeast (…) and has not been measured in a real system." Q3 then asks whether it has.
- *What is wrong.* The bullet asserts what the question asks. The account supports only that the theory's tests have not measured it in a real system.
- *Fix.* "… and the theory's tests have not measured it in a real system."

**C13 (credit, minor).** README, the references table.
- *What is wrong.* The table covers "the works behind its own [this dossier, AI] statements". S-13's cost bullet rests on Gordon's open access and bionomic equilibrium (SCIENCES.md:378), yet Gordon 1954 has no row.
- *Evidence.* Search records: H. S. Gordon, "The economic theory of a common-property resource: the fishery", *Journal of Political Economy* 62(2):124–142 (1954), doi 10.1086/257497.
- *Fix.* Add the row.

**C14 (credit, optional).** S-05, Known weaknesses (SCIENCES.md:149): the quotation of the record's later work begins at Ladyman and others.
- *What is wrong.* The record's list begins with Bennett's 2003 notes (SHPMP 34). Their remark that Landauer's principle is in a sense a restatement of the second law bears directly on the item's verdict, and the first pass listed the work (C2).
- *Evidence.* `theories/becoming/results/records/merge-of-a-part-kept-by-the-rest.md:49`.
- *Fix.* Start the quotation at "Bennett (1973; SHPMP 34, 2003".

**C15 (credit, optional; for 08's owner).** S-22 Standing quotes 08: "autocatalytic sets are food-generated (Hordijk and Steel 2012)".
- *What is wrong.* "Food-generated" is the F of RAF sets. Hordijk and Steel formalized these in 2004 (*Journal of Theoretical Biology* 227:451–461, from a mirror listing; the publisher's page was not reached), and their 2012 papers extend the framework. So the year may point to an extension rather than to the definition. The dossier can keep the quotation, since the citation is 08's.
- *Fix.* None in the dossier; a note for 08's owner.

**St7 (style; from the kit, repeated in my first pass).** "How it was made" (SCIENCES.md:15): "the slowing-down law's three names (S-16) are written without backticks and its file is cited."
- *What is wrong.*
  - S-16 writes one such name, SlowingDown.need_margin_read (SCIENCES.md:446), and the reviewed version wrote none.
  - My first pass's St1 repeated the kit's "three names" without checking, and the fix put the number into the dossier.
  - The README's account of the checker's first run (README:39) may be right as history.
- *Fix.* "the slowing-down law's name in S-16 is written without backticks".

**St8 (style, minor).** S-14, Known weaknesses (SCIENCES.md:405).
- *What is wrong.* The bullet repeats the ledger line above it: "3 of 10 passed", with A1 and A2 failed and the same numbers.
- *Fix.* Keep only its [this dossier, AI] sentence on 08's standing, or merge the bullet into the ledger line.

**St9 (style; the kit).** README.
- *What is wrong.*
  - The outline says "635 lines as reviewed" (README:9). The reviewed file had 634 lines, as the Review section says (README:178).
  - In the references table, Boerlijst and others 2013 sits between Clark 1973 and Clark 1976 (README:151–153).
- *Fix.* Write 634, and move the row.

### Counts

| Kind | Number | Findings |
|---|---|---|
| Error | 1 | E4 (S-14) |
| Imprecision | 8, of them 1 major | I30–I37; major: I31 |
| Credit | 3 | C13–C15 |
| Style | 3 | St7–St9 |
| **Total** | **15** | |

Four of the fifteen go back to my first pass: E4, I31 (in part), I34 and St7.

### Verdict

**Offer after the named fixes.** These must be fixed before the dossier is offered:
- E4: MQ3's F3 in episodes, with its numbers.
- I30: the ledger lines name every failure, MQ6's six predictions are described rightly, and S-16's counts are given. The opening is narrowed where no classes exist.
- I31: the [AI] bullet on MQ6 is rewritten against T2's refutation clause and the method chapter's count.
- I32: MQ4's "T2" is labelled as a test label, and MQ7's C1 is named.
- I33: the posterior contrast is stated with its conditions.
- I34: "occurs", not "is detected".
- St7: one name, not three.

Each fix is a sentence or two, drawn from a source the item already cites. None needs Lean or changes a verdict of the theory. I35 and C13 should go in with them; I36, I37, C14, C15, St8 and St9 are optional. The fixes can be checked against the lines given here, without a third full pass.
