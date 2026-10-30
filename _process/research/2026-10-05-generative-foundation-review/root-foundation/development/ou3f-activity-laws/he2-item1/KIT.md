# HE2's item 1: «两端分则中有标» on transitivity, and Sampling's search read from it

*AI-written kit, 31 October 2026, by OU3f's owner, for whoever lands HE2's rebuild (the board's HE2 row, item 1; WHAT-REMAINS, "After OU3f", item 2). Checked outside the package; nothing here is package Lean yet. Base: main `2f4a5bd96`; the four modules it reads are unchanged on main through `c05f4eab8`.*

«两端分则中有标» was stated with `K` a class, though its proof uses only transitivity. Asking only for transitivity admits a relation that is not a class: that a property does not arise from one end of a line to the other. On the successor line, that relation turns Sampling's search for the step where a decided property arises into an application of the law.

## The edits

1. **Grammar, «两端分则中有标».**
   - **Hypotheses:** `split`, then `trans : ∀ {a b c}, K a b → K b c → K a c`, in place of `hK : «类» K` before `split`. The proof changes in one place, `hK.trans k k'` → `trans k k'`.
   - **Docstring:** it now says "a transitive relation", and that `K` need only compose, as a class does and as a property's not arising does. It names no module, so it reads true with or without edit 3.
   - **Why `split` now comes first.** With `trans` first, a caller passing a projection such as `(carrierClass_class V).trans` gets `K` solved as a constant function. The projection's points are created inside the binder that the expected type's implicit `∀` opens, so the higher-order pattern takes the constant solution. `split`'s type fixes `K` from its bound variables. The first scratch build failed this way; the reordered law builds.
2. **PatternPassing**, in `ByPassing.passes_within` and `ByPassing.ends_within`:
   - before: `«两端分则中有标» (carrierClass_class V) split line apart`
   - after: `«两端分则中有标» split (carrierClass_class V).trans line apart`

   Statements unchanged.
3. **Sampling.** Statements unchanged.
   - **`arises_within`:** along the successor, `K x y := ¬ (¬ p x ∧ p y)`, the property's not arising from `x` to `y`.
     - It composes with no decision.
     - The split is excluded middle on whether the property arises across a step, the one use of the given decidability.
     - The line from `T` to `t` comes from item 5's `Map.step_reach_of_le`, and the places the law returns go back to order by item 5's `Map.step_reached_le`.
   - **`ceases_within`:** `arises_within` at the property's negation (its failing arises), the given decidability turning `¬¬ p u` into `p u`.

**Apply** with [kit/apply_he2_item1.py](kit/apply_he2_item1.py) `PACKAGE`.
- Each edit is found by the text it replaces and must occur as often as stated; nothing is written unless every edit applies, and an edit already applied is reported and left.
- `--check` writes nothing.
- Edit 3 reads item 5's two laws, so the script refuses it until GrammarMap has them. `--weakening-only` applies edits 1 and 2 alone.
- The whole change as a diff: [kit/he2-item1.diff](kit/he2-item1.diff).

## The checks

Rerun with [checks/run_checks.sh](checks/run_checks.sh), from the worktree root, at the base. [checks/make_tree.py](checks/make_tree.py) makes the tree:
1. It copies the four modules, refusing unless they match [tree/BASE.sha256](tree/BASE.sha256).
2. It puts item 5's three laws into GrammarMap as item 5's kit states them. That is a stand-in for this check only: no module built here imports MapRegions, which still holds `Map.step_reached_le` until item 5 moves it.
3. It applies item 1 with the kit's own script, so the tree is what the kit writes.

| Check | Result |
|---|---|
| Build ([scratch-build.log](scratch-build.log)) | 33 modules compiled, none unclean. Every axiom report empty: Sampling 117 declarations, PatternPassing 46, the check module 3. |
| Statements ([tree/Becoming/HE2Item1Check.lean](tree/Becoming/HE2Item1Check.lean)) | The law's earlier form, `K` a class, is the new law at the class's `trans` (`of_class`). Sampling's earlier statements, written out, are the new theorems (`arises_within_stated`, `ceases_within_stated`). |
| Genuine ([checks/HE2Item1Reach.lean.txt](checks/HE2Item1Reach.lean.txt); [main](checks/reach-main.txt), [tree](checks/reach-new.txt)) | On main, both proofs search by their own recursion (`Nat.le.brecOn`) and use no grammar law. In the tree, neither recurses: `arises_within` uses «两端分则中有标», `Map.step_reach_of_le` and `Map.step_reached_le`; `ceases_within` uses `arises_within`. The law is applied once; nothing is applied and undone. Sampling's four coarse-step theorems (`Web.sample_arises`, `sample_ceases`, `sample_unceasing`, `sample_ceasing`) reach «两端分则中有标» in the tree, and none does on main. |
| The weakening alone ([checks/scratch-weakening.log](checks/scratch-weakening.log)) | Edits 1 and 2 with nothing of item 5: PatternPassing builds over the weakened law, with Sampling's earlier proofs untouched. Every axiom report empty. |
| Length ([checks/measure.py](checks/measure.py), [output](checks/measure.out)) | See the table below. |

**Length**, the proofs after the statements, docstrings not counted:

| | lines | characters | symbols |
|---|---|---|---|
| `arises_within` | 5 → 7 | 257 → 346 | 90 → 144 |
| `ceases_within` | 5 → 2 | 249 → 141 | 90 → 53 |
| both | 10 → 9 | 506 → 487 | 180 → 197 |

So "no longer" holds for the pair in lines and characters, but not in symbols (9% more), and not for `arises_within` alone.
- **Where the length goes.** The old search was a five-line recursion that named nothing. The derivation names:
  - the relation that composes;
  - its composition;
  - the one decided split;

  and it turns order into the line and back with item 5's laws.
- **What it buys.** The search is stated once, in the grammar, for every carrier, and ceasing is the arising of the failure.

**Recommended:** take edits 1 to 3 together. If HE2 holds to "no longer" in every measure, take edits 1 and 2 alone (`--weakening-only`); they state the law as its proof has it.

## What HE2's landing runs for item 1

- **Order.**
  - After item 5, since edit 3 reads `Map.step_reach_of_le` and `Map.step_reached_le` by these names. If item 5 lands under other names, edit 3's text follows them.
  - With item 7 in either order: item 7 renames near Grammar's lines 581–612, and item 1's texts lie at the law (about 664–690), disjoint.
  - Items 2, 3, 4 and 6 edit GrammarLaws, Response and SelectionPool, which item 1 does not touch.
- **Signatures.** One statement changes, «两端分则中有标»'s hypotheses as above. No declaration in the package is added, removed or renamed; the check module is scratch.
- **Records.**
  - **Rebound:** none.
  - **Drift:** the records citing the three modules drift with the rebuild and are re-pointed with the reason:
    - Grammar: continuation-relative-to-a-class, precedence-and-its-links, processes-represented-both-ways, tasks-and-what-performs-them, the-present-on-causal-set-growth, the-world-represented-both-ways, what-a-course-keeps-reachable, what-can-be-born-next, what-choices-show-of-an-order, where-the-possible-grows;
    - PatternPassing: a-pattern-lasts-through-passing, continuation-relative-to-a-class, master-laws-on-the-grammar;
    - Sampling: continuous-time-as-tower, laws-at-coarser-steps, only-the-order-of-change-shows, relata-counted-up-to-indiscernibility.

    These are the records that name the paths; the records check gives the exact drift.
  - **Reason, for the re-point:** "HE2's item 1: «两端分则中有标» asks only that the relation it keeps compose (split, then trans, in place of a class), PatternPassing's two uses pass the carrier class's trans, and Sampling's arises_within and ceases_within are read from the law along the successor; statements unchanged but the law's hypotheses".
- **One claim widened.** continuation-relative-to-a-class, law 10 (`laws[9]`), whose declarations include «两端分则中有标», still reads true, but it states the law only for a class. Proposed, in both languages:
  - en, from "and where every step keeps a class or carries a mark, a line whose ends the class tells apart has a marked step" to "and where every step keeps a relation that composes (a class is one) or carries a mark, a line whose ends the relation tells apart has a marked step";
  - zh, from「凡每一步或保一类或带一标者，其两端为此类所分之线，必有带标之一步」to「凡每一步或保一传递之关系（类即其一）或带一标者，其两端为此关系所分之线，必有带标之一步」.

  No chapter states the law's hypothesis (searched), so the record is its only statement in prose.
- **The master-laws view** (master_laws.py, rerun on the receipt as after every core landing).
  - Expected: laws-at-coarser-steps law 8 moves from "no master law" to the grammar. Its declarations `Web.sample_arises`, `Web.sample_ceases`, `Web.sample_unceasing` and `Web.sample_ceasing` now reach «两端分则中有标» through `arises_within` and `ceases_within` (the genuineness check reads each), and nothing outside Sampling uses those two or the coarse-step theorems.
  - The central measure (COVERAGE) does not move: none of these declarations is central.
