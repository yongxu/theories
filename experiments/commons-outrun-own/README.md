# Whether a stepwise learner's own later acts outrun what it reads (CG3, CG3b, CG3c)

Board items CG3, CG3b and CG3c, 20–21 October 2026. AI-written (a Claude Code session started from CG2's line). It tests the post hoc reading of CG2's failed contrast X5 ([`../commons-outrun`](../commons-outrun/README.md), study §250). There, one tabular learner chose 0–3 requests a step on a gated 3×3 patch, rewarded with all the apples plus 6 × the level after the last step. It emptied the patch in every seed, though the exact optimum keeps it. The reading was that the outrunning rest is the learner's own later acts: the end reading's value reaches a state only where its own later policy does not end the condition first (`Flow.outrun_reading_alike` read across time).

## The account

1. **One's own later acts are not a rest.** Settled exactly before any run: one sweep of policy improvement from the full draw keeps the patch in every condition, even with no end reading. An apple withheld now is still taken later and meanwhile lets the empty cells around it regrow, and one's own later acts are improved together with the present act. `Flow.outrun_reading_alike` explains a selection blind to an act where the rest is held fixed (CG2). It does not explain a selector's blindness to its own later acts. The learners agree: neither removing the end reading nor multiplying its weight by eight changed any outcome.
2. **Where one's own acts do outrun the renewal: the start of a course, in sampled learning.** Uniform exploring starts train the first steps of a course least, and there the learner's greedy act is still the full draw, whose apples it learned first. Where that draw ends the patch before the course reaches the steps where restraint is learned, the patch is lost. This is `Flow.joint_excess_ends` with the learner's own untrained takes as the part (0 violations in 7.8 million windows over four rounds). The prediction that followed from it held: training the start rescued the learner whose mid-course restraint was learned (0.84) and not the one whose was not (0.00). Optimistic initial values, the known remedy, kept the patch.
3. **The boundary's quantitative form is the learner's, not the condition's.** Four frozen rounds proposed a form for where the boundary lies in two exact quantities of the condition: `cov`, how long the early behaviour's courses stand, and `full`, how long the full draw's do. A one-constant index of training visits was also tried. Each form was read from the rounds before it, and each failed on the sharpest new case it was frozen against: coverage alone (round 1), a threshold on the full draw (round 2), a fitted sigmoid (round 3, no better than round 2's rule) and a band in the full draw (round 4, where high coverage kept the patch below the band). The best of them, round 4's band, beat both earlier predictors on new conditions (V2), so the forms improved, but none located the boundary. Over all 36 conditions with uniform starts the ordering is clear (see [the map](#the-boundary-over-36-conditions-read-after-the-runs)), but a law for it would be a law of the learner's sample complexity, which is learning theory. The theory's part is items 1 and 2.

The mechanisms are known ([literature check](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#own-later-acts-check): policy improvement, dithering exploration, non-ergodic exploration, zero-initialised Q-learning, exploring starts). What these tests add is the boundary they set on CG2's law, and frozen evidence for where the learner's own outrun sits.

Count over four rounds: 30 graded conditions, 22 passed and 8 failed; 14 contrasts, 9 passed and 5 failed. Round 3's 9 half-A conditions carried no predictions. Identity checks passed in every round.

| File | What it is |
|---|---|
| [PREDICTIONS-2026-10-20.md](PREDICTIONS-2026-10-20.md) | Round 1: the exact result, the account (own exploratory coverage), nine conditions, contrasts Y1–Y5. Frozen at `f6a88683d` |
| [PREDICTIONS-ROUND2-2026-10-20.md](PREDICTIONS-ROUND2-2026-10-20.md) | Round 2: the two-quantity account, six conditions, contrasts Z1–Z3. Frozen at `87b6a0b36` |
| [PREDICTIONS-ROUND3-2026-10-20.md](PREDICTIONS-ROUND3-2026-10-20.md) | Round 3 (CG3b): the failed visit index; 16 conditions in two halves, the fitted boundary, W1–W2. Design frozen at `997e800b9`, predictions for half B at `2576b3e0d` |
| [PREDICTIONS-ROUND4-2026-10-21.md](PREDICTIONS-ROUND4-2026-10-21.md) | Round 4 (CG3c): the band rule, eight conditions (five at a draw cap of four), V1–V4. Frozen at `7de8bf5e3` |
| [exact.py](exact.py) | Exact dynamic programmes over the 512 configurations: optimum, full draw, policy iteration from the full draw, the standing curves (output [results/exact.json](results/exact.json)) |
| [conditions.py](conditions.py), [own.py](own.py), [run.py](run.py), [analyze.py](analyze.py) | Round 1: conditions, the learner (CG2's `learners.Q`, CG1's environment and checks, imported unchanged), the run, the verdict rules |
| [round2.py](round2.py), [round3.py](round3.py), [round4.py](round4.py) | Rounds 2–4: conditions, training, exact quantities, runs and verdict rules |
| [results/](results/) | Each round's runs, verdicts and `FROZEN-AT` files |

To reproduce (Python 3.11, standard library, CPU):
- round 1: `python3 exact.py && python3 run.py all && python3 analyze.py`;
- round 2: `python3 round2.py exact && python3 round2.py all && python3 round2.py analyze`;
- round 3: `python3 round3.py fit && python3 round3.py grid && python3 round3.py runA && python3 round3.py predict && python3 round3.py runB && python3 round3.py analyze`;
- round 4: `python3 round4.py exact && python3 round4.py all && python3 round4.py analyze`.

The runs took 26.0, 19.6, 46.0 and 89.1 worker-minutes (the sum of the runs' wall times). Round 4's figure is inflated by a machine at load 80 on 12 cores, and its wall time was 15 minutes. The exact computations took about 35 CPU-minutes.

## The exact result (before any run)

[`exact.py`](exact.py) runs policy iteration from the full draw, the policy a learner holds once its immediate apples are learned. Each sweep evaluates the current policy exactly and takes the greedy policy against it, so the value of restraint is read through the selector's own later acts as they stand. **After one sweep the policy keeps the patch standing at step 80 with probability 1.00 in all nine round-1 conditions**, including `J3w0` and `J1w0`, which have no end reading (optimum gain over the full draw 20.7 and 18.9). Against a later full draw, an apple withheld now is still taken later, and while it stands it lets the empty cells around it regrow. So restraint beats the full draw at every step but the last few, through the apples alone (`Regulation.accumulates_at`: an emptied course takes its start plus everything given). A single selector's later acts are improved in the same sweep (the policy improvement theorem), so across time there is no lock like CG2's equilibrium across members, and no delay of the exact improvement. `Flow.outrun_reading_alike` needs the rest held fixed, and one's own later acts are not.

## Round 1 verdicts

Measure (CG2's): the share of 200 greedy evaluation episodes from a full patch in which the patch stands at step H − 20, averaged over 20 seeds. Kept passes at ≥ 0.80, depleted at ≤ 0.20. `cov`: the exact steps (of 100) a full patch stands under uniform requests 0..m. `full`: the same under the full draw. Return: the mean of apples + w × the last level.

| Condition | m | s | w | `cov` | `full` | Predicted | Alive at H − 20 | Seeds ≥ 0.8 / ≤ 0.2 | Alive at H | Return (optimum) | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `J3` (CG2's joint learner, new seeds) | 3 | 1 | 6 | 6.0 | 2.3 | depleted | 0.00 | 0 / 20 | 0.00 | 9.4 (70.6) | **passed** |
| `J2` | 2 | 1 | 6 | 9.7 | 4.1 | J3 ≤ J2 ≤ J1 | 0.00 | 0 / 20 | 0.00 | 9.7 (70.6) | **passed** (by a tie with J3) |
| `J1` | 1 | 1 | 6 | 23.7 | 9.4 | kept | 1.00 | 20 / 0 | 1.00 | 26.7 (70.4) | **passed** |
| `J1w0` | 1 | 1 | 0 | 23.7 | 9.4 | kept | 1.00 | 20 / 0 | 0.01 | 16.1 (29.3) | **passed** |
| `J3w0` | 3 | 1 | 0 | 6.0 | 2.3 | depleted | 0.00 | 0 / 20 | 0.00 | 9.5 (30.1) | **passed** |
| `J3w48` | 3 | 1 | 48 | 6.0 | 2.3 | depleted | 0.00 | 0 / 20 | 0.00 | 9.5 (443.9) | **passed** |
| `J3s8` | 3 | 8 | 6 | 24.5 | 4.1 | kept | 0.01 | 0 / 20 | 0.01 | 18.4 (220.3) | **failed** |
| `J3s16` | 3 | 16 | 6 | 98.7 | 22.6 | kept | 1.00 | 20 / 0 | 1.00 | 257.1 (337.8) | **passed** |
| `J3opt` (initial values 100) | 3 | 1 | 6 | 6.0 | 2.3 | kept | 1.00 | 20 / 0 | 1.00 | 47.8 (70.6) | **passed** |

| Contrast | Verdict |
|---|---|
| Y1 the own draw's coverage, not the draw cap (`J3` depleted, `J3s8` and `J3s16` kept) | **failed** (`J3s8` 0.01) |
| Y2 not the end weight (`J3`, `J3w48` depleted) | **passed** |
| Y3 not the end reading (`J3w0` depleted, `J1w0` kept) | **passed** |
| Y4 order in the draw cap (`J1` kept, `J2` between, `J3` depleted) | **passed** (`J2` by a tie) |
| Y5 the known remedy opens it (`J3opt` kept) | **passed** |

Identity checks, both **passed**:
- I1: CG1's balance, gate, margin and joint-excess checks, with the selector's own takes as the part of `Flow.joint_excess_ends`, over 276.3 million steps and 3.25 million own-excess windows: 0 violations.
- I2: `Regulation.accumulates_at` on 23,911 emptied courses: 0 violations.

## Round 2 verdicts

Account (frozen at `87b6a0b36` with round 1's results): `cov` decides whether restraint is learned in mid-course, and `full` decides whether a course from the start, where the greedy act is the full draw, reaches it. Early starts: half the training episodes start in the first 10 steps.

| Condition | m | s | Training | `cov` | `full` | Predicted | Alive at H − 20 | Seeds ≥ 0.8 / ≤ 0.2 | Alive at H | Return (optimum) | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `R3s10` | 3 | 10 | round 1's | 54.9 | 5.3 | depleted | 0.80 | 11 / 0 | 0.80 | 176.7 (262.8) | **failed** |
| `R2s4` | 2 | 4 | round 1's | 20.2 | 5.4 | depleted | 0.28 | 1 / 10 | 0.28 | 28.0 (134.4) | **failed** |
| `R3s14` | 3 | 14 | round 1's | 93.1 | 10.6 | kept | 1.00 | 20 / 0 | 1.00 | 242.6 (317.9) | **passed** |
| `R2s8` | 2 | 8 | round 1's | 88.2 | 12.1 | kept | 0.97 | 20 / 0 | 0.97 | 177.2 (213.9) | **passed** |
| `R3s8early` | 3 | 8 | early starts | 24.5 | 4.1 | kept | 0.84 | 17 / 2 | 0.06 | 138.9 (220.3) | **passed** |
| `R3early` | 3 | 1 | early starts | 6.0 | 2.3 | depleted | 0.00 | 0 / 20 | 0.00 | 11.2 (70.6) | **passed** |

| Contrast | Verdict |
|---|---|
| Z1 coverage is not enough (`R3s10`, `R2s4` depleted) | **failed** (0.80, 0.28) |
| Z2 a full draw that lasts reaches the learned region (`R3s14`, `R2s8` kept) | **passed** |
| Z3 training the start rescues only where mid-course restraint is learned (`R3s8early` kept, `R3early` depleted) | **passed** |

Identity checks, both **passed**: I1 over 211.2 million steps and 1.25 million own-excess windows, and I2 on 11,543 emptied courses, with 0 violations.

Behind Z3 (round 1's greedy tables, read before this round was frozen):
- In `J3s8` the learner had learned restraint in mid-course: at level 6 its greedy request falls from 2.6 at the start to 0.6 with 50 steps left.
- From a full patch, its full draw at the start ends the patch within about four steps, before the course gets there.

`R3s8early` then emptied the patch near the end (alive at H 0.06), because the late steps were now the less trained: the same mechanism, displaced.

## Round 3 verdicts (CG3b)

[Design](PREDICTIONS-ROUND3-2026-10-20.md) frozen at `997e800b9` before any round-3 run.

**A failed calibration first.** A mechanistic index with one constant: the expected training visits to each (level, step), with the optimal act where visits reach `n*`, the full draw where there are some, and a uniform act where there are none. Fitted on the 14 finished conditions of rounds 1 and 2, its residual sum of squares was 3.6, against 0.65 for a three-feature logistic, and it called `J3s16` depleted and `J2` kept. It predicts nothing.

**The grid.** 16 new conditions (12 seeds each), split alternately within each draw cap into half A (fit) and half B (predict).

Half A measured: `G3s5`, `G3s7`, `G2s2` 0.00; `G2s5` 0.44; `G2s7` 0.80; `G3s11` 0.94; `G3s13`, `G2s10`, `G1s0.5` 1.00.

The frozen procedure then fitted p = σ(−4.797 + 0.431 · log `cov` + 2.036 · log `full`) on the 21 conditions of rounds 1–2 and half A (residual sum of squares 0.91). Its predictions for half B were committed (`2576b3e0d`) before half B ran.

| Condition | m | s | `cov` | `full` | p (class) | Measured | Seeds (min–max) | Verdict |
|---|---|---|---|---|---|---|---|---|
| `G3s6` | 3 | 6 | 13.2 | 3.4 | 0.23 (between) | 0.00 | 0.00–0.00 | **passed** |
| `G3s9` | 3 | 9 | 36.8 | 4.6 | 0.47 (between) | 0.25 | 0.06–0.45 | **passed** |
| `G3s12` | 3 | 12 | 78.5 | 7.0 | 0.74 (between) | 0.99 | 0.96–1.00 | **passed** |
| `G2s3` | 2 | 3 | 14.7 | 4.9 | 0.40 (between) | 0.07 | 0.00–0.35 | **failed** |
| `G2s6` | 2 | 6 | 49.0 | 7.3 | 0.72 (between) | 0.56 | 0.29–0.85 | **passed** |
| `G2s9` | 2 | 9 | 96.4 | 18.7 | 0.96 (kept) | 1.00 | 0.97–1.00 | **passed** |
| `G1s0.75` | 1 | 0.75 | 21.5 | 9.0 | 0.73 (between) | 1.00 | 1.00–1.00 | **failed** |

| Contrast | Verdict |
|---|---|
| W1 at least 5 of 7 pass | **passed** (5) |
| W2 the fitted boundary's mean absolute error on half B below both earlier rules' | **failed**: 0.214, against 0.306 for round 1's rule and 0.195 for round 2's |

Identity checks **passed**: CG1's checks with the learner's own takes as the part over 294.7 million steps and 2.36 million own-excess windows, and `Regulation.accumulates_at` on 16,722 emptied courses, with 0 violations.

The fit had converged (more iterations change the coefficients by 0.01). Its two failures both sit where a measured share is near 0 or 1 and the smooth boundary predicts about 0.4–0.7.

## Round 4 verdicts (CG3c)

The band rule, read from the 28 conditions of rounds 1–3 with uniform starts and frozen at `7de8bf5e3` before any round-4 run:

| Region | Predicted |
|---|---|
| `full` ≤ 4.4 | depleted |
| `full` ≥ 8.4 | kept |
| 4.4 < `full` < 8.4 and `cov` ≥ 60 | kept |
| 4.4 < `full` < 8.4 and `cov` ≤ 16 | depleted |
| 4.4 < `full` < 8.4, otherwise | between, rising with `cov` |

Twelve seeds per condition.

| Condition | m | s | `cov` | `full` | Band | Measured | Seeds (min–max) | Verdict |
|---|---|---|---|---|---|---|---|---|
| `G4s12` | 4 | 12 | 22.6 | 3.0 | depleted | 0.04 | 0.00–0.10 | **passed** |
| `G4s14` | 4 | 14 | 36.9 | 3.5 | depleted | 0.49 | 0.20–0.85 | **failed** |
| `G4s16` | 4 | 16 | 59.4 | 4.3 | depleted | 0.96 | 0.85–1.00 | **failed** |
| `G4s18` | 4 | 18 | 83.3 | 5.9 | kept | 1.00 | 1.00–1.00 | **passed** |
| `G4s20` | 4 | 20 | 97.7 | 11.2 | kept | 1.00 | 1.00–1.00 | **passed** |
| `G3s10.5` | 3 | 10.5 | 61.2 | 5.6 | kept | 0.81 | 0.51–0.94 | **passed** |
| `G2s4.5` | 2 | 4.5 | 24.5 | 5.8 | between | 0.28 | 0.01–1.00 | **passed** |
| `G1s0.1` | 1 | 0.1 | 17.5 | 8.1 | between | 0.00 | 0.00–0.00 | **failed** |

| Contrast | Verdict |
|---|---|
| V1 at least 6 of 8 pass | **failed** (5) |
| V2 the band's mean absolute error below round 3's sigmoid's and round 2's rule's | **passed**: 0.226, against 0.298 and 0.378 |
| V3 every four-request condition follows the band | **failed** (`G4s14`, `G4s16`) |
| V4 the between conditions rise with `cov` | **passed** (0.00 at 17.5, 0.28 at 24.5) |

Identity checks **passed**: CG1's checks with the learner's own takes as the part over 147.3 million steps and 0.97 million own-excess windows, and `Regulation.accumulates_at` on 8,183 emptied courses, with 0 violations.

At four requests, coverage kept the patch even where the full draw ends a course from a full patch in under four steps (`G4s16`: coverage 59.4, kept 0.96). The band's lower edge is not fixed by `full` alone. Near the upper edge, low coverage lost the patch (`G1s0.1`: coverage 17.5, `full` 8.1, 0.00 in every seed), so that edge is not fixed by `full` alone either.

## The boundary over 36 conditions, read after the runs

Not counted. Sorted by coverage, every condition at `cov` ≤ 17.5 was depleted (≤ 0.07; 10 conditions) and every condition at `cov` ≥ 54.9 was kept (≥ 0.80; 14 conditions). Between them (19.7 ≤ `cov` ≤ 49.0, 12 conditions), those whose full draw stands at least 8.6 steps were kept (1.00; three one-request conditions), and the rest lay between 0.01 and 0.56.

In the mechanism's terms:
- Coverage sets how far the early behaviour's own courses carry training back into the start region. It is the primary axis.
- The full draw's standing time matters only where coverage leaves the start region partly untrained.

Round 4's band had the roles the other way round. This reading too came after the runs and was not frozen. The forms so far have each come from the round before and failed on the next round's sharpest case, so I end the series here (item 3 of the account).

## What is new against prior work, and what is not

Known: that the greedy policy against an evaluation improves on it and that one's own later acts are revised with it (policy improvement, Sutton and Barto §4.2–4.6); that dithering exploration needs time exponential in the length of the consistent course to a delayed value (Osband et al. 2019); that exploration fails in systems its own acts can end (Moldovan and Abbeel 2012); that zero-initialised Q-learning is intractable where optimistic initialisation is not (Koenig and Simmons 1996); and that exploring starts govern which states a learner evaluates (Sutton and Barto §5.3). The CG3 findings are none of them new as learning theory.

New here, as frozen tests with their outcomes:
- the exact refutation of the across-time reading of CG2's law (one sweep keeps the patch);
- the measured irrelevance of the end reading for this learner (Y2, Y3);
- the location of the outrun at the start of the course, predicted before the run that tested it (Z3);
- the failure of each round's threshold (Y1, Z1);
- the boundary mapped over 36 conditions, and four frozen forms for it, each read from the rounds before and each failing on its sharpest new case. The last of them (round 4's band) predicted new conditions better than the earlier two (V2).

Their value for the theory is a boundary on what `Flow.outrun_reading_alike` explains. It explains a selection blind to an act where the rest is held fixed (CG2), and not a selector's blindness to its own later acts. The latter is the sampling of its own courses: what it has evaluated, set by its training and by how long its own acts let the condition stand.

## Corrections after the freezes

None. Round 1 ran from `f6a88683d` and round 2 from `87b6a0b36` (`results/FROZEN-AT`, `results/round2-FROZEN-AT`). Round 3's half A ran from `997e800b9` and half B from `2576b3e0d` (`results/round3-FROZEN-AT`, `results/round3B-FROZEN-AT`). Round 4 ran from `7de8bf5e3` (`results/round4-FROZEN-AT`). No code, condition or rule changed after any of them. Rounds 2, 3 and 4 were each designed after the verdicts of the rounds before and frozen before any of their own runs. Their anchors and thresholds are earlier rounds' outcomes, as their files state.

## Limits

- The environment is CG1's (one isolated 3×3 patch, no walking or tagging), the regrowth scale is a manipulation, and the learner and training are CG2's (tabular Q, uniform exploring starts, 30,000 episodes), with 20 seeds per condition.
- The exact computations are over policies reading the whole configuration; the learner reads the level and the steps left.
- The diagnosis of the start region rests on greedy tables averaged over seeds and on one manipulation (`R3s8early`, `R3early`). A law for the boundary as a joint function of coverage and the full draw was not derived.
- Rounds 3 and 4 used 12 seeds per condition, and only uniform starts.
- Near the boundary, seeds of one condition range widely (`G2s4.5`: 0.01–1.00).
- Total compute: 181 worker-minutes of runs (round 4 under heavy load) and about 35 CPU-minutes of exact computation.
