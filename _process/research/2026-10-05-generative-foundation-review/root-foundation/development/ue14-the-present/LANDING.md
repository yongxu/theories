# UE14: landing the present on causal-set growth

28 October 2026. AI-written landing note for board item UE14. It says what lands, the decisions taken at landing, the exact command sequence and what the run showed. The scripts are in [kit/](kit/).

## What lands

**Lean.** `Becoming.Presence` (from [tree/Becoming/](tree/Becoming/Presence.lean)) is a new core module, a leaf at L1 importing `Becoming.CausalGrowth` and `Becoming.OrderNormal`, with no L2 module in its closure. After the fold of the review's findings, the course forms and the re-check (NOTE §7, law 10, §8) it has 164 theorems in 190 declarations, every axiom report empty ([scratch-14.log](scratch-14.log)). No landed declaration changes. The module is added in three places:
- to `CORE` in `check_becoming.py`, after `Becoming.CausalGrowth`, and to the checker's scope text;
- to the root `Becoming.lean`, as an import and an L1 bullet: it names no ethical predicate, and no module in its closure is L2;
- to the package README rows (EN, ZH), after CausalGrowth's.

Imported with the whole package it clashes with no name ([clash.log](clash.log)). No layer label changes.

**One record**, recorded-checked, citing each declaration of the module once: `the-present-on-causal-set-growth`, *The present on causal-set growth*, family F01, thirty-one law groups, home 01 §1 after precedence and its links. Six formal-reuse dependencies (precedence-and-its-links, what-can-be-born-next, normal-forms-need-decided-apartness, order-of-exchanges-is-the-invariant, continuation-relative-to-a-class, counts-exist-where-decided). precedence-and-its-links and what-can-be-born-next each gain a related entry to it and one history note; no statement, next step or declaration of theirs changes.

**Texts.**
- 01 §1 is the record's home section (`r-the-present-on-causal-set-growth`), with a labelled reading [AI reading, D45]; 01's open entry on presence in time is narrowed to it.
- The overview's open list gains a clause.
- 08 §8 gains a bullet beyond the table, and 08's receipt counts are recounted.
- The study section of BECOMING-RENEWAL-READING.md.
- The UE plan: item 6's paragraph, the structural gap of the present, the failure list and the owners.
- regions.json: the record and the module root, base `frame`.

## Decisions

- **One module, one record.** The laws answer one question, the root's open entry on presence in time, on one model; they are homed where the entry is.
- **A leaf.** Nothing below uses the module, so nothing imports it.
- **Names.** `MaximalBorn` for the present at a stage, since the core's frontier (`Requirement.Frontier`) is that of a comparison among alternatives; `LeastAbove`, `NaturalLabelling`, `Comparable`; "together" for being present together, which is not the root's co-presence, 俱有, mutual reach. 覆盖 for links in the Chinese texts, as in UE13.
- **`count` kept local.** It computes the numbers `Frequency.count` does; importing `Becoming.Frequency` would add six modules to the leaf's closure.
- **The calibrations** are stated as equivalences with excluded middle and its weak form, with what each need says about the unfolding.
- **Course forms.** Each main law is stated on the growth's courses, `Run process` from the empty set, through `natural_iff_course`, so the laws the texts read on every or some course are stated on courses, and the module connects to the base the connectivity check measures. The laws on natural labellings stay as the order theory they restate.
- **The master laws.** The module proves no closure, return, lumping or order law of `Becoming.GrammarLaws` locally (the coordination note's item 4); its laws are of linear extensions, which no master law states. The strict-join laws of `ComparingCourses` that the note found are placed with OU3c (board `735956a8b`).
- **Re-pointing.** No landed statement or proof changes. The drift expected is in the sections the texts write (01 §1 and its open entry, 08 §8, the overview's §10), and in the root and README lines the integration edits.

## Commands

All commands run from the landing worktree's root, with `K` = the kit in the main checkout's study folder (`_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue14-the-present/kit`), `P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming` and `RF=_process/research/2026-10-05-generative-foundation-review/root-foundation`. The study folder is copied into the worktree before step 4.

1. `python3 -B $K/integrate_ue14.py`: copies the module, and edits CORE, the scope, the root module and the READMEs.
2. `(cd $P && python3 -B check_becoming.py)`, giving `RECEIPT`.
3. `python3 -B $RF/THEOREM-CONNECTIVITY.py --check`; the apart roots it reports are read and registered by `$K/apart_ue14.py` (written from the report), then the check again and `--write`.
4. `python3 -B $K/texts_ue14.py RECEIPT N`, where `N` is the last § plus one (asserted).
5. `python3 -B $K/make_records_ue14.py RECEIPT N`. It asserts the style caps and the record's lint (no hard finding, every warning printed), the receipt's hash, empty axiom reports, and that every declaration is cited exactly once. `--caps` checks the caps, the lint and the cover against the scratch audit and writes nothing.
6. `python3 -B $K/repoint_ue14.py RECEIPT` (a dry run), then the same with `--apply`: only the records drifting by the texts.
7. `python3 -B $K/board_ue14.py land UE14 RECEIPT N "QUEUE" "STATE"`. This moves the row to the history file, with its statements brought to what the Lean shows, adds the queue entry, names the latest receipt, drops UE14's head-of-queue clause and adds UE14 to the UE row's landed items.
8. `make research-render research-check research-links research-test`, with the kit, the note, the review and the re-check in the worktree first. Then commit the owned paths with `git commit -m … -- <paths>` (no person or AI named, no co-author trailer), merge main if it moved, re-render, and fast-forward main.

## What the run showed

28 October 2026, from main at `6964c0135` (UE14 at the head of the queue).

- **The checker passed**: core receipt `20261028T054831.888463Z`, 337 modules (321 core), 16,473 theorems, 22,502 declarations audited, every source declaration's axiom report empty; 9 Lean steps run and 1,339 reused. `Becoming.Presence` holds 164 theorems in 190 declarations, as in scratch. Its four unnamed instances, the decidability of the witnesses' relations, are covered by the core environment audit. It defines no structure, so no generated `injEq` lemma is added (229 in all, as before). Two earlier receipts of the landing worktree, from before the course forms and before the re-check's theorem, are superseded and not committed.
- **Connectivity**: of the module's 164 theorems, 19 are stated on the process family, 73 are used by a theorem on the base and 72 stand apart. The check reported twenty-three apart roots, registered by [apart_ue14.py](kit/apart_ue14.py): eleven witnesses (the vee, the diamond and the four elements off it), six calibrations, each with its course form on the base, three laws naming no course (whatever holds in every or some natural labelling depends only on size and precedence; with precedence decided, the least element above is the one link), one restatement of the present at a stage on the grammar, and two supports. UE13's `ordered_reach_links_iff` is now used by an apart theorem (`least_iff_only_link`), so its entry retired; its reason is carried by `least_iff_only_link`'s.
- **Texts and records**: the texts wrote study §432; the record was written with no lint finding, 190 declarations in 31 laws, each cited once, and precedence-and-its-links and what-can-be-born-next gained their related entries, also with none. Re-pointing re-bound three records whose statement references cite the overview's §10, where the texts add one clause on presence in time (loss-read-in-time-by-the-others, readers-drawn-from-the-selected, shaping-read-by-readers-drawn-from-the-selected); the change was read first and touches none of their claims.
- **Checks**: the generated pages re-rendered; research-check found no error and no source drift; research-links found no broken link; research-test ran 213 tests, all passing (one skipped).

## After landing

Once no session uses them, remove the landing worktree and these build outputs, which are not data: `tree/.build`, `probes/tree/.build`, the two superseded receipts in the worktree, and the clash, bridge, mirror, course-form and re-check trees in the scratchpad.
