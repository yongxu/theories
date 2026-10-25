> **Superseded** (26 October 2026) by [OU3b2-NOTES](OU3b2-NOTES.md) and [AUDIT](AUDIT.md). These notes describe the first draft: module B (`Becoming.GrammarLawsInstances`), the `_by_grammar` copies and the old names, none of which remain in `tree/`. Kept unmoved as evidence of the draft.

# OU3b draft notes: the five master laws on the grammar

AI-written drafting notes, 25 October 2026, for board item OU3b ([design](DESIGN.md)). Scratch only: nothing outside this folder was edited, nothing committed, the board untouched.

## Files

- `tree/Becoming/GrammarLaws.lean` (module A, `Becoming.GrammarLaws`): imports only `Becoming.Grammar`. The five laws, for every carrier and relation.
- `tree/Becoming/GrammarLawsInstances.lean` (module B, `Becoming.GrammarLawsInstances`): imports A, `GrammarMap`, `GrammarRegularity`, `Flow`, `Attraction`, `Branching`, `Regions`. Representation theorems and the rule-9 derivations.
- `OU3bCheck.lean.txt`: the correspondence check. It was run as a module in a scratchpad tree and is kept here as text so that it is not taken for part of the tree. It has 14 `example`s, each `@original = @original_by_grammar := rfl`; by proof irrelevance these hold only if the two statements are identical.
- `scratch.log`: the final build and audit output.

## Counts

| module | theorems | declarations | axiom reports |
|---|---:|---:|---|
| `Becoming.GrammarLaws` | 77 | 91 | all empty |
| `Becoming.GrammarLawsInstances` | 38 | 39 | all empty |

Per section of A (declarations / theorems): closure 16/14, list helpers 15/13, balance 10/9, finite runs 25/21, lumping 8/7, order 17/13. Per section of B: closure 6/6, balance 2/2, finite runs 14/14, lumping 6/6, order 11/10.

Build: from `experiments/integrated-correction/general-framework/generative-basis/lean/becoming`, `python3 -B scratch_build.py <this folder>/tree Becoming.GrammarLaws Becoming.GrammarLawsInstances`. It compiles 96 modules (the two new ones ran clean on their first passing run, so later runs reuse them), lists nothing as unclean, and reports `with_axioms: {}` for both modules. The correspondence check compiled clean too (112 modules), with an empty report.

## Law by law

### 1. Closure

- **Lifted (A).** `«闭» R P` is a closed region and `«所闭» R x y` the least closed region holding `x`. Their laws: `«所闭之自反»`, `«所闭之传递»`, `«缘在所闭»` (of a step), `«所闭之闭»`, `«所闭之单调»`, `«所闭之对称»` (for `«则» R («逆» R)`), `«所闭之界»` (nothing within bears `R` beyond), `«闭含所闭»`, `«所闭之证»` (the certificate in `closure_iff_certified`'s form), `«闭而外则不所闭»`, `«闭之及»`, `«及之所闭»`. The main equivalence is `«所闭当且仅当及»`: `«所闭» R x y ↔ x = y ∨ «及» R x y`. Also `«及当且仅当一步而所闭»`.
- **Design change.** `«所及»` is defined in `GrammarMap`, not `Grammar`, so A states the closure as `x = y ∨ «及» R x y`. B links the two with `eq_or_reach_iff_reached` (`↔ «所及» R «一» x y`).
- **Representation (B), both ways, no hypothesis.** `closedUnder_iff_closed` and `withinClosure_iff_within` hold by `Iff.rfl`: the model definitions are the grammar's word for word. `reach_iff_within` reads a process's `Reach` as `«所闭» (Steps P)`.
- **Rule 9.** `withinClosure_iff_reached_by_grammar` and `closure_iff_certified_by_grammar` are proved from A, and each has the original's exact statement (checked). Making `Frame` define `WithinClosure` as `«所闭»` is OU3b-2.

### 2. Balance

- **Formulation.** `«对» R a b` is an inductive perfect matching of places. `nil` pairs `[]` with `[]`. `cons` pairs the head `x` of the first list with some place `y` of the second (`b₁ ++ y :: b₂`), where `R x y` holds and the rests are matched. It is constructive, needs no decidability, and is the "explicit matching witness" the brief allowed.
- **Lifted (A).** `«对之长»`: matched lists have equal length. `«一之对»`: under `«一»`, a matching exists exactly for equal lengths. `«对之单调»`, `«对之自反»` (for a reflexive `R`), and `«对之逆»` (a matching read backward under `«逆» R`, via `«对之左插»`). `«对则守数»`: a matching of `before ++ given` onto `after ++ taken` gives `after.length + taken.length = before.length + given.length`. `«守数当且仅当可对»`: four numbers satisfy `r + s = p + q` exactly where lists of units of those lengths are matched under `«一»`.
- **Representation (B).** `Flow.balances_iff_units` holds both ways with no hypothesis: `L.Balances W` exactly where, at every `t` and `c`, unit lists of lengths `level t c`, `given t c`, `level (t+1) c` and `taken t c` are matched under `«一»`. `Flow.balances_of_continued` gives the ← direction for every carrier and every relation.
- **Honest scope.** As DESIGN says, this is near-definitional. It reads conservation as continuation; it adds no fact about amounts.
- **Not done.** Composition of matchings (`«对» R a b → «对» S b c → «对» («而» R S) a c`) needs list-splitting inversions and is not proved. Neither is append.
- **Rule 9 not applied.** `Flow.Balances.over` is the arithmetic of totals over a family, and routing it through lists would only raise the measure, so it is not derived.

### 3. Finite runs

- **(i) Design change: the stated law is false for general relations.** "For every relation, an occurrence with a successor is drawn exactly where it does not reach itself" fails. `«不定后则入而返»` is a counterexample: on `Bool` with `R a _ := a = false`, `false` reaches itself and is drawn into `{true}`. What holds:
  - For every relation, `«入当且仅当有不返»`: `«入» R x ↔ ∃ y, «及» R x y ∧ ¬ «及» R y x`. `«入»` (drawn in) uses the reached form, matching the model's `DrawnInto`: some closed region outside `x` holds something `x` reaches. The successor form, "holds a successor of `x`", differs from it for general relations and agrees with it for functional ones.
  - For every relation, `«有后不返则入»`: a successor and no self-reach give drawn.
  - With a fixed successor (`«定后» R`, `R˘;R ⊆ 静`), `«定后则返者不入»`: self-reach gives not drawn. The lemma `«环则所及皆返»` shows that everything on a loop reaches back.
  - Hence `«入当且仅当不返»` under a fixed successor plus some successor. Both directions are constructive. `«无后者不入亦不返»` shows the successor hypothesis is needed.
- **(ii) Lifted.** `«定前» R` (`R;R˘ ⊆ 静`) means nothing merged. `«有限定前则皆返»`: a listed carrier, a successor everywhere and nothing merged give every `x` reaching itself. The proof is pigeonhole with no decidability, along a line built from totality inside a `Prop` proof, then cancelling back along it. No `DecidableEq`, no choice, and no functionality is needed. `«皆返定后则定前»`: a fixed successor and every `x` reaching itself give nothing merged, by a common multiple of the two loop lengths through the shared successor (`«迭»`, `«迭之周»`, `«迭之定»`). Totality and the list are not needed for it. `«有限定前当且仅当皆返»` combines the two.
- **Lists in A.** Pigeonhole (`GrammarLaws.revisits_within` and its helpers) is restated in A, because `Recurrence` lies above `Frame` and A must sit below the models. The proof is Recurrence's, renamed into namespace `Becoming.GrammarLaws` to avoid clashes. A rule-9 refactor (OU3b-2) could have `Recurrence` use it.
- **Representation (B), no hypothesis.** The law's relation is `fun x y => next x = y`, with `Law.next_fixed` and `Law.next_total`. The equivalences are `Law.absorbing_iff_closed`, `Law.reaches_iff_orbit`, `Law.returns_iff_reaches` (`Returns next s ↔ «及» R s s`), `Law.drawn_iff_drawnIn` (`Drawn next s ↔ «入» R s`) and `Law.lossless_iff_fixedBefore`. For every process, `Branching.returns_iff_reaches` (along `Steps P`) and `Branching.lossless_iff_fixedBefore` hold.
- **Rule 9.** `Law.drawn_iff_not_returns_by_grammar`, `Law.lossless_iff_returns_by_grammar` and `RecurrenceRuns.lossless_iff_returns_by_grammar` are derived, each with the original's exact statement. A new consequence also follows: `Branching.Lossless.returns_of_total_by_grammar`. For every process that merges nothing, has a step from each configuration and has a list holding them, every configuration returns. Totality replaces the run that `Branching.Lossless.returns` takes as input.
- **Not done.** `Amounts.rests` ("rest is a case of being drawn", listed in 08 §7's anchors) is not represented.

### 4. Lumping

- **Lifted (A).** `«同行» R E := «则» («而» («而» («逆» R) E) R) E`, with `«同行之逐点»`. The links to `«有常»` (orientation checked: `E˘;R ⊆ R;E˘`): `«有常定后则同行»` (a fixed successor), `«同行遍后则有常»` (a successor everywhere), `«同行当且仅当有常»` (both), and `«类同行遍后则含于核»`. Lines: `«迭» R n` is n-fold composition, and `«同行之迭»` says E-alike occurrences go, by `n` steps, to E-alike occurrences. `«同行于迭»` follows.
- **Design change.** The lines law needs no reflexivity of `E`, so the hypothesis was dropped. It is stated for lines of equal length (`«迭»`), not for `«及»`, which fixes no length.
- **Representation (B), both ways, no hypothesis.** `goAlikeUnder_iff_alike`: `GoAlikeUnder P π E ↔ ∀ a, «同行» (moveRel P a) (fun s s' => E (π s) (π s'))`.
- **Rule 9.** `constant_of_goAlike_by_grammar`, `goAlike_of_constant_by_grammar` (via `moveRel_fixed`) and `Law.sameFuture_of_goAlike_by_grammar` (via `Law.steps_orbit`) are derived, each with the original's exact statement.

### 5. Order

- **Design change: widening uses a positive witness.** `«广» R S := «则» S R ∧ «逾» R S`, where `«逾» R S := ∃ x y, R x y ∧ ¬ S x y`. The brief's form `¬ «则» R S` is weaker constructively, while `Web.Widens` uses a positive witness (`Exceeds`), so the exact representation needs `«逾»`. The brief's form follows (`«广则不则»`).
- **Lifted (A).** `«广非自»` (irreflexive), `«广不可逆»` (asymmetric), `«广之传递»`, `«齐»` (both inclusions, `«齐即谓»`), `«杂»` (each exceeds), their symmetries, and the exclusions `«广则非齐»`, `«广则非杂»`, `«齐则非杂»`. `«四比之周»`: given decisions both ways, exactly one of the four cases holds. `«则逾之定当且仅当排中»`: deciding inclusion against exceeding for every pair on every carrier is exactly excluded middle, so the partition is as far as constructive logic goes.
- **Representation (B), both ways, no hypothesis.** `Web.admitted W l : «际» (Nat × F)` is the identity at admitted (step, formation) pairs. A homogeneous relation is needed because admission relates steps to formations, and this encoding is a choice the record should name. The equivalences are `Web.includes_iff`, `exceeds_iff`, `widens_iff`, `keeps_iff` and `mixed_iff`.
- **Rule 9.** `Widens.not_reverse_by_grammar`, `Widens.trans_by_grammar`, `Widens.not_keeps_by_grammar`, `Widens.not_mixed_by_grammar` and `Keeps.not_mixed_by_grammar` are derived, each with the original's exact statement.

## Not done here

- DESIGN item 4: the connectivity measure before and after. Another session's `measure_grammar.py` and `baseline.json` appeared in this folder and were not touched.
- The OU3b-2 refactors of shared modules.
- A record, the board, and landing.
