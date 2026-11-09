# T1N: T1's field test with a need measured in advance (design)

Board item T1N, 5 November 2026, at the coordinator's offer. AI-written (a Claude Code session); no person's review of it is recorded. The rules ([`t1n.py`](t1n.py)), the reader ([`reader.py`](reader.py)) with the layout it assumes ([`layout.json`](layout.json)), the run ([`run.py`](run.py)) and the dry run ([`dry_run.py`](dry_run.py), its record [`results/dry-run.json`](results/dry-run.json)) are frozen together before any value of the data is read; the one exception, values a search summary showed a reader for three lakes, is in §9. Their hashes are in `FROZEN.sha256`, which [`write_frozen.py`](write_frozen.py) writes last; this file is frozen by the commit that adds it (§14). Nothing has been downloaded. The downloads and the run are Ren's decision (§12).

*About 120 to 155 minutes to read, at 100 to 130 words a minute, the tables quicker; §1 and §11 in fourteen to eighteen.*

## 1. What is tested, and the answer expected

[02 §5](../../theories/becoming/chapters/02-MAP.md#t1)'s **Thesis T1**, *Persistence certifies the joint draw*: "Whatever persists through many renewal cycles of a condition it depends on, renewal stopping below a need, has had the joint draw on it, its own with every other drawer's, kept within the regime's margin (its point of no return, not the withheld-levels margin)." *Forbids*: "a condition below a need measured in advance returning with nothing given from beyond; a dependent active while its condition stood below its need." *Refuted by*: "a stock driven below a need measured beforehand returning with no measured giving from beyond, or fates across a predicted point separated no better than by a null." Its *Evidence* ends: "No field test of a need measured in advance has run." This is that test, designed and frozen before any value it reads is seen, save the few a search summary showed one reader for three lakes, which the run also reads without (§9).

**The field.** Walleye lakes of Wisconsin's Ceded Territory, read through the records of the Wisconsin Department of Natural Resources (WDNR) and the Great Lakes Indian Fish and Wildlife Commission (GLIFWC). A lake's adult walleye are the condition. Their renewal is the fall's age-0 fish, which join the adults about three years later. The draw is the harvest, tribal and angling. Giving from beyond is stocking, since a lake takes fish from nowhere else, connected waters aside (§5).

**The verdict (V1, primary): the separation**, T1's *Refuted by* in its second form. The need is fitted on the years up to 2012, before any later year is read (§4). A lake's fate is a measured change, read alike on both sides of the need: a decline of its adults by a ratio test on the recorders' own intervals, not undone by a recovery (§6). Below the need renewal is rarer and the draw goes on, so T1 predicts a fall. A lake with a year class recorded in the three falls before is not read as below the need, since that renewal is part of its condition. The null, fixed in advance, predicts no fall anywhere. Among the lakes below the need with resolved fates:
- ***Refuted by*'s second form not met**, the positive outcome, where at least the critical count of an exact one-sided sign test at 0.05 fell, and they fell more often than the lakes above the need by Fisher's exact test at 0.05: the fates separated across the predicted point. The verdict line counts the lakes below the need that came back above it, and adds "the need's causal role not shown", since renewal lost to another cause gives the same (below);
- **refuted** where so few fell that the same sign test puts them on the null's side, or, at twenty lakes or more, where at most half fell. Every refutation carries a clause these rules cannot remove: "unless the estimates are distorted at low density beyond what the doubled intervals cover", since estimates both inflated and too narrow at low density refute T1's own world at the field's size (§13). So no plain *refuted* comes from these rules; their strongest refutation carries that clause alone;
- **not decided** otherwise, or where fewer than ten are resolved (§7).

Four confounds could make a refutation on their own: fish from connected waters, stocking the database misses (fry, and fish from tribal or private hatcheries), lakes below the need never surveyed again, and intervals that understate the error where few fish are counted. Decided now, a refutation one of them could make reads **refuted unless** that confound, with the clause above (§7).

**Reported beside it**, deciding nothing: **V2**, the *Refuted by*'s first form, a lake below its need returning with nothing recorded given, its lakes listed; and **renewal below the need** after 2012 against the fit's expectation, T1's second *Forbids*, where a need that moved shows (§7).

**Who decides.** Every value the verdict reads is recorded by WDNR or GLIFWC, families that neither wrote nor read the theory. Their fields decide the scope and much of the fate; code and a layout file frozen here decide the rest. After the freeze nobody of the theory's family chooses anything, and no model is called.

**The answer expected.** The likeliest is *not decided*: managers stock and relabel a falling lake, and at a stocking chance of 0.3 a year V1 was undecided in every dry-run archive (§8). If decided, the positive outcome is expected. Sass, Feiner and Shaw found depensatory recruitment in about half of 82 Ceded Territory lakes (§13), and recruitment lost to another cause, the alternative the field also weighs, predicts the same outcome. A refutation in its strongest form would mean the need is misplaced, unless the estimates are distorted beyond what the records show. The test's value is mainly its chance to refute: a positive outcome is weak evidence about the need, since several rival families produce it (§8). §11 says what each outcome means.

**What it cannot decide.** Two limits hold so far (5 November 2026), each for a reason in these records:
- **Why lakes fell.** The positive outcome cannot show that the lakes' renewal stopped because of their level. Lakes that lose renewal to another cause (habitat, warming), or in long chance spells, whatever their level, before the window or during it, stand below the need with nothing pending and keep falling: V1 came out positive there in up to 40 of 40 dry-run archives (§7). Hence the outcome's narrow name. The limit lapses with lakes stocked back above the need, whose renewal returns under a need in the level and not otherwise (§13).
- **One T1-false world.** Where fish surviving from a fall below the floor return a lake within a year or two (*survival compensates*), the return cannot be told from one carried by a recorded year class, so V1 is not decided (160 of 160 archives). The limit lapses with a record tying the returning adults to their year class, such as the spring estimates' age composition or yearling surveys. Two other T1-false worlds V1 does refute (§8).

## 2. Why this field, and the alternatives considered

**What a field test of T1 needs**, from T1's own words:
- a condition whose renewal stops below a need;
- the need fixed before the series is read, from a source independent of that series;
- the draw and the renewal recorded;
- giving from beyond absent or measured, since *Refuted by* reads "returning with no measured giving from beyond".

**Alternatives considered, and why each was set aside** (from documentation and the literature; no data value was read):
- **The RAM Legacy Stock Assessment Database** (v4.66, Zenodo 14043031). It is public with no account, MQ3 already holds it under Ren's approval of 20 October, and MQ3 has read its layout. It does not fit:
  - Critical depensation, renewal stopping below a need, is rarely detected in assessed fish stocks: in 3 of 128 stock-recruitment series (Myers, Barrowman, Hutchings and Rosenberg 1995), and in few more in later, longer series (Hilborn, Hively, Jensen and Branch 2014).
  - The few published Allee thresholds are fitted on the whole of each stock's series, the series a test would then read, so no year is held out. Here the need is fitted on the years up to 2012 and tested on the years after: independent by time, not by source. The published thresholds also mark impaired recruitment, not renewal that stops. Examples are St Pierre Bank cod (Perälä, Hutchings and Kuparinen 2022) and 4 of 17 depleted gadid and flatfish stocks (Tirronen, Perälä and Kuparinen 2022).
  - Stocks are open, so fish from adjacent stocks are giving from beyond that nobody measures.
  - MQ3 has already read the total biomass and catch of 113 stocks.
- **Broadcast spawners** (abalone, queen conch). Their needs come from fertilization and mating biology, independent of any fishery's series: a minimum density for reproduction of about 0.3 abalone per m² (Babcock and Keesing 1999) or 0.15 to 0.2 (Shepherd and Partington 1995), and queen conch mating seen only above about 56 per hectare and spawning above about 48 (Stoner and Ray-Culp 2000). They do not fit:
  - Their series are in agency reports, at few sites.
  - Larvae arrive from elsewhere, giving from beyond that nobody measures.
  - The draw after a fishery's closure is poaching, which nobody records.
  - At one index set the decline has already been reported: pinto abalone in the San Juan Archipelago fell 97% (from 359 to 12) from 1992 to 2017 at ten sites (Carson and others 2019). A test there could only be prospective.
- **Laboratory archives** (the yeast of MQ1, MQ2 and MQ6; the beetles of UE31). These are not field data, and T1's yeast tests are already in its *Evidence*.
- **Population archives without draws** (the Global Population Dynamics Database). They record no draw.
- **The walleye lakes.** These fit best:
  - the lakes are closed, except for stocking;
  - depensatory recruitment is documented in many of them;
  - the recorders publish each lake's adult estimates with intervals, its recruitment-source label, the stocking and the tribal harvest;
  - fall age-0 surveys run in most years.

  Their gaps are named in §3 and §5. The coordinator's argument settled the choice: a test with named gaps that can still fail beats none.

## 3. The records

Each is named by its recorder, read only after Ren's yes (§12), and turned into lakes by [`reader.py`](reader.py) under the layout assumed in [`layout.json`](layout.json):

| | Record | Recorder | What the test reads | What it leaves out |
|---|---|---|---|---|
| R1 | Spring adult population estimates, by lake and year, the FMIS report "WDNR Treaty Walleye Adult Population Estimate, statewide by year" | WDNR and GLIFWC (mark and recapture) | The estimate and its 95% interval, divided by the lake's acres; the lake's primary recruitment source; its characteristics, where they name its type | Years without an estimate (lakes are surveyed in rotation) |
| R2 | Fall recruitment surveys, by lake and year | WDNR and GLIFWC (electrofishing) | Age-0 walleye per mile of shoreline | Years not surveyed |
| R3 | Tribal harvest, by lake and year | WDNR, from the bands' declarations and creel | Walleye harvested | — |
| R4 | Angling harvest, by lake and year | WDNR creel surveys | Walleye harvested, in creel years | Every year without a creel survey |
| R5 | Fish stocking records | WDNR's stocking database | The years a lake was stocked with walleye of any size | Fry, and fish supplied by the U.S. Fish and Wildlife Service or by tribal or private hatcheries (the database's own note) |
| R5b | Other walleye stocking: fry, and fish from tribal or private hatcheries | The bands' hatcheries, through GLIFWC's reports; WDNR's annual stocking summaries where they give fry | The years a lake was so stocked | Whatever those reports omit; where they cannot be had, refutations stay qualified (§7) |
| R7 | Each lake's type (seepage, drainage, drained, spring, impoundment) | WDNR's lake records, where R1's lake characteristics do not give it | Whether a lake is a recorded seepage lake, with no inlet or outlet | Lakes with no recorded type |

R3, R4, R5b and R7 are optional: the run reads without them, and V1 reads neither R3 nor R4. The draw the test reads, the **recorded draw** `h`, is R3 with R4 where a creel survey ran that year, per acre. It is a lower bound on the joint draw. V1 does not read it (§7), so its gaps do not enter the verdict. The point with it is reported.

Sass, Feiner and Shaw's (2021) per-lake stock-recruitment estimates are not an input. Where Ren can have the paper, the write-up of the run sets their findings beside the test's, read by hand and marked as a comparison (§4).

## 4. The need

**The floor.** A year's renewal counts as reaching the floor where its fall survey caught at least one age-0 walleye per mile of shoreline (`FLOOR`). WDNR's reports read a survey with no age-0 as no natural reproduction, and one per mile is the least catch a survey of a few miles of shoreline records above none. V1 is decided at this floor alone. The reports give it also at 0 (any age-0 caught), 5 and 10 per mile (`FLOORS_REPORTED`); a 2014 conference abstract, seen only in a search summary, reads ten per mile as successful recruitment.

**The data.** Every lake-year up to 2012 (`CUTOFF`) with both a spring adult estimate and a fall survey, the label natural recruitment that year and no stocking recorded in it or the five years before (`pairs`), gives one pair. Stocked years are left out because their fall age-0 can be stocked fish. The level is the adults per acre, and the outcome is whether that fall's renewal reached the floor.

**The fit.** A logistic regression of the outcome on the logarithm of the level, fitted by maximum likelihood with a small penalty (`RIDGE`, 0.001) that keeps it finite where the classes separate.

**The need** is the level at which the fitted chance of renewal reaching the floor is one half (`need`). Below it renewal is rarer than at it, not stopped: one half is where the fit's classes meet, not a level below which none renew. One need serves every lake, and no lake's need reads its own later series: a lake's years up to 2012 enter the pool with every other lake's.

**No need.** The fit gives none, and V1 is not decided, where:
- the pairs number fewer than 200 or come from fewer than 30 lakes;
- the fit does not converge;
- the slope's lower 95% bound is not above zero, so renewal is not shown to rise with the level;
- fewer than 20 of the fit's lake-years lie on either side of the need (`SIDE_MIN`), so the need lies where the data do not reach;
- the need's exponent overflows.

No need found is a finding: the lakes then lie outside T1's scope, not against it, as most assessed fish stocks do.

**The cutoff.** 2012 is the last year before the Wisconsin Walleye Initiative widened the stocking of large fingerlings from 2013. The references start in 2013.

**A published need, set aside.** The draft had a second branch, each lake's need from Sass, Feiner and Shaw's (2021) per-lake curves, preferred where twenty lakes had one. Round 1's reader found it unworkable (N-14, N-22), and the coordinator agreed to drop it:
- no published table gives the curves in a form the code reads, so someone of the theory's family would have had to transcribe them after the freeze, choosing how the paper's models map to the code's forms;
- a compensatory curve still yields a need, so lakes the paper found compensatory would have entered V1;
- the paper's data end before 2021, so its references could run a few years at most.

The paper's findings stay as a comparison only, read by hand in the write-up (§3).

## 5. The scope, by the recorders' own fields

A lake enters the test at a reference survey only where both of these hold (`in_scope`):
- the recorders' label of its primary recruitment source that year says natural recruitment. `layout.json` maps the label's texts; a text the map does not hold refuses the run, so no label is read as natural by default;
- no walleye stocking is recorded in that year or the five before it (`STOCK_BEFORE`), in WDNR's database or, where read, in the other stocking records (R5b). So the level read is not one that stocked fish make.

**Labels that never change.** The label may be the lake's classification when the report was made, not that year's. Where fewer than 5% of the lakes with two or more estimates change label category across them (`labels_per_year`), the rules read the label as deciding nothing, and the stocking records alone decide the scope and the fate. One lake's change may be a correction, so a share decides, not a single lake (round 2's N-37). The reader records which it found.

**The two confounds of giving, decided now.**
- **Connected waters.** A lake is *closed* where its recorded type is seepage, with no inlet or outlet. That type comes from R1's lake characteristics, or else from WDNR's lake records (R7), and is read by `reader.closed_of`. Any other named type (drainage, drained, spring, impoundment, flowage, reservoir, river) counts as open, and a lake with no recorded type is unknown. Walleye can reach an open lake from other waters.
- **Unrecorded stocking.** WDNR's database leaves out fry and fish from federal, tribal and private hatcheries. Where the other records (R5b) are read, their stocking enters the scope and the fate like the database's. Where they are not, the stocking they would show is unrecorded.

How a refutation is read in their light is in §7.

**What the scope leaves out.** The records give these as they are, and the test does not reach them:
- the angling harvest outside creel years;
- whatever stocking R5b omits;
- immigration into a lake recorded as seepage, by a route its type does not show.

**The reader's refusals.** `reader.py` refuses, rather than reads on, where a required file or column is missing, where a file's lake codes match none of the estimates' (codes are read in one form, so "123456", " 123456 " and "123456.0" agree), and where a stocking file holds no row of the species as `layout.json` names it.

## 6. The premise, the reference and the fate

**The ratio test.** The rules read every change in a lake's adults the same way (`change`). For surveys a and b, each estimate's standard error on the log scale is read from its own 95% interval, s = (ln upper − ln lower) / 3.92. The change is z = (ln est_b − ln est_a) / √(s_a² + s_b²). It is a **decline** where z < −1.645 and a **rise** where z > 1.645, each one-sided at 0.05. Where an estimate or a bound is not positive, the change cannot be read.

Why this test, and not the draft's two readings:
- The draft read a fall as the later interval below the need (round 1's N-01). A lake that holds its level below the need then counts for T1, though T1, renewal rarer and the draw going on, predicts it declines. Holding below the need is evidence against T1, and with lakes of different productivity it is what a world with no need produces (N-03).
- Reading a decline as the later interval wholly below the earlier one, as round 1's reader suggested, asks at the surveys' error (a CV near 0.25) for a fall of 62%. A fall T1 predicts would often go unseen, and a lake stuck near zero, which can fall no further, would count against it. The ratio test asks for the fall the two intervals together resolve, 44% at that error.

**The premise** (`held_above`). T1 speaks of a condition whose renewal met the draw above the need, so a lake enters the test only where that was shown before the cutoff. It needs two estimates up to 2012, at most ten years apart, both with their lower bounds at or above the need, with no decline between them by the ratio test, the label natural at both and no stocking recorded from five years before the first to the second. A lake that was never shown above the need, or shown only while it declined, is one to which the need is not shown to apply.

**The window.** References run from 2013 to the archive's last estimate year less three, which the layout step reads. A reference needs a later estimate three to ten years after it (`GAP_MIN`, `GAP_MAX`).

**Below the need** (`below_read`). A survey is read as below the need, where T1 predicts a fall, where both hold:
- its interval lies wholly below the need, so a survey low by chance is not read as a lake below it, whose next survey would regress upward;
- no fall survey in the three years before it reached the floor (`pending`, `RECRUIT_LAG`).

Walleye join the adults about three years after their fall. A year class already in the water is renewal made, part of the lake's condition, and it can lift the adults within the fate's horizon, so a lake with one recorded is not shown below its need. In the dry runs, such cohorts carried lakes in T1's own world back above the need after a winterkill, and kept cycling lakes up between their strong years (§8). A survey set aside this way is reported with its fate by the same reading. A year of the lag that was not surveyed does not set the survey aside, since a cohort the surveys missed can only lift the lake, against T1.

**The reference** is the lake's first survey in time, in the window, that is in scope and readable: read as below the need, where T1 predicts a fall, or with its interval wholly above the need, where T1 predicts persistence (`rows`). A survey whose interval holds the need and one set aside for renewal pending are passed over, as is one above the need with no later estimate; a lake whose first readable survey is below the need with no later estimate is marked unsurveyed (below). The choice reads only each survey's own interval, the need and the renewal recorded before it, never a later value.

Taking the first readable survey in time, and not the first below the need wherever it falls, keeps a lake's side from being chosen by whether it later went below. A lake that falls from above the need, for whatever reason, then counts on the side where it stood. The draft took the first survey below the need, and failing that the first above it. Under that choice a world where a fifth of lakes lose their renewal after 2012 to a cause other than the stock came out positive in 9 of 40 archives with no managers. Every lake that fell for that cause was read from below the need, and the lakes left above it were those that did not fall (§8).

**The fate**, between the reference and the first later estimate (`fate_of`), read the same way on either side of the need, so the separation compares like with like:
- **Unresolved** where the recorders' label leaves natural recruitment at a survey after the reference, up to the fate's, or stocking is recorded after the reference, in WDNR's database or in R5b: giving from beyond, or a programme's relabelling, either way. A relabelling counts no fall by itself. §8 gives the reading set aside, the label alone counted as a fall, and which side it favours.
- **Fell** where the fate's survey lies below the reference's by the ratio test, and no later survey within ten years of the reference, before any recorded giving, rises from the fate's by the test. A rise after a decline is a recovery, a return T1 forbids below the need, and the lake is then read at the recovering survey.
- **Persisted** where the later estimate keeps at least a quarter of the reference's at the ratio's one-sided lower bound at 0.05 (`ratio_lower`, `KEPT`): the level kept, a rise, or a return.
- **Unresolved** where the intervals show neither a decline nor a quarter kept, or where an interval cannot be read on the log scale.

Why persistence is shown, not read by default (round 2's N-29). Mark-and-recapture's precision falls with density, so below the need the same test has less power. With persistence the default, a T1 world whose estimates' CV widens at low density, as mark-and-recapture's does, was refuted in some form in 32 to 37 of 40 archives. Why a quarter, not the half round 2's reader suggested. At the surveys' usual error, every change short of a decline by the test keeps a quarter at the lower bound, so the rule reads there as before, and only wide intervals go unresolved. That holds exactly where the two surveys' joint log-scale error is at most ln 4 / (2 × 1.645) = 0.421, each CV up to 0.298 when they are equal. One case differs even then (round 3's N-45): a recovery that does not keep a quarter of the reference is now unresolved, where the earlier rule read it as persisted. Round 3's reader counted the change in the dry run: 141 of 9,562 rows of *need* at 0.03, and 186 of 10,693 with no managers. At a half, the band of unresolved changes reached the usual error. Lakes declining slowly below the need, which T1, renewal rarer and the draw going on, does not predict, then went unresolved instead of counting against it, and a no-need world of widely differing lakes came out positive in 7 of 40 archives.

Why the recovery: renewal can fail by chance three years running in a world with no need. The stock then dips for three years whatever the law, and recovers once renewal comes back. T1 forbids that recovery below the need, and a law without a need predicts it. The episodic worlds of §8 are that case.

**The unsurveyed.** A lake whose first readable survey is below the need with no later estimate three to ten years on is marked (`below the need with no later estimate`), where the archive runs at least ten years past that survey. Recorders may stop surveying a lake once it has fallen, so such lakes are counted in §7's third confound. Where the archive ends sooner, the missing estimate is the archive's end, not a survey stopped, and the lake is not marked (round 2's N-30).

## 7. The verdicts

**V1** (`v1`, `decide`). Every lake in the test has a row. T1 predicts a fall at a reference read as below the need, and the null predicts none, so the two classifiers differ on exactly those lakes. Let n be the ones with resolved fates and k the ones that fell, and let c be the critical count of an exact one-sided sign test at 0.05, which is McNemar's test on the discordant lakes: 9 of 10, 11 of 14 and 15 of 20. Let n_a and k_a be the same counts above the need. The rule, in this order:
1. Not decided where n < 10 (`N_MIN`).
2. ***Refuted by*'s second form not met** (the positive outcome) where k ≥ c and, by Fisher's exact test at 0.05, the share fallen below the need exceeds the share fallen above it. The verdict line reads in full: "*Refuted by*'s second form not met: the fates separated across the need, below it k of n falling, more than chance allows and more often than above it (k_a of n_a); r came back above the need within ten years, before any recorded giving, v of them at the fate's survey with every year of the lag surveyed (V2); the need's causal role not shown". Here r counts, of the n, the lakes with a survey wholly above the need at any time from the reference to ten years after, before any stocking or relabelling is recorded. Where k ≥ c but the lakes below did not fall more often than those above by Fisher's test, the verdict says so, with k_a of n_a; where none above is resolved, it says that. Either way, not decided.
3. Refuted, the fates separated no better than by the null, by either of two routes, the verdict carrying the residual clause of §13 and any confound below:
   - k ≤ n − c: so few fell that the same test at 0.05 puts the fates on the null's side. That is at most 1 of 10, 3 of 14 or 5 of 20.
   - by the home's letter, 2k ≤ n, where n ≥ 20 (`N_REFUTE`).
4. Not decided otherwise.

**What the positive outcome allows.** It allows n − c lakes below the need that did not fall: 1 of 10, 3 of 14, 5 of 20. MQ3's frozen test asked a fall share of 80%, and MQ2's 90% on each side; the positive outcome here can carry a share near 75% at twenty lakes. So V1 reports the share fallen below the need with its exact lower bound at 0.95 (Clopper and Pearson's) beside the verdict, and §11 reads the outcome with it.

**Why the positive outcome is named so narrowly** (round 2's N-28 and round 3's N-42, N-43 and N-46, the coordinator's decision). It shows what V1 checks: the fates separated across the need, and how many lakes below the need came back above it. It does not show that no lake came back, for up to n − c may not have fallen, and in the dry run's own positive archives one sometimes did. Nor does it show that the lakes' renewal stopped because of their level. Round 2's reader built a world where 20 to 30% of lakes lose all renewal to another cause, from a year between 1998 and 2012. Those lakes pass the premise on their earlier estimates, stand below the need at their first readable survey with nothing pending, and keep falling, while the lakes above persist. V1 came out positive there in up to 40 of 40 archives. Four guards, tried in memory, did not separate that world from T1's without losing T1's own: the premise read at the cutoff, no renewal failing while above the need, the order of failure, and a report of renewal failing above the need. Round 3's reader found the same where renewal is lost after 2012 in widely differing lakes, and where it is cut, whatever the level, in chance spells averaging twenty years. So the outcome's name says what it shows. §8's bound holds for worlds where renewal never stops with the level and its chance failures are independent from year to year. It does not hold for renewal lost for years at a time, by a cause or by chance, and §13 names the record that would tell the two apart.

**Why the separation as well as the sign test.** The sign test asks whether the lakes below the need fell more often than not. Fisher's test asks whether they fell more often than the lakes above it. A world with no need can make lakes fall on both sides: where renewal fails by chance for years, or where some lakes cannot persist at any level. There the lakes above the need fall too, and the separation keeps the positive outcome from resting on falls that come whatever the side (§8).

**A refutation, read against the four confounds**, decided before any value is read:
- **Connected waters.** Where a lake counted as persisting is not a recorded seepage lake, V1 is decided again on the closed lakes alone. Where that is not also a refutation, the verdict reads *refuted unless connected waters*, with its reason: "the seepage lakes alone too few to decide" (fewer than ten resolved), "the seepage lakes alone too few to refute by the letter" (at most half fell, but fewer than twenty resolved; round 5's N-64), or "the seepage lakes alone not refuting". At three hundred lakes the first is usual, whether or not fish arrive from other waters (round 2's N-31). So the reports also give the persisting share below the need among closed and open lakes, and Fisher's chance that the open lakes persisted more often.
- **Unrecorded stocking.** Where R5b was not read for a lake counted as persisting, the verdict reads *refuted unless unrecorded stocking*.
- **The unsurveyed.** Where the lakes marked unsurveyed (§6), counted as fallen, would undo the refutation, it reads *refuted unless the unsurveyed fell*.
- **The intervals at low density** (round 3's N-44). Mark-and-recapture counts few fish where a lake is low, and its interval can understate the error there. V1 is decided again with every interval below 2 adults per acre twice as wide on the log scale (`widen`), the premise, the references and the fates read anew. Where that reading does not refute, because it resolves too few lakes or because it does not refute them, the verdict reads *refuted unless the intervals understate the error at low density*, with its reason, read as for connected waters: the widened reading too few to decide, too few to refute by the letter, or not refuting. The qualifier also catches refutations that rest on slow declines below the need, which widened intervals no longer show keeping a quarter. So in a world where the need is misplaced and the intervals are honest (*renewal below the floor*), refutations with no named confound at 300 lakes fall from 40 of 40 to none at 0.03 and 19 with no managers, while at 900 lakes they stay at 35 and 40 of 40 (§8).
- Two or more of these read together, joined by "or". V1's numbers keep the readings these clauses rest on, the closed lakes alone and the widened reading, each named as read before the clauses, so that no raw "refuted" stands in the record as a verdict.
- **The residual, always** (the coordinator's decision, round 4). Estimates both inflated and too narrow at low density refute T1's own world with no named confound at 900 lakes, about the field's size, and no reading these records allow separates that from a misplaced need (§13). So every refutation ends "…, or the estimates are distorted at low density beyond what the doubled intervals cover", and one with no named confound reads "refuted unless the estimates are distorted at low density beyond what the doubled intervals cover". That is the strongest refutation these rules can give. It still lets the test fail, in the form the records allow. The clause would go only with a record that rules the distortion out (§13), which the layout step looks for.

None qualifies the positive outcome: each can only make a lake below the need persist or drop out, so each works against it.

**Why the letter needs twenty lakes.** The letter, no better than the null, is the one T1-STANDING read as met at equal accuracy after the salt shock, and it is kept. As a point estimate it is weak evidence at few lakes. Suppose a lake below the need falls with chance 0.7. Then at least half of 10 lakes survive with chance 0.15, and at least half of 20 with 0.048. So the letter is read at twenty lakes or more. At fewer, a refutation needs the fates on the null's side at 0.05, which a fall chance of 0.7 gives among 10 lakes with chance 0.00014. The positive outcome at ten needs 9 of 10, which a fair split between falling and not gives with chance 0.011.

**Why the need alone, not the point with the draw.** T1's point of no return is the need with a standing draw. Here the draw does not stand: safe harvests are set from each lake's estimates, so the harvest is cut as a lake falls. A lake whose draw would end it can then persist because the draw changed. That is a breach of T1's standing-draw premise, not evidence against T1. Below the need, T1 predicts a fall under any draw, so V1 reads the need alone. The rows also give each reference's point with the recorded draw, and the reports give the fates of lakes above the need and below that point.

**V2** (`v2`), reported. It counts the lakes read as below the need at the reference with every year of the lag surveyed and none at the floor, whose fate's interval lies at or above the need, with the natural-recruitment label at every survey between and no stocking recorded after the reference. It is *met* where at least one such lake exists, and each is listed. The positive outcome's line counts V2's lakes among those that came back, and names them.

**Renewal below the need** (`renewal_below`), reported. Among the lake-years after 2012 with a spring estimate wholly below the need and a fall survey that year, the label natural and no stocking recorded in it or the five years before, it counts those whose renewal reached the floor, and sets against them the number the need's fit expects there: the sum of the fit's chances at their estimates. It gives the exact chance, under the fit, of so many or more. This reads T1's second *Forbids* as far as a need at the 50% point can: below the need some renewal is expected, and more than the fit allows means the need moved after 2012. Such a move hides from V1, because the lakes that would show it renew and are set aside (§6).

**Reports**, ruling on nothing (`reports`):
- the lakes out, by reason;
- the fates below the need by route (the years taken out), by reference year (fates in one year can share a region-wide cause, so V1's p is optimistic where the years cluster) and by whether every year of the lag was surveyed;
- the recorded draw at the reference, per adult, below the need and above it: T1's lakes are driven below the need by the draw, and renewal lost to another cause needs none;
- the persisting share below the need among closed and open lakes;
- the surveys set aside with renewal pending, by their fate;
- the fates of the lakes above the need but below the point with the recorded draw;
- the references with a creel survey;
- V1 at the floors 0, 5 and 10;
- V1 on the recorded seepage lakes alone;
- V1 without the three lakes of §9's disclosure.

## 8. Dry runs

[`dry_run.py`](dry_run.py) builds synthetic archives of 300 lakes, 1990 to 2025, and reads each with the frozen rules. Its record is [`results/dry-run.json`](results/dry-run.json): 238 checks, none failed, 319 CPU seconds.

**The model.** Each year, spring adults per acre x renew by fall age-0 r = R(x)·e^(σz), with R(x) = 60 x^q / (1.5^q + x^q) and σ = 0.8. Next spring's adults are 0.7x − h plus 0.03 times the age-0 of three years before. The exploitation e is drawn per lake from 0.05 to 0.6, and above 0.3 a lake keeps no level. The draw is h = e·x, cut to 0.05·x below one adult per acre, as safe harvests are; lakes exploited hard then cycle, a strong year class every few years carrying them between lean ones. In a year, a lake loses nine tenths of its adults with chance 0.02 (a winterkill). A lake is a recorded seepage lake with chance 0.4.

**What the recorders do.**
- They estimate adults every three to five years, with log-normal error at a CV of 0.25 and a 95% interval.
- They survey age-0 every year at 70% of lakes, and at the rest in 40% of years.
- 40% of lakes are speared, and the tribal part of the harvest is recorded; angling is recorded only in creel years (a fifth).
- Below one adult per acre, managers stock a lake with a chance a year (the speed) and relabel it.
- The other stocking records (R5b) are read, and empty, in every world but the two named below.

**The worlds**, in four families and one reported apart:
- **T1 holds**, renewal stopping below a need:
  - *need*: q = 3;
  - *needs vary*: each lake's 1.5 scaled by a factor of about 2;
  - *need rises*: 1.5 doubled after 2012;
  - *relabelled*: managers also relabelling and stocking lakes at 0.03 a year from 2013 whatever the stock, a programme rather than a fall;
  - *unrecorded*: a third of stocked lakes stocked outside WDNR's database with the label kept, and R5b not read; *unrecorded, read*: the same, with R5b read and holding those stockings;
  - *open*: 0.15 adults per acre a year arriving from connected waters, in the lakes not recorded as seepage;
  - *episodic*: q = 3 with σ = 1.6;
  - *unsurveyed*: no estimate made of a lake below 0.03 adults per acre; *unsurveyed early*, reported: below 0.15;
  - *static labels*: each lake's label its last, in every year;
  - *estimates widen*: the estimates' CV 0.25·(2/x)^0.5 below 2 adults per acre, up to 1.0, their intervals as wide, as mark-and-recapture's widen at low density (round 2's N-29);
  - *labels follow failure*, reported: recorders relabelling a lake whose last three surveyed falls fell below the floor, with chance 0.5 a year; *slowly*, with 0.2 (round 2's N-33);
  - *estimates inflate at low density*: estimates below one adult per acre inflated by (1/x)^0.7; *intervals understate the error*: the true CV 0.25·(2/x)^0.7 below 2, up to 1.5, the stated interval at 0.25; *inflated and understated*: estimates inflated by (2/x)^0.5 below 2 and the true CV widening as (2/x)^0.5, up to 1.0, the interval at 0.25 (round 3's N-44).
- **The need misplaced**, where the surveys put a need and T1 is false, or holds only within the intervals' margin:
  - *survival compensates*: age-0 depensatory, but the adults they make rise as age-0^0.3 (with 0.4 for 0.03), so a lake below the need returns within a year or two; and *compensates, relabelled*;
  - *renewal below the floor*: the same with 0.10, so a lake below the need, renewal under the floor, holds there for years;
  - *weak depensation*: q = 1.5 with σ = 1.6, renewal stopping well below the 50% point, so lakes just below the need recover;
  - *need falls* and *need falls far*: 1.5 halved, or quartered, after 2012.
- **No need**, renewal never stopping with the level, its chance failures independent from year to year:
  - *no need*: q = 1;
  - *lakes differ*: q = 1, each lake's 60 and 0.03 scaled by independent log-normal factors of log-sd 0.5, 0.7, 1.0 or 1.5, so that some lakes cannot persist at any level;
  - *general decline*: renewal falling 4% a year everywhere;
  - *no need, relabelled* and *no need, unsurveyed*: the relabelled and unsurveyed variants, at log-sd 0.7;
  - *renewal unseen*: surveys catching age-0 in proportion to x/(x + 0.5);
  - *floor by chance*: a survey reaching the floor with a chance rising slowly with x, whatever the lake renews;
  - *episodic, no need*: σ = 2.5, so renewal fails by chance for years at any level; and *episodic, lakes differ*: σ = 2.0 at log-sd 1.0;
  - *catch 0.1*: *no need*, *lakes differ 0.7*, *lakes differ 1.5* and *general decline* with the surveys' age-0 catch at a tenth, so that the need is fitted where T1's world fits it, near 0.35 adults per acre, and not near zero (round 2's N-32).
- **Renewal lost for years**, by a cause such as a habitat lost or warming, or in chance spells, whatever the level; reported, with no bound:
  - *renewal stops after*: at log-sd 0.7, a fifth of lakes losing all renewal after 2012; *lakes differ widely*, the same at log-sd 1.5 (round 3's N-46);
  - *no renewal in some*: at log-sd 0.5, 15% of lakes with no renewal ever;
  - *renewal lost before*: 30% of lakes losing all renewal from a year between 1998 and 2012, with the catch at a tenth, or at log-sd 0.7 (round 2's N-28); *across the cutoff*: 30% from a year between 2005 and 2020, at log-sd 1.0 (round 3's N-46);
  - *renewal lost in spells*: renewal cut to 2% in spells entered and left with chance 0.05 a year, about twenty years each; *lakes differ*, at log-sd 0.7, left with chance 0.1 (round 3's N-43).
- **Reported apart**: *half need*, half the lakes at q = 3 and half at q = 1.

**The families, changed after findings.** Round 2's brief to its reader defined the no-need family as renewal that "never stops with the level, though it may fail by chance or stop for another reason". After round 2's N-28 the coordinator narrowed it to renewal that never stops with the level, chance failures included. Renewal lost to another cause became a family of its own, whose rates are reported with no bound. After round 3's N-43 the no-need family's chance failures are those independent from year to year. Renewal cut for years at a time in chance spells, whatever the level, belongs to the renewal-lost family. Both narrowings came after the reader's worlds showed V1 positive in up to 40 of 40 archives, and after guards tried in memory failed to separate them from T1's world (§7). The bound of 5 in 40 does not hold for renewal lost for years, by a cause or by chance. The answer is the positive outcome's narrow name, "the need's causal role not shown", not a bound.

**The quarter, set after a dry run.** The share a lake must be shown to keep to count as persisting (§6) was set at a quarter after the dry run, where a half came out positive in a no-need world (*lakes differ 1.5*) in 7 of 40 archives. It was chosen against synthetic worlds, before any data. At the surveys' usual error it equals the earlier rule. Compared with a half, it counts more lakes as persisting on both sides of the need. Below the need that makes a refutation easier, not harder. Above it, it lowers the share fallen there, which the separation compares against. The table's no-need rows, with no positive outcome, are read with the quarter in place.

V1's verdicts in 40 archives a cell, by the managers' stocking chance a year for a falling lake. P is the positive outcome, *Refuted by*'s second form not met, P* the same with V2 met, R refuted in its strongest form (the residual clause alone), R? refuted unless a named confound too, and N not decided. V2 met, in archives, is after the slash:

| World | 0.3 | 0.1 | 0.03 | 0 |
|---|---|---|---|---|
| **T1 holds** | | | | |
| need | N 40 / 0 | N 40 / 0 | P 29, N 11 / 0 | P 40 / 0 |
| needs vary | N 40 / 0 | P 3, N 37 / 0 | P 40 / 0 | P 40 / 0 |
| need rises | N 40 / 0 | N 40 / 0 | P 40 / 0 | P 40 / 0 |
| relabelled | N 40 / 0 | N 40 / 0 | P 21, N 19 / 0 | P 38, N 2 / 0 |
| unrecorded | N 40 / 1 | N 40 / 4 | P 23, P* 3, N 14 / 6 | P 40 / 0 |
| unrecorded, read | N 40 / 0 | N 40 / 0 | P 29, N 11 / 0 | P 40 / 0 |
| open | N 40 / 0 | N 40 / 0 | P 2, N 38 / 0 | P 15, N 25 / 0 |
| episodic | N 40 / 0 | P 37, N 3 / 0 | P 40 / 0 | P 40 / 0 |
| unsurveyed | N 40 / 0 | N 40 / 0 | N 40 / 0 | P 9, N 31 / 0 |
| unsurveyed early | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| static labels | N 40 / 0 | P 1, N 39 / 0 | P 34, N 6 / 0 | P 40 / 0 |
| estimates widen | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| labels follow failure | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| labels follow failure, slowly | N 40 / 0 | N 40 / 0 | N 40 / 0 | P 7, N 33 / 0 |
| estimates inflate at low density | N 40 / 0 | N 40 / 0 | N 40 / 0 | R? 14, N 26 / 0 |
| intervals understate the error | N 40 / 0 | N 40 / 1 | P 1, R? 1, N 38 / 3 | P 4, R? 11, N 25 / 3 |
| inflated and understated | N 40 / 0 | N 40 / 0 | R? 6, N 34 / 4 | R? 29, N 11 / 11 |
| **The need misplaced** | | | | |
| survival compensates | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| compensates, relabelled | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| need falls | N 40 / 0 | N 40 / 0 | P 4, N 36 / 0 | P 26, N 14 / 0 |
| need falls far | N 40 / 0 | N 40 / 0 | N 40 / 0 | P 1, N 39 / 0 |
| weak depensation | N 40 / 0 | N 40 / 0 | N 40 / 1 | R? 4, N 36 / 2 |
| renewal below the floor | N 40 / 0 | R? 4, N 36 / 0 | R? 40 / 1 | R 19, R? 21 / 0 |
| **No need** | | | | |
| no need | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| no need, catch 0.1 | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| lakes differ 0.5 | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| lakes differ 0.7 | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| lakes differ 1.0 | N 40 / 0 | N 40 / 0 | N 40 / 0 | R? 5, N 35 / 0 |
| lakes differ 1.5 | N 40 / 0 | N 40 / 0 | N 40 / 0 | R? 8, N 32 / 0 |
| lakes differ 0.7, catch 0.1 | N 40 / 0 | N 40 / 0 | N 40 / 1 | N 40 / 0 |
| lakes differ 1.5, catch 0.1 | N 40 / 0 | N 40 / 1 | N 40 / 1 | N 40 / 0 |
| general decline | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| general decline, catch 0.1 | N 40 / 0 | N 40 / 2 | R? 20, N 20 / 2 | R 1, R? 39 / 3 |
| no need, relabelled | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| no need, unsurveyed | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| renewal unseen | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| floor by chance | N 40 / 0 | N 40 / 2 | N 40 / 1 | N 40 / 2 |
| episodic, no need | N 40 / 0 | R? 1, N 39 / 2 | R 1, R? 30, N 9 / 8 | R 9, R? 28, N 3 / 14 |
| episodic, lakes differ | N 40 / 0 | N 40 / 0 | R? 3, N 37 / 3 | R 1, R? 29, N 10 / 7 |
| **Renewal lost for years** | | | | |
| renewal stops after | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| renewal stops after, lakes differ widely | N 40 / 0 | N 40 / 0 | P 1, N 39 / 0 | P 4, R? 3, N 33 / 0 |
| no renewal in some | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| renewal lost before, catch 0.1 | N 40 / 0 | P 39, N 1 / 0 | P 40 / 0 | P 38, P* 2 / 2 |
| renewal lost before, lakes differ | N 40 / 0 | P 4, N 36 / 0 | P 38, N 2 / 0 | P 39, N 1 / 0 |
| renewal lost across the cutoff | N 40 / 0 | N 40 / 0 | P 8, N 32 / 0 | P 29, N 11 / 0 |
| renewal lost in spells | N 40 / 0 | P 9, N 31 / 0 | P 33, N 7 / 0 | P 32, P* 1, N 7 / 2 |
| renewal lost in spells, lakes differ | N 40 / 0 | N 40 / 1 | P 3, R? 12, N 25 / 0 | P 3, R? 14, N 23 / 7 |
| **Reported apart** | | | | |
| half need | N 40 / 0 | N 40 / 0 | P 2, N 38 / 0 | P 22, N 18 / 0 |

**The checks on the worlds**, each failing the dry run if not met:
- in every no-need world, and every world with the need misplaced but *need falls*, at every speed: the positive outcome in at most 5 of 40 archives. A test at 0.05 exceeds 5 of 40 with chance 0.014;
- in *need* with no managers: the positive outcome in at least 30 of 40, the draft's bar, set before any of these results. At 0.03 the result is reported, with no bar: round 2's reader showed that a bar set after seeing a result cannot inform (N-36);
- in *renewal below the floor*, at 0.1, 0.03 and with no managers, and in *weak depensation* with no managers: refuted, in some form, more often than the positive outcome. A bar of 30 plain refutations of 40 in *renewal below the floor*, set in the rework, does not hold under round 3's low-density qualifier (§7), which reads most of them *unless*. It is dropped and the counts reported, as round 2's N-36 asks of a bar the rule's change outruns;
- in *weak depensation* at 900 lakes an archive: a refutation in its strongest form reached. *renewal below the floor* and *inflated and understated* are run at 900 lakes too, and reported;
- in *open*, *unrecorded*, *unsurveyed*, *static labels*, *estimates widen*, *estimates inflate at low density*, *intervals understate the error* and *inflated and understated*: at most 5 refutations of 40 in the strongest form;
- the renewal report beyond the fit at 0.05 in at least 30 of 40 archives of *need falls far* with no managers, and in at most 5 of 40 of *need* at 0.03 and with no managers.

**Which side the label's reading favours.** The frozen reading counts a label leaving natural recruitment as no fall by itself (§6). The reading set aside, the label alone counted as a fall, is run beside it in the three relabelled worlds:

| World | 0.3 | 0.1 | 0.03 | 0 |
|---|---|---|---|---|
| relabelled, frozen | N 40 | N 40 | P 21, N 19 | P 38, N 2 |
| relabelled, label alone | N 40 | N 40 | P 28, N 12 | P 40 |
| compensates, relabelled, frozen | N 40 | N 40 | N 40 | N 40 |
| compensates, relabelled, label alone | N 40 | N 40 | N 40 | N 40 |
| no need, relabelled, frozen | N 40 | N 40 | N 40 | N 40 |
| no need, relabelled, label alone | N 40 | N 40 | N 40 | N 40 |

The label alone counted as a fall favours the positive outcome. With T1 true and lakes relabelled it gave 28 positive archives at 0.03 where the frozen reading gave 21, and 40 with no managers where it gave 38. V2 is the same under both readings (round 5's N-59), and no positive archive of these worlds met it under either. Where T1 is false or there is no need, neither reading decided any relabelled archive, so these worlds cannot show which side it favours there. The run does not report this reading (§13).

**What the dry runs show:**
- **Where there is no need, V1 never came out positive**: in none of the 2,560 archives of the sixteen no-need worlds. A need was fitted in 1,108 of them, in the catch-scaled worlds near T1's world's level. Where lakes differ in productivity, or renewal fails by chance from year to year, V1 was instead refuted in some form with slow managers, since lakes below the need recover there. That happened in up to 8 of 40 archives where lakes differ, and with no managers in 37 of 40 in *episodic, no need* and 40 of 40 in *general decline, catch 0.1*.
- **Where renewal is lost for years, V1 came out positive often**, since its words claim only that the second form of *Refuted by* was not met (§7):
  - *renewal lost before, catch 0.1*: 39, 40 and 40 of 40 at 0.1, 0.03 and with no managers;
  - *renewal lost before, lakes differ*: 4, 38 and 39;
  - *across the cutoff*: 0, 8 and 29;
  - *in spells*: 9, 33 and 33;
  - *in spells, lakes differ*: 0, 3 and 3;
  - *renewal stops after, lakes differ widely*: 0, 1 and 4;
  - *renewal stops after* and *no renewal in some*: never.

  This is §7's limit, and the reason the outcome says the need's causal role is not shown.
- **Where T1 holds, V1 came out positive once managers are slower than 0.1 a year, and was never refuted in the strongest form at 300 lakes.**
  - *need*: 29 of 40 at 0.03 and 40 of 40 with no managers.
  - *needs vary*, *need rises* and *episodic*: 40 of 40 at both.
  - *relabelled*, *unrecorded*, *unrecorded, read* and *static labels*: 21 to 34 of 40 at 0.03, and 38 to 40 with no managers.
  - *open* (2 of 40 at 0.03, 15 with no managers), *unsurveyed* (9 of 40 with no managers) and *unsurveyed early* (never) were rarely or never decided, since lakes below the need there drop out before their fate or come back from connected waters.
  - *estimates widen*: not decided in any of 160 archives, since persistence must be shown (§6).
  - *labels follow failure*: not decided in any archive at 0.5 a year; at 0.2 (*slowly*), positive in 7 of 40 with no managers (§13).
  - **Estimates distorted at low density** were refuted only *unless*, with no managers: 14 of 40 where estimates inflate, 11 where the intervals understate the error, 29 where both. At 900 lakes the combined shape was refuted with no named confound in 32 of 40 with no managers and 4 at 0.03, the limit §13 states and every refutation's clause answers.
- **What the rework cost.** At 0.03 *need* came out positive in 29 of 40 archives, where the draft supported it in 36. The draft's reading of a fall also supported a no-need world with varying lakes in 40 of 40 (round 1's N-03); V1 now comes out positive in no no-need world. Of the eleven undecided archives at 0.03:
  - six had fewer than ten resolved lakes below the need, nearly all of which fell;
  - four fell short of the critical count by one, and one by two;
  - the lakes that did not decline were mostly ones whose lag years went unsurveyed, so a year class the surveys missed lifted them. That is the cost of not setting aside a survey whose lag was unread, which §6 accepts because a missed cohort works only against T1.
- **Where the need is misplaced, V1 was refuted where the lakes below it hold there.**
  - *renewal below the floor*: refuted in some form in 40 of 40 at 0.03 and with no managers. In the strongest form in none at 0.03 and 19 with no managers, the rest read *unless the intervals understate the error at low density*. At 900 lakes, in the strongest form in 35 and 40 of 40.
  - *weak depensation* (renewal stopping well below the 50% point): refuted in 4 of 40 with no managers, each *unless*. At 900 lakes, in the strongest form in 5 of 80 archives, and positive in 3.
- **Where lakes below the need return within a year or two (*survival compensates*), V1 was not decided in all 160 archives.** Their surveys below the need come with renewal pending and are set aside, so the test cannot refute T1 there, and gives no positive outcome. This is a limit of the test, holding so far (§1, §13). The two worlds where the need is misplaced and V1 does refute stand beside it, not in its place.
- **Where the need fell after the fit within the intervals' margin (*need falls*), V1 came out positive in 26 of 40 with no managers.** The lakes read as below the old need are below the new one too. The renewal report was beyond the fit in 40 and 39 of 40 at 0.03 and with no managers. Where the need fell further (*need falls far*), V1 was not decided in 159 of 160 archives and came out positive in one, and the renewal report flagged 40 of 40 at slow managers.
- **The confounds never produced a refutation in its strongest form where T1 holds at 300 lakes**, in *open*, *unrecorded*, *unsurveyed*, *static labels*, *estimates widen* or the three distortion worlds.
- **Power rests on the managers' speed,** which no record gives before the data. At 0.3 a year V1 was not decided in any archive of any world. At 0.1 it came out positive in *episodic* (37), *needs vary* (3) and *static labels* (1), and in three renewal-lost worlds (39, 9 and 4).
- **V2 was met mostly where giving from beyond went unrecorded, renewal failed by chance, or the estimates were distorted**: up to 6 of 40 in *unrecorded*, 14 in *episodic, no need*, 11 in *inflated and understated*, and 7 in *episodic, lakes differ* and *in spells, lakes differ*. Elsewhere it was met at most three times in a cell, and never in *need*.
- **The renewal report** was beyond the fit in at most 2 of 40 archives of *need* at any speed, and in 39 or 40 of *need falls* and *need falls far* at slow managers. It was also beyond the fit:
  - in up to 17 of 40 in *needs vary*, where lakes whose own need lies below the common one renew below it;
  - in up to 19 of 40 where lakes differ widely (*lakes differ 1.5*, *no renewal in some*), where the need is an artefact of lakes of different productivity and the lakes below it renew;
  - in up to 38 of 40 in *renewal lost in spells*, where lakes renew below the need in their good years.

**The other checks.**
- **On scripted lakes, each rule at its thresholds:**
  - V1's verdicts at the critical counts of 10, 14 and 20 lakes;
  - the separation, the premise and the scope;
  - the ratio test, against a value worked by hand;
  - the fate: a decline, a quarter kept, neither shown, a recovery, and the recovery's survey read;
  - renewal pending and the surveys set aside;
  - the reference as the first readable survey;
  - V2, the four confounds, the archive's end, and the static labels;
  - the exact tail, the exact lower bound and Fisher's test, each against a case by hand;
  - the renewal report, against a case by hand.
- **The need's fit** recovers a known need within 25%. It gives none where renewal does not rise with the level, or rises too shallowly for the data to reach the need.
- **The reader** rebuilds the synthetic lakes from files in the assumed layout. It refuses each layout failure round 1 named, and gives the same structural facts with every value column overwritten. One lake changing its label in forty does not make the labels per year.
- **The run**, end to end on those files, reproduces the rules' verdict and reports every floor. It refuses an unrecorded input, a recorded file missing, and a second run.
- **The freeze's chain**, in stand-in git repositories, passes when whole. It refuses:
  - a changed file;
  - a forbidden addendum, and one that remaps a label text;
  - a cut chain;
  - a link, or `downloads.json`, committed twice;
  - a run before the freeze.

## 9. Data and what has been seen

**Read before this design** (documentation, abstracts and search results, no value of any record):
- 02 §5 (T1, its standing and evidence), T1-STANDING, and the summary blocks of MQ1, MQ2, MQ3 and MQ6 (study §253, §266, §272 and §314);
- AA's plan §7, and UE31's design §9 to §11 and its layout record;
- the abstracts of Sass, Feiner and Shaw (2021), Dassow and others (2023), Mrnak and others (2024) and Sass (2025, *FACETS*);
- WDNR's descriptions of its Treaty Reports, the tribal harvest page and the stocking database's coverage;
- the titles and columns of the FMIS adult estimate report, as a search engine's summary gave them;
- WDNR's Walleye 2021 plan's objective of three adults per acre for naturally reproducing lakes;
- reports of GLIFWC's survey programme (15 to 20 spring estimates and 100 to 150 fall surveys a year);
- round 1's reader, in addition: the abstracts of Myers and others (1995), Hilborn and others (2014), Tirronen and others (2022), Perälä and others (2022), Shepherd and Partington (1995), Babcock and Keesing (1999), Stoner and Ray-Culp (2000) and Carson and others (2019), the Wisconsin Walleye Initiative's page and a WDNR stocking summary.

**Not read:** any record's values, any figure of a lake's series, and the per-lake tables of the papers. The ScienceBase records were behind a bot check and were not opened.

**Seen by a reader, before the freeze** (round 3). Round 3's reader, a fresh Claude subagent, ran one web search for its finding N-48. The search engine's summary quoted fall-survey values for Worcester Lake, and for Crane and Chase Lakes, in Price County, from two WDNR reports (2024 and 2022). The reader did not open those pages, and no value entered any finding, rule or threshold. The author saw neither the summary nor the values, only the lakes' names and the reports' addresses in the reader's report. So that no verdict can rest on lakes whose values someone of the theory's family has seen, the run also reads V1 without those three lakes, and reports both. They are found by whole words of the county and of their names, case aside (`reader.SEEN`; "Price County" and "PRICE CO." are Price, and "Purchase Lake" is not "Chase"), and the layout step lists the lakes it finds. Where no lake's name is read, or none in the county matches, the run says so and computes nothing.

**What is assumed of the layout** ([`layout.json`](layout.json)), **and checked at the layout step:**
- the files' names, and the columns the reader takes from each;
- the label's texts and the rules' category for each (natural, combination, stocked, remnant). "REM" is mapped by its name to remnant, not natural recruitment. Its definition in the recorders' documentation was not found before this design, and the layout step records it. Whatever it says, a label other than natural recruitment makes the fate unresolved, so the map matters only where it reads a text as natural;
- the species' text in the stocking files ("Walleye", read without regard to case or spaces);
- that R1 gives per lake and year the estimate, both interval bounds and the lake's acres, so the reader divides by the acres; R2 age-0 per mile; R3 and R4 numbers of walleye; R5 the species and the number stocked;
- that R1 gives one estimate per lake and year. Where it gives more than one, the most precise, the narrowest interval on the log scale, is read and the others counted (round 4's N-53), an interval reaching zero counting as the widest (round 5's N-63);
- that R2 gives one fall survey per lake and year. Where it gives more than one, as two agencies' or two runs' surveys would, the largest catch per mile is read, since renewal any survey of the year caught was made, and the repeats are counted (round 5's N-62). A year class one survey recorded then sets a survey below the need aside (§6) and keeps its lake from V2, and in the need's fit the year counts as renewing where either survey's catch reaches the floor. A lake-year surveyed twice reaches the floor more often than one surveyed once, so where repeats are more common on one side of 2012 than the other, the renewal report (§7) can come out beyond the fit with no move in the need; the layout step counts them on each side (round 6's N-67).

Both are decided now, since an addendum may not change a rule.

Where any differs, an addendum changes `layout.json` alone (§14): files, columns and the species' text as found, and label texts added. It never remaps a text the map already holds, which would change the scope and the fates, and `run.py` refuses an addendum that does (round 2's N-39). Where a quantity the rules need is missing, both interval bounds or the age-0 survey's unit, the reader refuses, and the layout record says so.

## 10. The run's order

Each step is committed before the next.

1. **The downloads**, on Ren's yes (§12): each record as a CSV file in one folder outside the repository, its source, date, size and sha-256 recorded in `downloads.json`.
2. **The layout, with no value read.** `python3 -B reader.py layout FOLDER` gives each file's header and row count, and nothing else. `python3 -B reader.py facts FOLDER` gives what is recorded beside it, read from the structural columns alone (the lake, the year, the label, the characteristics, the species and the type), never an estimate, an interval, a count or a number stocked:
   - the label's distinct texts, those the map does not hold, and the lakes whose label category changes across years, of the lakes with two or more estimates;
   - the water body types named, and the lakes recorded closed, open or of no type;
   - the species' texts in the stocking files, and the rows of each file whose lake code matches R1's;
   - whether R5b and R7 could be had;
   - the archive's last estimate year, which settles the reference window;
   - the lake-years up to 2012 with both an adult estimate and a fall survey, and their lakes, against the fit's 200 pairs from 30 lakes;
   - the lakes with a candidate reference, and those of them recorded closed;
   - the lake-years R1 gives more than one estimate for, and those R2 gives more than one fall survey for, these up to 2012 and after it, each lake-year counted once (round 6's N-67 and N-68). The fall surveys are counted by lake and year alone, so a row with a blank catch counts here though the reading skips it;
   - the lakes of §9's disclosure it finds, by name and county;
   - R1's columns that may give mark-and-recapture counts, the record that would lift §13's residual.

   Where the layout differs from the one assumed, an addendum changes `layout.json` alone, and the dry run's reader checks run again on synthetic files in the new layout.
3. **The run** (`python3 -B experiments/need-measured-in-advance/run.py FOLDER`, writing `results/run.json`): the need, then V1, V2, the renewal report, the rows and the reports, at each floor, kept whatever they are. Beside them it gives V1 without the three lakes of §9's disclosure. Where the records give no lake names, or no lake in the county matches, it says so. `run.py` refuses unless the freeze checks (§14); unless `downloads.json` is committed once and never changed, every file it records is in the folder with its sha-256, and no other input file is (round 2's N-38); and where `results/run.json` already exists.

**Why the layout is read after the freeze** (round 1's N-15). UE31's lesson is to check, before freezing, that the inputs can meet every rule's minimum. Here the headers cannot be read without the downloads, which wait on Ren, while the freeze does not wait: AGENTS.md has designs prepared fully, freezing designs included. What the lesson guards against is a freeze that the data cannot meet, and three things keep that from deciding anything:
- the layout step reads structure only, and the dry run checks that its facts are the same with every value column overwritten;
- an addendum can remap files and columns and add label texts, never change a rule or remap a label text;
- a minimum the data cannot meet leaves V1 not decided, with the reason recorded, never decided some other way.

## 11. What each outcome means

Fixed before the run.

| V1 | What it means |
|---|---|
| *Refuted by*'s second form not met: the fates separated across the need, with the lakes that came back counted, the need's causal role not shown | Lakes read as below a need measured in advance declined, by the recorders' own intervals and without recovering, more often than chance allows and more often than the lakes above the need. T1's *Refuted by* in its second form could have been met and was not, in the field, for the first time. The lakes that came back above the need are counted in the line, and up to n − c may have. It does not show that the lakes' renewal stopped because of their level, since renewal lost to another cause gives the same (§7), so it is not to be reported as T1 supported. It is read with the share fallen and its lower bound: 75% says less than 95%. It says nothing of the stocking the records miss, or of the lakes with renewal pending, which it set aside. |
| the same, with V2 met | The same, but at least one lake below the need, its lag surveyed with no renewal, came back above it with nothing recorded given: the separation held, and the first form's letter was met somewhere. The lakes are named in the line. |
| refuted unless the estimates are distorted at low density beyond what the doubled intervals cover | The strongest refutation these rules give. Lakes read as below the need persisted at least as often as they fell, the four confounds set aside: T1's *Refuted by* in its second form, met, unless the estimates are distorted at low density beyond what the doubled intervals cover (§13). The need is then misplaced, the adults' renewal not stopping where the age-0 surveys say, or the estimates are so distorted. T1's standing records a frozen field test failed, as its *Evidence* records MQ3. |
| refuted unless connected waters | The same among all lakes, but not among the seepage lakes alone, or too few of them to decide or to refute by the letter, as the verdict says: fish from connected waters could have kept the lakes up. Where the open lakes did not persist more often than the closed (reported), immigration is not shown either. T1's standing records a refutation the test could not separate from immigration. |
| refuted unless unrecorded stocking | The same, but the other stocking records were not read for a lake that persisted. Reading them, where they can be had, settles it. |
| refuted unless the unsurveyed fell | The same, but the lakes below the need never surveyed again would, counted as fallen, undo it. |
| refuted unless the intervals understate the error at low density | The same, but with the intervals below 2 adults per acre read twice as wide the reading no longer refutes, too few lakes resolved or the fates not refuting, as the verdict says: the refutation rests on the stated precision of estimates at low density, where mark-and-recapture counts few fish. A study of the recorders' estimator settles it. |
| not decided | Too few lakes stood below the need unstocked with no renewal pending, or their fates fell between the outcomes (more fell than not, but not by the sign test's margin, or not more often than above the need by Fisher's test, or none above resolved), or no need was found. With no need the lakes lie outside T1's scope, as most assessed fish stocks do; otherwise the test could not reach what T1 forbids, as the salt shock could not (T1-STANDING). The renewal report then says whether the need moved after 2012. |

| V2 | What it means |
|---|---|
| met | A lake below its need, its lag surveyed with no renewal and nothing recorded given, came back above it: the first form's letter, met within the records. An unrecorded stocking, fish from connected waters, a cohort the floor missed or the estimates' error could produce it (§8), so it is listed beside V1, not a verdict. |
| not met | No such lake. |

| Renewal below the need | What it means |
|---|---|
| beyond the fit at 0.05 | Lakes below the need after 2012 renewed more often than the fit allows: the need moved, or the fit misplaced it. V1 then reads only on the lakes that stayed below it, or is not decided. |
| within the fit | Renewal below the need ran as the fit allows. |

## 12. What waits on Ren

On the board's Decisions line:
- **The downloads**, each from a public page with no account where the page says so. Their sizes are read at the download, where the page gives none. The exports are expected to be tables of a few megabytes in all.
  - R1: the FMIS Treaty Reports' adult population estimates (<https://apps.dnr.wi.gov/fisheriesmanagement/Public/TreatyReports>);
  - R2: the fall recruitment surveys, from the same reports or from GLIFWC (<https://www.glifwc.org/Fisheries/Inland/>);
  - R3: the Ceded Territory's tribal harvest (<https://dnr.wisconsin.gov/topic/Fishing/ceded/tribalharvest.html>);
  - R4: the creel surveys;
  - R5: WDNR's fish stocking database;
  - R5b: fry, tribal and private stocking, from GLIFWC's reports of the bands' hatcheries and WDNR's annual stocking summaries, where they can be had as tables;
  - R7: WDNR's lake types, where R1's characteristics do not give them;
  - for the comparison only, Sass, Feiner and Shaw (2021), where Ren can have it.

  A page that offers no download, or a file behind a bot check, is fetched by Ren in a browser, as Dryad's files were for MQ6. Where R2 cannot be had, the need cannot be computed and V1 is not decided.
- **The run**: a few seconds of CPU on the local machine, standard library, no model call, no key.

Freezing waits on no one; AGENTS.md has designs "prepared fully, freezing designs included".

## 13. Limits and literature

- **The need is read at the age-0 stage.** T1's need is where the condition's renewal stops. The surveys read the fall's age-0; the adults' renewal also passes through survival from age 0 to age 3, which can compensate (Sass and others 2022 found age-0 to age-1 mortality density-dependent). Where compensation holds a lake below the need for years (*renewal below the floor*), V1 refutes. Where it returns a lake within a year or two (*survival compensates*), the lake's surveys below the need come with renewal pending and are set aside, and V1 is not decided: the test cannot refute T1 there, and gives no positive outcome (§8). This holds so far (5 November 2026). Its reason is that these records cannot tell a return carried by a recorded year class from one carried by fish that survived from below the floor. It lapses with the spring estimates' age composition or yearling surveys, which tie the returning adults to their year class (§1).
- **The need at the 50% point.** Below it renewal is rarer, not stopped. Where renewal truly stops well below that point (*weak depensation*), lakes just below the need recover, and V1 refutes, in its strongest form only with more lakes than 300.
- **A need misplaced within the intervals' margin.** A survey is read as below the need only where its whole interval is, so at the surveys' error an estimate below about three fifths of the need. A need that fell after the fit by less than that margin (*need falls*) leaves the lakes read below it below the true need too, and V1 can come out positive; the renewal report shows the move. A need that fell further (*need falls far*) leaves the lakes below it renewing, set aside, and V1 not decided, with the renewal report beyond the fit.
- **Why lakes fell** (§1, §7). The positive outcome cannot tell renewal stopping with the level from renewal lost for years, by a cause or by chance, before the window or during it. This holds so far (5 November 2026), for that reason. It lapses with a test of lakes stocked back above the need: does their natural renewal return? Under a need in the level it should, and under renewal lost to another cause it should not. Many stocked walleye carry an oxytetracycline mark, read in the laboratory from otoliths, not by the survey itself, and not every stocking is marked (round 3's N-48), so the stocked year class can sometimes be told from the lake's own. That test is a design of its own, offered on the board after this one lands.
- **Estimates distorted at low density** (round 3's N-44). Estimates inflated where a lake is low, by a factor growing as (x0/x)^0.5 to (x0/x)^0.7, or with a true error wider than the stated interval, can make T1's own world look refuted. Lakes falling below the need then appear to hold. The low-density qualifier (§7) reads most such refutations as *unless*. But estimates both inflated and too narrow, the combined shape, refuted T1's own world with no named confound in 32 of 40 archives of 900 lakes, about the field's size, and no reading these records allow separates that from a misplaced need. Chapman-like estimates did not do it in round 3's reader's runs. So every refutation carries the clause "unless the estimates are distorted at low density beyond what the doubled intervals cover", and no plain *refuted* comes from these rules (§7). This holds so far (5 November 2026). It lapses with a record of each estimate's mark-and-recapture counts (fish marked, caught and recaptured), or the agency's own statement of its precision by lake and year, where that record shows the distortion absent. The layout step records whether R1's columns give such counts; if they do, a later design can read them, since these rules do not.
- **Intervals that reach zero** (round 3's N-49). A lower bound at or below zero, as a normal approximation gives at low counts, cannot be read on the log scale, and every fate resting on it is unresolved. In round 3's reader's Chapman model with normal intervals, V1 was not decided in 120 of 120 archives. Where the recorders' intervals are of that kind at low density, the test loses the lakes below the need. This is a power cost, not a false outcome.
- **Recorders who relabel a failing lake.** Where the recorders move a lake off natural recruitment after its surveys fail, as "REM" may record, the fates T1 predicts become unresolved. In the dry run, recorders who did so after three failed falls left V1 not decided in every archive at half a chance a year (§8). The test's power then rests on how the recorders label, which the layout step shows but cannot change.
- **A lag longer than three years.** Females mature later than males, so part of a year class may join the adults at five years, after the pending window has closed. Round 2's reader ran T1's own world with half of each class joining at five, under the rules that round read: V1 was not decided in 31 of 40 archives with no managers, where at three it decided all 40. This is a power cost, not a false outcome, and holds so far.
- **A common need.** One need for every lake reads T1's need as a property of the lakes' common renewal law. The *needs vary* world shows V1 holding where needs differ by a factor of about two.
- **The lag.** T1's regime has no lag; walleye join the adults about three years after spawning, so the state at a reference is more than the level (T2's own claim: the level, the recent giving and one lag). The rules read renewal pending as part of the condition (§6).
- **The ratio test** reads each interval as log-normal, which a mark-and-recapture interval is only roughly. An interval read wrongly as narrow makes declines and rises easier to call on both sides of the need alike. One read wrongly as wide leaves more fates unresolved, since persistence must be shown (§6).
- **Lakes are read as independent.** Region-wide years correlate fates, so V1's p is optimistic; the fates by reference year are reported.
- **Labels.** The recruitment-source label is the recorders' classification and its criteria are theirs. Where it leaves natural recruitment the fate is unresolved. The reading set aside, the label alone a fall, is run beside it in the dry run, where it favours the positive outcome (§8). The run does not report it (round 5's N-59): its line would count a lake relabelled after coming back above the need among both the fallen and those that came back, so it would need words of its own, and the layout step's count of lakes whose label changes category (§10) says how many lakes the choice can touch.
- **Literature.** Critical depensation and its rarity in assessed stocks: Myers, Barrowman, Hutchings and Rosenberg (1995, *Science*); the q of depensation: Liermann and Hilborn (1997); Allee effects: Courchamp, Berec and Gascoigne (2008). Walleye: Sass, Feiner and Shaw (2021, *Fisheries*); Dassow and others (2023, *Fisheries Research*); Mrnak and others (2024, *Canadian Journal of Fisheries and Aquatic Sciences*); Rypel and others (2018, the same journal); Sass (2025, *FACETS*). Thresholds of harvest: Clark (1976); Beddington and May (1977). Exact bounds: Clopper and Pearson (1934). These are cited from their abstracts and summaries, not checked against the full texts.

## 14. Provenance and the freeze

- Written for board item T1N on 5 November 2026, at the coordinator's offer. The coordinator chose the walleye lakes, the separation as the primary verdict, the scope by the recorders' fields, the run's order, the confounds decided before any value, the label read with a recorded fall, the no-need family's bound and its checks, and agreed to drop the published need (§4). After round 2's N-28 the coordinator named V1's positive outcome narrowly, narrowed the no-need family to renewal that never stops with the level, recorded as made after that finding (§8), and asked that the stocked-lakes test be offered as its own item (§13). After rounds 3 to 5, the coordinator:
  - kept round 3's reader's wording for the outcome, which counts the lakes that came back (N-42);
  - placed renewal cut in long chance spells in the renewal-lost family (N-43);
  - accepted the low-density qualifier, its costs reported and no bar moved to meet them (N-44);
  - asked that §1 say the outcome's value is mainly its chance to refute;
  - asked that the run read V1 with and without the lakes a reader's search summary showed (§9);
  - set what counts as high from round 4 on (REVIEW-FREEZE.md);
  - during round 4, decided that every refutation carries the residual clause (§7, §13);
  - after round 5, approved a sixth round on its fixes alone, and left to the author whether the run keeps the label-alone reading; it does not (§13).
- No data was downloaded and no model called. No value was read, save the few a search summary showed round 3's reader for three lakes (§9). The only computation was the dry run's, on synthetic lakes.
- **Readers.** An independent reader reads the frozen files before the freeze lands: a full read, then the same reader on the diff of each round's fixes, until a round finds nothing of high or medium severity, at most five, and a sixth on round 5's fixes alone, approved by the coordinator. The findings, and how each was taken, are in [`REVIEW-FREEZE.md`](REVIEW-FREEZE.md).
- **What is frozen.** `FROZEN.sha256` lists:
  - this folder's code and layout: `t1n.py`, `reader.py`, `run.py`, `dry_run.py`, `layout.json` and `write_frozen.py`;
  - the dry run's record.

  `write_frozen.py` writes it last, on the merged tree, and refuses unless the dry run's record shows every check passed, its code unchanged while it ran, and the hashes it names equal to the files'. It also refuses a second write.
- **An addendum** may change only `layout.json`, after the layout is read with no value, and with it the dry run's record, once its checks are run again. It is a dated `addenda/ADDENDUM-k.md` with `addenda/FROZEN-k.sha256`, the hashes of every frozen file after it. `run.py` checks the chain before it reads anything:
  - each link is committed once and never changed, one blob across the full history, as freeze 1's chain reads it;
  - each link comes after the one before, and no link once committed is gone;
  - each lists the files before it and its own text;
  - each changes no file but `layout.json` and the dry run's record, and remaps no label text `layout.json` held;
  - the newest link's files are the bytes it names, committed;
  - the dry run's record passed every check on the code the newest link names.
- **How this file is frozen.** By the commit that adds `FROZEN.sha256`: its text there is the frozen one. It is not hashed, so that a link can be repaired without touching the code's hashes. A later edit may only repair a link or a typo, is listed in a dated note at the end, and changes no rule, threshold or reading.

**Corrected after the freeze, 9 November 2026** (board item RW). The header said "not yet reviewed by a person", a claim the repository cannot support and [the word of 8 November 2026](../../sources/15-codex-theory-conversations/2026-11-08-ai-briefly-and-read.md) asks the work not to make; it now says that no person's review of it is recorded. This file's rule allows a later edit only for a link or a typo. This note is neither, and is added by argument, as [FREEZE-1](../formations-that-read/FREEZE-1.md)'s corrections of its header are: it corrects what the header says of review, not the design. It changes no rule, threshold, size or reading; the frozen text is the one at the freeze commit.

**Since the freeze, 9 November 2026** (board item RW). A note, not an edit: the header's "Nothing has been downloaded" was true at this freeze; two of its records were downloaded, R1 and R5 ([`downloads.json`](downloads.json), which says why R2, R3 and the optional ones are not), and the one run was refused at R1's header on 6 November 2026 ([the status](README.md)). Nothing else changed: no rule, threshold, size, reading or frozen file. This file's rule allows a later edit only for a link or a typo; this note is neither, and is added by argument: it changes no sentence above and reports only what happened after the freeze, so no rule, threshold or reading can move by it.
