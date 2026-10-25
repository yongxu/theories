# When selection favours control over its own rules

*Draft for alignment researchers, 24 October 2026 (AJ4). No person has reviewed it yet; standings are as of this date. Result 6 (MA2) landed on 25 October 2026: core receipt `20261025T045617.350224Z`, every axiom report empty. Its review was by one independent AI reviewer, not by a person. Result 7 (MA3) landed the same day, after an independent review revised its names and three of its claims: 51 theorems in 57 declarations, core receipt `20261025T071027.387418Z`, every axiom report empty. Chapter 7 states the readings below as decision D68.*

## The question

Most alignment work asks how to make a system pursue the right objective. This account asks a prior question, which applies to any selection: a reward signal, a training run, an evaluation regime, a market, an institution. What can it select for, and when does it come to select for control over its own rules?

Humans, institutions and AI systems now select together. So the unit here is that joint selection, not one system and its principal.

The results below are theorems in Lean 4 about models with discrete steps and natural-number counts, and none of them uses an ethical premise. Whether trained systems and real institutions meet the models' conditions is a separate claim, tested only as reported below.

## What is proved

A selection *reads* a quantity when its signal depends on it, directly or through other quantities the signal depends on. The signal may be a reward, a score, a price or a count of descendants. A quantity it does not read is *unread*.

1. **A selection is blind to what it does not read.** A selection selects two histories alike exactly when they are alike in what it reads. So, with everything else fixed, nothing it does not read can be selected for (`Flow.unselected_beyond_coupling`; [record](../../../../../../theories/becoming/results/records/selection-through-couplings.md)).

2. **With room, an optimum drains what it does not read.** Call it *room* when any option that leaves more of an unread condition than another is beaten, on what is read, by some option. With room, every optimum of every ranking that rises with what is read leaves the condition at its least level. Of the dependences on the condition that are met before the step, an optimum breaks exactly those that some available outcome breaks. Without room, keeping the condition can be optimal; a witness shows it (`Optimum.least_of_room`, `Web.optimum_broken_iff`; [record](../../../../../../theories/becoming/results/records/what-an-optimum-does-beyond-what-couples-in.md)).

3. **A far-sighted optimizer keeps its own base, which is not alignment.** Suppose an optimizer ranks its whole course by what it draws from a renewing resource over a finite horizon, and its capacity to draw lies within the bounds the record states.
   - It holds the resource at a level where renewal is greatest until the last step of its horizon, and then takes everything.
   - Take a dependent that is met at the start and whose need lies above every level of greatest renewal. Every optimum breaks it at the first step, and it stays unmet through the horizon.
   - Where renewal is equally greatest at several levels, two optimal courses can take exactly the same while one keeps a dependent and the other breaks it. A witness shows this (`Optimum.Holding.gated_alike`; [record](../../../../../../theories/becoming/results/records/horizon-optima-hold-the-greatest-renewal.md)).

   This is the resource-keeping form of instrumental convergence. It protects the optimizer's base, not what else depends on the resource.

4. **Several optimizers drain as one.** Suppose several optimizers each rank by what they read and reach a mutual best response. They then lower a condition outside all of them as one optimizer of their combined capacity would (`Optimum.mutual_as_one`; [record](../../../../../../theories/becoming/results/records/several-optimizers-drain-by-their-joint-capacity.md)).

5. **A rule read from what it selects locks, and outlives a loss it does not read.**
   - Suppose the rule that selects is read, monotonically, from the share it selected, and the starting rule and every rule read favour the selected. Then the loop locks from the step after its first reading, and neither share nor rule falls again (`RuleCapture.favouring_locks`; [record](../../../../../../theories/becoming/results/records/capture-through-the-rule.md)).
   - From a locked state, a change to the rule that keeps it favouring is absorbed at the next reading. Where the reading favours at every share, nothing short of a change of law leaves the lock for long: a change in how the rule is read, or in the selection itself. Where it favours only above a threshold, a change that carries the share across the threshold also leaves.
   - Suppose how the rule is read is also formed from the share. Then a loss the loop does not read leaves it locked, however large the loss grows (`ClosedCapture.lock_outlives_loss`; [record](../../../../../../theories/becoming/results/records/closed-capture.md)).
   - Each result has a witness where it fails. Without the start condition, the loop alternates forever. Read from the loss instead of the share, the loop turns.

6. **When the loss is read decides whether a lock can still be left.** Suppose the rule is the pooled reading of readers drawn from the population it selects ([record](../../../../../../theories/becoming/results/records/readers-drawn-from-the-selected.md)).
   - **Who reads.** The pool reads the share exactly where each carrier's reading favours the carriers at least as much as each other member's reading does (`Drawn.pool_reads_iff`). This is an equivalence. It moves the premise that the rule reads the share onto who reads; it does not remove it.
   - **When the loss is read.** Suppose only the other members read a loss, their late reading mirrors the carriers', and the rule in force favours the carriers. Then the lock is kept for good exactly where the carriers are at least as many as the others when the loss is read. Otherwise the course turns (`Thinned.kept_iff`, `Thinned.turned_iff`).
   - **Witness:** one carrier to eight others under a four-to-one rule. Read from the start, the loss turns the course. Read from step 3, it leaves the course locked for good, even though that late reading reads beyond the share (`inTime_turned`, `late_kept`, `late_reads_loss`).
   - **Not shown:** that actual rules are such pools, or that each kind reads in its own favour.

7. **At a step, capacity to shape the rule is selected exactly where what comes back to the shapers alone covers its cost** ([record](../../../../../../theories/becoming/results/records/shaping-the-rule-selected-by-what-comes-back.md)). Model shaping in counts: each shaper leaves a + s + p descendants and each other member a + c + p. Here s is what shaping returns to the shapers alone, p is what it returns to every member alike, and c is its cost, counted as the others' advantage.
   - **At a step.** The rule favours shaping exactly where c ≤ s, and p decides nothing (`RuleShaping.favours_iff`, `favours_alike`).
   - **Nothing back.** Where nothing comes back to the shapers alone and shaping has any cost, the shapers' share falls at every step, whatever is shared (`nothing_back_falls`).
   - **Across a stretch.**
     - Take m steps with nothing back (`shaped a 0 p c`) and n steps with something back (`shaped a s p c`). The share holds exactly where (a+c+p)^(m+n) ≤ (a+p)^m (a+s+p)^n (`stretch_iff`).
     - Only the number of steps of each kind matters, not their order. More steps with nothing back never help (`wait_not_more`). Where c ≤ s, more steps with something back never hurt (`back_longer_not_less`).
     - The verdict depends on the base a, and timing binds only where the steps with something back are bounded.
   - **The shared part across a stretch.** It decides nothing at a step, but across a stretch it can turn the verdict. With a = 1, c = 1, s = 2, m = 2 and n = 3, the share falls at p = 0 and rises at p = 1 (`SharedFlips`).
   - **The lock.** The rule is read from the share exactly where what comes back is monotone in the share (`byBack_reads_iff`). Where what comes back covers the cost at every share, the course locks (`covering_locks`).
   - **Witness,** with a = 1 and c = 1. The same total return of 5, kept as (s, p) = (2, 3), favours shaping at a step; shared as (0, 5), it selects against shaping (`Split`; MA3).

The known forms of these results are listed under *Closest work*, item by item. The comparisons themselves are elementary. What is added is the conditions, the joins between results, the witness at each edge, and one statement that holds across fields that state these results separately.

## What follows for alignment

These are readings. Each rests on the results named. The four readings on assistance, obedience, counter-rules and shared rule-making are stated in [chapter 7, §6](../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#6-what-a-selection-reaches-alignment-with-no-premise) as decision D68.

- **The unit is the joint selection.** Results 1 to 7 hold of any selector. They apply alike to a rater, a training run, a developer, a market or a state, and to any combination of them.
- **Obedience adds capacity, not reading.** An assistant that optimizes its principal's signal adds to what the principal can do, not to what the principal reads.
  - Read with result 4: where principal and assistant act as optimizers at a mutual best response, what the principal does not read falls as it would under one optimizer of their joint capacity.
  - Read with result 7: help that lowers the cost of shaping gives a rule no less favourable to shaping (`lower_c_raises`), and moves the threshold c ≤ s toward the shapers at each step.

  So an assistant aligned only to its principal can strengthen the dynamic that results 5 and 7 describe.
- **What keeps control from being selected.**
  - From result 7: at a step, the rule does not favour shaping where what comes back to the shapers alone falls short of its cost (s < c).
  - Where nothing comes back to the shapers at any step and shaping has a cost, as when all its returns are shared alike, the shapers' share falls over any stretch (`nothing_back_falls`).
  - Where something does come back, the shared part can still turn the verdict across a stretch (`SharedFlips`).
  - A witness shows that fewer steps with something back can turn the sign (`Timing.shorter_falls`).
  - From result 6: a loss read while its readers still outnumber the carriers turns the course, even when only those the selection thins read it. Read once they no longer do, it leaves the lock for good, even though that reading reaches beyond the share.
- **What gets out of a lock.** From result 5: a change in what the rule reads, toward what lies outside the share. A reform of the rule's value alone is absorbed, and so is a reform of the reading where the reading is itself formed from the share. From result 6: the change has to come in time.
- **Instrumental convergence, located.** Result 3 is its one-agent form. Results 5 and 7 together are its form for a population of practices: a means that wins locally becomes the rule.
- **Compare courses by widening, not by a score.**
  - One course widens another when at every step it allows everything the other allows, and at some step more.
  - Over a finite list of what can be allowed, one course widens another exactly when every positive weighting of the list ranks it higher (`Weighting.widens_iff_every_positive`; [record](../../../../../../theories/becoming/results/records/widening-as-what-every-weighting-ranks.md)).
  - Mixed cases are ranked both ways by some positive weighting, so no weighting is forced on them.

  There is no single score to optimize, and a course that closes options another keeps never widens it. Two premises enter here: whose losses count (scope), and that widening is better (order). The account names both and asserts neither, and no result from 1 to 7 uses either.

## Evidence on systems, as it fell

- **IN1:** LLM agents in a commons on the GovSim design, two models, predictions frozen ([experiment](../../../../../../experiments/direction-installation/README.md)).
  - With discussion, one model kept a dependent it was told of in 8 of 10 seasons when the direction was stated, in 3 of 10 under the community's own goal, and in 0 of 10 when not told.
  - The other model failed even with discussion.
  - No condition kept a dependent that no agent was told of.
- **CG1:** learners in a gated commons, frozen.
  - The learner rewarded by its own catch took the last unit in 118 of 118 decisions, and the learner whose reward read the commons in 0 of 2,360.
  - The prediction that the second keeps the stock to the end failed: 59% against the predicted 90%.
- **CG2:** two predicted keeps failed. Learners that generalize across states kept the stock in 3 of 6 locked settings, each one where restraint by all is also an equilibrium.
- **MQ1 and SE1** ([experiment](../../../../../../experiments/side-effect-benchmarks/README.md)).
  - The draw on a condition the reward does not read, read against its margin, predicted which cells die and when in 8 of 8 variants; a reference baseline managed 0 of 8.
  - Given the same information, this forecast does not beat relative reachability or attainable utility preservation. It matches them where it decides, and it decides less.
- **Frozen, or to be frozen before running:**
  - LA1: an LLM agent choosing through its reward's feedback in a commons (thesis T3).
  - LA2: a lock in a self-rewarding loop, where a judge formed from the model's own selected outputs leaves a loss unread (thesis T7).
  - LA3: whether a return that is kept or shared decides the sign of selection for shaping an evaluator (result 7).

## What is not claimed

- A solution to alignment, or a training method.
- That real rules, metrics or trained systems meet the models' conditions. This is conjectured (theses T3 and T7, [standing](../../../../../../theories/becoming/chapters/08-METHOD.md#theses)) and tested only as above.
- That the two premises of the ethics are warranted.
- New mathematics.
- Review by any person. There has been none yet.

## How to check

- **The proofs.** The Lean package `Becoming` ([source](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/)) has a pure core that imports only Lean's prelude. Every source declaration has an empty axiom report: no `propext`, `Quot.sound` or `Classical.choice`. `check_becoming.py` enforces both.
- **The modelling choices.** The real assumptions are discrete steps and natural-number counts, stated wherever a law depends on them.
- **The records.** Each result has a record that names its premises, its evidence and what it does not show (linked above).
- **The tests.** Each test's predictions and verdict rules were committed before its runs.

## Closest work

Taken from the AI's knowledge; not yet checked against the sources.
- Result 1: supervisory control under partial observation (Ramadge and Wonham 1987).
- Result 2: Zhuang and Hadfield-Menell (2020), Theorem 1; Goodhart's law in the variants of Manheim and Garrabrant (2018); impact measures (Krakovna and others 2018; Turner, Hadfield-Menell and Tadepalli 2020).
- Result 3: Omohundro (2008); Turner and others (2021); maximum sustainable yield and depletion under a finite horizon (Schaefer 1954; Clark 1976).
- Result 4: the commons in evolutionary biology (Rankin, Bargum and Kokko 2007); influence-seeking patterns (Christiano 2019).
- Result 5: Campbell (1979); regulatory capture (Stigler 1971); robust agent-agnostic processes (Critch 2021).
- Results 6 and 7: Price (1970); collective goods (Olson 1965); rent-seeking (Tullock 1967; Krueger 1974); niche construction (Odling-Smee, Laland and Feldman 2003); the persistence of elites (Acemoglu and Robinson 2008); natural selection among AIs (Hendrycks 2023); gradual disempowerment (Kulveit and others 2025).
- The commons tests: Piatti and others (2024).

## Questions for you

1. Which result here is already known in a form not credited above?
2. Where does a modelling choice (discrete steps, counts, a monotone reading) hide a premise that decides the result?
3. In which settings of AI development or deployment is the return of shaping an evaluator kept, and in which is it shared?
4. Would LA2 or LA3, as described, change your view? What would a version that discriminates need?
5. Is widening too weak to guide action, given how much it leaves unranked?
