# A lock in a self-rewarding loop: a trained judge formed from its own earlier selections (LA2)

Board item AJ3, 25 October 2026. AI-written (a Claude Code session). Claude Haiku writes answers to everyday questions. Claude Haiku as judge then selects between the list and prose versions of those answers. The judge reads a reference set drawn, by exact counts, from what the loop itself selected before, and a planted loss (failed deliveries of list answers) is read by nobody, by the readers the selection disfavours, or by every reader. The predictions come from closed capture and MA2 (`Becoming.ClosedCapture`), for thesis T7, and were frozen before any call to the model ([PREDICTIONS-2026-10-25.md](PREDICTIONS-2026-10-25.md); commit in [`results/FROZEN-AT`](results/FROZEN-AT)).

## Failures and limits, first

- **Verdicts.** None yet: the test has not run. When it runs, failed verdicts are listed here first, each with its frozen label: failed at the first reading, failed later in the course, or not resolved by the readings.
- **What the test can refute.** The theorems are about a pool of readers and its readings, and the loop's arithmetic is theirs (checked against MA2's witness numbers). What the test can refute, for this system, is T7's conjecture that a measure formed from what it selected is such a pool: the judge's reading counted by kind, its loss read as the conditions let it.
- **What a full pass alone does not show.** A judge on which the reviewers' notes have no effect would also pass every contrast. Only the control (`in_time_unread`) and the notes measure, both reported, tell it apart. The predictions file states, as frozen rules, what each outcome supports.
- **One judge, one trait.** The judge is a single model reading a reference set in context; formation by training is untested. The trait (list against prose) and the planted loss carry no weight of their own: nothing here says lists are worse.
- **The answers are generated in the run.** The model writes its answers in the run's first calls. Their content is not frozen, but the format of each pair is, and so are the rule that an answer counts only if its three lines are plain sentences, the fallback, and the rule that fewer than 20 valid answers means the test is not run.
- **Readings near even.** Near-even readings would leave the verdicts near chance. The power check says where that begins, and the labels report it.
- **Tests by the call.** A judge may answer a whole call alike, so every test takes the call as its unit, by exact sign-flip tests. With five calls a reading is resolved only where all five lean one way, so the labels and the one-note measure are strict. A judge that answers calls alike leaves the measures, and what they support, mostly unresolved; the power check shows how much.

## Files

| File | What it is |
|---|---|
| [loop.py](loop.py) | The counts, the course (`Pace.paced`), the reference set counted from the share, the loss and the five conditions (with the control) |
| [questions.py](questions.py) | The 24 questions |
| [agent.py](agent.py) | The model's two tasks: its answers (two calls and a fallback) and the judge's prompt; the call (`claude -p --model haiku`, one turn, in an empty folder), its guard and the cache, keyed by the prompt |
| [values.py](values.py), [results/values.json](results/values.json) | MA2's witness numbers reproduced by the loop's arithmetic; the course under `hi` before the judge reads; the loss |
| [power.py](power.py), [scripted.py](scripted.py), [results/power.json](results/power.json) | The power check: the frozen rules applied to scripted judges (the pool premise at several strengths, and each rival account), with the control and the two reported measures |
| [run.py](run.py), [analyze.py](analyze.py) | The protocol (the answers, then 5 conditions × 5 seeds) and the verdict rules, labels and reported measures |

**Status.** Frozen and not run. The run waits for approval of the model usage: at most 156 calls of Claude Haiku, about 132 without the fallback (board item AJ3). The CLI needs the network, so the run is made outside the shell's sandbox: `python3 run.py all` from this folder, then `python3 analyze.py`. Verdicts are added here as they fall.
