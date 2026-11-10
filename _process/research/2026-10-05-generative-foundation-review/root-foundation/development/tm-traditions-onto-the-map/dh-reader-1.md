*CY item (e), its reader's first round (GPT astra through Codex, effort high; AI-written), 10 November 2026: its final message, kept as returned, on the leaf as it then stood (collapse by its own descent, recovery named for leaving, thresholds claimed). Its links pointed into a review copy that is not kept; they are given here as paths in code. The findings were taken as the record's history says.*

The leaf supports history dependence, but its prose overstates this as a law of two exact thresholds. Read-only review: no edits, builds, Lean runs, or tests; the checker receipt is author-supplied evidence. Corrections below apply to both language versions.

**High**

1. **[DrawHistory.lean] (`DrawHistory.lean:27`), header “So the draw at which…two thresholds”; [record] (`the-draws-before.json`), title, statement, correspondence and history; [home paragraph] (`02-home-paragraph.md`), same conclusion.** These promote a sufficient collapse condition and a necessary departure condition into exact thresholds. No theorem defines a least collapse draw, establishes recovery below a threshold, or orders all actual collapse and hold draws. The record’s own `does_not_show` correctly concedes this.

   Replace with: “For a nonempty band satisfying `Meets` and `Keeps`, a chosen draw exceeding every giving up to `hi` exceeds the band’s holding draw and forces the run to the inflow. Leaving the inflow requires a subsequent draw below it. These are separated bounds, not identified collapse and recovery thresholds.” Rename the title and `thresholds` docstring heading accordingly.

2. **Lean `two_levels`, `history_decides`, their header summaries; record statement/law 3; home “holds both a band…and the inflow.”** Distinctness is missing. `two_levels` allows `x = g 0`: take constant giving one and `H = x = hi = 1`, `y = 0`. Even `history_decides` admits this example with `H' = 2`; the two histories then agree.

   Correct: “The run from `x` never falls below `x`, and the inflow remains fixed. When `g 0 < x`, these outcomes are distinct.” For a whole distinct band, require `g 0 < H + y ≤ hi`. Replace unconditional “depends on the draws before” with “can depend,” subject to separation.

3. **Record correspondence: “the recovery threshold is the inflow itself”; related item: “the inflow is the floor.”** Neither follows. The rest is a real mathematical feature **forced by the modelling convention**: truncated subtraction wipes every `x ≤ H`, and the next state is `g 0`. It is not independently derived ecological persistence. Nor is `g 0` a universal floor: with `g 0 = 5`, `g 1 = 0`, `H = 5`, level six maps to one.

   Correct: “The absorbing inflow state results from complete removal followed by refill from zero. `g 0` bounds draws permitting departure; it is not an established recovery threshold or global lower bound.” The empirical boundary should require testing this update convention and a fixed giving law across draws, alongside the predicted history dependence. “Collapses at a harvest it once withstood” should become “a larger draw causes collapse; returning to the former holding draw leaves the low state.”

**Medium**

4. **All “giving meets it from `y` up to `hi`” passages**, including `two_levels`, `history_decides`, `Loop.meets_two`, `Loop.meets_three`, record laws/hypotheses and home. `Meets` means
   `∀ z, y ≤ z → z + H ≤ hi → H ≤ g z`,
   not giving meeting the draw through residual level `hi`. The witness makes the difference concrete: giving at seven and eight is zero.

   Correct throughout: “Giving meets `H` whenever `y ≤ z` and `z + H ≤ hi`.” In the witness these residual ranges are one–six and one–five respectively. Restore `H + y ≤ x ≤ hi` wherever the header, record or home omits the upper bound; spell out `Keeps` as preserving **every** level at most `hi`.

5. **Lean `recovery_needs_a_lower_draw` docstring and all “lifts/recovers” summaries.** The conclusion is `¬ ∀ t ≥ T, g 0 ≤ Hs t`; it supplies neither an explicit earlier witness `T ≤ t < T+k` nor upward movement. Departure can be downward: `g 0 = 3`, `g 2 = 0`, draw one sends three to two.

   Correct: “If the later level differs from the inflow, the draws from `T` onward cannot all be at least the inflow.” Reserve “recovery” for a defined upward return. A bounded witness would need an additional theorem.

6. **Lean witness header; record law 4/counterexample; home witness.** “Collapses only under four” is false: five also collapses the witness. “Levels from three hold at eight” confuses eventual arrival with holding above the start; levels initially at most two reach one **after one step**, rather than all initially resting there.

   Correct: “Under draw two, starts three through eight remain above their starts and eventually reach eight; starts at most two reach one after one step. Draw four suffices for collapse.”

   `two_paths` and the body of the `thresholds` docstring accurately describe their formulas. Staying exactly eight additionally uses `keeps_two`. Step five is correct by direct arithmetic, but `two_paths` states step nine onward; use nine when citing it. “Recovers under no draw” should read “from one, reaches seven after two zero-draw steps.” This reaches the high band, but does not state restoration to eight or a return-and-hold protocol. Describe the counterexample as comparing histories **after the draw returns to two**.

7. **Rule 9: existing package results.** [RegimeMargin.lean] (`experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/RegimeMargin.lean:614`) already has `Adjusted.left_bound` and `Adjusted.taken_whole`, allowing giving from nothing. Specialize with `A e r = g e`, `y = hi + 1`, recent giving zero; transfer through `orbit_regime`, then apply `to_inflow`. This supplies `collapses` without its separate descent induction.

   `Adjusted.fixed_iff` and `rests_short` already cover nonzero rests below the draw; `ends_below`, `stays_ended`, and `ends_beyond_giving` cover zero-inflow collapse. Correct the header’s implication of novelty to: “The package already permits nonzero low rests; this leaf combines them with changing draws and contrasting histories.” Reuse the existing general collapse result below this special application. I found related schedules in `HorizonWebs`, but no duplicate of this exact `underDraws` law.

8. **Record `related`: “here a run turns because the draw moved.”** No reversal theorem is stated; the collapse witness falls and then rests. Replace with: “Here changing the draw changes the eventual level, which persists after the draw returns.”

**Low**

9. **Record schema/process.** Static inspection found no obvious schema-2 refusal: kinds, boundary keys, declaration lists and prose caps fit. This is not a validator pass. Receipt narration belongs in `validation_scope`, where it already sits. `history` contains board/owner/AA/CY process narration; retain that as provenance, but shorten the public account to the mathematical addition. Move “a test…must fix…before it reads the series” to a test protocol; use “No empirical correspondence is established” in `does_not_show`.

