# Review of UE12: `Becoming.Tasks`

27 October 2026. An AI-written independent review of `tree/Becoming/Tasks.lean` (sha256 `d1f01ac7…68f7`, 841 lines) and `DESIGN.md`, read against the package (`Becoming.HeldPossible`, `Becoming.ReachableRanges`, `Becoming.Frame`, `GenerativeCore`, `Becoming.Grammar`), Deutsch 2013 (arXiv:1210.7439v2, extracted text) and Gogioso and others 2023 (arXiv:2401.05364v1, Definition 3.3, Proposition 3.4, footnotes 2–3).

Probes: [`probes/tree/Becoming/TasksProbe.lean`](probes/tree/Becoming/TasksProbe.lean), importing an identical copy of the module. Built with `scratch_build.py`: 43 theorems, 51 declarations, every axiom report empty ([`probes/build-5.log`](probes/build-5.log)). The module itself, built from the same copy (its step restored from the shared cache of a passed run on identical inputs): 54 theorems, 80 declarations, every axiom report empty, as stated.

## Verdict

The Lean is correct. Every one of the 54 proofs and 26 definitions was read and checked (list at the end), and each theorem proves what its statement says. The definitions give a reasonable relational, existential reading of constructor theory. The presentation clause rules out vacuous performers. Requiring the region again at the end of each delivery reproduces Deutsch's battery induction (§1.1), and `Conserved.not_raise` is its one-unit case.

The prose claims more than the Lean in six places, and two of these change what the module says about constructor theory:

- the reading is called "a held part", but the module's own catalytic cycle shows that what performs is restored, not held (F1);
- "Deutsch's composition principle holds there" is false within `interleaveOn`, as a probe shows (F2);
- invariable delivery is said to be "as constructor theory's constructor delivers", but halting is missing (§3.13): a counter performs invariably every task whose outputs lie ahead of its inputs (F3);
- the coupled witness is presented as making the composition principle a premise, but it leaves out an unavoidable output, which Deutsch's tasks must list (F5);
- the tower theorem is read as Deutsch's regress, but it is a regress within one delivery, and `Possible` lacks the pharaonic condition (F6);
- reuse of one constructor is said to be a theorem, but that holds for one region only, and one part under two regions fails (F8).

Two items fall under board rule 9. `serial` and `transpose` are the grammar's `«而»` and `«逆»` by definition (F7). The two-region composition laws are instances of the one-region laws at the pair region (F10). "Class" names a predicate, against the glossary (F13).

**Recommendation:** land after the wording fixes F1–F6, F8, F9, F11 and F13–F16, and after F7. F10 and F12 are cheap and recommended. The rest are optional.

## Findings

### F1. Overclaim, in the central framing: "as a held part"

**Where.** Module doc, lines 6–8; DESIGN §1 ("A constructor is a held part") and §1's first question; the board row ("its possible is the possible relative to a held part").

**What.** `Performs` asks the region `K` only at the end of each delivery (`Delivers`, line 101). The module proves that holding at every move gives delivery (`Delivers.of_heldMoves`). It also proves that the converse fails (`Catalysis.performs`, `Catalysis.not_held`). So the reading's possible is not UE11's possible relative to a held part. The held possible enters only as a sufficient premise (the composition laws) and in `AtHand`. The design's first question is answered by the module: no.

**Fix.** Replace lines 7–8 with:

> This module reads its task and what performs it on any process. What performs a task is a region of a performing part's states that every delivery restores at its end. Holding the part at every move, the possible relative to a held part (`Becoming.HeldPossible`), is sufficient (`Delivers.of_heldMoves`) and not needed (`Catalysis`). It enters as a premise of composition and in what can be done with the part held.

Correct the board row and the record in the same way.

### F2. Wrong as worded (serial), overclaim (parallel): "the composition principle holds there"

**Where.** `Possible.serial_interleaveOn` docstring (line 424–425); `Possible.parallel_interleave` docstring (360–361); module doc lines 44–48 ("Locality gives it … holds there for pairs").

**What.** Both theorems take possibility in the two separate processes `P` and `Q`. They do not take possibility in the interleaving, where the principle would have to hold.

- **Within one interleaving on a shared substrate the principle fails.** Probe `InterleavedCoupled.composition_fails_within` interleaves an idle first part with the coupled process as the second. The first task is possible with the first part's division, because the second part's moves deliver it. The second task is possible with the second part's division. The pair is regular, and no reading performs the composite.
- **On two substrates it does hold within the interleaving**, for divisions read off each process. Probes `reach_interleave_fst/snd`, `possible_of_interleave_left/right` and `possible_parallel_within` show it.
- **Locality gives the premise for the interleaving's own division, not for possibility within it.**
  - Deutsch §3.10 takes locality from Einstein: what is done with one system leaves the other's real situation unchanged. He calls it a necessary condition for composing tasks into networks. In constructor theory he states it as a description of composite states as ordered pairs.
  - Deutsch and Marletto (arXiv:2505.08692, §3, current version, dated June 2026) add a clause. In such a description, a task performed on one substrate only cannot change the attribute of the other.
  - In that form, locality does give the holding premise for deliveries made by moves on their own performer and substrate. The interleaving's moves are such moves by construction. So "Locality gives it" is fair for `Performs.serial_interleaveOn` and `Performs.parallel_interleave`, with possibility read in each process.
  - Locality does not tie a task's possibility within the interleaving to the part it is credited to, because `Possible` there reads every move, whichever part makes it. In the probe, the first task is credited to the idle part but delivered by the second part's moves, and those moves reset the second part. Yet every move holds the other part, as locality asks.
  - The design cites a 2026 thesis (arXiv:2605.11417) whose abstract reports a conflict between the locality and composition principles in quantum physics.

**Fix.** Replace the `Possible.serial_interleaveOn` docstring with:

> **Tasks possible with two parts, each in its own process on one substrate, are possible in series in their interleaving.** Where `T` is possible in the first process and `T'` in the second, and every output of `T` is an input of `T'`, the two parts together perform `T` then `T'`. Possibility is read in the two processes, not in the interleaving. Within one interleaving, a task can be possible with one part's division through the other part's moves, and there a regular pair of possible tasks can have no possible composite.

Replace the `Possible.parallel_interleave` docstring with:

> **Tasks possible in two processes are possible in parallel in their interleaving**, each task's division read off its own process.

If the probe's three projection lemmas are added (about 30 lines), the parallel docstring may add: "since a move of either keeps the other's configuration, this is the composition principle for a parallel pair within the interleaving, for divisions read off each process."

In the module doc, replace "Locality gives it: … holds there for pairs (…)" with:

> Locality gives it for deliveries made on their own performer and substrate. In Deutsch and Marletto's form (arXiv:2505.08692, §3), a task performed on one substrate only cannot change the attribute of another. Two processes interleaved, on one substrate (`interleaveOn`) or on two (`interleave`), are such a case: no move changes both, so each one's moves hold the other's part. Tasks performed in the two processes then compose (`Performs.serial_interleaveOn`, `Performs.parallel_interleave`), and so do tasks possible in them (`Possible.serial_interleaveOn`, `Possible.parallel_interleave`). Possibility is read in each process. Within one interleaving, a task can be possible with one part's division through the other part's moves, and there a regular pair of possible tasks can have no possible composite.

Apply the same correction to DESIGN T3.

### F3. Overclaim and missing: invariable delivery without halting

**Where.** `Delivers.invariably` docstring (144–146); module doc "Modelling choices" (22–26).

**What.** The module says that where each configuration has one next configuration, a delivery is invariable "as constructor theory's constructor delivers". Deutsch §3.13 asks more of a constructor:

- it gives a positive indication that it has finished (halting);
- it delivers its outputs together;
- an output that changes after being reached is spoiled.

Without halting, he notes, a program that ignores its input and counts forever would count as computing every integer function of its input. That is what the reading admits:

- **Counting.** Probe `Counter.performs` and `Counter.invariably`: on the deterministic counter, every task `x ↦ x + g x` is performed with no performing part, and invariably in `Delivers.invariably`'s own sense.
- **Zero moves.** Delivery may take zero moves. Probe `performs_identity` shows that every task relating each of its inputs to itself is performed on every process. `Counter.performs_identity` with `Counter.moves_change` shows this even where every move changes the substrate. So whether a state can be kept against change is not read. That bears directly on the planned T8 (keeping the ability under loss).
- **Same user action.** Deutsch §1.1 asks that what the user must do stay the same from run to run. The existential course may differ from one presentation to the next.

**Fix.** Replace the docstring with:

> **Where each configuration has at most one next configuration, the delivered configuration lies on every course from the presented one.** This is constructor theory's invariable delivery without its halting. Nothing marks where a delivery ends, so on a counter every task taking each count to a count ahead of it is delivered invariably, which constructor theory excludes by asking a constructor to signal that it is done (Deutsch §3.13).

Add to "Modelling choices":

> Delivery is passing an output. It may take zero moves, so a task relating each input to itself is performed on every process, and nothing marks where it ends: constructor theory's halting (§3.13) is not read. The course may differ from one presentation to another, where constructor theory keeps the user's part the same (§1.1).

Optionally add the counter as a witness; the Lean is in the probe.

### F4. Unclear: `Delivers.invariably` does not say the configuration is reached

**Where.** `Delivers.invariably`, conclusion at line 149.

**What.** The conclusion `∃ t, K (part t) ∧ T (sub s) (sub t) ∧ ∀ r, r.state 0 = s → ∃ n, r.state n = t` omits `Reach P s t`. Where no course starts at `s`, "every course passes `t`" holds vacuously, so the statement holds of a configuration never reached. Probe `Stuck.conclusion_without_reach` exhibits this on a process with no moves, where the task is not delivered. The docstring's "the delivered configuration" is therefore more than the statement says.

**Fix.** Return the reach. The proof is unchanged (probe `invariably_reached`):

```lean
∃ t, Reach P s t ∧ K (part t) ∧ T (sub s) (sub t) ∧ ∀ r : Run P, r.state 0 = s → ∃ n, r.state n = t
```

### F5. Overclaim: the coupled witness does not calibrate Deutsch's principle as he states it

**Where.** `Coupled.composition_fails` docstring (658–662); module doc bullet "The premise is needed" (49–53); DESIGN T4.

**What.** The Lean is right. On this process the composite is impossible by any means. But the first task, stated on the count alone, has every delivery reset the second part (`not_holding`), and the task does not list that change.

- **Deutsch's tasks must list it.** Deutsch §1.1 asks a task's specification to include all necessary inputs and unavoidable outputs, and characterises a constructor by its effect as a closed system with its substrates. Listed so, the first task's only output (second part off, count 1) is not an input of the second task with the part it needs (on, count 1). The pair is then not regular.
- **The principle is conjectured.** Deutsch states the principle as a conjectured law (§1.2), and §3.13's remark is conditional on it.
- **So the witness shows something about the reading.** It shows that this reading's tasks, which may change what they do not list, do not obey the principle. It does not contradict or calibrate the principle.
- **Read relationally, the closed-system requirement is the holding premise.** That premise is "each delivery holds what its task does not list", under which the composite is delivered (`Delivers.serial_holding`). This is more informative than "a premise about the process".

**Fix.** Replace the `composition_fails` docstring with:

> **Composition fails where a delivery changes what its task does not list.** The first task is performed with a trivial performing part and the second by the second part on. Every output of the first is an input of the second. The first then the second is performed by no region of any reading of a performing part, because every delivery of the first task resets the second part (`not_holding`), which that task does not list. Constructor theory asks a task to list its unavoidable outputs, reading a constructor with its substrates as a closed system (Deutsch §1.1). Listed so, this pair is not regular. Read here as each delivery holding what its task does not list, that requirement is the premise of `Delivers.serial_holding`, under which the composite is delivered.

Rename the module-doc bullet to "**Composition is not a law of every process.**" and adjust its text to match. In DESIGN T4 replace "the holding premise is needed" with "some premise is needed; holding is sufficient (F9)".

### F6. Overclaim: the tower theorem is not Deutsch's regress requirement

**Where.** `tower_delivers_iff_held` docstring (442–446); module doc lines 60–65; DESIGN T6 ("the regress as a theorem", "so the scheme's premise is what the requirement needs").

**What.** Deutsch §3.1's requirement concerns the pharaonic version of a task: constructing the constructor itself from naturally-occurring resources. A task whose constructor would persist if it existed, but cannot be built from such resources, is impossible.

- **`Possible` lacks this condition.** `Presented` asks only that some configuration has the part in the region. Probe `Unmade.possible_unmade` gives a task that is possible although no configuration without the enzyme reaches one with it.
- **The tower theorem is about one delivery.** It says that within a delivery the performers changed are below some level `n`, each changed as the one above allows, and those from `n` up are unchanged. That is a regress within one performance, finite because traces are.
- **What the tower model leaves out:**
  - what "naturally occurring" is;
  - constructions with several performers or substrates at once (Deutsch's chains are networks);
  - infinite courses, along which every level can change (`CopyDown`);
  - the fixed scheme (`base`, `up`) that is itself never constructed.
- **`FlipTower`.** It breaks the module's reading of the requirement, not Deutsch's, which `FlipTower` does not touch: there the performer exists from the start.

**Fix.** Replace the docstring with:

> **On a tower of performers with no top, every delivery is had with the performers from some level up held**, and conversely (`Reaching.reach_held_of_sequence`). The move `k + 1` changes the performer at level `k` as the one at level `k + 1` allows, so within a delivery each performer changed is changed as the one above it allows, and the performers from some level up are not changed: a regress within one performance, finite because a delivery is. Constructor theory's requirement that chains of construction begin with naturally-occurring constructors concerns building the performer itself (the pharaonic task, Deutsch §3.1). `Possible` does not read that: it asks only that some configuration has the part in the region. Read with the substrate the tower's state and the performing part its performers.

Make the same change in the module doc and DESIGN T6 ("so the scheme's premise is what this reading of the requirement needs").

An optional cheap definition, if wanted later: `PossibleFrom P part sub natural T := ∃ K, Performs P part sub K T ∧ ∀ s, natural s → ∃ t, Reach P s t ∧ K (part t)`.

### F7. Naming, board rule 9: `serial` and `transpose` are the grammar's composition and converse

**Where.** `serial` (189) and `transpose` (199); their uses at lines 208, 222, 412, 429, 572, 637, 639, 643 and 666.

**What.** `serial T T'` is by definition `«而» T T'`, the grammar's sequential composition, and `transpose T` is `«逆» T`, its converse (probes `serial_iff_er`, `transpose_iff_ni`, both `Iff.rfl`). `Becoming.Grammar` is already in the import closure. AGENTS.md asks new results to be stated on the grammar where possible. A second definition of each also leaves two names for one relation.

The name `serial` also collides with `Performs.serial`. Inside declarations in namespace `Tasks.Performs`, `serial` resolves to the theorem, which is why lines 412 and 429 must write `Tasks.serial` (the first scratch build failed on it, `scratch-1.log`).

**Fix.** Drop both definitions and state with `«而» T T'` and `«逆» T`. If a task-vocabulary name is wanted, use an `abbrev` defined as the grammar's and say so. In the docstring, note that `«而» T T'` is `T` then `T'`, where Deutsch's `AB` is `B` then `A`.

### F8. Overclaim, in DESIGN T2(a), T3 and §2: what Gogioso and others leave open

**What.**

- **Footnote 2 is about one part, not one region.** It concerns a constructor with an individual identity reused by task B after task A. With an attribute per task, that is one part under two regions. `Performs.serial` covers only one region performing both tasks. One part under two regions does not compose in general. Probe `one_part_two_classes` reads the coupled process with its second part as the performer of both tasks (all its states for the first, on for the second): both are performed, the pair is regular, and the composite is not possible with that part.
- **Footnote 3 is about use at once.** It concerns the same constructor used by two tasks simultaneously. `Delivers.parallel_reuse` uses one region in turn, not at once. Its docstring head "One class reused in parallel" invites the wrong reading.
- **Their definition is universal, this one existential.** Their Definition 3.3 asks the induced relation to give the task, with the attribute preserved in every outcome. Proposition 3.4 holds in a symmetric monoidal category, where `f ⊗ id` holds the other constructor by construction, and the sub-category includes identities and swaps. Here delivery is existential (some course, some output), which makes reuse of one region immediate. Identities are possible at zero moves (F3), and swaps are not possible in general. So "restate Proposition 3.4 on processes" and "preserve an attribute in the same way" are loose.

**Fix.** Write in DESIGN T2(a) and the record:

> Where one region of a part performs both tasks of a regular pair, it performs them in series (`Performs.serial`). One part under two regions need not: the coupled process, read with its second part as the performer of both. Gogioso and others leave reuse of one constructor with an individual identity, in series or at once, to future work. The first is answered here only for one region, in the existential reading; use at once is not read.

Rename the head of `Delivers.parallel_reuse` to "One region delivering two tasks in turn, on two substrates".

### F9. Overclaim: the holding premise is sufficient, not needed

**Where.** Module doc lines 41–44 ("The premise is the possible relative to a held part"); DESIGN T4 heading ("the holding premise is needed").

**What.** Probe `CatalysedSerial`: the first task's only delivery from the free enzyme binds it, so `Delivers.serial_holding`'s first premise fails (`not_holding`). Yet the trivial part and the free enzyme together perform the composite (`performs_pair`), because the enzyme is restored at the end. The module's own catalytic point (F1) applies to composition too. The coupled witness shows only that *some* premise is needed.

**Fix.** Use "where each delivers by the moves holding what the other uses (sufficient, not needed: restoring it at the end suffices, as on the catalytic cycle)". F10 gives the weaker premise its law.

### F10. Missing, board rule 9: one composition law below, the two-region laws as its instances

**Where.** `Performs.serial` (207), `Delivers.serial_holding` (218), `Delivers.parallel_holding` (235), `Delivers.parallel_reuse` (260).

**What.** These are four direct proofs with one shape.

- **Series.** `delivers_inSeries` (one region delivering a regular pair delivers it in series) is the delivery half of `Performs.serial`. `serial_holding` is that law at the pair region, through `delivers_pair_left/right`, which say that delivered by moves holding another reading, a task is delivered by the pair region. Probe: `serial_holding_derived`.
- **Parallel.** `parallel_holding` is `parallel_reuse` at the pair region, through `delivers_pair_left_holding/right_holding`. Probe: `parallel_holding_derived`.
- All of these build with empty reports.

**Fix.** State `Delivers.serial` (one region), derive `Performs.serial` from it, and derive the two-region laws as instances. The direct proofs then go. The premise "the pair region delivers each task" is also the weaker one that F9 needs. Applying F7 first avoids `serial` clashing with `Delivers.serial`.

### F11. Unclear and naming: what `Conserved.one` is

**Where.** `Conserved.one` (686–689); `possible_with_one` (791–800); module doc lines 28–29 and 58–59.

**What.**

- **`one` is the exclusive or of the two substrates** (probe `one_eq_xor`). It is a reading of the first substrate as well as the second. With the first, it recodes the configuration one to one.
- **Every move keeps it** (probe `one_kept`). The "performing part" is an invariant of the whole process, so every region of it is restored by every course and retention costs nothing.
- **So the witness says something more exact than "the division matters".** A reading that is an invariant of the process, read as the performer, is never consumed. That is how Deutsch's stronger conservation law (§2.2: a task changing the overall conserved amount of its substrates is impossible, since the change depletes an outside resource) is lost here.
- **The names mislead.** The theorem is named `possible_with_one` but states `Performs`. The name `one` reads as a number.

**Fix.** Replace the docstring with:

> **The division matters.** With the performing part read as whether the two together hold one unit, raising the first is performed. That reading is their exclusive or. Every move keeps it, and with the first substrate it recodes the configuration one to one. An invariant of the process read as the performer is never consumed. Constructor theory's verdict, that a task changing a substrate's conserved amount is impossible, needs the performer read off the rest of the configuration (`whole_of_impossible_parts`).

Rename `possible_with_one` to `performs_with_one`, and `one` to `holdsOne`. The `one` docstring should read "Whether the two together hold one unit".

### F12. Missing, cheap: what `whole_of_impossible_parts` quantifies over, and two companions

**What.** The witness is a fair reading of Deutsch §1.2: in a closed two-substrate world the performer is read off the rest, and the two tasks change the amount by equal and opposite steps. It leaves out readings of both substrates together (F11 shows these can perform). It also leaves out a third system, a reservoir, where Deutsch's actual reason for impossibility would show: depletion, the battery induction of §1.1.

Two cheap companions are missing (both in the probe):

- `not_lower_alone`: no reading of the second substrate itself performs lowering it. This is the companion of `not_raise_alone`; the module states only the raising side.
- Deutsch §3.4's pattern on the same witness. Lowering the first, the transpose of raising it, is performed by no region of any reading of the second (`not_lower_first`). Lowering the first with raising the second is possible (`performs_lower_raise`), so `Ã ⊗ B` is possible where `A` and `B` both raise.

### F13. Naming, glossary: "class" for a predicate

**Where.** Module doc (lines 13–20, 39–43, 50–51), and the docstrings of `Performs`, `Possible`, `Performs.serial`, `serial_holding`, `parallel_holding`, `parallel_reuse`, `Presented.interleave`, `transpose_not_possible`, `not_possible` and `composition_fails`.

**What.** `K : C → Prop` is called "a class of the performing part". The glossary gives class (类) one sense, an equivalence relation, and the module uses that sense itself in `sameReading_class`.

**Fix.** Use "region", the package's prose word for a predicate (`ClosedUnder rel region`; 97 uses in the package). Mention once that constructor theory calls it an attribute. For example: "A region `K` of the performing part's states performs a task…"; "performed by no region of any reading".

### F14. Naming and minor: `AtHand`, and the wrappers

**What.**

- **`AtHand` (473) is an idiom**, not a structural word. It is exactly `Reaching.PossibleHeld` at the part's sameness and the substrate's reading. Suggested name: `PossibleWithPartHeld`, with the four laws renamed to match. DESIGN §6 lists `Tasks.Doable`, which the module does not use; reconcile the two.
- **Several declarations are instances of UE11's laws, not new results.** These are the four `AtHand` laws, `Delivers.of_heldMoves`, `Performs.of_heldMoves` and `Delivers.heldMoves_mono`. AGENTS.md says a wrapper or rename is not another result, so the record should count them as instances.

### F15. Overclaim, minor, constructive wording

**Where.** `changes_of_atHandKeepsWidening` docstring (500–502): "some bounded stretch of the course changes it".

**What.** The Lean says only that not every step of the stretch keeps the part. A step that changes it follows only where keeping is decided (UE11's `Run.held_change_located`). That distinction matters in the pure core.

**Fix.** Use UE11's words: "from every step some bounded stretch of the course does not keep it throughout".

### F16. Overclaim, minor: "performs" where the Lean is `Delivers`

**Where.** Module doc lines 39–43: "performs two tasks on two substrates in parallel … (`Delivers.parallel_reuse`)" and "Two classes compose".

**What.** All three laws are `Delivers`. The presentation of the input pair is not proved and does not follow from the parts.

**Fix.** Use "delivers two tasks …" and "Two regions together deliver …".

### F17. Minor: an unused premise in `Performs.serial`

**What.** `second.1`, the presentation of the second task, is unused (line 207).

**Fix.** Take `second : Delivers P part sub K T'` (probe `performs_inSeries`), or keep the stronger premise and say why.

### F18. Minor: `sameReading_class` duplicates a lemma up to orientation

**What.** `sameReading_class` (202) duplicates `Becoming.GrammarCourse.sameValue_class` up to orientation (`sameValue o s t := o s = o t`). GrammarCourse is outside the import closure, so keeping it is defensible. The general fact, that a map's values give a class, belongs at the grammar, where both lemmas would follow from it. Note this in the record.

### F19. Minor: placement of `interleave`, and the name `Coupled`

**What.**

- **`interleave` (285) is the package's first asynchronous product of processes**; `GenerativeCore` has only the synchronous `productProcess`. Stated in a task leaf, it is hidden from the process layer. Say so in the record; it belongs beside `productProcess` when another module needs it.
- **`Tasks.Coupled` shares its last name with two other namespaces.** These are `Becoming.Coupled` (`Becoming.Continuation`, in the import closure) and `Becoming.RegimeMargin.Coupled`. There is no Lean clash, but it is a search hazard. `Resetting` would say what the process does.

### F20. Minor: cite the existing witness for `FlipTower`

**What.** `FlipTower` (806–837) is the delivery form of `Synchronous.tower_law_fails` (HeldPossible). Cite it in the docstring.

### F21. Minor: consistency of DESIGN.md with the module

**What.**

- T6 cites `RuleTower.possible_iff_held`, but the module proves `tower_delivers_iff_held`.
- §6 lists `Tasks.Doable` (see F14).
- §4 uses "calibration", a glossary term for where a law needs an omniscience principle, for "where composition holds and where it fails". Use another word.
- The board row should say why the module is a leaf (rule 9): a reading of constructor theory, not yet imported.
- `Regular` uses inclusion, which matches Deutsch's serial-composition clause. His "regular network" sentence can be read as equality; with inclusion the principle claims more. Say which reading is used.

### F22. Unclear, minor: modelling choices still to state

**What.** Add these to "Modelling choices", one sentence each:

- **Presentation** is co-occurrence in the configurations, not a course of the process: the user who presents is not read. It asks for the same state of the part with every input.
- **A task with no inputs** is possible on every inhabited process.
- **Performer readings** may be invariants of the process (F11).
- **Tasks need not list** what their deliveries change (F5).
- **`Possible` is not pharaonic** (F6).
- **Steps are discrete.**

## Checked and found correct

**Definitions.** All 26 definitions were read: `Input`, `Presented`, `Delivers`, `Performs`, `Possible`, `serial`, `Regular`, `parallel`, `transpose`, `interleave`, `interleaveOn`, `AtHand`, and the witnesses' processes, tasks and regions. Each is what its docstring says.

**Proofs.** Every proof was checked step by step:

| Group | Theorems |
|---|---|
| Reading | `delivers_iff_possible`, `on_every_run`, `Delivers.invariably` (correct; see F3, F4), `Delivers.of_heldMoves`, `Performs.of_heldMoves`, `Delivers.heldMoves_mono` |
| Composition | `sameReading_class`, `Performs.serial`, `Delivers.serial_holding`, `Delivers.parallel_holding` (both `Eq.subst` directions at the end checked), `Delivers.parallel_reuse` |
| Interleavings | `reach_interleave_left/right`, `Delivers.interleave_left/right`, `Presented.interleave`, `Performs.parallel_interleave`, `Possible.parallel_interleave`, `reach_interleaveOn_left/right`, `Performs.serial_interleaveOn`, `Possible.serial_interleaveOn` |
| Tower | `tower_delivers_iff_held` |
| `AtHand` | `Delivers.atHand`, `changes_of_atHandGrows`, `atHand_of_stays`, `changes_of_atHandKeepsWidening`, `not_atHandKeepsWidening_of_listed` (each a correct instance of UE11 with the right orientation of `Same`) |
| Catalysis | `reach_product`, `performs`, `not_held`, `product_stays`, `transpose_not_possible` |
| Coupled | `performs_first`, `performs_second`, `regular`, `stays`, `not_two`, `not_possible`, `not_holding`, `composition_fails` |
| Conserved | `empty_stays`, `full_stays`, `one_stays`, `second_empty_of_raised`, `first_full_of_lowered`, `performs_both`, `not_raise`, `not_lower`, `not_raise_alone`, `whole_of_impossible_parts`, `possible_with_one` |
| FlipTower | `performs`, `not_held` |

**Namespace.** Every declaration lies in `Becoming.Tasks`. No `Tasks` namespace, `Performs`, `Presented` or `Delivers` existed in the package before this module.

**Duplication.** The package has no asynchronous product of processes. `Interleavings.lean` interleaves lists of exchanges, a different object.

**Quotations and citations.**
- Every quotation of Deutsch 2013 in the design matches the text and the section cited: §1.1, §1.2, §2.1, §2.14, §3.1 and §3.13.
- Gogioso and others' Definition 3.3, Proposition 3.4 and footnotes 2–3 are as the design summarises, apart from F8.
- The design's arXiv identifiers 2505.08692, 2605.11417 and 2606.07352 match the works it names. 2605.11417 places the locality–composition conflict "in the context of quantum physics".
- F2's reading of locality rests on two texts. One is Deutsch 2013 §3.10. The other is Deutsch and Marletto's statement in §3 of arXiv:2505.08692 (current version, dated June 2026), checked against text extracted from its PDF. There the clause on tasks performed on one substrate only follows a description of composite attributes as ordered pairs.

## Not reviewed

`NOTE.md` and `kit/integrate_ue12.py` appeared in the folder during this review, and neither was reviewed. A read-only search of `NOTE.md` found two things:

- **Wording these findings correct.**
  - "A constructor is a held part" (line 11), and constructor theory's possible read as "the possible relative to a held part" (lines 71, 133; F1).
  - The composition principle said to hold on interleavings (lines 17, 39, 72; F2).
  - "The premise is needed", and the principle read as a premise about which processes are the laws (lines 42, 46; F5, F9).
- **Declarations absent from the reviewed module** (sha256 `d1f01ac7…68f7`). It cites four: `Tasks.Delivers.narrows`, `Tasks.Performs.unitPart`, `Tasks.Possible.serial_of_unitPart` and `Tasks.Rising.widens`.

Any revision of the module after that hash is unreviewed.
