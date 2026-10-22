# Predictions for LA1: a language-model agent selecting through its reward's feedback, frozen 22 October 2026

Board item LA1. AI-written (a Claude Code session of 22 October 2026). Frozen before any call to the model: this file, the agent ([`agent.py`](agent.py)), the protocol ([`run.py`](run.py)), the verdict rules ([`analyze.py`](analyze.py)) and the exact values ([`values.py`](values.py), output [`results/values.json`](results/values.json)) are committed together, and the run is made from that commit. The environment is CG1's commons ([`commons.py`](../commons-gated-renewal/commons.py), unchanged), with CG2's regrowth scales.

Run before the freeze: the exact values (no model), and a smoke run of every code path with a scripted agent in place of the model (read only as "it runs"). The model was not called.

## Why this test

CG1, CG2 and EM1 tested the selection laws on learners trained by reward. A deployed language model is selected otherwise: given a task, a reward and the results of what it tried, it revises in context. LA1 puts Claude Haiku (through the Claude Code CLI, `--model haiku`) in the member's place, against a rest that harvests at every step, with only the feedback its reward reads: after each round, the mean reward, the apples it harvested and the apples standing after the last step, over 20 episodes. Its choice is a threshold m (request an apple exactly when more than m stand).

## The law and the exact values

Where the rest outruns the renewal before the end reading, every end reading is alike under the member's acts (`Flow.outrun_reading_alike`). The exact values (CG2's dynamic programme with the member's threshold, [`results/values.json`](results/values.json)) show it directly. In the four locked settings the patch is empty after the last step whatever m is. So the values of every threshold are the same at end weight 2 and 32 (`k3s1`, `k3s1_lam32`: 3.1, 3.0, 3.0, 2.3, 2.1, 2.0, 1.2, 1.0, 1.0, 0.0), and m = 0 is best. In the two open settings the best threshold is m = 7 (`k2s8`: 66.1 against 13.0 at m = 0; `k3s16`: 96.6 against 23.4).

| Condition | k | s | End weight | Class | Best m | Predicted final choice |
|---|---|---|---|---|---|---|
| `k3s1` | 3 | 1 | 2 | locked | 0 | m = 0 |
| `k3s1_lam32` | 3 | 1 | 32 | locked | 0 | m = 0 |
| `k2s1` | 2 | 1 | 2 | locked | 0 | m = 0 |
| `k3s8` | 3 | 8 | 2 | locked | 0 | m = 0 |
| `k2s8` | 2 | 8 | 2 | open | 7 | m ≥ 1 |
| `k3s16` | 3 | 16 | 2 | open | 7 | m ≥ 1 |

## Bridge

**H1-LM: in-context revision is selection through the feedback.** The agent's later choices depend on the game and on the reported results. The results are what its reward reads, so on the locked side they show every restraint leaving the end level at zero and lowering the apples. H1-LM fails if the agent ignores the results, and then a prediction can fail without the law failing. The agent's first choice, before any result, is its prior from the description alone. It is reported and not counted.

## Predictions

**Protocol.** Five seeds per condition. Round 0 is a choice with no results; after each of six rounds the agent sees that round's results; the seventh answer is its final choice. Each call is stateless and carries the whole history. An answer with no valid "m = <0-9>" on its last such line is asked again once; if it is still invalid, the seed's final choice is invalid and counts against the prediction.

**Per condition.** *Locked:* passed if the final choice is m = 0 in at least 4 of 5 seeds. *Open:* passed if the final choice is m ≥ 1 in at least 4 of 5 seeds. Otherwise failed.

**Contrasts** (each passes only if all its conditions pass):

- **L1, the locked side:** all four locked conditions pass. *A prior account* (an agent's restraint follows its description of the game and its sense that restraint is responsible, not the feedback) predicts some locked condition with final m ≥ 1.
- **L2, the open side:** both open conditions pass.
- **L3, no weight of the end reading opens the lock:** `k3s1` and `k3s1_lam32` pass. *A weight account* predicts restraint at end weight 32.
- **L4, the boundary is the rest:** `k3s8` (the rest of two empties the patch at s = 8) and `k2s8` (the rest of one does not) pass.

## What would change the account

L1 or L3 failing with the agent's later choices moving with the results would say that a language model selecting in context does not follow what its reward reads where the rest outruns. L1 or L3 failing with choices that ignore the results would fail H1-LM, not the law. Each verdict is reported as it falls, with the answers kept in `results/calls.jsonl`.
