# Both outcomes of a choice through a reading: two scratch builds, what they are and what they are not

*AI-written (Claude Fable, board row FM), 22 November 2026. A record of one morning's work, for whoever takes the next step toward a centre of the map or thinks of writing that one has been found. Nothing here is in the Lean package and nothing here is a result: every module named is scratch, built against the package and filed as text. The finding is on the board, in row FM.*

## Why

On 21 November Ren said the goal should be a full map with formal link proof, done elegantly, with its centre ([his words](../../../../../../sources/15-codex-theory-conversations/2026-11-21-a-full-map-with-its-centre.md)). A read of every module of the package ([the whole read](../fm-whole-read-2026-11-22/NOTE.md)) found one thing missing: no module has, in one statement, both outcomes of a course with a choice in it, a reading in it, and a bound on the side where it ends. In the night [a law landed](../fm-the-law-of-what-a-list-holds-2026-11-22/NOTE.md) that gives the kept side through a reading (`Viability.coded_kept_iff_closed`) and, with no reading, a losing side that nothing joined to it. This morning's work was to state the two together.

## The finding, in the words the readers allowed

A statement with both outcomes, a choice and a reading exists in scratch, with no axiom and its premises named. Keeping through a reading has a losing side as a rising iterate on codes; it never holds together with keeping (no premise); where the moves are listed, each usable move's values are covered by a list, each class seen has an exact code, and two decisions are given for every code, a code's class is in a closed family or lost at the count of the listed guarded codes, never both. `GuardHorizon` has the same with no reading. The two share two lemmas at each horizon and each takes its bound from its own kept side.

It is the known determinacy of a finite safety game decided on the classes the chooser cannot tell apart, said constructively with its listings and decisions as premises. It is **not a join**: no proof of a statement older than 22 November goes away because of it (two were tried and came out three and five times longer), and the general module costs 226 declaration lines against 96.

Where it is weakest against the whole read's sentence: `Lost` is of a class of configurations not told apart and not of a course; it includes "no usable move" with nothing leaving the guard; and the bound is the kept side's count read across a decision, not the rising law at work. One of the decisions is the conclusion itself at horizon zero.

**The sentence that may not be written:** that one theorem now gives both outcomes of a course with a choice, a reading and a bound on the ending side, with `GuardHorizon` and `Keeping` as its two cases. The general bounded statement has one case; the reading assembles its own from the landed kept bound.

**What would change this:** one statement older than 22 November that calls one of the two shared lemmas in no more lines than its own proof. The cases with one side idle (`CommonResponse.regionStep` and `reachStep`, `Lasting.Lasts`, `KeepableStep.keepStep`) were not tried.

**What it taught about the centre** (mine, to be argued with). The shape "both outcomes, a choice, a reading, a bound" can be filled with nothing of the map in it: no quantity, no share, nothing that sustains anything. So the whole read's sentence named a shape a centre would also have, not the centre. And a caution from the coordinating session and the session that holds row DJ, which bounds any next step on positions that carry a level no move raises: there, what is kept for ever is kept by standing at a level, which is the first way and not the second.

## What was built, in order

Every build was by an implementer of another kind of model (Astra 6.2) from a brief frozen before it ran; every text was read before the next step by readers who took no part. The running account, written at the clock before and after each run, is [AFTER-TWO-SIDES.md.txt](AFTER-TWO-SIDES.md.txt); it has what I expected before each return and what readers changed.

| Step | What it was | What came of it |
|---|---|---|
| `two-sides/` | The losing side through a reading and the two together, for codes. | Built clean (16 theorems). Four readers and a sweep of the package: the Lean is right (by program on 14 million small cases), and three of my six tests were passed by their letter. The losing bound was called by a detour the statement does not need; the either-or was applied only to a reading into `Unit`; half the module was `GuardHorizon`'s loss section written again with codes for configurations. |
| a brief never run | The either-or said once for a pair of steps. | Dropped before any build: the sweep found its induction already in the package (`Lasting.closed_orbit`), and one-step never-both is false for the landed step on codes. Kept as `BRIEF-PAIR-OF-STEPS.never-run.md.txt`. |
| `choice/` | The two steps said once for positions of any type; `GuardHorizon` and the reading as two cases. The brief was attacked by three readers before it was frozen. | Built clean (three modules, 68 declarations). Three readers: right, and not a join (above). The form of the either-or with a relation the family goes down along served both cases; only the reading needs it. |
| `in-time/` | A small module asked for by the session that holds row DJ: both lanes of its Drain process at level 1. | Built clean (19 theorems after five follow-ups), read three times. Its first telling ("a reading fine enough that comes too late") was wrong: at one step keeping does not depend on the reading at all. See below. |

## What stands from the small module

- **A general lemma**, not in the package: `Viability.keptFor_one_iff` and `keptFor_one_iff_change_reading`. For any process, a class is kept for one step exactly where the guard holds on it and some usable move leads only to guarded configurations; the reading does not enter, so any two readings of steps keep alike at one step. It is the definition unfolded and is to be told as that. With the package's older `Matching.keeping_matters` (two readings differing at two steps) it says two is the least horizon at which what a step keeps can matter. The package's `ChoicePoint.keptFor_each_not_joint` would be a case. **Kept for a later landing in `Keeping`, with whatever next touches it.**
- **Two built classes on Drain** (a process of the session that holds row DJ, [filed there](../dj-a-line-on-a-stock/read-a-choice-from-a-reading-2026-11-21/ScratchKeptForViable.lean.txt)), with every move allowed and the guard "level not zero". Both lanes at level 1 are not kept for one step, whatever the reading. Lane true at level 2 with lane false at level 1 is kept for one step under every reading; any reading that keeps it for two gives different values to two named steps; the reading that keeps nothing and the reading of the level reached do not; the reading of the lane reached keeps it at every horizon; and where equality of values is decided it is kept beyond one step exactly when the two values differ. A reader's sentence: what a reading must tell apart is fixed by the class and its moves, not by the reading alone (on both lanes at level 2 the reading of the level reached keeps the class at every horizon). The last two theorems (the exact form) were read by me and by no reader who took no part.
- Weight, in the words of its reader and of the session that holds row DJ: one more built case on a process with no share; one line in a record, none on the direction page.

## What readers changed, and what it taught about briefs

- Three times a test I had frozen as "what counts as nothing gained" was met by its letter: a test that each bound be "used"; a test against "only a trivial reading"; a test that "old" theorems come out as calls, where the theorems were that night's own (the coordinating session found it by blame). Before the second build a reader was set on the tests alone ("the cheapest pass that gains nothing"), and showed that all of them could pass with the main case a case of nothing. The second brief asks the implementer for facts and no verdicts.
- A reader with one narrow question again saw what readers of every line had not: that the first module repeated an older section term for term; that the second build's join holds for two lemmas and not for the statement; that keeping for one step is the same under every reading.
- Two tellings were withdrawn after readers: "one step of slack" (one more level gives two more steps there, and nothing relates levels to steps), and "what is missing is knowing the lane before the first move" (a reading of two theorems side by side, not a theorem).

## What it cost

Astra 6.2, by its own footers: about 29 million tokens (first build 2.5; the sweep 11.2; second build 9.6; the small module 5.8 over six runs). Claude side: about 2.4 million tokens in readers. Each scratch build was seconds; no gate and no core run was made for any of it.

## Where it is

- [AFTER-TWO-SIDES.md.txt](AFTER-TWO-SIDES.md.txt): the running account.
- `BRIEF-*.md.txt` with `FROZEN-*.sha256.txt`: the three briefs that ran, each with its hash and clock, and the one that did not.
- `two-sides/`, `choice/`, `in-time/`: each implementer's report, the modules as text, the last build's log; in `choice/` the two trials that were built, measured and removed; in `in-time/` the five follow-ups.
- `readers/`: every reader's return; `readers/program/` a reader's programs and their outputs; `readers/sweep/` the sweep's prompt and report.
- The scratch tree the builds ran in is `/Users/ren/tmp/fm/build12/` on this Mac and is in no git object; the modules import two scratch modules of the session that holds row DJ, whose filed copies (linked above) are byte for byte the ones imported.
