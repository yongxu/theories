# U4, the boundary record (design, draft)

AI-written design for the last step of U4, "one root to its edge" ([proposal](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#one-root-to-its-edge-a-proposal-30-october-2026), [OU's decisions](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#ous-decisions-on-u4-and-on-gw1gw2-30-october-2026)). The step is one record stating where every central declaration stands: derived, on the root under a stated hypothesis with a countermodel, a premise proved not entailed, or at a named distance whose failure is written down.

- **Status.** This is a draft, revised after one independent review ([REVIEW-U4-BOUNDARY.md](REVIEW-U4-BOUNDARY.md)). The review found it sound with fixes, four of them blocking, and every finding is taken (§7). The connected rows have been read independently (§3). No package Lean is claimed and no record is written.
- **Order.** The record lands last, after GW1, GW2 and GW6, in OU's order. MV's field for the standings lands before it, as F5's field landed before U2's Lean. That field's spec waits for the tests of §1.5 (§5).
- **The table.** [boundary_table.py](boundary_table.py) produces [boundary-table.json](boundary-table.json). It ran on main `4ac8cf27e`, after U3's Lean landed. The script runs the master-law measure from the checker cache and compiles nothing.

## 0. Where it stands

On the strict reading this design recommends (§1.2), **8 central declarations are on the edge, all derived.** Each is a case of a grammar law, and its proof already applies that law through named bridges (§3). None is yet under a stated hypothesis, and none is a premise. 6 stand below the grammar, as laws of counting. The other 104 sit at named distances, each with its reason. No row is unplaced.

| Standing | Count | In F5's counts | What it is |
|---|---:|---|---|
| derived | 8 | reaching the grammar | a case of a declared grammar law, through named bridges (§1.1, §3) |
| under a stated hypothesis | 0 | | a root form whose hypotheses are relational, each with its countermodel (§1.2) |
| premise | 0 | | none of the central declarations is a premise (§1.3) |
| counting | 6 | the rest | laws over lists and maps to `Nat`, for any carrier: lever 2's rows 6, 12 and 18, `RelativePosition.rise_needs_fall`, and the two census rows (§1.4) |
| connected | 24 | reaching the grammar | reaches grammar laws among its reasons, with no balance in its statement; uses them as steps among its model's facts, or is a case of a law not yet on the grammar (§3) |
| witnessed at its model | 2 | the rest | lever 2's rows 5 and 17: forms with relational hypotheses, each witnessed, that keep the model's terms (§1.2, §4) |
| balance, represented | 31 | 12 reaching the grammar, 19 the rest | takes `Flow`'s balance in its statement; lever 1's verdict |
| amounts | 18 | the rest | its statement compares amounts, or a hypothesis constrains them; the grammar has no terms for either |
| at a represented model | 16 | stated at a represented model | F5's items at a World's occurrence model or a process's model; 9 of them definitional |
| own carrier | 7 | stated on its own carrier only | F5's items on the row's own carrier; 3 of them definitional |
| at its model | 3 | the rest | a law of its model with no statement on the root |
| free significance | 3 | the rest | U3's rows 1, 8 and 9: the general statement keeps `sig` free, as 07 §1 intends |

**Against F5's four counts.** F5's counts are 44, 16, 7 and 51 (master-laws.json, `central_reach`); the table reads them back and matches them.
- The 44 reaching the grammar are 8 derived, 24 connected and 12 balance, represented.
- The 16 at a represented model and the 7 on their own carrier are F5's exactly.
- The other 51 are 6 counting, 2 witnessed at their model, 19 balance, represented, 18 amounts, 3 at their model and 3 free significance.

The 12 rows EC6 calls definitional or representational keep the standing F5's items give them, flagged "definitional" in the table (§1.4).

Three findings shape the record.

1. **A name test on rows measures packaging, so the record applies it to declared items.** The record's test asks whether a statement names only grammar terms, `Becoming.Prelude` and `Init` (§1.5). On the 118 rows the outcome depends only on how far their definitions are unfolded:
   - At the name level, none passes: every row names its model's terms.
   - With the statement's definitions unfolded, 11 pass. These are the four counting rows of lever 2 and `RelativePosition`, `Listed.coming_of_ceasing`, `Weighting.widens_iff_every_positive`, `Learning.Training.unselected_beyond_data`, `Learnable.learnable_iff`, `onLoop_of_closing`, `forced_iff_center` and `presupposition_scopes`.
   - With structures unbundled as well, 105 pass, since every model is made of relations, numbers and lists.

   A standing is therefore carried by a declared item, as F5's statements at a model are: a grammar law the row is a case of, or a root form the row is an instance of. The name test applies to those items.
2. **Reaching the grammar is connection, not derivation.** All 44 declarations that reach the grammar reach grammar laws:
   - 43 reach a «» law;
   - `Web.Whole.family_excess_ends` reaches only `kept_onward`, the closure at the successor. GrammarLaws' header names it among its laws without a «» name, and the table counts it as a law.

   Many reach only closure's elementary laws, used as steps: `«所闭之传递»`, `«所闭之自反»`, `«缘在所闭»`, `«所闭之闭»` and `«所闭之单调»`. So "44 reach the grammar" says that a grammar law is among their reasons. It does not say the row is a grammar law at its model. Of the 32 with no balance in their statements, 8 are cases (§3).
3. **Balance enters by the statement or by the proof, and the edge needs that split.** `Flow`'s balance enters 31 rows' statements. Three rows take it only in their proofs:
   - `act_courses_unselected` uses the balance `course_balances_iff` proves from `Feasible`: connected;
   - `Flow.no_new_dependence` uses it as one way to meet "coming to stand is given to": witnessed at its model;
   - `Flow.new_beyond_every` concludes on imbalance: amounts.

   Thirteen rows reach only the prelude's `balance_over_stretch_on`. That is a law of counting, holding for every `q x y : Nat → Nat` (Prelude.lean:785). Three of the thirteen reach the grammar and are connected. The other ten are placed by their statements: the two census rows at counting, and the RegimeMargin and frontier rows at amounts.

   Lever 1's recount by anchor reached (18, 10, 3) is right as far as it goes. This split, by statement against proof, is the one the edge needs. It is the record's own, so 08 §7's balance column (55), which counts master-law anchors, is unchanged.

## 1. The standings

### 1.1 Derived

A row is **derived** when it is a case of a declared grammar law Y. Three things must hold:
- **Y is declared on the grammar.** It is a theorem of a `Becoming.Grammar*` module, or of a list of grammar laws that OU's owner keeps, and its statement passes the name test (§1.5).
- **The row is Y at the model's relation, through bridges each named in the record.** A bridge is an equivalence, proved by unfolding the model's definitions or by recursion, that holds for every instance of the model's parameters and adds no hypothesis. The row carries no hypothesis beyond Y's own, instantiated.
- **The row's proof reaches Y and every named bridge.**

Reaching a grammar law used as one step among the model's own reasoning does not make a row derived. The record declares Y and the bridges. MV checks that the declared laws pass the name test and that the row reaches them. The constants dump holds names, not terms, so the review confirms that each bridge is an equivalence adding no hypothesis.

### 1.2 Under a stated hypothesis

The proposal states standing 2 as "the hypothesis is written in the grammar's terms, and a countermodel on the root shows it cannot be dropped". Two readings fit those words.

**The strict reading, which this design adopts.** A row stands under a stated hypothesis when it is an instance of a root form F, declared in U4's core leaf, such that:
- **F's statement passes the name test.** The model's relations and amount functions are variables in it.
- **Each hypothesis is a named definition in F's type, and names grammar terms only:** relations, regions, classes and «» notions. List facts may appear as counting, which quantifies over every map. A hypothesis that constrains an amount function keeps the row at a distance: balance, cancellation, `need ≤ level`, or a comparison of trait sums.
- **The conclusion may use the prelude.**
- **Each hypothesis has a countermodel.** It is a theorem stated as the negation of F with that one hypothesis dropped. It names the hypothesis and is not proved through F.
- **F does not reach the row.** The row is F at its model, through a bridge in the leaf. A certificate ties the bridge to the row's own type (§1.5).

This reuses the measure's existing convention: theorems that "name nothing beyond the grammar and the prelude … are on the root already" ([WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), from WRP's measure).

**What separates standing 2 from derived.** Y is a grammar law, and a derived row adds nothing to it. F is not a grammar law. Its hypotheses beyond what the grammar's laws give stay in the row, each shown needed by its countermodel.

**The loose reading, not adopted.** On it, the root form may keep the model's own structures, a `Flow`, a `Web` or `Generations`, and state its hypotheses as grammar inclusions over relations the model defines. The design does not take it, because the name test is the one check MV can run on the Lean, and under the loose reading every model whose relations can be named would be "on the root".

**Lever 2's four rows on this line.**
- **Rows 5 and 17 are "witnessed at their model".** Their hypotheses are relational, and each is witnessed. Row 5's are "coming to stand is given to", inheritance at the descents, and nothing taking part depending on the condition. Row 17's are the gate and descent as two inclusions at one step, and a generation wholly inactive. Their forms keep the model's terms, so they reach standing 2 once restated with the relations as variables (§4).
- **Rows 13 and 14 are at amounts.** Row 13's cancellation, `G.raisedAt t = G.loweredAt t`, constrains amounts. So do row 14's cancellation and its `inactive`, which compares `total h (G.amount t) < total g (G.amount t)`. They therefore sit with rows 1–3, 7 and 8, which have the same shape. Their forms and witnesses stay in lever 2's scratch as evidence.

**F5's items** are statements at a represented model, which U2 named "a representation, not a derivation". They join standing 2 only where a strict root form has them as its instance. No item has such a form yet.

**F5's plan.** F5's spec §4 plans two things that bear on this record ([F5-MODEL-STATEMENTS.md](../../../../2026-10-05-repository-reconciliation/architecture/mv/F5-MODEL-STATEMENTS.md), "Not in this field").
- **Telling derivation from connection.** The spec says this "reads the Lean and needs nothing declared". Reach is indeed read from the Lean, but reach does not tell a case from steps; the independent reading had to read the proofs (§3). So the record declares Y and the bridges, and MV checks reach against them.
- **A named premise on the grammar (F5's third value).** Its input is the grammar form of a premise in COVERAGE.json's register (K3), such as `Web.Dependent` with `dependent_iff`. K3's witnesses (`World.contingent`, `World.independent`) meet and fail each premise in some world. A strict form's hypotheses are such premises in grammar terms, and its countermodels show more: dropping the hypothesis from that form makes the conclusion fail. So the record names each strict hypothesis's premise in K3's register where there is one; row 17's gate, for example, is "only active relata give". MV's third value and standing 2 then share the grammar forms.

### 1.3 Premise

A premise is stated on the root, with a proof that no statement about the dynamics entails it. The continuation condition and C stand here (`ReadsOnlyDynamics.not_entails`), but neither is a central declaration. K3's premises (balance, dissipation, a census and the rest) are hypotheses of the account, with witnesses that meet and fail them. They are not central declarations, and they have no proof of not-entailment.

Three central declarations keep `sig` free in their general statements: row 1, `unrestricted_iff_livingSignificance`, which is the condition read as living significance, and rows 8 and 9. U3 gave each a root form at the structural reading of `sig` only, and F5 keeps all three among the rest (U3's standing, WHAT-REMAINS). Their label is "free significance". It is a distance kept on purpose by 07 §1, not a gap. `not_entails` does not have the shape of a standing-2 countermodel, so a row whose only kept hypotheses are the two premises is not counted under standing 2.

### 1.4 Below the grammar

**Laws of counting** need no premise. They are laws over lists and maps to `Nat`, holding for any carrier, predicate or listing, and are counted apart, as lever 2 decided (REVIEW-U4-L2, S2), not as distances and not as derived. There are six:
- lever 2's rows 6, 12 and 18;
- `RelativePosition.rise_needs_fall`;
- `Listed.coming_of_ceasing`, which holds for any carrier, predicate and exact listing, and whose statement unfolds to the prelude's `Distinct` and `Init`;
- `CensusWebs.keep_pace`, which is the counting law `CountsAcross.keep_pace` at a web's arising and ceasing.

**No row is counted as a law of logic.** The 12 rows EC6 calls "definitional or representational" keep the standing F5's items give them: 9 at a represented model and 3 on their own carrier, each flagged "definitional" with its reading. Several are not definitions unpacked:
- `ExchangeLaw.response_not_fixed_by_coupling` constructs two exchange laws;
- `Web.significance_undetermined` is a not-entailment by two constant significances;
- the three `Web.roles_*` rows are representation lemmas of the one-kind construction `roles`.

Narrowing "logic" to `Iff.rfl` and tautologies would need OU's owner's decision, and would make the record's counts disagree with F5's. The design does not propose it.

### 1.5 The tests MV runs

F5's `verify` requires at least one grammar term in a statement (master_laws.py, `verify`). It shows the other terms only from the direct type constants, and it never tests "nothing else". The record needs a new test in MV's field, specified as follows.

- **The name test, on declared items only.** It applies to Y, F, each hypothesis's definition and each countermodel, never to rows (finding 1). Every constant the statement names directly, with no unfolding, must be one of:
  - a grammar constant: a «» name other than «际», or a constant of a `Becoming.Grammar*` module;
  - a constant of `Becoming.Prelude` (Prelude.lean:1–7);
  - a constant outside `Becoming`, that is, of `Init`.
- **Reach.** For a derived row, the row's proof reaches Y and each named bridge. For standing 2, the certificate's bridge reaches F, F does not reach the row, and no countermodel reaches F.
- **Shapes, checked by Lean.**
  - A bridge's certificate is `theorem … : @Row = @B := rfl`. It holds exactly when the two statements agree up to definitions, since proofs of one proposition are equal by definition. Alternatively, B is stated as `type_of% @Row`.
  - Each countermodel is stated as `¬` of F with one hypothesis dropped.

  MV checks that each certificate and countermodel exists and names what it should. The dump cannot show that a countermodel's statement is F with one hypothesis dropped, so the review confirms it, as F5's review does (F5 spec §2).
- **Axioms.** Every declared item is in the core leaf, so its axiom report is empty.

## 2. The table

[boundary_table.py](boundary_table.py) joins four sources for each distinct central declaration:
- **The measure's row:** dependence, category, master laws and EC6's reason.
- **Where `Flow`'s balance enters:** the statement (the type and the definitions it unfolds), or only the proof. This source also records whether the prelude's counting law is the only balance anchor.
- **Grammar reach:** the grammar laws and definitions its type and proof reach, with grammar constants not expanded.
- **F5's items:** with F5's class for the row.

Every rule reads the statement or a fact recorded apart, namely the measure's reach or F5's verified items. The rules, in order:
1. A row with `Flow`'s balance in its statement is **balance, represented**.
2. A row that reaches the grammar is **connected**. The reading marks the cases as derived.
3. A row with an F5 item at an occurrence or process model is **at a represented model**. One whose only items are on its own carrier is **own carrier**. EC6's definitional rows are flagged.
4. Every other row is **unplaced**. A reading of its statement places it, and the record keeps no unplaced row.

**Proof-only facts.** Where only the proof reaches balance or the prelude's counting law, the table records that in the row's `balance` field and does not place the row by it.

**The readings.** `HAND` gives the readings, each with the result that places it, and the table shows what the rule would give beside each one (`rule_would_give`). Forty-two rows carry a reading. For 40 of them it differs from the rule: 32 are rows that rule 4 leaves unplaced and their statements place, and 8 move from connected to derived.

## 3. The connected rows

An independent reader checked against its Lean each of the 31 rows that then reached the grammar with no balance ([CONNECTED-ROWS-READING.md](CONNECTED-ROWS-READING.md)). The reader read proofs only and built nothing. Each row got one verdict:
- **case:** the row is one grammar law at its model;
- **steps:** the row uses grammar laws among its model's facts.

The review rechecked the eight cases (REVIEW-U4-BOUNDARY, B3).

**Eight are cases, and need no new Lean.** Each proof already is the law at the model's relation. It goes through bridge equivalences that hold for every instance of the model's parameters and add no hypothesis. The record declares the law and names the bridges, and the rows are derived.

| Row | The law it is a case of | At | Bridges |
|---|---|---|---|
| `Flow.beyond_gives_nothing` | `«所闭之界»` | R = `L.FedFrom W` | `FedFrom` and `FedBy` unfolded; one prelude step, ¬ 0 < n → n = 0 |
| `Flow.withinSystem_of_withinInfluence` | `«所闭之单调»` | R = `AffectedBy`, S = `Shares` | `shares_of_affectedBy`, an unfolding |
| `Law.drawn_iff_not_returns` | `«定后有后则入当且仅当不返»` | R = `next x = y` | `drawn_iff_drawnIn` and `absorbing_iff_closed`; `reaches_iff_orbit` and `returns_iff_reaches`, by recursion |
| `Law.lossless_iff_returns` | `«有限遍后定后则定前当且仅当皆返»` | R = `next x = y` | `lossless_iff_fixedBefore`, an unfolding; `returns_iff_reaches`, by recursion |
| `Learning.goAlike_iff_lumped` | `«像定后当且仅当同行»` | the law's step, along π | `goAlikeUnder_iff_alike` and `lumped_iff_fixed_image`, unfoldings |
| `Tolerance.answers_restores_iff` | `«承之迭»` | R = `up` | `answers` is `«承» up` by definition; `chain_iff_steps`, by recursion through `«迭之末步»`; the start instantiated at `allWithheld` |
| `Withholding.withholding_spreads` | `«存承之迭»` | R = `up` | `waitsAll` by definition; `within_iff_withinSteps` through `chain_iff_steps`, by recursion |
| `WithinMoves.after_course` | `«迭内之接»` | R = `Steps P` | `trace_steps` and `trace_iff_steps`, by recursion; `withinMoves_iff_withinSteps` |

Five of the eight use bridges proved by recursion. The first draft said only the two `Law` rows did. The test of §1.1 admits all five, since each bridge is an equivalence at every instance of the model's parameters and adds no hypothesis.

**Two rows are cases of laws not yet on the grammar.**
- **`Flow.mutuallyDependent_iff_reach`** is exactly `WithinClosure.converse`, `«所闭» («逆» R) f g ↔ «所闭» R g f` (Response.lean:91).
  - Its content is grammar-only, but it is declared off the grammar. The grammar's `«所闭之对称»` needs R symmetric. No `«所闭之逆»` or `«及之逆»` exists; only `«迭之逆»` does.
  - Declaring the law in GrammarLaws does not by itself make the row reach it. `WithinClosure.converse`, which has its own proof and 10 uses, must be re-proved as one application of `«所闭之逆»` in the same rebuild. That is an edit to Response, by its owner.
- **`Flow.withinCoupling_reads_iff`** is two general closure laws over any relation that are declared off the grammar: `WithinClosure.of_reads` and `WithinClosureOf.to_reads` (SelectionPool.lean:559, :570). Its hypotheses are met by case splits on the model. It needs no new form: the two halves move to GrammarLaws and are re-proved there, like the converse.

Both go on HE2's list through OU's owner, for the next near-full rebuild. The record does not wait for that rebuild: both rows land as connected and are updated at it.

**Twenty-two use grammar laws as steps.**
- **One has a form the grammar lacks: `Branching.loss_passes_juncture`.** No grammar module states a law of junctures (Junctures.lean:132–148). A juncture law with the row as its case would be new Lean, weighed in the leaf's design.
- **`Amounts.rests`** rests on `«尽则不或屡»`, which is already its grammar form. The row adds amounts: it proves the law's ending hypothesis from "m copies of ε are not within s T".
- **Six carry a closed region along a run.** That is `«闭含所闭»` applied through `«所闭»`'s definition, so the walk does not show it. Their closedness itself needs their model's facts, so only the carrying part has a grammar form. The six are `Pace.rule_until_reading`, the two `RuleCapture` rows, `Valuation.significant_iff`, `ClosedCapture.lock_outlives_loss` and `RegimeMargin.Coupled.Indexed.ends_downstream`.
- **Fourteen have no form the grammar lacks.**
  - **Eleven** are amounts, counting, prediction from prefixes, or the valuation's own logic.
  - **`presupposition_scopes` and `onLoop_of_closing`.** The first draft proposed forms for both, and they are dropped. `presupposition_scopes`'s form is the closure's definition read through `«闭含所闭»`, `«所闭之闭»` and `«所闭之自反»`, so the grammar has it already. `onLoop_of_closing`'s form is a corollary of three laws (`«及当且仅当一步而所闭»`, `«所闭当且仅当同一或及»` and `«及之传递»`); it would be new only as a single statement.
  - **`act_courses_unselected`** joined the connected rows when the balance rule became statement-only, and the reader did not read it. Its statement names no balance. Its proof uses the balance that `course_balances_iff` proves, and it reaches `«所闭之传递»` and `«缘在所闭»` as steps.

The rows in each group are in the reading's table, and each row's `reading` field gives its group.

**The walk, corrected by the reading and the review.** These are not counted as grammar laws:
- Lean's generated auxiliaries, such as `«及».brecOn`;
- GrammarLaws' list and number helpers, which that file says are "not statements of the grammar".

A law is a theorem whose own name is a «» name, or `kept_onward`, which GrammarLaws' header names among its laws.

## 4. What would move, and the work

- **The eight cases** (§3) are derived once the record declares their laws and bridges. They need no Lean.
- **`Flow.mutuallyDependent_iff_reach` and `Flow.withinCoupling_reads_iff`** become cases at HE2's rebuild, once their laws are in GrammarLaws and the existing lemmas are re-proved through them.
- **Rows 5 and 17** move to standing 2 once each is restated on the strict reading.
  - Relations become variables: giving, descent, activity, requiring, inheritance and coming to stand. The generation's size becomes the prelude's total over a list.
  - Each hypothesis gets a countermodel stated as F with that hypothesis dropped. These are carried over from lever 2's witnesses: for row 5, `Ungiven`, `Uninherited`, `Held` and `Standing`; for row 17, `Ungated` (the gate), `Ungated.silent` (descent) and `Lifted.inactive_needed` (inactivity).
  - A certificate ties each bridge to the row's own type.
  - The scratch names `*_on_root` state a wrong meaning under the strict reading, so each is renamed at landing for what it states.
- **Rows 13 and 14** stay at amounts, with rows 1–3, 7 and 8. A relational restatement of cancellation is not proposed, since cancellation is an equation of sums.
- **`Branching.loss_passes_juncture`** moves to derived if the grammar gains a law of junctures. The leaf's design weighs whether it should: the law must be one the grammar lacks, not a restatement of the row.
- **F5's items, the definitional rows and the counting rows** need nothing for the record. A strict root form for an F5 item is further work, not this record's.
- **The rows that stay:** balance, represented; amounts; free significance; and the other steps rows. They stay where lever 1, lever 2, U3 and the reading left them, with their witnesses and reasons:
  - for balance, `pairs_without_one_to_one` and `repeated_unit`;
  - for amounts, lever 2 §6;
  - for free significance, 07 §1;
  - for the steps rows, the model's facts, named row by row in the reading.

  The two census rows are laws of counting, so lever 1's candidate through `«计»` adds nothing to their standing.

**The core leaf.** Every new theorem the record cites goes into one core leaf, as U2's `ModelStatements` and U3's `SignificanceStatements` did.
- **Contents:** rows 5 and 17's strict forms, with their countermodels and certificates, and the juncture law if the leaf's design keeps it. The eight cases need no Lean there.
- **Place:** it imports the rows' modules and `GrammarLaws`, and nothing below it uses it.
- **Landing:** a claim on the board, a slot in the queue, and one incremental core run.

## 5. Order and owners

1. **MV's field and verification.** MV's owner drafts the spec on the tests of §1.5. Per declaration it carries a standing or a distance label, and:
   - for derived, the declared law and the bridges;
   - for standing 2, F, each hypothesis with its countermodel, and the certificate;
   - for standing 3, the not-entailed theorem.

   MV verifies these from the checker cache. The spec is reviewed and lands first.
2. **HE2's list**, through OU's owner, for the next near-full rebuild: `«所闭之逆»`, with `WithinClosure.converse` re-proved through it, and the two halves of `Flow.withinCoupling_reads_iff`.
3. **The core leaf**, claimed on U4's row, with an independent review, landing through the queue.
4. **The record**, after GW's landing. It does not wait on HE2's rebuild. Its home section is 08 §7, beside the master laws, since it reads every central declaration through them. MV counts the standings, and the record prints them beside F5's four counts.

## 6. Not done

- No strict root form is written yet.
- The juncture law is not weighed yet.
- MV's field is not drafted.
- The reviewer has not reread this revision.
- GW1, GW2 and GW6 have not landed. Whether they add central declarations is checked when they do.

## 7. The review, and what was taken

| Finding | Taken |
|---|---|
| B1 (blocking): the strict reading admitted the prelude in hypotheses, so balance and rows 13 and 14 fell on both sides of the line | §1.2 states hypotheses apart: grammar terms only, list facts as counting, no hypothesis constraining an amount. Rows 5 and 17 are the candidates. Rows 13 and 14 go to amounts with rows 1–3, 7 and 8. The measure's convention for "on the root" is cited |
| B2 (blocking): the tests did not separate derived from standing 2, and claimed more of F5's test than it does | §1.5 specifies a new name test: prelude = `Becoming.Prelude` plus `Init`, no unfolding, on declared items, not rows (finding 1: 0, 11 and 105). §1.1 and §1.2 separate a declared grammar law from a root form whose extra hypotheses stay in the row. Lean checks the shapes (certificate, countermodel). F5's spec §4 is reconciled in §1.2 |
| B3 (blocking): five of the eight cases use bridges proved by recursion | The test is restated as bridge equivalences at every instance of the model's parameters, adding no hypothesis, each named. All eight stay derived. §3's table names the bridges, and the reading carries a correction note |
| B4 (blocking): the "logic" label put rows below the grammar that their Lean does not support | The label is dropped. All 12 rows keep F5's standing, flagged "definitional". The record's figures are printed against F5's four counts (§0) |
| M1: `Listed.coming_of_ceasing` is counting; rule 4 placed by the proof | Both census rows are counting. The rules read only the statement, and proof-only facts are recorded, not used to place. The balance column (55) is unchanged (§0, finding 3) |
| M2: `Flow.withinCoupling_reads_iff`'s halves exist | It goes on HE2's list beside `«所闭之逆»`, with no new form (§3) |
| M3: two of the four forms are not laws the grammar lacks | `presupposition_scopes` and `onLoop_of_closing` are dropped, and the juncture law alone is weighed (§3) |
| M4: declaring `«所闭之逆»` changes the row only if `converse` is re-proved through it | On HE2's entry, by Response's owner (§3, §5) |
| M5: one of the 44 reaches only `kept_onward` | The table counts `kept_onward` as a law; 43 reach a «» law (§0, finding 2) |
| M6: rule 2 placed `act_courses_unselected` by its proof | The rules are statement-only, so it is connected (§3) |
| M7: lever 2's notes, §4's witness list, names, label | The notes are corrected (list facts unwitnessed; row 5's implication; row 13's cancellation). The witnesses are listed per row (§4). The scratch names are renamed at landing. Rows 5 and 17 get their own label |
| M8: `not_entails` is not a countermodel's shape | The option is dropped (§1.3) |
| M9: wording | Three rows take balance only in their proofs, and the leaf holds no bridges for the eight (§0, §4) |
| M10: order | MV's spec waits for §1.5. The record does not wait on HE2's rebuild (§5) |
