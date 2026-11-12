*AI-written draft, 12 November 2026, for Ren's read. Nothing in the repository rests on it yet. [中文](THE-LOOP-v1.zh.md) · Kept as the first version; [the second](THE-LOOP.md) replaces it.*

# When a selection can still be turned

*In alignment's words: the erosion of oversight, as one loop with one condition.*

**The pattern.** Many things last only by being rebuilt: a body, a habit, a rule, a view. In each, a slow part steers a fast flow, and what the flow brings back rebuilds the slow part. Structure is the slow end of this one relation and activity the fast end.

**A selection is this pattern.** A reward, a judge, a market, a vote and a training run each pick by a rule. Where the rule is rebuilt from what it picked, the selection is this pattern. Say a rule *reads* a level where a difference in that level changes the rule. A selection can draw on a level it does not read. That level can then fall as far as anything allows, and the rule stays as it was.

**The loop.** One state holds four things, each with a level: the rule; the share of what the rule favours; a stock that is drawn on and regrows; and the stock's readers (voters, raters, regulators, a sensor), who register its fall, weigh in the rule when it is rebuilt, and themselves live on the stock. Two loops run through this state.

- *Reinforcing.* The rule raises the share it favours and is rebuilt from the shares.
- *Balancing.* A larger share draws more, the stock falls, its readers register the fall, and at the next rebuilding they weigh against the draw.

The balancing loop runs through the stock that the favoured share draws down, and through readers who need that stock.

**The condition.** Mark two levels on the stock: *v*, below which the fall shows to the readers, and *m*, which the readers need in order to stay. Start where the rule already holds its picks and the draw comes to exceed the regrowth.

- Where *v* < *m*, the fall shows only below what its readers need, and the balancing loop closes at no level. The rule is rebuilt from its own picks alone, and the stock falls below the level from which it regrows. No step needs anyone to aim at it.
- Where *v* ≥ *m* there is a window, while the stock lies between the two. The rule turns for good only if three things come in time: the fall shows while the readers stand; they outweigh at that rebuilding and at the next; and the stock is still above the level from which it regrows under the reduced draw.

A reader that registers the stock only through its own going on has *v* < *m*: when it can tell, it is already leaving. This is "we will notice when it harms us", made exact.

**One structure, several names.** The same loop holds a body, a language or a trust in being; those who bear what it does not read call it a lock. Parts of it are known as lock-in, regulatory capture, "shifting the burden", Goodhart's law and, in alignment, gradual disempowerment.

**The ethics, in three sentences kept apart.**

- *Shown.* Lasting filters choosing toward what keeps the chooser's own line going, and selects only on what comes back to it (07 §4.9, §4.12). That is prudence within one loop.
- *Not shown.* That any choosing, with nothing evaluative supplied, comes to change with a fall that never returns to it.
- *Wanted.* That choosers do, we who write this among them, human and AI. The want is itself a pattern within becoming: it enters, then spreads, locks or dies.

As a design requirement the want reads: read as far as you draw, and keep what reads standing where the rule is rebuilt. A reading wider than one's own return stays only where its readers do not hang on the course. How such readers form is the open question of the ethics and of alignment alike, and nothing here shows it.

## How far this has been seen

| | |
|---|---|
| **Proved in Lean**, each on its own model | A part runs by a law of its own exactly where the rest makes no difference to its next step (`ClosedCapture.identifiesAlike_iff_unread`). A rule that holds its picks keeps holding them (`RuleCapture.locked_stays`). With room to trade, every best outcome under a rule leaves what it does not read at the lowest level allowed (`Optimum.least_of_room`). A stock under a standing draw ends exactly where it starts below a stated level (`RegimeMargin.ends_iff_below`). A loss read only through the going on of those who bear it is read after its point of no return (`ReadOffInTime`, `too_late_of_own`). Read late, the counts at that reading decide whether the rule stays (`ClosedCapture.Thinned.kept_iff`). |
| **Assumed or defined** in the nearest joint model (`PoolFromCourse`) | The loss grows at every step (a hypothesis, `Accrues`). The readers leave when the loss passes a mark (a definition, `Stands`). A larger share draws more (a hypothesis, `drains`). |
| **Aimed at, not proved** | The two cases under "The condition", on one model with a stock that regrows. Expected to be a composition of the rows above. |
| **A reading** | "The pattern" and "One structure, several names". Six results in separate formal homes have this form; that they are one form is not a theorem. |
| **Tested** | Little. One language-model judge, reading its own earlier picks in context, chose the same way 60 times in 60; one note of the loss among nine readers turned all 50 picks (LA2, frozen before it ran). So that judge is not a count of readers by kind, and the timing condition does not describe it as it stands. No test yet updates a model's weights. |
| **Near work**, from abstracts and search summaries only, unread | A social-choice model of AI eroding collective agency (RAND, 2026). "Self-Sealing Reward Models" (NeurIPS 2026 workshop): a boundary past which an evaluator loop cannot be refuted, repair needing recurrent trusted information. "The Lock-in Hypothesis" (ICML 2025). None seems to have readers whose standing rests on the stock the course draws down, or the order of three times. This must be read before anything is called new. |
| **Not covered** | An agent that plans ahead to gain power. What a trained network comes to pursue apart from its reward. |
