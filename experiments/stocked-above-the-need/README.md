# T1R: whether natural renewal returns in lakes stocked back above the need

Board item T1R, 5 November 2026. AI-written (a Claude Code session). *About 6 to 9 minutes to read, at 100 to 130 words a minute.*

**What it is.** A field test that asks whether the need T1N measures is the level's. T1N's verdict on Wisconsin's walleye lakes ([its README](../need-measured-in-advance/README.md)), if positive, cannot tell renewal stopping below the need from renewal lost for years to another cause, so it says "the need's causal role not shown". Lakes stocked back above the need can tell them apart. Under a need in the level their natural renewal returns; under renewal lost to another cause it does not. T1R reads T1N's records with T1N's frozen reader and uses T1N's frozen need, checked by hash, so it cannot refit the need to suit its outcome.

**The verdict (V1).** It reads the lakes whose spring adults stood wholly below the need, were stocked, and later stood wholly above it. Each lake's own renewal is read in two years:
- above the need: the fall age-0 of its first year back above it with no stocking recorded that year or the year before. That needs no mark, since a fish stocked earlier is two or more by that fall.
- below the need, where it was surveyed there too: the last year before that one with the spring wholly below the need and no stocking recorded that year or the year before.

V1 reads:
- *renewal rose with the level*, where more lakes renewed above the need and not below than the reverse, by an exact sign test at 0.05. Unless what its clauses name gave it, this means renewal follows the level in some of these lakes at least, not lost to another cause in all of them. It always carries two clauses, unrecorded stocking and something other than the level changing renewal or its survey between the years compared, and connected waters where it applies.
- *renewal fell short of the fit at the levels restored*, where no rise is shown, whichever way the counts lean, and fewer lakes renewed above the need than its fit expects, even at the conservative bounds. This means renewal falls short of the level's in some of these lakes at least, as where it is lost to another cause. It always carries three clauses: stocked fish suppressing the lakes' own renewal, their own needs lying above the common one, and the adults restored counting stocked fish not yet spawning.
- otherwise *not decided*.

Neither outcome shows that renewal *stops* below the need, and *rose* does not say what share of the lakes follows the level. Nor does *rose* rule out stocking that no record shows, which reaches the year read and rarely the year below, or the conditions of the years the estimates chose: a lake's low survey is its first estimate below the need, chosen more often in a poor year, and its year read its first above it, chosen more often in a good one. Where those conditions also moved its age-0, the comparison favours a rise. The rise read with each lake's first fall after its low survey, a year no estimate chose, is reported beside V1.

**Shared lakes.** No year T1R reads above the need is one T1N's need is fitted on, but its lakes are partly lakes whose fates T1N reads after 2012. So the two verdicts are not two independent results, and the run reports how many lakes both read.

**Status.** Refused at its one run, on 6 November 2026, at the same point as T1N: T1N's reader, which it reads the records with, refuses at the header of the agency's public table of adult estimates, which gives no upper bound and no acres column ([the output](results/run-refused.txt), [T1N's record](../need-measured-in-advance/LAYOUT.md)). On that table with the stocking database, as the frozen reader reads them, T1N's need could have about 162 lake-years as the fall tables were read, where its fit needs 200, and T1R imports it. V1 is not decided and nothing is said of T1. The design is frozen by the commit that adds `FROZEN.sha256`, after its dry run passed and one reader read it in four rounds, the last finding nothing of high or medium severity ([REVIEW-FREEZE.md](REVIEW-FREEZE.md)). R8 was not sought as a table, since R1 settles the refusal first; WDNR's reports may hold it as lists. A successor to T1N's design is claimed on [the board](../../_process/BECOMING-WORKBOARD.md) as T1B and not being worked on.

| File | What it holds |
|---|---|
| [DESIGN.md](DESIGN.md) | The design: what is tested and why, the records, the need, the scope, what is compared, the verdicts, the dry runs, what each outcome means, the limits |
| [`t1r.py`](t1r.py) | The rules: the low survey, the year read and the year below, the two tests, V1 and its clauses, the reports |
| [`additions.py`](additions.py), [`layout.json`](layout.json) | What T1R reads beyond T1N's reader (the stocking files' dates, R8 and the repeated fall surveys) and their layout facts |
| [`run.py`](run.py) | The run, after T1N's freeze and T1R's are checked by T1N's own check; kept once |
| [`dry_run.py`](dry_run.py), [`results/dry-run.json`](results/dry-run.json) | Synthetic archives of 900 lakes in 28 worlds, at two speeds of the managers' stocking; the rules on scripted lakes; the additions, the run and the freeze's chain checked |
| [`write_frozen.py`](write_frozen.py), `FROZEN.sha256` | The freeze's hash file, written last, and its writer |
| [REVIEW-FREEZE.md](REVIEW-FREEZE.md) | The reader's rounds |
