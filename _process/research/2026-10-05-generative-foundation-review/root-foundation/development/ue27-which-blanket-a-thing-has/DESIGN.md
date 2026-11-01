# UE27: which blanket a thing has, and a World formation as the agent of a blanketed law (design, revised three times)

AI-written, 31 October 2026, by the session that holds UE26. Board item UE27. Revised after an independent review ([REVIEW-UE27-DESIGN](REVIEW-UE27-DESIGN.md), fifteen findings, every one taken; §7), and again, 1 November, after UE26 landed and an independent review of the scratch Lean ([REVIEW-UE27-LEAN](REVIEW-UE27-LEAN.md), fifteen findings, every one taken; §8), and after a review of the landing texts and records ([REVIEW-UE27-LANDING](REVIEW-UE27-LANDING.md), twenty-two findings, every one taken; §9). The module `tree/Becoming/BlanketCouplings.lean` builds in scratch on main cc2074912 with 43 theorems in 76 declarations, every axiom report empty and no warning ([scratch-build-v2.log](scratch-build-v2.log); after the landing review's header fix, [scratch-build-v3.log](scratch-build-v3.log)). Where this design and the module differ, the module and §8 govern. The coordinator places its core landing after BD2, EL's core Lean and DU.

## 1. The gap

The principle defines a thing by its Markov blanket: whatever persists has internal states separated from external states by sensory and active states (Friston 2013, 2019; Kirchhoff, Parr, Palacios, Friston and Kiverstein 2018). The theory states the blanket as a coupling structure, a determined law on four parts, each part's next state reading only some parts (`Becoming.Blanket`, 03 §1). Its witness `ThresholdDrain` joins it to the World: the witness's sensory part is the World's admission at need one (`ThresholdDrain.sensory_is_admission`), and its courses are blanket-alike exactly where the supply histories are alike through the formation's couplings (`ThresholdDrain.blanket_iff_through`). Two things are left open, in the theory's own words:

- **The general join.** The record [the Markov blanket as a coupling structure](../../../../../../theories/becoming/results/records/the-markov-blanket-as-a-coupling-structure.md) gives as its next delta, from UE18's [NOTE](../ue18-blanket-and-existence/NOTE.md) §3, "a World formation in general as the agent of a blanketed law, its sensory course its own course (`Web.selectsThrough_iff_prefix`) and its environment the levels under the others' fixed exchange: the join is proved for the witness only". 03 §1 says it "is not shown", and the principle's page lists it in §5. 03 §1's reading says what the join would make a theorem: a formation's support and observed levels are its sensory states, what it keeps of them its internal states.
- **Which blanket a thing has.** `Blanket.lean`'s header lists it among what the model leaves out. The criticism of the principle turns on how a blanket is fixed and what its existence says. Bruineberg, Dołęga, Dewhurst and Baltieri (2022) set Pearl's blankets, fixed within a model, against Friston's, read as the thing's boundary. Raja, Valluri, Baggs, Chemero and Anderson (2021) argue that a formalism applying to any domain is a narrower account of life and mind than claimed. Biehl, Pollock and Kanai (2021) show that the blanket's definitions are not equivalent, the statistical against the dynamical. The proponents class the existence claim with principles of stationary action, not falsifiable strictly speaking (Ramstead and others 2023). `Blanket` states that concession for the claim's weighting form (`forbids_iff`: a course is forbidden only by a weighting fixed apart from it); the coupling form has no such statement.

**Purpose.**
1. The general join, by construction: for any formation of any web whose couplings give the values of what couples into it, any model fed by those values, with any policy and any environment, is the agent of a blanketed law whose sensory course is the formation's own course through its couplings. Two of its courses are blanket-alike exactly where their level histories are alike through those couplings, and in the open loop every reading of its internal course is a selection through them. The law is a construction, not a test: having it forbids nothing of the formation's course. What it states is what the sensory part carries and that what the agent tells apart passes through it. For a World, the agent is a model beside the formation, not its own record, and the World's own case is the open loop at its levels.
2. Which blanket: state in the pure core when the existence of a blanket constrains anything. With parts that read the course (which course and the step, or its future), every family of courses has one. With a degenerate reading of the configuration, every family has a law determined part by part (the constant reading), or every family whose law is determined (the whole configuration), and an injective reading gives one only where the law is determined, not always there. A sparse partition fixed apart from the family, on a law the same at every step, can be refuted, even by one run.

## 2. The model

Everything is stated on `Blanket.Blanketed`, on the theory's law read off histories (`Histories.ShownBy`, `ConsistentFamily`, `shownBy_determined_iff`), on its dependence notions (`DependsOnlyOn`, `GoAlike`, `Determined`), and on its webs and couplings (`Web.Admits`, `Web.ValuesThrough`, `Web.courseThrough`, `Web.AlikeThroughUpTo`, `Web.SelectsThrough`). No new model.

- A **family** of courses is a predicate on courses with their moves, as in `Histories`; its law is `ShownBy` of it, the least law admitting each course.
- A **reading** is a map `π : X → Parts I S A E` from the configurations of some law to four parts, applied at every step of every course. It is **fixed apart from the family** when it is given before the family is seen. A reading **reads the course**, not only the configuration, when a part holds which course and the step's index (a clock) or the course's future. It is **degenerate** when it puts everything in one part or nothing in any part (the constant and whole-configuration readings), and **sparse** when it bars a part from reading another that moves it.

**Modelling choices.**
- Discrete synchronous steps.
- Determined laws, as `Blanketed` is.
- The four parts of any types in `Type` (`Blanketed` takes one universe, and `Unit` and `Nat` occur among the parts); the part-by-part dependence notions universe-polymorphic.
- A law the same at every step, read by one map at every step. With a clock in the external part every law is the same at every step, which is why the clocked readings constrain nothing. Under the time-unrolled blanket (Virgo, Rosas and Biehl 2022), which compares courses from one start given the blanket's history, a single run constrains nothing.
- As in `Blanket`, the blanket is sparse coupling, not conditional independence of a stationary density (UE26 joins the two where it can).
- In the join, admission is given by the web and the couplings by level `obs` are supplied, as in `Testing`; with admission at the formation decided and `obs g` listed, the values of what couples in exist (`Web.listed_values`).
- The steps of `Assurance.ofMap` are read as `t = f s a`, and `course (n + 1)` unfolds to `step (course n)` (`Law.orbit`); a change of either reaches the module.

## 3. The laws

Core leaf `Becoming.BlanketCouplings`, importing `Becoming.Blanket`, `Becoming.Histories` and `Becoming.IdentificationRuns` (`Becoming.World` lies within `Blanket`'s closure). Built in scratch: 43 theorems in 76 declarations, every axiom report empty, no warning. No `simp`, `omega`, `decide`, `Parts.mk.injEq` or `Prod.mk.injEq`, which bring `propext`; parts and pairs compared by matching and `congrArg` (`parts_eq`, `pair_eq`, `unit_eq`). Every law below is near-definitional; what is new is C's classification (§5).

### A. A formation's couplings as its blanket (the general join, by construction)

Take a web `W : Web F C`, a formation `g`, couplings by level `obs` (supplied), and `value : Nat → (C → Nat) → O` with `W.ValuesThrough obs g value`. Take any model `update : M → O → A → M` and any policy `policy : M → O → A → A`. For the environment, take any state `X`, its levels `lev : Nat → X → (C → Nat)`, and any `env : O → A → Nat → X → X`, so the environment may read the formation's sensory and active parts, its act included.

1. **The coupling law** `couplingLaw : Blanketed M O A (Nat × X)`. The internal part moves by `update`, the active part by `policy`. The sensory part's next state is `value t (lev t x)` at external part `(t, x)`, and the external part moves to `(t + 1, env o a t x)`. The clock sits on the world's side; the internal and active parts read none.
2. **Its sensory course is the formation's own course through its couplings** (`sensory_course`): from `startAt m o a x`, with `ownLevels` the course's own level history, the sensory part at `n + 1` is `Web.courseThrough value (ownLevels …) n`, whatever the model, the policy and the environment. This is the definition read along the clock (`clock`).
3. **Blanket-alike exactly where alike through its couplings** (`blanket_iff_through`): two courses from one internal, sensory and active start and two environment states are blanket-alike before `n + 2` exactly where their own level histories are alike through `g`'s couplings up to `n`, the environment reading the act or not. Then their internal courses agree up to `n + 2` (`internal_through_couplings`, tight: `ThresholdDrain.any_model` uses the same count). In the closed loop both sides are read off one course, so there the law says that the sensory part carries exactly the coupling values and that the agent follows its sensory course; it does not say that the agent's course is fixed by a level history given in advance.
4. **In the open loop, every reading of its internal course is a selection through its couplings** (`openLoop`: `X := Nat → C → Nat`, `levelsAt`, `levelsStay`; `open_external`, `open_levels`): whatever the model and the policy, a reading of the internal course up to `n + 2` is a selection through `g`'s couplings up to `n` (`internal_selectsThrough`).
5. **A World formation, narrowly.** For every world `w` and formation `g` of it, with `obs` any couplings by level, admission at `g` decided and `obs g` listed, the values exist (`Web.listed_values`, `W := w.web`), so any model fed by what couples into `g` is the agent of such a law. The World's own case is the open loop at `w.web.level`; the closed loop is a model beside the World, whose own exchange is not written as an environment. The agent is a model, not the formation's own record. No instance theorem: `w.web` is a web (the review's probe checks that `internal_selectsThrough` at `W := w.web` typechecks, `world_selects`).
6. **`ThresholdDrain`'s join as its case** (`ThresholdCase.threshold_case`): `ThresholdDrain.blanket_iff_through`'s exact statement follows from `blanket_iff_through` at the witness's web, the supply as the environment state beside the step, through a course correspondence part by part (`ThresholdCase.corr`) and the own levels the draining supply (`ThresholdCase.own_eq`). Whether `ThresholdDrain`'s direct proof goes stays with `Blanket`'s owner at that module's next change.
7. **The formation's own record as the internal part** (the first design's A6) is not in the module. It stays on the page's §5 list and in the record's `next_delta`; 03 §1's reading becomes a theorem for its first half only (the sensory part is what couples into the formation).

**A construction, not a test.** With the step on the world's side and the environment arbitrary, the coupling law exists wherever the couplings give the values, the agent a model and not the formation's own record, and having it forbids nothing of the formation's course: A sits at C's first level, not its third. Its content is what the sensory part carries and that what the agent tells apart passes through it.

### B. The law a family shows, part by part

1. **A part of the next configuration depending only on a reading** (`PartDependsOnlyOn P π ρ`, universe-polymorphic): wherever two configurations agree under `π`, one move takes them to configurations agreeing under `ρ`. `DependsOnlyOn` is the case `ρ := id` and `GoAlike` the case `ρ := π`, both by definition; `Determined` is equivalent to the case where both are the identity (`partDependsOnlyOn_id_iff`). `PartConsistentFamily H π ρ` is the family's form.
2. **The law a family shows has such a part exactly where the family is consistent under the two readings** (`shownBy_partDependsOnlyOn_iff`), with the sub-relation lemmas `PartDependsOnlyOn.of_le` and `PartConsistentFamily.mono`.
3. **A law determined part by part** (`BlanketDetermined`, two cases, `agentReads → agentParts` and `worldReads → worldParts`; moves kept, partial or not), and `BlanketConsistentFamily`: `shownBy_blanketDetermined_iff`, and a family is admitted by some law determined part by part exactly where it is consistent part by part (`admitted_iff`). Such a law is determined (`BlanketDetermined.determined`).
4. **A blanketed law**, read as a process with the trivial move, is determined part by part (`blanketed_determined`); the step congruence of its courses (`blanketed_step_alike`) and its courses forming a family consistent part by part (`blanketed_courses_consistent`) follow. The converse, a blanketed law for every family consistent part by part, needs a next state chosen at every reading the family never shows, and is not stated.

### C. When the existence of a blanket constrains, at three levels

1. **Readings of the course.** The clocked reading (`clocked x : Blanketed α α Unit (ρ × Nat)`: the internal part a course's present value, the sensory part its next, the external part which course and the step) makes every family of courses the course family of a blanketed law (`clocked_course`), its clocked reading consistent part by part (`clocked_consistent`) though the family need not be consistent (`clocked_witness`, two courses parting at their first step). A reading of the course's future, with no clock and no label (`future : Blanketed α (Nat → α) Unit Unit`, the sensory part the future shifted each step), makes every course the internal course of a blanketed law (`future_course`). The step alone is not enough for a family (`clock_only_fails`: two courses alike at steps 0 and 1 and parting at step 2). For a single course the step suffices (`ρ := Unit`).
2. **Degenerate readings of the configuration.** The constant reading gives every family a law determined part by part (`const_consistent`). The whole configuration as the internal part gives one exactly to the families whose law is determined (`whole_iff`, with `shownBy_determined_iff`). An injective reading gives one only where the law is determined (`injective_consistent`), and not always there (`injective_converse_fails`: under the identity reading `ReadsExternal`'s run is consistent and not consistent part by part). Here "gives one" means a law determined part by part, partial and keeping the family's moves, not a `Blanketed`.
3. **A sparse partition fixed apart from the family can be refuted, even by one run.** Witness `ReadsExternal`: the internal part's next state is whether the external part, cycling through three values, is at its first; the sensory and active parts are trivial, the start `⟨false, (), (), first⟩`. Its internal course is false, true, false, false, true (`internal_course`, a computation). Under its own partition its one run is not consistent part by part (`not_consistent`), and it is the course of no blanketed law on these four types (`not_blanketed`); under the whole-configuration reading the same run is consistent part by part (`whole_consistent`), its run an orbit. `Hexagram.runsOrder_reads` makes the same kind of refutation for a line-by-line reading of a law the same at every step; this witness is that idea on four parts.

**What the laws give together.** Which blanket a thing has depends on how its parts are read. With parts that read the course, every family of courses has a blanket, and having one forbids nothing (C1). With a reading of the configuration, a degenerate one gives every family a law determined part by part (the constant one) or exactly the families whose law is determined (the whole configuration), so it refutes no family whose law is determined, and any injective reading, degenerate or not, requires determinedness without giving it (C2). A sparse partition fixed apart from the family, on a law the same at every step, can be refuted, and one run can do it (C3). No theorem says that every reading which fails is sparse: among families whose law is not determined the whole configuration refutes too (the landing review's finding 2). The line between C2 and C3 is the partition's content, not when it is chosen: the constant and whole-configuration readings are fixed apart from every family too. "Chosen after the family" is the reason C1 and C2 constrain nothing: whoever may pick the reading after seeing the family can pick one of their kinds. The general join (A) sits at the first level: its clock is on the world's side and its environment arbitrary.

## 4. What the page and chapters gain

- **The page's §3 gains nothing.** Its entries are statements of the literature that fail, read as guarantees. C's result forbids no sentence of the literature, and the principle fixes its partition on a given state space, by its dynamics or its density, not off courses (Ramstead and others 2023).
- **The page's §4** gains one line beside "the existence claim alone forbids nothing", in the theory's words: which blanket a thing has depends on how its parts are read. With parts that read the course every family has one; a degenerate reading of the configuration refutes no family whose law is determined; a sparse partition fixed apart from the family, on a law the same at every step, can be refuted, even by one run. Where a formation's couplings give the values of what couples into it, any model fed by them is, by construction, the agent of a blanketed law whose sensory course is the formation's own course through its couplings; the agent is a model, and having that law forbids nothing of the formation's course. The line notes the agreement with the critics on the partition's model-relativity (Bruineberg, Dołęga, Dewhurst and Baltieri 2022) and with the proponents' concession (Ramstead and others 2023). The "In brief" count of laws that forbid no sentence of the literature but state what it leaves open goes from four (UE26 made it four) to five.
- **The page's claim table:** the blanket row gains "which blanket: relative to the reading; any model fed by a formation's couplings a blanketed agent by construction (03 §1)". Standing: one result, three parts, near-definitional, the classification new.
- **The page's §5:** "a World formation in general as the agent of a blanketed law" becomes "a World formation's own record, rather than a model, as the internal part"; the closed loop is covered as a model beside the World.
- **03 §1:** "a World formation in general as the agent of a blanketed law is not shown" becomes the new record's sentence: any model fed by what couples into a formation, with any update, policy and environment, is the agent of a blanketed law whose sensory course is the formation's own course through its couplings, blanket-alike exactly where alike through them; a construction, which forbids nothing of the formation's course; the formation's own record as the internal part is not shown.
- **The blanket record:** its `does_not_show` entry narrows the same way, and its `next_delta` keeps the formation's own record as the internal part.
- **`Blanket.lean`'s header**, which lists both items as left out, is a docstring of a landed core module, so it changes only at that module's next change. The new module's header says that it answers both, and that `ThresholdDrain`'s join is A's case at the witness's web, checked.
- No "forbids" wording anywhere for C1 or C2, and no wording that puts A at C's third level ("such a partition", the `forbids_iff` analogy).

## 5. Boundary

- Determined laws only, as `Blanketed` is. B's iff holds for any process with moves; branching laws are not considered further.
- Which reading a thing's partition is read off is not derived. A takes the formation's couplings: admission, given by the web, and the couplings by level `obs`, supplied.
- A's environment is any `env`. The World's own exchange is not written as one, and the agent is a model, not the formation's own record.
- No conditional independence, density, free energy or weighting (UE26, `Blanket`'s weighting form and UE17 hold those).
- **Standing.** One result with three parts, all near-definitional: A is the general form of `ThresholdDrain.blanket_iff_through` for any web, model, policy and environment; B is the part-by-part form of `shownBy_determined_iff`; C's witnesses are built to show what they show. The delta is C's classification, the three levels at which a blanket's existence constrains, with the theorem that an injective reading of the configuration requires determinedness and a reading of the course does not. The point that a blanket depends on the partition chosen is in the literature in words; the single-run witness is not new in kind (`Hexagram.runsOrder_reads`). The record counts one result, not 43 theorems: lemmas (`parts_eq`, `pair_eq`, `unit_eq`, the `of_le` and `mono` lemmas, `clock`, `open_external`, `open_levels`, `suffix_apply`, `suffix_zero`, `internal_course`), corollaries (`shownBy_blanketDetermined_iff`, `blanketed_step_alike`, `clocked_consistent`, `internal_through_couplings`, `internal_selectsThrough`, `not_blanketed`, `injective_converse_fails`, `threshold_case`) and the laws above.

## 6. Names and placement

- **Module `Becoming.BlanketCouplings`.** Its main law is the formation's couplings as its blanket, and B and C say when a blanket constrains.
- **Placement.** The module is a leaf, under board rule 9's option (a). It needs `Web.ValuesThrough` and `Web.courseThrough` from `IdentificationRuns`, which lies above `Blanket` (outside its import closure), so `Blanket` cannot import it. Option (b), stating the join in `Blanket` with `ValuesThrough`'s body written out, would change a landed module and duplicate a definition's body (rule 3), so it is not taken.
- **Declarations**, as built, all in `Becoming.BlanketCouplings` (cited in full by records and indexes):
  - parts: `parts_eq`, `pair_eq`, `unit_eq`, `agentReads`, `agentParts`, `worldReads`, `worldParts`;
  - B: `PartDependsOnlyOn`, `partDependsOnlyOn_id_iff`, `PartConsistentFamily`, `shownBy_partDependsOnlyOn_iff`, `PartDependsOnlyOn.of_le`, `PartConsistentFamily.mono`, `BlanketDetermined`, `BlanketConsistentFamily`, `shownBy_blanketDetermined_iff`, `BlanketDetermined.of_le`, `BlanketConsistentFamily.mono`, `admitted_iff`, `BlanketDetermined.determined`, `blanketed_determined`, `blanketed_step_alike`, `blanketed_courses_consistent`;
  - A: `couplingLaw`, `startAt`, `clock`, `ownLevels`, `sensory_course`, `blanket_iff_through`, `internal_through_couplings`, `levelsAt`, `levelsStay`, `openLoop`, `open_external`, `open_levels`, `internal_selectsThrough`, and `ThresholdCase` (`value`, `lev`, `env`, `update`, `policy`, `band_congr`, `admits_iff`, `values`, `corr`, `own_eq`, `threshold_case`);
  - C: `clocked`, `clocked_course`, `clocked_consistent`, `parting`, `clocked_witness`, `partingLate`, `clock_only_fails`, `shift`, `suffix`, `suffix_apply`, `suffix_zero`, `future`, `future_course`, `readFamily`, `const_consistent`, `injective_consistent`, `whole`, `whole_iff`, `ReadsExternal` (`Three`, `next`, `isFirst`, `step`, `start`, `run`, `internal_course`, `not_consistent`, `not_blanketed`, `whole_consistent`), `injective_converse_fails`.
  - "Shows" is used only from a history to its law. "Autonomous" is not used for a law the same at every step, since `Blanket`'s header uses it for the principle's autonomous states.
- **Record** (home 03 §1, beside the blanket): "a formation's couplings as its blanket, and when a blanket constrains". The blanket record's `does_not_show`, `next_delta` and history are amended.
- **Lessons carried from UE26 and the probes:** full nested matches on the witness's enum (no wildcard), `rfl` on closed terms rather than `decide`, parts compared by matching (`parts_eq`), `unit_eq` by matching, a namespace's comment as a `/-! -/` block, unused binders as `_`.

## 7. The design review's findings, taken

The design review's ([REVIEW-UE27-DESIGN](REVIEW-UE27-DESIGN.md); probe in `review-probes/`, every axiom report empty).

| Finding | Where taken |
|---|---|
| 1 (high): law 2 answered a weaker question, the couplings on the wrong side | §1, §3 A (the general join, open and closed loop, the World in its own sense, the optional record part), §4, §5 |
| 2 (high): trivial readings always give a blanket | §1 Purpose, §3 C2 (`const_consistent`, `inner_iff`, `injective_consistent`), the three levels, §4 |
| 3 (high): the sixth statement does not belong in §3 | §4: §3 gains nothing; one line in §4 and the "In brief" count |
| 4: autonomy unnamed | §2 modelling choices; the clock and time-unrolled sentences |
| 5: the course/configuration distinction was prose | §3 C1 (`clocked_consistent` with its witness) and C2 (`injective_consistent`) |
| 6: the single-run witness is not new | §3 C3 and §5 cite `HexagramSequences.runsOrder_reads` |
| 7: a bespoke four-part notion; moves dropped | §3 B1 (`PartDependsOnlyOn`, two instances; moves kept) |
| 8: law 6 needed a lemma; `not_shown` free types | §3 B2 (the sub-relation lemma), B4, C3 (`not_blanketed` with the four types given) |
| 9: two attributions | §1, the criticism sentence rewritten as proposed |
| 10: placement under rule 9 | §6, option (a) with its reason |
| 11: laws 1 and 4 were cases | §3 C1 (`ofCourse` dropped, the single course as `ρ := Unit`), B3 (step congruence a corollary); the vacuity is the clock's |
| 12: names | §6: `BlanketCouplings`, `BlanketDetermined`, `BlanketConsistentFamily`, `step_alike`, `ReadsExternal`; "shows" one way |
| 13: universes and imports | §2 (`Type`), §3 (imports: `IdentificationRuns`, not `World`) |
| 14: boundary sentences | §5: the branching sentence replaced, the standing as proposed; C3 gives the start |
| 15: page, chapter and record texts | §4 |

## 8. The Lean review's findings, taken

The review of the scratch Lean ([REVIEW-UE27-LEAN](REVIEW-UE27-LEAN.md); probe in `review-lean/`, every axiom report empty).

| Finding | Where taken |
|---|---|
| 1 (high): the join is a construction, not a test | module header; §1 Purpose 1, §3 A ("a construction, not a test"), the three levels, §4 (no "such a partition", no `forbids_iff` analogy) |
| 2: A near-definitional; the closed loop reads both sides off one course | module header; §3 A2, A3; §5 standing |
| 3: "every World formation" narrowly; `obs` supplied | module header and modelling choices; §2, §3 A5, §5 |
| 4: `ThresholdDrain` its case through a correspondence (checked) | module: `ThresholdCase.threshold_case`; §3 A6 |
| 5: level 2 misstated; the line is sparsity, not timing | module header and `injective_converse_fails`; §1 Purpose 2, §2, §3 C2, C3, the three levels, §4 |
| 6: "read the course", not "read the step" | module: `future`, `future_course`, `clock_only_fails`; header; §2, §3 C1 |
| 7: "has a blanket" in C2 is a law determined part by part | module header (C2 sentence); §3 C2, §4 |
| 8: two theorems one step weaker than the Lean gives | module: `internal_through_couplings`, `internal_selectsThrough` at `n + 2`; §3 A3, A4 |
| 9: names | module: `agentParts`, `worldParts`, `whole`, `clocked`, `levelsStay`, `openLoop`, `internal_selectsThrough`, "a law the same at every step", Lean names cited; §6 |
| 10: `Blanketed.*` outside `Blanket`'s namespace | module: `blanketed_determined`, `blanketed_step_alike`, `blanketed_courses_consistent`; §6 |
| 11: the three "cases" of `PartDependsOnlyOn` | module: docstring, `partDependsOnlyOn_id_iff`, universe-polymorphic section; §3 B1 |
| 12: A6 absent | §3 A7, §4 (03 §1, §5 list, the blanket record) |
| 13: "forbids" docstring; "refutes" heading | module: `clocked_witness` docstring, section heading "can refute" |
| 14: hygiene | module: `open_external` docstring, `ofMap`'s orientation and `Law.orbit` in the modelling choices, `internal_course` "by computation"; §2, §5 (not counted as a law) |
| 15: standing | §5: one result, three parts, near-definitional, the classification the delta |

## 9. The landing review's findings, taken

The review of the landing texts and records as rehearsed on main ([REVIEW-UE27-LANDING](REVIEW-UE27-LANDING.md)). Every finding is taken in the kit (`texts_ue27.py`, `make_records_ue27.py`, `integrate_ue27.py`, `study_ue27.txt`), and finding 7 also in the module's header (wording only, rebuilt).

| Finding | Where taken |
|---|---|
| 1 (high): the page's §4 made the formation the agent, without the hypothesis | the page's §4: the agent any model fed by what couples in, where the couplings give the values; not the formation's own record |
| 2 (high): "only a sparse partition can be refuted" contradicts `whole_iff` | the record's statement, the page's In brief and §4, the study, the regions note, the record's `related`; §3 above: a degenerate reading refutes no family whose law is determined |
| 3: "every formation" without the hypothesis elsewhere | 03's blanket reading, the page's "Where the two agree", §2, the claim table, Standing, 08 §8, the record's AI reading, the study; the module's header |
| 4: the line drawn at timing | 03's Reading, the study's Readings, the record's `related` |
| 5: the In brief list did not read as five | the fourth item's "and" dropped, its colon made "as"; the fifth item as the chapter states it |
| 6: four works cited for one point | the record's `correspondence`: Bruineberg and others for the partition, the rest as the wider criticism |
| 7: the injective reading grouped as degenerate | 03, the record's law, the study, the root bullet, the checker; the module's header |
| 8: the single-run witness stated of every run | 03, the record's counterexample, the checker: the run named |
| 9: "the blanket's form" unglossed | the page (glossed at first use), the root bullet, the READMEs, the checker, FEP-INTEGRATION: "a law determined part by part" |
| 10: the page's §4 sentence | rewritten in four sentences |
| 11: 03's Reading claimed the theory answers which blanket | 03's Reading and the study: the couplings give one reading, not derived |
| 12, 13: the blanket section's last sentence and reading | 03 |
| 14, 15: the new theorem's label, bounds, citations and length | 03: World and any type, n + 2 in the open loop, one start, both maps, "which may be partial", "exactly", `future_course` apart, 06 §5.5, two paragraphs |
| 16: the page's §1 cited the wrong declaration | `sensory_course` with `blanket_iff_through`, labelled *World* |
| 17: Standing listed the join as new | the page's Standing and claim table |
| 18: small faults in the record | laws 0, 3, 4, 8, 10; `validation_scope.zh` counts; `correspondence`; the blanket record's `related` |
| 19: the package texts | the root bullet, the README rows, FEP-INTEGRATION |
| 20: 08 §8's dangling phrase | 08 §8 names `Hexagram.runsOrder_reads` and 06 §5.5 |
| 21: this review not named | the record's `validation_scope`, the study's Evidence and reviews, this section |
| 22: the self-evidencing row left stale | the page's claim table |

## 10. Order

1. The design, its review and the fixes (done, 31 October).
2. Scratch Lean, its axiom reports, the closed-loop case, a review of the Lean and the fixes (done, 1 November).
3. The record and texts on the page as UE26 leaves it, and a landing kit on UE26's pattern; a rehearsal on main.
4. One core slot from the coordinator, after BD2, EL's core Lean and DU.
