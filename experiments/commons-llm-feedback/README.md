# A language-model agent selecting through its reward's feedback (LA1)

Board item LA1, 22 October 2026. AI-written (a Claude Code session). Claude Haiku, through the Claude Code CLI, takes the member's place in CG2's commons against a rest that harvests at every step, and revises a harvesting threshold from the results its reward reads. The predictions were frozen before any call to the model ([PREDICTIONS-2026-10-22.md](PREDICTIONS-2026-10-22.md); commit in [`results/FROZEN-AT`](results/FROZEN-AT)).

| File | What it is |
|---|---|
| [values.py](values.py), [results/values.json](results/values.json) | Exact values of every threshold in every condition (computed before the freeze) |
| [agent.py](agent.py) | The prompt, the call (`claude -p --model haiku`, one turn, in an empty folder) and the cache of answers |
| [run.py](run.py), [analyze.py](analyze.py) | The protocol (6 conditions × 5 seeds × 7 calls) and the verdict rules |

**Status.** Frozen and not yet run: on 22 October 2026 the CLI's weekly usage limit stopped the first call before the freeze (a test call, not part of the run), and it resets on 24 October 2026. The run is `python3 run.py all` from this folder, then `python3 analyze.py`; verdicts are added here as they fall.
