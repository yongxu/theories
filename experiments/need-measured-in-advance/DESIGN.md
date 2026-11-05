# T1N: T1's field test with a need measured in advance (design)

Board item T1N, 5 November 2026, at the coordinator's offer. AI-written (a Claude Code session), not yet reviewed by a person. The rules ([`t1n.py`](t1n.py)), the reader ([`reader.py`](reader.py)) with the layout it assumes ([`layout.json`](layout.json)), the run ([`run.py`](run.py)) and the dry run ([`dry_run.py`](dry_run.py), its record [`results/dry-run.json`](results/dry-run.json)) are frozen together before any value of the data is read. Their hashes are in `FROZEN.sha256`, which [`write_frozen.py`](write_frozen.py) writes last; this file is frozen by the commit that adds it (§14). Nothing has been downloaded. The downloads and the run are Ren's decision (§12).

*About 80 to 100 minutes to read, at 100 to 130 words a minute; §1 and §11 in ten to thirteen.*

## 1. What is tested, and the answer expected

[02 §5](../../theories/becoming/chapters/02-MAP.md#t1)'s **Thesis T1**, *Persistence certifies the joint draw*: "Whatever persists through many renewal cycles of a condition it depends on, renewal stopping below a need, has had the joint draw on it, its own with every other drawer's, kept within the regime's margin (its point of no return, not the withheld-levels margin)." *Forbids*: "a condition below a need measured in advance returning with nothing given from beyond; a dependent active while its condition stood below its need." *Refuted by*: "a stock driven below a need measured beforehand returning with no measured giving from beyond, or fates across a predicted point separated no better than by a null." Its *Evidence* ends: "No field test of a need measured in advance has run." This is that test, designed and frozen before any value it reads is seen.

**The field.** Walleye lakes of Wisconsin's Ceded Territory, read through the records of the Wisconsin Department of Natural Resources (WDNR) and the Great Lakes Indian Fish and Wildlife Commission (GLIFWC). A lake's adult walleye are the condition. Their renewal is the fall's age-0 fish, which join the adults about three years later. The draw is the harvest, tribal and angling. Giving from beyond is stocking, since a lake takes fish from nowhere else, connected waters aside (§5).

**The verdict (V1, primary): the separation**, T1's *Refuted by* in its second form. The need is fitted on the years up to 2012, before any later year is read (§4). A lake's fate is a measured change, read alike on both sides of the need: a decline of its adults by a ratio test on the recorders' own intervals, not undone by a recovery (§6). Below the need renewal is rarer and the draw goes on, so T1 predicts a fall. A lake with a year class recorded in the three falls before is not read as below the need, since that renewal is part of its condition. The null, fixed in advance, predicts no fall anywhere. Among the lakes below the need with resolved fates:
- **supported** where at least the critical count of an exact one-sided sign test at 0.05 fell, and they fell more often than the lakes above the need by Fisher's exact test at 0.05: the fates separated across the predicted point;
- **refuted** where so few fell that the same sign test puts them on the null's side, or, at twenty lakes or more, where at most half fell;
- **not decided** otherwise, or where fewer than ten are resolved (§7).

Three confounds could make a refutation on their own: fish from connected waters, stocking the database misses (fry, and fish from tribal or private hatcheries), and lakes below the need never surveyed again. Decided now, a refutation one of them could make reads **refuted unless** that confound, not plainly *refuted* (§7).

**Reported beside it**, deciding nothing:
- **V2, the single-lake form**, T1's *Refuted by* in its first form: a lake below its need, its lag surveyed with no renewal at the floor, back above the need with nothing recorded given from beyond. Its lakes are listed, and a support with V2 met reads **supported, contradicted by V2**.
- **Renewal below the need**, T1's second *Forbids*: the lake-years after 2012 below the need whose renewal reached the floor, against what the need's fit expects. A need that moved after the fit shows here (§7).

**Who decides.** Every value the verdict reads is recorded by WDNR or GLIFWC, families that neither wrote nor read the theory. Their fields decide the scope and much of the fate; code and a layout file frozen here decide the rest. After the freeze nobody of the theory's family chooses anything, and no model is called.

**The answer expected.** The likeliest is *not decided*. Managers stock and relabel a falling lake, and where they act fast few lakes stand below the need unstocked: in the dry runs, a stocking chance of 0.3 a year for a falling lake left V1 undecided in every archive of every world (§8). If decided, *supported* is expected, from Sass, Feiner and Shaw's finding of depensatory recruitment in about half of 82 Ceded Territory lakes (§13). A plain *refuted* would mean the need is misplaced: the adults' renewal does not stop where the age-0 surveys say. §11 says what each outcome means, and §8 how often each came in worlds where the answer is known.

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

**Labels that never change.** The label may be the lake's classification when the report was made, not that year's. Where no lake's label changes across years, the rules read the label as deciding nothing, and the stocking records alone decide the scope and the fate (`labels`). The reader records which it found.

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

**The reference** is the lake's first survey in time, in the window, that is in scope and readable: read as below the need, where T1 predicts a fall, or with its interval wholly above the need, where T1 predicts persistence (`rows`). A survey whose interval holds the need, one set aside for renewal pending, and one with no later estimate are passed over. The choice reads only each survey's own interval, the need and the renewal recorded before it, never a later value.

Taking the first readable survey in time, and not the first below the need wherever it falls, keeps a lake's side from being chosen by whether it later went below. A lake that falls from above the need, for whatever reason, then counts on the side where it stood. The draft took the first survey below the need, and failing that the first above it. Under that choice a world with no need, where a fifth of lakes lose their renewal after 2012 to a cause other than the stock, was supported in 9 of 40 archives with no managers. Every lake that fell for that cause was read from below the need, and the lakes left above it were those that did not fall (§8).

**The fate**, between the reference and the first later estimate (`fate_of`), read the same way on either side of the need, so the separation compares like with like:
- **Unresolved** where the recorders' label leaves natural recruitment at a survey after the reference, up to the fate's, or stocking is recorded after the reference, in WDNR's database or in R5b: giving from beyond, or a programme's relabelling, either way. A relabelling counts no fall by itself. §8 gives the reading set aside, the label alone counted as a fall, and which side it favours.
- **Fell** where the fate's survey lies below the reference's by the ratio test, and no later survey within ten years of the reference, before any recorded giving, rises from the fate's by the test. A rise after a decline is a recovery, a return T1 forbids below the need.
- **Persisted** otherwise: the level kept, a rise, or a return.
- **Unresolved** where an interval cannot be read on the log scale.

Why the recovery: renewal can fail by chance three years running in a world with no need. The stock then dips for three years whatever the law, and recovers once renewal comes back. T1 forbids that recovery below the need, and a law without a need predicts it. The episodic worlds of §8 are that case.

**The unsurveyed.** A lake whose first readable survey is below the need with no later estimate three to ten years on is marked (`below the need with no later estimate`). Recorders may stop surveying a lake once it has fallen, so such lakes are counted in §7's third confound.

## 7. The verdicts

**V1** (`v1`, `decide`). Every lake in the test has a row. T1 predicts a fall at a reference read as below the need, and the null predicts none, so the two classifiers differ on exactly those lakes. Let n be the ones with resolved fates and k the ones that fell, and let c be the critical count of an exact one-sided sign test at 0.05, which is McNemar's test on the discordant lakes: 9 of 10, 11 of 14 and 15 of 20. Let n_a and k_a be the same counts above the need. The rule, in this order:
1. Not decided where n < 10 (`N_MIN`).
2. Supported where k ≥ c and, by Fisher's exact test at 0.05, the share fallen below the need exceeds the share fallen above it. Where k ≥ c but the lakes above fell as often, or none above is resolved, not decided.
3. Refuted, the fates separated no better than by the null, by either of two routes:
   - k ≤ n − c: so few fell that the same test at 0.05 puts the fates on the null's side. That is at most 1 of 10, 3 of 14 or 5 of 20.
   - by the home's letter, 2k ≤ n, where n ≥ 20 (`N_REFUTE`).
4. Not decided otherwise.

**What a support allows.** It allows n − c lakes below the need that did not fall: 1 of 10, 3 of 14, 5 of 20. MQ3's frozen test asked a fall share of 80%, and MQ2's 90% on each side; a support here can carry a share near 75% at twenty lakes. So V1 reports the share fallen below the need with its exact lower bound at 0.95 (Clopper and Pearson's) beside the verdict, and §11 reads a support with it.

**Why the separation as well as the sign test.** The sign test asks whether the lakes below the need fell more often than not. Fisher's test asks whether they fell more often than the lakes above it. A world with no need can make lakes fall on both sides: where renewal fails by chance for years, or where some lakes cannot persist at any level. There the lakes above the need fall too, and the separation keeps a support from resting on falls that come whatever the side (§8).

**A refutation, read against the three confounds**, decided before any value is read:
- **Connected waters.** Where a lake counted as persisting is not a recorded seepage lake, V1 is decided again on the closed lakes alone. Where that is not also a refutation, the verdict reads *refuted unless connected waters*.
- **Unrecorded stocking.** Where R5b was not read for a lake counted as persisting, the verdict reads *refuted unless unrecorded stocking*.
- **The unsurveyed.** Where the lakes marked unsurveyed (§6), counted as fallen, would undo the refutation, it reads *refuted unless the unsurveyed fell*.
- Two or three of these read together, joined by "or".

None qualifies a support: each can only make a lake below the need persist or drop out, so each works against support.

**Why the letter needs twenty lakes.** The letter, no better than the null, is the one T1-STANDING read as met at equal accuracy after the salt shock, and it is kept. As a point estimate it is weak evidence at few lakes. Suppose a lake below the need falls with chance 0.7. Then at least half of 10 lakes survive with chance 0.15, and at least half of 20 with 0.048. So the letter is read at twenty lakes or more. At fewer, a refutation needs the fates on the null's side at 0.05, which a fall chance of 0.7 gives among 10 lakes with chance 0.00014. Support at ten needs 9 of 10, which a fair split between falling and not gives with chance 0.011.

**Why the need alone, not the point with the draw.** T1's point of no return is the need with a standing draw. Here the draw does not stand: safe harvests are set from each lake's estimates, so the harvest is cut as a lake falls. A lake whose draw would end it can then persist because the draw changed. That is a breach of T1's standing-draw premise, not evidence against T1. Below the need, T1 predicts a fall under any draw, so V1 reads the need alone. The rows also give each reference's point with the recorded draw, and the reports give the fates of lakes above the need and below that point.

**V2** (`v2`), reported. It counts the lakes read as below the need at the reference with every year of the lag surveyed and none at the floor, whose fate's interval lies at or above the need, with the natural-recruitment label at every survey between and no stocking recorded after the reference. It is *met* where at least one such lake exists, and each is listed. A support with V2 met reads *supported, contradicted by V2*.

**Renewal below the need** (`renewal_below`), reported. Among the lake-years after 2012 with a spring estimate wholly below the need and a fall survey that year, the label natural and no stocking recorded in it or the five years before, it counts those whose renewal reached the floor, and sets against them the number the need's fit expects there: the sum of the fit's chances at their estimates. It gives the exact chance, under the fit, of so many or more. This reads T1's second *Forbids* as far as a need at the 50% point can: below the need some renewal is expected, and more than the fit allows means the need moved after 2012. Such a move hides from V1, because the lakes that would show it renew and are set aside (§6).

**Reports**, ruling on nothing (`reports`):
- the lakes out, by reason;
- the fates below the need by route, by reference year (fates in one year can share a region-wide cause, so V1's p is optimistic where the years cluster) and by whether every year of the lag was surveyed;
- the surveys set aside with renewal pending, by their fate;
- the fates of the lakes above the need but below the point with the recorded draw;
- the references with a creel survey;
- V1 at the floors 0, 5 and 10;
- V1 on the recorded seepage lakes alone;
- V1 with the label alone counted as a fall, the reading set aside.

## 8. Dry runs

[`dry_run.py`](dry_run.py) builds synthetic archives of 300 lakes, 1990 to 2025, and reads each with the frozen rules. Its record is [`results/dry-run.json`](results/dry-run.json): 198 checks, none failed, 168 CPU seconds.

**The model.** Each year, spring adults per acre x renew by fall age-0 r = R(x)·e^(σz), with R(x) = 60 x^q / (1.5^q + x^q) and σ = 0.8. Next spring's adults are 0.7x − h plus 0.03 times the age-0 of three years before. The exploitation e is drawn per lake from 0.05 to 0.6, and above 0.3 a lake keeps no level. The draw is h = e·x, cut to 0.05·x below one adult per acre, as safe harvests are; lakes exploited hard then cycle, a strong year class every few years carrying them between lean ones. In a year, a lake loses nine tenths of its adults with chance 0.02 (a winterkill). A lake is a recorded seepage lake with chance 0.4.

**What the recorders do.**
- They estimate adults every three to five years, with log-normal error at a CV of 0.25 and a 95% interval.
- They survey age-0 every year at 70% of lakes, and at the rest in 40% of years.
- 40% of lakes are speared, and the tribal part of the harvest is recorded; angling is recorded only in creel years (a fifth).
- Below one adult per acre, managers stock a lake with a chance a year (the speed) and relabel it.
- The other stocking records (R5b) are read, and empty, in every world but the two named below.

**The worlds**, in three families and one reported apart:
- **T1 holds**, renewal stopping below a need:
  - *need*: q = 3;
  - *needs vary*: each lake's 1.5 scaled by a factor of about 2;
  - *need rises*: 1.5 doubled after 2012;
  - *relabelled*: managers also relabelling and stocking lakes at 0.03 a year from 2013 whatever the stock, a programme rather than a fall;
  - *unrecorded*: a third of stocked lakes stocked outside WDNR's database with the label kept, and R5b not read; *unrecorded, read*: the same, with R5b read and holding those stockings;
  - *open*: 0.15 adults per acre a year arriving from connected waters, in the lakes not recorded as seepage;
  - *episodic*: q = 3 with σ = 1.6;
  - *unsurveyed*: no estimate made of a lake below 0.15 adults per acre;
  - *static labels*: each lake's label its last, in every year.
- **The need misplaced**, where the surveys put a need and T1 is false, or holds only within the intervals' margin:
  - *survival compensates*: age-0 depensatory, but the adults they make rise as age-0^0.3 (with 0.4 for 0.03), so a lake below the need returns within a year or two; and *compensates, relabelled*;
  - *renewal below the floor*: the same with 0.10, so a lake below the need, renewal under the floor, holds there for years;
  - *weak depensation*: q = 1.5 with σ = 1.6, renewal stopping well below the 50% point, so lakes just below the need recover;
  - *need falls* and *need falls far*: 1.5 halved, or quartered, after 2012.
- **No need**, renewal never stopping with the level, though it may fail by chance or stop for another reason:
  - *no need*: q = 1;
  - *lakes differ*: q = 1, each lake's 60 and 0.03 scaled by independent log-normal factors of log-sd 0.5, 0.7, 1.0 or 1.5, so that some lakes cannot persist at any level;
  - *general decline*: renewal falling 4% a year everywhere;
  - *no need, relabelled* and *no need, unsurveyed*: the relabelled and unsurveyed variants, at log-sd 0.7;
  - *renewal unseen*: surveys catching age-0 in proportion to x/(x + 0.5);
  - *floor by chance*: a survey reaching the floor with a chance rising slowly with x, whatever the lake renews;
  - *episodic, no need*: σ = 2.5, so renewal fails by chance for years at any level; and *episodic, lakes differ*: σ = 2.0 at log-sd 1.0;
  - *renewal stops after*: at log-sd 0.7, a fifth of lakes losing all renewal after 2012, as a habitat lost would;
  - *no renewal in some*: at log-sd 0.5, 15% of lakes with no renewal ever.
- **Reported apart**: *half need*, half the lakes at q = 3 and half at q = 1.

V1's verdicts in 40 archives a cell, by the managers' stocking chance a year for a falling lake. S is supported, S* supported but contradicted by V2, R refuted, R? refuted unless a confound, and N not decided. V2 met, in archives, is after the slash:

| World | 0.3 | 0.1 | 0.03 | 0 |
|---|---|---|---|---|
| **T1 holds** | | | | |
| need | N 40 / 0 | N 40 / 0 | S 29, N 11 / 0 | S 40 / 0 |
| needs vary | N 40 / 0 | S 3, N 37 / 0 | S 40 / 0 | S 40 / 0 |
| need rises | N 40 / 0 | N 40 / 0 | S 40 / 0 | S 40 / 0 |
| relabelled | N 40 / 0 | N 40 / 0 | S 21, N 19 / 0 | S 38, N 2 / 0 |
| unrecorded | N 40 / 1 | N 40 / 4 | S 23, S* 3, N 14 / 6 | S 40 / 0 |
| unrecorded, read | N 40 / 0 | N 40 / 0 | S 29, N 11 / 0 | S 40 / 0 |
| open | N 40 / 0 | N 40 / 0 | S 2, N 38 / 0 | S 15, N 25 / 0 |
| episodic | N 40 / 0 | S 37, N 3 / 0 | S 40 / 0 | S 40 / 0 |
| unsurveyed | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| static labels | N 40 / 0 | S 1, N 39 / 0 | S 34, N 6 / 0 | S 40 / 0 |
| **The need misplaced** | | | | |
| survival compensates | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| compensates, relabelled | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| need falls | N 40 / 0 | N 40 / 0 | S 4, N 36 / 0 | S 26, N 14 / 0 |
| need falls far | N 40 / 0 | N 40 / 0 | N 40 / 0 | S 1, N 39 / 0 |
| weak depensation | N 40 / 0 | N 40 / 0 | N 40 / 1 | R? 5, N 35 / 2 |
| renewal below the floor | N 40 / 0 | R? 4, N 36 / 0 | R 40 / 1 | R 40 / 0 |
| **No need** | | | | |
| no need | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| lakes differ 0.5 | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| lakes differ 0.7 | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| lakes differ 1.0 | N 40 / 0 | N 40 / 0 | N 40 / 0 | R? 5, N 35 / 0 |
| lakes differ 1.5 | N 40 / 0 | N 40 / 0 | N 40 / 0 | R? 10, N 30 / 0 |
| general decline | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| no need, relabelled | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| no need, unsurveyed | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| renewal unseen | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| floor by chance | N 40 / 0 | N 40 / 2 | N 40 / 1 | N 40 / 2 |
| episodic, no need | N 40 / 0 | R? 1, N 39 / 2 | R 4, R? 29, N 7 / 8 | R 16, R? 21, N 3 / 14 |
| episodic, lakes differ | N 40 / 0 | N 40 / 0 | R? 3, N 37 / 3 | R 2, R? 28, N 10 / 7 |
| renewal stops after | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| no renewal in some | N 40 / 0 | N 40 / 0 | N 40 / 0 | N 40 / 0 |
| **Reported apart** | | | | |
| half need | N 40 / 0 | N 40 / 0 | S 2, N 38 / 0 | S 22, N 18 / 0 |

**The checks on the worlds**, each failing the dry run if not met:
- in every world with no need, and every world with the need misplaced but *need falls*, at every speed: supported in at most 5 of 40 archives. A test at 0.05 exceeds 5 of 40 with chance 0.014;
- in *need*: supported in at least 30 of 40 with no managers, and in at least half at 0.03. The draft asked 30 at 0.03, where it was supported in 36; the rework is supported in 29 there, for the reasons below;
- in *renewal below the floor*, at 0.1, 0.03 and with no managers, and in *weak depensation* with no managers: refuted, in some form, more often than supported; in *renewal below the floor* at 0.03 and with no managers, refuted plainly in at least 30 of 40;
- in *weak depensation* at 900 lakes an archive: a plain refutation reached;
- in *open*, *unrecorded*, *unsurveyed* and *static labels*: at most 5 plain refutations of 40;
- the renewal report beyond the fit at 0.05 in at least 30 of 40 archives of *need falls far* with no managers, and in at most 5 of 40 of *need* at 0.03 and with no managers.

**Which side the label's reading favours.** The frozen reading counts a label leaving natural recruitment as no fall by itself (§6). The reading set aside, the label alone counted as a fall, is run beside it in the three relabelled worlds:

| World | 0.3 | 0.1 | 0.03 | 0 |
|---|---|---|---|---|
| relabelled, frozen | N 40 | N 40 | S 21, N 19 | S 38, N 2 |
| relabelled, label alone | N 40 | N 40 | S 21, S* 7, N 12 | S 30, S* 10 |
| compensates, relabelled, frozen | N 40 | N 40 | N 40 | N 40 |
| compensates, relabelled, label alone | N 40 | N 40 | N 40 | N 40 |
| no need, relabelled, frozen | N 40 | N 40 | N 40 | N 40 |
| no need, relabelled, label alone | N 40 | N 40 | N 40 | N 40 |

The label alone counted as a fall favours support. With T1 true and lakes relabelled it supported 28 archives at 0.03 where the frozen reading supported 21, and it was contradicted by V2 in 17 archives where the frozen reading never was. Where T1 is false or there is no need, neither reading decided any relabelled archive, so these worlds cannot show which side it favours there.

**What the dry runs show:**
- **Where there is no need, V1 was never supported**: in none of the 2,240 archives of the fourteen no-need worlds. Where lakes differ in productivity, or renewal fails by chance for years, V1 was instead refuted in some form with slow managers, since lakes below the need recover there: in up to 10 of 40 archives where lakes differ, and in 37 of 40 in *episodic, no need* with no managers.
- **Where T1 holds, V1 was supported once managers are slower than 0.1 a year, and never refuted.** *need* was supported in 29 of 40 at 0.03 and 40 of 40 with no managers. *needs vary*, *need rises* and *episodic* were supported in 40 of 40 at both. *relabelled*, *unrecorded*, *unrecorded, read* and *static labels* were supported in 21 to 34 of 40 at 0.03 and in 38 to 40 with no managers.
- **What the rework cost.** At 0.03 the draft supported *need* in 36 of 40 archives, but its reading of a fall supported a no-need world with varying lakes in 40 of 40 (round 1's N-03). The rework supports none. Of the eleven undecided archives at 0.03:
  - six had fewer than ten resolved lakes below the need, nearly all of which fell;
  - five fell short of the critical count by one;
  - the lakes that did not decline were mostly ones whose lag years went unsurveyed, so a year class the surveys missed lifted them. That is the cost of not setting aside a survey whose lag was unread, which §6 accepts because a missed cohort works only against T1.
- **Where the need is misplaced, V1 was refuted where the lakes below it hold there.** *renewal below the floor* was refuted plainly in 40 of 40 at 0.03 and with no managers. Where renewal stops well below the 50% point (*weak depensation*), V1 was refuted in 5 of 40 with no managers, each read *unless*, and plainly in 7 of the 80 archives of 900 lakes.
- **Where lakes below the need return within a year or two (*survival compensates*), V1 was not decided in all 160 archives.** Their surveys below the need come with renewal pending and are set aside, so the test cannot refute T1 there, and does not support it.
- **Where the need fell after the fit within the intervals' margin (*need falls*), V1 was supported in 26 of 40 with no managers.** The lakes read as below the old need are below the new one too. The renewal report was beyond the fit in 39 or 40 of 40 at 0.03 and with no managers. Where the need fell further (*need falls far*), V1 was not decided in 159 of 160 archives and supported in one, and the renewal report flagged 40 of 40 at slow managers.
- **The confounds never produced a refutation of any kind where T1 holds**, in *open*, *unrecorded*, *unsurveyed* or *static labels*.
- **Power rests on the managers' speed,** which no record gives before the data. At 0.3 a year V1 was not decided in any archive of any world. At 0.1 it was supported only in *episodic* (37), *needs vary* (3) and *static labels* (1).
- **V2 was met mostly where giving from beyond went unrecorded or renewal failed by chance**: up to 6 of 40 in *unrecorded*, 14 in *episodic, no need* and 7 in *episodic, lakes differ*. Elsewhere it was met at most twice in a cell, and never in *need*.
- **The renewal report** was beyond the fit in at most 2 of 40 archives of *need* at any speed, and in 39 or 40 of *need falls* and *need falls far* at slow managers.
  - It was beyond the fit in up to 17 of 40 in *needs vary*, where lakes whose own need lies below the common one renew below it.
  - It was beyond the fit in up to 19 of 40 in the no-need worlds where lakes differ widely (*lakes differ 1.5*, *no renewal in some*). There the need is an artefact of lakes of different productivity, and the lakes below it renew.

**The other checks.**
- **On scripted lakes, each rule at its thresholds:**
  - V1's verdicts at the critical counts of 10, 14 and 20 lakes;
  - the separation, the premise and the scope;
  - the ratio test, against a value worked by hand;
  - the fate and its recovery, renewal pending and the surveys set aside;
  - the reference as the first readable survey;
  - V2, the three confounds and the static labels;
  - the exact tail, the exact lower bound and Fisher's test, each against a case by hand;
  - the renewal report, against a case by hand.
- **The need's fit** recovers a known need within 25%. It gives none where renewal does not rise with the level, or rises too shallowly for the data to reach the need.
- **The reader** rebuilds the synthetic lakes from files in the assumed layout. It refuses each layout failure round 1 named, and gives the same structural facts with every value column overwritten.
- **The run**, end to end on those files, reproduces the rules' verdict and reports every floor. It refuses an unrecorded input and a second run.
- **The freeze's chain**, in stand-in git repositories, passes when whole. It refuses a changed file, a forbidden addendum, a cut chain, a link committed twice, and a run before the freeze.

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

**What is assumed of the layout** ([`layout.json`](layout.json)), **and checked at the layout step:**
- the files' names, and the columns the reader takes from each;
- the label's texts and the rules' category for each (natural, combination, stocked, remnant);
- the species' text in the stocking files ("Walleye", read without regard to case or spaces);
- that R1 gives per lake and year the estimate, both interval bounds and the lake's acres, so the reader divides by the acres; R2 age-0 per mile; R3 and R4 numbers of walleye; R5 the species and the number stocked.

Where any differs, an addendum changes `layout.json` alone (§14). Where a quantity the rules need is missing, both interval bounds or the age-0 survey's unit, the reader refuses, and the layout record says so.

## 10. The run's order

Each step is committed before the next.

1. **The downloads**, on Ren's yes (§12): each record as a CSV file in one folder outside the repository, its source, date, size and sha-256 recorded in `downloads.json`.
2. **The layout, with no value read.** `python3 -B reader.py layout FOLDER` gives each file's header and row count, and nothing else. `python3 -B reader.py facts FOLDER` gives what is recorded beside it, read from the structural columns alone (the lake, the year, the label, the characteristics, the species and the type), never an estimate, an interval, a count or a number stocked:
   - the label's distinct texts, and the number of lakes whose label changes across years;
   - the water body types named, and the lakes recorded closed, open or of no type;
   - the species' texts in the stocking files, and the rows of each file whose lake code matches R1's;
   - whether R5b and R7 could be had;
   - the archive's last estimate year, which settles the reference window;
   - the lake-years up to 2012 with both an adult estimate and a fall survey, and their lakes, against the fit's 200 pairs from 30 lakes;
   - the lakes with a candidate reference, and those of them recorded closed.

   Where the layout differs from the one assumed, an addendum changes `layout.json` alone, and the dry run's reader checks run again on synthetic files in the new layout.
3. **The run** (`python3 -B experiments/need-measured-in-advance/run.py FOLDER`, writing `results/run.json`): the need, then V1, V2, the renewal report, the rows and the reports, at each floor, kept whatever they are. `run.py` refuses unless the freeze checks (§14), unless every input is the file `downloads.json` records, and where `results/run.json` already exists.

**Why the layout is read after the freeze** (round 1's N-15). UE31's lesson is to check, before freezing, that the inputs can meet every rule's minimum. Here the headers cannot be read without the downloads, which wait on Ren, while the freeze does not wait: AGENTS.md has designs prepared fully, freezing designs included. What the lesson guards against is a freeze that the data cannot meet, and three things keep that from deciding anything:
- the layout step reads structure only, and the dry run checks that its facts are the same with every value column overwritten;
- an addendum can remap columns and texts, not rules;
- a minimum the data cannot meet leaves V1 not decided, with the reason recorded, never decided some other way.

## 11. What each outcome means

Fixed before the run.

| V1 | What it means |
|---|---|
| supported | Lakes read as below a need measured in advance declined, by the recorders' own intervals and without recovering, more often than an exact sign test allows by chance, and more often than the lakes above the need. T1's *Refuted by* in its second form could have been met and was not, in the field, for the first time: a prediction that could fail and did not. It is read with the share fallen and its lower bound (§7): a support at 75% says less than one at 95%. It says nothing of the stocking the records miss, or of the lakes with renewal pending, which it set aside. |
| supported, contradicted by V2 | The same, but at least one lake below the need, its lag surveyed with no renewal, came back above it with nothing recorded given: the separation held, and the first form's letter was met somewhere. The lakes are listed. |
| refuted | Lakes read as below the need persisted at least as often as they fell, the three confounds set aside: T1's *Refuted by* in its second form, met. The need is then misplaced: the adults' renewal does not stop where the age-0 surveys say. T1's standing records a frozen field test failed, as its *Evidence* records MQ3. |
| refuted unless connected waters | The same among all lakes, but not among the seepage lakes alone, or too few of them to decide: fish from connected waters could have kept the lakes up. T1's standing records a refutation the test could not separate from immigration. |
| refuted unless unrecorded stocking | The same, but the other stocking records were not read for a lake that persisted. Reading them, where they can be had, settles it. |
| refuted unless the unsurveyed fell | The same, but the lakes below the need never surveyed again would, counted as fallen, undo it. |
| not decided | Too few lakes stood below the need unstocked with no renewal pending, or no need was found. With no need the lakes lie outside T1's scope, as most assessed fish stocks do; otherwise the test could not reach what T1 forbids, as the salt shock could not (T1-STANDING). The renewal report then says whether the need moved after 2012. |

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

- **The need is read at the age-0 stage.** T1's need is where the condition's renewal stops. The surveys read the fall's age-0; the adults' renewal also passes through survival from age 0 to age 3, which can compensate (Sass and others 2022 found age-0 to age-1 mortality density-dependent). Where compensation holds a lake below the need for years (*renewal below the floor*), V1 refutes. Where it returns a lake within a year or two (*survival compensates*), the lake's surveys below the need come with renewal pending and are set aside, and V1 is not decided: the test cannot refute T1 there, and does not support it (§8).
- **The need at the 50% point.** Below it renewal is rarer, not stopped. Where renewal truly stops well below that point (*weak depensation*), lakes just below the need recover, and V1 refutes, plainly only with more lakes than 300.
- **A need misplaced within the intervals' margin.** A survey is read as below the need only where its whole interval is, so at the surveys' error an estimate below about three fifths of the need. A need that fell after the fit by less than that margin (*need falls*) leaves the lakes read below it below the true need too, and V1 can support; the renewal report shows the move. A need that fell further (*need falls far*) leaves the lakes below it renewing, set aside, and V1 not decided, with the renewal report beyond the fit.
- **A common need.** One need for every lake reads T1's need as a property of the lakes' common renewal law. The *needs vary* world shows V1 holding where needs differ by a factor of about two.
- **The lag.** T1's regime has no lag; walleye join the adults about three years after spawning, so the state at a reference is more than the level (T2's own claim: the level, the recent giving and one lag). The rules read renewal pending as part of the condition (§6).
- **The ratio test** reads each interval as log-normal, which a mark-and-recapture interval is only roughly; an interval read wrongly as narrow makes declines and rises easier to call on both sides of the need alike.
- **Lakes are read as independent.** Region-wide years correlate fates, so V1's p is optimistic; the fates by reference year are reported.
- **Labels.** The recruitment-source label is the recorders' classification and its criteria are theirs. Where it leaves natural recruitment the fate is unresolved, and the reading set aside, the label alone a fall, is reported beside (§8).
- **Literature.** Critical depensation and its rarity in assessed stocks: Myers, Barrowman, Hutchings and Rosenberg (1995, *Science*); the q of depensation: Liermann and Hilborn (1997); Allee effects: Courchamp, Berec and Gascoigne (2008). Walleye: Sass, Feiner and Shaw (2021, *Fisheries*); Dassow and others (2023, *Fisheries Research*); Mrnak and others (2024, *Canadian Journal of Fisheries and Aquatic Sciences*); Rypel and others (2018, the same journal); Sass (2025, *FACETS*). Thresholds of harvest: Clark (1976); Beddington and May (1977). Exact bounds: Clopper and Pearson (1934). These are cited from their abstracts and summaries, not checked against the full texts.

## 14. Provenance and the freeze

- Written for board item T1N on 5 November 2026, at the coordinator's offer. The coordinator chose the walleye lakes, the separation as the primary verdict, the scope by the recorders' fields, the run's order, the confounds decided before any value, the label read with a recorded fall, the no-need family's bound and its checks, and agreed to drop the published need (§4).
- No data was downloaded, no value read, and no model called. The only computation was the dry run's, on synthetic lakes.
- **Readers.** An independent reader reads the frozen files before the freeze lands: a full read, then the same reader on the diff of each round's fixes, until a round finds nothing of high or medium severity, at most five. The findings, and how each was taken, are in [`REVIEW-FREEZE.md`](REVIEW-FREEZE.md).
- **What is frozen.** `FROZEN.sha256` lists:
  - this folder's code and layout: `t1n.py`, `reader.py`, `run.py`, `dry_run.py`, `layout.json` and `write_frozen.py`;
  - the dry run's record.

  `write_frozen.py` writes it last, on the merged tree, and refuses unless the dry run's record shows every check passed, its code unchanged while it ran, and the hashes it names equal to the files'. It also refuses a second write.
- **An addendum** may change only `layout.json`, after the layout is read with no value, and with it the dry run's record, once its checks are run again. It is a dated `addenda/ADDENDUM-k.md` with `addenda/FROZEN-k.sha256`, the hashes of every frozen file after it. `run.py` checks the chain before it reads anything:
  - each link is committed once and never changed, one blob across the full history, as freeze 1's chain reads it;
  - each link comes after the one before, and no link once committed is gone;
  - each lists the files before it and its own text;
  - each changes no file but `layout.json` and the dry run's record;
  - the newest link's files are the bytes it names, committed;
  - the dry run's record passed every check on the code the newest link names.
- **How this file is frozen.** By the commit that adds `FROZEN.sha256`: its text there is the frozen one. It is not hashed, so that a link can be repaired without touching the code's hashes. A later edit may only repair a link or a typo, is listed in a dated note at the end, and changes no rule, threshold or reading.
