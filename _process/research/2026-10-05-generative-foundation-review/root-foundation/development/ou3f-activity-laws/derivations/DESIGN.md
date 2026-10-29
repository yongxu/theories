# OU3f, derivations: the three twins rule 9 retires, and `ends_within`

AI-written design for the third part of board item OU3f, 29 October 2026, on main at `a34db4227`, after the laws of steps ([design](../laws/DESIGN.md), study §442). [The audit](../AUDIT.md) found three activity laws proved twice: once directly, and once by a twin added with OU3a that derives the same statement from a grammar law. Board rule 9 keeps the derivation and retires the direct proof. The coordinating session ordered the twins first among the derivations, module by module. The review found a fourth theorem of the same kind in `PatternPassing`, `ends_within`, so it is derived here too. Only `ContinuedClasses` and `PatternPassing` change ([tree](tree/Becoming/)).

Owners: both modules were last changed by OU2 and OU3a (23 October), whose sessions are no longer active, so rule 3's fallback applies, as for OU3e.

## What changes

| module | declaration | change |
|---|---|---|
| `ContinuedClasses` | `Web.Continuing.mono` | Proof only: the twin's derivation. A continuing is the occurrence itself or a line under activity (`continuing_iff_line`), and the line grows with the relation (`«及之单调»`). The direct induction on `Continuing` goes. The statement keeps its form, with `∀ {t g u h}` after the colon. |
| `ContinuedClasses` | `Web.Continuing.mono_by_reach` | Retired. Its proof is now `Continuing.mono`'s. No module uses it, and no record cites it. |
| `ContinuedClasses` | `consumingAlong_mono`, `renewingAlong_mono` | Moved, unchanged, to just after `Continuing.mono`. `Continuing.mono` now follows `continuing_iff_line`, which is proved in the module's last section. |
| `ContinuedClasses` | headers | The tenure bullet says the last two laws go through `Continuing.mono`. The last section's header names `Continuing.mono` and the two laws resting on it. |
| `PatternPassing` | `Web.ByPassing.passes_within` | Proof only: the twin's, in the twin's place, through `ByPassing.line_back`, `«两端分则中有标»` and `«线内同类»`. The binder keeps its name `by_passing`, so the printed statement is unchanged. The direct proof through `ByPassing.trace` goes. |
| `PatternPassing` | `Web.ByPassing.begins_passed` | Proof only: the twin's, in the twin's place, through `«生于细而续于粗则异»`, binder `by_passing`. The direct proof goes. |
| `PatternPassing` | `passes_within_by_line`, `begins_passed_by_grammar` | Retired: their proofs are now the two theorems'. No module uses them. One record cited them, and is brought to the kept names (below). |
| `PatternPassing` | `Web.ByPassing.ends_within` | Proof only, moved after `begins_passed`: the same route as `passes_within`, the review's compiled re-proof. The pattern's line back `d` steps from a carrier at a step from `T + d` on has ends the carrier class tells apart, so a passing lies on it, from `T` on, where none is. The direct proof through `trace` goes. |
| `PatternPassing` | `PatternRelay.stopped_relay` | Moved, unchanged, to the end of the module's second `PatternRelay` section, after `ends_within`, which it uses. |
| `PatternPassing` | header | The *Derived from grammar laws* paragraph names the three theorems and both laws used, `«两端分则中有标»` and `«线内同类»`. It no longer calls `«两端分则中有标»` "stated here", since it is `Grammar`'s. *Not connected* gives each remaining reason exactly. `present_back` is one application of the premise. `trace`'s disjunction would need deciding sameness of formations. `present_earlier`, and through it `present_of_le` and `empty_stays`, go back by an induction that is a case of closure, not yet derived. |

`ByPassing.trace` stays, a law of its model, cited by the record. After this part no theorem uses it. Each docstring keeps the theorem's statement in words and adds the derivation's.

The scratch build gives `ContinuedClasses` 73 theorems in 98 declarations (74 in 99 before) and `PatternPassing` 32 in 45 (34 in 47 before), every axiom report empty and no warnings ([log](scratch-2.log)).

## Why each is a derivation

The test is OU3d's second review's: a derivation replaces part of the old proof by the law; applying a law and then undoing it is no derivation.
- **`Continuing.mono`.** The old proof is an induction on the continuing that carries each step from `R` to `S`. That is reach growing with the relation, which `«及之单调»` states for every relation. What remains is the representation of a continuing as a line (`continuing_iff_line`, OU3a's), with its own induction.
- **`passes_within` and `ends_within`.** The old proofs trace a carrier back over `d` steps (`ByPassing.trace`) and find a passing, or a contradiction, because no carrier carries at both ends. The new ones read the trace as the pattern's line (`line_back`, OU3a's representation, its own induction) and take the passing from `«两端分则中有标»`: a line whose ends the carrier class tells apart, each step keeping the class or marked, has a marked step. The law replaces the search for the passing.
- **`begins_passed`** (small). The old proof is three lines: the passing premise gives a carrier before or a passing, and the first contradicts the arising. The new one replaces that contradiction by `«生于细而续于粗则异»`: a beginning under the finer class, continued under the coarser one, is an alteration, which is a passing.

## Not in this part

- **The six by closure.** `inactive_of_not_arising`, `active_back`, `active_before`, `ended_for_good`, `ByPassing.present_earlier` and `steady_held` need a clock run (`Invariant.reach` with `Run.reach`, as in EC6b). The clock is best stated once, not in six modules. Its place is that part's design.
- **The restricted bridge** with `Lineage.unique` and `origin`, and then `split`, `through`, `onward` and `back` (Identity).
- **The coarse-to-fine pair** (Persistence).
- **`Linked.mono`.** It is derivable the same way (`linked_iff_line`, `«及之单调»`; the review compiled it), but it reads no activity, so it belongs to the next layer.

## Landing

- No rehearsal: the two modules have four direct importers (`MapInstances`, `WorldRepresentation`, `EventualWidening` and the root module), and the run rebuilds only them and what imports them.
- Signatures: every remaining declaration prints its old statement. Three are gone (`Continuing.mono_by_reach`, `ByPassing.passes_within_by_line`, `ByPassing.begins_passed_by_grammar`), and none is added.
- The record `a-pattern-lasts-through-passing`:
  - Its law on the grammar (law 4) says the second law's two statements and the third law's ending are proved from grammar laws, and its declarations name the kept theorems.
  - The two retired names leave its aliases and the module's reference.
  - A history note.
  - Its home paragraph in 04 names the kept theorems.
- The records citing the two modules are re-pointed. The connectivity register and the measure are rechecked.
- The audit is corrected for `ends_within`: (a) 14, (c) model 173, so 399 of the 436 are laws of their models, not 400.
- A study section.

## The review, and what was taken

One independent read-only review by a separate AI agent ([REVIEW-TWINS](review/REVIEW-TWINS.md), its compiled checks in `review/checks/`). It found all three re-proofs genuine derivations, with every statement of both modules printing as on main (143 declarations compared). Every finding was taken.
1. **A live record and its home section cited the two retired PatternPassing names.** An earlier search cut its output short and missed them. They are brought to the kept names (Landing, above).
2. **`ends_within` is a fourth case of the same kind.** The audit had it as a law of its model. It is re-proved here by the review's compiled route, and the audit row and the header's *Not connected* sentence are corrected.
3. **Wording.**
   - `«线内同类»` is named beside `«两端分则中有标»`.
   - The `ContinuedClasses` tenure bullet says the moved laws go through `Continuing.mono`.
   - PatternPassing's header paragraph is re-wrapped.
