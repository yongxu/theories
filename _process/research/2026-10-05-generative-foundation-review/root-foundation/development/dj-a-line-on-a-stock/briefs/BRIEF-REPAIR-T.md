# Brief: repair of the lock pass in `TurningInTime` (in scratch only)

*AI-written (Fable, holding the design; board row DJ), 16 November 2026. For the implementer. Two readers who did not write the pass read it; their reports are `reader_C_premises` and `reader_C_attack` in `/Users/ren/theories/tmp/r7/one-model/check/round9/passes-review.json` (read both whole first, and `implementer_C`). They found no false statement and no wrong number. They found a loose bound, a proof longer than its fact, and tellings that say more than the statements. The person who directs the work wants a map that is joined and simple: each thing said once, and each sentence saying exactly what is there.*

## The task

Edit `SCR/Becoming/TurningInTime.lean` (SCR = `/Users/ren/theories/tmp/r7/one-model/lean-scratch/`). Every statement that is in the tracked file `PKG/Becoming/TurningInTime.lean` stays byte for byte (PKG = `/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/`); what the pass before added may change. Touch no tracked file. Land nothing.

- Build, from PKG, in the background, with a log: `LEAN_TIMEOUT=3600 python3 -B scratch_build.py /Users/ren/theories/tmp/r7/one-model/lean-scratch/ Becoming.TurningInTime > /Users/ren/theories/tmp/r7/one-model/lean-scratch/buildRT-<N>.log 2>&1`. Build `Becoming.TurningInTime` only: `LineOnAStock` rests on names you change and is repaired by the next pass. One build at a time; before each, `uptime`, and `ps` for a `lean`, `scratch_build` or `check_becoming` still alive. Never run `check_becoming.py` with any flag.
- Not allowed: `omega`, `simp`, `funext`, `Classical`, `propext`, `native_decide`, `sorry`, any axiom. `decide` only on small closed facts. No warning.

## What to do, in this order (keep the file green after each)

1. **The shared fact, said once and public.** Three private helpers of the pass before are needed by the next module too. Make them public theorems with docstrings that say exactly what they prove, and state the fact both modules rest on:
   - `kept_within` as it is (public).
   - `rises_from` asked only for the first `n` steps: `(rises : ∀ j, j < n → use (Law.orbit alone w j) < use (Law.orbit alone w (j + 1))) : ∀ j, j ≤ n → j ≤ use (Law.orbit alone w j)` (or the form you find plainest).
   - New, public:
     ```lean
     theorem rising_takes_all {alone : W → W} {giving : Nat → Nat} {use : W → Nat} {hi : Nat}
         (nothing : RegimeMargin.FromNothing giving) (keeps : RegimeMargin.Keeps giving 0 hi)
         {w : W} {x : Nat} (high : x ≤ hi)
         (rises : ∀ j, j < hi → use (Law.orbit alone w j) < use (Law.orbit alone w (j + 1))) :
         (Law.orbit (asItWas alone (fun w x => RegimeMargin.step giving (use w) x)) (w, x) (hi + 1)).2 = 0
     ```
     Route: every level of the course as it was is at most `hi` (`kept_within`); the use at step `hi` is at least `hi`; so the use there takes the whole level and, with nothing given from nothing, the next level is nothing. State also, if it is one more line, the step where the use first is at least the level (`∃ j, j ≤ hi ∧ level j ≤ use j`), since that is what "the use comes to take all" means in the statement.
2. **`ends_with_net_rising` with the bound that is reached.** Conclusion `∃ n t, n ≤ hi + 1 ∧ …` as before otherwise; premise `rises` asked only for `j < hi`. Prove it from `rising_takes_all` and `ends_of_below` at `N := hi + 1` (the level there is nothing, below the positive need). Delete `short_of_keeps` and the `regime_levels` and `Optimum.ends_within` route if nothing else uses them. `locked_ends_rising` follows with `n ≤ hi + 1` (`more` stays state-wise). `Three.rise_count_ends`: the law's instance then gives `n ≤ 12 + 1`.
3. **`count_rises`: ask only what is used.** In place of `locked : Locked M favours hA (w.1, w.2.1)` take `fav : favours w.2.1`, if the theorem is then still what `locked_ends_rising`'s `more` needs (in `Three.rise_count_ends` pass the first half of the lock). Its docstring says that the share's order and the reading are not used.
4. **The correction on the share, composed.** The readers found that no statement joins the `T` of `locked_turns_in_time_share_iff` (a step of the course as it was) to the `T` of `share_corrected_stays` (a step of the pair's course). Prove the join as one corollary: under the premises of `locked_turns_in_time_share_iff`, where its right side holds at `T`, for every `k` the configuration at step `T + 1 + k` of the pair's course from `(w, x)` has a `Low` share and a `kept` rule (the pair's course agrees with the course as it was up to `T` by `agrees_until_marked` with `window_share_alone_outside`, so its level at `T` is in the band; then `share_corrected_stays`). Name it plainly. If `windowAfter` reading at every step is `windowAfterShare` at `sA p g := fA p.1 g` by a proof of a few lines, state that too (then the old window is a case of the new one); if not, say what obstructs.
5. **`Three.rise_count_ends`: where the overdraw of the old kind begins.** The readers computed that from step 4 of that course (way `(7, true, 4)`, level 12) the premises of `locked_ends_with_net_regime` are met with `H = 7`, `y = 6`. If it is cheap, add conjuncts that say so in Lean: `RegimeMargin.Short giving 7 6`, `7 ≤ drawerUse (7, true, 4)`, `12 < 7 + 6`. Check by your own computation first.
6. **Docstrings and the header, each read against its statement.**
   - No docstring says or implies that a law here *concludes* an overdraw or a point of no return passed. `ends_with_net_rising` concludes an ending within `hi + 1` steps; what is asked in place of a floor on the use and a start below a point of no return is a cap on the level (`keeps`, `high`) and a rise of the use for `hi` steps (`rises`), both given. Title it by what it states, for example "A use that rises against a level that cannot pass `hi` ends the line within `hi + 1` steps."
   - `locked_ends_rising`: `more` does not ask that the use read the share or the rule (a use that reads only the step count meets it with the share never moving: the reader's case). Say that; "the rise of the use with the share" is `count_rises`'s case only.
   - `Three.rise_count_ends`: `Raises` and `ReadsShare` keep the rule favouring; the strict rise is `count_rises`'s own premise `rise`. Say what the conjunct about the start states (no `H ≤ 3` and `y` with `Short` put 12 below `H + y`) without "cannot be met from this start" unless you add the one-line inference; say from which step the old law applies (item 5, in Lean or "by computation").
   - `share_corrected_stays`: say only what it states (the pair's total course, any `left`, any start; nothing of the level, the use, or whether the net goes on). `locked_turns_in_time_share_iff`: it is `turns_in_time_iff` at the kept kind `Low ∧ kept`; the correction reaches the share because the reading sets it (`sets`, given), not because the share falls under the corrected rule; the overdraw of the course as it was is still given there (`draws`, `below`). Only the "if" side has a worked case.
   - Every "What stays given" list is complete or is not there.
   - The header: the old sentence "nothing here derives an overdraw from a lock, or that the use depends on the share or the rule" and the paragraph added after it now disagree unless both are read. Re-say that place once, so that one reading is true: in `locked_ends_with_net_regime` and `locked_ends_on_window` the start below `H + y` and the floor on the use are given; in `locked_ends_rising` neither is, and a cap on the level and the rise of the use at each step of the lock are given instead; no law here concludes that the use depends on the share or the rule. Remove "Added after the above". Add the new laws to the list "What this module adds" and to section 6's docstring in the style of their neighbours. Keep true what is still true ("a share that falls under the rule the window reads … is not tried").

## What I need back

- The new and changed declarations' names and statements verbatim; which existing theorems each rests on.
- `diff` of the tracked file against the scratch file: its shape (which hunks; which removed lines, and that each removed line is docstring or header text, never a statement that was tracked).
- The last build log's path and closing lines; that every axiom report is empty.
- Anything changed from this brief and why; anything false as written, with its countermodel; every premise not needed.

## Hard rules

No edit outside SCR and your notes folder `/Users/ren/theories/tmp/r7/one-model/check/round9/implementer-RT/`. No git command that writes; never `git prune`, `git gc`, `git clean`. No test suite, no gate, no core run. This Mac is shared and always busy: one Lean build at a time, in the background with a log; a timeout under load is rerun once alone before it is called a failure.
