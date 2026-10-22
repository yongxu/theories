# EW3: frozen predictions for thesis T6's uncoupled side on longer series

Board item EW3, 22 October 2026. AI-written (a Claude Code desktop session; downloads approved by Ren in chat, 22 October 2026). Frozen before any statistic relating a prey series to a breeding series was computed; the commit that lands this file on main is the freeze, and `results/ew3/FROZEN-AT` names it. The test is EW2's ([frozen predictions](PREDICTIONS-2026-10-21-EW2.md)), whose design is reused unchanged; this file states only what differs.

## 1. What is tested, and why again

T6's uncoupled side, read as in EW2: given the stock's own course, its early-warning statistics carry no information on whether its dependents fail. EW2 passed at low power with every estimate in the refuting direction (combined partial r about 0.3, 95% interval about −0.1 to 0.6; [study §289](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#289-early-warnings-before-seabird-breeding-failures-in-the-field-ew2)). It left the next test to resolve that estimate: the same design on longer series, with the catch as the draw, since T6's refutation clause names "what the stock's own level and draw predict".

## 2. Sources, extraction and what was seen before the freeze

- **Breeding success.** BCO-DMO dataset 985565 v1, global seabird breeding success (Sydeman et al.; offspring per nesting female per year), file `985565_v1_global_seabird_breeding_success.csv`, sha256 `1f1f7c0b6aeb4d9f4ae5288edea9b668666fcbc25bfa93c607229ec9d317c6e3`.
- **Norwegian spring-spawning herring.** ICES Stock Assessment Graphs, assessment key 21106 (her.27.1-24a514a, assessment year 2025), the SAG API's summary table: recruitment at age 2, SSB and catches, 1988–2025; sha256 `0c3765d3fa772611c87ed3d9603ad347e38d271dbcd7abe93a2a4efa90d62aac`.
- **Benguela sardine and anchovy.** The data records of the 2024 South African assessments: FISHERIES/2024/OCT/SWG-PEL/40 (sardine, doi 10.25375/uct.27824667.v1, sha256 `436d6dccee056c69da4f9bbfa59ca7e5b508c79555d007f3d86996a960df06c0`) and FISHERIES/2024/AUG/SWG-PEL/34 (anchovy, doi 10.25375/uct.27917268.v1, sha256 `f86fbc7a07c934fecf0bf4bea451445c46752e136b215b565c0c5a8f756a1cba`). Read: the November survey biomass of sardine from Hondeklip Bay to Cape Agulhas (sardine Table 3) and of anchovy west of Port Alfred (anchovy Table 2), the monthly sardine catch west of Cape Agulhas (Tables 1a, 1b, 1d, 1e; 1e includes the small amounts landed east of it) and the monthly anchovy catch (Table 1).
- **Extraction.** [`ew3_data.py`](ew3_data.py) writes one CSV of series (sha256 `1180d4cdbc6ba2cb316948c2e3649a939f8003f20ff6fcdf80c333c639dab3d2`); the PDFs' text layer is read with pypdf 6.14.2. No source file and no extract is committed.
- **Seen before the freeze, disclosed.** (1) The herring summary table's values (recruitment, SSB, catches, F, by year) were printed in full while its format was checked. (2) The sardine Table 3 and anchovy Table 2 values were printed while the parser was built, and the annual catch totals for a few years (1987, 2004, 2020) to check the tables' reading order. (3) To fix how the new prey series line up with EW2's, the new prey series were correlated with Cury et al.'s prey columns (series 2 and 18 of the SOM), prey only, at lags −2 to +3 and as raw values or logarithms (section 3). (4) Presence (years with a value) of the breeding-success series. No breeding-success value of the 985565 file was displayed, and no statistic relating a prey or catch series to a breeding series was computed. EW2's own data (Cury et al.'s z-scores to 2009) were read in EW2, and EW2's result is known; section 5 reports the rows EW2 did not test apart.

## 3. Stocks and series

| Stock | Prey in year *t* | Draw in year *t* | Dependents | Role |
|---|---|---|---|---|
| BEN | November survey biomass of sardine west of Cape Agulhas plus anchovy (to Port Alfred), survey of year *t* | catch of sardine west of Cape Agulhas plus anchovy, calendar year *t* | Cape gannets at Malgas and Lambert's Bay, African penguins at Robben Island (EW2's three) | **primary** |
| ROST | the herring year class born in *t*, read as ICES recruitment at age 2 in *t* + 2 | herring catch, year *t* | Atlantic puffins at Røst | **primary** |
| BEN4 | as BEN | as BEN | as BEN, with African penguins at Dassen Island | secondary |
| ROST2 | as ROST | as ROST | puffins and both Røst kittiwake colonies | secondary |

**How the series were matched to EW2's.** Against Cury et al.'s BEN prey (1988–2009), the sum of sardine west of Cape Agulhas and anchovy in the same year correlates 0.87 as raw values (0.79 as logarithms; 0.78 a year off). Against Cury et al.'s ROST age-0 herring (VPA, 1 January; 1964–2009), ICES recruitment at age 2 two years later correlates 0.95 as raw values (0.73 as logarithms; 0.35 and 0.19 one year off). So the prey is read as raw values, z-scored per series as Cury et al. did, BEN in the survey's year, ROST two years before the recruitment year. The anchovy survey covers the area to Port Alfred, not only west of Cape Agulhas, and the sardine and anchovy series were revised in 2024 (Coetzee et al. 2024a, cited in the data record); the 0.87 measures how far the new BEN series is the old one.

**Scope.** Unchanged from EW2 (Saraux et al. 2021): the gannets take 1.8–4.0% of the sardine and 0.3–0.9% of the anchovy near their need; the puffins' take reaches the observed herring series only through spawners years later. Shetland and the Farallon birds are not run: their prey series to 2020 were not obtained.

**Layout (presence only, `results/ew3/layout.json`).** BEN: prey 1984–2022 without 2021, catch 1984–2023, usable years 1992–2020 (29), 10 failure years; 15 of them are years EW2 did not test. ROST: prey 1986–2023, catch 1988–2024, usable years 1994–2021 (28), 9 failure years; 21 not tested in EW2.

## 4. The test

EW2's section 4, with one change: the covariates are EW2's four level covariates (the prey level in year *t*, its square, the level in year *t*−1, the window's slope) and the draw, the z-scored catch in year *t* and in year *t*−1. The partial correlation, its Fisher z with √(*N*\* − *q* − 3) for *q* = 6 covariates, Pyper and Peterman's *N*\*, Stouffer's combination over BEN and ROST and the one-sided *p* are EW2's code (`ew2.pp_test`), unchanged. The dependents' index is the mean of the dependents' breeding success, each series z-scored over all its years in the file.

## 5. Verdicts (frozen)

| Verdict | Rule | Passed if |
|---|---|---|
| **V1** (AR1) | the combined one-sided test for lag-1 autocorrelation, BEN and ROST, 8-year window, level and draw | *p* ≥ 0.025 |
| **V2** (variance) | the same for variance | *p* ≥ 0.025 |

Either failing meets T6's refutation clause (familywise level 0.05 over the two). Reported only: R1 no covariates; R4 EW2's level covariates without the draw; R2 windows of 6 and 10 years; R5 the primary test on the rows EW2 did not test; R3 each stock alone, BEN4 and ROST2; each stock's *r* and *N*\*; after the run, the combined partial correlation and its 95% interval (`posthoc_ew3.py`, not a verdict), as in EW2.

**Reading a result (frozen).** As EW2's section 5. In addition: EW2's estimate is resolved toward T6 if both pass and the combined interval for AR1 excludes 0.3, the size EW2 found; toward the refutation if either fails; and left open if both pass and the interval still contains 0.3. R5 is read the same way but has about half the rows.

## 6. Dry runs (frozen with the code; `results/ew3/dry.json`)

EW2's generators (its section 6), on EW3's calendar and presence, with three changes: the observed prey is the level itself plus observation noise (sd 0.2 of the level's standard deviation; 0.4 in G0n), z-scored, since the field series are read as raw values; the catch is observed, the draw times the level with lognormal noise of sd 0.1, z-scored; and one more null, G6, in which breeding success also falls with the catch. 2000 replicates per generator, α = 0.025 per statistic:

| Generator | What it is | Rejects V1 (AR1) | Rejects V2 (variance) | Level covariates only (AR1, variance) |
|---|---|---|---|---|
| G0 | no feedback, need on the level (T6's uncoupled side) | 0.015 | 0.013 | 0.018, 0.016 |
| G0s | as G0, a sigmoid need at a third of capacity | 0.023 | 0.015 | 0.021, 0.016 |
| G0n | as G0, observation noise 0.4 | 0.018 | 0.013 | 0.021, 0.013 |
| G5 | as G0, the need on last year's level | 0.022 | 0.009 | 0.024, 0.015 |
| G0r | as G0, breeding-success noise AR(1) 0.5 | 0.024 | 0.030 | 0.024, 0.024 |
| G6 | as G0, breeding success also lowered by the catch (competition with the fishery) | 0.021 | 0.014 | 0.024, 0.011 |
| G1 | feedback of the measured size (3% at X = 1/3) | 0.026 | 0.015 | 0.028, 0.017 |
| G2 | feedback of the coupled case (40% at X = 1/3) | 0.022 | 0.011 | 0.021, 0.013 |
| G3a | a need on the prey's recent autocorrelation (EW2's effect size) | **0.914** | 0.031 | 0.842, 0.032 |
| G3b | the same on the window variance | 0.041 | **0.876** | 0.035, 0.767 |
| G4 | a shared driver of the stock's noise and breeding success | 0.021 | 0.027 | 0.018, 0.028 |
| G4s | a strong shared driver | 0.027 | 0.054 | 0.029, 0.060 |

**Acceptance rule (EW2's, fixed before the dry runs):** every null generator (G0, G0s, G0n, G5, G0r and here G6) rejects at most 0.045 per statistic. Met (largest 0.030). Against EW2's effect (a need on the prey's recent statistic explaining a quarter to a half of breeding success beyond the level), the power is 0.91 (AR1) and 0.88 (variance), against EW2's 0.69 and 0.74. As in EW2, feedback (G1, G2) and these shared drivers are not seen; the strong shared driver reaches 0.054 on variance, above the nominal level but not a null.

## 7. Run

```bash
python3 ew3_data.py <985565.csv> <sag_21106.json> <sardine.pdf> <anchovy.pdf> <series.csv>
```

```bash
python3 -I ew3.py layout <series.csv>
```

```bash
python3 -I ew3.py dry 2000
```

```bash
python3 -I ew3.py test <series.csv>
```

`test` writes `results/ew3/test.json`. No parameter is chosen after the freeze.

## 8. Limits stated before the run

- Longer, not long: 29 and 28 usable years, 10 and 9 failure years. Half the BEN rows and a quarter of the ROST rows were in EW2's test, so V1 and V2 are not independent of EW2; R5 is, at lower power.
- The series are not Cury et al.'s: the Benguela series were revised in 2024 and the anchovy is surveyed to Port Alfred; the herring is a 2025 assessment read two years after birth. Both are assessment or survey outputs, not measurements of the birds' prey at their colonies.
- The draw is the catch in the stock's area, in tonnes: for ROST it is taken from the adults, not from the year class read as the prey.
- Failure is relative (the lowest third of usable years), as in EW2.
- Feedback is not seen by the design (EW2's dry runs, here G1 and G2); the birds' small share rests on Saraux et al.
