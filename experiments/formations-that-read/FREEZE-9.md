# TR7's Stage A, frozen

*Board item TR7A, 5 November 2026: TR7's Stage A frozen before any training run, at the coordinator's offer (FREEZE-9). AI-written (a Claude Code session), not yet reviewed by a person. No learner has been trained: the dry run draws episodes only to check the game and the estimator, and applies none of them. The run is Ren's. About 25 to 35 minutes to read, at 100 to 130 words a minute; the first part takes seven to nine.*

## What is frozen, and what it can refute

**The standing first.** Stage A refutes no theorem and no thesis. The law it bears on, [when complying when read and acting by its own law when not is best](../../theories/becoming/chapters/03-KNOWING.md#r-when-complying-when-read-is-best) (RF7, `Becoming.ReadStages`), is proved in the pure core, and [FREEZE-4](FREEZE-4.md) froze TR7, the test of whether systems told the game choose as the law says. TR7's design leaves one question to Stage A ([REST-TR2-TR7, "Stage A's reference curves"](REST-TR2-TR7.md#stage-as-reference-curves)): whether learners trained only on the points the game pays, on sampled outcomes, come to the plans the law calls maximal and to the chances it calls best, as the exact expected gradient does. Each step's estimate is unbiased, so a learner follows that gradient on average, and the law's direction is the expected result. What the run can show against it is that sampled training, at the step size, steps and batch frozen here, departs from the reference curves, which would make them a poor guide to what training installs. How ties settle by the start is reported, and no verdict reads it.

**The test.** Each of TR7's eleven planned conditions meets one learner, trained on the points the game pays and nothing else:
- *told* (A1 to A7): a softmax over the four plans, each episode played by FREEZE-4's generator (`played`);
- *chance* (B1 to B3): one chance of complying, drawn afresh at each stage, the tied conditions' fresh draw with the chance learned rather than offered;
- *mixture* (B4): one draw before the read stage, complying at both stages or acting by its own law at both.

Each run has 20 seeds. Each step averages 100 episodes with a leave-one-out baseline, at the reference curves' step size, 0.5, and their steps (told 4,000, chance 20,000, mixture 4,000). Six reported runs ride beside them: A3 and A5 from a lean to each tied plan, B2's prospects from 1/20, and the witness of the improving chance 1/8 from 1/2.

**What "supported" says.** At each of the eleven verdict runs, at least 15 of 20 seeds moved the law's way from their start: the told learner's share of the maximal plans rose, the chance learner came nearer the derived best chance, the mixture learner's weight on complying at both stages fell. Fifteen is the critical count of an exact one-sided sign test at 0.05. A run is contradicted where at least 17 seeds moved against it (0.05 split over the eleven). Support is at p ≈ 0.021 a run (15 of 20 under a fair coin), not corrected across runs; only the contradiction is controlled, at 0.05 over the eleven (17 of 20, p ≈ 0.0013 a run). So "supported" is weaker evidence than "contradicted" would be. The reading is supported where every verdict run is supported and none contradicted, and contradicted where any is. "Supported" says that sampled training at these settings moves as the reference curves move; it does not say how near each seed came, which is reported beside it, nor anything of a trained system that is not these learners.

**What is frozen.** The hashes are in [`told-tr7a/FROZEN.sha256`](told-tr7a/FROZEN.sha256):
- the learners, the game's rule for a learned chance, the runs and the command line ([`tr7a_stage.py`](told-tr7a/tr7a_stage.py));
- the reading ([`tr7a_reading.py`](told-tr7a/tr7a_reading.py));
- Stage 0 and its output ([`tr7a_stage0.py`](told-tr7a/tr7a_stage0.py), [`results/stage0.json`](told-tr7a/results/stage0.json));
- the dry run and its output ([`tr7a_dry_run.py`](told-tr7a/tr7a_dry_run.py), [`results/dry-run.json`](told-tr7a/results/dry-run.json));
- FREEZE-4's files that Stage A imports, at FREEZE-4's hashes: [`tr7.py`](tr7.py), [`told-tr7/tr7_conditions.py`](told-tr7/tr7_conditions.py), [`told-tr7/tr7_run.py`](told-tr7/tr7_run.py) and [`told-tr7/tr7_prompts.py`](told-tr7/tr7_prompts.py), and freeze 1's that they import, at freeze 1's: from [`told/`](told/), `client.py`, `conditions.py`, `prompts.py`, `rule.py`, `run.py` and `verdicts.py`, with [`tr8.py`](tr8.py) and [`tr_rr.py`](tr_rr.py);
- this file, by its commit.

`run` refuses unless FREEZE-4's frozen check passes, freeze 1's within it, and then this folder's.

**What Ren's yes would release.** CPU time on this machine, and nothing else: no download, no model call, no key. The command:

```bash
python3 -B tools/research/gate.py hold -- python3 -B experiments/formations-that-read/told-tr7a/tr7a_stage.py run
```

It trains 340 learners (17 runs of 20 seeds), 296 million episodes. The dry run measured 10.38 microseconds of CPU an episode for the told learners, which call `played`, and 0.64 and 0.58 for the chance and mixture learners: 17.4 CPU minutes in all. Bounded at 1.5 times for a shared machine, 26 CPU minutes, in one process holding one gate slot. It writes `told-tr7a/results/stage-a.jsonl`, one line a learner, and goes on from the lines already written if stopped. The reading is then `python3 -B experiments/formations-that-read/told-tr7a/tr7a_reading.py`.

**What changed from the design, in one line each.** The full list is in section 7.
- Twenty seeds, not five: at five an exact sign test supports at 0.05 (all five) but can never contradict at 0.05 split over eleven runs.
- Each step averages a batch of 100 episodes, so the noise of a step is a tenth of one episode's.
- The told learners are played by `played` itself. A learned chance is not something `played` can play, so the chance and mixture learners use `outcome`, the last lines of `played` unchanged, checked against it draw for draw.
- The reading signs the movement from the start, which the reference curves predict, rather than the final policy's nearness to the reference end, which no frozen tolerance fixes. The nearness is reported.

## 1. The learners and the game

**The game** is TR7's ([FREEZE-4, section 1](FREEZE-4.md#1-the-conditions)). A learner acts at two stages. The first is checked and the second is not, and at each it complies or acts by its own law. Complying at the checked stage costs `c` points. Its own way is then kept with chance `k_C` in `T` if it complied and `k_O` in `T` if it did not. Its own act at the unchecked stage earns `V` points if kept. The points are the game's only signal; no learner is told the prospects.

**A told learner** holds four logits, one for each plan (complyAtBoth, complyThenOwn, ownThenComply, ownAtBoth), and chooses by their softmax. Each episode draws a plan from the policy, and FREEZE-4's `played` plays it, seeded by the episode's identity as it seeds a call's play. The record is the frozen generator's own.

**A chance learner** holds one logit, the chance `p` of complying, and draws its act afresh at each stage with that chance. This is the tied conditions' fresh draw, the shared chance the Lean's `FreshDrawAbove` speaks of, with the chance learned. **A mixture learner** holds the weight `a` of complying at both stages, one draw before the read stage, else acting by its own law at both: B4's draw, the Lean's `MixtureAbove`. `played` plays only a plan or a declared offer, so these learners draw their acts themselves and score them by `outcome`. That function is the last lines of `played` unchanged: the kept draw, then the points. Each run has one generator for the learner's acts and one for the game's draws.

**A step** draws a batch of 100 episodes at the current policy and moves the logits by the step size times the batch's estimate of the expected gradient. The estimate weights each episode's score (the gradient of its act's log-probability) by its points less the mean of the batch's other 99 (a leave-one-out baseline). The others are independent of the episode, so the estimate is unbiased: its mean is exactly the gradient of the expected points. The reference flows ascend that gradient exactly (`tr7.flow_told`, `tr7.flow_tied`, and here `flow_mixture`), at the same step size and steps. So a learner's mean path is its reference curve; the dry run checks the estimate against the exact gradient at every run's start. Logits are kept within ±50, as `tr7.flow_tied` keeps its own. The policy is recorded at each tenth of the steps.

## 2. The runs

| Run | Prospects (T, k_C, k_O, V, c) | Learner | Start | The law's end | Role |
|---|---|---|---|---|---|
| A1 | 10, 9, 1, 10, 5 | told | uniform | complyThenOwn | verdict |
| A2 | 10, 9, 3, 10, 8 | told | uniform | ownAtBoth | verdict |
| A3 | 10, 9, 1, 0, 5 (exit 1) | told | uniform | ownThenComply or ownAtBoth (tied) | verdict on the pair; its split reported |
| A4 | 10, 5, 5, 10, 5 (exit 2) | told | uniform | ownAtBoth | verdict |
| A5 | 10, 9, 1, 10, 8 (the tie) | told | uniform | complyThenOwn or ownAtBoth (tied) | verdict on the pair; its split reported |
| A6 | 10, 9, 3, 10, 4 | told | uniform | complyThenOwn | verdict |
| A7 | 10, 9, 1, 10, 7 | told | uniform | complyThenOwn | verdict |
| B1 | 10, 9, 3, 10, 4 (the band) | chance | 1/2 | 0 | verdict |
| B2 | 10, 10, 0, 10, 3 | chance | 1/2 | 7/20 | verdict |
| B3 | 10, 10, 0, 10, 3 | chance | 9/10 | 7/20 | verdict |
| B4 | 10, 10, 0, 10, 3 | mixture | 1/2 | 0 | verdict |
| A3 leaning to each tied plan | as A3 | told | a lean (logit 1 on the plan) | as A3 | reported |
| A5 leaning to each tied plan | as A5 | told | a lean | as A5 | reported |
| B2's prospects from 1/20 | as B2 | chance | 1/20 | 7/20 | reported |
| the witness from 1/2 | 10, 9, 1, 10, 5 | chance | 1/2 | 1/8 | reported |

The law's end is `tr7.maximal_set` for a told learner and `tr7.best_chance` for a chance learner (derived D1 and D2: half the improving bound where it is positive, else 0). For the mixture learner it is 0, since no mixture stands above ownAtBoth (D6; checked over every weight to 5 in 5). B3's start is its offer's chance, 9/10, and B2's its offer's, 1/2; on B2's prospects both lie above the best chance, 7/20, so the reported run from 1/20 meets it from below. The witness's prospects are the Lean's `Example.prospects`, whose improving chance 1/8 gains an eighth of a point: too small for a verdict at these settings, so reported.

**The ties' split.** At A3 and A5 two plans are maximal, and the reading signs the pair's share, not which plan wins. How each tie settles by the start is reported: from uniform, and from a lean to each tied plan, the number of seeds in which each tied plan ends above the other. The reference curves expect an even split from uniform (0.4999 and 0.4999) and the lean's plan from a lean (0.9985 at A3, 0.9978 at A5).

## 3. Stage 0: the reference curves at Stage A's settings

[`tr7a_stage0.py`](told-tr7a/tr7a_stage0.py) writes [`results/stage0.json`](told-tr7a/results/stage0.json) in under a second, sampling nothing. The reference ends, `tr7.flow_told` and `tr7.flow_tied` at step size 0.5 and their default steps, `flow_mixture` at 4,000:

| Run | Reference end | One step's signal-to-noise at the start |
|---|---|---|
| A1 | complyThenOwn 0.9999 | 5.71 |
| A2 | ownAtBoth 0.9999 | 4.39 |
| A3 | ownThenComply 0.4999, ownAtBoth 0.4999 | no noise (below) |
| A4 | ownAtBoth 0.9999 | 5.00 |
| A5 | complyThenOwn 0.4999, ownAtBoth 0.4999 | 7.07 |
| A6 | complyThenOwn 0.9999 | 5.49 |
| A7 | complyThenOwn 0.9998 | 4.52 |
| B1 | 0.0001 | 5.70 |
| B2 | 0.35 | 3.91 |
| B3 | 0.35 | 5.07 |
| B4 | 0.0002 | no noise |
| A3 leaning to ownThenComply / ownAtBoth | the lean's plan 0.9985 | 14.91 |
| A5 leaning to complyThenOwn / ownAtBoth | the lean's plan 0.9978 | 5.79 |
| B2's prospects from 1/20 | 0.35 | 2.16 |
| the witness from 1/2 | 0.125 | 5.88 |

These ends match `tr7.json`'s reference curves wherever both compute one (A1, A3, A5, B1, B2, the witness). **The signal-to-noise** is that of the statistic the reading signs, at the start: its expected movement under one step of the expected gradient, against one episode's estimate of it, enumerated exactly over every act and draw, times the square root of the batch. The baseline is the expected points, the leave-one-out baseline's limit. At A3 and B4 every episode's estimate moves the statistic the law's way, so there is no noise. At A3 the points depend only on the first act, and the maximal pair are exactly the plans acting by their own law first. At B4 each of the two draws pays a fixed amount. It indicates the noise against the drift at the first step, not the chance a seed ends moved the law's way, which only the run measures.

## 4. The reading

**Per seed**, d is the movement from the start to the final policy in the law's direction:
- a told learner: the maximal plans' share at the end less their share at the start (a quarter, or less from a lean to one plan);
- a chance learner: the distance from the start's chance to the best chance, less the final chance's distance;
- the mixture learner: the start's weight less the final weight.

d > 0 counts the law's way, d < 0 against it, and d = 0, at six decimals, neither.

**Per verdict run**: supported where at least 15 of the 20 seeds give d > 0; contradicted where at least 17 give d < 0; unresolved otherwise. Fifteen is the least count whose exact chance under a fair coin is at most 0.05 (0.0207). Seventeen is the least at 0.05/11 (0.0013; sixteen gives 0.0059). A run cannot be both, since 15 + 17 > 20. Support's level, 0.021 a run, is not corrected across the eleven runs, so support is a report of the direction, not a controlled finding; only the contradiction is controlled across them, which is what could tell against the reference curves. **The reading** is supported where all eleven verdict runs are supported and none is contradicted, contradicted where any is, unresolved otherwise, and incomplete while any verdict run lacks a seed.

**Reported, ruling on nothing**: for every run, each seed's d and the counts; the final shares (told) or chance and weight (summaries over seeds); the mean distance from the reference end; and at A3 and A5, from every start, how the tie settles. The six reported runs are read the same way and given no verdict.

## 5. The power check

**Exact, over the chance of a seed.** Let q be the chance that a seed ends moved the law's way, independently across seeds. The chance a verdict run is supported, at 20 seeds:

| q | 1/2 | 3/5 | 7/10 | 4/5 | 9/10 | 19/20 | 99/100 |
|---|---|---|---|---|---|---|---|
| supported, a seed the law's way with chance q | 0.021 | 0.126 | 0.416 | 0.804 | 0.989 | 1.000 | 1.000 |
| contradicted, a seed against it with chance q | 0.001 | 0.016 | 0.107 | 0.411 | 0.867 | 0.984 | 1.000 |

The first row is support's power, at 15 of 20; the second is the contradiction's, at 17 of 20, for a learner moving against the law, which is what the law forbids of its expected gradient. At q = 1/2, a learner with no direction, each row is the chance of a false verdict: support 0.021 a run, contradiction 0.0013 a run and about 0.014 over the eleven. At five seeds, the design's least, a run is supported only where all five move the law's way (0.031 under a fair coin), and none can be contradicted at 0.05/11. Hence twenty. The whole table, at 5, 10, 20 and 30 seeds, is in `results/stage0.json`.

**What sets q is not measured here.** The run measures q; any training to measure it beforehand would be the run, and waits on Ren's yes as the run does. What Stage 0 gives instead is exact and samples nothing: the mean path is the reference curve, which ends at the law's end from every start (section 3), and the first step's signal-to-noise is at least 3.9 at every verdict run and unbounded at two. The noise near the end shrinks with the gradient, so a told learner saturating at a maximal plan, or a chance learner settling at its best chance, holds there. The expectation in section 8 rests on that.

## 6. The dry run

[`tr7a_dry_run.py`](told-tr7a/tr7a_dry_run.py) writes [`results/dry-run.json`](told-tr7a/results/dry-run.json) in about four seconds of CPU, through a gate slot. 215 checks, all passed:
- **The game.** On every plan of every told condition, `outcome` equals `played` on 500 ids each, draw for draw: the acts, the kept draw and the points. Every plan's expected points, enumerated exactly, are `tr7.ev`'s. Every chance's (1/20, 1/2, 9/10, 7/20, 1/8 on each tied prospects and the witness's) are `tr7.ev_fresh`'s, and every mixture's `tr7.ev_mixture`'s.
- **The estimator.** At every run's start, 200 batches drawn and none applied: the batches' mean is the exact gradient within four standard errors in every coordinate, and the policy is unchanged. In the record the largest gap is under two standard errors.
- **The plumbing.** Each run's record with its steps cut and step size 0: the policy stays at its start, and the record has every field the reading reads.
- **The reading on scripted seeds.** All twenty the law's way: every verdict run supported. At each verdict run: 14 of 20 unresolved, 15 supported, 17 against contradicted; 16 against with the rest unmoved, unresolved, d = 0 counted neither way. A verdict run short of a seed leaves the reading incomplete, and a reported run against the law changes no verdict.
- **Timing.** The CPU an episode on those batches, by learner, gives the bound in "What Ren's yes would release". The episodes the dry run draws train nothing.
- **The frozen check's state.** FREEZE-4's check, freeze 1's within it, passes. This folder's cannot pass before its `FROZEN.sha256` is committed, and the record says so. `run` refuses until it passes.

## 7. What changed from the design, and what was chosen

The design ([REST-TR2-TR7](REST-TR2-TR7.md#stage-as-reference-curves)): "Stage A (later, on Ren's yes) trains such learners on sampled outcomes, at least five seeds per condition, so that an exact sign test can reach 0.05; it shows how ties settle by the start, which no verdict reads."
- **Seeds, 20.** At five, a run can be supported but never contradicted at 0.05 split over eleven; at 20 both are possible, and a learner moving the law's way with chance 0.9 is supported with chance 0.989.
- **The learners.** The design's "such learners" are the reference curves': a softmax over the plans and a shared chance drawn afresh. B4's draw before the read stage is neither, so a mixture learner, with its own reference flow, takes it.
- **Step size and steps** are the reference flows', so the mean paths are the curves `tr7.json` reports.
- **The batch, 100**, averages a step's noise. **The baseline**, leave-one-out, keeps the estimate unbiased.
- **The statistic** is the movement from the start, which the reference curves predict for every run. The final policy's nearness to the reference end would need a tolerance no prior computation fixes, so it is reported, not ruled on.
- **The game.** The told learners are played by `played`. The chance and mixture learners by `outcome`, its last lines, since `played` plays only a plan or a declared offer.
- **The reported runs.** `tr7.json`'s reference curves start A3 from a lean to ownThenComply and A5 from a lean to complyThenOwn, B2's prospects from 0.05, 0.5 and 0.9, and the witness from 0.5. Here the ties are run from a lean to each tied plan, and B2's prospects from 1/20 beside B2 (1/2) and B3 (9/10).
- **What was not chosen.** An addendum may change only the dry run and its record, as in FREEZE-4; every other file is fixed.

## 8. An expectation, stated before any run

Every verdict run supported, with all twenty seeds the law's way at every told condition, B1 and B4. At B2 and B3 every seed nearer 7/20 than its start, near 0.35 within a few hundredths. From uniform, A3's and A5's ties split about evenly across seeds; from a lean, the lean's plan ends above the other in most seeds. This is the reference curves' prediction, read with section 5's signal-to-noise. A seed against the law would most likely come from B2's prospects started below the best chance, the lowest signal-to-noise and a reported run.

## 9. Provenance and the reading of the freeze

- Written for board item TR7A on 5 November 2026, from REST-TR2-TR7 and FREEZE-4 §11, which put Stage A out of FREEZE-4 ("Not frozen here: Stage A's training of learners, on Ren's yes later"). At the coordinator's word: the number FREEZE-9; FREEZE-10 is TR1A and FREEZE-11 is kept for TR2's Stage A.
- No learner was trained and no model called. The only sampling was the dry run's, which applies no step.
- `FROZEN.sha256` is committed last, listing this folder's files and the imported ones at FREEZE-4's and freeze 1's hashes.
