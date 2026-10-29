# OU3f, derivations: the lineage laws, through the grammar's steps

AI-written design for the next part of board item OU3f's derivations, 29 October 2026. It was begun on main at `5956c2cff`, after the closure (study §445) and WRP2 (§447), and rebuilt after the review on main at `ffdbeea47`, with GW3–GW5 (`4edb05c1f`, §448) merged.

[The audit](../AUDIT.md) found six lineage laws of `Becoming.Identity` to be cases of grammar laws:
- two through a restricted bridge to the grammar's steps (*Two lineage laws through a restricted bridge*): `Lineage.unique` and `Lineage.origin`;
- four needing laws of steps the grammar lacked, B1 and B2: `Lineage.split`, `through`, `onward` and `back`. Those laws landed in §442 ([design](../laws/DESIGN.md)).

The review of this part found two more cases through the same bridge: `Lineage.line` and `line_lineage`, representations of a lineage as a line. `Lineage.ends`, `lineages_apart` and `lineage_iff_line` apply these and follow. Everything here is in Identity, apart from one lemma that moves out of MapInstances ([tree](tree/Becoming/)).

## The bridge

`Web.Lineage R M g k h` is `k` steps of the continuation `R` from `g` at step `M`, taken last step last, each between formations active at its two ends. The grammar's steps (`«迭»`) take the first step first.

The bridge reads a lineage as the grammar's steps of `«续» (continuationStep R) (W.activityOnward N)`: one step of the continuation (缘) between occurrences alike in activity, from an active occurrence at or after `N`.

| declaration | what it is |
|---|---|
| `Web.activityOnward` (new definition) | `W.activityClass x y ∧ N ≤ x.1 ∧ W.active x.1 x.2`. This is activity onward from step `N`: two occurrences alike in activity, the first active at a step from `N` on. It is not a class, since it relates nothing from an occurrence before `N` or from an inactive one. Its docstring says so. |
| `Web.lineage_of_steps` (new theorem) | Read forward, steps are a lineage: `k` steps within activity onward from any `N`, from `(M, g)`, end at a formation the lineage of `g` from `M` reaches. No bound on `N` is used. Its own induction through `«迭之末步»`, with the index from `steps_advance`. |
| `Web.steps_iff_lineage` (new theorem) | For `N ≤ M` and every `k`, `0` included: `«迭» («续» (continuationStep R) (W.activityOnward N)) k (M, g) y ↔ y.1 = M + k ∧ W.Lineage R M g k y.2`. The forward direction is `steps_advance` with `lineage_of_steps`. The converse is its own induction through `«迭之末步»`, and it is where the bound is used: a lineage's steps start at `M`. |
| `Web.steps_start_active` (new theorem) | Steps within activity onward from `N` start at an active occurrence where they end at one. It has two cases and no induction. |
| `Web.steps_advance` (moved from MapInstances, unchanged) | `k` steps of a continuation under `continuationStep R`, with any relation in the class position, advance the step index by `k`. |

What each part of the bridge's form is for:
- **The restriction.** The bridge is restricted to sources at or after `N` and active, as the audit's review required: the unrestricted reading was false at `k = 0` and did not give `origin`. Within the restriction, "no split from `M` on" is the relation's fixed successor and "no merge from `M` on" is its merging nothing.
- **The endpoint's step** (`y.1 = M + k`) saves rewrites; it is not needed. `steps_advance` gives the step of any occurrence the steps reach, the middle of split steps included, as the second review's note on the laws of steps said. The review compiled `split` from a bridge with a fixed endpoint (`split_v3`). The audit's line saying the conjunct is needed is corrected in its note *After the lineage review*.
- **The bound.** The generality in `N` serves the forward reading, which needs no bound: the second part of a lineage split at `j` has steps within activity onward from `M` and starts at `M + j`. The bound serves the converse.
- **The class position.** The restriction sits in the class position of `«续»`, so the relation is a continuation in the grammar's own form, and `steps_advance` applies to it.

The bridge is a representation: its content is the correspondence, like OU3a's `lineage_iff_line`.

## The derivations

Every statement and name is unchanged. Each docstring gains a clause naming the law. In what follows, *within activity onward from `M`* means the continuation step within `W.activityOnward M`.

| theorem | the law | the old proof's induction, replaced |
|---|---|---|
| `Lineage.unique` | `«迭之定»`: with a fixed successor, `n` steps lead to one occurrence | On `k`, applying no-split at each step. No split from `M` on is now the fixed successor within activity onward from `M` (`«定后之逐点»`), shown once. |
| `Lineage.origin` | `«迭之定前»`: merging nothing, `n` steps to one occurrence come from one | On `k`, applying no-merge at each step. No merge from `M` on is now merging nothing within activity onward from `M` (`«定前之逐点»`). |
| `Lineage.split` | `«迭之分»` (B1): `b + a` steps are `a` steps and then `b` | On `i`, peeling the last steps and re-indexing them. Now the `j + i` steps split at `j`, and the forward reading gives both parts as lineages, the second from step `M + j` (`steps_advance`). |
| `Lineage.through` | `«迭之分»`, through `split` | On `i`. Now it is `split` at `k + 1`, the definition's last step being the step from `M + k`. |
| `Lineage.onward` | `«或有后则或迭»` (B2 bounded) | On `k`, extending by one step where nothing ceases. Now each occurrence the steps reach is active and lies at or after `N`, so the premise gives a successor as far as can be refuted, and B2 gives `k` steps as far as can be refuted. |
| `Lineage.back` | `«或有后则或迭»` on the converse, through `«迭之逆»` | On `k`, stepping back where nothing arises. Now each occurrence fewer than `k` steps back lies after `M`, by `steps_advance` and the bound `j < k`, and is active, so the premise gives a predecessor as far as can be refuted. B2 on the converse gives `k` steps back as far as can be refuted; read forward, they start at step `M`, where the covering list holds their start. |
| `Lineage.line` (representation, found by the review) | `«迭则及»`: `n + 1` steps reach; with `«及之单调»` | On `k`, extending the line one step at a time (`«及之传递»`). Now the bridge reads the lineage as `k + 1` steps within activity onward from `M`, `«迭则及»` makes them a reach, the inclusion in activity drops the restriction, and the first step's source is active. |
| `line_lineage` (representation, found by the review) | `«闭之及»`: a closed region holds what is reached; with `«及即迭»` | On the line, extending the lineage at its front with `Lineage.cons`. Now a region closed under the line's steps (active, at or after the start, within the closure of activity onward from the start) holds what the line reaches, `«所闭当且仅当同一或及»` with `line_advances` leaves a reach, `«及即迭»` counts its steps, and the bridge reads them. |

`Lineage.ends` applies `through` and `unique`, `lineages_apart` applies `split` and `origin`, and `lineage_iff_line` assembles `line` and `line_lineage`. Each reaches the grammar unchanged.

`Lineage.line` and `line_lineage` keep their standing as representations, as `ByPassing.line_back` did when the closure part proved it by closure; only their proofs change.

**`Lineage.cons` retires.** It put a first step onto a lineage, and its one consumer was `line_lineage`'s old induction. It is the bridge read at one more first step, with only `«迭»`'s definition between (the review's `cons_v4`), so it states no law of its own. No module and no record names it.

**The PartForms test** is the one from OU3d's second review: a derivation replaces part of the old proof by the law. Each of the eight old proofs was its own induction:
- `Nat.brecOn` for seven;
- `«及».rec` for `line_lineage`.

Each new proof has none. The grammar law's induction replaces the old one, and what remains is one step's argument together with readings through the bridge:
- no split, no merge, nothing ceasing or nothing arising;
- for `line_lineage`, the region's closure under one step.

The inductions left are the bridge's (the correspondence), `steps_advance`'s (the index) and the laws' own.

The landing checks this mechanically with `kit/deps_lineage.py`, the review's dependency check adapted (`kit/deps-tree.log`). For each proof it reads the constants used, with the compiler's matchers unfolded:
- on the tree, none of the eight carries an induction mark, and each reaches its named law;
- on main, each carries one and reaches none (`kit/deps-main-control.log`).

The connectivity dump cannot do this, since it leaves out `Init`'s constants, `Nat.brecOn` among them.

## What moves, and why

- **`continuationStep` and `occurrence_eq` move up within Identity.** They go from the start of the grammar section at the end of the module to the bridge, right after `def Lineage`. The bridge must come before the lineage laws, and those come before the grammar section. Names, statements and docstrings are unchanged.
  - The grammar section's text says where they now stand.
  - It names `steps_advance` beside `reach_advances`, and the laws giving `Lineage.line` and `line_lineage`.
- **`steps_advance` moves from MapInstances into Identity.** `back` needs it, since its steps back start where it is not given, and so do the forward reading and `split`. It reads only `continuationStep`, which Identity defines. Its name and statement are unchanged, and MapInstances' `reaches_onward`, its one other use, takes it from Identity. GW3–GW5, the last change to MapInstances (`2ce13d0d1`), touched another place.
- **`split` moves up,** from the converse's subsection to just after `unique`, since `through` is now its case.

Identity's header gains a bullet, *Lineages on the grammar*. The covering-list section gains a doc section on the bridge, and a heading of its own before the census law (`ceasingFrom_found` on).

## Not in this part

- **`Lineage.active`** stays a representation with two cases.
- **The coarse-to-fine pair** (Persistence) is the next part.
- **GrammarLaws' module doc.** It says, under *What is not shown*, that the lineage laws following from the laws of steps "is board item OU3f's next part". Its sentence "Three of the models' step-indexed laws are proved from the laws of steps counted…" also leaves out the lineage laws once they land. Correcting either touches GrammarLaws, which 322 modules import, so a rebuild of 323 of the package's 345 modules, against 20 for Identity's change.
  - The coordinating session decided: this landing stays narrow, and both corrections go to board item HE, the one near-full rebuild that carries every edit held for a rebuild (item 2, with `kept_onward`'s move as item 3).
  - Until HE lands, OU3f's board row says GrammarLaws' module doc lags. The records this landing changes say what holds: `master-laws-on-the-grammar` drops its does-not-show item on the lineage laws.

## Scratch build

[scratch-5.log](scratch-5.log), with Identity and MapInstances and their closure of 41 modules on main with GW3–GW5, gives every axiom report empty and no warnings:
- **`Becoming.Identity`:** 152 theorems in 217 declarations, as on main (149 in 213).
  - Four theorems are new or moved in: `lineage_of_steps`, `steps_iff_lineage` and `steps_start_active` new, `steps_advance` moved in.
  - One retires: `Lineage.cons`.
  - One definition is new: `activityOnward`.
- **`Becoming.MapInstances`:** 27 theorems in 27 declarations, against 28 in 28; `steps_advance` moved out.

The review built the whole package with the second draft's tree, 345 modules, clean. The landing's rehearsal builds it with this one.

## Owners

Identity was last changed by OU2 and OU3a (`46a72f71f`, 23 October), and no active session holds it, so rule 3's fallback applies, as for the closure's modules. MapInstances was last changed by GW3–GW5, which has landed.

## Landing

Queued after UE16 and UE17, behind any earlier clause, after a rehearsal on main outside the repository.
- **Rebuild.** It covers Identity's cone, 19 modules and Identity, MapInstances among them.
- **Signatures.**
  - Every remaining statement of Identity and MapInstances prints unchanged.
  - Identity adds three theorems (`lineage_of_steps`, `steps_iff_lineage`, `steps_start_active`) and one definition (`activityOnward`), and `Lineage.cons` is gone. `steps_advance` moves from MapInstances to Identity with its statement unchanged.
  - Nothing else is gone or added.
- **The dependency check** (`deps_lineage.py`) on the rehearsal's build: the eight with no induction of their own, each reaching its law.
- **Connectivity register.** It drops «或有后则或迭», «迭之分» and «迭之逆», registered with the laws of steps for the lineage laws to use. Nothing becomes a root.
- **Records.**
  - `master-laws-on-the-grammar` takes the eight into its last group. It gets an Identity reference and binding: the bridge, `steps_advance` moved there, and the eight. Its MapInstances reference drops `steps_advance`, and its does-not-show item on the lineage laws goes.
  - `census-balance-under-continuation`, whose laws 10 and 11 rest on these lemmas, is re-pointed only.
- **The measure** cannot change: no declaration in COVERAGE depends on these laws (the review's `Central.lean`). It is rerun anyway, and MV's generator runs after the receipt; MV's view may move, since laws 10 and 11 now reach the laws of steps.
- **A study section,** 01 §7, the root module's bullets, 08's counts, the board rows (OU3f's, HE's item 2 widened) and the audit's note.

## The review, and what was taken

One independent read-only review by a separate AI agent ([REVIEW-LINEAGE](review/REVIEW-LINEAGE.md), its compiled checks in `review/checks/`).
- **What it confirmed.**
  - The Lean is right, and all 241 existing declarations print identically: by `#check @`, with hypothesis names, and in a `pp.all` dump of every constant.
  - Each of the six inductions is replaced by its named law's.
  - The bridge is correct for every `k`, and every part of its restriction is used.
  - The whole package builds clean with the tree.
- **Verdict:** ready after findings 1–4.

Every finding was taken.
1. **"Reaches one formation" claimed more than `Lineage.unique` shows.** Now "at most one", in the header and the doc section.
2. **The endpoint's step is not needed.** `steps_advance` reads the middle of split steps. The design says so, and the audit's note corrects its line.
3. **The landing's test for "no induction of its own" could not fail.** Lean compiles structural recursion to `Nat.brecOn`, which the connectivity dump leaves out. The landing uses the review's dependency check instead, with a control on main.
4. **`Lineage.line` and `line_lineage` are cases through the bridge,** of `«迭则及»` and of `«闭之及»` with `«及即迭»`, both compiled by the review. They are derived here, their standing unchanged, and `Lineage.cons`, left with no consumer, retires.
5. **The bridge's index re-proved `steps_advance`.** It now takes it from there.
6. **The bound serves only the converse.** A forward lemma with no bound, `lineage_of_steps`, now serves `split`, `onward` and `back`.
7. **The name `activityFrom` could be read as a reading under a continuation,** like `ArisesFrom`, and its docstring overstated what it excludes. It is now `activityOnward`, with the docstring corrected.
8. **Wording.**
   - `through`'s step is from `M + k`.
   - `back`'s steps, read forward, start at `M`.
   - "cases of" the laws of steps.
   - `«迭之逆»` is tied to `back` alone.
   - The grammar section's paragraph is reflowed.
   - `steps_advance` is stated for any relation in the class position.
9. **The bridge's heading covered the census law.** The census law now has its own heading.
10. **The design was stale after GW merged.** Counts, owners, 323 of 345, and the record's binding of `steps_advance` under Identity are now right.

On the open question, the review held the GrammarLaws correction for HE, with three conditions, all taken:
- this design records the decision;
- HE's item 2 covers the "Three of the models' step-indexed laws" sentence too;
- the board row says GrammarLaws' doc lags until HE.
