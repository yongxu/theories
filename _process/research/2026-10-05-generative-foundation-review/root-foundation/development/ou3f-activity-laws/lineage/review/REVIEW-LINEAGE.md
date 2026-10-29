# Review: OU3f's lineage part (the bridge and the six lineage laws)

AI-written independent read-only review, 29 October 2026, of [the tree](../tree/Becoming/) (`Identity.lean`, `MapInstances.lean`) and [DESIGN.md](../DESIGN.md). It was made against the package on branch `ou3f-laws` at `b9ca6a840`, where main `62fa37fcc` is merged, so MapInstances is GW3–GW5's. Nothing outside this folder was edited. The checks and their outputs are in [checks/](checks/). A first round against the pre-merge base `5956c2cff` is kept in [checks/round1-old-base/](checks/round1-old-base/), with the same result.

**Verdict: ready after findings 1–4.** The Lean is right:
- every statement prints unchanged;
- each of the six inductions is replaced by its named law's, with nothing applied and then undone;
- the bridge is correct for every `k`;
- every axiom report is empty, and the whole package builds with the tree.

Findings 1 and 2 are text, finding 3 is the landing's own check, and finding 4 is two more derivations or a corrected reason. Findings 5–10 are nits.

## Findings

1. **should fix: "reaches one formation" claims more than `Lineage.unique` shows.**
   - Where: the header bullet ([Identity.lean](../tree/Becoming/Identity.lean):122) and the new doc section (:982) say that without splits "a lineage reaches one formation at each step".
   - What the Lean shows: `Lineage.unique` proves *at most one*, since any two formations it reaches at step `k` are equal. That some formation is reached is `onward`'s content, and only as not refuted. The theorem's own docstring (:1046) says "at most one".
   - Fix: "at most one formation" in both places.
   - Checked against the printed statement (`checks/signatures-new.out`, `@Becoming.Web.Lineage.unique`).

2. **should fix: the design says the endpoint's step is needed; it is not.**
   - The claim: DESIGN.md:26 says that without the conjunct `y.1 = M + k`, "the middle occurrence of split steps cannot be read back as a lineage from `M + j`". This repeats [AUDIT.md](../../AUDIT.md):87.
   - Why it fails: with the restriction in the class position of `«续»`, `steps_advance` gives the middle occurrence's step. That was the laws review's note for this part, kept at [laws/DESIGN.md](../../laws/DESIGN.md):62.
   - Compiled: `split_v3` (`checks/BridgeVariants.lean` §3, empty report) proves `split` from the endpoint-fixed bridge (`lineage_iff_steps_at`), with `steps_advance` and a rewrite of the middle occurrence.
   - So the conjunct saves rewrites, as DESIGN.md:30 says. It is a convenience, not a need.
   - Fix: correct the sentence, and AUDIT.md:87 when the audit is next touched.

3. **should fix: the landing's mechanical test for "no induction of its own" cannot fail.**
   - The test: DESIGN.md:90 checks the dependency dump for any of the six that "refers to itself".
   - Why it cannot fail: Lean compiles structural recursion to `Nat.brecOn` and `Nat.below`, so none of these proofs refers to itself, the old ones included. On main, each of the six old proofs carries `Nat.brecOn`/`Nat.below` and no reference to itself (`checks/deps-main.out`).
   - The dump cannot see the marks either. It records only constants of the run, with `Init`, `Std`, `Lean` and `Lake` excluded ([THEOREM-CONNECTIVITY-DUMP.lean](../../../../THEOREM-CONNECTIVITY-DUMP.lean), `toolchainRoots`), so `Nat.brecOn` never appears in it.
   - Fix: test each proof's constants, with its matchers unfolded, for `brecOn`, `below`, `rec`, `WellFounded.fix` or a `_unary` helper, as `checks/Deps.lean` does. On main it marks all six; in the tree it marks none of them, and of the new and moved declarations only the bridge and `steps_advance` carry an induction.

4. **should fix, or record the right reason: two representation lemmas are cases of grammar laws through the new bridge.**
   - **`Lineage.line`** (Identity.lean:2432) is `«迭则及»` through the bridge, in four lines with no induction (`line_v5`, empty report, statement confirmed by an `example`):
     - the bridge reads the lineage as `k + 1` steps within activity from `M`;
     - `«迭则及»` makes the steps a reach;
     - `«及之单调»` drops the restriction;
     - the first step's restriction gives `W.active M g`.
   - **`line_lineage`** (:2445) is `«闭之及»` with `«及即迭»` through the bridge, with no induction of its own (`line_lineage_v6`, empty report, statement confirmed):
     - a region is closed under the line's steps: active, at or after the start, and within the closure of activity from the start;
     - so the line stays within activity from its start;
     - `«所闭当且仅当同一或及»` with `line_advances` leaves a reach, `«及即迭»` counts its steps, and the bridge reads them.
   - Neither applies a law and then undoes it.
   - The design's reasons for leaving them out (DESIGN.md:63) do not hold:
     - "`line_lineage` would still need its own induction" is false (`line_lineage_v6`).
     - "a correspondence, not a law to derive" concerns standing, not proof. The closure part re-proved `ByPassing.line_back`, a representation, by closure with its standing unchanged ([closure/DESIGN.md](../../closure/DESIGN.md):47; AUDIT.md:221).
   - Fix: derive both here, standings unchanged, since Identity is rebuilt anyway and the statements stay. Otherwise, record the reason they stay out in DESIGN.md and in the audit's (c) list.
   - Deriving `line_lineage` takes away `Lineage.cons`'s one consumer, and no record names `cons`. `cons` is then the bridge read at one more first step (`cons_v4`, four lines, no induction). It goes into the bridge and back out with only `«迭»`'s definition between, so it is a representation, not a derivation from a law. It can stay as a registered apart root, or go; that is the owner's call.
   - `Lineage.active` (two cases) and `lineage_iff_line` (an assembly with no induction) stay, as the design says.

5. **nit: the bridge's forward index re-proves `steps_advance`.**
   - The conjunct `y.1 = M + k` that the bridge reads from steps is `steps_advance k` at `(M, g)`. `steps_advance` now sits just above the bridge, which proves the conjunct again in its own induction (Identity.lean:1027).
   - `steps_iff_lineage_v1` takes this index, and the middle occurrence's index, from `steps_advance`. It has the same statement, the same length and an empty report, and in its forward case the induction supplies only the lineage.
   - Optional, as `«迭则所及»` was in the laws review (finding 3).

6. **nit: the bound `N ≤ M` serves only the converse direction.**
   - The forward reading holds for every `N` and uses no bound (`lineage_of_steps`).
   - That is the direction `split` (Identity.lean:1072) and `back` (:1124) use at a later start. Each builds `M ≤ y.1` only for `from_` to go unused.
   - The iff needs the bound, so the statement is right. DESIGN.md:27 should say that the generality in `N` serves the forward reading and the bound the converse.
   - A forward lemma would drop the two inequalities (`split_v2`). Optional.

7. **nit: `activityFrom`'s docstring and name.**
   - Docstring (Identity.lean:997; also DESIGN.md:19): "it relates no occurrence before `N`" holds only of the first occurrence. An active occurrence at a step from `N` on is related to any active occurrence, earlier ones included. Say "it relates nothing from an occurrence before `N` or from an inactive one".
   - Name:
     - In Identity, `From` in a name marks a reading under a continuation (`ArisesFrom`, `CeasesFrom`, `UnceasingFrom`, `balanceFrom`, `arisingFrom_found`).
     - "From a step on" is the lower-case suffix `_from` (`Census.arisingFrom_of_ceasingFrom_from`, :909).
     - `activityFrom N` means activity from step `N` on, restricted to active sources. The docstring settles the meaning, but names are chosen now, at claim time. A name such as `activityOnward` could not be read as one more reading under a continuation. Owner's call.
   - `steps_iff_lineage` and `steps_start_active` are exact in the module's vocabulary (`steps_advance`, `steps_cancel`, `lineage_iff_line`).

8. **nit: smaller wording.**
   - Identity.lean:1076: "the step from `k`" is the step from `M + k` (also DESIGN.md:43).
   - :1099–1100: "they begin at step `M`". The steps back begin at `M + k`; read forward, they begin at `M`.
   - :121–122 and :981: "its laws are the grammar's laws of steps" and "are then the laws of a lineage". Write "are cases of".
   - :987–988: "read backward through `«迭之逆»`" applies to `back` only, but as written it also covers `onward`.
   - :2195: the edit left a short line ("merges with. The class is activity"); reflow the paragraph.
   - DESIGN.md:22 and :28: `steps_advance` is stated for every relation in the class position, not for every class. `activityFrom` is not a class, as :19 says.

9. **nit: the new subsection's heading covers the census law.** The `###` heading at Identity.lean:976 now also stands over `ceasingFrom_found`, `not_not_arisingFrom_covered` and `arisingFrom_not_stopping_covered` (:1128–1205), which are not the bridge. Add a heading before `ceasingFrom_found`, for example "### The census law from one covering list", or make the bridge's text a plain doc block.

10. **nit: the design is stale after the merge, and two counts are off.**
    - :3 and :80: GW3–GW5 has landed (`4edb05c1f`). It last changed MapInstances (`2ce13d0d1`), not §442.
    - :74:
      - MapInstances now has 27 theorems in 27 declarations, against 28 in 28 ([scratch-4.log](../scratch-4.log); `checks/scratch-new.log`, `checks/scratch-main.log`), not 25 and 26.
      - Identity's 152 in 217, against 149 in 213, is right.
    - :66: GrammarLaws is imported by 322 modules, so a change to it rebuilds 323 of the package's 345 (the receipt lists 345 modules, 342 of them in the spine). Identity's change rebuilds 20, Identity and its 19 importers, as :85 says.
    - :93: the Identity binding of `master-laws-on-the-grammar` should carry `steps_advance`, which the record binds today under MapInstances, beside the bridge and its helpers, so the record still binds it.
    - :95: "No central declaration names these laws." None depends on them either, which is what matters for the measure (below).

## The open question: GrammarLaws' *What is not shown*

**View: hold it for HE, and widen HE's item.**

The board already holds this edit as HE's item (2), with `kept_onward`'s move as item (3) ([board](../../../../../../../BECOMING-WORKBOARD.md), row HE, "queued after UE16, UE17 and OU3f's lineage part"). UE16 is a leaf and UE17 is in the periphery, so neither rebuilds GrammarLaws, and HE's rebuild is the next one. A separate rebuild of 323 modules now, for one sentence of a module doc, would be the redundant rebuild HE exists to avoid. The stale clause under-claims (it calls "not shown" what is shown), which misleads less than an over-claim, and HE bounds how long it stays.

Three conditions:
- (a) DESIGN.md:66 records the decision; it still asks the question.
- (b) HE's item (2) also covers the sentence "Three of the models' step-indexed laws are proved from the laws of steps counted: …" ([GrammarLaws.lean](../../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarLaws.lean):112–115). This landing makes it incomplete, since the six lineage laws are then proved from those laws too. Its wording is fixed now, with the *What is not shown* clause (:145–147) dropped.
- (c) The records this landing updates say what holds (`master-laws-on-the-grammar` drops its does-not-show item), and the board row notes that GrammarLaws' module doc lags until HE.

If any GrammarLaws-wide landing comes before HE, the correction rides with it, by HE's own rule.

## Confirmed

- **Statements.**
  - On the merged base, all 241 declarations of main's Identity (213) and MapInstances (28) print identically in the tree.
    - By `#check @`: `checks/signatures-{main,new}.out`, 780 lines each, `diff` empty.
    - By `#check` with hypothesis names: `checks/binders-{main,new}.out`, 740 lines each, `diff` empty.
  - The pre-merge round (239 declarations against `5956c2cff`) was identical as well.
  - The declaration lists, read by the checker's own scanner (`check_becoming.declarations`), differ only in these ways:
    - `activityFrom`, `steps_iff_lineage` and `steps_start_active` are added;
    - `steps_advance` moves from MapInstances to Identity;
    - no declaration changes kind.
  - The three new statements are in `checks/added-new.out`.
- **Every constant.** `checks/Dump.lean` prints every constant of both modules with `pp.all` (binder names and kinds, universes, implicit arguments), and the value of each definition that is not a compiler-made auxiliary. `checks/compare_dump.py` compares the two outputs (`checks/dump-compare.out`):
  - 757 constants become 771, and none is gone;
  - added: the three new declarations, and eleven matchers the compiler makes for the new proofs;
  - moved: `steps_advance` and its matcher;
  - changed: only the types of eleven matchers inside the re-proved theorems;
  - `continuationStep`'s value is unchanged.
- **Derivations** (`checks/Deps.lean`; `deps-main.out`, `deps-new.out`).
  - On main, each of the six carries `Nat.brecOn` and reaches no law of steps.
  - In the tree, none of them carries an induction mark, and each uses its named law directly:
    - `unique`: `«迭之定»` with `«定后之逐点»`;
    - `origin`: `«迭之定前»` with `«定前之逐点»`;
    - `split`: `«迭之分»`;
    - `through`: only `split`;
    - `onward`: `«或有后则或迭»`;
    - `back`: `«或有后则或迭»` and `«迭之逆»`, with `steps_advance` and `steps_start_active`.
  - `ends` and `lineages_apart` reach the laws unchanged.
  - The inductions left are the bridge's, `steps_advance`'s and the laws' own.
  - Read against the old proofs, each replaced induction is the named law's. What remains is one step's argument (no split, no merge, nothing ceasing, nothing arising) and readings through the bridge. The design's table (DESIGN.md:38–45) describes each correctly, apart from finding 8's first item.
- **The bridge** is correct for every `k`, `0` included, and each part of its restriction is used:
  - **Active sources** make the iff true: from an inactive start, steps under activity can exist where no lineage of one or more steps does. They also make "no split" a fixed successor.
  - **The bound from `M`** makes "no split" and "no merge" global. `«迭之定前»` has no local form, while `unique` could have used the local `«迭之定于»` and needs no change.
  - **The class position** lets `steps_advance`, stated for every relation there, apply, which `back` needs.
  - The endpoint's conjunct and the bound are the subject of findings 2, 5 and 6.
- **`steps_start_active` is needed.**
  - `back` needs the activity of every occurrence its steps back reach, and of their start.
  - Nothing Identity can import gives it. MapInstances' `active_along_line` is downstream of Identity and reads reach under `activityClass`, and `«线内同类»` needs a class, which `activityFrom` is not.
  - It is two cases, with no induction.
- **Moves.**
  - The order is forced: `continuationStep` and `occurrence_eq` must precede the bridge, which must precede the lineage laws, which precede the grammar section. Moving the two up is the smallest move; moving the covering-list section down instead would move about 280 lines.
  - `steps_advance` must precede `back`. It reads only Identity's `continuationStep`, so GrammarLaws cannot hold it.
  - `split` now precedes `through`, which uses it.
  - The moved docstrings are unchanged byte for byte.
  - The tree's MapInstances is main's minus `steps_advance`, a 7-line deletion (`git diff --no-index`). GW3–GW5's change to MapInstances is elsewhere in the file.
- **Downstream.**
  - With the tree, the whole package builds clean: the root `Becoming`, 345 modules, with 15 steps run, 331 reused and nothing unclean (`checks/scratch-downstream.log`).
  - The 14 importers of Identity outside the 41-module closure, the root among them, compiled fresh against the tree.
  - None of the three new names occurs anywhere else in the package.
- **Builds and axioms.**
  - The scratch builds of both trees (`checks/scratch-new.log`, `checks/scratch-main.log`) give every axiom report empty, with the counts of finding 10.
  - A fresh compile of the two tree modules, outside the cache, exits 0 with no messages (`checks/fresh-*.out`).
  - The imports are unchanged, and no `sorry`, axiom or tactic block is added.
- **Central declarations.**
  - The check covered the 213 Lean names in [COVERAGE.json](../../../../../../../../theories/becoming/results/completion/COVERAGE.json): the rows' central declarations, their instances, the master laws' anchors and the rest.
  - None of them depends, transitively, on any of these: the six, `ends`, `lineages_apart`, the bridge, `activityFrom`, `steps_start_active`, `steps_advance`, or `Web.Lineage` itself (`checks/Central.lean`, `central-new.out`). The check finds the dependence in four controls.
  - So the measure cannot change. MV's view may, since laws 10 and 11 of `census-balance-under-continuation` now reach the grammar's laws of steps; the design reruns it.
- **Consumers.** Within the two modules, no declaration loses a consumer, and the new ones have consumers (`checks/Consumers.lean`, `consumers-*.out`), so nothing becomes a root.

## Files in checks/

- `tree-new/` holds the tree's two modules, the same bytes as `../tree/`. `tree-main/` is empty and builds the checkout. Their `.build/` folders are ignored build output.
- **Builds:** `scratch-new.log`, `scratch-main.log` and `scratch-downstream.log` (with their `.err` files) are the scratch builds. `fresh-*.out` are the fresh compiles.
- **Statements:** `SignaturesCommon.lean`, `BindersCommon.lean`, `SignaturesAdded.lean` and `names-main.txt`, with outputs `signatures-*.out`, `binders-*.out` and `added-new.out`.
- **Every constant:** `Dump.lean`, `compare_dump.py` and `dump-compare.out`. The two dumps (0.9 MB each) are not kept; running `Dump.lean` regenerates them, and their sha256 is in `dump-compare.out`.
- **Proofs and their inductions:** `Deps.lean`, with `deps-*.out`.
- **Variants:** `BridgeVariants.lean`, with `bridge-variants.out`, compiles the variants of findings 2, 4, 5 and 6, each with an empty report.
- **Central declarations:** `Central.lean`, `central.txt` and `central-new.out`.
- **Consumers:** `Consumers.lean`, with `consumers-*.out`.
- `round1-old-base/` holds the first round, against `5956c2cff`.

To rerun a check:
1. From the package folder, run `python3 -B scratch_build.py TREE Becoming.Identity Becoming.MapInstances` (or `Becoming` for `Central.lean`).
2. Run `LEAN_PATH=TREE/.build lean FILE` with the toolchain's Lean, v4.29.1.

## Verdict

Ready to land once findings 1–4 are taken:
- 1 and 2 are corrections of text;
- 3 replaces a vacuous landing check;
- 4 is two more derivations in Identity, or a corrected reason in the design and the audit.

The rest are nits. The six derivations are genuine, the statements are unchanged, the reports are empty, and nothing downstream breaks.

## Second pass (branch `ou3f-laws` at `3a4c922b6`)

Read-only, like the first. It covers:
- the tree regenerated by `kit/edit_tree.py` (`1b1c204ab`);
- the rewritten [DESIGN.md](../DESIGN.md) and the audit's note *After the lineage review*;
- the kit, with the rehearsal's logs (`3a4c922b6`).

The tree's base is main's Identity and MapInstances. They are unchanged on main through `0471d3343`, where UE16 has landed; UE16's module does not import Identity. The checks are in [checks/second/](checks/second/).

**Verdict: ready to land after two small fixes (1 and 2).** The Lean needs nothing, and the kit's checks are sound. Items 3–8 are nits.

### Findings

1. **should fix: the audit's note gives a wrong count.**
   - The claim: [AUDIT.md](../../AUDIT.md):227 says that with `Lineage.cons` retired, "the theorems reading only activity on main number one fewer than this audit's 436".
   - Why it is wrong: the twins' part (§443) already retired three of the 436, `Continuing.mono_by_reach`, `ByPassing.passes_within_by_line` and `ByPassing.begins_passed_by_grammar`. All three are rows of [TABLE.md](../../TABLE.md) and of `data/active-only.json`. Later landings may also have added theorems that read only activity.
   - Fix: say that `Lineage.cons`, one of the audit's 436, is retired, and give no running total.
   - Also :233: of "the three that follow", `lineage_iff_line` is a (c) representation. It reaches the grammar through `line` and `line_lineage`, with its standing unchanged; it is not an "(a), follows" row like `ends` and `lineages_apart`.

2. **should fix: a superseded check is still in the kit.**
   - `kit/dump_check_lineage.py` is the old dump-based check of finding 3. The design no longer names it, and no file refers to it.
   - It cannot see `Nat.brecOn`, it checks only the six, and its docstring still says `Lineage.cons`, `Lineage.line` and `line_lineage` "stay" and keep their inductions.
   - Fix: move it to `history/` with `research.py move`, or delete it, so that a landing session cannot run it in place of `deps_lineage.py`.

3. **nit: `deps_lineage.py`'s docstring** (:7) says that on main every one of the eight carries `Nat.brecOn`. Seven do; `line_lineage` carries `«及».rec`, as DESIGN.md:56 and the control log say.

4. **nit: `records_lineage.py`** (:85) writes "two with a second pass". With this pass there are three: OU3d's, the closure's and this one.

5. **nit: counts on the landing's base.** On main after UE16 (346 modules, as the rehearsal says), 323 modules import GrammarLaws, so a change to it rebuilds 324 of 346. DESIGN.md:84 and `kit/study_lineage.txt`:47 give 322 importers and 323 of 345, which held at `ffdbeea47`. Identity's cone is still 20.

6. **nit: wording in the tree.**
   - Identity.lean:995: "where steps back begin". `back`'s docstring now says the steps back, read forward, start at `M`; say "where steps back end", or "start, read forward".
   - :2233 and :2447: "stays within activity onward from its start, a region closed under its steps". This makes a relation the region. The region is the one DESIGN.md:46 states: active, at or after the start, and within the closure of activity onward from the start.

7. **nit: wording in the design and the kit.**
   - DESIGN.md:35: "Every statement and name is unchanged". `Lineage.cons` is gone; say "every derived theorem keeps its statement and name".
   - :62: the inductions left now include `lineage_of_steps`'s; the bridge's induction is split between it and the converse.
   - :75: `onward` uses `steps_advance` too.
   - `kit/texts_lineage.py`'s text for 01 §7 still reads "(`Web.Lineage.onward`, `Web.Lineage.back`, from `«或有后则或迭»` with `«迭之逆»`)", tying `«迭之逆»` to both. Identity's header now ties it to `back` alone.

8. **nit, process: the rehearsal commit swept in work in progress.**
   - Commit `3a4c922b6` took in `checks/second/` while this pass was running, including the two `pp.all` dumps, 0.9 MB each.
   - As in round 1, the dumps are not kept. Running `Dump.lean` regenerates them, and their sha256 is in `checks/second/dump-compare.out`. They are deleted in the working tree, so commit the deletion with this section.

### The four questions

**(a) Every remaining statement prints identically.**
- The 240 declarations that main and the tree share print the same:
  - by `#check @`: `second/signatures-{main,new}.out`, 777 lines each, `diff` empty;
  - by `#check` with hypothesis names: `second/binders-{main,new}.out`, 737 lines each, `diff` empty.
- `Lineage.cons` is present on main and absent in the tree; `activityFrom` is absent from both (`second/cons-gone-*.out`).
- The checker's scanner lists only these differences: `Lineage.cons` gone, and four additions (`activityOnward` as a definition; `lineage_of_steps`, `steps_iff_lineage` and `steps_start_active` as theorems). `steps_advance` moves to Identity, and no declaration changes kind. The four new statements are in `second/added-new.out`.
- The `pp.all` dump goes from 757 constants to 772 (`second/dump-compare.out`):
  - gone: `cons` and its matcher, and one matcher of `onward`;
  - added: the four declarations and compiler-made matchers;
  - changed: only matcher types.
  - Main's dump is byte-identical to round 1's.
- The rehearsal's signature audit (`kit/signatures-rehearsal.log`) says the same.

**(b) The docstrings and the header bullet claim nothing beyond the Lean.** Each was read against the statement it describes:
- "at most one formation";
- `origin`'s "start from one";
- `split`'s middle point placed by `steps_advance`;
- `through`'s step from `M + k`;
- `back`'s steps, read forward, starting at `M`;
- `lineage_of_steps` using no bound;
- the bridge's bound serving the converse;
- `activityOnward` relating nothing from an occurrence before `N` or from an inactive one;
- the readings of a lineage as a line, both ways;
- `«迭之逆»` tied to `back` alone.

`Lineage.line` and `line_lineage` keep their original binder form; `line_lineage` still has `W.active x.1 x.2 →` after the colon. The census law has its own heading. Finding 6's two nits are wording, not claims.

**(c) Retiring `cons` is sound.**
- Nothing uses it:
  - no module of the package uses it, and no other Lean file in the repository does, outside superseded trees (`ou3-lifting`) and old receipts;
  - no record, chapter, COVERAGE entry or apart-register entry names it;
  - the generated files that list it (`THEOREM-CONNECTIVITY.json`, the receipt) are regenerated at landing.
- Nothing is lost. Its content is the bridge read at one more first step, four lines from the bridge (`cons_v4` in round 1).
- Nothing is left behind:
  - in the two modules, no declaration loses its last consumer (`second/consumers-new.out` against round 1's main);
  - the rehearsal's connectivity check finds no apart root without a reason, and names only the four register entries the design drops.
- The signature audit expects exactly this removal, and the twins' part (§443) retired names the same way.

**(d) The rest of the design and the kit.**
- **Derivations** (`second/Deps.lean`).
  - In the tree, none of the eight carries an induction mark, and each reaches its law: `Lineage.line` reaches `«迭则及»` and `«及之单调»`, and `line_lineage` reaches `«闭之及»` and `«及即迭»`. `lineage_iff_line`, `ends` and `lineages_apart` reach theirs.
  - On main, seven carry `Nat.brecOn` and `line_lineage` carries `«及».rec`.
  - Only `lineage_of_steps`, the bridge's converse and `steps_advance` keep an induction, while `steps_start_active` has none.
  - `kit/deps-tree.log` agrees. The control, `kit/deps-main-control.log`, fails as it must: exit 1, all eleven unexpected.
- **The kit.**
  - `edit_tree.py`, run on copies of main's bytes, reproduces the tree byte for byte (`second/kit-repro.out`).
  - `signatures_lineage.py`'s expected sets are exact.
  - `records_lineage.py` binds `steps_advance` under Identity.
  - `integrate_lineage.py` checks `BASE.sha256` before copying.
  - `register_lineage.py`'s four entries are the four the rehearsal's connectivity check names.
- **Builds.**
  - The scratch builds give Identity 152 theorems in 217 declarations and MapInstances 27 in 27, every axiom report empty, as `scratch-5.log` does (`second/scratch-new.log`).
  - A fresh compile of both modules, outside the cache, is clean.
  - The whole package builds clean with the tree: the root compiled and the 344 other modules were reused, all passed (`second/scratch-downstream.log`).
  - The rehearsal on main, with 346 modules, passed.

### Verdict (second pass)

Ready to land once findings 1 and 2 are fixed: one sentence of the audit's note, and one superseded script out of the kit. The Lean is right as it stands. The remaining statements print unchanged, the eight derivations are genuine, retiring `cons` loses nothing, and the landing's dependency check can fail and does fail on main.
