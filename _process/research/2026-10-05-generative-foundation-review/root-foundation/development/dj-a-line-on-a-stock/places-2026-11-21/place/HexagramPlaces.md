# HexagramPlaces

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HexagramPlaces.lean`
- *result records that name this place's file as a source* (computed; not a link): `bands-of-the-three-powers`, `censuses-of-the-xiang-and-tuan`, `fixed-places-and-sole-lines`, `hexagram-arrangements-and-laws`, `hexagram-world-laws`, `place-relations-in-context`
- *dynamics in the atlas that name one of those records* (computed; not a link): `waxing-and-waning-returns`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-07, as "HexagramPlaces.lean: atSites_glues_iff, changes_run_phase, opposition_orbit, run_opposition_two_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-07.md.txt)); pass b: reader whole-b-25, as "HexagramPlaces.lean: opposed_iff_phase, atSites_glues_iff, halves_glues_iff, halves_no_free_frame, phases_glue_iff, opposition_waxWane, opposition_lumped, run_opposition_moves, run_six_keeps, backward_run, changes_run_phase, shown_along_run" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-25.md.txt)); the third pass, where the two differed: reader whole-c-settle-09, as "HexagramPlaces.lean: settled fields both_outcomes, rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-09.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `atSites_glues_iff` (l. 286) says any Boolean site reading of a hexagram glues exactly when every site agrees with the designated home site. B: `opposition_orbit` (l. 1365) projects the six-line waxing and waning orbit at every time to the three-cell orbit on its oppositions.
  - *pass b:* The module defines the relations the 彖 and 象 read between a hexagram's places: in phase (正), opposed (應), alternation/rise/fall (比, 承, 乘) and middle (中). It proves how they glue as contextual readings, that opposition is told by phase, and how each behaves under the complement, turning over, the change of one line and the law of waxing and waning, along runs, with text censuses checked. All of this is of one built model (the 64 configurations). A few statements quantify over any process or run on hexagrams (`halves_no_free_frame`, `shown_along_run`), and `atSites_glues_iff` holds for any relation.
- **moves**
  - *pass a:* B: `changes_run_phase` (l. 1384) and `changes_run_opposition` (l. 1397) say every chosen line flips its own phase and its height's opposition, preserving other phases and other heights' oppositions.
  - *pass b:* S: `changes_run_phase` (l. 1384): along every run of `changes`, each step turns the phase of the line it changes (r.act n), keeps every other phase, and moves `phaseCount` by one. `changes_run_opposition` (l. 1397): each step turns the opposition at the changed line's height and keeps every other. `halves_no_free_frame` (l. 338) and `shown_along_run` (l. 1436) quantify over any `Process Hexagram A` and any of its runs. All of this is in the built hexagram model.
- **a reading**
  - *pass a:* S: `atSites_indexed` (l. 1251) gives realization at the specified site exactly when its reading has the specified value, for every site reading and process on hexagrams. B: `opposition_lumped` (l. 812) makes next opposition depend on present opposition under waxWane, while `phaseCount_not_lumped` (l. 766) rules this out for the phase count.
  - *pass b:* S: `atSites` (l. 281) reads a relation at each site as a `Contextual` reading. `atSites_glues_iff` (l. 286): it glues to one reading of the whole exactly where every site shows what one site shows. `halves_glues_iff` (l. 325): the two trigrams glue exactly where no height is opposed. `halves_no_free_frame` (l. 338): for every process P, no context-free frame fits the heights; `phases_no_free_frame` (l. 1258), `oppositions_no_free_frame` (l. 1267) and `seams_no_free_frame` (l. 1276) say the same of the other relations. `opposition_lumped`/`opposition_goAlike` (l. 812/817): the reading `opposition` is a lumping waxWane goes alike across, so what it registers decides its next value. `phaseCount_not_lumped`/`phaseCount_not_goAlike` (l. 766/769): the count in phase is not.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: there are counts (`phaseCount` l. 263, `riseCount`, `fallCount`) with laws such as `phaseCount_waxWane` (l. 743) and `rises_falls_ends` (l. 896), but no rule or favouring set again from a share.
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
  - *pass b:* N: nothing is once lost and not regained. `opposition_six` (l. 828) and `run_six_keeps` (l. 1323) say six steps keep every opposition. `phase_qian_orbit` (l. 760, built) says that along twelve steps from 乾 the count in phase never reaches six or none.
- **both outcomes**
  - *settled by the third pass:* B: `run_opposition_two_iff` (l. 1355): for every `s : Hexagram` and n, `opposition ((Law.run waxWane s).state (n + 2)) = opposition ((Law.run waxWane s).state n) ↔` the pattern at n is `(true, false, true)` or `(false, true, false)`. An exactly-when of the pattern of oppositions being had again two steps on or not, on the one built law `waxWane`, with no choice; `opposition_two_iff` (l. 878) is the same from a start. It is of kept and not kept, not of going on and ending. [which pass was right: a; opened: `opposition` l. 798, `waxWane3_twice_iff` l. 834, `waxWane3_moves` l. 858, `opposition_two_iff` l. 878, `run_opposition_moves` l. 1350, `run_opposition_two_iff` l. 1355. Pass b's second sentence states the same (with letter S; the model is built).]
  - *pass a:* B: `run_opposition_two_iff` (l. 1355) gives retention of the current opposition reading two steps later exactly at the two alternating triples, on every run of waxWane.
  - *pass b:* N for going on and ending. S for kept/not kept, in the built model: `opposition_two_iff` (l. 878) says the oppositions are had again two steps on exactly when the pattern is (T,F,T) or (F,T,F); `run_opposition_two_iff` (l. 1355) says the same along every waxWane run. `phases_glue_iff` (l. 442) and `seams_glue_iff` (l. 513) are exactly-when statements of gluing.
- **a comparison between two**
  - *pass a:* B: `backward_run` (l. 1406) identifies reversal of a forward run at each time with the backward law from the reversed start.
  - *pass b:* S: `opposition_waxWane` (l. 807): `opposition (waxWane s) = waxWane3 (opposition s)`, carrying the six-line law to the three-cell law. `backward_run` (l. 1406): the waxWane run turned over is the unwaxWane run from the turned-over start. `backward_relations` (l. 1414) carries every relation, mirrored, between the two runs. `inPhase_complement`, `opposed_complement` and `rises_complement` (l. 598–622) and `inPhase_reverse` and `opposed_reverse` (l. 638–653) carry relations under the symmetries.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* B (weaker form): `run_three_turns` (l. 1339): for every s, n and `h : Height`, `opposed ((Law.run waxWane s).state (n + 3)) h = !opposed ((Law.run waxWane s).state n) h`. The value of each opposition is the opposite three steps on, so its present value is gone by then; `run_six_keeps` (l. 1323) has it back at six. A turn at a fixed step that recurs, on the built law; nothing ends, and no rank or variant falls. [which pass was right: both in part; opened: `opposed_three_steps` l. 821, `opposition_six` l. 828, `opposition_cycle` l. 870, `run_six_turns` l. 1313, `run_six_keeps` l. 1323, `run_three_turns` l. 1339, `run_doubled_three` l. 1345, `run_opposition_cycle` l. 1372.]
  - *pass a:* B: `run_three_turns` (l. 1339) gives a deadline for loss of the current opposition at each height, since its value is opposite three steps later. The change recurs.
  - *pass b:* N
- **a closed region**
  - *pass a:* B: `opposition_waxWane` (l. 807) preserves the relation that the three-cell state is the opposition reading of the six-line state when waxWane and waxWane3 take a step together.
  - *pass b:* B: `opposition_cycle` (l. 870) is a built list: the orbit of waxWane3 from (T,T,T) through six patterns and back in six steps, with the two other patterns a 2-cycle (`waxWane3_twice_iff` l. 834). `waxWane3_moves` (l. 858): no pattern is a fixed point. No Invariant, kernel or certificate statement was found.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `run_opposition_moves` (l. 1350) gives different opposition readings at every successive time for every start of waxWane. `run_opposition_cycle` (l. 1372) lists the six-step return from the all-opposed reading.
  - *pass b:* S: `run_opposition_moves` (l. 1350): along every waxWane run the pattern of oppositions changes at every step. `run_phase_rises` (l. 1287): each line's phase turns as it rises. `phase_parity_along_run` (l. 754): the count in phase changes parity at every step. The run goes on while what is present changes, in the built model. N for a widening.
- **how it was read**
  - *pass a:* S: I read the opening account, all statements and their docstrings. General statements cover states, reading. Built cases cover states, moves, reading, both_outcomes, comparison, rank, closed_region, forms_change. I found no matching claim for share, level, giving, cost, multiplying, no_return. I reached all fourteen questions.
  - *pass b:* Read all statements and docstrings of the whole module (1450 lines) and the opening account. Answered from statements: moves, reading, both_outcomes, comparison, forms_change. N after reading every statement: share, level, giving, cost, multiplying, no_return, rank. Closed_region from a built case.
