# A commons with gated renewal: the theory's first falsifiable test on learning agents

Board item CG1, 20 October 2026. AI-written (a Claude Code session started from the significance review SA1). Study section 240 of [BECOMING-RENEWAL-READING](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/mirror/BECOMING-RENEWAL-READING/240.md#240-a-commons-with-gated-renewal-the-first-falsifiable-test-on-learning-agents-cg1).

SA1 found that no correspondence of the Theory of Becoming to physics, ecology, economics or AI had been measured. This experiment writes predictions from five laws of the spine for a Harvest-style commons with gated regrowth (Perolat et al. 2017), freezes them, and runs learning agents. Each prediction is reported as passed, failed or not testable, and every failure is kept.

| File | What it is |
|---|---|
| [PREDICTIONS-2026-10-20.md](PREDICTIONS-2026-10-20.md) | Round 1: system, reading of the laws' terms, bridge hypotheses H1 and H2, thirteen predictions with Lean names, classes and pass/fail rules, prior work and what is new. Frozen at `3a9806fe5`, before any learning run |
| [PREDICTIONS-2026-10-20-ROUND2.md](PREDICTIONS-2026-10-20-ROUND2.md) | Round 2: one change to training (exploring starts), all predictions and criteria unchanged. Frozen at `d73365d27`, after round 1's results were committed (`c8765a03c`) |
| [commons.py](commons.py) | The environment: 3×3 patches, regrowth by apples within distance 2, exact whole-apple accounting, one random stream per patch |
| [learning.py](learning.py) | Tabular Q-learners, the identity checks every episode passes through, scripted harvesters, the late-reading game |
| [run.py](run.py), [analyze.py](analyze.py), [calibrate.py](calibrate.py) | Frozen configurations; verdict rules; scripted calibration (the only run before the freeze) |
| [results/](results/) | Round 1 (`*.json`, `VERDICTS.json`), round 2 (`round2/`), the calibration; `FROZEN-AT` holds each run's commit |

To reproduce (Python 3.11, standard library only, CPU, about 20 minutes over 12 cores):

```bash
python3 run.py all && python3 analyze.py
```

```bash
python3 run.py round2 && python3 analyze.py results/round2
```

## Verdicts

Classes: *identity* (follows from premises the environment is built to meet; tests the identification, not the dynamics), *scope* (the law should fail where a premise fails), *law + H1 (+ H2)* (a law read through learning: H1, training is selection through the reward's coupling; H2, the learners come near the best return), *beyond the law*.

| Prediction | Law | Class | Round 1 | Round 2 |
|---|---|---|---|---|
| A1 joint excess: n steps of excess from below n + 1 leave a patch at 0 with no regrowth | `Flow.joint_excess_ends` | identity | **passed** (5,138,957 windows, 0 violations; 559M steps) | **passed** (4,704,548 windows, 0 violations) |
| A2 scope: the law fails for a patch read alone where a neighbour reseeds it, holds for the two read as one, holds where patches are isolated | the same, premise `gated` | scope | **passed**: gap 1, all 679 windows violated and 100/100 runs regrow after 0; union 0 violations (0 windows); gap 2, 0 of 656 violated | (round 1's run) |
| B1 margin: renewal admitted exactly when 1 + Σ taken ≤ x₀ + Σ given | `Flow.Balances.retains_iff_within_margin` | identity | **passed** (565M steps, 0 mismatches) | **passed** |
| B2 rate bound: mean collapse time ≤ 9 / (q − 0.30) | the margin + gate + exact R_max = 0.30 (Wald) | identity | **passed**: q = 0.5, 0.7, 1.0: 24.5 ≤ 45, 16.0 ≤ 22.5, 10.3 ≤ 12.9 | (round 1's run) |
| C1 at the last step with an apple standing, own learner harvests ≥ 95%, coupled ≤ 5% | `Flow.act_unselected`, `Flow.unselected_beyond_coupling` | law + H1 + H2 | **not testable**: no such decision (every patch empty before the last step) | **passed**: own 100% of 118, coupled 0% of 2,360 |
| C2 level left at H: coupled − own ≥ 2.0; coupled alive ≥ 90%; own dead ≥ 50% | the same | law + H1 + H2 | **failed**: both 0.0, coupled alive 0% | **failed**: 0.95 − 0.00; coupled alive 59%; own dead 99.7% |
| C3 own learner alive at H − 20 in ≥ 80% | none (H2 only) | beyond the law | **failed**: 0% | **failed**: 51% |
| D1 a learner beyond the pool's closure changes nothing in it (bit for bit), and its change acts at its own patch | `Flow.unselected_beyond_pool` | identity | **failed** on the second clause: the A pool identical in 10/10 seeds; B empty in both conditions | **failed**, the same: identical 10/10; B empty in both |
| D2a a coupled member does no more for the stock than its absence: survival(1c+2o) ≤ survival(2o) + 0.10, survival(2c+1o) ≤ survival(1o) + 0.10 | `Flow.unselected_beyond_pool`, `withinClosureOf_iff` | law + H1 + H2 | **passed**, vacuously (every survival 0) | **passed**, vacuously (all 0; 1o: 2%) |
| D2b all three coupled: survival ≥ 80% and ≥ survival(2c+1o) + 0.30 | the same | law + H1 + H2 | **failed**: 0% | **failed**: 0% |
| E1 the late return keeps [−(ℓ+1)d, (ℓ+1)d] against every rest tried | `Regulation.lateReturn_band` | identity | **passed** (40 cells, 0 exits) | (round 1's run) |
| E2 under any rule the two constant rests end ≥ 2(ℓ+1)d apart | `Regulation.late_band`, `Regulation.no_narrower_band` | identity | **passed** (attained exactly) | (round 1's run) |
| E3 a learned adversary breaks a band one narrower than 2(ℓ+1)d, against the late return and a learned overseer, ℓ = 0–3 | `Regulation.no_narrower_band` | law + H2 | **passed** (80 of 80 seed-cells) | (round 1's run) |

Count: of the identity and scope predictions, all seven of A1, A2, B1, B2, D1's first clause, E1 and E2 held. D1 as frozen failed, because its manipulation check failed. Of the learning predictions, E3 and (in round 2) C1 passed; C2, C3 and D2b failed in both rounds; D2a passed only vacuously.

## What the results say

**The laws' conclusions hold where their premises hold and fail where they fail.** This is the identification, not the dynamics: A1, B1, B2, E1 and E2 cannot fail in an environment that keeps whole-number balance and the gate, and they did not. A2 is the informative one. Where two patches lie within the regrowth radius, joint excess on one patch read alone does not end its renewal (all 679 windows violated, 100 of 100 runs regrow after reaching 0). Read as one condition, the two patches meet the law. Which condition the law is about is exactly the gate's premise: which givers need it. SA1's verdict that these laws are near-definitional stands. The test adds that the identification is right in a standard commons.

**The selection gap shows where the theory places it, and only there.** With enough coverage (round 2), an own-reward learner spends the last apple at the last step every time, and a learner whose reward reads the level after the last step never does (C1). The difference between the two lies wholly beyond the own learner's reward, and it is not selected. The whole-episode extension failed. The coupled learner kept the patch alive in only 59% of episodes (10 of 20 seeds at or above 70%, 7 below 30%), and the own learner emptied its patch before step H − 20 in about half of them. The learners reached 13 apples where the best scripted rule takes 28.5. These failures sit in H2, the bridge: tabular Q-learning with this horizon and exploration does not come near the best return. They do not touch the gap law, which says what cannot be selected, not that a learner finds what can. A post-hoc observation, not a frozen test: in D2's single-learner conditions, trained 30,000 episodes rather than 20,000, the coupled learner kept the patch alive in 100% of episodes and the own learner in 2%.

**Coupling every member into the stock did not keep it (D2b, both rounds).** This is the substantive failure. Three learners whose rewards each read the level left at the end still emptied the patch within a few steps in every episode, harvesting 9.4 apples between them, about the 9 standing at the start. The prediction read the pool law as "the pool's selection reaches the stock through every member's coupling, so the stock is selected for". The first half is the law; the second is not. Where the others harvest at every step, one member's restraint changes nothing it couples into, since the others take what it leaves. Harvesting at every step is then a best response for each member, coupled or not: a mutual best response that independent learners reach (Perolat et al.'s tragedy, here with coupled rewards). The spine's selection laws are laws of blindness: what no selection through a coupling can tell apart. They do not say which of several self-consistent outcomes learners reach. So "widen the coupling" is necessary for the stock to be selected for, and this test shows it is not sufficient for independent learners. D2a passed, but only because every multi-learner condition failed alike.

**The late reading's bound is realised by learners.** No rule reading ℓ steps late holds a band narrower than 2(ℓ + 1)d against every rest. A learned adversary found the break against both the late return and a learned overseer in every seed and lateness (E3), while the late return held the band of exactly that width against everything (E1). The worst case needs no cunning. It is a constant push for ℓ + 1 steps, which is why learners find it. Against random rests the late return left the narrow band in 27–100% of courses, falling with lateness (descriptive), so typical rests sit well inside the worst case.

## What is new against prior work, and what is not

Known before this test: commons collapse under independent learners (Perolat et al. 2017), irreversible loss of an emptied patch (Melting Pot's substrates), the help of rewards coupled into others or the commons (Hughes et al. 2018; reward exchange and the self-interest level, arXiv 2501.16138), and horizon effects (Pardo et al. 2018). This test claims none of them. New here are the frozen quantitative forms and their outcomes: the scope of joint excess at adjoining patches (held); the collapse-rate bound from the margin and the exact maximum regrowth (held, not tight: 54–80% of the bound); the gap's contrast at the end of the coupling (held in round 2) and its whole-episode extension (failed, through H2); the heterogeneous pool prediction (failed in its positive half: all members coupled is not enough); and the least band of a late reading met by learned adversaries (held). The identity class gives no empirical support to the theory beyond the correctness of its identification.

## Corrections after the freeze

1. `analyze.py` crashed on round 1's C1, where neither condition had a last-step decision with an apple standing. The frozen rule did not foresee a side with no decision. Such a side is now *not testable*, never passed (commit `c8765a03c`). No criterion changed.
2. Round 2 is a second freeze, motivated by round 1's diagnosis (training never reached late steps alive, so the coupling term returned nothing). Its one change is to training, and round 1's verdicts stand.

## Limits

The agents do not walk or tag, so the commons is Perolat et al.'s regrowth rule with the spatial game removed. The learners are tabular Q, and their failures to reach the best return (H2) bound what the learning predictions can say. Seeds are 20 per condition (10 for D1 and E). E is the law's own one-condition setting, not the commons' dynamics. D1's manipulation check failed because 10,000 episodes left the coupled learner at patch B no better than the own one. The bit-for-bit identity it was guarding held in all seeds of both rounds.
