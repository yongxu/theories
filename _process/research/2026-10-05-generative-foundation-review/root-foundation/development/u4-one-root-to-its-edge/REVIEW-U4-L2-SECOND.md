# U4 lever 2: second read of the post-review delta (§10, with §0, §1, §7, §8)

Checkout `wt-l2-read` at `dd95616d9`; delta `b23261cc5..dd95616d9`. Paths below are relative to
`_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u4-one-root-to-its-edge/`.

## Verdict

**Sound with fixes.** Every witness that was built does what §10 says. For each one, the named hypothesis fails, every other hypothesis of the row holds as a Lean theorem (with one exception, M1, which holds by `rfl`), and the row's conclusion fails. The Lean has no defect. The completeness claim is wrong, though: two hypotheses have no witness (B1).

## Findings

### B1, blocking: "every hypothesis witnessed" is false for two hypotheses

- **Row 8.** `SelectionTerm.Flow.support_moved_rises` has the hypothesis `moved : G.size 0 * G.sum T ≠ G.size T * G.sum 0` (package `Becoming/SelectionTerm.lean:682`).
  - `LowGives`, `TopMissed` and `Lowered` all prove `moved` holds. No world drops it.
- **Row 17.** `GroupEnding.Flow.all_end` has the hypothesis `inactive : ∀ p, p ∈ G.family t → ¬ W.active t p` (`Becoming/GroupEnding.lean:377`).
  - `Ungated` and `Ungated.silent` drop only the gate and descent.
- **Where the claim is made:**
  - LEVER-2-AUDIT.md l.7, l.34 and l.50 say "every hypothesis … but the list facts".
  - l.35 says "Every hypothesis has its witness" for rows 1, 2, 3, 7, 8.
  - l.65, row 8, says "with the same witnesses".
  - §7 (l.177–178) does not list these two as not done.
  - The scratch module docstring, `U4LeverTwo.lean:42–45`, says the same of "rows 7 and 8".
- **Fix.** Either add the two witnesses or narrow the claim to say that these two are not covered. Both witnesses are small, and I checked both in Lean (`Check.lean`, see below):
  - **`moved`, row 8.** Use `Lowered`'s world at `T = 0`. `acting`, `dependent`, `descended` and `top` are `Lowered`'s theorems. `exact` holds vacuously for `t < 0`. `moved` fails (`x ≠ x`), and the conclusion fails (`x < x`).
  - **`inactive`, row 17.** Use `Lifted`'s world. `Lifted.acting` and `Lifted.descended` hold, and member `0` is active. `GroupEnding.Flow.all_end` would then give `size 1 = 0`, but the size is `1`.

### S1, should fix: §8's witness line is false for `Standing`

- **Where:** LEVER-2-AUDIT.md l.193 says "with every level equal to the step. Each relatum then comes to stand at the first step and at no other."
- **What is wrong:** `Standing.web` has `level _ _ := 1` (`U4LeverTwo.lean:1422`). Nothing comes to stand in it, and that is its point.
- **Fix:** add "except `Standing`, whose levels are constantly one, so nothing comes to stand".

### Minor

- **M1. Row 2's offspring dependence in `NeedOverLevel` has no theorem.**
  - **Where:** l.216 cites `depends` as "dependence", but `depends` (`U4LeverTwo.lean:732`) is the parents' dependence at step 0. Row 2 needs `(web act).requires (0 + 1) 1 2`, and the same holds in the `silent` world.
  - It holds by `rfl`; I supplied it that way.
  - **Fix:** add `theorem offspring_depends (act : Bool) : (web act).requires (0 + 1) 1 2 := rfl` and cite it.
- **M2. The per-step forms are not stated.**
  - **What is wrong:** the witnesses refute the forms over all steps (`¬ L.Acting W`, `¬ Descended`). The standing-2 statements `rises_iff_inactive_on_root` and `size_zero_of_within` take the inclusions at one step `t`. The witnesses' cancellation for row 14 comes from `cancel_of_exact`.
  - The failures at `t = 0` do follow. I derived them in Lean through the on-root theorems. They are just not stated.
  - **Fix:** a sentence in §10, or state the per-step negations.
- **M3. "`rising` is reflexive and transitive, not a class" is only asserted.**
  - **Where:** l.231 and `U4LeverTwo.lean:633`.
  - It is true; I checked both parts in two lines.
  - **Fix:** add the lemma, or drop the parenthesis.
- **M4. Two occurrence-model details.**
  - **Duplicate definition:** `activeOcc` (`U4LeverTwo.lean:662`) repeats the body of U2's `ModelStatements.activeAt`. Reusing U2's definition would make l.233's "both parts in that form" literal, with one region.
  - **Unlisted modelling choice:** `givingOcc` places giving within the giving step, `(t, g) → (t, x)`, although the recipient stands at `t + 1`. §8 does not list this choice. The iff is unaffected.

## What I checked and found right

- **Build.** I ran `scratch_build.py` on the scratch tree: 51 modules, 52 steps reused from the content-keyed shared cache, `ran: []`, `unclean: []`.
  - `Becoming.U4LeverTwo`: **173 theorems in 236 declarations, `with_axioms` empty.** This matches the header and the log.
  - The checkout is clean afterwards (`.build/` is ignored).
- **Each witness against the package row itself.**
  - I wrote `/private/tmp/claude-501/-Users-ren-theories/a1748b36-1177-4857-afe2-0d9f0c541556/scratchpad/l2-second/Check.lean`, which has 41 `example`s. It compiles with no errors against the checkout's oleans.
  - Each example applies the package theorem itself to the witness's other-hypothesis theorems and contradicts the witness's `fails`. This machine-checks that each "holds" is proved at exactly the row's type, and that `fails` negates exactly the row's conclusion.
  - It covers:
    - rows 1 and 3: `NeedOverLevel` with both values of `act`, `Undepending`, `NeedOverLevel.silent`;
    - row 2: `NeedOverLevel`, `Untransmitted`, `Undependent`, `NeedOverLevel.silent`;
    - rows 7 and 8: `LowGives` with both values of `act`, `TopMissed`, `Lowered`, `LowGives.silent`;
    - row 14, in both the package form and the on-root form: `EndsAmong` with both values of `act`, `EndsAmong.silent`, `Lifted`;
    - row 17, in the package form and `size_zero_of_within`: `Ungated`, `Ungated.silent`;
    - row 5 on the root: `Uninherited`, `Held`, `Standing`.
  - No witness has a second failing hypothesis.
- **Numbers in the prose,** checked by `#eval`:
  - `EndsAmong`: concordance among the groups 1, discordance 13, and the mean goes from 3/3 to 2/6.
  - `LowGives` and `TopMissed`: the mean goes from 1/2 to 0.
  - `Lowered`: the mean goes from 1 to 0.
  - `Lifted`: raised 1, lowered 0.
- **The inclusion forms.**
  - `unlowered_iff_within` is `lowered ps kids a b = 0 ↔ «则» (descent ps kids) (rising (trait a b))`, with `rising f u v := f u ≤ f v`. That is the one-sided form of `exact_iff_within`, as §10 says.
  - `unlowered_at_iff` is row 7's `loweredAt t = 0` at one generation.
  - `acting_iff_occurrences` is `L.Acting W ↔ «则» (givingOcc L) («而» (Web.partialIdentity (activeOcc W)) (givingOcc L))`. That is the shape of U2's `dependent_iff`: a partial identity of activity composed with a relation `withinStep` on `Nat × X`.
  - All three have empty axiom reports.
- **§10's stated limit** (l.255–257) is present and accurate: one hypothesis is dropped at a time, and the list facts of rows 13 and 14 are excluded.
- **Other changed lines.** The §0 and §1 cells for rows 1, 2, 3, 5, 7 and 14 match what was built.
