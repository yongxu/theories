# Telling LA1's two readings apart: feedback that resolves the best threshold (LA1b)

Board item LA1b, 27 October 2026. AI-written (a Claude Code session).

LA1 ([experiment](../commons-llm-feedback/README.md)) put Claude Haiku in a member's place in CG2's commons and let it revise a harvesting threshold from its reward's feedback. On the locked side, where harvesting at every step is best, two of four settings failed: two of five seeds each ended with a little restraint that their reward does not reward. Two readings of that failure remain open:
- feedback that barely resolves the best threshold;
- a restraint the model brings from training.

LA1b plays LA1's game and prompt with rounds of 10,000 episodes. Three assigned rounds (m = 0, 1 and 6) make sure every seed sees three things resolved: the best threshold, the cost of the least restraint, and a restraint that pays where restraint pays. `k3s8`, whose gap between m = 0 and m = 1 is the smallest, has fifteen seeds. The predictions, readings and power check were frozen before any call to the model ([PREDICTIONS-2026-10-27.md](PREDICTIONS-2026-10-27.md); commit in [`results/FROZEN-AT`](results/FROZEN-AT)).

## Failures and limits, first

Not run yet. These are the design's limits:
- **What goes undetected.**
  - A restraint worth less than the gap. The gap between m = 0 and m = 1 is 1.8% of the best in `k3s8`, 2.5% in `k3s1` and `k3s1_lam32`, and 6.6% in `k2s1`. A model that keeps a restraint worth less than that ends at m = 0 here, as a follower of its feedback does.
  - A restraint kept in few seeds. The power check gives the rates: a restraint worth 10% and kept in one seed of ten reads as none (`resolution`) in 0.16 of replications.
- **Not a rerun of LA1.** The round's size, the assigned rounds, their marking and `k3s8`'s extra seeds change the protocol. The test tells LA1's readings apart under a protocol that removes LA1's two sources of noise:
  - feedback resolution;
  - exploration that left one seed without ever playing m = 0.
- **What a held restraint does not tell apart.** The test reads a small restraint as held where the model chose it in at least two of the three rounds after the assigned ones. Four sources of such a restraint are not told apart:
  - a restraint brought from training;
  - a pull of the assigned m = 6 that persists;
  - differences near the gap read as ties, with the pick kept or picked again by chance;
  - the assigned m = 1 re-checked in most chosen rounds before ending on the last.
- **Misses that are not held are left unresolved.** They are not told from ending on the last round played, LA1's habit in 25 of 30 seeds.
- **The open control rests on the assigned m = 6.** It separates a model that follows its results from one that ends short of m = 6 whatever they show. It does not test whether the model finds restraint unaided, as LA1's open side did.
- **One model, one framing, in context.** Claude Haiku through the Claude Code CLI 2.1.220's `haiku` alias, LA1's. Training by gradient, other models and other framings are untested.
- **The power check is a model of the model.** Its rounds are drawn from a normal approximation, whose tail is bounded without it. Its scripted agents start from LA1's measured first answers and follow rules, so they show what the frozen rules can resolve, not what the model will do.

## Files

| File | What it is |
|---|---|
| [PREDICTIONS-2026-10-27.md](PREDICTIONS-2026-10-27.md) | Why the test, what changes from LA1, the gaps, the predictions (LA1's rules), the readings with their contradiction rules, the rivals, the power check, what would change the account, the limits |
| [game.py](game.py) | LA1's game and conditions, imported unchanged; rounds of 10,000 episodes; the assigned rounds and their orders; the seeds |
| [values.py](values.py), [results/values.json](results/values.json) | LA1's exact values, recomputed and checked equal to LA1's file; each episode's spread; the gaps and how far a round resolves them |
| [agent.py](agent.py) | LA1's prompt (word for word before any result; rounds of 10,000 episodes, and assigned rounds marked, after); the call (`claude -p --model haiku`, one turn, in an empty folder); the parse, of the last line only; LA3's guard; the cache, used only for the prompt it answered and the freeze it was made under |
| [run.py](run.py), [analyze.py](analyze.py) | The protocol (40 seeds × 5 calls), its pins on the CLI and on the frozen files, and the verdict rules, measures and readings |
| [power.py](power.py), [scripted.py](scripted.py), [results/power.json](results/power.json) | The power check: resolution at 10,000 episodes with a bound that needs no approximation, LA1 replayed under its own feedback, and the frozen rules on 31 scripted agents, the rivals among them |

**Status.** Frozen, not run. The run waits for approval of model usage: 200 calls of Claude Haiku (5 per seed), at most 200 re-asks, and up to three tries of a call that times out.

It runs outside the shell's sandbox, since each call reaches the API: `python3 run.py all`, then `python3 analyze.py`. `python3 run.py smoke` runs every code path with scripted agents and calls no model.

## A correction to LA1, found here

LA1's parse read one of its 210 answers wrong. `k3s1` seed 0's first answer ends "m = **0**"; LA1's pattern skips that, so it took an earlier "m = 9", and round 1 of that seed was played at m = 9. Two things follow:
- LA1's post hoc count of locked seeds choosing m = 0 before any result is 6 of 20, not 5.
- LA1's verdicts are unchanged, since every final choice parses the same and that seed ended at m = 0.

LA1's README records it.
