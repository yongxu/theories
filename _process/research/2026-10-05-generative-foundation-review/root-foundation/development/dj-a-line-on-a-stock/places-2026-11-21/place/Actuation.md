# Actuation

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Actuation.lean`
- *result records that name this place's file as a source* (computed; not a link): `reserved-shutdown-during-recovery`
- *dynamics in the atlas that name one of those records* (computed; not a link): `recoverable-mediated-change`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-01, as "Actuation.lean: chosen_completes, protocol_exact, conserved_invariant, statewise_not_uniform" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-01.md.txt)); pass b: reader whole-b-01, as "Actuation.lean: installation, protocol_iff, run_iff, passes_iff, chosen_completes, none_chosen, conserved_invariant, protocol_completes, omitted_route_fails, late_no_trace" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-01.md.txt)); the third pass, where the two differed: reader whole-c-settle-01, as "Actuation.lean: settled fields no_return" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-01.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* For the installation process, a plan selected for a list of states has a completed trace from each member (`chosen_completes`, l. 318). For signed, current credentials on the open route, three reserve units and three time units suffice for completion (`protocol_exact`, l. 204).
  - *pass b:* One built process, `installation` on `State` with moves probe/issue/deliver/enact. Each move draws one unit of reserve and one unit of time before a deadline, and fails where its conditions do not hold. Laws over all states of this model: protocol and plan runs are traces (protocol_iff, run_iff, passes_iff), reserve + drawn is invariant, and the protocol completes under signed, current, open route, reserve ≥ 3 and three time units. The rest are computed cases.
- **moves**
  - *pass a:* B: `chosen_completes` (l. 318) gives completion from every listed start under the selected installation plan.
  - *pass b:* B (laws over all states of one model): `installation` (l.267) is a `Process State Move`. `chosen_completes` (l.318): a plan chosen for a list of states has a completed trace from each. `none_chosen` (l.325): where none is chosen for two states, no plan of the repertoire completes from both. `unsigned_no_issue`, `stale_no_issue`, `undelivered_no_enact`, `revoked_no_enact` (l.341–358) disable moves. `statewise_not_uniform` (l.512): each of two states has its own protocol trace, but no single plan completes from both.
- **a reading**
  - *pass a:* B: `run_iff` (l. 299) characterizes a run by a trace on the answer-dependent planMoves; `route_inquiry_completes_both` (l. 497) exhibits one query plan for both routes.
  - *pass b:* B: `probe` (l.123) answers whether the route is open, and a plan branches on the answer. `omitted_route_fails` (l.528): a plan selected from a list omitting the open-route state completes from the state it models and has no trace from the one it omits. `unknown_route_probes` (l.450) and `known_route_no_probe` (l.455): what is listed decides which plan is selected.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* B: `draw_eq_some` (l. 153) makes successful draw conditional on sufficient reserve and time and gives the reduced balance. No replenishment is specified.
  - *pass b:* B: `reserve` and `time`/`deadline` in State. `draw` (l.87) fails unless amount ≤ reserve and time + delay ≤ deadline. `protocol_exact` (l.204) needs reserve ≥ 3 and three time units. `late_probe_no_run` (l.469): the slow inquiry misses the deadline. `shutdown_trace` (l.551) ends with reserve 0. Nothing replenishes, so nothing comes back.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the reserve is a field. Nothing gives to it.
- **a cost to the one that keeps or gives**
  - *pass a:* B: `probe` (l. 123) charges one reserve unit and one or three time units for the route answer; `protocol_exact` (l. 204) charges three more for the completed protocol under its guards.
  - *pass b:* B: every move that draws spends the installation's own reserve and time: `move_draws` (l.408), `draw_conserves` (l.165). The inquiry costs too (`probe`). `timely_trace` (l.538) vs `late_no_trace` (l.545): an equally accurate but slower inquiry spends the time the protocol needed.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `generation` and `version` are counters (replacement_trace l.561, update_trace l.571). No units leave units.
- **a point of no return**
  - *settled by the third pass:* N: opened `late_no_trace` (l.545: no o, u with `Trace installation (start true .update 4 4) (planMoves ⟨.slow, false, true⟩ o) u`), `late_probe_no_run` (l.469), `draw_none` (l.148), `revoked_no_enact` (l.356), `conserved_invariant` (l.426), `move_draws` (l.408). `late_no_trace` is the failure of one named plan from one named start, as pass a itself says; no statement says something once lost is not regained, or that from a configuration no course completes. [which pass was right: b; opened: late_no_trace l.545, timely_trace l.538, late_probe_no_run l.469, draw_none l.148, draw_conserves l.165, stale_no_issue l.346, revoked_no_enact l.356, move_draws l.408, conserved_invariant l.426, omitted_route_fails l.528, statewise_not_uniform l.512]
  - *pass a:* B: `late_no_trace` (l. 545) rules out every trace of the specified slow plan from the supplied start. This is failure of that plan at the deadline, not irreversibility for every plan.
  - *pass b:* N: no stated irreversibility. reserve + drawn is conserved (`conserved_invariant`), but no statement says the reserve or running, once lost, is not regained.
- **both outcomes**
  - *pass a:* B: `passes_iff` (l. 309) characterizes passing for each installation plan and start by a completed trace with some answer.
  - *pass b:* B in part: `passes_iff` (l.309): a plan passes exactly when the installation has a trace along it ending completed. This is completion, not going on or ending. `timely_trace`/`late_no_trace` and `shutdown_trace` are built pairs.
- **a comparison between two**
  - *pass a:* B: `statewise_not_uniform` (l. 512) gives a protocol trace separately from both starts but rules out a single repertoire plan completing from both.
  - *pass b:* S (within the model): `protocol_iff` (l.284) and `run_iff` (l.299) carry between the partial-function protocol/run and traces of the process `installation`. `statewise_not_uniform` (l.512) compares per-state paths with a uniform plan.
- **a rank (an ending within a bound)**
  - *pass a:* B: `draw_none` (l. 148) rules out a draw exceeding the reserve or deadline. `late_no_trace` (l. 545) proves the specific slow plan misses its chance.
  - *pass b:* B: a deadline. `draw` requires time + delay ≤ deadline, `draw_conserves` (l.165) keeps time ≤ deadline, and `late_probe_no_run` (l.469) / `late_no_trace` (l.545) show runs failing on it.
- **a closed region**
  - *pass a:* B: `conserved_invariant` (l. 426) makes each fixed value of reserve plus drawn invariant under installation moves.
  - *pass b:* S (within the model): `conserved_invariant` (l.426): reserve + drawn = c is an `Invariant installation`. `conserved_trace` (l.433): every trace keeps it.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `replacement_trace` (l. 561) reaches completion at generation one and version zero; `enact` (l. 107) sets running true for replacement.
  - *pass b:* B (weak): `replacement_trace` (l.561) completes with generation advanced by one, and `update_trace` (l.571) with version advanced by one, while running stays true. These are counters, not kinds coming and going.
- **how it was read**
  - *pass a:* Read the opening account, all docstrings and all declaration statements. Statements support states. Built statements supply moves, reading, level, cost, no_return, both_outcomes, comparison, rank, closed_region, forms_change. The remaining fields are N. None were unreached.
  - *pass b:* Answered from statements of one built model (laws over all its states and computed cases). All statements were read, the whole module (581 lines).
