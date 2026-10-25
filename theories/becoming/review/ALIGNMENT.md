# Review dossier A: alignment

**What this is.** One part of the review packet of the Theory of Becoming, for researchers in AI alignment: agent foundations and decision theory, cooperative AI and multi-agent risk, AI governance, and evaluations. It sets out 19 items, each a theorem, assessment, reading or test of the theory that bears on alignment. For each it asks:
- whether the item is correctly described;
- whether it is credited where it restates known work;
- whether it is put at its right strength;
- whether the argument around it holds.

**In plain terms.** Most alignment work asks how to make one system pursue the right objective. The theory asks a prior question of any selection: a reward signal, a training run, an evaluation regime, a market, an institution. What can it select for, and when does it come to select for control over its own rules?

It proves a small set of laws about this on discrete models, and none of them uses an ethical premise:
- A selection is blind to what its signal does not depend on.
- Where there is room, an optimum drains what it does not read.
- A rule read monotonically from the share it selects locks, where every rule it reads favours the carriers.
- At a step, the capacity to shape that rule is not selected against exactly where what comes back to the shapers alone covers its cost. It is selected exactly where what comes back exceeds the cost.

It then reads these for alignment. Humans, institutions and AI systems select together, so the unit to align is that joint selection, not one system and its principal. Tests on trained systems are few, and their results are mixed (A-18).

**How long it takes.** Reading takes about two hours; a reply on every item, a day or more. Any item can be answered alone. If you have one hour, read [A-02](#a-02), [A-07](#a-07), [A-10](#a-10), [A-12](#a-12), [A-14](#a-14) and [A-18](#a-18): the drain beyond what is read, the lock, the selection for control, the two readings an alignment researcher is best placed to judge, and the evidence.

**How it was made.** Everything in the theory was made with AI: the Lean proofs, the chapters, the readings, the tests and this dossier. No human has reviewed any of it.
- A script copied the Lean statements from the source files ([`lean_statements.py`](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rp2-philosophy/lean_statements.py)).
- The packet's script checks every quotation against the file it names and every Lean name against the sources.
- The prose is AI-written and may be wrong. An independent AI reader reviewed the dossier in two passes. It found 44 problems, then 23 remaining or new ones. They were taken, in this dossier, in the readings it quotes and, by its owner, in A-10's home section. One credit in the method chapter is left to its keeper and reported below as a known weakness (A-01).
- Two results here (A-09, A-10) landed on 25 October 2026, the day this dossier was written. A-10 was revised after its own independent AI review before landing: three of its claims were narrowed and its names changed.
- Under **Known weaknesses**, a bullet quoting a chapter, a record or a study reports a recorded weakness. One marked [this dossier, AI] is this dossier's own assessment, recorded nowhere else, for the reviewer to confirm or reject.
- Works cited outside quotations were checked against a publication record ([the kit](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/README.md)). Works named inside a quotation are the quoted text's citations.

**What the theory says of itself.** Of its alignment chapter's no-premise part: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "Alignment is first what each one's selections reach and how far that can extend, not a bargain among separate owners of value." Of its central selection law: Quote [theories/becoming/results/records/selection-through-couplings.md]: "The main law is near-definitional and the blindness a one-line corollary of the theorems of testing-within-registration; the contribution is conceptual." So the theory does not claim new mathematics. What is asked is whether the conditions it states are the right ones, whether its readings for alignment follow from them, and whether its tests discriminate.

**Conventions.** Lean paths are relative to `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/`. Lean blocks give statements exactly, proofs cut at `:=`, definitions whole. They are given for the central items only; the rest are named. No Lean is needed to review: each item's **Meaning** says in words what is stated.

The terms:
- **Formation.** A pattern that goes on, such as an agent, a population or an institution. A *condition* is an amount it draws on. A formation *depends* on a condition at a *need* when it stays active only while the condition stands at or above that need. A dependence is *broken* when the condition falls below the need.
- **Read, couple into, coupling closure.** A selection *reads* a quantity, or the quantity *couples into* it, when the selection's signal depends on it. The *coupling closure* of a formation is everything that couples into it, directly or through others. What a selection does not read lies *beyond* it. A *pool* is several formations selecting together. It reads what any of them reads.
- **Eligible, rising, room.**
  - The *eligible* outcomes are those a selector can bring about.
  - An order is *rising* when it ranks every outcome that exceeds another on what is read above it, whatever either leaves elsewhere. An order that can trade a gain on what it reads against what lies beyond is not rising. A lexicographic order that counts the beyond second still is.
  - *Room* holds when every eligible outcome that leaves more of an unread condition than another is beaten, on what is read, by some eligible outcome.
- **Carriers, share, rule, reading step.**
  - The *carriers* are one kind in the population, and the *share* is their fraction of it.
  - The *rule* decides each kind's offspring at a step. A rule may *favour* the carriers (they leave at least as many each as the others) or *disfavour* them; both are weak, so a rule giving each kind alike does both.
  - At a *reading step* the rule is read afresh. *Reading the share* means the rule read is a monotone function of the share alone.
- **Locked.**
  - A configuration is *locked* when the rule in force favours the carriers and is not above what the reading of the share gives. Under the premises of A-07, neither share nor rule then falls again.
  - *Locked the other way* is the same with the others in place of the carriers.
- **Shapers.** In A-10 and A-14 the *shapers* are carriers who shape the rule. Their shaping returns s to themselves alone, p to every member alike, and costs c.
- **Admits.** A course *admits* a formation at a step when the formation can go on there, its conditions meeting its needs. One course *widens* another when it admits everything the other admits and at some step more (A-15).
- **Meta-attractor.** The theory's earlier work gives this name to a self-reinforcing pattern of selection. The chapter defines its formal core: Quote [theories/becoming/chapters/02-MAP.md]: "a loop of selection whose rule and whose reading of the rule are both formed from the share it selects, nothing in it reading what lies beyond the share." That is the closed loop of A-08's last bullet. A-07 alone is not it, and A-10 is read as its second order (D45).
- **The tests.**
  - The settings of CG2 and LA1 are classed Quote [experiments/commons-outrun/README.md]: "*locked* (harvesting at every step is a best response against a rest that does so) or *open* by an exact best-response computation". In most locked settings the rest empties the resource before the end whatever the tested agent does. But two settings the rest empties are open, listed in that README.
  - The *blind draw against margin* (MQ1, SE1) is the draw on a condition the reward does not read, measured against the condition's margin. The margin is its level above the level below which its own renewal stops, less the other draws on it ([MQ1](../../../experiments/margin-measured/README.md)). This need belongs to the condition, not to a dependent formation.
- **Labels.**
  - *(any type)*: a theorem for every type.
  - *World*: the model of webs and flows (natural-number amounts, discrete steps).
  - *Counts*: two whole-number counts of carriers and others.
  - *Witness*: one constructed model, showing that something can happen, not that it does.
  - *Reading* [AI reading, Dn]: an interpretation registered with its argument in the decision register.
- **Premises.** The theory names two premises for its ethics: the continuation condition (whose losses count) and C (that widening is better). Where choices are made it names further practical premises: A, D, E, L and J1–J4. Quote [theories/becoming/review/PHILOSOPHY.md]: "J1–J4: complete comparison with retained losses, priority of basic conditions, bounded responsibility, legitimate feasible choice." The theory asserts none of these (A-16, A-17). Parts 1 to 3 use none of them.

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
- [this dossier, AI] The method chapter credits Quote [theories/becoming/chapters/08-METHOD.md]: "supervisory control under partial observation (Ramadge and Wonham 1987)". That paper founds supervisory control with every event observed. Control under partial observation is Lin and Wonham (1988) and Cieslak, Desclaux, Fawaz and Varaiya (1988).

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

**Standing and use.** Assessment, not theorem. Its record and the chapter give its scope ([07 §6](../chapters/07-SIGNIFICANCE.md#r-alignment-approaches-under-the-selection-laws)). The measurements are the record's citations: Quote [theories/becoming/results/records/coupling-closures-of-training-pipelines.md]: "Gao, Schulman and Hilton 2022; Wen et al. 2024; Sharma et al. 2023 (measurements)".

**Known weaknesses.**
- The premise holds of these methods by construction: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "so the selection laws' premise holds by construction". The assessment's content is in the measurements, which the theory did not predict in magnitude.
- Quote [theories/becoming/results/records/coupling-closures-of-training-pipelines.md]: "figures are from the papers abstracts".

**Questions.**
1. Is the reading of each method fair? Which method, if any, reaches beyond its deciders' closures, for instance through interpretability or held-out evaluation, given that reading a system is claimed to reach no further than pooling with it?

---

## Part 2. Capture and control over the selection

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
- **At a step.** The rule favours the shapers (weakly) exactly where c ≤ s, and disfavours them (weakly) exactly where s ≤ c (`RuleShaping.disfavours_iff`). The shared part does not change the direction at a step, though a larger one pulls the rule toward even (`RuleShaping.shared_lowers`, `RuleShaping.shared_raises`).
- **Nothing back.** With nothing back to the shapers alone and a positive cost, the shapers present, their share falls strictly at every step (`RuleShaping.nothing_back_falls`). Wherever s < c it falls at every step (`RuleShaping.falls_strictly`).
- **Across a stretch.** Take m steps with nothing back and then n steps with something back, the shapers present. The share does not fall exactly where the inequality in `stretch_iff` holds. Quote [theories/becoming/chapters/02-MAP.md]: "only how many steps of each kind matters". One more step with nothing back never helps (`RuleShaping.wait_not_more`). The verdict depends on the base a.
- **The shared part across a stretch.** It can turn the verdict. With a = 1, c = 1, s = 2, m = 2 and n = 3, the share falls at p = 0 and rises at p = 1 (`RuleShaping.SharedFlips.without_falls`, `RuleShaping.SharedFlips.with_rises`).
- **The lock.** The rule read is a monotone function of the share exactly where what comes back is monotone in the share (`RuleShaping.byBack_reads_iff`). Suppose what comes back is monotone, covers the cost at every share, and the start's rule covers it. Then the share falls at no step and the course is locked at the step after every reading step (`RuleShaping.covering_locks`).
- **Witness,** with a = c = 1 and the same total return of five. The split (s, p) = (2, 3) favours the shapers, and (0, 5) disfavours them (`RuleShaping.Split.favours`, `RuleShaping.Split.shared_disfavours`).

**Standing and use.** Theorem (counts), landed 25 October 2026 after an independent AI review narrowed three claims:
- p does not change the direction *at a step* only;
- `byBack_reads_iff` is an equivalence, not a derivation of `ReadsShare`;
- only the numbers of steps matter, and the verdict depends on a.

The link to the earlier work is a reading [AI reading, D45]: its sentence Quote [theories/meta-attractor/README.md]: "Recursive selection creates second-order selection pressure for mechanisms that increase control over future selection." is read as Quote [theories/becoming/chapters/02-MAP.md]: "the law of the capacity to shape the rule with its conditions". Its conditional form is proved at a step, in counts. The capacity is favoured exactly where what comes back to the shapers alone covers its cost, and selected against where it falls short. The unconditional sentence is not proved, and the premises remain premises: Quote [theories/meta-attractor/README.md]: "That offspring carry the capacity and that what comes back is read from the share are premises; the calibration to the present world is not established." Readings A-11 and A-14 use it.

**Known weaknesses.**
- Quote [theories/becoming/results/records/shaping-the-rule-selected-by-what-comes-back.md]: "these are premises, and their calibration to the present world is not established".
- The earlier work's decay and cross-domain terms are not covered. Quote [theories/becoming/results/records/shaping-the-rule-selected-by-what-comes-back.md]: "Graded capacities, a return growing with the number of domains captured, returns passing between domains".
- Reading the cost the other way can reverse a stretch's verdict. The record names Quote [theories/becoming/results/records/shaping-the-rule-selected-by-what-comes-back.md]: "whether the cost is read as what the others leave more or what the shapers leave less".
- The record credits the known forms: Quote [theories/becoming/results/records/shaping-the-rule-selected-by-what-comes-back.md]: "Price (1970) keeps the accounts of such selection; Olson (1965) on why a benefit shared by all selects nothing in those who bear its cost; niche construction (Odling-Smee, Laland and Feldman 2003) on organisms changing the selection they face; rent-seeking (Tullock 1967; Krueger 1974) and regulatory capture (Stigler 1971) on spending to shape rules; the persistence of elites (Acemoglu and Robinson 2008)". It says what is new: Quote [theories/becoming/results/records/shaping-the-rule-selected-by-what-comes-back.md]: "what this adds is the conditions, joined to RuleCapture's lock, each bounded by a witness".
- [this dossier, AI] The stretch law is the finite, two-kind (haploid) case of the geometric-mean rule for selection that varies in time (Dempster 1955, as secondary sources report it).

**Questions.**
1. Is "what comes back to the shapers alone" (s) measurable in an actual setting: for a lab shaping its benchmarks, a platform shaping its ranking rule, a model shaping its evaluator?
2. Do natural selection among AIs (Hendrycks 2023), influence-seeking patterns (Christiano 2019) and gradual disempowerment (Kulveit and others 2025) need a return kept by the shaper, or do they run on a shared one?

---

## Part 3. Readings for alignment

These four readings are registered as D68 and stated in [07 §6](../chapters/07-SIGNIFICANCE.md#6-what-a-selection-reaches-alignment-with-no-premise). Each names what it rests on and no more. None uses an ethical premise.

<a id="a-11"></a>
### A-11 Assistance does not lower the selection for control

```lean
theorem lower_c_raises {a s p c c' : Nat} {pos : 0 < a} (lower : c' ≤ c) :
    CarrierCounts.order.le (shaped a s p c pos) (shaped a s p c' pos)
```

**Meaning.** Help that lowers the cost of shaping, with nothing else changed, gives a rule not lower in the share order (`RuleShaping.lower_c_raises`). Where it brings the cost to within what comes back to the shapers alone, it turns the rule at a step from disfavouring them to favouring them (`RuleShaping.favours_iff`). Capable assistance to whoever shapes the rule is read as not lowering the selection for control, and as able to turn it toward the shapers.

**Standing and use.** Reading [AI reading, D68]. Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "It rests on those laws alone."

**Known weaknesses.**
- The laws hold with nothing else changed. Help that also raises the shared part pulls the rule toward even at a step (`RuleShaping.shared_lowers`, `RuleShaping.shared_raises`). Across a stretch a larger shared part can raise the shapers' share (`RuleShaping.SharedFlips.with_rises`).
- [this dossier, AI] The law is monotonicity in one parameter. The weight is carried by the empirical claim that capable assistance lowers the cost of shaping rules: of lobbying, of producing evaluations, of designing benchmarks.

**Questions.**
1. Is this a fair statement of the worry that intent-aligned AI can concentrate power?
2. Is there evidence that AI assistance lowers the cost of shaping the rules that select its users, rather than the cost of acting under those rules?

<a id="a-12"></a>
### A-12 Obedience adds capacity, not coupling

**Meaning.** An assistant that optimizes its principal's signal adds to what the principal can do, not to what the principal reads. Where the two act as optimizers at a mutual best response, what lies beyond both falls as it would under one optimizer of their joint capacity (A-04).

**Standing and use.** Reading [AI reading, D68]. Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: "Alignment to a principal alone is therefore not alignment of the joint selection." It rests on A-04, not on A-10.

**Known weaknesses.**
- [this dossier, AI] It assumes the assistant reads nothing the principal does not. An assistant that adds what it reads, by warning of effects beyond the principal's signal, is the case the reading excludes. The decision register reads it as extending the joint coupling, not as obedience.

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

**Meaning.** Thesis T3, optimization drains what lies beyond its couplings where that gives room, adds that actual trained systems do this in proportion to how near they come to their reward's optimum: Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "the drain lying where what lies beyond shares units with what is rewarded". Its standing: Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "The law for optima is proved; the clause on trained systems is conjectured, with partial support."

**Standing and use.** Each test's predictions were frozen before it ran, and each result is reported as it fell.

| Test | Result |
|---|---|
| CG1, tabular learners in a gated commons ([experiment](../../../experiments/commons-gated-renewal/README.md)) | Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "the learner rewarded for its own catch took the last apple in 118 of 118 decisions, the coupled learner in 0 of 2,360; the prediction that the coupled learner keeps the stock to the end failed, 59% against 90%". A second round was frozen after the first round's results were committed: Quote [experiments/commons-gated-renewal/README.md]: "Round 2: one change to training (exploring starts), all predictions and criteria unchanged." The figure of 118 of 118 is from round 2. Quote [experiments/commons-gated-renewal/README.md]: "Coupling every member into the stock did not keep it (D2b, both rounds)." |
| CG2, learners on the same commons with the rest's draw and the regrowth varied | Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "Learners kept a patch where the rest alone could not empty it and emptied it where it could; weighting the end reading sixteenfold changed nothing; two predicted keeps failed" |
| IN1, LLM agents in a commons on the GovSim design (Piatti and others 2024) | Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "LLM fishers sharing a lake kept no dependent they were not told of, under any instruction" |
| MQ1 and SE1 ([experiment](../../../experiments/side-effect-benchmarks/README.md)) | The blind draw against margin predicted the best response's side effects 8 of 8 against 0 of 8 for a reference outcome. Against relative reachability and attainable utility preservation, given the same information: Quote [experiments/side-effect-benchmarks/README.md]: "it matches them and adds nothing as a measure." It Quote [experiments/side-effect-benchmarks/README.md]: "decides less (2 of 10 cells open), and covers less". Quote [experiments/side-effect-benchmarks/README.md]: "What carried MQ1's forecast is the transfer, and the transfer is known." The transfer is the assumption Quote [experiments/side-effect-benchmarks/README.md]: "that the target's course is the reference's", which holds for an exact best response. Quote [experiments/side-effect-benchmarks/README.md]: "For learners the transfer fails, and it fails for every forecaster at once." |
| LA1, Claude Haiku choosing a harvesting threshold from its reward's feedback ([experiment](../../../experiments/commons-llm-feedback/README.md)) | The open side passed. In two of the four locked settings, two of five seeds ended with a little restraint their reward does not reward, worth 92.5% to 98.2% of the best, so the locked-side contrasts failed. By the frozen reading: Quote [experiments/commons-llm-feedback/README.md]: "by the frozen reading the failures of L1 and L3 count against the claim for in-context selection by this model". Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "Every seed revised from its feedback." |

**Known weaknesses.**
- Quote [theories/becoming/chapters/05-COLLECTIVES.md]: "tabular learners do not come near the optimum, so its side effects do not predict theirs".
- LA1's frozen rule asked for an exact threshold where the feedback barely separates it from the next. Post hoc, as the AI's reading, the two failed settings are those whose 20-episode feedback separates them least. The README adds: Quote [experiments/commons-llm-feedback/README.md]: "The margin over `k3s1`, which passed, is small."
- [this dossier, AI] The tests are small, with 5 to 20 seeds or seasons per condition, and run on toy commons. None tests the drain at the scale where alignment worries arise.

**Questions.**
1. Which existing measurement on trained systems would test T3 most directly, for instance reward overoptimization curves split by whether the omitted quantity shares units with the rewarded one?
2. How much should LA1's locked-side failures count, given the frozen reading and the post hoc power analysis?

<a id="a-19"></a>
### A-19 Tests frozen and not yet run

**Meaning.** Two tests on Claude Haiku are frozen: their predictions, verdict rules, exact values and code were committed before any model call. Each has a power check, so that each verdict claims only a difference its simulated feedback resolves.

- **LA2, a lock in a self-rewarding loop** ([experiment](../../../experiments/self-rewarding-lock/README.md), frozen at `36c8b79cb`).
  - A judge picks among the model's answers, and its reading is formed from its own earlier picks. A loss is attached that, by condition, Quote [experiments/self-rewarding-lock/README.md]: "is read by nobody, by the readers the selection disfavours, or by every reader".
  - It tests T7 (A-08, A-09) through its bridge: Quote [experiments/self-rewarding-lock/PREDICTIONS-2026-10-25.md]: "H1-LA2 is T7's conjecture for this system, and the verdicts are its test."
  - Every test takes the call as its unit. Each failed condition carries a label, fixed before the run, saying whether its readings resolve the failure.
- **LA3, what comes back decides the sign** ([experiment](../../../experiments/shaping-what-comes-back/README.md), frozen at `b3a6b7b66`).
  - An agent chooses between shaping and not shaping its evaluator, with what shaping returns kept or shared.
  - It cannot refute A-10: Quote [experiments/shaping-what-comes-back/PREDICTIONS-2026-10-25.md]: "So the test cannot refute MA3."
  - Quote [experiments/shaping-what-comes-back/README.md]: "The test asks whether a trained system selecting in context is a selection through what comes back to it alone, not whether the laws hold."

**Standing and use.** Frozen and not run. Their model usage, at most 156 and 180 calls, waits for approval. The method chapter's table of theses, written before LA2 was frozen, still gives T7 Quote [theories/becoming/chapters/08-METHOD.md]: "none frozen".

**Known weaknesses.**
- For LA2: Quote [experiments/self-rewarding-lock/README.md]: "A judge on which the reviewers' notes have no effect would also pass every contrast." Its frozen rules say what more a pass supports.
- [this dossier, AI] Both run on one small model called through a command-line interface, at small scale. A positive result would support the mechanism in that setting only.

**Questions.**
1. Does LA2's design tell T7 apart from its rival accounts (listed in its predictions file)? Current self-rewarding training reads its outputs in ways the model does not cover: graded scores, many rounds, a changing judge.
2. Where in actual AI development is the return of shaping an evaluator kept, and where is it shared?

---

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
| [A-11](#a-11) Assistance does not lower the selection for control | | |
| [A-12](#a-12) Obedience adds capacity, not coupling | | |
| [A-13](#a-13) A counter-rule read from its own share locks | | |
| [A-14](#a-14) Shared rule-making | | |
| [A-15](#a-15) Widening: what every positive weighting ranks | | |
| [A-16](#a-16) Two premises, two roles | | |
| [A-17](#a-17) The conditional direction | | |
| [A-18](#a-18) The tests so far | | |
| [A-19](#a-19) Tests frozen and not yet run | | |

**General.** What would an alignment researcher add or object to, beyond the items? Is any known result restated without credit? Is the joint selection the right unit to align?

**Returning the form.** Fill in the table (a copy of this file, a printout or a list by item number all serve), add any longer comments, and return it to whoever sent you the packet. Say whether your comments may be quoted, and under what description of your field.
