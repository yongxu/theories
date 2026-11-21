# Hexagrams

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Hexagrams.lean`
- *result records that name this place's file as a source* (computed; not a link): `fixed-places-and-sole-lines`, `hexagram-arrangements-and-laws`, `hexagram-world-laws`, `hexagrams-on-the-spine`, `place-relations-in-context`, `what-a-commuting-law-keeps-apart`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-map-moving-every-value-never-rests`, `waxing-and-waning-returns`, `what-a-commuting-law-keeps-apart`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-07, as "Hexagrams.lean: changes_keeps, every_returns_iff, wane_six, arising_recurs, ceasing_recurs" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-07.md.txt)); pass b: reader whole-b-26, as "Hexagrams.lean: changes, waxWane, wane, every_returns_iff, wane_never_back, arising_recurs, pairs_goAlike" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-26.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `every_returns_iff` (l. 565) gives return of every configuration exactly when the process of a deterministic hexagram law is lossless. B: `changes_keeps` (l. 342) gives a branching line-flip process that keeps all possibilities despite merging, and `wane_drawn` (l. 539) gives a deterministic law drawing every other figure into all broken.
  - *pass b:* The module builds one world, the 64 six-line configurations. Two processes act on it: `changes`, which flips one line and returns, reaches every configuration and merges while keeping every possibility, and the law `waxWane`, which is lossless, returns everything, gives the complement after six steps and the start again after twelve. Its counterpart `wane` merges, draws everything into all broken and loses a possibility. All of this is built, as instances of general laws stated in other modules; `every_returns_iff` is stated for every law on this one world.
- **moves**
  - *pass a:* B: `changes` (l. 327) allows a flip at any chosen place, `flip_flip` (l. 312) restores the figure by repeating that choice, and `reach_every` (l. 363) gives reachability between every pair.
  - *pass b:* S: `changes` (l. 327) is a `Process Hexagram Place`, a choice of which place to flip. `changes_keeps` (l. 342): it keeps every possibility (`KeepsPossibilities`) and is not `Lossless`. `reach_every` (l. 363): every configuration reaches every other. `revisits_within_order` (l. 726): for every process on hexagrams, every run revisits a configuration within 64 steps. `changes_run_revisits` (l. 379): every run of `changes` revisits from every step on.
- **a reading**
  - *pass a:* B: `pairs_lumped` (l. 617) says the current complement pair determines the next pair under waxWane, while `yang_not_lumped` (l. 637) rules this out for the unbroken-line count.
  - *pass b:* S: `pairs_lumped` and `pairs_goAlike` (l. 617, l. 628): the lumping `pairOf`, a hexagram together with its complement, is one that `waxWane` goes alike across. `yang_not_lumped` and `yang_not_goAlike` (l. 637, l. 640): the count of unbroken lines is not such a lumping. `lines` (l. 647) is a Frame whose claim at a place is realized where that line is unbroken. These are of the built world.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `yang` (l. 632) counts the unbroken lines, but no rule is set again from that count.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
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
  - *pass a:* B: `wane_not_returns` (l. 549) concludes nonreturn for every start other than all broken, and `wane_loses` (l. 555) concludes failure to keep all possibilities under the same law.
  - *pass b:* B: `allBroken_absorbing` (l. 533): `wane` never leaves all broken. `wane_never_back` (l. 544): for every s other than all broken, the state at step 6 + k is never s. `wane_not_returns` (l. 549) and `wane_loses` (l. 555): a possibility is lost for good. These are concluded in the built law `wane`. The loss is of a configuration, not of something that gives.
- **both outcomes**
  - *pass a:* S: `every_returns_iff` (l. 565) gives the criterion for universal return for all deterministic laws on this finite carrier. B: `allBroken_absorbing` (l. 533) and `wane_not_returns` (l. 549) distinguish the retained state from every other start of wane.
  - *pass b:* S: `every_returns_iff` (l. 565): for every law `next` on hexagrams, every configuration returns exactly when the law's process is lossless. It is general over laws but on this one built world. B: `waxWane_returns` (l. 405) against `wane_not_returns` (l. 549).
- **a comparison between two**
  - *pass a:* B: `reverse_waxWane` (l. 583) takes every forward run step, under reversal of the figure, to a step of the backward law.
  - *pass b:* B: `waxWane_complement` (l. 575): the law commutes with the complement. `reverse_waxWane` (l. 583): turning a state over makes each step one of the backward law `unwaxWane`. `pairs_lumped` (l. 617): the law is carried across the pairs of complements.
- **a rank (an ending within a bound)**
  - *pass a:* B: `wane_six` (l. 529) puts every start at all broken at time six. S: `revisits_within_order` (l. 726) bounds the first repeated state by index 64 for any run on hexagrams.
  - *pass b:* B: `wane_six` (l. 529): after six steps every configuration is all broken, a fixed deadline. `six_steps` (l. 413), `twelve_steps` (l. 422) and `first_return` (l. 495) are exact periods. No falling variant is stated.
- **a closed region**
  - *pass a:* B: `allBroken_absorbing` (l. 533) says the singleton all broken is closed under wane.
  - *pass b:* B: `allBroken_absorbing` (l. 533): all broken is an absorbing region of `wane`. `wane_drawn` (l. 539): every other configuration is drawn into it.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `world_arising_recurs` (l. 712) and `world_ceasing_recurs` (l. 717) give recurrent arising and ceasing among the six places in every waxWane run. `twelve_steps` (l. 422) restores each figure twelve steps later.
  - *pass b:* B: `arising_recurs` (l. 678) and `ceasing_recurs` (l. 704): along every run of `waxWane`, a line comes to be unbroken, and ceases to be, at arbitrarily late steps. `world_arising_recurs` and `world_ceasing_recurs` (l. 712, l. 717): read as a world, the places arise and cease at arbitrarily late steps. `waxing` and `waning` (l. 466, l. 478) are the rise of unbroken lines and then of broken ones. `kept_history_unlisted` (l. 731): the law with its history kept is held by no list.
- **how it was read**
  - *pass a:* S: I read the opening account, all statements and their docstrings. General statements cover states, both_outcomes, rank. Built cases cover states, moves, reading, no_return, both_outcomes, comparison, rank, closed_region, forms_change. I found no matching claim for share, level, giving, cost, multiplying. I reached all fourteen questions.
  - *pass b:* All 14 answered from statements; all statements read, lines 1-737.

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge-11

*As "Hexagrams.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge-11.md.txt).*

- **an exact statement of both outcomes**: S: `every_returns_iff` (l.565): for every `next : Hexagram → Hexagram`, `(∀ s, Branching.Returns (Law.process next) s) ↔ Branching.Lossless (Law.process next)`; no other premise, no section variable. It is general over laws on this one carrier and is an edge on the law (merges nothing or not), not on a start. B: for the built law `wane` the edge by start is two halves and not one iff: `allBroken_absorbing` (l.533) against, for `s ≠ allBroken`, `wane_drawn` (l.539), `wane_never_back` (l.544) and `wane_not_returns` (l.549). That all broken returns under `wane` is not stated.
- **the side that keeps**: For `wane`: `allBroken_absorbing` (l.533): `Law.Absorbing wane (fun s => s = allBroken)`, a one-configuration region the law never leaves. In `every_returns_iff` the statement only asserts returning of every configuration; no region.
- **the side that ends**: A fixed deadline, nothing falls: `wane_six` (l.529): `∀ s, (Law.run wane s).state 6 = allBroken`; `wane_never_back` (l.544): for `s ≠ allBroken`, `∀ k, (Law.run wane s).state (6 + k) ≠ s`. `revisits_within_order` (l.726) is a bound for every `Process Hexagram A` and every `Run P` (a repeat by step 64), but of revisiting, not of ending.
- **moves in that statement**: N in the edge statements: `every_returns_iff` quantifies over every law `next`, a function handed in whole; `Law.process next` has action type `Unit`. The module does have a process with moves, `changes : Process Hexagram Place` (l.327), but with one outcome only: `changes_keeps` (l.342) `Branching.KeepsPossibilities changes ∧ ¬ Branching.Lossless changes`, `reach_every` (l.363).
- **a reading in that statement**: N: the conditions are `Branching.Lossless` of the law and `s = allBroken`. The readings of the module (`pairs_goAlike` l.628, `yang_not_goAlike` l.640, `lines : Frame Hexagram Unit Place` l.647) are of `waxWane`, of which only one outcome is stated (`waxWane_returns`, l.405).
- **the carrier**: A law `Hexagram → Hexagram` under `Law.process` (`Process Hexagram Unit`), `Law.run`, `Law.Absorbing`, `Law.DrawnInto`; `changes : Process Hexagram Place` for the one process with moves.
- **what is handed in**: None of the six appears: no level, giving, share, favouring, reading or turn. For `wane` the closure, the six-step deadline and the non-return are concluded by computation from its definition; in `every_returns_iff` the law is universally quantified and nothing is handed in.
- **links to other modules**: (1) `every_returns_iff` (l.565): names `Branching.Returns`, `Branching.Lossless`, `Law.process`; by its docstring and proof the carrier's instance of `Law.lossless_iff_returns` with `mem_order`. (2) `allBroken_absorbing` (l.533), `wane_drawn` (l.539): instances of `Law.Absorbing`, `Law.DrawnInto`; `wane_not_returns` (l.549): `¬ Branching.Returns (Law.process wane) s`; `wane_loses` (l.555): `¬ Branching.KeepsPossibilities (Law.process wane)`. (3) `changes_keeps` (l.342): `Branching.KeepsPossibilities changes ∧ ¬ Branching.Lossless changes`. (4) `pairs_goAlike` (l.628): `GoAlike (Law.process waxWane) pairOf`; `pairs_lumped` (l.617): `Learning.Lumped pairOf …`. (5) `arising_recurs` (l.678), `ceasing_recurs` (l.704): `Recurs places (… ComesToBe / CeasesToBe … lines.realized …)`; `world_arising_recurs` (l.712) names `(lines.world …).web.Arises`; `kept_history_unlisted` (l.731) names `Law.withHistory`.
- **standing**: The opening account says "No ethical predicate, ranking or axiom occurs." None seen in the statements.
- **note**: The three things are on three different laws: moves on `changes` (everything kept, no edge), readings on `waxWane` (everything returns, no edge), and the two sides on `wane` (a function, no moves, no reading). The one iff is on the law, with no region and no bound in it.
