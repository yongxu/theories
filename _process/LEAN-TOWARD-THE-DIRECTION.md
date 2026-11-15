# The Lean toward the direction

*AI-written (Fable), 15 November 2026. The order of work on the Lean as it looks now. It will change as the work teaches us. About six minutes. It goes with [the direction](DIRECTION.md). A first draft was attacked by another AI reader and three of its statements were tried by hand before any Lean; no person has checked it.*

## How this came up

On 14 November the whole Lean was counted and read for the first time: about 20,000 theorems in 403 modules, written as answers to one question after another, joined inside a family and mostly not between. Ren asked that the Lean we have be turned toward the direction, and said to start if the plan looked good. His words are in [the sources](../sources/15-codex-theory-conversations/2026-11-13-the-map-one-model.md#the-direction-14-november-2026-evening).

## What a stage is for

A stage is a try at making something the idea needs, and that is now assumed, come out as a conclusion in one model. Before a stage, someone says what they would count as nothing having changed. After it, someone who did not write the proof reads it against the Lean. Turning the Lean is not restating 403 modules, and it is not counted in modules or theorems.

## What trying on paper found

Three statements the first draft rested on were tried by hand. All three failed as first worded, and each failure is kept.

- **A correction that fires once.** "A locked rule never ends exactly where its first reading of the level comes before the point of no return" is false. On a five-step course the level is read in time; one step later it is no longer read, the rule is set again from the share, and the line ends. This page first said the level recovers there; it never rises on that course. The statement holds under the condition said in step 2 below, proved on 15 November.
- **Its one-way half holds.** A locked rule that never reads the level ends, still locked, and the fall follows from the lock holding its draw. The lock keeps an overdraw going. It does not bring one about.
- **Two lemmas that were to carry one model to another** are true only when written so exactly that they say nothing new: a dictionary between two vocabularies.
- **The first statement tried on 14 November**, a selection using up what it itself depends on, was false as first worded too; two small worlds refute it.
- **Step 2's first two tellings were wrong, one each way** (found by readers of the Lean, not on paper). Its first Lean stated the exact condition with the start held within the range where the corrected draw holds the level, and was told as joining the lock to turning in time. Readers who had not written it showed that this form adds no case with a first reading after the start to the old theorem's, and that the lock's premises did nothing in it. The session then wrote, and told Ren, that no such case exists and that the lock is not joined. The next readers showed that the bound belongs on the level after the turn; with it there the case exists and the lock's premises do work. Both were found before anything landed.

## The order as it looks now

1. **A lock that keeps an overdraw.** Landed on 15 November (content tip `b09df328e`), in `Becoming/TurningInTime.lean`: `locked_alone_not_below`, `locked_ends_with_net_regime`, its form on the lock's own window, and two worked cases, in one of which the share rises at every step. The core run passed with every axiom report empty. A reviewer and the coordinator read it: no premise speaks of the level's course any more, and the lock's premises carry the ending; the start already overdrawing, the tie from the lock to how much is drawn, and the level making no difference are still assumed. In the worked cases how much is drawn follows only the rule.
2. **Turning in time, with a correction that stays in force.** Landed on 15 November (content tip `fb6f3cf35`), in `Becoming/TurningInTime.lean`; the core run passed with every axiom report empty, and three rounds of readers read it in scratch.
   - **For any way.** A way that comes to respond never ends exactly where the step at its first marked level leaves the level at or above the corrected kind's point of no return (`turns_in_time_iff_kept_below`, on `unending_iff_above_kept_below`). This is proved where the corrected kind is kept from that point up to below a level `c`, in one of two ways. Either `c` lies above a bound on where the level is after the turn, so the kind is kept wherever the level then goes; the earlier exact theorem, `turns_in_time_iff`, is this way with the kind kept at every level. Or from `c` up to the bound every way's step keeps the level at or above `c` and within the bound; then `c` is never below any way's own point of no return (argued from `held_above`, not a Lean statement). Also given: the way as it was draws at least a floor, from a start already past that draw's point of no return, and every way reached after the turn draws at least what the corrected kind draws. The law is a sufficient condition: whether a line can go on where no such level and bound exist is not shown.
   - **On the lock's window.** A `Locked` way that already overdraws, its level read on a band that reaches from the corrected kind's point of no return up to that level `c`, never ends exactly where the step at the first reading leaves the level at or above that point (`locked_turns_in_time_on_window_iff`). The lock's premises keep its draw at or above its floor until the first reading. On a lock a first reading after the start occurs only in the first of the two ways (argued in that law's docstring, not a Lean statement). From one start that is not locked the line goes on with no reading, so the two sides differ (`Three.unlocked_goes_on`).
   - **What stays given on the lock.** That a reading sets a rule of the corrected kind and such a rule draws one fixed amount; that every step reads; where the band lies; that from `c` up to the bound every rule's step keeps the level there, which asks nothing in the first way; the floors on the draws; the start already past the lock's own point of no return; a bound on the level after a step that is read; and the premises on giving and on the need. Nothing is concluded about whether the way that goes on is locked.
   - **Three more worked courses**, from a level of nine. Read at eight only: 9, 8, 6, 6, 2, 0, in time by the old theorem's right side, and the line ends (`Three.read_at_eight_ends`). Read from six to below ten: 9, 8, 10, 12, 12, and it goes on; from seven it ends (`Three.read_to_ten`). Read from six to below nine: 9, 8, 6, 6, 6, first read at step 1, and it goes on (`Three.held_at_six`).
   - **What goes on is not always the corrected rule.** In the last course it is, by the first way: the corrected rule is held where the band reads the level. In the one before it is not, by the second way: at ten the rule is set again from the share, and what goes on at twelve is the lock's own rule, at a level where its draw is met. So "a lock turns in time" does not say the lock was corrected.
   - **The cases we expected.** `Three.goes_on` and `WayOfUnits.two_units_iff` rest on the old theorem unchanged. `Three.turned_and_ends` is a computed case and never went through it.
   - **Not tried.** A reading at some steps only. A correction to what the rule is set from: the window sets the rule, and the rule is read off the share again wherever the level is not read. A use that grows with the share.
3. **The two relations behind "selection".** Unequal continuing, and alikeness wherever what reaches a thing is the same. No theorem states both together. Whether one can.
4. **A stock's own point of no return.** At or above a level the family keeps (`Flow.joint_keeps`); below it the excess lowers it (`Flow.excess_lowers`); after the break it stays below (`Flow.stays_below`). It may hold only in built examples.
5. **What is favoured draws more.** A line of descent that does not shrink, living on a family it needs, overdraws it, with the overdraw a conclusion. We expect the ending of `LineageDrawdown.Drain` and one part of `ReadingsSpread.Commons` to come out. A share is not a draw (`SelectionShift.Generations.shift_step`), so this may fail, and then the link stays put in by hand.
6. **How what selects comes to be and changes.** What is selected forms the coupling, and the coupling changes what is selected, in one statement. The earlier work this starts from: couplings formed in a course (`Closing`), a lumping changed by the course's own acts (`Revision`), rules with no top rule (`HeldPossible`), and `Web.consumed_continues_transformed`, which is proved and used nowhere.
7. **Losses that never come back.** Starts from the modules of 9 and 10 November on what persists. It may end where it began: reading a loss does not settle what to do about it, and counting it stays the step the ethics offers.
8. **A case from outside.** No Lean. The conditions of the first stages put as questions someone outside the work can ask of a case of their own.
9. **In the grammar's own terms, where that joins.** Not a pass of its own. A stage states its conclusion as going on without end or ending (`«不穷»`, `«亡»`) where that joins it to the root, as steps 1 and 2 did. No conclusion is said again for the sake of the idiom (Ren, 16 November: the aim is not the language, or results said again).

Re-sayings are folded where a module is already open for one of these. Folding as its own pass was tried on 18 October: it added adapters and retired nothing. If the size does not come down this way, we change it.

## Where the Lean we have stands

- About forty modules hold a statement that one of the stages needs or leans on.
- A quarter to a third of the theorems are built examples and kept failures. They stay: they are where a condition is shown to matter.
- Much is needed and bears on none of the stages: general mathematics; results that say what does not follow (`World.independent`, `ReadsOnlyDynamics.not_entails`, `World.standing_not_read`); other fields read in Lean; 710 theorems named in classical Chinese; and the parts of the map this order does not reach. This plan gives them no way to move, and says so.
- Nothing is deleted. A module taken out of the build is named on the board with the reason and can come back.

## Size, and following one understanding

The repository is too large to read. As something is understood better its telling should get shorter, and each landing is a chance to point several tellings at one place. Once a few of these stages hold, it should be possible to follow one understanding through: the statement, its proof, its conditions, its example, its test, where it is told.

## What is Ren's

- **The choice about old theorems, answered.** On 23 October an AI plan decided that old theorems would not be said again from the base. It was put to him on 15 November. On 16 November he said that it is not about results being said again, or about the language: the aim is a map that is joined and simple ([his words](../sources/15-codex-theory-conversations/2026-11-13-the-map-one-model.md#the-direction-14-november-2026-evening), the last message there). So an old theorem is touched where a join is found that makes it a case, or where it can be retired; none is restated as a pass.
- New test designs and paid runs, held since 6 November, and who is sent what. Stage 8 needs these.

After each stage he is told in a few lines what it showed. The next does not wait.

## What a proof says today

Four of the ways into the idea, taken a pair at a time because that is how the check was run on 14 November; another cut would do. We counted a pair as meeting where one theorem, in one model, names something of each and concludes how one bears on the other. It is a check against fooling ourselves, not what work is chosen by.

| Pair | What a proof says today | By | What is missing |
|---|---|---|---|
| Evolution with what sustains | They meet. | `Reproduction.Flow.lineage_ends`; `GroupEnding.Flow.coupled_generation_childless` | The line's own going on concluding that it overdraws what it needs. |
| What sustains with what can still form | They meet. | `Flow.family_excess_ends`; `Flow.not_keepsOpening_of_dissipated_requirements` | The exact point of no return for a renewed stock; proved for one level in another model (`TurningInTime.noReturnAt_iff_first_below`). |
| Evolution with selection | As counting only. | `Founding.varied_before`; `SelectionTerm.Generations.mean_step` | Descent together with a selection through what makes a difference to it. |
| Evolution with what can still form | They do not meet. | nearest `Flow.begins_late_of_keepsOpening` | For a line of descent, the step from which it can no longer be kept. |
| Selection with what sustains it | They do not meet. | near: `Web.course_lost_iff`; `TurningInTime.locked_ends_with_net_regime` (a rule set again from its share that already overdraws ends still locked where its level makes no difference to it; the overdraw is given); `Web.alikeThrough_raise` | A selection drawing down what it itself depends on while nothing it reads differs. |
| Selection with what can still form | For a rule set again from its share, with the overdraw and the reading given. | `TurningInTime.locked_turns_in_time_on_window_iff`; `TurningInTime.turns_in_time_iff_kept_below`; `ReadInTime.deadline` | What the rule responds to, and the tie from the rule to how much is drawn, derived and not given; a correction that reaches what the rule is set from; whether what goes on is still that rule. |

The whole chain, being favoured, drawing more, overdrawing, ending, exists only in built examples where the link is put in by hand (`LineageDrawdown.Drain`, `ReadingsSpread.Commons`, `ReadingsPersist.Habitat`).
