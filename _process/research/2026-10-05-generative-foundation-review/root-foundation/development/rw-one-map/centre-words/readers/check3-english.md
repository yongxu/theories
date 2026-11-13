# Check 3, English: the third version against the four reports and the Lean

*AI-written, 13 November 2026. Read only; nothing run. Lean paths are under `.../Becoming/`.*

## Still to change (7 NEW sentences, and 3 unchanged ones)

1. **box b3.gone (says_en), new second sentence.** "A measure taken only among what is left passes whatever was removed". `survivorsPersist_of_settled` (ReadingsPersist.lean:569) takes `settled`: from some step on, every line either persists or is no longer alive. Without it, a surviving line that does not persist fails the measure. This arrow's own sentence (b3.gone>b3.list) says "once the course settles". SAYS MORE. *Fix:* "A measure taken only among what is left passes once the course settles, whatever was removed, and the rule…".
2. **step 15, second sentence; arrow b2.uncounted>a2.ended, first sentence.** "whenever it is higher on what the rule goes by". `Rising` (Optimum.lean:550) ranks o' above o where o' `Exceeds` o (:545): lower at no condition of the family and higher at one. If "higher on" is read as "higher on each", the premise is weaker than `Rising`, and an order ranking only such pairs can have an optimum that is not at the least level. *Fix:* "whenever it is higher at one of the things the rule goes by and lower at none".
3. **step 15 (same sentence, last clause); arrow a2.ended, second sentence.** "ends where that level is below its need" / "is cut off if, and only if". `optimum_broken_iff` (:722) takes `met` (MetOn: the need was met before the step, DrawnBeyond.lean:96). `Broken` (Dependence.lean:146) holds only if the need was met at t. 2b's finding 5 named this, and it was left. SAYS MORE. *Fix:* "what lives on one of them, its need met before the step and still needing it, ends…"; in the arrow, "What lives on one of them, its need met before the step, is cut off if, and only if…".
4. **arrow b2.uncounted>a2.supplied, second sentence.** "the best outcome takes exactly the spare" leaves out `rising` (`keeping_optimum_takes_slack`, Optimum.lean:814). Step 15 and a2.ended now state that premise; this sentence does not. SAYS MORE. *Fix:* "Where also the rule ranks an outcome above another whenever it is higher at one of the things it goes by and lower at none, the needs were met before the step…". Step 13 carries the same gap under its "further premise" mark.
5. **sheet lead_en, first sentence; path lock want_en, first sentence.** Both say "people and AI", and "people" is a barred word. *Fix:* "humans and AI", which is AGENTS.md's own phrase.
6. **Unchanged, barred words.** Step 2's example ("people learn it … people learned it") → "typists learn it … typists learned it". Step 8's example ("residents downstream who now sit") → "residents downstream now sitting". Step 12's example ("those who dropped out") → "those that dropped out". THE-MAP.v3 lines 99, 144, 148, 153 and 154 also use "who": "others that pick", "The person directing the work", "a second AI reader, which corrected…".

**Exact on one reading; the change is advised.**
- Cast 6, second sentence: "can differ" can be read as "does differ". The first sentence says "the model lets", so use the same words: "Where the model lets no judgment in the pool differ with the loss, none counts it."
- Step 6: in "as long as it changes", the "it" can be taken for the lock. Use "provided the loss changes".
- Arrow b1.held>b2.uncounted, second sentence: `window_order_kept` has N = 0. Say "stand, counting it from the start, until it reaches a bound".
- Step 9: `past` is `N ≤ loss`, so "at or past the set amount" says the same thing as the Lean.
- Arrow b3.rest>b2.felt: "either does or does not tell the two apart" stands for `decided`, which a classical reader sees as no premise. Say "for each of which it is decided whether it tells the two apart".

## Asked in particular

- **Cast 6** is true of all three models. In Thinned's `lossPool` (ClosedCapture.lean:785) and in ReadInTime, the others read `v`/`lo` below N and `w`/`lo'` from N, and `lo = lo'` is allowed. In PoolFromCourse's `windowRead` (:252), the readers read `hL` in [N, K) and are gone from K. In Drained (N = 0) they read `lo` against the carriers and are drained out (`strong_undone`). The shapers' `hi` does not vary, so the definition does not cover every judge.
- **"None counts the loss" against removal.** Removal is `¬ Stands K`, the loss at or past K. Past K, `window_past` gives the share-readers' rule whatever the loss, and `window_removed_unregistered` gives it whatever `hL`. So at a removal no judgment in the pool can differ with the loss, and cast 6's "none counts it" holds. With Drawn pools, "gone" means the others read `v` again with their count unchanged (:52–53), and that is still "none counts". Step 5 rests on `closed_stays_closed`'s abstract `¬ present` with `ReadsThroughPresent`, and box b3.gone's "or were never in the pool" covers `window_never_read`. Both are consistent.
- **Cast 9's list (5, 6, 9, 14) is right.** Step 5: `window_locked_after_removal` and `window_removed_unregistered` take `Accrues`, `closed_stays_closed` does not. Step 6: the stay's `lock_outlives_loss` takes it, the `same` arrow's laws do not. Step 9: all three `turned_iff`/`kept_iff` take it. Step 14: `kept_iff` and `Thinned.kept_iff` take it, and `kept_early_iff`/`kept_once_favoured` have it built in (`lossCourse`, :209). Steps 2, 7, 8 and 15 take none. Step 10, `turned_by_loss`, takes it but is marked.
- **Step 9** is exact to `turned_iff` (:185): `accrues`, `at_r`, `at_next`, `past`, `dis`; "for good" with `readers`. "The rule turns" needs only `rule_read`.
- **Arrow b1.held>b2.uncounted.** In the first sentence, `raises`, `monotone`, `upper` and `accrues` (ClosedCapture.lean:309–310) are each said. The second sentence has `monotone`, `selects`, `drains`, `monoL`, `against`, `K' ≤ K`, the same `reads`, and the conclusion in all three.
- **bs.costs / bs.pays.** `disfavours_iff`/`favours_iff` (RuleShaping.lean:160, 167). With s < c the disfavour is strict, so "favours the others" holds, and `falls_strictly` takes `some`. For bs.pays, "favours them" is the weak favour, as the lock uses it everywhere.
- **Legend.** `soft` (map_sheet.py:477) reads the step's first reference. On every step drawn, that equals the first arrow, since no step puts a box first and a soft arrow after it. Exact as drawn.

## Report findings: fate

**1b.** S1 taken in other words, exact. 1 and 2 taken exactly. 3 taken exactly. 4 taken, but the new clause lacks `settled` (item 1). 5 taken (bs.costs, cast 8). 6 taken exactly.

**2b.** 1 taken exactly. 2 taken (step 9). 3 taken in other words ("counts in"). 4 taken in other words (cast 6's second sentence; "changes no judgment"). 5: the order premise is taken in other words, ambiguously (item 2); `met` is left (item 3); a2.supplied's order premise is left (item 4). 6 taken; `kept'` left, as old. 7 taken. 8 taken; `lo ≤ hi` and the favoured start left, as old. 9 taken. 10 taken.

**3b.** S1 taken exactly. S2 taken in other words, exact. S3, S4 and smaller 1, 4 and 11 are in the fronts, which are not in this change set: left. 2 taken. 3 left, not untrue: the lead says only "turns". 5 taken. 6: en exact, zh taken. 7, 8, 9 and 10 taken.

**Cold-2.** S1 taken. S2 taken for the lead and step 1; front centre left. Stops 1, 3–7 and 9–15 taken (8 in part: "it"; the test notes' "turned the judge" and "chose prose" left; "no anchor in the Lean" left). Stop 2 taken except "come to count" in step 18. Questions: 1, 4 and 5 taken; 2 ("get back") left; 3 taken in other words. Fronts left.

## Found exact

Lead (bar "people"); boxes b2.counted (en, says_en), b1.held, b1.outside, bs.costs, bs.pays; path lead_en; casts 4, 5, 6 (with the wording note), 7, 8, 9; steps 1, 2, 4, 5, 7, 8, 9, 11, 12, 14, 16, 17, 18; step 15's first sentence; shows 3 and 4; want_en (bar "people"); arrows b1.held>b2.uncounted, b3.rest>b2.felt, b3.inside>b2.counted more 0, b2.felt>b2.heard, b2.uncounted>a1.past, b2.counted>b3.gone, b3.inside>b3.checkers, b3.checkers>d2.handed (both); a2.supplied's first sentence; the legend sentence.
