# Check lean-1: first path steps 1–7, their arrows, boxes and cast, against the Lean

*AI-written, 13 November 2026. Read only; nothing run. Lean paths are under `.../lean/becoming/Becoming/`.*

## Serious

**S1. === box b3.inside (says_en).** NEW: "A loss that makes no difference to either can grow without limit while nothing in the loop changes." "Either" covers the rule and how it is set. It leaves out what is selected next. `lock_outlives_loss` (ClosedCapture.lean:307) holds only on `join`, where the share's next value reads the share alone (:220). `Borne.onShapers` (PoolFromCourse.lean:727–728) is read through `joinRead`, so the loss changes neither the rule nor how it is set. But the loss enters the share, and the lock is left at step 4 (`Borne.shapers_left`, :753). The OLD box ("a loss nothing inside reads") covered the selection. SAYS LESS (a premise dropped), so the sentence is untrue. "Nothing in the loop changes" was already loose: share and rule may rise (`locked_rises`), and what is proved is that the loop runs as it would with no loss (`join_course`, :248).
*Fix:* "A loss that makes a difference neither to what is selected next nor to how the rule is set can grow without limit while the loop runs as it would with no loss."

**S2. === arrow bs.costs>bs.pays (en).** NEW: "What all get equally makes no difference." In the new words, "makes a difference" means the Lean's dependence. The shared part does change the rule: `shared_lowers` and `shared_lowers_strictly` (RuleShaping.lean:182, 200) make it strictly lower where c < s, and across a stretch it can turn the verdict (`SharedFlips`). `favours_alike` (:175) keeps only the direction at the step. SAYS MORE.
*Fix:* "What all get equally makes no difference to which side the rule favours at that step."

## Smaller

1. **=== path lock step 6.** "however far a loss grows that makes no difference to the share or the rule." This leaves out how the rule is set. `both_reads` (ClosedCapture.lean:425–427) puts the reading `Q` into the locked pair, and `Locked` of the pair (:441) bounds `Q` too. A loss read only by `mind` can unlock the pair. SAYS LESS. *Fix:* use step 3's condition: "however far a loss grows that makes a difference neither to what is selected next nor to how the rule is set." The added "from a locked start" is right: the OLD lacked it, and `lock_outlives_loss` needs it.

2. **=== path lock step 7 (second sentence); === arrow bs.pays>b3.inside.** Step 7: "a start at which it covers the cost". The arrow: "that return covers the cost". In step 7 the "it" points back to what comes back to the shapers alone (`s`). `drawn_locks` (DrawnShaping.lean:333–334) takes `lo ≤ hi` and `favours (drawn … x)`. That premise is the return as the readers together judge it, each kind counted by its numbers (`drawn_favours_iff`). The start's rule is also the one read there (`drawnCourse`, :156), and OLD and NEW both leave this out. SAYS SOMETHING ELSE, and OLD WAS ALREADY LOOSE. *Fix (both):* "a start, under the rule set there, at which the return as those the rule is set from judge it together covers the cost, is locked."

3. **=== path lock step 7 (first sentence).** "exactly where" SAYS MORE than OLD ("wherever"), but it is exact to `favours_iff` (RuleShaping.lean:160: weak favour ⟺ c ≤ s). Keep it. It is listed so the change is seen.

4. **=== path lock step 5; === arrow b3.gone>b3.inside.** "provided what is used up never lowers the favoured side's share". `closed_stays_closed` (PoolFromCourse.lean:222) takes `Raises (liftShare P)`: under a favouring rule the whole step, the loss with it, does not lower the share. It also takes `ReadsShare`, `upper`, and a lock under the rule read off the share. In `window_locked_after_removal` (:342) the clause holds automatically (`joint_raises`, :278), and the premise is `Raises` for the share's own selection. OLD WAS ALREADY LOOSE. Step 2 now names Raises, so name it here too. *Fix:* "provided selecting under a rule that favours that side, with what is used up, never lowers its share".

5. **=== arrow b1.held>b2.uncounted (en).** (a) "so from a locked start it stays": `lock_outlives_loss` also takes `Raises`, `ReadsShare` and `upper` (ClosedCapture.lean:309–310). *Fix:* "so from a locked start, under step 2's premises, it stays". (b) The last sentence is `window_order_kept` (PoolFromCourse.lean:465–472). That theorem is about the window course with N = 0. Its premises are `selects`, `drains`, `ReadsShare`, `monoL` and `against`. Its starts are no lower in share, loss and rule, with the readers' bound no higher. Its conclusion is that share, loss and rule are no lower at every step. The sentence mixes up `drains` with `selects` and drops `monoL`, `against` and the window. OLD WAS ALREADY LOOSE (check-L1, smaller 3). *Fix:* "Where those whose judgment the loss changes stand until it reaches a bound, and it is also a premise that a share, loss and rule no lower select a share no lower and use up no less, and that their judgment rises with share and loss and is never more for the favoured side than the share's: a course that starts no lower in share, loss and rule, its judges removed no later, is no lower in all three at every step."

6. **=== box b3.gone (says_en).** "so it comes out the same as if nothing were missing". If the removed still stood, the rule read would be `hL` (windowRead, PoolFromCourse.lean:252–253). What is proved is that it comes out as the share alone gives it (`window_past_course`, :314). Read as "as if none were missing", the sentence is false. SAYS SOMETHING ELSE. *Fix:* "so it comes out as it would if nothing had been used up."

7. **=== box b1.held (says_en).** "is undone at the next update". `perturbation_absorbed` (RuleCapture.lean:258–261) gives a rule no lower than before the push and a lock again. It does not give the old value, and any share the push moved in between stays (`Reversed.not_absorbed`). OLD WAS ALREADY LOOSE ("taken back"). *Fix:* "is absorbed at the next update: the rule is set again from the share, no lower than before the push, and locked again."

8. **=== path lock cast 1.** "each step says which: the share it already favours, or judgments". In steps 8 and 15 the rule is set from whether each keeps going (cast 7). OLD WAS ALREADY LOOSE. *Fix:* add ", or whether each of those it is set from keeps going".

9. **=== path lock cast 4.** NEW drops "of what it picked". In steps 7, 9 and 14 the judges are drawn from what is selected and counted as the population counts them (`Drawn.pool`; DrawnShaping.lean:146). SAYS LESS. *Fix:* "Where the rule is set from the judgments of what it has selected (steps 7, 9 and 14) …"

10. **=== box bs.costs / bs.pays (says_en).** "so its share falls" and "rises where it returns more" are strict, and they hold only with the shapers present (`drawn_rises` takes `some`, :406). OLD WAS ALREADY LOOSE. *Fix:* add "the shapers present".

## Asked in particular

- **Step 2 and its arrow, Raises.** Raises was missing before: `uniform_locks` (RuleCapture.lean:294) and `readers_uniform_locks` (ClosedCapture.lean:470) both take `raises` (def :145). It is now stated right. ("A side" is read for every side, a stronger premise, so the claim is not overstated.)
- **Step 3, join/joinRead.** "makes a difference neither to what is selected next nor to how the rule is set" is exactly `Unread` (ClosedCapture.lean:131), which is equivalent to the join form (`courses_alike_iff_unread`, :202). "Runs the same" needs no locked start (`join_course`, `join_alike`). Staying needs one, and the arrow now says so.
- **"share" for "lead".** It is the same quantity in every sentence: `P` on `A`, which on counts is `CarrierCounts.order`, the ratio of carriers to others. Cast 3 loses nothing by dropping "lead".

## Checked and found exact

=== path lock step 1; === path lock step 2; === path lock step 3; === path lock step 4; === arrow a1.over>b2.uncounted (tag_en, en); === arrow b1.swing>b1.held (en); === arrow b1.held>b2.uncounted (tag_en); === arrow b2.uncounted>b3.gone (tag_en, en); === arrow b3.gone>b3.inside (tag_en); === arrow b1.held>b3.inside (tag_en, en); === arrow bs.pays>b3.inside (tag_en); === stay b3.inside (`lock_outlives_loss` instantiated on the pair through `both_reads`, `byRule_raises`, `both_upper`); boxes b2.uncounted, b1.swing, b1.held, b1.outside, b3.gone, b3.inside, bs.costs, bs.pays (en); === box b2.uncounted, b1.swing, b1.outside (says_en); === path lock cast 0, 3, 5, 8.
