# ActivationCapacity

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ActivationCapacity.lean`
- *result records that name this place's file as a source* (computed; not a link): `effective-capacity-and-eventual-reachability`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-01, as "ActivationCapacity.lean: preparation_changes_capacity, release_loses_joint, prepared_can_end_one_sided" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-01.md.txt)); pass b: reader whole-b-01, as "ActivationCapacity.lean: joint_iff, preparation_changes_capacity, released_not_joint, release_loses_joint, prepared_can_end_one_sided" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-01.md.txt)); the third pass, where the two differed: reader whole-c-settle-01, as "ActivationCapacity.lean: settled fields giving, rank, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-01.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* In the activation law, retaining the coupling puts joint realization one move away, and releasing it makes joint realization unreachable (`preparation_changes_capacity`, l. 68, `release_loses_joint`, l. 80). A prepared run can still end one-sided (`prepared_can_end_one_sided`, l. 87).
  - *pass b:* All results are of one built law (`Activation.law` of Becoming.Bundles). Joint content is realized exactly at bothActive. It can be realized within one move from coupled, not within one from initial, and within two from initial. After the release no number of moves realizes it, so the release loses what was eventually reachable, and a prepared configuration can still end one-sided with no move left.
- **moves**
  - *pass a:* B: `prepared_can_end_one_sided` (l. 87) traces retain then activateLeft to a state with no enabled action, although joint activation was within one move at coupled.
  - *pass b:* B: the built `law` has moves (retain, release, activateLeft, activateRight, activateTogether). `release_loses_joint` (l.80): the release move takes initial to released, joint content is realizable within some n from initial and from released within no n. `prepared_can_end_one_sided` (l.87): the course [retain, activateLeft] ends at leftActive with the right claim unrealized and no enabled move. `WithinMoves` (from Recurrence) is used.
- **a reading**
  - *pass a:* B: `joint_iff` (l. 44) identifies realization of every claim in both under realizedAt exactly with bothActive.
  - *pass b:* B: `realizedAt` reads the claims realized at a configuration. `joint_iff` (l.44): both claims are realized iff s = bothActive. No law in which what is registered decides a course.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: only a count of moves. There is no amount.
- **a giving that is itself a going-on**
  - *settled by the third pass:* B: `release_loses_joint` (l.80): in the built `Activation.law`, `Trace law .initial [.release] .released`, some n has `WithinMoves law realizedAt .initial n both`, and no n has it from `.released`; with `preparation_changes_capacity` (l.68) the coupled configuration is what puts the joint content within one move. What enables is a configuration of the law reached by the move `retain`, not a premise handed in; there is no level and no formation or unit that gives. [which pass was right: both in part; opened: joint_iff l.44, coupled_within_one l.51, initial_not_within_one l.56, preparation_changes_capacity l.68, released_not_joint l.75, release_loses_joint l.80, prepared_can_end_one_sided l.87 (whole module)]
  - *pass a:* B: `preparation_changes_capacity` (l. 68) and `release_loses_joint` (l. 80) exhibit a coupling configuration enabling joint realization and an actual release losing that possibility.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* B: `released_not_joint` (l. 75) concludes no move budget suffices after release.
  - *pass b:* B: `released_not_joint` (l.75): from released, no number of moves realizes the joint content. Concluded in the built law (from `PastRelease.no_joint`), and it comes at the release of the coupling that makes joint activation possible, not at a low level.
- **both outcomes**
  - *pass a:* B: `release_loses_joint` (l. 80) puts eventual joint realization before release and its impossibility afterward in one statement. `preparation_changes_capacity` (l. 68) gives the retaining branch in the same law.
  - *pass b:* B (no exactly-when): `release_loses_joint` (l.80) pairs reachable from initial with unreachable from released, and `preparation_changes_capacity` (l.68) pairs not-within-one with within-one and within-two. No statement says going on or ending exactly when.
- **a comparison between two**
  - *pass a:* B: `preparation_changes_capacity` (l. 68) compares initial and coupled at budget one and counts the preparation at budget two.
  - *pass b:* B: `preparation_changes_capacity` (l.68) compares capacity at initial and at coupled and uses `WithinMoves.after_course` (Recurrence) to carry within-1 from coupled to within-2 from initial along the trace [retain].
- **a rank (an ending within a bound)**
  - *settled by the third pass:* N: opened `coupled_within_one` (l.51: `WithinMoves law realizedAt .coupled 1 both`), `initial_not_within_one` (l.56), `preparation_changes_capacity` (l.68), `prepared_can_end_one_sided` (l.87: after [.retain, .activateLeft] no move is enabled at `.leftActive`). These bound the number of moves within which a content is realized in one built law; none states a course ending within a bound, and nothing falls. Pass b's description of what is there is accurate, but it is not the field's thing. [which pass was right: a; opened: coupled_within_one l.51, initial_not_within_one l.56, preparation_changes_capacity l.68, released_not_joint l.75, prepared_can_end_one_sided l.87]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* B: capacity is counted within a bound of moves (`coupled_within_one` l.51, `initial_not_within_one` l.56). No variant falls.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `prepared_can_end_one_sided` (l.87) shows a configuration with no enabled move. No invariant or closed region is stated.
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* B (weak): `preparation_changes_capacity` (l.68): after the step `retain` from `.initial` to `.coupled`, both claims are realizable within one move where they were not, while they were already realizable within two from `.initial`. So what widens is the one-move capacity only; no eventually reachable content is added, and there is no relay or alternation. [which pass was right: both in part; opened: preparation_changes_capacity l.68, coupled_within_one l.51, initial_not_within_one l.56]
  - *pass a:* B: `preparation_changes_capacity` (l. 68) exhibits increased one-move capacity after retain.
  - *pass b:* N
- **how it was read**
  - *pass a:* Read the opening account, all docstrings and all declaration statements. Statements support states. Built statements supply moves, reading, giving, no_return, both_outcomes, comparison, forms_change. The remaining fields are N. None were unreached.
  - *pass b:* Answered from statements of the built law (B) or N. All statements were read, the whole module (99 lines).
