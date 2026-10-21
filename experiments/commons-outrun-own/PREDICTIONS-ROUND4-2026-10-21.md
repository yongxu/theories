# CG3 round 4 (board item CG3c): the band form of the boundary, frozen 21 October 2026

AI-written (the CG3 session). Rounds 1–3 are closed and their verdicts stand. This file, [`round4.py`](round4.py) (the rule, the conditions, the run and the verdict rules) and [`results/round4-exact.json`](results/round4-exact.json) (the exact quantities and every account's prediction, no learning) are committed together on main before any round-4 learning run. Before the commit only a smoke run (30 episodes) and a code-path test of the analysis (50 episodes, 2 seeds, kept nowhere) were run.

## The rule

Round 3's map, read after its runs over all 28 conditions with uniform training starts (study §264), suggested a band form. It uses two exact quantities:
- `full`: the steps a full patch stands under the full draw.
- `cov`: the steps it stands under uniform requests 0..m.

The rule:

| Region | Predicted |
|---|---|
| `full` ≤ 4.4 | depleted |
| `full` ≥ 8.4 | kept |
| 4.4 < `full` < 8.4 and `cov` ≥ 60 | kept |
| 4.4 < `full` < 8.4 and `cov` ≤ 16 | depleted |
| 4.4 < `full` < 8.4, otherwise | between: the share kept lies strictly between 0.05 and 0.80, and rises with `cov` |

The mechanism is the one rounds 2 and 3 found. A learner's values are least trained at the start of a course, and there its greedy act is the full draw. If the full draw ends the patch within about four steps, the course never reaches the steps where restraint is learned. If it lasts beyond about eight steps, the course always does. In between, how long the early behaviour's courses stand decides how far training reaches into the start region. The thresholds are read off rounds 1–3 and are not fitted to anything new.

## Conditions

There are eight new conditions, each with 12 seeds, the reading apples + 6 × the last level, and round 1's training (uniform exploring starts, 30,000 episodes). Five of them use a draw cap no learner here has had, four requests a step.

| Condition | m | s | `cov` | `full` | Band | Round 3's sigmoid | Round 2's rule | Draw cap (m ≥ 3 and `full` < 8.4 → depleted) |
|---|---|---|---|---|---|---|---|---|
| `G4s12` | 4 | 12 | 22.6 | 3.0 | depleted | 0.23 | 0 | depleted |
| `G4s14` | 4 | 14 | 36.9 | 3.5 | depleted | 0.33 | 0 | depleted |
| `G4s16` | 4 | 16 | 59.4 | 4.3 | depleted | 0.48 | 0 | depleted |
| `G4s18` | 4 | 18 | 83.3 | 5.9 | kept | 0.67 | 0.5 | depleted |
| `G4s20` | 4 | 20 | 97.7 | 11.2 | kept | 0.89 | 1 | — |
| `G3s10.5` | 3 | 10.5 | 61.2 | 5.6 | kept | 0.62 | 0.5 | depleted |
| `G2s4.5` | 2 | 4.5 | 24.5 | 5.8 | between | 0.54 | 0.5 | — |
| `G1s0.1` | 1 | 0.1 | 17.5 | 8.1 | between | 0.67 | 0.5 | — |

The sharp cases:
- **`G4s16`:** coverage 59.4 is as high as kept conditions elsewhere, but `full` is 4.3, so the band says depleted.
- **`G4s18`:** `full` is 5.9 but coverage is 83.3, so the band says kept where a draw-cap account says depleted.
- **`G1s0.1`:** one request a step and `full` 8.1, just short of the upper edge, with low coverage, so the band says between where every earlier one-request condition was kept.

## Verdict rules

The measure is as before: the share of 200 greedy evaluation episodes alive at step 80, averaged over seeds. Kept passes at ≥ 0.80, depleted at ≤ 0.20, between strictly within (0.05, 0.80).

- **V1:** at least 6 of the 8 conditions pass.
- **V2:** the band's mean absolute error is below both round 3's sigmoid's and round 2's rule's. For this score the band counts kept as 1, depleted as 0, and between as linear in `cov` from 16 to 60.
- **V3:** all five four-request conditions pass, so the band carries to a draw cap it was not read from.
- **V4:** the two between conditions are ordered by `cov` (`G1s0.1` ≤ `G2s4.5`).
- **Identity checks** as in rounds 1–3.

## What would change the account

- V3 failing at `G4s16` (kept): high coverage reaches the start region even where the full draw ends a course in four steps, so the lower edge is not fixed by `full` alone.
- V3 failing at `G4s18` (depleted): the draw cap matters beyond the two quantities.
- `G1s0.1` kept: coverage does not matter near the upper edge, so the band is narrower than read.
- V2 failing: the band, read post hoc, carries no better than the rules it replaces.

About 25 CPU-minutes.
