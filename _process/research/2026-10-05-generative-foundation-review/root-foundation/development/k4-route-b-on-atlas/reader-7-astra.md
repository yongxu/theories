# Cold read, round 4: 5c584f638

AI-written review. Scope: only the readmission-edge fix in `git show HEAD -- theories/becoming/results/atlas/entries/dynamics.json`. Read-only inspection apart from this file.

No findings. The round-3 medium is resolved; the revised edge introduces no additional unsupported claim.

The edge at `theories/becoming/results/atlas/entries/dynamics.json:22154` now explicitly requires the update to preserve the complementary region whenever both inputs lie there, and explicitly applies `fixed_of_present` to that complement. These match `theories/becoming/chapters/07-SIGNIFICANCE.md:808–813` and the separate `present`, `keeps` and `fixed` premises of `Becoming.SelectionTerm.Generations.fixed_of_present` (`experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ReadingsSpread.lean:169–173`). Absence of the reader region supplies fixation of its complement.

“An absent region re-enters only by revision in” matches `Becoming.SelectionTerm.Generations.absent_step` (`ReadingsSpread.lean:325–332`), which equates its next count with revisions into it. With the update-preservation premise retained, the following sentence identifies the boundary: within-cohort sensing prevents re-entry, so re-entry requires leaving that sensing restriction. It does not claim re-entry can occur while every stated premise continues to hold, or that outside sensing suffices to produce it.

The cross-model join remains explicitly “in words, not as a Lean statement,” with argued standing and no law or strength; the fix does not promote the pool/generations correspondence to a theorem.

Counts: high 0, medium 0, low 0.
