# Review of freeze 2 (TR4 and TR5): readers other than its author

4 November 2026. AI-written (a Claude Code session). Readers other than the freeze's author read the frozen files before the freeze landed, in rounds, each round checking the fixes of the one before. Every reader was a Claude Opus subagent, of the theory's own family, as is every reader this session can call ([FREEZE-2 section 6](../FREEZE-2.md#6-the-pins)). Each was given the files, the designs, freeze 1's harness and the requirements this freeze was given, not the author's conclusions, and worked read-only, with small checks of the code. None called a model. Round 1 found nineteen points, none high, three medium, and five departures from the design not yet listed. Round 2 checked each fix and found eighteen more, none high, three medium, all three confirmed by a verifier of their own. Round 3 checked those fixes and found eight more, all low, and nothing of high or medium severity remained. Every one is taken below, and where the fix differs from the reader's, the reason is given. The text it changed is [FREEZE-2.md](../FREEZE-2.md).

## Round 1: one reader, read-only

A Claude Opus subagent was given the frozen files, the designs, freeze 1's harness and the requirements the freeze was given, but not the author's conclusions. It worked read-only, with small checks of the code, and did not run the dry run or the power check. It is of the theory's own family, as is every reader this session can call (FREEZE-2 section 6). What it read: FREEZE-2.md and all eight `fresh/*.py` in full; `told/run.py` and `told/verdicts.py` in full; the protocol, verdict-rule, usage and freeze-choice sections of REST-TR4-TR5.md; the parts of `told/client.py`, `tr4.py` and `tr5.py` that the freeze uses; and every number in FREEZE-2 sections 8, 10 and 11, against the two JSON outputs. It confirmed that freeze 1's 13 files match their hashes.

It found no high-severity defect. Every finding was taken, as follows.

| # | Severity | Finding | How it was taken |
|---|---|---|---|
| M1 | medium | The strict listing schema makes a decline write a list of sides. A decline written with `[]` was read as an empty reading, so V5 was met by a decline. | `classify_listing` reads any decline as `(decline, None)`: it states no reading, and V4 and V5 read none from it. A dry-run case sends exactly that response; FREEZE-2 section 2. |
| M2 | medium | The pin reported apart got a C verdict when the deciding pins' harness check rejected. | It is read only where the shared check passed. A dry-run case with a harness leak in G checks it. |
| M3 | medium | TR4 gave no verdict to any deciding pin unless both were complete, and FREEZE-2 did not say so; the release order implied a verdict per pin. | Holm's families are now fixed (G over 4, C over 8). A pin void for C, unmeasured or not read counts with p-values of 1, so the other is read at the full families' thresholds, never lower. The reading is *pending* until both deciding runs are complete; `verdicts --final` reads it where one cannot be completed. FREEZE-2 sections 3, 8 and 12; dry-run cases. |
| L1 | low | Filtered answers were not reported apart from unreadable ones. | Counted apart per arm in both rules. |
| L2 | low | "The harness check stops the run" is not what happens, since G's calls are made with C's. | Now "withholds every C verdict"; listed in section 12; power.json's keys renamed. |
| L3 | low | V3's false-contradiction rate was given as at most 0.020; it is 0.024 for the step count with 5% noise. | Corrected. |
| L4 | low | "Explicit leaks ≥ 0.998" was too broad. | Narrowed to the faulty line; the other-line leak, 0.940, added. |
| L5 | low | The dry run compared fewer of `stage_b`'s fields than claimed. | Extended to the 21 fields the rule reads or reports. |
| L6 | low | "An id is made once" was overstated. | Now "logged once", with the case `execute` logs nothing for. |
| L7 | low | The Holm last-step wording was ambiguous. | Now "where the other deciding pin's four are rejected". The author also removed the pin reported apart's "last step at 0.05": in a family of its own four measures it has no meaning, and printed it read as a false-alarm rate of 0.06 to 0.085. |
| L8 | low | The stand-ins read the call's arm and mode, not only its messages. | Said in FREEZE-2 section 11 and the dry run's docstring. |
| L9 | low | The count of filtered answers in a row restarted at each batch. | `run_batches` also reads it across batches from the log; a dry-run check on a hand-made log. |
| L10 | low | After a move mid-batch, a bad attempt's calls not yet made were still made, paid for and never read. | A bad attempt keeps only its logged calls in the plan. The TR4 move is now at the read after 100 calls, mid-batch, and the dry run checks that no call of a bad attempt is made after the move. |
| L11 | low | The cap of 4 attempts was undocumented. | Stated in sections 1 and 12. |
| L12 | low | The call ceiling is in a fixed file. | Stated in section 7. |
| L13 | low | An entry that is exactly "invalid" or "filtered" is read as unreadable. | Kept as a stated limit (section 2), with a parser fixture. Fixing it would change freeze 1's classes, which an addendum may not do. |
| L14 | low | A refusal-field decline in a smoke listing stopped the smoke run. | Exempted. |
| L15 | low | Untested paths: TR4's invalid and filtered answers and its minimums; TR5's filtered history; the listing decline. | Dry-run cases for each (section 11). |
| L16 | low | Dead code in `members()`. | Simplified, with the same output. |
| D1–D5 | — | Departures not listed in section 12: a reason on TR4's crew calls; TR5's pass needs no void episode; the apart pin's G; the attempts cap; G and C in one run. | Each listed in section 12, with its reason. |

After the fixes, the power check and the dry run were run again on the changed code. Every check holds.

## Round 2: three readers, three verifiers

Three readers, each with a lens of its own:
- **the fixes**: whether each of round 1's fixes was made, complete and without regression;
- **the code**: the frozen code read whole, for a defect round 1 did not find;
- **the text**: whether FREEZE-2, the status lines and the records say what the code and the two outputs do.

What each read is in its own report. All three read FREEZE-2 and every `fresh/*.py` in full. The fixes reader and the text reader checked every rate quoted in FREEZE-2 sections 8 and 10 against `power.json`, and every check against `dry-run.json`. The code reader read freeze 1's `run.py`, `verdicts.py` and `client.py` in full. Small checks were run under `nice`: rule4 on empty inputs, the entry parser on "filtered", "invalid", " Filtered " and "decline.", and a stub view through TR5's smoke plan. Each medium finding went to a verifier of its own, told to refute it. Each of the three held: the verifier read the code path and found the scenario real, at medium severity.

The fixes reader confirmed round 1's M1 to M3, L1, L3, L4, L7, L8, L11, L12, L14 to L16 and D1 to D5 made, complete and without regression. It confirmed L10 by code and the dry run for TR4, and by code only for TR5. The other fixes it found incomplete, below.

| # | Severity | Finding | How it was taken |
|---|---|---|---|
| M4 | medium | A listing answered with a decline counts as resolved and states no reading, so V4 and V5 skip it, and nothing stopped a pass: a pin declining at every listing could pass with V4 and V5 read at no listing. | The reader's option (a): a resolved listing that is a decline makes the outcome unresolved, not a pass, as a void episode does (`rule5.outcome`). FREEZE-2 sections 5 and 12; the dry run's listing-decline case now expects unresolved. |
| M5 | medium | TR5's smoke run planned its conversation's second step whenever the first answer was an act, back and decline included. Neither has a successor at the start, so building the second prompt raised an error. | The second step is planned only where the first act has a successor at the smoke world (`tr5_live.smoke_plan`). The dry run's smoke check runs the first step answered back and declined, 9 calls each. FREEZE-2 sections 9 and 11. |
| M6 | medium | DESIGN's TR5 line said 9 episodes "separates" a commitment carried in 30% of conversations; power.json gives 0.616. Its "noise … at most 1.4%" is the figure at 3 episodes. | "Catches it in 0.62 of runs (0.006 at 3)", with V3's false contradictions under 5% noise rising to at most 0.024; the 1.4% tied to 3 episodes. |
| L17 | low | The filtered count read across batches is checked after each batch, and `execute`'s own count starts again in each, so a run of filtered answers spanning two batches can reach 39 before the run stops. | Kept, and said: the run stops by the end of the batch in which twenty in a row are reached, at most 39 then logged (FREEZE-2 section 7, `run_batches`' docstring). Stopping at twenty exactly would change freeze 1's `execute`. Round 3 bounded it further (L33). |
| L18 | low | Round 1's L6 reached FREEZE-2 but not `layer.py`, whose docstrings still said no id is made twice. | `layer.py` says, as section 1 does, that no id is logged twice, and a call `execute` stops at is logged nowhere and made again. |
| L19 | low | The known limit (section 2) said an entry exactly "filtered" is read as unreadable; it is read as the provider's filter, counted with the filtered and toward the stop. | Reworded. |
| L20 | low | power.json's thresholds still had the key `tr4_G_stop`. | Renamed `tr4_G_withhold`, with the constant. |
| L21 | low | Section 11's "every field of `stage_b`'s result the rule reads or reports" left out `any_failing_modal`. | Added to the compared fields, now 22. |
| L22 | low | TR5's part-way move (a bad attempt's unmade calls dropped) is checked by no case: its dry-run move falls at a batch's closing read. | First said to be read only, on the ground that the stand-ins make no batch over 100 calls; round 3 found that ground false (L32), and a case now runs it. |
| L23 | low | Episodes were made where the whole audit is already void, whose outcome they cannot change. | No episode is made where the whole audit is void (`tr5_live.build`), sparing a void pin's calls; the void stand-in makes none either way, so the comparison with `stage_b` holds. FREEZE-2 sections 4 and 5. |
| L24 | low | `rule4.verdicts`' docstring said a pin void for C counts at p-values of 1 in both families; the code reads its G and puts only its C at 1. | Docstring and section 3 now say what the code does: void for C, C at 1 and G as measured; G unmeasured, both at 1. |
| L25 | low | Section 2's "a crew is not called where its clerk's answer is unreadable" reads per situation; in the code one unreadable clerk entry stops all of the unit's crews. | Reworded to the code's rule. |
| L26 | low | The dry-run label "a read answer ends the run" says the opposite of what is checked. | "A read answer starts the count again." |
| L27 | low | Section 7 left out that an addendum may also change a pin's `served_as` in `PINS.json`, which `run.chain` allows. | Added. |
| L28 | low | A departure not listed: the design put the smoke run before the freeze, to check the parser and the prompt property; here it follows the freeze and checks no prompt property, and a parser fault it finds needs a new freeze. | Listed in section 12, and said in section 9. |
| L29 | low | The TR5 power table's mean calls leave out the 15 calls outside the relation, so they do not match the 747 elsewhere. | The column says so. |
| L30 | low | The TR4 expectation (section 14) said C not contradicted and m1 or m4 rejecting, which contradicts C. | Split: m2 not rejecting, so RF6.1's forbidden case not met; m1 or m4 rejecting for a pin whose clerks name a member or a line, C then contradicted only in that the reading in force is not the register's rule. The expectation was written before any call and is changed here only so that it states one thing; no call has been made. |
| L31 | low | Section 15 linked this file before it existed, and said one reader. | This file; section 15 says two rounds. |

After the fixes, the power check and then the dry run were run again on the changed code. Every check holds.

## Round 3: one reader

One reader checked round 2's fixes, the new code first: the declined-listing guard, the smoke run's successor guard, the episodes skipped on a void audit and what reads them downstream, and the new smoke cases. It read FREEZE-2, this file and six of the eight `fresh/*.py` in full, and every number in FREEZE-2 sections 8 and 10 and DESIGN's TR5 line against the two outputs; it ran small checks on stub views (the outcome on synthetic scores, a void audit with a failing pair at its root, the smoke plan under each first answer, batch sizes per stand-in). It confirmed M4 to M6, L18 to L21, L23, L24 and L26 to L31 made, complete and without regression, and found no defect of high or medium severity. A verifier was to be called for any; none was needed.

| # | Severity | Finding | How it was taken |
|---|---|---|---|
| L32 | low | L22's ground is false: an episode set's first steps are planned in one batch, 18 calls a course, so stand-ins with six courses make batches of 108, and some audit and listing levels reach 105 to 150. Only the planner's batches, which the move case used, stay under 100. | A second TR5 move case, on the step-count stand-in, moves the catalog at the first read `execute` makes after 100 calls, part way through a batch; the dry run checks that the run stops, the units are made again, no call of a bad attempt is made after the move, and the verdict equals the run with no move. FREEZE-2 section 11. |
| L33 | low | "At most 39" holds at `--parallel 1` only; under a thread pool, calls in flight when `execute`'s count reaches twenty are still logged. | Section 7 and `run_batches`' docstring say so: up to the parallel setting less one more. |
| L34 | low | Where the smoke conversation ends at its first step, no carried call is measured and TR5's projection is "not measured", while sections 8 and 9 said the guard is set from the projection. | Said in sections 8 and 9: the guard then rests on section 8's estimate. `fresh_run.py` unchanged. |
| L35 | low | L25's rewording named the unreadable entry only; the code withholds the crews on a filtered entry too. | "Filtered or unreadable", in section 2, section 11 and the dry run's label. |
| L36 | low | Section 11 understated the fields compared with `stage_b` (three more are) and left the carried-commitment stand-in out of the contradicted. | Both added. |
| L37 | low | `tr5_live.py`'s docstring still made episodes on any whole audit, and gave a prompt as a function of the history and menu alone. | "Whole and not void"; "the visible history, the menu's order and its kind". |
| L38 | low | The listings resolved count declines, at which V4 reads nothing, and a void audit tests no failing pair; neither was said. | Said in section 5's reported list. No rule changed. |
| L39 | low | The files did not show that `dry-run.json` came from the final code: it was written 52 seconds after the last code change, for a run that takes longer. | It did: the run started after that change (the one before it was stopped and run again). The dry run was in any case run once more on the final tree, after round 3's fixes, its output newer than every frozen file. |
