# The tools behind T1N's reach

AI-written (a Claude Code session), 6 November 2026. *One minute to read.*

What made [`../results/reach-input/`](../results/reach-input/), [`../results/reach-readings.json`](../results/reach-readings.json), [`../results/reach-with-glifwc.json`](../results/reach-with-glifwc.json) and [`../results/reports-manifest.json`](../results/reports-manifest.json), kept so the lists can be regenerated and checked ([the record](../LAYOUT.md)). They print counts or masked rows, and the lists kept in the repository hold lake, year, label, the name as parsed and where it was read, with no value. The OCR's output and the intermediate lists of `gfall2.py` and `gearly.py`, outside the repository, hold whole rows, values included, on disk and unread. They are not part of T1N's freeze.

1. `fetch_reports.py` downloads the reports `report-links.tsv` lists, from the two agencies' listing pages, writing the manifest.
2. `pdftext.swift` extracts each PDF's text layer; `pdfocr.swift` runs the Mac's Vision OCR on pages with none, `imgpages.py` finding them, and `pdfocr2.swift` runs it at a chosen rotation, which `candpages.py` and `rotocr.py` use on GLIFWC's reports whose tables lie on their side.
3. `rows.py` turns OCR boxes into rows. `wdnrfall2.py` lists WDNR's fall lake-years, and `gfall2.py` and `gearly.py` GLIFWC's, for its later and earlier reports.
4. `aliases_apply.py` fills the lake code of parsed rows from `aliases.csv`, a list of renamed and misread names with the reason for each, and `union.py` writes the two lists, `fall-listed.csv` and `fall-generous.csv`, which [`../reach.py`](../reach.py) reads with R1 and R5.
5. `readings.py` counts what the ceiling rests on, and R1's plain facts, into `reach-readings.json`.
6. For [`../results/reach-with-glifwc.json`](../results/reach-with-glifwc.json): `gspring.py` and `gspring2.py` list GLIFWC's spring lake-years (the second for the two years the first did not parse), `spring_list.py` writes them as `spring-glifwc.csv`, `wdnrfall3.py` is a fuller list of WDNR's fall lake-years, `widen_struct.py` writes the grid under four readings of GLIFWC's codes, and `widen_read.py` runs [`../reach.py`](../reach.py) on them and `structdry.py`, which puts on the grid the values of the 30 of T1N's 48 worlds whose settings it carries. Each archive's seed is fixed, so the worlds repeat exactly.

The rows were not checked against the pages, so the lists are an approximation: `LAYOUT.md` says what rests on them.
