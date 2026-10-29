# F5's field: statements at a model

AI-written, 30 October 2026, by MV's owner, on main at `24397d633`. It answers U2's request ([U2's design §7](../../../2026-10-05-generative-foundation-review/root-foundation/development/u2-rows-on-the-root/DESIGN.md#7-placement-decided-and-the-lean-item-not-yet-claimed)): which record field carries the pairs of a central row and its statement at a model, which F5 reads. F5 is item 全五 of full unification ([FU](../../../2026-10-05-generative-foundation-review/root-foundation/development/fu-full-unification/PROPOSAL.md), change 1): the measure reports derivation, representation at a model, and a named premise on the grammar apart.

**Status:** MV's part landed (study §458); U2's Lean fills the field. Draft 1 was reviewed by two independent readers, one on F5 and the measure and one on the schema and the record rules. They raised 20 findings ([reports/f5-field-review.json](reports/f5-field-review.json)), and §7 maps them. A re-check of draft 2 ([reports/f5-field-recheck.json](reports/f5-field-recheck.json)) found seven of them taken wrongly or in part and three new problems. It also applied the rules to U2's 21 drafted items. Everything it raised is taken (§7).

## 1. The field

A law of a record may carry `statements_at_model`, a list of items:

```json
{
  "en": "…, at the occurrence model …",
  "zh": "…",
  "declarations": ["Becoming.ModelStatements.roles_supported_reading", "Becoming.ModelStatements.supported_iff"],
  "statements_at_model": [
    {"declaration": "Becoming.ModelStatements.roles_supported_reading",
     "of": "Becoming.Web.roles_supported",
     "models": ["occurrence"],
     "review": "_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u2-rows-on-the-root/REVIEW-U2.md"}
  ]
}
```

- `declaration` is the theorem that states the row at a model. It is one of this law's own `declarations`; the law's other declarations are its lemmas.
- `of` is the row whose statement it is.
- `review` is the path of a reference of role `review` in the same record: the review that checked this item, as it now stands, against its row. That `declaration` states what `of` states is a reader's judgment, which Lean does not show.
- `models` lists where the statement is stated: `occurrence`, a World's occurrence model (WRT2); `process`, a process's model (WRP2: its moves' relations, its steps and the step index); `own`, the row's own carrier. U2 §2's Model column gives them. Row 6's step index is `process`, since its statement names `Steps.next`. A row with two models, such as rows 10, 16, 20 and 24, lists both.

A law may hold several items. Row 24 has two with one `of`: `finite_reading_not_exact`, and `renewing_not_closed`, the closure form proved through it. `finite_reading_iff` relates the two forms without the row, so it stays a lemma.

**The rules the check enforces (`registry.py`, schema 2).**
- A law item's keys lie among `en`, `zh`, `declarations` and `statements_at_model`. As today, an item needs nonempty English or Chinese, since 13 current law items have English only. This closes a set that is open today, so a misspelled key fails.
- Each item has exactly the four keys. `declaration`, `of` and `review` are strings; `review` is the path of a `review` reference of the record, and where that file is readable it names the item's theorem (its last component, in code, qualified or not). This guards against citing a review that never mentions the item; that the review read the item as it stands is the landing's to ensure (§6). `models` is a nonempty list of distinct values among the three.
- `declaration` is among this law's declarations.
- `of` is among the declarations of another law of the same record, the row's own law. No declaration of a law carrying items is the `of` of any item in the record. This keeps one row's statement at a model off another row's law, as in joint-difference-making, where rows 11 and 14 have laws 6 and 7.
- Across all records, a theorem is the `declaration` of at most one item.
- The field is not allowed on a superseded or withdrawn record.

## 2. Declared and computed

Only the pair, its models and its review are declared. That `declaration` states what `of` states, at those models, is a reader's judgment. Lean shows that the theorem holds, not that its statement is the row's, so each item names the review that checked it. Everything else is computed by MV from the checker cache, which keeps a declaration's statement (`t`) apart from its proof or body (`v`).

**An item is verified where all of these hold:**
- **In the spine run:** both names are among the constants of the core receipt's run.
- **Proved through the row:** the walk from `declaration` through the constants each declaration uses, in its statement and its proof or body, reaches `of`. Grammar constants are not expanded, as U2Deps walks. The walk enters no declaration of another item, except an item on the same law with the same `of`. This stops a pair from naming the wrong row: a reading whose proof uses another row's reading reaches that row too. Take `significance_undetermined_reading` paired with `Web.roles_alive`. Its proof reaches that row only through `roles_alive_reading`, which is on another law, so the pair fails. A path through another statement of the same row on the same law is allowed, as `renewing_not_closed`'s path through `finite_reading_not_exact`.
- **On the grammar:** the grammar terms are the «» names other than «际». At least one occurs among the statement's constants, or in the bodies of the definitions of its own module that it names, and transitively in the bodies of the definitions of that module those name. For U2 that module is `Becoming.ModelStatements`. Grammar constants are not expanded. This reads more than U2Deps does, which counts only the statement's own constants. It is not the measure's grammar test either, which also counts «际». The depth matters: rows 21 and 22 reach WRT2's occurrence relations only at the second or third level, through `livingOcc` → `drawing` → `World.withinStep` and `descendsRel` → `descentStep` → `giving`.
- **At the declared models:** the statement names, in the same sense, a relation of each declared model, and `own` is not checked. The two lists split U2Deps' `modelRelations`:
  - `occurrence`: WRT2's `World.withinStep`, `Web.roles` and `Steps.along`;
  - `process`: WRP2's `moveRel`, `Steps` and `Steps.next`.

  U2Deps' other model relations are `Web.partialIdentity`, `sameValue` and `Web.admitted`. They are regions or classes on any carrier, so they count as the model's structure when computing other terms, but they are evidence of no model. The lists are written in the generator and hashed among its inputs, and WRT's and WRP's designer changes them.
- **Not on a central row's law:** the law carrying the item holds no central declaration of `COVERAGE.json`.

**Computed and shown for each item:**
- the grammar terms its statement names;
- what it keeps in other terms, as U2Deps computes them: the statement's own constants, not expanded, that are not grammar terms, not in the theorem's own module, not in U2Deps' `modelRelations` (the two lists, `Web.partialIdentity`, `sameValue`, `Web.admitted` and «际») and not in `Init`. The model's structure types, such as `Web`, `Flow` and `Run`, are shown as they are computed;
- the row's own dependence, as the measure gives it.

**What MV never does with an item.**
- It never refuses to run on one. An item that fails is written as unverified, with the tests it fails. So is an item the check would refuse, except one whose review does not name it: only the check reads the review. Its page shows nothing for it, and the check's `master_laws` status lists it. U2's landing requires none unverified.
- It never shows a line for items the data has not read. The lines appear only while the current items of the record carrying them equal the data's; otherwise the carrying law counts in `laws_not_matched`. That holds for the line under a law of another record too, so the registry reads every record's items for it.

## 3. How MV counts it

- **Dependency facts stay true.** For a law carrying items, `grammar`, `dependence` and `master_laws` are computed and written exactly as for any law: they are facts of Lean dependency.
- **Counted apart.** Such a law enters `counts_at_model`, never `counts`. U2's 20 laws therefore change no existing figure. Rows 6, 13 and 24 reach closure's «所闭» only through their statements at the model, and their rows rest on no master law, so closure's count is not raised. That is the move between categories change 1 rules out.
- **The row's dependence stays the measure's.** A statement at a model never makes its row reach the grammar.

## 4. F5's report

**Per row.** For each central declaration with verified items, `central_reach.rows` in MV's data lists them, each with its record, law and models. Under every law whose declarations include a verified item's row, the law's entry names the item (`stated_at_model`). A law carrying items keeps its items as verified (`statements_at_model`) and is counted in `counts_at_model`.

**Headline.** Over the distinct central declarations, the data gives four counts:
- those reaching the grammar (the measure's);
- those not reaching it, with a verified item at `occurrence` or `process`: stated at a represented model;
- those not reaching it whose only verified items are `own`: stated in the grammar's terms on their own carrier. These are not at a represented model, and change 1 does not count them as representations.
- the rest.

Rows 7, 9, 12 and 23 are wholly on their own carriers, so they fall in the third count.

**Not in this field.**
- **Derivation and connection.** Telling derivation from connection within "reaches the grammar" is F5's further part. It reads the Lean and needs nothing declared.
- **F5's third value, a named premise on the grammar.** Its input is a premise's grammar form, which U2 §3's table gives (`Web.Supported` with `supported_iff`, `Web.Dependent` with `dependent_iff`, a determined process with `determined_iff_fixed`, and so on). Its place is beside the premises the measure already holds in `COVERAGE.json`. That file has no active owner (WHAT-REMAINS; EC6c and EC6d), so OU's owner decides under rule 3's fallback. MV proposes it there next. U2 adds nothing for it at landing. The nine premise rows keep U1's verdict.
- **U3's forms.** The field holds a row's own statement at a model.
  - An instance or a specialization of a row states less than the row, so it is not an item.
  - Until U3 lands, its five rows are reported by the measure's dependence alone, in the fourth count.
  - An instance or a specialization at the structural reading is not the row stated at a represented model, so change 1 does not count it. This is contrary to U3 §3's wording ("an instance at a reading, is a representation"). Its reach is the instance's own, never its free row's.
  - If U3 holds to its reading, it brings it to OU's owner, and the field would gain a declared relation (statement, instance, specialization).
- **`COVERAGE.json`'s `instances`.** They map a central row to declarations stating it on a base family, and K2 checks them. Holding on a base family is not a statement in the grammar's terms, so F5 does not count them as representations.

## 5. The pages

The item has its own line, apart from the Lean-dependency line, and it marks what is declared:

- Under the law at the model: *At a model (declared; reviewed in [its review]):* `Becoming.ModelStatements.roles_supported_reading` states `Becoming.Web.roles_supported` at a World's occurrence model. Computed: its proof reaches the row; its statement names, directly or through its module's definitions, `Becoming.«则»` and `Becoming.«而»`; it keeps `Becoming.Web` and `Becoming.Web.Supported` in other terms. The row taken alone: on no master law's anchor.
- Under every law, in any record, whose declarations include `of`: *At a model (declared; reviewed in [its review]):* `of` is stated at a World's occurrence model by `declaration` ([record], law N).
- An item only on its row's own carrier is labelled *On its own carrier (declared; …)*, not as at a model.
- Names are given in full, as in the law's declarations and the master-law line.

Four rows are declarations of laws in more than one record (`Web.transmits_at_iff`, `Valuation.significant_iff_held`, `Run.not_fixes_of_untaken` and `Learning.Training.unselected_beyond_data`), so each of those laws gets the second line.

## 6. Order of work

1. **MV lands the field first.** That covers the check's rules, the generator's verification and counts, the page lines, RESULT-WORKFLOW's laws row and MV paragraph, and tests through the real render. Records hold correspondences, which this field is, and "Nothing about master laws is written into a record" still holds. MV claims this on the board once UE20 has landed, and it lands before U2's Lean.
2. **U2's landing fills the field in the new shape and reruns the generator.** The landing also follows RESULT-WORKFLOW for an added law: a history note, the home-section bullet with its base label, and a reference with its proof binding. Each item's `review` names a review that checked it as it stands. REVIEW-U2 read the scratch of 48 theorems, before rows 11, 14, 15, 16 and 20–24 took their present statements and before `renewing_not_closed` was added. So the leaf as it lands (78 theorems) needs a re-check of all 21 items against their rows, and the items name it, or REVIEW-U2 where its reading still holds.
3. **U2's Lean names may keep "reading".** In Lean the word is used in its formal sense, as in the one-kind reading `W.roles`. Only the record field avoids it, because the pages render standings, and in 08 §2 a reading is a standing.

## 7. Findings taken

| Review finding | Taken in |
|---|---|
| F5 1, schema 1: row 24's second pair fails the first check | §1 (U2's `renewing_not_closed`) |
| F5 2, schema 2: laws at the model raise grammar and master-law counts | §3 |
| F5 3, schema 6: the model is not computable from names; own carriers are not represented models | §1 `models`, §2, §4 |
| F5 4, schema 7: the premise value | §4 |
| F5 5: per-row report, rows in several records | §4, §5 |
| F5 6: what the statement keeps in other terms | §2 |
| F5 7: a pair naming the wrong row | §2 |
| schema 3: the row's law ambiguous, pairs on a central row's law, unchecked names, superseded records | §1 rules, §2 |
| schema 4: unknown keys ignored; stale data | §1 rules, §2 |
| schema 5: `by` reads backwards; `model_statements` reads as "law of its model" | §1 names |
| schema 8: U3 | §4 |
| schema 9: `COVERAGE.json`'s `instances` | §4; the field stays on the law because the claim is the law's, next to its text and its review |
| schema 10: RESULT-WORKFLOW | §6 |
| schema 11: declared versus computed on the page; the review | §1 rules, §2, §5 |
| schema 12: the word "reading" | §6 |
| schema 13: the grammar test | §2 |
| Re-check, F5 7: the same-`of` exemption let the wrong-row example through | §2, the same law and the same `of` |
| Re-check, schema 11: the review not tied to the items | §1, a `review` key per item |
| Re-check, schema 8: how F5 reports U3's forms | §4 |
| Re-check, schema 13 and new must-fix: the expansion depth, and the claim about U2Deps | §2, transitive |
| Re-check, F5 6: «际» and structure types in other terms | §2, §5's example |
| Re-check, schema 4: lines across records | §2 |
| Re-check, schema 7: `COVERAGE.json` has no active owner | §4 |
| Re-check, new: the closed key set required `zh` | §1 |
| Re-check, new: REVIEW-U2 predates ten items | §6 |
| Code review: a malformed item crashed or miscounted the generator | §2, written unverified |
| Code review: the walk's block stated loosely; `stated()` expanded a «» definition at the top | RESULT-WORKFLOW; the code |
| Code review: RESULT-WORKFLOW's counts and not-matched sentences; the block untested | RESULT-WORKFLOW; `blocked()` and its test |
| Re-check of the fixes: the generator verified items the check refuses; "changes none of the counts"; the guard's wording and its match; `process` in RESULT-WORKFLOW; grammar terms not in code | §1, §2, §5; RESULT-WORKFLOW; the code |
| Code review on U2's records: the row's line unmarked; own carriers labelled at a model; the row's dependence not shown; a review that never read the item; "a process's moves' relations" for row 6; "its statement names"; short names | §1, §5 |
