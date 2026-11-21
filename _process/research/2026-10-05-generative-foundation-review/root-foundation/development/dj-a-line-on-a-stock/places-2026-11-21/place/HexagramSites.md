# HexagramSites

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HexagramSites.lean`
- *result records that name this place's file as a source* (computed; not a link): `fixed-places-and-sole-lines`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-07, as "HexagramSites.lean: between_shown_along_runs, ends_not_told, sole_count, run_sole" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-07.md.txt)); pass b: reader whole-b-25, as "HexagramSites.lean: fixedPhase, holdsPlace, SameBetween, ends_not_told, opposed_mid_told, between_glues_iff, between_no_free_frame, betweenPhases_not_lumped, statements_fix_parity, sole, sole_count, sole_waxWane_none, run_sole, between_shown_along_runs" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-25.md.txt)); the third pass, where the two differed: reader whole-c-settle-09, as "HexagramSites.lean: settled fields both_outcomes, rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-09.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `between_shown_along_runs` (l. 1044) says that agreement on the internal phases across any two hexagram runs determines middle opposition and every internal seam relation. B: `run_sole` (l. 1141) says that a sole line on any waxWane run disappears as sole everywhere after one step and is sole at its original place again after six.
  - *pass b:* The module states 王弼's two further relations: the phase read only at the four places between the ends (`fixedPhase`, `holdsPlace`), and answering at every pair of places, with the sole line (`answers`, `sole`). It proves how they meet the relations of HexagramPlaces under the symmetries, the change of one line and waxing and waning, along runs, and checks text censuses. All of this is of the built hexagram model. Some statements quantify over every run of any process (`between_shown_along_runs`, `sole_shown_along_run`).
- **moves**
  - *pass a:* B: `changes_run_between` (l. 1032) says that a chosen end flip preserves the internal phase reading and an internal flip reverses the phase at its chosen place.
  - *pass b:* S: `changes_run_between` (l. 1032): along every run of `changes`, a step at an end keeps every phase between the ends (SameBetween), and a step between the ends turns the phase of the line changed. `changes_run_ends` (l. 1082) and `changes_run_sole` (l. 1153): changing a sole line leaves every line alike, and changing a line of a uniform configuration makes it sole. `between_shown_along_runs` (l. 1044) holds for any two runs of any two processes.
- **a reading**
  - *pass a:* B: `ends_not_told` (l. 538) exhibits flips indistinguishable on the four internal phases that reverse end opposition and seam alternation. `betweenPhases_not_lumped` (l. 608) says the reading fails to determine its own successor under waxWane.
  - *pass b:* S: `fixedPhase` (l. 146) is a reading that shows the phase between the ends and nothing at the ends. `SameBetween` (l. 447) means read alike. `opposed_mid_told` (l. 483) and `inner_seams_told` (l. 490): configurations with the same reading agree on the middle opposition and on every relation at the three inner seams. `ends_not_told` (l. 538): changing the bottom or top line keeps the reading and turns the opposition at its height and the alternation at its end seam. `betweenPhases_not_lumped`/`not_goAlike` (l. 608/611): this reading is not a lumping waxWane goes alike across. `between_no_free_frame` (l. 436): no context-free frame fits it under any process. `statements_fix_parity` (l. 234): any parity for which every listed 小象 statement holds equals `odd` at places 3, 4 and 5, so the registered statements decide the parity.
- **a share**
  - *pass a:* N: `sole_count` (l. 688) identifies a sole line by its value and the current count of unbroken lines. No step resets favouring from that count.
  - *pass b:* N: `sole_count` (l. 688) and `soleAny_count` (l. 698) say a line is sole exactly where the count of unbroken lines is 1 or 5, but no rule or favouring is set again from that count.
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
  - *pass b:* N: `sole_waxWane_none` (l. 902) says a sole line never lasts a step, but `sole_six` (l. 907) says it is back at its place six steps on.
- **both outcomes**
  - *settled by the third pass:* B: `changes_run_between` (l. 1032): for every `r : Run changes` and n, `(betweenEnds (r.act n) = false → SameBetween (r.state (n + 1)) (r.state n)) ∧ (betweenEnds (r.act n) = true → fixedPhase (r.state (n + 1)) (r.act n) = (fixedPhase (r.state n) (r.act n)).map (fun b => !b))`. Two cases by the Boolean `betweenEnds` of the move: a move at an end keeps every phase between the ends; a move between the ends turns the phase of the line it changes. Keeping and turning on the built process `changes`, with the move in the statement; not going on and ending. [which pass was right: a; opened: `betweenEnds` l. 122, `SameBetween` l. 447, `sameBetween_flip_end` l. 507, `fixedPhase_flip_self` l. 569, `changes_run_between` l. 1032, `changes_run_ends` l. 1082, `changes_run_sole` l. 1153; also `between_glues_iff` l. 424 and `sole_iff_flip` l. 742 by name (gluing and place, as pass b says).]
  - *pass a:* B: `changes_run_between` (l. 1032) gives the two branches for a single change run, retention of the inner phases for an end move and reversal of the selected inner phase for an interior move.
  - *pass b:* N for going on and ending, or keeping and losing. The exactly-when statements are of gluing and place: `between_glues_iff` (l. 424), `allHold_iff` (l. 343), `noneHold_iff` (l. 361), `sole_iff_flip` (l. 742).
- **a comparison between two**
  - *pass a:* S: `between_shown_along_runs` (l. 1044) transfers agreement of internal phases to agreement of middle opposition and internal seam readings across arbitrary times of any two hexagram processes. B: `backward_sole` (l. 1134) carries sole status to the mirrored place on the backward run.
  - *pass b:* S: `between_shown_along_runs` (l. 1044): for any runs r of P and r' of Q, if their states at n and m are SameBetween, they agree on the middle opposition and on falls, rises and alternations at inner seams. `backward_between` (l. 1025) and `backward_sole` (l. 1134) carry the phases between the ends and the sole line from the waxWane run to the unwaxWane run from the turned-over start, mirrored. `fixedPhase_complement` (l. 549), `sole_complement` (l. 765) and `sole_reverse` (l. 769) carry them under the symmetries.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* B (weaker form): `sole_waxWane_none` (l. 902): `sole s k = true → sole (waxWane s) k' = false` for every place k'; `run_sole` (l. 1141) says along every run of `waxWane` a sole line at step n leaves no sole line at n + 1 and is sole at its place again at n + 6; `sole_six` (l. 907): `sole (Law.orbit waxWane s 6) k = sole s k`. A feature of the configuration gone in one step and back at six, on the built law; nothing ends and no rank or variant falls. [which pass was right: both in part; opened: `sole` l. 666, `soleAny_waxWane` l. 897, `sole_waxWane_none` l. 902, `sole_six` l. 907, `sole_top_passes` l. 912, `run_between_six` l. 1015, `run_sole` l. 1141, `changes_run_sole` l. 1153.]
  - *pass a:* B: `sole_waxWane_none` (l. 902) concludes loss of sole status at every place in one step when a sole line is present. `sole_six` (l. 907) gives its return at six.
  - *pass b:* N
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no invariant, kernel or certificate statement. `soleAny_waxWane` (l. 897) says no configuration with a sole line has one a step later, and `sole_six` (l. 907) is a return after six steps.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `sole_top_passes` (l. 912) gives a uniform figure one step after a sole top line, then a sole bottom line at step two.
  - *pass b:* S: `run_sole` (l. 1141): along every waxWane run, a sole line never lasts a step and is back six steps on, and a sole line at the top is followed two steps later by a sole line at the bottom. `sole_top_passes` (l. 912): a sole line at the top passes out, leaving every line alike, and the next step a sole line enters at the bottom. So the sole line comes and goes while the run continues, in the built model. N for a widening.
- **how it was read**
  - *pass a:* S: I read the opening account, all statements and their docstrings. General statements cover states, comparison. Built cases cover states, moves, reading, both_outcomes, comparison, rank, forms_change. I found no matching claim for share, level, giving, cost, multiplying, no_return, closed_region. I reached all fourteen questions.
  - *pass b:* Read all statements and docstrings of the whole module (1163 lines) and the opening account. Answered from statements: moves, reading, comparison, forms_change. N after reading every statement: share, level, giving, cost, multiplying, no_return, both_outcomes, rank, closed_region.
