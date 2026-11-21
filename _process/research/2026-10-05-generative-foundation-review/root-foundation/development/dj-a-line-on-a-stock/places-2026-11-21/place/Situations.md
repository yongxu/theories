# Situations

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Situations.lean`
- *result records that name this place's file as a source* (computed; not a link): `the-move-alone-underdetermines`, `weights-count-situations`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-19, as "Situations.lean: finerLaw_determined, move_underdetermines, sum_finer, sum_event" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-19.md.txt)); pass b: reader whole-b-72, as "Situations.lean: finerLaw, finerLaw_determined, finerLaw_step_iff, sum_finer, finer_count, move_underdetermines, situations_of_course, situations_typical, sum_event, event_typical, event_concentrated, situations_of_course_listed, sum_finer_weights, signed_counts, cancels_situations" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-72.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For every natural weighting, taking the situation as move gives a determined law, with a situation for precisely the positive-weight steps (`finerLaw_determined`, l. 104 and `finerLaw_step_iff`, l. 108). Summing a course reading over finer courses gives its weighted sum over listed courses (`sum_finer`, l. 135).
  - *pass b:* General, with no premise beyond a natural weighting: the law whose moves are situations (`finerLaw`) is determined (l. 104), and summing any reading over its finer courses equals summing over the weighted courses (`sum_finer`, l. 135). So natural weights count situations, with the law of large numbers, concentration and per-course counts as counts of situations (l. 217-437, 537); signed weights are pairs of counts of adding and subtracting situations (l. 700); a move alone underdetermines the outcome where it has two situations (l. 185). Built: `cancels_situations` (l. 712).
- **moves**
  - *pass a:* S: `move_underdetermines` (l. 185) gives two finer steps with the same coarse move when both different targets have positive weight, and excludes any state-and-move function being right on both.
  - *pass b:* S: `finerLaw weight : Process S (A × S × Nat)` (l. 100) with `finerLaw_determined` (l. 104) and `finerLaw_step_iff` (l. 108): the finer law takes a step exactly where it has positive weight. `move_underdetermines` (l. 185): if a step by a from s has positive weight to m and to m' with m ≠ m', the finer law takes both by move a, and no `next : S → A → S` gives both. No law of what a choice keeps.
- **a reading**
  - *pass a:* S: `sum_event` (l. 361) reduces every natural-valued reading of event histories to Boolean courses weighted by the total weights inside and outside the event.
  - *pass b:* S: `sum_event` (l. 361): for any listed values with natural weights and any event, summing a reading of `seen event c` over weighted courses equals summing over Typicality's two-value courses with weights `inside` and `outside`. `coarse` (l. 128) forgets the situation. `move_underdetermines` (l. 185): what the move alone registers does not fix the outcome.
- **a share**
  - *pass a:* S: `event_typical` (l. 401) bounds the count of deviations for any event of the weighted values. Weights are supplied at each value, with no reset from frequencies.
  - *pass b:* S: `inside`/`outside` (l. 311, 315) give the weight where an event holds or fails. `event_typical` (l. 401): finer courses deviating by at least d from that ratio, times d, are at most n·P·Q·(P+Q)^n. `situations_typical` (l. 280) is the two-value case. N: no rule set again from the share.
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
  - *pass b:* N: `finer_count` (l. 173) counts courses (the sum over histories), not units.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N for going on and ending. `signs_unit` (l. 664): every finer course composes to adding or to subtracting, which is a different dichotomy.
- **a comparison between two**
  - *pass a:* S: `sum_finer_weights` (l. 568) equates weighted readings on finer and coarse courses when each step’s weight is the sum of its situation contributions.
  - *pass b:* S: `sum_finer` (l. 135): for every process with listed moves and configurations and every natural weighting, any reading of courses summed over the finer law's courses equals its sum over the coarse courses, each counted by its weight. `sum_finer_weights` (l. 568) states the same for any `Weights` where each step weighs the sum over its situations. This carries readings between two processes.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and its docstring where present. General statements support states, moves, reading, share, comparison. All fourteen questions were reached.
  - *pass b:* All statements and the account read, with some proof bodies. Moves, reading, share and comparison are S; the rest are N. `counting_transfer_iff`, named in the account, is not in this module.
