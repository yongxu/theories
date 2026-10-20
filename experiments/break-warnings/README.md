# Early warnings before a dependent's break, in the field

Board item EW2, 21 October 2026. AI-written (a Claude Code session started from the theses-and-conjectures session). Literature and data check: [significance review, "forage fish and seabirds"](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md#seabird-warnings-check).

Thesis T6's uncoupled side ([chapter](../../theories/becoming/chapters/THE-THEORY-OF-BECOMING.md#t6-a-break-is-seen-coming-only-through-what-couples-into-what-breaks)) says that a drawn stock's early-warning statistics read its own decline and never where a dependent's need lies. EW1 found that a simulation of this side has its verdict fixed by the generator, so only real dependents with a measured need can fail it. Cury et al. (2011) measured such a need: seabird breeding success falls below about a third of the largest forage-fish biomass. Their Supporting Online Material prints every series. This experiment tests, in the two stocks where the birds' feedback onto the observed series is small (Benguela sardine and anchovy; Røst's age-0 herring), whether the prey's lag-1 autocorrelation or variance before the birds' poor years exceeds what the prey's level path predicts.

| File | What it is |
|---|---|
| [PREDICTIONS-2026-10-21-EW2.md](PREDICTIONS-2026-10-21-EW2.md) | Source, extraction and disclosure; scope from Saraux et al.'s (2021) consumption data; the layout; the stop rule and its best-case power; the test; verdicts V1-V2 and reading rules; dry runs and the first design's failed acceptance; limits. Frozen before any statistic of a field series was computed (`results/FROZEN-AT`) |
| [ew2.py](ew2.py) | Extraction, presence-only layout, the generators and dry runs, the frozen test |
| [power_bestcase.py](power_bestcase.py) | Step 1: the best-case power at the field's series lengths, which decided that a test could be supported |
| [pdftext.js](pdftext.js) | Reads the SOM's text layer (macOS PDFKit) |
| [results/](results/) | `power_bestcase.log`, `layout.json`, `dry.json`, `FROZEN-AT`; after the run, `test.json` |

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

Not yet run: the predictions are frozen and the test has not read the field series.
