# Retrodiction

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Retrodiction.lean`
- *result records that name this place's file as a source* (computed; not a link): `historical-source-binding`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-17, as "Retrodiction.lean: reading_right_iff, bracket_settles_iff, change_unlocated" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-17.md.txt)); pass b: reader whole-b-64, as "Retrodiction.lean: reading_right_iff, look_right_iff, fits_iff_same, fits_or_separated, bracket, bracket_settles_iff, change_unlocated" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-64.md.txt)); the third pass, where the two differed: reader whole-c-settle-24, as "Retrodiction.lean: settled fields both_outcomes, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-24.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: With decidable report and content equality, dated controls settle earlier packet content exactly when they separate every admitted rival explanation with different content (`reading_right_iff`, l. 115). For a relation type with two distinct values, equal endpoints settle the entire interval for all courses under change budget k exactly when k \< 2 or the span is shorter than two (`bracket_settles_iff`, l. 252).
  - *pass b:* For every type of histories, dates, relations, probes, reports, packets and contents, it proves general laws of reading an earlier packet from dated records: every explanation by a family history that fits the records gives the actual content exactly when every rival giving the same packet with another content is told apart by some dated control (reading_right_iff, look_right_iff, agreed_reading_actual). It also proves general laws of counting changes of a course over dates (bracket, bracket_settles_iff, change_unlocated).
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found. Histories are given functions from dates to relations; there are no steps to choose.
- **a reading**
  - *pass a:* S: `agreed_reading_actual` (l. 134) gives the agreed content when the actual history belongs to the family, its source is admitted, and all fitting admitted explanations of the packet agree.
  - *pass b:* S: `reading_right_iff` (l.115): with records acquired from history h, every family history that fits them, with an admitted source giving the same packet, gives the actual content, exactly when every family history giving that packet with another content is Separated from h by some dated probe. `look_right_iff` (l.145) is the same for any reading `look` of the relation at a date. `agreed_reading_actual` (l.134): where h is in the family and its source is admitted, an agreed reading is the actual one. What the records register decides what is read right.
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
  - *settled by the third pass:* S, in a different form, general: `bracket_settles_iff` (l. 252), for `R` with decidable equality and two values `r ≠ r'`, states `(∀ c : Nat → R, changes c a n ≤ k → c (a + n) = c a → ∀ j, j ≤ n → c (a + j) = c a) ↔ (k < 2 ∨ n < 2)`: an exactly-when of whether every admitted course holds its end value at every date between, on the bound `k` of changes and the span `n`. It is about what end controls settle over a family of courses, not about one course going on or ending. `fits_or_separated` (l. 92) is a dichotomy of a history fitting the records or being told apart, with `[DecidableEq O]`. [which pass was right: both in part; opened: `Fits` (l. 53), `Separated` (l. 63), `fits_or_separated` (l. 92), `reading_right_iff` (l. 115), `changes` (l. 167), `bracket` (l. 216), `bracket_settles_iff` (l. 252); section variables `{R : Type w} [DecidableEq R]` (l. 164), `(routeAt : H → D → R) (emit : R → Q → O)` (l. 50).]
  - *pass a:* S: `bracket_settles_iff` (l. 252) characterizes when all bounded-change courses with equal endpoints keep that value throughout, assuming two distinct values exist.
  - *pass b:* N: no exactly-when of going on and ending, or of keeping and losing. `fits_or_separated` (l.92) is a dichotomy (with decidable reports, a history either fits the records or is told apart), and `bracket_settles_iff` (l.252) is an exactly-when about settling dates; neither is about a going-on.
- **a comparison between two**
  - *pass a:* S: `fits_iff_same` (l. 73) equates fitting another history’s records with generating those same records on the same dated probes.
  - *pass b:* S: `fits_iff_same` (l.73): history g fits the records h gave exactly when g gives the same records for the same dated probes. `not_fits_of_separated` (l.85) and `fits_or_separated` (l.92) compare two histories by the probes. These compare histories by their records; they carry no order or simulation between processes.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found. `changes_le` (l.179) bounds the count of changes over n steps by n; nothing falls toward an end.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* N: no going-on is stated to continue. `excursion_changes` (l. 227) states `∀ m, changes (excursion r r' a) a (m + 2) = 2` for `r ≠ r'`, a count of changes on the built course `excursion` (l. 225, `r` except `r'` at date `a + 1`); `stepAt` (l. 286) and `change_unlocated` (l. 307) are built courses with one change. A course here is a function `Nat → R` whose changes are counted; nothing is said to go on through the change. [which pass was right: b; opened: `changes` (l. 167), `excursion` (l. 225), `excursion_changes` (l. 227), `stepAt` (l. 286), `step_changes` (l. 290), `change_unlocated` (l. 307).]
  - *pass a:* B: `excursion_changes` (l. 227) counts exactly two changes on the specified course that visits a different value for one date and returns.
  - *pass b:* N: no going-on is said to continue. Courses that change value over dates are counted: `bracket` (l.216) says a return through a date elsewhere is at least two changes, `excursion_changes` (l.227) and `change_unlocated` (l.307) are built step courses showing that end controls do not locate a change. These are about reading changes, not about a going-on continuing.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and docstrings. S for states, reading, both_outcomes, comparison. N for moves, share, level, giving, cost, multiplying, no_return, rank, closed_region. B for forms_change.
  - *pass b:* All statements and docstrings to l.326 read. 1, 3 and 11 answered from statements. The rest are N after reading every statement.
