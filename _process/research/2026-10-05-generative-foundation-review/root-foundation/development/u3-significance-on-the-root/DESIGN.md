# U3: the significance rows on the root (design)

Design, 29 October 2026, on main at `c2dc1773d`. No Lean in the package. U3 is an item of full unification, OU plan §十三 item 13, 全四, decision D25 ([WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), "U1's verdict, GW's, and U3's gate"). OU's owner posted it with its gate open after U1's reviewed verdict. This session claims it with U1's landing: a design first, one independent review, then any Lean claim goes to OU's owner. It edits no module and redefines nothing.

**Scratch.** [scratch/Becoming/SignificanceRootScratch.lean](scratch/Becoming/SignificanceRootScratch.lean): 7 theorems in 7 declarations, every axiom report empty, built with `scratch_build.py` against main. **Review.** One independent review ([REVIEW-U3.md](REVIEW-U3.md), GPT astra, high effort) found no false theorem and no sentence grounding the ethics in the root. Its three medium findings and one low are taken (§6).

## 0. What the ethics' scope and order require of this item

AGENTS.md's paragraph on scope and order governs every line of this item:
- The continuation condition (`Unrestricted`) fixes **scope**: whose losses count. By itself it orders nothing.
- C, that widening is better, alone fixes **order**.
- The theory asserts neither. Both are named wherever the ethics is used, and nothing here says the ethics derives from the condition.

FU's change 3 lifts the plan's deferral of the ethics for 全四 alone, with three conditions: the condition and C stay named premises, the free predicate `sig` stays the general form (SD1, `ReadsOnlyDynamics.not_entails`), and **the root derives nothing ethical**.

So "the significance rows on the root" means: each row's statement where its terms are the root's. The condition is read structurally (held de se along a relation, GS2), widening as the grammar's `«广»` on what is admitted, and weightings through U1's second sort. It does not mean that the root entails significance, the condition or C.

## 1. The rows and their root forms

**Which rows, and where their numbers come from.** COVERAGE's significance row (`theories/becoming/results/completion/COVERAGE.json`, row `significance`) lists five declarations: `unrestricted_iff_livingSignificance`, `Web.widens_iff_retains_adds`, `Web.paths_comparison_widens`, `Web.paths_one_object` and `Weighting.widens_iff_every_positive`. The table below has a sixth, `Web.paths_extension_iff_widens`. COVERAGE lists it under capacity, and the ethics chain lists it as a step. It is here because two significance rows rest on it: row 7 is one direction of it, and row 9 is its conjunction with row 8. Their root forms need its root form.
- **The numbers 5 to 10, and the reasons in the second column,** are those of OU3c's audit table of the ten central declarations ([AUDIT](../ou3c-anchors-on-the-grammar/AUDIT.md), "The ten central declarations").
- **`unrestricted_iff_livingSignificance` has no number there.** MV's view (`theories/becoming/results/data/master-laws.json`) places it under EC6's category "definitional or representational".
- **Row 6, `Direction.extension_iff_widens`,** is row 5 on the moves' frame, and it stands in COVERAGE's direction row. Its root form would be row 5's, read on that frame. U3 does not state it.

| Row | OU3c's reason it does not reach the grammar | Root form (scratch) | Kind |
|---|---|---|---|
| `unrestricted_iff_livingSignificance` | definitional | `noOutside_iff_paths_livingSignificance`: on a web's level paths, every formation lying on every center's line under the one of a relation (`«续无外» rel «一» center`) is exactly living significance over admission, with a claim's significance from a standpoint being that its formation lies within that standpoint's center's closure | **representation** at the structural reading, a specialization of the general frame theorem to web paths (GS2's `ownClosure_unrestricted_iff_noOutside` composed with `Web.unrestricted_iff_paths_livingSignificance`). The acyclic boundary binds (§2) |
| `Web.paths_extension_iff_widens` (row 5) | a reindexing, a claim being a (formation, step) pair and admission read at (step, formation); counting every claim | `paths_extension_iff_grammar`: an extension counting every claim is `«广»` of what the paths admit | **representation**: the anchor's grammar form (`Web.widens_iff`); the proof is the anchor's |
| `Web.paths_comparison_widens` (row 7) | one direction of row 5, for every reading of `living` | `paths_comparison_grammar`: for **every** reading of `living`, `Comparison W.paths living` holds with "better" read as `«广»` of what the paths admit. That this relation is "better" is supplied by the reading of "better", C's normative content, and is not shown | **representation**, at the row's own scope |
| `Web.widens_iff_retains_adds` (row 8) | the condition's reduction of significance to what can form; the free significance is not on the root | `widens_iff_retains_adds_root`: where `«续无外» rel «一» center`, `«广»` of what the paths admit is retaining and adding what lies within one's own line, pointwise in any standpoint, for any level paths | the row's **instance at the structural reading**. The grammar's closure law converts the supplied condition, through GS2 (`withinClosure_iff_reached`); the reduction itself is `Web.widens_iff_retains_adds`'s, not a new law of closure. It is a new statement, and the row keeps its free form. The acyclic boundary binds (§2) |
| `Web.paths_one_object` (row 9) | the conjunction of rows 5 and 8 with the paths' living significance | `paths_one_object_root`: the three readings of one predicate, admission, with the condition on the root and widening `«广»` | the conjunction of the three root forms above. The acyclic boundary binds (§2) |
| `Weighting.widens_iff_every_positive` (row 10) | a law of weights, which the grammar has none of | `grammar_widens_iff_every_positive`: on a **finite list** of items, with **Boolean admission** and **additive natural-number weights strictly positive on the listed items**, the grammar's `«广»` of what two choices admit is exactly what every such weighting ranks higher | **an interface law of the second sort**, describing its role, not a derivation of weights. It pairs the root's order (`Weighting.widensOn_iff`) with amounts assigned to what is admitted (U1's verdict). Mixed comparisons have no unanimous ranking: some positive weighting ranks each direction (`Weighting.mixed_either_way`) |

Also proposed, for `Becoming.GrammarTransport`'s owner (WRT's designer): `«广之对应»`, widening kept by a one-to-one correspondence (`guang_correspondence` in scratch, universe-polymorphic as that module is). It would let rows 5 and 7 be read on the claims' own carrier, (formation, step), and carried to (step, formation) by the swap, rather than only through the anchor. That is still a representation, and it would be added only if a consumer reads it.

## 2. What this establishes, and what it does not

**Established, at the scopes above (scratch):**
- every significance row has a statement whose terms are the root's, row 7 at its own scope (every reading of `living`);
- the condition, in its structural reading, is the root's `«续无外»`, which GS2 landed;
- widening on what is admitted is the root's `«广»`, which OU3b landed;
- weightings meet the root's order through one interface law of the second sort.

**Not established, and not claimed:**
- **That the root entails any of it.** `«续无外»` is a hypothesis, not a theorem, and SD1 stands for the free predicate.
- **That the structural reading is the right one.** Which relation a center's own line runs along, and whether the self's presupposition is held de se, is the step of invariance (07 §4), and stays open.
- **That widening is better.** C stays a premise; `grammar_widens_iff_every_positive` shows widening is what every positive weighting ranks higher, which is C's content relocated to valuing positively (T5), not its warrant.
- **Any ranking of mixed comparisons.**
- **The free significance lifted onto the root.** The rows' free forms are unchanged; the root forms are their instances and their anchors' grammar forms.

**The boundary on acyclic nets.** Where the supplied relation `rel` is acyclic, `«续无外» rel «一» center` forces every existing center to coincide: `«续无外则同一中心»` concludes `∀ p q, center p = center q`. That is at most one distinct center. It does not say there is a standpoint, or that standpoints are few, since several may share a center and `Pos` may be empty. It is a necessary consequence of the condition, not a sufficient condition for it. The root forms of rows 1, 8 and 9 remain valid with distinct centers; their condition side then fails. Acyclicity is not added as a hypothesis to the general statements. Each of the three forms, in the table and in the scratch docstrings, carries this boundary.

## 3. Categories (for MV, the measure's owner)

No row moves to "master law" or "derived". The free forms keep OU3c's reasons, and the root forms are new statements beside them.

**How F5 counts them.** In F5's field (MV's [spec](../../../../2026-10-05-repository-reconciliation/architecture/mv/F5-MODEL-STATEMENTS.md) §1 and §4), an item states the row itself. An instance or a specialization of a row states less than the row, so it is not an item (§4, "U3's forms").
- **Rows 5, 7 and 10.** The root forms keep their row's full generality, restated in the grammar's terms on the row's own carrier: a web's level paths, or a finite list. Each is an item whose model is `own`. It is not stated at a World's occurrence model or a process's model, so F5 counts these rows in its third count, "stated in the grammar's terms on their own carrier". FU's change 1 does not count such statements as representations at a represented model, and this design does not claim it.
- **Rows 1, 8 and 9.** The root forms fix significance at the structural reading (`selfAscribed (ownClosure rel) center`), so each is a specialization of its row. They land as ordinary laws in their rows' records, labelled as specializations, with no F5 item, and their rows stay in F5's fourth count. Counting them would need the field to gain a declared relation (statement, instance, specialization), which the spec leaves to OU's owner. This design does not propose that now.
- Where §1 and §2 say "representation", they mean that each statement is a restatement of its row, or of its row at one reading, and not a derivation.
- Row 8's root form uses the closure law through GS2. Its row's dependence stays the measure's: a statement in the grammar's terms never makes its row reach the grammar (MV's spec §3).
- Each root form is proved through its own row. Row 9's root form is proved through `Web.paths_one_object`, not through the other root forms. The acyclic boundary that rows 1, 8 and 9's laws state is `«续无外则同一中心»` (GS2), which those laws cite.

*(Corrected twice on 30 October 2026, before landing. The first wording said the measure reports these as representations. The second counted all six root forms as items. MV's spec, which landed after this design was reviewed, counts own-carrier statements apart and takes no instance or specialization as an item. The review of the Lean found the second error ([REVIEW-U3-LEAN](REVIEW-U3-LEAN.md)).)*

## 4. Smallest Lean items (none claimed)

If OU's owner wants the root forms in the package:
1. **The root forms of rows 1, 5, 7, 8 and 9** go in a leaf importing `Relevance`, `Extension`, `GrammarScope` and `Regions`. Each is one line of composition, and no definition is added.
   - **The handoff names the existing records each composes:** the records of `Web.paths_one_object`, `Web.widens_iff_retains_adds`, `unrestricted_iff_livingSignificance`, `Web.widens_iff` (the master laws on the grammar), GS2's condition on the root and `Weighting.widens_iff_every_positive`. It also names the source-bound check evidence.
   - **These compositions are not new results.** They are their records' root statements, added to those records' laws where their owners agree.
2. **Row 10's interface law** goes in `Becoming.Weightings`, beside `widensOn_iff`, under that module's owner or rule 3's fallback.
3. **`«广之对应»`** is proposed to `GrammarTransport`'s owner, and added only when a consumer reads it.

## 5. What would change this design

- **If a review finds** that a root form says more than its composition (for example, that `noOutside_iff_paths_livingSignificance` is read as the root grounding significance), the wording changes before anything lands.
- **If the step of invariance were settled** (07 §4, a philosophical question), the structural reading would be argued, not supplied. That is outside this item.
- **If GW's join** (generation and widening, one way) **lands as Lean**, row 10's interface could be stated alongside `全生成` on the held possible. That is a later connection, not this item's.

## 6. The review's findings and where each is taken

| Finding | Taken in |
|---|---|
| 1. Row 7 not stated at its own scope (every `living`, `Comparison`) | `paths_comparison_grammar` (scratch, checked), §1 row 7 |
| 2. The acyclic boundary not carried into every place it binds; exact quantifiers | §2, rewritten with exact quantifiers; §1 rows 1, 8 and 9; scratch docstrings |
| 3. Row 10's scope (finite list, Boolean admission, natural-number positive weights); "mixed unranked" made exact | §1 row 10; scratch docstring |
| 4. The transport lemma restricted to `Type 0` | scratch `guang_correspondence` made universe-polymorphic |
| Handoff: name existing records and evidence; compositions are not new results | §4 item 1 |

