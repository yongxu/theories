# BalanceRegions

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/BalanceRegions.lean`
- *result records that name this place's file as a source* (computed; not a link): `balance-from-conservation-along-a-relation`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-01, as "BalanceRegions.lean: balancing_iff_closures, balancing_iff_units_paired, closureListed_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-01.md.txt)); pass b: reader whole-b-02, as "BalanceRegions.lean: Continuity.adjacentListed, closes_iff_notGoingOut, balancing_iff_notGoingOut, closureListed, closureListed_iff, reachedListed_grows_or_stays, conservedOn_iff_closures, balancing_iff_closures, conservedOn_iff_units_paired, balancing_iff_units_paired, PathOfThree.counts_kept_not_along_step" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-02.md.txt)); the third pass, where the two differed: reader whole-c-settle-01, as "BalanceRegions.lean: settled fields moves, reading, no_return, both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-01.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* With decidable equality and distinct listed relata, balancing transfers exist exactly when each listed relatum's closure conserves its total (`balancing_iff_closures`, l. 433). Equivalently the before and after units pair one to one under that closure (`balancing_iff_units_paired`, l. 535).
  - *pass b:* The laws are general: for any Boolean relation on relata listed without repetition, with equality decided, transfers along the relation that balance a step exist exactly where the total is conserved on every region not gone out of along adjacency among the listed relata, equivalently on the closure of each listed relatum, equivalently where the units before and after are paired one to one under the closure. The same holds on a web at every step. The closure is decided by a finite test. PathOfThree is a built case showing that counts kept per closure do not give a pairing along one step.
- **moves**
  - *settled by the third pass:* S (different form): `balancing_iff_closures` (l.433): with `[DecidableEq R]` (section variable, l.232) and `Distinct us`, `(∃ move, Balancing rel us prev next move) ↔ ∀ a, a ∈ us → total us (within (closureListed rel us a) next) = total us (within (closureListed rel us a) prev)`. The quantified `move : R → R → Nat` is an assignment of transfers allowed only between adjacent listed relata (`Continuity.Balancing`), for one step from `prev` to `next`. There is no `Process S A`, no policy or plan, and no course of steps. [which pass was right: both in part; opened: balancing_iff_notGoingOut l.122, balancesOn_iff_notGoingOut l.137, balancing_iff_closures l.433, balancesOn_iff_closures l.444; Continuity.Balancing l.98]
  - *pass a:* S: `balancing_iff_closures` (l. 433) characterizes the existence of an allowed transfer assignment balancing the step by conservation on each listed closure, given decidable equality and distinctness. The choice is of amounts transferred.
  - *pass b:* N: no Process with a choice among steps. The transfers are an existence ∃ move, Balancing rel us prev next move (`balancing_iff_notGoingOut`, l.122; `balancing_iff_closures`, l.433), a flow, not a law about what a choice keeps.
- **a reading**
  - *settled by the third pass:* S (different form): `pairing_iff_closure_counts` (l.464): for `S` with `«则» S («逆» S)` and a test e deciding `«所闭» S`, `«对» («所闭» S) a b ↔ ∀ z, «计» (e z) a = «计» (e z) b`: the closure of a symmetric relation is a class, and the count in each class decides whether two lists pair. `closureListed_iff` (l.347), which pass a cites, says only that the Boolean test `closureListed rel us a x = true` holds exactly within `«所闭» (adjacentListed rel us) a x`: a decision of membership, not a reading. No observation and no rule made from what is registered is declared. [which pass was right: both in part; opened: closureListed_iff l.347, closureListed_closed l.328, closureListed_closes l.352, pairing_iff_closure_counts l.464, closes_iff_closed l.90, balancing_iff_notGoingOut l.122]
  - *pass a:* S: `closureListed_iff` (l. 347) says the Boolean closure test decides membership in the relational closure for decidable equality.
  - *pass b:* N: no observation or rule made from what is registered. Families are Boolean tests p : R → Bool. `pairing_iff_closure_counts` (l.464) treats the closure of a symmetric relation as a class: a pairing under it holds iff each class holds equally many entries of the two lists. That is a class law, not a law about registering.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: counts «计» of listed relata appear (`count_le_count`, l.157; `count_lt_count`, l.164), but no share among kinds and no rule set again from a count.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: there are levels prev, next : R → Nat and their totals, but the laws concern conservation and balance; nothing runs down.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `count_unitsOn` (l.485) counts a level's units (each relatum repeated as often as its level) as the total, with no law of a step changing their number.
- **a point of no return**
  - *settled by the third pass:* S (different form): `reachedListed_stays` (l.281): if `∀ x, reachedListed rel us a (k + 1) x = true → reachedListed rel us a k x = true`, then for every j and x what is reached within k + j steps is reached within k; `reachedListed_add` (l.267) says what is reached within n is reached within n + k. This is the iteration of a test coming to rest once and for all, concluded from a premise at one k. Nothing is lost, and it is not a course of a going-on. [which pass was right: both in part; opened: reachedListed l.236, reachedListed_add l.267, reachedListed_stays l.281, reachedListed_grows_or_stays l.300 (docstring and head), closureListed_closed l.328]
  - *pass a:* S: `reachedListed_stays` (l. 281) concludes no later expansion once a step reaches nothing new; this is stabilization of the reachability calculation.
  - *pass b:* N
- **both outcomes**
  - *settled by the third pass:* N: opened `balancing_iff_notGoingOut` (l.122): with `[DecidableEq R]` and `Distinct us`, `(∃ move, Balancing rel us prev next move) ↔ ∀ p : R → Bool, «不出» (adjacentListed rel us) (fun x => p x = true) → total us (within p next) = total us (within p prev)`; also `balancesOn_iff_notGoingOut` (l.137), `balancing_iff_closures` (l.433), `closes_iff_closed` (l.90). These are exact conditions for balancing transfers to exist, of one step; none is of going on and ending, or keeping and losing, of a course. [which pass was right: b; opened: closes_iff_closed l.90, closes_iff_notGoingOut l.102, closes_iff_notComingIn l.114, balancing_iff_notGoingOut l.122, balancesOn_iff_notGoingOut l.137, balancing_iff_closures l.433, balancesOn_iff_closures l.444]
  - *pass a:* S: `balancing_iff_notGoingOut` (l. 122) characterizes the possibility of balancing a step by conservation on every Boolean region with no exit, given distinctness and decidable equality.
  - *pass b:* N: the 'exactly where' laws concern whether balancing transfers exist and whether totals are conserved, not going on or ending, nor keeping or losing.
- **a comparison between two**
  - *pass a:* S: `count_le_count` (l. 157) carries pointwise inclusion of Boolean tests to count order on every list; `conservedOn_iff_units_paired` (l. 522) relates conservation to unit pairing across the step.
  - *pass b:* S: `conservedOn_iff_units_paired` (l.522): with equality decided, conservation on every family the relation closes ⇔ the units before are paired one to one with the units after under the closure «所闭» (adjacentListed rel us). `balancing_iff_units_paired` (l.535) and `balancesOn_iff_units_paired` (l.544). `closes_iff_notComingIn` (l.114): along the symmetric adjacency, not going out ⇔ not coming in.
- **a rank (an ending within a bound)**
  - *pass a:* S: `closureListed` (l. 245) and `closureListed_iff` (l. 347) identify full closure with reach within the list length, with decidable equality.
  - *pass b:* S: `reachedListed_grows_or_stays` (l.300): for each k, either some step i ≤ k reaches nothing new, or at least k more listed relata are reached within k steps than at the start. `reachedListed_stays` (l.281): once a step reaches nothing new, no later step does. Together with the list's length they bound the closure test at us.length steps (`closureListed`, l.245; `closureListed_closed`, l.328).
- **a closed region**
  - *pass a:* S: `closureListed_closed` (l. 328) proves closure under listed adjacency; `closureListed_inside` (l. 367) places it inside every closed test containing its start.
  - *pass b:* S: `closes_iff_closed` (l.90): a family the relation closes ⇔ a region «闭» under adjacentListed rel us. `closes_iff_notGoingOut` (l.102). `closureListed_closed` (l.328). `closureListed_iff` (l.347): the test holds exactly within the grammar's closure «所闭». `closureListed_inside` (l.367): a closed family holds the closure of each relatum it holds, so the closure is the least such family. These regions are closed under adjacency, not under the steps of a process.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* Read the opening account, all docstrings and all declaration statements. Statements support states and moves, reading, no_return, both_outcomes, comparison, rank, closed_region. The remaining fields are N. None were unreached.
  - *pass b:* All statements and docstrings (590 lines). All fields were answered from statements; none from the account alone, and none was left unreached.
