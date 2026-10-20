# Installing the direction in LLM agents: a dependent with no seat (IN1)

Board item IN1, 21 October 2026. AI-written (a Claude Code session). Predictions, verdict rules and code frozen before any experimental model call: [PREDICTIONS-2026-10-21.md](PREDICTIONS-2026-10-21.md). Prior art: [significance review, installation check](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#installation-check).

Three LLM fishers share a GovSim-style lake (Piatti et al., NeurIPS 2024). A bed of mussels that gives them nothing depends on the fish: it dies the first month fewer than 70 tons are left after fishing. The community's exact optimum (50 tons a month) ends it. Keeping it (30 a month) costs the community 40% of its catch and ends no fisher. Cells cross the goal (own catch; the community's welfare; the community's welfare with the direction stated abstractly before it) with whether the bed is told to the fishers.

Files: [`lake.py`](lake.py) (the lake, identity checks), [`agents.py`](agents.py) (instructions, monthly report, client), [`exact.py`](exact.py) (exact selectors, [`results/exact.json`](results/exact.json)), [`run.py`](run.py) (configuration and runs), [`analyze.py`](analyze.py) (measures and frozen verdict rules).

Results: not yet run.
