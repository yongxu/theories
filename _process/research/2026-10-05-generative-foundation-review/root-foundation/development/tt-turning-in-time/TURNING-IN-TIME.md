*AI-written, 13 November 2026, for Ren's read: a candidate statement of the centre on one page. Where it and [02 §11](../../../../../../theories/becoming/chapters/02-MAP.md#turning-in-time) differ, §11 and its Lean decide. [中文，另写](TURNING-IN-TIME.zh.md)*

# Turning in time

**The statement.** Things happen, and each is a condition of what happens next. Seen in one respect, a run of them is alike: a line. A line ends in one of two ways. Nothing follows at all: the net itself ends there. Or something follows that is no longer alike: the line ends while the net goes on. The first is being used up as it was. The second is a turn.

Which of the two happens is not settled by the respect. It is settled by an amount.

**With an amount.** Let going on in some way need a level of something, and lower it. At most levels the level makes no difference to the way. Then the way stays as it was, the same from every level, until the level is below what is needed and nothing follows. It turns only at a level that does make a difference to the way, reached while the need is still met. The turn holds only if what that step leaves is enough under the new use.

So three levels of one quantity decide: where its fall first makes a difference, what that step leaves, and the level from which it holds under the new use.

**One case in numbers.** What is left gives back `min(z, 12 − z)`. The way as it was uses five a step; the way it turns into uses three. One is needed. Start at nine. As it was, the level runs nine, eight, six, two, nothing. Under a use of three it holds from six up.

| The fall first makes a difference at | What follows |
|---|---|
| nine | it turns at once, eight is left, and it never ends |
| eight | it turns one step later, six is left, and it never ends |
| six | it turns with two left, too few; one step later nothing is left and nothing follows |
| no level | it never turns: nine, eight, six, two, nothing, the same way to the end |

One step separates a turn that holds from a turn that comes too late.

## What it says, by reader

- **Machine learning and alignment** (a reading; no test here trains a system). Read the way as a trained system together with what selects it, and the level as something that selection needs and lowers. Where no level changes the way, going on the same way is all that shows until the end: lines from one way at two levels are alike step for step. A warning exists only at levels that change the way. So a design asks two things of whatever the selection lives on: that its fall change the way early, and that enough is left for the changed way to hold. There is no overseer outside the course in this; there are only levels that make a difference.
- **Systems and economics.** This is overshoot with a response at a threshold. Near work switches a tax on at a chosen level of a stock and says in words that it must come in time. Here the comparison of the three levels is exact and machine-checked, on whole numbers and discrete steps, without noise.
- **Philosophy.** The way and the level are two readings of one configuration, not two things joined afterwards. Nothing in the statement is good or bad. "Lock", "capture" and "turn" are its names from one standpoint or another.
- **Anyone.** A habit, a firm or a society can go on exactly as it was up to the day what it lives on is gone. What it lives on has to be able to change it while there is still enough left.

## How far this has been seen

| | |
|---|---|
| **Proved**, in Lean with no axioms | The root's two names for the gap are tied: where each occurrence has at most one next, constancy up to the net's end is going alike with it decided whether a next exists (`«局定后则至终有常当且仅当同行可决»`). On the model: which levels make a difference (`TurningInTime.toEnd_iff`); used up as it was (`ends_with_net`); the exact condition for a turn that holds (`turns_in_time_iff`); the line ending while the net goes on (`kind_ends_while_net_goes`); the table above (`Three`). The earlier lock's courses are courses of this model where nothing is needed (`window_is_pair`). |
| **Given, not derived** | Which levels make a difference, what is needed, the way it turns into, and that this way is kept and has one standing use. |
| **Not shown** | How what brings a level's difference to a way comes to stand, and whether it stands on that same level. Anything about a trained system. That this is new: several near papers were read only in part. |
