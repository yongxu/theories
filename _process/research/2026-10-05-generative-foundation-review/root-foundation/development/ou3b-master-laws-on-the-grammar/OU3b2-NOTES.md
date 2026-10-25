# OU3b-2 notes: the models' laws proved from the grammar's, in their own modules

AI-written drafting notes, 26 October 2026, for board item OU3b-2 (the rule-9 step of [OU3b](DESIGN.md)). Scratch only: every edit is under this folder's `tree/`; nothing outside it was edited, nothing committed, the board untouched.

Board rule 9 ("generalize below, not beside") forbids landing a second proof beside an original. So the `_by_grammar` theorems of the first draft are gone. Each original keeps its name and statement and is now proved from the grammar's law (`Becoming.GrammarLaws`, module A) in its own module, which reaches A through `Becoming.Frame`.

## Imports

- `Becoming.GrammarLaws` imports only `Becoming.Grammar`, which imports nothing.
- `Becoming.Frame` now imports `Becoming.Prelude`, `Becoming.GrammarLaws` and `GenerativeCore`. Every model module reaches A through Frame, so no other import changed. Mechanism, GrammarRegularity, IdentificationRuns, GrammarScope and Regions already reach Frame and Laws.
- No cycle arises: A's closure is {Grammar}, below Frame. The build's closure walk asserts there is no cycle.
- Module B (`Becoming.GrammarLawsInstances`) is gone. Its two balance theorems moved into `Flow`, and its scratch file was deleted from `tree/`. The only new module is `Becoming.GrammarLaws`. `Flow` reaches A through `Frame`, as every model does, so it needs no import of its own.
- The bridges for lumping sit in `Laws`, not `GrammarRegularity`. `GrammarRegularity` imports `IdentificationRuns` transitively, and `Law.sameFuture_of_goAlike` (in `IdentificationRuns`) needs the bridge. So `goAlikeUnder_iff_alike` is stated in `Laws` with the move written out (`fun s t => P.step s a t`), which is `moveRel P a` by definition.
- For landing, the integrator must add `Becoming.GrammarLaws` to `CORE` in `check_becoming.py` and to the root `Becoming.lean`. This folder does not do that.

## What moved where, and what is proved from A

| module | proved from A now (statement unchanged) | bridges added (new declarations) |
|---|---|---|
| `Frame` | `ClosedUnder := «闭» rel region`, `WithinClosure := «所闭» rel f g` (still `def`). `WithinClosure.refl`, `.trans`, `.of_rel`, `.mono`, `.symm`, `.not_rel`, `closedUnder_withinClosure`, `closure_iff_certified` and `not_within_of_closed` are each one application of A's law | `closedUnder_iff_closed`, `withinClosure_iff_within` (`Iff.rfl`, the representation by definition; moved from B) |
| `Recurrence` | `le_succ_cases`, `gap_of_lt`, `mem_cons_split`, `skipAt` (a `def` equal to A's), `skipAt_ne`, `skipAt_le`, `skipAt_lt`, `split_at_head`, `revisits_within`: one proof each, A's (`GrammarLaws.*`). `Law.lossless_iff_returns` (from `«有限定前当且仅当皆返»`), `Law.Lossless.returns` (from `«有限定前则皆返»`), `Law.lossless_of_returns` (from `«皆返定后则定前»`); `Branching.Lossless.returns` (from the line law `«线有限定前则返»`, the run being the line) | `Law.next_fixed`, `Law.next_total`, `Law.reaches_of_orbit`, `Law.reaches_iff_orbit`, `Law.returns_iff_reaches`, `Law.lossless_iff_fixedBefore`, `Law.steps_orbit`; `Branching.returns_iff_reaches`, `Branching.lossless_iff_fixedBefore`; the new consequence `Branching.Lossless.returns_of_total` (renamed from `…_by_grammar`) |
| `Attraction` | `Law.drawn_iff_not_returns` (from `«入当且仅当不返»`), `Law.Drawn.not_returns` (from `«定后则返者不入»`) | `Law.absorbing_iff_closed`, `Law.drawn_iff_drawnIn` |
| `Laws` | (none) | `determined_iff_fixed`, `goAlikeUnder_iff_alike` |
| `Mechanism` | `image_determined_iff` (from the new `«像定后当且仅当同行»`) | `image_step_iff` (`Iff.rfl`) |
| `GrammarRegularity` | `constant_of_goAlike` (from `«同行遍后则有常»`), `goAlike_of_constant` (from `«有常定后则同行»`) | (none; B's `moveRel_fixed` is replaced by `determined_iff_fixed`) |
| `IdentificationRuns` | `Law.sameFuture_of_goAlike` (from `«同行之迭»`, via `Law.steps_orbit`) | (none) |
| `GrammarScope` | `withinClosure_iff_reached` (from `«所闭当且仅当同一或及»`), `withinClosure_of_line` (likewise) | `eq_or_reach_iff_reached` (moved from B; its only user is here) |
| `Admission` | `Web.Includes.refl`, `Web.Includes.trans`, `Web.Includes.not_exceeded` (from `«则之自反»`, `«则之传递»`, `«逾则不则»`) | `Web.admitted`, `Web.includes_iff`, `Web.exceeds_iff` (moved from B by way of Regions, since the definitions live here) |
| `Flow` | (none: balance is read on the grammar, not derived) | `Flow.balances_iff_units`, `Flow.balances_of_continued` (moved from B) |
| `Regions` | `Web.Widens.not_reverse`, `.trans`, `.not_keeps`, `.not_mixed`, `Web.Keeps.not_mixed`, `Web.Keeps.symm`, `Web.Mixed.symm` (from `«广不可逆»`, `«广之传递»`, `«广则非齐»`, `«广则非杂»`, `«齐则非杂»`, `«齐之对称»`, `«杂之对称»`) | `Web.widens_iff`, `Web.keeps_iff`, `Web.mixed_iff` (moved from B) |
| `Branching` | `RecurrenceRuns.lossless_iff_returns` was already derived from `Law.lossless_iff_returns`; not copied, unchanged | (none) |

In round 2 (the coordinator's cleanup), module B was dissolved. `Flow.balances_iff_units` and `Flow.balances_of_continued` now sit in `Flow`, next to `Balances`. They are a reading of `Flow.Balances` on the grammar, not a derivation, and the `Flow` header says so. `tree/Becoming/GrammarLawsInstances.lean` was deleted. It was scratch, and its history is in this folder's notes.

Decided against B's list:
- `reach_iff_within` is dropped. With `WithinClosure` defined as `«所闭»`, it is Frame's `reach_iff_withinClosure` read through a definition, so it would be a second statement of one fact.
- `Branching.returns_iff_reaches` goes into `Recurrence`, where `Branching.Returns` and `Branching.Lossless` are defined.
- `Branching.Lossless.returns_of_total` sits beside `Branching.Lossless.returns` in `Recurrence`.

The theorems going further than the brief are `Branching.Lossless.returns`, `Law.Lossless.returns`, `Law.lossless_of_returns`, `Law.Drawn.not_returns`, `withinClosure_of_line`, `Keeps.symm`, `Mixed.symm` and `image_determined_iff`. Each is the general law proving the special one, as rule 9 asks. Their direct proofs went; the orbit-period arithmetic of `lossless_of_returns` and `Drawn.not_returns` is replaced by A's.

Declarations per module before → after (theorems): Frame 38 → 40 (28 → 30), Recurrence 92 → 102 (71 → 81), Attraction 69 → 71 (54 → 56), Laws 9 → 11 (3 → 5), Mechanism 45 → 46 (30 → 31), GrammarRegularity 29 → 29, IdentificationRuns 65 → 65, GrammarScope 44 → 45 (37 → 38), Admission 78 → 81 (51 → 53), Flow 134 → 136 (97 → 99), Regions 28 → 31 (20 → 23). No declaration was removed from any model module.

## Not proved from A, and why

- `Flow.Balances`, `Flow.Balances.over`, `balance_over_stretch_on`: see "Review taken", findings 2 and 3.
- `WithinClosureOf` and its laws have no A counterpart; they are unchanged.
- `Amounts.rests` is not represented (A's header gives the reason).

## Review taken (DEV/REVIEW-ASTRA-A.md)

- **Finding 6.** `«所闭当且仅当及»` is renamed `«所闭当且仅当同一或及»` everywhere (A, GrammarScope).
- **Finding 7.** `«不定后则入而返»` is renamed `«入而返之例»`. Its docstring and A's header now call it a witness that the fixed successor "cannot be omitted in general", not a characterization. The docstring of `«无后者不入亦不返»` now says the successor hypothesis cannot be omitted.
- **Finding 1.** No header says "each model anchor". A's header lists where each law is now proved, and says `Amounts.rests` (marked steps not recurring under a least loss within a finite budget, `¬ ∀ N, ∃ t, N ≤ t ∧ P t`) is not represented, and why rest is not `«入»`: no settling time and no absorbing region entered from outside, and a course already at rest need not be drawn.
- **Finding 2.** A and the `Flow` header (formerly B) now describe balance as an exact cardinality representation of natural-number balance at one step. The matching is supplied, not derived from the unfolding. There is no unit trajectory and no compatibility between successive matchings, and for an arbitrary relation only matching gives balance. "Conservation as a fact about continuation" is removed.
- **Finding 3.** A and the `Flow` header (formerly B) say the lifting covers one-step balance only. Balance over a stretch (`balance_over_stretch_on`, telescoping) and over a family (`Flow.Balances.over`, sums over conditions) stay arithmetic, because each adds equations already balanced and routing it through lists adds a dependence and no content.
- **Finding 5 (done).** A gains local lumping bridges, and the global forms became their corollaries:
  - `«有常局定后则同行»`: the successor needs to be fixed only at the occurrences `E` relates something to.
  - `«同行可续则有常»`: a successor is needed only where `E` leads from one that has one.
  - `«有常则可续»`: constancy gives that availability, so the hypothesis is necessary.
  - `«局定后则有常当且仅当同行可续»`: the exact gap.
  - `«有常定后则同行»` and `«同行遍后则有常»` are now corollaries.
- **Finding 8 (done).** A gains the local path lemma `«线有限定前则返»`: a line of a list's length whose places the list holds, under a relation merging nothing, has its start reaching itself. Neither totality nor a list of the whole carrier is needed. `«有限定前则皆返»` is now its corollary. Merging nothing (`«定前» R`) is still assumed globally; a version local to the line was not attempted.
- **Finding 4 (done).** A gains `«像»`, the image of a relation along a map, and `«像定后当且仅当同行»`: the image has a fixed successor exactly where sameness under the map goes alike, and the law may be partial. `Mechanism.image_determined_iff` is now proved from it (and so is `carries_law_iff`, which uses it), through `determined_iff_fixed` and `goAlikeUnder_iff_alike`. No totality is added.

## Statements unchanged: the check

`OU3b2Check.lean.txt` is the check module, kept as text so that it is not taken for part of the tree. It prints, with `pp.all` (every implicit argument, universe and binder name), the full statement of 43 declarations:
- the 42 originals whose proof or definition changed: the 11 of Frame, the 13 of Recurrence, 2 of Attraction, `image_determined_iff`, 2 of GrammarRegularity, `Law.sameFuture_of_goAlike`, 2 of GrammarScope, the 3 of Admission and the 7 of Regions;
- `RecurrenceRuns.lossless_iff_returns`, which is unchanged.

`Flow` changed no original: it only gained the two balance theorems.

It was compiled twice, with the same `#check` lines (the scratchpad copy imports six modules directly; this one imports the root `Becoming` and `Becoming.FallibleInquiry`). The first compile was against the checkout, in a scratchpad tree holding only the check module; the second was against this tree. The two outputs are **identical** (`diff` empty, 150 lines; the output is kept as `OU3b2-statements.txt`). The full build compiling every downstream module unchanged is the second check.

`OU3bCheck.lean.txt` (the first draft's check, comparing `_by_grammar` copies) is superseded: those copies no longer exist.

## Build (round 2)

From `experiments/integrated-correction/general-framework/generative-basis/lean/becoming`:

```
python3 -B scratch_build.py <DEV>/tree Becoming.OU3b2Check Becoming.GrammarLaws Becoming.Frame \
  Becoming.Recurrence Becoming.Attraction Becoming.Laws Becoming.Mechanism Becoming.GrammarRegularity \
  Becoming.IdentificationRuns Becoming.GrammarScope Becoming.Admission Becoming.Flow Becoming.Regions
```

During the run, `tree/Becoming/OU3b2Check.lean` imported the root `Becoming` (all 320 of its imports) and `Becoming.FallibleInquiry` (the one package module the root does not import). So the build covered the whole package plus A:
- 328 modules compiled (final run, after a header-only edit to A: 317 steps run, 24 restored from the cache);
- `unclean: []`, no failure, exit 0 (the report is in `OU3b2-build.log`);
- every audited module had `with_axioms: {}`.

Round 1 (with B, before the Admission and Flow changes) compiled 329 modules, also clean.

Declarations and theorems in each audited module, all with empty axiom reports:

| module | declarations | theorems |
|---|---:|---:|
| GrammarLaws | 98 | 83 |
| Frame | 40 | 30 |
| Recurrence | 102 | 81 |
| Attraction | 71 | 56 |
| Laws | 11 | 5 |
| Mechanism | 46 | 31 |
| GrammarRegularity | 29 | 25 |
| IdentificationRuns | 65 | 58 |
| GrammarScope | 45 | 38 |
| Admission | 81 | 53 |
| Flow | 136 | 99 |
| Regions | 31 | 23 |

Afterwards the check module was moved out of the tree. This is a working build, not a receipt. The checker's environment audit, controls and prelude-only compile run only at landing, which must also add A to `CORE` and the root module.

## Statements changed

None. Every original keeps its name, its statement (checked above) and its module.
