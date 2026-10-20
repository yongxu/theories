# EW2: frozen predictions for thesis T6's uncoupled side on forage fish and seabirds

Board item EW2, 21 October 2026. AI-written (a Claude Code session started from the theses-and-conjectures session). Frozen before any statistic of a field series was computed; the commit that lands this file on main is the freeze, and `results/FROZEN-AT` names it. Literature and data check: [significance review, "forage fish and seabirds"](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#seabird-warnings-check).

## 1. What is tested

Thesis T6 ([chapter](../../theories/becoming/chapters/THE-THEORY-OF-BECOMING.md#t6-a-break-is-seen-coming-only-through-what-couples-into-what-breaks)), as EW1 corrected it: a statistical early warning reads the observed condition's own rate of return; before a dependent's break the drawn stock's statistics rise exactly as much as before the same drawdown with no break; they read the decline, never where the need lies. *Refuted by:* a drawn stock whose dependent takes a negligible share of it, whose variance or lag-1 autocorrelation before the dependent's break exceeds what the stock's own level and draw predict, against periods of the same stock at the same level with no break.

Read operationally, the clause says that given the stock's level path, the stock's early-warning statistics carry no information on whether the dependent fails. The test is that conditional independence, in stocks where the birds take a small share near their need. It is not a test of feedback: the dry runs (section 6) show that the matched comparison does not see feedback of the birds onto the stock, even at a 40% share, because feedback that depends on the level is matched away with it. Whether the birds take a negligible share is a premise, measured apart from the test (section 3) from Saraux et al.'s (2021) published consumption estimates.

## 2. Source, extraction and what was seen before the freeze

- **Data.** Cury et al., *Science* 334:1703 (2011), the authors' accepted version with its Supporting Online Material (Archimer 00056/16770, file `14307.pdf`, 67 pages, sha256 `5c1f8840d3538a3034b660da3face5ab697ffb33597e24fef469b81bdaa031f1`). The SOM prints the complete dataset of the paper, normalized per series (each column a z-score over the series' years): 488 rows of year, breeding success, prey abundance, ecosystem, colour, species, prey label and series number, 19 series (one row prints its series as `3"2`, read as series 3). The text layer was read with macOS PDFKit ([`pdftext.js`](pdftext.js)) and the rows written by `ew2.py extract` (CSV sha256 `21effb24ecb14b7a5be170b4aef0342e90f27795d0561af40045aa2c1ab59ca5`). Neither file is committed.
- **Scope data.** Saraux et al., *Fish and Fisheries* 22:262 (2021), data on Mendeley Data (doi 10.17632/5bb8nhb6hr.1, `Data_downloaded.csv`, sha256 `79fc3e3db0140fcf3f9df6f9f06a744490aa27245c485e08a321d13517e84416`, matching the repository's hash). Free downloads of 1-2 MB each; no paid data.
- **Seen before the freeze, disclosed.** While checking the extracted format, the rows 1987-2010 of series 19 (Røst kittiwakes; its prey column is the age-0 herring series of the primary stock ROST, z-scored over the same years as series 18) and the first four rows of series 1 (Scotia Sea) were displayed. From Saraux et al.'s file, only the shares of the stock consumed were summarized, in bands of the stock's level relative to its maximum (section 3); that summary reads stock biomass but no breeding success. No early-warning statistic, no failure year and no relation between a prey series and a breeding series was computed before the freeze. Cury et al.'s published finding (breeding success falls below about a third of the largest prey biomass) is known and is what the level adjustment removes.

## 3. Stocks, scope and layout

The birds' share of the stock near their need, from Saraux et al.'s data, in the years when the stock stood at 25-45% of its largest value (Cury et al.'s need is about 33%):

| Stock | Dependents in Cury et al. | Birds' share of the stock near the need | Role here |
|---|---|---|---|
| BEN: sardine and anchovy spawner biomass west of Cape Agulhas (November acoustic survey) | Cape gannets (Malgas, Lambert's Bay), African penguins (Robben Island) | Cape gannets 1.8-4.0% of sardine (median 2.9%), 0.3-0.9% of anchovy; penguins unmeasured | **primary** |
| ROST: age-0 Norwegian spring-spawning herring (ICES VPA, 1 January) | Atlantic puffins, Røst | 4.3-11.0% (median 8.4%, minimum-consumption scenario; 3 years in the band) | **primary** |
| SHE: Shetland sandeel (VPA, then trawl survey) | Arctic skua, great skua, Arctic tern, kittiwake (Foula) | the whole seabird community 26-96% (3 years, 1977, 1986, 2000) | secondary: the coupled case |
| CAL: juvenile rockfish index (NMFS trawl survey, May-June) | common murre, rhinoceros auklet, pigeon guillemot (Southeast Farallon) | unmeasured | secondary |
| ROST2: as ROST | puffins and kittiwakes | as ROST | secondary |

Excluded before reading: Scotia Sea krill (21 values, longest run 9 years: no complete window), New Zealand euphausiid availability (16 values, longest run 10; an index read from gulls' regurgitations), Gulf of Alaska (three colonies in each of five years, not a time series).

**Why ROST is in scope.** The share puffins take near the need (4-11%) is not negligible as a share of a year class, so this is argued on mechanism. The observed condition is the age-0 herring index as of 1 January, before the puffins eat that year class, and the next year's index is a new year class from the spawning stock. The puffins' take reaches the observed series only through spawners three or more years later, by a few percent of a year class whose natural mortality is far larger. The herring's recruitment is weakly related to its spawning stock (Sætre, Toresen and Anker-Nilssen 2002, cited by Saraux et al.), so even that route is weak. So the birds' feedback onto the observed series' dynamics is negligible, whatever their share of the year class. BEN's survey follows most of the gannets' consumption (Saraux et al. corrected for it; Cury et al.'s series is the survey's), at 1-4%.

**Layout (presence only, `results/layout.json`).** With the 8-year window: BEN prey 1988-2009 complete, usable years 1996-2009 (14), 5 failure years; ROST prey 1964-2009 without 1998, usable years 1972-1997 and 2007-2009 (29), 10 failure years. Secondary: CAL 17 usable years, SHE 22, ROST2 29.

**Step 1's stop rule and the best-case power** ([`power_bestcase.py`](power_bestcase.py), [`results/power_bestcase.log`](results/power_bestcase.log), generators only). The rule, fixed before the check was run: proceed only if a test calibrated exactly on a threshold-only generator reaches power at least 0.5, on the in-scope stocks, against an effect in which the prey's earlier-window statistic explains a quarter of breeding success's variance beyond the level. At an 8-year window the power was 0.30 (AR1) and 0.35 (variance) for BEN alone, 0.66 and 0.72 for BEN with ROST, and 0.92 and 0.93 for all four stocks. With ROST in scope by the argument above, the rule is met; for BEN alone it is not. Both figures are reported, and the verdict depends on ROST's place in scope. (The first run of the check had the effect's sign reversed and gave power 0.00 everywhere; corrected and rerun before any other step.)

## 4. The test

For each usable year *t* of a stock (prey present at *t* and at each of the 8 years before it; the dependents' index present at *t*):

- **The dependents' index** is the mean of the available breeding-success z-scores of the stock's dependents in year *t*. A **failure year** is one of the round(*m*/3) lowest values of the index among the stock's *m* usable years.
- **The window statistics** are computed on the prey z-scores of the years *t*−8 … *t*−1, detrended by a least-squares line: lag-1 autocorrelation (sum of products of successive residuals over the sum of squares) and variance (sum of squares over 6).
- **The level covariates** are the prey level in year *t*, its square, the level in year *t*−1, and the window's slope: the end, the curvature of the need and the drawdown that led there. The draw (the catch) is not in the dataset and is not adjusted for (section 8).
- **Per stock**: the partial correlation *r* between failure and the window statistic given the covariates (both regressed on an intercept and the four covariates, the residuals correlated). Its Fisher z is scaled by √(*N*\* − 7), where *N*\* is the effective size of the two residual series (Pyper and Peterman 1998: 1/*N*\* = 1/*N* + (2/*N*)Σ_{k≤N/5} ((*N*−*k*)/*N*) ρ₁(*k*)ρ₂(*k*), capped at *N*).
- **Combined** over BEN and ROST by Stouffer's rule with weights √(*N*\* − 7); one-sided normal *p* for a statistic higher before failure years.

## 5. Verdicts (frozen)

| Verdict | Rule | Passed if |
|---|---|---|
| **V1** (AR1) | the combined one-sided test for lag-1 autocorrelation, BEN and ROST, 8-year window | *p* ≥ 0.025 |
| **V2** (variance) | the same for variance | *p* ≥ 0.025 |

Either failing meets T6's refutation clause as worded (familywise level 0.05 over the two). Reported only, no verdict: R1, the same test with no level covariates (T6 allows a positive unadjusted association where failures follow the stock's decline); R2, windows of 6 and 10 years; R3, each stock alone, and the secondary stocks CAL, SHE (the coupled case, where T6 forbids nothing) and ROST2; and the two-sided *p* and each stock's *r* and *N*\*.

**Reading a result (frozen).**
- *Both pass.* No information on the dependents' failure was found in the prey's statistics beyond the level path, where the birds' feedback onto the observed series is small. This is weak support. The dry runs give power about 0.7 only against an association explaining a quarter (ROST) to a half (BEN's averaged index) of breeding success's variance beyond the level. Smaller associations, shared environmental drivers of the strength tried, and the birds' feedback are not seen. T6's evidence line records a pass of limited power.
- *Either fails.* The clause is met: before the dependents' failures, the stock's statistics exceed what its level path predicts. The failure is kept, and read through R1-R3: one stock or both, which statistic, whether the window matters. The test cannot tell a need that lies partly in the prey's variability from a shared driver. Either way, T6's "given the stock's own course" would need more than the level path: the course would have to include what drives the stock's variability, or the need would lie partly in it.

## 6. Dry runs (frozen with the code; `results/dry.json`)

The generators have the primary stocks' exact layout (calendar, gaps, three Benguela dependents with their missing years). The stock follows Ricker renewal with carrying capacity 1, X′ = X·exp(1 − X − e − s + σε), σ = 0.4. The draw *e* rises from 0.1 to a random peak of 0.5-0.95 and falls (random phase, 0.5-1.5 cycles). The observed prey is log X plus observation noise of sd 0.2, z-scored. Breeding success follows Cury et al.'s asymptote 1 − exp(−X/0.12), plus noise of sd 0.25, z-scored. 2000 replicates per generator, α = 0.025 per statistic:

| Generator | What it is | Rejects V1 (AR1) | Rejects V2 (variance) |
|---|---|---|---|
| G0 | no feedback, need on the level (T6's uncoupled side) | 0.019 | 0.020 |
| G0s | as G0, a sigmoid need at a third of capacity | 0.021 | 0.015 |
| G0n | as G0, observation noise 0.4 | 0.018 | 0.021 |
| G5 | as G0, the need on last year's level (index a year off) | 0.015 | 0.021 |
| G0r | as G0, breeding-success noise AR(1) 0.5 | 0.028 | 0.034 |
| G1 | feedback of the measured size: share 0.013·B/(0.1 + X), 3% at X = 1/3; bird numbers B follow breeding success | 0.015 | 0.017 |
| G2 | feedback of the coupled case: 40% at X = 1/3 | 0.019 | 0.019 |
| G3a | a need on the prey's recent autocorrelation (partial R² beyond level 0.25 for ROST's one dependent, about 0.5 for BEN's mean of three) | **0.690** | 0.092 |
| G3b | the same on the window variance | 0.090 | **0.735** |
| G4 | a shared driver: AR(1) environment raises the stock's noise (σ·e^{0.35E}) and lowers breeding success by 0.1E | 0.021 | 0.025 |
| G4s | a strong shared driver (σ·e^{0.7E}, breeding success −0.2E) | 0.024 | 0.025 |

**Acceptance rule (fixed before the dry runs):** every null generator (G0, G0s, G0n, G5, G0r) rejects at most 0.045 per statistic. Met (largest 0.034).

**The first design failed it, and was replaced before any field value was read.** The first design computed *p* by a conditional randomization test: circular shifts of each dependent's residual on the covariates, the fitted values kept, failures recomputed, 499 surrogates. It rejected at 0.046-0.057 under G0, G0s, G0n and G5 and at 0.056/0.073 under G0r, about twice the nominal rate. The observed residual is orthogonal to the covariates in sample and its shifts are not, so the observed configuration is not exchangeable with the surrogates. A leverage correction and a variance inflation of the residuals did not fix it (0.035-0.056 in a 1000-replicate check). The plain analytic test (no effective-size correction) held at 0.022-0.032 under those four but rejected at 0.049/0.055 under G0r (2000 replicates each). The Pyper-Peterman test, frozen above, holds under all five nulls. The first design's rates stay in `dry.json` (`first_design_*`).

What the dry runs show beyond acceptance: the matched comparison sees an association of the dependent's failure with the prey's statistic itself (G3) and not the routes by which T6 could fail through the stock's dynamics. Feedback (G1, G2) is matched away with the level, and these shared drivers (G4, G4s) dilute over an 8-year window.

## 7. Run

```bash
python3 -I ew2.py dry 2000
python3 -I ew2.py test /path/to/cury2011_som_data.csv
```

`test` writes `results/test.json` with V1, V2 and everything reported only. No parameter is chosen after the freeze.

## 8. Limits stated before the run

- The series are short: 14 and 29 usable years, 5 and 10 failure years. The test detects only strong associations.
- The data are z-scores. Within-series statistics are unaffected, but levels relative to the maximum cannot be computed, so the scope bands of section 3 rest on Saraux et al.'s raw biomass, not on Cury et al.'s series.
- The draw is not adjusted for: catches are not in the dataset. In the theory's linearization the return rate of one renewal under one form of draw is a function of the level, so the level path stands in for level and draw. A change in the form of the draw (the herring fishery's collapse and later quotas; Benguela's quotas) is not captured. Fishing also raises variability through age truncation (Hsieh et al. 2006; Anderson et al. 2008), beyond what the level predicts.
- ROST's prey is an assessment output (VPA), not a measurement; BEN's is a survey of two species summed.
- Failure is relative: the lowest third of each stock's usable years, not an absolute breeding failure.
- The dependents are averaged into one index per stock: BEN's three, ROST's puffins (the Røst kittiwakes are secondary, as Cury et al.'s SOM reports white-tailed eagle predation driving their breeding success from the mid-1990s).
- BEN's African penguins' share of the stock is unmeasured.
