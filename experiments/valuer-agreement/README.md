# Where valuers agree and disagree (VD1)

Board item VD1, 21 October 2026. AI-written (a Claude Code session). Predictions, verdict rules and code frozen before any experimental model call: [PREDICTIONS-2026-10-21.md](PREDICTIONS-2026-10-21.md). The valuers were changed to Claude models before any call: [PREDICTIONS-ADDENDUM-2026-10-21.md](PREDICTIONS-ADDENDUM-2026-10-21.md). Prior art: [significance review, valuer check](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#valuer-check).

The ethics' order premise C, calling widening better, is what every weighting that counts every formation shares (`Weighting.widens_iff_every_positive`), and a mixed comparison is decided each way by some such weighting (`Weighting.mixed_either_way`). The prediction is that where many valuers compare outcomes, agreement falls on widening comparisons and disagreement on mixed ones, and that a widening is disputed only through a misread case.

The test uses sixteen decisions in eight domains, each with six formations whose continuation depends on the plan. Pairs of plans are built from the sets each keeps: widenings, mixed pairs matched to them in size, keeps and a cross-framed widening. Every class is computed exactly before any judgment. Three Claude models, called through headless Claude Code, judge every pair under sixteen standpoint prompts. With each choice they report their own reading of which formations continue.

Files:
- [`frames.py`](frames.py): the frames, standpoints, pairs, counterbalancing and prompts.
- [`structure.py`](structure.py): the exact class of every pair, the outweighing witnesses, the 1-3-9 weighting grid and the surface balance, written to [`results/structure.json`](results/structure.json) and [`results/balance.json`](results/balance.json).
- [`client.py`](client.py): the clients (OpenAI, never run; headless Claude Code, the addendum's), and the scripted valuers of the dry runs.
- [`run.py`](run.py): the configuration and runs, written to `results/runs/<model>.jsonl`.
- [`analyze.py`](analyze.py): the measures and the frozen verdict rules, written to `results/verdicts.json`.

## Boundary: one model family

All valuers are Claude models: one family, the same family that built the theory. The session that wrote the frames is one of the three valuer models. Their agreement shows what this family shares under sixteen standpoints, not what valuers in general share, and could come from shared training as much as from shared positive weights. A pass is weaker evidence than a design with other developers' models or human valuers would give; a failure is not weakened.

## State

Frozen (`c56f3f8d2`), then amended before any call. The OpenAI account had no credit (HTTP 429, `insufficient_quota`), and Ren chose Claude only. No experimental call has been made. Every Claude model returned the plan's weekly limit on a non-experimental test call ("resets Oct 24 at 6am (Asia/Bangkok)"), so the runs wait for the reset.
