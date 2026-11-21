# Segmentation

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Segmentation.lean`
- *result records that name this place's file as a source* (computed; not a link): `acquired-binding-compositional-use`, `transition-grouping-word-partition`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-18, as "Segmentation.lean: encode_iff, bond_unique, reads_every_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-18.md.txt)); pass b: reader whole-b-68, as "Segmentation.lean: chunks, Grouped, chunks_eq_iff, chunks_unique, encode_iff, bond, bond_unique, no_record_groups, reads_every_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-68.md.txt)); the third pass, where the two differed: reader whole-c-settle-26, as "Segmentation.lean: settled fields both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-26.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `encode_iff` (l. 182) characterizes exact segmentation of all encoded sequences of nonempty words by internal links and absence of links across word boundaries. `bond_unique` (l. 278) gives at most one successor per element for the strict-majority relation learned from a log.
  - *pass b:* For every alphabet and every Boolean adjacency relation r, grouping a sequence by r (chunks) returns a partition exactly when every group is nonempty and linked inside and no group is linked to the next; that partition is unique, and grouping never changes the sequence. A majority bond learned from a log of transitions is functional, so no record groups every encoded sequence where two words continue one element differently. Reading the groups gives the words' meanings exactly when each word is read as its meaning. All of these are general laws.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a reading**
  - *pass a:* S: `reads_every_iff` (l. 350) equates correct reading of all sequences with correct reading of every word given exact segmentation.
  - *pass b:* S: `bond` (l. 230) is a rule made from what is registered: x is bonded to y where more than half of the observed transitions from x in the log go to y. `bond_unique` (l. 278): each element is bonded to at most one successor. `no_record_groups` (l. 291): where every log linking each word inside must bond x to y and to z with y ≠ z, no log's bond groups every encoded sequence. `reads_every_iff` (l. 350): where grouping recovers the words, every encoded sequence is read as its meanings exactly when each word is read as its meaning.
- **a share**
  - *pass a:* S: `bond` (l. 230) sets an adjacency rule from the observed share of departures to each successor, requiring strictly more than half. Its argument is a log, with no step updating the log from the chosen bond.
  - *pass b:* S: `bond` (l. 230): the share of transitions from x that go to y (transitions against departures, departures \< 2*transitions) decides the relation. The rule is made from the share once; it is not set again from its own output over steps (N for that).
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
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *settled by the third pass:* N (strictly; S for an exactly-when of another kind): `chunks_eq_iff` (l. 141): for any `r : α → α → Bool` and `L : List (List α)`, `chunks r (join L) = L ↔ Grouped r L`; `encode_iff` (l. 182): given `Spelled word first rest`, grouping returns `ws.map word` for every `ws` iff every word is `LinkedFrom` inside and no word's last element is linked to any word's first. These are exact conditions for grouping returning a partition, general, with no process, no going on or ending, nothing kept or lost over a step. Also opened `readAll_map_iff` (l. 313) and `reads_every_iff` (l. 350): exact conditions for reading words as meanings, the same kind. [which pass was right: both in part; opened: glue l.38, chunks l.44, LinkedFrom l.49, Opens l.59, Grouped l.65, join l.71, chunks_of_grouped l.132, chunks_eq_iff l.141, chunks_unique l.146, encode l.155, Spelled l.158, grouped_words l.161, encode_iff l.182, readAll l.309, readAll_map_iff l.313, reads_every_iff l.350]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: `chunks_eq_iff` (l. 141) and `encode_iff` (l. 182) are exactly-when laws for grouping recovering a partition or words, general. They are not of going on against ending (N for that).
- **a comparison between two**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* S: `chunks_eq_iff` (l. 141) characterizes the fixed partitions of join followed by regrouping exactly as `Grouped r`; `grouped_glue` (l. 90) preserves this condition when adding an element.
  - *pass b:* S: `grouped_glue` (l. 90): the step glue r x keeps Grouped r. `grouped_chunks` (l. 101): chunks always returns a Grouped partition. This is an invariant of the grouping recursion.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* Statements, their docstrings and the opening account were read throughout. General statements for states, reading, share, closed_region. Not found for moves, level, giving, cost, multiplying, no_return, both_outcomes, comparison, rank, forms_change. All questions were reached.
  - *pass b:* All statements and docstrings of the module (360 lines) were read. Reading, share, both_outcomes and closed_region come from statements; all others are N.
