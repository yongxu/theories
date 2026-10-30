# The boundary field: each central declaration's standing, declared on U4's record and verified from the Lean

**Status:** draft 1, for review. MV's part of U4's boundary record ([WHAT-REMAINS](../../../2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), "One root to its edge" and "OU's decisions on U4"). U4's owner asked for it on 30 October 2026, and agreed that the record is built to it and that the field lands first, as F5's field ([F5-MODEL-STATEMENTS.md](F5-MODEL-STATEMENTS.md)) landed before U2's Lean. Nothing here is claimed for the Lean package. Landing the field changes no figure: the report exists only once a record carries the field.

## 0. What the field is for

U4's edge has three standings for a central declaration (WHAT-REMAINS, "What the edge is"):
1. **derived:** it follows from the grammar's laws, for every relation and class;
2. **on the root under a stated hypothesis:** the hypothesis is written in the grammar's terms, and a countermodel shows it cannot be dropped;
3. **a premise:** stated on the root, with a proof that no statement about the dynamics entails it.

Any other standing is a distance from the edge. OU's owner decided that MV counts these standings once the boundary record lands, and until then the F5 figures stand.

This field also takes over the two parts of F5 that its field left out (F5-MODEL-STATEMENTS §4):
- telling derivation from connection;
- the premise value.

F5's own report (`central_reach`: 44 / 16 / 7 / 51 on core run 20261030T131028.245732Z) is unchanged and stays beside the new one.

**The principle is F5's.** What the Lean cannot show is declared, and everything else is computed. Here that principle reaches further: where a correspondence can be stated as a theorem Lean checks, the field asks for that theorem rather than a declaration. Three findings shape the design. U4's owner reported them and the probe in [boundary/](boundary/) confirms them (§6).
- No central declaration's own statement names only grammar terms, so every standing on the edge needs a declared item.
- "Reaches the grammar" says only that a grammar law is among the reasons, never that the row is a case of one. All 44 rows reaching the grammar reach some grammar theorem, but mostly closure's elementary laws used as steps.
- The checker cache records, for each constant, the run's constants its type and its value name, and nothing of Lean's `Init`. A test on those sets cannot tell a translation lemma from a law of a model, since every theorem bottoms out in definitions and logic. So "a case of" must be shown in Lean's own terms: a certificate theorem or the dump's forwarder field (§3.1).

## 1. The standings and the labels

Every distinct central declaration of `COVERAGE.json` (118 at core run 20261030T131028.245732Z) gets exactly one label.

| Group | Label | How a declaration gets it |
|---|---|---|
| on the edge | derived | declared, and verified (§3.1) |
| | under a stated hypothesis | declared, and verified (§3.2) |
| | premise | declared, and verified (§3.3) |
| below the grammar | logic | a reading (§3.4) |
| | counting | a reading |
| distances | connected | the rule (§3.5) |
| | balance, represented | the rule |
| | amounts | the rule, or a reading |
| | at a represented model | the rule, from F5's verified items |
| | own carrier | the rule, from F5's verified items |
| | at its model | a reading |
| | free significance | a reading |
| none | unplaced | the rule's fallback |

**Precedence:** a verified entry on the edge, then a reading, then the rule. A declared entry on the edge that fails verification places nothing. Its row takes the rule's label, and the entry is listed as unverified (§3.6). "Unplaced" exists so that no row reaches "at its model" by default: that label is always a reading, with its basis. The record is complete when no row is unplaced.

The labels below the grammar and the distances are U4's (U4's owner's message of 30 October; [boundary_table.py](../../../2026-10-05-generative-foundation-review/root-foundation/development/u4-one-root-to-its-edge/) on branch u4-edge). MV adopts them unchanged, apart from the fallback. Their sense is U4's record's to state.

## 2. The field

The field is called `boundary`. It sits on one record, U4's boundary record, and the check refuses it on a second record and on a superseded or withdrawn one. It is an object with two lists.

**`standings`:** one entry per central declaration that a declaration places, either on the edge or by a reading. A row the rule places is not written here.

| Key | Required for | Content |
|---|---|---|
| `declaration` | every entry | a distinct central declaration of `COVERAGE.json`, full name; at most one entry per declaration |
| `standing` | every entry | one of: derived, under a stated hypothesis, premise, logic, counting, amounts, at its model, free significance |
| `basis` | every entry | `{en, zh?}`: why, in the record's words |
| `review` | every entry | a review reference of the record whose file names the declaration in code |
| `laws` | derived | the grammar laws the row is a case of |
| `lemmas` | derived, where its bridge names any | the model theorems the bridge's proof names, each proved from definitions alone |
| `bridge` | derived, optional | a theorem stating the row, when the row's own proof is not the case |
| `form` | under a stated hypothesis | the statement on the root |
| `hypotheses` | under a stated hypothesis | `[{hypothesis, countermodel}]`, at least one |
| `recovery` | under a stated hypothesis | a theorem stating the row, proved through the form |
| `certificate` | with a `bridge` or `recovery` other than the row, and for premise | the theorem that Lean checks to tie the row to it (§3) |
| `premise` | premise | a premise listed under `premises` |

No other key is allowed, and a key used for a standing other than its own is refused.

**`premises`:** the premises of the account, each `{premise, not_entailed, basis, review}`. `premise` is a definition, and `not_entailed` is a theorem showing that no statement about the dynamics entails it. The continuation condition (`Becoming.Unrestricted`, with `Becoming.ReadsOnlyDynamics.not_entails`) and C go here. They are not central declarations, so they are listed apart from the 118 and never added to them.

**The check's rules.** The registry reads no Lean.
- The keys are closed as above. `basis` is `{en, zh?}`, with `en` nonempty.
- `declaration` is in `COVERAGE.json`'s rows and appears once.
- Every theorem or definition an entry introduces is among the declarations of the record's own laws, so each has its proof binding and its place in the core: `bridge`, `certificate`, `form`, `hypothesis`, `countermodel`, `recovery`. `laws` and `lemmas` need not be; they belong to the grammar's records and the models' modules.
- A `premise` entry names a premise listed under `premises`.
- `review` is among the record's review references, and its file names the declaration (for `premises`, the premise) in a code span, as for F5's `review`.

## 3. Verification (master_laws.py, from the checker cache)

These terms are used below:
- A **grammar constant** is a name containing «» or a constant of a module named `Becoming.Grammar*`.
- A **grammar law** is a grammar constant that is a theorem. A pure forwarder of a grammar law also counts as that law at a model's terms: this is the dump's `f`, of kind `pure` or `projection` ([THEOREM-CONNECTIVITY-DUMP.lean](../../../2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-DUMP.lean), R32).
- The **prelude** is `Becoming.Prelude`.
- A declaration's **statement closure** is the run's constants its type names, together with the types and values of the definitions, inductives, constructors and recursors those unfold to, across modules, without entering grammar constants.
- A theorem is **from definitions alone** when its proof names no theorem of the run other than grammar laws and prelude theorems.
- The dump lists only the run's constants, so Lean's `Init` (logic and the arithmetic of `Nat` and `List`) is never seen. Every check below holds up to it.

### 3.1 Derived

Let B be the entry's `bridge`, or the row itself.
- **D1.** Each of `laws` is a grammar law, and its statement closure names nothing but grammar constants and the prelude.
- **D2.** The theorems of the run that B's proof names are exactly these:
  - the `laws`, or pure forwarders of them, at least one;
  - prelude theorems;
  - the `lemmas`.

  Nothing is left out of the entry, and nothing it lists goes unused.
- **D3.** Each of the `lemmas` is from definitions alone.
- **D4.** If B is not the row, the `certificate`'s type names both the row and B, and its proof names no theorem of the run beyond those its type names. The intended certificate is `theorem c : @Row = @B := rfl`. Lean accepts it exactly when the two state the same thing, up to definitional unfolding and binder kinds. It is a definitional equation between proofs, which proof irrelevance makes hold. The idiom was checked on Lean 4.29.1 ([boundary/certificate-idiom.lean](boundary/certificate-idiom.lean)), and a certificate between different statements fails ([boundary/certificate-idiom-wrong.lean](boundary/certificate-idiom-wrong.lean)).
- **D5.** If B is not the row, B's proof does not reach the row.

**Strength, reported on the page:**
- **a forwarder of the law.** B's `f` is one of `laws`, so the row's statement, hypotheses included, is the law's at the model's terms, definitionally. Lean's kernel checks this when B is elaborated, and nothing else enters.
- **with lemmas from definitions alone.** Otherwise. The model meets the law's conditions, or its terms translate into the grammar's, through the listed lemmas.

**What this does not show.**
- That B's own reasoning beyond the theorems it names is translation. `Init` is not in the dump, so a proof can do arithmetic of its own. The review reads B, and its lemmas.
- That B uses the law at all. Lean's unused-variable linter warns about a bridge that ignores a hypothesis, but the dump does not carry that warning. A row whose bridge never uses its law follows from definitions alone, which is logic or counting, and the review says so.

### 3.2 Under a stated hypothesis

Let F be the `form`, and R′ the `recovery`.
- **S1.** F is a theorem, and its type names each hypothesis directly.
- **S2.** Each hypothesis is a definition written in the grammar's terms: its statement closure names a «» term other than «际», or names nothing outside grammar constants and the prelude. The other terms it names are reported.
- **S3.** Each countermodel is a theorem whose type names its hypothesis and whose proof does not reach F.
- **S4.** F's proof does not reach the row. F is not the row restated, as a statement at a model is (F5).
- **S5.** R′ is the row, or a theorem tied to it by a `certificate` as in D4. R′'s proof reaches F, and, when R′ is not the row, does not reach the row. The other theorems of the run that R′ names are reported: through them, the row's model meets the hypotheses.

A hypothesis listed under `premises` is marked as a premise.

**What this does not show.**
- That each countermodel's statement says the other hypotheses hold and the conclusion fails. The intended shape is U4's `Ungated.gate_needed`: the other hypotheses, the conclusion's failure, and the hypothesis's failure.
- That the hypotheses listed are all of F's kept hypotheses. List facts and typing binders are not hypotheses in this sense.

The review checks both.

### 3.3 Premise

- **P1.** The `premise` is listed under `premises`. The `certificate`'s type names the premise, and its proof names no theorem of the run but the row: `theorem c : P := @Row`. The row's statement is then P, definitionally.
- **Q1.** For each of `premises`, `premise` is a definition and `not_entailed` a theorem whose type names it. The review checks that this theorem states non-entailment by every statement reading only the dynamics, as `ReadsOnlyDynamics.not_entails` does. Each premise is reported as verified or not.

### 3.4 Readings

A reading is declared and reviewed, and MV does not try to falsify it. Beside it the page and the data show:
- the rule's label, where it differs;
- F5's verified items for the row;
- for logic and counting, the theorems of the run the row's own proof names: none, or the list.

A reading of logic whose proof names a law of a model is listed in the check's status (`boundary_readings_to_reread`), as information, never as an error.

### 3.5 The rule

This is U4's rule (boundary_table.py, `standing`), with the fallback changed to "unplaced". The balance anchors are the measure's balance anchors that do not reach the grammar: `Flow.Balances`, `Flow.BalancesOn` and `Flow.BalancesBetween` (Flow's), and `balance_over_stretch_on` (the prelude's counting law). Balance is **in the statement** when one of Flow's anchors is in the statement closure. It is **only in the proof** when one is in the proof's dependency closure and not in the statement.

A row reaching the grammar (the measure's dependence):
- **balance, represented,** if Flow's balance is in its statement or only in its proof;
- **connected** otherwise, with the grammar laws it reaches listed.

Any other row:
- **balance, represented,** if Flow's balance is in its statement;
- **at a represented model,** if it has an F5 item at `occurrence` or `process`;
- **own carrier,** if its only F5 items are `own`;
- **amounts,** if the prelude's counting law is its only balance anchor, or Flow's balance is only in its proof;
- **unplaced** otherwise.

### 3.6 Failures

As for F5, the generator never refuses to run.
- An entry that fails a check is written as unverified, with the checks it fails, and its row takes the rule's label.
- An entry the check would refuse is written the same way. The generator mirrors every rule except the review's text.

The check's `master_laws` status lists `boundary_unverified`, `boundary_unplaced` and `boundary_not_matched`; the last lists entries that differ from the data's, which a rerun refreshes. The boundary record's landing requires all three empty. That rule is U4's review's to keep.

## 4. The report

`master-laws.json` gains `boundary` once a record carries the field.
- `record`.
- `counts` for each label in §1, and `groups`: on the edge, below the grammar, distances, unplaced. They sum to the distinct central declarations.
- `premises`, each verified or not.
- `unverified`.
- `rows`: for each central declaration, its label, and whether it came by verification, reading or rule. Also the rule's label, the basis, F5's items, the grammar theorems it reaches, where balance enters, and the entry's names, with the strength (§3.1), the reported terms (§3.2) and any failures.

The counts for laws (`counts`, `counts_at_model`) and F5's `central_reach` are unchanged. A boundary standing never moves a law between them.

## 5. The pages

- **The boundary record's page** gets a generated section listing the central declarations by group and label. Each line gives:
  - the declaration;
  - how it was placed ("declared, verified" with its review, "a reading" with its basis, or "by the rule" with the rule's reason);
  - for the edge, its laws, form, hypotheses with countermodels, and certificate.

  A counts line heads the section.
- **Every record page** whose law names a central declaration: the law's master-law note gains a clause for it, such as "Standing: derived, a case of `«像定后当且仅当同行»` (declared in [record]; verified; reviewed in [review])" or "Standing, by the rule: connected (it reaches `«所闭之传递»`, …)". The clause appears only while the record's entries equal the data's, as F5's lines do.

## 6. What the probe found

The probe is [boundary/probe.py](boundary/probe.py), with output [boundary/probe.json](boundary/probe.json). It ran on the constants of core run 20261030T131028.245732Z, from `measure_grammar.py --save`, with main at `4ac8cf27e`.

- **U4's point 2, corrected, holds.** All 44 rows reaching the grammar reach a grammar theorem. Most reach closure's elementary laws (`«所闭之传递»`, `«所闭之自反»`, `«缘在所闭»`, …). `Law.drawn_iff_not_returns`'s own proof names `«定后有后则入当且仅当不返»`.
- **U4's point 3 holds.**
  - Of the 31 rows of balance, represented: 19 have Flow's balance in their statement, 2 only in their proof, and 10 the prelude's counting law alone.
  - Of the 44 grammar rows: 12 take Flow's balance in their statement, 1 only in its proof (`act_courses_unselected`), and 3 the prelude's law alone.
- **Derived, as the rows stand.** No central declaration is a pure forwarder of a grammar law. Two meet §3.1 with the row as its own bridge:
  - `Flow.beyond_gives_nothing`: law `«所闭之界»` through `WithinClosure.not_rel`, its forwarder; lemma `eq_zero_of_not_pos`.
  - `Learning.goAlike_iff_lumped`: law `«像定后当且仅当同行»`; lemmas `Learning.lumped_iff_fixed_image` and `goAlikeUnder_iff_alike`.

  For the other 42, the row's own proof names model theorems that are not from definitions alone. A row becomes derived only through a bridge that meets §3.1, or it stays connected. Whether either of the two is a case of its law is for U4's review to read.
- **Seventeen model theorems are pure forwarders of a grammar law** (`WithinClosure.of_rel`, `WithinClosure.trans`, `Amounts.fallsStop_of_ends`, …), so the dump's field already finds the exact case. The grammar laws take their relation implicitly and their conditions explicitly. A forwarder must take a law's conditions as its own hypotheses, so a row whose model meets the conditions through its own lemmas is derived with lemmas, not a forwarder.
- **Row 1's statement is not the condition.** `unrestricted_iff_livingSignificance` names `Unrestricted`, `LivingSignificance` and `Frame`: it is the condition's reading at a model. A certificate `theorem c : Unrestricted sig := @row` would not check.

## 7. Answers to U4's owner

- **Point 1, agreed.** Derived is a declared law the row is a case of, shown as §3.1 shows it. Reach alone is connection, the rule's "connected".
- **Point 4, the labels.** Keep them all, with none folded into "the rest". Each distance names a different remedy:
  - balance: lever 1;
  - amounts: units;
  - at its model: a hypothesis to state;
  - free significance: kept open on purpose (07 §1).

  The one change is the rule's fallback. "At its model" by default would read a row nobody has read, so the fallback is "unplaced", and the record is complete when none is.
- **Point 5, the leaf.** For each row:
  - write each kept hypothesis as a named definition, named in the form's statement;
  - write each countermodel as a theorem whose statement names its hypothesis and whose proof does not use the form;
  - write the recovery as a theorem with the row's statement, proved through the form, with `theorem … : @Row = @Recovery := rfl` as its certificate.

  **Rows 13 and 14.** Their cancellation hypothesis, `G.raisedAt t = G.loweredAt t`, names model counts and no grammar term, so it fails S2. By WHAT-REMAINS's definition, the hypothesis is then not in the grammar's terms, and amounts are a distance. Either state it in the grammar's terms, or keep the two rows at amounts. One way to state it is the pairing `«对»` under the trait's class. Lever 2 shows the pairing is stronger than cancellation, so the countermodel would change. The choice is U4's.
- **Point 6, premises.**
  - The premises are listed apart, each with its not-entailed theorem.
  - A row whose kept hypotheses are premises is under a stated hypothesis when each premise has a countermodel showing that the conclusion fails without it. A not-entailed theorem is not such a countermodel: it shows that no statement about the dynamics gives the premise, not that the row needs it. It is recorded once, with the premise.
  - A central row is a premise only when its statement is one (P1). Row 1's is not (§6), so U4's reading "free significance" fits it.

## 8. Order of work

1. **MV lands the field first.** That covers this specification, the check's rules, the generator's verification, rule and report, the page lines, a RESULT-WORKFLOW paragraph, and tests through the real render. Each part gets one independent review and a re-check. No record carries the field, so no figure changes. MV claims it on RA's row of the board.
2. **U4 builds the leaf and the record.** The leaf is a core leaf, as `SignificanceStatements` is. It holds the forms, the hypotheses as named definitions, the countermodels, the bridges and the certificates. The boundary record carries the field. The landing reruns `master_laws.py` and requires none unverified, unplaced or not matched. It lands after GW's landing, by OU's order.
3. **OU's owner** brings WHAT-REMAINS and 08 §7's account of the edge to MV's report.

## 9. Findings taken

None yet: this is draft 1.
