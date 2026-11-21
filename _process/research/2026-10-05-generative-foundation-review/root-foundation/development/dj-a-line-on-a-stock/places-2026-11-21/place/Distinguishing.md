# Distinguishing

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Distinguishing.lean`
- *result records that name this place's file as a source* (computed; not a link): `identification-where-runs-part`, `tests-fix-likeness-where-determined`
- *dynamics in the atlas that name one of those records* (computed; not a link): `recurrence-without-premise`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-04, as "Distinguishing.lean: Law.sameTests_iff_within, Law.sameTests_iff_below_across, Law.agree_bisimulation, frameBy_across_exact" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-04.md.txt)); pass b: reader whole-b-13, as "Distinguishing.lean: Law.agree_bisimulation, Law.alike_iff_agree, Law.sameTests_iff_within, Law.sameTests_iff_below_across, Law.labelled, Law.alikeTo_labelled_iff, Law.realized_within, labelled_across_exact, frameBy_across_exact, frameBy_within_exact" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-13.md.txt)); the third pass, where the two differed: reader whole-c-settle-05, as "Distinguishing.lean: settled fields rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-05.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Law.sameTests_iff_within` (l. 86) equates passing the same tests in a determined law with agreement on observations at indices below N−1 when N listed configurations cover the world. Across two covered worlds the bound is N+N′−1 (`Law.sameTests_iff_below_across`, l. 98), and `frameBy_across_exact` (l. 222) exhibits failure one observation earlier for every pair of positive sizes.
  - *pass b:* General laws with no premise. Under a determined law read through a map, in a world of N listed configurations, two configurations pass the same tests exactly when their futures through the map agree for N-1 steps; across two worlds of N and N' configurations the bound is N+N'-1 steps; and two laws read through maps are alike exactly when their futures agree at every step. Every history with at most N states is the course of a law on N configurations. Built frames show the depths are exact.
- **moves**
  - *pass a:* S: `Law.labelled` (l. 119) gives each configuration one enabled move named by its current observation. `Law.alikeTo_labelled_iff` (l. 124) equates depth-k likeness with agreement of the first k observed values.
  - *pass b:* S: `Law.labelled` (l. 119): a Frame with a single move at each configuration, named by the map's value. `Law.alikeTo_labelled_iff` (l. 124): two such frames are alike to depth k iff the futures through the maps agree for k steps. There is no choice among several moves.
- **a reading**
  - *pass a:* S: `Law.sameTests_iff_within` (l. 86) makes the bounded observation prefix determine all test agreement under the listed-world hypothesis.
  - *pass b:* S: `Law.sameTests_iff_within` (l. 86): with `∀ s, s ∈ l`, SameTests (Law.frameBy next o) s s' iff o agrees along the two orbits for every n \< l.length - 1. `Law.sameTests_iff_below_across` (l. 98) gives the same across two worlds with bound l.length + l'.length - 1. `Law.alike_iff_agree` (l. 74): Alike iff agreement at every step. What the map registers decides likeness and the tests.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no exactly-when of going on and ending, or of keeping and losing. The iffs here are of likeness and tests.
- **a comparison between two**
  - *pass a:* S: `Law.agree_bisimulation` (l. 57) makes agreement at every observed orbit index a bisimulation between the two observed laws.
  - *pass b:* S: `Law.agree_bisimulation` (l. 57): agreeing at every step is a bisimulation between two laws read through maps. `Law.alike_iff_agree` (l. 74). `Law.sameTests_iff_below_across` (l. 98) carries tests between two worlds.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* N: `Law.sameTests_iff_below_across` (l. 98): for two laws read through maps, with lists `l`, `l'` holding every configuration, `SameTests` at s, s' exactly when the futures through the maps agree for every n \< l.length + l'.length - 1; `Law.sameTests_iff_within` (l. 86) the same within one world for n \< l.length - 1. A bound on the depth needed to tell apart, with nothing that falls and no ending. Opened to rule it out: sameTests_iff_within, sameTests_iff_below_across, realized_within, frameBy_within_exact, frameBy_across_exact. [which pass was right: b; opened: alike_iff_agree l. 74; sameTests_iff_within l. 86; sameTests_iff_below_across l. 98; realized_within l. 170; labelled_across_exact l. 196; frameBy_across_exact l. 222; frameBy_within_exact l. 245]
  - *pass a:* S: `Law.sameTests_iff_below_across` (l. 98) bounds the prefix needed to detect test inequivalence by the two covering list lengths minus one in total. This is a distinguishing horizon.
  - *pass b:* N: no law of ending within a bound. S, a bound of another kind: `Law.sameTests_iff_within` (l. 86) bounds the depth of distinguishing by N-1, and `frameBy_within_exact` (l. 245), `frameBy_across_exact` (l. 222) and `labelled_across_exact` (l. 196) show by built frames that the bounds N-1 and N+N'-1 are exact.
- **a closed region**
  - *pass a:* S: `Law.orbit_fin` (l. 162) identifies the orbit on Fin N with the natural-valued orbit when the map has every output below N. `Law.agree_bisimulation` (l. 57) gives closure of agreement under matched advances.
  - *pass b:* S: `Law.agree_bisimulation` (l. 57): the relation 'futures through the maps agree at every step' is a bisimulation, so it is closed under the steps of both laws.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found. `frameBy_within_exact` (l. 245) is built on a path of N places to a last one that stays, which is not a case of forms changing.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and its docstring. I used statements for states, moves, reading, comparison, rank, closed_region. I reached all fourteen questions.
  - *pass b:* All statements and docstrings read (l. 1-288). moves, reading, comparison and closed_region are answered from statements; rank is N with a different kind of bound from statements; the rest are N.
