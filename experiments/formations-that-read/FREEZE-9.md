# TR7's Stage A, frozen

*Board item TR7A, 5 November 2026: TR7's Stage A frozen before any training run, at the coordinator's offer (FREEZE-9). AI-written (a Claude Code session), not yet reviewed by a person. No learner has been trained: the dry run draws episodes only to check the game, the estimator and the run's plumbing, and applies none of them. The run is Ren's. About 43 to 56 minutes to read, at 100 to 130 words a minute; the first part takes ten to thirteen.*

## What is frozen, and what it can refute

**The standing first.** Stage A refutes no theorem and no thesis. The law it bears on, [when complying when read and acting by its own law when not is best](../../theories/becoming/chapters/03-KNOWING.md#r-when-complying-when-read-is-best) (RF7, `Becoming.ReadStages`), is proved in the pure core, and [FREEZE-4](FREEZE-4.md) froze TR7, the test of whether systems told the game choose as the law says. TR7's design leaves one question to Stage A ([REST-TR2-TR7, "Stage A's reference curves"](REST-TR2-TR7.md#stage-as-reference-curves)): whether learners trained only on the points the game pays, on sampled outcomes, move toward the plans the law calls maximal and the chances it calls best, as the exact expected gradient does. Each step's estimate is unbiased at the current policy, so a learner follows its reference curve to first order in a step's noise, and the run shows how far sampled paths depart. What the run can show against the curves is that at some verdict run most seeds move away from the law's end (contradicted), or too few move toward it (unresolved). The curves' direction would then not be what sampled training installs at the step size, steps and batch frozen here, and they would be a poor guide to it. How ties settle by the start is reported, and no verdict reads it.

**The test.** Each of TR7's eleven planned conditions meets one learner, trained on the points the game pays and nothing else:
- *told* (A1 to A7): a softmax over the four plans, each episode played by FREEZE-4's generator (`played`);
- *chance* (B1 to B3): one chance of complying, drawn afresh at each stage, the tied conditions' fresh draw with the chance learned rather than offered;
- *mixture* (B4): one draw before the read stage, complying at both stages or acting by its own law at both.

Each run has 20 seeds. Each step averages 100 episodes with a leave-one-out baseline, at the reference curves' step size, 0.5, and their steps (told 4,000, chance 20,000, mixture 4,000). Six reported runs ride beside them: A3 and A5 from a lean to each tied plan, B2's prospects from 1/20, and the witness of the improving chance 1/8 from 1/2.

**What "supported" says.** At every one of the eleven verdict runs, at least 15 of 20 seeds ended nearer the law's end than they began: the told learner's share of the maximal plans rose, the chance learner's chance came nearer the derived best chance, the mixture learner's weight on complying at both stages fell. That is the direction the reference curves move. It says nothing of the path, nor of how near a seed came, which is reported beside it, nor of any trained system that is not these learners.

Each run's support is an exact one-sided sign test: 15 of 20 has chance 0.021 under a fair coin. The reading's support needs every run, so it is controlled at 0.021 with no correction: were the learners at any one run without direction, the reading would be supported with chance at most 0.021. One run's support read alone among the eleven is not corrected; with no direction anywhere, some run would pass with chance about 0.21. The contradiction needs only one run, so its level is split: a run is contradicted where at least 17 seeds moved away from the law's end, chance 0.0013 a run and about 0.014 over the eleven. The reading is incomplete while a verdict run lacks a seed; otherwise it is contradicted where any verdict run is, supported where every one is, and unresolved otherwise. At A3 and B4 no step can move a seed away from the law's end (section 3), so those two runs can only be supported, and the reading's chance to fail rests on the other nine.

**What is frozen.** The hashes are in `told-tr7a/FROZEN.sha256`, which lists this folder's files:
- the learners, the game's rule for a learned chance, the runs, the run's records and its resume ([`tr7a_stage.py`](told-tr7a/tr7a_stage.py));
- the reading ([`tr7a_reading.py`](told-tr7a/tr7a_reading.py));
- Stage 0 and its output ([`tr7a_stage0.py`](told-tr7a/tr7a_stage0.py), [`results/stage0.json`](told-tr7a/results/stage0.json));
- the dry run and its output ([`tr7a_dry_run.py`](told-tr7a/tr7a_dry_run.py), [`results/dry-run.json`](told-tr7a/results/dry-run.json));
- the writer of the hash file ([`write_frozen.py`](told-tr7a/write_frozen.py));
- this file, by its commit (section 10).

The files Stage A imports are FREEZE-4's: [`tr7.py`](tr7.py), [`told-tr7/tr7_conditions.py`](told-tr7/tr7_conditions.py), [`told-tr7/tr7_run.py`](told-tr7/tr7_run.py) and [`told-tr7/tr7_prompts.py`](told-tr7/tr7_prompts.py). With them come the files of freeze 1 that they import, from [`told/`](told/): `client.py`, `conditions.py`, `prompts.py`, `rule.py`, `run.py`, `verdicts.py` and `PINS.json`, which `run.py` reads at import. [`tr8.py`](tr8.py) and [`tr_rr.py`](tr_rr.py) come too. This folder's link does not list them again. `run` refuses unless FREEZE-4's frozen check passes, freeze 1's within it, and FREEZE-4's check holds each of these files at FREEZE-4's newest link; this folder's check runs after it. FREEZE-4's addenda may change only freeze 1's client and a pin's `served_as`, each as freeze 1's own addendum changed it, and FREEZE-4's dry run and its record. Stage A uses none of them. So FREEZE-4's newest link fixes everything Stage A computes with, and an addendum there needs none here. After an addendum to freeze 1's client, FREEZE-4's check, and so `run`, refuses until FREEZE-4 takes its own addendum. Meanwhile the run can be made in a checkout of this freeze's newest link's commit, where every chain checks, as the shared-harness lesson says (section 8).

**What Ren's yes would release.** CPU time on this machine, and nothing else: no download, no model call, no key. The command:

```bash
python3 -B tools/research/gate.py hold -- python3 -B experiments/formations-that-read/told-tr7a/tr7a_stage.py run
```

It trains 340 learners (17 runs of 20 seeds), 296 million episodes. The dry run measured 10.67 microseconds of CPU an episode for the told learners, which call `played`, and 0.65 and 0.58 for the chance and mixture learners: 17.9 CPU minutes in all, 26.8 with a margin of 1.5 times for a shared machine. That is an estimate, not a bound: nothing stops the run at it. It runs in one process, holding one gate slot. It writes `told-tr7a/results/stage-a.jsonl`, one line a learner, each naming the frozen link it ran under. If stopped, it goes on from the lines already written, setting aside a last line cut by a kill or a full disk and training that learner again. The reading is then `python3 -B experiments/formations-that-read/told-tr7a/tr7a_reading.py`. It refuses unless the frozen check passes, and writes `told-tr7a/results/reading.json`.

**What changed from the design, in one line each.** The full list is in section 7.
- Twenty seeds, not five: at five an exact sign test can support at 0.05 but never contradict at 0.05 split over eleven runs, and twenty gives the power.
- Each step averages a batch of 100 episodes, so the noise of a step is a tenth of one episode's.
- The told learners are played by `played` itself. A learned chance is not something `played` can play, so the chance and mixture learners use `outcome`, the last lines of `played` unchanged, checked against it draw for draw.
- The reading signs the movement toward the law's end from the start, rather than the final policy's nearness to the reference end, which no frozen tolerance fixes. The nearness is reported.
- A5, the tie, has a verdict here on its pair's share; TR7 reads it by contradiction only.

## 1. The learners and the game

**The game** is TR7's ([FREEZE-4, section 1](FREEZE-4.md#1-the-conditions)). A learner acts at two stages. The first is checked and the second is not, and at each it complies or acts by its own law. Complying at the checked stage costs `c` points. Its own way is then kept with chance `k_C` in `T` if it complied and `k_O` in `T` if it did not. Its own act at the unchecked stage earns `V` points if kept. The points are the game's only signal; no learner is told the prospects.

**A told learner** holds four logits, one for each plan (complyAtBoth, complyThenOwn, ownThenComply, ownAtBoth), and chooses by their softmax. Each episode draws a plan from the policy, from a generator seeded by the run's condition, start, seed and step. FREEZE-4's `played` then plays the plan, seeded by the episode's identity as it seeds a call's play, so the record is the frozen generator's own.

**A chance learner** holds one logit, the chance `p` of complying, and draws its act afresh at each stage with that chance. This is the tied conditions' fresh draw, the shared chance the Lean's `FreshDrawAbove` speaks of, with the chance learned. **A mixture learner** holds the weight `a` of complying at both stages, one draw before the read stage, else acting by its own law at both: B4's draw, the Lean's `MixtureAbove`. `played` plays only a plan or a declared offer, so these learners draw their acts themselves and score them by `outcome`. That function is the last lines of `played` unchanged: the kept draw, then the points. Each chance or mixture learner, a run at a seed, has two generators, one for its acts and one for the game's draws.

**A step** draws a batch of 100 episodes at the current policy and moves the logits by the step size times the batch's estimate of the expected gradient. The estimate weights each episode's score (the gradient of its act's log-probability) by its points less the mean of the batch's other 99 (a leave-one-out baseline). The others are independent of the episode, so the estimate is unbiased: its mean, at the current logits, is exactly the gradient of the expected points there. The reference flows ascend that gradient exactly (`tr7.flow_told`, `tr7.flow_tied`, and here `flow_mixture`), at the same step size and steps. A step is not linear in the logits, so unbiased steps do not make the mean over seeds the reference curve. A learner follows the curve to first order in a step's noise, and the run shows how far sampled paths depart, at the ties most (section 2). The dry run checks the estimate against the exact gradient at every run's start.

Logits are kept within ±50, as `tr7.flow_tied` keeps its own. `tr7.flow_told` has no clip; its logits stay within 8.2 of zero at every told run here, so the clip is not expected to act on a told learner. The policy is recorded at each tenth of the steps.

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

The law's end is `tr7.maximal_set` for a told learner and `tr7.best_chance` for a chance learner (derived D1 and D2: half the improving bound where it is positive, else 0). For the mixture learner it is 0. The Lean's `mixture_never_above` says no mixture stands above ownAtBoth. Derived D6 adds that, with `k_O V + c T > 0`, ownAtBoth stands strictly above every mixture with weight on complying, so the expected gradient drives the weight to 0. The reading checks that `tr7.mixture_above` fails at every pair of weights from 1 to 5.

B3's start is its offer's chance, 9/10, and B2's its offer's, 1/2. On B2's prospects both lie above the best chance, 7/20, so the reported run from 1/20 meets it from below. The witness's prospects are the Lean's `Example.prospects`, whose improving chance 1/8 gains an eighth of a point over ownAtBoth. It is reported because it is not one of TR7's planned conditions.

**The ties' split.** At A3 and A5 two plans are maximal, and the reading signs the pair's share, not which plan wins. How each tie settles by the start is reported: from uniform, and from a lean to each tied plan, the number of seeds in which each tied plan ends above the other. The deterministic curves end evenly split from uniform (0.4999 and 0.4999), and at the lean's plan from a lean (0.9985 at A3, 0.9978 at A5). No seed is expected at the even split:
- At A5, once the pair holds the mass, the difference between the two plans' logits is a random walk with no drift, spreading by 0.15 a step at the even split.
- At A3 the drift favours whichever tied plan leads while any mass is left on complying first, and stops when none is.

So each seed's split is its own, the counts are the report, and the distance from the reference end at A3 and A5 is large by design.

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

`tr7.json` holds reference curves for ten of these runs: A1, A3 and A5 from uniform, A3 from a lean to ownThenComply, A5 from a lean to complyThenOwn, B1, B2, B3, B2's prospects from 1/20, and the witness. The ends match there, and the dry run checks that they do. Stage 0 alone gives the other seven.

**The signal-to-noise** is that of the statistic the reading signs, at the start. It divides the statistic's first-order movement under one step of the expected gradient by the standard deviation of one episode's estimate of that movement, enumerated exactly over every act and draw, and multiplies by the square root of the batch. The baseline is the expected points, the leave-one-out baseline's limit. It indicates the noise against the drift at the first step, not the chance a seed ends moved the law's way, which only the run measures.

**A3 and B4 cannot move away from the law's end.** At A3 (`V` = 0) the points depend only on the first act. The two plans acting by their own law first, the maximal pair, pay 0, and the two complying first pay −5. At B4 (`k_O` = 0) complying at both stages pays −3, and acting by its own law at both pays 0. The leave-one-out advantages sum to zero in every batch. So a plan's logit moves by the sum of the advantages of the episodes that chose it, over the batch, and the mixture's logit by those of the episodes that drew complying. An episode of the better kind has advantage at least 0, and one of the worse at most 0. So at any policy no step lowers the pair's share at A3 or raises the weight at B4, and the expected-points baseline sees no noise there. A seed moves neither way only if every batch of its run is of one kind. At A3's and B4's verdict starts the first batch alone is of one kind with chance 2^−99. The dry run checks the sign on 200 batches from every start of the two. So A3 and B4 can only be supported.

## 4. The reading

**Per seed**, d is the movement from the start to the final policy toward the law's end:
- a told learner: the maximal plans' share at the end less their share at the start (a quarter from uniform where one plan is maximal, a half at A3 and A5 from uniform, 0.650 from a lean to one of the tied plans);
- a chance learner: the start's distance from the best chance, less the final chance's distance;
- the mixture learner: the start's weight less the final weight.

d > 0 counts the law's way, d < 0 against it, and d = 0, at six decimals, neither. A chance learner that falls to 0, never complying, counts the law's way at B3 (d = 0.20) and at the witness (d = 0.25). So where the best chance lies inside (0, 1), the seeds ending within the improving chances are counted beside the verdict: above 0 and below the improving bound, which is 7/10 on B2's prospects and 1/4 at the witness. Only B2 from 1/2, where falling to 0 gives d = −0.20, and the run from 1/20 tell the improving chance from dropping to ownAtBoth.

**Per verdict run**: supported where at least 15 of the 20 seeds give d > 0; contradicted where at least 17 give d < 0; unresolved otherwise. Fifteen is the least count whose exact chance under a fair coin is at most 0.05 (0.0207; fourteen gives 0.0577). Seventeen is the least at 0.05/11 (0.0013; sixteen gives 0.0059). A run cannot be both, since 15 + 17 > 20.

**The reading** goes in this order:
1. incomplete while any verdict run lacks a seed;
2. otherwise contradicted where any verdict run is contradicted;
3. supported where all eleven are supported;
4. unresolved otherwise.

Its support is controlled at 0.021 with no correction, since it needs every run: an intersection-union test. One run's support read alone is not corrected across the eleven. The contradiction needs one run, so its level is split: 0.0013 a run, about 0.014 over the eleven. Since A3 and B4 cannot be contradicted, that is at most 0.012.

**The records.** The reading refuses unless the frozen check passes. It also refuses a record that is:
- for a run or seed not frozen, or a learner recorded twice;
- one whose fields are not its run's, or whose final policy is of the wrong shape;
- not stamped with a link of this freeze's chain.

So a complete run is each of seeds 0 to 19 once. The reading writes `results/reading.json`.

**Reported, ruling on nothing**: for every run, each seed's d and the counts; the final shares (told) or chance and weight (summaries over seeds); the mean distance from the reference end. Where the best chance is inside (0, 1), the seeds ending within the improving chances; at A3 and A5, from every start, how the tie settles. The six reported runs are read the same way and given no verdict.

## 5. The power check

**Exact, over the chance of a seed.** Let q be the chance that a seed ends moved the law's way, and r the chance it ends moved away from the law's end, independently across seeds. At 20 seeds:

| chance a seed, q or r | 1/2 | 3/5 | 7/10 | 4/5 | 9/10 | 19/20 | 99/100 |
|---|---|---|---|---|---|---|---|
| supported, a seed the law's way with chance q | 0.021 | 0.126 | 0.416 | 0.804 | 0.989 | 1.000 | 1.000 |
| contradicted, a seed away from the law's end with chance r | 0.001 | 0.016 | 0.107 | 0.411 | 0.867 | 0.984 | 1.000 |

The first row is support's power, at 15 of 20. The second is the contradiction's, at 17 of 20, for a learner moving away from the law's end, which the exact expected gradient never does. At one half, a learner with no direction, each row gives the chance of a false verdict at a run: support 0.021, contradiction 0.0013. At five seeds, the design's least, a run is supported only where all five move the law's way (0.031 under a fair coin), and none can be contradicted at 0.05/11. At ten, both verdicts are possible (9 of 10 to support, 10 of 10 to contradict). Twenty is for power: at q = 9/10 a run is supported with chance 0.989 at twenty seeds and 0.736 at ten. The whole table, at 5, 10, 20 and 30 seeds, is in `results/stage0.json`.

**What sets q is not measured here.** The run measures q. Any training to measure it beforehand would be the run, and waits on Ren's yes as the run does. What Stage 0 gives instead samples nothing:
- The reference curve, which a learner follows to first order, ends at the law's end from every start (section 3).
- The first step's signal-to-noise is at least 3.9 at every verdict run with noise.
- At A3 and B4 no step can move away from the law's end.

Near a told learner's maximal plan the gradient and its noise shrink together: a batch all of one plan moves nothing. At an interior best chance they do not. The expected gradient vanishes there while one episode's estimate does not, so the chance keeps fluctuating about the best chance however many steps are taken. Stage 0's linear estimate of that spread is 0.028 on B2's prospects and 0.024 at the witness. The expectation in section 9 rests on these.

## 6. The dry run

[`tr7a_dry_run.py`](told-tr7a/tr7a_dry_run.py) writes [`results/dry-run.json`](told-tr7a/results/dry-run.json) in about three seconds of CPU, through a gate slot. It runs 294 checks, all passed; the record counts them by kind:
- **The game** (36 and 78). `outcome` equals `played` on 500 ids each, draw for draw: the acts, the kept draw and the points. This holds on every plan of every told condition, and on both answers of every tied condition, B2's prospects among them. The tied conditions' acts are drawn from the call's generator as `played` draws them. Every plan's expected points, enumerated over the kept draw, are `tr7.ev`'s. Every chance's are `tr7.ev_fresh`'s and every mixture's `tr7.ev_mixture`'s, enumerated over every act and draw. The chances are 1/20, 1/2, 9/10, 7/20 and 1/8, on each tied condition's prospects and the witness's.
- **The estimator** (17 and 4). At every run's start, 200 batches are drawn and none applied. The batches' mean is the exact gradient within four standard errors in every coordinate; the record's largest gap is under two standard errors. At A3 and B4, from every start, no batch's estimate moves the statistic away from the law's end.
- **The plumbing** (35 and 4). `run_all` runs on a temporary file at a seed outside the frozen ones, every run once, at step size 0 for two steps. The policy stays at its start, and each record has the fields the reading reads, its run's values and its stamp. Then the last line is cut, as a kill would leave it, and `run_all` runs again:
  - the cut line is set aside byte for byte, and that learner alone is trained again;
  - a whole file trains nothing;
  - a record that lost only its newline gets it back;
  - a bad line before the last refuses.
- **Stage 0** (10). The reference ends are `tr7.json`'s at the ten runs both compute.
- **The reading on scripted records** (48, 52 and 10).
  - All twenty seeds the law's way: every verdict run is supported.
  - At each verdict run: 14 of 20 is unresolved, 15 supported, 17 away contradicted. 16 away with the rest unmoved is unresolved, d = 0 counted neither way.
  - A verdict run short of a seed leaves the reading incomplete, before a contradiction elsewhere. A reported run against the law changes no verdict.
  - B3 falling to 0 is supported by d, with no seed within the improving chances.
  - With `stage0.json`: every run's distance from the reference end, the improving chances where the best chance is interior, and the tie's split at A3 and A5 only.
  - The reading refuses each kind of record section 4 lists, in ten cases.
- **Timing.** The CPU an episode on the estimator's batches, by learner, gives the estimate under "What Ren's yes would release".
- **The frozen check's state.** FREEZE-4's check, freeze 1's within it, passes. This folder's cannot pass before its `FROZEN.sha256` is committed, and the record says so. `run` refuses until it passes.
- **The code it ran.** The record names the sha-256 of each file this folder's link lists but the record itself, taken as the dry run starts, and says whether they were the same at its end. `write_frozen.py` writes `FROZEN.sha256` only where those are the files' hashes when it writes, so anyone can check that the result frozen is the frozen code's.

## 7. What changed from the design, and what was chosen

The design ([REST-TR2-TR7](REST-TR2-TR7.md#stage-as-reference-curves)): "Stage A (later, on Ren's yes) trains such learners on sampled outcomes, at least five seeds per condition, so that an exact sign test can reach 0.05; it shows how ties settle by the start, which no verdict reads."
- **Seeds, 20.** At five, a run can be supported but never contradicted at 0.05 split over eleven. At ten, both are possible. Twenty is for power: a learner moving the law's way with chance 0.9 a seed is supported with chance 0.989, against 0.736 at ten.
- **The learners.** The design's "such learners" are the reference curves': a softmax over the plans and a shared chance drawn afresh. B4's draw before the read stage is neither, so a mixture learner, with its own reference flow, takes it.
- **Step size and steps** are the reference flows'. The learners follow, to first order, the curves `tr7.json` reports, and Stage 0 gives the seven it does not.
- **The batch, 100**, averages a step's noise. **The baseline**, leave-one-out, keeps the estimate unbiased and makes the advantages sum to zero in each batch.
- **The statistic** is the movement from the start toward the law's end, the direction the reference curves move for every run. The final policy's nearness to the reference end would need a tolerance no prior computation fixes, so it is reported, not ruled on.
- **The game.** The told learners are played by `played`, the chance and mixture learners by `outcome`, its last lines, since `played` plays only a plan or a declared offer.
- **A5, the tie.** TR7 reads it by contradiction only and never supports it (REST-TR2-TR7, the verdict rules). Here it has a verdict on the pair's share, as A3 has. The question here is whether training moves toward the maximal plans, and at a tie that is the pair, so the reading's support needs A5 too.
- **The reported runs.** `tr7.json`'s reference curves start A3 from a lean to ownThenComply and A5 from a lean to complyThenOwn, B2's prospects from 0.05, 0.5 and 0.9, and the witness from 0.5. Here the ties are run from a lean to each tied plan, and B2's prospects from 1/20 beside B2 (1/2) and B3 (9/10).
- **The frozen scope.** This folder's link lists only its own files, and FREEZE-4's frozen check holds the files Stage A imports. An addendum here may change only the dry run and its record; every other file of this folder is fixed.

## 8. The lessons of earlier freezes, met

From [experiments/README](../README.md#freezing-a-test-on-a-trained-system):
- **A verdict only on a difference the feedback resolves.** The power is exact (section 5), and Stage 0 gives the first step's signal-to-noise at every run.
- **Exploration apart from selection.** A chance learner that stops complying counts the law's way by d at B3 and the witness. So the seeds ending within the improving chances are reported apart, and B2 from 1/2 and from 1/20 read the difference.
- **Each support rule guarded against contradiction.** The reading's support needs every verdict run supported and none contradicted.
- **A reading that refuses a run it was not frozen for.** The records name the frozen link they ran under, and the reading refuses the kinds listed in section 4.
- **Inputs that can meet every rule's minimum.** The run's plan is 20 seeds a run, the count the rules need, and the reading reports a run short of one as incomplete.
- **A shared harness changed only where every freeze reading it still reads its runs.** FREEZE-9 changes no harness. It imports FREEZE-4's and freeze 1's files at FREEZE-4's newest link, and refuses while FREEZE-4's check does. In that case the run can be made in a checkout of this freeze's newest link's commit.
- **Every log line read, and a cut one handled before any work.** Each record is one line of ASCII JSON, written and flushed as its learner ends. `run` sets aside a cut last line before training anything, and the reading refuses one.

## 9. An expectation, stated before any run

[AI expectation. It is not a prediction of the account, and it is not revised after the run.] Every verdict run supported, with all twenty seeds the law's way at every told condition, B1 and B4. At B2 and B3 every seed nearer 7/20 than its start, ending within a few hundredths of 0.35. From uniform, A3's and A5's ties split about evenly across seeds, each seed's split its own. From a lean, the lean's plan ends above the other in nearly every seed at A3, and in most at A5, where the split keeps diffusing once the pair holds the mass. This reads the reference curves with sections 3 and 5. A seed against the law would most likely come from B2's prospects started below the best chance, the lowest signal-to-noise and a reported run.

## 10. Provenance and the reading of the freeze

- Written for board item TR7A on 5 November 2026, from REST-TR2-TR7 and FREEZE-4 §11, which put Stage A out of FREEZE-4 ("Not frozen here: Stage A's training of learners, on Ren's yes later"). At the coordinator's word, the number is FREEZE-9; FREEZE-10 is TR1A, and FREEZE-11 is kept for TR2's Stage A.
- No learner was trained and no model called. The only sampling was the dry run's, which applies no step: its plumbing steps at step size 0.
- An independent reader read the frozen files before the freeze landed, in rounds, until no finding of high or medium severity remained, at most five rounds. The findings, and how each was taken, are in [`told-tr7a/REVIEW-FREEZE.md`](told-tr7a/REVIEW-FREEZE.md). The reader was a Claude Opus subagent, of the theory's own family.
- **How this file is frozen.** By the commit that adds `told-tr7a/FROZEN.sha256`, as FREEZE-4's is: its text there is the frozen one. It is not hashed, so that a link it gives can be repaired if its target moves without touching the code's hashes. A later edit may only repair a link or a typo. It is listed in a dated note at the end of this file and changes no rule, threshold or reading. `write_frozen.py` writes `FROZEN.sha256` last, on the merged tree once every check passes there, and it is committed alone. The writer refuses unless FREEZE-4's frozen check passes, the dry run passed every check with its code unchanged while it ran, and the hashes it recorded are the files' then. A fault found later can be fixed only by an addendum within the scope of section 7, or by a new freeze, since a second commit of `FROZEN.sha256` would make the chain refuse for good.
