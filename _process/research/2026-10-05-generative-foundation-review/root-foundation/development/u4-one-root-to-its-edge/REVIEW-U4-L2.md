# Review of U4, lever 2 (audit and scratch), adversarial

Reviewer: independent, read-only. Worktree `wt-u4`, branch `u4-edge` at `2d727a707`.
- Audit: `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u4-one-root-to-its-edge/LEVER-2-AUDIT.md` (114 lines), cited below as "audit l.N".
- Scratch: `…/lever-2-scratch/Becoming/U4LeverTwo.lean` (421 lines), cited as "L2:N".
- Package: `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.

The checks I ran myself used `lean --stdin` against the lever-2 build's oleans (Init only where noted), so no file was written. They are quoted where they carry a finding. Their `propext` (from `simp`/`omega`) is mine, not the scratch's.

## Verdict

**Sound with fixes.**
- **The scratch is correct.** It builds (42 theorems in 61 declarations, every axiom report empty), and every theorem says what the audit says it does.
- **The rows are right.** The 18 rows are taken correctly from the measure.
- **No F1 circularity.** No row's inclusion hypothesis is its conclusion restated.
- **One blocking finding: the §0 tally.** The audit says 11 rows "wait on lever 1". That is wrong:
  - Six of the 11 read support or dissipation, not balance.
  - The gate's second part is already an inclusion in the package (U2's `ModelStatements.dependent_iff`).
  - Row 5 needs only "coming to stand is given to".
  - Row 4 is a law of logic, and U2 already states both its halves as inclusions.
  - After lever 1's F1/F2, lever 1 puts no amounts on the root, so nothing moves by waiting on it.
- **The "seven on the root" side needs fixes.**
  - Rows 13 and 14 rest on a stronger hypothesis than they use. The weakest is a count equation, not an inclusion.
  - Row 14 has no Lean in its root form.
  - Row 17 is mislabelled "derived".
  - §2's "derived" for laws of counting needs a separate label.

## Findings

### B1 (blocking): the tally "11 wait on lever 1" (audit l.11, l.21, l.31–47, l.50, §5)

**What is wrong.**
1. **Rows 1, 2, 3, 7 and 8 do not read balance.**
   - Their hypotheses are `Acting`, `Dependent`, descent and transmission:
     - row 3: Evolution.lean:231;
     - row 1: Evolution.lean:242;
     - row 2: Evolution.lean:291;
     - rows 7 and 8: SelectionTerm.lean:670, :682.
   - Lever 1 is about balance. It supplies nothing for comparing need with level.
   - Row 9 (Reproduction.lean:561) reads dissipation, not balance.
   - These six keep U1 §4's standing ("premise of the account"). Lever 1 changes nothing for them.
2. **The gate's second part is already an inclusion in the package.** U2 landed:
   - `ModelStatements.dependent_iff` (ModelStatements.lean:144): `V.Dependent ↔ «则» («而» (partialIdentity activeAt) requiring) needMet`;
   - `supported_iff` (l.136), on `needMet` (l.124), which is need ≤ level read as a relation.

   The audit reads `gives` (the sign of a `Nat` give, L2:373) as a relation on the root, but treats `needMet` (a `Nat` comparison read as a relation) as waiting on amounts (audit l.50, l.93). Both are relations read off the model's amounts. Either both are at the represented model or neither is. With `acting_iff` and `dependent_iff`, rows 1–3, 7 and 8 have the whole gate as inclusions now, as row 17 does. What remains of their content is a comparison of the model's amounts in the conclusion. That is the same situation as rows 13 and 14 (see S1).
3. **Row 5 (`Flow.no_new_dependence`, Transmission.lean:531) needs only that coming to stand is given to.** It uses balance only through `descends_of_comes` (l.500) and `BalancesOn.rise_given` (Flow.lean:464). I checked a weaker form (no axioms):
   ```lean
   theorem no_new_dependence_of_given (given : W.ComesToStand t x → ∃ g, L.DescendsAt W t x g)
       (inherits : ∀ g, L.DescendsAt W t x g → W.requires (t + 1) x c → W.requires t g c)
       (none : ∀ g, g ∈ L.present t → ¬ W.requires t g c) (comes : W.ComesToStand t x) :
       ¬ W.requires (t + 1) x c
   ```
   `given` is an inclusion: coming to stand lies within being given to by something present. Balance is one sufficient condition for it.

   The audit's §5 (l.102) route goes through the census, "units arising … are counted in what is given". That is lever 1's bridge equation, which lever-1 F1 found to be balance restated. So row 5 is reachable now, under an inclusion, and does not wait on lever 1.
4. **Row 4 (`Web.transmits_at_iff`, Transmission.lean:169) waits on nothing.**
   - Its statement is the propositional law `(A → B ∧ C) ↔ (A → B) ∧ (A → B → C)`. The proof reads `need ≤ need + δ` only as an opaque proposition.
   - U2 already states both halves as inclusions: `inheritsAt_iff` (ModelStatements.lean:301), `needsWithinAt_iff` (l.321), `transmits_at_one_kind` (l.336).
   - "The half on need waits on lever 1" (audit l.20, l.34) is wrong.
5. **Rows 10, 11, 15 and 16 do read balance** (`BalancesOn`/`Balances` with stock, uptake and replenishment). After lever 1's F1/F2 (accepted), lever 1 represents balance at a step and puts no amounts on the root. These rows keep "balance, represented" with U1's reason. They do not "wait".

**Fix.** Re-tally:

| Rows | Standing |
|---|---|
| 4 | Law of logic; at the model already (U2) |
| 6, 12, 18 | Counting (§2's decision) |
| 13, 14, 17, 5 | At the model under stated hypotheses, witnesses pending (S1–S4) |
| 1, 2, 3, 7, 8 | Gate fully as inclusions (`acting_iff`, `dependent_iff`); conclusions compare model amounts |
| 9 | Premise of the account (dissipation; U1 §4's injection) |
| 10, 11, 15, 16 | Balance, represented, unchanged |

Also:
- Drop "waits on lever 1" throughout, and rewrite §5 as what amounts on the root *would* need, with U1's verdict standing.
- WHAT-REMAINS:258 already expects "the gate rows … become hypotheses on the root". Say that this is now possible for both parts of the gate.

### S1 (should fix): rows 13 and 14 rest on a stronger hypothesis than they use (audit l.14–19, l.44–45, l.69)

This answers question 3. **It is not the F1 pattern.** No inclusion is the conclusion restated, and the descent relation and the class come from the row's own lists and trait. But:
- **Exactness is more than row 13 uses.** `SelectionLevels.rises_exact_iff_levels` (SelectionLevels.lean:553) goes through `Generations.raises_exact_iff` (SelectionTerm.lean:623), which uses exactness only to make `raised = lowered`. Cancellation is enough. I checked (no axioms):
  ```lean
  theorem rises_cancel_iff_levels (G : Generations α) (gs : List (List α))
      (listed : whole gs = G.family t) (equal : ∀ g, g ∈ gs → g.length = m)
      (cancel : G.raisedAt t = G.loweredAt t) : G.Raises t ↔ <the row's levels side>
  ```
  - By the audit's own `totals_iff_cancel` (L2:265), cancellation is strength (3), equal totals. That is "read on counts" (audit l.75). Swap-type generations (`raised = lowered = 1`) meet the row's equivalence without exactness.
  - So "the witness that exact transmission is needed" (audit l.19) overstates. `Raised.levels_fail` (L2:358) shows only that the hypothesis cannot be dropped altogether. In `Raised`, `raised = 1` and `lowered = 0`, so even cancellation fails.
  - The inclusion `«则» D («续» D E)` is one sufficient condition. It is not what the row needs.
- **The "continuation" form adds nothing beyond "within the class".**
  - `within_iff_continues` (L2:73) holds for every `R` and `E`: `«则» R E ↔ «则» R («续» R E)`.
  - `exact_iff_within` (L2:78) is `Exact` unfolded (`subst; symm`). The class is the kernel of a `Nat` map.
  - This is U2's kind of statement, "a representation, not a derivation" (ModelStatements.lean:36). Say so rather than "the central reading checks out" (audit l.23).
- **Row 14 is not a statement of inclusions, and it has no Lean.**
  - Its `inactive` hypothesis (GroupEnding.lean:281–289) compares sums of trait values across groups. `listed` and `equal` are list equations.
  - No scratch theorem states row 14 from the inclusions. Only row 17 has one (`all_end_on_root`).
- **Rows 13 and 14 depend on §2.** Their conclusions are `Nat` inequalities over products and sums of trait and offspring numbers, so their standing "on the root" depends on §2's decision.

**Fix.**
- State the weakest hypothesis for rows 13 and 14 (cancellation, equivalently equal totals). Present exact transmission as continuation as one sufficient condition.
- Re-word "needed" as "cannot be dropped".
- Add a one-line `rises_iff_inactive_on_root` from `acting_iff`, `listed_within_gives` and `offspring_zero`'s argument, or mark row 14 argued.
- Make rows 13 and 14's standing conditional on §2.

### S2 (should fix): §2, counting laws as "derived" (audit l.54–58)

1. **The dependency check.** The audit says it was not run (l.5, l.109). I ran it on constants for rows 6, 12 and 13:
   - `covariation`, `levels_sized` and `rises_exact_iff_levels` reach no `Becoming.Flow.*`, `Becoming.Web.*` or `Becoming.World.*` constant.
   - Their model-module constants are arithmetic only:
     - `excess` (Change.lean);
     - top-level `total_*` lemmas placed in Flow.lean;
     - `total_const` (Evolution.lean);
     - `GrammarLaws.total_congr`.
   - So they meet the convention in substance and miss it by file placement only. The convention is WHAT-REMAINS, correction note: "name nothing beyond the grammar and the prelude, so they are on the root already". Moving `excess` and those lemmas to the prelude would close the gap.
   - Row 18 (`Drift.falls_back`, Drift.lean:232) is unchecked. Drift imports Typicality, Identification and Weighted.
2. **"On the root" is not standing 1.** The convention cited says "on the root". Standing 1 is "Derived: it follows from the grammar's laws, for every relation and class" (WHAT-REMAINS:225). These rows follow from no grammar law.

**Fix.** Give laws of counting a label of their own ("a law of the second sort's arithmetic, for every family and every map to `Nat`"), and count them apart in MV, as F5's statements at a model are. Then state the line that keeps F13 coherent: counting laws quantify over every map, while balance reads a model's levels. Leave the choice to U4's owner, as the audit does, but drop "count … as derived".

### S3 (should fix): `Unexact` "(3) without (2)" is prose only (audit l.80, L2:136–153)

The scratch proves equal totals and ¬exact for `Unexact`. It does not prove that `Unexact` has no pairing under the trait's class, which is what "neither step reverses" needs. I checked it with lever 1's region-count argument: the class "trait = 1" holds the parent twice before and nothing after.
```lean
theorem unexact_not_paired :
    ¬ «对» (alike (trait Unexact.a Unexact.b)) (before Unexact.kids Unexact.ps) (after Unexact.kids Unexact.ps)
```
It checks, with `propext` and `Quot.sound` from `simp`/`omega`. A core proof would use a structural count lemma.

**Fix.** Add the theorem.

### S4 (should fix): row 17 labelled "derived" (audit l.47), and standing 2 needs its countermodel

- §1 says row 17 is "derived on the root", while §0 l.14 puts it among the rows "on the root under hypotheses". `all_end_on_root` (L2:414) takes `Acting` and `Descended` (as inclusions) as hypotheses, so it is standing 2, not standing 1.
- Standing 2 requires a countermodel showing the hypothesis cannot be dropped. For the gate it is not built (audit l.19, l.106).

**Fix.** Label row 17 standing 2, and count it as pending until the witness is built.

### S5 (should fix): known package results not cited

- **`ModelStatements.dependent_iff`, `supported_iff`, `needsWithinAt_iff`, `inheritsAt_iff`.** See B1.
- **`«对之单调»` (GrammarLaws).** It closes (1) ⇒ (2) now, without lever 1's tree (audit l.108 says the join waits). I checked, with no axioms:
  ```lean
  theorem exact_paired_class (exact : SelectionTerm.Exact ps kids a b) :
      «对» (alike (trait a b)) (before kids ps) (after kids ps) :=
    «对之单调» (fun _ _ r => r.2) (exact_pairs exact)
  ```
- **`GroupEnding.Flow.inactive_childless` and `offspring_zero`** (GroupEnding.lean:197, :234). `size_zero_of_within` re-proves their content from the inclusions. Cite them.
- **`Transmission.descends_of_comes` and `Flow.BalancesOn.rise_given`.** These are row 5's only use of balance.
- **`Generations.raises_exact_iff`** (SelectionTerm.lean:623). This is where row 13 uses exactness, and only as cancellation.

### S6 (should fix): unstated modelling assumptions

§7 (audit l.114) names one step, `Bool × α`, `Nat` amounts and `List`. Also state:
- `gives` reads the sign of a `Nat` give, and `activeAt` is a partial identity.
- The trait's class is decided by `Nat.beq` (`alike_decided`).
- `before` lists each parent once per offspring, the multiplicity that makes `selected` appear.
- Generations' lists may repeat members.
- `descent` is built from the Generations' lists, not from the World's `Flow.DescendsAt`. Row 13 has no World at all. Rows 14 and 17 join the World only through `Descended`.
- `listed_within_gives` drops `DescendsAt`'s "comes to stand" part.
- Formations and conditions are one type (`Flow X X`).

### M1 (minor): wording and provenance

- Audit l.82 says "the landed `offspring_eq_selected_of_within`". It is a scratch theorem; no package declaration has that name.
- The scratch-build log's `tree` is the other session's `wt-l2` path. I rebuilt it here (see below).
- Audit l.65 says "This is the root's definition of continuation read along descent". It would be more exact to say it is `within_iff_continues`, true of every relation.

### Lever 1, U4Bridge against F1.2 (asked if time)

- **F1.2 is resolved for membership on a closed step.**
  - `arising_iff_begins` and `ceasing_iff_ends` (scratch/Becoming/U4Bridge.lean:74, :93) give `f ∈ arising ↔ f ∈ after ∧ «生» R E f`, and the same for ceasing and `«亡»`.
  - Their hypotheses: a Bool `k` deciding `«续» R E`, and closure (every predecessor of a unit after is listed before; every successor of a unit before is listed after).
  - `unlisted_predecessor` (l.115) shows that closure cannot be dropped.
  - `census_on_continuation` (l.60) states the pairing under `«续» R E ∨ =`.
- **Remaining points:**
  - `«定后»`/`«定前»` are global on `«续» R E`.
  - The length equalities follow from membership with `Distinct`, but they are not stated.
  - F1.1 and F1.3 are untouched. The World's levels, given and taken are still equated to list lengths by hypothesis, and the units are a listed carrier, not a World's occurrences.

## What I checked and found right

- **The 18 rows.** The measure's rows with `row == "evolution"` in `gw-generation-and-widening/measure-grammar-after.json` are exactly the audit's 18, in the same order, with the same measure categories.
- **Each row's statement and proof**, read in the package:
  - rows 1–3 (Evolution.lean:231–299);
  - rows 4 and 5 (Transmission.lean:169, :531);
  - rows 6, 7 and 8 (SelectionTerm.lean:248, :670, :682);
  - rows 9–11 (Reproduction.lean:561, :645, :684);
  - rows 12 and 13 (SelectionLevels.lean:266, :553);
  - rows 14–17 (GroupEnding.lean:281, :206, :330, :377);
  - row 18 (Drift.lean:232).

  The audit's "what it reads" column is right except for rows 4 and 5 (B1). Its "premise of the account because of the gate" is right as a description.
- **Builds**, both with 0 failures, 0 unclean, and steps reused from the shared cache:
  - `python3 -B scratch_build.py <lever-2-scratch> Becoming.U4LeverTwo`: 42 theorems in 61 declarations, `with_axioms: {}`;
  - lever 1 by name (`U4Scratch` 43/51, `U4Repairing` 15/18, `U4Bridge` 6/7): `with_axioms: {}`.
- **Theorems that say what the audit says:**
  - `exact_iff_within`, `exact_iff_continues`, `exact_iff_terms_vanish`, `offspring_eq_selected_of_within`;
  - `Unexact.totals_alike` and `Unexact.not_exact`;
  - `exact_pairs`, `totals_of_paired`, `totals_iff_cancel`, `alike_decided`;
  - `Swap.paired`, `Swap.not_exact`, `Swap.terms` (each term one);
  - `Raised.listed`, `Raised.equal`, `Raised.raises`, `Raised.levels_false`, `Raised.levels_fail`;
  - `acting_iff` (both ways), `listed_within_gives` (one way, as stated), `size_zero_of_within`, `all_end_on_root`.
- **§3's analysis is right:** exactness makes Price's two transmission terms vanish, while a pairing under the class only makes them cancel. Exact transmission as descent within the trait's class is a correct and useful reading. It is the WHAT-REMAINS lever-2 candidate, confirmed for "Price's zero transmission term".
- **Honest limits.** The audit admits the missing gate witnesses, "never lowers" (row 7), and the unchecked constants.
