# The laws of a level course under a level that stays below, with tidyings owed beside them (23 November 2026)

*AI-written (Claude Fable, board row DJ). A Lean landing in four modules of the package, with docstrings in two more and in the root. Every new proof is an old proof with one lemma swapped or a premise passed through; nothing deep is added. What a reader who took no part changed in this note and in the docstrings is said at its end.*

## Why

On 23 November row FM landed `Becoming.LevelAlone`. Its core law asks, beside its common premises, that a level of the course as it was, once below `H₂ + y₂`, stays below (`below`). Its forms in the notions `Recoverable` and `NoReturnAt` are given only where the level never rises, because the two laws of `Becoming.TurningInTime` they call, `recoverable_iff_above` and `noReturnAt_of_below`, ask a course that never rises (`fall`) from a start at most `hi` (`top`). A reader of another kind of model had argued on paper that the first of those holds under `below` and a bound on the level. That morning Ren said to the coordinating session that sessions which had not finished their work should finish those parts and then merge ([his words](../../../../../../../sources/15-codex-theory-conversations/2026-11-23-be-the-new-coordinator.md)); that this seam between two rows' modules is such a part is this row's reading. The row claimed it on the board before any build.

## What was frozen first, and what the attack changed

The brief was written before any build and attacked by one reader (`BRIEF.md.txt`, its "After"; `RETURN-attack.md.txt`; hashes and clock in `FROZEN.sha256.txt` and `FROZEN.clock.txt`, under the files' names before `.txt` was added). The attack confirmed the fact the landing rests on: in the module's section on the point of no return, `fall` is used in three places, all through the private `later_le`, and `top` in one. It worked each general law on paper. It found two false sentences in the brief's account of `LevelAlone`, that the lemma to be added already stands, privately, in that module, that the rule for "the old laws come back as calls" could be met by its letter and for three laws could not be met at all, that the form of the bound was left to taste, and that the docstrings missing "together" are 27 places and not a dozen. All are in the brief's "After", which fixed the forms law by law before the first build.

## What landed

**In `TurningInTime`, nine new theorems** (eight public, one private), each beside the old one it generalises:

| New | In place of `fall` and `top` |
|---|---|
| `above_before_of_stays_below` | `below` alone: a level at or above `c` at a step is at or above it at every earlier step |
| `turned_meets_of_above_of_stays_below`, `turned_meets_iff_of_stays_below` | `below`, and the level at most `hi` at the step `T` of the turn |
| `recoverable_of_above_of_stays_below`, `recoverable_iff_above_of_stays_below` | `below`, and the level at most `hi` at `N` |
| `above_of_recoverable_of_stays_below` | `below`, no bound |
| `noReturnAt_iff_first_below_of_stays_below` | `below`, and the level at most `hi` at every step up to `N` |
| `recoverable_decided_of_stays_below` (private), `noReturnAt_of_below_of_stays_below` | `below`, and the level at most `hi` at every step |

`below` is `∀ t, X t < H + y → X (t + 1) < H + y`. Every other premise is the old law's. No general law needed a premise beyond these two.

**Four old theorems are now one call each of their namesakes, statements unchanged:** `turned_meets_of_above`, `above_of_recoverable`, `noReturnAt_iff_first_below`, and the private `recoverable_decided`. A fall gives `below` in one line, and with the start the bound. **Four stand as they were:** `turned_meets_iff`, `recoverable_of_above`, `recoverable_iff_above`, `noReturnAt_of_below`; a direct call would be longer, and they reach the general laws through the theorems they already call. After the landing `turned_meets_iff_of_stays_below` and `noReturnAt_of_below_of_stays_below` have no caller in the package.

**Seven calls that a checker of row FM's sweep of 22 November had found**, each losing an induction of its own: in `LineOnAStock`, `course_fixed`, `line_or_none`, `met_or_unmet`, `strong_below`; in `Stock`, `search`, `total_append`; in `RegimeMargin`, `Coupled.Indexed.run_within` as `Lasting.closed_orbit band high`. All seven passed the keeping rule (the statement the same, the named law used, no induction left, strictly fewer lines and no more characters); none was put back. `Stock.total_append`'s statement is the same binder by binder and is re-broken over two lines.

**Docstrings.** In `LineOnAStock`, 27 places where the premises `even`, `grows` and `keeps` on a line were told of a unit's kids without saying they are of the kids together; the same in `LineOnAStockCases` (two places), `WayOfUnits` (one) and the root (one). One of them, in `LineOnAStockCases`, was true of each kid as it stood and was changed because the sentence lists a premise that is of the kids together. `strong_below`'s docstring no longer narrates a proof that is not its own.

**Tellings outside the modules:** one clause in the root and in the package's README where they tell the laws of a level course; two laws appended to the record `turning-in-time`, nothing renumbered.

## How it was checked

- **By Lean, set side by side.** A lister (`kit/Rows23.lean.txt`) printed every declaration of the six modules as Lean holds it, private ones too and Lean's own generated names left out, on main and on the scratch build: kind, universe names, each binder's kind, name and type, and for a theorem the head of its proof term, the package theorems it uses and its recursors (`kit/rows-before.txt`, `kit/rows-after.txt`, `kit/compare-output.txt`, by `kit/compare_rows.py.txt`). 883 declarations before, 892 after. None gone. **No statement changed.** Nine new. Eleven proof terms changed: the four old theorems, each now with its namesake at the head, and the seven calls, each now using the law named and with no recursor left.
- **Builds.** Seven scratch builds of the 25 allowed (`builds/`): the two writers' five; one of all six modules together with the unchanged `LevelAlone` on top; and one more of the same after the reader's mends to the docstrings, on which the lister gave the same rows and the same comparison, byte for byte. Every one exit 0, nothing unclean, no axiom in any public declaration of the modules built (the audit is of public declarations; the private ones are reached through the public ones that call them).
- **A test of use, not landed.** The general laws have no caller but their own cases, so one scratch build checked that they fit their one prospective user: `LevelAlone`'s form in `Recoverable` and its no-return form, stated under its core law's premises (with `below`, without `mono` and `still`), build with `recoverable_iff_above_of_stays_below` and `noReturnAt_of_below_of_stays_below` and the bound from that module's `level_within` (`LevelAlone.scratch-test-of-use.appended.lean.txt`). Whether those two forms are then landed in `LevelAlone` is row FM's to say.
- The core run, its receipt, the print of uses and the gate are told on the board's Queue line.

## What it does not show

- No built course separates the general laws from the old in this landing. The course that does is by hand: the levels 3, 3, 4, 4, 0, 0, … of `LevelAlone.Rising` (of which Lean states only `Rising.level_rises`), where the old law cannot be applied and the general one gives recoverable at step 3 and not at step 4. A second hand course, in the docstrings, shows that the bound at the step of the turn cannot be dropped from the first three laws; for the existence of a point of no return the docstring says the bound enters only the deciding.
- It derives no response of a selection, places no two ways, and joins no two places of the map. It states laws under less than they were stated under, and makes four older theorems cases.
- `LevelAlone.above_before` (private there) and `TurningInTime.above_before_of_stays_below` are one statement written twice, because the import runs from the first module to the second. Making the first a call of the second is owed to row FM, its to do or leave.
- Three sentences that the rewrite had left true of the statements and no longer of the route (in the head note, in `noReturn_exists`'s docstring and in `noReturnAt_of_below`'s) were reworded on the reader's finding; the brief had said not to touch the first two.

## Cost

By the runs' records: the attacker of the brief 235,630 tokens; the two writers 461,999. Said beforehand: 0.9 million for the landing's readers in all, with a stop at 0.5 million after two stages, restated at 0.6 before the writers ran; they came to 697,629, over that stop by 97,629. The reader of the docstrings took 253,085, so the landing's readers come to 950,714 against the 0.9 million said. Each stop was told to the coordinating session before the next stage.

## What a reader changed in the docstrings and in this note

One reader who took no part (253,085 tokens) read every new and changed docstring against its statement and proof, recomputed both hand courses, checked the thirty changed sentences on a unit's kids against the premises and the cases' numbers, recounted the record's figures from the lister's rows, and read this note against the returns (`RETURN-reader-of-the-docstrings.md.txt`). Before the core run. It found the nine new docstrings true of their statements in every premise, bound and direction, every "a case of" true of the proof terms, both hand courses right, all thirty sentences true and every place left rightly left. It found three docstring sentences and four others that said more than is proved, and eleven lesser; all are mended in its words. The worst: the root, the README and the record said "a course that never rises meets both" premises, where it meets the bound only from a start at most `hi`; `turned_meets_iff` was said to follow from the general law, where only its if direction does; `noReturnAt_of_below`'s docstring named a route its proof no longer takes; the record's Chinese said "only requires" where the other premises stay, and gave a hand course with no mark that it is by hand. After its mends the six modules were built once more in scratch and the lister run again on that build (below).

The coordinating session, from the worktree before the commit, ran the comparison script on the lister's rows itself, got the filed output byte for byte, and found no sentence of this note that says more than that output; it did not check the docstrings.

