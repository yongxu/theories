# MQ4: a state of level and recent giving in the field. Frozen 20 October 2026

Board item MQ4. AI-written. This file, [`mq4.py`](mq4.py), [`dev_mq4.py`](dev_mq4.py), the presence-only layout ([`results/mq4/layout.json`](results/mq4/layout.json)), the development on MQ3's stocks ([`results/mq4/development.json`](results/mq4/development.json), [`results/mq4/development-models.json`](results/mq4/development-models.json)) and the dry runs ([`results/mq4/dry-runs.json`](results/mq4/dry-runs.json)) are committed before any value of the test stocks is read. The verdicts are kept whatever they are.

## The question

MQ3 (study §272) read `Becoming.RegimeMargin.step` in 113 assessed fish stocks and failed every frozen verdict. Giving persisted beyond what the level gives (residual lag-1 autocorrelation 0.55), and the theory's frozen-rest reading, with giving held at its last value, forecast better than the regime margin at one and five years. MQ4 asks what state does predict there: is a condition's state its level plus its recent giving?

## The state in the theory's terms

- **The regime's step** (RM1, §270): x ↦ (x − H) + g(x − H). The state is the level alone, and giving is read off what is left.
- **The frozen rest** (`Flow.WithheldLevels`, read as a forecast): every other exchange is held as it was, giving included.
- **The state tested here** has two variables, the level x and the giving γ just observed. Under a draw H, with E = x − H left:

  γ′ = φ γ + (1 − φ) g(E),  x′ = E + γ′.

  - φ = 1 is the frozen rest and φ = 0 the regime's step, so the two readings the theory already has are the two ends of one law.
  - Giving closes a share 1 − φ of its gap to the level's giving law each year.
  - One φ for every stock, chosen on MQ3's stocks and frozen: **φ = 0.96**, a half-life of about 17 years.
  - At a fixed point γ = H and g(E) = H, which is RM1's regime point. So this state keeps RM1's long-run point and changes only the approach to it. Under it, the point of no return is a boundary in the plane of level and giving, not a single level. This is elementary and not a Lean result; MQ4 is empirical and adds no Lean.
- **The frozen-rest margin's time to break.** Law (2) is "time to break = margin / total net draw". Read as a forecast, it holds every exchange as it is at the origin: the catch C_{t0} and the giving SP_{t0−1}.
  - The level then falls by the net draw D = C_{t0} − SP_{t0−1} a year.
  - A break is a fall below half the origin's level. The margin above the break, TB_{t0}/2, is spent in n̂ = TB_{t0} / (2D) years.
  - The threshold of half within ten years corresponds to the IUCN Red List's criterion A (a decline of at least 50% over ten years or three generations). That is a correspondence, not a claim of equivalence.

## Data and what has been seen

- **Source.** RAM Legacy Stock Assessment Database v4.66, assessment data only: Zenodo record 14043031, CC-BY-4.0, archive `RAMLDB v4.66.zip`, md5 `ed6d7cd3f7da1fdcbc60015c3d65014b`.
  - The archive was copied from the MQ3 session's scratchpad and its md5 matched, so nothing new was downloaded; it is covered by Ren's approval of 20 October 2026.
  - It is extracted outside the repository. Files are read with `python3 -I` from outside their directories.
- **The test stocks: stocks no analysis has read.**
  - They are current stocks (the `stock` table's state is `Current`), none of them among MQ3's 256. Each stock's most recent assessment lacks TB or catch in tonnes.
  - Each is read from the latest earlier assessment of the same stock that has both. "Latest" is by the end of the assessment's year range; ties go to the longer run, then the assessid.
  - That gives 215 stocks. By presence, 184 have at least 25 SP years: 79 primary, 11 control and 94 other (92 of them with method `Unknown`).
  - 55 assessments of deprecated stocks are skipped. A deprecated stockid is a definition RAM no longer uses (for example PCODBSAI, Pacific cod in the Bering Sea and Aleutian Islands). It can overlap current stocks, some of them MQ3's.
- **Read before the freeze:**
  - the database documents (as MQ3) and the workbook's sheet names and dimensions;
  - the `tsmetrics` table in full (definitions of series types; no stock values);
  - the header of `timeseries_values_views`;
  - the `stock` table in full (ids, names, areas, regions, state);
  - the `assessment` table's ids, stocks, year ranges, methods and most-recent flags (its notes were not displayed);
  - the presence and years of TB, catch, SSB, survey, ER, F, TN and recruitment series for every assessment (no values);
  - the values of MQ3's stocks, already read in MQ3, for development.
- **Parsed in memory, never kept, printed or analysed.** Before `mq4.py` existed, MQ3's own loader (`mq3.load`) was run once in this session to load MQ3's stocks for development.
  - As in MQ3's run, it parsed in memory the TB and catch values of every most-recent assessment that carries either, and kept only MQ3's eligible stocks.
  - For 177 of the 184 test stocks, the most recent assessment carries a TB or a catch series in tonnes (mostly catch). Their recent values were parsed in that run and dropped.
  - The earlier assessments that MQ4 reads were never parsed.
  - `mq4.py dev` reads MQ3's assessments only.
  - MQ3's short stocks (24 primary, 9 control and 33 other) were parsed by MQ3's loader and never analysed. MQ4 does not use them.
- **Not read:** any value of the test stocks' assessments. No stock summary PDF or plot was opened.

## Development on MQ3's stocks (already read; not a test)

The classes compared ([`dev_mq4.py`](dev_mq4.py)) forecast TB from the state at the origin with the actual catches, on MQ3's split. Pooled direction accuracy / median |log error|, primary group:

| Class | 1 year | 5 years | 8 years |
|---|---|---|---|
| FR, frozen rest | 0.769 / 0.026 | 0.681 / 0.192 | 0.634 / 0.329 |
| RM, regime margin | 0.641 / 0.070 | 0.619 / 0.304 | 0.609 / 0.452 |
| FR2, mean of the last two givings | 0.755 / 0.031 | 0.670 / 0.192 | 0.627 / 0.315 |
| RATE, giving per unit left held | 0.769 / 0.030 | 0.690 / 0.265 | 0.652 / 0.534 |
| M6, the level law's change, anomaly held | 0.766 / 0.028 | 0.694 / 0.202 | 0.650 / 0.341 |
| P4 φ = 0.42, MQ3's post-hoc reading | 0.715 / 0.046 | 0.630 / 0.275 | 0.611 / 0.428 |
| MR φ = 0.9, relaxing to the mean, no level | 0.772 / 0.028 | 0.674 / 0.203 | 0.652 / 0.365 |
| **LG φ = 0.96, relaxing to the level law** | 0.772 / 0.026 | 0.690 / 0.184 | 0.646 / 0.311 |

- **Why LG.** It nests the theory's two readings with one parameter, and it is the only class here no worse than FR in both direction and error at five and eight years.
- **How φ was chosen.** The criterion was the least pooled median |log error| at five years over all 187 MQ3 stocks, on a grid from 0.80 to 0.99. It gives 0.96 (`mq4.py dev` recomputes it and stops if it differs from the frozen value).
- **The persistence fitted in sample is lower.** One-step regressions within the training years give a pooled 0.14 and a per-stock median of 0.42: inside the years it is fitted on, the level law takes up giving that, out of sample, persists. That is what a giving law that moves looks like.

The frozen rules on MQ3's stocks (`mq4.py dev`):

| Rule | Primary (113) | Control (22) | Other (52) |
|---|---|---|---|
| G1 recent giving needed (median excess) | passed (0.37) | passed (0.28) | passed (0.41) |
| G2 the level needed (stocks detected) | passed (58/113) | passed (10/22) | passed (25/52) |
| G3 nothing more needed (median excess) | **failed** (0.13) | passed (0.04) | **failed** (0.12) |
| F1b one year, error | passed (0.026 = 0.026; 91 of 113 stocks better) | failed | passed |
| F5a five years, direction | passed (0.690 vs FR 0.681, RM 0.619, MO 0.611) | failed | passed |
| F5b five years, error | passed (0.184 vs 0.192, 0.304, RW 0.192; 84 of 113) | failed | passed |
| F10a ten years, direction | passed (0.623 vs 0.615, 0.617, 0.539) | failed | passed |
| F10b ten years, error | **failed** (0.376 vs FR 0.389 but RW 0.286) | failed | failed |
| T1 time to break ranks the risk | passed (0.41, 0.25, 0.18, 0.06) | passed | passed |
| T2 half of n̂ ≤ 5 break within ten years | **failed** (107/264 = 0.41) | passed (0.53) | passed (0.55) |
| R1 MQ3's finding | passed | passed | passed |
| R2 MQ3's F4 | passed (76/113) | failed (16/22, p = 0.052) | passed (36/52) |

## Fixed choices

- **Series, years, exclusions, split, giving law, floor.** As MQ3:
  - TB is `TB-MT`, else `TB-E03MT` × 10³. Catch is `TC-MT`, `TC-E03MT` × 10³, else landings `TL-MT`, `TL-E03MT` × 10³, `TL-E06MT` × 10⁶.
  - Years are the longest consecutive run with TB > 0 and catch ≥ 0, with at least 25 SP years.
  - A stock is excluded if more than 10% of its SP years have E ≤ 0.
  - Training is the first 60% of SP years. g(E) = aE + bE² through the origin is fitted on training, in units of the largest training TB.
  - Log errors floor forecasts at 1% of that TB.
- **The assessment.** As stated under the test stocks above.
- **Groups.** As MQ3: *primary* (statistical catch-at-age and catch-at-length models, integrated analysis, VPA), *control* (biomass dynamics models) and *other*. Verdicts are on the primary group; control and other are reported.
- **φ = 0.96.** Horizons 1, 5 and 10 years.
- **Origins.** As MQ3: test years t0 with t0 − k, t0 − 1 and t0 + k in the run and no year with E ≤ 0 from t0 − 1 to t0 + k − 1.

## Rules (all in `mq4.py test`; each verdict on the primary group)

- **G1, recent giving is part of the state** (MQ3's F0 turned around).
  - Within each stock, over all SP years with t − 1 and t − 2 in the run, the level law SP_t on E_t and E_t² (scaled) is extended by SP_{t−1}.
  - The excess reduction is the share of the residual sum of squares removed, less the chance level q / (n − p).
  - Passed if the median over stocks is ≥ 0.10.
- **G2, the level is part of the state given recent giving.**
  - Within each stock, SP_t on SP_{t−1} and a constant is extended by E_t and E_t². The test is the F test for the two added columns (p < 0.05).
  - Passed if the test fires in at least 20% of the stocks, and in more than chance allows (one-sided binomial test against 0.05, p < 0.001).
  - The median excess reduction is reported.
- **G3, nothing more is needed** (MQ1's D1 and MQ3's F0, for the two-variable state).
  - SP_t on E_t, E_t² and SP_{t−1} is extended by SP_{t−2}, E_{t−1} and E_{t−1}².
  - Passed if the median excess reduction is < 0.10.
- **F1, F5, F10, the state as a forecast.** LG, FR and RM forecast TB_{t0+k} from TB_{t0} and SP_{t0−1} with the actual catches.
  - **Fa** (five and ten years; one year reported only): LG's pooled direction accuracy is above FR's, RM's and momentum's (the sign of TB_{t0} − TB_{t0−k}).
  - **Fb**: LG's pooled median |log error| is below FR's, RM's and persistence's (TB_{t0+k} = TB_{t0}), and LG's mean |log error| is below FR's in more stocks than not, with a two-sided sign test p < 0.05.
  - Each is testable with at least 100 origins from at least 10 stocks.
- **T1, T2, the frozen-rest margin's time to break.**
  - Origins: test years t0 with t0 − 1 in the run and neither t0 nor t0 − 1 with E ≤ 0.
  - Observed: whether TB falls below TB_{t0}/2 within ten years. Origins whose run ends earlier without a fall are censored and dropped.
  - Predicted, for D > 0: n̂ = TB_{t0} / (2D), placed in the classes (0, 5], (5, 10], (10, 20] and above 20 years.
  - **T1**: the share breaking within ten years falls strictly across the four classes.
  - **T2**: at least half of the origins with n̂ ≤ 5 break within ten years.
  - Testable with at least 20 origins from at least 5 stocks in every class.
  - Reported: the class D ≤ 0, and the same call (a break within ten years under the held catch C_{t0}) made by FR, LG and RM.
- **R1, MQ3's finding on new stocks.** The frozen rest calls the direction better than the regime margin, and has the smaller median |log error|, at one and at five years.
- **R2, MQ3's F4 on new stocks.**
  - Per stock, the residual of SP from g fitted on all years is regressed on the mean exploitation rate C/TB of the three previous years.
  - Passed if the slope is positive in more stocks than not, with a two-sided sign test p < 0.05.
- **Reported, not verdicts:** every rule on the control and other groups; MQ3's rules F0-F4 on all groups (`mq3.run_rules`); one year's direction.

## Dry runs (synthetic stocks; `mq4.py dry`, seed 20261021)

There are five generators of 150 stocks each, over 60 years. Each has Schaefer giving r E (1 − E/K) with K = 10⁵ t, and held catches reset every 3-6 years as in MQ3:
- **level**: giving read off the level, lognormal noise 0.2;
- **regimes**: log r a random walk with steps 0.15;
- **lag**: giving read off the escapement two years before;
- **relaxing**: the hypothesis, SP_t = 0.9 SP_{t−1} + 0.1 g(E_t), with lognormal noise 0.1;
- **drifting**: giving a random walk of its own, not read off the level.

| Generator | Eligible | G1 | G2 | G3 | F1b | F5a | F5b | F10a | F10b | T1, T2 | R1 | R2 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| level | 36 | **failed** (−0.02) | passed (36/36) | passed | failed | failed | failed | failed | failed | failed, passed | failed | failed |
| regimes | 44 | passed (0.11) | passed (39/44) | **failed** (0.17) | passed | failed | failed | failed | failed | failed, passed | failed | passed |
| lag | 39 | passed (0.30) | passed (22/39) | **failed** (0.26) | passed | failed | failed | failed | failed | failed, passed | failed | passed |
| **relaxing** | 35 | passed (0.83) | passed (17/35) | passed (0.01) | passed | passed | passed | passed | passed | not testable | passed | passed |
| drifting | 42 | passed (0.94) | **failed** (2/42) | passed | failed | failed | failed | failed | failed | not testable | passed | passed |

- **Every verdict passes only where the state is level plus recent giving.** Where giving is read off the level alone, G1 and the forecasts fail. Where it drifts with no level, G2 and the forecasts fail. Where more history matters (a lag, a random-walk productivity), G3 fails.
- **The time-to-break rules have no synthetic pass.** In these generators the catch is reset every 3-6 years, so it is rarely held for ten years, and T1 fails or cannot be tested. On MQ3's stocks T1 passes, so the rule can pass on field data.
- **Two rules were changed after the first dry run, before any test value was read.** That run showed both failing on the generator that is the hypothesis:
  - G2 had been "the median excess reduction ≥ 0.10". A slow pull toward the level law (0.1 a year) adds little one-step variance, so the bound missed it; the detection test fires at the nominal 5% under drifting and in 49% of stocks under relaxing.
  - One year's direction (F1a) had been a verdict. It is now reported only.

## What the verdicts would mean

- **G1-G3, F5 and F10 all passing:** in assessed stocks the state is the level plus the recent giving. Giving relaxes toward the regime's level law at about 4% a year. RM1's regime point is the long-run point, the frozen rest is the short run, and the margin is a state quantity of the pair.
- **G3 failing:** more than the level and the last giving is needed (an age structure, a lag), so the state is larger than two variables.
- **G2 failing, or F5 and F10 failing while G1 passes:** the level adds no detectable information beyond the recent giving. Giving drifts on its own, as in the drifting generator, and the regime's level law has no content in these data at these horizons.
- **F10b failing only through persistence:** at ten years no forecast from the state beats "the level stays where it is". Over a decade the catch responds to the stock (management), and no reading with the draw held or given includes that.
- **T1 passing and T2 failing:** the frozen-rest margin over the net draw ranks the risk of a break, but it is not a calibrated time to break, because the draw and the giving respond.
- **R1 and R2:** whether MQ3's finding and its descriptive F4 hold on stocks MQ3 never read.

## Expectations before the run (from the development; not rules)

These are expectations, not rules: G1 passes; G2 passes; G3 fails in the primary group; F1b passes; F5a and F5b pass narrowly or fail by noise; F10a is open; F10b fails through persistence; T1 passes; T2 fails; R1 passes; R2 is open.

## Literature (closest prior results; from memory, not checked against the texts)

- **Productivity that moves in assessed stocks:**
  - productivity regime shifts are common and often dominate biomass-driven production (Vert-pre, Amoroso, Jensen and Hilborn 2013, *PNAS*);
  - recruitment capacity changes over time in many stocks (Britten, Dowd and Worm 2016, *PNAS*);
  - a meta-analysis of recruitment dynamics finds autocorrelation and regimes common (Szuwalski, Vert-pre, Punt, Branch and Hilborn 2015, *Fish and Fisheries*).
- **Surplus production and its observed form:** Hilborn and Walters, *Quantitative Fisheries Stock Assessment* (1992); errors in biomass shared by SP_t and E_t bias density dependence (Walters' time-series bias).
- **RAM Legacy:** Ricard, Minto, Jensen and Baum (2012), *Fish and Fisheries*.
- **A 50% decline within ten years or three generations:** IUCN Red List criterion A.
- **Partial adjustment** (a state relaxing toward a target at a fixed rate) is a standard model class in econometrics and population dynamics. What is tested is not the class but whether the theory's two readings, as its ends, describe field data no analysis has read.
