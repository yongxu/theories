# HexagramLaws

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HexagramLaws.lean`
- *result records that name this place's file as a source* (computed; not a link): `hexagram-arrangements-and-laws`, `hexagram-world-laws`
- *dynamics in the atlas that name one of those records* (computed; not a link): `waxing-and-waning-returns`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-07, as "HexagramLaws.lean: returns_iff_attractor, nuclear_two_fixed_one_cycle, MarkedLines.returns_iff, addOne_one_orbit, orbit_census" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-07.md.txt)); pass b: reader whole-b-24, as "HexagramLaws.lean: nuclear, nuclear_loses, NuclearAttractor, attractor_absorbing, returns_iff_attractor, basin_counts, Symmetry, classes_goAlike, MarkedLines.returns_iff, addOne_one_orbit, changesAround_invariant, orbit_census" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-24.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* B: `returns_iff_attractor` (l. 327) identifies the four returning figures of the nuclear law, and `MarkedLines.returns_iff` (l. 889) identifies the returning marked figures as exactly those without turning lines. `addOne_one_orbit` (l. 1075) gives a single orbit of 64 for the counter, while `orbit_census` (l. 1311) counts six orbits for waxing and waning.
  - *pass b:* Finite computations on the 64 hexagrams of one built model: the nuclear law (互) merges, loses a possibility for good and draws every configuration within two steps into an absorbing region of four (乾, 坤 fixed; 既濟, 未濟 alternating), with basins told by lines 3 and 4; the four symmetries form a group the nuclear law commutes with, giving twenty classes. Also the law of turning lines (MarkedLines.settle, settled in one step), the counter adding one (one orbit of 64), and the six orbits of waxing and waning kept apart by the invariant changesAround; all are built instances of spine laws (Law.Drawn.not_returns, Learning.goAlike_iff_lumped, Invariant.reach).
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: every law here is a deterministic function Hexagram → Hexagram (or MarkedLines → MarkedLines) read as `Law.process`; no choice among steps and no law of what a choice keeps was found.
- **a reading**
  - *pass a:* B: `run_two_middle` (l. 187) gives identical nuclear runs from step two if the two middle lines agree. `nuclear_yang_not_lumped` (l. 217) says the unbroken-line count fails to determine its own next value.
  - *pass b:* B: lumpings a law goes alike across, a class read alike deciding the next class: `innerPair_lumped`/`innerPair_goAlike` (l. 208, l. 212), `classes_lumped`/`classes_goAlike` (l. 649, l. 655), `MarkedLines.onward_goAlike` (l. 919), `orbitIndex_goAlike` (l. 1296); and readings it does not go alike across: `nuclear_yang_not_goAlike` (l. 221), `classes_not_goAlike_waxWane` (l. 663), `MarkedLines.shown_not_goAlike` (l. 911).
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the counts (`entry_counts` l. 371, `basin_counts` l. 440, `class_census` l. 640, `changesAround_counts` l. 1192) are censuses over the received order; nothing is set again from them.
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
  - *pass a:* N: `nuclear` (l. 137) copies some inner line values into multiple places on a fixed six-place carrier. I found no law of reproduction of units or formation of new kinds.
  - *pass b:* N
- **a point of no return**
  - *pass a:* B: `outside_not_returns` (l. 322) concludes nonreturn under the nuclear law from every start outside `NuclearAttractor`. `MarkedLines.returns_iff` (l. 889) excludes return from a start with a turning line.
  - *pass b:* B: `nuclear_loses` (l. 167): `¬ Branching.KeepsPossibilities (Law.process nuclear)`, a possibility lost for good (by `Law.Merges.loses`); `outside_not_returns` (l. 322): a configuration outside the attractor never returns (by `Law.Drawn.not_returns`); `MarkedLines.returns_iff` (l. 889). Concluded, in the built model, at the level of configurations, not of a level or a giver.
- **both outcomes**
  - *pass a:* B: `returns_iff_attractor` (l. 327) gives return exactly on the four-figure attractor for one law. `nuclear_rests_iff` (l. 296) gives perpetual retention of the starting figure exactly at all unbroken or all broken.
  - *pass b:* B: `returns_iff_attractor` (l. 327): a hexagram returns under the nuclear law exactly when it is in the attractor (others are drawn in); `nuclear_rests_iff` (l. 296); `MarkedLines.returns_iff` (l. 889): returns exactly where no line turns; `process_returns_iff_ends` (l. 340).
- **a comparison between two**
  - *pass a:* B: `nuclear_run_act` (l. 542) carries any nuclear run to the run from its transformed start under each of the four symmetries.
  - *pass b:* B: `nuclear_run_act` (l. 542): each symmetry takes every run of the nuclear law to a run of it (by `Law.Commutes.iterate`); `run_complement_apart` (l. 549); `run_inner` (l. 152): two runs whose starts agree in lines 2 to 5 are one run from step 1; `run_two_middle` (l. 187): agreeing in lines 3 and 4, one run from step 2; `reach_keeps_orbit` (l. 1304).
- **a rank (an ending within a bound)**
  - *pass a:* B: `run_in_attractor` (l. 365) gives entry by step two from every nuclear start, with 4 already inside, 12 first entering at step one and 48 still outside at one by `entry_counts` (l. 371). `MarkedLines.run_settled` (l. 873) gives settlement by step one.
  - *pass b:* B: `nuclear_two_attractor` (l. 259) and `run_in_attractor` (l. 365): within two steps every configuration is in the attractor; `MarkedLines.run_settled` (l. 873): settled from step 1; `addOne_first_return` (l. 1069) no return before step 64. No falling variant.
- **a closed region**
  - *pass a:* B: `attractor_absorbing` (l. 302) gives closure for the four nuclear figures. `orbitIndex_invariant` (l. 1299) gives a separate invariant for each waxWane orbit index.
  - *pass b:* B: `attractor_absorbing` (l. 302): `Law.Absorbing nuclear NuclearAttractor`; `nuclear_fixed_iff` (l. 285): fixed points 乾, 坤 only; `changesAround_invariant` (l. 1172) and `orbitIndex_invariant` (l. 1299): invariants of waxWane; `qian_not_reach_jiJi` (l. 1199).
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `nuclear_two_fixed_one_cycle` (l. 273) exhibits a run at 既濟 at every even step and the distinct 未濟 at every odd step, alongside two fixed runs.
  - *pass b:* B: `nuclear_two_fixed_one_cycle` (l. 273): the run from 既濟 alternates 既濟/未濟 at every step; `addOne_one_orbit` (l. 1075): one orbit of 64, every configuration had in turn; `line_turns` (l. 1140); `starts_return` (l. 1258). No widening: the counter and waxWane are lossless, the nuclear law and settle lose.
- **how it was read**
  - *pass a:* S: I read the opening account, all statements and their docstrings. Built cases cover states, reading, no_return, both_outcomes, comparison, rank, closed_region, forms_change. I found no matching claim for moves, share, level, giving, cost, multiplying. I reached all fourteen questions.
  - *pass b:* All statements and docstrings read, lines 1 to 1321; reading, no_return, both_outcomes, comparison, rank, closed_region, forms_change from built cases only; moves, share, level, giving, cost, multiplying not found.

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge-11

*As "HexagramLaws.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge-11.md.txt).*

- **an exact statement of both outcomes**: B: `returns_iff_attractor` (l.327): for every `s : Hexagram`, `Law.Returns nuclear s ↔ NuclearAttractor s`, no premise, no section variable; of the one built law `nuclear`. Its halves are `attractor_returns` (l.310) and `outside_not_returns` (l.322). A second built edge: `MarkedLines.returns_iff` (l.889): `Law.Returns settle m ↔ staysAll m = true`. Also `nuclear_rests_iff` (l.296): `(∀ n, (Law.run nuclear s).state n = s) ↔ s = allUnbroken ∨ s = allBroken`.
- **the side that keeps**: `attractor_absorbing` (l.302): `Law.Absorbing nuclear NuclearAttractor` (the four configurations 乾, 坤, 既濟, 未濟 are never left); `run_in_attractor` (l.365). For `settle` there is no named closure theorem: `staysAll_settle` (l.829) states `staysAll (settle m) = true` for every m and `settle_fixed_iff` (l.838) gives the fixed points as exactly those with `staysAll`.
- **the side that ends**: A fixed deadline, nothing falls: `outside_drawn` (l.317) concludes `Law.DrawnInto nuclear NuclearAttractor s` from `¬ NuclearAttractor s`, with `nuclear_two_attractor` (l.259): `NuclearAttractor (Law.orbit nuclear s 2)` for every s; `entry_counts` (l.371) 4/12/48. For `settle`: `MarkedLines.drawn` (l.883) and `run_settled` (l.873), one step. What ends is the start's being had again (`outside_not_returns`); the run itself goes on in the attractor.
- **moves in that statement**: N: `nuclear : Hexagram → Hexagram` and `settle : MarkedLines → MarkedLines` are functions; read as `Law.process next : Process S Unit` (Recurrence l.143) there is one step from each configuration. No statement of the module quantifies over a move, plan or allowed set.
- **a reading in that statement**: N for the edge statements: the conditions `NuclearAttractor s` and `staysAll m = true` are on the configuration itself. Beside them, B: `basin_iff` (l.390) `(Law.run nuclear s).state 2 = thrice p ↔ innerPair s = p`, with `qian_basin`, `kun_basin`, `cycle_basin` (ll.406, 416, 426): where the course rests is exactly told by lines 3 and 4, which `innerPair_goAlike` (l.212) states is a lumping `GoAlike (Law.process nuclear) innerPair`; but all three outcomes lie inside the closed region.
- **the carrier**: A law `Hexagram → Hexagram` (`nuclear`) under `Law.Returns`, `Law.Absorbing`, `Law.DrawnInto`, `Law.run`; as `Law.process nuclear : Process Hexagram Unit` in `nuclear_process_returns_iff` (l.334). Likewise `settle : MarkedLines → MarkedLines`.
- **what is handed in**: None of the six is in the statement: no level, giving, share, favouring, reading or turn. The law is a defined function; the condition, the closure and the two-step (one-step) deadline are all concluded, by computation over the configurations.
- **links to other modules**: (1) `nuclear_process_returns_iff` (l.334) and `MarkedLines.process_returns_iff` (l.897): `Branching.Returns (Law.process …) … ↔ …`, the edge read on the spine's process. (2) `attractor_absorbing` (l.302), `outside_drawn` (l.317), `MarkedLines.drawn` (l.883): instances of Attraction's `Law.Absorbing`, `Law.DrawnInto`. (3) `innerPair_goAlike` (l.212), `classes_goAlike` (l.655), `MarkedLines.onward_goAlike` (l.919), `orbitIndex_goAlike` (l.1296): instances of `GoAlike`, with `Learning.Lumped` in the `_lumped` twins; `nuclear_yang_not_goAlike` (l.221), `classes_not_goAlike_waxWane` (l.663), `MarkedLines.shown_not_goAlike` (l.911) its negations. (4) `changesAround_invariant` (l.1172), `orbitIndex_invariant` (l.1299): `Invariant (Law.process waxWane) (…)`; `qian_not_reach_jiJi` (l.1199): `¬ Reach (Law.process waxWane) allUnbroken jiJi`. (5) `nuclear_loses` (l.167): `¬ Branching.KeepsPossibilities (Law.process nuclear)`; `addOne_one_orbit` (l.1075): `Branching.Lossless (Law.process addOne) ∧ ∀ s t, Reach …`; `process_returns_iff_ends` (l.340) names Hexagrams' `order`.
- **standing**: The opening account says "No ethical predicate, ranking or axiom occurs." None seen in the statements.
- **note**: The edge is here twice, each time a closed region against a fixed deadline on a function with no moves and no reading, in a built case; on both sides the run goes on for ever, and the far side loses only the return to the start. For `settle` the statement `shown_not_goAlike` (l.911) says only that the hexagram shown is not a lumping the law goes alike across; it does not state that `shown` fails to tell `staysAll`.
