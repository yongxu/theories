# CodeAcquisition

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/CodeAcquisition.lean`
- *result records that name this place's file as a source* (computed; not a link): `composition-route`

## 21 November, how a registering comes to be: reader learning-codes-inquiry

*As "CodeAcquisition.lean". A reader's return, unchecked; what the note mended is in the note: [note](../../read-registering-2026-11-21/NOTE.md), [report](../../read-registering-2026-11-21/read-learning-codes-inquiry.md.txt).*

- **what registers what**: A learner holds an optional code, a stock and records (l.162). observe shows three probes (l.100); acquire reads a code off them (l.103).
- **what changes it**: train c (l.208). The code c is the move of trainProcess : Process Learner Code (l.345), handed in. 'The grammar, the probes, the training schedule and the draw of each operation are supplied, not derived.'
- **laws where something comes to be registered**: - step_installs (l.356), general law. Premises: step : trainProcess.step s c t; enough : 7 ≤ s.stock; distinct : c.first ≠ c.second. Conclusion: t.code = some c. - acquired_exact (l.110): c.first ≠ c.second → acquire (observe c) = c. - acquired_every_expression (l.120). Handed in: the code as the move.
- **cost and keeping**: step_stock (l.361): t.stock + 7 = s.stock. step_rests_when_short (l.366). installed_without_execution (l.398, built).
- **a registering lost**: primitives_no_exact (l.275), equal_primitives_unresolved (l.317), nonuniform_fails_transfer (l.332).
- **tied to what it rests on**: Stock as a precondition only.

## 22 November, every module by fifteen questions

*pass a: reader whole-a-02, as "CodeAcquisition.lean: acquired_every_expression, step_then_execute, step_rests_when_short" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-02.md.txt)); pass b: reader whole-b-05, as "CodeAcquisition.lean: acquired_exact, acquired_every_expression, primitives_no_exact, train, trainProcess, step_stock, step_rests_when_short, step_code_transfers, step_then_execute, installed_without_execution" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-05.md.txt)); the third pass, where the two differed: reader whole-c-settle-02, as "CodeAcquisition.lean: settled fields rank, closed_region, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-02.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `acquired_every_expression` (l. 120) gives exact evaluation at every expression for every code with distinct primitives in the supplied grammar. `step_then_execute` (l. 384) gives the result and exact remaining stock after a training step when the learner can afford both draws.
  - *pass b:* B: One built finite model: expressions from two atoms, and codes giving atom values and a join order. The code read off three probes is the code wherever its primitives differ (acquired_exact l.110, acquired_every_expression l.120); no reading of the primitives alone is exact for the order (primitives_no_exact l.275). Training is a process of the spine (trainProcess l.345): a step draws seven units from the learner's stock, installs the code and appends records, and leaves a learner with stock below seven as it was (step_stock l.361, step_installs l.356, step_rests_when_short l.366).
- **moves**
  - *pass a:* B: In `trainProcess` (l. 345) any code is a move; `step_installs` (l. 356) installs that code at stock ≥7 if its primitives differ.
  - *pass b:* S: trainProcess : Process Learner Code (l.345), where the move c trains under c. step_code_transfers (l.372): every move c with stock ≥ 7 and c.first ≠ c.second installs acquire (observe c), which evaluates every expression as c does. step_rests_when_short (l.366): every move leaves a learner with stock \< 7 unchanged.
- **a reading**
  - *pass a:* S: `acquired_exact` (l. 110) recovers every code with distinct primitives from its three probes. `primitives_no_exact` (l. 275) rules out an exact answer for order from primitive values alone.
  - *pass b:* S: observe (l.100) and acquire (l.103). acquired_exact (l.110): the code read off the probes is the code where its primitives differ. primitives_not_lumped (l.268) and primitives_no_exact (l.275): read through the primitives alone, the order is not lumped and no answer is exact (PartialReadout). step_evidence (l.378): from no records, the step's records read back as the code's probes. B: reversed_composite_switches (l.308) and missing_composite_no_code (l.304).
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: Not found.
- **a level that runs down**
  - *pass a:* B: `step_stock` (l. 361) draws seven from a sufficient stock and `step_rests_when_short` (l. 366) fixes a learner below seven. `execute` (l. 239) checks remaining stock against expression cost.
  - *pass b:* S: The learner's stock. step_stock (l.361): a covered step draws seven. step_rests_when_short (l.366): with stock \< 7 the step changes nothing. step_then_execute (l.384): execution draws operationDraw, and what is left plus both draws equals the stock before. Whether training or execution can happen depends on the stock left. B: installed_without_execution (l.398): from 7 the code is installed but the novel expression cannot be executed.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: Not found. Nothing gives to the stock; it is a number in the Learner.
- **a cost to the one that keeps or gives**
  - *pass a:* B: `step_then_execute` (l. 384) charges the learner’s own stock seven for acquisition plus the operation draw for execution, under affordability and distinct primitives.
  - *pass b:* S: Training costs the learner its own stock. training_stock and step_stock (l.230, l.361): (train c s).stock + 7 = s.stock. trained_execution_stock (l.252): execution draws operationDraw from what is left. B: installed_not_executed (l.299).
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: Not found.
- **a point of no return**
  - *pass a:* B: `step_rests_when_short` (l. 366) concludes every training successor equals the learner once its stock is below seven.
  - *pass b:* S: step_rests_when_short (l.366): a learner with stock \< 7 is left as it was by any move. Since no step raises the stock, short is not left, but this is stated only per step, not as a law over runs. It is at a low level (the stock), not at the loss of a giver.
- **both outcomes**
  - *pass a:* B: `train` (l. 208) branches on affordability, with `train_of_le` (l. 213) giving installation and `training_short` (l. 235) giving rest.
  - *pass b:* S: train_of_le (l.213) and training_short (l.235): for stock ≥ 7 the code is installed and seven are drawn; for stock \< 7 the learner is unchanged. These are the two cases of one built model. B: novel_after_step (l.392, from 11, executes with nothing left) against installed_without_execution (l.398, from 7).
- **a comparison between two**
  - *pass a:* S: `renaming_keeps_values` (l. 134) preserves evaluation under simultaneous renaming of code and expression.
  - *pass b:* S: renaming_keeps_values (l.134): renaming the atoms and the code together keeps every value. acquired_every_expression (l.120): two codes agree on every expression. B: nonuniform_agrees_on_probes (l.327) and nonuniform_fails_transfer (l.332): a law agreeing on the probes differs on the novel expression.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* B: step_stock (l. 361): for trainProcess.step s c t with 7 ≤ s.stock, t.stock + 7 = s.stock (for every learner and code of this one built model); with step_rests_when_short (l. 366) when s.stock \< 7. A drain of seven a covered step in the built training process; no statement says the course ends within a bound or names a falling rank. [which pass was right: both in part; opened: train l. 208; training_stock l. 230; training_short l. 235; step_stock l. 361; step_rests_when_short l. 366; step_then_execute l. 384]
  - *pass a:* B: `step_stock` (l. 361) gives a strict seven-unit drain on every covered step; the short-stock step rests.
  - *pass b:* N: Not found. The stock falls by seven per covered step, but no law of ending within a bound is stated.
- **a closed region**
  - *settled by the third pass:* B: step_rests_when_short (l. 366): for trainProcess.step s c t with s.stock \< 7, t = s, for every code c. Every learner whose stock is short is a fixed point of every move of the built training process. [which pass was right: a; opened: training_short l. 235; trainProcess l. 345; step_iff l. 348; step_rests_when_short l. 366]
  - *pass a:* B: `step_rests_when_short` (l. 366) makes every short-stock learner a fixed state under every training action.
  - *pass b:* N: Not found.
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* B: novel_after_step (l. 392): after trainProcess.step (initial 11) usual t, execute t novel = some ([false, false, true], 0); step_installs (l. 356) and step_code_transfers (l. 372) say a covered step installs a code that evaluates every expression as c does. More can be executed after the step than by the codeless initial learner, but that execute is none before is by definition only, no statement compares before and after, the stock is then 0, and records only append. [which pass was right: both in part; opened: execute l. 239; initial l. 288; novel_execution l. 295; step_records l. 351; step_installs l. 356; step_code_transfers l. 372; novel_after_step l. 392; installed_without_execution l. 398]
  - *pass a:* B: `novel_after_step` (l. 392) gives a successful novel execution from a previously codeless learner with eleven units after one usual-code step.
  - *pass b:* N: Not found. Records only append (step_records l.351).
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, reading, comparison. Built-case answers cover moves, level, cost, no_return, both_outcomes, rank, closed_region, forms_change. I reached all fourteen questions.
  - *pass b:* Every statement and docstring read, lines 1–404. All fourteen answered from statements.
