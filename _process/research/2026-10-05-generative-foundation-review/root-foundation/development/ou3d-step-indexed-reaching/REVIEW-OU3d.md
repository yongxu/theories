# OU3d: independent read-only review

One review, by a separate AI agent working read-only (no file in the repository edited; builds ran in scratch trees), 28 October 2026. It covered the scratch tree of `GrammarLaws`, [DESIGN.md](DESIGN.md) and the bridge check, as they stood before its findings were taken. What was taken is in DESIGN.md, *The review, and what was taken*. The findings are reproduced below as the reviewer gave them, lightly formatted, and use the names as they stood then.

## Findings, most serious first

1. **`«或静»` reads wrongly against the module's own `«或屡»`.** In the same section, `«或屡»` uses a leading 或 to mean "as far as can be refuted" (`¬¬`). By that convention `«或静»` reads "stays, as far as can be refuted", which is not `x = y ∨ R x y`, and the step disappears from the name. Fix: put 或 between the two terms, as `«所闭当且仅当同一或及»` already does, and use 缘 for a step, as `«缘在所闭»` does. That gives `«静或缘»` and `«迭内即静或缘之迭»`, with the table row and the bullet updated to match.
2. **`«迭内之接»`'s bound order, `n + m`.** It follows `«迭之接»`, but there the order is forced: `b + (a+1)` reduces to `succ (b + a)`. `«迭内»`'s bound is an inequality, so its order is free, and the brief and WHAT-REMAINS both say "within *m* + *n*". The consumers also run the other way: `Chain.append` gives `i + j`, and `WithinMoves.after_course` gives `xs.length + n`. In the reviewer's check, `after_course` from the current statement needed `Eq.subst … (Nat.add_comm n xs.length)`, and from an `m + n` statement nothing. Fix: conclude `«迭内» R (m + n) x z` by `⟨j + k, Nat.le_trans (Nat.add_le_add le' le) (Nat.le_of_eq (Nat.add_comm n m)), «迭之接» k j first second⟩` (axiom-free, verified). Do it before landing, since afterwards it changes a statement the consumers use.
3. **In `«守承之迭»`, 守 is already a defined term.** `GrammarMap`, which GrammarLaws imports, defines `«守»` as keeping: going on along some branch with no carrying renewal. `«守则延»` and `«守退化不并»` use it as that term, so `«守承»` parses as `«守»` plus `«承»`. GrammarLaws also has `«守数…»`. The design note's claim that `«守»` occurs only in `«守理…»` is false. Fix: use a character no name uses, such as `«存承之迭»`, or keep 守 and correct the note's reason.
4. **`«迭之末»` should be `«迭之末步»`.** The grammar uses 末 alone for the last place (`«定后于线有限则末返»`, `«相续之末有前»`) and 末步 for the last step (`«相续之末步»`, `«有亡之线末步离核»`). `«相续之末步»` in GrammarRegularity is the same decomposition for lines. The note's "no equivalent in the core" holds only for `«迭»`; the docstring could cite `«相续之末步»` as precedent.
5. **The header says more than the module shows.**
   - "What is not shown" lists "a law's run to a course of regions" as a pending bridge. But a run already is such a course, with rounds by `Iff.rfl` (verified on the real `Law.run`, and the design note's own point 1). Drop it.
   - "These are the closed forms of `Withholding`'s two laws … stated before any consumer bridges to them (board item OU3d)" claims a correspondence the landed code does not prove, and its process clause will go stale. Suggested: "`Withholding`'s closed forms (`answers_closed`, `waitsAll_closed`) have these shapes for its chains; the bridges are not shown (below)."
   - The intro's "finite runs (return, being drawn and rest)" should also name "steps counted".
6. **Nits.**
   - `«承»`: "one with none takes on anything" would read better as "one with no condition lies in it for every region".
   - `«承之迭»`'s docstring sentence is hard to parse; "in exactly `n` steps" would set it apart from "within".
   - The new "What is not shown" line beginning "(their chains and traces…" was not rewrapped.
   - In the throwaway check, `steps_then_within`'s docstring says `k + n` while its type says `n + k`.

## Missing or unnecessary

- Nothing the brief or the three consumer rows need is missing. "Exactly *k*, then within *n*" is `⟨k, Nat.le_refl k, steps⟩` passed to `«迭内之接»`, so no separate law is needed.
- Two optional additions, both compiling axiom-free:
  - monotonicity of `«迭内»`, which matters only if `Within` is redefined from it (`withholding_absorbs` uses `Within.mono`);
  - `«所闭» R x y ↔ ∃ n, «迭» R n x y`, with its memory corollary `(∀ n, S n a) ↔ «承» («所闭» R) (S 0) a`, which no consumer needs.
- Nothing is unnecessary. `«或静»` and `«迭内即或静之迭»` carry the rule-9 derivation, and `«迭之末»` carries `«承之迭»` and the `Chain` bridge.

## Checked and found holding

- **Diff.** The change is additions only, after `«迭之周»`, plus the header edits. No existing declaration changed, and the bridge check's copy differs from the tree only in header text.
- **Faithfulness.** `«承之迭»` is the brief's exactly-*n* law with no memory, and `«守承之迭»` its within-*n* law with memory. The memory law comes from the general one at `«或静» R` with no second induction, as rule 9 asks.
- **Stating it for any course `S` is faithful,** and more general than an iterate. An iterate meets the round by `Iff.rfl`, so does any pointwise-equivalent course, and neither a second orbit nor extensionality is needed.
- **Against the real consumers.** A module importing the real `Withholding`, `Tolerance` and `Labelled`, with the new block copied verbatim, re-proved:
  - the real `answers_closed` and `waitsAll_closed`, with rounds `fun _ _ => Iff.rfl` and `R` inferred (an `example` confirms each statement matches the real one);
  - `withholding_spreads` and `answers_restores_iff`;
  - `chain_iff` and `within_iff` (via `Chain.zero_eq` and `Chain.last`);
  - `Trace` ↔ `«迭» (Steps P)` in both directions, and `WithinMoves` ↔ `«迭内»`;
  - `after_course`.

  All 23 declarations had no axioms and no warnings.
- **Axioms.** A fresh build from an empty cache (Prelude, Grammar, GrammarMap, GrammarLaws) gave 120 theorems in 143 declarations, all with empty axiom reports. The audit covers all eight new names, and their generated matchers are axiom-free too. The block uses no `simp`, `omega` or `decide`, and its `Nat` case splits sit inside `∃`, not on an indexed family. The closure imports no `Std`, so the prelude-only compile is the same build.
- **Names and claims.** None of the eight names occurs elsewhere in the package. `«迭»` is used only in GrammarLaws, Recurrence and Learning, as claimed. Statements are pointwise, docstrings match their proofs, there are no exchange words, and other module docs already cite board items.

## Verdict (the reviewer's)

Not ready to land, but close. Rename `«或静»` and settle `«迭内之接»`'s bound order before landing, since both cost more to change once consumers bridge, and fix the header in the same pass. Findings 3 and 4 are advisable. None of this needs a new proof idea.

## Second pass: the re-proof of `PartForms.goAlike`

The same reviewer, under the same rules (read-only), checked a re-proof of `PartForms.goAlike` (`MoveFormation`) through the image law, at the time proposed for OU3d's landing. Its findings follow, lightly formatted. They were taken: the re-proof is not landed, and the row has its reason instead (DESIGN.md, *And the part's own law*).

1. **It is a rerouting, not a genuine instance.**
   - The inner term is main's proof word for word, wrapped in `to.symm.trans (…).trans to'` with `same := at_k.trans at_k'.symm`.
   - That wrapper is `«像定后当且仅当同行»`'s `.mpr` direction, with main's proof in place of `«同行之逐点».mp alike`.
   - So the proof is `image_determined_iff.mp (image_determined_iff.mpr main)`, with the `.mpr` written out by hand. The reviewer compiled that form to confirm.
   - The law is applied and then undone, and no part of main's proof is replaced. That fails EC6's test that a derivation replace part of the proof by the law.
   - `goAlike_iff_lumped` differs: its statement is the image law read through two lemmas stated apart, so the law is its whole content.

   Here the content is the model's premise: `P` is determined at a move the part forms. The image law is how the conclusion reads as "carries a law of its own", through `carries_law_iff`, as main's header says. It is not why the conclusion holds.

   The reviewer agreed that `«有常定后则同行»` does not apply either:
   - constancy needs a coupled step from every joint configuration sharing a stepping one's part, so the rest must step;
   - the fixed successor needs `Q` determined, since `coupled_determined` uses both laws;
   - the local form still needs a fixed successor everywhere, since sameness of part is reflexive.

   So the line in EC6d's study saying that the proof is constancy with a fixed successor is inaccurate. **Recommendation:** keep main's proof and header sentence, and close the measure's pending entry with a reason: a law of its model, read as carrying a law through `carries_law_iff`.
2. **The new docstring overstated.** "being the part's law at a move the part alone forms" should be "lying within", since an image step needs the rest to step too. The new header sentence dropped main's `carries_law_iff` link.
3. **No axiom or elaboration risk.**
   - An independent recompile of `MoveFormation` produced a byte-identical `.olean`.
   - It had 55 theorems in 78 declarations, all with empty axiom reports, including the generated matcher.
   - The statement was unchanged, so `parts_agree` and the importers were unaffected.
