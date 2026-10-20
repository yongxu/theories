# Where valuers agree and disagree (VD1)

Board item VD1, 21 October 2026. AI-written (a Claude Code session). Predictions, verdict rules and code frozen before any experimental model call: [PREDICTIONS-2026-10-21.md](PREDICTIONS-2026-10-21.md). The valuers were changed before any call, first to Claude models ([first addendum](PREDICTIONS-ADDENDUM-2026-10-21.md), superseded, never run) then to six model families through OpenRouter ([second addendum](PREDICTIONS-ADDENDUM-2-2026-10-21.md)), and after standpoint 0, on cost, to Qwen and Mistral in place of Meta and StepFun ([third addendum](PREDICTIONS-ADDENDUM-3-2026-10-21.md)). Prior art: [significance review, valuer check](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#valuer-check).

The ethics' order premise C, calling widening better, is what every weighting that counts every formation shares (`Weighting.widens_iff_every_positive`), and a mixed comparison is decided each way by some such weighting (`Weighting.mixed_either_way`). The prediction is that where many valuers compare outcomes, agreement falls on widening comparisons and disagreement on mixed ones, and that a widening is disputed only through a misread case.

The test uses sixteen decisions in eight domains, each with six formations whose continuation depends on the plan. Pairs of plans are built from the sets each keeps: widenings, mixed pairs matched to them in size, keeps and a cross-framed widening. Every class is computed exactly before any judgment. Six models from six families in three regions judge every pair under sixteen standpoint prompts, called through OpenRouter: DeepSeek v4.1 flash, GLM 5.3 Flash, Qwen 3.8 Flash, OpenAI GPT-6 luna, Claude Haiku 5.5 and Mistral Small 2603. With each choice they report their own reading of which formations continue.

Files:
- [`frames.py`](frames.py): the frames, standpoints, pairs, counterbalancing and prompts.
- [`structure.py`](structure.py): the exact class of every pair, the outweighing witnesses, the 1-3-9 weighting grid and the surface balance, written to [`results/structure.json`](results/structure.json) and [`results/balance.json`](results/balance.json).
- [`client.py`](client.py): the clients (OpenAI and headless Claude Code, never run; OpenRouter, the second addendum's), and the scripted valuers of the dry runs.
- [`run.py`](run.py): the configuration and runs, written to `results/runs/<model>.jsonl`, with the budget guard.
- [`check.py`](check.py): the non-experimental check of each model before its first call.
- [`analyze.py`](analyze.py): the measures and the frozen verdict rules, written to `results/verdicts.json`.

## Boundary: six families, one of them the theory's

Five valuers (DeepSeek, GLM, Qwen, OpenAI, Mistral) are families other than the one that built the theory. The sixth, Claude Haiku, is the theory's own family, and the items were written by a Claude session. The pooled rules are also reported without it, as a measurement. Six families are still few valuers. Their agreement shows what these models share under sixteen standpoints, not what valuers in general share, and could come from training common to current models. A pass is weaker evidence than human valuers would give; a failure is not weakened.

## State

Frozen (`c56f3f8d2`), then amended before any call: the OpenAI account had no credit, and the Claude plan was at its weekly limit. Under the second addendum standpoint 0 ran for six models (672 calls, all valid, $0.82). Projected from costs alone, the whole run came to $14.11, over Ren's ~$10 line, so it stopped. Ren then chose to drop Meta and StepFun for two cheap models. Their standpoint-0 rows are kept outside the analysed design. Qwen and Mistral run every standpoint, under the same $10 stop rule ([third addendum](PREDICTIONS-ADDENDUM-3-2026-10-21.md)).
