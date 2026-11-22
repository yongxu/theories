# Keeping

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Keeping.lean`
- *result records that name this place's file as a source* (computed; not a link): `finite-continuation-plans`, `joint-plan-composition`, `kept-at-the-length-of-a-list`, `what-holding-for-a-reading-is-worth`, `when-to-inquire-and-when-to-respond`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-stop-passed-by-a-listing-that-fixes-the-sign`, `kept-at-the-length-of-a-list`

## 21 November, a future opening or closing: reader courses-still-open

*As "Keeping.lean: KeptFor, Plan". A reader's return, unchecked; what the note mended is in the note: [note](../../read-a-future-2026-11-21/NOTE.md), [report](../../read-a-future-2026-11-21/read-courses-still-open.md.txt).*

- **what stands for what can go on after**: KeptFor P sense guard allowed n B (90): a class kept n steps through usable moves, narrowed by what each step keeps (Seen).
- **laws concluding an opening**: - keptFor_of_closed (311): a family within the guard, closed under a usable move whatever is kept, keeps each class at every horizon. - Certificate.keptFor (322) and Kernel.keptFor (333), each needing a move usable throughout. - KeptFor.finer (288): a finer map of the steps keeps what a coarser one keeps.
- **laws concluding a closing**: - KeptFor.shorter (280) and KeptFor.mono (271). - Built example Matching.keeping_matters (435): kept for 2 steps where the step keeps the bit, not where it keeps nothing. - plans_iff_choice (247).
- **forms changing while it continues**: Not found in what was read.
- **from where an opening comes**: Not applicable.
- **a way related to widening**: What a step registers decides how long a class is kept: keeping_matters (a built example) and KeptFor.finer (general). This concerns keeping, not widening.

## 21 November, a choice made from a reading: reader keeping-through-what-is-registered

*As "Keeping.lean: Seen, Usable, KeptFor, Plan, Plan.Keeps, keptFor_iff_plan, plans_iff_choice, KeptFor.mono/shorter/finer, keptFor_of_closed, Certificate.keptFor, Kernel.keptFor, Matching.keeping_matters". A reader's return, unchecked; what the note mended is in the note: [note](../../read-a-choice-from-a-reading-2026-11-21/NOTE.md), [report](../../read-a-choice-from-a-reading-2026-11-21/read-keeping-through-what-is-registered.md.txt).*

- **what is read, and what chooses from it**: Statements read. The reading is `sense : S → A → S → O`, a map of steps (where it began, the move, where it ended), not of states. A class of starts B is handed in, and Seen (73) is what can stand after move a from B where the step kept value o. What chooses is a Plan (100): a first move and, for each value kept, a further plan, so a tree with recall of every value kept so far. The first move must be usable from all of B (Usable 84).
- **the exact law**: KeptFor (90) is for n steps, with recall, and counts every successor (∀ o, Seen gathers all t). keptFor_iff_plan (182): for Fin k values, KeptFor n B ↔ some plan keeps B, exact. keptFor_iff_plan_of_choice (176) gives the same given ∀ n, ChoiceOver O (Plan A O n), and plans_iff_choice (247) shows that choice is exactly what is needed, over every process. keptFor_of_closed (311), from a family within the guard and closed under a usable move whatever is kept, gives KeptFor at every n; it is sufficient only, and is not one infinite plan (record does_not_show). Certificate.keptFor (322) and Kernel.keptFor (333) need one move usable throughout, so no reading does work there.
- **within one reading**: The definition asks for one move usable from the whole class. The built case Matching.keepsNothing_not_kept (425): with the step keeping nothing, the two starts are not kept for 2 steps. That each start alone is kept is not stated (not found in what was read).
- **two readings of one process**: KeptFor.finer (288): given forget : F → O with ∀ s a t, forget (fine s a t) = sense s a t, KeptFor P sense guard allowed n B → KeptFor P fine guard allowed n B, the moves unchanged. Direction: coarse kept implies fine kept. What a finer reading keeps more is shown only in the built case Matching.keeping_matters (435), keepsBit kept for 2 steps and keepsNothing not. That case does not cite finer. No exact law of what more was found in what was read.
- **when a reading tells apart, and what can still be kept**: Not found in what was read. In Matching the bit is kept at the first step (keepsBit 385) and needed by the second move, but no statement relates that step to what can be kept after it.
- **the lock as a case**: Not found in what was read. No lock module imports or names KeptFor (grep of the seven lock modules). Keeping supplies a process with moves, a reading of steps and a class of starts; no statement puts the lock's models (Pace.turn on a supplied schedule) into that form.

## 22 November, every module by fifteen questions

*pass a: reader whole-a-08, as "Keeping.lean: keptFor_iff_plan, plans_iff_choice, KeptFor.finer, Matching.keeping_matters, Plan.zip_keeps" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-08.md.txt)); pass b: reader whole-b-31, as "Keeping.lean: Viability.KeptFor, Usable, Seen, Plan, Plan.Keeps.keptFor, keptFor_iff_plan, plans_iff_choice, KeptFor.finer, keptFor_of_closed, Certificate.keptFor, Kernel.keptFor, Matching.keeping_matters, Plan.zip_keeps" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-31.md.txt)); the third pass, where the two differed: reader whole-c-settle-11, as "Keeping.lean: settled fields rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-11.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For every process with Fin k step readings, a class is kept for n steps iff some observation-dependent plan of that length keeps it (keptFor_iff_plan, l. 182). For arbitrary observation type O, turning every such keeping result into a plan for every process is equivalent to choice over O in the stated universe (plans_iff_choice, l. 247).
  - *pass b:* The module gives general laws for every process, every map of steps to the values they keep (sense), every guard and every allowed set. A class is kept for n steps (KeptFor) where the guard holds throughout and some usable move leaves, whatever value is kept, a class kept for n-1 steps. A plan that keeps the guard keeps the class; the converse holds with choice over the values (no premise for Fin k), and plans for every process are exactly choice (plans_iff_choice). Further laws give order, closed families and certificates kept for every horizon, and joint plans. Built: Matching shows that what a step keeps decides keeping, and Answering is the choice witness.
- **moves**
  - *pass a:* S: Plan.Keeps.usable_first and Plan.Keeps.rest (ll. 138, 143) require a usable first move and a keeping continuation for every observed value. Plan.zip_keeps (l. 471) combines two keeping plans when joint steps project, the initial class projects inside theirs and the paired moves are compatible.
  - *pass b:* S: `Usable` (l. 84): allowed and enabled throughout the class. `KeptFor` (l. 90). `Plan.Keeps.keptFor` (l. 149): a plan keeping the guard keeps the class for its length. `keptFor_iff_plan` (l. 182): with listed values, kept exactly where some plan keeps it. `plans_iff_choice` (l. 247). `Plan.zip_keeps` (l. 471).
- **a reading**
  - *pass a:* S: KeptFor.finer (l. 288) transports finite-horizon keeping to any step reading from which the old reading can be recovered. B: Matching.keeping_matters (l. 435) gives two-step safety exactly on the bit-reading side of the two readings compared.
  - *pass b:* S: `Seen` (l. 73) is the class after a move and a kept value. `KeptFor.finer` (l. 288): a finer map of the steps keeps what a coarser one keeps, the moves unchanged. B: `Matching.keeping_matters` (l. 435): the same process, guard and moves keep the starts for two steps where the step keeps the hidden bit, and not where it keeps nothing.
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
  - *pass a:* B: Matching.step (l. 350) fixes the lost outcome; Matching.step_unmatched (l. 394) reaches it with a mismatched move.
  - *pass b:* B: `Matching.step` (l. 350): `.lost` steps only to `.lost`, by definition. `keepsNothing_not_kept` (l. 425). N in general.
- **both outcomes**
  - *pass a:* S: keptFor_iff_plan (l. 182) characterizes finite-horizon keeping by existence of a keeping plan for Fin k observations. B: Matching.keeping_matters (l. 435) gives keeping and failure from the same starts under two step readings.
  - *pass b:* B: `Matching.keeping_matters` (l. 435): kept and not kept for one process, depending on what the step keeps.
- **a comparison between two**
  - *pass a:* S: KeptFor.mono, shorter and finer (ll. 271, 280, 288) carry keeping to a narrower class, one fewer step or a finer observation with a consistent forgetful map.
  - *pass b:* S: `KeptFor.mono` (l. 271): a narrower class is kept wherever a wider one is. `KeptFor.shorter` (l. 280). `KeptFor.finer` (l. 288). `Plan.zip_keeps` (l. 471): where joint steps project onto each part's steps, the joint class lies over classes the parts' plans keep, and the plans are compatible, the zipped plan keeps both guards. `Plan.compatible_of_zip_keeps` (l. 497).
- **a rank (an ending within a bound)**
  - *settled by the third pass:* N: `Matching.keepsNothing_not_kept` (l. 425) states `¬ KeptFor process keepsNothing safe (fun _ _ => True) 2 starts`: with the step keeping nothing, no first and second move keep both starts within `safe` for two steps. It does not state that a course ends within a bound: `keepsBit_kept` (l. 408) keeps the same starts for two steps on the same process, and `step` (l. 350) takes a matched need to `done`. No variant, drain or deadline is stated; `KeptFor` (l. 90) is a horizon of keeping, and `KeptFor.shorter` (l. 280) only passes to shorter horizons. Opened to rule it out: ll. 90, 350, 408, 425, 435, 311, 322, 333. [which pass was right: b; opened: KeptFor l.90; Seen l.73; Usable l.84; keptFor_of_closed l.311; Certificate.keptFor l.322; Kernel.keptFor l.333; Matching.step l.350; keepsBit_kept l.408; keepsNothing_not_kept l.425; keeping_matters l.435]
  - *pass a:* B: Matching.keepsNothing_not_kept (l. 425) rules out keeping all starts safe for two steps with the constant reading, even with all moves allowed.
  - *pass b:* N.
- **a closed region**
  - *pass a:* S: keptFor_of_closed (l. 311) gives every finite horizon to each class in a family inside the guard with one usable move per class taking all observed successors back into the family. Certificate.keptFor (l. 322) specializes to a certificate with a uniformly usable move.
  - *pass b:* S: `keptFor_of_closed` (l. 311): a family of classes within the guard, each with a usable move into the family whatever value is kept, keeps each class for every horizon. `Certificate.keptFor` (l. 322). `Kernel.keptFor` (l. 333).
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. General statements support states, moves, reading, both_outcomes, comparison, closed_region. Built cases support reading, no_return, both_outcomes, rank. I found no matching statement for share, level, giving, cost, multiplying, forms_change. No answer rests on prose alone or was unreached.
  - *pass b:* All answered from statements. Read whole (509 lines, all statements); I opened Viability.lean for Kernel and Certificate.
