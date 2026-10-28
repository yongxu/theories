# UE15: landing a world's reorderings as courses of growth

28 October 2026. AI-written landing note for board item UE15. It says what lands, the decisions taken at landing, the exact command sequence and what the run showed. The scripts are in [kit/](kit/).

## What lands

**Lean.** `Becoming.ReorderingGrowth` (from [tree/Becoming/](tree/Becoming/ReorderingGrowth.lean)) is a new core module, a leaf at L1 importing `Becoming.Presence`, whose closure holds `Becoming.Reordering`, with no L2 module in its closure. After the review, its fold, the re-check and its fold (NOTE §7 and §8) it has 62 theorems in 76 declarations, every axiom report empty ([scratch-9.log](scratch-9.log)). No landed declaration changes. Imported with the whole package it clashes with no name ([clash.log](clash.log)). The module is added in three places:
- to `CORE` in `check_becoming.py`, after `Becoming.Presence`, and to the checker's scope text;
- to the root `Becoming.lean`, as an import and an L1 bullet: it names no ethical predicate, and no module in its closure is L2;
- to the package README rows (EN, ZH), after Presence's.

**One record**, recorded-checked, citing each declaration of the module once: `reorderings-as-courses-of-growth`, *A world's reorderings as courses of growth*, family F01, home 01 §9.6 after the order of exchanges as the invariant. Seventeen law groups. Seven formal-reuse dependencies (order-of-exchanges-is-the-invariant, normal-forms-need-decided-apartness, exchanges-commute-unless-joined, the-present-on-causal-set-growth, precedence-and-its-links, what-can-be-born-next, counts-exist-where-decided). the-present-on-causal-set-growth and order-of-exchanges-is-the-invariant each gain a related entry to it and one history note; no statement, next step or declaration of theirs changes.

**Texts.**
- 01 §9.6 gains the record's row after the order of exchanges as the invariant, and a labelled reading [AI reading, D45] after the section's reading; 01's open entry on presence in time is extended to it.
- The overview's open list gains a clause.
- 08 §8 gains a bullet beyond the table, after UE14's, and 08's receipt counts are recounted.
- The study section of BECOMING-RENEWAL-READING.md.
- The UE plan: item 6's paragraph, the structural gap of the present, the failure list and the owners.
- regions.json: the record and the module root, base `old-base`, as the order of exchanges.

## Decisions

- **One module, one record.** The laws answer one question, whether the World's interleavings are causal-set growth, so that UE14's laws hold on the World by instance; they are homed with the World's order of exchanges.
- **A leaf.** Nothing below uses the module, so nothing imports it.
- **Decisions Prop-valued.** `Decided` and `WeaklyDecided`, weaker than a Boolean or `Decidable` joining; UE14's laws taking a `Decidable` instance of the whole precedence are not instanced, three of their forms with no decision are, and `past_every_iff` has none.
- **New witnesses.** Three small worlds with empty flows (`Witnesses.emptyFlow`), since the World's existing witnesses have two exchanges and no fixed footprint.
- **The master laws.** The module proves no closure, return, lumping or order law of `Becoming.GrammarLaws` locally (the coordination note's item 4).
- **Re-pointing.** No landed statement or proof changes. The drift expected is in the sections the texts write (01 §9.6 and the open entry, 08 §8, the overview's §10), and in the root and README lines the integration edits.

## Commands

All commands run from the landing worktree's root, with `K` = the kit in the main checkout's study folder (`_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue15-reorderings-as-growth/kit`), `P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming` and `RF=_process/research/2026-10-05-generative-foundation-review/root-foundation`. The study folder is copied into the worktree before step 4.

1. `python3 -B $K/integrate_ue15.py`: copies the module, and edits CORE, the scope, the root module and the READMEs.
2. `(cd $P && python3 -B check_becoming.py)`, giving `RECEIPT`.
3. `python3 -B $RF/THEOREM-CONNECTIVITY.py --check`; any apart roots it reports are read and registered by `$K/apart_ue15.py` (written from the report), then the check again and `--write`.
4. `python3 -B $K/texts_ue15.py RECEIPT N`, where `N` is the last § plus one (asserted).
5. `python3 -B $K/make_records_ue15.py RECEIPT N`. It asserts the style caps and the record's lint, the receipt's hash, empty axiom reports, and that every declaration is cited exactly once. `--caps` checks the caps, the lint and the cover against the scratch audit and writes nothing.
6. `python3 -B $K/repoint_ue15.py RECEIPT` (a dry run), then the same with `--apply`: only the records drifting by the texts.
7. `python3 -B $K/board_ue15.py land UE15 RECEIPT N "QUEUE" "STATE"`.
8. `make research-render research-check research-links research-test`, with the kit, the note, the review and the re-check in the worktree first. Then commit the owned paths with `git commit -m … -- <paths>` (no person or AI named, no co-author trailer), merge main if it moved, re-render, and fast-forward main.

## What the run showed

28 October 2026. A first landing, from main at `8459e9e78`, passed every check (core receipt `20261028T072618.218634Z`, study §435) but waited for DF3, which held the head of the queue first; meanwhile EC6c changed `Flow.lean`, in this module's closure, so that receipt no longer covered main. It is kept at `refs/salvage/ue15-land-first`. A second landing, from main at `0421539d8` (core receipt `20261028T082113.931247Z`, study §437), passed every check too, but OU3d landed first, changing `GrammarLaws.lean`, also in the closure, and taking §437; it is kept at `refs/salvage/ue15-land-second`. UE15 was landed a third time from main at `4fcfc7011`, on a fresh worktree.

- **The checker passed**: core receipt `20261028T083434.601834Z`, 338 modules (322 core), 16,553 theorems, 22,600 declarations audited, every source declaration's axiom report empty; 11 Lean steps run and 1,341 reused. `Becoming.ReorderingGrowth` holds 62 theorems in 76 declarations, as in scratch, with no unnamed instance. It defines no structure, so no generated `injEq` lemma is added (229 in all).
- **Connectivity**: every one of the module's 62 theorems connects to the base: 56 are stated on the World family, 3 on both families and 3 are used by a theorem on the base. No apart root is added, and no entry retires; two of UE14's theorems, apart before, are now used by a theorem on the base (`Becoming.Presence` apart 70 of 164, from 72).
- **Texts and records**: the texts wrote study §438 (OU3c, EC6b, EC6c with EC6d, DF3 and OU3d took §433 to §437 during the work); the kit applied to main after them with no anchor moved. The record was written with no lint finding, 76 declarations in 17 laws, each cited once, and the-present-on-causal-set-growth and order-of-exchanges-is-the-invariant gained their related entries. Re-pointing re-bound the three records whose statement references cite the overview's §10, where the texts extend the clause on presence in time; the change was read first and touches none of their claims.
- **Checks**: the generated pages re-rendered; research-check found no error and no source drift; research-links found no broken link; research-test ran 213 tests, all passing (one skipped).

## After landing

Once no session uses them, remove the landing worktree and these build outputs, which are not data: `tree/.build`, and the mirror, clash and review trees in the scratchpad.
