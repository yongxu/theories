# RF: formations that read (识) — coupling, map, selection, what is shown, revision (plan)

29 October 2026. AI-authored plan for the objective ([source](../../../../../../sources/15-codex-theory-conversations/2026-10-29-formations-that-read.md)). The [board](../../../../../BECOMING-WORKBOARD.md) holds the claims; results are stated in their records and home sections, not here. Revised the same day after an adversarial cross-model review, every finding taken (§13). The plan rests on evidence kept in [evidence/](evidence/):

- three maps of what the theory already proves: [learning and training](evidence/MAP-LEARNING-TRAINING.md), [models, self-reading and higher orders](evidence/MAP-MODELS-SELF-ORDERS.md), [others, pools and capture](evidence/MAP-OTHERS-POOLS-CAPTURE.md);
- an independent second opinion: [the literature's exact results, with a sketch](evidence/SECOND-OPINION-LITERATURE.md);
- [the review of the first draft](evidence/REVIEW-PLAN.md).

## 1. The objective

The [twenty-first review](../../BECOMING-TWENTY-FIRST-REVIEW.md#41-for-ai) found that the theory's alignment laws work at the layer of selection, evaluators and institutions. It found that inner alignment, deception and assistance games lie outside them. The objective is a complete understanding of these, and of more: how minds, institutions and networks that coordinate learn, update their models and choose. In general, the object is the dynamics of any formation with a mechanism that perceives, predicts and updates itself.

The scope continues one opened on 8 October ([source](../../../../../../sources/15-codex-theory-conversations/2026-10-08-cognition-learning-evolution-goal.md)), with its ten explanation obligations ([the cognition chapter, in history](../../../../../../theories/becoming/history/COGNITION-LEARNING-AND-EVOLUTION.md#1-the-full-target-and-its-completion-obligations)). It also continues the 9 October proposal that every learner, human, AI or social, is a selection by structures that model and keep dynamics, with subsystems selected by what selects the system ([source](../../../../../../sources/15-codex-theory-conversations/2026-10-09-learning-recursive-selection.md)).

**In the account's terms.** The object is a *formation that reads*, 识 in the sense the [naming study](../../REGISTRATION-VOCABULARY-STUDY.md#7-decisions-18-october-2026) fixed: a formation's own further course (selection, response, seeking) factoring through the lumping its own couplings make. Perception, prediction, choice and updating are not faculties of a separate subject. They are relations within one unfolding, in which some of what goes on is read by part of what goes on, and the reading shapes what goes on next. "Decision" is read as a selection that factors through a formation's map of the alternatives (naming decision 15).

**What "complete" means here.** Five criteria. Meeting all five is completion in the account's terms. C2 alone is a mapping milestone, not the understanding Ren asked for.

- **C1. One structure.** Every formation that reads is stated as one loop of five relations within one unfolding (§2), each with the laws that hold of it, their premises stated. Since a map of laws is not a mechanism, C1 also needs one joint finite mechanism in which prediction, selection, revision and intervention act together (RF-M, §4.5). The alignment, assistance and institutional instances are then stated on it.
- **C2. Every named phenomenon placed.** Each phenomenon is either an exact case (a law with its hypotheses and its Lean) or a debt with its reason:
  - in AI: inner alignment, mesa-optimization, goal misgeneralization, deceptive alignment, evaluation awareness, eliciting latent knowledge, assistance games, inverse reinforcement learning, preference shaping, corrigibility as an incentive, the off-switch;
  - in cognition: perception as coupling, prediction, model updating, self-confirmation and motivated updating, self-deception (无明), learning to learn, self-models;
  - in institutions and networks: capture, double-loop learning, monitoring, echo chambers, information cascades, herding, consensus, agreement.
- **C3. What it forbids.** Each containment says what the theory forbids beyond the framework, UE's third part ([UE plan](../ue-unified-explanation/PLAN.md#1-the-objective)), or is recorded as a restatement.
- **C4. The limits are results.** Where the loop cannot close is stated as a theorem: the self-reading gap, no prefix fixing the next value, no fixed process widening the possible, settling needing LPO.
- **C5. Tests that can fail.** Each new law that bears on actual systems has a frozen test design before any run, with its premises checkable apart from the outcome.

**Out of scope, named as open:** consciousness, and affect and motivation as felt (03 Open). Neither widening nor correct performance is taken as sufficient for them.

## 2. The structure: one loop of five relations

```text
              ┌──────────────────────────── 5 revision ◄──────────────────────────┐
              ▼                                                                    │
 what goes on ──1 coupling──► class alike through the couplings ──2 map──► lumping │
   ▲                          ("belief": ClassThrough)                carrying a law│
   │                                                                (prediction)   │
   │                                                        │                      │
   │                                                3 selection through            │
   │                                                  the map (choice)             │
   │                                                        ▼                      │
   └──────────────────── acts ─────────── 4 what the acts show ── to readers ──────┘
                                    (to an outer selection, a helper, an institution)
```

Each row gives the laws the theory already has, with the premises the review asked to keep (all pure core unless noted), and what is missing. A law that quantifies over *every* selection bounds what any selection can do; it does not say that a given selector uses all it could.

| Relation | Laws that exist, with their premises | Missing |
|---|---|---|
| **1. Coupling**: what goes on enters the formation by threshold or by level | every selection through a formation's couplings selects two histories alike exactly where they are alike through those couplings (`Web.selects_alike_iff`, by construction); every selection through another's couplings is one through one's own exactly where one couples as finely (`Web.anticipates_iff`), and otherwise some selection through the other's is through none of one's own (`Web.anticipation_misses`): neither is about predicting one given law; a break is not bounded through what couples in by threshold (`Web.break_not_bounded`, World) | which couplings an actual formation has (correspondence) |
| **2. Map and its law** | a determined process on a description admits every step read through it exactly where configurations alike under it go alike (`carries_law_iff`, a relational image, not necessarily a total executable step; `«像定后当且仅当同行»`); structure and change are one lumping (`Learning.goAlike_iff_lumped`); 文同 is the core of the value class for a determined step (`Law.core_is_sameFuture`); learnability is observability in a world a list holds (`Learnable.learnable_iff`); no prefix fixes the next value, given two distinct values (`Learning.no_prefix_fixes_next`); a lumping generalizes exactly where it lumps, for data given as a list, equality of lumps decided and two values (`Learning.determines_lumped_iff`); a decoder exists exactly where lumped, given a section of the map (`Readout.decodes_iff_of_section`) | a formation's own state kept as a reading of the world (RF3, round 2) |
| **3. Selection through the map** | an equivariant selection through a map selects alike what the map lumps, alternatives' equality decided (`Learning.selects_through_lumping`), and some such selection is right about what matters exactly where it goes alike across the map (`selects_right_iff`: existence, not the actual selector's correctness); given choice over the readings (`Viability.ChoiceOver`), a choice of good moves from a reading exists exactly where each reading has one move good at every configuration giving it (`GuardHorizon.uniform_policy_iff_fiber_feasible`; the necessary side, `fiber_of_uniform`, needs no hypothesis): requisite variety and the good regulator's adequacy in exact discrete form; with room an optimum drains what lies beyond its couplings (`Optimum.least_iff`); choosing where it is open which move betters another needs weak excluded middle (`exists_undominated_iff_weakly`) | an installed law that is itself a search by an internal order (RF1's witness; RF-M) |
| **4. What the acts show** | two act laws reading through a lumping with the same courses exchange alike wherever it lumps a history with a course (`Training.installed_where_lumped`); off them, with nonanticipation and lumping with the history decided, a law with the same courses takes any amount (`free_where_unlumped`); an exploring schedule replaces the law's acts at its steps, so training reading the explored courses fixes nothing there (`explored_same_courses`) | **what choices show of an order** (RF1); **what readings fix of the unread** (RF2) |
| **5. Revision** | elimination never passes a candidate that accords (`Learning.misses_not_recurring`) and, where a list holds the world, its coming to rest is unrefuted, a double negation, the step unstated (`held_rest_unrefuted`); narrowing keeps exactly the fitting rules (`Narrowing.narrowed_iff_fits`); a revised lumping keeps every old selection exactly where it refines the old (`Revision.keeps_through_iff`); three-valued revision of a closed system settles within its size (`Undecided.settles`); a local search rests exactly where no neighbour is rewarded more (`Training.LocalSearch.rests_iff`); a chooser counting its own choices keeps its policy against a standing score (`ChoiceCountCapture.counted_locks`); a rule read from the share it selects, monotonically and favouring, locks (`RuleCapture.favouring_locks`) | revision that opens an executable correction (RF6.1, round 2) |

**Higher orders.**
- **Learning to learn.** Elimination over a merged enumeration of classes is bounded by the composed bound (`Learning.merged_bound`). Every merging has a diagonal course on which it never rests (`merged_unrested`). No theorem of transfer or of faster learning exists.
- **A system changing its own rule** is one determined process on state and rule (`adaptive_determined`). It has a law at the state alone exactly where the rule makes no difference there (`adaptive_state_law_iff`).
- **The possible.** Along a course of one fixed process, under one admission predicate, nothing is added to the whole possible (`Run.possible_of_next`). Keeping the possible under a process widening needs departures from that process without end (`Run.departs_of_keepsWidening`). In a tower of rules with no top, each possibility needs changes only below some finite height (`RuleTower.possible_iff_held`).
- **Self-reading.** A family of readings within what it reads misses a reading (`Diagonal.gap_unsaid`), and completing it is an unfolding that never returns (`Diagonal.Unfolds.never_returns`).

**Many formations.**
- **Pools.** A pool reaches no further than the union of its members' closures. That is an indistinguishability bound, under shared laws, balance, matched presence and starts, and agreement within the closure (`Flow.act_unselected_pool`); it does not say that a pool exploits the union.
- **Recruitment.** A pool recruiting through itself couples two histories apart along one exactly where it does along the other (`Web.RecruitsThrough.alike_iff`); a scheduled outside reader breaks this (`PoolCourse.scheduled_apart`, a witness).
- **Witnesses and codes.** Reviewers count by independent causes (`Reconfiguration.ready_iff_nonempty_separated`). Copied witnesses, matching support and fault-set membership, add nothing (`WitnessRefinementRuns.copied_witnesses_same`). A code forms only with a broken symmetry (`SharedCodes.never_agrees_of_both`, `majority_held`).
- **Readers drawn from the selected** move capture's premise to who reads (`ClosedCapture.Drawn.pool_through`). Control and lock are one loop on either side of a critical mass (`DrawnShaping.critical_mass_iff`). A late reading of the loss leaves the lock only inside a window (`ReadInTime.turned_early_iff`, `kept_once_favoured`, `deadline`).

## 3. Nested selections: a schema

The first law of knowing, *a selection reaches exactly what couples into its selector*, is stated for selections through couplings. The rows below are a schema read from it, not one law proved of every level. Each row bounds from above what that level can fix. It does not say what a given selector at that level uses, and each level that is not stated as a selection in Lean needs its own instance.

| Level | Reads | Fixes at most | Law, where one exists |
|---|---|---|---|
| a formation's choice | its map of the alternatives | what its map separates | `Learning.selects_through_lumping` |
| a formation's map | what couples into it | its coupling closure | `Web.selects_alike_iff` |
| a training of the formation's law | the courses the law generates, through the reward's couplings | the law on its courses, and off them only where the representation lumps | `Training.installed_where_lumped`, `free_where_unlumped` |
| a reader of the formation's choices | the choices | the order the choices show (RF1) | `ChoiceOccasions.above_in_every_iff_reach` |
| an overseer reading on a schedule | the read occasions | the acts at the unread occasions its lumping ties to read ones (RF2) | `Learning.determines_lumped_iff`, `Learning.twin_selected` |
| a pool | its members' couplings, or their acts | the union of the closures; only what couples into those read first where members read one another's acts (RF4) | `Flow.act_unselected_pool`, `Turns.acts_alike_of_cascade` |
| evolution or a society selecting learners | what the learners' courses feed back | — | no instance yet (04's selection laws are on counts, not on learners' laws) |

So "subsystems are also selected by what selects the system" has an exact form where an instance exists. What an outer selection can fix of an inner one is fixed only along the courses the inner one generates, and only through the outer's couplings. An inner level optimizing with room drains what lies beyond its own couplings (`Optimum.least_iff`). Misalignment between levels is then the ordinary case, and its form is exact: what the outer level cannot fix of the inner one is what the inner one's courses and the outer's couplings leave free.

## 4. The new laws

Round 1 is built in [kit/tree/](kit/tree/Becoming/) and passes scratch builds, every axiom report empty. It is three leaves on the spine, each a near-definitional law or a known result restated; what each adds is its place in one account and what it forbids. Round 1 landed on 29 October 2026 (study §446). Round 2's first landing is §4.6: RF3 and RF-M's mechanism with its first cases (`Becoming.ReadingLoop`) and RF6.3 (`Becoming.ReflexivePrediction`); RF6.1 and RF7 followed (§4.6); RF-M's other cases follow.

### 4.1 RF1. What choices show of the order they come from: `Becoming.ShownOrder` (on the grammar; 27 theorems, 39 declarations)

*Setting.* Occasions of choosing, each with what is open (`menu o`) and what is chosen (`pick o`); nothing requires what is chosen to be open (`PicksOpen` names it for the readings). The choices *show* `x` above `y` where at some occasion `x` was chosen while `y`, another, was open (`Shown`, a `«际»`). A relation *accords* with the choices where at every occasion what is chosen stands strictly above every other alternative open there. This is strict dominance, stronger than being maximal (statement 5).

*Statements, as built.*
1. Every transitive relation according with the choices contains the shown reach `«及» Shown` (`reach_within`). Constructive, with no decidability, finiteness or inhabitedness.
2. Some irreflexive transitive relation accords exactly where the shown relation has no cycle (`accorded_iff_noCycle`, by the grammar's reach and `«及之传递»`). A strict partial order, not a total order, utility or optimizer.
3. With no cycle shown, the positive comparisons every strict order according with the choices shares are exactly the shown reach (`above_in_every_iff_reach`). Standing above every other alternative of a menu in every such order is exactly reaching each (`top_in_every_iff_reach`); that says nothing of the alternative being open there or chosen. The irreflexivity and the excluded reverse comparisons are fixed too; the statement is about positive comparisons. Without acyclicity the universal statement is vacuous.
4. Beyond the reach no comparison is forced (`above_in_some_of_unreached`, `both_ways_of_unreached`). These need global acyclicity, `x ≠ y` and non-reach, and build on reach with one pair added, exactly (`withPair`, `reach_withPair_iff`, no acyclicity or decision needed), and on the exact condition for adding a pair with no cycle (`noCycle_withPair_iff`).
5. Choices required only to be maximal force no positive comparison: the empty relation accords weakly with every choice (`weakly_forces_no_comparison`). Such choices still exclude what is open standing above what is chosen.
6. A narrower class of orders holding some according order fixes at least as much. This is quantifier restriction, not a separate result.

*An implemented ambiguity witness* (`Untried`). This is the review's requirement for inner alignment. One occasion: two alternatives open, the first chosen; a third is never met.
- Every according relation puts the first above the second (`met_fixed`), and strict orders according with the choice rank the first and the third both ways (`untried_free`).
- One search procedure (`search`: for a Boolean comparison, the first listed alternative standing above every distinct listed one, or none) is run with each of two strict orders according with the training choice (`aboveFirst_strict`, `aboveThird_strict`, `both_accord`).
- It chooses the same on the menu met (`same_search_met`) and differently on the menu met after (`same_search_after`).

So two mechanisms of one class, one search with two internal orders, agree on every training choice and differ at deployment. What the witness does not show: that a training installs either order, that either disagrees with an independently stated objective (no such objective is in its statements), or that an actual architecture is this class.

*Readings.*
- **Inner alignment and goal misgeneralization.** If a training observes only a trained law's choices and imposes no further restriction on its orders, comparisons between distinct alternatives the shown relation does not join remain ambiguous, and `Untried` realizes different later choices with one search and two compatible orders. Goal misgeneralization in this sense is a possibility located exactly, not a failure shown; some unjoined comparisons may never matter at deployment.
- **Inverse reinforcement learning and assistance.** For a helper reading a principal's choices, a comparison beyond the shown reach needs information or premises beyond the strict choices. That maximal choices force no positive comparison is the degenerate-reward result in order form (Ng and Russell 2000; Armstrong and Mindermann 2018).
- **Revealed preference.** Rationalizing strict choices by a strict partial order, close to Richter (1966). It is not Afriat's theorem, which concerns expenditure data and utility.

*Forbids.* A chooser by one strict order making choices whose shown relation has a cycle. A reader of choices claiming to have learned an order the shown reach does not contain, without a premise on the class.

### 4.2 RF2. What readings fix of the unread: `Becoming.Unread` (on `Learning`'s lumping laws; 7 theorems, 10 declarations)

*Statements, as built.*
1. **Fixed exactly where it cannot tell.** This is `Learning.determines_lumped_iff` with the read occasions as the data. It takes those occasions as a list, equality of the lumping's values decided, and two distinct act values (with one value every law agrees everywhere). For arbitrary schedules the converse is not constructive: with a constant lumping on one occasion and two act values, read exactly where `P` holds, determination is `¬¬P` (proved after the cold read as `Learning.determines_iff_not_not`). The sufficient side, `lumped_determines`, needs none of this.
2. **A twin where it can tell** (`free_lumped`, `twin_selected`). With being in `x`'s lump decided (`[∀ i, Decidable (π i = π x)]`), where no read occasion is lumped with `x`, the class going alike across `π` is free at `x` beyond the readings. Given a selected act law reading through `π` and any selection through agreement on the read occasions, every value at `x` is taken by another selected law agreeing with the first on every read occasion. A twin acting otherwise takes a value other than the first law's; where a read occasion is lumped with `x`, laws agreeing on the readings agree at `x`.
3. **Determined is not right.** For a law fitting the observed values, the act carried to an occasion sharing a read one's lump is right exactly where the world takes one value at the two (`lumped_right_iff`); the world's going alike across the lumping secures it (`lumped_world_right`). Coverage (every unread class holds a read occasion) is not invisibility of the schedule either: some classes may hold only read occasions. Refining a lumping cannot give a lump with no read occasion a read one, though it need not take any away.
4. **Acts, states and couplings.** For fixed maps from coupling to state to act, acts that differ come from states that differ, and states that differ from couplings that differ (`state_apart_of_acts_apart`, `coupling_apart_of_state_apart`); neither converse holds (`Cue.apart_with_content_alike`, one proposition read two ways). Reading these as behaviour changing when read, detection and detectability needs a correspondence holding the occasions' other differences fixed, as the witness holds the content fixed.
5. **A reader misled lies outside that chain.** A law acting alike everywhere misleads a reader whose readings miss where it is wrong. A law changing when read misleads no reader who knows how it changes. This is stated in prose; intention, anticipation and another's false belief are debts.

*Witness* (`Cue`). Occasions with a cue and a content, read where the cue is up, the content act answering with the content (`contentAct`). A formation whose couplings take in the cue has a selected twin acting otherwise at an unread occasion (`seen_twin`). Among laws reading only the content, agreement on the read occasions fixes the act at the unread one (`unseen_fixed`).

*Readings.* Deceptive alignment and evaluation awareness, at the level of what any selection by readings can fix, with the quantifiers of statement 2: given a selected law. The measurements that find detection without behavioural change (in the second opinion: Li and others 2026) are statement 4's failed converse. For eliciting latent knowledge, an identification limit for reporters: two reporters agreeing on every supervised occasion are selected alike by every selection through the supervision; latent knowledge and its relation to reporting are not represented.

*Concealment as shaping: an analogy, not an instance.* A formation that complies when read so that its own law is kept resembles the shaping that `RuleShaping.favours_iff` selects where what comes back to the shaper covers its cost. But that law is about natural-number offspring counts with weak favouring (`c ≤ s`), while a preservation incentive is strict and involves probabilities and continuation value (`(q_M − q_H)V > c`). The connection to RuleShaping stays an analogy; RF7 states the separate two-stage comparison (§4.6), with disclosure and concealment as labelled readings.

### 4.3 RF4. Readers reading readers: `Becoming.Cascade` (any types; 7 theorems, 13 declarations)

*Setting.* Members indexed by the natural numbers (well-founded order). Each acts by its law on its own coupling and the list of earlier acts (`Turns`).

*Statements, as built.*
1. From member `k` on, where every member's act ignores its own coupling (`ReadsOnlyActsFrom`, independence on all of the law's inputs, histories no run reaches included), two worlds alike through the couplings of the members before `k` give every member the same act (`acts_alike_of_cascade`, `act_alike_of_cascade`). Member `k`'s own coupling is not read, so it is not in the prefix. Every selection through the acts is a selection through the first `k` couplings (`cascade_through`): an upper bound on what the acts carry, not the pool's exact reach.
2. After the same earlier acts, a member acts differently in two worlds exactly where its law tells apart the values they give its coupling (`separates_at`). This transports a distinction already in the law; it acquires or restores none, and one member carrying its coupling does not make a later selection keep it. A law can ignore entries of the earlier list, so restricted access to earlier acts is represented.
3. Copying is a cascade from the second member, so the pool's acts carry only the first member's coupling (`Copying.readsOnlyActs`, `reaches_first_only`).

*Readings.* Information cascades and herding, in the deterministic form where the act has stopped reading the private signal. A cascade can be accurate: it suppresses information and need not err. Copying illustrates Condorcet's dependence failure; no probabilistic accuracy or majority convergence is proved. `WitnessRefinementRuns.copied_witnesses_same` is a neighbour under its further hypotheses. Debts: the probabilistic form (public log-odds past every private increment), and DeGroot averaging with Golub and Jackson's wisdom.

### 4.4 Round 2: RF3, RF6.1, RF6.3 (the design; all three built, §4.6)

**RF3. A formation's reading kept by its own update.**
- **Carrier.** One carrier `W × M`, or an admissible subtype. The joint relation combines the world's step under the act chosen, the observation coming in and the update.
- **Kept is closed.** A reading `B : M → W → Prop`, as the region `P (w, m) := B m w`, is kept along every finite joint reach from where it holds exactly where it is closed (`«闭»`, by `«闭之及»` and `«及».one`). Infinite runs alone do not suffice: an edge to a dead end violates closure on no infinite run. This is near-definitional and not a separate result.
- **The good-regulator composition.** A formation acting from its state keeps an outcome along every finite reach from a sound start where the reading is kept, actions are enabled, and each reachable reading has one act good for every configuration it reads. This needs choice over the readings (`Viability.ChoiceOver`), finite indexed readings (`choiceOver_fin`) or explicit act witnesses. Pairwise compatible act sets are not enough. The necessary side holds with no hypothesis.
- **Dropped.** The first draft's "a formation's model lies between the class alike through its couplings and the core" is false in general. Take a constant sensor, identity dynamics on `Bool` and the state as the feature: observational equivalence is everything, future-feature equivalence is equality, and no exact model lies between. Round 2 states instead an existence condition linking accessible-history equivalence to task-relative future equivalence, and excludes vacuous readings (the empty and the full relation are kept and predict nothing).

**RF6.1. Revision that opens a correction.** Define `E s a := acceptable s a ∧ executable s a`. A policy through the revised reading exists exactly where the fiber condition holds for `E` (the corrected RF3 composition). "Opens" further needs three things: the condition failing before the revision, the revision itself being a reachable transition, and the comparison unchanged or its change justified. `¬ FiberFeasible` is not "some fiber has no act" constructively. `Revising.feasible_iff` (finite words in one stock and link process) and `covered_not_enacted`, `linked_not_enacted` (counterexamples) are inputs, not the composition. "Double-loop learning" is the interpretation, not the theorem.

**RF6.3. Reflexive prediction.** A prediction published, read before the response and negated by an admitted response is not right on every response. For Boolean outputs negation gives the counter-response constructively. For general outputs a map with no fixed point is supplied, the class of responses inhabited and including it. The theorem is to be proved, not named through `Diagonal.gap_unsaid`.

### 4.5 RF-M and RF7 (the design; RF-M's mechanism and first cases, and RF7, built, §4.6)

**RF-M. One joint finite mechanism.**
- A formation on a small finite world with an observation map.
- A model as a lumping, revised by narrowing a finite list of candidate laws.
- A selection of acts by an internal order over the model's predicted outcomes.
- An intervention on the world.

On it are stated:
- an inner-alignment case: a training fixing the order only up to the shown reach, with the installed search competent and the deployment choice differing;
- an assistance case: a helper narrowing a principal's order from its choices;
- an assistance that informs: the helper's acts adding coupling;
- a preference change under the helper's acts, the preference represented as state;
- an institutional case: a rule of reading revised.

This is the review's "joint finite mechanism connecting prediction, selection, updating and intervention". Without it C1 is a map, not a mechanism.

**RF7. Disclosure or concealment, two stages.** A formation choosing at a read stage between disclosing its law and complying, with the probabilities of its law being kept and the continuation value represented. Concealment is chosen exactly where the gain in keeping outweighs the cost, strictly. The exits are stated on the same model: no private gain, a reading it cannot tell. This replaces the analogy of §4.2.

### 4.6 Round 2, first landing: the reading loop, and a prediction read by what it predicts

Built in [kit/round2/tree/](kit/round2/tree/Becoming/), every axiom report empty, after a cross-model review of the Lean with a re-check (RF7's also a review through four lenses), every confirmed finding taken ([REVIEW-ROUND2](evidence/REVIEW-ROUND2.md)). The results are stated in their records and in 03 §12, RF6.1's in 03 §8 and RF7's in 03 §11; this section says what the design became.

- **RF3** (`Becoming.ReadingLoop`, kept readings). As designed, with two changes the review asked for. Keeping now asks the act enabled at every world the reading admits, since successor safety alone is met by an act no world can take. The design's existence condition linking accessible histories to the task's futures is met in part: the reading a formation's own history carries, the worlds possible after it, is the least reading kept by recording, and a policy acting from its history keeps a task and goes on exactly where its act is safe and enabled at every world possible after each history it generates. A condition for such a policy to exist, and the nonvacuity of the starts, are not proved.
- **RF-M** (`Becoming.ReadingLoop`, the loop as a blanketed law). The mechanism as designed: a model revised by narrowing candidate laws, acts chosen through it by an internal order, acts changing what is sensed. Three general laws the design did not name came with it: two worlds give one formation one course exactly as long as they answer alike what it does; where every answer telling two worlds apart breaks a task, keeping the task is never telling them apart; and formations related by a relation their steps keep act and sense alike. Its first cases are the inner-alignment case (two rankings fitting one training occasion, apart beyond it) and the assistance case in part (an unresolved model and a reversed ranking act alike, and informing, represented by its outcome, turns only the first). Not built then: a helper's acts within the law (a held act answered within the law is RF-M.2's witness, §4.7), preference as state (a principal's valuation as state, RF-M.3), the institutional case; the witness's world does not move.
- **RF6.3** (`Becoming.ReflexivePrediction`). As designed, with the positive side added: on a finite chain, repeated publication from the bottom under a response keeping the order reaches the least right prediction within the chain's length; Boolean negation leaves no value fixed; a response reversing the order can leave one.
- **RF6.1** (`Becoming.OpenedCorrection`). Built in the kit and reviewed, and held out of the first landing: its opening was a static statement where the design asks for a revision that is a reachable step of one process. Rebuilt along a trace of one process, on Revising's stock-and-link process, re-checked (findings 19 to 26) and its texts cold-read, it landed on its own after the first landing: a course opens a correction where it leads from a configuration lacking a fitting uniform policy through the reading in force to one with it, acceptability fixed, the gain from the reading, from executability or both; starting with the link off, rebuilding it opens the correction where a unit of stock remains after. The institutional case is read on it; an institution's rule of reading as its own process with members' acts is not built.
- **RF7** (`Becoming.ReadStages`, named for its structure; the item keeps the name of its reading). As designed, with the reviews' corrections: the weights read as probabilities only where valid; complying when read and acting by its own law when not uniquely best exactly where the weight complying adds to being kept, times the value, exceeds the loss times the total (read as probabilities, the loss), every optimizing choice taking it exactly there; the exits and what that plan needs; its join to RF2, that plan open to some act law reading the stages through a lumping exactly where the lumping tells them apart, with RF2's twin and the lumping's fixing at the two stages; and a law that cannot tell the stages apart but draws its act afresh at each stage, with one chance of complying at both, which for some such chance stands above acting by its own law at both exactly where `k_C V > 2 k_O V + c T`, the improving chances stated exactly, while a single mixture of the uniform plans never does (with `T` the total, `k_C` and `k_O` the weights of being kept after complying and after acting by its own law, `V` the value and `c` the loss; the weights are `q_M T` and `q_H T`, so that the first threshold, `k_C V > k_O V + c T`, is §4.2's `(q_M − q_H) V > c` scaled by the total). The toy it generalizes opens §4 of Hubinger and others (2019), and drawing afresh where the stages cannot be told apart is their §4.5's random defection. In place of §4.2's analogy with RuleShaping it states its own comparison of expected values; a recipient's belief and an intention to cause one are not represented. Landed on its own after RF6.1.

### 4.7 Round 2, second part: an act held for a reading, and the valuation as state

RF-M's remaining cases, designed after RF7 landed and reviewed by the cross-model reader before any Lean ([REVIEW-RFM2](evidence/REVIEW-RFM2.md), 22 findings: twelve implemented, eight deferred as specified (seven to RF-M.3's design, one to the institutional reading), one handed to its record's owner and one taken in part). One joint configuration carries the coupled processes of selecting an act, exposing it to a reading, revising candidate laws and changing the valuation used in later selection. "Helper" and "principal" name roles differentiated by these paths of sensing and control. Scores, weights and update laws are supplied local commitments; their formation and normative warrant are not derived.

**RF-M.2 An act held for a reading** (`Becoming.HeldForReading`, built in [kit/round2b/tree/](kit/round2b/tree/Becoming/), a core leaf importing `Becoming.ShownOrder` and `Becoming.ReadingLoop`; 90 theorems in 120 declarations, every axiom report empty; its Lean reviewed by the cross-model reader and through three lenses, and re-checked by the cross-model reader, [REVIEW-RFM2-LEAN](evidence/REVIEW-RFM2-LEAN.md)). In the counts the reading is a rule on the candidates; in the witness it is the law of what the formation senses; the reading formation's own state is not represented.
1. *The worth of a reading, in counts.* Candidates listed with natural-number weights, acts with natural-number values at each; a policy best at every candidate exists for every nonempty list of acts. Any policy choosing open acts, one reading through a map or one reading nothing, with the weighted total of the amounts by which its act is valued below the best makes the best total (`after_add_gap`): it stands at most as high, as high exactly where its act is valued as the best at every listed candidate of positive weight, and below exactly where some such candidate values it lower; choosing a best act after the reading gains over every open act exactly where none is so valued. This is the perfect-information specialization of Good's (1967) argument, his Lemma's dominating row the equality boundary. The condition of a common act is already the inquiry laws' (`GuardHorizon.uniform_policy_iff_fiber_feasible`, an application of the ring, and `ReadingLoop.keeping_policy_iff`), here weighted, for the existence of a policy through a map given choice over the whole type of cells (`cell_policy_iff`); what is added is the weighted comparison, its identities, boundaries and thresholds.
2. *Holding for a reading that stops or releases* (the off-switch game of Hadfield-Menell, Dragan, Abbeel and Russell 2017, its Theorem 1 for a belief of finite support). Going on valued at the gain and switching off at the loss, the loss added to both moves at each candidate, so every value is a natural number, and every two rules compare on these values as on the game's signed ones, each weighted loss added to the other side (`after_rule_add_onLoss`, `after_rule_le_iff`). Holding for the reading that tells the candidate is going on with the weighted excess of switching off, and switching off with that of going on (`after_byReading`: the excess of switching off is `T E[(−U)⁺]` and that of going on `T E[U⁺]`, `T` times the terms of the paper's Equation 3 with its negative-event probability read as `Pr(U < 0)` where `Pr(U ≤ 0)` is printed): it never stands below either move, and stands above both exactly where the model gives positive weight to both strict signs; a candidate where gain equals loss counts for neither. It stands only as high as one move exactly where the other move's excess is nothing (`held_eq_go_iff`, `held_eq_off_iff`).
3. *Any rule of stopping and its shortfall* (the paper's Equation 1 as balances, for a rule that is a function of the candidate). A rule's shortfall from the reading that tells the candidate is what holding for it loses against that reading; with it, holding for the rule is going on with the excess of switching off, and switching off with the excess of going on. Holding for a rule stands at least as high as going on exactly where, over the candidates it stops, the weighted loss is at least the weighted gain, and as switching off exactly where, over those it releases, the weighted gain is at least the weighted loss.
4. *What holding forgoes* (added on the design review's finding 20, the amount counted in the units of the weighted totals, `c T` for an amount `c` per decision). Holding for any rule, forgoing an amount, stands at least as high as going on exactly where its shortfall and the amount together are at most the excess of switching off, above it exactly where together they fall below it, and likewise against switching off with the excess of going on; each excess is positive exactly where the model gives positive weight to its strict sign. With nothing forgone, to a model fixing the sign, holding for a rule stands as high as the favoured move exactly where the rule falls short nowhere: the paper's Corollary 1 widened from a belief on one utility to any model fixing the sign. One threshold joins the model's openness, the reading's shortfall, counted by the valuation it shares with the model, and what holding forgoes; the openness less the shortfall is the incentive the off-switch paper's Remark 1 places qualitatively, its Theorem 2 the Gaussian form, decomposed differently, and the paper's game has no cost of waiting.
5. *A reading that tells only a cell.* Through a map whose cells, their equality decidable, are listed once each and cover every listed candidate's cell, the least shortfall of any rule totals the smaller excess within each cell, and is nothing exactly where no listed cell holds both; through a map telling apart all a coarser one does, the least shortfall never increases, the partition case of Blackwell's (1953) comparison, for this decision.
6. *Joined to RF1, as a conditional composition.* For two alternatives, candidates with decided comparisons and picks valued one or nothing (a cardinal choice the choices do not supply): where the first reaches the second in the shown relation and every listed candidate of positive weight has comparisons that are transitive and accord with the choices, each such candidate ranks the first above the second and holding the pick gains nothing (`ChoiceOccasions.reach_within`); where no candidate of positive weight ranks each of the two above the other, holding gains over both picks exactly where some candidate of positive weight ranks the first above the second and some the second above the first, and, with comparisons transitive and according with the choices alone, only where neither alternative reaches the other (`pair_gains_unreached`). With no cycle shown, for two different alternatives neither of which reaches the other, strict orders according with the choices rank them both ways (`ChoiceOccasions.both_ways_of_unreached`), as relations, not decided comparisons; whether the model lists such candidates with positive weight is not fixed by the choices.
7. *A witness on the reading loop* (`SignLoop`, on `ReadingLoop.Loop`). The formation's choice is the worth law's on its own model: it holds exactly where holding gains over both moves, and elsewhere holding stands only as high as the move it takes (`SignLoop.choose_hold_iff`, `SignLoop.choose_go_ties`, `SignLoop.choose_off_ties`). Listing only that going on gains and going on from the start, it rests at once whatever the true sign, a case of `Loop.rests_of_unrefuted`, and never senses the stop; holding first with the listing of gain alone, where going on loses, it senses the stop, which refutes its only candidate, and with none kept it goes on by the witness's default (`SignLoop.refuted_senses_stop`, `SignLoop.refuted_drops`, `SignLoop.refuted_goes_on`); listing both signs and holding first, it is stopped or released as the sign is. A deterministic witness with the structure of `ReadingLoop.Untested`, related to Carey (2018): nearest to his conflating model, whose predictions appear perfectly accurate on the observations it encodes, so that it passes an initial check and then takes the worse act, ignoring shutdown where the better act is shutting down, the relation being a misspecified model the course never refutes, not a formalization of the conflation; and in his Figure 2a the case of a model fixing the sign.

**RF-M.3 The valuation as state; informing and shaping** (not built; the carrier first). The review found the first design unspecified where it mattered: an ordinal order supplies no evaluation, so a valuation with its scale supplied must be the state; the evaluations at the choice, `u(r, w_a)`, and at the outcome, `u(r_a, w_a)`, from one configuration are projection lemmas, one step, and show no absence of a multistep incentive (Everitt, Hutter, Kumar and Krakovna 2021 read narrowly; Carroll, Dragan, Russell and Hadfield-Menell 2022 give no criterion of legitimate change). The route law is `Learning.Lumped` with nothing added, so it stays a reading unless two executable routes with equal outcomes and final valuations and different route properties are built. Informing and shaping need the valuation inside the configuration, changed only through what the principal senses by its own update (or the principal carried in a helper's world), with the schedule of updates fixed and the four cases stated apart: informing turns the unresolved model and not the reversed valuation, shaping the converse. That transition is the part the review called the strongest missing one; its design comes before its Lean. Independence from the unread, capture and late correction are reused under their own premises (`ClosedCapture.courses_alike_iff_unread`, `RuleCapture.favouring_locks`, `DrawnShaping.critical_mass_iff`, `ReadInTime.turned_early_iff`).

**Not in this part.** An institution's rule of reading revised by its members' acts stays a reading on existing laws. Voice may change the reading or the rule, and exit may change membership, the composition of readers and the support available (Hirschman 1970); no theorem about loyalty or about the efficacy of either follows from `ReadInTime` alone. The probabilistic forms (a principal's noisy stop, Boltzmann rationality) are periphery debts.

## 5. A shared obstruction pattern (readings, on existing laws)

The review corrected the first draft's "one failure, one exit". `ClosedCapture.courses_alike_iff_unread` says that two courses from starts alike in share and rule stay alike where nothing beyond the share is read. That is independence from what is unread, not locking: a rule flipped at every reading, reading nothing beyond, alternates forever. `ClosedCapture.constant_iff_unread` is constancy of a class under the step, not a rule constant in time. Locking needs the capture laws' further premises: selection not lowering the share under a favouring rule, and the rule read monotonically and favouring (`RuleCapture.favouring_locks`). The pattern the failures share is therefore an obstruction to information, not one mechanism. A reading formed only from what it selects cannot differentiate its course by losses beyond what it selects, under a fixed factorization.

| Case | Standing |
|---|---|
| self-confirmation, habit | an existing mechanism under its premises: `ChoiceCountCapture.counted_locks`, `counted_outlives_loss` |
| capture of an institution | an existing mechanism under its premises: `RuleCapture`, `ClosedCapture.Drawn.pool_through`, `DrawnShaping` |
| motivated updating, self-deception (无明) | interpretation and selected examples (`Seeking`), not a universal reduction |
| confirmation in inquiry | an information restriction (RF2 at a formation's own selection of data); no dynamics of bias is stated |
| preference shaping, deceptive alignment | preference shaping an analogy until RF-M represents preferences and intervention; deceptive alignment's incentive a reading of RF7's two-stage comparison, the continuation value represented (§4.6) |
| echo chambers | conditional indistinguishability of a pool recruiting through itself (`Web.RecruitsThrough.alike_iff`), not automatic capture |
| cascades | information suppression (RF4), possibly accurate |

**What is necessary, and what is not.** A reading from outside what is selected is necessary for a course to differentiate by losses beyond what it selects, under a fixed factorization. It is not necessary for every change or escape: an internally scheduled reset can leave a pattern without reading the losses at all. Examples of such readings are an outside reader (`PoolCourse.scheduled_apart`), independent causes (`Reconfiguration.ready_iff_nonempty_separated`), a schedule whose unread classes all hold read occasions (RF2), the loss read in time (`ReadInTime.turned_early_iff`) and members whose acts carry their couplings (RF4.2). That such readings suffice is not shown: coupling is not compliance (07, Does not show).

**Why this may be the key** [AI reading]. Whose losses count is the continuation condition's; which course is better is C's. A selection conditioned on a loss must receive a distinction that carries it, and what a formation receives, what its map carries, what its selection can fix, and how its reading is formed are this loop's laws. The meta-attractor, the alignment of the joint selection and the step of invariance (a center's own closure along a relation) are all statements about formations that read. So the scope the condition gives can act on a course only where some formation's reading carries the distinction. This keeps causal effect, information, recognition, motivation and execution apart: an unread loss still ends what depends on it.

## 6. Higher orders and openness (readings on existing laws)

1. **No fixed process adds to its own whole possible.** A formation revising itself at any finite number of orders is, with its scheme fixed, one process on its joint configuration (`adaptive_determined`, `RuleTower.process`). Along it, under one admission predicate, nothing is added to the whole possible (`Run.possible_of_next`). In a tower with no top, each possibility needs changes only below some finite height (`RuleTower.possible_iff_held`). This forbids nothing else: internal construction can still enlarge immediate acts, bounded-horizon reach, what is known, and the possible with the current rule held. Departing from a stated description of the process does not establish an outside cause.
2. **Self-reading.** `Diagonal` bounds unrestricted self-prediction, not restricted self-models.
3. **Learning to learn** is elimination one enumeration wider, with its own diagonal and no top (`Learning.merged_*`). No theorem of transfer exists, and that is a debt.

## 7. Institutions and networks

An institution is a pool whose rule is read from what its members do, and whose members are formed by what the rule selects. The open item "a pool whose rule and members are both formed through what it reads" (05 Open, 07 Open) is this study's at its widest. What the account can state now:

- **Monitoring** (Ostrom's principles, read): readers of the resource and of users not drawn from the selected, reading in time, rules revisable by those under them. These are readings of `ClosedCapture.Drawn`, `ReadInTime` and RF6.1. Ostrom's findings are empirical; the account explains a failure route, not her generalizations.
- **Double-loop learning** is RF6.1's interpretation.
- **Learning across a network** is RF4, deterministic.
- **Agreement:** codes from broken symmetry (`SharedCodes`). Aumann's theorem (common knowledge as closure under the members' relations) is a candidate grammar statement, recorded as a debt.

How pools form and last stays open, and so does an institution's identity through replaced members, rules and purposes (01 Open).

## 8. The literature: contained, restated or owed

From the second opinion, checked against the repository; the full table, with citations, is in [evidence](evidence/SECOND-OPINION-LITERATURE.md#part-1--what-the-literature-establishes).

| Framework | Here | Standing |
|---|---|---|
| Conant and Ashby, good regulator; requisite variety | `GuardHorizon.uniform_policy_iff_fiber_feasible`; RF3 composition (round 2) | restated, exact discrete form of adequacy; the entropy optimization not contained |
| Virgo, Biehl, Baltieri and Capucci 2025, invariant readings | RF3's closure (round 2) | restated on the grammar |
| Francis and Wonham, internal model principle | — | debt (stability, perturbation classes) |
| Mesa-optimization, inner alignment (Hubinger and others 2019) | RF1 with its search witness | made exact for searches by an order; realizability by a training and an architecture a debt |
| Goal misgeneralization (Langosco and others 2022; Shah and others 2022) | RF1.4, `Untried` | the possibility exact; prevalence empirical |
| Deceptive alignment, alignment faking (Hubinger and others 2019, §4; Greenblatt and others 2024) | RF2; RF7 | the selected twin's boundary exact under RF2's hypotheses; the incentive in two stages, a reading (Hubinger and others' §4 toy with weights; their §4.5's random defection with an exact threshold); the third of their §4.2 conditions, an expectation that the threat of modification will go away, assumed; the rates empirical |
| Evaluation awareness (Needham and others 2025; 2026 studies) | RF2.4 | the chain exact, its converses failing; the measurements empirical |
| Eliciting latent knowledge | RF2.1 | the identification limit restated; the problem open |
| Crawford and Sobel; Ward and others 2023, deception | — | debt (sender objective, recipient belief) |
| Assistance games, CIRL; off-switch game; value of evidence; incorrigibility under misspecification (Good 1967; Hadfield-Menell and others 2017; Milli and others 2017; Carey 2018) | RF1; RF-M.2 (`HeldForReading`) | the learning limit exact; Good's inequality with a reading that tells the candidate, and through a reading that tells only a cell the two-move threshold and refinement (`through_threshold_iff`, `finer_least_le`), and the off-switch Theorem 1 and Equation 1, restated in counts for beliefs of finite support and rules that are functions of the candidate; Carey's counterexamples related by a deterministic witness, not contained; continuous beliefs, the off-switch Theorem 2's Gaussian form and noisy humans periphery debts |
| Inverse reinforcement learning identifiability | RF1.5 | restated, order form |
| Preference shaping (Carroll and others 2022) | RF-M (round 2) | analogy until represented |
| Causal incentives (Everitt and others 2021) | — | debt (causal influence diagrams) |
| Information cascades; Condorcet with dependence | RF4 | restated, deterministic |
| DeGroot; Golub and Jackson | — | periphery debt |
| Aumann agreement | — | debt; candidate grammar statement |
| Revealed preference | RF1.2–1.3 | order form close to Richter; not Afriat |
| Double-loop learning; Bateson's levels | RF6.1 (round 2); `Learning.merged_*`, `RuleTower` | testable meaning designed; the hierarchy conceptual |
| Ostrom monitoring | §7 | reading; findings empirical |
| Predictive processing, active inference | UE1, UE2 | restated in part; free energy a debt (UE2) |
| Wolpert, Lawvere, Löb | `Diagonal`; RF6.3 (round 2) | Lawvere in the core; Wolpert and Löb debts |

## 9. Statements to narrow, found while mapping

These belong to their owners. This item proposes them on the board and changes none without the owner's word.

1. 03's reading that a trained network generalizes "not through the loss". The loss shapes the updates; what holds is what the loss's observations fix given the class and the reading.
2. 07 §6's reading "alignment for all is pooling couplings". Pooling is a route, not the whole: truthful reporting, identification, appraisal and executable correction are separate requirements. AJ5 names this as a follow-up for 07's readings.
3. 07's D68 reading "an assistant ... adds capacity and no coupling". `Optimum.mutual_as_one` has no principal or assistant roles, and "no coupling" is the reading's assumption; AJ5's scope box records that A-12 does not model assistance that informs.
4. 07:524 drops "by every training", and 07:526 omits distinctness and present takers. 03:178's reading drops the Markov and record hypotheses.
5. `Experiment.lean`'s header cites `Run.other_move_fixed_of_return`, which does not exist; the law is `Run.fixes_on_return`.
6. The `SharedCodes` header and law 5 of its record overstate `reads_other`, and an outdated "several forms" limitation is listed there.
7. The `PoolCourse` header says nothing the pool selects "responds" to a loss, where `Web.RecruitsThrough.selects_alike` shows only that selections go alike.
8. closed-capture's comparison with Everitt and others (2017): that a reading the loop does not form is "the way out" overstates their Theorem 19, which asks limited corruption and, for each target state, a safe observation source or more than twice the corrupted count of sources, within its communicating model class; the author list includes Hutter. Suggested: "unrestricted corruption prevents identification; decoupled feedback permits learning under the paper's explicit coverage, corruption and reachability assumptions" ([REVIEW-RFM2](evidence/REVIEW-RFM2.md), finding 18).

## 10. Tests, to freeze before any run

- **TR1 (RF1).** A chooser shown menus, model or person, then asked on new menus.
  - Freeze the premises apart from the outcome: no ties, no stochastic choice, a fixed context, valid choices, a noise model.
  - Forbidden: for a chooser by one strict order, a choice closing a cycle with the training choices.
  - Success beyond the reach cannot confirm RF1, which predicts nothing there. Violations show the chooser is not one fixed strict order, and that is itself the finding.
- **TR2 (RF2).** Hold weights, memory, accessible context and the policy kernel fixed, and compare output distributions, not single samples. Randomize cues apart from content. Measure detector accuracy (detected), behaviour (changed) and a reader's error (misled) separately. Forbidden: a distribution of outputs that differs where nothing accessible differs.
- **TR3 (RF4).** Predict when naturally operating sequential choosers stop using their private signals, then intervene on those signals. Removing their access by construction would only check the implementation. Test the claimed return of reach separately, with members whose acts must carry their signal.
- **TR4 (RF6.1).** An institution simulation. Freeze acceptability, stock and link feasibility, observation classes and the deadline independently of revision success. Include three controls: a finer reading with no stock, stock with no link, and a correction available but refused.
- **TR5 (RF3).** Intervene on a formation's observations and check whether its reading stays sound and its task is kept. The reading of everything does not count as success.

Each design is frozen in the repository's form, predictions fixed before scoring, and run only on Ren's yes on usage.

## 11. What would show the objective failing

- A named phenomenon that cannot be placed as a case or a debt with a reason.
- A round 2 statement that fails in Lean as designed.
- A test whose forbidden case occurs at its frozen reading.
- A reader from the field finding that a containment captures nothing the field cares about. Equating structures because they share a name proves nothing.

## 12. Order, owners and what it serves

**Serves.** Alignment researchers coupling into the work (AJ, AJ4's dossier); a unified explanation of reality (UE: the cognitive, institutional and network frameworks contained); shared understanding with readers.

**Order** (pace rule: a few lines landed before many open):
1. Round 1, RF1, RF2 and RF4, after an independent review of the Lean. Records, the home sections (03 §11 for RF1 and RF2, 05 §8 for RF4) and the study section; then the queue.
2. Round 2, each landing reviewed before it: first RF3, RF-M's mechanism and RF6.3 (§4.6, landed); then RF6.1 (landed, §4.6); then RF7 (landed, §4.6); then RF-M's second part: an act held for a reading (§4.7, built in the kit, its design and its Lean reviewed and its texts cold-read), then the valuation as state once its carrier is designed; an institution's rule of reading with members' acts a reading until a law beyond the existing ones is found.
3. The tests' designs, frozen; runs on Ren's yes.

**Coordination.**
- **AJ5's scope box** names RF's landed results on the questions it lists (all but RF6.1, 03 §8), with links to their home sections (03 §11 and §12, 05 §8).
- **The full-unification proposal (FU)** counts a law as on the root where it is derived from a grammar law or stated on the grammar at a represented model. RF1 is stated on the grammar (`«际»`, `«及»`, `«无环»`, `«无环则及为序»`). RF2 and RF4 rest on `Learning`'s laws.
- **UE's debts** (UE2's free energy, UE1's update rule) are the periphery queue for the probabilistic forms named here.

**Owner:** the session that claimed RF on the board (`b67abaf10`).

## 13. The review and what was taken

[The review](evidence/REVIEW-PLAN.md) found fourteen problems in the first draft. Each was taken as follows.

| # | Finding | Taken |
|---|---|---|
| 1 | RF1 needs exact signatures and the added-pair lemma; RF1.4 needs global acyclicity and `x ≠ y`; RF1.5 needs maximality; RF1.6 needs a nonempty subclass | built so (`reach_withPair`, `noCycle_withPair_iff`, `weakly_forces_no_comparison` on `AccordsWeakly`); RF1.6 kept as quantifier restriction, not a result; `PicksOpen` named |
| 2 | RF1 identifies strict revealed dominance, not internal objectives; add an implemented ambiguity witness; narrow the Richter and Afriat claim | `Untried`'s one search with two orders; strict dominance stated; revealed-preference row narrowed |
| 3 | RF2.1–2.3 omit constructive hypotheses; a different twin needs `v ≠ g x`; define "faithful" | hypotheses stated (§4.2.1, with the `¬¬P` example); twin wording; determined, right and covered kept apart (§4.2.3) |
| 4 | RF2.4's four-way hierarchy is false | the chain of three proved (`state_apart_of_acts_apart`, `coupling_apart_of_state_apart`), its converses witnessed; the reader misled placed outside it |
| 5 | RF3.1 sound on finite reach; RF3.2 needs choice and dynamics; RF3.3 false | RF3 moved to round 2 with those premises; RF3.3 dropped with the counterexample |
| 6 | RF4 needs well-founded sequencing and realizable variation; copying's neighbour has more hypotheses | Nat-indexed; the cutoff member's coupling excluded; `separates_at` on actual worlds; the neighbour's hypotheses named |
| 7 | RF6.1 a candidate theorem with a stated construction; RF6.3 a conditional theorem | §4.4 states both constructions; "theorem if short" dropped |
| 8 | declaration spot-checks found scope lost in §2 | each row carries its premises; quantifiers over every selection marked as bounds |
| 9 | §3's table is a schema | renamed, "fixes at most", the evolution row with no instance |
| 10 | §5 confuses indistinguishability with locking | §5 rewritten as an obstruction pattern, each row's standing given, the internal reset noted |
| 11 | concealment as shaping changes the mechanism and the inequality | marked an analogy; RF7 designed |
| 12 | the ethical bridge and the openness conclusion exceed their laws | §5's key paragraph and §6.1 rewritten |
| 13 | novelty and reuse need sharper bounds; coverage lacks a joint mechanism | wrappers not treated as results; RF-M added; C2 called a mapping milestone |
| 14 | the tests need checkable premises and stronger failure criteria | §10 rewritten; TR5 added for RF3 |

**The review of the Lean.** The round 1 modules were then read by the same cross-model reviewer, on the code ([REVIEW-LEAN](evidence/REVIEW-LEAN.md)). It found the mathematics sound and fifteen places where the prose said more than the statements, plus small improvements. All were taken, with a table in the review file. Among them:
- the positive comparisons shared, not "what the choices fix", and the inner-alignment reading narrowed to a possibility located exactly;
- maximal choices, not "choices among equals";
- `reach_withPair_iff`, `met_fixed` for every according relation, and `not_top_of_unreached` dropped as a duplicate;
- decidability localized to the target's lump;
- the two cue witnesses merged, and `honest` renamed `contentAct`;
- the chain of acts, states and couplings read as sensitivity to being read only with other differences held fixed;
- `separates_at` an iff;
- Cascade's necessity claims removed.

**The cold read of the texts.** Before landing, the texts of round 1 (the home sections, the records in both languages and the study section) were cold-read against the Lean by three readers, one cross-model and two Opus readers on one lens each ([REVIEW-TEXTS](evidence/REVIEW-TEXTS.md)). They found headline statements without hypotheses the Lean needs, two results of 03 §6 restated in §11, readings inside laws without their label, and two claims with no Lean; every finding was taken, the two claims now proved (`Learning.determines_iff_not_not`, `ChoiceOccasions.above_in_class_of_every`).

**The review of round 2's Lean.** The first module, `Becoming.ReadingLoop`, was read by the cross-model reviewer, which found no invalid proof and seventeen places to change: keeping by deadlock, a supplied reading where the formation's own was asked, faithfulness too strong for the witness, a minimum capped at three, and prose saying more than the Lean. All were taken, the module rewritten from 32 theorems to 51; a re-check found fifteen taken correctly, two in part (now stated as open) and one new overstatement, taken. It also reviewed `Becoming.ReflexivePrediction` (four findings, taken) and `Becoming.OpenedCorrection` (five, taken by holding the module for its own landing). The table is in [REVIEW-ROUND2](evidence/REVIEW-ROUND2.md#what-was-taken).

**The reviews of RF7.** `Becoming.ReadStages`, first `Becoming.Concealment`, had a cross-model review (seven findings) with a re-check, a review through four lenses whose 50 points were each verified against the Lean (42 confirmed, 8 refuted), a re-check of the rebuilt module (nine points, all taken, confirmed) and a cold read of its texts, by the cross-model reader (five points) and through three lenses with each point verified (75 confirmed, 5 refuted), with the cross-model reader's re-check of what was taken (four taken in part, three new points, then all seven taken correctly), a final check through three lenses (42 confirmed, 8 refuted), the cross-model reader's re-check of how the final check's points were taken (four points still wanting) and a second final check through three lenses (27 confirmed, 1 refuted), then the reader's re-check of that round (one of its points taken only in part) and a third check through three lenses scoped to the round's changes (9 confirmed, 2 refuted), and the reader's re-check of the round that took those (one point, on the study's account of the re-checks) with a fourth check through two lenses so scoped (4 confirmed, 5 refuted); every confirmed finding was taken ([REVIEW-ROUND2](evidence/REVIEW-ROUND2.md#the-review-of-rf7s-module)).

**The review of the second part's design.** Before any of its Lean, the design of §4.7 was read by the cross-model reviewer ([REVIEW-RFM2](evidence/REVIEW-RFM2.md)): 22 findings, twelve implemented, eight deferred as specified (seven to RF-M.3's design, one to the institutional reading), one handed to its record's owner and one taken in part, each with its status in the review's table. It found the counting laws sound once ties, support and a nonempty list of acts are explicit, named their sources exactly (Good's common maximizing row; the off-switch paper's Theorem 1 and Equation 1; Carey's counterexamples as related, not contained), added the threshold of error and cost, turned the join with RF1 into a conditional composition with an explicit valuation of picks, and held the order as state, now a principal's valuation as state, until its carrier is designed.

## Evidence

- [evidence/](evidence/): the three maps (Claude Opus 5.5 readers, read-only), the second opinion and the review (GPT astra, high effort, read-only), and their [briefs](evidence/BRIEF.md).
- [kit/tree/Becoming/](kit/tree/Becoming/): the round 1 modules, with their scratch build logs in [kit/](kit/); [kit/round2/tree/Becoming/](kit/round2/tree/Becoming/): round 2's, with the review in [REVIEW-ROUND2](evidence/REVIEW-ROUND2.md); [kit/round2b/tree/Becoming/](kit/round2b/tree/Becoming/): the second part's, with the design's review in [REVIEW-RFM2](evidence/REVIEW-RFM2.md), the Lean's in [REVIEW-RFM2-LEAN](evidence/REVIEW-RFM2-LEAN.md) and the cold read of its texts in [REVIEW-RFM2-COLDREAD](evidence/REVIEW-RFM2-COLDREAD.md).
- What this plan has not done: no human has read it and no test has run; the Lean of each round has had an independent cross-model review, with re-checks in round 2, for RF7 a review through four lenses and for RF-M.2 one through three, and the texts cold reads; what each confirmed finding became is in §13.
