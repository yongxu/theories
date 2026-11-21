# RevisionPlans

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/RevisionPlans.lean`
- *result records that name this place's file as a source* (computed; not a link): `what-holding-for-a-reading-is-worth`, `when-holding-for-a-reading-stands-above-a-route`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-stop-passed-by-a-listing-that-fixes-the-sign`

## 21 November, how a registering comes to be: reader revision-and-forming

*As "RevisionPlans.lean". A reader's return, unchecked; what the note mended is in the note: [note](../../read-registering-2026-11-21/NOTE.md), [report](../../read-registering-2026-11-21/read-revision-and-forming.md.txt).*

- **what registers what**: reading c := decide (gain c \< offGain c) (l168), from supplied numbers. held r a (l163) holds the act for a supplied reading r.
- **what changes it**: Nothing changes along a course; it is a static order on plans (order l143).
- **laws where something comes to be registered**: None found in what was read. gainOf_reading (l213) and excess_reading (l223), premise Splits listed weight p, are equalities of gains.
- **cost and keeping**: Holding forgoes an amount a. From the account: reading_not_below_iff (l253) and reading_above_iff (l262), premise Splits; statements not read in full.
- **a registering lost**: None found.
- **tied to what it rests on**: None found; gain, loss and weight are supplied.

## 22 November, every module by fifteen questions

*pass a: reader whole-a-17, as "RevisionPlans.lean: balance, reading_above_iff, above_iff_routes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-17.md.txt)); pass b: reader whole-b-64, as "RevisionPlans.lean: KeepStop, gainOf, excess, held, reading, gainOf_reading, balance, above_iff, reading_not_below_iff, gainOf_move, ofRoutes, routes_above_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-64.md.txt)); the third pass, where the two differed: reader whole-c-settle-24, as "RevisionPlans.lean: settled fields both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-24.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: Any two plans splitting the listed weights have equal gain plus excess (`balance`, l. 228). The general plan order therefore ranks the smaller own loss plus excess strictly higher (`above_iff`, l. 244), and specializes to revision routes on one candidate.
  - *pass b:* General, near-definitional arithmetic for any type of candidates with supplied weights and gains. A plan keeps the law at some weight and switches it off at some weight at each candidate, with a loss of its own. Holding for the reading that tells the candidate gains what any plan splitting the weights gains plus that plan's excess (gainOf_reading), so between such plans the order is that of loss plus excess (balance, above_iff, reading_not_below_iff, reading_above_iff). RevisionRoutes' revision and routes are shown to be plans on one candidate (ofRoutes, above_iff_routes, routes_above_iff), with a built Example.
- **moves**
  - *pass a:* S: `splits_held` (l. 180) gives a splitting plan for every Boolean rule and own loss; `held` (l. 163) keeps the full weight where the rule releases and stops it where it stops.
  - *pass b:* S: plans are choices of kept and stopped weights (`KeepStop` l.121), ordered by `order` (l.143), but there is no Process or step. `gainOf_move` (l.293), `move_le_of` (l.306), `move_ge_of` (l.319): moving weight r from switching off to keeping never lowers the gain where keeping loses at no listed candidate, and never raises it where keeping gains at none.
- **a reading**
  - *pass a:* S: `reading` (l. 168) stops exactly when offGain exceeds gain. Against any splitting plan, holding for this reading gains that plan’s gain plus its excess (`gainOf_reading`, l. 213).
  - *pass b:* S: `reading` (l.168) stops exactly where offGain c > gain c, and `held` (l.163) holds for a rule. `gainOf_reading` (l.213): for any plan p splitting the weights, holding for the reading gains gainOf p + excess p. `excess_reading` (l.223): holding for the reading has no excess. `gainOf_reading_eq_iff` (l.333): it ties a splitting plan exactly when that plan has no excess. The reading is a rule built from the supplied gains at each candidate.
- **a share**
  - *pass a:* N: `Splits` (l. 153) partitions supplied candidate weights into keep and stop weights. I found no step resetting a rule from the resulting share.
  - *pass b:* N: weights per candidate and `Splits` (l.153) appear, but no rule or favouring is set again from a share.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a cost to the one that keeps or gives**
  - *pass a:* S: `reading_not_below_iff` (l. 253) puts the amount forgone by holding into the plan’s own loss; holding stands at least as high as a splitting plan exactly when this amount is within its loss plus excess. The amounts are supplied.
  - *pass b:* S: each plan carries its own loss (`KeepStop.loss` l.127), and holding forgoes an amount a. `reading_not_below_iff` (l.253): holding for the reading at cost a stands at least as high as a splitting plan p exactly when a ≤ p.loss + excess p. `reading_above_iff` (l.262): it stands strictly above exactly when a \< p.loss + excess p.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **both outcomes**
  - *settled by the third pass:* S, in a different form, general: `above_iff` (l. 244), for plans `p q : KeepStop C` with `Splits listed weight p` and `Splits listed weight q` (section variables `listed`, `weight`, `gain`, `offGain`), states `(order listed gain offGain).Above q p ↔ q.loss + excess … q < p.loss + excess … p`; `not_above_iff` (l. 235) is its negation with `≤`; `reading_not_below_iff` (l. 253) and `reading_above_iff` (l. 262) the same against `held weight (reading gain offGain) a`; `excess_zero_iff` (l. 271) says when a plan has no excess. These are exact thresholds of which plan stands above which in an order of gain and loss; no course is said to go on or end, and nothing is said to be kept or lost by a process. [which pass was right: both in part; opened: `KeepStop` (l. 121), `gainOf` (l. 138), `order` (l. 143), `excess` (l. 148), `Splits` (l. 153), `goOn` (l. 156), `off` (l. 159), `held` (l. 163), `reading` (l. 168), `balance` (l. 228), `not_above_iff` (l. 235), `above_iff` (l. 244), `reading_not_below_iff` (l. 253), `reading_above_iff` (l. 262), `excess_zero_iff` (l. 271); section variables l. 131.]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: general exact thresholds in the order of plans, not of a course going on or ending. `above_iff` (l.244) and `not_above_iff` (l.235) between plans splitting the weights; `reading_not_below_iff` (l.253) and `reading_above_iff` (l.262) for holding against a plan; `excess_zero_iff` (l.271).
- **a comparison between two**
  - *pass a:* S: `above_iff_routes` (l. 370) transports the prospects order exactly to the plans on a single candidate; `move_le_of` (l. 306) gives gain monotonicity for weight moved to keeping when keeping gains at least as much everywhere listed.
  - *pass b:* S: `balance` (l.228): any two plans splitting the weights have equal gain plus excess. `le_iff_of_balance` (l.98) compares across that balance. `above_iff_routes` (l.370): RevisionRoutes' order on Prospects is the order of plans on one candidate under ofRoutes, so one order is carried into the other. `routes_above_iff` (l.393) gives the same with probabilities read in.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and docstrings. S for states, moves, reading, cost, comparison. N for share, level, giving, multiplying, no_return, both_outcomes, rank, closed_region, forms_change.
  - *pass b:* All statements and docstrings to l.454 read. 1, 2, 3, 7, 10 and 11 answered from statements. 4, 5, 6, 8, 9, 12, 13 and 14 are N.
