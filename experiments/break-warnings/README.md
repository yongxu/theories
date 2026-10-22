# Early warnings before a dependent's break, in the field

Board item EW2, 21 October 2026. AI-written (a Claude Code session started from the theses-and-conjectures session). Literature and data check: [significance review, "forage fish and seabirds"](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#seabird-warnings-check).

Thesis T6's uncoupled side ([chapter](../../theories/becoming/chapters/THE-THEORY-OF-BECOMING.md#t6-a-break-is-seen-coming-only-through-what-couples-into-what-breaks)) says that a drawn stock's early-warning statistics read its own decline and never where a dependent's need lies. EW1 found that a simulation of this side has its verdict fixed by the generator, so only real dependents with a measured need can fail it. Cury et al. (2011) measured such a need: seabird breeding success falls below about a third of the largest forage-fish biomass. Their Supporting Online Material prints every series. This experiment tests, in the two stocks where the birds' feedback onto the observed series is small (Benguela sardine and anchovy; Røst's age-0 herring), whether the prey's lag-1 autocorrelation or variance before the birds' poor years exceeds what the prey's level path predicts.

| File | What it is |
|---|---|
| [PREDICTIONS-2026-10-21-EW2.md](PREDICTIONS-2026-10-21-EW2.md) | Source, extraction and disclosure; scope from Saraux et al.'s (2021) consumption data; the layout; the stop rule and its best-case power; the test; verdicts V1-V2 and reading rules; dry runs and the first design's failed acceptance; limits. Frozen before any statistic of a field series was computed (`results/FROZEN-AT`) |
| [ew2.py](ew2.py) | Extraction, presence-only layout, the generators and dry runs, the frozen test |
| [power_bestcase.py](power_bestcase.py) | Step 1: the best-case power at the field's series lengths, which decided that a test could be supported |
| [posthoc_ew2.py](posthoc_ew2.py) | After the run, not a verdict: the combined partial correlation and its 95% interval, from `test.json` alone |
| [pdftext.js](pdftext.js) | Reads the SOM's text layer (macOS PDFKit) |
| [results/](results/) | `power_bestcase.log`, `layout.json`, `dry.json`, `FROZEN-AT` (the freeze, `44ced15e8`, landed on main before the run); after the run, `test.json` and `posthoc.json` |

To reproduce (Python 3.11, standard library only; the dry runs take about three minutes over 12 cores):

```bash
python3 -I ew2.py dry 2000
```

The test needs the authors' accepted version with the SOM (Archimer 00056/16770, `14307.pdf`, sha256 `5c1f8840d3538a3034b660da3face5ab697ffb33597e24fef469b81bdaa031f1`), read outside the repository. Neither the PDF nor the extract is committed.

```bash
osascript -l JavaScript pdftext.js /absolute/path/14307.pdf > som.txt
```

```bash
python3 -I ew2.py extract som.txt cury2011_som_data.csv
```

```bash
python3 -I ew2.py test cury2011_som_data.csv
```

## Results

Run once, after the freeze landed on main (`44ced15e8`), with nothing changed. Study section [289](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#289-early-warnings-before-seabird-breeding-failures-in-the-field-ew2).

| Verdict | Statistic | Result |
|---|---|---|
| V1 | lag-1 autocorrelation of the prey's 8-year window before the year, given the level path; Benguela (14 years, 5 poor) and Røst (29 years, 10 poor) | **passed**: Z = 1.66, one-sided p = 0.048 ≥ 0.025; partial r 0.43 (Benguela), 0.26 (Røst) |
| V2 | variance of the same window | **passed**: Z = 1.43, p = 0.076; partial r 0.40, 0.23 |

**What the pass says.** At the frozen level, no information on the birds' poor years was found in the prey's statistics beyond the prey's level path, in the two stocks where the birds' feedback on the observed series is small. The pass is weak. Every estimate lies in the direction the refutation clause names. The combined partial correlation is 0.30 for autocorrelation (95% interval −0.06 to 0.59) and 0.26 for variance (−0.10 to 0.57), computed after the run from the frozen statistic (`posthoc_ew2.py`, not a verdict). The interval runs from no association to a partial correlation of about 0.6 between the poor years and the statistic. AR1's one-sided p would have been below 0.05 as a single test; the frozen familywise rule set 0.025 for each of two.

**Reported only (`test.json`).**

| Report | AR1: combined r (95% interval) | Variance |
|---|---|---|
| R1, no level adjustment | 0.23 (−0.10 to 0.52) | 0.10 (−0.23 to 0.42) |
| R2, 6-year window | 0.30 (−0.04 to 0.57) | 0.27 (−0.07 to 0.55) |
| R2, 10-year window | 0.01 (−0.39 to 0.40) | 0.19 (−0.23 to 0.54) |
| R3, Benguela alone | 0.43 (−0.28 to 0.83) | 0.40 (−0.37 to 0.84) |
| R3, Røst alone | 0.26 (−0.15 to 0.59) | 0.23 (−0.19 to 0.57) |
| R3, Røst with its kittiwakes | 0.16 (−0.27 to 0.54) | 0.32 (−0.09 to 0.64) |
| R3, Farallon (share unmeasured) | 0.12 (−0.46 to 0.63) | −0.04 (−0.58 to 0.53) |
| R3, Shetland (the coupled case) | 0.01 (−0.55 to 0.57) | −0.04 (−0.63 to 0.58) |

Three points. Adjusting for the level raised Røst's association (unadjusted r 0.08 for AR1, adjusted 0.26), so what the estimate carries is not the stock's decline. The 10-year window loses Røst's autocorrelation (−0.08) and keeps Benguela's. Shetland, where the seabirds take a large share and T6 forbids nothing, shows nothing, as do the Farallon birds.

**Limits.** Two short series (14 and 29 usable years) and power about 0.7 only against an association explaining a quarter to a half of breeding success beyond the level. The draw is not adjusted for. The data are z-scores, and Røst's prey is an assessment output. Feedback cannot be seen by this design; that the birds take little was measured apart (Saraux et al. 2021). The frozen limits are in section 8 of the predictions.

**Next.** The same frozen test on longer and unread series: Sydeman et al.'s breeding success to 2023 (BCO-DMO 985565) with the Benguela surveys, the Norwegian herring assessments and the Farallon juvenile rockfish index brought forward, with the catch as the draw. The design is fixed already; only the series and the dry runs' layout change.

## EW3: the same test on longer series, with the catch as the draw

Board item EW3, 22 October 2026. EW2's frozen test, unchanged, on series to 2020-2021 that EW2 did not read: Sydeman et al.'s breeding success (BCO-DMO 985565), the 2024 South African sardine and anchovy assessment data records, and ICES's 2025 assessment of Norwegian spring-spawning herring. The catch in the year and the year before enter as the draw, beside EW2's four level covariates.

| File | What it is |
|---|---|
| [PREDICTIONS-2026-10-22-EW3.md](PREDICTIONS-2026-10-22-EW3.md) | Sources and hashes, what was seen before the freeze, how the new series match EW2's, the layout, what differs in the test, verdicts V1-V2 and reading rules, dry runs, limits. Frozen before any statistic relating a prey series to a breeding series was computed (`results/ew3/FROZEN-AT`) |
| [ew3_data.py](ew3_data.py) | Reads the four sources into one CSV of series (pypdf for the two PDFs) |
| [ew3.py](ew3.py) | The layout, the generators and dry runs, and the frozen test, on EW2's statistics (`ew2.py`) |
| [posthoc_ew3.py](posthoc_ew3.py) | After the run, not a verdict: the combined partial correlation and its 95% interval |
| [results/ew3/](results/ew3/) | `layout.json`, `dry.json`, `FROZEN-AT`; after the run, `test.json` and `posthoc.json` |
