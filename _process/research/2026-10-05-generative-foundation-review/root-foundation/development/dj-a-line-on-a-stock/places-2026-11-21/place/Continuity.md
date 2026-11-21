# Continuity

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Continuity.lean`
- *result records that name this place's file as a source* (computed; not a link): `balance-from-conservation-along-a-relation`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-03, as "Continuity.lean: balancing_iff, conservedOn_of_law, balancesOn_of_law" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-03.md.txt)); pass b: reader whole-b-08, as "Continuity.lean: Closes, ConservedOn, Balancing, conserved_of_balancing, route_balancing, balancing_iff, ReadsAdjacent, conservedOn_of_law, balancesOn_iff_conserved, balancesOn_of_law, Teleport.no_transfers_apart" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-08.md.txt)); the third pass, where the two differed: reader whole-c-settle-03, as "Continuity.lean: settled fields level, cost, both_outcomes, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-03.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `balancing_iff` (l. 649) identifies existence of balancing transfers with conservation on every closed family of a distinct finite list, given decidable equality. `balancesOn_of_law` (l. 700) gives routed balance at each step of any run on that list when the law reads adjacent levels and conserves the total from every configuration.
  - *pass b:* General, over finitely many relata listed without repetition, any computable relation and whole-number levels. Transfers along the relation that balance a step exist exactly when the total is conserved on every family the relation closes (`balancing_iff`), and the routed transfers `route` are such. A law whose next level at each relatum reads only it and its adjacent relata, and which conserves the total from every configuration, conserves it on every closed family (`conservedOn_of_law`). The same is read on a Web (`balancesOn_iff_conserved`, `balances_of_conserved`, `balancesOn_of_law`), with a built control, Teleport.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no Process with moves. The `law` is a function from configurations to next levels.
- **a reading**
  - *pass a:* S: `ReadsAdjacent` (l. 185) requires agreement here and at listed neighbours to determine the same next level here. `conservedOn_of_law` (l. 197) uses this and total conservation from every start to give conservation on each closed family.
  - *pass b:* S: `ReadsAdjacent` (l.185) and `conservedOn_of_law` (l.197): what a law reads (only adjacent relata) decides that its global conservation is conservation on every closed family. B: `Teleport.no_transfers_apart` (l.749) and `Teleport.balanced_together` (l.754): the same swap law, which reads both relata, balances along the full relation and not along the empty one. This is a law's dependence, not an observation.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *settled by the third pass:* N: levels appear as `prev next : R → Nat` and `W.level`, and every statement about them is conservation or balance (`conserved_of_balancing` l. 159, `balancing_iff` l. 649, `Teleport.conserves` l. 732). `Teleport.swap` (l. 723) and `Teleport.unit` (l. 744) are definitions; no statement says a level runs down or that what comes back depends on what is left. Also opened: `Balancing` (l. 98), `no_transfers_apart` (l. 749), `balanced_together` (l. 754). [which pass was right: b; opened: Balancing l. 98; conserved_of_balancing l. 159; balancing_iff l. 649; Teleport.swap l. 723; Teleport.conserves l. 732; Teleport.unit l. 744; no_transfers_apart l. 749; balanced_together l. 754]
  - *pass a:* B: `Teleport.swap` (l. 723) takes the next level from the other site. On `Teleport.unit` (l. 744) one site falls from one to zero and receives the unit back on the second swap.
  - *pass b:* N: levels per relatum appear (`Balancing` l.98) but only their conservation and transfer; nothing runs down or comes back depending on what is left.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *settled by the third pass:* S, in a weaker form and in a definition only: `Balancing` (l. 98, variable `{R : Type}`) has as its third clause `∀ c, c ∈ us → next c + total us (move c) = prev c + total us (fun a => move a c)`: what a relatum sends is counted against its own level after the step. That is the amount transferred leaving the sender; no statement says a giver forgoes or spends anything further, and the opening account says a transfer may exceed what stands on its source. [which pass was right: both in part; opened: Balancing l. 98; flow l. 659; conserved_of_balancing l. 159; route_balancing l. 620]
  - *pass a:* S: `Balancing` (l. 98) charges every transfer sent against the sender's previous level plus receipts in the same step. It requires no bound by the previous level alone.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *settled by the third pass:* N for going on and ending or keeping and losing. S of another thing: `balancing_iff` (l. 649), premise `Distinct us`, with `rel : R → R → Bool` and `prev next : R → Nat`, states `(∃ move, Balancing rel us prev next move) ↔ ConservedOn rel us prev next`: balancing transfers for one step exist exactly where the total is conserved on every closed family. `balancesOn_iff_conserved` (l. 672) is the same on a web. Both passes describe the statement alike. [which pass was right: b; opened: balancing_iff l. 649; balancesOn_iff_conserved l. 672; route_balancing l. 620]
  - *pass a:* S: `balancing_iff` (l. 649) gives both outcomes for existence of balancing transfers for a prescribed step between two configurations on a distinct list with decidable equality. This is a feasibility criterion for a step, rather than a survival criterion for a formation.
  - *pass b:* N for going on and ending. S: `balancing_iff` (l.649) is an exactly-when, between balance and conservation on closed families.
- **a comparison between two**
  - *pass a:* S: `conservedOn_rest` (l. 517) carries conservation from a distinct list to the list without its head, joining neighbours of the head and adjusting levels for its exchange.
  - *pass b:* S: `balancing_iff` (l.649) carries a step between two descriptions, transfers along the relation and conservation on closed families. `conservedOn_rest` (l.517): conservation on x :: rest carries to rest under the relation `joined rel x`. B: Teleport (l.714-758) compares the empty and the full relation for one law.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* S: `conservedOn_of_law` (l. 197) preserves the total on each adjacency-closed family under a law reading adjacent levels and conserving the global total at every configuration. Thus configurations with a given such total stay at that total.
  - *pass b:* S: `Closes` (l.88) is a family closed under the relation (adjacent listed relata both in or both out). `conserved_of_balancing` (l.159) and `conservedOn_of_law` (l.197): the total is conserved on every such family. `kept_alone` (l.586): a relatum adjacent to none keeps its level. The closure is under the relation, not under steps in time.
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* N: `Teleport.conserves` (l. 732) states `Conserves all swap`, i.e. `∀ a, total all (swap a) = total all a`; it says the total is kept and does not say what is present changes. That the unit moves is in the definitions `swap` (l. 723) and `unit` (l. 744) and in the docstring of `no_transfers_apart` (l. 749), whose statement is `¬ ∃ move, Balancing apart all unit (swap unit) move`. No run, relay or alternation is stated. Opened also: `reads` (l. 737), `balanced_together` (l. 754). [which pass was right: b; opened: Teleport.swap l. 723; Teleport.conserves l. 732; Teleport.reads l. 737; Teleport.unit l. 744; no_transfers_apart l. 749; balanced_together l. 754]
  - *pass a:* B: `Teleport.conserves` (l. 732) preserves the total under `swap` even for `unit` (l. 744), whose occupied site changes.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statements (1, 3, 7, 10, 11, 13). Built cases (5, 14). Not found (2, 4, 6, 8, 9, 12). I reached all fourteen questions.
  - *pass b:* All 14 questions were answered from statements or built cases. I read all statements, l.1-762.
