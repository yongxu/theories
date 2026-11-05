# T1R: whether natural renewal returns in lakes stocked back above the need

Board item T1R, 5 November 2026, at the coordinator's offer. AI-written (a Claude Code session), not yet reviewed by a person. The rules ([`t1r.py`](t1r.py)), what T1R reads beyond T1N's reader ([`additions.py`](additions.py), [`layout.json`](layout.json)), the run ([`run.py`](run.py)) and the dry run ([`dry_run.py`](dry_run.py)) are frozen with this file by `FROZEN.sha256`, written last by [`write_frozen.py`](write_frozen.py). T1N's rules, reader and run are used at the hashes T1N's freeze names. *About 55 to 75 minutes to read, at 100 to 130 words a minute, the tables quicker; §1 and §11 in 8 to 12.*

## 1. What is tested, and the answer expected

T1N's verdict, if positive, says the lakes below the need fell and the lakes above it did not, and adds "the need's causal role not shown" ([T1N's §7](../need-measured-in-advance/DESIGN.md)). Renewal lost for years to another cause, a changed habitat or a run of warm springs, gives the same outcome, and T1N's records cannot tell the two apart. Lakes stocked back above the need can. If renewal stops below the need because of the level, a lake whose level is restored renews where it did not while below. If renewal was lost to another cause, restoring the level does not bring it back.

**The verdict (V1).** The lakes read are those whose spring adults stood wholly below T1N's need, were then stocked, and later stood wholly above it.
- Each lake's own renewal is read once above the need, in its first year back above it with no stocking recorded that year or the year before. That fall's age-0 comes from the lake's own spawning, since a fish stocked earlier is two or more by then.
- Where the lake was also surveyed in a year below the need with no stocking recorded that year, its renewal is read there too, in the last such year before the year read.
- Let k of the n lakes read reach T1N's floor in the year read. Of the m lakes also read below the need, let u renew above it and not below, and d below it and not above.

There are three outcomes (§7), each with its clauses:
- **Renewal rose with the level.** u exceeds d by an exact sign test at 0.05. Within the same lakes, renewal came above the need where it had not come below, more often than the reverse. Renewal is read as following the level in some of these lakes at least, and not lost to another cause in all of them. The line gives what the need's fit expects at the levels restored, but does not say what share of the lakes follows the level. It always carries one clause, that what held their renewal down ended by the year read. It carries unrecorded stocking or connected waters where they apply.
- **Renewal did not rise with the level.** The rise is not shown, and fewer lakes renewed in the year read than the need's fit expects even at the lower bounds of the levels restored, by an exact test at 0.05. Renewal is read as short of the level's in some of these lakes at least, as where it is lost to another cause. It always carries three clauses: stocking suppressing natural renewal, their own needs lying above the common one, and the adults restored counting stocked fish not yet spawning.
- **Not decided**, where fewer than ten lakes are read, T1N finds no need, or neither test decides.

**What the test is worth.** It is the one test that turns T1N's "the need's causal role not shown" into evidence on the need's role. Each outcome answers one part of that:
- *rose* shows that in some of the lakes that fell below the need, renewal came back once the level was restored, where it had not come below. Renewal lost to another cause in all of them would not give that.
- *did not rise* shows that in some of these lakes at least, restoring the level did not bring renewal up to what the fit gives at that level. Renewal lost to another cause gives that.

Neither shows that renewal *stops* below the need. The fit's 50% point is a property of the level both where renewal stops below a need and where it only shrinks at low levels, and T1N's fit does not tell those apart either.

**Independence from T1N.** No year T1R reads above the need is a year T1N's fit reads (§4). Its low surveys and years below the need may be. Its lakes are partly lakes whose fates T1N reads after 2012, so the two verdicts share lakes. They are not two independent results, and the run reports how many lakes both read.

**The answer expected.** None, from the account alone:
- where the lakes that fell are in T1's regime, it predicts *rose*;
- renewal lost to another cause predicts *did not rise*;
- the dry run has a world where 30% of lakes lose their renewal and the rest are in T1's regime. There *rose* came out in 40 of 40 archives at 0.1 and 36 at 0.03, and *did not rise* in none at 0.1 and 4 at 0.03 (§8).

The outcome is kept whatever it is.

**Its limits** (§13, each holding so far):
- something else that held renewal down ending by the year read, which these records cannot separate from the level's return;
- stocked fish suppressing the lakes' own renewal, which they cannot separate from renewal lost;
- lakes whose own needs lie above the common one;
- stocked fish counted among the adults before they spawn;
- *rose* not saying what share follows the level;
- the power of one year a lake, read two years from a stocking.

## 2. Why this test, and the alternatives considered

- **Marks alone.** The coordinator first set the scope as lakes whose stockings are recorded as marked, since only a mark tells a stocked fish from a lake's own. A fall survey with no stocking recorded that year or the year before needs no mark. A fish stocked earlier is two or more by that fall, and is not counted as age 0. T1N's own fit reads age 0 the same way, in lake-years with no stocking recorded in them or the five years before. So the primary scope is those years, and the marked years are a second route, reported (§5). The coordinator agreed.
- **The common fit at the lakes' low levels.** The design first read the rise against the need's fit at each lake's level below the need: more lakes renewing in the year read than the fit allows at their low levels. Round 1's reader set it aside (R-01). In one world the lakes whose renewal is lost go unstocked, so the lakes stocked back renew at any level, and the fit's chance at low levels comes from the lost lakes. There the rise came out in 31 of 40 archives of 900 lakes, though no lake's renewal follows the level. The fit's chance at a level belongs to the lakes it was fitted on, not to these lakes. So the rise is now read within each lake, against its own renewal below the need, and the fit's chance at the low levels is only reported.
- **A year read right after a stocking.** Set aside (round 1's R-02). In one world a tenth of last year's surviving stocked fish are read as age 0 in the fall survey, and nearly every lake read has lost its renewal. There, under the design round 1 read, a year read with no stocking that year alone gave *rose* in 33 of 40 archives of 300 lakes at 0.1. So the year read has no stocking recorded that year or the year before.
- **A need refitted for these lakes.** Set aside: the need is T1N's, imported by hash, so T1R cannot fit one to suit its outcome (§4).
- **The recorders' label returning to natural recruitment.** Set aside as the outcome: the label is the recorders' classification, and its criteria may read the same surveys.
- **Persistence after stocking stops.** Set aside: a lake that holds its level after stocking ends mixes its own renewal with the survival of stocked fish.
- **Every year read, rather than one a lake.** Set aside. A lake's years share its productivity and its cause, so they are not independent, and one year a lake above the need and one below keep the lakes' pairs independent of each other. An earlier draft read renewal in any of three years, which brought both chances near one, so a group in which some lakes renew and some do not showed no rise (§8).
- **A year below kept two years from a stocking too.** Set aside. It read too few lakes below the need: in the author's runs, *need* at 0.03 rose in 26 of 40 archives against 36. A year below read within a stocking programme also shares the stocking's effects with the year read.
- **A test of the shortfall against the fit as part of the rise.** Set aside (§8). The fit's chances at the levels restored are uncertain, and no fixed reading of them was right in both directions. At the estimates they gave false shortfalls where every lake follows the level; at the intervals' lower bounds they hid shortfalls where two in five lakes had lost their renewal. So the rise is read for some lakes at least, the fit's expectations are reported beside it, and the shortfall decides only the negative outcome, at the bounds.

## 3. The records

T1N's records, its R1 to R5, R5b and R7 ([T1N's §3](../need-measured-in-advance/DESIGN.md)), from the folder T1N's downloads fill and read by T1N's reader at its frozen hash. Nothing of them is downloaded again. T1R adds three things:
- **The stocking files' dates**, where they give a date column, as named in T1R's layout.json. A stocking filed under another year's entry, a season's or a budget's year, would otherwise let a stocked fish of the survey's own spring, or of the year before, be read as natural. A lake with a walleye stocking whose date gives no readable year, or that stands in a stocking file with no date column while the other file has one, is undated.
- **R8, the marked shares**, where the agency's stocking evaluations give them as a table. For a stocked lake-year, this is the unmarked share of the fall age-0 catch, for a stocking the agency marked with oxytetracycline. R8's layout is assumed in layout.json and checked at the layout step. Where R8 cannot be had, the second route is empty, and the layout step says so. Where any share is above 1, the file may give percentages, and the second route is not read.
- **The fall surveys repeated**: the lake-years with more than one fall survey, by R2's lake and year columns. T1N's reader reads such a year at its largest catch, and the run reports how many of the years T1R reads are such.

**How age 0 is told.** By R2's own field, the agency's age-0 count per mile, as T1N reads it. T1R reads no length and fits no length cut. Where R2 gives lengths and no age-0 field, T1N's reader refuses (its §9), and T1R's run then writes no result.

## 4. The need

**T1N's, by hash.** The run calls T1N's `need` on the lakes T1N's reader builds, at T1N's floor of one age-0 per mile, with the labels as T1N reads them. Before it loads, `t1r.py` checks `t1n.py`, `reader.py` and T1N's `run.py` against T1N's base link, and refuses if any differs. T1N's addenda may change only its layout and its dry run's record, so these hashes stand. Where T1N finds no need, T1R is not decided.

**No year read above the need is one the fit reads.** T1N's fit, and its renewal report, read only lake-years with no stocking recorded in them or the five years before (its `pairs`). Every year T1R reads above the need has stocking recorded in T1N's records in the five years before it. So the need was neither fitted on nor reported from any of them, and a scripted check holds it. A lake's low survey and its year below the need may be years the fit reads. They set which lakes are read and the comparison within each lake, not the need.

## 5. The scope: the lakes and the years read

`scope` takes, for each lake:
1. **The low survey**: the lake's first spring estimate whose 95% interval lies wholly below the need, its estimate and upper bound above no adults.
2. **Stocking from it on**, in any record, from the low survey's own year: a stocking that year comes after the spring's count. A lake with none is out.
3. **No return first**: a lake with a spring interval wholly above the need after the low survey, and no later than its first stocking from it, came back before it was stocked, and is out.
4. **The year read**: the lake's first year after the low survey in which:
   - the spring interval lies wholly above the need;
   - stocking is recorded from the low survey's year within the five years before it, in T1N's records, so that T1N's fit never reads the year;
   - no stocking is recorded in it or the year before, in WDNR's database, in R5b, or by a stocking's date;
   - a fall survey was made.

   The fall's age-0 that year is the lake's own renewal.
5. **The year below**: the lake's last year from the low survey to the year read in which the spring interval lies wholly below the need, no stocking is recorded that year, and a fall survey was made. A lake with none is still read. It counts in n and k, not in m, u or d.
6. **The second route** (reported, §7): a stocked year read whose unmarked share R8 records, with none recorded the year before, is read at the catch times that share.

A stocking whose date falls in a different year from its entry counts in both years. One year a lake is read above the need, and one below (§2).

**Out**, and counted by reason:
- lakes never wholly below the need;
- lakes with no stocking from their low survey;
- lakes back above the need before they were stocked;
- lakes with no year read, including those stocked every year, or every other year without a break, with no estimate after.

## 6. What is compared

For each lake read:
- **within the lake**: whether it reached the floor in its year read, and in its year below where it has one;
- **against the fit at the level restored**: the fit's chance at the lower bound of the year read's interval, and, reported, at its estimate;
- **reported**: the fit's chance at the upper bound of the low survey's interval, the comparison of the design round 1 read (§2).

**Why the lower bound.** A year is read because its interval lies wholly above the need, so its estimate tends to run high, and the chance at the estimate would be too high. The lower bound errs toward not deciding.

## 7. The verdicts

**V1** (`decide`, `v1`). Two exact one-sided tests:
- **the rise**, within the m lakes also read below the need: the chance that a fair coin gives at least u heads in u + d tosses (T1N's `tail_half`). It is shown where that chance is at most 0.05. Where a lake's renewal does not depend on its level, either of its two years is as likely as the other to be the one that renewed.
- **the shortfall**: the chance of at most k of the n lakes renewing, at their chances at the lower bounds of the levels restored, a sum of independent trials (Poisson-binomial). It is shown where that chance is at most 0.05.

The rule, in order:
1. Not decided where n < 10 (`N_MIN`).
2. Renewal rose with the level, where the rise is shown.
3. Renewal did not rise with the level, where the rise is not shown and the shortfall is.
4. Not decided otherwise.

**The lines in full.** Each opens "of n lakes stocked back above the need, k renewed at the floor in a year read". Then:
- **rose**: "; of the m also read in a year below the need, u renewed above it and not below and d below it and not above (p = …), more often above; the need's fit expecting e at the levels restored (e′ at their intervals' lower bounds); renewal read as following the level in some of these lakes at least, not lost to another cause in all of them, unless {the clauses of the rise}";
- **did not rise**: ", fewer than the need's fit expects even at the lower bounds of the levels restored (e′ expected, p = …); of the m also read in a year below the need, u renewed above it and not below and d below it and not above (p = …), not shown more often above; renewal read as short of the level's in some of these lakes at least, as where it is lost to another cause, unless stocking suppresses natural renewal, their own needs lie above the common one or the adults restored count stocked fish not yet spawning";
- **not decided**: "fewer than 10 lakes read", or the counts within the lakes "not shown more often above" and "not shown fewer than" the fit's expectation.

**The clauses of the rise:**
- **unrecorded stocking**, where a lake that renewed above the need and not below has R5b unread or is undated (§3), or the stocking files give no date;
- **connected waters**, where such a lake is not a recorded seepage lake, and the closed lakes alone, read by the same rule, do not also show the rise;
- **what held their renewal down ended by the year read**, always. Four things other than the level can change between a lake's year below and its year read, and no reading of these records separates them from the level's return:
  - a lasting cause ending, since managers stock when renewal fails and a cause may pass in the same years;
  - a run of poor years passing, which may be what brought the stocking;
  - a suppression by stocked fish easing, since the year below may follow a stocking by one year and the year read follows one by two or more;
  - the survey's catch rising.

**The clauses of the negative outcome**, all always:
- **stocking suppresses natural renewal.** Stocked fish still eat a lake's own age 0 in an unstocked year, and nothing here separates that from renewal lost.
- **their own needs lie above the common one.** The lakes read were chosen by having fallen and been stocked, and they may need more than the lakes the need was fitted on. The lakes restored to at least their own earlier renewing level are read again and reported. That level is the median spring level of the lake's own unstocked years before its low survey whose fall reached the floor, the upper of the middle two where they are even. That reading compares them with the common fit too, so a shortfall there does not rule their own needs out, and the clause stays.
- **the adults restored count stocked fish not yet spawning.** A stocked cohort is counted among the spring adults by its length or by its ripe males before its females spawn. So a lake raised above the need by stocking may hold fewer spawners than an unstocked lake at the same count, and renew less than the fit gives there (round 1's R-03).

V1's numbers keep the readings the clauses rest on, the closed lakes alone and the lakes restored to their own level, each named as read before the clauses.

**Reported, ruling on nothing** (`reports`, `read`, run.py):
- V1 on the lakes whose year read is after 2012 alone, the window T1N holds out;
- V1 with the second route's marked years added, where R8 is read;
- the lakes out, by reason;
- renewal in the years read by the years since the last stocking, which a suppression by stocked fish would lower nearest the stocking;
- the lakes read with no year below the need, and how many of them renewed;
- the fit's expectation at the lakes' levels below the need;
- the years read and below with more than one fall survey, read at the largest catch;
- the lakes T1R reads that T1N also reads (§1);
- V1 without the three lakes of T1N's §9 disclosure (§9).

## 8. Dry runs

[`dry_run.py`](dry_run.py) builds synthetic archives of 900 lakes, about the field's size, from 1990 to 2025. It reads each with T1N's need and T1R's rules. Its record is [`results/dry-run.json`](results/dry-run.json): 88 checks, none failed, 194 CPU seconds.

**The model.** T1N's own (its §8):
- renewal R(x) = 60 x^q / (1.5^q + x^q), with log-normal noise;
- next spring's adults 0.7x − h, plus 0.03 times the age-0 of three years before;
- harvest cut below one adult per acre, and winterkills;
- spring estimates every three to five years, their intervals at a CV of 0.25.

T1R adds managers who stock:
- A lake below one adult per acre begins a programme with a chance a year (the speed: 0.1 or 0.03).
- It is then stocked every other year for ten years.
- A stocking's fingerlings are in that fall's age-0 catch, and join the adults three years later as one adult per acre.

The speeds are T1N's two slower ones. At T1N's third, 0.3 a year, lakes are stocked before they stay below the need: T1N's own dry run fitted no need in 33 of 40 archives of its *need* world there.

**The worlds**, in six families:
- **T1 holds** (q = 3):
  - *need*;
  - *needs vary* (each lake's 1.5 scaled by a factor of about 2);
  - *lakes differ* (productivity spread 0.5);
  - *episodic* (σ = 1.6);
  - *stocked every year*;
  - *open* (age-0 immigrants in open lakes).
- **T1 holds, with a rival of the negative outcome** (reported):
  - *stocking suppresses*: a lake's own renewal is cut to a fifth for three years after each stocking;
  - *stocked fish counted before they spawn*: each stocked cohort is counted among the adults for three years before it spawns, at weights of 1, 0.6 and 0.36 for its survival (round 1's R-03).
- **Renewal lost** (q = 1, T1N's family of that name). 30% of lakes lose their renewal for good from a year between 1995 and 2015.
  - *light harvest*: harvest up to 0.3, so lakes fall mostly by the loss;
  - *renewal lost*: T1N's harvest;
  - *other stocking read*: fry stocked in the years between, recorded in R5b, read;
  - *dated*: half of the stockings filed under the year before, their dates read;
  - *the lost lakes left unstocked*: managers leave the lakes whose renewal is lost unstocked and begin the others' programmes ten times as soon, with winterkills at 0.04 a year, so the lakes read renew at any level and are many (round 1's R-01);
  - *yearlings read as age 0*: a tenth of last year's surviving stocked fish, 40% of a stocking, are read as age 0 in the fall survey (round 1's R-02).
- **Mixed** (reported apart): *renewal lost, need*, with q = 3, and 30% of lakes losing their renewal as above.
- **Confounded**: renewal lost, each with a confound only a clause answers:
  - *other stocking unread*;
  - *no dates*;
  - *open*;
  - *the cause ends*, where renewal returns at the first stocking;
  - *stocked after a failed survey*: renewal episodic (σ = 1.6), and managers begin a programme only after a fall survey below the floor, so a run of poor years brings the stocking and then passes.
- **No need** (q = 1): *no need*; *lakes differ*; *catch 0.1*.

V1 in 40 archives a cell: R *rose*, D *did not rise*, N not decided, – no need fitted by T1N.

| World | 0.1 | 0.03 |
|---|---|---|
| **T1 holds** | | |
| need | R 40 | R 36, N 4 |
| needs vary | R 40 | R 40 |
| lakes differ | R 40 | R 40 |
| episodic | R 40 | R 40 |
| stocked every year | R 40 | R 32, N 8 |
| open | R 34, N 6 | R 7, N 33 |
| **T1 holds, with a rival of the negative outcome (reported)** | | |
| stocking suppresses | R 40 | R 35, N 5 |
| stocked fish counted before they spawn | D 40 | D 29, N 11 |
| **Renewal lost** | | |
| renewal lost, light harvest | D 40 | D 40 |
| renewal lost | D 40 | D 40 |
| renewal lost, other stocking read | D 38, N 2 | D 8, N 32 |
| renewal lost, dated | D 40 | D 40 |
| renewal lost, the lost lakes left unstocked | D 4, N 36 | D 2, N 38 |
| renewal lost, yearlings read as age 0 | D 40 | D 39, N 1 |
| **Mixed (reported apart)** | | |
| renewal lost, need | R 40 | R 36, D 4 |
| **Confounded** | | |
| renewal lost, other stocking unread | R 4, D 36 | R 3, D 30, N 7 |
| renewal lost, no dates | D 40 | D 40 |
| renewal lost, open | D 40 | D 37, N 3 |
| renewal lost, the cause ends | R 40 | R 38, N 2 |
| renewal lost, stocked after a failed survey | D 40 | D 40 |
| **No need** | | |
| no need | – 40 | – 40 |
| no need, lakes differ | – 40 | N 8, – 32 |
| no need, catch 0.1 | R 1, N 36, – 3 | N 39, – 1 |

**The checks on the worlds:**
- where T1 holds, *did not rise* in at most 5 of 40 archives at each speed (a level of 0.05 exceeds 5 such outcomes in 40 with chance 0.014);
- where renewal is lost and nothing confounds it, *rose* in at most 5 of 40;
- in each confounded world, a rise read without its clause in at most 5 of 40;
- power: *need* at 0.1, *rose* in at least 30 of 40; *renewal lost, light harvest* at 0.1, *did not rise* in at least 30 of 40.

**Set after the author's dry runs**, with the numbers those runs gave, which are not in the record:
- **The bounds** (§6). At the estimates, the T1 world *need* gave a false shortfall in 4 of 40 archives.
- **One year a lake** (§2). In an earlier draft, reading renewal in any of three years, the mixed world gave *did not rise* in 36 of 40, though most of its lakes follow the level.
- **The clause of own needs, always.** Dropping it where the own-level reading also showed a shortfall dropped it wrongly in 1 of 40 archives of *needs vary* at 900 lakes.
- **Three outcomes, not four.** The rule first read a fourth, "renewal returned with the level", where the shortfall at the bounds was not shown. It read renewal as following the level in these lakes and not lost to another cause. In the mixed world, the archives that gave it had 34 of their 85 lakes read lost to another cause. So the rise reads "in some of these lakes at least", and the fit's expectations are reported beside it rather than tested (§2).
- **The mixed world** was first in the renewal-lost family. There its bound failed, *returned* in 6 of 40 at 0.03, since most of its lakes follow the level. It is reported apart.
- **After round 1's reading:**
  - **The rise within the lake** (§2, R-01): the reader's world of lost lakes left unstocked gave *rose* in 31 of 40 under the design round 1 read.
  - **The year read two years from a stocking** (§2, R-02): yearlings read as age 0 gave *rose* in 33 of 40 under the design round 1 read.
  - **The clause of stocked fish counted before they spawn** (§7, R-03): under the design round 1 read, *needs vary* with such cohorts gave *did not rise* in 39 of 40 at 0.1, which neither clause then named.
  - **900 lakes an archive.** At 300, the rise within the lake read too few lakes: *need* at 0.1 rose in 18 of 40.
  - **The year below one year from a stocking allowed** (§2): kept two years from one too, *need* at 0.03 rose in 26 of 40 against 36.

**What the dry runs show:**
- **Where T1 holds, V1 rose in 40 of 40 archives at 0.1 in every world but *open*, and never came out *did not rise*.** *open* rose in 34 at 0.1 and 7 at 0.03, where it read a median of 8 lakes. At 0.03 fewer lakes are read, a median of 15 in *need*, 11 of them below the need too; *need* rose in 36 of 40 there, and *stocked every year* in 32.
- **Where stocking suppresses a lake's own renewal** to a fifth for three years after each stocking, V1 rose in 40 and 35 of 40 and never came out *did not rise*. **Where stocked cohorts are counted among the adults for three years before they spawn, V1 came out *did not rise* in 40 and 29 of 40**, each time with the clause naming them. That rival is strong at this size, and only its clause answers it.
- **Where renewal is lost and nothing confounds it, V1 never rose.** In each of these worlds but *the lost lakes left unstocked* it came out *did not rise* in 38 to 40 of 40 at 0.1. At 0.03, *other stocking read* read a median of 7 lakes and did not rise in 8. Of the lakes read in these worlds' archives that did not rise, 91% to 97% had lost their renewal; the rest had fallen by harvest or a winterkill. Yearlings read as age 0 gave *did not rise* in 40 and 39 of 40 and no rise. The lost lakes left unstocked gave no rise either: not decided in 36 and 38 of 40, *did not rise* in 4 and 2, with a median of 87 lakes read at 0.1. In its archives that did not rise at 0.1, 61 of the 321 lakes read had lost their renewal.
- **In the mixed world, V1 rose in 40 and 36 of 40, and did not rise in none and 4**, at 0.1 and 0.03. Where it rose, 1874 of the 2691 lakes read at 0.1 had lost their renewal, and none of the 513 that renewed above the need and not below. *Rose* says some at least, not what share.
- **In the confounded worlds the rise came with its clause.** Fry stocked unrecorded, with R5b unread, gave *rose* in 4 and 3 of 40, each with *unrecorded stocking*. The cause ending at the first stocking gave it in 40 and 38, each with what held renewal down ending. Stocking files with no dates, immigrants reaching open lakes, and managers stocking after a failed survey gave no rise. In *no dates*, where half the stockings are filed under the year before and no date is read, a stocking's own year has one recorded the year before, so it is never a year read.
- **Where there is no need, V1 rose once in 240 archives, in *catch 0.1*, and was otherwise never decided.** In *no need* and *no need, lakes differ*, T1N's need was fitted in at most 8 of 40 archives: with q = 1, renewal reaches the floor at nearly every level. In *catch 0.1* it was fitted in 37 and 39. There the floor of one age-0 a mile is reached only at higher levels, so renewal at the floor follows the level, smoothly, with no need below which it stops; a rise says no more than that.

**Other checks.** The rules on scripted lakes (34 checks): the low survey, the year read and the year below and each of their conditions, the dates, R5b and R8, the own level, that no year read is one T1N's fit reads, the rule at its thresholds, the lines' words, and each clause. T1R's additions on synthetic files (10): the dates read back, the rows filed under another year counted, a lake with an unreadable date undated, R8 read back, its shares above 1 and its lake-years given twice, the facts the same with R8's shares overwritten, the repeated fall surveys, and the dates in the files' forms. The run end to end on synthetic files through T1N's reader, and its refusals of R8 unrecorded (4). T1R's freeze by T1N's frozen check in a stand-in repository (4): it refuses before the link, passes whole, and refuses a changed rule and an addendum changing one.

## 9. Data and what has been seen

Read before this design: T1N's design and code, 02 §5, and the documentation T1N's §9 lists. No value of any record was read, and nothing was downloaded. T1N's §9 records a search summary that showed T1N's round-3 reader fall-survey values for Worcester Lake, and for Crane and Chase Lakes, in Price County. T1R reads fall surveys too. So the run also reads V1 without those three lakes and reports both, finding them as T1N does (`reader.seen`).

## 10. The run's order

1. **The downloads.** T1N's (R1 to R5, R5b and R7) are made on Ren's yes, in the order T1N's §10 gives. R8, where it can be had as a table, comes on the same yes, its source, date, size and sha-256 in T1R's `downloads.json`.
2. **The layout, with no value read.** These are T1N's layout facts and T1R's (`python3 -B experiments/stocked-above-the-need/additions.py facts FOLDER`), from the structural columns alone:
   - the stocking files' date columns;
   - their walleye rows filed under another year than their date's, the rows with no readable year in the date, and the lakes undated;
   - R8's header, rows and lakes, by its lake and year columns, never its shares;
   - the lake-years with more than one fall survey.

   Where the layout differs, an addendum changes T1R's `layout.json` alone (§14).
3. **The run** (`python3 -B experiments/stocked-above-the-need/run.py FOLDER`, writing `results/run.json`). It reads T1N's need, then V1 and its readings, the reports, the lakes both read, and V1 without the disclosed lakes. `run.py` refuses:
   - unless T1N's freeze and T1R's both pass T1N's own frozen check;
   - unless T1N's downloads pass T1N's own check;
   - where R8 is in the folder and T1R's `downloads.json`, committed once, does not record it;
   - where `results/run.json` exists.

## 11. What each outcome means

| V1 | What it means |
|---|---|
| Renewal rose with the level | In some of the lakes stocked back above the need, renewal came in the year read where it had not come below the need, more often than the reverse. Renewal follows the level in some of them at least, which renewal lost to another cause in all of them would not give. The clauses still stand: what held their renewal down ending by the year read, and unrecorded stocking or connected waters where the line names them. Where T1N's verdict is positive, its "causal role not shown" is now partly answered, since renewal lost in all the lakes is ruled out. How many lakes follow the level is not shown: the line gives the fit's expectations to set k against. Whether renewal stops below the need is not shown. |
| Renewal did not rise with the level | No rise within the lakes was shown, and in some of these lakes at least, renewal in the year read fell short of what the need's fit gives at the levels restored. That reads as renewal lost to another cause in those lakes, outside T1's regime, unless stocked fish suppress it, their own needs lie above the common one, or the adults restored count stocked fish not yet spawning. Where T1N's verdict is positive, it may rest in part on such lakes; how far is not read. |
| not decided | Fewer than ten lakes read, no need found by T1N, or neither test decides. |

## 12. What waits on Ren

On the board's Decisions line:
- **R8**, where WDNR's or GLIFWC's stocking evaluations give the marked shares as a table, with T1N's downloads, which wait on Ren's yes already;
- **the run**: a few seconds of CPU on this machine, standard library, no model call, no key.

Freezing waits on no one.

## 13. Limits and literature

- **What held renewal down ending** (§7). A lasting cause that ends as the lakes are stocked, a run of poor years that brought the stocking and passes, a suppression by stocked fish that eases, or a rise in the survey's catch each reads as renewal following the level. This holds so far (5 November 2026), for that reason. It lapses with lakes restored above the need at different times from when a region-wide cause ended, read apart, or with each lake's year below read after its stocking began. In the dry run, the cause ending at the first stocking gave *rose* in 40 and 38 of 40 archives, each with this clause; managers stocking after a failed survey gave no rise.
- **Stocked fish suppressing natural renewal** (§7). Predation or competition by stocked fish lowers a lake's own renewal, and reads as renewal lost. This holds so far. It lapses with the renewal of lakes stocked back above the need, read long after the last stocking. The report of renewal by years since the last stocking shows the pattern a suppression would give. In the dry run, a suppression to a fifth for three years still gave *rose* in 40 of 40 archives at 0.1.
- **Own needs** (§7). The common need may lie below the needs of the lakes that fell and were stocked. This lapses with a need for each lake, fitted before the series it judges, which T1N set aside.
- **Stocked fish counted before they spawn** (§7). This holds so far. It lapses with the adults counted read by age or sex for the stocked cohorts, or with the year read taken once every stocked cohort is of spawning age. In the dry run, cohorts counted three years before they spawn gave *did not rise* in 40 and 29 of 40 archives where T1 holds.
- **What share follows the level** is not read: *rose* says some at least. In the dry run's mixed world, 1874 of the 2691 lakes read in the archives that rose at 0.1 had lost their renewal (§8).
- **One year a lake, two years from a stocking**, costs power. In the dry run, *need* at 0.03 read a median of 15 lakes an archive, 11 of them below the need too, and rose in 36 of 40 (§8). A lake stocked every other year without a break is not read above the need until its stocking stops.
- **The years read are few.** Spring estimates come every three to five years, so a lake's first year read can be many years after its low survey.
- **The age-0 classification** is the agency's (§3). A yearling read as age 0 is kept out by the year read's distance from a stocking; a fish two or more is taken as never read as age 0.
- **Stocking outside the records read.** *Unrecorded stocking* is named only where R5b is unread or a lake undated. A stocking in neither WDNR's database nor R5b, in a year read or the year before, makes that lake's renewal its stocking's. This holds so far, and lapses with R5b read as complete.
- **Repeated fall surveys.** A lake-year surveyed twice is read at the larger catch, as T1N reads it, and a lake surveyed more often once stocked has more chances to reach the floor. The run reports how many years read and below are such.
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
- **Readers.** As T1N's: an independent reader reads the files before the freeze lands, in a full read and then on the diff of each round's fixes, until a round finds nothing of high or medium severity, at most five rounds. The findings are in [`REVIEW-FREEZE.md`](REVIEW-FREEZE.md). Round 1's changed the design: the rise is read within the lake, the year read is two years from a stocking, and the negative outcome names stocked fish counted before they spawn.
- **What is frozen.** `FROZEN.sha256` lists:
  - `t1r.py`, `additions.py`, `run.py`, `dry_run.py`, `layout.json` and `write_frozen.py`;
  - the dry run's record.

  `t1r.py`'s check holds T1N's files T1R uses at T1N's hashes.
- **An addendum** may change only T1R's `layout.json`, after the layout is read with no value, and with it the dry run's record. T1R's chain is checked by T1N's own frozen check, T1N's `run.frozen` run on T1R's folder. That check refuses an addendum that remaps a label text, and stops with an error on a `layout.json` with no `labels` key. T1R maps none, so its `layout.json` holds an empty `labels`, which an addendum keeps.
- **How this file is frozen.** By the commit that adds `FROZEN.sha256`: its text there is the frozen one. A later edit may only repair a link or a typo, is listed in a dated note at the end, and changes no rule, threshold or reading.
