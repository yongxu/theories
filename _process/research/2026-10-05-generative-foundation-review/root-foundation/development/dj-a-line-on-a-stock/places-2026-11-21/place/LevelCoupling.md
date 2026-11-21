# LevelCoupling

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/LevelCoupling.lean`
- *result records that name this place's file as a source* (computed; not a link): `what-dependence-alone-carries-of-a-level`, `where-a-level-couples`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-09, as "LevelCoupling.lean: crossing_passes_iff, carried_iff_rising, supply_not_carried, supply_carried_by_complement" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-09.md.txt)); pass b: reader whole-b-34, as "LevelCoupling.lean: ExchangeLaw.RespondsTo.couples, ExchangeLaw.Through.couples_of_respondsTo, ExchangeLaw.Through.not_respondsByLevel, not_not_obs_iff_respondsByLevel, crossing_passes_iff, ExchangeLaw.Through.rises_at_step, carried_iff_rising, supply_not_carried, Complement.carry, supply_carried_by_complement" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-34.md.txt)); the third pass, where the two differed: reader whole-c-settle-13, as "LevelCoupling.lean: settled fields both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-13.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `crossing_passes_iff` (l. 601) equates a positive requirement at T with existence of a law reading through coupling and responding to its crossing at every condition from T on, given decidable admission and condition and formation equality. `carried_iff_rising` (l. 904) characterizes bounded single-level giving responses representable by support-dependent threshold units as exactly the nondecreasing ones, assuming decidable condition equality.
  - *pass b:* S: General laws of what an exchange law reading only through a web's couplings (`ExchangeLaw.Through W obs part`) can respond to. A response is a positive strength for every strength array of the law (`ExchangeLaw.RespondsTo.couples`, l. 159). Only what couples in can respond (`ExchangeLaw.Through.couples_of_respondsTo`, l. 200). By threshold only a crossing of the need passes (`ExchangeLaw.Through.not_respondsByLevel`, l. 252; `crossing_passes_iff`, l. 601). Coupling by level is exactly where a response by level is possible (`not_not_obs_iff_respondsByLevel`, l. 314). Dependence alone carries of a level exactly what rises with it (`carried_iff_rising`, l. 904), so it carries no supply of a deficit (`supply_not_carried`, l. 1046), unless the level stands with a complement at a fixed total (`Complement.carry`, l. 1005). The built laws `levelLaw`, `thresholdLaw`, `admissionLaw`, `Layers` and `Complement` are the witnesses inside these iffs.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no `Process S A` with moves. The laws quantify over exchange laws and histories ('some law reading through its couplings', e.g. `crossing_passes_iff`, l. 601), not over choices of steps.
- **a reading**
  - *pass a:* S: `ExchangeLaw.Through.admission_changes_of_unobserved` (l. 478) shows that a positive exchange gap from varying just an unobserved level implies different admission at that step, no later than the exchange, for an outside formation under a law reading through its couplings.
  - *pass b:* S: what is registered (coupled in by threshold `W.DependsOn` or by level `obs`) decides what can respond. `ExchangeLaw.Through.respondsWithin_uncoupled` (l. 185): a level that couples in neither way is coupled with strength zero. `ExchangeLaw.Through.reads_of_respondsTo` (l. 207): a response is read in every schedule covering what couples in. `ExchangeLaw.Through.not_respondsByLevel` (l. 252): where `¬ obs h d`, no response by level. `ExchangeLaw.Through.crosses_of_unobserved` (l. 359): a response to an unobserved level is a crossing of its need. `not_not_obs_iff_respondsByLevel` (l. 314). `carried_iff_rising` (l. 904).
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* S: `supplyLaw` (l. 1028) gives k minus the current level for marked formations. `supply_carried_by_complement` (l. 1060) realizes that deficit via supported threshold units when two distinct levels sum to N. These compare histories at a step without iterating a stock-update rule.
  - *pass b:* S: levels (histories l : Nat → C → Nat) against needs (`W.need`) and admission (`W.Admits`). A response that depends on what is left: `supplyLaw` (l. 1028) gives what the level of d lacks of k. `supply_not_carried` (l. 1046): under dependence alone, no family each exchanging only where supported carries it over levels up to a positive bound. It passes by level (`supplyLaw_through`, l. 1033) and is carried with a complement at a fixed total (`supply_carried_by_complement`, l. 1060). N: no level runs down under a dynamic in this module; histories are handed in.
- **a giving that is itself a going-on**
  - *pass a:* S: `ExchangeLaw.NeedsSupportAt` (l. 656) requires a formation’s take and give to vanish under histories that no longer admit it. `Layers.law_needsSupport` (l. 798) and `Layers.carry` (l. 855) realize a nondecreasing bounded-domain giving response using such units. The index family is supplied.
  - *pass b:* S: what gives a response is a family of formations each exchanging only where supported (`ExchangeLaw.NeedsSupportAt`, l. 656; `ExchangeLaw.CarriesGiving`, l. 691). Not admitted by the levels at the step, such a unit takes and gives nothing. Built: `Layers.carry` (l. 855), units at thresholds, unit j+1 giving the rise at need j+1; `Complement.carry` (l. 1005). N: no law of these units being lost over time.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the carrying units take nothing (`Layers.law`, l. 779; `Complement.law`, l. 954). No cost to the giver.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *settled by the third pass:* N: `Complement.admitted_iff` (l.991) states, for naturals with `x + y = N` and `j ≤ N`, `(j ≤ x ∧ N - j ≤ y) ↔ j = x`; it names no process, web or step and is arithmetic of one unit's two thresholds. The other exactly-whens are of responding and carrying at one step: `crossing_passes_iff` (l.601: `W.requires T g d ∧ 0 < W.need T g d` iff some law `Through W obs part` responds by crossing from `T` on, given admission decided), `crossing_passes_of_support` (l.632), `carried_iff_rising` (l.904: a response is carried by some family through `thresholdOnly` iff it rises up to `N`). None is of going on and ending or of keeping and losing. [which pass was right: b; opened: Complement.admitted_iff l.991; Complement.admits_iff l.959; Complement.carry l.1005; crossing_passes_iff l.601; crossing_passes_of_support l.632; carried_iff_rising l.904; Layers.admits_iff l.785; ExchangeLaw.Through.carried_fall_needs_fall l.714; supply_not_carried l.1046; supply_carried_by_complement l.1060 (section variables l.650, l.769, l.880, l.944); signatures only for l.108-590]
  - *pass a:* S: `Complement.admitted_iff` (l. 991) characterizes whether the two thresholds of unit j are met. When x+y=N and j≤N, both are met exactly at j=x. This concerns support at one step.
  - *pass b:* N for going on and ending. The exactly-whens are of responding and carrying: `crossing_passes_iff` (l. 601), `crossing_passes_of_support` (l. 632), `carried_iff_rising` (l. 904), `not_not_obs_iff_respondsByLevel` (l. 314, double-negated).
- **a comparison between two**
  - *pass a:* S: `ExchangeLaw.Through.carried_rises` (l. 698) orders aggregate giving across histories equal before t and ordered in every level at t when both are in the specified domain and the outside carriers need support and read through thresholds alone.
  - *pass b:* S: an order between two histories is carried. `ExchangeLaw.Through.rises_at_step` (l. 667): under a law reading through dependence alone, a supported formation takes and gives no less where the levels at the step stand no lower (`NoLowerAt`, l. 660), the history before alike. `ExchangeLaw.Through.carried_rises` (l. 698): a carried response is no lower. `ExchangeLaw.Through.carried_fall_needs_fall` (l. 714): it falls only where some level at the step falls. `RespondsTo` (l. 110) compares two histories differing only in one level.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: Read the opening account, every declaration statement and its docstring where present. S for states, reading, level, giving, both_outcomes, comparison. N for moves, share, cost, multiplying, no_return, rank, closed_region, forms_change. No U fields.
  - *pass b:* S from statements: states, reading, level, giving and comparison; N for moves, share, cost, multiplying, no_return, both_outcomes, rank, closed_region and forms_change; no U. Read all statements and docstrings, ll. 1-1072; proof bodies at ll. 540-550 and 838-850 not read.
