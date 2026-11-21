# ComparingCourses

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ComparingCourses.lean`
- *result records that name this place's file as a source* (computed; not a link): `comparing-two-courses-on-what-they-admit`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-02, as "ComparingCourses.lean: WidensOrWithLag.keepsWhatKept, TailAndLag.disagree, Sides.growing_keepsWidening" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-02.md.txt)); pass b: reader whole-b-06, as "ComparingCourses.lean: Web.WidensOrWithLag, Web.strictJoin_order, Web.ranks_self_of_crossed, Web.tailOrder_order, Web.KeepsWhatKept, WidensOrWithLag.includesEachLater, Sides.no_order_ranks_keeping_over_alike, TailAndLag.no_order_contains_both, LagWitness.decided, NamesAcrossSteps.lag_reads_names" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-06.md.txt)); the third pass, where the two differed: reader whole-c-settle-02, as "ComparingCourses.lean: settled fields no_return" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-02.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Web.WidensOrWithLag.trans`, `irrefl` and `of_widens` (ll. 211, 206, 202) give a strict partial order containing widening on every web. B: `TailAndLag.disagree` (l. 1668) gives opposite comparisons by eventual widening and widening with a lag on the same two courses.
  - *pass b:* For every web, on level paths (courses l : Nat → C → Nat), widening joined with widening with a lag (and with a lag varying with the formation, a lag for each admission, a lag along a continuation, or a lag from some step on) is a strict partial order containing widening (strictJoin_order l. 136, WidensOrWithLag.irrefl/trans l. 206/211, tailOrder_order l. 513). Every order except the lag-for-each-admission one ranks a course above another only where it keeps what the other keeps (l. 545-576). On built webs: no strict partial order containing widening ranks every course keeping widening by name above every static course of the class (Sides.no_order_ranks_keeping_over_alike, l. 739; AlongMerging.no_order_ranks_along_listed, l. 1413); no strict partial order contains both eventual widening and widening with a lag (TailAndLag.no_order_contains_both, l. 1674); the lagged order decides UE4's lag (LagWitness.decided, l. 1444).
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the compared courses are whole level paths supplied as functions of step and condition. There is no process with a choice among steps. The laws quantify over courses in a class (Web.RanksKeepingOverAlike, l. 126), not over a process's choices.
- **a reading**
  - *pass a:* B: `NamesAcrossSteps.lag_reads_names` (l. 1776) changes the lag verdict by exchanging names from step one, while ordinary widening agrees under the two identifications.
  - *pass b:* S: Web.widens_reidentify (l. 348): widening is unchanged by every re-identification of formations across steps. Web.widensOrWithLag_rename (l. 366): the lagged order is unchanged by every renaming constant across steps. Web.widensOrWithLagAlong_reidentify (l. 466): along a continuation, the lagged order is unchanged by every re-identification that carries it. B: NamesAcrossSteps.lag_reads_names (l. 1776): a re-identification that exchanges two names from step one on changes the lagged verdict, so the verdict depends on how formations are named across steps. That is a naming, not an observation class.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: Sides.ScaleAtLeast (l. 991) compares how many formations two courses admit at every step (by an injection), and Sides.scale_counts (l. 1052) makes it a strict order, but it is not a share and nothing is set again from it.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: there is no law of a level running down with what comes back depending on what is left. Courses are levels of conditions, supplied, and a formation is admitted where the levels meet its needs (Web.Admits, from Becoming.Admission). B: EachLagDrops.evenLevel/alternate (l. 1526/1547): a supplied level of 1 at even steps and 0 at odd steps.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *settled by the third pass:* B: TailAndLag.early_zero (l. 1625) with not_early_succ_zero (l. 1636): on OwnCondition.web the course early admits formation 0 at step 0 and at no step t + 1; tailOrder_loses (l. 1684) adds that ahead never admits it. Once lost not regained, in one built course whose levels are stipulated, so by definition of the course; the general WidensOrWithLag.includesEachLater (l. 326) is a comparison of two courses (what l' admits, l admits then or later), not a point of no return of a process. [which pass was right: a; opened: IncludesLater l. 108; WidensOrWithLag.includesEachLater l. 326; KeepsWhatKept l. 524; eachLag_not_keeping l. 1592; ahead l. 1607; early l. 1612; early_zero l. 1625; not_early_succ_zero l. 1636; tailOrder_loses l. 1684]
  - *pass a:* B: `TailAndLag.early_zero` and `not_early_succ_zero` (ll. 1625, 1636) give admission of formation zero initially and its permanent loss thereafter on the specified course.
  - *pass b:* N: no point of no return of a process or a level. What is stated is about losing an admission for good between two courses. S: WidensOrWithLag.includesEachLater (l. 326): if l widens l' or widens it with a lag, whatever l' admits at a step, l admits then or later. B: TailAndLag.tailOrder_loses (l. 1684): the tail order ranks 'ahead' above 'early', though ahead never admits formation 0, which early admits at step 0. B: EachLagDrops.eachLag_not_keeping (l. 1592): the lag-for-each-admission order ranks a course above one that keeps a formation the first drops.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no dichotomy of going on and ending, or of keeping and losing. Sides.silent (l. 818) is silent both ways, and Sides.keeping_reading (l. 975) has neither of the pair keeping what the other keeps.
- **a comparison between two**
  - *pass a:* S: `Web.WidensOrWithLag.keepsWhatKept` (l. 553) carries eventual permanent admission of every formation from the lower course to the higher. B: `EachLagDrops.eachLag_not_keeping` (l. 1592) refutes that implication when a separate lag is allowed for each admission.
  - *pass b:* S: the module's centre. IncludesLater.trans (l. 160): lags add. WidensOrWithLag.trans (l. 211). strictJoin_order (l. 136): widening joined to the strict part of any transitive relation containing inclusion is a strict partial order containing widening. ranks_self_of_crossed (l. 149): two rankings crossed by widening rank a course above itself. TailOrder.keepsWhatKept (l. 545), WidensOrWithLag.keepsWhatKept (l. 553) and WidensOrWithFormationLag.keepsWhatKept (l. 572): each order carries Web.KeepsWhatKept (every formation the other admits at every step from some step on, this one does too). B: Sides.keeping_over_alike_cycles (l. 754), Sides.exchange_needed (l. 774), Sides.reverse_consistent (l. 896), Sides.listed_consistent (l. 939), AllOrSegment.unlisted_consistent (l. 1224), Delayed.widens_not_withLag (l. 1507).
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: lags (IncludesLater d, l. 108) are bounds on delay in admitting, not bounds on ending, and nothing falls.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `Sides.growing_keepsWidening` (l. 624) proves continuing widening by name from zero; `growing_true` (l. 609) identifies the admitted first-side formations exactly as n ≤ t. S: `Web.widensOrWithLagAlong_order` (l. 442) gives a strict comparison along any supplied continuation.
  - *pass b:* B: Sides.growing_keepsWidening (l. 624): a course admitting one more formation at each step keeps widening by name from step 0. AllOrSegment.rising_keeps (l. 1166) and AlongMerging.keepingA_keeps (l. 1322) keep widening along a continuation that merges every formation into 0, so more is admitted later. S on one built web: AllOrSegment.reaches_secondSide (l. 1114): every course keeping widening by name admits every second-side formation at some step. B: EachLagDrops.alternate (l. 1547): formation 0 is admitted at even steps only, an alternation.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, comparison, forms_change. Built-case answers cover states, reading, no_return, comparison, forms_change. I reached all fourteen questions.
  - *pass b:* All statements and docstrings read (whole file, three parts), with the Web definitions in Admission, Regions and EventualWidening opened. Answered from statements or built cases: states, reading, share, level, no_return, comparison, forms_change. N: moves, giving, cost, multiplying, both_outcomes, rank, closed_region.
