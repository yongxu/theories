# T1N: T1's field test with a need measured in advance (design)

Board item T1N, 5 November 2026, at the coordinator's offer. AI-written (a Claude Code session), not yet reviewed by a person. The design, the rules ([`t1n.py`](t1n.py)), the reader ([`reader.py`](reader.py)), the run ([`run.py`](run.py)), the dry run ([`dry_run.py`](dry_run.py), [`results/dry-run.json`](results/dry-run.json)) and this file are frozen together before any value of the data is read. The hashes are in `FROZEN.sha256`, which [`write_frozen.py`](write_frozen.py) writes last. Nothing has been downloaded. The downloads and the run are Ren's decision (§12).

*About 45 to 60 minutes to read, at 100 to 130 words a minute; §1 and §11 in eight to ten.*

## 1. What is tested, and the answer expected

[02 §5](../../theories/becoming/chapters/02-MAP.md#t1)'s **Thesis T1**, *Persistence certifies the joint draw*: "Whatever persists through many renewal cycles of a condition it depends on, renewal stopping below a need, has had the joint draw on it, its own with every other drawer's, kept within the regime's margin (its point of no return, not the withheld-levels margin)." *Forbids*: "a condition below a need measured in advance returning with nothing given from beyond; a dependent active while its condition stood below its need." *Refuted by*: "a stock driven below a need measured beforehand returning with no measured giving from beyond, or fates across a predicted point separated no better than by a null." Its *Evidence* ends: "No field test of a need measured in advance has run." This is that test, designed and frozen before any value it reads is seen.

**The field.** Walleye lakes of Wisconsin's Ceded Territory, read through the records of the Wisconsin Department of Natural Resources (WDNR) and the Great Lakes Indian Fish and Wildlife Commission (GLIFWC). A lake's adult walleye are the condition. Their renewal is the fall's age-0 fish, which join the adults about three years later. The draw is the harvest, tribal and angling. Giving from beyond is stocking, since a lake takes fish from nowhere else, connected waters aside (§5).

**The verdict (V1, primary): the separation.** This is T1's *Refuted by* in its second form, "fates across a predicted point separated no better than by a null". The need is fixed before the series is read (§4). Lakes standing below it at a reference survey are set against the null, fixed in advance: T1's own classifier with no need, which predicts no fall. Below the need renewal stops under any draw, so T1 predicts a fall there whatever the managers do. The null predicts persistence there. Among the lakes below the need whose later fate is resolved:
- **supported** where at least the critical count of an exact one-sided sign test at 0.05 fell;
- **refuted** where at most half fell;
- **not decided** otherwise, or where fewer than ten are resolved (§7).

**Reported beside it (V2): the single-lake form.** This is T1's *Refuted by* in its first form: a lake below its need, with no renewal pending, returning above it with no recorded giving from beyond. It counts against T1 only where the recorders' own label says natural recruitment throughout and no stocking is recorded. An unrecorded stocking, of fry or by a tribal or private hatchery, could produce it, and so could fish from connected waters (§5).

**Who decides.** Every value the verdict reads is recorded by WDNR or GLIFWC, families that neither wrote nor read the theory. Their own fields decide the scope and much of the fate: the label of a lake's primary recruitment source, the stocking records, the survey estimates and their intervals. Code frozen here decides the rest. After the freeze nobody of the theory's family chooses anything, and no model is called.

**The answer expected.** The likeliest is *not decided*. Managers stock and relabel a falling lake, which takes it out of the test, and where they act fast few lakes stand below the need unstocked. In the dry runs, a stocking chance of 0.3 a year for a falling lake left V1 undecided in nearly every archive (§8). If decided, *supported* is expected, from Sass, Feiner and Shaw's finding of depensatory recruitment in about half of 82 Ceded Territory lakes (§13). A *refuted* would say one of two things. Either the need is misplaced, the adults' renewal not stopping where the age-0 surveys say. Or giving from beyond goes unrecorded: stocking the records miss, or fish from connected waters. §11 says what each outcome means, and §8 how often each came in worlds where the answer is known.

## 2. Why this field, and the alternatives considered

**What a field test of T1 needs**, from T1's own words:
- a condition whose renewal stops below a need;
- the need fixed before the series is read, from a source independent of that series;
- the draw and the renewal recorded;
- giving from beyond absent or measured, since *Refuted by* reads "returning with no measured giving from beyond".

**Alternatives considered, and why each was set aside** (from documentation and the literature; no data value was read):
- **The RAM Legacy Stock Assessment Database** (v4.66, Zenodo 14043031). It is public with no account, MQ3 already holds it under Ren's approval of 20 October, and MQ3 has read its layout. It does not fit:
  - Critical depensation, renewal stopping below a need, is rarely detected in assessed fish stocks: in 3 of 128 stock-recruitment series (Myers, Barrowman, Hutchings and Rosenberg 1995), and in few more with fifteen years added (Hilborn, Hively, Jensen and Branch 2014).
  - The few published Allee thresholds come from the stocks' own series, so they are not independent of the series a test would read. Examples are St Pierre Bank cod (Perälä, Hutchings and Kuparinen 2022) and 4 of 17 depleted gadid and flatfish stocks (Tirronen, Perälä and Kuparinen 2022). They also mark impaired recruitment, not renewal that stops.
  - Stocks are open, so fish from adjacent stocks are giving from beyond that nobody measures.
  - MQ3 has already read the total biomass and catch of 113 stocks.
- **Broadcast spawners** (abalone, queen conch). Their needs come from fertilization and mating biology, independent of any fishery's series: a minimum density for reproduction near 0.15 abalone per m² (Babcock and Keesing 1999), and queen conch mating seen only above about 56 per hectare and spawning above about 48 (Stoner and Ray-Culp 2000). They do not fit:
  - Their series are in agency reports, at few sites.
  - Larvae arrive from elsewhere, giving from beyond that nobody measures.
  - The draw after a fishery's closure is poaching, which nobody records.
  - At one index set the decline has already been reported: pinto abalone in the San Juan Archipelago fell 98% from 1992 to 2017 at ten sites. A test there could only be prospective.
- **Laboratory archives** (the yeast of MQ1, MQ2 and MQ6; the beetles of UE31). These are not field data, and T1's yeast tests are already in its *Evidence*.
- **Population archives without draws** (the Global Population Dynamics Database). They record no draw.
- **The walleye lakes.** These fit best:
  - the lakes are closed, except for stocking;
  - depensatory recruitment is documented in many of them;
  - the recorders publish each lake's adult estimates with intervals, its recruitment-source label, the stocking and the tribal harvest;
  - fall age-0 surveys run in most years.

  Their gaps are named in §3 and §5. The coordinator's argument settled the choice: a test with named gaps that can still fail beats none.

## 3. The records

Each is named by its recorder, read only after Ren's yes (§12), and turned into lakes by [`reader.py`](reader.py) under the layout assumed in its `FILES` and `COLUMNS`:

| | Record | Recorder | What the test reads | What it leaves out |
|---|---|---|---|---|
| R1 | Spring adult population estimates, by lake and year, the FMIS report "WDNR Treaty Walleye Adult Population Estimate, statewide by year" | WDNR and GLIFWC (mark and recapture) | The estimate and its 95% interval, divided by the lake's acres; the lake's primary recruitment source | Years without an estimate (lakes are surveyed in rotation) |
| R2 | Fall recruitment surveys, by lake and year | WDNR and GLIFWC (electrofishing) | Age-0 walleye per mile of shoreline | Years not surveyed |
| R3 | Tribal harvest, by lake and year | WDNR, from the bands' declarations and creel | Walleye harvested | — |
| R4 | Angling harvest, by lake and year | WDNR creel surveys | Walleye harvested, in creel years | Every year without a creel survey |
| R5 | Fish stocking records | WDNR's stocking database | The years a lake was stocked with walleye of any size | Fry, and fish supplied by the U.S. Fish and Wildlife Service or by tribal or private hatcheries (the database's own note) |
| R6 | The published per-lake stock-recruitment curves, if any | Sass, Feiner and Shaw (2021), *Fisheries* 46(6): 266–276, doi:10.1002/fsh.10584, or its supplement | Each lake's fitted curve, its form, its parameters and its last data year | Lakes the publication does not give |

The draw the test reads, the **recorded draw** `h`, is R3 with R4 where a creel survey ran that year, per acre. It is a lower bound on the joint draw. V1 does not read it (§7), so its gaps do not enter the verdict. The point with it is reported.

## 4. The need

**The floor.** A year's renewal counts as stopped where its fall survey caught fewer than one age-0 walleye per mile of shoreline (`FLOOR`). WDNR's reports read a survey with no age-0 as no natural reproduction, and one per mile is the least catch a survey of a few miles of shoreline records above none. V1 is decided at this floor alone, and the reports give it at 0, 1 and 5 per mile as well (`FLOORS_REPORTED`).

**Branch A, the published need**, where R6 gives a lake's curve in a readable form:
- The form is the depensatory Beverton-Holt `α S^q / (1 + β S^q)` or the depensatory Ricker `α S^q e^(−βS)`, with S in spring adults per acre and recruitment in age-0 per mile (`CURVES`).
- The lake's need is the least adult density, up to 100 per acre, at which the published curve reaches the floor (`need_branch_a`).
- Branch A's references start the year after the publication's last data year, so its need is fixed before every year its test reads.

**Branch B, the cross-lake need**, otherwise:
- **The data.** Every lake-year up to 2012 (`CUTOFF`) with both a spring adult estimate and a fall survey gives one pair. The level is the adults per acre, and the outcome is whether that fall's renewal reached the floor.
- **The fit.** A logistic regression of the outcome on the logarithm of the level, fitted by maximum likelihood with a small penalty (`RIDGE`, 0.001) that keeps it finite where the classes separate.
- **The need** is the level at which the fitted chance of renewal reaching the floor is one half (`need_branch_b`).
- **One need for every lake.** No lake's need reads its own later series. A lake's own years up to 2012 enter the pool with every other lake's.
- **No need.** Branch B gives none, and V1 is not decided, where the pairs number fewer than 200 or come from fewer than 30 lakes, or where renewal does not rise with the level (the fitted slope at most zero). No need found is a finding: the lakes then lie outside T1's scope, not against it, as most assessed fish stocks do.
- **The cutoff.** 2012 is the last year before the Wisconsin Walleye Initiative widened the stocking of large fingerlings from 2013. Branch B's references start in 2013.

**The fallback order**, fixed now and applied at the layout step, before any value of R1 to R5 is read:
1. Branch A decides V1 where R6 exists and gives a readable curve for at least 20 lakes (`BRANCH_A_LAKES`). The layout counts its readable curves, but reads none of their values.
2. Otherwise branch B decides V1.

Branch B is computed and reported in either case.

## 5. The scope, by the recorders' own fields

A lake enters the test at a reference survey only where both of these hold (`in_scope`):
- the recorders' label of its primary recruitment source that year says natural recruitment (reader.py maps the label's texts; any text the map does not hold refuses);
- no walleye stocking is recorded in that year or the five before it (`STOCK_BEFORE`), so the level read is not one that stocked fish make.

**What the scope leaves out.** The records give these as they are, and the test does not reach them:
- fry stocking;
- federal, tribal and private stocking (R5's own note);
- the angling harvest outside creel years;
- fish from connected waters, where a lake lies on a chain or a flowage and walleye can enter.

Where R1's lake characteristics name the water body's type, V1 is also reported for seepage lakes alone, which have no inlet or outlet. That is a report, not a verdict.

## 6. The reference and the fate

**Candidates.** A lake's candidates are its spring estimates in the reference window that have a later estimate three to ten years after (`candidates`, `GAP_MIN`, `GAP_MAX`). Under branch B the window runs from 2013 to the archive's last estimate year less three, which the layout reads.

**The reference** is the lake's first candidate in scope at which T1 predicts a fall, its level x below the need y. Failing that, it is the lake's first candidate in scope at which T1 predicts persistence (`rows`). The choice reads only the reference's own level and the need, never a later value.

**The fate**, between the reference and the first later estimate (`fate_of`), by the recorders' own fields first:
- **fell** where their label leaves natural recruitment at any survey after the reference up to the fate's. That is the recorders' judgement that natural renewal no longer sustains the lake, and it is how a falling lake, stocked and relabelled, stays in the test instead of leaving it.
- **unresolved** where stocking is recorded after the reference with the label kept: giving from beyond, without that judgement.
- otherwise by the later estimate against the need: **fell** where its interval's upper bound is below the need, **persisted** where its lower bound is at or above it, **unresolved** where the interval holds the need.

**Renewal pending.** Walleye join the adults about three years after their fall (`RECRUIT_LAG`). A lake below the need can still hold a strong year class from before it fell, as the dry run's first single-lake hits showed (§8). T1's regime has no lag. Each row records whether a fall survey in the three years before the reference reached the floor (renewal pending), or whether none was made (renewal unread):
- **V1 reads every lake below the need**, and reports the two kinds apart. A pending cohort that keeps a lake up then counts against T1, as it should against a claim stated on the level alone.
- **V2 reads only lakes with none pending**, where a return is renewal from below the need.

## 7. The verdicts

**V1** (`v1`). Every lake in the test has a row. T1 predicts a fall where x < y, and the null predicts none, so the two classifiers differ on exactly the lakes below the need. Let n be those with resolved fates, and k the ones that fell. The rule, in this order:
1. Not decided where n < 10 (`N_MIN`).
2. Supported where k reaches the critical count of an exact one-sided sign test at 0.05, which is McNemar's test on the discordant lakes. The critical count is 9 of 10, 11 of 14 and 15 of 20.
3. Refuted, the fates separated no better than by the null, by either of two routes:
   - k ≤ n − c, with c the critical count: so few fell that the same exact test at 0.05 puts the fates on the null's side. That is at most 1 of 10, 3 of 14 or 5 of 20.
   - by the home's letter, 2k ≤ n, where n ≥ 20 (`N_REFUTE`).
4. Not decided otherwise.

**Why the letter needs twenty lakes.** The letter, no better than the null, is the one T1-STANDING read as met at equal accuracy after the salt shock, and it is kept. As a point estimate it is weak evidence at few lakes. Suppose a lake below the need falls with chance 0.7, as pending cohorts and quick recoveries after a kill give in T1's own dry-run world (§8). Then at least half of 10 lakes survive with chance 0.15, and at least half of 20 with 0.048. So the letter is read at twenty lakes or more. At fewer, a refutation needs the fates on the null's side at 0.05, which a fall chance of 0.7 gives among 10 lakes with chance 0.0001. Support at ten needs 9 of 10, a chance of 0.011 under the null.

**Why the need alone, not the point with the draw.** T1's point of no return is the need with a standing draw. Here the draw does not stand: safe harvests are set from each lake's estimates, so the harvest is cut as a lake falls. A lake whose draw would end it can then persist because the draw changed. That is a breach of T1's standing-draw premise, not evidence against T1. Below the need, T1 predicts a fall under any draw, so V1 reads the need alone. The rows also give each reference's point with the recorded draw, and the reports give the fates of lakes above the need and below that point.

**V2** (`v2`), reported. It counts the lakes below the need at the reference, by the interval's upper bound, with no renewal pending, whose fate is persisted. That fate needs the natural-recruitment label at every survey between and no stocking recorded after the reference. It is *met* where at least one such lake exists, and each is listed.

**Reports**, ruling on nothing (`reports`):
- the lakes out, by reason;
- the fates of the lakes above the need, and of those above it but below the point with the recorded draw;
- the references with a creel survey;
- V1 split by renewal pending at the reference;
- V1 at the floors 0 and 5;
- V1 for seepage lakes, where R1 names the type;
- under branch A, branch B's V1 beside it.

## 8. Dry runs

[`dry_run.py`](dry_run.py) builds synthetic archives of 300 lakes, 1990 to 2025, and reads each with the frozen rules under branch B. Its record is [`results/dry-run.json`](results/dry-run.json): 57 checks, none failed, 57.8 CPU seconds.

**The model.** Each year, spring adults per acre x renew by fall age-0 r = R(x)·e^(σz), with R(x) = 60 x^q / (1.5^q + x^q) and σ = 0.8. Next spring's adults are 0.7x − h plus 0.03 times the age-0 of three years before. The exploitation e is drawn per lake from 0.05 to 0.6, and above 0.3 a lake keeps no level. The draw is h = e·x, cut to 0.05·x below one adult per acre, as safe harvests are. In a year, a lake loses nine tenths of its adults with chance 0.02 (a winterkill).

**What the recorders do.**
- They estimate adults every three to five years, with log-normal error at a CV of 0.25 and a 95% interval.
- They survey age-0 in most years.
- 40% of lakes are speared, and the tribal part of the harvest is recorded; angling is recorded only in creel years (a fifth).
- Below one adult per acre, managers stock a lake with a chance a year (the speed) and relabel it.

**The worlds:**
- *need*: q = 3;
- *no need*: q = 1;
- *needs vary*: each lake's 1.5 scaled by a factor of about 2;
- *need rises* and *need falls*: doubled or halved after 2012;
- *unrecorded*: a third of stocked lakes stocked with nothing recorded and the label kept;
- *open*: 0.15 adults per acre a year arriving from connected waters, unmeasured;
- *survival compensates*: age-0 depensatory, but the adults they make rise as age-0^0.3, so the need is read at the wrong stage;
- *episodic*: q = 1.5 and σ = 1.6, so below the need renewal is rare, not stopped;
- *renewal unseen*: q = 1, with surveys catching age-0 in proportion to x/(x + 0.5).

V1's verdicts in 40 archives a cell (S supported, R refuted, N not decided), by the managers' stocking chance a year for a falling lake; V2 met, in archives, after the slash:

| World | 0.3 | 0.1 | 0.03 | 0 |
|---|---|---|---|---|
| need | N 40 / 0 | S 9, N 31 / 0 | S 39, N 1 / 0 | S 40 / 1 |
| no need | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| needs vary | N 40 / 0 | S 28, N 12 / 0 | S 40 / 0 | S 40 / 0 |
| need rises | N 40 / 0 | S 38, N 2 / 1 | S 40 / 1 | S 40 / 1 |
| need falls | N 40 / 0 | S 2, R 2, N 36 / 0 | S 4, R 9, N 27 / 1 | S 18, R 2, N 20 / 3 |
| unrecorded | R 12, N 28 / 3 | S 9, R 5, N 26 / 8 | S 38, N 2 / 7 | S 40 / 4 |
| open | N 40 / 0 | R 1, N 39 / 1 | R 8, N 32 / 0 | R 17, N 23 / 2 |
| survival compensates | R 1, N 39 / 0 | R 14, N 26 / 1 | R 27, N 13 / 1 | R 24, N 16 / 1 |
| episodic | N 40 / 0 | N 40 / 1 | S 20, R 3, N 17 / 10 | S 21, R 3, N 16 / 9 |
| renewal unseen | N 40 / 0 | N 40 / 1 | N 40 / 0 | R 1, N 39 / 0 |

**What the dry runs show:**
- **Where there is no need, V1 is never supported.** The fitted need comes out near zero (at most 0.03 adults per acre), so almost no lake stands below it and V1 is not decided. Under *renewal unseen* the fitted need is near 0.12, but too few lakes fall below it to decide; one archive of 40 was refuted at the slowest speed.
- **Where a need is real and fixed or rising, V1 is supported** once managers are slower than 0.3 a year, and it was refuted in none of the 480 archives of those three worlds. In T1's own world about one lake in five below the need still persists, from pending cohorts and quick recoveries after a kill. The two refutation routes (§7) keep that from refuting.
- **V1 is refuted where the need is misplaced:** read at the wrong stage (*survival compensates*, 14 to 27 of 40 once managers are slower than 0.3), or fallen after the fit (*need falls*, up to 9). It is also refuted where giving from beyond goes unrecorded: connected waters (*open*, up to 17), and unrecorded stocking under fast managers (*unrecorded* at 0.3, 12 of 40). The last two are the confounds §5 names, and V1 cannot tell them from a misplaced need. The seepage-lake report is there for the first of them.
- **Power rests on the managers' speed,** which no record gives before the data. At 0.3 a year almost no falling lake stays in the test unstocked.
- **V2 is met mostly where giving from beyond goes unrecorded** (*unrecorded*, up to 8 of 40) **or renewal is episodic** (up to 10). It was also met in T1's own world without managers (1 of 40), from estimation error and rare strong year classes. So V2 alone refutes nothing: it is reported, as §1 says.

## 9. Data and what has been seen

**Read before this design** (documentation, abstracts and search results, no value of any record):
- 02 §5 (T1, its standing and evidence), T1-STANDING, and the summary blocks of MQ1, MQ2, MQ3 and MQ6 (study §253, §266, §272 and §314);
- AA's plan §7, and UE31's design §9 to §11 and its layout record;
- the abstracts of Sass, Feiner and Shaw (2021), Dassow and others (2023), Mrnak and others (2024) and Sass (2025, *FACETS*);
- WDNR's descriptions of its Treaty Reports, the tribal harvest page and the stocking database's coverage;
- the titles and columns of the FMIS adult estimate report, as a search engine's summary gave them;
- WDNR's Walleye 2021 plan's objective of three adults per acre for naturally reproducing lakes;
- reports of GLIFWC's survey programme (15 to 20 spring estimates and 100 to 150 fall surveys a year).

**Not read:** any record's values, any figure of a lake's series, and the per-lake tables of the papers. The ScienceBase records were behind a bot check and were not opened.

**What is assumed of the layout, and checked at the layout step:**
- R1 gives per lake and year the estimate, both interval bounds and the lake's acres, so the reader divides by the acres.
- R2 gives age-0 per mile.
- R3 and R4 give numbers of walleye.
- R5 gives the species and the number stocked.
- Where any differs, an addendum changes only the reader's `FILES`, `COLUMNS` and `LABELS` (§14).
- Where a quantity the rules need is missing (both interval bounds, or the age-0 survey's unit), the layout record says so, and the rule that needs it is not run. V1 is then not decided, and the record gives the reason.

## 10. The run's order

Each step is committed before the next.

1. **The downloads**, on Ren's yes (§12): each record as a CSV file in one folder outside the repository, its source, date, size and sha-256 recorded.
2. **The layout, with no value read.** `python3 -B reader.py layout FOLDER` gives each file's header and row count, and nothing else. Recorded beside it, still without values:
   - the label's distinct texts, for the map;
   - the water body types R1 names;
   - whether R6 gives curves, in which forms and for how many lakes, and its last data year, which settles the branch (§4);
   - the archive's last estimate year, which settles the reference window;
   - the number of lake-years with both an adult estimate and a fall survey up to 2012, against branch B's 200 pairs from 30 lakes;
   - the number of lakes with a candidate reference.

   Where the layout differs from the one assumed, an addendum adapts the reader's mapping alone, and the dry run's reader checks run again on synthetic files in the new layout.
3. **The reader** on the files, the lakes it builds recorded as counts.
4. **The run** (`python3 -B experiments/need-measured-in-advance/run.py FOLDER`, writing `results/run.json`): the need under the branch the layout settled, then V1, V2, the rows and the reports, kept whatever they are. Branch B's V1 is reported in either case. `run.py` refuses unless the freeze checks (§14).

## 11. What each outcome means

Fixed before the run.

| V1 | What it means |
|---|---|
| supported | Lakes standing below a need measured in advance fell more often than an exact sign test allows by chance, where the null without a need predicts none: T1's *Refuted by* in its second form was met and not borne out, in the field, for the first time. It is a prediction that could fail and did not. It holds within the recorders' records: it says nothing of the stocking they miss, and nothing of the draw within the margin, which V1 does not read. |
| refuted | Lakes below the need persisted at least as often as they fell: T1's *Refuted by* in its second form, met. Either the need is misplaced (the adults' renewal does not stop where the age-0 surveys say, or the need moved after 2012), or giving from beyond goes unrecorded (stocking R5 misses, fish from connected waters). The seepage-lake report and the split by renewal pending say which is likelier; neither is a verdict. T1's standing then records a frozen field test failed, as its *Evidence* records MQ3. |
| not decided | Too few lakes stood below the need unstocked, or no need was found. Where no need was found the lakes lie outside T1's scope, as most assessed fish stocks do; otherwise the test could not reach what T1 forbids, as the salt shock could not (T1-STANDING). |

| V2 | What it means |
|---|---|
| met | A lake below its need, with nothing pending and nothing recorded given from beyond, came back above it: T1's *Refuted by* in its first form, met by the letter, within the records. An unrecorded stocking, fish from connected waters or a rare strong year class could produce it (§8), so it is reported with V1 and its lakes listed, and it is not a verdict. |
| not met | No such lake: the first form not met in these records. |

## 12. What waits on Ren

On the board's Decisions line:
- **The downloads**, each from a public page with no account where the page says so. Their sizes are read at the download, since none can be read before it without its values. The exports are expected to be tables of a few megabytes in all.
  - R1: the FMIS Treaty Reports' adult population estimates (<https://apps.dnr.wi.gov/fisheriesmanagement/Public/TreatyReports>);
  - R2: the fall recruitment surveys, from the same reports or from GLIFWC (<https://www.glifwc.org/Fisheries/Inland/>);
  - R3: the Ceded Territory's tribal harvest (<https://dnr.wisconsin.gov/topic/Fishing/ceded/tribalharvest.html>);
  - R4: the creel surveys;
  - R5: WDNR's fish stocking database;
  - R6: the 2021 paper's supplement, where one exists.
  A page that offers no download, or a file behind a bot check, is fetched by Ren in a browser, as Dryad's files were for MQ6. Where R2 cannot be had, branch B cannot be computed, and the test runs only under branch A.
- **The run**: a few seconds of CPU on the local machine, standard library, no model call, no key.

Freezing waits on no one; AGENTS.md has designs "prepared fully, freezing designs included".

## 13. Limits and literature

- **The need is read at the age-0 stage.** T1's need is where the condition's renewal stops. The surveys read the fall's age-0; the adults' renewal also passes through survival from age 0 to age 3, which can compensate (Sass and others 2022 found age-0 to age-1 mortality density-dependent). The *survival compensates* world is that case, and it refutes (§8).
- **A common need under branch B.** One need for every lake reads T1's need as a property of the lakes' common renewal law. The *needs vary* world shows V1 holding where needs differ by a factor of about two.
- **The lag.** T1's regime has no lag; walleye recruit to the adults three years after spawning, so the state at a reference is more than the level (T2's own claim: the level, the recent giving and one lag). V1 reads the level alone and reports pending renewal apart.
- **Estimates.** Mark-and-recapture estimates carry their intervals, which the fate reads; the reference's level is read as the estimate.
- **Labels.** The recruitment-source label is the recorders' classification and its criteria are theirs; a relabelling for another reason than failing natural recruitment is read as a fall.
- **Literature.** Critical depensation and its rarity in assessed stocks: Myers, Barrowman, Hutchings and Rosenberg (1995, *Science*); the q of depensation: Liermann and Hilborn (1997); Allee effects: Courchamp, Berec and Gascoigne (2008). Walleye: Sass, Feiner and Shaw (2021, *Fisheries*); Dassow and others (2023, *Fisheries Research*); Mrnak and others (2024, *Canadian Journal of Fisheries and Aquatic Sciences*); Rypel and others (2018, the same journal); Sass (2025, *FACETS*). Thresholds of harvest: Clark (1976); Beddington and May (1977). These are cited from their abstracts and summaries, not checked against the full texts.

## 14. Provenance and the freeze

- Written for board item T1N on 5 November 2026, at the coordinator's offer. The coordinator chose the walleye lakes, the separation as the primary verdict, the scope by the recorders' fields, the need's two branches with a fallback and the run's order.
- No data was downloaded, no value read, and no model called. The only computation was the dry run's, on synthetic lakes.
- **Readers.** An independent reader reads the frozen files before the freeze lands: a full read, then the same reader on the diff of each round's fixes, until a round finds nothing of high or medium severity, at most five. The findings, and how each was taken, are in [`REVIEW-FREEZE.md`](REVIEW-FREEZE.md).
- **What is frozen.** `FROZEN.sha256` lists:
  - this folder's code: `t1n.py`, `reader.py`, `run.py`, `dry_run.py` and `write_frozen.py`;
  - the dry run's record.

  `write_frozen.py` writes it last, on the merged tree, and refuses unless the dry run's record shows every check passed, its code unchanged while it ran, and the hashes it names equal to the files'. It also refuses a second write.
- **An addendum** may change only `reader.py`'s `FILES`, `COLUMNS`, `LABELS` and `SPECIES`, after the layout is read with no value, and with them the dry run's record, once its reader checks are run again. It is a dated `addenda/ADDENDUM-k.md` with `addenda/FROZEN-k.sha256`, the hashes of every frozen file after it. `run.py` checks the chain before it reads anything:
  - each link is committed once and never changed, one blob across the full history, as freeze 1's chain reads it;
  - each link comes after the one before;
  - each lists the files before it and its own text;
  - each changes no file but `reader.py` and the dry run's record;
  - the newest link's files are the bytes it names.
- **How this file is frozen.** By the commit that adds `FROZEN.sha256`: its text there is the frozen one. It is not hashed, so that a link can be repaired without touching the code's hashes. A later edit may only repair a link or a typo, is listed in a dated note at the end, and changes no rule, threshold or reading.
