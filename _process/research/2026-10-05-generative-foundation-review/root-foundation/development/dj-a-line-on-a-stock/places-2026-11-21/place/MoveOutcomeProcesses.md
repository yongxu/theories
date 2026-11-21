# MoveOutcomeProcesses

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/MoveOutcomeProcesses.lean`
- *result records that name this place's file as a source* (computed; not a link): `one-move-covering`

## 21 November, a choice made from a reading: reader response-common-over-a-reading

*As "MoveOutcomeProcesses.lean: common_completes, Ensures, summary_ensures_iff". A reader's return, unchecked; what the note mended is in the note: [note](../../read-a-choice-from-a-reading-2026-11-21/NOTE.md), [report](../../read-a-choice-from-a-reading-2026-11-21/read-response-common-over-a-reading.md.txt).*

- **what is read, and what chooses from it**: common_completes (184) uses the ASCII CommonResponse for a belief. The rest of what was read is about one move from a known configuration s; nothing in it is read off a reading of the start. Lines 1-230 read.
- **the exact law**: common_completes (184): CommonResponse … belief r together with belief s gives Completes P safe goal s (response r); it only unfolds the definition. summary_ensures_iff (176): a goal on a summary f of the outcomes is ensured ↔ its pullback is; a one-move law.
- **within one reading**: Not found in what was read.
- **two readings of one process**: Not found in what was read; covers_iff (95) compares two processes' moves, not two readings.
- **when a reading tells apart, and what can still be kept**: Not found in what was read.
- **the lock as a case**: Not named. The docstring says summary_hides_loss exists; I did not read it.

## 22 November, every module by fifteen questions

*pass a: reader whole-a-11, as "MoveOutcomeProcesses.lean: ensures_iff, covers_iff, covers_along, setting_covers_and_gains" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-11.md.txt)); pass b: reader whole-b-41, as "MoveOutcomeProcesses.lean: Ensures, Covers, covers_iff, not_covers_iff, covers_along, summary_ensures_iff, law_covers_free_and_loses, setting_covers_and_opens, summary_hides_loss" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-41.md.txt)); the third pass, where the two differed: reader whole-c-settle-15, as "MoveOutcomeProcesses.lean: settled fields no_return" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-15.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `ensures_iff` (l. 73) characterizes a one-move guarantee by an enabled move all of whose outcomes meet the goal. For any two processes on the same state type, `covers_iff` (l. 95) equates move coverage with carrying every such guarantee between the given starts.
  - *pass b:* For every process, some one move from s ensures a goal exactly where an enabled move's next configurations all meet it (`ensures_iff`). Q's moves at t cover P's at s exactly where every goal one move of P ensures, one move of Q ensures (`covers_iff`); covering is a preorder carried along revisions (`covers_along`). Four built processes on Bool (toFalse, free, setting, halted) show that more outcomes need not cover, that covering can remove a possibility or open a closed one, and that a summary can hide a loss.
- **moves**
  - *pass a:* S: `completes_one_iff` (l. 66) requires both enabledness and the goal at every successor of the chosen move.
  - *pass b:* S: `Ensures` (l. 56) and `ensures_iff` (l. 73): some move ensures a goal exactly where some enabled move has all its next configurations in the goal, a law of what some choice keeps. `completes_mono` (l. 115): a move completing a goal completes every weaker one. `not_ensures_false` (l. 122) and `ensures_true_iff` (l. 127): the full goal is ensured exactly where some move is enabled.
- **a reading**
  - *pass a:* S: `summary_ensures_iff` (l. 176) transports a goal on an outcome summary to its pullback. B: `summary_hides_loss` (l. 279) shows an ensured constant summary while the corresponding full-state value cannot be ensured.
  - *pass b:* S: `summary_ensures_iff` (l. 176): for any summary f of outcomes, a goal on the summaries is ensured exactly where its pullback along f is. B: `summary_hides_loss` (l. 279): through the summary sending every configuration to false, a move of `free` meets false; read whole, no move completes reaching false.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no count or fraction.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no stock or amount.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: nothing gives.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no cost.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no units leaving units.
- **a point of no return**
  - *settled by the third pass:* B (weaker): `toFalse_not_true` (l. 215): for every s, `¬ ∃ a, toFalse.step s a true`; in the built constant law no move from any configuration goes to `true`. Concluded from the built step, as a one-step statement; nothing is stated over the steps of a run. `law_covers_free_and_loses` (l. 235) is a loss between two processes: `Covers free s toFalse s`, `free` can go to `true`, `toFalse` cannot. [which pass was right: both in part; opened: toFalse l. 195; toFalse_not_true l. 215; free_wider_not_covering l. 226; law_covers_free_and_loses l. 235; setting_covers_and_opens l. 251; halted_ensures_nothing l. 270.]
  - *pass a:* B: `toFalse_not_true` (l. 215) excludes every move reaching true from any state in the constant law. The exclusion is concluded from the built step.
  - *pass b:* N: no irreversibility over steps. B: `law_covers_free_and_loses` (l. 235): the constant law covers the free process while losing the possibility of going to true, a loss between two processes, not over time. `halted_ensures_nothing` (l. 270): where no move is enabled nothing is ensured.
- **both outcomes**
  - *pass a:* S: `ensures_true_iff` (l. 127) gives the one-step boundary for going on: the full goal can be guaranteed iff at least one move is enabled.
  - *pass b:* S: `covers_iff` (l. 95) and `not_covers_iff` (l. 158), general: a cover holds exactly where every goal is carried and fails exactly where not every goal is, which is keeping against losing goals between two processes. `lost_goal_of_not_covers_of_dne` (l. 165): with double-negation elimination as a hypothesis, a failed cover names a goal ensured by P and not by Q.
- **a comparison between two**
  - *pass a:* S: `covers_iff` (l. 95) characterizes transfer of every one-move goal. `covers_along` (l. 147) composes coverage across any sequence of revisions, even with changing move types.
  - *pass b:* S: `Covers` (l. 61); `Covers.ensures` (l. 86) carries every ensured goal; `covers_iff` (l. 95); `covers_refl`/`covers_trans` (l. 104/108); `covers_along` (l. 147): revisions each covering the last, labels possibly changing, cover the first at every stage. `common_goal` (l. 134). B: `free_wider_not_covering` (l. 226), `setting_covers_and_gains` (l. 241).
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no bound on ending, no variant.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no region closed under steps.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `setting_covers_and_gains` (l. 241) exhibits a covering process with a new guaranteed goal from each start, reaching true; the constant law cannot guarantee it.
  - *pass b:* S: `covers_along` (l. 147): with the label type L n changing at each revision, each revision covering the last covers the first. B: `setting_covers_and_gains` (l. 241): a cover ensures a new goal, reaching true; `setting_covers_and_opens` (l. 251): a cover opens what the covered law closed.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and the docstrings. General statements — states, moves, reading, both_outcomes, comparison. Built cases — reading, no_return, forms_change. Not found — share, level, giving, cost, multiplying, rank, closed_region. No commentary-only answers. All questions were reached.
  - *pass b:* Every statement of the module was read, all 288 lines. 2, 3, 10, 11 and 14 are answered from statements (with built cases); 9 has only a built case of losing a possibility between processes; 4 to 8, 12 and 13 were not found.

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge2-07

*As "MoveOutcomeProcesses.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge2-07.md.txt).*

- **an exact statement of both outcomes**: S: `covers_iff` (l. 95) with `not_covers_iff` (l. 158), section `variable {S A B C : Type}` (l. 53), no include, no premise: for `P : Process S A`, `s`, `Q : Process S B`, `t`, `Covers P s Q t ↔ ∀ goal, Ensures P s goal → Ensures Q t goal`, and `¬ Covers P s Q t ↔ ¬ ∀ goal, Ensures P s goal → Ensures Q t goal`. The second is the first negated on both sides. Keeping against losing the goals one move completes, between two processes at two configurations; one step, no course. Also `ensures_true_iff` (l. 127): `Ensures P s (fun _ => True) ↔ ∃ a, Enabled P s a`, one process, one step (some move enabled or none).
- **the side that keeps**: N: no region closed under a step. The keeping side only asserts that every goal one move of `P` completes, one move of `Q` completes. Nearest: `covers_refl` (l. 104), `covers_trans` (l. 108) and `covers_along` (l. 147: with `each : ∀ n, Covers (P n) (s n) (P (n+1)) (s (n+1))` as premise, `∀ n, Covers (P 0) (s 0) (P n) (s n)`), a preorder carried along supplied revisions, the keeping at each stage handed in.
- **the side that ends**: N. The losing side says only that not every goal is carried (`not_covers_iff`), and under the hypothesis `dne` names one lost goal (`lost_goal_of_not_covers_of_dne`, l. 165: `∃ goal, Ensures P s goal ∧ ¬ Ensures Q t goal`). No bound, no falling quantity, no natural number in any general statement. Every one of the 33 declarations read; `toFalse_not_true` (l. 215), `law_covers_free_and_loses` (l. 235), `halted_ensures_nothing` (l. 270) are built facts of one step, not endings within a bound.
- **moves in that statement**: S: `Covers` (l. 61) is `∀ a, Enabled P s a → ∃ b, Enabled Q t b ∧ ∀ o, Q.step t b o → P.step s a o` and `Ensures` (l. 56) is `∃ a, Completes P (fun _ _ _ => True) goal s [a]`: every enabled move of `P`, some enabled move of `Q`, and every goal.
- **a reading in that statement**: N in `covers_iff`: goals are all predicates on `S`, nothing is read. A reading stands in a separate statement, `summary_ensures_iff` (l. 176): for `f : S → T`, `(∃ a, Enabled P s a ∧ ∀ p, (∃ o, P.step s a o ∧ f o = p) → goal p) ↔ Ensures P s (fun o => goal (f o))`, a transport, not a keeping against a losing. B: `summary_hides_loss` (l. 279), of `free` on `Bool`.
- **the carrier**: Two processes `Process S A` and `Process S B` on one configuration type, at configurations `s` and `t`, with goals `S → Prop`; one move from a configuration.
- **what is handed in**: Both processes and both configurations are handed in; concluded is the equivalence of the cover with the carrying of every one-move goal. No level, giving, share, favouring or turn in any statement; the reading (`f`) is a supplied map in `summary_ensures_iff` only.
- **links to other modules**: `completes_one_iff` (l. 66): the core's `Completes P (fun _ _ _ => True) goal s [a] ↔ Enabled P s a ∧ ∀ o, P.step s a o → goal o`, a case of `Completes` on a one-move word. `common_completes` (l. 184): from `CommonResponse P safe goal response belief r` and `belief s`, `Completes P safe goal s (response r)`. Definitions built from other modules: `toFalse := Law.process (fun _ => false)` (l. 195), `free := everyStep Bool Unit` (l. 198), `halted := Witnesses.halted Bool Unit` (l. 204), used by `halted_ensures_nothing` (l. 270) and `law_covers_free_and_loses` (l. 235).
- **standing**: No axiom seen; opening account: "No ethical predicate, ranking or axiom occurs." Double-negation elimination is a named hypothesis `dne : ∀ p : Prop, ¬ ¬ p → p` of `lost_goal_of_not_covers_of_dne` (l. 165). The docstring at l. 153-157 says the classical form `lost_goal_of_not_covers` is in `MoveOutcomeProcessesInherited` (docstring only; that module not opened).
- **note**: Moves are in the exact statement, a reading is not, and every statement is of one move from one configuration, so there is no course in which anything could end or be kept for ever. `covers_iff` is a comparison of two processes, not two outcomes of one.
