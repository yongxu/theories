# Where valuers agree and disagree (VD1)

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
