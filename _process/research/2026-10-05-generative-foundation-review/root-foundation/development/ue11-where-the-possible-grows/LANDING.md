# UE11: landing where the possible grows

27 October 2026. AI-written landing note for board item UE11. It says what lands, the decisions taken at landing, the exact command sequence and what the run showed. The scripts are in [kit/](kit/).

## What lands

**Lean.** `Becoming.HeldPossible` (from [tree/Becoming/](tree/Becoming/)) is a new core module, a leaf at L1 importing ReachableRanges, Mechanism, Gated and Junctures, with 74 modules in its closure and none of them L2; it has 81 theorems in 110 declarations after the fix round and the re-check (NOTE §6). No landed declaration changes. The module is added:
- to `CORE` in `check_becoming.py`, after `Becoming.ReachableRanges`, and to its scope text;
- to the root `Becoming.lean`, as an import and an L1 bullet (it names no ethical predicate and no module in its closure is L2);
- to the package README rows (EN, ZH), after ReachableRanges'.

No layer label changes.

**With it.** One docstring correction in a landed module, from DF's [LEFT.md](../../../../2026-10-05-repository-reconciliation/architecture/df/LEFT.md), for UE1b's owner. `Becoming.SelectionPool`'s `anticipates_iff` cites `Revision.web_keeps_iff`, whose name is `Registration.web_keeps_iff` (in Revision.lean). It is one docstring line; no statement or proof changes. The five records citing SelectionPool are re-pointed to its corrected bytes, and their three proof bindings are rebound to UE11's receipt, which checked those bytes.

**The record** `where-the-possible-grows`, *Where the possible grows*, status recorded-checked, family F07.
- Twenty-three law groups (EN, ZH), citing every declaration: a move adds nothing to the possible under its process; keeping widening needs departures without end; a course that returns; the possible with a part held; the two instances; on the root; held move by move, and as at the start; where it grows; where it keeps widening; located where holding is decided; read on the course's moments; a rule changing its own rule; every possibility with some member of a sequence held; a tower of rules with no top; the premise is needed; along a course of the tower; and seven witnesses (a raised rule, endless change not sufficing, a course that only returns, a tower copying down, both witnesses ceasing under what is held, growth with renewal without end, and the two readings of holding differing off a class).
- Two hypotheses, eight does-not-show items, seven counterexamples, nine formal-reuse dependencies (what-a-course-keeps-reachable, projection-carrying-a-law, every-origin-passes-the-gate, where-a-run-goes-on, every-loss-passes-a-juncture, continuation-relative-to-a-class, master-laws-on-the-grammar, levels-of-closure, rest-by-balance) and two related records.
- what-a-course-keeps-reachable and rules-that-change-themselves-in-the-grammar: each gains a related entry and one history note; no statement, next step or declaration of theirs changes.

**Texts.**
- 07 §2 is the home section (`r-where-the-possible-grows`), after what a course keeps reachable, with a labelled reading [AI reading, D45] placed beside D5 and the root's `«生生不息»`; UE10's reading's last clause points to it.
- 01's Open item on self-changing conditions is narrowed: the tower is stated, with its scheme fixed; a change of the law of change with no fixed scheme, and a space of rules not given with the carrier, are left.
- 02 §9 gains a pointer after rules that change themselves in the grammar, outside its record-bound paragraph.
- 08 §8 gains a bullet beyond the table (Banzhaf and others 2016, Taylor and others 2016, Adams, Zenil, Davies and Walker 2017, des Rivières and Smith 1984, Wand and Friedman 1988, Bateson 1972, Longo, Montévil and Kauffman 2012), and 08's receipt counts are recounted.
- The study section of BECOMING-RENEWAL-READING.md; the UE plan's item 7, its gap on self-changing conditions and its owners; regions.json (the record and the module, significance, base `frame`: the laws are stated on processes and runs, the root law on the grammar).

## Decisions

- **A leaf.** The laws are near-definitional readings of UE10's possible and witnesses; nothing below uses them, so nothing imports the module.
- **Declarations beside other modules' definitions.** `Onward.within_eq_heldMoves` and `Branching.keeping_eq_heldMoves` (the two landed restrictions as instances, by definition), the laws of reach and traces under the held moves (`Reach.of_heldMoves`, `Reach.heldMoves_mono`, `Reach.same_of_heldMoves`, `Reach.heldMoves_iff_sameAsStart`, `Trace.heldMoves_sameAsStart`, `Trace.sameAsStart_heldMoves`), `adaptive_keeps_rule_iff` (beside Mechanism's `adaptive`) and the root law `«及在渐粗列之相续»` stay in the leaf until the owners of the definitions they concern move them. The root law is named in the root's vocabulary: 列, a sequence, since 族 is the grammar's family.
- **Imports.** Gated for the gate instance (`Gated.origin`), Junctures for Branching's `keeping`; the located forms search with `Amounts.unmarked_or_marked`, already in the closure, rather than importing Reproduction.
- **Names.** `Becoming.Alternating` is taken (RuleCapture), so the re-check's witness with renewal without end landed as `RaisedEveryOther`; its two counterexamples to holding as at the start as `AdjacentHeld` and `OrderHeld`.
- **Not built.** The review's degenerate adaptive witness (P11, with no held move) and the listed-along form (N2, which is UE10's `Reaching.KeepsWidening.not_listed` itself at the held chain); the re-check's weakly decided located form and its calibration to weak excluded middle (Q8, a lemma of the item), and its Q3, Q7 and Q9, which stay probes; see NOTE §6. A change of the law of change with no fixed scheme stays open, as 01 says.
- **Re-pointing.** No landed statement or proof changes. The drift is in the sections UE11's texts write, in the root and README lines the integration edits, and in SelectionPool's bytes. The re-point script checks that the docstring line is SelectionPool's only change before re-pointing its records and rebinding them.

## Commands

All commands run from the landing worktree's root, with `K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue11-where-the-possible-grows/kit`, `P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming` and `RF=_process/research/2026-10-05-generative-foundation-review/root-foundation`.

1. `python3 -B $K/integrate_ue11.py`: copies the module, edits CORE, the scope, the root module and the READMEs, and corrects SelectionPool's docstring.
2. `(cd $P && python3 -B check_becoming.py)`, giving `RECEIPT`.
3. `python3 -B $RF/THEOREM-CONNECTIVITY.py --check`, then the same with `--write`.
4. `python3 -B $K/texts_ue11.py RECEIPT N`, where `N` is the last § plus one (asserted).
5. `python3 -B $K/make_records_ue11.py RECEIPT N` (it asserts the style caps, the receipt's hash and empty axiom reports, and that every declaration is cited; `--caps` checks the caps and the cover against the scratch audit and writes nothing).
6. `python3 -B $K/repoint_ue11.py RECEIPT` (a dry run), then the same with `--apply`: the records drifting by the texts, and SelectionPool's records with their bindings rebound to `RECEIPT`.
7. `python3 -B $K/board_ue11.py land UE11 RECEIPT N "QUEUE" "STATE"`: the row to the history file with its five statements brought to what the Lean shows, the queue entry, the latest receipt, UE11's head-of-queue clause dropped and UE11 added to the UE row's landed items.
8. `make research-render research-check research-links research-test`, with the kit, this note, the review and the re-check in the worktree first; commit the owned paths with `git commit -m … -- <paths>` (no person or AI named, no co-author trailer), merge main if it moved, re-render, and fast-forward main.

## What the run showed

To be written at landing.

## After landing

Remove `tree/.build`, `probes/tree/.build` and `recheck/tree/.build` (build output, not data) and the landing worktree once no session uses them.
