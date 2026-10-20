# Blind draw against margin and the established impact measures

Board item SE1 (line E), 20 October 2026. AI-written (a Claude Code session started from the significance-aim session). Study section 262 of [BECOMING-RENEWAL-READING](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#262-blind-draw-against-margin-and-the-established-impact-measures-se1). Literature check: [significance review, "blind draw against margin and the impact measures"](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#side-effect-benchmarks-check).

MQ1 ([experiments/margin-measured](../margin-measured/README.md)) found that an exact best response's blind draw, read against the margin, predicted out of sample which lawn cells die in five thin-margin variants and when (B4: 8/8, 8/8 in band; a reference-outcome baseline 0/8). The blind draw is the draw on a condition the reward has zero measured coupling into. This experiment asks whether that predictor beats, matches or complements relative reachability (Krakovna et al. 2018/2019) and attainable utility (Turner et al. 2020). The answer: **it matches them and adds nothing as a measure.** Given the same information, reachability forecasts every cell exactly where the margin band leaves two open. What made MQ1's forecast work is the transfer it rests on, and that is the known invariance of an optimal policy to state its reward does not read.

| File | What it is |
|---|---|
| [PREDICTIONS-2026-10-20.md](PREDICTIONS-2026-10-20.md) | Step 0 literature table, the reduction stated before the run, forecasters F0-F5, predictions R1-R6 with classes and pass rules, what the verdicts decide. Frozen at `0b158e1b9` |
| [se.py](se.py) | The forecasters on MQ1's lawn (part R) and the Box environment (part B) |
| [analyze.py](analyze.py) | The frozen verdict rules |
| [results/](results/) | `se.json` (every forecast, row by row), `VERDICTS.json`, `FROZEN-AT` |

To reproduce (Python 3, standard library only, about 7 seconds; reads `../margin-measured/results/b.json`):

```bash
python3 se.py && python3 analyze.py
```

## The comparison

Every forecaster gets what MQ1's B4 got. It has the entry steps of the reference (V0) course into a lawn cell, and the target variant's own dynamics of that cell: start level, regrowth period, gate at 0, cap 3, horizon 45. MQ1's band (`garden.death_band`) already replays the reference entries on the target cell; it bounds the regrowth by floor(t/r) instead of running it. Relative reachability on the same replay runs it.

| Forecaster | What it computes |
|---|---|
| F0 reference outcome | what happened in V0 (no death) |
| F1 blind draw against margin | MQ1's band; undecided where open |
| F2 unreachability of the alive set | the entries replayed on the cell; death iff no level ≥ 1 stays reachable |
| F3 relative reachability, undiscounted | mean over the cell's levels of reachability lost against the inaction course (truncated) |
| F4 relative reachability, discounted (γ_r 0.99) | graded: its largest value on the course |
| F5 attainable utility | truncated loss against the inaction course over 30 random rewards on the cell's levels, γ 0.99; graded |

## Verdicts

| Prediction | Class | Verdict |
|---|---|---|
| R1 F2 decides all 10 best-response cells right, with the exact death step | identity given MQ1's B3 | **passed** (10/10, every step exact) |
| R2 the band agrees with F2 wherever it decides, and F2 decides where it does not | identity | **passed** (8/8 agree; the band leaves V1's B and V5's A open, F2 forecasts both survive, correctly; every F2 step lies in the band, at its upper end) |
| R3 RR over all levels gives F2's verdicts on death and is exact on any irreversible loss | identity | **passed** (10/10 and 10/10; on V3's A, which does not renew, RR flags the first take at step 1, five steps before death) |
| R4 graded measures rank dying above surviving cells | could fail | **passed** (AUC 1.0 for discounted RR and for AU; surviving cells 0.007 and 0.175, dying cells 0.25-0.74 and 20.1-29.4) |
| R5 for learners every replay forecast fails together | identity + H2 | **passed** (F2 agrees with the band on all 151 rows the band decides; F2 right on 122/200 = 61%; the reference outcome F0 is right on 120/200; all 78 of F2's errors forecast a death that does not happen) |
| R6 Box: the best response corners the box; RR > 0; coupling by replay 0 with the box removed, > 0 with it displaced | could fail | **passed** (course south, pushing the box into the corner at (3,2), then east, south, south, east to the goal; return 45; the box's start unreachable; stepwise RR 0.45 at the push and 0 after; coupling 0 under removal, 50 under displacement onto the course) |

## What the results say

**The margin band is reachability on a replay, bounded.** Given the reference course and the target cell's dynamics, unreachability of the alive set forecasts every death and every survival exactly (R1). The band agrees wherever it decides and is open on two cells the exact replay settles (R2). Relative reachability as Krakovna et al. define it gives the same verdicts and is exact on its own wider notion of side effect, any lost level (R3). Discounted RR and attainable utility rank the dying cells above the surviving ones without exception (R4). As a deviation measure, the margin adds nothing to reachability. Its one advantage is that it needs less of a model: two numbers per condition, which can be measured by intervention (the pulse margin and the largest sustained draw). That is the stock-and-yield arithmetic of fisheries.

**What carried MQ1's forecast is the transfer, and the transfer is known.** Every replay forecast assumes that the target's course is the reference's. For an exact best response that holds because the reward and the dynamics it reads do not read the lawn: π*-irrelevance (Li, Walsh and Littman 2006), and the qualitative point of Zhuang and Hadfield-Menell (2020) that a proxy optimizer spends what its reward omits. For learners the transfer fails, and it fails for every forecaster at once. Exact replay is right on 61% of rows, the same as forecasting no death at all (60%). Every error is a death forecast for a learner that drew less in the thin variant (R5, MQ1's H2).

**On the established benchmark, blind draw does not settle what it covers.** In Box, the canonical side-effects environment, the box is blind when the perturbation is its removal and coupled when it is moved onto the course (R6). A level-valued renewable condition settles the perturbation set; a box does not. Where a side effect runs through a feature the reward reads (Box under displacement, the off switch in Turner et al.'s Correction), blind draw forecasts nothing. RR and AUP still register it.

**Answer to the question.** Blind draw against margin does not beat relative reachability or attainable utility. Given the same information it matches them where it decides, decides less (2 of 10 cells open), and covers less (silent on reward-coupled side effects). As a forecast it complements them in one respect only. The impact measures are used as penalties and ex-post scores, and none is set up as an ex-ante forecast from a sandbox run. But the forecast is available to any of them once the transfer condition holds, and the transfer condition is known. By the rule frozen in advance, line E stops here. The predictor is shown no better than the known measures. No CPU-feasible established benchmark has a renewable condition with a margin. The one that has renewal, SafeLife's spawners, needs a package install and deep RL agents, which no exact best response reaches; there the transfer would rest on learners, where R5 shows it fails.

## Limits

Part R reuses MQ1's courses (`../margin-measured/results/b.json`) and runs no new environment. Ground truth is the target's own course, so every replay forecast is exact for the best response by construction once B3's transfer holds. R1-R3 and R5 are identities, and what they show is where the predictive content lies, not a new fact. The cell-level reachability and attainable utility give the cell its own control (take one unit or wait) over an unbounded future; they are not computed over the whole gridworld. Part B's Box layout and rewards are those of AI Safety Gridworlds' `side_effects_sokoban` level 0 as published, rebuilt from the description, with the hidden performance function replaced by RR's irreversibility criterion. Sushi, Vase, Survival, Options, Damage, Correction, Offset, Interference and Soko-coin were not rebuilt. Their side effects are discrete and irreversible (margin 0, where blind draw reduces to unreachability on the course) or reward-coupled (where it is silent). The classification is by their published descriptions.
