# RouteTraces

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/RouteTraces.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-17, as "RouteTraces.lean: within_trace, possibility_within_trace, scheduleWorld_le_always" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-17.md.txt)); pass b: reader whole-b-65, as "RouteTraces.lean: within_trace, possibility_within_trace, selfLoopWorld_geomBound, selfLoopWorld_mono, scheduleWorld_le_always" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-65.md.txt)); the third pass, where the two differed: reader whole-c-settle-24, as "RouteTraces.lean: settled fields multiplying, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-24.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For every process with complete move and state listings and nonzero combined weights exactly on its steps, a positive order-j count at horizon n implies an actual length-n trace to positive terminal amount (`within_trace`, l. 46). The always-coupled self-loop world has the full-order geometric standing and bounds arbitrary schedules (`selfLoopWorld_geomBound`, l. 75, `scheduleWorld_le_always`, l. 98).
  - *pass b:* A general law: for any process P whose counting weights (ground plus response) are nonzero exactly at P's steps, with every move and configuration listed, a nonzero order of the sum over histories gives a trace of P of n moves to a configuration where f is nonzero. The same holds read as possibility. Built laws of FormedLoops' self-loop world: it stands at Loops.geomBound D(1+M)^t, never falls, equals the full order, and on any schedule stands at most at D(1+M)^t.
- **moves**
  - *pass a:* S: `within_trace` (l. 46) supplies a list of n actual moves to a positive endpoint under the complete listings, support equivalence and positive ordered count.
  - *pass b:* S: `within_trace` (l. 46): for every `Process S A` meeting the weight-reading premise, with every move and configuration listed, a nonzero order at s after n steps gives some trace of n moves from s to a t with f t nonzero. This is an existence of a course, not a law of what a choice keeps.
- **a reading**
  - *pass a:* S: `possibility_within_trace` (l. 59) reads each weight and terminal amount through nonzero; truth of the resulting possibility order implies such a trace under the same listing and support conditions.
  - *pass b:* S: `possibility_within_trace` (l. 59): the possibility order, read off whether each count is zero (through `Weights.Hom.within` of the support reading), holds only along courses P has.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no level running down. B, a rising level: `selfLoopWorld_geomBound` (l. 75) and `selfLoopWorld_mono` (l. 82): the self-loop world's level never falls.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N in what was read. FormedLoops.scheduleWorld was not opened.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *settled by the third pass:* B, in a different form: `selfLoopWorld_geomBound` (l. 75) states `(FormedLoops.scheduleWorld (fun _ => true) M D).web.level t (.inr ()) = Loops.geomBound M D t`, where `Loops.geomBound` (Loops.lean l. 767) is `D` at 0 and `geomBound M D t + M * geomBound M D t` after: the one level of a built world multiplied by `1 + M` at each step. No units leave units and no kinds form kinds; no count of things changes by a law of the step. [which pass was right: both in part; opened: `within_trace` (l. 46), `possibility_within_trace` (l. 59), `selfLoopWorld_geomBound` (l. 75), `selfLoopWorld_full_order` (l. 90), `scheduleWorld_le_always` (l. 98); `Loops.geomBound` (Loops.lean l. 767), `Loops.geomBound_eq` (l. 824), `FormedLoops.scheduleWorld` (l. 130), `scheduleWorld_course` (l. 137).]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* B: `selfLoopWorld_geomBound` (l. 75): the level is D multiplied by (1+M) at each step. A level multiplying, not units leaving units.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a comparison between two**
  - *pass a:* B: `scheduleWorld_le_always` (l. 98) bounds any Boolean schedule for this self-loop by D(1+M)^t, the all-on standing of `selfLoopWorld_geomBound` (l. 75).
  - *pass b:* S: `within_trace` (l. 46) carries from nonzero weights to traces of the process. B: `scheduleWorld_le_always` (l. 98): the self-loop world on any schedule stands at most where coupling at every step does.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the bounds are upper bounds on growth, not on ending.
- **a closed region**
  - *settled by the third pass:* B, in a weaker form: `selfLoopWorld_mono` (l. 82) states for `s ≤ t` that the level of `FormedLoops.scheduleWorld (fun _ => true) M D` at `(.inr ())` at `s` is at most its level at `t`: the standing of one built world never falls. That gives each lower bound kept at later steps, but the statement is a monotonicity along one course with no choice; no region closed under a step, kernel, certificate or fixed point is stated. `within_trace` (l. 46) and `possibility_within_trace` (l. 59) conclude the existence of a trace, not an invariant. [which pass was right: both in part; opened: `within_trace` (l. 46), `possibility_within_trace` (l. 59), `selfLoopWorld_geomBound` (l. 75), `selfLoopWorld_mono` (l. 82), `selfLoopWorld_full_order` (l. 90), `scheduleWorld_le_always` (l. 98): all six declarations of the module; `Loops.geomBound_mono` (Loops.lean l. 792).]
  - *pass a:* B: `selfLoopWorld_mono` (l. 82) keeps every lower bound already attained by this always-coupled world at every later time.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and docstrings. S for states, moves, reading. N for share, level, giving, cost, multiplying, no_return, both_outcomes, rank, forms_change. B for comparison, closed_region.
  - *pass b:* From statements throughout (S, B or N); `giving` covers only what was read here, since FormedLoops was not opened. All statements were read (all 106 lines).
