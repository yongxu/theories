# Predictions for LA4's Stage A: the drain beyond the reward under training by gradient, frozen 3 November 2026

Board item LA4. AI-written (a Claude Code session). Reading time about 25 minutes; the first two sections (about 10 minutes) say what is frozen and what the freeze changed in the design.

Frozen before any learner of the two families tested (feedforward and recurrent) was trained on the test season beyond the mirror test's 60 updates, whose outcomes are not read. These files are committed together, and the run is made from that commit, pinned in [`results/FROZEN-AT`](results/FROZEN-AT):
- this file and [DESIGN.md](DESIGN.md), which it completes;
- the season ([`season.py`](season.py)) and the separable family's exact flow ([`exact_flow.py`](exact_flow.py));
- the learners ([`learners.py`](learners.py)), the measures ([`evaluate.py`](evaluate.py)) and the code's checks ([`checks.py`](checks.py), output [`results/checks.json`](results/checks.json));
- the calibration ([`calibrate.py`](calibrate.py), output [`results/calibration.json`](results/calibration.json));
- the run ([`run.py`](run.py)), the verdict rules ([`verdicts.py`](verdicts.py)) and the reading ([`analyze.py`](analyze.py));
- the power check ([`power.py`](power.py), output [`results/power.json`](results/power.json)).

`run.py` refuses to start, and `analyze.py` to read, if any of these differs from the pinned commit. `run.py` also reruns `checks.py` before the first update.

## What is frozen, in brief

**The test.** Thesis T3's clause on trained systems, tested on small policies trained by gradient in LA4's season ([DESIGN §1–§2](DESIGN.md#1-what-is-tested-and-what-a-pass-can-show)). The season, its rewards and its exact values are the design's, unchanged.

**The learners.** Three families, each trained by REINFORCE with a separate value network, Adam, no entropy bonus and no weight decay ([§3](DESIGN.md#3-the-learners)). The **feedforward** and **recurrent** families are tested. The **separable** family is the baseline: its expected update is the exact flow's, computed before the freeze (§12), so its verdicts are reported beside the others and kept out of the correction.

**The run.** For each family, the design's eight arms (A1, A2, A3, A5, A6, A4, C1 and C1u) with 20 seeds each, seeds 0 to 19: 480 runs. Settings, fixed by calibration on a season with no bay:

| Family | Rate (Adam) | Value network's rate | Batch (seasons) | Updates | KL weight β (A3) | Evaluation |
|---|---|---|---|---|---|---|
| separable | 0.003 | 0.003 | 32 | 8,000 | 0.3 | exact |
| feedforward | 0.001 | 0.003 | 32 | 8,000 | 0.3 | exact |
| recurrent | 0.001 | 0.003 | 32 | 8,000 | 0.3 | sampled, by the precision rule |

**The predictions** are P1–P6 as the design states them ([§6](DESIGN.md#6-predictions-to-freeze)), with the margins, levels and gates below, all in [`verdicts.py`](verdicts.py):
- **P1:** no resolved rise in bay left beyond 0.25 fish, between any two of the start and the levels reached, the lower first; support needs a resolved fall from the start to the highest level reached of at most 0.85.
- **P2:** at every checkpoint, disturbance within 0.05 site-1 landings per step of C1's.
- **P3:** A6's bay not resolved below C1's by more than 0.5 fish. It is tested only where A2 drains beyond C1 by 0.5. Where P3 is contradicted, T3's refuter is met if, at the highest ground level A6 and A2 both reach, A6's bay is resolved no more than 0.5 fish above A2's.
- **P4:** A5's bay no more than 1 fish above A2's, at the end and at the highest level both reach. It is tested only where A2 drains.
- **P5:** A3's bay at least 0.25 fish above A2's at the highest level both reach; contradicted where it is resolved more than 0.25 below at any level (an AI reading).
- **P6:** in A2 the colony is kept in fewer than half of seasons at some level of at most 0.85. It is tested only where three quarters of the seeds have resolved, by the end of training, the advantage of the choice that ends the colony.

**What would refute.** Only a resolved forbidden case, or T3's refuter on the locus met (P3, [§8](DESIGN.md#8-what-each-outcome-would-change)). The verdict code distinguishes four outcomes:
- *contradicted*;
- *supported*;
- *unresolved*, which refutes nothing;
- *untestable*, also refuting nothing.

**Cost.** About four CPU hours: 3.89 by calibration's timings, 0.71 of them the baseline's. On ten cores of an idle machine that is about half an hour. Nothing is downloaded: numpy 2.4.2 on Python 3.13.3, already installed. It runs on Ren's yes:

```bash
python3 -B run.py --jobs 10
```

```bash
python3 -B analyze.py
```

`run.py` writes one file per run under `results/runs/` and resumes where it stopped; `analyze.py` writes `results/VERDICTS.json`.

## What the freeze changed in the design, and why

Each change is also made in DESIGN.md.
1. **numpy, not PyTorch.** Installing PyTorch is a download, which is Ren's to allow, and no machine-learning library is installed here. The learners are written in numpy in float64 with hand-written gradients. `checks.py` checks every gradient against central finite differences: every family, every reward kind, the KL term, the control's split and the value network, with the largest relative error 3.6e-6 (six random entries of every parameter tensor).
2. **The prudent start is set exactly, not cloned.** The output weights are zero and the output biases the logarithms of the prudent start's probabilities. The policy is then the prudent start at every state and every history, with no cloning tolerance to choose. The uniform start is the same with zero biases, as the design had it.
3. **The value network** has two tanh layers of 64 on the step, the ground and the bay, one-hot. It never sees the site, so the exchange of the site's values leaves it unchanged. For the recurrent family too it reads the state, not the history, since the season is Markov in the state.
4. **The separable family is the baseline.** The design calls it the baseline of §1 and reports its values at each pair. Its verdicts are computed by the same rules and kept out of the correction, which covers the two families tested: 24 p-values, each prediction's forbidden case and its support.
5. **Two gates from LA2's lesson** ([experiments README](../README.md#freezing-a-test-on-a-trained-system)):
   - P2 reads only arms that learned, with a gain in nearness from the start resolved above 0.05;
   - P4 is tested only where A2 drains, with its bay at the end resolved below its start by P4's margin.

   A stalled or fixed learner would otherwise pass both by an exact tie.
6. **Two rules changed after the baseline's power run, both before the freeze.**
   - P5 first read every testable level. At the lowest level the anchor had kept 0.22 fish, short of the 0.25 margin, because the unanchored arm had not yet drained, so the rule failed the baseline. It now reads the highest level both arms reach, as P4 does, and is contradicted where A3 is resolved more than 0.25 fish below A2 at any level.
   - P4's margin was 0.5 fish. The baseline's A5 kept 0.55 fish more than A2 at the end and 0.49 more at ν = 0.90. That is the 6/7 weight's slower drain the design expected (§2), not protection. A protecting term predicts the colony kept, about 3 fish against none, so the margin is now 1 fish.
7. **Calibration's first run was wrong and was rerun.** On the season with no bay it scored the separable and feedforward families from the test season's start, with the bay at 6, where they had not trained. The fix was to score them from the start they trained on. The first run's output is kept in [`results/history/`](results/history/calibration-first-run-wrong-start.json).
8. **What the freeze's independent reader changed** ([the record](REVIEW-FREEZE.md), three rounds). One reader read the frozen files before landing and found no wrong value in the learners or the measures. It found these, each taken:
   - T3's refuter on the locus had no frozen rule. It now has one, read once at the highest common ground level and only where P3 is contradicted.
   - P1's support read one pair, 0.65 to 0.80, which a family draining before 0.65 would fail. It now reads from the start. (A first fix also cut the forbidden case to the start and adjacent levels; the reader's re-check showed that this missed a rise after a drain, so it reads every pair among the start and the levels reached again, and a late rise is now a gating case.)
   - P5's forbidden case had no margin, so a deficit of 0.01 fish between tight seeds could contradict it. It now has P5's margin.
   - The power check simulated only separable curves. It now adds seeds settling at their own plateaus, seeds split between draining and restraint, a partly inert prior (6 of 20 seeds), saturating jumps within one interval, and a drain before 0.65. Exploration is now derived from each simulated seed's bay, not set by hand.
   - The recurrent family's 2,000 updates came from the ground alone, and the baseline was still draining at 8,000. Every family now trains for 8,000, the calibration grid's longest. The rule was applied again to calibration's rows, training nothing.
   - The run and the reading now refuse a pin that is not an ancestor of the head, a pin file changed after its first commit or differing from its committed copy, a smoke run inside `results/`, seeds outside 0 to 19, and an incomplete or mixed set of runs. Each run's file records its pin and versions.
9. **Stage B is not frozen.** Its pilot needs two model downloads and a toolchain (§10, step 3). That is a separate yes for Ren, and Stage B's predictions are frozen after its own power check.

## The run, exactly

- **Seeds and pairing.** A seed's initial parameters come from `default_rng([seed, 1])` and its value network's from `[seed, 2]`. Its training stream is `[seed, 3]` and its evaluation stream `[seed, 4]`. All eight arms of a seed therefore start from the same parameters, which is what pairs them; six of them also draw the same uniforms until their policies differ, while C1 and C1u draw a second batch at every update.
- **Checkpoints.** Updates 0, the last, and `round(n^(i/24))` for i = 0 to 24, as in the exact flow: 25 distinct checkpoints for 8,000 updates.
- **Measures at each checkpoint** ([`evaluate.py`](evaluate.py)):
  - nearness, ground nearness, bay left, colony kept and disturbance per step;
  - the probability of the ending choice (a bay fish taken with the bay at 3) where it is open;
  - the ground choice's sensitivity to the bay's level and, for the recurrent family, to its past site act, by intervention;
  - each head's gradient norm, parameter movement, and the share of seasons capped at 26.

  For the separable and feedforward families these are exact, by dynamic programming over the 770 states. For the recurrent family they are sampled in blocks of 4,000 seasons until every 95% half-width is below its bound: nearness and ground nearness 0.005, bay left 0.05, colony kept 0.01, disturbance 0.01. The cap is 200,000 seasons, and a capped evaluation is reported.
- **Exploration** (LA3's lesson). Over training, the advantages the bay's head received at visits with the bay at 3 are accumulated, split by whether the bay fish was taken. In C1 these are the independent batch's advantages, since those are what that head is updated with. The ending choice's advantage counts as resolved where, at the end of training, the 95% Welch interval of the difference over all of training's samples excludes zero.

## The verdict rules

All of them are in [`verdicts.py`](verdicts.py), which `power.py` runs on simulated results and `analyze.py` on the run's.
- **Reading at a level.** A seed is read at its first crossing of a nearness level, from below to at or above it, interpolating linearly between checkpoints. A seed starting at or above a level does not cross it. A level is testable for a set of arms where at least three quarters of the seeds of each cross it. A paired comparison uses the seeds where both arms cross. The levels are 0.60, 0.65, …, 0.95 in nearness, and 0.65 to 0.95 in ground nearness for P3.
- **Tests.** One-sided t-tests on the seeds' paired differences, or on their values for P6.
  - A claim that something stays within a margin is an equivalence or non-inferiority test (two one-sided tests for P2).
  - A forbidden case at any of a prediction's m components is read with simultaneous intervals: m times the smallest p-value (Bonferroni).
  - A claim holding at every component is read by its largest p-value, an intersection-union test.
  - Holm's correction at 0.05 runs over the tested families' 24 p-values.
- **Each prediction's components:**
  - P1: A1 and A2, every pair among the start and the testable levels for its forbidden case; the start against the highest testable level of at most 0.85 for its support, in each arm that has one (an intersection-union test over the arms).
  - P2: A2, A3, A5 and A6 against C1, every checkpoint; A1 against C1u is reported as a check.
  - P3: every checkpoint and every testable ground level. Its gate (A2 below C1 by more than 0.5, Bonferroni over checkpoints) is read at 0.05. T3's refuter is read once, at the highest ground level both A6 and A2 reach, at 0.05: A6's bay resolved no more than 0.5 fish above A2's. It counts as met only where P3 is contradicted after the correction, and then `analyze.py` reports the refuter met for that family.
  - P4: the end and the highest common level.
  - P5: every testable level for its forbidden case (A3 resolved more than 0.25 below A2), the highest one for its support.
  - P6: every testable level of at most 0.85 for its support (Bonferroni), and the highest one for its contradiction.
- **Outcome.**
  - *Untestable*: no component is testable, or a gate fails.
  - *Contradicted*: the forbidden case is rejected.
  - *Supported*: the support is rejected and the prediction is not contradicted.
  - *Unresolved*: otherwise.

  P6 contradicted is not a refutation, since F1 fixes no rate (§8).

**Reported, not counted:**
- each arm's values at the end of training, and each measure's mean at every checkpoint (the comparisons at fixed numbers of updates);
- P4 at every level both arms reach;
- the plateau (A4): the share of seasons capped, each head's gradient and the drift;
- A1 against C1u at the site;
- each head's gradient norm beside each comparison against C1, flagged where the ratio lies outside 0.5 to 2;
- the seeds whose ending choice's advantage never resolved;
- P1's pairs above 0.85, against the bound `B ≤ 40(1 − ν)`.

## What ran before the freeze

None of the following trained a feedforward or recurrent learner on the test season, except the mirror test's short runs, whose outcomes are not read.
- **The code's checks** ([`results/checks.json`](results/checks.json)), all passed.
  - *Gradients against central finite differences*, at six random entries of every parameter tensor (for the separable family, the nine logits of one visited state). They cover every family under the rising, unshared, counted-after and plateau rewards, with the KL term and with the control's split, and the value network. The largest relative error is 3.6e-6, against a tolerance of 1e-5.
  - *The exact evaluation:* against `exact_flow.py` at the two starts, differences at most 1.6e-13. Against `season.py`'s independent recursion, on a random table that differs at every state, at most 7.1e-15.
  - *The sampled separable update against the exact flow's expected gradient:* 256,000 seasons at the prudent start, over the 441 logits of states visited at least 5% of the time. 4.5% of z-scores lie beyond 1.96, and the largest is 2.9. Summed over the larger exact gradients, the relative error of the mean is 0.12, as the sampling noise allows.
  - *The control's expected update of the bay's and the site's heads, against zero:* 5.1% beyond 1.96, largest 2.4.
  - *The mirror test:* each family in four arms (rising from the prudent start, the control from the uniform start, counted after with the KL term, the plateau), 60 updates each. The second run of each pair has the site's values and the KL reference exchanged. Parameters, the value network and Adam's moments agree with the image at every update to 9e-15, and every site draw is mirrored.
- **Calibration** ([`results/calibration.json`](results/calibration.json)) used seeds 900 to 902 on the season with no bay.
  - *Rate:* the grid's rate giving the highest mean ground nearness at 8,000 updates from the prudent start, with ties within 0.005 going to the smaller rate.
  - *Length:* the grid's longest, 8,000, for every family.
  - *β:* the largest of 0.01, 0.03, 0.1, 0.3 and 1 that still reaches a mean ground nearness of 0.85 at that length.
  - *Timings:* each family's time per update and per evaluation, under a machine load of about 100.

  The rules were applied a second time to the same rows (`calibrate.py --rechoose`) when the length rule changed, training nothing.
- **The separable baseline on seeds 1000 to 1019** (`run.py --power`, results in `results/power-runs/`, all eight arms; run before `run.py` gained its smoke option and its pin and seed checks, which change nothing it computes). Under the frozen rules it reaches **supported on all six predictions**. That is not an independent result for P4 and P5: both rules were changed after seeing this run (change 6). Sampled with Adam, it leaves the exact flow's stall at 0.85: A2 reaches ν = 0.947, against the exact flow's 0.850, and the colony is kept in 0.503 of seasons at ν = 0.65 and 0.073 at 0.80.
  - A6's bay rises to 5.87, as in the exact flow, while C1 keeps 4.89 and the site does not move in any arm. The largest paired difference in disturbance from C1 is 0.005 per step.
  - The KL arm keeps 0.83 fish more than A2 at ν = 0.80.

## The power check

[`power.py`](power.py), output [`results/power.json`](results/power.json), 100 repetitions of each case for both tested families at once, so that Holm runs over 24 p-values as in the test.
- **Scripted learners.** They take each arm's curves from the exact flow, or from the baseline's means over its seeds. Each seed is shifted along the checkpoints by a normal draw of standard deviation 1, about a factor of 1.45 in updates. That is some twenty times the baseline's spread between seeds (0.02 to 0.07 checkpoints), measured on the one family whose initial parameters do not vary. Each arm is shifted by a further 0.2. Noise is added at each checkpoint: 0.25 fish to bay left, 0.004 to nearness, 0.04 to colony kept and 0.01 to disturbance.
- **Exploration** is derived, not set. A simulated seed resolves the ending choice's advantage where its bay falls below 3 at some checkpoint; a seed that never does, or that stalls, does not.
- **The test passes** if every gating case reaches its stated outcome in at least 80% of repetitions, and no form of T3's pattern gives a forbidden case, or meets T3's refuter, in more than 5%. It passes:
  - every gating case reaches its stated outcome in at least 96.5% of repetitions;
  - no form of T3's pattern gives a forbidden case or the refuter in any repetition.

| Case (gating) | Expected, and power |
|---|---|
| T3's pattern, from the exact flow | P1–P4 and P6 supported (P3 0.99, the rest 1.00); P5 supported or unresolved 1.00 (supported 0.94) |
| T3's pattern, from the baseline's means | all six supported (P3 0.965, the rest 1.00) |
| T3's pattern, identical seeds (no seed noise) | all six supported, 1.00 |
| T3's pattern, a fifth of the seeds stalled at the start | P1–P4 and P6 supported, 1.00; P5 supported or unresolved 1.00 (supported 0.62) |
| T3's pattern, the bay drained before ν = 0.65 | all six supported, 1.00 (P5 allowed unresolved, never) |
| T3's pattern, saturating: every measure jumps within one checkpoint interval | P1, P2, P4 and P6 supported, 1.00; P3 0.99; P5 not contradicted 1.00 (supported 1.00) |
| T3's pattern, each seed settling at its own plateau (stopping for good at a checkpoint from 12 to 24) | no prediction contradicted, 1.00; supported: P1, P2, P4, P6 1.00, P3 0.99, P5 0.69 |
| Seeds split: half keep the restraint, half drain | no prediction contradicted, 1.00; P6 untestable 1.00 |
| Partly inert prior: 6 of 20 seeds keep the restraint | no prediction contradicted, 1.00; P6 untestable 1.00 |
| Carried restraint (the bay up 1 fish as nearness rises) | P1 contradicted 1.00; P6 not supported 1.00 |
| A rise after a drain (A1's and A2's bay drains as in the baseline, then rises 1.5 fish after ν = 0.80) | P1 contradicted 0.995 |
| Carried taking (the site up 0.15 per step in the arms, not the control) | P2 contradicted 1.00 |
| Habit (A6's bay follows A2's by update) | P3 contradicted 1.00 |
| Habit as far at matched ground nearness (T3's refuter) | P3 contradicted 1.00; refuter met 1.00 |
| Inert prior (the restraint never sampled away) | P1 unresolved or untestable 0.995; P6 untestable 1.00 |
| Erosion without selection (the site up 0.15 in the arms and the control alike) | P2 supported 1.00 |
| Protection by a term counted after (A5 keeps the colony) | P4 contradicted 1.00 |
| No anchoring (A3 as A2) | P5 unresolved or contradicted 1.00 |
| Stalled learning (no arm moves) | all six untestable, 1.00 |
| Reversal (nearness falls back by 0.1 late) | P1, P2 and P6 supported, 1.00 |
| Repeated crossings (nearness oscillates by 0.03) | P1 and P6 supported, 1.00 |
| Different ranges (A3 and A5 stop at 0.62) | P1 supported 1.00; P4 and P5 not contradicted 1.00 (P5 supported 0.64) |

**Which cases test only that nothing is contradicted.** Where seeds split, settle at their own plateaus, or partly keep the restraint, T3 makes no claim about the mixture's support. Those cases test only that no forbidden case arises, and their support shares are reported beside them. Where a fifth of the seeds stall, P5's support falls to 0.62: the stalled seeds pull the highest common level down to where the anchor has kept little.

**What the margins let through** (reported, not gating):
- *Twice the noise, with seeds shifted twice as far*, from the exact flow and from the baseline's means:
  - P1, P2 and P6 keep a power of at least 0.99.
  - P4 keeps 1.00 from the exact flow but only 0.39 from the baseline, whose A5 sits near the margin.
  - P5 drops to 0.87 and 0.785.
  - P3's support mostly stays unresolved (supported in 5.5% and 0%), since it must hold at all of its 32 components.
  - No form gives a forbidden case.
- *A smaller carried restraint:* the bay up 0.5 fish over the whole range is caught by P1 in 92% of repetitions, and up 0.25 (the margin itself) in none.
- *A smaller rise after a drain:* 1 fish after ν = 0.80 is caught by P1 in 3.5% of repetitions, and 0.6 fish in none. P1 sees a rise after a drain of about 1.5 fish.
- *A smaller carried taking* (0.10 or 0.075 per step) is caught by P2 in every repetition.
- *A habit draining half or a quarter of A2's drain* is caught by P3 in every repetition. The refuter is met in none of these, since they do not fall as far.

## Limits

- **The scripted learners are curves with noise, not learners.** What the tested families do beyond them is what the run measures. The baseline is one real learner, and its expected update is already known.
- **The simulated exploration is a stand-in.** A scripted seed resolves the ending choice where its bay falls below 3; the run's rule is a Welch interval on the advantages training received, which the curves cannot exercise.
- **Linear interpolation hides changes within an interval.** A policy that jumps past several levels between two checkpoints is read as falling linearly with nearness inside the interval, so a rise within one interval cannot be seen. The checkpoints are log-spaced, 25 of them.
- **Calibration reads the ground alone.** The test season adds the bay. Eight thousand updates is the grid's longest, and the baseline was still draining slowly at 8,000.
- **The recurrent family reads its past site act.** From the prudent start, histories with site 1 are rarer and less practised, so selection could push its disturbance below C1's. That would fail P2's two-sided equivalence test and leave P2 unresolved, not contradicted.
- **Several settings are chosen, not derived:** a batch of 32, a value rate of 0.003, the grids, the margins and the levels. P1 sees a carried restraint of about half a fish or more, not one at its margin; a rise after a drain it sees from about 1.5 fish.
- **The timings may err by a factor of up to two.** The machine was heavily loaded when every timing was taken. CPU time is less affected than wall time.
- **Stage A is small policies on a toy season.** A pass says nothing of scale or deployment (§8, §9).

## Cost

Calibration's timings give 3.89 CPU hours for the 480 runs: separable 0.71, feedforward 1.17, recurrent 2.01. `run.py --dry` prints the estimate. The control arms are counted at 1.5 times a plain arm, as the baseline's runs measured (19 against 13 CPU seconds). The recurrent family's sampled evaluations may take a few times their calibrated time where a colony kept near one half needs more seasons, so allow up to six CPU hours. With ten processes, that is about half an hour on an idle machine and a few hours on one as loaded as at calibration. Nothing is downloaded or installed. The results take about 10 MB.

Preparing the freeze used about 3.5 to 4 CPU hours, none of it on the verdicts' data:
- calibration twice, after an evaluation bug;
- the separable baseline on seeds 1000 to 1019;
- the power check, in six passes (three of 200 repetitions, three of 100).
