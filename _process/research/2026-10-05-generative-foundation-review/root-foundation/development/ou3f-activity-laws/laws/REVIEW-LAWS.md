# OU3f, laws of steps: independent read-only review

One review, 29 October 2026, by a separate AI agent working read-only, the reviewer of OU3f's audit. It edited no file in the repository. It compiled `steps_advance` and the new `reaches_onward` over main's `MapInstances` in scratch, with the two laws copied verbatim; the check is kept in `checks/`. It read the tree and [DESIGN.md](DESIGN.md) as they stood before its findings were taken; what was taken is in DESIGN.md, *The review, and what was taken*. The findings are reproduced below as the reviewer gave them, lightly formatted.

## Findings, most serious first

1. **The header overclaims.** "The models' step-indexed laws are proved from the laws of steps counted:" reads as complete. But the lineage laws (`Lineage.split`, `through`, `onward`, `back`, `unique`, `origin`) wait for the third part. The removed *What is not shown* clause was stale and right to go, but nothing replaces it. Fix: write "Three of the models' step-indexed laws …", and add to *What is not shown* that the lineage laws do not yet follow from these laws.
2. **`«迭之分»`'s docstring says more than the law.** "Its case `a = n`, `b = 1` is `«迭之末步»`" is inaccurate. That case gives `«迭» R (1 + n) x z → ∃ y, «迭» R n x y ∧ «迭» R 1 y z`:
   - the count is `1 + n`, not `n + 1`;
   - the last step is `«迭» R 1`, not `R`;
   - the law runs one way, while `«迭之末步»` is an equivalence.

   The design note's table repeats the claim. Fix: say it gives `«迭之末步»`'s forward direction, up to `1 + n = n + 1` and reading one step as `R`, or drop the sentence.
3. **`«迭则所及»` is stated as a special case only.**
   - It holds only for a line's continuation `«续» R E`, but the general law `«迭» R n x y → x = y ∨ «及» R x y`, for any `R`, is the same two-case split.
   - `«迭则所及»` is exactly that law at `«续» R E`, by definition: `«所及» R E x y` is `x = y ∨ «相续» R E x y`, and `«相续» R E` is `«及» («续» R E)`.
   - The general form also gives the unbounded B2 its promised one line, through `«所闭当且仅当同一或及»`.

   Rule 9 favours stating the general law and taking `«迭则所及»` from it. This is optional, a support law.
4. **`«或有后则或迭»`'s docstring claims a calibration.** "The double negation is the exact strength" is a sharpness claim nothing proves. Rephrase it as an explanation: the conclusion is a double negation because the successor is given only as far as can be refuted.

## The questions, answered

1. **Statements and minimality.**
   - **The five laws:** right and constructive, matching what the reviewer compiled in the previous review, with `«迭则所及»` added. The set is close to minimal; finding 3 is a free generalization.
   - **B1:** in `«迭之接»`'s order it needs no arithmetic, and `split`'s `j + i` is one `Nat.add_comm` rewrite.
   - **B2:** `onward` and `back` need only the bounded form; `back` takes it on the converse through `«迭之逆»`, with `steps_advance` for the times.
   - **Note for part three, `split` and `through`:**
     - `steps_advance` accepts any `E`, so write the restricted step as `«续» (continuationStep R) E_N`, with `E_N x y := activityClass x y ∧ N ≤ x.1 ∧ active x.1 x.2`. Then `steps_advance` fixes the step of B1's middle point.
     - Stating the bridge for any bound `N ≤ M` lets the second half be read from `M + j` with no re-restriction.
2. **`reaches_onward`: genuine.**
   - `«不穷则迭»` replaces the induction's successor-taking, and the step index stays web-side in `steps_advance`; no converse undoes the law. It has the same shape as OU3e's `after_course`.
   - `steps_advance` and the new proof compile over main's `MapInstances`, both with empty axiom reports, and an `example` confirms the statement is the real one.
   - `Nat.succ_add` has an empty axiom report, by probe; the core already uses it in `Lineage.cons`.
   - **Who rests on it:** five of the 436 rest on `reaches_onward`, as the design says, and so does `includesAcrossFrom_iff_endless` in KeepingWidening, outside the count.
3. **Names: apt.**
   - `分` pairs with `接`, with no clash with `«分叉»`.
   - `«迭之逆»` uses the grammar's converse.
   - The leading `或` is modal, as in `«或屡»`. The grammar's `«有后»` takes a class while the law has a plain successor; that is acceptable as a reading.
   - `«迭则所及»`, `«不穷则迭»` and `steps_advance` follow `«迭则及»`, `«不穷则延»` and `line_advances`. None of the six names occurs elsewhere in main.
4. **Header and docstrings:** findings 1, 2 and 4. The other docstrings say what their proofs show.

## Verdict (the reviewer's)

Ready to land once findings 1, 2 and 4 are fixed; finding 3 is optional.
