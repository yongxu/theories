# UE11: where the possible grows (design)

AI-written, 27 October 2026, for board item UE11 under [UE](../ue-unified-explanation/PLAN.md), item 7 and §5's deepest structural gap, self-changing conditions. It follows [UE10](../ue10-what-can-be-reached/NOTE.md), landed the same day. Nothing here is proved yet; each statement is a plan for Lean, and the names are provisional.

## 0. The question

- UE10's third law: within one fixed process nothing is added to the whole possible along a course, a lost possibility has no way back, and the possible within a horizon moves with the actual (`Run.possible_of_next`, `Run.not_possible_returns`, `Run.possibleWithin_moves`). 07's reading of it ends: growth of the possible itself would need a process that changes, which no law states.
- 01's Open item on self-changing conditions: a rule that changes by a fixed law is stated by taking the rule into the occurrence (`adaptive` in `Becoming.Mechanism`, read in the grammar by `Becoming.GrammarRegularity`). Not yet stated: a change of the law of change with no fixed law above it, or a space of rules not given with the carrier.
- The UE plan names self-changing conditions as the deepest structural gap, and its item 7 says that containing the adjacent possible, how the possible grows, would give 生生 its formal second half.

So the question: in what sense can the possible grow, what does its growth need, and can a change of the law of change at every level be stated?

## 1. The answer to check

The possible grows only relative to what is held, and only where what is held changes. Under any process `Q`, a step that is a move of `Q` adds nothing to the possible under `Q`. So the possible with a part held (the moves keeping the part) grows only across steps that change the part, and it keeps widening, in 07's form, only where the part changes without end. Every stated change of a law, a rule changing its own rule or a tower of rules with no top level, is one process on a larger configuration, so nothing is added to its whole possible along any course. What grows is the possible relative to its present rule, or its present levels.

## 2. Statements (to check in Lean, pure core, on `Becoming.ReachableRanges` and `Becoming.Mechanism`)

Throughout, `adm : S → X → Prop` says what each configuration admits, and the possible under a process `Q` from `s` is UE10's `Reaching.Possible Q adm s`.

1. **A move adds nothing to the possible under its process.** For any processes `P` and `Q` on one configuration type, where `Q.step s a t`, what is possible under `Q` from `t` is possible under `Q` from `s` (UE10's `Reaching.Possible.of_reach` read for `Q`). So where the possible under `Q` grows across a step of a course of `P`, that step is not a move of `Q` (`Reaching.not_step_of_grows`).
2. **Keeping widening needs departures without end.** Along a course of `P`, if every step from some step on is a move of `Q`, the possible under `Q` from those steps on never grows (`Run.possible_of_within`), so it does not keep widening in 07's form (`Run.not_keepsWidening_of_within`). Constructively: where it keeps widening, from no step on are all steps moves of `Q` (`Run.departs_of_keepsWidening`).
3. **A part held.** For a relation `Same` on configurations (the held part unchanged; for a reading `h`, `h t = h s`), the moves keeping it (`Process.keeping P Same`: a move of `P` with `Same s t`) are moves of `P`, so the possible with the part held (`Reaching.PossibleHeld`) is included in the whole possible (`Reaching.PossibleHeld.possible`). Along a course it grows across a step only where the step changes the part (`Run.changes_of_heldGrows`), and it keeps widening only where the part changes without end: from no step on does it stay (`Run.changes_of_heldKeepsWidening`). With UE10's law 4, it also keeps widening only where no list holds the whole possible from the course's start (`Run.not_heldKeepsWidening_of_listed`).
4. **A rule changing its own rule** (`adaptive F G`, the joint configuration of a state and its rule). A step keeps the rule exactly where `G` leaves it as it is; so along a course the possible with the rule held keeps widening only where the rule changes without end (`Run.adaptive_rule_changes_of_keepsWidening`), while nothing is added to the whole possible (`Run.adaptive_possible_of_next`, UE10 read on `adaptive`).
5. **A tower of rules with no top level.** On a state and a sequence of levels, a move either changes the state by the rule at level `0` or changes the level `k` by the level `k + 1`, every other level kept (`Tower.process`). Every level is changed by the one above it and none is the last. The tower is one process, so nothing is added to its whole possible along a course (`Run.tower_possible_of_next`). The possible with the levels from `n` up held keeps widening along a course only where some level from `n` up changes without end (`Run.tower_levels_change_of_keepsWidening`). So if from some step on the levels from `N` up stay, a top fixed from then on, the possible held from any `n ≥ N` up keeps widening nowhere along that course (`Run.tower_not_keepsWidening_of_top`).
6. **Witness: open-ended relative to its rule, with the whole possible fixed** (`Climbing`). Configurations are a rule `n` and a position `x`; a move either raises the rule by one or moves the position to any `x' ≤ n`; `(n, x)` admits `x`. Along the course that raises the rule at every step, the possible with the rule held keeps widening, in 07's form (`Climbing.held_keeps_widening`), while from every configuration of the course every formation is possible (`Climbing.whole_every`). The rule changes at every step, as law 3 requires.

## 3. What it would forbid

- Growth of the possible under a process across one of its own moves (law 1).
- A course whose held part stays the same from some step on while the possible relative to it keeps widening (laws 2 and 3); a tower whose levels from some `N` up stay from some step on while the possible held from `N` up keeps widening (law 5).
- Growth of the whole possible along a course of any stated process, however many levels of rule it carries, a tower with no top level included (UE10, read on laws 4 and 5).
- So a claim that a system with a fixed law of change at any level opens, along a course, possibilities not possible from its start, read on its whole configuration, is refuted. What it can open is possibility relative to what it holds: its present rule, its present levels.

## 4. What it leaves open

- Whether the actual unfolding is a course of a process whose configurations can be stated in advance: the thesis that the biosphere's possible cannot be prestated (Longo, Montévil and Kauffman 2012). The laws say what such a statement would cost: if the possible grows relative to every statable configuration, no stated process carries the course.
- A space of rules not given with the carrier. Read as one process embedded in a larger one, the whole possible read along the embedding can grow, but that is growth across processes, not along a course of one; it is not stated here.
- The tower's scheme (`F` and the family of level changes) is fixed, as the law of any stated process is. What a statement cannot have is no fixed scheme at all.
- Sufficiency: endless change of the held part and an unlisted whole possible are both needed for keeping widening relative to the part; together they are not claimed to suffice.

## 5. Neighbours (from prior knowledge, to be checked by the review)

- Kauffman (2000), the adjacent possible; Longo, Montévil and Kauffman (2012), no entailing laws for the biosphere.
- Banzhaf and others (2016), defining open-ended novelty: variation, innovation and emergence, emergence changing the model's own space of possibilities; law 3 reads emergence relative to the held model.
- Hughes and others (2024), open-endedness relative to an observer, by novelty and learnability; law 3 puts the relativity in the configuration.
- Taylor and others (2016), open-ended evolution, the debate over whether a closed system can be open-ended; Bedau and others (2000).
- Hierarchies of rules changing rules: Holland's adaptive systems; second-order cybernetics (Bateson's logical levels of learning, Learning I to III); meta-learning towers in machine learning. To be checked for a statement of law 5 in substance.

## 6. Premises and standing

- No axiom; discrete steps; formations by name over one fixed type; the held part read by a relation on configurations; the tower's levels a sequence indexed by the natural numbers, one level changed per move.
- Each law is expected near-definitional or a witness. What is new is the reading: keeping widening relative to a held part needs that part to change without end, and at every level of a tower no level fixed for good.

## 7. Reading (to be argued in the note) [AI reading, D45]

If the one unfolding were one stated process, its whole possible would never grow: what generation adds is the actual. Growth of the possible is a relation of a part to what it holds fixed within the whole, and keeping it growing needs the held to keep changing. 生生不息, generation without ceasing, then reads as the parts' possibles growing as what they hold keeps changing, at every level, never the whole's possible.

## 8. Plan

- Lean in a scratch tree beside this note, built with `scratch_build.py`; the module a leaf at L1 importing `Becoming.ReachableRanges` and `Becoming.Mechanism`, its closure checked for L2 modules.
- An independent read-only review by a separate AI agent with Lean probes; every required finding taken; a re-check of the fold-in.
- Landing through the queue with a kit, as UE10's: the record `where-the-possible-grows`, homed in 02 after the rules that change themselves or in 07 §2 after what a course keeps reachable (decided at landing), and 01's Open item on self-changing conditions narrowed.
