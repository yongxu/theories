# UE7: landing what keeping widening needs

26 October 2026. AI-written landing note for board item UE7. It says what lands, the decisions taken at landing, the exact command sequence and what the run showed. The scripts are in [kit/](kit/) with the run's logs. The landing ran in a clean worktree at `ecb0ce662` (main after DF1), and main's one later commit (DF2's plan) was merged before the fast-forward.

## What lands

**Lean.** `Becoming.KeepingWidening` (from [tree/Becoming/](tree/Becoming/)) is a new core module, a leaf importing EventualWidening, Gain, Flow and MapInstances; it has 126 theorems in 154 declarations. Population, Novelty, Gain and Admission change by 3-way patches against their last commits (board rule 9): seven general laws are added below seven landed ones, which are re-proved from them, and no declaration is removed. The module is added:
- to `CORE` in `check_becoming.py` and to its scope text;
- to the root `Becoming.lean`, as an import and an L2 bullet (L2 through `Becoming.MapInstances`); the EventualWideningInstances, Admission, Novelty and Population bullets are updated;
- to the package README rows (EN, ZH), with EventualWideningInstances' row marking its first carrier form superseded.

**The record** `what-keeping-widening-needs`, *What keeping widening needs, and what carries it*, status recorded-checked.
- Fifteen law groups (EN, ZH): the gain bridge, fed from beyond, takers and renewers multiplying, the recency definition and its laws with the decided form, what the map reads of keeping and of carrying, the exclusion along passing of support, and the witnesses (Ladder, ClosedCycle, OpeningChain, the two forms independent, Saturated and OwnCondition, Loosening and Source).
- Two hypotheses, five does-not-show items, three counterexamples and eleven formal-reuse dependencies.
- Extended records (rule 9): support-passed-on (the uniform form, its statement rewritten), support-from-the-supported (the first step) and returning-novelty-forgetting-on-levels (the list form), each with one history note.
- eventual-widening: law 7 is its first carrier form, marked superseded by the recency form; its provisional item, next delta, related and history are updated.

**Texts.**
- 07 §2 is the home section (`r-what-keeping-widening-needs`), with a labelled reading [AI reading, D45]; eventual widening's carrier sentence and UE4's reading point to it, and 07's Open item on the second-order direction is narrowed.
- 02 §3.2 (`r-support-passed-on`) gains the uniform-form sentence, and 02's Open item on the capture loop and 生成 is narrowed.
- 08 §8 gains a bullet beyond the table (open-ended evolution, the TAP equation and assembly theory, maintenance scaling and growth theory, autocatalytic sets), and 08's receipt counts are recounted.
- The study section §419 of BECOMING-RENEWAL-READING.md, and regions.json (the record and the module, significance, old base).

## Decisions

- **UE4's record keeps its own declarations**, the first carrier form `Flow.OpenedByOpened` among them, marked superseded; the recency form, its laws and the restated witnesses are the new record's. The landed definition is not edited.
- **Re-pointing is filtered.** The Lean drift is accepted only after the signature audit shows every theorem of the four modules printing its old statement. The one other drifting pair (eventual-widening on 07 §2) lies in a section UE7 writes.
- **No apart root.** Every statement of the module is on the World family, so the connectivity register takes none, and `--check --write` passes as it is.

## Commands

All commands run from the landing worktree's root, with `K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue7-what-keeps-widening/kit`, `P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming` and `RF=_process/research/2026-10-05-generative-foundation-review/root-foundation`.

1. `python3 -B $K/integrate_ue7.py`: copies the module, 3-way applies the four patches (stopping on any conflict or drift from the kit tree) and edits CORE, the scope, the root module and the READMEs.
2. `(cd $P && python3 -B check_becoming.py)`, giving `RECEIPT`.
3. `python3 -B $K/signatures_ue7.py RECEIPT`, which must print "statements unchanged in every changed module".
4. `python3 -B $RF/THEOREM-CONNECTIVITY.py --check`, then the same with `--write`.
5. `python3 -B $K/texts_ue7.py RECEIPT N`, where `N` is the last § plus one (asserted).
6. `python3 -B $K/make_records_ue7.py RECEIPT N` (it asserts the style caps).
7. `python3 -B $K/repoint_ue7.py RECEIPT` (a dry run), then the same with `--apply`.
8. `python3 -B $K/board_ue7.py land UE7 RECEIPT N "QUEUE" "STATE"`: the row to the history file, the queue entry, the latest receipt, UE7's head-of-queue clause dropped and the way now's UE item brought to the landing.
9. `make research-render research-check research-links research-test`, with the kit and this note in the worktree first; commit the owned paths with `git commit -m … -- <paths>` (no person or AI named, no co-author trailer), merge main if it moved, re-render, and fast-forward main.

## What the run showed

- **Integrate.** The four patches applied cleanly and matched the kit tree.
- **Checker.** Receipt `20261025T191425.159994Z`: 1,029 Lean steps run and 291 reused. The closure has 330 modules, 314 of them core, with 15,563 theorems in 21,324 declarations; every axiom report of the five modules is empty, and the core compiles from the prelude.
- **Signatures.** All theorems of Population, Novelty, Gain and Admission print their old statements; no definition's body changed; the added declarations are exactly the seven expected.
- **Connectivity.** No new apart root (330 modules, 15,489 spine theorems, 1,507 apart).
- **Texts and records.** N = 419; the record cites 155 declarations in fifteen groups, every field within the caps.
- **Re-pointing.** 55 pairs in 52 records: 54 Lean pairs (statements unchanged in all four modules) and eventual-widening's 07 §2 pair; none left to other owners; one rebinds line.
- **Generated pages.** Recorded in the landing commit's message (render, check, links and test).

## After landing

Remove `tree/.build` (build output, not data) and the landing worktree once no session uses them.
