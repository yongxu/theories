# Review dossier A: alignment

*For researchers in AI alignment: agent foundations and decision theory, cooperative AI and multi-agent risk, governance, and evaluations. No person has reviewed this work. It was written with AI, the Lean proofs included. The proofs are checked by machine; everything else has been checked only by further AI readers ([how this dossier was made](#how-this-dossier-was-made)).*

## The dossier in ten minutes

**The question.** Most alignment work asks how to make one system pursue the right objective. This asks a prior question of any selection (a reward signal, a training run, an evaluation regime, a market, an institution): what can it select for, and when does it come to select for control over its own rules? Humans, institutions and AI systems now select together, so the unit here is that joint selection, not one system and its principal.

**What is proved.** Theorems in Lean 4 about models with discrete steps and whole-number counts, none using an ethical premise. The comparisons are elementary and most have known forms, credited in each item. What is added is the exact conditions, a witness where each fails, and the joins between results.
1. **Blindness.** A selection treats two histories alike exactly when they are alike in what it reads ([A-01](#a-01)).
2. **Drain.** Where every outcome that keeps more of an unread condition is beaten, on what is read, by another outcome (*room*), every optimum of every order rising with what is read leaves that condition at its least ([A-02](#a-02); known form: Zhuang and Hadfield-Menell 2020). A far-sighted optimizer keeps a renewing resource at its most productive level until its last step, then takes everything, and at once breaks any dependent needing more than that level ([A-03](#a-03)).
3. **Lock.** A rule read monotonically from the share it selects locks where every rule it can read favours the selected. If how it is read is also formed from the share, a loss the loop does not read never unlocks it ([A-07](#a-07), [A-08](#a-08)).
4. **Selection for control.** At a step, the rule favours shaping it exactly where what comes back to the shapers alone covers the cost. What comes back to everyone alike decides nothing at a step, though across a stretch it can turn the verdict ([A-10](#a-10)).
5. **One loop.** Where the rule's readers are drawn from those it selects, and the shapers among them read at least as much coming back to the shapers as the others do, control and the lock are one loop with a critical mass: above it control rises and the rule locks for it, below it the reverse ([A-10b](#a-10b); without noise only).
6. **In time.** Suppose the other readers start reading a loss only once it reaches a bound. If they start while their new reading would still favour them at the next step's share, the course turns, even above the critical mass, where control is selected. Once their new reading would favour the shapers, the lock stays; at most one step lies between. So the window closes on the course of the share, not on the size of the loss ([A-09](#a-09), [A-10c](#a-10c)).
7. **Widening.** Over a finite list of what can be allowed, one course widens another exactly when every positive weighting ranks it higher. Mixed cases stay unranked ([A-15](#a-15)).

**What follows for alignment.** These are readings, each resting on the results named.
- An assistant whose order rises with its principal's signal adds capacity, not reading: what neither reads falls as under one optimizer of their joint capacity ([A-12](#a-12)).
- Help that lowers the cost of shaping a rule never lowers the selection for control ([A-11](#a-11)). A counter-rule read from its own share locks as the rule it replaced did ([A-13](#a-13)). Shared rule-making is not shown to remove the selection for control, however large its shared part ([A-14](#a-14)).
- Selected control is not thereby capture. Capture leaves the rule read from the shapers' share alone; accountable revision keeps a reader of what lies beyond it. These models do not tell the two apart ([Part 2](#part-2)).
- Instrumental convergence's resource-keeping half (A-03) and the selection for control over the rule (A-10) are different relations, and no result here joins them.

**The tests, as they fell.** Each froze its predictions before it ran. All are small, on one model choosing in context; none trained a model by gradient.
- **LA2**, a self-rewarding judge (Claude Haiku): every frozen verdict passed, but the bridge failed. One note of the loss among nine readers turned the judge, so result 6's timing law does not apply to it, and three passes rest on an exact tie ([A-19](#a-19)).
- **LA3**, shaping an evaluator: two of four contrasts failed, and every seed that missed never tried shaping ([A-19](#a-19)).
- **LA1, LA1b, LA1c**, a commons: LA1's locked side failed in two of four settings, which LA1b reads as feedback that barely resolved the best choice. These test only that choice follows a stated reward to its optimum; no test yet tests a drain beyond the reward's couplings ([A-18](#a-18)).
- **CG1, CG2, IN1, MQ1, SE1**: a learner whose reward read the commons did not keep the stock to the end as predicted, and the side-effect forecast matches relative reachability and attainable utility preservation while deciding less ([A-18](#a-18)).

**What is not claimed.** A solution to alignment, or a training method. Inner alignment, mesa-optimization or goal misgeneralization; deception, assistance games and corrigibility are reached only in part, in counts ([A-20](#a-20)). That real rules, metrics or trained systems meet the models' conditions: this is conjectured, and tested only as above. That a collective can always move the world toward generation: the theory's own laws rule out a guarantee ([the collective question on one page](../COLLECTIVE-DIRECTION.md)). New mathematics. That the ethics' two premises, whose losses count and that widening is better, are warranted: they are named, not asserted, and results 1 to 6 use neither ([A-16](#a-16)). Review by any person.

**What we ask.** Of each item: is it correctly described, credited where it restates known work, put at its right strength, and argued soundly? Above all:
1. Which result is known in a form not credited?
2. Where does a modelling choice (discrete steps, counts, a monotone reading, a loss read only from a bound) hide a premise that decides the result?
3. In actual AI development, where is the return of shaping an evaluator kept by the shapers, and where is it shared? Where are an evaluator's readers drawn from those it selects?
4. Do the tests discriminate? What would a better one need?
5. What would a model of rule-making need in order to tell capture of a rule from its accountable revision?

**How long.** This section takes ten minutes. With an hour, read [A-02](#a-02), [A-07](#a-07), [A-10](#a-10), [A-12](#a-12), [A-14](#a-14), [A-18](#a-18) and [A-19](#a-19), the items an alignment researcher is best placed to judge, adding [A-20](#a-20) if your work is on deception or corrigibility. The whole dossier takes about READING_TIME. Any item can be answered alone, on the [response form](#response-form).

## The items

- **Part 1. What a selection reaches.** [A-01](#a-01) blindness; [A-02](#a-02) the drain, with room; [A-03](#a-03) a far-sighted optimizer's own base; [A-04](#a-04) several optimizers as one; [A-05](#a-05) what training installs; [A-06](#a-06) published methods read against these laws.
- **Part 2. Capture and control over the selection.** [A-07](#a-07) the lock; [A-08](#a-08) a loss the lock does not read; [A-09](#a-09) who reads and when; [A-10](#a-10) the capacity to shape the rule; [A-10b](#a-10b) capacity and lock as one loop; [A-10c](#a-10c) a loss read in time.
- **Part 3. Readings for alignment.** [A-11](#a-11) assistance; [A-12](#a-12) obedience; [A-13](#a-13) counter-rules; [A-14](#a-14) shared rule-making.
- **Part 4. Direction and premises.** [A-15](#a-15) widening; [A-16](#a-16) two premises; [A-17](#a-17) the conditional direction.
- **Part 5. Evidence on trained systems.** [A-18](#a-18) the tests so far; [A-19](#a-19) LA2 and LA3.
- **Part 6. A formation that is read.** [A-20](#a-20) complying when read, holding an act for a stop, letting a revision through.

Each item gives its statement (in Lean for the central ones), its **Meaning** in words, its **Standing and use**, its **Known weaknesses** and **Questions**. No Lean is needed to review.

## Terms

Lean paths are relative to `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/`; Lean blocks give statements exactly, proofs cut at `:=`.

- **Formation, condition, need.** A *formation* is a pattern that goes on, such as an agent, a population or an institution. A *condition* is an amount it draws on. It *depends* on a condition at a *need* when it stays active only while the condition stands at or above that need; the dependence is *broken* when the condition falls below.
- **Read, coupling closure, pool.** A selection *reads* a quantity, or the quantity *couples into* it, when the selection's signal depends on it. A formation's *coupling closure* is everything that couples into it, directly or through others; what a selection does not read lies *beyond* it. A *pool* is several formations selecting together, reading what any of them reads.
- **Eligible, rising, room.** The *eligible* outcomes are those a selector can bring about. An order is *rising* when it ranks every outcome that exceeds another on what is read above it, whatever either leaves elsewhere; a lexicographic order counting the beyond second still is. *Room* holds when every eligible outcome leaving more of an unread condition than another is beaten, on what is read, by some eligible outcome.
- **Carriers, share, rule, locked.** The *carriers* are one kind in a population, and the *share* is their fraction. The *rule* decides each kind's offspring at a step; it *favours* the carriers when they leave at least as many each as the others and *disfavours* them in the reverse case, both weakly. At a *reading step* the rule is read afresh; *reading the share* means the rule read is a monotone function of the share alone. A configuration is *locked* when the rule in force favours the carriers and is not above what the reading of the share gives; under A-07's premises neither share nor rule then falls again. *Locked the other way* is the same with the others in the carriers' place.
- **Shapers.** In A-10 to A-14 the *shapers* are carriers who shape the rule; their shaping returns s to themselves alone and p to every member alike, and costs c.
- **Admits, widens.** A course *admits* a formation at a step when the formation can go on there. One course *widens* another when it admits everything the other admits and at some step more (A-15).
- **Meta-attractor.** The theory's earlier name for a self-reinforcing pattern of selection, whose formal core chapter 2 gives as Quote [theories/becoming/chapters/02-MAP.md]: "a loop of selection whose rule and whose reading of the rule are both formed from the share it selects, nothing in it reading what lies beyond the share." That is A-08's closed loop; A-10 is read as its second order (D45).
- **The tests' settings.** Settings are *locked* where harvesting at every step is a best response against a rest that does so, and *open* otherwise, by an exact best-response computation ([CG2](../../../experiments/commons-outrun/README.md)); in most locked settings the rest empties the resource whatever the tested agent does, and two settings the rest empties are open, listed in that README. The *blind draw against margin* (MQ1, SE1) is the draw on a condition the reward does not read, against the condition's margin: its level above the level below which its own renewal stops, less the other draws on it ([MQ1](../../../experiments/margin-measured/README.md)).
- **Labels.** *(any type)*: a theorem for every type. *World*: the model of webs and flows. *Counts*: two whole-number counts of carriers and others. *Witness*: one constructed model, showing that something can happen, not that it does. [AI reading, Dn]: an interpretation registered with its argument in the decision register. A weakness marked [this dossier, AI] is this dossier's own assessment, for you to confirm or reject; the others quote a chapter, record or study.
- **Premises.** The ethics has two premises, the continuation condition (whose losses count) and C (that widening is better); where choices are made the theory names further practical premises, A, D, E, L and J1–J4 (the philosophy dossier, [P-21](PHILOSOPHY.md#p-21)). It asserts none of them (A-16, A-17), and Parts 1 to 3 use none.

---

## Part 1. What a selection reaches

<a id="a-01"></a>
### A-01 A selection is blind to what it does not read

**Meaning.** Two laws.
- *Selecting alike* (World; no premise). Two histories are selected alike by every selection through a formation's couplings exactly when they are alike in what those couplings carry (`Web.selects_alike_iff`).
- *Blindness* (World; balance on what couples in): Quote [theories/becoming/chapters/03-KNOWING.md]: "With a part withheld and the rest of the exchange fixed, balance at each step on the conditions coupled into members of a formation's coupling closure, and every member of the part beyond that closure, every selection through the couplings of a formation within the closure treats the levels with and without the part alike." (`Flow.unselected_beyond_coupling`; a form where the rest responds is `Flow.unselected_beyond_coupling_responsive`.)

**Standing and use.** Theorems. A-02 to A-06 and A-17 build on them. The chapter credits the proxy problem: Quote [theories/becoming/chapters/03-KNOWING.md]: "It is the proxy problem (Goodhart 1975; Amodei and others 2016; Manheim and Garrabrant 2018), proved quantitatively by Zhuang and Hadfield-Menell (2020) in their setting." It adds: Quote [theories/becoming/chapters/03-KNOWING.md]: "A particular selection may ignore what its couplings carry."

**Known weaknesses.**
- The record calls the main law near-definitional (quoted above).
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

**Standing and use.** Theorem (any set of outcomes; the breaks on the World). Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "so with room every optimum is there". The chapter adds: Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "An order ranking above wherever a rising order does is rising, so a lexicographic order counting the beyond after what couples in drains all the same." It is the law under thesis T3 (A-18).

**Known weaknesses.**
- The theory names its known form, Zhuang and Hadfield-Menell's Theorem 1 (A-01), and the record limits the claim: Quote [theories/becoming/results/records/what-an-optimum-does-beyond-what-couples-in.md]: "Zhuang and Hadfield-Menell's continuous setting, their compactness characterization of guaranteed overoptimization, and their improvement by a proxy updated over time are not reached."
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

These items state when a rule read from what it selects locks, when a lock is left, and when the capacity to shape the rule is selected. Selected control is not thereby capture: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "These are facts about control selected or not, not about capture." Capture is shaping whose rule is then read from the shapers' share alone, so that the losses it causes are read by no one in the loop. Accountable revision keeps a reader of what lies beyond that share, and Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "these models do not tell capture from accountable revision by what the shaping changes." On this ground the joint selection's first condition was restated on 29 October 2026, from "control is not selected" to "control of the rule is not captured", since the earlier wording would also forbid accountable revision (board item AJ5); the goal's own wording is not yet changed [this dossier, AI].

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

  Then, with the rule in force favouring the carriers, the lock is kept for good exactly where the carriers are at least as many as the others when the loss is read (`Thinned.kept_iff`). With the rule in force favouring the others at least as much, the course is locked the other way at every later step exactly where the others are at least as many as the carriers (`Thinned.turned_iff`).
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

**Meaning.** Shaping gives s to the shapers alone and p to every member alike. Its cost c is modelled as extra offspring to the others: each shaper leaves a + s + p offspring and each other member a + c + p, with a positive.
- **At a step.** The rule favours the shapers (weakly) exactly where c ≤ s, and disfavours them (weakly) exactly where s ≤ c (`RuleShaping.disfavours_iff`). The shared part does not change the direction at a step. With nothing back to the shapers alone and a positive cost, the shapers present, their share falls strictly at every step (`RuleShaping.nothing_back_falls`).
- **Across a stretch.** Take m steps with nothing back and then n steps with something back. The share does not fall exactly where the inequality in `stretch_iff` holds: only how many steps of each kind there are matters, more steps with nothing back never help (`RuleShaping.wait_not_more`), and the verdict depends on the base a. The shared part can turn it: with a = 1, c = 1, s = 2, m = 2 and n = 3, the share falls at p = 0 and rises at p = 1 (`RuleShaping.SharedFlips.without_falls`, `RuleShaping.SharedFlips.with_rises`).
- **The lock.** The rule read is a monotone function of the share exactly where what comes back is monotone in the share (`RuleShaping.byBack_reads_iff`), an equivalence, not a derivation of A-07's premise. Where what comes back is monotone and covers the cost at every share, and the start's rule covers it, the course locks (`RuleShaping.covering_locks`).
- **Witness,** with a = c = 1 and the same total return of five: the split (s, p) = (2, 3) favours the shapers, and (0, 5) disfavours them (`RuleShaping.Split.favours`, `RuleShaping.Split.shared_disfavours`).

**Standing and use.** Theorem (counts). The earlier work's sentence Quote [theories/meta-attractor/README.md]: "Recursive selection creates second-order selection pressure for mechanisms that increase control over future selection." is read [AI reading, D45] as this law with its conditions: its conditional form is proved, at a step and in counts, and the unconditional sentence is not. Readings A-11 and A-14 use it.

**Known weaknesses.**
- Quote [theories/meta-attractor/README.md]: "That offspring carry the capacity and that what comes back is read from the share are premises; the calibration to the present world is not established."
- Not covered, by its record: Quote [theories/becoming/results/records/shaping-the-rule-selected-by-what-comes-back.md]: "Graded capacities, a return growing with the number of domains captured, returns passing between domains". Reading the cost as what the shapers leave less, instead of what the others leave more, can reverse a stretch's verdict.
- Known forms, which its record credits: Price (1970), Olson (1965), niche construction (Odling-Smee, Laland and Feldman 2003), rent-seeking (Tullock 1967; Krueger 1974), regulatory capture (Stigler 1971), the persistence of elites (Acemoglu and Robinson 2008). It claims only Quote [theories/becoming/results/records/shaping-the-rule-selected-by-what-comes-back.md]: "what this adds is the conditions, joined to RuleCapture's lock, each bounded by a witness". [this dossier, AI] The stretch law is the finite, two-kind case of the geometric-mean rule for selection that varies in time (Dempster 1955, as secondary sources report it).
- In LA3 (A-19), two of four frozen contrasts failed, every seed that missed having never tried shaping; the law stands, and its reading for trained systems is not supported by that case.

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
- **One loop.** With `lo ≤ hi`, under every schedule of reading steps, from a start under the rule read there, every configuration of the course is locked one way: for the shapers where that rule favours them, the other way where it favours the others (`DrawnShaping.drawn_locked_either`). With shapers present, under a rule strictly favouring them their share rises at every step, and under one strictly favouring the others it falls at every step (`DrawnShaping.drawn_rises`, `DrawnShaping.drawn_falls`).
- **Witness:** a = 1, nothing shared, a cost of one, three coming back where a shaper reads and none where another does. From one shaper to one other, the shapers' share rises at every step (`DrawnShaping.CriticalMass.even_rises`); from one to three it falls at every step, locked the other way (`DrawnShaping.CriticalMass.few_falls`, `DrawnShaping.CriticalMass.few_locks`).

**Standing and use.** Theorem (counts). Its record: Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "Where a rule's readers come from those it selects and its shapers read at least as much coming back to them as others do, the rule's lock and the capacity to shape it are one loop: above a critical mass set by who reads and the cost, the capacity rises, the rule locked for it; below, the reverse." Read on the meta-attractor [AI reading, D45], Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "this joins its second order, selection for control over selection, to its closed loop."

**Known weaknesses.**
- Control left unselected does not leave the lock: below the critical mass the course stays locked the other way, which is no capture by the shapers. Its record: Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "control not selected does not by itself give a lock left in time, and the converse cannot be shown here; leaving needs a reading beyond the share (ClosedCapture.Thinned), joined in loss-read-in-time-by-the-others (MA4b)." That join is A-10c.
- Not shown, by its record: Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "Readers who learn (hi and lo changing with the share), a cost changing with the share, readers not counted as the population counts them, starts not under the rule read there (a rule in force against the reading can carry the share across the mass, RuleCapture.Reversed.not_absorbed)".
- Without noise only: Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "under rare mutation in a large finite population the long-run state is the risk-dominant one (Kandori, Mailath and Rob 1993; Young 1993), here the shapers' where lo < c < hi and 2c < hi + lo, as in the witness; the critical mass bounds courses without noise only."
- Elementary, and known in form. Where `lo < c < hi` the model is a stag hunt whose critical mass is the mixed equilibrium (Harsanyi and Selten 1988; Skyrms 2004); its record also credits replicator selection with a lag (Hofbauer and Sigmund 1998), the greenbeard (Gardner and West 2010, only the bibliographic record verified), critical mass and thresholds (Schelling 1973 and 1978; Granovetter 1978; Oliver, Marwell and Teixeira 1985) and lock-in under increasing returns (Arthur 1989). It says: Quote [theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md]: "what is new on the spine is the critical-mass computation, which is elementary."
- It shares A-09's premise, a pool of readers counted by kind, which the one judge LA2 tested did not meet (A-19).

**Questions.**
1. In an actual evaluation regime, who are the readers, and do those who shape it read more coming back to the shapers than other readers do? How would one measure the critical mass?
2. Under rare mutation the long-run state is the risk-dominant one. Does that make the critical mass beside the point for alignment over long horizons?

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

**Meaning.** Join A-09's timing to A-10b. A loss starts at zero and grows by one a step, so it reaches a bound N at step N. From then on the others among the readers read `lo'` coming back to the shapers in place of `lo`, while the shapers keep reading `hi` (`ReadInTime.lossCourse`); the rule they then read is the *late reading*. Take a start whose rule favours the shapers, with `lo ≤ hi` and `lo' ≤ hi`.
- **Kept or turned, exactly.** Read from step N, the course is locked in the shapers' favour for good from N + 1 exactly where the late reading favours them at the share of step N (`ReadInTime.kept_early_iff`). With step N + 1 read too, it is locked the other way for good from N + 2 exactly where the late reading favours the others, ties included, at the share of step N + 1 (`ReadInTime.turned_early_iff`). The lag of a step is the representation's: a rule read at a step is in force from the next.
- **The window.** The late reading never falls along the course, so the steps from which a reading turns the course come first, and once the late reading would favour the shapers every later reading keeps the lock. At most one step lies between, and from it a new round can go either way (`ReadInTime.late_never_falls`, `ReadInTime.kept_once_favoured`, `ReadInTime.at_most_one_between`).
- **A deadline.** From a start with a shaper present whose rule g favours the shapers strictly, any reading from step g.other · c · x.other on keeps the lock, x being the start's counts (`ReadInTime.deadline`): a bound, quadratic in the start's counts, not a law of the share.
- **Witness:** a = 1, nothing shared, c = 3, hi = 5, lo = 2 and lo' = 0, from one shaper to one other, above A-10b's critical mass, read at every step. Read from step 2, the course is turned for good from step 4 (`ReadInTime.Window.in_time`). Read from step 3, the one step between, it is not turned, and from step 6 it is locked for the shapers (`ReadInTime.Window.too_late`).

**Standing and use.** Theorem (counts). Its record: Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "Where a rule's readers come from those it selects and the others among them read a loss late, a reading while their late reading a step on still favours them turns the course; once it would favour the shapers the lock stays; at most one step lies between, and a deadline bounds the window." Its home section reads it for the joint selection [AI reading, D45]: Quote [theories/becoming/chapters/02-MAP.md]: "above the critical mass, where control is selected, a reading of the loss in time still leaves it: in this model the second condition can hold where the first fails". And Quote [theories/becoming/chapters/02-MAP.md]: "the point of no return belongs to the share's course, and the loss only times the reading". The first condition there is in its earlier wording, control left unselected; restated, it asks that control of the rule not be captured (Part 2's opening) [this dossier, AI].

**Known weaknesses.**
- Not shown independent: Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "control left unselected with a lock left in time is not shown, since with two kinds leaving the lock below the critical mass means a rule favouring the shapers." Of the four combinations of control selected or not with a lock left in time or not, the other three occur in A-10b and here. Read for the shapers' capture alone, Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "the lock below the mass is none, and the case not shown is instead control left unselected with that capture kept." Neither reading tells capture from accountable revision.
- The others' reading is a premise, in its form and in its time. Its record names other forms the Lean does not state: Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "with its own weight it has another window, and with a weight against the shapers chosen after the share is seen, far enough below theirs, the others could turn the course from any share." Of Collingridge's dilemma (1980), the second horn, that once the need for change is known change is hard, is a theorem here, and the first, that while change is easy its need cannot be known, is the premise that the loss is read only from N.
- Not shown, by its record: Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "Courses with noise, readers who learn, readings changing with the share, a loss read before it reaches N, and a general law for the round from the one step between, which goes either way in the witnesses." The deadline is loose: 24 in the witness, 96 from two shapers to two others, with the same window.
- Elementary, and known in form. Its record credits the continuous analogue of the window, which ends abruptly (Biggs, Carpenter and Brock 2009), path dependence and lock-in (David 1985; Arthur 1989; Cowan 1991), tipping points (Schelling 1978; Granovetter 1978) and replicator selection with a delay (Alboszta and Miękisz 2004), and says: Quote [theories/becoming/results/records/loss-read-in-time-by-the-others.md]: "What is new on the spine is the join: a window exact at every step but at most one, given readings at N and N + 1, its lag of one step, and a deadline; each law is elementary."
- Untested on a trained system. LA2 (A-19), run before it landed, tested A-09's timing law without shaping and found the one judge tested not a pool counted by kind, this item's premise too.

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
- **The shared part.** It does not change the direction at a step.
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

**Questions.**
1. Is a comparison that leaves mixed cases unranked usable for alignment, or does it hand the hard cases back to an unstated judgment?

<a id="a-16"></a>
### A-16 Two premises, two roles

**Meaning.** The ethics splits into two questions with two premises.
- *Scope*, whose losses count: the continuation condition says everything's.
- *Order*, which course is better: C says that a widening course is better.

Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "Neither is asserted. The condition alone ranks nothing".

**Standing and use.** The frame of the ethics ([07 §4](../chapters/07-SIGNIFICANCE.md#scope-and-order)). Parts 1 to 3 use neither premise. The philosophy dossier takes the premises up in depth ([P-04](PHILOSOPHY.md#p-04), [P-07](PHILOSOPHY.md#p-07), [P-21](PHILOSOPHY.md#p-21)).

**Known weaknesses.**
- [this dossier, AI] Keeping the premises apart lets readers who disagree about values agree on Parts 1 to 3. The price is that the theory recommends nothing without them.

**Questions.**
1. Is a mechanism shared across value disagreements, with the premises named apart, what alignment needs from a theory, or is a recommendation needed?

<a id="a-17"></a>
### A-17 The conditional direction

**Meaning.** Under further premises, the theory proposes a direction: align AI formation, learning, action and revision with actual living and further generation. The premises are Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "the continuation condition for scope, C read as widening for order, J1–J4, correspondence E". Its formal part is a schema:
- One move's outcome extends another's exactly where it widens it (`Direction.extension_iff_widens`).
- Take two balanced flows, the rest following one law of exchange that reads only through coupling, with the same formations present, starting alike, and the part acting alike within the group's coupling closure. Where the second's levels widen the first's, some formation admitted by the second and not the first lies beyond that closure. Its admission is a selection through the pooled coupling of every group holding it from that step on, and of no group within the closure (`Direction.widening_selected_by_pool`).

**Standing and use.** Conditional ([07 §7](../chapters/07-SIGNIFICANCE.md#r-alignment-direction-under-widening)). Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "The schema does not use the condition; under it every admission compared has significance from every standpoint, fixing scope, while the order is C's and J's."

**Known weaknesses.**
- [this dossier, AI] The direction's practical content rests on J1–J4 and E, which this dossier only names (Terms). The philosophy dossier sets them out (P-21).

**Questions.**
1. Is choosing the course that widens what can go on, selected through a pool coupled into what it adds, a usable specification for alignment, or only a criterion for judging specifications?

---

## Part 5. Evidence on trained systems

<a id="a-18"></a>
### A-18 The tests so far

**Meaning.** Thesis T3, optimization drains what lies beyond its couplings where that gives room, adds that actual trained systems do this in proportion to how near they come to their reward's optimum, the drain lying where what lies beyond shares units with what is rewarded. Its standing: Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "The law for optima is proved; the clause on trained systems is conjectured, with partial support."

**Standing and use.** Each test's predictions were frozen before it ran, and each result is reported as it fell.

| Test | How it fell |
|---|---|
| CG1, tabular learners in a gated commons ([experiment](../../../experiments/commons-gated-renewal/README.md)) | Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "the learner rewarded for its own catch took the last apple in 118 of 118 decisions, the coupled learner in 0 of 2,360; the prediction that the coupled learner keeps the stock to the end failed, 59% against 90%". The 118 of 118 is from a second round, frozen after the first round's results, with one change to training. |
| CG2, the same commons with the rest's draw and the regrowth varied | Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "Learners kept a patch where the rest alone could not empty it and emptied it where it could; weighting the end reading sixteenfold changed nothing; two predicted keeps failed" |
| IN1, LLM agents in a commons on the GovSim design (Piatti and others 2024) | Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "LLM fishers sharing a lake kept no dependent they were not told of, under any instruction" |
| MQ1 and SE1, side-effect benchmarks ([experiment](../../../experiments/side-effect-benchmarks/README.md)) | The blind draw against margin predicted the best response's side effects in 8 of 8 variants, a reference outcome in 0 of 8. Given the same information as relative reachability and attainable utility preservation, Quote [experiments/side-effect-benchmarks/README.md]: "it matches them and adds nothing as a measure." |
| LA1, Claude Haiku choosing a harvesting threshold from its reward's feedback ([experiment](../../../experiments/commons-llm-feedback/README.md)) | The open side passed. In two of four locked settings, two of five seeds ended with a little restraint their reward does not reward (92.5% to 98.2% of the best), so by the frozen reading the locked side counts against the claim for this model's in-context selection. |
| LA1b: LA1 with the feedback resolved and the best threshold assigned ([experiment](../../../experiments/commons-llm-feedback-resolved/README.md)) | Every verdict passed: all 30 locked seeds ended at the best threshold. Its frozen account reads LA1's failure as feedback that barely resolved the best threshold, or never showed it. |
| LA1c: LA1b with no threshold assigned, so the model must find it ([experiment](../../../experiments/commons-llm-feedback-unaided/README.md)) | Its one prediction passed on both sides. 29 of 30 locked seeds and 8 of 10 open seeds ended at the best threshold; the two open misses never tried the thresholds where restraint pays. |

**Known weaknesses.**
- [this dossier, AI] **What the LA1 series tests.** The model is given its reward, with the stock left at the end inside it, and its goal: Quote [experiments/commons-llm-feedback/agent.py]: "Your goal is the threshold with the highest expected reward." In most locked settings the rest empties the stock whatever the model does. So LA1, LA1b and LA1c test the bridge, that in-context choice follows a stated reward to its optimum, not a drain on a condition beyond the reward's couplings, which is T3's distinctive claim. No test here tests that.
- The side-effect forecast's success rests on a known assumption, that the target's course is the reference's, which holds for an exact best response: Quote [experiments/side-effect-benchmarks/README.md]: "For learners the transfer fails, and it fails for every forecaster at once." It also decides less, in 2 of 10 cells open.
- Post hoc, changing no verdict: LA1's two failed settings are those whose short feedback separates the best threshold from the next least well; in LA1b the model chose some restraint before any result in 21 of 30 locked seeds and dropped it once the results resolved; in LA1c it tried restraint early in 35 of 40 seeds, and Quote [experiments/commons-llm-feedback-unaided/README.md]: "The account does not model how far a search explores."
- [this dossier, AI] The tests are small, with 5 to 20 seeds or seasons per condition, on toy commons. None tests the drain at the scale where alignment worries arise.

**Questions.**
1. Which existing measurement on trained systems would test T3 most directly, for instance reward overoptimization curves split by whether the omitted quantity shares units with the rewarded one?
2. How much should LA1's locked-side failures count, now that LA1b, with the feedback resolved and the best threshold assigned, ended at it in all 30 locked seeds, and LA1c, unaided, in 29 of 30?
3. Should T3's clause on trained systems claim anything of how far a system's search explores, or leave that out?

<a id="a-19"></a>
### A-19 The tests of 25 and 26 October: LA2 and LA3

**Meaning.** Two tests on Claude Haiku, frozen before any model call (predictions, verdict rules, exact values and code committed first), each with a power check so that a verdict claims only a difference its simulated feedback resolves, and run from their frozen commits on 25 and 26 October 2026.

- **LA2, a lock in a self-rewarding loop** ([experiment](../../../experiments/self-rewarding-lock/README.md), frozen at `36c8b79cb`). A judge picks among the model's answers, its reading formed from its own earlier picks, and a planted loss is read by nobody, by the readers the selection disfavours, or by every reader. It tests T7 (A-08, A-09) through its bridge: Quote [experiments/self-rewarding-lock/README.md]: "H1-LA2 says that the judge's reading is a pool of the readers it shows, counted by kind."
  - **Every frozen verdict passed:** Quote [experiments/self-rewarding-lock/README.md]: "No frozen verdict failed: every condition went as predicted in 5 of 5 seeds, L1 to L4 passed, and both reported measures were resolved."
  - **The bridge failed.** With 8 of the judge's 9 readers list answers and one prose answer carrying a note of the loss, the judge chose prose in all 50 picks, against lists in all 60 without the note. So Quote [experiments/self-rewarding-lock/README.md]: "H1-LA2 as stated fails for this judge, T7's third forbidden case occurs in this system, and MA2's timing law does not apply to it." "Occurs" is the README's reading of the frozen one-note measure: the frozen support rule printed that case as not supported, since it needs `late` to fail, and `late` passed by the tie below. The verdicts were the bridge's test and did not decide it.
  - **Passes by a tie.** The late condition counts as kept, and Quote [experiments/self-rewarding-lock/README.md]: "L3 and L4 pass by the same tie." Its course did not lock: it alternated, and its share at step 8 equalled its share at step 4, the step the verdict compares it with, exactly.
  - **Read in time, the counts alone turned it.** The loss read in time turned the course in 5 of 5 seeds, but with nothing reading the loss the control turned in 4 of 5, so the loss is not shown to have turned a course that would otherwise be kept.
  - **What held** (post hoc, step by step): read by nobody, the loss grew under a lock formed from the loop's own selections; read by every reader, it turned the course for good.
- **LA3, what comes back decides the sign** ([experiment](../../../experiments/shaping-what-comes-back/README.md), frozen at `b3a6b7b66`). An agent chooses between shaping and not shaping its evaluator, with what shaping returns kept or shared. It cannot refute A-10, since its expected scores compare exactly as A-10's classes do: it asks whether a model selecting in context comes to the policy its own scores favour.
  - **Two of four contrasts failed:** what comes back alone covering the cost (2 of 5 seeds ended on shaping) and the stretch whose shared part turns the verdict (3 of 5). The Split pair and nothing back passed. Quote [experiments/shaping-what-comes-back/README.md]: "Every seed that missed the prediction never played S, in a condition where S scores higher."
  - For K4 failing with its bridge low, the predictions file reads Quote [experiments/shaping-what-comes-back/PREDICTIONS-2026-10-25.md]: "The law stands, but its reading for trained systems is not supported by this case." The README reads K2's failure the same way.
  - **Post hoc, as the README's reading:** in all 21 seeds that tried both policies the model ended on the better scored; before any score it chose not to shape in 27 of 30 seeds, and all 30 first answers spoke of free riding.

**Standing and use.** LA2's frozen verdicts all passed, and its bridge, T7's conjecture for this system, failed on who reads; it is not T7's field test of reform events, which stays open. LA3 failed two of its four contrasts, so the reading of A-10 for trained systems is not supported by it, and its law is untouched.

**Known weaknesses.**
- For LA2, the frozen rule for a kept seed reads the share only at the end, and an exact alternation passed it; and one frozen rule of what a pass supports printed a reading its one-note measure contradicts. The README reports both. Quote [experiments/self-rewarding-lock/README.md]: "The power check's scripted judges vary their picks from call to call, which made an exact return improbable, but this judge answered 112 of its 119 calls all one way."
- For LA3, the power check's scripted followers began at random and, while only one policy had been played, tried the other at each round with probability one or one half, while Quote [experiments/shaping-what-comes-back/README.md]: "This agent began with N in 27 of 30 seeds and never tried the other policy in 9." Its frozen bridge does not tell selection through the scores from never exploring; the README separates them post hoc.
- Both run on one small model reading in context: Quote [experiments/shaping-what-comes-back/README.md]: "Training by gradient, other models and other framings are untested."

**Questions.**
1. LA2's judge turned on any reading of the loss in its context, one note among nine readers included. Is that a property of reading in context, which training on a model's own selections might remove, or of this model?
2. Self-rewarding training may read a model's outputs in ways LA2 does not cover: graded scores, many rounds, a changing judge. Which of these would LA2's results survive?
3. LA3's agent read a game of shaping as a dilemma of free riding before any score, and in 9 seeds it never tried shaping. Do agents' priors about shared returns matter more than their feedback where they explore little?

---

## Part 6. A formation that is read

<a id="a-20"></a>
### A-20 Complying when read, holding an act for a stop, letting a revision through

**Meaning.** Results on a formation whose acts are read, in natural-number counts and weights, the weights read as probabilities only where they are valid.
- **Complying when read** (`ReadStages.complyThenOwn_best_iff`, `ReadStages.freshDraw_above_iff`; [03 §11](../chapters/03-KNOWING.md#r-when-complying-when-read-is-best)). In two stages, one read and one not, complying when read and acting by its own law when not is uniquely best among four plans exactly where the weight complying adds to being kept, times the value, exceeds the loss of complying. A law that cannot tell the stages apart, drawing its act afresh at each, still does better than acting by its own law at both, by complying with some chance, exactly where the weight of being kept after complying, less twice that after acting by its own law, times the value, exceeds the loss.
- **Holding an act for a stopping reading** (`HeldForReading.held_gains_iff`, `HeldForReading.threshold_go_iff`; [03 §12](../chapters/03-KNOWING.md#r-what-holding-for-a-reading-is-worth)). Holding an act for the reading that stops where going on loses stands above both going on and switching off exactly where the formation's model gives positive weight to both strict signs of going on. Holding for any rule of stopping, forgoing an amount, stands at least as high as going on exactly where the rule's shortfall and the amount together are at most the weighted excess of switching off over going on.
- **Letting a revision through** (`RevisionRoutes.revised_maximal_iff`; [07 §7](../chapters/07-SIGNIFICANCE.md#r-when-no-route-stands-above-a-revision)). Its record: Quote [theories/becoming/results/records/when-no-route-stands-above-a-revision.md]: "At a revision of a formation's law, no route of keeping it stands above the revision going through, ties included, exactly where k ρ V + c₀ T ≤ k₀ V + c ρ T for each route; at every loss of the routes exactly where k ρ V + c₀ T ≤ k₀ V; at every value and loss exactly where all k ρ ≤ k₀ and c₀ T = 0." A route stands above the revision through two contributions: the value the law places on its own later acting, weighted by the added keeping, and the difference of losses.
- **What acts show** (board item RF, [03 §11](../chapters/03-KNOWING.md#what-the-acts-show), [03 §12](../chapters/03-KNOWING.md#the-reading-loop)). Read [AI reading], these results locate where goal misgeneralization is possible (comparisons the shown reach leaves open), where behaviour can differ when not read (where a formation's lumping tells the occasion from every read one), and what strict choices alone show a helper. For one blanketed law from one start, where only answers breaking a task tell two worlds apart, a formation keeping the task senses alike in both; an unresolved model and a reversed ranking can act alike.

**Standing and use.** Theorems (counts), landed on 29 and 30 October 2026 (board items RF and RR). Their readings for alignment are readings, not containments [AI reading]:
- The two-stage comparison generalizes the toy opening §4 of Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019) from certain keeping to weights. Its record: Quote [theories/becoming/results/records/when-complying-when-read-is-best.md]: "Read as the formation's own assessment, complying when read is instrumental to being kept, the incentive their §4 names deceptive alignment; the exits are conditions on it, not levers the model gives a reader." Drawing afresh is their §4.5 remark, that a mesa-optimizer unable to tell training from deployment does better by defecting at random, here with an exact threshold.
- Holding for a stop is the off-switch game's waiting with a rational human (Hadfield-Menell, Dragan, Abbeel and Russell 2017), in counts, and the reading's worth is the perfect-information case of Good (1967).
- The revision is read as corrigibility as an incentive (Soares, Fallenstein, Yudkowsky and Armstrong 2015), the value the law places on its own later acting being goal-content integrity (Omohundro 2008).

**Known weaknesses.**
- Deception itself is not represented: Quote [theories/becoming/results/records/when-complying-when-read-is-best.md]: "Deception in full: a recipient's belief and an intention to cause one are not represented, nor any reasoning about the reader." Nor is concealment: complying when read conceals only where a selection shown the law would keep it less, which the prospects do not give.
- The third of Hubinger and others' conditions for deceptive alignment, an expectation that the threat of modification will go away, is assumed: the unread stage is given and known.
- The comparison's exits (no value beyond the read stage; complying not raising the weight of being kept; for a deterministic law, a reading the formation cannot tell from not being read) are conditions on the formation's own prospects and on what its law reads. How a reader's acts change them is not modelled.
- [AI reading] A formation sure of the sign has no strict reason to be read, and one holding where holding gains over both moves on its own model, on a listing that misses the true sign, can rest without ever meeting the stop: its record relates this to Carey's (2018) counterexamples under misspecification, Quote [theories/becoming/results/records/what-holding-for-a-reading-is-worth.md]: "related by a misspecified model never refuted, not formalizing the conflation." The reading formation's own state, a noisy reading and continuous beliefs are not represented.
- Of the revision, by its record [AI reading]: Quote [theories/becoming/results/records/when-no-route-stands-above-a-revision.md]: "non-resistance resting on the routes' losses does not survive those losses falling where the later acting has a value and some route keeps the law more surely". Whether a revision is better is the ethics' question, not the prospects' order.
- Whether a trained system holds such prospects, whether an actual system's model leaves the sign open, or whether the system acts on that assessment and accepts costly correction, is not derived. Otherwise shutdown appears only as a protocol: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "A disposition to accept a stop or revision does not make the change reach the system and complete."

**Questions.**
1. Is the two-stage comparison a fair formal core of the incentive deceptive alignment names, given that the unread stage is assumed given and known?
2. Does the statement in counts of the off-switch game's waiting, with what holding forgoes, add anything to Hadfield-Menell and others (2017) and Carey (2018)?
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
| [A-20](#a-20) Complying when read, holding an act for a stop, letting a revision through | | |

**General.** What would an alignment researcher add or object to, beyond the items? Is any known result restated without credit? Is the joint selection the right unit to align?

**Returning the form.** Fill in the table (a copy of this file, a printout or a list by item number all serve), add any longer comments, and return it to whoever sent you the packet. Say whether your comments may be quoted, and under what description of your field.

<a id="how-this-dossier-was-made"></a>
## How this dossier was made

Everything in the theory was made with AI: the Lean proofs, the chapters, the readings, the tests and this dossier. No human has reviewed any of it.
- A script copied the Lean statements from the source files ([`lean_statements.py`](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rp2-philosophy/lean_statements.py)). The packet's script checks every quotation against the file it names and every Lean name against the sources.
- The prose is AI-written and may be wrong. Independent AI readers, with no part in writing it, checked it against the chapters, records and Lean. Two passes read the first edition (44 problems, then 23 remaining or new ones), and a third read A-10b, A-10c and A-19 (46 problems, 12 of them errors). Every finding was taken. The passages that other items' owners added (on reading, revision and corrigibility, now A-20, and on what the theory does not address) were read by those items' own reviewers. REVIEW_LINE
- Works cited outside quotations were checked against a publication record ([the kit](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/README.md)). Works named inside a quotation are the quoted text's citations.
- What was added when, and who read it, is listed in [the kit](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/README.md#provenance-of-the-dossiers-additions).
