# TR1A's freeze, read in rounds

*Board item TR1A, 5 November 2026. AI-written (a Claude Code session): the record of the readers' rounds on [FREEZE-10](../FREEZE-10.md) and its code, as the coordinator set them. Round 1 is a full read by a reader other than the author; then the same reader reads each diff. There are at most five rounds, stopping at the first with no finding of high or medium severity. About nine to twelve minutes to read.*

Each reader called no model, used no key and edited nothing in the repository. Anything a reader ran was run in a scratch copy.

## Round 1: a full read

**What the reader read.**
- In full: FREEZE-10 (then numbered 9), the six modules of `told-tr1a/`, its `dry-run.json`, FREEZE-5's `tr1_run.py` and `tr1_rule.py`, and REST-TR1 §§7 to 13.
- In part: freeze 1's `run.py`, `verdicts.py` and `client.py`, the parts of `tr1.py` the rule uses, and 03 at both anchors.

**What the reader ran, in scratch:**
- a crafted log for the rounds check;
- P1's testability over all 120 strict orders on five contents;
- the power and the void clauses over every pattern;
- the item-score class on 300 seeds of its own on the order, and on 100 on labels carrying no order.

It found two faults of high severity and five of medium, which kept the rounds going.

| Id | Severity | Finding | How it was taken |
|---|---|---|---|
| A1 | high | Stage A read each trained chooser from 9 draws, and a cell was contradicted where any of 20 seeds was. A near tie then gives strict picks either way by chance: on labels carrying no order, the item-score class read contradicted on 5 of 100 seeds from draws, every one an exact tie. | Fixed. Each chooser is read on its exact choice probabilities. A pick is strict where 8 of 9 draws would name it with chance at least one half (`tr1a_stage_a.read`), so a near tie is strict neither way. The dry run checks a hand-set near tie. FREEZE-10 §§9 and 12 say why. |
| A2 | high | The rounds check could never report. It kept a record only where it was the very object `verdicts.load` read, from a separate reading of the log. FREEZE-5's check of H's histories has the same fault. | Fixed here: a record read is its id's latest in the log, compared by position (`tr1a_run.rounds_apart`). The dry run gives it a case it must flag and one it must not. FREEZE-5 gets a dated note (its §16): its report reads empty whatever the log holds, its guarantee is section 6's argument, and no addendum can mend the code. |
| A3 | medium | V1 could pass with only stated occasions strict, or only told ones. Its second void clause could never be met. | Fixed. V1 is void where no pair has both a strict stated occasion and a strict told one (`tr1a_rule.v1`). The power is recomputed; the void column rises a little (1.6 × 10⁻⁴ at a tremble of 1/20). |
| A4 | medium | The reason given for chains as the hidden orders was false. The met pairs are fixed. 50 of the 120 orders join nothing beyond them, a minority. Every order leaves P1 readable. | FREEZE-10 §12 states the chain as a choice: the met reach then joins every pair of 0 to 3, so P1 reads transitive inference on three pairs never shown, with the reader's counts. |
| A5 | medium | X asked what the other option pays right after the telling. That checks recall, not belief: a distruster could pass it and then be contradicted across frames. | X now asks what the player expects to receive from the other option in round 2. FREEZE-10 says it reads that the telling is taken into what is expected, not that it is believed, and that a contradiction can still come from a player that repeats the telling and does not act on it. |
| A6 | medium | The negative control had no stated purpose. Its labels were keyed by class. "Carries no order whatever the shuffle" was false (13 in 100 draws accord with an order). The unjoined bias was computed against an order that played no part in the labels. | The control's purpose is stated: each class's reading with no order to learn. Its labels are now shared by the classes at each seed. The claim is corrected, and the unjoined bias is not defined under labels carrying no order. |
| A7 | medium | A pin whose X stop stands was run on U and I, but their shares were read only where the premise was. X's answers were the numbers "2", "5" and "8", which a provider returning a JSON number would leave unread. | The course shares are read wherever U and I are read whole, and only the class needs the premise. X's three amounts are lettered P, Q and R. |
| A8 | low | The class ignored T and I in down, and read an explorer from one name order. | A class is read only where V1 passed, and an explorer needs both name orders. The table's presentation readers and frame-inconsistent formation are now named by where their cycle lies (`the cycle's places`). |
| A9 | low | "V1 contradicted: the correspondence fails across frames" left out cycles within a frame. | Corrected: "among the eight occasions, within a frame or across frames", with the places reported. |
| A10 | low | "Each reads as the table says" claimed more than the asserts. The courses lag the table's by a step. A trembling formation passed on the void floor itself. | FREEZE-10 §10 says what is asserted (the reading, the class and the cycle's places) and notes the lag. A trembling formation is asserted only not contradicted. |
| A11 | low | A pin declining every call was classed "untrusting". | It is now classed "the check failed". |
| A12 | very low | It is not true that every FREEZE-5 addendum refuses this folder. | Qualified: only one that changes a file this freeze lists. |
| A13 | very low | The estimate's stand-in rounds were not the longest. | The stand-in is now the longest line (an answer not read). The estimate is $1.80 to $20.93. |
| A14 | very low | The reading time did not match the reader's raw count, and a round logged out of order surfaced as an uncaught error. | The time is the repository's measure (`navigation.reading_time`), as AGENTS.md says. The out-of-order round is now refused with its reason. |

The reader also confirmed:
- the power, recomputed in full, including the design's six-occasion figures;
- the cycle rule on three amounts;
- that the uninformed words are the same in both worlds;
- that the rounds, the run's prepare and the reading's rebuild build alike, and that remakes are a suffix of the log;
- the run module, line for line against FREEZE-5's, and the import of FREEZE-5's helpers;
- the three gradients, analytically, and the positive control, on 300 seeds of its own;
- that the dry run trains no comparator or set-input network to a reading;
- every figure the text cited.

Its runs of the item-score class on labels carrying no order, read from draws, previewed that cell's tendency under the old reading. FREEZE-10 §9 says so.
