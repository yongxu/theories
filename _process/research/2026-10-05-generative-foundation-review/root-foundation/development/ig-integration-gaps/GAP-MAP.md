# Gap map: where the account is not yet one picture

AI-written (the synthesis agent of the integration scan, 3 November 2026; see [README](README.md)).

Repository root is `/Users/ren/theories`. These abbreviations are used in the paths below:
- `ch/` = `theories/becoming/chapters/`
- `rec/` = `theories/becoming/results/records/`
- `R/` = `_process/research/2026-10-05-generative-foundation-review/root-foundation/`
- `D/` = `R/development/`
- `L/` = `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`

Each item's priority is the verifier's priority. Where a verifier gave corrected wording, the item uses it. I merged duplicates across the nine slices; the source slices are in brackets.

Zhuang and Hadfield-Menell is left out because another session is handling it. Item 7.9 sits next to that case and should be coordinated with it.

---

## Theme 1. What the fronts and summaries tell a reader

**1.1 [high] README summarizes the ethics without C.** README.md:166 says "Under the continuation condition, living significance and explicit practical commitments support comparison…". That contradicts README.md:13 and :93 and breaks the AGENTS rule to name both premises.
- Files: `README.md:166`, generated from `_process/goals/universal-intelligence-session.json:54`; also `GOALS.md:318`.
- Work: text revision in the goal JSON, re-render, and check the other generated goal summaries for the same omission.
- Effort: S. [fronts]

**1.2 [medium] The opening still makes two overclaims that 08 lists for the chapters.** OPENING.md:17 says "There is no absolute self" and :25 says "It shows why alignment is hard, and how hard"; README.md:35/43 renders both. 08's list of prose that says more than the theorems (ch/08-METHOD.md:538-540) covers only the chapters. The opening's notes ([^self] OPENING.md:69, [^alignment] :83) ground the sentences in other theorems. No text reconciles the two.
- Work: text revision, either in place under OPENING's header rule or by extending 08's list. The alignment half touches the ZH session.
- Effort: S. [fronts]

**1.3 [medium] The fronts use two measures of "one account".** README.md:146-148 says "nothing formal remains". That is measured on the exchange base (OverExchange, 33 central laws, ch/01-ROOT.md:281). ONE-PAGE.md:11 and THE-THEORY-OF-BECOMING.md:11 measure against the grammar root (ch/08-METHOD.md:440-452: 11 derived, 99 at a named distance). 08 §7 relates the two; no front does. "Spine" is undefined (GLOSSARY.md:38).
- Work: one sentence on the two bases in ONE-PAGE and overview §10, scope README's claim, add a glossary entry.
- Effort: M. [fronts]

**1.4 [medium] README's research-line blocks are stale.**
- README.md:178 lists as "Next" items that have landed: groups on coupled conditions (ch/04-LIFE.md:199), the additive part of Fisher's theorem (:177) and drift (:226).
- README.md:188 says LA4 is "still to be built, frozen and run", but ONE-ARGUMENT.md:13 says "Stage A frozen".
- The "Established results" lists are peripheral early records.
- Work: refresh `_process/goals/theory-of-evolution.json` and `generative-alignment.json` against the home sections, then re-render.
- Effort: M. [fronts]

**1.5 [medium] Two development pages were not re-synced after the C and LA4 corrections.**
- `D/aj4-alignment-readers/FAILURE-MODE-MAP.md:9` and `:230` say "every ranking needs C" and present it as chapter 7's wording; 07 no longer contains the phrase.
- `FAILURE-MODE-MAP.md:259` says "no prediction is frozen".
- `D/aj-joint-selection/PLAN.md:63` says LA4 has "nothing frozen or run". PLAN is linked from theories/becoming/review/ALIGNMENT.md:7.
- Work: text revision (C or a premise in its place, `Weighting.ended_below`; Stage A frozen).
- Effort: S. [alignment]

**1.6 [medium] No front says any containment forbids something.**
- "Third part", the FEP's five forbidden statements and 08's four table third parts appear in none of README, ONE-PAGE, the overview, ONE-ARGUMENT or OPENING.
- The FEP page appears only as a link at THE-THEORY-OF-BECOMING.md:11.
- Overview §3 (THE-THEORY-OF-BECOMING.md:83-93) omits the blanket and free energy that ch/03-KNOWING.md:44-58 has.
- 08 itself folds the third parts into its verdict (ch/08-METHOD.md:552-559), so this is a gap in how the fronts summarize 08.
- Work: text revision on the fronts.
- Effort: S. [fronts]

**1.7 [low] The glossary claims one sense per word but lacks the words AGENTS sends readers to it for.**
- GLOSSARY.md:3 claims "each in one sense". It has 0 entries for recognition, motivation, compliance, implementation, direction, capacity, maximization, room, regime, point of no return, embodied and spine.
- "Coupling" carries two senses (GLOSSARY.md:37 against :45).
- "Reading" carries three technical senses in 03 with no entry: a class of runs (ch/03-KNOWING.md:195), a world-by-state relation (:525, :555), and being read by another (:515).
- Work: glossary revision.
- Effort: S. [fronts, knowing]

**1.8 [low] Some names state another law's meaning; the text already flags them.**
- Records `unceasing-generation-needs-renewal` and `whole-persists-through-generation` are laws of arising (ch/02-MAP.md:147, ch/04-LIFE.md:42).
- The spine's "the first law" for `Flow.Gainless` (ch/02-MAP.md:10) sits beside the anchor `r-balance-from-the-first-law` (ch/01-ROOT.md:297).
- Work: renames, keeping the former ids.
- Effort: S. [root-map]

## Theme 2. Selection as one law: evolution, training, capture, institutions

**2.1 [medium] MA3's "p never changes that direction" holds only at zero assortment of the shared part.**
- The claim appears at theories/becoming/review/ALIGNMENT.md:13, GOALS.md:104 and ch/02-MAP.md:411.
- The complete-assortment end is joined (L/PairSelection.lean:58-60; D/el-evolution-on-the-root/WS.md:207-212).
- No law states MA3 as a case of `SelectionLevels.rises_iff_returns` (ch/04-LIFE.md:207). Under positive assortment among shapers, p could select shaping where c > s.
- Work: a Lean law (MA3 as Hamilton's rule with assortment-weighted p), then narrow the scope in ALIGNMENT, GOALS, 02 §9 and 07 §6.
- Effort: M. [life]

**2.2 [medium] Capture under noise is marked open but not joined to 04's own pieces.**
- It is declared open at ch/02-MAP.md:467, COLLECTIVE-DIRECTION.md:55 ("cited, not proved") and ch/02-MAP.md:438 (long-run risk dominance stated).
- 04 §6 already proves sampled draws, absorbing ends, Moran fixation with weights a and b, and mutation (ch/04-LIFE.md:226-229). RuleCapture, DrawnShaping and ClosedCapture have zero drift or fixation hits.
- T7's "for good" (ch/02-MAP.md:428) carries no noise caveat.
- The §9 models are not sorted into those whose lock survives noise (accumulating counts; Arthur's urn, rec/shaping-read-by-readers-drawn-from-the-selected.md:60) and those whose lock noise can leave (constant hi, lo, c). No exit time is given.
- Work: containment of KMR/Young from 04's laws, the T7 caveat, a forbidden case on noise-driven exit.
- Effort: L. [life, root-map]

**2.3 [medium] "Exponential pace" is not joined to the Malthusian bound.** OPENING.md:98 [^present] and rec/mutual-dependence-and-its-pace.md:26, :68 give (a/b)^n. They are not joined to 04 §4's inflow bound (ch/04-LIFE.md:163-174): a ratio that rises that fast needs carried inflow.
- Work: one two-sided statement and links in OPENING, 05 §1 and the record.
- Effort: S. [life]

**2.4 [medium] One two-kind share law is proved five times with no adapter to SelectionTerm.**
- The five: L/Capture.lean:14-21, L/RuleCapture.lean:8-30, L/Reproduction.lean:738-743 (`Mutation.rises_iff`), `MutualDependence.share_ratio_pow`, and the market Euler step (rec/market-model-share-margin-and-ends.md:58).
- Capture.lean's header is stale: it says Price's selection term is unstated, but SelectionTerm states it.
- The letter `m` means margin in RuleCapture and mutation loss in Reproduction.
- Work: Lean adapters to `SelectionTerm.exceeds_iff` (as PairSelection already does), and a header fix.
- Effort: M. [life]

**2.5 [medium] The evolutionary-suicide witness uses a label, not a draw.**
- The witness is at ch/04-LIFE.md:143.
- It is not linked to 04's confined-rise law (`Founding.Flow.ConfinedRise.ends`), which already joins selection within to a gated family's excess and its end, or to `LineageRegimes.degeneration_of_family_excess`.
- 04's Open list (ch/04-LIFE.md:316-327) omits it, and the sources are unread (D/el-evolution-on-the-root/NOTE.md:202-204).
- Work: links, a witness on a draw, read the sources.
- Effort: M. [life]

**2.6 [medium] Whether a capture loop is 生成 is left open.** The question is at ch/02-MAP.md:444 and :466. EL's LineageRegions could decide it once a capture loop is stated as Descended generations on a World flow. The EL note does not record the question.
- Work: a World model of a capture loop, then apply EL's laws.
- Effort: M. [life]

**2.7 [medium] The replicator–Bayes identity is absent where 03 says reproducing and training are one selection.**
- 03's conditioning by restriction (`ConditionalWeights.restrict_two_ways`, ch/03-KNOWING.md:252-254) and 04's selection term are one counting identity: posterior ∝ prior × likelihood is new share ∝ share × fitness (Harper 2009; Shalizi 2009; Czégel et al. 2022).
- Also absent: Fisher's theorem as a Shahshahani gradient, and Frank's information-theoretic reading.
- Already present: Watson et al. (ch/04-LIFE.md:268) and Frank 2012 as the Price form.
- Work: a short Lean law and an 08 §8 row.
- Effort: M. [life]

**2.8 [medium] Cooperation sits in two chapters and the dossier with no join.**
- 05 §5's pair law (ch/05-COLLECTIVES.md:130-136) reuses 04's multilevel law in Lean (rec/offspring-read-from-giving-that-waits.md:76-78), but the chapter does not link 04's Hamilton's rule (ch/04-LIFE.md:206-207).
- No law is stated at partial assortment, 08 §8 has no reciprocity row, and indirect reciprocity is not placed.
- The dossier's A-04, "restraint is no mutual best response" (theories/becoming/review/ALIGNMENT.md:132, open Q1 :140), is not set beside the reciprocity laws. Yet the dossier names cooperative AI as its audience (:3). Dafoe 2020 appears only in R/COLLECTIVE-DESTRUCTION-INTEGRATION.md:51.
- Work: links, a partial-assortment law, an 08 row, a dossier item.
- Effort: M. [collectives, fronts, alignment]

**2.9 [low] Position is Price's selection term, weighted.** n·Σwa − ΣwΣa = Σw·position. L/RelativePosition.lean and L/SelectionTerm.lean do not import each other. Schaffer and Hamilton's spite appear only in rec/a-race-for-position-draws-everything.md:57.
- Work: a one-line Lean identity and links at 05 §3 and 04 §4.
- Effort: S. [collectives]

**2.10 [low] The template-and-successor law is not joined to `Becoming.price`.** This is self-declared at ch/04-LIFE.md:129.
- Work: a core adapter.
- Effort: S. [life]

**2.11 [low] Capture's attractor and threshold vocabulary is not tied to §2 and §5's laws.**
- The meta-attractor (ch/02-MAP.md:402) is not stated as drawn in §2's sense (`Law.drawn_iff_not_returns`).
- Two perturbation laws with the same hypothesis, `Law.perturbation_drawnInto` (02:76) and `Law.perturbation_reabsorbed` (02:391), are not related.
- The critical mass and the read-in-time window are not placed under §5's threshold law (02:262).
- Work: corollaries and text.
- Effort: S. [root-map]

**2.12 [low] Cultural evolution is not named beside the account's transmission and institution laws.** Dual inheritance, conformist transmission and Henrich's population-size threshold are absent beside 02 §9's counted-choice capture, 05 §12's institution and 04 §8's transmission. The field appears only as a contrast in theories/meta-attractor/README.md:91.
- Work: a mapping note and 08 rows.
- Effort: M. [fields-sweep]

## Theme 3. Knowing, inference and the closed loop

**3.1 [medium] Closed-loop non-identification is stated twice and never joined.**
- 02 §9: closed capture (ch/02-MAP.md:386-447, `ClosedCapture.courses_alike_iff_unread`), credited to Borkar–Varaiya at ch/08-METHOD.md:505.
- 03 §12: the untested model (ch/03-KNOWING.md:530-532, `ReadingLoop.alike_within` / `sensed_alike_iff`), credited to Fudenberg–Levine and Rothschild at 08:524.
- They are joined only by audit row 16 (D/ue0-third-parts/AUDIT.md:31) and 03:384's bare pointer.
- The exits are not unified: 02 offers a reading of the loss, 03 offers "an act that risks the task, or a reading from outside". T7's list (02:428) omits experimentation.
- Fudenberg–Kreps 1993 and persistent excitation are stated against neither.
- Work: a Lean bridge plus containment of the experimentation remedy, which gives T7 a refuter that can be met.
- Effort: M. [root-map, knowing]

**3.2 [medium] "Seeking corrects within what some experiment separates" rests on one witness.**
- 03:272 makes the claim; it is shown only by a three-coin witness (`LumpedSeeking.Agree.seeking_turns_tails`).
- No posterior-consistency result backs it (Doob 1949; Blackwell–Dubins 1962).
- Berk 1966 and Berk–Nash (Esponda–Pouzo 2016), the probabilistic counterpart of 03:532's witness and of Carey at 03:547, are absent.
- Work: a consistency law in counts on finite hypotheses with a rate, or narrow 03:272; add the Berk–Nash correspondence.
- Effort: M. [knowing]

**3.3 [medium] EFE's epistemic value is not joined to Good's value of evidence.**
- 03:267 (epistemic value) and 03:547 (Good) are unrelated; the log-score identity (Bernardo 1979) is absent.
- No text asks whether an EFE chooser takes the separating, untried act in `ReadingLoop.Untested`. That decides 03:272's positive half for active inference's own policy rule.
- The dual effect is at 03:422 but credited only in rec/when-to-inquire-and-when-to-respond.md:63.
- Work: a law on the Untested witness, a third-part candidate against "epistemic value resolves uncertainty".
- Effort: M. [knowing]

**3.4 [medium] Pearl is credited "restated" without saying which part.**
- ch/08-METHOD.md:489 gives the unqualified credit.
- What is restated (non-ancestor invariance) is stated only in AUDIT.md:114-120. The exclusion of identification and the do-calculus is only in rec/causal-models-as-processes.md:39.
- 03's own "a control is the model the step factors through" (03:137) and the Confound witness (03:140) are not related to adjustment.
- Work: revise the 08 row and add a 03 §3 sentence (S); a deterministic back-door law is optional (M).
- Effort: S/M. [knowing]

**3.5 [medium] The supervisory-control mapping was done in studies and never reached the chapters.**
- 08:582 credits Ramadge–Wonham and Lin–Wonham.
- The mapping exists in R/BECOMING-SIGNIFICANCE-REVIEW.md:170-203, whose own line says "Integration: none", and in AUDIT.md:234-240 (selection = observability's necessity; pools = centralized supervision).
- Co-observability (Rudie–Wonham 1992) is the decentralized, harder case of pooling (review:184). None of this is in 03 §1, 03 §12 or 05 §8.
- The common-response existence law (03:555, «共应当且仅当所闭之承遍», «所闭之承最大») credits only Aubin and Ashby (rec/a-response-common-over-a-reading.md:64). It is not compared with the controllable-and-observable existence theorem or the supremal controllable sublanguage.
- Work: containment with a third-part check, landing the study's mapping.
- Effort: M. [knowing, method-meta, fronts]

**3.6 [medium] Regulation and requisite variety are three readings, not one law.**
- "Requisite variety" is attached to 02 §8 regulation (08:503), 03:527 and 03:557, with no stated relation; 02 §8 and 03 §12 do not link.
- The one-reader law's third part (pinwheel windows; AUDIT.md:30, :186-192) is missing from 08's third-parts list (08:553-559) and from 03:84.
- Ashby's counting form is absent, and Touchette–Lloyd's information form is not named (08:523 has only the data-processing inequality).
- 02 §8's regulation is never called a loop or related to 02 §7's closing-loop law (02:343). 01:35 illustrates feedback with a thermostat but links runaway loops. Maruyama appears only at 08:493.
- Work: one regulation entry with its cases, a counting corollary in the core, the third part added to 08's list.
- Effort: M. [knowing, fields-sweep, root-map]

**3.7 [low] Blackwell's two deterministic forms are not linked.** `Learning.Training.keeps_through_iff` (03:359) and `informed_le` (03:550) do not refer to each other, and the every-decision converse is neither stated nor noted as open.
- Work: a link plus the converse law.
- Effort: M. [knowing]

**3.8 [low] 03:207's "not shown" converse is Kelly's classical theorem.** The chapter does not say it is Kelly's classical Σ⁰₂ characterization (rec/what-a-method-comes-to-say-in-the-limit.md:39, :65) or what blocks it constructively. Gold's negative theorem and Angluin's tell-tale condition are absent.
- Work: text and a calibration.
- Effort: S. [knowing]

**3.9 [low] The weighted lumping law may already give the EFE record's "Next".** `Weights.lumped_iff` (ch/01-ROOT.md:566) is not cited by 03 (03:179) or by the EFE results. The EFE record's Next, "many-step form with lumpable transitions" (rec/expected-free-energy-and-its-terms.md:71), is unchecked against it.
- Work: check, then Lean if it follows.
- Effort: M. [knowing]

## Theme 4. Persistence, the map and its dynamics

**4.1 [high] T2 is not set against the field that measures its quantity.**
- T2 (ch/08-METHOD.md:567) forbids "a fourth variable removing a tenth of the residual variance in the median series" across fish stocks.
- Empirical dynamic modelling and delay embedding measure exactly that: Sugihara and May 1990; Sugihara et al. 2012; Glaser et al. 2014. These are from prior knowledge and were not re-read.
- They are absent. Takens appears only at experiments/state-named-in-advance/DESIGN.md:21, :545, and ch/02-MAP.md:281 credits only delay-difference models.
- Work: literature reading, place T2's numbers against published embedding dimensions, design the next frozen test on out-of-sample skill.
- Effort: M. [method-meta]

**4.2 [medium] No 08 §8 verdict for the root theorem or the map's regions.**
- These are the two results the fronts lead with (ONE-PAGE.md:11; THE-THEORY-OF-BECOMING.md:67, :75), yet 08's table (08:484-496) has no row for either.
- The core as greatest bisimulation is stated only at 01:104 and rec/continuation-relative-to-a-class.md:80.
- 延, 后守 and 生成 are not related to greatest-fixed-point path properties (EG, EFG, EGF), nor 尽 to well-foundedness or AF (partly at rec/degeneration-from-a-horizon.md:64). The LPO/WLPO calibrations are not tied to the known Σ/Π cost.
- Work: 08 rows and a mapping note, then the third-part question for «阶生成则上不退化».
- Effort: S. [root-map]

**4.3 [medium] 02 proves generation and arising-needs-renewal but never composes them.**
- 02 never composes 全生成 under passing (02:47, `Web.generation_arises_late`) with arising needing renewal (02:145-158).
- The composed law, `Flow.not_generation_of_dissipated_requirements`, appears only at ch/07-SIGNIFICANCE.md:97 and rec/what-keeping-widening-needs.md:37.
- 02:52's list of where later laws meet the map omits it, and Prigogine appears only at 08:494.
- Work: text, and move the law home to 02.
- Effort: S. [root-map]

**4.4 [medium] Margin and point of no return are not set against resilience theory.**
- 02:242 and :252, T1 and T6 are not set against Holling 1973, Walker et al. 2004 (precariousness and basin) or Dai et al. 2015 (stability against resilience).
- The mapping exists only in R/BECOMING-SIGNIFICANCE-REVIEW.md:332. 08:504 credits only Clark and May.
- The invariance kernel is joined (03:555; ch/05-COLLECTIVES.md:349; L/Viability.lean:19-82).
- Work: containment with a third-part question (T1's joint-draw clause).
- Effort: M. [fields-sweep]

**4.5 [medium] Life's definition cites no framework.**
- 04:20 says "Life is continuation that renews its own conditions" with no citation.
- The organism model is placed below autopoiesis, closure of constraints and Rosen (04:262; D/og-organism/DESIGN.md:24-26; rec/the-stock-buys-time-where-the-rebuild-draws-on-it.md:56), but the three gaps are not in 04's Open list.
- RAF sets are joined only to 07 §2 (08:514). Enactivism is absent at 03:522.
- Work: citations, Open items, an attempt at the first gap (two mutually rebuilt readers).
- Effort: M. [fields-sweep]

**4.6 [low] The viability kernel, the dual of the joined invariance kernel, is never named.** 02 §1's 延 and 02 §2's largest sub-process keeping s (02:17, :81) are viability kernels. They are not named so or related to the invariance kernel, and the juncture and point of no return are not placed as kernel boundaries.
- Work: a Lean duality lemma and links.
- Effort: M. [root-map]

**4.7 [low] The converse of rest has a known classical form.** 01:170's "Not shown" converse is not identified as the classical, choice-dependent completeness of ranking functions and converse Lyapunov theorems (rec/rest-exactly-where-falls-stop.md:59). Conley's recurrent/gradient decomposition is uncited.
- Work: text; a finite Conley law is optional.
- Effort: S/M. [root-map]

**4.8 [low] Nets are mapped on conservation only.** 01:218 and rec/place-transition-nets-on-the-spine.md give no liveness ↔ 全生成, T-invariants ↔ return, or Commoner siphon–trap ↔ degeneration.
- Work: a Lean instance.
- Effort: M. [root-map]

**4.9 [low] The dropped stronger direction hypothesis has measurable rivals.** At 08:779 it is dropped because it forbids nothing measurable. MEPP (Dewar 2003), maximum power (Lotka 1922; Odum), Chaisson 2001 and ZFEL (McShea–Brandon 2010) are not used to give it runs and rates or to act as its rival.
- Work: a short study.
- Effort: M. [method-meta]

## Theme 5. Collectives, commons and institutions

**5.1 [high] "Restraint is no mutual best response" travels without its hypothesis.**
- `Optimum.MutualBest.full` holds where the condition lies beyond every optimizer's family. 05:202 and rec/several-optimizers-drain-by-their-joint-capacity.md keep that hypothesis; ch/07-SIGNIFICANCE.md:699 and COLLECTIVE-DIRECTION.md:50, :68 drop it.
- 07:699 also sits beside "restraint by all is also an equilibrium", so a reader sees a contradiction.
- The other side of the boundary is proved but not landed: D/ue6-beyond-the-sciences/ROUND-3-CANDIDATE-4.md and its tree/Becoming/CoupledDrawers.lean. Drawers in turn keep the need exactly where c > m; drawing at once with no pivotal drawer, the drain holds at every rate.
- Round 3's correction has not been made: COLLECTIVE-DIRECTION.md:51 still offers `Optimum.frontier_keeps_stepwise` as a collective exit.
- Work: text revision at three places, land CoupledDrawers (claim it on the board), fix the exit.
- Effort: M. [collectives]

**5.2 [medium] "Externality" and "prices" are named as unified, but only Goodhart is linked.**
- 08:585 names "overshoot, externality and Goodhart's law as one law of the optimum under room", labelled a conjecture (T3). Only Goodhart is linked (03:29), and 05 §7 (05:160-222) names neither overshoot nor externality.
- Only a reading at 05:336 maps externality onto what a selection does not couple into.
- Pigou 1920 appears only in R/BECOMING-SIGNIFICANCE-REVIEW.md:53, not in 08's row (08:494). Coase, Meade, the welfare theorems and mechanism design are absent.
- The coupling laws are the Pigouvian remedy in substance, but no text says so: `Optimum.frontier_keeps_stepwise`; rec/a-step-coupling-keeps-at-every-horizon.md:63; exact penalty in rec/keeping-forgoes-the-renewal-at-the-need.md:66. UE6 round 3's drawers result, the third part against a static Pigouvian rate, is unlanded.
- "Prices" (08:582) has no instance: experiments/market-generativity/formal/MarketInstances.lean:1-5 instances viability and lasting only. Its replicator share law (rec/market-model-share-margin-and-ends.md:58) is not shown as 04's selection term.
- Work: containment in 05 §7 with a third part; prove "prices" or narrow it.
- Effort: M. [collectives, method-meta, fields-sweep]

**5.3 [medium] Ostrom's mapping exists in studies and never reached the theory.**
- In the theory she is only an aside: 05:404, 05:424, rec/several-optimizers-drain-by-their-joint-capacity.md:56, rec/significance-through-a-common-condition.md:55.
- The RF plan maps monitoring onto `ClosedCapture.Drawn`, `ReadInTime` and RF6.1 (D/rf-formations-that-read/PLAN.md:265). AUDIT.md:288 and :364 have related readings.
- None of this reached 02, 05, 08 §8, the audit's rows or COLLECTIVE-DIRECTION's exits (:44-53).
- The fronts credit the commons to Hardin only (ONE-PAGE.md:17; THE-THEORY-OF-BECOMING.md:109; 08:490).
- Cox, Arnold and Villamayor-Tomás 2010 is not used as evidence. The gap was flagged at R/BECOMING-TWENTY-FIRST-REVIEW.md:249.
- This would be a partial containment, since sanctions and collective choice are not modelled (05:402).
- Work: a principle-by-principle containment table, plus a T1 field design on long-enduring common-pool resources.
- Effort: M/L. [collectives, method-meta, fronts, fields-sweep]

**5.4 [medium] Common knowledge and the jury theorem are absent from the pool laws.**
- "Common knowledge" occurs in no chapter or front. 05:244's "as with distributed knowledge" is uncited.
- Aumann is a recorded debt (D/rf-formations-that-read/PLAN.md:268). Lewis 1969, Halpern–Moses 1990, Rubinstein 1989 and Chwe 2001 are absent, and the 02 §9 stag hunt has no epistemic half.
- The Condorcet jury theorem and its failure under dependence are not named, though the independent-causes and copied-witness laws make that point. May and "Condorcet-style" majority appear only in rec/a-swap-symmetric-assignment-singles-out-none.md:48 and rec/a-pool-read-by-its-majority.md:47.
- Common knowledge should be framed as a known condition for some coordination tasks, not all.
- Work: a grammar statement of common knowledge, a witness that pooling does not give it, and landing Aumann.
- Effort: M. [fields-sweep, collectives]

**5.5 [low] The horizon optima have no 08 verdict and their test was never frozen.**
- 05 §7(b) and (c) have no 08 §8 verdict; 08:504 covers only the regime margin.
- The audit's frozen-test design for (f) to (h) (AUDIT.md:275, :288) is not carried into T3 or 05's Open list.
- The records already name the sources and the third part (rec/horizon-optima-hold-the-greatest-renewal.md:63).
- Work: an 08 row, and freeze the test design.
- Effort: S/M. [collectives]

**5.6 [low] Institutions are three models with partial links, and one ending law has five carriers.**
- 05 §12 (05:386-404) links 04 §8's organism but not 04's RuleHandoff (04:246-248) or 02's readers-drawn-from-the-selected laws. The full join is the open item at 05:417.
- "A take above renewal ends it" stands on five carriers (05:23, :203, :386, :398; 02:251; 04:199). Several are joined by rest by balance and lineage regimes. §12's lemma and the re-optimizing course are only "related, not a proved adapter", and §12's bridge is listed as unproved (05:402).
- Work: a joining record and a bridge lemma.
- Effort: M. [collectives, fronts]

**5.7 [low] "One law, three faces" is one theorem for two faces only.** The unit-transfer law (L/Optimum.lean:67; `beyond_of_ranked`, `transfer_exceeds`) unifies the one-step forms and `MutualBest.full`. Face (b), `frontier_of_gainsMost`, and the drawers in turn are separate arguments (05:160-162).
- Work: a generic lemma, or retitle the section.
- Effort: M. [collectives]

## Theme 6. Ethics: C, its warrant, social choice

**6.1 [medium] Arrow's theorem is missing where the account says mixed comparisons need further premises.**
- 07:345 reads C as Pareto unanimity. COLLECTIVE-DIRECTION.md:76 says "Practical choice among them needs J1–J4".
- Arrow's theorem (with Sen's Paretian liberal and Gibbard–Satterthwaite) is the known reason a Pareto quasi-order cannot be completed under IIA and non-dictatorship. It is not stated.
- 08:582's "votes" brings in no voting theory.
- Work: a 07 §5 note saying which Arrow condition each J relaxes; a Lean witness on three courses.
- Effort: M. [fields-sweep, collectives]

**6.2 [medium] The capability approach is never weighed against C.**
- Nussbaum and "capability approach" are named nowhere in chapters, records or fronts. The only mentions are R/BECOMING-RENEWAL-READING.zh.md:394 ("not connected") and the foundation-assessment GOVERNANCE-LITERATURE.md:63.
- Sen 1985 is credited at 08:516 and the intersection approach at 07:343.
- The approach is not weighed against C's open warrant (open item 12), the J1/J2 threshold, or the condition's scope beyond humans (Nussbaum 2006).
- The "unwanted option" objection is already carried in substance by T5 (07:740; OPENING.md:77).
- Work: a 07 §4 paragraph and an 08 row.
- Effort: S/M. [significance, method-meta, fronts]

**6.3 [medium] "Quasi-option value is not captured" is true of covering, but 03 §12 captures it.**
- 08:516 and rec/what-a-course-keeps-reachable.md:73, :107 make the claim.
- 03 §12's holding-for-a-reading law captures deferral with learning (03:547; L/HeldForReading.lean:327-398, `after_lt_after_iff`). No text joins the two.
- This places quasi-option value in the account. It does not supply a reason for C: the argument needs a later chooser, which 07:343 already counts as C relocated.
- Work: a correspondence, and revise "not captured".
- Effort: S/M. [significance]

**6.4 [medium] 06 reports no law for a question 07 has largely answered.**
- ch/06-CLASSICAL-TEXTS.md:425 says "无律" (no law) for whether a closure-graded order is the same from every standpoint.
- 07 proves the two-valued case exactly (07:300, `ownClosure_standpointInvariant_iff_centersWithin`) and a sufficient condition for grades (07:361, `ranks_alike_of_gradeInvariant`).
- Only a necessary condition for graded closure levels is open.
- Work: link, revise the row, state the open part exactly.
- Effort: S. [significance]

**6.5 [low] Self-concern and 05's rising order have the same shape but are unrelated.** 07's `increasingInOwn` and 05's `Optimum.Rising` are not related in text or Lean. A bridge from admissions to levels would be a new theorem; 07:358 has the weaker reversal.
- Work: a new Lean law.
- Effort: M. [collectives]

**6.6 [low] 06's 丁 sentences could serve as a T5 refuter corpus.** The 619 + 33 evaluative sentences (06:71) are counted by design. No study reads them as a T5 refuter corpus on Becoming.Hexagrams.
- Work: a test design, to be frozen.
- Effort: M. [significance]

**6.7 [low] Chichilnisky's second pole and the non-constructivity results are missing.** Her dictatorship of the present is not linked to the bounded-in-time rival (07:30, a loose analogy). Zame 2007 and Lauwers 2010 are absent, and their bearing on the pure core is unshown.
- Work: text.
- Effort: S. [significance]

## Theme 7. Alignment

**7.1 [medium] C as option-keeping, and power-seeking: the tie is made, but not where readers look.**
- The tie between C and option-keeping (POWER, relative reachability, AUP) is made at 07:651 (D65), rec/own-widening-within-the-margin.md:62, ONE-ARGUMENT.md:75 (SE1) and AUDIT.md:106.
- It is not made at C's definition (07 §4) or at covering (07 §2; rec/what-a-course-keeps-reachable.md). 08:488 and :555 credit only Pattanaik–Xu, so 08 never says its one alignment third part answers power-seeking.
- The dossier never cites `Flow.Balances.widens_iff_others_within`; it mentions Turner only at ALIGNMENT.md:119.
- The three halves of instrumental convergence are unjoined, and ALIGNMENT.md:121 says so: resource-keeping, option-keeping, and goal-content integrity (08:527).
- Retargetability is absent. Offsetting and interference incentives are not brought to C. The audit's shared-resource option-gain test was never designed.
- Work: an 08 row, a dossier item, text at C's definition, a test design.
- Effort: M. [significance, method-meta, alignment, fields-sweep]

**7.2 [medium] "One law in eight cases" has no law.**
- 07:637 makes the claim, but no statement of the one law exists.
- what-a-finite-history-refutes, seeking-boundary, how-a-carried-difference-grows and counterfactual-is-the-course carry no dependency on selection-through-couplings. runaway-distance-uncoupled is "related, not a proved adapter" (rec/selection-through-couplings.md:103).
- This repeats a pattern already withdrawn (D/ue17-free-energy/NOTE.md:66).
- Work: rewrite as eight laws, saying which share the selection law.
- Effort: S. [significance]

**7.3 [medium] The joint selection, the unit of alignment, is not one object.**
- PLAN.md:9 and ALIGNMENT.md:7 make it the unit. Conditions 1 and 2 are joined (PLAN.md:28, MA4 and MA4b).
- Condition 3 (widening) is joined only by HeldPossible's reading (COLLECTIVE-DIRECTION.md:111).
- No law compares a locked course with an accountable one by widening, and no model has distinct kinds of selector. PLAN §3's "Missing" (:72-74) omits this.
- Work: a Lean law giving the capture loss content on the World; a PLAN text update.
- Effort: L. [alignment]

**7.4 [medium] No law for KL-regularized objectives or quantilizers.**
- There is a threshold law for a lump coupling (rec/keeping-forgoes-the-renewal-at-the-need.md:66; 05:207).
- There is none for reward − β·KL to a reference (only LA4's P5 reading, experiments/drain-beyond-the-reward/DESIGN.md:153) or for quantilizers (rec/what-a-set-point-optimum-does-beyond.md:79, :101).
- Gao 2023 and Pan 2022 sit as "Outside" (05:236), with only DESIGN.md:280 noting that the axes differ.
- Deployed RLHF optimizes this objective, so T3's nearness is undefined for it.
- Work: a discrete exp-tilt law and a T3 forbidden case.
- Effort: M. [alignment]

**7.5 [medium] Two points of no return are never compared.** Condition 2 is worded for the loss's point of no return. In MA4b it is read as the share's (PLAN.md:17). No model ties the bound N to `RegimeMargin.ends_iff_below`, and COLLECTIVE-DIRECTION.md:96 lists both deadlines unordered. Collingridge's first horn is left as the premise N (ALIGNMENT.md:375).
- Work: a Lean join of ReadInTime and RegimeMargin, with both orders witnessed.
- Effort: M. [alignment]

**7.6 [medium] Shaping the evaluator (A-10) and revaluing the reader (A-20) are unrelated.** A-10's RuleShaping and A-20's revaluing (ALIGNMENT.md:303, :588, :617-625; 03:552) are not related. The split between reward-function and reward-input tampering, and decoupled approval (Uesato 2020), are absent.
- Work: a mapping note and a join law.
- Effort: M. [alignment]

**7.7 [medium] The principal-and-assistant reading is not stated against CIRL.**
- 07:671 is CIRL's common-payoff case, not stated against Hadfield-Menell et al. 2016 or multi-principal assistance. Assistance games are named at ALIGNMENT.md:23, and the off-switch game and IRL limits are read (03:507, :547).
- Weak-to-strong generalization (Burns 2023) is absent, and the converse of A-06's pooling bound is not posed.
- Work: a seventh approach in rec/alignment-approaches-under-the-selection-laws.md, with the drain law applied.
- Effort: M. [significance, alignment]

**7.8 [low] Corrigibility and accountable revision are linked only indirectly.** `RevisionRoutes.revised_maximal_iff` (07 RR, RR2) and condition 1's accountable revision (PLAN.md:16) are related only through HeldPossible (FAILURE-MODE-MAP.md:217; COLLECTIVE-DIRECTION.md:111).
- Work: one table of the four senses of revision.
- Effort: S/M. [alignment]

**7.9 [low] The Goodhart-variant mapping never left its study.** Skalse 2022, Karwowski 2024 and extremal Goodhart are mapped at R/BECOMING-SIGNIFICANCE-REVIEW.md:569-572. The mapping never reached rec/what-an-optimum-does-beyond-what-couples-in.md:67, the chapters or the dossier. Regressional Goodhart has no counterpart because every capture law is noiseless.
- Work: land the mapping, coordinated with the ZH session.
- Effort: S. [alignment]

**7.10 [low] The failure map's capture rows have no instance theorem, and "pool" has two senses.** The rows reach the closure law by Lean dependency (FAILURE-MODE-MAP.md:9; rec/closed-capture.md:18). No instance theorem maps the counts model's unread loss onto World's beyond-the-closure (L/PoolCourse.lean:40, docstring only). "Pool" is used in two senses (ALIGNMENT.md:52 against :243).
- Work: a bridge lemma, and split the term.
- Effort: M. [alignment]

**7.11 [low] A-05's measurement question ignores a measurement already in hand.** Its question (ALIGNMENT.md:158) is not connected to emergent misalignment (Betley 2025), which is already a rival in LA4's design (DESIGN.md:163).
- Work: text and a test proposal.
- Effort: S. [alignment]

**7.12 [low] The audit's five tests were never applied to the alignment bullets.** The bullets added after 25 October (08:522-528) carry only "near-definitional".
- Work: extend the audit over those rows (a UE0b).
- Effort: M. [method-meta]

## Theme 8. Method and philosophy

**8.1 [medium] The premise card omits the hypotheses that carry the third parts.**
- 08:167 says "Every premise in one place", but its table (08:185-192) lacks the gate, room (`Optimum.Room`) and exact transmission.
- The gate is defined only in GLOSSARY.md:56 and mentioned inside 08:175.
- `RegimeMargin.Gated` (L/RegimeMargin.lean:267) is not bridged to the flow gate. The net gate is bridged (L/PlaceTransitionNets.lean:517-536).
- Work: rows on the card, plus a small Lean bridge.
- Effort: M. [method-meta]

**8.2 [medium] No containment except the FEP lists its debts.** PLAN.md:23 and :41 require each containment to list "what the framework states that the theory cannot yet". The limits are scattered across "Does not show" sections, study notes, SCIENCES known weaknesses and asides in 08 (08:516, :520, :528; 05:170), so they do not form the work queue.
- Work: a debt column in 08 §8 and in the audit table.
- Effort: M. [method-meta]

**8.3 [low] The live defeater is named but the debate about it is not engaged.** 08:605 names "relations need relata with natures of their own". The debate where that is argued (Esfeld–Lam 2008, Chakravartty, Bradley's regress, Whitehead) is not engaged, and review/PHILOSOPHY.md lacks it. The gap was flagged at R/BECOMING-TWENTY-FIRST-REVIEW.md:334.
- Work: an 08 §9 paragraph and a dossier question.
- Effort: S. [fields-sweep]

---

## (a) The five items that would most move the work

**1. The restraint boundary (5.1).**
- **Belief to correct:** 07:699 and COLLECTIVE-DIRECTION.md:50 and :68 tell a reader the account rules out restraint as an equilibrium. 07:699 says this in the same paragraph as "restraint by all is also an equilibrium". The hypothesis of `Optimum.MutualBest.full`, a condition beyond every optimizer's family, is kept at ch/05-COLLECTIVES.md:202 and in rec/several-optimizers-drain-by-their-joint-capacity.md, and dropped at the three front-facing places.
- **Text:** restore the hypothesis everywhere, so the first-rank error goes.
- **Lean:** the other half of the boundary is already proved in unlanded scratch, D/ue6-beyond-the-sciences/ROUND-3-CANDIDATE-4.md and its tree/Becoming/CoupledDrawers.lean. Drawers in turn keep the need exactly where the coupling c exceeds the need m, and drain it where c < m. Drawing at once with no pivotal drawer, the drain holds at every coupling rate. Claim it on the board, land it with its record, and state the pair in 05 §7: drain where nothing couples in, restraint exactly where a drawer is pivotal or c > m. That makes the boundary exact.
- **Exit to fix:** apply round 3's correction to COLLECTIVE-DIRECTION.md:51. `Optimum.frontier_keeps_stepwise` is a one-optimizer law and is not a collective exit unless c > m.
- **Further:** the same result is the account's third part against a static Pigouvian rate (5.2), so cite it there as well.
- **Size:** documents plus one Lean landing.

**2. The AJ conditions against 04's own selection laws (2.1 and 2.2).**
- **Belief to correct:** readers of theories/becoming/review/ALIGNMENT.md:13, GOALS.md:104 and 02 §9 are told that what comes back to the shapers alone decides ("p never changes that direction"), and that a lock left in time is the exit.
- **Condition 1:** state MA3 (RuleShaping) as a case of `SelectionLevels.rises_iff_returns` with the shared part p weighted by assortment, and give a witness where c > s and shaping is selected among groups. Narrow "exactly where c ≤ s" to zero assortment of p. Note that s is private, so lower assortment cannot unselect where c ≤ s.
- **Condition 2:** read the MA4 stag hunt as 04 §6's Replacement chain, with drift (`Becoming.Drift`), absorbing ends and Moran weights a and b drawn from the pool, plus `Mutation`. Prove fixation-weight bounds on each side of the critical mass, and state the counting form of KMR/Young risk dominance or a small-N witness where it fails.
- **Then:** sort the §9 models into those whose lock survives noise and those whose lock noise leaves. Add the noise caveat to T7 (ch/02-MAP.md:428). Revise COLLECTIVE-DIRECTION.md:55's "the window may then be transient" into a stated law.
- **Effect:** both conditions get their true scope, and T7 gains a forbidden case about noise-driven exit.

**3. T2 against empirical dynamic modelling (4.1).**
- **The thesis:** T2 (ch/08-METHOD.md:567) holds that a renewable condition's state is its level, its recent giving and one lag. It forbids "a fourth variable removing a tenth of the residual variance in the median series". Its tests so far: MQ4 failed, MQ5 passed, MQ7 missed.
- **The field:** the work that measures this quantity across fish stocks, delay-coordinate embedding and EDM (Takens 1981; Sugihara and May 1990; Sugihara et al. 2012; Glaser et al. 2014), is absent from the account. Takens appears only at experiments/state-named-in-advance/DESIGN.md:21 and :545.
- **Work:** read that literature (the citations are from prior knowledge). Tabulate published embedding-dimension and nonlinearity estimates for the stocks T2's data cover. Record in T2's evidence whether any already bears on the forbidden item. Then design, and freeze without running, the next test using the field's out-of-sample prediction-skill criterion, with T2's three variables as the named state.
- **Effect:** a refutable thesis is set against the field that could already have refuted it.
- **Constraint:** running a test is Ren's decision; designing and freezing it is not.

**4. Closed-loop non-identification as one law with an experimentation exit (3.1, with 3.2 and 3.3).**
- **The split:** 02 §9's closed capture (`ClosedCapture.courses_alike_iff_unread`, `lock_outlives_loss`) and 03 §12's untested model (`ReadingLoop.alike_within`, `sensed_alike_iff`) are the same phenomenon. The unread is never exposed by a selection through what it reads. They are credited to different literatures (Borkar–Varaiya at 08:505; Fudenberg–Levine and Rothschild at 08:524) and joined only by audit row 16.
- **Lean bridge:** on `ReadingLoop.Loop`, take the share as the kept candidates and the rule as the act chosen. Show that `Unread` holds exactly where every untried act's answer goes unsensed, so that `Untested.rests` is a case of closed capture. Cross-link 02 §9 and 03 §12.
- **Experimentation exit:** state the excitation remedy as a law. An act or reading that separates the share's classes at some steps unlocks the course, the analogue of persistent excitation and of Fudenberg–Kreps (self-confirming equilibria become Nash under enough experimentation). Add "an act that risks the task" to T7's ways out (02:428) and give T7 the forbidden case: a lock left by excitation with no reading of the loss.
- **Same session:** ask whether an EFE chooser takes the separating act in `Untested`, which decides 03:272's positive half for active inference. Either back 03:272 with a finite consistency law in counts or narrow it, and add the Berk–Nash correspondence beside 03:532.

**5. Power-seeking and C's family, shown where readers look (7.1).**
- **Belief to correct:** an alignment reader's first objection is that widening what can form is option-keeping, which Turner et al. show optimal agents pursue. The answer exists: `Flow.Balances.widens_iff_others_within` (D65, 07:651) says own widening widens the whole only within others' margins. It is mapped against POWER, AUP and relative reachability in rec/own-widening-within-the-margin.md:62, and SE1 (ONE-ARGUMENT.md:75) found the blind draw to be relative reachability. But 08 §8 credits only Pattanaik–Xu (08:488, :555), the dossier never cites the law, and C's definition (07 §4) and covering (07 §2) never name the family.
- **Text:** add an 08 row naming Turner 2021, Omohundro 2008 and Krakovna 2019 with the third part. Add an ALIGNMENT.md item after A-03. Add a sentence at C's definition stating the map: covering is reachable-set inclusion, own widening is POWER read as admission, the inaction baseline is the withheld levels. Say where the account differs.
- **Lean:** state whether the three halves of instrumental convergence join under the margin and optimum laws, or why not (resource-keeping in horizon optima, option-keeping in own widening, goal-content integrity in the revision routes). Bring the offsetting and interference incentives to C.
- **Test:** design and freeze the audit's shared-resource option-gain test.

Next in line: 5.2 (externality and prices as a containment with a third part), 5.3 (Ostrom), and 1.1 together with 1.4 and 1.5 (a re-sync of the generated fronts and development pages, all small).

## (b) The general cause

The findings share four causes.

1. **A prior-art verdict is taken as the end of the work.** 08 §8's table has three columns (result, closest prior result, verdict) and no column for debts. "Restated" or "near-definitional" settles what the account owes the framework, not what the framework holds that the account lacks. UE's PLAN.md:23 asks each containment to list its debts, and only the free-energy principle got that list (PLAN.md:41). So Pearl is "restated" without scope (3.4), supervisory control is credited for its weaker half (3.5), and Kelly's theorem reads as an open gap (3.8). Each record's "Does not show" section absorbs the gap, so it reads as handled. Remedy: item 8.2's debt column, ordered as the work queue, plus the five tests applied to every row (7.12).

2. **Studies map a framework, and the mapping does not land.** Repeatedly the join was done in a plan, review or scratch tree and stopped there:
   - supervisory control: BECOMING-SIGNIFICANCE-REVIEW.md:170-203, whose own line reads "Integration: none";
   - Ostrom: RF PLAN.md:265;
   - Skalse and Karwowski: review:569-572;
   - resilience: review:332;
   - the one-reader third part: AUDIT.md:186-192;
   - the restraint boundary and the drawers' Pigou result: UE6 round 3, CoupledDrawers.

   Landing moves records and Lean. It does not require a study's correspondence to reach the home section or 08, so the work exists and the reader never sees it.

3. **Each model gets its own carrier, and a resemblance is recorded instead of proved.** Capture is counts (CarrierCounts), evolution is SelectionTerm on offspring weights, ethics is Weightings over admissions, and the market is a rational periphery. Relations are recorded as "related, not a proved adapter" or "interpretive", and the shared word ("one law", "selection", "pool", "regulation") stands in for a theorem. Examples: 2.4, 2.9, 5.6, 5.7, 7.2, 7.3, 7.10, 3.6. The rule "never reprove another session's item" with one session per item builds each piece well and leaves the joins unowned. A join between two landed items is nobody's claim.

4. **Generated and secondary text is not re-synced after a correction.** The goal JSONs behind README (1.1, 1.4) and the alignment development pages (1.5) still state superseded positions. The check passes because they are generated or off-path, not because they agree with the chapters.

The free-energy containment, UE16 to UE25, shows the remedy works. It stated the framework's stronger results as cases under named premises, listed its debts, and put five forbidden statements in the theory text. Applying the same three steps to each row of 08 §8, starting with the items in (a), would turn the citations into one picture.