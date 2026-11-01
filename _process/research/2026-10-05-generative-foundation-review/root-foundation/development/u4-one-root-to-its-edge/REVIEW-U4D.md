# Review of the U4d design: the covering laws on the root

*Status (added with the design's revision, 1 November 2026): every finding was taken; the revised design's [§9](COVERING-ON-THE-ROOT.md#9-the-review-and-what-was-taken) says how. This review and its scratch are committed with that revision. The review scratch built against the design's first scratch (`d39c709d3`); the revised scratch carries its checks on the revised frame, so the review scratch no longer builds against it. One check this review reports as made, `type_of%` on `coming_of_ceasing_covered`, compared the scratch's law with itself (a name-resolution slip in the first scratch, §7 of the revised design); it now passes against the package's law.*

1 November 2026. AI-written independent review of [COVERING-ON-THE-ROOT.md](COVERING-ON-THE-ROOT.md) and its scratch ([u4d-scratch](u4d-scratch/)). The checks that back the findings are Lean in [u4d-review-scratch](u4d-review-scratch/Becoming/U4dReview.lean). They were built with `scratch_build.py` together with the design's four modules: 12 theorems and 17 declarations, every axiom report empty, no warning ([build log](u4d-review-scratch/build.log)). That folder is not committed. Reading time: about fifteen minutes.

## Verdict

The mathematics in the scratch is sound. I rebuilt the design's four modules on main and got the reported 88 theorems, every axiom report empty, none unclean. The count, its mirror and the six run forms say what §2 says. The four re-proofs and the two census cases prove the package's own statements, checked by `type_of%`. The seven other laws named in §0 do reach the root through the four changed proofs with their own proofs unchanged. The witnesses meet the hypotheses they claim to meet, and `run_needs_decision` is a correct reduction to weak excluded middle.

The design's structural claim in §5 is wrong, though. The root's census of a run is not "a sibling, not a case, either way". `GrammarLaws.census_run`, with its statement unchanged, is a case of the proposed count. The route goes through the undecided trace (a stretch form of the count) and a finite search decided by the census's own beginning test. That route uses neither the "listed once" hypothesis nor the ending test (finding 1, checked in Lean). This should be taken before the package Lean is written. It changes what GrammarLaws should state, which records say what, and how rule 9 applies.

There are eight should-fix findings and nine minor ones:
- one helper in §5 still has a consumer;
- the run witnesses state less than the table says they show;
- three witnesses are missing (the converse's decision, the stage map, the decision at Identity);
- the reading of the decision witness overstates one thing;
- two record laws and one home row that state the changed routes are not named;
- the line lemmas are placed after a law that is to become their corollary;
- the frame's "held back" and "held on" are the grammar's closed regions under other names.

Counts: 1 blocking, 8 should-fix, 9 minor.

## Findings

### 1. Blocking: the census of a run is a case of the count (§0 "What it does not reach", §5 first bullet, §6 records, §8 question 1)

**What is wrong.** §5 says the census of a run and the covering law are siblings, and that neither's hypotheses give the other's, because "the census's tests do not give the predecessor positively". That is true of the *decided* form `cover_from`. It is not true of the count the design proposes.

Read the census's units as occurrences `(t, x)` with `x ∈ u t`, under the step relation restricted to listed units:
- `R' x y := y.1 = x.1 + 1 ∧ «续» R E x.2 y.2`
- `E' x y := T ≤ x.1 ∧ x.2 ∈ u x.1 ∧ y.2 ∈ u y.1`

Then every hypothesis of the stretch form of the count holds:
- the stage map;
- held back;
- no split, from the census's `noSplit`;
- a covering list at every stage, `(u N).map (N, ·)`;
- endings recurring, from the census's `ending`.

`predecessorsBefore` reads a beginning at `(t + 1, y)` as `«生» R E y`. So, with `|u N| + 1` endings found at distinct stages in `[N, U)`, the count says it is refuted that nothing begins in `(N, U)`. That is a finitely bounded search over listed units, and the test `b` decides it. So a beginning is found positively.

`U4dR.census_run_lines` proves the census of a run this way from `noSplit`, `predecessorsBefore`, `begins` and `ending` alone. `example : type_of% @GrammarLaws.census_run := @U4dR.census_run_again` checks that the package's law, statement unchanged, is its case. The hypotheses `once` (units after each step listed once) and `ends` (the test `e` of endings) go unused. Distinctness comes from the distinct stages of the endings, and endings are taken from `ending` directly.

**Consequences.**
- The census in the identity reading need not have two root proofs, one by the census of a step summed over a stretch and one by lines. One count can carry both.
- `«定后前者在前则亡屡者生屡»` asks more than its conclusion needs, so U4c's "asking only what its proof uses" is true of its proof but not of the law.
- §5's "a form taking lists at every step with tested beginnings, of which both would be cases, is open" is not open. The form is the stretch form below, and it is already in the scratch in pieces (`ends_le_unrefuted` with `trace_unrefuted`). The Locality case of `Covers.ceasing_steps_within` already assembles those two pieces inline.

**Fix.**
1. State the stretch form as a root law. It is `U4dR.cover_within`: with a list covering the units at `N` and no unit beginning at a stage in `(N, U)`, units ending at distinct stages in `[N, U)` number at most the list, with no decision. `cover_unrefuted` and `Covers.ceasing_steps_within` are its direct cases.
2. State the census of a run's weaker form (`census_run_lines`, under the owner's name) as the law, with `census_run` and `«定后前者在前则亡屡者生屡»` its corollaries, statements unchanged.
3. Rewrite §0, §5 and the planned record texts:
   - the one-root-to-its-edge history entry;
   - shared-laws-on-the-grammar law 4;
   - ceasing-needs-arising law 2.

   They should say that the census of a run is a case of the count through the undecided trace. The *decided* covering form `cover_from` is the one that is not a case of the census of a run, since the census's tests give no predecessor positively and its lists give nothing positive between them.
4. If the owner defers the re-proof, the texts must still not say "not a case either way". Say "a case, not yet re-proved", the next step named.

### 2. Should-fix: a helper said to lose its last consumer keeps one, and the rule for removing helpers removes none (§5, last bullet; §3.1)

**What is wrong.**
- §3.1 keeps `Covers.ceasing_stops_unrefuted`'s proof unchanged. That proof calls `ceasing_steps_unrefuted` (Locality.lean:690). So `ceasing_steps_unrefuted` does not lose its last consumer, as §5 says it does.
- Every helper §5 lists appears in a record's `references` declaration list:
  - in laws-of-one-step: `accumulates_or`, `ceases_once`, `ceasing_steps_unrefuted`, and also `ceasing_steps_found` and `stays_failing_within`;
  - in census-balance-under-continuation: `Lineage.ends`, `ceasingFrom_found`, `arisingFrom_found`, `lineages_apart`.

  "Rule 9 removes those that nothing uses or cites" would therefore remove none of them. The dead proof routes would stand beside the general law, which rule 9 means to prevent.

**Fix.**
- Take the scratch's shorter route as the package's:
  - `Covers.not_not_coming_from` becomes a direct case of `cover_unrefuted` (`U4d.not_not_coming_from`);
  - `Covers.ceasing_stops_unrefuted` follows from it (`U4d.ceasing_stops_unrefuted`).

  Six proofs then change, not four, and `ceasing_steps_unrefuted` really loses its consumer.
- Or keep both proofs and strike `ceasing_steps_unrefuted` from §5's list.
- Either way, say that a `references` entry lists a source's declarations rather than a law's support. Remove the dead helpers from the package and from those two `references` lists, naming each record in the landing.

### 3. Should-fix: the run witnesses refute only the run form's conclusion (§4 table; U4dNeeded.lean:70, :97, :120)

**What is wrong.**
- `run_needs_noSplit`, `run_needs_keeps` and `run_needs_covering` each end with `¬ ∀ M, ∃ y, M < y.1 ∧ … ∧ «生» … y`. That refutes `cover_run` only.
  - It does not refute `cover_from` at `N = 0`, which concludes `∃ y, 0 < y.1 ∧ …`.
  - Nor does it refute the undecided forms `cover_unrefuted` and `cover_never_stops`, since `¬ ∀ M ∃` does not give `¬ ∃` or `∃ M ∀ ¬`.
- The table's prose ("no beginning after the first stage") states the right, stronger fact, but the Lean does not.
- The three converse witnesses do not state that each unit ends or has a successor. They meet it trivially, every unit having a successor, but as stated they do not cover `cover_converse_run`.

**Fix.**
- End each run witness with `∀ y, 0 < y.1 → here y → ¬ «生» … y`. The same proofs give it, and it refutes all four run forms.
- Add the decision conjunct to the converse witnesses.

### 4. Should-fix: three hypotheses have no witness (§0 "Each hypothesis needed", §4, §3.3)

**What is wrong.**

(a) *The converse's decision.* `cover_converse_run`, and through it Identity's new `ceasingFrom_of_arisingFrom_covered`, asks that each unit end or have a successor. §4 has no witness for it.

`U4dR.ConverseChoose.converse_needs_decision` gives one. `(t, 1)` continues as `(t + 1, 0)` where `Q` holds, and `(t, 0)` continues as it where `Q` fails. Every other hypothesis holds, the decision holds exactly where `Q ∨ ¬Q`, and endings recur exactly where `¬Q ∨ ¬¬Q`.

(b) *The stage map.* §4 calls it "the frame, not a hypothesis, and has no witness". But it is a hypothesis of every run form's Lean statement, and the conclusion depends on it.

`U4dR.Stage.run_needs_stage` gives a witness. Each `(0, a)` continues as `(a + 1, a)`, which ends. Every other hypothesis of the decided run law holds, and each step moves strictly later, yet no unit begins after the first stage. So even "each step moves later" is not enough: one stage on is needed.

(c) *The decision at Identity.* census-balance-under-continuation's Next leaves open "the decision the exact form needs". §3.3 says two cases close it, but the necessity witness is at the root only.

`U4dR.AtIdentity.exact_needs_decision` reads it at Identity. On a web with formations `0` and `1` active at every step, let `0` continue as `0` where `Q` holds and as `1` where it fails. Then:
- covering lists, no split and ceasing recurring all hold;
- `Continues` is decided exactly where `Q ∨ ¬Q`;
- `UnceasingFrom` holds exactly where `¬Q ∨ ¬¬Q`.

**Fix.** Add the three witnesses, or the owner's versions, to §4 and to U4dNeeded. Cite (c) in the census-balance-under-continuation law that states the exact forms.

### 5. Should-fix: the decision row is not a countermodel, and the reading claims a little too much (§4 intro and table row "run, found"; §7 last sentence; §8 question 5)

**What is wrong.**

1. §4's intro says each witness meets every other hypothesis "and the conclusion fails there". No model can do that for the decision. Given the other hypotheses, `cover_unrefuted` proves the conclusion's double negation, so the conclusion is never refutable. The row is a reduction, not a countermodel.
2. The witness shows that *some* non-constructive hypothesis is needed. It does not show that this one is. At the model the conclusion is equivalent to weak excluded middle for `Q`, while the hypothesis asks excluded middle for `Q`. The proof also uses the decision only at units after `N`: `U4dR.cover_from_after` checks `cover_from` with `decided : ∀ y, here y → N < τ y → …`. A weaker sufficient hypothesis may exist, and that question is open.
3. §7: "That Lean's logic does not prove weak excluded middle is a known fact about intuitionistic logic." Intuitionistic higher-order logic does not prove it, since it fails in toposes that are not De Morgan. Lean's axiom-free core adds impredicative `Prop`, proof irrelevance and inductive types. That it does not prove it either is the standard belief from such models, not a checked fact.

**Fix.**
- In §4, say that the decision row is a reduction: asked as a law without the decision, the found form gives `¬Q ∨ ¬¬Q` for every `Q`.
- Change the column entry to "the conclusion is equivalent to `¬Q ∨ ¬¬Q`".
- State that the minimal decision is open, and optionally weaken `decided` to units after `N`.
- In §7, say "intuitionistic logic does not prove it; that Lean's axiom-free logic does not is not checked here".

### 6. Should-fix: record laws that state the changed routes are not named, and one record has been renamed (§6 "Records")

**What is wrong.**
- **census-balance-under-continuation.** Its law 4 ends "The covering laws (laws 10 and 11) go by lineages." That sentence becomes false, and §6 names only laws 10 and 11, which state no route. If question 3 is taken, law 4's "laws 3, 6 and 9 go through the root's census of a step" is wrong for law 9's two recurrence laws too.
- **ceasing-needs-arising.** The route sentence is in law 2: "the world and standing readings through the covering law (law 6), not a case of it". §6 names laws 6 and 7, which state no route. Law 2 should say the covering law now reaches the root through its own root form. Under finding 1 it should also say that the root's census of a run is itself a case of the root's count.
- **The renamed record.** ND's final stage landed on main (`3e2e702be`): `master-laws-on-the-grammar` is now `shared-laws-on-the-grammar`, and its data file is `shared-laws.json`. Its law 4 is "Balance at one step". A count over lines across many steps is not balance at one step; the census of a run already strains that title.

**Fix.**
- Name census-balance-under-continuation law 4 and ceasing-needs-arising law 2 in §6, with their new sentences.
- Use the new record id.
- Put the count, its mirror and the stretch form in their own law of shared-laws-on-the-grammar (or with law 7, steps), not in law 4.

### 7. Should-fix: home sections (§6 "Home sections")

**What is wrong.**
1. A new law in census-balance-under-continuation, the exact forms from covering lists, changes a statement. AGENTS asks that such a change go to the record and its home section. The home row (01 §9.5) reads "Under a census, read along a continuation, with activity decided and whether a formation continues, or is continued by, some active formation decided …". The new forms need no census and no decision of activity. §6 says only that "01 §9.5's census rows name the new route where they name one".
2. The drafted 01 §7 sentence omits several hypotheses:
   - the stage map, a modelling choice that AGENTS asks to be stated where a law depends on it;
   - that the units form a region closed under the converse;
   - the converse's no merge and held on, and its decided/undecided split ("never stops" against "recur").

**Fix.**
- Add a clause to the 01 §9.5 row stating the exact forms.
- Redraft the 01 §7 sentence along these lines (under finding 1 it also names the census of a run as a case):

  > Traced along lines instead of listed at each step: endings on lines from a list, the successor fixed where the lines could part, number at most the list. So, with each step one stage on, the units a region nothing outside continues into, lists covering them at arbitrarily late stages and each decided to begin or to have a predecessor, endings recurring need beginnings recurring. Without the decision, a later beginning is not refuted. Mirrored, with bounded lists at every stage, a region closed forward and nothing merging, beginnings recurring leave endings never stopping, and with each unit decided to end or to continue, endings recur. Locality's and Identity's covering laws are proved as its cases.

### 8. Should-fix: the line lemmas cannot follow the census of a run if `«迭之定于»` is their corollary (§6 "Lean", GrammarLaws)

**What is wrong.** §6 puts "the line lemmas" in the census section, after the census of a run (GrammarLaws ~line 2079). It also makes `«迭之定于»` (line 1332, section Runs) "the corollary of `steps_unique`". A corollary cannot precede the law it follows from.

**Fix.** Put the line lemmas in the Runs section, after `«迭则同一或及»` and before `«迭之定于»`:
- the closure as some number of steps;
- `steps_unique`, `ends_before` and `one_end_rel`.

They use only `«所闭当且仅当同一或及»`, `«及即迭»` and `«迭之分»`, all above. Put the count and its mirror there too, since they are laws of lines on any relation. The stretch form and the run forms go in the census section beside the census of a run.

### 9. Should-fix: the frame's region conditions are the grammar's closed regions (§2.3; U4dCover.lean:186–194)

**What is wrong.**
- `keeps : ∀ x y, «续» R E x y → here y → here x` is `«闭» («逆» («续» R E)) here`: nothing outside the region continues into it.
- `keepsOn` is `«闭» («续» R E) here`.
- `U4d.keeps_on` restates `«闭含所闭»`, and `U4d.keeps_back` restates `«闭含所闭»` read through `«所闭之逆»`. The grammar has both, so the two wrappers add a second name for one law.
- The prose "what holds of a unit holds of its predecessors" reads as "every property of a unit"; it means "a predecessor of a unit is a unit". "No unit continuing as two units" quantifies only the two successors, not the occurrence continued.
- The stage map has a hidden consequence. Since `τ y = τ x + 1` on every step, no occurrence continues itself. Units must be occurrences at stages, not relata that persist. The census of a run, which has no stage map, meets the frame only after pairing each unit with its stage, as in finding 1.

**Fix.**
- State the two conditions with `«闭»` and drop the wrappers.
- Name the region as a region (`P`, "the units"), not `here`.
- Say "nothing outside the region continues into it" and "no occurrence continues as two units".
- Say in §2.3 that the frame reads units as occurrences at stages.

### 10. Minor: more laws reach the root through the four than §0 lists (§0 first bullet, §3.1 "Through them")

"Six laws go through these two" counts one hop only. These also go through the four, with proofs unchanged:
- `ListedWebs.ceasing_not_recurring` (ListedWebs.lean:82, through `Covers.ceasing_not_recurring`);
- `World.comes_to_rest_unrefuted_from` (Openness.lean:590) and `World.arising_unrefuted_covering` (InAmounts.lean:363), through `Covers.not_not_coming_from`;
- their consumers (`World.comes_to_rest_unrefuted`, `World.rests_unrefuted_covering`, `World.rests_unrefuted`).

§6 already lists the records that cite them. Say "directly", or name them. (Decidedness' `ceasing_steps_within` is its own law, not a consumer.)

### 11. Minor: the reason given for 08 §7's figures not changing is the wrong one (§0 "Standing", §6 "Home sections")

"None of these laws is among the 117 central declarations, so the … figures … do not change" does not follow. The measure counts central declarations whose proofs reach grammar constants transitively. The figures hold for another reason: the central declarations downstream of the four already reach the grammar (`World.comes_to_rest_unrefuted`, `RegimeMargin.Adjusted.comes_to_rest` and `Listed.coming_of_ceasing` are all "grammar" in shared-laws.json). Give that reason, and rerun the measure on the landing build.

### 12. Minor: "From step `T` on is not a hypothesis of the root forms" (§2.3, last paragraph)

`cover_converse` and `cover_converse_run` take `T` in `bounded`. The sentence means no split and no merge from `T` on. Say so.

### 13. Minor: `run_needs_covering`'s description (§4 table)

"infinitely many at the first stage": the model has infinitely many units at every stage (`(t, a)` for every `a ≥ t`), so no list covers any stage. Say that.

### 14. Minor: general lemmas stated at a special type (§6 "Locality"; U4dCases.lean:93–107; U4dCover.lean:16–27)

- `U4d.pick` and `U4d.distinct_of_map` are list lemmas stated at `Nat × α`. Generalize them and place them in the prelude beside `distinct_map_on`.
- `closure_of_steps` and `steps_of_closure` are two directions of one law. State them as one equivalence ("the closure is some number of steps"), as `«及即迭»` is stated.

### 15. Minor: the base has moved, and what `type_of%` checks (§7, §8 "Order")

- The scratch was built on `43497d137`. Since then ND's final stage has landed (`3e2e702be`), and EL6 is at the head of the queue with a near-full core run and two renames. Rebuild on the new head before step 3.
- `type_of% @X := @Y` checks the type up to definitional equality, which ignores binder annotations and names. That is enough for "the new proof proves the old statement", provided the landing keeps each statement's literal text and changes only the proof. Say so in §7.

### 16. Minor: `Covers.within` is not placed (§5)

`Covers.within` is a covering law as well: a list covering `N` covers every later step of a stretch across which nothing comes to be. Its root form is the decided trace (`U4d.trace`). §5 neither makes it a case nor says why it stays.

### 17. Minor: consequences of question 3 for Identity.lean's order

The Counting section (census laws, line ~871) precedes the Covering section (~927). To re-prove the census recurrence laws through the exact forms, the covering forms and their supports must move above them, or the two laws below. U4c's count of "seven laws of Identity's Counting section that go through `balanceFrom_at`" then becomes three (`balanceFrom`, `balanceFrom_eq_at`, `balanceFrom_eq`), since the two recurrence laws' corollaries (`arisingFrom_of_ceasingFrom`, `ceasingFrom_of_arisingFrom`) follow them. Say so in §3.3.

## The five questions

**1. GrammarLaws or a leaf?** GrammarLaws.
- The line lemmas and the count are laws of steps and lines on any relation. They belong in the Runs section with `«迭»`'s laws, before `«迭之定于»` (finding 8).
- The stretch form and the run forms belong beside the census of a run. Under finding 1 the census of a run is re-proved through them, so GrammarLaws changes anyway, and a leaf would split one census across two modules.
- A leaf would save reading GrammarLaws' nine bound records. It would cost new imports in Locality and Identity (against §6's "no import changes") and a new core module in the manifest. Within the one core run that Locality and Identity already need, those nine re-points cost little.

**2. `here` with held back and held on, or the region in `E`?** Keep the region beside `E`, but state its conditions in the grammar's own terms (finding 9): closed under the converse of `«续» R E` (nothing outside comes into it) and closed under `«续» R E`. Folding the region into `E` has costs and no gain:
- It would change `«生»` and `«亡»` off the region.
- At Locality, `E` is the class `Steps.alikeAt p`. Its bridges `comesToBe_iff_sheng_along` and `ceasesToBe_iff_wang_along` are stated at that class, and would have to be restated at the restricted relation.
- Identity's `activityOnward` already folds the region in, and meets the two closure conditions trivially. The separate region costs it nothing.

**3. Re-prove Identity's census recurrence laws through the exact forms?** Yes.
- The exact forms ask strictly less: covering lists in place of a census, no decision of activity, and one decision of the continuation in place of three. Rule 9 asks the general law to prove the special one.
- `balanceFrom_at` keeps laws 3 and 6 and the balance half of law 9.
- The record consequences are census-balance-under-continuation law 4's sentence (finding 6) and the file order (finding 17).
- If the owner keeps the census route, the record should still say that the census laws are cases of the exact forms (checked in `U4dSame`), so that the standing is written.

**4. The count's hypothesis: the local form or `«定后于»` at each member?** The local form as the law, with `«定后于»` at each member a corollary beside it, as `«迭之定于»` is to `steps_unique`.
- The local form is what `fixed_of_noSplit` gives from a no-split asked only among units.
- `«定后于»` would also ask that successors outside the region not split. The root frame's region is closed only backward in the decided forms, so the run forms would then need a stronger hypothesis than they use.
- The two cases happen to meet `«定后于»`: Locality's successor is fixed everywhere, and Identity's `activityOnward` keeps successors of active occurrences active. That is a fact about the cases, not about the frame.
- `count_needs_fixed` shows that the local form cannot be dropped.

**5. Is the decision witness read right?** Yes, as a reduction, with the three corrections of finding 5:
- it is not a countermodel, and no countermodel can exist;
- it shows that a non-constructive hypothesis is needed, not that this one is minimal (at the model weak excluded middle suffices, and the proof uses the decision only after `N`);
- the closing sentence should not present the independence of weak excluded middle from Lean's core as checked.

The same reading holds for the converse and at Identity, where the witnesses are built (finding 4).
