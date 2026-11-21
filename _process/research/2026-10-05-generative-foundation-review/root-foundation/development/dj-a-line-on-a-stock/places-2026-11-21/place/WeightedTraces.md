# WeightedTraces

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/WeightedTraces.lean`
- *result records that name this place's file as a source* (computed; not a link): `sum-over-histories-exact`, `sums-over-histories-by-support-horizon-and-order`, `weights-count-situations`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-20, as "WeightedTraces.lean: possibility_transfer_iff, counting_transfer_iff, WeightedTraces.lumped_iff, kept_traces" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-20.md.txt)); pass b: reader whole-b-79, as "WeightedTraces.lean: possibility_transfer_iff, counting_transfer_iff, WeightedTraces.Reaches, WeightedTraces.lumped_iff, memory_not_steps, keptLaw, kept_traces" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-79.md.txt)); the third pass, where the two differed: reader whole-c-settle-29, as "WeightedTraces.lean: settled fields forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-29.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: possibility_transfer_iff and counting_transfer_iff (ll. 48, 88) equate positive transfer with existence of a length-n trace reaching a positive terminal reading, given exhaustive move and state lists and step weights reading exactly the process steps. `WeightedTraces.lumped_iff` (l. 118) gives exact reachability through a description at all horizons iff at one move, for Boolean step readings with the same coverage and a representative of each description.
  - *pass b:* S: For any Process S A whose steps are read by possibility weights, with every move and configuration listed, the possibility transfer after n steps holds exactly where a trace of n moves reaches a configuration where the reading holds (possibility_transfer_iff); the count of courses is nonzero exactly where such a course exists (counting_transfer_iff). Lumpability of a process's reachability is exact at every n exactly where it is exact at one move (lumped_iff). These are general, with the built cases memory_not_steps and kept_traces.
- **moves**
  - *pass a:* S: `possibility_transfer_iff` (l. 48) characterizes existence of a successful choice of n moves by Boolean transfer under exact step readings and exhaustive lists. B: `WeightedTraces.kept_traces` (l. 175) allows a two-move trace from none to some b precisely when the two choices differ.
  - *pass b:* S: possibility_transfer_iff (l. 48): transfer true iff ∃ as t with as.length = n, Trace P s as t and f t, a law about some choice of moves. Reaches (l. 110): some trace of n moves from s reaches t with g (π t).
- **a reading**
  - *pass a:* S: `WeightedTraces.lumped_iff` (l. 118) makes the initial description sufficient for every finite-horizon endpoint test exactly when it suffices for every one-step test, under exact step readings, exhaustive lists and representatives.
  - *pass b:* S: lumped_iff (l. 118): with possibility weights reading P's steps, all moves and configurations listed, and representatives for π, Reaches P π g n s depends only on π s for every n and g exactly where it does for n = 1. B: memory_not_steps (l. 147): no process on one configuration has as its two-move traces exactly those whose second move differs from the first. kept_traces (l. 175): on configurations keeping the last move (keptLaw) it does.
- **a share**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a giving that is itself a going-on**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a comparison between two**
  - *pass a:* S: `WeightedTraces.lumped_iff` (l. 118) transfers existential reachability both ways between equal-description starts at every horizon under its one-step equivalence and representation premises.
  - *pass b:* S: lumped_iff (l. 118) carries reachability between two starts with one description. counting_transfer_iff (l. 88) carries between the counting and possibility weightings through support.
- **a rank (an ending within a bound)**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* B (weaker): `WeightedTraces.kept_traces` (l. 175): for a b : Bool, `Trace keptLaw none [a, b] (some b) ↔ Memory.differ a b = true`, where `keptLaw : Process (Option Bool) Bool` (l. 164) steps where the move lands as the move kept and differs from the move kept before. So in this built process a course of two moves from `none` exists exactly where the second move differs from the first, the configuration going from `some a` to `some b`. It is an alternation over two moves only; no statement says the course goes on beyond them or names a going-on that continues. [which pass was right: both in part; opened: possibility_transfer_iff (l. 48), counting_transfer_iff (l. 88), Reaches (l. 110), lumped_iff (l. 118), memory_not_steps (l. 147), keptLaw (l. 164), lands_eq (l. 166), kept_traces (l. 175); Weighted.lean: Memory.lands (l. 484), Memory.fresh (l. 489), Memory.kept (l. 495).]
  - *pass a:* B: `WeightedTraces.kept_traces` (l. 175) gives the two-step Boolean alternation from none, with the last move recorded as some b. Its stated horizon is two moves.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, moves, reading, comparison. Named cases contribute to moves, forms_change. No answer relies on prose alone. The remaining questions are N, and I reached all fourteen.
  - *pass b:* Every statement and docstring and the opening account were read; moves, reading and comparison are answered from statements, and the rest are N after reading every statement.
