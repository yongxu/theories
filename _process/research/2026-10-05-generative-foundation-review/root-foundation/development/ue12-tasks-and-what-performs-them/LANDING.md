# UE12: landing tasks and what performs them

27 October 2026. AI-written landing note for board item UE12. It says what lands, the decisions taken at landing, the exact command sequence and what the run showed. The scripts are in [kit/](kit/).

## What lands

**Lean.** `Becoming.Tasks` (from [tree/Becoming/](tree/Becoming/)) is a new core module, a leaf at L1 importing `Becoming.HeldPossible`, with no L2 module in its closure. After the fix round and the re-check (NOTE §6) it has 128 theorems in 167 declarations, every axiom report empty. No landed declaration changes. The module is added in three places:
- to `CORE` in `check_becoming.py`, after `Becoming.HeldPossible`, and to the checker's scope text;
- to the root `Becoming.lean`, as an import and an L1 bullet: it names no ethical predicate, and no module in its closure is L2;
- to the package README rows (EN, ZH), after HeldPossible's.

No layer label changes.

**The record** `tasks-and-what-performs-them`, *Tasks and what performs them*, status recorded-checked, family F07.
- Thirty-seven law groups (EN, ZH) cite every declaration:
  - the reading: what performs a task; possible from what is there naturally; delivering is having an output possible; invariable where the successor is fixed, without halting; zero moves and no input;
  - held throughout, and the composition laws: one region in series; one region in turn on two substrates; the pair region; two regions; where no performing part is needed;
  - the interleavings: two processes interleaved; within the interleaving on two substrates; two parts interleaved on one substrate;
  - the additive pattern, the division, the regress within one delivery, making the performer, what can be done with the part held and where it grows;
  - reach and lagged covering, a delivery adding nothing to the whole possible, strictly on the catalytic cycle, covering silent where no course starts, and same-offset widening ranking the output above the input or the input above the output;
  - the witnesses: UE10's climbing process, an unmade performer, a catalytic cycle, holding sufficient and not needed, a pair not regular, composition failing within one interleaving on one substrate, a resetting process with its listed pair and one part under two regions, a possible whole of impossible parts, and a tower changing every level at once.
- It also has two hypotheses, eight does-not-show items and eleven counterexamples, four formal-reuse dependencies (what-a-course-keeps-reachable, where-the-possible-grows, continuation-relative-to-a-class, where-a-run-goes-on) and two related records.
- what-a-course-keeps-reachable and where-the-possible-grows each gain a related entry and one history note. No statement, next step or declaration of theirs changes.

**Texts.**
- 07 §2 is the home section (`r-tasks-and-what-performs-them`), after where the possible grows, with a labelled reading [AI reading, D45].
- 08 §8 gains a bullet beyond the table (Deutsch 2013, Gogioso and others 2023, Deutsch and Marletto 2025), and 08's receipt counts are recounted.
- The study section of BECOMING-RENEWAL-READING.md.
- The UE plan: its item 5 and its owners.
- regions.json: the record and the module, significance, base `frame` (the laws are stated on processes).

## Decisions

- **A leaf.** The laws are near-definitional readings of UE10's possible and UE11's held possible, with witnesses. Nothing below uses them, so nothing imports the module.
- **Declarations beside other modules' definitions.** `Reaching.coversLater_of_trace`, `Reaching.not_widensWithLag_of_reach` and `Reaching.widensOrLater_iff_of_reach` stay in the leaf until the owner of UE10's definitions moves them, and `Tasks.tower_reach_held` until the owner of UE11's moves it beside `RuleTower.possible_iff_held` (the re-check's R7).
- **Placement notes.** `Tasks.interleave`, the package's first asynchronous product of processes, belongs beside `productProcess` at the process layer once another module needs it. `Tasks.sameReading_class` duplicates `GrammarCourse.sameValue_class` up to orientation, outside the closure; the general fact belongs at the grammar.
- **Names.** `Becoming.Rising` (SelectionTerm) and `Becoming.Coupled` (Continuation) are taken. So the rising witness is `RiseTask` and the coupled one, renamed for what it does, `Resetting`. `Becoming.Counting` is a module, and the counter was UE10's `Climb.process` under another name, so the climbing witness is `ClimbTask`, built on it (the re-check's R6).
- **After the re-check.** The module lands without a third reading. Each change after the re-check is taken from its proposed Lean or text or built from its probes, every axiom report is empty, and the record's validation scope and the note (§6) say that no independent reader has read the module since.
- **Re-pointing.** No landed statement or proof changes. The drift is in the sections UE12's texts write, and in the root and README lines the integration edits.

## Commands

All commands run from the landing worktree's root, with `K` = the kit in the main checkout's study folder (`_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue12-tasks-and-what-performs-them/kit`), `P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming` and `RF=_process/research/2026-10-05-generative-foundation-review/root-foundation`. The study folder is copied into the worktree before step 4.

1. `python3 -B $K/integrate_ue12.py`: copies the module, and edits CORE, the scope, the root module and the READMEs.
2. `(cd $P && python3 -B check_becoming.py)`, giving `RECEIPT`.
3. `python3 -B $K/apart_ue12.py`: registers the module's four apart roots, `Tasks.Conserved.holdsOne_eq_xor`, `Tasks.Conserved.holdsOne_recodes`, `Tasks.Resetting.listed_not_regular` and `Tasks.Unregular.not_regular` (theorems standing apart from the base, each a fact about one witness that names no process, and used by no other apart theorem), as model witnesses in `THEOREM-CONNECTIVITY-APART.json`. It also retires the entry of `«定后之逐点»`, which `Tasks.ClimbTask.fixed` now uses on the base, to the kit's `apart-retired.json`, as R28 retired its own. Then `python3 -B $RF/THEOREM-CONNECTIVITY.py --check`, and the same with `--write`.
4. `python3 -B $K/texts_ue12.py RECEIPT N`, where `N` is the last § plus one (asserted).
5. `python3 -B $K/make_records_ue12.py RECEIPT N`. It asserts the style caps and the record's lint (no hard finding, every warning printed), the receipt's hash, empty axiom reports, and that every declaration is cited. `--caps` checks the caps, the lint and the cover against the scratch audit and writes nothing.
6. `python3 -B $K/repoint_ue12.py RECEIPT` (a dry run), then the same with `--apply`: only the records drifting by the texts.
7. `python3 -B $K/board_ue12.py land UE12 RECEIPT N "QUEUE" "STATE"`. This moves the row to the history file, with its statements brought to what the Lean shows (the review's F1, F5, F6, F8 and F9, and the re-check's R1). It also adds the queue entry, names the latest receipt, drops UE12's head-of-queue clause and adds UE12 to the UE row's landed items.
8. `make research-render research-check research-links research-test`, with the kit, the note, the review and the re-check in the worktree first. Then commit the owned paths with `git commit -m … -- <paths>` (no person or AI named, no co-author trailer), merge main if it moved, re-render, and fast-forward main.

## What the run showed

The run was on 28 October 2026 (local time; the receipt's stamp is UTC), from main `e2d2de2fb`, the board's head-of-queue clause, in a fresh worktree on branch `ue12`.
- Step 1 joined the module, sha256 `706db12b…90af`, as planned.
- Step 2: the checker passed, core receipt `20261027T170011.101817Z`.
- Step 3: the first connectivity check reported four apart roots without a reason. Two were the kit's; `Tasks.Conserved.holdsOne_recodes` and `Tasks.Unregular.not_regular` came with the re-check. It also reported one register entry no longer an apart root, `«定后之逐点»`, which `Tasks.ClimbTask.fixed` uses on the base. The script was extended to register the four and retire that entry, and then the check and the write passed. Four of the module's 128 theorems stand apart, the four witnesses.
- Steps 4–6: the texts at study §430; the record, 167 declarations in 37 laws, with no lint finding; nothing drifted, so nothing was re-pointed.
- Step 7 moved the board row.
- Step 8: the first render failed, because the record's aliases still named `Delivers.narrows`, renamed `Delivers.adds_nothing` after the re-check. The alias was corrected in the kit. The record and the two related entries were regenerated from main's state of those records, and the render passed. research-check passed with no error, research-links found 0 broken links, and research-test ran 213 tests, OK with one skipped.

## After landing

Once no session uses them, remove the landing worktree and these build outputs, which are not data: `tree/.build`, `probes/tree/.build`, `probes2/tree/.build` and the clash tree `clash/` (a copy of the package with the module imported).
