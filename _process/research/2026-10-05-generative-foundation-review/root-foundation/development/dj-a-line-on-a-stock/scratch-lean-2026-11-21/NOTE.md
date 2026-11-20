# Two small statements in scratch Lean, 21 November 2026

*AI-written (Claude Fable, board row DJ), 21 November 2026. Two modules written and built outside the package by two AI implementers, one after the other; then read by an AI reader who took no part (Claude Opus), who ran no build (it read the units module except lines 471 to 473 and 513 to 699). A second AI agent who took no part (Claude Opus, capped) then set a first form of this note against the logs, the reports and the signatures and found five places that were false or said more than their source and eight lesser; they are mended here in its words where it gave words, and not read again ([its findings](check-note.md.txt)). The writer of this note read the three build logs himself and none of the Lean. The modules are here as text and are not part of the package: nothing in the package, the chapters or the atlas changed, and no result is landed by this. No person has read any of it. Keepable, grower, stayer, turn are working names or the package's own.*

## Why

Ren, 21 November 03:39 WIB: "All right, good understanding, keeps moving." ([his words](../../../../../../../sources/15-codex-theory-conversations/2026-11-21-good-understanding-keeps-moving.md)), after the session had said it would first write two small Lean statements. They were claimed on the board's row DJ as a join and not a new result (the writer's own claim there; the units implementer's report says "Nothing here is a new result of the theory"). Neither places the two ways.

## What built

By the three logs beside this note, each with exit 0, no module unclean and no declaration with an axiom:

- `ScratchKeepableStep` (167 lines; 11 declarations, 8 of them theorems; 2 builds).
- `ScratchUnitsTurn` (1,367 lines; 87 declarations, 75 of them theorems; 8 builds, the last numbered 9) and a check module `ScratchUnitsTurnCheck` (2 theorems; 2 builds, numbered 8 and 10; ten builds in all for the two).

## What they state, as the reader read them

The reader's verdict: "Neither module has a MUST finding. Every statement says what was asked, or something more general that still contains it. No premise is unsatisfiable."

**For `Keepable`** (the package's "some run from here stays within the guard"):

- `keepable_step_iff`: for every process and guard, with no premise, a guard is keepable from a configuration exactly where it holds there and some step leads to a configuration it is keepable from.
- `not_keepable_step`, `not_keepable_run`: where every step keeps the guard's complement, a step from a configuration the guard is not keepable from leads to one it is not keepable from, and so along any run that starts from such a configuration. No decision of the guard is used.
- The premise is needed and is not the least, each by a built case: on a process of the package a step gains keepability where the premise fails (`ChoicePoint.keepable_gained`); and on the successor law of the numbers, a process defined in the scratch, the premise fails while the conclusion holds (`Successor.not_keepable_kept_complement_not`). The exact premise is stated too (`not_keepable_invariant_iff`).

**For units on the line on a stock:**

- `units_turn_iff`, with the turn `T` given (`before`, `belowT`), and `units_turn_iff_first`, with only its existence assumed (`comes : ∃ N, X N < m`) and the regime asked at the first such step: the statement in units of 20 November as corrected. Premises of both: the growers `S` are decided and each needs `m`; every other unit of every generation leaves only itself and needs `n`, with `0 < n ≤ m` (`Stays`); nothing is given from nothing; the start is within `hi` and `Keeps` at the start's stayers' take. That the course comes below `m` is a premise and is not derived. The premise that some stayer is left at the turn is dropped and derived inside the proof, so where the turn leaves no stayer the premises cannot hold and the theorem concludes nothing; a separate line (`one_need_ends`) is written for that.
- The transfer is stated once as `unending_carrier`; for growers and stayers it is `unending_turned`.
- Cases with the old statements exactly, each checked by `rfl` and none proved by calling the old theorem: `WayOfUnits.two_units_iff` (`two_units_iff_case`), the scratch's `mixed_turns_iff` of 17 November, the scratch's `unending_grown`, and `TurningInTime.unending_iff_first_marked` (`unending_iff_first_marked_case`, checked by `first_marked_same`), through `unending_iff_first_marked_wide`, which weakens its premise `asItWasEnds`. `WayOfUnits.unending_iff_carrier` matches by the reader's eye and has no `rfl` check; the reader suggests one. The scratch's `mixed_turns_iff` has one premise, that the rest is not empty, which is unused and is carried unnamed; that is the only change to its signature.
- A worked example (a grower needing 8 that leaves a grower and a stayer needing 1, from a start with no stayer) is built, meets the premises, and gives the same verdict from the computed course and from the law; the reader checked its numbers by hand.

## What turned out other than on paper

By the units' implementer; the reader agreed on the first two; the last three it did not address:

- **`mixed_turns_iff` is a case only where the stayers' need is strictly below the growers'.** Where the two needs are equal no decided predicate separates the growers from the rest, no stayer is left, and the separate line is needed. Neither the worker of 20 November nor the capped reader had said this.
- **`two_units_iff` needs the separate line for two equal pairs**, as predicted.
- **The paper argument's use of `gone_from` was not followed** (its premise `closed` is global, as the reader of 20 November warned); the proof uses that the stayers' way is fixed under the step.
- **For growers and stayers (`unending_turned`) the carrier is the list of units itself**, not the `Nat ⊕ Unit` the capped reader had sketched; the general transfer takes any carrier.
- No premise of the statement was missing and no conclusion was false.

## What the reader found that is lesser

- `one_need_ends` is narrower than its docstring says: it also asks that the units of generations after the turn need the growers' need. The reader proposes a statement that would cover the whole case; it is argued, not built.
- The step form of the keepable law uses its premise only at the one step it is given, so a form with a local premise is possible; argued, not built.
- **Would any proof in the package get shorter?** One: `TurningInTime.unending_iff_first_marked`, from about 18 lines to 3 through a version with a weaker premise that the units module builds. `two_units_iff` would get longer, not shorter. `unending_iff_carrier` only if its helpers are retired, which the reader did not count. For the keepable module, none: October's renewal theorems sit outside the package and the bridge to them is not written.
- For a landing: `JointKeeping` does not import `Horizon`, where `Run.cons` is; `Enough.prepend` duplicates `Run.cons`; and if the widened law lands, a remark in `TurningInTime` must name the weaker premise.
- The keepable implementer did not write the positive form (keepable after a step gives keepable before): it needs a decision of the guard, and it expects it unprovable without one (argued, not proved).

## What it is, set against the direction

A join of the smaller kind and nothing more: two theorems of the package (`two_units_iff`, `unending_iff_first_marked`) and two scratch theorems of 17 November become cases, each with an `rfl` check, of three statements (`units_turn_iff_first`, with `one_need_ends` where no stayer is left; `unending_carrier`; `unending_iff_first_marked_wide`); a third package theorem, `unending_iff_carrier`, matches by the reader's eye. One law of the package would get shorter, and a general step law that October's files had only for their own process is stated for every process (the bridge to those files is on paper only). It is 1,367 lines for these cases, which is more Lean and not less; whether that is worth putting to the package is not settled here. By the repository's practice, as the writer knows it and not from these sources, entering the package needs the core run, which is heavy on this machine, and a telling for each theorem set against its signature at that landing.

## What it cost

Three AI agents, 0.70 million tokens by the run's own count, 57 minutes; the ceiling told to Ren beforehand was about 1.5 million.

## Where it is

Beside this note, as text: the three modules, their last build logs, the units implementer's report, the keepable implementer's return (its report file was refused by its tool, so its structured return is set down as the run's journal has it), the reader's report, and the checker's findings on this note. The working tree was `/Users/ren/tmp/dj/batch22`, which is not tracked.
