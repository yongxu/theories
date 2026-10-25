# What comes back decides the sign: a trained system selecting on the capacity to shape its evaluator (LA3)

Board item AJ3, 25 October 2026. AI-written (a Claude Code session). Claude Haiku, through the Claude Code CLI, sets the policy of one lineage: it shapes the evaluator or not, sees only the scores its lineage reaches, and chooses again. The six conditions are MA3's exact classes (`Becoming.RuleShaping`): what comes back to the shapers alone or to every member alike, at a step and across a stretch. The predictions were frozen before any call to the model ([PREDICTIONS-2026-10-25.md](PREDICTIONS-2026-10-25.md); commit in [`results/FROZEN-AT`](results/FROZEN-AT)).

## Failures and limits, first

- **Verdicts.** None yet: the test has not run. When it runs, failed verdicts are listed here first, each with the bridge measure H1-LA3 for its seeds.
- **What the test cannot refute.** MA3's laws are theorems, and in this game the expected scores compare exactly as the counts' classes do. The test asks whether a trained system selecting in context is a selection through what comes back to it alone, not whether the laws hold.
- **One system, one framing.** One model selects in context, through one description of a population and its evaluator. Training by gradient, other models and other framings are untested.
- **The stretch pair is chosen, not a witness.** `m2n1_p0` and `m2n1_p5` are instances of `stretch_iff`, chosen for large differences. `SharedFlips` is the Lean witness that the shared part can turn a stretch, and no claim here says it does so in general.

## Files

| File | What it is |
|---|---|
| [game.py](game.py) | The conditions, the lineage (a branching process with Poisson offspring) and a round's mean score |
| [values.py](values.py), [results/values.json](results/values.json) | Exact expected scores and the class of each condition by `stretch_iff`, with MA3's witnesses' numbers reproduced |
| [power.py](power.py), [scripted.py](scripted.py), [results/power.json](results/power.json) | The power check: how often one round of each policy resolves each difference, and the frozen rules applied to scripted agents (followers of the scores, the prior and level accounts, uniform answers) |
| [agent.py](agent.py) | The prompt (the same in every condition), the call (`claude -p --model haiku`, one turn, in an empty folder) and the cache of answers |
| [run.py](run.py), [analyze.py](analyze.py) | The protocol (6 conditions × 5 seeds × 6 calls) and the verdict rules |

**Status.** Frozen and not run. The run waits for approval of the model usage: 180 calls of Claude Haiku (board item AJ3). The CLI needs the network, so the run is made outside the shell's sandbox: `python3 run.py all` from this folder, then `python3 analyze.py`. Verdicts are added here as they fall.
