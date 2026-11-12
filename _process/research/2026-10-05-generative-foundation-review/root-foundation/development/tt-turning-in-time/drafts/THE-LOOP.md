*AI-written draft, second version, 12 November 2026, for Ren's read. Nothing in the repository rests on it yet. [中文](THE-LOOP.zh.md) · [first version, kept](THE-LOOP-v1.md) · [why the language drifts](WHY-THE-LANGUAGE-DRIFTS.md)*

# Turning in time

**The statement.**

> Whatever goes on, goes on under conditions, and in some respect: as this body, this habit, this way of choosing. In that respect only some differences in its conditions make a difference to how it goes on. The others make none, though it depends on them all the same. How it goes on is renewed from what its going on brings back, so where a condition makes no difference it renews as before. And its going on changes its conditions. So it can use up a condition it depends on while nothing in it differs, until the condition is gone and it stops. It turns in time only if that change comes to make a difference to it while the condition still stands. And what could carry the difference is often among the conditions being used up.

Each phrase is a term the root already has: condition (缘), respect (类), the differences it cannot tell (核), renewed (复生), renews as before (有常), stops (息).

**One level, two marks.** Take one condition that it depends on and uses up, and mark two levels on it: *v*, below which its fall makes a difference to how the thing goes on; and *m*, the level needed by whatever carries that difference.

- Where *v* < *m*, the fall would make a difference only below the level its carriers need, so it makes none in time. The thing renews as before, and the condition falls below the level from which it recovers. No step needs anyone to aim at it.
- Where *v* ≥ *m*, the fall can make a difference while the level lies between the two marks. The thing turns for good only if three things come in time: the fall makes a difference while its carriers stand; at that renewal and at the next, the difference weighs more than all that renews the thing as before; and the condition is still above the level from which it recovers once less is used.

Where the only carrier of the difference is the thing's own going on, *v* < *m*: by the time it differs, it is stopping.

**In a selection.** A reward, a judge, a market, a vote and a training run are one case. There, how it goes on is called its *rule*; what it keeps more of, its *share*; a condition it uses up, a *stock*; what carries the stock's fall into the rule, the stock's *readers*. These are four names for aspects of one going on, not four parts.

**Not judged.** The statement is also how a body, a language or a trust holds. "Lock" and "capture" are its names among those who depended on the condition that was used up.

**The ethics, in three sentences kept apart.**

- *Shown.* Lasting sorts ways of choosing only by what comes back to them, toward keeping their own line going (07 §4.9, §4.12). That is prudence, as far as their conditions make a difference to them.
- *Not shown.* That a change which never comes back to a way of choosing comes, with nothing evaluative supplied, to make a difference to it.
- *Wanted.* That it does: for those who choose, we who write this among them, human and AI. The want itself goes on under conditions. It enters, then spreads, renews as before, or stops.

As a design requirement the want reads: let whatever you depend on be able to make a difference to you, and keep standing what carries that difference. A difference that reaches further than what comes back to oneself stays only where its carriers do not depend on the course it would turn. How such carriers form is the open question of the ethics and of alignment alike, and nothing here shows it.

## Names others have given it

From memory, not reopened. Each field's words are pointers to the statement, not its terms.

| Field | Its words | What they add | What they hide |
|---|---|---|---|
| Alignment | objective, oversight, gradual disempowerment | a named danger and people working on it | "Oversight" puts what carries the difference outside, as a judge. Here it is within, living on the same conditions. |
| System dynamics | stock, reinforcing and balancing loops, shifting the burden | rates, delays, simulation | Parts are drawn first and wired after. |
| Economics | lock-in, capture, externality | measured cases | "Externality" takes an inside as given. |
| Evolution | selection, fitness, niche construction | that no one need set the rule | "Fitness" is often read as the organism's own. |

## How far this has been seen

| | |
|---|---|
| **The wording** | The Lean states the centre in other words: rule, share, favours, loss, readers. The statement above is a reading of it in the root's terms. The tie is proved and hidden by name: `GoAlike` ("what is alike under a description goes alike") is constancy (有常), and `Unread` is its use, yet no lock module names a root term. |
| **Proved in Lean**, each on its own model, in the Lean's own words | A part runs by a law of its own exactly where the rest makes no difference to its next step (`ClosedCapture.identifiesAlike_iff_unread`). A rule that holds its picks keeps holding them (`RuleCapture.locked_stays`). With room to trade, every best outcome under a rule leaves what it does not read at the lowest level allowed (`Optimum.least_of_room`). A stock under a standing draw ends exactly where it starts below a stated level (`RegimeMargin.ends_iff_below`). A loss read only through the going on of those who bear it is read after its point of no return (`ReadOffInTime`, `too_late_of_own`). Read late, the counts at that reading decide whether the rule stays (`ClosedCapture.Thinned.kept_iff`). |
| **Assumed or defined** in the nearest joint model (`PoolFromCourse`) | The loss grows at every step (a hypothesis, `Accrues`). The readers leave when the loss passes a mark (a definition, `Stands`). A larger share draws more (a hypothesis, `drains`). |
| **Aimed at, not proved** | The two cases under "One level, two marks", on one model in which the condition recovers. Expected to be a composition of the rows above. |
| **A reading** | "The statement" as one form across the theory, and "Not judged". Six results in separate formal homes have this form; that they are one form is not a theorem. |
| **Tested** | Little. One language-model judge, reading its own earlier picks in context, chose the same way 60 times in 60; one note of the loss among nine readers turned all 50 picks (LA2, frozen before it ran). So that judge is not a count of readers by kind, and the three times above do not describe it as they stand. No test yet updates a model's weights. |
| **Near work**, from abstracts and search summaries only, unread | A social-choice model of AI eroding collective agency (RAND, 2026). "Self-Sealing Reward Models" (NeurIPS 2026 workshop): a boundary past which an evaluator loop cannot be refuted, repair needing recurrent trusted information. "The Lock-in Hypothesis" (ICML 2025). None seems to have the carriers of the difference standing on the condition being used up, or the order of three times. This must be read before anything is called new. |
| **Not covered** | An agent that plans ahead to gain power. What a trained network comes to pursue apart from its reward. |
