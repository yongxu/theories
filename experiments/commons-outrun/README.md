# What decides the outcome learners reach on a gated renewal: the rest outruns the renewal (CG2)

Board item CG2, 20 October 2026. AI-written (a Claude Code session, line B of four toward the 20 October aim). It takes up CG1's substantive failure ([`../commons-gated-renewal`](../commons-gated-renewal/README.md), D2b: three learners each coupled into the stock's end level emptied it in every episode).

The [significance review's check](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#restraint-equilibrium-check) found the requested theorem (when restraint is a mutual best response) known in form: pivotality at a threshold, coordination at a known threshold, the folk theorem, risk-dominant selection. What the theory's ingredients add is a condition on the *rest*: where the other members alone take more than the gated renewal gives, the condition ends whatever a member takes, and every reading of it after the end is alike under the member's acts (`Flow.outrun_below`, `Flow.outrun_reading_alike`, added to `Becoming.Exclusion`). This experiment classes eleven settings as *locked* (against a rest that harvests at every step, harvesting at every step comes within 0.25 of a best response's expected return from the full patch: the computed gain is 0 in four of the six locked settings, 0.001 in `k3s8` and 0.084 in `k3s1_share`) or *open* (a best response, for `k3s1_joint` the one selector's optimum, beats it by at least 1.0) by an exact best-response computation, predicts the outcome learners reach from the class, and freezes the predictions before any learning run.

| File | What it is |
|---|---|
| [PREDICTIONS-2026-10-20.md](PREDICTIONS-2026-10-20.md) | The law, the condition, the calibration table, bridges H1 and H3, eleven conditions, contrasts X1-X5 with the alternative accounts each rules out, identity checks I1-I3, pass/fail rules. Frozen at `8a049b4fb`, before any learning run |
| [conditions.py](conditions.py), [calibrate.py](calibrate.py) | The conditions with their classes; the exact dynamic programme over the patch's 512 configurations (output [results/calibration.json](results/calibration.json), the only computation before the freeze besides smoke runs) |
| [learners.py](learners.py), [run.py](run.py), [analyze.py](analyze.py) | Learners and identity checks (CG1's environment and checks, unchanged); the frozen configuration; the verdict rules |
| [results/](results/) | `runs.json` (220 runs), `VERDICTS.json`, `run.log`, `FROZEN-AT` |
| [posthoc_joint.py](posthoc_joint.py) | Post hoc, after the verdicts: why the joint learner failed (output [results/posthoc-joint.txt](results/posthoc-joint.txt)) |

To reproduce (Python 3.11, standard library only, CPU; about 13 minutes on 8 workers, 63 CPU-minutes):

```bash
python3 calibrate.py && python3 run.py all && python3 analyze.py
```

## Verdicts

Measure: the share of 200 greedy evaluation episodes in which the patch still stands at step H − 20, averaged over 20 seeds. Kept passes at ≥ 0.80, depleted at ≤ 0.20.

| Condition | k | s | Reading | Rest at full draw | gain | Class | Predicted | Alive at H − 20 | Seeds ≥ 0.8 / ≤ 0.2 | Alive at H | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `k3s1` (CG1's D2b) | 3 | 1 | 2 × last level | empties | 0.000 | locked | depleted | 0.00 | 0 / 20 | 0.00 | **passed** |
| `k3s1_lam32` | 3 | 1 | 32 × last level | empties | 0.000 | locked | depleted | 0.00 | 0 / 20 | 0.00 | **passed** |
| `k2s1` | 2 | 1 | 2 × last level | empties | 0.000 | locked | depleted | 0.00 | 0 / 20 | 0.00 | **passed** |
| `k3s8` | 3 | 8 | 2 × last level | empties | 0.001 | locked | depleted | 0.00 | 0 / 20 | 0.00 | **passed** |
| `k2s8` | 2 | 8 | 2 × last level | does not empty | 53.4 | open | kept | 0.95 | 20 / 0 | 0.95 | **passed** |
| `k3s16` | 3 | 16 | 2 × last level | does not empty | 73.3 | open | kept | 1.00 | 20 / 0 | 1.00 | **passed** |
| `k3s1_vlo` | 3 | 1 | 0.107 × level each step | empties | 0.000 | locked | depleted | 0.00 | 0 / 20 | 0.00 | **passed** |
| `k3s1_vhi` | 3 | 1 | 0.64 × level each step | empties | 2.44 | open | kept | 0.97 | 19 / 0 | 0.91 | **passed** |
| `k3s1_share` | 3 | 1 | step's apples / 3 | empties | 0.084 | locked | depleted | 0.00 | 0 / 20 | 0.00 | **passed** |
| `k3s8_share` | 3 | 8 | step's apples / 3 | empties | 3.85 | open | kept | 0.48 | 1 / 2 | 0.23 | **failed** |
| `k3s1_joint` | one learner, 0-3 requests | 1 | all apples + 6 × last level | no rest | 61.2 | open | kept | 0.00 | 0 / 20 | 0.00 | **failed** |

| Contrast | Conditions | Verdict |
|---|---|---|
| X1 the boundary is the rest, not the whole | `k2s1` depleted, `k2s8` kept, `k3s8` depleted, `k3s16` kept | **passed** |
| X2 no weight of an end reading opens the lock | `k3s1`, `k3s1_lam32` depleted | **passed** |
| X3 a reading before the rest's end opens the lock only above v* | `k3s1_vlo` depleted, `k3s1_vhi` kept | **passed** |
| X4 sharing opens the lock only where renewal lets something through | `k3s1_share` depleted, `k3s8_share` kept | **failed** (open side: 0.48) |
| X5 one selector reading the union | `k3s1_joint` kept | **failed** (0.00) |

Identity checks, all **passed**: I1 `Flow.outrun_below` (22,263 windows over every member of every evaluation episode, 0 violations); I2 an emptied course takes its start plus everything given (31,639 episodes, 0 violations); I3 CG1's balance, gate, margin and joint-excess checks (337.7 million steps, 2.89 million joint-excess windows, 0 violations).

Count: of eleven conditions, nine passed and two failed; of five contrasts, three passed and two failed.

## What the results say

**The boundary is the rest's draw, and learners follow it.** In `k2s8` and `k3s16` the whole group harvesting at every step empties the patch (in 13 and 24 steps), but the rest of one member does not; learners kept the patch in 95% and 100% of episodes, every seed at or above 0.8. In `k3s8`, at the same regrowth as `k2s8` with one member more, the rest empties it, and learners emptied it in all but one of 4,000 evaluation episodes. A whole-capacity account (kept where all k at full draw cannot empty it) predicts `k2s8` and `k3s16` depleted, and failed. This was the prediction most exposed to failure: it needed learners to leave depletion where harvesting at every step is far from a best response against such a rest (gains 53 and 73) and to stay in it where it comes within 0.001 of one (`k3s8`), and the class was computed exactly before any run.

**No weight of the end reading opens the lock; a reading before the rest's end does, above v\*.** With the end level weighted 32 rather than 2, the three learners still emptied the patch in every episode (X2): where the rest outruns the renewal, the member's restraint changes nothing the end reading sees, so the weight multiplies nothing. With the level read after every step, learners kept the patch at 0.64 (three times the exact threshold v* = 0.2134) and emptied it at 0.107 (half of it), at the same regrowth and group size (X3). The difference is where the reading falls relative to the rest's end, not how much it weighs. This is CG1's D2b explained by the gap law read on the rest: its coupled learners read the stock only after the last step, which every rest of two had already emptied.

**Sharing, failed on its open side.** Full sharing (each member rewarded a third of the step's apples) left the lock at regrowth ×1, as predicted, against a sharing-level account that predicts cooperation preferred at s = 1/n (X4's locked side held). At ×8, where the exact gain is 3.85, learners split: 1 seed kept the patch in at least 80% of episodes, 2 in at most 20%, the rest between, 0.48 on average. The frozen rule says failed. The gain is real; whether shared rewards, which add the other members' exploration to each learner's reward, let tabular learners find it in 30,000 episodes is the bridge, and it held only half way.

**The joint learner failed, and the failure is instructive.** One learner choosing how many of three requests to make, rewarded all apples plus six times the end level, has no rest outside its reading, and the exact optimum keeps the patch (gain 61). It emptied the patch in every episode of every seed. Post hoc ([posthoc_joint.py](posthoc_joint.py), run after the verdicts): the same code with CG1's single coupled learner keeps the patch in 3 of 3 seeds, so the shared code is not at fault; the joint learner's values are unconverged far from the end (at level 8 with 3 steps left it values waiting at 5, where the exact value is near 48), and its greedy action is three requests at most levels and steps. A temporal-difference learner selects each step's action through the values of the steps after it. Where the learner's own later actions empty the patch before the end reading (three apples a step outrun any renewal here within three steps), its restraint now changes nothing the end reading sees: the outrunning rest is its own later policy. A single coupled learner taking at most one apple a step empties the patch slowly enough for the end value to reach back. This reading is post hoc and not counted; it suggests that reading the union of the couplings is not sufficient for a learner that selects step by step, and that the reading has to fall before what *any* other part of the course, other members or one's own later acts, can do to the condition.

*Correction (20 October 2026, CG3).* The post hoc reading above is false in its exact form. Exact policy iteration from the full draw keeps the patch after one sweep in every condition, with or without an end reading: an apple withheld against a later full draw is still taken later and lets regrowth through meanwhile, and one's own later acts improve with the present act rather than staying fixed, so they are not a rest in the sense of `Flow.outrun_reading_alike`. The failure is the known exploration problem. Frozen tests locate it: the learner's own untrained full draw outruns the renewal at the start of a course, where uniform exploring starts train it least, before the course reaches the steps where restraint is learned ([CG3](../commons-outrun-own/README.md), study §254). The observation stands (reading the union did not suffice for this learner), but the reason is the sampling of its own courses, not the gap law across time.

## What is new against prior work, and what is not

Known: that commons collapse under independent learners (Perolat et al. 2017); that a known threshold makes restraint and depletion both equilibria and coupling or exchange can help (Barrett 2013; Hughes et al. 2018; Willis et al. 2025); that horizon and patience matter (Dutta 1995; Mitra and Sorger 2014); that learners select risk-dominant equilibria (Kandori, Mailath and Rob 1993). New here, as frozen quantitative forms and their outcomes: the class of each setting computed exactly from the rest's draw against the renewal, and the outcome learners reach following it (X1: held, against the whole-capacity account); the end reading's weight being irrelevant where the rest outruns (X2: held); the per-step threshold (X3: held); sharing that leaves the lock where renewal is weak (X4's locked side: held) and fails to open it fully where it is strong (failed); and the joint learner's failure (X5), which locates the same blindness inside one learner's temporal credit assignment. The identity checks test the identification, not the dynamics (SA1's verdict that the laws are near-definitional stands).

## Corrections after the freeze

None. The runs were made from `8a049b4fb` (`results/FROZEN-AT`); no code, condition or rule changed. The post hoc diagnostic is a separate script run after `VERDICTS.json` was written.

*Wording (3 November 2026, board item AF1).* The opening and the limits said that locked means harvesting at every step is a best response against a rest that does so; they now give the tolerance the frozen rule uses (`gain < 0.25`), since the gain is 0.001 in `k3s8` and 0.084 in `k3s1_share`. The results said that learners emptied `k3s8` in every episode, where one evaluation episode of 4,000 still stood, and that depletion is an equilibrium there, where harvesting at every step comes within 0.001 of a best response. Nothing frozen changed.

## Limits

CG1's environment (no walking or tagging; one isolated 3×3 patch); the regrowth scale is a manipulation. Tabular Q-learners with CG1's round-2 training; 20 seeds per condition. The classes come from best responses over policies reading the whole configuration, which learners (reading the level and the steps left) cannot exceed. Locked means that, against a rest that harvests at every step, harvesting at every step comes within 0.25 of a best response's expected return from the full patch, and is one where the computed gain is 0; it does not say restraint is not also an equilibrium, which no computation here checks, and the learning predictions add H3 (learners settle where the reading cannot see restraint) to the law. The joint learner's diagnosis is one seed's value table and a three-seed control.
