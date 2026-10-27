# UE13: landing precedence and its links, and what can be born next

28 October 2026. AI-written landing note for board item UE13. It says what lands, the decisions taken at landing, the exact command sequence and what the run showed. The scripts are in [kit/](kit/).

## What lands

**Lean.** `Becoming.CausalGrowth` (from [tree/Becoming/](tree/Becoming/)) is a new core module, a leaf at L1 importing `Becoming.HeldPossible`, with no L2 module in its closure. After the fix round and the re-check (NOTE §7 and §8) it has 161 theorems in 212 declarations, every axiom report empty ([scratch-5.log](scratch-5.log)). No landed declaration changes. The module is added in three places:
- to `CORE` in `check_becoming.py`, after `Becoming.Tasks`, and to the checker's scope text;
- to the root `Becoming.lean`, as an import and an L1 bullet: it names no ethical predicate, and no module in its closure is L2;
- to the package README rows (EN, ZH), after Tasks'.

Imported with the whole package (`import Becoming`, 336 modules) it clashes with no name ([clash.log](clash.log)). No layer label changes.

**Two records**, both recorded-checked, each declaration of the module cited by exactly one.
- `precedence-and-its-links`, *Precedence and its links*, family F01: seven law groups (links; reached by links with no finiteness; exactly with transitivity; deciding what lies between; the excluded-middle calibration; causal sets; ω + 1), 36 declarations, home 01 §1 after the paragraph on cycles. One formal-reuse dependency (continuation-relative-to-a-class) and one related record (what-can-be-born-next).
- `what-can-be-born-next`, *What can be born next against what continues*, family F07: twenty-seven law groups, 176 declarations, home 07 §2 after tasks and what performs them. Four formal-reuse dependencies (precedence-and-its-links, what-a-course-keeps-reachable, where-the-possible-grows, continuation-relative-to-a-class) and two related records.
- what-a-course-keeps-reachable and where-the-possible-grows each gain a related entry to the second and one history note. No statement, next step or declaration of theirs changes.

**Texts.**
- 01 §1 is the home section of the first record (`r-precedence-and-its-links`), with a labelled reading [AI reading, D45].
- 07 §2 is the home section of the second (`r-what-can-be-born-next`), after tasks and what performs them, with a labelled reading [AI reading, D45]; 07's open entry on the second-order direction gains a sentence.
- 08 §8 gains two bullets beyond the table, and 08's receipt counts are recounted.
- The study section of BECOMING-RENEWAL-READING.md.
- The UE plan: its items 6 and 7, and its owners.
- regions.json: the first record root, base `grammar`; the second and the module significance, base `frame`.

## Decisions

- **One module, two records.** Law 1 is a claim about the root's precedence, distinct from the growth, so it has a record of its own homed where precedence is defined. `Causet` and `Causet.Ordered` belong to it, since its laws on causal sets use them; the growth record depends on it.
- **A leaf.** Nothing below uses the module, so nothing imports it.
- **The review packet.** The logic review's question L-02 (4) is answered in part; the packet ([LOGIC.md](../../../../../../theories/becoming/review/LOGIC.md)) is re-synced by its owner, not edited here.
- **Names.** Links are 覆盖 in the Chinese texts, since 链 names the chain. The witnesses live in namespaces of their own. The order never reversing widening is named by what it does (`not_above_antichain`), not by a contest; the re-check's `right` is `Kinds.swapped`, `Finer.wide` with `0` and `1` exchanged.
- **The re-check's witnesses in the module.** The witnesses that most comparisons of two courses fail without the empty start are in the module (namespace `Starts`), since the docstrings and the records rely on the start; the calibrations are stated as excluded middle, with what the need says about the unfolding, and the De Morgan witnesses they replace are not kept.
- **Re-pointing.** No landed statement or proof changes. The drift expected is in the sections UE13's texts write (01 §1, 07 §2 and its open entry, 08 §8), and in the root and README lines the integration edits.

## Commands

All commands run from the landing worktree's root, with `K` = the kit in the main checkout's study folder (`_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue13-causal-sets/kit`), `P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming` and `RF=_process/research/2026-10-05-generative-foundation-review/root-foundation`. The study folder is copied into the worktree before step 4.

1. `python3 -B $K/integrate_ue13.py`: copies the module, and edits CORE, the scope, the root module and the READMEs.
2. `(cd $P && python3 -B check_becoming.py)`, giving `RECEIPT`.
3. `python3 -B $RF/THEOREM-CONNECTIVITY.py --check`; any apart roots it reports are read and registered by `$K/apart_ue13.py` (written from the report), then the check again and `--write`.
4. `python3 -B $K/texts_ue13.py RECEIPT N`, where `N` is the last § plus one (asserted).
5. `python3 -B $K/make_records_ue13.py RECEIPT N`. It asserts the style caps and each record's lint (no hard finding, every warning printed), the receipt's hash, empty axiom reports, and that every declaration is cited by exactly one record. `--caps` checks the caps, the lint and the cover against the scratch audit and writes nothing.
6. `python3 -B $K/repoint_ue13.py RECEIPT` (a dry run), then the same with `--apply`: only the records drifting by the texts.
7. `python3 -B $K/board_ue13.py land UE13 RECEIPT N "QUEUE" "STATE"`. This moves the row to the history file, with its statements brought to what the Lean shows, adds the queue entry, names the latest receipt, drops UE13's head-of-queue clause and adds UE13 to the UE row's landed items.
8. `make research-render research-check research-links research-test`, with the kit, the note, the review and the re-check in the worktree first. Then commit the owned paths with `git commit -m … -- <paths>` (no person or AI named, no co-author trailer), merge main if it moved, re-render, and fast-forward main.

## What the run showed

28 October 2026, from main at `908054894` (UE13 at the head of the queue).

- **The checker passed**: core receipt `20261027T195912.152773Z`, 336 modules (320 core), 16,309 theorems, 22,312 declarations audited, every source declaration's axiom report empty; 9 Lean steps run and 1,335 reused. `Becoming.CausalGrowth` holds 161 theorems in 212 declarations, as in scratch. Its one unnamed instance, the decidability of the path witness, is covered by the core environment audit. The structure `Causet` adds one generated `injEq` lemma depending on `propext` (229 in all), outside the requirement on source declarations, as for every structure.
- **Connectivity**: of the module's 161 theorems, 91 are stated on the process family, 44 are used by a theorem on the base and 26 stand apart. The check reported sixteen apart roots, registered by [apart_ue13.py](kit/apart_ue13.py): eight witnesses (the path, ω + 1 with its order and its infinite interval, the numbers in their order, the two classes), four supports (a link is a pair, no cycle on a causal set, a birth's element is maximal, all the elements are not a stem before the birth), three laws of general structure (every net whose reach is a relation contains its links; precedence the reach of its links on a causal set; no configuration renews without end) and one calibration (reaching every pair of every causal set by links is excluded middle, whose course form is on the base). No entry retired.
- **Texts and records**: the texts wrote study §431; the two records were written with no lint warning, 36 and 176 declarations, each cited once; re-pointing found nothing to re-point, since the texts change no section another record cites.
- **Checks**: the generated pages re-rendered; research-check found no error and no source drift, the two new records no style finding; research-links found no broken link; research-test ran 213 tests, all passing (one skipped).

## After landing

Once no session uses them, remove the landing worktree and these build outputs, which are not data: `tree/.build`, `probes/tree/.build`, `probes2/tree/.build`, and the clash tree in the scratchpad.
