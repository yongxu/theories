# The Lean toward the direction

*AI-written (Fable), 15 November 2026. The order of work on the Lean as it looks now. It will change as the work teaches us. About six minutes. It goes with [the direction](DIRECTION.md). A first draft was attacked by another AI reader and three of its statements were tried by hand before any Lean; no person has checked it.*

## How this came up

On 14 November the whole Lean was counted and read for the first time: about 20,000 theorems in 403 modules, written as answers to one question after another, joined inside a family and mostly not between. Ren asked that the Lean we have be turned toward the direction, and said to start if the plan looked good. His words are in [the sources](../sources/15-codex-theory-conversations/2026-11-13-the-map-one-model.md#the-direction-14-november-2026-evening).

## What a stage is for

A stage is a try at making something the idea needs, and that is now assumed, come out as a conclusion in one model. Before a stage, someone says what they would count as nothing having changed. After it, someone who did not write the proof reads it against the Lean. Turning the Lean is not restating 403 modules, and it is not counted in modules or theorems.

## What trying on paper found

Three statements the first draft rested on were tried by hand. All three failed as first worded, and each failure is kept.

- **A correction that fires once.** "A locked rule never ends exactly where its first reading of the level comes before the point of no return" is false. A five-step course reads the level in time, recovers, is locked again and ends. On paper the statement holds only if the reading stays in force.
- **Its one-way half holds.** A locked rule that never reads the level ends, still locked, and the fall follows from the lock holding its draw. The lock keeps an overdraw going. It does not bring one about.
- **Two lemmas that were to carry one model to another** are true only when written so exactly that they say nothing new: a dictionary between two vocabularies.
- **The first statement tried on 14 November**, a selection using up what it itself depends on, was false as first worded too; two small worlds refute it.

## The order as it looks now

1. **A lock that keeps an overdraw.** Proved in scratch on 15 November, in a copy of `Becoming/TurningInTime.lean`: `locked_alone_not_below`, `locked_ends_with_net_regime`, its form on the lock's own window, and two worked cases, in one of which the share rises at every step. The working builds passed with no axioms. A reviewer and the coordinator read it: no premise speaks of the level's course any more, and the lock's premises carry the ending; the start already overdrawing, the tie from the lock to how much is drawn, and the level making no difference are still assumed. In the worked cases how much is drawn follows only the rule. It is ready to land.
2. **Turning in time, with a correction that stays in force.** Either the exact statement, or a three-way split: ends locked; turns in time; in time for the level and too late for the lock. We expect `Three.goes_on`, `Three.turned_and_ends` and `WayOfUnits.two_units_iff` to come out as cases. If one does not, that is news about the statement.
3. **The two relations behind "selection".** Unequal continuing, and alikeness wherever what reaches a thing is the same. No theorem states both together. Whether one can.
4. **A stock's own point of no return.** At or above a level the family keeps (`Flow.joint_keeps`); below it the excess lowers it (`Flow.excess_lowers`); after the break it stays below (`Flow.stays_below`). It may hold only in built examples.
5. **What is favoured draws more.** A line of descent that does not shrink, living on a family it needs, overdraws it, with the overdraw a conclusion. We expect the ending of `LineageDrawdown.Drain` and one part of `ReadingsSpread.Commons` to come out. A share is not a draw (`SelectionShift.Generations.shift_step`), so this may fail, and then the link stays put in by hand.
6. **How what selects comes to be and changes.** What is selected forms the coupling, and the coupling changes what is selected, in one statement. The earlier work this starts from: couplings formed in a course (`Closing`), a lumping changed by the course's own acts (`Revision`), rules with no top rule (`HeldPossible`), and `Web.consumed_continues_transformed`, which is proved and used nowhere.
7. **Losses that never come back.** Starts from the modules of 9 and 10 November on what persists. It may end where it began: reading a loss does not settle what to do about it, and counting it stays the step the ethics offers.
8. **A case from outside.** No Lean. The conditions of the first stages put as questions someone outside the work can ask of a case of their own.
9. **Said in the grammar's own terms.** Each conclusion stated also as going on without end, generating, degenerating (`«不穷»`, `«生成»`, `«退化»`). This is where the question about Chinese meets the Lean.

Re-sayings are folded where a module is already open for one of these. Folding as its own pass was tried on 18 October: it added adapters and retired nothing. If the size does not come down this way, we change it.

## Where the Lean we have stands

- About forty modules hold a statement that one of the stages needs or leans on.
- A quarter to a third of the theorems are built examples and kept failures. They stay: they are where a condition is shown to matter.
- Much is needed and bears on none of the stages: general mathematics; results that say what does not follow (`World.independent`, `ReadsOnlyDynamics.not_entails`, `World.standing_not_read`); other fields read in Lean; 710 theorems named in classical Chinese; and the parts of the map this order does not reach. This plan gives them no way to move, and says so.
- Nothing is deleted. A module taken out of the build is named on the board with the reason and can come back.

## Size, and following one understanding

The repository is too large to read. As something is understood better its telling should get shorter, and each landing is a chance to point several tellings at one place. Once a few of these stages hold, it should be possible to follow one understanding through: the statement, its proof, its conditions, its example, its test, where it is told.

## What is Ren's

- **One choice never put to him.** On 23 October an AI plan decided that old theorems would not be said again from the base. Turning all the Lean may mean they should be. This plan does not decide it.
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
| Selection with what sustains it | They do not meet. | near: `Web.course_lost_iff`; `TurningInTime.locked_ends_with_net`; `Web.alikeThrough_raise` | A selection drawing down what it itself depends on while nothing it reads differs. |
| Selection with what can still form | For a way in general; not for a selection. | `TurningInTime.turns_in_time_iff_before`; `ReadInTime.deadline` | That the way be a selection, with what it responds to derived and not given. |

The whole chain, being favoured, drawing more, overdrawing, ending, exists only in built examples where the link is put in by hand (`LineageDrawdown.Drain`, `ReadingsSpread.Commons`, `ReadingsPersist.Habitat`).
