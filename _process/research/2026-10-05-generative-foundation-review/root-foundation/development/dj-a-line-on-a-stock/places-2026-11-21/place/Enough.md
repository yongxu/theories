# Enough

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Enough.lean`
- *result records that name this place's file as a source* (computed; not a link): `the-boundary-of-enough-under-undetermined-laws`, `what-a-method-comes-to-say-in-the-limit`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-run-round-a-loop-keeps-changing`, `seeking-boundary`

## 21 November, a future opening or closing: reader courses-still-open

*As "Enough.lean". A reader's return, unchecked; what the note mended is in the note: [note](../../read-a-future-2026-11-21/NOTE.md), [report](../../read-a-future-2026-11-21/read-courses-still-open.md.txt).*

- **what stands for what can go on after**: Whether some or every run from s comes to rest with its target met (Rests, 55).
- **laws concluding an opening**: possibly_rests_iff (96), exact, no premise: some run rests with the target met ↔ ∃ u reachable that Stays and meets the target.
- **laws concluding a closing**: assured_iff (138), exact: every run rests ↔ every reachable stay meets the target and every run settles. Also assured_stays_meet (114) and the built example Free.stays_meet_not_assured (180).
- **forms changing while it continues**: Not found in what was read.
- **from where an opening comes**: Not applicable.
- **a way related to widening**: Not found in what was read. This place is about coming to rest, not opening or closing.

## 22 November, every module by fifteen questions

*pass a: reader whole-a-04, as "Enough.lean: possibly_rests_iff, assured_iff, trace_then_stay, Free.stays_meet_not_assured" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-04.md.txt)); pass b: reader whole-b-14, as "Enough.lean: RestsFrom, Rests, Stays, Settles, trace_then_stay, possibly_rests_iff, assured_stays_meet, assured_iff, Free.stays_meet_not_assured, law_possibly_iff, law_possibly_iff_assured" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-14.md.txt)); the third pass, where the two differed: reader whole-c-settle-06, as "Enough.lean: settled fields no_return, comparison, rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-06.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `possibly_rests_iff` (l. 96) equates a run resting with target met with a reachable target configuration admitting a self-step, for any process. `assured_iff` (l. 138) characterizes rest with target met on every run by every reachable self-step state meeting the target and every run settling.
  - *pass b:* For any Process S A, with no premise: some run from s comes to rest with its target met exactly where a reachable configuration meets the target and has a staying step (possibly_rests_iff). Every run does so exactly where every reachable staying configuration meets the target and every run from s settles (assured_iff). Under a determined law the possible and the assured coincide (law_possibly_iff_assured). Free is a built case in which every configuration can stay and meets the target, yet an alternating run never settles.
- **moves**
  - *pass a:* S: `trace_then_stay` (l. 82) extends any finite trace to a state with a chosen self-step into a run staying there from the trace length on. `assured_iff` (l. 138) quantifies all runs.
  - *pass b:* S: these are runs of a Process S A, where each run picks actions. `possibly_rests_iff` (l. 96) is about some run (some choice), and `assured_iff` (l. 138) is about every run (every choice): (∀ r from s, Rests target r) ↔ (∀ u reachable, Stays u → target u) ∧ ∀ r from s, Settles r.
- **a reading**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: there is no reading, observation or registered rule.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: there is no share or fraction of kinds.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: there is no stock or reserve that runs down.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: nothing gives to a level. The target is a predicate handed in.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no statement has a cost to the one who acts.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: there are no units leaving units.
- **a point of no return**
  - *settled by the third pass:* N: `possibly_rests_iff` (l. 96; section variables `{S} {A} {P : Process S A}`, no other premise) states `(∃ r : Run P, r.state 0 = s ∧ Rests target r) ↔ ∃ u, Reach P s u ∧ Stays P u ∧ target u`. Its negated side is an exact condition for no run from `s` coming to rest with the target met, at a given start; it states nothing lost, no step or level after which this holds, and nothing about later configurations. Opened to rule out: possibly_rests_iff, assured_stays_meet (l. 114), assured_iff (l. 138), Free.stays_meet_not_assured (l. 180), law_possibly_iff (l. 204). [which pass was right: b; opened: RestsFrom l. 51; Rests l. 55; Stays l. 58; possibly_rests_iff l. 96; assured_stays_meet l. 114; assured_iff l. 138; Free.stays_meet_not_assured l. 180; law_possibly_iff l. 204; law_possibly_iff_assured l. 217]
  - *pass a:* S: `possibly_rests_iff` (l. 96) excludes every course resting with target met when no reachable target admits a self-step. This is a general reachability obstruction from the specified start.
  - *pass b:* N: no irreversibility is stated. Rests means unchanged with the target met from some step T on; nothing is said to be lost for good.
- **both outcomes**
  - *pass a:* S: `possibly_rests_iff` (l. 96) and `assured_iff` (l. 138) give exact conditions for possible and assured rest with target met. B: `Free.stays_meet_not_assured` (l. 180) has both a resting and a nonsettling run from false.
  - *pass b:* S: `assured_iff` (l. 138) and `possibly_rests_iff` (l. 96) are exactly-when statements, general for every process, about coming to rest with the target met. Their complement is a run that keeps changing or rests short of the target. B: `Free.stays_meet_not_assured` (l. 180): some run from false rests, and the alternating run from false does not settle.
- **a comparison between two**
  - *settled by the third pass:* N: `law_possibly_iff_assured` (l. 217; section `{S} {next : S → S}`) states that some run of `Law.process next` from `s` rests with the target met exactly where every run from `s` does: one process, one start, some against every. `law_possibly_iff` (l. 204) equates that with `∃ T, next (Law.orbit next s T) = Law.orbit next s T ∧ target (...)`, the same law read two ways. Neither carries anything between two processes or two starts, and no order or simulation occurs. Opened to rule out: both, and assured_iff (l. 138). [which pass was right: b; opened: law_possibly_iff l. 204; law_possibly_iff_assured l. 217; assured_iff l. 138; possibly_rests_iff l. 96]
  - *pass a:* S: `law_possibly_iff_assured` (l. 217) transfers the resting-target judgment from some run to every run and back at the same start of a determined law.
  - *pass b:* N for a law carrying something between two processes or starts. `law_possibly_iff` (l. 204) joins the Process reading to Law.orbit: some run rests ↔ ∃ T with the orbit fixed and meeting the target at T. `law_possibly_iff_assured` (l. 217): under a determined law, some run rests ↔ every run rests.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* N: `trace_then_stay` (l. 82) takes `stay : P.step u a u` and `path : Trace P s as u` and gives `∃ r : Run P, r.state 0 = s ∧ ∀ n, as.length ≤ n → r.state n = u`: one constructed run is at `u` from the supplied path's length on. The bound is the length of a path handed in and holds of that one run; no variant falls and no statement bounds when the runs of a process rest (`Settles`, l. 126, is an unbounded `∃ T`; `assured_iff`, l. 138, has it as a conjunct). Opened to rule out: trace_then_stay, Settles, settled_at (l. 129), assured_iff. [which pass was right: b; opened: trace_then_stay l. 82; Settles l. 126; settled_at l. 129; assured_iff l. 138]
  - *pass a:* S: `trace_then_stay` (l. 82) gives an existential run at the endpoint from the supplied path’s length onward. There is no bound here for every run.
  - *pass b:* N: there is no bound or variant. The account says when the runs of a process settle is not stated here.
- **a closed region**
  - *pass a:* S: `law_possibly_iff` (l. 204) equates possible rest under a determined law with reaching a fixed point meeting the target. A self-step in an arbitrary process gives only a possible stay.
  - *pass b:* S: `Stays` (l. 58) is a configuration with an action leaving it unchanged, a fixed point of a step. `stayAt` (l. 61) is the run staying there. `trace_then_stay` (l. 82): some run from s reaches u by a trace and stays there from the trace's length on. `possibly_rests_iff` puts a reachable staying configuration at the centre.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `Free.alternating` (l. 174) is a run that flips the Boolean each step, and `Free.stays_meet_not_assured` (l. 180) proves it never settles although the target is True everywhere.
  - *pass b:* B: `Free.alternating` (l. 174) and `Free.stays_meet_not_assured` (l. 180): a run that changes at every step, alternating between two configurations, and never settles. It is a going on that continues while what is present changes, in a built case. In general, the Settles conjunct of `assured_iff` (l. 138) separates such runs.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and its docstring. I used statements for states, moves, no_return, both_outcomes, comparison, rank, closed_region, and built cases for forms_change. I reached all fourteen questions.
  - *pass b:* All statements and docstrings read (234 lines). moves, both_outcomes, closed_region and forms_change are from statements or the built case; the rest are N.
