# The rest-outruns law on learners that generalize (EM1)

Board item EM1, 22 October 2026. AI-written (a Claude Code session). CG2 ([`../commons-outrun`](../commons-outrun/README.md)) tested on tabular Q-learners where learners reach depletion on a gated renewal. EM1 runs CG2's eleven conditions, exact classes, identity checks and verdict rules unchanged, with learners that generalize across states: a linear softmax policy over eight smooth features of the level and the steps left, trained by REINFORCE on whole-episode returns with a Monte Carlo baseline. The predictions were frozen at `42cf03228` ([`results/FROZEN-AT`](results/FROZEN-AT)) before any learning run on a test condition ([PREDICTIONS-2026-10-22.md](PREDICTIONS-2026-10-22.md)).

| File | What it is |
|---|---|
| [learners_pg.py](learners_pg.py) | The policy-gradient learners; CG2's environment and checks imported unchanged |
| [tune.py](tune.py), [results/tuning.json](results/tuning.json) | Learning rates chosen on one learner alone (k = 1), outside the test, before the freeze |
| [run.py](run.py), [analyze.py](analyze.py) | The frozen configuration (20 seeds × 11 conditions × 30,000 episodes); CG2's verdict rules plus E1–E3 |
| [results/runs.json](results/runs.json), [results/VERDICTS.json](results/VERDICTS.json) | Every run (with the learned parameters) and the verdicts |

## Verdicts (as frozen)

| Condition | Class | Predicted | Alive at H − 20 | Seeds ≥ 0.8 | Harvest | Verdict | CG2 |
|---|---|---|---|---|---|---|---|
| `k3s1` | locked | depleted | 0.00 | 0 | 9.4 | passed | passed |
| `k3s1_lam32` | locked | depleted | 0.90 | 18 | 0.9 | **failed** | passed |
| `k2s1` | locked | depleted | 0.00 | 0 | 9.6 | passed | passed |
| `k3s8` | locked | depleted | 1.00 | 20 | 73.8 | **failed** | passed |
| `k2s8` | open | kept | 1.00 | 20 | 156.8 | passed | passed |
| `k3s16` | open | kept | 1.00 | 20 | 282.4 | passed | passed |
| `k3s1_vlo` | locked | depleted | 0.00 | 0 | 9.4 | passed | passed |
| `k3s1_vhi` | open | kept | 0.95 | 19 | 0.5 | passed | passed |
| `k3s1_share` | locked | depleted | 1.00 | 20 | 11.6 | **failed** | passed |
| `k3s8_share` | open | kept | 1.00 | 20 | 164.6 | passed | failed |
| `k3s1_joint` | open | kept | 1.00 | 20 | 0.0 | passed | failed |

Identity checks: I1 (outrun windows) 9,026 windows, 0 violations; I2 (emptied totals) 12,600 episodes, 0 violations; I3 (CG1's balance, gate, margin and joint excess) 337,819,652 steps and 1,616,705 joint-excess windows, 0 violations. All passed.

Contrasts: X1 failed (`k3s8` kept), X2 failed (`k3s1_lam32` kept), X3 passed, X4 failed (`k3s1_share` kept), X5 passed. **E1 failed** (three of the six locked conditions kept), **E2 passed** (all five open conditions kept), **E3 passed** (the joint learner on whole-episode returns kept the patch in every episode of every seed, where CG2's temporal-difference joint learner emptied it in every one).

## What failed, and what did not

**The law held course by course.** Every window in which the rest outran the renewal ended the condition, and every emptied course took its start and everything given (I1, I2): `Flow.outrun_below` and `Regulation.accumulates_at` were never violated. The laws say what a reading sees along a course in which the rest outruns. They do not say that learners reach such courses.

**The bridge H3 failed for this learner class on the locked side.** CG2's prediction for locked settings rested on H3: the rest's exploration empties the patch before the reading in almost every training episode, so the coupling term is unselected and learners settle on depletion. For learners that generalize, H3 failed in three settings. Where restraint by all is also an equilibrium (`k3s1_lam32`, `k3s8`, `k3s1_share`; see the record's *does not show*), these learners reached it. In `k3s1_lam32` the end reading weighted 32 opened the lock that weight 2 (`k3s1`) did not, which is what the frozen file called the weight account. **So CG2's X2, "no weight of the end reading opens the lock", is a finding about tabular learners, not about learning in general.**

**E3 counts CG2's post hoc reading of its joint learner:** trained on the returns its acts led to, the joint learner kept the patch. Post hoc, it did so by never harvesting (harvest 0.0, an end reading of 54 against the exact optimum's 70.6), so it kept the patch without finding the optimal restraint.

## Post hoc (not counted)

Read after the verdicts from the learned parameters (harvest probability at level x with τ steps left, mean over seeds and members):

| Condition | x = 9, τ = 50 | x = 5, τ = 50 | x = 2, τ = 50 | x = 9, τ = 5 |
|---|---|---|---|---|
| `k3s1` (depleted) | 1.00 | 0.99 | 0.98 | 0.99 |
| `k3s1_lam32` (kept) | 0.08 | 0.09 | 0.09 | 0.06 |
| `k3s8` (kept) | 1.00 | 0.98 | 0.03 | 1.00 |
| `k3s1_share` (kept) | 0.16 | 0.04 | 0.02 | 0.36 |

In `k3s8` the learners reached a threshold profile: harvest unless the level is at 2 or below. Against a rest that harvests at every step that is not a best response (the class is locked), but against a rest that also restrains at low levels it keeps the patch. A reading, not tested: training episodes start at a random step (CG2's exploring starts), so many start with few steps left, where the rest cannot empty the patch before the end reading, and the member's restraint is visible to it there. A table learns those late states separately. A policy shared across states carries restraint selected where it is visible into the early states where, against a harvesting rest, it would not be. In the theory's terms, the selected object is the parameter vector, a condition shared by every state, and the end reading separates parameter values through the late-start episodes. So restraint at an early state lies beyond the end reading for that state's episode, but not for the parameters. **A follow-up that would test this reading:** the same learners with every training episode starting at step 0 are predicted to deplete the locked settings. That prediction would need its own freeze.
