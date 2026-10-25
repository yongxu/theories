# MA4b: the loss read in time by the others, joined to the critical mass (design)

Board item MA4b, step 7 of [AJ's plan](../aj-joint-selection/PLAN.md). Claimed on 26 October 2026 by the session that owns AJ. This is the design: each statement, its premises and its expected standing, written before the Lean.

## 1. What is asked

MA4 ([record](../../../../../../theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md)) joined the capacity to shape the rule (MA3) with readers drawn from the selected (MA2). It left one way out of the lock open. Every course read from the share alone is locked one way or the other (`DrawnShaping.drawn_locked_either`). So control not selected does not by itself give a lock left in time: leaving needs a reading beyond the share.

MA2's `ClosedCapture.Thinned` gives such a reading: the others among the readers read the loss once it reaches a bound. It is not joined to MA4's critical mass. AJ's condition 2, a lock left in time, needs the join, to say when a reading is in time.

## 2. The model

The rule is read as `ClosedCapture.Thinned.lossPool u v w N` with these three readings, all with the same `a`, `p` and `c`:
- `u = shaped a hi p c`: each shaper among the readers reads `hi` coming back to the shapers, whatever the loss.
- `v = shaped a lo p c`: each other reads `lo` while the loss is below `N`.
- `w = shaped a lo' p c`: each other reads `lo'` from then on.

The course is `Thinned.course`, the share's selection joined to a loss that accrues.

For the window, the loss steps by `Beyond.lossStep` from zero, so the others read the loss from step `N`. The start is MA4's: a population under the rule read there.

## 3. To prove

1. **The late verdict.** The late pool favours the shapers at `x` exactly where `x.carrier·c + x.other·c ≤ x.carrier·hi + x.other·lo'`. This is MA4's `drawn_favours_iff` at `lo'`.
2. **Kept, exactly.** Take a reading step `r` with the loss past `N`, the rule in force favouring the shapers, and `lo' ≤ hi`. The course is locked for good from `r + 1` exactly where the late verdict favours at the share at `r`. No mirror premise is needed; `Thinned.kept_iff` has one.
3. **Turned, exactly, with the lag.** Take reading steps `r` and `r + 1`, with the loss past `N` at `r`. The rule in force at `r` favours the shapers, and the late verdict at the share at `r` disfavours them. Then the course is locked the other way for good from `r + 2` exactly where the late verdict disfavours at the share at `r + 1`. That share is selected under the rule in force at `r`, which still favoured the shapers.
4. **The early course.** Before step `N` the joined course is MA4's `drawnCourse`, and the loss at step `t` is `t`. This is an equivalence that connects the two models.
5. **The window closes for good.** Take a start the rule read there favours, with `lo ≤ hi` and `lo' ≤ hi`. Where the late verdict favours at some step `s ≤ N` of the early course, a reading from step `N` keeps the lock for good. Equivalently, the others' reading can turn the course only if it comes before the first step at which their late verdict would favour the shapers.
6. **The strongest reading of this form.** Where the late verdict with `lo' = 0` favours, it favours for every `lo'`. With `c ≤ hi` it favours exactly where `x.other·c ≤ x.carrier·(hi − c)`. Past that share no reading of this form by the others alone turns the course.
7. **A bound on the window, if short enough for the core.** From a start the rule read favours strictly, with `c < hi`, the strongest late verdict favours within `g₀.other · c · x.other` steps of the early course, where `g₀` is the start's rule. The proof would multiply the ratio at least by `g₀`'s at every step, through Bernoulli's inequality (`Resolution.bernoulli_powers`). If the proof is too long, a witness shows the window closing and the bound stays open.
8. **Witness.** Take `a = 1`, `p = 0`, `c = 3`, `hi = 5`, `lo = 2`, `lo' = 0`, one shaper to one other, read at every step. Computed before the Lean:
   - Read from step 0, 1 or 2, the course is turned for good.
   - Read from step 3, it is turned for one step and then locked in the shapers' favour again from step 5.
   - Read from step 4 or later, it is kept.

   The share passes the late verdict's threshold only at step 4, yet a reading at step 3 already comes too late: the lag takes one step.

## 4. Expected standing

Elementary: a weighted majority with a threshold, read one step late. The following are credited:
- Collingridge's dilemma (1980): control is easy while the need for it cannot yet be seen, and hard once it can.
- Lock-in and its timing: David (1985), Arthur (1989).
- The tipping models: Schelling (1978), Granovetter (1978).

What it adds is on the spine: MA2's timing joined to MA4's critical mass, with the exact window and the lag.

## 5. What it will not show

- That actual rules are read by readers drawn from those they select.
- That the others read the loss at all.
- That their late reading has this form: the same `a`, `p` and `c`, with what comes back read as a natural number. With an unbounded reading of their own (any rule `w` not above `u`), the others can always turn the course. So the window is a law of readings of this form, and the record must say so.
- Noise, readers who learn, or a ranking of courses. Ranking needs C.

## 6. Output → input

The result feeds:
- 02 §9, after MA4's paragraph;
- AJ's condition 2, a lock left in time;
- 07 §6's readings (AJ2's owner);
- AJ4's dossier;
- T7.

## 7. What the draft states (26 October 2026)

`Becoming.ReadInTime` in the kit's tree, built in scratch: 25 theorems in 31 declarations, every axiom report empty (`scratch.log`). Against the design:
- Statements 1 to 6 and 8 are as designed: `kept_iff`, `turned_iff`, `early`, `closed_kept`, `least`, `least_iff`, `closed_for_every`, and the witness `Window.in_time`, `Window.too_late`, `Window.late_kept`.
- Statement 7 is proved in the core, not left open: `deadline`, with the bound `g.other * c * x.other` (`g` the rule read at the start), for a start with at least one shaper whose rule favours strictly and `c < hi`, under every schedule. The route is a comparison with the start's rule held fixed (`held`, `held_le`, `held_counts`), then Bernoulli's inequality (`bernoulli_powers`, `held_past`). The witness's deadline is 24, and its window is closed from step 4 (`Window.by_deadline`). So the bound is loose, linear where the share grows geometrically.
- Added: the window stated in MA4's course. Read from `N`, the course is kept for good exactly where the late verdict favours at MA4's share at `N` (`kept_early_iff`), and turned for good exactly where it disfavours at MA4's share at `N + 1` (`turned_early_iff`). The late verdict never falls along MA4's course (`late_rises`). At most one step lies between the steps of the two kinds (`one_between`): the step at which the late verdict favours the others strictly at its share and the shapers strictly at the next. In the witness that step is 3.
