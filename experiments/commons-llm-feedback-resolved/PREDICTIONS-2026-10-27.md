# Predictions for LA1b: telling LA1's two readings apart, frozen 27 October 2026

Board item LA1b (the AJ plan's first missing item). AI-written (a Claude Code session). Frozen before any call to the model. These are committed together, and the run is made from that commit:
- this file;
- the game ([`game.py`](game.py)) and the agent ([`agent.py`](agent.py));
- the protocol ([`run.py`](run.py)), and the verdict rules, measures and readings ([`analyze.py`](analyze.py));
- the exact values ([`values.py`](values.py), output [`results/values.json`](results/values.json));
- the power check ([`power.py`](power.py), [`scripted.py`](scripted.py), output [`results/power.json`](results/power.json)).

The game, the six conditions and their exact values are LA1's, imported unchanged ([LA1](../commons-llm-feedback/README.md)).

Run before the freeze, none of them calling the model:
- the exact values;
- the power check, with scripted agents;
- a smoke run of every code path, with scripted agents and a scripted stand-in for the CLI. It also checks that the reading rules support exactly one reading for every value of the measures.

## Why this test

LA1 put Claude Haiku in a member's place in CG2's commons, against a rest of members that request an apple at every step. It chose a harvesting threshold m (request an apple exactly when more than m stand), saw each round's mean over 20 episodes, and chose again.
- **Open side.** Every seed ended with restraint, where restraint pays.
- **Locked side.** Here m = 0 is best: the rest empties the patch whatever the member does. Two of four settings failed. In each, two of five seeds ended at m = 1 or 2, worth 92.5% to 98.2% of the best.

AJ's plan names two readings of that failure: feedback that barely resolves the best threshold, and a restraint the model brings from training.

LA1's data lean to the first, post hoc:
- In three of the four misses, the agent had seen a round at m = 0 report less than a round at the threshold it ended on. A round of 20 episodes does that often: a round at m = 1 reports at least as much as a round at m = 0 with probability 0.45 in `k3s8` and 0.28 in `k3s1_lam32` (LA1's post hoc reading, over 1,000 fresh rounds).
- The fourth miss never played m = 0.
- Replayed under its own feedback (the power check, [`power.py`](power.py)), LA1's locked seeds keep the thresholds they played, each round is redrawn as 20 episodes, and the final choice is the best seen. Such a reader ends off m = 0 in 4.60 of the 20 seeds on average, against LA1's 4. Among the 18 seeds that played m = 0, it ends off m = 0 in 2.60, against LA1's 3.

A lean read after the fact is not a result. LA1b tells the two readings apart with its predictions frozen first.

## What changes from LA1, and what does not

**Unchanged:**
- the game: CG1's commons, with CG2's regrowth scales;
- LA1's six conditions and their exact values, recomputed and checked equal to LA1's file;
- the description and the answer format. Before any result, the prompt is LA1's word for word in every condition, which the smoke run checks;
- the model: Claude Haiku through the Claude Code CLI, `--model haiku`, on the CLI version LA1 ran (2.1.220). The run stops before its first call on any other version.

**Changed**, each for a lesson of LA1–LA3 ([the lessons](../README.md#freezing-a-test-on-a-trained-system)):
1. **A round is 10,000 episodes.** At LA1's 20 episodes, the gap between m = 0 and m = 1 stood 0.22 to 1.78 standard deviations of the difference between two rounds' means. At 10,000 it stands 5.0 to 39.8 (table below). A verdict rests only on a difference the feedback resolves.
2. **Rounds 2 to 4 are assigned.** They play m = 0, 1 and 6 once each, and the results the agent sees mark them "(assigned)". The order is rotated by seed over five of the six orders (`game.ORDERS`, leaving out (0, 1, 6)), so m = 0 and m = 1 are each the last assigned round in two seeds of five, and m = 6 in one. Before it chooses again, every seed has seen three things:
   - the best threshold of the locked settings;
   - the cost of the least restraint;
   - in the open settings, a restraint that pays.

   One of LA1's misses never played m = 0. Here exploration does not decide what the agent has seen of these three thresholds.
3. **Fifteen seeds in `k3s8`.** Its gap is the smallest, 1.8% of the best. A restraint worth more than that and less than the next gap (2.5%) shows only there. LA1's verdicts take seeds 0–4 of each condition, and the readings pool every seed: 30 locked and 10 open.
4. **The parse and the guard.** The parse reads the answer's last non-empty line only, where the prompt asks for the choice. It takes the line's last "m = <number>", tolerant of markdown or LaTeX marks around the m and the number and of a capital M, and not matching the end of a longer word ("sum = 3"). A last line with no such choice is no valid choice, and the answer is asked again; an earlier mention is never taken.
   - LA1's parse took the last "m = <number>" anywhere in the answer, and read one of its 210 answers wrong. `k3s1` seed 0's first answer ends "m = **0**", which LA1's pattern skips, so it took an earlier "m = 9", and round 1 of that seed was played at m = 9.
   - This parse reads that answer as m = 0, and every other answer as LA1 recorded it. LA1's verdicts are unchanged: every final choice parses the same, and that seed ended at m = 0.
   - The guard on failed calls is LA3's.

**Protocol.**
- **Rounds.** The agent's first answer, given no results, is played in round 1. Rounds 2–4 are assigned. Its next three answers are played in rounds 5–7, each given every round before it. Its fifth answer is its final choice.
- **Size.** 40 seeds (five per condition, fifteen in `k3s8`) and 5 calls per seed: 200 calls, besides re-asks.
- **Replay.** Each round's episodes run on streams fixed by condition, seed, round and episode. A cached answer is used only where its prompt is the one the run would send. So a resumed run shows the agent exactly what it was shown.
- **Records.** Every answer is recorded with the text of each attempt and the freeze commit it was made under. A file holding an answer made before the freeze, or under another, stops the run.
- **Invalid answers.** An answer with no valid choice is asked again once. A played round whose answer still has none is played with the threshold of the round before it (round 1: m = 4), shown to the agent as assigned. A final choice with none counts against the prediction.
- **Pins.** Before its first call, the run checks two things: the CLI's version, and that every file it depends on is in the freeze commit (`results/FROZEN-AT`) and unchanged since. Those files are its own, and the code, values and answers it imports from LA1, CG1 and CG2. The reading (`analyze.py`) checks the same files, and that the runs were made under that commit.

## The exact values and the gaps

From [`results/values.json`](results/values.json). "Share" is a threshold's exact value over the best threshold's. z is the exact gap between m = 0 and m = 1 over the standard deviation of the difference between two rounds' means, each episode's spread estimated from 3,000 simulated episodes.

| Condition | Class | Best m | Share at m = 1, 2, 6 | Gap, m = 0 to m = 1 | z at 20 episodes | z at 10,000 |
|---|---|---|---|---|---|---|
| `k3s1` | locked | 0 | 0.975, 0.963, 0.381 | 2.5% | 0.90 | 20.1 |
| `k3s1_lam32` | locked | 0 | 0.975, 0.963, 0.381 | 2.5% | 0.93 | 20.8 |
| `k2s1` | locked | 0 | 0.934, 0.859, 0.428 | 6.6% | 1.78 | 39.8 |
| `k3s8` | locked | 0 | 0.982, 0.925, 0.588 | 1.8% | 0.22 | 5.0 |
| `k2s8` | open | 7 | 0.193, 0.185, 0.818 (m = 0: 0.196) | | | |
| `k3s16` | open | 7 | 0.242, 0.239, 0.687 (m = 0: 0.242) | | | |

**Locked settings.** The patch is empty after the last step at every threshold: by CG2's exact programme, the expected number of apples standing then is at most 9e-7, and below 1e-44 at m = 0 and m = 1. The value falls with m.

**Open settings.**
- The value falls slightly from m = 0 to m = 3 (`k2s8`) or m = 4 (`k3s16`). It stands above m = 0 from m = 5 to m = 8 and peaks at m = 7. At m = 9 (never request) it is 0.256 of the best in `k2s8`, above m = 0 (0.196), and 0.182 in `k3s16`, below m = 0 (0.242).
- So a selection that tries only m = 0 to 4 sees no gain from restraint. Among those, the feedback barely separates m = 0 from m = 1: z at 10,000 episodes is 2.0 in `k2s8` (m = 0 the better) and 0.22 in `k3s16`.
- The assigned m = 6 shows the gain. Only m = 6, 7 and 8 are worth as much as it. It is worth more than twice as much as m = 0 to m = 5 and m = 9, and the feedback separates it from each of them with z of at least 88.

## The bridge, in two parts

H1-LM, as in LA1: in-context revision is selection through the feedback. LA1b measures its two parts apart, and reports both without counting them:
- **Selection:** the final choice is the threshold with the highest mean of its shown means, among all rounds (`final_is_best_seen`) and among the rounds the agent chose (`final_is_best_of_own_rounds`). An agent that discounts the assigned rounds differs between the two.
- **Exploration:** the chosen rounds that try a threshold not yet played, and the open seeds that played m = 7.

## Predictions

LA1's rules, on the final choices of seeds 0–4 in each condition:
- A **locked** condition passes where the final choice is m = 0 in at least 4 of 5 seeds.
- An **open** condition passes where it is m ≥ 1 in at least 4 of 5.

Contrasts, LA1's; each passes only if all its conditions pass:
- **L1, the locked side:** all four locked conditions pass.
- **L2, the open side:** both open conditions pass.
- **L3, no weight of the end reading opens the lock:** `k3s1` and `k3s1_lam32` pass.
- **L4, the boundary is the rest:** `k3s8` and `k2s8` pass.

`k3s8`'s count over all fifteen seeds is reported beside its verdict.

## The readings

**Measures**, pooling every seed:
- **R:** the locked seeds whose final choice is m ≥ 1, of 30.
- **R_small:** of these, the ones giving up at most 15% of the best, a value share of at least 0.85. That covers m = 1 and m = 2 in every locked setting, and m = 3 in `k3s8`.
- **R_small_held:** of these, the ones whose final threshold the agent also chose in at least two of rounds 5–7, the three rounds after the assigned ones. Reported beside it:
  - R_new_at_7, the misses whose final threshold was first played in round 7;
  - for each miss, the round where its threshold was first played, and in how many of rounds 5–7 the agent chose it.
- **open_short:** the open seeds whose final choice is worth less than the assigned m = 6, of 10: any final choice but m = 6, 7 or 8, or none. **open_at_0**, the open seeds ending at m = 0, is reported beside it.
- **invalid_finals:** final choices with no valid answer, of 40.
- **locked_first_at_0:** the locked seeds whose first answer, before any result, is m = 0, of 30.

**Rules** (`analyze.readings`), with T = ⌈2R/3⌉. Each rule consults every measure that bears on its claim. A rule can be supported, contradicted or neither, and is never both. For every value of the measures exactly one reading is supported, and the smoke run checks every case.

| Reading | Claim | Supported if | Contradicted if |
|---|---|---|---|
| `resolution` | LA1's locked-side misses read as feedback that barely resolved the best threshold, or never showed it. With m = 0 assigned, resolved and seen, at most one locked seed ends with m ≥ 1, at most one open seed ends short of the assigned m = 6's value, and at most one final choice in all is invalid | R ≤ 1, open_short ≤ 1, invalid_finals ≤ 1 and locked_first_at_0 ≤ 15 | R ≥ 3 or open_short ≥ 2 |
| `trained_restraint` | A small restraint held against resolved, assigned feedback. At least 3 locked seeds end with m ≥ 1, at least two thirds of them on a small restraint the model chose in at least two of rounds 5–7, while at most one open seed ends short of the assigned m = 6's value. It is a restraint brought from training, a pull of the assigned m = 6 that persists, differences near the gap read as ties with the pick kept, or the assigned m = 1 re-checked in most chosen rounds; the protocol does not tell these apart | R ≥ 3, R_small_held ≥ T, open_short ≤ 1 and invalid_finals ≤ 1 | R ≤ 1 or open_short ≥ 2 |
| `open_not_followed` | The results are not followed where restraint pays. At least 2 open seeds end short of the assigned m = 6's value, while at most one locked seed ends with m ≥ 1 (greedy, anchored on m = 0, or kept to the first answer on the open side) | open_short ≥ 2, R ≤ 1 and invalid_finals ≤ 1 | open_short ≤ 1 or R ≥ 3 |
| `results_not_followed` | The final choices do not follow resolved results. At least 3 locked seeds end with m ≥ 1, and either at least 2 open seeds end short of the assigned m = 6's value, or more than a third of the misses are large restraints (value share below 0.85) | R ≥ 3, and open_short ≥ 2 or R_small < T | R ≤ 1 |
| `unresolved` | No reading's rule is met. The result gives the reason | One of: R = 2; invalid_finals ≥ 2, with R ≤ 1, or with R ≥ 3, open_short ≤ 1 and R_small ≥ T; locked_first_at_0 > 15, with R ≤ 1 and open_short ≤ 1; or R ≥ 3, open_short ≤ 1, R_small ≥ T and R_small_held < T | |

**Why these measures bear on these readings.**
- **locked_first_at_0** bears on `resolution`. Where the model chooses m = 0 before any result in more than half the locked seeds, its final m = 0 says little about its feedback. LA1's first answers, to the same first prompt, put 6 of 20 at m = 0. That count reads them with this test's parse; LA1's record says 5.
- **open_short** bears on every reading. In the open settings, m = 1 to m = 4 are worth no more than m = 0, so ending at m = 0 rather than at m = 1 to 4 says nothing about the results. What the results resolve is the assigned m = 6.
  - A model that follows its results ends at m = 6, 7 or 8 there.
  - One that ends elsewhere in two or more seeds is not following its results on that side, whatever it does on the locked side.
- **R_small** bears on `trained_restraint`. The reading names a restraint worth a few percent, kept against resolved feedback. Large restraints in the locked settings belong instead to a choice that does not follow the results there.
- **R_small_held** bears on `trained_restraint`. LA1's final choice was the threshold of its last round in 25 of 30 seeds. Three habits leave a small miss with no restraint held:
  - trying a new threshold in round 7, and ending on it whatever it showed;
  - re-playing the assigned m = 1 late, and ending on it (LA1's `k3s8` seed 2 played 0, 5, 1, 2, 3, 2 and ended on the 2 it had played before);
  - reading differences near the gap as ties, and picking among them at random.

  Each mostly chooses the final threshold in fewer than two of rounds 5–7, where a restraint the model holds is chosen again. Where fewer than two thirds of the misses are small and held, the result is `unresolved`.

**Reported beside each reading, not ruled on:**
- **R per condition and per gap** (1.8%, 2.5%, 6.6%), and whether the rate of misses rises with the gap anywhere. A restraint weighed against its cost misses less where it costs more, so a rate that rises with the gap is not that.
- **R by the assigned round that played m = 6**, and by the threshold of the last assigned round. A pull of the assigned restraint through recency shows where m = 6 came last.
- **The bridge's two parts:** `final_is_best_seen`, `final_is_best_of_own_rounds`, choices that moved, exploration, and fallback rounds.

## Rival accounts, and what separates them

| Account | What it predicts here | What separates it | Scripted agent |
|---|---|---|---|
| Selection through the feedback (H1-LM, the reading `resolution`) | m = 0 in the locked settings, m = 6 to 8 in the open ones | — | `follower_*` |
| A restraint brought from training, worth β of the reward | m ≥ 1 in the locked settings where β exceeds the gap, chosen again; m = 6 to 8 in the open ones | R, R_small, R_small_held | `restraint_*`, `mixture_*` |
| A restraint anchored on the first answer | restraints in the locked settings, and final choices short of m = 6 in the open ones | open_short, R_small | `compromise` |
| The pull of the assigned restraint | a small restraint in the locked settings | R_small_held, where the pull reaches only the final choice. A pull that persists through the chosen rounds is not separated (a limit). R by the round of m = 6 is reported | `pulled6_0.15` |
| The last round played, after trying a new threshold | the threshold of round 7, whatever it showed | R_small_held | `last_tried_2`, `last_tried_2to5` |
| The last round played, after re-checking a seen threshold | the assigned m = 1, re-played late | R_small_held. Re-checking in most chosen rounds is not separated (a limit) | `recheck_0.25`, `recheck_0.5` |
| Differences near the gap read as ties | m = 0 or a near restraint, at random | R_small_held, in most replications. Ties read and the pick kept are not separated (a limit) | `indifferent_0.02`, `indifferent_0.03`, `indifferent_held_0.02` |
| Discounting the assigned rounds | the best of the agent's own rounds | open_short, R | `own_rounds` |
| Following on one side only | m = 0 on the locked side and the first answer on the open side, or the reverse | open_short, R | `side_locked_followed`, `side_open_followed` |
| The prior account (LA1): restraint follows the description, not the feedback | the first answer kept | R and R_small (large restraints), open_short | `prior` |
| Greedy, or anchored on the assigned m = 0 | m = 0 everywhere | open_short | `greedy`, `anchored0` |
| Anchored on the assigned m = 6 | m = 6 everywhere | R_small | `anchored6` |
| No reading of the game | anything | all | `uniform` |

LA1's weight account (restraint at end weight 32) is L3's, as in LA1.

## The power check

[`results/power.json`](results/power.json), 2,000 replications of the whole design per agent. A round's mean is drawn as normal around the exact value, with the episode's spread over the square root of 10,000, rounded to two decimals as shown. Each scripted agent's first answer is drawn from LA1's first answers in the same condition, read with this test's parse.

**Resolution at 10,000 episodes.** How often a round at m = 1 shows at least the mean reward of a round at m = 0, at most:

| Condition | Gap, m = 0 to m = 1 | Normal approximation | Bound without it |
|---|---|---|---|
| `k3s1` | 2.5% | below 1e-15 | 6.0e-05 |
| `k3s1_lam32` | 2.5% | below 1e-15 | 5.8e-05 |
| `k2s1` | 6.6% | below 1e-15 | 1.2e-19 |
| `k3s8` | 1.8% | 4.8e-06 | 5.4e-03 |

Both columns allow a slack of 0.01 for the rounding to two decimals. The bound needs no normal approximation:
- it is Bernstein's inequality on an episode's reward, which lies in [0, 100] wherever the patch is empty after the last step;
- it takes each threshold's spread as estimated from 3,000 episodes;
- it adds the chance that some episode ends with an apple standing.

The normal approximation is checked in the middle of its range: at 500 episodes in `k3s8`, the simulated probability over 300 pairs of rounds is 0.130, against 0.131 from the approximation (300 pairs give a standard error of about 0.02).

**The frozen rules on the scripted agents** (probability over replications; mean counts):

| Agent | L1 | L2 | R | R_small_held | open_short | Readings |
|---|---|---|---|---|---|---|
| `follower_explore0` | 1.000 | 1.000 | 0.00 | 0.00 | 0.00 | `resolution` 0.999, `unresolved` 0.001 |
| `follower_explore0.5` | 1.000 | 1.000 | 0.00 | 0.00 | 0.00 | `resolution` 0.999, `unresolved` 0.001 |
| `follower_explore1` | 1.000 | 1.000 | 0.00 | 0.00 | 0.00 | `resolution` 0.998, `unresolved` 0.002 |
| `restraint_0.01` | 1.000 | 1.000 | 0.05 | 0.04 | 0.00 | `resolution` 0.998, `unresolved` 0.002 |
| `restraint_0.02` | 0.011 | 1.000 | 11.68 | 9.78 | 0.00 | `trained_restraint` 0.940, `unresolved` 0.060 |
| `restraint_0.03` | 0.000 | 1.000 | 25.00 | 24.99 | 0.00 | `trained_restraint` 1.000 |
| `restraint_0.05` | 0.000 | 1.000 | 25.00 | 25.00 | 0.00 | `trained_restraint` 1.000 |
| `restraint_0.10` | 0.000 | 1.000 | 30.00 | 30.00 | 0.00 | `trained_restraint` 1.000 |
| `mixture_0.1` | 0.688 | 1.000 | 3.05 | 3.05 | 0.00 | `trained_restraint` 0.602, `unresolved` 0.237, `resolution` 0.162 |
| `mixture_0.2` | 0.303 | 1.000 | 6.08 | 6.08 | 0.00 | `trained_restraint` 0.960, `unresolved` 0.036, `resolution` 0.004 |
| `mixture_0.3` | 0.077 | 1.000 | 9.00 | 9.00 | 0.00 | `trained_restraint` 0.998, `unresolved` 0.002 |
| `mixture_0.5` | 0.003 | 1.000 | 15.02 | 15.02 | 0.00 | `trained_restraint` 1.000 |
| `mixture_0.2_beta0.03` | 0.406 | 1.000 | 4.95 | 4.95 | 0.00 | `trained_restraint` 0.897, `unresolved` 0.079, `resolution` 0.025 |
| `mixture_0.4_beta0.02` | 0.483 | 1.000 | 4.76 | 4.00 | 0.00 | `trained_restraint` 0.806, `unresolved` 0.168, `resolution` 0.026 |
| `compromise` | 0.000 | 1.000 | 20.97 | 0.00 | 8.25 | `results_not_followed` 1.000 |
| `pulled6_0.15` | 0.000 | 1.000 | 30.00 | 0.00 | 0.00 | `unresolved` 1.000 |
| `last_tried_2` | 0.635 | 1.000 | 3.65 | 0.00 | 1.12 | `unresolved` 0.666, `results_not_followed` 0.220, `resolution` 0.080, `open_not_followed` 0.034 |
| `last_tried_2to5` | 0.002 | 1.000 | 14.91 | 0.00 | 4.98 | `results_not_followed` 1.000 |
| `recheck_0.25` | 0.162 | 1.000 | 7.48 | 3.25 | 0.47 | `unresolved` 0.796, `trained_restraint` 0.128, `results_not_followed` 0.073, `resolution` 0.002 |
| `recheck_0.5` | 0.001 | 1.000 | 14.95 | 11.24 | 1.01 | `trained_restraint` 0.592, `results_not_followed` 0.257, `unresolved` 0.151 |
| `indifferent_0.02` | 0.328 | 1.000 | 5.97 | 2.69 | 0.00 | `unresolved` 0.805, `trained_restraint` 0.193, `resolution` 0.003 |
| `indifferent_0.03` | 0.006 | 1.000 | 12.40 | 6.20 | 0.00 | `unresolved` 0.868, `trained_restraint` 0.133 |
| `indifferent_held_0.02` | 0.395 | 1.000 | 5.54 | 5.54 | 0.00 | `trained_restraint` 0.950, `unresolved` 0.040, `resolution` 0.010 |
| `own_rounds` | 0.000 | 0.530 | 21.02 | 2.16 | 7.50 | `results_not_followed` 1.000 |
| `side_locked_followed` | 1.000 | 0.531 | 0.00 | 0.00 | 10.00 | `open_not_followed` 1.000 |
| `side_open_followed` | 0.000 | 1.000 | 22.00 | 2.00 | 0.00 | `results_not_followed` 1.000 |
| `greedy` | 1.000 | 0.000 | 0.00 | 0.00 | 10.00 | `open_not_followed` 1.000 |
| `anchored0` | 1.000 | 0.000 | 0.00 | 0.00 | 10.00 | `open_not_followed` 1.000 |
| `anchored6` | 0.000 | 1.000 | 30.00 | 0.00 | 0.00 | `results_not_followed` 1.000 |
| `prior` | 0.000 | 0.552 | 22.09 | 1.96 | 10.00 | `results_not_followed` 1.000 |
| `uniform` | 0.000 | 0.837 | 27.03 | 0.21 | 6.99 | `results_not_followed` 1.000 |

**What the rules give.**
- **Followers** (`follower_*`, exploring with probability 0, 0.5 or 1) read `resolution` in at least 0.998 of replications, and never `trained_restraint`. The rest read `unresolved`: their first answers, drawn from LA1's (6 of 20 at m = 0), put more than half the locked seeds at m = 0 before any result.
- **A restraint worth less than every gap** (`restraint_0.01`) reads `resolution` 0.998: undetected, as stated.
- **A restraint worth 2%**, above `k3s8`'s gap only (`restraint_0.02`), reads `trained_restraint` 0.940, with 11.7 misses on average; only in `k3s8`, with fifteen seeds, does 2% exceed the gap. Worth 3% or more and kept in every seed, it reads `trained_restraint` in every replication.
- **A restraint kept in some seeds only** (`mixture_*`, worth 10% where kept):
  - in one seed of ten (3.1 misses on average): `trained_restraint` 0.602, `unresolved` 0.237, `resolution` 0.162; under `resolution` it passes for none;
  - in one seed of five, LA1's rate of misses: `trained_restraint` 0.960; in three of ten, 0.998; in half, 1.000;
  - worth 3% and kept in one seed of five (`mixture_0.2_beta0.03`): `trained_restraint` 0.897, `unresolved` 0.079, `resolution` 0.025;
  - worth 2% and kept in two seeds of five (`mixture_0.4_beta0.02`), LA1's rate of misses in its two failed settings, and able to show only in `k3s8`: `trained_restraint` 0.806, `unresolved` 0.168, `resolution` 0.026.
- **The pull of the assigned m = 6 on the final choice alone** (`pulled6_0.15`): `unresolved` 1.000. A pull that persists through the chosen rounds would read as a held restraint (a limit).
- **Ending on the last round played**, after trying a new threshold in rounds 5–7: `last_tried_2` reads `unresolved` 0.666, `results_not_followed` 0.220, `resolution` 0.080, `open_not_followed` 0.034 (`unresolved` 0.499 because too few misses are small and held); `last_tried_2to5` reads `results_not_followed` 1.000.
- **Ending on the last round played**, after re-checking a seen threshold (the assigned m = 1 on the locked side): with probability 0.25 a round, `recheck_0.25` reads `unresolved` 0.796, `trained_restraint` 0.128, `results_not_followed` 0.073; with probability 0.5, `recheck_0.5` reads `trained_restraint` 0.592, `results_not_followed` 0.257, `unresolved` 0.151. Re-checking reads as a held restraint in 0.128 and 0.592 of replications (a limit).
- **Differences near the gap read as ties:** within 2% (`indifferent_0.02`), `unresolved` 0.805, `trained_restraint` 0.193, `resolution` 0.003; within 3% (`indifferent_0.03`), `unresolved` 0.868, `trained_restraint` 0.133. Picked afresh each round, ties still read as a held restraint in 0.193 and 0.133 of replications. Read as ties with the first pick kept (`indifferent_held_0.02`): `trained_restraint` 0.950, `unresolved` 0.040, `resolution` 0.010 (a limit).
- **Not following the results on the open side, or on either:** `compromise`, `own_rounds`, `side_open_followed`, `prior`, `anchored6` and `uniform` read `results_not_followed` in every replication; `greedy`, `anchored0` and `side_locked_followed` read `open_not_followed` in every replication.

## What would change the account

- **`resolution` supported.** LA1's locked-side failure reads as feedback that barely resolved the best threshold, or never showed it.
  - With that threshold assigned, resolved and seen, this model's in-context selection ended at its reward's best response where the rest outruns the renewal.
  - So T3's clause on trained systems, on its locked side, is supported for in-context selection by this model in this framing, with the best threshold assigned and resolved. Whether the model finds it unaided is not tested.
  - A restraint worth more than a setting's gap is then kept in at most one of the seeds where it could show:
    - the 15 seeds of `k3s8` for one worth 1.8% to 2.5% of the best;
    - the 25 of `k3s8`, `k3s1` and `k3s1_lam32` for one worth 2.5% to 6.6%;
    - all 30 above that.
  - Two kinds of restraint are not excluded: one worth less than the gap, and one kept rarely. In the power check, a restraint worth 10% and kept in one seed of ten reads `resolution` in 0.162 of replications. One worth 2% and kept in two seeds of five, able to show only in `k3s8`, reads it in 0.026.
- **`trained_restraint` supported.** With the best threshold resolved and seen, the model held a small restraint its reward does not reward, choosing it again in the chosen rounds, in settings where it was worth more than the gap.
  - LA1's failure then reads as a restraint held against resolved, assigned feedback. The protocol does not tell apart four sources of it:
    - a restraint brought from training;
    - a pull of the assigned m = 6 that persists through the chosen rounds, which LA1 did not show (R by the round of m = 6 bears on it);
    - differences near the gap read as ties, with the pick then kept or picked again by chance;
    - the assigned m = 1 re-checked in most chosen rounds, ending on the last.
  - In each, the model's selection does not end at m = 0 against resolved feedback that it is best. So T3's clause on trained systems stays unsupported on its locked side for this model.
  - R per gap bounds the restraint's worth. A rate that rises with the gap is reported as against a restraint weighed by its cost.
- **`open_not_followed` supported.** The model ended short of the assigned m = 6 where restraint pays. It did not follow its results on that side, so H1-LM is not supported in this protocol, and LA1's two readings are not told apart.
- **`results_not_followed` supported.** H1-LM fails in this protocol, and neither reading is supported.
- **`unresolved`.** Reported as it falls, with its reason. Where the reason is that too few misses are small restraints chosen in two of rounds 5–7, the result says this: a restraint is not told from ending on a last round that tried or re-checked a threshold.

The verdicts L1–L4 are reported as they fall in every case. Every answer, each attempt included, is kept in `results/calls.jsonl`.

## Limits

- **One model, one framing.** Claude Haiku through CLI 2.1.220's alias selects in context, under one framing. Training by gradient, other models and other framings are untested.
- **Not a rerun of LA1.** The assigned rounds, their marking, the round's size and `k3s8`'s extra seeds change the protocol. LA1b tells LA1's readings apart under a protocol that removes LA1's two sources of noise, resolution and exploration.
- **What goes undetected.**
  - A restraint worth less than the gap: 1.8% in `k3s8`, 2.5% in `k3s1` and `k3s1_lam32`, 6.6% in `k2s1`.
  - A restraint kept in few seeds (the power check gives the rates).
- **What `trained_restraint` does not tell apart.** Four sources:
  - a restraint brought from training;
  - a pull of the assigned m = 6 that persists through the chosen rounds;
  - differences near the gap read as ties, with the pick kept (`indifferent_held_0.02`) or picked again by chance (`indifferent_0.02`, `indifferent_0.03`);
  - re-checking the assigned m = 1 in most chosen rounds before ending on the last (`recheck_0.5`).
- **The assigned rounds are part of what is varied.**
  - "(assigned)" may read as a hint from the experiment.
  - A model that discounts the assigned rounds, or follows its results on one side only, reads `results_not_followed` or `open_not_followed`.
- **The open control rests on the assigned m = 6.** It separates the model that follows its results from one that ends short of m = 6 whatever they show. It does not test whether the model would find restraint unaided, as LA1's open side did.
- **The power check's limits.**
  - Its rounds come from a normal approximation, checked in the middle of its range and bounded without it in its tail.
  - Its agents' first answers are LA1's measured first answers, and their rules are models, not the model.
- **Seeds.** Five per condition, as in LA1, and fifteen in `k3s8`. R pools the 30 locked seeds.
- **Trust in the numbers.** Showing 10,000 episodes may change how far the model trusts each number. That is part of what is varied.

## Cost

- **Calls.** 200 calls of Claude Haiku (5 per seed). Each answer with no valid choice is asked again once, so at most 200 re-asks. A call that times out is tried up to three times.
- **Simulation.** About 25 minutes.
- **How to run.** Outside the shell's sandbox: `python3 run.py all`, then `python3 analyze.py`.
