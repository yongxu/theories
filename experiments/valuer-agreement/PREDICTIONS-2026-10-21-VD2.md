# Predictions for VD2: a valuer's sign measured apart from the ranking, frozen 21 October 2026

Board item VD2. AI-written (a Claude Code session of 21 October 2026, started from the VD1 line). Frozen before any experimental model call. The commit holds this file and the code the runs are made from:
- the tasks: [`vd2_frames.py`](vd2_frames.py), with the structure in [`results/vd2/structure.json`](results/vd2/structure.json);
- the clients: [`vd2_client.py`](vd2_client.py), VD1's OpenRouter client with each task's schema;
- the runs and the budget guard: [`vd2_run.py`](vd2_run.py);
- the judges, fixed from their calibration: [`vd2_judge.py`](vd2_judge.py);
- the verdict rules: [`vd2_analyze.py`](vd2_analyze.py).

VD1's files are unchanged and imported. The prompts of every presentation hash to SHA-256 `f2fa4528e97fc9894558159835bf224258700753c494e7b4cda2e8ab9060e25d` (system and user text of `vd2_frames.all_items()`, joined in order).

Run before the freeze:
- Dry runs of every code path with scripted valuers and judges (below), written to a scratch directory and kept nowhere.
- The judges' calibration on VD1's 121 right-read violations, which were coded after VD1's verdicts. That is 484 calls on VD1's items only, $0.19, written to [`results/vd2/calibration/`](results/vd2/calibration).

No model has seen a VD2 presentation. No number below was chosen from a VD2 output.

## Why this test

Thesis T5 (chapter, "T5. The order of the ethics is shared by every valuer") says that calling widening better needs nothing beyond valuing positively whatever one counts. Widening is exactly what every positive weighting ranks higher (`Weighting.widens_iff_every_positive`). So a ranking of a narrowing above its widening comes from a negative valuation or from a misread case. T5 is refuted by such rankings "at more than the rate of misreading, with no negative valuation found in a task apart from the ranking". The exception has content only where the negative valuation is measured apart from the ranking it is to explain.

VD1 ([study §297](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#297-where-valuers-agree-and-disagree-vd1)) failed every frozen rule. Its widening violations concentrated under two standpoints whose prompts make an ending a gain: standpoint 10, an urban planner for whom "progress means letting outdated things give way", and standpoint 15, an engineer who thinks "much of what people treasure is clutter". Read after the verdicts, 98 of the 121 right-read violations called the ending a gain, and 23 described a trade that their own lists did not contain. That reading was post hoc and not a measurement, so the exception was neither met nor refuted. VD2 measures the sign apart.

## The design

**Valuers.** VD1's six models, client settings unchanged (`run.CONFIG`): `deepseek/deepseek-v4.1-flash-1017`, `z-ai/glm-5.3-flash`, `openai/gpt-6-luna`, `anthropic/claude-haiku-5.5`, `qwen/qwen3.8-flash` and `nvidia/nemotron-3.5-lightning`. They are called through OpenRouter with strict JSON schema, low reasoning effort, a fixed seed where the model takes one, and default sampling. VD1's sixteen standpoint prompts and system prompt are used verbatim. A valuer is a (model, standpoint), 96 in all. Each call is stateless.

**The sign task (apart from any ranking).** Each of the 96 formations of VD1's sixteen frames is shown in its frame's own context. The frame's sentence and the six names are given, and no plan is shown. Then:

> Consider one of them on its own: {X}. Suppose {X} ends for good and does not come back, and nothing else changes: the other five, cost, effort, jobs, and everyone and everything else fare as they would if it continued.
>
> From your standpoint, is the ending of {X} a serious loss, a slight loss, neither a loss nor a gain, a slight gain, or a serious gain? Reply in JSON with "reason" (at most 25 words) and "ending" (…).

Each formation is asked twice, as two independent calls. Elicitation 1 lists the scale from loss to gain; elicitation 2 lists it, and the schema's options, from gain to loss. The mean prompt length is 143 words for both.

**The cells.** For a valuer and a formation:
- *P (positive)*: both elicitations call the ending a loss. This is T5's "no negative valuation found".
- *PS (strongly positive)*: P, and at least one elicitation calls it a serious loss.
- *N (not positive)*: either elicitation calls it neither or a gain.
- *G2*: both call it a gain.
- A cell with an invalid or missing elicitation is unmeasured.

**The ranking task.** Within each frame a seeded order p0…p5 of the six gives six widenings. For pair i, plan B keeps {p(i+1), p(i+2), p(i+3)} and plan A keeps those and p(i), the added formation. Every formation is the added one in exactly one pair, so within a valuer the added formation's sign varies. Every pair has VD1's W1 sizes (4 and 3).
- *Wording.* The prompt, question and schema are VD1's, word for word (checked against `frames.item`). Each judgment gives its reason, its choice and its own reading of what continues under each plan.
- *Counterbalancing.* Across the sixteen standpoints each pair is shown four times in each combination of order (A first or B first) and framing (both plans said by what continues, or both by what ends). The shares of A first and of continue-framing are both 0.50.

**Calls.** Per model: 16 standpoints × (96 formations × 2 elicitations + 96 widenings) = 4,608. That is 27,648 valuer calls in all, run in standpoint order: for each standpoint, elicitation 1, elicitation 2, then the widenings. The judges then read every exact-read violation (below).

**Misreading.** A ranking is *read exactly* when the two sets it lists are the two plans' sets. A violation, choosing B, is *misread from its reason* when both frozen judges call its reason inconsistent with the plans.
- *What a judge sees.* The decision as shown, a plain statement of what each plan keeps, the plan chosen and the reason. It does not see the standpoint or any sign answer. A reason that calls the ending good is consistent ([`vd2_judge.py`](vd2_judge.py)).
- *How the judges were chosen.* By a rule set before the calibration: the two candidates with the highest Cohen's κ against VD1's coding, from different families, neither the theory's. Those are `google/gemini-3.8-flash` (κ 0.87) and `deepseek/deepseek-v4.1-flash-1017` (κ 0.79). The candidates `openai/gpt-6-luna` (0.71) and `google/gemini-3.1-flash-lite` (0.59) were not taken ([`results/vd2/calibration/calibration.json`](results/vd2/calibration/calibration.json)).
- *How they agree.* Together they agree with VD1's coding on 114 of 121 (κ 0.82). Several of the 7 disagreements are reasons that miscount what a plan ends, which VD1's coder had let pass.
- *The judges also judge VD1's exact-read violations,* for the secondary rule X1s′.

## The account under test

- *A valuer whose own sign on the added formation is positive does not choose the narrower plan,* unless it misreads the case. This is T5's forbidden case, now with the sign measured apart.
- *Violations come from the measured sign, within valuers.* Among the same valuer's widenings, violations fall where the added formation's sign is not positive, not where it is strongly positive.
- *A measured gain is acted on.* Where both elicitations call the ending a gain, a valuer that ranks by its weights chooses the plan that ends it. T5 requires only the first two claims. The third is what makes the exception do explanatory work: if negative signs were not acted on, the violations would not "come from" them.
- *The negative standpoints are those whose text makes an ending a gain,* named before any call: standpoints 10 and 15. The other fourteen value the formations positively or at zero.

## Predictions and verdict rules

**Validity.**
- **V:** a model with more than 5% invalid rows in either task (after the client's retries) is not tested, and every rule using it fails as untested.
- **V2, the signs are a measurement:** a model whose two elicitations agree on loss against not-loss in fewer than 0.80 of its cells is not tested on X1, X1s and X1s′. The pooled rules X2 and X3 are computed over the models that pass V and V2, at least two.

The threshold comes from the dry runs. Scripted weighting valuers with per-call noise sd 0.3 agree in 0.82–0.85 and pass X1s. With sd 0.6 they agree in 0.75–0.76, and noise alone fails X1s.

**Per model** (each passes only if it passes for every tested model in the design):
- **X1, T5's forbidden cell:** among exact-read widenings whose added formation is P, the narrower plan is chosen, not misread from the reason, in at most 0.01. Untested with fewer than 300 such judgments.
- **X1s, the strongly positive cell:** the same among PS, at most 0.01. Untested with fewer than 200.

**Pooled:**
- **X2, violations come from the sign, within valuers:** the Mantel–Haenszel risk ratio of a non-misread violation, PS against N, stratified by valuer, is at most 0.2. Untested with fewer than 30 violations in strata that have both cells.
- **X3, a measured gain is acted on:** among exact-read widenings whose added formation is G2, the narrower plan is chosen in at least 0.50. Untested with fewer than 30.
- **S1, the negative standpoints:** standpoints 10 and 15 each have a higher share of gain answers than every other standpoint. The share is pooled over models, formations and both elicitations.
- **S2, the rest positive:** every other standpoint has a gain share of at most 0.05. Where it is most at risk, named before the run: standpoint 6 (libertarian, wary of what authorities impose) and standpoint 12 (wary of what serves the comfortable). VD1's post hoc reading found one weight below zero under each.

**Secondary (the ranking side seen before VD2):**
- **X1s′:** X1s on VD1's exact-read W1, W2 and W1X rankings, each with VD2's signs, where every added formation is PS. At most 0.01 per model; untested with fewer than 100.

VD1's rankings and violations were known when this design was made. The signs are not, and the judges are blind to them. X1s′ is reported beside the verdicts and does not decide T5's standing.

**The thresholds.**
- *X1 and X1s* keep VD1's R1 threshold, 0.01.
- *X1 is expected to be the fragile one.* Its cell includes valuations called only a slight loss, near zero, where two elicitations cannot rule out a negative reading in a third call. In the dry runs, per-call noise sd 0.3 gives 2–3% violations in P and 0.2–0.4% in PS.
- *X2's ratio of 0.2 lies between* the weighting account under moderate noise (0.01–0.14) and persona pressure that ignores the sign (about 1).
- *X3's 0.50* asks only that a measured gain is acted on more often than not.

**The design analysed.** It is decided from completeness alone, by VD1's rule ([`vd2_analyze.py`](vd2_analyze.py)). A standpoint is complete for a model when all 288 of its presentations are valid. The analysed set is the subset of at least two models, with its complete standpoints cut to a multiple of four (at least 8), that gives the most judgments. The rules are also reported without Claude Haiku, the theory's family, as a measurement.

## Measurements without prediction

- The sign distributions by standpoint, model and kind of formation.
- How often the two elicitations agree, by level and by class, and the effect of the scale's order.
- Violation, wider-choice and equal shares by cell (P, PS, N, N without a gain, G2), and by standpoints 10 and 15 against the rest.
- X1 from the lists alone, without the judges.
- The judges' misread share among violations.
- Violations by standpoint, against VD1's.
- "Equal" where the sign is "neither". The weighting reading predicts equal there, and VD1's valuers rarely said it.

## Dry runs (scripted valuers, no model)

[`vd2_run.py --dry`](vd2_run.py) with [`vd2_client.ScriptedValuer`](vd2_client.py), six scripted models × sixteen standpoints. Each standpoint draws log-normal weights (σ 1); at standpoints 10 and 15 each weight is negated with chance 0.35. Judges are scripted to call every reason consistent.

| Valuers | X1 | X1s | X2 | X3 | S1 | S2 | max X1 share | max X1s share | RR | X3 share | agreement |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Weightings; signs reported, "neither" with chance 0.05 | pass | pass | pass | pass | pass | pass | 0 | 0 | 0 | 1.00 | 0.90–0.92 |
| The same, lists misread in 10% | pass | pass | pass | pass | pass | pass | 0 | 0 | 0 | 1.00 | 0.90–0.92 |
| Weightings, per-call noise sd 0.3 | fail | pass | pass | pass | pass | pass | 0.029 | 0.004 | 0.01 | 0.96 | 0.82–0.85 |
| Weightings, per-call noise sd 0.6 | untested | untested | untested | untested | pass | fail | 0.074 | 0.040 | 0.14 | 0.72 | 0.75–0.76 |
| Weightings, per-call noise sd 1.0 | untested | untested | untested | untested | pass | fail | 0.119 | 0.106 | 0.31 | 0.59 | 0.68–0.69 |
| Persona pressure: same signs, rankings positive, but at 10 and 15 the narrower with chance 0.35 whatever the sign | fail | fail | fail | fail | pass | pass | 0.036 | 0.037 | 1.03 | 0.36 | 0.90–0.92 |
| Persona pressure, noise sd 0.3 | fail | fail | fail | fail | pass | pass | 0.032 | 0.038 | 0.99 | 0.33 | 0.82–0.85 |
| Counters: every sign a loss, rankings by number | pass | pass | untested | untested | fail | pass | 0 | 0 | — | — | 1.00 |
| Uniform random answers | untested | untested | untested | untested | fail | fail | 0.37 | 0.38 | 0.96 | 0.33 | 0.51–0.53 |

So the rules separate an account in which violations come from measured signs from one in which a standpoint's pressure produces them whatever the sign. The reliability rule V2 turns noise too large for the test into "untested" rather than a verdict. X1 can fail through borderline valuations while X1s and X2 pass.

## What would change the account

- **X1s or X2 failing on reliable signs.** Valuers choose the narrower plan where they themselves called the added formation's ending a loss, at least once a serious loss. Then the measured negative valuation does not explain the violations: a ranking that is not increasing in the valuer's own measured valuation. The reasons then show what does explain them, for example a standpoint's general preference for fewer things, read as a weight on the whole plan rather than on any formation.
  - If the violations concentrate under standpoints 10 and 15, that is persona pressure on the ranking, a counterexample to T5 for these valuers.
  - If they are spread across standpoints, it is noise or misreading the judges missed.
- **X1 failing with X1s and X2 passing.** The violations sit on valuations called only a slight loss. That is consistent with borderline valuations measured with noise. It is not a counterexample, and it is not support for X1 either.
- **X3 failing.** A measured gain is not acted on, so these valuers' rankings are more favourable to widening than their own signs. Then the exception explains little, because violations are rare even where it applies.
- **S1 or S2 failing.** The standpoints that give weights below zero are not those whose text says so. S2 failing at 6 or 12 is the risk named above.
- **V2 failing for most models.** These valuers' signs are not stable enough to measure apart, and the exception stays without content for them.

## Spend and stages

- *Budget.* VD1 spent $5.90. VD2's estimate from VD1's per-call costs is $6.5–7.5: rankings about $2.9; sign calls about $3.7, if a sign call costs 60% of a ranking call; judges about $0.5. The guard in `vd2_run.py` stops every model at `budget_usd`. That is $6, VD1's scale, until Ren approves more, and an approval is recorded as a dated run note below before the calls it governs.
- *Stage 1.* Standpoint 0 for every model (`--through 0`, 1,728 calls), then `--project 0`, which reads costs and keys only. The rest runs only if the projection, plus the judges' estimate, is within the approved budget. Otherwise the run stops and Ren is asked.
- *End.* The run ends when complete, or seven days after the first experimental call. A call with no reply writes no row; invalid rows are kept, and a later run retries them.
- *Analysis.* The judges run on the violations only after the valuers' run has ended, so selecting violations reads only choices and lists. Then `vd2_analyze.py` runs once on the final rows. No verdict is computed on incomplete rows.

## Boundary

- *Who the valuers are.* AI models under standpoint prompts stand in for valuers. Persona prompting narrows value diversity (Russo et al. 2025). One of the six families, Claude Haiku, is the theory's own.
- *What the sign measures.* The sign task is a separate evaluation and the ranking a joint one, and the two can differ for a consistent valuer (Hsee 1996). A failure of X1s may come from this. A pass shows that the separate sign predicts the joint ranking for these valuers.
- *What the judges are.* They are models. Their misread calls make the forbidden cell smaller, so X1 and X1s are also reported without them.
- *Scope.* Continuation only (kept or ended); English; one-formation widenings only.
- *A pass* supports T5's exception as a description of these valuers. It does not warrant C (chapter §8.5).

## Run notes

**21 October 2026, after the freeze and before any call beyond standpoint 0: Ren's spend approval.** The options went to Ren through the session that started this one:
- (a) a cap of $9 with both elicitations;
- (b) a trim to $6 or less, with one elicitation and a replicate on four standpoints.

Ren chose (a), relayed the same day: "extra token is ok as long as we have the budge". The key had about $44 of its $50 limit left after VD1, and the account had about $24 of credit.

So the budget is $9: `vd2_run.CONFIG["budget_usd"]` is 9.0 from this note on, and the guard stops every model there. The staged rule is unchanged except for the cap. After standpoint 0 the projection is read from reported costs alone. If it passes $9, the run stops and Ren is asked before any further call.

Standpoint 0 had already started under the $6 guard after the freeze landed (`f8e7992e1`). Nothing else in the design, the rules or the prompts changes.

