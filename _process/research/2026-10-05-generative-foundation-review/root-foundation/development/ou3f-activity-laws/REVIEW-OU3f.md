# OU3f: independent read-only review

One review, 29 October 2026, by a separate AI agent working read-only. It was the reviewer of OU3d and OU3e. It edited no file in the repository and ran its Lean checks in scratch; the checks are now kept in `checks/`. It read [AUDIT.md](AUDIT.md), [TABLE.md](TABLE.md) and the data as they stood before its findings were taken; what was taken is in AUDIT.md, *The review, and what was taken*. The findings are reproduced below as the reviewer gave them, lightly formatted.

## Findings, most serious first

1. **Closure is never considered, and it hides about six (a) cases.**
   - **Precedent:** EC6's audit put lemmas that prove invariance "by their own induction on the step count" in (a), as cases of closure, and EC6b derived them through `Invariant.reach` with `Run.reach`.
   - **The same pattern in OU3f's "(c) model: short inductions with no grammar law of their shape":**
     - a region every step keeps: `Web.inactive_of_not_arising`, `Web.active_before`, `Web.ended_for_good`;
     - a bounded region: `Web.active_back`;
     - presence kept by the backward step: `Web.ByPassing.present_earlier`, of which `present_of_le` and `empty_stays` are single applications;
     - an equality kept on a held stretch: `Web.steady_held`, which is bounded at both ends; check it.
   - **Feasible:** the reviewer re-proved `inactive_of_not_arising` and `active_back` this way, with a clock run `⟨id, fun _ => (), fun _ => rfl⟩` and no induction. The statements match the real ones, and the axiom reports are empty. At WRT's occurrence model this clock is the names' step, with activity as a partial identity: the brief's frame.
   - **Fix:** add closure to the candidate laws and move these rows to (a), or state why EC6b's precedent doesn't apply.
2. **The Lineage bridge is false at `k = 0` and doesn't give `origin`.**
   - **False at 0:** `Lineage M g 0 h` is `h = g`, with no activity, while the right side requires `W.active M g`. `lineage_iff_line` is stated for `k + 1` for this reason.
   - **No `origin`:** `«迭之定前»` needs no merge anywhere, but `noMerge` holds only from `M` on. Converting to a restricted relation is a further induction.
   - **Fix (compiled):** bridge instead to `x y ↦ «续» (continuationStep R) activityClass x y ∧ M ≤ x.1 ∧ active x.1 x.2`. That holds for every `k`, `0` included, and then:
     - `unique` is `«迭之定»`, from `noSplit`, with no closure argument;
     - `origin` is `«迭之定前»`, from `noMerge`;
     - for `split` and `through`, the bridge must also fix the endpoint's step (`y.1 = M + k`), or B1's middle point can't be read back as a lineage from `M + j`.
3. **Three of the ten (a) rows are not derivations.**
   - `cons`: its induction, putting a first step onto a lineage built last step last, is the bridge's own induction through `«迭之末步»`. `«迭之接»` at one step is `«迭»`'s definition. The induction moves into the bridge rather than being replaced, so this is representation.
   - `ends` and `lineages_apart` contain no induction. They only apply `through`/`unique` and `split`/`origin`, so they reach the grammar unchanged once those do.
   - So (a) is 7 before the closure cases, and the Summary's "4 wait on two laws" should be 6.
4. **B2 as stated can't serve `Lineage.back`.**
   - **Why:** its hypothesis covers only steps from `M` on, so an occurrence at `M` need have no predecessor, and the unbounded hypothesis fails.
   - **Fix (compiled):** state B2 bounded, `(∀ k y, k < n → «迭» R k x y → ¬¬ ∃ z, R y z) → ¬¬ ∃ y, «迭» R n x y`. The audit's form follows in one line.
   - **The positive form on the grammar's own term:** `«不穷» R E x → ∀ n, ∃ y, «迭» («续» R E) n x y`. The web lemma `reaches_onward` already proves it by its own induction, and the MapInstances "(a), done" rows rest on it, so B2 is shared by more than the four lineage laws.
   - **B1:** B1 and the converse law are right, constructive and missing. `«迭之末步»` is B1's `n = 1` case. In `«迭之接»`'s order B1 is the exact converse and needs no arithmetic, while `split` wants the stated order; say which.
5. **A central declaration is among the 436.** `CensusWebs.keep_pace` is in COVERAGE's dissolution row, and the measure reports it as "balance, represented". The audit files it as "(c) model: counting" and says none of the 436 is central. Correct both.
6. **The field-free rows.**
   - **Anchors:** all 13 check out in the dump.
   - **Balance:** six of them, through `coming_recurs_iff` and `Listed.coming_of_ceasing`, reach the prelude's `balance_over_stretch_on`. `Listed.coming_of_ceasing` is itself central and "balance, represented". Like the census rows, they rest on balance (represented), so "not a grammar law" undersells them.
   - **Not (b):** "stated once, below" is a reason about rule 9, not about (b)'s definition. Call the other seven "(b), not proposed", or say why the grammar can't state them.
   - **Errors:** `Web.arising_recurs_iff`'s note says "see B1", but B1 is the split of steps. Its anchor `Change.coming_recurs_iff` is not a Lean name.
7. **`sample_arises` and `sample_ceases` are misfiled.**
   - **Where they belong:** each is one application of the field-free `arises_within`/`ceases_within`, so by the audit's own scheme they are "field-free law below", not "the index re-read".
   - **The reason given doesn't hold:** «两端分则中有标» "finds a change but not its direction" only as stated with a class, and its docstring says only transitivity is used. With the transitive relation "holds later → held earlier" it gives the direction, so `arises_within` would be its case: a (b) candidate.
8. **The MapInstances "(a), done" rows overstate their reach.** In GrammarMap they reach only `«所及之传递»`, plus core line laws, not "the map's laws". Four anchors read "GrammarMap", which is not a law. Name the law for each, and decide whether a lemma used inside an instance theorem makes the row a case of it.
9. **Apply "small" consistently.** `begins_passed_by_grammar` replaces only the one-token contradiction `absurd before begins.1`, through two representation lemmas. That is as small as `sheng_state_of_change` and `wang_state_of_change`, whose proofs already inline the coarse-to-fine law as the destructuring `⟨alike, _⟩`. All three are genuine by the test but trivial; count them the same way.

## Checked and holding

- **Counts:** 436 classified; 388 whose upper bound is `active` alone; 30 proofs reaching a grammar theorem, 15 of them directly; 74 statements naming a grammar term. The categories sum to 436.
- **The twins:** `Continuing.mono_by_reach` and `passes_within_by_line` are genuine; the law does the induction or the search. The reason for keeping `trace` in (c) holds: it would need deciding sameness of formations.
- **WRT2:** every (a) row is a web theorem at `Nat × F`. Add one sentence saying the derivations use OU3a's class reading, which agrees with activity as a partial identity on lines from an active occurrence.
- **The sampled modules:**
  - the Wholes "combinations" reason holds;
  - Sampling, Population and ContextualRuns read as classed;
  - there is no other hand-done coarse-to-fine step and no other central row.
- **Witnesses:** six witnesses reach grammar laws and stay witnesses. That is defensible; say so.

## Verdict (the reviewer's)

Not ready for proposals. Five changes are needed:
- add the closure family;
- restate the Lineage bridge;
- restate the (a) count;
- restate B2 in bounded and «不穷» forms;
- correct the central row.

The rest is wording.
