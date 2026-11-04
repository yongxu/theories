# What LA2's occurrence does to T7 (T7C)

Board item T7C, the coordinator's, 4 November 2026: the question AJE left open, from AA's Phase 0 erratum E15. The fronts told a reader that LA2 found "another case T7 forbids", and nothing said what that does to T7. Reading time: six minutes. AI-written.

## 1. The question

LA2 ([experiment](../../../../../../experiments/self-rewarding-lock/README.md)) froze its predictions before any call to the model. In its `late` condition, eight of the judge's nine readers were list answers, and one prose answer carried a note of the loss. The judge chose prose in all 50 picks of that reading; without the note it chose lists in 60 of 60. LA2 numbers this T7's third forbidden case. Since AJ8 it is the fourth in [02 §9](../../../../../../theories/becoming/chapters/02-MAP.md#t7): "a metric whose loss is read only by those it disfavours, dropped once the selection has left them no more than its carriers among its readers, with nothing else changed". AJ8 also added "more often than drift alone would allow", which LA2 did not test. Does the occurrence count against T7?

## 2. The answer: it counts against the fourth case

**The record** (`results/runs.json`, `late`, identical in all five seeds, since every call was unanimous):

| Step | Readers (lists : prose) | Note | Judge's picks |
|---|---|---|---|
| 3 | 8 : 1 | yes | prose, 10 of 10 |
| 4 | 9 : 0 | no reader carries it | lists |
| 5 | 7 : 2 | yes | prose, 10 of 10 |
| 6 | 9 : 0 | no reader carries it | lists |

- The rule in force turned to prose after each reading where the disfavoured carried the loss. It turned back only after the readings where no reader carried it.
- The share of lists was 32 : 1 at steps 4, 6 and 8, and lower at the odd steps.
- The frozen course rule, `kept`, compares step 8 with step 4 and lets a tie count. So `late` passed as kept only by an exact tie that holds at every even step. A run ending at step 5 or 7 would have printed it as turned.

**What T7 says.** Its premise is a metric whose rule and reading are formed from the share it selects. This judge meets it: `unread` passed, and the lock formed from the loop's own selections. The fourth forbidden case is stated of such a metric, not only of the model's pool of readers. So the case occurred in this system, at both readings, and LA2 counts against it as a claim about trained judges. It is kept as that counterexample.

**What else it counts against, and what stands.**
- It counts against H1-LA2, the bridge that such a judge is a pool of readers read by kind.
- The law of the rule as the pool of readers drawn from those it selects stands within its hypotheses, which this judge does not meet.
- T7's other forbidden cases are not touched.
- T7's *Refuted by* is narrower: it asks for no change in what is read. So it names no test of this case, and a refuter for the fourth case is open design work.

**My first decision, and why it was wrong.** The first draft (5dc96f6fe) found the opposite, on three grounds. One reader other than the author refuted all three:
- **"The metric was not dropped."** This rested on the frozen rule's tie, which is an artifact of the run's even end step.
- **"A loss entering what is read is a way out T7 allows."** This would excuse every instance of the fourth case, which forbids exactly that entry by the disfavoured.
- **"The case is a law of a pool read by kind."** This narrowed T7's *Forbids* after the result, against a premise the judge meets.

The lesson: read the per-step record before a frozen summary rule, and do not narrow a forbidden case to the model it was proved in once an instance appears.

## 3. Texts

- **[02 §9](../../../../../../theories/becoming/chapters/02-MAP.md#t7), the home:** LA2's paragraph now says what this does to T7, in the terms above.
- **[08](../../../../../../theories/becoming/chapters/08-METHOD.md#theses)'s T7 row:** the same, shortened.
- **The fronts, for ED2.** ONE-PAGE and its zh edition, and the overview and its zh edition, are under ED2's freeze.
  - ONE-PAGE says "another case T7 forbids", and the overview's T7 row says "a case T7 forbids". Both are true, but neither says what follows.
  - Proposed for ONE-PAGE: "one note of the loss among nine readers turning it at each reading where the loss was read, a case T7 forbids, so that case is contradicted in this system; the course passed the frozen rule only by an exact tie at its last step".
  - The overview's row: the same, with "the bridge, that such a judge is a pool read by kind, failed".
  - The zh editions to match. The overview's zh T7 row also lists three forbidden cases, the list before AJ8.

## 4. Review

One AI reader other than the author read the first draft adversarially against LA2's frozen record and T7's paragraph. Its findings reversed the decision (§2), and all are taken:
- **High:** "not dropped" rests on the tie; the "way out" point empties the case; the pool narrowing is post hoc; "the conjecture" named the wrong sentence, so the text now names H1-LA2.
- **Medium:** both readings, not one; the five seeds' courses identical; *Refuted by* names no test of this case; the fronts' proposed words corrected.
- **Low:** the 02 sentence split.

The same reader checks the revision: below.

## 5. The reader's check of the revision

(Filled after the reading.)
