# Brief: a line on a stock, second pass: made a part of what is there (in scratch only)

*AI-written (Fable, holding the design; board row DJ), 16 November 2026. For the implementer. Nothing new here is proved.*

## Where it stands

`SCR/Becoming/LineOnAStock.lean` (SCR = `/Users/ren/theories/tmp/r7/one-model/lean-scratch/`) builds with no axiom and no warning: 1,145 lines, 83 theorems. Three readers who did not write it found no counterexample and no wrong number. They also found (their reports: `/Users/ren/theories/tmp/r7/one-model/check/round9/stage-a-review.json`; read all three):

- It is joined to the package at definitions and hardly at laws. About a dozen facts are proved again that exist in `Prelude`, `Flow` or `WayOfUnits`. No existing theorem became a case of one here, and nothing got smaller.
- `alike_one_count` is one single-course fact stated twice; its premise is "every need met on both", not alikeness; `after_alike` is used by no proof; no count is stated.
- Only one direction of `same` is used (`S v → S u`); `rise` and `draw_holds` use none.
- `need_unmet` holds with `n ≤ hi + 1`, and that bound is reached.
- Several docstrings say more than their statements (`after_append`'s title, `unending_unit`'s header, `KidsNeedMore.goes_on`'s "so `way_ends` fails without `down`" with the other premises not proved for that world, "line" used in two senses).
- No closed instance shows that the premises of `fall`, `line_ends` (with a line that is a proper part), `need_unmet` or `alike_one_count` can hold together.

The person who directs the work wants a map that is joined and simple, not results said again. This pass is for that: fewer lines doing the same work, and existing theorems as cases of the laws here.

## The task

Rework `SCR/Becoming/LineOnAStock.lean`, and rework a scratch copy of `WayOfUnits.lean` so that it rests on it. Both must build with every axiom report empty and no warning. Touch no tracked file. Land nothing.

- Package (PKG): `/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/`. No Mathlib.
- `SCR/Becoming/TurningInTime.lean` was extended by the pass before yours (read its new theorems `ends_with_net_rising` and what follows, near the old `ends_with_net_regime` and the lock; if `ends_with_net_rising` is not there, skip item 7 and say so). Do not edit it.
- Copy `PKG/Becoming/WayOfUnits.lean` to `SCR/Becoming/WayOfUnits.lean` and edit the copy.
- Build, from PKG, in the background, with a log: `LEAN_TIMEOUT=3600 python3 -B scratch_build.py /Users/ren/theories/tmp/r7/one-model/lean-scratch/ Becoming.LineOnAStock Becoming.WayOfUnits > /Users/ren/theories/tmp/r7/one-model/lean-scratch/buildA2-<N>.log 2>&1`. One build at a time; before each, `uptime`, and `ps` for a `lean`, `scratch_build` or `check_becoming` still alive. Never run `check_becoming.py` with any flag.
- Not allowed: `omega`, `simp`, `funext`, `Classical`, `propext`, `native_decide`, `sorry`, any axiom. `decide` only on small closed facts.
- Docstrings say exactly what the Lean proves: premises named, what is given said as given, no title that promises more than its statement.

## What to do, in this order (keep the file green after each; stop and report on any item that resists)

1. **Turn the import round.** `LineOnAStock` imports `Becoming.TurningInTime` and `Becoming.SelectionTerm` (and what else it needs) and not `WayOfUnits`. The section `Units` (the bridge: `after_unit`, `taken_unit`, `goes_unit`, `step_unit`, `course_unit`, `unending_unit`) and `EqualInPlaceOfMore.units_with` leave this file; the bridge goes into the `WayOfUnits` copy (item 6), which will `import Becoming.LineOnAStock`.
2. **Use what is there.** Replace the local copies by the package's lemmas: `Becoming.le_total_of_mem` (Flow.lean:198); Prelude's `mem_append_of_left`, `mem_append_of_right`, `mem_append_cases` (near 514 to 526) and `ListTests.append_assoc` (482); `ListTests.mem_flatMap_iff` (Prelude:360) for `mem_after_iff` through `after_flatMap` if that is shorter. Look for others (`total_append`, `total_le`, `total_ones`, `total_congr` are already used). Report each local lemma removed and each kept with the reason.
3. **Alike, stated as alikeness.** Replace `alike_one_count` by: for one `need` and `kids`, two givings, two uses, two start levels and one way: if for every `j < n` the two levels at step `j` meet the same needs in the way of the first course at step `j` (`∀ u, u ∈ (course … (w, x) j).1 → (need u ≤ (course … (w, x) j).2 ↔ need u ≤ (course' … (w, x') j).2)`), then for every `j ≤ n` the two ways at step `j` are equal. Its proof must use `after_alike`. Keep `way_generation` as the case where every need is met. Add the count: under the same premise, for `j < n` the two `generations` have the same `kids j u` at every unit `u` of the common way (so the Lean's offspring numbers agree). Name them plainly (`ways_alike`, `kids_alike` or better).
4. **The line's closure, one way.** Where `same : ∀ u v, v ∈ kids u → (S v ↔ S u)` is a premise and only `S v → S u` is used, take `closed : ∀ u v, v ∈ kids u → S v → S u` instead (no unit outside the line leaves a unit of it). Say in the docstrings what a line is by that.
5. **`need_unmet` with `n ≤ hi + 1`.**
6. **The middle case, and `WayOfUnits` as its case.** Per unit there are three cases: its offspring together draw more than it did (`grows`: then the way ends, `way_ends`), the same (`even`), or less (not treated). Prove the middle one here, in general:
   - `Holds y s := s.1 ≠ [] ∧ (∀ u, u ∈ s.1 → need u ≤ s.2) ∧ taken use s.1 + y (taken use s.1) ≤ s.2` and `Regime giving y hi w := Short giving (taken use w) (y (taken use w)) ∧ Meets … hi ∧ Keeps giving (taken use w) hi` (as `WayOfUnits.Holds`, `WayOfUnits.Regime`, general in `U`).
   - **Theorem (`unending_iff_holds`).** Given `even : ∀ u, taken use (kids u) = use u`, `some : ∀ u, kids u ≠ []`, `down : ∀ u v, v ∈ kids u → need v ≤ need u`, `needs : ∀ u, 0 < need u`, `FromNothing giving`, `x ≤ hi`, and `along : ∀ k, (∀ j, j ≤ k → Goes need (course (w, x) j)) → Regime giving y hi (course (w, x) k).1`: `«不穷» (net …) «一» (w, x) ↔ ∃ k, (∀ j, j < k → Goes need (course (w, x) j)) ∧ Holds y (course (w, x) k)`. (Trim premises you find you do not need; add any you find you do, with the countermodel that forces it.)
   - Route, right to left: from a holding configuration every need is met, so the next way is all the kids (`after_of_met`, `way_generation`), which by `even` take the same, by `down` need no more, by `some` are not none; the level under one draw at or above its point of no return does not fall (`RegimeMargin.holds`, as `WayOfUnits.stays` uses it); so every later configuration is met. Left to right: strong induction on a bound `m` on the needs in the way (`Below`, as in `line_ends`), inner strong induction on the level. If the level is below `m`, step once: the next way is `Below` the level. If every need is met: either the level is at or above the point of no return of what the way takes, and the configuration holds; or it is below it, and then under that one draw the next level is strictly lower (or nothing), the next way is all the kids, still `Below m`, taking the same: recurse on the level.
   - **In the `WayOfUnits` copy:** add `import Becoming.LineOnAStock`; after its definitions put the bridge (the six lemmas of the old section `Units`, saying that `WayOfUnits` is the case `kids u = [u]`); then re-prove from the general module, each **statement byte for byte as it stands**, whatever gets shorter that way: `reaches_holds` and `unending_iff_holds` (from the theorem above at `kids u = [u]`), `met_or_unmet`, `mem_of_ne_nil`, `anyGoes_iff` or `goesDecidable`, `course_fixed`, `unending_of_fixed`, `mem_after_iff`, and `step_falls` from `TurningInTime.held_above` (they are one fact, one contraposed). Do not change any definition or statement of `WayOfUnits`. If a re-proof is not shorter than the proof it replaces, leave the old proof and say so. Report `WayOfUnits.lean`'s line count before and after, and for each theorem whether it is now a case.
   - A new one-line consequence there or here: on a `WayOfUnits` course that goes on, what the way takes is less than the level (`taken_below` at the case).
7. **One law, two cases.** In a world of one need (`∀ u, need u = n`, `0 < n`), with `grows`, `FromNothing giving`, `Keeps giving 0 hi`, `x ≤ hi` and a way that is not empty: derive that the net ends from `TurningInTime.ends_with_net_rising` (marks: the levels below `n`; the way as it was: `allKids kids`; the draw rises along it by `rise`). State it so that the docstring can truthfully say: a way that grows and a lock whose share is a number of drawers end by one law. Keep `way_ends` (unequal needs) as it is.
8. **Closed instances and kept countermodels made whole.**
   - `KidsNeedMore`: prove `FromNothing hump10`, `Keeps hump10 0 10`, `∀ u, 0 < need u`, `8 ≤ 10`, and state as one theorem that every premise of `way_ends` but `down` holds there while the net never ends. `EqualInPlaceOfMore`: the same for `grows` (every other premise holds; `grows` fails; never ends).
   - A closed case of `fall`: one kind, need 1, use 7, leaving itself, on `Three.giving` from 12: levels 12, 10, 6, 0; gone from step 4 (check the numbers first).
   - A closed case of `line_ends` with a line that is a proper part: `D` = need 1, use 1, kids `[D, D]`; `O` = need 1, use 1, kids `[O]`; from `([D, O], 12)`; the line of `D`. Give the step from which no `D` is in the way, by the law, and the course's values by computation.
   - `need_unmet` at `Doubling` with `hi = 12`; `ways_alike` at `HigherStartEnds` with `n = 2`, so that the equal ways there come from the law and not from `rfl`.
9. **Docstrings.** Fix each one the readers named. The module docstring says, in this order: the model; the one relation with two ends (`after_alike`: the way reads the level only through which needs it meets; `left_of_taken`: the level reads the way only through what it takes) and that each end alone holds with no stock; which laws need both and the stock (`rise` with `need_unmet`, `line_ends`, `fall`, `taken_below`, `unending_iff_holds`); the three cases per unit; what is given and not derived (needs, uses, offspring, the giving and its bounds); what is not here.

## What I need back

- Both files' paths and line counts (and `WayOfUnits.lean`'s before); the last build log's path and closing lines; that every axiom report is empty; `diff` of the `WayOfUnits` copy against the tracked file summarised: which statements changed (must be none), which proofs changed, what was added.
- For each numbered item: theorem names and statements verbatim as they stand, or why an item is not there.
- Which existing laws (not only definitions) of `RegimeMargin`, `TurningInTime`, `SelectionTerm`, `Flow`, `Prelude` each proof now rests on.
- Anything changed from this brief and why; anything false as written, with its countermodel; every premise not needed.

## Hard rules

No edit outside SCR and your notes folder `/Users/ren/theories/tmp/r7/one-model/check/round9/implementer-A2/`. No git command that writes; never `git prune`, `git gc`, `git clean`. No test suite, no gate, no core run. This Mac is shared and always busy: one Lean build at a time, in the background with a log; a timeout under load is rerun once alone before it is called a failure.
