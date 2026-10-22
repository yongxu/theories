# EW4: frozen predictions for thesis T6's uncoupled side at the Farallones

Board item EW4, 22 October 2026. AI-written (a Claude Code desktop session; downloads approved by Ren in chat, 22 October 2026). Frozen before any statistic relating the prey series to a breeding series was computed; the commit that lands this file on main is the freeze, and `results/ew4/FROZEN-AT` names it. The test is EW2's ([frozen predictions](PREDICTIONS-2026-10-21-EW2.md)), unchanged; this file states only what differs.

## 1. What is tested, and why this stock

T6's uncoupled side, read as in EW2 and EW3. EW3 left one question open: its verdicts reuse EW2's rows, so it is not independent evidence ([study §350](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#350-early-warnings-before-seabird-breeding-failures-on-longer-series-ew3)). EW4 tests a stock no verdict has used: the Farallon seabirds and the juvenile rockfish off central California. EW2 ran it as a reported-only secondary on Cury et al.'s series to 2007 (partial r 0.12 for autocorrelation, −0.04 for variance), so its early years were read; 14 of its 24 usable rows here were not.

**Shetland is not run.** Its prey series to 2020 was not obtained: ICES's 2025 assessment of Shetland sandeel (san.sa.7r, assessment key 19320; summary sha256 `70882fc3af1bcc501255d69e4a5c6ba6a7b47b5fdbc31b4054303a527be7ddfa`) carries catches only, no biomass or survey index. It was T6's coupled case anyway, where T6 forbids nothing.

## 2. Sources, extraction and what was seen before the freeze

- **Breeding success.** BCO-DMO 985565 v1, as in EW3 (sha256 `1f1f7c0b6aeb4d9f4ae5288edea9b668666fcbc25bfa93c607229ec9d317c6e3`).
- **Prey.** NOAA SWFSC Rockfish Recruitment and Ecosystem Assessment Survey, ERDDAP dataset `FED_Rockfish_Catch` (oceanview.pfeg.noaa.gov, through the upwell.pfeg.noaa.gov mirror), the core area (strata C, Point Reyes to Monterey Bay), 1990–2025: the hauls (`time, cruise, haul_no, station`, distinct; sha256 `7a23e4857855ac509821270de21174ff927b2f7b3822e24577fb0f1fd27163f5`) and the young-of-the-year *Sebastes* catches (`maturity = Y`, sha256 `d129d999c2455ee5caf032ab2183abbf1610ba81549ab2602a3d1c4310580038`). The prey in year *t* is the mean over that year's core hauls of log(1 + young-of-year rockfish caught). The survey's own indices are model-based and adjust catches to a common age; this simpler index is used because it is reproducible from the public table. [`ew4.py extract`](ew4.py) writes the series (sha256 `e5993cc70f96a1add06b2691825a98aeac73ce0c97be12164b319c6492a9f692`). Nothing is committed.
- **Scope literature.** Warzybok et al. (2018, *J. Marine Systems* 185:25; sha256 `b7984001d2b3bc356294167d2ccf4c6dde97d242c8dfd8b249755235c2e20b6c`).
- **Seen before the freeze, disclosed.** The number of core hauls per year. The new prey index correlated with Cury et al.'s CAL prey column (series 15, 1990–2007), prey only, at lags −1 to +1 and in three forms: the mean of log(1 + catch) in the same year 0.935, the log of the mean catch 0.80, the mean catch 0.66, every form a year off at most 0.45. Presence of the breeding-success series. No breeding-success value was displayed and no statistic relating prey to birds was computed.

## 3. Stock, scope and layout

| Stock | Prey in year *t* | Dependents | Role |
|---|---|---|---|
| CAL | young-of-year rockfish, core area, May–June survey of year *t* | common murre, rhinoceros auklet, pigeon guillemot at Southeast Farallon (EW2's three) | **primary** |
| CAL5 | as CAL | as CAL, with Brandt's and pelagic cormorants | secondary |

**No draw.** The birds' rockfish are almost all young of the year, mostly shortbelly rockfish (*S. jordani*), which is not fished; the fisheries take the adults of other species (Warzybok et al. 2018, §4.3; competition "likely to be modest", citing Field et al. 2010). So no catch enters as the draw, and the covariates are EW2's four.

**Scope, by mechanism.** No literature read gives the birds' take as a share of the young-of-year rockfish, so the premise that their feedback onto the observed series is negligible is argued, as EW2 argued it for Røst. The survey reads the year's young of the year in May–June. The birds eat that year class, during and after the survey. Each year's index is a new year class from adults years older, which the birds do not eat; rockfish recruitment is weakly tied to spawners and strongly to ocean conditions. So the birds' take reaches the observed series' dynamics only through spawners several years later. A same-year take during the survey lowers that year's index, a level effect the covariates match. This is weaker than a measured share and is the test's main premise.

**Layout (presence only, `results/ew4/layout.json`).** Prey 1990–2025 complete (15 core hauls in 2020, 33 in 2008, otherwise 41–93); dependents complete over 1990–2021. Usable years 1998–2021 (24), 8 failure years; 14 after EW2's rows (2008–2021).

**Stop rule (EW2's).** Proceed only if a test calibrated on the nulls reaches power at least 0.5 against EW2's effect (G3a for autocorrelation, G3b for variance).

## 4. The test

EW2's section 4, unchanged: EW2's four level covariates, the partial correlation, Pyper and Peterman's effective size, one stock, one-sided *p*.

## 5. Verdicts (frozen)

| Verdict | Rule | Passed if |
|---|---|---|
| **V1** (AR1) | CAL, 8-year window | *p* ≥ 0.025 |
| **V2** (variance) | the same for variance | *p* ≥ 0.025 |

Either failing meets T6's refutation clause, *given the scope premise argued in section 3*: a failure could also mean the birds' feedback onto the series is not negligible. Reported only: R1 unadjusted; R2 windows of 6 and 10; R5 the rows after EW2's (2008–2021); R3 CAL5; after the run, the partial correlation and its 95% interval (`posthoc_ew4.py`, not a verdict).

**Reading a result (frozen).** Both pass: no association beyond the level path in a stock no verdict has used, a third pass for T6's uncoupled side, with the scope argued and not measured. Either fails: the refutation clause is met unless the scope premise fails. The record says which half of that disjunction the evidence favours, and that it cannot settle it.

## 6. Dry runs (frozen with the code; `results/ew4/dry.json`)

EW3's generators (`ew3.generate`: EW2's, with the observed prey the level plus observation noise, z-scored) on CAL's calendar: one stock, 1990–2021, three dependents complete. EW3's catch is generated but not read, and G3's effect is the window statistic's residual given EW3's covariates (level and draw), a slightly weaker effect on the test's four level covariates. 2000 replicates per generator, α = 0.025 per statistic:

| Generator | What it is | Rejects V1 (AR1) | Rejects V2 (variance) |
|---|---|---|---|
| G0 | no feedback, need on the level (T6's uncoupled side) | 0.026 | 0.018 |
| G0s | as G0, a sigmoid need at a third of capacity | 0.025 | 0.019 |
| G0n | as G0, observation noise 0.4 | 0.023 | 0.015 |
| G5 | as G0, the need on last year's level | 0.021 | 0.019 |
| G0r | as G0, breeding-success noise AR(1) 0.5 | 0.028 | 0.025 |
| G1 | feedback of the measured size (3% at X = 1/3) | 0.025 | 0.013 |
| G2 | feedback of the coupled case (40% at X = 1/3) | 0.019 | 0.016 |
| G3a | a need on the prey's recent autocorrelation (EW2's effect size) | **0.570** | 0.035 |
| G3b | the same on the window variance | 0.037 | **0.506** |
| G4 | a shared driver of the stock's noise and breeding success | 0.024 | 0.036 |
| G4s | a strong shared driver | 0.026 | 0.074 |

**Acceptance (EW2's rule):** every null (G0, G0s, G0n, G5, G0r) rejects at most 0.045 per statistic. Met (largest 0.028). **Stop rule:** power at least 0.5 against EW2's effect. Met, narrowly: 0.570 (AR1) and 0.506 (variance). One stock with 24 usable years can detect only a large association; the strong shared driver reaches 0.074 on variance.

## 7. Run

```bash
python3 -I ew4.py extract <985565.csv> <hauls.csv> <yoy.csv> <series.csv>
```

```bash
python3 -I ew4.py layout <series.csv>
```

```bash
python3 -I ew4.py dry 2000
```

```bash
python3 -I ew4.py test <series.csv>
```

## 8. Limits stated before the run

- One stock, 24 usable years, 8 failure years.
- Scope by mechanism only; the share is unmeasured.
- The index is a simple mean of log catches per haul, not the survey's standardized index, and the core area's coverage changed (15 hauls in 2020).
- Failure is relative, as in EW2.
- Ten of the 24 rows overlap the years EW2 read as a reported-only secondary.
