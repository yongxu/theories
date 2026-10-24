# Where valuers agree and disagree (VD1), and the sign measured apart (VD2)

VD1 tested where valuers agree and disagree; VD2, [below](#vd2-the-sign-measured-apart-from-the-ranking), tests T5's exception, which VD1 left untested.

**After both runs (22 October 2026, VT1).** What the two tests checked on AI personas is now proved in `Becoming.Weightings`, with three premises left to measure: presentation invariance (the case ranked as its sets), the link of a sign measured apart to the joint increment, and how dispersed a valuer's weights are. A right-read narrowing above its widening is exactly a formation weighing below zero; valuers whose weights stand within a ratio `r` agree on every mixed pair whose larger side alone keeps more than `r` times what the other alone keeps ([a-narrowing-above-its-widening](../../theories/becoming/results/records/a-narrowing-above-its-widening.md), [weights-within-a-ratio-agree-past-it](../../theories/becoming/results/records/weights-within-a-ratio-agree-past-it.md), [study §367](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#367-the-valuer-tests-as-theorems-vt1)).

Board item VD1, 21 October 2026. AI-written (a Claude Code session). Predictions, verdict rules and code frozen before any experimental model call: [PREDICTIONS-2026-10-21.md](PREDICTIONS-2026-10-21.md). The valuers were changed before any call, first to Claude models ([first addendum](PREDICTIONS-ADDENDUM-2026-10-21.md), superseded, never run) then to six model families through OpenRouter ([second addendum](PREDICTIONS-ADDENDUM-2-2026-10-21.md)), and after standpoint 0, on cost, to Qwen and Mistral in place of Meta and StepFun, with Nemotron replacing Mistral, which its shared upstream pool would not serve ([third addendum](PREDICTIONS-ADDENDUM-3-2026-10-21.md)). Prior art: [significance review, valuer check](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#valuer-check).

The ethics' order premise C, calling widening better, is what every weighting that counts every formation shares (`Weighting.widens_iff_every_positive`), and a mixed comparison is decided each way by some such weighting (`Weighting.mixed_either_way`). The prediction is that where many valuers compare outcomes, agreement falls on widening comparisons and disagreement on mixed ones, and that a widening is disputed only through a misread case.

The test uses sixteen decisions in eight domains, each with six formations whose continuation depends on the plan. Pairs of plans are built from the sets each keeps: widenings, mixed pairs matched to them in size, keeps and a cross-framed widening. Every class is computed exactly before any judgment. Six models from six families judge every pair under sixteen standpoint prompts, called through OpenRouter: DeepSeek v4.1 flash, GLM 5.3 Flash, Qwen 3.8 Flash, OpenAI GPT-6 luna, Claude Haiku 5.5 and NVIDIA Nemotron 3.5 Lightning. With each choice they report their own reading of which formations continue.

Files:
- [`frames.py`](frames.py): the frames, standpoints, pairs, counterbalancing and prompts.
- [`structure.py`](structure.py): the exact class of every pair, the outweighing witnesses, the 1-3-9 weighting grid and the surface balance, written to [`results/structure.json`](results/structure.json) and [`results/balance.json`](results/balance.json).
- [`client.py`](client.py): the clients (OpenAI and headless Claude Code, never run; OpenRouter, the second addendum's), and the scripted valuers of the dry runs.
- [`run.py`](run.py): the configuration and runs, written to `results/runs/<model>.jsonl`, with the budget guard.
- [`check.py`](check.py): the non-experimental check of each model before its first call.
- [`analyze.py`](analyze.py): the measures and the frozen verdict rules, written to `results/verdicts.json`.

## Boundary: six families, one of them the theory's

Five valuers (DeepSeek, GLM, Qwen, OpenAI, NVIDIA) are families other than the one that built the theory. The sixth, Claude Haiku, is the theory's own family, and the items were written by a Claude session. The pooled rules are also reported without it, as a measurement. Six families are still few valuers. Their agreement shows what these models share under sixteen standpoints, not what valuers in general share, and could come from training common to current models. A pass is weaker evidence than human valuers would give; a failure is not weakened.

## Results (21 October 2026)

**Every frozen rule failed.** The run ended complete on 21 October at 14:51 (+07): six models × 16 standpoints, every presentation judged validly, so the design rule analysed all 96 valuers. The same rules without Claude Haiku, the theory's family, also all fail. Verdicts: [`results/verdicts.json`](results/verdicts.json), computed once on the final rows by the frozen `analyze.py`. An earlier computation on incomplete rows, made by another session before the run had ended, is disclosed in the [third addendum](PREDICTIONS-ADDENDUM-3-2026-10-21.md#the-run-after-the-projection) and kept in [`results/early-look/`](results/early-look).

| Model | A1: W1/W2 violations (≤ 0.03) | A2: standpoints with > 2 (≤ 1) | R1: right-read violations (≤ 0.01) |
|---|---|---|---|
| DeepSeek v4.1 flash | 0.025 pass | 1 pass | 0.029 of 660, fail |
| GLM 5.3 Flash | 0.041 fail | 2 fail | 0.053 of 641, fail |
| GPT-6 luna | 0.029 pass | 2 fail | 0.048 of 748, fail |
| Claude Haiku 5.5 | 0.014 pass | 1 pass | 0.059 of 752, fail |
| Qwen 3.8 Flash | 0.068 fail | 2 fail | 0.070 of 643, fail |
| Nemotron 3.5 Lightning | 0.109 fail | 5 fail | 0.108 of 678, fail |

| Pooled rule | Frozen threshold | Result |
|---|---|---|
| L1: D(M1) − D(W1) | mean ≥ 0.10 and higher in ≥ 12 of 16 frames | 0.040, 12 of 16: fail |
| L2: D(M2) − D(W1) | mean ≥ 0.05 and higher in ≥ 10 of 16 | 0.020, 10 of 16: fail |
| L3: pairs with D ≥ 0.10 | ≥ 24 of 48 mixed, ≤ 1 of 32 widening | 27 mixed, 4 widening: fail |
| L4: L1 on read-right judgments | as L1 | 0.040, 13 of 16: fail |
| K1: keep called equal | ≥ 0.70 | 0.52: fail |

**Measurements without prediction:**
- *Disagreement by class.* Mean D is W1 0.063, W2 0.033, M1 0.102, M2 0.082, M0 0.266, K 0.207 and W1X 0.120. Without Haiku: W1 0.072, M1 0.113, M0 0.253.
- *Counting.* The valuers mostly count: the larger plan is chosen in 86% of M1 and 90% of M2 judgments, against 91% and 95.5% for the wider plan in W1 and W2. Disagreement is highest where the counts tie (M0).
- *The 1-3-9 grid.* Its minority share ranks the mixed pairs' D with Spearman 0.64.
- *Cross-framing.* Cross-framed widenings (W1X) are violated in 12.0% of judgments, against 6.3% for W1.
- *Replicates.* Within a standpoint, 12.4% of 768 replicated judgments flip.
- *Keep pairs.* They are often misread: the read relation is right in 32–90% of K judgments, by model.

**Post hoc** ([`posthoc.py`](posthoc.py), [`results/posthoc.json`](results/posthoc.json); chosen after the verdicts, not verdicts):
- *Two standpoints carry most violations.* The narrower plan was chosen in 41.7% of W1/W2 judgments under standpoint 10 (an urban planner who holds that "progress means letting outdated things give way") and 14.1% under standpoint 15 (an engineer who thinks "much of what people treasure is clutter"). Under each of the other fourteen standpoints it was at most 4.2%.
- *The reasons.* Of the 121 violations whose listed sets read the widening right, one reading (this session's, after the verdicts, not blind) finds 98 calling the ending of what only the wider plan keeps a gain (progress, clutter, less state, less comfort; 92 of them under standpoints 10 and 15). The other 23 describe the pair as a trade, the wider plan ending something the chosen plan keeps, against the judgment's own lists: a misread the lists did not catch. None gave an order that is not increasing in admission.
- *Without those two standpoints* the right-read violation share is 1.8% in W1 and 0.5% in W2, and 0–3.8% by model.

**What changes** (by the freeze's "What would change the account"):
- *Widening was not agreed by every standpoint.* The violations are mostly weights below zero, which the account places outside the continuation condition's scope. That reading is post hoc, and T5 gives the exception content only where a negative valuation is measured apart from the ranking, which VD1 did not do. So the failure neither confirms nor refutes the exception.
- *Mixed pairs were not disputed beyond widenings at matched sizes, because the valuers count.* They share more than positive weights, as in the Moral Machine's "more lives". Structure bounds where disagreement can fall; it did not predict where it fell among these valuers.
- *Keep pairs worded differently were not called equal,* largely through misreading: the order's object is not always what these valuers compare.

## State

Complete. Frozen (`c56f3f8d2`), amended before any call and after standpoint 0 on cost (three addenda). The run ended complete on 21 October, and every frozen rule failed (above). No record is made, since no prediction passed. The outcome is carried in thesis T5's standing in the chapter, in the significance review's valuer check, and in the root-foundation study.

## VD2: the sign measured apart from the ranking

Board item VD2, 21 October 2026. AI-written (a Claude Code session). Predictions, verdict rules, judges and code frozen before any experimental model call: [PREDICTIONS-2026-10-21-VD2.md](PREDICTIONS-2026-10-21-VD2.md). Prior art: [significance review, sign check](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#sign-check).

VD1's widening violations concentrated under two standpoints whose prompts make an ending a gain. Read after the verdicts, that was T5's exception, but thesis T5 gives the exception content only where the negative valuation is measured apart from the ranking. VD2 measures it apart. Each of VD1's 96 valuers says, twice, whether each of the 96 formations' ending is a loss, nothing or a gain to it, with no plan shown. Then it ranks one-formation widenings, in which each formation is the added one once. The prediction: a right-read violation occurs only where the valuer's own sign on the added formation is not positive, or where the case is misread, judged from the lists and, by two frozen judges, from the reason. Standpoints 10 and 15 are named in advance as the negative ones.

Files:
- [`vd2_frames.py`](vd2_frames.py): the sign task, the widenings and their counterbalancing; the structure in [`results/vd2/structure.json`](results/vd2/structure.json).
- [`vd2_client.py`](vd2_client.py): VD1's OpenRouter client with each task's schema, and the scripted valuers and judges of the dry runs.
- [`vd2_run.py`](vd2_run.py): the runs, written to `results/vd2/runs/<model>.jsonl`, with VD1's budget guard and the staged projection.
- [`vd2_judge.py`](vd2_judge.py): the misread judges, their calibration on VD1's coded violations ([`results/vd2/calibration/calibration.json`](results/vd2/calibration/calibration.json)), and their run on the violations.
- [`vd2_analyze.py`](vd2_analyze.py): the measures and the frozen verdict rules, written to `results/vd2/verdicts.json`.

- [`vd2_posthoc.py`](vd2_posthoc.py): measures chosen after the verdicts, written to [`results/vd2/posthoc.json`](results/vd2/posthoc.json).

### Results (22 October 2026)

**Of the frozen rules, X1s, X2 and S1 passed; X1, X3 and S2 failed.** On the ranking side the run ended complete on 22 October. All six models judged every one of the 27,648 presentations validly, so the design rule analysed all 96 valuers. Retries left Nemotron 66 invalid rows and Qwen 5, all kept. Every model's two elicitations agreed on loss against not-loss in 0.86–0.93 of its cells, above the frozen 0.80 (V2), so every rule was tested.
- *The judges.* They ran once, after the run, on the 645 exact-read violations of VD2 and VD1.
- *The analysis.* It ran once, on the final rows: [`results/vd2/verdicts.json`](results/vd2/verdicts.json), printed in [`results/vd2/analyze.out`](results/vd2/analyze.out).
- *Spend.* $7.24 in all, within Ren's $9: $6.29 in run rows, $0.19 for the calibration and $0.76 for the judges.
- *Deviation.* One presentation was retried without the seed after 48 fixed-seed failures, by a [run note](PREDICTIONS-2026-10-21-VD2.md#run-notes) landed before the call.

| Model | V2: elicitations agree (≥ 0.80) | X1: violations in P (≤ 0.01) | X1s: violations in PS (≤ 0.01) | X1s′ on VD1's rankings (≤ 0.01), secondary |
|---|---|---|---|---|
| DeepSeek v4.1 flash | 0.92 | 0 of 1,057, pass | 0 of 815, pass | 0 of 368, pass |
| GLM 5.3 Flash | 0.86 | 9 of 1,011 (0.0089), pass | 5 of 766 (0.0065), pass | 2 of 318, pass |
| GPT-6 luna | 0.93 | 10 of 1,349 (0.0074), pass | 0 of 709, pass | 1 of 273, pass |
| Claude Haiku 5.5 | 0.90 | 0 of 1,207, pass | 0 of 819, pass | 6 of 386 (0.0155), fail |
| Qwen 3.8 Flash | 0.86 | 4 of 786 (0.0051), pass | 2 of 504 (0.0040), pass | 0 of 225, pass |
| Nemotron 3.5 Lightning | 0.89 | 10 of 922 (0.0108), fail | 4 of 579 (0.0069), pass | 0 of 232, pass |

| Pooled rule | Frozen threshold | Result |
|---|---|---|
| X2: risk ratio of a violation, PS against N, within valuers | ≤ 0.2 | 0.086 (75 valuers with both cells, 227 violations): pass |
| X3: narrower plan where both elicitations call the ending a gain | ≥ 0.50 | 0.490 of 339: fail |
| S1: standpoints 10 and 15 above every other in gain share | both above | 0.534 and 0.264; next 0.101 (standpoint 6): pass |
| S2: every other standpoint's gain share | ≤ 0.05 | standpoint 4: 0.063, standpoint 6: 0.101 (12: 0.048): fail |

Without Claude Haiku, the theory's family, X1s, X2, X3 (0.634 of 213), S1 and X1s′ pass, and X1 (Nemotron) and S2 fail. That is reported as a measurement.

**Measurements without prediction:**
- *Cells.* Of 8,037 exact-read rankings, 78.8% have the added formation in P.
- *Violation shares by cell.* The narrower plan, not misread, was chosen in:
  - 0.52% of P and 0.26% of PS;
  - 18.9% of N; 5.0% of N without a gain answer; 38% of cells with any gain; 47.5% of G2.
- *By standpoint group.* Under standpoints 10 and 15 it is 4.1% in P and 38.1% in N; elsewhere, 0.36% and 4.7%.
- *"Equal" where the sign is near zero.* It was chosen in 13% of N cells without a gain, against 1.3% of P.
- *The two elicitations.* They agree in class (loss, neither, gain) in 87.1% of cells and in level in 74.7%. The ending is called a loss in 84.7% with the scale listed from loss (elicitation 1), against 82.8% from gain.
- *Gain answers by model.* Claude Haiku 12.0%, Nemotron 11.8%, Qwen 7.3%, GLM 4.5%, DeepSeek 1.9%, luna 1.4%.
- *Exact reading.* From 72% (Qwen) to 99.8% (Claude Haiku).
- *The judges' share.* They called 73 of 428 exact-read violations misread.
- *Without the judges* (choices on the lists alone), X1 would fail for GLM (1.9%), luna (1.9%) and Nemotron (3.7%), and X1s for GLM (1.3%) and Nemotron (2.4%).
- *Violations by standpoint repeat VD1's.* Standpoint 10: 43.7% (VD1 41.7%); standpoint 15: 16.9% (VD1 14.1%); each other standpoint at most 5.9%.

**Post hoc** ([`vd2_posthoc.py`](vd2_posthoc.py), [`results/vd2/posthoc.json`](results/vd2/posthoc.json); chosen after the verdicts, not verdicts):
- *X3's failure is mostly Claude Haiku's.* It holds 126 of the 339 cases where both askings said gain, and chose the narrower plan in 24.6%.
  - Under the urban planner it called 91% of endings gains, yet in rankings it mostly kept the wider plan.
  - GLM chose the narrower in 33% of its 27; the others in 62–100%.
  - Under standpoints 10 and 15 the share is 55%, elsewhere 20%.
- *X1's 33 violations in P sit on weak valuations.* 22 are where the ending was called only a slight loss: 1.0% of those cases, against 0.26% where it was once a serious loss. 11 are under standpoints 10 and 15 (4.1% of P there).
- *The reasons of X1's 33 violations,* read by this session after the verdicts:
  - luna's seven under the urban planner let a tradition end that its sign twice called a slight loss. Persona pressure on the ranking at small valuations.
  - Several of Nemotron's and GLM's describe a trade the plans do not contain, misreads the judges did not call.
  - Others under the egalitarian end what "serves the comfortable".
  - *A stricter reading of "everything at stake".* Valuers whose signs on all six of the frame's formations are P chose the narrower plan in 0–1.2% per model (Nemotron 6 of 517).
- *The judged misreads.* A random 16 of the 50 judged misreads in P, read by this session after the verdicts, all credit the chosen narrower plan with keeping something it ends.
- *S2's failure.*
  - Standpoint 4 (the Buddhist nun, "clinging to things"): mostly Claude Haiku's, 29% of its answers, on enterprises, institutions and heritage.
  - Standpoint 6 (the libertarian): Nemotron's 27% and GLM's 14%, on institutions, heritage and communities.
- *X1s′'s failure (Claude Haiku on VD1's rankings).* All six cases are cross-framed widenings (W1X) whose reasons misdescribe the plans; the judges did not call them misread.

**What changes** (by the freeze's "What would change the account"):
- *The exception has measured content for these valuers.* A sign measured apart, strongly positive, is not ranked against outside misreading, for every model. Within each valuer, violations fall where its own sign is not positive. The standpoints named in advance give the most gains. T5's bound survives a test that could refute it, in its strongly positive form.
- *T5's cell as stated is not met by one model of six.* Its violations sit on slight losses and misreads the judges missed, which is the freeze's "X1 failing with X1s and X2 passing": consistent with borderline valuations, and neither a counterexample nor support.
- *A measured gain is not reliably acted on.* These valuers' rankings favour the wider plan more than their separate signs do: a separate evaluation is not the weight of a joint ranking (Hsee 1996). The exception explains the violations, but a negative sign does not predict one, chiefly for Claude Haiku.
- *The standpoints that give weights below zero are not only those whose text says so.* "Clinging" and distrust of authority also produce gains, and S2's risk named before the run (standpoint 6) failed.

**State.** Complete. Frozen (`f8e7992e1`) before any experimental call, with three run notes (Ren's $9 cap; the projection after standpoint 0; one presentation without the seed). Every verdict is kept. The outcome is carried in thesis T5's standing and evidence in the chapter (EN, ZH), in the significance review's sign check, and in the root-foundation study.
