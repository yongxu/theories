# UE12: tasks and what performs them (constructor theory)

27 October 2026. An AI-written design for item 5 of the [UE plan](../ue-unified-explanation/PLAN.md), constructor theory. Claimed on the board on 27 October 2026, after UE11 landed (`e561ca2b5`). Quotations are checked against the text of Deutsch's paper (arXiv:1210.7439v2, revised December 2012) and of Gogioso and others (arXiv:2401.05364v1).

## 1. The question

Constructor theory states the laws of physics as statements about which tasks are possible, which are impossible, and why (Deutsch 2013, arXiv:1210.7439, *Synthese* 190:4331–4359).
- A task is a set of input–output pairs of attributes of a substrate (§1.1).
- A constructor is capable of performing a task if, "whenever it is presented with substrates in a legitimate input state", it transforms them to an output state of that input; it "must invariably produce" it (§1.1). It must be a constructor for the task again after performing it: "Its other attributes may change" (§1.1).
- A task is possible "if the laws of nature impose no limit, short of perfection, on how accurately A could be performed, nor on how well things that are capable of approximately performing it could retain their ability to do so" (§1.1).

Deutsch calls the theory "the ultimate generalisation of the idea of catalysis" (§2.1).

UE10 read the possible on any process: what each configuration admits, and what can be reached. UE11 read the possible relative to what is held. A constructor is a held part: a class of configurations of one part, in that class again after the performance. This design asks three things:
- whether constructor theory's possible is the theory's possible relative to a held part;
- which of constructor theory's principles become theorems under a named premise;
- what the reading forbids that constructor theory leaves open.

## 2. The reading

- **Configurations and the division.** A process on configurations `S`, with readings `part : S → C` (the performing part) and `sub : S → X` (the substrate). Everything the two readings leave out is environment, and a performance must succeed in every environment. The division into performer and substrate is an analytic distinction, stated with each claim: which tasks are possible depends on it (T5).
- **A task.** A relation on `X`: its domain gives the legitimate inputs, and each input's related states are its outputs.
- **What performs it.** A class `K` of the performing part, *presented* and *delivering*. Presented: some configuration has the part in `K`, and each such state of the part is had with every legitimate input (the constructor can be presented with any input). Delivering: from every configuration with the part in `K` and the substrate a legitimate input, the process reaches one with the part in `K` and the substrate an output of that input. `K` at the end is keeping the ability ("Its other attributes may change"); Gogioso and others (2023) preserve an attribute `P` of the constructor in the same way (their Definition 3.3).
- **Existential delivery.** The process reaches the output: some admissible course delivers it, as the possible is read throughout (UE10). Deutsch's constructor delivers invariably. On a process with one course from each configuration the two agree (to be proved: every course from the presented configuration passes the delivered one); where several courses are admitted, this reading is the weaker.
- **Possible, exact form.** Some class performs it. The limit "short of perfection" is not read: the exact form is a modelling choice. The approximate form, a sequence of performers whose errors go to zero, needs real amounts and is outside.

## 3. Laws to prove

- **T1, held throughout and restored.** A task delivered by moves holding `K` at every step is delivered with `K` at the end. The converse fails on a catalytic cycle: an enzyme binds its substrate, leaving its free form, and is restored when it releases the product.
- **T2, serial composition.** (a) One performer reused: where `K` performs `A` and `B` and every output of `A` is an input of `B` (a regular pair), `K` performs `A` then `B`, with no further premise. Gogioso and others leave reuse of one constructor to future work (their footnotes 2 and 3); in this relational reading it is a theorem. (b) Two performers: where `K` delivers `A` by moves holding the other performing part unchanged, and `L` delivers `B` holding the first, the pair `K × L` delivers `A` then `B`. The premise is UE11's possible relative to a held part.
- **T3, parallel composition.** Where `K` delivers `A` on one substrate by moves holding the other performer and the other substrate, and `L` delivers `B` likewise, the pair delivers `A ⊗ B`. Locality, each component's moves being moves of the composite with the rest unchanged, gives the holding premise, so on the interleaving of two processes possible tasks compose (Gogioso and others' Proposition 3.4, possible tasks for a fixed choice of substrates forming a sub-SMC of Rel, read on processes).
- **T4, the holding premise is needed.** On a coupled witness, `A` is performed by one part and `B` by another, the pair is regular, and `A` then `B` is performed by no class of any reading of any part. Deutsch states the composition principle ("every regular network of possible tasks is a possible task", §1.2) as a conjectured law of physics, and writes that composing particular constructors may be impossible but "this never makes a regular network of possible tasks impossible" (§3.13). On the witness the network is impossible by any means. So the principle is a premise about which processes are the laws, as locality is, and it holds where performances can be had holding what the other uses. A 2026 thesis (Waseem, arXiv:2605.11417) reports a conflict between constructor-theoretic locality and composition in quantum theory.
- **T5, a possible whole of impossible parts, and the division.** Deutsch: "A⊗B may be possible even when neither A nor B is – for instance, when they violate a conservation law by equal and opposite amounts" (§1.2). On two one-unit substrates with the moves passing the unit between them, `A` (raise the first) is performed by no class of any reading of the second substrate, `B` (lower the second) by none of the first, and `A ⊗ B` is possible. With the performing part read as the conserved total, `A` is possible: which tasks are possible depends on the division, which constructor theory takes as given by its substrates.
- **T6, the regress as a theorem.** Deutsch (§3.1, pharaonic tasks): "To avoid an infinite regress, A✓ must imply that every chain of transformations contributing to the construction of CA begins with naturally-occurring constructors and substrates." On a tower of performers, the move `k + 1` changes the performer at level `k` as the one at level `k + 1` allows (UE11's `RuleTower`). On it, every delivery can be had with the performers from some level up held: each chain of constructions is finite and begins with performers it does not construct (`RuleTower.possible_iff_held`). On the tower changing every level at once, a task is performed and no delivery holds any level, so the scheme's premise is what the requirement needs.
- **T7, what can be done grows with what performs.** What can be done to the substrate with the performing part held is UE11's held possible. Along a course it grows only across steps changing the part, keeps widening only where the part changes without end, and does not keep widening where a list holds the whole possible. Read with Deutsch's abstract constructors (§2.14: information that "meets the definition of a constructor more closely than anything else in the situation"), what can be done with the knowledge at hand grows only as that knowledge changes (an AI reading).
- **Later, T8, keeping the ability under loss.** Deutsch: constructors "in the absence of maintenance ... gradually deteriorate" (§1.1). Take a world where every configuration of the performing part decays unless renewed (the turnover premises of the [root foundation](../../ROOT-FOUNDATION.md)). There, a performer keeps its ability only through steps that renew it, which joins constructor theory's constructor to the theory's self-renewing pattern. A candidate for a second step, since it needs the World's loss.

## 4. What it would forbid

- **Composition.** Constructor theory forbids more here: it posits composition as a law. The reading says where composition holds and where it fails, a calibration, not a forbidding.
- **Growth.** Constructor theory is silent here. The reading forbids growth of what can be done with the performers at hand where they stay for good, and keeping widening where a list holds the whole possible (T7).
- **The regress (T6).** Derived rather than posited; its premise is shown needed.
- **The division (T5).** The reading forbids reading a conservation law's impossibility statements without the division they presuppose.

The standing is near-definitional throughout. T2 and T3 restate Gogioso and others' Proposition 3.4 on processes. The regress, growth and division readings need a search before they are called new.

## 5. Neighbours to grade

- Deutsch 2013 (above): tasks, constructors, the possible (§1.1), composition and the composition principle (§1.2), catalysis (§2.1), pharaonic tasks and the regress (§3.1), composing constructors and synchronisation (§3.13), imperfect constructors (§3.14).
- Deutsch and Marletto 2015, *Proc. R. Soc. A* 471:20140540: the constructor theory of information.
- Marletto 2015, *J. R. Soc. Interface* 12:20141226: life under no-design laws.
- Marletto 2016, arXiv:1608.02625: the constructor theory of thermodynamics, with irreversibility as a task possible while its transpose is not.
- Gogioso, Wang-Maścianica, Waseem, Scandolo and Coecke 2023, *Constructor Theory as Process Theory*, EPTCS 397:137–151 (ACT 2023), arXiv:2401.05364. Tasks are relations in Rel; a task is possible when a constructor substrate, an attribute and a task-inducing process exist with the attribute preserved (Definition 3.3); possible tasks for a fixed choice of substrates form a sub-SMC of Rel (Proposition 3.4); reuse of the same constructor, in series or at once, is left to future work (footnotes 2 and 3).
- Waseem 2026, arXiv:2605.11417 (thesis): constructor theory as a process theory, and the conflict between locality and composition in quantum theory.
- Deutsch and Marletto 2025, arXiv:2505.08692, the constructor theory of time: duration and dynamics from timeless laws. This is a neighbour for presence in time, the other half of the plan's deepest gap (§5).
- arXiv:2606.07352 (June 2026), tests of constructor theory.
- von Neumann 1966: the universal constructor. Copying a description, rather than constructing it, avoids the regress.

## 6. Lean

A leaf at L1, importing `Becoming.HeldPossible`. Lean's own word "constructor" names an inductive type's constructors and their injectivity lemmas, and Lean's prelude already has a `Task` (asynchronous computation, `Init/Core.lean`). So a task is a relation on the substrate, with no new type, and the declarations sit in the namespace `Tasks`: `Tasks.Input`, `Tasks.Presented`, `Tasks.Delivers`, `Tasks.Performs`, `Tasks.Possible`, `Tasks.serial`, `Tasks.parallel`, `Tasks.Regular`, `Tasks.Doable`, with the witnesses named by what they do (`Tasks.Catalysis`, `Tasks.Coupled`, `Tasks.Conserved`, `Tasks.FlipTower`). No `Tasks` namespace, `Performs` or task module exists in the package (checked on main `4363708a8`). The module is pure core, with empty axiom reports. T6 and T7 are instances of UE11's laws, so the module states them in the task vocabulary and proves them from HeldPossible.

## 7. Steps

1. Claim UE12 on the board, with its purpose: shared understanding with readers who hold constructor theory as a unifying framework.
2. Build in scratch, with an axiom audit and a closure check.
3. An independent review by a read-only agent, with probes; fold its findings in.
4. Write the note and the landing kit; land through the queue.
