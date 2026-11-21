# MoveFormation

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/MoveFormation.lean`
- *result records that name this place's file as a source* (computed; not a link): `where-a-move-is-formed`
- *dynamics in the atlas that name one of those records* (computed; not a link): `recurrence-without-premise`

## 21 November, how a registering comes to be: reader revision-and-forming

*As "MoveFormation.lean". A reader's return, unchecked; what the note mended is in the note: [note](../../read-registering-2026-11-21/NOTE.md), [report](../../read-registering-2026-11-21/read-revision-and-forming.md.txt).*

- **what registers what**: A move formed through a reading π: Learning.Lumped π form. PartForms (l231, Lumped Prod.fst) and RestForms (l234, Lumped Prod.snd).
- **what changes it**: No change of the reading along a course found. Run.keepHistory_formed (l662, general over runs of keepHistory P): a policy of the configuration gives every move; 'the length of the history kept tells the step'.
- **laws where something comes to be registered**: None found. lumped_of_finer (l210, general): from Lumped π form and π' finer than π, Lumped π' form.
- **cost and keeping**: From the account: Run.whole_unheld_of_never_cycles (l453). Moves that never cycle need a whole no list holds; 'Novelty in what is done needs openness or growth.'
- **a registering lost**: lumped_const_iff (l217): through the reading that tells nothing apart, only a constant move is formed. No course of losing a reading found.
- **tied to what it rests on**: None found.

## 22 November, every module by fifteen questions

*pass a: reader whole-a-11, as "MoveFormation.lean: partForms_iff, PartForms.parts_agree, no_policy_upto_iff, Run.moves_lasso_of_whole_held" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-11.md.txt)); pass b: reader whole-b-41, as "MoveFormation.lean: coupled, PartForms, RestForms, PartForms.goAlike, Run.withClock, Run.moves_lasso_of_whole_held, Run.whole_unheld_of_never_cycles, no_policy_upto_iff, TwoClocks.one_course_two_laws, Parity.neither_alone" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-41.md.txt)); the third pass, where the two differed: reader whole-c-settle-15, as "MoveFormation.lean: settled fields rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-15.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `partForms_iff` (l. 240) characterizes formation by the part as using the same policy irrespective of the rest, given one rest state. For arbitrary courses with decidable state and move equality, `no_policy_upto_iff` (l. 622) says a finite record rules out such a state policy precisely when a state recurs with a different move.
  - *pass b:* For any labelled processes P, Q coupled by one move formed at the joint configuration (`coupled`), it states where the move is formed (by the part, the rest, or only their relation) and that every run of a labelled process is the part's course in a whole whose rest is a clock forming the move. It also states that moves of a whole, part or rest held by a list repeat (a lasso), and what one course's record fixes. The laws are general; TwoClocks, Still and Parity are built witnesses on Nat and Bool.
- **moves**
  - *pass a:* S: `Run.part_act_eq_rest_act` (l. 154) gives the same move to both sides at every step of a coupled run. `MoveRuns.part_policy` (l. 866) identifies it with a policy of the part when PartForms holds.
  - *pass b:* S: `coupled` (l. 138) is a Process (S × E) Unit taking the part by P and the rest by Q, with the move `form x`. `partForms_iff` (l. 240): the move is the part's exactly where it is a policy of the part. `PartForms.goAlike` (l. 269): where P is determined and the move is the part's, joint configurations with one part configuration go to joint configurations with one part configuration. `PartForms.parts_agree` (l. 279): two runs from one part configuration agree on the part at every step, whatever the rest.
- **a reading**
  - *pass a:* S: `lumped_iff_singleValued` (l. 529) equates agreement on each reading class with a single-valued relation giving all recorded moves. B: `TwoClocks.one_course_two_laws` (l. 720) exhibits identical courses under different attributions of the move.
  - *pass b:* S: `lumped_of_finer` (l. 210): a move formed through a reading is formed through every finer reading. `lumped_const_iff` (l. 217): through the reading that tells nothing apart, only a constant move is formed. `lumped_iff_singleValued` (l. 529). `lumped_upto_iff` (l. 576): with equality of configurations decided, the first N moves are given by a policy of the configuration exactly where no two differ at one configuration. `no_policy_upto_iff` (l. 622): with moves decided too, no policy exists exactly where some configuration recurs with the move varied. `Run.keepHistory_formed` (l. 662): a run keeping its history has every move given by a policy of its configuration.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no count or fraction of one kind among several.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no stock or amount that runs down.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: nothing gives to a level; the move is formed by `form`, a function handed in.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no cost to the one that forms or keeps.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no units leaving units.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no irreversibility is stated. The account (l. 103-105) says a part keeping its history never returns, by Becoming.Recurrence; that is not stated in this module.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no dichotomy of going on and ending, or of keeping and losing. The exactly-when statements found, `lumped_upto_iff` (l. 576), `no_policy_upto_iff` (l. 622) and `partForms_and_restForms_iff` (l. 253), are of whether a policy gives the moves.
- **a comparison between two**
  - *pass a:* S: `PartForms.parts_agree` (l. 279) transports equality of initial part states to equality at every step across runs when the part forms the move and its process is determined.
  - *pass b:* S: `Run.toClosedBy`/`Run.ofClosedBy` (l. 160/173) carry runs between the coupled whole and closedBy of the product. `Run.withClock` (l. 382) carries every run of P into a run of a coupled whole whose clock rest forms the move, and `Run.withLasso` (l. 487) into one whose lasso rest does. `lumped_of_finer` (l. 210) carries formation to finer readings. B: `TwoClocks.one_course_two_laws` (l. 720): the part's law and the rest's law of the move admit one course and differ only where it never goes.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* S of a bound on repetition, N for ending within a bound: `Run.moves_lasso_of_whole_held` (l. 439): for a run of `coupled P Q form`, where both steps are functions (`lawP`, `lawQ`) and every `r.state n ∈ l`, there are i, q with `i + q + 1 ≤ l.length` and `Learning.Lasso (fun n => form (r.state n)) i q`. Likewise l. 407 and l. 422. Nothing ends and no variant falls. [which pass was right: both in part; opened: Lassos section variables; moves_lasso_of_rest_held l. 407; moves_lasso_of_part_held l. 422; moves_lasso_of_whole_held l. 439; whole_unheld_of_never_cycles l. 453.]
  - *pass a:* S: `Run.moves_lasso_of_whole_held` (l. 439) bounds transient length plus positive period by the length of a list containing the whole run when both component steps follow functions. The bounded event is repetition of moves.
  - *pass b:* N: no ending within a bound. S (a bound of repetition, not of ending): `Run.moves_lasso_of_whole_held` (l. 439): where the laws are functions and the joint configurations are held by a list l, the moves repeat from some i with period q+1, with i+q+1 ≤ l.length. Likewise `Run.moves_lasso_of_rest_held` (l. 407) and `Run.moves_lasso_of_part_held` (l. 422).
- **a closed region**
  - *pass a:* S: `closedBy_formed` (l. 165) preserves the equality of the installed move to the formation rule from an initially formed move.
  - *pass b:* S: `PartForms.goAlike` (l. 269): the part's configuration classes go alike under the whole's steps, so the part carries a law of its own. `Run.withLasso_held` (l. 494): the lasso rest stays within the positions 0…i+q. B: `TwoClocks.closed_not_own` (l. 735): a part closed against the rest (GoAlike) whose move is the rest's, not its own.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `MoveRuns.stillRun` (l. 926), with `MoveFormation.alt_ne` (l. 697), continues with alternating moves, a fixed part, and a counting rest.
  - *pass b:* S: `Run.whole_unheld_of_never_cycles` (l. 453): where the laws are functions and the moves never settle into a lasso, no list holds the whole; likewise `Run.rest_unheld_of_never_cycles` (l. 462) and `Run.part_unheld_of_never_cycles` (l. 471). B: `Still.driven` (l. 750): the part stays the same while the move alternates (`MoveFormation.alt`, l. 693), formed through the rest's count. `Parity.neither_alone` (l. 788): a move of period four formed only by the relation of part and rest.
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and the docstrings. General statements — states, moves, reading, comparison, rank, closed_region. Built cases — reading, forms_change. Not found — share, level, giving, cost, multiplying, no_return, both_outcomes. No commentary-only answers. All questions were reached.
  - *pass b:* Every statement of the module was read, all 952 lines including the MoveRuns section. 2, 3, 11, 12 (as a bound of repetition), 13 and 14 are answered from statements, with built cases for 11, 13 and 14; 4 to 10 were not found. None is from the account only.
