# UE12: tasks and what performs them (note)

AI-written, 27 October 2026, for board item UE12 under [UE](../ue-unified-explanation/PLAN.md), item 5, constructor theory. It follows the [design](DESIGN.md), revised after the [independent review](REVIEW-UE12.md) and its re-check, as §6 says. Where the two differ, this note holds. Above all, what performs a task is restored at the end of each delivery, not held, where the design called it a held part. The design's laws T1–T7 are laws 2–8 here: T1 is law 2, T2 and T3 are laws 3 and 4, T4 is law 5, T5 is law 6, T6 is law 7 and T7 is law 8. Law 9 answers the plan's own question, and §4 supersedes the design's §5 (neighbours). Kit: [`tree/Becoming/Tasks.lean`](tree/Becoming/Tasks.lean). It is pure core, a leaf at L1 on the landed `Becoming.HeldPossible` (UE11).

Marks: **[AI reading]** is an interpretation by the AI, not a theorem.

## 1. The question

Constructor theory states the laws of physics as statements about which tasks are possible, which are impossible, and why (Deutsch 2013, *Synthese* 190:4331–4359, arXiv:1210.7439).
- A task is a set of input–output pairs of attributes of a substrate.
- A constructor for a task, presented with the substrate in any legitimate input state, always produces an output of that input. Afterwards it is still a constructor for the task, though its other attributes may change (§1.1).
- A task is possible where the laws set no limit, short of perfection, on how accurately it can be performed, nor on how well what performs it can keep that ability (§1.1).
- Deutsch presents the theory as the widest generalisation of catalysis (§2.1).
- He conjectures the composition principle as its first law: a regular network of possible tasks is always a possible task (§1.2).

The UE plan's item 5 asks the containment to read tasks as admissions, and to test whether widening is the order that constructor theory's possible tasks carry. [UE10](../ue10-what-can-be-reached/NOTE.md) read the possible on any process, and [UE11](../ue11-where-the-possible-grows/NOTE.md) the possible relative to what is held. The design took a constructor to be a held part, a region of one part's states kept through the performance, and asked four questions:
- is constructor theory's possible the theory's possible relative to a held part?
- which of its principles become theorems, and under which premise?
- what does the reading forbid that constructor theory leaves open?
- is widening the order its possible tasks carry?

**The reading.** Read a process as divided into a performing part and a substrate. A task is a relation on the substrate. A region of the performing part's states performs the task where two things hold: each of its states is had with every legitimate input, and from each such configuration the process reaches an output with the part in the region again. Delivering is having an output possible with the part in the region.

**The first question: no.** What performs is restored at the end of each delivery, not held. Holding the part at every move is sufficient but not needed, as a catalytic cycle shows; on the same cycle a possible task has an impossible transpose. So constructor theory's possible is not the possible relative to a held part. That possible enters elsewhere: as a sufficient premise of composition, and in what can be done with the part held.

**Composition.**
- One region delivering both tasks of a regular pair delivers them in series.
- Two regions together deliver where each delivers by the moves holding what the other uses. That premise is sufficient and not needed.
- Locality gives the premise for deliveries made on their own performer and substrate. On two processes interleaved, tasks possible in each process compose. Within one interleaving on one substrate, a regular pair of possible tasks can have no possible composite.
- Composition fails by any means where a delivery changes what its task does not list. Listed so, the pair is not regular.

**The division.** Which tasks are possible depends on the division. On two substrates passing a unit, constructor theory's pattern for an additive conservation law holds for readings of the other substrate. It fails where the performer is read as an invariant of the process.

**The regress.** On a tower of performers with no top, each delivery is had with the performers from some level up held, and so is each making of a performer from a natural configuration. On a tower changing every level at once, no delivery is.

**Growth.** What can be done with the part held grows only across steps changing the part.

**The order.** A delivery adds nothing to the whole possible, and on a catalytic cycle it narrows it strictly. Widening what can be reached follows deliveries in neither direction. On what a configuration reaches, UE10's lagged order is same-offset widening, which ranks a delivered output above its input on one witness and below it on another, and ranks nothing where no course starts. So deliveries carry the inclusion of the whole possible, not widening.

**[AI reading]** The possible tasks carry reach, along which the whole possible never grows. What grows is the possible relative to what is held, and only where what performs changes.

## 2. The laws

Throughout, a process `P` on configurations `S` is divided by two readings: the performing part, `part : S → C`, and the substrate, `sub : S → X`. What both leave out is environment. A task `T : X → X → Prop` is a relation on the substrate: its legitimate inputs are its domain (`Tasks.Input`), and the outputs of an input are what `T` relates it to. Lean's prelude has its own `Task`, so the module's declarations sit in the namespace `Tasks`, and a task is a relation, with no new type. A region `K : C → Prop` is a predicate on the performing part's states; constructor theory calls it an attribute. Serial composition and the transpose are the grammar's `«而»` and `«逆»`: `«而» T T'` is `T` then `T'`, while constructor theory's `AB` is `B` then `A`.

### Law 1. What performs a task, and the possible

- *Presented and delivering.* A region `K` of the performing part is presented with `T` (`Tasks.Presented`) where some configuration has the part in `K`, and each state of the part in `K` is had with every legitimate input. `K` delivers `T` (`Tasks.Delivers`) where, from every configuration with the part in `K` and the substrate a legitimate input, whatever the environment, the process reaches one with the part in `K` and the substrate an output of that input. `K` performs `T` (`Tasks.Performs`) where both hold, and `T` is possible with the division (`Tasks.Possible`) where some region performs it. The part may leave `K` along the way. In `K` at the end, it can perform the task again.
- *Possible from what is there naturally.* A task is possible from natural configurations (`Tasks.PossibleFrom`) where some region performs it and, from some configuration counted natural, the process reaches one with the part in that region. Such a task is possible (`Tasks.PossibleFrom.possible`); the converse fails. In `Unmade` the present enzyme turns the substrate into the product and nothing makes an enzyme. So the task is possible but not possible from the configurations with no enzyme (`Unmade.performs`, `Unmade.absent_stays`, `Unmade.possible_not_possibleFrom`). Constructor theory counts such a task impossible: a task whose constructor could persist, but could not be built from naturally occurring resources, is impossible (§3.1). What counts as natural is a parameter, as in constructor theory, where it depends partly on local conditions (§3.1).
- *Delivering is having an output possible.* `K` delivers `T` exactly where, from every configuration with the part in `K` and the substrate a legitimate input, some output of that input is possible with the part in `K` (`Tasks.delivers_iff_possible`). This is UE10's possible, with what a configuration admits read as its substrate with the part in `K`.
- *Invariable where the successor is fixed, without halting.* Delivery is existential, as the possible is: some trace delivers. Where the successor is fixed at what a configuration reaches, the grammar's `«定后于»` on the process's steps, every course passing a configuration it reaches passes the end of every trace from there (`Tasks.on_every_run`). So the delivered configuration is reached and lies on every course from the configuration it is delivered from (`Tasks.Delivers.invariably`). A process with at most one next configuration everywhere, the grammar's `«定后»`, gives the premise (`«定后则定后于»`); the proofs need it only where the presented configuration reaches. This is constructor theory's invariable delivery without its halting. Deutsch asks a constructor to give a positive indication that it has finished (§3.13). Without it, he notes, a program that counts for ever would compute every function of its input. The reading admits exactly that:
  - on UE10's climbing process, where every move adds one, every task each of whose inputs has an output at or ahead of it is performed with no performing part, and invariably (`ClimbTask.fixed`, `ClimbTask.performs`, `ClimbTask.invariably`), the tasks taking each count to itself plus an amount among them (`ClimbTask.performs_function`);
  - delivery may take zero moves, so a task relating each of its inputs to itself is performed on every process with a configuration where each of its inputs is had (`Tasks.performs_identity`), on the climbing process too, where every move changes the count (`ClimbTask.moves_change`, `ClimbTask.performs_identity`);
  - a task with no legitimate input is possible on every process with a configuration (`Tasks.possible_of_no_input`).

  The trace may also differ from one presentation to another, where constructor theory keeps what the user does the same (§1.1).

### Law 2. Held throughout, restored at the end

- *Held throughout.* What is delivered by the moves holding any relation is delivered (`Tasks.Delivers.of_heldMoves`, `Tasks.Performs.of_heldMoves`), and so is what is delivered by the moves holding any weaker relation (`Tasks.Delivers.heldMoves_mono`). These are instances of UE11's `Reach.of_heldMoves` and `Reach.heldMoves_mono`. Take the relation "the part in `K` after the move": a task delivered with the part in `K` at every move is delivered with it in `K` at the end.
- *Not conversely: catalysis.* In `Catalysis` a configuration is an enzyme, free or bound, and a molecule, the substrate or the product. The free enzyme binds the substrate, and the bound enzyme releases the product and is free again. The free enzyme performs the task, substrate to product (`Catalysis.reach_product`, `Catalysis.performs`). Held free at every move, or held unchanged, it delivers nothing (`Catalysis.not_held`, `Catalysis.not_held_unchanged`): it performs only by leaving its free form.
- *A possible task with an impossible transpose.* On the same cycle the product stays the product (`Catalysis.product_stays`). So the transpose, product to substrate (`«逆»`), is performed by no region of any reading of a performing part (`Catalysis.transpose_not_possible`). Deutsch notes that in constructor theory nothing stops a possible task, such as turning work wholly into heat, from having an impossible transpose (§2.3).

### Law 3. Composition

- *One region.* Take a regular pair: one region `K` delivers `T` and `T'`, and every output of `T` is a legitimate input of `T'` (`Tasks.Regular`). Then `K` delivers `T` then `T'` (`Tasks.Delivers.serial`). Where `K` performs `T` and delivers `T'`, it performs the composite with no further premise (`Tasks.Performs.serial`).
  - `Regular` is inclusion, as in Deutsch's clause on serial composition (§1.2). His sentence on regular networks can be read as equality; with inclusion the principle claims more.
  - Where `K` delivers `T` on one substrate by the moves holding a second, and `T'` on the second by the moves holding the first, it delivers the two in parallel, one after the other (`Tasks.parallel`, `Tasks.Delivers.parallel_inTurn`).
  - This reuse is of one region of one part, in turn, in the existential reading. One part under two regions need not compose (law 5), and use at once is not read. Gogioso and others leave to future work the reuse of one constructor with an individual identity, in series or at once (their footnotes 2 and 3). The first is answered here only for one region.
- *Two regions.* A task delivered by the moves holding another reading is delivered by the pair region, with the other reading's region kept (`Tasks.Delivers.pair_left`, `Tasks.Delivers.pair_right`). With the other substrate held as well, the same holds (`Tasks.Delivers.pair_left_held`, `Tasks.Delivers.pair_right_held`). This works because a reading the same is a class (`Tasks.sameReading_class`), and what the moves holding it reach keeps it (`Reach.same_of_heldMoves`). Two consequences follow:
  - two regions together deliver a regular pair in series where each delivers by the moves holding the other's part (`Tasks.Delivers.serial_holding`);
  - they deliver two tasks on two substrates in parallel where each delivers by the moves holding the other's part and substrate (`Tasks.Delivers.parallel_holding`).

  Both are the one-region laws at the pair region.
- *Sufficient, not needed.* In `CatalysedSeries` the free enzyme binds at `0`, is released with the count at `1`, and moves the count from `1` to `2`. The first task's only delivery from the free enzyme binds it, so the first premise of `serial_holding` fails (`CatalysedSeries.not_holding`). Yet the trivial part and the free enzyme together perform the first task then the second (`CatalysedSeries.performs_pair`). What the other uses, restored at the end, suffices.
- *Where no performing part is needed.* Read with the performing part trivial, a region performing a task can be taken as every state of the part (`Tasks.Performs.unitPart`), and a regular pair of possible tasks is possible in series (`Tasks.Possible.serial_of_unitPart`). The pair must be regular. In `Unregular`, stepping `0` to `1` and `2` to `3`, the task `0` to `1` or `2` and the task `2` to `3` are each performed with no performing part; the pair is not regular, and the composite is performed by no region of any reading (`Unregular.performs_first`, `Unregular.performs_second`, `Unregular.stays`, `Unregular.not_regular`, `Unregular.composite_not_possible`).

### Law 4. Locality and interleavings

- *Locality gives the premise.*
  - Deutsch takes locality from Einstein: what is done to one system leaves the real situation of another unchanged. He counts it a necessary condition for composing tasks into networks (§3.10).
  - In Deutsch and Marletto's form (2025, §3), the attributes of a composite of two substrates are pairs of their attributes, and a task performed on one substrate only does not change the other's attribute.
  - In that form, locality gives law 3's holding premise for deliveries made by moves on their own performer and substrate.
- *Between processes.*
  - On two processes interleaved (`Tasks.interleave`), each move is a move of one with the other's configuration kept. What each process reaches, the interleaving reaches by the moves holding the other (`Tasks.reach_interleave_left`, `Tasks.reach_interleave_right`, `Tasks.Delivers.interleave_left`, `Tasks.Delivers.interleave_right`).
  - So tasks performed in the two compose in parallel (`Tasks.Presented.interleave`, `Tasks.Performs.parallel_interleave`), and tasks possible in them are possible in parallel in the interleaving (`Tasks.Possible.parallel_interleave`).
  - On two performing parts interleaved on one substrate (`Tasks.interleaveOn`), tasks performed or possible in each compose in series for a regular pair (`Tasks.reach_interleaveOn_left`, `Tasks.reach_interleaveOn_right`, `Tasks.Performs.serial_interleaveOn`, `Tasks.Possible.serial_interleaveOn`).
  - In each case possibility is read in the two processes, not in the interleaving.
- *Within the interleaving on two substrates.* What the interleaving reaches, each process reaches on its own configurations (`Tasks.reach_fst_of_interleave`, `Tasks.reach_snd_of_interleave`). So a task is possible in the interleaving, with a division read off one process, exactly where it is possible in that process, given a configuration of the other (`Tasks.Possible.of_interleave_left`, `Tasks.Possible.of_interleave_right`, and conversely `Tasks.Possible.interleave_left`, `Tasks.Possible.interleave_right`). Tasks possible within the interleaving, with divisions read off each process, are then possible in parallel there (`Tasks.Possible.parallel_within`). This is the composition principle for a parallel pair within the interleaving: `Tasks.Possible.parallel_interleave` read within it, its hypotheses equivalent.
- *Not within one interleaving on one substrate.* In `ResettingInterleaved` an idle part, which never moves, and law 5's resetting process are interleaved on one count. The first task is possible with the idle part's division, because the other part's moves deliver it, and the second task with the other part's division. The pair is regular, and the composite is performed by no region of any reading of a performing part (`ResettingInterleaved.composition_fails_within`). Every move holds the other part, as locality asks. Locality does not tie a task's possibility to the part it is credited to.

### Law 5. Composition is not a law of every process

In `Resetting` a configuration is a second performing part, on or off, and a substrate, a number.
- The substrate at `0` goes to `1` and sets the second part off, whatever it was.
- The substrate at `1` goes to `2` with the second part on, which stays on.

The pair:
- the first task, `0` to `1`, is performed with the performing part trivial (`Resetting.performs_first`);
- the second, `1` to `2`, is performed by the second part on (`Resetting.performs_second`);
- every output of the first is an input of the second (`Resetting.regular`);
- the first then the second is performed by no region of any reading of a performing part (`Resetting.not_possible`), since from the substrate at `0` no course reaches `2` (`Resetting.stays`, `Resetting.not_two`). All four together are `Resetting.composition_fails`.

Every delivery of the first task resets the second part (`Resetting.not_holding`), which the first task does not list. Deutsch asks a task's specification to include all its necessary inputs and unavoidable outputs; a constructor is characterised by its effect with its substrates as a closed system (§1.1). List the second part in each task's states. Then the first task's only output, the second part off with the count at `1`, is not an input of the second task, which needs the part on. So the listed pair is not regular (`Resetting.firstListed`, `Resetting.secondListed`, `Resetting.listed_not_regular`).

One part under two regions need not compose either. The second part performs the first task with every state and the second task when on. The pair is regular, and the composite is performed by no region of that part (`Resetting.performs_first_by_part`, `Resetting.one_part_two_regions`).

Deutsch states the composition principle as a conjectured law (§1.2). He writes that, if it holds, composing particular constructors may fail but never makes a regular network of possible tasks impossible (§3.13). The witness does not contradict that principle, whose tasks list their unavoidable outputs. It shows that this reading's tasks, which may change what they do not list, do not obey it. Read relationally, the closed-system requirement gives law 3's holding premise: each delivery holds what its task does not list. Under that premise the composite is delivered.

### Law 6. A possible whole of impossible parts, and the division

- *The witness.* In `Conserved` two substrates each hold a unit or none, and a move passes the unit from one to the other (`Conserved.process`). With both empty or both full nothing moves, and a unit between them stays between them (`Conserved.empty_stays`, `Conserved.full_stays`, `Conserved.unit_stays`). Deutsch notes that a parallel composite can be possible though neither part is, when the parts break a conservation law by equal and opposite amounts (§1.2). Here raising the first and lowering the second, in parallel, is performed with the performing part trivial (`Conserved.performs_both`).
  - Raising the first is performed by no region of any reading of the second substrate (`Conserved.second_empty_of_raised`, `Conserved.not_raise`), nor of the first (`Conserved.not_raise_alone`).
  - Lowering the second is performed by none of any reading of the first (`Conserved.first_full_of_lowered`, `Conserved.not_lower`), nor of the second (`Conserved.not_lower_alone`).
  - Lowering the first and raising the second are performed by no region of any reading of the substrate changed (`Conserved.not_lower_first_alone`, `Conserved.not_raise_second_alone`). So no reading of a substrate itself raises or lowers it.
  - With the whole, this is `Conserved.whole_of_impossible_parts`. It ranges over readings of the other substrate alone.
- *The additive pattern.* For an additive conservation law Deutsch gives a pattern (§3.4). A task changing the conserved amount is impossible, and so is its transpose. Yet for two tasks changing it by the same amount, the transpose of one in parallel with the other can be possible. On the witness, with each substrate's change performed by readings of the other:
  - raising either substrate and lowering either are impossible (`Conserved.second_full_of_emptied`, `Conserved.not_lower_first`, `Conserved.first_empty_of_raised_second`, `Conserved.not_raise_second`);
  - lowering the first with raising the second is possible, and so is raising the first with lowering the second (`Conserved.performs_lower_raise`);
  - together these are `Conserved.additive_pattern`.
- *The division.* With the performing part read as whether the two together hold one unit (`Conserved.holdsOne`), each of the four single tasks is performed (`Conserved.performs_with_one`, `Conserved.performs_lower_first_with_one`, `Conserved.performs_raise_second_with_one`, `Conserved.performs_lower_second_with_one`).
  - That reading is the two substrates' exclusive or (`Conserved.holdsOne_eq_xor`), and every move keeps it (`Conserved.holdsOne_kept`). With the first substrate it recodes the configuration one to one (`Conserved.holdsOne_recodes`), so it is a reading of the two together, which `whole_of_impossible_parts` does not range over.
  - An invariant of the process, read as the performer, is never consumed.
  - Deutsch's stronger conservation law says that every task changing the overall conserved amount of its substrates is impossible (§2.2). It needs the performer read off the rest of the configuration.
  - The witness is a closed world of two substrates. It has no third system, a reservoir, where Deutsch's reason, the depletion of an outside resource, would show.

### Law 7. The regress

- *Within one delivery.* Take UE11's `RuleTower.process`, a tower of performers with no top. Read the substrate as the tower's state and the performing part as its performers. The move `0` changes the substrate as the performer at level `0` allows, and the move `k + 1` changes the performer at level `k` as the one at level `k + 1` allows. On it, what is reached is reached with the performers from some level up held (`Tasks.tower_reach_held`, UE11's `Reaching.reach_held_of_sequence` at `RuleTower.SameFrom`), so every delivery is had with them held, and conversely (`Tasks.tower_delivers_iff_held`). This is a regress within one performance, finite because a delivery is.
- *Making the performer.* Deutsch's requirement concerns the pharaonic version of a task, which includes constructing the constructor from naturally occurring resources. To avoid an infinite regress, every chain of transformations contributing to that construction must begin with naturally occurring constructors and substrates (§3.1).
  - `Possible` does not read this (law 1); `PossibleFrom` does, relative to which configurations are counted natural.
  - That the chain begins with a natural configuration is `PossibleFrom`, which `Tasks.tower_made_held` takes as its hypothesis. On the tower a performer so made is made with the performers from some level up held, as the natural configuration has them (`Tasks.tower_made_held`): UE11's `RuleTower.possible_iff_held` at the made performer. What it adds is that on the tower the regress the requirement avoids ends at a finite height. A construction is a finite trace, so it constructs only finitely many levels and takes those from that level up as found.
  - The tower leaves out what counts as natural; constructions with several performers or substrates at once, since Deutsch's chains are networks; infinite courses, along which every level can change (UE11's `CopyDown`); and the fixed scheme (`base`, `up`), which is itself never constructed.
- *A tower changing every level at once.* On UE11's `RuleTower.synchronous` with every level flipping at each move, a task is performed and no delivery holds the performers from any level up (`FlipTower.performs`, `FlipTower.not_held`). This is the delivery form of UE11's `Synchronous.tower_law_fails`. It bears on the regress within one delivery. Making the performer (`PossibleFrom`, `Tasks.tower_made_held`) is not touched, since the performer is there from the start.

### Law 8. What can be done with the part held

What can be done with the performing part held is the set of substrate states reached by the moves holding the part unchanged (`Tasks.PossibleWithPartHeld`). It is UE11's `Reaching.PossibleHeld` at the part's sameness and the substrate's reading. Where a task is delivered by those moves, some output of each input is reached with the part held (`Tasks.Delivers.possibleWithPartHeld`). Along a course:
- it grows only across steps changing the part (`Tasks.changes_of_partHeldGrows`);
- nothing is added to it from the step at which the part stays for good (`Tasks.possibleWithPartHeld_of_stays`);
- it keeps widening only where, from every step, some bounded stretch of the course does not keep the part throughout (`Tasks.changes_of_partHeldKeepsWidening`);
- it does not keep widening where a list holds the substrate states reachable from the course's start (`Tasks.not_partHeldKeepsWidening_of_listed`).

These are UE11's held laws read on the performing part (`Run.changes_of_heldGrows`, `Run.possibleHeld_of_stays`, `Run.changes_of_heldKeepsWidening`, `Run.not_heldKeepsWidening_of_listed`): instances, not new results.

### Law 9. The order possible tasks carry

- *A delivery adds nothing to the whole possible.* Take a configuration with the part in `K` and the substrate a legitimate input. From it the process reaches one with an output, and from that one nothing is possible that is not possible from the first (`Tasks.Delivers.adds_nothing`, by UE10's `Reaching.Possible.of_reach`). The theorem also returns that the first covers it with a lag: a configuration covers every configuration a trace from it reaches, with a lag equal to the trace's length (`Reaching.coversLater_of_trace`), extending UE10's `Run.coversLater_next` from one step to reach.
- *Strictly, on the catalytic cycle.* There the substrate is possible from the free enzyme with the substrate, and not from the free enzyme with the product, which the delivery reaches (`Catalysis.narrows`). That every task with an impossible transpose narrows the whole possible strictly is not proved; this witness shows it.
- *Widening follows deliveries in neither direction.*
  - Widening with a lag never ranks what a configuration reaches above it (`Reaching.not_widensWithLag_of_reach`, extending UE10's `Run.not_widensWithLag_next`). So UE10's lagged order, widening or widening with a lag, ranks what a configuration reaches above it exactly where same-offset widening does (`Reaching.widensOrLater_iff_of_reach`, the reach form of UE10's `Run.widensOrLater_next_iff`).
  - Same-offset widening can rank the output above the input. UE10's rising process has every step lead to `true`; on it the task `false` to `true` is performed with the performing part trivial, and its output widens its input at the same offsets, while its input covers it with a lag (`RiseTask.widens`, with UE10's `Rise.rises`).
  - It can rank the input above the output. On the process where every step leads to `false`, read with the same admission (UE10's `Rise.adm`), the task `true` to `false` is performed with the performing part trivial, and its input widens its output at the same offsets (`FallTask.widens_back`).
  - Covering reads infinite runs, and a configuration that starts none is covered by every configuration (UE10's `NoCourse`). On the catalytic cycle no configuration starts a course: every move ends with the enzyme bound to the substrate or free with the product, and nothing moves from the latter (`Catalysis.into`, `Catalysis.stuck`, `Catalysis.no_course`). So every configuration covers every other with every lag there, and UE10's lagged order ranks nothing (`Catalysis.coversLater_all`, `Catalysis.not_widensOrLater`), while the whole possible narrows strictly. The covering conjunct of `Delivers.adds_nothing` holds there of every pair.

So what every delivery carries, from an input to the outputs delivered from it, is the inclusion of the whole possible, from the output into the input. Widening follows deliveries in neither direction: it ranks the output above the input, the input above the output, or neither. What can be done with the part held grows only where the part changes (law 8).

## 3. What it shows, and what it does not

**Shows:**
- What performs a task, read on processes, is a region restored at the end of each delivery, not held: holding throughout is sufficient and not needed (law 2). So constructor theory's possible is not the possible relative to a held part. That possible enters as a sufficient premise of composition (laws 3, 4) and in what can be done with the part held (law 8).
- Which composition laws hold, and where (laws 3–5):
  - one region, in series and in turn;
  - two regions under holding, which is sufficient and not needed;
  - locality's premise on interleavings, with possibility read in each process and within the interleaving on two substrates;
  - failure within one interleaving on one substrate;
  - failure by any means where a delivery changes what its task does not list.
- Constructor theory's own examples as theorems on witnesses, with the possible shown to depend on the division (law 6):
  - catalysis and an impossible transpose (law 2);
  - a whole of impossible parts and the additive pattern (law 6);
  - the regress, within a delivery and in making the performer (law 7).
- The plan's question answered: widening is not the order possible tasks carry (law 9). They carry the inclusion of the whole possible, which a delivery never enlarges, and widening ranks a delivered output above its input, below it, or neither. What can be done with the part held grows only where the performers change (law 8).

**Forbids:**
- a delivery adding to the whole possible, and an output ranked above its input by widening with a lag (law 9);
- growth of what can be done with the part held across a step keeping the part, or after the part stays for good; and its keeping widening along a course on which the part stays from some step on, or where a list holds the substrate states reachable from the start (law 8);
- on a tower of performers each of whose moves keeps the performers from some level up, a delivery, or a making of a performer from a natural configuration, that needs the whole tower (law 7);
- failure of composition between deliveries that hold, or restore, what the other uses (law 3).

**Does not show:**
- the approximate form. Constructor theory's possible is a limit, short of perfection, of constructors whose errors go to zero, and that needs amounts of error;
- that every task with an impossible transpose narrows the whole possible strictly. The catalytic cycle shows it on one witness (law 9);
- invariable delivery where several courses are admitted, and halting and synchronisation (§3.13). Nothing marks where a delivery ends (law 1);
- the composition principle for networks beyond pairs, and the use of one constructor by two tasks at once;
- that the laws fix the division into performing part and substrate. Which tasks are possible depends on it (law 6);
- constructor theory's information (Deutsch and Marletto 2015), its thermodynamics beyond the witnesses (Marletto 2016), or its account of time (Deutsch and Marletto 2025);
- keeping the ability under loss. Deutsch notes that constructors deteriorate without maintenance (§1.1). This is a later step on the World, where every state of the performing part decays unless renewed (the design's T8). Since delivery may take zero moves, an identity task does not read whether a state can be kept against change (law 1). T8 must read that instead.

## 4. Standing and neighbours

Every law is near-definitional or a witness:
- law 1 is the definition read through UE10's possible, and its invariable form is a uniqueness argument on traces;
- law 2 is UE11's `Reach.of_heldMoves` and an invariant;
- law 3 is the concatenation of traces, with the two-region laws its instances at the pair region;
- law 4 is the lifting and projection of traces between a process and an interleaving;
- laws 5 and 6 are witnesses;
- law 7 is UE11's tower law read on deliveries and on making, `tower_made_held` being `RuleTower.possible_iff_held` at the made performer;
- law 8 is UE11's held laws at the part;
- law 9 is UE10's `Reaching.Possible.of_reach` and lagged covering by prefixing, with witnesses.

Many declarations are instances of laws stated elsewhere (the re-check's R8): `Delivers.adds_nothing`, `tower_made_held`, `Possible.parallel_within`, `Possible.serial_of_unitPart`, `Conserved.additive_pattern` and `whole_of_impossible_parts`, the held wrappers of law 2, the laws of law 8, the pair-region laws and `PossibleFrom.possible`. So the count of theorems is not a count of results.

The content is in the reading, the witnesses and the answer to the plan's question. Citations are checked against the texts of Deutsch 2013 (arXiv:1210.7439v2), Gogioso and others 2023 (arXiv:2401.05364v1), Marletto 2016 (arXiv:1608.02625v5) and Deutsch and Marletto 2025 (arXiv:2505.08692v3), on 27 October 2026.

- **Deutsch 2013**, *Constructor theory*.
  - The reading follows its definitions of task, constructor and possible (§1.1), with three named departures. Delivery is existential, invariable only where the successor is fixed, and without halting (law 1). Performance is exact. And `Possible` is not pharaonic, though `PossibleFrom` is (laws 1 and 7).
  - Laws 2 and 5–7 state its examples as theorems or witnesses on processes: catalysis (§2.1), an impossible transpose (§2.3), the composition principle (§1.2, §3.13), equal and opposite amounts (§1.2), the additive pattern (§3.4) and the regress (§3.1).
- **Gogioso, Wang-Maścianica, Waseem, Scandolo and Coecke 2023**, *Constructor theory as process theory*, EPTCS 397:137–151 (ACT 2023).
  - Tasks are relations in Rel. A task is possible where a constructor substrate, an attribute and a task-inducing process exist, with the attribute preserved in every outcome (their Definition 3.3). That is universal, where delivery here is existential.
  - The possible tasks for a fixed choice of substrates form a sub-SMC of Rel (their Proposition 3.4). That holds in a symmetric monoidal category, where `f ⊗ id` holds the other constructor by construction, and identities and swaps are included.
  - Here identities are performed at zero moves (law 1), swaps are not possible in general, and law 4 gives the parallel case on interleavings, for pairs.
  - They leave reuse of one constructor to future work (their footnotes 2 and 3). Law 3 answers it for one region in series and in turn, and law 5 shows that one part under two regions need not compose.
- **Deutsch and Marletto 2025**, *Constructor theory of time*, arXiv:2505.08692. It uses the composition principle and relies on the principle of locality in the form cited in law 4 (§3). Law 4 reads that form as delivery by the moves holding the other, and shows that it does not tie possibility within one interleaving to the part a task is credited to. Its account of duration and dynamics from timeless laws is a neighbour for presence in time, the other half of the UE plan's deepest gap, and is not read here.
- **Waseem 2026**, *String diagrams for quantum foundations, computing and natural language processing* (thesis), arXiv:2605.11417. Its abstract reports a conflict between the constructor-theoretic principles of locality and composition, in quantum physics. That is not the same statement. Laws 3 and 4 derive composition for pairs from a holding premise on processes. Law 4's failure within one interleaving is classical, and locality holds there. The quantum setting is not read.
- **Marletto 2016**, *Constructor theory of thermodynamics*, arXiv:1608.02625. There, the second law requires a task to be possible while the task of the inverse transformation is impossible, read adiabatically, with adiabatic accessibility reformulated. Law 2's impossible transpose and law 9's strict narrowing have that shape on a witness. Adiabatic accessibility is not modelled. In the traditional form the paper starts from, a cyclic device brings the transformation about with a weight's displacement as its only side effect.
- **Not read here:**
  - Deutsch and Marletto 2015, *Proc. R. Soc. A* 471:20140540, the constructor theory of information;
  - Marletto 2015, *J. R. Soc. Interface* 12:20141226, life under no-design laws, the neighbour the design's T8 would take up;
  - Marletto, Deutsch and Vedral 2026, arXiv:2606.07352, tests of constructor theory.
- **von Neumann 1966**, *Theory of self-reproducing automata*: the universal constructor, which avoids a regress by copying its description. Law 7 states the regress for a tower of performers, not the copying.

A short search on 27 October 2026 (two web searches) found no published counterexample to the composition principle, and no statement of law 8 or law 9 for constructor theory. That search is too short to call either new.

## 5. Pure core

- **Counts.** 128 theorems in 167 declarations, every axiom report empty. The build is `scratch_build.py` with the package of main `253ae3dac`; see [scratch-7.log](scratch-7.log) for the module after the re-check, [scratch-6.log](scratch-6.log) for the module the re-check read, and `scratch-1.log` to `scratch-5.log` for the builds before the review. Term proofs only, no tactic blocks.
- **Imports and level.**
  - The module imports `Becoming.HeldPossible` only, which is core. Its closure brings UE10's `Becoming.ReachableRanges` (`Reaching.Possible`, `Reaching.CoversLater`, `Reaching.WidensWithLag`, the `Rise` witness) and the grammar (`«而»`, `«逆»`, `«类»`, `«定后»`, `«定后于»`).
  - No L2 module is in the closure, and the module names no ethical predicate, so it is L1. Nothing imports it: a leaf, because it is a reading of constructor theory that no other module uses yet.
  - Imported with the whole package (`import Becoming`, 335 modules), there are no name clashes ([clash-3.log](clash-3.log) for the module after the re-check, [clash-2.log](clash-2.log) for the one the re-check read, [clash.log](clash.log) before the review).
- **Universes.** Configurations `S : Type u`, acts `A : Type v`, performing parts `C : Type w` and `D : Type w'`, substrates `X Y : Type`. Interleaved processes have `S' : Type u'` and `A' : Type v'`. The tower's state is `Z : Type` and its performers `R : Type v`. The witnesses are at `Bool` and `Nat`.
- **Placement.**
  - Three declarations sit in a namespace of another module's definitions: `Reaching.coversLater_of_trace`, `Reaching.not_widensWithLag_of_reach` and `Reaching.widensOrLater_iff_of_reach`. They are laws of reach and lagged covering on any process, extending UE10's step forms, and belong in `Becoming.ReachableRanges` beside `Run.coversLater_next`. `Tasks.tower_reach_held`, a law of UE11's tower, belongs in `Becoming.HeldPossible` beside `RuleTower.possible_iff_held`. Their owners may move them.
  - `ClimbTask` is built on UE10's `Climb.process`, since a counter of its own would duplicate it and `Becoming.Counting` is a module's name.
  - `Tasks.interleave` is the package's first asynchronous product of processes; `GenerativeCore` has only the synchronous `productProcess`. It belongs beside `productProcess`, at the process layer, once another module needs it.
  - `Tasks.sameReading_class` duplicates `GrammarCourse.sameValue_class` up to orientation. GrammarCourse is outside the import closure. The general fact, that a map's values give a class, belongs at the grammar, where both would follow from it.
- **Modelling.** What the report does not catch lies in the modelling:
  - discrete steps;
  - the division read by two functions on configurations, with the environment what both leave out, and delivery asked from every configuration with the part in the region, whatever the environment;
  - a task as a relation on one substrate type, with its domain the legitimate inputs;
  - delivery existential, invariable only where the successor is fixed at what the presented configuration reaches, with zero-move delivery allowed and no halting;
  - performance exact, with no amount of error;
  - presentation as co-occurrence in the configurations: each state of the part in the region is had with every legitimate input, and who presents is not read;
  - a performing part's reading may be an invariant of the process, and a task need not list what its deliveries change;
  - `Possible` not pharaonic.
- **Lean lessons.**
  - In Lean 4.29.1 `Nat.succ_ne_zero` carries `propext`, so `Nat.noConfusion` is used for `succ = 0`, and after `Nat.succ.inj` for `1 = 2`.
  - `isTrue` and `isFalse` are `Decidable`'s constructors and cannot name pattern variables.
  - Inside `theorem Performs.foo` the namespace `Performs` is open, so a short name can resolve to a theorem there. Stating composition with the grammar's `«而»` removed the clash that a definition named `serial` had with `Performs.serial`.

## 6. The review

The [independent review](REVIEW-UE12.md) read the module at sha256 `d1f01ac7…68f7` (841 lines, 54 theorems, 80 declarations) with 43 probe theorems. It found the Lean correct, and the prose claiming more than the Lean in six places. It made 22 findings, all taken:
- **F1.** The framing is now "restored at the end, not held". Holding is sufficient (`Delivers.of_heldMoves`) and not needed (`Catalysis.not_held`). The board row and the record are corrected at landing.
- **F2.** The interleaving docstrings and the module doc are corrected, and possibility is read in each process. The projection lemmas and `Possible.parallel_within` are added, and so is the failure within one interleaving on one substrate (`ResettingInterleaved`).
- **F3.** `Delivers.invariably` is read as invariable delivery without halting. The modelling choices name zero-move delivery, no halting and the user's part. The counter is a witness (`Counting`, rebuilt on UE10's climbing process as `ClimbTask` after the re-check), and `performs_identity` is added.
- **F4.** `Delivers.invariably` returns the reach.
- **F5.** `Resetting.composition_fails` is read as composition failing where a delivery changes what its task does not list. `Resetting.listed_not_regular` is added, and the module-doc bullet is renamed "Composition is not a law of every process".
- **F6.** `tower_delivers_iff_held` is read as a regress within one delivery. `PossibleFrom` (existential in the natural configurations, as Deutsch §3.1 speaks of resources from which the constructor can be built), `tower_made_held` and `Unmade` are added.
- **F7.** `serial` and `transpose` are dropped for the grammar's `«而»` and `«逆»`, with the order of Deutsch's `AB` noted.
- **F8.** `Resetting.one_part_two_regions` is added, and `Delivers.parallel_reuse` is renamed `Delivers.parallel_inTurn`. What Gogioso and others leave open is stated in law 3 and §4.
- **F9.** `CatalysedSeries` is added. Holding is called sufficient, not needed.
- **F10.** The one-region laws are `Delivers.serial`, `Performs.serial` and `Delivers.parallel_inTurn`. `serial_holding` and `parallel_holding` are derived as their instances at the pair region (`Delivers.pair_left`, `pair_right`, `pair_left_held`, `pair_right_held`).
- **F11.** `Conserved.one` is renamed `holdsOne`, and `possible_with_one` is renamed `performs_with_one`. `holdsOne_eq_xor` and `holdsOne_kept` are added, and the docstring follows the review; the one-to-one recoding it stated was proved after the re-check (`holdsOne_recodes`).
- **F12.** `not_lower_alone`, `not_lower_first` and `performs_lower_raise` are added, and `whole_of_impossible_parts` says it ranges over readings of the other substrate alone. Beyond the review, `not_raise_second` and `additive_pattern` complete Deutsch's §3.4 pattern on the witness.
- **F13.** "Class" is replaced by "region" throughout, and constructor theory's "attribute" is named once.
- **F14.** `AtHand` is renamed `PossibleWithPartHeld`, with its laws renamed to match. The record counts them, and the held wrappers of law 2, as instances of UE11.
- **F15.** The wording now says the part is not kept throughout.
- **F16.** "Delivers" is used where the Lean is `Delivers`.
- **F17.** `Performs.serial` takes only delivery of the second task.
- **F18–F20.** The placement notes in §5 are added, `Coupled` is renamed `Resetting`, and `FlipTower` cites `Synchronous.tower_law_fails`.
- **F21.** The design gets a pointer to this note. `Regular` says it is inclusion, and "calibration" is not used.
- **F22.** The modelling choices are stated in the module doc and in §5.

The review also listed four declarations cited by the draft note that were absent from the reviewed module: `Delivers.narrows`, `Performs.unitPart`, `Possible.serial_of_unitPart` and `Rising.widens`, now `RiseTask.widens`. They are in the folded module, `Delivers.narrows` renamed `Delivers.adds_nothing` after the re-check.

The folded module, sha256 `fbccc794…34da` (1509 lines, 104 theorems, 138 declarations), was re-checked by a second independent, read-only reader ([RECHECK-UE12.md](RECHECK-UE12.md)), with 43 probe theorems of its own ([probes2/](probes2/)). It found every proof correct with an empty axiom report and every module part of F1–F22 taken, and eight findings in what the module says, all taken:
- **R1.** The answer to the plan's question read only widening with a lag. Added: `Reaching.widensOrLater_iff_of_reach` (on what a configuration reaches, UE10's lagged order is same-offset widening), `FallTask` (same-offset widening ranks a delivered input above its output), and on the catalytic cycle `Catalysis.into`, `Catalysis.stuck`, `Catalysis.no_course`, `Catalysis.coversLater_all` and `Catalysis.not_widensOrLater` (covering ranks nothing where no course starts). `Delivers.narrows` drops its third conjunct, which followed from the second, and is renamed `Delivers.adds_nothing`, since it states an inclusion. Law 9 and the module doc now say that deliveries carry the inclusion of the whole possible, not widening. This note's earlier sentence that the lagged order never rises along a delivery was wrong for UE10's lagged order; it held only of widening with a lag.
- **R2.** `tower_made_held` was read as the requirement it assumes. Its hypothesis `PossibleFrom` reads the requirement; the theorem is UE11's `RuleTower.possible_iff_held` at the made performer, and now states that the performers from the held level up are as the natural configuration has them. `tower_reach_held` factors out the reach lemma both tower laws used.
- **R3.** Three module-doc sentences dropped a condition. The identity task needs each input had, and serial composition needs the regular pair, with no performing part and on one substrate interleaved. The witness `Unregular` shows the pair must be regular.
- **R4.** Invariable delivery is stated on the grammar's fixed successor: `Delivers.invariably` takes `«定后于» (Steps P) s`, which the proofs need only at what the presented configuration reaches.
- **R5.** The one-to-one recoding is proved (`Conserved.holdsOne_recodes`). The two missing single-substrate impossibilities (`Conserved.not_lower_first_alone`, `Conserved.not_raise_second_alone`) and the invariant performing the three other single tasks are added.
- **R6.** The counter, UE10's `Climb.process` under another name, is rebuilt on it as `ClimbTask`, for every task each of whose inputs has an output at or ahead of it.
- **R7, R8.** The placement of laws in UE10's and UE11's namespaces, and the declarations that are instances of laws stated elsewhere, are noted in §4 and §5 and in the record.

The re-check also answered five questions. `Possible.parallel_within` is exact. The existential `PossibleFrom` is what Deutsch §3.1 asks; the universal form asks more. `additive_pattern` reads §3.4 faithfully, relative to the division. Naming is clean apart from `Counting`. And the order is R1. Beyond the findings, `Catalysis.not_held_unchanged` states the cycle's failure for holding the enzyme unchanged, which a probe of the re-check showed, and `Possible.interleave_left` and `Possible.interleave_right` make the projections' converses theorems. The module after the re-check, sha256 `706db12b…90af` (1801 lines), has 128 theorems in 167 declarations, every axiom report empty ([scratch-7.log](scratch-7.log)), with no name clash in the whole package ([clash-3.log](clash-3.log)). No independent reader has read it since. Its changes are those listed above, each taken from the re-check's proposed Lean or text, or built from its probes.

## 7. Landing

- **Module.** `Becoming.Tasks` joins the core as a leaf at L1.
- **Record.** `tasks-and-what-performs-them`, homed in 07 §2 directly after where the possible grows, whose possible relative to a held part it places: sufficient, not needed. Base: any process (frame), and witnesses. Standing: near-definitional laws and witnesses. Many laws are counted as instances of UE10's and UE11's (§4). The placement notes of §5 go in its boundary.
- **07 §2.** The home section, with a labelled reading [AI reading, D45].
- **08 §8.** A bullet beyond the table: constructor theory read on processes, with what it adds.
- **The UE plan.** Item 5, and the study section.

## 8. Reading [AI reading, D45]

Constructor theory says what can be done and what cannot, and why. Read on processes, what performs a task is what each delivery restores, not what it holds: a catalyst leaves its form and returns to it.

The possible tasks carry reach. From an input to the outputs delivered from it, the whole possible never grows, and on the catalytic cycle it narrows for good. Widening what can be reached follows deliveries in neither direction, so it is not the order the possible tasks carry. What grows is what can be done with the performer held, and only across changes of the performer. Keeping it growing needs the performer not to stay for good (UE11). Deutsch reads information as the abstract constructor (§2.14). Read with that, what can be done with the knowledge held grows only as that knowledge changes.

Composition is had where deliveries hold, or restore, what the others use. Locality gives that for deliveries on their own performer and substrate. Where a delivery changes what its task does not list, a regular pair of possible tasks can be impossible by any means. Constructor theory's demand that a task list its unavoidable outputs is what excludes this.

The regress ends where each move keeps the performers from some level up, both within a delivery and in making the performer. A process changing every level at once has deliveries that need the whole tower.
