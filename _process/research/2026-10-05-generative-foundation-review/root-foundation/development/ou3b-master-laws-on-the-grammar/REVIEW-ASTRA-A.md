Read-only review; no files changed and no rebuild. I found no incorrect Lean proposition or broken stated `↔` representation. The main issues are completeness, interpretation, and naming. **A** denotes `GrammarLaws.lean`; **B** denotes `GrammarLawsInstances.lean`.

1. **Overclaim — `B:12`, qualified at B:47.** “Each model anchor” is too broad: `Amounts.rests`, explicitly an anchor in §7, is absent. Moreover, that theorem concludes nonrecurrence of marked steps, `¬ ∀ N, ∃ t ≥ N, P t`; it supplies neither a settling time nor an absorbing region entered from outside. An already stationary course also need not be drawn.
   **Fix:** describe the represented subset explicitly. A rest lifting must retain the amount structure, nonincrease, least-loss and finite-budget hypotheses, and distinguish nonrecurrence from witnessed settling or attraction. Do not close this gap merely by identifying “rest” with `«入»`.

2. **Imprecision — `A:29`, `B:110`.** The near-definitional qualification is honest, but “conservation as a fact about continuation” invites a stronger interpretation. `balances_iff_units` reconstructs repeated `Unit` lists from the numbers and matches them under the universal relation. It preserves the balance equation exactly; it establishes no actual unit trajectories, conditioning relation, or compatibility between successive matchings. For arbitrary `R`, only the matching-to-balance direction is established.
   **Fix:** call this an exact cardinality representation of natural-number balance. State that matching is supplied, not derived from the unfolding. More informative extensions could conserve supplied weights along matched edges or compose compatible matchings; these require additional structure and checked proofs. Arbitrary relations alone supply no stronger conservation law.

3. **Overclaim — `A:6`, `B:25`.** §7’s balance law includes “over every stretch”; the draft provides the one-step representation only. The explanation for not routing `Balances.over` through lists concerns aggregation across conditions, not temporal accumulation. These are distinct omissions.
   **Fix:** qualify the headline as partial coverage, or supply a stretch theorem with its representation. Reusing arithmetic telescoping is legitimate; forcing it through list matching is unnecessary. Record explicitly which part remains arithmetic and which part has been lifted.

4. **Suggestion — `B:259`.** The `GoAlikeUnder` representation is exact without extra hypotheses. However, §7’s substantive wording—“a part read alone carries a law exactly where the rest makes no difference”—also calls for the connection to a determined image/factor process. The draft stops at preservation of the pulled-back relation and equal-length futures.
   **Fix:** connect explicitly to `Mechanism.image_determined_iff` or `carries_law_iff`, ideally through a grammar-level relational-image statement. Specify that the resulting law may be partial; do not silently add totality or construct an executable successor function.

5. **Imprecision — `A:579`.** The lumping bridges have sufficient, but not minimal, hypotheses. At A:589, global totality is used only to obtain a successor of `u'` when `E u u'` and `R u v`. It can be replaced by the corresponding local availability condition. At A:580, uniqueness is used only at those second-source occurrences.
   **Fix:** retain the convenient global corollaries, but add locally scoped versions or qualify “only what it uses.” The availability condition is necessary under `«有常»` and, together with `«同行»`, gives its converse; this offers a sharper account of the precise gap.

6. **Imprecision — `A:138`.** `«所闭当且仅当及»` does not mean exactly its statement: closure is equivalent to **equality or** positive reach, not `«及»` alone. The distinction matters at an isolated occurrence, where self-closure holds without positive self-reach.
   **Fix:** rename it to include equality explicitly, such as `«所闭当且仅当同一或及»`. The docstring and proof already state the correct result.

7. **Imprecision — `A:477`, also A:39.** `«不定后则入而返»` reads as an implication from nonfunctionality, but proves an existential counterexample. Nonfunctionality does not generally produce both drawing and returning. The witness correctly shows that functionality cannot simply be deleted from the general theorem; it does not characterize functionality as necessary for every relation satisfying the equivalence.
   **Fix:** use an explicitly existential name, such as `«入而返之例»`, and replace “needed” with “cannot be omitted in general.” The no-successor lemma correctly identifies the separate failure of the reverse direction.

8. **Suggestion — `A:523`.** The finite recurrence theorem is sound and usefully drops functionality, but listing the entire carrier and requiring totality everywhere are stronger than the argument needs for one starting occurrence. The proof uses a sufficiently long finite path, a list containing its visited occurrences, and predecessor cancellation along it.
   **Fix:** expose that local path lemma, retaining the current theorem as its global corollary. This makes “only what it uses” more informative and accommodates finite invariant regions inside infinite carriers.

The remaining principal names fit their definitions: `«对»` matches **positions**, `«定后»`/`«定前»` express **at-most-one**, `«迭»` fixes length, and `«广»`/`«逾»` correctly retain positive witnesses. `«入»` must remain existential—possible entry into a closed region, not inevitable entry along every branch.

── cx · ok · session 01a173bf-4916-7d11-af63-cb3b63caaaba · gpt-6-astra/high · read-only · 340s · 911.5k tokens · 14 cmds
continue: cx -r 01a173bf-4916-7d11-af63-cb3b63caaaba "…"
log: /Users/ren/.cache/cx/runs/20261025-234757-99390
