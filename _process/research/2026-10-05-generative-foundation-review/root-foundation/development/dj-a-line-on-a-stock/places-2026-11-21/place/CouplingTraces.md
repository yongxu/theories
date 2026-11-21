# CouplingTraces

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/CouplingTraces.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-03, as "CouplingTraces.lean: coupledIntoBy_iff_trace, loop_succ_reads, settled_every_iff_steps, standing_no_loop_traces" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-03.md.txt)); pass b: reader whole-b-11, as "CouplingTraces.lean: couplingProcess, retraceProcess, chain_iff_trace, upstream_iff_reach, onLoop_iff_trace, coupledIntoBy_iff_trace, loop_forms_by_closing, loop_succ_reads, standing_no_loop_traces, settled_every_iff_steps, stops_not_recurs" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-11.md.txt)); the third pass, where the two differed: reader whole-c-settle-04, as "CouplingTraces.lean: settled fields no_return, rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-04.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `upstream_iff_reach` (l. 130), `onLoop_iff_trace` (l. 142) and `coupledIntoBy_iff_trace` (l. 164) identify upstream reach, a nonempty return and a time-ordered chain with their respective process traces. `settled_every_iff_steps` (l. 418) makes universal settling with an exhaustive condition listing equivalent to RecursOrStops.
  - *pass b:* The module reads coupling strengths as a process (`couplingProcess`) and chains in time order as traces back in time of a `retraceProcess`. It restates the loop, closing, threshold, observation, remainder and frequency laws as laws of the traces, general for every strengths array, with a few built cases (onset, draw, measurement, once, self-loop).
- **moves**
  - *pass a:* S: `couplingProcess` (l. 125) labels steps by coupling times. `standing_no_loop_traces` (l. 317) confines every reachable endpoint from the marked stock to itself under ReadsBelow, unique marking and the stated response-strength bounds on the standing law.
  - *pass b:* S: `couplingProcess` (l. 125) is a `Process C Nat` stepping from d to c by the step u at which d is coupled into c. `chain_iff_trace` (l. 85), for every `Process`: a sequence whose first j successive members are steps is a trace of j moves. `upstream_iff_reach` (l. 130). No law of what a choice keeps.
- **a reading**
  - *pass a:* S: `loop_succ_reads` (l. 278) characterizes a loop by T+1 in read-restricted strengths by a prior loop or a positive coupling at T from a listed condition actually read by a present outside formation, with paths completing the loop.
  - *pass b:* S: `loop_succ_reads` (l. 278): with strengths restricted to what is read, a loop formed by T + 1 is one formed by T or one through a formation present at T that reads the level of d and gives to c, with c reaching e and e reaching d. `self_step_reads` (l. 303): a self-step under the restricted strengths is read by a formation outside the part. `standing_no_loop_traces` (l. 317): for a law reading a stock only below a threshold (`ReadsBelow`), the standing law's restricted couplings have no loop through the stock and reach nothing else from it.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a level that runs down**
  - *pass a:* N: `standing_no_loop_traces` (l. 317) uses a stock read only below a threshold. Its conclusion is about reachable conditions, and no remaining-stock-dependent replenishment law was found.
  - *pass b:* N: a stock read below a threshold θ appears in `standing_no_loop_traces` (l. 317) and `draw_loop` (l. 333), but no law here has a level running down with return depending on what is left.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the formations present (`present`) and the strengths k are handed in.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a point of no return**
  - *settled by the third pass:* S (premise only): `stops_not_recurs` (l. 465): from `stops : ∀ t u s, (retraceProcess cs part k present).step (t, c) u (s, d) → s < N`, concludes `¬ ∀ N', ∃ u, (couplingProcess cs part (strengthsFrom N' k) present).step d u c`. That no coupling of `d` into `c` reads a level from `N` on is the premise, for every later step; the conclusion is that the coupling does not recur. Nothing is concluded to be lost and not regained, and no point from which no course keeps something is stated. `once_no_retrace_of_two` (l. 432) is of a built loop and says no trace back of two steps, not an irreversibility. [which pass was right: both in part; opened: retraceProcess (l. 157), retrace_later (l. 370), recurs_iff_steps (l. 382), settled_iff_steps (l. 390), settled_zero_of_always (l. 402), settled_every_iff_steps (l. 418), once_no_retrace_of_two (l. 432), once_settled (l. 438), stops_not_recurs (l. 465); Frequency.StopsBy (l. 696), Remainder.CouplingRecurs (l. 486)]
  - *pass a:* S: `stops_not_recurs` (l. 465) concludes nonrecurrence when every backward step for the pair reads a time below N. Cessation of later readings is a premise.
  - *pass b:* N: no irreversibility of a loss. `stops_not_recurs` (l. 465): a coupling all of whose steps back read levels before N is not a step of the couplings from every step on. `once_no_retrace_of_two` (l. 432, built): the loop acting once has no trace back of two steps.
- **both outcomes**
  - *pass a:* S: `recurs_iff_steps` (l. 382) characterizes recurrence by existence of a step at every suffix. `settled_every_iff_steps` (l. 418) identifies universal settling for listed conditions with the explicit RecursOrStops principle.
  - *pass b:* S, of couplings recurring, not of a model going on or ending: `recurs_iff_steps` (l. 382): a coupling recurs exactly where it is a step of the couplings from every step on. `settled_iff_steps` (l. 390). `settled_every_iff_steps` (l. 418): every coupling process with listed conditions settles exactly where `RecursOrStops` holds (a principle of reasoning).
- **a comparison between two**
  - *pass a:* S: `retrace_later` (l. 370) carries existence of a backward trace of length j to any later starting time at the same condition; `reach_readCouplings` (l. 309) carries reach through restricted strengths to reach through read couplings by the same time.
  - *pass b:* S: `loop_iff_formed` (l. 216) and `reach_iff_formed` (l. 223): loops and reach of the coupling process are those of the strengths formed before some T. `reach_readCouplings` (l. 309): routes of strengths restricted to what is read are routes of the reading couplings. `retrace_later` (l. 370): a trace back from a level is a trace back from every later level of the condition (closed upward in time). `retrace_shorten` (l. 376).
- **a rank (an ending within a bound)**
  - *settled by the third pass:* B (different form): `once_no_retrace_of_two` (l. 432): for every `t`, the retrace process of `Loops.Once.strengths` has no trace of length 2 from `(t, ())`: traces back end within one step, in that built loop. `selfLoop_retrace_iff` (l. 449): the scheduled self-loop steps back from `(t, ())` by `u` to `(s, ())` exactly when `u < t ∧ on u = true ∧ s = u ∧ 0 < M`, so each step back lands at a strictly earlier step. Both are of traces back in time through couplings, not of a course ending. In general the fall is in the def only: `retraceProcess` (l. 157) requires `u < x.1` and `CouplesAt` gives `s ≤ u`; no general theorem states a bound. [which pass was right: both in part; opened: retraceProcess (l. 157), coupledIntoBy_iff_trace (l. 164), retrace_later (l. 370), retrace_shorten (l. 376), once_no_retrace_of_two (l. 432), selfLoop_retrace_iff (l. 449), selfLoop_returns (l. 458), stops_not_recurs (l. 465); Remainder.CouplesAt (l. 262)]
  - *pass a:* B: `once_no_retrace_of_two` (l. 432) rules out length-two backward traces at every time in the once-acting loop. `selfLoop_retrace_iff` (l. 449) makes each backward step of the scheduled self-loop go to a strictly earlier time.
  - *pass b:* N.
- **a closed region**
  - *pass a:* S: `standing_no_loop_traces` (l. 317) confines the restricted standing law's reachable region from the uniquely marked stock to that stock, given ReadsBelow and valid bounds on responses.
  - *pass b:* S: `standing_no_loop_traces` (l. 317): everything the restricted couplings reach from the stock c is c (a closed singleton). `measure_reach_before` (l. 341, built): before T the measured stock reaches only itself.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* S: `route_forms_by_closing` (l. 242) identifies an acting step at T on any newly reachable route. B: `measure_no_loop_before` (l. 348) and `measure_loop_at` (l. 355) give a new nonempty return through the stock in the measurement case.
  - *pass b:* S/B, loops forming: `loop_forms_by_closing` (l. 232, general): where the couplings formed by T + 1 have a loop through e and those formed by T have none, some step from d to c acts at T on the loop. B: `onset_forms` (l. 256) and `onset_not_formed` (l. 262): the self-loop from T on has a loop by T + 1 and none by T. `measure_loop_at` (l. 355). This is a loop coming to be, not a going-on continuing while what is present changes.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statements (1, 2, 3, 9, 10, 11, 13, 14). Built cases (12). Not found (4, 5, 6, 7, 8). Additional evidence is marked within 14. I reached all fourteen questions.
  - *pass b:* Answered from statements: states, moves, reading, both_outcomes (as recurrence), comparison, closed_region, forms_change (as loops forming); the rest are N. All statements read, all 489 lines.
