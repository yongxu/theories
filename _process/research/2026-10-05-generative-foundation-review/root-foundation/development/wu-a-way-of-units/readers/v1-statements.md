AI-written (Opus reader), 13 November 2026

# WayOfUnits v1: statements against words

Read only: `lean/Becoming/WayOfUnits.lean` against DESIGN.md, r3-logic.md, TurningInTime.lean, GuardedStep.lean, RegimeMargin.lean, Prelude.lean, GrammarLaws.lean, Narrowing.lean. I built nothing and ran nothing. Every name the header cites exists, with the namespace given: `TurningInTime.pair/net/turns_in_time_iff/AloneOutside/kind_ends_while_net_goes/Three.giving`, `Flow.family_ends_below_at` (Continuation.lean:480), `ReadingsSpread.Commons.overdrawn_spreads_then_ends`, `RegimeMargin.ends_below/holds/Short/Meets/Keeps/FromNothing`, `GrammarLaws.keep/keep_all/mem_keep`, `Law.stepWhile_unending_iff`, `first_of_decided`, and `ReadOffInTime.FourReaders` `near`/`mid`. The words rule holds: no reader, part, candidate, shed, shield or canary appears, and "law" occurs only in `Law.` and `GrammarLaws`.

## Findings, most serious first

1. **`takes_nothing_ends` says less than its words (restates `RegimeMargin.ends_below`).** With `h = 0` the way takes `H₂` whether or not the first unit is there, so the level's course is the course under `H₂`. The premises `short₁ : Short giving H₂ y₁` and `below : x < H₂ + y₁`, with `nothing`, already put the start below `H₂`'s own point of no return. `ends_below` takes the level to 0 by step `x`, and `0 < n ≤ m` then ends the line. `short`, `meets`, `keeps`, `within` and `high` are not needed for the conclusion; they come in only through `two_units_iff`. The first unit's ending plays no part. The header's reading ("the case `takes_nothing_ends` says can correct nothing by ending") credits the theorem with something it does not state. *Fix:* state the exact fact, `n ≤ m → («不穷» (net giving) «一» ([(m, 0), (n, H₂)], x) ↔ «不穷» (net giving) «一» ([(n, H₂)], x))` for any giving and any `x`. `Goes` agrees because `n ≤ m`, `taken` is `H₂` on both ways, and the courses agree while `n` is met. Keep `takes_nothing_ends` as a corollary with only `order`, `nothing`, `needs`, `short₁` and `below`, or drop it. Point the header reading at the new statement. DESIGN W5 has the same weakness.

2. **Header word, `unending_iff_carrier`.** "The units' line and the carrier's line never end together" reads as "never both end". The theorem is an iff: one never ends exactly where the other never ends. *Fix:* "the units' line never ends exactly where the carrier's line never ends".

3. **Header overclaim.** "A start that already holds with both units is outside `two_units_iff`; `unending_iff_holds` covers it." It covers that start only under its own `along`. `along` asks `Short`, `Meets` and `Keeps` at `h + H₂` with `y (h + H₂)`, and `two_units_iff` does not ask `Meets` or `Keeps` there. *Fix:* add "under its own premises, which ask `Meets` and `Keeps` at `h + H₂` too".

4. **`course_within` docstring.** It names the premise as "(`Regime`'s third clause)", but `along` asks all of `Regime`; only the third clause is used. *Fix:* "where `Regime` holds at every way … (only its third clause, `Keeps`, is used)", as `reaches_holds` already says.

5. **Restatements under new names.**
   - `length_pos_of_mem` is `Becoming.length_pos_of_mem` (Prelude.lean:1022, more general) and shadows it.
   - `ge_of_not_lt` is core `Nat.ge_of_not_lt`, which the package uses axiom-free (Arising, Dependence, Entropy …).
   - `step_le_of_below` and `level_le_start` are `RegimeMargin.Adjusted.step_below` (third clause) and `Adjusted.orbit_bound` (`≤ x - n`), carried by `Adjusted.orbit_regime`.
   - `level_le_of_le` is `Optimum.never_rises` in the regime form; the package reaches that form only through the private `TurningInTime.regime_levels`.
   - `orbit_id_true` is the private `TurningInTime.Three.orbit_id`.

   *Fix:* use the first two directly. For the level lemmas and `orbit_id_true`, say in the docstring which existing statement each re-proves and why (another module's form, or private).
6. **"While the net goes on" in `along`.** The phrase appears in the header bullet, in `unending_iff_holds` and in `Regime`'s uses. `along k` holds at every `k` with `Goes` at every step before `k`. That includes the start (`k = 0`, always, even for `w = []`) and the way at which the net stops. *Fix:* "at every way the course reaches with the net going on at every step before it, the start's included".
7. **Nothing shows `unending_iff_holds`'s premises can be met together.** The witnesses go through `two_units_iff` only. Both witnesses satisfy `along` with one `y`: `y 5 = 5`, `y 4 = 4`, `y 1 = 1` under `Three.giving`, `hi = 12` (checked by hand: `Short`, `Meets` and `Keeps` at 5, 4 and 1). *Fix (optional):* `With.holds_at_two : Holds y (course … 2)`, and `With`'s and `Against`'s outcomes through `unending_iff_holds`, so the general theorem has a witness.
8. **"What the package already has" drops premises.**
   - The summary of `turns_in_time_iff` leaves out "the need met there and at every step before".
   - The summary of `Flow.family_ends_below_at` leaves out "where it is active only while supported".
   - `RegimeMargin.ends_below` and `holds` are cited without `Short`/`FromNothing` and `Meets`/`Keeps`.

   *Fix:* add a half-line each, or say "under their regime premises".
9. **Section heading "List lemmas".** The words rule calls a proved statement a theorem. *Fix:* "On lists".

## Each declaration (the rest)

- **Definitions.** `need`, `use`, `goes`, `after`, `taken`, `left`, `Goes`, `net`, `course`, `Holds`, `Regime`: each docstring says what is defined.
- **Small theorems.** `goes_of_le`, `goes_false_of_lt`, `le_of_goes`, `mem_of_ne_nil`, `length_keep_le`, `length_keep_lt`, `met_or_unmet`, `mem_after_iff`, `anyGoes`/`anyGoes_iff`/`goesDecidable` (used by `by decide` in `Against`): exact.
- **`after_eq_iff`, `mem_course_iff`:** exact, at any way, level and giving.
- **`ends_while_net_goes`:** exact. Its premises are named. It is not an instance of `kind_ends_while_net_goes`: the nets differ (`stepWhile Goes` against `stepWhile (need ≤ ·)`), so "the counterpart of" is right.
- **`fixed_while`, `stays`, `falls`, `reaches_holds`:** exact. `reaches_holds` correctly says that only `Short` is used.
- **`unending_iff_holds`:** exact. Its premises are named. It keeps `S ≠ []` (r3-logic G4), and it says that `along` is stated along the course, not over sub-ways, as DESIGN asked.
- **Section 6 definitions and lemmas.** `firstAfter`, `firstUse`, `twoWay`, `carrierCourse`, `taken_twoWay`, `after_twoWay`, `goes_twoWay`, `course_twoWay`: exact. `first_outside`, `first_turns`, `first_kept`, `first_uses`, `first_uses₁` match TurningInTime's `outside`, `turns`, `kept`, `uses`, `uses₁` at `Kept b := b = false`, `alone := id`. `asItWas_first`: exact.
- **`two_units_iff`:** the docstring lists all ten premises. The right side reads as stated (the need met before `T` follows from `m ≤ X j` and `n ≤ m`). It is not vacuous: `With.goes_on` uses it.
- **`greater_need`, `more_use_on_first`:** the premise lists match. The proof sketches are true. Both are satisfiable (for `more_use_on_first`, e.g. `(3,2)` against `(4,1)` under `Three.giving`). The header's admission that `greater_need` fails without `below` (found by simulation, not in Lean) is honest.
- **`With.goes_on`, `With.levels`, `Against.turns_and_ends`:** the levels check: 9, 8, 6, 10, 12, 12 and 9, 8, 6, 4, 0. "The same up to the first unit's ending" holds at steps 0 to 2.

## Against the design

- **Present:** W1 to W6, the three lemmas, and the one statement on the turn. Every bullet of "What it does not show" is in the header ("shielding" is reworded as "keeping a unit from ending by lowering its need", which keeps the words rule).
- **Not done as offered:** making `regime_levels` public. The monotonicity is re-proved instead (finding 5).
- **Added beyond the design:** `Regime`, `anyGoes`/`goesDecidable` and `With.levels` are needed or harmless. The header advertises `mem_course_iff` and `after_eq_iff`, which DESIGN called "lemmas as needed, not advertised". That is a choice, and harmless.
- **The design's own weak point:** W5 as specified is the weakness in finding 1.
