# The boundary field: each central declaration's standing, declared on U4's record and checked against the Lean

**Status:** draft 2, for a re-check. MV's part of U4's boundary record ([WHAT-REMAINS](../../../2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), "One root to its edge" and "OU's decisions on U4"). U4's owner asked for it on 30 October 2026, and agreed that the record is built to it and that the field lands first, as F5's field ([F5-MODEL-STATEMENTS.md](F5-MODEL-STATEMENTS.md)) landed before U2's Lean. Draft 1 (88b470a44) was read by three independent reviewers, for the Lean, for the edge's meaning and for the tooling ([reports/boundary-field-review.json](reports/boundary-field-review.json), 49 findings). Every finding is taken (§9). This draft follows U4's design as revised after U4's own review (DESIGN-BOUNDARY.md and boundary_table.py on branch u4-edge, 2cc1bac0b). Nothing here is claimed for the Lean package. Landing the field changes no figure: the report exists only once a record carries the field.

## 0. What the field is for

U4's edge has three standings (WHAT-REMAINS, "What the edge is"):
1. **derived:** it follows from the grammar's laws, for every relation and class;
2. **on the root under a stated hypothesis:** the hypothesis is written in the grammar's terms, and a countermodel on the root shows it cannot be dropped;
3. **a premise:** stated on the root, with a proof that no statement about the dynamics entails it.

Any other standing is a distance from the edge. OU's owner decided that MV counts these standings once the boundary record lands, and until then the F5 figures stand. F5's own report (`central_reach`: 44 / 16 / 7 / 51 on core run 20261030T131028.245732Z) stays unchanged beside the new one.

**The principle is F5's.** What the Lean cannot show is declared and reviewed; the rest is computed. The checker cache records, for each constant, the run's constants its type and its value name, and nothing of Lean's `Init` (logic and the arithmetic of `Nat` and `List`). It holds names, not terms. So most of what MV checks here is names and dependencies, and the review reads the shapes. Where the field needs one shape exactly, the certificate tying a theorem of the leaf to a row, this spec proposes one small field for the dump (§3.0), which Lean computes from the term.

**Three findings shape the design.** U4 reported them, and the probe in [boundary/](boundary/) confirms them (§6).
- **A name test on rows measures packaging, so it applies to declared items.** No central declaration's statement passes the name test of §3.0; with its definitions unfolded 11 do, and with structures unbundled 105 (U4's finding 1). So every standing on the edge is carried by a declared item: a grammar law the row is a case of, or a root form the row is an instance of.
- **Reaching the grammar is connection, not derivation.** 43 of the 44 rows that reach the grammar reach a grammar law, mostly closure's elementary laws used as steps. The measure's "reaches the grammar" says a grammar law or term is among the reasons, never that the row is a case of a law.
- **Balance enters by the statement or by the proof.** The rule reads the statement only (U4's rules, DESIGN-BOUNDARY §2); where only the proof reaches balance, that is reported and places nothing.

**What the field takes from F5's plan** (F5-MODEL-STATEMENTS §4). It takes telling derivation from connection: "derived" against the rule's "connected". It does not take F5's premise value. That value is the grammar form of a premise in COVERAGE.json's register (K3), such as `Web.Dependent` with `dependent_iff`; a standing-2 hypothesis matching a K3 premise names it in its basis (U4 §1.2), and where the premise value lives otherwise is OU's owner's decision, by F5 §4's fallback. Draft 1 said this field took it over; that was wrong.

## 1. The standings and the labels

Every distinct central declaration of `COVERAGE.json` (118 at core run 20261030T131028.245732Z) gets exactly one label.

| Group | Label | How a declaration gets it |
|---|---|---|
| on the edge | derived | declared, and checked (§3.1) |
| | under a stated hypothesis | declared, and checked (§3.2) |
| below the grammar | counting | a reading (§3.4) |
| distances | connected | the rule (§3.5), or a reading |
| | witnessed at its model | a reading |
| | balance in its statement | the rule, or a reading |
| | amounts | a reading |
| | at a represented model | the rule, from F5's verified items |
| | own carrier | the rule, from F5's verified items |
| | at its model | a reading |
| | free significance | a reading |
| none | unplaced | the rule's fallback |

- **Premise is not a label of a central declaration.** All 118 central declarations are theorems, and a theorem whose statement were a premise would prove it. The premises are definitions, and the record lists them apart (§2, §3.3).
- **Below the grammar** is its own group because lever 2's review decided that laws of counting are counted apart, neither distances nor derived (REVIEW-U4-L2, S2; U4 §1.4).
- **Precedence:** a checked entry on the edge, then a reading, then the rule. An entry on the edge that fails places nothing: its row takes the rule's label, and the entry is listed as unverified (§3.6). A reading may give any label but the edge's and "unplaced"; one equal to the rule's label is shown as such. "Unplaced" exists so that no row takes a distance by default; the record is complete when no row is unplaced.
- **The labels are U4's** (DESIGN-BOUNDARY §0), with one renaming proposed to U4: the rule's "balance, represented" becomes "balance in its statement". The measure's EC6 category of the same name is a different set of 31 rows: 19 with `Flow`'s balance in their statements, 2 with it only in their proofs and 10 with the prelude's counting law alone. The rule's 31 are the 19 and 12 rows reaching the grammar. Two sets under one name on one page would mislead. The labels' sense is U4's record's to state.

## 2. The field

The field is called `boundary`. It sits on one record, U4's boundary record, of schema 2; the check refuses it on a second record and on a superseded or withdrawn one. It is an object with two keys, both required.

**`standings`:** a nonempty list, one entry per central declaration that a declaration places, on the edge or by a reading. A row the rule places is not written here.

| Key | Required for | Content |
|---|---|---|
| `declaration` | every entry | the central declaration, full name; at most one entry per declaration |
| `standing` | every entry | one of the labels of §1 but "unplaced" |
| `basis` | every entry | `{en, zh}`, at least one nonempty: why, in the record's words |
| `review` | every entry | a review reference of the record (§2, check rules) |
| `law` | derived | the grammar law the row is a case of |
| `bridges` | derived, when the closed set needs any (§3.1) | nonempty list: the model theorems the derivation goes through |
| `form` | under a stated hypothesis | the root form F |
| `hypotheses` | under a stated hypothesis | nonempty list of `{hypothesis, countermodel}`, no other keys |
| `recovery` | under a stated hypothesis, unless the row's own proof applies the form | a theorem stating the row, proved through F |
| `certificate` | exactly when `recovery` is given | the theorem tying the row to the recovery (§3.2, S5) |

No other key is allowed, and a key outside its standing is refused. A reading carries only the first four.

**`premises_of_the_ethics`:** exactly two items, one for each premise the ethics rests on: the continuation condition (role `scope`) and C (role `order`), as AGENTS.md asks wherever the ethics is summarized. The list is named for them because "premise" already names COVERAGE's category "premise of the account" and K3's register.

| Key | Content |
|---|---|
| `role` | `scope` or `order`, each once |
| `name` | `{en, zh}`, at least one nonempty |
| `premise` | the definition stating it, or `null` |
| `not_entailed` | a theorem showing that no statement about the dynamics entails it, or `null` |
| `absent` | required when either of the two is `null`: why |
| `basis`, `review` | as for a standing |

For the condition: `premise` `Becoming.Unrestricted`, `not_entailed` `Becoming.ReadsOnlyDynamics.not_entails`. For C both are `null`: no Lean statement holds C's content, calling widening better. `Becoming.Comparison` leaves "better" free, and with better read as widening it holds by definition (`Web.paths_comparison_widens`, whose docstring says "that widening is better is supplied by the reading of 'better', not shown here").

**The check's rules** (registry.py, which reads no Lean):
- the keys are closed at every level, as above; lists are nonempty where present; `basis` and `name` take English or Chinese;
- no declaration appears twice, and no premise role twice;
- `law`, `form`, `recovery` and `certificate` differ from the declaration, and `bridges` does not hold it;
- every name an entry introduces in the leaf (`form`, each `hypothesis` and `countermodel`, `recovery`, `certificate`) is among the declarations of the record's own laws, so each has its proof binding and its place in the core; `law` and `bridges` belong to the grammar's modules and the models' and need not be;
- `review` is among the record's review references, and its file names in code spans the declaration and every name the entry gives (`law`, each bridge, `form`, each hypothesis and countermodel, `recovery`, `certificate`; for a premise, `premise` and `not_entailed`), matched as F5's review is;
- whether the declaration is a central one is the generator's to check (§3.6), not the registry's, so a renamed COVERAGE row never makes the check fail for every lander.

One hypothesis definition may serve several entries (rows 13 and 14 would have shared cancellation); each entry gives its own countermodels.

## 3. Checking (master_laws.py, from the checker cache)

### 3.0 Terms

- **Generated auxiliaries** are Lean's own constants, named by their last component: `match_N`, `_proof_N`, `proof_N`, `eq_N`, `eq_def`, `sizeOf_spec`, `_sizeOf_N`, `_sizeOf_inst`, `inj`, `injEq`, `brecOn`, `below`, `binductionOn`, `casesOn`, `recOn`, `rec`, `noConfusion`, `noConfusionType`, `ctorIdx`, `toCtorIdx`, `elim`, `_unsafe_rec`, `_sunfold`, `_flat_ctor`, `_aux_N` and `_default`. They are never laws, bridges or theorems a proof names: every walk below goes through them.
- **A root constant** is a constant of `Becoming.Prelude` or of a `Becoming.Grammar*` module whose statement reaches, all the way down, only such constants (a theorem's statement is its type; any other constant's is its type and its value). The probe finds 2,260; 64 constants of those modules are off the root because they are built on a model, such as `ClosedCapture.lockedAlike`.
- **The name test**, on a declared item. The constants its statement names directly (a theorem's type; a definition's type and value), with its own auxiliaries walked through, are root constants or definitions the test allows. Nothing else is unfolded. This is U4's test (DESIGN-BOUNDARY §1.5), with a definition's value read and constants of grammar modules built on models excluded.
- **A grammar term** is a «» constant other than «际» (F5's test).
- **A grammar law** is a theorem whose last name component is a «» name and that is not an auxiliary, whose statement passes the name test and reaches a grammar term, whose statement names no closed value of the run (the dump's `cv`: it holds of every relation, not of one constructed net), and whose proof names only root theorems and grammar laws. The probe finds 391 of the 412 theorems with «» names. It leaves out 13 witnesses about one constructed system, such as `«两火以薪定理»`, and 8 laws of logic, such as `«非真则假»`. GrammarLaws' number and list helpers, which that file says are "not statements of the grammar", have no «» name and are not laws; nor is `kept_onward`, whose statement is about `Nat` alone. Two laws are declared in model modules, `«全生成则生成»` and `«及在渐粗列之相续»`, and count, since they are stated and proved on the root. The rule, the checks and the pages use this one predicate. Its code is among the inputs MV hashes.
- **A forwarder of a grammar law** is a theorem whose dump `f` names a grammar law or another forwarder, of kind `pure` or `projection`, and whose proof names no other theorem of the run. The probe finds 14, all through closure's laws, such as `WithinClosure.not_rel` for `«所闭之界»` and `Flow.WithinFeeding.trans` for `«所闭之传递»` (through `WithinClosure.trans`).
- **The theorems a proof names** are found by walking its value through definitions, instances and auxiliaries, their types and values, stopping at theorems, which are collected, and at root constants. A model theorem used through a definition's value, an abstracted `_proof_N` or a `Decidable` instance is therefore seen.
- **A counting law** is one of the measure's balance anchors (`Flow.Balances`, `Flow.BalancesOn`, `Flow.BalancesBetween`, and the prelude's `balance_over_stretch_on`), or a root theorem whose proof reaches one.
- **The grammar laws a declaration reaches** are found by walking its type and proof through its model's content, stopping at grammar laws and forwarders, which are collected, and at root constants.
- **What the dump does not show.** Every check holds up to `Init`. A proof can do arithmetic of its own with `Nat` and `List` lemmas or `omega`, and the dump shows nothing of it. The pages say "theorems of the run named (Init not shown)" wherever they list them.

**The field proposed for the dump.** THEOREM-CONNECTIVITY-DUMP.lean gains `eq` for a theorem whose type, metadata aside, is `@Eq _ (.const a us) (.const b vs)`: the pair `[a, b]`, with `eqg`, whether each side is at distinct level parameters of the theorem, that is at its full generality. [boundary/certificate-idiom.lean](boundary/certificate-idiom.lean) defines it and runs it on Lean 4.29.1:
- the certificate `@row = @recovery := rfl` gives `eq` `[row, recovery]`, both general;
- a certificate between an implicit and an explicit binder checks, since binder kinds are ignored;
- a row at `Type u` against a statement at `Type` checks only as `@rowU.{0} = …`, and `eqg` says the row's side is not general;
- `@row = @row ∧ @other = @other` checks and names what a certificate names, but has no `eq`;
- a certificate between different statements, and one with the row at full generality against a statement at `Type`, fail ([boundary/certificate-idiom-wrong.lean](boundary/certificate-idiom-wrong.lean)).

The field is computed from the term, adds one key to some lines of the dump and changes no consumer's figure. The dump belongs to R32's programme, which has closed, so the change needs the coordinator's yes on RA's row (§8).

### 3.1 Derived

Let Y be the entry's `law` and Br its `bridges`.
- **D1.** Y is a grammar law.
- **D2. The closed set.** The theorems the row's proof names, and those each bridge's proof names, are grammar laws or their forwarders, root theorems that are not counting laws, or bridges. This is U4's rule ("derived is a declared grammar law reached through named bridge equivalences").
- **D3.** Y is among the grammar laws D2 reaches, directly or through a forwarder.
- **D4.** Every bridge is reached from the row in D2's walk: none is listed unused.
- **D5.** No counting law is reached. A derivation through balance or the prelude's counting law is a distance, and its row keeps the rule's label.

**Reported on the page and in the data:** the other grammar laws used, the root theorems named, and whether the row is itself a forwarder of Y. A forwarder is the exact case, shown as "a forwarder of the law": the row's proof is Y applied at the model's terms, possibly one direction of an iff, possibly with hypotheses Y does not use. The count of derived rows gives how many are forwarders.

**What this does not show,** and the review reads:
- that each bridge is an equivalence holding at every instance of the model's parameters and adding no hypothesis (U4 §1.1);
- that the row's proof applies Y as the case and not as one step among the bridges' facts: the names show that Y is used, not how;
- arithmetic done in `Init`.

So a derived entry reads, on the page, "derived, a case of Y through the bridges named; the law and bridges checked against the Lean by name and dependency; the case read in [review]".

### 3.2 Under a stated hypothesis

This is the strict reading, which U4's design adopts (DESIGN-BOUNDARY §1.2): F is stated over variable relations and amount functions, and the row is F at its model. Let H₁…Hₙ be the hypotheses, K₁…Kₙ their countermodels, R′ the recovery and c the certificate.
- **S0.** F passes the name test, with its hypotheses allowed, and reaches a grammar term, by itself or through its hypotheses.
- **S1.** F's type names each Hᵢ directly.
- **S2.** Each Hᵢ is a definition that passes the name test and names a grammar term directly. A hypothesis constraining amounts alone fails, as cancellation `G.raisedAt t = G.loweredAt t` would stated over amount functions: such a hypothesis keeps its row at amounts (U4 §1.2).
- **S3. The countermodel.** Each Kᵢ is a theorem in the idiom `Hᵢ_needed`: at a witness w, `theorem Hᵢ_needed : ¬ Hᵢ w := fun h => fails (F w o … h …)`, where the facts o state the other hypotheses at w and `fails` states that F's conclusion fails there ([boundary/certificate-idiom.lean](boundary/certificate-idiom.lean), `incl_needed`). Applied this way, the kernel checks that the facts fit F's other hypotheses and its conclusion. MV checks:
  - Kᵢ's statement names Hᵢ, and passes the name test with the hypotheses and the definitions of F's module (the witnesses) allowed;
  - Kᵢ's proof names F and at least one other theorem;
  - each of those others (the facts) is a theorem of F's module that reaches neither F nor the row.

  The facts are reported. A Lean `example` leaves nothing in the environment, so countermodels and facts are named theorems.
- **S4.** F's proof names only root theorems, grammar laws and their forwarders: F is proved on the root. It does not reach the row.
- **S5. The recovery.** R′ reaches F and not the row, and the certificate c has `eq` `[row, R′]` with the row's side general: Lean has checked that R′ states what the row states, at its full generality. The other theorems of the run R′ names are reported: through them the row's model meets the hypotheses. Where the row's own proof applies F, R′ and c are absent and the row's proof must reach F; that needs F in a module the row's module imports.

**What this does not show,** and the review reads:
- that each Hᵢ is a hypothesis F keeps, not a typing binder or a list fact;
- that each Kᵢ's proof is the application above: the names show that it uses F and the facts, not that it is that term;
- that definitional equality in c includes evaluation, so `twice 3 = 6` certifies as `6 = 6` (`certEval`): the review reads that R′ states the row in its own terms;
- that a certificate needs the row's binders in the same order: U4 states R′'s binders as the row's.

Where a hypothesis matches a premise of K3's register, the basis names it (U4 §1.2), and K3's witnesses may be cited beside the countermodel.

### 3.3 The premises of the ethics

- **Q1.** For an item with both names: `premise` is a definition, and `not_entailed` a theorem whose type names it. The review checks that it states non-entailment by every statement reading only the dynamics, as `ReadsOnlyDynamics.not_entails` does.
- **Q2.** Whether `premise` passes the name test, reported as "on the root" or not. `Unrestricted` does not: its value names `Becoming.Neutral` (Metaethics), and 07 §4.5 says the free significance of §1 is not lifted onto the root.

Each premise is reported in two parts: not entailed (checked, not shown, or unverified) and on the root (yes or no). An item with a `null` is shown "not shown", with its reason. An item whose names fail Q1 is unverified.

This corrects a sentence inherited from WHAT-REMAINS ("The continuation condition and C stand here already (`ReadsOnlyDynamics.not_entails`)"), repeated in U4's design §1.3: the not-entailed theorem is the condition's alone, and C has none, nor a Lean statement of its content. OU's owner and U4's owner are asked to correct it.

A row whose kept hypotheses are the premises is not under a stated hypothesis: `not_entails` is not a countermodel (it shows that no law of the dynamics gives the premise, not that the row needs it), and a form keeping `Unrestricted sig` fails S2. Rows 1, 8 and 9 stay at free significance until 07 §1's open root reading exists, as U4 reads them.

### 3.4 Readings

A reading is declared and reviewed, and MV does not try to falsify it. Beside it the page and the data show the rule's label where it differs, F5's verified items for the row, the grammar laws the row reaches, and where balance enters.

### 3.5 The rule

This is U4's rule (DESIGN-BOUNDARY §2; boundary_table.py, `standing`), which reads only the statement or facts recorded apart, with the fallback "unplaced":
1. a row with one of `Flow`'s balance anchors in its statement is **balance in its statement**;
2. a row the measure has reaching the grammar is **connected**, with the grammar laws it reaches listed, or "the grammar's vocabulary only" where it reaches none;
3. a row with an F5 item at `occurrence` or `process` is **at a represented model**; one whose only items are `own` is **own carrier**;
4. any other row is **unplaced**.

A balance anchor's being in the statement means it is in the statement's closure: the type and the definitions it unfolds to, all the way down. Where only the proof reaches `Flow`'s balance or the prelude's counting law, the row's data says so; it places nothing. On the current data the rule gives 31, 32, 16, 7 and 32 unplaced; U4's readings place the 32 and move 8 connected rows to derived.

### 3.6 Failures and staleness

As for F5, the generator never refuses to run.
- An entry that fails a check is written as unverified, with the checks it fails, and its row takes the rule's label. An entry whose declaration is not a central one is unverified for that reason.
- An entry the registry would refuse is written the same way: the generator mirrors every rule of §2 except the review's text.
- If no record or more than one carries the field, the data holds `boundary: {error, records}` and nothing renders.

The check's `master_laws` status lists:
- `boundary_unverified` and `boundary_premises_unverified`;
- `boundary_unplaced`;
- `boundary_not_matched`: each central declaration whose entry on the record, or its absence, differs from the data's, and a premises list that differs.

`current` is false while `boundary_not_matched` is nonempty. A standing's page line shows only while its declaration is matched and, for a line placed by the rule from F5's items, while each F5 law it cites is matched. U4's landing requires the four lists empty, and the premise items "not shown" are not unverified. That gate is U4's review's to keep.

## 4. The report

`master-laws.json` gains `boundary` once a record carries the field:
- `record`;
- `counts` for each label of §1, `derived_by_forwarder`, and `groups` (on the edge, below the grammar, distances, unplaced), which sum to the distinct central declarations;
- `against_f5`: each label against F5's four classes, so the report shows how the standings divide F5's 44 / 16 / 7 / 51;
- `premises_of_the_ethics`, each with its two parts;
- `unverified`;
- `rows`: for each central declaration, its label and how it came (checked entry, reading or rule), the rule's label, the basis, F5's items, the grammar laws it reaches, where balance enters, and the entry's names with what §3.1 and §3.2 report and any failures.

**The record's own laws are counted apart.** The forms, hypotheses, countermodels, recoveries and certificates are declarations of the boundary record's laws, and they reach the grammar and the rows. So every law of the record carrying `boundary` goes into `counts_at_boundary`, not `counts`, as F5's carrying laws go into `counts_at_model`. U4's landing then changes no existing count; a test asserts it. F5's `central_reach` is unchanged.

## 5. The pages

- **The boundary record's page** gets a generated section listing the central declarations by group and label, headed by a counts line, with each line giving the declaration, how it was placed ("declared; checked; reviewed in" with its review, "a reading" with its basis, or "by the rule" with its reason) and, for the edge, the law and bridges, or the form, hypotheses with countermodels, recovery and certificate.
- **Every record page whose law names a central declaration** gets one line under that law for each such declaration, as F5's statements at a model get theirs: "Standing: derived, a case of `«像定后当且仅当同行»` through `Learning.lumped_iff_fixed_image` and `goAlikeUnder_iff_alike` (declared in [record]; checked; the case reviewed in [review])", or "Standing, by the rule: connected (it reaches `«所闭之传递»` and `«缘在所闭»` among its reasons; not declared a case of one)". The master-law note above it is unchanged: it gives the measure's dependence, and the standing line gives the edge.

## 6. What the probe found

The probe is [boundary/probe.py](boundary/probe.py), rewritten to this draft's terms, with output [boundary/probe.json](boundary/probe.json). It ran on the constants of core run 20261030T131028.245732Z, from `measure_grammar.py --save`, with main at `4ac8cf27e`.

- **The name test:** no central declaration passes it.
- **Grammar laws:** 391; 14 forwarders, none a central declaration; 64 constants of grammar modules off the root (§3.0).
- **Reach:** 43 of the 44 rows reaching the grammar reach a grammar law. `Web.Whole.family_excess_ends` reaches only `kept_onward` and the grammar's vocabulary. U4's table counts `kept_onward` as a law, since GrammarLaws' header names it among its laws; by §3.0 it is a law of `Nat`, so the row is connected through the vocabulary. The difference changes no label.
- **Balance:** 12 of the 44 and 19 others have `Flow`'s balance in their statements: 31, as U4 has.
- **U4's eight derived rows**, with the row as the derivation and every model theorem its proof needs treated as a bridge. For each, Y is a grammar law, the closed set reaches it, no counting law is reached, and the row is not a forwarder.

| Row | Y | Bridges U4 names | Further bridges the closed set needs |
|---|---|---|---|
| `Flow.beyond_gives_nothing` | `«所闭之界»` | `eq_zero_of_not_pos` | none |
| `Flow.withinSystem_of_withinInfluence` | `«所闭之单调»` | `shares_of_affectedBy` | `WithinClosure.mono`, the law with its arguments reordered, which the dump's `f` does not catch |
| `Law.drawn_iff_not_returns` | `«定后有后则入当且仅当不返»` | `drawn_iff_drawnIn`, `absorbing_iff_closed`, `reaches_iff_orbit`, `returns_iff_reaches` | `Law.returns_iff`, `reaches_of_orbit`, `orbit_add`, `orbit_shift`, `next_fixed`, `next_total`; `Branching.law_reach_iff`, `law_trace_iff`, `law_trace_of`, `units_length` |
| `Law.lossless_iff_returns` | `«有限遍后定后则定前当且仅当皆返»` | `lossless_iff_fixedBefore`, `returns_iff_reaches` | `Law.lossless_iff`, `reaches_iff_orbit`, and the ten above |
| `Learning.goAlike_iff_lumped` | `«像定后当且仅当同行»` | `goAlikeUnder_iff_alike`, `lumped_iff_fixed_image` | none (it also uses `«同行之逐点»`) |
| `Tolerance.answers_restores_iff` | `«承之迭»` | `chain_iff_steps` | `Tolerance.KeepsInclusion.course`, `KeepsInclusionInto.course`, `answers_keeps`, `worst_start`; `Withholding.answers_closed`, `Chain.last`, `Chain.last_of_eq`, `Chain.zero_eq` (it also uses `«迭之末步»`) |
| `Withholding.withholding_spreads` | `«存承之迭»` | `within_iff_withinSteps`, `chain_iff_steps` | `Withholding.waitsAll_closed`, `Chain.last`, `Chain.last_of_eq`, `Chain.zero_eq` |
| `WithinMoves.after_course` | `«迭内之接»` | `trace_steps`, `trace_iff_steps`, `withinMoves_iff_withinSteps` | none |

Three closed sets are U4's bridges exactly. For the other five the record declares the further theorems as bridges, and the review reads each as U4 §1.1 asks; a row whose bridges include a model fact that is not an equivalence adding no hypothesis stays connected.

## 7. Answers to U4's owner

- **Derived.** The closed set, as agreed, with the lists of §6. "Derived" and "under a stated hypothesis" are never readings; "connected" may be, and equals the rule's label for `Flow.mutuallyDependent_iff_reach`.
- **Standing 2.** The strict reading, as U4's design adopts. The countermodel idiom changes from "the negation of F with one hypothesis dropped, not proved through F" to `Hᵢ_needed` (S3), because applied that way the kernel checks that the facts fit F's other hypotheses and its conclusion; lever 2's witnesses carry over as the facts and witnesses. Countermodels must be named theorems, not `example`s. Rows 5 and 17 reach standing 2 once their forms are restated over variable relations; the current forms keep `Flow` and `Web` and fail S0, as U4's table has them ("witnessed at its model"). Rows 13 and 14 stay at amounts: their cancellation constrains amounts.
- **The certificate** is `theorem c : @Row = @R′ := rfl`, checked exactly through the proposed `eq` field, with R′ stated at the row's full generality and with the row's binders in order.
- **Premises.** No central declaration is a premise; the record lists the two premises of the ethics apart, the condition with its not-entailed theorem and C with none (§3.3).
- **The labels.** "Balance, represented" becomes "balance in its statement" (§1). Each label names what it records, not a remedy: balance in its statement, with `pairs_without_one_to_one` and `repeated_unit` as the witnesses that the represented balance is not the root's (U1's verdict stands); amounts, the root's second sort, which no lever brings onto the root (lever 2 §6); at its model, a hypothesis not yet stated; free significance, kept open on purpose (07 §1). Draft 1 named lever 1 and units as remedies; both avenues are closed.
- **`kept_onward`** is not a grammar law by §3.0 (§6).

## 8. Order of work

1. **MV lands the field first,** with one claim on RA's row of the board. That covers this specification, the registry's check, the generator's checks, rule and report, `counts_at_boundary`, the page lines, the `eq` field in the dump with the coordinator's yes, a RESULT-WORKFLOW paragraph, and the tests below. The spec and the code each get an independent review and a re-check. No record carries the field, so no figure changes; the dump's new field changes none either, which a test asserts.
2. **U4 builds the leaf and the record.** The leaf is a core leaf, as `SignificanceStatements` is: rows 5 and 17's strict forms, their hypotheses as named definitions, the countermodels, facts and witnesses, the recoveries and the certificates. The record carries the field, with the eight derived rows' bridges as §6 lists them. The landing reruns `master_laws.py` and requires none unverified, unplaced or not matched. It lands after GW's landing, by OU's order.
3. **OU's owner** brings WHAT-REMAINS and 08 §7's account of the edge to MV's report, with the correction of §3.3.

**RESULT-WORKFLOW** gains a paragraph: `law` and `bridges` declare a correspondence (the row is a case of a law through these bridges), as F5's `of` does; they record nothing about which master laws a row rests on, which stays computed.

**The tests**, all against a synthetic pickle fixture, with the pages rendered in a scratch worktree:
- **Registry.** The field on a schema-1, superseded, withdrawn or second record; unknown keys at every level; each standing's required and forbidden keys; `recovery` without `certificate` and the reverse; an introduced name equal to the declaration; empty lists; duplicate declarations and roles; premises other than one `scope` and one `order`; `absent` missing beside a `null`; a review that is not a review reference or does not name each name; an introduced name outside the record's law declarations.
- **Generator.** A passing and a failing case for each of D1–D5, S0–S5, Q1 and Q2; a forwarder row and a projection; the predicate of §3.0 on a helper, a witness theorem, a logic law, an auxiliary and a grammar-module constant built on a model; the walk through a definition holding a theorem; every branch of the rule, unplaced included; precedence (a checked entry over a reading over the rule, and a failing entry falling to the rule); a declaration that is not central or not in the run; malformed entries never crashing; counts summing to the distinct declarations; `counts` unchanged by the boundary record's laws.
- **Pages.** One line per central declaration under a law naming several, and under laws in several records; lines hidden when not matched, or when an F5 law they cite is not matched; pages byte-identical when no record carries the field.
- **Status.** The four lists and `current`; the error when two records carry the field.
- **Lean and the dump.** certificate-idiom.lean and certificate-idiom-wrong.lean as in §3.0; the dump's output with `eq` equal to the present output on every other key, and THEOREM-CONNECTIVITY.json and the measure's report unchanged.

## 9. Findings taken

Draft 1's review had three lenses: Lean (BF-L1 to BF-L14), the edge's meaning (E1 to E16) and the tooling (BF-S1 to BF-S6, BF-M1 to BF-M8, and five low findings, here BF-T1 to BF-T5). All 49 are taken.

| Findings | What draft 1 had wrong | Where taken |
|---|---|---|
| BF-L1, E2, BF-S1 | "grammar law" admitted helpers, logic, witnesses, auxiliaries and model-built grammar constants; "17 forwarders" | §3.0's one predicate and root constants; §6 (14 through chains, 8 directly) |
| BF-L2, E6, BF-T2, BF-L7 | the lemma path claimed more than names show; forwarder claims overstated; wrappers missed | §3.1: the closed set, what it does not show, the forwarder reported with its limits; `WithinClosure.mono` as a bridge (§6) |
| BF-L3, E1, BF-S3 | standing 2 checked the loose reading | §3.2 S0 and S4, the strict reading |
| BF-L4, E12, BF-S4, E8 | S2 read a definition's type, passed Nat-only hypotheses vacuously; incomplete verdicts | §3.0's name test reads the value; S2 requires a grammar term; §7 on rows 5, 13, 14 and 17 |
| BF-L5, BF-S2, BF-L14, BF-M3, BF-L6, E16 | certificates checked by names; idiom files tested another shape; universes, evaluation, binder order | §3.0's `eq` field and the new idiom files; S5; §3.2's limits |
| BF-L8, BF-L13, BF-M2, E15 | proofs read one level deep; auxiliaries; one lemma level | §3.0's walk and auxiliaries; D2's closed set; S5 when the row applies F |
| BF-L9, BF-T4 | prelude counting laws allowed freely | §3.0 counting laws; D5 |
| BF-L10 | countermodels barred from F | §3.2 S3, `Hᵢ_needed`; named theorems, not `example`s |
| BF-L11, E3, BF-S6 | C had no not-entailed theorem; the condition not on the root | §2 `premises_of_the_ethics` with `absent`; §3.3 Q1, Q2 and the correction |
| BF-L12 | Init invisible but not said on the labels | §3.0, "Init not shown" on the pages |
| E4, BF-S5, E5 | premise standing unreachable for central rows | §1: premise is not a label; §3.3 on rows 1, 8 and 9 |
| E7, BF-M7 | U4's eight and readings not engaged | §6's table; §7 |
| E9, BF-M1 | the record's laws would change counts | §4 `counts_at_boundary` |
| E10 | the group below the grammar | §1 (lever 2's review); §4 `against_f5` |
| E11, BF-M4 | F5's premise value conflated; COVERAGE coupling; three senses of premise | §0; §2 (generator checks centrality; the list renamed) |
| E13 | stale remedies | §7, labels name what they record |
| E14, BF-M6 | one label, two sets; standing clause inside the note | §1 renaming; §5 own line |
| BF-M5 | staleness undefined | §3.6 |
| BF-M8 | no tests | §8 |
| BF-T1, BF-T3 | key rules open; the review named only the declaration | §2 |
| BF-T5 | probe differed from the spec; RESULT-WORKFLOW | probe rewritten; §8 paragraph |
