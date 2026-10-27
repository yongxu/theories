# UE10: landing what a course keeps reachable

26 October 2026, revised 27 October after the re-check and the second re-check. AI-written landing note for board item UE10. It says what lands, the decisions taken at landing, the exact command sequence and what the run showed. The scripts are in [kit/](kit/).

## What lands

**Lean.** `Becoming.ReachableRanges` (from [tree/Becoming/](tree/Becoming/)) is a new core module, a leaf at L1 importing Horizon, Labelled, Onward, Population, Admission, LawAlongRun, Extension, Lexical, Bundles and EventualWidening, with 68 modules in its closure and none of them L2; it has 135 theorems in 196 declarations after the fix round and the two re-checks (NOTE §6). No landed declaration changes. The module is added:
- to `CORE` in `check_becoming.py`, after `Becoming.ComparingCourses`, and to its scope text;
- to the root `Becoming.lean`, as an import and an L1 bullet (it names no ethical predicate and no module in its closure is L2);
- to the package README rows (EN, ZH), after ComparingCourses'.

**Layer labels.** Two landed modules carry the label L1 while importing an L2 module: `Becoming.EventualWideningInstances` (UE4) imports `Becoming.Weightings`, and `Becoming.ComparingCourses` (UE9) imports `Becoming.EventualWideningInstances`. Their root bullets and README rows (EN, ZH) are relabelled L2, through the module named, as KeepingWidening's are; no Lean changes.

**The record** `what-a-course-keeps-reachable`, *What a course keeps reachable*, status recorded-checked.
- Twenty-three law groups (EN, ZH), citing every declaration: ranges of courses, covering and widening what can be reached, inclusion now, `EndsNow`, greatest courses and determined processes, covering with a lag and the lagged order, the lagged order on a determined process and along a course, `WiderNow`, its other admissions and C, the possible, nothing added along a course, covering carrying the possible, `NoCourse`, the rise, keeping widening for chains, `Climb` and `AllAtOnce`, `KeptAlternative`, the disagreement, the lexical order, the lower preorder, C's extension, `DeferredBranching` and `KeptTogether`.
- Two hypotheses, eight does-not-show items, ten counterexamples, ten formal-reuse dependencies, one interpretive dependency (comparing-two-courses-on-what-they-admit, whose lagged order this one is built as, not imported) and four related records.
- comparing-two-courses-on-what-they-admit, eventual-widening and what-keeping-widening-needs: their next steps point to the new record, each with a related entry and one history note; no declaration of theirs changes.

**Texts.**
- 07 §2 is the home section (`r-what-a-course-keeps-reachable`), after comparing two courses on what they admit, with a labelled reading [AI reading, D45]; eventual widening's reading and UE9's reading point to it; 07's Open item on the second-order direction is narrowed, leaving what carries a course's openings.
- 08 §8 gains a bullet beyond the table (Kreps 1979, Jones and Sugden 1982, Pattanaik and Xu 1990, Arrow and Fisher 1974, Henry 1974, van Glabbeek 1990, Kauffman 2000, Longo, Montévil and Kauffman 2012, Sen 1985), and 08's receipt counts are recounted.
- The study section of BECOMING-RENEWAL-READING.md; the UE plan's item 7 and owners; regions.json (the record and the module, significance, old base).

## Decisions

- **A leaf.** The comparisons are alternatives with their witnesses, which no module below uses and C's order does not adopt, so nothing imports the module.
- **Declarations beside other modules' definitions.** `Web.KeepsWidening.chain`, `Web.KeepsWidening.of_chain` and `Web.keepsWidening_iff_chain` connect EventualWidening's keeping widening by name to the chain law, both ways, `Web.KeepsWidening.not_listed_via_chain` re-derives its law over a listed type from the chain law, and `Law.runs_agree` is the two-run form of Branching's `law_run_state`, derived from it. They stay in the leaf until the owners of those definitions move them.
- **The lagged order proved here.** Importing `Becoming.ComparingCourses` for `strictJoin_trans` would put an L2 module in the closure, through `Becoming.EventualWideningInstances`, so the lagged order's laws are proved directly, with configurations at any universe.
- **Universes.** Configurations `S : Type u`, the lagged order included; formations are at `Type`, as the pigeonhole's lemmas are.
- **Not built.** The optional branching witness for keeping the possible within a horizon widening, the order on two chosen courses and `X : Type w` (NOTE §3, §6).
- **No Lean re-pointing.** No landed declaration changes, so the only drift is in the sections UE10's texts write and in the root and README lines the integration edits.

## Commands

All commands run from the landing worktree's root, with `K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue10-what-can-be-reached/kit`, `P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming` and `RF=_process/research/2026-10-05-generative-foundation-review/root-foundation`.

1. `python3 -B $K/integrate_ue10.py`: copies the module and edits CORE, the scope, the root module and the READMEs, the two layer labels included.
2. `(cd $P && python3 -B check_becoming.py)`, giving `RECEIPT`.
3. `python3 -B $RF/THEOREM-CONNECTIVITY.py --check`, then the same with `--write`.
4. `python3 -B $K/texts_ue10.py RECEIPT N`, where `N` is the last § plus one (asserted).
5. `python3 -B $K/make_records_ue10.py RECEIPT N` (it asserts the style caps and that every declaration is cited).
6. `python3 -B $K/repoint_ue10.py` (a dry run), then the same with `--apply`.
7. `python3 -B $K/board_ue10.py land UE10 RECEIPT N "QUEUE" "STATE"`: the row to the history file with its four statements brought to what the Lean shows, the queue entry, the latest receipt, UE10's head-of-queue clause dropped, the way now's UE item brought to the landing and UE10 added to the UE row's landed items.
8. `make research-render research-check research-links research-test`, with the kit and this note in the worktree first; commit the owned paths with `git commit -m … -- <paths>` (no person or AI named, no co-author trailer), merge main if it moved, re-render, and fast-forward main.

## What the run showed

To be filled from the run.

## After landing

Remove `tree/.build`, `probes/tree/.build`, `recheck/tree/.build` and `recheck2/tree/.build` (build output, not data) and the landing worktree once no session uses them. The untracked `probes/tree/Becoming/ComparingCourses.lean` is a byte-identical copy of the landed `Becoming.ComparingCourses` (sha256 `e5d2cb98…`), redundant once no session uses it.
