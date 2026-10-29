# OU3f, derivations: the lineage laws, through the grammar's steps

AI-written design for the next part of board item OU3f's derivations, 29 October 2026. Main was at `5956c2cff`, after the closure (study §445) and WRP2 (§447), with GW3–GW5 holding the head.

[The audit](../AUDIT.md) found six lineage laws of `Becoming.Identity` to be cases of grammar laws:
- two through a restricted bridge to the grammar's steps (*Two lineage laws through a restricted bridge*): `Lineage.unique` and `Lineage.origin`;
- four needing the laws of steps the grammar lacked, B1 and B2: `Lineage.split`, `through`, `onward` and `back`. Those laws landed in §442 ([design](../laws/DESIGN.md)).

Two more theorems apply these and follow: `Lineage.ends` and `lineages_apart`. Everything here is in Identity, apart from one lemma that moves out of MapInstances ([tree](tree/Becoming/)).

## The bridge

`Web.Lineage R M g k h` is `k` steps of the continuation `R` from `g` at step `M`, taken last step last, each between formations active at its two ends. The grammar's steps (`«迭»`) take the first step first.

The bridge reads a lineage as the grammar's steps of `«续» (continuationStep R) (W.activityFrom N)`: one step of the continuation (缘) between occurrences alike in activity, from an active occurrence at or after `N`.

| declaration | what it is |
|---|---|
| `Web.activityFrom` (new definition) | `W.activityClass x y ∧ N ≤ x.1 ∧ W.active x.1 x.2`. This is activity from step `N` on: two occurrences alike in activity, the first active at a step from `N` on. It is not a class, since it relates nothing before `N` and nothing inactive; its docstring says so. |
| `Web.steps_iff_lineage` (new theorem) | For `N ≤ M` and every `k`, `0` included: `«迭» («续» (continuationStep R) (W.activityFrom N)) k (M, g) y ↔ y.1 = M + k ∧ W.Lineage R M g k y.2`. The proof is its own induction through `«迭之末步»`. |
| `Web.steps_start_active` (new theorem) | Steps within activity from `N` start at an active occurrence where they end at one. |
| `Web.steps_advance` (moved from MapInstances, unchanged) | `k` steps of a continuation under `continuationStep R`, within any class, advance the step index by `k`. |

Its form answers the audit and the reviews.
- **Restricted.** It is restricted to sources at or after `N` and active, as the audit's review required: the unrestricted reading was false at `k = 0` and did not give `origin`. Within the restriction, "no split from `M` on" is the relation's fixed successor and "no merge from `M` on" is its merging nothing.
- **It fixes the endpoint's step** (`y.1 = M + k`), as the audit said B1 needs. Otherwise the middle occurrence of split steps cannot be read back as a lineage from `M + j`.
- **The bound is any `N ≤ M`.** The second part of a lineage split at `j` is a lineage from `M + j` whose steps are still within activity from `M`.
- **The restriction sits in the class position of `«续»`.** The relation is a continuation in the grammar's own form (the second review's note), so `steps_advance`, stated for every class, applies to it.

The review's compiled bridge, `OU3fLawsCheck.lineage_iff_steps`, fixed the endpoint itself. The first draft here took that form (`scratch-1.log`, `scratch-2.log`), and every use then re-indexed the steps by `Eq.subst`. Reading the endpoint as a step and a formation removes those rewrites.

The bridge is a representation: its content is the correspondence, like OU3a's `lineage_iff_line`, a lineage of `k + 1` steps as a line, which stays.

## The derivations

Every statement and name is unchanged. Each docstring gains a clause naming the law. In what follows, *within activity from `M`* means the continuation step within `W.activityFrom M`.

| theorem | the law | the old proof's induction, replaced |
|---|---|---|
| `Lineage.unique` | `«迭之定»`: with a fixed successor, `n` steps lead to one occurrence | on `k`, applying no-split at each step. No split from `M` on is now the fixed successor within activity from `M` (`«定后之逐点»`), shown once. |
| `Lineage.origin` | `«迭之定前»`: merging nothing, `n` steps to one occurrence come from one | on `k`, applying no-merge at each step. No merge from `M` on is now merging nothing within activity from `M` (`«定前之逐点»`). |
| `Lineage.split` | `«迭之分»` (B1): `b + a` steps are `a` steps and then `b` | on `i`, peeling the last steps and re-indexing them. Now the `j + i` steps split at `j`; the bridge reads the first part as a lineage ending at step `M + j`, and the second as a lineage from there. |
| `Lineage.through` | `«迭之分»`, through `split` | on `i`. Now it is `split` at `k + 1`, and the definition's last step is the step from `k`. |
| `Lineage.onward` | `«或有后则或迭»` (B2 bounded) | on `k`, extending by one step where nothing ceases. Now each occurrence the steps reach is active and lies at or after `N`, so the premise gives a successor as far as can be refuted, and B2 gives `k` steps as far as can be refuted. |
| `Lineage.back` | `«或有后则或迭»` on the converse, through `«迭之逆»` | on `k`, stepping back where nothing arises. Now each occurrence fewer than `k` steps back lies after `M`, by `steps_advance` and the bound `j < k`, and is active. So the premise gives a predecessor as far as can be refuted, and B2 on the converse gives `k` steps back as far as can be refuted. They begin at step `M`, where the covering list holds their start. |

`Lineage.ends` applies `through` and `unique`, and `lineages_apart` applies `split` and `origin`. Each reaches the grammar unchanged.

**The PartForms test** is the one from OU3d's second review: a derivation replaces part of the old proof by the law. Each of the six old proofs was an induction on the step count whose successor case carried the lineage one step; for `through`, it peeled steps until it reached the `k`-th. Each new proof has no induction of its own. The grammar law's induction replaces the old one, and what remains is one step's argument (no split, no merge, nothing ceasing, nothing arising) together with readings through the bridge. The inductions left in the new proofs are the bridge's (the correspondence), `steps_advance`'s (the index) and the laws' own.

## What moves, and why

- **`continuationStep` and `occurrence_eq` move up within Identity.** They go from the start of the grammar section at the end of the module to the bridge, right after `def Lineage`. The bridge must come before the lineage laws, and those come before the grammar section. Names, statements and docstrings are unchanged. The grammar section's text says where they now stand and names `steps_advance` and the bridge beside `reach_advances` and `lineage_iff_line`.
- **`steps_advance` moves from MapInstances into Identity.** `back` needs it, since its steps back start where it is not given. It reads only `continuationStep`, which Identity defines. Its name and statement are unchanged, and MapInstances' `reaches_onward`, its one other use, takes it from Identity. MapInstances' docstrings name it unchanged. GW3–GW5 changes MapInstances in another place, `itself`'s laws, and lands first.
- **`split` moves up,** from the converse's subsection to just after `unique`, since `through` is now its case.

Identity's header gains a bullet, *Lineages on the grammar*. The covering-list subsection gains a short doc section saying what the bridge is and which law gives each lineage law.

## Not in this part

- **`Lineage.cons`, `Lineage.line`, `line_lineage` and `lineage_iff_line`** stay as they are: representation, per the audit, (c) rep.
  - `cons`'s induction is the bridge's own.
  - `Lineage.line`'s forward half could be read through `steps_iff_lineage`, with `«迭则及»` and the inclusion of activity from `M` in activity. But it is a correspondence, not a law to derive, and `line_lineage` would still need its own induction.
- **`Lineage.active`** stays (c) rep.
- **The coarse-to-fine pair** (Persistence) is the next part.
- **GrammarLaws' module doc** still says, under *What is not shown*, that the lineage laws following from the laws of steps "is board item OU3f's next part". Correcting it touches GrammarLaws, which 323 of the package's 343 modules import, against 19 for Identity. The coordinating session is asked whether it waits for the next full rebuild, with `kept_onward`'s move into GrammarLaws (its home, closure design condition 3), or goes into this landing. Its decision is recorded here.

## Scratch build

[scratch-3.log](scratch-3.log), with Identity and MapInstances and their closure of 41 modules, gives every axiom report empty and no warnings:
- `Becoming.Identity`: 152 theorems in 217 declarations, against 149 in 213 on main.
  - Three theorems: `steps_iff_lineage` and `steps_start_active`, which are new, and `steps_advance`, which moved in.
  - One definition: `activityFrom`.
- `Becoming.MapInstances`: 25 theorems in 25 declarations, against 26 in 26; `steps_advance` moved out.

So the package gains two theorems and one definition.

## Owners

Identity was last changed by OU2 and OU3a (`46a72f71f`, 23 October), and no active session holds it, so rule 3's fallback applies, as for the closure's modules. MapInstances was last changed by OU3f's laws of steps (this item, §442), and GW3–GW5 is changing it now in another place.

## Landing

Queued after GW3–GW5, behind any earlier clause, after a rehearsal on main with GW merged.
- **Rebuild.** It covers Identity's cone, 19 modules and Identity, MapInstances among them.
- **Signatures.**
  - Every statement of Identity and MapInstances prints unchanged.
  - Two theorems are added to Identity (`steps_iff_lineage`, `steps_start_active`), one definition is added (`activityFrom`), and `steps_advance` moves from MapInstances to Identity with its statement unchanged.
  - Nothing else is gone or added.
- **The dependency dump** of the rehearsal's run is checked mechanically. Each of the six reaches the law named above, and none refers to itself (no induction of its own).
- **Connectivity register.** `steps_iff_lineage` and `steps_start_active` have consumers; nothing becomes a root.
- **Records.**
  - `master-laws-on-the-grammar` takes the six into its last group, with an Identity reference and binding (the bridge and the six). Its MapInstances reference drops `steps_advance`, and its does-not-show item on the lineage laws is dropped.
  - `census-balance-under-continuation`, which states laws 10 and 11 on these lemmas, is re-pointed only.
- **The measure** is rerun, and MV's generator after the receipt. No central declaration names these laws.
- **A study section,** the board row, and the audit's *What follows*.

## The review, and what was taken

One independent read-only review comes next.
