# ContextualRuns

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ContextualRuns.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-02, as "ContextualRuns.lean: noGlobal_run_iff, cycle_run_iff, chsh_run_le" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-02.md.txt)); pass b: reader whole-b-07, as "ContextualRuns.lean: chsh_run_le, specker_run_le, square_run_le, cycle_run_le, cycle_run_iff, specker_respecting_not_free, square_respecting_not_free, noGlobal_run_iff, passes_glued, specker_not_passes, square_not_passes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-07.md.txt)); the third pass, where the two differed: reader whole-c-settle-03, as "ContextualRuns.lean: settled fields moves, share, both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-03.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `noGlobal_run_iff` (l. 170) characterizes failure of every respecting contextual system to be context-free at a run step by a contradictory selection of contexts, with decidable claim equality, distinct listed claims and covered contexts. `chsh_run_le` (l. 76) bounds the total pairs won under any context-free description of an n-step prefix by 3n.
  - *pass b:* The module states, for every run of every process, Bell-type bounds on any context-free description of its configurations over the first n steps (CHSH at most three of four pairs on average; Specker two of three; the square five of six; a cycle with odd polarity n of n+1). It also states that systems respecting the built parity possibilities are context-free at no step, and gives general parity laws on runs (noGlobal_run_iff, cycle_run_iff). The laws are general over processes and runs, instantiated at the built parity systems of Gluing and Context.
- **moves**
  - *settled by the third pass:* N: `cycle_run_iff` (l. 106, variables `{σ A : Type} {P : Process σ A}`) quantifies over `r : Run P` and uses only `r.state t`; the run's acts do not appear and nothing is said of what a choice keeps. Opened to rule it out: `cycle_run_iff` (l. 106), `chsh_run_le` (l. 76), `noGlobal_run_iff` (l. 170), `passes_glued` (l. 188), `specker_not_passes` (l. 199). [which pass was right: b; opened: cycle_run_iff l. 106; chsh_run_le l. 76; noGlobal_run_iff l. 170; passes_glued l. 188; specker_not_passes l. 199]
  - *pass a:* S: `cycle_run_iff` (l. 106) holds along any run of any Process S A, independently of its moves; all cycle constraints can be met at every time by one context-free description exactly for even polarity.
  - *pass b:* N: runs of any Process P are quantified over, with no choice among steps and no law about what a choice keeps.
- **a reading**
  - *pass a:* S: `passes_local` (l. 193) gives locality of the restriction of a run’s context-free readings, and `noGlobal_run_iff` (l. 170) characterizes the parity obstruction to a context-free reading.
  - *pass b:* S: `noGlobal_run_iff` (l. 170): for a parity system with claims listed without repetition and contexts listed, every contextual system respecting the possibilities at step t of a run fails to be context-free there exactly where some selection of contexts contradicts. `specker_respecting_not_free` (l. 151) and `square_respecting_not_free` (l. 160): a system respecting those possibilities at a step of a run is not FreeAt there. `cycle_run_iff` (l. 106): some context-free description val meets every relation of a cycle at every step exactly where the polarity is even.
- **a share**
  - *settled by the third pass:* N for the field read whole: no rule or favouring is set again from a count. S of a count only: `chsh_run_le` (l. 76), for every `val` and every `r : Run P`, states `total (readings val r n) (fun v => total CHSH.pairs (fun k => cond (CHSH.paritySystem.met k v) 1 0)) + n ≤ n * 4`; likewise `specker_run_le` (l. 82), `square_run_le` (l. 89), `cycle_run_le` (l. 97, premise odd polarity), all through `along_le` (l. 64). [which pass was right: both in part; opened: along_le l. 64; chsh_run_le l. 76; specker_run_le l. 82; square_run_le l. 89; cycle_run_le l. 97]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: `chsh_run_le` (l. 76): for any val and any run, over the first n steps the total number of CHSH pairs won, plus n, is at most 4·n, so at most three of four on average. Likewise `specker_run_le` (l. 82), `square_run_le` (l. 89) and `cycle_run_le` (l. 97), all through `along_le` (l. 64). N: no rule or favouring is set again from that count.
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
  - *settled by the third pass:* N for going on and ending or keeping and losing. S of another thing: `cycle_run_iff` (l. 106), for any `r : Run P`, states that some `val : σ → Nat → Bool` meets every relation of `Gluing.Cycle.system n pol close` at every `r.state t` exactly when `Gluing.Cycle.polarity n pol close = false`; it is an exactly-when of a context-free description existing, and the process plays no part. `noGlobal_run_iff` (l. 170) is of the same kind. [which pass was right: b; opened: cycle_run_iff l. 106; noGlobal_run_iff l. 170]
  - *pass a:* S: `cycle_run_iff` (l. 106) gives both possibilities for meeting every listed cycle relation throughout one run, according to cycle polarity.
  - *pass b:* N: no exactly-when of going on and ending. S, of other things: `cycle_run_iff` (l. 106) and `noGlobal_run_iff` (l. 170).
- **a comparison between two**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the bounds are averages over n steps, not endings.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, moves, reading, both_outcomes. I reached all fourteen questions.
  - *pass b:* All statements, docstrings and the opening read (211 lines). Answers are from statements.
