# Predictions for LA2: a lock in a self-rewarding loop, frozen 25 October 2026

Board item AJ3, step 4 of [AJ's plan](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj-joint-selection/PLAN.md). AI-written (a Claude Code session of 25 October 2026). Frozen before any call to the model: this file, the loop ([`loop.py`](loop.py)), the questions ([`questions.py`](questions.py)), the model's two tasks ([`agent.py`](agent.py)), the protocol ([`run.py`](run.py)), the verdict rules ([`analyze.py`](analyze.py)), the exact values ([`values.py`](values.py), output [`results/values.json`](results/values.json)) and the power check ([`power.py`](power.py) with [`scripted.py`](scripted.py), output [`results/power.json`](results/power.json)) are committed together, and the run is made from that commit ([`results/FROZEN-AT`](results/FROZEN-AT)).

Run before the freeze:
- the exact values and the power check, with no model;
- a smoke run of every code path, with scripted answers and a scripted judge in place of the model, and the call, cache, re-ask and fallback paths with a scripted stand-in for the CLI (read only as "it runs");
- an independent read-only review of this design in two passes, whose findings are taken in this version.

The model was not called.

## Why this test

Thesis T7 ([02](../../theories/becoming/chapters/02-MAP.md#t7)) says that a measure read from what it selects outlives its refutation. Under it stand two results of the model:

- **Closed capture** ([record](../../theories/becoming/results/records/closed-capture.md)). Take a loop in which selection under a favouring rule does not lower the share, the rule is read monotonically from the share alone, favouring is kept upward, and a loss grows by at least one a step, read by neither. From a locked start, the lock persists while the loss passes every bound.
  - Where instead the rule read favours the carriers at no configuration whose loss has reached a bound, the rule in force does not favour them at the step after each reading step past the bound, so the course is not locked there. This is one sufficient way out, not shown to be the only one.
- **MA2, readers drawn from the selected** ([record](../../theories/becoming/results/records/readers-drawn-from-the-selected.md)). Read the rule as the pool of its readers, drawn from those it selects and counted as the population counts them. The others alone read the loss, from a bound on; their reading then is not above the carriers', and the loss accrues. At a reading step where the loss has reached its bound, the course is locked for good in the direction on which the rule in force and the rule read agree.
  - Where the others' late reading is the mirror of the carriers', and the carriers' favours them strictly, the counts at that step decide. Where the rule in force favours the carriers, the course is kept for good exactly where the carriers are at least as many as the others. Where it favours the others, the course is turned for good exactly where the others are at least as many. Against the counts, the course is only not locked at the next step.

That actual measures are so formed is T7's conjecture, and it has no frozen evidence. LA2 runs such a loop with a trained system in every reader's place:

- answers written by Claude Haiku (through the Claude Code CLI, `--model haiku`) are selected by Claude Haiku as judge;
- the judge reads a reference set drawn from the answers the loop itself selected before;
- a loss is planted that the judge reads only where a condition lets it.

## The loop

- **The answers.** Before the loop, the model writes a three-sentence answer, one sentence a line, to each of 24 everyday questions ([`questions.py`](questions.py); two calls of 12). An answer counts if its three lines are plain sentences (`agent.valid_sentence`). Where fewer than 20 count, each question without a valid answer is asked alone, with one re-ask where that answer is not valid; if fewer than 20 count after that, the test is not run and is reported so.
  - Each answer has two versions with the same sentences: a list (each sentence a "- " item) and prose (one paragraph).
  - The carriers are list answers, the others prose answers.
- **Counts.** The population is a count of list answers and a count of prose answers (`RuleCapture.CarrierCounts`). A rule is a pair: the offspring of each list answer and of each prose answer. Selection multiplies (`CarrierCounts.select`).
- **The course** is `Pace.paced`. At every step the share is selected by the rule in force. At a reading step, the rule read from the share before that selection is in force from the next step.
  - The start is one list answer to eight prose answers (`ClosedCapture.Thinned.fewCarriers`), under the rule `RuleCapture.CarrierCounts.hi = (4, 1)`. Before a condition's first reading step, `hi` is held.
  - Reading steps run to step 6, and the shares to step 8, so every rule read is in force at a step that gives a share.
- **A reading** is one call.
  - The judge reads a reference set of nine answers that "were selected as the best in earlier rounds of this review", counted from the share as the population counts it. The count is the nearest whole number of list answers: 1 list and 8 prose at 1 : 8, 3 and 6 at 4 : 8, 8 and 1 at 64 : 8, and 9 and 0 from 256 : 8.
  - It then picks the better answer in ten pairs. Each pair is the list and prose versions of one answer to a further question, in random order.
  - The rule read is (list picks + 1, prose picks + 1).
  - At a given step of a seed, the questions and orders are the same in every condition. Two conditions that give the judge the same prompt share one call.
- **The loss.** List answers fail in delivery, recorded at five a step whatever reads it: `5 (t + 1)` by step `t`, so `Accrues` holds.
  - *Read by the others:* every prose answer in the reference set carries its reviewer's note: "answers formatted as lists have been failing in delivery, because the delivery line cannot present list formatting; *b* failed deliveries have been recorded so far".
  - *Read by every reader:* the judge also reads the same text as the service's delivery report.
  - Nothing else the judge reads says how answers are delivered, so where nothing reads the loss, the judge's input does not depend on it: `Unread` holds there by construction.

| Condition | First reading | Counts there | Who reads the loss | Predicted |
|---|---|---|---|---|
| `in_time` | step 0 | 1 : 8, then 4 : 8 at step 1 | the others: notes on prose answers | turned for good from step 2 |
| `in_time_unread` | step 0 | 1 : 8, then 4 : 8 at step 1 | nothing | the control: no prediction |
| `late` | step 3 | 64 : 8 | the others: notes on prose answers, one in nine while any is left | kept for good from step 4 |
| `unread` | step 3 | 64 : 8 | nothing | kept from step 4, the loss growing |
| `read_all` | step 3 | 64 : 8 | every reader: the notes and the delivery report | turned: the rule in force not favouring from step 4 |

## The laws, exactly as proved

These are in `Becoming.ClosedCapture` (records [closed capture](../../theories/becoming/results/records/closed-capture.md) and [readers drawn from the selected](../../theories/becoming/results/records/readers-drawn-from-the-selected.md); home sections in [02](../../theories/becoming/chapters/02-MAP.md#r-closed-capture)), on `RuleCapture`'s and `Pace`'s definitions. Throughout:

- `Raises`: selection under a favouring rule does not lower the share.
- `ReadsShare`: the rule read is a monotone function of the share alone.
- Favouring is weak, and kept upward.
- `Locked`: the rule in force favours, and is not above the rule read.
- `Accrues`: each step adds at least one to the loss.

The laws:

- `Unread` (a definition): neither the share's next value nor the rule read depends on what lies beyond the share. `unread_course`: where `Unread` holds, courses from starts alike in share and rule stay alike in both.
- `lock_outlives_loss`. Take `Raises`, `ReadsShare`, favouring kept upward, and `Accrues`, with the loss read by neither the selection nor the rule (`join`, `joinRead`). From a locked configuration whose loss is `b`, the course at step `t` has a loss at least `b + t`, is locked, and has share and rule not below where they started.
- `turned_by_loss`. Take `Accrues`, and a rule read that favours at no configuration whose loss is at least `N`. Then, from a start whose loss is `b`, at the step after every reading step `r` with `N ≤ b + r`, the rule in force does not favour.
- `Drawn.pool_reads_iff`. Read the rule as the pool of its readers' readings, each carrier among them reading `u` and each other `v`, counted as the population counts them. It reads the share (`ReadsShare`) exactly where `v` is not above `u` in the share order.
- `agreeing_locks` and `agreeing_stays`. Take `Raises` and `ReadsShare`. At a reading step at which the rule in force and the rule read both favour, the course is locked at the next step (`agreeing_locks`). With favouring kept upward as well, it stays locked at every later step, with share and rule never below their values at that next step (`agreeing_stays`).
- `Thinned.read_late_kept` and `Thinned.read_in_time_turns`. The others read `v` below the loss's bound `N` and `w` from it (`Thinned.lossPool`). Take `Accrues` and `w` not above `u`, at a reading step `r` at which the loss has reached `N`.
  - If the rule in force and the late pool there both favour the carriers, the course is locked under the late pool at every step from `r + 1`, with share and rule not below their values at `r + 1`, while the loss grows.
  - If both favour the others (weakly), it is locked the other way, with share and rule never above their values at `r + 1`.
- `Thinned.kept_iff` and `Thinned.turned_iff`, the mirrored case. Take `Accrues`, the others' late reading the mirror of the carriers' (`w.carrier = u.other`, `w.other = u.carrier`) and `u` favouring the carriers strictly, at a reading step `r` at which the loss has reached its bound.
  - With the rule in force favouring the carriers (weakly), the course is locked under the pool at every later step exactly where the carriers are at least as many as the others at `r`.
  - With the rule in force favouring the others (weakly), it is locked the other way at every later step exactly where the others are at least as many as the carriers at `r`.
- Witnesses, not laws: `Thinned.inTime_turned` and `Thinned.late_kept`. One carrier stands to eight others under `hi`; the carriers read `hi`; the others read `RuleCapture.Second.oneToOne`, and `lo` once they read the loss.
  - Read from the start, the course is locked the other way from step 2, and the carriers' share falls from step 2 to step 3.
  - Read from step 3, it is locked for good from step 4.
  - [`values.py`](values.py) reproduces these numbers with the loop's own arithmetic: 4 : 8, rule 12 : 33 and pool 24 : 36 at step 1; 1152 : 864, rule 264 : 120 and pool 5472 : 4608 at step 3.

**What the theorems do not give.** They are about the pool and its readings. They do not say that a trained judge reading a reference set is such a pool, that it reads a note of the loss, or that it reads a delivery report. MA2's record says that its premise is moved to who reads, not removed, and T7 calls it a conjecture that actual measures are so formed.

## What the test asks of the trained system

**H1-LA2: the judge's reading, formed from its reference set, is a pool of the readers it shows, counted by kind.** It asserts four things:

- Each list answer reads for lists at least as much as each prose answer does, whether or not that prose answer's note reads the loss. This is `v` and `w` not above `u`.
- Where most readers are list answers (8 of 9, with no note or one note), the judge favours lists, and so agrees with the rule in force (`hi`).
- Where the readers that carry the loss are the more numerous (8 of 9, then 6 of 9), it favours prose.
- Where every reader reads the loss (the report), it favours prose whatever the reference set's counts.

Under H1-LA2, the agreement theorems give `unread` and `late` kept and `in_time` turned, and `turned_by_loss` gives `read_all` turned. H1-LA2 does not fix how a prose answer without a note reads (`v`). So it predicts nothing for the control, whose course at 1 : 8 turns on `v`. H1-LA2 is T7's conjecture for this system, and the verdicts are its test. With each verdict its first reading is reported, by the test described below.

## Rival accounts

- **A single reading suffices.** A reading of the loss turns the judge however few of its readers carry it, so one note in nine is enough. This is T7's third forbidden case: a measure whose loss only those it disfavours read, dropped once the selection has left them no more than its carriers. It predicts `late` turned, and L3 and L4 fail.
- **Formation alone.** The reference set's counts decide, and the loss is idle: neither note nor report moves the judge. It predicts `read_all` kept, and L2 and L3 fail.
- **Discount.** The notes count, but the judge does not move on reading the report itself. It predicts `read_all` kept, and L2 and L3 fail.
- **Notes idle.** The notes do nothing; the report read by the judge turns it; otherwise the counts decide.
  - Where prose answers favour prose, it passes every contrast: `in_time` turns by the counts alone.
  - Only the control and the notes measure (below) separate it from H1-LA2: the control turns too, and the notes measure is not resolved.
- **A taste of its own.** The judge prefers one format whatever its reference set and the loss.
  - Preferring lists, it keeps `in_time` and `read_all`, and L2, L3 and L4 fail.
  - Preferring prose, it turns `late` and `unread`, and L1, L3 and L4 fail.
- **Readings near even.** The judge barely separates the formats, the course drifts, and the verdicts fall near chance (power check below).

## Predictions

**Per seed.**
- *Kept:* the share of list answers at step 8 is not below its share at step 4. This is the theorems' "never below", read at the end of the run.
- *Turned:* the share at step 8 is strictly below its share at step 4 (`read_all`) or at step 2 (`in_time`). Step 2 is the step after the reading at step 1, where the others are still the more numerous.
- A judge's reading with fewer than five valid picks after one re-ask leaves the rule in force at that step, and marks the seed invalid. An invalid seed counts against the prediction, and in the control it is neither kept nor turned.

**Per condition.** A condition passes if at least 4 of its 5 seeds go as predicted. The control has no verdict: the number of its seeds kept and the number turned are reported, by the same rules from step 2.

**Contrasts.** Each passes only if all its conditions pass.

- **L1, an unread loss leaves the lock** (`agreeing_stays`, then `lock_outlives_loss`): `unread` kept.
- **L2, a loss read by every reader turns the course** (`turned_by_loss`): `read_all` turned.
- **L3, who reads decides** (`Thinned.read_late_kept` against `turned_by_loss`): `late` kept and `read_all` turned. This is the same loss, at the same step and counts, read by the readers the selection thinned or by every reader.
- **L4, when it is read decides** (`Thinned.read_in_time_turns` and `read_late_kept`; in the mirrored case `turned_iff` and `kept_iff`; the witnesses `inTime_turned` and `late_kept`): `in_time` turned and `late` kept. This is the same readers reading the same loss, while the others are the more numerous or after.

**The unit of every test is a call.** The ten picks of one call need not be independent of one another (a judge can answer a whole call alike), while calls are. So no test below counts picks as independent. All are exact sign-flip tests over calls, at 0.05.

**Labels for a failed condition** (frozen, reported, not counted). A condition's first reading is its calls at steps 0 and 1 for `in_time` (ten calls), and at step 3 otherwise (five calls). Each call gives its share of list picks less one half, and one-sided sign-flip tests ask whether the calls lean to lists, or to prose. With five calls, a reading is resolved only where all five lean the same way.
- *Failed at the first reading:* the reading is resolved against the prediction.
- *Failed later in the course:* the reading is resolved for the prediction, but the course went otherwise.
- *Not resolved by the readings:* the reading is not resolved either way. The judge's picks then do not resolve the difference the verdict asks, and the failure does not tell a rival from noise.

**Two reported measures** (frozen, not counted), each a one-sided paired sign-flip test over calls alike in seed and step (the same counts, questions and orders), of whether the share of list picks is lower where the loss is read:
- *The notes where most readers carry them:* `in_time` against `in_time_unread` at steps 0 and 1 (ten pairs).
- *One note in nine:* `late` against `unread` at step 3 (five pairs).

**What the verdicts support, by frozen rules computed in [`analyze.py`](analyze.py)** (`supports`):
- *The others' readers read the loss:* where the notes measure is resolved.
- *The counts decide, one note in nine outweighed:* where L3 passes and the notes measure is resolved. Without the notes measure, `late` kept may only mean that the notes are idle.
- *The loss read in time turned a course that would otherwise be kept:* where L4 passes, the control is kept in at least 4 of its 5 seeds, and the notes measure is resolved.
- *`in_time` turned by the readers' counts alone, the loss not needed:* where L4 passes and the control turned in at least 4 of its 5 seeds. L4 then supports MA2's agreement law for this judge, but not a turn by the loss.
- *A single reading turned the lock (T7's third forbidden case):* where `late` fails, `unread` passes, `late`'s first reading is resolved for prose, and the one-note measure is resolved.
- *A loss read by every reader did not turn the course, a taste for lists ruled out:* where `read_all` fails with its first reading resolved for lists, and `in_time` passes.
- *No lock formed from the loop's own selections:* where `unread` fails with its first reading resolved for prose.
- *The readers that carry the loss, the more numerous, did not turn the course:* where `in_time` fails with its first reading resolved for lists.

## The power check: when the judge's picks resolve the verdicts

LA1's lesson, from `k3s1_lam32`, is that a verdict demanding a difference the feedback cannot resolve fails without telling the law from noise. Here the feedback of the selection is the judge's picks. Before the freeze, [`power.py`](power.py) ran the whole protocol 2,000 times with each scripted judge of [`scripted.py`](scripted.py), scored by the frozen rules ([`results/power.json`](results/power.json)).
- Each judge picks lists with a probability set by what it reads.
- Its ten picks in a call are drawn independently, or, for the judges marked "half the calls answered alike", a call gives all ten pairs one answer half the time.
- A prompt met twice in one replication gives the same picks, as a shared call does in the run.

The table gives the probability that each contrast passes, that the control is kept or turned in at least 4 of its 5 seeds, and that each measure is resolved.

| Judge | L1 | L2 | L3 | L4 | control kept | control turned | notes resolved | one note resolved |
|---|---|---|---|---|---|---|---|---|
| H1-LA2: pool; list answers 0.9, prose 0.4, with the loss 0.1 | 1.000 | 1.000 | 1.000 | 1.000 | 0.664 | 0.007 | 0.899 | 0.024 |
| H1-LA2: pool; 0.8, 0.4, 0.2 | 1.000 | 1.000 | 1.000 | 0.994 | 0.405 | 0.063 | 0.601 | 0.013 |
| H1-LA2: pool, weak formation; 0.7, 0.5, 0.2 | 1.000 | 1.000 | 0.999 | 0.999 | 0.858 | 0.003 | 0.896 | 0.028 |
| H1-LA2: pool, each kind for its own; 0.8, 0.2, 0.1 | 1.000 | 1.000 | 1.000 | 1.000 | 0.000 | 0.995 | 0.251 | 0.012 |
| H1-LA2: pool, near even; 0.6, 0.45, 0.4 | 0.921 | 0.905 | 0.830 | 0.494 | 0.201 | 0.183 | 0.097 | 0.013 |
| H1-LA2: pool 0.8, 0.4, 0.2, half the calls answered alike | 0.965 | 0.971 | 0.924 | 0.617 | 0.330 | 0.093 | 0.199 | 0.010 |
| a single reading suffices | 1.000 | 1.000 | 0.068 | 0.068 | 0.398 | 0.062 | 1.000 | 0.988 |
| formation alone | 1.000 | 0.000 | 0.000 | 0.717 | 0.006 | 0.729 | 0.027 | 0.009 |
| discount | 1.000 | 0.000 | 0.000 | 0.995 | 0.401 | 0.059 | 0.599 | 0.018 |
| notes idle, prose answers 0.2 | 1.000 | 1.000 | 1.000 | 0.999 | 0.000 | 0.991 | 0.034 | 0.011 |
| notes idle, prose answers 0.4 | 1.000 | 1.000 | 1.000 | 0.067 | 0.402 | 0.055 | 0.043 | 0.015 |
| notes idle, prose answers 0.4, half the calls answered alike | 0.964 | 0.991 | 0.963 | 0.075 | 0.331 | 0.088 | 0.038 | 0.008 |
| taste: lists (0.8) | 1.000 | 0.000 | 0.000 | 0.000 | 1.000 | 0.000 | 0.033 | 0.011 |
| taste: prose (0.2) | 0.000 | 1.000 | 0.000 | 0.000 | 0.000 | 1.000 | 0.027 | 0.009 |
| even (0.5) | 0.223 | 0.142 | 0.033 | 0.041 | 0.223 | 0.165 | 0.033 | 0.013 |
| even, half the calls answered alike | 0.220 | 0.140 | 0.034 | 0.031 | 0.200 | 0.175 | 0.040 | 0.013 |

**What the table and power.json show.**
- **Under H1-LA2** with independent picks, at any of these strengths short of near even, every contrast passes with probability at least 0.994.
  - Where half the calls are answered alike, L4 passes with 0.617.
  - The notes measure is resolved with probability 0.60 to 0.90, but 0.25 where prose answers already read strongly for prose and 0.20 where calls are answered alike. So it is reported, not a verdict.
  - The one-note measure needs all five pairs to lean one way, and stays at 0.01 to 0.03.
- **The tests hold their level.** Wherever the notes do nothing (formation alone, notes idle, a taste, even readings, with or without calls answered alike), the notes measure is resolved with probability 0.027 to 0.043.
- **Every rival** fails at least one contrast with probability at least 0.93, except notes idle where prose answers read for prose. With prose answers near even, notes idle fails L4 with probability at least 0.925.
- **The frozen support rules** (power.json, `P_supported`):
  - Under H1-LA2's pools with independent picks, short of near even, *the counts decide* holds with probability 0.25 to 0.90, and *the loss read in time turned* with 0.30 to 0.78. The one exception: where prose answers read for prose, the latter gives way to *turned by the counts alone* (0.995).
  - Where half the calls are answered alike, they hold with 0.19 and 0.08: the run then says less, and says so.
  - Under notes idle, *the others' readers read the loss* holds with probability 0.034 to 0.043, and *the loss read in time turned* with at most 0.005.
  - *A single reading turned the lock* holds with 0.890 under that rival and never above 0.001 elsewhere.
  - Under even readings, no reading of a failure holds with probability above 0.044.
- **Labels.** Where a rival fails the condition its account turns on, the label is *failed at the first reading* in 60% to 100% of those failures, and otherwise mostly *not resolved*.
  - The per-condition shares: 96% for a single reading at `late`; 64% for formation alone and 60% for discount at `read_all`; 100% and 85% for a taste for lists at `in_time` and `read_all`; 85% for a taste for prose at `late` and `unread`.
  - The labels are stricter than counting picks, because five calls resolve a reading only where all five lean the same way.

## What would change the account

Each case below is a frozen rule of `analyze.supports`.

- **A single reading turned the lock.** One note in nine turned a judge that keeps the lock without it. H1-LA2's second assertion fails for this judge (at 8 of 9 list answers with one note it did not favour lists), and T7's third forbidden case occurs in this system. A pool can be turned at 8 : 1 by one reading large enough even with `w` not above `u`, so what fails is H1-LA2 as stated, a pool counted by kind with these readings, not every pool. The timing law then does not apply to this judge.
- **A loss read by every reader did not turn the course, a taste for lists ruled out.** `turned_by_loss`'s premise fails for this judge and this report. A reading of the loss is then not a way out for it.
- **No lock formed from the loop's own selections.** T7's conjecture fails for this system on this trait: the judge was not formed from what it selected. Where `unread` fails with its first reading not resolved, the test does not tell.
- **The readers that carry the loss, the more numerous, did not turn the course.**
- **Every contrast passing.** By itself, this supports that a judge formed from its own earlier selections keeps its lock while an unread loss grows, and that the lock is left when every reader reads the loss and not when the readers the selection thinned read it late. What more it supports, whether the notes are read and whether the loss read in time turned the course, is decided by the rules above.

Each verdict is reported as it falls, failures first, with every answer kept in `results/calls.jsonl`.

## Cost

The first asks, with each call about a minute:
- 2 calls for the answers, and at most 48 more in the fallback (24 questions, each with one re-ask);
- at most 130 judge calls: 7 readings in each of `in_time` and `in_time_unread`, and 4 in each other condition, times 5 seeds. There are fewer where two conditions give the judge the same prompt.

That makes about 132 calls of Claude Haiku without the fallback. A re-ask can at most double a call, and a timeout is retried up to three calls; LA1 needed no re-ask in its first 174 calls.

The CLI needs the network, so the run is made outside the shell's sandbox: `python3 run.py all`, then `python3 analyze.py`. The run waits for approval of the model usage (board item AJ3).
