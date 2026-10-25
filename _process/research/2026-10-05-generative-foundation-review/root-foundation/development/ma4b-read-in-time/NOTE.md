# MA4b: the loss read in time by the others, joined to the critical mass (design)

Board item MA4b, step 7 of [AJ's plan](../aj-joint-selection/PLAN.md). Claimed on 26 October 2026 by the session that owns AJ. Sections 1 to 6 are the design: each statement, its premises and its expected standing, written before the Lean and corrected after the independent review where it was wrong (§8 says where). Section 7 says what the draft stated, and §8 what the review changed.

## 1. What is asked

MA4 ([record](../../../../../../theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.md)) joined the capacity to shape the rule (MA3) with readers drawn from the selected (MA2). It left one way out of the lock open. Every course from a start under the rule read there, read from the share alone, is locked one way or the other (`DrawnShaping.drawn_locked_either`). So control not selected does not by itself give a lock left in time: leaving needs a reading beyond the share.

MA2's `ClosedCapture.Thinned` gives such a reading: the others among the readers read the loss once it reaches a bound. It is not joined to MA4's critical mass. AJ's condition 2, a lock left in time, needs the join, to say when a reading is in time.

## 2. The model

The rule is read as `ClosedCapture.Thinned.lossPool u v w N` with these three readings, all with the same `a`, `p` and `c`:
- `u = shaped a hi p c`: each shaper among the readers reads `hi` coming back to the shapers, whatever the loss.
- `v = shaped a lo p c`: each other reads `lo` while the loss is below `N`.
- `w = shaped a lo' p c`: each other reads `lo'` from then on.

The course is `Thinned.course`, the share's selection joined to a loss that accrues.

For the window, the loss steps by `Beyond.lossStep` from zero, so the others read the loss from step `N`. The start is MA4's: a population under the rule read there.

## 3. To prove

1. **The late reading.** The late pool favours the shapers at `x` exactly where `x.carrier·c + x.other·c ≤ x.carrier·hi + x.other·lo'`. This is MA4's `drawn_favours_iff` at `lo'`.
2. **Kept, exactly.** Take a reading step `r` with the loss past `N`, the rule in force favouring the shapers, and `lo' ≤ hi`. The course is locked for good from `r + 1` exactly where the late reading favours at the share at `r`. No mirror premise is needed; `Thinned.kept_iff` has one.
3. **Turned, exactly, with the lag.** Take reading steps `r` and `r + 1`, with the loss past `N` at `r`. The rule in force at `r` favours the shapers, and the late reading at the share at `r` disfavours them. Then the course is locked the other way for good from `r + 2` exactly where the late reading disfavours at the share at `r + 1`. That share is selected under the rule in force at `r`, which still favoured the shapers.
4. **The early course.** Before step `N` the joined course is MA4's `drawnCourse`, and the loss at step `t` is `t`. This is an equivalence that connects the two models.
5. **The window closes for good.** Take a start the rule read there favours, with `lo ≤ hi` and `lo' ≤ hi`. Where the late reading favours at some step `s ≤ N` of the early course, a reading from step `N` keeps the lock for good. So, but at a tie, the others' reading can turn the course only if it comes before the first step at which their late reading would favour the shapers.
6. **The least reading of this form.** Where the late reading with `lo' = 0` favours, it favours for every `lo'`. With `c ≤ hi` it favours exactly where `x.other·c ≤ x.carrier·(hi − c)`. Past that share every reading of this form with `lo' ≤ hi` keeps the lock.
7. **A bound on the window, if short enough for the core.** From a start the rule read favours strictly, with `c < hi`, the least late reading favours within `g₀.other · c · x.other` steps of the early course, where `g₀` is the start's rule. The proof would multiply the ratio at least by `g₀`'s at every step, through Bernoulli's inequality (`Resolution.bernoulli_powers`). If the proof is too long, a witness shows the window closing and the bound stays open.
8. **Witness.** Take `a = 1`, `p = 0`, `c = 3`, `hi = 5`, `lo = 2`, `lo' = 0`, one shaper to one other, read at every step. Computed before the Lean:
   - Read from step 2 (and, by computation, from 0 or 1), the course is turned for good.
   - Read from step 3, it is turned for one step and then locked in the shapers' favour again from step 6.
   - Read from step 4 or later, it is kept.

   The share passes the late reading's threshold only at step 4, yet in this witness a reading at step 3 already comes too late: the lag takes one step.

## 4. Expected standing

Elementary: MA2's `Thinned` laws composed with MA4's monotone course; the lag of one step is the representation's (a rule read at a step is in force from the next). In this model the second horn of Collingridge's dilemma (1980) is a theorem: from the first step at which the late reading would favour the shapers, a reading keeps the lock, and past the least reading's threshold every reading of this form does. The first horn, that the need is read too late, is the premise that the loss is read only from `N`. The following are credited:
- Biggs, Carpenter and Brock (2009), the continuous analogue of the window: the window for averting a regime shift ends abruptly, and where the driver changes only gradually, action is needed well before the shift.
- Lock-in and its timing: David (1985), Arthur (1989), Cowan (1991).
- The tipping models: Schelling (1978), Granovetter (1978).
- Replicator selection with a delay: Alboszta and Miękisz (2004).

What it adds is on the spine: MA2's timing joined to MA4's critical mass, with a window exact at every step but at most one (given readings at steps `N` and `N + 1`), its lag of one step, and a deadline.

## 5. What it will not show

- That actual rules are read by readers drawn from those they select.
- That the others read the loss at all.
- That their late reading has this form: the same `a`, `p` and `c`, with what comes back read as a natural number. With a late reading whose weight against the shapers is chosen after the share is seen (a rule `w` far enough below `u`), the others could turn the course from any share; that is not stated here. So the window is a law of readings of this form, and the record must say so.
- Noise, readers who learn, or a ranking of courses. Ranking needs C.

## 6. Output → input

The result feeds:
- 02 §9, after MA4's paragraph;
- AJ's condition 2, a lock left in time;
- 07 §6's readings (AJ2's owner);
- AJ4's dossier;
- T7.

## 7. What the draft states (26 October 2026)

`Becoming.ReadInTime` in the kit's tree as committed at `b69dfcb1e`, built in scratch: 25 theorems in 31 declarations, every axiom report empty. The names here are the draft's; §8 gives the revised ones. Against the design:
- Statements 1, 2 and 4 to 6 are as designed: `kept_iff`, `early`, `closed_kept`, `least`, `least_iff`, `closed_for_every`. Statement 3 (`turned_iff`) needs `lo' ≤ hi`, which the design lacks, and not the rule in force favouring the shapers. Statement 8 is proved for readings from steps 2, 3 and 4 on (`Window.in_time`, `Window.too_late`, with the relock from step 6, and `Window.late_kept`), and computed only from steps 0 and 1.
- Statement 7 is proved in the core, not left open: `deadline`, with the bound `g.other * c * x.other` (`g` the rule read at the start), for a start with at least one shaper whose rule favours strictly and `c < hi`, under every schedule. The route is a comparison with the start's rule held fixed (`held`, `held_le`, `held_counts`), then Bernoulli's inequality (`bernoulli_powers`, `held_past`). The witness's deadline is 24, and its window is closed from step 4 (`Window.by_deadline`). So the bound is loose: since `g.other = (x.carrier + x.other)·(a + c + p)`, it is quadratic in the start's counts, and it grows when they are scaled though the window does not change.
- Added: the window stated in MA4's course. Read from `N`, the course is kept for good exactly where the late reading favours at MA4's share at `N` (`kept_early_iff`), and, with steps `N` and `N + 1` reading, turned for good exactly where it disfavours at MA4's share at `N + 1` (`turned_early_iff`). The late reading never falls along MA4's course (`late_rises`). At most one step lies between the steps of the two kinds (`one_between`): the step at which the late reading favours the others strictly at its share and the shapers strictly at the next. In the witness that step is 3. From that step neither law decides: the course starts a new round (§8).

## 8. What the review changed (26 October 2026)

One independent read-only review ([REVIEW-MA4b.md](REVIEW-MA4b.md)) found no unsound Lean and fifteen findings in the text; its probe module is kept as `review-probe-ReadInTimeProbe.lean.txt` and the scripts of its integer mirror in `review-mirror/`. All fifteen were taken.

**The step between (findings 1, 2, 7).** The draft said a reading from the one step between comes one step too late. That holds in the witness but not in general: in the review's probe P1 (a cost of one, `hi = 3`, `lo = 2`, `lo' = 0`, one shaper to three others) step 0 is the step between, and read from there the course is turned for good from step 4. In the review's numeric survey of 50,342 courses read from the step between, 84.8% were first locked in the shapers' favour and 15.2% the other way. The module now says that from the step between neither law decides and the course starts a new round, to which `kept_iff` and `turned_iff` apply again from step `N + 2` (`kept_next_round_iff`, the review's `between_round`), and it witnesses both outcomes (`Window.too_late`, `Between.turned`). The classification is stated with readings at `N` and `N + 1`, and ties are named: where every rule read ties, a reading both keeps and turns in the sense of these laws (`Tie.both`).

**Premises restored in the text (findings 3 to 6).** `lo' ≤ hi` in the Turned bullet and wherever "this form" stands for a lock, `Accrues` in the bullets and the docstrings of `kept_iff`, `loss_next` and `turned_iff`, and the reading step in the bullets of the two laws once the window has closed. Each has a counterexample in the probe module (P2 to P5, P12).

**The deadline (finding 8).** It is quadratic in the start's counts, not linear, and not a law of the share: from two to two the window is that from one to one, and the deadline 96 (`Window.scaled`, the review's P10).

**The standing (finding 9).** Collingridge's dilemma has two horns; here the second is a theorem and the first a premise (the bound `N`). The lag is the representation's. Biggs, Carpenter and Brock (2009), Cowan (1991) and Alboszta and Miękisz (2004) are credited. The window is called exact at every step but at most one, given readings at `N` and `N + 1`, not exact.

**This note (findings 10, 11, 13).** §3.8 now says the relock is from step 6 and that steps 0 and 1 are computed, §7 says how statements 3 and 8 differ from the design, §5 withdraws "an unbounded reading … always turns the course" (false: a late rule equal to the shapers' turns nothing), and the vocabulary follows the module: the late reading, the least reading.

**Docstrings (finding 12).** The numbers of `Window.late_kept` are carrier first, `held_le` states its statement before its reason, `drawn_locked_either` is cited with its start, and the rule read past the bound cites `Thinned.lossPool_past` and `Thinned.rule_read`.

**Premises not needed (finding 14), taken.** `deadline` drops `c < hi`, which `lo ≤ hi` and a start favouring strictly give (`covers_of_strict`). `at_most_one_between` needs only `lo ≤ hi`: MA4's course is monotone one way or the other and the late reading reads it one way or the other (`at_most_one_between_up`, `none_between_down`). `kept_past_least` drops the start favoured, which the least reading favouring forces.

**Names (finding 15), taken.** `late_rises` → `late_never_falls`; `one_between` → `at_most_one_between`; `closed_kept` → `kept_once_favoured` (hypothesis `favoured`); `closed_for_every` → `kept_past_least` (hypothesis `least_favours`), since in `ClosedCapture` "closed" means read from the share alone; `lossRead` → `shapedLossPool` (and `lossRead_before` → `shapedLossPool_before`), since `ClosedCapture.Beyond.lossRead` is another rule (the review's `lateRead` would name the late reading, which is a part of it); `held` is gone, the course under a rule held fixed being `Law.orbit` and its counts following from `RuleShaping.orbit_held` (`powers_eq_pow`); the witnesses reuse `DrawnShaping.CriticalMass.one_pos`, `even`, `oneToTwo` and `oneToThree`. Added for the kit, which cited it: `in_time_earlier` (the review's P15).
