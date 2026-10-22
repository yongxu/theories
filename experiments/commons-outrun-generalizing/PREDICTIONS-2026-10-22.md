# Predictions for EM1: the rest-outruns law on learners that generalize, frozen 22 October 2026

Board item EM1. AI-written (a Claude Code session of 22 October 2026). Frozen before any learning run on a test condition: this file, the learners ([`learners_pg.py`](learners_pg.py)), the configuration ([`run.py`](run.py), `CONFIG`), the verdict rules ([`analyze.py`](analyze.py), which runs CG2's rules unchanged) and the tuning output ([`results/tuning.json`](results/tuning.json)) are committed together, and the runs are made from that commit. The environment, the eleven conditions, their exact classes and the identity checks are CG2's ([`../commons-outrun`](../commons-outrun/README.md): `conditions.py`, `results/calibration.json`, `learners.OutrunChecks`; CG1's `commons.py` and `learning.Checks`), unchanged.

Run before the freeze: the tuning ([`tune.py`](tune.py)) on one learner alone on the patch (k = 1, s = 1, its own apples plus twice the last level), a setting that is not one of the eleven, has no rest and so makes no prediction of the law to protect. Four learning rates, 3 seeds each, 30,000 episodes; the exact optimum there is 37.11 (CG2's `calibrate.value(0, 1, lam=2.0)`), and the rate frozen (α = 10⁻³, baseline rate β = 10⁻³) reached 35.19 in greedy evaluation, every seed keeping the patch at step H − 20. And a smoke run of every code path (30 episodes per condition, read only as "it runs"). No test condition was trained beyond those 30 episodes.

## Why this test

CG1 and CG2 tested the selection laws on independent tabular Q-learners. Two things limit what they show about actual learning systems. A table learns each state separately, while every deployed learning system generalizes: what it learns at one state moves what it does at others. And a temporal-difference learner selects each step's action through its own later values, which CG2's joint learner showed can fail in a way the law does not predict (it emptied the patch where the exact optimum keeps it; CG2's post hoc reading, not counted, was that its restraint changed nothing its own later, unconverged values could see). EM1 changes the learner class on both counts: a parametric policy over eight smooth features of the level and the steps left, trained by REINFORCE on the returns its acts actually led to (a Monte Carlo linear baseline, no bootstrapping).

## The law and the bridges

The law is CG2's (`Flow.outrun_reading_alike`, `Flow.act_unselected`): where the other members, harvesting at every step, end the condition before the step the member's reward reads, the member's restraint changes nothing its reward reads except its own apples, so harvesting at every step is a best response for every weight of that reading. The calibration classes each condition exactly (locked: gain < 0.25; open: gain ≥ 1.0).

- **H1, training is selection through the reward's coupling.** A policy-gradient learner's parameters change only through the returns it receives: two episodes alike in every reward it reads move it alike.
- **H3, learners reach the class's outcome** (CG2's H3): on the locked side the coupling term is unselected in almost every training episode, so learners settle on depletion; on the open side it is selected whenever the rest harvests, so they leave it. H3 is where a prediction can fail without the law failing, and on the open side the learner's capacity to find a restraining policy is part of it.

## Predictions

**Training and evaluation.** k independent PG learners (one for the joint condition, choosing 0 to 3 requests), state features as in `learners_pg.features`, undiscounted, α = β = 10⁻³, 30,000 training episodes with exploring starts (random step, random apples), exploration by the softmax policy itself, H = 100; 20 seeds per condition; 200 greedy evaluation episodes from a full patch on fresh regrowth streams. **Measure** (CG2's): the share of evaluation episodes in which the patch still stands at step H − 20, averaged over seeds.

**Per condition** (CG2's rules): *kept* passes if the measure is at least 0.80; *depleted* passes if it is at most 0.20; otherwise failed. The predicted outcome of each condition is CG2's frozen one (locked → depleted, open → kept):

| Condition | Class | Predicted |
|---|---|---|
| `k3s1`, `k3s1_lam32`, `k2s1`, `k3s8`, `k3s1_vlo`, `k3s1_share` | locked | depleted |
| `k2s8`, `k3s16`, `k3s1_vhi`, `k3s8_share`, `k3s1_joint` | open | kept |

**Contrasts** (each passes only if all its conditions pass): CG2's X1–X5 unchanged, and

- **E1, the locked side holds for learners that generalize:** all six locked conditions depleted. This is the side where the law speaks. *A generalization account* (a learner that generalizes across states carries restraint learned where it pays into states where the rest outruns) predicts some locked condition kept.
- **E2, the open side holds for learners that generalize:** all five open conditions kept. This is H3 on the open side, with the learner's capacity in it.
- **E3, a selector reading the union on whole-episode returns keeps the patch:** `k3s1_joint` kept. CG2's temporal-difference joint learner emptied it in every episode of every seed; CG2's post hoc reading says this was its own later values, not the reading. E3 counts that reading: a learner trained on the returns its acts led to, with no rest outside it, is predicted to keep the patch.

**Identity checks** (CG2's I1–I3, unchanged): the outrun windows, the emptied totals and CG1's balance, gate, margin and joint-excess checks, at zero violations.

## What would change the account

E1 failing (a locked condition kept by learners that generalize) would say that the law's blindness reading, sound for each course, does not decide which outcome generalizing learners reach on the locked side: the strongest failure this test can show. E2 or E3 failing would bound H3 for this learner class without touching the law. Each verdict is reported as it falls.
