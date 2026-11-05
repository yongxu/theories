# T1R: whether natural renewal returns in lakes stocked back above the need

Board item T1R, 5 November 2026. AI-written (a Claude Code session). *About 5 to 7 minutes to read.*

**What it is.** A field test that asks whether the need T1N measures is the level's. T1N's verdict on Wisconsin's walleye lakes ([its README](../need-measured-in-advance/README.md)), if positive, cannot tell renewal stopping below the need from renewal lost for years to another cause, so it says "the need's causal role not shown". Lakes stocked back above the need can tell them apart. Under a need in the level their natural renewal returns; under renewal lost to another cause it does not. T1R reads T1N's records with T1N's frozen reader and uses T1N's frozen need, checked by hash, so it cannot refit the need to suit its outcome.

**The verdict (V1).** It reads the lakes whose spring adults stood wholly below the need, were stocked, and later stood wholly above it. Each lake's own renewal is read once: the fall age-0 of its first year back above the need with no stocking recorded that year. That needs no mark, since a fish stocked the year before is a yearling by that fall. Against the need's fit, at the lakes' levels below the need and at the levels restored, V1 reads:
- *renewal rose with the level*, where more renewed than their low levels allow. This means renewal follows the level in some of these lakes at least, not lost to another cause in all of them. It carries the cause ending as they were stocked, always, and unrecorded stocking or connected waters where they apply.
- *renewal did not rise with the level*, where no more did and fewer renewed than the fit expects even at the conservative bounds. This means renewal is not following the level in these lakes taken together, as where it is lost to another cause. It carries two clauses, always: stocked fish suppressing the lakes' own renewal, and their own needs lying above the common one.
- otherwise *not decided*.

Neither outcome shows that renewal *stops* below the need, and *rose* does not say what share of the lakes follows the level.

**Shared lakes.** T1R reads none of the lake-years T1N's need is fitted on. But its lakes are partly lakes whose fates T1N reads after 2012, so the two verdicts are not two independent results. The run reports how many lakes both read.

**Status.** Designed, with its dry run passing. Its reader's rounds are in progress, and it is not frozen until `FROZEN.sha256` is committed. Not run. Nothing has been downloaded and no value of the records read. The run waits on T1N's downloads, which wait on Ren's yes, and on R8, the marked shares, where they can be had.

| File | What it holds |
|---|---|
| [DESIGN.md](DESIGN.md) | The design: what is tested and why, the records, the need, the scope, the two chances, the verdicts, the dry runs, what each outcome means, the limits |
| [`t1r.py`](t1r.py) | The rules: the low survey, the year read, the two chances, V1 and its clauses, the reports |
| [`additions.py`](additions.py), [`layout.json`](layout.json) | What T1R reads beyond T1N's reader: the stocking files' dates, R8, and their layout facts |
| [`run.py`](run.py) | The run, after T1N's freeze and T1R's are checked by T1N's own check; kept once |
| [`dry_run.py`](dry_run.py), [`results/dry-run.json`](results/dry-run.json) | Synthetic archives in 19 worlds at two speeds of the managers' stocking, three of them again at 900 lakes; the rules on scripted lakes; the additions, the run and the freeze's chain checked |
| [`write_frozen.py`](write_frozen.py), `FROZEN.sha256` | The freeze's hash file, written last, and its writer |
| [REVIEW-FREEZE.md](REVIEW-FREEZE.md) | The reader's rounds |
