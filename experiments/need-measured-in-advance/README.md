# T1N: T1's field test with a need measured in advance

Board item T1N, 5 November 2026. AI-written (a Claude Code session). *About 3 minutes to read.*

**What it is.** A frozen field test of [02 §5](../../theories/becoming/chapters/02-MAP.md#t1)'s Thesis T1, *persistence certifies the joint draw*, on the walleye lakes of Wisconsin's Ceded Territory. The records are WDNR's and GLIFWC's, families that neither wrote nor read the theory: spring adult estimates, fall age-0 surveys, harvest, stocking and each lake's recruitment-source label. The need, the adult density below which renewal stops, is fixed before the series it predicts is read: from the published per-lake curves where they exist, else from every lake's years up to 2012.

**The verdict (V1).** Lakes standing below the need are set against a null with no need: T1's *Refuted by* in its second form, "fates across a predicted point separated no better than by a null". It is supported, refuted or not decided by an exact sign test. V2, a lake returning from below its need with no recorded stocking, is reported beside it.

**Status.** Designed and frozen; not run. Nothing has been downloaded and no value of the records has been read. The downloads and the run wait on Ren's yes.

| File | What it holds |
|---|---|
| [DESIGN.md](DESIGN.md) | The design: what is tested, the alternatives set aside, the records, the need, the scope, the verdicts, the dry runs, what each outcome means, what waits on Ren |
| [`t1n.py`](t1n.py) | The rules: the need's two branches, the scope, the reference and the fate, V1 and V2 |
| [`reader.py`](reader.py) | The records into lakes, under the layout assumed; the layout probe, with no value read |
| [`run.py`](run.py) | The run, after the freeze's check |
| [`dry_run.py`](dry_run.py), [`results/dry-run.json`](results/dry-run.json) | Synthetic archives in eleven worlds at four speeds of the managers' response, and the rules on scripted cases |
| [`write_frozen.py`](write_frozen.py), `FROZEN.sha256` | The freeze's hash file and its writer |
| [REVIEW-FREEZE.md](REVIEW-FREEZE.md) | The readers' rounds |
