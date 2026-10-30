# U3: the review of the Lean and the records kit

30 October 2026, before the landing queue. Two independent readers, read-only, each briefed with the same text and neither with the other's findings (the Opus reader saw the kit mid-revision after astra's findings, and reviewed the versions saved then): GPT astra (high effort) and a Claude Opus subagent. Each was given the leaf `Becoming.SignificanceStatements`, the one theorem added to `Becoming.Weightings`, the kit (`kit/laws_u3.py`, `kit/make_records_u3.py`), the design and its review, the scratch builds, F5's spec and the measure. This page names each of the six theorems it checked: `noOutside_iff_paths_livingSignificance`, `paths_extension_iff_grammar`, `paths_comparison_grammar`, `widens_iff_retains_adds_root`, `paths_one_object_root` and `grammar_widens_iff_every_positive`. Each reader's findings are saved as returned, with absolute links made repository-relative and line numbers dropped. §3 says how each finding is taken.

## 1. GPT astra

1. **High — Three specializations are incorrectly registered as F5 statements of their rows.**  
   Affects `noOutside_iff_paths_livingSignificance`, `widens_iff_retains_adds_root`, and `paths_one_object_root`. They fix `sig` to `selfAscribed (ownClosure rel) center`; the first also specializes the general frame to web paths. Nevertheless, the kit gives every law `statements_at_model` with model `own` (`kit/make_records_u3.py:100`). F5 explicitly excludes instances and specializations; choosing `own` does not remove that restriction ([F5-MODEL-STATEMENTS.md:85](../../../../../../_process/research/2026-10-05-repository-reconciliation/architecture/mv/F5-MODEL-STATEMENTS.md)). The dependency checks cannot detect this semantic mismatch, so these entries would misclassify their general rows.

   **Fix:** keep these three as ordinary laws without F5 items, or obtain the specified schema extension distinguishing statements, instances and specializations. Correct the design’s corresponding classification.

2. **Medium — The acyclic-center claim lacks its supporting declaration in all three affected records.**  
   The words “On an acyclic relation the condition forces every center to coincide” accompany the same three theorems, but each law cites only its new equivalence (`kit/laws_u3.py:12`, `kit/laws_u3.py:30`, `kit/laws_u3.py:38`). Those equivalences do not prove the acyclic consequence. None of the three existing records cites its actual proof, `Becoming.«续无外则同一中心»`, which concludes `center p = center q` under acyclicity and `«续无外»` ([GrammarScope.lean:215](../../../../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarScope.lean)).

   **Fix:** cite that declaration and add its `GrammarScope` proof reference and binding, extending the kit’s module collection accordingly.

3. **Low — The weighting law text drops limits correctly stated in its docstring.**  
   For `grammar_widens_iff_every_positive`, both languages say “every weighting positive on the items” without specifying additive natural-number weighting (`kit/laws_u3.py:47`). The declaration concerns a finite list, Boolean admission and sums of natural-number weights; its docstring states these limits explicitly (`tree/Becoming/Weightings.lean:1179`).

   **Fix:** state “on a finite list, with Boolean admission and additive natural-number weights positive on every listed item” in both law texts.

Also checked `paths_extension_iff_grammar` and `paths_comparison_grammar`: no defects found. Both Lean files recompile; all six axiom reports are empty. No files changed.

## 2. The Claude Opus reader

I found no defect in the Lean itself: all six statements match their docstrings, are proved through their rows, use no axioms, and change no existing declaration. The defects are in the records kit and the texts around it. One of them stops `make_records_u3.py` from running at all.

The kit was being edited while I reviewed it. These findings are against the versions saved at 17:17–17:23. The earlier kit (16:55) made all six root forms F5 items, which F5's spec §4 forbids for specializations. The current kit and DESIGN §3 fix that: rows 5, 7 and 10 are items with model `own`, and rows 1, 8 and 9 land as plain laws. The two Lean files have not changed since 16:48/16:50, and they are byte-identical to the copies in `tree/.build`. Per the brief I ran no lean and no lake build; the "every axiom report empty" result comes from `check/scratch-1.log` and `check/scratch-2.log`. I did run `integrate_u3.py --check`, which writes nothing, and it passes.

### Defects, most severe first

**1. Blocking: `make_records_u3.py` fails before it writes anything, in both modes.**
- **Cause:** `make_records_u3.py:68` builds `MODULES` only from each law's main theorem, and those all live in SignificanceStatements or Weightings. GrammarScope is never added. So the GrammarScope branch at `:73-76` never runs, and the receipt names are never read for GrammarScope.
- **Effect:** `Becoming.«续无外则同一中心»`, which rows 1, 8 and 9 now cite, is missing from `names`. `assert set(decls) <= names` at `:91` fails, starting with row 1 (`continuation-condition-yields-living-significance`). I confirmed `MODULES == ['Becoming.SignificanceStatements', 'Becoming.Weightings']`.
- **Fix:** build `MODULES` from every declaration, e.g. `sorted({source_of(x) for _, _, _, decls, _, _ in LAWS for x in decls})`.
- **Also:** `--caps` reads the package sources, not the kit's tree, so it only works after `integrate_u3.py` has run. The usage line should say so.

**2. Medium: rows 8 and 9 get the wrong label in chapter 7.**
- **Cause:** `make_records_u3.py:206` writes "**Theorem** (World)" for every bullet. The root forms of rows 8 and 9 take `«续无外» rel «一» center` as a hypothesis, which is the continuation condition at the structural reading.
- **Why it matters:** the method chapter says a result that holds under the condition is **Conditional** and names its premise (`08-METHOD.md:61`, `:95`). Row 8's own bullet already says "**Conditional** (the continuation condition)" (`07-SIGNIFICANCE.md:50`). GS2 labels its `«续无外»` results "**Conditional** (the root's condition at the one, the own-closure reading)" (`07-SIGNIFICANCE.md:325`).
- **Fix:** use a per-row label.
  - Row 8: "**Conditional** (the root's condition at the one, the own-closure reading)".
  - Row 9: "**Theorem** (World) **and Conditional** (…)".
  - Row 1 stays "Theorem": its root form is an equivalence with no hypothesis.

**3. Medium: the research check will fail on the record `widening-as-what-every-weighting-ranks`.**
- **Cause:** at `make_records_u3.py:136-143` the kit moves that record's `Weightings.lean` reference to the new file hash. But `:148` only removes bindings that already point at the new receipt.
- **Effect:** the record's existing binding to receipt `20261025T184500.197330Z` stays, and that receipt still holds the old Weightings hash. The registry then raises "receipt does not bind the reviewed proof source" (`tools/research/registry.py:818`). If `repoint.py` runs before the kit, the stale binding is replaced cleanly. If it runs after, the record ends up with two identical bindings.
- **Fix:** do what U2's kit did and drop every existing binding for that source: `bindings[:] = [b for b in bindings if b['source'] != source]`. The kit has already checked that the new receipt binds the current file.

**4. Medium-low: the connectivity check will flag `Weighting.grammar_widens_iff_every_positive`.**
- **Cause:** this theorem (tree `Weightings.lean:1186`) is used by nothing. Its statement (`«广»`, `admittedOn`, `Positive`, `weighed`) and its proof never reach the base. It will therefore be reported as an unexplained "apart root" by `THEOREM-CONNECTIVITY.py --check`, the same way `Weighting.mixedOn_iff` and `Weighting.WidensOn.not_reverse` were. Those two now have entries in `THEOREM-CONNECTIVITY-APART.json:4245` and `:4255`.
- **Gap:** neither `integrate_u3.py` nor `make_records_u3.py` registers it. U2 used `register_u2.py` for exactly this.
- **Fix:** add an entry for `Becoming.Weighting.grammar_widens_iff_every_positive`: module `Becoming.Weightings`, category "support" or "restates", reason "widening over a listing on the grammar is what every positive weighting ranks higher". Then confirm with the connectivity run.
- The five theorems in SignificanceStatements reach the base through `Web.paths`, so they need no entry.

**5. Medium-low: the kit's check that the review names each theorem is weaker than the registry's.**
- **Cause:** `make_records_u3.py:61-64` accepts the name anywhere as a whole word. The registry requires it inside backticks, qualified or not (`registry.py:397`).
- **Effect:** a review that names an item's theorem without backticks passes the kit, then fails the research check with "its review … does not name …".
- **Fix:** use the registry's pattern, `` r'`(?:[^`\s]*\.)?' + re.escape(short) + '`' ``.

**6. Low-medium: `kit/study_u3.txt` still describes the old plan.** Lines 6-8, 31 and 32-33 still say six F5 items, "F5's verification of the six items", and "F5 counts them in its third count". That contradicts the current `laws_u3.py` and DESIGN §3, where only three are items and rows 1, 8 and 9 stay in F5's fourth count. Fix: rewrite those lines for three items and three specializations with no item. Row 10's Delta line should also gain "additive natural-number weights", as its law text now has.

**7. Low: rows 1 and 9's law texts say more than their declarations show.**
- **Uncited identification:** both texts say the condition *is* `«续无外»` (`laws_u3.py:17-19`, `:34`). That is GS2's `ownClosure_unrestricted_iff_noOutside`, which the proofs use but neither law lists (`:16`, `:33`). The statement of `noOutside_iff_paths_livingSignificance` does not mention `Unrestricted`.
- **Dropped hypothesis:** row 9's text puts "retaining and adding" among the readings of one predicate with no condition. In the Lean that part is the third conjunct and holds only under `«续无外»`. Law 7 of the same record says "under the condition".
- **Fix:** add `Becoming.ownClosure_unrestricted_iff_noOutside` to both laws' declarations; it goes through the same GrammarScope reference and is cited nowhere else in these records. In row 9, write "and, under «续无外», «广» is retaining and adding from each standpoint", with the matching change in Chinese.

**8. Low: two pieces of wording still describe all six forms the old way.**
- The regions.json note (`make_records_u3.py:217`) says "on their own carriers" for all six.
- The history note (`:166`) calls every added law "a restatement", including the three specializations.
- Fix: "rows 5, 7 and 10 on their own carrier, rows 1, 8 and 9 at the structural reading", and "a restatement or a specialization, not a derivation".

**Before landing:** `REVIEW-U3-LEAN.md` does not exist yet, but DESIGN.md:64 and `study_u3.txt:3` link to it. It has to be saved before the link check runs. If this report becomes that file, the item names below are already in backticks, as the registry requires.

### Each theorem checked

- `noOutside_iff_paths_livingSignificance`: no defect in the Lean. Law text: finding 7. Kit: finding 1.
- `paths_extension_iff_grammar`: no defect. It states the same thing as its row, with the same binders, F5 item, model `own`.
- `paths_comparison_grammar`: no defect. It holds for every reading of `living`, F5 item, model `own`.
- `widens_iff_retains_adds_root`: no defect in the Lean. Label: finding 2. Kit: finding 1.
- `paths_one_object_root`: no defect in the Lean. Law text: finding 7. Label: finding 2. Kit: finding 1.
- `grammar_widens_iff_every_positive`: no defect in the Lean; Weightings gains this one theorem and nothing else. Connectivity: finding 4. Binding: finding 3.


## 3. How each finding is taken

- **Astra 1 (high), taken.** F5's spec says it outright: "An instance or a specialization of a row states less than the row, so it is not an item". `noOutside_iff_paths_livingSignificance`, `widens_iff_retains_adds_root` and `paths_one_object_root` fix significance at the structural reading (`selfAscribed (ownClosure rel) center`), so each is a specialization of its row. They land as ordinary laws in their rows' records, each saying it is a specialization, with no F5 item, under the label *At the structural reading*. Only `paths_extension_iff_grammar`, `paths_comparison_grammar` and `grammar_widens_iff_every_positive`, which keep their row's full generality, carry items (model `own`). The design's §3 is corrected to match.
- **Astra 2 (medium), taken.** The three laws stating the acyclic boundary now cite `Becoming.«续无外则同一中心»` (GrammarScope), and the kit adds its proof reference and binding.
- **Astra 3 (low), taken.** Row 10's law text, in both languages, now names a finite list, two-valued admission and additive natural-number weights positive on every listed item.
- **Opus 1 (blocking), taken.** The kit collects its modules from every declaration a law cites, GrammarScope included. Its usage line says that `--caps` reads the package's sources, so it runs after `integrate_u3.py`.
- **Opus 2 (medium), taken.** The labels follow 08 §2, as GS2's laws do in 07 §4.5. Row 8's root form is **Conditional** (the root's condition at the one, the own-closure reading). Row 9's is **Theorem** (World) **and Conditional** (the same). Row 1's, an equivalence with no hypothesis, stays **Theorem** (World).
- **Opus 3 (medium), taken.** For each source a law cites, the kit drops every earlier binding, as U2's kit does. The new receipt binds the current file.
- **Opus 4 (medium-low), taken.** `kit/register_u3.py` registers `Weighting.grammar_widens_iff_every_positive` as an apart root (support, as `Weighting.mixedOn_iff`), from the connectivity check's log. It stops on any other unregistered root.
- **Opus 5 (medium-low), taken.** The kit's guard is now the registry's: the review names each theorem in backticks. This page does.
- **Opus 6 (low-medium), taken.** `kit/study_u3.txt` now gives three items and three specializations, and row 10's additive natural-number weights.
- **Opus 7 (low), taken.** The laws of rows 1 and 9 cite `Becoming.ownClosure_unrestricted_iff_noOutside` (GS2), which identifies the condition with `«续无外»`. Row 9's text says that retaining and adding read the predicate only under `«续无外»`, in both languages.
- **Opus 8 (low), taken.** The regions note and the history note say "rows 5, 7 and 10 on their own carrier, rows 1, 8 and 9 at the structural reading" and "a restatement or a specialization".
- **Both readers.** Neither found a defect in the Lean. The six statements, their proofs through their rows, the empty axiom reports and the one theorem added to `Becoming.Weightings` stand as built.
