# Review of TR7's Stage A freeze (FREEZE-9): an independent reader, round by round

5 November 2026. AI-written (a Claude Code session). A reader other than the author read the frozen files before the freeze landed: a fresh Claude Opus subagent, of the theory's own family. It read them whole in the first round. From the second round on, by the coordinator's rule, the same reader, continued, reads the diff of the last round's fixes and the sections they touch, and checks this record rather than trusting it. The rounds stop at the first with no finding of high or medium severity, at most five. The reader was given the files, the design and FREEZE-4, not the session's conclusions. It worked read-only, with exact computations of its own in scratch outside the worktree, trained no learner and called no model. Each round read a commit on the branch, so the files it read are kept in the history. Round 1 found five faults of medium severity and twenty-five of lower, all taken. Round 2, on the diff of their fixes, found none of high or medium severity, so by the rule it was the last: its eleven findings were taken after it, checked by the dry run and the author's own tests, and not read again.

## Round 1: a full read of the draft (commit 435878ce7)

No high finding, five medium, thirteen low and twelve very low.

| Id | Severity | Finding | How it was taken |
|---|---|---|---|
| E9-01 | medium | An unbiased step makes each step's expected increment the exact gradient at the current logits, not the mean over seeds the reference curve, since a step is not linear in the logits. At the ties seeds leave the even split by construction: at A5 the split has no drift once the pair holds the mass and spreads by 0.15 a step. `tr7.json` holds curves for ten of the seventeen runs. | Taken. FREEZE-9 and both scripts now say a learner follows the curve to first order in a step's noise, and that the run shows how far sampled paths depart. Section 2 says the even split is the deterministic curve's end, no seed's expectation, with the reason at A5 and at A3. Section 3 names the ten runs `tr7.json` holds; Stage 0 gives the other seven; a new dry-run check compares the ten. |
| E9-02 | medium | The coordinator's sentence: the per-run figures are right (0.0207, 0.0013, about 0.014 over the eleven), the conclusion wrong. The reading's support needs all eleven runs, an intersection-union test, so it is controlled at 0.021 with no correction. What is uncorrected is one run's support read alone (about 0.21 that some run passes by chance). "Weaker evidence" and "not a controlled finding" are wrong for the reading. | Taken in the reader's words: the opening and sections 4 and 5 now state each level. |
| E9-03 | medium | Overstatement: the reading signs only whether each seed ends nearer the law's end than it began, not the path or the end. A seed from 0.25 to 0.26 counts, and so does a B3 seed falling to 0. | Taken: "supported" now says at least 15 of 20 seeds ended nearer the law's end than they began, the direction the curves move, and nothing of the path. The standing question and what can tell against the curves are restated to match. |
| E9-04 | medium | FREEZE-4's `MAY_CHANGE` includes `told/client.py`; FREEZE-9's did not, though its link would have listed that file at freeze 1's hash. After a client addendum in freeze 1, which FREEZE-4 is built to take, this folder's check would refuse for good, with no addendum able to mend it. | Taken by the reader's second fix. This folder's link lists only its own files, and FREEZE-4's check, run first, holds the imported files at FREEZE-4's newest link. FREEZE-4's addenda change only files Stage A does not use. "What is frozen" and section 8 state the dependency and the remedy: until FREEZE-4 takes its own addendum, run in a checkout of this freeze's newest link's commit (made complete in round 2, E9-33). |
| E9-05 | medium | The reading took whatever `stage-a.jsonl` held, with no frozen check. Records named no link. A run counted as complete at 20 records, so a duplicate could stand in for a lost seed, and condition, learner, start and role were not compared with the runs. | Taken. `run` stamps each record with the link, its commit and the head. The reading runs the frozen check. It refuses a run or seed not frozen, a learner twice, fields not the run's, a final policy of the wrong shape, and a record not stamped with a link of the chain. Ten dry-run checks plant each case. |
| E9-06 | low | "The noise near the end shrinks … a chance learner … holds there" is false at an interior best chance: the expected gradient vanishes, one episode's estimate does not, and the chance keeps a spread of about 0.03 on B2's prospects, 0.02 at the witness. | Taken. Section 5 says so; Stage 0 now computes the spread, linearized: 0.028 and 0.024. |
| E9-07 | low | Zero noise holds only for the expected-points baseline. The stronger fact went unstated: the leave-one-out advantages sum to zero in every batch, so at A3 and B4 no step moves the statistic against the law, and those runs cannot fail. | Taken. Section 3 gives the argument and the chance a seed moves neither way. The opening says the reading's chance to fail rests on the other nine runs. The dry run checks the sign on 200 batches from each of the four starts. |
| E9-08 | low | Section 4's "(a quarter, or less from a lean to one plan)" was wrong both ways: a half at A3 and A5 from uniform, 0.650 from a lean. | Taken. |
| E9-09 | low | The witness was "too small for a verdict", yet its signal-to-noise, 5.88, is above B2's, A2's and A7's. The reason is that it is not a planned condition. | Taken. |
| E9-10 | low | A chance learner falling to 0 counts as the law's way at B3 (d = 0.20) and the witness (d = 0.25). | Taken in part, on the reader's suggestion. The reading reported, where the best chance is interior, the seeds ending within the improving chances; section 4 says only B2 from 1/2 and the run from 1/20 tell the two apart. A dry-run check planted B3 falling to 0. Round 2 found the count unable to tell the two apart, since a learner falling toward 0 ends near it, not at it (E9-31). |
| E9-11 | low | TR7 reads A5 by contradiction only; Stage A gives it a support verdict, and the departure was not listed. | Taken: listed in section 7, with the reason. |
| E9-12 | low | "What the law forbids of its expected gradient": RF7 says nothing of gradients. | Taken: "which the exact expected gradient never does". |
| E9-13 | low | 36 of 215 dry-run checks could not fail ("policy unchanged", and a mixture check comparing two of `tr7.py`'s functions). The draw-for-draw check never met B2's prospects. `run`'s loop, its resume and the reading's distances were never run. | Taken. The "policy unchanged" kind is dropped, the mixture's expected points are enumerated over every act and draw, and a draw-for-draw check of `outcome` against `played` is added on both answers of every tied condition. `run_all` runs on a temporary file at step size 0, with a cut line and a resume, and the reading is read with `stage0.json`. The record counts the checks by kind (294 after round 1, 299 after round 2). |
| E9-14 | low | A line cut by a kill or a full disk stopped both the resume and the reading; no procedure was frozen. | Taken. `run` sets a cut last line aside, byte for byte, with the time, and trains that learner again. A last record that lost only its newline gets it back. The reading refuses a cut file. The dry run plants each, the reading's refusal from round 2's fixes on (E9-39). |
| E9-15 | low | "Bounded at 26 CPU minutes" was an extrapolation with a margin, not a bound. | Taken: an estimate with a margin, and the text says nothing stops the run at it. |
| E9-16 | low | Section 8 lacked FREEZE-4's label and said "the reference curves' prediction". | Taken: labelled an AI expectation, not the account's prediction and not revised after the run (now section 9). |
| E9-17 | low | Section 9 said neither how FREEZE-9.md is frozen nor where the readers' findings go. | Taken (now section 10), as FREEZE-4 §13 says it, with this file. |
| E9-18 | low | The reading only printed. | Taken: it writes `results/reading.json`. |
| E9-19 | very low | `tr7.json` holds ten curves, not six. | Taken: all ten named. |
| E9-20 | very low | The header's reading time was low. | Taken: measured again on the revised file. |
| E9-21 | very low | The scripts' time estimates disagreed with the text. | Taken. |
| E9-22 | very low | "One generator a run" is one per learner, a run at a seed, and only for chance and mixture learners. | Taken in both. |
| E9-23 | very low | `told/run.py` reads `told/PINS.json` at import. | Taken: named. |
| E9-24 | very low | The plumbing check drew each run's own seed 0. | Taken: the plumbing's seed is outside the frozen ones. |
| E9-25 | very low | Ten seeds already allow both verdicts; twenty is for power (0.989 against 0.736 at q = 9/10). | Taken. |
| E9-26 | very low | `flow_told` has no clip, unlike the told learner. | Taken: noted, with the flows' largest logit, 8.2. |
| E9-27 | very low | The power table's second row reused q. | Taken: r, the chance a seed moves away from the law's end, in the text and in `stage0.json`. |
| E9-28 | very low | "Not above" is the Lean's `mixture_never_above`; D6 adds the strictness. | Taken. |
| E9-29 | very low | "The exact expected movement" is first-order. | Taken in the text, the docstring and `stage0.json`'s key. |
| E9-30 | very low | The text did not say that "incomplete" comes before "contradicted". | Taken: section 4 gives the order, and a dry-run check plants both. |

## What round 1's reader checked and found right

- **The game.** `outcome` is `played`'s last three lines verbatim, and `played` plays every told episode.
- **Seeding.** The generators are as described, distinct across runs, starts and seeds, from TR7's call ids, and from the dry run's (E9-24 aside).
- **The estimator.** The leave-one-out estimate is unbiased, step by step, for the gradient `flow_told`, `flow_tied` and `flow_mixture` ascend. The step size, steps, batch, clip and checkpoints match, and the resume is deterministic per learner.
- **The frozen checks** run in the stated order. FREEZE-4's passes, at its link of f1d8ad939; this folder's refuses for want of its hash file, as the record says.
- **Imports.** The modules loaded are exactly the list, at FREEZE-4's and freeze 1's hashes.
- **The reading.**
  - d and each run's target are right: best chances 0, 7/20, 7/20 and 1/8, the mixture's 0.
  - The thresholds are exact: 15 gives 0.0207 and 14 gives 0.0577; 17 gives 0.0013 and 16 gives 0.0059.
  - The verdict and reading logic is right, incomplete included.
- **Stage 0.**
  - The reference ends match `tr7.json` at the ten runs both compute.
  - The signal-to-noise recomputes by hand at A1, A5 and B2 (5.714, 7.071, 3.906), and it is fairly called an indicator.
  - Both power rows recompute, and so does "about 0.014 over the eleven".
- **The dry run, read, not run.**
  - 215 checks. The estimator's largest gap is 1.65 standard errors.
  - The CPU arithmetic and the episode and learner counts agree with `plan`.
- **The command.** `gate.py hold` exists and refuses a second copy on the same tree. Nothing is downloaded, no model is called, no key is used.
- **The sources.**
  - The design's Stage A sentence and FREEZE-4 §11 are quoted exactly.
  - The Lean names exist: `FreshDrawAbove`, `MixtureAbove`, `Example.prospects` ⟨10, 9, 1, 10, 5⟩, and `freshDraw_above` at 1 7.
  - The 03-KNOWING anchor exists.
  - Every departure is listed (E9-11 aside).

## Round 2: the diff of round 1's fixes (435878ce7 to 45dc4bedf)

The same reader, continued, read the diff and the sections it touches, including the two commits added while it read (the dry run's record of its code, and `write_frozen.py`). No high or medium finding; four low and seven very low. It also corrected a remark of the author's message: FREEZE-4's "What is frozen" does link its hash file. FREEZE-9 gives `told-tr7a/FROZEN.sha256` as a plain path for the gate's reason alone. The links check needs a link's target to exist, and the gate refuses a tree with uncommitted files, so a link to a file committed after the gate could never pass.

| Id | Severity | Finding | How it was taken |
|---|---|---|---|
| E9-31 | low | E9-10 was taken on round 1's suggestion, which was wrong. A chance learner falling toward 0 never reaches it: its final rounds to 0 only below a logit of −14.5, and B1's exact flow ends at 0.0001. So seeds at 0.0001 counted as "within the improving chances", and the count could not tell finding the improving chance from dropping toward ownAtBoth. | Taken. The count reads the seeds ending nearer the best chance than 0 and within the improving chances: above half the best chance and below the improving bound, (7/40, 7/10) on B2's prospects and (1/16, 1/4) at the witness. The dry run plants B3 at 0.0001, not 0. Section 4 says so and rests the distinction by a verdict's sign on B2 from 1/2 and from 1/20; section 8 follows. |
| E9-32 | low | The mend truncated the file and then rewrote it, so a kill or a full disk in that window could lose lines already written. | Taken. The file is rewritten through a temporary file that replaces it in one step (`os.replace`). |
| E9-33 | low | The remedy named only the run, though the reading refuses too. The records, untracked, must be carried into the checkout. And every chain checks there only while this freeze's newest link precedes freeze 1's client addendum. | Taken: "What is frozen" now says each. |
| E9-34 | low | Section 8 covered 7 of the README's 11 lessons, and "the power is exact" needs "given q". | Taken. Section 8 gives all eleven, each met, met in part or not applying, with the reason. |
| E9-35 | very low | "The expected-points baseline sees no noise there" does not follow from the sign argument, and is false at A3's leans (14.91). | Taken. Section 3 says it holds at the verdict starts, A3 from uniform and B4 from 1/2, and not at A3's leans. |
| E9-36 | very low | "15 of 20 has chance 0.021" is for at least 15. The opening gave 0.21 and 0.014 over eleven runs, where section 4 counted nine, since A3 and B4 cannot fail. | Taken. "At least 15 of 20". Both places now give the figures over the nine that can fail: about 0.17 for one run's uncorrected support and about 0.012 for the contradiction. |
| E9-37 | very low | A seed written as `true` read as seed 1. A record or stamp that is not an object crashed instead of refusing, and so did a line that is not an object in `run_all`. | Taken. The reading refuses a record or stamp that is not an object and a seed that is not a whole number. `records` refuses a line that is not a record. The dry run plants four new cases. |
| E9-38 | very low | `chance_run`'s docstring still said "one generator each a run". | Taken. |
| E9-39 | very low | This record's round 1 summary miscounted (thirteen low and twelve very low). E9-04's row placed the remedy in section 7. E9-13's row misdescribed what was replaced. E9-14's "the dry run plants each" missed the reading's refusal of a cut file. | Taken. The four are corrected above. The dry run now plants the reading's refusal of a cut file. |
| E9-40 | very low | "Each file this folder's link lists but the record" was no longer true once the link listed `write_frozen.py`. Section 10 omitted the writer's refusal of a link already there. | Taken: "each file the dry run runs with", in section 6 and the dry run, and the refusal added to section 10. |
| E9-41 | very low | "Stage A uses none of them" is false of the client, which Stage A imports. The argument holds by freeze 1's rule that a changed client imports nothing new and assigns nothing in another module, which the text did not cite. The dry run's record named no link of FREEZE-4's. | Taken. "What is frozen" says Stage A imports the client and calls nothing in it, citing freeze 1's rule. The author checked the claim: with every function and class method of the client made to raise, the dry run's 299 checks and FREEZE-4's frozen check pass. The dry run's record names FREEZE-4's newest link. |

After the fixes the dry run ran again: 299 checks, none failed, its code unchanged while it ran. FREEZE-9's numbers follow its record.

## What round 2's reader checked and found right

- **Support's level.** The new wording in the opening, section 4 and section 5 is correct and plain, and no sentence overstates what "supported" shows (E9-36's nits aside).
- **The frozen scope (E9-04).** FREEZE-4's link lists all thirteen files Stage A imports, and its addenda can change only freeze 1's client, `served_as`, and its own dry run and record. The remedy is right in substance (E9-33 aside).
- **This record.** All thirty rows match the code and text, except where E9-31 to E9-41 say otherwise.
- **A3 and B4 can only be supported.** The leave-one-out advantages sum to zero in every batch, so each logit moves by the advantages of the episodes that chose it. The pair's share never falls at A3 and the weight never rises at B4, at any policy, clip included. The 2^−99 is right.
- **New figures.** Recomputed: the flows' largest logit, 8.121 at A4; the settled spreads, 0.0282 and 0.023505; the bound over the nine runs, 0.0116; A5's step spread, 0.150.
- **Stage 0.** Rebuilt in memory, `stage0.json` is byte-identical to the committed file.
- **The dry run, called in memory.** It gave 294 checks, by kind as section 6 then listed them, none failed. The plumbing wrote only to its temporary directory, and the tied draw-for-draw check consumes the generator exactly as `played` does.
- **The dry run's record.** Its code hashes equal the five files, and its CPU numbers equal the opening's.
- **New code.** `records()` sets a cut last line aside and restores a lost newline. The reading refuses a cut file, and every planted refusal refuses.
- **`write_frozen.py`, stepped through without writing.** The link it would write lists seven files that parse with `run.chain`'s reader and hash as listed. It refuses a second write.
- **Reading time.** 5,577 words gave 43 to 56 minutes, and the first part ten to thirteen. After round 2's fixes, FREEZE-9 is 5,948 words: 46 to 60 minutes, the first part ten to fourteen.
