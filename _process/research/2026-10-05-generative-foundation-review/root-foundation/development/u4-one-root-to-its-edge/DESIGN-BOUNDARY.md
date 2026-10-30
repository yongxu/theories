# U4, the boundary record (design, draft)

AI-written design for the last step of U4, "one root to its edge" ([proposal](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#one-root-to-its-edge-a-proposal-30-october-2026), [OU's decisions](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#ous-decisions-on-u4-and-on-gw1gw2-30-october-2026)). The step is one record stating where every central declaration stands: derived, on the root under a stated hypothesis with a countermodel, a premise proved not entailed, or at a named distance whose failure is written down.

- **Status.** This is a draft, revised after two independent reviews ([first](REVIEW-U4-BOUNDARY.md), [second](REVIEW-U4-BOUNDARY-SECOND.md)) and MV's owner's reading of the field it needs. Both reviews found it sound with fixes, four blocking findings in the first and three in the second. Every finding is taken (§7).
  - The connected rows have been read independently (§3).
  - OU's owner has answered where a derived row's law sits, and has put two laws on HE2's list (§1.1, §3).
  - Row 17's strict form passes a Lean check of every test in §1.5, and nine negative controls fail as they should (§4). Row 5's strict form records the relational part of a row that stays at "balance in its statement" (§1.2).
  - No package Lean is claimed, and no record is written.
- **Order.** The record lands last, after GW1, GW2 and GW6 (landed, main `e077583c6`), in OU's order. MV's field for the standings lands before it, as F5's field landed before U2's Lean (§5).
- **The table.** [boundary_table.py](boundary_table.py) produces [boundary-table.json](boundary-table.json). It ran on the constants of main `4ac8cf27e`, after U3's Lean landed. The script runs the master-law measure from the checker cache and compiles nothing.

## 0. Where it stands

On the strict reading this design adopts (§1.2), **8 central declarations are on the edge, all derived.** Each is a case of a grammar law, and its proof already applies that law through named bridges (§3). None is yet under a stated hypothesis, and none is a premise. 6 stand below the grammar, as laws of counting. The other 104 sit at named distances, each with its reason. No row is unplaced.

| Standing | Count | In F5's counts | What it is |
|---|---:|---|---|
| derived | 8 | reaching the grammar | a case of a declared grammar law, through named bridges (§1.1, §3) |
| under a stated hypothesis | 0 | | an instance of a root form whose hypotheses are relational, each with its countermodel, met by definitions alone (§1.2) |
| premise | 0 | | none of the central declarations is a premise (§1.3) |
| counting | 6 | the rest | laws over lists and maps to `Nat`, for any carrier: lever 2's rows 6, 12 and 18, `RelativePosition.rise_needs_fall`, and the two census rows (§1.4) |
| connected | 24 | reaching the grammar | reaches grammar laws among its reasons, with no balance in its statement; uses them as steps among its model's facts, or is a case of a law not yet on the grammar (§3) |
| witnessed at its model | 1 | the rest | lever 2's row 17: a form with relational hypotheses, each witnessed, that keeps the model's terms; its strict form waits for the leaf (§1.2, §4) |
| balance in its statement | 32 | 12 reaching the grammar, 20 the rest | takes `Flow`'s balance in its statement, or writes it out as an equation; lever 1's verdict |
| amounts | 18 | the rest | its statement compares amounts, or a hypothesis constrains them; the grammar has no terms for either |
| at a represented model | 16 | stated at a represented model | F5's items at a World's occurrence model or a process's model; 9 of them definitional |
| own carrier | 7 | stated on its own carrier only | F5's items on the row's own carrier; 3 of them definitional |
| at its model | 3 | the rest | a law of its model with no statement on the root |
| free significance | 3 | the rest | U3's rows 1, 8 and 9: the general statement keeps `sig` free, as 07 §1 intends |

**Against F5's four counts.** F5's counts are 44, 16, 7 and 51 (master-laws.json, `central_reach`). The table reads them back and matches them.
- The 44 reaching the grammar are 8 derived, 24 connected and 12 at balance in their statements.
- The 16 at a represented model and the 7 on their own carrier are F5's exactly.
- The other 51 are 6 counting, 1 witnessed at its model, 20 at balance in their statements, 18 amounts, 3 at their model and 3 free significance.

The 12 rows EC6 calls definitional or representational keep the standing F5's items give them. The table flags them "definitional" (§1.4).

**The edge is not a ranking of nearness to the grammar.** A derived row is a case of a grammar law. A row under a stated hypothesis is an instance of a root form whose conclusion follows by logic alone from relational hypotheses, none of them redundant. Such a form need not use any grammar law, and the forms written so far use none (§1.2). A connected row does use grammar laws, but as steps among its model's facts. "On the edge" says where a row's statement stands, not that it is nearer the grammar than a connected row.

Three findings shape the record.

1. **A name test on rows measures packaging, so the record applies it to declared items.** The record's test asks whether a statement names only grammar terms, `Becoming.Prelude` and `Init` (§1.5). On the 118 rows, the outcome depends only on how far their definitions are unfolded:
   - At the name level, none passes: every row names its model's terms.
   - With the statement's definitions unfolded, 11 pass. These are the four counting rows of lever 2 and `RelativePosition`, `Listed.coming_of_ceasing`, `Weighting.widens_iff_every_positive`, `Learning.Training.unselected_beyond_data`, `Learnable.learnable_iff`, `onLoop_of_closing`, `forced_iff_center` and `presupposition_scopes`.
   - With structures unbundled as well, 105 pass, since every model is made of relations, numbers and lists.

   A standing is therefore carried by a declared item, as F5's statements at a model are: a grammar law the row is a case of, or a root form the row is an instance of. The name test applies to those items.
2. **Reaching the grammar is connection, not derivation.** All 44 declarations that reach the grammar reach a grammar law, by MV's walk (§2). `Web.Whole.family_excess_ends` reaches `«线则所闭»` and `«闭含所闭»` through the proof of `kept_onward`, GrammarLaws' closure along the successor on `Nat`, which has no «» name.

   Many rows reach only closure's elementary laws, used as steps: `«所闭之传递»`, `«所闭之自反»`, `«缘在所闭»`, `«所闭之闭»` and `«所闭之单调»`. **Reach says a grammar law is among a declaration's reasons; derived says the row is a case of one.** So the 44 and the derived count are two figures, not one. `Web.Whole.family_excess_ends`, for example, reaches the grammar, but its statement takes `Flow.Balances` and is not a case of a grammar law, so it stands at "balance in its statement". Of the 32 with no balance in their statements, 8 are cases (§3).
3. **Balance enters by the statement or by the proof, and the edge needs that split.** Balance enters 32 rows' statements.
   - In 31 it enters through `Flow`'s anchors (`Balances`, `BalancesOn`, `BalancesBetween`).
   - In one, `Flow.no_new_dependence`, it is written out as an equation of levels and flows at the row's one relatum and step. The anchor test does not see it, so rule 1 reads it as well: the statement's own type names `Dependence.level`, `Flow.taken` and `Flow.given`. A scan of every row finds that only this one writes balance out without an anchor. (`Flow.restores` also names all three, beside its anchor.)

   Two rows take balance only in their proofs:
   - `act_courses_unselected` uses the balance that `course_balances_iff` proves from `Feasible`, which bounds what a course takes by what stands and is given. It is connected.
   - `Flow.new_beyond_every` concludes on imbalance. It stands at amounts.

   Thirteen rows reach only the prelude's `balance_over_stretch_on`. That is a law of counting, holding for every `q x y : Nat → Nat` (Prelude.lean:785). Three of the thirteen reach the grammar and are connected. The other ten are placed by their statements: the two census rows at counting, and the RegimeMargin and frontier rows at amounts.

   Lever 1's recount by anchor reached (18, 10, 3) is right as far as it goes. The edge needs a different split, by statement against proof. That split is the record's own, so 08 §7's balance column (55), which counts master-law anchors, is unchanged.

## 1. The standings

### 1.1 Derived

A row is **derived** when it is a case of a declared grammar law Y. Three things must hold:
- **Y is declared on the grammar.** It is a theorem of a `Becoming.Grammar*` module whose statement passes the name test (§1.5). OU's owner has decided that the law sits in the package only: a list kept beside it would be metadata, and metadata settles no standing. The «» name is the vocabulary, not the standing.
- **The row is Y at the model's relation, through bridges each named in the record.**
  - The bridges are the closed set of lemmas between the row and Y, as MV's probe computes it: every lemma the row's proof uses on its way to Y.
  - Each bridge holds at every instance of the model's parameters and adds no hypothesis the row lacks.
  - The principal bridges are equivalences, proved by unfolding the model's definitions or by recursion. §3's table names them; the others are their steps.
- **The row's proof reaches Y and every named bridge.**

Reaching a grammar law used as one step among the model's own reasoning does not make a row derived. The record declares Y and the bridges. MV checks that each declared law passes the name test and that the row reaches it and its bridges. The constants dump holds names, not terms, so the review confirms that each principal bridge is an equivalence adding no hypothesis.

### 1.2 Under a stated hypothesis

The proposal states standing 2 as "the hypothesis is written in the grammar's terms, and a countermodel on the root shows it cannot be dropped". Two readings fit those words.

**The strict reading, which this design adopts.** A row stands under a stated hypothesis when it is an instance of a root form F, declared in U4's core leaf, such that:
- **F's statement passes the name test.** The model's relations and amount functions are variables in it, bound implicitly.
- **F's hypotheses are named definitions of F's module, each used once.** Every propositional binder of F's type is an application of one of them.
  - Each names grammar terms only: relations, regions, classes and «» notions, with `Becoming.Prelude` and `Init`.
  - None names an amount. List facts may appear through membership, as counting, which quantifies over every map.
  - A hypothesis that constrains an amount function keeps the row at a distance: balance, cancellation, `need ≤ level`, or a comparison of trait sums.
- **The conclusion may use the prelude.**
- **Each hypothesis H has a countermodel, in two theorems on the same facts.**
  - `F.needs_H` is `¬` of F's statement with H's binder removed. It is not proved through F.
  - `F.H_needed` is `¬ H w` at a witness `w` made of named definitions of F's module. It applies F to the facts, so the kernel checks that they meet F's other hypotheses and that F's conclusion fails there.
  - The facts are named theorems. None reaches F or the row, and `F.needs_H` names exactly the same facts.
- **F's proof** uses only the grammar, the prelude, `Init` and its own module's lemmas, and does not reach the row.
- **The row is F at its model, through a recovery in the leaf.** The recovery is stated as `type_of% @Row`, and a certificate `@Row = @Recovery := rfl` ties it to the row's own type.
- **The discharge condition.** The recovery meets each of F's hypotheses from the row's own by definitions alone. Its proof uses no theorem except F, the named bridge equivalences of §1.1, and `Init`'s projections and constructors.
  - Amounts may still define the model's relations. Row 17's giving is `present ∧ 0 < give` (Flow.lean:280–281), and that is allowed.
  - What is excluded is amount reasoning used to meet a hypothesis.

This reuses the measure's existing convention: theorems that "name nothing beyond the grammar and the prelude … are on the root already" ([WHAT-REMAINS](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), from WRP's measure).

**What separates standing 2 from derived.** Y is a grammar law, and a derived row adds nothing to it. F is not a grammar law. Its hypotheses beyond what the grammar's laws give stay in the row, and each countermodel shows one of them needed.

**What a form establishes, and what it does not.** A form under the strict reading shows that the row's conclusion follows by logic alone from its hypotheses read as relations, and that none of them is redundant. It does not show:
- that the row uses the grammar's laws. Connected rows do; the two forms written so far use none (`descent_forms_no_dependence` uses no theorem, and `outside_leaves_no_offspring` uses one prelude list lemma and its own length lemma).
- that the hypotheses hold, or are warranted. They are premises of the account (K3).

The root countermodels over `Unit` show only that no hypothesis is redundant in the form; any non-redundant first-order hypothesis has one. So lever 2's witnesses at the model stay beside them, as evidence that the model does not meet each hypothesis automatically.

**Why the discharge condition.** Without it, a recovery could meet F's hypotheses through any lemma the record names, and two things would follow:
- **Degenerate forms would pass.** A form whose one hypothesis is its conclusion (`Holds a := a`) passes the name and amounts tests, has a countermodel, and is met by the row's own proof. The discharge condition stops it; the check's ninth control is that form (§4).
- **Like rows would be placed unlike.** Row 5 and `Flow.Balances.renewedBy` both use balance only to find a giver for every rise.

**The loose reading, not adopted.** On it, the root form may keep the model's own structures, a `Flow`, a `Web` or `Generations`, and state its hypotheses as grammar inclusions over relations the model defines. The design does not take it, because under it every model whose relations can be named would be "on the root".

**An alternative OU's owner may take instead.** If a weaker sense of standing 2 is wanted, it can be named as a standing of its own, "under a stated hypothesis, met through ⟨lemma⟩", and applied to every row by a scan, `renewedBy` included. The design does not propose it.

**Lever 2's four rows on this line.**
- **Row 17 is "witnessed at its model".** The hypotheses of its lever 2 form are the gate and descent as two inclusions at one step, and a generation wholly inactive, each witnessed. That form keeps the model's terms. Its strict form passes every test of §1.5, its recovery meeting the discharge condition, so the row reaches standing 2 when the leaf lands (§4).
- **Row 5 stays at "balance in its statement".** Its statement writes balance out at its one relatum (rule 1, §2). Its strict form, `descent_forms_no_dependence`, records the row's relational part. The recovery meets "given to" from the balance only through `Flow.descends_of_comes`, which is amount reasoning: balance and a rise from nothing give a positive giving, through `total_pos` and `BalancesOn.rise_given`. So it fails the discharge condition. Lever 2's form `no_new_dependence_of_given` and its witnesses keep their place as evidence. `Flow.Balances.renewedBy` has the same structure, and stays at "balance in its statement" with it; no form is written for it.
- **Rows 13 and 14 are at amounts.** Row 13's cancellation, `G.raisedAt t = G.loweredAt t`, constrains amounts. So do row 14's cancellation and its `inactive`, which compares `total h (G.amount t) < total g (G.amount t)`. They therefore sit with rows 1–3, 7 and 8, which have the same shape. Their forms and witnesses stay in lever 2's scratch as evidence.

**F5's items** are statements at a represented model, which U2 named "a representation, not a derivation". They join standing 2 only where a strict root form has them as its instance. No item has such a form yet.

**F5's plan.** F5's spec §4 plans two things that bear on this record ([F5-MODEL-STATEMENTS.md](../../../../2026-10-05-repository-reconciliation/architecture/mv/F5-MODEL-STATEMENTS.md), "Not in this field").
- **Telling derivation from connection.** The spec says this "reads the Lean and needs nothing declared". Reach is indeed read from the Lean, but reach does not tell a case from steps; the independent reading had to read the proofs (§3). So the record declares Y and the bridges, and MV checks reach against them.
- **A named premise on the grammar (F5's third value).** Its input is the grammar form of a premise in COVERAGE.json's register (K3), such as `Web.Dependent` with `dependent_iff`. K3's witnesses (`World.contingent`, `World.independent`) meet and fail each premise in some world. A strict form's hypotheses are such premises in grammar terms, and its countermodels show more: dropping the hypothesis from that form makes the conclusion fail. So the record names each strict hypothesis's premise in K3's register where there is one:
  - Row 17's gate is "only active relata give".
  - In row 5's relational part, "given to" is met by K3's balance, which is stronger, and only through amount reasoning.
  - Row 5's inheritance is weaker than K3's bounded transmission, which is inheritance with the need within δ (`Flow.transmitsWithin_iff`).
  - The others have no entry.

  MV's third value and standing 2 then share the grammar forms.

### 1.3 Premise

A premise is stated on the root, with a proof that no statement about the dynamics entails it.
- **The continuation condition stands here.** `ReadsOnlyDynamics.not_entails` (Significance.lean:296) proves it of `Unrestricted`.
- **C does not.** `not_entails` says nothing of C, calling widening better, whose reason is open apart (07).
- **K3's premises** (balance, dissipation, a census and the rest) are hypotheses of the account, with witnesses that meet and fail them. They have no proof of not-entailment.

None of these is a central declaration.

Three central declarations keep `sig` free in their general statements: row 1, `unrestricted_iff_livingSignificance`, which is the condition read as living significance, and rows 8 and 9. U3 gave each a root form at the structural reading of `sig` only, and F5 keeps all three among the rest (U3's standing, WHAT-REMAINS). Their label is "free significance". It is a distance kept on purpose by 07 §1, not a gap. `not_entails` does not have the shape of a standing-2 countermodel, so a row whose only kept hypotheses are the condition is not counted under standing 2.

### 1.4 Below the grammar

**Laws of counting** need no premise. They are laws over lists and maps to `Nat`, holding for any carrier, predicate or listing. Lever 2 decided to count them apart (REVIEW-U4-L2, S2), not as distances and not as derived. There are six:
- lever 2's rows 6, 12 and 18;
- `RelativePosition.rise_needs_fall`;
- `Listed.coming_of_ceasing`, which holds for any carrier, predicate and exact listing, and whose statement unfolds to the prelude's `Distinct` and `Init`;
- `CensusWebs.keep_pace`, which is the counting law `CountsAcross.keep_pace` at a web's arising and ceasing.

**No row is counted as a law of logic.** The 12 rows EC6 calls "definitional or representational" keep the standing F5's items give them: 9 at a represented model and 3 on their own carrier, each flagged "definitional" with its reading. Several are not definitions unpacked:
- `ExchangeLaw.response_not_fixed_by_coupling` constructs two exchange laws;
- `Web.significance_undetermined` is a not-entailment by two constant significances;
- the three `Web.roles_*` rows are representation lemmas of the one-kind construction `roles`.

Narrowing "logic" to `Iff.rfl` and tautologies would need OU's owner's decision, and would make the record's counts disagree with F5's. The design does not propose it.

### 1.5 The tests, and where they run

F5's `verify` requires at least one grammar term in a statement (master_laws.py, `verify`). It shows the other terms only from the direct type constants, and it never tests "nothing else". The record needs new tests.

**The name test, by module, on declared items only.** It applies to Y, F, each hypothesis's definition, each countermodel and each witness, never to rows (finding 1). A constant is admitted when it is one of:
- an `Init` constant, one the package does not declare;
- a constant of `Becoming.Prelude` (Prelude.lean:1–7);
- a root constant of a `Becoming.Grammar*` module, generated auxiliaries included: everything its type and value reach is itself admitted;
- for F and its countermodels, one of F's own hypothesis definitions; for a fit, also the witness definitions of F's module.

These are not admitted:
- the foundation's modules (`GenerativeCore`, whose `Generative.*` names include `Generative.Process`, a model; `RelationalRenewal`; `InquirySufficiency`);
- a «» name declared off the grammar, such as `«全生成则生成»` (KeepingWidening.lean:231) and `«及在渐粗列之相续»` (HeldPossible.lean:504).

For Y, F and a countermodel, the item is its statement, read directly with no unfolding. For a hypothesis's or witness's definition, it is the type and the body, since the type alone names only `«际»`.

**The tests on a standing-2 form**, all run by the Lean check (§4):
- the name test on F's statement and on each hypothesis;
- no amounts in a hypothesis: no `Nat`, and none of its order and arithmetic (`LE.le`, `LT.lt`, `HAdd.hAdd`, `HSub.hSub`, `HMul.hMul`), in its type or body;
- F's telescope, as §1.2 states it;
- each countermodel against F's telescope with one binder removed (defeq at reducible transparency, binder names and infos aside);
- each fit's shape, witness and facts, and the countermodel naming the same facts;
- F's proof and what it reaches;
- the certificate's type, and the recovery applying F;
- the discharge condition, against the flag the record declares for the row.

**Where the tests run.** The dump drops `Init`'s constants, so from the dump the amounts test cannot run and "names only `Init`" cannot be told from "names nothing". MV has proposed two dump fields, `eq` and `x`, that would carry what these tests read; they need the coordinator's yes. Until then the Lean check runs the tests, and MV records its result.

**For a derived row**, MV checks from the cache that Y passes the name test and that the row reaches Y and each named bridge.

**MV's field.** MV's owner's draft keys a standing-2 row by `{hypothesis, countermodel, fit}` for each hypothesis, with `recovery` and `certificate`, and counts the standings in `counts_at_boundary`.

**Axioms.** Every declared item is in the core, so its axiom report is empty. The check itself imports `Lean`, so it is periphery: it lands with this study or with MV's tools, outside the package's `Becoming/`.

## 2. The table

[boundary_table.py](boundary_table.py) joins four sources for each distinct central declaration:
- **The measure's row:** dependence, category, master laws and EC6's reason.
- **Where balance enters:** `Flow`'s anchors in the statement (the type and the definitions it unfolds), or only in the proof; whether the prelude's counting law is the only balance anchor; and whether the statement writes balance out, its own type naming `Dependence.level`, `Flow.taken` and `Flow.given`.
- **Grammar reach, by MV's walk** (master_laws.py), the measure's: from the declaration through every constant its type and proof use, stopping only at a «» name.
  - A grammar law is a «» theorem of a `Becoming.Grammar*` module; any other «» constant of one is a grammar term.
  - A «» name declared elsewhere is listed apart and not counted. No central row reaches one.
  - A `Grammar*` constant without a «» name, such as GrammarLaws' list and number helpers or `kept_onward`, is walked through, so what it reaches counts.
- **F5's items:** with F5's class for the row.

Every rule reads the statement or a fact recorded apart, namely the measure's reach or F5's verified items. The rules, in order:
1. A row with balance in its statement, through `Flow`'s anchors or written out, is **balance in its statement**.
2. A row that reaches the grammar is **connected**. The reading marks the cases as derived.
3. A row with an F5 item at an occurrence or process model is **at a represented model**. One whose only items are on its own carrier is **own carrier**. EC6's definitional rows are flagged.
4. Every other row is **unplaced**. A reading of its statement places it, and the record keeps no unplaced row.

**Proof-only facts.** Where only the proof reaches balance or the prelude's counting law, the table records that in the row's `balance` field and does not place the row by it.

**The readings.** `HAND` gives the readings, each with the result that places it. The table shows what the rule would give beside each one (`rule_would_give`). Forty-one rows carry a reading. For 39 of them it differs from the rule: 31 are rows that rule 4 leaves unplaced and their statements place, and 8 move from connected to derived. `NOTES` adds to a rule's basis without changing the standing; row 5's note names its relational part.

## 3. The connected rows

An independent reader checked against its Lean each of the 31 rows that then reached the grammar with no balance ([CONNECTED-ROWS-READING.md](CONNECTED-ROWS-READING.md)). The reader read proofs only and built nothing. Each row got one verdict:
- **case:** the row is one grammar law at its model;
- **steps:** the row uses grammar laws among its model's facts.

The first review rechecked the eight cases (REVIEW-U4-BOUNDARY, B3).

**Eight are cases, and need no new Lean.** Each proof already is the law at the model's relation. It goes through bridges that hold for every instance of the model's parameters and add no hypothesis. The record declares the law and names the bridges, and the rows are derived.

| Row | The law it is a case of | At | Principal bridges |
|---|---|---|---|
| `Flow.beyond_gives_nothing` | `«所闭之界»` | R = `L.FedFrom W` | `FedFrom` and `FedBy` unfolded; one prelude step, ¬ 0 < n → n = 0 |
| `Flow.withinSystem_of_withinInfluence` | `«所闭之单调»` | R = `AffectedBy`, S = `Shares` | `shares_of_affectedBy`, an unfolding |
| `Law.drawn_iff_not_returns` | `«定后有后则入当且仅当不返»` | R = `next x = y` | `drawn_iff_drawnIn` and `absorbing_iff_closed`; `reaches_iff_orbit` and `returns_iff_reaches`, by recursion |
| `Law.lossless_iff_returns` | `«有限遍后定后则定前当且仅当皆返»` | R = `next x = y` | `lossless_iff_fixedBefore`, an unfolding; `returns_iff_reaches`, by recursion |
| `Learning.goAlike_iff_lumped` | `«像定后当且仅当同行»` | the law's step, along π | `goAlikeUnder_iff_alike` and `lumped_iff_fixed_image`, unfoldings |
| `Tolerance.answers_restores_iff` | `«承之迭»` | R = `up` | `answers` is `«承» up` by definition; `chain_iff_steps`, by recursion through `«迭之末步»`; the start instantiated at `allWithheld` |
| `Withholding.withholding_spreads` | `«存承之迭»` | R = `up` | `waitsAll` by definition; `within_iff_withinSteps` through `chain_iff_steps`, by recursion |
| `WithinMoves.after_course` | `«迭内之接»` | R = `Steps P` | `trace_steps` and `trace_iff_steps`, by recursion; `withinMoves_iff_withinSteps` |

**The closed sets.** MV's probe adds these steps of the principal bridges, which the record names with them:
- `withinSystem_of_withinInfluence`: `WithinClosure.mono`.
- `drawn_iff_not_returns`: `Law.returns_iff`, `reaches_of_orbit`, `orbit_add`, `orbit_shift`, `next_fixed`, `next_total`, `Branching.law_reach_iff`, `law_trace_iff`, `law_trace_of` and `units_length`.
- `lossless_iff_returns`: `Law.lossless_iff`, `reaches_iff_orbit`, and the same ten.
- `answers_restores_iff`: `Tolerance.KeepsInclusion.course`, `KeepsInclusionInto.course`, `answers_keeps`, `worst_start`, `Withholding.answers_closed`, `Chain.last`, `Chain.last_of_eq` and `Chain.zero_eq`.
- `withholding_spreads`: `Withholding.waitsAll_closed`, `Chain.last`, `Chain.last_of_eq` and `Chain.zero_eq`.

Five of the eight use bridges proved by recursion. The test of §1.1 admits all five, since each bridge holds at every instance of the model's parameters and adds no hypothesis.

**Two rows are cases of laws not yet on the grammar.**
- **`Flow.mutuallyDependent_iff_reach`** is exactly `WithinClosure.converse`, `«所闭» («逆» R) f g ↔ «所闭» R g f` (Response.lean:91).
  - Its content is grammar-only, but it is declared off the grammar. The grammar's `«所闭之对称»` needs R symmetric. No `«所闭之逆»` or `«及之逆»` exists; only `«迭之逆»` does.
  - Declaring the law in GrammarLaws does not by itself make the row reach it. `WithinClosure.converse`, which has its own proof and 10 uses, must be re-proved as one application of `«所闭之逆»` in the same rebuild. That is an edit to Response, by its owner.
- **`Flow.withinCoupling_reads_iff`** is two general closure laws over any relation that are declared off the grammar: `WithinClosure.of_reads` and `WithinClosureOf.to_reads` (SelectionPool.lean:559, :570). Its hypotheses are met by case splits on the model. It needs no new form.
  - `WithinClosureOf` is Frame's, and the grammar has no closure-of-a-region form. Over the region "o or a", though, that closure is `«所闭» R o g ∨ «所闭» R a g`, so the halves are stated on `«所闭»` alone.
  - OU's owner has named them `«借步之所闭在二所闭»` (of_reads) and `«二所闭在借步之所闭»` (to_reads). The names avoid 之逆, which the grammar keeps for the converse relation.
  - The two lemmas are re-proved through these laws by SelectionPool's owner.

Both are on the board as HE2's items 3 and 4 (`14c7c0cdf`), for the next near-full rebuild. The record does not wait for that rebuild: both rows land as connected and are updated at it.

**Twenty-two use grammar laws as steps.**
- **One has a form the grammar lacks: `Branching.loss_passes_juncture`.** No grammar module states a law of junctures (Junctures.lean:132–148). A juncture law with the row as its case would be new Lean, weighed in the leaf's design.
- **`Amounts.rests`** rests on `«尽则不或屡»`, which is already its grammar form. The row adds amounts: it proves the law's ending hypothesis from "m copies of ε are not within s T".
- **Six carry a closed region along a run.** That is `«闭含所闭»` applied through `«所闭»`'s definition, so the walk does not show it. Their closedness itself needs their model's facts, so only the carrying part has a grammar form. The six are `Pace.rule_until_reading`, the two `RuleCapture` rows, `Valuation.significant_iff`, `ClosedCapture.lock_outlives_loss` and `RegimeMargin.Coupled.Indexed.ends_downstream`.
- **Fourteen have no form the grammar lacks.**
  - **Eleven** are amounts, counting, prediction from prefixes, or the valuation's own logic.
  - **`presupposition_scopes` and `onLoop_of_closing`.** The first draft proposed forms for both, and they are dropped. `presupposition_scopes`'s form is the closure's definition read through `«闭含所闭»`, `«所闭之闭»` and `«所闭之自反»`, so the grammar has it already. `onLoop_of_closing`'s form is a corollary of three laws (`«及当且仅当一步而所闭»`, `«所闭当且仅当同一或及»` and `«及之传递»`); it would be new only as a single statement.
  - **`act_courses_unselected`** joined the connected rows when the balance rule became statement-only, and the reader did not read it. Its statement names no balance. Its proof uses the balance that `course_balances_iff` proves, and it reaches `«所闭之传递»` and `«缘在所闭»` as steps.

The rows in each group are in the reading's table, and each row's `reading` field gives its group.

## 4. What would move, and the work

- **The eight cases** (§3) are derived once the record declares their laws and bridges. They need no Lean.
- **`Flow.mutuallyDependent_iff_reach` and `Flow.withinCoupling_reads_iff`** become cases at HE2's rebuild, once their laws are in GrammarLaws and the existing lemmas are re-proved through them.
- **Row 17** moves to standing 2 when its strict form lands. The forms are written in [boundary-scratch](boundary-scratch/Becoming/U4Boundary.lean) and built with `scratch_build.py`: 30 theorems and 42 declarations, every axiom report empty ([build log](boundary-scratch/scratch-build.log)). Each form's statement names `«际»`, `Init` and its own hypotheses only. Each hypothesis's definition names grammar terms and `Init` only. The fact `one_offspring` uses the prelude's `Naturals.succ_ne_zero`, since `Init`'s carries `propext` in this toolchain.
  - **Row 17, `outside_leaves_no_offspring`.** Where giving lies within giving from a region (`GivesFrom`, the grammar's `«则»` and `«而»`) and listed descent lies within giving (`ListedWithin`), a listing wholly outside the region (`Outside`) has no listed offspring: the join of its offspring lists has length 0.
    - The recovery `all_end_at_model` takes giving as a member taking part giving a positive amount, the region as activity at the step, and the listing as the generation. The next generation's size is that length by `family`'s definition. The recovery meets each hypothesis by definitions alone: its proof uses no theorem but the form, `And.left` and `And.right`.
    - Its countermodels and fits are `needs_gate` and `gate_needed` (lever 2's `Ungated`), `needs_descent` and `descent_needed` (`Ungated.silent`), and `needs_outside` and `outside_needed` (`Lifted.inactive_needed`).
  - **Row 5's relational part, `descent_forms_no_dependence`.** Where what comes to stand is given to (`GivenTo`), dependence after the step is inherited along descent (`Inherits`), and nothing descended from depends before the step (`UndependedFrom`), nothing coming to stand depends after it.
    - The relations and regions are variables: descent, coming to stand, and dependence before and after the step.
    - The recovery `no_new_dependence_at_model` takes the form at the row's one relatum: coming to stand is `fun y => y = x ∧ W.ComesToStand t y`, and descent is descent from `x`. That restriction is legitimate, a singleton region, which the row forces, since its balance and inheritance hold at `x` only. Then `GivenTo` is lever 2's inclusion, met from balance alone through `Flow.descends_of_comes`, and descent's first part, taking part, meets `UndependedFrom` from the row's `none`. Lever 2's `Standing` has the region as its counterpart and needs no countermodel.
    - Its countermodels and fits are `needs_given` and `given_needed` (lever 2's `Ungiven`), `needs_inherits` and `inherits_needed` (`Uninherited`), and `needs_undepended` and `undepended_needed` (`Held`).
    - The recovery fails the discharge condition, so the row stays at "balance in its statement" (§1.2).
  - **Countermodels and certificates.**
    - The countermodels are built on the root directly, over `Unit`, from named witness parts (`everywhere`, `nowhere`, `allRelated`, `noneRelated`, `oneListed`, `oneOffspring`) and named facts. Lever 2's witnesses stay as the evidence at the model.
    - The certificates `no_new_dependence_certified` and `all_end_certified` are `@Row = @Recovery := rfl`.
  - **The check.** [U4BoundaryCheck.lean](boundary-scratch/Becoming/U4BoundaryCheck.lean) is a periphery check that imports `Lean`. [run_check.sh](boundary-scratch/run_check.sh) builds the forms with `scratch_build.py` and compiles the check with Lean directly. The check runs every test of §1.5 on both forms ([its output](boundary-scratch/check-run.log)), and finds the discharge condition holding for row 17 and failing for row 5, as the record declares.
  - **The controls.** [U4BoundaryControls.lean](boundary-scratch/controls/U4BoundaryControls.lean) holds nine negative controls. Each fails, and on the test it is meant for ([output](boundary-scratch/controls-run.log)):
    1. a row checked as a form;
    2. a repeated countermodel;
    3. a countermodel reaching its form;
    4. the prelude's `total` checked as a hypothesis;
    5. the second review's vacuous countermodel, ending in `False`;
    6. the second review's form with an inline amount hypothesis;
    7. a fact reaching the form;
    8. row 5's recovery claimed to discharge by definitions;
    9. a degenerate form whose one hypothesis is its conclusion.

    The name test is controlled as well. It admits `Nat`, the prelude's `total`, `«际»` and `«则»`. It refuses `Generative.Process`, `Flow.taken`, `U4Boundary.GivenTo` (a hypothesis, admitted only in its own form's items), and a «» name declared off the grammar.
  - **Names.** Lever 2's scratch names `*_on_root` stated a wrong meaning under the strict reading. The new forms are named for what they state, and the leaf takes the core's vocabulary at its claim.
- **Rows 13 and 14** stay at amounts, with rows 1–3, 7 and 8. A relational restatement of cancellation is not proposed, since cancellation is an equation of sums.
- **`Branching.loss_passes_juncture`** moves to derived if the grammar gains a law of junctures. The leaf's design weighs whether it should: the law must be one the grammar lacks, not a restatement of the row.
- **F5's items, the definitional rows and the counting rows** need nothing for the record. A strict root form for an F5 item is further work, not this record's.
- **The rows that stay** are those at balance in their statements, at amounts, and at free significance, and the other steps rows. They stay where lever 1, lever 2, U3 and the reading left them, with their witnesses and reasons:
  - for balance, `pairs_without_one_to_one` and `repeated_unit`, and for row 5 its relational part;
  - for amounts, lever 2 §6;
  - for free significance, 07 §1;
  - for the steps rows, the model's facts, named row by row in the reading.

  The two census rows are laws of counting, so lever 1's candidate through `«计»` adds nothing to their standing.

**The core leaf.** Every new theorem the record cites goes into one core leaf, as U2's `ModelStatements` and U3's `SignificanceStatements` did.
- **Contents:**
  - row 17's strict form, with its witnesses, facts, countermodels, fits, recovery and certificate;
  - row 5's relational part, which the record cites in the row's basis and which confers no standing;
  - the juncture law, if the leaf's design keeps it.

  The eight cases need no Lean there.
- **Place:** it imports `Becoming.Grammar` and the rows' modules (`Transmission`, `GroupEnding`), and nothing below it uses it.
- **Landing:** a claim on the board, a slot in the queue, and one incremental core run. The check and its controls stay outside the package.

## 5. Order and owners

1. **MV's field and verification.** MV's owner has drafted the spec on the tests of §1.5 (draft 3). Per declaration it carries a standing or a distance label, and:
   - for derived, the declared law and the bridges' closed set;
   - for standing 2, F, each hypothesis with its countermodel and fit, the recovery, and the certificate;
   - for standing 3, the not-entailed theorem.

   MV verifies from the cache what the cache can show (§1.5), and records the Lean check's result for the rest. The spec is reviewed and lands first.
2. **HE2's list**, for the next near-full rebuild. OU's owner has put both items on the board (`14c7c0cdf`):
   - `«所闭之逆»`, with `WithinClosure.converse` re-proved through it by Response's owner;
   - the two halves of `Flow.withinCoupling_reads_iff`, as `«借步之所闭在二所闭»` and `«二所闭在借步之所闭»`, re-proved by SelectionPool's owner.
3. **The core leaf**, claimed on U4's row, with an independent review, landing through the queue.
4. **The record.** GW has landed; the record does not wait on HE2's rebuild. Its home section is 08 §7, beside the master laws, since it reads every central declaration through them. MV counts the standings, and the record prints them beside F5's four counts.

## 6. Not done

- The strict forms are scratch, not package Lean. The leaf is not claimed, and no reviewer has read this revision of the forms or the check.
- The juncture law is not weighed yet.
- MV's field is drafted, not landed. The dump fields `eq` and `x` wait for the coordinator.
- The table ran on main `4ac8cf27e`. GW1, GW2 and GW6 have since landed (`e077583c6`). Whether they add central declarations is checked when the table is rerun on main.

## 7. The reviews, and what was taken

### The first review ([REVIEW-U4-BOUNDARY.md](REVIEW-U4-BOUNDARY.md))

| Finding | Taken |
|---|---|
| B1 (blocking): the strict reading admitted the prelude in hypotheses, so balance and rows 13 and 14 fell on both sides of the line | §1.2 states hypotheses apart: grammar terms only, list facts as counting, no hypothesis constraining an amount. Rows 5 and 17 were the candidates. Rows 13 and 14 go to amounts with rows 1–3, 7 and 8. The measure's convention for "on the root" is cited |
| B2 (blocking): the tests did not separate derived from standing 2, and claimed more of F5's test than it does | §1.5 specifies a new name test on declared items, not rows (finding 1: 0, 11 and 105). §1.1 and §1.2 separate a declared grammar law from a root form whose extra hypotheses stay in the row. F5's spec §4 is reconciled in §1.2. The second review's findings 2 and 3 complete this |
| B3 (blocking): five of the eight cases use bridges proved by recursion | The test is restated as bridges at every instance of the model's parameters, adding no hypothesis, each named. All eight stay derived. §3's table names the bridges, and the reading carries a correction note |
| B4 (blocking): the "logic" label put rows below the grammar that their Lean does not support | The label is dropped. All 12 rows keep F5's standing, flagged "definitional". The record's figures are printed against F5's four counts (§0) |
| M1: `Listed.coming_of_ceasing` is counting; rule 4 placed by the proof | Both census rows are counting. The rules read only the statement, and proof-only facts are recorded, not used to place. The balance column (55) is unchanged (§0, finding 3) |
| M2: `Flow.withinCoupling_reads_iff`'s halves exist | It goes on HE2's list beside `«所闭之逆»`, with no new form (§3) |
| M3: two of the four forms are not laws the grammar lacks | `presupposition_scopes` and `onLoop_of_closing` are dropped, and the juncture law alone is weighed (§3) |
| M4: declaring `«所闭之逆»` changes the row only if `converse` is re-proved through it | On HE2's entry, by Response's owner (§3, §5) |
| M5: one of the 44 reaches only `kept_onward` | Now settled by MV's walk, which passes through `kept_onward` to `«线则所闭»` and `«闭含所闭»`: all 44 reach a «» law (§0, finding 2; §2) |
| M6: rule 2 placed `act_courses_unselected` by its proof | The rules are statement-only, so it is connected (§3) |
| M7: lever 2's notes, §4's witness list, names, label | The notes are corrected (list facts unwitnessed; row 5's implication; row 13's cancellation). The witnesses are listed per row (§4). The scratch names are renamed at landing. Row 17 has its own label |
| M8: `not_entails` is not a countermodel's shape | The option is dropped (§1.3) |
| M9: wording | The leaf holds no bridges for the eight (§4). The rows taking balance only in their proofs are now two (§0, finding 3) |
| M10: order | MV's spec waits for §1.5. The record does not wait on HE2's rebuild (§5) |

### The second review ([REVIEW-U4-BOUNDARY-SECOND.md](REVIEW-U4-BOUNDARY-SECOND.md))

| Finding | Taken |
|---|---|
| 1 (blocking): "a row may carry more than its form needs" lets amount reasoning into the bridge; row 5 reaches standing 2 only through it, and `renewedBy` would follow | The rule is replaced by the discharge condition (§1.2). Row 5 stays at "balance in its statement", its strict form recorded as its relational part; `renewedBy` stays with it. Row 17 meets the condition. The Lean check computes it, and controls 8 and 9 test it (§4) |
| 2 (blocking): the names-only shape test passes a vacuous countermodel and an inline amount hypothesis | The check works on F's telescope: every propositional binder is one listed hypothesis, used once, and each countermodel is defeq to F's telescope with one binder removed. It also checks fits, facts, F's proof and the certificate. The nine controls are committed with their output (§4) |
| 3 (blocking): §1.5 cannot run on the dump; "outside `Becoming`" admits the foundation; any «» name was admitted | The name test is by module: `Grammar*` root constants, the prelude, `Init`, and the form's own definitions. The foundation and «» names off the grammar are excluded, and the controls test both. The amounts and shape tests run in the Lean check, and MV records the result until the dump carries them (§1.5) |
| 4: row 5's prose does not match its Lean | The recovery takes `comes := fun y => y = x ∧ W.ComesToStand t y`. `GivenTo` is lever 2's inclusion, the region is coming to stand, and `Standing` needs no countermodel. The record says the row is the form at one relatum (§4) |
| 5: row 5's placement contradicts §0 and §2 | Rule 1 reads balance written out (§0 finding 3, §2) |
| 6: what the forms establish | §1.2 says it in those terms. Lever 2's model witnesses stay beside the root countermodels, and §0 says the edge is not nearness to the grammar |
| 7: smaller points | The prelude's `Naturals.succ_ne_zero` is used. The leaf imports `Becoming.Grammar`, not GrammarLaws. "In the core", not "in the core leaf". The check tests the certificates and F's proof. The check lands outside the package's `Becoming/` (§1.5, §4) |

### MV's owner's reading (draft 3 of MV's field)

| Point | Taken |
|---|---|
| A derived row's bridges are the closed set MV's probe computes | §1.1, and §3 lists the additions |
| §1.3 overstated C | `not_entails` concerns the condition only (§1.3) |
| "balance, represented" names the measure's category, not this standing | The standing is "balance in its statement" |
| `kept_onward`'s wording; the walk | The walk is the measure's, stopping only at «» names. `kept_onward` is described neutrally, and the table's list of unnamed laws is dropped (§0, §2) |
| Standing 2's fields | `{hypothesis, countermodel, fit}`, `recovery`, `certificate`; the counts in `counts_at_boundary` (§1.5) |
| Dump fields | `eq` and `x` are proposed, and wait for the coordinator (§1.5) |
