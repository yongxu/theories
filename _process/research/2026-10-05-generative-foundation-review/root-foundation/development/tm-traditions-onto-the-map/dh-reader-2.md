*CY item (e), its reader's second round (GPT astra through Codex, effort high; AI-written), 10 November 2026, on the revision against its first-round findings: its final message, kept as returned. Its links pointed into a review copy that is not kept; they are given here as paths in code. Its three remaining wording findings were taken.*

The main mathematical repairs are sound on static inspection. No files were edited; no builds, Lean runs, or tests were performed. The checker receipt remains author-supplied evidence.

1. **Partly fixed.** Separated bounds replace exact thresholds in the main exposition, but the record’s `history` still claims “distinct collapse and recovery thresholds.”
2. **Partly fixed.** `histories_differ` correctly requires `g 0 < x`; the main explanations respect this, but `two_levels`’ heading and the header’s concluding hysteresis sentence remain unconditional.
3. **Fixed.** The inflow rest is explicitly attributed to the update convention; recovery-threshold and universal-floor claims are removed, and empirical correspondence is disclaimed.
4. **Fixed.** The residual-domain condition for `Meets`, the starting interval, and the universal scope of `Keeps` are restored.
5. **Fixed.** `leaving_needs_a_lower_draw` constructively supplies `∃ j, j < k ∧ Hs (T + j) < g 0`; prose distinguishes departure from upward recovery.
6. **Fixed.** Witness wording now distinguishes holding, one-step arrival, sufficient collapse, and the two-step zero-draw calculation; `Loop.bounds` is appropriately named.
7. **Fixed in the proof.** `collapses` specializes `Adjusted.taken_whole` through `orbit_regime`, with valid premises and the sharper `x - H + 1` bound; its new dependency prose needs qualification below.
8. **Fixed.** The related-item text now describes persistent changes in level after the draw returns, without asserting reversal.
9. **Partly fixed.** `does_not_show` now states the empirical limitation directly, but `history` retains the process-heavy account and obsolete mathematical description.

**High: none.**

**Medium: one new finding, two residual wording findings.**

- **New — [the-draws-before.json:156] (`the-draws-before.json:156`), dependency on `regime-point-under-adjusting-giving`.** “Below the point of no return and whatever is given from nothing” omits essential premises of the general adjusted law: recent giving must be below the draw, and the adjustment must satisfy `StaysShort`. “Whatever” does not remove those restrictions. Correct both languages to: “Collapse specializes `Adjusted.taken_whole`: with a positive residual boundary, regime giving below the draw below that boundary, initial level below the corresponding point, recent giving below the draw, and adjustment preserving shortfall, the level is at most the draw from `x - H` steps onward.” The actual specialization supplies these premises correctly; **no remaining rule-9 proof issue found**.

- **Residual #2 — [DrawHistory.lean:125] (`DrawHistory.lean:125`), “One draw, two outcomes,” and [line 40] (`DrawHistory.lean:40`), “a held band and a rest … make the state depend on its history.”** `two_levels` still permits coincident outcomes: constant giving one with `H = x = hi = 1`, `y = 0`. Correct the heading to “A held level and an inflow rest”; correct the conclusion to “When the held starting level is above the inflow, the raised-and-returned and constant-draw histories have distinct later levels.”

- **Residual #1 — [the-draws-before.json:238] (`the-draws-before.json:238`), `history`, both languages.** “A band with distinct collapse and recovery thresholds” still overstates the result. Replace with “a held band above the inflow, contrasting draw histories, and separated sufficient-collapse and necessary-departure bounds.”

**Low:** Residual #9: shorten the public `history` to that mathematical addition while retaining provenance separately. No additional low finding.

