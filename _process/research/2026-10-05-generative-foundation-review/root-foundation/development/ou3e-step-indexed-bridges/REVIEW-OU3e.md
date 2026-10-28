# OU3e: independent read-only review

One review, 28 October 2026, by a separate AI agent working read-only (the reviewer of OU3d). It edited no file in the repository and ran its builds in scratch trees. It read the scratch tree of `Withholding` and `Labelled` and [DESIGN.md](DESIGN.md) as they stood before its findings were taken. What was taken is in DESIGN.md, *The review, and what was taken*. The findings are reproduced below as the reviewer gave them, lightly formatted.

## 1. Genuine derivations, not reroutings

- **`answers_closed` and `waitsAll_closed`.** The old proofs were inductions on `n` that unfold the run one round at a time. That induction is `«承之迭»`'s content, and with memory `«存承之迭»`'s. The new terms contain no induction on `n`. The law is applied once, and its result is translated into chains by an equivalence; it is not undone by the law's converse, as in the PartForms attempt.
- **`after_course`.** The old induction along the trace, adding one move at a time with `WithinMoves.before`, was `«迭之接»`'s induction in the model's terms. `«迭内之接»` replaces it.
- **Dependency check on a rebuild.**
  - `withholding_spreads` reaches `«存承之迭»` and `«承之迭»`.
  - `Tolerance.answers_restores_iff` reaches `«承之迭»`.
  - `after_course` reaches `«迭内之接»` and `«迭之接»`, and no longer `WithinMoves.before`.

## 2. Each bridge is its own induction, and the statements are unchanged

- `chain_iff_steps` is an induction on `k`, using the existing `Chain.zero_eq`, `Chain.last` and `«迭之末步»`.
- `trace_steps` is an induction on the trace, and `steps_trace` one on `k`.
- `within_iff_withinSteps` and `withinMoves_iff_withinSteps` have no induction.
- Under `pp.all`, these statements are identical to main's build: `waitsAll_closed`, `answers_closed`, `withholding_spreads`, `withholding_absorbs`, `answers_restores_iff`, `after_course`, `before` and `together_after_reach`.

No row needs to keep a reason.

## 3. Text, names, placement

- **Fix:** `Withholding`'s header sentence ("both closed forms below are the grammar's laws of taking on … whose rounds the two laws meet by definition") has three problems:
  - the closed forms are cases of the grammar's laws read on chains, not the laws themselves;
  - "the two laws" could mean the grammar's two just named, so it should say `waitsAll` and `answers`;
  - its parenthetical lists `«承之迭»` before `«存承之迭»`, against the order of the closed forms below, which put memory first.
- **Nit:** `trace_steps`' docstring "is" overstates a one-way lemma; "gives" is accurate.
- **Optional:** combine `trace_steps` and `steps_trace` into `(∃ xs, xs.length = k ∧ Trace P s xs t) ↔ «迭» (Steps P) k s t`, the form in which `FinerTraces`, `ReferencePlanTraces` and `CouplingTraces` already state traces.
- **Nit:** in `after_course`' docstring, the course is exactly `xs.length` moves, passed as within by `Nat.le_refl` and read through `trace_steps`. "A course of `m` moves and then within `n` …" would be exact.
- **Names.** They follow the model-first convention (`returns_iff_reaches`, `reach_iff_withinClosure`), and none of the five occurs elsewhere in the package, including the 152 modules downstream of `Labelled`.
- **`Labelled`, not `Frame`, is defensible.** By the import graph, `Frame` has 313 transitive importers out of 335 modules and `Labelled` has 152. The only consumer is in `Labelled`. `Frame`'s unindexed bridge, from `Trace` to `WithinClosure (Steps P)`, is the natural neighbour, though. `CouplingTraces` is not above `Labelled` and states traces of length `j`; if it ever needs the bridge, the bridge moves down then, as the design note says.

## 4. No axiom or elaboration risk

- Direct recompiles of `Labelled` and `Withholding` are byte-identical to the cached results: 69 theorems in 108 declarations and 40 in 52, every axiom report empty.
- Every generated constant of the eight changed or new declarations is axiom-free, including `trace_steps`' match on `Trace`.
- `Tolerance` recompiles cleanly against the new `Withholding`.
- No module uses the old proofs' equation lemmas, and no stray section variables are captured.

## Verdict (the reviewer's)

Ready to land once `Withholding`'s header sentence is fixed; the rest are nits.
