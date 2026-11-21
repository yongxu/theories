# Experiment

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Experiment.lean`
- *result records that name this place's file as a source* (computed; not a link): `a-law-through-a-projection-along-one-run`, `causal-models-as-processes`, `configurations-alike-by-relation`, `determinacy-up-to-likeness`, `experiment-needs-return`, `process-and-frame-as-readings`, `processes-represented-both-ways`, `projection-carrying-a-law`, `where-a-move-is-formed`, `wisdom-root`, `wisdom-root-without-axiom`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-wrong-projection-admitted-at-every-step`, `recurrence-without-premise`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-05, as "Experiment.lean: Run.not_fixes_of_untaken, Run.generalizes, keepHistory_new, Confound.varied_refutes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-05.md.txt)); pass b: reader whole-b-16, as "Experiment.lean: Run.Fixes, Run.fixes_of_takes, Run.not_fixes_of_untaken, Run.not_fixes_other_of_new, keepHistory_new, keepHistory_fixes_nothing_else, FactorsThrough, Run.generalizes, Confound.misattributes, Confound.confounded, Confound.varied_refutes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-16.md.txt)); the third pass, where the two differed: reader whole-c-settle-06, as "Experiment.lean: settled fields both_outcomes, rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-06.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Run.fixes_of_takes` (l. 85) fixes the recorded outcome of a taken move among determined processes admitting the record, while `Run.not_fixes_of_untaken` (l. 122) excludes a fixed outcome for an untaken move given determinacy and two distinct states. `Run.generalizes` (l. 239) extends a fixed projected outcome to other states in the class if the step factors through a determined process.
  - *pass b:* General laws for every Process S A: along a run, relative to every determined process admitting its steps, the record fixes a move's outcome at a configuration where the run took it there, and fixes none for a move not taken. So a run that never returns, as a kept history never does, fixes nothing about its other acts. Read through a projection the record fixes outcomes, and where the step factors through the projection into a determined process one occasion stands for every configuration with that projection. A built Confound shows that a wrong projection misattributes, is never excluded when moves go in step with the hidden bit, and is refuted when the move is varied.
- **moves**
  - *pass a:* S: `Run.stepsOf_retarget` (l. 114) preserves every observed step when any untaken state-move pair is redirected to any target.
  - *pass b:* S: `Run.not_fixes_of_untaken` (l. 122): for determined P, where the run has not taken b at s before t, the record fixes no outcome of b at s. `Run.fixes_of_takes` (l. 85): a move taken is fixed. B: `Confound.confounded` (l. 345): under the moves `aligned`, the wrong model is admitted at every step. `Confound.varied_refutes` (l. 353): under `varied`, no determined process admits the steps up to 4 read through the outcome. The choice of move sequence decides what the record can exclude.
- **a reading**
  - *pass a:* S: `Run.generalizes` (l. 239) requires factorization and projected determinacy for a fixed outcome to apply to every concrete step in a class. B: `Confound.misattributes` (l. 331) fixes different projected outcomes after two specified moves even though changing moves preserves the concrete step relation.
  - *pass b:* S: `Run.FixesThrough` (l. 208) and `Run.fixesThrough_of_takes` (l. 214): read through a projection π, a taken move's outcome is fixed. `Run.generalizes` (l. 239): where P factors through π into a determined Q, a fixed outcome for a at k is the projected outcome of a at every configuration projecting to k, observed or not. B: `Confound.misattributes` (l. 331): read through the outcome alone, the record fixes different outcomes for two moves that make no difference anywhere.
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
  - *pass a:* S: `keepHistory_new` (l. 174) concludes no run of the history-keeping process revisits an earlier full configuration.
  - *pass b:* S (not a loss): `keepHistory_new` (l. 174): along any run of `keepHistory P`, the configuration at i differs from that at j for every i \< j, so a kept history never returns. Concluded from the history growing by one each step (`keepHistory_length` l. 167). Nothing here is lost.
- **both outcomes**
  - *settled by the third pass:* B, of keeping and losing a model's admission, not of going on and ending: on the built `Confound.process` (l. 274), `Confound.confounded` (l. 345) states `∀ t, (run aligned).StepsThrough outcome moveDecides t` (the determined model `moveDecides` admits every step read through the outcome, at every step) and `Confound.varied_refutes` (l. 353) states `¬ ∃ Q : Process Bool Move, Determined Q ∧ (run varied).StepsThrough outcome Q 4`. Two runs of one built process under two sequences of moves; no exact condition. General and two-sided, though not of a course going on or ending: `Run.fixes_of_takes` (l. 85) and `Run.not_fixes_of_untaken` (l. 122; premises `Determined P`, the move untaken before `t`, two distinct configurations). [which pass was right: b; opened: Run.Fixes l. 80; Run.fixes_of_takes l. 85; Run.not_fixes_of_untaken l. 122; Run.not_fixes_other_of_new l. 146; Confound.process l. 274; Confound.aligned l. 295; Confound.varied l. 301; Confound.misattributes l. 331; Confound.confounded l. 345; Confound.varied_refutes l. 353]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* B: `Confound.confounded` (l. 345) and `Confound.varied_refutes` (l. 353): the same wrong model is never excluded under aligned moves and excluded under varied moves. N for going on and ending.
- **a comparison between two**
  - *pass a:* S: `Run.stepsThrough_of_factors` (l. 231) carries every run prefix through a projection into an admitting process under step factorization.
  - *pass b:* S: `FactorsThrough` (l. 222): every step of P read through π is a step of Q, a simulation. `Run.stepsThrough_of_factors` (l. 231) and `Run.generalizes` (l. 239) carry the record's fixings across it. `retarget` (l. 92) and `retarget_determined` (l. 96): a determined process differing only at an untaken move admits the same run.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* N: `Confound.varied_refutes` (l. 353) states that no determined `Q` admits the varied run's steps before step 4 read through the outcome. A fixed step of one built run at which a class of models is excluded; nothing is said to end, nothing falls, and there is no bound as a function of anything. The general statements have no bound either: `Run.projection_returns` (l. 248), from a list holding every projected configuration, gives `∃ i j, T ≤ i ∧ i < j ∧ π (r.state i) = π (r.state j)` with no bound on `j`; `keepHistory_length` (l. 167) states a length that rises by one a step. Opened to rule out: varied_refutes, confounded (l. 345), projection_returns, keepHistory_length, keepHistory_new (l. 174). [which pass was right: b; opened: Confound.varied_refutes l. 353; Confound.confounded l. 345; Run.projection_returns l. 248; keepHistory_length l. 167; keepHistory_new l. 174]
  - *pass a:* B: `Confound.varied_refutes` (l. 353) excludes every determined model admitting the varied run's outcome-only record through four steps.
  - *pass b:* N.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N. `Run.projection_returns` (l. 248), within finitely many projected configurations, is recurrence (an instance of `revisits_from`), not a closed region.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* S: `keepHistory_length` (l. 167) makes the retained history grow by one per step on every run. `Run.projection_returns` (l. 248) gives repeated projected states in every tail when a finite list covers them.
  - *pass b:* S (weak): `keepHistory_new` (l. 174): for every run of `keepHistory P`, the process goes on while the configuration is new at every step. N for kinds coming and going or a widening.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statements — states, moves, reading, no_return, comparison, forms_change. Built cases — rank. Not found — share, level, giving, cost, multiplying, both_outcomes, closed_region. No answer rests on commentary alone; all questions were reached.
  - *pass b:* All statements of the module read (l. 1 to 360). moves, reading, comparison, no_return (as never returning) and forms_change (weak) answered from statements; both_outcomes from the built Confound; share, level, giving, cost, multiplying, rank and closed_region not found.
