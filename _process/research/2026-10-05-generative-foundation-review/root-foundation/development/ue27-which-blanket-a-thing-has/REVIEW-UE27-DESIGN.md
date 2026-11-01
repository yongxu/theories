AI-written by an independent reviewer, 31 October 2026

# Review of the UE27 design (which blanket a thing has; a World formation as the agent of a blanketed law)

Read: [DESIGN.md](DESIGN.md) at `d6eb33937`; `Blanket.lean`, `Histories.lean`, `Laws.lean`, `World.lean`, `Runs.lean`, and, for the checks below, `Mechanism.lean` (`DependsOnlyOn`), `Learning.lean` (`Lumped`), `Testing.lean` and `Selection.lean` (`Web.AlikeThrough`, `Web.SelectsThrough`), `IdentificationRuns.lean` (`Web.ValuesThrough`, `Web.courseThrough`, `Web.selectsThrough_iff_prefix`) and `HexagramSequences.lean` (`Reads`, `runsOrder_reads`); the blanket record (JSON), 03 §1, the principle's page §3–§5, UE18's [NOTE](../ue18-blanket-and-existence/NOTE.md) and the board rules. The literature was checked at its abstracts and, for Ramstead and others (2023), its §2 and its definition of the partition.

**Probe.** [review-probes/tree/Becoming/UE27ReviewProbe.lean](review-probes/tree/Becoming/UE27ReviewProbe.lean), built with `scratch_build.py` ([probe-2.log](review-probes/probe-2.log)): 13 theorems in 24 declarations, every axiom report empty, three unused-variable warnings, no `simp`, `omega` or `decide`. ([probe-1.log](review-probes/probe-1.log) is the first attempt, with four elaboration errors in the probe's own proofs, not in the design.) It checks (A) law 5 with moves and its corollary that such a law is determined; (B) the trivial reading of finding 2; (C) the stronger law 2 of finding 1; (D) the witness `ReadsWorld` at steps 2 and 3, and that the same run has a blanket under the whole-configuration reading.

**Laws 1–6 worked by hand.** Each is true as stated, with the caveats of findings 2, 4 and 8.
- Law 1: from `⟨x 0, x 1, (), 0⟩` one step gives `⟨x 1, x 2, (), 1⟩`; by induction (the orbit's successor is `step` of the previous point, definitionally) the course at `n` is `⟨x n, x (n + 1), (), n⟩`. Law 3 likewise with `(r, n)`.
- Law 4: `course (n + 1)` is `step (course n)` by definition, so it is `congr3` on each part.
- Law 5: true, and it is the part-by-part analogue of `shownBy_determined_iff`: probe (A), `shownBy_blanketDetermined_iff`. A law so blanketed is determined: two steps from one configuration under one move meet both premises, so the four parts of the ends agree, and the ends are equal by matching on `Parts` (probe `parts_eq`, `BlanketDetermined.determined`). Nothing more is needed. Avoid `Parts.mk.injEq` and `simp`, which bring `propext`.
- Law 6 and the witness: from `⟨false, (), (), first⟩` the internal course is false, true, false, false, true (probe `internal_course`); steps 2 and 3 agree on the internal, sensory and active parts, and their successors part (probe `not_consistent`). Nothing needs classical logic or decidability: closed terms reduce by `rfl`. On universes: `Blanketed` puts its four parts in one universe, so `α` and `ρ` must be in `Type` (finding 13).

## Findings

### 1. High: law 2 answers a weaker question than the one the record asks, and puts the couplings on the wrong side

**Where.** DESIGN §1 (second bullet), §3 law 2, §4 first and third bullets; the record's `next_delta` and `does_not_show`; 03 §1; UE18 NOTE §3 and §4.

**What is wrong.** The record's next delta, "a World formation in general as the agent of a blanketed law, its sensory course its own course", is quoted from UE18's NOTE §3, where it reads in full: "its sensory course its own course (`Web.selectsThrough_iff_prefix`) and its environment the levels under the others' fixed exchange: the join is proved for the witness only, and the general one is an item of its own". So "its own course" is `Web.courseThrough`, the formation's own course through its couplings (what couples into it at each step), and "the join" is the general form of `ThresholdDrain.sensory_is_admission` and `ThresholdDrain.blanket_iff_through`. 03 §1 places the open item right after the witness's join, and its reading says the same: "a formation's support and observed levels are its sensory states, what it keeps of them its internal states". The design's law 2 is a different and weaker thing:
- `World.formation_shown` is law 1 at one particular `x`. It is a one-line instance, so it adds no theorem.
- It puts the formation's whole record, its requirements included, into the internal part. So the couplings sit inside the agent, the opposite of the reading the item claims to answer.
- Its "sensory course its own course" means the internal course one step ahead. That is a pun on the record's words, not the record's sense.
- Declaring the delta answered, and deleting it from §5 of the page, would tell readers that the blanket-as-couplings join is shown in general. It is not.

**Fix.** Replace law 2 with the general join, checked in probe (C):
- *Hypotheses.* A web `W : Web F C`, a formation `g`, couplings `obs`, and `value : Nat → (C → Nat) → O` with `W.ValuesThrough obs g value`. Such a `value` exists where admission at `g` is decided and the conditions coupled in by level are listed (`Web.listed_values`). Also any model `update : M → O → A → M` and any policy `policy : M → O → A → A`, all types in `Type`.
- *The law.* `couplingLaw : Blanketed M O A (Nat × (Nat → C → Nat))`. The external part is the step and a level history, moving `(t, l) ↦ (t + 1, l)`. The sensory part's next state is `value t (l t)`. The internal part moves by `update`, the active part by `policy`.
- *Laws.*
  - (a) `sensory_course`: from `startAt m o a l` (external `(0, l)`), the sensory part at `n + 1` is `Web.courseThrough value l n`. Its sensory course is its own course through its couplings.
  - (b) `blanket_iff_through`: from one internal, sensory and active start, the courses under `l` and `l'` are blanket-alike before `n + 2` exactly where `W.AlikeThroughUpTo obs g l l' n`. This is the general form of `ThresholdDrain.blanket_iff_through`, whose witness is the case `value t x := Nat.blt 0 (x ())`, `l := fun t _ => e - t`, up to how the external part is represented.
  - (c) `selectsThrough`: whatever the model and the policy, every reading of the internal course up to `n + 1` is a selection through `g`'s couplings up to `n` (`Web.SelectsThrough`).
- *World instance.* `W := w.web` and `l := w.web.level`, for every world and every formation with decided admission and listed couplings. This is "a World formation in general as the agent of a blanketed law, its sensory course its own course", in the record's sense. It turns 03 §1's reading "the principle's blanket names the couplings" into a theorem joining the two records of 03 §1.
- *What it leaves.* The environment here is not moved by the formation's act; that is the open-loop case, as in the witness. The closed-loop form, with external `(t, x)` moving to `(t + 1, env t x a)`, `env` the levels after the others' fixed exchange and the formation's act, keeps (a) and (b) for the courses' own level histories. I checked that by hand, not in Lean. Either prove it, or keep in §5 a narrowed entry: "a World formation whose own act moves the levels, as the agent of a blanketed law; and its own record, rather than a model, as the internal part".
- *Optional stronger part.* For the formation's record as the internal part, apply law 5 at the reading π_f that DESIGN §5 already names: record internal, coupling values sensory, draws active, the rest external. Add a World witness, a formation whose level another formation's give moves through a condition not coupled into it. That would state when a World formation's own record is a blanketed agent: exactly where what moves it couples into it.
- *Keep law 1* as the reason a course-read partition is no constraint, but do not present it as the answer to the delta.

### 2. High: "read off its configurations by one map, it has one exactly where the agent never parts" overclaims; trivial readings always give a blanket

**Where.** DESIGN §1 Purpose; §3 law 6 and "What the laws give together"; §4 second bullet.

**What is wrong.** Laws 5–6 hold for a reading `π` fixed before the family is seen. Over readings chosen afterwards, the existence of a configuration-read blanket forbids nothing beyond determinedness:
- With `π` constant, every family is consistent part by part (all readings and all successors are equal).
- With the whole configuration as the internal part and the other three parts `Unit`, a family is consistent part by part exactly where it is consistent (probe `inner_iff`). So, by `shownBy_determined_iff`, exactly where the law it shows is determined.
- The design's own witness has such a blanket: its one run is an orbit, so it is consistent part by part under the whole-configuration reading (probe `ReadsWorld.inner_consistent`).

"What forbids is the partition read off configurations, not the course" (law 6) is therefore false as worded. What forbids is a partition fixed apart from the run, together with autonomy (finding 4). The trivial blanket is also a standard objection in the literature: everything has a blanket if the whole system may count as internal.

**Fix.**
- Quantify every sentence of law 6 and of the summary over a reading fixed apart from the family.
- Add three laws (the first two are one-liners; the second is checked):
  - `const_consistent`: under a constant reading every family is consistent part by part.
  - `inner_iff`: under the whole-configuration reading, consistent part by part ⟺ `ConsistentFamily`.
  - `injective_consistent`: under an injective reading, consistent part by part → `ConsistentFamily`, via `BlanketDetermined.determined` and injectivity.
- Restate "What the laws give together" in three levels:
  - with the parts allowed to read the step (a clock), every family has a blanket;
  - with the parts read off configurations by a map chosen after the family, a family has one exactly where the law it shows is determined (the trivial blanket), and under a constant map always;
  - with a map fixed apart from the family, a family has one exactly where its agent never parts from equal readings, which one run can refute.

### 3. High: the candidate sixth placed statement does not belong in §3 and is unfair to the principle as worded

**Where.** DESIGN §4 second bullet; the page's §3 heading and "In brief".

**What is wrong.**
- The page's §3 is "What the theory forbids that the literature claims". Each of its five entries is a statement of a paper that fails, read as a guarantee, by a law the principle does not state. The candidate says the opposite: under the course-read partition, "whatever persists has a Markov blanket" holds of everything. Under a fixed partition it forbids a parting agent, which is no sentence of the literature. Counting it as a sixth forbidden statement is a category error.
- The principle does not read partitions off courses. Ramstead and others (2023) define the particular partition on a fixed state vector, by sparse coupling of the flow or by conditional independence under a steady-state density. A partition whose sensory part holds the course's next state and whose external part holds a clock is not a partition of any given system's states. So "read as a guarantee about the thing, holds of every course" reports a reading the principle never makes.
- As finding 2 shows, even the configuration-read form forbids nothing once the map may be chosen afterwards.

**Fix.**
- Do not add it to §3.
- If the page gains anything, add one line to §4 beside "the existence claim alone forbids nothing", or move the "In brief" count of laws that "forbid no sentence of the literature but state what it leaves open" from three to four. Suggested wording: "Which blanket a thing has depends on how its parts are read. If the parts may read the step, or are read by a map chosen after the course, every course or every determined law has one; only a partition fixed apart from the course, on a law that is the same at every step, forbids, and then a single run can refute it. This agrees with the principle's critics on the partition's model-relativity (Bruineberg, Dołęga, Dewhurst and Baltieri 2022) and with its proponents' concession (Ramstead and others 2023)."
- In the "Claim by claim" table, the blanket row may gain "which blanket: relative to the reading (03 §1)".

### 4. Medium: the single-run constraint rests on an unnamed modelling choice, autonomy

**Where.** DESIGN §2 Modelling choices; §3 law 6; §5.

**What is wrong.** Comparing steps 2 and 3 of one run needs one law at every step and one reading at every step. Under the time-unrolled blanket (Virgo, Rosas and Biehl 2022, already cited by `Blanket`), the condition compares courses from one start given the blanket's history. A single run is then never refuted: there is only one course from its start. Law 1's clock is exactly the step that turns an autonomous law into one depending on the step. So what the design calls "read off the course" is, formally, "the law may depend on the step, through a clock in the external part, and the sensory part may carry any function of it".

**Fix.**
- Add to §2: "the law is the same at every step (autonomous), and the parts are read by one map at every step. With a clock in the external part every law is autonomous, which is why laws 1–3 forbid nothing; under the time-unrolled reading, which compares courses from one start, a single run forbids nothing."
- Rename the distinction in §3 accordingly. "A partition read off the course" becomes "parts that read the step (a clock) or the course's future".

### 5. Medium: the distinction between reading off the course and reading off configurations is prose; it can be a theorem

**Where.** DESIGN §2 third bullet; §3 "What the laws give together".

**What is wrong.** Laws 1–3 build explicit `Blanketed` structures on an enlarged state, while laws 5–6 speak of a fixed `π` on the family's own configurations. No statement compares the two, so the contrast exists only in prose.

**Fix.** State two laws:
- (i) `clocked_consistent`: for every family `x : ρ → Nat → α`, the clocked reading `n ↦ ⟨x r n, x r (n + 1), (), (r, n)⟩` is consistent part by part, and this holds for an inconsistent family too. Witness: two courses from one configuration that part at their first step.
- (ii) `injective_consistent` of finding 2: a family read by an injective map and consistent part by part is consistent.

Together they say exactly how the two differ: a configuration-read blanket implies determinedness, a clocked one does not. Laws 1 and 3 then follow from law 5 at the clocked reading, together with the explicit structure `ofFamily`.

### 6. Medium: the single-run witness is not new in the core

**Where.** DESIGN §5 Standing ("new are … the single-run witness").

**What is wrong.** `HexagramSequences` already shows one course forbidding a sparse reading of an autonomous law. It states that the received order is "not the orbit of any law that reads less than the whole configuration" (`runsOrder_reads`, `runsOrder_blind_not_lumped`, `ringRule_not_runsOrder`), with `Reads next q k` (which line of the next configuration reads which line) established from a list of steps (`reads_of_readsb`). Law 6's witness is that idea on four parts.

**Fix.** Cite it in §5 and in the module header, and drop "the single-run witness" from what is new. If law 4 is stated as "a part of the next configuration reads only the parts it is given" (finding 7), say in prose that `HexagramSequences.runsOrder_reads` is the same refutation for the line-by-line reading. No second proof or instance theorem is needed (rule 9).

### 7. Medium: law 5 sets up a bespoke four-part notion beside existing ones; state it on a two-projection form, with moves

**Where.** DESIGN §3 law 5; §6 names.

**What is wrong.**
- `ReadsBlanketed` is "the part ρ of the successor depends only on the projection π of the source", taken twice: π the internal, sensory and active parts with ρ the internal and active parts; π the sensory, active and external parts with ρ the sensory and external parts. The core has the cases ρ = identity (`DependsOnlyOn`, `Mechanism`), π = ρ = identity (`Determined`) and π = ρ (`GoAlike`), plus the functional form `Learning.Lumped`, which `Blanket.through_reading` uses. A four-part-only notion is a parallel definition (rule 3).
- The design drops moves (trivial move). `Determined` and `ConsistentFamily` compare steps under one move, so the "part-by-part form of `shownBy_determined_iff`" is exact only with a same-move hypothesis.

**Fix.**
- Define once, for any process, the relation "the part `ρ` of the next configuration depends only on `π`": `∀ s s' a u u', π s = π s' → P.step s a u → P.step s' a u' → ρ u = ρ u'`. Name it in the core's vocabulary, for example a two-projection `DependsOnlyOn`.
- Prove its `ShownBy` iff once, with the family condition carrying `m i = m' j`.
- Make the blanket's condition the conjunction of its two instances. `BlanketDetermined.determined` then follows from the two instances covering all four parts.
- With moves, the probe's (A) is exactly this shape and passes. Mentioning `DependsOnlyOn` and `Determined` as cases in prose is enough; no instance theorems (rule 9).

### 8. Medium: law 6 is not "no new proof", and its iff is for laws blanketed in their reading, not for `Blanketed` structures

**Where.** DESIGN §3 law 6; "What the laws give together"; §5 third bullet.

**What is wrong.**
- "Is the agent's course of a law blanketed in its reading" means some law determined part by part admits every read course. The iff with consistency part by part needs one more lemma, that a sub-relation of a law determined part by part is determined part by part, together with `shownBy_le_iff`.
- For a `Blanketed` structure only the "only if" direction holds. The "if" direction needs a next state chosen at every unseen reading, which the design rightly leaves out. Yet the summary says "it has one exactly where", which reads as a `Blanketed` structure.
- `ReadsWorld.not_shown` is unstated. If it is `¬ ∃ (S E : Type) (b : Blanketed Bool S Unit E) x, …` with the types free, it is false by law 1.

**Fix.**
- Add the sub-relation lemma, and say law 6 is law 5 with it.
- Word the summary "has a law blanketed in its reading exactly where …; a `Blanketed` structure only where …".
- Fix `not_shown` with all four types given: `¬ ∃ (b : Blanketed Bool Unit Unit Three) x, ∀ n, b.course x n = run n`.

### 9. Medium: two literature attributions do not say what the design has them say

**Where.** DESIGN §1, third paragraph.

**What is wrong.** The sentence "the criticism … turns on the first: which partition is the blanket, and whether the existence of one says anything about the system" cites three works, of which only one fits:
- Bruineberg, Dołęga, Dewhurst and Baltieri (2022) fit: instrumental Pearl blankets against realist Friston blankets, and the partition's dependence on a model.
- Raja, Valluri, Baggs, Chemero and Anderson (2021) argue that the principle's scope is narrower than claimed. The blanket formalism extends Bayesian modelling to any domain (the "trick"), and active inference presupposes the perception and action it is said to explain. That is near "existence says nothing about the system", but it is a scope argument, not a statement about partitions.
- Biehl, Pollock and Kanai (2021) show that the blanket's various definitions are not equivalent, give a counterexample to the free energy lemma as stated, and question the Bayesian reading. That is not "which partition".

**Fix.** Write: "The criticism turns on how a blanket is fixed and what its existence says: Pearl's blankets, fixed within a model, against Friston's, read as the thing's boundary (Bruineberg, Dołęga, Dewhurst and Baltieri 2022); a formalism applying to any domain and so narrower as an account of life and mind than claimed (Raja, Valluri, Baggs, Chemero and Anderson 2021); and blanket definitions that are not equivalent, statistical against dynamical (Biehl, Pollock and Kanai 2021)."

### 10. Medium: with the stronger law 2, placement must answer rule 9

**Where.** DESIGN §6 placement; board rule 9.

**What is wrong.** Finding 1's join generalizes `ThresholdDrain.sensory_is_admission` and `ThresholdDrain.blanket_iff_through`. As a leaf importing `Blanket`, it lands beside them, and `Blanket` cannot import it. It needs `Web.ValuesThrough` and `Web.courseThrough` from `IdentificationRuns`, which lies outside `Blanket`'s import closure (54 modules; `IdentificationRuns` has 85).

**Fix.** Choose and record one of:
- (a) the leaf, whose row says why it is a leaf: it needs `IdentificationRuns`, which lies above `Blanket`. Say in prose that the witness's join is its case at the witness's web, with no instance theorem. At `Blanket`'s next change, its owner decides whether `ThresholdDrain`'s join moves.
- (b) the join stated in `Blanket` itself, with the hypothesis written as `ValuesThrough`'s body on `Web.Admits` and `obs`, which `Blanket` already reaches. `ThresholdDrain.blanket_iff_through` is then proved from it and its direct proof goes. This is a change to a landed module, for its owner on the board, and it duplicates a definition's body (rule 3).

I lean to (a). `Becoming.World` need not be imported (it is in `Blanket`'s closure); `IdentificationRuns` must be.

### 11. Low: laws 1 and 4 are cases of laws 3 and 5, and law 1's vacuity is the clock's

**Where.** DESIGN §3 laws 1, 3, 4; §5 Standing.

**What is wrong.**
- `ofCourse` is `ofFamily` at `ρ = Unit`, with external `Unit × Nat` in place of `Nat`.
- `reads_alike` is `Blanketed.readsBlanketed` applied to `course (n + 1) = step (course n)`.
- What makes laws 1–3 forbid nothing is the clock, as for every kept history (`Law.withHistory`, `keepHistory`, and `Histories`' reading on `Run.keepHistory_shown`), with the sensory part carrying a function of it. The blanket only routes it.

**Fix.**
- State `ofFamily` and derive `ofCourse` as a one-line corollary, or keep `ofCourse` only as a definition used by the World text.
- State law 4 as a corollary of `Blanketed.readsBlanketed` (or of finding 7's form).
- Add to §5: "the vacuity is the clock's, as for every kept history; the blanket adds only that the clock and the next state sit on the external and sensory sides".

### 12. Low: names

**Where.** DESIGN §6. A search of the Becoming folder finds no clash for any proposed name (`world_reads_alike` in `Interleavings` is in another namespace).

**What is wrong, and the fix, name by name.**
- `BlanketShown` and "shows". `Shown` and `ShownBy` are the least law admitting a history, on its own configurations. `ofCourse` is one law on an enlarged state, not the least of anything. The design also uses "shows" both ways (§2: "a blanketed law shows a course"; law 1: "a course shows a blanketed law"). Use "shows" only from history to law. For the module, a name stating its content, for example `Becoming.BlanketReadings` or `Becoming.BlanketCouplings` if finding 1 is taken.
- `ReadsBlanketed`: "in its reading" names a map the definition does not contain. Use `BlanketDetermined`, the part-by-part `Determined`, or finding 7's two-projection name.
- `BlanketConsistent` becomes `BlanketConsistentFamily`, after `ConsistentFamily`, and `shownBy_readsBlanketed_iff` becomes `shownBy_blanketDetermined_iff`.
- `reads_alike` (law 4 is congruence of the step, not a reading) becomes `step_alike`, or `agent_step_alike` and `world_step_alike` beside `agent_through_sensory` and `world_through_active`.
- `formation_shown`: drop with law 2. Finding 1's names are `couplingLaw` (or `ofCouplings`), `sensory_course`, `blanket_iff_through` and `selectsThrough`.
- `ReadsWorld`: within `Blanket` "world" means the external part, but beside `Becoming.World` and a World instance it misleads. Use `ReadsExternal`.
- `ofCourse` and `ofFamily`: acceptable; `clocked` would say what makes them vacuous.

### 13. Low: universes and imports

**Where.** DESIGN §3 laws 1–3; §6.

**What is wrong.** `Blanketed (I S A E : Type u)` takes one universe. With `Unit` and `Nat` among the parts, `α` and `ρ` must lie in `Type`; for a general universe the parts would need `PUnit` and `ULift`. The World record (`Nat × Prop × (R → Prop) × (R → Nat) × (R → Prop)`) is in `Type`, so nothing breaks, but the statement should say so.

**Fix.** Write "for `α ρ : Type`" in laws 1 and 3. Drop `Becoming.World` from the imports; add `Becoming.IdentificationRuns` for finding 1.

### 14. Low: boundary and standing sentences that say more than any law

**Where.** DESIGN §5 first and last bullets; §3 law 6.

**What is wrong.**
- "A law with branching has the same statement for its determined part": no "determined part" is defined in the core.
- "New are its statement on the theory's laws read off histories": laws 1–3 are not stated on `ShownBy`.
- The witness's start is not given, and the course "false, true, false, false, true" depends on it.

**Fix.**
- Drop the branching sentence, or replace it with "the iff of law 5 holds for any process with moves (finding 7); branching laws are not considered further".
- Write "new are the part-by-part iff on the law read off histories (law 5), the general join of a formation's couplings and its blanket (finding 1), and the levels of finding 2".
- State the start `⟨false, (), (), first⟩`.

### 15. Low: page, chapter and record texts after the fixes

**Where.** DESIGN §4.

**Fix.**
- §5 of the page: replace "a World formation in general as the agent of a blanketed law" with the narrowed remainder of finding 1, unless the closed-loop form and the formation's record are proved.
- 03 §1: "a World formation in general as the agent of a blanketed law is not shown" becomes, for example: "any formation of any web, its admission decided and its couplings listed, with any model and policy, is the agent of a blanketed law whose sensory course is its own course through its couplings, blanket-alike exactly where alike through them ([record])". The closed-loop remainder stays open.
- The blanket record: its `does_not_show` entry narrows the same way, and its `next_delta` keeps the closed-loop part and the formation's record as the internal part.
- No "forbids" wording anywhere for the course-read result (finding 3).

## Verdict

Three high, seven medium and five low findings (fifteen in all). Laws 1–6 are true as stated, and the probe confirms that law 5, its determinedness corollary and the witness need nothing beyond the pure core. As drafted, though, the item is mostly a wrapper. Laws 1–4 are a clock construction and congruence; law 6 is law 5 at a map; and law 2, the half the record actually asks for, is a one-line instance that answers a different question. Lean may start after the fixes, under board rule 7 (once UE26 has landed), provided that:
- law 2 is replaced by the general join of finding 1, already checked in the probe with empty axiom reports;
- the configuration-read claims are quantified over a reading fixed apart from the family, with the trivial-reading and injective-reading laws (findings 2 and 5) and autonomy named (finding 4);
- the candidate sixth statement is kept out of the page's §3 (finding 3).

With those, the item makes a real advance: it turns 03 §1's reading that the blanket names the couplings into a theorem for every formation, and states exactly when the existence of a blanket constrains anything.
