# MQ6: the margin's time to break past the fold, in the lab. Frozen 21 October 2026

Board item MQ6. AI-written. This file, [`mq6.py`](mq6.py), the layout ([`results/mq6/layout.json`](results/mq6/layout.json)), the development map ([`results/mq6/development.json`](results/mq6/development.json)) and the dry runs ([`results/mq6/dry-runs.json`](results/mq6/dry-runs.json)) are committed before any value of the new data is read. The test then runs in three stages, each frozen in a commit before the next data are read. Every verdict is kept whatever it is.

## The question

The margin law's central forecast is a time to break: law (2), margin over net draw. It has been measured only where it could not be tested:
- MQ1 tested it on a simulated yeast, where the band held.
- MQ2's test D (the time to break after the draw passes the fold) was not testable, because no run in Dai et al. 2012 passes the fold.
- In 76 assessed fish stocks (MQ4, T1 and T2), the frozen-rest time to break ranks the risk without timing it, because the catch follows the stock and the giving moves (MQ5).

So the field leaves open whether the regime margin times a break where its premises hold: a draw set from outside, and a state that is the level. Dai, Korolev and Gore (2015) drove yeast populations past their fold in two ways, by raising the dilution 10% a day and by lowering the sucrose 20% a day. MQ6 asks whether the regime's step, with an equation of state measured in constant regimes, forecasts those runs and times their breaks better than the frozen rest.

## The reading in the theory's terms

- **Draw.** The daily dilution. On day d the density n_d is read, then the culture is diluted by DF_d into fresh medium with sucrose s_d and grows, n_{d+1} = G_{s_d}(n_d / DF_d).
- **What is left and the giving.** What is left is x = n_d / DF_d; the giving is G(x) − x (`Becoming.RegimeMargin.step`, with the draw a share of the level).
- **The regime's points.** The need is the unstable point of n ↦ G(n / DF), and the level is the stable point. Past the fold no positive point is left, and every level falls (`ends_beyond_giving`).
- **The frozen rest (FR).** The last day's giving, n_{t0} − n_{t0−1} / DF_{t0−1}, is held and the known draw applied (`Flow.WithheldLevels` read as a forecast, as in MQ3 and MQ4).
- **The regime margin (RM).** The map is iterated under the known schedule from the reading at the origin.
- **Two baselines from outside the theory.** RW holds the level; TR continues the last day's ratio.

## Data and what has been seen

- **Source.** Dryad doi:10.5061/dryad.k30v3, CC0-1.0 (read from the Dryad API).
  - Ren approved the download in chat on 21 October 2026. Ren downloaded it in a browser (`doi_10_5061_dryad_k30v3__v20150730.zip`), because Dryad's file links sit behind a bot check that was not automated.
  - All six files match Dryad's published md5: `data_deterioration.zip` f739beab…, `data_SUCbifurcation.zip` d9f631a7…, `data_SUCindicator.zip` fecdb030…, and the three README PDFs 44e7cc2a… (one identical file).
  - The files are extracted outside the repository and read with `python3 -I`.
- **The paper.** Dai, Korolev and Gore (2015), PNAS 112:10056, the MIT open-access copy (`Relation between stability.pdf`), approved by Ren in chat and downloaded by Ren. Its md5 (bf372303…, 2,387,061 bytes) differs from the one DSpace lists (903ec043…), so this may be another copy of the same final published version. It is documentation, not data.
- **Read before the freeze:**
  - the README (layout and file names);
  - the paper in full, including its SI. Table S1 gives the schedules. The SI says the sucrose experiments ran at DF 500, the constant groups at DF 500, and the density was read each day before the transfer;
  - the files' layout: lines and fields per file, and token styles over all files, with no value printed (`layout.json`).
- **Seen in the paper, and so prior knowledge:**
  - Fig. 1 B and F and Fig. S6 show the deteriorating and constant groups' mean and individual trajectories on a log scale.
  - Fig. S1 and Table S1 give the authors' tipping days: day 16 (DF ≈ 1569) under rising dilution, day 20 (sucrose ≈ 0.11%) under falling sucrose. The text places the folds near DF 1600 and sucrose 0.12%.
  - Fig. 2B shows the sucrose bifurcation diagram, with the need rising as sucrose falls.
  - So the timing verdicts are partly anticipated (see the expectations below). The per-population forecasts, the comparison with the frozen rest, the held-out needs and the residual structure are not in the paper.
- **Discrepancies, read from the layout only.**
  - `all_SUC.txt` has 48 rows of 21 values, where the README says 36 populations over 24 days. It does not match the 24-day sucrose protocol, so it is not used.
  - `subset_SUC.txt` has 20 rows of 25 values, read as days 1–25.
  - `all_DF_control.txt` and `subset_DF_control.txt` are not in the README; they are read as the paper's constant group (DF 500, 2% sucrose).
- **Development data (already read in MQ1 and MQ2).** Dai et al. 2012's bifurcation experiment, eight DFs at 2% sucrose (md5 3891af75…, as recorded in MQ1).

## The maps

- **The dilution map** is frozen from development (`mq6.py dev`).
  - Class: MQ2's two-phase class with the low-density rate falling with the draw, gl T = a − β ln(DF / 1000). This is MQ2's post-hoc P2 class (P1 there measured per-capita growth falling with DF), now fitted on all eight DFs of the 2012 data.
  - θ = (4.9433, 0.4841, −8.7859, 0.6367, 0.2687), RMSE 0.20 over 3,356 pairs.
  - Fold at DF 1930, so on the schedule the map's fold is first passed on day 19 (DF 2089). Level at DF 500: 1.661 (10⁵ cells/µl).
  - Reported alongside: MQ2's frozen map (draw-independent, fold DF 2797).
- **The sucrose map** is fitted on the new sucrose bifurcation data, at DF 500.
  - Class: two-phase with a(s) = a₀ + α ln(s / 2) and ln k(s) = ln k₀ + κ ln(s / 2), b and n_c common. The paper says lower sucrose limits both the carrying capacity and the growth at low density.
  - Fit: the censored log residuals of consecutive readings (days 1–6, n_t > f), from five fixed starts (the dilution map at DF 500, without and with sucrose exponents).
  - It extrapolates in two places. Above 2% it is used only from day 7 (s = 2.05%) on. Below 0.16% is where the paper puts the fold.

## Stages

1. **Freeze 1** (this commit): rules, code, layout, development map, dry runs.
2. **`fit-odd`** reads the sucrose bifurcation at the odd levels only (2.0, 0.8, 0.5, 0.3, 0.16%). It writes the fitted map and its needs and levels at the even levels (1.0, 0.6, 0.4, 0.2%), committed as freeze 2 before the even levels are read.
3. **`test-a`** reads the even levels: A1 and A2. It fits the map on all nine levels and writes `fit-all.json`, committed as freeze 3 before any deteriorating or constant population is read.
4. **`test`** reads the deterioration files: T1, T2, C1, L.

## Fixed choices

- **Floor** f = 0.01 (10³ cells/µl, MQ2's).
- **Units** by MQ2's rule (a median more than 1000 times the expected level means cells/µl).
- **Day indexing.** Column d is day d's reading, and the day-d transfer uses Table S1's day-d condition. A reading shifted by one day is reported.
- **Schedules.** DF_d = 500 (d ≤ 4), else 500 × 1.1^(d−4). s_d = 5% (d ≤ 3), else 5 × 0.8^(d−3). DF 500 throughout the sucrose run.
- **Populations.** The authors' subsets (20 each, edge wells excluded by position) are primary: `subset_DF`, `subset_SUC`, `subset_DF_control`. `all_DF` and `all_DF_control` are reported.
- **Origins.**
  - Dilution run: from day 5, the first raised transfer.
  - Sucrose run: from day 7, the first day within the fitted range.
  - Late origins: from the tenth day of deterioration (DF: day 14; sucrose: day 16).

## Rules (all in `mq6.py`)

- **A1, the need separates fates in held-out sucrose regimes** (MQ2's A1 with nutrient as the driver; stage 2).
  - At each even level with a need predicted by the odd-level fit: populations whose day-1 density is above 1.5 û survive, and those below û / 1.5 are going extinct, at least 90% each side. Testable with at least 5 each side.
  - A population survives where its day-6 density is above its day-1 density, or above half the map's level. Fates are read by direction because six days leave populations just below the need declining but above the floor; the dry runs showed the floor reading biased the empirical need low by up to 1.4×. The floor reading is reported.
  - At each even level the map puts past the fold, at least 90% of the populations above the floor on day 1 are lower on day 6 (`ends_beyond_giving`).
  - Passed if passed at every testable level, with at least two tested.
- **A2, the held-out need within a factor 1.5 of the need read from fates** (MQ2's A2).
  - At each even level with a predicted need of at least 1.5 f and mixed fates, by the same reading.
  - Passed at every such level, with at least two.
- **A3 (reported only).** The need read from fates rises as sucrose falls. The paper's Fig. 2B already shows it.
- **T1, the regime margin forecasts the level better than the frozen rest under a worsening regime** (dilution run with the frozen dilution map; sucrose run with the all-nine sucrose map).
  - Score: median |log(max(forecast, f) / max(observed, f))| over origins with n_{t0} > f.
  - **T1a:** every origin, k = 3 and 5. RM below FR, RW and TR at both.
  - **T1b:** late origins, k = 1 and 3. RM below FR, RW and TR at both.
  - k = 1 over every origin, and direction accuracy, are reported.
- **T2, the time to break** (both runs).
  - Each population's free-fall onset is the paper's criterion applied per population: the first day d with n_{d+1} / n_d < 0.5.
  - The predicted onset comes from the map iterated under the schedule from the reading on the first origin day.
  - The two agree if both are none, if both are within 2 days, or if one falls on the last possible day or the day before and the other is none.
  - Passed if they agree in at least 75% of populations. The first day at or below the floor is reported the same way.
  - Reported: the authors' onset (mean ratio < 0.5) and the map's first day past its fold.
- **C1, the regime's level carries across experiments.** The median reading of the constant group (days 5–21) lies within a factor 1.15 of the dilution map's level at DF 500. The bound is 15% because MQ2's P3 found two experiments of the same lab 8–20% apart.
- **L, the level is the state in the lab** (MQ1's D1 and MQ3's F0).
  - On the constant group: the map's one-day log residuals (both readings above 10 f), demeaned within each population, carry less than 0.3 from one day to the next (pooled lag-1 autocorrelation).
  - Testable with at least 50 pairs.
- **Reported:** every rule on the full sets; the shifted reading; MQ2's frozen map on the dilution run.

## Dry runs (`mq6.py dry`, seed 20261021; six synthetic experiments through all three stages)

Each experiment is written in the Dryad layout (sucrose bifurcation, the two deteriorating subsets, the controls), with lognormal noise 0.08 on growth and Poisson sampling at transfer. The generators:
- **hypothesis:** the true maps are the frozen dilution map and a sucrose map S (fold 0.15%);
- **carried anomaly:** giving carries 0.8 of its last anomaly;
- **earlier dilution fold:** β = 1.2, fold DF 1401, passed on day 15;
- **level offset:** carrying capacity 20% lower;
- **sucrose kink within range:** S's exponents 2.5 times steeper below 0.5%;
- **sucrose threshold below the fitted levels:** 3 times steeper below 0.16%.

| Generator | A1 | A2 | T1a-DF | T1b-DF | T2-DF | T1a-SUC | T1b-SUC | T2-SUC | C1 | L |
|---|---|---|---|---|---|---|---|---|---|---|
| hypothesis | passed | passed | passed | passed | passed | passed | passed | passed | passed | passed |
| carried anomaly | passed | **failed** | passed | **failed** | passed | passed | passed | passed | passed | **failed** |
| earlier dilution fold | passed | passed | passed | **failed** | **failed** | passed | passed | passed | passed | passed |
| level offset | passed | passed | passed | passed | passed | passed | passed | passed | **failed** | passed |
| sucrose kink within range | passed | **failed** | passed | passed | passed | passed | passed | passed | passed | passed |
| sucrose threshold below the fitted levels | passed | passed | passed | passed | passed | passed | passed | **failed** | passed | passed |

- **Every verdict passes where the maps are true.** Each other generator fails the rules that read what it changes:
  - a carried anomaly fails L, A2 and T1b (persistence wins at one day);
  - an earlier fold fails T1b and T2 on the dilution run;
  - a level offset fails C1;
  - a kink inside the sucrose range fails A2;
  - a threshold below it fails T2 on the sucrose run.
- **A1 and T1a never fail here.** A1 sorts starts a factor 2 apart, so it is coarse. T1a is weak because RM knows the schedule and the frozen rest does not see the level fall. Their passes say little.
- **Changed after the first dry runs, before any value was read:**
  - T1 was split into every origin and late origins (in the first runs it passed under every generator).
  - T2 was moved from the floor to the free-fall onset (the floor was not reached within the dilution run's 21 days under the frozen map, so T2 passed vacuously).
  - L and A2 were added.
  - A1's fates were read by direction (see A1).
  - The earlier-fold generator was moved from β = 0.8 to β = 1.2, so that its free fall starts before the run ends.

## Expectations before the run (from the paper and the development; not rules)

- **Dilution run: T2 and T1b expected to fail.** The frozen dilution map's fold (DF 1930, first passed on day 19) lies three days past the authors' tipping day (16, DF ≈ 1569). That is what MQ2's P1 found, the 2012 fit overstating renewal near the fold.
- **C1 is open.** Two experiments of the lab differed by 8–20% in MQ2.
- **L is open.** MQ1's D1 passed on the 2012 data.
- **Sucrose run open.** The map must extrapolate below 0.16%, where the paper puts the fold.
- **A1 and A2 are open.**

## What the verdicts would mean

- **T1 and T2 passing on a run:** where the draw is set from outside and the state is the level, the regime margin measured in constant regimes times the break of a changing regime, and the frozen rest does not. The field's failures (MQ3–MQ5) would then be about the field (a larger state, a responding draw), not about the margin of a regime.
- **T2 failing with T1a passing:** the map knows the giving's response to the draw well enough to forecast the decline, but its fold, measured in constant regimes of another experiment, is misplaced. The break is set by the fold, which is the least well measured part of the equation of state.
- **C1 failing:** the regime's level does not carry from one experiment to another at 15%. The equation of state is the experiment's, as MQ2's P3 found.
- **L failing:** even in the lab the level is not the whole state.
- **A1 and A2 passing:** the need of held-out nutrient regimes is predicted by the map fitted on others, as MQ2 found for the draw. Lowered giving raises the need (`lowered_raises`) as a measured equation of state.

## Literature (closest prior results; from memory, not checked against the texts, except the paper itself)

- **The data's source.** Dai, Vorselen, Korolev and Gore (2012), *Science* 336:1175; Dai, Korolev and Gore (2015), *PNAS* 112:10056 (critical slowing down, stability against resilience). MQ6 does not test early-warning indicators.
- **Rate-dependent passage through a fold.** Delayed collapse past a saddle-node; the "ghost" of the fold (Strogatz, *Nonlinear Dynamics and Chaos*, 1994).
- **Extinction in deteriorating environments.** Drake and Griffen (2010), *Nature* 467:456.
- **Harvest thresholds.** Clark (1976); May (1977), *Nature* 269:471.
