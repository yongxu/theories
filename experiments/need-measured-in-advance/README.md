# T1N: T1's field test with a need measured in advance

Board item T1N, 5 November 2026. AI-written (a Claude Code session). *About 4 to 6 minutes to read.*

**What it is.** A field test of [02 §5](../../theories/becoming/chapters/02-MAP.md#t1)'s Thesis T1, *persistence certifies the joint draw*, on the walleye lakes of Wisconsin's Ceded Territory, designed to be frozen before any value it reads is seen. The records are WDNR's and GLIFWC's, families that neither wrote nor read the theory: spring adult estimates with their intervals, fall age-0 surveys, harvest, stocking and each lake's recruitment-source label. The need, the adult density below which renewal grows rare, is fitted on every lake's years up to 2012 and tested on the years after.

**The verdict (V1).** T1's *Refuted by* in its second form, "fates across a predicted point separated no better than by a null". A lake's fate is a decline of its adults by a ratio test on the recorders' own intervals, not undone by a recovery, read the same way on either side of the need. Lakes below the need, with no year class pending from the three falls before, are set against a null with no need. Where they fell by an exact sign test, and more often than the lakes above the need by Fisher's exact test, V1 reads "*Refuted by*'s second form not met: the fates separated across the need", counts the lakes that came back above it, and adds "the need's causal role not shown". It is not "T1 supported": renewal lost for years to another cause gives the same, so the test's value is mainly its chance to refute. V1 is refuted where they fell no more than the null allows, always with a clause these rules cannot remove, "unless the estimates are distorted at low density beyond what the doubled intervals cover" (DESIGN.md §7), and not decided otherwise. Reported beside it: V2, a lake returning from below its need with no recorded stocking and its label natural throughout, and renewal below the need after 2012 against what the need's fit expects.

**Status.** Designed, with its dry run passing, and read by one reader in six rounds, the last finding nothing of high or medium severity ([REVIEW-FREEZE.md](REVIEW-FREEZE.md)). It is frozen by the commit that adds `FROZEN.sha256`. Not run. Nothing has been downloaded, and no value of the records has been read, save the few a search summary showed one reader for three lakes (DESIGN.md §9). The downloads and the run wait on Ren's yes.

| File | What it holds |
|---|---|
| [DESIGN.md](DESIGN.md) | The design: what is tested, the alternatives set aside, the records, the need, the scope, the premise, the reference and the fate, the verdicts, the dry runs, what each outcome means, what waits on Ren |
| [`t1n.py`](t1n.py) | The rules: the need, the premise, the scope, the ratio test, the reference and the fate, V1, V2 and the reports |
| [`reader.py`](reader.py), [`layout.json`](layout.json) | The records into lakes, under the layout assumed; the layout probe and its structural facts, with no value read |
| [`run.py`](run.py) | The run, after the freeze's chain and the inputs' hashes are checked; kept once |
| [`dry_run.py`](dry_run.py), [`results/dry-run.json`](results/dry-run.json) | Synthetic archives in 48 worlds at four speeds of the managers' response, three of them again at 900 lakes; the rules on scripted cases; the reader, the run and the freeze's chain checked |
| [`write_frozen.py`](write_frozen.py), `FROZEN.sha256` | The freeze's hash file, written last, and its writer |
| [REVIEW-FREEZE.md](REVIEW-FREEZE.md) | The readers' rounds |
