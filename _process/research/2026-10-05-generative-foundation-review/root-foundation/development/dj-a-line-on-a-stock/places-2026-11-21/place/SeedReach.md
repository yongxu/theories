# SeedReach

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/SeedReach.lean`
- *result records that name this place's file as a source* (computed; not a link): `reach-from-a-seed`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-18, as "SeedReach.lean: fromSeed_iff_invariant, separated_iff_not_fromSeed, fromSeed_of_not_separated_iff_dne" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-18.md.txt)); pass b: reader whole-b-67, as "SeedReach.lean: Moves, FromSeed, fromSeed_iff_closure, fromSeed_iff_invariant, covers_iff_invariant, unreached_has_invariant, Separated, separated_iff_not_fromSeed, fromSeed_iff_not_separated_of_decidable, fromSeed_of_not_separated_iff_dne" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-67.md.txt)); the third pass, where the two differed: reader whole-c-settle-25, as "SeedReach.lean: settled fields both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-25.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `fromSeed_iff_invariant` (l. 73) characterizes reach from seeds by all invariants containing them. `fromSeed_of_not_separated_iff_dne` (l. 177) equates universal reach from failed separation with double-negation elimination.
  - *pass b:* For every process, what is reached from seeds is the seed–edge closure under its moves, and the least property holding at the seeds and invariant under the process. A configuration is separated (some such invariant fails there) exactly where it is not reached; where reach is decided, reached exactly where not separated; and that every unseparated configuration is reached is equivalent to double-negation elimination (built SeedReach.conditional); general laws throughout.
- **moves**
  - *pass a:* S: `FromSeed.step` (l. 52) preserves reach from a seed under any enabled labelled step.
  - *pass b:* S: `Moves` (l. 46): ∃ a, P.step x a y, for any Process S A. `fromSeed_iff_invariant` (l. 73): reach from seeds holds at p exactly where every property holding at the seeds and invariant under every step holds at p.
- **a reading**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a point of no return**
  - *pass a:* S: `separated_iff_not_fromSeed` (l. 117) concludes that no course from a seed reaches a target exactly when an invariant containing the seeds excludes it. This is a reach obstruction with no stock threshold.
  - *pass b:* S (of reach, not of a loss): `separated_iff_not_fromSeed` (l. 117): a configuration is not reached from the seeds exactly where some property holds at the seeds, is invariant and fails there, which concludes that no course from the seeds reaches it. `fromSeed_iff_seed_of_no_moves` (l. 102): with no moves only the seeds are reached.
- **both outcomes**
  - *settled by the third pass:* N for going on and ending or keeping and losing. There is an exact 'iff' of reach, general: `separated_iff_not_fromSeed` (l.117): `Separated P seed x ↔ ¬ FromSeed P seed x` for every `Process S A`; `fromSeed_iff_not_separated_of_decidable` (l.135): with `Decidable (FromSeed P seed x)`, `FromSeed P seed x ↔ ¬ Separated P seed x`; `not_separated_iff` (l.129): `¬ Separated ↔ ¬ ¬ FromSeed`. Reached or separated by an invariant, of one configuration; not two outcomes of a course. [which pass was right: both in part; opened: All statements: `fromSeed_invariant` (l.58), `fromSeed_iff_invariant` (l.73), `unreached_has_invariant` (l.88), `fromSeed_iff_seed_of_no_moves` (l.102), `Separated` (l.113), `separated_iff_not_fromSeed` (l.117), `not_separated_iff` (l.129), `fromSeed_iff_not_separated_of_decidable` (l.135), `fromSeed_of_not_separated_iff_dne` (l.177).]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S (reach, general): `fromSeed_iff_not_separated_of_decidable` (l. 135): where reach is decided, reached exactly where not separated. `not_separated_iff` (l. 129): without a decision, not separated ↔ ¬¬ reached. Not of going on and ending.
- **a comparison between two**
  - *pass a:* S: `substitute_seeds` (l. 94) transfers reach from a second seed set when its every seed is reachable from the first.
  - *pass b:* S: `substitute_seeds` (l. 94): seeds reached from other seeds add nothing to what is reached. `fromSeed_iff_closure` (l. 63): reach equals the seed–edge closure of Becoming.EdgeClosure. `covers_iff_invariant` (l. 80).
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a closed region**
  - *pass a:* S: `fromSeed_invariant` (l. 58) and `fromSeed_iff_invariant` (l. 73) give closure and leastness of the seed-reachable region.
  - *pass b:* S: `fromSeed_invariant` (l. 58): being reached holds at the seeds and is invariant. `fromSeed_iff_invariant` (l. 73): it is the least such invariant. `unreached_has_invariant` (l. 88): an unreached configuration has an invariant holding at the seeds and failing there (a certificate).
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **how it was read**
  - *pass a:* Statements, their docstrings and the opening account were read throughout. General statements for states, moves, no_return, comparison, closed_region. Not found for reading, share, level, giving, cost, multiplying, both_outcomes, rank, forms_change. All questions were reached.
  - *pass b:* Answered from statements: moves, no_return (of reach), both_outcomes (of reach), comparison and closed_region. N after reading every statement: the rest. Nothing unreached. Read: the whole module, lines 1–187.
