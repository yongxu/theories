*CY's first piece, its one reader (GPT astra through Codex, effort high; AI-written), 10 November 2026: its final message, kept as returned, on the leaf as it then stood (RunTurns with last_before_failure, rests_on_band and halves of its own). Its links pointed into a review copy that is not kept; they are given here as paths in code. The findings were taken as the record's history says.*

Read only; no files changed and no builds, Lean runs, or tests executed. I accept the supplied receipt as compilation and axiom evidence.

**High**

1. **Missing premises in the period-two prose.** [RunTurns.lean:26] (`RunTurns.lean:26`), its `reversing_period_two` docstring, [the record] (`where-a-run-turns.json`)’s statement/hypotheses/law 3, and [the home paragraph] (`02-home-paragraph.md`) omit or leave implicit **the start being inside the band**, `x ≤ hi`. The record’s statement also omits band preservation. These matter: with `hi = 0`, `g 0 = 0` and `g n = n + 1` for positive `n`, the band is preserved and its order reversed, but a run starting at 1 never becomes periodic.

   **Correction:** “For natural-number levels, if the step preserves `[0, hi]` and reverses its order, every run **starting in that band** satisfies `orbit (n + 2) = orbit n` for every `n ≥ hi + hi`.”

2. **The correspondence asserts an unsupported converse.** Record `correspondence`: “Compensatory renewal settles and overcompensating renewal oscillates.” The settling result requires a preserved bounded band; the turn result gives a necessary local decrease in giving, not sufficient conditions for oscillation. This sentence conflicts with the record’s own `does_not_show` item about falling giving.

   **Correction:** “Within a preserved finite band of natural-number levels, order-preserving steps settle. A run initially not lowering and later falling witnesses a local decrease in giving; such a decrease alone does not force oscillation.” Keep the ecological references as a separately qualified correspondence, not a universal consequence of these declarations.

**Medium**

3. **“First,” “last,” and “so far” exceed the exported witness.** [RunTurns.lean:47–52] (`RunTurns.lean:47`) says “fails first”; its header and record law 1 say “the last step”; [CY-RULE9.md:21] (`CY-RULE9.md:21`) says “has not lowered so far.” The conclusion supplies only `k < n ∧ P k ∧ ¬ P (k+1)`. It states neither minimality nor maximality nor an unbroken prefix. The backward proof searches from the end, but does not export maximality. For values `true, false, true, false`, it selects the later transition, not the first failure.

   **Correction:** “There is some `k < n` at which the property holds and at `k + 1` it fails.” For the run: “the step from `k` to `k + 1` does not lower”; delete “so far.”

4. **Existing general statements were missed.** `last_before_failure` is the `T = 0` specialization of both:
   - `Becoming.ceasing_step`, `Becoming/Substitution.lean:48`;
   - `Becoming.ceases_within`, `Becoming/Sampling.lean:181`.

   Both already locate `p s ∧ ¬ p (s+1)` between arbitrary endpoints. `RunTurns.halves` duplicates `ReadingSchedule.halves`, `Becoming/ReadingSchedule.lean:327`, modulo `Naturals.two_mul`.

   Thus the record history’s “this leaf states only what is new as a statement” is too broad.

   **Correction:** “The leaf applies an existing decidable transition-localization law to adjacent orbit states and adds the regime witness and bounded antitone result.” Put shared localization and parity laws below their applications and reuse them.

5. **`rests_on_band` generalizes an existing special proof but lands above it.** [RunTurns.lean:128] (`RunTurns.lean:128`) repeats the two branches of `RegimeMargin.rests_within` (`RegimeMargin.lean:1119`) with band-local monotonicity. This is a useful generalization, not an exact duplicate. But `RunTurns` imports `RegimeMargin`, so the special theorem cannot cite the general one. That violates the stated placement rule.

   **Correction:** “The general band law lives in a common lower module; `RegimeMargin.rests_within` specializes it using `step_mono`.” Implementing that requires relocation and reuse, not merely changing the prose. R1’s deferral does not resolve this separate duplication.

6. **The generic theorem’s scope is misstated.** `turns_where_order_breaks` takes **any binary relation**, with decidability on **every pair**, not order axioms. Failure of that relation need not mean a strict decrease. Conversely, the module header, record’s scalar/memory boundaries, home paragraph, and Rule 9 note say less than this theorem: its carrier may include history.

   **Correction:** “For any carrier and binary relation decidable on every pair, if the relation holds between the initial state and its successor but fails between a later adjacent pair, some earlier adjacent related pair has unrelated images. The natural-number specializations interpret this as lowering; the scalar regime results do not analyze delayed rules.”

   Also qualify the record’s broad “a run that turns” and law 2 with **initially not lowering, subsequently falling**. The displayed natural-number witness is not stated for both orientations of turn.

7. **The record is rejected by the current validator.** `where-a-run-turns.json` omits `counterexamples`. Despite allowing `does_not_show` as the substantive boundary, `tools/research/registry.py:967` still requires `counterexamples` to be a list; the loader supplies no default.

   **Correction:** Add `"counterexamples": []`. This finding comes from reading the validator, not running it.

**Low**

8. **Chinese broadens `Nat` and obscures the draw.** Record law 2 and hypotheses use “整数,” which includes negative integers; Lean uses `Nat`. “有多少取多少” can also suggest taking everything rather than taking up to `H`.

   **Correction:** Use “自然数（含零）”; describe the draw as “先汲取 `min(H,x)`，留下 `x-H`（自然数减法）.”

9. **Two helper docstrings understate their quantifiers.** [RunTurns.lean:160–171] (`RunTurns.lean:160`) describes two steps and their commutation, while both declarations quantify over arbitrary `m`.

   **Correction:** For `orbit_twice`: “For every `m`, `2m` applications of `g` equal `m` applications of `g ∘ g`.” For `step_after_twice`: “Applying `g` after `m` applications of `g ∘ g` equals starting those `m` applications at `g x`.”

10. **Universal cycle heading versus the exhibited case.** “A longer cycle needs a step that neither keeps nor reverses the order” is a general mathematical consequence in the intended setting, but `ThreeCycle.returns` and `ThreeCycle.neither` explicitly establish one example, not that quantified necessity theorem.

    **Correction:** “A period-three regime whose step neither keeps nor reverses the order.”

11. **Minor process wording remains.** Record `correspondence` says “TM’s joint reading,” and `next_delta` describes moving inline proofs. These read partly as production history.

    **Correction:** Say “Under the proposed dialectical reading…” and describe the mathematical next question directly. I found no forbidden date/round marker in the lint’s public fields, nor any exceeded length cap. Receipt dates in `validation_scope`, dates in `history`, and bibliographic years are appropriately placed.

The two principal mathematical checks are sound on inspection. For subtraction, `a < b` gives only `a-H ≤ b-H`; the reversed step images force `g(b-H) < g(a-H)`, which rules out equal remainders and establishes **`a-H < b-H`**. No premise `H ≤ a` is needed.

The **`hi + hi` bound is correct**: both parity subsequences settle within `hi` square-steps. “Ends at rest or period two” is honest with the band premises restored: the tail has period dividing two, with equality of its two alternating values giving rest. It does not assert a genuine two-cycle or a sharp bound. I found no existing duplicate of `orbit_twice`; `Law.orbit_mul` concerns repeated returns and is a different statement.

