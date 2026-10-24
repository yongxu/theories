# When selection favours control over its own rules

*Draft for alignment researchers, 24 October 2026 (AJ4). No person has reviewed it yet; standings are as of this date. Of the two results it uses that are not yet on the main line, MA2 is checked on its branch and being merged, and MA3's statements are fixed in a scratch build that has not yet been through the checker.*

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

6. **When the loss is read decides whether a lock can still be left.** Suppose the rule is the pooled reading of readers drawn from those it selected.
   - Where each carrier's reading favours the carriers at least as much as each other member's reading does, the rule's being read from the share is derived, not assumed.
   - Suppose only the members the selection thins read a loss. Then the same readers reading the same loss turn the course if they read it in time. Once the selection has left them no more than the carriers, they leave it locked for good (`Thinned.kept_iff`, `Thinned.turned_iff`; witness: one carrier to eight others under a four-to-one rule; MA2, whose home section will be in chapter 2).

7. **Capacity to shape the rule is selected exactly where its return is kept.** Model shaping in counts: each shaper leaves a + s + p descendants and each other member a + c + p. Here s is what shaping returns to the shapers alone, p is what it returns to every member alike, and c is its cost, counted as the others' advantage.
   - The rule favours shaping exactly where c ≤ s, and p decides nothing (`RuleShaping.favours_iff`, `favours_alike`).
   - Where nothing is kept and shaping has any cost, the shapers' share falls at every step (`open_falls`).
   - Over m steps that pay the cost and then n steps that return, the share holds exactly where (a+c)^(m+n) ≤ a^m (a+s)^n. So a later return never helps (`stretch_iff`, `later_not_more`).
   - Where what comes back is read from the shapers' share, the rule's being read from the share is derived, and the course locks (`byReturn_reads_iff`, `return_locks`).
   - Witness, with a = 1 and c = 1: the same total return of 5, kept as (s, p) = (2, 3), favours shaping; shared as (0, 5), it selects against shaping (MA3).

The known forms of these results are listed under *Closest work*, item by item. The comparisons themselves are elementary. What is added is the conditions, the joins between results, the witness at each edge, and one statement that holds across fields that state these results separately.

## What follows for alignment

These are readings. Each rests on the results named.

- **The unit is the joint selection.** Results 1 to 7 hold of any selector. They apply alike to a rater, a training run, a developer, a market or a state, and to any combination of them.
- **Obedience adds capacity, not reading.** An assistant that optimizes its principal's signal adds to what the principal can do, not to what the principal reads.
  - Read with result 4: where principal and assistant act as optimizers at a mutual best response, what the principal does not read falls as it would under one optimizer of their joint capacity.
  - Read with result 7: help that lowers the cost of shaping gives a rule no less favourable to shaping (`cheaper_raises`), and moves the threshold c ≤ s toward the shapers.

  So an assistant aligned only to its principal can strengthen the dynamic that results 5 and 7 describe.
- **What keeps control from being selected.**
  - From result 7: shaping is selected against where what comes back to the shapers alone falls short of its cost (s < c). That is the case when its returns are shared alike by all members and it has any cost.
  - A witness shows that a return cut short by correction can turn the sign.
  - From result 6: a loss read in time turns the course, even when only those the selection thins read it.
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
