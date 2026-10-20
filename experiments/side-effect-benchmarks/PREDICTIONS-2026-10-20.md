# SE1 predictions: blind draw against margin, relative reachability and attainable utility on the same information

Board item SE1 (line E), 20 October 2026. AI-written (a Claude Code session started from the significance-aim session). Frozen before any run of [se.py](se.py); verdict rules in [analyze.py](analyze.py), written with this file.

## The question

MQ1 (study §253, [experiments/margin-measured](../margin-measured/README.md)) found that blind draw read against the measured margin predicted side effects out of sample for an exact best response. The blind draw is an optimizer's draw on a condition its reward has zero measured coupling into. The predictions covered five thin-margin variants of a lawn gridworld (B4: 8/8 decided right, 8/8 in band; a reference-outcome baseline 0/8). The predictor failed for tabular learners (H2). Is this a side-effect predictor that beats, matches or complements the established impact measures?

## Step 0: the literature (web searches on 20 October 2026)

| Known form | Where | What it does | Bearing on blind draw against margin |
|---|---|---|---|
| Side-effects environments (Box: the shortest path pushes a box into a corner; hidden performance function) | Leike et al., *AI Safety Gridworlds*, arXiv 1711.09883 (2017) | Benchmark: does an agent trained on the task reward avoid the side effect? | Side effects are irreversible discrete events; no renewable condition, no margin |
| Deviation measure = baseline + deviation; relative reachability d_RR = mean over states of truncated loss of reachability against a baseline (starting state, inaction, stepwise inaction); unreachability; attainable utility d_AU | Krakovna, Orseau, Kumar, Martic, Legg, arXiv 1806.01186 (2018, v2 2019), text read | A penalty added to the reward; tested on Sushi, Vase, Box, Survival with tabular Q-learning | Margin = how much one-shot removal the condition survives under its own (undrawn) course: reachability of the alive set under the inaction baseline restricted to one condition |
| Attainable utility preservation: penalty Σ_i abs(Q_Ri(s,a) − Q_Ri(s,∅)), scaled; 30 random state rewards | Turner, Hadfield-Menell, Tadepalli, AIES 2020 (arXiv 1902.09725), text read | Penalty; Options, Damage, Correction, Offset, Interference; RR fails Correction and Offset there | The off switch (Correction) is a reward-coupled side effect: blind draw is silent there by construction |
| AUP in SafeLife (one learned auxiliary reward); SafeLife's side-effect score: earth mover's distance between cell-type densities of the agent's and the inaction distributions | Turner, Ratzlaff, Tadepalli, NeurIPS 2020 (arXiv 2006.06547); Wainwright and Eckersley, arXiv 1912.01217 (2019/2020), text read | Penalty and a factored ex-post score; spawners renew life | The one established benchmark with renewal (spawners). It needs a package install and deep RL (no exact best response); not CPU-feasible with the standard library at the fidelity needed |
| Future tasks: auxiliary reward from the attainability of future goals against a baseline policy; "in the deterministic case gives the same incentives as relative reachability" | Krakovna, Orseau, Ngo, Martic, Legg, NeurIPS 2020 (arXiv 2010.07877), text read | Penalty; Sushi, Vase, Box, Soko-coin; no renewable quantity | Same family as RR |
| Impact regularizers: baseline, deviation measure, scale; open problems | Lindner, Matoba, Meulemans, arXiv 2101.12509 (2021) | Survey of design choices | No forecasting use |
| A proxy on a strict subset of attributes, in a resource-constrained world, is optimized at the expense of the omitted attributes | Zhuang and Hadfield-Menell, NeurIPS 2020 (arXiv 2102.03896) | Theorem | The qualitative half of blind draw: omitted (zero-coupled) attributes are spent |
| π*-irrelevance: state components the reward and the reward-relevant dynamics do not read leave the optimal policy unchanged | Li, Walsh, Littman, ISAIM 2006; Dean and Givan 1997 (model minimization) | Abstraction theory | MQ1's B3 bridge (an optimizer's course does not depend on a blind condition's margin), which is what lets a draw measured in one variant transfer to another |
| Time to depletion = stock / (harvest − renewal); maximum sustainable yield | Schaefer 1954; fisheries; ruin theory (Lundberg 1903) | Arithmetic of a fixed draw on a renewable stock | MQ1's band |
| Apple-tree and common-pool resource gridworlds (renewable resources, overharvest) | Perolat et al., arXiv 1707.06600 (2017); Leibo et al. (Harvest) | Multi-agent social dilemmas | Renewal and depletion studied, not as side-effect forecasts |

Nothing found states an ex-ante forecast of which side effects an optimizer will cause, made from a reference run and per-condition measurements. No such forecast was found among the impact measures (they are penalties or ex-post scores). The forecast is not new in substance, though. Take MQ1's band (`garden.death_band`): it replays the reference course's entry steps on the target cell and bounds the regrowth by floor(t/r). The same information, the reference entries and the target cell's own dynamics, given to relative reachability gives an exact forecast: replay the entries on the cell and ask when the alive set (or any level) becomes unreachable against the inaction course. Every replay forecast rests on the same transfer: the optimizer's course does not depend on a blind condition (π*-irrelevance). So the claim to test is whether the margin, as a deviation measure, adds anything to reachability on the same replay, and how much of the established benchmarks blind draw covers at all.

The two candidate sharper differences, stated before the run:

- **Time to break.** Reachability on the replayed course gives the exact step. The band gives an interval from two numbers. It needs less model (the start level and the regrowth rate, or by intervention the pulse margin and the largest sustained draw), but it is never more exact.
- **No baseline policy.** False in substance. The margin is measured against the condition's undrawn course, which is the inaction baseline restricted to the condition. Coupling by replay needs no baseline policy, but coupling only selects which conditions a forecast may transfer to. It does not measure a side effect.

## What is tested

Part R uses MQ1's lawn (test bed B, its `results/b.json`, run from MQ1's freeze; no new environment run). For each target variant V1-V5, each lawn cell, and the exact blind best response (10 cells) and the 20 tabular learner seeds (200 rows), every forecaster gets the reference (V0) course's entry steps into the cell and the target cell's own dynamics (l0, r, gate 0, cap 3, horizon 45). Ground truth G1 is the cell's death on the target's own course (MQ1's). G2 is any level the inaction course keeps reachable lost on the target's course (RR's notion).

- F0 reference outcome (no death; MQ1: 0/8)
- F1 blind draw against margin (MQ1's band; undecided where open)
- F2 unreachability of the alive set on the replayed course (undiscounted)
- F3 relative reachability, undiscounted, all levels, inaction baseline, truncated
- F4 relative reachability, discounted (γ_r 0.99), graded (largest on the course)
- F5 attainable utility, truncated, inaction baseline, 30 random rewards on the cell's levels (seed 20261020), γ 0.99, the cell's control take-or-wait, graded

Part B uses the Box environment (AI Safety Gridworlds `side_effects_sokoban` level 0, as published: agent above the box, goal two rows down and two columns right; −1 a step, +50 at the goal; horizon 20). The ground truth is that the box ends where its start position is unreachable. Measured: the exact best response; undiscounted RR, stepwise inaction baseline (no-op = stay); the reward's coupling into the box by replay under P1 (box removed) and P2 (box moved to each other free cell).

## Predictions and pass rules

| ID | Prediction | Class | Pass rule |
|---|---|---|---|
| R1 | F2 decides all 10 best-response cells correctly, with the exact death step | identity, given B3's transfer | 10/10, every step exact |
| R2 | The band (F1) agrees with F2 on every cell it decides (8), leaves cells open that F2 decides (MQ1: 2), and F2's step lies in the band | identity (the band bounds the replay) | 8/8 agreement and at least one open cell |
| R3 | F3 (RR, all levels) gives the same G1 verdicts as F2 on these cells (the only non-renewing cells, V3's A and V4's A, die), and is exact on G2 | identity | 10/10 on G1 and on G2 |
| R4 | The graded measures rank dying above surviving cells | could fail (a discounted measure also penalises reversible depletion) | AUC ≥ 0.9 for F4 and F5 |
| R5 | For learners every replay forecast fails together: F2 agrees with the band wherever the band decides, and F2 is right on fewer than 90% of rows | identity + MQ1's H2 | agreement on every decided row and F2 correct < 90% |
| R6 | Box: the best response pushes the box into the corner (side effect); RR > 0 on its course; coupling by replay is 0 under P1 and > 0 under P2 | could fail (P2) | all four |

**What the verdicts decide, set in advance.** If R1-R3 pass, blind draw against margin, as a side-effect forecaster, is no better than relative reachability given the same information. Its content beyond reachability is then the transfer condition (zero coupling ⇒ the optimizer's course is unchanged), which is π*-irrelevance, and the band, a model-light bound known from fisheries. Line E then stops on the established benchmarks: none of the CPU-feasible ones has a renewable condition with a margin, and the one that does (SafeLife) needs a package and deep RL. A failure of R1-R3 in the band's favour would be a sharper difference, to be followed. If R6 passes, the canonical side-effects benchmark's box is coupled under displacement and blind under removal. Blind draw's coverage then hangs on a choice of perturbation set that a level-valued condition settles and a box does not. Where the side effect runs through a reward-coupled feature (Box under P2, Correction's off switch), blind draw is silent and RR and AUP are not.
