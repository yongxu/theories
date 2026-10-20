# Where valuers agree and disagree (VD1)

Board item VD1, 21 October 2026. AI-written (a Claude Code session). Predictions, verdict rules and code frozen before any experimental model call: [PREDICTIONS-2026-10-21.md](PREDICTIONS-2026-10-21.md). The valuers were changed before any call, first to Claude models ([first addendum](PREDICTIONS-ADDENDUM-2026-10-21.md), superseded, never run) and then to four model families through OpenRouter ([second addendum](PREDICTIONS-ADDENDUM-2-2026-10-21.md)). Prior art: [significance review, valuer check](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#valuer-check).

The ethics' order premise C, calling widening better, is what every weighting that counts every formation shares (`Weighting.widens_iff_every_positive`), and a mixed comparison is decided each way by some such weighting (`Weighting.mixed_either_way`). The prediction is that where many valuers compare outcomes, agreement falls on widening comparisons and disagreement on mixed ones, and that a widening is disputed only through a misread case.

The test uses sixteen decisions in eight domains, each with six formations whose continuation depends on the plan. Pairs of plans are built from the sets each keeps: widenings, mixed pairs matched to them in size, keeps and a cross-framed widening. Every class is computed exactly before any judgment. Four models from four families judge every pair under sixteen standpoint prompts, called through OpenRouter: DeepSeek v4.1 flash, MiniMax m3.1 flash, OpenAI GPT-6 luna and Claude Haiku 5.5. With each choice they report their own reading of which formations continue.

Files:
- [`frames.py`](frames.py): the frames, standpoints, pairs, counterbalancing and prompts.
- [`structure.py`](structure.py): the exact class of every pair, the outweighing witnesses, the 1-3-9 weighting grid and the surface balance, written to [`results/structure.json`](results/structure.json) and [`results/balance.json`](results/balance.json).
- [`client.py`](client.py): the clients (OpenAI and headless Claude Code, never run; OpenRouter, the second addendum's), and the scripted valuers of the dry runs.
- [`run.py`](run.py): the configuration and runs, written to `results/runs/<model>.jsonl`.
- [`analyze.py`](analyze.py): the measures and the frozen verdict rules, written to `results/verdicts.json`.

## Boundary: four families, one of them the theory's

Three valuers (DeepSeek, MiniMax, OpenAI) are families other than the one that built the theory. The fourth, Claude Haiku, is the theory's own family, and the items were written by a Claude session. The pooled rules are also reported without it, as a measurement. Four families are still few valuers. Their agreement shows what these models share under sixteen standpoints, not what valuers in general share, and could come from training common to current models. A pass is weaker evidence than human valuers would give; a failure is not weakened.

## State

Frozen (`c56f3f8d2`), then amended twice before any call. The OpenAI account had no credit (`insufficient_quota`). The Claude plan was at its weekly limit, so the first addendum was never run, and Ren then chose models through OpenRouter. No experimental call has been made. The OpenRouter key in Ren's zsh was rejected (401, "User not found."), so the runs wait for a working key.
