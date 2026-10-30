# U4, the boundary record (design, draft)

AI-written design for the last step of U4, "one root to its edge" ([proposal](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#one-root-to-its-edge-a-proposal-30-october-2026), [OU's decisions](../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md#ous-decisions-on-u4-and-on-gw1gw2-30-october-2026)). The step is one record stating where every central declaration stands: derived, on the root under a stated hypothesis with a countermodel, a premise proved not entailed, or at a named distance whose failure is written down.

- **Status.** A draft, not yet reviewed. No package Lean is claimed and no record is written.
- **Order.** The record lands last, after GW1, GW2 and GW6, in OU's order. MV's field for the standings lands before it, as F5's field landed before U2's Lean. MV's owner has offered to draft that field (§5).
- **The table.** [boundary_table.py](boundary_table.py) produces [boundary-table.json](boundary-table.json). It ran on main `4ac8cf27e`, after U3's Lean landed. The script runs the master-law measure from the checker cache and compiles nothing.

## 0. Where it stands

On the strict reading this design recommends (§1.2), **no central declaration is on the edge yet**: 0 derived, 0 under a stated hypothesis, 0 premise. 16 stand below the grammar, as laws of logic or of counting. The other 102 sit at named distances, each with its reason:

| Standing | Count | What it is |
|---|---:|---|
| derived | 0 | a case of a declared grammar law (§1.1) |
| under a stated hypothesis | 0 | a case of a declared root form, each hypothesis with its countermodel (§1.2) |
| premise | 0 | none of the central declarations is a premise; the continuation condition and C are not central declarations (§1.3) |
| logic | 12 | definitions unpacked; most are stated at a model by U2 |
| counting | 4 | laws over lists and maps to `Nat`: lever 2's rows 6, 12 and 18, and `RelativePosition.rise_needs_fall` |
| connected | 31 | reaches grammar theorems among its reasons, with no balance; derived only once a grammar law it is a case of is declared (§3) |
| balance, represented | 32 | takes `Flow`'s balance in its statement (31) or its proof (1); lever 1's verdict |
| amounts | 18 | its statement compares amounts the grammar has no terms for |
| at a represented model | 7 | F5's items at a World's occurrence model or a process's model |
| own carrier | 4 | F5's items on the row's own carrier |
| at its model | 7 | a law of its model with no statement on the root; lever 2's four rows wait here (§4) |
| free significance | 3 | U3's rows 1, 8 and 9: the general statement keeps `sig` free, as 07 §1 intends |

Three findings shape the record.

1. **No central declaration states itself in the grammar's terms.** Under F5's own test (`stated`, `is_grammar_term` in tools/research/master_laws.py), all 118 statements name their model's terms. A standing is therefore carried by a declared item, as F5's statements at a model are: a grammar law the row is a case of, or a root form the row is an instance of.
2. **Reaching the grammar is connection, not derivation.** All 44 declarations that reach the grammar reach grammar theorems. Most reach only closure's elementary laws, used as steps: `«所闭之传递»`, `«所闭之自反»`, `«缘在所闭»`, `«所闭之闭»` and `«所闭之单调»`. Some reach finite runs' `«尽则不或屡»`, and a few reach a master form itself. So the figure "44 reach the grammar" says a grammar law is among their reasons. It does not say the row is a grammar law at its model. Which rows are cases is read in §3.
3. **Balance enters 31 rows' statements and one row's proof. Ten of the "balance, represented" rows are about amounts instead.** The measure counts `balance_over_stretch_on` as a balance anchor. It is the prelude's law of counting over a stretch.
   - Ten rows reach only that law, and balance appears in none of their statements: the RegimeMargin and frontier rows, and the two census rows. Their distance is amounts.
   - Two more rows have balance only in their proofs. `Flow.no_new_dependence` uses it to find a giver, and lever 2 places it under "coming to stand is given to". `Flow.new_beyond_every` concludes on imbalance, which is an amount.
   - Of the 44 rows that reach the grammar, 13 also take `Flow`'s balance: 12 in the statement, and `act_courses_unselected` in the proof only.
   - Lever 1's recount by anchor reached (18, 10, 3) is right as far as it goes. This split, by statement against proof, is the one the edge needs.

## 1. The standings

### 1.1 Derived

A row is **derived** when it is a case of a declared grammar law Y. The conditions are:
- Y is a theorem whose statement names only grammar terms and the prelude. MV checks this with F5's test.
- The row's statement follows from Y read at the row's model, unfolding only the model's definitions of grammar notions. For example, `WithinClosure` is `«所闭»` by definition, and a coupling is a relation.
- The row's proof reaches Y, or a bridge theorem applies Y at the model and concludes the row.

Reaching a grammar law used as one step among the model's own reasoning does not make a row derived. The record declares Y, and the bridge where one is needed. MV verifies the declaration.

### 1.2 Under a stated hypothesis: two readings

The proposal states standing 2 as "the hypothesis is written in the grammar's terms, and a countermodel on the root shows it cannot be dropped". Of a law of a particular model, it says the law "is stated at a represented model, the model cut out by a stated hypothesis, with a countermodel on the root". Two readings fit those words.

- **The strict reading.** The root form is a theorem whose statement names only grammar terms and the prelude, quantified over every relation and every amount function `X → Nat` that meets its hypotheses. Each hypothesis has a countermodel: a named theorem on the root whose statement names that hypothesis, and in which every other hypothesis holds while the conclusion fails. The row is the root form's instance at its model.
- **The loose reading.** The root form may keep the model's own structures, a `Flow`, a `Web` or `Generations`, and state its hypotheses as grammar inclusions over relations the model defines, such as `«则» (gives L t) («而» (activeAt W t) (gives L t))`.

**This design recommends the strict reading.** Only it gives MV a check that reads the Lean: the statement names grammar terms and the prelude and nothing else. Under the loose reading, every model whose relations can be named would be "on the root", and the third standing's line would fall where the measure cannot see it. Lever 2's four rows (5, 13, 14 and 17) have their hypotheses witnessed. But their forms keep the model's terms (`W.requires`, `G.Raises`, `G.size`, Price's sums over `SelectionLevels`), so on the strict reading they stand at their model until restated (§4).

F5's items are statements at a represented model. U2 named them "a representation, not a derivation". They join standing 2 only where a strict root form, with the model's relation a variable under stated hypotheses, has them as its instance. No item has such a form yet.

### 1.3 Premise

A premise is stated on the root, with a proof that no statement about the dynamics entails it. The continuation condition and C stand here (`ReadsOnlyDynamics.not_entails`), but neither is a central declaration. Three central declarations keep `sig` free in their general statements: row 1, `unrestricted_iff_livingSignificance`, the condition read as living significance; and rows 8 and 9. U3 gave each a root form at the structural reading of `sig` only, and F5 keeps all three among the rest (U3's standing, WHAT-REMAINS). Their label is "free significance", a distance kept on purpose by 07 §1, not a gap.

How a row whose only kept hypotheses are the two premises would count is for MV's field to say. One option is standing 2, with `not_entails` standing in for the countermodel. Another is a case of its own.

### 1.4 Below the grammar

**Laws of logic** (definitions unpacked) and **laws of counting** (lists and maps to `Nat`) need no premise and hold for every carrier. They are counted apart, as lever 2 decided for counting (REVIEW-U4-L2, S2), not as distances and not as derived. Most of the logic rows are already stated at a model by U2.

## 2. The table

[boundary_table.py](boundary_table.py) joins four sources for each distinct central declaration:
- the measure's row: dependence, category, master laws and EC6's reason;
- where `Flow`'s balance enters, the statement (the type and the definitions it unfolds) or only the proof, and whether the prelude's counting law is the only balance anchor;
- the grammar theorems and definitions its type and proof reach, with grammar constants not expanded;
- F5's items.

Rules give a standing, and `HAND` gives the rows that need a reading, each with the result that places it. The table records both what the rule would give and what the reading gives, so the review can see every override.

The rules, in order:
1. A row that reaches the grammar and takes no `Flow` balance is **connected**.
2. A row with `Flow` balance in its statement, or reaching the grammar with balance in its proof, is **balance, represented**.
3. A row with an F5 item at an occurrence or process model is **at a represented model**; one with an F5 item on its own carrier is **own carrier**.
4. A row whose only balance anchor is the prelude's law, or that has balance only in its proof, is **amounts**.
5. Every other row is **at its model**.

The readings cover lever 2's rows (its audit's table), the definitional rows (EC6 and U2), the significance rows (U3) and a few laws of their models.

## 3. The connected rows

An independent reader is checking each of the 31 connected rows against its Lean. Each row gets one verdict:
- **case:** it is one grammar law at its model; the reader names the law and the bridge needed.
- **steps:** it uses grammar laws among facts of its model; the reader names those facts, and whether a root form seems possible.

The rows judged cases become the record's derived rows, each with its declared law and any bridge. The rest stay connected, with the model's facts named. This section is filled in from the reading.

## 4. What would move, and the work

- **Cases** (§3) move to derived, with Y declared and, where needed, a bridge theorem.
- **Lever 2's four rows** move to standing 2 once each is restated on the strict reading:
  - relations become variables for gives, descent, activity and requiring;
  - amounts become functions to `Nat`;
  - Price's sums become the prelude's;
  - each hypothesis gets a named countermodel theorem on the root, carried over from `Ungiven`, `Raised`, `Ungated`, `EndsAmong`, `Lifted` and `Kept`.

  Row 5 looks easiest, since its content is relational. Rows 13 and 14 carry Price's partition, a law of counting. That is prelude, so a strict form is in reach.
- **F5's items, the logic rows and the counting rows** need nothing for the record. A strict root form for an F5 item is further work, not this record's.
- **Balance, represented; amounts; free significance.** These stay where lever 1, lever 2 and U3 left them, with their witnesses: `pairs_without_one_to_one` and `repeated_unit` for balance; lever 2 §6 for amounts; 07 §1 for free significance. The two census rows remain lever 1's candidate through `«计»`.

Every new theorem the record cites goes into one core leaf, as U2's `ModelStatements` and U3's `SignificanceStatements` did. The leaf holds the bridges for the cases, lever 2's strict root forms, and the countermodels as named theorems. It imports the rows' modules and `GrammarLaws`, and nothing below it uses it. It needs a claim on the board and a slot in the queue, with one incremental core run.

## 5. Order and owners

1. **MV's field and verification.** MV's owner drafts the spec in the shape this design needs: per declaration, a standing or a distance label; for standing 2, each hypothesis and its countermodel; for standing 3, the not-entailed theorem; for derived, the declared law. MV verifies these from the checker cache, and the spec is reviewed and lands first.
2. **The connected rows' reading** (§3), then this design's independent review.
3. **The core leaf**, claimed on U4's row: bridges, strict root forms and countermodels. It gets an independent review and lands through the queue.
4. **The record**, after GW's landing. Its home section is 08 §7, beside the master laws, since it reads every central declaration through them. MV counts the standings.

## 6. Not done

- The connected rows' reading (§3) is under way.
- No strict root form is written yet.
- MV's field is not drafted.
- The table's readings in `HAND` are this design's and have not been reviewed.
- GW1, GW2 and GW6 have not landed. Whether they add central declarations is checked when they do.
