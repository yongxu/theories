# HexagramCommuting

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HexagramCommuting.lean`
- *result records that name this place's file as a source* (computed; not a link): `hexagram-world-laws`, `what-a-commuting-law-keeps-apart`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-map-moving-every-value-never-rests`, `what-a-commuting-law-keeps-apart`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-07, as "HexagramCommuting.lean: waxWane_apart, waxWane_halfway, changes_mirror_apart" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-07.md.txt)); pass b: reader whole-b-24, as "HexagramCommuting.lean: complement_moves, waxWane_apart, waxWane_halfway, wane_breaks, changes_symmetric, changes_mirror_apart" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-24.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* B: `Hexagram.waxWane_apart` (l. 39) keeps complementary starts apart at every common time under waxing and waning, and `waxWane_halfway` (l. 44) gives complement after six more steps and return at twelve. `wane_breaks` (l. 50) concludes that the particular waning law fails to commute with complement.
  - *pass b:* Built instances, on the 64 hexagrams of Becoming.Hexagrams, of the general commuting laws of Becoming.Commuting at the complement (錯): the complement moves every hexagram, waxing and waning commutes with it so runs from a hexagram and its complement never meet and are paired halfway round a return of twelve, the waning law breaks the symmetry, and the change of one line is symmetric so every course has a complementary course never at the same hexagram. All of one built model.
- **moves**
  - *pass a:* B: `Hexagram.flip_complement` (l. 55) commutes the flip at any chosen place with complement, and `changes_symmetric` (l. 64) gives symmetry of the one-line change process.
  - *pass b:* B: `changes_symmetric` (l. 64): `Branching.Symmetric changes complement`, the process of changing one line (a choice of place k) is symmetric under the complement; `changes_mirror_apart` (l. 68): every run r of `changes` has a mirror run never at the same hexagram at any step n.
- **a reading**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
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
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* B: `Hexagram.waxWane_apart` (l. 39) concludes that synchronously iterating waxWane from a figure and its complement can never merge the two. This is an unreachable diagonal for that pair of starts.
  - *pass b:* B: `wane_breaks` (l. 50) states `¬ Law.Commutes wane complement`; its proof uses `wane_six` (in Becoming.Hexagrams) that six steps of waning bring allBroken and its complement to one. The drawing into all broken is not itself stated in this module.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a comparison between two**
  - *pass a:* B: `Hexagram.changes_mirror_apart` (l. 68) gives a complementary run for every run of changes, whose state differs from the original at every common time.
  - *pass b:* B: `waxWane_apart` (l. 39): for every s and n, the run of waxWane from complement s is never at the state of the run from s (instance of `Law.Commutes.apart`); `waxWane_halfway` (l. 44): state 6 + n is the complement of state n and state 12 is s (instance of `Law.Commutes.paired_halfway`); `changes_mirror_apart` (l. 68) (instance of `Branching.mirror_apart`); `flip_complement` (l. 55).
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* B: `Hexagram.waxWane_apart` (l. 39) keeps the pair of synchronously evolving complementary starts off the diagonal at every time.
  - *pass b:* B: `waxWane_halfway` (l. 44): every run of waxWane returns to its start at step 12, a cycle.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `Hexagram.waxWane_halfway` (l. 44) gives the complement six steps after every moment and the starting figure at twelve, and `complement_moves` (l. 35) says complementation changes every figure.
  - *pass b:* B: `waxWane_halfway` (l. 44): along every run the hexagram goes to its complement at step 6 and back at 12, the law going on while the configuration alternates.
- **how it was read**
  - *pass a:* S: I read the opening account, all statements and their docstrings. Built cases cover states, moves, no_return, comparison, closed_region, forms_change. I found no matching claim for reading, share, level, giving, cost, multiplying, both_outcomes, rank. I reached all fourteen questions.
  - *pass b:* All statements, docstrings and proofs read (74 lines); moves, no_return, comparison, closed_region, forms_change from built instances; the rest not found.
