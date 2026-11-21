# TypicalRuns

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/TypicalRuns.lean`
- *result records that name this place's file as a source* (computed; not a link): `typicality-by-counting`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-20, as "TypicalRuns.lean: mem_courses_iff, records_concentrated, histories_records" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-20.md.txt)); pass b: reader whole-b-77, as "TypicalRuns.lean: mem_courses_iff, courses_records, sum_listing, total_listing, records_typical, records_concentrated, histories_records" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-77.md.txt)); the third pass, where the two differed: reader whole-c-settle-28, as "TypicalRuns.lean: settled fields share" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-28.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `mem_courses_iff` (l. 161) and `courses_records` (l. 196) identify the distinct Boolean courses of length n with exactly the prefixes shown by free-branching runs. `records_spread` (l. 225) and `records_concentrated` (l. 242) give the weighted spread identity and concentration bound on every exhaustive, repetition-free listing of those prefixes.
  - *pass b:* The module states that the courses of n steps on two values (`Typicality.courses`) are exactly the n-step prefixes shown by runs of free branching on Bool (`mem_courses_iff`, `record`), each listed once (`courses_records`). Since a count over any list holding each member once is the same (`sum_listing`, `total_listing`), Typicality's counts (2^n, (p + q)^n, the exact spread, the Chebyshev bound and the Chernoff bound) hold over every listing of those prefixes (`records_count` … `records_few_far_ahead`). These are general in n, p, q, d, k, u and v, but about one model: free branching on two values.
- **moves**
  - *pass a:* S: `mem_courses_iff` (l. 161) gives a realizing run of free Boolean branching for each listed course and puts every run prefix in the list. `records_count` (l. 206) counts possible prefixes across choices.
  - *pass b:* S: runs are of `Parting.free Bool`. `mem_courses_iff` (l. 161) states that a list of n values is a course of n steps exactly when some run r of free branching has `record r n = w`, witnessed by `Parting.freeRun (ofRecord w)`. N: no law says what a choice of steps keeps. The laws are counts over the prefixes of all runs.
- **a reading**
  - *pass a:* S: `record` (l. 156) reads n Boolean values of a run. `records_concentrated` (l. 242) bounds the total weight of records showing at least k ones for Records n l and v ≤ u.
  - *pass b:* S: `record r n` (abbrev l. 156) is the n-step prefix a run shows. `mem_courses_iff` (l. 161) states that every list of n values is shown by some run, and `records_typical` (l. 235) bounds the weight of prefixes deviating by at least d. N: nothing registered decides a selection or a course. D: the account (l. 30-32) says counting does not choose a run, and that no prefix shows a run will not part (citing `Parting.free_parts_after`).
- **a share**
  - *settled by the third pass:* S: `records_concentrated` (l. 242), section Counts (variables n, l): premises `listed : Records n l` and `le : v ≤ u`; conclusion `total l (Typicality.atLeast p q k) * (u ^ k * v ^ n) ≤ (p * u + q * v) ^ n * v ^ k`, where `atLeast` weighs the prefixes with at least k ones. `records_few_far_ahead` (l. 249) is its case p = q = 1, u = 3, v = 1. So the count of one value among two is in a statement, for every list holding each prefix of n steps of the runs of `Parting.free Bool` once. The second half of the field is absent: p, q, u, v are parameters throughout and no rule or favouring is set again from the count. The two passes say the same in substance. [which pass was right: both in part; opened: Records l.192; courses_records l.196; records_count l.206; records_weight l.210; records_spread l.225; records_typical l.235; records_concentrated l.242; records_few_far_ahead l.249]
  - *pass a:* N: `records_few_far_ahead` (l. 249) counts prefixes crossing a ones threshold. No rule reset from that count was found.
  - *pass b:* S: the count of ones appears through `Typicality.atLeast`. `records_concentrated` (l. 242) states that prefixes with at least k ones weigh, times u^k·v^n, at most (p·u + q·v)^n·v^k for v ≤ u, and `records_few_far_ahead` (l. 249) gives the p = q = 1 case. N: no rule or favouring is set again from the share.
- **a level that runs down**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N: no stock or reserve runs down.
- **a giving that is itself a going-on**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N: `records_count` (l. 206) states that there are 2^n prefixes. That is a count of courses, not units leaving units by a law of the step.
- **a point of no return**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N. D: the account (l. 31-32) cites `Parting.free_parts_after`, that no prefix shows a run will not part. It is not stated here.
- **both outcomes**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a comparison between two**
  - *pass a:* S: `total_listing` (l. 138) equates the total of any natural-valued reading on two listings of the same predicate. `histories_records` (l. 217) equates the history sum from either Boolean start with the total prefix weight on any Records listing.
  - *pass b:* S: `sum_listing` (l. 88), `sum_listed` (l. 118), `length_listed` (l. 123) and `total_listing` (l. 138) state that two lists without repetition holding the same members give every reading the same sum and the same length. `histories_records` (l. 217) states that the sum over histories in `Becoming.Weighted` (with `counting.along` of `Typicality.stepWeight`) equals the total weight over any listing of the prefixes. This carries a count between two ways of listing and two forms of the sum; it does not compare processes.
- **a rank (an ending within a bound)**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N: the bounds are on weights of prefixes, not on an ending.
- **a closed region**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, moves, reading, comparison. No answer relies on prose alone. The remaining questions are N, and I reached all fourteen.
  - *pass b:* All 258 lines read: the account and every statement and docstring. Questions 1-4 and 11 are answered from statements; the rest found nothing (N), with the account cited for 3 and 9.
