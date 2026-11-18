# Amounts at a step and the within-renewal class: what the sweep found, the statements to try, and what counts against them

*AI-written (Fable, board row DJ). Frozen 18 November 2026, 14:51 WIB (from the clock), after a sweep and a read of the pieces and before any Lean was written. Scratch; nothing is built and no tracked file is changed. What comes back is appended below with its time; nothing above an appended line is changed.*

Ren, 18 November, about 14:45 WIB, of item 2 of the page on both next steps ("Read what joins amounts at a step to the step classes, and try it"): "Yes, try it".

## What it bears on

The direction asks where a course passes between the two ways, and by what ways. This morning's first look found no general statement of a passing in the step classes, and found that where the Lean says what leads to an ending it says it in amounts. The question here: what joins the amounts taken and given at a step to the class "within renewal at a step", and to the two classes of a whole course.

## What the sweep found, before anything was written

I asked today's output of the existing program which theorems name a step condition (`Web.Kept`, `Broken`, `RenewingAt`, `BreakingAt`, `BreakingOn`, `UnderminingAt`, `UnderminingOn`, `Renewed`) together with an amount (`Flow.taken`, `given`, `take`, `give`, `Balances`, `BalancesOn`, `WithinJoint`, `WithinOwn`, `partTaken`, `partGiven`): 32 theorems. Then I read `JointDraw.lean` (its opening account, and its statements to line 200).

- **The join I told Ren "has not been read or tried" is in the Lean, for one dependence.** On a balanced record, a dependence met at a step is broken across it exactly where the level with all that is given falls short of the need with all that is taken (`Flow.Balances.broken_iff`), and the need is met after the step exactly where the need with all that is taken is within the level with all that is given (`Flow.Balances.kept_iff`). The second names no step condition, so my query did not list it; I found it by reading the file. The dig's sweep reader of 17 November had named `broken_iff` and I did not follow it.
- **What the query does not show:** any theorem that names `Web.RenewingAt` with an amount, or `Web.Renewed` or the two classes of a whole course with what is taken and given at every step (two name `Renewed` with `Balances`, as a premise). `Clearing.undermines_within_renewal` is one built course.
- The fixed pair's record balances its web (`SupportGated.balances`), and the laws in amounts read this morning are there (`Flow.restores`, `stays_below`, `ends_below`, `joint_excess_ends`), each with premises on who gives.

So what is left to try is smaller than I said: to carry the two equivalences from one dependence to the step class and to the classes of a whole course, and to say a passing in those terms.

## The statements, on paper

All on a record that balances on a web (`L.Balances W`). "Takes part in" is requires or draws on.

- **S-A (the step class in amounts).** A formation is within renewal at a step exactly where it is active and, for every condition it takes part in at that step and every dependence on that condition holding at that step, the need is met and the need with all that is taken is within the level with all that is given.
- **S-B (not within renewal).** Where a formation takes part in a condition, a dependence on it is met, and the level with all that is given falls short of the need with all that is taken, the formation is not within renewal at that step.
- **S-C (a passing).** Let a formation be within renewal at a step and active after it. Let it take part after the step in nothing it did not take part in before, and let every dependence that holds after the step on what it takes part in have held before, at a need no lower. Then it is within renewal at the next step exactly where, at that next step, each such need with all that is taken is within the level with all that is given.
- **S-D (a condition renewed over the course, in amounts).** A condition is renewed exactly where, at every step, every dependence on it holding then is met and its need with all that is taken is within the level with all that is given.
- **S-E (enough for renewing).** Where, on every condition a formation ever takes part in, all that is taken is within what is given at every step (`Flow.WithinJoint`) and every dependence on it is at a need the level at the start meets, the formation is renewing over the course.
- **S-F (enough for consuming).** Where a dependence on a condition holds at a step, the level with all that is given falls short of its need with all that is taken at that step, and at every later step what is given to the condition is within what is taken from it, the condition is consumed; and every formation that draws on it at any step is consuming.

Each follows on paper in a few lines from `kept_iff`, `broken_iff`, `Flow.level_kept`, `Web.not_renewing_at_of_broken` and the definitions.

## Guesses, each with what would count against it

- **J1.** The statements hold as worded and build outside the package with no axiom, in under a hundred lines. *Against:* one does not hold as worded (it is then kept with what was wrong), or needs an axiom.
- **J2.** None of them is in the package already under another name or form. *Against:* a reader finds one. The sweep above already shows how a count by name misses a statement.
- **J3.** No older proved statement becomes a case of them and gets shorter. They are one unfolding from `kept_iff`, and the fixed pair's two laws need the pair's own arithmetic of levels whatever is added. I guess this is a join of the kind found on 17 November: it says in one place what was said in two, and teaches little. *Against:* a reader shows an older statement that is a case and whose proof would shorten.
- **J4.** The one built course with both ends of a passing (`escalating`) is stated of a run read as a web, with no record of takes and gives in its statements, so S-C does not apply to it as it stands. *Against:* it applies directly, or with a record the Lean already has.
- **J5.** What S-C gives the direction, if it holds: a general statement, in the Lean's terms, of by what a formation stops being within renewal across a step, namely the joint take with a need exceeding the level with what is given, where dependences and needs do not change. It says nothing of selecting or of turning, and nothing of the other way: leaving renewal at a step is not consuming. I expect the reader set to refute to call it arithmetic. That is recorded as it comes.

## The test

A scratch module outside the package, built by the package's own scratch build against the checker's cache. Then three AI readers with the Lean, read-only: one sets each statement against what I say it shows, with each premise tried for whether it can be dropped; one sweeps for the statements already in the package and for older statements that are cases (J2, J3) and reads the built course (J4); one is set to refute what it is worth (J5). Then readers who took no part read what I say of it.

## What it cannot show

That the statements matter. Whether a formation's leaving renewal at a step is what the idea means by a course beginning to use up. Nothing here is landed, and no package module is changed.

## Appended 18 November 2026, 15:06 WIB (from the clock): what was built, and what came back

**What was built.** `ScratchStepInAmounts.lean.txt` (a copy of the module at `(scratch outside the repository)/dj/batch21/amounts/`): nine theorems, about 81 lines of Lean in a file of 144, built once by the package's `scratch_build.py` against the checker's cache, with no axiom (`ScratchStepInAmounts.build.log.txt`; 49 modules reused, under five seconds). It built on the first run and was not changed. Nothing is landed and no package module is changed.

**The readers.** `wf_be67fc95-f5c`: three AI readers with the Lean; reports `reader-statements.md`, `reader-sweep.md`, `reader-worth.md`; journal `journal-wf_be67fc95-f5c.jsonl`. No person has read any of it. I read the three summaries whole and the reports only where a summary pointed. After them I opened, at the statement, `Flow.held_below`, `never_returns_below`, `excess_lowers` and `excess_bounded` in `Continuation.lean`, and the opening account of `Restoration.lean` (its statements not).

**The guesses.**
- **J1: not counted against.** Each of S-A to S-F matches a theorem with every premise and none fails as worded (one reader). "Under a hundred lines" holds of the Lean, not of the file.
- **J2: failed in part.** By the sweep reader: one of the nine is in the package in another form, two are near, six were not found. `consumed_of_exceeds` is `Flow.never_returns_below` (`Continuation.lean`) started one step later with the need as the bound, and the package's law has the weaker premise: it asks no net giving only while the level is below the need. My proof runs again the induction of `Flow.held_below`. `renewed_of_withinJoint` is `Flow.supported_of_within` (`Exclusion.lean`) with one premise dropped and "and after the step" added. `level_succ_le_of_given_le` is the unnamed step inside `held_below`. My own sweep could not have shown these: the three name no class, and my query named neither `Consumed` nor `Lost`.
- **J3: stands.** No older statement's proof shortens. Four older statements are cases at equal length (`supported_of_within`; one conjunct each of `Clearing.undermines_within_renewal`, `Clearing.renewing_over_resource` and `Preemption.renewingAt_consuming_narrows`). The fixed pair's laws are not cases: its record defines the take as what the step removes, so the amount conditions there unfold to the conclusions of its own laws.
- **J4: stands for `escalating`, and its opening words were wrong.** No record of takes and gives was found for that course, so S-C does not apply to it as it stands. But it is not "the one built course with both ends of a passing": `Clearing`'s clearer is within renewal at step 0 and not at step 1, has a balanced record in the Lean, and S-C applies to it as it stands. The Lean states only the second end of that one; the first holds by working the definition out by hand (the sweep reader).
- **J5: as I expected, and my wording of it was more than the Lean.** The reader set to refute: arithmetic. `renewingAt_iff` and `renewed_iff` are `kept_iff` substituted under the binders; `not_renewingAt_of_exceeds` composes two existing lemmas; `renewingAt_succ_iff` is `renewingAt_iff` with two conjuncts supplied; the only proof with a step of its own is the induction in `consumed_of_exceeds`, which the package has. "By what a formation stops being within renewal, namely the joint take with a need exceeding the level with what is given" is stated by no theorem: the right side of `renewingAt_succ_iff` is, by `kept_iff`, the definition's own clause that the need is met after the step; the formation's own take does not occur in it; no amount at one step is compared with one at the next; its premises remove every other way of leaving, so "only the amounts" is assumed; and "some need exceeds" follows only as a denial of "every need is within", without a step the module does not take.

**Errors in the frozen text above.** "Each with premises on who gives" is false of two of the four laws I named: `Flow.restores` is in joint amounts only and `ends_below` has no record in it. I did not name `held_below` and `never_returns_below`, a law of no return with no premise on who gives. The module's own account gives a wrong reason for "leaving renewal is not consuming"; the fact is in the package (`Renewable.dip_breaks_without_consuming`).

**What else the readers found.**
- Premises that can go: `met` in `not_renewingAt_of_exceeds`. In `renewingAt_succ_iff`, "no need has risen" is stronger than needed, and the three premises together only say that every dependence after the step is met after the step. `low` in the two renewing theorems and `after` in the two consuming ones are much stronger than needed.
- The two sufficient conditions are far from the classes: on paper, a course that is renewing with the first's premise failing at every other step, and one that is consuming with the second's failing for every step.
- The step class does not place a course between the two ways: on paper, a formation that takes three of five at step 0 and then takes part in nothing is within renewal at every step and consuming over the course. With activity and taking part unchanged, within renewal at every step is the same as renewing; the gap is in activity and taking part, not in amounts.
- One thing the reader set to refute thought worth a sentence: within renewal at a step is a condition on slack (the need with all taken against the level with all given); taking jointly within what is given is a condition on rate. A formation can be within renewal at each of several steps of joint excess.
- **Nearer the direction than this module, and not named in my note** (the reader set to refute): `Restoration.lean`, which has the two classes with a graded middle; the laws of `Continuation.lean` taken together (taking jointly within what is given, the level never falls; under joint excess it falls by at least one a step, whoever takes; below a need, with givers that depend on the condition it stays below, and with net giving it is restored within so many steps); and `Web.lost_iff` in `Optimum.lean`. That reader found no theorem of a general record joining `Continuation`'s laws to the classes, with the limits its report gives.

**Verdict of the reader set to refute.** A join only in the thinnest sense. Not to be landed as a module. At most `renewingAt_iff`, and a bridge from `never_returns_below` with its weaker premise to `Consumed`, could go beside what they rewrite if a later join needs them.

## Appended 18 November 2026, 15:20 WIB (from the clock): corrections to the section above, after two readers who took no part

Two AI readers (`wf_e9875e77-65e`; `told3-claims.md`, `told3-plain.md`) set the section above and a first draft of the page for Ren against the three reports and the Lean. They found seven and eight places that say something false or more than the source, some the same, and 34 lesser ones. The section above is left as written; these are its corrections, in the readers' words where I could use them, not read again.

- **J2** is counted against outright by its frozen test; "failed in part" was the sweep reader's wording. That reader's table has three near and five not found, within the searches it names; its closing line has two and six.
- **J5** did not come "as I expected": what I said S-C would give, it does not.
- **The paper course** needs its second taker, who takes the remaining two at the next step, and a third formation whose need of one is never met again; without them nothing is consumed. "With activity and taking part unchanged, within renewal at every step is the same as renewing" is, by that reader and on paper, of a formation active at every step and taking part in the same conditions at every step.
- **"Not named in my note"** is not so of four laws of `Continuation.lean`, which the frozen text names; it is so of `held_below`, `never_returns_below`, `Restoration.lean` and `Web.lost_iff`.
- **"Under five seconds"** is the module alone; the run took about fifteen by the clock.
- **The three modules are October's** (`Continuation.lean` added 10 October, `JointDraw.lean` 20 October, `Restoration.lean` under that name 20 October, first added as `Return.lean` on 9 October), and the account's chapters already tell them: chapter 5 tells `broken_iff`, `broken_shared` and `kept_of_restrained`; chapter 2 tells the grades with `consumed_iff`, `Flow.restores` and `never_returns_below`. "More than our pages tell" holds of the direction page and the dig's record only.
