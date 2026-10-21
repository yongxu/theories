# MQ7: fates on either side of the curve in the plane of level and recent giving, in the field. Frozen 21 October 2026

Board item MQ7. AI-written. The following are all committed and landed on main before any value of the test stocks is read:
- this file;
- [`mq7.py`](mq7.py), [`match_mq7.py`](match_mq7.py), [`dev_mq7.py`](dev_mq7.py) and [`rda_read.py`](rda_read.py);
- the test stocks' matching to the RAM Legacy stocks already read ([`results/mq7/matching.json`](results/mq7/matching.json));
- their presence-only layout ([`results/mq7/layout.json`](results/mq7/layout.json));
- the downloaded files' sizes and checksums ([`results/mq7/data-files.json`](results/mq7/data-files.json));
- the development on the RAM stocks MQ3–MQ5 read ([`results/mq7/development.json`](results/mq7/development.json), [`results/mq7/dev.out`](results/mq7/dev.out));
- the dry runs ([`results/mq7/dry-runs.json`](results/mq7/dry-runs.json), [`results/mq7/dry.out`](results/mq7/dry.out));
- the design checks that chose the comparison and the reading ([`results/mq7/design-checks.json`](results/mq7/design-checks.json), [`results/mq7/design.out`](results/mq7/design.out), [`results/mq7/design-ssb.out`](results/mq7/design-ssb.out)).

The verdicts are kept whatever they are.

## The question

Thesis T2 and the records `threshold-in-the-state-plane` and `regime-point-under-adjusting-giving` leave one prediction untested: **below the regime's point of no return, episodes whose recent giving falls short of the catch fall more often than episodes whose recent giving meets it.**

- **Where it comes from.** MQ3's F3 found that the regime's point did not separate the fates of assessed stocks under a held catch: 63% of the episodes below it fell, against the 80% required (study §272). The thesis reads the point as separating fates on the state, not on the level alone [AI reading, D45].
- **The laws behind that reading.** Under giving that adjusts to what is left e and to the recent giving r by a law A(e, r) rising in both, within a band, the runs that come to rest below the draw are exactly those from levels below a least level for each recent giving (`RegimeMargin.Adjusted.falls_iff_below`, RM4, §301). That level does not rise as the recent giving rises (`Adjusted.threshold_falls`). Below the regime's point, recent giving above the draw can carry a condition across it (`Crossing.crosses`).
- **The null.** Under the regime's step, giving read off the level alone, the threshold is the point H + y at every recent giving (`threshold_regime`), so recent giving changes no fate.

## What the field can read of the theorem

- **The theorem orders where runs come to rest.** A managed stock is not watched to its rest. The field reads the next K = 3 years, as F3 did: an episode falls where its level is lower after K years.
- **So the test is of the reading, not of the theorem.** The theorem holds under its premises. What is tested is that the field's giving is an adjustment of this kind: below the point, the recent giving carries part of the state, and the regime's step with a measured level law does not settle the fates there.
- **The premise.** MQ5's post hoc work (§280) read the field's giving as an adjustment. It rises in the recent giving in 65 of 69 stocks, but in what is left only below the level law's peak (a median 41% of a stock's observed escapements). The order laws apply only where the adjustment rises in both, so every episode here starts on that low side.

## The reading

- **Episode.** A test origin t0 (MQ3's split: the last 40% of a stock's SP years) whose catches over t0 .. t0 + 2 are held, each within a factor 1.25 of their mean C̄ (MQ3's). The draw on the level is H = κ C̄.
- **State.** The level x_t0 and the recent giving r = SP_{t0−1} = x_t0 − x_{t0−1} + κ C_{t0−1}.
- **The regime's point.** TB*(H) = H + y(H), where y(H) is the least escapement whose fitted giving g meets H (MQ3's g: quadratic through the origin, fitted on the first 60% of SP years). An episode is below the point where x_t0 < TB*(H)/1.25, or where g never meets H (beyond giving).
- **Low side.** The escapement at the origin, E_t0 = x_t0 − κ C_t0, is below the peak of g (any escapement, where g rises everywhere).
- **Deficit.** z = g(E_t0)/H, what the level law gives at the origin against the draw: the regime's step's own measure of how far below the point the episode lies.
- **Short** where r < H, the recent giving falling short of the draw; **meets** where r ≥ H.
- **Fate.** The episode falls where x_{t0+3} < x_t0.

**Two readings of level and draw** (MQ3's and MQ5's):
- **TB:** the level is total biomass and the draw the whole catch (κ = 1);
- **SSB:** the level is spawning biomass and the draw a share κ of the catch, fitted per stock on its training years (MQ5's grid, 0 to 2 by 0.05).

**Timing, read before the balance.** MQ5's post hoc work found that half its test stocks (New Zealand's) report spawning biomass after part of the year's catch. Its frozen reading had assumed every series reports the level before the catch. Neither test source states when its level is taken. Stock SMART's series carry no timing, and SAG's summary tables give the stock size but not the share of the catch before it. So each series' timing is read from the series itself.
- **The correction.** A level reported after a share f of the year's draw is x_t = L_t + f κ C_t before it. What the draw leaves is then L_t − (1 − f) κ C_t, and the giving is L_{t+1} − L_t + κ (C_t + f (C_{t+1} − C_t)). Read at the wrong timing, the giving carries a term in next year's change of catch that no state at t gives.
- **The rule.** For each series, f ∈ {0, 0.5, 1} is profiled jointly with κ on the training years, by the least residual of a state's giving law:
  - in the SSB reading, MQ4's state (giving on E_t, E_t², SP_{t−1}; below);
  - in the TB reading, MQ5's state with the lag (with E_{t−1}, E_{t−1}² as well).

  Ties go to the smaller f, then the smaller κ.
- **How well it reads known timings** (development, RAM stocks already read):
  - New Zealand's CASAL series, reported mid-season: 8 of 8 read at f = 0.5 in the TB reading, 17 of 25 read after part of the catch in the SSB reading.
  - Series taken as reported before the catch: 276 of 360 read at f = 0 in the TB reading, 246 of 316 in the SSB reading.
- **On synthetic stocks reported after half or all of the catch:**
  - in the TB reading, 204 of 300 are read at f = 0.5 and 215 of 300 at f = 1;
  - in the SSB reading, 157 of 300 and 295 of 300.
- **The step is imperfect.** It misreads about a fifth of the series taken as before. So the verdicts are also reported with every series read at f = 0, MQ3–MQ5's reading.

## Why the comparison is within a stock and a bin of the deficit

This design was changed after the dry runs, before any test value was read. The checks that chose it are in [`dev_mq7.py`](dev_mq7.py) ([`results/mq7/design-checks.json`](results/mq7/design-checks.json), 300 bootstrap resamples).

- **The first draft and its failure.** The first draft pooled the episodes over stocks, in MQ3's strata of the level: beyond giving, x_t0/TB* < 0.5, and 0.5 to 0.8. Under the regime's step (giving read off the level with lognormal noise 0.2), that draft gave a difference of 0.22 in the TB reading and 0.33 in the SSB reading. The SSB one passed (lower bound 0.02); the TB one did not (−0.08). With the level law fitted on all of a stock's years, the differences were 0.19 and 0.21 (the SSB one passed).
- **Why the null gives a difference there.** Within a coarse band of the level, the recent giving still tracks the level (x_t0 = E_{t0−1} + r). And the fitted level law misplaces the point, so recent giving reveals the stock's true giving near the origin.
- **The design.** Within one stock and one bin of the deficit z (width 0.2; below 0 one bin), both the level and the stock's measured law are the same on both sides of a comparison.
  - Under the null, the difference in the TB reading is then −0.005 on the same stocks.
  - Over 16 runs in the TB reading (the 8 frozen dry runs below and 8 more with seeds 21–24) it lies between −0.14 and 0.05, and every run fails.
  - Bins of 0.1 give the same verdicts: the null 0.02 and 0.03, the hypothesis 0.15 and 0.19. The width 0.2 keeps more strata with both classes.
- **What did not work.** A regression within stock, with the deficit or the regime's own forecast of the episode as covariate instead of bins, left the null at 0.05–0.13, with a lower bound above zero in 6 of 8 forms.

## The reading the verdicts are on

This choice was made in two steps, both before any test value was read.

- **First: TB.** In the SSB reading with κ fitted as MQ5 fitted it (MQ5's state with the lag), the regime's step passed C1 in 3 of 8 runs, and in 4 of 8 with every series at f = 0. Holding the catch over the year before the origin too, which makes the split almost free of κ and of the timing, did not help (3 of 8). The cause: κ is weakly identified (MQ5), and a misread share puts the catch into the level law as read, so the regime's step is no longer a law of the level alone. The TB reading (κ = 1) separated: the null passed C1 in 0 of 16 runs, the hypothesis in 15 of 16. So the verdicts were planned on the TB reading.
- **Then: SSB, with κ and the timing fitted by MQ4's state.** The presence-only layout found no unread primary test stock with total biomass: every one carries spawning biomass (below). A TB verdict would therefore be not testable. So the SSB reading's variants were checked on the same nulls and the hypothesis (`dev_mq7.py ssb`, seeds 21–24). With κ and the timing profiled by MQ4's state (giving on E_t, E_t², SP_{t−1}):
  - the null passes C1 in 0 of 16 runs (the 8 frozen dry runs below and 8 in the design checks) and C2 in 1 of 16;
  - the hypothesis passes C1 in 14 of 16 and C2 in 13 of 16;
  - the hypothesis reported after half or all of the year's catch passes C1 in 6 of 6.
- **The alternatives were worse.** Fitting κ by the level law alone, with the timing read, also kept the null to 1 of 8 but passed C2 under the hypothesis in only 3 of 8. MQ5's state with the lag let the null pass C1 in 3 of 8.
- **So C1 and C2 are verdicts on the primary group in the SSB reading,** with κ and the timing fitted by MQ4's state. The TB, survey and other groups are reported.

## The hypothesis' generator

- **The rate.** Read through the balance in MQ5's development, giving closes about 0.3 of its gap to the draw each year in sample (the same coefficients on MQ5's test stocks).
- **The generator that is the hypothesis:** SP_t = (0.96 SP_{t−1} + 0.04 g(E_t) + 0.29 (E_{t−1} − E_t)) × lognormal noise 0.1, with Schaefer g. By the balance this is 0.67 r + 0.29 H + 0.04 g(E). It rises in the recent giving, and, below g's peak, in what is left.
- **Its draws.** The catch either follows the level (MQ5's draw, `adjusting-law`) or is held and reset every 3–6 years (MQ3's, `adjusting-reset`).
- **MQ5's frozen state.** Its λ = 0.55 was chosen for five-year forecasts, and in its generator giving moves faster toward the draw (0.35 r + 0.55 H). Under it the three-year difference is near zero (TB −0.02, SSB 0.00) and C1 fails. So C1 also tells the in-sample rate from MQ5's forecast rate.

## Development on the RAM stocks MQ3–MQ5 read (already read; not a test)

`mq7.py dev`, the frozen rules on the stocks of MQ3 and MQ4 (TB and SSB readings) and of MQ5 (SSB). Entries are the difference in the share falling (short minus meets), its one-sided 95% lower bound, and the compared episodes and stocks.

| Reading, stocks | Below the point, low side | C1 | C2 | Falls: short / meets (pooled) |
|---|---|---|---|---|
| **SSB, MQ5 primary (69)** | 399 episodes, 41 stocks | **0.351** (0.219), 297 from 21 | **0.357** (0.174), 159 from 15 | 0.74 / 0.23 |
| **SSB, MQ3–MQ4 primary (143)** | 723, 75 | **0.298** (0.212), 561 from 40 | **0.225** (0.140), 328 from 31 | 0.72 / 0.36 |
| SSB, MQ3–MQ4 other (101) | 221, 27 | 0.125 (−0.064), failed | 0.022 (−0.136), failed | 0.67 / 0.35 |
| TB, MQ3–MQ4 primary (191) | 1,112, 103 | 0.295 (0.201), 862 from 58 | 0.205 (0.093), 537 from 43 | 0.77 / 0.34 |
| TB, control (33) | 185, 19 | 0.375 (0.016), 108 from 11 | 0.482 (0.161) | 0.90 / 0.31 |
| TB, other (144) | 313, 50 | 0.091 (−0.100), failed | 0.023 (−0.144), failed | 0.81 / 0.51 |

What the development shows:
- **On the stocks already read, the prediction holds in both readings.** Episodes short of the draw fall 0.30–0.35 more often than those meeting it, in the same stock at the same deficit.
- **The share falling is graded by recent giving over the draw** (SSB, MQ5 primary): 0.82 below 0.8, 0.59 from 0.8 to 1, 0.34 from 1 to 1.25, and 0.15 above.
- **C2 holds too.** At the same trend of the level, the classes split by the catch's change at the origin still differ (0.23–0.36).
- **The other group fails in both readings** (RAM's methods listed as `Unknown`).
- **At f = 0**, the SSB primary C1 is 0.45 (MQ5's stocks) and 0.28 (MQ3–MQ4's).
- **Reported (not frozen):**
  - crossing the point by year 3 is rare in both classes (MQ5's stocks: 1 of 60 short, 1 of 53 meeting);
  - the level's part at the same recent giving (C3) and short against meets above the point vary in sign across the sets (C3 0.11 to 0.29; above the point 0.00 to 0.17).

## Data and what has been seen

- **Sources, downloaded 21 October 2026 with Ren's approval in chat** ("approved, go ahead with both downloads"), each into its own directory outside the repository and read with `python3 -I`. Sizes and md5 sums of every file are in [`results/mq7/data-files.json`](results/mq7/data-files.json).
  - **NOAA Stock SMART**, through the NOAA-EDAB `stocksmart` R data package on GitHub: `data/stock_assessment_data.rda` (857,831 bytes, md5 `eedc109a5dfdffa64fb9b4c4870e2c2f`; last changed in commit `959ae760`, 2026-09-29) and `data/stock_assessment_summary.rda` (186,478 bytes, md5 `bfe693c0a092806986a16819ab1ca53e`). The package's pull of Stock SMART is dated 2026-10-17. US Government data, public domain. The files are R serializations, read by [`rda_read.py`](rda_read.py) with the standard library.
  - **ICES Stock Assessment Graphs** (`sag.ices.dk/SAG_API`, CC BY 4.0): `StockList` for the assessment years 2015–2025 (11 files, 1.07 MB) and the `SummaryTable` of the latest published advice assessment of each of the 57 unread ICES stocks (57 files, 1.66 MB).
- **Read before the freeze:**
  - Stock SMART: the two tables' column names and types; every assessment's series kinds (metric, description, units) and their years; the summary's stock names, species, areas, assessment years and models (not its reference points or status values).
  - SAG: the stock lists in full (keys, stock labels, species, descriptions, model types and names, years, purposes); in each downloaded summary table, the stated units and descriptions and the years at which the SSB, total biomass, catch and landings fields are present (whether a value is there, not the value).
  - RAM Legacy v4.66: the `stock` table, for matching.
- **Parsed in memory, not printed, kept or analysed.** Reading an .rda file decompresses and parses all of it, so the value column of Stock SMART's time series was parsed in memory for every stock, read and unread. No value of it was printed, kept or used before the freeze. The presence-only code never takes the value column (`smart_assessments(values=False)`).
- **Not read:** any value of a test stock, in either source. No stock assessment report, advice sheet or plot of a test stock was opened.
- **Prior knowledge, disclosed.** From the literature, from memory: anglerfish and pollack assessments in ICES use Stock Synthesis, and many ICES spawning biomasses are taken at spawning time. Nothing about the fates of the test stocks was known.

## The test stocks: stocks no analysis has read

- **The rule** ([`match_mq7.py`](match_mq7.py), [`results/mq7/matching.json`](results/mq7/matching.json)).
  - A test stock is unread where no RAM stock whose values MQ3, MQ4 or MQ5 read holds the same fish (same species, overlapping area).
  - A stock reassessed under a new definition keeps only its latest assessment.
  - Each decision was made by hand from names, species, areas and model types, and is recorded with the RAM stock it rests on.
- **ICES SAG.** Of the 161 stocks whose latest published advice assessment is from 2018 on and names a model type:
  - 96 hold the fish of a RAM stock already read;
  - 5 were superseded by a split or relabelling;
  - 3 are out of scope (salmon, sea trout and eel: what is left after the catch is not carried into the level);
  - 57 are unread. Their RAM counterpart, where there is one, carries only an index, a ratio or the catch.

  Stocks without a model type in SAG are not modelled assessments and carry no level in tonnes.
- **Stock SMART.** Of the stocks with a level and a catch in weight over at least 26 consecutive years, 132 hold the fish of a RAM stock already read and 20 are unread.
- **The draw must be the whole draw.** A catch series that names a single gear or one of the commercial and recreational fleets, and is not a total, is not read (`partial_catch`). This rule was fixed before any value was read, on seeing that Stock SMART's eastern Gulf of Mexico hogfish carries only its spear harvest and Puerto Rico's queen triggerfish only its commercial landings. Both stocks drop out.
- **Groups.**
  - SAG's model types A (age-based) and AL (age-length) are primary; B (biomass dynamics) is control; the rest by model name.
  - Stock SMART's models map to the same three groups by name (`model_group`).
- **The layout** ([`results/mq7/layout.json`](results/mq7/layout.json), presence only):

| Reading, group | Eligible (≥ 25 SP years) | Stocks |
|---|---|---|
| **SSB, primary (the verdicts)** | **21** | ICES (10): anchovy in southern 9.a, anglerfish in 3.a, 4 and 6, black-bellied anglerfish in 7 and 8.abd and in 8.c and 9.a, boarfish in 6–8 (all SS3), Atlantic wolffish in 5.a and northern Norwegian coastal cod (SAM), Greenland halibut in 5, 6, 12 and 14 and Icelandic slope beaked redfish (GADGET), pollack in 6 and 7 (SS3). Stock SMART (11): nine American Samoa bottomfish (one Stock Synthesis framework of 2023), Florida Keys / East Florida hogfish (SS3, 2014), the Pacific Coast blackspotted and rougheye rockfish complex (SS, 2019) |
| TB, control (reported) | 3 | American Samoa and Guam bottomfish complexes (JABBA), Main Hawaiian Islands Deep 7 (Bayesian production model) |
| TB, other (reported) | 2 | Gulf of Maine / northern Georges Bank red hake, Gulf of Alaska shark complex |
| survey, other (reported) | 5 | windowpane, red hake (2), Gulf of Alaska sculpin and shallow-water flatfish complexes |

- **Short by presence.** Three primary ICES stocks: West Greenland offshore and northwest Greenland inshore cod, and horse mackerel in 4.bc and 7.d.
- **Spawning biomass is female-only** for black-bellied anglerfish in 8.c and 9.a (the fitted κ carries the scale).
- **The catch is landings** for four ICES stocks (anchovy, both black-bellied anglerfish, pollack), as MQ3 took landings where no total catch is given.
- **The nine American Samoa stocks come from one assessment framework** and share its catch reconstruction, so they are not nine independent assessments. The bootstrap resamples stocks, not frameworks; the verdicts are also reported with each source apart.

## Fixed choices

- **Horizon and episodes.**
  - K = 3 years, the catch held within 1.25 of its mean, and below the point by a factor 1.25 (MQ3's F3).
  - MQ3's split and MQ3's level law.
  - The timing grid {0, 0.5, 1} and MQ5's κ grid.
  - The deficit's bins of width 0.2, with below 0 one bin.
- **The comparison.** A Mantel–Haenszel weighted difference in the share falling within strata, w_s = n_s(short) n_s(meets) / n_s; strata with one class carry no weight. Its one-sided 95% lower bound comes from 2,000 bootstrap resamples of stocks (origins overlap within a stock; a stock drawn twice counts as two), seed 20261021.
- **Testable.**
  - C1 needs at least 10 compared episodes in each class, from at least 3 stocks each.
  - C2 needs at least 10 compared discordant episodes from at least 3 stocks (the recent giving's class against the level's last change).
  - Both need at least 5 stocks compared.
- **Series.**
  - Stock SMART's level is the assessment's abundance series in weight (spawning, mature or one-sex biomass for SSB; total, exploitable or age-k+ biomass for TB). Survey, smoothed, adjusted, complex-wide, relative or egg series are not a level.
  - The catch is the first whole-draw catch in weight, in the order total catch, landings plus discards, catch, modelled catch, then landings.
  - SAG's level is SSB where the stock size is described as SSB in tonnes; the catch is total catches, else landings, in tonnes.
  - For each stock and reading the assessment read is the most recent with both (then the longer run).

## Rules (all in `mq7.py test`; each verdict on the primary group, SSB reading)

- **C1, the prediction.** Below the regime's point, on the low side of the level law's peak, the episodes whose recent giving falls short of the draw fall more often than those whose recent giving meets it, in the same stock and the same bin of the deficit.
  - Passed where the pooled difference is positive and its one-sided 95% stock-bootstrap lower bound is above zero.
- **C2, beyond the level's last change.** C1 within strata of the same sign of the level's change over the year before the origin as well.
  - **Why.** Under a held catch the recent giving falls short of the draw exactly where the level fell last year, less the catch's change at the origin (the balance: r − H = x_t0 − x_{t0−1} + κ (C_{t0−1} − C̄)). So C1 alone does not tell giving against the draw from a trend of the level. C2 compares only episodes of the same trend, whose classes differ through the catch's change at the origin.
  - **Predictions.** Momentum predicts no difference, or the reverse; the balance with persisting giving predicts C1's sign.
  - Passed as C1.
- **How the verdicts combine** (fixed now):
  - C1 passing says that below the measured point the recent giving separates the fates and the level does not settle them.
  - C2 passing says that it is the giving against the draw that does it, not a trend of the level.
  - C1 passing with C2 failing (or not testable) leaves a trend of the level as a reading of C1.
- **Reported, not verdicts:**
  - the share falling in each class, falling at every step, and crossing the point by year 3 (`Crossing.crosses`);
  - C1 pooled over stocks in MQ3's strata of the level (the first draft, which the null passes);
  - C1 on the high side of the peak and over both sides;
  - above the point, short against meets;
  - the level's part at the same class of recent giving (C3: below the point against above it, on the low side). Over three years the theorem orders the eventual rest, not the next steps.
  - the share falling graded by r/H;
  - the frozen rest's call (falls iff short) and momentum's (falls iff the level fell last year);
  - C1 and C2 at five years;
  - C1 and C2 with every series read at f = 0;
  - the TB, survey and other groups;
  - each source apart.

## Dry runs (synthetic stocks; `mq7.py dry`, seeds 20261021 + 100 s)

Each generator is run in both readings; the SSB reading is the verdicts', with κ and the timing fitted by MQ4's state. Entries are verdicts over the seeds run, with each run's difference.

| Generator | Seeds | SSB: C1 | SSB: C2 | TB: C1 | TB: C2 |
|---|---|---|---|---|---|
| level: giving read off the level, held catches reset (the null) | 4 | **failed 4** (−0.08, −0.15, −0.05, 0.05) | failed 3, not testable 1 | failed 4 | failed 3, not testable 1 |
| level-law: the same, the catch following the level (the null) | 4 | **failed 4** (−0.02, 0.06, −0.10, 0.02) | failed 4 | failed 4 | failed 3, not testable 1 |
| **adjusting-law: the hypothesis, the catch following the level** | 4 | **passed 4** (0.20, 0.14, 0.09, 0.15) | passed 4 | passed 4 | passed 4 |
| **adjusting-reset: the hypothesis, held catches reset** | 4 | **passed 4** (0.27, 0.57, 0.24, 0.18) | passed 2, failed 1, not testable 1 | passed 3, failed 1 | passed 3, failed 1 |
| mq5-state: MQ5's frozen state (λ = 0.55) | 1 | failed (0.00) | failed | failed (−0.02) | failed |
| relaxing: MQ4's state, no lag | 1 | failed (0.49, lower bound 0.00) | not testable | passed (0.55) | not testable |
| trend: the catch moves no level | 2 | failed 2 (−0.07, 0.01) | **failed 2** (−0.19, −0.02) | failed 2 | **failed 2** (−0.17, −0.17) |
| age: age-structured, not the hypothesis | 1 | passed (0.09) | failed (0.01) | passed (0.18) | passed |

**Mis-timed series.** The hypothesis (`adjusting-law`) reported after half or all of the year's catch, with the timing read, passes C1 and C2 in both readings: SSB 0.18 and 0.17, TB 0.13 and 0.13. Read at f = 0, the SSB reading of a level reported after the whole catch fails C1 (0.07, lower bound −0.01). There the timing step is what keeps the verdict.

What the dry runs show:
- **In the SSB reading as fitted, C1 separates the hypothesis from the regime's step:** 8 of 8 passes against 0 of 8 here, and 14 of 16 against 0 of 16 with the design checks.
- **C2 separates giving against the draw from a trend of the level:** the trend null fails it.
- **An age-structured stock passes C1.** Its recruitment carries giving forward, as the field's adjustment does. So C1 does not tell an age structure from an adjustment of giving, as MQ5's verdicts did not. In the SSB reading the age-structured stock fails C2.
- **MQ5's frozen state fails C1.** At its rate giving reaches the draw within a year or two, so the recent giving no longer separates three-year fates.

## Rule and design changes made after development, dry runs or the presence-only layout, before any test value was read

- **The strata.** C1 had been pooled over stocks in MQ3's strata of the level. The regime's step gives that form a positive difference, and passes it in the SSB reading, so the comparison became within a stock and a bin of the deficit (above).
- **The reading.** The verdicts had been planned on the TB reading, where the dry runs separated the null and κ is not fitted. The layout then found no unread primary stock with total biomass. So they moved to the SSB reading, with κ and the timing fitted by MQ4's state, chosen on the design checks above (MQ5's state with the lag lets the null pass).
- **The level's part at the same recent giving (C3)** is reported only. Over three years the theorem predicts little there, and in the first development it reversed in the SSB reading of MQ5's stocks.
- **The hypothesis' generator.** It had been MQ5's frozen state (λ = 0.55), under which the prediction does not hold over three years. It is now the field's in-sample rate, with MQ5's state kept as a reported generator.
- **The testable condition for C2.** It counts the discordant episodes. The concordant episodes carry no information on C2 and made it testable with almost none.
- **Partial catches** are not read (above).
- **An earlier scratch check had suggested that bins of 0.1 let the null pass.** It had capped the bins at 0.4. The committed check (`dev_mq7.py bins`) shows that they do not.

## What the verdicts would mean

- **C1 and C2 passing.** On stocks no analysis has read, below the regime's measured point, the recent giving against the draw separates three-year fates where the level does not settle them, and not as a trend of the level would. That is T2's reading of F3's failure: the point of no return is a curve in the plane of level and recent giving, not a level.
- **C1 passing, C2 failing.** The fates follow the level's last change; whether the catch's change at the origin moves them as the balance says is not shown.
- **C1 failing.** Below the measured point, the recent giving does not separate fates within a stock at the same deficit. Either the regime's step reads these stocks after all (unlike MQ3's), or giving moves to the draw within a year (MQ5's frozen rate).
- **Not testable.** The 21 stocks give too few compared episodes; the prediction stays untested.
- **Neither verdict tests the theorem itself,** which holds under its premises. They test that the field's giving is an adjustment of the kind its premises name, over the low side.

## Expectations before the run (from the development; not rules)

- **C1.** If the new stocks are like the RAM stocks already read, C1 passes with a difference near 0.3.
- **The open questions are power and the kind of assessment.**
  - 21 stocks give perhaps 50–100 compared episodes, against 297 from 69 stocks in development.
  - Nine of them come from one data-limited framework. A model whose recruitment is not estimated reads its spawning biomass off the catch as the regime's step does, and there C1 would fail.
- **C2** may be not testable: the development's discordant episodes were about a tenth of the compared.

## Literature (closest prior results; from memory, not checked against the texts)

- **Constant catch.** Under a constant catch the harvested equilibrium has an unstable point, below which the stock falls (Beddington and May 1977, *Science*; Clark 1976). That is the regime's step's point of no return.
- **Production lags.** Delay-difference models carry the lag from recruitment and growth explicitly (Deriso 1980; Schnute 1985). Surplus production models omit it (Hilborn and Walters 1992).
- **Changing productivity.** Productivity regime shifts are common in assessed stocks (Vert-pre, Amoroso, Jensen and Hilborn 2013, *PNAS*), so a level law fitted on earlier years misplaces later points.
- **Recovery from depletion.** It is often slower than models predict (Hutchings 2000, *Nature*; Neubauer, Jensen, Hutchings and Baum 2013, *Science*). That is a fate question on the low side.
- **Assessment output is model output.** Retrospective patterns revise it (Mohn 1999), and its biomass obeys the assessment's own balance of catch and production. So C2's balance holds partly by construction, and C1's persistence may be partly the assessment's.
- **The data.** RAM Legacy (Ricard, Minto, Jensen and Baum 2012, *Fish and Fisheries*); NOAA Stock SMART; ICES Stock Assessment Graphs.
