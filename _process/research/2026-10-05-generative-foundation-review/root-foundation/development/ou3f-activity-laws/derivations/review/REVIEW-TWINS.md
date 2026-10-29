# Review: OU3f derivations, the three twins

AI-written independent review, 29 October 2026, of `derivations/tree/` against the package on branch `ou3f-laws` (4cab8ba91). Line numbers are the tree's unless a file is named.

**Verdict: ready after the listed fixes.** Fix 1 is needed before landing, fix 2 is recommended for this part, and fix 3 is wording.

## Findings

1. **A live record and its home section cite the two retired PatternPassing names.** The design says no record cites them (DESIGN.md lines 12, 17). But `theories/becoming/results/records/a-pattern-lasts-through-passing.json` names `ByPassing.passes_within_by_line` and `ByPassing.begins_passed_by_grammar` in law 5's declarations (lines 74–75), its aliases (138–139) and its proof reference (199, 204).
   - After landing, `research-check` fails in `tools/research/registry.py` with "declaration not found" (579), "declarations not elaborated" (606) and "alias not elaborated" (615).
   - `theories/becoming/chapters/04-LIFE.md:50` (§`r-a-pattern-lasts-through-passing`) cites both names too.
   - **Fix:** in law 5, put `Becoming.Web.ByPassing.passes_within` and `…begins_passed` (already declared in the reference) in place of the twins, and write "are proved from grammar laws" (en, zh). Drop the two aliases and the two reference entries. Cite the kept names in 04-LIFE.md:50, correct the design, and re-render.
   - `mono_by_reach` has no live consumer.

2. **Missed: `ByPassing.ends_within` is a fourth case of the same kind.**
   - Its proof (165–179) is the old `passes_within` argument: trace a carrier back with `trace`, then contradict `brief` at the start or `stopped` at the passing.
   - Its conclusion is a negation, so the reason `trace` stays in (c), that it would need deciding sameness of formations, does not apply.
   - `checks/tree/Becoming/ReviewTwinsMissed.lean` proves its exact statement through `line_back`, `«两端分则中有标»` and `«线内同类»`, without `trace`. An `example : type_of% @…ends_within` checks that the statement is the same. It compiles with an empty axiom report.
   - The audit files it as "(c) model, counting over steps". The header's *Not connected* paragraph (336–340) says it reads "presence at a step, which is not a grammar term", yet the re-proved `passes_within` reads presence at steps too.
   - **Fix:** re-prove it in this part, which leaves `trace` with no theorem consumer, or record it as the next derivation. Either way, correct the audit row and that header sentence.

3. **Wording.**
   - `passes_within` also uses `«线内同类»` (498), but its docstring (470–476) and the header (327–331) name only `«两端分则中有标»`. Name both, as the audit does.
   - The ContinuedClasses module header (35–41) still lists `consumingAlong_mono` and `renewingAlong_mono` under tenure and undermining. That is true, but they now sit in the last section.
   - PatternPassing lines 331–333 were not re-wrapped (109–113 characters).

## The six checks

**1. Derivation, not rerouting: holds for all three.**
- **`Continuing.mono`.** `«及之单调»` does the induction that carried each step from `R` to `S`. What remains is `continuing_iff_line` in both directions, each at a single relation: `Continuing.line` (686–695) and `line_continuing` (an induction on 及, 668–683), plus a one-step map. The representation is applied and undone around the law. The old proof is not inside.
- **`passes_within`.** `«两端分则中有标»` replaces `trace`'s search for the passing. What remains is `line_back` (453–468), with its own induction: it builds the line through both cases of the premise, searches for nothing and does not use `trace`. The rest is `split`, `«线内同类»`, `line_advances` and arithmetic.
- **`begins_passed` (small).** The law (Grammar.lean:697–699, a one-line unfolding of 生) supplies `apart`.
  - The old `absurd before begins.1` now runs inside `arises_iff_sheng_carrier.mp` (392–394).
  - The old two-way split returns as the match on `kind` (529–531). That match is `passesAt_of_alters`'s body, inlined because `PassesAt` forgets the receiver.
  - `apart` is used, not undone.

**2. Statements unchanged: confirmed.**
- **Source text.** The five statements are byte-identical to main's, including `∀ {t g u h}` after the colon.
- **Printed statements.** `checks/{main,tree}/Becoming/ReviewTwins*.lean` run `#check` on every declaration of both modules (outputs in `checks/main.out`, `checks/tree.out`). All 143 shared declarations print identically, and only the three twins are missing from the tree.
- **Section variables.** The moved theorems now sit under `variable {W} {R}` (665) and `{V} {passes}` (365), instead of `(W) (R)` with `{W R}` (333, 351) and `(V)` with `{V} {passes}` (90, 106). They print the same binders in the same order.
- **Binder names.** The twins printed differently (`continuing`, `byPassing`), so keeping the originals' names was needed.

**3. Retired names.** No Lean module uses them; the ou3-lifting trees are frozen workspace copies. `THEOREM-CONNECTIVITY.json` lists all three, but it is regenerated at landing. `THEOREM-CONNECTIVITY-APART.json` lists none. For the record and the chapter, see finding 1.

**4. Docstrings and headers.** They are accurate apart from fix 3, and the last-section header (643–645) is right. "Of the grammar" is right: the law is at Grammar.lean:669, and OU3a (46a72f71f) moved it down from PatternPassing, leaving "stated here" stale.

**5. Anything missed.**
- `ends_within`: see finding 2.
- **`Continuing.itself_same` (weaker).** It reads activity, and the same check file derives it through `continuing_iff_line`, `«及之单调»` and `«线内同类»` under the one-formation class. The audit calls it a fact of the names.
- **`Linked.mono`.** It derives through `linked_iff_line` and `«及之单调»` (compiled), but it reads no activity, so it is out of scope. Re-proving it would move it, with `underminingAlong_mono`, `IncludesAcross.mono` and `ExceedsAcross.anti`.

**6. Build.** I used `scratch_build.py`. Every axiom report is empty and there were no warnings:

| module | theorems | declarations | how built |
|---|---|---|---|
| ContinuedClasses | 73 | 98 | reused |
| PatternPassing | 32 | 45 | recompiled: its final bytes postdate `scratch-1.log` |
| ReviewTwinsMissed | 3 | 3 | compiled |
| MapInstances | 26 | 26 | compiled against the tree |
| WorldRepresentation | 34 | 48 | compiled against the tree |
| EventualWidening | 24 | 36 | compiled against the tree |
| KeepingWidening | 126 | 154 | compiled against the tree |
| EventualWideningInstances | 82 | 106 | compiled against the tree |
| ReachableRanges | 135 | 196 | compiled against the tree |

The root module was not built. The counts match the design, and no importer uses a changed or retired name.

Left in `review/checks/`: byte copies of the two tree modules (sha256 `216036d5…`, `d68c59b8…`) and gitignored `.build/` folders. I did not delete them.
