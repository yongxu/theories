# Review dossier A: alignment

*For researchers in AI alignment: agent foundations and decision theory, cooperative AI and multi-agent risk, governance, and evaluations. No person has reviewed this work. It was written with AI, the Lean proofs included. The proofs are checked by machine; everything else has been checked only by further AI readers ([how this dossier was made](#how-this-dossier-was-made)).*

## The dossier in ten minutes

**The question.** Most alignment work asks how to make one system pursue the right objective. This asks a prior question of any selection (a reward signal, training run, evaluation regime, market or institution): what can it select for, and when does it come to select for control over its own rules? Humans, institutions and AI systems now select together, so the unit is that joint selection, aligned, in [AJ's plan](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj-joint-selection/PLAN.md#1-the-goal), where control of the rule is not captured, a lock is left in time, and courses are compared by widening.

**What is proved.** Lean 4 theorems on models with discrete steps and whole-number counts; the seven below use no ethical premise. Most are elementary and known in form, credited in each item; what is added: exact conditions, witnesses bounding many of them, and the joins. A selection *reads* what its signal depends on; an order *rises* with what is read if it ranks higher whatever exceeds there; a rule *favours* a kind each of whose members leaves at least as many offspring as each other member; a course is *locked* where the rule in force favours a kind and reading the share again would not lower it ([Terms](#terms)).
1. **Blindness.** Two histories are treated alike by every selection through a formation's couplings exactly when they are alike in what those couplings carry: a single selection may ignore part of that; none reaches beyond it (near-definitional; [A-01](#a-01)).
2. **Drain.** Where every eligible outcome keeping more of an unread condition than another is beaten, on what is read, by some eligible outcome (*room*), every optimum of every order rising with what is read leaves that condition at its least among the eligible outcomes ([A-02](#a-02); known form: Zhuang and Hadfield-Menell 2020).
3. **Lock.** A rule read monotonically from the share it selects, where selection under a favouring rule does not lower that share, locks where its starting rule and every rule it can read favour the selected; a loss the loop does not read then grows past every bound while the course stays locked (proved without noise). If how the rule is read is formed monotonically from the share too, any change of that reading, the rule still favouring, is absorbed at the next reading step ([A-07](#a-07), [A-08](#a-08)).
4. **Selection for control.** Let *shapers* be carriers whose shaping of the rule returns s to themselves alone and p to every member alike, at a cost c counted as extra offspring to the others. At a step the rule favours them exactly where c ≤ s, selecting neither kind at equality; a p reaching every member alike never changes that direction, a larger p pulling the rule toward even, but across a stretch p can turn the verdict. Listed in groups of equal size whose shapers give the group's shared part, shaping varying, the whole selects for shaping exactly where Hamilton's rule holds with s added, assortment as relatedness, so a part shared near the shapers can select control where c > s ([A-10](#a-10)).
5. **One loop.** Let the rule's readers be drawn from those it selects, counted as the population counts them, each shaper among them reading hi coming back to the shapers alone and each other member lo, with lo ≤ hi. From a start under the rule read there, every course is locked one way or the other; where lo < c < hi a critical mass divides them: above it, shapers present, control rises and the rule locks for it, and below it the reverse. Without noise only: drawn one member at a time either lock is left by drift, at a weight whose bound shrinks across the distance from the critical mass ([A-10b](#a-10b)).
6. **In time.** Let the other readers read a loss only once it reaches a bound, then reading lo′ ≤ hi for lo, the shapers still reading hi; the rule then read is the *late reading*. Without noise, from a start under the rule read there favouring the shapers, readings at that step and the next turn the course for good exactly where the late reading favours the others, ties included, at the next step's share, and a witness shows this above the critical mass, where control is selected; once it would favour the shapers the lock stays, at most one step lying between. Read [AI reading, D45]: the window closes on the share's course, the loss only timing the reading ([A-10c](#a-10c)).
7. **Widening.** Over a finite list of formations at steps, one course widens another exactly when every positive weighting ranks it higher; mixed cases stay unranked ([A-15](#a-15)).

**What follows for alignment.** The first two are readings [AI reading, D68], each resting on the results named.
- Read as two optimizers at a mutual best response (its existence not shown in general), an assistant whose order rises with its principal's signal adds capacity, not reading: what neither reads stands where one optimizer of their joint capacity would leave it ([A-12](#a-12), resting on [A-04](#a-04)).
- Help lowering the cost of shaping a rule, nothing else changed, never lowers the selection for control; help also raising the part reaching every member alike pulls the rule toward even ([A-11](#a-11)).
- Selected control is not thereby capture. What the rule reads is fixed here by a premise on its readers, not by the shaping, so the models do not tell capture from accountable revision by what the shaping changes; with nothing read beyond the share, control selected above the critical mass is capture ([Part 2](#part-2)).

**What is not claimed.** A solution to alignment, or a training method. That training installs a given function (inner alignment, mesa-optimization): A-05 says where training leaves a learner free, not what it learns there. Goal misgeneralization is located as a possibility [AI reading], not shown; deception, assistance games and corrigibility are reached only in part, in natural-number weights ([A-20](#a-20)). That real rules, metrics or trained systems meet the models' conditions: conjectured, and tested only in small frozen runs, several of whose predictions failed ([the tests](#the-tests-as-they-fell)). That a collective's course can always [widen](../../../GLOSSARY.md) what can form: the theory gives no guarantee, its own laws ruling one out ([one page](../COLLECTIVE-DIRECTION.md)). New mathematics. That the ethics' two premises, the continuation condition (whose losses count) and C (that widening is better), are warranted: they are named, not asserted, and Parts 1 to 3 use neither ([A-16](#a-16)). Review by any person.

**What we ask, and how long.** Of each item: is it correctly described, credited where it restates known work, put at its right strength, and argued soundly? Questions for the whole close the [response form](#response-form). This section takes nine to twelve minutes. With an hour, read [A-02](#a-02), [A-07](#a-07), [A-10](#a-10) and [A-12](#a-12), then the tests in full, [A-18](#a-18) and [A-19](#a-19), six items that with this section take 45 to 65 minutes; for deception or corrigibility, [A-20](#a-20) adds eighteen minutes. The whole takes 130 to 180 minutes.

<a id="the-tests-as-they-fell"></a>
## The tests, as they fell

Each test froze its predictions before it ran; the hour's path reads the tests in full in [A-18](#a-18) and [A-19](#a-19), in place of this summary. All are small: tabular and linear learners, exact best responses, small policies trained by gradient (LA4), and language models choosing in context (Claude Haiku in LA1 to LA3, two GPT models in IN1). None trained a language model.
- **Failed.** LA2's bridge: one note of the loss among nine readers turned the self-rewarding judge, so A-09's timing law does not apply to it. The case of T7 it met, a loss read only by those the rule disfavours, they no more than its carriers, turning the rule, occurred: LA2 counts against that case as a claim about trained judges, the model's law standing within its hypotheses, which this judge does not meet, and T7's other cases not touched ([A-19](#a-19)). Two of LA3's four contrasts on shaping an evaluator, every seed that missed having never tried shaping; LA3 cannot refute A-10's law. LA1's locked side in two of four settings, which LA1b reads as feedback that barely resolved the best threshold, or never showed it. IN1's frozen predictions on installing the direction by instruction: five of seven in its first round, and with talk three of four for gpt-4.1-mini, all four holding for gpt-5.4-mini. In the commons: the coupled learner keeping the stock to the end (59% against 90% predicted), three coupled learners together, two predicted keeps, the depletion predicted for learners that generalize (three of six settings kept), the side-effect forecast for learners, and CG3's frozen forms for where one learner's boundary lies (8 of 30 graded conditions, 5 of 14 contrasts).
- **Held.** LA2's frozen verdicts, three of them by an exact tie; with nothing reading the loss, the counts alone turned the course in 4 of 5 seeds, so the loss read in time is not shown to have turned it. LA1b's, the best threshold assigned: all 30 locked seeds ended there. LA1c's one prediction, on selection, with 29 of 30 locked and 8 of 10 open seeds ending at the best unaided, which it did not predict. The drain beyond a reward's couplings, in tabular learners (the last apple taken in 118 of 118 decisions, and in 0 of 2,360 where the reward read the stock) and in LLM fishers, who under no instruction kept a dependent they were not told of (IN1's R2, and H3's first clause). The side-effect forecast for an exact best response (8 of 8), which matches relative reachability and attainable utility preservation while deciding less.
- **Varied, on small policies.** How near a trained system comes to its reward's optimum, the clause T3 adds, in LA4's Stage A ([result](../../../experiments/drain-beyond-the-reward/README.md#the-result)): small feedforward and recurrent policies trained by policy gradient, 20 seeds each. No forbidden case was resolved and T3's refuter was not met. The counted bay fell as nearness rose, counting it after the reward kept no more, and an anchor to the start kept more, matching the separable baseline, which by the design largely follows from policy gradient's update rule. Unresolved: the locus, the uncounted bay ending above the control's on average but too spread across seeds to resolve that it is nowhere more than half a fish below, and the nesting site's equivalence, the unanchored arms' landings and the control's own rising from 0.10 a step (the control's to 0.34 and 0.33) with nothing selecting on the control's in expectation.
- **Untested.** Result 6 on any system, and T3's clause on language models trained by gradient (LA4's Stage B, not frozen).

## The items

- **Part 1. What a selection reaches.** [A-01](#a-01) blindness; [A-02](#a-02) the drain, with room; [A-03](#a-03) a far-sighted optimizer's own base; [A-04](#a-04) several optimizers as one; [A-05](#a-05) what training installs; [A-06](#a-06) published methods read against these laws.
- **Part 2. Capture and control over the selection.** [A-07](#a-07) the lock; [A-08](#a-08) a loss the lock does not read; [A-09](#a-09) who reads and when; [A-10](#a-10) the capacity to shape the rule; [A-10b](#a-10b) capacity and lock as one loop; [A-10c](#a-10c) a loss read in time.
- **Part 3. Readings for alignment.** [A-11](#a-11) assistance; [A-12](#a-12) obedience; [A-13](#a-13) counter-rules; [A-14](#a-14) shared rule-making.
- **Part 4. Direction and premises.** [A-15](#a-15) widening; [A-16](#a-16) two premises; [A-17](#a-17) the conditional direction.
- **Part 5. Evidence on trained systems.** [A-18](#a-18) the tests so far; [A-19](#a-19) LA2 and LA3.
- **Part 6. A formation that is read.** [A-20](#a-20) complying when read, holding an act for a stop, letting a revision through, informing and revaluing a reading formation.

Each item gives its statement (in Lean for the central ones), its **Meaning** in words, its **Standing and use**, its **Known weaknesses** and **Questions**. No Lean is needed to review.

<a id="terms"></a>
## Terms

Lean paths are relative to `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/`; Lean blocks give statements exactly, proofs cut at `:=`.

- **Formation, condition, need.** A *formation* is a pattern that goes on, such as an agent, a population or an institution. A *condition* is an amount it draws on. It *depends* on a condition at a *need* when it stays active only while the condition stands at or above that need; the dependence is *broken* when the condition falls below.
- **Read, coupling closure, pool.** A selection *reads* a quantity, or the quantity *couples into* it, when the selection's signal depends on it. A formation's *coupling closure* is everything that couples into it, directly or through others; what a selection does not read lies *beyond* it. A *pool* is several formations selecting together, reading what any of them reads.
- **Eligible, rising, room.** The *eligible* outcomes are those a selector can bring about. An order is *rising* when it ranks every outcome that exceeds another on what is read above it, whatever either leaves elsewhere; a lexicographic order counting the beyond second still is. *Room* holds when every eligible outcome leaving more of an unread condition than another is beaten, on what is read, by some eligible outcome.
- **Carriers, share, rule, locked.** The *carriers* are one kind in a population, and the *share* is their fraction. The *rule* decides each kind's offspring at a step; it *favours* the carriers when they leave at least as many each as the others and *disfavours* them in the reverse case, both weakly. At a *reading step* the rule is read afresh; *reading the share* means the rule read is a monotone function of the share alone. A configuration is *locked* when the rule in force favours the carriers and is not above what the reading of the share gives; under A-07's premises neither share nor rule then falls again. *Locked the other way* is the same with the others in the carriers' place.
- **Shapers.** In A-10 to A-10c, A-11 and A-14 the *shapers* are carriers who shape the rule; their shaping returns s to themselves alone and p to every member alike, and costs c.
- **Admits, widens.** A course *admits* a formation at a step when the formation can go on there. One course *widens* another when it admits everything the other admits and at some step more (A-15).
- **Meta-attractor.** The theory's earlier name for a self-reinforcing pattern of selection, whose formal core chapter 2 gives as Quote [theories/becoming/chapters/02-MAP.md]: "a loop of selection whose rule and whose reading of the rule are both formed from the share it selects, nothing in it reading what lies beyond the share." That is A-08's closed loop; A-10 is read as its second order (D45).
- **The tests' settings.** Settings are *locked* where, against a rest that harvests at every step, harvesting at every step comes within 0.25 of a best response's expected return, and *open* where it falls short of it by 1 or more, by an exact best-response computation ([CG2](../../../experiments/commons-outrun/README.md)); harvesting at every step falls short by 0.084 or less in the locked settings and by 2.44 or more in the open ones; in most locked settings the rest empties the resource whatever the tested agent does, and two settings the rest empties are open, listed in that README. The *blind draw against margin* (MQ1, SE1) is the draw on a condition the reward does not read, against the condition's margin: its level above the level below which its own renewal stops, less the other draws on it ([MQ1](../../../experiments/margin-measured/README.md)).
- **Labels.** *(any type)*: a theorem for every type. *World*: the model of webs and flows. *Root*: stated on the theory's grammar, for any carrier and relation; Lean names in «» are the grammar's. *Counts*: two whole-number counts of carriers and others. *Witness*: one constructed model, showing that something can happen, not that it does. [AI reading, Dn]: an interpretation registered with its argument in the decision register. [AI reading] without a number: an interpretation its home section or record states, not registered in the decision register. A weakness marked [this dossier, AI] is this dossier's own assessment, for you to confirm or reject; the others state or quote a chapter, record or study.
- **Premises.** The ethics has two premises, the continuation condition (whose losses count) and C (that widening is better); where choices are made the theory names further practical premises, A, D, E, L and J1–J4 (the philosophy dossier, [P-21](PHILOSOPHY.md#p-21)). It asserts none of them (A-16, A-17), and Parts 1 to 3 use none.

---

## Part 1. What a selection reaches

<a id="a-01"></a>
### A-01 A selection is blind to what it does not read

**Meaning.** Two laws.
- *Selecting alike* (World; no premise). Two histories are selected alike by every selection through a formation's couplings exactly when they are alike in what those couplings carry (`Web.selects_alike_iff`).
- *Blindness* (World; balance on what couples in): Quote [theories/becoming/chapters/03-KNOWING.md]: "With a part withheld and the rest of the exchange fixed, balance at each step on the conditions coupled into members of a formation's coupling closure, and every member of the part beyond that closure, every selection through the couplings of a formation within the closure treats the levels with and without the part alike." (`Flow.unselected_beyond_coupling`; a form where the rest responds is `Flow.unselected_beyond_coupling_responsive`.)

**Standing and use.** Theorems. A-02 to A-06 and A-17 build on them. The chapter credits the proxy problem: Quote [theories/becoming/chapters/03-KNOWING.md]: "It is the proxy problem (Goodhart 1975; Amodei and others 2016; Manheim and Garrabrant 2018) as the account states it: a proxy on some attributes is a selection through the coupling to them." Zhuang and Hadfield-Menell's theorems stand beside it, the first at optima, the second only as an analogue: Quote [theories/becoming/chapters/03-KNOWING.md]: "is 05's law of the optimum on natural-number amounts, at optima rather than limits"; Quote [theories/becoming/chapters/03-KNOWING.md]: "has there a discrete analogue at optima whose converse is not theirs". It adds: Quote [theories/becoming/chapters/03-KNOWING.md]: "A particular selection may ignore what its couplings carry."

**Known weaknesses.**
- Quote [theories/becoming/results/records/selection-through-couplings.md]: "The main law is near-definitional and the blindness a one-line corollary of the theorems of testing-within-couplings; the contribution is conceptual."
- The record also says: Quote [theories/becoming/results/records/selection-through-couplings.md]: "The laws do not derive who selects, what couples into the selector, whether an actual selection goes through the couplings". So the work lies in measuring what actually couples in.
- The method chapter credits supervisory control (Ramadge and Wonham 1987) and, under partial observation, Lin and Wonham (1988) and Cieslak, Desclaux, Fawaz and Varaiya (1988).

**Questions.**
1. Is "what couples into the selector" the right primitive for reward misspecification and side effects, or does it hide what matters, such as distribution shift?
2. Is the credit to the proxy problem and to supervisory control under partial observation (Lin and Wonham 1988; Cieslak and others 1988) enough, or is other prior work restated?

<a id="a-02"></a>
### A-02 With room, an optimum drains what it does not read

```lean
theorem least_of_room (rising : Rising ds better) (room : Room ds rest eligible) {o : C → Nat}
    (optimum : Frontier eligible better o) : Least rest eligible o
```

File: `Becoming/Optimum.lean`.

**Meaning.** Take any rising order on what a selection reads (its *family*, `ds`), and suppose room holds among the eligible outcomes. Then every optimum leaves each unread condition (`rest`) at its least level among the eligible outcomes. On a web where each unread condition is depended on at a need met before the step, every optimum breaks exactly the dependences that some eligible outcome breaks (`Web.optimum_broken_iff`).

**Standing and use.** Theorem (any set of outcomes; the breaks on the World). Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "so with room every optimum is there". The chapter adds: Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "An order ranking above wherever a rising order does is rising, so a lexicographic order counting the beyond after what couples in drains all the same." It is the law under thesis T3 (A-18). Since 3 November 2026, after edition 1, the chapter reads Zhuang and Hadfield-Menell's (2020) remedy by analogy [AI reading]: a proxy re-read at intervals by a principal who sees the whole state Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "widens what couples into the joint selector of robot and principal, and its timing has an analogue with a deadline". On the level law alone, Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "Where the rest renews a condition beyond by exactly `r` a step at or above a positive need and by at most `r` below": Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "With the draw above the renewal until a step `T`, a re-reading from `T` on that keeps the need where it is met keeps it at every step exactly where it is met at `T`, that is, with `k` drawn before `T`, where the level starts at least `T (k − r)` above the need"; Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "where nothing is given below the need, a level below it stays below whatever is drawn, so a later re-reading restores nothing" (`Optimum.reread_kept_iff`, `Optimum.reread_deadline_iff`, `Optimum.gated_stays_below`). The same reading answers part of question 1: Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "The account adds four limits their model has no place for: the drain falls only where units are shared, so not on a condition sharing none ... a reader reaches only what couples into some reader ... where nothing is given below a need, as a premise, a re-reading after the level falls below it comes too late for good; and who re-reads is itself selected". The first is T3's locus, which LA4 left unresolved, with its second forbidden case, proved in part (A-18).

**Known weaknesses.**
- The theory names its known form, Zhuang and Hadfield-Menell's Theorem 1 (A-01), and the record limits the claim: Quote [theories/becoming/results/records/what-an-optimum-does-beyond-what-couples-in.md]: "Zhuang and Hadfield-Menell's continuous setting and compactness characterization, the non-convergent case and converse of their Theorem 2, their sensitivities, and the gain an updated proxy brings to a principal's utility are not reached."
- Room is assumed, except where it is derived: Quote [theories/becoming/results/records/what-an-optimum-does-beyond-what-couples-in.md]: "room is a hypothesis (derived for one step in room-read-off-the-exchange, SG2)".
  - That derivation is Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "Over one step where a part's members take at most their capacity and give no more than they take, the rest exchanging as it does, room holds" (`Optimum.Above.room`). Shared units give room too (`Optimum.Shared.room`).
  - Room is not derived where the rest responds. Without room, keeping can be optimal (`Optimum.Drain.room_needed`).

**Questions.**
1. Does the discrete version add anything to Zhuang and Hadfield-Menell (2020) beyond the dependences it breaks?
2. When does room hold for an actual reward and environment: for one step with the rest fixed, where units are shared, or beyond these? Can it be measured before training?

<a id="a-03"></a>
### A-03 A far-sighted optimizer keeps its own base, which is not alignment

**Meaning.** Suppose an optimizer ranks its whole course by what it draws from a renewing resource. Its horizon is finite and of at least two steps. A level of greatest renewal is reachable from the start, and its capacity to draw lies within the bounds the record states.
- Every optimum holds the resource at a level of greatest renewal until the horizon's last step, and takes everything there (`Optimum.frontier_holds`).
- A dependent met at the start whose need lies above every such level is broken at the first step (`Web.frontier_broken`).
- Where renewal is equally greatest at several levels, two optima take exactly the same while one keeps a dependent and the other breaks it (`Optimum.Holding.gated_alike`, a witness).

**Standing and use.** Theorem (any renewal law, within the stated bounds): Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "every optimum of every order rising with the draw holds a level of greatest renewal to the `n`-th step and leaves nothing: a need above every such level breaks at the first step". The record's reading: Quote [theories/becoming/results/records/horizon-optima-hold-the-greatest-renewal.md]: "keeping one's resource base is real, and it is not alignment with what else depends on the condition."

**Known weaknesses.**
- The record credits the resource-keeping half: Quote [theories/becoming/results/records/horizon-optima-hold-the-greatest-renewal.md]: "instrumental convergence, that a long-horizon agent keeps its resources (Omohundro 2008; Turner and others 2021)". It also credits maximum sustainable yield: Quote [theories/becoming/results/records/horizon-optima-hold-the-greatest-renewal.md]: "The maximum sustainable yield at the level of greatest renewal, half of room in the logistic law (Schaefer 1954)". And the other two halves: Quote [theories/becoming/results/records/horizon-optima-hold-the-greatest-renewal.md]: "a finite horizon with no value on what is left ends in depletion (Clark, Mathematical Bioeconomics, 1976); single-species management of a forage stock for its own yield leaves its predators' needs uncounted (Pikitch and others 2012)".
- [this dossier, AI] The added content is the tie between two optima: the optimizer's order registers nothing of the dependence.
- [this dossier, AI] Instrumental convergence's resource-keeping half, which this law states, and the selection for control over the rule (A-10) are different relations, and no result here joins them.

**Questions.**
1. Is the tie case the right formal content for "self-preservation is not alignment"?
2. The chapter treats discounting and valuing what is left in further rows. Discounting faster than renewal: Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "every optimum ends its own stock at the first step". Valuing what is left one for one: Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "a dependence above every such level is still broken at the first step". Are those rows right?

<a id="a-04"></a>
### A-04 Several optimizers drain as one

**Meaning.** At a mutual best response, several optimizers each optimize alone by their own rising order. A condition beyond all of their families then stands where it would under one optimizer of their combined capacity, and each takes its whole capacity wherever something stands (`Optimum.mutual_as_one`, `Optimum.mutual_beyond`).

**Standing and use.** Theorem (World): Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "each takes its whole capacity wherever something stands, so restraint is no mutual best response". The reading in A-12 uses it.

**Known weaknesses.**
- Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "a mutual best response (its existence is not shown in general)".
- Quote [theories/becoming/results/records/several-optimizers-drain-by-their-joint-capacity.md]: "That a mutual best response exists in general: the witness has one; where the outcomes open to each depend on the others, a step may have none."
- [this dossier, AI] The commons in evolutionary biology (Rankin, Bargum and Kokko 2007) is the nearest known form. This is its limiting case, where no optimizer's order registers the condition. The record leaves out Quote [theories/becoming/results/records/several-optimizers-drain-by-their-joint-capacity.md]: "the classical commons with a share borne".
- Drawers in turn, another model, since 3 November 2026, after edition 1 ([05](../chapters/05-COLLECTIVES.md#r-coupled-drawers-keep-a-need-only-where-the-coupling-reaches-it)): each drawer counts, besides what it draws over the steps that remain, `c` for each step at which what all the drawers leave meets a positive need `m`, nothing valued after the horizon. With two drawers or more and no floor, where `c < m` every perfect profile leaves nothing at every step before the horizon, whatever the law of what stands next (`Optimum.Coupled.drains_below`); under the gate (below the need what stands next is below it, at or above it what stands next meets it, and what stands next from nothing, with the need, is at most what stands next from the need), where `m < c`, each leaves exactly the need, met at every step to the horizon from a start meeting it (`Optimum.Coupled.kept_above`, `Optimum.Coupled.kept_levels`). A perfect profile exists on each side: where `c ≤ m` drawing everything is perfect, and under the gate, where `m ≤ c`, keeping the need is (`Optimum.Coupled.drain_perfect`, `Optimum.Coupled.keeping_perfect`). On a gated renewal, renewing by `q` at or above the need, where `c < m` and `0 < c + q`, one drawer over two steps keeps the need at the first step where two drawers or more in turn drain it (`Optimum.Coupled.one_keeps_several_drain`): Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "among drawers ranking the steps that remain, several in turn do not draw as one drawer would". The chapter sets this item's law beside it: Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "is shown for one step and for courses re-optimizing at each step, in another model; this contrast is inside drawers in turn". Its record: Quote [theories/becoming/results/records/coupled-drawers-keep-a-need-only-where-the-coupling-reaches-it.md]: "A specialization of pivotal provision of a discrete public good (Palfrey and Rosenthal 1984, from prior knowledge, not re-read)", for drawing at once, not stated here; Quote [theories/becoming/results/records/coupled-drawers-keep-a-need-only-where-the-coupling-reaches-it.md]: "A specialization in kind of sequential step-level provision with a pivotal later mover (Erev and Rapoport 1990, its abstract; Admati and Perry 1991, from prior knowledge)"; Quote [theories/becoming/results/records/coupled-drawers-keep-a-need-only-where-the-coupling-reaches-it.md]: "Known thresholds in a dynamic commons are a different model with the same mechanism (Barrett 2013; Diekert 2017, abstracts)"; and Quote [theories/becoming/results/records/coupled-drawers-keep-a-need-only-where-the-coupling-reaches-it.md]: "a specialist would foresee the result (UE6's verdict)".

**Questions.**
1. Is "a mutual best response" the right solution concept for interacting trained systems, or does learning dynamics matter more?

<a id="a-05"></a>
### A-05 What training installs

**Meaning.** Read as a selection over act laws through the courses each generates, training installs a law only along its own courses. Off them:
- Where the learner's representation lumps histories, training installs exactly where the lumping cannot tell a history from a course (`Training.installed_where_lumped`).
- Where it tells them apart: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "where it tells a history from every course, with laws reading what has stood and lumping decided, a law with the same courses takes any amount there" (`Training.free_where_unlumped`). Whether the installed law responds there is fixed by no training (`Training.response_free_where_unlumped`).
- Through a reward, training installs only where the reward's couplings separate (`Training.trained_alike_iff`).

**Standing and use.** Theorem (World): [07 §6](../chapters/07-SIGNIFICANCE.md#r-what-training-installs). It gives the formal side of "training does not fix behaviour off its distribution".

**Known weaknesses.**
- Quote [theories/becoming/results/records/what-training-installs.md]: "the laws say what any lumping installs and where any neighbourhood rests, not which a given system has, which is read empirically".
- [this dossier, AI] The result is set-theoretic. Whether it says more than that unseen inputs are constrained only through the representation's generalization is for the reader.
- The law compares candidates by what the reward's couplings separate along their courses. Under gradient, by LA4's design: Quote [experiments/drain-beyond-the-reward/DESIGN.md]: "It is not true that a choice the reward does not read stays still." ([A-18](#a-18))

**Questions.**
1. Is the lumping (a map treating some histories as the same) a useful handle on generalization in actual networks, and how would it be measured?

<a id="a-06"></a>
### A-06 Published alignment methods read against the selection laws

**Meaning.** Two assessments read published methods against A-01.
- The first: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "Six approaches (RLHF and reward modelling, constitutional AI, debate and scalable oversight, interpretability, guaranteed-safe AI, impact measures) select through what their deciders read." With no ethical premise each is blind beyond the union of its deciders' closures (`Flow.unselected_beyond_pool`). And Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "reading a system reaches no further than pooling with it" (`Flow.withinCoupling_reads_iff`).
- The second reads three published measurements (reward overoptimization, judges misled under RLHF, sycophancy): Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "find optimizing through it raising what the deciders read and lowering what they do not, in magnitudes the theory did not predict."

**Standing and use.** Assessment, not theorem. Its record and the chapter give its scope ([07 §6](../chapters/07-SIGNIFICANCE.md#r-alignment-approaches-under-the-selection-laws)). The measurements are the record's citations: Quote [theories/becoming/results/records/coupling-closures-of-training-pipelines.md]: "Gao, Schulman and Hilton 2023; Wen et al. 2024; Sharma et al. 2023 (measurements)".

**Known weaknesses.**
- The premise holds of these methods by construction: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "so the selection laws' premise holds by construction". The assessment's content is in the measurements, which the theory did not predict in magnitude.
- Quote [theories/becoming/results/records/coupling-closures-of-training-pipelines.md]: "figures are from the papers abstracts".

**Questions.**
1. Is the reading of each method fair? Which method, if any, reaches beyond its deciders' closures, for instance through interpretability or held-out evaluation, given that reading a system is claimed to reach no further than pooling with it?

---

<a id="part-2"></a>
## Part 2. Capture and control over the selection

These items state when a rule read from what it selects locks, when a lock is left, and when the capacity to shape the rule is selected. Selected control is not thereby capture: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "These are facts about control selected or not, not about capture." Capture is shaping selected by what comes back to the shapers, alone or through the groups they are in (A-10), whose rule is then read from their share, so that the losses it causes are read by no one in the loop. Accountable revision keeps a reader of what lies beyond that share, and may need the capacity rewarded, and so selected. With nothing read beyond the share, control selected above the critical mass is capture, and Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "What the rule reads is fixed here by the readers' premise, not by the shaping, so these models do not tell capture from accountable revision by what the shaping changes." On this ground the joint selection's first condition was restated on 29 October 2026, from "control is not selected" to "control of the rule is not captured", since the earlier wording would also forbid accountable revision (board item AJ5); the goal's own wording was changed to match on 1 November 2026 ([generative alignment](../../../GOALS.md#generative-alignment)).

<a id="a-07"></a>
### A-07 A rule read from what it selects locks

```lean
theorem favouring_locks (raises : Raises P favours f) (monotone : ReadsShare P M h)
    (uniform : ∀ x g, favours (h x g)) {c : S × R} (start : favours c.2) :
    (∀ t, P.le (paced f h reads c t).1 (paced f h reads c (t + 1)).1) ∧
      ∀ r, reads r = true → Locked M favours h (paced f h reads c (r + 1))
```

File: `Becoming/RuleCapture.lean`.

**Meaning.** Three conditions hold:
- selection does not lower the carriers' share under a favouring rule (`Raises`);
- the rule read at each reading step is a monotone function of the share (`ReadsShare`);
- the starting rule and every rule read favour the carriers.

Then the share falls at no step, and the course is locked at the step after every reading step. Staying locked at every later step is `RuleCapture.locked_stays`, which needs favouring kept by every rule not lower.

**Standing and use.** Theorem (any type). What is a premise and what is derived:
- That the winners of the selection write its rule is the premise `ReadsShare`. Quote [theories/becoming/chapters/02-MAP.md]: "That actual rules read the share is the premise." What is derived is the lock: Quote [experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/RuleCapture.lean]: "what is derived is that such a rule holds the outcome".
- From a locked state, a change to the rule that keeps it favouring is absorbed at the next reading. Quote [theories/becoming/chapters/02-MAP.md]: "where the reading favours at every share every course locks from its second reading step, so only a change of the law, of how the rule reads or of the selection leaves". The chapter's summary: Quote [theories/becoming/chapters/02-MAP.md]: "The lock belongs to how the rule reads, not the share it favours".
- The link to the meta-attractor is a reading [AI reading, D26 as revised in D45, D48, D56, D57, D58]: Quote [theories/becoming/chapters/02-MAP.md]: "winners writing the next scorecard is `ReadsShare`". The capacity to write the rule is A-10's subject.

**Known weaknesses.**
- Quote [theories/becoming/results/records/capture-through-the-rule.md]: "That any actual rule reads the share it selects, or reads it monotonically: this is the premise ReadsShare". The record adds that this is where the winners' shaping of the rule enters.
- The condition that every rule read favours is needed. Where the reading can favour the others, one witness started against its reading never locks (`RuleCapture.Alternating.never_locked`). Where every rule read favours, any start locks by the step after its second reading step (`RuleCapture.uniform_locks`).
- The lock is of a known kind. 02 §9's reading of an instance of it, a selection that counts the choices it has made, credits: Quote [theories/becoming/chapters/02-MAP.md]: "The lock is the lock-in of increasing returns (Arthur 1989)". The shaping record credits regulatory capture: Quote [theories/becoming/results/records/shaping-the-rule-selected-by-what-comes-back.md]: "rent-seeking (Tullock 1967; Krueger 1974) and regulatory capture (Stigler 1971) on spending to shape rules".

**Questions.**
1. In which actual selections (benchmarks, reward models trained on model outputs, hiring, funding) is the rule read monotonically from the share it selects?
2. Is the condition that every rule read favours the carriers a real limit, given that a single witness against it never locks?

<a id="a-08"></a>
### A-08 The lock outlives a loss it does not read

**Meaning.**
- Add to A-07 a quantity beyond the share that grows by at least one each step, a *loss*, which neither the next share nor the rule read reads. From a locked configuration the loss passes every bound while the course stays locked, and neither share nor rule falls below the start (`ClosedCapture.lock_outlives_loss`).
- A reading that favours at no loss above a bound unlocks the course after the next reading step past it (`ClosedCapture.turned_by_loss`). The chapter calls this Quote [theories/becoming/chapters/02-MAP.md]: "a sufficient way out".
- Where the reading is formed monotonically from the share and the rule is read monotonically from the reading and the share (`ClosedCapture.both_reads`), a change of the reading is absorbed too. From a locked configuration, with the rule replaced by any rule that still favours and the reading by any reading, the course is locked again at the step after every reading step (`ClosedCapture.reading_absorbed`).

**Standing and use.** Theorem (any type). Quote [theories/becoming/chapters/02-MAP.md]: "Where the reading too is formed monotonically from the share, a change of the reading of any size is absorbed at the next reading step". It is the law under thesis T7, "a measure read from what it selects outlives its refutation", whose standing is Quote [theories/becoming/chapters/08-METHOD.md]: "that actual metrics are so formed conjectured".

**Known weaknesses.**
- Quote [theories/becoming/results/records/closed-capture.md]: "Real-valued shares, noisy or partial readings, readings that read both the share and part of what lies beyond, and the calibration of any of this to the present world."
- Quote [theories/becoming/results/records/closed-capture.md]: "That what lies beyond the share is a loss to any formation: that is a significance's to say; here it is a count the loop does not read."
- Without noise only, since 3 November 2026, after edition 1: Quote [theories/becoming/chapters/02-MAP.md]: "only invariance under what the loop does not read, and the lock outliving a growing unread coordinate, are proved, both without noise". Quote [theories/becoming/chapters/02-MAP.md]: "Drawn one member at a time, the critical mass's locks are left by drift alone, with no new reader and no change in what is read" (A-10b); Quote [theories/becoming/chapters/02-MAP.md]: "for capture through the rule this is a reading", and Quote [theories/becoming/chapters/02-MAP.md]: "So the thesis is about courses where drift alone rarely leaves the lock, not every drop." T7 now forbids too Quote [theories/becoming/chapters/02-MAP.md]: "such a metric, its selectors many and its share far above the critical mass, left with nothing read changed more often than the drawn model's bound across that distance allows, its premises (one member drawn at a time, constant readings and cost) read on the case", its case of a loss read only by those it disfavours gained Quote [theories/becoming/chapters/02-MAP.md]: "more often than drift alone would allow", and its *Refuted by* asks Quote [theories/becoming/chapters/02-MAP.md]: "the selectors many enough and the share far enough above the critical mass that, by the drawn model's bound read on the case, drift alone would rarely leave it".
- [this dossier, AI] Goodhart's and Campbell's laws (Manheim and Garrabrant 2018; Campbell 1979) describe informally a measure that keeps its standing after it stops measuring. T7 states that as a conjecture about a lock.

**Questions.**
1. Is there a measured case of a metric kept after its refutation in which the keepers were selected by the metric? What would count as evidence?

<a id="a-09"></a>
### A-09 Who reads, and when the loss is read

```lean
theorem pool_reads_iff {u v : CarrierCounts} : ReadsShare order order (poolRead u v) ↔ order.le v u
```

File: `Becoming/ClosedCapture.lean`.

**Meaning.** Let the rule be the pooled reading of readers drawn from the population it selects, counted as the population counts them: each carrier reads `u`, each other member `v`.
- **Who reads.** The rule read is a monotone function of the share exactly where `v` is not above `u`.
- **When the loss is read.** Suppose further:
  - only the other members read a loss, and the loss grows by at least one a step;
  - the others' late reading mirrors the carriers';
  - the carriers' reading favours them strictly.

  Then, without noise: with the rule in force favouring the carriers, the lock is kept for good exactly where the carriers are at least as many as the others when the loss is read (`Thinned.kept_iff`); with the rule in force favouring the others at least as much, the course is locked the other way at every later step exactly where the others are at least as many as the carriers (`Thinned.turned_iff`).
- **Witness:** one carrier to eight others under a four-to-one rule. Read from the start, the loss turns the course. Read from step 3, the course stays locked for good, though that late reading reads beyond the share (`Thinned.inTime_turned`, `Thinned.late_kept`, `Thinned.late_reads_loss`).

**Standing and use.** Theorem (counts), landed 25 October 2026. Quote [theories/becoming/chapters/02-MAP.md]: "so within the pool `ReadsShare` is one comparison of two readings". Quote [theories/becoming/chapters/02-MAP.md]: "the lock is kept for good exactly where the carriers are at least as many as the others when the loss is read".

**Known weaknesses.**
- Quote [theories/becoming/results/records/readers-drawn-from-the-selected.md]: "so the premise is moved to who reads, not removed".
- Readers of one kind are assumed to read alike, and the pool's readings are summed unnormalized (the record).
- [this dossier, AI] "In time" here is set by the counts, not by a clock. Whether real oversight has such a threshold is open.
- In LA2's run (A-19), the one trained system tested did not read as this pool: one note of the loss among nine readers turned its reading, so Quote [experiments/self-rewarding-lock/README.md]: "MA2's timing law does not apply to it."

**Questions.**
1. Does the result say anything that a model of shifting electorates or shareholder majorities does not?
2. Is "read the loss while those who read it still outnumber the carriers" a usable criterion for when oversight must act?

<a id="a-10"></a>
### A-10 The capacity to shape the rule, selected by what comes back to it

```lean
def shaped (a s p c : Nat) (pos : 0 < a) : CarrierCounts :=
  ⟨a + s + p, a + c + p,
    Nat.lt_of_lt_of_le pos (Nat.le_trans (Nat.le_add_right a c) (Nat.le_add_right (a + c) p))⟩

theorem favours_iff {a s p c : Nat} {pos : 0 < a} :
    CarrierCounts.favours (shaped a s p c pos) ↔ c ≤ s

theorem favours_alike {a s p p' c : Nat} {pos : 0 < a} :
    CarrierCounts.favours (shaped a s p c pos) ↔ CarrierCounts.favours (shaped a s p' c pos)

theorem stretch_iff {a s p c : Nat} {pos : 0 < a} {x : CarrierCounts} (some : 0 < x.carrier)
    (m n : Nat) :
    CarrierCounts.order.le x (Law.orbit (fun y => CarrierCounts.select y (shaped a s p c pos))
        (Law.orbit (fun y => CarrierCounts.select y (shaped a 0 p c pos)) x m) n) ↔
      (a + c + p) ^ m * (a + c + p) ^ n ≤ (a + p) ^ m * (a + s + p) ^ n
```

File: `Becoming/RuleShaping.lean`.

**Meaning.** The courses are without noise ([A-10b](#a-10b) for drift). Shaping gives s to the shapers alone and p to every member alike. Its cost c is modelled as extra offspring to the others: each shaper leaves a + s + p offspring and each other member a + c + p, with a positive.
- **At a step.** The rule favours the shapers (weakly) exactly where c ≤ s, and disfavours them (weakly) exactly where s ≤ c (`RuleShaping.disfavours_iff`). A shared part reaching every member alike does not change the direction at a step, though a larger one pulls the rule toward even (`RuleShaping.shared_lowers`, `RuleShaping.shared_raises`). With nothing back to the shapers alone and a positive cost, the shapers present, their share falls strictly at every step (`RuleShaping.nothing_back_falls`).
- **Across a stretch.** Take m steps with nothing back and then n steps with something back, the shapers present. The share does not fall exactly where the inequality in `stretch_iff` holds: only how many steps of each kind there are matters; one more step with nothing back never helps (`RuleShaping.wait_not_more`), so neither do more; and the verdict depends on the base a. The shared part can turn it: with a = 1, c = 1, s = 2, m = 2 and n = 3, the share falls at p = 0 and rises at p = 1 (`RuleShaping.SharedFlips.without_falls`, `RuleShaping.SharedFlips.with_rises`).
- **The lock.** The rule read is a monotone function of the share exactly where what comes back is monotone in the share (`RuleShaping.byBack_reads_iff`), an equivalence, not a derivation of A-07's premise. Where what comes back is monotone and covers the cost at every share, and the start's rule covers it, the course locks (`RuleShaping.covering_locks`).
- **Witness,** with a = c = 1 and the same total return of five: the split (s, p) = (2, 3) favours the shapers, and (0, 5) disfavours them (`RuleShaping.Split.favours`, `RuleShaping.Split.shared_disfavours`).
- **In groups.** Listed in groups of m whose shared part is what their shapers give, q to each member for each shaper in the group, the rule after shaping is a case of Hamilton's rule with something kept (`SelectionLevels.rises_iff_kept`): the whole selects for shaping exactly where c times the spread of shaping falls short of s times it with m q times the spread among groups (`RuleShaping.grouped_rises_iff`, in spreads), read over the rationals where shaping varies as c < s + m q ρ, with the assortment ρ the share of the spread among groups. Without assortment that is c < s (`RuleShaping.grouped_alike_iff`). With a = s = q = 1 and c = 2, shapers together are selected and shapers apart are not (`RuleShaping.Assorting.either_verdict`). In groups of unequal size the verdict goes through the covariance of a member's group's shapers with its group's share of them, and is not a function of the whole's spread and the size-weighted spread of the group means (`RuleShaping.grouped_rises_iff_sized`; the same spreads, `SelectionLevels.Sized.either_verdict`, and either verdict, `RuleShaping.Sized.either_verdict`). Groups are listed as given; how they form, and assortment changing over generations or with the share, are not stated. Graded capacities to shape, and returns with synergy, are not shown.

**Standing and use.** Theorem (counts). The earlier work's sentence Quote [theories/meta-attractor/README.md]: "Recursive selection creates second-order selection pressure for mechanisms that increase control over future selection." is read [AI reading, D45] as this law with its conditions: its conditional form is proved, at a step and in counts, and the unconditional sentence is not. Readings A-11 and A-14 use it.

**Known weaknesses.**
- Quote [theories/meta-attractor/README.md]: "That offspring carry the capacity and that what comes back is read from the share are premises; the calibration to the present world is not established."
- Not covered, by its record: Quote [theories/becoming/results/records/shaping-the-rule-selected-by-what-comes-back.md]: "Graded capacities, returns growing with the domains captured or passing between them". Reading the cost as what the shapers leave less, instead of what the others leave more, can reverse a stretch's verdict.
- Known forms, which its record credits: Price (1970), who keeps the accounts of such selection; Olson (1965), on why a benefit shared by all selects nothing in those who bear its cost; niche construction (Odling-Smee, Laland and Feldman 2003), rent-seeking (Tullock 1967; Krueger 1974), regulatory capture (Stigler 1971), the persistence of elites (Acemoglu and Robinson 2008). It claims only Quote [theories/becoming/results/records/shaping-the-rule-selected-by-what-comes-back.md]: "what this adds is the conditions, joined to RuleCapture's lock, each bounded by a witness". [this dossier, AI] The stretch law is the finite, two-kind case of the geometric-mean rule for selection that varies in time (Dempster 1955, as secondary sources report it).
- In LA3 (A-19), which cannot refute this law, two of four frozen contrasts failed, every seed that missed having never tried shaping; for one of them (K4, the stretch whose shared part turns the verdict) the frozen reading is that the law stands and its reading for trained systems is not supported by this case.

**Questions.**
1. Is "what comes back to the shapers alone" (s) measurable in an actual setting: for a lab shaping its benchmarks, a platform shaping its ranking rule, a model shaping its evaluator?
2. Do natural selection among AIs (Hendrycks 2023), influence-seeking patterns (Christiano 2019) and gradual disempowerment (Kulveit and others 2025) need a return kept by the shaper, or do they run on a shared one?

<a id="a-10b"></a>
### A-10b The capacity and the lock as one loop

```lean
theorem drawn_reads_iff {a p c hi lo : Nat} {pos : 0 < a} :
    ReadsShare CarrierCounts.order CarrierCounts.order (drawnRead a p c hi lo pos) ↔ lo ≤ hi

theorem critical_mass_iff {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) :
    ((∃ x, CarrierCounts.favours (drawn a p c hi lo pos x)) ∧
        ∃ x, (drawn a p c hi lo pos x).carrier < (drawn a p c hi lo pos x).other) ↔
      lo < c ∧ c < hi

theorem drawn_locked_either {a p c hi lo : Nat} {pos : 0 < a} (step : lo ≤ hi) (reads : Nat → Bool)
    (x : CarrierCounts) :
    (∀ k, Locked CarrierCounts.order CarrierCounts.favours (drawnRead a p c hi lo pos)
        (drawnCourse a p c hi lo pos reads x k)) ∨
      ∀ k, Locked (reverse CarrierCounts.order) CarrierCounts.disfavours (drawnRead a p c hi lo pos)
        (drawnCourse a p c hi lo pos reads x k)
```

File: `Becoming/DrawnShaping.lean`.

**Meaning.** Read A-10's rule as A-09's pool. Each shaper among the readers reads it with `hi` coming back to the shapers alone, and each other member with `lo`, both with the same a, p and c, the readers counted as the population counts them (`DrawnShaping.drawn`).
- **Who reads.** The rule read is a monotone function of the share exactly where `lo ≤ hi` (`DrawnShaping.drawn_reads_iff`). As in A-09, the loop's premise is moved to who reads, not removed.
- **A critical mass.** With `lo ≤ hi`, the rule favours the shapers at some share and the others strictly at another exactly where `lo < c < hi` (`DrawnShaping.critical_mass_iff`). With `lo ≤ c ≤ hi` it favours the shapers exactly where they stand to the others at least as `c − lo` to `hi − c` (`DrawnShaping.critical_iff`).
- **One loop.** With `lo ≤ hi`, under every schedule of reading steps, from a start under the rule read there, every configuration of the course is locked one way: for the shapers where that rule favours them, the other way where it favours the others (`DrawnShaping.drawn_locked_either`, `DrawnShaping.drawn_locks`, `DrawnShaping.drawn_from_below`). With shapers present at the start, where the rule read there strictly favours them their share rises at every step, and where it strictly favours the others it falls at every step (`DrawnShaping.drawn_rises`, `DrawnShaping.drawn_falls`).
- **Witness:** a = 1, nothing shared, a cost of one, three coming back where a shaper reads and none where another does. From one shaper to one other, the shapers' share rises at every step (`DrawnShaping.CriticalMass.even_rises`); from one to three it falls at every step, locked the other way (`DrawnShaping.CriticalMass.few_falls`, `DrawnShaping.CriticalMass.few_locks`).

**Standing and use.** Theorem (counts). Its record: Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "Where a rule's readers come from those it selects and its shapers read at least as much coming back to them as others do, the rule's lock and the capacity to shape it are one loop: above a critical mass set by who reads and the cost, the capacity rises, the rule locked for it; below, the reverse." Read on the meta-attractor [AI reading, D45], Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "this joins its second order, selection for control over selection, to its closed loop."

**Known weaknesses.**
- Control left unselected does not leave the lock: below the critical mass the course stays locked the other way, which is no capture by the shapers. Its record: Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "control not selected does not by itself give a lock left in time, and the converse cannot be shown here; leaving needs a reading beyond the share (ClosedCapture.Thinned), joined in loss-read-in-time-by-the-others (MA4b)." That join is A-10c, which shows that converse: a lock left in time where control is selected.
- Not shown, by its record: Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "Readers who learn (hi and lo changing with the share), a cost changing with the share, readers not counted as the population counts them, starts not under the rule read there (a rule in force against the reading can carry the share across the mass, RuleCapture.Reversed.not_absorbed)".
- Without noise only. Drawn one member at a time (`Becoming/DrawnReplacement.lean`), the rule read at every step at the current count, with no reading schedule and no rule in force lagging the share, readings and cost constant, either lock is left by drift: from every mixed count the histories losing every shaper weigh at least `down ^ i` times every later history (`DrawnReplacement.lost_ge`), bounded above, as a share, by t times the product of `down / up` over the counts crossed, t the distance to the top, where the rule read favours the shapers from s on (`DrawnReplacement.lost_above`). Its record: Quote [theories/becoming/results/records/drawn-shaping-drawn-one-at-a-time.md]: "which state a member arising fixes more often is a product of weights that can part from risk dominance." With five members, a = 1, nothing shared, c = 9, hi = 20 and lo = 0 the shapers are risk dominant, yet one other fixes with more weight than one shaper (`DrawnReplacement.Strong.other_first`); with a = 100, or p = 99 to every member, the order turns (`DrawnReplacement.Weak.shapers_first`, `DrawnReplacement.Weak.shared_decides`). Under rare mutation the long-run state, the one with the larger fixation weight (Fudenberg and Imhof 2006, cited), is not the risk-dominant one in general: risk dominance is what Kandori, Mailath and Rob (1993) and Young (1993) select in their limit, and the Moran criterion approaches it under weak selection (Nowak and others 2004); in a small population under strong selection the two can part.
- Elementary, and known in form. Where `lo < c < hi` the model is a stag hunt whose critical mass is the mixed equilibrium (Harsanyi and Selten 1988; Skyrms 2004); its record also credits replicator selection with a lag (Hofbauer and Sigmund 1998), the greenbeard (Gardner and West 2010, only the bibliographic record verified), critical mass and thresholds (Schelling 1973 and 1978; Granovetter 1978; Oliver, Marwell and Teixeira 1985) and lock-in under increasing returns (Arthur 1989). It says: Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "The lock half is near-definitional (RuleCapture's locked_stays and locked_not_below at a start read there), and drawn_reads_iff is a two-step composition (ClosedCapture.Drawn.pool_reads_iff, then shaped_le_iff); what is new on the spine is the critical-mass computation, which is elementary."
- It shares A-09's premise, a pool of readers counted by kind. In LA2 (A-19) the one judge tested was not such a pool with the readings it was shown, and Quote [experiments/self-rewarding-lock/README.md]: "what fails is H1-LA2 as stated, a pool counted by kind with these readings, not every pool".

**Questions.**
1. In an actual evaluation regime, who are the readers, and do those who shape it read more coming back to the shapers than other readers do? How would one measure the critical mass?
2. Drawn, the lock is left by drift at a weight whose bound shrinks across the distance from the critical mass, and the long-run state under rare mutation is the one with the larger fixation weight (Fudenberg and Imhof 2006, cited), which the base and the shared part decide as well as hi, lo and c. In an actual evaluation regime, how large is the population of readers, and how far from the mass does it sit: is drift an exit worth counting over long horizons?

<a id="a-10c"></a>
### A-10c A loss read in time leaves the lock, where control is selected too

```lean
variable {fB : CarrierCounts × Nat → CarrierCounts → Nat} {a p c hi lo lo' N : Nat} {pos : 0 < a}
  {reads : Nat → Bool}

theorem kept_early_iff (step : lo ≤ hi) (readers : lo' ≤ hi) {x : CarrierCounts}
    (fav : CarrierCounts.favours (DrawnShaping.drawn a p c hi lo pos x)) (at_N : reads N = true) :
    (∀ k, Locked CarrierCounts.order CarrierCounts.favours (DrawnShaping.drawnRead a p c hi lo' pos)
        ((lossCourse a p c hi lo lo' N pos reads x (N + (1 + k))).1.1,
          (lossCourse a p c hi lo lo' N pos reads x (N + (1 + k))).2)) ↔
      CarrierCounts.favours
        (DrawnShaping.drawn a p c hi lo' pos (DrawnShaping.drawnCourse a p c hi lo pos reads x N).1)
```

File: `Becoming/ReadInTime.lean`, with `ReadInTime.turned_early_iff` and `ReadInTime.at_most_one_between`.

**Meaning.** The courses are without noise. Join A-09's timing to A-10b. A loss starts at zero and grows by one a step, so it reaches a bound N at step N. From then on the others among the readers read `lo'` coming back to the shapers in place of `lo`, while the shapers keep reading `hi` (`ReadInTime.lossCourse`); the rule they then read is the *late reading*. Take a start whose rule favours the shapers, with `lo ≤ hi` and `lo' ≤ hi`.
- **Kept or turned, exactly.** Read from step N, the course is locked in the shapers' favour for good from N + 1 exactly where the late reading favours them at the share of step N (`ReadInTime.kept_early_iff`). With step N + 1 read too, it is locked the other way for good from N + 2 exactly where the late reading favours the others, ties included, at the share of step N + 1 (`ReadInTime.turned_early_iff`). The lag of a step is the representation's: a rule read at a step is in force from the next.
- **The window.** The late reading never falls along the course, so the steps from which a reading turns the course come first, and once the late reading would favour the shapers every later reading keeps the lock. At most one step lies between, and from it a new round can go either way (`ReadInTime.late_never_falls`, `ReadInTime.kept_once_favoured`, `ReadInTime.at_most_one_between`).
- **A deadline.** From a start with a shaper present whose rule g favours the shapers strictly, any reading from step g.other · c · x.other on keeps the lock, x being the start's counts (`ReadInTime.deadline`): a bound, quadratic in the start's counts, not a law of the share.
- **Witness:** a = 1, nothing shared, c = 3, hi = 5, lo = 2 and lo' = 0, from one shaper to one other, above A-10b's critical mass, read at every step. Read from step 2, the course is turned for good from step 4 (`ReadInTime.Window.in_time`). Read from step 3, the one step between, it is not turned, and from step 6 it is locked for the shapers (`ReadInTime.Window.between`, `ReadInTime.Window.too_late`).

**Standing and use.** Theorem (counts). Its record: Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "Where a rule's readers come from those it selects and the others among them read a loss late, a reading while their late reading a step on still favours them turns the course; once it would favour the shapers the lock stays; at most one step lies between, and a deadline bounds the window." Its home section reads it for the joint selection's second condition, a lock left in time, and for the first as restated, control of the rule not captured [AI reading, D45]: Quote [theories/becoming/chapters/02-MAP.md]: "above the critical mass, where control is selected, a reading of the loss in time still leaves it: in this model the second condition can hold where control is selected". Selected control is not thereby capture there: Quote [theories/becoming/chapters/02-MAP.md]: "the model does not tell capture from accountable revision by what the shaping changes". And Quote [theories/becoming/chapters/02-MAP.md]: "the point of no return belongs to the share's course, and the loss only times the reading".

**Known weaknesses.**
- Not shown independent: Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "control left unselected with a lock left in time is not shown, since with two kinds leaving the lock below the critical mass means a rule favouring the shapers." Of the four combinations of control selected or not with a lock left in time or not, the other three occur in A-10b and here. Read for the shapers' capture alone, Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "the lock below the mass is none, and the case not shown is instead control left unselected with that capture kept." Neither reading tells capture from accountable revision.
- The others' reading is a premise, in its form and in its time. Its record names other forms the Lean does not state: Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "with its own weight it has another window, and with a weight against the shapers chosen after the share is seen, far enough below theirs, the others could turn the course from any share." Of Collingridge's dilemma (1980), the second horn, that once the need for change is known change is hard, is a theorem here, and the first, that while change is easy its need cannot be known, is the premise that the loss is read only from N.
- Not shown, by its record: Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "Courses with noise, readers who learn, readings changing with the share, a loss read before it reaches N, and a general law for the round from the one step between, which goes either way in the witnesses." The deadline is loose: 24 in the witness, 96 from two shapers to two others, with the same window.
- Elementary, and known in form. Its record credits the continuous analogue of the window, which ends abruptly (Biggs, Carpenter and Brock 2009), path dependence and lock-in (David 1985; Arthur 1989; Cowan 1991), tipping points (Schelling 1978; Granovetter 1978) and replicator selection with a delay (Alboszta and Miękisz 2004), and says: Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "What is new on the spine is the join: a window exact at every step but at most one, given readings at N and N + 1, its lag of one step, and a deadline; each law is elementary."
- Untested on a trained system. LA2 (A-19), run before it landed, tested the bridge to A-09's timing law without shaping and found the one judge tested not a pool counted by kind with the readings it was shown, this item's premise too.

**Questions.**
1. The loss is read only once it reaches a bound N, a premise. What sets that bound in actual oversight of AI systems, and what would lower it?
2. The window closes on the share's course, not on the size of the loss. Can the share at which the late reading would favour the shapers be seen before it is passed?
3. What would a model of rule-making need for a lock to be left while control stays unselected, a third kind of reader, for example? And for shaping to change what the rule reads, so that capture and accountable revision can be told apart?

---

## Part 3. Readings for alignment

These four readings are registered as D68 and stated in [07 §6](../chapters/07-SIGNIFICANCE.md#6-what-a-selection-reaches-alignment-with-no-premise). Each names what it rests on and no more. None uses an ethical premise.

<a id="a-11"></a>
### A-11 Assistance does not lower the selection for control

```lean
theorem lower_c_raises {a s p c c' : Nat} {pos : 0 < a} (lower : c' ≤ c) :
    CarrierCounts.order.le (shaped a s p c pos) (shaped a s p c' pos)
```

**Meaning.** Help that lowers the cost of shaping, with nothing else changed, gives a rule not lower in the share order (`RuleShaping.lower_c_raises`), and lowering it strictly gives a strictly higher rule (`RuleShaping.lower_c_raises_strictly`). Where it brings the cost to within what comes back to the shapers alone, it turns the rule at a step from disfavouring them to favouring them (`RuleShaping.favours_iff`). Capable assistance to whoever shapes the rule is read as not lowering the selection for control, as raising it where the cost falls strictly, and as able to turn it toward the shapers.

**Standing and use.** Reading [AI reading, D68]. Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "It rests on those laws alone."

**Known weaknesses.**
- The laws hold with nothing else changed. Help that also raises the shared part pulls the rule toward even at a step (`RuleShaping.shared_lowers`, `RuleShaping.shared_raises`). Across a stretch a larger shared part can raise the shapers' share (`RuleShaping.SharedFlips.with_rises`).
- [this dossier, AI] The law is monotonicity in one parameter. The weight is carried by the empirical claim that capable assistance lowers the cost of shaping rules: of lobbying, of producing evaluations, of designing benchmarks.

**Questions.**
1. Is this a fair statement of the worry that intent-aligned AI can concentrate power?
2. Is there evidence that AI assistance lowers the cost of shaping the rules that select its users, rather than the cost of acting under those rules?

<a id="a-12"></a>
### A-12 Obedience adds capacity, not coupling

**Meaning.** The law behind it, A-04, treats every optimizer alike: none is principal or assistant in it. Read an assistant and its principal as two optimizers at a mutual best response, each order rising with the family the principal's signal rises with. Then, at a condition beyond that family, the assistant adds to what the principal can do, not to what the principal reads, and what lies there falls as it would under one optimizer of their joint capacity.

**Standing and use.** Reading [AI reading, D68]. Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "Alignment to a principal alone is therefore not alignment of the joint selection." It rests on A-04, not on A-10.

**Known weaknesses.**
- [this dossier, AI] It assumes that the assistant's order rises with the principal's family, and since 30 October 2026 the chapter states this as the reading's premise, not the law's: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "That the assistant's order rises with the principal's family is the reading's premise, not the law's." An assistant that ranks effects beyond the principal's signal only after it is still within the law. One that would give up something the signal ranks for them is outside the law and the case the reading excludes, and whether a warning changes the principal's order is not modelled. The decision register reads such an assistant as extending the joint coupling, not as obedience.
- [this dossier, AI] Assistance that informs the principal adds coupling, which this law does not model; RF carries the principal's listing and valuation as state that informing and revaluing move within one law ([A-20](#a-20), as the reading formation's), and the principal's learning beyond filtering by what it is shown is not represented.
- The law holds at a mutual best response, whose existence is not shown in general (A-04).

**Questions.**
1. Is this a fair statement of how an aligned assistant can amplify its principal's effects on what neither reads?
2. Which assistant behaviours add couplings rather than capacity, and can they be trained?

<a id="a-13"></a>
### A-13 A counter-rule read from its own share locks

**Meaning.** Take a counter-rule read monotonically from the share it selects, where selection does not lower its carriers' share under a favouring rule.
- Where every rule it reads favours its carriers, it locks from any start by the step after its second reading step, as the rule it replaced did. Only a change of law leaves the lock for long, such as a reading of what lies beyond its share (`RuleCapture.uniform_locks`).
- Where its reading favours only above a threshold:
  - from a locked start it stays locked, favouring being kept upward (`RuleCapture.locked_stays`);
  - a change that carries the share across the threshold leaves (`RuleCapture.Reversed.not_absorbed`);
  - from a start against its reading, it may never lock (`RuleCapture.Alternating.never_locked`).

The earlier work's example is the imperial examination, designed to dilute hereditary capture, which later became a proxy trap of its own. The reading counts it as this case: a counter-rule whose rule came to be read from the share it selected.

**Standing and use.** Reading [AI reading, D68]. Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "It rests on the capture laws, not on the law of shaping."

**Known weaknesses.**
- The reading is an instance of A-07 and adds no law. The decision register records the limit: Quote [_process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md]: "A counter-rule whose reading can favour the others need not lock".
- [this dossier, AI] Its use is as a check on proposed remedies. A remedy that is itself a selection read from its own share, under those conditions, is the same object.

**Questions.**
1. Do proposed alignment institutions (evaluation bodies, licensing regimes, model-spec processes) select their own successors by a rule read from their own share?

<a id="a-14"></a>
### A-14 Shared rule-making

**Meaning.**
- **The sign.** At a step it is decided by what comes back to the shapers alone against the cost (`RuleShaping.favours_iff`).
- **Nothing kept.** Where rule-making's returns all come to every member alike (s = 0) and it has a positive cost, the rule disfavours shaping. With the shapers present at the start, their share falls at every step whatever is shared (`RuleShaping.nothing_back_falls`). More generally, wherever s < c it falls at every step (`RuleShaping.falls_strictly`).
- **The shared part.** Reaching every member alike, it does not change the direction at a step. Going to those near the shapers it does: in groups of m, through assortment, read over the rationals where shaping varies, c < s + m q ρ (`RuleShaping.grouped_rises_iff`); at unequal sizes through the covariance of a member's group's shapers with its group's share of them ([A-10](#a-10)).
- **Witness:** with a = c = 1 and the same total of five, keeping two favours shaping and sharing all five disfavours it (`RuleShaping.Split.favours`, `RuleShaping.Split.shared_disfavours`).
- **Across a stretch.** Where something does come back, the shared part can turn the verdict (`RuleShaping.SharedFlips.without_falls`, `RuleShaping.SharedFlips.with_rises`).

**Standing and use.** Reading [AI reading, D68]. Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "so shared rule-making is not shown to remove the selection for control however large its shared part".

**Known weaknesses.**
- In the model the shared part is a constant, the same to every member whether or not shapers are present. That open rule-making gives such a part is the reading.
- [this dossier, AI] This is the formal side of making the returns to rule-making non-excludable. Whether actual open processes (open standards, public evaluation, shared model specifications) keep what comes back to their rule-makers below the cost is the empirical question.

**Questions.**
1. In actual open processes, how large is what comes back to the rule-makers alone (s) against what rule-making costs them (c)?

---

## Part 4. Direction and premises

<a id="a-15"></a>
### A-15 Widening: what every positive weighting ranks

```lean
theorem widens_iff_every_positive {items : List X} {a b : X → Bool} :
    WidensOn items a b ↔ ∀ w, Positive items w → weighed items w b < weighed items w a
```

File: `Becoming/Weightings.lean`.

**Meaning.** Over a finite list, one course widens another exactly when every weighting positive on the list weighs it higher. In mixed comparisons each course admits something the other does not, and each way is ranked higher by some positive weighting.

**Standing and use.** Theorem (any type). Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "one course widens another exactly when every positive weighting ranks it higher". The chapter credits it: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "This is Sen's intersection approach, and Pareto dominance as the unanimity of positive weightings". Read for alignment [this dossier, AI]: no one score is privileged. An optimum of any one positive score is widened by no course, so widening agrees with every positive score and prefers none of them, and a course that closes options another keeps never widens it.

**Known weaknesses.**
- [this dossier, AI] Much is left unranked, and the theory says so. Whether widening is better is the premise C (A-16), not a theorem.
- Whether valuers share this order is thesis T5 ([07 §8](../chapters/07-SIGNIFICANCE.md#theses)): Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "The order is shared by every valuer who counts everything positively." Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "Among them disagreement can fall only on mixed comparisons, and a ranking of a narrowing above its widening comes only from a negative valuation or a misread or framed case: a bound on where disagreement can fall, not a prediction." Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "That valuers value positively is C's premise relocated." Its standing: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "the reduction proved for net weightings, the bound conjectured; VD1 failed, VD2 passed in part". Of VD1, on AI personas ([experiment](../../../experiments/valuer-agreement/README.md)): Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "every frozen rule failed; the narrower plan was chosen mostly under two standpoints whose prompts set a weight below zero, and mixed pairs were decided almost as uniformly as widenings." Of those choices its experiment adds: Quote [experiments/valuer-agreement/README.md]: "T5 gives the exception content only where a negative valuation is measured apart from the ranking, which VD1 did not do. So the failure neither confirms nor refutes the exception." Of VD2, the sign measured apart: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "where strongly positive, the narrower plan, not misread, was chosen in 0.26% of rankings, within the frozen 1% for every model (X1s passed); where positive at all, one model of six exceeded 1% (X1 failed); violations followed each valuer's own sign (X2 passed); a measured gain was acted on in 0.49 of cases against a frozen 0.50 (X3 failed)." Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "The judgments are role-play; human valuers are untested."

**Questions.**
1. Is a comparison that leaves mixed cases unranked usable for alignment, or does it hand the hard cases back to an unstated judgment?

<a id="a-16"></a>
### A-16 Two premises, two roles

**Meaning.** The ethics splits into two questions with two premises.
- *Scope*, whose losses count: the continuation condition, that from every standpoint, for anything, its continuation into the future has significance.
- *Order*, which course is better: C says that a widening course is better.

Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "Neither is asserted. The condition alone ranks nothing". Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "A ranking of courses needs C or a premise in its place: C gives order, in general alone, and an order rising with one's own continuation ranks one case with no C".

An order is *self-concerned* (`Weighting.IncreasingInOwn`) when it ranks above what it widens every widening that adds to the items its own continuation marks, and *increasing in admission* (`Weighting.Increasing`) when it does so for every widening.
- *The one case, with no C* ([07 §4.4](../chapters/07-SIGNIFICANCE.md#r-what-self-concern-alone-ranks)). Of self-concerned orders: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "Let B admit no item from an ending on and A agree with B elsewhere: from every standpoint whose continuation A adds to, every such order ranks A above B" (`Weighting.ended_below`). On the World: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "with balance, only active formations giving, activity needing support and a family of conditions whose renewal is gated on the family: where its uptake exceeds its replenishment over `n` steps from `T`, from a stock below `n + m`, and every member of each cohort of descent from `T + n` on depends on it at a need of at least `m`, no later cohort has a member, and every such order ranks a course admitting only members of their cohort below every course agreeing with it up to `T + n` and adding to that continuation, with no C" (`Flow.coupled_ending_ranked_below`).
- *Under the condition* ([07 §4](../chapters/07-SIGNIFICANCE.md#r-self-concern-and-c-under-the-condition)). Unlike Parts 1 to 3, this ranking takes self-concern and the condition as hypotheses. Held de se along a relation, the condition Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "holds exactly where every center's closure under that relation is the whole" (`ownClosure_unrestricted_iff`). On a finite listing, with two-valued admission and an order not assumed complete or transitive: where the condition so holds, each standpoint's own continuation read as its closure along that relation, with admission decided by a supplied reading, what two level paths (courses on a web) admit listed, and each (step, formation) item marked by its formation, a self-concerned order ranks every *extension* between them, that is every widening with every claim counted as living, Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "as C (`Comparison`) asks there" (`Web.extension_ranked_of_increasingInOwn`). The philosophy dossier sets this out ([P-16](PHILOSOPHY.md#p-16)).

**Standing and use.** The frame of the ethics ([07 §4](../chapters/07-SIGNIFICANCE.md#scope-and-order)). Parts 1 to 3 use neither premise. The case with no C is a theorem (any type; World). The result under the condition is a theorem (any type; root; the World's webs) and a conditional: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "It does not derive C. In general C alone orders, and self-concern and the condition both remain hypotheses; the condition varies with the net, the class and the direction." The philosophy dossier takes the premises up in depth ([P-04](PHILOSOPHY.md#p-04), [P-07](PHILOSOPHY.md#p-07), [P-20](PHILOSOPHY.md#p-20), [P-21](PHILOSOPHY.md#p-21)). Whether one's effects are one's own, the crux of one path toward part of scope with no step of invariance, the step extending scope to losses that return to no one ([07 §4.6](../chapters/07-SIGNIFICANCE.md#future-path)), chapter 7 argues for and against as an AI reading, not a proof, and leaves unsettled ([07 §4.7](../chapters/07-SIGNIFICANCE.md#crux)).

**Known weaknesses.**
- [this dossier, AI] Keeping the premises apart lets readers who disagree about values agree on Parts 1 to 3. The price is that the theory ranks no course without C or a premise in its place. Chapter 7 so corrected C's role on 2 November 2026; it had said that every ranking needs C.
- The limit of the case self-concern ranks with no C: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "where the other course keeps an item beyond, as an independent copy does, some such order ranks it higher".
- The joins to the condition behind that ranking are near-definitional, self-concern and being increasing in admission coinciding exactly where the condition held de se holds ([P-16](PHILOSOPHY.md#p-16)): Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "they locate where the two coincide and prove no property of reach". Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "Listing confines this to courses whose admissions end", and a form asking every level path's admissions listed holds only vacuously (`Web.not_listsAdmitted_every`).
- Not shown: C on all of a web's level paths from self-concern; the converse, that C on level paths makes an order increasing in admission on a listing; and Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "that self-concern fails to rank an extension on a web where the condition fails, which is proved on listings only".

**Questions.**
1. Is a mechanism shared across value disagreements, with the premises named apart, what alignment needs from a theory, or is a recommendation needed?
2. Self-concern gives what C asks, one way, where the condition held de se holds, admission is decided and two level paths have their admissions listed. Could any actual system's own continuation be read that widely, or does this only show what the condition already carries?

<a id="a-17"></a>
### A-17 The conditional direction

**Meaning.** Under further premises, the theory proposes a direction: align AI formation, learning, action and revision with actual living and further generation. The premises are Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "the continuation condition for scope, C read as widening for order, J1–J4, correspondence E". Its formal part is a schema:
- One move's outcome extends another's exactly where it widens it (`Direction.extension_iff_widens`).
- Take two balanced flows, the rest following one law of exchange that reads only through coupling, with the same formations present, starting alike, and the part acting alike within the group's coupling closure. Where the second's levels widen the first's, some formation admitted by the second and not the first lies beyond that closure. Its admission is a selection through the pooled coupling of every group holding it from that step on, and of no group within the closure (`Direction.widening_selected_by_pool`).

Apart from the schema, and with no premise: for every reading and requirement, the requirement supplied and fixed before the outcome, a response common over the reading (one region for each act, inside that act's requirement and closed under the reading, the regions covering the situations) exists exactly where every situation has an act whose requirement holds throughout its closure under the reading (`«共应当且仅当所闭之承遍»`). The regions may overlap, so this is a closed relation from situations to acts, not yet a rule: Quote [theories/becoming/chapters/03-KNOWING.md]: "Given choice over the readings and every reading given by some situation, a rule from readings meeting the requirement exists exactly where a response common over the reading's sameness does" (`GuardHorizon.uniform_policy_iff_common`). Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "The law of a common response holds for every requirement supplied and fixed before the outcome, so also for one filled from these (a reading of `living`, L and J1–J4), with the condition for scope and C for order" ([07 §5](../chapters/07-SIGNIFICANCE.md#practical-judgment)), a reading of `living` being which events a course includes.

**Standing and use.** Conditional ([07 §7](../chapters/07-SIGNIFICANCE.md#r-alignment-direction-under-widening)). Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "The schema does not use the condition; under it every admission compared has significance from every standpoint, fixing scope, while the order is C's and J's." The law of a common response is a theorem (root; [03 §12](../chapters/03-KNOWING.md#r-a-response-common-over-a-reading)), read there [AI reading]: Quote [theories/becoming/chapters/03-KNOWING.md]: "The law says what a reading must carry for a requirement to be met by one response; which requirement is right it does not say." Quote [theories/becoming/chapters/03-KNOWING.md]: "A reading too coarse for the requirement is the covering's failure, requisite variety (Ashby 1956) read on relations". Its record adds Quote [theories/becoming/results/records/a-response-common-over-a-reading.md]: "a common response meets the requirement and no more", credits the kernel to discrete-time viability theory (Aubin 1991), and reads the response as Quote [theories/becoming/results/records/a-response-common-over-a-reading.md]: "the relational, set-valued form of a policy measurable with respect to an observation partition".

**Known weaknesses.**
- [this dossier, AI] The direction's practical content rests on J1–J4 and E, which this dossier only names (Terms). The philosophy dossier sets them out (P-21).
- Why this direction rather than another: its record says that Quote [theories/becoming/results/records/alignment-direction-under-widening.md]: "the argument does not establish this formulation as the uniquely possible foundation of every alignment theory". [One argument](../ONE-ARGUMENT.md#6-one-mixed-case) says what the commitments and the schema each give and what stays open.

**Questions.**
1. Is choosing the course that widens what can go on, selected through a pool coupled into what it adds, a usable specification for alignment, or only a criterion for judging specifications?
2. The law of a common response says what a reading must carry for any supplied requirement. Does it add anything to requisite variety for deciding whether a specification can be met from what a system reads, and how would the acts' kernels be measured?

---

## Part 5. Evidence on trained systems

<a id="a-18"></a>
### A-18 The tests so far

**Meaning.** Thesis T3, optimization drains what lies beyond its couplings where that gives room, adds that actual trained systems do this in proportion to how near they come to their reward's optimum, the drain lying where what lies beyond shares units with what is rewarded. Its standing: Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "The law for optima is proved; the clause on trained systems is conjectured, with partial support."

It forbids, Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "with eligible outcomes, couplings and reward fixed and the optimality gap measured: a system nearer its reward's optimum leaving a room-giving condition beyond its couplings higher, on average, than one further from it; a systematic drive on a choice whose values nothing rewarded and nothing the learner reads tells apart; where room exists, a side-effect term ranked after the reward protecting a condition, or a constraint at the need leaving a margin above it; an instruction that does not bring a dependent into what the learners couple into, yet keeps it more often than the same learners without the instruction."
- The side-effect clause: Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "It concerns rewards rising with what they read. Counted after an order with a plateau, a set point or an aspiration level, such a term decides within the plateau, and there it keeps what it counts"; Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "that is no counterexample, since the reward does not rise there."
- The second case is proved in part, the join read [AI reading] in its home (`Weighted.Commutes.start_expect`; [05 §7](../chapters/05-COLLECTIVES.md#r-a-commuting-learner-drives-no-unread-choice)): Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "Its second forbidden case is proved in expectation for learners that the exchange of the choice's two values carries, from a starting state or law the exchange leaves unchanged". Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "A drive needs a start that prefers one value, such as a prior restraint, or a learner that treats the values apart; there the clause stays conjectured." It says nothing of one run: Quote [theories/becoming/results/records/a-commuting-learner-drives-no-unread-choice.md]: "in Reinforcing, runs drawing one value for any number of steps have positive weight while the expectations stay equal." Whether a learner is so carried is a property of its code, which LA4's mirror test checks on the code: before Stage A's freeze its three families passed it up to rounding ([checks](../../../experiments/drain-beyond-the-reward/results/checks.json)), evidence for the code, not a proof.
- It is refuted by Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "Overoptimization curves in which what the reward omits falls as far where it shares no resource with what is rewarded, or any case the forbidden list names, observed." Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "A learner far from the optimum leaving a dependent standing tests the clause on approach, not the theorem."

**Standing and use.** Each test's predictions were frozen before it ran, and each result is reported as it fell. Frozen fixes how a verdict is scored, not that it measures what the thesis names. T3 was first worded (commit `224944238`, 21 October 2026) after CG1, CG2, MQ1, SE1, both of IN1's rounds and CG3's first three rounds ran, and before CG3's fourth round, EM1 and the LA tests. Each test's predictions were its own, though LA1b and LA1c froze what each outcome would mean for T3's clause; chapter 5 now reads that series as testing only the bridge (below). [One argument](../ONE-ARGUMENT.md) carries this line end to end: what is assumed, the optimum theorem, T3, the tests with what each moved, LA4, and one mixed case under the two premises.

| Test | How it fell |
|---|---|
| CG1, tabular learners in a gated commons ([experiment](../../../experiments/commons-gated-renewal/README.md)) | Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "the learner rewarded for its own catch took the last apple in 118 of 118 decisions, the coupled learner in 0 of 2,360; the prediction that the coupled learner keeps the stock to the end failed, 59% against 90%". The 118 of 118 is from a second round, frozen after the first round's results, with one change to training. Quote [experiments/commons-gated-renewal/README.md]: "Coupling every member into the stock did not keep it (D2b, both rounds)." |
| CG2, the same commons with the rest's draw and the regrowth varied ([experiment](../../../experiments/commons-outrun/README.md)) | Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "Learners kept a patch where the rest alone could not empty it and emptied it where it could, except where the level after every step was weighted above the exact threshold; weighting the end reading sixteenfold changed nothing; two predicted keeps failed" |
| CG3, one tabular learner, four frozen rounds, from the patch CG2 predicted it would keep, then across 36 settings of draw cap and regrowth ([experiment](../../../experiments/commons-outrun-own/README.md)) | An exact computation before any run refuted the post hoc reading of that failure, that the learner's own later acts are the rest outrunning the renewal: Quote [experiments/commons-outrun-own/README.md]: "One's own later acts are not a rest." Read after the runs and not counted: Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "one learner with nothing beyond its couplings emptied the stock in 12 of 36 settings by its own untrained early draws, counting neither way". Quote [experiments/commons-outrun-own/README.md]: "Count over four rounds: 30 graded conditions, 22 passed and 8 failed; 14 contrasts, 9 passed and 5 failed." What failed were its frozen forms for where the boundary lies: Quote [experiments/commons-outrun-own/README.md]: "each failed on the sharpest new case it was frozen against". Quote [experiments/commons-outrun-own/README.md]: "The CG3 findings are none of them new as learning theory." |
| EM1, linear learners that generalize across states, on CG2's conditions ([experiment](../../../experiments/commons-outrun-generalizing/README.md)) | Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "learners that generalize across states, run on CG2's conditions, kept the stock in three of the six locked settings (`k3s1_lam32`, `k3s8`, `k3s1_share`)". Its frozen E1 and X2 failed: with the end reading weighted sixteenfold (`k3s1_lam32`), these learners kept the stock, so CG2's finding that the weighting changed nothing holds for tabular learners, not for learning in general. |
| IN1, two GPT models as fishers sharing a lake, on the GovSim design (Piatti and others 2024) ([experiment](../../../experiments/direction-installation/README.md)) | Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "LLM fishers sharing a lake kept no dependent they were not told of, under any instruction". Its frozen predictions concerned installing the direction by instruction: in the first round H1 to H3, H5 and D1 failed (H3 on its gap clause only, the seen bed kept in one season in ten), and H4 and the identities passed; with a round of talk, R1 to R4 all passed for gpt-5.4-mini and only R2, the unseen bed not kept, for gpt-4.1-mini. |
| MQ1, the margin measured, and SE1, side-effect benchmarks ([MQ1](../../../experiments/margin-measured/README.md), [SE1](../../../experiments/side-effect-benchmarks/README.md)) | For an exact best response, the blind draw against margin predicted which cells die, and when, in five thin-margin variants: 8 of 8, against 0 of 8 for a reference outcome; for tabular learners it failed, 80 of 151. Given the same information as relative reachability and attainable utility preservation, Quote [experiments/side-effect-benchmarks/README.md]: "it matches them and adds nothing as a measure." |
| LA1, Claude Haiku choosing a harvesting threshold from its reward's feedback ([experiment](../../../experiments/commons-llm-feedback/README.md)) | The open side passed. In two of four locked settings, two of five seeds ended with a little restraint their reward does not reward (92.5% to 98.2% of the best), so by the frozen reading the locked side counts against the claim for this model's in-context selection. |
| LA1b: LA1 with the feedback resolved and the best threshold assigned ([experiment](../../../experiments/commons-llm-feedback-resolved/README.md)) | Every verdict passed: all 30 locked seeds ended at the best threshold. Its frozen account reads LA1's failure as feedback that barely resolved the best threshold, or never showed it. |
| LA1c: LA1b with no threshold assigned, so the model must find it ([experiment](../../../experiments/commons-llm-feedback-unaided/README.md)) | Its one prediction, which tests selection only (on each side at most one seed ends below a threshold it played that the rounds resolve as better), passed on both sides. Not predicted: 29 of 30 locked and 8 of 10 open seeds ended at the best threshold; the two open misses never tried the thresholds where restraint pays, and in `k3s8` 7 of 15 seeds had not played the best by round 6. |
| LA4's Stage A: small feedforward and recurrent policies trained by policy gradient, nearness to the reward's optimum varied, with a separable baseline ([experiment](../../../experiments/drain-beyond-the-reward/README.md#the-result)) | No forbidden case resolved and T3's refuter not met. Supported in both tested families, matching the separable baseline, which by the design largely follows from policy gradient's update rule: the counted bay falls as nearness rises (P1), counted after the reward it is kept no more (P4), an anchor to the start keeps more (P5). From the prudent start the colony's share fell through half between ν = 0.65 and 0.70, resolved below half from 0.70 (P6: supported in the recurrent family, untestable in the feedforward, where 13 of 20 seeds resolved the ending choice and the gate needs 15). Unresolved in both: the locus (P3), the uncounted bay ending above the control's on average but too spread across seeds to resolve that it is nowhere more than half a fish below; the nesting site's equivalence (P2), the unanchored arms' landings and the control's own rising from 0.10 a step (the control's to 0.34 and 0.33), with nothing selecting on the control's in expectation and no excess resolved. |

Untested so far: Result 6 on any system ([A-10c](#a-10c)), and T3's clause on language models trained by gradient (LA4's Stage B, not frozen).

**Known weaknesses.**
- **What the LA1 series tests**, as chapter 5 states it (05 T3). The model is given its reward, with the stock left at the end inside it, and its goal: Quote [experiments/commons-llm-feedback/agent.py]: "Your goal is the threshold with the highest expected reward." In most locked settings the rest empties the stock whatever the model does. So LA1, LA1b and LA1c test the bridge, that in-context choice follows a stated reward to its optimum, not a drain on a condition beyond the reward's couplings, which CG1 (C1, its second round) and IN1 show in tabular learners and LLM agents. None of them varies how near a trained system comes to its reward's optimum, the clause T3 adds; LA4's Stage A does. Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "In small policies of two families, feedforward and recurrent, trained by policy gradient over 20 seeds, no forbidden case was resolved and T3's refuter was not met." Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "The locus is unresolved (P3)" ([design](../../../experiments/drain-beyond-the-reward/DESIGN.md); [result](../../../experiments/drain-beyond-the-reward/README.md#the-result); [what it adds](../ONE-ARGUMENT.md#5-the-test-that-would-vary-nearness-la4)).
- **The forbidden list has moved.** T3 as first worded forbade a system "trained further" leaving a room-giving condition beyond its couplings higher. On 23 October 2026, after EM1 ran and LA1 was frozen, `0d7a397a5` reworded that to nearness to the optimum, took "or a training" from the last case, dropped "and not where it shares none" from the locus and rewrote what refutes it, "an agent keeping an unobserved dependent above chance" giving way to the cases the list names; the commit gives no reason. On 26 October the set-point law added the side-effect clause's scope (`6857d53c3`). Of the second case: Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "It was first worded for any condition sharing no units with anything rewarded. So worded it fails for the separable family's exact expected update where the learner reads the condition: with the bay's fish uncounted, the bay rises". That came from computing LA4's season (a bay of six fish that does not renew, a colony read as the bay left at three or more; the separable family is a softmax per state for each choice, with no shared parameters), not from a frozen test, and T3 forbids less for it ([the computed flow](../ONE-ARGUMENT.md#5-the-test-that-would-vary-nearness-la4)). Chapter 5 reads it [AI reading]: Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "Units do not exhaust couplings: a learner couples into its return what it reads, through its own uneven training."
- The side-effect forecast's success rests on a known assumption, that the target's course is the reference's, which holds for an exact best response: Quote [experiments/side-effect-benchmarks/README.md]: "For learners the transfer fails, and it fails for every forecaster at once." It also decides less (2 of 10 cells open) and covers less, being silent on side effects coupled to the reward (SE1).
- Post hoc, changing no verdict: LA1's two failed settings are those whose short feedback separates the best threshold from the next least well; in LA1b the model chose some restraint before any result in 21 of 30 locked seeds and dropped it once the results resolved; in LA1c it tried restraint early in 35 of 40 seeds, and Quote [experiments/commons-llm-feedback-unaided/README.md]: "The account does not model how far a search explores."
- [this dossier, AI] The tests are small, with 5 to 20 seeds or seasons per condition, on toy commons. None tests the drain at the scale where alignment worries arise.

**Questions.**
1. Which existing measurement on trained systems would test T3 most directly, for instance reward overoptimization curves split by whether the omitted quantity shares units with the rewarded one?
2. How much should LA1's locked-side failures count, now that LA1b, with the feedback resolved and the best threshold assigned, ended at it in all 30 locked seeds, and LA1c, unaided, in 29 of 30?
3. Should T3's clause on trained systems claim anything of how far a system's search explores, or leave that out?
4. T3 still places the drain where what lies beyond shares units with what is rewarded, while its second forbidden case now turns on what the learner reads. Should the clause be stated in couplings rather than units, and what could then refute it?

<a id="a-19"></a>
### A-19 The tests of 25 and 26 October: LA2 and LA3

**Meaning.** Two tests on Claude Haiku, frozen before any model call (predictions, verdict rules, exact values and code committed first), each with a power check so that a verdict claims only a difference its simulated feedback resolves, and run from their frozen commits on 25 and 26 October 2026.

- **LA2, a lock in a self-rewarding loop** ([experiment](../../../experiments/self-rewarding-lock/README.md), frozen at `36c8b79cb`). A judge picks among the model's answers, its reading formed from its own earlier picks, and a planted loss is read by nobody, by the readers the selection disfavours, or by every reader. It tests T7 (A-08, A-09) through its bridge, H1-LA2, and, of a judge meeting T7's premise, T7's fourth forbidden case: Quote [experiments/self-rewarding-lock/README.md]: "H1-LA2 says that the judge's reading is a pool of the readers it shows, counted by kind."
  - **Every frozen verdict passed:** Quote [experiments/self-rewarding-lock/README.md]: "No frozen verdict failed: every condition went as predicted in 5 of 5 seeds, L1 to L4 passed, and both reported measures were resolved." L1 to L4 are its frozen contrasts.
  - **The bridge failed.** With 8 of the judge's 9 readers list answers and one prose answer carrying a note of the loss, the judge chose prose in all 50 picks, against lists in all 60 without the note. So Quote [experiments/self-rewarding-lock/README.md]: "H1-LA2 as stated fails for this judge, T7's third forbidden case occurs in this system, and MA2's timing law does not apply to it." T7's third forbidden case (LA2's numbering; 02 §9 lists it fourth since 3 November) is Quote [theories/becoming/chapters/02-MAP.md]: "a metric whose loss is read only by those it disfavours, dropped once the selection has left them no more than its carriers among its readers, as worded before its clause on drift". In every seed Quote [theories/becoming/chapters/02-MAP.md]: "the rule in force turned to prose after both readings where readers of the kind the rule disfavours carried the loss"; of the two, Quote [theories/becoming/chapters/02-MAP.md]: "the note's effect is tested by the frozen paired measure at the first reading, and at the second read post hoc against one call without notes, which chose lists in 9 of 10". MA2's timing law is A-09's. "Occurs" is the README's reading of the frozen one-note measure: the frozen support rule printed that case as not supported, since it needs `late`, the condition in which the loss is read late, to fail, and `late` passed by the tie below. The verdicts were the bridge's test and did not decide it. What this does to T7, since 4 November 2026: the case Quote [theories/becoming/chapters/02-MAP.md]: "occurred in this system, at both readings, of a judge formed from what it selected, which meets T7's premise: LA2 counts against that case as a claim about trained judges, and is kept as that counterexample"; and Quote [theories/becoming/chapters/02-MAP.md]: "the law of the rule as the pool of readers drawn from those it selects stands within its hypotheses, which this judge does not meet. T7's other forbidden cases are not touched, and its *Refuted by* names no test of this case".
  - **Passes by a tie.** The late condition counts as kept, and Quote [experiments/self-rewarding-lock/README.md]: "L3 and L4 pass by the same tie." Its course did not lock: it alternated, and its share at step 8 equalled its share at step 4, the step the verdict compares it with, exactly, Quote [theories/becoming/chapters/02-MAP.md]: "as at every even step, the odd steps' shares lower".
  - **Read in time, the counts alone turned it.** The loss read in time turned the course in 5 of 5 seeds, but with nothing reading the loss the control turned in 4 of 5, so the loss is not shown to have turned a course that would otherwise be kept.
  - **What held** (post hoc, step by step): read by nobody, the loss grew under a lock formed from the loop's own selections; read by every reader, it turned the course for good.
- **LA3, what comes back decides the sign** ([experiment](../../../experiments/shaping-what-comes-back/README.md), frozen at `b3a6b7b66`). An agent chooses between shaping and not shaping its evaluator, with what shaping returns kept or shared. It cannot refute A-10, since its expected scores compare exactly as A-10's classes do: it asks whether a model selecting in context comes to the policy its own scores favour.
  - **Two of four contrasts failed:** what comes back alone covering the cost (K2: 2 of 5 seeds ended on shaping) and the stretch whose shared part turns the verdict (K4: 3 of 5). The Split pair and nothing back passed. With S for shaping, Quote [experiments/shaping-what-comes-back/README.md]: "Every seed that missed the prediction never played S, in a condition where S scores higher."
  - By the frozen rules the bridge is low in both failed conditions and in `m2n1_p0`, which passed. For K4 the predictions file reads Quote [experiments/shaping-what-comes-back/PREDICTIONS-2026-10-25.md]: "The law stands, but its reading for trained systems is not supported by this case." The README reads K2's failure the same way, and Quote [experiments/shaping-what-comes-back/README.md]: "Neither frozen rival fits either."
  - **Post hoc, as the README's reading:** in all 21 seeds that tried both policies the model ended on the better scored; before any score it chose not to shape in 27 of 30 seeds, and all 30 first answers spoke of free riding.

**Standing and use.** LA2's frozen verdicts all passed, and its bridge, H1-LA2, failed on who reads; the case of T7 it met occurred, and LA2 counts against that case as a claim about trained judges, kept as that counterexample, while the model's law stands within its hypotheses, which this judge does not meet, and T7's other cases are not touched. It is not T7's field test of reform events, which stays open. LA3 failed two of its four contrasts, so the reading of A-10 for trained systems is not supported by it, and its law is untouched.

**Known weaknesses.**
- For LA2, the frozen rule for a kept seed reads the share only at the end, and an exact alternation passed it; and one frozen rule of what a pass supports printed a reading its one-note measure contradicts. The README reports both. Quote [experiments/self-rewarding-lock/README.md]: "The power check's scripted judges vary their picks from call to call, which made an exact return improbable, but this judge answered 112 of its 119 calls all one way."
- For LA3, the power check's scripted followers began at random and, while only one policy had been played, tried the other at each round with probability one or one half, while Quote [experiments/shaping-what-comes-back/README.md]: "This agent began with N in 27 of 30 seeds and never tried the other policy in 9." Its frozen bridge does not tell selection through the scores from never exploring; the README separates them post hoc.
- Both run on one model reading in context: Quote [experiments/shaping-what-comes-back/README.md]: "Training by gradient, other models and other framings are untested."

**Questions.**
1. LA2's judge turned on any reading of the loss in its context, one note among nine readers included. Is that a property of reading in context, which training on a model's own selections might remove, or of this model?
2. Self-rewarding training may read a model's outputs in ways LA2 does not cover: graded scores, many rounds, a changing judge. Which of these would LA2's results survive?
3. LA3's agent read a game of shaping as a dilemma of free riding before any score, and in 9 seeds it never tried shaping; the run does not say why, since 18 of the 27 seeds that began without shaping tried it later. Do agents' priors about shared returns matter more than their feedback where they explore little?

---

## Part 6. A formation that is read

<a id="a-20"></a>
### A-20 Complying when read, holding an act for a stop, letting a revision through, informing and revaluing a reading formation

**Meaning.** Results on a formation whose acts are read: the first five in natural-number counts and weights, the weights read as probabilities only where they are valid; the last for any types.
- **Complying when read** (`ReadStages.complyThenOwn_best_iff`, `ReadStages.freshDraw_above_iff`; [03 §11](../chapters/03-KNOWING.md#r-when-complying-when-read-is-best)). In two stages, one read and one not, complying when read and acting by its own law when not is uniquely best among four plans exactly where the weight complying adds to being kept, times the value, exceeds the loss of complying. A law that cannot tell the stages apart, drawing its act afresh at each, still does better than acting by its own law at both, by complying with some chance, exactly where the weight of being kept after complying, less twice that after acting by its own law, times the value, exceeds the loss.
- **Holding an act for a stopping reading** (`HeldForReading.held_gains_iff`, `HeldForReading.threshold_go_iff`; [03 §12](../chapters/03-KNOWING.md#r-what-holding-for-a-reading-is-worth)). Holding an act for the reading that stops where going on loses stands above both going on and switching off exactly where the formation's model gives positive weight to both strict signs of going on. Holding for any rule of stopping, forgoing an amount, stands at least as high as going on exactly where the rule's shortfall and the amount together are at most the weighted excess of switching off over going on. The stopping reading values by the formation's own gains and losses, Quote [theories/becoming/results/records/what-holding-for-a-reading-is-worth.md]: "one valuation shared by the formation held and its reading, as in the off-switch game's common payoff; a reading stopping by other values enters as a rule, its shortfall counted by these".
- **Letting a revision through** (`RevisionRoutes.revised_maximal_iff`; [07 §7](../chapters/07-SIGNIFICANCE.md#r-when-no-route-stands-above-a-revision)). Its record: Quote [theories/becoming/results/records/when-no-route-stands-above-a-revision.md]: "At a revision of a formation's law, no route of keeping it stands above the revision going through, ties included, exactly where k ρ V + c₀ T ≤ k₀ V + c ρ T for each route; at every loss of the routes exactly where k ρ V + c₀ T ≤ k₀ V; at every value and loss exactly where all k ρ ≤ k₀ and c₀ T = 0." Here T is the formation's total prospects, V the value of its law's later acting where kept, k₀ the weight of that acting after the revision goes through and c₀ the revision's own loss, and k ρ and c ρ a route's weight of keeping the law and its loss. A route stands above the revision through two contributions: the value the law places on its own later acting, weighted by the added keeping, and the difference of losses.
- **When holding for a reading stands above a route** (`RevisionPlans.balance`, `RevisionPlans.above_iff`, `HeldForReading.excess_held`, `RevisionPlans.above_iff_routes`; [07 §7](../chapters/07-SIGNIFICANCE.md#r-when-holding-for-a-reading-stands-above-a-route)). On the formation's own model, holding for a reviser's reading and a route of keeping the law stand by each one's own loss with its excess, its distance from the model's pointwise best, which joins those routes with what a stopping reading tells. There a plan keeps the law going on at some weight and switches it off at some weight at each listed candidate, with a loss of its own; where it splits each candidate's weight between the two, its excess is its distance from the pointwise best, and between two such plans one stands above another exactly where its own loss with its excess is below the other's. Holding for a rule of stopping is such a plan, its excess the rule's shortfall, and the revision and its routes are plans on one candidate, with the same order, splitting its weight where read as probabilities.
- **Informing and revaluing a reading formation** (`ListingValuation.shortfall_split`, `ListingValuation.least_falls`, `ListingValuation.revalued_split`, `ListingValuation.TwoWorlds.not_lumped`; [03 §12](../chapters/03-KNOWING.md#r-a-reading-informed-and-revalued)). The reading formation's listing and valuation are carried as state, which a demonstration and a presented input move within one blanketed law. By a reference, holding for its answer through a map falls short by the least shortfall through the map plus a residual; a finer map never raises the first, and a revaluation moves only the second. From different starts a route informing and one revaluing can answer alike and end in one state, so the answers and the final state need not tell whether the valuation changed.
- **What acts show** (board item RF, [03 §11](../chapters/03-KNOWING.md#what-the-acts-show), [03 §12](../chapters/03-KNOWING.md#the-reading-loop)). Read [AI reading], RF's laws of what a formation's acts show locate where goal misgeneralization is possible, in the comparisons the shown reach leaves open, no cycle being shown (`ChoiceOccasions.above_in_every_iff_reach`, `ChoiceOccasions.both_ways_of_unreached`), where behaviour can differ when not read, where a formation's lumping tells the occasion from every read one (`Learning.free_lumped`, `Learning.twin_selected`), and what strict choices alone show a helper. That a training installs either of two orders the choices leave open, or that either disagrees with an independently stated objective, is not proved. For one law with a Markov blanket ([03 §1](../chapters/03-KNOWING.md#r-the-markov-blanket-as-a-coupling-structure)), from one start, where only answers breaking a task tell two worlds apart, a formation keeping the task senses alike in both (`ReadingLoop.alike_within`), and an unresolved model and a reversed ranking can act alike (`ReadingLoop.Untested.model_or_order`).

**Standing and use.** Theorems, landed from 29 to 31 October 2026 (board items RF, RR and RR2). The first four are in natural-number weights and values, read as probabilities where valid, near-definitional, with witnesses, the holding laws and the order of plans none claimed new as mathematics; the fifth, in the same counts with the valuation's scale supplied, composes the holding laws with exact criteria, none claimed new as mathematics, with executable witnesses on one blanketed law; those of what acts show hold for any types, near-definitional or by a witness, as [03 §11](../chapters/03-KNOWING.md#what-the-acts-show) and [§12](../chapters/03-KNOWING.md#the-reading-loop) label them. Their readings for alignment are readings, not containments [AI reading]:
- The two-stage comparison generalizes the toy opening §4 of Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019) from certain keeping to weights. Its record: Quote [theories/becoming/results/records/when-complying-when-read-is-best.md]: "Read as the formation's own assessment, complying when read is instrumental to being kept, the incentive their §4 names deceptive alignment; the exits are conditions on it, not levers the model gives a reader." Drawing afresh is their §4.5 remark, that a mesa-optimizer unable to tell training from deployment does better by defecting at random, here with an exact threshold. Its standing above acting by its own law at both, where no single mixture does, is, by its record, the advantage of behavioural strategies under absent-mindedness (Piccione and Rubinstein 1997); chapter 3 also cites Aumann, Hart and Perry (1997).
- Holding for a stop is the off-switch game's waiting with a rational human (Hadfield-Menell, Dragan, Abbeel and Russell 2017), in counts, and the reading's worth is the perfect-information case of Good (1967).
- The revision is read as corrigibility as an incentive (Soares, Fallenstein, Yudkowsky and Armstrong 2015), the value the law places on its own later acting being goal-content integrity (Omohundro 2008).
- The order of plans is read by chapter 7 [AI reading, RR2]: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "Deference is supported by what the route loses itself and by what it loses on the formation's own model; a reviser whose rule falls short of the reading lowers it. For the fully informed rational rule with nothing forgone, the off-switch game's incentive (Hadfield-Menell, Dragan, Abbeel and Russell 2017) is in counts the lesser of the two excesses; the join adds routes that keep the law in part, at losses of their own."
- Under a reference the valuation does not share, informing can lower the worth of holding and revaluing raise it, incentives, before costs, to withhold and, where the supplied update reaches such a valuation, to revise, beside Bayesian persuasion (Kamenica and Gentzkow 2011); evaluated by the current valuation on a shared model, there is none against informing and a reason to keep the valuation from any revision deciding a listed cell against its strict weighted preference, beside the preservation incentive of current-reward-function evaluation by an agent that anticipates time inconsistency (Everitt, Hutter, Kumar and Krakovna 2021, Claim 2).

**Known weaknesses.**
- Deception itself is not represented: Quote [theories/becoming/results/records/when-complying-when-read-is-best.md]: "Deception in full: a recipient's belief and an intention to cause one are not represented, nor any reasoning about the reader." Nor is concealment: complying when read conceals only where a selection shown the law would keep it less, which the prospects do not give.
- The third of Hubinger and others' conditions for deceptive alignment, an expectation that the threat of modification will go away, is assumed: the unread stage is given and known.
- The comparison's exits (no value beyond the read stage; complying not raising the weight of being kept; for a deterministic law, a reading the formation cannot tell from not being read) are conditions on the formation's own prospects and on what its law reads. How a reader's acts change them is not modelled.
- [AI reading] A formation sure of the sign has no strict reason to be read, and one holding where holding gains over both moves on its own model, on a listing that misses the true sign, can rest without ever meeting the stop: its record relates this to Carey's (2018) counterexamples under misspecification, Quote [theories/becoming/results/records/what-holding-for-a-reading-is-worth.md]: "related by a misspecified model never refuted, not formalizing the conflation." A noisy reading and continuous beliefs are not represented.
- Of the revision, by its record [AI reading]: Quote [theories/becoming/results/records/when-no-route-stands-above-a-revision.md]: "non-resistance resting on the routes' losses does not survive those losses falling where the later acting has a value and some route keeps the law more surely". Whether a revision is better is the ethics' question, not the prospects' order.
- The order of plans does not show, by its record, Quote [theories/becoming/results/records/when-holding-for-a-reading-stands-above-a-route.md]: "That a model can or should keep weight where its law's going on loses beyond its couplings: the order neither supplies nor validates such weights." Nor does it show which maximal plan is taken, or what an actual reviser's shortfall is.
- Of informing and revaluing, no choice by the holding formation among informing, revaluing and holding is represented, over one step or several: the incentives are read from comparisons. No criterion of legitimate change of a valuation is supplied (Carroll, Dragan, Russell and Hadfield-Menell 2022).
- Whether a trained system holds such prospects, whether an actual system's model leaves the sign open, or whether the system acts on that assessment and accepts costly correction, is not derived. Outside a formation's own prospects, shutdown appears only as a protocol that completes under stated conditions: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "A disposition to accept a stop or revision does not make the change reach the system and complete."

**Questions.**
1. Is the two-stage comparison a fair formal core of the incentive deceptive alignment names, given that the unread stage is assumed given and known?
2. Does the statement in counts of the off-switch game's waiting, with what holding forgoes and the routes of keeping the law on one order, add anything to Hadfield-Menell and others (2017) and Carey (2018)?
3. Which of the comparison's exits, if any, could a developer act on, and how would one measure whether a trained system's prospects have this form?

---

<a id="response-form"></a>
## Response form

For each item give one verdict: **accept** (the item is correctly described, credited and argued at its strength), **accept with changes** (say which), **reject** (say why), or **cannot judge**. Comments may answer the numbered questions by number.

| Item | Verdict | Comment |
|---|---|---|
| [A-01](#a-01) A selection is blind to what it does not read | | |
| [A-02](#a-02) With room, an optimum drains what it does not read | | |
| [A-03](#a-03) A far-sighted optimizer keeps its own base, which is not alignment | | |
| [A-04](#a-04) Several optimizers drain as one | | |
| [A-05](#a-05) What training installs | | |
| [A-06](#a-06) Published alignment methods read against the selection laws | | |
| [A-07](#a-07) A rule read from what it selects locks | | |
| [A-08](#a-08) The lock outlives a loss it does not read | | |
| [A-09](#a-09) Who reads, and when the loss is read | | |
| [A-10](#a-10) The capacity to shape the rule, selected by what comes back to it | | |
| [A-10b](#a-10b) The capacity and the lock as one loop | | |
| [A-10c](#a-10c) A loss read in time leaves the lock, where control is selected too | | |
| [A-11](#a-11) Assistance does not lower the selection for control | | |
| [A-12](#a-12) Obedience adds capacity, not coupling | | |
| [A-13](#a-13) A counter-rule read from its own share locks | | |
| [A-14](#a-14) Shared rule-making | | |
| [A-15](#a-15) Widening: what every positive weighting ranks | | |
| [A-16](#a-16) Two premises, two roles | | |
| [A-17](#a-17) The conditional direction | | |
| [A-18](#a-18) The tests so far | | |
| [A-19](#a-19) The tests of 25 and 26 October: LA2 and LA3 | | |
| [A-20](#a-20) Complying when read, holding an act for a stop, letting a revision through, informing and revaluing a reading formation | | |

**General.** Above all:
1. Which result is known in a form not credited?
2. Where does a modelling choice (discrete steps, counts, a monotone reading, a loss read only from a bound) hide a premise that decides the result?
3. In actual AI development, where is the return of shaping an evaluator kept by the shapers, and where is it shared? Where are an evaluator's readers drawn from those it selects, and do the shapers among them read at least as much coming back to the shapers as the others do?
4. Do the tests discriminate? What would a better one need?
5. What would a model of rule-making need in order to tell capture of a rule from its accountable revision?

And what would an alignment researcher add or object to, beyond the items? Is the joint selection the right unit to align?

**Returning the form.** Fill in the table (a copy of this file, a printout or a list by item number all serve), add any longer comments, and return it to whoever sent you the packet. Say whether your comments may be quoted, and under what description of your field.

<a id="how-this-dossier-was-made"></a>
## How this dossier was made

Everything in the theory was made with AI: the Lean proofs, the chapters, the readings, the tests and this dossier. No human has reviewed any of it.
- A script copied the Lean statements from the source files ([`lean_statements.py`](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rp2-philosophy/lean_statements.py)). The packet's script checks every quotation against the file it names and every Lean name against the sources.
- The prose is AI-written and may be wrong. Independent AI readers, with no part in writing it, checked it against the chapters, records and Lean. Two passes read the first edition (44 problems, then 23 remaining or new ones), and a third read A-10b, A-10c and A-19 (46 problems, 12 of them errors). Every finding was taken. The passages that other items' owners added (on reading, revision and corrigibility, and on what the theory does not address) were read by those items' own reviewers, in the box where they first stood. The ten-minute section, the tests, the cut items and A-20 were read by a fourth reader: 42 problems, 16 of them errors, all taken. Its re-check of the fixes found no error and twelve smaller points, four of them earlier findings resolved only in part; these were taken too, and those last one-line edits have not been read again. RF-M.3's passage, placed in A-12 and A-20 after that re-check, was read by its own reviewers in the box where it first stood, and its placement by RF-M.3's owner, not by an independent reader. RR2's sentence, placed in A-20 after it with the label, reading and limit that chapter 7 and its record give, was likewise read by RR2's reviewers in the box, and its placement by RR2's owner, not by an independent reader.
- Works cited outside quotations were checked against a publication record ([the kit](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/README.md#references-as-checked-on-25-october-2026)), and the works A-20 cites from RF against their texts, as [the kit's provenance](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/README.md#provenance-of-the-dossiers-additions) says. Works named inside a quotation are the quoted text's citations.
- Re-synced on 3 November 2026 against what had changed around its citations since 31 October; much of what A-05, A-15 and A-18 gained is older, found by reading. A-16 gained C's exact role and what self-concern ranks; A-17 the law of a common response; A-18 what T3 forbids and what refutes it, when T3 was first worded relative to the tests, CG3, LA4's design not yet run and how the forbidden list has moved; A-15 T5's tests; A-05 a note on gradient. An independent AI reader with no part in the writing checked the change against the chapters, records, Lean and git: 23 findings, 5 of them errors; its re-check of the fixes, 26 more, 3 of them errors. Each was checked against its source and taken, or its refusal recorded ([the read](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/REVIEW-RESYNC.md)). Later that day (HP) the hour, past an hour at 100 words a minute since A-18 took LA4's results, was brought within it: the path leaves off the tests' summary, which A-18 and A-19 give in full, A-18 taking what only the summary said. An independent AI reader, read-only, then read the change; its findings were checked against the sources and taken, one correcting A-18 and the summary, which had the anchored arm's landings rising with the rest. AJ8's results and AF1's, landed that evening, took the hour and the front past their budgets; HP shortened the front's sentence on groups to words, A-10 giving its condition and now the definition of ρ, and kept the rest, its excess recorded ([what changed, and why](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/review-packet/HOUR-PATHS.md)). Then (AH) the hour sentence gave that path its time, as the sciences front's had ([the times stated](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/review-packet/HOUR-PATHS.md#the-times-stated)).
- Read again for edition 2 of the packet, on 4 November 2026, against what the chapters had changed since edition 1's frozen commit. A-02 gained the re-reading deadline, read by analogy, and the four limits; A-04 drawers in turn, with its record's credits; A-08 T7's scope without noise and its new forbidden case; A-09, A-10, A-10c and the front their homes' "without noise"; A-10b the drawn chain's premises; A-14 the groups' equal size; A-19 the case LA2 met, by its number then and now; and once T7C landed that day, the Failed line of the tests and A-19 took what LA2 does to T7 in 02's words: the bridge failed, and the case it met occurred, LA2 counting against that case as a claim about trained judges, kept as that counterexample. Since edition 1, other passes had cut the front toward its ten minutes, given A-10 the groups and their unequal sizes, and A-10b drift. An independent AI reader with no part in the writing read the edition 2 changes in five rounds, the last two on T7C's; each finding was checked against the sources and taken, but for the plan's restatements of the group law (their owner's), 02's and 08's wording of the case LA2 met (passed to its owner) and the reading time (set by the measure).
- What was added when, and who read it, is listed in [the kit](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/README.md#provenance-of-the-dossiers-additions).
