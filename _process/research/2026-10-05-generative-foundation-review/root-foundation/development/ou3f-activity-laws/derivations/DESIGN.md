# OU3f, derivations: the three twins rule 9 retires

AI-written design for the third part of board item OU3f, 29 October 2026, on main at `a34db4227`, after the laws of steps ([design](../laws/DESIGN.md), study §442). [The audit](../AUDIT.md) found three activity laws proved twice: once directly, and once by a twin added with OU3a that derives the same statement from a grammar law. Board rule 9 keeps the derivation and retires the direct proof. The coordinating session ordered the twins first among the derivations, module by module. Only `ContinuedClasses` and `PatternPassing` change ([tree](tree/Becoming/)).

Owners: both modules were last changed by OU2 and OU3a (23 October), whose sessions are no longer active, so rule 3's fallback applies, as for OU3e.

## What changes

| module | declaration | change |
|---|---|---|
| `ContinuedClasses` | `Web.Continuing.mono` | Proof only: the twin's derivation. A continuing is the occurrence itself or a line under activity (`continuing_iff_line`), and the line grows with the relation (`«及之单调»`). The direct induction on `Continuing` goes. The statement keeps its form, with `∀ {t g u h}` after the colon. |
| `ContinuedClasses` | `Web.Continuing.mono_by_reach` | Retired. Its proof is now `Continuing.mono`'s. No module uses it, and no record cites it. |
| `ContinuedClasses` | `consumingAlong_mono`, `renewingAlong_mono` | Moved, unchanged, to just after `Continuing.mono`. `Continuing.mono` now follows `continuing_iff_line`, which is proved in the module's last section. |
| `ContinuedClasses` | header of the last section | Names `Continuing.mono`, and the two laws resting on it. |
| `PatternPassing` | `Web.ByPassing.passes_within` | Proof only: the twin's, through `ByPassing.line_back` and `«两端分则中有标»`, in the twin's place. The binder keeps its name `by_passing`, so the printed statement is unchanged. The direct proof through `ByPassing.trace` goes. `trace` stays, since `ends_within` uses it. |
| `PatternPassing` | `Web.ByPassing.begins_passed` | Proof only: the twin's, through `«生于细而续于粗则异»`, in the twin's place, binder `by_passing`. The direct proof goes. |
| `PatternPassing` | `passes_within_by_line`, `begins_passed_by_grammar` | Retired: their proofs are now the two theorems'. No module uses them, and no record cites them. |
| `PatternPassing` | header, *Derived from grammar laws* | Says the two theorems are proved from the laws. It no longer calls `«两端分则中有标»` "stated here", since it is `Grammar`'s. |

Each docstring keeps the theorem's statement in words and adds the derivation's.

The scratch build gives `ContinuedClasses` 73 theorems in 98 declarations (74 in 99 before) and `PatternPassing` 32 in 45 (34 in 47 before), every axiom report empty and no warnings ([log](scratch-1.log)). The header correction came after the build and is comment text only.

## Why each is a derivation

The test is OU3d's second review's: a derivation replaces part of the old proof by the law; applying a law and then undoing it is no derivation.
- **`Continuing.mono`.** The old proof is an induction on the continuing that carries each step from `R` to `S`. That is reach growing with the relation, which `«及之单调»` states for every relation. What remains is the representation of a continuing as a line (`continuing_iff_line`, OU3a's), with its own induction.
- **`passes_within`.** The old proof traces a carrier back over `d` steps (`ByPassing.trace`) and finds a passing because no carrier carries at both ends. The new one reads the trace as the pattern's line (`line_back`, OU3a's representation) and takes the passing from `«两端分则中有标»`: a line whose ends the carrier class tells apart, each step keeping the class or marked, has a marked step. The law replaces the finding of the passing.
- **`begins_passed`** (small). The old proof is three lines: the passing premise gives a carrier before or a passing, and the first contradicts the arising. The new one replaces that contradiction by `«生于细而续于粗则异»`: a beginning under the finer class, continued under the coarser one, is an alteration, which is a passing.

The audit's review confirmed the two genuine twins and the third as small.

## Not in this part

- **The six by closure.** `inactive_of_not_arising`, `active_back`, `active_before`, `ended_for_good`, `ByPassing.present_earlier` and `steady_held` need a clock run (`Invariant.reach` with `Run.reach`, as in EC6b). The clock is best stated once, not in six modules. Its place is that part's design.
- **The restricted bridge** with `Lineage.unique` and `origin`, and then `split`, `through`, `onward` and `back` (Identity).
- **The coarse-to-fine pair** (Persistence).

## Landing

- A rehearsal is not needed: the two modules have four direct importers (`MapInstances`, `WorldRepresentation`, `EventualWidening` and the root module), and the run rebuilds only them and what imports them.
- Signatures: every remaining declaration prints its old statement. Three are gone (`Continuing.mono_by_reach`, `ByPassing.passes_within_by_line`, `ByPassing.begins_passed_by_grammar`), and none is added.
- The connectivity register and the measure, rechecked.
- The record `master-laws-on-the-grammar`'s last group gains the three derivations.
- The records citing the two modules are re-pointed.
- A study section.
