# WRP: the independent review of the design

One independent reviewer, an Opus subagent working read-only, read the first [DESIGN](DESIGN.md) and its scratch check, built as [scratch-5.log](check/scratch-5.log): 24 theorems in 29 declarations. It read them against the package, the chapters and the measurement artifacts.
- It rebuilt the check from identical bytes, with the same counts and no axioms.
- It wrote a test file of its own, outside the repository: 12 theorems, every axiom report empty, one unused-variable warning.
- Its report follows, condensed; each finding ends with what was done.

Every finding was taken. The revised check is [scratch-7.log](check/scratch-7.log): 31 theorems in 39 declarations, every axiom report empty, no warning. The counts were taken again with the saved [`measure_wrp.py`](measure_wrp.py), giving [`measure.json`](measure.json). The same reviewer then re-read the revisions; its nine items are at the end, all taken. The final check is [scratch-9.log](check/scratch-9.log): 37 theorems in 50 declarations, every axiom report empty, no warning. Line numbers below are the first version's.

**Paths.** L is `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.

## What checks out

- **The Lean matches the design.** Every Lean statement the design quotes matches the check. These prove what the design says: `withMove_image_iff`, `reads_next_move`, `moves_forgotten`, `run_image`, `run_iff_image`, `trace_iff_word`, `feasible_iff_word`, `yan_iff_keepsMoving`, `run_yan`, `yan_pullback`, `preserves_iff_image`, `lifting_iff` and `class_is_claims`.
- **The counting.** 2^(n²k) and 2^(n²k²) are right for n ≥ 1.
- **The table.** The rows for reach, invariants, returning, merging nothing, determination, going alike and traces of k moves cite theorems that state them.
- **The measure.** The 988 recomputes exactly, and the most-named notions left match.
- **Names.** None of the proposed names clashes with a Lean name in the package.
- **F2's standing.** It adds no calibration, which matches 08 §5's row for dependent choice. `KeepsMoving.run` supports the finite case on processes.
- **Purity.** Every cited module is pure core at receipt `20261029T084618.786422Z`.

## Findings

1. **Error. The 2,180 that "bind no process" include 323 that hold of every frame.** They take a `Becoming.Frame` as a binder (84 in Likeness, 56 in Granularity), e.g. `Alike.refl`, `Novel.mono`, `AlikeTo.refining`. *Fix:* count frame binders, and recount with the frame notions included.

   **Taken.** Binding now means a process, or a frame only: 988 + 323 = 1,311. A frame's process, construction and claims count as bridged by definition, the claims through `Web.partialIdentity`. The coverage is recounted (§2.3).

2. **Error. Four duplicates of landed definitions.**
   - `StepsBy` is `moveRel` (L/GrammarRegularity.lean:189).
   - `claimClass` is `AlikeTo F F 0` (L/Likeness.lean:883).
   - The right side of `steps_lawProcess` is `Law.step next` (L/GrammarCourse.lean:104).
   - `Enabled P s a` is `«能» (moveRel P a) s` (L/GrammarCandidates.lean:48).

   §2.3 also contradicted itself: it counted a step as bridged while M1 proposed the bridge as new.

   **Taken.** `StepsBy`, `claimClass` and `claimClass_class` are dropped, and the check uses `moveRel`, `AlikeTo`, `Law.step` and `«能»`. GrammarRegularity is imported rather than `moveRel` moved down, so the leaf's import closure is about 100 modules. A step is counted as landed, being `moveRel` by definition.

3. **Error. "With 'the same move' among its classes … faithful" fails up to correspondence.** Correspondence is the only way grammar terms read a model (L/GrammarTransport.lean:8–11). The counterexample, checked:
   - `P₁` steps exactly from `true`;
   - `P₂` steps by `true` from `false`, and by `false` from `true`;
   - `twist` carries one model to the other and keeps the same-move class;
   - no renaming relates `P₁` and `P₂`.

   *Fix:* add the class "the same configuration", or say "faithful on the fixed carrier".

   **Taken, both ways.**
   - Faithfulness is stated on the fixed carrier (`step_iff_withMove`).
   - The twist is in the check as a witness (`Twist.models_correspond`, `Twist.not_renamed`).
   - The design says the model needs both classes.
   - That the two together make every correspondence a renaming is proposed, not checked (§1.2, F3).

4. **Error. "With one relation: yes … necessarily so, by counting" is not established.**
   - F1 shows only that the steps forget the moves, and the counting remark was about the image.
   - For finite `S` (n ≥ 1, k ≥ 2), 2^(n²) < 2^(kn²): no relation on `S` is faithful.
   - For infinite `S`, a bijection `S ≅ S × A` gives a faithful one-relation model.
   - The remark failed at n = 0.

   **Taken.** §1.2 now scopes each claim:
   - finite carriers: no relation on `S` is faithful;
   - infinite carriers: a coding exists, but it is not a reading;
   - the move inside: faithful on its carrier;
   - the image count, for n ≥ 1.

5. **Error. F4 was inconsistent with §2.1.** F4 called reading back along a map "a function, not a term", while §2.1 counted bridges that read back the same way (`goAlikeUnder_iff_alike`, `«像定后当且仅当同行»`). `sameValue` already names reading back «静». At each move, the product's relation is «合» of two relations on one carrier. *Fix:* one standard; the boundary is relating three carriers without pairing; cite `unlabelled_product_le` and `Fork.label_couples`.

   **Taken.** F4 is rewritten:
   - the product is a grammar model on `S × S'`;
   - what the grammar does not form is the relation of the three carriers, which takes pairing;
   - both landed laws are cited.

   The proposed reading-back term is withdrawn.

6. **Gap. Question 55: "faithful and full" with no morphisms defined.** "GrammarTransport keeps the listed terms" was unchecked, and the bridges read seven terms GrammarTransport does not list. *Fix:* define morphisms through `FactorsThrough` and state the functor, or drop the words; add the correspondence lemmas.

   **Taken.**
   - "Faithful and full" is dropped. The design says the moves' relations are a bijection by definition.
   - Morphisms are not defined. The functor form names the maps under which each move's relation factors, with `FactorsThrough` bridged (finding 7).
   - The seven correspondence lemmas are proposed in WRP2's Part 1, not checked.

7. **Gap. "Left" listed `FactorsThrough`**, though `preserves_iff_image` bridges it move by move. Mechanism already has `image_step_iff` and `Image.least`.

   **Taken.** `factorsThrough_iff_image` is in the check, and `FactorsThrough` and the image process are counted as bridged (§2.1, §2.3).

8. **Error. §2.1's table.**
   - Some rows state no grammar term: `Run.toWithMove`/`Run.ofWithMove`, `KeepsMoving.run` ("the same") and `same_steps_iff_traces`.
   - It omits landed bridges:
     - `moveRel`;
     - `constant_of_goAlike` and `goAlike_iff_constant` (GrammarRegularity);
     - GrammarCourse's `constant_iff_keeps`, `core_is_sameFuture`, `alike_iff_core` and `unending_iff`;
     - `image_determined_iff` (Mechanism);
     - `withinClosure_iff_closure` (EdgeClosure).

   **Taken.**
   - The table now has rows for each of these, for the deterministic laws (with `next_fixed` and `next_total`), and for frames' claims.
   - The rows without a grammar term moved to a line beneath it.

9. **Error. Part 1 called `preserves_iff_image` and `yan_pullback` "the grammar's form of `projection_exact_iff`".** That theorem states exact finite-trace representation, and they do not.

   **Taken.** They are now called its one-step and going-on counterparts.

10. **Gap. The summary left out the share.** Only 28% of the no-field theorems are on processes, and 9% bind one. So WHAT-REMAINS' premise, that the no-field layer is "taken whole" through WRP, does not hold. *Fix:* say this first.

    **Taken.** The summary now opens with it, at the current head. In the final figures (after the re-read), 3,163 of 11,409 are on processes (28%), and 1,306 bind a process or a frame (11%). Of the rest, 1,343 name nothing beyond the grammar, and 6,903 (60%) are about other structures; no part of WRP reaches those. The coordinating session is told, and OU's plan item 13 is narrowed (`2e37676f9`).

11. **Wording and standing. "Where the laws hold: answered once."**
    - `lifting_family_iff` is currying, and `stepsBy_mk`/`mk_stepsBy` are `rfl`.
    - They meet 08 §6's third requirement (representation), not its second (lifting).
    - "Lifting" already names 08 §6's restating and `Lasting.lifting`.

    **Taken.**
    - They are presented as the representation, carrying a law's truth and not its statement.
    - They are renamed `forall_steps_iff` and `forall_moveRel_iff`.
    - The `rfl` lemmas are `moveRel_mk` and `mk_moveRel`.

12. **Gap. The counts could not be reproduced.**
    - The script behind `classes2.json` was not saved.
    - The stated criterion for "on processes" gave 2,800, not 3,168: the extra 368 name `Process.step` of constructed processes.
    - The reviewer's replication gave 41/177/811 and 239 notions.
    - The counts predated OU3f's landing.

    **Taken.**
    - [`measure_wrp.py`](measure_wrp.py) is saved. Its criteria, the step included, are listed in its docstring and printed with its output.
    - It runs at OU3f's receipt.
    - The rerun found a further defect in the first count: its search for what reaches a field depended on the order of iteration over sets, so repeated runs gave 11,446 to 11,451. That search is replaced by a search along the reversed dependencies, which is exact and gives the same result under every hash seed: 11,430, and 11,409 once the re-read's item 6 drops generated recursion lemmas.

13. **Wording. F2.**
    - Only the direction from dependent choice to lines uses `runs_iff_dependentChoice`; the other direction is direct.
    - The result is for `Type` only.
    - The grammar form of the finite case was not stated.
    - The 08 quotation was about the LLPO calibration.
    - "A move chosen at each step" is countable choice, unlabelled.
    - `«不穷则迭»` was not cited.

    **Taken, each one.**
    - The directions and the universe are stated.
    - `goesOn_line_of_list` is in the check (renamed `yan_line_of_list`, the re-read's item 2).
    - 08 §5's row for dependent choice replaces the quotation.
    - Countable choice is named, with "not checked".
    - `«不穷则迭»` is the contrast.

14. **Wording. F5 asserted underivability.** It also missed that "functional and total" is landed (`next_fixed`, `next_total`).

    **Taken.** F5 now says unique choice is not assumed and that whether it can be derived is not shown, and it cites both lemmas.

15. **Wording. The header named declarations the check did not use, and an unused import.**

    **Taken.** The header lists only what the check uses, and `import Becoming.Laws` is gone.

16. **Naming.**
    - "The family of a process" clashes with 同族 and with Onward's "a family that keeps moving".
    - `reads_next_move` named the opposite of what it proves.
    - `byTrue` and `byFalse` needed a namespace.
    - By rule 9, the composite along a word belongs to the grammar layer.

    **Taken.**
    - The glossary entry is "the relations of a process, one per move (`moveRel`)".
    - The negation is `reading_next_move_not_withMove`.
    - The witnesses are in `Forgotten` and `Twist`.
    - `wordRel` is the composite of any family along a word, placed in Part 1. Deriving `«迭»` from it is proposed to `Becoming.GrammarLaws`' owner.

## The re-read

The same reviewer re-read the revisions: REVIEW-WRP.md, the rewritten design, the third check ([scratch-7.log](check/scratch-7.log)) and the measure.
- **What checks out.** It confirmed the other fixes as described. It rebuilt the check from identical bytes and reran the measure, reproducing `measure.json` exactly; every count in §2.3 matched it. The Lean quotes, the twist, the rewritten F4, and the F2 and F5 fixes were accurate.
- **Its second test file** built with 6 theorems, every axiom report empty. Its two checks are now in the scratch check.

It found nine items.

1. **Error. "The other 8,262 (72%) are about other structures" counted what needs no reaching.**
   - 1,348 of them name nothing beyond the grammar: 950 name no Becoming constant, and 398 grammar terms only.
   - 694 sit in the grammar's own modules and the Prelude.
   - The summary's "largest groups" skipped GrammarLaws, Prelude and GrammarPath.

   **Taken.** The measure reports the split and the top modules beyond the grammar. In the final figures, 1,343 name nothing beyond the grammar (950 and 393), and 6,903 (60%) are about other structures; the design lists their modules as `measure.json` gives them.

2. **Naming, new. `goesOn_*` clashed with the landed `GoesOn`** (HistoryIdeals: an ideal with members beyond every horizon). `run_goesOn` already names two landed theorems.

   **Taken.** The names keep the package's pinyin stem, as `arises_iff_sheng` and `ceasesToBe_iff_wang` do: `yan_iff_keepsMoving`, `run_yan`, `yan_line_iff_dependentChoice`, `yan_line_of_list` and `yan_pullback`. None clashes.

3. **Gap. "Faithful only with both classes, checked" was half checked.** The twist shows the same-move class is not enough. The reviewer checked the other half: flipping the move where the configuration is `true` carries `P₃` to `P₄`, keeps the same-configuration class, and no renaming relates them.

   **Taken.** The flip is in the check (`Flip.models_correspond`, `Flip.not_renamed`). The design says that up to correspondence neither class alone is enough. That both together suffice stays proposed.

4. **Gap. «迭» as the composite's case was claimed but not in the check.** Landing the composite beside «迭» with that theorem is the pattern board rule 9 forbids.

   **Taken.**
   - `wordRel_replicate` is in the check.
   - The composite's placement goes to `Becoming.GrammarLaws`' owner before WRP2 lands: either in GrammarLaws, with «迭» derived from it, or left out, with traces read through «迭» and their words forgotten.

5. **Wording. §2.1's added rows.** The seed–edge closure is a process notion, not a grammar term, and `goAlike_iff_constant` needs the process determined.

   **Taken.** The seed–edge closure has its own row, bridged by `withinClosure_iff_closure` (for `X : Type`). The going-alike row says what each lemma needs.

6. **Wording. The measure.**
   - The search is depth-first, not "breadth-first"; its result does not depend on order.
   - `GEN` kept 27 generated `brecOn` and `below` theorems, and two of its alternatives could never match.
   - Reading only projections lets 18 theorems that build or match the structures count as no-field.
   - "Naming a grammar term" misses readings named in English.

   **Taken.**
   - The wording is corrected.
   - `GEN` drops the recursion lemmas, and its dead alternatives are fixed. That moves the counts slightly: 11,409, 3,163, 1,306.
   - The 18 cases and the meaning of "naming a grammar term" are in the docstring and in §2.3.

7. **Wording. §5's tally.** The labels give seven errors, four gaps, four wordings and one naming.

   **Taken.**

8. **Wording. The infinite carrier.** A bijection `S ≅ S × A` exists only where `A` is not larger than `S`.

   **Taken.** "Where one exists" is added.

9. **Wording. Binding.** For the 322 statements binding only a frame, the law is of every family of relations with claims, and the lemma covers processes only. §2.2 omitted `Forgotten.moves_forgotten`.

   **Taken.** Both are corrected.

No third pass was made. Each of the nine is either a check the reviewer supplied, now built, or a correction of wording and figures that the rebuilt check and the rerun measure confirm.

## After the re-read

GrammarLaws' owner then decided where the composite along a word goes: in `Becoming.GrammarLaws`, with laws of `«迭»` derived from it where it carries them, and `«迭»`'s definition, statements and names unchanged.
- **The design's Part 1 follows.** The composite's laws and six cases of `«迭»` were checked in scratch: [scratch-11.log](check/scratch-11.log), 53 theorems in 66 declarations, every axiom report empty, no warning.
- **One more defect, found while checking.** Core's `List.reverse_cons` reports `propext`, so the reverse-cons step is proved in the check.
- **Not reviewed yet.** These 16 statements were not separately reviewed. The independent review of WRP2's Lean reads them before anything lands.

