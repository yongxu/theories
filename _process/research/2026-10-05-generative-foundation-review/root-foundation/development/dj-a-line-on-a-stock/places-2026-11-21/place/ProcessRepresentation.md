# ProcessRepresentation

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ProcessRepresentation.lean`
- *result records that name this place's file as a source* (computed; not a link): `processes-represented-both-ways`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-14, as "ProcessRepresentation.lean: withMove_image_iff, yan_iff_keepsMoving, renaming_invariant, yan_line_iff_dependentChoice" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-14.md.txt)); pass b: reader whole-b-52, as "ProcessRepresentation.lean: moveRel_mk, steps_iff_moveRel, forall_steps_iff, withMove_image_iff, withMove_of_renaming, renaming_of_withMove, renaming_invariant, renaming_reach, yan_iff_keepsMoving, run_yan, factorsThrough_iff_image, yan_line_iff_dependentChoice" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-52.md.txt)); the third pass, where the two differed: reader whole-c-settle-20, as "ProcessRepresentation.lean: settled fields both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-20.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `withMove_image_iff` (l. 162) characterizes the step relations representable with the move inside the state by independence from the next move. `renaming_of_withMove` (l. 224) recovers separate state and move renamings from a correspondence preserving steps and both equality classes, given a state and a move.
  - *pass b:* A process `Process S A` is read in the grammar as its relations, one per move, and back. A renaming of configurations and moves relating two processes is exactly a correspondence of their models with the move inside that carries the steps and both classes (given a configuration and a move). Such a renaming keeps traces, n steps, reach, returning, invariants, determination, losslessness, going alike and going on along some branch. Going on along some branch is lying in a family that keeps moving. The laws are general; built countermodels (NoMoves, NoConfigurations, Twist, Flip, Forgotten) show where the reading stops.
- **moves**
  - *pass a:* S: `yan_iff_keepsMoving` (l. 505) characterizes onward branching from x in any process by membership in a family admitting continued moves inside; `run_yan` (l. 513) gives this at every run's start.
  - *pass b:* S: `steps_iff_moveRel` (l. 96): the steps are the union of the moves' relations; `enabled_iff_neng` (l. 115); `yan_iff_keepsMoving` (l. 505): going on along some branch of the steps from x («延» (Steps P) «一» x) is exactly lying in some K with K x and `Onward.KeepsMoving P K` (some move from each member stays in K); `run_yan` (l. 513): a run goes on along some branch from where it starts; `run_iff_image` (l. 486).
- **a reading**
  - *pass a:* S: `renaming_goAlike` (l. 609) transports going alike under a description when state and move bijections preserve the step relation and the description is read back along the state bijection.
  - *pass b:* S: `class_is_claims` (l. 144): every class is the class of a frame's claims, likeness to depth zero; `renaming_goAlike` (l. 609): a renaming keeps going alike under a description π, read back along it; `factorsThrough_iff_image` (l. 473). B: `Forgotten.moves_forgotten` (l. 640): two processes with the same steps differ in which move is enabled (the steps forget the moves); `reading_next_move_not_withMove` (l. 172).
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
  - *pass b:* N
- **both outcomes**
  - *settled by the third pass:* S: `yan_iff_keepsMoving` (l. 505), section variables S, A only, for every `P : Process S A` and x: `«延» (Steps P) «一» x ↔ ∃ K, K x ∧ Onward.KeepsMoving P K`, an exactly-when of going on along some branch, general; its right side is the same going on said in the process's terms (a family that keeps moving), and no ending side or condition on the configuration is stated. `yan_line_iff_dependentChoice` (l. 523) is an iff between a schema over all relations (going on gives a line) and `Onward.DependentChoice`, not two outcomes of a model. [which pass was right: both in part; opened: yan_iff_keepsMoving l.505; run_yan l.513; yan_line_iff_dependentChoice l.523; yan_line_of_list l.535; feasible_iff_li l.465; Onward.KeepsMoving (def, other module)]
  - *pass a:* S: `yan_iff_keepsMoving` (l. 505) gives an iff for possible continuation for any process, with existence of a keeps-moving family as its criterion. `yan_line_iff_dependentChoice` (l. 523) identifies the extra principle for obtaining a line in general.
  - *pass b:* N: `yan_line_iff_dependentChoice` (l. 523) is an exactly-when between going on along some branch giving a line and dependent choice, not a dichotomy of going on and ending for one model.
- **a comparison between two**
  - *pass a:* S: `renaming_trace` (l. 565) carries traces both ways under step-preserving and reflecting state and move bijections, with the move word renamed letter by letter.
  - *pass b:* S: `withMove_of_renaming` (l. 186) and `renaming_of_withMove` (l. 224): a renaming relating two processes is exactly a correspondence of their withMove models carrying the steps and both classes (from a configuration s0 and move a0); `renaming_steps`, `renaming_trace`, `renaming_iterate`, `renaming_reach`, `renaming_returns`, `renaming_invariant`, `renaming_determined`, `renaming_lossless`, `renaming_goAlike`, `renaming_yan` (l. 556-626) carry each notion between the two processes; `factorsThrough_iff_image` (l. 473): P factors through π into Q exactly where at each move the image of P's relation lies within Q's. B: `Twist.models_correspond` / `Twist.not_renamed` (l. 352, 374) and `Flip.*` (l. 422, 437): one class alone does not suffice.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `renaming_iterate` (l. 570) carries n steps and within n steps, but no law of ending within a bound.
- **a closed region**
  - *pass a:* S: `renaming_invariant` (l. 588) transfers step closure in both directions under a process renaming when region membership agrees.
  - *pass b:* S: `renaming_invariant` (l. 588): given membership read along φ, `Invariant P I` iff `Invariant P' I'`; `yan_iff_keepsMoving` (l. 505): a family K that keeps moving (some move from each member stays in K) is what going on along some branch means.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration's statement and its docstring where present. General statements answer states, moves, reading, both_outcomes, comparison, closed_region. The remaining fields are N. No question was unreached.
  - *pass b:* Answered from statements: moves, reading, comparison, closed_region; the rest are N after reading every statement. Read the whole module: the account and every statement to l. 646.
