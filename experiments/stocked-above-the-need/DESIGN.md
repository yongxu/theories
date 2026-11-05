# T1R: whether natural renewal returns in lakes stocked back above the need

Board item T1R, 5 November 2026, at the coordinator's offer. AI-written (a Claude Code session), not yet reviewed by a person. The rules ([`t1r.py`](t1r.py)), what T1R reads beyond T1N's reader ([`additions.py`](additions.py), [`layout.json`](layout.json)), the run ([`run.py`](run.py)) and the dry run ([`dry_run.py`](dry_run.py)) are frozen with this file by `FROZEN.sha256`, written last by [`write_frozen.py`](write_frozen.py). T1N's rules, reader and run are used at the hashes T1N's freeze names. *About 40 to 55 minutes to read, at 100 to 130 words a minute, the tables quicker; §1 and §11 in 7 to 10.*

## 1. What is tested, and the answer expected

T1N's verdict, if positive, says the lakes below the need fell and the lakes above it did not, and adds "the need's causal role not shown" ([T1N's §7](../need-measured-in-advance/DESIGN.md)). Renewal lost for years to another cause, a changed habitat or a run of warm springs, gives the same outcome, and T1N's records cannot tell the two apart. Lakes stocked back above the need can. If renewal stops below the need because of the level, restoring the level brings it back. If renewal was lost to another cause, restoring the level does not.

**The verdict (V1).** The lakes read are those whose spring adults stood wholly below T1N's need, were then stocked, and later stood wholly above it.
- Each lake's own renewal is read once, in its first year back above the need with no stocking recorded that year. That fall's age-0 then comes from the lake's own spawning.
- Let k of the n lakes reach T1N's floor that fall.
- The need's fit gives each lake two chances: one at its level below the need, as though restoring the level had changed nothing, and one at the level restored.

There are three outcomes (§7), each with its clauses:
- **Renewal rose with the level.** More lakes renewed than their levels below the need allow, by an exact test at 0.05. Renewal is read as following the level in some of these lakes at least, not lost to another cause in all of them. The line gives what the fit expects at the levels restored but does not say what share of the lakes follows the level. It carries the cause that stopped renewal ending when the lakes were stocked, always, and unrecorded stocking or connected waters where they apply.
- **Renewal did not rise with the level.** No more renewed than their levels below the need allow, and fewer than the fit expects even at the lower bounds of the levels restored. Renewal is read as not following the level in these lakes taken together, as where it is lost to another cause. It carries two clauses, always: stocking suppressing natural renewal, and their own needs lying above the common one.
- **Not decided**, where fewer than ten lakes are read, T1N finds no need, or neither test decides.

**What the test is worth.** It is the one test that turns T1N's "the need's causal role not shown" into evidence on the need's role. Each outcome answers one part of that:
- *rose* shows that renewal in lakes that fell below the need follows the level in some of them, which renewal lost to another cause in all of them would not give;
- *did not rise* shows that restoring the level did not raise these lakes' renewal, which is what renewal lost to another cause gives.

Neither shows that renewal *stops* below the need. The fit's 50% point is a property of the level both where renewal stops below a need and where it only shrinks at low levels, and T1N's fit does not tell those apart either.

**Independence from T1N.** T1R reads no lake-year that T1N's fit reads (§4). But its lakes are partly lakes whose fates T1N reads after 2012, so the two verdicts share lakes. They are not two independent results, and the run reports how many lakes both read.

**The answer expected.** None, from the account alone:
- where the lakes that fell are in T1's regime, it predicts *rose*;
- renewal lost to another cause predicts *did not rise*;
- in the dry run's world where 30% of lakes lose their renewal and the rest are in T1's regime, both occur (§8).

The outcome is kept whatever it is.

**Its limits** (§13, each holding so far):
- a cause ending as the lakes were stocked, which these records cannot separate from the level's return;
- stocked fish suppressing the lakes' own renewal, which they cannot separate from renewal lost;
- lakes whose own needs lie above the common one;
- *rose* not saying what share follows the level;
- the power of one year a lake.

## 2. Why this test, and the alternatives considered

- **Marks alone.** The coordinator first set the scope as lakes whose stockings are recorded as marked, since only a mark tells a stocked fish from a lake's own. A fall survey in a year with no stocking of any kind recorded needs no mark: a fingerling stocked the year before is a yearling by that fall, and is not counted as age 0. That is the reading T1N's own fit makes, since it reads age 0 in unstocked lake-years as natural renewal. So the primary scope is the unstocked years, and the marked years are a second route, reported (§5). The coordinator agreed.
- **A need refitted for these lakes.** Set aside: the need is T1N's, imported by hash, so T1R cannot fit one to suit its outcome (§4).
- **The recorders' label returning to natural recruitment.** Set aside as the outcome: the label is the recorders' classification, and its criteria may read the same surveys.
- **Persistence after stocking stops.** Set aside: a lake that holds its level after stocking ends mixes its own renewal with the survival of stocked fish.
- **Every year read, rather than one a lake.** Set aside. A lake's years share its productivity and its cause, so they are not independent. Reading renewal in any of three years also brings both chances near one, so a group in which some lakes renew and some do not shows no rise (§8). One year a lake keeps the chance below the need under one half and the chance above it over one half.
- **A test of the shortfall against the fit as part of the rise.** Set aside (§8). The fit's chances at the levels restored are uncertain, and no fixed reading of them was right in both directions. At the estimates they gave false shortfalls where every lake follows the level; at the intervals' lower bounds they hid shortfalls where two in five lakes had lost their renewal. So the rise is read for some lakes at least, the fit's expectations are reported beside it, and the shortfall decides only the negative outcome, at the bounds.

## 3. The records

T1N's records, its R1 to R5, R5b and R7 ([T1N's §3](../need-measured-in-advance/DESIGN.md)), from the folder T1N's downloads fill and read by T1N's reader at its frozen hash. Nothing of them is downloaded again. T1R adds two things:
- **The stocking files' dates**, where they give a date column, as named in T1R's layout.json. A stocking filed under another year's entry, a season's or a budget's year, would otherwise let a stocked fish of the survey's own spring be read as natural.
- **R8, the marked shares**, where the agency's stocking evaluations give them as a table. For a stocked lake-year, this is the unmarked share of the fall age-0 catch, for a stocking the agency marked with oxytetracycline. R8's layout is assumed in layout.json and checked at the layout step. Where R8 cannot be had, the second route is empty, and the layout step says so.

**How age 0 is told.** By R2's own field, the agency's age-0 count per mile, as T1N reads it. T1R reads no length and fits no length cut. Where R2 gives lengths and no age-0 field, T1N's reader refuses (its §9), and T1R is not decided.

## 4. The need

**T1N's, by hash.** The run calls T1N's `need` on the lakes T1N's reader builds, at T1N's floor of one age-0 per mile, with the labels as T1N reads them. Before it loads, `t1r.py` checks `t1n.py`, `reader.py` and T1N's `run.py` against T1N's base link, and refuses if any differs. T1N's addenda may change only its layout and its dry run's record, so these hashes stand. Where T1N finds no need, T1R is not decided.

**No lake-year read twice.** T1N's fit, and its renewal report, read only lake-years with no stocking recorded in them or the five years before (its `pairs`). Every year T1R reads has stocking recorded in T1N's records in the five years before it, so the need was neither fitted on nor reported from any of T1R's years. A scripted check holds it.

## 5. The scope: the lakes and the year read

`years_read` takes, for each lake:
1. **The low survey**: the lake's first spring estimate whose 95% interval lies wholly below the need.
2. **Stocking after it**, in any record. A lake with none is out.
3. **The year read**: the lake's first year after the low survey in which:
   - the spring interval lies wholly above the need;
   - stocking is recorded after the low survey within the five years before it, in T1N's records, so that T1N's fit never reads the year;
   - no stocking is recorded in the year itself, in WDNR's database, in R5b, or by a stocking's date;
   - a fall survey was made.

   The fall's age-0 that year is the lake's own renewal.
4. **The second route** (reported, §7): a stocked year whose unmarked share R8 records is read at the catch times that share.

A stocking whose date falls in a different year from its entry counts in both years. One year a lake is read (§2).

**Out**, and counted by reason:
- lakes never wholly below the need;
- lakes with no stocking after their low survey;
- lakes with no year read, including those stocked every year with no estimate in an unstocked year.

## 6. What is compared: the two chances

For each lake read, the need's fit gives two chances that its year read reaches the floor:
- **at its level below the need**: the fit's chance at the upper bound of the low survey's interval, the renewal the lake would have had if restoring the level had changed nothing;
- **at the level restored**: the fit's chance at the lower bound of that year's interval, and, reported, at its estimate.

**Why the bounds, not the estimates.** A year is read because its interval lies wholly above the need, so its estimate tends to run high. The low survey is chosen for an interval wholly below, so its estimate tends to run low. At the estimates, the chance at the level restored would be too high and the chance below the need too low. Each bound errs toward not deciding.

## 7. The verdicts

**V1** (`decide`, `v1`). Let n be the lakes read and k those whose year read reached the floor. Two exact one-sided tests of k, each on a sum of independent trials with the lakes' chances (Poisson-binomial):
- **the rise**: the chance of at least k, at the chances below the need; shown where at most 0.05;
- **the shortfall**: the chance of at most k, at the chances at the lower bounds of the levels restored; shown where at most 0.05.

The rule, in order:
1. Not decided where n < 10 (`N_MIN`).
2. Renewal rose with the level, where the rise is shown.
3. Renewal did not rise with the level, where the rise is not shown and the shortfall is.
4. Not decided otherwise.

**The lines in full.** Each opens "of n lakes stocked back above the need, k renewed at the floor in a year read". Then:
- **rose**: "more than their levels below the need allow (the expected number, p = …), the need's fit expecting e at the levels restored (e′ at their intervals' lower bounds); renewal read as following the level in some of these lakes at least, not lost to another cause in all of them, unless {the clauses of the rise}";
- **did not rise**: "no more than their levels below the need allow (…), and fewer than the need's fit expects even at the lower bounds of the levels restored (…); renewal read as not following the level in these lakes taken together, as where it is lost to another cause, unless stocking suppresses natural renewal or their own needs lie above the common one";
- **not decided**: the numbers, and which test failed.

**The clauses of the rise:**
- **unrecorded stocking**, where the other stocking records (R5b) were not read for a lake that renewed, or the stocking files give no date;
- **connected waters**, where a lake that renewed is not a recorded seepage lake, and the closed lakes alone, read by the same rule, do not also show the rise;
- **the cause that stopped it ended when they were stocked**, always. No reading of these records separates a cause ending as stocking begins from the level's return, since managers stock when renewal fails and a cause may pass in the same years.

**The clauses of the negative outcome**, both always:
- **stocking suppresses natural renewal.** Stocked yearlings still eat a lake's own age 0 in an unstocked year, and nothing here separates that from renewal lost.
- **their own needs lie above the common one.** The lakes read were chosen by having fallen and been stocked, and they may need more than the lakes the need was fitted on. The lakes restored to at least their own earlier renewing level are read again and reported. That level is the median spring level of the lake's own unstocked years before its low survey whose fall reached the floor. That reading compares them with the common fit too, so a shortfall there does not rule their own needs out, and the clause stays.

V1's numbers keep both readings the clauses rest on, the closed lakes alone and the lakes restored to their own level, each named as read before the clauses.

**Reported, ruling on nothing** (`reports`, `read`, run.py):
- V1 on the years read after 2012 alone, the window T1N holds out;
- V1 with the second route's marked years added, where R8 is read;
- the lakes out, by reason;
- renewal by the years since the last stocking, which a suppression by stocked fish would lower nearest the stocking;
- the lakes T1R reads that T1N also reads (§1);
- V1 without the three lakes of T1N's §9 disclosure (§9).

## 8. Dry runs

[`dry_run.py`](dry_run.py) builds synthetic archives of 300 lakes, 1990 to 2025, and reads each with T1N's need and T1R's rules. Its record is [`results/dry-run.json`](results/dry-run.json): 70 checks, none failed, 64 CPU seconds.

**The model.** T1N's own (its §8):
- renewal R(x) = 60 x^q / (1.5^q + x^q), with log-normal noise;
- next spring's adults 0.7x − h, plus 0.03 times the age-0 of three years before;
- harvest cut below one adult per acre, and winterkills;
- spring estimates every three to five years, their intervals at a CV of 0.25.

T1R adds managers who stock:
- A lake below one adult per acre begins a programme with a chance a year (the speed: 0.1 or 0.03, T1N's slower speeds).
- It is then stocked every other year for ten years.
- A stocking's fingerlings are in that fall's age-0 catch, and join the adults three years later as one adult per acre.

At T1N's speed of 0.3 a year, lakes are stocked before they stay below the need. T1N's need is then not fitted, with fewer than twenty of its lake-years below it, as in T1N's own dry run.

**The worlds**, in six families:
- **T1 holds** (q = 3):
  - *need*;
  - *needs vary* (each lake's 1.5 scaled by a factor of about 2);
  - *lakes differ* (productivity spread 0.5);
  - *episodic* (σ = 1.6);
  - *stocked every year*;
  - *open* (age-0 immigrants in open lakes).
- **T1 holds, stocking suppresses** (reported): a lake's own renewal is cut to a fifth for three years after each stocking.
- **Renewal lost** (q = 1, T1N's family of that name). 30% of lakes lose their renewal for good from a year between 1995 and 2015.
  - *light harvest*: harvest up to 0.3, so lakes fall mostly by the loss;
  - *renewal lost*: T1N's harvest;
  - *other stocking read*: fry stocked in the years between, recorded in R5b, read;
  - *dated*: half of the stockings filed under the year before, their dates read.
- **Mixed** (reported apart): *renewal lost, need*, with q = 3, and 30% of lakes losing their renewal as above.
- **Confounded**: renewal lost, each with a confound only a clause answers:
  - *other stocking unread*;
  - *no dates*;
  - *open*;
  - *the cause ends*, where renewal returns at the first stocking.
- **No need** (q = 1): *no need*; *lakes differ*; *catch 0.1*.

V1 in 40 archives a cell: R *rose*, D *did not rise*, N not decided, – no need fitted by T1N.

| World | 0.1 | 0.03 |
|---|---|---|
| **T1 holds** | | |
| need | R 39, N 1 | R 6, N 34 |
| needs vary | R 40 | R 40 |
| lakes differ | R 40 | R 31, N 9 |
| episodic | R 40 | R 40 |
| stocked every year | R 39, N 1 | R 8, N 32 |
| open | R 16, N 11, – 13 | N 39, – 1 |
| **T1 holds, stocking suppresses (reported)** | | |
| stocking suppresses | R 37, N 3 | R 9, N 31 |
| **Renewal lost** | | |
| renewal lost, light harvest | D 34, – 6 | D 26, N 14 |
| renewal lost | D 28, – 12 | D 25, N 15 |
| renewal lost, other stocking read | D 30, N 3, – 7 | D 14, N 25, – 1 |
| renewal lost, dated | D 31, – 9 | D 23, N 17 |
| **Mixed (reported apart)** | | |
| renewal lost, need | R 13, D 27 | R 8, D 26, N 6 |
| **Confounded** | | |
| renewal lost, other stocking unread | R 22, D 12, N 1, – 5 | R 15, D 10, N 15 |
| renewal lost, no dates | R 15, D 22, – 3 | R 16, D 12, N 12 |
| renewal lost, open | R 1, D 11, – 28 | D 10, N 22, – 8 |
| renewal lost, the cause ends | R 32, – 8 | R 26, N 14 |
| **No need** | | |
| no need | – 40 | – 40 |
| no need, lakes differ | – 40 | N 1, – 39 |
| no need, catch 0.1 | N 4, – 36 | N 5, – 35 |

**The checks on the worlds:**
- where T1 holds, *did not rise* in at most 5 of 40 archives at each speed (a level of 0.05 exceeds 5 such outcomes in 40 with chance 0.014);
- where renewal is lost and nothing confounds it, *rose* in at most 5 of 40;
- in each confounded world, a rise read without its clause in at most 5 of 40;
- power: *need* at 0.1, *rose* in at least 30 of 40; *renewal lost, light harvest* at 0.1, *did not rise* in at least 30 of 40.

**Set after the author's dry runs**, with the numbers those runs gave, which are not in the record:
- **The bounds** (§6). At the estimates, the T1 world *need* gave a false shortfall in 4 of 40 archives.
- **One year a lake** (§2). Reading renewal in any of three years, the mixed world gave *did not rise* in 36 of 40, though most of its lakes follow the level.
- **The clause of own needs, always.** Dropping it where the own-level reading also showed a shortfall dropped it wrongly in 1 of 40 archives of *needs vary* at 900 lakes.
- **Three outcomes, not four.** The rule first read a fourth, "renewal returned with the level", where the shortfall at the bounds was not shown. It read renewal as following the level in these lakes and not lost to another cause. In the mixed world, the archives that gave it had 34 of their 85 lakes read lost to another cause. So the rise now reads "in some of these lakes at least", and the fit's expectations are reported beside it rather than tested (§2).
- **The mixed world** was first in the renewal-lost family. There its bound failed, *returned* in 6 of 40 at 0.03, since most of its lakes follow the level. It is reported apart.

**What the dry runs show:**
- **Where T1 holds, V1 rose in 39 or 40 of 40 archives at 0.1 in every world but *open*, and never came out *did not rise*.** *open* rose in 16: age-0 immigrants in its open lakes kept T1N's need from being fitted in 13. At 0.03 fewer lakes are read, a median of 7 in *need*, and V1 was mostly not decided in *need* and *stocked every year*. At 900 lakes, *need* rose in 39 of 40 and *needs vary* in 40.
- **Where stocking suppresses a lake's own renewal** to a fifth for three years after each stocking, V1 rose in 37 of 40 at 0.1, and never came out *did not rise*: a suppression of that size leaves renewal above the need reaching the floor often.
- **Where renewal is lost and nothing confounds it, V1 came out *did not rise* in 28 to 34 of 40 at 0.1, and never rose.** At 900 lakes, *light harvest* did not rise in 40 of 40 at 0.03. Of the lakes read in the archives that did not rise, 89% to 97% had lost their renewal; the rest had fallen by harvest or a winterkill.
- **In the mixed world, V1 rose in 13 and 8 of 40, and did not rise in 27 and 26**, at 0.1 and 0.03. Where it rose, 190 of the 374 lakes read at 0.1, and 47 of 112 at 0.03, had lost their renewal: *rose* says some at least, not what share. Where it did not rise, 547 of 784 and 261 of 404 had.
- **In the confounded worlds the rise came with its clause.** Fry stocked unrecorded, with R5b unread, gave *rose* in 22 and 15 of 40, each with *unrecorded stocking*. Stocking files with no dates gave it in 15 and 16, each with the same clause. The cause ending at the first stocking gave it in 32 and 26, each with the cause abating. Immigrants reaching open lakes gave it once, with *connected waters*.
- **Where there is no need, T1N's need was fitted in at most 5 of 40 archives, and V1 was never decided.** With q = 1, renewal reaches the floor at nearly every level, so too few of T1N's lake-years lie below its 50% point.

**Other checks.** The rules on scripted lakes (27 checks): the low survey and each condition of the year read, the dates, R5b and R8, the own level, that no year read is one T1N's fit reads, the rule at its thresholds, and each clause. T1R's additions on synthetic files (6): the dates read back, the rows filed under another year counted, R8 read back, the facts the same with R8's shares overwritten, and the dates in the files' forms. The run end to end on synthetic files through T1N's reader, and its refusal of R8 unrecorded (3). T1R's freeze by T1N's frozen check in a stand-in repository (4): it refuses before the link, passes whole, and refuses a changed rule and an addendum changing one.

## 9. Data and what has been seen

Read before this design: T1N's design and code, 02 §5, and the documentation T1N's §9 lists. No value of any record was read, and nothing was downloaded. T1N's §9 records a search summary that showed T1N's round-3 reader fall-survey values for Worcester Lake, and for Crane and Chase Lakes, in Price County. T1R reads fall surveys too. So the run also reads V1 without those three lakes and reports both, finding them as T1N does (`reader.seen`).

## 10. The run's order

1. **The downloads.** T1N's (R1 to R5, R5b and R7) are made on Ren's yes, in the order T1N's §10 gives. R8, where it can be had as a table, comes on the same yes, its source, date, size and sha-256 in T1R's `downloads.json`.
2. **The layout, with no value read.** These are T1N's layout facts, and T1R's (`additions.facts`), from the structural columns alone:
   - the stocking files' date columns;
   - their walleye rows filed under another year than their date's;
   - R8's header, rows and lakes, by its lake and year columns, never its shares.

   Where the layout differs, an addendum changes T1R's `layout.json` alone (§14).
3. **The run** (`python3 -B experiments/stocked-above-the-need/run.py FOLDER`, writing `results/run.json`). It reads T1N's need, then V1 and its readings, the reports, the lakes both read, and V1 without the disclosed lakes. `run.py` refuses:
   - unless T1N's freeze and T1R's both pass T1N's own frozen check;
   - unless T1N's downloads pass T1N's own check;
   - unless R8, where it is in the folder, is recorded in T1R's `downloads.json`, committed once;
   - where `results/run.json` exists.

## 11. What each outcome means

| V1 | What it means |
|---|---|
| Renewal rose with the level | In the lakes stocked back above the need, more renewed than their low levels allow. Renewal follows the level in some of them at least, which renewal lost to another cause in all of them would not give. The clauses still stand: the cause ending as they were stocked; unrecorded stocking or connected waters where the line names them. Where T1N's verdict is positive, its "causal role not shown" is now partly answered, since renewal lost in all the lakes is ruled out. How many lakes follow the level is not shown: the line gives the fit's expectations to set k against. Whether renewal stops below the need is not shown. |
| Renewal did not rise with the level | Restoring the level did not raise these lakes' renewal, taken together, above what their low levels allow, and they renewed less than the fit expects at the levels restored. That reads as renewal lost to another cause, outside T1's regime, unless stocked fish suppress it or their own needs lie above the common one. A positive T1N verdict would then rest on renewal lost, not on the need. |
| not decided | Fewer than ten lakes read, no need found by T1N, or neither test decides. |

## 12. What waits on Ren

On the board's Decisions line:
- **R8**, where WDNR's or GLIFWC's stocking evaluations give the marked shares as a table, with T1N's downloads, which wait on Ren's yes already;
- **the run**: a few seconds of CPU on this machine, standard library, no model call, no key.

Freezing waits on no one.

## 13. Limits and literature

- **The cause abating** (§7). Where renewal was lost to a cause that ended in the years the lakes were stocked, it returns with the level and reads as following it. This holds so far (5 November 2026), for that reason. It lapses with lakes restored above the need at different times from when a region-wide cause ended, read apart.
- **Stocked fish suppressing natural renewal** (§7). Predation or competition by stocked fish lowers a lake's own renewal, and reads as renewal lost. This holds so far. It lapses with the renewal of lakes stocked back above the need, read long after the last stocking. The report of renewal by years since the last stocking shows the pattern a suppression would give. In the dry run, a suppression to a fifth for three years still gave *rose* in 37 of 40 archives at 0.1.
- **Own needs** (§7). The common need may lie below the needs of the lakes that fell and were stocked. This lapses with a need for each lake, fitted before the series it judges, which T1N set aside.
- **What share follows the level** is not read: *rose* says some at least. In the dry run's mixed world, 190 of the 374 lakes read in the archives that rose at 0.1 had lost their renewal (§8).
- **One year a lake** costs power. In the dry run, *need* at a speed of 0.03 read a median of 7 lakes an archive at 300 lakes and was mostly not decided; at 900 lakes it rose in 39 of 40 (§8).
- **The years read are few.** Spring estimates come every three to five years, and alternate-year stocking leaves half the years unstocked, so a lake's first year read can be many years after its low survey.
- **The age-0 classification** is the agency's (§3).
- **Lakes stocked every year** are never read in their stocked years except by R8.
- **Lakes are read as independent**, though region-wide years correlate their renewal.
- **Literature** as T1N's §13.

## 14. Provenance and the freeze

- Written for board item T1R on 5 November 2026, at the coordinator's offer, after T1N landed. The coordinator:
  - set the need as T1N's, imported by hash;
  - asked that stocking suppressing natural renewal be named as the rival a negative outcome cannot separate;
  - agreed the unstocked years as the primary scope, with the marks as a second route, both counted at the layout step;
  - asked that how age 0 is told be fixed in advance, and the stockings filed under another year be checked;
  - asked that the lakes shared with T1N be stated plainly;
  - agreed the clauses of the rise.
- No data was downloaded and no model called. No value was read. The only computation was the dry run's, on synthetic lakes.
- **Readers.** As T1N's: an independent reader reads the files before the freeze lands, in a full read and then on the diff of each round's fixes, until a round finds nothing of high or medium severity, at most five rounds. The findings are in [`REVIEW-FREEZE.md`](REVIEW-FREEZE.md).
- **What is frozen.** `FROZEN.sha256` lists:
  - `t1r.py`, `additions.py`, `run.py`, `dry_run.py`, `layout.json` and `write_frozen.py`;
  - the dry run's record.

  `t1r.py`'s check holds T1N's files T1R uses at T1N's hashes.
- **An addendum** may change only T1R's `layout.json`, after the layout is read with no value, and with it the dry run's record. T1R's chain is checked by T1N's own frozen check, T1N's `run.frozen` run on T1R's folder. That check refuses an addendum that remaps a label text. T1R maps none, so its `layout.json` holds an empty `labels`.
- **How this file is frozen.** By the commit that adds `FROZEN.sha256`: its text there is the frozen one. A later edit may only repair a link or a typo, is listed in a dated note at the end, and changes no rule, threshold or reading.
