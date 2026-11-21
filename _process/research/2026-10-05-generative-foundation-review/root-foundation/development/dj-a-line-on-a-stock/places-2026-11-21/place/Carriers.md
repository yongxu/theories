# Carriers

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Carriers.lean`
- *result records that name this place's file as a source* (computed; not a link): `trace-law-equivalence`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-01, as "Carriers.lean: continuing_single_event_is_one_recurrence, word_feasibility_does_not_determine_endpoints, toggle_continues" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-01.md.txt)); pass b: reader whole-b-04, as "Carriers.lean: idle, static, toggle, same_carrier_incompatible_laws, continuing_single_event_is_one_recurrence, static_toggle_one_dynamics, unchanged_reads_carrier_identity, feasible_of_step_total, word_feasibility_does_not_determine_endpoints" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-04.md.txt)); the third pass, where the two differed: reader whole-c-settle-01, as "Carriers.lean: settled fields no_return, both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-01.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* Every single-action process admitting a successor at each state is bisimilar, under empty claims, to the singleton loop (`continuing_single_event_is_one_recurrence`, l. 210). Static and toggle admit the same words but disagree on the endpoint of one move (`word_feasibility_does_not_determine_endpoints`, l. 305).
  - *pass b:* On one carrier (Bool, one move) three built laws fit: idle takes no step, static keeps the configuration and toggle changes it (same_carrier_incompatible_laws). Symmetry properties do not select one law, and no state map carries static to toggle. General laws: every process with one move in which every configuration can continue is bisimilar, on frames with no claims, to the single recurring move (continuing_single_event_is_one_recurrence); total, determined and reversible gives a unique predecessor; a total process takes every word.
- **moves**
  - *pass a:* S: `feasible_of_step_total` (l. 274) gives a trace for every chosen word from every start under StepTotal.
  - *pass b:* S: Process S A in general. feasible_of_step_total (l. 274): where every configuration and move has a successor (StepTotal), every word is feasible from every configuration. total_processes_same_feasible (l. 282): any two total processes take the same words. The built processes have one move (Unit).
- **a reading**
  - *pass a:* B: `unchanged_reads_carrier_identity` (l. 249) distinguishes static and toggle by the existence of a self-step while exhibiting a bisimulation between their claim-free frames.
  - *pass b:* S: bare (l. 205) reads a process with no claims, and Bisimulation identifies configurations by how they relate to continuations. unchanged_reads_carrier_identity (l. 249): 'a step leaves the configuration unchanged' holds of static and fails of toggle, while the two are bisimilar. word_feasibility_does_not_determine_endpoints (l. 305): static and toggle take the same words and end differently, so what feasible words register does not fix the law.
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
  - *settled by the third pass:* N: opened `idle_no_event` (l.61: `¬ Enabled idle s ()` for every s), `idle_cannot_continue` (l.267: no `states` with `states 0 = s` and every `idle.step (states n) () (states (n + 1))`), `same_carrier_incompatible_laws` (l.83), `idle_differs_from_recurrence` (l.255). `idle` has no step from any configuration from the start; nothing is had and then lost, and no configuration is reached from which a course cannot go on. [which pass was right: b; opened: idle l.53, idle_no_event l.61, same_carrier_incompatible_laws l.83, idle_differs_from_recurrence l.255, toggle_continues l.262, idle_cannot_continue l.267]
  - *pass a:* B: `idle_no_event` (l. 61) and `idle_cannot_continue` (l. 267) rule out even a first move and any continuing course for idle.
  - *pass b:* N: no irreversibility after a loss. B: idle_cannot_continue (l. 267): idle has no course of steps from any configuration; this holds from the start, not after a loss.
- **both outcomes**
  - *settled by the third pass:* B: `toggle_continues` (l.262): for every s there is `states` with `states 0 = s` and `toggle.step (states n) () (states (n + 1))` for every n, against `idle_cannot_continue` (l.267): for no s is there such a course of `idle`. Going on and not going on are shown of two built processes on the one carrier Bool, not of one model, and with no exact condition; `continuing_single_event_is_one_recurrence` (l.210) and `idle_differs_from_recurrence` (l.255) are a general one-directional law and a built refusal, not an iff. [which pass was right: b; opened: toggle_continues l.262, idle_cannot_continue l.267, idle_differs_from_recurrence l.255, continuing_single_event_is_one_recurrence l.210, static_toggle_one_dynamics l.226]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* B: toggle_continues (l. 262), a course without end from every configuration, against idle_cannot_continue (l. 267); these are two built processes. S: idle_differs_from_recurrence (l. 255): for any relation B relating some configuration, idle is not bisimilar to singletonLoop. N: no exactly-when of going on and ending for one model.
- **a comparison between two**
  - *pass a:* S: `total_processes_same_feasible` (l. 282) transfers word feasibility between any two step-total processes; `continuing_single_event_is_one_recurrence` (l. 210) supplies the full relation as a bisimulation in the specified claim-free one-move case.
  - *pass b:* S: continuing_single_event_is_one_recurrence (l. 210): every P : Process S Unit in which every configuration continues is bisimilar (relation True) to singletonLoop. static_toggle_one_dynamics (l. 226) and static_toggle_same_histories (l. 231): bisimilar, with the same feasible words from any two starts. no_state_map_identifies_static_toggle (l. 191): no f : Bool → Bool carries static's steps to toggle's.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a closed region**
  - *pass a:* B: `static_history_never_changes` (l. 73) keeps each static trajectory at its starting state.
  - *pass b:* B: static_never_changes (l. 66) and static_history_never_changes (l. 73): under static every configuration is fixed along every trace. N: no general invariant.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `toggle_continues` (l. 262) gives an infinite continuation from every Boolean state, and `toggle_always_changes` (l. 70) makes every step change state.
  - *pass b:* B: toggle_continues (l. 262) with toggle_always_changes (l. 70): toggle goes on without end and changes its configuration at every step. Read relationally it is one recurrence with static (static_toggle_one_dynamics, l. 226).
- **how it was read**
  - *pass a:* Read the opening account, all docstrings and all declaration statements. Statements support states and moves, comparison. Built statements supply reading, no_return, closed_region, forms_change. The remaining fields are N. None were unreached.
  - *pass b:* All statements read (312 lines). Every field answered from statements or built cases. N for share, level, giving, cost, multiplying and rank, having read every statement.
