# A lock in a self-rewarding loop: a trained judge formed from its own earlier selections (LA2)

Board item AJ3, 25 October 2026. AI-written (a Claude Code session). Claude Haiku writes answers to everyday questions. Claude Haiku as judge then selects between the list and prose versions of those answers. The judge reads a reference set drawn, by exact counts, from what the loop itself selected before, and a planted loss (failed deliveries of list answers) is read by nobody, by the readers the selection disfavours, or by every reader. The predictions come from closed capture and MA2 (`Becoming.ClosedCapture`), for thesis T7, and were frozen before any call to the model ([PREDICTIONS-2026-10-25.md](PREDICTIONS-2026-10-25.md); commit in [`results/FROZEN-AT`](results/FROZEN-AT)). Run on 25 and 26 October 2026; the verdicts are [below](#verdicts).

## Failures and limits, first

- **The bridge failed: one note in nine turned the judge.** H1-LA2 says that the judge's reading is a pool of the readers it shows, counted by kind. Its second assertion is that where 8 of 9 readers are list answers, with no note or with one, the judge favours lists.
  - With no note it chose lists in 60 of 60 picks.
  - With one note, on the one prose answer, it chose prose in all 50 picks of `late`'s first reading, in all five seeds.
  - At that step `late` and `unread` share their counts, questions and orders, and differ only in the note. The one-note measure is resolved (p = 0.031).

  This is the first outcome the predictions file lists under what would change the account. H1-LA2 as stated fails for this judge, T7's third forbidden case occurs in this system, and MA2's timing law does not apply to it.
- **`late` passed by a tie, not a lock.** Its seeds count as kept because, by the frozen rule, the share at step 8 is not below the share at step 4. The course did not lock.
  - From step 4 it alternated between 32/33 and 32/43, and its share at step 8 equalled its share at step 4 exactly.
  - At steps 5 and 7 the share was below its value at step 4, where the theorems' lock says "never below".
  - The frozen rule reads only the end. The power check's scripted judges vary their picks from call to call, which made an exact return improbable, but this judge answered 112 of its 119 calls all one way.
  - L3 and L4 pass by the same tie.
- **A frozen support is contradicted by the data.** By its frozen rule (L3 and the notes measure), `analyze.supports` prints *the counts decide, one note in nine outweighed* as supported. That rule consults neither the one-note measure nor `late`'s first reading, and both show the opposite, so it is not claimed here. *A single reading turned the lock* is printed as not supported only because its rule needs `late` to fail. Every other part of that case holds.
- **The verdicts as frozen.** No frozen verdict failed: every condition went as predicted in 5 of 5 seeds, L1 to L4 passed, and both reported measures were resolved. The verdicts stand as frozen, and the three points above say what they do not show.
- **What the test can refute.** The theorems are about a pool of readers and its readings, and the loop's arithmetic is theirs (checked against MA2's witness numbers). What the test can refute, for this system, is the bridge T7 rests on here, H1-LA2, that a measure formed from what it selected is such a pool: the judge's reading counted by kind, its loss read as the conditions let it.
- **One judge, one trait.** The judge is a single model reading a reference set in context; formation by training is untested. The trait (list against prose) and the planted loss carry no weight of their own: nothing here says lists are worse.
- **The answers were generated in the run.** All 24 were valid in the first two calls, so the fallback was not used. Their content is not frozen, but the format of each pair is.
- **All-or-nothing readings, tests by the call.** The power check guarded against readings near even. This judge's were the opposite: every one of its 119 distinct calls gave ten valid picks, and 112 gave all ten to one format. Every test takes the call as its unit, by exact sign-flip tests, so with five calls a reading is resolved only where all five lean one way. Here they did.

<a id="verdicts"></a>
## Verdicts

Scored by the frozen [`analyze.py`](analyze.py) ([`results/VERDICTS.json`](results/VERDICTS.json)). The last column is post hoc (below): whether the share and the rule in force went the predicted way at every step from the step the verdict starts from, not only at the end.

| Condition | Predicted | Seeds as predicted | Verdict | First reading: calls, mean share of list picks, side (p) | Held at every step (post hoc) |
|---|---|---|---|---|---|
| `in_time` | turned from step 2 | 5 of 5 | passed | 10, 0.00, prose (0.001) | 5 of 5 |
| `in_time_unread`, the control | no prediction | kept in 1, turned in 4 | no verdict | 10, 0.43, not resolved | |
| `late` | kept from step 4 | 5 of 5 | passed | 5, 0.00, prose (0.031) | 0 of 5 |
| `unread` | kept from step 4 | 5 of 5 | passed | 5, 1.00, lists (0.031) | 5 of 5 |
| `read_all` | turned from step 4 | 5 of 5 | passed | 5, 0.00, prose (0.031) | 5 of 5 |

- **Contrasts.** L1, L2, L3 and L4 passed.
- **Measures.**
  - The notes where most readers carry them: 10 paired calls, mean fall in the share of list picks 0.43, p = 0.016, resolved.
  - One note in nine: 5 paired calls, mean fall 1.00, p = 0.031, resolved.
- **What the frozen rules print** (`supports`):
  - supported: *the others' readers read the loss*;
  - supported: *the counts decide, one note in nine outweighed*. The one-note measure and `late`'s first reading contradict it, and it is not claimed (above);
  - supported: *`in_time` turned by the readers' counts alone, the loss not needed*. Its L4 part passes by `late`'s tie. The control alone turned in 4 of 5 seeds with nothing reading the loss;
  - not supported: *the loss read in time turned a course that would otherwise be kept*, since the control turned in 4 of 5 seeds;
  - not supported: *a single reading turned the lock (the third forbidden case of T7)*. Its rule needs `late` to fail, and the rest of it holds (above);
  - not supported: *a loss read by every reader did not turn the course*, *no lock formed from the loop's own selections* and *the readers that carry the loss, the more numerous, did not turn the course*.

## How the run went

- Started on 25 October 2026 at 23:00 (+08), from the frozen commit, outside the shell's sandbox. The desktop app was quit at 23:10, which stopped the run after 10 calls.
- It was resumed at 23:29 from `results/calls.jsonl`, whose calls are reused by their prompt's hash as the protocol provides, and finished at 00:05 on 26 October ([`results/run-2026-10-25.log`](results/run-2026-10-25.log)). No deviation from the frozen protocol.
- 121 calls: 2 for the answers, and 119 distinct judge calls of the 130 the protocol allows, 11 being shared by conditions that gave the judge the same prompt. No re-ask, no timeout, no invalid seed.

## Post hoc (the AI's reading, not frozen)

[`posthoc.py`](posthoc.py), written after the verdicts ([`results/POSTHOC.json`](results/POSTHOC.json)).

**The judge's readings by what it read.** Each cell gives the list picks of all picks, over distinct calls (a call two conditions shared is counted once), with the number of calls.

| Reference set | Nothing reads the loss | Notes on its prose answers | The delivery report |
|---|---|---|---|
| 0 lists : 9 prose | 0 of 160 (16) | 0 of 250 (25) | |
| 1 : 8 | 3 of 80 (8) | 0 of 50 (5) | |
| 2 : 7 | 3 of 10 (1) | | 0 of 50 (5) |
| 3 : 6 | 47 of 60 (6) | 0 of 50 (5) | |
| 5 : 4 | 10 of 10 (1) | | |
| 7 : 2 | 9 of 10 (1) | 0 of 50 (5) | 0 of 50 (5) |
| 8 : 1 | 60 of 60 (6) | 0 of 50 (5) | 0 of 50 (5) |
| 9 : 0 | 150 of 150 (15) | | 0 of 50 (5) |

- **Formed from its own selections where nothing reads the loss.** Without a note or the report, the judge's picks follow the reference set's counts: none for lists where it shows no list answer, every one where it shows nine. In `unread` the course locked at its first reading and stayed locked at every step, while the unread loss grew to 45 by step 8. That is T7's lock, formed from the loop's own selections, in this system.
- **Any reading of the loss outweighs the counts.** Wherever a note or the report was in its input, the judge chose prose in all 650 picks, one note among nine readers included. As the predictions file says, what fails is H1-LA2 as stated, a pool counted by kind with these readings, not every pool: a pool in which one reading of the loss is large enough would read the same.
- **Neither kept nor left: a threshold reading, read one step late.** In `late` only the prose answers in the reference set read the loss, and the set of nine holds one exactly where the share is below 17/18. Read as a rule of the share, the judge's reading there is a threshold reading: lists at or above 17/18, prose below. The rule read at one step is in force from the next, so from step 4 the course alternated between 32/43 and 32/33 while the loss grew. The readers the selection thins do read the loss, and the selection then removes them from what is read.
  - Capture through the rule has this course in its witness `RuleCapture.Alternating` ([02](../../theories/becoming/chapters/02-MAP.md#r-capture-through-the-rule)): a threshold reading, read one step late from a start against it, alternates and is locked neither way at any step (`RuleCapture.Alternating.never_locked`). There the threshold is at an even share and the rules are four to one each way.
  - MA2's laws assume a pool counted by kind and do not describe this judge. What no theorem states is how such a threshold arises from the readers, as the share at which the last reader of the loss leaves the reference set.
- **What turned for good.** The report, read by every reader, turned the course at its first reading and kept it turned at every later step (`read_all`). In `in_time` the course turned and stayed turned, and the control shows that the counts at 1 : 8 alone turned it in 4 of 5 seeds.

## Files

| File | What it is |
|---|---|
| [loop.py](loop.py) | The counts, the course (`Pace.paced`), the reference set counted from the share, the loss and the five conditions (with the control) |
| [questions.py](questions.py) | The 24 questions |
| [agent.py](agent.py) | The model's two tasks: its answers (two calls and a fallback) and the judge's prompt; the call (`claude -p --model haiku`, one turn, in an empty folder), its guard and the cache, keyed by the prompt |
| [values.py](values.py), [results/values.json](results/values.json) | MA2's witness numbers reproduced by the loop's arithmetic; the course under `hi` before the judge reads; the loss |
| [power.py](power.py), [scripted.py](scripted.py), [results/power.json](results/power.json) | The power check: the frozen rules applied to scripted judges (the pool premise at several strengths, and each rival account), with the control and the two reported measures |
| [run.py](run.py), [analyze.py](analyze.py) | The protocol (the answers, then 5 conditions × 5 seeds) and the verdict rules, labels and reported measures |
| [results/calls.jsonl](results/calls.jsonl), [results/answers.json](results/answers.json), [results/runs.json](results/runs.json), [results/VERDICTS.json](results/VERDICTS.json), [results/run-2026-10-25.log](results/run-2026-10-25.log) | The run: every call with its prompt and answer, the 24 answers, the courses, the verdicts and the run's log |
| [posthoc.py](posthoc.py), [results/POSTHOC.json](results/POSTHOC.json) | Post hoc, not frozen: the judge's readings by what it read, H1-LA2's assertions checked on them, the courses step by step |

**Status.** Run from the frozen commit on 25 and 26 October 2026 (121 calls of Claude Haiku), outside the shell's sandbox: `python3 run.py all`, then `python3 analyze.py`; `python3 posthoc.py` gives the post hoc readings.
