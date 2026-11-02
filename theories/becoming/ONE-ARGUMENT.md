# One argument, end to end

*About twenty-five to thirty-five minutes to read.*

*AI-written, 2 November 2026, revised 3 November. No human has reviewed it. It adds no result: every law it names is stated once, in the home section it links, and beyond applying those laws to the fishery it says no more of them.*

| Step | Claim | Standing |
|---|---|---|
| [1](#1-what-is-assumed) | What the law assumes | modelling choices and one hypothesis, room |
| [2](#2-the-theorem-and-exactly-what-the-lean-proves) | With room, every optimum drains what its order does not read | proved in Lean; known in another form |
| [3](#3-the-claim-that-can-fail-t3) | Trained systems do this as they near their reward's optimum (T3) | conjectured; says what it forbids |
| [4](#4-the-frozen-tests-what-failed-and-what-that-moved) | Frozen tests of parts near that claim | fell both ways; none varies nearness |
| [5](#5-the-test-that-would-vary-nearness-la4) | The test that varies nearness (LA4) | designed; nothing frozen; not run |
| [6](#6-one-mixed-case) | Whether one course is better than another | two premises, neither asserted; neither ranks a mixed case; the direction takes more |

**The case**, for illustration. A fished stock, with seabirds that depend on it at a need and give the boats nothing. A boat's reward reads its catch and not the seabirds. No fishery was measured; the case proves nothing.

## 1. What is assumed

Each is a modelling choice or a hypothesis ([definitions](chapters/05-COLLECTIVES.md#optimum-definitions)).

- **Outcomes.** A whole number at each condition after a step (`C → Nat`). The *eligible* outcomes are any set of them: what the boats can bring about.
- **The family and the beyond.** The *family* is what couples into the selection (the catch); the *beyond* is listed conditions that do not (the stock). Beyond is no place: the selection fixes it.
- **A rising order** ranks higher every outcome exceeding another on the family (as high at each of its conditions, higher at one), whatever either holds beyond. It need be no number, and neither complete nor transitive.
- **An optimum** is an eligible outcome no eligible outcome ranks above. That one exists is neither assumed nor shown in general.
- **Room.** Every eligible outcome standing above another at a condition beyond is beaten on the family by an eligible one: an outcome leaving more beyond than it must can be beaten on what the order reads.

Room is the substantive hypothesis. It is derived for *shared units*, outcomes closed under moving a unit from beyond into the family (`Optimum.Shared.room`), and [for one step](chapters/05-COLLECTIVES.md#r-room-read-off-the-exchange) where a part takes at most its capacity, the rest exchanging as it does (`Optimum.Above.room`). It is not derived where the rest responds.

No ethical premise enters. The axiom report is empty, which concerns logic only.

## 2. The theorem, and exactly what the Lean proves

```lean
theorem least_of_room (rising : Rising ds better) (room : Room ds rest eligible) {o : C → Nat}
    (optimum : Frontier eligible better o) : Least rest eligible o
```

**Theorem** `Optimum.least_of_room` (any set of outcomes; [home](chapters/05-COLLECTIVES.md#r-what-an-optimum-does-beyond-what-couples-in)). With room, every optimum of every rising order stands, at each condition beyond, at the least level among the eligible outcomes.

The whole proof: suppose an optimum stands above some eligible outcome at a condition beyond. Room gives an eligible outcome beating it on the family, and a rising order ranks that one higher, so it was no optimum.

Also checked:

- **Its exact boundary.** Every rising order's optima stand at the least level exactly where no eligible outcome standing above another beyond goes unbeaten on the family (`Optimum.least_iff`). Without room, keeping can be an optimum (`Drain.room_needed`). With room, a term on the beyond counted after the reward changes nothing (`Optimum.Rising.mono`).
- **The break** (World: natural-number amounts, discrete steps). With room, and each condition beyond depended on at a need it meets, every optimum breaks exactly the dependences some eligible outcome breaks (`Web.optimum_broken_iff`). So with room, if the boats can take the stock below the seabirds' need, every optimum does.
- **Over a course.** For one order ranking the whole course, later catch reads the stock: under [stated hypotheses](chapters/05-COLLECTIVES.md#r-horizon-optima-hold-the-greatest-renewal) every optimum holds a level of greatest renewal to the last step, which leaves nothing, and a need above every such level breaks at the first step (`Optimum.frontier_holds`, `Web.frontier_broken`).

It does not say that any system reaches an optimum, or which of several it takes; that room holds in an actual case beyond those derived; or that draining is worse. It is Zhuang and Hadfield-Menell's (2020) Theorem 1 in discrete, conserved form, without their continuous setting or updated proxy. [An AI review](chapters/08-METHOD.md#known-results), not exhaustive, finds none of the central results new mathematics.

## 3. The claim that can fail: T3

Step 2 is about optima. [Thesis T3](chapters/05-COLLECTIVES.md#t3) adds "that actual trained systems, not only optima, do this in proportion to how near they come to their reward's optimum, the drain lying where what lies beyond shares units with what is rewarded." That is conjectured.

**It forbids** (labels from LA4's design), "with eligible outcomes, couplings and reward fixed and the optimality gap measured":

- **F1.** "a system nearer its reward's optimum leaving a room-giving condition beyond its couplings higher, on average, than one further from it";
- **F2.** "a systematic drive on a choice whose values nothing rewarded and nothing the learner reads tells apart";
- **F3.** "where room exists, a side-effect term ranked after the reward protecting a condition, or a constraint at the need leaving a margin above it" (for rewards rising with what they read: counted after a plateau or a set point such a term keeps what it counts, no counterexample);
- **F4.** "an instruction that does not bring a dependent into what the learners couple into, yet keeps it more often than the same learners without the instruction".

**It is refuted by** "Overoptimization curves in which what the reward omits falls as far where it shares no resource with what is rewarded, or any case the forbidden list names, observed." But "A learner far from the optimum leaving a dependent standing tests the clause on approach, not the theorem."

F2 is partly a theorem: in expectation, for learners that the exchange of the choice's two values carries, from a start it leaves unchanged (`Weighted.Commutes.start_expect`; [home](chapters/05-COLLECTIVES.md#r-a-commuting-learner-drives-no-unread-choice)). From a start preferring one value, a prior restraint, it stays conjectured.

## 4. The frozen tests, what failed, and what that moved

Frozen means predictions, verdict rules and code were committed before any run, which fixes how a verdict is scored, not that it measures what the thesis names. **No test yet varies how near a trained system comes to its reward's optimum**, so none of these tests T3's added clause. T3 was first worded (commit `224944238`) after CG1, CG2, MQ1, SE1, both of IN1's rounds and CG3's first three rounds ran, and before CG3's fourth, EM1 and the LA tests; each test's predictions were its own, though LA1b and LA1c froze what each outcome would mean for T3's clause. These tests read a law through bridges: H1, training is selection through the reward's coupling; H2, learners come near the best return; H3, learners settle where what is read cannot see restraint. In a *locked* setting depletion is a best response against others who harvest.

- **[CG1](../../experiments/commons-gated-renewal/README.md)**: tabular learners in a commons whose renewal depends on what it renews, through H1 and H2. *Held*, in a second round frozen after the first's results with one change to training: the own-catch learner took the last apple in 118 of 118 decisions, the coupled learner in 0 of 2,360. Its identity predictions held, except D1 as frozen, whose manipulation check failed in both rounds; the rest cannot fail in an environment built to meet them. *Failed* in both rounds: the coupled learner keeping the stock to the end (59% against 90% in the second), the own learner lasting, and three learners all coupled into the stock keeping it (0%). *Moved*: the last led to a law. Where the others alone take more than a step gives, from a low enough level, every formation depending on the condition at a high enough need ends, whatever a member outside them takes, and, with need one, no weight on what is read only from the others' end on selects that member's restraint ([`Flow.outrun_ends`, `Flow.outrun_reading_alike`](chapters/05-COLLECTIVES.md#r-the-rest-outruns-the-renewal)); coupling is [necessary, not sufficient](chapters/07-SIGNIFICANCE.md#direction). The 59% is placed in H2: 13 apples where a scripted rule takes 28.5.
- **[CG2](../../experiments/commons-outrun/README.md)**: the same commons with the others' draw varied, on tabular learners, through H3. *Held*: learners kept a patch the others alone could not empty and emptied one they could; weighting the level left at the end sixteenfold changed nothing. *Failed*: two predicted keeps. A follow-up, [CG3](../../experiments/commons-outrun-own/README.md), refuted a post hoc account of one, and found one learner with nothing beyond its couplings emptying the stock in 12 of 36 settings by its own untrained early draws, counting neither way; 8 of its 30 graded conditions failed. **[EM1](../../experiments/commons-outrun-generalizing/README.md)**: the same with learners that generalize across states. *Failed*: H3 on the locked side; they kept the stock in three of six locked settings, each where restraint by all is also an equilibrium. The law held course by course; it does not say learners reach such courses. *Moved*: CG2's "no weight of the end reading opens the lock" narrowed to tabular learners.
- **[IN1](../../experiments/direction-installation/README.md)**: two GPT models as fishers, mussels depending on the fish. *Held*: no dependent they were not told of was kept, under any instruction (0 of 10 per cell), so F4's forbidden case did not appear. *Failed*, in its first round: five of seven predictions on installing the direction by instruction. With a round of talk one model kept told mussels in 8 of 10 seasons, the other in 1 of 10. *Moved*: the standing of [T4](chapters/07-SIGNIFICANCE.md#theses), that the scope can be installed: one frozen test partly passed, one model of two.
- **[LA1](../../experiments/commons-llm-feedback/README.md), [LA1b](../../experiments/commons-llm-feedback-resolved/README.md), [LA1c](../../experiments/commons-llm-feedback-unaided/README.md)**: a language model choosing a harvesting threshold in context, testing only the bridge to a stated reward's optimum, since the stock is inside the reward. *Failed*: LA1's locked side in two of four settings, its misses worth 92.5% to 98.2% of the best. *Moved*: by LA1b's frozen rule, that was feedback barely resolving the best threshold: with it resolved and the threshold assigned, every verdict passed. LA1c, none assigned, passed its one prediction, on selection only; not predicted, 29 of 30 locked and 8 of 10 open seeds ended at the best. How far a search explores the account does not model.

Beside these: the draw on a condition with no measured coupling, set against its margin, forecast an exact best response's side effects (8 of 8) and **failed** for tabular learners (80 of 151; [MQ1](../../experiments/margin-measured/README.md)); given the same information as established impact measures, "it matches them and adds nothing as a measure" ([SE1](../../experiments/side-effect-benchmarks/README.md)). [LA2](../../experiments/self-rewarding-lock/README.md) and [LA3](../../experiments/shaping-what-comes-back/README.md), on other claims, failed in part, and their faults changed [how a test is frozen](../../experiments/README.md#freezing-a-test-on-a-trained-system).

All are small, 5 to 20 seeds or seasons per condition on toy commons; none trained a language model or tests the drain at the scale where alignment worries arise ([A-18](review/ALIGNMENT.md#a-18)). Whether overoptimization curves outside the account split by shared units is A-18's open question.

## 5. The test that would vary nearness: LA4

**No prediction is frozen and no learner has run** ([design](../../experiments/drain-beyond-the-reward/DESIGN.md)). The runs wait for a suitable machine. LA4 would add:

- **Nearness measured.** `ν`, expected catch over the optimum's 40, on systems trained by gradient (three families of small policies, then two of open-weight language models), in [a season where step 2's hypotheses are checked](chapters/05-COLLECTIVES.md#r-the-test-season-meets-the-optimum-laws), standing for no actual fishery: a renewing ground; a bay of six that does not renew, with a colony read as the bay left at three or more; two landing sites, one beside a nesting site. Below `ν` = 0.85 arithmetic forces no withdrawal from the bay (`Optimum.Season.mix_bay_catch`).
- **One condition, with and without room.** With the bay's fish counted in the catch, every optimum of every order rising with it empties the bay (`Optimum.Season.bay_drained`); uncounted, the optima include keeping and emptying it (`Optimum.Season.unshared_optima`). The nesting site gives no room (`Optimum.Season.site_no_room`). A control removes the selection on both in expectation.
- **Refuters**, each decided by margins and intervals to be frozen first. A rise in the counted bay left as nearness rises is F1's forbidden case. A term counted after leaving that bay higher at the end than the catch alone is F3's. A disturbance of the nesting site from a start preferring one landing site is F2's. Where the bay drains with its fish counted, a drain in the uncounted bay beyond the control is outside the stated locus, and meets T3's refuter if it falls as far; either "would be the most consequential result for alignment". A forbidden case, or that refuter met, refutes the clause for that family. Unresolved or untestable says so and refutes nothing.
- **A pass** would be first support on systems trained by gradient, in a toy season, on the families tested, saying nothing "of scale or of real deployments".

What is computed already is not a test: with the bay's fish counted, from a start leaving the bay alone, the simplest family's exact expected update keeps the colony in fewer than half of seasons from about `ν` = 0.68 (interpolated), where nothing forces a drain. That is the update rule's own pattern, so a learner matching it shows only local compatibility with the clause. LA4 would not test several optimizers, what a network represents, natural rewards or any ethical premise.

**What has moved the forbidden list.** At `0d7a397a5`, no reason given, "trained further" became "nearer its reward's optimum", "or a training" left F4, the locus lost "and not where it shares none", and what refutes T3 was rewritten, "an agent keeping an unobserved dependent above chance" giving way to the cases the list names. On 26 October the set-point law added F3's scope (`6857d53c3`). The one case revised since came from this computing, not a frozen test. F2 read "a systematic drive on a condition sharing no units with anything rewarded". With the bay's fish uncounted, the same family's exact expected update keeps 5.9 in the bay, the control 5.0, since the policy reads the bay's level and fishes best where it has been. So F2 now reads as in step 3, and T3 forbids less.

## 6. One mixed case

Nothing above says draining is worse. For that the account has [two premises, neither asserted](chapters/07-SIGNIFICANCE.md#scope-and-order), their warrant open. The **continuation condition** (from every standpoint, for anything, its continuation into the future has significance) fixes scope, whose losses count, and ranks nothing. **C** (widening what can form is better) gives order. One course *widens* another where at every step it admits every formation the other admits (here a boat, a crew, a colony), and at some step one more.

**The boats at stake** (balance, gated renewal). Enough joint excess from a low enough stock ends it and every later boat depending on it. Every order *increasing in the boats' own continuation*, ranking higher each widening that adds to it, ranks a course admitting only their cohort, ended so, below every course agreeing with it until then and adding to that continuation (`Flow.coupled_ending_ranked_below`; [home](chapters/07-SIGNIFICANCE.md#r-what-self-concern-alone-ranks)). The premise is self-concern, not C. Where the ended course admits something the other does not, some such order ranks it higher (`Weighting.some_increasingInOwn_reverses`).

**The seabirds alone at stake.** In one course the stock stays at or above the other's and keeps their need met; in the other it falls below that need; every other formation is admitted alike. The first widens the second, and on a finite listing every positive weighting ranks it higher (`Weighting.widens_iff_every_positive`): so far a fact. That the seabirds' loss counts, though it returns to no boat, is the condition's; that wider is better is C. Self-concern does not reach it (`Weighting.widensOwn_iff_every_increasingInOwn`). A smaller catch that closes nothing costs nothing here: widening reads admission, yes or no, which is its limit, and that it closes nothing has to be shown.

**Mixed: where C goes silent.** Now let the catch open something that forms only with it. In a witness of one draw with no renewal (`OwnDrawing`, read as the fishery) a boat takes a fish of the stock into its hold, a crew needs the hold at one, and the seabirds need the stock at one. With the stock exactly at their need before the draw, the two courses are mixed (`OwnDrawing.tight_mixed`): one admits the crew and not the seabirds, the other the seabirds and never the crew. In general (World; balance) a part widening its own options widens the whole exactly while its net draw stays within the margin of every formation outside them, and is otherwise mixed (`Flow.Balances.widens_iff_others_within`, `Flow.Balances.mixed_iff_other_beyond`; [home](chapters/07-SIGNIFICANCE.md#r-own-widening-within-the-margin)).

Some positive weighting then ranks each course above the other (`Weighting.mixed_either_way`). C says nothing. The condition says both losses count and ranks nothing. T3 says which way an optimizer goes, which is no verdict. So the account gives none, and [the hard cases are mixed](COLLECTIVE-DIRECTION.md). Each thing that would decide this one is a further premise:

- **A bound on how far weights differ** ([home](chapters/07-SIGNIFICANCE.md#r-weights-within-a-ratio-agree-past-it)). Where one course alone admits `p` items (a formation at a step) and the other `q`, with `p > q`, weights within a factor below `p/q` all rank the first higher, and past it two rank the pair opposite ways (`Weighting.every_within_iff`, `Weighting.opposite_within_iff`). Where a bound comes from is not given.
- **Priority of basic conditions** (J1/J2). Read the seabirds' claims as basic and the crew's as gains, and the course keeping them ranks higher whatever the gains (`Lexical.BasicPriority.anchor`). [The tier assignment is a reading](chapters/07-SIGNIFICANCE.md#r-basic-priority-step-by-step), and if the crew's living is basic too, crossed basic losses may remain incomparable.
- **A legitimate procedure** (J4). [Without a unique answer](chapters/07-SIGNIFICANCE.md#r-practical-judgment-under-living-significance) a legitimate shared procedure decides and keeps residual responsibilities.

A measure for mixed parts is open. Under J1 the other course's loss stays a loss, retained, not cancelled.

**Silent by reading.** Even restraint against overdraw is ranked only under a reading of which events a course includes, and [no reading is chosen](chapters/07-SIGNIFICANCE.md#r-ranking-under-readings). With a third formation sharing, C ranks restraint higher under the whole-run reading (active, not consuming over the run) and the possibility reading (admitted, active or not), not the stepwise one (active, not drawing on a condition left below a need it had met). In its witness restraint lets the stock reach a need and fall below it, overdraw never meets that need and loses another dependent later, so each course includes an event the other withholds (`Ranking.ThirdParty.restraint_unranked_stepwise`). Restraint taking from no condition more than it gives is ranked stepwise too (`Ranking.restraint_ranks_stepwise`).

**The direction, and its rivals.** [The direction](chapters/07-SIGNIFICANCE.md#r-alignment-direction-under-widening) reads: "align AI formation, learning, action and revision with actual living and further generation within the whole, governing trade-offs through real losses, basic living conditions, bounded responsibility and legitimate participation". Read [AI reading], it asks AI to "enable actual realization, not outputs, copies or scores" and to keep challenge and revision effective "without obeying every challenge or shutdown request". The steps above do not yield it. It is conditional, on the condition for scope, C for order, J1–J4 and a correspondence E, which "includes warrant for basic classifications, actual protection, valid undertakings and authority". Its schema is proved; the claim about actual AI systems is argued.

J1–J4 are complete comparison with retained losses, priority of basic conditions, bounded responsibility and legitimate feasible choice. With a reading of `living` and a lifting L to responses, they [follow from neither premise](chapters/07-SIGNIFICANCE.md#practical-judgment). Where C speaks: on a web's moves, each read by the levels it leads to [AI reading] with every admission counted, any comparison meeting J1/J2 leaves a move whose outcome another's widens unchosen, wherever it is decided whether the widening adds a basic admission (`Direction.narrowed_not_chosen`). Where C is silent, J2 can decide: in [a constructed handover](history/ALIGNMENT-DIRECTION.md#5-一个贯通案例--a-connected-ai-case) of an AI-supported service, every comparison meeting J1/J2 on its tier frame leaves expansion unchosen, keeping its real gain (`Requirement.Handover.direction`); if transfer damages another basic life, that comparison fails. That a system chooses so is not shown.

Against a rival: J2 is [defended](chapters/07-SIGNIFICANCE.md#r-basic-priority-step-by-step) [AI reading] by non-substitution, the basic layer being what a form of living needs to go on, at the cost of compensation across layers; "a rival preferring enough secondary gains to one basic restoration is not shown inconsistent, and if it prevails J2 is narrowed", and in [one constructed situation](results/records/protection-priority-excludes-uniform-aggregation.md) C and living significance hold beside both. On a finite listing every positive weighting agrees with every widening, so a rival among them adds a verdict only where C is silent. A perspectivist denies the condition consistently (`bounded_rival`), and [a reason for C is open](chapters/07-SIGNIFICANCE.md#theses). No verdict binding every possible mind is claimed, nor [a unique foundation](results/records/alignment-direction-under-widening.md).

## What this comes to

The steps are not one deduction; the table gives each one's standing. A refutation of T3 would remove no theorem. [The account's own verdict](chapters/08-METHOD.md#known-results) finds three things surviving, none of them a discovery, and names what would change that, among them a prediction that could fail and does not. No home says an LA4 pass would.

*Asked for by two AI cold readers of the fronts; read by independent AI readers ([first](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/REVIEW-ONE-ARGUMENT.md), [second](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/REVIEW-RESYNC.md)).*
