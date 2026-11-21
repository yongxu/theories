# RoutesToC

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/RoutesToC.lean`
- *result records that name this place's file as a source* (computed; not a link): `what-would-give-c`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-17, as "RoutesToC.lean: widens_iff_noneWorseSomeBetter, pareto_increasing_iff_covers, Restraint.each_falls" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-17.md.txt)); pass b: reader whole-b-65, as "RoutesToC.lean: ReadsNoOrder.implies_comparison, comparison_listingFrame_iff, increasingInOwn_iff_comparison, reach, widens_iff_noneWorseSomeBetter, gains_every_widening_iff, not_lowered_of_no_bearing, Restraint, every_pareto_iff, pareto_increasing_iff_covers, increasing_iff_one_step, increasing_on_downstream" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-65.md.txt)); the third pass, where the two differed: reader whole-c-settle-25, as "RoutesToC.lean: settled fields cost" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-25.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: On a finite listed menu, widening is exactly weak improvement for all fixed item valuations with refusal and strict improvement for some (`widens_iff_noneWorseSomeBetter`, l. 379). With decidable item equality, every Pareto profile of self-concerned orders that ranks no widening below is increasing exactly when every listed item is someone’s own (`pareto_increasing_iff_covers`, l. 641).
  - *pass b:* General laws on the requirement C (`Comparison`) on an order. With help that reads no order, a premise that gives C implies C. On `listingFrame`, C is being increasing in admission, and with every item marked, self-concern is C. It also states choosers' reach and widening as what no chooser does worse from, Pareto relations of self-concerned standpoints (increasing exactly where every item is someone's own), one item at a time under transitivity, and self-concern on what lies downstream. Built witnesses (Refusing, AnotherReads, Restraint, EachItsOwn, OnlyMany, ZeroWeight, AboveNothing) mark where each route stops.
- **moves**
  - *pass a:* S: `not_lowered_of_no_bearing` (l. 541) compares mutual best choices in nested allowed menus: the first payoff cannot fall if it is independent of the other’s act. B: `Restraint.wide_best_iff` (l. 578) gives mutual taking as the only mutual best response in the wide menu.
  - *pass b:* S: `not_lowered_of_no_bearing` (l. 541): where no choice bears on what the other gets, at mutual best responses (`MutualBest`, l. 534) of a menu and of a wider one, the first chooser gets at least as much from the wider. B: `Restraint.wide_best_iff` (l. 578) and `each_falls` (l. 595): widening the menu by taking makes both taking the only mutual best response, and each gets 1 instead of 2. `listingFrame` (l. 202) takes any process, and C does not read it.
- **a reading**
  - *pass a:* S: `comparison_listingFrame_iff` (l. 219) equates Comparison on the frame reading listed admissions, counting every claim, with Increasing on those admissions. `ReadsNoOrder.implies_comparison` (l. 164) requires an order-reading premise if order-independent help already holds and the pair entails Comparison.
  - *pass b:* S: the marking `own`. `increasingInOwn_iff_comparison` (l. 228): where every listed item is marked, an order is self-concerned iff it meets C on listingFrame. `exists_selfConcerned_notBelow_not_increasing` (l. 674): at an unmarked listed item, some self-concerned order that ranks no widening below is not increasing. `increasing_on_downstream` (l. 936): where the class holds everything downstream and `own` marks what the line reaches, self-concern gives increasing in admission on that listing.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *settled by the third pass:* B: `Restraint.pays` (def, l.556) with `Restraint.wide_best_iff` (l.578): in the built two-act case, restraining pays 2 against restraint where taking pays 3, and 0 against taking where taking pays 1; `wide_best_iff` states `MutualBest pays wide x y ↔ x = true ∧ y = true`, so restraint is no best reply once taking is on the menu. `each_falls` (l.595): `pays true true < pays false false`. No general law; `reach_le_of_includes` (l.331) is of a chooser for whom leaving costs nothing. [which pass was right: a; opened: `Restraint.pays` (l.556), `narrow_best` (l.569), `wide_best_iff` (l.578), `each_falls` (l.595), `MutualBest` (l.534), `not_lowered_of_no_bearing` (l.541), `reach` (l.268), `reach_le_of_includes` (l.331), `reach_eq_of_refused` (l.338).]
  - *pass a:* B: `Restraint.pays` (l. 556) pays restraint 2 against restraint where taking would pay 3, and restraint 0 against taking where taking would pay 1. `each_falls` (l. 595) compares mutual taking with mutual restraint.
  - *pass b:* N for keeping or giving. D: `reach_le_of_includes` (l. 331) says in its docstring that reach, being a maximum, builds in that what a chooser leaves costs it nothing. B: `Restraint.each_falls` (l. 595): at the equilibrium of the wider menu, what each gets falls.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: its iff laws are about orders, not about going on and ending.
- **a comparison between two**
  - *pass a:* S: `reach_le_of_includes` (l. 331) carries any chooser’s attainable maximum upward under inclusion with valuation and refusal fixed.
  - *pass b:* S: `reach_le_of_includes` (l. 331): a course including another is never lower for any chooser. `widens_iff_noneWorseSomeBetter` (l. 379): a widens b iff no chooser does worse from a and some does better. `increasing_iff_ranks_noneWorseSomeBetter` (l. 403). `gains_every_widening_iff` (l. 412). `every_pareto_iff` (l. 626). `increasing_iff_one_step` (l. 770): a transitive order is increasing iff `StepAlike` holds and a given one-item widening is ranked.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `increasing_on_downstream_of_regularity` (l. 946) takes a class constant up to the net's end (`«本类至终有常»`) as a premise. No region law is stated here.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* S: `gains_every_widening_iff` (l. 412) characterizes when every widening strictly benefits some chooser in a supplied range: every listed item must be uniquely highest and above refusal for someone in range, with decidable item equality. Widening compares menus here.
  - *pass b:* S, as widening only: `extension_listingFrame_iff` (l. 206): on listingFrame, with every claim counted, an extension is a widening on the listing. `comparison_listingFrame_iff` (l. 219): C ranks every widening above what it widens. B: `Restraint.comparison_ranks_wide` (l. 600) ranks the wider menu above while what each gets falls. No going-on that continues while what is present changes.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and docstrings. S for states, moves, reading, comparison, forms_change. B for moves, cost. N for share, level, giving, multiplying, no_return, both_outcomes, rank, closed_region.
  - *pass b:* Mostly from statements (S, B, N); the cost note on reach is from a docstring (D). All statements were read (all 961 lines).
