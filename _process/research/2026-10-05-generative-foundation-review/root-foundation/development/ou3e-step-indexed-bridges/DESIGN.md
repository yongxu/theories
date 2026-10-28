# OU3e: the step-indexed bridges

AI-written design for board item OU3e, 28 October 2026, on main at `4fcfc7011`, after OU3d ([design](../ou3d-step-indexed-reaching/DESIGN.md)). EC6's audit found three central declarations reading the `n`-fold composition of a relation:
- `Withholding.withholding_spreads` (collective);
- `Tolerance.answers_restores_iff` (maintenance);
- `WithinMoves.after_course` in `Labelled` (capacity).

OU3d stated the laws they are cases of, on the grammar. OU3e proves the three from those laws, by board rule 9, with every statement and name unchanged ([tree](tree/Becoming/)). One independent review, every finding taken (last section). The coordinating session's condition: where a bridge needs more than its own induction to say the same thing, it stops, and the row keeps a stated reason. None does.

Owners: none active. `Withholding` and `Labelled` were last changed by the sessions of R29 to R37 (20 October), `Tolerance` by ZG1 to ZG3's (22 October). So rule 3's fallback applies, as the board row says.

## What changes

| Module | Declaration | Change |
|---|---|---|
| `Withholding` | `chain_iff_steps` (new) | `Chain up k b a ↔ «迭» up k b a`: a chain of `k` waits is `k` steps of the grammar, the chain's last wait the last step (`«迭之末步»`). It is its own induction on `k`. It uses `Chain.zero_eq` and `Chain.last`, which avoid a dependent match on `Chain` (that brings in `propext`). |
| `Withholding` | `within_iff_withinSteps` (new) | `Within up k b a ↔ «迭内» up k b a`, from `chain_iff_steps` at each length. |
| `Withholding` | `waitsAll_closed` | Proof only. It is `«存承之迭»` with rounds `fun _ _ => Iff.rfl` (a law's run meets them by definition), read on chains by `within_iff_withinSteps`. The direct induction goes. |
| `Withholding` | `answers_closed` | Proof only. It is `«承之迭»` with rounds by `Iff.rfl`, read on chains by `chain_iff_steps`. The direct induction goes. |
| `Withholding` | header | One sentence: chains of waits are the grammar's steps, so both closed forms are its laws of taking on. |
| `Labelled` | `trace_steps`, `trace_iff_steps` (new) | A trace of `xs` gives `xs.length` steps of `Steps P` (`«迭»`), and a trace of `k` moves is exactly `k` steps, in the form other trace modules use (`∃ xs, xs.length = k ∧ Trace P s xs t`). Each is its own induction. |
| `Labelled` | `withinMoves_iff_withinSteps` (new) | Realizable together within `n` moves is a configuration within `n` steps (`«迭内» (Steps P) n`) realizing the bundle. |
| `Labelled` | `WithinMoves.after_course` | Proof only. Within `m` steps and then within `n` is within `m + n` (`«迭内之接»`), in the consumers' order, so no commutation is needed, read on traces by `withinMoves_iff_withinSteps`. The direct induction on the trace goes. |

`Withholding.withholding_spreads` uses `waitsAll_closed`, and `Tolerance.answers_restores_iff` uses `answers_closed`. Both reach the grammar through them, so `Tolerance` is not changed. `WithinMoves.before` stays, since `ReachableRanges` uses it. The scratch build against main gives `Labelled` 69 theorems in 108 declarations (66 in 105 before), `Withholding` 40 in 52 (38 in 50 before), every axiom report empty and no warnings ([log](scratch-5.log)).

## Why each is a derivation, not a rerouting

OU3d's second review set the test: a derivation replaces part of the old proof by the law.
- **`answers_closed` and `waitsAll_closed`.** The old proofs are inductions on `n` that unfold the run one round at a time. That induction is `«承之迭»`'s (with memory, `«存承之迭»`'s, itself the law without memory under staying or a step). The new proofs replace it by the law. What remains is a representation, that a chain of waits is the grammar's steps, with its own induction on the chain's length, as `returns_iff_reaches` reads return. The law is not applied and undone: no step of the old induction survives inside the new term.
- **`after_course`.** The old proof is an induction on the trace that adds one move to the bound at each step (`WithinMoves.before`), which is composition of bounds. The new proof replaces it by `«迭内之接»`. What remains is the representation of a trace as the grammar's steps, with its own induction.

## Bridges named

`chain_iff_steps`, `within_iff_withinSteps`, `trace_steps`, `trace_iff_steps` and `withinMoves_iff_withinSteps` follow the earlier bridges' naming (`returns_iff_reaches`, `reach_iff_withinClosure`, `goAlikeUnder_iff_alike`): the model's notion first, then the grammar's. `trace_steps` is a plain name, not `Trace.steps`. `Trace` is `Generative.Trace`, so dot notation would put the lemma in the `Generative` namespace.

## What OU3e does not do

- It does not redefine `Chain`, `Within` or `WithinMoves` from `«迭»`/`«迭内»`. Each keeps its definition, and the bridges are equivalences.
- It puts no trace bridge in `Frame`, beside `Steps` and `Trace`. That would rebuild nearly every module for a lemma only `Labelled` uses. If another consumer needs it, it can move down then.

## Landing

On OU3d's pattern: a rehearsal run outside the repository, then the landing run, which reuses its steps. `Labelled` has 17 importers, so the run rebuilds them and their dependents. The landing also includes:
- signatures: every earlier statement of the two modules unchanged, five new bridges;
- the connectivity register: OU3d's apart roots `«迭内之接»` and `«存承之迭»` now have consumers, so their entries go;
- the measure: the three rows reach the grammar, so their pending entries go, and the gaps are 0;
- 01 §7's finite-runs bullet and 08 §7's measure sentence;
- the record master-laws-on-the-grammar: the last group gains the derivations, and the does-not-show item on the step-indexed bridges goes;
- re-pointing of the records citing the two modules;
- a study section.

## The review, and what was taken

One independent read-only review by a separate AI agent, the reviewer of OU3d ([REVIEW-OU3e](REVIEW-OU3e.md)). It found all three re-proofs genuine derivations and each bridge its own induction, and every statement identical to main's under `pp.all`. Every finding was taken.
1. **`Withholding`'s header sentence.** It now says the closed forms are cases of the grammar's laws read on chains (not the laws themselves), names `waitsAll` and `answers` (not "the two laws"), and lists `«存承之迭»` first, in the order of the closed forms.
2. **`trace_steps`' docstring** says "gives": the lemma is one way.
3. **`steps_trace` became `trace_iff_steps`**, the review's optional suggestion: one equivalence, `(∃ xs, xs.length = k ∧ Trace P s xs t) ↔ «迭» (Steps P) k s t`, in the form `FinerTraces`, `ReferencePlanTraces` and `CouplingTraces` already use for traces.
4. **`after_course`' docstring** says the course is `m` moves, read by `trace_steps` as `m` steps, then within `n`.

A leftover unused variable, from the old `steps_trace k` call, was removed, so the build is clean.
