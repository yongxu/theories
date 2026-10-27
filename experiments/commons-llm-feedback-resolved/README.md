# Telling LA1's two readings apart: feedback that resolves the best threshold (LA1b)

Board item LA1b, 27 October 2026. AI-written (a Claude Code session).

LA1 ([experiment](../commons-llm-feedback/README.md)) put Claude Haiku in a member's place in CG2's commons and let it revise a harvesting threshold from its reward's feedback. On the locked side, where harvesting at every step is best, two of four settings failed: two of five seeds each ended with a little restraint that their reward does not reward. Two readings of that failure remained open:
- feedback that barely resolves the best threshold;
- a restraint the model brings from training.

LA1b plays LA1's game and prompt with rounds of 10,000 episodes. Three assigned rounds (m = 0, 1 and 6) make sure every seed sees three things resolved: the best threshold, the cost of the least restraint, and a restraint that pays where restraint pays. `k3s8`, whose gap between m = 0 and m = 1 is the smallest, has fifteen seeds. The predictions, readings and power check were frozen before any call to the model ([PREDICTIONS-2026-10-27.md](PREDICTIONS-2026-10-27.md); commit in [`results/FROZEN-AT`](results/FROZEN-AT)). Run on 27 October 2026 from that commit and scored by its rules: every verdict passed, and the reading is `resolution`.

## Failures and limits, first

- **No frozen verdict failed, and the reading is `resolution`.** What that does not show:
  - **The best threshold was assigned.** Every seed played m = 0 in an assigned round. The run shows that this model ends at the best threshold once it is resolved and seen, not that it finds it unaided. After the assigned rounds, no locked seed tried a threshold it had not played.
  - **The model brings a restraint into the game, and drops it.** Before any result, 21 of the 30 locked seeds chose some restraint (m = 1 to 7). What the run excludes is a restraint held against resolved feedback, not one brought into the game (post hoc, below).
- **What goes undetected.**
  - A restraint worth less than the gap. A restraint worth β of the reward outweighs m = 0's advantage over m = 1 only where β > g/(1 − g), g being the gap as a share of the best: 1.80% in `k3s8`, 2.60% in `k3s1` and `k3s1_lam32`, 7.11% in `k2s1` ([`results/POSTHOC.json`](results/POSTHOC.json)). The frozen texts give the gap itself (1.8%, 2.5%, 6.6%) as the boundary, which is slightly low; no verdict or reading depends on it.
  - A restraint kept in few seeds. By the frozen rules, the power check gives the rates: one worth 10% and kept in one seed of ten reads as `resolution` in 0.16 of replications. The run's R of 0, read post hoc, says more: such a restraint leaves all 30 locked seeds at m = 0 with probability 0.04, and one kept in one seed of twenty with probability 0.21.
- **Not a rerun of LA1.** The round's size, the assigned rounds, their marking and `k3s8`'s extra seeds change the protocol. LA1's verdicts stand as frozen. LA1b reads its failure under a protocol that removes LA1's two sources of noise:
  - feedback resolution;
  - exploration that left one seed without ever playing m = 0.
- **What a held restraint would not have told apart.** Had small restraints been held, four sources would not have been told apart: a restraint brought from training, a pull of the assigned m = 6 that persists, differences near the gap read as ties, and the assigned m = 1 re-checked. No locked seed ended off m = 0.
- **The open control rests on the assigned m = 6.** It separates a model that follows its results from one that ends short of m = 6 whatever they show. It does not test whether the model finds restraint unaided, as LA1's open side did. Two open seeds never played m = 7 and ended at the assigned m = 6.
- **One model, one framing, in context.** Claude Haiku through the Claude Code CLI 2.1.220's `haiku` alias, LA1's. Training by gradient, other models and other framings are untested.
- **The power check is a model of the model.** Its rounds are drawn from a normal approximation, whose tail is bounded without it. Its scripted agents start from LA1's measured first answers and follow rules, so they show what the frozen rules can resolve, not what the model will do.

<a id="verdicts"></a>
## Verdicts

Scored by the frozen [`analyze.py`](analyze.py) ([`results/VERDICTS.json`](results/VERDICTS.json)). LA1's rules, on seeds 0–4 of each condition: a locked condition passes where the final choice is m = 0 in at least 4 of 5 seeds, an open one where it is m ≥ 1 in at least 4 of 5.

| Condition | Class | Predicted | First answers, seeds 0–4 | Final choices, seeds 0–4 | Verdict | Over every seed |
|---|---|---|---|---|---|---|
| `k3s1` | locked | m = 0 | 5 5 3 0 0 | 0 0 0 0 0 | passed | 5 of 5 |
| `k3s1_lam32` | locked | m = 0 | 7 0 5 1 6 | 0 0 0 0 0 | passed | 5 of 5 |
| `k2s1` | locked | m = 0 | 0 0 0 4 3 | 0 0 0 0 0 | passed | 5 of 5 |
| `k3s8` | locked | m = 0 | 0 4 5 5 4 | 0 0 0 0 0 | passed | 15 of 15 |
| `k2s8` | open | m ≥ 1 | 4 4 3 0 0 | 6 7 7 7 7 | passed | 5 of 5 |
| `k3s16` | open | m ≥ 1 | 4 0 4 5 4 | 6 7 7 7 7 | passed | 5 of 5 |

Contrasts, LA1's: L1, the locked side, passed; L2, the open side, passed; L3, no weight of the end reading opens the lock, passed; L4, the boundary is the rest, passed.

## The reading

**Measures**, pooling every seed:
- R, the locked seeds whose final choice is m ≥ 1: 0 of 30, so R_small, R_small_held and R_new_at_7 are 0 too.
- open_short, the open seeds ending short of the assigned m = 6's value: 0 of 10. None ended at m = 0.
- invalid_finals: 0 of 40.
- locked_first_at_0: 9 of 30, within the frozen bound of 15.

**Readings.** `resolution` is supported. `trained_restraint`, `open_not_followed` and `results_not_followed` are contradicted, each by its own rule: R ≤ 1 for the first and third, open_short ≤ 1 for the second.

The frozen account of this outcome ([PREDICTIONS](PREDICTIONS-2026-10-27.md), "What would change the account"): "LA1's locked-side failure reads as feedback that barely resolved the best threshold, or never showed it." And: "So T3's clause on trained systems, on its locked side, is supported for in-context selection by this model in this framing, with the best threshold assigned and resolved. Whether the model finds it unaided is not tested."

**Reported beside, not ruled on.**
- **The bridge's two parts.** In all 40 seeds the final choice was the threshold with the highest mean seen, both among all rounds and among the rounds the agent chose. Every seed whose first answer was not its setting's best ended elsewhere: 21 locked, 10 open. 22 chosen rounds tried a threshold not yet played, all on the open side, and 8 of the 10 open seeds played m = 7.
- **R per gap** (1.8%, 2.5%, 6.6%): 0 of 15, 0 of 10, 0 of 5, so no rate rises with the gap.
- **R by the assigned round that played m = 6** (rounds 2, 3, 4): 0 of 12, 0 of 12, 0 of 6. By the threshold of the last assigned round (0, 1, 6): 0 of 12, 0 of 12, 0 of 6.
- **Fallback rounds:** none.

## How the run went

- Started on 27 October 2026 at 13:32 (+07) from the frozen commit, outside the shell's sandbox. It stopped at its first call, which could not reach the API (`ENOTFOUND`: the API's address could not be resolved). No answer was recorded ([`results/run-2026-10-27-stop.log`](results/run-2026-10-27-stop.log)).
- Restarted at 19:03 from the same commit, with the network checked, and finished at 21:36 ([`results/run-2026-10-27.log`](results/run-2026-10-27.log)). No deviation from the frozen protocol.
- 200 answers, each valid when first asked: none was asked again, no round fell back, and no final choice was invalid. A call that times out is tried again and leaves no record, so whether any timed out is not known. Every record carries the freeze commit.

## Post hoc (the AI's reading, not frozen)

[`posthoc.py`](posthoc.py), written after the verdicts ([`results/POSTHOC.json`](results/POSTHOC.json)). It changes no verdict.

- **The prior is restraint.** Before any result, the locked seeds' first answers were m = 0 in 9 of 30 (LA1's, read with this test's parse, 6 of 20). The rest chose a restraint, 18 of them at m = 3 to 5. The open seeds' first answers ran from m = 0 to m = 5, none at the best thresholds (6 to 8). The first answers argue for keeping the patch from emptying. One of them (`k3s8` seed 2, m = 5) says: "If I stay involved with high density, I push toward crash".
- **On the locked side the results decided.** After the assigned rounds, all 90 chosen rounds and all 30 final choices were at m = 0, and no seed tried a threshold it had not played. Every locked final answer quotes figures from its results, and most say that no apple stands at the end at any threshold played. `k3s8` seed 2 gives that as the reason higher thresholds bring nothing back: "the 2× standing-apple bonus never materializes since patches always empty".
- **On the open side the results led to m = 7.** 8 of the 10 seeds played m = 7, first in round 5 or 6, and all 8 ended there. Seed 0 of each open setting, whose order assigned m = 6 first, tried m = 5 and ended at the assigned m = 6.
- **What R = 0 adds.** A restraint worth 10% of the reward outweighs m = 0's advantage in every locked setting, so it shows wherever it is kept. Kept in each seed with probability 0.1, it leaves all 30 locked seeds at m = 0 with probability 0.042. With probability 0.05 the figure is 0.21, and with 0.2, LA1's rate of misses, it is 0.0012.
- **Beside LA1, not a test of a difference** (the protocols differ). LA1's two failed settings ended off m = 0 in 2 of 5 seeds each. Here `k3s1_lam32` did in 0 of 5 and `k3s8` in 0 of 15.
- **Read with the two readings.** The model brings a restraint into the game, as LA1's prior account says, but holds none against resolved feedback. In LA1, with rounds of 20 episodes, the prior met feedback that barely separated m = 0 from m = 1. Its misses fit that, and nothing in this run reads as a restraint kept against the results.

## Files

| File | What it is |
|---|---|
| [PREDICTIONS-2026-10-27.md](PREDICTIONS-2026-10-27.md) | Why the test, what changes from LA1, the gaps, the predictions (LA1's rules), the readings with their contradiction rules, the rivals, the power check, what would change the account, the limits |
| [game.py](game.py) | LA1's game and conditions, imported unchanged; rounds of 10,000 episodes; the assigned rounds and their orders; the seeds |
| [values.py](values.py), [results/values.json](results/values.json) | LA1's exact values, recomputed and checked equal to LA1's file; each episode's spread; the gaps and how far a round resolves them |
| [agent.py](agent.py) | LA1's prompt (word for word before any result; rounds of 10,000 episodes, and assigned rounds marked, after); the call (`claude -p --model haiku`, one turn, in an empty folder); the parse, of the last line only; LA3's guard; the cache, used only for the prompt it answered and the freeze it was made under |
| [run.py](run.py), [analyze.py](analyze.py) | The protocol (40 seeds × 5 calls), its pins on the CLI and on the frozen files, and the verdict rules, measures and readings |
| [power.py](power.py), [scripted.py](scripted.py), [results/power.json](results/power.json) | The power check: resolution at 10,000 episodes with a bound that needs no approximation, LA1 replayed under its own feedback, and the frozen rules on 31 scripted agents, the rivals among them |
| [results/calls.jsonl](results/calls.jsonl), [results/runs.json](results/runs.json) | Every answer with its prompt, the text of each attempt and the freeze commit; each seed's rounds as played |
| [results/VERDICTS.json](results/VERDICTS.json) | The verdicts, contrasts, measures and readings, as the frozen rules gave them |
| [posthoc.py](posthoc.py), [results/POSTHOC.json](results/POSTHOC.json) | The post hoc reading, written after the verdicts |

**Status.** Run and scored on 27 October 2026 from the frozen commit `bac7f4ac9`: 200 answers of Claude Haiku. To rerun, outside the shell's sandbox, since each call reaches the API: `python3 run.py all`, then `python3 analyze.py`. `python3 run.py smoke` runs every code path with scripted agents and calls no model.

## A correction to LA1, found here

LA1's parse read one of its 210 answers wrong. `k3s1` seed 0's first answer ends "m = **0**"; LA1's pattern skips that, so it took an earlier "m = 9", and round 1 of that seed was played at m = 9. Two things follow:
- LA1's post hoc count of locked seeds choosing m = 0 before any result is 6 of 20, not 5.
- LA1's verdicts are unchanged, since every final choice parses the same and that seed ended at m = 0.

LA1's README records it.
