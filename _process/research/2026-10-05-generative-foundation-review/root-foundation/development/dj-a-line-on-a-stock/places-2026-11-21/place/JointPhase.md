# JointPhase

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/JointPhase.lean`
- *result records that name this place's file as a source* (computed; not a link): `joint-correlation-reduced-dynamics`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-08, as "JointPhase.lean: interaction_tells_apart, no_local_update, summary_response" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-08.md.txt)); pass b: reader whole-b-31, as "JointPhase.lean: actual_phase_preserves_both_local_states, same_interaction_distinguishes_relation, no_local_pair_update, local_pair_carries_no_law, summary_update_exact, every_finite_word_exact, summary_omits_register" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-31.md.txt)); the third pass, where the two differed: reader whole-c-settle-11, as "JointPhase.lean: settled fields closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-11.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* B: In the two-event JointPhase model, a phase shift at joined keeps the two local states and the basis masses but changes the response to a later interaction (phase_keeps_local_states, l. 189, phase_keeps_masses, l. 194, interaction_tells_apart, l. 209). For every finite event trace of this model, updating the four-component summary recovers the final control response (summary_response, l. 226).
  - *pass b:* This is one built model, the control-and-register configuration of Dephasing. A phase step keeps both local states and the basis masses but changes the cross contribution, and the same interaction then tells the two apart. No update or determined law on the local pair carries the interaction; a summary keeping the cross contribution commutes with the law and is exact along every finite word, while still omitting the register.
- **moves**
  - *pass a:* B: evolve_trace (l. 183) realizes every finite word from every start; at joined, shiftPhase keeps local states while the choice to apply it before interact changes the response (ll. 189, 209).
  - *pass b:* B: `process` (l. 94) is the map `next` read as a process with two Events (interact, shiftPhase); it is determined, so there is no choice. `phase_keeps_local_states` (l. 189): the phase step from joined keeps the local states.
- **a reading**
  - *pass a:* B: no_local_update (l. 219) excludes any decoder from the two local states to the post-interaction control. summary_response (l. 226) gives an exact control response from the updated summary despite omission of the register (summary_omits_register, l. 233).
  - *pass b:* B: `no_local_pair_update` (l. 113): no function of the local states gives the control after the interaction for both joined and changed. `local_pair_carries_no_law` (l. 124): no determined process on local pairs is one the law factors through. `summary_update_exact` (l. 149): the summary commutes with the law. `every_finite_word_exact` (l. 162). `summary_response` (l. 226). `summary_omits_register` (l. 233).
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
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a comparison between two**
  - *pass a:* B: every_finite_word_exact (l. 162) carries any word from any joint start through summarize to reducedNext, giving the same final summary.
  - *pass b:* B: `summary_update_exact` (l. 149) and `every_finite_word_exact` (l. 162): `summarize` semiconjugates `next` to `reducedNext` along every word. `local_pair_carries_no_law` (l. 124): no such carrying through `localStates`.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a closed region**
  - *settled by the third pass:* N: `summary_update_exact` (l. 149) states `Commuting next reducedNext summarize` (the summary of the next configuration is the reduced step of the summary, for both `Event`s), and `every_finite_word_exact` (l. 162) gives it along every word; this carries a law through a reading (the comparison field's kind), and no statement names a set of configurations closed under steps. The keepings stated are of one step from one configuration: `phase_keeps_local_states` (l. 189) and `phase_keeps_masses` (l. 194), `∀ t, process.step joined .shiftPhase t → …`. Opened to rule it out: ll. 100, 104, 149, 162, 189, 194, 233. [which pass was right: b; opened: summary_update_exact l.149; every_finite_word_exact l.162; actual_phase_preserves_both_local_states l.100; actual_phase_preserves_basis_masses l.104; phase_keeps_local_states l.189; phase_keeps_masses l.194; summary_omits_register l.233]
  - *pass a:* B: summary_update_exact (l. 149) gives a commuting summary, so the graph of summarize is preserved by synchronized full and reduced steps.
  - *pass b:* N.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: phase_changes_cross and interaction_tells_apart (ll. 201, 209) exhibit a changed joint cross contribution followed by another executable interaction, with unchanged local states across the shift.
  - *pass b:* B: `phase_keeps_local_states` (l. 189) with `phase_changes_cross` (l. 201): the joint relation changes while both local states stay fixed. This is a change of relation, not a going-on continuing while forms come and go.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. built cases support states, moves, reading, comparison, closed_region, forms_change. I found no matching statement for share, level, giving, cost, multiplying, no_return, both_outcomes, rank. No answer rests on prose alone or was unreached.
  - *pass b:* All answered from statements of the built model. Read whole (246 lines, all statements).
