# Second round: substance

30 October 2026. The second-round check of the revised kits (`kit/one_sense.py` and LW's `kit/upw_question.py`), the substance lens (one Opus reader, read-only), as returned. How each finding was taken is in [NOTE §5](../NOTE.md#5-the-second-round).

**Substance review of the rv21 one-sense revision and the restated universal-practical-warrant record (read-only)**

Ten findings survived my attempts to refute them against the files. The rest of the revision holds.
- The first sentence of the new 01 §4 paragraph follows from the Lean. Along a step with a fixed successor that every occurrence has, `«同行当且仅当有常»` makes constancy and going alike the same thing. `«根»` and `«核为类»` then make the core of a class the coarsest class inside it that goes alike.
- 06 §八 and the projection-carrying-a-law wording are correct. The second goes through `«像定后当且仅当同行»`.
- Formal 3 and 4, senses 6–9 and language 2–10 are taken correctly.
- Every link and anchor the revision adds resolves.
- Every new record field is within its cap in style.py.

**1. 01-ROOT.md §4, new paragraph (the most serious): the "Off such a step" sentence says more than the Lean, and the last sentence contradicts it**
- Words: "Off such a step the two are related only under the hypotheses of `«有常局定后则同行»` and `«同行可续则有常»`, so the core is shown to be a 理 only there. The names below that write 理 (…) are stated for the core of every relation, and mean a 理 only along such a step."
- The same claim is in NOTE §2: "That is a 理 only along such a step."
- Why it is wrong:
  - The two lemmas give sufficient conditions, not "only". Counterexample: let `E` be the one (everything related) under a step that branches but gives every occurrence a successor. Then the one is constant, it goes alike trivially (anything lies inside the one), and it is its own core and the coarsest class inside itself. Yet the fixedness hypothesis of `«有常局定后则同行»` fails.
  - "Mean a 理 only along such a step" is false by 01's own witness. The flame `f₀→f₁→f₂→ash` (01 §5) has a fixed step, and ash has no successor. The core of any class under it is constant (`«根»`), so it goes alike by `«有常定后则同行»`, which needs fixedness only. With `«核为类»` it is a 理.
  - This also contradicts the paragraph's own previous sentence, which says the core is shown a 理 under `«有常局定后则同行»`'s hypothesis.
  - `«同行可续则有常»` bears only on "coarsest", not on the core being a 理.
  - Formal 2's class condition was dropped. The core of a relation that is not a class need not be a class even along such a step: the empty relation's core is empty. Formal 2 is therefore only half taken.
- Fix: replace the last two sentences with:
  > Along a fixed step alone the core of a class still goes alike (`«有常定后则同行»`; the successor need be fixed only where the core leads, `«有常局定后则同行»`), so it is a 理; it is shown the coarsest only where a successor is also available as `«同行可续则有常»` asks. The names below that write 理 (`«守理则不穷»`, `«亡前理变»`, `«足以定理»`) are stated for the core of every relation; where the relation is a class and the step is fixed they name a 理, and along such a step its 理.
- In NOTE §2, change the same sentence to match.

**2. universal-practical-warrant.json, does_not_show[7] (written by upw_question.py `NEW_DNS8`): the non-entailment drops "satisfiable"**
- Words: "neither logic alone nor a statement reading only the represented dynamics entails the condition". The zh is 「单凭逻辑或只读所表示之动力学的陈述都不蕴含延续条件」.
- Why it is wrong:
  - `ReadsOnlyDynamics.not_entails` (Significance.lean:296) concludes `¬ law d sig`: a statement reading only the dynamics that entails the condition holds of no dynamics.
  - So an unsatisfiable statement, for example `fun _ _ => False`, reads only the dynamics and entails the condition vacuously. As written, the item is false.
  - T8, 07's open item and the kit's own new related entry all say "satisfiable". The formal lens's proposed text had it; the senses lens's text, which was adopted, dropped it.
  - The record's history therefore wrongly says the non-entailment is "stated exactly".
- Fix: en "…neither logic alone nor a satisfiable statement reading only the represented dynamics entails the condition; this does not show that no such warrant exists." This is 237 of 240 characters. zh 「…单凭逻辑或只读所表示之动力学的可满足陈述都不蕴含延续条件；…」

**3. standard-boundaries.json, `zero-axiom-target-open`: the new text is not true of every one of the 20 records citing it**
- Words: "Whether premise-free (zero-substantive-axiom) grounding exists is a separate open question; completed results on the conditional alignment route keep their scope."
- Why it is wrong:
  - (a) In the theory records the key stands for the zero-substantive-axiom foundation of Becoming, not for a normative warrant. Their pre-migration snapshots show it:
    - becoming-context-coherence (`_process/architecture/history/4fb6c5073a10192a/`): "not … ethical warrant or zero-substantive-axiom grounding", with the two listed apart.
    - relational-renewal-classification (`…/ec9fd5fb82637cc1/`): "or that the zero-substantive-axiom foundation of Becoming is complete".
    - endpoint-loss-and-return (`…/32ccdb09f6795566/`): "No … law origin or zero-substantive-axiom foundation is proved".
  - That foundation is still a target. `_process/goals/theory-of-becoming.json` says "Establish the deductive necessity of the Theory of Becoming as a whole without added substantive axioms" and "…establishes the stronger target". Three of these records are in that goal's result_ids. AGENTS.md also aims "toward one … zero-axiom theory".
  - The approval (2026-10-30-goal-practical-judgment-for-life-approved.md) turns only "a warrant binding every possible mind" into a question.
  - (b) On universal-practical-warrant itself the boundary now says the record's own question is "a separate open question".
- Fix:
  - en: "The zero-substantive-axiom foundation of the theory is a separate open target, and whether a warrant binding every possible mind exists a separate open question; completed results on the conditional alignment route keep their scope."
  - zh: 「本理论的零实质公理基础是另一开放目标，是否存在对一切可能心智都有约束力的根据是另一开放问题；条件对齐路线上已完成的成果保持原范围。」
  - Remove `zero-axiom-target-open` from universal-practical-warrant's standard_boundaries. Its related entry already says the question does not reopen the route.

**4. Several record laws still write the grammar's 生生 plain in their Chinese (senses 4 and 5 taken only in English)**
NOTE §1 says "Every other plain use in the live texts is the ethics' sense or a quotation". These are not, and each needs a wording-only history note:
- **continuation-relative-to-a-class**
  - laws[11].zh: 「生生是每一员皆复生至族中一员之最大之族，在此族中者不息（生生不息）。」 The kit changed only the en, but its history note says "the theorem's name written `«生生不息»`". Fix: 「`«生生»` 是…之最大之族，在此族中者不息（`«生生不息»`）。」
  - laws[7].zh: 「生生是最大之族…；生生必复生。」 Fix: write `«生生»` both times.
- **generation-and-degeneration-at-two-grains**, laws[7].zh: 「生生即某一支上之延，息即诸支皆尽。」 This is the sentence the kit marks in 06 §三. Fix: 「`«生生»` 即某一支上之延，`«息»` 即诸支皆尽。」
- **what-can-be-born-next** (`ordered_not_renews`, `antichainLimit_not_renews` and `chainLimit_renews` state `«生生»`, not `«生生不息»`):
  - laws[21].zh: 「无构型生生不息」. Fix: 「无构型 `«生生»`」.
  - laws[22].zh: 「任何类下皆无生生不息者」 and 「1 生生不息」. Fix: 「皆无 `«生生»` 者」 and 「1 `«生生»`」.
- **where-the-possible-grows**, laws[23].zh: 「相对于所持守者之增长与生生并存…每一偶数时刻皆生生，故时刻 0 不息（生生不息）」. This is the same `RaisedEveryOther` witness, with the same overclaim the kit fixed in COLLECTIVE-DIRECTION. Fix: 「…与无尽之复生并存…每一偶数时刻皆 `«生生»`，故时刻 0 不息（`«生生不息»`）」.

**5. "A step that is fixed and always continues" uses "continue" in a second sense**
- Where: 01 §4's new label "(root; a step that is fixed and always continues)", the glossary's 理 row "Along a step that is fixed and always continues", and NOTE §2 and §4.
- Why it is wrong:
  - GLOSSARY.md:12 defines continuation (续) as "a condition joined to sameness under a class". "Always continues" would read as every occurrence being continued under `E`.
  - The hypothesis is `∀ x, ∃ y, R x y`. The paragraph body says "always has a successor", and 01 §7 says "a successor everywhere and the successor fixed".
- Fix: write "a step with a successor everywhere and the successor fixed", or "(root; a fixed successor everywhere)", in all three places.

**6. 01 §4 new paragraph: the first sentence's wording**
- Words: "the core of a class is … the 理 of `E`". `E` is never bound in the paragraph.
- "Going alike" is used two sections before §7 defines it (the Lumping bullet). Language 1's link to §7 was not carried over.
- Fix: "the core of a class `E` …" and "going alike (`«同行»`, [§7](../../../../../../../theories/becoming/chapters/01-ROOT.md#r-master-laws-on-the-grammar))".

**7. 01 §4 new paragraph: the central claim is stated by no Lean declaration**
- "The core of a class is the coarsest class inside it that the step goes alike across" composes three declarations by hand. No declaration states it, and the review's Witness.lean does not check it.
- AGENTS.md says every new proof claim needs Lean and that hand arguments do not replace it.
- Fix: at GrammarLaws' next Lean change, through its owner, add a declaration and cite it. A possible statement: `«类» E → «定后» R → (∀ x, ∃ y, R x y) → «同行» R («核» R E) ∧ ∀ S, «类» S → «则» S E → «同行» R S → «则» S («核» R E)`. Until then, word the paragraph as following from the cited declarations.

**8. COLLECTIVE-DIRECTION.md: one citation does not contain the claim**
- Words: "renewal without end holds at every even moment, so moment `0` does not cease (`«生生»`, `«生生不息»`; `RaisedEveryOther.both`)".
- `both` (HeldPossible.lean:826) gives `«生生»` at moment 0 only. "At every even moment" is `RaisedEveryOther.renews_without_end` (line 794).
- Fix: cite both declarations.

**9. 08's words table and the new glossary row for 生生: "continuing generation" in the English gloss**
- Words in 08's "Not" column: "生生, life in the whole and its continuing generation (07)". The new glossary row has the same gloss.
- Here "generation" is not 02's 生成, which is the only sense 08's row gives the word. The Chinese editions now say 持续的生发 for exactly this reason, but the English keeps the second sense inside the row that declares one sense.
- Fix: in 08's row and the glossary's generation row, add "('continuing generation' in the gloss of 生生 is 生发, not this sense)".

**10. NOTE §4 says "Every finding was taken", but one item of senses 2 is untouched**
- conditional-foundation-assessment.json, related detail: "Conditional foundation completion does not finish the stronger axiom-free normative target."
- Senses 2 named this detail and the kit does not change it.
- Leaving it is right for a superseded record under RESULT-WORKFLOW's supersession rule. Fix: say so in NOTE §4.

Files read:
- /Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21-one-sense/review/combined-2.diff.txt
- /Users/ren/theories/_process/research/2026-10-05-generative-foundation-review/root-foundation/development/lw-the-way-for-life/kit/upw_question.py
- /Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarLaws.lean (lines 1295–1360)
- /Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Grammar.lean (lines 325–400 and 570–610)
- /Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Significance.lean (line 296)
- /Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HeldPossible.lean (lines 794 and 826)
- /Users/ren/theories/_process/goals/theory-of-becoming.json
- /Users/ren/theories/theories/becoming/results/data/standard-boundaries.json

*Links in the quoted passages, written for the pages they propose text for, were rebased to this folder on 30 October 2026, and placeholder links `(…)` made plain; the text is otherwise as returned.*
