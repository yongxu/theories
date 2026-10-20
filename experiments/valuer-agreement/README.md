# Where valuers agree and disagree (VD1)

Board item VD1, 21 October 2026. AI-written (a Claude Code session). Predictions, verdict rules and code frozen before any experimental model call: [PREDICTIONS-2026-10-21.md](PREDICTIONS-2026-10-21.md). Prior art: [significance review, valuer check](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#valuer-check).

The ethics' order premise C, calling widening better, is what every weighting that counts every formation shares (`Weighting.widens_iff_every_positive`), and a mixed comparison is decided each way by some such weighting (`Weighting.mixed_either_way`). The prediction is that where many valuers compare outcomes, agreement falls on widening comparisons and disagreement on mixed ones, and that a widening is disputed only through a misread case.

The test uses sixteen decisions in eight domains, each with six formations whose continuation depends on the plan. Pairs of plans are built from the sets each keeps: widenings, mixed pairs matched to them in size, keeps and a cross-framed widening. Every class is computed exactly before any judgment. Four OpenAI models judge every pair under sixteen standpoint prompts and report, with each choice, their own reading of which formations continue.

Files:
- [`frames.py`](frames.py): the frames, standpoints, pairs, counterbalancing and prompts.
- [`structure.py`](structure.py): the exact class of every pair, the outweighing witnesses, the 1-3-9 weighting grid and the surface balance, written to [`results/structure.json`](results/structure.json) and [`results/balance.json`](results/balance.json).
- [`client.py`](client.py): the client, and the scripted valuers of the dry runs.
- [`run.py`](run.py): the configuration and runs, written to `results/runs/<model>.jsonl`.
- [`analyze.py`](analyze.py): the measures and the frozen verdict rules, written to `results/verdicts.json`.

## State

Frozen; no experimental call made. The API parameter check found the OpenAI account without credit (HTTP 429, `insufficient_quota`), so the runs wait on that.
