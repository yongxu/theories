# GrammarCrossing

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarCrossing.lean`
- *result records that name this place's file as a source* (computed; not a link): `not-going-out-of-a-region`
- *dynamics in the atlas that name one of those records* (computed; not a link): `not-going-out-of-a-region`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-06, as "GrammarCrossing.lean: «不出当且仅当不外者闭», «内至外之线有出步», «闭而有入之例»" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-06.md.txt)); pass b: reader whole-b-21, as "GrammarCrossing.lean: «不出当且仅当不外者闭», «不外者内则不出当且仅当闭», «不出皆闭当且仅当排中», «逆之不出当且仅当外者不出», «对称则不出当且仅当逆不出», «闭而有入之例», «内至外之线有出步»" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-21.md.txt)); the third pass, where the two differed: reader whole-c-settle-08, as "GrammarCrossing.lean: settled fields reading, no_return, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-08.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `«不出当且仅当不外者闭»` (l. 57) equates absence of an outgoing crossing of P with step closure of double-negated membership. `«内至外之线有出步»` (l. 150) locates a crossing on an inside-to-outside line if each continuation step is known to preserve membership or to cross.
  - *pass b:* For every carrier, relation R and region P, the module states how not going out of a region («不出») stands to being closed («闭»): it is the closedness of what is not outside, it is closedness where membership is stable, and that the two coincide everywhere is exactly excluded middle. It also relates going out to coming in along the converse, and places the step going out on a line from inside to outside; all general, with one witness on Bool.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no process with moves, policy or allowed set; the statements are about one relation R, its converse, and lines «相续» R E. Nothing is stated about what a choice keeps.
- **a reading**
  - *settled by the third pass:* N: `«定则内至外之线有出步»` (l. 159): premise `decided : ∀ a, P a ∨ ¬ P a` for a region `P : α → Prop`, a line `«相续» R E x y`, `P x`, `¬ P y`; concludes a step `«续» R E u v` with `P u ∧ ¬ P v` and its place on the line. `decided` is decidability of membership, not an observation; `E` is any relation and decides nothing. Whole module read (9 declarations): no map of values, no class read alike that decides. [which pass was right: b; opened: all nine declarations, l.57-159]
  - *pass a:* S: `«定则内至外之线有出步»` (l. 159) uses decided region membership to exhibit an exit step on a continuation line with an inside start and outside end.
  - *pass b:* N: the region P is any proposition. No observation, class read alike, or rule made from what is registered appears.
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
  - *settled by the third pass:* B: `«闭而有入之例»` (l. 120): there are `R : «际» Bool` and `P` with `«闭» R P`, some `x y` with `¬ P x ∧ P y ∧ R x y`, and `¬ «则» R («逆» R)`. A two-point witness: a region closed under the relation that is entered from outside, so what has entered is not borne back out. It is exhibited, not concluded from a law; no level and nothing that gives. `«内至外之线则非不出»` (l. 139) is a crossing, not an irreversibility. [which pass was right: a; opened: «闭而有入之例» l.120; «内至外之线则非不出» l.139; «对称则不出当且仅当逆不出» l.109]
  - *pass a:* B: `«闭而有入之例»` (l. 120) exhibits a closed Boolean region with an incoming edge from outside. Once inside, every step stays inside by the exhibited closure.
  - *pass b:* N: no irreversibility or loss is stated. S, the nearest: `«内至外之线则非不出»` (l. 139): a line under E from a member of P to something outside means P is not «不出» along R. That is a crossing, not a point of no return.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N for going on or ending. S, the nearest, of closedness: `«不出皆闭当且仅当排中»` (l. 75): that every region not gone out of is closed, for every relation on every carrier in Type, is exactly excluded middle. `«内至外之线有出步»` (l. 150) takes a dichotomy as a premise: each step keeps to P or goes out of it.
- **a comparison between two**
  - *pass a:* S: `«对称则不出当且仅当逆不出»` (l. 109) transfers no-exit between a relation and its converse assuming symmetry. `«逆之不出当且仅当外者不出»` (l. 102) gives the complement version without symmetry.
  - *pass b:* S: `«逆之不出当且仅当外者不出»` (l. 102): P is not gone out of along the converse of R exactly where nothing outside P bears R to something not outside P. S: `«对称则不出当且仅当逆不出»` (l. 109): for a symmetric R, «不出» R P ↔ «不出» («逆» R) P. B: `«闭而有入之例»` (l. 120): a non-symmetric relation on Bool with a closed region that something outside comes into. These carry a property between a relation and its converse, not between two processes.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* S: `«不外者内则不出当且仅当闭»` (l. 65) characterizes closure by absence of exit for stable membership. `«不出皆闭当且仅当排中»` (l. 75) equates the unrestricted implication with excluded middle.
  - *pass b:* S: `«不出当且仅当不外者闭»` (l. 57): «不出» R P ↔ «闭» R (fun y => ¬¬ P y), with no decision. S: `«不外者内则不出当且仅当闭»` (l. 65): given stable membership (¬¬P y → P y), «不出» R P ↔ «闭» R P. B: `«闭而有入之例»` (l. 120).
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* S: `«内至外之线有出步»` (l. 150): given `split : ∀ u v, «续» R E u v → (P u → P v) ∨ (P u ∧ ¬ P v)`, a line `«相续» R E x y`, `P x` and `¬ P y`, there is a step of continuation under E from a member of P to something outside P, reached from x and reaching y. The line continuing under E while membership in P changes is a premise; the statement only places the step. No relay, alternation or widening. [which pass was right: both in part; opened: «内至外之线有出步» l.150; «定则内至外之线有出步» l.159; «内至外之线则非不出» l.139]
  - *pass a:* S: `«内至外之线有出步»` (l. 150) exhibits an E-continuation step changing P from true to false, given an E-line with that endpoint change and the stepwise split premise.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: Read the opening account, all declaration statements and their docstrings. Statements support states, reading, comparison, closed_region, forms_change. Built statements support no_return. No finding for moves, share, level, giving, cost, multiplying, both_outcomes, rank. All questions reached.
  - *pass b:* I read all statements, docstrings and the opening account (169 lines). states, comparison, closed_region and no_return (its nearest crossing) come from statements; every other field is N.
