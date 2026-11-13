# Check 2, lean-1b: first path steps 1–7, their arrows, boxes and cast, NEW against the Lean

*AI-written, 13 November 2026. Read only; nothing run. Lean paths are under `.../lean/becoming/Becoming/`.*

## Serious

**S1. === box bs.pays (says_en).** NEW: "…rises where it brings back more: the shapers gain share by shaping." The gloss after the colon claims a gain. Where the return only equals the cost the rule gives each kind alike (`favours_iff`, RuleShaping.lean:160, is weak), so the share stays the same. With no shapers present nothing rises (`rises_strictly` takes `some`, RuleCapture.lean:508). The box's own name is "keeps share". SAYS MORE. *Fix:* "…: by shaping, the shapers keep their share."

## Smaller

1. **=== arrow b1.held>b2.uncounted (en), last sentence** (`window_order_kept`, PoolFromCourse.lean:465–472). (a) The premise `monotone : ReadsShare P M hA` (:468) is not named: the rule set from the share alone must be no lower for a share no lower. The first report's fix left it out too. "Also" can be read as carrying step 2's premises, but "A further theorem" reads as a fresh statement, and without the premise the claim is unproved. SAYS LESS. (b) Both courses run on one schedule `reads` (:473–477). The sentence does not say so. SAYS MORE. Everything else is now right: N = 0, `selects`, `drains`, `monoL`, `against`, `K' ≤ K` ("removed no later"), and share, loss and rule no lower at every step. *Fix:* "…where it is also a premise that the rule set from the share alone is no lower for a share no lower, that a share, loss and rule no lower leave…, the course under the same updates that starts no lower…".

2. **=== arrow b1.held>b2.uncounted (en), second sentence.** NEW: "so, under step 2's premises, from a locked start the lock stays while that loss passes every bound." `lock_outlives_loss` (ClosedCapture.lean:309–311) takes `raises`, `monotone`, `upper` (a rule no lower than one that favours also favours) and `accrues`. It does not take `uniform` ("every update favours the same side"). Step 2's premises bring in `uniform`, which the theorem does not need, and leave out `upper`, which it does need. The claim is still true with `uniform` in place of `upper`, but no Lean statement says that. SAYS SOMETHING ELSE about the premises. Report 1's 5(a) was taken in these words. *Fix:* "so, where being favoured never lowers the share, the rule set from the share is no lower for a share no lower, and a rule no lower than one that favours a side favours it too, from a locked start the lock stays…".

3. **=== box b1.held (says_en).** NEW: "absorbed at the next update: the rule is set again from the share, no lower than before, and locked again." `perturbation_absorbed` (RuleCapture.lean:258–261) gives `M.le g …`, where g is the rule before the change. A reader can take "before" to mean just before the update, that is the changed rule g'. For an upward change (g' above g) that reading is unproved. Report 1's fix said "before the push", and NEW dropped those words. SAYS MORE on one reading. *Fix:* "no lower than before the change".

4. **=== box b3.gone (says_en).** NEW: "so nothing is recorded as missing." Report 1's finding 6 was not taken, and that was sound: its fix ("as it would if nothing had been used up") would have been false. With nothing used up the loss is below K, the readers stand, and the rule read is `hL` (`windowRead`, PoolFromCourse.lean:252–253). NEW keeps OLD's gloss ("nothing shows as missing"), and no statement speaks of a record. STILL LOOSE AS OLD. *Exact replacement:* "so the rule read is the one the share alone gives, whatever the removed would have judged" (`read_absent` :141, `window_past_course` :314, `window_removed_unregistered` :332).

5. **=== box bs.costs (says_en); === path lock cast 8.** "Shaping the rule to favour the shapers more" and "spends to make the rule favour it more" give the shaping an aim. In `shaped` (RuleShaping.lean:146–152) shaping costs c and brings back s. In bs.costs, s < c, so the rule after shaping favours the others. STILL LOOSE AS OLD. *Fix (bs.costs):* "Shaping the rule costs the shapers more than comes back to them alone, so the rule after it favours the others and, where any shapers are present, their share falls." *(cast 8):* "what bears a cost to shape the rule, part of what that gives coming back to it alone."

6. **=== path lock step 2.** "locked from the step after its second update": `uniform_locks` (RuleCapture.lean:294–296) gives the lock *at* step r'+1 only. Staying locked after that is `locked_stays` (:182), which needs `upper`. STILL LOOSE AS OLD (the docstring itself says "from"). *Fix:* "is locked at the step after its second update".

## Findings of report 1: taken or not

S1, S2, 1, 3, 4, 8, 9 and 10 were taken exactly. Finding 2 was taken in other words ("a start at which the rule so set favours the shapers"). That wording is exact to `drawn_locks` (DrawnShaping.lean:333–334): the start is under the rule read there (`drawnCourse` :156), and `favours (drawn … x)` is the premise. Findings 5(a), 5(b) and 7 were taken, with the gaps given in smaller 1–3. Finding 6 was not taken, and that was sound (smaller 4).

## Asked in particular

- "being favoured never lowers a share" is `Raises` (RuleCapture.lean:145). Read for any share, it is a stronger premise, so nothing is overstated. Exact.
- "If the loss changes neither what is selected next nor how the rule is set, a lock runs the same" is `Unread` (ClosedCapture.lean:131) with `join_course` (:248). Exact. No lock is needed for "runs the same".
- "provided being favoured, with what is used up, never lowers that side's share" is `Raises (liftShare P)` (PoolFromCourse.lean:222, 127). Exact. As in OLD, `ReadsShare` and `upper` go unsaid.
- "a start at which the rule so set favours the shapers is locked" is exact (see above).
- The `window_order_kept` sentence is now right in direction, quantifiers and conclusion; it lacks the premise and schedule given in smaller 1.
- The box b1.held absorbed sentence is right except for "before" (smaller 3).
- "nothing is recorded as missing" is still loose as OLD (smaller 4).
- "where any are present" is right in both boxes. It matches `falls_strictly` (RuleShaping.lean:262) and `rises_strictly` (RuleCapture.lean:508).

## Checked and found exact

=== path lock step 1; === path lock step 3; === path lock step 4; === path lock step 5; === path lock step 6; === path lock step 7; === arrow a1.over>b2.uncounted (tag_en, en); === arrow b1.swing>b1.held (en); === arrow b1.held>b2.uncounted (tag_en; first sentence of en); === arrow b2.uncounted>b3.gone (tag_en, en); === arrow b3.gone>b3.inside (tag_en, en); === arrow b1.held>b3.inside (tag_en, en); === arrow bs.costs>bs.pays (en); === arrow bs.pays>b3.inside (tag_en, en); === stay b3.inside (en); === box b2.uncounted, b1.swing, b1.held, b1.outside, b3.gone, b3.inside, bs.costs, bs.pays (en); === box b2.uncounted, b1.swing, b1.outside, b3.inside (says_en); === path lock cast 0, 1, 3, 4, 5.
