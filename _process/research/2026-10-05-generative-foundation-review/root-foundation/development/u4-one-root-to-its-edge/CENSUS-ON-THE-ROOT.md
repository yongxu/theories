# The census on the root (U4c, design)

1 November 2026. AI-written design for the next step that the record [one-root-to-its-edge](../../../../../../theories/becoming/results/records/one-root-to-its-edge.md) names first: a root form for the census rows. It is revised after an independent review ([REVIEW-U4C.md](REVIEW-U4C.md)), all thirteen of whose findings are taken, and again after the reviewer's re-check of the revision, all ten of whose findings are taken (§8). Its record and chapter texts were reviewed after that ([REVIEW-U4C-RECORD.md](REVIEW-U4C-RECORD.md)), all five should-fix and eight minor findings taken, and the reviewer's second pass, its blocking finding and six others taken (§9). The laws and their cases are checked in scratch Lean outside the package ([u4c-scratch](u4c-scratch/), §6). Reading time: §0 in about five minutes, the whole in about twenty.

## 0. The proposal in brief

- **The two census rows** stand at counting, below the grammar:
  - `Listed.coming_of_ceasing`: where what holds is listed at each step, each once, ceasing to be at arbitrarily late steps needs coming to be at arbitrarily late steps;
  - `CensusWebs.keep_pace`: over a stretch, a fixed family's arisings and ceasings, wherever they are counted, differ by at most its members.
- **What is proposed.** Three laws for GrammarLaws' census section, after `«后者在后则所列亡者亡»`:
  - **the census of a step, counted, one side** (`«定后则后并亡不过前并生»`). Under a continuation that fixes successors, the units listed after a step with those a test marks as ceasing are at most the units before with those a test marks as arising. The tests ask only that a unit marked as ceasing has no successor among the units after, and that a unit after not marked as arising has a predecessor among the units before, as far as can be refuted. No decision of identity is used.
  - **its mirror** (`«定前则前并生不过后并亡»`), the same law at the converse, under a continuation that fixes predecessors.
  - **the census of a run** (`«定后前者在前则亡屡者生屡»`). On the root's own beginnings and endings (`«生»`, `«亡»` of `«续» R E`): where endings recur among the units listed at each step (`«屡»`), beginnings recur among the units listed after a step. It needs the units after each step listed once, nothing splitting, every predecessor of a unit listed after a step listed before it, and the beginnings and endings of listed units decided by tests.
- **What they reach.**
  - `Listed.coming_of_ceasing` becomes a case of the census of a run. The units are a member's occurrences along its steps (`Steps.along`), under the two-valued class of the determination, and coming to be and ceasing to be are a beginning and an ending there. It moves from counting to derived.
  - `Listed.across_at` and `Web.Census.balanceFrom_at` become cases of the two halves at one step. So the census laws of Population that go through `across_at`, and the seven laws of Identity's `Counting` section that go through `balanceFrom_at`, rest on the root's census of a step.
  - The count of HE2's census of a step is a case of the two halves, the tests read off its decision `k`. So the new law generalizes the census of a step below it rather than standing beside it (DESIGN-BOUNDARY §2, rule 9).
- **What it does not reach.**
  - `CensusWebs.keep_pace` stays at counting. The reason is not that its counts are relations, since its conclusion is decided and tests can be had. It is a two-sided bound over a stretch, on a fixed family that may list a member twice, and today its proof goes through the balance anchor (§4).
  - The covering laws are not cases (§3.5): Locality's `coming_of_ceasing_covered`, with `World.arising_of_ceasing` and `Web.StandingCensus.coming_of_ceasing` through it, and Identity's three, which go by lineages. Nor is `Counts.listed_across` re-proved, though it is a case by content.
- **Standing.** `Listed.coming_of_ceasing` is derived, on the precedent of `Law.drawn_iff_not_returns`: its law's hypotheses are met at the model by support lemmas. That holds once the law's proof lies wholly on the root and the row's proof reaches no balance anchor (D5). Both are arranged (§5).
- **What it costs.** It lands as a patch series on top of OU7's kit, applied by one stage of OU7's landing script, so one core run and one receipt cover both (§6).

## 1. What the root and the model already have

- **The census of a step, on the grammar** (GrammarLaws, HE2):
  - `«定后定前则前并生对后并亡»`: under a continuation decided by `k` that fixes successors and predecessors, the units before with the arising pair one to one with the units after with the ceasing;
  - `«前者在前则所列生者生»` and `«后者在后则所列亡者亡»`: the census's arising and ceasing are the grammar's beginnings and endings, where predecessors stand before and successors after.

  No grammar law joins a run's beginnings and endings across its steps. `«对之程»` and `«程守数当且仅当可对»` join per-step pairings over a stretch, not beginnings and endings.
- **What differs from lever 1's census candidate.** DESIGN-BOUNDARY §4 said that a candidate through `«计»` adds nothing to the census rows' standing. That candidate, now HE2's census, needs `k` deciding every pair of units, so decided identity, which `Listed` lacks. The laws proposed here need only tests on listed units, and their subject is `«生»` and `«亡»` of `«续»`, so a row reaches them through bridges. The landing adds a dated note to DESIGN-BOUNDARY saying so (§5).
- **Occurrences as units** (Arising): `Steps.along` on `Nat × F`, the occurrence `(t, f)` a condition of `(t + 1, f)`, each member continuing only itself. With the class of activity (`Web.activityClass`) it reads arising as a beginning (`Web.arises_iff_sheng`). `Identity.continuationStep` at the identity continuation is the same relation.
- **The census laws of the models**, each with its own counting:
  - `Listed.coming_of_ceasing`, `Listed.across_at` and the stretch laws through it (Population), for any carrier, determination and listing;
  - `Web.Census.balanceFrom_at` and the laws through it, `balanceFrom`, `balanceFrom_eq_at`, `balanceFrom_eq`, `arisingFrom_of_ceasingFrom(_from)` and `ceasingFrom_of_arisingFrom(_from)` (Identity), under a continuation with no splits, or no merges;
  - through `Listed.coming_of_ceasing`: `Web.arising_of_ceasing_listing` (Listing) and `DependenceCensus.forming_of_dissolving` (Population);
  - `CountsAcross.keep_pace` (Decidedness), whose case is `CensusWebs.keep_pace`.

  The records [ceasing-needs-arising](../../../../../../theories/becoming/results/records/ceasing-needs-arising.md) and [census-balance-under-continuation](../../../../../../theories/becoming/results/records/census-balance-under-continuation.md) gather them.

## 2. The laws

Units of any type `α`; a continuation `«续» R E`; units listed before and after a step, `before` and `after`, or at each step of a run, `u : Nat → List α`. The tests are functions `α → Bool`, the modelling choice by which `«计»` counts.

**The census of a step, one side** (`«定后则后并亡不过前并生»`). Hypotheses:
- the units after listed once (`Distinct after`);
- nothing splits (`«定后» («续» R E)`);
- a test `b` fails only of units after with a predecessor among the units before, as far as can be refuted: `b y = false → ¬¬ ∃ x, x ∈ before ∧ «续» R E x y`;
- a test `e` holds only of units before that no unit after continues.

Conclusion: `after.length + «计» e before ≤ before.length + «计» b after`.

The proof:
- Each unit after that `b` fails of is matched to a predecessor before, which `e` fails of, since it has a successor.
- No two are matched to one, since nothing splits.
- A list without repetition matched one to one is no longer than the list it is matched into (`length_le_of_matched`).
- The predecessors are found under a double negation. The conclusion is a decided comparison of numbers, so `Decidable.of_not_not` takes it out, as `Covers.ceasing_steps_within` and `CountsAcross.keep_pace` already do.
- Splitting a list at a member needs membership only, so no decision of identity enters.

**What the hypotheses ask, exactly.**
- Nothing is asked of the units before: unlisted successors only enlarge the right side.
- `«定后»` is more than the step uses, which is no splits among listed units. Every case meets the global form, so the law takes it, as HE2's census does; the corollary of §3.4 then types against HE2's hypotheses as they stand. HE2's own helper `census_pairs` takes the local form, and the step law's proof needs only that form. Each of the four laws is therefore the corollary of a local form stated beside it (`GrammarLaws.census_le`, `census_le_converse`, `census_count`, `census_run`), asking no split, or no merge, only among the listed units, as GrammarLaws' module doc and master-laws' first hypothesis say every global form is (§9, S1).
- The tests are one-directional. `b` may mark a unit with a predecessor before, and `e` may miss a unit that ends; either only weakens the bound.

**Its mirror** (`«定前则前并生不过后并亡»`). It is the same law at the converse (`«逆» R`, `«逆» E`), with the lists and tests exchanged. Under `«定前»`, the units before listed once, `e` failing only of units before with a successor after, as far as can be refuted, and `b` holding only of units after that no unit before continues: `before.length + «计» b after ≤ after.length + «计» e before`. Its proof is the first law applied at the converse, five lines.

**The census of a run** (`«定后前者在前则亡屡者生屡»`). From a step `T` on:
- the units listed after each step listed once;
- every predecessor of a unit listed after a step listed before it (`«前者在前»`'s hypothesis at each step);
- nothing splits;
- the beginnings and endings of listed units decided by tests: `b y = true ↔ «生» R E y` for `y` listed after a step, `e x = true ↔ «亡» R E x` for `x` listed at a step.

Then `«屡» (fun before _ => ∃ x, x ∈ before ∧ «亡» R E x) u` gives `«屡» (fun _ after => ∃ y, y ∈ after ∧ «生» R E y) u`. Read along the run `u` as a line of lists, endings recur exactly when, after every step, some list holds an ending; beginnings recur exactly when, after every step, some list after a step holds a beginning. Beginnings are read among units listed after a step. Every unit listed at step 0 begins with no condition (`Steps.along_sheng_zero`), and that is no coming to be.

The proof:
- At each step from `T` on, the first law applies. Its arising hypothesis comes from the test of beginnings and the listed predecessors, its ceasing hypothesis from the test of endings.
- The counting step from losing to gaining (`gaining_of_losing_from`) then gives beginnings without end. Its proof goes through the prelude's `le_over_stretch`, never `balance_over_stretch_on`.

**Each hypothesis needed** (Lean witnesses in the scratch, `U4cCensus.Needed`):
- **The units after listed once** (`step_needs_once`): one unit before and its one successor listed twice after; every other hypothesis holds, and the count fails.
- **Nothing splitting, at a step** (`step_needs_fixedAfter`): one unit before, continuing as two after.
- **Nothing splitting, along a run** (`run_needs_fixedAfter`): each `x` continues as the next `x` and the next `y`, and each `y` as nothing. The tests hold, with nothing tested as beginning and `y` tested as ending: every unit listed after a step has `x` before it, so none begins, and of the units listed at a step `x` continues and `y` ends. Endings recur and beginnings do not.
- **Predecessors listed** (`run_needs_predecessorsBefore`): each listed unit continues as nothing, and an unlisted unit at each step continues as the next listed one. Every listed unit ends, and none listed after a step begins.
- **Listing once, for the run's truth.** It is not needed: counting distinct units, those after a step that do not begin inject into those before that do not end. It is needed for the proof by lengths. A proof without it would need distinct members counted under a double negation, which is possible but not worth it while every case lists each unit once. This is argued, not checked in Lean.
- **The tests.** They are the modelling choice by which the root counts (`«计»`). Whether the run law holds without them, as far as can be refuted, is not settled here.

**Names.** GrammarLaws' owner accepted the step law's name and the run law's name with 不绝. The review proposed 屡, the grammar's word for "at arbitrarily late steps" (`«屡»`), which the run law now states its hypothesis and conclusion with. The names above follow the census section's style:
- `«定后则后并亡不过前并生»`: successors fixed, the units after with the ceasing exceed not the units before with the arising;
- its mirror, `«定前则前并生不过后并亡»`;
- `«定后前者在前则亡屡者生屡»`: successors fixed and predecessors before, endings recurring, beginnings recur.

The step law no longer names `«前者在前»`: in its counted form it asks for listed predecessors only through the arising test. GrammarLaws' owner accepted all three names on 1 November, and the corollary's (§3.4).

## 3. The cases

### 3.1 `Listed.coming_of_ceasing` (central, counting today)

- **Units:** a member's occurrences `(t, a)`, related along its steps by `Steps.along`.
- **The class:** the determination's two-valued class on occurrences, `Steps.alikeAt p` (`fun x y => p x.2 x.1 ↔ p y.2 y.1`). `Web.activityClass` is its case at activity, by `rfl`.
- **The run:** the occurrences listed at each step, `listedOccurrences l t := (l t).map fun a => (t, a)`. The name `occurrences` is taken: Population's `occurrences T q t` counts the steps at which a quantity is positive.
- **The hypotheses, met at the model:**
  - the units after listed once, from `Listed`'s `Distinct`, mapped (`distinct_map_on`);
  - predecessors listed, since a listed occurrence's predecessor is the same member one step earlier, which holds by the class, so is listed;
  - nothing splits, along the steps under every class (`Steps.along_fixed`);
  - the tests, from `decide (p a t)` and `decide (p a (t + 1))` alone, with no decision of identity on the carrier.
- **The bridges**, equivalences with no hypothesis, as `Web.arises_iff_sheng` reads arising:
  - `comesToBe_iff_sheng_along`: `ComesToBe (p a) t ↔ p a (t + 1) ∧ «生» Steps.along (Steps.alikeAt p) (t + 1, a)`;
  - `ceasesToBe_iff_wang_along`: `CeasesToBe (p a) t ↔ p a t ∧ «亡» Steps.along (Steps.alikeAt p) (t, a)`.

  They are Change's `comesToBe_iff_sheng` and `ceasesToBe_iff_wang`, which read one determination along `Steps.next` under `Steps.alike`, read at a member's occurrences along `Steps.along` under `Steps.alikeAt`. Change's names are in `namespace Becoming`, so the new ones say where they read.
- **Its statement is unchanged**, checked by `rfl` on `type_of%` against the package's.
- **D5.** The re-proof goes through the census of a run alone, not through `coming_iff_excess` and `over_stretch_on`, so no balance anchor is in its closure.
- **Through it,** `Web.arising_of_ceasing_listing` and `DependenceCensus.forming_of_dissolving` reach the law with no change of their own.

### 3.2 `Listed.across_at` (not central)

It becomes a case of the two halves at the step's relation on members: each continues only itself, holding at both ends (`R a b := a = b`, `E a b := p a t ∧ p b (t + 1)`). The tests are the decisions of `ComesToBe (p a) t` and `CeasesToBe (p a) t`, and their counts are `comings` and `ceasings` (`total_mark_eq_count`). Its statement is unchanged, checked by `rfl`. `Listed.across`, `over_stretch_on` and the stretch laws through them then rest on the root's census of a step. They still reach the balance anchor through `balance_over_stretch_on`, which is theirs and is not changed.

### 3.3 `Web.Census.balanceFrom_at` (not central)

It becomes a case of the two halves at the step's relation on formations: `R t`, the formations active at both ends. Without splits at the step, the first half; without merges, the mirror. The tests are the decisions of `ArisesFrom` and `CeasesFrom`, which the section's instances already give.

The instance deciding `R` becomes unused. It is a variable of Identity's whole `Counting` section (`variable {W R} [∀ t g f, Decidable (R t g f)]`), and seven more laws of the section use it only through `balanceFrom_at`: `balanceFrom`, `balanceFrom_eq_at`, `balanceFrom_eq`, `arisingFrom_of_ceasingFrom(_from)` and `ceasingFrom_of_arisingFrom(_from)`. Dropped from `balanceFrom_at` alone, it would be left unused in those seven, the unused-section-variable linter would warn on each, and the checker fails on a warning. So the landing deletes it from the section's `variable` line:
- eight statements each lose one instance argument, each strictly more general;
- no caller changes. The one caller outside the section, `Persistence.persisting_census`, keeps the instance in its own signature, where an unused anonymous instance binder raises no warning.

The scratch checks the package statement of `balanceFrom_at`, that instance included, from the re-proof. It also elaborates copies of the seven, with their proofs as they stand, in a section without the instance, with no warning. The `Counting` section then has one route to the root, through the step. Identity's covering laws are outside it and are not cases (§3.5).

### 3.4 HE2's census, counted

Under HE2's hypotheses, the tests read off `k` (`b y := !(before.any (k · y))`, `e x := !(after.any (k x))`). The two halves then give exactly the count of `«定后定前则前并生对后并亡»`'s pairing, asking neither the predecessors' nor the successors' lists (`census_count_of_halves`, checked). HE2's pairing says more than its count. The new law generalizes the count, below it. The landing states it as a corollary beside HE2's census, `«定后定前则前并生与后并亡同数»` (GrammarLaws' owner's name: as many where HE2's says pair one to one), its docstring saying that it is the two halves meeting, the tests read off `k`. So rule 9 shows in the package.

### 3.5 Not cases

- **The covering law** `coming_of_ceasing_covered` (Locality), and `World.arising_of_ceasing` (Openness) and `Web.StandingCensus.coming_of_ceasing` (Openness) through it. It asks a list covering what holds at arbitrarily late steps, not a listing at each step. In the identity reading it is more general than `Listed.coming_of_ceasing`, which is its corollary through `Listed.covered`. After U4c the census in the identity reading has two proofs: the root's, and the covering law's, which is not a case. The record's next step names the covering law's root form (lines traced back to a covering list, no splits) so that this stands written.
- **Identity's covering laws**, `not_not_arisingFrom_covered`, `arisingFrom_not_stopping_covered` and `ceasingFrom_not_stopping_covered`, go by lineages and `length_le_of_matched`, not through `balanceFrom_at`. census-balance-under-continuation's laws 10 and 11 cite them. Like Locality's, they ask a list covering the active formations, not a census, and their root form is the same open step (§7).
- **`Counts.listed_across`** (Decidedness) proves the census across a step, with counts as relations, by its own search under a double negation. By content it is a case of the two halves, tests being had under the double negation as §4 argues for `keep_pace`. It is not re-proved here.
- **`Web.arisesFrom_of_more`** (Identity) is a case by content, more after than before giving a unit that arises. Its proof keeps its own search, through `length_le_of_matched`, which moves to the prelude. It is not re-proved here.
- **`CensusWebs.keep_pace`** (§4).

## 4. `CensusWebs.keep_pace` stays at counting

- **What it takes.** Its counts are relations, `CountsAcross`: they exist exactly where each member is decided (`counts_iff_decided`), and no procedure is given. Its bound runs in both directions over a stretch, on a fixed family `fs` that may list a member twice.
- **Why counts as relations are not the obstacle.** Its conclusion is a decided inequality, and its own proof already decides each member under a double negation (`not_not_decided`, `not_not_all`). The same move gives tests on the finitely many members and steps of the stretch.
- **What is missing:**
  - a two-sided bound, which needs both halves; both are now proposed;
  - a stretch form, the two halves summed over a stretch by `le_over_stretch` and `ge_over_stretch`, which is not proposed;
  - a reading on positions, since its family is fixed and may repeat, so its units would be positions of `fs` at each step, not members;
  - a proof off the balance anchor: today it reaches `balance_over_stretch_on` through `Counts.over_stretch_decided`, so D5 fails until it is re-proved.
- **Its basis then reads:** "the counting law `CountsAcross.keep_pace` at a web's arising and ceasing; not a case of the root's census of a step (U4c): a two-sided bound over a stretch on a fixed family that may list a member twice, it would need both halves summed over a stretch, read on positions, and a proof off the balance anchor; its counts as relations are not the obstacle, its conclusion being decided".
- **Next.** A stretch form on positions is a small further step once the two halves land, and the row can then be weighed again. The record's next step says so.

## 5. What changes, and what does not

**GrammarLaws, the census section** (core):
- the three laws, after `«后者在后则所列亡者亡»`, and the corollary of §3.4;
- four count lemmas they use, `length_keep`, `count_add_not`, `distinct_keep` and `count_pos_of_mem`, and `eq_true_of_not_false` for the corollary, all in `namespace GrammarLaws` beside `keep`, `mem_keep` and `not_eq_true_iff`. `Presence.count_add_not` and the `eq_true_of_not_false` of `Limit` and of Weightings' `Interacting` are other namespaces' lemmas, each used only inside its own namespace. Only GrammarLaws opens `GrammarLaws`, so no reference becomes ambiguous.

**Prelude** (core). These move to `Becoming.Prelude` together, with their names and namespace kept:
- from Population: `mem_remove`, `length_le_of_matched`, `not_not_all`, `gaining_of_losing`, `losing_of_gaining`, `recurs_shift`, `recurs_unshift`, `gaining_of_losing_from` and `losing_of_gaining_from`;
- from Change: `steps_mem`, `steps_last`, `steps_mono`, `recurring_accumulates` and `pos_of_exceeds`;
- from Flow: `total_pos`.

Three are generalized from `Type` to every universe as they move: `mem_remove`, `length_le_of_matched` and `not_not_all`, which the step law applies at `Type u` (§6). The rest move verbatim, `total_pos` at `Type` included. The three sit after `Distinct`, in the prelude's `Type u` section (`Once`). Their proofs take `ListTests.mem_cons_iff.mp` where Population's take `mem_cons_cases`, which is stated at `Type` and is not changed; the scratch's copies do so already.

None of them reaches a balance anchor. Where the prelude makes them visible, no reference becomes ambiguous: no other declaration has their names but Interleavings' `LocalLaw.total_pos`, which sees Flow's today. Three small lemmas of the cases join them there, being lemmas of lists and truth values only:
- `mem_map_prodMk` and `prodMk_mem_map`, membership in a list paired with a step (`mem_pairs` is Standing's, about `pairs`);
- `not_decide_iff`.

**Arising.** `Steps.alikeAt` and `Steps.along_fixed`, beside `Steps.along`, and `Web.activityClass` read as `Steps.alikeAt` at activity (`rfl`).

**Population:**
- the bridges `comesToBe_iff_sheng_along` and `ceasesToBe_iff_wang_along`, beside `Listed` (§3.1);
- `listedOccurrences`, the two tests on occurrences (`beginTest`, `endTest`), and `total_mark_eq_count`, which needs Change's `mark` and so stays above it;
- `Listed.coming_of_ceasing` and `Listed.across_at` re-proved, their statements unchanged.

**Identity.** `Web.Census.balanceFrom_at` re-proved, and the instance deciding `R` deleted from the `Counting` section's `variable` line, so that eight statements each lose that instance argument (§3.3).

**Records and texts:**
- **The master laws' record** gains the three laws and the corollary at 01 §7, as HE2's census laws did.
- **one-root-to-its-edge.** `Listed.coming_of_ceasing` moves to derived, with:
  - `law`: `«定后前者在前则亡屡者生屡»`;
  - `bridges`: the two equivalences of §3.1;
  - `support`: `Steps.along_fixed`, `Steps.along_hasPred_iff` and `Steps.along_hasSucc_iff`, which the bridges' proofs use.

  Its statement still reads as counting on U4b's line. It is placed by its proof's reach and the reading, as the eight connected rows were, under DESIGN-BOUNDARY §2's rule 2. `CensusWebs.keep_pace`'s basis takes §4's text. The counts become 11 derived, 1 under a stated hypothesis, 6 counting and 99 at a distance (100 before DU, which counted 117 central declarations, not 118). `next_delta` is reworded: "a grammar law the census rows are cases of" is done, and what is next is the covering law's root form and a stretch form of the census on positions, of which `CensusWebs.keep_pace` would be a case.
- **08 §7.** "Ten are derived" becomes eleven, with a clause naming the census as a case of the root's census of a run through its two bridges. "Seven are counting" becomes six.
- **08 §7's connectivity figures.** Re-proved, `Listed.coming_of_ceasing` reaches the grammar and no longer rests on balance, so the measure's figures in the paragraph before (of the 127 and of the 117 since DU, and F5's report) move by it. They are read off the rehearsal's core run (`measure_grammar.py`, MV's report) and written in the stage, not predicted.
- **DESIGN-BOUNDARY** gains a dated §9, as §8 did for U4b: lever 1's census candidate needed decided identity; this law needs tests on listed units.
- **ceasing-needs-arising.** Law 2 states the proof route through the census balance and declares `Listed.over_stretch` and `Listed.coming_iff_excess`, which the re-proof does not use. It is rewritten for the route through the root's census of a run, with its declarations. The rewrite is scoped to `Listed.coming_of_ceasing` and what goes through it (`Web.arising_of_ceasing_listing`, `DependenceCensus.forming_of_dissolving`). It names the world and standing readings as going through the covering law (law 6), which is not a case. A history note says so. Texts in Appendix A.
- **census-balance-under-continuation.**
  - Law 4 states the route through the continuing pairs (`mark_le_total`, `total_le_mark`, `total_swap`), which the re-proof does not use. It is rewritten for the route through the two halves, scoped to `balanceFrom_at` and the seven laws through it, so that it does not read over laws 10 and 11 (Identity's covering laws).
  - Law 3, the second hypotheses entry and the record's home row in 01 §9.5 say that the continuation is decided. After §3.3 none of the eight theorems takes that; they take decided `Continues` and `Continued`, of which a decided continuation under a census is one source (`Census.decideContinues`, `Census.decideContinued`). All three are rewritten, the record and its home row together.
  - A history note says so. Texts in Appendix A.

**MV.** Moving the lemmas raises MV's count of root constants (2,258 on the last run) and widens what D2 admits for every row. The landing reruns `master_laws.py` and the boundary report, and checks that no other row's standing changes by the move. D1 to D6 for the new derived entry are checked by MV's tool on the rehearsal run, not by hand.

**Not changed:** any statement of a model law except the eight of Identity's `Counting` section, each losing the instance deciding `R`, and the three moved lemmas generalized to every universe; HE2's census laws; balance's standing (still represented, not derived, as 01 says).

**Not claimed:**
- that any world meets the hypotheses, which are premises of the account where a model takes them (a census, the identity or a continuation with no splits);
- that the census is a law of how anything comes to be in every universe. 08 lists that as interpretation exceeding the theorem, and these laws change nothing there.

## 6. Order and cost

- **Done:**
  - the claim (board, main `0a4a465e0`);
  - the review;
  - the scratch, built over the checkout's modules with the checker's cache and Lean (`scratch_build.py`):
    - `U4cCensus`: the moved lemmas as copies, the three laws, the corollary and the witnesses, 26 theorems;
    - `U4cCases`: the bridges, the three re-proofs with their statement certificates, and the seven copies of §3.3's check, 18 theorems;
    - every axiom report empty and no warning ([scratch-build.log](u4c-scratch/scratch-build.log));
  - the names, accepted by GrammarLaws' owner;
  - the reviewer's re-check, all ten findings taken (§8).
  - the eight statements of §3.3, decided 1 November (below).
- **The stage** ([u4c-stage](u4c-stage/)), in OU7's format (the kit's `stages/README.md`):
  - the Lean series, one patch per file, made by [make_u4c_stage.py](u4c-stage/make_u4c_stage.py) on the tree after the kit's apply, and built there: 39 modules, every axiom report empty, no warning ([build-closure.log](u4c-stage/build-closure.log)); after the local forms (§9, S1), GrammarLaws rebuilt alone, 191 theorems in 220 declarations, every axiom report empty, no warning ([build-grammarlaws-local.log](u4c-stage/build-grammarlaws-local.log)), the four laws' statements unchanged, so nothing above it needs another check before the rehearsal;
  - the records and chapters, made by [make_u4c_records.py](u4c-stage/make_u4c_records.py) on main's text (Appendix A), reviewed in [REVIEW-U4C-RECORD.md](REVIEW-U4C-RECORD.md);
  - `EXPECTED.json` (what the audit and the register expect), the re-point reason and the study paragraph (`study.txt`, a fragment of the study page, as the kit takes it).
- **Next:**
  1. OU's owner's dry run with the stage, in a throwaway tree (run here on 1 November against the kit at `d8a870cda`, then at `2a72478ea` and `9813b8834`: both applies pass once GrammarLaws' header bullet sits apart from the owner's header patch; two kit points found and sent to OU's owner, §9);
  2. the rehearsal's core run, then the connectivity register's predicted roots and 08 §7's connectivity figures read off it (`Listed.coming_of_ceasing` now reaches the grammar), and U4's check on the derived entry;
  3. the landing with OU7's rebuild, last in the core round, on the coordinator's word. The record and chapter patches are cut from the main the landing merges.
- **If U4c's stage fails the dry run,** OU7 lands without it and U4c takes the next core slot. A failure of U4c's never holds OU7's slot.
- **Cost.** One near-full rebuild shared with OU7: Prelude and GrammarLaws change, so nearly every module above them recompiles once. Each item keeps its own records and study section, and the landing commit names both.
- **Owners and decisions:**
  - GrammarLaws: OU's owner, for the laws' names and place.
  - **The move into the prelude** (decided 1 November, since Prelude and Population have no named owner):
    - **A pure move.** Names, namespace and statements are unchanged, no caller is changed, and every axiom report stays empty, which the core run shows.
    - **One exception.** Three lemmas the step law applies at `Type u` are generalized from `Type` to every universe as they move: `length_le_of_matched`, `mem_remove` and `not_not_all`. A strictly more general statement that every caller still instantiates keeps one statement (R37). It keeps the census laws at one level and lets the corollary of §3.4 type as stated. The alternatives were a step law at `Type`, apart from the section's other laws and from HE2's census, or a second copy.
    - **The study section says** that these three are the only statements the move changes.
  - **The eight statements of Identity's `Counting` section** (decided 1 November). The instance deciding `R` is deleted from the section's `variable` line, so eight statements each lose one instance argument and are strictly more general (§3.3). On main only Identity.lean and Persistence.lean use these names, and none with explicit arguments (`@balanceFrom…`, `@arisingFrom_of…`, `@ceasingFrom_of…`), so nothing shifts by position.
    - **The study section and U4c's row say exactly:** three lemmas generalized to `Type u` as they move, and eight statements in Identity's `Counting` section each losing the decidability instance; no other statement changes.
    - **Records naming one of the eight** have that statement read against the new signature and are re-pointed with that reason. On main this is one record, census-balance-under-continuation, which names all eight. Its home row in 01 §9.5 says "with activity and the continuation decided", like its law 3, and takes the same correction (Appendix A).
    - **The proof is the rehearsal's core run**, not the scratch copies: the dry run builds the whole downstream set, Persistence and every module importing Identity.

    - **Edited by hand: the records whose declaration lists name a moved lemma under its old module**, twenty on main at `0a4a465e0`. `research-check` requires each declaration a reference lists to be elaborated in that reference's module, and `repoint.py` rewrites only hashes and receipts, so each declaration is moved by hand to a `Becoming.Prelude` reference:
      - `length_le_of_matched`, `mem_remove` or `not_not_all`: identity-across-steps, laws-of-one-step and more-needs-renewers;
      - the counting lemmas of Change, Flow and Population: the other seventeen;
      - five have no Prelude reference and gain one: bounded-census-keeps-pace, ceasing-needs-arising, laws-of-one-step, rising-and-falling-in-one-exchange and support-from-the-supported;
      - in two, closing-needs-net-draw and orders-as-a-sum-over-histories, a Change.lean reference is left with no declaration. Each is read: the reference goes if nothing in the record's text rests on the file, and otherwise stays in the role that text gives it, whichever `research-check` admits, with the reason in the note.
      
      Each takes a history note in EC2's form, in both languages: "declarations moved with their full names: … to Becoming.Prelude (U4c). The cited Lean source and its proof binding follow them; the claim is unchanged". For the three, the note adds "generalized from Type to every universe; every earlier use is an instance". census-balance-under-continuation's related note, "moved into Becoming.Population", reads Prelude, its history kept.
    - **Re-pointed by the tool: every other record that binds a changed module.** On main, 133 records reference Prelude, GrammarLaws, Population, Change, Flow, Identity or Arising, and 118 of them bind one to a receipt. These are bookkeeping: `repoint.py --paths … --receipt … --lean …` after reading each changed source, logged in one `rebinds.jsonl` line, against the shared receipt of the core run, as EC2 and EC4 re-pointed 138. OU7's rebuild changes modules too, so the pass is shared and runs once. Its owner is OU's owner, whose landing script runs the core round, unless they name another; U4c supplies its changed paths and reasons.
  - **The occurrence relation and its class:** OU's owner places them, as the core spine's integrator and the owner of the module both Population and Identity sit on. The relation is `Steps.along`, already in Arising below both. The new pieces, `Steps.alikeAt` and `Steps.along_fixed`, are proposed beside it. If OU's owner prefers a new small module, it is named at claim time in the core's vocabulary, inside OU7's one run.
  - The record `one-root-to-its-edge`: U4's.
  - These decisions go into U4c's board row and its study section at landing.

## 7. Open

- The covering law's root form, which would make `World.arising_of_ceasing` and `Web.StandingCensus.coming_of_ceasing` cases (§3.5).
- A stretch form of the census on positions, of which `CensusWebs.keep_pace` would be a case (§4).
- Whether the run law holds without its tests, as far as can be refuted, and a proof without listing once (§2). Neither is needed by any case.
- The root form of Identity's covering laws, with Locality's (§3.5).

## 8. How the review was taken

| Finding | What changed |
|---|---|
| 1 (blocking): the reason given for `keep_pace` was refuted by the design's own double-negation move | §4 rewritten: the obstacles are the two sides, the stretch, positions and the balance anchor; its basis text and the next step follow |
| 2: the law is a grammar law only if its whole proof is on the root; name the moves and D5 | §5 lists every lemma that moves, generalized to every universe, `length_le_of_matched` reused rather than copied; D5 stated in §2 and §3.1; MV's rerun named |
| 3: the occurrence relation already exists | `Steps.along` with the determination's class `Steps.alikeAt`, `Web.activityClass` its case (§3.1); nothing new to place but the class |
| 4: DESIGN-BOUNDARY §4 and the record's next step say otherwise | the difference stated (§1); a dated DESIGN-BOUNDARY §9 and the reworded next step at landing (§5) |
| 5: take the mirror by converse; join it to HE2's census | the mirror taken as a step law (§2), used by both step-level re-proofs; HE2's count a case of the two halves (§3.4). Its run form in the returning form is not taken: no case needs it once `across_at` and `balanceFrom_at` are re-proved, `Listed.ceasing_of_returning` and `ceasingFrom_of_arisingFrom_from` going through them |
| 6: the records' sentences overclaim | both sentences scoped; the covering law named as not a case and as the next step (§3.5, §5) |
| 7: the run law's indexing | beginnings among units listed after a step, stated with `«屡»` (§2) |
| 8: the cases missed | `across_at` and `balanceFrom_at` re-proved through the two halves; Identity takes the step route, one route (§3.2, §3.3); `arisesFrom_of_more` named (§3.5) |
| 9: H1 and H3 exactly | the units after only; `«定后»` stronger than used, kept; the run's truth without H1 argued, not checked (§2) |
| 10: one inexact sentence | §1 corrected |
| 11: names, 屡 | the run law stated with `«屡»` and named with 屡; the step laws renamed for their counted form; all for GrammarLaws' owner (§2) |
| 12: unused instances | `balanceFrom_at` drops the instance deciding `R`, its one change of statement, checked (§3.3; the re-check's R1 widened it to the section's eight statements); the `Listed` re-proofs need none dropped |
| 13: the entry's fields and 08's wording | the entry's `law`, `bridges` and `support` listed; 08 §7's two sentences (§5) |

**The re-check** (REVIEW-U4C.md, "Re-check, 1 November"):

| Finding | What changed |
|---|---|
| R1 (would fail the core build): the instance deciding `R` is a section variable, and seven laws would leave it unused | §3.3, §5 and "Not changed": deleted from the `Counting` section's `variable` line, eight statements each losing it, no caller changed; the scratch elaborates copies of the seven without it, with no warning |
| R2 (would fail the core build): `mem_pairs` is Standing's | renamed `mem_map_prodMk` and `prodMk_mem_map` (§5). A sweep of every new name against the package found four more clashes, each renamed or placed: `occurrences` → `listedOccurrences`; the bridges → `comesToBe_iff_sheng_along` and `ceasesToBe_iff_wang_along` (Change has the `Steps.next` forms in `namespace Becoming`); `count_add_not` and `eq_true_of_not_false` in `namespace GrammarLaws` (§3.1, §5) |
| R3: two records would state routes and a hypothesis the Lean no longer has | ceasing-needs-arising law 2, and census-balance-under-continuation laws 3 and 4 and its second hypotheses entry, rewritten with history notes (§5, Appendix A) |
| R4: the twenty need hand edits; about 130 more records re-point | §6: two kinds named, the twenty by hand with EC2's note, five gaining a Prelude reference and two left with an empty Change reference read; the rest by the tool in one pass shared with OU7, its owner proposed |
| R5: Identity's covering laws are not cases | §0, §3.3 and §3.5 scoped to the `Counting` section; the three named beside Locality's; the record's new law 4 scoped away from laws 10 and 11 |
| R6: `Counts.listed_across` | named in §3.5 as a case by content, not re-proved |
| R7: `run_needs_fixedAfter` left out the tests | the two test conjuncts added and checked (§2) |
| R8: the move to `Type u` and §5 against §6 | §5 names the three and moves the rest verbatim; their proofs take `ListTests.mem_cons_iff.mp`, as the scratch's copies now do, in the `Type u` section after `Distinct`; `mem_cons_cases` unchanged |
| R9: "as the census section's other laws do" | "as HE2's census does"; the local form left open (§2, §7), then stated after the record review (§9, S1) |
| R10: OU7 should not wait on U4c's stage | §6: if U4c's stage fails the dry run, OU7 lands without it |

## Appendix A. Record texts at landing

AI-written. The words are in [make_u4c_records.py](u4c-stage/make_u4c_records.py), which writes them, each edit asserting that the text it replaces is there once; [REVIEW-U4C-RECORD.md](REVIEW-U4C-RECORD.md) read them. What each edit does:

- **ceasing-needs-arising.** Law 2 states the route through the root's census of a run, scoped to `Listed.coming_of_ceasing` and what goes through it; it names the world and standing readings as going through the covering law (law 6), which is not a case. Its declarations follow the proof, with GrammarLaws, Population, Arising and Prelude references holding them. The census balance leaves the dependencies (the census law no longer goes through it), and its related note says until when it was the proof and that it still characterizes coming to be recurring exactly.
- **census-balance-under-continuation.** Law 4 states the route through the two halves, scoped to `balanceFrom_at` and laws 3, 6 and 9, laws 10 and 11 going by lineages. Law 3, the second hypotheses entry and the home row in 01 §9.5 say what the eight theorems take after §3.3: decided activity and decided "continues, or is continued by, some active formation", of which a decided continuation under a census is one source. The related note on `not_not_all` names the prelude, its history kept.
- **census-balance.** `Listed.across_at` is re-proved as a case of the two halves; nothing it states changes.
- **census-balance** also restates law 1 (`Listed.across` a case of the root's census, declaring `Listed.keeps` for the members kept, in place of `marks_le_of_sub`), law 5 and its related note on ceasing-needs-arising (the census law proved from the balance until U4c, and still following from it).
- **The root's census**: a formal-reuse dependency of census-balance-under-continuation, whose law 4 goes through its two halves and which master-laws-on-the-grammar does not reach; among related in census-balance and ceasing-needs-arising, which master-laws-on-the-grammar reaches (census-balance among its own dependencies, ceasing-needs-arising through least-loss-rest and continued-change-needs-openness), so that a dependency back would close a cycle. census-balance-under-continuation's dependency on the census balance names the counting it now reuses, its identity dependency's conditions what its theorems decide, and six declarations no law of it uses leave its Population and Flow references.
- **The twenty**, each a history note in EC2's form; the three generalized lemmas named as such; in closing-needs-net-draw and orders-as-a-sum-over-histories the emptied Change.lean reference goes with its binding.
- **master-laws-on-the-grammar.** Law 4 gains the four laws with their local forms, law 3 the five list lemmas and the census of a run, the third hypothesis the counted census's tests, the GrammarLaws reference all thirteen, the references this design and its two reviews. Its validation scope is at its length cap, so its list of changed statements gives way to the history notes, which carry it, and its reviews per item to the references, which hold them; the kit's record stage still finds the counts and the receipt there once.
- **one-root-to-its-edge**, from [make_record_u4.py](make_record_u4.py) in U4c's state (`U4_U4C`): the two entries, the review and this design among the references, DESIGN-BOUNDARY's hash for its dated §9, and the next step.
- **01 §7, 01 §9.5, 08 §7.** The census counted after HE2's census, each law asking its fixed successor or predecessor only in a local form; the root theorem's sentence, a model's law keeping its statement or taking a more general one; the row's clause; eleven derived and six counting, with U4c's derived row.
- **WHAT-REMAINS.** The release gate's line on the two census rows says what U4c did with them.

Each note's date and study section are left as `{DAY}`, `{DAY_ZH}` and `{N}`, for the landing to fill.

## 9. How the record review was taken

[REVIEW-U4C-RECORD.md](REVIEW-U4C-RECORD.md) found nothing blocking. Every finding is taken in [make_u4c_records.py](u4c-stage/make_u4c_records.py), [make_record_u4.py](make_record_u4.py) or the Lean:

| Finding | What changed |
|---|---|
| S1: master-laws' first hypothesis false of the four laws | the local forms stated in Lean (`GrammarLaws.census_le`, `census_le_converse`, `census_count`, `census_run`), the four laws their corollaries with unchanged statements; master law 4, 01 §7 and GrammarLaws' header say so |
| S2: census-balance states the old routes | law 1 declares `Listed.keeps` for the members kept and says `Listed.across` is a case; law 5 and the related note: proved from the balance until U4c, still following from it |
| S3: a dependency names lemmas no longer used | the census balance's dependency names `total_mark_eq_count` and the stretch inequalities; the six unused declarations leave the references |
| S4: design and review provenance | master-laws gains this design and both reviews as references; the scope and note say the references hold the reviews; the edge record gains REVIEW-U4C.md, and its note attributes each review |
| S5: the cycle reason false for one record | census-balance-under-continuation takes master-laws-on-the-grammar as a formal-reuse dependency; the reasons for the other two corrected (Appendix A) |
| M1: "from some step on" | added to the run law in 01 §7 and master law 4 |
| M2: law 2's readings, 本律, "names" | "listing, census and dependence"; 该律 and 根上一程之清点; "declares" |
| M3: "keeping its name and statement" | "its statement or a more general one" in 01 §7's root theorem |
| M4: "keep_pace's stretch form" | "a stretch form of the census on positions, of which `CensusWebs.keep_pace` would be a case" (next step, note, §7) |
| M5: "as the connected rows were" | "as were the eight connected rows the reading of connected rows took as derived" |
| M6: "decided activity and continuation" | "decided activity, and decided continuing of an active formation" |
| M7: master law 3 and hypothesis 3 | law 3 names the census of a run; hypothesis 3 the counted census's tests |
| M8: WHAT-REMAINS and the board | WHAT-REMAINS' line in the stage; the board row with the landing (`board_u4c.py`) |

**The second pass** (the same file's last section) built the new Lean in scratch and found the local forms minimal, ordered as `census_pairs` is, strictly more general (a witness where `«定后»` fails) and discharged by the four laws:

| Finding | What changed |
|---|---|
| B1: the staged generator predates DU's change to it | main merged into branch u4c before the cut: the generator counts 117 central declarations, 99 at a distance, and its 08 §7 paragraph is DU's with U4c's sentences |
| S6: "in the references" is not true of every item | master-laws' scope counts the reviews without saying where they are; the note says each is referenced from its item's records |
| S7: five reviews with a second pass, and a stale hash | "five"; the patches re-cut, binding this file as it lands |
| S8: the local-forms sentence said of the laws what holds of their local forms | 01 §7 and master law 4: "each is the corollary of a local form beside it that asks no split (no merge) only among the listed units" |
| M9: "HE2's census" in the English note | "the paired census" |
| M10: the header's "ending … beginning" | "those a test marks as ceasing … as arising" |
| M11: who declares the reused lemmas | the stretch inequalities' route named; census-balance law 8 declares `total_mark_eq_count`, which `Listed.across_at` uses |

The dry run also found two points in OU7's kit, sent to the kit's builder with the stage and copied to OU's owner. First, the synthetic receipt names a stage's added declarations without their namespace (`Becoming.along_fixed` for `Becoming.Steps.along_fixed`), so a record citing one reads as not elaborated. Second, once the record step and the re-point edit records and chapters that a stage's series also edits, the series no longer reverses, so the kit reads the stage as not in place. On the kit at `2a72478ea` the later steps read the selected stages, so the study paragraph and the re-point reason are kept; but apply run again after post would try the stage again and stop, and `stage_check.py` fails on a finished dry run's tree that holds a real stage. The fixes are in [kit-points-2a72478ea.diff](u4c-stage/kit-points-2a72478ea.diff): the receipt reads the namespaces open at a declaration, and apply records the stages it puts in place in the tree's own git folder, read before the reversal. With both, the dry run on `2a72478ea`, and on `9813b8834` (to which the diff applies unchanged), passes with no finding on its 152 records, and `stage_check.py` passes every check on its tree. Without the first there is one finding (`ceasing-needs-arising`); without the second, `stage_check.py` stops at its first check. Neither changes the order of `land_ou7.sh`; the second changes how the audit finds a stage in place. The kit's builder took both into the kit (`355f8b37b`), the first matching the full name exactly, the second also clearing the record when the kit's own patches are applied, since a tree without them holds no stage; the stage went in unchanged from `d5d034614` (`3b59e86b2`).
