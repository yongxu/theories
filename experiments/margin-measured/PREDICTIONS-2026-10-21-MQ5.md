# MQ5: a lag and the draw's response in the field. Frozen 21 October 2026

Board item MQ5. AI-written. The following are all committed before any value of the test stocks is read:
- this file;
- [`mq5.py`](mq5.py) and [`dev_mq5.py`](dev_mq5.py);
- the presence-only layout ([`results/mq5/layout.json`](results/mq5/layout.json));
- the development on MQ3's and MQ4's stocks ([`results/mq5/development.json`](results/mq5/development.json), [`results/mq5/development-models.json`](results/mq5/development-models.json), [`results/mq5/dev.out`](results/mq5/dev.out));
- the dry runs ([`results/mq5/dry-runs.json`](results/mq5/dry-runs.json), [`results/mq5/dry.out`](results/mq5/dry.out)).

The verdicts are kept whatever they are.

## The question

MQ4 (study §277) read a state of level and recent giving in 76 assessed stocks no analysis had read. Recent giving and the level were both needed. Two things were left:
- **G3 failed.** Last year's escapement and the giving before still removed a median 0.12 of the residual variance, and post hoc that excess was mostly the lagged escapement.
- **F10b failed.** At ten years, "the level stays where it is" (persistence) beat every forecast from the state: 0.215 against 0.304. Post hoc, next year's catch followed the last change in biomass in 70 of 76 stocks.

MQ5 asks two things on stocks no analysis has read:
- **(a)** Is the state the level, the recent giving and a lag (last year's escapement, as an age structure gives)?
- **(b)** Does reading the draw as a law of the stock (the catch following the level) explain why persistence wins at ten years?

## The state in the theory's terms

- **MQ4's state** (LG): γ′ = φ γ + (1 − φ) g(E), x′ = E + γ′, with E = x − H what the draw H leaves.
  - φ = 1 is the frozen rest and φ = 0 the regime's step (RM1, §270). φ = 0.96 is MQ4's frozen rate.
- **The state with the lag** (LGD): the giving also reads last year's escapement,

  γ_t = φ γ_{t−1} + (1 − φ) g(E_t) + λ (E_{t−1} − E_t).

  - **The balance.** The level's change is giving less the draw: x_{t+1} − x_t = γ_t − H_t. From it, E_{t−1} − E_t = H_t − γ_{t−1}.
  - So the lag is giving moving toward the draw: γ_t = (φ − λ) γ_{t−1} + λ H_t + (1 − φ) g(E_t).
  - At the frozen values (φ = 0.96, λ = 0.55) the level's net change is γ_t − H_t = 0.41 (γ_{t−1} − H_t) + 0.04 (g(E_t) − H_t). Last year's giving set against this year's draw shrinks to 0.41 of itself. A share of the level law's surplus over the draw is added.
  - At a fixed point E_{t−1} = E_t, so the lag vanishes. The fixed point is RM1's regime point, as under MQ4's state; the lag changes only the approach to it.
  - This is elementary and not a Lean result. MQ5 is empirical and adds no Lean.
- **One dependence, three readings.** By the balance, a giving that reads E_{t−1} beyond E_t and γ_{t−1} is a giving that reads the current draw H_t. Three readings give that same dependence:
  - a lag (recruits from last year's spawners, as an age structure gives);
  - the other order of draw and giving (giving read off the level before the draw);
  - compensation (MQ3's F4: giving at equal escapement rises with recent exploitation).

  MQ5's verdicts do not separate them. Two things are reported toward separating them: which of the lag and the other order fits better (they differ only in their squares), and the age-structured generator.
- **The draw as a law of the stock.** With no future catch used, the closed loop sets C_t = C_{t0−1} (x_t / x_{t0−1})^ε.
  - ε = 0 holds the draw, as the frozen rest does. ε = 1 holds the exploitation rate.
  - A harvest control rule that cuts the catch as the stock falls lies between the two.
  - The measured ε, 0.7, is frozen.
  - In the closed loop, giving and draw are both laws of the state, so the forecast is the unfolding of the coupled pair rather than of the stock under a given draw.

## The reading: spawning biomass and catch

The stocks no analysis has read carry spawning biomass (SSB) and catch, not total biomass (TB). The two are not on one scale:
- the catch is taken from the exploited stock, including fish not yet mature;
- SSB is the mature part.

**The reading:**
- The level is SSB.
- The draw on it is κ C, a share κ of the catch.
- The giving is γ_t = SSB_{t+1} − SSB_t + κ C_t, and the escapement E_t = SSB_t − κ C_t.

**How κ is fitted:**
- κ is fitted per stock on its training years. It is the share, on a grid from 0 to 2 in steps of 0.05, with the least residual sum of squares of the state with the lag (giving at t on E_t, E_t², γ_{t−1}, E_{t−1}, E_{t−1}², over training years with t − 2 in the run).
- A share is admissible only where every escapement over those years is positive.
- The TB reading is κ = 1. The development and the dry runs read both.
- The state with the lag is used because, in the dry runs, fitting κ with MQ4's state biased it low where the lag holds: medians of 0.05 to 0.3 of the true share. On synthetic stocks where the lag holds ([`dev_mq5.py`](dev_mq5.py)), the share fitted with the lag has a median of 0.84 of the true share and quartiles of 0.45 and 1.66. Without the lag the median is 0.35, and with the level law alone 0.27.

**κ is weakly identified, and the weakness is stated in the rules.**
- A wrong κ adds a term in C_t to the giving, and by the balance that is the same column the lag adds.
- The robust tests therefore give the base model a free linearized shift of κ (the residual's derivative in κ). A κ misfitted at its fitted value then cannot pass for the lag.
- The cost is power. Where the lag holds exactly, S2's test fires in 27 of 145 synthetic stocks in the SSB reading, against 141 of 150 in the TB reading.

**The bridge.** On the 142 primary development stocks whose assessments carry both TB and SSB:
- the fitted κ has quartiles 0.05, 0.35 and 0.65;
- the median SSB share of TB is 0.48;
- κ and that share correlate at 0.33.

The verdicts on those stocks:
- TB reading: all eight rules pass.
- SSB reading: all pass except S3 (0.108 against the bound 0.10).

## Data and what has been seen

- **Source.** RAM Legacy Stock Assessment Database v4.66, assessment data only: Zenodo record 14043031, CC-BY-4.0, archive `RAMLDB v4.66.zip`, md5 `ed6d7cd3f7da1fdcbc60015c3d65014b`.
  - The archive was copied from the MQ4 session's scratchpad and its md5 matched, so nothing new was downloaded; it is covered by Ren's approval of 20 October 2026.
  - It is extracted outside the repository. Files are read with `python3 -I` from outside their directories.
- **The test stocks: stocks no analysis has read.**
  - They are current stocks, none of them among MQ3's 256 or MQ4's 215. MQ4's 215 are the current stocks outside MQ3's with any assessment carrying TB and catch.
  - Each has an assessment carrying SSB and catch in tonnes. MQ5 reads the most recent assessment where it has both, else the latest earlier one; ties go to the longer run, then the assessid.
  - That gives 175 stocks. 56 assessments of deprecated stocks are skipped.
  - By presence, 101 have at least 25 SP years:
    - 70 primary (CASAL 26, SS3 11, SCA 7, VPA 6, ASAP 5, others);
    - 5 control;
    - 26 other, all with method `Unknown`.
  - 95 of the 101 are read from the stock's most recent assessment.
  - Every SSB series is `SSB-MT`. The catch is `TC-MT` in 75 stocks and landings `TL-MT` in 26.
- **Read before the freeze:**
  - the database documents and tables as MQ4 read them (`tsmetrics`, `stock`, the `assessment` table's ids, stocks, year ranges, methods and most-recent flags);
  - the presence and years of TB, catch and SSB series for every assessment (no values);
  - the values of MQ3's and MQ4's assessments, SSB included, already read there, for development.
- **Parsed in memory in earlier sessions, never kept, printed or analysed.**
  - In MQ3's run and in MQ4's development, MQ3's loader (`mq3.load`) parsed in memory the TB and catch values of every most-recent assessment carrying either.
  - For 100 of the 101 eligible test stocks, the most recent assessment carries a catch or TB series in tonnes, and 95 of those are the assessment MQ5 reads. Their catch values were parsed in those runs and dropped.
  - No SSB value of a test assessment has been parsed.
- **In this session no value of a test assessment was parsed.**
  - `mq5.py dev` and `dev_mq5.py` read MQ3's and MQ4's assessments only (`dev_assessments`).
  - `mq5.py layout` keeps no value cell.
  - Reading the workbook tokenizes every row of a sheet. Rows of other assessments are skipped before their value cell is converted.
- **Not read:** any value of the test stocks' assessments, SSB or catch, by this or any analysis. No stock summary or plot was opened.

## Development on MQ3's and MQ4's stocks (already read; not a test)

The classes ([`dev_mq5.py`](dev_mq5.py)) forecast the level k years ahead from the state at the origin, on MQ3's split and MQ5's origins. Entries are the pooled median |log error| on the primary group, with direction accuracy in brackets.

SSB reading, 142 stocks (2,901, 2,317 and 1,604 origins):

| Class | 1 year | 5 years | 10 years |
|---|---|---|---|
| FR, frozen rest | 0.035 (0.758) | 0.272 (0.640) | 0.554 (0.618) |
| RM, regime step | 0.098 (0.592) | 0.436 (0.595) | 0.816 (0.580) |
| LG, MQ4's state | 0.034 (0.762) | 0.253 (0.641) | 0.537 (0.616) |
| LG3, the lag inside the level law (quadratic in E_t and E_{t−1}, fitted) | 0.034 (0.760) | 0.265 (0.644) | 0.582 (0.625) |
| LGD λ = 0.15 | 0.034 (0.761) | 0.217 (0.640) | 0.368 (0.616) |
| **LGD λ = 0.55, the state with the lag** | 0.043 (0.753) | 0.210 (0.636) | 0.299 (0.607) |
| NC ψ = 0.3, the net change decaying by 0.3 a year (no level, no lag) | 0.050 (0.757) | 0.206 (0.647) | 0.304 (0.607) |
| CLLG ε = 0, MQ4's giving, draw held | 0.038 (0.751) | 0.275 (0.638) | 0.567 (0.604) |
| **CLLG ε = 0.7, MQ4's giving, the draw's law** | 0.036 (0.751) | 0.225 (0.636) | 0.397 (0.595) |
| CLLG ε = 2.0 | 0.038 (0.734) | 0.212 (0.631) | 0.351 (0.593) |
| CL, the lag and the draw's law | 0.046 (0.746) | 0.211 (0.629) | 0.308 (0.600) |
| RW, persistence | 0.060 | 0.219 | 0.303 |
| MO, momentum (direction only) | (0.757) | (0.590) | (0.517) |

TB reading, 189 stocks (4,261, 3,505 and 2,560 origins):

| Class | 1 year | 5 years | 10 years |
|---|---|---|---|
| LG | 0.024 | 0.171 | 0.349 |
| LGD λ = 0.55 | 0.035 | 0.164 | 0.249 |
| NC ψ = 0.3 | 0.041 | 0.170 | 0.254 |
| CLLG ε = 0 / 0.7 | 0.032 / 0.031 | 0.215 / 0.176 | 0.443 / 0.318 |
| CL | 0.038 | 0.167 | 0.249 |
| RW | 0.050 | 0.178 | 0.257 |

What the development shows:
- **The lag in the level law does not forecast.** Fitted per stock as a second quadratic, it is worse than MQ4's state at ten years. One weight for all stocks, read through the balance as giving moving toward the draw, does better. That is LGD.
- **LGD closes the whole of LG's ten-year gap to persistence** (SSB 0.299 against RW 0.303; TB 0.249 against 0.257). It also beats LG at five years.
  - So does a net change that decays with no level and no lag (NC). The lag's forecast gain is a damping of the net change, and damping draws any forecast toward persistence.
  - So the forecast rules P2 and D2 are not specific. The lag's specific evidence is in sample (S2) and against MQ4's state at five years (S4).
- **In sample the giving moves toward the draw.** Per stock, giving on E_t, γ_{t−1} and E_{t−1} without squares has medians:
  - SSB: −0.29, 1.00, +0.29, with E_{t−1} positive in 113 of 142 stocks;
  - TB: −0.17, 0.96, +0.20, with E_{t−1} positive in 158 of 189.

  By the balance, the SSB medians give γ_t ≈ 0.71 γ_{t−1} + 0.29 H_t. The weight that forecasts best, 0.55, is larger than the one-step weight fitted in sample, as MQ4's φ was.
- **The draw follows the stock.**
  - The pooled elasticity of the catch to the level over ten-year windows is 0.67 in SSB (25,923 pairs) and 0.71 in TB.
  - At 0.7, the draw's law closes 65% (SSB) and 67% (TB) of the gap between the held draw and persistence at ten years.
  - With the lag as well (CL), the forecast ties persistence at ten years: better in 72 of 140 stocks, worse in 68.

**How λ was chosen.** The criterion was the least pooled median |log error| of LGD at five years over all 249 development stocks in the SSB reading, on a grid from 0 to 1 in steps of 0.05. It gives 0.55 (0.2218).
- The minimum is shallow: 0.45 gives 0.2237 and 0.7 gives 0.2254.
- ε is the measured elasticity rounded to 0.1.
- `mq5.py dev` recomputes both and stops if either differs from the frozen value.

The frozen rules on the development stocks (`mq5.py dev`):

| Rule | SSB primary (142) | SSB other (101) | TB primary (189) | TB control (33) | TB other (144) |
|---|---|---|---|---|---|
| S1 MQ4's state (detected: giving, level) | passed (103, 62) | passed (55, 37) | passed (138, 87) | passed (24, 19) | passed (91, 57) |
| S2 the lag (detected) | passed (30, p = 1.9e-11) | **failed** (6) | passed (48) | passed (9) | passed (31) |
| S3 nothing more (median excess) | **failed** (0.108) | passed (0.090) | passed (0.086) | **failed** (0.157) | passed (0.049) |
| S4 the lag at five years (LGD vs LG; stocks better/worse) | passed (0.210 vs 0.253; 109/33) | passed (0.254 vs 0.362; 84/17) | passed (0.164 vs 0.171; 120/69) | **failed** (0.170 vs 0.101) | passed (0.201 vs 0.240) |
| P1 persistence wins at ten years (RW vs LG) | passed (0.303 vs 0.537) | passed (0.364 vs 0.630) | passed (0.257 vs 0.349) | **failed** (0.307 vs 0.257) | passed (0.328 vs 0.431) |
| P2 the lag closes the gap (share) | passed (1.02) | passed (0.97) | passed (1.09) | not testable | passed (0.98) |
| D1 the draw follows the stock (positive slopes) | passed (97/141) | passed (85/100) | passed (133/188) | passed (24/33) | passed (110/143) |
| D2 the draw's law closes the gap (share) | passed (0.65) | **failed** (0.39) | passed (0.67) | passed (0.94) | passed (0.82) |

In the SSB reading the control group has 6 stocks and is not testable. In the TB control group (biomass dynamics models), MQ4's state forecasts best at five and ten years, so S4 and P1 fail there.

## Fixed choices

- **Series:**
  - SSB is the first present of `SSB-MT`, `SSB-E03MT` × 10³, `SSB-E05MT` × 10⁵ and `SSB-E06MT` × 10⁶.
  - Catch is as MQ3: `TC-MT`, `TC-E03MT` × 10³, else landings `TL-MT`, `TL-E03MT` × 10³, `TL-E06MT` × 10⁶.
- **Years.** The longest consecutive run with SSB > 0 and catch ≥ 0, with at least 25 SP years.
- **Split, giving law, floor.** As MQ3: training is the first 60% of SP years. g(E) = aE + bE² through the origin is fitted on the training years with E > 0, in units of the largest training SSB. Log errors floor forecasts at 1% of that SSB.
- **κ.** As stated above.
- **Exclusions.** A stock is excluded if no κ is admissible, or if more than 10% of its SP years have E ≤ 0 at its κ.
- **The assessment.** As stated under the test stocks.
- **Groups.** As MQ3: *primary* (statistical catch-at-age and catch-at-length models, integrated analysis, VPA), *control* (biomass dynamics models) and *other*. Verdicts are on the primary group; control and other are reported.
- **Rates.** φ = 0.96 (MQ4's), λ = 0.55, ε = 0.7. Horizons 1, 5 and 10 years.
- **Origins.** Test years t0 with t0 − k, t0 − 2 and t0 + k in the run, and no year with E ≤ 0 from t0 − 2 to t0 + k − 1. The forecasts start from x_{t0}, γ_{t0−1}, E_{t0−1} and C_{t0−1}.
- **In-sample years.** Every SP year t with t, t − 1 and t − 2 in the run and none with E ≤ 0. A stock needs at least 20 such years.

## Rules (all in `mq5.py test`; each verdict on the primary group)

The in-sample tests use a heteroscedasticity-robust Wald test (HC3), referred to F(q, n − p).
- It is computed at the κ fitted with the base model, and the base carries the residual's derivative in κ (a free shift of the share).
- Why robust: giving's noise grows with its size, and in the dry runs the plain F test fired in 13-21% of stocks on columns the law does not read.
- The plain F counts are reported.
- **S1, MQ4's state on new stocks.** Two tests:
  - recent giving: γ_{t−1} added to E_t and E_t²;
  - the level: E_t and E_t² added to γ_{t−1} and a constant.

  Each must be detected (p < 0.05) in at least 20% of the stocks, and in more than chance allows (one-sided binomial against 0.05, p < 0.001).
- **S2, the lag is part of the state.** E_{t−1} and E_{t−1}² are added to E_t, E_t² and γ_{t−1}.
  - Passed if they are detected (p < 0.05) in more stocks than chance allows (binomial against 0.05, p < 0.001).
  - There is no share floor. In the SSB reading the lag's linear part and a shift of κ are one column, which bounds the test's power near 20% where the lag holds (dry runs).
- **S3, nothing more is needed.** γ_{t−2}, E_{t−2} and E_{t−2}² are added to the state with the lag. Passed if the median excess reduction is below 0.10.
  - The excess reduction is the share of the residual sum of squares removed, less q / (n − p). p counts κ where it is fitted, and each model's κ is profiled.
- **S4, the lag in the forecast.** At five years, LGD beats LG, both with the actual catches.
  - "Beats" means a smaller pooled median |log error|, and a smaller per-stock mean in more stocks than not (two-sided sign test p < 0.05).
- **P1, persistence wins at ten years** (MQ4's F10b, retested). Persistence's pooled median |log error| is below LG's.
- **P2, the lag explains it.** LGD closes at least half of the gap between LG and persistence at ten years: (e_LG − e_LGD) / (e_LG − e_RW) ≥ 0.5.
- **D1, the draw follows the stock**, in the form the closed loop uses. Per stock, log C_t − log C_{t−1} is regressed on log x_t − log x_{t−1}, with log C_{t−1} and a constant.
  - The control is needed because a catch reverting to its own mean, blind to the stock, otherwise gives a positive slope: a high catch lowers the level and then reverts (dry runs).
  - Passed if the slope on the level's change is positive in more stocks than not (two-sided sign test p < 0.05). Each stock needs at least 15 years.
- **D2, the draw read as a law of the stock explains it.** With MQ4's giving and no future catch, the draw's law (CLLG, ε = 0.7) closes at least half of the gap between the held draw (CLLG, ε = 0) and persistence at ten years.
- **Testable.** The forecast rules need at least 100 origins from at least 10 stocks. The in-sample rules and D1 need at least 10 stocks.
- **How the verdicts combine** (fixed now):
  - **(a) The lag is part of the state** where S2 and S4 both pass. S3 says whether it is all of it.
  - **(b) The draw's law explains persistence's ten-year win** where P1, D1 and D2 pass. P2 says whether the lag alone does as well.
  - P2 and D2 are not specific alone, since any damping closes a gap to persistence (the level generator passes both). P1 is MQ4's finding and passes under most generators.
- **Reported, not verdicts:**
  - every rule on the control and other groups;
  - the lag's median excess, and MQ4's G3 in this form (the state of level and recent giving extended by both lags);
  - the lag against the other order, in how many stocks it fits better;
  - the fitted κ;
  - MQ4's uncontrolled form of D1;
  - every class's direction and error at one, five and ten years, and the frozen rest with the draw held (FRH);
  - whether the closed loop with the lag beats persistence at ten years, and whether it beats the same giving with the actual catches. The hypothesis does not imply either: CL ties persistence under the hypothesis' own generator.

## Dry runs (synthetic stocks; `mq5.py dry`, seed 20261021)

There are ten generators of 150 stocks each, over 60 years. All share these settings:
- K = 10⁵ t and Schaefer giving r E (1 − E/K);
- SSB a share ω (0.4-0.9) of the total, exact unless stated;
- verdicts in the SSB reading, with the TB reading run where the giving is the hypothesis' and for the age-structured stock.

The generators:
- **level**: giving read off the level (MQ3's premise), with held catches reset every 3-6 years;
- **relaxing**: MQ4's state, SP_t = 0.9 SP_{t−1} + 0.1 g(E_t), catches reset;
- **hypothesis**: relaxing plus the lag λ (E_{t−1} − E_t), with the catch following the level at ε = 0.7 (noise 0.1, at most 0.6 of the level);
- **hypothesis-noisy**: the same, with lognormal noise 0.02 on the SSB share;
- **lag-reset**: the lag with catches reset;
- **blind**: the lag with log catch an AR(1) of its own, never reading the level;
- **draw-only**: MQ4's state with the draw's law, no lag;
- **two-lags**: the lag plus a second, λ (E_{t−2} − E_{t−1});
- **drifting**: giving a random walk of its own;
- **age**: an age-structured stock (ages 1-12), not the hypothesis. It has Beverton-Holt recruitment with autocorrelated deviations, fishing mortality a bounded random walk, and catch by Baranov's equation.

| Generator | Stocks | S1 (giving, level) | S2 | S3 | S4 | P1 | P2 | D1 | D2 |
|---|---|---|---|---|---|---|---|---|---|
| level | 41 | **failed** (1, 37) | **failed** (3) | passed | **failed** | passed | passed (0.75) | passed | passed (0.80) |
| relaxing | 36 | passed (36, 21) | **failed** (2) | passed | **failed** | **failed** | not testable | passed | passed (0.57) |
| **hypothesis** | 145 | passed (67, 65) | passed (27, p = 3.5e-9) | passed (0.012) | passed (130/15) | passed | passed (0.93) | passed (120/145) | passed (0.72) |
| **hypothesis, TB** | 150 | passed (150, 80) | passed (141) | passed (0.002) | passed (142/8) | passed | passed (1.02) | passed (125/150) | passed (0.82) |
| hypothesis-noisy | 141 | passed (58, 47) | **failed** (6) | passed | passed | passed | passed (0.94) | passed | **failed** (0.37) |
| hypothesis-noisy, TB | 150 | passed | passed (142) | passed | passed | passed | passed (1.01) | passed | passed (0.61) |
| lag-reset | 132 | passed | passed (127) | passed | passed | passed | passed (1.00) | **failed** (33/132) | passed (0.55) |
| blind | 135 | passed | passed (52) | passed | passed | passed | passed (0.94) | **failed** (60/135) | **failed** (0.40) |
| draw-only | 148 | passed | **failed** (9) | passed | **failed** (81/65) | passed | passed (1.20) | passed | passed (2.08) |
| two-lags | 142 | **failed** (18, 37) | passed (24) | **failed** (0.40) | passed | passed | passed (0.81) | passed | passed (0.53) |
| drifting | 43 | **failed** (42, 4) | **failed** (2) | passed | **failed** | **failed** | not testable | **failed** (24/43) | passed (0.58) |
| age | 149 | passed (143, 57) | passed (32) | **failed** (0.46) | passed | passed | passed (0.97) | passed | passed (0.58) |
| age, TB | 150 | passed | passed (67) | **failed** (0.55) | **failed** (75/71) | passed | passed (0.89) | passed | passed (0.67) |

- **Every rule passes where the hypothesis holds, in both readings.**
- **Each null fails a rule.**
  - Without the lag, S2 and S4 fail (level, relaxing, draw-only), and P1 fails where MQ4's state is right (relaxing).
  - With giving of its own, S1 and D1 fail (drifting).
  - With the catch blind to the level, D1 and D2 fail (blind).
  - The reset draws read the level only at each reset. D1 passes under two of them (level, relaxing) and fails under two (lag-reset, drifting).
  - With more history, S3 fails (two-lags, age).
- **P1, P2 and D2 pass under most nulls.** They say how much a reading closes, not which reading is right; the specific rules carry that.
- **The SSB reading's limit.** With 2% year-to-year noise in the SSB share, S2 (6 of 141) and D2 (0.37) fail in the SSB reading and pass in the TB reading.
  - The noise moves the fitted κ toward 0 (quartiles 0.05, 0.15, 0.95), and at κ near 0 the catch hardly enters the forecast.
  - So in the field a failure of S2 or D2 is evidence against the hypothesis only as far as the SSB share is steady. This limit is fixed before the run.

**Rule and design changes made after development or dry runs, before any test value was read:**
- κ is fitted with the state with the lag, not MQ4's state, which biased it low under the hypothesis.
- D1 regresses the change in catch on the contemporaneous change in the level with the catch's own last level. It had been next year's change on the last change, uncontrolled (MQ4's post hoc form), which passed under the blind draw.
- The blind generator became a stationary AR(1) without a cap. The cap at 0.6 of the level made a blind catch read the level.
- A test of the draw's law with the actual levels was dropped. Under the hypothesis, catch noise moves the level, and the test failed there.
- "The closed loop with the lag beats persistence at ten years" became reported only. It fails under the hypothesis' own generator.
- S1's level part had been an effect-size bound. Under the hypothesis it failed, so it became a detection test (MQ4's lesson).
- The in-sample tests became robust (HC3) with the derivative in κ. The plain F test fired in 13-21% of stocks under null generators; HC3 alone, at either κ, over-rejected; HC3 at the base model's κ without the derivative had no power in the SSB reading.
- S2's 20% floor was dropped. With λ = 0.55 the hypothesis' own generator detects the lag in 27 of 145 (18.6%) in the SSB reading.
- λ became 0.55 (it had been 0.5 before `dev` chose it).
- The lag inside the level law (a second quadratic, g3) was dropped for LGD. It was worse out of sample in development, and degenerate in one stock.

## What the verdicts would mean

- **S1-S4 passing:** on stocks no analysis has read, the state is the level, the recent giving and the lag. The lag is equivalently giving moving toward the draw, at about half the gap a year.
  - The three readings of that dependence (age structure, the other order, compensation) are not separated.
  - S3 says whether more history is still needed. An age structure leaves more: S3 fails under the age generator.
- **S2 failing with S4 passing:** the lag forecasts but is not detected in sample. Either the SSB reading's limit applies (the share is not steady), or the forecast gain is damping alone, as NC's equal score shows is possible.
- **S4 failing:** MQ4's state forecasts as well at five years. The lag is not needed there.
- **P1 passing:** MQ4's ten-year finding replicates on the new stocks.
- **D1 and D2 passing:** the catch follows the stock, and reading it as a law of the stock closes most of the held draw's ten-year gap to persistence. Persistence wins partly because the draw responds: management closes the loop that the frozen rest holds open.
- **D2 failing with D1 passing:** the catch responds, but too weakly or too noisily at ε = 0.7 to close half the gap. Or the SSB reading's limit applies.
- **P2 passing:** the lag alone also closes the gap. Since any damping does, P2 adds to (a) only with S2 and S4.
- **Reported CL against persistence:** whether the coupled loop of giving and draw beats "the level stays where it is" at ten years. A tie means the state with both laws forecasts as well as persistence and no better.

## Expectations before the run (from the development; not rules)

These are expectations, not rules:
- S1, S4, P1, P2 and D1 pass;
- S2 is marginal (the SSB reading's power);
- S3 is open (0.108 on the development stocks, at the bound);
- D2 is near 0.65 and could fall below half, as in the development's other group;
- CL ties persistence at ten years.

## Literature (closest prior results; from memory, not checked against the texts)

- **Lags in production from age structure:**
  - delay-difference models carry the lag from recruitment and growth explicitly (Deriso 1980, *Canadian Journal of Fisheries and Aquatic Sciences*; Schnute 1985);
  - surplus production models omit it (Hilborn and Walters, *Quantitative Fisheries Stock Assessment*, 1992).
- **Harvest strategies:** constant catch (ε = 0), constant exploitation rate (ε = 1) and constant escapement are the classical harvest strategies. Harvest control rules that cut the catch as the stock falls lie between them.
- **Simple forecasts:** short-term population forecasts are often won by simple models close to persistence (Ward, Holmes, Thorson and Collen 2014, *Oikos*, "Complexity is costly").
- **Assessment output is model output:**
  - SSB and TB in RAM Legacy come from assessments, so a lag found there may be the assessment model's own structure;
  - retrospective patterns revise them (Mohn 1999, *ICES Journal of Marine Science*);
  - errors shared by SP_t and E_t bias density dependence (Walters' time-series bias).
- **RAM Legacy:** Ricard, Minto, Jensen and Baum (2012), *Fish and Fisheries*.
