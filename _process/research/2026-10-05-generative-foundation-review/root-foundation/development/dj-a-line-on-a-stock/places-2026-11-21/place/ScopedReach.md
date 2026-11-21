# ScopedReach

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ScopedReach.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-18, as "ScopedReach.lean: invariant_iff_only, glued_invariant, fromSeed_within_iff, alternating_beyond_scopes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-18.md.txt)); pass b: reader whole-b-67, as "ScopedReach.lean: only, only_reach, invariant_iff_only, Agree, Glued, glued_invariant, glued_on_reach, within, within_keeps, fromSeed_within_iff, alternating_beyond_scopes, halted_coverage_insufficient" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-67.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `glued_invariant` (l. 82) makes agreeing local grounds invariant when each step stays in its domain and carries its ground. `fromSeed_within_iff` (l. 124) identifies reach in a history-indexed process with reach from seeds in that history.
  - *pass b:* For any process whose labels are scopes: what one scope's steps reach the whole process reaches, a property is invariant exactly where each scope's steps carry it, and grounds that agree on overlaps and are carried by each scope's steps glue to an invariant that holds wherever the process reaches from seeds where it holds. A family of processes indexed by histories is one process no path of which leaves a history, reaching exactly what each history's process reaches; these are general laws, with built witnesses that alternating scopes reach beyond each scope and that covering by scopes does not give reach.
- **moves**
  - *pass a:* S: `invariant_iff_only` (l. 61) equates invariance under all labelled steps with invariance under each label’s restriction.
  - *pass b:* S: Process S L with labels as scopes. `invariant_iff_only` (l. 61): Invariant P R ↔ ∀ i, Invariant (only P i) R, so every choice of scope keeps R exactly where the process does. `glued_invariant` (l. 82): with Agree, every step inside its scope's domain, and each scope's steps carrying its ground, the glued ground is invariant under the process.
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
  - *pass a:* S: `within_keeps` (l. 115) rules out reaching a different history from any start in the within-history process. B: `halted_coverage_insufficient` (l. 221) gives a covered finish unreachable from the specified seed. Neither concerns a depleted stock.
  - *pass b:* S (as invariance, not loss): `within_keeps` (l. 115): no path of `within Q` leaves a history (x.1 = y.1). N: no point of no return of a kept or lost thing.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N for going on and ending. `fromSeed_within_iff` (l. 124) is an exactly-when of reach.
- **a comparison between two**
  - *pass a:* S: `only_reach` (l. 53) lifts any reach from a seed under one scope to reach under the whole process.
  - *pass b:* S: `only_reach` (l. 53): what `only P i` reaches from a seed, P reaches. `fromSeed_within_iff` (l. 124): the family's process reaches ⟨h, p⟩ from seed exactly where Q h reaches p from the seeds of h. B: `alternating_beyond_scopes` (l. 204): the converse of only_reach fails.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a closed region**
  - *pass a:* S: `glued_on_reach` (l. 91) carries the glued ground to every reachable state given seed grounds, overlap agreement, domain containment and local preservation. `within_keeps` (l. 115) keeps the history index along every path.
  - *pass b:* S: `glued_invariant` (l. 82), `glued_on_reach` (l. 91): the glued ground holds wherever the process reaches from seeds where it holds. `invariant_on_within_reach` (l. 139): a property invariant in each history holds wherever the family's process reaches from seeds it holds at.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `alternating_beyond_scopes` (l. 204) reaches the finish by using both scopes where neither scope alone can reach it from the start.
  - *pass b:* B: `alternating_beyond_scopes` (l. 204): the alternating process reaches the finish from the start by a step under scope false then a step under scope true, while neither scope's steps alone reach it (an alternation reaches further). `halted_coverage_insufficient` (l. 221): covering by scopes with no steps reaches nothing.
- **how it was read**
  - *pass a:* Statements, their docstrings and the opening account were read throughout. General statements for states, moves, no_return, comparison, closed_region. Built cases for no_return, forms_change. Not found for reading, share, level, giving, cost, multiplying, both_outcomes, rank. All questions were reached.
  - *pass b:* Answered from statements: moves, no_return (as invariance), comparison and closed_region. Built cases: forms_change and the converse under comparison. N after reading every statement: the rest. Nothing unreached. Read: the whole module, lines 1–233.
