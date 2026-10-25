# OU3b-2 and OU3b-3 notes: the master laws on the grammar, and the models' laws proved from them

AI-written drafting notes, 26 October 2026, for board items OU3b-2 (the rule-9 step of [OU3b](DESIGN.md)) and OU3b-3 (the review [REVIEW-OU3b2](REVIEW-OU3b2.md) taken, balance and rest finished). Scratch only: every edit is under this folder's `tree/` or in these notes; nothing outside this folder was edited, nothing committed, the board untouched. Round 3 comes first below; the sections after it record rounds 1 and 2, corrected where round 3 changed them.

## Round 3

### Review findings taken (REVIEW-OU3b2)

- **F1 (local forms).** A states each law of return with what it uses, and the global forms are corollaries:
  - `«定后于» R x`: the successor is fixed within `«所闭» R x`. It gives `«定后于环则所及皆返»`, `«定后于则返者不入»` and `«定后于有后则入当且仅当不返»`, and `«迭之定于»` for steps.
  - `«线不并» R g N`: merging nothing at the line's first `N` places. It gives `«线不并则可退»`, `«线有限不并则回»` and `«线有限不并则返»`.
  - `«定后于二返则不并»` is the two-occurrence form of `«皆返定后则定前»`.
  - New laws: `«定后于线有限则末返»` (the line's last place returns, with the successor fixed at what its start reaches) and `«迭之定前»` (merging nothing, n steps to one place come from one).
- **F3.** `«对»` is glossed as a perfect pairing of places under `R`, and documented as not continuation. `Flow.balances_of_continued` is renamed `Flow.balances_of_matched`; it is a new OU3b declaration, so no original changes. The case `«对» («续» R E)` is not added, and A's "not shown" says so.
- **F4.** `«等长而不对之例»`: under the empty relation, two one-place lists of equal length have no pairing.
- **F5.** `«非定后返而不入之例»`, the reviewer's `local_fixed_enough`. The docstring of `«入而返之例»` now claims only what that witness shows.
- **F6.** Renames:
  - `«环则所及皆返»` → `«定后环则所及皆返»`
  - `«入当且仅当不返»` → `«定后有后则入当且仅当不返»`
  - `«有限定前则皆返»` → `«有限遍后定前则皆返»`
  - `«有限定前当且仅当皆返»` → `«有限遍后定后则定前当且仅当皆返»`

  The uses in Recurrence and Attraction follow.
- **F7.** All five are derived from A:
  - `Branching.Lossless.cancel` from `«定前则线可退»` (`N := i + d`);
  - `Branching.Lossless.comes_back` from `«线有限不并则回»`;
  - `Law.Lossless.cancel` from `«迭之定前»` at the law's steps;
  - `Law.returns_of_reachable` from `«定后于线有限则末返»`, the orbit being the line;
  - `Law.orbit_mul` from `«迭之周»` and `«迭之定»`, through the new `Law.step_fixed`.

  To make this possible, `Law.steps_orbit` (an OU3b bridge) moved before `orbit_mul`, and `Branching.returns_iff_reaches` and `Branching.lossless_iff_fixedBefore` moved before `Lossless.cancel`. None remains with a direct proof.
- **F8.** Recurrence now says pigeonhole is a lemma on numbers and lists, proved once in A, with aliases in Recurrence. A uses the Prelude's `le_dest`, `ListTests.length_append` and `Naturals.add_congr`, and its own copies are gone. A now imports `Becoming.Prelude`, and `Becoming.GrammarMap` for `«尽»`. Flow's `total_congr` is now A's `GrammarLaws.total_congr`, which A needs below Flow, so there is no second proof.
- **F9, F10, F13.** A's header is rewritten:
  - lumping is "bridged in `Laws`, proved from them in `Mechanism`, …";
  - the title says five master laws, and the header names balance as the one law represented, not derived, with its four anchors;
  - the reason order is routed and balance's arithmetic is not is in [AUDIT](AUDIT.md#why-order-is-routed-through-the-grammar-and-balances-arithmetic-is-not-f13), with `admitted` and `admittedOn` named as coreflexive relations.
- **F14.** The docstring of `image_step_iff` says it documents the representation and no proof uses it. Mechanism's long header line is rewrapped.
- **F15.** `OU3b2Check.lean.txt` carries the reviewer's three `rfl` body checks. They pass against both the checkout and the tree.
- **F2.** Settled below (rest). F11 is done by B, C and D below. F12 is done by [AUDIT](AUDIT.md), except the measure, which needs A in the checker cache and so belongs to the landing. F16 is for the lander; DESIGN.md line 27 ("conservation as a fact about continuation") is left as the design's history.

### Balance (B)

A proves on the grammar that pairings:
- read backward (`«对之逆»`);
- compose under `«而» R S` (`«对之接»`, via `«对之取»`), and under a transitive relation under itself (`«对之传»`);
- join (`«对之并»`) and swap under a reflexive relation (`«对之换»`);
- gather over a finite family (`«对之族»`, with `«聚»`);
- carry over a stretch under `«所闭» R` (`«对之程»`).

The count law over a stretch is exactly such a pairing of units (`«程守数当且仅当可对»`).

Flow represents its anchors both ways:
- `balances_iff_units`;
- `balancesOn_iff_units`;
- `over_iff_units`, the family equation as a pairing of gathered unit lists;
- `BalancesOn.units_over`, the members' pairings gathered by `«对之族»`.

`balance_over_stretch_on` lives in the Prelude, below A, so its representation is A's `«程守数当且仅当可对»`.

The consumers' numerical proofs are not rerouted, because each needs only the count, and the count is exactly what a pairing under the one is (`«一之对»`).

### Finite runs: rest (C), and F2 settled

The grammar reading of rest is **ending**. A line whose steps from `T` are steps of `Q` is at rest where its steps of `F` do not recur (`«屡»`, and `«或屡»` as far as can be refuted). Where every course of `Q`-steps then an `F`-step ends from the line's place (`«尽» («而» («所闭» Q) F) «一»`, GrammarMap's accessibility), the `F`-steps do not recur:
- `«尽则不或屡»`, by induction on `«尽»`, with no decision and no choice;
- `«尽则不屡»`, outright.

At amounts:
- `Amounts.falls_end`: within fewer than `m` least losses, the courses of no rise then a least fall end.
- `Amounts.rests_unrefuted` is now proved from `«尽则不或屡»` and `falls_end`, with its statement unchanged, and `Amounts.rests` follows from it as before.
- `Amounts.FallsStop` is `¬ «或屡» (fun a b => ¬ M.le a b) s T` by definition (`Amounts.fallsStop_iff`, both ways).
- Falls that end stop (`Amounts.fallsStop_of_ends`). The converse needs dependent choice and is not stated.

**F2: rest is not a case of `«入»`**, proved both ways:
- `«止而不入之例»`: a fixed point is at rest and not drawn.
- `«入而屡之例»`: along the successor on the whole numbers, 0 is drawn and its `F`-steps recur.

A's header states this, and the proposed revision of 08 §7's row is [PROPOSED-08-7-FINITE-RUNS](PROPOSED-08-7-FINITE-RUNS.md).

### Order (D)

`Weighting.admittedOn items a` is the coreflexive relation of what `a` admits among the listed items. `includesOn_iff`, `exceedsOn_iff`, `widensOn_iff` and `mixedOn_iff` read the comparisons as `«则»`, `«逾»`, `«广»` and `«杂»`, both ways. The checkout had no order law of `WidensOn`; the new `WidensOn.not_reverse` and `WidensOn.trans` are A's.

### Statements and build (round 3)

`OU3b2Check.lean.txt` now prints 67 statements with `pp.all`: the round-2 43, plus 24 more. Of the 24, 7 are originals whose proofs changed this round:
- `Law.orbit_mul`, `Law.Lossless.cancel`, `Law.returns_of_reachable`;
- `Branching.Lossless.cancel`, `.comes_back`;
- `Amounts.rests_unrefuted`;
- `total_congr`.

The other 17 are downstream or anchors:
- `Law.returns_iff_keeps`, `Branching.Lossless.recurs`, `carries_law_iff`;
- `Branching.Returns`, `Branching.Lossless`, `Amounts.rests`, `Amounts.FallsStop`, `Flow.Balances`, `Flow.BalancesOn`, `Flow.Balances.over`, `balance_over_stretch_on`;
- `Weighting.IncludesOn`, `ExceedsOn`, `WidensOn`, `MixedOn`, `Web.Widens`, `GoAlikeUnder`.

It also carries the three `rfl` body checks. It was compiled against the checkout (scratchpad tree holding only the check) and against `tree/`. The two outputs are **identical** (299 lines, kept as `OU3b2-statements.txt`).

The full build ran with the check importing the root `Becoming` and `Becoming.FallibleInquiry`:
- 329 modules, 323 steps run, `unclean: []`, exit 0 (`OU3b2-build.log`);
- every audited module had an empty axiom report.

The check module was then removed from `tree/`.

| module | declarations | theorems | change this round |
|---|---:|---:|---|
| GrammarLaws | 133 | 113 | +35 declarations (balance, local runs, rest, witnesses) |
| Frame | 40 | 30 | none |
| Recurrence | 103 | 82 | `Law.step_fixed` |
| Attraction | 71 | 56 | rename uses only |
| Laws | 11 | 5 | none |
| Mechanism | 46 | 31 | wording |
| GrammarRegularity | 29 | 25 | none |
| IdentificationRuns | 65 | 58 | none |
| GrammarScope | 45 | 38 | none |
| Admission | 81 | 53 | none |
| Flow | 139 | 102 | `balancesOn_iff_units`, `over_iff_units`, `BalancesOn.units_over`; rename |
| Regions | 31 | 23 | none |
| Amounts | 42 | 37 | new copy: `falls_end`; imports A |
| InAmounts | 127 | 91 | new copy: `fallsStop_iff`, `fallsStop_of_ends` |
| Weightings | 559 | 397 | new copy: `admittedOn` and six theorems |

Amounts, InAmounts and Weightings were copied from the checkout this round. Their last checkout commits are `423800365`, `1af8e0949` and `67338f174`, with no uncommitted change. None of the fourteen copied modules has changed on main since its copy.

### For the lander (additions to F16)

- `Amounts` now imports `Becoming.GrammarLaws`. Its header says so, and A's closure is Grammar, GrammarMap and Prelude, so there is no cycle.
- No declaration of any model module was removed.

Board rule 9 ("generalize below, not beside") forbids landing a second proof beside an original. So the `_by_grammar` theorems of the first draft are gone. Each original keeps its name and statement and is now proved from the grammar's law (`Becoming.GrammarLaws`, module A) in its own module, which reaches A through `Becoming.Frame`.

## Imports

- `Becoming.GrammarLaws` imported only `Becoming.Grammar` in rounds 1–2; since round 3 it imports `Becoming.Grammar`, `Becoming.GrammarMap` (for `«尽»`) and `Becoming.Prelude`, none of which imports a model.
- `Becoming.Frame` now imports `Becoming.Prelude`, `Becoming.GrammarLaws` and `GenerativeCore`. Every model module reaches A through Frame, so no other import changed. Mechanism, GrammarRegularity, IdentificationRuns, GrammarScope and Regions already reach Frame and Laws.
- No cycle arises: A's closure is {Grammar} (since round 3, {Grammar, GrammarMap, Prelude}), below Frame and Amounts. The build's closure walk asserts there is no cycle.
- Module B (`Becoming.GrammarLawsInstances`) is gone. Its two balance theorems moved into `Flow`, and its scratch file was deleted from `tree/`. The only new module is `Becoming.GrammarLaws`. `Flow` reaches A through `Frame`, as every model does, so it needs no import of its own.
- The bridges for lumping sit in `Laws`, not `GrammarRegularity`. `GrammarRegularity` imports `IdentificationRuns` transitively, and `Law.sameFuture_of_goAlike` (in `IdentificationRuns`) needs the bridge. So `goAlikeUnder_iff_alike` is stated in `Laws` with the move written out (`fun s t => P.step s a t`), which is `moveRel P a` by definition.
- For landing, the integrator must add `Becoming.GrammarLaws` to `CORE` in `check_becoming.py` and to the root `Becoming.lean`. This folder does not do that.

## What moved where, and what is proved from A

Names as of round 2. Round 3's renames (F6, `balances_of_matched`) and derivations (F7) are listed under Round 3.

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

- `Flow.Balances`, `Flow.Balances.over`, `balance_over_stretch_on`: represented, not derived (round 3, Balance).
- `WithinClosureOf` and its laws have no A counterpart; they are unchanged.
- `Amounts.rests` was not represented in rounds 1–2; round 3 proves it from A (Finite runs: rest).

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

## Statements unchanged: the check (round 2; round 3 extends it)

`OU3b2Check.lean.txt` is the check module, kept as text so that it is not taken for part of the tree. It prints, with `pp.all` (every implicit argument, universe and binder name), the full statement of 43 declarations:
- the 42 originals whose proof or definition changed: the 11 of Frame, the 13 of Recurrence, 2 of Attraction, `image_determined_iff`, 2 of GrammarRegularity, `Law.sameFuture_of_goAlike`, 2 of GrammarScope, the 3 of Admission and the 7 of Regions;
- `RecurrenceRuns.lossless_iff_returns`, which is unchanged.

`Flow` changed no original: it only gained the two balance theorems.

It was compiled twice, with the same `#check` lines (the scratchpad copy imports six modules directly; this one imports the root `Becoming` and `Becoming.FallibleInquiry`). The first compile was against the checkout, in a scratchpad tree holding only the check module; the second was against this tree. The two outputs are **identical** (`diff` empty, 150 lines; the output is kept as `OU3b2-statements.txt`). The full build compiling every downstream module unchanged is the second check.

`OU3bCheck.lean.txt` (the first draft's check, comparing `_by_grammar` copies) is superseded: those copies no longer exist.

## Build (round 2; superseded by round 3's)

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
