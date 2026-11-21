# Two of this week's formal links, moved from scratch into the package: 21 November 2026

*AI-written (Claude Fable, board row FM), 21 November 2026. It records a landing, not a result of the theory: nothing here places the two ways of going on with respect to each other. No person has read it. The modules were written on 21 November by AI workers under the session that holds board row DJ and read there by readers who took no part ([their record](../dj-a-line-on-a-stock/scratch-lean-2026-11-21/NOTE.md)); that session handed them over to be landed. The writer of this note read the statements and the proofs moved, wrote none of them, and changed no statement or proof.*

## Why

Ren, 21 November 2026, about 19:50 WIB: "I think our goal should be a full map with formal link proof done elegantly with its center" ([his words](../../../../../../sources/15-codex-theory-conversations/2026-11-21-a-full-map-with-its-centre.md)). The links below were the ones of that week in which an older result comes out as a case of a more general statement with the general statement doing the work. They stood outside the package, as text.

## What entered the package

1. **One step of keeping along some course**, a new module `Becoming.KeepableStep` (11 declarations, 8 of them theorems). For every process and guard, with no further premise: the guard is keepable from a configuration exactly when it holds there and some step leads to a configuration it is keepable from (`keepable_step_iff`). Every step keeps not being keepable exactly when no step from outside the guard leads to a configuration the guard is keepable from (`not_keepable_invariant_iff`); where every step keeps the guard's complement that holds (`not_keepable_step`), and along every run (`not_keepable_run`). Two built cases: a step that gains keepability where the complement is not kept (`ChoicePoint.keepable_gained`), and the successor law of the numbers, where not being keepable is kept by every step and the complement is not (`Successor.not_keepable_kept_complement_not`). It is the scratch module `ScratchKeepableStep` with its statements and proofs unchanged. It is a leaf in the package: what imports it is the bridge to October's renewal files, which is to land beside those files and is not in this landing.
2. **The split at the first marked level under a weaker premise**, in `Becoming.TurningInTime`: `unending_from`, `unending_iff_marked_at` and `unending_iff_first_marked_wide`, added above `unending_iff_first_marked`. The old theorem's statement is unchanged, letter for letter; its proof, 53 lines, is now a call of the wide law, 3 lines: its premise, that the course as it was comes below the need, gives the wide law's premise, that at some step of that course it is not so that the need is met and the level unmarked. The module goes from 3,092 to 3,151 lines.

## What a reader who took no part said of it

Before the core run one AI reader (run as Claude Opus; 19 tool calls) set every new docstring, the root file's bullets, the package README's rows in both languages and the checker's scope text against the Lean statements ([its return, word for word](RETURN-reader-docstrings.md.txt)). It marked no place as false or as saying more than its statement, and eleven lesser places. All eleven are mended in its words where it gave words, and not read again. Two of what it said bear on what this landing is:

- Of the turn law: the general law does the work in the old theorem's new proof, and nothing is put in and taken out. But "the wide law's proof is the old 53-line proof, generalised and split", and so "it is a re-factoring within the module. It does not make the law a case of a result proved elsewhere before".
- Of the step law: it has the same form as the kernel's step law (`kernel_step_iff`), with some step for every step. The scratch module called it the twin. No theorem relates the two: the kernel is over what can be reached and keepable over runs, and at a configuration with no step the kernel can hold where keepability fails. The module now says "the same form as".

## What did not enter, and why

- **The transfer of the net of units to a carrier** (`unending_carrier`, of which `WayOfUnits.unending_iff_carrier` is a case, checked the same by `rfl` in scratch). The package's proof of that theorem is 4 lines and would be about 12 by the call, and its helpers would stay. A general law beside a shorter special proof is more Lean and not a join. It stays as text.
- **The bridge to October's renewal files** (`renewable_iff_keepable`, with `renewable_iff_step` and `renewability_not_generated` proved again from the step law). It belongs beside those files, outside the package, and is the next landing on this row. That folder's checker pins a hash of `Depletion.lean` that the file no longer has. The writer read the change: one commit of 16 October (`bf842fced`) added a comment on the file's import line and changed nothing else.
- **The rest of the scratch module on units** (1,367 lines), and the 21 mended tellings of the survey's trial.
- **The atlas.** No dynamic was added or changed. These links are in the Lean and in two records; they are not on the atlas's listing.

## What was run

- Two focused scratch builds of both modules, before and after the mend ([first](build-before-the-read.log.txt), [second](build-after-the-mend.log.txt)): exit 0, no module unclean, no declaration with an axiom.
- One core run, 20:35:06 to 20:36:12 WIB ([its summary](core-run.summary.txt)): receipt `20261121T133506.986317Z`, passed; 21 Lean steps run and 1,619 reused.
- The gate of the landing's tree is named in the landing's clause on the board.

## Where it is recorded

The step law is a sixth law of the record [conditions-kept-together](../../../../../../theories/becoming/results/records/conditions-kept-together.md), which already stated `Keepable`; the wide split is in one law of [turning-in-time](../../../../../../theories/becoming/results/records/turning-in-time.md). Each has a history note. Ten other records that cite the live receipt file were re-pointed, hash only.
