# A first look at the classes of a single step, and the program tried again: guesses, and what counts against them

*AI-written (Fable, board row DJ). Frozen 18 November 2026, 13:29 WIB (from the clock), before any reader of either part was started and before the program was changed. Scratch; nothing is built and no store or tracked file is changed. What comes back is appended below with its time; nothing above an appended line is changed.*

Ren, 18 November, about 13:25 WIB, of the two next steps the page on the try by program left open: "i think it is reasonable to do both".

## Part A. The classes of a single step

**What it bears on.** The direction wants two ways of going on placed with respect to each other: "where, and at which grain, a course is doing the one or the other, where it passes between them, and by what ways". The two classes the Lean has nearest them, renewing and consuming, are of a whole course, and one course cannot be in one and then the other. The Lean also has three classes of one formation's event at a single step (`Web.RenewingAt`, within renewal; `Web.BreakingAt`; `Web.UnderminingAt`). The question: does any statement say that a course passes from doing the one to doing the other, and what ties the step classes to the classes of a whole course.

**What I have and have not read.** The definition of `RenewingAt`, `Web.renewing_at_active`, `Dip.renewing_at_each_step_not_in_run`, `Unmet.consumed_without_loss`, `Renewable.prefix_does_not_decide` and `Preemption.renewingAt_consuming_narrows`, at their statements, this morning. Not the definitions of breaking and undermining, and none of the other statements below.

**The fixture.** By a query of today's output of the existing program: the 20 theorems that name one of the three step classes together with another of them or with a class of a whole course (`FIXTURE.txt`, S1 to S20); and the other 48 theorems that name a step class (`REST-48.txt`), for a reader set to refute.

**What counts as a passing.** Graded, by a reader with the Lean:
- P1: a statement, of every course of some kind under premises, that a formation is within renewal at steps before some step and breaking or undermining at or after it (or the reverse), or that gives a condition under which one follows the other.
- P2: the same of one built course.
- P3: both step classes, or a step class and a class of a whole course, said of one course with no order in time between them.
- P4: the two said apart at one step, or of different courses; no passing.

**Guesses.**
- **A1.** No statement among the 20 is P1. There are P2 statements, at least `Renewable.prefix_does_not_decide` and one of the two `Preemption` statements. *Against:* a P1 among the 20, or none of P2.
- **A2.** The step classes are not the two ways said step by step, by the Lean's own statements: whole-course renewing gives within renewal at every active step and the converse fails; a consuming course can have no undermining step; a step within renewal can lie in a consuming course. So no equivalence is stated between a class of a whole course and a condition on the step classes alone. *Against:* such an equivalence, general, among the 68.
- **A3.** Where the Lean does say what leads from staying within to ending, it says it in amounts (a draw against what is renewed, in the laws of the fixed pair) and not in the step classes. *Against:* a general statement, among the 68, with a step class in a premise and a later loss or ending in the conclusion.
- **A4.** The reader set to refute finds, among the other 48, no P1 either. *Against:* one.

**The test.** Three AI readers with the Lean, read-only: one on the definitions and every general law between the step classes and the classes of a whole course; one grading S1 to S20; one set to refute A1 to A4 among the other 48 and beyond. A fourth, for part B, writes questions (below).

**What it cannot show.** That no such statement exists outside what was read. Whether the step classes should be read as the two ways. Nothing is proved by it.

## Part B. The program again

**What is changed, and only this.** (1) Under each statement, the definition of every condition it names is printed, read from the Lean. (2) Arguments the Lean's printing hides are kept where they are not types or instances. (3) What the source writes after the colon is read from the source text and kept with the conclusion. (4) No grouping into models. For each statement: the kind of thing its variables are (a web, a record, a law, a run), the step a course is made by, written out until it is no longer a name for another step, and the functions it names that carry one kind of thing into another. The places page is not mended and is left out. The two entered tables stay as they are, with lines added only for kinds of thing the 20 new statements range over that the table has no line for, each added line counted.

**The statements.** The 28 of this morning, and S1 to S20 above, which the program's rules were not written with in view (one of the 20 was among the six held out). The program is frozen, with its hash, before it is run on the 20; a crash is mended and said.

**The questions.** Eight, about S1 to S20, written with their answers from the Lean by a reader who does not see the program or its output. I do not write them and do not see them before the answerers have answered.

**Guesses.**
- **B1.** On the 20 new statements an auditor finds no premise lost, added or changed, no conclusion part listed as a premise, and no statement that has lost which web or course it speaks of. *Against:* any.
- **B2.** The rule that reads the colon from the source finds it for at least 46 of the 48 and is wrong on none. *Against:* more than two not found, or one wrong.
- **B3.** For every statement of a course made by a step the step printed is the Lean's; statements 14 and 15 show the same step, and 17, 18, 19, 20 and 22 show one step function with different arguments; every statement of a course given whole shows what kind of thing it is; only statement 16 shows neither. *Against:* a wrong step, a statement of a course with neither, or those not shown as said.
- **B4.** Two readers who see only the new output answer the eight questions: no answer wrong, at least five of eight as the Lean has it for each, and the judge lays no shortfall to a definition that is not printed or to a hidden argument. *Against:* any of the three.
- **B5.** The definitions printed make the page long: I guess the 48 statements take more than 1,500 lines, and that a reader says it cannot be read whole. That would count against printing them under every statement and for printing each once.

**The test.** After the program has run: one auditor on the 20 new statements (B1, B2 for them); one on the 28 for B2 and B3; two answerers; one judge.

**What it cannot show.** As this morning: nothing over the whole package; not that a person can read it. There is no hand-typed file of the 20 to set the answers beside, so the count stands alone.

## Appended 18 November 2026, 14:07 WIB (from the clock): what came back

No person has read any of it. I read the nine summaries whole and the reports only where a summary pointed. Of the Lean I opened myself, at the statement, only the three laws of `ContinuedClasses.lean` told under A below.

### Part A

**The readers.** `wf_4f45d1be-d5e`: three AI readers with the Lean and one writing questions, about a million tokens, 13 minutes; reports `reader-grains.md`, `reader-twenty.md`, `reader-refute.md`; journal `journal-wf_4f45d1be-d5e.jsonl`.

**The guesses.**
- **A1: first half not refuted, second half failed.** No statement among the 20 is P1 (two readers). On P2 the readers differ, and both say my grading was badly posed: it did not say whether a denial of a step class, or a class of a whole course, may stand for one end of a passing. The reader of the 20 grades three as P2 "each only in part" (S10, S16, S20) and none strictly; the reader set to refute grades none. So there is no statement among the 20 with both ends of a passing as step classes placed in time. The two I named do not qualify: `prefix_does_not_decide` has no step class at or after its horizon, and of the two `Preemption` statements one has both classes at step 0 and the other a step class and a class of a whole course with no order between them.
- **A2: not refuted.** One general law runs between the grains, one way: renewing over the course gives within renewal at each active step (`Web.renewing_at_active`). No law of every web was found that relates consuming to undermining or breaking, either way. The reader set to refute scanned every theorem header in the package with an equivalence and a class of a whole course, found 50, and none has a side built from step classes alone; the scan can miss equivalences inside definitions or under other names. Built webs separate the grains: within renewal at each of its own active steps and not renewing over the course; consuming with no undermining step, in five built webs for five reasons. By the reader of the definitions, undermining is not consuming said at a step: it asks that the need had been met for a stretch and looks one step ahead, where consuming asks that the need is met at no later step and nothing of its having been met. The file's opening account calls undermining "the stepwise counterpart of consumption"; no theorem backs that.
- **A3: not refuted by its letter, and posed too narrowly.** None of the 68 is a general statement with a step class in a premise and a later loss or ending in the conclusion. But (i) at the grain of one relation and of a region there are general statements that run from a step class to the next step (`Web.UnderminingOn.exceeded`, `.not_retains`, `Web.RenewingOver.keeps_own`), none reaching an ending for good; and (ii) the laws in amounts are not only the fixed pair's: they hold of every balanced record on every web (`Flow.restores`, `stays_below`, `ends_below`, `joint_excess_ends`, in `Continuation.lean`), by that reader's reading of statements.
- **A4: not refuted.** Of the other 48: no P1, no P2, three P3, 45 P4. All 27 general ones are at one step.

**What I did not guess.**
- `ContinuedClasses.lean` reads both classes from an event of a course onward, along what continues what (`Web.RenewingAlong`, `Web.ConsumingAlong`). I opened the three laws: the two exclude each other at an event (`renewingAlong_not_consumingAlong`); renewing from an event holds of whatever continues it across the next step (`RenewingAlong.branch`); consuming from a later event holds of what it continues (`ConsumingAlong.merged`). On paper, from the three: a course that is renewing from some event is never consuming from a later one. Both readers drew that and both say it is not one stated theorem. The other order, consuming from earlier events and renewing from a later one, is neither excluded nor shown in what they read. What the definitions make of this: consuming from an event is a fact about a loss anywhere ahead, so it holds of every earlier event too; in these terms a course cannot have been remaking and then begun to use up.
- Nearest to a passing, in built courses only: in `escalating` the drawer is within renewal at step 0, not within renewal at step 1, and consuming over the course (S16); with a second statement outside the 20 (`Renewable.escalation_undermines_for_every_cycle`) the step-1 end is undermining. In `extracting` the drawer is undermining at step 2 and at no other step, and consuming over the course (S20). None of the 20 says by what a course passes: in S10 the draws before the horizon are the same in the renewing and the consuming course.
- A built world in which a step is undermining and nothing ever ceases afterwards (`seedbank_world`, `Space.lean`), by the reader set to refute.
- Two corrections to my brief: `Web.UnderminingFor` is defined in `Restoration.lean`, not `Dependence.lean`; and "one course cannot be in one class of a whole course and then the other" holds of `RenewingIn` and `ConsumingIn`, while the classes along a continuation do carry an event.
- Seven docstrings among the 20 say more than their statements, by the reader of the 20.

### Part B

**What was built.** `TRY-DUMP2.lean`, `make_try_dump2.py`, `analyze2.py`, `ROLES2.tsv` (this morning's table with six lines added: one kind of thing, and five constants that make a course from a step), hashes in `PROGRAMS2.sha256`, taken before the program was run on S1 to S20 and unchanged since. It was written and run on this morning's 28 only, four times; the colon rule was mended once after it failed on three of the 28, and the step inside a guarded step was added after 19 and 20 did not show it. It then ran on all 49 declarations (47 theorems and two definitions; S13 is H3) with no crash and no change. Output `out48/`: 1,188 lines.

**The readers.** `wf_09c7a4cc-69f`: five AI readers, about 1.1 million tokens, 22 minutes; `reader2-audit-new.md`, `reader2-audit-28.md`, `answers-b1.md`, `answers-b2.md`, `reader2-judge.md`. The eight questions and their answers (`QUESTIONS-B.md`, `ANSWERS-B.md`) were written from the Lean by a reader who did not see the program; I had not opened them when the answerers answered.

**The guesses.**
- **B1: held.** On the 20 new statements, 77 premises and parts: nothing lost, added or changed; no part of a conclusion listed as a premise; no statement where which web or course is lost (47 lines saying what the printing leaves out, all right).
- **B2: held, with a limit.** The colon is found for 47 of 47 theorems and wrong on none (20 by one auditor, 28 by the other; H3 is in both). The second auditor wrote five kinds of signature on which the rule would count too few without noticing, since its check against the environment runs only when it found something bound. A rough search found none of the five in the package.
- **B3: failed in part.** Every step printed is the Lean's (15 steps in 8 statements); 14 and 15 show the same step; 17, 18, 19, 20, 22 and one side of 21 show `TurningInTime.pair` with different arguments; 16 alone shows neither. Against: seven of the 28 have a step in the Lean that the page does not print (five by the recursion in the fixed pair's level, two by a run's own process), and so do five statements of runs among the 20 (one of them is H3, counted in both); the second course of 21 shows no kind of thing; S10, a statement of two runs, shows none, and its line "given: nothing (a statement of built things only)" is false, because the runs are bound after the colon.
- **B4: held, narrowly on its third clause.** No answer wrong; seven of eight as the Lean has it for each reader; the one answer right in part (question 6, both readers) needs the definitions of two built webs, which the page does not print. The judge sorted that as outside what was promised (definitions of conditions) and says that by the bare words of my frozen sentence, "a definition that is not printed", it would count against. Nobody carried a statement from one web, course or formation to another without a statement that carries it.
- **B5: failed.** 1,188 lines, under the 1,500 I guessed. Of the two answerers one read the page whole, slowly; the other says the new statements' blocks hold together and the whole does not, for the repetition. Both ask for each definition once: 397 lines are definitions, of 95 distinct ones.

**What the count does not mean.** Seven of eight is not to be set beside this morning's three of nine. The questions are different, there is no hand-typed file of these statements, and I told the reader who wrote the questions that they must be answerable from the statements and the definitions they name. They were written to fit what the page prints.

**Faults the auditors found that no guess covered.** The marks "about" and "grain" are no better on statements the rules had not seen: about right on 63 of 77, with 14 wrong from one line of my table (a run called "part of a step"); grain right on 74 of 77, coarse on seven more. Inside a printed definition the hidden argument is still hidden, with no line saying so (27 lines). Fields of a structure print as `self.2`. Definitions by recursion print in compiled form. A condition defined as an inductive type gets no definition line (statement 15). `MODELS2.md` drops the kind of thing after built things.

## Appended 18 November 2026, 14:24 WIB (from the clock): corrections to the section above, after two readers who took no part

Two AI readers (`wf_26ef0025-9e9`; `told2-claims.md`, `told2-plain.md`) set the section above and a first draft of the page for Ren against the nine reports and the Lean. They found ten and twelve places that say something false or more than the source, some the same, and 36 lesser ones. The section above is left as written; these are its corrections, in the readers' words where I could use them, not read again.

- **What consuming from an event asks.** Not "a loss anywhere ahead". `ConsumingAlong` asks that the event, or something that continues it, draws on a condition for which some need, from some step of the course on, is never met again; the need may never have been met, and that step may lie before the draw. A draw ahead of an event is ahead of every earlier event of the same chain of active formations, so consuming holds from each of those too; not "every earlier event" without that.
- **"In these terms a course cannot have been remaking and then begun to use up"** holds only of the two classes read from an event on, and because of how they are defined. In step classes and in amounts the reports give a before and an after: S10 for every horizon, S16, and the fixed pair's law for drawing beyond renewal. The derivation itself is right, for every web and every continuation, and needs two of the three laws; `RenewingAlong` from an event says nothing of what the chain did before it.
- **A2.** "Undermining asks that the need had been met for a stretch" is not the reader's: it asks that a need of the dependence was met at some one step since which the dependence has held without a gap. "In five built webs for five reasons": four by statements, the fifth by one reader's hand reading. "One general law, one way" is of `Dependence.lean` and the 68.
- **A1.** No P1 among the 20 is by three readers, not two.
- **Who read what.** One reader read all 68 at the statement; a second read the 20 whole; the other 48 rest on one reader; about thirty of the package's 406 files were opened in part.
- **Amounts.** "Which no statement ties to the step classes" was one reader's "not found in what I read", of the fixed pair's module. The Lean names such conditions elsewhere (`Flow.WithinOwn`, `Flow.WithinJoint`), and the reader set to refute lists three statements that set amounts beside a step class.
- **B4** did not simply hold: two clauses held; the third failed by the words as frozen ("a definition that is not printed"), and the judge left the choice of reading open. A stricter marking of question 7 gives six and six. **B5:** the count of lines failed; the readers' half is met by one of two. So of five guesses: B1 held, B2 held with a limit, B4 held on a kind reading only, B3 and B5 failed in part.
- **B3.** "16 alone shows neither" is by the program's own list; S10 shows neither and is not on it. All eight statements that show a step are among the 28 the program was written and mended on.
- **"Twenty it had not seen": nineteen.** S13 is H3. By subtraction: 73 premises and parts, 42 lines on which web or run, about right on 63 of 73, grain on 70 of 73. Of those 47 lines, 31 say which web and 16 the process of a run.
- **Definitions.** Not "every condition as the Lean has it": none wrong; 28 of 34 as the Lean has them; three leave out the web; three print a field as a position. On the 28, statement 15's inductive condition has no definition line.
- **Small.** `out48/`'s 1,188 lines are one file of two. The token and minute figures are from the runs' own notices and are in no report.
