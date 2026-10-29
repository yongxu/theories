# OU3f, derivations: the coarse-to-fine pair

AI-written design for the last part of board item OU3f's derivations, 30 October 2026, on main at `cf5202bd7`, after the lineage laws (§451) and HE (§455).

## The two derivations

[The audit](../AUDIT.md) found two activity laws of `Becoming.Persistence` that are cases of the grammar's laws of lines and change, both small (*Two coarse-to-fine laws, both small*). Each old proof destructured "alike in the state class" to reach "alike in activity". That one step is the grammar's law that what ends or begins under a coarser class ends or begins under a finer one. Its sibling `arises_of_persisting_arises` already goes through the law.

| theorem | the law | what it replaces |
|---|---|---|
| `Web.wang_state_of_change` | `«亡于粗则亡于细»`: what ends under a coarser class ends under the finer one | the projection of the state class's pair to its activity half. Where activity changes across the step from `t`, the occurrence before it ends under activity, and the state class is finer than activity, so it ends there too. |
| `Web.sheng_state_of_change` | `«生于粗则生于细»`, the dual | the same projection. The occurrence after the step begins under activity, so it begins under the finer state class. |

- Statements and names are unchanged. Each docstring names the law.
- Persistence's header (*Derived from grammar laws*) gains the two.
- The coarse class is named (`E' := W.activityClass`), and the finer-than proof is the state class's first half (`fun _ _ same => same.1`).

**The PartForms test.** The law replaces the old proofs' one projection. What remains is the argument that activity does not change, unchanged. Nothing is applied and then undone. Each derivation is small, as the audit counted it: genuine by the test, but each replaces only one step.

## OU3f is then done

The audit's derivations were:
- the fifteen rows in (a), to derive: six by closure and two more; the twins and `ends_within`; the restricted bridge's `unique` and `origin`; this pair;
- the four rows in (b), with B1 and B2: `split`, `through`, `onward` and `back`.

All are derived after this part, and the rows that follow from them reach the grammar unchanged. The audit's *What follows* says nothing else among the theorems reading only activity is a derivation to make: the 398 laws of their models keep their proofs, with their reasons written down. So the landing closes OU3f's board row and moves it to the history file.

## The signature scanner

OU3b's helper `signatures_ou3b.py` compares the definitions of the changed modules by their source text, and its scanner read lines of docstrings as definitions. HE's audit met one; OC5's owner counted eight more in GrammarPath.

The helper now blanks comments, docstrings and string contents before matching (`blank_comments`), as the catalogue's parser does. Run on every module of the package, it drops 26 such lines, none of them a real declaration, and adds none. Since it only removes lines that were never declarations, on both sides of a comparison, it can only remove spurious differences: no audit that passed would fail with it.

## Scratch build

[scratch-1.log](scratch-1.log): `Becoming.Persistence` has 86 theorems in 106 declarations, as on main, every axiom report empty, with no warnings. Persistence's cone is 13 modules.

## Owners

Persistence was last changed by this item's closure part, `steady_held` (§445). OU3b's helper belongs to this item's line too (OU3b, §417).

## Landing

Behind any earlier clause, with no rehearsal needed for 13 modules beyond a run outside the repository first.
- **Signatures.** Every statement of Persistence prints unchanged, and nothing is gone or added.
- **Records.** None changes. The records pinning Persistence are re-pointed, each read first.
- **Texts.** The study section and 08's counts.
- **The board.**
  - OU3f's row moves to the history file with its whole account: the audit; the laws of steps; the twins; the closure; the lineage laws; HE's moves of `kept_onward`; and this pair.
  - The queue gets its landed clause.
- **The measure** is rerun, and MV's generator after the receipt.

## The review, and what was taken

One independent review comes next.
