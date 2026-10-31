# U1b: the independent review of Becoming.UnitMatchings

Cross-model reader (Codex, astra, high effort, read-only), 31 October 2026, against main `3f6afc9a4`. Its report verbatim (its links made repository-relative, each link's text keeping the line it cited in the leaf as it stood before the fixes), then how each finding is taken. AI-written.

## The report

Read-only review against `3f6afc9a4`. I compiled the leaf from stdin: **20 theorems, 29 declarations, all axiom reports empty**. No files were edited. I found no proof error.

1. **Major — The crossing summary omits essential hypotheses.** [UnitMatchings.lean:25](Becoming/UnitMatchings.lean) states the rise implication without `L.Balances W` or `Distinct ds`, both required by the weak and strong theorems.  
   **Fix:** Begin “In a balanced flow, where a family without repetition…” Preserve the current “from the rest” conclusion: only `ds` is distinct; `rest` need not be disjoint from it.

2. **Minor — Existing helpers are reproved beside their originals.** [UnitMatchings.lean:62](Becoming/UnitMatchings.lean) duplicates `Undecided.upto_length` at [Undecided.lean:430](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Undecided.lean). The leaf’s `mem_insert` at line 165 duplicates `GrammarLaws.mem_middle` at [GrammarLaws.lean:579](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarLaws.lean), also already represented by `mem_middle` in Prelude.  
   **Fix:** Reuse `GrammarLaws.mem_middle`; arrange to move `Undecided.upto_length` below both consumers, beside `upto` in Prelude, retaining its name. Also replace `tag`’s bespoke recursion with `List.map` and obtain its length from existing `length_map`. I found no equivalent existing crossing declaration or selected-frame structure; `FrameMatch.le` correctly reuses the existing pigeonhole theorem.

3. **Minor — “What is not shown” omits important interface boundaries.** [UnitMatchings.lean:43](Becoming/UnitMatchings.lean) faithfully retains DESIGN §5’s failures, but omits §3.2’s unestablished labelled exchange existence, attachment to frames, enriched-fibre nonemptiness, and bridge from `FrameMatch` to `«对»`. Nor does it explicitly exclude §3.7’s global line laws.  
   **Fix:** Add those boundaries, particularly that the selected-frame and relational-exchange interfaces are not yet joined. State that the projection and correspondence failures are design-level conclusions, not theorems supplied by this leaf.

4. **Minor — Modelling choices need fuller disclosure.** [UnitMatchings.lean:50](Becoming/UnitMatchings.lean) names naturals, steps, positions and lists, but omits commensurability when summing across conditions and multiplicities in `Flow.present`. Moreover, `beyondL`, `leaveL` and `endedL` are arbitrary lists: their names impose no constructor restrictions. `«对» R` asserts a perfect matching using edges of `R`, not that `R` itself is functional.  
   **Fix:** State these explicitly. Retain the existing warning about repeated condition labels; finite exchange selections do not restrict the globally indexed frame family to finitely many conditions.

5. **Minor — Three names suggest stronger meanings than their statements.** [UnitMatchings.lean:305](Becoming/UnitMatchings.lean): `endings_count_closed` assumes no closure; `[] ++ endedL` reduces to `endedL`, making its statement definitionally the same as `endings_count`. At lines 314 and 321, `source_free_of_dissipates` and `ends_of_dissipates` establish numerical excess facts, not source-free matching existence or a line ending.  
   **Fix:** Reuse `endings_count` for the empty-leaving case; rename the numerical lemmas, for example, `source_minimal_count_zero_of_dissipates` and `residual_pos_of_dissipates`. Replace “A line ends” in line 319 accordingly. The other requested names do not state a wrong meaning in their documented scopes.

6. **Wording — Existence attribution and variation are overstated.** [UnitMatchings.lean:18](Becoming/UnitMatchings.lean): predecessor existence comes from `bwd_lt` and `fwd_bwd`; `predecessor_unique` supplies uniqueness. Line 31’s “changes with the pairing” need not hold when a crossing is forced.  
   **Fix:** Cite the fields alongside the uniqueness lemma; say “may depend on the pairing.”

**Interface coverage:** DESIGN §2 items 1–6 are present at their stated theorem scopes. Item 1’s census form is indeed [Flow.balances_iff_units:336](../../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Flow.lean).

**Item 7’s mathematical content is not lost.** `«对之程»` supplies relational stretch composition; `«程守数当且仅当可对»` supplies the numerical representation. `Flow.over_iff_units` concerns one step across a family, not time aggregation. I additionally Lean-checked the flow’s own stretch equation from supplied pairing lists with the corresponding lengths, using `«对则守数»` and `balance_over_stretch_on`. Cite that route explicitly. A stretch law for selected `FrameMatchings` remains outside the interface, exactly as DESIGN §3.7 says.

**Verdict: land after the listed fixes.**

## How each finding is taken

1. **Taken.** The crossing bullet opens "In a balanced flow, where a family listed without repetition …", and says that only the risen family is asked to be without repetition, so the rest may share conditions with it.
2. **Taken.** `mem_insert` is gone: the crossing uses the prelude's `mem_middle`. `tag` is gone: the exchange lists are `List.map`, with their length from the prelude's `length_map`. `length_upto` is gone too: the leaf imports `Becoming.Undecided`, a core module, and uses its `upto_length` (rechecked: the recheck found the deferred move left the duplicate in place). The crossing section keeps its universe-polymorphic carrier and uses `GrammarLaws.mem_middle`.
3. **Taken.** "What is not shown" now says that the two interfaces are not joined: no labelled exchange pairing is shown to exist for a World's formations, none is shown attached to the frames, the enriched data is not shown non-empty, and nothing is bridged to `«对»`. It also says that line laws across steps lie outside the interface, and that the projection and correspondence failures are the design's conclusions, not theorems of the module. It cites the route to the flow's own stretch equation (`«对则守数»` at each step with `balance_over_stretch_on`).
4. **Taken.** A paragraph on modelling choices covers:
   - commensurability across conditions;
   - multiplicities in `Flow.present`;
   - repeated labels;
   - lists whose names restrict no constructor;
   - `«对» R` not asserting that `R` is functional;
   - finite exchange lists against frames indexed by every condition.
5. **Taken.** `endings_count_closed` is removed: with no leaving outputs kept it is `endings_count`, which the docstring says. `source_free_of_dissipates` becomes `source_minimal_zero_of_dissipates`, and `ends_of_dissipates` becomes `residual_pos_of_dissipates`. Their docstrings say they are counts, and that neither a source-free pairing nor a line ending is shown.
6. **Taken.** A predecessor's existence is cited from the fields `bwd_lt` and `fwd_bwd`, and its uniqueness from `predecessor_unique`. "Changes with the pairing" becomes "may depend on the pairing", in both places.

After the fixes the module builds with `scratch_build.py` on `3f6afc9a4`: 17 theorems in 25 declarations, every axiom report empty.

## The recheck

The same reader, resumed, recompiled the revised leaf (17 theorems in 25 declarations, every axiom report empty) and found findings 1 and 3 to 6 resolved, with three points left:

- finding 2: the deferred move of `Undecided.upto_length` left the duplicate in place;
- `crossing_edge`'s carrier was narrowed to `Type` for no reason;
- this file said "no labelled exchange pairing exists" where the leaf says none "is shown to exist".

All three are taken, as item 2 and item 3 above now read. The leaf imports `Becoming.Undecided`, a core module, and uses its `upto_length`. The crossing carrier is universe-polymorphic again, through `GrammarLaws.mem_middle`.

After the recheck's fixes the module builds with `scratch_build.py` on `3f6afc9a4`: 16 theorems in 24 declarations, every axiom report empty.
