# Questions for a case of your own

*Nine questions to ask of something you know that lives on a stock that renews. Each comes from a small mathematical model in which the answer was proved and checked by machine (the proof checker Lean), or worked through on one example. None has been tried on a real case. No person has checked this page.*

*AI-written (Fable), 16 November 2026. Prepared for Ren as step 8 of [the plan](LEAN-TOWARD-THE-DIRECTION.md); sending it to anyone is his. About seven minutes. English only for now. Two rounds of AI readers read drafts of it and found places where it claimed more than the proofs; they are corrected here.*

## What the questions are about

Something goes on by drawing on a stock that renews: a fishery on its fish, a platform on its users' attention, an institution on trust, a training run on the judgments that correct it. The model has three things in it.

- **A level**: how much of the stock there is. It has a ceiling it cannot pass.
- **What comes back** each step. It depends only on what was left after the draw.
- **A way**: who or what is there, drawing.

Two kinds of way are worked out, never both at once.

- **Members.** Each takes something, needs the level to be at least something in order to go on, and leaves successors.
- **A rule with a share.** The rule favours something. The share is how much of what there is the favoured already has. Favouring does not lower the share (in question 4 it adds to it), and each step the rule is set again from the share. At some levels the level is read, and the reading sets the rule instead; the rule it sets is the corrected rule, with one fixed draw. The rule overdraws when the level is already below the point of no return (question 2) of the draw it keeps.

"Ends" means that no need is met any more.

The idea behind the questions: how much is left can be among the things that make no difference to what goes on. Then what goes on can use the stock up while nothing in it yet differs. The questions ask where, in your case, the level first makes a difference, and whether that is early enough.

## The questions

**1. What does it draw on, and what comes back?** Can you name one stock, and say what comes back as depending on what is left? If nothing is left, does nothing come back? Is there a ceiling the level never passes? *The theorems that speak of the stock assume yes to each. With several stocks, or a return that depends on more than what is left, they do not speak.*

**2. For the draw it makes now, is there a point of no return?** Hold the draw fixed. Suppose that when less than some amount is left after the draw, what comes back falls short of the draw, and that from that amount up to the ceiling it covers the draw. Then the draw plus that amount is a point of no return: the level comes to nothing exactly where it starts below it. *Proved.*

**3. At what level does a shortfall first make a difference to anything in it?** Name it: a member that stops when the level is too low for it, or a reading of the level that changes a rule. Until the level gets there, who is there is who would be there if the level made no difference: every need met, or the level never read. *Proved: two courses that start with the same members have the same ways for as long as their levels meet the same needs, whatever the two stocks and their starting levels are.*

**4. Does its draw grow at every step, for as long as every need is met?** The theorems ask this of every member at every step, and of the rule while nothing reads the level. Growing now is not enough. Two forms are proved.
   - *Members.* What each member leaves behind draws more, together, than the member did, and every member needs something.
   - *A rule.* It is set again from the share it already favours, each favouring adds to the share, the draw is the share times a positive amount, and nothing reads the level.

   In both, a shortfall comes within as many steps as the ceiling plus one: for members, a first need that is not met; for the rule, its end. Until then, for members, who is there is who would be there with every need met. If successors need no more than their parents, the level at that step is below a need that was met at the start, and so below the level it started from. With that premise what goes on also ends: at some step, which no theorem bounds, no need is met. The count of steps is in the model's whole-number levels: a bound in the model, not a forecast. *So where a draw grows like this, the question is not whether a shortfall comes but what the first difference will be. No theorem here joins a growing draw to a reading: questions 6 and 7 are proved from a start that already overdraws.*

**5. If every member's successors together draw exactly what it drew, where does it come to hold?** If also every member leaves at least one successor, successors need no more than their parents, and every member needs something, it goes on without end exactly where it reaches a state in which every need is met and the level is at or above the point of no return of what they take together. In the model, a member whose need is not met stops, and its draw stops with it. *Proved, with question 2's conditions on what comes back assumed all along the course. Successors that together draw less than their parent are not covered.*

**6. If something reads the level and corrects, what does a reading set?** In the model the level is read on a band of levels and nowhere else.
   - *The rule only.* Where the level is not read, the rule is set again from the share. *A worked course: read in time and corrected; one step later not read; the share had not changed, so the old rule came back, and it ended.*
   - *The share as well*, lowered to one that gives the corrected rule and stays low under it. Then it goes on without end exactly where the step at the first reading leaves the level at or above the corrected draw's point of no return. *Proved. That a reading does this is assumed, not derived; so is the overdraw before it.*

**7. Is the first reading early enough?** Where a reading sets the share as well, "early enough" is one inequality: the level after the step at which it is first read is at or above the corrected draw's point of no return (question 2, asked of the corrected draw). Where it sets the rule only, the same inequality is proved to settle it under two conditions on the band that is read: it starts at or below that point; and its top is at or above a level from which the level does not fall back under any rule, or is above the ceiling. Under these two, a first reading that leaves the level below that point still corrects the rule, and what goes on ends all the same. Where the band starts above that point, a course can meet the inequality and still end (question 6's worked course). Whether the condition on the top is needed is not shown.

**8. After a reading in time, is what goes on the corrected thing?** Not always. *A worked course: the level is read and the rule corrected; the level rises out of the band that is read; the rule is set again from the share, and what goes on is the old rule, at a level where its draw is met.* "It was read in time" does not say it was corrected.

**9. What stops that takes nothing?** A member that draws nothing can stop with the level and every other member as they were. *Proved.* So its loss is not felt through the stock. It can also be the only thing still going on: with it something goes on, without it nothing does, and nothing else differs. *A small case.* And a line of descent that is gone does not come back. *Proved.*

## What these do not answer

- Who bears a loss, and what should be done about it. Reading a loss does not settle that.
- How the needs, the draws and the successors come to be what they are. In the model they are given.
- Whether what goes on can come to read the fall because of the fall. In this model it cannot: no new difference arrives from a difference not yet made.
- When a way in which the successors of some members together draw less than them, and of others more, goes on without end. No exact condition is proved; in one small case the higher start ends and the lower one does not.
- What the loss of a member that draws something does to the rest. In one worked course it is what the rest goes on by; in another the rest ends all the same.
- Anything about a trained system. Nothing here has been tested on one.

## Where each is proved

The Lean is in `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`. There, members are units and successors are `kids`. The names are theorems unless said. "Given" is what a theorem assumes.

| Question | Where | Given |
|---|---|---|
| 1 | The premises themselves: `RegimeMargin.FromNothing`, `RegimeMargin.Keeps giving 0 hi`, a start at most `hi`. | |
| 2 | `RegimeMargin.ends_iff_below`. | A fixed draw; what comes back short of it when less than an amount is left, covering it from that amount up to the ceiling; the step keeping the level within the ceiling; nothing from nothing; a start within the ceiling. |
| 3 | `LineOnAStock.ways_alike`, `way_while_met`; `alike_iff` (which needs are met is exactly what makes a difference, where every unit of the way leaves a kid); `TurningInTime.agrees_until_marked` for a way with marked levels. | For members, nothing about the stock. For marked levels, that outside them the level makes no difference to the way. |
| 4 | `LineOnAStock.need_unmet`, `falls_to_unmet`, `way_ends`; `TurningInTime.rising_takes_all`, `locked_ends_rising`, `count_rises`. Worked: `LineOnAStock.Doubling`, `TurningInTime.Three.rise_count_ends`. | For members: that each one's kids together take more; that every one needs something; the ceiling and nothing from nothing; a start that is not empty with every need met. For the level having fallen, and for the ending: that kids need no more than their parent. For the rule: that no level at which it goes on is read; that it needs something of the level; the ceiling and nothing from nothing; and that the draw rises with each step, or is the share times a positive amount with every favouring raising the share. |
| 5 | `LineOnAStock.unending_iff_holds`; its case `WayOfUnits.unending_iff_holds`. Worked: `LineOnAStock.TwoForOne`, `WayOfUnits.With`. | That each unit's kids together take exactly what it took; that every unit leaves a kid; that kids need no more; that every unit needs something; nothing from nothing; question 2's conditions along the course. |
| 6 | Worked: `TurningInTime.Three.read_at_eight_ends`. `TurningInTime.locked_turns_in_time_share_iff`, `share_corrected_on_course`; worked: `Three.share_read_goes_on`. | That a reading sets a low share and the corrected rule, which then stay; that the corrected kind has one draw; that the need is at most its point of no return; a locked start; the overdraw before the reading; question 2's conditions for the corrected draw. |
| 7 | The right sides of `TurningInTime.locked_turns_in_time_share_iff` (the share as well) and `locked_turns_in_time_on_window_iff` (the rule only). | The share as well: as in question 6. The rule only: question 6's givens other than those on the share (nothing is given about the corrected rule staying), and: every step reads; the band as said; no way draws less than the corrected draw. |
| 8 | Worked: `TurningInTime.Three.read_to_ten`. | |
| 9 | `LineOnAStock.takes_nothing`; the small case `LineOnAStock.NothingTakenEnds.ending_differs`; `LineOnAStock.never_in`, `gone_from`. | That the member takes nothing and leaves only its like; for the last, that no unit outside the line leaves a unit of it. |

What the model leaves out: more than one stock; levels that are not whole numbers; a return that depends on anything but what is left; needs, draws and successors that change; members and a rule together; anything that comes to read what it did not read.
