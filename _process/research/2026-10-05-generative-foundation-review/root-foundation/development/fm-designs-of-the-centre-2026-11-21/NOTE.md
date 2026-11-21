# Eight designs of a model of the centre, each refuted by another kind of model: 21 to 22 November 2026

*AI-written (Claude Fable, board row FM), 22 November 2026, 01:25:38 WIB (clock, read by the command that wrote this). A record of two rounds on paper and by small programs, and of one scratch Lean module; nothing here is in the package and nothing is a result of the theory. No person has read any of it. Every design and every return is one AI agent's, filed word for word as `.md.txt`; their programs are not filed here and are kept at `refs/salvage/fm/whole-1122`.*

## Why

Ren, 21 November 2026: "I think our goal should be a full map with formal link proof done elegantly with its center" ([his words](../../../../../../sources/15-codex-theory-conversations/2026-11-21-a-full-map-with-its-centre.md)); and later that evening he gave the session a higher effort, the many-agent mode, and Astra 6.2 and Opus beside Fable ([his words](../../../../../../sources/15-codex-theory-conversations/2026-11-21-high-and-ultracode-fable-astra-opus.md)). The centre is one statement with both outcomes of one course: a way of selecting that uses up what it rests on and can no longer be turned, and a way in which forms change and the going on continues.

## What was done

1. **Eight designs**, one angle each, none seeing the others, on a brief frozen first ([BRIEF-DESIGNS.md.txt](BRIEF-DESIGNS.md.txt); requirements from the page of the session holding row DJ on what a model must have; eight tests of what counts as nothing gained; the list of what had failed since 16 November): two by Opus, three by Fable, three by Astra 6.2. They are in `designs/`.
2. **My reading of the eight together**, written before any refuter ran and not shown to them ([READING-OF-THE-EIGHT.md.txt](READING-OF-THE-EIGHT.md.txt)): a candidate centre in two layers.
3. **Fifteen refuters**, each of another kind of model than wrote the design it was given, on a second frozen brief ([BRIEF-REFUTE.md.txt](BRIEF-REFUTE.md.txt)), one lens each: read against the Lean and ask whether a general law of the design does work the old laws do not; or rebuild the model blind and search for a counterexample. Their returns are in `refute/`.
4. **One scratch Lean module** for the one claim that could only be settled there ([its brief](BRIEF-LEAN-COMPARISON.md.txt); [the module as text](lean-comparison/ScratchComparison.lean.txt), 256 lines; [its last build's log](lean-comparison/build-10.log.txt); [the implementer's report](lean-comparison/REPORT.md.txt)).

## What came of it

**No design is the centre, and none is a law that joins.** Fifteen refuters, one verdict in different words: each design survives, if at all, as a built case with one or two small lemmas. My own reading is refuted with them, in both layers. What each layer was, why it fell, what the refuters found already in the package, what is kept, and what it cost, are in [AFTER-THE-REFUTATIONS.md.txt](AFTER-THE-REFUTATIONS.md.txt), with the scratch module's outcome appended to it:

- **The comparison in Lean.** One statement, keeping for n steps carried along a one-sided comparison of two guarded processes, with no premise beyond the comparison, of which `GuardHorizon.closed_viable`, `Keeping.keptFor_of_closed` and `TurningInTime.locked_ends_rising` are each a case with its statement unchanged, each checked by `rfl`; no axiom. **By the tests frozen before it ran it gains nothing**: the lock's new chain is 85 lines against 58, and both keeping cases are shorter by direct induction. It is not landed. The three cases' own conditions are not one thing and not three: two are one condition at two relations, a region closed under some move with its outcomes inside it, read at the configurations (`Closed`) and at the classes a reading leaves (the closed family); the third is of the other kind, a rank, the clock's time, kept in step by the old law's premises. The comparison stands over a closed region and a rank only by being general enough to be neither, which is why each case's work is in its own condition. Small and new in it: `keptFor_iff_viable` with no premise (keeping by a choice from a reading for n steps is viability for n steps on a process of classes, the empty class counted as an outcome).

## What followed from it

That seven of eight designers, and the session, proposed as new what the package states in general led to a read of every module of the package: [its note](../fm-whole-read-2026-11-22/NOTE.md).

## Where it is

The three briefs with their hashes (each hash file names its brief by the name it had in scratch, without `.txt`); `designs/DESIGN-<key>.md.txt`; `refute/RETURN-<design>-<lens>-<model>.md.txt`; `lean-comparison/`; the notes written after each brief was frozen ([of the designs](AFTER-DESIGNS.md.txt), [of the Lean brief](AFTER-LEAN-COMPARISON.md.txt)); the session's first page of guesses and its withdrawal ([FROZEN-THE-CENTRE.md.txt](FROZEN-THE-CENTRE.md.txt), [AFTER.md.txt](AFTER.md.txt)). Some times in these notes were first written as guesses and are corrected in place, each saying what it first said.
