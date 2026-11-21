# ReferencePlanTraces

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReferencePlanTraces.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-15, as "ReferencePlanTraces.lean: step_iff, repair_iff, revise_gains_contact, small_support_no_repair" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-15.md.txt)); pass b: reader whole-b-57, as "ReferencePlanTraces.lean: step_iff, run_iff, repair_iff, chosen, revise_registers, revise_keeps_selections, revise_gains_contact, frozen_leaves_unregistered, checked_drives, drift_misses, history_uses_fuel" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-57.md.txt)); the third pass, where the two differed: reader whole-c-settle-22, as "ReferencePlanTraces.lean: settled fields rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-22.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `run_iff` (l. 92) and `repair_iff` (l. 172) identify execution with traces of the reference-plan process and repair with length-indexed traces of its chosen policy. B: `rounds_change_method` (l. 399) gives the successive methods [], [0], [1,0] in the native two-round trace.
  - *pass b:* ReferencePlan's operations are read as laws of the process P and its traces: a step is an operation with the fuel it uses, executed sequences are exactly the traces, and repairs of n steps are exactly the policy process `chosen`'s traces of length n. Every revise step registers the failed address, keeps old selections and gains a new contact's choice; every frozen step leaves some failure unregistered; a low-reference key drives every target iff the references differ, and after drift misses every target. These are laws over all states of one built model, with the native history and controls as built traces.
- **moves**
  - *pass a:* S: `chosen` (l. 135) restricts P to the policy’s chosen acts. `revise_keeps_selections` (l. 220) carries every selection reading through the old method across every revision step.
  - *pass b:* S: `chosen` (l. 135), the policy's process. `repair_iff` (l. 172): repair n s = some t ↔ a `chosen` trace of length n. `frozen_leaves_unregistered` (l. 266): for every s there is an i such that every frozen step from s with mismatch i leaves i unregistered. `revise_keeps_selections` (l. 220): every revise step keeps every old selection. `enabled_iff` (l. 85).
- **a reading**
  - *pass a:* S: `revise_binds_plan` (l. 193) puts the held mismatch at the head of both method and pending plan while keeping the installed device. `checked_drives` (l. 295) characterizes target agreement for a ready, fueled state keyed to its low reference.
  - *pass b:* S: `revise_registers` (l. 212): a revise step's method registers the failed address. `revise_gains_contact` (l. 239): with i ∉ s.method, the new method can select at i and the old cannot. `checked_drives` (l. 295): with key = low reference, not building and fuel ≥ 1, every perform meets its target iff the references differ. B: `first_round_registers` (l. 419), `second_round_registers` (l. 428).
- **a share**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N.
- **a level that runs down**
  - *pass a:* S: `enabled_iff` (l. 85) requires enough fuel and a successful operation. `step_iff` (l. 64) gives the successor precisely with the draw subtracted from fuel and added to use.
  - *pass b:* S: `step_iff` (l. 64): a step needs use a ≤ fuel and moves `use a` from fuel to used. N: no replenishment, so nothing comes back. B: `history_uses_fuel` (l. 453): the native history ends with fuel 15 and used 15, none restored. `small_support_no_repair` (l. 491).
- **a giving that is itself a going-on**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N.
- **a cost to the one that keeps or gives**
  - *pass a:* B: `constant_channel_uses_fuel` (l. 510) gives a two-step policy trace with fuel spent, a failed check and an empty installation. `small_support_uses_fuel` (l. 496) exhibits complete expenditure before installation.
  - *pass b:* S: `step_iff` (l. 64): each act draws on the state's own fuel. B: `small_support_uses_fuel` (l. 496) and `constant_channel_uses_fuel` (l. 510): contacts use fuel while nothing is installed.
- **multiplying**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N.
- **a point of no return**
  - *pass a:* B: `small_support_no_repair` (l. 491) excludes every three-step policy trace from the given low-fuel start. `erased_no_repair` (l. 483) concludes no policy move after the specified erasure, and `exhausted_not_enabled` (l. 517) rules out the specified performance at zero fuel.
  - *pass b:* S: `drift_misses` (l. 318): after a drift step, a key checked against separated references misses every target (concluded, for all states). B: `exhausted_not_enabled` (l. 517): with fuel 0, no perform. `erased_no_repair` (l. 483): after erasing failedFirst's mismatch, the policy has no step. Low level, not the loss of a giver.
- **both outcomes**
  - *pass a:* S: `enabled_iff` (l. 85) gives exact one-step continuation for each act in P. `checked_drives` (l. 295) gives exact correctness of all targets under the key, readiness and fuel hypotheses.
  - *pass b:* S: `checked_drives` (l. 295) is an exactly-when of meeting every target. N: none of going on and ending.
- **a comparison between two**
  - *pass a:* S: `run_iff` (l. 92) preserves and reflects endpoints for each action sequence. `revise_keeps` (l. 230) carries distinctions from each old method to its revision.
  - *pass b:* S: `revise_keeps` (l. 230): `Registration.Keeps AgreeOn s.method t.method` for every revise step. `revise_keeps_selections` (l. 220). `run_iff` (l. 92) and `repair_iff` (l. 172) carry the source's functions to traces. `trace_unique` (l. 102).
- **a rank (an ending within a bound)**
  - *settled by the third pass:* B: `small_support_no_repair` (l. 491): `¬ ∃ as t, as.length = 3 ∧ Trace chosen { failedFirst with fuel := 3 } as t`; `exhausted_not_enabled` (l. 517): no `.perform 0 true` enabled at fuel 0; `first_repair` (l. 367) and `second_repair` (l. 372) give the exact ends of the policy's traces of length 3 and 4. Of the one model's process `ReferencePlan.P`, `step_iff` (l. 64) states every step needs `use a ≤ s.fuel` and leaves `fuel := s.fuel - use a`, but no statement here bounds the length of a trace by the fuel. [which pass was right: a; opened: step_iff (l. 64), enabled_iff (l. 85), chosen (l. 135), repair_iff (l. 172), no_repair_of (l. 185), first_repair (l. 367), second_repair (l. 372), history_uses_fuel (l. 453), small_support_no_repair (l. 491), small_support_uses_fuel (l. 496), exhausted_not_enabled (l. 517). Pass b's B part names the same built case; its N is of a general law only.]
  - *pass a:* B: `first_repair` (l. 367) and `second_repair` (l. 372) give exact trace endpoints at lengths 3 and 4. `small_support_no_repair` (l. 491) excludes length 3 for the first low-fuel control.
  - *pass b:* N: no general bound law here (the fuel cover is in ReferencePlan's `covered`). B: `small_support_no_repair` (l. 491): with fuel 3, no 3-step repair.
- **a closed region**
  - *pass a:* N: Not found among this module’s statements.
  - *pass b:* N.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* S: `revise_gains_contact` (l. 239) gains a choice at a previously absent failed address. B: `second_round_registers` (l. 428) witnesses the new installed distinction, and `finished_trace` (l. 383) gives subsequent uses of both addresses.
  - *pass b:* S: `revise_gains_contact` (l. 239): each revise step at a new address widens what the method can select. B: `rounds_change_method` (l. 399): along traces from `initial` the method is [], then [0], then [1,0]. `first_round_installs_contact` (l. 410), `second_round_meets` (l. 443).
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, moves, reading, level, both_outcomes, comparison, forms_change. Built cases support states, cost, no_return, rank, forms_change. The remaining findings are N. No question was unreached.
  - *pass b:* Answered from statements: states, moves, reading, level, cost, no_return, both_outcomes, comparison, forms_change. Built only: rank. N for share, giving, multiplying, closed_region. Read the whole module (522 lines).
