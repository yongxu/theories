# LearningRuns

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/LearningRuns.lean`
- *result records that name this place's file as a source* (computed; not a link): `fixed-places-and-sole-lines`, `generalization-through-lumping`, `hexagram-arrangements-and-laws`, `hexagram-world-laws`, `hexagrams-on-the-spine`, `place-relations-in-context`, `shared-laws-on-the-grammar`, `the-split-that-makes-sense`, `wisdom-root-without-axiom`
- *dynamics in the atlas that name one of those records* (computed; not a link): `falls-that-end-do-not-recur`, `waxing-and-waning-returns`

## 21 November, how a registering comes to be: reader learning-codes-inquiry

*As "LearningRuns.lean". A reader's return, unchecked; what the note mended is in the note: [note](../../read-registering-2026-11-21/NOTE.md), [report](../../read-registering-2026-11-21/read-learning-codes-inquiry.md.txt).*

- **what registers what**: The prefix of a run of any process through reg (Parting.course). The extrapolation is through the prefix (byElimination_through_prefix, l.200).
- **what changes it**: The map does not change. Elimination as in Learning.
- **laws where something comes to be registered**: None beyond Learning's laws on runs. - held_byElimination_bounded (l.343). Premises: r : Run (Law.process next); held : ∀ n, r.state n ∈ l; reg; [DecidableEq R]. - transfer_right_iff (l.92). Premises: a determined process; observed : P.step s₀ a u₀. An outcome observed at s₀ transfers to s exactly where s₀ and s go alike under π by a.
- **cost and keeping**: Not found.
- **a registering lost**: free_prefix_fixes_nothing (l.264). Premises: late : t ≤ x, two : y ≠ z. merged_unrested (l.321).
- **tied to what it rests on**: Not found.

## 22 November, every module by fifteen questions

*pass a: reader whole-a-09, as "LearningRuns.lean: transfer_right_iff, loss_through_prefix, unselected_beyond_prefix, alternate_rests" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-09.md.txt)); pass b: reader whole-b-34, as "LearningRuns.lean: GoAlikeAt, transfer_right_iff, goAlike_iff_lumped, missed_on_one_of_part, prefix_fixes_no_next, fit_right_iff_runs, free_prefix_fixes_nothing, answer_open, held_byElimination_bounded, pair_not_learnable" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-34.md.txt)); the third pass, where the two differed: reader whole-c-settle-12, as "LearningRuns.lean: settled fields closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-12.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `LearningRuns.loss_through_prefix` (l. 224) makes any loss-based selection identical on two runs agreeing throughout the registered prefix if the loss depends only on that prefix. `held_byElimination_bounded` (l. 343) bounds the lasso learner’s misses on list-held deterministic runs, while `answer_misses` (l. 309) constructs a diagonal law on whose runs from the empty record every made proposal misses given two distinct decidable values.
  - *pass b:* S: General laws of learning along runs of any process. At a parting of two runs a proposal misses on one (`missed_on_one_of_part`, l. 173). No run's prefix fixes the next value, even among lasso runs of free branching (`prefix_fixes_no_next`, l. 184). Training on runs' prefixes selects alike runs alike through the map and is right at a moment exactly where the prefix determines it (`loss_through_prefix`, l. 224; `fit_right_iff_runs`, l. 245). Under a determined process an outcome transfers exactly where the two configurations go alike by the move, and structure and change are one lumping (`transfer_right_iff`, l. 92; `goAlike_iff_lumped`, l. 113). Built witnesses are the negation runs and the pair law.
- **moves**
  - *pass a:* S: `Learning.transfer_right_iff` (l. 92) characterizes when every successor by a specified move agrees in projection with an observed outcome of that move elsewhere, assuming determinacy.
  - *pass b:* S: `GoAlikeAt P π s s' a` (l. 79) is defined for a `Process S A` by a move a. `goAlike_iff_at` (l. 83): going alike is going alike at every two lumped configurations by every move. `transfer_right_iff` (l. 92): for a determined P, the outcome of a observed at s₀ transfers to every step of a from s exactly where s₀ and s go alike by a. `missed_on_one_of_part` (l. 173) and `byElimination_through_prefix` (l. 200) hold for runs of every process.
- **a reading**
  - *pass a:* S: `LearningRuns.unselected_beyond_prefix` (l. 234) gives a selected course sharing the observed prefix and realizing any attainable value at x when the selection factors through prefix agreement and the course class is free there.
  - *pass b:* S: `fit_right_iff_runs` (l. 245): every two runs alike through `reg` before t are alike at x exactly where the prefix determines x within `Courses P reg`. `free_prefix_fixes_nothing` (l. 264): under free branching the prefix fixes no later value. `loss_through_prefix` (l. 224); `unselected_beyond_prefix` (l. 234). `claim_not_right_on_both` (l. 371): on runs of a determined law beginning alike in the frame by reg, a proposal is right on at most one where the features differ. `goAlike_iff_lumped` (l. 113). B: `pair_not_learnable` (l. 445): through the first coordinate, no extrapolation predicts the second along every run. `pair_whole_predicts` (l. 453): through both coordinates, elimination predicts from step 2.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
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
  - *pass b:* N: no point of no return of keeping or losing. `answer_open` (l. 300): a run of the diagonal law never revisits (no list holds it). B: `negation_never_rests` (l. 415).
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N for going on and ending. The exactly-whens `fit_right_iff_runs` (l. 245), `transfer_right_iff` (l. 92), `goAlike_iff_lumped` (l. 113) and `lumped_iff_fixed_image` (l. 101) are of fit and transfer, general.
- **a comparison between two**
  - *pass a:* S: `byElimination_through_prefix` (l. 200) transfers both elimination index and proposal across runs agreeing on registered values before t, with decidable registration equality.
  - *pass b:* S: carries between runs. `missed_on_one_of_part` (l. 173): two runs alike through the map before t and apart at t. `byElimination_through_prefix` (l. 200): two runs alike before t give the same candidate and proposal. `transfer_right_iff` (l. 92): the outcome carried from s₀ to s. `prefix_fixes_no_next` (l. 184): relates a run of any process to two runs of free branching with its prefix. `missed_on_one` (l. 388): runs alike in the frame have equal prefixes at every step. `answer_course` (l. 286): the diagonal course is the course of a run of the diagonal law.
- **a rank (an ending within a bound)**
  - *pass a:* S: `held_byElimination_bounded` (l. 343) bounds the mistake index strictly below tri N and guarantees proposals from N on for a list-held run. `held_rest_unrefuted` (l. 361) gives eventual prediction under double negation.
  - *pass b:* S: `held_byElimination_bounded` (l. 343): on a run of a determined law whose configurations a list holds, fewer than `tri l.length` misses, proposals from l.length on, and no misses at arbitrarily late steps. `held_rest_unrefuted` (l. 361). B: `alternate_rests` (l. 421), right from step 3; `pair_whole_predicts` (l. 453), from step 2.
- **a closed region**
  - *settled by the third pass:* S, of a relation on pairs kept by the step, not of a region of configurations. `Learning.goAlike_iff_lumped` (l. 113): for `next : S → S` and `π : S → K`, `GoAlike (Law.process next) π ↔ Lumped π (fun s => π (next s))`; equal projection is kept by the law's step exactly where the projected successor is one value on each class of π. No premise. `goAlike_iff_at` (l. 83) and `transfer_right_iff` (l. 92, under `Determined P` and an observed step) are of the same relation. `Courses P reg` (l. 216) is a class of courses of runs, and no invariant, certificate, fixed point or closed set of configurations is stated. [which pass was right: both in part; opened: `GoAlikeAt` l. 79; `goAlike_iff_at` l. 83; `transfer_right_iff` l. 92; `lumped_iff_fixed_image` l. 101; `goAlike_iff_lumped` l. 113; `Courses` l. 216; `course_mem` l. 220; `loss_through_prefix` l. 224; `unselected_beyond_prefix` l. 234 (head). Section `Change` variables `{S A K}`.]
  - *pass a:* S: `Learning.goAlike_iff_lumped` (l. 113) states that equal projection is preserved by paired deterministic steps exactly when the projected successor is constant on each projection class.
  - *pass b:* N: `Courses P reg` (l. 216) is a class of courses. That a list holds a run is a premise. No closed-region law was found.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `negation_never_rests` (l. 415) changes the Boolean state on every step of every negation run, while `alternate_rests` (l. 421) gives continuing correct predictions from step three on runs starting at false.
  - *pass b:* S: `answer_open` (l. 300): the run of the diagonal law from the empty prefix keeps the whole prefix and is held by no list. `merged_unrested` (l. 321): elimination over every merging never rests along it. B: `negation_never_rests` (l. 415): along every run of negation each configuration differs from the one before (an alternation), while elimination predicts it from step 3 (`alternate_rests`, l. 421).
- **how it was read**
  - *pass a:* S: Read the opening account, every declaration statement and its docstring where present. S for states, moves, reading, comparison, rank, closed_region. B for forms_change. N for share, level, giving, cost, multiplying, no_return, both_outcomes. No U fields.
  - *pass b:* S from statements: states, moves, reading, comparison, rank and forms_change (with B); N for share, level, giving, cost, multiplying, no_return, both_outcomes and closed_region; no U. Read all statements and docstrings, ll. 1-459.
