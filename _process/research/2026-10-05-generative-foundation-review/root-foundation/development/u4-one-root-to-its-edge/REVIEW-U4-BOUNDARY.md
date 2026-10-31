# Review: U4, the boundary record (DESIGN-BOUNDARY.md)

*Independent AI review. Read-only on checkout `wt-u4` (branch `u4-edge`, `a79a029f4`); nothing compiled; only this file written.*

**Path abbreviations.** `D/` = `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u4-one-root-to-its-edge/`. `L/` = `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`. `WR` = `D/../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md`.

## Verdict: sound with fixes (4 blocking)

The direction is right:
- the strict reading over the loose one;
- the eight cases are cases (checked in Lean);
- the split by statement against proof;
- "no central declaration is a premise".

What is not yet sound is the line that the strict reading draws, and the tests that MV is said to run. As written, those tests:
- admit balance into standing 2;
- leave rows of the same shape on opposite sides of the line;
- fail to separate standing 1 from standing 2;
- yield 3 derived rows, not 8, if read literally.

The "logic" label puts at least five rows below the grammar that their Lean does not support.

**Reproduction.** `boundary_table.py` with `--dump` reran in about 1 s. Its output is identical to the committed `boundary-table.json`, compared with sorted keys: 118 rows; 8/0/0 on the edge, 12/4 below, and 23/32/18/7/4/7/3 at distances. The counts in §0's table and in finding 3 reproduce (31 + 1 balance rows; 10 prelude-only; 13 of the 44 with `Flow` balance). `statement_closure` is sound for the 31 rows with balance in their statement: every path from the type to a `Flow.Balances*` anchor runs through definitions only, never through a theorem (checked by BFS).

## Blocking

**B1. The strict reading admits the prelude in hypotheses, so its line is not the theory's line.**

The rule (`D/DESIGN-BOUNDARY.md:53`) allows statements that name "only grammar terms and the prelude, quantified over every relation and every amount function". It sets no rule for hypotheses. The proposal sets one: "the hypothesis is written in the grammar's terms" (`WR:226`). It also counts "balance, represented" and the second sort as distances (`WR:229`). The design's placements contradict each other under any single rule:
- **Balance.** `Flow.Balances` unfolds to `Nat` equations over lists with the prelude's `total`. Stated as a hypothesis on amount functions, with a countermodel, it meets §1.2 as written. So the 32 "balance, represented" rows would be in reach of standing 2 just as rows 13 and 14 are.
- **Rows 13 and 14** are called "in reach" (`:131`). Yet their hypotheses constrain amounts:
  - cancellation `G.raisedAt t = G.loweredAt t` (`D/lever-2-scratch/Becoming/U4LeverTwo.lean:439`, `:574`);
  - row 14's `inactive`, which compares `total h (G.amount t) < total g (G.amount t)` (`:575`).
- **Rows 1–3, 7 and 8** are placed at "amounts", a distance (`D/boundary_table.py:68-71`). They have the same shape as row 13: the gate and descent as hypotheses, and a conclusion comparing sums of `G.amount` over `Generations`. Compare row 7 (`L/SelectionTerm.lean:670-676`, `G.size T * G.sum 0 ≤ G.size 0 * G.sum T`) with row 13 (`L/SelectionLevels.lean:553-560`).

**Fix.** State the rule for hypotheses separately:
- Hypotheses may name grammar terms only: relations, regions, classes and «» notions. List facts may appear as counting, which quantifies over every map.
- A hypothesis that constrains an amount function (balance, cancellation, `need ≤ level`, comparisons of trait sums) keeps the row at a distance.
- The conclusion may use the prelude.

Under that rule, rows 5 and 17 are the candidates for standing 2. Rows 13 and 14 join rows 1–3, 7 and 8 at "amounts", unless their cancellation and `inactive` are restated relationally; §4 must say so. If amount hypotheses are to be admitted instead, §1.2 must say why balance is not, and rows 1–3, 7 and 8 move to "in reach". Also cite the existing convention: theorems that "name nothing beyond the grammar and the prelude … are on the root already" (`WR:108`, from WRP's measure). That convention supports the strict reading and is the test it should reuse.

**B2. The tests do not separate derived from standing 2, and claim more for MV than MV does.**

1. **The claim about F5's test.** "MV checks this with F5's test" (`:43`) is not what F5's test does. F5's `verify` requires at least one grammar term (`tools/research/master_laws.py:163-166`). It displays other terms only from the direct type constants (`:170`), and it never tests "nothing else". The test needed is new, and it must be specified:
   - Which prelude counts: `Becoming.Prelude` plus `Init` (`L/Prelude.lean:1-7`).
   - Whether the statement's own definitions are unfolded. At the name level, all 118 rows fail, as finding 1 says. Once their own definitions are unfolded, 11 rows name only grammar, `Becoming.Prelude` and `Init` terms:
     - the four counting rows;
     - `Listed.coming_of_ceasing`;
     - `Weighting.widens_iff_every_positive`;
     - `Learning.Training.unselected_beyond_data`;
     - `Learnable.learnable_iff`;
     - `onLoop_of_closing`;
     - `forced_iff_center`;
     - `presupposition_scopes`.

     A name-level test also punishes file placement, as REVIEW-U4-L2 S2 found for the counting rows (`D/REVIEW-U4-L2.md:114`).
   - Model structures (`Web`, `Flow`, `Generations`) are bundles of relations and amount functions. Under a name test, unbundling them alone moves a row, which is packaging, not the theory.
2. **Derived and standing 2 collapse.** A strict root form landed in the core leaf (`:135`) is "a theorem whose statement names only grammar terms and the prelude". That is exactly §1.1's Y. So rows 5 and 17 would read as derived, not standing 2.
   **Fix:** define derived as follows: Y is declared on the grammar (in a `Becoming.Grammar*` module, or on a list of grammar laws kept by OU's owner), and the row carries no hypothesis beyond Y's own, instantiated. Define standing 2 as a root form whose extra hypotheses stay in the row, each with its countermodel.
3. **Shapes MV cannot read.** The dump keeps constant names, not terms. So MV cannot verify:
   - that a bridge concludes exactly the row;
   - that a countermodel has "every other hypothesis hold while the conclusion fails" (`:53`, `:139`).

   **Fix:** have Lean check both:
   - state each bridge at the row's own type (`theorem … : type_of% @Row := …`);
   - state each countermodel as the negation of the root form with that one hypothesis dropped.

   MV then verifies existence, empty axiom reports and reach, and a review confirms what the dump cannot show, as F5 does (F5 spec §2).
4. **F5's own plan.** Reconcile with F5's spec §4 (`_process/research/2026-10-05-repository-reconciliation/architecture/mv/F5-MODEL-STATEMENTS.md:83-84`). It says derivation versus connection "reads the Lean and needs nothing declared", and it plans a "named premise on the grammar" from COVERAGE.json's premise register (K3, with witnesses `World.contingent` and `World.independent`). The design declares Y instead, and mentions neither.

**B3. The test "unfolding only" excludes 5 of the 8 cases. Decision: all 8 are derived once the test is restated.**

§1.1 (`:44`) allows only the unfolding of definitions. §3 (`:106`) and the reading (`D/CONNECTED-ROWS-READING.md:47`) say the two `Law` rows are the only induction bridges. In fact five of the eight rely on bridges proved by recursion:
- the `Law` rows: `reaches_iff_orbit` (`L/Recurrence.lean:584`) and `returns_iff_reaches` (`:594`);
- `Tolerance.answers_restores_iff` and `Withholding.withholding_spreads`: `chain_iff_steps`, recursion on `k` through `«迭之末步»` (`L/Withholding.lean:163`, `:171`);
- `WithinMoves.after_course`: `trace_steps` and `trace_iff_steps` (`L/Labelled.lean:936`, `:941`).

I checked `beyond_gives_nothing`, `withinSystem_of_withinInfluence`, both `Law` rows, `goAlike_iff_lumped`, `answers_restores_iff`, `withholding_spreads` and `after_course`. Each applies Y directly: every walk in the table reaches its Y. Each bridge is an equivalence that holds for every instance of the model's parameters, with no added hypothesis. `answers_restores_iff` uses `worst_start` only as instantiation at `allWithheld` (`L/Tolerance.lean:451-455`).

**Fix:** restate the test as "Y at the model's relation, through bridge equivalences that hold for every instance of the model's parameters and add no hypothesis, each bridge named in the record". Correct `:106` and the reading's tally. No "steps" row should be a case, with one exception in M2.

**B4. The "logic" label puts rows below the grammar that their Lean does not support, and no owner has decided it.**

§1.4 (`:68`) says these rows are "definitions unpacked … hold for every carrier". Several are not:
- `ExchangeLaw.response_not_fixed_by_coupling` constructs two exchange laws, `ofClass` and `zero` (`L/PoolResponse.lean:226-236`).
- `Web.significance_undetermined` is a not-entailment by two constant significances (`L/Significance.lean:389-401`).
- `Web.roles_supported`, `roles_dependent` and `roles_alive` are representation lemmas of the one-kind construction `roles` (`L/Roles.lean:189-218`). EC6's category for them is "definitional **or representational**".

All 12 rows carry verified F5 items, at a model or on their own carrier. Lever 2 placed row 4 "at the model already (U2)" (`D/REVIEW-U4-L2.md:20`; `D/LEVER-2-AUDIT.md:34`), and OU decided only for counting (`WR:328`). Moving the 12 makes the record's counts (7 and 4) disagree with F5's (16 and 7), with no mapping between them.

**Fix:** either of these:
- keep the 12 at their F5 standing, flagged "definitional";
- restrict "logic" to `Iff.rfl` and instances of a propositional tautology (`verifiableBy_iff_interior`, `identifies_iff_tracks`, `kernel_and_iff`, `transmits_at_iff`, and the like), and get OU's owner's decision.

Either way, print the record's figures beside F5's four counts. Also say "all 12", not "most" (`:18`, `:68`).

## Minor

**M1. `Listed.coming_of_ceasing` is counting by the design's own definition, not "amounts".** It holds for any carrier, any predicate and any exact listing. Its conclusion names no amount (`L/Population.lean:446-447`, `:609-612`), and its statement unfolds to `Becoming.Prelude`'s `Distinct` and `Init`. It is the same kind of law as `RelativePosition.rise_needs_fall`, which is labelled counting.
- **Fix:** label it counting, or give the test that separates the two.
- Also, rule 4 assigns "amounts" by a fact about the proof, while §0 defines "amounts" by the statement (`:23` against `:84`).
- `balance_over_stretch_on` (`L/Prelude.lean:785`) is rightly called a law of counting: it holds for every `q x y : Nat → Nat`. Say that the split leaves 08 §7's balance column (55) unchanged.

**M2. `Flow.withinCoupling_reads_iff` is not a "form no declaration states yet" (`:111`).** Its two halves are already general closure laws over any relation, declared off the grammar: `WithinClosure.of_reads` and `WithinClosureOf.to_reads` (`L/SelectionPool.lean:559`, `:570`). The row is those two halves, with their hypotheses met by case splits (`:600-608`).
- **Fix:** treat it as `mutuallyDependent_iff_reach` is treated: move both halves to GrammarLaws on HE2's list. It needs no new form.

**M3. The other three grammar-only forms, weighed against §4's own criterion.**
- `presupposition_scopes`: the proposed form is the closure's definition read through `«闭含所闭»`, `«所闭之闭»` and `«所闭之自反»` (`L/GrammarLaws.lean:171`, `:188`, `:206`; compare `«所闭之证»`, `:212`). The grammar does not lack it, so drop it.
- `onLoop_of_closing`: the form is a corollary of three laws (`L/Closing.lean:270-278`). It is new only as a single statement.
- `Branching.loss_passes_juncture`: the only form that is clearly new content. No grammar module states a juncture law (`L/Junctures.lean:132-148`).

**M4. `«所闭之逆»`: "changes nothing else" (`:108`) is wrong.** The row's proof reaches `WithinClosure.converse` (`L/Response.lean:91`), which has its own proof and 10 uses. Declaring the law in GrammarLaws does not make the row reach it.
- **Fix:** re-prove `converse` as one application of `«所闭之逆»` in the same rebuild. That is an edit to Response, by its owner, and it goes on HE2's entry.
- Confirmed: no `«所闭之逆»` or `«及之逆»` exists. Only `«迭之逆»` does (`L/GrammarLaws.lean:876`).

**M5. Finding 2's "All 44 … reach grammar laws" (`:31`) is false under the corrected walk.**
- `Web.Whole.family_excess_ends` reaches only `kept_onward`. That theorem is one of the closure laws GrammarLaws names in its header (`L/GrammarLaws.lean:53`, `:1104`), but it has no «» name.
- The walk files it as a definition and does not expand it (`D/boundary_table.py:156-158`).
- **Fix:** count `kept_onward` as a law, or expand non-«» theorems of the Grammar modules. Otherwise say 43.

**M6. `act_courses_unselected` is not "balance, represented" by the design's own split.** Its statement names no balance. The balance it uses is proved: `course_balances_iff` from `Feasible` (`L/SelectionGap.lean:176-177`). Rule 2 (`:82`; `D/boundary_table.py:166-169`) places it by the proof only because it reaches the grammar, while rule 4 gives non-grammar rows in the same situation "amounts".
- **Fix:** make rule 2 statement-only. This row then becomes connected (steps).

**M7. Lever 2's rows in HAND and §4.**
- **Overstated hypotheses (`D/boundary_table.py:38-49`).**
  - For rows 13 and 14, "every hypothesis witnessed" overstates: the list facts are not witnessed (`D/LEVER-2-AUDIT.md:36`, `:180`, `:270`).
  - "State the gate as grammar inclusions" is wrong for rows 5 and 13. Row 5's hypothesis is an implication on `ComesToStand` and `DescendsAt` (`U4LeverTwo.lean:592`), and row 13's is cancellation.
- **§4's witness list (`:129`)** names `Kept`, which is row 8's witness. It omits the others:
  - `Uninherited`, `Held` and `Standing`;
  - the silent flows;
  - `Lifted.inactive_needed`.
- **Names.** The scratch names `*_on_root` state a wrong meaning under the strict reading. Rename them at landing (AGENTS.md, naming).
- **Label.** "At its model" hides that witnessed forms exist. Give these rows a distinct label.

**M8. The premise standing (§1.3) is right; one option does not fit.** Central declarations are theorems, and the premises are the condition and C (`not_entails`).
- But `not_entails` does not have the shape of a standing-2 countermodel, "every other hypothesis holds, the conclusion fails". So drop the option "standing 2 with `not_entails` as countermodel" (`:64`), or show the shape.
- The free-significance handling of rows 1, 8 and 9 matches WR's "U3's standing" (`WR:296-297`).

**M9. Wording.**
- `:32` says balance enters "one row's proof", but three rows take `Flow` balance only in their proofs.
- `:135` says the leaf "holds the bridges for the cases", while `:122` says the eight need no Lean.

**M10. Order.** MV's field first and the record after GW is right, but MV's spec should wait for B1 and B2's tests. The record should not wait on HE2's rebuild: land `mutuallyDependent_iff_reach` as connected, and update it at the rebuild.
