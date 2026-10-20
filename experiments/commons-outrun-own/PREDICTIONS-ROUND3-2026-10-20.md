# CG3 round 3 (board item CG3b): the boundary mapped and predicted, design frozen 20 October 2026

AI-written (the CG3 session). Rounds 1 and 2 are closed and their verdicts stand. Neither round's threshold located the boundary between the learner keeping the gated patch and emptying it. It depends jointly on the learner's exploration coverage (`cov`) and on how long a full patch stands under the full draw (`full`), and round 2's other results showed that the start of a course is where the learner's own draw outruns the renewal ([README](README.md)). This round maps the boundary on a fresh grid and tests whether a boundary fitted on half the grid predicts the other half.

It is frozen in two steps, each committed on main before the runs it governs:
1. **This design**, before any round-3 learning run: the grid, the split into halves, the predictor, its fitting procedure and the verdict rules ([`round3.py`](round3.py), grid features in [`results/round3-grid.json`](results/round3-grid.json)).
2. **The predictions for half B**, after half A has run and before half B runs. They come from the fitting procedure below applied mechanically ([`results/round3-predictions.json`](results/round3-predictions.json)).

Before this commit, besides exact computations, only a smoke run (30 episodes) and a code-path test of the fit and analysis (50 episodes, 2 seeds, written to a scratch directory, kept nowhere) were run.

## A failed calibration, recorded

First I tried a mechanistic index with one constant. It counts the expected training visits to each (level, step) under the early behaviour and the training start distribution. A learner is assumed to hold the optimal act where the visits reach `n*`, the full draw where it has some visits, and a uniform act where it has none. The index is the exact probability that such a policy leaves the patch standing at step 80. Fitted on the 14 finished conditions of rounds 1 and 2 (`python3 round3.py fit`, [`results/round3-fit.json`](results/round3-fit.json)), it fits badly: the residual sum of squares is 3.6 at the best `n*`, against 0.65 for a three-feature logistic. It predicts `J3s16` depleted (measured 1.00) and `J2` kept (measured 0.00). Visits alone do not describe these learners, so the index predicts nothing here. This took about 31 CPU-minutes of exact computation.

## The grid and the split

The grid has 16 new conditions with the reading of rounds 1 and 2 (apples + 6 × the last level), round 1's training (uniform exploring starts, 30,000 episodes) and 12 seeds each. Within each draw cap m, sorted by regrowth scale s, the conditions alternate between half A and half B, starting with A.

| Condition | m | s | `cov` | `full` | Half |
|---|---|---|---|---|---|
| `G3s5` | 3 | 5 | 10.6 | 3.1 | A |
| `G3s6` | 3 | 6 | 13.2 | 3.4 | B |
| `G3s7` | 3 | 7 | 17.4 | 3.7 | A |
| `G3s9` | 3 | 9 | 36.8 | 4.6 | B |
| `G3s11` | 3 | 11 | 67.3 | 6.0 | A |
| `G3s12` | 3 | 12 | 78.5 | 7.0 | B |
| `G3s13` | 3 | 13 | 87.2 | 8.4 | A |
| `G2s2` | 2 | 2 | 11.6 | 4.4 | A |
| `G2s3` | 2 | 3 | 14.7 | 4.9 | B |
| `G2s5` | 2 | 5 | 30.6 | 6.2 | A |
| `G2s6` | 2 | 6 | 49.0 | 7.3 | B |
| `G2s7` | 2 | 7 | 71.3 | 9.1 | A |
| `G2s9` | 2 | 9 | 96.4 | 18.7 | B |
| `G2s10` | 2 | 10 | 99.3 | 36.9 | A |
| `G1s0.5` | 1 | 0.5 | 19.7 | 8.6 | A |
| `G1s0.75` | 1 | 0.75 | 21.5 | 9.0 | B |

## The predictor and its fit

The predictor is p = σ(b0 + b1 · log `cov` + b2 · log `full`): three coefficients, fitted by least squares of p against the measured share alive at step 80 (`logistic_fit`, a small ridge term). It is fitted on every finished condition with round 1's start distribution and zero initial values: rounds 1 and 2 (12 conditions, 20 seeds) and half A (9 conditions, 12 seeds). Nothing else is chosen after half A runs.

## Verdict rules for half B

- **Per condition** (measure as before: the share of 200 greedy evaluation episodes alive at step 80, averaged over seeds):
  - p ≥ 0.80: predicted kept, passes at ≥ 0.80.
  - p ≤ 0.20: predicted depleted, passes at ≤ 0.20.
  - Otherwise: predicted between, passes if the measured share lies within 0.25 of p.
- **W1:** at least 5 of the 7 conditions in half B pass.
- **W2:** the fitted boundary's mean absolute error on half B is below both earlier frozen rules', each scored as kept = 1, depleted = 0, between = 0.5. Round 1's rule is coverage alone; round 2's is coverage plus the full draw.
- **Identity checks** as in rounds 1 and 2: CG1's checks with the learner's own takes as the joint-excess part, and `Regulation.accumulates_at` on emptied courses. Zero violations pass.

## What would change the account

- W1 failing: the boundary in (`cov`, `full`) does not carry from one half of the grid to the other. Something the two quantities do not hold, such as the draw cap itself or the seed-to-seed spread near the boundary, decides.
- W2 failing: fitting the joint boundary adds nothing over the thresholds already frozen.

## Limits stated in advance

- Twelve seeds per condition (rounds 1 and 2 used 20), so a condition's mean has a standard error up to about 0.1 near the boundary.
- The predictor is statistical, with no mechanism in its form. If it passes, it summarizes where the boundary lies; it does not explain it.
- About 29 CPU-minutes of runs.
