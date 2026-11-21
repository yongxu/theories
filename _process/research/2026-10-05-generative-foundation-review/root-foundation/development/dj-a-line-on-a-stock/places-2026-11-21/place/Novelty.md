# Novelty

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Novelty.lean`
- *result records that name this place's file as a source* (computed; not a link): `returning-novelty-forgetting-on-levels`, `what-keeping-widening-needs`, `where-novelty-gain-comes-from`
- *dynamics in the atlas that name one of those records* (computed; not a link): `closed-cycle-without-dissipation`, `kind-relay-keeps-widening-within-kinds`, `returning-novelty-forgetting-on-levels`, `what-keeping-widening-needs`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-11, as "Novelty.lean: revisits_of_bounded, unread_of_new_record, changes_le_stock" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-11.md.txt)); pass b: reader whole-b-41, as "Novelty.lean: Web.revisits_of_bounded, Web.exceeds_of_new, Web.unbounded_of_new, Web.unread_of_new_record, Flow.uncarried_of_bounded, Web.never_revisits_of_loses, Web.changes_le_stock, Web.rests_of_loses, first_law_cases, Web.counting" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-41.md.txt)); the third pass, where the two differed: reader whole-c-settle-15, as "Novelty.lean: settled fields both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-15.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Web.revisits_of_bounded` (l. 90) finds two equal family configurations arbitrarily late if natural-valued family stock remains bounded. With stock nonincreasing and strictly falling on changes, `Web.changes_le_stock` (l. 249) instead bounds the count of changes plus remaining stock by the starting stock.
  - *pass b:* On the levels of any web, with no flow, balance or finiteness of the world, it states the following. A family whose stock stays within a bound revisits a configuration and forgets (no reading of its configuration gives a never-repeating record or an unbounded count). Pairwise distinct configurations beyond the count of those within K force stock above K. A family whose stock never rises and falls at each change never revisits, changes at most its stock at T times, and stops changing. The laws are general; Entropy's first-law forms are derived as cases (`first_law_cases`), and `Web.counting` is a built web new at every step.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no process with a choice of moves; webs and flows are given.
- **a reading**
  - *pass a:* S: `Web.unread_of_new_record` (l. 208) precludes any function of the bounded family configuration from reading a record that differs at every pair of distinct times.
  - *pass b:* S: `Web.unread_of_new_record` (l. 208): where the stock stays within K from T, no `read` of the configuration gives at each step a record that never repeats. `Web.unread_of_unbounded` (l. 216): nor a count exceeding every bound. `Flow.uncarried_of_bounded` (l. 335): a bounded family exchanged with at arbitrarily late steps does not carry its history (¬ CarriesHistory). `World.forgets_of_bounded` (l. 350).
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no count or fraction of one kind among several.
- **a level that runs down**
  - *pass a:* S: `Web.changes_le_stock` (l. 249) bounds remaining family stock and the count of changes on a stretch under nonincrease and loss at each change. Replenishment is unspecified.
  - *pass b:* S: the family's stock `W.stock cs t`. `revisits_of_nonrising` (l. 97). `changes_le_stock` (l. 249): where from T the stock never rises and falls across every step at which the configuration changes, the stock at T+N plus the number of changes up to there is at most the stock at T. `Flow.Balances.bounded` (l. 319). N: no law in which what comes back depends on what is left.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no giver that is a going-on of the model; gainlessness and bounds are premises (`Balances.bounded`, l. 319; `bounded_counting_rest`, l. 327). D: the account (l. 53) reads gain without bound as coming from beyond the part.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no cost of keeping or giving. S (as a premise of changing, not keeping): `changes_le_stock` (l. 249) takes as premise that the family's own stock falls at each change of its configuration.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no units leaving units.
- **a point of no return**
  - *pass a:* S: `Web.never_revisits_of_loses` (l. 229) concludes no revisit after a change if stock never rises and falls at each change.
  - *pass b:* S: `never_revisits_of_loses` (l. 229) is concluded: with stock nonrising from T and falling across every change, the family never revisits a configuration. `rests_of_loses` (l. 284) is concluded: change does not recur at arbitrarily late steps. Both are at the level of the family's stock, not at the loss of something that gives.
- **both outcomes**
  - *settled by the third pass:* S, general, in the form of an exclusion: `Web.returns_of_bounded` (l. 106): where `W.stock cs t ≤ K` from T on and the configuration changes at arbitrarily late steps, `¬¬ W.Revisits cs T`; `first_law_cases` (l. 363) states, under `L.Balances W` and `GainlessOn` from T on, `¬ W.Revisits cs T → ¬ ∀ N, ∃ t, N ≤ t ∧ W.Changes cs t`. Returning or stopping is given only as 'not both changing without end and never revisiting', with no condition deciding which. `upto_or_fails` (l. 67) is a disjunction for a decided property up to N. [which pass was right: both in part; opened: upto_or_fails l. 67; revisits_of_bounded l. 90; returns_of_bounded l. 106; unbounded_of_never_revisits l. 198; never_revisits_of_loses l. 229; changes_le_stock l. 249; rests_of_loses l. 284; first_law_cases l. 363.]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S, general: `returns_of_bounded` (l. 106): a bounded family changing without end does not never-revisit. With `unbounded_of_never_revisits` (l. 198) and the conjunct of `first_law_cases` (l. 363) (balanced and gainless: ¬Revisits → change stops), this is the dichotomy of returning or stopping. `upto_or_fails` (l. 67) is a logical dichotomy on finite stretches.
- **a comparison between two**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no law carrying something between two processes or two starts. S (cases): `first_law_cases` (l. 363) obtains Entropy's Flow.Balances.recurs, rests_of_never_revisits and World.forgets from the level laws with the bound from `Flow.Balances.bounded` (l. 319). `bounded_counting_rest` (l. 327): with the rest counted (withImbalance), a gainless family stays within its stock at T.
- **a rank (an ending within a bound)**
  - *pass a:* S: `Web.changes_le_stock` (l. 249) bounds the number of changes, allowing arbitrarily many unchanged steps. `Web.rests_of_loses` (l. 284) negates arbitrarily late change under the same premises.
  - *pass b:* S: `changes_le_stock` (l. 249): the number of changes is bounded by the stock at T. `rests_of_loses` (l. 284). `exceeds_of_new` (l. 163): if the configurations at T…T+N are all different, N being the number of configurations totalling at most K, the stock exceeds K at one of those steps (a bounded wait).
- **a closed region**
  - *pass a:* S: `Flow.Balances.bounded` (l. 319) confines stock to its initial upper bound when the flow balances and the family is gainless from T onward.
  - *pass b:* S: `revisits_of_bounded` (l. 90): from T the configurations lie among configurationsWithin cs.length K, and so take one value at two steps from every M. `Flow.Balances.bounded` (l. 319): balanced and gainless from T, the stock stays within its value at T.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `Web.counting_new` (l. 301) has a distinct configuration at every step. `Web.counting` (l. 297) changes one condition’s level with no active formation.
  - *pass b:* S: `unbounded_of_new` (l. 186): a family whose configuration from T is new at every step exceeds every bound at arbitrarily late steps; `unbounded_of_distinct_configs` (l. 133); `exceeds_of_distinct_configs` (l. 117). B: `Web.counting` (l. 297), `counting_new` (l. 301), `counting_gains` (l. 306): a web whose level is the step is new at every step and exceeds every bound.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and the docstrings. General statements — states, reading, level, no_return, rank, closed_region. Built cases — forms_change. Not found — moves, share, giving, cost, multiplying, both_outcomes, comparison. No commentary-only answers. All questions were reached.
  - *pass b:* Every statement of the module was read, all 379 lines. 3, 5, 9, 10, 12, 13 and 14 are answered from statements, and 11 as cases; 6 is in part from the account; 2, 4, 7 and 8 were not found.
