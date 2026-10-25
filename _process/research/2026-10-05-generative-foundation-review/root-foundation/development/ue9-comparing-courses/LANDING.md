# UE9: landing comparing two courses on what they admit

26 October 2026. AI-written landing note for board item UE9. It says what lands, the decisions taken at landing, the exact command sequence and what the run showed. The scripts are in [kit/](kit/) with the run's logs.

## What lands

**Lean.** `Becoming.ComparingCourses` (from [tree/Becoming/](tree/Becoming/)) is a new core module, a leaf importing only `Becoming.EventualWideningInstances`; it has 191 theorems in 244 declarations, after the re-check's fixes ([RECHECK-UE9.md](RECHECK-UE9.md), NOTE §6). No landed module changes. The module is added:
- to `CORE` in `check_becoming.py` and to its scope text;
- to the root `Becoming.lean`, as an import and an L1 bullet (it names no ethical predicate and imports only an L1 module);
- to the package README rows (EN, ZH), after KeepingWidening's.

**The record** `comparing-two-courses-on-what-they-admit`, *Comparing two courses on what they admit*, status recorded-checked.
- Twenty-one law groups (EN, ZH), citing every declaration: the order lemma, the cycle of crossed rankings, the two-sided witness and its mirror, law 1 in its class and one-pair forms, the reverse ranking, counting scale, the listed scope, infinite width not sufficing, "by name" needed, widening with a lag and its forms, names across steps, the lag along a continuation, the tail order, UE4's lag decided, where it is silent, law 3, why the choice matters, law 4, and law 4 telling the lag's forms apart.
- Two hypotheses, six does-not-show items, seven counterexamples and six formal-reuse dependencies.
- eventual-widening and what-keeping-widening-needs: their next steps point to the new record, each with a related entry and one history note; no declaration of theirs changes.
- what-keeping-widening-needs also states its passing laws with requirements never loosening, a hypothesis beside the World premises, as UE8's first review found: its statement, law 9 and premises, with a second history note.

**Texts.**
- 07 §2 is the home section (`r-comparing-two-courses-on-what-they-admit`), after what keeping widening needs, with a labelled reading [AI reading, D45]; eventual widening's reading points to the lag's decision, and 07's Open item on the second-order direction is narrowed, with "by name" and the two-sided web.
- UE7's passing laws take requirements never loosening beside the World premises: 07 §2's theorem and reading, 07's Open item and 02's Open item say so.
- 08 §8 gains a bullet beyond the table (Askell 2018, relative anonymity, Chichilnisky 1996, delayed simulation, delay games), and 08's receipt counts are recounted.
- The study section of BECOMING-RENEWAL-READING.md; the UE plan's item 7 and owners; regions.json (the record and the module, significance, old base).

## Decisions

- **A leaf.** The comparisons are alternatives with their witnesses, which no module below uses and C's order does not adopt, so nothing imports the module. The general lemma (`strictJoin_trans`, `strictJoin_irrefl`) stays in it: it would belong in `Prelude`, and moving it rebuilds every module above. Link composition (`Web.Linked.append`) generalizes the landed `Web.Linked.snoc` (UE7); it would belong in `ContinuedClasses`, with `snoc` derived from it, a move for the owners of `ContinuedClasses` and `KeepingWidening` that rebuilds every module above `ContinuedClasses`. Until then the general form sits in the leaf beside its special case, as the record's validation scope says.
- **S4 not taken.** One own-condition web over any carrier would remove two copies of a definition, but it changes the landed `EventualWideningInstances`; that is its owner's choice.
- **No Lean re-pointing.** No landed module changes, so the only drift is in the sections UE9's texts write.

## Commands

All commands run from the landing worktree's root, with `K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue9-comparing-courses/kit`, `P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming` and `RF=_process/research/2026-10-05-generative-foundation-review/root-foundation`.

1. `python3 -B $K/integrate_ue9.py`: copies the module and edits CORE, the scope, the root module and the READMEs.
2. `(cd $P && python3 -B check_becoming.py)`, giving `RECEIPT`.
3. `python3 -B $RF/THEOREM-CONNECTIVITY.py --check`, then the same with `--write`.
4. `python3 -B $K/texts_ue9.py RECEIPT N`, where `N` is the last § plus one (asserted).
5. `python3 -B $K/make_records_ue9.py RECEIPT N` (it asserts the style caps and that every declaration is cited).
6. `python3 -B $K/repoint_ue9.py` (a dry run), then the same with `--apply`.
7. `python3 -B $K/board_ue9.py land UE9 RECEIPT N "QUEUE" "STATE"`: the row to the history file with its three statements brought to what the Lean shows (the re-check's R1), the queue entry, the latest receipt, UE9's head-of-queue clause dropped and the way now's UE item brought to the landing.
8. `make research-render research-check research-links research-test`, with the kit and this note in the worktree first; commit the owned paths with `git commit -m … -- <paths>` (no person or AI named, no co-author trailer), merge main if it moved, re-render, and fast-forward main.

## What the run showed

To be filled from the run.

## After landing

Remove `tree/.build` (build output, not data) and the landing worktree once no session uses them.
