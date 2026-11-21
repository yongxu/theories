# ContinuingRuns

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ContinuingRuns.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-02, as "ContinuingRuns.lean: run_at, run_cycle_amounts, run_retired_choice, run_cut_stops" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-02.md.txt)); pass b: reader whole-b-08, as "ContinuingRuns.lean: run_at, run_cycle_amounts, run_method_changed, run_new_available_choice, run_retired_choice, run_no_renewal_at_cycle, run_cut_renewal, run_cut_stops, run_of_trace, run_reserve_consumed, run_frozen_no_return" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-08.md.txt)); the third pass, where the two differed: reader whole-c-settle-03, as "ContinuingRuns.lean: settled fields multiplying, rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-03.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* B: `run_at` (l. 44) identifies every dated state of the yield-nine continuing run with the corresponding phase of the cycle, and `run_cycle_amounts` (l. 51) gives exact fuel, use, receipts and carrier at each boundary. `run_cut_stops` (l. 133) excludes the next prescribed undertaking from any zero-yield renewal successor of the run’s pre-renewal state.
  - *pass b:* Facts of the built witness of ContinuingRevision at yield nine, read along its one infinite Run `continuing`. The configuration at every date of a cycle is that cycle's (`run_at`), with fixed amounts at each cycle's start, a changed method, and a gained and a retired choice. The controls: no renewal at a cycle's start, a cut return leaving no fuel and stopping the next undertaking, and one extra use of fuel or a frozen plan making no course. All are of one built model; only `run_of_trace` is stated for every yield of that process.
- **moves**
  - *pass a:* B: `run_no_renewal_at_cycle` (l. 107) excludes renewal as a move from every cycle start; `run_frozen_no_return` (l. 162) excludes the specified frozen action sequence.
  - *pass b:* S: `run_of_trace` (l.146): for every yield, every Trace of `ContinuingRevision.P yield` is what the executed function `run` returns. B: `run_reserve_consumed` (l.155) and `run_frozen_no_return` (l.162): the move lists `erase :: word 0` from date 0, and the frozen list from date 1, are no course of `P 9`.
- **a reading**
  - *pass a:* B: `run_new_available_choice` (l. 71) gives selection through installed contacts at the next address once installed; `run_retired_choice` (l. 90) loses the old address at the next cycle start.
  - *pass b:* B: `run_new_available_choice` (l.71): at date 7n+5 the selection at address n+1 is Through `alikeOnInstalled` of the installed contacts, and at date 7n it is not. `run_retired_choice` (l.90): at date 7(n+1) the selection at n no longer is.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* B: `run_cycle_amounts` (l. 51) gives nine fuel at every boundary; `run_cut_renewal` (l. 116) gives a zero-yield successor with zero fuel and disabled renewal.
  - *pass b:* B: `run_cycle_amounts` (l.51): at date 7n, fuel 9, used 9n+6, received 9n, carrier n. `run_cut_renewal` (l.116): from date 7n+6, renewal with yield 0 leaves fuel 0. `run_reserve_consumed` (l.155).
- **a giving that is itself a going-on**
  - *pass a:* D: The opening account names successful activity as enabling renewal in the imported process. The local controls show when particular renewal moves are unavailable.
  - *pass b:* B: `run_no_renewal_at_cycle` (l.107): at each cycle's start, renewal is no step (it needs a success first). `run_cut_renewal` (l.116): with the return cut, renewal enables nothing.
- **a cost to the one that keeps or gives**
  - *pass a:* B: `run_cycle_amounts` (l. 51) gives nine additional units used per carrier and nine received; `run_reserve_consumed` (l. 155) excludes prefixing the cycle with one extra erase.
  - *pass b:* B: `run_reserve_consumed` (l.155): one extra use of the process's own fuel before a cycle makes the cycle no course. `run_cycle_amounts` (l.51): used grows by 9 each cycle.
- **multiplying**
  - *settled by the third pass:* B, in a weaker form: `run_cycle_amounts` (l. 51) states that at `continuing.state (7 * n)` the fuel is 9, used is `9 * n + 6`, received is `9 * n` and `carrier = n`. The carrier index counts successive replacements along the one built run; there is one carrier at a time and no number of units changing by the step. [which pass was right: both in part; opened: run_cycle_amounts l. 51; run_at l. 44; run_method_changed l. 60]
  - *pass a:* B: `run_cycle_amounts` (l. 51) gives carrier n at time 7n, counting successive carriers along this run.
  - *pass b:* N
- **a point of no return**
  - *pass a:* B: `run_cut_stops` (l. 133) concludes impossibility of the next undertaking after zero-yield renewal; it does not quantify over every alternative move.
  - *pass b:* B (concluded): `run_cut_stops` (l.133): with the return cut, after the renewal from date 7n+6 the next undertaking is no step. `run_frozen_no_return` (l.162), `run_reserve_consumed` (l.155). Each concerns one named next move or move list, not every course; the loss is of the return or of the reserve.
- **both outcomes**
  - *pass a:* B: `run_at` (l. 44) identifies the continuing yield-nine course; `run_cut_renewal` and `run_cut_stops` (ll. 116, 133) give its zero-yield control at each renewal. D: The opening attributes the cycle threshold iff to the imported module.
  - *pass b:* B: the run goes on at yield 9 (`run_at`, `run_cycle_amounts`), and from the same configuration at yield 0 it stops (`run_cut_renewal`, `run_cut_stops`). These are separate statements, not one exactly-when.
- **a comparison between two**
  - *pass a:* B: `run_cut_renewal` (l. 116) takes the same pre-renewal state of the yield-nine run as a start for zero-yield renewal; `run_cut_stops` (l. 133) excludes the next undertaking there.
  - *pass b:* S: `run_of_trace` (l.146) carries every Trace of the process to the executed function. B: `run_at` (l.44) maps the clock orbit from (n, ready) onto the run's states; `run_cut_renewal` compares yield 9 and yield 0 from the same state.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* B: `run_cut_stops` (l. 133), premise `(ContinuingRevision.P 0).step (continuing.state (7 * n + 6)) .renew t`, states `¬ ∃ u, (P 0).step t (.native (.perform (t.carrier + 1) true)) u`; `run_cut_renewal` (l. 116) states that such a `t` exists with `t.work.fuel = 0 ∧ t.enabled = false`. So in the built run, with the yield cut to zero, the fuel is drained and the next undertaking is no step; only that one move is stated blocked, and no falling variant or bound is stated in this module. [which pass was right: a; opened: run_cut_renewal l. 116; run_cut_stops l. 133; run_no_renewal_at_cycle l. 107; run_reserve_consumed l. 155; run_frozen_no_return l. 162; run_of_trace l. 146]
  - *pass a:* B: `run_cut_stops` (l. 133) sets the stopping point of the specified undertaking immediately after the zero-yield renewal.
  - *pass b:* N
- **a closed region**
  - *pass a:* B: `run_cycle_amounts` (l. 51) gives the invariant fuel value nine at seven-step cycle boundaries of this run.
  - *pass b:* B: `run_at` (l.44): at every date of cycle n, the run is at the configuration that the clock orbit from (n, ready) exposes, so the cycle's configurations recur for every n.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `run_method_changed` (l. 60), `run_new_available_choice` (l. 71) and `run_retired_choice` (l. 90) show the method, available address and retired address changing each cycle while the carrier index continues to increase (l. 51).
  - *pass b:* B: `run_method_changed` (l.60), `run_new_available_choice` (l.71), `run_retired_choice` (l.90) and `run_cycle_amounts` (carrier = n, l.51): along one run that goes on, the carrier, the method and the available choices change every cycle.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Built-case answers cover states, moves, reading, level, cost, multiplying, no_return, both_outcomes, comparison, rank, closed_region, forms_change. Account or docstring evidence covers giving, both_outcomes. I reached all fourteen questions.
  - *pass b:* All 14 questions were answered from statements or built cases. I read all statements, l.1-170.
