# Brief: last fixes before the landing (in scratch only)

*AI-written (Fable, holding the design; board row DJ), 16 November 2026. For the implementer. Three readers who did not write the repair read it; their reports are `readR:lock`, `readR:line` and `readR:smaller` in `/Users/ren/theories/tmp/r7/one-model/check/round9/repair-review.json` (read all three whole first; each finding gives lines and the Lean quoted). They found no false statement and no wrong number. What is left is below. These four files land as they stand after this pass, and their docstrings become the telling: each sentence says exactly what its statement says.*

## The task

Edit the four scratch files under SCR = `/Users/ren/theories/tmp/r7/one-model/lean-scratch/`: `Becoming/TurningInTime.lean`, `Becoming/LineOnAStock.lean`, `Becoming/WayOfUnits.lean`, `Becoming/LineOnAStockCases.lean`. All four build with every axiom report empty and no warning. Touch no tracked file. Land nothing. No statement that is in the tracked `PKG/Becoming/TurningInTime.lean` or that remains in the tracked `PKG/Becoming/WayOfUnits.lean` changes (PKG = `/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/`); proofs may.

- Build, from PKG, in the background, with a log: `LEAN_TIMEOUT=3600 python3 -B scratch_build.py /Users/ren/theories/tmp/r7/one-model/lean-scratch/ Becoming.TurningInTime Becoming.LineOnAStock Becoming.WayOfUnits Becoming.LineOnAStockCases > /Users/ren/theories/tmp/r7/one-model/lean-scratch/buildR2-<N>.log 2>&1`. One build at a time; before each, `uptime`, and `ps` for a `lean`, `scratch_build` or `check_becoming` still alive. Never run `check_becoming.py` with any flag.
- Not allowed: `omega`, `simp`, `funext`, `Classical`, `propext`, `native_decide`, `sorry`, any axiom (core's `Nat.sub_eq_zero_of_le` brought `propext` in once: use the Prelude's). `decide` only on small closed facts.
- Before the first edit, copy the four files as they stand into your notes folder.

## A. `TurningInTime.lean`

1. **`ends_with_net` as a case of `ends_of_below`.** The body of the private `ends_of_below` repeats `ends_with_net`'s match line for line. Prove `ends_with_net` (statement untouched) from `ends_of_below` at `N := s.2` with `Optimum.ends_within`, if that is shorter; `ends_of_below` then stands before it. Report the lines before and after.
2. **Docstrings, each against its statement** (the lock reader's findings, with lines):
   - `share_corrected_on_course`, bold title: "from the step after the first step the window reads", as its body and the header say.
   - Header near 220: the law's instance gives an ending within `12 + 1` steps; that the line has seven steps is a separate computed conjunct. Say both, apart.
   - `Three.rise_count_ends`: the old law's premises are excluded in Lean at step 0 only, and met at step 4 by three conjuncts (`draws` and the lock there are argued). "The four steps before, held at twelve, are what `locked_ends_rising` adds here" says more: say what is in Lean and mark the rest "by computation, not a Lean statement" (the reader recomputed steps 1 to 3).
   - Header near 310: the list of laws in which `below` and `draws` are given names `locked_turns_in_time_on_window_iff` too.
   - `count_rises`'s title and section 6's docstring: "raises strictly" (in this module `Raises` is the weak relation, under which `count_rises` fails).
   - `rising_takes_all`'s title: its statement is that the level after `hi + 1` steps of the course as it was is nothing. That the use is at least the level at some step up to `hi` is `rising_meets_level`; say so there.
   - `locked_ends_rising`: the remark that a use reading only the step count meets `more` with the share never moving is argued, not a Lean instance; mark it.
   - Header near 140 and `locked_ends_with_net_regime`'s docstring (tracked text): "The lock keeps an overdraw that stands; it does not bring one about" is scoped to that law ("there").

## B. `LineOnAStock.lean`

1. **The central law, said with the premise that makes it true.** `need_unmet` stays as it is. A reader found that without `down` its unmet need can be a kid's higher need at a level that never fell (`a` = need 1, use 1, kids `[b, b]`; `b` = need 13, use 1, kids `[b, b]`; `min z (12 - z)`; from `([a], 12)`: step 1 is `([b, b], 12)`). So its docstring's sentence about using up what it rests on says more than the statement. Do three things.
   - Add a corollary, with `down : ∀ u v, v ∈ kids u → need v ≤ need u` added to `need_unmet`'s premises (name it plainly, for example `falls_to_unmet`): the same conclusion with one more conjunct, `(course need kids giving use (w, x) n).2 < x` (the level at the first unmet step is below the start level), or, if it comes as cheaply, the finer one: some unit of `w` whose need the start met needs more than the level at step `n`. Route: the unmet unit is in `generation kids n w`; with `down` its need is at most the need of a unit of `w` (the file's `generation_below` or its like); that need was met at the start.
   - Its docstring says exactly: up to the first unmet step the way at step `j` is `generation kids j w`, in which no giving, use or level appears: it is the way of every course from `w` on which every need is met until then (`way_while_met`, or the one name item 3 keeps); what it takes rises at each of those steps (`generations_rise`); and at that step, within `hi + 1`, the level has fallen below a need the start met. Then one sentence, marked as a reading: this is the model's form of a going-on that draws down what it rests on while nothing in it yet differs. Given, not derived: the needs, uses and offspring; that each unit's kids together take more (`grows`); the cap (`keeps`, `high`); `down`.
   - `need_unmet`'s own docstring: remove the "uses up" sentence; say that `down` is not asked and that the unmet need may then be a kid's greater need at a level that has not fallen, with the reader's instance as a closed kept case if it is a few lines (check it by computation first), else "by computation, not a Lean statement".
   - The module docstring's bullet: title it by what is stated (a way whose kids take more comes to an unmet need within `hi + 1` steps, the way until then not depending on the stock; with `down`, the level by then below a need the start met). Do not say an alikeness law is in the proof: the proof goes through `after_of_met` and `course_asItWas`.
2. **Two stale names.** The docstrings of `met_or_unmet` and `mem_of_ne_nil` say "`WayOfUnits.…` is its case"; those were removed from `WayOfUnits`. Remove the sentences.
3. **One fact, one name.** `way_generation` and `way_while_met` conclude the same; keep one (the one the proofs use, under whichever name reads better), delete the other, and make every docstring cite the one kept.
4. **`one_need_ends`'s docstring**: "With needs that differ, `way_ends` (no bound on the step) holds instead" leaves out that `way_ends` also asks `down`; the file keeps the countermodel (`KidsNeedMore.all_but_down`). Say it.
5. **The module bullet for `unending_iff_holds`** names every premise the theorem takes (`nothing`, `high` and "some need met at every step before" among them), and says of `TwoForOne` what is in Lean: only `P`'s offspring are not itself, the course is fixed from step 1, and the instance uses the "if" side at `k = 0`.
6. **`after_append`**: its docstring says what it states (the way after a step of two ways side by side is the two ways after it, side by side); "they reach each other only through the level" is a reading: mark it so, or drop it.
7. **`NothingTakenEnds.ending_differs`**: the docstring's course values are not conjuncts: add them as conjuncts if each is `rfl`, else mark "by computation".
8. **Said twice, fold if shorter** (report lines before and after; leave and say so if not shorter): `allKids_rises` from `rise` at the line of every unit; `step_overdrawn`'s first disjunct from `RegimeMargin.step_falls_by`. Say in the docstrings of `ends_high` and `need_unmet` that the two rest on the same arithmetic (a take that rises against a capped level) in two settings, and that only `need_unmet` and `one_need_ends` rest on `TurningInTime.rising_takes_all`.
9. `grows` is asked of every unit of the type while `needs` is asked of the descendants of `w`: say so where both are premises (do not change the statements).

## C. `LineOnAStockCases.lean`

1. **Say what the law adds, which is not the ending.** Two readers found that each ending conjunct already follows from the example's own Lean, which the equalities take as input (`LineageRegimes.MultiplyingTakers.inactive` at step 2; `LineageDrawdown.Drain.familyP_eq` from step 10). Keep the statements. Re-say the titles and docstrings (module docstring too): what is shown is that the example's sizes and levels (and the other things equated, each named) are those of a course of this model on which the premises of `way_ends`, or of `fall`, hold; the law's conclusion read back gives nothing about the example that its own Lean did not already give, and the size equality at the late steps itself takes the example's ending as input. Not "the law `fall` ends its family".
2. `need_agrees` has no term of `Drain` in it: say so (Drain's own need, one, is read from its source, not stated here).
3. Replace the local `nil_of_length` by `Becoming.nil_of_length_zero` (Prelude near 1026).
4. One sentence in the module docstring: `ReadingsSpread.Commons` was not tried.

## D. `WayOfUnits.lean`

1. `unending_of_fixed` repeats `LineOnAStock.unending_of_fixed`: derive it through the bridge if shorter; else leave and say so.
2. The module docstring's bullet on what rests on `LineOnAStock`: check it against the file as it stands (six derived: `unending_iff_holds`, `fixed_while`, `unending_taken_below`, `course_fixed`, `goesDecidable`, `step_falls`; `takes_nothing_iff_alone` not).

## What I need back

- The four files' line counts before and after; the last build log's path and closing lines; that every axiom report is empty.
- For A1, B1, B3, B8, C3, D1: names and statements verbatim as they stand, lines before and after, or why not done.
- For every docstring item: the sentence as it now stands, verbatim.
- That no tracked statement changed (script over headers up to `:=`, for `TurningInTime` and for the declarations remaining in `WayOfUnits`).
- Anything changed from this brief and why; anything false as written, with its countermodel.

## Hard rules

No edit outside SCR and your notes folder `/Users/ren/theories/tmp/r7/one-model/check/round9/implementer-R2/`. No git command that writes; never `git prune`, `git gc`, `git clean`. No test suite, no gate, no core run. This Mac is shared and always busy: one Lean build at a time, in the background with a log; a timeout under load is rerun once alone before it is called a failure.
