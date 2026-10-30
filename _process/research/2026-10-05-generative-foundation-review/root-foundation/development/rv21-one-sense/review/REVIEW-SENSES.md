# Completeness of the one-sense fix and the question (review of the first draft, 30 October 2026)

One of three Opus lenses on the first drafts of kit/one_sense.py and lw-the-way-for-life/kit/upw_question.py ([combined.diff.txt](combined.diff.txt)); how each finding was taken is in [NOTE §4](../NOTE.md#4-the-review-and-how-each-finding-was-taken). The report as returned:

**Findings: completeness of the one-sense fix and consistency of the restated question**

Most important first. Every finding below was checked against the files; none is padding.

**1. The record's new statement says more than 07 §1, and differs from its home item**
- **File:** theories/becoming/results/records/universal-practical-warrant.json (written by upw_question.py, `NEW['statement']`).
- **Proposed words:** "Neither logic nor the represented dynamics gives the condition such a warrant; neither shows that none exists." In Chinese: 「单凭逻辑或单凭所表示的动力学，都不给出延续条件的这样的根据；二者也都不表明它不存在。」
- **Why it is wrong:**
  - It drops the qualifier "where there is a standpoint and a formation". Both 07 §1 (`ReadsOnlyDynamics.not_entails`) and T8 keep it. Without a standpoint or a formation, `Unrestricted` holds vacuously, so logic alone does give the condition.
  - T8 also says "with significance supplied as the free predicate". 07 §1 says its theorem "concerns the untied parameter".
  - The English drops "alone"; the Chinese keeps 单凭.
  - "Neither shows that none exists" now points at logic and the dynamics; the Chinese 二者 makes this explicit. 07 says only that its two results (the non-entailment and `bounded_rival`) do not show that no warrant exists. Nothing in 07 claims what logic itself cannot show.
  - The statement has three sentences, two of them negative. RESULT-WORKFLOW asks for one or two positive sentences.
  - It no longer matches the home item: 07 keeps "as one account of ends, selection, knowing and revision within becoming"; the record dropped it.
- **Fix:**
  - Statement (en): "Question: whether practical reasons have a warrant binding every possible mind, with zero substantive premises. It stays open, and the ethics, life's stance, does not wait on it." (178 characters)
  - Statement (zh): 「问题：实践理由是否有一个零实质前提、对一切可能的心智都有约束力的根据。它保持开放，伦理作为生命的立场不待其解决。」
  - Move the non-entailment to `does_not_show`, as kind non-implication. The record already holds the maximum 8 items, so it replaces item 8 (see finding 3). Text (en): "With significance a free predicate, where there is a standpoint and a formation, neither logic alone nor a statement reading only the represented dynamics entails the condition; this does not show that no such warrant exists." (225 characters, limit 240.) Text (zh): 「意义为自由谓词、有立场与形成之处，单凭逻辑或只读所表示之动力学的陈述都不蕴含延续条件；这不表明不存在这样的根据。」
  - In 07's open item (`NEW_07`), drop "as one account of ends, selection, knowing and revision within becoming". That is the old target's requirement on how an answer is built, and the goal and the record no longer carry it.
  - In 07's open item, change "neither shows that none exists" to "these do not show that none exists".

**2. "Target" framing left beside "not a goal"**
- **The record page itself:**
  - The record's kind stays "target", so the page header reads "**open** · target". RESULT-WORKFLOW defines `open` as "an unmet target".
  - The record keeps the shared boundary `zero-axiom-target-open`. Its text in theories/becoming/results/data/standard-boundaries.json reads "Premise-free (zero-substantive-axiom) grounding is a separate open target". That text renders on the record page (line 38), next to the new "It is open, not a goal".
  - The approval source (2026-10-30-goal-practical-judgment-for-life-approved.md) says: "Neither goal now pursues a warrant binding every possible mind as a target".
- **Other passages the kits left:**
  - theories/becoming/chapters/08-METHOD.md:682 still reads "**A stronger universal practical warrant**: grounding reasons without an externally supplied end". This is in the philosophical-warrant list, which LW edited, and it differs from 07's new title and gloss.
  - tools/research/navigation.py:333 writes into RESULTS.md: "The independent targets `universal-practical-warrant` and `wisdom-root` remain open."
  - Two other records' `related` details call it a target: conditional-foundation-assessment ("the stronger axiom-free normative target") and practical-judgment-under-living-significance ("The independent axiom-free target remains open"). Two more say "Advances without completing it": metaethical-core-characterization and own-good-to-reachable-living-significance.
- **Fix:**
  - Reword the shared boundary for all 20 records that carry it: "Whether premise-free (zero-substantive-axiom) grounding exists is a separate open question the work does not wait on; completed results on the conditional alignment route keep their scope."
  - Either add a kind `question` to `KINDS` in registry.py (an infrastructure change, so run research-test), or record in the record's history that "target" is kept only as the registry's kind for an open item.
  - Restate 08:682 as "**Whether a universal practical warrant exists**: a question, not a goal, which the ethics does not wait on ([07](../../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md#r-universal-practical-warrant), T8)."
  - Say "question" in navigation.py and in the two `related` details.

**3. Other fields of the record that the restatement should also have changed** (same file as finding 1)
- **`progress`:** its seven lines are the old target's work on practical judgment (response ground, purpose revision, fulfillment test). They render under "Progress" on a question they do not advance. The new `next_delta` itself calls practical judgment "the goal's work". Fix: add to `validation_scope` and the history entry: "The progress lines are the earlier target's work on practical judgment, now the goal's; none bears on whether a warrant binding every possible mind exists."
- **`does_not_show` item 8:** "The revised question is itself an inquiry…" now reads as the record's own question. It means the old fulfillment question. Fix: fold it into progress line 7's boundary and give its slot to the non-entailment item from finding 1.
- **`related`:**
  - It lacks `what-the-dynamics-leave-open`, the record that holds both `ReadsOnlyDynamics.not_entails` and `bounded_rival`, which the restated question rests on. Fix: add that entry.
  - The `open-form-realization-under-revision` detail says "missing mechanism for this target" (zh 本目标). Fix: say "question" (zh 本问题).
  - The `practical-judgment-under-living-significance` detail speaks of "a different completion standard", which a question does not have. Fix: reword it.
- **`next_delta`:** "a warrant … that says where it comes from beyond logic and the represented dynamics" assumes more than 07 shows. 07 says this only "where it would ground the condition". Fix: add "(for a warrant grounding the condition)".

**4. A remaining second sense: plain 生生不息 meaning the theorem**
- **File:** theories/becoming/COLLECTIVE-DIRECTION.md:102.
- **Current words:** "renewal without end holds from moment `0` (`RaisedEveryOther.both`): widening relative to what is held and 生生不息 can hold together."
- **Why it is wrong:** the evidence named is `«生生» … 0 ∧ ¬«息» … 0`, so 生生不息 here is the theorem `«生生不息»`. 07's home section writes it with guillemets ("(`«生生»`, `«生生不息»`; `RaisedEveryOther.both`)"). 07 D5 uses plain 生生不息 for 生生 going on with more still able to form, which the same reading says the held possible keeping widening can be. Read that way, this sentence would be close to circular. The note's claim that every other plain use is the ethics' sense or a quotation is therefore false here.
- **Fix:** "renewal without end holds of moment `0`, which so does not cease (`«生生»`, `«生生不息»`; `RaisedEveryOther.both`): widening relative to what is held and renewal without end can hold together."

**5. The same in a record law**
- **File:** theories/becoming/results/records/continuation-relative-to-a-class.json, law 12 (rendered at line 35 of its page).
- **Current words:** "Renewal without end, the greatest family each member of which renews into a member, does not cease (生生不息)."
- **Why it is wrong:** this is the formal theorem written plain.
- **Fix:** write `«生生不息»`, with a history note saying only the wording changed.

**6. A remaining second sense of 理 in 06 §八**
- **File:** theories/becoming/chapters/06-CLASSICAL-TEXTS.md:497. The kit changed line 477 but not this one.
- **Current words:** 「文同与理在根之文法中同为一个结构（值之类沿律之步的核）」
- **Why it is wrong:** it equates 理 in general with one particular core, the core of the value class. That is the very reading of 「只在此义」 the kit narrows at line 477. Under the decision, that core is the 理 of the value class, not 理 as such.
- **Fix:** 「文同与文之理（值之类之理）在根之文法中同为一个结构（值之类沿律之步的核）」

**7. A Lean name where 理 means "law", contrary to the note and the new glossary row**
- **Where:** `«从缘生非文法之理»` in Becoming/GrammarCandidates.lean:316, a pure-core theorem cited in theories/becoming/chapters/06-CLASSICAL-TEXTS.md:158 (「不是定理（`«从缘生非文法之理»`）」).
- **Why it is wrong:** its docstring says "both are conditions on a model, not laws", so 理 here means law. Two texts say otherwise:
  - The note, §3: "No Lean name: each already writes `«生生»` and reads 理 as a class's core."
  - The new glossary row: "the grammar's names that write 理 (…) mean [the core]".
- **Also:** `«亡前理变»` is stated "for every relation `E`", and 01's new sentence admits that for a relation that is not a class "the core … need not be a lumping". So the names mean a class's 理 only where `E` is a class.
- **Fix:**
  - Correct the note's sentence.
  - In the glossary row, write "the root's names on cores that write 理 (…) mean, for a class".
  - Rename the theorem to `«从缘生非文法之律»` at the core module's next Lean change, through its owner. Under AGENTS' naming rule, the name now states a sense the glossary excludes.

**8. 06 §十's parenthesis: the 生生 judgment is right, but the 不息 should be marked**
- **File:** theories/becoming/chapters/06-CLASSICAL-TEXTS.md:549.
- **Current words:** 「于是在脊柱上成为三种情形：无损之复返（有不息而无生生）」
- **Why it matters:** the 生生 there is the corpus sense, which matches the ethics' sense, so leaving it unmarked follows the decision. But the sentence says "on the spine". In 06 §三, plain 息 is the grammar's (「息是其归纳之对偶」), so the unmarked 不息 reads as a grammar claim. The note itself shows that claim is false there: a return that renews nothing ceases (`«自不复生则息»`).
- **Fix:** 「无损之复返（以语料之词，有不息而无生生，见下段）」

**9. A looser sense of 理 left in a record (minor)**
- **File:** theories/becoming/results/records/projection-carrying-a-law.json, correspondence field.
- **Current words:** "reading 理 as a projection (Becoming.Experiment), this says when 理 carries a law."
- **Why it is wrong:** this reads 理 as any projection. Under the new glossary, a 理 is a lumping the step goes alike across, so it always carries the law.
- **Fix:** "reading a model as a projection (Becoming.Experiment), this says when it is a 理, one the step goes alike across."

**Judgments confirmed, no change needed**
- 06 §五's 「生生之謂易」 row is in the ethics' sense. Change that loses possibility is set against widening, and in the grammar `«生生»` can hold while what can form only returns (01 D1). This matches C-13 and the twenty-first review's own reading.
- C-13 needs no change: its 「续而复生」 is 复生, not `«生生»`.
- T8 and the approved goal agree with the restated question. The only mismatches with 07 are the ones in finding 1.
- Every link the kits add resolves: `#renewal-and-grains`, `#constancy-and-core`, `#li` and `#theses`.
- The snapshot hash in the record diff matches the current record bytes.

*Links in the quoted passages, written for the pages they propose text for, were rebased to this folder on 30 October 2026, and placeholder links `(…)` made plain; the text is otherwise as returned.*
