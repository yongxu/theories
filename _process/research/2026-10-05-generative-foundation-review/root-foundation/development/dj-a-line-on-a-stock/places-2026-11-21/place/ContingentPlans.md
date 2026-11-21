# ContingentPlans

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ContingentPlans.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-02, as "ContingentPlans.lean: selected_iff_completes, selected_executes, branch_incompatible" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-02.md.txt)); pass b: reader whole-b-07, as "ContingentPlans.lean: Plan, Interface, run, process, Completes, run_iff_trace, passes_iff_completes, valid_iff, choose, selected_iff_completes, none_selected_iff, selected_completes, branch_congr, branch_incompatible" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-07.md.txt)); the third pass, where the two differed: reader whole-c-settle-03, as "ContingentPlans.lean: settled fields both_outcomes, rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-03.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `run_iff_trace` (l. 129) characterizes execution of any probe-and-respond plan by a two-action trace through its interface. `selected_iff_completes` (l. 201) gives selection exactly when a listed plan reaches achievement from every member of a nonempty belief.
  - *pass b:* The module states, in general for every interface (probe a query, get an answer and a next configuration; respond), that a plan's run is a trace of the interface's process. A plan passes exactly where it completes, and is valid for a listed belief exactly where the belief is not empty and it completes from every configuration listed. Selection takes the first valid plan: some plan is selected exactly where some listed plan completes from every configuration of a nonempty belief, and equal answers select the same response.
- **moves**
  - *pass a:* S: `selected_executes` (l. 189) gives the probe, its returned state and answer, the selected response and its achieved endpoint for every believed start of a selected plan.
  - *pass b:* S: `process` (l. 115): the interface as a Process with moves Sum (Q × Bool) A (probe with an answer, or respond). `run_iff_trace` (l. 129): run m p s = some t exactly where, for some answer, a trace of the plan's two moves leads from s to t. `selected_iff_completes` (l. 201): choose returns some plan exactly where some listed plan completes from every configuration of a nonempty belief. `selected_completes` (l. 218): a selected plan is listed and completes from every believed configuration.
- **a reading**
  - *pass a:* S: `branch_congr` and `branch_incompatible` (ll. 230, 234) give identical responses on equal answers for a fixed plan and exclude satisfying two incompatible requirements with that response.
  - *pass b:* S: `branch` (l. 54) chooses the response by the answer the probe returns. `branch_congr` (l. 230): equal answers select the same response. `branch_incompatible` (l. 234): one response cannot meet two incompatible requirements. `valid_iff` (l. 155): validity for a belief (a listed set of configurations) is completion from each one listed. `empty_belief_none` (l. 182): an empty belief selects no plan.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
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
  - *settled by the third pass:* N for going on and ending or keeping and losing. S of another thing, general for every `Interface S Q A`, belief list and plan list: `selected_iff_completes` (l. 201) states `(choose m states plans).isSome = true ↔ ∃ p, p ∈ plans ∧ states ≠ [] ∧ ∀ s, s ∈ states → Completes m p s`, and `none_selected_iff` (l. 210) its other half; the two outcomes are a plan selected and none selected. Both passes describe these two statements alike. [which pass was right: b; opened: selected_iff_completes l. 201; none_selected_iff l. 210; valid_iff l. 155; passes_iff_completes l. 146]
  - *pass a:* S: `selected_iff_completes` and `none_selected_iff` (ll. 201, 210) characterize success and failure of selection for the same interface, belief and candidate list.
  - *pass b:* N: no exactly-when of going on and ending. S, a dichotomy of selection: `selected_iff_completes` (l. 201) and `none_selected_iff` (l. 210).
- **a comparison between two**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a rank (an ending within a bound)**
  - *settled by the third pass:* S, in a weaker form: `selected_completes` (l. 218), premise `choose m states plans = some p`, states `states ≠ [] ∧ p ∈ plans ∧ ∀ s, s ∈ states → Completes m p s`, where `Completes` (l. 125) is `∃ answer t, Trace (process m) s (moves p answer) t ∧ m.achieved t = true` and `moves` (l. 121) is a list of two moves. So an achieved configuration is reached in two moves; the bound sits in the definition, nothing ends and no rank falls. [which pass was right: both in part; opened: moves l. 121; Completes l. 125; selected_completes l. 218; chosen_sound l. 174; run_iff_trace l. 129]
  - *pass a:* S: `Completes` and `moves` (ll. 125, 121) require an achieved endpoint after exactly two actions for a completing plan; `selected_completes` (l. 218) gives this on every believed start of a chosen plan.
  - *pass b:* N
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, moves, reading, both_outcomes, rank. I reached all fourteen questions.
  - *pass b:* All statements, docstrings and the opening read (241 lines). Answers are from statements.
