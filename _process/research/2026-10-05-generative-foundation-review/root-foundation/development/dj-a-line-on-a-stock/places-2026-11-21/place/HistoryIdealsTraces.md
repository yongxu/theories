# HistoryIdealsTraces

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HistoryIdealsTraces.lean`
- *result records that name this place's file as a source* (computed; not a link): `a-history-read-off-its-finite-stretches`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-07, as "HistoryIdealsTraces.lean: classification, run_goesOn, countdown_ends, history_without_run" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-07.md.txt)); pass b: reader whole-b-26, as "HistoryIdealsTraces.lean: HistoryOf, classification, run_goesOn, countdown, countdown_ends, history_without_run" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-26.md.txt)); the third pass, where the two differed: reader whole-c-settle-10, as "HistoryIdealsTraces.lean: settled fields level" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-10.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `classification` (l. 50) represents an ideal contained in the feasible words from s as a finite or infinite move history from s, given a longest member or member words picked beyond every length. B: `history_without_run` (l. 127) gives a countdown with all initial words of the infinite unit sequence feasible from none and no run starting there.
  - *pass b:* S, general: for every process, an ideal of the courses feasible from s that settles, or goes on with a course of each length picked, is a history of the process from s (`classification`, l. 50). The moves of every run are a history from its start that goes on (`run_goesOn`, l. 81). B: the built `countdown` shows the converse fails: every course can be feasible while no run exists (`history_without_run`, l. 127).
- **moves**
  - *pass a:* S: `run_initial_trace` (l. 66) makes each length-k initial word of a run's actions from n a trace from its state at n to its state at n+k.
  - *pass b:* S: `HistoryOf` (l. 45) is a history of a `Process` read by its moves only. B: `countdown` (l. 90): from `none` the process may go to any count, then counts down. `history_without_run` (l. 127): every course of `()`s is feasible from `none`, yet no run starts there. No general law says what a choice keeps.
- **a reading**
  - *pass a:* S: `run_goesOn` (l. 81) gives both unboundedness of the run's move ideal and `HistoryOf` for its infinite action word. B: `history_without_run` (l. 127) separates feasibility read from move prefixes from existence of one state run realizing them.
  - *pass b:* S: `HistoryOf` (l. 45) reads histories by their moves only. B: `history_without_run` (l. 127): reading by moves does not decide whether a run exists. D: the opening account contrasts this reading with the stretches, where configurations are part of the history.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *settled by the third pass:* B: `countdown` (l. 90): `Process (Option Nat) Unit` whose step goes from `none` to any `some _`, from `some (n+1)` to `some n` only, and from `some 0` nowhere. `countdown_down` (l. 100): `Trace countdown (some k) (initialWord (fun _ => ()) k) (some 0)`; `countdown_ends` (l. 105): for every `r : Run countdown`, `∀ k m, r.state m ≠ some k`. A count that runs down by one a step in one built process; nothing comes back, so the clause 'what comes back depending on what is left' is not met. [which pass was right: b; opened: countdown l.90; countdown_down l.100; countdown_ends l.105; history_without_run l.127; variable l.41]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* B: `countdown` (l. 90): a count falls by one each step, and nothing steps on from zero. Nothing comes back.
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
  - *pass a:* B: `countdown_ends` (l. 105) concludes no run can be at any numeric count at any index, and `history_without_run` (l. 127) concludes no run starts at none. `countdown` (l. 90) supplies the decrement and absence of a step at zero.
  - *pass b:* B: `countdown_ends` (l. 105): no run of `countdown` is ever at a count, because from a count every course ends at zero, where no step is possible. This is concluded, at the lowest level.
- **both outcomes**
  - *pass a:* S: `classification` (l. 50) represents a feasible ideal by a `HistoryOf` under the stated longest-or-picked disjunction. In its infinite branch the conclusion is feasibility of every initial word.
  - *pass b:* B: `history_without_run` (l. 127): one model where every course goes on as a feasible word while, as a run, it cannot go on. It is not stated as an exactly-when.
- **a comparison between two**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the contrast between the word half and the stretches is D only (opening account).
- **a rank (an ending within a bound)**
  - *pass a:* B: `countdown` (l. 90) requires a successor count to drop by exactly one and forbids a move at zero. `countdown_down` (l. 100) gives a length-k trace from k to zero.
  - *pass b:* B: `countdown_down` (l. 100): from `some k`, a trace of k moves reaches `some 0`, where the course ends. The count is a variant that falls to a bound.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all statements and their docstrings. General statements cover states, moves, reading, both_outcomes. Built cases cover states, reading, no_return, rank. I found no matching claim for share, level, giving, cost, multiplying, comparison, closed_region, forms_change. I reached all fourteen questions.
  - *pass b:* All 14 answered from statements except `comparison`, which is D; all statements read, lines 1-141.
