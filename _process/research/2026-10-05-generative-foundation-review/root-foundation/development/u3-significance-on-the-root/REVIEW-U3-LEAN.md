# U3: the review of the Lean and the records kit

30 October 2026, before the landing queue. Two independent readers, read-only, each briefed with the same text and neither with the other's findings: GPT astra (high effort) and a Claude Opus subagent. Each was given the leaf `Becoming.SignificanceStatements`, the one theorem added to `Becoming.Weightings`, the kit (`kit/laws_u3.py`, `kit/make_records_u3.py`), the design and its review, the scratch builds, F5's spec and the measure. This page names each of the six theorems it checked: `noOutside_iff_paths_livingSignificance`, `paths_extension_iff_grammar`, `paths_comparison_grammar`, `widens_iff_retains_adds_root`, `paths_one_object_root` and `grammar_widens_iff_every_positive`. Each reader's findings are saved as returned, with absolute links made repository-relative and line numbers dropped. §3 says how each finding is taken.

## 1. GPT astra

1. **High — Three specializations are incorrectly registered as F5 statements of their rows.**  
   Affects `noOutside_iff_paths_livingSignificance`, `widens_iff_retains_adds_root`, and `paths_one_object_root`. They fix `sig` to `selfAscribed (ownClosure rel) center`; the first also specializes the general frame to web paths. Nevertheless, the kit gives every law `statements_at_model` with model `own` ([make_records_u3.py:100](kit/make_records_u3.py)). F5 explicitly excludes instances and specializations; choosing `own` does not remove that restriction ([F5-MODEL-STATEMENTS.md:85](../../../../../../_process/research/2026-10-05-repository-reconciliation/architecture/mv/F5-MODEL-STATEMENTS.md)). The dependency checks cannot detect this semantic mismatch, so these entries would misclassify their general rows.

   **Fix:** keep these three as ordinary laws without F5 items, or obtain the specified schema extension distinguishing statements, instances and specializations. Correct the design’s corresponding classification.

2. **Medium — The acyclic-center claim lacks its supporting declaration in all three affected records.**  
   The words “On an acyclic relation the condition forces every center to coincide” accompany the same three theorems, but each law cites only its new equivalence ([laws_u3.py:12](kit/laws_u3.py), [30](kit/laws_u3.py), [38](kit/laws_u3.py)). Those equivalences do not prove the acyclic consequence. None of the three existing records cites its actual proof, `Becoming.«续无外则同一中心»`, which concludes `center p = center q` under acyclicity and `«续无外»` ([GrammarScope.lean:215](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarScope.lean)).

   **Fix:** cite that declaration and add its `GrammarScope` proof reference and binding, extending the kit’s module collection accordingly.

3. **Low — The weighting law text drops limits correctly stated in its docstring.**  
   For `grammar_widens_iff_every_positive`, both languages say “every weighting positive on the items” without specifying additive natural-number weighting ([laws_u3.py:47](kit/laws_u3.py)). The declaration concerns a finite list, Boolean admission and sums of natural-number weights; its docstring states these limits explicitly ([Weightings.lean:1179](tree/Becoming/Weightings.lean)).

   **Fix:** state “on a finite list, with Boolean admission and additive natural-number weights positive on every listed item” in both law texts.

Also checked `paths_extension_iff_grammar` and `paths_comparison_grammar`: no defects found. Both Lean files recompile; all six axiom reports are empty. No files changed.

## 2. The Claude Opus reader

This reader's findings, and how each is taken, are added with U3's Lean landing.

## 3. How each finding is taken

- **Astra 1 (high), taken.** F5's spec says it outright: "An instance or a specialization of a row states less than the row, so it is not an item". `noOutside_iff_paths_livingSignificance`, `widens_iff_retains_adds_root` and `paths_one_object_root` fix significance at the structural reading (`selfAscribed (ownClosure rel) center`), so each is a specialization of its row. They land as ordinary laws in their rows' records, each saying it is a specialization, with no F5 item, under the label *At the structural reading*. Only `paths_extension_iff_grammar`, `paths_comparison_grammar` and `grammar_widens_iff_every_positive`, which keep their row's full generality, carry items (model `own`). The design's §3 is corrected to match.
- **Astra 2 (medium), taken.** The three laws stating the acyclic boundary now cite `Becoming.«续无外则同一中心»` (GrammarScope), and the kit adds its proof reference and binding.
- **Astra 3 (low), taken.** Row 10's law text, in both languages, now names a finite list, two-valued admission and additive natural-number weights positive on every listed item.
