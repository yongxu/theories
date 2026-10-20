# MQ3: the margin of a regime in the field. Frozen 20 October 2026

Board item MQ3. AI-written. This file, [`mq3.py`](mq3.py), [`ram_read.py`](ram_read.py), the presence-only layout ([`results/mq3/layout.json`](results/mq3/layout.json)) and the dry runs ([`results/mq3/dry-runs.json`](results/mq3/dry-runs.json)) are committed before any time-series value of the database is read. The verdicts are kept whatever they are.

## The question

MQ1 (study §253) found that the measurable margin belongs to the regime: under a standing draw the point of no return lies above need + draw. MQ2 (§266) found, on real yeast, that one giving law fitted on some regimes predicts the need of held-out regimes, and that giving at equal density falls with the draw. RM1 (§270) put the regime's laws on the spine: `Becoming.RegimeMargin.step g H x = (x - H) + g (x - H)`, the draw taken first and giving read off what is left. Below the point H + y, where y is the least level whose giving meets the draw, the condition falls at every step and ends (`ends_below`). From the point up it holds (`holds`), and the point is exact (`ends_iff_below`).

MQ3 asks whether that step, with a giving law measured on a system's own past, predicts the system's future in the field, against the theory's own frozen-rest reading. In the frozen-rest reading (`Flow.WithheldLevels`) the rest's exchanges, giving included, are held as they were.

## The reading in a fishery

- **Draw.** The year's catch C_t, taken from the total biomass TB_t.
- **What is left.** The escapement E_t = TB_t − C_t.
- **Giving.** The surplus production SP_t = TB_{t+1} − E_t = TB_{t+1} − TB_t + C_t. This is the standard observed surplus production (as in RAM's own SP fit guide), read exactly as RM1's step.
- **Giving law.** g(E) = aE + bE², fitted by least squares on each stock's earlier years and passing through the origin, since nothing gives nothing (`FromNothing`). The class can be concave (a dome, Schaefer-like) or convex. It can fail to reach a draw at all ("beyond giving", `ends_beyond_giving`).
- **Regime point under a catch H.** TB*(H) = H + ŷ(H), where ŷ(H) is the least E ≥ 0 with g(E) ≥ H (`regime_point`). There is none where H exceeds the most g gives.
- **Frozen rest (FR).** Giving held at its last observed value, SP_{t0−1}, at the forecast origin t0. TB_{t+1} = E_t + SP_{t0−1}.
- **Regime margin (RM).** TB_{t+1} = E_t + g(E_t).
- Both forecasts use the actual catches (the draw is the regime's input) and stop at zero once the catch takes everything.
- **Momentum (MO) and persistence (RW).** Two baselines from outside the theory: the sign of TB_{t0} − TB_{t0−k}, and TB_{t0+k} = TB_{t0}.

## Data and what has been seen

- **Source.** RAM Legacy Stock Assessment Database v4.66, assessment data only: Zenodo record 14043031, CC-BY-4.0, archive `RAMLDB v4.66.zip`, 111,883,889 bytes, md5 `ed6d7cd3f7da1fdcbc60015c3d65014b` (matched). Download approved by Ren on 20 October 2026. The archive is extracted outside the repository and not committed. Files are read with `python3 -I` from outside their directories.
- **Read before the freeze:**
  - the database documents (structure, quick guide, SP fit guide, biomass conversion guide);
  - the workbook's sheet names and dimensions;
  - the header rows of the time-series, units, assessment, stock, tsmetrics and parameter sheets;
  - the metadata tables `assessmethod` and `tsmetrics` in full (method codes and time-series type definitions, no stock values);
  - the `assessment` table's `mostrecent` flags and method codes (counts only: 1,438 assessments flagged 999, most recent);
  - the presence of the TB and catch series and their years for those assessments (`mq3.py layout`, which never keeps a value cell).
- **Not read:** any `tsvalue` and any bioparams value. No plot or stock summary PDF was opened.
- **Prior knowledge, disclosed.** From the literature (from memory, not checked against the texts):
  - productivity regime shifts are common in assessed stocks (Vert-pre et al. 2013, *PNAS*);
  - depensation is rarely detected in stock-recruitment data (Myers et al. 1995, *Science*);
  - constant-catch harvesting has an unstable point and constant-effort harvesting does not (Beddington and May 1977, *Science*; Clark 1976).
  - So the expectation before the run is that F0 fails (the level is not the whole state of an assessed stock), and that F1 is hard to win against momentum. These are expectations, not rules.

## Fixed choices

- **Assessment.** For each stock, the assessment flagged most recent (`mostrecent` = 999).
- **Series.** From that one assessment (TB and catch from the same assessment, as the SP fit guide requires):
  - TB: `TB-MT`, else `TB-E03MT` × 10³;
  - catch: total catch `TC-MT`, `TC-E03MT` × 10³, else landings `TL-MT`, `TL-E03MT` × 10³, `TL-E06MT` × 10⁶.
- **Years.** The longest run of consecutive years with TB > 0 and catch ≥ 0. SP years are the run less its last year. At least 25 SP years are required.
- **Exclusions.** A stock is excluded if more than 10% of its SP years have E ≤ 0 (catch at or above the biomass: the TB is then likely an exploitable or mid-year biomass). Otherwise those years are dropped from fits and origins.
- **Split.** Training is the first 60% of SP years (floor); testing is the rest. g is fitted on training only, in units of the largest training TB.
- **Groups.**
  - Primary: assessment methods in the categories *Statistical catch at age model*, *Statistical catch at length model*, *Integrated Analysis* and *VPA* (117 stocks eligible by presence).
  - Positive control: *Biomass dynamics model* (22 by presence). In these assessments the biomass is itself generated by a production function, so the regime margin should do well there. The control is reported, not a verdict, and a failure there would point at the machinery.
  - Other: methods `Unknown` (listed under two categories) and the rest (55 by presence), reported only.
- **Pooling.** Verdicts pool origins over the primary stocks. Stock-mean accuracies are reported.

## Rules (all in `mq3.py test`; each verdict on the primary group)

- **F0, the level as the state** (MQ1 D1 in the field). Over all SP years of each stock:
  - fit SP_t on E_t, E_t² (through the origin);
  - add E_{t−1}, E_{t−1}²;
  - the excess reduction is the fraction of residual sum of squares removed, less the chance level 2/(n − 2);
  - passed if the median excess reduction over stocks is < 0.10;
  - the median lag-1 autocorrelation of the residuals is reported.
- **F1, one step.** At each test origin t0 (with t0 − 1 in the run), call whether TB rises from t0 to t0 + 1 by RM, FR and MO. Passed if RM's pooled accuracy is ≥ 0.60 and above both FR's and MO's.
- **F2, five steps.** At each test origin with t0 ± 5 in the run, call whether TB rises over five years by RM, FR and MO. The median |log(forecast / TB_{t0+5})| is computed for RM, FR and RW, with forecasts floored at 1% of the largest training TB. Passed if RM's accuracy is above FR's and MO's, and its median log error is below FR's and RW's.
- **F3, the regime's point separates fates under a held catch** (`ends_iff_below`, `holds`).
  - Episodes: test origins t0 with t0 + 3 in the run, and the catches of years t0, t0 + 1 and t0 + 2 each within a factor 1.25 of their mean C̄ (a standing draw).
  - Below: no regime point for C̄ (beyond giving), or TB_{t0} < TB*(C̄)/1.25.
  - Above: TB_{t0} > 1.25 TB*(C̄).
  - Testable with ≥ 10 below episodes from ≥ 3 stocks and ≥ 10 above.
  - Passed if ≥ 80% of below episodes fall (TB_{t0+3} < TB_{t0}) and ≥ 90% of above episodes end at or above TB*(C̄).
  - Reported: the share of below episodes falling at every step (`step_falls`); how many are beyond giving; how often FR (C̄ > SP_{t0−1}) called the fall in the below class.
- **F4, giving lowered by the draw** (MQ2's finding, `Lowered`). Descriptive only, not a verdict. Per stock, the residual of SP from g fitted on all years is regressed on the mean exploitation rate C/TB of the three previous years. Reported: the share of negative slopes and a two-sided sign test. A falling productivity under sticky catches also raises the exploitation rate, so a negative slope does not separate the two.
- **Not testable here:**
  - super-additivity of joint harm (`harms_superadditive`): one catch per stock, no separate drawers;
  - the time-to-break band (`not_before`, `falls_within`): assessed stocks are managed before they end;
  - the fold: no smooth fold in the whole-number laws, and none tested.

## Dry runs (synthetic stocks; `mq3.py dry`, seed 20261020)

Three generators of 150 stocks each. Each has Schaefer giving with K = 10⁵ t, lognormal noise 0.2, and held catches reset every 3–6 years to a share of the biomass (0–0.1 below a quarter of K, 0.02–0.5 above). Many synthetic stocks collapse or run short of 25 years before eligibility.

| Generator | Eligible | F0 | F1 | F2 | F3 |
|---|---|---|---|---|---|
| giving a function of the level | 26 | passed (−0.04) | passed (RM 0.90, FR 0.88, MO 0.78) | passed (0.91 / 0.87 / 0.46; log error 0.08 against FR 0.25, RW 0.39) | passed (63 below, 94% fell; 114 above, 100% held) |
| productivity regimes (log r a random walk, steps 0.15) | 42 | passed (0.01) | passed (0.74 / 0.73 / 0.67) | **failed** (0.68 against FR 0.72; log error 0.30 against RW 0.28) | **failed** (68% fell) |
| giving read off the escapement two years before | 33 | **failed** (0.43) | passed | passed | passed |

So the rules pass where giving is read off the level, F2 and F3 fail under productivity regimes, and F0 detects a lagged state. F1 barely separates the models even when the level is the state: one year is short.

## What the verdicts would mean

- **F2 and F3 passing on the primary group:** the regime margin, measured on a stock's own past, predicts its future better than the theory's frozen-rest reading. That is the margin law made operational in the field, beyond yeast.
- **F2 or F3 failing where the control passes:** in assessed stocks giving is not read off the level in a way that persists from the earlier years to the later ones; the regime includes more than the draw (MQ2 found this in yeast). The law stays a theorem; its premise "giving a function of what is left" is what fails, and the record says so.
- **F0 failing:** the stock's state has more than its level, so the step's state must carry more (an age structure, a lag).

## Literature (closest prior results; from memory, not checked against the texts)

- Surplus production and its observed form: Hilborn and Walters, *Quantitative Fisheries Stock Assessment* (1992).
- RAM Legacy and its uses: Ricard, Minto, Jensen and Baum (2012), *Fish and Fisheries*.
- Productivity regime shifts against biomass-driven production: Vert-pre, Amoroso, Jensen and Hilborn (2013), *PNAS*.
- Constant catch against constant effort: Beddington and May (1977), *Science*.
- Depensation at low abundance: Myers, Barrowman, Hutchings and Rosenberg (1995), *Science*.
- Nothing in MQ3 is new fisheries science. What is tested is the theory's regime margin as a measured state quantity in field data, against its own frozen-rest reading.
