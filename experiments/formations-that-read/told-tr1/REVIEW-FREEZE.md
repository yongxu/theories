# TR1's freeze, read in rounds

*Board item TR1, 4 November 2026. AI-written (a Claude Code session): the record of the readers' rounds on [FREEZE-5](../FREEZE-5.md) and its code, as the coordinator set them. A full read first, by a reader other than the author, then the same reader on each diff. At most five rounds, stopping at the first with no finding of high or medium severity. About eight to ten minutes to read.*

Each reader called no model, used no key and edited nothing in the repository. What a reader ran was in a scratch copy.

## Round 1: a full read

Read in full: FREEZE-5.md, the five modules of `told-tr1/`, freeze 1's `run.py`, `verdicts.py`, `client.py` and `PINS.json`, and FREEZE-1's dated note on a log cut short. Read in part: `dry-run.json`, REST-TR1's §§3, 4, 6, 7 and 13, and the parts of `tr1.py` the rule uses. Its own runs in scratch reproduced R1, checked the shortest cycle against a brute force on 3,000 random sets, and checked the line writer on eight cases. It found no high-severity fault, and three medium ones, which kept the rounds going.

| Id | Severity | Finding | How it was taken |
|---|---|---|---|
| R1 | medium | The spend guard's call cap counted calls made again, so a start after a mend could stop early on the cap; and `--max-usd` was not said to be the folder's total. | Fixed: the cap is the records logged plus the calls left (`tr1_run.py run`). §6 and §10 say `--max-usd` is the folder's total over every start. The dry run's third pin makes H's 630 calls in full after calls made again. |
| R2 | medium | Once a condition had begun, its unreadable smoke answers stopped nothing, so a client broken by an addendum could misread the rest of its calls as the pin's. | Fixed: a begun condition's unreadable smoke answers are a stop of the run, lifted by a smoke run that passes (`smoke_stops`). §8 says so; the dry run checks it on T. |
| R3 | medium | One unreadable smoke answer of four stood for good, so T could be lost for a deciding pin on one answer, while the rule tolerates one in twenty. | Fixed: a stop stands only at two or more of a condition's four (`SMOKE_STANDS`); one is a stop of the run. §8 gives the chances, from the dry run: 0.014 a condition, 0.0278 on either deciding pin, against 0.1855 at one. The dry run checks one unreadable H answer. |
| R4 | low | §12 left out that the smoke run comes after the freeze and that no system prompt is sent. | Both added to §12 and to the first part's list. |
| R5 | low | §8 said a client addendum reading TR1's responses otherwise is taken "once TR1's runs are made and read", which would make its readings refuse. | §8 and §10 now say such an addendum is never taken by TR1; its runs and readings stay in a checkout of TR1's newest link. |
| R6 | low | §3 said a pin that declines often is "void, never contradicted". | Now: each counts only against strictness, making a condition void, never by itself contradicting it. |
| R7 | low | §12's case against a calibration subset holds for the fresh conditions, not for H, whose calls of one presentation fall close in time. | §12 limits it to the fresh conditions and adds H's case. |
| R8 | low | `begun` marked every condition a start asked for, so H was begun by a fresh call. | Fixed: a condition is begun by a call of that condition. The dry run checks a start of all four killed in the fresh calls begins no H. |
| R9 | very low | The module check left out freeze 1's `prompts`. | Added to the module check in `tr1_design.py`, the loop over the modules that must resolve to their own files. |
| R10 | very low | §6 said every module refuses `python3 -O`; `write_frozen.py` has no asserts. | §6: every module whose checks are asserts. |
| R11 | very low | §14 linked this file, which did not exist, and `FROZEN.sha256` is written only at landing. | This file; the hash file is committed last at landing, before the second link check. |
| R12 | very low | "Nine response shapes" and "400 random answer sets" were not in `dry-run.json`; TieN's H chance is the fresh figure. | Both recorded in `dry-run.json`, with the 92 formations' conditions; §9 says TieN's H figure is the fresh one. |
| R13 | very low | §6 dropped FREEZE-1's "each time it gets that answer" for a surrogate pair. | Restored. |
| R14 | very low | Wording: codes "not in alphabetical order" (sometimes they are); "not run" where the code says "no call read". | "Not put in alphabetical order"; "no call read" in §7 and §9. |

Besides, the reader confirmed the rule against Stage 0 line for line, the prompts, H's history through freeze 1's resume and reading, the line writer, the cut-short check, `mend`, the lock, the hashes and every figure the text cited.

## Round 2: the same reader, on the diff

Read: the whole diff of `tr1_run.py`, `tr1_design.py` and `tr1_dry_run.py`, FREEZE-5's changes as a word diff, this file in full, and the new entries in `dry-run.json`. Run in scratch: the third pin's kill, which gave the 100 calls made again. It found every fix doing what round 1's table says, and no new fault in `smoke_stops`, `begun`, `stood`, `smoke_needed` or the third pin's checks. No finding of high or medium severity, so the rounds stopped here, at two of the five allowed.

| Id | Severity | Finding | How it was taken |
|---|---|---|---|
| S1 | low | §8's chances, 0.014 and 0.0278, are per smoke run, and a pin may need more than one. | §8 says "per smoke run", that each smoke run exposes the conditions not yet begun again, and that T can be started once a smoke run passes it. |
| S2 | very low | `begun`'s docstring still said nothing at a smoke run stops a begun condition. | "For good", with its unreadable answers a stop of the run. |
| S3 | very low | Row R9 named `tr1_design._told_first`; the check is the loop over the modules. | Row R9 names the loop. |

What kept the rounds going: round 1's three medium findings (R1 to R3), each a rule that could lose or misread calls; round 2 found none.
