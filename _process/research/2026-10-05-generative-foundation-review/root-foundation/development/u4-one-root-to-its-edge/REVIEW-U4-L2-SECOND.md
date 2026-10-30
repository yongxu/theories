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
  - I wrote a check file, `l2-second/Check.lean` in the reader's scratch space (not kept: its examples were adapted into [U4LeverTwoCheck.lean](lever-2-scratch/Becoming/U4LeverTwoCheck.lean)), which has 41 `example`s. It compiles with no errors against the checkout's oleans.
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

## Recheck of the fixes (commit `0b39bc2d7`)

**Verdict: the fixes are sound.** B1, S1 and M1–M4 are each taken as the §10 table says. Nothing is blocking. Two minor wording points are left; neither changes a claim about the witnesses.

**What I checked:**

1. **Build.** I ran `scratch_build.py <lever-2-scratch> Becoming.U4LeverTwo Becoming.U4LeverTwoCheck`: `ran: []`, 140 steps reused, `unclean: []`.
   - `Becoming.U4LeverTwo` has **190 theorems in 253 declarations**.
   - `Becoming.U4LeverTwoCheck` has **2 theorems in 2 declarations**.
   - `with_axioms` is empty for both. The module has 48 `example`s, matching the header.
2. **`Kept`, row 8.** The world uses `Lowered`'s web and flow, `amount _ _ := 1`, and `T = 1`.
   - `Lowered.acting`, `Lowered.dependent`, `Kept.descended`, `Kept.top` and `Kept.exact` hold.
   - Exactness holds over a real step of descent, not vacuously.
   - `Kept.not_moved` holds: sizes and sums are (1, 1, 1, 1) by `#eval`. `Kept.not_rises` holds.
   - `moved_needed` applies the package `support_moved_rises` to these five theorems, which machine-checks their types.
   - I also proved the tuple of others, ¬`moved` and ¬conclusion independently.
3. **`Lifted.inactive_needed`, row 17.**
   - `Lifted.acting`, `Lifted.descended`, `¬ inactive` and `size 1 ≠ 0` all hold.
   - The check applies both the package `GroupEnding.Flow.all_end` and the on-root `size_zero_of_within` to them.
4. **The check applies the rows themselves.**
   - With `pp.fullNames`, every row name in the module's own namespace context resolves to the package constant: `Becoming.Flow.selection_within`, `selected_le`, `transmitted_supported`, `Becoming.SelectionTerm.Flow.support_not_lower` and `support_moved_rises`, `Becoming.GroupEnding.Flow.rises_iff_inactive` and `all_end`, and `Becoming.SelectionLevels.rises_exact_iff_levels`.
   - The scratch defines no theorem under any of these names.
   - The on-root forms it applies (`rises_iff_inactive_on_root`, `size_zero_of_within`, `rises_cancel_iff_levels`, `no_new_dependence_of_given`) are the standing-2 statements themselves, not copies.
   - For row 5 and row 14, dropping the weakened hypothesis on the root leaves the same remainder as dropping the package's (balance and exactness), so `Ungiven` and `Lifted` witness both forms.
5. **The other fixes.**
   - **M1:** `offspring_depends` is used in all three row-2 examples that need it.
   - **M2:** `not_acting_at` and `not_descended_at` state the failures at step 0 directly.
   - **M3:** `rising_refl`, `rising_trans` and `rising_not_class` are proved.
   - **M4:** `activeOcc` is gone, and `acting_iff_occurrences` reads U2's `ModelStatements.activeAt`. `gate_iff_occurrences` is `L.Acting W ∧ W.Dependent ↔` the two inclusions with that one region, and its axiom report is empty.
   - **S1:** §8 now treats `Standing` apart, and lists giving within the giving step. Its remark that `acting_iff_occurrences` reads activity only at the giver is accurate.
6. **No new overclaim** in the header, §0, §1, §4, §7, §10 or the docstring. With `Kept` and `Lifted`, every non-list hypothesis of rows 1–3, 5, 7, 8, 13, 14 and 17 has a witness.

**Left (minor):**

- **R1.** LEVER-2-AUDIT.md l.18 says "48 examples and 2 theorems, whose axiom reports are empty". Examples are elaborated but have no axiom report; only the 2 theorems are audited. They compose axiom-free scratch theorems with core rows, so nothing hides there.
  - **Fix:** "the 2 theorems' axiom reports are empty; the examples are elaborated, not audited".
- **R2.** The repository copy of this review (byte-identical to the version before this section) names the scratchpad `Check.lean` by an absolute path (l.58) that will not survive the scratchpad.
  - **Fix:** re-copy the review with this section appended, and note there that the check now lives in `lever-2-scratch/Becoming/U4LeverTwoCheck.lean`.
  - Cosmetic: `U4LeverTwoCheck.lean` l.12 is one over-long docstring line.

**Taken by U4's owner.** R1: the audit's sentence now says that the 2 theorems' axiom reports are empty and the examples are elaborated, not audited. R2: this copy carries the recheck, and l.58 names the kept check. The over-long docstring line of the check module is split.
