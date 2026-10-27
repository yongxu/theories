# Recheck of UE12: `Becoming.Tasks`

27 October 2026. An AI-written independent recheck of `tree/Becoming/Tasks.lean` (sha256 `fbccc794…34da`, 1509 lines), the revision made after [the review](REVIEW-UE12.md) of sha256 `d1f01ac7…68f7`. It was read against the package (`Becoming.ReachableRanges`, `Becoming.HeldPossible`, `Becoming.GrammarLaws`, `Becoming.Laws`, `Becoming.Frame`), Deutsch 2013 (arXiv:1210.7439v2, extracted text: §1.1, §1.2, §3.1, §3.4, §3.10, §3.13), Deutsch and Marletto, *Constructor theory of time* (arXiv:2505.08692, June 2026, §3), and item 5 of [the UE plan](../ue-unified-explanation/PLAN.md).

Probes: [`probes2/tree/Becoming/TasksRecheck.lean`](probes2/tree/Becoming/TasksRecheck.lean), importing an unchanged copy of the module. Built with `scratch_build.py`: 43 theorems, 49 declarations, every axiom report empty, no error or warning ([`probes2/build-5.log`](probes2/build-5.log)). The module itself, built from the same copy (its step restored from the shared cache of a passed run on identical inputs): 104 theorems, 138 declarations, every axiom report empty, no error or warning, as stated.

## Verdict

The Lean is correct. All 104 theorems and 34 definitions were read (list at the end), and each theorem proves what its statement says. Every module part of F1–F22 is taken. The parts for DESIGN.md, the board and the record are outside this recheck.

What remains is in what the module says. Two findings change it:

- **The answer to the UE plan's question is incomplete (R1).** The plan asks whether widening is the order possible tasks carry. The module reads only widening with a lag, one disjunct of UE10's lagged order. The lagged order ranks a delivered output above its input exactly where same-offset widening does, and same-offset widening ranks the output above the input on one witness and the input above the output on another. Covering, read on infinite runs, ranks nothing on the module's own catalytic cycle, where the whole possible narrows strictly. The module never states the answer the Lean supports: what every delivery carries is the inclusion of the whole possible, not widening.
- **`tower_made_held` is read as the requirement it assumes (R2).** That a chain of construction begins with a natural configuration is `PossibleFrom`, its hypothesis. The theorem is UE11's `RuleTower.possible_iff_held` at the made performer. What it adds is that on the tower a construction changes only finitely many levels.

The rest are smaller:

- three module-doc sentences drop a theorem's condition, one of them false as worded (R3);
- the one-next hypothesis is the grammar's fixed successor, and the proofs need only `«定后于»` (R4);
- one docstring claim on the conserved amount is unproved, and two companions are missing (R5);
- the counter duplicates UE10's `Climb` (R6);
- two lemmas sit in UE10's namespace (R7);
- the record should count several declarations as instances (R8).

**Answers to the questions asked.**

- **(a) `Possible.parallel_within`** is correct and says what its docstring says: within the interleaving on two substrates, for divisions read off each process, possible tasks are possible in parallel. Its hypotheses are equivalent to those of `Possible.parallel_interleave`, given one configuration of the other process (probes `possible_interleave_left_of` and `possible_interleave_right_of`, with the module's `Possible.of_interleave_left/right`). So it is that law read within the interleaving. "Possibility is read in each process" is exact for the four interleaving laws it follows.
- **(b) `PossibleFrom`** in its existential form is what Deutsch §3.1 asks. A task is impossible if its constructor cannot be built from naturally-occurring resources, so a possible task needs some construction. Each chain of construction must begin with naturally-occurring constructors and substrates, so a performer already present in a natural configuration counts as made, at zero moves. With every configuration natural, `PossibleFrom` is `Possible` (probe `possibleFrom_all_iff`). On `Unmade` with every configuration natural, the existential form holds and the universal form sketched in F6 fails (probe `unmade_forms`). The universal form asks more than the text; the two agree where one configuration is natural. On `tower_made_held`, see R2.
- **(c) The order.** See R1.
- **(d) `Conserved.additive_pattern`** reads §3.4 faithfully. Take `A` as raising the first and `B` as raising the second, both changing the amount by one unit. Then `A`, its transpose `Ã`, `B` and `B̃` are each performed by no region of any reading of the other substrate, and `Ã ⊗ B` (`parallel lower raise`) and `A ⊗ B̃` (`parallel raise lower`) are possible. The impossibility proofs are §1.1's battery induction in one unit. The impossibilities are relative to the division: the other substrate stands for Deutsch's separate constructor, and no third system is read. See R5.
- **(e) Glossary and naming.** "Class" now names only `«类»`, and "region" names predicates. "Calibration" is not used. "Attribute" is used once, in Deutsch and Marletto's sense, a set of states. `Resetting` and `RiseTask` avoid the hazards `Becoming.Coupled` and `Becoming.Rising`. `Counting` is a new hazard (R6). `Delivers.narrows` names an inclusion (R1).

**Recommendation:** land after R1, R2 and R3. R4–R6 are cheap and recommended. R7 and R8 are record notes.

## Findings

### R1. Incomplete, in the module's answer to UE plan item 5: the order deliveries carry

**Where.** Module doc, "The order possible tasks carry" (lines 114–121) and "Modelling choices" (line 30); `Delivers.narrows` (781–797); `RiseTask.widens` (1488–1503).

**What.** The UE plan's item 5 asks to "test whether widening is the order constructor theory's possible tasks carry". The bullet answers with widening with a lag only, and calls same-offset widening "another relation". The Lean shows three things the bullet does not say.

- **UE10's order is the lagged order, `Reaching.WidensOrLater`: widening, or widening with a lag.** It ranks what a configuration reaches above it exactly where same-offset widening does. This is probe `widensOrLater_iff_widens_of_reach`, the reach form of UE10's `Run.widensOrLater_next_iff`, whose docstring says the lag adds nothing there. So the lagged order ranks `RiseTask`'s delivered output above its input (probe `riseTask_lagged`). Same-offset widening also runs the other way. Probe `Fall.widens_back` performs the task `true` to `false` on the process where every step leads to `false`. Read with UE10's `Rise.adm`, the input widens the output there, and so the lagged order ranks the input above the output.
- **Covering is silent where the output starts no course.** Covering reads infinite runs; UE10 states that a configuration starting none is covered by every configuration (`NoCourse`). On the catalytic cycle no configuration starts a course (probe `CatalysisCourses.no_course`). So every configuration covers every other with every lag (`coversLater_all`), and the lagged order ranks nothing (`not_widensOrLater`). Yet the whole possible narrows strictly there (`Catalysis.narrows`; probe `narrows_unseen` states the three together). On the module's own witness for strict narrowing, the covering conjuncts of `Delivers.narrows` hold of every pair of configurations.
- **The third conjunct of `Delivers.narrows` follows from the second** (probe `not_widensWithLag_of_coversLater`). And "So a delivery adds nothing to the whole possible" follows from `Reaching.Possible.of_reach`, not from the covering lemma before it, as "So" suggests.

The Lean supports a plain answer. Along a delivery the whole possible never widens, and it can narrow strictly. Widening, in UE10's lagged order, follows deliveries in neither direction: it ranks the output above the input (`RiseTask`), the input above the output (`Fall`), or neither (`Catalysis`). So what every delivery carries is the inclusion of the whole possible, from the output into the input, and not widening.

Two smaller points. Line 30 says "some admissible course delivers", using "course" for a finite trace, where this bullet needs traces and runs kept apart. And `Delivers.narrows` names an inclusion, while `Catalysis.narrows` is strict.

**Fix.** Replace the bullet with:

> * **The order possible tasks carry.** A delivery adds nothing to the whole possible: what is possible from its output is possible from its input (`Delivers.narrows`, by `Reaching.Possible.of_reach`). On the catalytic cycle it narrows the whole possible strictly (`Catalysis.narrows`). Widening what can be reached follows deliveries in neither direction. The input covers the output with a lag the trace's length (`Reaching.coversLater_of_trace`), so UE10's lagged order ranks a delivered output above its input exactly where same-offset widening does (`Reaching.widensOrLater_iff_of_reach`). Same-offset widening can rank the output above the input (`RiseTask.widens`, on UE10's rising process) or the input above the output (`FallTask.widens_back`). Covering reads infinite runs, so where the output starts none, every configuration covers it with every lag: on the catalytic cycle the lagged order ranks nothing while the whole possible narrows strictly (`Catalysis.no_course`, `Catalysis.not_widensOrLater`). So what every delivery carries is the inclusion of the whole possible, and not widening.

In "Modelling choices", replace "some admissible course delivers" with "some trace delivers", and add: "Delivery reads finite traces and covering reads infinite runs; a configuration that starts no run is covered by every configuration (UE10's `NoCourse`)."

In `Delivers.narrows`, drop the third conjunct, or say that it follows from the second. Replace the docstring's last clause, "and which widening with a lag does not rank above the first (`Reaching.not_widensWithLag_of_reach`)", with: "Covering reads infinite runs, so where the output starts none, the second conjunct holds of every configuration (`Catalysis.no_course`)."

Add the Lean; all of it is in the probe and builds with empty reports. In `namespace Reaching`, after `not_widensWithLag_of_reach`:

```lean
/-- **On what a configuration reaches, the lagged order is same-offset widening**: the lag adds
nothing there (`Run.widensOrLater_next_iff`, for reach). -/
theorem widensOrLater_iff_of_reach {s t : S} (reach : Reach P s t) :
    WidensOrLater P adm t s ↔ Widens P adm t s :=
  ⟨fun above => match above with
     | .inl widens => widens
     | .inr lag => absurd lag (not_widensWithLag_of_reach reach),
   .inl⟩
```

In `namespace Catalysis`, add the probe's `CatalysisCourses` declarations: `into`, `stuck`, `no_course (r : Run process) : False`, `coversLater_all`, and `not_widensOrLater (adm) (s s') : ¬ Reaching.WidensOrLater process adm s s'`. Add the probe's `Fall` as `FallTask`, beside `RiseTask`. `FallTask` is optional: without it, drop "or the input above the output" from the bullet, and `Catalysis` alone shows that widening does not always rank the output above the input.

### R2. Overclaim: `tower_made_held` is read as the requirement it assumes

**Where.** `tower_made_held`, docstring and statement (693–712); module doc, "The regress" (lines 102–104); the pointers in `tower_delivers_iff_held`'s docstring (675–676) and `FlipTower.not_held`'s (1470–1471).

**What.**

- **The requirement is the hypothesis.** Deutsch §3.1 asks, to avoid an infinite regress, that every chain of construction of a possible task's constructor begin with naturally-occurring constructors and substrates. The module reads that requirement in `PossibleFrom`: from some natural configuration the process reaches one with the performer. `tower_made_held` takes `PossibleFrom` as its hypothesis. Its docstring says "This is constructor theory's requirement … read on the tower: there it holds wherever each move keeps the performers from some level up". That reads the theorem as deriving the requirement, which it assumes.
- **The conclusion is UE11's tower law at the made performer.** It adds that the reach holds the performers from some level `n` up. That is `RuleTower.possible_iff_held` at the formation "the part in `K`", applied to `PossibleFrom`'s reach (probe `made_held_of_possible_iff_held`). The proof inlines `Reaching.reach_held_of_sequence` with that law's arguments (lines 708–711, and again in `tower_delivers_iff_held`, 685–688). Its standing is an instance.
- **What it adds, read on the regress.** On the tower a construction changes the substrate and the performers below some level, and takes those from that level up as found. So the regress the requirement avoids ends at a finite height, because a construction is a finite trace, whatever the natural configuration.
- **"As they are in the natural configuration" is not in the statement.** It follows from `Reach.same_of_heldMoves (RuleTower.sameFrom_class n)` (probe `made_as_there`).

**Fix.** Replace the docstring with:

> **On a tower of performers with no top, a performer made from a natural configuration is made with the performers from some level up held, as the natural configuration has them** (UE11's `RuleTower.possible_iff_held`, at the part in the region). The construction changes the substrate and the performers below some level, each as the one above allows, and takes the performers from that level up as found. That it begins with a natural configuration is `PossibleFrom`, this theorem's hypothesis, which reads constructor theory's requirement on chains of construction (Deutsch §3.1). The theorem adds that on the tower the regress the requirement avoids ends at a finite height, because a construction is a finite trace.

State "as found", and factor the reach term (probes `tower_reach_held`, `tower_made_held_as_there`, `tower_delivers_held`):

```lean
/-- What the tower reaches it reaches with the performers from some level up held
(`Reaching.reach_held_of_sequence` at `RuleTower.SameFrom`). -/
theorem tower_reach_held {s t : Z × (Nat → R)} (reach : Reach (RuleTower.process base up) s t) :
    ∃ n, Reach (Reaching.heldMoves (RuleTower.process base up) (RuleTower.SameFrom n)) s t :=
  Reaching.reach_held_of_sequence (P := RuleTower.process base up)
    (E := fun n => RuleTower.SameFrom n)
    (fun _ _ le _ _ same => RuleTower.SameFrom.mono same le)
    (fun _ a _ step => ⟨a, RuleTower.step_sameFrom a step⟩) reach

theorem tower_made_held {natural : Z × (Nat → R) → Prop}
    (possible : PossibleFrom (RuleTower.process base up) Prod.snd Prod.fst natural T) :
    ∃ K : (Nat → R) → Prop, Performs (RuleTower.process base up) Prod.snd Prod.fst K T ∧
      ∃ s, natural s ∧ ∃ n t,
        Reach (Reaching.heldMoves (RuleTower.process base up) (RuleTower.SameFrom n)) s t ∧
          RuleTower.SameFrom n s t ∧ K t.2 :=
  match possible with
  | ⟨K, performs, s, isNatural, t, reach, inK⟩ =>
    match tower_reach_held reach with
    | ⟨n, held⟩ => ⟨K, performs, s, isNatural, n, t, held,
        Reach.same_of_heldMoves (RuleTower.sameFrom_class n) held, inK⟩
```

The forward direction of `tower_delivers_iff_held` then uses `tower_reach_held` (probe `tower_delivers_held`). In the module doc, replace "A performer made from a natural configuration … begins with performers it does not construct." with:

> A performer made from a natural configuration is made with the performers from some level up held as the natural configuration has them (`tower_made_held`), so on the tower a chain of constructions beginning with a natural configuration constructs only finitely many levels.

In `tower_delivers_iff_held`'s docstring, replace "(the pharaonic task, Deutsch §3.1; `tower_made_held`)" with "(the pharaonic task, Deutsch §3.1), which `PossibleFrom` reads, and on the tower `tower_made_held`". In `FlipTower.not_held`'s docstring, replace "the requirement on making the performer (`tower_made_held`) is not touched" with "making the performer (`PossibleFrom`, `tower_made_held`) is not touched".

### R3. Overclaim: three module-doc sentences drop a theorem's condition

**Where.** Module doc, lines 34–35, 68–69 and 74–76.

**What.**

- **"So a task relating each input to itself is performed on every process (`performs_identity`)" is false as worded.** The theorem asks for a configuration and for each input to be had by some configuration, and its docstring says so. Without the second condition the statement fails. Probe `identity_not_possible`: on any process with one configuration, read with the substrate `false`, the identity task on `Bool` is performed by no region of any reading, since the input `true` is never had.
- **"Where no performing part is needed, read with the part trivial, possible tasks compose in series (`Possible.serial_of_unitPart`)" drops the regular pair.** The theorem takes it, its docstring says so, and it is needed. Probe `Unregular`: on a process with the steps `0 → 1` and `2 → 3`, the tasks "`0` to `1` or `2`" and "`2` to `3`" are each performed with no performing part. The pair is not regular, and the composite is performed by no region of any reading (`composite_not_possible`).
- **"Tasks performed in the two processes then compose (`Performs.serial_interleaveOn`, …)" drops the same condition for the series laws.** This sentence is the earlier review's F2 text.

**Fix.** Replace the three with:

> so a task relating each input to itself is performed on every process with a configuration where each of its inputs is had (`performs_identity`)

> Where no performing part is needed, read with the part trivial, a regular pair of possible tasks is possible in series (`Possible.serial_of_unitPart`).

> Tasks performed in the two processes then compose, in series where the pair is regular (`Performs.serial_interleaveOn`, `Performs.parallel_interleave`), and so do tasks possible in them (`Possible.serial_interleaveOn`, `Possible.parallel_interleave`).

Optionally add the probe's `Unregular` as the witness that regularity is needed.

### R4. Naming, board rule 9: the one-next hypothesis is the grammar's fixed successor

**Where.** `on_every_run` (221–233), `Delivers.invariably` (235–247), `Counting.oneNext` (1370–1372); module doc, lines 31–33.

**What.**

- **The hypothesis is `«定后» (Steps P)`.** `∀ s a t a' t', P.step s a t → P.step s a' t' → t = t'` is the grammar's fixed successor of the steps (probe `oneNext_iff_fixed`, by `«定后之逐点»`). `Becoming.GrammarLaws` is in the import closure, and AGENTS.md asks for statements on the grammar where possible. It is stronger than the package's `Determined`, a fixed successor for each move (`determined_iff_fixed`).
- **The proofs need less.** They need the successor fixed only at what the presented configuration reaches, `«定后于» (Steps P) s`. The grammar introduces `«定后于»` for such uses, noting that its laws of return use a fixed successor only there. Probes `on_every_run_within` and `invariably_within` prove both laws from it.

**Fix.** State both on the grammar, with the probes' proofs:

```lean
theorem on_every_run {s₀ : S} (fixed : «定后于» (Steps P) s₀) :
    ∀ {s t : S} {as : List A}, Reach P s₀ s → Trace P s as t → ∀ (r : Run P) (k : Nat),
      r.state k = s → ∃ n, r.state (k + n) = t

theorem Delivers.invariably (delivers : Delivers P part sub K T) {s : S}
    (fixed : «定后于» (Steps P) s) (inK : K (part s)) (input : Input T (sub s)) :
    ∃ t, Reach P s t ∧ K (part t) ∧ T (sub s) (sub t) ∧
      ∀ r : Run P, r.state 0 = s → ∃ n, r.state n = t
```

Begin the docstring with "**Where the successor is fixed at what the presented configuration reaches** (`«定后于»`)", and use the same words in the module doc. A process with at most one next configuration everywhere gives the premise by `«定后则定后于»`. The counter's `oneNext` becomes `«定后» (Steps …)` (probe `ClimbTaskFix.fixed`, and `ClimbTaskFix.invariably` for the use).

### R5. Unproved, and two companions missing: the conserved amount

**Where.** `Conserved.holdsOne_eq_xor` and `Conserved.performs_with_one` docstrings (1326–1327, 1346–1351); module doc, lines 92–93.

**What.**

- **"One to one" is not proved.** Both docstrings say that with the first substrate, `holdsOne` recodes the configuration one to one. It is true; probe `holdsOne_recodes` proves it.
- **Two of the four "alone" impossibilities are missing.** The module has the first raising itself (`not_raise_alone`) and the second lowering itself (`not_lower_alone`). The probe's `not_lower_first_alone` and `not_raise_second_alone` give the other two. With them, all four single tasks are impossible under both divisions by one substrate, the performer read off the other substrate (`additive_pattern`) or off the substrate changed.
- **Read off both substrates, the performer performs all four.** That is `performs_with_one` and probes `performs_lower_first_with_one`, `performs_raise_second_with_one` and `performs_lower_second_with_one`. This supports the scope `whole_of_impossible_parts` states: "Readings of the two together are not ranged over".

**Fix.** Add this beside `holdsOne_eq_xor` and cite it in both docstrings, or drop "one to one" from them:

```lean
/-- With the first substrate, whether the two together hold one unit recodes the configuration one
to one. -/
theorem holdsOne_recodes : ∀ s t : Bool × Bool, s.1 = t.1 → holdsOne s = holdsOne t → s = t
  | (false, false), (false, false), _, _ => rfl
  | (false, true), (false, true), _, _ => rfl
  | (true, false), (true, false), _, _ => rfl
  | (true, true), (true, true), _, _ => rfl
  | (false, false), (false, true), _, same => Bool.noConfusion same
  | (false, true), (false, false), _, same => Bool.noConfusion same
  | (true, false), (true, true), _, same => Bool.noConfusion same
  | (true, true), (true, false), _, same => Bool.noConfusion same
  | (false, _), (true, _), first, _ => Bool.noConfusion first
  | (true, _), (false, _), first, _ => Bool.noConfusion first
```

Add the two companions from the probe, and in the module doc write "no reading of either substrate alone raises or lowers it (`Conserved.not_raise_alone`, `Conserved.not_lower_alone`, `Conserved.not_lower_first_alone`, `Conserved.not_raise_second_alone`)". Optionally, add to `performs_with_one`'s docstring that the same reading performs all four single tasks.

### R6. Duplicate and naming: the counter is UE10's `Climb`

**Where.** The `Counting` namespace (1363–1403); module doc, lines 36–37.

**What.**

- **The process exists.** `Tasks.Counting.process` is `Climb.process` by `rfl` (probe `counting_eq_climb`), and the same as UE11's `AdjacentHeld.process`. `Counting.reach_add` is `Climb.trace_units` (probe `reach_add_of_climb`). AGENTS.md asks to extend the spine rather than build another model.
- **The name is taken.** `Becoming.Counting` is a module of the package, outside this module's import closure. `Tasks.Counting` is a search hazard of the kind F19 named.
- **The Lean is narrower than the sentence.** `Counting.performs g` covers tasks that are functions, `x ↦ x + g x`. The module doc says "every task taking each count to a count ahead of it", which reads as any relation. The Lean for that is as short (probe `ClimbTaskFix.performs`).

**Fix.** Build the witness on `Climb.process`, in a namespace named for what it shows, such as `ClimbTask`. Use the probe's `ClimbTaskFix.fixed`, `performs` (every task each of whose inputs has an output at or ahead of it), `invariably` and `performs_function` (the present `performs g`), and keep `moves_change` and `performs_identity` as they are. In the module doc write: "so on UE10's climbing process every task each of whose inputs has an output at or ahead of it is performed, and invariably (`ClimbTask.performs`, `ClimbTask.invariably`)".

### R7. Placement, minor: lemmas in UE10's and UE11's namespaces

**Where.** `Reaching.coversLater_of_trace` (138–148) and `Reaching.not_widensWithLag_of_reach` (150–154); R1's `Reaching.widensOrLater_iff_of_reach` and R2's `tower_reach_held`, if added.

**What.** These are laws of UE10's covering and UE11's tower on any process, stated in a leaf. UE10's `Run.coversLater_next` and `Run.not_widensWithLag_next` are their one-step cases. No package lemma duplicates them: `Run.tail_of_trace` prefixes a trace to a run the same way but states no lag. Their place is the decision of the owner of those modules (AGENTS.md, Coordination), as LANDING.md says.

**Fix.** A record note: the first three belong in `Becoming.ReachableRanges` beside `Run.coversLater_next`, and `tower_reach_held` in `Becoming.HeldPossible` beside `RuleTower.possible_iff_held`, which follows from it.

### R8. Standing, for the record: instances are not further results

**What.** AGENTS.md says a wrapper, recheck or rename is not another result. These declarations are instances or corollaries of laws stated elsewhere:

- `Delivers.narrows`: `Reaching.Possible.of_reach` and `coversLater_of_trace`, at a delivery;
- `tower_made_held`: `RuleTower.possible_iff_held` (R2);
- `Possible.parallel_within`: `Possible.parallel_interleave` with the projection laws, its hypotheses equivalent (answer (a));
- `Possible.serial_of_unitPart`: `Performs.serial` with `Performs.unitPart`;
- `Conserved.additive_pattern` collects six lemmas, and `whole_of_impossible_parts` is three of them;
- `Delivers.of_heldMoves`, `Performs.of_heldMoves`, `Delivers.heldMoves_mono` and the five `PossibleWithPartHeld` laws: UE11's laws at the part;
- `Delivers.serial_holding` and `Delivers.parallel_holding`: the one-region laws at the pair region, as their docstrings say;
- `PossibleFrom.possible`: a projection.

So the 104 theorems are not 104 results.

**Fix.** A record note.

## F1–F22

| Finding | Status | Note |
|---|---|---|
| F1 | Taken | Module doc, lines 6–12. The board row and the record: outside the module. |
| F2 | Taken | Both docstrings and the Locality bullet as proposed; the projection laws, `Possible.parallel_within` and `ResettingInterleaved.composition_fails_within` added. On the proposed bullet's "compose", see R3. DESIGN T3: outside the module. |
| F3 | Taken | Docstring, modelling choices, and the counter as a witness. On the added text, see R3 and R6. |
| F4 | Taken | The conclusion returns the reach. |
| F5 | Taken | Docstring and renamed bullet; "listed so, the pair is not regular" proved (`Resetting.listed_not_regular`). DESIGN T4: outside the module. |
| F6 | Taken | `tower_delivers_iff_held`'s docstring and the bullet as proposed. The optional definition taken in the existential form, which is what §3.1 asks (answer (b)), with `Unmade` and `tower_made_held` (R2). DESIGN T6: outside the module. |
| F7 | Taken | `«而»` and `«逆»` used; the order of `AB` noted. |
| F8 | Taken | `Delivers.parallel_inTurn` renamed; `Resetting.one_part_two_regions` added. DESIGN T2(a) and the record: outside the module. |
| F9 | Taken | `CatalysedSeries` added; "sufficient, not needed" in the module doc and `serial_holding`'s docstring. DESIGN T4: outside the module. |
| F10 | Taken | `Delivers.serial` below; `Performs.serial`, `serial_holding` and `parallel_holding` derived through the four pair lemmas. |
| F11 | Taken | Renames and docstring as proposed; the proposed "one to one" was unproved (R5). |
| F12 | Taken | `not_lower_alone`, `not_lower_first`, `performs_lower_raise`, and beyond them `not_raise_second` and `additive_pattern`; `whole_of_impossible_parts` states what it ranges over. The reservoir point was in the finding's "What" only. |
| F13 | Taken | |
| F14 | Taken | `PossibleWithPartHeld` and its laws renamed. DESIGN §6 and the record's count: outside the module (see R8). |
| F15 | Taken | |
| F16 | Taken | |
| F17 | Taken | `second : Delivers …`, and the docstring says so. |
| F18 | Outside the module | A record note. |
| F19 | Taken | `Coupled` renamed `Resetting`. The placement of `interleave` is a record note: outside the module. |
| F20 | Taken | |
| F21 | Taken | `Regular`'s docstring says which reading is used. The rest is DESIGN and the board: outside the module. |
| F22 | Taken | All six, and "Performance is exact" besides. |

## Checked and found correct

**Definitions.** All 34 were read: `Input`, `Presented`, `Delivers`, `Performs`, `Possible`, `PossibleFrom`, `Regular`, `parallel`, `interleave`, `interleaveOn`, `PossibleWithPartHeld`, and the witnesses' processes, tasks and regions. Each is what its docstring says.

**Proofs.** Every proof was checked step by step, the unchanged ones included, since the module was reorganized. All are term proofs; no tactic is used.

| Group | Theorems |
|---|---|
| Lagged covering | `Reaching.coversLater_of_trace` (the run from the start is the trace prefixed by `Run.cons`, the lag its length), `Reaching.not_widensWithLag_of_reach` |
| Reading | `PossibleFrom.possible`, `delivers_iff_possible`, `on_every_run`, `Delivers.invariably`, `performs_identity`, `possible_of_no_input`, `Delivers.of_heldMoves`, `Performs.of_heldMoves`, `Delivers.heldMoves_mono` |
| Composition | `sameReading_class`, `Delivers.serial`, `Performs.serial`, `Delivers.pair_left/right`, `Delivers.serial_holding`, `Delivers.parallel_inTurn` (both `Eq.subst` directions), `Delivers.pair_left_held/right_held`, `Delivers.parallel_holding`, `Performs.unitPart`, `Possible.serial_of_unitPart` |
| Interleavings | `reach_interleave_left/right`, `reach_fst_of_interleave`, `reach_snd_of_interleave`, `Delivers.interleave_left/right`, `Presented.interleave`, `Performs.parallel_interleave`, `Possible.parallel_interleave`, `Possible.of_interleave_left/right`, `Possible.parallel_within`, `reach_interleaveOn_left/right`, `Performs.serial_interleaveOn`, `Possible.serial_interleaveOn` |
| Tower | `tower_delivers_iff_held`, `tower_made_held` (R2) |
| Part held | `Delivers.possibleWithPartHeld`, `changes_of_partHeldGrows`, `possibleWithPartHeld_of_stays`, `changes_of_partHeldKeepsWidening`, `not_partHeldKeepsWidening_of_listed` (each a correct instance of UE11, with `Same` oriented as UE11 has it) |
| Order | `Delivers.narrows` (R1) |
| Catalysis | `reach_product`, `performs`, `not_held`, `product_stays`, `transpose_not_possible`, `narrows` |
| Resetting | `performs_first`, `performs_second`, `regular`, `stays`, `not_two`, `not_possible`, `not_holding`, `composition_fails`, `listed_not_regular`, `performs_first_by_part`, `one_part_two_regions` |
| CatalysedSeries | `not_holding`, `performs_pair` |
| ResettingInterleaved | `first_possible`, `second_possible`, `stays`, `not_two`, `not_possible`, `composition_fails_within` |
| Conserved | `empty_stays`, `full_stays`, `unit_stays`, `second_empty_of_raised`, `first_full_of_lowered`, `second_full_of_emptied`, `first_empty_of_raised_second`, `performs_both`, `not_raise`, `not_lower`, `not_raise_second`, `not_raise_alone`, `not_lower_alone`, `whole_of_impossible_parts`, `not_lower_first`, `performs_lower_raise`, `additive_pattern`, `holdsOne_eq_xor`, `holdsOne_kept`, `performs_with_one` |
| Counting | `oneNext`, `reach_add`, `performs`, `invariably`, `moves_change`, `performs_identity` |
| Unmade | `performs`, `absent_stays`, `possible_not_possibleFrom` |
| FlipTower | `performs`, `not_held` |
| RiseTask | `widens` |

**Hypotheses.** No unused hypothesis was found; the build reports no warning. Apart from those named in R2 and R5, every statement is as strong as its docstring.

**The held premise.** `Catalysis.not_held` holds the region `Free` at every move. Holding the enzyme unchanged, UE11's possible relative to a held part, fails as well (probe `catalysis_not_held_unchanged`), so "not needed" in the module doc stands for either reading.

**Namespaces.** No other module of the package uses the two `Reaching` names, or the witness namespaces `Catalysis`, `Resetting`, `CatalysedSeries`, `ResettingInterleaved`, `Conserved`, `Unmade`, `FlipTower` and `RiseTask`. `Counting` is a module name (R6).

**Quotations and citations.**

- Deutsch 2013, as the module uses it:
  - §1.1: the definition of a possible task, short of perfection, and what the user must do staying the same;
  - §1.2: the serial-composition clause and the regular-network sentence, as `Regular` says;
  - §3.1: the pharaonic version, and resources counted natural depending partly on local conditions, as `PossibleFrom` says;
  - §3.4: the additive pattern;
  - §3.13: halting.
- Deutsch and Marletto, *Constructor theory of time* (June 2026), §3: an attribute is a set of states, a task requires an indication that it is complete, and the locality clause is as the Locality bullet states it.
- UE10's `Rise`, `NoCourse` and `Run.widensOrLater_next_iff`, and UE11's `Synchronous.tower_law_fails` and `RuleTower.possible_iff_held`: as cited.

## Not reviewed

Not reviewed:

- DESIGN.md (out of scope), NOTE.md, LANDING.md, `kit/`, the board and the record;
- `clash/`, the `clash*.log` and `scratch-*.log` files, the earlier `probes/`, and U12's sibling folders;
- Deutsch 2013 beyond the sections listed, Deutsch and Marletto beyond §3, and the package beyond the declarations cited.

A read-only search of NOTE.md found:

- **Names.** Every `Tasks.` name it cites exists in this revision. R1, R2, R4 and R6 would change some (`Counting`, the conjuncts of `Delivers.narrows`).
- **Line 151, "the lagged order never rises".** Probe `riseTask_lagged` contradicts it: UE10's lagged order, `WidensOrLater`, ranks `RiseTask`'s output above its input. It holds of widening with a lag alone (R1).
- **Line 282, "an irreversible task narrows it for good".** This is shown on one witness (`Catalysis.narrows`); no theorem states it for every task with an impossible transpose.
- **Lines 121 and 52.** Line 121 repeats the unproved "one to one" (R5), and line 52 the counter's relational wording (R6).

Any revision of the module after sha256 `fbccc794…34da` is unreviewed.
