# The lock and the turn as two requirements and two readings on one built process: tried in scratch, 21 November

*AI-written (Claude Fable, board row DJ), 21 November 2026. Scratch Lean, outside the package; nothing has entered it. A built case, not a law, not a join, and not a model proposed for the package. Guesses T1 to T7 and what would count as nothing having changed were frozen at 19:48 WIB, before any Lean was written for it ([the frozen file](FROZEN-TWO-REQUIREMENTS.md.txt); [as frozen](FROZEN-TWO-REQUIREMENTS.as-frozen-1948.md.txt), [its hash](FROZEN.sha256.txt), which records the copy by its name in scratch); three points of the coordinating session were added under "After" once the worker had started. One AI worker (run as Claude Opus; 17 tool calls and 2 builds, by its own count) wrote one module ([the module](ScratchTwoRequirements.lean.txt); [its build log](build-ScratchTwoRequirements.log.txt): exit 0, an empty axiom report, 39 theorems; the scratch build tool is a working build and not a receipt, and the checker's controls have not run on it). One AI reader who took no part (Opus; 11 tool calls by its own count) read its definitions, statements and proofs, checked the runs and the exhibited configurations by hand, and marked two places in the worker's report as saying more than the Lean, none in the module, and nine lesser, two of them on the module's docstrings. Their returns are filed word for word and are all there is of their reports ([worker](RETURN-worker.md.txt), [reader](RETURN-refuter.md.txt)). The writer read the module's definitions and main statements, not its proofs; what is said of what a proof uses is from the docstrings and the two returns. The worker did not read the direction page's paragraphs, and its return does not show whether it read the points under "After". A third AI agent who took no part (Opus; 9 tool calls by the run's count) then set a first form of this note against the module, the returns and the frozen file, and marked seven places as false or as saying more than the source, three of them under "What it draws", and fifteen lesser; they are mended here in its words where it gave words, and not read again ([its findings](check-note.md.txt); [the note before the check](NOTE.before-check.md.txt)). No person has read it.*

## Why it was tried

Four tries of this day looked for a bridge between two notions the Lean already has, and each came back as a dictionary or as two sides with no theorem between them. The session's reading from them was that the lock is a way whose selecting is set from one thing, its share, while it rests on another, a level: two requirements and a reading, not one guard kept by a plan ([the direction page](../../../../../../DIRECTION.md), "What four tries in one day say about how to go on"). This is the built case that reading called for. That paragraph says what would turn it back: the case coming out, by a reader who took no part, as the package's own small cases said again.

## The built process

A configuration is a share and a level. To favour raises the share by one and lowers the level by one, stopping at zero. To hold leaves both. The guard is that the level is not zero. Nothing gives to the level. Two readings: the share alone; the share and the level. Three requirements on a move at a configuration (keeping and the yielding one are on the package's `Admissible`, hence on `Viable`, unchanged; whether a rule meets a requirement is judged by the package's `UniformPolicy`): the selection's own (where the share is at least a threshold `c`, favour); keeping (where the guard holds, the move is admissible for `n` steps more); and the selection yielding to the level from a line `m` (where the share is at least `c` and the level at least `m`, favour; and keeping). The reader: the definitions are the frozen file's, none bent.

## The table

For each requirement: whether some move meets it at each configuration, whether a rule made from the share alone meets it, and whether a rule made from the share and the level does.

| requirement | by configuration | from the share | from the share and the level |
|---|---|---|---|
| the selection's own | yes (not stated; follows from `t1`) | yes (`t1`); also by a rule that reads nothing, always favour (`t1_no_reading`) | yes (not stated; follows by composing) |
| keeping | yes (not stated; follows from `t3`) | yes (not stated as such: `t3` is a rule that reads nothing, always hold; a rule from the share follows by composing) | yes (not stated; follows by composing) |
| the selection's own and keeping together | no: at share `c` and level 1 no move meets both (`t4_conflict`) | no (`t4`) | no: under every reading into a type of `Type` (`t4`) |
| yielding, the line at least two | yes (not stated; follows from `t5_both`) | no (`t5_share_none`, which holds for every line) | yes (`t5_both`) |
| yielding, the line at zero or one | no: at share `c` and level 1 (in the proof and docstring of `t5_low_none`, not in its statement) | no (`t5_share_none`, `t5_low_none`) | no: under every reading into a type of `Type` (`t5_low_none`) |

In this process the reading of the share and the level is the configuration itself, so the first and third columns are the same question; the cells marked "not stated" are true by that or by composing a rule with a coarser reading, and no theorem of the module states them.

So, of the readings tried (nothing, the share, the share and the level), a reading does work in one row only, the fourth: a choice knowing the configuration exists and a choice from the share does not. In the third the two requirements cannot both be met at share `c` and level 1, and in the fifth the yielding requirement's own two clauses cannot, and no reading is at work (the coordinating session's first point). `t5` joins it: a rule made from the share and the level meets the yielding requirement exactly where the line is at least two, and no rule made from the share alone meets it.

## The runs

- **The selection's own rule** (`t2`): for every rule made from the share that meets the selection's own requirement, from a start whose share is at least the threshold, at step `k` the share is the start's plus `k` and the level is the start's less `k`, stopping at zero; the guard first fails at the step equal to the start's level and holds at every step before. The reader's words for what it bears: "the move does not change and the selection's requirement is met at every step while the level falls to zero at step `s0.2`; the level is not read." What the rule reads, the share, does change at every step; the worker's sentence that nothing in what the rule reads differs is false of it (the reader's first finding). The reader adds that the same run follows under any reading, so stating it for the share says less than holds; and the worker, that the run goes on after the guard fails, the share still rising.
- **A rule that meets the yielding requirement**: the guard holds at every step of its run from a start where it holds, under every reading (`t6_guard`; empty for lines at most one, where no rule meets the requirement). For the built rule that favours exactly where the share is at least `c` and the level at least `m`, with `m` at least two, from a start whose share is at least `c` and whose level is at least `m`: the share rises until the level is one below the line and then both stay (`t6`). The guess that every such rule stops one below the line fails: another rule, `eagerRule`, meets the yielding requirement at line three, and from share `c` and level 3 it is at level 1 at step 2 (`t6_other_rule`).

## How it came out

By the frozen file's own test, nothing has changed. The reader's verdict has two qualifiers: the second, fourth and fifth guesses hold as worded, "the last for the two readings named"; and the counter-guess's clause that no law of the package does work is "false only in small part". The reader who took no part: "it is the package's built cases of a uniform policy said again with numbers, placed on a process with runs. Of the four parts, only what it rests on does work that the old cases lack. The selection's requirement works only as 'force a favour at one point'. The reading is the old fibre argument. The time is subtraction and an idle horizon." The worker's own answer is nearly the same ("mostly the package's built cases of a uniform policy said again with numbers"); it goes on to name one feature those cases lack, and the two things it names for it are the ones the reader's first two findings answer.

What the reader found idle, or arithmetic, or bookkeeping:

- **The horizon is idle.** Holding always keeps, so admissible for `n` steps more comes, for every `n`, to the next level not being zero (the reader, from `closed_above` and `viable_above`; not stated as one theorem). Every theorem holds alike for every `n`.
- **The line being at least two is one step's arithmetic.** A requirement that asks for a favour at level 1 has no rule (`line_two`). It is not a threshold of the map (the coordinating session's third point).
- **The share is idle.** The reader: "The share is idle in both the dynamics and the succeeding reading". The selection's own requirement is met by a rule that reads nothing (`t1_no_reading`). In the row where a reading does work, what does it is registering the level: with the line at least two, a rule from the level alone would meet the yielding requirement (the reader, read off the proofs of `t6_other_rule` and `adm_of`; not a theorem). For line three, `t6_other_rule` proves it for `eagerRule`, which reads only the level, under the reading of share and level. The fifth guess is proved for the two named readings only.
- **The package's laws do bookkeeping.** Two are called (`closed_viable`, `viable_guard`). No law of the lock's modules is used.

The second test, added under "After" (one course under laws of both kinds: a law of the lock's side and a law of the choice side called on the same course): only the lock's side was not reached. The reader names an untried tie, that the run of the selection's own rule might be had as a case of the lock's `locked_rises`. On the choice side `closed_viable`, a law of `Viable`, is called on the process, as bookkeeping.

## What is kept from it

The reader's list:

- the table's split between a conflict at a configuration under every reading (the third row) and a failure that depends on the reading (the fourth);
- the refuted part of the sixth guess;
- "two facts that say what a next built case would need: the horizon is idle with no giving to the level, and the share is idle in the reading that succeeds. A next case would need a level with a giving, so that `n` and the line matter, and a rule re-read from its own share, as the lock's `turn` does, so that the selection's side is the lock's and not a parameter."

## What it draws

My reading, held loosely. The built case I called for was too small to say the idea's sentence. By its own clause, the session's reading on the direction page is turned back: the reader judged the case the package's built cases said again with numbers.

For this try, the reader names two things a next built case would need: a level with a giving, and a rule re-read from its own share. Whether the four earlier tries lacked the same two was not checked. The direction page says where the package stands on a lock and a level together ([its lines under "Where we are heading"](../../../../../../DIRECTION.md)): in the chapters as far as they were read, a lock and a level it needs stand in one model only with the level's fall handed in beside the lock, or with the lock needing nothing; in the Lean there is more (`locked_ends_with_net_regime`, `locked_turns_in_time_on_window_iff`, `locked_ends_rising`), each with what it takes as given; and "What is not there" names three things not found together with each doing work. The read of this evening found no moves in the lock's seven modules.

Nothing here starts a model. On the evening of 21 November Ren said to another session that the goal should be a full map with formal link proof, done elegantly, with its centre ([his words](../../../../../../../sources/15-codex-theory-conversations/2026-11-21-a-full-map-with-its-centre.md)); that session means to write first, on paper, what a model of the centre must have, and this record is among what it was given.

## What it cost

By the run's own count, in its journal (`wf_0c5559fa-ec2`, not filed here): 233,295 tokens for the worker and the reader; the checker of this note 120,538 (`wf_166132c4-6ef`). 353,833 in all; the ceiling for this step was 0.5 million.
